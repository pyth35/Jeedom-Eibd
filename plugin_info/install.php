<?php
require_once dirname(__FILE__) . '/../../../core/php/core.inc.php';

function eibd_install() {
	log::add('eibd','debug','Lancement du scripte de mise a  jours des Flags');
	foreach(eqLogic::byType('eibd') as $eqLogic){
		foreach($eqLogic->getCmd() as $cmd){
			if(isset($cmd->getConfiguration('eventOnly') && $cmd->getConfiguration('eventOnly')){
				log::add('eibd','debug','Remplacement du Flags eventOnly  par FlagWrite et FlagUpdate sur la commande '.$cmd->getHumaneName());
				$cmd->setConfiguration('FlagWrite',true);
				$cmd->setConfiguration('FlagUpdate',true);
			}
			if(isset($cmd->getConfiguration('init') && $cmd->getConfiguration('init')){
				log::add('eibd','debug','Remplacement du Flags init  par FlagInit sur la commande '.$cmd->getHumaneName());
				$cmd->setConfiguration('FlagInit',true);
			}
			if(isset($cmd->getConfiguration('transmitReponse') && $cmd->getConfiguration('transmitReponse')){
				log::add('eibd','debug','Remplacement du Flags transmitReponse par FlagRead sur la commande '.$cmd->getHumaneName());
				$cmd->setConfiguration('FlagRead',true);
				$cmd->setValue($cmd->getConfiguration('ObjetTransmit'));
			}
			$cmd->save();
		}
	}
}
function eibd_update() {
	log::add('eibd','debug','Lancement du scripte de mise a  jours des Flags');
	foreach(eqLogic::byType('eibd') as $eqLogic){
		foreach($eqLogic->getCmd() as $cmd){
			if(isset($cmd->getConfiguration('eventOnly') && $cmd->getConfiguration('eventOnly')){
				log::add('eibd','debug','Remplacement du Flags eventOnly  par FlagWrite et FlagUpdate sur la commande '.$cmd->getHumaneName());
				$cmd->setConfiguration('FlagWrite',true);
				$cmd->setConfiguration('FlagUpdate',true);
			}
			if(isset($cmd->getConfiguration('init') && $cmd->getConfiguration('init')){
				log::add('eibd','debug','Remplacement du Flags init  par FlagInit sur la commande '.$cmd->getHumaneName());
				$cmd->setConfiguration('FlagInit',true);
			}
			if(isset($cmd->getConfiguration('transmitReponse') && $cmd->getConfiguration('transmitReponse')){
				log::add('eibd','debug','Remplacement du Flags transmitReponse par FlagRead sur la commande '.$cmd->getHumaneName());
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
