<?php
namespace Ign\Bundle\DlbBundle\Services\RabbitMQ;

use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\DlbBundle\Services\DBBProcess;
use PhpAmqpLib\Message\AMQPMessage;
use Ign\Bundle\GincoBundle\Services\RabbitMQ\GenericConsumer;

class DlbGenericConsumer extends GenericConsumer {

	/**
	 * The DBBProcess Service, in charge of the construction of DLB data file, certificate,
	 * and DEE generation
	 * @var
	 */
	protected $DBBProcess;

	public function setDBBProcess(DBBProcess $DBBProcess) {
		$this->DBBProcess = $DBBProcess;
	}

	/**
	 * Specific code to execute  when receiving a message with RUNNING or PENDING status
	 *
	 * Adds the action 'dbbProcess' to the list of tasks handled by the Generic Consumer
	 *
	 * @param $action
	 * @param null $parameters
	 * @param null $message
	 */
	protected function onRunning($action, $parameters = null, $message = null)
	{
		// -- DLB generation, archive creation and notifications
		if ($action == 'dbbProcess') {
			sleep(1); // let the time to the application to update message before starting
			$this->DBBProcess->generateAndSendDBB($parameters['DEEId'], $message->getId());
			if ($message->getStatus() == Message::STATUS_RUNNING) {
				$message->setStatus(Message::STATUS_COMPLETED);
			}
			$this->em->flush();
			echo $this->datelog() . "DBB Process finished\n";
		}

		parent::onRunning($action, $parameters, $message);
	}

}