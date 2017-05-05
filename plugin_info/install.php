<?php
require_once dirname(__FILE__) . '/../../../core/php/core.inc.php';

function eibd_install() {
}
function eibd_update() {
	foreach(eqLogic::byType('eibd') as $eqLogic){
		foreach($eqLogic->getCmd() as $cmd){
			if(isset($cmd->getConfiguration('eventOnly') && $cmd->getConfiguration('eventOnly')){
				$cmd->setConfiguration('FlagWrite',true);
				$cmd->setConfiguration('FlagUpdate',true);
			}
			if(isset($cmd->getConfiguration('init') && $cmd->getConfiguration('init')){
				$cmd->setConfiguration('FlagInit',true);
			}
			if(isset($cmd->getConfiguration('transmitReponse') && $cmd->getConfiguration('transmitReponse')){
				$cmd->setConfiguration('FlagRead',true);
				$cmd->setValue($cmd->getConfiguration('ObjetTransmit'));
			}
			$cmd->save();
		}
	}
}
function eibd_remove() {
}
?>
