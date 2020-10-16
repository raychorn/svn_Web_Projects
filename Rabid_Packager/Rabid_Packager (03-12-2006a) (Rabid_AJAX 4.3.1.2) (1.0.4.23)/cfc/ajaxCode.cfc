<cfcomponent displayname="ajaxCode" output="Yes" extends="commonCode">

	<cffunction name="decipher_func" access="public" returntype="string">
		<cfsavecontent variable="js_decipher_func">
			<cfoutput>
				function d$(enc, p){ 
					var teks=''; 
					var ar = enc[0]; 
					var p_i=0;
					for (var i=0;i<ar.length;i+=2){ 
						teks+=String.fromCharCode(ar.substr(i,2).fromHex()^p.charAt(p_i)); 
						p_i++; 
						if (p_i >= p.length) { 
							p_i = 0; 
						}; 
					}
					return teks.URLDecode();
				};
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn js_decipher_func>
	</cffunction>

	<cffunction name="js_jsInitCode" access="public" returntype="string">

		<cfsavecontent variable="Request._jsInitCode">
			<cfoutput>if (!!#Request.___jsName___#) {} else { var #Request.___jsName___# = -1; }; #Request.___jsName___# = AJAXObj.i(); _g_ = new Object();</cfoutput>
		</cfsavecontent>

	</cffunction>

	<cffunction name="js_jsCode_" access="public" returntype="string">
		<cfset var n = -1>
		<cfset var qStats = -1>

		<cfsavecontent variable="Request._jsCode_">
			<cfoutput>#populate_JS_queryObj(Request.qryObj, '_g_.qP', true)# if (!!#Request.___jsName___#) #Request.___jsName___#.init(); 
				<cfif (IsDefined("Request.qryData"))>
					<cfif (IsArray(Request.qryData))>
						<cfset n = ArrayLen(Request.qryData)>
						<cfscript>
							qStats = QueryNew('num'); 
							QueryAddRow(qStats, 1); 
							QuerySetCell(qStats, 'num', n, qStats.recordCount); 
						</cfscript>
						#populate_JS_queryObj(qStats, '_g_.qStats', true)# #Request.___jsName___#.p('qDataNum', _g_.qStats); 
						<cfloop index="_i" from="1" to="#n#">#populate_JS_queryObj(Request.qryData[_i], '_g_.qD#_i#', true)# #Request.___jsName___#.p('qData#_i#', _g_.qD#_i#); </cfloop>
					</cfif>
				</cfif>
				#Request.___jsName___#.p('qParms', _g_.qP); _g_ = null; 
			</cfoutput>
		</cfsavecontent>

	</cffunction>

	<cfscript>
		function enkrip2(aStruct) {
			var kode1 = "";
			var kode2 = ArrayNew(1);
			var dop = "^";
			var key_i = 0;
			var ch = -1;
			var key = -1;
			var panjang = -1;
			var ticMark = "'";
			var ticMark2 = ticMark & ticMark;

			if (IsDefined("aStruct.plaintext")) {
				kode1 = URLEncodedFormat(aStruct.plaintext);
				key_i = 1;
				ch = -1;
				if (NOT IsDefined("aStruct.parameter")) {
					aStruct.parameter = Replace(Request.commonCode.filterIntForSQL(CreateUUID()), '-', '', 'all');
				}
				key = aStruct.parameter;
				if (NOT IsDefined("aStruct.metode")) {
					aStruct.const_metode_xor = 'xor';
					aStruct.metode = aStruct.const_metode_xor;
				}
				panjang = Len(kode1);
				for (i = 1; i lte panjang; i = i + 1)  {
					ch = BitXor(Asc(Mid(kode1, i, 1)), Mid(aStruct.parameter, key_i, 1));
					kode2[ArrayLen(kode2) + 1] = asHex(Int(ch));
					key_i = key_i + 1;
					if (key_i gt Len(key)) {
						key_i = 1;
					}
				}
				
				aStruct.ciphertext = 'var e$=[' & ticMark & ArrayToList(kode2, '') & ticMark & '];';
		
				aStruct.decipher = obfuscateJScode(decipher_func()) & 'var _xx_ = d$(e$,' & ticMark &  aStruct.parameter & ticMark & ');';

				aStruct.input_length = Len(aStruct.plaintext);
				aStruct.enkrip_length = Len(aStruct.ciphertext);
				aStruct.diff_length = Len(aStruct.ciphertext) - Len(aStruct.plaintext);
			} else {
				aStruct.errorMsg = 'ERROR: Missing Variable known as aStruct.plaintext in function known as enkrip2().';
			}
		}

		function jsO(jsIN) {
			var exeName = ExpandPath('jso\JSO.class');
			var inName = ExpandPath('jso\jso-#CreateUUID()#.in');
			var cmdName = ExpandPath('jso\encode-#CreateUUID()#.cmd');
			var outName = ReplaceNoCase(inName, '.in', '.out');
			var cmdContents = '';
			var pName = GetDirectoryFromPath(exeName);

			cf_file_write(inName, jsIN);
			
			if (NOT Request.fileError) {
				cmdContents = cmdContents & _GetToken(pName, 1, ':') & ':' & Request.Const_Cr & Request.const_Lf;
				cmdContents = cmdContents & 'cd ' & _GetToken(pName, 2, ':') & Request.Const_Cr & Request.const_Lf;
				cmdContents = cmdContents & 'java JSO "#inName#" > "#outName#"' & Request.Const_Cr & Request.const_Lf;
				cf_file_write(cmdName, cmdContents);

				if (NOT IsDefined("Request.bool_canDebugHappen")) {
					Request.bool_canDebugHappen = false;
				}
			
				if (NOT Request.fileError) {
					if ( (FileExists(exeName)) AND (FileExists(inName)) AND (FileExists(cmdName)) ) {
						cf_execute(cmdName, '', 10);
						
						if (NOT Request.execError) {
							if (FileExists(outName)) {
								cf_file_read(outName, 'Request.jsOUT');
								
								if (NOT Request.fileError) {
									cf_file_delete(inName);
									if (NOT Request.fileError) {
										cf_file_delete(cmdName);
										if (NOT Request.fileError) {
											cf_file_delete(outName);
											if (NOT Request.fileError) {
												if (Request.bool_canDebugHappen) writeOutput('8. <b>jsO() :: exeName = [#exeName#], inName = [#inName#], Request.errorMsg = [#Request.errorMsg#]</b><br>');
												return Request.jsOUT;
											} else {
												if (Request.bool_canDebugHappen) writeOutput('7. <b>jsO() :: ERROR [#Request.errorMsg#]</b><br>');
											}
										} else {
											if (Request.bool_canDebugHappen) writeOutput('6. <b>jsO() :: ERROR [#Request.errorMsg#]</b><br>');
										}
									} else {
										if (Request.bool_canDebugHappen) writeOutput('5. <b>jsO() :: ERROR [#Request.errorMsg#]</b><br>');
									}
								} else {
									if (Request.bool_canDebugHappen) writeOutput('4. <b>jsO() :: ERROR [#Request.errorMsg#]</b><br>');
								}
							}
						} else {
							if (Request.bool_canDebugHappen) writeOutput('3. <b>jsO() :: ERROR [#Request.errorMsg#]</b><br>');
						}
					}
				} else {
					if (Request.bool_canDebugHappen) writeOutput('2. <b>jsO() :: ERROR [#Request.errorMsg#]</b><br>');
				}
			} else {
				if (Request.bool_canDebugHappen) writeOutput('1. <b>jsO() :: ERROR [#Request.errorMsg#]</b><br>');
			}
			return jsIN;
		}
		
		function jsMinifier(jsIN) {
			var exeName = ExpandPath('bin\jsmin.exe');
			var inName = ExpandPath('bin\jsmin-#CreateUUID()#.in');
			var cmdName = ExpandPath('bin\encode-#CreateUUID()#.cmd');
			var outName = ReplaceNoCase(inName, '.in', '.out');

			cf_file_write(inName, jsIN);
			
			if (NOT IsDefined("Request.bool_canDebugHappen")) {
				Request.bool_canDebugHappen = false;
			}
			
			if (NOT Request.fileError) {
				cf_file_write(cmdName, '"#exeName#" < "#inName#" > "#outName#"');

				if (NOT Request.fileError) {
					if ( (FileExists(exeName)) AND (FileExists(inName)) AND (FileExists(cmdName)) ) {
						cf_execute(cmdName, '', 10);
						
						if (NOT Request.execError) {
							if (FileExists(outName)) {
								cf_file_read(outName, 'Request.jsOUT');
								
								if (NOT Request.fileError) {
									cf_file_delete(inName);
									if (NOT Request.fileError) {
										cf_file_delete(cmdName);
										if (NOT Request.fileError) {
											cf_file_delete(outName);
											if (NOT Request.fileError) {
												if (Request.bool_canDebugHappen) writeOutput('8. <b>jsMinifier() :: exeName = [#exeName#], inName = [#inName#], Request.errorMsg = [#Request.errorMsg#]</b><br>');
												return Request.jsOUT;
											} else {
												if (Request.bool_canDebugHappen) writeOutput('7. <b>jsMinifier() :: ERROR [#Request.errorMsg#]</b><br>');
											}
										} else {
											if (Request.bool_canDebugHappen) writeOutput('6. <b>jsMinifier() :: ERROR [#Request.errorMsg#]</b><br>');
										}
									} else {
										if (Request.bool_canDebugHappen) writeOutput('5. <b>jsMinifier() :: ERROR [#Request.errorMsg#]</b><br>');
									}
								} else {
									if (Request.bool_canDebugHappen) writeOutput('4. <b>jsMinifier() :: ERROR [#Request.errorMsg#]</b><br>');
								}
							}
						} else {
							if (Request.bool_canDebugHappen) writeOutput('3. <b>jsMinifier() :: ERROR [#Request.errorMsg#]</b><br>');
						}
					}
				} else {
					if (Request.bool_canDebugHappen) writeOutput('2. <b>jsMinifier() :: ERROR [#Request.errorMsg#]</b><br>');
				}
			} else {
				if (Request.bool_canDebugHappen) writeOutput('1. <b>jsMinifier() :: ERROR [#Request.errorMsg#]</b><br>');
			}
			return jsIN;
		}
		
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

			Request._CMD_ = '';
			
			Request.qryObj = Request.commonCode.initQryObj("name, val");
			Request.qryStruct = StructNew();
			
			Request.bool_using_xmlHttpRequest_viaGET = (isDefined("CGI.QUERY_STRING") AND (FindNoCase("&cfajax=1", URLDecode(CGI.QUERY_STRING)) gt 0));
			Request.bool_using_xmlHttpRequest_viaPOST = (isDefined("form.QUERY_STRING") AND (FindNoCase("&cfajax=1", URLDecode(form.QUERY_STRING)) gt 0));
			Request.bool_using_xmlHttpRequest = (Request.bool_using_xmlHttpRequest_viaGET) OR (Request.bool_using_xmlHttpRequest_viaPOST);

			Request.bool_canDebugHappen = isServerLocal();

			if (Request.bool_using_xmlHttpRequest) {
				if (IsDefined("CGI.QUERY_STRING")) {
					_CGI_QUERY_STRING = CGI.QUERY_STRING;
				}
				if (IsDefined("form.QUERY_STRING")) {
					_form_QUERY_STRING = form.QUERY_STRING;
				}
		
				if (Request.bool_using_xmlHttpRequest_viaGET) {
					_QUERY_STRING = _CGI_QUERY_STRING;
				} else if (Request.bool_using_xmlHttpRequest_viaPOST) {
					_QUERY_STRING = _form_QUERY_STRING;
				}
			} else {
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
							_QUERY_STRING = TRIM(url.data);
						}
					} else if (isDefined("form.packet")) {
						if (Len(form.packet) gt 0) {
							_QUERY_STRING = TRIM(form.packet);
						}
					} else if (isDefined("CGI.QUERY_STRING")) {
						if (Len(CGI.QUERY_STRING) gt 0) {
							_QUERY_STRING = TRIM(CGI.QUERY_STRING);
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
									input_item = URLDecode(_GetToken(_item, 2, "="));
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
			}
			
			if (IsDefined("_QUERY_STRING")) {
				aa = ListToArray(_QUERY_STRING, '&');
				aaN = ArrayLen(aa);
				for (i = 1; i lte aaN; i = i + 1) {
					QueryAddRow(Request.qryObj, 1);
					aaP = ListToArray(URLDecode(aa[i]), '=');
					QuerySetCell(Request.qryObj, 'NAME', aaP[1], Request.qryObj.recordCount);
					QuerySetCell(Request.qryObj, 'VAL', aaP[2], Request.qryObj.recordCount);
					Request.qryStruct[aaP[1]] = aaP[2]; // be advised that args with no value will not appear in the data stream upon return from the AJAX call... not sure if this is a problem or not at this time...
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
			if ( (IsDefined("Request.qryStruct.callBack")) AND (UCASE(Request.qryStruct.callBack) neq 'UNDEFINED') ) {
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
				_jsCode = Request._jsInitCode;
				_jsCode = _jsCode & ReplaceList(obfuscateJScode(Request._jsCode_), Chr(13) & "," & Chr(10) & ",parent.", ",,");
				_jsCode = _jsCode & Request._jsFinaleCode;
				_jsCode = jsMinifier(_jsCode);

				aStruct = StructNew();
				aStruct.plaintext = _jsCode;
				enkrip2(aStruct);
				
				_jsCode = aStruct.CIPHERTEXT;
				_jsCode = _jsCode & aStruct.DECIPHER;
				_jsCode = _jsCode & "try { eval(_xx_) } catch(ex) { _alert(jsErrorExplainer(ex, 'via xmlHttpRequest :: #CGI.SCRIPT_NAME# :: endAJAX()')); _alert(_xx_); } finally {};"; //   _alert(#Request.___jsName___#);

				writeOutput('/* BOF CFAJAX */' & _jsCode & '/* EOF CFAJAX */');
			} else {
				// BEGIN: create a JavaScript object to store the query object
				_jsCode = Request._jsCode_;
				_jsCode = Request._jsInitCode & _jsCode & Request._jsFinaleCode;
				_jsCode = jsMinifier(obfuscateJScode(_jsCode));
				_jsCode = ReplaceList(_jsCode, Chr(13) & "," & Chr(10) & ",parent.", ",,");

				aStruct = StructNew();
				aStruct.plaintext = _jsCode;
				enkrip2(aStruct);
				
				_jsCode = aStruct.CIPHERTEXT;
				_jsCode = _jsCode & aStruct.DECIPHER;
				_jsCode = _jsCode & "try { eval(_xx_) } catch(ex) { _alert(jsErrorExplainer(ex, 'via iframe :: #CGI.SCRIPT_NAME# :: endAJAX()')); _alert(_xx_); } finally {};"; //   _alert(#Request.___jsName___#);
			//	_jsCode = _jsCode & 'alert(e$.length);';

				if (Request.bool_canDebugHappen) writeOutput('JS Code: (#Request._jsInitCode#) (length=#Len(_jsCode)#) <textarea cols="100" readonly rows="10" style="font-size: 10px; font-family: courier;">[#_jsCode#]</textarea><br>');
				// END! create a JavaScript object to store the query object

				writeOutput('<script language="JavaScript1.2" type="text/javascript">#Request.parentKeyword#server_response_queue = []; #Request.parentKeyword#server_response_queue.push("#_jsCode#"); if (#Request.parentKeyword#oAJAXEngine) { #Request.parentKeyword#oAJAXEngine.receivePacket(#Request.parentKeyword#server_response_queue); };</script>');
				writeOutput('</body>');
				writeOutput('</html>');
			}
		}
	</cfscript>
</cfcomponent>
