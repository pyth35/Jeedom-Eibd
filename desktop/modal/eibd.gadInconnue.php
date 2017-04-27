<?php
if (!isConnect('admin')) {
    throw new Exception('401 Unauthorized');
}
include_file('3rdparty', 'jquery.tablesorter/theme.bootstrap', 'css');
include_file('3rdparty', 'jquery.tablesorter/jquery.tablesorter.min', 'js');
include_file('3rdparty', 'jquery.tablesorter/jquery.tablesorter.widgets.min', 'js');
?>
<a class="btn btn-success btn-xs Gad pull-right" data-action="newEqlogic">
	<i class="fa fa-check-circle"></i>
	{{Créer un équipement}}
</a>
<table id="table_GadInconue" class="table table-bordered table-condensed tablesorter">
    <thead>
        <tr>
            <th>{{Source}}</th>
            <th>{{Destination}}</th>
            <th>{{Data Point Type}}</th>
            <th>{{Derniere valeur}}</th>
            <th>{{Action sur cette adresse de groupe}}</th>
        </tr>
    </thead>
    <tbody></tbody>
</table>
<script>
initTableSorter();
getKnxGadInconue();
function getKnxGadInconue () {
	$.ajax({
		type: 'POST',
	async: false,
	url: 'plugins/eibd/core/ajax/eibd.ajax.php',
		data: {
			action: 'getCacheGadInconue',
		},
		dataType: 'json',
		global: false,
		error: function(request, status, error) {
			setTimeout(function() {
				getKnxGadInconue()
			}, 100);
		},
		success: function(data) {
			if (data.state != 'ok') {
				$('#div_alert').showAlert({message: data.result, level: 'danger'});
				return;
			}
			$('#table_GadInconue tbody').html('');
			jQuery.each(jQuery.parseJSON(data.result),function(key, value) {
				$('#table_GadInconue tbody').append($("<tr>")
					.append($("<td>").text(value.AdressePhysique))
					.append($("<td>").text(value.AdresseGroupe))
					.append($("<td>").text(value.DataPointType))
					.append($("<td>").text(value.valeur))
					.append($("<td>")
						.append($('<a class="btn btn-danger btn-xs Gad pull-right" data-action="remove">')
							.append($('<i class="fa fa-minus-circle">'))
							.text('{{Supprimer}}'))
						.append($('<a class="btn btn-primary btn-xs Gad pull-right" data-action="addEqLogic">')
							.append($('<i class="fa fa-check-circle">'))
							.text('{{Ajouter a un equipement}}')));
			});				
			$('#table_GadInconue').trigger('update');
			if ($('#md_modal').dialog('isOpen') === true) {
				setTimeout(function() {
					getKnxGadInconue()
				}, 1000);
			}
		}
	});
}
$('body').on('click', '.Gad[data-action=addEqLogic]', function(){
	var gad=$(this).closest('tr').find('td:eq(1)').text();
	jeedom.eqLogic.getSelectModal({},function (result) {
		removeInCache(gad,result.id);
	}); 
	$(this).closest('tr').remove();
});
$('body').on('click', '.Gad[data-action=newEqlogic]', function(){
	$('#md_modal').dialog({
		title: "{{Création d'un équipement avec template}}",
		height: 780,
		width: 1024});
	$('#md_modal').load('index.php?v=d&modal=eibd.newTemplateEqLogic&plugin=eibd&type=eibd').dialog('open');
	/*var gad=$(this).closest('tr').find('td:eq(1)').text();
	removeInCache(gad,"new");
	$(this).closest('tr').remove();*/
});
$('body').on('click', '.Gad[data-action=remove]', function(){
	var gad=$(this).closest('tr').find('td:eq(1)').text();
	removeInCache(gad, false);
	$(this).closest('tr').remove();
});	
function removeInCache(gad, destination){
	$.ajax({
		type: 'POST',
		async: false,
		url: 'plugins/eibd/core/ajax/eibd.ajax.php',
		data: {
			action: 'setCacheGadInconue',
			gad:gad,
			eqLogic:destination
		},
		dataType: 'json',
		global: false,
		error: function(request, status, error) {},
		success: function(data) {
			if (data.state != 'ok') {
				$('#div_alert').showAlert({message: data.result, level: 'danger'});
				return;
			}
			if(data.result != false){
				bootbox.confirm('{{Souhaitez vous aller a la page de configuration de l\'équipement}}', function (result) {
					if (result)
						$(location).attr('href',$(location).attr('href')+'&id='+data.result)
				});
			}
		}
	});
}
</script>
