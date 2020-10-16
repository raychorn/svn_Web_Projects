<cfcomponent displayname="ajaxCode" output="Yes" extends="commonCode">
	<cffunction name="js_jsInitCode" access="public" returntype="string">

		<cfsavecontent variable="Request._jsInitCode">
			<cfoutput>
				if (!!#Request.___jsName___#) {
				} else {
					var #Request.___jsName___# = -1;
				}
				#Request.___jsName___# = AJAXObj.getInstance();
				_#Request.___jsName___# = new Object();
			</cfoutput>
		</cfsavecontent>

	</cffunction>

	<cffunction name="js_jsCode_" access="public" returntype="string">
		<cfset var n = -1>
		<cfset var qStats = -1>

		<cfsavecontent variable="Request._jsCode_">
			<cfoutput>
				#populate_JS_queryObj(Request.qryObj, '_#Request.___jsName___#.qParms', true)#
				#Request.___jsName___#.init();
				<cfif (IsDefined("Request.qryData"))>
					<cfif (IsArray(Request.qryData))>
						<cfset n = ArrayLen(Request.qryData)>
		
						<cfscript>
							qStats = QueryNew('num');
							QueryAddRow(qStats, 1);
							QuerySetCell(qStats, 'num', n, qStats.recordCount);
						</cfscript>
		
						#populate_JS_queryObj(qStats, '_#Request.___jsName___#.qStats', true)#
						#Request.___jsName___#.push('qDataNum', _#Request.___jsName___#.qStats);
						<cfloop index="_i" from="1" to="#n#">
							#populate_JS_queryObj(Request.qryData[_i], '_#Request.___jsName___#.qData#_i#', true)#
							#Request.___jsName___#.push('qData#_i#', _#Request.___jsName___#.qData#_i#);
						</cfloop>
					</cfif>
				</cfif>
				#Request.___jsName___#.push('qParms', _#Request.___jsName___#.qParms);
				_#Request.___jsName___# = null;
			</cfoutput>
		</cfsavecontent>

	</cffunction>

	<cfscript>
		function registerQueryFromAJAX(qObj) {
			var tObj = -1;

			if (NOT IsDefined("Request.qryData")) {
				Request.qryData = ArrayNew(1);
				Request.qryData[ArrayLen(Request.qryData) + 1] = qObj;
			} else {
				if (IsArray(Request.qryData)) {
					Request.qryData[ArrayLen(Request.qryData) + 1] = qObj;
				} else {
					tObj = ArrayNew(1);
					tObj[ArrayLen(tObj) + 1] = Request.qryData;
					tObj[ArrayLen(tObj) + 1] = qObj;
					Request.qryData = qObj;
				}
			}
		}
		
		function beginAJAX() {
			var aa = -1;
			var aaN = -1;
			var i = -1;
			var aaP = -1;
			var _item = -1;
			var ii = -1;
			var _QUERY_STRING = '';
			var _CGI_QUERY_STRING = '';
			var _form_QUERY_STRING = '';

			if (Request.bool_using_xmlHttpRequest) {
				if (IsDefined("CGI.QUERY_STRING")) {
					_CGI_QUERY_STRING = URLDecode(CGI.QUERY_STRING);
				}
				if (IsDefined("form.QUERY_STRING")) {
					_form_QUERY_STRING = URLDecode(form.QUERY_STRING);
				}
		
				if (Request.bool_using_xmlHttpRequest_viaGET) {
					_QUERY_STRING = _CGI_QUERY_STRING;
				} else if (Request.bool_using_xmlHttpRequest_viaPOST) {
					_QUERY_STRING = _form_QUERY_STRING;
				}
			} else {
				// +++
				writeOutput('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
				writeOutput('<html>');
				writeOutput('<head>');
				writeOutput(html_nocache());

				if (Request.bool_canDebugHappen) {
					_prefix = '.';
					if (FileExists(ExpandPath('..\StyleSheet.css'))) {
						_prefix = '../';
					} else if (FileExists(ExpandPath('StyleSheet.css'))) {
						_prefix = '';
					}
					if (_prefix neq '.') {
						writeOutput('<LINK rel="STYLESHEET" type="text/css" href="#_prefix#StyleSheet.css"> ');
					}
				}

				writeOutput('</head>');
				writeOutput('<body>');

				if (Request.bool_canDebugHappen) {
					cf_dump(URL, 'URL Scope', false);
					cf_dump(FORM, 'FORM Scope', false);
					cf_dump(CGI, 'CGI Scope', false);
					
					writeOutput("BEGIN: #blue_formattedModuleName('cfinclude_AJAX_Begin.cfm')#<br>");
					writeOutput('(isDefined("url.data")) = [#(isDefined("url.data"))#]<br>');
					writeOutput('(isDefined("form.packet")) = [#(isDefined("form.packet"))#]<br>');
					writeOutput('(isDefined("url.wddx")) = [#(isDefined("url.wddx"))#]<br>');
					writeOutput('(isDefined("form.wddx")) = [#(isDefined("form.wddx"))#]<br>');
					writeOutput('(isDefined("CGI.QUERY_STRING")) = [#(isDefined("CGI.QUERY_STRING"))#]<br>');

					// BEGIN: Determine the data source from all available sources of data and route to _QUERY_STRING
					_QUERY_STRING = '';
					if (isDefined("url.data")) {
						if (Len(url.data) gt 0) {
							_QUERY_STRING = TRIM(URLDecode(url.data));
						}
					} else if (isDefined("form.packet")) {
						if (Len(form.packet) gt 0) {
							_QUERY_STRING = TRIM(URLDecode(form.packet));
						}
					} else if (isDefined("CGI.QUERY_STRING")) {
						if (Len(CGI.QUERY_STRING) gt 0) {
							_QUERY_STRING = TRIM(URLDecode(CGI.QUERY_STRING));
						}
					}
					// END! Determine the data source from all available sources of data and route to _QUERY_STRING
					if (Len(_QUERY_STRING) gt 0) {
						writeOutput('_QUERY_STRING = [#_QUERY_STRING#]<br>');
						for (ii = 1; ii lte ListLen(_QUERY_STRING, '&'); ii = ii + 1) {
							_item = _GetToken(_QUERY_STRING, ii, '&');
							writeOutput('_item = [#_item#]<br>');
							if (ListLen(_item, "=") eq 2) {
								writeOutput('&nbsp;[#_GetToken(_item, 1, "=")#]&nbsp;[#_GetToken(_item, 2, "=")#]<br>');
								if (LCase(_GetToken(_item, 1, "=")) eq LCase("wddx")) {
									writeOutput('0. Exec WDDX2CFML<br>');
									writeOutput('[#_GetToken(_item, 2, "=")#]<br>');
									input_item = _GetToken(_item, 2, "=");
									writeOutput('input_item = [#input_item#]<br>');
									cf_wddx_WDDX2CFML(input_item);
									if (IsDefined("Request._CMD_")) {
										if (IsQuery(Request._CMD_)) {
											cf_dump(Request._CMD_, 'Request._CMD_', false);
										} else {
											writeOutput('_CMD_ = [#_CMD_#]<br>');
										}
									}
								} else {
									if (NOT IsDefined("Request._CMD_")) {
										Request._CMD_ = '';
									}
									Request._CMD_ = ListAppend(Request._CMD_, _item, "&");
								}
							}
							writeOutput('<br>');
						}
					}
					if (isDefined("url.wddx")) {
						writeOutput('url.wddx = [#url.wddx#] [#URLDecode(url.wddx)#]<br>');
					} else if (isDefined("form.wddx")) {
						writeOutput('form.wddx = [#URLDecode(form.wddx)#]<br>');
					}
					writeOutput('END! #blue_formattedModuleName('cfinclude_AJAX_Begin.cfm')#<br>');
				}

				if (isDefined("url.wddx")) {
					if (Request.bool_canDebugHappen) {
						writeOutput('A. Exec WDDX2CFML<br>');
					}
					cf_wddx_WDDX2CFML(url.wddx);
				} else if (isDefined("form.wddx")) {
					if (Request.bool_canDebugHappen) {
						writeOutput('B. Exec WDDX2CFML<br>');
					}
					cf_wddx_WDDX2CFML(form.wddx);
				}
				
				if (Request.bool_canDebugHappen) {
					writeOutput('BEGIN: #blue_formattedModuleName('cfinclude_AJAX_Begin.cfm')#<br>');
					writeOutput('(IsDefined("Request._CMD_") = [#IsDefined("Request._CMD_")#]<br>');
					if (IsDefined("Request._CMD_")) {
						writeOutput('(IsQuery(Request._CMD_)) = [#(IsQuery(Request._CMD_))#]<br>');
						if (IsQuery(Request._CMD_)) {
							writeOutput(Request.primitiveCode.debugQueryInTable(Request._CMD_, "Request._CMD_"));
						} else {
							writeOutput('Request._CMD_ = [#Request._CMD_#]<br>');
						}
						writeOutput("END! #blue_formattedModuleName('cfinclude_AJAX_Begin.cfm')#<br>");
					}
				}
				_QUERY_STRING = Request._CMD_;
				// +++
			}
			
			if (IsDefined("_QUERY_STRING")) {
				aa = ListToArray(_QUERY_STRING, '&');
				aaN = ArrayLen(aa);
				for (i = 1; i lte aaN; i = i + 1) {
					QueryAddRow(Request.qryObj, 1);
					aaP = ListToArray(URLDecode(aa[i]), '=');
					QuerySetCell(Request.qryObj, 'NAME', aaP[1], Request.qryObj.recordCount);
					QuerySetCell(Request.qryObj, 'VAL', aaP[2], Request.qryObj.recordCount);
					Request.qryStruct[aaP[1]] = aaP[2];
				}
			}
		}

		function endAJAX() {
			Request.___jsName___ = 'qObj'; // this is the default javaScript global varName...
			if (IsDefined("Request.qryStruct.___jsName___")) {
				Request.___jsName___ = Request.qryStruct.___jsName___; // this is the user-defined javaScript global varName...
			}
			
			js_jsInitCode();
			js_jsCode_();

			Request._jsFinaleCode = '';
			if (UCASE(Request.qryStruct.callBack) neq 'UNDEFINED') {
				Request._jsFinaleCode = Request.qryStruct.callBack;
				openParen_i = Find('(', Request._jsFinaleCode);
				closeParen_i = Find(')', Request._jsFinaleCode, openParen_i);
				if ( (openParen_i eq 0) AND (closeParen_i eq 0) ) {
					Request._jsFinaleCode = Request._jsFinaleCode & '()';
				}
				if (Find(';', Request._jsFinaleCode) eq 0) {
					Request._jsFinaleCode = Request._jsFinaleCode & ';';
				}
			}

			if (Request.bool_using_xmlHttpRequest) {
				writeOutput('/* BOF CFAJAX */');
				writeOutput(Request._jsInitCode);
				writeOutput(ReplaceList(Request._jsCode_, Chr(13) & "," & Chr(10) & ",parent.", ",,"));
				writeOutput(Request._jsFinaleCode);
				writeOutput('/* EOF CFAJAX */');
			} else {
				// BEGIN: create a JavaScript object to store the query object
				_jsCode = Request._jsCode_;
				_jsCode = Request._jsInitCode & _jsCode & Request._jsFinaleCode;
				_jsCode = ReplaceList(_jsCode, Chr(13) & "," & Chr(10) & ",parent.", ",,");
				writeOutput('JS Code: (#Request._jsInitCode#) (length=#Len(_jsCode)#) <textarea cols="100" readonly rows="10" style="font-size: 10px; font-family: courier;">[#_jsCode#]</textarea><br>');
				// END! create a JavaScript object to store the query object

				writeOutput('<script language="JavaScript1.2" type="text/javascript">');
				writeOutput('#Request.parentKeyword#server_response_queue = [];');
				writeOutput('#Request.parentKeyword#server_response_queue.push("#_jsCode#");');
				writeOutput('if (#Request.parentKeyword#oAJAXEngine) {');
				writeOutput('#Request.parentKeyword#oAJAXEngine.receivePacket(#Request.parentKeyword#server_response_queue);');
				writeOutput('};');
				writeOutput('</script>');
				writeOutput('</body>');
				writeOutput('</html>');
			}
		}
	</cfscript>
</cfcomponent>
