<?php
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
  if (init('action') == 'AppliTemplate') {
		$EqLogic=eqLogic::byId(init('id'));
		if (is_object($EqLogic)){
			$EqLogic->applyModuleConfiguration(init('template'));
		}
		ajax::success(true);
	}
   throw new Exception(__('Aucune methode correspondante à : ', __FILE__) . init('action'));
    /*     * *********Catch exeption*************** */
} catch (Exception $e) {
    ajax::error(displayExeption($e), $e->getCode());
}
?>
