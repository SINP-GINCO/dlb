<?php
namespace Ign\Bundle\DlbBundle;

use Symfony\Component\HttpKernel\Bundle\Bundle;

class IgnDlbBundle extends Bundle {

	public function getParent() {
		return 'IgnGincoBundle';
	}
}
