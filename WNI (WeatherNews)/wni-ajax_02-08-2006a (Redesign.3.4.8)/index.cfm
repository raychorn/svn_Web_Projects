<cfsetting showdebugoutput="No">

<cfset _js_path = "js/">

<cfset _wni_menuEditor_js = "#_js_path#wni_menuEditor.js">

<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>wni-ajax v1.0</title>
		<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 
	
		<script language="JavaScript1.2" src="#_wni_menuEditor_js#" type="text/javascript"></script>

	</head>
	
	<body onload="window_onload()" onunload="window_onUnload()">
	
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function jsErrorExplainer(e, funcName, bool_useAlert) {
				var _db = '';
				var msg = '';
				bool_useAlert = ((bool_useAlert == true) ? bool_useAlert : false);
				_db += "e.number is: " + (e.number & 0xFFFF) + '\n'; 
				_db += "e.description is: " + e.description + '\n'; 
				_db += "e.name is: " + e.name + '\n'; 
				_db += "e.message is: " + e.message + '\n';
				msg = funcName + '\n' + e.toString() + '\n' + _db;
				if (bool_useAlert) alert(msg);
				return msg;
			}
			
			function objectExplainer(obj) {
				var _db = '';
				var m = -1;
				var i = -1;
				var a = [];
				
				_db = '[';
				if ( (!!obj) && (typeof obj == const_object_symbol) ) {
					if (!!obj.length) {
					    for (i = 0; i < obj.length; i++) {
							a.push('obj[' + i + '] = [' + obj[i] + ']');
					    }
					} else {
						for (m in obj) {
							a.push(m + ' = [' + obj[m] + ']');
						}
					}
					_db += a.join(', ');
				} else {
					_db += obj;
				}
				_db += ']';
				return _db;
			}

			/////////////////////////////////////////////////////////////////////////////////////////////////////

			var oMenuDict = DictionaryObj.getInstance();
			var uMenuDict = DictionaryObj.getInstance();
			
			var global_ClientMenuObj = ClientMenuObj.getInstance();

			function _dispaySysMessages(s, t, bool_hideShow, taName) {
				if (taName.toUpperCase() == 'ta_menuHelperPanel'.toUpperCase()) {
					var taObj = _getGUIObjectInstanceById(taName);
					if (!!taObj) {
						taObj.value += s;
					}
				} else {
					var cObj = getGUIObjectInstanceById('div_sysMessages');
					var tObj = getGUIObjectInstanceById('span_sysMessages_title');
					var sObj = getGUIObjectInstanceById('span_sysMessages_body');
					var taObj = _getGUIObjectInstanceById(taName);
					var s_ta = '';
					if ( (!!cObj) && (!!sObj) && (!!tObj) ) {
						bool_hideShow = ((bool_hideShow == true) ? bool_hideShow : false);
						s_ta = ((!!taObj) ? taObj.value : '');
						flushGUIObjectChildrenForObj(sObj);
						sObj.innerHTML = '<textarea id="' + taName + '" class="codeSmaller" cols="150" rows="30" readonly>' + ((s.length > 0) ? s_ta + '\n' : '') + s + '</textarea>';
						flushGUIObjectChildrenForObj(tObj);
						tObj.innerHTML = t;
						cObj.style.display = ((bool_hideShow) ? const_inline_style : const_none_style);
						cObj.style.position = 'absolute';
						cObj.style.left = 10 + 'px';
						cObj.style.top = 10 + 'px';
						cObj.style.width = (clientWidth() - 10) + 'px';
						cObj.style.height = (clientHeight() - 10) + 'px';
					}
				}
			}
			
			function dispaySysMessages(s, t) {
				return _dispaySysMessages(s, t, true, 'textarea_sysMessages_body');
			}
			
			function _alert(s) {
				return dispaySysMessages(s, 'DEBUG');
			}

			function dismissSysMessages() {
				return _dispaySysMessages('', '', false, 'textarea_sysMessages_body');
			}
			
			function _alertM(s) {
				return _dispaySysMessages('-->' + s + '\n', '', true, 'ta_menuHelperPanel');
			}
		//-->
		</script>

		<cfscript>
			const_menuRecord_symbol = 'menuRecord';
			const_groupNameRecord_symbol = 'groupNameRecord';
			const_layerNameRecord_symbol = 'layerNameRecord';

			const_menuGroupRecord_symbol = 'menuGroupRecord';
			const_layerGroupRecord_symbol = 'layerGroupRecord';

			const_menuEditorRecord_symbol = 'menuEditorRecord';

			const_menuDisplayRecord_symbol = 'menuDisplayRecord';

			const_layerEditorRecord_symbol = 'layerEditorRecord';
			
			_site_menu_background_color = "##3081e4";
			_site_menu_text_color = "white";
		</cfscript>	

		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			var currentParentSubMenu_id = -1;

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
			
			var const_div_floating_debug_menu = '#Request.cf_div_floating_debug_menu#';

			var const_paper_color_light_yellow = '#Request.const_paper_color_light_yellow#';
			var const_color_light_blue = '#Request.const_color_light_blue#';

			var const_add_button_symbol = '[+]';
			var const_edit_button_symbol = '[*]';
			var const_delete_button_symbol = '[-]';
			
			var const_jsapi_width_value = 200;

			var global_allow_loading_data_message = false;

			var url_fname = document.location.pathname.substring(0, document.location.pathname.length);
			var _ar = url_fname.split('/');
			_ar[_ar.length - 1] = null;
			var url_sBasePath = 'http:\/\/#CGI.HTTP_HOST#' + _ar.join('/');

			var bool_isServerLocal = (('#Request.commonCode.isServerLocal()#'.toString().trim().toLowerCase() == 'yes') ? true : false);
			
			// BEGIN: This is for the code that is supposed to detect the Registry settings by observation...
			var ar_oAJAXEngine = []; // an array of Gateway Objs - these are xmlHttpRequest objects...
			var ar_oAJAXEngine_CB = []; // an array of Gateway CallBacks - these are functions...
			var ar_oAJAXEngine_CB_RC = []; // an array of Gateway CallBack return codes - these are numbers or flags...
			var ar_oAJAXEngine_Div = []; // an array of div objects - these are functions...
			// END! This is for the code that is supposed to detect the Registry settings by observation...
	
			// create the gateway object
			var oAJAXEngine = AJAXEngine.getInstance(url_sBasePath + ((url_sBasePath.charAt(url_sBasePath.length - 1) == '/') ? '' : '/') + '#Request.cfm_gateway_process_html#', bool_isServerLocal);
			oAJAXEngine.setMethodGet();
			oAJAXEngine.setReleaseMode(); // this overrides the oAJAXEngine.set_isServerLocal() setting...
			oAJAXEngine.isXmlHttpPreferred = true;
			oAJAXEngine.js_global_varName = 'js_Global';
			
			function init() {
				// define the function to run when a packet has been sent to the server
				oAJAXEngine.onSend = function (){
					if (global_allow_loading_data_message == true) {
						showServerCommand_Begins();
					}
				};
		
				// define the function to run when a packet has been received from the server
				oAJAXEngine.onReceive = function (){
					var _db = '';
		
					showServerCommand_Ends();

					// BEGIN: This block of code always returns the JavaScript Query Object known as oAJAXEngine.js_global_varName regardless of the technique that was used to perform the AJAX function...
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
								if (!!jsErrorExplainer) jsErrorExplainer(ee, '1.0', true);
							} finally {
							}
						}
					} catch(e) {
						if (!!jsErrorExplainer) jsErrorExplainer(ee, '1.0', true);
					} finally {
					}
					if (this.isDebugMode()) alert('oAJAXEngine.mode = [' + oAJAXEngine.mode + ']' + '\n' + oAJAXEngine.js_global_varName + ' = [' + js_Global + ']' + '\n' + this.received);
					// END! This block of code always returns the JavaScript Query Object known as oAJAXEngine.js_global_varName regardless of the technique that was used to perform the AJAX function...

					handle_next_jsapi_function(); // get the next item from the stack...
				};
		
				oAJAXEngine.onTimeout = function (){
					this.throwError("The current request has timed out.\nPlease try your request again.");
					showServerCommand_Ends();
					handle_next_jsapi_function(); // get the next item from the stack...
				};
			}
	
			function doAJAX_func(cmd, callBackFuncName, vararg_params) {
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
			    // END! Make the arguments into a series of URL Parms, as-required, don't worry the AJAX Engine will figure out how to handle all this data...

				if (oAJAXEngine.isXmlHttpPreferred == false) {
					oAJAXEngine.setMethodGet();
				}
				oAJAXEngine.sendPacket(URLEncode(sValue));
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
				var cObj = getGUIObjectInstanceById(const_cf_html_container_symbol);
				if (!!cObj) {
					cObj.style.top = document.body.scrollTop + 'px';
					cObj.style.left = (window.document.body.scrollWidth - 200) + 'px';

					var dObj = getGUIObjectInstanceById(const_div_floating_debug_menu);
					if (!!dObj) {
						dObj.style.position = cObj.style.position;
						dObj.style.top = parseInt(cObj.style.top) + 25 + 'px';
						dObj.style.left = (clientWidth() - 75) + 'px';
						
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
				var dObj = getGUIObjectInstanceById(const_div_floating_debug_menu);
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
		//-->
		</script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
		// place this on the page where you want the gateway to appear
			oAJAXEngine.create();
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
			function queueUp_AJAX_Sessions3() {
				var jsCode = '';
				var pQueryString = '';

				pQueryString = '';
				oAJAXEngine.addNamedContext('#const_menuDisplayRecord_symbol#', pQueryString);
				doAJAX_func('getMenuEditorContents', 'displayClientMenuData(' + oAJAXEngine.js_global_varName + ')');
			}
			
			function queueUp_AJAX_Sessions4() {
				var jsCode = '';
				var pQueryString = '';

				pQueryString = '';
				oAJAXEngine.addNamedContext('#const_layerEditorRecord_symbol#', pQueryString);
				doAJAX_func('getLayerEditorContents', 'displayLayerEditorData(' + oAJAXEngine.js_global_varName + ')');
			}

			function queueUp_AJAX_Sessions() {
				var jsCode = '';
				var pQueryString = '';

				jsCode = "var pQueryString = ''; ";
				jsCode += "oAJAXEngine.addNamedContext('#const_menuEditorRecord_symbol#', pQueryString); ";
				jsCode += "global_maxRecsPerPage['#const_menuEditorRecord_symbol#'] = 10; ";
				jsCode += "doAJAX_func('getMenuEditorContents', 'displayMenuEditor(" + oAJAXEngine.js_global_varName + ")'); ";
				register_jsapi_function(jsCode);

				jsCode = "var pQueryString = '&spanName=' + '#const_groupNameRecord_symbol#' + '&col1_keyName=ID&col2_keyName=LAYERGROUPNAME&div_name=div_contents2&editor_title_bar=Group Names&cfm_add_cmd=addGroupName&cfm_save_cmd=saveGroupName&cfm_drop_cmd=dropGroupName'; ";
				jsCode += "oAJAXEngine.addNamedContext('#const_groupNameRecord_symbol#', pQueryString); ";
				jsCode += "global_maxRecsPerPage['#const_groupNameRecord_symbol#'] = 10; ";
				jsCode += "doAJAX_func('getGroupNames', 'displayTopLevelMenuNames(" + oAJAXEngine.js_global_varName + ")'); ";
				register_jsapi_function(jsCode);

				jsCode = "var pQueryString = '&spanName=' + '#const_layerNameRecord_symbol#' + '&col1_keyName=ID&col2_keyName=LAYERNAME&col3_keyName=LAYERDISPLAYNAME&div_name=div_contents3&editor_title_bar=Layer Names&cfm_add_cmd=addLayerName&cfm_save_cmd=saveLayerName&cfm_drop_cmd=dropLayerName'; ";
				jsCode += "oAJAXEngine.addNamedContext('#const_layerNameRecord_symbol#', pQueryString); ";
				jsCode += "global_maxRecsPerPage['#const_layerNameRecord_symbol#'] = 10; ";
				jsCode += "doAJAX_func('getLayerNames', 'displayTopLevelMenuNames(" + oAJAXEngine.js_global_varName + ")'); ";
				register_jsapi_function(jsCode);

				pQueryString = '&spanName=' + '#const_menuRecord_symbol#' + '&col1_keyName=ID&col2_keyName=MENUNAME&div_name=div_contents&editor_title_bar=Menu Names&cfm_add_cmd=addTopLevelMenuName&cfm_save_cmd=saveTopLevelMenuName&cfm_drop_cmd=dropTopLevelMenuName';
				oAJAXEngine.addNamedContext('#const_menuRecord_symbol#', pQueryString); // spanName is the name of the context... the GUI follows this same pattern...
				global_maxRecsPerPage['#const_menuRecord_symbol#'] = 5;
				doAJAX_func('getTopLevelMenuNames', 'displayTopLevelMenuNames(' + oAJAXEngine.js_global_varName + ')');
			}

			function perform_click_btn_addMenuName(_spanName, _cfm_add_cmd, _cfm_save_cmd) {
				var i = -1;
				var bool_performing_btn_addMenuName = true;
				var cObj = getGUIObjectInstanceById('btn_addMenuName_' + _spanName);
				if (!!cObj) {
					if (cObj.value == const_edit_button_symbol) {
						bool_performing_btn_addMenuName = false;
					}
				}
				var dataVals = [];
				var eObj = -1;
				for (i = 0; i < 10; i++) { // allow for more columns... is 10 enough ?
					eObj = getGUIObjectInstanceById('txt_menuName_' + _spanName + '_' + i);
					if (!!eObj) {
						if (bool_performing_btn_addMenuName) {
							dataVals.push(eObj.value.trim());
						} else {
							dataVals.push(eObj.value.trim());
							dataVals.push(eObj.title.trim());
						}
					} else {
						break;
					}
				}
				oAJAXEngine.setContextName(_spanName);
				if (dataVals.length > 0) {
					if (bool_performing_btn_addMenuName) {
						doAJAX_func(_cfm_add_cmd + '_v', 'displayTopLevelMenuNames(' + oAJAXEngine.js_global_varName + ')', dataVals.length, dataVals);
					} else {
						doAJAX_func(_cfm_save_cmd + '_v', 'displayTopLevelMenuNames(' + oAJAXEngine.js_global_varName + ')', dataVals.length, dataVals);
					}
				} else {
					eObj = getGUIObjectInstanceById('txt_menuName_' + _spanName);
					if (!!eObj) {
						if (eObj.value.trim().length > 0) {
							if (bool_performing_btn_addMenuName) {
								doAJAX_func(_cfm_add_cmd, 'displayTopLevelMenuNames(' + oAJAXEngine.js_global_varName + ')', eObj.value.trim());
							} else {
								doAJAX_func(_cfm_save_cmd, 'displayTopLevelMenuNames(' + oAJAXEngine.js_global_varName + ')', eObj.value.trim(), eObj.title.trim());
							}
						} else {
							alert('INFO: Unable to process the requested action unless there is some data to act upon. Currently the only data there is to act upon is (' + eObj.value + ') however this makes no sense at the moment.  PLS try again.');
						}
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
						oAJAXEngine.setContextName(_spanName);
						doAJAX_func(_cfm_drop_cmd, 'global_guiActionsObj.popAll(); displayTopLevelMenuNames(' + oAJAXEngine.js_global_varName + ')', _recID);
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
							} else {
								alert('ERROR: Programming Error - Unable to locate the widget named (' + _objID_ + _iNum.toString() + ')');
							}
						} else {
							alert('ERROR: Programming Error - Unable to locate the widget named (' + 'txt_menuName_' + _spanName + '_' + i + ')');
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

				disableActionPanelWidets(_spanName);
			}

			function perform_click_btn_revertMenuName() {
				global_guiActionsObj.popAll();
			}

			function onChange_EventHandler(oObj) {
				var aValue = '';
				if ( (!!oObj) && (!!oObj.options) && (!!oObj.selectedIndex) ) {
					aValue = oObj.options[oObj.selectedIndex].value;
					global_maxRecsPerPage[oAJAXEngine.currentContextName] = parseInt(aValue);
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
				if (oAJAXEngine.currentContextName == oAJAXEngine.namedContextStack[0]) {
					_html += '<table width="*" border="1" bgcolor="' + const_paper_color_light_yellow + '" cellpadding="-1" cellspacing="-1" style="margin-bottom: 20px;">';
					_html += '<tr>';
					_html += '<td>';
	
					_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
					_html += '<tr>';
					_html += '<td>';
	
					_html += '<span class="workingStatusClass">Max Records Per Logical Page:</span>&nbsp;';
	
					_html += '<select id="select_max_recs_per_page" class="textClass" onchange="onChange_EventHandler(this); return false;">';
	
					_html += '<option value="" ' + ((global_maxRecsPerPage[oAJAXEngine.currentContextName] > 0) ? '' : 'SELECTED') + '>';
					_html += 'Choose...';
					_html += '</option>';
	
					_html += '<option value="5"' + ((global_maxRecsPerPage[oAJAXEngine.currentContextName] == 5) ? 'SELECTED' : '') + '>';
					_html += '5';
					_html += '</option>';
	
					_html += '<option value="10"' + ((global_maxRecsPerPage[oAJAXEngine.currentContextName] == 10) ? 'SELECTED' : '') + '>';
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
				var mObj = getGUIObjectInstanceById('te_menuEditorPrompt');
				if (!!mObj) {
					mObj.value = sData;
					global_dict.push(sData, [aRecID,aContextName]);
				//	_alert(global_dict);
					menuEditorObj.refreshMenuItemEditorSaveButton(menuEditorObj.instances[global_menuEditorObj.id]);
				}
			//	alert('clickEventHandler_Record(sData = [' + sData + '], aContextName = [' + aContextName + '], aRecID = [' + aRecID + '])');
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

				// BEGIN: Init the global_currentRecsPageBeingDisplayed based on the number of contexts being managed by oAJAXEngine object...
				initCurrentRecsPageBeingDisplayed(oAJAXEngine.namedContextStack);
				// END! Init the global_currentRecsPageBeingDisplayed based on the number of contexts being managed by oAJAXEngine object...
			}

			function intraPageNavPanel(_wid, _bgColor) {
				var html = '';
				var _border = '0';
				
				html = '<table height="140" width="' + _wid + '" border="' + _border + '" bgcolor="' + _bgColor + '" cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td>' + '<button id="btn_intraPageNav_Up_' + oAJAXEngine.currentContextName + '" class="buttonClass" title="Scroll the Records List back One Page of Records" onclick="advanceIntraPageNav(-1,\'' + oAJAXEngine.currentContextName + '\'); return false;">[^]</button>' + '</td>';
				html += '</tr>';
				html += '<tr>';
				html += '<td>' + '<button id="btn_intraPageNav_Dn_' + oAJAXEngine.currentContextName + '" class="buttonClass" title="Scroll the Records List forward One Page of Records" onclick="advanceIntraPageNav(1,\'' + oAJAXEngine.currentContextName + '\'); return false;">[v]</button>' + '</td>';
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

							if (!global_maxRecsPageCount[oAJAXEngine.currentContextName]) {
								global_maxRecsPageCount[oAJAXEngine.currentContextName] = 1;
							} else {
								global_maxRecsPageCount[oAJAXEngine.currentContextName] = i_recordContainerNumber;
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

				function searchForArgRecs(_ri, _dict, _rowCntName) {
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
							oParms.iterateRecObjs(searchForArgRecs);
						//	_alert(oParms);
							iInc = 1;
							for (i = 0; i < args.length; i += iInc) {
								if ( (!!oAJAXEngine.namedContextCache[oAJAXEngine.currentContextName]) && (!!oAJAXEngine.namedContextCache[oAJAXEngine.currentContextName].parmsDict.getValueFor(args[i])) ) {
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

									global_htmlStream += '<table width="100%" cellpadding="5" cellspacing="-1">';
									global_htmlStream += '<tr>';
									global_htmlStream += '<td valign="top" align="left">';
									global_htmlStream += '<div id="div_contents_#const_menuRecord_symbol#">(Menu Names Editor)</div>';
									global_htmlStream += '</td>';
									global_htmlStream += '</tr>';
									global_htmlStream += '<tr>';
									global_htmlStream += '<td valign="top" align="left">';
									global_htmlStream += '<div id="div_contents_#const_groupNameRecord_symbol#">(Group Names Editor)</div>';
									global_htmlStream += '</td>';
									global_htmlStream += '</tr>';
									global_htmlStream += '</table>';
									global_htmlStream += '</td>';

									global_htmlStream += '<td valign="top" align="center">';
									global_htmlStream += '<div id="div_contents_#const_layerNameRecord_symbol#">(Layer Names Editor)</div>';
									global_htmlStream += '</td>';

									global_htmlStream += '</tr>';
								//	global_htmlStream += '<tr>';
								//	global_htmlStream += '<td valign="top" align="left">';
								//	global_htmlStream += '&nbsp;'
								//	global_htmlStream += '</td>';
								//	global_htmlStream += '<td valign="top" align="center">';
								//	global_htmlStream += '</td>';
								//	global_htmlStream += '</tr>';
									global_htmlStream += '</table>';

									global_htmlStream += '</td>';
									global_htmlStream += '<td width="50%" valign="top" align="left">';
									global_htmlStream += '<table width="100%" cellpadding="5" cellspacing="-1">';
									global_htmlStream += '<tr>';
								//	global_htmlStream += '<td align="left" valign="top">';
								//	global_htmlStream += '<div id="div_contents_#const_menuGroupRecord_symbol#">(Menu(s)<->Group(s))</div>';
								//	global_htmlStream += '</td>';
								//	global_htmlStream += '<td align="left" valign="top">';
								//	global_htmlStream += '<div id="div_contents_#const_layerGroupRecord_symbol#">(Group(s)<->Layer(s))</div>';
								//	global_htmlStream += '</td>';
									global_htmlStream += '<td align="left" valign="top">';
									global_htmlStream += '<div id="div_contents_#const_menuEditorRecord_symbol#">(Menu Editor)</div>';
									global_htmlStream += '</td>';
									global_htmlStream += '</tr>';
									global_htmlStream += '</table>';
									global_htmlStream += '</td>';
									global_htmlStream += '</tr>';
									global_htmlStream += '</table>';

									flushGUIObjectChildrenForObj(cObj);
									cObj.innerHTML = global_htmlStream;

									var cObj2 = getGUIObjectInstanceById('div_displayEditorControlPanel');
									if (!!cObj2) {
										flushGUIObjectChildrenForObj(cObj2);
										cObj2.innerHTML = displayEditorControlPanel();
									}

									global_htmlStream = '';
								}

								var cObj2a = getGUIObjectInstanceById('div_contents_' + oAJAXEngine.currentContextName);
								if (!!cObj2a) {
									flushGUIObjectChildrenForObj(cObj2a);
									cObj2a.innerHTML = _html;
								}

								global_guiActionsObj.popAll();
								initIntraPageNavPanelButtons();
							} else {
								alert('ERROR: Programming Error - The variable argument to doAJAX_func() known as "' + _div_name + '" has not been defined and is missing...');
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
					alert('ERROR: Programming Error or Database Error - No Data was provided to the displayTopLevelMenuNames() callBack for the "' + oAJAXEngine.currentContextName + '" context.');
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
					oAJAXEngine.setContextName('#const_menuGroupRecord_symbol#');
					doAJAX_func('saveMenuGroupAssociation', 'displayMenuGroupNames(' + oAJAXEngine.js_global_varName + ')', global_dict.getValueFor(menuName), global_dict.getValueFor(groupName));
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
						oAJAXEngine.setContextName(_spanName);
						doAJAX_func('dropMenuGroupAssociation', 'global_guiActionsObj.popAll(); displayMenuGroupNames(' + oAJAXEngine.js_global_varName + ')', _recID);
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
				if ( (!!anObj) && (!!anObj.options) ) { //  && (!!anObj.selectedIndex)
					for (i = 0; i < anObj.options.length; i++) {
						x = parseInt(anObj.options[i].value);
						if (x != 'NaN') {
							if (x == parseInt(item)) {
								anObj.options[i] = null;
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

					oAJAXEngine.setContextName('#const_menuGroupRecord_symbol#');
					doAJAX_func('setMenuGroupDispOrder', 'displayMenuGroupNames(' + oAJAXEngine.js_global_varName + ')', oObj.id, aValue);
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
						oAJAXEngine.setContextName(_spanName);
						var cObj = getGUIObjectInstanceById('div_contents_' + oAJAXEngine.currentContextName);
						if (!!cObj) {
							if (cObj.innerHTML.length > 0) {
								qData.iterateRecObjs(displayRecord);
							} else {
								alert('ERROR: Programming Error - Missing HTML Content for (' + cObj.id + ').');
							}
						}
					}
				}
			}

			function _displayAbstractGroupNames(qObj, _spanName) {
				var _html = '';
				var nRecs = -1;
				var oParms = -1;
				var aDict = -1;
				var argCnt = -1;
				var args = [];
				var _titleText = '';
				var _col1Text = '';
				var _col2Text = '';
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

				function convertArgsToDict() {
					var i = -1;
					var d = DictionaryObj.getInstance();
					for (i = 0; i < args.length; i += 2) {
						d.push(args[i], args[i + 1]);
					}
					return d;
				}
				
				function searchForArgRecs(_ri, _dict, _rowCntName) {
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

							if (!global_maxRecsPageCount[oAJAXEngine.currentContextName]) {
								global_maxRecsPageCount[oAJAXEngine.currentContextName] = 1;
							} else {
								global_maxRecsPageCount[oAJAXEngine.currentContextName] = i_recordContainerNumber;
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
							oParms.iterateRecObjs(searchForArgRecs);
							qObj.push('ArgsDict', convertArgsToDict());
							aDict = qObj.named('ArgsDict');
							if (!!aDict) {
							}
						//	_alert(oParms);
						//	_alert('argCnt = [' + argCnt + ']' + ', args = [' + args + ']');
						//	alert(aDict);

							oAJAXEngine.setContextName(_spanName);
							var cObj = getGUIObjectInstanceById('div_contents_' + oAJAXEngine.currentContextName);
							if (!!cObj) {
								_col1Text = ((_spanName == '#const_menuGroupRecord_symbol#') ? 'Menu(s)' : ((_spanName == '#const_layerGroupRecord_symbol#') ? 'Group(s)' : 'undefined'));
								_col2Text = ((_spanName == '#const_menuGroupRecord_symbol#') ? 'Group(s)' : ((_spanName == '#const_layerGroupRecord_symbol#') ? 'Layer(s)' : 'undefined'));
								_titleText = _col1Text + ' <-> ' + _col2Text;
								_html = '';
								_html += '<table width="300" cellpadding="-1" cellspacing="-1">';
								_html += '<tr>';
								_html += '<td bgcolor="silver" align="center">';
								_html += '<span class="normalStatusBoldClass">' + _titleText + '</span>';
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
								_html += '<span class="normalStatusBoldClass">' + _col1Text + '</span>';
								_html += '</td>';
								_html += '<td align="center">';
								_html += '<span class="normalStatusBoldClass">' + _col2Text + '</span>';
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
								alert('ERROR: Programming error, the element known as (' + 'div_contents_' + oAJAXEngine.currentContextName + ') is not present in the document.');
							}
						}
					//	_alert(qData);
					}
				}
			}

			function displayMenuGroupNames(qObj) {
				return _displayAbstractGroupNames(qObj, '#const_menuGroupRecord_symbol#');
			}
			
			function displayLayerGroupNames(qObj) {
				return _displayAbstractGroupNames(qObj, '#const_layerGroupRecord_symbol#');
			}

			function _onCommitMenuSomething(v, currentParentSubMenu_id, offset) { // returns a Dictionary instance...
				var aDict = DictionaryObj.getInstance();
				var ar = [];
				var srcId = -1;
				var parentId = -1;
				var dispOrder = ((offset != null) ? offset : -1);
				var menuUUID = -1;
				var ar = [];
				try {
					ar = v[0].split('|');
				} catch(e) {
					ar = v.split('|');
				} finally {
				}
				var srcTableName = '';
				if (ar.length > 2) {
					var ar2 = global_dict.getValueFor(ar[2].URLDecode());
					if (!!ar2) {
						srcId = ((ar2.length > 0) ? ar2[0] : -1);
						srcTableName = ((ar2.length > 1) ? ar2[1] : -1);
					}
					menuUUID = ar[1];
				} else {
					alert('ERROR: Programming Error - Expected 3 items in the ar array but only got (' + ar.length + ') in global_menuEditorObj.onCommitSubMenu().');
				}
				if (srcTableName.toUpperCase() == '#const_menuRecord_symbol#'.toUpperCase()) {
					srcTableName = 'AvnMenu';
				} else if (srcTableName.toUpperCase() == '#const_groupNameRecord_symbol#'.toUpperCase()) {
					srcTableName = 'AvnGroupName';
				} else if (srcTableName.toUpperCase() == '#const_layerNameRecord_symbol#'.toUpperCase()) {
					srcTableName = 'AvnLayer';
				}
				aDict.push('srcTableName', srcTableName);
				aDict.push('srcId', srcId);
				aDict.push('menuUUID', menuUUID);
				aDict.push('parentId', ((currentParentSubMenu_id > -1) ? currentParentSubMenu_id : parentId));
				aDict.push('dispOrder', dispOrder);
				return aDict;
			}

			function _onCommitMenuMetaData(sPrompt, currentParentSubMenu_id) { // returns a Dictionary instance...
				var aDict = DictionaryObj.getInstance();
				var srcId = -1;
				var parentId = -1;
				var menuUUID = uuid();
				var srcTableName = '';
				var iAR = global_dict.getValueFor(sPrompt.URLDecode());
//_alert('_onCommitMenuMetaData(sPrompt = [' + sPrompt + '], currentParentSubMenu_id = [' + currentParentSubMenu_id + '])');
//_alert('\n\niAR = [' + iAR + ']');
				srcId = ((iAR.length > 0) ? iAR[0] : -1);
				srcTableName = ((iAR.length > 1) ? iAR[1] : -1);

				if (srcTableName.toUpperCase() == '#const_menuRecord_symbol#'.toUpperCase()) {
					srcTableName = 'AvnMenu';
				} else if (srcTableName.toUpperCase() == '#const_groupNameRecord_symbol#'.toUpperCase()) {
					srcTableName = 'AvnGroupName';
				} else if (srcTableName.toUpperCase() == '#const_layerNameRecord_symbol#'.toUpperCase()) {
					srcTableName = 'AvnLayer';
				}
				aDict.push('srcTableName', srcTableName);
				aDict.push('srcId', srcId);
				aDict.push('menuUUID', menuUUID);
				aDict.push('parentId', ((currentParentSubMenu_id > -1) ? currentParentSubMenu_id : parentId));
//_alert('\n\naDict = [' + aDict + ']');
				return aDict;
			}

			function processMenuRecordsAbstract(_ri, _dict, _rowCntName, queryObj) {
				var _ID = '';
				var _PROMPT = '';
				var _MENUUUID = -1;
				var _PARENT_ID = -1;
				var _PARENTUUID = -1;
				var _SRCID = -1;
				var _SRCTABLENAME = '';
				var _DISPORDER = '';
				var _rowCnt = -1;

				try {
					_ID = _dict.getValueFor('ID');
					_PROMPT = _dict.getValueFor('PROMPT');
					_MENUUUID = _dict.getValueFor('MENUUUID');
					_PARENT_ID = _dict.getValueFor('PARENT_ID');
					_PARENTUUID = _dict.getValueFor('PARENTUUID');
					_SRCID = _dict.getValueFor('SRCID');
					_SRCTABLENAME = _dict.getValueFor('SRCTABLENAME');
					_DISPORDER = _dict.getValueFor('DISPORDER');
					_rowCnt = _dict.getValueFor(_rowCntName);
				} catch(e) {
				} finally {
				}

				_PARENTUUID = ((_PARENTUUID.trim().length == 0) ? '-1' : _PARENTUUID);
				
				var eDISPORDER = -1;
				var aVal = oMenuDict.getValueFor(_PARENTUUID);
				if (aVal == null) {
					eDISPORDER = 0;
				} else if (typeof aVal != const_object_symbol) {
					eDISPORDER = 1;
				} else {
					eDISPORDER = aVal.length;
				}
				_dict.put('DISPORDER', eDISPORDER);
				oMenuDict.push(_PARENTUUID, '&_ri=' + _ri + _dict.asQueryString());
				
				uMenuDict.push(_MENUUUID, '&_ri=' + _ri + _dict.asQueryString());
			}
			
			function refreshMenuForLevelAbstract(pID) {
				var kids = -1;
				var tDict = -1;
				var optObj = -1;
				var aPrompt = '';
				var aMENUUUID = '';
				var isParent = false;
				var _sel = -1;
				var brObj = getGUIObjectInstanceById('menu_browser'); 
				if (!!brObj) { 
					kids = oMenuDict.getValueFor(pID);
					if (typeof kids != const_object_symbol) {
						var oAR = [];
						if ( (!!kids) && (kids.length > 0) ) oAR.push(kids);
						kids = oAR;
					}
					_sel = brObj.selectedIndex;
					while (brObj.options.length > 0) {
						brObj.options[0] = null;
					}
					for (var j = 0; j < kids.length; j++) {
						tDict = DictionaryObj.getInstance(kids[j]);
						aPrompt = tDict.getValueFor('PROMPT');
						aMENUUUID = tDict.getValueFor('MENUUUID');
						isParent = ((oMenuDict.getValueFor(aMENUUUID) == null) ? false : true);
						optObj = new Option(((isParent) ? '(' : '') + aPrompt + ((isParent) ? ')' : ''), aMENUUUID);
						brObj.options[brObj.options.length] = optObj;
						DictionaryObj.removeInstance(tDict.id);
					}
					brObj.selectedIndex = _sel;
				}
			}

			function displayMenuEditor(qObj) {
				var i = -1;
				var nRecs = -1;
				var oParms = -1;
				var _spanName = '#const_menuEditorRecord_symbol#';
				var coMenuDict = DictionaryObj.getInstance();
				var cuMenuDict = DictionaryObj.getInstance();
				var _isParent = false;
				var _isInsideParent = false;
				var selected_MENUUUID = -1;
				var a_selected_Dict = -1;
				var dispOrder = -1;
				var sPrompt = '';

				function displayRecord(_ri, _dict, _rowCntName, queryObj) {
					return processMenuRecordsAbstract(_ri, _dict, _rowCntName, queryObj);
				};
				
				function refreshMenuForLevel(pID) {
					return refreshMenuForLevelAbstract(pID);
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
						//	_alert(oParms);

							oAJAXEngine.setContextName(_spanName);
							var cObj = getGUIObjectInstanceById('div_contents_' + oAJAXEngine.currentContextName);
							if (!!cObj) {
								_html = '';
	
								global_menuEditorObj = menuEditorObj.getInstance('div_menuEditor', 'menu_browser', '#_site_menu_text_color#', 400);
								_html += global_menuEditorObj.getGUIcontainer('div_menuEditor_container');

								global_menuEditorObj.onOpenAddMenuItem = function (brObj) {
									var cObj = getGUIObjectInstanceById('div_contents_menuRecord');
									if (!!cObj) {
										cObj.disabled = true;
									}
									
									var cObj = getGUIObjectInstanceById('div_contents_groupNameRecord');
									if (!!cObj) {
										cObj.disabled = true;
									}

									if (!!brObj) dispOrder = brObj.selectedIndex;
									_alertM('global_menuEditorObj.onOpenAddMenuItem() :: ' + 'dispOrder = [' + dispOrder + ']');
								}
								
								global_menuEditorObj.onCloseMenuItemEditor = function (brObj) {
									var cObj = getGUIObjectInstanceById('div_contents_menuRecord');
									if (!!cObj) {
										cObj.disabled = false;
									}

									var cObj = getGUIObjectInstanceById('div_contents_groupNameRecord');
									if (!!cObj) {
										cObj.disabled = false;
									}

									var cObj = getGUIObjectInstanceById('div_contents_layerNameRecord');
									if (!!cObj) {
										cObj.disabled = false;
									}

									if (!!brObj) brObj.selectedIndex = dispOrder;
									_alertM('global_menuEditorObj.onCloseMenuItemEditor() :: ' + 'brObj.selectedIndex = [' + brObj.selectedIndex + ']');
								}
								
								global_menuEditorObj.onOpenAddSubMenu = function () {
									var cObj = getGUIObjectInstanceById('div_contents_layerNameRecord');
									if (!!cObj) {
										cObj.disabled = true;
									}

									_alertM('global_menuEditorObj.onOpenAddSubMenu() :: ');
								}

								global_menuEditorObj.onEditMenuItem = function (brObj, epObj) {
									if (brObj.selectedIndex > -1) {
										selected_MENUUUID = brObj.options[brObj.selectedIndex].value;
										_isParent = ((oMenuDict.getValueFor(selected_MENUUUID) == null) ? false : true);
	
										epObj.value = brObj.options[brObj.selectedIndex].text;
									//	_alert('oMenuDict = [' + oMenuDict + ']' + '\n\n' + 'uMenuDict = [' + uMenuDict + ']');
										_alertM('global_menuEditorObj.onEditMenuItem() :: ' + 'epObj.value = [' + epObj.value + ']' + ', selected_MENUUUID = [' + selected_MENUUUID + ']' + ', _isParent = [' + _isParent + ']');
									}
								}
								
								global_menuEditorObj.onSaveMenuItem = function (brObj, epObj) {
									sPrompt = epObj.value;
									var aDict = _onCommitMenuMetaData(sPrompt, currentParentSubMenu_id);
									var srcId = aDict.getValueFor('srcId');
									if (!!srcId) {
										doAR = oMenuDict.getValueFor(currentParentSubMenu_id);
										if (typeof doAR != const_object_symbol) {
											var _ar = [];
											_ar.push(doAR);
											doAR = _ar;
										}
										if (dispOrder < 0) {
											var doDict = DictionaryObj.getInstance(doAR[doAR.length - 1]);
											var _x = doDict.getValueFor('DISPORDER');
											dispOrder = _int((_x != null) ? _x : -1) + 1;
										//	_alert('doDict = [' + doDict + ']' + '\n\ndispOrder = [' + dispOrder + ']');
											DictionaryObj.removeInstance(doDict.id);
										}

									//	_alert('\ndispOrder = [' + dispOrder + ']');
									//	_alert('aDict = [' + aDict + ']');
									//	_alert('\n\ncurrentParentSubMenu_id = [' + currentParentSubMenu_id + ']');
									//	_alert('\n\noMenuDict = [' + oMenuDict + ']');
									//	_alert('\n\nuMenuDict = [' + uMenuDict + ']');
										if (this.isAddingMenuSubMenu) {
											doAJAX_func('onCommitSubMenu', 'displayMenuEditorData(' + oAJAXEngine.js_global_varName + ')', aDict.getValueFor('srcTableName'), srcId, aDict.getValueFor('menuUUID'), aDict.getValueFor('parentId'), dispOrder + 1);
											_alertM('global_menuEditorObj.onCommitSubMenu() :: ' + 'currentParentSubMenu_id = [' + currentParentSubMenu_id + ']' + ', dispOrder = [' + dispOrder + ']' + ', sPrompt = [' + sPrompt + ']' + ', this.isAddingMenuSubMenu = [' + this.isAddingMenuSubMenu + ']' + ', this.isAddingMenuItem = [' + this.isAddingMenuItem + ']');
										} else {
											doAJAX_func('onCommitMenuItem', 'displayMenuEditorData(' + oAJAXEngine.js_global_varName + ')', aDict.getValueFor('srcTableName'), srcId, aDict.getValueFor('menuUUID'), aDict.getValueFor('parentId'), dispOrder + 1);
											_alertM('global_menuEditorObj.onCommitMenuItem()' + '\nglobal_dict = [' + global_dict + ']' + '\naDict = [' + aDict + ']');
										}
									} else {
										alert('ERROR - Programming Error - srcId (' + srcId + ') is undefined or missing in onCommitSubMenu() callback function.');
									}
									brObj.disabled = false;
									DictionaryObj.removeInstance(aDict.id);
								}

								global_menuEditorObj.onCommitSubMenu = function (v, offset) {
									var aDict = _onCommitMenuSomething(v, currentParentSubMenu_id, offset);
									var srcId = aDict.getValueFor('srcId');
									if (!!srcId) {
									//	alert(aDict);
										doAJAX_func('onCommitSubMenu', 'displayMenuEditorData(' + oAJAXEngine.js_global_varName + ')', aDict.getValueFor('srcTableName'), srcId, aDict.getValueFor('menuUUID'), aDict.getValueFor('parentId'), aDict.getValueFor('dispOrder'));
										_alertM('global_menuEditorObj.onCommitSubMenu(v = [' + v + '])' + '\nglobal_dict = [' + global_dict + ']' + '\naDict = [' + aDict + ']');
									} else {
										doAJAX_func('onCommitMenuItem', 'displayMenuEditorData(' + oAJAXEngine.js_global_varName + ')', aDict.getValueFor('srcTableName'), srcId, aDict.getValueFor('menuUUID'), aDict.getValueFor('parentId'), aDict.getValueFor('dispOrder'));
										_alertM('global_menuEditorObj.onCommitMenuItem(v = [' + v + '])' + '\nglobal_dict = [' + global_dict + ']' + '\naDict = [' + aDict + ']');
									}
									DictionaryObj.removeInstance(aDict.id);
								}

								global_menuEditorObj.onCommitMenuItem = function (v, offset) {
									var aDict = _onCommitMenuSomething(v, currentParentSubMenu_id, offset);
									var srcId = aDict.getValueFor('srcId');
									if (!!srcId) {
										doAJAX_func('onCommitMenuItem', 'displayMenuEditorData(' + oAJAXEngine.js_global_varName + ')', aDict.getValueFor('srcTableName'), srcId, aDict.getValueFor('menuUUID'), aDict.getValueFor('parentId'), aDict.getValueFor('dispOrder'));
									} else {
										alert('ERROR - Programming Error - srcId (' + srcId + ') is undefined or missing in onCommitMenuItem() callback function.');
									}
									_alertM('global_menuEditorObj.onCommitMenuItem(v = [' + v + '])' + '\nglobal_dict = [' + global_dict + ']' + '\naDict = [' + aDict + ']');
									DictionaryObj.removeInstance(aDict.id);
								}
								
								global_menuEditorObj.onChangeMenuItem = function (v) {
									_alertM('global_menuEditorObj.onChangeMenuItem(v = [' + v + '])');
								}

								global_menuEditorObj.onPasteFromClipboard = function (brObj, clipObj, bcpasteObj) {
									function cutItemsFromClipBoard(_MENUUUID, _PARENTID) {
										var aMENUUUID = -1;
										var selected_container = -1;
										var selected_Dict = -1;
										var selected_PARENTUUID = -1;
										var temp_Dict = -1;
										var new_container = -1;
										
										selected_Dict = DictionaryObj.getInstance(cuMenuDict.getValueFor(_MENUUUID));
										selected_PARENTUUID = selected_Dict.getValueFor('PARENTUUID');

										cuMenuDict.drop(_MENUUUID);

										if (_PARENTID != null) {
											selected_container = coMenuDict.getValueFor(_PARENTID);
											if (selected_container != null) {
												if (typeof selected_container != const_object_symbol) {
													var ar = [];
													if (!!selected_container) ar.push(selected_container);
													selected_container = ar;
												}
												new_container = [];
												for (i = 0; i < selected_container.length; i++) {
													temp_Dict = DictionaryObj.getInstance(selected_container[i]);
													aMENUUUID = temp_Dict.getValueFor('MENUUUID');
													if (aMENUUUID != _MENUUUID) {
														new_container.push(selected_container[i]);
													}
													DictionaryObj.removeInstance(temp_Dict.id);
												}
												if (new_container.length == 0) {
													coMenuDict.drop(_PARENTID);
												} else {
													coMenuDict.put(_PARENTID, new_container);
												}
											}
										}
										
										selected_container = coMenuDict.getValueFor(_MENUUUID);
										if (selected_container != null) {
											coMenuDict.drop(_MENUUUID);
											
											for (i = 0; i < selected_container.length; i++) {
												temp_Dict = DictionaryObj.getInstance(selected_container[i]);
												aMENUUUID = temp_Dict.getValueFor('MENUUUID');
												try {cutItemsFromClipBoard(aMENUUUID);} catch(e) {} finally {};
												DictionaryObj.removeInstance(temp_Dict.id);
											}
										}
										DictionaryObj.removeInstance(selected_Dict.id);
									};
									
									selected_MENUUUID = clipObj.options[clipObj.selectedIndex].value;

									a_selected_Dict = DictionaryObj.getInstance(cuMenuDict.getValueFor(selected_MENUUUID));

									if (!!clipObj) {
										clipObj.options[0] = null;
										if (clipObj.options.length == 0) {
											var optObj = new Option(global_menuEditorObj.const_ClipboardEmpty_symbol, global_menuEditorObj.const_ClipboardEmpty_symbol);
											clipObj.options[clipObj.options.length] = optObj;
											clipObj.disabled = true;
										}
										if (!!bcpasteObj) {
											bcpasteObj.disabled = true;
										}
									}

									var newDispOrder = brObj.selectedIndex + 1;
								//	cutItemsFromClipBoard(selected_MENUUUID, a_selected_Dict.getValueFor('PARENT_ID'));

									DictionaryObj.removeInstance(a_selected_Dict.id);
									
									doAJAX_func('onPasteSubMenu', 'displayMenuEditorData(' + oAJAXEngine.js_global_varName + ')', selected_MENUUUID, newDispOrder, ((currentParentSubMenu_id.trim().length == 0) ? '-1' : currentParentSubMenu_id));
									
								//	_alert('selected_MENUUUID = [' + selected_MENUUUID + ']' + ', newDispOrder = [' + newDispOrder + ']' + '\n\n' + 'coMenuDict = [' + coMenuDict + ']\n\n' + 'cuMenuDict = [' + cuMenuDict + ']');
									_alertM('global_menuEditorObj.onPasteMenuItem()' + ' newDispOrder = [' + newDispOrder + ']');
								}
								
								global_menuEditorObj.onChangeSubMenu = function (v, offset) {
									var aDict = _onCommitMenuSomething(v, currentParentSubMenu_id, offset);
									var srcId = aDict.getValueFor('srcId');
									if (!!srcId) {
									//	alert(aDict);
										doAJAX_func('onChangeSubMenu', 'displayMenuEditorData(' + oAJAXEngine.js_global_varName + ')', aDict.getValueFor('srcTableName'), srcId, aDict.getValueFor('menuUUID'), aDict.getValueFor('parentId'), aDict.getValueFor('dispOrder'));
									} else {
										alert('ERROR - Programming Error - srcId (' + srcId + ') is undefined or missing in onCommitSubMenu() callback function.');
									}
									_alertM('global_menuEditorObj.onChangeSubMenu(v = [' + v + '])');
									DictionaryObj.removeInstance(aDict.id);
								}

								global_menuEditorObj.onOpenSubMenu = function (brObj) {
									selected_MENUUUID = brObj.options[brObj.selectedIndex].value;
									currentParentSubMenu_id = selected_MENUUUID;
									refreshMenuForLevel(currentParentSubMenu_id);								
									_alertM('global_menuEditorObj.onOpenSubMenu(' + 'currentParentSubMenu_id = [' + currentParentSubMenu_id + ']');
								}
								
								global_menuEditorObj.onCloseSubMenu = function (brObj, cbutObj) {
									selected_MENUUUID = currentParentSubMenu_id;

									selected_Dict = DictionaryObj.getInstance(uMenuDict.getValueFor(selected_MENUUUID));
									selected_PARENTUUID = selected_Dict.getValueFor('PARENTUUID');
									DictionaryObj.removeInstance(selected_Dict.id);

									try {
										currentParentSubMenu_id = ((selected_PARENTUUID.trim().length == 0) ? '-1' : selected_PARENTUUID);
									} catch(e) {
										currentParentSubMenu_id = '-1';
									} finally {
									}
									cbutObj.disabled = ((currentParentSubMenu_id != '-1') ? false : true);
									refreshMenuForLevel(currentParentSubMenu_id);
									menuEditorObj.selectItemByUUID(brObj, selected_MENUUUID);
									_alertM('global_menuEditorObj.onCloseSubMenu(' + ', selected_PARENTUUID = [' + selected_PARENTUUID + ']' + ', selected_MENUUUID = [' + selected_MENUUUID + ']' + ', currentParentSubMenu_id = [' + currentParentSubMenu_id + ']' + ', (currentParentSubMenu_id != \'-1\') = [' + (currentParentSubMenu_id != '-1') + ']');
								}
								
								global_menuEditorObj.onCutToClipboard = function (brObj) {
									function cutItemsToClipBoard(_MENUUUID, _PARENTID) {
										var aMENUUUID = -1;
										var selected_container = -1;
										var selected_Dict = -1;
										var selected_PARENTUUID = -1;
										var temp_Dict = -1;
										var new_container = -1;
										
										selected_Dict = DictionaryObj.getInstance(uMenuDict.getValueFor(_MENUUUID));
										selected_PARENTUUID = selected_Dict.getValueFor('PARENTUUID');

										cuMenuDict.push(_MENUUUID, selected_Dict.asQueryString());
										uMenuDict.drop(_MENUUUID);

										if (_PARENTID != null) {
											coMenuDict.push(_PARENTID, selected_Dict.asQueryString());
	
											selected_container = oMenuDict.getValueFor(_PARENTID);
											if (selected_container != null) {
												if (typeof selected_container != const_object_symbol) {
													var ar = [];
													ar.push(selected_container);
													selected_container = ar;
												}
												new_container = [];
												for (i = 0; i < selected_container.length; i++) {
													temp_Dict = DictionaryObj.getInstance(selected_container[i]);
													aMENUUUID = temp_Dict.getValueFor('MENUUUID');
													if (aMENUUUID != _MENUUUID) {
														new_container.push(selected_container[i]);
													}
													DictionaryObj.removeInstance(temp_Dict.id);
												}
												if (new_container.length == 0) {
													coMenuDict.drop(_PARENTID);
												} else {
													coMenuDict.put(_PARENTID, new_container);
												}
											}
										}
										
										selected_container = oMenuDict.getValueFor(_MENUUUID);
										if (selected_container != null) {
											coMenuDict.push(_MENUUUID, selected_container);
											oMenuDict.drop(_MENUUUID);
											
											for (i = 0; i < selected_container.length; i++) {
												temp_Dict = DictionaryObj.getInstance(selected_container[i]);
												aMENUUUID = temp_Dict.getValueFor('MENUUUID');
												try {
													cutItemsToClipBoard(aMENUUUID);
												} catch(e) {
												} finally {
												}
												DictionaryObj.removeInstance(temp_Dict.id);
											}
										}
										DictionaryObj.removeInstance(selected_Dict.id);
									};
									
									var _sel = brObj.selectedIndex;
									selected_MENUUUID = brObj.options[_sel].value;

									a_selected_Dict = DictionaryObj.getInstance(uMenuDict.getValueFor(selected_MENUUUID));
									_isParent = ((oMenuDict.getValueFor(selected_MENUUUID) == null) ? false : true);
									
									var cObj = menuEditorObj.menu_clipboard();
									if (!!cObj) {
										if (global_menuEditorObj.isClipboardActuallyEmpty()) {
											cObj.options[0] = null;
										}
										var optObj = new Option(((_isParent) ? '(' : '') + a_selected_Dict.getValueFor('PROMPT') + ((_isParent) ? ')' : ''), selected_MENUUUID);
										cObj.options[cObj.options.length] = optObj;
										cObj.disabled = false;
									}
									DictionaryObj.removeInstance(a_selected_Dict.id);

								//	_alert('BEFORE: ');
								//	_alert('\noMenuDict = [' + oMenuDict + ']');
								//	_alert('\nuMenuDict = [' + uMenuDict + ']');
									
									cutItemsToClipBoard(selected_MENUUUID, ((currentParentSubMenu_id.trim().length == 0) ? '-1' : currentParentSubMenu_id));

								//	_alert('\n\nAFTER: ');
								//	_alert('\noMenuDict = [' + oMenuDict + ']');
								//	_alert('\nuMenuDict = [' + uMenuDict + ']');
								//	_alert('\n\ncoMenuDict = [' + coMenuDict + ']');
								//	_alert('\ncuMenuDict = [' + cuMenuDict + ']');
									
								//	_alert('\n\nrefreshMenuForLevel = [' + ((currentParentSubMenu_id.trim().length == 0) ? '-1' : currentParentSubMenu_id) + ']');
									refreshMenuForLevel((currentParentSubMenu_id.trim().length == 0) ? '-1' : currentParentSubMenu_id);

									brObj.options[_sel] = null;
									
								//	_alert(oMenuDict + '\n\n' + uMenuDict + '\n==================================\n\n' + coMenuDict + '\n\n' + cuMenuDict);
									_alertM('global_menuEditorObj.onCutToClipboard()' + ', selected_MENUUUID = [' + selected_MENUUUID + ']' + ', currentParentSubMenu_id = [' + currentParentSubMenu_id + ']');  
								}
					
								global_menuEditorObj.onDeleteMenuItem = function (brObj, bcutObj, bdelObj) {
									var oAR = [];
									
									function cutItemsToThinAir(_MENUUUID, _PARENTID) {
										var aMENUUUID = -1;
										var selected_container = -1;
										var selected_Dict = -1;
										var selected_PARENTUUID = -1;
										var temp_Dict = -1;
										var new_container = -1;
										
										selected_Dict = DictionaryObj.getInstance(uMenuDict.getValueFor(_MENUUUID));
										selected_PARENTUUID = selected_Dict.getValueFor('PARENTUUID');

										uMenuDict.drop(_MENUUUID);
										if (locateArrayItems(oAR, _MENUUUID) == -1) {
											oAR.push(_MENUUUID);
										}

										if (_PARENTID != null) {
											selected_container = oMenuDict.getValueFor(_PARENTID);
											if (selected_container != null) {
												if (typeof selected_container != const_object_symbol) {
													var ar = [];
													ar.push(selected_container);
													selected_container = ar;
												}
												new_container = [];
												for (i = 0; i < selected_container.length; i++) {
													temp_Dict = DictionaryObj.getInstance(selected_container[i]);
													aMENUUUID = temp_Dict.getValueFor('MENUUUID');
													if (aMENUUUID != _MENUUUID) {
														new_container.push(selected_container[i]);
													} else if (locateArrayItems(oAR, aMENUUUID) == -1) {
														oAR.push(aMENUUUID);
													}
													DictionaryObj.removeInstance(temp_Dict.id);
												}
												if (new_container.length == 0) {
													oMenuDict.drop(_PARENTID);
												} else {
													oMenuDict.put(_PARENTID, new_container);
												}
											}
										}
										
										selected_container = oMenuDict.getValueFor(_MENUUUID);
										if (selected_container != null) {
											oMenuDict.drop(_MENUUUID);
											
											for (i = 0; i < selected_container.length; i++) {
												temp_Dict = DictionaryObj.getInstance(selected_container[i]);
												aMENUUUID = temp_Dict.getValueFor('MENUUUID');
												cutItemsToThinAir(aMENUUUID);
												DictionaryObj.removeInstance(temp_Dict.id);
											}
										}
										DictionaryObj.removeInstance(selected_Dict.id);
									};
									
									selected_MENUUUID = brObj.options[brObj.selectedIndex].value;
									cutItemsToThinAir(selected_MENUUUID, ((currentParentSubMenu_id.trim().length == 0) ? '-1' : currentParentSubMenu_id));

									if ( (!!oAR) && (oAR.length > 0) ) {
										doAJAX_func('onDeleteMenuItem', 'displayMenuEditorData(' + oAJAXEngine.js_global_varName + ')', currentParentSubMenu_id, oAR);
									}
									if (!!bdelObj) bdelObj.disabled = true;
								//	_alert('selected_MENUUUID = [' + selected_MENUUUID + ']' + ', oAR = [' + oAR + ']' + '\n\n' + oMenuDict + '\n\n' + uMenuDict);
									_alertM('global_menuEditorObj.onDeleteMenuItem()');
								}
								
								global_menuEditorObj.onClickMenuItem = function (brObj, bdelObj) {
									selected_MENUUUID = brObj.options[brObj.selectedIndex].value;
									_isParent = ((oMenuDict.getValueFor(selected_MENUUUID) == null) ? false : true);
									var cObj = menuEditorObj.btn_menuOpenSubMenu();
									if (!!cObj) {
										cObj.disabled = ((_isParent) ? false : true);
									}
									selected_Dict = DictionaryObj.getInstance(uMenuDict.getValueFor(selected_MENUUUID));
									selected_PARENTUUID = selected_Dict.getValueFor('PARENTUUID');
									if (currentParentSubMenu_id.trim().length == 0) {
										_isInsideParent = false;
									} else if (selected_PARENTUUID == currentParentSubMenu_id) {
										_isInsideParent = true;
									}
									DictionaryObj.removeInstance(selected_Dict.id);
									
									var cObj = menuEditorObj.btn_menuCloseSubMenu();
									if (!!cObj) {
										cObj.disabled = ((_isInsideParent) ? false : true);
									}
									if (bdelObj.disabled == false) {
										if (!!bdelObj) bdelObj.disabled = ((brObj.options.length == 1) ? true : false);
									}
									
									var cObj = menuEditorObj.btn_cutMenu2Clipboard();
									if (!!cObj) {
										cObj.disabled = ((_isParent) ? false : bdelObj.disabled);
									}
									
									if (!!bdelObj) bdelObj.disabled = ((_isParent) ? false : true);
									if (!!bdelObj) bdelObj.disabled = ((brObj.options.length == 1) ? true : false);
									
									_alertM('global_menuEditorObj.onClickMenuItem(brObj.selectedIndex = [' + brObj.selectedIndex + '])' + ', text = [' + brObj.options[brObj.selectedIndex].text + ']' + ', value = [' + brObj.options[brObj.selectedIndex].value + ']' + ', _isParent = [' + _isParent + ']' + ', _isInsideParent = [' + _isInsideParent + ']' + ', selected_PARENTUUID = [' + selected_PARENTUUID + ']' + ', currentParentSubMenu_id = [' + currentParentSubMenu_id + ']');  
								}
					
								flushGUIObjectChildrenForObj(cObj);
								cObj.innerHTML = _html;
								
								try {
									global_menuEditorObj.populateGUIcontainer('div_menuEditor_container');
								} catch(e) {
									jsErrorExplainer(e, '+++', true);
								} finally {
								}

								global_menuEditorObj.isAutoLoadingMenu = true;
								global_menuEditorObj.bool_suppressEvents = true;
								qData.iterateRecObjs(displayRecord);
								global_menuEditorObj.bool_suppressEvents = false;
								global_menuEditorObj.isAutoLoadingMenu = false;
								global_menuEditorObj._uuid = null; // disable this callback so normal processing will use real valid random uuid values when necessary...

								currentParentSubMenu_id = '-1';
								refreshMenuForLevel(currentParentSubMenu_id);								

							//	_alert(oMenuDict + '\n\n' + uMenuDict);
							} else {
								alert('ERROR: Programming error, the element known as (' + 'div_contents_' + oAJAXEngine.currentContextName + ') is not present in the document.');
							}
						}
					//	_alert(qData);
					}
				}
			}

			function displayMenuEditorData(qObj) {
				var nRecs = -1;
				var oParms = -1;
				var _spanName = '#const_menuEditorRecord_symbol#';

				function displayRecord(_ri, _dict, _rowCntName, queryObj) {
					return processMenuRecordsAbstract(_ri, _dict, _rowCntName, queryObj);
				};

				function refreshMenuForLevel(pID) {
					return refreshMenuForLevelAbstract(pID);
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
						//	_alert(oParms);

							oAJAXEngine.setContextName(_spanName);

							oMenuDict.init();
							uMenuDict.init();
							
							global_menuEditorObj.isAutoLoadingMenu = true;
							global_menuEditorObj.bool_suppressEvents = true;
							qData.iterateRecObjs(displayRecord);
							global_menuEditorObj.bool_suppressEvents = false;
							global_menuEditorObj.isAutoLoadingMenu = false;
							global_menuEditorObj._uuid = null; // disable this callback so normal processing will use real valid random uuid values when necessary...

						//	_alert('currentParentSubMenu_id = [' + currentParentSubMenu_id + ']');
							refreshMenuForLevel(((currentParentSubMenu_id > -1) ? currentParentSubMenu_id : '-1'));								
						}
					//	_alert('*** NEED TO REFRESH THE oMenuDict and uMenuDict\n' + qData);
					}
				}
			}
			
			function displayClientMenuData(qObj) {
				var nRecs = -1;
				var oParms = -1;
				var _spanName = '#const_menuDisplayRecord_symbol#';

				function displayRecord(_ri, _dict, _rowCntName, queryObj) {
					var _ID = '';
					var _PROMPT = '';
					var _MENUUUID = -1;
					var _PARENT_ID = -1;
					var _PARENTUUID = -1;
					var _SRCID = -1;
					var _SRCTABLENAME = '';
					var _DISPORDER = '';
					var _rowCnt = -1;
	
					try {
						_ID = _dict.getValueFor('ID');
						_PROMPT = _dict.getValueFor('PROMPT');
						_MENUUUID = _dict.getValueFor('MENUUUID');
						_PARENT_ID = _dict.getValueFor('PARENT_ID');
						_PARENTUUID = _dict.getValueFor('PARENTUUID');
						_SRCID = _dict.getValueFor('SRCID');
						_SRCTABLENAME = _dict.getValueFor('SRCTABLENAME');
						_DISPORDER = _dict.getValueFor('DISPORDER');
						_rowCnt = _dict.getValueFor(_rowCntName);
					} catch(e) {
					} finally {
					}
	
					_PARENTUUID = ((_PARENTUUID.trim().length == 0) ? '-1' : _PARENTUUID);
					
					var eDISPORDER = -1;
					var aVal = global_ClientMenuObj.oMenuDict.getValueFor(_PARENTUUID);
					if (aVal == null) {
						eDISPORDER = 0;
					} else if (typeof aVal != const_object_symbol) {
						eDISPORDER = 1;
					} else {
						eDISPORDER = aVal.length;
					}
					_dict.put('DISPORDER', eDISPORDER);
					global_ClientMenuObj.oMenuDict.push(_PARENTUUID, '&_ri=' + _ri + _dict.asQueryString());
					
					global_ClientMenuObj.uMenuDict.push(_MENUUUID, '&_ri=' + _ri + _dict.asQueryString());
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

							oAJAXEngine.setContextName(_spanName);

							oMenuDict.init();
							uMenuDict.init();
							
							try {
								qData.iterateRecObjs(displayRecord);
							} catch(e) {
								jsErrorExplainer(e, '999', true);
							} finally {
							}
							
							var dObj = getGUIObjectInstanceById('div_clientMenuTest');
							if (!!dObj) {
								var _html = '';
								var mDict = -1;
								var mAR = global_ClientMenuObj.oMenuDict.getValueFor('-1');
								for (var i = 0; i < mAR.length; i++) {
									mDict = DictionaryObj.getInstance(mAR[i]);
									_html += '<span class="menuClass"><a href="" onclick="ClientMenuObj.openClientMenuByUUID(global_ClientMenuObj, \'' + mDict.getValueFor('MENUUUID') + '\'); return false;">' + mDict.getValueFor('PROMPT') + '</a></span>' + ((i < (mAR.length - 1)) ? ' | ' : '');
									DictionaryObj.removeInstance(mDict.id)
								}
								flushGUIObjectChildrenForObj(dObj);
								dObj.innerHTML = _html;
								
								global_ClientMenuObj.onCheckBoxClicked = function(id, bool, ar) {
									_alertM('global_ClientMenuObj.onCheckBoxClicked(id = [' + id + '], bool = [' + bool + '], ar = [' + ar + '])');
								};
								
								global_ClientMenuObj.onL2DecideToUseRadioButtonOrCheckBoxes = function(uuid) {
									var resp = ( (uuid == '1139265798671870') || (uuid == '1139267611109108') );
								//	_alert(global_ClientMenuObj.oMenuDict);
									_alertM('global_ClientMenuObj.onDecideToUseRadioButtonOrCheckBoxes(uuid = [' + uuid + '])' + ', resp = [' + resp + ']');
									return resp;
								};
								
								global_ClientMenuObj.onL2DecideToUseLinks = function(uuid) {
									var resp = ( (uuid == '1139271638421104') || (uuid == '1139271659640192') );
								//	_alert(global_ClientMenuObj.oMenuDict);
									_alertM('global_ClientMenuObj.onL2DecideToUseLinks(uuid = [' + uuid + '])' + ', resp = [' + resp + ']');
									return resp;
								};
							}
						}
					//	_alert('*** Display oMenuDict and uMenuDict as a Client Menu\n\n' + 'oMenuDict = [' + oMenuDict + ']\n\n' + 'uMenuDict = [' + uMenuDict + ']\n\n');
					}
				}
			}

			function handleLayerEditorGridClick(_recID, _colName) {
				var datum = '';
				var cObj = getGUIObjectInstanceById('span_layer_grid_' + _colName + '_' + _recID);
				var dObj = getGUIObjectInstanceById('td_layer_grid_' + _colName + '_' + _recID);
				if ( (!!cObj) && (!!dObj) ) {
					datum = cObj.innerHTML.stripHTML().trim();
					_alert('handleLayerEditorGridClick(_recID = [' + _recID + '], _colName = [' + _colName + '])' + ', datum = [' + datum + ']' + ', dObj.width = [' + dObj.width + ']' + ', dObj.style = [' + Style2String(dObj.style) + ']');
				}
			}
			
			function displayLayerEditorData(qObj) {
				var nRecs = -1;
				var oParms = -1;
				var _spanName = '#const_layerEditorRecord_symbol#';
				var _html = '';
				var rowCnt = 0;
				var isTableLabeled = false;

				function beginTable(aPrompt, vararg_params) {
					var html = '';

					function injectParmsFrom(d, aKey) {
						var _content = '';
						var _ar = d.getValueFor(aKey);
						if (!!_ar) {
							for (var i = 0; i < _ar.length; i++) {
								_content += ' ' + _ar[i].URLDecode();
							}
						}
						return _content;
					}
					
					html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
					if (!!aPrompt) {
						if (aPrompt.trim().length > 0) {
							aDict = DictionaryObj.getInstance();
							aDict.bool_returnArray = true;
						    for (var i = 1; i < arguments.length; i++) {
								aDict.fromSpec(arguments[i]);
							}
							html += '<tr' + injectParmsFrom(aDict, 'tr') + '>';
							html += '<td' + injectParmsFrom(aDict, 'td') + '>';
							html += '<span' + injectParmsFrom(aDict, 'span') + '>';
							html += aPrompt;
							html += '</span>';
							html += '</td>';
							html += '</tr>';
							DictionaryObj.removeInstance(aDict.id);
						}
					}
					return html;
				}
				
				function endTable() {
					return '</table>';
				}
				
				function buildTableRowFrom(vararg_params) {
					var html = '';
					if (arguments.length > 0) {
						rowCnt += ((isTableLabeled) ? 1 : 0);
						html += '<tr>';
					    for (var i = 0; i < arguments.length; i++) {
							if (typeof arguments[i] == const_object_symbol) {
								var d = arguments[i];
								try {
									var keys = d.keys;
									var datum = '';
									var isKeyID = false;
									var isFieldEditable = false;
									var recID = d.getValueFor('ID');

									html += '<tr' + ((!isTableLabeled) ? ' bgcolor="silver"' : '') + '>';

									html += '<td' + ((isTableLabeled) ? ' bgcolor="silver"' : '') + ((!isTableLabeled) ? ' align="center"' : '') + ' style="border-left: thin groove ##C2C2C2; border-right: thin groove ##C2C2C2;">';
									datum = '##';
									html += '<span class="textClass">' + ((!isTableLabeled) ? datum : rowCnt + '.' + d.getValueFor('rowCnt')) + '</span>';
									html += '</td>';
									
									recID = ((!!recID) ? recID : '');

								    for (var j = 0; j < keys.length; j++) {
										isKeyID = (keys[j].toUpperCase() != 'ID'.toUpperCase());
										isFieldEditable = ((!isTableLabeled) ? false : true);
										if (keys[j].toUpperCase() != 'rowCnt'.toUpperCase()) {
											html += '<td' + (((!isFieldEditable) || (!isKeyID)) ? ' bgcolor="silver"' : '') + ' id="td_layer_' + ((!isFieldEditable) ? 'header' : 'grid') + '_' + keys[j] + '_' + recID + '"' + ((!isFieldEditable) ? ' align="center"' : '') + ' style="border-right: thin groove ##C2C2C2;' + (((!isFieldEditable) || (!isKeyID)) ? '' : ' cursor:hand; cursor:pointer;') + '"' + (((!isFieldEditable) || (!isKeyID)) ? '' : ' onclick="handleLayerEditorGridClick(\'' + recID + '\', \'' + keys[j] + '\'); window.status = \'ID = [' + recID + '], colName = [' + keys[j] + ']\';"') + '>';
											datum = d.getValueFor(keys[j]);
											html += '<span id="span_layer_' + ((!isFieldEditable) ? 'header' : 'grid') + '_' + keys[j] + '_' + recID + '" class="textClass">' + ((!isFieldEditable) ? keys[j] : ((datum.length == 0) ? '&nbsp;' : datum)) + '</span>';
											html += '</td>';
										}
									}
									html += '</tr>';
								} catch(e) {
								} finally {
								}
							} else {
								html += '<td>';
								html += '<span class="textClass">' + arguments[i] + '</span>';
								html += '</td>';
							}
						}
						html += '</tr>';
					}
					return html;
				}
				
				function displayRecord(_ri, _dict, _rowCntName, queryObj) {
					var _ID = '';
					var _layerName = '';
					var _layerDisplayName = -1;
					var _timeFileList = -1;
					var _timeFileType = -1;
					var _rowCnt = -1;
	
					try {
						_ID = _dict.getValueFor('ID');
						_layerName = _dict.getValueFor('layerName'.toUpperCase());
						_layerDisplayName = _dict.getValueFor('layerDisplayName'.toUpperCase());
						_timeFileList = _dict.getValueFor('timeFileList'.toUpperCase());
						_timeFileType = _dict.getValueFor('timeFileType'.toUpperCase());
						_rowCnt = _dict.getValueFor(_rowCntName);
					} catch(e) {
					} finally {
					}
					
					isTableLabeled = ((isTableLabeled == true) ? isTableLabeled : false);
					if (isTableLabeled == false) {
						_html += buildTableRowFrom(_dict);
						isTableLabeled = true;
					}
					_html += buildTableRowFrom(_dict);
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

							oAJAXEngine.setContextName(_spanName);

							_html += beginTable('Layer Editor', '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
							_html += beginTable();
							try {
								qData.iterateRecObjs(displayRecord);
							} catch(e) {
								jsErrorExplainer(e, '999', true);
							} finally {
							}
							_html += endTable();
							_html += endTable();
							
							var dObj = getGUIObjectInstanceById('div_layerEditorTest');
							if (!!dObj) {
								flushGUIObjectChildrenForObj(dObj);
								dObj.innerHTML = _html;
							} else {
								alert('ERROR - Proramming Error - Missing object known as "div_layerEditorTest".');
							}
						}
					//	_alert('qData = [' + qData + ']');
					}
				}
			}
		// -->
		</script>

		<b>Welcome to the AJAX powered Beacon Menu Editor !</b>
		<br><br>
		
		<table width="100%" border="0" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80" style="margin-top: 20px;">
			<tr>
				<td>
					<table>
						<tr>
							<td align="left" valign="top">
								<button name="btn_getContents" id="btn_getContents" class="buttonMenuClass" onclick="queueUp_AJAX_Sessions();  return false;">[?]</button>
							</td>
							<td align="left" valign="top">
								<button name="btn_getContents4" id="btn_getContents4" class="buttonMenuClass" onclick="queueUp_AJAX_Sessions4();  return false;">[?Layers]</button>
							</td>
							<td align="left" valign="top">
								<button name="btn_getContents3" id="btn_getContents3" class="buttonMenuClass" onclick="queueUp_AJAX_Sessions3();  return false;">[?Menu]</button>
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
				</td>
			</tr>
			<tr>
				<td>
					<div id="div_clientMenuTest" style="display: inline;"></div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="div_layerEditorTest" style="display: inline;"></div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="div_clientSubMenuTest" style="display: inline;"></div>
				</td>
			</tr>
		</table>
		
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
		
		<div id="#Request.cf_div_floating_debug_menu#" style="display: none;">
			<table width="*" bgcolor="##80FFFF" border="1" cellpadding="-1" cellspacing="-1">
				<tr>
					<td align="left" style="display: inline;">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td align="left">
									<span class="onholdStatusBoldClass">AJAX:</span>&nbsp;<button name="btn_helperPanel" id="btn_helperPanel" class="buttonMenuClass" title="Click this button to open the AJAX Debug Panel" onclick="var cObj = getGUIObjectInstanceById('td_ajaxHelperPanel'); var bObj = getGUIObjectInstanceById('btn_helperPanel'); var tbObj = getGUIObjectInstanceById('table_ajaxHelperPanel'); if ( (!!cObj) && (!!bObj) && (!!tbObj) ) { cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style); bObj.value = ((cObj.style.display == const_inline_style) ? '[<<]' : '[>>]'); if (cObj.style.display == const_inline_style) { tbObj.style.width = _global_clientWidth; repositionBasedOnFloatingDebugPanel(tbObj); oAJAXEngine.setDebugMode(); } else { oAJAXEngine.setReleaseMode(); }; }; return false;">[>>]</button>
								</td>
							</tr>
							<tr>
								<td align="left">
									<span class="onholdStatusBoldClass">Menu:</span>&nbsp;<button name="btn_menuHelperPanel" id="btn_menuHelperPanel" title="Click this button to open the Menu Debug Panel" class="buttonMenuClass" onclick="var cObj = getGUIObjectInstanceById('td_menuHelperPanel'); var bObj = getGUIObjectInstanceById('btn_menuHelperPanel'); var tbObj = getGUIObjectInstanceById('table_menuHelperPanel'); if ( (!!cObj) && (!!bObj) && (!!tbObj) ) { cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style); bObj.value = ((cObj.style.display == const_inline_style) ? '[<<]' : '[>>]'); if (cObj.style.display == const_inline_style) { tbObj.style.width = _global_clientWidth; repositionBasedOnFloatingDebugPanel(tbObj); } else {  }; }; return false;">[>>]</button>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		
		<table id="table_menuHelperPanel" width="100%" bgcolor="##80FFFF" border="1" cellpadding="-1" cellspacing="-1">
			<tr>
				<td id="td_menuHelperPanel" style="display: none;" align="left" valign="top">
					<textarea id="ta_menuHelperPanel" readonly rows="5" cols="175" class="textClass"></textarea>
				</td>
			</tr>
		</table>

		<table width="100%" cellpadding="-1" cellspacing="-1">
			<tr>
				<td id="td_ajaxHelperPanel" align="center" style="display: none;">
					<table width="100%" bgcolor="##80FFFF" cellspacing="-1" cellpadding="-1" id="table_ajaxHelperPanel" style="width: 800px;">
						<tr>
							<td align="center">
								<button name="btn_useDebugMode" id="btn_useDebugMode" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('DEBUG') != -1) { oAJAXEngine.setReleaseMode(); this.value = this.value.clipCaselessReplace('Debug', 'Release'); } else { oAJAXEngine.setDebugMode(); this.value = this.value.clipCaselessReplace('Release', 'Debug'); }; return false;">[Debug Mode]</button>
							</td>
							<td align="center">
								<button name="btn_useXmlHttpRequest" id="btn_useXmlHttpRequest" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('XMLHTTPREQUEST') == -1) { oAJAXEngine.isXmlHttpPreferred = false; this.value = this.value.clipCaselessReplace('iFRAME', 'XmlHttpRequest'); } else { oAJAXEngine.isXmlHttpPreferred = true; this.value = this.value.clipCaselessReplace('XMLHTTPREQUEST', 'iFRAME'); }; return false;">[Use iFrame]</button>
							</td>
							<td align="center">
								<button name="btn_useMethodGetOrPost" id="btn_useMethodGetOrPost" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('GET') != -1) { oAJAXEngine.setMethodGet(); this.value = this.value.clipCaselessReplace('GET', 'Post'); } else { oAJAXEngine.setMethodPost(); this.value = this.value.clipCaselessReplace('POST', 'Get'); }; return false;">[Use Get]</button>
							</td>
							<td align="center">
								<button name="btn_hideShow_iFrame" id="btn_hideShow_iFrame" class="buttonMenuClass" onclick="var s = this.value; if (s.toUpperCase().indexOf('SHOW') != -1) { oAJAXEngine.showFrame(); this.value = this.value.clipCaselessReplace('show', 'Hide'); } else { oAJAXEngine.hideFrame(); this.value = this.value.clipCaselessReplace('hide', 'Show'); }; return false;">[Show iFrame]</button>
							</td>
							<td align="center">
								<button name="btn_1" id="btn_1" class="buttonMenuClass" onclick="doAJAX_func('getTopLevelMenuNames'); return false;">[Test]</button>
							</td>
						</tr>
					</table>
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
			oAJAXEngine.hideFrame();
			var cObj = getGUIObjectInstanceById('btn_hideShow_iFrame');
			if (!!cObj) {
				if (oAJAXEngine.visibility == 'visible') {
					cObj.value = cObj.value.clipCaselessReplace('show', 'Hide');
				}
			}

			var cObj = getGUIObjectInstanceById('btn_useXmlHttpRequest');
			if (!!cObj) {
				if (oAJAXEngine.isXmlHttpPreferred == false) {
					cObj.value = cObj.value.clipCaselessReplace('iFRAME', 'XmlHttpRequest');
				}
			}

			var cObj = getGUIObjectInstanceById('btn_useMethodGetOrPost');
			if (!!cObj) {
				if (oAJAXEngine.isMethodGet()) {
					cObj.value = cObj.value.clipCaselessReplace('GET', 'Post');
				}
			}

			var cObj = getGUIObjectInstanceById('btn_useDebugMode');
			if (!!cObj) {
				if (oAJAXEngine.isReleaseMode() == true) {
					cObj.value = cObj.value.clipCaselessReplace('Debug', 'Release');
				}
			}

			var cObj = getGUIObjectInstanceById(const_cf_html_container_symbol);
			var dObj = getGUIObjectInstanceById(const_div_floating_debug_menu);
			if ( (!!cObj) && (!!dObj) ) {
				if (dObj.style.display == const_none_style) {
					dObj.style.position = cObj.style.position;
					dObj.style.top = parseInt(cObj.style.top) + 25 + 'px';
					dObj.style.left = (clientWidth() - 75) + 'px';
					dObj.style.display = const_inline_style;
				}
			}
		// -->
		</script>
		
	</body>
	</html>
</cfoutput>
