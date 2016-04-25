<?php
if (!isConnect('admin')) {
    throw new Exception('401 Unauthorized');
}
include_file('3rdparty', 'jquery.tablesorter/theme.bootstrap', 'css');
include_file('3rdparty', 'jquery.tablesorter/jquery.tablesorter.min', 'js');
include_file('3rdparty', 'jquery.tablesorter/jquery.tablesorter.widgets.min', 'js');
?>
<!--div>
	Sélectionner le nombre de ligne affichée
	<select id="NbLigne">
		<option value=20>20</option>
		<option value=30>30</option>
		<option value=40>40</option>
		<option value=50>50</option>
		<option value=60>60</option>
		<option value=70>70</option>
		<option value=80>80</option>
		<option value=90>90</option>
		<option value=100>100</option>
	</select>
</div>
<div class="tempLog"></div-->
<table id="table_BusMonitor" class="table table-bordered table-condensed tablesorter">
    <thead>
        <tr>
            <th>{{Date}}</th>
            <th>{{Mode}}</th>
            <th>{{Source}}</th>
            <th>{{Destination}}</th>
            <th>{{Data}}</th>
            <th>{{Valeur}}</th>
        </tr>
    </thead>
    <tbody></tbody>
</table>
<script>
initTableSorter();
getKnxBusMonitor();
function getKnxBusMonitor () {
	$.ajax({
		type: 'POST',
	async: false,
	url: 'plugins/eibd/core/ajax/eibd.ajax.php',
		data: {
			action: 'getCacheMonitor',
		},
		dataType: 'json',
		global: false,
		error: function(request, status, error) {
			setTimeout(function() {
				getKnxBusMonitor()
			}, 100);
		},
		success: function(data) {
			if (data.state != 'ok') {
				$('#div_alert').showAlert({message: data.result, level: 'danger'});
				return;
			}
			$('#table_BusMonitor tbody').html('');
			//alert(data.result);
			var monitors=jQuery.parseJSON(data.result);
			jQuery.each(monitors.reverse(),function(key, value) {
			  $('#table_BusMonitor tbody').append($("<tr>")
					.append($("<td>").text(value.datetime))
					.append($("<td>").text(value.monitor.Mode))
					.append($("<td>").text(value.monitor.AdressePhysique))
					.append($("<td>").text(value.monitor.AdresseGroupe))
					.append($("<td>").text(value.monitor.data))
					.append($("<td>").text(value.monitor.valeur)));
			});				
			$('#table_BusMonitor').trigger('update');
				setTimeout(function() {
					getKnxBusMonitor()
				}, 100);
			
		}
	});
}		   
</script>
		