/** BEGIN: Globals ************************************************************************/

var _stack_AJAX_serialization = [];

var const_jsapi_width_value = 200;

/** END! Globals ************************************************************************/

/** BEGIN: AJAX Extensions ************************************************************************/

function register_AJAX_function(f) {
	_stack_AJAX_serialization.push(f);
}

function handle_next_AJAX_function() {
	var f = _stack_AJAX_serialization.pop();
	if (!!f) {
		eval(f);
	}
}

function ajaxBegins(width) {
	var resp = '';
	if (width == null) {
		width = const_jsapi_width_value;
	}
	resp = '<table width="' + parseInt(width) + 'px" bgcolor="' + const_paper_color_light_yellow + '" border="1" cellpadding="-1" cellspacing="-1">';
	resp += '<tr>';
	resp += '<td height="25px">';
	return resp;
}

function ajaxEnds() {
	var resp = '';
	resp += '</td>';
	resp += '</tr>';
	resp += '</table>';
	return resp;
}

function showAJAXBegins(sMsg, sImage, imageHeight) {
	var resp = '';
	var _href = makeHrefGeneric(document.location.href);
	var frameCode = '';
	var divName = const_cf_html_container_symbol;
	var cObj = $(divName);

	if (!!cObj) {
		imageHeight = ((!!imageHeight) ? imageHeight : '55%');

		resp = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">';
		resp += '<html><head><title>System Activity Display</title>';
		resp += '<link rel=stylesheet type="text/css" href="' + _href + ((_href.charAt(_href.length - 1) != '/') ? '/' : '') + 'ajaxStyles.css">';
		resp += '</head>';
		resp += '<body>';
		resp += ajaxBegins();
		resp += '<b>' + ((!!sMsg) ? sMsg : const_loading_data_message_symbol) + '</b>';
		resp += '&nbsp;&nbsp;<img height="' + imageHeight + '" src="' + ((!!sImage) ? sImage : const_AJAX_loading_image) + '" border="0">';
		resp += ajaxEnds();
		resp += '</body></html>';
		frameCode = '<iframe id="iframe_showAJAXBegins" frameborder="0" marginwidth="0" marginheight="0" scrolling="No" style="display: none;"></iframe>';
		flushCache$(cObj); 
		cObj.innerHTML = frameCode;
		var frObj = $('iframe_showAJAXBegins');
		if (!!frObj) {
			frObj.contentWindow.document.writeln(resp);
			frObj.style.display = const_inline_style;
			cObj.style.position = 'absolute';
			cObj.style.top = ((isServerLocal()) ? 11 : 0) + 'px';
			cObj.style.width = (const_jsapi_width_value + 10) + 'px';
			cObj.style.left = (clientWid$() - parseInt(cObj.style.width) - 11) + 'px';
			cObj.style.height = '30px';
			frObj.style.position = 'absolute';
			frObj.style.top = document.body.scrollTop + 'px';
			frObj.style.left = '20px';
			frObj.style.height = '30px';
			frObj.style.width = const_jsapi_width_value + 'px';
		}

		var dObj = $(const_div_floating_debug_menu);
		if (!!dObj) {
			dObj.style.position = cObj.style.position;
		}
	}
}

function showAJAXEnds() {
	var frObj = $('iframe_showAJAXBegins');
	if (!!frObj) {
		if (frObj.style.display != const_none_style) {
			frObj.style.display = const_none_style;
		}
	}
}

function clearAJAXEnds() {
	var resp = '';
	var divName = const_cf_html_container_symbol;
	var cObj = $(divName);

	if (!!cObj) {
		flushCache$(cObj); 
		if (const_system_ready_message_symbol.length > 0) {
			resp = ajaxBegins();
			resp += '<b>' + const_system_ready_message_symbol + '</b>';
			resp += ajaxEnds();
			cObj.innerHTML = resp;
		}
	}
}

function initJSQ(qryObjName, columnList) {
	var s_code = qryObjName + ' = -1;';
	var qryObj = eval(s_code);
	try {
		eval(qryObjName + ' = ((' + qryObjName + ') ? object_destructor(' + qryObjName + ') : null)'); // avoid closures by destroying the previous object before making a new one...
	} catch(e) {
	} finally {
	}
	eval(qryObjName + " = QueryObj.get$((columnList) ? columnList : '')");
}

/** END! AJAX Extensions **************************************************************************/
