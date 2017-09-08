<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Exception\MetadataException;
use Ign\Bundle\GincoBundle\Form\GincoJddType;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Request;
use Ign\Bundle\OGAMBundle\Controller\JddController as BaseController;

/**
 * @Route("/jdd")
 */
class JddController extends BaseController {

	/**
	 * Default action: Show the jdd list page
	 * Ginco customisation: the test for 'Jdd deletable' takes into account if the jdd has active DEEs
	 *
	 * @Route("/", name = "jdd_list")
	 */
	public function listAction() {
		parent::listAction();
		dump(count($jddList));
	}
}
