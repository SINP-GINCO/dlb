<?php

namespace Ign\Bundle\DlbBundle\Services;

use Monolog\Logger;

use Doctrine\ORM\EntityManager;

use Ign\Bundle\GincoBundle\Services\JddService as BaseJddService;

use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Services\Integration;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
use Ign\Bundle\GincoBundle\Services\MetadataReader;
use Ign\Bundle\DlbBundle\Services\MetadataTpsReader;

/**
 * Description of JddManager
 *
 * @author rpas
 */
class JddService  extends BaseJddService {
	
	/**
	 *
	 * @var MetadataTpsReader
	 */
	protected $metadataTpsReader ;

	/**
	 *
	 * @var translator
	 */
	protected $translator;

	function __construct(
		Logger $logger, 
		ConfigurationManager $configuration, 
		EntityManager $entityManager, 
		Integration $integrationService,
		MetadataReader $metadataReader,
		MetadataTpsReader $metadataTpsReader
	) {
		
		parent::__construct($logger, $configuration, $entityManager, $integrationService, $metadataReader) ;
		$this->metadataTpsReader = $metadataTpsReader ;
	}
	

	/**
	 * Met à jour les métadonnées du JDD en ajoutant celle du cadre d'acquisition (pour DLB).
	 * Surcharge de ginco.jdd_service.
	 * @param Jdd $jdd
	 * @return type
	 */
	public function updateMetadataFields(Jdd $jdd) {
		
		parent::updateMetadataFields($jdd);
		
		$metadataCAId = $jdd->getField('metadataCAId') ;
		if (!$metadataCAId) {
			return ;
		}
		
		$fields = $this->metadataTpsReader->getTpsIdFromCaId($metadataCAId) ;
		foreach ($fields as $key => $value) {
			$jdd->setField($key, $value) ;
		}
		
		$this->entityManager->flush() ;
	}
}
