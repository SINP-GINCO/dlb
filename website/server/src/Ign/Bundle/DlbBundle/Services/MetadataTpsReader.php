<?php
namespace Ign\Bundle\DlbBundle\Services;

use Ign\Bundle\GincoBundle\Exception\MetadataException;

/**
 * Class MetadataCAReader
 *
 * Get metadatas using tps_id in URL
 *
 * @author Amouget
 */
class MetadataTpsReader {

	/**
	 * The configuration manager service
	 *
	 * @var
	 *
	 */
	protected $configurationManager;

	/**
	 * The logger
	 *
	 * @var
	 *
	 */
	protected $logger;

	/**
	 * MailManager constructor.
	 *
	 * @param \Swift_Mailer $mailer        	
	 * @param \Twig_Environment $twig        	
	 * @param
	 *        	$logger
	 * @param
	 *        	$fromEmail
	 * @param
	 *        	$fromName
	 */
	public function __construct($configurationManager, $logger) {
		$this->configurationManager = $configurationManager;
		$this->logger = $logger;
	}

	/**
	 * Get the xml file, read it and return its content
	 *
	 * @param String $url        	
	 */
	public function getXmlFile($url) {
		
		// Try to download the XML file
		$ch = curl_init($url);
		
		// CURL options
		$verbose = fopen('php://temp', 'w+');
		$fileUrl = '/tmp/tempMetadata.xml';
		$file = fopen($fileUrl, 'w+');
		
		$curlOptions = array(
			CURLOPT_URL => $url,
			CURLOPT_SSL_VERIFYPEER => false,
			CURLOPT_FOLLOWLOCATION => true,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_CONNECTTIMEOUT => 2,
			CURLOPT_TIMEOUT => 4,
			CURLOPT_FILE => $file,
			CURLOPT_VERBOSE => true,
			CURLOPT_STDERR => $verbose
		);
		
		// Add proxy if needed
		$httpsProxy = $this->configurationManager->getConfig('https_proxy', '');
		if ($httpsProxy) {
			$curlOptions[CURLOPT_PROXY] = $httpsProxy;
		}
		
		curl_setopt_array($ch, $curlOptions);
		
		// Execute request
		curl_exec($ch);
		$httpCode = "" . curl_getinfo($ch, CURLINFO_HTTP_CODE);
		
		$this->logger->info("The HTTP code returned is " . $httpCode);
		
		// Close the cURL channel and file
		curl_close($ch);
		fclose($file);
		
		// HTTP code different from 200 means something is wrong
		if ($httpCode !== '200') {
			$this->logger->error("The download failed for metadata $url");
			rewind($verbose);
			$verboseLog = stream_get_contents($verbose);
			$this->logger->error(print_r($verboseLog, true));
			return null;
		}
		
		// Read the file, close it return its content
		$xml = file_get_contents($fileUrl);
		unlink($fileUrl);
		return $xml;
	}

	/**
	 * Get jddIds within the $tpsId (read jdds xml)
	 *
	 * @param unknown $tpsId        	
	 * @throws Exception
	 * @throws MetadataException
	 */
	public function getJddMetadatas($tpsId) {
		$this->logger->info('Getting XML metadata jdds file for id: ' . $tpsId);
		
		// Get the url of the metadata service
		// exemple: https://inpn2.mnhn.fr/mtd/cadre/jdd/export/xml/GetRecordsByTpsId?id=
		try {
			$metadataServiceUrl = $this->configurationManager->getConfig('jddMetadataFileDownloadServiceURL');
			$metadataJddFromTpsServiceUrl = str_replace("GetRecordById?", "GetRecordsByIdTps?", $metadataServiceUrl);
		} catch (\Exception $e) {
			$this->logger->error('No ca metadata file download service URL found: PLEASE FIX CONFIGURATION');
			throw $e;
		}
		
		// The XML metadata file url:
		$url = $metadataJddFromTpsServiceUrl . $tpsId;
		
		// Get the xml file with 0..* jdd from INPN website
		$jddFromTpsIdxmlStr = $this->getXmlFile($url);
		
		if ($jddFromTpsIdxmlStr == null) {
			// No xml file for this tps_id, pass value 'error'
			$fields['jddIds'][0] = 'error';
		} else {
			// Read and parse the file, to extract values in $fields
			$fields = array();
			
			try {
				$doc = new \DOMDocument();
				$doc->loadXML($jddFromTpsIdxmlStr);
				$xpath = new \DOMXpath($doc);
				
				$i = 0;
				$fields['jddIds'] = array();
				while (isset($xpath->query('//jdd:JeuDeDonnees/jdd:identifiantJdd')->item($i)->nodeValue)) {
					$jddId = $xpath->query('//jdd:JeuDeDonnees/jdd:identifiantJdd')->item($i)->nodeValue;
					$jddFormLabel = $xpath->query('//jdd:JeuDeDonnees/jdd:libelle')->item($i)->nodeValue . "|" . $jddId;
					$fields['jddIds'][$jddId] = $jddFormLabel;
					$i ++;
				}
			} catch (\Exception $e) {
				$this->logger->error("The jdd metadata XML file contains errors could not be parsed for $tpsId :" . $e->getMessage());
				throw new MetadataException('MetadataException.ParsingError');
			}
		}
		
		return $fields;
	}

	/**
	 * Get CA libelle from $tpsId (using CA metadata)
	 *
	 * @param unknown $tpsId        	
	 * @throws Exception
	 * @throws MetadataException
	 */
	public function getTpsMetadata($tpsId) {
		$this->logger->info('Getting XML metadata CA file for id: ' . $tpsId);
		
		// Get the url of the metadata service
		// exemple: https://inpn2.mnhn.fr/mtd/cadre/export/xml/GetRecordByIdTps?id=
		try {
			$metadataServiceUrl = $this->configurationManager->getConfig('jddMetadataFileDownloadServiceURL');
			$metadataTpsServiceUrl = str_replace("/cadre/jdd", "/cadre", $metadataServiceUrl);
			$metadataTpsServiceUrl = str_replace("GetRecordById?", "GetRecordByIdTps?", $metadataTpsServiceUrl);
		} catch (\Exception $e) {
			$this->logger->error('No ca metadata file download service URL found: PLEASE FIX CONFIGURATION');
			throw $e;
		}
		
		// The XML metadata file url:
		$url = $metadataTpsServiceUrl . $tpsId;
		
		// Get the xml CA file from INPN website
		$jddFromTpsIdxmlStr = $this->getXmlFile($url);
		
		// Read and parse the file, to extract values in $fields
		$fields = array();
		
		try {
			$doc = new \DOMDocument();
			$doc->loadXML($jddFromTpsIdxmlStr);
			$xpath = new \DOMXpath($doc);
			
			$libelleNodeList = $xpath->query('//ca:CadreAcquisition/ca:libelle') ;
			$descriptionNodeList = $xpath->query('//ca:CadreAcquisition/ca:description') ;
			$projetOwnerNodeList = $xpath->query('//ca:CadreAcquisition/ca:acteurAutre[ca:ActeurType/ca:roleActeur="3"]/ca:ActeurType/ca:organisme') ;
			$projetManagerNodeList = $xpath->query('//ca:CadreAcquisition/ca:acteurAutre[ca:ActeurType/ca:roleActeur="4"]/ca:ActeurType/ca:organisme') ;
			
			$fields['libelle'] = $libelleNodeList->length > 0 ? $libelleNodeList->item(0)->nodeValue : null ;
			$fields['description'] = $descriptionNodeList->length > 0 ? $descriptionNodeList->item(0)->nodeValue : null ;
			$fields['projetOwner'] = $projetOwnerNodeList->length > 0 ? $projetOwnerNodeList->item(0)->nodeValue : null ;
			$fields['projetManager'] = $projetManagerNodeList->length > 0 ? $projetManagerNodeList->item(0)->nodeValue : null ;

			$this->logger->debug('libelle : ' . $xpath->query('//ca:CadreAcquisition/ca:libelle')
				->item(0)->nodeValue);
		} catch (\Exception $e) {
			$this->logger->error("The jdd metadata XML file contains errors could not be parsed for $tpsId :" . $e->getMessage());
			throw new MetadataException('MetadataException.ParsingError');
		}
		
		return $fields;
	}

	/**
	 * Get tpsId from $caId (using CA metadata)
	 * 
	 * @param unknown $caId
	 * @throws Exception
	 * @throws MetadataException
	 */
	public function getTpsIdFromCaId($caId) {
		$this->logger->info('Getting XML metadata CA file for ca_id: ' . $caId);
		
		// Get the url of the metadata service
		// exemple: https://inpn2.mnhn.fr/mtd/cadre/export/xml/GetRecordById?id=
		try {
			$metadataServiceUrl = $this->configurationManager->getConfig('jddMetadataFileDownloadServiceURL');
			$metadataTpsServiceUrl = str_replace("/cadre/jdd", "/cadre", $metadataServiceUrl);
		} catch (\Exception $e) {
			$this->logger->error('No ca metadata file download service URL found: PLEASE FIX CONFIGURATION');
			throw $e;
		}
		
		// The XML metadata file url:
		$url = $metadataTpsServiceUrl . $caId;
		
		// Get the xml CA file from INPN website
		$caFromCaIdxmlStr = $this->getXmlFile($url);
		
		// Read and parse the file, to extract values in $fields
		$fields = array();
		
		try {
			$doc = new \DOMDocument();
			$doc->loadXML($caFromCaIdxmlStr);
			$xpath = new \DOMXpath($doc);
			
			$tpsIdNodeList = $xpath->query('//ca:CadreAcquisition/ca:idTPS') ;
			$descriptionNodeList = $xpath->query('//ca:CadreAcquisition/ca:description') ;
			$projetOwnerNodeList = $xpath->query('//ca:CadreAcquisition/ca:acteurAutre[ca:ActeurType/ca:roleActeur="3"]/ca:ActeurType/ca:organisme') ;
			$projetManagerNodeList = $xpath->query('//ca:CadreAcquisition/ca:acteurAutre[ca:ActeurType/ca:roleActeur="4"]/ca:ActeurType/ca:organisme') ;
			
			$fields['tpsId'] = $tpsIdNodeList->length > 0 ? $tpsIdNodeList->item(0)->nodeValue : null ;
			$fields['description'] = $descriptionNodeList->length > 0 ? $descriptionNodeList->item(0)->nodeValue : null ;
			$fields['projetOwner'] = $projetOwnerNodeList->length > 0 ? $projetOwnerNodeList->item(0)->nodeValue : null ;
			$fields['projetManager'] = $projetManagerNodeList->length > 0 ? $projetManagerNodeList->item(0)->nodeValue : null ;
			
			$this->logger->debug('idTPS : ' . $xpath->query('//ca:CadreAcquisition/ca:idTPS')
				->item(0)->nodeValue);
		} catch (\Exception $e) {
			$this->logger->error("The jdd metadata XML file contains errors could not be parsed for $metadataTpsServiceUrl :" . $e->getMessage());
			throw new MetadataException('MetadataException.ParsingError');
		}
		
		return $fields;
	}
}