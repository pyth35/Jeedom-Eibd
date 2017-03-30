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
            <th>{{Source}}</th>
            <th>{{Destination}}</th>
            <th>{{Data Point Type}}</th>
            <th>{{Parametre}}</th>
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
					.append($("<td>").text(value.dpt))
					.append($("<td>")));
			});				
			/*$('#table_GadInconue').trigger('update');
				setTimeout(function() {
					getKnxGadInconue()
				}, 100);*/
			
		}
	});
}		   
</script>
