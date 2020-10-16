function _init(c) {
	if ( (!!c) && (!!c.length) && (c.length > 0) ) {
		var uc = c.URLDecode(); 
		eval(uc);
	}
	oAJAXEngine = AJAXEngine.getInstance(url_sBasePath + ((url_sBasePath.charAt(url_sBasePath.length - 1) == '/') ? '' : '/') + const_cfm_gateway_process_html, bool_isServerLocal);
	if (!!oAJAXEngine) {
	//	alert('_init() :: oAJAXEngine = [' + oAJAXEngine + ']');
	} else {
		alert('ERROR: Programming error - oAJAXEngine is undefined in _init().');
	}

	init();
	
	_global_clientWidth = clientWidth();

	global_allow_loading_data_message = true;
	
	register_AJAX_function("clear_showServerCommand_Ends();");

	handle_next_AJAX_function(); // kick-start the process of fetching HTML from the server...
}

function canXMLhttpRequest() {
	var bool = false;
	var xmlHttp_reqObject = -1;
    if (window.XMLHttpRequest) { // branch for native XMLHttpRequest object
    	try {
			xmlHttp_reqObject = new XMLHttpRequest();
			bool = true;
        } catch(e) {
			xmlHttp_reqObject = false;
			bool = false;
        }
    } else if (window.ActiveXObject) { // branch for IE/Windows ActiveX version
       	try {
        	xmlHttp_reqObject = new ActiveXObject("Msxml2.XMLHTTP");
			bool = true;
      	} catch(e) {
        	try {
          		xmlHttp_reqObject = new ActiveXObject("Microsoft.XMLHTTP");
				bool = true;
        	} catch(e) {
          		xmlHttp_reqObject = false;
				bool = false;
        	}
		}
    }
	return bool;
}

function window_onload() {
	if (canXMLhttpRequest()) {
		dhtmlLoadScript("bootstrap.js"); // this method uses xmlHttpRequest()
	} else {
		dhtmlLoadScript("_bootstrap.js");// this method uses a hidden iframe in the document head...
	}
}

function window_onUnload() {
	// BEGIN: Clean-Up any Objects that are still laying about to ensure there are no memory leaks in case there were any closures...

	// BEGIN: This is where some bad evil things will happen unless these global variables were successfully initialized...
	try { _jG_ = ((!!_jG_) ? object_destructor(_jG_) : null); } catch(e) {}																		// avoid closures by destroying the previous object before making a new one...
	// END! This is where some bad evil things will happen unless these global variables were successfully initialized...

	AJaxContextObj.removeInstances();
	AJAXObj.removeInstances();
	QueryObj.removeInstances();
	GUIActionsObj.removeInstances();
	DictionaryObj.removeInstances();
	NestedArrayObj.removeInstances();
	// END! Clean-Up any Objects that are still laying about to ensure there are no memory leaks in case there were any closures...

	// BEGIN: Clean-up event handlers to avoid memory leaks...
	var bodyObj = document.getElementsByTagName('body')[0];
	if (!!bodyObj) {
		var a = bodyObj.getElementsByTagName('div');
		for (var i = 0; i < a.length; i++) {
			flushGUIObjectChildrenForObj(a[i]);
		}
		flushGUIObjectChildrenForObj(bodyObj);
	}
	// END! Clean-up event handlers to avoid memory leaks...
}

window.onresize = function () {
	_global_clientWidth = clientWidth();
}

var global_reposition_stack = [];
var global_reposition_cache = [];

window.onscroll = function () {
	var cObj = $(const_cf_html_container_symbol);
	if (!!cObj) {
		cObj.style.top = document.body.scrollTop + 'px';
		cObj.style.left = (window.document.body.scrollWidth - 200) + 'px';

		var dObj = $(const_div_floating_debug_menu);
		if (!!dObj) {
			dObj.style.position = cObj.style.position;
			dObj.style.top = parseInt(cObj.style.top) + 25 + 'px';
		//	dObj.style.left = (clientWidth() - 75) + 'px';
			
			var i = -1;
			var oo = -1;
			for (i = 0; i < global_reposition_stack.length; i++) {
				oo = global_reposition_cache[global_reposition_stack[i]];
				if (!!oo) {
					repositionBasedOnFloatingDebugPanel(oo);
				}
			}
		}
	}
//	_alert('scrolled ' + 'document.body.scrollTop = [' + document.body.scrollTop + ']' + ', document.body.scrollLeft = [' + document.body.scrollLeft + ']' + ', window.document.body.scrollHeight = [' + window.document.body.scrollHeight + ']' + ', window.document.body.scrollWidth = [' + window.document.body.scrollWidth + ']');
}

function repositionBasedOnFloatingDebugPanel(oObj) {
	var dObj = $(const_div_floating_debug_menu);
	if (!!dObj) {
		oObj.style.position = dObj.style.position;
		oObj.style.top = parseInt(dObj.style.top) + ((oObj.id == 'table_menuHelperPanel') ? 20 : 0) + 'px';
		oObj.style.left = '100px';
		oObj.style.width = (clientWidth() - 175) + 'px';

		if (global_reposition_cache[oObj.id] == null) {
			global_reposition_cache[oObj.id] = oObj;
			global_reposition_stack.push(oObj.id);
		}
	//	_alert('oObj.id = [' + oObj.id + ']' + ', oObj.style.position = [' + oObj.style.position + ']' + ', oObj.style.top = [' + oObj.style.top + ']' + ', oObj.style.left = [' + oObj.style.left + ']' + ', oObj.style.width = [' + oObj.style.width + ']');
	}
}

function handle_ajaxHelper_onClick() {
   	try {
		var cObj = $('td_ajaxHelperPanel'); 
		var bObj = $('btn_helperPanel'); 
		var tbObj = $('table_ajaxHelperPanel'); 
		if ( (!!cObj) && (!!bObj) && (!!tbObj) ) { 
			cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style); 
			bObj.value = ((cObj.style.display == const_inline_style) ? '[<<]' : '[>>]'); 
			if (cObj.style.display == const_inline_style) { 
				tbObj.style.width = _global_clientWidth; 
			//	repositionBasedOnFloatingDebugPanel(tbObj); 
				oAJAXEngine.setDebugMode(); 
			} else { 
				oAJAXEngine.setReleaseMode(); 
			}; 
		};
       } catch(e) {
		_alertError(jsErrorExplainer(e, 'handle_ajaxHelper_onClick()'));
       }
}

function handle_ajaxHelper2_onClick() {
   	try {
		var cObj = $('td_ajaxHelperPanel2'); 
		var bObj = $('btn_helperPanel2'); 
		var tbObj = $('table_ajaxHelperPanel2'); 
		if ( (!!cObj) && (!!bObj) && (!!tbObj) ) { 
			cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style); 
			bObj.value = ((cObj.style.display == const_inline_style) ? '[<<]' : '[>>]'); 
			if (cObj.style.display == const_inline_style) { 
				tbObj.style.width = _global_clientWidth; 
			} else { 
			}; 
		};
       } catch(e) {
		_alertError(jsErrorExplainer(e, 'handle_ajaxHelper2_onClick()'));
       }
}
