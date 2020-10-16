<cfcomponent displayname="ajaxCode" output="Yes" extends="commonCode">
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
		
		function beginAJAX(aStruct) {
			var aa = -1;
			var aaN = -1;
			var i = -1;
			var aaP = -1;
			var _item = -1;
			var ii = -1;
			var _QUERY_STRING = '';
			var _CGI_QUERY_STRING = '';
			var _form_QUERY_STRING = '';

			if (aStruct.bool_using_xmlHttpRequest) {
				if (IsDefined("CGI.QUERY_STRING")) {
					_CGI_QUERY_STRING = URLDecode(CGI.QUERY_STRING);
				}
				if (IsDefined("form.QUERY_STRING")) {
					_form_QUERY_STRING = URLDecode(form.QUERY_STRING);
				}
		
				if (aStruct.bool_using_xmlHttpRequest_viaGET) {
					_QUERY_STRING = _CGI_QUERY_STRING;
				} else if (aStruct.bool_using_xmlHttpRequest_viaPOST) {
					_QUERY_STRING = _form_QUERY_STRING;
				}
			} else {
				// +++
				writeOutput('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
				writeOutput('<html>');
				writeOutput('<head>');
				writeOutput(Request.commonCode.html_nocache());

				if (aStruct.bool_canDebugHappen) {
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

				if (aStruct.bool_canDebugHappen) {
					cf_dump(URL, 'URL Scope', false);
					cf_dump(FORM, 'FORM Scope', false);
					cf_dump(CGI, 'CGI Scope', false);
					
					writeOutput("BEGIN: #Request.commonCode.blue_formattedModuleName('cfinclude_AJAX_Begin.cfm')#<br>");
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
								writeOutput('&nbsp;[#Request.commonCode._GetToken(_item, 1, "=")#]&nbsp;[#Request.commonCode._GetToken(_item, 2, "=")#]<br>');
								if (LCase(Request.commonCode._GetToken(_item, 1, "=")) eq LCase("wddx")) {
									writeOutput('0. Exec WDDX2CFML<br>');
									writeOutput('[#Request.commonCode._GetToken(_item, 2, "=")#]<br>');
									input_item = Request.commonCode._GetToken(_item, 2, "=");
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
					writeOutput('END! #Request.commonCode.blue_formattedModuleName('cfinclude_AJAX_Begin.cfm')#<br>');
				}

				if (isDefined("url.wddx")) {
					if (aStruct.bool_canDebugHappen) {
						writeOutput('A. Exec WDDX2CFML<br>');
					}
					cf_wddx_WDDX2CFML(url.wddx);
				} else if (isDefined("form.wddx")) {
					if (aStruct.bool_canDebugHappen) {
						writeOutput('B. Exec WDDX2CFML<br>');
					}
					cf_wddx_WDDX2CFML(form.wddx);
				}
				
				if (aStruct.bool_canDebugHappen) {
					writeOutput('BEGIN: #Request.commonCode.blue_formattedModuleName('cfinclude_AJAX_Begin.cfm')#<br>');
					writeOutput('(IsDefined("Request._CMD_") = [#IsDefined("Request._CMD_")#]<br>');
					if (IsDefined("Request._CMD_")) {
						writeOutput('(IsQuery(Request._CMD_)) = [#(IsQuery(Request._CMD_))#]<br>');
						if (IsQuery(Request._CMD_)) {
							writeOutput(Request.primitiveCode.debugQueryInTable(Request._CMD_, "Request._CMD_"));
						} else {
							writeOutput('Request._CMD_ = [#Request._CMD_#]<br>');
						}
						writeOutput("END! #Request.commonCode.blue_formattedModuleName('cfinclude_AJAX_Begin.cfm')#<br>");
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
	</cfscript>
</cfcomponent>
