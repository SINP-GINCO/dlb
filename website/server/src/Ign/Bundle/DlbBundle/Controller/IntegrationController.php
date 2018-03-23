<?php
namespace Ign\Bundle\DlbBundle\Controller;

use Ign\Bundle\GincoBundle\Controller\IntegrationController as BaseController;
use Ign\Bundle\OGAMBundle\Entity\RawData\Submission;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;

/**
 * @Route("/integration")
 */
class IntegrationController extends BaseController {

	/**
	 * Show the create data submission page.
	 * DLB: Skip this page
	 * - Only one import model for the data model --> choose this one
	 * - can't choose another provider for the submission --> choose provider of the user
	 * --> and then just forward to next step
	 *
	 * @Route("/create-data-submission", name="integration_creation")
	 */
	public function createDataSubmissionAction(Request $request) {

		// Get the referer url, and put it in session to redirect to it at the end of the process
		$refererUrl = $request->headers->get('referer');
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('user_jdd_list');
		$session = $request->getSession();
		if (!$session->has('redirectToUrl'))
			$session->set('redirectToUrl', $redirectUrl);

		$em = $this->get('doctrine.orm.entity_manager');

		// Find jddid if given in GET parameters
		$jddId = intval($request->query->get('jddid', 0));
		$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);

		// If the model of the jdd has no published datasets, add a flash error message
		// which will be seen on next page
		$dataset = null;
		if ($jdd != null && $jdd->getModel()
			->getImportDatasets()
			->count() == 0) {
			$this->addFlash('error', 'Integration.Submission.noDatasetsForModel');
		}
		else {
			$dataset = $jdd->getModel()->getImportDatasets()->first();
		}

		// Instantiate a new submission
		$submission = new Submission();

		// Add user and provider relationship
		$submission->setUser($this->getUser());
		$submission->setProvider($this->getUser()->getProvider());

		// Add jdd relationship
		// And update jdd "dataUpdatedAt"
		$submission->setJdd($jdd);
		$jdd->setDataUpdatedAt(new \DateTime());
		$em->merge($jdd);

		// Add Import Dataset
		$submission->setDataset($dataset);

		// writes the submission to the database
		// merge because cascade persist is not set in the entity
		// and get the merged object to access auto-generated id
		$attachedSubmission = $em->merge($submission);
		$em->flush();

		// Redirects to next page: upload data
		return $this->redirect($this->generateUrl('integration_upload_data', array(
			'id' => $attachedSubmission->getId()
		)));
	}
}
