<?php
namespace Ign\Bundle\DlbBundle\Tests;

/**
 * @author Gautam Pastakia
 *
 */
interface DlbBaseInterface {

	/**
	 * This function execute SQL scripts needed for specific test.
	 *
	 * @param $adminConn connection
	 *        	to postgres
	 */
	static function executeScripts($adminConn);
}