<?php
namespace Ign\Bundle\DlbBundle\Services;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Ign\Bundle\OGAMBundle\Entity\Website\User;
use Ign\Bundle\OGAMBundle\Services\ConfigurationManager;
use Ign\Bundle\OGAMBundle\Services\MailManager;
use Symfony\Bridge\Monolog\Logger;

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
	 * @var DEEGenerator
	 */
	protected $DEEGenerator;

	/**
	 *
	 * @var MailManager
	 */
	protected $mailManager;

	/**
	 *
	 * @var Logger
	 */
	protected $logger;

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
	public function __construct($em, $configuration, $integration, $DEEProcess, $DEEGenerator, $DBBGenerator, $CertificateGenerator, $MetadataDownloader, $mailManager, $logger) {
		$this->em = $em;
		$this->configuration = $configuration;
		$this->integration = $integration;
		$this->DEEProcess = $DEEProcess;
		$this->DEEGenerator = $DEEGenerator;
		$this->DBBGenerator = $DBBGenerator;
		$this->CertificateGenerator = $CertificateGenerator;
		$this->MetadataDownloader = $MetadataDownloader;
		$this->mailManager = $mailManager;
		$this->logger = $logger;
	}

	/**
	 * Whole process for generating the DBB and sending notifications to MNHN and INPN
	 *
	 * @param
	 *        	$DEEId
	 * @param null $messageId        	
	 */
	public function generateAndSendDBB($DEEId, $messageId = null) {
		$this->logger->info("GenerateAndSendDBB: " . implode(',', func_get_args()));
		
		// Get all objects and variables
		$DEE = $this->em->getRepository('IgnGincoBundle:RawData\DEE')->findOneById($DEEId);
		$jdd = $DEE->getJdd();
		
		if ($DEE) {
			// RabbitMQ Message if given
			$message = ($messageId) ? $this->em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId) : null;
			
			/* Publish valid submissions */
			
			// Get submissions successful in the jdd
			$submissions = $jdd->getSuccessfulSubmissions();
			$submissionsIds = array();
			
			foreach ($submissions as $submission) {
				$submissionsIds[] = $submission->getId();
				try {
					$this->integration->validateDataSubmission($submission->getId());
				} catch (\Exception $e) {
					throw new \Exception("Error during upload: " . $e->getMessage());
				}
			}
			
			// Add submissions in dee table as they are validated now
			$DEE->setSubmissions($submissionsIds);
			$this->em->flush();
		
			/* Generate DEE and send notification email to MNHN only */
			$this->DEEProcess->generateAndSendDEE($DEEId, $messageId, false);
			
			/* Generate DBB CSV */
			$csvFile = $this->DBBGenerator->generateDBB($DEE);
			
			/* Get metadatas */
			$dbbPublicDirectory = $this->configuration->getConfig('dbbPublicDirectory');
			$metadataId = $jdd->getField('metadataId');
			$metadataCAId = $jdd->getField('metadataCAId');
			
			$jddMetadataFileDownloadURL = $this->configuration->getConfig('jddMetadataFileDownloadServiceURL');
			$jddCAMetadataFileDownloadURL = str_replace("cadre/jdd", "cadre", $jddMetadataFileDownloadURL);
			
			$jddMetadataFile = $jddMetadataFileDownloadURL . $metadataId;
			$caMetadataFile = $jddCAMetadataFileDownloadURL . $metadataCAId;
			
			$this->MetadataDownloader->saveXmlFile($jddMetadataFile, $dbbPublicDirectory . '/' . $jdd->getId() . '/' . $metadataId);
			$this->MetadataDownloader->saveXmlFile($caMetadataFile, $dbbPublicDirectory . '/' . $jdd->getId() . '/' . $metadataCAId);
			
			/* Generate Certificate */
			$certificateFile = $this->CertificateGenerator->generateCertificate($jdd);
			
			/* Zip files */
			$fileNameDBB = $this->DBBGenerator->generateFilePathDBB($jdd);
			$parentDir = dirname($fileNameDBB); // dbbPublicDirectory
			$archiveName = $parentDir . '/dlb_' . basename($fileNameDBB, '.csv') . '.zip';
			try {
				chdir($parentDir);
				system("zip -r $archiveName $csvFile $certificateFile $metadataCAId $metadataId");
			} catch (\Exception $e) {
				throw new \Exception("Could not create archive $archiveName:" . $e->getMessage());
			}
			
			// Delete csv file
			@unlink($csvFile);
			
			/* Send mail to user */
			$this->sendDBBNotificationMail($DEE, $submissions);
			
			/* Send mail to MNHN */
			$this->DEEProcess->sendDEENotificationMail($DEE, false);

			/* Add publication informations */
			$now = new \DateTime();
			$jdd->setField('publishedAt', $now->format('Y-m-d_H-i-s'));
			$jdd->setField('dbbZipFilePath', $archiveName);
			$jdd->setField('status', 'published');
			$this->em->flush();
		}
	}

	/**
	 * Send notification email after creation of the DBB archive:
	 * to the user who created the DBB
	 *
	 * @param DEE $DEE the DEE object
	 * @param $submissions
	 */
	public function sendDBBNotificationMail(DEE $DEE, $submissions) {
		$jdd = $DEE->getJdd();
		$user = $DEE->getUser();
		
		$submissionFilesNames = array();
		$submissionRepo = $this->em->getRepository('OGAMBundle:RawData\Submission');
		foreach ($submissions as $submission) {
			foreach ($submission->getFiles() as $file) {
				$this->logger->debug('fileName : ' . $file->getFileName());
				$submissionFilesNames[] = $file->getFileName();
			}
		}
		$fileNames = array_map("basename", $submissionFilesNames);
		
		$this->logger->debug('filName : ' . implode(', ', $fileNames));
		$parameters = array(
			'filename' => implode(', ', $fileNames),
			'jdd' => $jdd
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

			// Delete files created for DBB process
			@unlink($jdd->getField('dbbZipFilePath'));
			@unlink($jdd->getField('certificateFilePath'));
			@unlink($jdd->getField('dbbFilePath'));

			// Delete Jdd Fields created in the process of publication
			$jdd->removeField('status');
			$jdd->removeField('publishedAt');
			$jdd->removeField('dbbZipFilePath');
			$jdd->removeField('certificateFilePath');
			$jdd->removeField('dbbFilePath');

			$this->em->persist($jdd);
			$this->em->flush();

			// Delete DEE (in table, and file)
			$deeRepo = $this->em->getRepository('IgnGincoBundle:RawData\DEE');
			$lastDEE = $deeRepo->findLastVersionByJdd($jdd);
			$this->DEEProcess->deleteDEELineAndFiles($lastDEE->getId());

			// Unpublish all submissions for this jdd
			$submissions = $jdd->getValidatedSubmissions();
			foreach ($submissions as $submission) {
				$this->integration->invalidateDataSubmission($submission->getId());
			}
		}
	}
}