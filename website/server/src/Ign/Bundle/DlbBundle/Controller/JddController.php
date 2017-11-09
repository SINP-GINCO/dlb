<?php
namespace Ign\Bundle\DlbBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Exception\MetadataException;
use Ign\Bundle\DlbBundle\Form\DlbJddType;
use Ign\Bundle\GincoBundle\Controller\JddController as BaseController;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;

/**
 * @Route("/jdd")
 */
class JddController extends BaseController {

	/**
	 * Jdd creation page
	 * Dlb customisation: hide model field, add tps_id field, add jdd_id field dynamicaly
	 * Checks, via a service, the xml file on metadata platform, and fills jdd fields with metadata fields
	 *
	 * @Route("/new", name = "jdd_new")
	 */
	public function newAction(Request $request) {
		
		// Redirect url is integration_home when creating a new jdd, put it in session to redirect to it at the end of the process
		$redirectUrl = $this->generateUrl('integration_home');
		$session = $request->getSession();
		if (!$session->has('redirectToUrl'))
			$session->set('redirectToUrl', $redirectUrl);
		
		$em = $this->get('doctrine.orm.entity_manager');
		
		/* Get info on tps and metadata to display in the view */
		$tpsId = null;
		$choices = null;
		
		// Get the url of the metadata service
		$metadataServiceUrl = $this->get('ogam.configuration_manager')->getConfig('jddMetadataFileDownloadServiceURL');
		// Format the URL to only get prefix
		$endUrl = strpos($metadataServiceUrl, "cadre");
		$metadataServiceUrl = substr($metadataServiceUrl, 0, $endUrl + 6);
		$tpsDescription = "";
		
		// Get input user values from ajax
		if (!empty($_POST)) {
			$tpsId = $_POST['dlb_jdd']['tps_id'];
		}
		
		// Get jdds from tpsId (using a xml concatenating several jdd metadatas)
		if ($tpsId != null) {
			$metadataJddsFields = $this->get('dlb.metadata_tps_reader')->getJddMetadatas($tpsId);
			$choices = $metadataJddsFields['jddIds'];
			// By default the tpsId is unknown : stock an error message to display
			$tpsDescription = $this->get('translator')->trans('Jdd.new.tpsIdError', array());
			
			if (count($choices) > 0) {
				if (!array_key_exists(0, $choices)) {
					// Get info on tps from CA metadata
					$metadataTpsFields = $this->get('dlb.metadata_tps_reader')->getTpsMetadata($tpsId);
					$tpsLibelle = $metadataTpsFields['libelle'];
					// Stock info to display
					$tpsDescription = $this->get('translator')->trans('Jdd.new.tpsIdInfo', array(
						'%title%' => $tpsLibelle
					));
				}
			}
		}
		
		/* Manage form */
		$jdd = new Jdd();
		$form = $this->createForm(new DlbJddType($this->get('dlb.metadata_tps_reader')), $jdd, array(
			// the entity manager used for model choices must be the same as the one used to persist the $jdd entity
			'entity_manager' => $em,
			'option_key' => $this->get('dlb.metadata_tps_reader')
		));
		
		// Pre-fill form if parameters are passed in the query
		if (null !== $request->query->get('idtps')) {
			$tpsId = $request->query->get('idtps');
			$this->get('logger')->debug('tpsid from URL : ' . $tpsId);
			$form->get('tps_id')->setData($tpsId);
		}
		
		// Pre-fill form if parameters are passed in the query
		$jddId = null;
		if (null !== $request->query->get('idjdd')) {
			$idjdd = $request->query->get('idjdd');
			$this->get('logger')->debug('idjdd from URL : ' . $jddId);
			try {
				// Get ca_id from jdd metadata
				$metadataFields = $this->get('ginco.metadata_reader')->getMetadata($jddId);
				$caId = $metadataFields['metadataCAId'];
				
				// Get tps_id from ca metadata
				$metadataTpsFields = $this->get('dlb.metadata_tps_reader')->getTpsIdFromCaId($caId);
				$tpsId = $metadataTpsFields['tpsId'];
				
				$form->get('tps_id')->setData($tpsId);
				$form->get('jdd_id')->setData($jddId);
				
			} catch (Exception $e) {
				$error = new FormError($this->get('translator')->trans($e->getMessage(), array(), 'validators'));
				$form->get('jdd_id')->addError($error);
			}
		}
		
		$form->handleRequest($request);
		
		// Add a custom step to test validity of the jdd_id, with the metadata service
		$formIsValid = $form->isValid();
		if ($formIsValid) {
			$jddId = $form->get('jdd_id')->getData();
			$this->get('logger')->debug('metadataId is : ' . $jddId);
			
			// Test if another jdd already exists with this jddId
			$jddWithSameMetadataId = $em->getRepository('OGAMBundle:RawData\Jdd')->findByField(array(
				'metadataId' => $jddId
			));
			if (count($jddWithSameMetadataId) > 0) {
				$error = new FormError($this->get('translator')->trans('Metadata.Unique', array(), 'validators'));
				$form->get('jdd_id')->addError($error);
				$formIsValid = false;
			}
		}
		if ($formIsValid) {
			// Read the metadata XML file
			$mr = $this->get('ginco.metadata_reader');
			try {
				$fields = $mr->getMetadata($jddId);
			} catch (MetadataException $e) {
				$error = new FormError($this->get('translator')->trans($e->getMessage(), array(), 'validators'));
				$form->get('jdd_id')->addError($error);
				$formIsValid = false;
			}
		}
		if ($formIsValid) {
			// Add user and provider relationship
			$jdd->setUser($this->getUser());
			$jdd->setProvider($this->getUser()
				->getProvider());
			
			// writes the jdd to the database
			// persist won't work (because user and provider are not retrieved via the same entity manager ?)
			// So merge and get the merged object to access auto-generated id
			$attachedJdd = $em->merge($jdd);
			// and we must create the fields for the attached Jdd... beurk !!
			foreach ($fields as $key => $value) {
				$attachedJdd->setField($key, $value);
			}
			$attachedJdd->setField('tpsId', $tpsId);
			$attachedJdd->setField('caTitle', $tpsLibelle);
			$em->flush();
			
			// Redirects to the new submission form: upload data
			return $this->redirect($this->generateUrl('integration_creation', array(
				'jddid' => $attachedJdd->getId()
			)));
		}
		
		return $this->render('IgnDlbBundle:Jdd:jdd_new_page.html.twig', array(
			'form' => $form->createView(),
			'tpsDescription' => $tpsDescription,
			'metadataUrl' => $metadataServiceUrl,
			'idjdd' => $jddId
		));
	}
}
