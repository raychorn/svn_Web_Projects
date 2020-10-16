<cfset _js_path = "js/">

<cfset _CrossBrowserLibrary_js = "#_js_path#CrossBrowserLibrary.js">
<cfset _GUIActionsObj_js = "#_js_path#gui_actions_obj.js">

<cfset _StylesAndArrays_js = "#_js_path#StylesAndArrays.js">

<cfset _gateway_js = "#_js_path#gatewayApi_2.03/gateway.js">
<cfset _wddx_js = "#_js_path#gatewayApi_2.03/wddx.js">
<cfset _ajax_obj_js = "#_js_path#ajax_obj.js">
<cfset _jsapi_extensions_js = "#_js_path#gatewayApi_2.03/js/jsapi_extensions.js">

<cfset _iframe_ssi_script2_js = "#_js_path#www.dynamicdrive.com/iframe_ssi_script2.js">

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
	</head>
	
	<body onload="window_onload()" onunload="window_onUnload()">
	
		<!--// load the Client/Server Gateway API //-->
		<cfif 0>
			<script language="JavaScript1.2" src="#_wddx_js#" type="text/javascript"></script>
		</cfif>
		<script language="JavaScript1.2" src="#_gateway_js#" type="text/javascript">></script>
		<!--// load the extensions to the Client/Server Gateway API //-->
		<script language="JavaScript1.2" src="#_jsapi_extensions_js#" type="text/javascript">></script>

		<cfscript>
			const_menuRecord_symbol = 'menuRecord';
			const_groupNameRecord_symbol = 'groupNameRecord';
		</cfscript>	

		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			var global_guiActionsObj = GUIActionsObj.getInstance();
			
			var const_cf_html_container_symbol = '#Request.cf_html_container_symbol#';
			var const_loading_data_message_symbol = '<span class="normalStatusClass">&nbsp;Loading !</span>';
			var const_system_ready_message_symbol = '<span class="normalStatusClass">&nbsp;Ready !</span>';
			var const_jsapi_loading_image = '#Request.const_jsapi_loading_image#';
			var const_paper_color_light_yellow = '#Request.const_paper_color_light_yellow#';

			var const_add_button_symbol = '[+]';
			var const_edit_button_symbol = '[*]';
			var const_delete_button_symbol = '[-]';
			
			var const_jsapi_width_value = 200;

			var global_allow_loading_data_message = false;
			
			var url_sBasePath = 'http:\/\/#CGI.HTTP_HOST#' + document.location.pathname.substring(0, document.location.pathname.length);

			var bool_isServerLocal = (('#Request.commonCode.isServerLocal()#'.toString().trim().toLowerCase() == 'yes') ? true : false);
	
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
				var s_argSpec = '';
				var sValue = '&cfm=' + cmd + '&AUTH_USER=#Request.AUTH_USER#' + '&callBack=' + callBackFuncName;

			    // BEGIN: Make the arguments into a series of URL Parms, as-required, don't worry the AJAX Engine will figure out how to handle all this data...
				// a Parm may be a simple value or a Query String using the standard CGI Query String specification of "&name=value"...
			    for (var i = 0; i < arguments.length - 2; i++) {
					anArg = arguments[i + 2];
					if ((typeof anArg).toUpperCase() != const_string_symbol.toUpperCase()) {
						try {
							anArg = anArg.toString();
						} catch(e) {
							anArg = ''; // default is empty string whenever the thing that is not a string cannot be made into a string...
						} finally {
						}
					}
					ampersand_i = anArg.indexOf('&');
					equals_i = anArg.indexOf('=');
					if ( (ampersand_i != -1) && (equals_i != -1) && (ampersand_i < equals_i) ) {
						s_argSpec += anArg;
						_argCnt++;
					} else if (anArg.indexOf(',') != -1) {
						ar = anArg.split(',');
						for (j = 0; j < ar.length; j++) {
							if (ar[j].indexOf('=') != -1) {
								ar2 = ar[j].split('=');
								j2 = (j * 2);
								s_argSpec += '&arg' + (j2 - 1) + '=' + ar2[0];
								_argCnt++;
								s_argSpec += '&arg' + j2 + '=' + ar2[1];
								_argCnt++;
							} else {
								s_argSpec += '&arg' + (j + 1) + '=' + ar[j];
								_argCnt++;
							}
						}
					} else {
						s_argSpec += '&arg' + (i + 1) + '=' + anArg;
						_argCnt++;
					}
			    }
				sValue += '&argCnt=' + _argCnt + s_argSpec;
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
				var pQueryString = '';
				var jsCode = "var pQueryString = '&spanName=' + '#const_groupNameRecord_symbol#' + '&col1_keyName=ID&col2_keyName=LAYERGROUPNAME&div_name=div_contents2&editor_title_bar=Group Names&cfm_add_cmd=addGroupName&cfm_save_cmd=saveGroupName&cfm_drop_cmd=dropGroupName';";
				jsCode += "oGateway.addNamedContext('#const_groupNameRecord_symbol#', pQueryString);";
				jsCode += "execJSAPI_func('getGroupNames', 'displayTopLevelMenuNames(" + oGateway.js_global_varName + ")');";
				register_jsapi_function(jsCode);
				pQueryString = '&spanName=' + '#const_menuRecord_symbol#' + '&col1_keyName=ID&col2_keyName=MENUNAME&div_name=div_contents&editor_title_bar=Menu Names&cfm_add_cmd=addTopLevelMenuName&cfm_save_cmd=saveTopLevelMenuName&cfm_drop_cmd=dropTopLevelMenuName';
				oGateway.addNamedContext('#const_menuRecord_symbol#', pQueryString); // spanName is the name of the context... the GUI follows this same pattern...
				execJSAPI_func('getTopLevelMenuNames', 'displayTopLevelMenuNames(' + oGateway.js_global_varName + ')');
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
			
			function perform_click_btn_editMenuName(_objID_prefix, _iNum, _recID, _spanName) {
				var _handle = global_guiActionsObj.push('btn_addMenuName_' + _spanName);
				if (_handle > -1) {
					global_guiActionsObj.replaceAspectNamedFor(_handle, 'value', const_edit_button_symbol);
					global_guiActionsObj.replaceAspectNamedFor(_handle, 'title', 'Click to Save the edited Menu Name to the Db.');
				}
				var _handle2 = global_guiActionsObj.push('btn_revertMenuName_' + _spanName);
				if (_handle2 > -1) {
					global_guiActionsObj.replaceStyleNamedFor(_handle2, 'display', 'display: ' + const_inline_style + ';');
				}
// +++
				var _handle3 = global_guiActionsObj.push('txt_menuName_' + _spanName);
				if (_handle3 > -1) {
					var cObj = getGUIObjectInstanceById(_objID_prefix + _iNum.toString());
					if (!!cObj) {
						global_guiActionsObj.replaceAspectNamedFor(_handle3, 'title', _recID);
						global_guiActionsObj.replaceAspectNamedFor(_handle3, 'value', cObj.innerHTML);
						setFocusSafelyById('txt_menuName_' + _spanName);
					}
				}
				disableActionPanelWidets(_spanName);
			}

			function perform_click_btn_revertMenuName() {
				global_guiActionsObj.popAll();
			}
			
			function displayTopLevelMenuNames(qObj) {
				var _html = '';
				var oParms = -1;
				var i = -1;
				var iInc = 1;
				var argCnt = -1;
				var args = [];
				var _spanName = '';
				var _col1_keyName = '';
				var _col2_keyName = '';
				var _div_name = '';
				var _editor_title_bar = '';
				var _cfm_add_cmd = '';
				var _cfm_save_cmd = '';
				var _cfm_drop_cmd = '';

				function displayActionsPanel(objID_prefix, iNum, recID, i_leftOrRight, bool_isHorz) {
					var someHtml = '';
					
					bool_isHorz = ((bool_isHorz == true) ? bool_isHorz : false);
					i_leftOrRight = (((i_leftOrRight == 1) || (i_leftOrRight == 2)) ? i_leftOrRight : -1);
					
					someHtml = '<table width="100%" cellpadding="-1" cellspacing="-1">';
					someHtml += '<tr>';
					if (i_leftOrRight == 2) someHtml += '<td><button id="btn_dropMenuName_' + _spanName + '_' + iNum + '" class="buttonClass" title="Click to Delete a Menu Name from the Db." onclick="perform_click_btn_dropMenuName(\'' + objID_prefix + '\',' + iNum + ',' + recID + ',\'' + _spanName + '\',\'' + _cfm_drop_cmd + '\'); return false;">' + const_delete_button_symbol + '</button></td>';
					if ( (bool_isHorz == false) && ( (i_leftOrRight != 1) || (i_leftOrRight != 2) ) ) {
						someHtml += '</tr>';
						someHtml += '<tr>';
					}
					if (i_leftOrRight == 1) someHtml += '<td><button id="btn_editMenuName_' + _spanName + '_' + iNum + '" class="buttonClass" title="Click to Edit a Menu Name in the Db." onclick="perform_click_btn_editMenuName(\'' + objID_prefix + '\',' + iNum + ',' + recID + ',\'' + _spanName + '\'); return false;">' + const_edit_button_symbol + '</button></td>';
					someHtml += '</tr>';
					someHtml += '</table>';
					
					return someHtml;
				};

				function displayRecord(_ri, _dict, _rowCntName) {
					var _ID = '';
					var _dataVal = '';
					var _rowCnt = -1;
					
					try {
						_ID = _dict.getValueFor(_col1_keyName);
						_dataVal = _dict.getValueFor(_col2_keyName);
						_rowCnt = _dict.getValueFor(_rowCntName);
					} catch(e) {
					} finally {
					}

					_html += '<tr>';
					_rowStyle = ((_ri < _rowCnt) ? 'border-bottom: thin solid Silver;' : '');
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_ACTION_LEFT_' + _ri + '" class="normalStatusClass">' + displayActionsPanel('span_' + _spanName + '_' + _col2_keyName + '_', _ri, _ID, 1, true) + '</span></td>'; // this is the ACTIONS column...
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_' + _col1_keyName + '_' + _ri + '" class="normalStatusClass">' + _ri + '</span></td>';       // this is the ID column...
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_' + _col2_keyName + '_' + _ri + '" class="normalStatusClass">' + _dataVal + '</span></td>'; // this is the data column...
					_html += '<td style="' + _rowStyle + '"><span id="span_' + _spanName + '_ACTION_RIGHT_' + _ri + '" class="normalStatusClass">' + displayActionsPanel('span_' + _spanName + '_' + _col2_keyName + '_', _ri, _ID, 2, true) + '</span></td>'; // this is the ACTIONS column...
					_html += '</tr>';
				};

				function displayControlPanel() {
					_html += '<tr>';
					_html += '<td><button id="btn_addMenuName_' + _spanName + '" class="buttonClass" title="Click to Add a Menu Name to the Db." onclick="perform_click_btn_addMenuName(\'' + _spanName + '\',\'' + _cfm_add_cmd + '\',\'' + _cfm_save_cmd + '\'); return false;">' + const_add_button_symbol + '</button></td>';
					_html += '<td colspan="2"><input type="text" class="textEntryClass" id="txt_menuName_' + _spanName + '" size="30" maxlength="50"></td>';
					_html += '<td><button id="btn_revertMenuName_' + _spanName + '" class="buttonClass" style="display: none;" title="Click to revert the chosen Action." onclick="perform_click_btn_revertMenuName(); return false;">[<<]</button></td>';
					_html += '</tr>';
				};

				function displayTable(someHtml, _width, bgColor, _border) {
					_html = '<table width="' + _width + '" border="' + _border + '" cellpadding="-1" cellspacing="-1">';
					_html += '<tr bgcolor="' + bgColor + '">';
					_html += '<td>' + someHtml + '</td>';
					_html += '</tr>';
					_html += '</table>';
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
				
				var nRecs = -1;
				var qStats = qObj.named('qDataNum');
				if (!!qStats) {
					nRecs = qStats.dataRec[1];
				}
				if (nRecs > 0) {
					var qData = qObj.named('qData1');
					if (!!qData) {

						oParms = qObj.named('qParms');
						if (!!oParms) {
							oParms.iterateRecObjs(searchForRec);
							iInc = 1;
							for (i = 0; i < args.length; i += iInc) {
								if ( (!!oGateway.namedContextCache[oGateway.currentContextName]) && (!!oGateway.namedContextCache[oGateway.currentContextName].parmsDict.getValueFor(args[i])) ) {
									if (args[i].toUpperCase() == 'spanName'.toUpperCase()) {
										_spanName = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'col1_keyName'.toUpperCase()) {
										_col1_keyName = args[i + 1];
									} else if (args[i].trim().toUpperCase() == 'col2_keyName'.toUpperCase()) {
										_col2_keyName = args[i + 1];
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
						_html += '<td><span id="span_' + _spanName + '_HEADER_3" title="MENUNAME" class="normalStatusBoldClass">' + _editor_title_bar + '</span></td>';
						_html += '</tr>';

						// iterate over the Query Obj pulling out data...
						qData.iterateRecObjs(displayRecord);
						displayControlPanel();
						_html += '</table>';
						displayTable(_html, 200, const_paper_color_light_yellow, 1);

						var cObj = getGUIObjectInstanceById(_div_name);
						if (!!cObj) {
							flushGUIObjectChildrenForObj(cObj);
							cObj.innerHTML = _html;
						} else {
							alert('ERROR: Programming Error - The variable argument to execJSAPI...() known as "div_name" has not been defined and is missing...');
						}

						var eObj = getGUIObjectInstanceById('txt_menuName_' + _spanName);
						if (!!eObj) {
							eObj.focus();
						}
					}
				}
			}
		// -->
		</script>

		<b>Hello World !</b>
		<br><br>
		
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
					<div id="div_contents" style="display: inline;"></div>
				</td>
				<td align="left" valign="top">
					<div id="div_contents2" style="display: inline;"></div>
				</td>
			</tr>
		</table>
		
		<!--- BEGIN: This is the minimal amount of code that must be on the client to support a remote boosteap loader for an AJAX Application --->
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function __callback(h) {
				if (!!h) {
					eval(h); // the content passed-down from the server is JavaScript executable code.
				}
			}

			document.write('<div id="div_boostrap_loader" style="display: none;">');
			document.write('<iframe id="frame_boostrap_loader" width="100%" height="200" frameborder="1" src="bootstrap.cfm" style="display: none;"></iframe>');
			document.write('</div>');
		//-->
		</script>
		<!--- END! This is the minimal amount of code that must be on the client to support a remote boosteap loader for an AJAX Application --->

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
