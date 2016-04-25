<?php

/* This file is part of Jeedom.
 *
 * Jeedom is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Jeedom is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Jeedom. If not, see <http://www.gnu.org/licenses/>.
 */

try {
    require_once dirname(__FILE__) . '/../../../../core/php/core.inc.php';
    include_file('core', 'authentification', 'php');
	include_file('core', 'dpt', 'class', 'eibd');

    if (!isConnect('admin')) {
        throw new Exception(__('401 - Accès non autorisé', __FILE__));
    }
	if (init('action') == 'SearchGatway') {
		switch(init('type')){
			case 'ip':
				$result=eibd::SearchBroadcastGateway();
				ajax::success($result['KnxIpGateway']);
			break;
			case 'ipt':
				$result=eibd::SearchBroadcastGateway();
				ajax::success($result['KnxIpGateway'].':'.$result['KnxPortGateway']);
			break;
			case 'iptn':
				$result=eibd::SearchBroadcastGateway();
				ajax::success($result['KnxIpGateway'].':'.$result['KnxPortGateway']);
			break;
			/*case 'ft12':
			break;
			case 'bcu1':
			break;
			case 'tpuarts':
			break;
			case 'usb':
			break;*/
			default:
				ajax::success(false);
			break;
		}
	}
	if (init('action') == 'getAllDpt') {
		$All_DPT=Dpt::All_DPT();
		 ajax::success(json_encode($All_DPT));
	}
	if (init('action') == 'KnxEquipements') {
		$Equipements=array();
		foreach (eqLogic::byType('knx') as $Equipement)
			$Equipements[]=$Equipement->getId();
		ajax::success($Equipements);
	}
	if (init('action') == 'KnxToEibd') {
		$Equipements=eqLogic::byId(init('id'));
		$Equipements->setEqType_name('eibd');
		$Equipements->save();
		foreach($Equipements->getCmd() as $Commande)
		{
			$Commande->setEqType('eibd');
			$Commande->save();
		}
		ajax::success(true);
	}
	if (init('action') == 'Read') {
		$Commande=cmd::byLogicalId(init('Gad'))[0];
		if (is_object($Commande)){
			$ga=$Commande->getLogicalId();
			$dpt=$Commande->getConfiguration('KnxObjectType');
			$inverse=$Commande->getConfiguration('inverse');
			log::add('eibd', 'debug', 'Lecture sur le bus de l\'adresse de groupe : '. $ga);
			$DataBus=eibd::EibdRead($ga);	
			$option=null;
			if ($dpt == '235.001')
				{
				$option=array(
					"Tarif"=>$Commande->getConfiguration('option1'),
					"validityTarif"=>$Commande->getConfiguration('option2'),
					"validityActiveElectricalEnergy"=>$Commande->getConfiguration('option3')
					);
				}
			$BusValue=Dpt::DptSelectDecode($dpt, $DataBus, $inverse,$option);
			$Commande->setCollectDate('');
			$Commande->event($BusValue);
			$Commande->save();
			ajax::success($BusValue);
			//ajax::success(true);
		}
		ajax::success(false);
	}
	if (init('action') == 'getCacheMonitor') {
		ajax::success(cache::byKey('eibd::Monitor')->getValue('[]'));
	}
	if (init('action') == 'EtsParser') {
		if (isset($_FILES['Knxproj'])){
			ajax::success(eibd::ParserEtsFile($_FILES['Knxproj']['tmp_name']));
		}
	}
   throw new Exception(__('Aucune methode correspondante à : ', __FILE__) . init('action'));
    /*     * *********Catch exeption*************** */
} catch (Exception $e) {
    ajax::error(displayExeption($e), $e->getCode());
}
?>
