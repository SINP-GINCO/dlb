<?php
namespace Ign\Bundle\DlbBundle\Controller;

use Ign\Bundle\DlbBundle\Form\DlbJddType;
use Ign\Bundle\GincoBundle\Controller\JddController as BaseController;
use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Exception\MetadataException;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Request;

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

		// Get the referer url, to redirect to it at the end of the action
		$refererUrl = $request->headers->get('referer');
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('user_jdd_list');
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
					$caDescription = $metadataTpsFields['description'];
					$projetOwner = $metadataTpsFields['projetOwner'];
					$projetManager = $metadataTpsFields['projetManager'];
					// Stock info to display
					$tpsDescription = $this->get('translator')->trans('Jdd.new.tpsIdInfo', array(
						'%title%' => $tpsLibelle
					));
				}
			}
		}

		/* Manage form */
		$jdd = new Jdd();
		$form = $this->createForm(new DlbJddType($em, $this->get('translator'), $this->get('dlb.metadata_tps_reader')), $jdd, array(
			// the entity manager used for model choices must be the same as the one used to persist the $jdd entity
			'entity_manager' => $em,
			'option_key' => $this->get('dlb.metadata_tps_reader'),
			'current_user' => $this->getUser()
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
			$jddId = $request->query->get('idjdd');
			$this->get('logger')->debug('idjdd from URL : ' . $jddId);
			try {
				// Get ca_id from jdd metadata
				$metadataFields = $this->get('ginco.metadata_reader')->getMetadata($jddId);
				$caId = $metadataFields['metadataCAId'];

				// Get tps_id from ca metadata
				$metadataTpsFields = $this->get('dlb.metadata_tps_reader')->getTpsIdFromCaId($caId);
				$tpsId = $metadataTpsFields['tpsId'];
				$projetOwner = $metadataTpsFields['projetOwner'];
				$projetManager = $metadataTpsFields['projetManager'];

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
		/*
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
		 */
		if ($formIsValid) {
			// Read the metadata XML file
			$mr = $this->get('ginco.metadata_reader');
			$jddId = $form->get('jdd_id')->getData();
			try {
				$fields = $mr->getMetadata($jddId);
			} catch (MetadataException $e) {
				$error = new FormError($this->get('translator')->trans($e->getMessage(), array(), 'validators'));
				$form->get('jdd_id')->addError($error);
				$formIsValid = false;
			}
		}
		if ($formIsValid) {

			// Do we create a new Jdd or get an existing one ?
			$createJdd = true;
			$jddId = $form->get('jdd_id')->getData();
			$jddWithSameMetadataId =$em->getRepository('OGAMBundle:RawData\Jdd')->findByField(array(
				'metadataId' => $jddId
			));
			if (count($jddWithSameMetadataId) > 0) {
				$createJdd = false;
				$jddId = $jddWithSameMetadataId[0]->getId();
			}

			if ($createJdd) {
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
				$attachedJdd->setField('projetOwner', $projetOwner);
				$attachedJdd->setField('projetManager', $projetManager);
				$attachedJdd->setField('caTitle', $tpsLibelle);
				$attachedJdd->setField('caDescription', substr($caDescription, 0, 255));
				$em->flush();
				$jddId = $attachedJdd->getId();
			}

			// Redirects to the new submission form: upload data
			return $this->redirect($this->generateUrl('integration_creation', array(
				'jddid' => $jddId
			)));
		}

		return $this->render('IgnDlbBundle:Jdd:jdd_new_page.html.twig', array(
			'form' => $form->createView(),
			'tpsDescription' => $tpsDescription,
			'metadataUrl' => $metadataServiceUrl,
			'idjdd' => $jddId
		));
	}

	/**
	 * Show the published jdd list page
	 *
	 * @Route("/published-jdds/", name = "published_jdds")
	 */
	public function listPublishedAction() {
		// Checks rights as non authentificated user has VIEW_PUBLISHED_DATASETS permission
		if (!$this->getUser()->isAllowed('VIEW_PUBLISHED_DATASETS')) {
			throw $this->createAccessDeniedException();
		}

		$em = $this->get('doctrine.orm.raw_data_entity_manager');

		$jddList = $em->getRepository('OGAMBundle:RawData\Jdd')->findByField(array(
			'status' => 'published'
		), array(
			'id' => 'DESC'
		));

		$deeRepo = $em->getRepository('IgnGincoBundle:RawData\DEE');
		foreach ($jddList as $jdd) {
			// Add DEE information
			$jdd->dee = $deeRepo->findLastVersionByJdd($jdd);
		}

		return $this->render('OGAMBundle:Jdd:jdd_published_list_page.html.twig', array(
			'jddList' => $jddList,
			'user' => $this->getUser()
		));
	}

	/**
	 * Show the published jdd list page for a tpsId
	 *
	 * @Route("/published-jdds/{tpsId}", name = "published_jdds_by_tps", requirements={"tpsId": "\d+"})
	 */
	public function listPublishedByTpsIdAction($tpsId) {
		// Checks rights as non authentificated user has VIEW_PUBLISHED_DATASETS permission
		if (!$this->getUser()->isAllowed('VIEW_PUBLISHED_DATASETS')) {
			throw $this->createAccessDeniedException();
		}

		$em = $this->get('doctrine.orm.raw_data_entity_manager');

		$jddListPublished = $em->getRepository('OGAMBundle:RawData\Jdd')->findByField(array(
			'status' => 'published'
		), array(
			'id' => 'DESC'
		));
		$jddListByTpsId = $em->getRepository('OGAMBundle:RawData\Jdd')->findByField(array(
			'tpsId' => $tpsId
		), array(
			'id' => 'DESC'
		));
		$jddList = array_uintersect($jddListPublished, $jddListByTpsId, function ($jdd1, $jdd2) { return !($jdd1->getId() == $jdd2->getId()); });

		$deeRepo = $em->getRepository('IgnGincoBundle:RawData\DEE');
		foreach ($jddList as $jdd) {
			// Add DEE information
			$jdd->dee = $deeRepo->findLastVersionByJdd($jdd);
		}

		return $this->render('OGAMBundle:Jdd:jdd_published_by_tpsid_list_page.html.twig', array(
			'jddList' => $jddList,
			'user' => $this->getUser(),
			'tpsId' => $tpsId
		));
	}
}
