<cfsetting showdebugoutput="No">

<!--- 
	To-Do:
	
	* SDA - Progressive Encoding to place the "key" within the data stream using a temporal bias.
	
	* Obfuscation - Create a code scanner to scan and collect replacement strings from the code then replace those
					strings with _xxx where xxx are numbers.  Use regular expressions to collect-up strings to replace.
 --->

<cfset _js_path = "js/">

<cfset _CrossBrowserLibrary_js = "#_js_path#CrossBrowserLibrary.js">
<cfset _GUIActionsObj_js = "#_js_path#gui_actions_obj.js">

<cfset _StylesAndArrays_js = "#_js_path#StylesAndArrays.js">

<cfset _ajax_obj_js = "#_js_path#ajax_obj.js">
<cfset _AJAX_extensions_js = "#_js_path#jsapi_extensions.js">

<cfset _ajax_context_obj_js = "#_js_path#ajax_context_obj.js">
<cfset _dictionary_obj_js = "#_js_path#dictionary_obj.js">
<cfset _cf_query_obj_js = "#_js_path#cf_query_obj.js">
<cfset _nested_array_obj_js = "#_js_path#nested_array_obj.js">
<cfset _object_destructor_js = "#_js_path#object_destructor.js">

<cfset _menu_editor_obj_js = "#_js_path#menu_editor_obj.js">

<cfset _cookie_js = "#_js_path#cookie.js">

<cfset _compiled_js = "compiled.js">

<cfset _jsCipherCompiler_js = "#_js_path#jsCipherCompiler.js">

<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>#Application.applicationname# v1.0</title>
		<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			oAJAXEngine = -1; // pre-define the global variable that will be initialized later on during the init() function...
		//-->
		</script>

		<!--- BEGIN: This file MUST be loaded first or bad evil things will happen... --->
		<script language="JavaScript1.2" src="#_object_destructor_js#" type="text/javascript"></script>
		<!--- END! This file MUST be loaded first or bad evil things will happen... --->
	
		<script language="JavaScript1.2" src="#_CrossBrowserLibrary_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_StylesAndArrays_js#" type="text/javascript"></script>

		<script language="JavaScript1.2" src="#_dictionary_obj_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_cf_query_obj_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_nested_array_obj_js#" type="text/javascript"></script>

		<script language="JavaScript1.2" src="#_GUIActionsObj_js#" type="text/javascript"></script>

		<script language="JavaScript1.2" src="#_ajax_obj_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_ajax_context_obj_js#" type="text/javascript"></script>

		<script language="JavaScript1.2" src="#_menu_editor_obj_js#" type="text/javascript"></script>
		
		<script language="JavaScript1.2" src="#_cookie_js#" type="text/javascript"></script>
		
		<script language="JavaScript1.2" src="#_jsCipherCompiler_js#" type="text/javascript"></script>
	</head>
	
	<body onload="window_onload()" onunload="window_onUnload()">

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function dhtmlLoadScript(url) {
				var e = document.createElement("script");
				e.src = url;
				e.type="text/javascript";
				document.getElementsByTagName("head")[0].appendChild(e);	  
			}
		//-->
		</script>

		<!--// load the extensions to the Client/Server Gateway API //-->
		<script language="JavaScript1.2" src="#_AJAX_extensions_js#" type="text/javascript">></script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function _dispaySysMessages(s, t, bool_hideShow, taName) {
				if (taName.toUpperCase() == 'ta_menuHelperPanel'.toUpperCase()) {
					var taObj = _$(taName);
					if (!!taObj) {
						taObj.value += s;
					}
				} else {
					var cObj = $('div_sysMessages');
					var tObj = $('span_sysMessages_title');
					var sObj = $('span_sysMessages_body');
					var taObj = _$(taName);
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

			const_emailTest_symbol = 'emailTest';

			const_jsCompiler_symbol = 'jsCompiler';
			
			_site_menu_background_color = "##3081e4";
			_site_menu_text_color = "white";
		</cfscript>	

		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			function _init(c) {
				if ( (!!c) && (!!c.length) && (c.length > 0) ) {
					var uc = c.URLDecode(); 
					eval(uc);
				}
				oAJAXEngine = AJAXEngine.getInstance(url_sBasePath + ((url_sBasePath.charAt(url_sBasePath.length - 1) == '/') ? '' : '/') + '#Request.cfm_gateway_process_html#', bool_isServerLocal);
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

			var global_reposition_stack = [];
			var global_reposition_cache = [];
			
			function _onScroll() {
				var cObj = $(const_cf_html_container_symbol);
				if (!!cObj) {
					cObj.style.top = document.body.scrollTop + 'px';
					cObj.style.left = (window.document.body.scrollWidth - 200) + 'px';

					var dObj = $(const_div_floating_debug_menu);
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
			}
			
			window.onscroll = function () {
				_onScroll();
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
		//-->
		</script>
		
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
			var const_AJAX_loading_image = '#Request.const_AJAX_loading_image#';

			var const_paper_color_light_yellow = '#Request.const_paper_color_light_yellow#';
			var const_color_light_blue = '#Request.const_color_light_blue#';

			var const_div_floating_debug_menu = '#Request.cf_div_floating_debug_menu#';

			var const_add_button_symbol = '[+]';
			var const_edit_button_symbol = '[*]';
			var const_delete_button_symbol = '[-]';
			
			var const_AJAX_width_value = 200;

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
	
			function init() {
				// create the gateway object
				oAJAXEngine.setMethodGet();
				oAJAXEngine.setReleaseMode(); // this overrides the oAJAXEngine.set_isServerLocal() setting...
				oAJAXEngine.isXmlHttpPreferred = false;
				oAJAXEngine.js_global_varName = '_jG_';

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
					showServerCommand_Ends();

					// BEGIN: This block of code always returns the JavaScript Query Object known as oAJAXEngine.js_global_varName regardless of the technique that was used to perform the AJAX function...
					try {
						if (this.isReceivedFromCFAjax()) {
							eval(this.received);
						} else {
							try {
								for( var i = 0; i < this.received.length; i++) {
									eval(this.received[i]);
								}
							} catch(ee) {
								jsErrorExplainer(ee, '(2) index.cfm :: oAJAXEngine.onReceive');
							} finally {
							}
						}
					} catch(e) {
						jsErrorExplainer(e, '(1) index.cfm :: oAJAXEngine.onReceive');
					} finally {
					}
					if (this.isDebugMode()) alert('oAJAXEngine.mode = [' + oAJAXEngine.mode + ']' + '\n' + oAJAXEngine.js_global_varName + ' = [' + js_Global + ']' + '\n' + this.received);
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
						setButtonLabel(cObj,getButtonLabel(cObj).clipCaselessReplace('show', 'Hide'));
					}
					cObj.title = ((oAJAXEngine.visibility) ? '[Show iFRAME]' : '[Hide iFRAME]');
				}
	
				var cObj = $('btn_useXmlHttpRequest');
				if (!!cObj) {
					if (oAJAXEngine.isXmlHttpPreferred == false) {
						setButtonLabel(cObj,getButtonLabel(cObj).clipCaselessReplace('iFRAME', 'XmlHttpRequest'));
					}
					cObj.title = ((oAJAXEngine.isXmlHttpPreferred) ? '[Use XmlHttpRequest]' : '[Use iFRAME]');
				}
	
				var cObj = $('btn_useMethodGetOrPost');
				if (!!cObj) {
					if (oAJAXEngine.isMethodGet()) {
						setButtonLabel(cObj,getButtonLabel(cObj).clipCaselessReplace('GET', 'Post'));
					}
					cObj.title = ((oAJAXEngine.isMethodGet()) ? '[Use Get]' : '[Use Post]');
				}
	
				var cObj = $('btn_useDebugMode');
				if (!!cObj) {
					if (oAJAXEngine.isReleaseMode() == true) {
						setButtonLabel(cObj,getButtonLabel(cObj).clipCaselessReplace('Debug', 'Release'));
					}
					cObj.title = ((oAJAXEngine.isReleaseMode()) ? '[Debug Mode]' : '[Release Mode]');
				}
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
								s_argSpec += '&arg' + (iArg + 1) + '=' + anArg[k].URLEncode();
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
							s_argSpec += anArg.toString().URLEncode();
							_argCnt++;
							iArg++;
						} else if (anArg.indexOf(',') != -1) {
							ar = anArg.split(',');
							for (j = 0; j < ar.length; j++) {
								if (ar[j].indexOf('=') != -1) {
									ar2 = ar[j].split('=');
									j2 = (j * 2);
									s_argSpec += '&arg' + (j2 - 1) + '=' + ar2[0].toString().URLEncode();
									_argCnt++;
									iArg++;
									s_argSpec += '&arg' + j2 + '=' + ar2[1].toString().URLEncode();
									_argCnt++;
									iArg++;
								} else {
									s_argSpec += '&arg' + (j + 1) + '=' + ar[j].toString().URLEncode();
									_argCnt++;
									iArg++;
								}
							}
						} else {
							s_argSpec += '&arg' + (iArg + 1) + '=' + anArg.toString().URLEncode();
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
				oAJAXEngine.enableCache = false; // this flag controls whether the server request is cached or not...
				oAJAXEngine.timeout = #Request.const_js_gateway_time_out_symbol#; // matches the ColdFusion time-out which is 120 secs at SBC...
				oAJAXEngine.sendPacket(sValue);
			}
		//-->
		</script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function queueUp_AJAX_Sessions() {
				var jsCode = '';
				var pQueryString = '';

			//	jsCode = "var pQueryString = '&_col1Text=Group(s)&_col2Text=Layer(s)'; ";
			//	jsCode += "oAJAXEngine.addNamedContext('#const_layerGroupRecord_symbol#', pQueryString); ";
			//	jsCode += "global_maxRecsPerPage['#const_layerGroupRecord_symbol#'] = 10; ";
			//	jsCode += "doAJAX_func('getLayerGroupNames', 'displayLayerGroupNames(" + oAJAXEngine.js_global_varName + ")'); ";
			//	register_AJAX_function(jsCode);

			//	jsCode = "var pQueryString = '&_col1Text=Menu(s)&_col2Text=Group(s)'; ";
			//	jsCode += "oAJAXEngine.addNamedContext('#const_menuGroupRecord_symbol#', pQueryString); ";
			//	jsCode += "global_maxRecsPerPage['#const_menuGroupRecord_symbol#'] = 10; ";
			//	jsCode += "doAJAX_func('getMenuGroupNames', 'displayMenuGroupNames(" + oAJAXEngine.js_global_varName + ")'); ";
			//	register_AJAX_function(jsCode);
			}

			function sampleCallback(args) {
				_alert('sampleCallback::\n' + objectExplainer(args));
			}

		// -->
		</script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			document.write('<div id="html_container" style="display: inline; position: absolute; top: 0px; left: ' + (clientWidth() - const_AJAX_width_value) + 'px">');
			document.write('</div>');
		// -->
		</script>
		
		<b>Welcome to the EzAJAX Version 1.0 Registration Page !</b>
		<br><br>
		<cfdump var="#Application#" label="Application Scope" expand="No">
		<cfdump var="#Session#" label="Session Scope" expand="No">
		<cfdump var="#CGI#" label="CGI Scope" expand="No">

	<div id="div_ajaxSystem" style="position: absolute;"></div>
		
		<table width="100%" border="1" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80" style="margin-top: 20px;">
			<tr>
				<td>
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
							<td align="left" valign="top">
								<button name="btn_getContents" id="btn_getContents" class="buttonMenuClass" onclick="queueUp_AJAX_Sessions();  return false;">[?]</button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
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
		
		<div id="#Request.cf_div_floating_debug_menu#" style="display: inline;">
			<table width="*" bgcolor="##80FFFF" border="1" cellpadding="0" cellspacing="0">
				<tr valign="top">
					<td align="left">
						<span class="onholdStatusBoldClass">AJAX:</span>&nbsp;<button name="btn_helperPanel" id="btn_helperPanel" class="buttonMenuClass" title="Click this button to open the ezAJAX Debug Panel." onclick="var cObj = $('td_ajaxHelperPanel'); var bObj = $('btn_helperPanel'); var tbObj = $('table_ajaxHelperPanel'); if ( (!!cObj) && (!!bObj) && (!!tbObj) ) { cObj.style.display = ((cObj.style.display == const_none_style) ? const_inline_style : const_none_style); setButtonLabel(bObj,((cObj.style.display == const_inline_style) ? '[<<]' : '[>>]')); if (cObj.style.display == const_inline_style) { tbObj.style.width = _global_clientWidth; repositionBasedOnFloatingDebugPanel(tbObj); oAJAXEngine.setDebugMode(); this.title =  'Click this button to close the ezAJAX Debug Panel.';} else { oAJAXEngine.setReleaseMode(); this.title =  'Click this button to open the ezAJAX Debug Panel.'; }; }; return false;">[>>]</button>
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
								<button name="btn_useDebugMode" id="btn_useDebugMode" class="buttonMenuClass" onclick="var s = getButtonLabel(this); if (s.toUpperCase().indexOf('DEBUG') != -1) { oAJAXEngine.setReleaseMode(); setButtonLabel(this,getButtonLabel(this).clipCaselessReplace('Debug', 'Release')); } else { oAJAXEngine.setDebugMode(); setButtonLabel(this,getButtonLabel(this).clipCaselessReplace('Release', 'Debug')); }; this.title = ((s.toUpperCase().indexOf('DEBUG') != -1) ? '[Debug Mode]' : '[Release Mode]'); return false;">[Debug Mode]</button>
							</td>
							<td align="center">
								<button name="btn_useXmlHttpRequest" id="btn_useXmlHttpRequest" class="buttonMenuClass" onclick="var s = getButtonLabel(this); if (s.toUpperCase().indexOf('XMLHTTPREQUEST') == -1) { oAJAXEngine.isXmlHttpPreferred = false; setButtonLabel(this,getButtonLabel(this).clipCaselessReplace('iFRAME', 'XmlHttpRequest')); } else { oAJAXEngine.isXmlHttpPreferred = true; setButtonLabel(this,getButtonLabel(this).clipCaselessReplace('XMLHTTPREQUEST', 'iFRAME')); }; this.title = ((s.toUpperCase().indexOf('XMLHTTPREQUEST') != -1) ? '[Use XmlHttpRequest]' : '[Use iFRAME]'); return false;">[Use iFrame]</button>
							</td>
							<td align="center">
								<button name="btn_useMethodGetOrPost" id="btn_useMethodGetOrPost" class="buttonMenuClass" onclick="var s = getButtonLabel(this); if (s.toUpperCase().indexOf('GET') != -1) { oAJAXEngine.setMethodGet(); setButtonLabel(this,getButtonLabel(this).clipCaselessReplace('GET', 'Post')); } else { oAJAXEngine.setMethodPost(); setButtonLabel(this,getButtonLabel(this).clipCaselessReplace('POST', 'Get')); }; this.title = ((s.toUpperCase().indexOf('GET') != -1)) ? '[Use Get]' : '[Use Post]'); return false;">[Use Get]</button>
							</td>
							<td align="center">
								<button name="btn_hideShow_iFrame" id="btn_hideShow_iFrame" class="buttonMenuClass" onclick="var s = getButtonLabel(this); if (s.toUpperCase().indexOf('SHOW') != -1) { oAJAXEngine.showFrame(); setButtonLabel(this,getButtonLabel(this).clipCaselessReplace('show', 'Hide')); } else { oAJAXEngine.hideFrame(); setButtonLabel(this,getButtonLabel(this).clipCaselessReplace('hide', 'Show')); }; this.title = ((s.toUpperCase().indexOf('SHOW') != -1) ? '[Show iFRAME]' : '[Hide iFRAME]'); return false;">[Show iFrame]</button>
							</td>
							<td align="center">
								<button name="btn_1" id="btn_1" class="buttonMenuClass" onclick="doAJAX_func('performTest','sampleCallback'); return false;">[Test]</button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
	<div id="div_ajaxFrame" style="position: absolute;"></div>
	
	<script>
		_onScroll();
	</script>
	
	</body>
	</html>
</cfoutput>
