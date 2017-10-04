<?php
namespace Ign\Bundle\DlbBundle\Controller;


use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Exception\DEEException;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;

/**
 * @Route("/dbb")
 */
class DBBController extends Controller
{
	/**
	 * Direct generation of DBB
	 *
	 * @Route("/{jddId}/generate_dbb", name = "generate_dbb", requirements={"jddId": "\d+"})
	 */
	public function directDBBAction($jddId) {
		$dbbProcess = $this->get('dlb.dbb_generator');

		$em = $this->get('doctrine.orm.entity_manager');
		
		// Use DEE entity to generate dbb (attributes are the same)
		$DEE = $em->getRepository('IgnGincoBundle:RawData\DEE')->findOneById($jddId);
		$dbbProcess->generateDBB($DEE);

		return $this->redirect($this->generateUrl('integration_home'));
	}
}