<?php
require_once dirname(__FILE__) . '/../../../core/php/core.inc.php';
include_file('core', 'authentification', 'php');
if (!isConnect()) {
    include_file('desktop', '404', 'php');
    die();
}
?>
 <div class="col-sm-6">
	<form class="form-horizontal">
		<legend>Connexion au Bus KNX</legend>
		<fieldset>
			<div class="form-group">
				<label class="col-lg-4 control-label" >{{Interface de communication :}}</label>
				<div class="col-lg-4">
					<select class="configKey form-control" data-l1key="KnxSoft" >
						<option value="knxd">KNXd</option>
						<option value="eibd">EIBD</option>
						<option value="">Manuel</option>
					</select>
				</div>
			</div>
			<div class="form-group NoSoft">
				<label class="col-lg-4 control-label">{{Adresse IP :}}</label>
				<div class="col-lg-4">
					<input class="configKey form-control" data-l1key="EibdHost" />
				</div>
			</div>
			<div class="form-group NoSoft">
				<label class="col-lg-4 control-label">{{Port :}}</label>
				<div class="col-lg-4">
					<input class="configKey form-control" data-l1key="EibdPort" />
				</div>
			</div>
		</fieldset>
	</form>
</div>
 <div class="col-sm-6 Soft">
	<form class="form-horizontal">
		<legend>Configuration du démon</legend>
		<fieldset>
			<div class="form-group">
				<label class="col-lg-4 control-label" >{{Type de passerelle}}</label>
				<div class="col-lg-4">
					<select class="configKey form-control" data-l1key="TypeKNXgateway" >
						<option value="ft12">{{FT12 - Ligne serie}}</option>
						<option value="bcu1s">{{BCU1 - kernel driver}}</option>
						<option value="tpuarts">{{TPUART - kernel driver Linux 2.6}}</option>
						<option value="ip">{{IP - EIBnet/IP Routing protocol}}</option>
						<option value="ipt">{{IPT - EIBnet/IP Tunneling protocol}}</option>
						<option value="iptn">{{IPTN - EIBnet/IP NAT mode}}</option>
						<option value="usb">{{USB - KNX USB interface}}</option>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-4 control-label">{{Adresse de la passerelle}}</label>
				<div class="col-lg-4">
					<input class="configKey form-control" data-l1key="KNXgateway" />
					<a class="btn btn-primary SearchGatway"><i class="fa fa-search"></i>{{Rechercher}}</a>
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-4 control-label">{{Adresse physique du démon}}</label>
				<div class="col-lg-4">
					<input class="configKey form-control" data-l1key="EibdGad" />
				</div>
			</div>
		</fieldset>
	</form>
</div>
 <div class="col-sm-6">
	<form class="form-horizontal">
		<legend>Option</legend>
		<fieldset>
			<div class="form-group">
				<label class="col-lg-4 control-label">{{Adresse de groupe 2 ou 3 niveau}}</label>
				<div class="col-lg-4">
					<label class="checkbox-inline"><input type="checkbox" class="configKey" data-l1key="level" checked/>{{3 niveau}}</label>
				</div>
			</div>
			<!--div class="form-group">
				<label class="col-lg-4 control-label">{{Ajouter automatiquement les equipements}}</label>
				<div class="col-lg-4">
					<label class="checkbox-inline"><input type="checkbox" class="configKey" data-l1key="autoAddDevice" checked/>{{Automatique}}</label>
				</div>
			</div-->
			<div class="form-group">
				<label class="col-lg-4 control-label">{{Initialiser les retours d'etat au lancement}}</label>
				<div class="col-lg-4">
					<label class="checkbox-inline"><input type="checkbox" class="configKey" data-l1key="initInfo" checked/>{{Activer}}</label>
				</div>
			</div>
		</fieldset>
	</form>
</div>
<script>
	
$('.configKey[data-l1key=KnxSoft]').on('change',function(){
	switch($(this).val()){
		case 'knxd':
		case 'eibd':
			$('.Soft').show();
			$('.NoSoft').hide();
		break;
		default:
			$('.Soft').hide();
			$('.NoSoft').show();
		break;
	}
});
$('.SearchGatway').on('click',function(){
//$('.configKey[data-l1key=TypeKNXgateway]').on('change',function(){
	if($('.configKey[data-l1key=KNXgateway]').val()==''){
		$.ajax({
			async: false,
			type: 'POST',
			url: 'plugins/eibd/core/ajax/eibd.ajax.php',
			data:
				{
				action: 'SearchGatway',
				type: $('.configKey[data-l1key=TypeKNXgateway]').val(),
				},
			dataType: 'json',
			global: false,
			error: function(request, status, error) {},
			success: function(data) {
				if (data.state != 'ok') {
					$('#div_alert').showAlert({message: data.result, level: 'danger'});
					return;
				}
				if(data.result)
				{
					$('.configKey[data-l1key=KNXgateway]').val(data.result);
				}
			}
		});
	}
});
</script>
