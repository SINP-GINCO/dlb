<?php
$currentDir = dirname(__FILE__);
// Require file from dev or build environnement
if (is_file("$currentDir/../../../lib/share.php")) {
	require_once "$currentDir/../../../lib/share.php";
} else if (is_file("$currentDir/../../../../ginco/lib/share.php")) {
	require_once "$currentDir/../../../../ginco/lib/share.php";
} else {
	echo "Can't find file ..../lib/share.php\n\n";
	exit(1);
}

// ----------------------------------------------------
// Synopsis: migrate DB GINCO/DLB from v2.0.004 to v2.0.005
// ----------------------------------------------------
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
	execCustSQLFile("$currentDir/update_taxref_to_v11.sql", $config);
} catch (Exception $e) {
	echo "$currentDir/update_dlb.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
} finally {
	echo "Finished applying patches on DLB database.\n";
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
$connectStr ="host="     .$config['db.host'];
$connectStr.=" port="    .$config['db.port'];
$connectStr.=" user="    .$config['db.adminuser'];
$connectStr.=" password=".$config['db.adminuser.pw'];
$connectStr.=" dbname="  .$config['db.name'];
system("$currentDir/populateTaxref.sh $connectStr", $returnCode1);

if ($returnCode1 != 0) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: error code returned from php sql script \n";
	exit(1);
}
 
try {
	/* patch code here */
	execCustSQLFile("$currentDir/../../../../ginco/database/init/populate_mode_taxref_table.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}