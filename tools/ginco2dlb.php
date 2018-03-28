<?php

/**
 * Converts a standard Ginco CSV import file to a DLB one (convert column names)
 * Usage: php ginco2dlb.php -f import_ginco.csv -o import_dlb.csv
 */


function usage($mess=NULL){
	echo "------------------------------------------------------------------------\n";
	echo "\nConverts a standard Ginco CSV import file to a DLB one (convert column names)\n";
	echo "> php ginco2dlb.php -f import_ginco.csv -o import_dlb.csv\n\n";
	echo "o import_ginco.csv: a ginco import file\n";
	echo "o a DLB import file (short names)\n\n";

	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)){
		echo("$mess\n\n");
		exit(1);
	}
	exit;
}


//------------------------------------------------------------------------------------------------------

if (count($argv)==1) usage();

// Get configuration and build options

$shortOpts = "f:"; // Name of input import file
$shortOpts .= "o:"; // Output DLB file

$params = getopt($shortOpts);
//var_dump($params);

if (!isset($params['f']) || empty($params['f']) || !isset($params['o']) || empty($params['o']) )
	usage();

if ($params['f'] == $params['o'])
	usage("The output file must not be the same as input file.");

if (!is_readable($params['f']))
	usage($params['f'] . " is not a readable file.");

if (file_exists($params['o']) && !is_writable($params['o']))
	usage($params['o'] . " is not a writable file.");

// Read first line and replace fields names
$fp=fopen($params['f'],"r");
$header=fgets($fp);

$replace = array(
	'altitudeMax' => 'altMax',
	'altitudeMin' => 'altMin',
	'altitudeMoyenne' => 'altMoy',
	'anneeRefCommune' => 'anRefCom',
	'anneeRefDepartement' => 'anRefDept',
	'cdNom' => 'cdNom',
	'cdRef' => 'cdRef',
	'codeCommune' => 'cdCom',
	'codeDepartement' => 'cdDept',
	'codeMaille' => 'cdM10',
	'commentaire' => 'comment',
	'dateDetermination' => 'dateDet',
	'denombrementMax' => 'denbrMax',
	'denombrementMin' => 'denbrMin',
	'determinateurIdentite' => 'detId',
	'determinateurNomOrganisme' => 'detNomOrg',
	'dsPublique' => 'dSPublique',
	'geometrie' => 'WKT',
	'heureDateDebut' => 'heureDebut',
	'heureDateFin' => 'heureFin',
	'identifiantOrigine' => 'idOrigine',
	'identifiantPermanent' => 'permId',
	'identifiantRegroupementPermanent' => 'permIdGrp',
	'jddsourceid' => 'jddSourId',
	'jourDateDebut' => 'dateDebut',
	'jourDateFin' => 'dateFin',
	'methodeRegroupement' => 'methGrp',
	'natureObjetGeo' => 'natObjGeo',
	'nomCite' => 'nomCite',
	'nomcCmmune' => 'nomCom',
	'nomRefMaille' => 'nomRefM10',
	'objetDenombrement' => 'objDenbr',
	'obsContexte' => 'obsCtx',
	'obsDescription' => 'obsDescr',
	'observateurIdentite' => 'obsId',
	'observateurNomOrganisme' => 'obsNomOrg',
	'obsMethode' => 'obsMeth',
	'occEtatBiologique' => 'ocEtatBio',
	'occMethodeDetermination' => 'ocMethDet',
	'occNaturalite' => 'ocNat',
	'occSexe' => 'ocSex',
	'occStadeDeVie' => 'ocStade',
	'occStatutBioGeographique' => 'ocBiogeo',
	'occStatutBiologique' => 'ocStatBio',
	'organismeGestionnaireDonnee' => 'orgGestDat',
	'precisionGeometrie' => 'precisGeo',
	'preuveExistante' => 'preuveOui',
	'preuveNonNumerique' => 'preuvNoNum',
	'preuveNumerique' => 'preuvNum',
	'profondeurMax' => 'profMax',
	'profondeurMin' => 'profMin',
	'profondeurMoyenne' => 'profMoy',
	'referenceBiblio' => 'refBiblio',
	'statutObservation' => 'statObs',
	'statutSource' => 'statSource',
	'typeDenombrement' => 'typDenbr',
	'typeInfoGeoCommune' => 'typInfGeoC',
	'typeInfoGeoDepartement' => 'typInfGeoD',
	'typeInfoGeoMaille' => 'typInfGeoM',
	'typeRegroupement' => 'typGrp',
	'versionRefMaille' => 'vRefM10'
);

$newHeader = str_replace(array_keys($replace), array_values($replace), $header, $count);
// echo "$count remplaceemnts\n";
// var_dump($newHeader);

// Write new header in output file
$fo = fopen($params['o'],"w");
fputs($fo, $newHeader);

// todo: remplacer les noms de colonnes supprimées par un marqueur (XXX), et supprimer les colonnes du CSV...

// Write the rest of the file
while($line=fgets($fp)) {
	fputs($fo,$line);
}
fclose($fp);
fclose($fo);

echo "Replacing column names in header by DLB ones... Done.\n\n";