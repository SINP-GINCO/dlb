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
/**
 * #1230: Configure roles and permissions for dlb platform
 * - Delete 'administrateur' and 'producteur' roles
 * - Add 'petitionnaire' role
 * - Update 'grand public' role with new permission (export raw data)
 */
try {

	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');

	// Delete unnecessary roles
	$selectCodes = "SELECT role_code FROM website.role WHERE role_label IN ('Administrateur', 'Producteur')";

	$results = pg_query($selectCodes);
	$deletePermissionsSql = "DELETE FROM permission_per_role WHERE role_code = $1";
	$deleteRolesSql = "DELETE FROM role WHERE role_code = $1";

	$deletePermissions = pg_prepare($dbconn, "deletePermissions", $deletePermissionsSql);
	$deleteRoles = pg_prepare($dbconn, "deleteRoles", $deleteRolesSql);

	while ($row = pg_fetch_assoc($results)) {
		$roleCode = $row['role_code'];
		pg_execute($dbconn, "deletePermissions", array(
			$roleCode
		));
		pg_execute($dbconn, "deleteRoles", array(
			$roleCode
		));
	}

	// Insert new role and its permissions
	$select = "SELECT role_code FROm role where role_label ='Pétitionnaire'";
	$result = pg_query($dbconn, $select);
	if (pg_num_rows($result) == 0) {
		$insert = "INSERT INTO role(role_label, role_definition, is_default) VALUES ('Pétitionnaire', 'Pétitionnaire', false) RETURNING role_code;";
		$results = pg_query($insert);
		$roleCode = pg_fetch_result($results, 0, 0);

		$permissions = array(
			'DATA_INTEGRATION',
			'DATA_QUERY',
			'EXPORT_RAW_DATA',
			'DATA_EDITION',
			'MANAGE_DATASETS',
			'CONFIRM_SUBMISSION',
			'MANAGE_OWNED_PRIVATE_REQUEST'
		);
		$insertNewRoleSql = "INSERT INTO permission_per_role(role_code, permission_code) VALUES ($1, $2)";
		$insertNewRole = pg_prepare($dbconn, "insertNewRole", $insertNewRoleSql);
		foreach ($permissions as $permission) {
			pg_execute($dbconn, "insertNewRole", array(
				$roleCode,
				$permission
			));
		}
	}

	// Update grand_public role
	$selectCode = "SELECT role_code FROM website.role WHERE role_label = 'Grand public'";

	$result = pg_query($selectCode);
	$roleCode = pg_fetch_result($result, 0, 0);
	$selectPermission = "SELECT permission_code FROM permission_per_role WHERE role_code = $roleCode AND permission_code = 'EXPORT_RAW_DATA'";
	$result = pg_query($dbconn, $selectPermission);
	if (pg_num_rows($result) == 0) {
		$updatePermissionsSql = "INSERT INTO permission_per_role(role_code, permission_code) VALUES ($1, 'EXPORT_RAW_DATA');";
		$updatePermissions = pg_prepare($dbconn, "updatePermissions", $updatePermissionsSql);
		pg_execute($dbconn, "updatePermissions", array(
			$roleCode
		));
	}

	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_dlb.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}
