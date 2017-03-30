<?php
if (!isConnect('admin')) {
    throw new Exception('401 Unauthorized');
}
include_file('3rdparty', 'jquery.tablesorter/theme.bootstrap', 'css');
include_file('3rdparty', 'jquery.tablesorter/jquery.tablesorter.min', 'js');
include_file('3rdparty', 'jquery.tablesorter/jquery.tablesorter.widgets.min', 'js');
?>
<table id="table_GadInconue" class="table table-bordered table-condensed tablesorter">
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
			$('#table_BusMonitor tbody').html('');
			//alert(data.result);
			var monitors=jQuery.parseJSON(data.result);
			jQuery.each(monitors.reverse(),function(key, value) {
			  $('#table_GadInconue tbody').append($("<tr>")
					.append($("<td>").text(value.datetime))
					.append($("<td>").text(value.monitor.Mode))
					.append($("<td>").text(value.monitor.AdressePhysique))
					.append($("<td>").text(value.monitor.AdresseGroupe))
					.append($("<td>").text(value.monitor.data))
					.append($("<td>").text(value.monitor.valeur)));
			});				
			$('#table_GadInconue').trigger('update');
				setTimeout(function() {
					getKnxGadInconue()
				}, 100);
			
		}
	});
}		   
</script>
