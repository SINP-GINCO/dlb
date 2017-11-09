<?php
namespace Ign\Bundle\DlbBundle\Form;

use Doctrine\ORM\EntityRepository;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Symfony\Component\Form\AbstractType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\Form\FormEvent;
use Symfony\Component\Form\FormError;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\NotBlank;

/**
 * Class DlbJddType
 *
 * @package Ign\Bundle\dlbBundle\Form
 */
class DlbJddType extends AbstractType {

	private $metadataTpsReader;

	public function __construct($metadataTpsReader) {
		$this->metadataTpsReader = $metadataTpsReader;
	}

	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->add('tps_id', TextType::class, array(
			'label' => 'Jdd.new.tpsId',
			'mapped' => false,
			'constraints' => array(
				new NotBlank(array(
					'message' => 'Jdd.new.tpsIdNotBlank'
				))
			)
		))
			->
		// Hidden in twig
		add('model', EntityType::class, array(
			'label' => 'Modèle de données',
			'class' => 'OGAMBundle:Metadata\Model',
			'choice_label' => 'name',
			'em' => $options['entity_manager'],
			// Select Models which have an Import Dataset, ie a dataset with at least one FileFormat
			'query_builder' => function (EntityRepository $er) {
				return $er->createQueryBuilder('m')
					->leftJoin('m.datasets', 'd')
					->where('d.id IS NOT NULL')
					->leftJoin('d.files', 'f')
					->where('f.format IS NOT NULL')
					->orderBy('m.name', 'ASC');
			},
			'constraints' => array(
				new NotBlank(array(
					'message' => 'Jdd.new.modelUnpublished'
				))
			)
		))
			->add('submit', SubmitType::class, array(
			'label' => 'Créer le jeu de données'
		));
		
		// We add a select list jdd_id dynamically (cf ajax in the twig)
		$formModifier = function ($form, $tpsId = null) {
			$choices = array();
			
			// Get jdd from CA metadata
			if ($tpsId != null) {
				$metadataFields = $this->metadataTpsReader->getJddMetadatas($tpsId);
				$choices = $metadataFields['jddIds'];
				//var_dump($choices);
				//exit();
			}
			if (array_key_exists(0, $choices)) {
				$form->get('tps_id')->addError(new FormError('error message'));
				$choices = array();
			}
			
			$form->add('jdd_id', ChoiceType::class, array(
				'choices' => $choices,
				'expanded' => true,
				'multiple' => false,
				'mapped' => false,
				'label' => 'Jdd.new.jddId'
			));
		};
		// before form submit
		$builder->addEventListener(FormEvents::PRE_SET_DATA, function (FormEvent $event) use($formModifier) {
			$data = $event->getData();
			$form = $event->getForm();

			$formModifier($event->getForm(), $form->get('tps_id')->getData());
		});

		// after form submit
		$builder->get('tps_id')->addEventListener(FormEvents::POST_SUBMIT, function (FormEvent $event) use($formModifier) {
			// $event->getForm()->getData() send the initial value (empty)
			$tpsId = $event->getForm()
				->getData();
			// the event listener is on the child (jdd_id),
			// the parent (tps_id) must be pass to the callback functions
			$formModifier($event->getForm()
				->getParent(), $tpsId);
		});
	}

	/**
	 *
	 * @param OptionsResolver $resolver        	
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => Jdd::class
		));
		$resolver->setRequired('entity_manager');
		$resolver->setRequired('option_key');
	}

	public function getParent() {
		return \Ign\Bundle\OGAMBundle\Form\JddType::class;
	}
}