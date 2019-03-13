<?php
$currentDir = dirname(__FILE__);
$sprintDir = dirname(__FILE__);
$initDir = realpath(dirname(__FILE__)."/../../init/") ;
// Require file from dev or build environnement
if (is_file("$currentDir/../../../lib/share.php")) {
	require_once "$currentDir/../../../lib/share.php";
} else if (is_file("$currentDir/../../../../ginco/lib/share.php")) {
	require_once "$currentDir/../../../../ginco/lib/share.php";
} else {
	echo "Can't find file ..../lib/share.php\n\n";
	exit(1);
}

function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nApplies DLB patches to latest Ginco/DLB version database (the database should be up to date before launching this script");
	echo ("> php update_dlb.php -f <configFile> [{-D<propertiesName>=<Value>}]\n\n");
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
$paramStr = implode(' ', array_slice($argv, 1));

try {
	/* patch code here */
	// execCustSQLFile("$currentDir/xxx.sql", $config);
	execCustSQLFile("$currentDir/add_status_fields.sql", $config);
	execCustSQLFile("$sprintDir/add_standard.sql", $config);



} catch (Exception $e) {
	echo "$currentDir/update_dlb.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
} finally {
	echo "Finished applying patches on DLB database.\n";
}


$CLIParams = implode(' ', array_slice($argv, 1));
try {

	//system("php $sprintDir/XXXX.php $CLIParams", $returnCode1);
    system("php $sprintDir/change_model_nomvalide.php $CLIParams", $returnCode1) ;
    if ($returnCode1 != 0) {
        echo "$sprintDir/change_model_nomvalide.php crashed.\n";
        exit(1);
	}
	
	system("php $sprintDir/add_index_observations.php $CLIParams", $returnCode2) ;
    if ($returnCode2 != 0) {
		echo "$sprintDir/add_index_observations.php crashed.\n";
		// pas besoin d'exit -> on ne plante pas le processus si la création de l'index a échoué.
    }
	

} catch (Exception $e) {
	
	echo "$sprintDir/update_db_sprint.php : an exception has occured.\n" ;
	echo "Exception : {$e->getMessage()}" ;
	exit(1) ;
}
