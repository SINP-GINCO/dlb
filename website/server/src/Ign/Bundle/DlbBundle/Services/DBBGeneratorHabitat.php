<?php

namespace Ign\Bundle\DlbBundle\Services;

use Ign\Bundle\DlbBundle\Services\AbstractDBBGenerator;
use Ign\Bundle\GincoBundle\Entity\RawData\DEE;

/**
 * Description of DBBGeneratorHabitat
 *
 * @author rpas
 */
class DBBGeneratorHabitat extends AbstractDBBGenerator {
	
	private $habitatModel = array(
		"identifianthabsinp"	=> "idHabSINP",
		"nomcite"				=> "nomCite",
		"preuvenumerique"		=> "uRLPreuve",
		"cdhab"					=> "cdHab",
		"typedeterm"			=> "typeDeterm",
		"determinateur"			=> "determinateur",
		"techniquecollecte"		=> "techniqueCollecte",
		"precisiontechnique"	=> "precisionTechnique",
		"recouvrement"			=> "recouvrement",
		"abondancehabitat"		=> "abondanceHabitat",
		"identifiantorigine"	=> "identifiantOrigine",
		"releveespeces"			=> "releveEspeces",
		"relevephyto"			=> "relevePhyto",
		"sensibilitehab"		=> "sensibiliteHab"
	);
	
	
	private $stationModel = array(
		"natureobjetgeo"			=> "NATOBJGEO",
		"acidite"					=> "ACIDITE",
		"altitudemax"				=> "ALTMAX",
		"altitudemin"				=> "ALTMIN",
		"altitudemoyenne"			=> "ALTMOY",
		"commentaire"				=> "COMMENT",
		"jourdatedebut"				=> "DATEDEBUT",
		"jourdatefin"				=> "DATEFIN",
		"dateimprecise"				=> "DATEIMPREC",
		"dspublique"				=> "DSPUBLIQUE",
		"echellenumerisation"		=> "ECHELLENUM",
		"exposition"				=> "EXPOSITION",
		"geologie"					=> "GEOLOGIE",
		"jddmetadonneedeeid"		=> "IDMTD",
		"identifiantoriginestation" => "IDORIGSTA",
		"identifiantstasinp"		=> "IDSTASINP",
		"estcomplexehabitats"		=> "ISCOMPLEX",
		"methodecalculsurface"		=> "METHCALC",
		"nomstation"				=> "NOMSTATION",
		"observateur"				=> "OBSNOMORG",
		"precisiongeometrie"		=> "PRECISGEOM",
		"profondeurmax"				=> "PROFMAX",
		"profondeurmin"				=> "PRODMIN",
		"profondeurmoyenne"			=> "PROFMOY",
		"referencebiblio"			=> "REFBIBLIO",
		"surface"					=> "SURFACE",
		"typesol"					=> "TYPESOL",
		"usage"						=> "USAGE",
		"geometrie"                 => "WKT"
 	);
	
	private $maskedData = array(
		'geometrie',
		'nomcommune',
		'nomcommunecalcule',
		'codecommune',
		'codecommunecalcule',
		'codemaille',
		'codemaillecalcule',
		'codedepartement',
		'codedepartementcalcule'
	);
	
	
	
	public function generate(DEE $dee) {
		
		// Configure memory and time limit because the program asks a lot of resources
		ini_set("memory_limit", $this->configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", 0);
		
		// Get the jdd and the data model
		$jdd = $dee->getJdd();

		$submissions = $jdd->getSuccessfulSubmissions();
		$submissionsIds = array();
		foreach ($submissions as $submission) {
			$this->logger->debug('submission : ' . $submission->getId());
			$submissionsIds[] = $submission->getId();
		}
		$dee->setSubmissions($submissionsIds);
		$this->em->flush();
		
		$model = $jdd->getModel();
		
		// Récupération des tables du modèle.
		$tableHabitat = null ;
		$tableStation = null ;
		$tables = $model->getTables() ;
		foreach ($tables as $table) {
			if ("habitat" == $table->getLabel()) {
				$tableHabitat = $table ;
			} else if ("station" == $table->getLabel()) {
				$tableStation = $table ;
			}
		}
		
		// Requête pour les habitats.
		$sqlHabitat = "SELECT s.identifiantstasinp AS idStaSINP" ;
		foreach ($this->habitatModel as $field => $label) {
			$sqlHabitat .= ", h.$field AS $label " ;
		}
		$sqlHabitat .= " FROM {$tableHabitat->getTableName()} h " ;
		$sqlHabitat .= " JOIN {$tableStation->getTableName()} s USING (clestation, SUBMISSION_ID) " ;
		$sqlHabitat .= " WHERE h.submission_id IN (" . implode(",", $dee->getSubmissions()) . ")" ;
		
		$csvHabitat = $this->generateFileNameDBB($jdd, $dee, "Habitat_soh_1_0") ;
		$this->generateCsv($sqlHabitat, $csvHabitat, array_merge(["identifiantstasinp" => "idStaSINP"], $this->habitatModel)) ;
		
        $parentDir = dirname($csvHabitat); // dbbPublicDirectory
        
		// Requête stations base
        $sqlStation = "SELECT " ;
		$fields = array() ;
        foreach ($this->stationModel as $column => $label) {
            $fields[] = "s.$column AS $label" ;
        }
        $sqlStation .= implode(", ", $fields) ;
		$sqlStation .= " FROM {$tableStation->getTableName()} s " ;
		$sqlStation .= " WHERE s.submission_id IN (" . implode(",", $dee->getSubmissions()) . ") " ;
		
		// Stations points
		$sqlStationPoints = $sqlStation . " AND st_geometrytype(st_multi(s.geometrie)) = 'ST_MultiPoint'" ;
		$shpStationPoints = $parentDir . DIRECTORY_SEPARATOR . "shp_point_soh.shp" ;
		$this->ogr2ogr->pg2shp($sqlStationPoints, $shpStationPoints, 'EPSG:4326') ;
		
		// Stations lignes
		$sqlStationLignes = $sqlStation . " AND st_geometrytype(st_multi(s.geometrie)) = 'ST_MultiLineString'" ;
		$shpStationLignes = $parentDir . DIRECTORY_SEPARATOR . "shp_ligne_soh.shp" ;
		$this->ogr2ogr->pg2shp($sqlStationLignes, $shpStationLignes, 'EPSG:4326') ;
		
		// Stations polygones
		$sqlStationPolygones = $sqlStation . " AND st_geometrytype(st_multi(s.geometrie)) = 'ST_MultiPolygon'" ;
		$shpStationPolygones = $parentDir . DIRECTORY_SEPARATOR . "shp_polygone_soh.shp" ;
		$this->ogr2ogr->pg2shp($sqlStationPolygones, $shpStationPolygones, 'EPSG:4326') ;
		
		// Create an archive of the csv (zip)
		$files = array(
			$csvHabitat,	
		);
		
		$entries = scandir($parentDir) ;
		foreach ($entries as $entry) {
			$fileName = basename(pathinfo($entry, PATHINFO_FILENAME)) ;
			if (in_array($fileName, ['shp_point_soh', 'shp_ligne_soh', 'shp_polygone_soh'])) {
				$files[] = $entry ;
			}
		}
		
		
		$baseFiles = implode(" ", array_map(function($f) { return basename($f) ; } , $files)) ; //basename($fileNameDBB); // fichier.csv
		$archiveName = $parentDir . '/' . basename($this->generateFileNameDBB($jdd, $dee), '.csv') . '.zip';
		try {
			chdir($parentDir);
			system("zip -r $archiveName $baseFiles");
		} catch (\Exception $e) {
			throw new DEEException("Could not create archive $archiveName:" . $e->getMessage());
		}
		
		// Put zip filePath in JddField
		$this->logger->debug('fileDBB : ' . $archiveName);
		
		$jdd->setField('dbbFilePath', $archiveName);
		$this->em->flush();
		
		return $files ;
	}	
	
	
	
	/**
	 * Writes CSV file from SQL.
	 * @param type $sql
	 * @param type $outputFile
	 */
	private function generateCsv($sql, $outputFile, $model) {
		
		$pdo = $this->em->getConnection() ; 
		
		$file = new \SplFileObject($outputFile, "w") ;
		$file->setCsvControl(";") ;
		
		$sth = $pdo->prepare($sql) ;
		$sth->execute() ;
		$firstLine = true ;
		while ($row = $sth->fetch(\PDO::FETCH_ASSOC)) {
			
			if (empty($row)) {
				continue ;
			}
			
			if ($firstLine) {
				$file->fputcsv(array_values($model)) ;
				$firstLine = false ;
			}
			
			$file->fputcsv(array_values($row)) ;
		}
	}
}
