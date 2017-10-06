<?php
namespace Ign\Bundle\DlbBundle\Services;

use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Ign\Bundle\OGAMBundle\Services\ConfigurationManager;
use Symfony\Bridge\Monolog\Logger;

/**
 * Class DBBGenerator
 * Responsible of the export of the DBB
 *
 * @package Ign\Bundle\DlbBundle\Services
 */
class CertificateGenerator {

	/**
	 * CertificateGenerator constructor
	 *
	 * @param
	 *        	$em
	 * @param
	 *        	$configuration
	 * @param
	 *        	$templating
	 * @param
	 *        	$knpSnappy
	 * @param
	 *        	$logger
	 */
	public function __construct($em, $configuration, $templating, $knpSnappy, $logger) {
		$this->em = $em;
		$this->configuration = $configuration;
		$this->templating = $templating;
		$this->knp_snappy = $knpSnappy;
		$this->logger = $logger;
	}

	/**
	 *
	 * @param Jdd $jdd        	
	 * @throws Exception
	 */
	public function generateCertificate(Jdd $jdd) {
		$filePath = $this->configuration->getConfig('dbbPublicDirectory') . '/';
		$filename = 'certificat-de-depot-legal-' . $jdd->getField('metadataId') . '.pdf';
		
		// The cerificate is generated only once
		if (file_exists($filename)) {
			throw new Exception("Error: le fichier: $fileName existe déjà.");
		} else {
			// Get frame of aquisition metadata URL from jdd metadata URL
			$jddMetadataFileDownloadServiceURL = $this->configuration->getConfig('jddMetadataFileDownloadServiceURL');
			$jddCAMetadataFileDownloadServiceURL = str_replace("cadre/jdd", "cadre", $jddMetadataFileDownloadServiceURL);
			
			$this->knp_snappy->generateFromHtml($this->templating->render('IgnDlbBundle:Jdd:certificate_pdf.html.twig', array(
				'jdd' => $jdd,
				'jddCAMetadataFileDownloadServiceURL' => $jddCAMetadataFileDownloadServiceURL
			)), $filePath . $filename);
			
			$jdd->setField('certificateFilePath', $filePath . $filename);
			$this->em->flush();
		}
	}
}