<?php
require_once dirname(__FILE__) . '/../../../core/php/core.inc.php';

function eibd_install() {
	exec('sudo rm /etc/default/eibd.out');
	exec('sudo rm /etc/init.d/eibd');
	exec('sudo rm /etc/systemd/system/eibd.service');
	foreach(eqLogic::byType('eibd') as $Equipement){
		foreach($Equipement->getCmd() as $Commande){
			$Commande->setConfiguration('eventOnly',$Commande->getEventOnly());
			$Commande->setEventOnly(1);
			if ($Commande->getConfiguration('init')=='')
				$Commande->setConfiguration('init',1);
			if ($Commande->getConfiguration('KnxObjectGad')!=''){
				$Commande->setLogicalId($Commande->getConfiguration('KnxObjectGad'));
				$Commande->setConfiguration('KnxObjectGad',null);
			}
			if ($Commande->getConfiguration('transmitReponse')==''){
				$Commande->setConfiguration('transmitReponse',0);
			}
			if ($Commande->getConfiguration('subTypeAuto')==''){
				$Commande->setConfiguration('subTypeAuto',0);
			}
			if ($Commande->getConfiguration('noBatterieCheck')==''){
				$Commande->setConfiguration('noBatterieCheck',0);
			}
			$Commande->save();
		}
	}
}

function eibd_update() {
	exec('sudo rm /etc/default/eibd.out');
	exec('sudo rm /etc/init.d/eibd');
	exec('sudo rm /etc/systemd/system/eibd.service');
	foreach(eqLogic::byType('eibd') as $Equipement){
		foreach($Equipement->getCmd() as $Commande){
			$Commande->setConfiguration('eventOnly',$Commande->getEventOnly());
			$Commande->setEventOnly(1);
			if ($Commande->getConfiguration('init')=='')
				$Commande->setConfiguration('init',1);
			if ($Commande->getConfiguration('KnxObjectGad')!=''){
				$Commande->setLogicalId($Commande->getConfiguration('KnxObjectGad'));
				$Commande->setConfiguration('KnxObjectGad',null);
			}
			if ($Commande->getConfiguration('transmitReponse')==''){
				$Commande->setConfiguration('transmitReponse',0);
			}
			if ($Commande->getConfiguration('subTypeAuto')==''){
				$Commande->setConfiguration('subTypeAuto',0);
			}
			if ($Commande->getConfiguration('noBatterieCheck')==''){
				$Commande->setConfiguration('noBatterieCheck',0);
			}
			$Commande->save();
		}
	}
}

function eibd_remove() {
}
?>