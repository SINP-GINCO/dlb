<?php
namespace Ign\Bundle\DlbBundle\Services\RabbitMQ;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\DlbBundle\Services\DBBProcess;
use OldSound\RabbitMqBundle\RabbitMq\ConsumerInterface;
use PhpAmqpLib\Message\AMQPMessage;
// use Ign\Bundle\GincoBundle\GMLExport\GMLExport;

class DlbGenericConsumer implements ConsumerInterface {

	/**
	 * The logger.
	 *
	 * @var Logger
	 */
	protected $logger;
	
	/**
	 * The locale.
	 *
	 * @var locale
	 */
	protected $locale;

	/**
	 * The entity manager.
	 *
	 */
	protected $em;
	
	/**
	 * Configuration Manager
	 */
	protected $configuration;

	protected $DBBProcess;

	public function __construct($em, $configuration, $logger, $locale) {
		// Initialise the logger
		$this->logger = $logger;
		// Initialise the locale
		$this->locale = $locale;
		// Initialise the entity manager
		$this->em = $em;
		$this->configuration = $configuration;

		echo "GenericConsumer is listening...\n";
	}


	public function setDBBProcess(DBBProcess $DBBProcess) {
		$this->DBBProcess = $DBBProcess;
	}


	public function execute(AMQPMessage $msg) {
		// $message will be an instance of `PhpAmqpLib\Message\AMQPMessage`.
		// The $message->body contains the data sent over RabbitMQ.
		echo "Getting new message !\n";

		try {
 			$data = unserialize($msg->body);
			// Get action and parameters
			$action = $data['action'];
			$parameters = $data['parameters'];

			// Get Message entity;
			$messageId = $data['message_id']; // Message id in messages table
			$message = $this->em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId);
			echo "Received message $messageId with action '$action' and status ".$message->getStatus(). ".\n";

			// if PENDING mark it as runnning
			if ($message->getStatus() == Message::STATUS_PENDING) {
				$message->setStatus(Message::STATUS_RUNNING);
				$this->em->flush();
			}

			// Perform task
			switch ($action) {
				// -- DLB generation, archive creation and notifications
				case 'dbbProcess':

					sleep(1); // let the time to the application to update message before starting
					$this->DBBProcess->generateAndSendDBB($parameters['DEEId'], $messageId);

					echo "DBB Process finished\n";
					break;
			}
		} catch (\Exception $e) {
			// If any of the above fails due to temporary failure, return false,
			// which will re-queue the current message.
			echo "Error : " . $e->getMessage() . "\n\n";
			echo $e->getTraceAsString();
			echo "\n";
			return false;
		}
		// Any other return value means the operation was successful and the
		// message can safely be removed from the queue.
		return true;
	}
}