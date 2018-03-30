<?php
namespace Ign\Bundle\DlbBundle\Services;

use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\GincoBundle\Exception\Exception;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
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
	 * Generate pdf certificate for dlb knpSnappyBundle
	 *
	 * @param Jdd $jdd        	
	 * @throws Exception
	 */
	public function generateCertificate(Jdd $jdd) {
		$filePath = $this->configuration->getConfig('dbbPublicDirectory') . '/'. $jdd->getId() . '/';
		$fileName = 'certificat-de-depot-legal-' . $jdd->getField('publishedAt') . '-' . $jdd->getField('metadataId') . '.pdf';
		
		// The certificate is generated only once
		if (!file_exists($fileName)) {
			// Get frame of aquisition metadata URL from jdd metadata URL
			$jddMetadataFileDownloadServiceURL = $this->configuration->getConfig('jddMetadataFileDownloadServiceURL');
			$jddCAMetadataFileDownloadServiceURL = str_replace("cadre/jdd", "cadre", $jddMetadataFileDownloadServiceURL);


			$html = $this->templating->render('IgnDlbBundle:Jdd:certificate_pdf.html.twig', array(
				'jdd' => $jdd,
				'jddCAMetadataFileDownloadServiceURL' => $jddCAMetadataFileDownloadServiceURL,
			));

			// Output the html (for debugging)
			// file_put_contents($filePath . "certificat" . date("H:i:s").  ".html", $html);

			try {
				$this->knp_snappy->generateFromHtml($html, $filePath . $fileName, array(
					'orientation' => 'Landscape'
				));
			}
			catch (\RuntimeException $e) {
				echo "Exception Snappy:\n";
				echo $e->getMessage();
				// On a real error, re-throw the exception
				// If just warnings, let it be
				if (strpos($e->getMessage(), 'Error:') !== false) {
					throw $e;
				}
			}

			$jdd->setField('certificateFilePath', $filePath . $fileName);
			$this->em->flush();
		}
		
		return $fileName;
	}
}