var global_dict = DictionaryObj.get$();

var const_loading_data_message_symbol = '<span class="normalStatusClass">&nbsp;Loading !</span>';
var const_system_ready_message_symbol = '<span class="normalStatusClass">&nbsp;Ready !</span>';

var const_add_button_symbol = '[+]';
var const_edit_button_symbol = '[*]';
var const_delete_button_symbol = '[-]';

var const_AJAX_width_value = 200;

var global_allow_loading_data_message = false;

// BEGIN: This is for the code that is supposed to detect the Registry settings by observation...
var ar_oAJAXEngine = []; // an array of Gateway Objs - these are xmlHttpRequest objects...
var ar_oAJAXEngine_CB = []; // an array of Gateway CallBacks - these are functions...
var ar_oAJAXEngine_CB_RC = []; // an array of Gateway CallBack return codes - these are numbers or flags...
var ar_oAJAXEngine_Div = []; // an array of div objects - these are functions...
// END! This is for the code that is supposed to detect the Registry settings by observation...

function init() {
	// create the gateway object
	oAJAXEngine.setMethodGet();
	oAJAXEngine.setReleaseMode(); // this overrides the oAJAXEngine.set_isServerLocal() setting...
	oAJAXEngine.isXmlHttpPreferred = false;
	oAJAXEngine.js_global_varName = 'j$';

	// place this on the page where you want the gateway to appear
	oAJAXEngine.create('div_ajaxFrame');
	
	// define the function to run when a packet has been sent to the server
	oAJAXEngine.onSend = function (){
		if (global_allow_loading_data_message == true) {
			showServerCommand_Begins();
		}
	};

	// define the function to run when a packet has been received from the server
	oAJAXEngine.onReceive = function (){
		var recvdByteCnt = 0;
		showServerCommand_Ends();

		var oo = $(this.idGateway);
		if (!!oo) {
			//_alert('oo.document.body = [' + oo.document.body + ']' + ', (typeof oo.document.body) = [' + (typeof oo.document.body) + ']' + ', oo.document.body.length = [' + oo.document.body.length + ']' + '\n\n' + objectExplainer(oo.document.body));
		//	if (oAJAXEngine.isDebugMode()) _alert(oo.document.body.outerText);
		}
		
		// BEGIN: This block of code always returns the JavaScript Query Object known as oAJAXEngine.js_global_varName regardless of the technique that was used to perform the AJAX function...
		try {
			if (this.isReceivedFromCFAjax()) {
				if (this.isDebugMode()) _alert(this.received);
				recvdByteCnt += this.received.length;
				eval(this.received);
			} else {
				try {
					for( var i = 0; i < this.received.length; i++) {
						if (this.isDebugMode()) _alert(this.received[i]);
						recvdByteCnt += this.received[i].length;
						eval(this.received[i]);
					}
				} catch(ee) {
					_alertError(jsErrorExplainer(ee, '(2) ' + const_cf_CGI_SCRIPT_NAME + ' :: oAJAXEngine.onReceive'));
					_alert(this.received[i]);
				} finally {
				}
			}
		} catch(e) {
			_alertError(jsErrorExplainer(e, '(1) ' + const_cf_CGI_SCRIPT_NAME + ' :: oAJAXEngine.onReceive'));
			_alert(this.received);
		} finally {
		}
		if (this.isDebugMode()) _alert('oAJAXEngine.mode = [' + oAJAXEngine.mode + ']' + '\n' + oAJAXEngine.js_global_varName + ' = [' + oAJAXEngine.js_global_varName + ']' + '\n' + this.received);
		window.status = 'recvdByteCnt = [' + recvdByteCnt + ']';
		// END! This block of code always returns the JavaScript Query Object known as oAJAXEngine.js_global_varName regardless of the technique that was used to perform the AJAX function...

		handle_next_AJAX_function(); // get the next item from the stack...
	};

	oAJAXEngine.onTimeout = function (){
		this.throwError("The current request has timed out.\nPlease try your request again.");
		showServerCommand_Ends();
		handle_next_AJAX_function(); // get the next item from the stack...
	};

	oAJAXEngine.hideFrame();
	var cObj = $('btn_hideShow_iFrame');
	if (!!cObj) {
		if (oAJAXEngine.visibility == ((document.layers) ? 'show' : 'visible')) {
			cObj.value = cObj.value.clipCaselessReplace('show', 'Hide');
		}
	}

	var cObj = $('btn_useXmlHttpRequest');
	if (!!cObj) {
		if (oAJAXEngine.isXmlHttpPreferred == false) {
			cObj.value = cObj.value.clipCaselessReplace('iFRAME', 'XmlHttpRequest');
		}
	}

	var cObj = $('btn_useMethodGetOrPost');
	if (!!cObj) {
		if (oAJAXEngine.isMethodGet()) {
			cObj.value = cObj.value.clipCaselessReplace('GET', 'Post');
		}
	}

	var cObj = $('btn_useDebugMode');
	if (!!cObj) {
		if (oAJAXEngine.isReleaseMode() == true) {
			cObj.value = cObj.value.clipCaselessReplace('Debug', 'Release');
		}
	}
}

function doAJAX_func(cmd, callBackFuncName, vararg_params) {
	var j = -1;
	var j2 = -1;
	var ar = [];
	var ar2 = [];
	var _argCnt = 0;
	var anArg = '';
	var iArg = 0;
	var useNamedArgs = false;
	var argNames = [];
	var s_argSpec = '';
	var isObject = false;
	var sValue = '&cfm=' + cmd + '&AUTH_USER=' + const_cf_AUTH_USER + '&callBack=' + callBackFuncName;
	
	var _db = '';

    // BEGIN: Make the arguments into a series of URL Parms, as-required, don't worry the AJAX Engine will figure out how to handle all this data...
	// a Parm may be a simple value or a Query String using the standard CGI Query String specification of "&name=value"...
	iArg = 0;
    for (var i = 0; i < arguments.length - 2; i++) {
		anArg = arguments[i + 2];
		isObject = false;
		_db += ', (typeof anArg) = [' + (typeof anArg) + ']';
		if ((typeof anArg).toUpperCase() == const_object_symbol.toUpperCase()) {
			// the arg might be an array or a complex object...
			var k = -1;
			for (k = 0; k < anArg.length; k++) {
				if (anArg[k].trim().length > 0) {
					if ((typeof anArg[k]).toUpperCase() != const_string_symbol.toUpperCase()) {
						try {
							anArg[k] = anArg[k].toString();
						} catch(e) {
							anArg[k] = ''; // default is empty string whenever the thing that is not a string cannot be made into a string...
						} finally {
						}
					}
					s_argSpec += '&arg' + (iArg + 1) + '=' + anArg[k].URLDecode().URLEncode();
					_argCnt++;
					iArg++;
				}
			}
			isObject = true;
		} else if ((typeof anArg).toUpperCase() != const_string_symbol.toUpperCase()) {
			try {
				anArg = anArg.toString();
			} catch(e) {
				anArg = ''; // default is empty string whenever the thing that is not a string cannot be made into a string...
			} finally {
			}
		}
		_db += ', isObject = [' + isObject + ']';
		if ( (isObject == false) && (anArg.trim().length > 0) ) {
			if ( (anArg.indexOf(',') != -1) || (anArg.indexOf('&') != -1) ) {
				ar = anArg.split(',');
				if (ar.length < 2) {
					ar = anArg.split('&');
					useNamedArgs = true;
				}
				for (j = 0; j < ar.length; j++) {
					if (ar[j].trim().length > 0) {
						if (ar[j].indexOf('=') != -1) {
							ar2 = ar[j].split('=');
							j2 = (j * 2);
							if (useNamedArgs) {
								if (ar2[1].length > 0) argNames.push(ar2[0].URLDecode());
								ar2[1] = ar2[1].toString();
								s_argSpec += '&' + ar2[0] + '=' + ar2[1].URLDecode().URLEncode();
								_argCnt++;
								iArg++;
							} else {
								s_argSpec += '&arg' + (j2 - 1) + '=' + ar2[0].toString().URLDecode().URLEncode();
								_argCnt++;
								iArg++;
								s_argSpec += '&arg' + j2 + '=' + ar2[1].toString().URLDecode().URLEncode();
								_argCnt++;
							}
							iArg++;
						} else {
							s_argSpec += '&arg' + (j + 1) + '=' + ar[j].toString().URLDecode().URLEncode();
							_argCnt++;
							iArg++;
						}
					}
				}
			} else {
				s_argSpec += '&arg' + (iArg + 1) + '=' + anArg.toString().URLDecode().URLEncode();
				_argCnt++;
				iArg++;
			}
		}
    }
	sValue += '&argCnt=' + ((argNames.length > 0) ? argNames.length : ((s_argSpec.length > 0) ? _argCnt : 0)) + s_argSpec + ((argNames.length > 0) ? '&argNames=' + argNames.toString().URLDecode().URLEncode() : '');
//	_alert('sValue = [' + sValue + ']');
	if (oAJAXEngine.isDebugMode()) _alert('argNames.length = [' + argNames.length + ']');
	if (oAJAXEngine.isDebugMode()) _alert('argNames = [' + argNames + ']');
	if (oAJAXEngine.isDebugMode()) _alert('sValue = [' + sValue + ']');
    // END! Make the arguments into a series of URL Parms, as-required, don't worry the AJAX Engine will figure out how to handle all this data...

	if (oAJAXEngine.isXmlHttpPreferred == false) {
		oAJAXEngine.setMethodGet();
	}
	oAJAXEngine.enableCache = false; // this flag controls whether the server request is cached or not...
	oAJAXEngine.timeout = const_cf_gateway_time_out_symbol; // matches the ColdFusion time-out which is 120 secs at SBC...
	oAJAXEngine.sendPacket(sValue);
}
