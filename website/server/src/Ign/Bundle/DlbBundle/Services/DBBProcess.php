<?php
namespace Ign\Bundle\DlbBundle\Services;

use Symfony\Bridge\Monolog\Logger;
use Symfony\Bundle\FrameworkBundle\Routing\Router;

use Doctrine\ORM\EntityManager;

use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
use Ign\Bundle\GincoBundle\Services\MailManager;
use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\DlbBundle\Services\AbstractDBBGenerator;
use Ign\Bundle\GincoBundle\Entity\Metadata\Standard;



/**
 * Class DBBProcess
 * Responsible of the whole process of the DEE generation and sending:
 *
 * - Publish data
 * - create file name
 * - generate DEE gml file
 * - generate DBB CSV file
 * - generate certificate
 * - get metadatas
 * - create zip archive
 * - send email to the user
 * - send email to the MNHN
 *
 * @package Ign\Bundle\DlbBundle\Services
 *         
 * @author AMouget
 */
class DBBProcess {

	/**
	 *
	 * @var EntityManager
	 */
	protected $em;

	/**
	 *
	 * @var ConfigurationManager
	 */
	protected $configuration;

	/**
	 *
	 * @var MailManager
	 */
	protected $mailManager;

	/**
	 *
	 * @var Router
	 */
	protected $router;

	/**
	 *
	 * @var Logger
	 */
	protected $logger;
	
	/**
	 *
	 * @var AbstractDBBGenerator
	 */
	protected $dbbGenerator ;

	/**
	 * DEEProcess constructor.
	 *
	 * @param
	 *        	$em
	 * @param
	 *        	$configuration
	 * @param
	 *        	$mailManager
	 * @param
	 *        	$logger
	 */
	public function __construct(
			$em, 
			$configuration, 
			$integration, 
			$DEEProcess, 
			$DBBGeneratorOcctax,
			$DBBGeneratorHabitat,
			$CertificateGenerator, 
			$MetadataDownloader, 
			$mailManager, 
			$router, 
			$logger) 
	{
		$this->em = $em;
		$this->configuration = $configuration;
		$this->integration = $integration;
		$this->DEEProcess = $DEEProcess;
		$this->DBBGeneratorOcctax = $DBBGeneratorOcctax;
		$this->DBBGeneratorHabitat = $DBBGeneratorHabitat;
		$this->CertificateGenerator = $CertificateGenerator;
		$this->MetadataDownloader = $MetadataDownloader;
		$this->mailManager = $mailManager;
		$this->router = $router;
		$this->logger = $logger;
	}

	/**
	 * Whole process for generating the DBB and sending notifications to MNHN and INPN
	 *
	 * @param
	 *        	$DEEId
	 * @param null $messageId        	
	 */
	public function generateAndSendDBB(DEE $dee, $sendMail = true) {
		
		$message = $dee->getMessage() ;
		$messageId = $message ? $message->getId() : null ;
		$this->logger->info("GenerateAndSendDBB: dee_id = {$dee->getId()}, message_id = $messageId");
		
		$jdd = $dee->getJdd();

		try {
		
			$this->generateAndSendDee($dee, $message) ;

			// Generate DBB files
			$files = $this->getDbbGenerator($dee)->generate($dee);

			// Save metadatas
			$this->downloadMetadata($dee) ;

			// Generate Certificate 
			$this->CertificateGenerator->generateCertificate($jdd);

			// Create archive and delete useless csv file.
			$this->createDBBArchive($dee, $files) ;
			foreach ($files as $file) {
				@unlink($file);
			}

			/* Send mail to user */
			if ($sendMail) {
				$this->sendDBBNotificationMail($dee);
			}

			// Add publication informations
			$jdd->setField('status', 'published');
			$this->em->flush() ;
		
			
		} catch (\Exception $e) {
			
			$this->logger->error($e->getMessage()) ;
			$message->setStatus(Message::STATUS_ERROR) ;
			$jdd->setField('status', 'error') ;
			$this->em->flush() ;
		}
	}
	
    
    /**
     * Retourne un DBB generator adapté au standard du jeu de données.
     * @param DEE $dee
     * @return AbstractDBBGenerator
     */
    public function getDbbGenerator(DEE $dee) : AbstractDBBGenerator {
        
        $jdd = $dee->getJdd() ;
        $standardType = $jdd->getModel()->getStandard()->getName() ;
        $dbbGenerator = null ;
		if (Standard::STANDARD_HABITAT == $standardType) {
			$dbbGenerator = $this->DBBGeneratorHabitat ;
		} else {
			$dbbGenerator = $this->DBBGeneratorOcctax ;
		}
        
        return $dbbGenerator ;
    }
    
    
	
	/**
	 * Publie les soumissions associées au JDD, génère la DEE et envoie la notification au MNHN
	 * @param DEE $dee
	 * @throws \Exception
	 */
	private function generateAndSendDee(DEE $dee, Message $message = null) {
		
		$messageId = $message ? $message->getId() : null ;
		
		$this->logger->info("GenerateAndSendDEE: dee_id = {$dee->getId()}, message_id = $messageId");

		$jdd = $dee->getJdd();

		// Get submissions successful in the jdd and publish them
		$submissions = $jdd->getSuccessfulSubmissions();
		foreach ($submissions as $submission) {
			try {
				$this->integration->validateDataSubmission($submission);
			} catch (\Exception $e) {
				throw new \Exception("Error during upload: " . $e->getMessage());
			}
		}

		// Generate DEE and send notification email to MNHN only
		$this->DEEProcess->generateAndSendDEE($dee->getId(), $messageId, false);
	}
	
	
	/**
	 * Télécharge les fichiers de métadonnées et les stocke.
	 * @param DEE $dee
	 */
	private function downloadMetadata(DEE $dee) {
		
		$jdd = $dee->getJdd() ;
		
		// Get metadatas
		$dbbPublicDirectory = $this->configuration->getConfig('dbbPublicDirectory');
		$metadataId = $jdd->getField('metadataId');
		$metadataCAId = $jdd->getField('metadataCAId');

		$jddMetadataFileDownloadURL = $this->configuration->getConfig('jddMetadataFileDownloadServiceURL');
		$jddCAMetadataFileDownloadURL = str_replace("cadre/jdd", "cadre", $jddMetadataFileDownloadURL);

		$jddMetadataFile = $jddMetadataFileDownloadURL . $metadataId;
		$caMetadataFile = $jddCAMetadataFileDownloadURL . $metadataCAId;

		$this->MetadataDownloader->saveXmlFile($jddMetadataFile, $dbbPublicDirectory . '/' . $jdd->getId() . '/' . $metadataId);
		$this->MetadataDownloader->saveXmlFile($caMetadataFile, $dbbPublicDirectory . '/' . $jdd->getId() . '/' . $metadataCAId);
	}
	
	
	/**
	 * Crée une archive zip avec la DBB, les métadonnées (CA et JDD), et le certificat de dépot.
	 * @param DEE $dee
	 * @param type $csvFile
	 * @throws \Exception
	 */
	public function createDBBArchive(DEE $dee, $csvFiles) {
		
		$jdd = $dee->getJdd() ;
		
		$certificateFile = basename($jdd->getField('certificateFilePath')) ;
		$metadataId = $jdd->getField('metadataId') ;
		$metadataCAId = $jdd->getField('metadataCAId') ;
		
		// Zip files
		$fileNameDBB = $this->getDbbGenerator($dee)->generateFileNameDBB($jdd, $dee);
		$parentDir = dirname($fileNameDBB); // dbbPublicDirectory
		$archiveName = $parentDir . '/dlb_' . basename($fileNameDBB, '.csv') . '.zip';
		try {
			chdir($parentDir);
			$allFiles = implode(" ", $csvFiles) ;
			system("zip -r $archiveName $allFiles $certificateFile $metadataCAId $metadataId");
		} catch (\Exception $e) {
			throw new \Exception("Could not create archive $archiveName:" . $e->getMessage());
		}
		
		$jdd->setField('dbbZipFilePath', $archiveName);
		$this->em->flush() ;
	}
	
	

	/**
	 * Send notification email after creation of the DBB archive:
	 * to the user who created the DBB
	 *
	 * @param DEE $DEE the DEE object
	 * @param $submissions
	 */
	private function sendDBBNotificationMail(DEE $DEE) {
		
		$jdd = $DEE->getJdd();
		$submissions = $DEE->getJdd()->getSuccessfulSubmissions() ;
		$user = $DEE->getUser();
		
		$submissionFilesNames = array();
		foreach ($submissions as $submission) {
			foreach ($submission->getFiles() as $file) {
				$this->logger->debug('fileName : ' . $file->getFileName());
				$submissionFilesNames[] = $file->getFileName();
			}
		}
		$fileNames = array_map("basename", $submissionFilesNames);
		
		$this->logger->debug('filName : ' . implode(', ', $fileNames));

		$siteUrl = $this->configuration->getConfig('site_url');
		$domain = parse_url($siteUrl, PHP_URL_SCHEME) . '://' . parse_url($siteUrl, PHP_URL_HOST);
		$parameters = array(
			'filename' => implode(', ', $fileNames),
			'jdd' => $jdd,
			'pubTpsUrl' => $domain . $this->router->generate(
				'published_jdds_by_tps',
				[ 'tpsId' => $jdd->getField('tpsId') ]
			)
		);
		
		// Send mail notification to user
		$this->mailManager->sendEmail('IgnDlbBundle:Emails:DBB-notification-to-user.html.twig', $parameters, $user->getEmail());
	}


	/**
	 * Unpublish the JDD, ie reverse all steps done during generateAndSendDBB
	 * This functionnality is normally reserved to developpers
	 *
	 * @param Jdd $jdd
	 */
	public function unpublishJdd(Jdd $jdd) {
		if ($jdd->hasField('status') && $jdd->getField('status') == 'published') {

			$this->unfreezeJdd($jdd) ;

			// Delete DEE (in table, and file)
			$deeRepo = $this->em->getRepository('IgnGincoBundle:RawData\DEE');
			$lastDEE = $deeRepo->findLastVersionByJdd($jdd);
			$this->DEEProcess->deleteDEELineAndFiles($lastDEE->getId());
		}
	}
    
    /**
     * Unfreeze jdd, ie remove status field and invalidate submissions, so DEE can be re-calculated without changing the date of the certicate.
     * @param Jdd $jdd
     */
    public function unfreezeJdd(Jdd $jdd) {
        
        // Delete files created for DBB process
        @unlink($jdd->getField('dbbZipFilePath'));
        @unlink($jdd->getField('certificateFilePath'));
        @unlink($jdd->getField('dbbFilePath'));

        // Delete Jdd Fields created in the process of publication
        $jdd->removeField('status');
        $jdd->removeField('dbbZipFilePath');
        $jdd->removeField('certificateFilePath');
        $jdd->removeField('dbbFilePath');

        $this->em->persist($jdd);
        $this->em->flush();

        // Unpublish all submissions for this jdd
        $submissions = $jdd->getValidatedSubmissions();
        foreach ($submissions as $submission) {
            $this->integration->invalidateDataSubmission($submission);
        }
    }

	
}