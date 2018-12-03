<?php
namespace Ign\Bundle\DlbBundle\Controller;

use Ign\Bundle\DlbBundle\Form\ContactType;
use Ign\Bundle\GincoBundle\Controller\DefaultController as BaseController;

use Symfony\Component\HttpFoundation\Request;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

class DefaultController extends BaseController {
    
    /**
     * Contact form page
     *
     * @Route("/contact", _name="contact")
     */
    public function contactAction(Request $request) {
           $form = $this->createForm(ContactType::class, null, array(
                   'action' => $this->generateUrl('contact'),
                   'method' => 'POST'
           ));
                      
           // If user is authenticated, get his email and set as default value
           if ($this->get('security.authorization_checker')->isGranted('IS_AUTHENTICATED_FULLY')) {
                   $email = $this->getUser()->getEmail();
                   $form->get('email')->setData($email);
           }

           if ($request->isMethod('POST')) {
                   // Refill the fields in case the form is not valid.
                   $form->handleRequest($request);

                   if ($form->isValid()) {
                           // Contact recipients
                            $contactRecipients = $this->get('ginco.configuration_manager')->getConfig('contactEmail', 'sinp-dev@ign.fr');
                            $contactRecipients = explode(',', $contactRecipients);

                            $this->get('app.mail_manager')->sendEmail(
                                        'IgnDlbBundle:Emails:contact.html.twig', 
                                        array(
                                            'email' => $form->get('email')->getData(),
                                            'subject' => $form->get('subject')->getData(),
                                            'message' => $form->get('message')->getData()
                                        ), 
                                        $contactRecipients
                                );

                           $request->getSession()
                                   ->getFlashBag()
                                   ->add('success', 'Contact.send.success');

                           return $this->redirect($this->generateUrl('contact'));
                   }
           }

           return $this->render('IgnGincoBundle:Default:contact.html.twig', array(
                   'form' => $form->createView()
           ));
    }
}
