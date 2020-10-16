<cfset _js_path = "js/">

<cfset _CrossBrowserLibrary_js = "#_js_path#CrossBrowserLibrary.js">
<cfset _GUIActionsObj_js = "#_js_path#gui_actions_obj.js">

<cfset _StylesAndArrays_js = "#_js_path#StylesAndArrays.js">

<cfset _gateway_js = "#_js_path#gatewayApi_2.03/gateway.js">
<cfset _wddx_js = "#_js_path#gatewayApi_2.03/wddx.js">
<cfset _ajax_obj_js = "#_js_path#ajax_obj.js">
<cfset _jsapi_extensions_js = "#_js_path#gatewayApi_2.03/js/jsapi_extensions.js">

<cfset _iframe_ssi_script2_js = "#_js_path#www.dynamicdrive.com/iframe_ssi_script2.js">

<cfset _ajax_context_obj_js = "#_js_path#ajax_context_obj.js">
<cfset _dictionary_obj_js = "#_js_path#dictionary_obj.js">
<cfset _cf_query_obj_js = "#_js_path#cf_query_obj.js">
<cfset _nested_array_obj_js = "#_js_path#nested_array_obj.js">
<cfset _object_destructor_js = "#_js_path#object_destructor.js">

<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>wni-ajax v1.0</title>
		<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 
	
		<!--- BEGIN: This file MUST be loaded first or bad evil things will happen... --->
		<script language="JavaScript1.2" src="#_object_destructor_js#" type="text/javascript"></script>
		<!--- END! This file MUST be loaded first or bad evil things will happen... --->
	
		<script language="JavaScript1.2" src="#_iframe_ssi_script2_js#" type="text/javascript"></script>
	
		<script language="JavaScript1.2" src="#_CrossBrowserLibrary_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_StylesAndArrays_js#" type="text/javascript"></script>

		<script language="JavaScript1.2" src="#_dictionary_obj_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_cf_query_obj_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_nested_array_obj_js#" type="text/javascript"></script>

		<script language="JavaScript1.2" src="#_GUIActionsObj_js#" type="text/javascript"></script>

		<script language="JavaScript1.2" src="#_ajax_obj_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_ajax_context_obj_js#" type="text/javascript"></script>
	</head>
	
	<body onload="window_onload()" onunload="window_onUnload()">
	
		<!--// load the Client/Server Gateway API //-->
		<cfif 0>
			<script language="JavaScript1.2" src="#_wddx_js#" type="text/javascript"></script>
		</cfif>
		<script language="JavaScript1.2" src="#_gateway_js#" type="text/javascript">></script>
		<!--// load the extensions to the Client/Server Gateway API //-->
		<script language="JavaScript1.2" src="#_jsapi_extensions_js#" type="text/javascript">></script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function _dispaySysMessages(s, t, bool_hideShow) {
				var cObj = getGUIObjectInstanceById('div_sysMessages');
				var tObj = getGUIObjectInstanceById('span_sysMessages_title');
				var sObj = getGUIObjectInstanceById('span_sysMessages_body');
				var taObj = _getGUIObjectInstanceById('textarea_sysMessages_body');
				var s_ta = '';
				if ( (!!cObj) && (!!sObj) && (!!tObj) ) {
					bool_hideShow = ((bool_hideShow == true) ? bool_hideShow : false);
					s_ta = ((!!taObj) ? taObj.value : '');
					sObj.innerHTML = '<textarea id="textarea_sysMessages_body" class="codeSmaller" cols="150" rows="30" readonly>' + ((s.length > 0) ? s_ta + '\n' : '') + s + '</textarea>';
					tObj.innerHTML = t;
					cObj.style.display = ((bool_hideShow) ? const_inline_style : const_none_style);
					cObj.style.position = 'absolute';
					cObj.style.left = 10 + 'px';
					cObj.style.top = 10 + 'px';
					cObj.style.width = (clientWidth() - 10) + 'px';
					cObj.style.height = (clientHeight() - 10) + 'px';
				}
			}
			
			function dispaySysMessages(s, t) {
				return _dispaySysMessages(s, t, true);
			}
			
			function _alert(s) {
				return dispaySysMessages(s, 'DEBUG');
			}

			function dismissSysMessages() {
				return _dispaySysMessages('', '', false);
			}
		//-->
		</script>

		<cfscript>
			const_menuRecord_symbol = 'menuRecord';
			const_groupNameRecord_symbol = 'groupNameRecord';
			const_layerNameRecord_symbol = 'layerNameRecord';

			const_menuGroupRecord_symbol = 'menuGroupRecord';
		</cfscript>	

		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			var global_previous_dispOrder = [];
			
			var global_htmlStream = '';

			var global_maxRecsPerPage = []; // based on the context...

			var global_currentRecsPageBeingDisplayed = []; // based on the context...
			var global_maxRecsPageCount = []; // based on the context...
			
			var global_guiActionsObj = GUIActionsObj.getInstance();

			var global_dict = DictionaryObj.getInstance();
			
			var const_cf_html_container_symbol = '#Request.cf_html_container_symbol#';
			var const_loading_data_message_symbol = '<span class="normalStatusClass">&nbsp;Loading !</span>';
			var const_system_ready_message_symbol = '<span class="normalStatusClass">&nbsp;Ready !</span>';
			var const_jsapi_loading_image = '#Request.const_jsapi_loading_image#';

			var const_paper_color_light_yellow = '#Request.const_paper_color_light_yellow#';
			var const_color_light_blue = '#Request.const_color_light_blue#';

			var const_add_button_symbol = '[+]';
			var const_edit_button_symbol = '[*]';
			var const_delete_button_symbol = '[-]';
			
			var const_jsapi_width_value = 200;

			var global_allow_loading_data_message = false;
			
			var url_sBasePath = 'http:\/\/#CGI.HTTP_HOST#' + document.location.pathname.substring(0, document.location.pathname.length);

			var bool_isServerLocal = (('#Request.commonCode.isServerLocal()#'.toString().trim().toLowerCase() == 'yes') ? true : false);
			
			// BEGIN: This is for the code that is supposed to detect the Registry settings by observation...
			var ar_oGateway = []; // an array of Gateway Objs - these are xmlHttpRequest objects...
			var ar_oGateway_CB = []; // an array of Gateway CallBacks - these are functions...
			var ar_oGateway_CB_RC = []; // an array of Gateway CallBack return codes - these are numbers or flags...
			var ar_oGateway_Div = []; // an array of div objects - these are functions...
			// END! This is for the code that is supposed to detect the Registry settings by observation...
	
			// create the gateway object
			var oGateway = new Gateway(url_sBasePath + ((url_sBasePath.charAt(url_sBasePath.length - 1) == '/') ? '' : '/') + '#Request.cfm_gateway_process_html#', bool_isServerLocal);
			oGateway.setMethodGet();
			oGateway.setReleaseMode(); // this overrides the oGateway.set_isServerLocal() setting...
			oGateway.js_global_varName = 'js_Global';
			
			function init() {
				// define the function to run when a packet has been sent to the server
				oGateway.onSend = function (){
					if (global_allow_loading_data_message == true) {
						showServerCommand_Begins();
					}
				};
		
				// define the function to run when a packet has been received from the server
				oGateway.onReceive = function (){
					var _db = '';
		
					showServerCommand_Ends();

					// BEGIN: This block of code always returns the JavaScript Query Object known as oGateway.js_global_varName regardless of the technique that was used to perform the AJAX function...
					try {
						if (this.isReceivedFromCFAjax()) {
							eval(this.received);
						} else {
							var _db = '';
							try {
								for( var i = 0; i < this.received.length; i++) {
									eval(this.received[i]);
									_db += '\n' + this.received[i];
								}
							} catch(ee) {
								jsErrorExplainer(ee, '(2) index.cfm :: oGateway.onReceive');
							} finally {
							}
						}
					} catch(e) {
						jsErrorExplainer(e, '(1) index.cfm :: oGateway.onReceive');
					} finally {
					}
					if (this.isDebugMode()) alert('oGateway.mode = [' + oGateway.mode + ']' + '\n' + oGateway.js_global_varName + ' = [' + js_Global + ']' + '\n' + this.received);
					// END! This block of code always returns the JavaScript Query Object known as oGateway.js_global_varName regardless of the technique that was used to perform the AJAX function...

					handle_next_jsapi_function(); // get the next item from the stack...
				};
		
				oGateway.onTimeout = function (){
					this.throwError("The current request has timed out.\nPlease try your request again.");
					showServerCommand_Ends();
					handle_next_jsapi_function(); // get the next item from the stack...
				};
			}
	
			function execJSAPI_func(cmd, callBackFuncName, vararg_params) {
				var j = -1;
				var j2 = -1;
				var ar = [];
				var ar2 = [];
				var ampersand_i = -1;
				var equals_i = -1;
				var _argCnt = 0;
				var anArg = '';
				var iArg = 0;
				var s_argSpec = '';
				var isObject = false;
				var sValue = '&cfm=' + cmd + '&AUTH_USER=#Request.AUTH_USER#' + '&callBack=' + callBackFuncName;
				
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
								s_argSpec += '&arg' + (iArg + 1) + '=' + anArg[k];
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
					if (isObject == false) {
						ampersand_i = anArg.indexOf('&');
						equals_i = anArg.indexOf('=');
						if ( (ampersand_i != -1) && (equals_i != -1) && (ampersand_i < equals_i) ) {
							s_argSpec += anArg;
							_argCnt++;
							iArg++;
						} else if (anArg.indexOf(',') != -1) {
							ar = anArg.split(',');
							for (j = 0; j < ar.length; j++) {
								if (ar[j].indexOf('=') != -1) {
									ar2 = ar[j].split('=');
									j2 = (j * 2);
									s_argSpec += '&arg' + (j2 - 1) + '=' + ar2[0];
									_argCnt++;
									iArg++;
									s_argSpec += '&arg' + j2 + '=' + ar2[1];
									_argCnt++;
									iArg++;
								} else {
									s_argSpec += '&arg' + (j + 1) + '=' + ar[j];
									_argCnt++;
									iArg++;
								}
							}
						} else {
							s_argSpec += '&arg' + (iArg + 1) + '=' + anArg;
							_argCnt++;
							iArg++;
						}
					}
			    }
				sValue += '&argCnt=' + _argCnt + s_argSpec;
			//	_alert('arguments.length = [' + arguments.length + ']' + ', sValue = [' + sValue + ']' + '\n' + _db);
			    // END! Make the arguments into a series of URL Parms, as-required, don't worry the AJAX Engine will figure out how to handle all this data...

				if (oGateway.isXmlHttpPreferred == false) {
					oGateway.setMethodGet();
				}
				oGateway.enableCache = false; // this flag controls whether the server request is cached or not...
				oGateway.timeout = #Request.const_js_gateway_time_out_symbol#; // matches the ColdFusion time-out which is 120 secs at SBC...
				oGateway.sendPacket(URLEncode(sValue));
			}

			function window_onload() {
				init();
				
				_global_clientWidth = clientWidth();
	
				global_allow_loading_data_message = true;
				
				register_jsapi_function("clear_showServerCommand_Ends();");
				
				handle_next_jsapi_function(); // kick-start the process of fetching HTML from the server...
			}
	
			function window_onUnload() {
				// BEGIN: Clean-Up any Objects that are still laying about to ensure there are no memory leaks in case there were any closures...
	
				// BEGIN: This is where some bad evil things will happen unless these global variables were successfully initialized...
			//	try { js_Global = ((!!js_Global) ? object_destructor(js_Global) : null); } catch(e) {}																		// avoid closures by destroying the previous object before making a new one...
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
		//-->
		</script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
		// place this on the page where you want the gateway to appear
			oGateway.create();
		//-->
		</script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			document.write('<div id="html_container" style="display: inline; position: absolute; top: 0px; left: ' + (clientWidth() - const_jsapi_width_value) + 'px">');
			document.write('</div>');
		// -->
		</script>
		
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function queueUp_AJAX_Sessions() {
				var jsCode = '';
				var pQueryString = '';

				jsCode = "var pQueryString = '&spanName=' + '#const_layerNameRecord_symbol#' + '&col1_keyName=ID&col2_keyName=LAYERNAME&col3_keyName=LAYERDISPLAYNAME&div_name=div_contents3&editor_title_bar=Layer Names&cfm_add_cmd=addLayerName&cfm_save_cmd=saveLayerName&cfm_drop_cmd=dropLayerName'; ";
				jsCode += "oGateway.addNamedContext('#const_layerNameRecord_symbol#', pQueryString); ";
				jsCode += "global_maxRecsPerPage['#const_layerNameRecord_symbol#'] = 5; ";
				jsCode += "execJSAPI_func('getLayerNames', 'displayTopLevelMenuNames(" + oGateway.js_global_varName + ")'); ";
				register_jsapi_function(jsCode);

				jsCode = "var pQueryString = '&spanName=' + '#const_groupNameRecord_symbol#' + '&col1_keyName=ID&col2_keyName=LAYERGROUPNAME&div_name=div_contents2&editor_title_bar=Group Names&cfm_add_cmd=addGroupName&cfm_save_cmd=saveGroupName&cfm_drop_cmd=dropGroupName'; ";
				jsCode += "oGateway.addNamedContext('#const_groupNameRecord_symbol#', pQueryString); ";
				jsCode += "global_maxRecsPerPage['#const_groupNameRecord_symbol#'] = 5; ";
				jsCode += "execJSAPI_func('getGroupNames', 'displayTopLevelMenuNames(" + oGateway.js_global_varName + ")'); ";
				register_jsapi_function(jsCode);

				jsCode = "var pQueryString = ''; ";
				jsCode += "oGateway.addNamedContext('#const_menuGroupRecord_symbol#', pQueryString); ";
				jsCode += "global_maxRecsPerPage['#const_menuGroupRecord_symbol#'] = 10; ";
				jsCode += "execJSAPI_func('getMenuGroupNames', 'displayMenuGroupNames(" + oGateway.js_global_varName + ")'); ";
				register_jsapi_function(jsCode);

				pQueryString = '&spanName=' + '#const_menuRecord_symbol#' + '&col1_keyName=ID&col2_keyName=MENUNAME&div_name=div_contents&editor_title_bar=Menu Names&cfm_add_cmd=addTopLevelMenuName&cfm_save_cmd=saveTopLevelMenuName&cfm_drop_cmd=dropTopLevelMenuName';
				oGateway.addNamedContext('#const_menuRecord_symbol#', pQueryString); // spanName is the name of the context... the GUI follows this same pattern...
				global_maxRecsPerPage['#const_menuRecord_symbol#'] = 5;
				execJSAPI_func('getTopLevelMenuNames', 'displayTopLevelMenuNames(' + oGateway.js_global_varName + ')');
			}

			function xmlHttpRequestObj() {
				var xmlObj = -1;
			    // branch for native XMLHttpRequest object
			    if (window.XMLHttpRequest) {
			    	try {
						xmlObj = new XMLHttpRequest();
			        } catch(e) {
						xmlObj = -1;
			        }
			    // branch for IE/Windows ActiveX version
			    } else if (window.ActiveXObject) {
			       	try {
			        	xmlObj = new ActiveXObject("Msxml2.XMLHTTP");
			      	} catch(e) {
			        	try {
			          		xmlObj = new ActiveXObject("Microsoft.XMLHTTP");
			        	} catch(e) {
			          		xmlObj = -1;
			        	}
					}
			    }
				return xmlObj;
			}
			
			function processReqChange0() {
				window.status = 'CB(0)';
			}

			function processReqChange1() {
				window.status = 'CB(1)';
			}
			
			function processReqChange2() {
				window.status = 'CB(2)';
			}

			function processReqChange3() {
				window.status = 'CB(3)';
			}

			function processReqChange4() {
				window.status = 'CB(4)';
			}

			function processReqChange5() {
				window.status = 'CB(5)';
			}

			function processReqChange6() {
				window.status = 'CB(6)';
			}

			function processReqChange7() {
				window.status = 'CB(7)';
			}
			
			function queueUp_AJAX_Sessions2() {
				var i = -1;
				var gObj = -1;
				var cObj = -1;
				
				ar_oGateway_CB.push(processReqChange0);
				ar_oGateway_CB.push(processReqChange1);
				ar_oGateway_CB.push(processReqChange2);
				ar_oGateway_CB.push(processReqChange3);
				ar_oGateway_CB.push(processReqChange4);
				ar_oGateway_CB.push(processReqChange5);
				ar_oGateway_CB.push(processReqChange6);
				ar_oGateway_CB.push(processReqChange7);
				
				for (i = 0; i < 8; i++) {
					cObj = getGUIObjectInstanceById('div_browser_patch_detect_' + i);
					if (!!cObj) {
						ar_oGateway_Div.push(cObj);
					}

					gObj = xmlHttpRequestObj()
					gObj.onreadystatechange = ar_oGateway_CB[i];
					ar_oGateway.push(gObj);
					
					ar_oGateway_CB_RC.push(-1);
				}

				cObj = getGUIObjectInstanceById('div_browser_patch_detect');
				if (!!cObj) {
					cObj.style.display = const_inline_style;
				}
				alert('ar_oGateway = [' + ar_oGateway + ']' + ', ar_oGateway.length = [' + ar_oGateway.length + ']' + ', ar_oGateway_CB = [' + ar_oGateway_CB + ']' + ', ar_oGateway_CB.length = [' + ar_oGateway_CB.length + ']' + ', ar_oGateway_Div.length = [' + ar_oGateway_Div.length + ']' + ', ar_oGateway_CB_RC = [' + ar_oGateway_CB_RC + ']');
			}

			function perform_click_btn_addMenuName(_spanName, _cfm_add_cmd, _cfm_save_cmd) {
				var bool_performing_btn_addMenuName = true;
				var cObj = getGUIObjectInstanceById('btn_addMenuName_' + _spanName);
				if (!!cObj) {
					if (cObj.value == const_edit_button_symbol) {
						bool_performing_btn_addMenuName = false;
					}
				}
				var eObj = getGUIObjectInstanceById('txt_menuName_' + _spanName);
				if (!!eObj) {
					if (eObj.value.trim().length > 0) {
						oGateway.setContextName(_spanName);
						if (bool_performing_btn_addMenuName) {
							execJSAPI_func(_cfm_add_cmd, 'displayTopLevelMenuNames(' + oGateway.js_global_varName + ')', eObj.value.trim());
						} else {
							execJSAPI_func(_cfm_save_cmd, 'displayTopLevelMenuNames(' + oGateway.js_global_varName + ')', eObj.value.trim(), eObj.title.trim());
						}
					} else {
						alert('INFO: Unable to process the requested action unless there is some data to act upon. Currently the only data there is to act upon is (' + eObj.value + ') however this makes no sense at the moment.  PLS try again.');
					}
				}
			}

			function disableActionPanelWidets(_spanName) {
				var i = -1;
				var cObj1 = -1;
				var cObj2 = -1;
				var _handle1 = -1;
				var _handle2 = -1;
				
				for (i = 1; i; i++) {
					cObj1 = getGUIObjectInstanceById('btn_editMenuName_' + _spanName + '_' + i);
					cObj2 = getGUIObjectInstanceById('btn_dropMenuName_' + _spanName + '_' + i);
					if ( (!!cObj1) && (!!cObj2) ) {
						_handle1 = global_guiActionsObj.push(cObj1.id);
						if (_handle1 > -1) {
							global_guiActionsObj.replaceAspectNamedFor(_handle1, 'disabled', true);
						}
						_handle2 = global_guiActionsObj.push(cObj2.id);
						if (_handle2 > -1) {
							global_guiActionsObj.replaceAspectNamedFor(_handle2, 'disabled', true);
						}
					} else {
						break;
					}
				}
			}
			
			function perform_click_btn_dropMenuName(_objID_prefix, _iNum, _recID, _spanName, _cfm_drop_cmd) {
				disableActionPanelWidets(_spanName);
				var _handle1 = global_guiActionsObj.push('btn_addMenuName_' + _spanName);
				if (_handle1 > -1) {
					global_guiActionsObj.replaceAspectNamedFor(_handle1, 'disabled', true);
				}

				if (confirm('Are you sure you really want to delete that record from the database ?')) {
					_recID = ((!!_recID) ? _recID : -1);
					if (_recID > -1) {
						oGateway.setContextName(_spanName);
						execJSAPI_func(_cfm_drop_cmd, 'global_guiActionsObj.popAll(); displayTopLevelMenuNames(' + oGateway.js_global_varName + ')', _recID);
					} else {
						alert('ERROR: Programming ERROR - This message should NEVER ever been seen so this means someone, shall we call him/her the programmer ?!?  Forgot something.  Oops !');
					}
				} else {
					global_guiActionsObj.popAll();
				}
			}
			
			function perform_click_btn_editMenuName(_objID_prefix, _iNum, _recID, _spanName, vararg_params) {
				var bool_isSingleColData = true;
				var _title = '';
				if (_spanName.toUpperCase() == '#const_menuRecord_symbol#'.toUpperCase()) {
					_title = 'Menu Name';
				} else if (_spanName.toUpperCase() == '#const_groupNameRecord_symbol#'.toUpperCase()) {
					_title = 'Group Name';
				} else if (_spanName.toUpperCase() == '#const_layerNameRecord_symbol#'.toUpperCase()) {
					bool_isSingleColData = false;
					_title = 'Layer Name(s)';
				}

				var _handle = global_guiActionsObj.push('btn_addMenuName_' + _spanName);
				if (_handle > -1) {
					global_guiActionsObj.replaceAspectNamedFor(_handle, 'value', const_edit_button_symbol);
					global_guiActionsObj.replaceAspectNamedFor(_handle, 'title', 'Click to Save the edited ' + _title + ' to the Db.');
				}
				var _handle2 = global_guiActionsObj.push('btn_revertMenuName_' + _spanName);
				if (_handle2 > -1) {
					global_guiActionsObj.replaceStyleNamedFor(_handle2, 'display', 'display: ' + const_inline_style + ';');
				}

				if (bool_isSingleColData == false) {
					var theArgs = [];
					var ar = [];
					var i = 0;
					var j = -1;
				    for (i = 0; i < arguments.length - 4; i++) {
						ar = arguments[i + 4].split(',');
						for (j = 0; j < ar.length; j++) {
							theArgs.push(ar[j]);
						}
					}
// +++
					var cObj3a = -1;
					var _handle3a = -1;
					var _objID_ = '';
					ar = _objID_prefix.split('_');
					var _f = -1;
				    for (i = 0; i < theArgs.length; i++) {
						_f = locateArrayItems(ar, theArgs[i]);
						if (_f > -1) {
							break;
						}
					}

				    for (i = 0; i < theArgs.length; i++) {
						if (_f > -1) ar[_f] = theArgs[i];
						_objID_ = ar.join('_');
						_handle3a = global_guiActionsObj.push('txt_menuName_' + _spanName + '_' + i);
						if (_handle3a > -1) {
							cObj3a = getGUIObjectInstanceById(_objID_ + _iNum.toString());
							if (!!cObj3a) {
								global_guiActionsObj.replaceAspectNamedFor(_handle3a, 'title', _recID);
								global_guiActionsObj.replaceAspectNamedFor(_handle3a, 'value', cObj3a.innerHTML.stripHTML());
							}
						}
					}
				} else {
					var _handle3 = global_guiActionsObj.push('txt_menuName_' + _spanName + ((bool_isSingleColData == false) ? '_1' : ''));
					if (_handle3 > -1) {
						var cObj = getGUIObjectInstanceById(_objID_prefix + _iNum.toString());
						if (!!cObj) {
							global_guiActionsObj.replaceAspectNamedFor(_handle3, 'title', _recID);
							global_guiActionsObj.replaceAspectNamedFor(_handle3, 'value', cObj.innerHTML.stripHTML());
							setFocusSafelyById('txt_menuName_' + _spanName + ((bool_isSingleColData == false) ? '_0' : ''));
						}
					}
				}
// +++
				disableActionPanelWidets(_spanName);
			}

			function perform_click_btn_revertMenuName() {
				global_guiActionsObj.popAll();
			}

			function onChange_EventHandler(oObj) {
				var aValue = '';
				if ( (!!oObj) && (!!oObj.options) && (!!oObj.selectedIndex) ) {
					aValue = oObj.options[oObj.selectedIndex].value;
					global_maxRecsPerPage[oGateway.currentContextName] = parseInt(aValue);
					var _handle1 = global_guiActionsObj.push(oObj.id);
					if (_handle1 > -1) {
						global_guiActionsObj.replaceAspectNamedFor(_handle1, 'disabled', true);
					}
					queueUp_AJAX_Sessions();
				}
			 }
			
			function displayEditorControlPanel() {
				var _html = '';
				return _html; // comment this code-out for now.
				if (oGateway.currentContextName == oGateway.namedContextStack[0]) {
					_html += '<table width="*" border="1" bgcolor="' + const_paper_color_light_yellow + '" cellpadding="-1" cellspacing="-1" style="margin-bottom: 20px;">';
					_html += '<tr>';
					_html += '<td>';
	
					_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
					_html += '<tr>';
					_html += '<td>';
	
					_html += '<span class="workingStatusClass">Max Records Per Logical Page:</span>&nbsp;';
	
					_html += '<select id="select_max_recs_per_page" class="textClass" onchange="onChange_EventHandler(this); return false;">';
	
					_html += '<option value="" ' + ((global_maxRecsPerPage[oGateway.currentContextName] > 0) ? '' : 'SELECTED') + '>';
					_html += 'Choose...';
					_html += '</option>';
	
					_html += '<option value="5"' + ((global_maxRecsPerPage[oGateway.currentContextName] == 5) ? 'SELECTED' : '') + '>';
					_html += '5';
					_html += '</option>';
	
					_html += '<option value="10"' + ((global_maxRecsPerPage[oGateway.currentContextName] == 10) ? 'SELECTED' : '') + '>';
					_html += '10';
					_html += '</option>';
	
					_html += '</select>';
					
					_html += '';
	
					_html += '</td>';
					_html += '</tr>';
					_html += '</table>';
	
					_html += '</td>';
					_html += '</tr>';
					_html += '</table>';
				}

				return _html;
			}

			function refreshIntraPageNav(aContext) {
				var adjustedMaxRecsPageCount = global_maxRecsPageCount[aContext];
				var cObj = getGUIObjectInstanceById('btn_intraPageNav_Up_' + aContext);
				if (!!cObj) {
					cObj.disabled = ((global_currentRecsPageBeingDisplayed[aContext] == 1) ? true : false);
					cObj.style.display = ((adjustedMaxRecsPageCount == 1) ? const_none_style : const_inline_style);
				}

				var dObj = getGUIObjectInstanceById('btn_intraPageNav_Dn_' + aContext);
				if (!!dObj) {
					dObj.disabled = (((adjustedMaxRecsPageCount > 1) && (global_currentRecsPageBeingDisplayed[aContext] < adjustedMaxRecsPageCount)) ? false : true);
					dObj.style.display = ((adjustedMaxRecsPageCount == 1) ? const_none_style : const_inline_style);
				}
			}
			
			function advanceIntraPageNav(offset, aContextName) {
				function hideShowRecordContainers(aPageNum, bool_hideOrShow) {
					var i = -1;
					var cObj = -1;
					
					if ( (!!aPageNum) && (typeof aPageNum != const_object_symbol) ) {
						bool_hideOrShow = ((bool_hideOrShow == true) ? bool_hideOrShow : false);
						for (i = 1; i <= global_maxRecsPerPage[aContextName]; i++) {
							cObj = getGUIObjectInstanceById('tr_recordContainer_' + aContextName + '_' + aPageNum + '_' + i);
							if (!!cObj) {
								cObj.style.display = ((bool_hideOrShow) ? const_inline_style : const_none_style);
							}
						}
					} else {
						alert('ERROR: (hideShowRecordContainers) :: Programming Error - The variable known as aPageNum has the value of (' + aPageNum + ') and typeof (' + (typeof aPageNum) + ') which is invalid for this function.');
					}
				}
				hideShowRecordContainers(global_currentRecsPageBeingDisplayed[aContextName], false);
				if ( ( (offset > 0) && ((global_currentRecsPageBeingDisplayed[aContextName] + offset) <= global_maxRecsPageCount) ) || ((global_currentRecsPageBeingDisplayed[aContextName] + offset) >= 1) ) {
					hideShowRecordContainers(global_currentRecsPageBeingDisplayed[aContextName] + offset, true);
				}
				global_currentRecsPageBeingDisplayed[aContextName] = global_currentRecsPageBeingDisplayed[aContextName] + offset;
				refreshIntraPageNav(aContextName);
			}

			function clickEventHandler_Record(sData, aContextName, aRecID) {
				var cObj = getGUIObjectInstanceById('span_' + aContextName);
				if (!!cObj) {
					cObj.innerHTML = sData;
					global_dict.push(sData, aRecID);
				}
				if (canPerformAssociateMenu2Group()) {
					var _handle1 = global_guiActionsObj.push('btn_addMenuGroupMapping');
					if (_handle1 > -1) {
						global_guiActionsObj.replaceAspectNamedFor(_handle1, 'disabled', false);
					}
				}
			}
			
			function initIntraPageNavPanelButtons() {
				function initCurrentRecsPageBeingDisplayedFor(aContext) {
					if (!global_currentRecsPageBeingDisplayed[aContext]) {
						global_currentRecsPageBeingDisplayed[aContext] = 1;
					}

					if (!global_maxRecsPageCount[aContext]) {
						global_maxRecsPageCount[aContext] = 1;
					}
					
					refreshIntraPageNav(aContext);
					
					var aPageNum = -1;
					var cObj = -1;
					var _id = '';
					// BEGIN: Determine how many actual pages of records there really are...
					for (aPageNum = 1; aPageNum <= global_maxRecsPageCount[aContext] + 1; aPageNum++) {
						_id = 'tr_recordContainer_' + aContext + '_' + aPageNum + '_' + 1;
						cObj = getGUIObjectInstanceById(_id);
						if (!!cObj) {
							global_maxRecsPageCount[aContext] = aPageNum;
						} else {
							break;
						}
					}
					// END! Determine how many actual pages of records there really are...
				}
				
				function initCurrentRecsPageBeingDisplayed(arContexts) {
					var i = -1;
					if (!!arContexts) {
						try {
							if (typeof arContexts == const_string_symbol) {
								return initCurrentRecsPageBeingDisplayedFor(arContexts);
							} else if (!!arContexts.length) {
								for (i = 0; i < arContexts.length; i++) {
									initCurrentRecsPageBeingDisplayedFor(arContexts[i]);
								}
							}
						} catch(e) {
						} finally {
						}
					}
				}

				// BEGIN: Init the global_currentRecsPageBeingDisplayed based on the number of contexts being managed by oGateway object...
				initCurrentRecsPageBeingDisplayed(oGateway.namedContextStack);
				// END! Init the global_currentRecsPageBeingDisplayed based on the number of contexts being managed by oGateway object...
			}

			function intraPageNavPanel(_wid, _bgColor) {
				var html = '';
				var _border = '0';
				
				html = '<table height="140" width="' + _wid + '" border="' + _border + '" bgcolor="' + _bgColor + '" cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td>' + '<button id="btn_intraPageNav_Up_' + oGateway.currentContextName + '" class="buttonClass" title="Scroll the Records List back One Page of Records" onclick="advanceIntraPageNav(-1,\'' + oGateway.currentContextName + '\'); return false;">[^]</button>' + '</td>';
				html += '</tr>';
				html += '<tr>';
				html += '<td>' + '<button id="btn_intraPageNav_Dn_' + oGateway.currentContextName + '" class="buttonClass" title="Scroll the Records List forward One Page of Records" onclick="advanceIntraPageNav(1,\'' + oGateway.currentContextName + '\'); return false;">[v]</button>' + '</td>';
				html += '</tr>';
				html += '</table>';
				
				return html;
			}
				
			function displayTable(someHtml, _width, bgColor, _border) {
				var _html = '';
				
				_html = '<table width="' + _width + '" border="' + _border + '" cellpadding="-1" cellspacing="-1">';
				_html += '<tr bgcolor="' + bgColor + '" valign="top">';
				_html += '<td>' + someHtml + '</td>';
				_html += '<td valign="top">' + intraPageNavPanel(_width, bgColor) + '</td>';
				_html += '</tr>';
				_html += '</table>';
				
				return _html;
			};

			function displayTopLevelMenuNames(qObj) {
				var _html = '';
				var _html_ = '';
				var oParms = -1;
				var i = -1;
				var iInc = 1;
				var argCnt = -1;
				var args = [];
				var _spanName = '';
				var _col1_keyName = '';
				var _col2_keyName = '';
				var _col3_keyName = '';
				var _div_name = '';
				var _editor_title_bar = '';
				var _cfm_add_cmd = '';
				var _cfm_save_cmd = '';
				var _cfm_drop_cmd = '';
				var bool_isAnyErrorRecords = false;
				var bool_isAnyPKErrorRecords = false;
				var s_explainError = '';
				var i_recordContainerNumber = 1; // use to coordinate the paging of records from the server...
				var i_recordContainerCount = 1; // the number of records in the current container...

				function displayActionsPanel(objID_prefix, iNum, recID, i_leftOrRight, bool_isHorz, vararg_params) {
					var someHtml = '';
					var _title = '';
					
					bool_isHorz = ((bool_isHorz == true) ? bool_isHorz : false);
					i_leftOrRight = (((i_leftOrRight == 1) || (i_leftOrRight == 2)) ? i_leftOrRight : -1);
					
					_title = '';
					if (_spanName.toUpperCase() == '#const_menuRecord_symbol#'.toUpperCase()) {
						_title = 'a Menu Name';
					} else if (_spanName.toUpperCase() == '#const_groupNameRecord_symbol#'.toUpperCase()) {
						_title = 'a Group Name';
					} else if (_spanName.toUpperCase() == '#const_layerNameRecord_symbol#'.toUpperCase()) {
						bool_isSingleColData = false;
						_title = 'Layer Name(s)';
					}
					
					someHtml = '<table width="100%" cellpadding="-1" cellspacing="-1">';
					someHtml += '<tr>';
					if (i_leftOrRight == 2) someHtml += '<td><button id="btn_dropMenuName_' + _spanName + '_' + iNum + '" class="buttonClass" title="Click to Delete ' + _title + ' from the Db." onclick="perform_click_btn_dropMenuName(\'' + objID_prefix + '\',' + iNum + ',' + recID + ',\'' + _spanName + '\',\'' + _cfm_drop_cmd + '\'); return false;">' + const_delete_button_symbol + '</button></td>';
					if ( (bool_isHorz == false) && ( (i_leftOrRight != 1) || (i_leftOrRight != 2) ) ) {
						someHtml += '</tr>';
						someHtml += '<tr>';
					}
					var theArgs = [];
				    for (var i = 0; i < arguments.length - 5; i++) {
						if (objID_prefix != arguments[i + 5]) theArgs.push(arguments[i + 5]);
					}
					if (i_leftOrRight == 1) someHtml += '<td><button id="btn_editMenuName_' + _spanName + '_' + iNum + '" class="buttonClass" title="Click to Edit ' + _title + ' in the Db." onclick="perform_click_btn_editMenuName(\'' + objID_prefix + '\',' + iNum + ',' + recID + ',\'' + _spanName + '\',\'' + theArgs + '\'); return false;">' + const_edit_button_symbol + '</button></td>';
					someHtml += '</tr>';
					someHtml += '</table>';
					
					return someHtml;
				};

				function makeRecordLink(sData, spanName, recID, colID) { // colID is the number 0..nCols that indicates which column we are dealing with...
					var _html = '';
					var showLink = true;
					
					if (colID == 0) {
						showLink = false;
					}
					
					_html += ((showLink == false) ? '' : '<a href="" onclick="clickEventHandler_Record(\'' + sData + '\',\'' + spanName + '\',\'' + recID + '\'); return false;">') + sData + ((showLink == false) ? '' : '</a>');

					return _html;
				}
				
				function displayRecord(_ri, _dict, _rowCntName) {
					var i = -1;
					var _ID = '';
					var _dataVal = '';
					var _rowCnt = -1;
					var cStyle = '';
					var anHTML = '';
					var _rowStyle = '';
					var _widthPcent = -1;
					var _widthPcent_tally = -1;
					var _dataVals = [];
					var _col_keyNames = [];
					
					try {
						_ID = _dict.getValueFor(_col1_keyName);
						_dataVal = _dict.getValueFor(_col2_keyName);
						if (_dataVal.length > 0) {
							_dataVals.push(_dataVal);
							_col_keyNames.push(_col2_keyName);
						}
						_dataVal = _dict.getValueFor(_col3_keyName);
						if (_dataVal.length > 0) {
							_dataVals.push(_dataVal);
							_col_keyNames.push(_col3_keyName);
						}
						_rowCnt = _dict.getValueFor(_rowCntName);
					} catch(e) {
					} finally {
					}

					cStyle = ((i_recordContainerNumber == 1) ? const_inline_style : const_none_style);
					anHTML = '<tr id="tr_recordContainer_' + _spanName + '_' + i_recordContainerNumber + '_' + i_recordContainerCount + '" style="display: ' + cStyle + ';">';

					_html += anHTML;
					_rowStyle = ((_ri < _rowCnt) ? 'border-bottom: thin solid Silver;' : '');
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_ACTION_LEFT_' + _ri + '" class="normalStatusClass">' + displayActionsPanel('span_' + _spanName + '_' + _col2_keyName + '_', _ri, _ID, 1, true, _col_keyNames) + '</span></td>'; // this is the ACTIONS column...
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_' + _col1_keyName + '_' + _ri + '" class="normalStatusClass">' + _ri + '</span></td>';       // this is the ID column...
					if (_dataVals.length > 1) {  // this is a compound data column that is composed of more than one column of data...
						_html += '<td style="' + _rowStyle + '">';
						_html += '<table width="100%" border="1" cellpadding="-1" cellspacing="-1">';
						_html += '<tr>';
						_widthPcent_tally = 0;
						_widthPcent = _int(100 / _dataVals.length);
						for (i = 0; i < _dataVals.length; i++) {
							if (i == (_dataVals.length - 1)) {
								_widthPcent = 100 - _widthPcent_tally;
							}
							_html += '<td width="' + _widthPcent + '%" align="center" valign="top">';
							_html += '<span id="span_' + _spanName + '_' + _col_keyNames[i] + '_' + _ri + '" class="normalStatusClass">' + makeRecordLink(_dataVals[i], _spanName, _ID, i) + '</span>';
							_html += '</td>';
							_widthPcent_tally += _widthPcent;
						}
						_html += '</tr>';
						_html += '</table>';
						_html += '</td>';
					} else {
						_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_' + _col2_keyName + '_' + _ri + '" class="normalStatusClass">' + makeRecordLink(_dataVals[0], _spanName, _ID) + '</span></td>'; // this is the data column...
					}
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_ACTION_RIGHT_' + _ri + '" class="normalStatusClass">' + displayActionsPanel('span_' + _spanName + '_' + _col2_keyName + '_', _ri, _ID, 2, true) + '</span></td>'; // this is the ACTIONS column...
					_html += '</tr>';
					
					if (global_maxRecsPerPage[_spanName] > 0) {
						if (i_recordContainerCount == global_maxRecsPerPage[_spanName]) {
							i_recordContainerNumber++;
							i_recordContainerCount = 0;

							if (!global_maxRecsPageCount[oGateway.currentContextName]) {
								global_maxRecsPageCount[oGateway.currentContextName] = 1;
							} else {
								global_maxRecsPageCount[oGateway.currentContextName] = i_recordContainerNumber;
							}
						}
					}
					i_recordContainerCount++;
				};

				function displayControlPanel() {
					var _title = '';
					var bool_isSingleColData = true;
					if (_spanName.toUpperCase() == '#const_menuRecord_symbol#'.toUpperCase()) {
						_title = 'a Menu Name';
					} else if (_spanName.toUpperCase() == '#const_groupNameRecord_symbol#'.toUpperCase()) {
						_title = 'a Group Name';
					} else if (_spanName.toUpperCase() == '#const_layerNameRecord_symbol#'.toUpperCase()) {
						bool_isSingleColData = false;
						_title = 'Layer Name(s)';
					}
					_html += '<tr>';
					_html += '<td><button id="btn_addMenuName_' + _spanName + '" class="buttonClass" title="Click to Add ' + _title + ' to the Db." onclick="perform_click_btn_addMenuName(\'' + _spanName + '\',\'' + _cfm_add_cmd + '\',\'' + _cfm_save_cmd + '\'); return false;">' + const_add_button_symbol + '</button></td>';
					_html += '<td colspan="2">';
					_html += '<input type="text" class="textEntryClass" id="txt_menuName_' + _spanName + ((bool_isSingleColData) ? '' : '_0') + '" size="' + ((bool_isSingleColData) ? '30' : '15') + '" maxlength="50">';
					_html += ((bool_isSingleColData) ? '' : '<input type="text" class="textEntryClass" id="txt_menuName_' + _spanName + '_1' + '" size="' + '15' + '" maxlength="50">')
					_html += '</td>';
					_html += '<td><button id="btn_revertMenuName_' + _spanName + '" class="buttonClass" style="display: none;" title="Click to revert the chosen Action." onclick="perform_click_btn_revertMenuName(); return false;">[<<]</button></td>';
					_html += '</tr>';
				};

				function searchForRec(_ri, _dict, _rowCntName) {
					var n = _dict.getValueFor('NAME');
					var v = _dict.getValueFor('VAL');
					if (n.trim().toUpperCase().indexOf('ARG') != -1) {
						if (n.trim().toUpperCase() == 'ARGCNT') {
							argCnt = v;
						} else {
							args.push(v);
							if (args.length == argCnt) {
								return 0;
							}
						}
					}
				}

				function anyErrorRecords(_ri, _dict, _rowCntName) {
					var errorMsg = '';
					var isPKerror = '';
					
					try {
						errorMsg = _dict.getValueFor('ERRORMSG');
						isPKerror = _dict.getValueFor('ISPKVIOLATION');
					} catch(e) {
					} finally {
					}

					bool_isAnyErrorRecords = ( (!!errorMsg) && (errorMsg.length > 0) );
					bool_isAnyPKErrorRecords = ( (!!isPKerror) && (isPKerror.length > 0) );
					
					s_explainError = '';

					if ( (bool_isAnyErrorRecords) || (bool_isAnyPKErrorRecords) ) {
						try {
							s_explainError = _dict.getValueFor('ERRORMSG').stripHTML().stripSpacesBy2s().stripCrLfs().stripTabs(' ');
						} catch(e) {
						} finally {
						}
					}
				};
				
				var nRecs = -1;
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData = qObj.named('qData1');
					if (!!qData) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							oParms.iterateRecObjs(searchForRec);
						//	_alert(oParms);
							iInc = 1;
							for (i = 0; i < args.length; i += iInc) {
								if ( (!!oGateway.namedContextCache[oGateway.currentContextName]) && (!!oGateway.namedContextCache[oGateway.currentContextName].parmsDict.getValueFor(args[i])) ) {
									if (args[i].toUpperCase() == 'spanName'.toUpperCase()) {
										_spanName = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'col1_keyName'.toUpperCase()) {
										_col1_keyName = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'col2_keyName'.toUpperCase()) {
										_col2_keyName = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'col3_keyName'.toUpperCase()) {
										_col3_keyName = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'div_name'.toUpperCase()) {
										_div_name = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'editor_title_bar'.toUpperCase()) {
										_editor_title_bar = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'cfm_add_cmd'.toUpperCase()) {
										_cfm_add_cmd = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'cfm_save_cmd'.toUpperCase()) {
										_cfm_save_cmd = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'cfm_drop_cmd'.toUpperCase()) {
										_cfm_drop_cmd = args[i + 1];
									}
									iInc = 2;
								} else {
									iInc = 1;
								}
							}
						}

						_html = '<table width="100%" cellpadding="-1" cellspacing="-1">';
						_html += '<tr bgcolor="silver">';
						_html += '<td><span id="span_' + _spanName + '_HEADER_1" title="*" class="normalStatusBoldClass">&nbsp;</span></td>';
						_html += '<td><span id="span_' + _spanName + '_HEADER_2" title="ID" class="normalStatusBoldClass">##</span></td>';
						_html += '<td colspan="2"><span id="span_' + _spanName + '_HEADER_3" title="MENUNAME" class="normalStatusBoldClass">' + _editor_title_bar + '</span></td>';
						_html += '</tr>';

						// BEGIN: Determine if there is an error condition and handle the error gracefully...
						qData.iterateRecObjs(anyErrorRecords);
						if (!bool_isAnyErrorRecords) {
							// iterate over the Query Obj pulling out data...
							qData.iterateRecObjs(displayRecord);
							displayControlPanel();
						}
						// END! Determine if there is an error condition and handle the error gracefully...

						_html += '</table>';
						_html = displayTable(_html, '*', const_paper_color_light_yellow, 1);

						// BEGIN: Only update the display when there are no errors... this wastes some processing time but we need to get this code done on-time - this issue can be resolved, if necessary, at a later time...
						if (!bool_isAnyErrorRecords) {
							var cObj = getGUIObjectInstanceById(_div_name);
							if (!!cObj) {
								var cObj2b = getGUIObjectInstanceById('table_editor_contents');
								if (!cObj2b) {
									global_htmlStream = '<table id="table_editor_contents" width="100%" border="1" cellpadding="5" cellspacing="-1">';
									global_htmlStream += '<tr>';
									global_htmlStream += '<td width="50%" valign="top" align="left">';

									global_htmlStream += '<table width="100%" cellpadding="5" cellspacing="-1">';
									global_htmlStream += '<tr>';
									global_htmlStream += '<td width="280" valign="top" align="left">';
									global_htmlStream += '<div id="div_displayEditorControlPanel">(1)</div>';
									global_htmlStream += '</td>';
									global_htmlStream += '<td valign="top" align="center">';
									global_htmlStream += '<div id="div_contents_#const_menuRecord_symbol#">(Menu Names Editor)</div>';
									global_htmlStream += '</td>';
									global_htmlStream += '<td valign="top" align="center">';
									global_htmlStream += '<div id="div_contents_#const_layerNameRecord_symbol#">(Layer Names Editor)</div>';
									global_htmlStream += '</td>';
									global_htmlStream += '</tr>';
									global_htmlStream += '<tr>';
									global_htmlStream += '<td valign="top" align="left">';
									global_htmlStream += '&nbsp;'
									global_htmlStream += '</td>';
									global_htmlStream += '<td valign="top" align="center">';
									global_htmlStream += '<div id="div_contents_#const_groupNameRecord_symbol#">(Group Names Editor)</div>';
									global_htmlStream += '</td>';
									global_htmlStream += '</tr>';
									global_htmlStream += '</table>';

									global_htmlStream += '</td>';
									global_htmlStream += '<td width="50%" valign="top" align="left">';
									global_htmlStream += '<div id="div_contents_#const_menuGroupRecord_symbol#">(4)</div>';
									global_htmlStream += '</td>';
									global_htmlStream += '</tr>';
									global_htmlStream += '</table>';

									flushGUIObjectChildrenForObj(cObj);
									cObj.innerHTML = global_htmlStream;

									var cObj2 = getGUIObjectInstanceById('div_displayEditorControlPanel');
									if (!!cObj2) {
										cObj2.innerHTML = displayEditorControlPanel();
									}

									global_htmlStream = '';
								}

								var cObj2a = getGUIObjectInstanceById('div_contents_' + oGateway.currentContextName);
								if (!!cObj2a) {
									cObj2a.innerHTML = _html;
								}

								global_guiActionsObj.popAll();
								initIntraPageNavPanelButtons();
							} else {
								alert('ERROR: Programming Error - The variable argument to execJSAPI() known as "' + _div_name + '" has not been defined and is missing...');
							}
						} else {
							_alert(s_explainError);
						}
						// END! Only update the display when there are no errors... this wastes some processing time but we need to get this code done on-time - this issue can be resolved, if necessary, at a later time...

						var eObj = getGUIObjectInstanceById('txt_menuName_' + _spanName);
						if (!!eObj) {
							eObj.focus();
						}
					}
				} else {
					alert('ERROR: Programming Error or Database Error - No Data was provided to the displayTopLevelMenuNames() callBack for the "' + oGateway.currentContextName + '" context.');
				}
			}

			function canPerformAssociateMenu2Group() {
				var menuName = '';
				var groupName = '';
				var bool_canPerformAssociateMenu2Group = false;
				
				var cObj1 = getGUIObjectInstanceById('span_#const_menuRecord_symbol#');
				var cObj2 = getGUIObjectInstanceById('span_#const_groupNameRecord_symbol#');
				if ( (!!cObj1) && (!!cObj2) ) {
					menuName = cObj1.innerHTML.stripHTML().trim();
					groupName = cObj2.innerHTML.stripHTML().trim();
					bool_canPerformAssociateMenu2Group = ( (menuName.length > 0) && (groupName.length > 0) );
				}
				return bool_canPerformAssociateMenu2Group;
			}

			function performAssociateMenu2Group() {
				var menuName = '';
				var groupName = '';
				
				var cObj1 = getGUIObjectInstanceById('span_#const_menuRecord_symbol#');
				var cObj2 = getGUIObjectInstanceById('span_#const_groupNameRecord_symbol#');
				if ( (!!cObj1) && (!!cObj2) ) {
					menuName = cObj1.innerHTML.stripHTML().trim();
					groupName = cObj2.innerHTML.stripHTML().trim();
					oGateway.setContextName('#const_menuGroupRecord_symbol#');
				//	_alert('performAssociateMenu2Group() :: ' + 'menuName = [' + menuName + ']' + ', groupName = [' + groupName + ']' + '\n' + 'oGateway.currentContextName = [' + oGateway.currentContextName + ']' + ', oGateway.namedContextCache[' + oGateway.currentContextName + '] = [' + oGateway.namedContextCache[oGateway.currentContextName] + ']' + '\nglobal_dict = [' + global_dict + ']');
					execJSAPI_func('saveMenuGroupAssociation', 'displayMenuGroupNames(' + oGateway.js_global_varName + ')', global_dict.getValueFor(menuName), global_dict.getValueFor(groupName));
				}
			}
			
			function perform_click_btn_dropMenuGroupName(_objID_prefix, _iNum, _recID, _spanName) {
				disableActionPanelWidets(_spanName);
				var _handle1 = global_guiActionsObj.push('btn_addMenuName_' + _spanName);
				if (_handle1 > -1) {
					global_guiActionsObj.replaceAspectNamedFor(_handle1, 'disabled', true);
				}

				if (confirm('Are you sure you really want to delete that record from the database ?')) {
					_recID = ((!!_recID) ? _recID : -1);
					if (_recID > -1) {
						oGateway.setContextName(_spanName);
						execJSAPI_func('dropMenuGroupAssociation', 'global_guiActionsObj.popAll(); displayMenuGroupNames(' + oGateway.js_global_varName + ')', _recID);
					} else {
						alert('ERROR: Programming ERROR - This message should NEVER ever been seen so this means someone, shall we call him/her the programmer ?!?  Forgot something.  Oops !');
					}
				} else {
					global_guiActionsObj.popAll();
				}
			}

			function dropItemFrom(item, anObj) {
				var i = -1;
				var x = -1;
				var _db = '';
				_db += 'dropItemFrom(item = [' + item + '], anObj = [' + anObj + '])' + ', (!!anObj) = [' + (!!anObj) + ']' + ', (!!anObj.options) = [' + (!!anObj.options) + ']' + ', (!!anObj.selectedIndex) = [' + (!!anObj.selectedIndex) + ']' + '\n';
				if ( (!!anObj) && (!!anObj.options) ) { //  && (!!anObj.selectedIndex)
					for (i = 0; i < anObj.options.length; i++) {
						x = parseInt(anObj.options[i].value);
						if (x != 'NaN') {
							_db += 'parseInt(anObj.options[' + i + '].value) = [' + x + ']' + ', parseInt(item) = [' + parseInt(item) + ']' + '\n';
							if (x == parseInt(item)) {
								anObj.options[i] = null;
								_alert(_db);
								break;
							}
						}
					}
				}
			}
			
			function onFocus_dispOrder_EventHandler(oObj) {
				var ar = -1;
				var n = -1;

				if ( (!!oObj) && (!!oObj.options) ) {
					ar = oObj.id.split('_');
					n = parseInt(ar[ar.length - 2]);
					global_previous_dispOrder[n] = ((!!oObj.selectedIndex) ? parseInt(oObj.options[oObj.selectedIndex].value) : -1);
				}
			}

			function onChange_dispOrder_EventHandler(oObj) {
				var aValue = '';
				var ar = -1;
				var m = -1;
				var n = -1;
				var id = -1;
				var cObj = -1;
				
				if ( (!!oObj) && (!!oObj.options) && (!!oObj.selectedIndex) ) {
					aValue = parseInt(oObj.options[oObj.selectedIndex].value);
					
					ar = oObj.id.split('_');
					n = parseInt(ar[ar.length - 3]);
					m = parseInt(ar[ar.length - 2]);
					id = parseInt(ar[ar.length - 1]);

					oGateway.setContextName('#const_menuGroupRecord_symbol#');
				//	execJSAPI_func('setMenuGroupDispOrder', 'updateMenuGroupDispOrder(' + oGateway.js_global_varName + ')', oObj.id, aValue);
					execJSAPI_func('setMenuGroupDispOrder', 'displayMenuGroupNames(' + oGateway.js_global_varName + ')', oObj.id, aValue);
				}
			 }

			function updateMenuGroupDispOrder(qObj) {
				var _spanName = '#const_menuGroupRecord_symbol#';

				function displayRecord(_ri, _dict, _rowCntName, queryObj) {
					var _ID = '';
					var _GROUP_ID = '';
					var _MENU_ID = '';
					var _MENUNAME = '';
					var _DISPORDER = '';
					var _LAYERGROUPNAME = '';
					var _rowCnt = -1;
					
					try {
						_ID = _dict.getValueFor('ID');
						_MENU_ID = _dict.getValueFor('MENU_ID');
						_GROUP_ID = _dict.getValueFor('GROUP_ID');
						_MENUNAME = _dict.getValueFor('MENUNAME');
						_DISPORDER = _dict.getValueFor('DISP_ORDER');
						_LAYERGROUPNAME = _dict.getValueFor('LAYERGROUPNAME');
						_rowCnt = _dict.getValueFor(_rowCntName);
					} catch(e) {
					} finally {
					}

					var m = (((!!queryObj) && (typeof queryObj == const_object_symbol)) ? queryObj.recordCount() : -1);
					
					var cObj = getGUIObjectInstanceById('select_menuGroupRecord_disporder_' + _ri + '_' + m + '_' + _ID);
					if (!!cObj) {
						if (cObj.selectedIndex != -1) {
							cObj.options[cObj.selectedIndex].selected = false;
						}
						var i = -1;
						for (i = 0; i < cObj.options.length; i++) {
							if (cObj.options[i].value == _DISPORDER) {
								cObj.options[i].selected = true;
								cObj.selectedIndex = i;
							}
						}
					}
				};

				global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...
				
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData = qObj.named('qData1');
					if (!!qData) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							// no parms are expected so doesn't matter if they arrived...
						}
						oGateway.setContextName(_spanName);
						var cObj = getGUIObjectInstanceById('div_contents_' + oGateway.currentContextName);
						if (!!cObj) {
							if (cObj.innerHTML.length > 0) {
								qData.iterateRecObjs(displayRecord);
							} else {
								alert('ERROR: Programming Error - Missing HTML Content for (' + cObj.id + ').');
							}
						}
					}
				}
			//	_alert(qObj);
			}
			
			function displayMenuGroupNames(qObj) {
				var _html = '';
				var nRecs = -1;
				var _spanName = '#const_menuGroupRecord_symbol#';
				var i_recordContainerNumber = 1; // use to coordinate the paging of records from the server...
				var i_recordContainerCount = 1; // the number of records in the current container...

				function displayActionsPanel(objID_prefix, iNum, recID) {
					var someHtml = '';
					
					someHtml = '<table width="100%" cellpadding="-1" cellspacing="-1">';
					someHtml += '<tr>';
					someHtml += '<td align="center"><button id="btn_dropRecord_' + _spanName + '_' + iNum + '" class="buttonClass" title="Click to Delete a Menu <-> Group Name from the Db." onclick="perform_click_btn_dropMenuGroupName(\'' + objID_prefix + '\',' + iNum + ',' + recID + ',\'' + _spanName + '\'); return false;">' + const_delete_button_symbol + '</button></td>';
					someHtml += '</tr>';
					someHtml += '</table>';
					
					return someHtml;
				};

				function displayRecord(_ri, _dict, _rowCntName, queryObj) {
					var _ID = '';
					var _GROUP_ID = '';
					var _MENU_ID = '';
					var _MENUNAME = '';
					var _DISPORDER = '';
					var _do = '';
					var _LAYERGROUPNAME = '';
					var _rowCnt = -1;
					var cStyle = '';
					var anHTML = '';
					var _rowStyle = '';
					
					function htmlDisplayOrderControls(ri, n, m, recID) {
						var i = -1;
						var anID = '';
						var n_ch = -1;
						var m_ch = -1;
						var html = '';
						
						n = ((!!n) ? ((((n_ch = n.toString().charCodeAt(0)) >= 48) && (n_ch <= 57)) ? n : -1) : -1);
						m = ((!!m) ? ((((m_ch = m.toString().charCodeAt(0)) >= 48) && (m_ch <= 57)) ? m : -1) : -1);
						
						anID = 'select_menuGroupRecord_disporder_' + ri + '_' + m + '_' + recID;
						
						html += '<select id="' + anID + '" class="textClass" onfocus="onFocus_dispOrder_EventHandler(this); return false;" onchange="onChange_dispOrder_EventHandler(this); return false;">';
						html += '<option value=""' + ((n == -1) ? ' SELECTED' : '') + '>(???)</option>';
						for (i = 1; i <= m; i++) {
							html += '<option value="' + i + '"' + ((n == i) ? ' SELECTED' : '') + '>' + i + '</option>';
						}
						html += '</select>';
						return html;
					}

					try {
						_ID = _dict.getValueFor('ID');
						_MENU_ID = _dict.getValueFor('MENU_ID');
						_GROUP_ID = _dict.getValueFor('GROUP_ID');
						_MENUNAME = _dict.getValueFor('MENUNAME');
						_do = _dict.getValueFor('DISP_ORDER');
						_DISPORDER = htmlDisplayOrderControls(_ri, _do, (((!!queryObj) && (typeof queryObj == const_object_symbol)) ? queryObj.recordCount() : -1), _ID);
						_LAYERGROUPNAME = _dict.getValueFor('LAYERGROUPNAME');
						_rowCnt = _dict.getValueFor(_rowCntName);
					} catch(e) {
					} finally {
					}
					
					cStyle = ((i_recordContainerNumber == 1) ? const_inline_style : const_none_style);
					anHTML = '<tr id="tr_recordContainer_' + _spanName + '_' + i_recordContainerNumber + '_' + i_recordContainerCount + '" style="display: ' + cStyle + ';">';

					_html += anHTML;
				//	_rowStyle = ((_ri < _rowCnt) ? 'border-bottom: thin solid Silver;' : '');
					_html += '<td style="' + _rowStyle + ' display: none;"><span id="span_' + _spanName + '_ID_' + _ri + '" class="normalStatusClass">' + _ID + '</span></td>';            // this is the ID column...
					_html += '<td style="' + _rowStyle + ' display: none;"><span id="span_' + _spanName + '_MENUID_' + _ri + '" class="normalStatusClass">' + _MENU_ID + '</span></td>';   // this is the MENU_ID column...
					_html += '<td style="' + _rowStyle + ' display: none;"><span id="span_' + _spanName + '_GROUPID_' + _ri + '" class="normalStatusClass">' + _GROUP_ID + '</span></td>'; // this is the GROUP_ID column...
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_DISPORDER_' + _ri + '" class="normalStatusClass">' + _DISPORDER + '</span></td>';               // this is the MENUNAME column...
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_MENUNAME_' + _ri + '" class="normalStatusClass">' + _MENUNAME + '</span></td>';               // this is the MENUNAME column...
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_LAYERGROUPNAME_' + _ri + '" class="normalStatusClass">' + _LAYERGROUPNAME + '</span></td>';   // this is the LAYERGROUPNAME column...
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_ACTION_' + _ri + '" class="normalStatusClass">' + displayActionsPanel('span_' + _spanName + '_ACTION_', _ri, _ID) + '</span></td>'; // this is the ACTIONS column...
					_html += '</tr>';
					
					if (global_maxRecsPerPage[_spanName] > 0) {
						if (i_recordContainerCount == global_maxRecsPerPage[_spanName]) {
							i_recordContainerNumber++;
							i_recordContainerCount = 0;

							if (!global_maxRecsPageCount[oGateway.currentContextName]) {
								global_maxRecsPageCount[oGateway.currentContextName] = 1;
							} else {
								global_maxRecsPageCount[oGateway.currentContextName] = i_recordContainerNumber;
							}
						}
					}
					i_recordContainerCount++;
				};

				global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...
				
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) { // at present only the first data record is consumed...
					var qData = qObj.named('qData1');
					if (!!qData) {
						oParms = qObj.named('qParms');
						if (!!oParms) {
							// no parms are expected so doesn't matter if they arrived...
						}
						oGateway.setContextName(_spanName);
						var cObj = getGUIObjectInstanceById('div_contents_' + oGateway.currentContextName);
						if (!!cObj) {
							_html = '';
							_html += '<table width="300" cellpadding="-1" cellspacing="-1">';
							_html += '<tr>';
							_html += '<td bgcolor="silver" align="center">';
							_html += '<span class="normalStatusBoldClass">Menu(s) <-> Group(s)</span>';
							_html += '</td>';
							_html += '</tr>';
							_html += '<tr>';
							_html += '<td align="left" valign="top">';
							
							_html += '<table width="100%" border="1" bgcolor="' + const_paper_color_light_yellow + '" cellpadding="-1" cellspacing="-1">';
							_html += '<tr bgcolor="silver">';
							_html += '<td align="center">';
							_html += '<span class="normalStatusBoldClass">Display Order</span>';
							_html += '</td>';
							_html += '<td align="center">';
							_html += '<span class="normalStatusBoldClass">Menu(s)</span>';
							_html += '</td>';
							_html += '<td align="center">';
							_html += '<span class="normalStatusBoldClass">Group(s)</span>';
							_html += '</td>';
							_html += '</tr>';

							qData.iterateRecObjs(displayRecord);

							_html += '<tr bgcolor="' + const_color_light_blue + '">';
							_html += '<td align="center" colspan="2">';
							_html += '<span id="span_#const_menuRecord_symbol#" class="normalStatusBoldClass">&nbsp;</span>';
							_html += '</td>';
							_html += '<td align="center">';
							_html += '<span id="span_#const_groupNameRecord_symbol#" class="normalStatusBoldClass">&nbsp;</span>';
							_html += '</td>';
							_html += '<td align="center">';
							_html += '<button id="btn_addMenuGroupMapping" disabled class="buttonClass" title="Click this button to add the Menu<->Group Associated to the Db." onclick="performAssociateMenu2Group(); return false;">[+]</button>';
							_html += '</td>';
							_html += '</tr>';
							_html += '</table>';

							_html = displayTable(_html, '*', const_paper_color_light_yellow, 1);
							
							flushGUIObjectChildrenForObj(cObj);
							cObj.innerHTML = _html;
							
							initIntraPageNavPanelButtons();
						} else {
							alert('ERROR: Programming error, the element known as (' + 'div_contents_' + oGateway.currentContextName + ') is not present in the document.');
						}
					//	alert('(displayMenuGroupNames) :: ' + 'oGateway.currentContextName = [' + oGateway.currentContextName + ']' + ', qData = [' + qData + ']');
					//	_alert(qData);
					}
				}
			}

		// -->
		</script>

		<b>Welcome to the AJAX powered Beacon Menu Editor !</b>
		<br><br>
		
		<div id="div_sysMessages" style="display: none;">
			<table width="*" border="1" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80">
				<tr>
					<td>
						<table width="*" cellspacing="-1" cellpadding="-1">
							<tr bgcolor="silver">
								<td align="center">
									<span id="span_sysMessages_title" class="boldPromptTextClass"></span>
								</td>
								<td align="right">
									<button class="buttonClass" title="Click this button to dismiss this pop-up." onclick="dismissSysMessages(); return false;">[X]</button>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<span id="span_sysMessages_body" class="textClass"></span>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		
		<table width="*" bgcolor="##80FFFF" border="1" cellpadding="-1" cellspacing="-1">
			<tr>
				<td align="left" style="display: inline;">
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
							<td align="left">
								<button name="btn_helperPanel" id="btn_helperPanel" class="buttonMenuClass" onclick="var cObj = getGUIObjectInstanceById('td_ajaxHelperPanel'); var bObj = getGUIObjectInstanceById('btn_helperPanel'); var tbObj = getGUIObjectInstanceById('table_ajaxHelperPanel'); if ( (!!cObj) && (!!bObj) && (!!tbObj) ) { cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style); bObj.value = ((cObj.style.display == const_inline_style) ? '[<<]' : '[>>]'); if (cObj.style.display == const_inline_style) { tbObj.style.width = _global_clientWidth; oGateway.setDebugMode(); } else { oGateway.setReleaseMode(); }; }; return false;">[>>]</button>
							</td>
						</tr>
					</table>
				</td>
				<td id="td_ajaxHelperPanel" align="center" style="display: none;">
					<table width="100%" cellspacing="-1" cellpadding="-1" id="table_ajaxHelperPanel" style="width: 800px;">
						<tr>
							<td align="center">
								<button name="btn_useDebugMode" id="btn_useDebugMode" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('DEBUG') != -1) { oGateway.setReleaseMode(); this.value = this.value.clipCaselessReplace('Debug', 'Release'); } else { oGateway.setDebugMode(); this.value = this.value.clipCaselessReplace('Release', 'Debug'); }; return false;">[Debug Mode]</button>
							</td>
							<td align="center">
								<button name="btn_useXmlHttpRequest" id="btn_useXmlHttpRequest" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('XMLHTTPREQUEST') == -1) { oGateway.isXmlHttpPreferred = false; this.value = this.value.clipCaselessReplace('iFRAME', 'XmlHttpRequest'); } else { oGateway.isXmlHttpPreferred = true; this.value = this.value.clipCaselessReplace('XMLHTTPREQUEST', 'iFRAME'); }; return false;">[Use iFrame]</button>
							</td>
							<td align="center">
								<button name="btn_useMethodGetOrPost" id="btn_useMethodGetOrPost" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('GET') != -1) { oGateway.setMethodGet(); this.value = this.value.clipCaselessReplace('GET', 'Post'); } else { oGateway.setMethodPost(); this.value = this.value.clipCaselessReplace('POST', 'Get'); }; return false;">[Use Get]</button>
							</td>
							<td align="center">
								<button name="btn_hideShow_iFrame" id="btn_hideShow_iFrame" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('SHOW') != -1) { oGateway.showFrame(); this.value = this.value.clipCaselessReplace('show', 'Hide'); } else { oGateway.hideFrame(); this.value = this.value.clipCaselessReplace('hide', 'Show'); }; return false;">[Show iFrame]</button>
							</td>
							<td align="center">
								<button name="btn_1" id="btn_1" class="buttonMenuClass" onclick="execJSAPI_func('getTopLevelMenuNames'); return false;">[Test]</button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<table width="100%" border="1" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80" style="margin-top: 20px;">
			<tr>
				<td align="left" valign="top">
					<button name="btn_getContents" id="btn_getContents" class="buttonMenuClass" onclick="queueUp_AJAX_Sessions();  return false;">[?]</button>
				</td>
				<td align="left" valign="top">
					<button name="btn_getContents2" id="btn_getContents2" class="buttonMenuClass" onclick="queueUp_AJAX_Sessions2();  return false;">[??]</button>
				</td>
				<td align="left" valign="top">
					<div id="div_contents" style="display: inline;"></div>
					<div id="div_contents3" style="display: inline;"></div>
				</td>
				<td align="left" valign="top">
					<div id="div_contents2" style="display: inline;"></div>
				</td>
			</tr>
		</table>
		
		<div id="div_browser_patch_detect" style="display: none;">
			<table width="100%" border="1" bgcolor="##80FFFF" cellpadding="-1" cellspacing="-1">
				<tr>
					<td>
						<div id="div_browser_patch_detect_0"></div>
					</td>
					<td>
						<div id="div_browser_patch_detect_1"></div>
					</td>
					<td>
						<div id="div_browser_patch_detect_2"></div>
					</td>
					<td>
						<div id="div_browser_patch_detect_3"></div>
					</td>
					<td>
						<div id="div_browser_patch_detect_4"></div>
					</td>
					<td>
						<div id="div_browser_patch_detect_5"></div>
					</td>
					<td>
						<div id="div_browser_patch_detect_6"></div>
					</td>
					<td>
						<div id="div_browser_patch_detect_7"></div>
					</td>
				</tr>
			</table>
		</div>
		
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			oGateway.hideFrame();
			var cObj = getGUIObjectInstanceById('btn_hideShow_iFrame');
			if (!!cObj) {
				if (oGateway.visibility == ((document.layers) ? 'show' : 'visible')) {
					cObj.value = cObj.value.clipCaselessReplace('show', 'Hide');
				}
			}

			var cObj = getGUIObjectInstanceById('btn_useXmlHttpRequest');
			if (!!cObj) {
				if (oGateway.isXmlHttpPreferred == false) {
					cObj.value = cObj.value.clipCaselessReplace('iFRAME', 'XmlHttpRequest');
				}
			}

			var cObj = getGUIObjectInstanceById('btn_useMethodGetOrPost');
			if (!!cObj) {
				if (oGateway.isMethodGet()) {
					cObj.value = cObj.value.clipCaselessReplace('GET', 'Post');
				}
			}

			var cObj = getGUIObjectInstanceById('btn_useDebugMode');
			if (!!cObj) {
				if (oGateway.isReleaseMode() == true) {
					cObj.value = cObj.value.clipCaselessReplace('Debug', 'Release');
				}
			}

		// -->
		</script>

	</body>
	</html>
</cfoutput>
