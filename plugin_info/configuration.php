<?php
require_once dirname(__FILE__) . '/../../../core/php/core.inc.php';
include_file('core', 'authentification', 'php');
if (!isConnect()) {
    include_file('desktop', '404', 'php');
    die();
}
?>
 
<form class="form-horizontal">
    <fieldset>
			<div class="form-group">
				<label class="col-lg-4 control-label">Adresse IP du démon :</label>
				<div class="col-lg-4">
					<input class="configKey form-control" data-l1key="EibdHost" />
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-4 control-label">Port du démon </label>
				<div class="col-lg-4">
					<input class="configKey form-control" data-l1key="EibdPort" />
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-4 control-label" >Type de passerelle</label>
				<div class="col-lg-4">
					<select class="configKey form-control" data-l1key="TypeKNXgateway" >
						<option value="ft12">FT12 - Ligne serie</option>
						<option value="bcu1s">BCU1 - kernel driver</option>
						<option value="tpuarts">TPUART - kernel driver Linux 2.6</option>
						<option value="ip">IP - EIBnet/IP Routing protocol</option>
						<option value="ipt">IPT - EIBnet/IP Tunneling protocol</option>
						<option value="iptn">IPTN - EIBnet/IP NAT mode</option>
						<option value="usb">USB - KNX USB interface</option>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-4 control-label">Adresse de la passerelle</label>
				<div class="col-lg-4">
					<input class="configKey form-control" data-l1key="KNXgateway" />
					<a class="btn btn-primary SearchGatway"><i class="fa fa-search"></i>Rechercher</a>
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-4 control-label">Adresse physique du démon</label>
				<div class="col-lg-4">
					<input class="configKey form-control" data-l1key="EibdGad" />
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-4 control-label">Adresse de groupe 2 ou 3 niveau</label>
				<div class="col-lg-4">
					<input type="checkbox" class="configKey bootstrapSwitch" data-label-text="{{3 niveau}}" data-l1key="level"/>
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-4 control-label">Ajouter automatiquement les equipements </label>
				<div class="col-lg-4">
					<input type="checkbox" class="configKey bootstrapSwitch" data-label-text="{{Automatique}}" data-l1key="autoAddDevice"/>
				</div>
			</div>
			<div class="form-group">
				<label class="col-lg-4 control-label">Initialiser les retours d'etat au lancement</label>
				<div class="col-lg-4">
					<input type="checkbox" class="configKey bootstrapSwitch" data-label-text="{{Activer}}" data-l1key="initInfo"/>
				</div>
			</div>
		</div>
   </fieldset>
</form>
<script>
var ConfKnx=null;
/*$('.configKey[data-l1key=KNXgateway]').on('change',function(){
	$('.configKey[data-l1key=TypeKNXgateway]').trigger('change');
});*/
$.ajax({
	async: false,
	type: 'POST',
	url: 'plugins/eibd/core/ajax/eibd.ajax.php',
	data:
		{
		action: 'KnxEquipements'
		},
	dataType: 'json',
	global: false,
	error: function(request, status, error) {},
	success: function(data) {
		if (data.state != 'ok') {
			$('#div_alert').showAlert({message: data.result, level: 'danger'});
			return;
		}
		if(data.result.length > 0)
		{
			bootbox.confirm('{{Voulez vous importer la configuration du plugin Knx ? }}', function (result) {
				if (result) {
					ConfKnx=data.result
					$('#md_modal').dialog({
						title: "{{Importer la configuration du plugin KNX}}",
						position:{ my: "center", at: "center", of: window },
						resizable: false,
						width: 400,
						height: 200,
					});
					$('#md_modal').load('index.php?v=d&plugin=eibd&modal=eibd.ImportKnxConf').dialog('open');
				}
			});
		}
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