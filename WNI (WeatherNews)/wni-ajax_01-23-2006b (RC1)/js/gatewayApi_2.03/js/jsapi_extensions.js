/** BEGIN: Globals ************************************************************************/

_stack_jsapi_serialization = [];

/** END! Globals ************************************************************************/

/** BEGIN: JSAPI Extensions ************************************************************************/

function register_jsapi_function(f) {
	_stack_jsapi_serialization.push(f);
}

function handle_next_jsapi_function() {
	var f = _stack_jsapi_serialization.pop();
	if (!!f) {
		eval(f);
	}
}

function htmlServerCommand_Begins(width) {
	var resp = '';
	if (width == null) {
		width = const_jsapi_width_value;
	}
	resp = '<table width="' + parseInt(width) + 'px" bgcolor="' + const_paper_color_light_yellow + '" border="1" cellpadding="-1" cellspacing="-1">';
	resp += '<tr>';
	resp += '<td height="25px">';
	return resp;
}

function htmlServerCommand_Ends() {
	var resp = '';
	resp += '</td>';
	resp += '</tr>';
	resp += '</table>';
	return resp;
}

function showServerCommand_Begins() {
	var resp = '';
	var divName = const_cf_html_container_symbol;
	var cObj = getGUIObjectInstanceById(divName);

	if (!!cObj) {
		resp = htmlServerCommand_Begins();
		resp += '<b>' + const_loading_data_message_symbol + '</b>';
		resp += '&nbsp;&nbsp;<img src="' + const_jsapi_loading_image + '" border="0">';
		resp += htmlServerCommand_Ends();
		flushGUIObjectChildrenForObj(cObj); // always flush BEFORE replacing the old HTML just to make sure the cache is cleared for the new objects...
		cObj.innerHTML = resp;
		cObj.style.display = const_inline_style;
	}
}

function showServerCommand_Ends() {
	var resp = '';
	var divName = const_cf_html_container_symbol;
	var cObj = getGUIObjectInstanceById(divName);

	if (!!cObj) {
		var _f_isLoading = cObj.innerHTML.trim().toUpperCase().indexOf(const_jsapi_loading_image.trim().toUpperCase());

		if (_f_isLoading != -1) {
			flushGUIObjectChildrenForObj(cObj); // always flush BEFORE replacing the old HTML just to make sure the cache is cleared for the new objects...
			resp = htmlServerCommand_Begins();
			resp += '<b>' + const_system_ready_message_symbol + '</b>';
			resp += htmlServerCommand_Ends();
			cObj.innerHTML = resp;
		}
	}
}

function clear_showServerCommand_Ends() {
	var resp = '';
	var divName = const_cf_html_container_symbol;
	var cObj = getGUIObjectInstanceById(divName);

	if (!!cObj) {
		flushGUIObjectChildrenForObj(cObj); // always flush BEFORE replacing the old HTML just to make sure the cache is cleared for the new objects...
		resp = htmlServerCommand_Begins();
		resp += '<b>' + const_system_ready_message_symbol + '</b>';
		resp += htmlServerCommand_Ends();
		cObj.innerHTML = resp;
	}
}

function jsapi_init_js_q(qryObjName, columnList) {
	var s_code = qryObjName + ' = -1;';
	var qryObj = eval(s_code);
	try {
		eval(qryObjName + ' = ((' + qryObjName + ') ? object_destructor(' + qryObjName + ') : null)'); // avoid closures by destroying the previous object before making a new one...
	} catch(e) {
	} finally {
	}
	eval(qryObjName + " = QueryObj.getInstance((columnList) ? columnList : '')");
}

/** END! JSAPI Extensions **************************************************************************/
