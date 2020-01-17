<?php
namespace Ign\Bundle\DlbBundle\Services;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Exception\DEEException;
use Ign\Bundle\GincoBundle\Entity\Generic\QueryForm;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\DlbBundle\Services\AbstractDBBGenerator;

/**
 * Class DBBGenerator
 * Responsible of the export of the DBB
 *
 * @package Ign\Bundle\DlbBundle\Services
 *         
 * @author AMouget
 */
class DBBGeneratorOcctax extends AbstractDBBGenerator {

	

	/**
	 * Create the CSV of the DBB for jdd with the id given.
	 * Write it in file.
	 *
	 * @param DEE $DEE        	
	 * @return string[]
	 * @throws DEEException
	 */
	public function generate(DEE $DEE) {
		// Configure memory and time limit because the program asks a lot of resources
		ini_set("memory_limit", $this->configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", 0);
		
		// Get validated (published) submissions in the jdd, stored in the DEE line
		//$submissionsIds = $DEE->getSubmissions();
		
		// Get the jdd and the data model
		$jdd = $DEE->getJdd();

		$submissionsIds = implode(',', $DEE->getSubmissions()) ;
		
		$model = $jdd->getModel();
		
		// -- Create a query object : the query must find all lines with given submission_ids
		// And print a list of all fields in the model
		$queryForm = new QueryForm();
		
		// Get all table fields for model
		$tableFields = $this->em->getRepository('IgnGincoBundle:Metadata\TableField')->getTableFieldsForModel($model);
		// Get all Form Fields for Model
		$formFields = $this->em->getRepository('IgnGincoBundle:Metadata\FormField')->getFormFieldsFromModel($model->getId());
		
		// -- Criteria fields for the query : we only add SUBMISSION_IDs
		// -- Result fields for the query : all fields of the model, we will sort them later
		foreach ($formFields as $formField) {
			$data = $formField->getData()->getData();
			$format = $formField->getFormat()->getFormat();
			
			// Search criteria
			switch ($data) {
				case 'SUBMISSION_ID':
					// Add submissions ids as an array, it will result in a x OR y OR z
					$queryForm->addCriterion($format, 'SUBMISSION_ID', $submissionsIds);
					break;
			}
			// Result columns
			$queryForm->addColumn($format, $data);
		}
		
		// -- Generate the SQL Request
		
		$options = array(
			'geometry_format' => 'wkt',
			'geometry_srs' => 4326,
			"date_format" => 'YYYY-MM-DD',
			"datetime_format" => 'YYYY-MM-DD"T"HH24:MI:SSTZ',
			"time_format" => 'HH24:mi:ss'
		);
		
		// Get the mappings for the query form fields
		$queryForm = $this->queryService->setQueryFormFieldsMappings($queryForm);
		$mappingSet = $queryForm->getFieldMappingSet($queryForm);
		
		// Fake user params, OK
		$userInfos = [
			"providerId" => NULL,
			"userLogin" => NULL,
			"DATA_QUERY_OTHER_PROVIDER" => true,
			"EDIT_DATA_OWN" => true,
			"EDIT_DATA_PROVIDER" => true,
			"EDIT_DATA_ALL" => true
		];
		
		$select = $this->genericService->generateSQLSelectRequest('RAW_DATA', $queryForm->getColumns(), $mappingSet, $userInfos, $options);
		$from = $this->genericService->generateSQLFromRequest('RAW_DATA', $mappingSet);
		$where = $this->genericService->generateSQLWhereRequest('RAW_DATA', $queryForm->getCriteria(), $mappingSet, $userInfos);
		$sqlPKey = $this->genericService->generateSQLPrimaryKey('RAW_DATA', $mappingSet);
		$order = " ORDER BY " . $sqlPKey;
		$sql = $select . $from . $where . $order;
		
		// Count Results
		$total = $this->queryService->getQueryResultsCount($from, $where);
		
		// -- Export results to a CSV file
		if ($total != 0) {
			
			$fileNameDBB = $this->generateFileNameDBB($jdd,$DEE);
			
			$out = fopen($fileNameDBB, 'w');
			if (!$out) {
				throw new DEEException("Error: could not open (w) file: $fileNameDBB");
			}
			fclose($out);
			
			// -- Batch execute the request, and write observations to the output file
			$batchLines = 1000;
			$batches = ceil($total / $batchLines);
			
			$sortFields = array(
				'jddmetadonneedeeid',
				'identifiantpermanent',
				'organismegestionnairedonnee',
				'statutsource',
				'statutobservation',
				'nomcite',
				'cdnom',
				'cdref',
				'jourdatedebut',
				'jourdatefin',
				'observateurnomorganisme',
				'determinateurnomorganisme',
				'datedetermination',
				'occmethodedetermination',
				'sensible',
				'sensiniveau',
				'sensidateattribution',
				'sensireferentiel',
				'sensiversionreferentiel',
				'geometrie',
				'precisiongeometrie',
				'natureobjetgeo',
				'nomcommune',
				'nomcommunecalcule',
				'codecommunecalcule',
				'codemaillecalcule',
				'codedepartementcalcule',
				'obscontexte',
				'obsdescription',
				'obsmethode',
				'occetatbiologique',
				'occnaturalite',
				'occsexe',
				'occstadedevie',
				'occstatutbiogeographique',
				'occstatutbiologique',
				'objetdenombrement',
				'typedenombrement',
				'denombrementmax',
				'denombrementmin',
				'commentaire',
				'identifiantregroupementpermanent',
				'methoderegroupement',
				'typeregroupement',
				'altitudemax',
				'altitudemin',
				'altitudemoyenne',
				'profondeurmax',
				'profondeurmin',
				'profondeurmoyenne',
				'preuveexistante',
				'preuvenonnumerique',
				'preuvenumerique',
				'referencebiblio',
				'identifiantorigine',
				'jddcode',
				'jddid',
				'jddsourceid',
				'versionrefmaille',
				'versiontaxref'
			);
			
			// Get the column names
			$line = array();
			foreach ($sortFields as $sortField) {
				$data = $this->em->getRepository('IgnGincoBundle:Metadata\Data')->findOneByData($sortField);
				$line[] = $data->getLabel();
			}
			
			// Put the lines to write in an array
			$resultsArray = array();
			$resultsArray[] = $line;
			
			for ($i = 0; $i < $batches; $i ++) {
				
				$batchSQL = $sql . " LIMIT $batchLines OFFSET " . $i * $batchLines;
				
				// -- Execute query and put results in a formatted array of strings
				$results = $this->queryService->getQueryResults($batchSQL);
				
				// Put lines in a formatted array
				foreach ($results as $line) {
					$resultLine = array();
					foreach ($tableFields as $tableField) {
						$key = strtolower($tableField->getName());
						$value = $line[$key];
						$data = $tableField->getData()->getData();
						
						if ($value == null) {
							$resultLine[$data] = '';
						} else {
							$type = $tableField->getData()
								->getUnit()
								->getType();
							switch ($type) {
								case 'ARRAY':
									// Just sanitize string (remove "", {}, and [])
									$bad = array(
										"[",
										"]",
										"\"",
										"'"
									);
									$value = str_replace($bad, "", $value);
									$resultLine[$data] = $value;
									break;
								
								case "CODE":
								default:
									// Default case : String or numeric value
									$resultLine[$data] = $value;
									break;
							}
						}
					}
					
					// Masks sensitive fields when data is sensitive
					$datasToMask = array(
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
					if ($resultLine['sensiniveau'] != '0') {
						
						foreach ($datasToMask as $dataToMask) {
							$resultLine[$dataToMask] = 'Masqué';
						}
					}
					
					// Orders fields
					$properOrderedLine = array();
					foreach ($sortFields as $sortField) {
						$properOrderedLine[$sortField] = $resultLine[$sortField];
					}
					
					$resultsArray[] = $properOrderedLine;
				}
				
				// Writes the file
				$file = fopen($fileNameDBB, 'w');
				if ($resultsArray != null) {
					// Write each line in the csv
					foreach ($resultsArray as $line) {
						// keep only the first count($resultColumns), because there is 2 or 3 technical fields sent back (after the result columns).
						$line = array_slice($line, 0, count($queryForm->getColumns()));
						// implode all arrays
						foreach ($line as $index => $value) {
							if (is_array($value)) {
								$line[$index] = join(",", $value); // just use join because we don't want double enclosure...
							}
						}
						
						$line = array_map(function ($field) {
							return trim($field, '"');
						}, $line);
						
						// use the default csv handler to write line in file
						fputcsv($file, $line, ";", '"');
					}
				}
				fclose($file);
			}
		}
		
		// Create an archive of the csv (zip)
		$parentDir = dirname($fileNameDBB); // dbbPublicDirectory
		$file = basename($fileNameDBB); // fichier.csv
		$archiveName = $parentDir . '/' . basename($fileNameDBB, '.csv') . '.zip';
		try {
			chdir($parentDir);
			system("zip -r $archiveName $file");
		} catch (\Exception $e) {
			throw new DEEException("Could not create archive $archiveName:" . $e->getMessage());
		}
		// Delete CSV file
		// unlink($fileNameDBB);
		
		// Put zip filePath in JddField
		$this->logger->debug('fileDBB : ' . $archiveName);
		
		$jdd->setField('dbbFilePath', $archiveName);
		$this->em->flush();
		
		return array($file);
	}

	

}