<cfsetting showdebugoutput="No">

<!--- 
	To-Do:

	* Use .INI files to store the data from the analysis of the source modules.
	
	* Initially only one source module will be used - the one from WNI.com
	
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

<cfset _jsCipherCompiler_js = "#_js_path#jsCipherCompiler.js">

<cfset _geonosis_obj_js = "#_js_path#geonosis_obj.js">

<cfset _ajax_support_js = "#_js_path#ajax_support.js/support.js">

<cfset _dispaySysMessages_js = "#_js_path#dispaySysMessages.js">

<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>#Application.applicationname# v1.0</title>
		<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 
		
		<cfscript>
			writeOutput(Request.commonCode.html_nocache());
		</cfscript>
<cfif (NOT Request.commonCode.isServerLocal())>
		<script language="JavaScript1.2" src="js/disableContextMenu.js" type="text/javascript"></script>
</cfif>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			oAJAXEngine = -1; // pre-define the global variable that will be initialized later on during the init() function...
		//-->
		</script>

<cfif (NOT Request.commonCode.isServerLocal())>
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
		<script language="JavaScript1.2" src="#_geonosis_obj_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_ajax_support_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="js/packager.js/javascript.js" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_dispaySysMessages_js#" type="text/javascript"></script>
<cfelse>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			<cfinclude template="#_object_destructor_js#">
			<cfinclude template="#_CrossBrowserLibrary_js#">
			<cfinclude template="#_StylesAndArrays_js#">
			<cfinclude template="#_dictionary_obj_js#">
			<cfinclude template="#_cf_query_obj_js#">
			<cfinclude template="#_nested_array_obj_js#">
			<cfinclude template="#_GUIActionsObj_js#">
			<cfinclude template="#_ajax_obj_js#">
			<cfinclude template="#_ajax_context_obj_js#">
			<cfinclude template="#_menu_editor_obj_js#">
			<cfinclude template="#_cookie_js#">
			<cfinclude template="#_jsCipherCompiler_js#">
			<cfinclude template="#_geonosis_obj_js#">
			<cfinclude template="#_ajax_support_js#">
			<cfinclude template="#_dispaySysMessages_js#">
		//-->
		</script>
</cfif>

		<cfscript>
			cf_const_Objects_symbol = '[?Objects]';
			cf_const_getCLASSES_symbol = 'getCLASSES';
			cf_const_chgDataForObject_symbol = 'chgDataForObject';
			cf_const_getOBJECTS_symbol = 'getOBJECTS';

			Request.commonCode.registerCFtoJS_variable('cf_const_Objects_symbol', cf_const_Objects_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_getCLASSES_symbol', cf_const_getCLASSES_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_chgDataForObject_symbol', cf_const_chgDataForObject_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_getOBJECTS_symbol', cf_const_getOBJECTS_symbol);
			
			Request.commonCode.emitCFtoJS_variables();
		</cfscript>
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

		<cfscript>
			_site_menu_background_color = "##3081e4";
			_site_menu_text_color = "white";
			
		//	aGeonosisObj = Request.commonCode.objectForType('geonosisObject').init(Request.Geonosis_DSN);
		//	aGeonosisObj.readObjectNamedOfType('Super User', 'GeonosisROLES').getObject().getAttrs();
			
		//	aGeonosisObjCollector = Request.commonCode.objectForType('geonosisObjectCollector').init(Request.Geonosis_DSN).getObjectsOfType('GeonosisROLES');

		//	aGeonosisClassCollector = Request.commonCode.objectForType('geonosisClassCollector').init(Request.Geonosis_DSN).getClasses();
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
					_alert(jsErrorExplainer(e, 'handle_ajaxHelper_onClick()'));
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
					_alert(jsErrorExplainer(e, 'handle_ajaxHelper2_onClick()'));
		        }
			}
		//-->
		</script>
		
		<script language="JavaScript1.2" type="text/javascript">
		<!--//
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

					var oo = $(this.idGateway);
					if (!!oo) {
						//_alert('oo.document.body = [' + oo.document.body + ']' + ', (typeof oo.document.body) = [' + (typeof oo.document.body) + ']' + ', oo.document.body.length = [' + oo.document.body.length + ']' + '\n\n' + objectExplainer(oo.document.body));
					//	if (oAJAXEngine.isDebugMode()) _alert(oo.document.body.outerText);
					}
					
					// BEGIN: This block of code always returns the JavaScript Query Object known as oAJAXEngine.js_global_varName regardless of the technique that was used to perform the AJAX function...
					try {
						if (this.isReceivedFromCFAjax()) {
							if (this.isDebugMode()) _alert(this.received);
							eval(this.received);
						} else {
							try {
								for( var i = 0; i < this.received.length; i++) {
									if (this.isDebugMode()) _alert(this.received[i]);
									eval(this.received[i]);
								}
							} catch(ee) {
								if (this.isDebugMode()) _alert(jsErrorExplainer(ee, '(2) index.cfm :: oAJAXEngine.onReceive'));
							} finally {
							}
						}
					} catch(e) {
						if (this.isDebugMode()) _alert(jsErrorExplainer(e, '(1) index.cfm :: oAJAXEngine.onReceive'));
					} finally {
					}
					if (this.isDebugMode()) _alert('oAJAXEngine.mode = [' + oAJAXEngine.mode + ']' + '\n' + oAJAXEngine.js_global_varName + ' = [' + oAJAXEngine.js_global_varName + ']' + '\n' + this.received);
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
											if (ar2[1].length > 0) argNames.push(ar2[0]);
											ar2[1] = ar2[1].toString();
											s_argSpec += '&' + ar2[0] + '=' + ar2[1].URLEncode();
											_argCnt++;
											iArg++;
										} else {
											s_argSpec += '&arg' + (j2 - 1) + '=' + ar2[0].toString().URLEncode();
											_argCnt++;
											iArg++;
											s_argSpec += '&arg' + j2 + '=' + ar2[1].toString().URLEncode();
											_argCnt++;
										}
										iArg++;
									} else {
										s_argSpec += '&arg' + (j + 1) + '=' + ar[j].toString().URLEncode();
										_argCnt++;
										iArg++;
									}
								}
							}
						} else {
							s_argSpec += '&arg' + (iArg + 1) + '=' + anArg.toString().URLEncode();
							_argCnt++;
							iArg++;
						}
					}
			    }
				sValue += '&argCnt=' + ((argNames.length > 0) ? argNames.length : ((s_argSpec.length > 0) ? _argCnt : 0)) + s_argSpec + ((argNames.length > 0) ? '&argNames=' + argNames.toString().URLEncode() : '');
				if (oAJAXEngine.isDebugMode()) _alert('argNames.length = [' + argNames.length + ']');
				if (oAJAXEngine.isDebugMode()) _alert('argNames = [' + argNames + ']');
				if (oAJAXEngine.isDebugMode()) _alert('sValue = [' + sValue + ']');
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

<cfif (Request.commonCode.isServerLocal())>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			<cfinclude template="js/packager.js/javascript.js">
		//-->
		</script>
</cfif>
	<cfscript>
		Request.bool_canDebugHappen = Request.commonCode.isServerLocal();
	</cfscript>

	<div id="div_ajaxSystem" style="position: absolute;"></div>
		
		<table width="100%" border="1" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80" style="margin-top: 20px;">
			<tr>
				<td>
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
							<td align="left" valign="top">
								<button name="btn_getContents" id="btn_getContents" class="buttonMenuClass" onclick="queueUp_AJAX_Sessions(js_const_Objects_symbol);  return false;">#cf_const_Objects_symbol#</button>
							</td>
							<td align="center" valign="top">
								<span class="textClass"><b>Welcome to the AJAX powered JavaScript Packager !</b></span>
							</td>
							<td align="right" valign="top">
								<div id="html_container" style="display: inline; left: 0px;"></div>
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

		<div id="#Request.cf_div_floating_debug_menu#" style="display: none;">
			<table width="*" bgcolor="##80FFFF" border="1" cellpadding="-1" cellspacing="-1">
				<tr>
					<td align="left" style="display: inline;">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td align="left">
									<span class="onholdStatusBoldClass">AJAX:</span>&nbsp;<button name="btn_helperPanel" id="btn_helperPanel" class="buttonMenuClass" title="Click this button to open the AJAX Debug Panel" onclick="handle_ajaxHelper_onClick(); return false;">[>>]</button>
								</td>
							</tr>
							<cfif (Request.bool_canDebugHappen)>
								<tr>
									<td align="left">
										<span class="onholdStatusBoldClass">Scopes:</span>&nbsp;<button name="btn_helperPanel2" id="btn_helperPanel2" class="buttonMenuClass" title="Click this button to open the Scopes Debug Panel" onclick="handle_ajaxHelper2_onClick(); return false;">[>>]</button>
									</td>
								</tr>
							</cfif>
						</table>
					</td>
				</tr>
			</table>
		</div>

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
		
		<table width="100%" cellpadding="-1" cellspacing="-1">
			<tr>
				<td id="td_ajaxHelperPanel2" align="center" style="display: none;">
					<table width="100%" border="1" bgcolor="##80FFFF" cellspacing="-1" cellpadding="-1" id="table_ajaxHelperPanel2" style="width: 800px;">
						<tr>
							<td align="center">
								<cfif (Request.bool_canDebugHappen)>
									<div id="div_application_debug_panel">
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td valign="top" align="left">
													<table width="100%" cellpadding="-1" cellspacing="-1">
														<tr>
															<td align="left" valign="top">
																<cfdump var="#Application#" label="Application Scope" expand="No">
															</td>
															<td align="left" valign="top">
																<cfdump var="#Session#" label="Session Scope" expand="No">
															</td>
															<td align="left" valign="top">
																<cfdump var="#CGI#" label="CGI Scope" expand="No">
															</td>
															<td align="left" valign="top">
																<cfdump var="#Request#" label="Request Scope" expand="No">
															</td>
														</tr>
													</table>
												</td>
											</tr>
										<cfif 0>
											<tr>
												<td valign="top" align="left">
													<table width="100%" cellpadding="-1" cellspacing="-1">
														<tr>
															<td align="left" valign="top">
																<cfdump var="#aGeonosisObj#" label="aGeonosisObj" expand="No">
															</td>
															<td align="left" valign="top">
																<cfdump var="#aGeonosisObjCollector#" label="aGeonosisObjCollector" expand="No">
															</td>
															<td align="left" valign="top">
																<cfdump var="#aGeonosisClassCollector#" label="aGeonosisClassCollector" expand="No">
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</cfif>
										</table>
									</div>
								</cfif>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			var cObj = $(const_cf_html_container_symbol);
			var dObj = $(const_div_floating_debug_menu);
			if ( (!!cObj) && (!!dObj) ) {
				if (dObj.style.display == const_none_style) {
					dObj.style.position = cObj.style.position;
				//	dObj.style.top = parseInt(cObj.style.top) + 25 + 'px';
					dObj.style.left = (clientWidth() - 75) + 'px';
					dObj.style.display = const_inline_style;
				}
			}
		// -->
		</script>
		
	<div id="div_ajaxFrame" style="position: absolute; top: 200px; left: 0px; width: 990px; height: 400px;"></div>
	
	<div id="div_contentHome" style="width: 990px; height: 400px;">
	</div>

	<table width="100%" cellpadding="-1" cellspacing="-1">
		<tr>
			<td>
			<cfif 1>
				<cfset uname = "RAHl3J6MvJg88x%2BFkqY5kEmRg%3D%3DRA%4056505CE2AF97989F">
				<cfset pwd = "RAH8gvyktucAcyvk8hVs%2FjsgQ%3D%3DRB%402A2DB4853AC7CE7860168B8740318499">
				<cfset structDecoder = Request.commonCode.decodeEncodedEncryptedString(URLDecode(pwd))>
				<cfset structDecoder2 = Request.commonCode.decodeEncodedEncryptedString(URLDecode(uname))>
				
				<cfset structMetaData = Request.commonCode.oJDBCMetaData(Request.Geonosis_DSN, structDecoder2.PLAINTEXT, structDecoder.PLAINTEXT)>

				<cfset structObjects = Request.commonCode.qJDBCColumns(structMetaData, 'cms', 'objects')>

				<cfset structAttrs = Request.commonCode.qJDBCColumns(structMetaData, 'cms', 'objectAttributes')>
			</cfif>
			</td>
		</tr>
	</table>
	
	</body>
	</html>
</cfoutput>
