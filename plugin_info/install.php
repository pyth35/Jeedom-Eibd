<?php
require_once dirname(__FILE__) . '/../../../core/php/core.inc.php';
function eibd_install() {
	log::add('eibd','debug','Instalation'); 
}
function eibd_update() {
	log::add('eibd','debug','Lancement du scripte de mise a  jours des Flags'); 
	foreach(eqLogic::byType('eibd') as $eqLogic){ 
		foreach($eqLogic->getCmd() as $cmd){ 
			/*if(!isset($cmd->getConfiguration('FlagWrite')) && !isset($cmd->getConfiguration('FlagUpdate')) && isset($cmd->getConfiguration('eventOnly'))){ 
				//log::add('eibd','debug','Remplacement du Flags eventOnly  par FlagWrite et FlagUpdate sur la commande '.$cmd->getHumanName()); 
				//$cmd->setConfiguration('FlagWrite',true); 
				//$cmd->setConfiguration('FlagUpdate',true); 
			} */
			/*if(!isset($cmd->getConfiguration('FlagInit')) && isset($cmd->getConfiguration('init'))){ 
				log::add('eibd','debug','Remplacement du Flags init  par FlagInit sur la commande '.$cmd->getHumanName()); 
				//$cmd->setConfiguration('FlagInit',true); 
			} 
			if(!isset($cmd->getConfiguration('FlagRead')) && isset($cmd->getConfiguration('transmitReponse'))){ 
				log::add('eibd','debug','Remplacement du Flags transmitReponse par FlagRead sur la commande '.$cmd->getHumanName()); 
				//$cmd->setConfiguration('FlagRead',true); 
				//$cmd->setValue($cmd->getConfiguration('ObjetTransmit')); 
			} */
			//$cmd->save(); 
		}
	}
}
?>
