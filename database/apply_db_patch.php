<?php
$currentDir = dirname(__FILE__);
require_once "$currentDir/../../ginco/lib/share.php";

// ----------------------------------------------------
// Synopsis: migrate DB GINCO from v2.0.001 to v2.0.002
// ----------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nApplies DLB patches to latest Ginco version database (the database should be up to date before launching this script");
	echo ("> php apply_db_patch.php -f <configFile> [{-D<propertiesName>=<Value>}]\n\n");
	echo "o <configFile>: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)) {
		echo ("$mess\n\n");
		exit(1);
	}
	exit();
}

if (count($argv) == 1)
	usage();
$config = loadPropertiesFromArgs();

try {
	/* patch code here */
	execCustSQLFile("$currentDir/scripts/update_event_listener.sql", $config);
} catch (Exception $e) {
	echo "$currentDir/scripts/apply_db_patch.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
} finally {
	echo "Finished applying patches on dlb database.\n";
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
//  system("php $currentDir/script1.php $CLIParams", $returnCode1);
// system("php $currentDir/script2.php $CLIParams", $returnCode2);
/*
 if ($returnCode1 != 0 || $returnCode2 != 0) {
 echo "$currentDir/apply_db_patch.php\n";
 echo "exception: " . $e->getMessage() . "\n";
 exit(1);
 }
 */