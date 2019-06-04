<?php
namespace Ign\Bundle\DlbBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Exception\DEEException;
use Ign\Bundle\GincoBundle\Controller\GincoController;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;

/**
 * @Route("/")
 *
 * @author AMouget
 */
class DBBController extends GincoController {

	/**
	 * DLB generation action
	 * Publish a RabbitMQ message to generate the DLB in background
	 * Include generation of dbb, metadatas, certificate and dee
	 *
	 * @param Request $request
	 * @return JsonResponse GET parameter: jddId, the Jdd identifier
	 *
	 *         @Route("/dlb/generate_dlb", name = "generate_dlb")
	 */
	public function generateDLB(Request $request) {
		$em = $this->get('doctrine.orm.entity_manager');

		// Find jddId if given in GET parameters
		$jddId = intval($request->query->get('jddId', 0));
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneById($jddId);
		if (!$jdd) {
			return new JsonResponse([
				'success' => false,
				'message' => 'No jdd found for this id: ' . $jddId
			]);
		}

		if ( !$this->isGranted('GENERATE_DEE', $jdd) ) {
			throw $this->createAccessDeniedException("You don't have the rights to generate a DEE for this JDD.");
		}

		$this->get('ginco.jdd_service')->updateMetadataFields($jdd) ;
		
		$dbbProcess = $this->get('dlb.dbb_process');
		$deeProcess = $this->get('ginco.dee_process');

		// Create a line in the DEE table
		$dee = $this->getDoctrine()->getRepository('IgnGincoBundle:RawData\DEE')->findOneByJdd($jdd) ;
		if (!$dee) {
			$dee = $deeProcess->createDEELine($jdd, $this->getUser(), 'Dépôt Légal de données de Biodiversité');
		}

		// Add information in jddField table
		$jdd->setField('status', 'generating');
		$em->flush();

		// Publish the message to RabbitMQ
		$messageId = $this->get('old_sound_rabbit_mq.ginco_generic_producer')->publish('dbbProcess', [
			'DEEId' => $dee->getId()
		]);
		$message = $em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId);

		// Attach message id to the DEE (use it for the progress bar)
		$dee->setMessage($message);
		$em->flush();

		return new JsonResponse($this->getStatus($jddId));
	}

	/**
	 * Direct generation of DLB (dbb, metadatas, certificate, dee) for testing
	 *
	 * @Route("/dlb/{id}/generate_dlb_direct", name = "generate_dlb_direct", requirements={"id": "\d+"})
	 */
	public function directDLBAction(Jdd $jdd) {

		// Check permissions on a per-jdd basis if necessary
		if (!$this->get('security.authorization_checker')->isGranted('IS_AUTHENTICATED_FULLY')) {
			throw $this->createAccessDeniedException();
		}

		if ( !$this->isGranted('GENERATE_DEE', $jdd) ) {
			throw $this->createAccessDeniedException("You don't have the rights to generate a DEE for this JDD.");
		}

		$this->get('ginco.jdd_service')->updateMetadataFields($jdd) ;
		
		$dbbProcess = $this->get('dlb.dbb_process');
		$deeProcess = $this->get('ginco.dee_process');

		// Create a line in the DEE table
		$dee = $this->getDoctrine()->getRepository('IgnGincoBundle:RawData\DEE')->findOneByJdd($jdd) ;
		if (!$dee) {
			$dee = $deeProcess->createDEELine($jdd, $this->getUser(), 'Dépôt Légal de données de Biodiversité - test');
		}

		$dbbProcess->generateAndSendDBB($dee);

		return $this->redirect($this->generateUrl('integration_home'));
	}

	/**
	 * Undo generation of DLB and unpublish JDD
	 * (for testing)
	 *
	 * @Route("/dlb/{id}/unpublish", name = "unpublish_dlb", requirements={"id": "\d+"})
	 */
	public function undoDLBAction(Jdd $jdd) {
		
		if (!$this->isGranted('GENERATE_DEE', $jdd)) {
			throw $this->createAccessDeniedException();
		}

		$dbbProcess = $this->get('dlb.dbb_process');
		$dbbProcess->unpublishJdd($jdd);
		return $this->redirect($this->generateUrl('integration_home'));
	}

	/**
	 * Direct generation of DBB for testing
	 *
	 * @Route("/dlb/{jddId}/generate_dbb", name = "generate_dbb", requirements={"jddId": "\d+"})
	 */
	public function generateDbbCsvAction($jddId) {
		$em = $this->get('doctrine.orm.entity_manager');
		$deeProcess = $this->get('ginco.dee_process');
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneById($jddId);


		if ( !$this->isGranted('GENERATE_DEE', $jdd) ) {
			throw $this->createAccessDeniedException("You don't have the rights to generate a DEE for this JDD.");
		}

		// Create a line in the DEE table
		$dee = $this->getDoctrine()->getRepository('IgnGincoBundle:RawData\DEE')->findOneByJdd($jdd) ;
		if (!$dee) {
			$dee = $deeProcess->createDEELine($jdd, $this->getUser(), 'Dépôt Légal de données de Biodiversité - test');
		}

		// Use DEE entity to generate dbb (attributes are the same)
		$this->get('dlb.dbb_generator')->generateDBB($dee);

		return $this->redirect($this->generateUrl('integration_home'));
	}

	/**
	 * Save PDF Certificate for testing
	 *
	 * @Route("/dlb/{jddId}/generate_certificate", name="generate_certificate", requirements={"jddId": "\d+"})
	 */
	public function pdfSaveAction($jddId) {
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneById($jddId);


		if ( !$this->isGranted('GENERATE_DEE', $jdd) ) {
			throw $this->createAccessDeniedException("You don't have the rights to generate a DEE for this JDD.");
		}

		$this->get('dlb.certificate_generator')->generateCertificate($jdd);

		return $this->redirect($this->generateUrl('integration_home'));
	}

	/**
	 * Save PDF Certificate for testing
	 *
	 * @Route("/dlb/{jddId}/generate_certificate_twig", name="generate_certificate_twig", requirements={"jddId": "\d+"})
	 */
	public function pdftwigSaveAction($jddId) {
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneById($jddId);

		if ( !$this->isGranted('GENERATE_DEE', $jdd) ) {
			throw $this->createAccessDeniedException("You don't have the rights to generate a DEE for this JDD.");
		}

		return $this->render('IgnDlbBundle:Jdd:certificate_pdf.html.twig', array(
			'jdd' => $jdd,
			'jddCAMetadataFileDownloadServiceURL' => 'dsf'
		));
	}

	/**
	 * Download dbb (zipped csv)
	 *
	 * @param
	 *        	$jddId
	 * @return BinaryFileResponse @Route("/dlb-download/{jddId}/download-dbb", name = "download_dbb")
	 */
	public function downloadDbb($jddId) {
		
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneByMetadataId($jddId);
		
		// Checks rights as non authentificated user has VIEW_PUBLISHED_DATASETS permission
		if (!$this->getUser()->isAllowed('VIEW_PUBLISHED_DATASETS') && !$this->isGranted('GENERATE_DEE', $jdd)) {
			throw $this->createAccessDeniedException();
		}
				
		$filePath = $jdd->getField('dbbFilePath');

		return $this->download($filePath);
	}

	/**
	 * Download certificate
	 *
	 * @param
	 *        	$jddId
	 * @return BinaryFileResponse @Route("/dlb-download/{jddId}/download-certificate", name = "download_certificate")
	 */
	public function downloadCertificate($jddId) {
				
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneByMetadataId($jddId);
		
		// Checks rights as non authentificated user has VIEW_PUBLISHED_DATASETS permission
		if (!$this->getUser()->isAllowed('VIEW_PUBLISHED_DATASETS') && !$this->isGranted('GENERATE_DEE', $jdd)) {
			throw $this->createAccessDeniedException();
		}
		
		
		$filePath = $jdd->getField('certificateFilePath');

		return $this->download($filePath);
	}

	/**
	 * Download metadata CA
	 *
	 * @param
	 *        	$jddId
	 * @return BinaryFileResponse @Route("/dlb-download/{jddId}/download-mtdca", name = "download_mtdca")
	 */
	public function downloadMtdCA($jddId) {
		
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneByMetadataId($jddId);
		
		// Checks rights as non authentificated user has VIEW_PUBLISHED_DATASETS permission
		if (!$this->getUser()->isAllowed('VIEW_PUBLISHED_DATASETS') && !$this->isGranted('GENERATE_DEE', $jdd)) {
			throw $this->createAccessDeniedException();
		}
		
		$metadataCAIdUrl= $this->get('ginco.configuration_manager')->getConfig('jddMetadataFileDownloadServiceURL');
		$urlMetaDataCAId = str_replace("/cadre/jdd", "/cadre", $metadataCAIdUrl);
		$metadataCAId = $jdd->getField('metadataCAId');

		$caMetadataFile = $urlMetaDataCAId . $metadataCAId;

		return $this->redirect($caMetadataFile);
	}

	/**
	 * Download metadata Jdd
	 *
	 * @param
	 *        	$jddId
	 * @return BinaryFileResponse @Route("/dlb-download/{jddId}/download-mtdjdd", name = "download_mtdjdd")
	 */
	public function downloadMtdJdd($jddId) {
	    
	    $em = $this->get('doctrine.orm.entity_manager');
	    $jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneByMetadataId($jddId);
	    
	    // Checks rights as non authentificated user has VIEW_PUBLISHED_DATASETS permission
	    if (!$this->getUser()->isAllowed('VIEW_PUBLISHED_DATASETS') && !$this->isGranted('GENERATE_DEE', $jdd)) {
	        throw $this->createAccessDeniedException();
	    }
	    $urlMetadataId= $this->get('ginco.configuration_manager')->getConfig('jddMetadataFileDownloadServiceURL');
	    $metadataId = $jdd->getField('metadataId');
	    $jddMetadataFile = $urlMetadataId . $metadataId;
	    
	    return $this->redirect($jddMetadataFile);
	    
	}

	/**
	 * Download the zip archive of a DEE for a jdd
	 * Note: direct downloading is prohibited by apache configuration, except for a list of IPs
	 *
	 * @param DEE $DEE
	 * @return BinaryFileResponse
	 * @throws DEEException @Route("/dlb/{jddId}/download-dee-dlb", name = "download_dee_dlb")
	 */
	public function downloadDEE($jddId) {
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneByMetadataId($jddId);
		$DEE = $em->getRepository('IgnGincoBundle:RawData\DEE')->findOneByJdd($jdd->getId());

		// Check permissions on a per-jdd basis if necessary
		if (!$this->get('security.authorization_checker')->isGranted('IS_AUTHENTICATED_FULLY')) {
			throw $this->createAccessDeniedException();
		}

		if ( !$this->isGranted('GENERATE_DEE', $jdd) ) {
			throw $this->createAccessDeniedException("You don't have the rights to generate a DEE for this JDD.");
		}

		// Get archive
		$archivePath = $DEE->getFilePath();
		if (!$archivePath) {
			throw new DEEException("No archive file path for this DEE: " . $DEE->getId());
		}

		// Test the existence of the zip file
		$fileName = pathinfo($archivePath, PATHINFO_BASENAME);
		$archiveFilePath = $this->get('ginco.configuration_manager')->getConfig('deePublicDirectory') . '/' . $fileName;
		if (!is_file($archiveFilePath)) {
			throw new DEEException("DEE archive file does not exist for this DEE: " . $DEE->getId() . ' ' . $archiveFilePath);
		}

		// Get back the file
		$response = new BinaryFileResponse($archiveFilePath);
		$response->setContentDisposition(ResponseHeaderBag::DISPOSITION_ATTACHMENT, $fileName);
		return $response;
	}

	/**
	 * Download a file
	 * Note: direct downloading is prohibited by apache configuration, except for a list of IPs
	 *
	 * @param string $file
	 * @return BinaryFileResponse
	 * @throws Exception
	 *
	 */
	private function download($filePath) {
		if (!is_file($filePath)) {
			throw new \Exception("file does not exist: " . $filePath);
		}

		$fileName = pathinfo($filePath, PATHINFO_BASENAME);

		// -- Get back the file
		$response = new BinaryFileResponse($filePath);
		$response->setContentDisposition(ResponseHeaderBag::DISPOSITION_ATTACHMENT, $fileName);
		return $response;
	}

	/**
	 * DBB generation - get status of the background task
	 *
	 * @param Request $request
	 * @return JsonResponse GET parameter: jddId, the Jdd identifier
	 *
	 *         @Route("/status", name = "dbb_status")
	 */
	public function getDBBStatus(Request $request) {
		// Find jddId if given in GET parameters
		$jddId = intval($request->query->get('jddId', 0));
		return new JsonResponse($this->getStatus($jddId));
	}

	/**
	 * DBBgeneration - get status of a set of background task
	 *
	 * @param Request $request
	 * @return JsonResponse GET parameter: jddIds, an array of Jdd identifiers
	 *
	 *         @Route("/status/all", name = "dbb_status_all")
	 */
	public function getDBBStatusAll(Request $request) {
		// Find jddIds if given in GET parameters
		$jddIds = $request->query->get('jddIds', []);

		$json = array();
		foreach ($jddIds as $jddId) {
			$json[] = $this->getStatus($jddId);
		}

		return new JsonResponse($json);
	}

	/**
	 * Returns a json array with informations about the DBB generation process
	 * This is the expected return of all DBB Ajax actions on the Jdd pages
	 *
	 * @param
	 *        	$jddId
	 * @param DBB|null $DBB
	 * @return array
	 */
	protected function getStatus($jddId) {
		$em = $this->get('doctrine.orm.entity_manager');
		$jddRepo = $em->getRepository('IgnGincoBundle:RawData\Jdd');

		// The returned informations
		$json = array(
			'jddId' => $jddId,
			'success' => true
		);

		$jdd = $jddRepo->findOneById($jddId);
		if (!$jdd) {
			$json['success'] = false;
			$json['error_message'] = 'No jdd found';
		} else {
			// Do the JDD has submissions ?
			// Are they all successful ?
			// If yes, the DBB can be generated
			$submissionCount = $jdd->getActiveSubmissions()->count();
			$submissionSuccessfulCount = $jdd->getSuccessfulSubmissions()->count();

			$json['canGenerateDBB'] = ($submissionCount == $submissionSuccessfulCount && $submissionSuccessfulCount > 0);

			if (empty($jdd->getField('status'))) {
				$json['dbb'] = array(
					'status' => 'unpublished'
				);
			} else {
				$createdDateTime = $jdd->getDees()[0]->getCreatedAt();

				$json['dbb'] = array(
					'id' => $jdd->getId(),
					'status' => $jdd->getField('status'),
					'createdDate' => $createdDateTime->format('d/m/Y'),
					'createdTime' => $createdDateTime->format('H\hi'),
					'fullCreated' => $createdDateTime->format('Y-m-d_H-i-s')
				);

				if ($jdd->getField('status') == 'generating') {
					$DEE = $em->getRepository('IgnGincoBundle:RawData\DEE')->findOneByJdd($jddId);
					$message = $DEE->getMessage();

					if (!$message) {
						$json['message'] = array(
							'status' => Message::STATUS_NOTFOUND,
							'error_message' => 'No message found for this dee',
							'createdDate' => '1970-01-01',
							'createdTime' => '00:00',
							'fullCreated' => date('c', mktime(0, 0, 0, 1, 1, 1970))
						);
					} else {
						$json['message'] = array(
							'status' => $message->getStatus(),
							'progress' => $message->getProgressPercentage()
						);
					}
				}
			}
		}
		return $json;
	}
    
}
