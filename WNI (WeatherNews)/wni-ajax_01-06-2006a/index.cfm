<cfset _js_path = "js/">

<cfset _CrossBrowserLibrary_js = "#_js_path#CrossBrowserLibrary.js">
<cfset _gateway_js = "#_js_path#gatewayApi_2.03/gateway.js">
<cfset _wddx_js = "#_js_path#gatewayApi_2.03/wddx.js">
<cfset _jsapi_extensions_js = "#_js_path#gatewayApi_2.03/js/jsapi_extensions.js">

<cfset _iframe_ssi_script2_js = "#_js_path#www.dynamicdrive.com/iframe_ssi_script2.js">

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

		<script language="JavaScript1.2" src="#_cf_query_obj_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_nested_array_obj_js#" type="text/javascript"></script>
	</head>
	
	<body onload="window_onload()" onunload="window_onUnload()">
	
		<!--// load the Client/Server Gateway API //-->
		<script language="JavaScript1.2" src="#_wddx_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_gateway_js#" type="text/javascript">></script>
		<!--// load the extensions to the Client/Server Gateway API //-->
		<script language="JavaScript1.2" src="#_jsapi_extensions_js#" type="text/javascript">></script>
	
		<script language="JavaScript1.2" type="text/javascript">
		<!--//
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
			oGateway.set_isServerLocal(bool_isServerLocal);
			oGateway.setMethodGet();

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
		
					// BEGIN: received items is an array that gives the variable name followed by the item that goes into the variable...
					// this.received holds the received values...
					jsObjectExplainer(this.received);
					
					try {
						for( var i = 0; i < this.received.length; i++) {
						}
					} catch(e) {
					} finally {
					}
		
					showServerCommand_Ends();
					handle_next_jsapi_function(); // get the next item from the stack...
				};
		
				oGateway.onTimeout = function (){
					this.throwError("The current request has timed out.\nPlease try your request again.");
					showServerCommand_Ends();
					handle_next_jsapi_function(); // get the next item from the stack...
				};
			}
	
			function execJSAPI_func(cmd) {
				var sValue = cmd + ',AUTH_USER=#Request.AUTH_USER#';
				sValue += ',UUID=' + URLEncode(uuid());

				oGateway.setMethodGet();
				oGateway.enableCache = false; // this flag controls whether the server request is cached or not...
				oGateway.timeout = #Request.const_js_gateway_time_out_symbol#; // matches the ColdFusion time-out which is 120 secs at SBC...
				oGateway.sendPacket(URLEncode(sValue));
			}

			function window_onload() {
				init();
	
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

		<b>Hello World !</b>
		<br><br>
		
		<table width="100%" bgcolor="##80FFFF" border="1" cellpadding="-1" cellspacing="-1">
			<tr>
				<td align="center">
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
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
		
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			oGateway.hideFrame();
			var cObj = getGUIObjectInstanceById('btn_hideShow_iFrame');
			if (cObj != null) {
				if (oGateway.visibility == ((document.layers) ? 'show' : 'visible')) {
					cObj.value = cObj.value.clipCaselessReplace('show', 'Hide');
				}
			}
		// -->
		</script>

	</body>
	</html>
</cfoutput>
