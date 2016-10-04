var AllDpt=null;
var DptSelectorOption=null;
$(function(){
	UpdateVar();
	if (getUrlVars('wizard') == 1) {
		$('#md_modal').dialog({
			title: "{{Wizard}}",
			height: 700,
			width: 850});
		wizard();
		$('#md_modal').dialog('open');
		}
	$('.Wizard').on('click', function() {
		jeedom.eqLogic.save({
			type: eqType ,
			eqLogics: [{name: 'Nouvel Equipement'}],
			error: function (error) {
				  $('#div_alert').showAlert({message: error.message, level: 'danger'});
				},
			success: function (eqLogicData) {
				var vars = getUrlVars();
				var url = 'index.php?';
				for (var i in vars) {
					if (i != 'id' && i != 'saveSuccessFull' && i != 'removeSuccessFull') {
						url += i + '=' + vars[i].replace('#', '') + '&';
					}
				}
				url += 'id=' + eqLogicData.id + '&saveSuccessFull=1&wizard=1';
				modifyWithoutSave = false;
				loadPage(url);
			}
		});
	});
	$('.BusMoniteur').on('click', function() {
		$('#md_modal').dialog({
			title: "{{Bus Moniteur}}",
			height: 700,
			width: 850});
		$('#md_modal').load('index.php?v=d&modal=eibd.busmoniteur&plugin=eibd&type=eibd').dialog('open');
	});
	$('.Ets4Parser').on('click', function() {
		$('#md_modal').dialog({
			title: "{{Ajout de vos équipement par ETS}}",
			height: 700,
			width: 850});
		$('#md_modal').load('index.php?v=d&modal=eibd.EtsParser&plugin=eibd&type=eibd').dialog('open');

	});
	$('.EibdParametre').on('click', function() {
		$('#md_modal').dialog({
			title: "{{Parametre de connexion EIB}}",
			height: 700,
			width: 850});
		$('#md_modal').load('index.php?v=d&modal=eibd.parametre&plugin=eibd&type=eibd').dialog('open');
	});
	$('body').on( 'click','.bt_selectCmdExpression', function() {
		var _this=this;
		$(this).value()
		jeedom.cmd.getSelectModal({cmd: {type: 'info'},eqLogic: {eqType_name : ''}}, function (result) {
			switch($(_this).attr('id'))
				{
				case "ObjetTransmit":
					$(_this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=ObjetTransmit]').val(result.human);
				break;
				case "option1":
					$(_this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=option1]').val(result.human);
				break;
				case "option2":
					$(_this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=option2]').val(result.human);
				break;
				case "option3":
					$(_this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=option3]').val(result.human);
				break;
				case "option4":
					$(_this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=option4]').val(result.human);
				break;
				case "option5":
					$(_this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=option5]').val(result.human);
				break;
				default:
					$(_this).closest('.cmd').find('.cmdAttr[data-l1key=value]').val(result.human);
				break;
				};
			});
		});  
	$('body').on( 'click','.bt_read', function() {
		$.ajax({
			type: 'POST',            
			async: false,
			url: 'plugins/eibd/core/ajax/eibd.ajax.php',
			data:
				{
				action: 'Read',
				Gad:$(this).closest('.cmd').find('.cmdAttr[data-l1key=logicalId]').val(),
				},
			dataType: 'json',
			global: false,
			error: function(request, status, error) {},
			success: function(data) {
				if (!data.result)
					$('#div_alert').showAlert({message: 'Aucun message recu', level: 'error'});
				else
					$('#div_alert').showAlert({message: 'Message recu', level: 'success'});
				}
		});
	});
	$('body').on('keyup','.cmd .cmdAttr[data-l1key=logicalId]', function() {
		var lastCar=$(this).val().substr(-1);
		var doublelastCar=$(this).val().substr(-2);
		var oldvalue=$(this).val().substring(0,$(this).val().length-1);
		if(!$.isNumeric(lastCar) && lastCar!='/' || doublelastCar=='//')
			$(this).val(oldvalue);
	}); 
	$('body').on('change','.cmd .cmdAttr[data-l1key=configuration][data-l2key=KnxObjectType]', function() {
		switch($(this).val())
			{
			case '229.001':
				$(this).closest('.cmd').find('#groupoption1').show();
				$(this).closest('.cmd').find('#groupoption1').find('label').text('ValInfField');
				$(this).closest('.cmd').find('#groupoption2').show();
				$(this).closest('.cmd').find('#groupoption2').find('label').text('StatusCommande');
			break;
			case '235.001':
				$(this).closest('.cmd').find('#groupoption1').show();
				$(this).closest('.cmd').find('#groupoption1').find('label').text('Tarif');
				$(this).closest('.cmd').find('#groupoption2').show();
				$(this).closest('.cmd').find('#groupoption2').find('label').text('Validité du Tarif');
				$(this).closest('.cmd').find('#groupoption3').show();
				$(this).closest('.cmd').find('#groupoption3').find('label').text('Validité Energie');
				$(this).closest('.cmd').find('#groupoption4').hide();
				$(this).closest('.cmd').find('#groupoption5').hide();
			break;
			case 'x.001':
				$(this).closest('.cmd').find('#groupoption1').show();
				$(this).closest('.cmd').find('#groupoption1').find('label').text('Mode');
			break;
			default:
				$(this).closest('.cmd').find('#groupoption1').hide();
				$(this).closest('.cmd').find('#groupoption1').find('label').text('Option 1');
				$(this).closest('.cmd').find('#groupoption2').hide();
				$(this).closest('.cmd').find('#groupoption2').find('label').text('Option 2');
				$(this).closest('.cmd').find('#groupoption3').hide();
				$(this).closest('.cmd').find('#groupoption3').find('label').text('Option 3');
				$(this).closest('.cmd').find('#groupoption4').hide();
				$(this).closest('.cmd').find('#groupoption4').find('label').text('Option 4');
				$(this).closest('.cmd').find('#groupoption5').hide();
				$(this).closest('.cmd').find('#groupoption5').find('label').text('Option 5');
			break;
			}
		var valeur =$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').val();
		if ($(this).closest('.cmd').find('.cmdAttr[data-l1key=unite]').val() == '')
			$(this).closest('.cmd').find('.cmdAttr[data-l1key=unite]').val(DptUnit($(this).val()));
		if ($(this).closest('.cmd').find('.cmdAttr[data-l1key=type]').value() == "action" && $(this).closest('.cmd').find('.cmdAttr[data-l1key=subType]').value() == "other")
			{
			$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').remove();
			$(this).closest('.cmd').find('.parametre').append($('<select class="cmdAttr form-control input-sm" data-l1key="configuration" data-l2key="KnxObjectValue">').append(DptValue($(this).val())));
			$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue] option[value="'+valeur+'"]').prop('selected', true);
			}
		}); 
	$('body').on('change', '.cmd .cmdAttr[data-l1key=type]',function() 	{
		switch ($(this).value())
			{
			case "info":
				$(this).closest('.cmd').find('.RetourEtat').hide();
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=init]').parent().show();
				$(this).closest('.cmd').find('.bt_read').show();
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=transmitReponse]').parent().show();
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').hide();
				if($(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=transmitReponse]').is(':checked'))
					$(this).closest('.cmd').find('.ObjetTransmit').show();
				else
					$(this).closest('.cmd').find('.ObjetTransmit').hide();
			break;
			case "action":		
				$(this).closest('.cmd').find('.RetourEtat').show();
				$(this).closest('.cmd').find('.ObjetTransmit').hide();
				$(this).closest('.cmd').find('.bt_read').hide();
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=init]').parent().hide();
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=transmitReponse]').parent().hide();
				if ($(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectType]').val()!="")
					{
					var _this=$(this);
					var DPT = $(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectType]').val();
					var valeur =$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').val();
					var div =$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').parent();
					$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').remove();
					div.append($('<select class="cmdAttr form-control input-sm" data-l1key="configuration" data-l2key="KnxObjectValue">')
						.append(DptValue(DPT)));
					$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue] option[value="'+valeur+'"]')
						.prop('selected', true);
					}
			break;
			}
		});			
	$('body').on('change', '.cmd .cmdAttr[data-l1key=subType]',function() {
		switch ($(this).value())
		{
			case "numeric":
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=inverse]').show();
			break;
			case "binary":
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=inverse]').show();
			break;
			case "other":
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=inverse]').hide();
				if ($(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectType]').val()!="")
					{
					var _this=$(this);
					var DPT = $(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectType]').val();
					var valeur =$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').val();
					var div =$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').parent();
					$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').remove();
					div.append($('<select class="cmdAttr form-control input-sm" data-l1key="configuration" data-l2key="KnxObjectValue">')
						.append(DptValue(DPT)));
					$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue] option[value="'+valeur+'"]')
						.prop('selected', true);
					}
			break;
			default:
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=inverse]').hide();
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').hide();
			break;
		}
	});			
	$('body').on('switchChange.bootstrapSwitch change','.cmd .cmdAttr[data-l1key=configuration][data-l2key=transmitReponse]',function(){
		if($(this).is(':checked')){
			$(this).closest('.cmd').find('.ObjetTransmit').show();
		}else{
			$(this).closest('.cmd').find('.ObjetTransmit').hide();
		}
	});
	$('body').on('switchChange.bootstrapSwitch change','.cmd .cmdAttr[data-l1key=configuration][data-l2key=subTypeAuto]', function() {
			if($(this).is(':checked'))
			{
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=subType]').attr("disabled", true)
				var Dpt=$(this).closest('.cmd').find('.cmdAttr[data-l1key=configuration][data-l2key=KnxObjectType]').val();
				var type=$(this).closest('.cmd').find('.cmdAttr[data-l1key=type]').val();
				getDptSousType(Dpt,type);
			}
			else
			{
				$(this).closest('.cmd').find('.cmdAttr[data-l1key=subType]').attr("disabled", false)

			}
		});
	$("#table_cmd").sortable({axis: "y", cursor: "move", items: ".cmd", placeholder: "ui-state-highlight", tolerance: "intersect", forcePlaceholderSize: true});
	$(".eqLogicAttr[data-l1key=configuration][data-l2key=device]").html($(".eqLogicAttr[data-l1key=configuration][data-l2key=device] option").sort(function (a, b) {
		return a.text == b.text ? 0 : a.text < b.text ? -1 : 1
	}));
	$('.Template[data-action=add]').on('click', function () {
		if($('.Template[data-l1key=type]').val()!=""){
			$('.eqLogicAction[data-action=save]').trigger('click');
			$.ajax({
				type: 'POST',   
				url: 'plugins/eibd/core/ajax/eibd.ajax.php',
				data:
				{
					action: 'AppliTemplate',
					id:$('.eqLogicAttr[data-l1key=id]').val(),
					template:$('.Template[data-l1key=type]').val()
				},
				dataType: 'json',
				global: true,
				error: function(request, status, error) {},
				success: function(data) {
					window.location.reload();
				}
			});
		}
	});
});
function UpdateVar(){
	$.ajax({
		type: 'POST',            
		async: false,
		url: 'plugins/eibd/core/ajax/eibd.ajax.php',
		data:{
			action: 'getAllDpt'
		},
		dataType: 'json',
		global: false,
		error: function(request, status, error) {},
		success: function(data) {
			AllDpt=jQuery.parseJSON(data.result);
		}
	});
}
function DptUnit(Dpt)	{
	var result;
	$.each(AllDpt, function(key, value){
		$.each(value, function(key, value){
			if (key==Dpt)
				result=value.Unite;
		});
	});
	return result;
}
function getDptSousType(Dpt,type)	{
	var result;
	$.each(AllDpt, function(key, value){
		$.each(value, function(key, value){
			if (key==Dpt){
				if(type='info')
					result=value.InfoType;
				else
					result=value.ActionType;
			}
		});
	});
	return result;
}
function DptValue(Dpt){
	var result='<option value="">{{Imposer une valeur}}</option>';
	$.each(AllDpt, function(key, value){
		$.each(value, function(key, value){
			if (key==Dpt)
			{
				$.each(value.Valeurs, function(key, value){
					result+='<option value="'+key+'">{{'+value+'}}</option>';
				});
			}
		});
	});
	return result;
}
function OptionSelectDpt(AllDpt){
	DptSelectorOption='<option value="">{{Sélèctionner un DPT}}</option>';
	$.each(AllDpt, function(key, value){
		DptSelectorOption+= '<optgroup label="{{'+key+'}}">';
		$.each(value, function(key, value){
			DptSelectorOption+='<option value="'+key+'">{{'+key+' - '+value["Name"]+'}}</option>';
		});
	DptSelectorOption+='</optgroup>';
	});
	return DptSelectorOption;
	}
function addCmdToTable(_cmd) {
  if (!isset(_cmd)) {
        var _cmd = {};
    }
    if (!isset(_cmd.configuration)) {
        _cmd.configuration = {};
    }
	var tr =$('<tr class="cmd" data-cmd_id="' + init(_cmd.id) + '">');
  	tr.append($('<td>')
		.append($('<i class="fa fa-minus-circle pull-right cmdAction cursor" data-action="remove">'))
		.append($('<i class="fa fa-arrows-v pull-left cursor bt_sortable" style="margin-top: 9px;">')));
	tr.append($('<td class="wizard">')
		.append($('<div>')
			.append($('<input type="hidden" class="cmdAttr form-control input-sm" data-l1key="id">'))
			.append($('<input class="cmdAttr form-control input-sm" data-l1key="name" value="' + init(_cmd.name) + '" placeholder="{{Name}}" title="Name">')))
		.append($('<div>')
			.append($('<a class="cmdAction btn btn-default btn-sm" data-l1key="chooseIcon">')
				.append($('<i class="fa fa-flag">')).text('Icone'))
			.append($('<span class="cmdAttr" data-l1key="display" data-l2key="icon" style="margin-left : 10px;">'))));
	tr.append($('<td class="wizard">')
		.append($('<label>')
			.text('{{Data Point Type}}')
			.append($('<sup>')
				.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
					.attr('title','Selectionner le type de data KNX'))))
		.append($('<select class="cmdAttr form-control input-sm" data-l1key="configuration" data-l2key="KnxObjectType">')
			.append(OptionSelectDpt(AllDpt)))
		.append($('<label>')
			.text('{{Groupe d\'adresse}}')
			.append($('<sup>')
				.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
					.attr('title','Saisisez l\'adresse de groupe de votre commande KNX'))))
		.append($('<input class="cmdAttr form-control input-sm" data-l1key="logicalId" placeholder="{{GAD}}" title="GAD">')));
	tr.append($('<td class="expertModeVisible wizard">')
		.append($('<span>')
				.append($('<input type="checkbox" class="cmdAttr bootstrapSwitch" data-size="mini" data-label-text="{{Initialiser}}" data-l1key="configuration"  data-l2key="init"/>'))
				.append($('<sup>')
					.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
						.attr('title','Souhaitez vous initialiser cette commande au démarrage?  (Attention: Avant d\'activer cette option veillez a ce que dans ce groupe d\'adresse, le flag READ soit present'))))
		.append($('<span>')
				.append($('<input type="checkbox" class="cmdAttr bootstrapSwitch" data-size="mini" data-label-text="{{Evenement}}" data-l1key="configuration"  data-l2key="eventOnly" checked/>'))
				.append($('<sup>')
					.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
						.attr('title','Souhaitez vous que la valeur soit mise a jours par le bus monitor'))))
		.append($('<span>')
				.append($('<input type="checkbox" class="cmdAttr bootstrapSwitch" data-size="mini" data-label-text="{{Transmetre}}" data-l1key="configuration" data-l2key="transmitReponse">')))
				.append($('<sup>')
					.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
						.attr('title','Soutez vous transmetre une information sur ce groupe d\'adresse'))));	
	tr.append($('<td class="wizard">')
		.append($('<div class="ObjetTransmit">')
						.append($('<label>')
							.text('{{Objet a transmetre}}'))
                		.append($('<div class="input-group">')
							.append($('<span class="input-group-btn">')
								.append($('<sup>')
									.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
									.attr('title','Selectionner un objet Jeedom dont la valeur est a envoyer sur le reseau KNX'))))
							.append($('<input class="cmdAttr form-control input-sm expressionAttr" data-l1key="configuration" data-l2key="ObjetTransmit">'))
							.append($('<span class="input-group-btn">')
								.append($('<a class="btn btn-success btn-sm bt_selectCmdExpression listCmdActionOther" data-type="inAction">')
									.append($('<i class="fa fa-list-alt">'))))))
		.append($('<span class="RetourEtat">')
						.append($('<label>')
							.text('{{Retour d\'état}}'))
						.append($('<div class="input-group">')
							.append($('<span class="input-group-btn">')
								.append($('<sup>')
									.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
									.attr('title','Choisissez un objet jeedom contenant la valeur de votre commande'))))
							.append($('<input class="cmdAttr form-control input-sm" data-l1key="value">'))
							.append($('<span class="input-group-btn">')
								.append($('<a class="btn btn-success btn-sm bt_selectCmdExpression" data-type="inAction">')
									.append($('<i class="fa fa-list-alt">'))))))
			/*.append($('<div id="groupoption1">')
				.append($("<label>")
					.text("Option1")
					.append($('<sup>')
						.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
							.attr('title','option1'))))
				.append($('<input class="cmdAttr form-control input-sm " data-l1key="configuration" data-l2key="option1">'))
				.append($('<a class="btn btn-default btn-xs cursor bt_selectCmdExpression" style="position : relative; top : 3px;" title="{{Rechercher une commande}}" id="option1">')
					.append($('<i class="fa fa-list-alt">'))))*/
			/*.append($('<div id="groupoption2">')
				.append($("<label>")
					.text("Option2")
					.append($('<sup>')
						.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
							.attr('title','option2'))))
				.append($('<input class="cmdAttr form-control input-sm " data-l1key="configuration" data-l2key="option2">'))
				.append($('<a class="btn btn-default btn-xs cursor bt_selectCmdExpression" style="position : relative; top : 3px;" title="{{Rechercher une commande}}" id="option2">')
					.append($('<i class="fa fa-list-alt">'))))*/
			/*.append($('<div id="groupoption3">')
				.append($("<label>")
					.text("Option3")
					.append($('<sup>')
						.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
							.attr('title','option3'))))
				.append($('<input class="cmdAttr form-control input-sm " data-l1key="configuration" data-l2key="option3">'))
				.append($('<a class="btn btn-default btn-xs cursor bt_selectCmdExpression" style="position : relative; top : 3px;" title="{{Rechercher une commande}}" id="option3">')
					.append($('<i class="fa fa-list-alt">'))))*/
			/*.append($('<div id="groupoption4">')
				.append($("<label>")
					.text("Option4")
					.append($('<sup>')
						.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
							.attr('title','option4'))))
				.append($('<input class="cmdAttr form-control input-sm " data-l1key="configuration" data-l2key="option4">'))
				.append($('<a class="btn btn-default btn-xs cursor bt_selectCmdExpression" style="position : relative; top : 3px;" title="{{Rechercher une commande}}" id="option4">')
				.append($('<i class="fa fa-list-alt">'))))*/
			/*.append($('<div id="groupoption5">')
				.append($("<label>")
					.text("Option5")
					.append($('<sup>')
						.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
							.attr('title','option5'))))
				.append($('<input class="cmdAttr form-control input-sm " data-l1key="configuration" data-l2key="option5">'))
			.append($('<a class="btn btn-default btn-xs cursor bt_selectCmdExpression" style="position : relative; top : 3px;" title="{{Rechercher une commande}}" id="option5">')
				.append($('<i class="fa fa-list-alt">'))))*/
			.append($('<input style="width : 120px; margin-bottom : 3px;" class="cmdAttr form-control input-sm" data-l1key="unite" placeholder="{{Unitée}}" title="Unitée">'))
			.append($('<input style="width : 120px; margin-bottom : 3px;" class="cmdAttr form-control input-sm" data-l1key="configuration" data-l2key="KnxObjectValue">').hide())
		.append($('<span>')
			.append($('<input type="checkbox" class="cmdAttr bootstrapSwitch" data-size="mini" data-label-text="{{Historiser}}" data-l1key="isHistorized" checked/>'))
			.append($('<sup>')
				.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
					.attr('title','Souhaitez vous Historiser les changements de valeur'))))
		.append($('<span>')
			.append($('<input type="checkbox" class="cmdAttr bootstrapSwitch" data-size="mini" data-label-text="{{Afficher}}" data-l1key="isVisible" checked/>'))
			.append($('<sup>')
				.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
					.attr('title','Souhaitez vous afficher cette commande sur le dashboard'))))
		.append($('<span>')
			.append($('<input type="checkbox" class="cmdAttr bootstrapSwitch" data-size="mini" data-label-text="{{Inverser}}" data-l1key="configuration" data-l2key="inverse">'))
			.append($('<sup>')
				.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
					.attr('title','Souhaitez vous inverser l\'état de la valeur'))))
		.append($('<span>')
            .append($('<input type="checkbox" class="cmdAttr bootstrapSwitch" data-size="mini" data-label-text="{{Niveau Batterie}}" data-l1key="configuration" data-l2key="noBatterieCheck">'))
			.append($('<sup>')
				.append($('<i class="fa fa-question-circle tooltips" style="font-size : 1em;color:grey;">')
					.attr('title','Activer cette option uniquement si votre équipement est sur batterie. Ce groupe d\'adresse correspond au niveau de batterie'))))
			.append($('<input class="tooltips cmdAttr form-control input-sm" data-l1key="configuration" data-l2key="minValue" placeholder="{{Min}}" title="{{Min}}" >'))
			.append($('<input class="tooltips cmdAttr form-control input-sm" data-l1key="configuration" data-l2key="maxValue" placeholder="{{Max}}" title="{{Max}}" >')));
	tr.append($('<td class="wizard">')
		.append($('<div class="parametre" style="width : 30%;display : inline-block;margin:5px;">')
			.append($('<span class="type" type="' + init(_cmd.type) + '">')
				.append(jeedom.cmd.availableType()))
		.append($('<span class="expertModeVisible">')
			.append($('<input type="checkbox" class="cmdAttr bootstrapSwitch" data-size="mini" data-label-text="{{Sous type}}" data-l1key="configuration"  data-l2key="subTypeAuto"/>')))
			.append($('<span class="subType" subType="'+init(_cmd.subType)+'">'))));
		var parmetre=$('<td>');
	if (is_numeric(_cmd.id)) {
		parmetre.append($('<a class="btn btn-default btn-xs cmdAction" data-action="test">')
			.append($('<i class="fa fa-rss">')
				.text('{{Tester}}')));
	}
	parmetre.append($('<a class="btn btn-default btn-xs cmdAction expertModeVisible" data-action="configure">')
		.append($('<i class="fa fa-cogs">')));
	parmetre.append($('<a class="btn btn-default btn-xs cmdAction expertModeVisible tooltips" data-action="copy" title="{{Dupliquer}}">')
		.append($('<i class="fa fa-files-o">')));
	parmetre.append($('<a class="btn btn-default btn-xs cmdAction expertModeVisible bt_read">').hide()
		.append($('<i class="fa fa-rss">')
			.text('{{Read}}')));
	tr.append(parmetre);
	$('#table_cmd tbody').append(tr);
	$('#table_cmd tbody tr:last').setValues(_cmd, '.cmdAttr');
	$('#table_cmd tbody tr:last .cmdAttr[data-l1key=configuration][data-l2key=KnxObjectType]').trigger('change');
	$('#table_cmd tbody tr:last .cmdAttr[data-l1key=configuration][data-l2key=KnxObjectValue]').trigger('change');
	jeedom.cmd.changeType($('#table_cmd tbody tr:last'), init(_cmd.subType));
}
function wizard(){
	$('#md_modal').append($('<div>').addClass('eqLogic'));
	$('.wizard').each(function() {
		//Ajouter un test si mode expert ?
		$('#md_modal').find('.eqLogic').append(
			$('<div>').addClass('stepWizard')
				.append($('<table>')
					.append($('<tr>')
						.append($('<td colspan="2">')
							.append($('<center>')
								.text($(this).find('.control-label').text()))))
					.append($('<tr>')
						.append($('<td>')
							.append($('<center>')
								.append($(this).find('.form-control').clone())))
						.append($('<td>')
							.append($('<center>')
								.text($(this).find('sup i').attr('title')))))
					.append($('<tr>')
						.append($('<td>')
							.append($('<center>')
								.append($('<a class="btn btn-success btn-sm wizardAction" data-action="prev">')
									.append($('<i class="fa fa-plus-circle">'))
									.text('{{Précédent}}'))
								.append($('<a class="btn btn-success btn-sm wizardAction" data-action="next">')
									.append($('<i class="fa fa-plus-circle">'))
									.text('{{Suivant}}'))))
						.append($('<td>')
							.append($('<center>')
								.append($('<a class="btn btn-success btn-sm wizardAction" data-action="cmd">')
									.append($('<i class="fa fa-plus-circle">'))
									.text('{{Ajouter une commande}}').hide())
								.append($('<a class="btn btn-success btn-sm wizardAction" data-action="save">')
									.append($('<i class="fa fa-plus-circle">'))
									.text('{{Sauvgarder}}').hide()))))));

	});
	$('#md_modal .data-info').show();
	$('.stepWizard').hide();
	$('.stepWizard').first().show();
	$('.stepWizard').first().find('.wizardAction[data-action=prev]').hide();
	$('.stepWizard').last().find('.wizardAction[data-action=next]').hide();
	$('.stepWizard').last().find('.wizardAction[data-action=save]').show();
	$('.stepWizard').last().find('.wizardAction[data-action=cmd]').show();
	$('#md_modal').on('click','.wizardAction[data-action=prev]', function(){
		$(this).closest('.stepWizard').hide();
		$(this).closest('.stepWizard').prev().show();
	});
	$('#md_modal').on('click','.wizardAction[data-action=next]', function(){
		$(this).closest('.stepWizard').hide();
		$(this).closest('.stepWizard').next().show();
	});
	$('#md_modal').on('click','.wizardAction[data-action=save]', function(){
		var _eqLogic=$('#md_modal').getValues('.eqLogicAttr')[0];
		$('.eqLogic').setValues(_eqLogic, '.eqLogicAttr');
		$('#md_modal .cmd').each(function(){	
			var _cmd=$(this).getValues('.cmdAttr')[0];
			addCmdToTable(_cmd);
		});
		$('#md_modal').dialog('close');
		$('#md_modal').html('');
		//$('.eqLogicAction[data-action=save]').trigger('click');
	});
	$('#md_modal').on('click','.wizardAction[data-action=cmd]', function(){
		$('.stepWizard').last().find('.wizardAction[data-action=next]').show();
		$(this).closest('.stepWizard').hide();
		$(this).closest('.stepWizard').next().show();
		addCmdToTable();
		$('#md_modal').append($('<div>').addClass('cmd'));
		$('#table_cmd tbody tr:last .wizard').each(function() {
			//Ajouter un test si mode expert ?
			$('#md_modal').find('.cmd').append(
				$('<div>').addClass('stepWizard')
					.append($(this).children().clone())
					.append($('<div>')
						.append($('<center>')
							.append($('<a class="btn btn-success btn-sm wizardAction" data-action="prev">')
								.append($('<i class="fa fa-plus-circle">'))
								.text('{{Précédent}}'))
							.append($('<a class="btn btn-success btn-sm wizardAction" data-action="next">')
								.append($('<i class="fa fa-plus-circle">'))
								.text('{{Suivant}}'))
							.append($('<a class="btn btn-success btn-sm wizardAction" data-action="cmd">')
								.append($('<i class="fa fa-plus-circle">'))
								.text('{{Ajouter une commande}}').hide())
							.append($('<a class="btn btn-success btn-sm wizardAction" data-action="save">')
								.append($('<i class="fa fa-plus-circle">'))
								.text('{{Sauvgarder}}').hide()))));
		});
		$('#table_cmd tbody').html('');
		$('#md_modal .data-info').show();
		$('.stepWizard').hide();
		$('.cmd').find('.stepWizard').first().show();
		$('.stepWizard').last().find('.wizardAction[data-action=next]').hide();
		$('.stepWizard').last().find('.wizardAction[data-action=save]').show();
		$('.stepWizard').last().find('.wizardAction[data-action=cmd]').show();
	});
}
