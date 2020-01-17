<?php

namespace Ign\Bundle\DlbBundle\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\InputArgument;

use Doctrine\ORM\EntityManagerInterface;

use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\DlbBundle\Services\DBBProcess ;

/**
 * Description of DlbRegenerateCommand
 *
 * @author rpas
 */
class DlbUnfreezeCommand extends Command {
	
	
	protected static $defaultName = 'dlb:unfreeze' ;


	/**
	 *
	 * @var EntityManagerInterface
	 */
	private $entityManager ;
    
    /**
     *
     * @var DBBProcess
     */
    private $dbbProcess ;

	
	/**
	 * 
	 * @param EntityManager $entityManager
	 * @param DBBProcess $dbbProcess
	 */
	public function __construct(EntityManagerInterface $entityManager, DBBProcess $dbbProcess) {
		
		$this->entityManager = $entityManager ;
        $this->dbbProcess = $dbbProcess ;
		parent::__construct();
	}
	
	
	/**
	 * 
	 */
	public function configure() {
		$this
			->setDescription('Débloque un dépôt de jeu de données')
			->addArgument('metadataId', InputArgument::REQUIRED, 'Identifiant de la métadonnée du JDD') ;
		;
	}
	
	
	/**
	 *
	 * @param InputInterface $input
	 * @param OutputInterface $output
	 * @return int
	 */
	public function execute(InputInterface $input, OutputInterface $output) {
	
        $metadataId = $input->getArgument('metadataId') ;
        $jddRepository = $this->entityManager->getRepository('IgnGincoBundle:RawData\Jdd') ;
        /* @var $jdd Jdd */
        $jdd = $jddRepository->findOneByMetadataId($metadataId) ;
        
        if (!$jdd) {
            $output->writeln("<error>Jeu de données non trouvé.</error>") ;
            return 1 ;
        }
        
        $this->dbbProcess->unfreezeJdd($jdd) ;
        $output->writeln("<info>Jeu de données débloqué.</info>") ;
	}
	
}
