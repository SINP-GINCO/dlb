<?php

namespace Ign\Bundle\DlbBundle\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\InputOption;

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
	
	
	protected static $defaultName = 'dlb:regenerate:dbb' ;


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
			->addOption('start', null, InputOption::VALUE_REQUIRED, 'Date de début au format YYYY-MM-DD.')
			->addOption('end', null, InputOption::VALUE_REQUIRED, 'Date de fin au format YYYY-MM-DD.')
		;
	}
	
	
	/**
	 * Recherche les DEE publiés, et relance le calcule des DEE et DBB.
	 * @param InputInterface $input
	 * @param OutputInterface $output
	 * @return int
	 */
	public function execute(InputInterface $input, OutputInterface $output) {
		
		$start = null ;
		$end = null ;
		
		// Parse start date.
		if ($input->hasOption('start')) {
			$start = \DateTime::createFromFormat('Y-m-d', $input->getOption('start')) ;
			if (!$start) {
				$start = null ;
			}
		}
		
		// Parse end date.
		if ($input->hasOption('end')) {
			$end = \DateTime::createFromFormat('Y-m-d', $input->getOption('end')) ;
			if (!$end) {
				$end = null ;
			}
		}
		
		// Si aucune date fournie, on ne fait rien.
		if (!$start && !$end) {
			$output->writeln("<error>Aucune date de début ou de fin fournie.</error>") ;
			return 1 ;
		}
		
		$dees = $this->findPublishedDees($start, $end) ;
		$numDees = count($dees) ;
		
		$output->writeln("") ;
		$output->writeln("<info>Nombre de dépots régénérés : $numDees</info>") ;
		$output->writeln("<info>Date de début : " . $input->getOption('start') . "</info>") ;
		$output->writeln("<info>Date de fin : " . $input->getOption('end') . "</info>") ;
		
		foreach ($dees as $dee) {
			// Régénération du dépot, sans notification de l'utilisateur.
			$output->writeln("") ;
			$output->writeln("Régénération DBB {$dee->getId()}, pour le JDD {$dee->getJdd()->getId()}.") ;
            
            $files = $this->dbbProcess->getDbbGenerator($dee)->generate($dee) ;
            // Create archive and delete useless csv file.
			$this->dbbProcess->createDBBArchive($dee, $files) ;
			foreach ($files as $file) {
				@unlink($file);
			}
                        
			$output->writeln("Terminé") ;
		}
	}
	
	
	
	/**
	 * Trouve les DEEs qui ont été publiés.
	 * @param \DateTime $start
	 * @param \DateTime $end
	 * @return DEE[]
	 */
	private function findPublishedDees($start, $end) {
		
		$deeRepository = $this->entityManager->getRepository('IgnGincoBundle:RawData\DEE') ;
		$queryBuilder = $deeRepository->createQueryBuilder('d')
			->leftJoin('d.jdd', 'j')
			->leftJoin('j.fields', 'f')
			->where('d.status = :deeStatus')
			->andWhere('j.status = :jddStatus')
			->andWhere('f.key = :key')
			->andWhere('f.valueString = :value')
			->setParameter('deeStatus', DEE::STATUS_OK)
			->setParameter('jddStatus', Jdd::STATUS_ACTIVE)
			->setParameter('key', 'status')
			->setParameter('value', 'published')
		;
		
		if ($start) {
			$queryBuilder
				->andWhere('d.createdAt >= :start')
				->setParameter('start', $start)
			;
		}
		
		if ($end) {
			$queryBuilder
				->andWhere('d.createdAt < :end')
				->setParameter('end', $end)
			;
		}
		
		return $queryBuilder->getQuery()->getResult() ;
	}
}
