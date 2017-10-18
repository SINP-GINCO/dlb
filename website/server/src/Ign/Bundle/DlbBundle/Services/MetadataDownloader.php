<?php

namespace Ign\Bundle\DlbBundle\Services;
use Ign\Bundle\GincoBundle\Exception\MetadataException;

/**
 * Class MetadataService
 *
 * Save metadata locally
 *
 * @author AMouget
 */
class MetadataDownloader
{
	/**
	 * The configuration manager service
	 * @var
	 */
    protected $configurationManager;

	/**
	 * The logger
	 * @var
	 */
	protected $logger;

    /**
     * MailManager constructor.
     * @param \Swift_Mailer $mailer
     * @param \Twig_Environment $twig
     * @param  $logger
     * @param $fromEmail
     * @param $fromName
     */
    public function __construct($configurationManager, $logger)
    {
        $this->configurationManager = $configurationManager;
		$this->logger = $logger;
    }


    public function saveXmlFile($metadataFilePath, $toSaveFilePath)
	{
		$this->logger->info('Getting XML metadata file for id: ' . $metadataFilePath);
		$this->logger->info('Saving XML metadata file to: ' . $toSaveFilePath);

		// The XML metadata file url:
		$url = $metadataFilePath;

		// Try to download the XML file
		$ch = curl_init($url);

		// CURL options
		$verbose = fopen('php://temp', 'w+');
		$fileUrl = $toSaveFilePath;
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
		// Let time to download the file (direct generation)
		sleep(3);

		// HTTP code different from 200 means something is wrong
		if ($httpCode !== '200') {
			$this->logger->error("The download failed for metadata $metadataFilePath");
			rewind($verbose);
			$verboseLog = stream_get_contents($verbose);
			$this->logger->error(print_r($verboseLog, true));
			throw new MetadataException('MetadataException.FailedDownload');
		}
	}
}