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
	
		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			var guiActionsObj = GUIActionsObj.getInstance();
			
			var const_cf_html_container_symbol = '#Request.cf_html_container_symbol#';
			var const_loading_data_message_symbol = '<span class="normalStatusClass">&nbsp;Loading !</span>';
			var const_system_ready_message_symbol = '<span class="normalStatusClass">&nbsp;Ready !</span>';
			var const_jsapi_loading_image = '#Request.const_jsapi_loading_image#';
			var const_paper_color_light_yellow = '#Request.const_paper_color_light_yellow#';

			var const_jsapi_width_value = 200;

			var global_allow_loading_data_message = false;
			
			var url_sBasePath = 'http:\/\/#CGI.HTTP_HOST#' + document.location.pathname.substring(0, document.location.pathname.length);

			var bool_isServerLocal = (('#Request.commonCode.isServerLocal()#'.toString().trim().toLowerCase() == 'yes') ? true : false);
	
			// create the gateway object
			var oGateway = new Gateway(url_sBasePath + ((url_sBasePath.charAt(url_sBasePath.length - 1) == '/') ? '' : '/') + '#Request.cfm_gateway_process_html#', bool_isServerLocal);
			oGateway.setMethodGet();
			oGateway.setReleaseMode(); // this overrides the oGateway.set_isServerLocal() setting...
			
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

					// BEGIN: This block of code always returns the JavaScript Query Object known as qObj regardless of the technique that was used to perform the AJAX function...
					try {
						if (this.isReceivedFromCFAjax()) {
							eval(this.received);
							if (this.isDebugMode()) alert('oGateway.mode = [' + oGateway.mode + ']' + '\n' + this.received + '\n' + qObj);
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
							if (this.isDebugMode()) alert('oGateway.mode = [' + oGateway.mode + ']' + _db + '\n' + qObj);
						}
					} catch(e) {
						jsErrorExplainer(e, '(1) index.cfm :: oGateway.onReceive');
					} finally {
					}
					// END! This block of code always returns the JavaScript Query Object known as qObj regardless of the technique that was used to perform the AJAX function...
		
					handle_next_jsapi_function(); // get the next item from the stack...
				};
		
				oGateway.onTimeout = function (){
					this.throwError("The current request has timed out.\nPlease try your request again.");
					showServerCommand_Ends();
					handle_next_jsapi_function(); // get the next item from the stack...
				};
			}
	
			function execJSAPI_func(cmd, callBackFuncName, vararg_params) {
				var sValue = '&cfm=' + cmd + '&AUTH_USER=#Request.AUTH_USER#' + '&callBack=' + callBackFuncName;

			    // BEGIN: Make the arguments into a series of URL Parms, as-required, don't worry the AJAX Engine will figure out how to handle all this data...
				sValue += '&argCnt=' + arguments.length;
			    for (var i = 0; i < arguments.length - 2; i++) {
					sValue += '&arg' + (i + 1) + '=' + arguments[i + 2];
			    }
			//	alert('execJSAPI_func :: arguments = [' + arguments + ']' + '\n' + objectExplainer(arguments) + '\n' + sValue);
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
			//	try { qObj = ((qObj != null) ? object_destructor(qObj) : null); } catch(e) {}																		// avoid closures by destroying the previous object before making a new one...
				// END! This is where some bad evil things will happen unless these global variables were successfully initialized...
	
				QueryObj.removeInstances();
				NestedArrayObj.removeInstances();
				// END! Clean-Up any Objects that are still laying about to ensure there are no memory leaks in case there were any closures...
	
				// BEGIN: Clean-up event handlers to avoid memory leaks...
				var bodyObj = document.getElementsByTagName('body')[0];
				if (bodyObj != null) {
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
			function perform_click_btn_addMenuName() {
				var eObj = getGUIObjectInstanceById('txt_menuName');
				if (eObj != null) {
					if (eObj.value.trim().length > 0) {
						execJSAPI_func('addTopLevelMenuName', 'displayTopLevelMenuNames(qObj)', eObj.value.trim());
					} else {
						alert('INFO: Unable to process the requested action unless there is some data to act upon. Currently the only data there is to act upon is (' + eObj.value + ') however this makes no sense at the moment.  PLS try again.');
					}
				//	alert('perform_click_btn_addMenuName() = [' + eObj.id + '] = (' + eObj.value + ')');
				}
			}
			// Instrument Panel, Satellite, Radar, Charts
			function perform_click_btn_dropMenuName(_objID_prefix, _iNum, _recID) {
				//	alert('perform_click_btn_dropMenuName(' + _objID_prefix + ', ' + _iNum + ', ' + _recID + ')');
				if (confirm('Are you sure you really want to delete that record from the database ?')) {
					_recID = ((!!_recID) ? _recID : -1);
					if (_recID > -1) {
						execJSAPI_func('dropTopLevelMenuName', 'displayTopLevelMenuNames(qObj)', _recID);
					} else {
						alert('ERROR: Programming ERROR - This message should NEVER ever been seen so this means someone, shall we call him/her the programmer ?!?  Forgot something.  Oops !');
					}
				}
			}
			
			function perform_click_btn_editMenuName(_objID_prefix, _iNum, _recID) {
			//	alert('perform_click_btn_editMenuName(' + _objID_prefix + ', ' + _iNum + ', ' + _recID + ')');
				var _handle = guiActionsObj.push('btn_addMenuName');
				if (_handle > -1) {
					guiActionsObj.replaceAspectNamedFor(_handle, 'value', '*');
					guiActionsObj.replaceAspectNamedFor(_handle, 'title', 'Click to Save the edited Menu Name to the Db.');
				//	alert('Did it work ?');
				//	guiActionsObj.pop(_handle);
				}
			}

			function perform_click_btn_revertMenuName() {
				alert('perform_click_btn_revertMenuName()');
			}
			
			function displayTopLevelMenuNames(qObj) {
				var _html = '';

				function displayActionsPanel(objID_prefix, iNum, recID, i_leftOrRight, bool_isHorz) {
					var someHtml = '';
					
					bool_isHorz = ((bool_isHorz == true) ? bool_isHorz : false);
					i_leftOrRight = (((i_leftOrRight == 1) || (i_leftOrRight == 2)) ? i_leftOrRight : -1);
					
					someHtml = '<table width="100%" cellpadding="-1" cellspacing="-1">';
					someHtml += '<tr>';
					if (i_leftOrRight == 2) someHtml += '<td><button id="btn_dropMenuName" class="buttonClass" title="Click to Delete a Menu Name from the Db." onclick="perform_click_btn_dropMenuName(\'' + objID_prefix + '\',' + iNum + ',' + recID + '); return false;">[-]</button></td>';
					if ( (bool_isHorz == false) && ( (i_leftOrRight != 1) || (i_leftOrRight != 2) ) ) {
						someHtml += '</tr>';
						someHtml += '<tr>';
					}
					if (i_leftOrRight == 1) someHtml += '<td><button id="btn_editMenuName" class="buttonClass" title="Click to Edit a Menu Name in the Db." onclick="perform_click_btn_editMenuName(\'' + objID_prefix + '\',' + iNum + ',' + recID + '); return false;">[*]</button></td>';
					someHtml += '</tr>';
					someHtml += '</table>';
					
					return someHtml;
				};

				function displayRecord(_ri, _dict, _rowCntName) {
					var _ID = '';
					var _MENUNAME = '';
					var _rowCnt = -1;
					
					try {
						_ID = _dict.getValueFor('ID');
						_MENUNAME = _dict.getValueFor('MENUNAME');
						_rowCnt = _dict.getValueFor(_rowCntName);
					} catch(e) {
					} finally {
					}
					
					_html += '<tr>';
					_rowStyle = ((_ri < _rowCnt) ? 'border-bottom: thin solid Silver;' : '');
					_html += '<td style="' + _rowStyle + '"><span id="span_menuRecord_ACTION_LEFT_' + _ri + '" class="normalStatusClass">' + displayActionsPanel('span_menuRecord_MENUNAME_', _ri, _ID, 1, true) + '</span></td>'; // this is the ACTIONS column...
					_html += '<td style="' + _rowStyle + '"><span id="span_menuRecord_ID_' + _ri + '" class="normalStatusClass">' + _ri + '</span></td>'; // this is the ID column...
					_html += '<td style="' + _rowStyle + '"><span id="span_menuRecord_MENUNAME_' + _ri + '" class="normalStatusClass">' + _MENUNAME + '</span></td>'; // this is the MENUNAME column...
					_html += '<td style="' + _rowStyle + '"><span id="span_menuRecord_ACTION_RIGHT_' + _ri + '" class="normalStatusClass">' + displayActionsPanel('span_menuRecord_MENUNAME_', _ri, _ID, 2, true) + '</span></td>'; // this is the ACTIONS column...
					_html += '</tr>';
				//	alert('displayRecord(_ri = [' + _ri + ']' + ', _rowCnt = [' + _rowCnt + ']' + ', _dict = [' + _dict + '])' + '\n');
				};

				function displayControlPanel() {
					_html += '<tr>';
					_html += '<td><button id="btn_addMenuName" class="buttonClass" title="Click to Add a Menu Name to the Db." onclick="perform_click_btn_addMenuName(); return false;">[+]</button></td>';
					_html += '<td colspan="2"><input type="text" class="textEntryClass" id="txt_menuName" size="30" maxlength="50"></td>';
					_html += '<td><button id="btn_revertMenuName" class="buttonClass" style="display: none;" title="Click to revert the chosen Action." onclick="perform_click_btn_revertMenuName(); return false;">[<<]</button></td>';
					_html += '</tr>';
				};

				function displayTable(someHtml, _width, bgColor, _border) {
					_html = '<table width="' + _width + '" border="' + _border + '" cellpadding="-1" cellspacing="-1">';
					_html += '<tr bgcolor="' + bgColor + '">';
					_html += '<td>' + someHtml + '</td>';
					_html += '</tr>';
					_html += '</table>';
				};

				var cObj = getGUIObjectInstanceById('div_contents');
				if (cObj != null) {
					var nRecs = -1;
					var qStats = qObj.named('qDataNum');
					if (qStats != null) {
						nRecs = qStats.dataRec[1];
					}
					if (nRecs > 0) {
						var qData = qObj.named('qData1');
						if (qData != null) {
							_html = '<table width="100%" cellpadding="-1" cellspacing="-1">';
							_html += '<tr bgcolor="silver">';
							_html += '<td><span id="span_menuRecord_HEADER_1" title="*" class="normalStatusBoldClass">&nbsp;</span></td>';
							_html += '<td><span id="span_menuRecord_HEADER_2" title="ID" class="normalStatusBoldClass">##</span></td>';
							_html += '<td><span id="span_menuRecord_HEADER_3" title="MENUNAME" class="normalStatusBoldClass">Menu Name</span></td>';
							_html += '</tr>';
							// iterate over the Query Obj pulling out data...
							qData.iterateRecObjs(displayRecord);
							displayControlPanel();
							_html += '</table>';
							displayTable(_html, 200, const_paper_color_light_yellow, 1);
							flushGUIObjectChildrenForObj(cObj);
						//	alert(_html);
							cObj.innerHTML = _html;

							var eObj = getGUIObjectInstanceById('txt_menuName');
							if (eObj != null) {
								eObj.focus();
							}
							
						//	alert('displayTopLevelMenuNames()' + ', nRecs = [' + nRecs + ']' + ', qData = [' + qData + ']' + '\n' + qStats + '\n' + qObj);
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
								<button name="btn_helperPanel" id="btn_helperPanel" class="buttonMenuClass" onclick="var cObj = getGUIObjectInstanceById('td_ajaxHelperPanel'); var bObj = getGUIObjectInstanceById('btn_helperPanel'); var tbObj = getGUIObjectInstanceById('table_ajaxHelperPanel'); if ( (cObj != null) && (bObj != null) && (tbObj != null) ) { cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style); bObj.value = ((cObj.style.display == const_inline_style) ? '[<<]' : '[>>]'); if (cObj.style.display == const_inline_style) { tbObj.style.width = _global_clientWidth; oGateway.setDebugMode(); } else { oGateway.setReleaseMode(); }; }; return false;">[>>]</button>
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
					<button name="btn_getContents" id="btn_getContents" class="buttonMenuClass" onclick="execJSAPI_func('getTopLevelMenuNames', 'displayTopLevelMenuNames(qObj)'); return false;">[?]</button>
				</td>
				<td align="left" valign="top">
					<div id="div_contents" style="display: inline;"></div>
				</td>
			</tr>
		</table>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			oGateway.hideFrame();
			var cObj = getGUIObjectInstanceById('btn_hideShow_iFrame');
			if (cObj != null) {
				if (oGateway.visibility == ((document.layers) ? 'show' : 'visible')) {
					cObj.value = cObj.value.clipCaselessReplace('show', 'Hide');
				}
			}

			var cObj = getGUIObjectInstanceById('btn_useXmlHttpRequest');
			if (cObj != null) {
				if (oGateway.isXmlHttpPreferred == false) {
					cObj.value = cObj.value.clipCaselessReplace('iFRAME', 'XmlHttpRequest');
				}
			}

			var cObj = getGUIObjectInstanceById('btn_useMethodGetOrPost');
			if (cObj != null) {
				if (oGateway.isMethodGet()) {
					cObj.value = cObj.value.clipCaselessReplace('GET', 'Post');
				}
			}

			var cObj = getGUIObjectInstanceById('btn_useDebugMode');
			if (cObj != null) {
				if (oGateway.isReleaseMode() == true) {
					cObj.value = cObj.value.clipCaselessReplace('Debug', 'Release');
				}
			}

		// -->
		</script>

	</body>
	</html>
</cfoutput>
