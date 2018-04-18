<?php
namespace Ign\Bundle\DlbBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints\Blank;
use Symfony\Component\Validator\Constraints\Email;
use Symfony\Component\Validator\Constraints\NotBlank;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

/**
 * Class ContactType
 * Contact form type
 * @package Ign\Bundle\GincoBundle\Form
 */
class ContactType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            // This field is a "honeypot", meant to confuse bots.
            // it is hidden in css, and must be left blank.
            // if not, we don't send the email.
            ->add('name', TextType::class, array(
                'label' => 'Contact.name',
                'required' => false,
                'attr' => array(
                    'class' => 'hidden'
                ),
                'label_attr' => array(
                    'class' => 'hidden'
                ),
                'constraints' => array(
                    new Blank(array('message' => 'Contact.validation.name.blank')),
                ),
            ))
            ->add('email', EmailType::class, array(
                'label' => 'Contact.email',
                'constraints' => array(
                    new NotBlank(array('message' => 'Contact.validation.email.notblank')),
                    new Email(array('message' => 'Contact.validation.email.invalid')),
                ),
            ))
            ->add('subject', ChoiceType::class, array(
                'label' => 'Contact.subject.title',
                'choices' => array(
                    'Contact.subject.legal.title' => array(
                        'Contact.subject.legal.questions' => 'legal_questions',
                        'Contact.subject.legal.rules' => 'legal_rules',
                    ),
                    'Contact.subject.format.title' => array(
                        'Contact.subject.format.standard' => 'format_standard',
                        'Contact.subject.format.structure' => 'format_structure',
                        'Contact.subject.format.taxref' => 'format_taxref',
                        'Contact.subject.format.sensitivity' => 'format_sensitivity',
                    ),
                    'Contact.subject.rules.title' => array(
                        'Contact.subject.rules.architecture' => 'rules_architecture',
                        'Contact.subject.rules.protocol' => 'rules_protocol',
                        'Contact.subject.rules.relation' => 'rules_relation',
                        'Contact.subject.rules.validation' => 'rules_validation',
                    ),
                    'Contact.subject.operation.title' => array(
                        'Contact.subject.operation.organism' => 'operation_organism',
                        'Contact.subject.operation.metadata' => 'operation_metadata',
                        'Contact.subject.operation.geonature' => 'operation_geonature',
                        'Contact.subject.operation.geonatureWorkflow' => 'operation_geonatureWorkflow',
                        'Contact.subject.operation.ginco' => 'operation_ginco',
                        'Contact.subject.operation.import' => 'operation_import',
                        'Contact.subject.operation.gincoWorkflow' => 'operation_gincoWorkflow'
                    ),
                    'Contact.subject.blocking.title' => array(
                        'Contact.subject.blocking.ginco' => 'blocking_ginco',
                        'Contact.subject.blocking.geonature' => 'blocking_geonature',
                        'Contact.subject.blocking.metadata' => 'blocking_metadata',
                        'Contact.subject.blocking.authentication' => 'blocking_authentication',
                        'Contact.subject.blocking.sinpDirectory' => 'blocking_sinpDirectory'
                    ),
                    'Contact.subject.evolution.title' => array(
                        'Contact.subject.evolution.geonature' => 'evolution_geonature',
                        'Contact.subject.evolution.ginco' => 'evolution_ginco',
                        'Contact.subject.evolution.dldbb' => 'evolution_dldbb',
                        'Contact.subject.evolution.metadata' => 'evolution_metadata',
                        'Contact.subject.evolution.directory' => 'evolution_directory'
                    ),
                    'Contact.subject.other'=>'other'
                ),
                'choices_as_values' => true,
            ))
            ->add('message', TextareaType::class, array(
                'label' => 'Contact.message',
                'attr' => array(
                    'cols' => 90,
                    'rows' => 10,
                ),
                'constraints' => array(
                    new NotBlank(array('message' => 'Contact.validation.message.notblank')),
                ),
            ))
            ->add('submit', SubmitType::class, array(
                'label' => 'Contact.send.button'
            ))
        ;
    }

    public function setDefaultOptions(OptionsResolverInterface $resolver)
    {
    }

    public function getName()
    {
        return 'contact_form';
    }
}