<?php

namespace Ign\Bundle\DlbBundle\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Input\InputArgument;

use Doctrine\ORM\EntityManagerInterface;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\DlbBundle\Services\DBBProcess;
use Ign\Bundle\GincoBundle\Entity\RawData\Submission;

/**
 * Description of DlbRegenerateCommand
 *
 * @author rpas
 */
class DlbRegenerateCommand extends Command {
	
	
	protected static $defaultName = 'dlb:regenerate' ;


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
			->setDescription('Régénère les fichiers de données brutes de biodiversité.')
			->addOption('jddId', 'j', InputOption::VALUE_OPTIONAL | InputOption::VALUE_IS_ARRAY, "Identifiant métadonnée du JDD à régénérer")
            ->addOption('file', 'f', InputOption::VALUE_OPTIONAL, "Fichier contenant une liste d'identifiants de métadonnées de JDD à régénérer")
		;
	}
	
	
	/**
	 * Recherche les DEE publiés, et relance le calcule des DEE et DBB.
	 * @param InputInterface $input
	 * @param OutputInterface $output
	 * @return int
	 */
	public function execute(InputInterface $input, OutputInterface $output) {
		
        if (!$input->hasOption('jddId') && !$input->hasOption('file')) {
            $output->writeln("<error>Aucun identifiant de jeu de données n'a été fourni.</error>") ;
			return 1 ;
        }
        
        $jddIds = array() ;
        if ($input->hasOption('jddId')) {
            $jddIds = $input->getOption('jddId') ;
        }
        
        if ($input->hasOption('file')) {
            $filepath = $input->getOption('file') ;
            if (!empty($filepath)) {
                $file = new \SplFileObject($filepath, "r") ;
                $jddIds = array_merge($jddIds, $this->readJddIdFromFile($file)) ;
            }
        }
		
        $jddRepository = $this->entityManager->getRepository('IgnGincoBundle:RawData\Jdd') ;
        $deeRepository = $this->entityManager->getRepository('IgnGincoBundle:RawData\DEE') ;
        
        foreach ($jddIds as $jddId) {
            
            $output->writeln("<info>### Régénération du Jdd $jddId :</info>") ;
            $output->writeln("");
            
            $jdd = $jddRepository->findOneByMetadataId($jddId) ;
            
            if (!$jdd) {
                $output->writeln("<error>Jdd $jddId non trouvé.</error>") ;
                continue ;
            }
            
            if (!$jdd->isActive()) {
                $output->writeln("<info>Jdd $jddId a été supprimé.</info>") ;
                continue ;
            }
            
            $dee = $deeRepository->findLastVersionByJdd($jdd) ;
            if (!$dee) {
                $output->writeln("<info>Pas de DEE trouvée pour le Jdd $jddId.</info>") ;
                continue ;
            }
            
            $this->dbbProcess->unfreezeJdd($jdd) ;
            $this->dbbProcess->generateAndSendDBB($dee, false) ;
        }

	}
    
    
    /**
     * Lit les identifiants contenus dans un fichier et les renvoie sous forme de tableau.
     * @param \SplFileObject $file
     * @return array
     */
    private function readJddIdFromFile(\SplFileObject $file) {
         
        $jddIds = array() ;
        while (!$file->eof()) {
            $row = trim($file->fgets()) ;
            if (empty($row)) {
                continue ;
            }
           $jddIds[] = $row ; 
        }
         
        return $jddIds ;
    }
}
