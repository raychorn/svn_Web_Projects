<cfsetting showdebugoutput="no">

<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>#Application.applicationname# v1.0</title>
		<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 
		
		<cfscript>
			writeOutput(Request.commonCode.html_nocache());
		</cfscript>
<cfif (NOT isDebugMode())>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/disableContextMenu/" type="text/javascript"></script>
</cfif>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			oAJAXEngine = -1; // pre-define the global variable that will be initialized later on during the init() function...
		//-->
		</script>

		<!--- BEGIN: This file MUST be loaded first or bad evil things will happen... --->
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/object_destructor/" type="text/javascript"></script>
		<!--- END! This file MUST be loaded first or bad evil things will happen... --->
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/CrossBrowserLibrary/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/StylesAndArrays/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/dictionary_obj/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/cf_query_obj/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/nested_array_obj/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/gui_actions_obj/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/ajax_obj/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/ajax_context_obj/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/menu_editor_obj/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/cookie/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/jsCipherCompiler/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/geonosis_obj/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/ajax_support/support/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/dispaySysMessages/" type="text/javascript"></script>

		<cfscript>
			cf_const_Objects_symbol = '[?Objects]';
			cf_const_getCLASSES_symbol = 'getCLASSES';
			cf_const_chgDataForObject_symbol = 'chgDataForObject';
			cf_const_getOBJECTS_symbol = 'getOBJECTS';
			cf_const_chgAttrsForObject_symbol = 'chgAttrsForObject';
			cf_const_addClassDef_symbol = 'addClassDef';
			cf_const_dropClassDef_symbol = 'dropClassDef';
			cf_const_addObject_symbol = 'addObject';
			cf_const_dropObject_symbol = 'dropObject';
			cf_const_addAttribute_symbol = 'addAttribute';

			Request.commonCode.registerCFtoJS_variable('cf_const_Objects_symbol', cf_const_Objects_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_getCLASSES_symbol', cf_const_getCLASSES_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_chgAttrsForObject_symbol', cf_const_chgAttrsForObject_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_chgDataForObject_symbol', cf_const_chgDataForObject_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_getOBJECTS_symbol', cf_const_getOBJECTS_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_Session_symbol', Request.const_Session_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_Application_symbol', Request.const_Application_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_CGI_symbol', Request.const_CGI_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_Request_symbol', Request.const_Request_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_addClassDef_symbol', cf_const_addClassDef_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_dropClassDef_symbol', cf_const_dropClassDef_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_addObject_symbol', cf_const_addObject_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_dropObject_symbol', cf_const_dropObject_symbol);
			Request.commonCode.registerCFtoJS_variable('cf_const_addAttribute_symbol', cf_const_addAttribute_symbol);
			
			Request.commonCode.emitCFtoJS_variables();
		</cfscript>
	</head>
	
	<body onload="window_onload()" onunload="window_onUnload()">
	<noscript>You must enable JavaScript to use this site.</noscript>

		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/dhtmlLoadScript/" type="text/javascript"></script>

		<!--// load the extensions to the Client/Server Gateway API //-->
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/jsapi_extensions/" type="text/javascript"></script>

		<cfscript>
			_site_menu_background_color = "##3081e4";
			_site_menu_text_color = "white";
			
		//	aGeonosisObj = Request.commonCode.objectForType('geonosisObject').init(Request.Geonosis_DSN);
		//	aGeonosisObj.readObjectNamedOfType('Super User', 'GeonosisROLES').getObject().getAttrs();
			
		//	aGeonosisObjCollector = Request.commonCode.objectForType('geonosisObjectCollector').init(Request.Geonosis_DSN).getObjectsOfType('GeonosisROLES');

		//	aGeonosisClassCollector = Request.commonCode.objectForType('geonosisClassCollector').init(Request.Geonosis_DSN).getClasses();
		</cfscript>	
		
		<script language="JavaScript1.2" type="text/javascript">
			var const_cf_html_container_symbol = '#Request.cf_html_container_symbol#';
			var const_AJAX_loading_image = '#Request.const_AJAX_loading_image#';
			
			var const_paper_color_light_yellow = '#Request.const_paper_color_light_yellow#';
			var const_color_light_blue = '#Request.const_color_light_blue#';
			
			var const_div_floating_debug_menu = '#Request.cf_div_floating_debug_menu#';

			var url_fname = document.location.pathname.substring(0, document.location.pathname.length);
			var _ar = url_fname.split('/');
			_ar[_ar.length - 1] = null;
			var url_sBasePath = 'http:\/\/#CGI.HTTP_HOST#' + _ar.join('/');
			
			var const_cfm_gateway_process_html = '#Request.cfm_gateway_process_html#';
			
			var bool_isServerLocal = (('#Request.commonCode.isServerLocal()#'.toString().trim().toLowerCase() == 'yes') ? true : false);
			
			var const_cf_CGI_SCRIPT_NAME = '#CGI.SCRIPT_NAME#';
			
			var const_cf_AUTH_USER = '#Request.AUTH_USER#';
			
			var const_cf_gateway_time_out_symbol = '#Request.const_js_gateway_time_out_symbol#';
		</script>
		
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/_init/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/doAJAX_func/" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#Request.commonCode.clusterizeURL('http://#CGI.SERVER_NAME#/#ListFirst(CGI.SCRIPT_NAME, "/")#')#/xjs/packager/javascript/" type="text/javascript"></script>

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

		<cfsavecontent variable="content_application_debug_panel">
			<cfoutput>
				#Request.commonCode.scopesDebugPanelContentLayout()#
			</cfoutput>
		</cfsavecontent>		

		<table id="table_ajaxHelperPanel2" style="width: 800px;" cellpadding="-1" cellspacing="-1">
			<tr>
				<td id="td_ajaxHelperPanel2" align="center" style="display: none;">
					<table border="1" bgcolor="##80FFFF" cellspacing="-1" cellpadding="-1">
						<tr>
							<td align="center">
								<cfif (Request.bool_canDebugHappen)>
									#content_application_debug_panel#
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
			
			<cfscript>
				aContentStruct = Request.commonCode.processComplexHTMLContent(Request.commonCode.cfdump(Application, 'Application Scope', false));
				writeOutput("setApplicationScopeDebugPanelContent('#aContentStruct.htmlContent#');");
			</cfscript>
			
			<cfscript>
				aContentStruct = Request.commonCode.processComplexHTMLContent(Request.commonCode.cfdump(Session, 'Session Scope', false));
				writeOutput("setSessionScopeDebugPanelContent('#aContentStruct.htmlContent#');");
			</cfscript>
			
			<cfscript>
				aContentStruct = Request.commonCode.processComplexHTMLContent(Request.commonCode.cfdump(CGI, 'CGI Scope', false));
				writeOutput("setCgiScopeDebugPanelContent('#aContentStruct.htmlContent#');");
			</cfscript>
			
			<cfscript>
				aContentStruct = Request.commonCode.processComplexHTMLContent(Request.commonCode.cfdump(Request, 'Request Scope', false));
				writeOutput("setRequestScopeDebugPanelContent('#aContentStruct.htmlContent#');");
			</cfscript>
			
		// -->
		</script>

		<style type="text/css">
			#aContentStruct.styleContent#
		</style>
		
		<script language="JavaScript1.2" type="text/javascript">
			#aContentStruct.jsContent#
		</script>

	<div id="div_ajaxFrame" style="position: absolute; top: 200px; left: 0px; width: 990px; height: 400px;"></div>
	
	<div id="div_contentHome" style="width: 990px;">
	</div>

	</body>
	</html>
</cfoutput>
