<?php
$currentDir = dirname(__FILE__);
// Require file from dev or build environnement
if (is_file("$currentDir/../../lib/share.php")) {
	require_once "$currentDir/../../lib/share.php";
} else if (is_file("$currentDir/../../../ginco/lib/share.php")) {
	require_once "$currentDir/../../../ginco/lib/share.php";
} else {
	echo "Can't find file ..../lib/share.php\n\n";
	exit(1);
}

//------------------------------------------------------------------------------
// Synopsis: Play all DLB updates, starting from a fresh Ginco DB initialisation
//------------------------------------------------------------------------------
function usage($mess=NULL){
	echo "------------------------------------------------------------------------\n";
	echo("Play all DLB updates, starting from a fresh Ginco DB initialisation\n\n");
	echo("> php play_all_updates.php -f configFile [{-D<propertiesName>=<Value>}]\n\n");
	echo "o configFile: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)){
		echo("$mess\n\n");
		exit(1);
	}
	exit;
}

//------------------------------------------------------------------------------
function exitOnError($mess, $code=1){
	echo $mess;
	exit($code);
}

// Normalise version numbers X.Y.Z with 3 digits per number:
// 1.2.3 ==> 001002003
// 1.2.30 ==> 001002030
// 1.12.0 ==> 001012000
function normalizeVersion($verStr){
	if (!preg_match('#^\d+\.\d+\.\d+$#', $verStr)) {
		return false;
	}
	$verNums = explode('.',$verStr);
	$verNums = array_map( function($x){ return sprintf("%'.03d",$x);}, $verNums );
	return intval(implode('', $verNums));
}

// Reduce version string by removing 0
function reduceVersion($verStr){
	if (!preg_match('#^\d+\.\d+\.\d+$#', $verStr)) {
		return false;
	}
	$verNums = explode('.',$verStr);
	$verNums = array_map( function($x){ return intval($x);}, $verNums );
	return implode('.', $verNums);
}


// find all the patches to apply (based on the update/v*.*.* directories)
//------------------------------------------------------------------------------
function getApplicablePatches($updateDir){

	$versionsList = glob("$updateDir/v*",GLOB_ONLYDIR);
	$applicablePatches = array();
	foreach ($versionsList as $version) {
		$applicablePatches[] = basename($version);
	}

	return $applicablePatches;
}

//------------------------------------------------------------------------------
// Main
//------------------------------------------------------------------------------
if (count($argv)==1) usage();

$config = loadPropertiesFromArgs();
$conStr = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";

$applicablePatches = getApplicablePatches($currentDir);
if (count($applicablePatches)==0){
	echo "INFO : DB DLB is already up to date. There is nothing to do.\n";
	exit();
}

// apply patches
// $CLIParams is argv without the command name. Useful to give the params to the sprint scripts 
/* FIXME: dans $CLIParams il faudrait s'assurer que le chemin vers le fichier de conf est bien en absolu
          parce que le script de sprint n'est pas dans le même répertoire.*/
$CLIParams = implode(' ',array_slice($argv,1));
foreach ($applicablePatches as $patchDir) {
	echo "INFO: applying patches in: $patchDir\n";
	// Update php scripts are appliad in alphabetic order.
	$updateScripts = glob("$currentDir/$patchDir/update_*.php");
	foreach ($updateScripts as $script) {
		system("php $script $CLIParams", $returnCode);
		if ($returnCode != 0) {
			echo "ERROR : Problem occured on patch $patchDir";
			exit(1);
		}
	}
}
echo "DB patches applied. \n";