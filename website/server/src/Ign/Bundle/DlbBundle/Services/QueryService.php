<?php

namespace Ign\Bundle\DlbBundle\Services;

use Ign\Bundle\GincoBundle\Services\QueryService as BaseQueryService ;


/**
 * Description of QueryService
 *
 * @author rpas
 */
class QueryService extends BaseQueryService {
	
	
	/**
	 * Gets the permissions linked to visualization : sensitive, private and logged.
	 * 
	 * Surcharge de la méthode de GINCO.
	 * Dans dépôt légal, il n'y a pas de notion de données privées.
	 *
	 * @param mixed $user
	 *        	the user in session
	 * @return array of string|boolean $permissions
	 */
	public function getVisuPermissions($user) {
		
		$permissions = array(
			'sensitive' => $user->isAllowed('VIEW_SENSITIVE'),
			'private' => true,
			'logged' => true
		);
		
		return $permissions;
	}
}
