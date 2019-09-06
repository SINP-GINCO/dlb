<?php

namespace Ign\Bundle\DlbBundle\Services;

use Doctrine\ORM\EntityManagerInterface ;

use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Services\GenericService;
use Ign\Bundle\DlbBundle\Services\QueryService;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Services\Ogr2ogr;

use Psr\Log\LoggerInterface;


/**
 * Description of AbstractDBBGenerator
 *
 * @author rpas
 */
abstract class AbstractDBBGenerator {
	
	
	/**
	 *
	 * @var EntityManagerInterface
	 */
	protected $em ;
	
	
	/**
	 *
	 * @var ConfigurationManager
	 */
	protected $configuration ;
	
	
	/**
	 *
	 * @var GenericService
	 */
	protected $genericService ;


	/**
	 *
	 * @var QueryService
	 */
	protected $queryService ;
	
	/**
	 *
	 * @var LoggerInterface
	 */
	protected $logger ;
	
	/**
	 *
	 * @var Ogr2ogr
	 */
	protected $ogr2ogr ;


	/**
	 * DBBGenerator constructor.
	 *
	 * @param
	 *        	$em
	 * @param
	 *        	$configuration
	 * @param
	 *        	$genericService
	 * @param
	 *        	$queryService
	 * @param
	 *        	$logger
	 */
	public function __construct($em, $configuration, $genericService, $queryService, $logger, $ogr2ogr) {
		$this->em = $em;
		$this->configuration = $configuration;
		$this->genericService = $genericService;
		$this->queryService = $queryService;
		$this->logger = $logger;
		$this->ogr2ogr = $ogr2ogr;
	}
	
	
	/**
	 * Génère la donnée brute.
	 */
	abstract public function generate(DEE $dee) ;
	
	
	
	public function generateFilePathDBB(Jdd $jdd, DEE $DEE) {
	
		$filePath = $this->configuration->getConfig('dbbPublicDirectory') . '/' . $jdd->getId();
		@mkdir($filePath); // create the jdd dir
		
		return $filePath ;
	}
	
	
	/**
	 * Create the filepath of the DBB csv file
	 * @param Jdd $jdd  
	 * @param DEE  $DEE  	
	 * @return string
	 */
	public function generateFileNameDBB(Jdd $jdd, DEE $DEE, $extra = null) {
		$regionCode = $this->configuration->getConfig('regionCode', 'REGION');
		
		$date = $DEE->getCreatedAt()->format('Y-m-d_H-i-s');
		
		$uuid = $jdd->getField('metadataId', $jdd->getId());
		
		$fileNameWithoutExtension = $regionCode . '_' . $date . '_' . $uuid;
		if ($extra) {
			$fileNameWithoutExtension .= '_' . $extra ;
		}
		$filePath = $this->generateFilePathDBB($jdd, $DEE) ;
		$filename = $fileNameWithoutExtension . '.csv';
		
		return $filePath . '/' . $filename;
	}
		
}
