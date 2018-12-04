<?php
use Symfony\Component\HttpKernel\Kernel;
use Symfony\Component\Config\Loader\LoaderInterface;

class AppKernel extends Kernel {

	public function registerBundles() {
		$bundles = array(
			new Symfony\Bundle\FrameworkBundle\FrameworkBundle(),
			new Symfony\Bundle\SecurityBundle\SecurityBundle(),
			new Symfony\Bundle\TwigBundle\TwigBundle(),
			new Symfony\Bundle\MonologBundle\MonologBundle(),
			new Symfony\Bundle\SwiftmailerBundle\SwiftmailerBundle(),
			new Doctrine\Bundle\DoctrineBundle\DoctrineBundle(),
			new Sensio\Bundle\FrameworkExtraBundle\SensioFrameworkExtraBundle(),
			new WhiteOctober\BreadcrumbsBundle\WhiteOctoberBreadcrumbsBundle(),
			new FOS\JsRoutingBundle\FOSJsRoutingBundle(),
			new OldSound\RabbitMqBundle\OldSoundRabbitMqBundle(),
			new FOS\CKEditorBundle\FOSCKEditorBundle(),
			new Knp\Bundle\SnappyBundle\KnpSnappyBundle(),
			new Ign\Bundle\GincoBundle\IgnGincoBundle(),
			new Ign\Bundle\DlbBundle\IgnDlbBundle(),
			new Ign\Bundle\OGAMConfigurateurBundle\IgnOGAMConfigurateurBundle(),
			new Ign\Bundle\GincoConfigurateurBundle\IgnGincoConfigurateurBundle(),
		);

		if (in_array($this->getEnvironment(), array(
			'dev',
			'test'
		), true)) {
			$bundles[] = new Symfony\Bundle\DebugBundle\DebugBundle();
			$bundles[] = new Symfony\Bundle\WebProfilerBundle\WebProfilerBundle();
			$bundles[] = new Sensio\Bundle\DistributionBundle\SensioDistributionBundle();
			$bundles[] = new Sensio\Bundle\GeneratorBundle\SensioGeneratorBundle();
		}

		return $bundles;
	}

	public function registerContainerConfiguration(LoaderInterface $loader) {
		$loader->load($this->getRootDir() . '/config/config_' . $this->getEnvironment() . '.yml');
	}
	
	public function getCacheDir() {
        return dirname(__DIR__).'/var/cache/'.$this->getEnvironment();
    }
	
    public function getLogDir() {
        return dirname(__DIR__).'/var/logs';
    }
}
