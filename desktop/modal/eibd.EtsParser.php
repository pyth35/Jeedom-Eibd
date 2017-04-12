<?php
if (!isConnect('admin')) {
    throw new Exception('401 Unauthorized');
}
?>
<div class="row">  	
	<div class="col-md-12"> 
		<p>Cette option du plugin permet de configurer automatiquement votre installation sous Jeedom.</p>
		<p><b>Attention :</b></p>
		<p>Cette opération peut etre longue.</p>
		<p>Il est possible que tous les possibilitées de programation ne soit pas pris en compte, il est impératif de verifier et compléter la configuration a la fin de l\'execution</p>
		<form class="form-horizontal" onsubmit="return false;"> 
			<div class="form-group"> 
				<label class="col-md-4 control-label">{{Nom}}</label> 
				<input type="file" name="Knxproj" id="Knxproj" data-url="plugins/eibd/core/ajax/eibd.ajax.php?action=EtsParser" placeholder="{{Ficher export ETS}}" class="form-control input-md"/>
				<div class="col-md-4"></div> 
			</div> 
			<!--div class="form-group"> 
				<label class="col-md-4 control-label">{{Création de l\'arboressance ETS en objet Jeedom}}</label> 
				<div class="col-md-4">
					<input type="checkbox" name="CreateObject"  disabled/> 
				</div> 
			</div--> 
		</form> 
	</div>  
</div>
<script>
	$('#Knxproj').fileupload({
		dataType: 'json',
		replaceFileInput: false,
		done: function (e, data) {
			if (data.result.state != 'ok') {
				$('#div_alert').showAlert({message: data.result.result, level: 'danger'});
				return;
				$('#md_modal').dialog({
					title: "{{Importer les Gad inconnue}}",
					height: 800,
					width: 1024});
				$('#md_modal').load('index.php?v=d&modal=eibd.gadInconnue&plugin=eibd&type=eibd').dialog('open');
			$//('#div_alert').showAlert({message: '{{L\'intégration par l\export ETS est terminé avec succes}}', level: 'success'});
			}
		}
	});
</script>
