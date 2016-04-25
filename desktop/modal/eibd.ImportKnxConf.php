<?php
if (!isConnect('admin')) {
    throw new Exception('401 Unauthorized');
}
?>
<div class="ProgessImport">
	<p>Merci de patienter jusqu'a la fin de la conversion</p>
	<p>Progression <strong>0%</strong></p>
	<progress value="0">0%</progress>
	<div>
		<a class="btn btn-warning btn-xs StartConvertion"><i class="fa fa-cloud-upload"></i> Démarrer la conversion</a>
	</div>
</div>
<script>
$('.ProgessImport progress').attr('max',ConfKnx.length);
$('.StartConvertion').on('click',function(){
	for (var i in ConfKnx) {
		$.ajax({
			async: false,
			type: 'POST',
			url: 'plugins/eibd/core/ajax/eibd.ajax.php',
			data:
				{
				action: 'KnxToEibd',
				id:ConfKnx[i]
				},
			dataType: 'json',
			global: false,
			error: function(request, status, error) {},
			success: function(data) {
				if (data.state != 'ok') {
					$('#div_alert').showAlert({message: data.result, level: 'danger'});
					return;
				}
				var PerCent=Math.round((1+parseInt(i))*100/ConfKnx.length);
				$('.ProgessImport progress').attr('value',parseInt(i)+1);
				$('.ProgessImport progress').text(PerCent+'%');
				$('.ProgessImport strong').text(PerCent+'%');
			}
		});
	}
});
</script>
		