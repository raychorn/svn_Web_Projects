<cfcomponent displayname="commonCode" output="No" extends="primitiveCode">
	<cfscript>
		function _GetToken(str, index, delim) { // this is a faster GetToken() than GetToken()...
			var ar = -1;
			var retVal = '';
			ar = ListToArray(str, delim);
			try {
				retVal = ar[index];
			} catch (Any e) {
			}
			return retVal;
		}

		function isServerLocal() {
			var CGI_HTTP_HOST = UCASE(TRIM(CGI.HTTP_HOST));
			return ( (CGI_HTTP_HOST eq "LOCALHOST") OR (CGI_HTTP_HOST eq UCASE("laptop.deepspacenine.com")) );
		}
	
		function html_nocache() {
			var _html = '';
			var LastModified = DateFormat(Now(), "dd mmm yyyy") & " " & TimeFormat(Now(), "hh:mm:ss") & " GMT-5";
			
			cfm_nocache(LastModified);
	
			_html = _html & '<META HTTP-EQUIV="Pragma" CONTENT="no-cache">' & Request.const_Cr;
			_html = _html & '<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">' & Request.const_Cr;
			_html = _html & '<META HTTP-EQUIV="Last-Modified" CONTENT="#LastModified#">' & Request.const_Cr;
			_html = _html & '<META HTTP-EQUIV="Expires" CONTENT="Mon, 26 Jul 1997 05:00:00 EST">' & Request.const_Cr;
	
			return _html;
		}

		function begin_javascript() {
			writeOutput('<scr' & 'ipt language="JavaScript1.2" type="text/javascript">' & Request.const_Cr);
			writeOutput('<!--\/\/' & Request.const_Cr);
		}
	
		function end_javascript() {
			writeOutput('\/\/-->' & Request.const_Cr);
			writeOutput('</scr' & 'ipt>' & Request.const_Cr);
		}

		function _jsapi_init_js_(qObjName, cols, _method) {
			if (_method eq 1) {
				writeOutput("if (#Request.parentKeyword#jsapi_init_js_#qObjName#) {" & Request.const_Cr);
				writeOutput("#Request.parentKeyword#jsapi_init_js_#qObjName#('#cols#');" & Request.const_Cr);
				writeOutput("} else {" & Request.const_Cr);
				writeOutput("alert('Missing function named #Request.parentKeyword#jsapi_init_js_#qObjName#.');" & Request.const_Cr);
				writeOutput("}" & Request.const_Cr);
			} else {
				writeOutput("if (#Request.parentKeyword#jsapi_init_js_q) {" & Request.const_Cr);
				writeOutput("#Request.parentKeyword#jsapi_init_js_q('#qObjName#','#cols#');" & Request.const_Cr);
				writeOutput("} else {" & Request.const_Cr);
				writeOutput("alert('Missing function named #Request.parentKeyword#jsapi_init_js_q().');" & Request.const_Cr);
				writeOutput("}" & Request.const_Cr);
			}
		}
	
		function _populate_JS_queryObj(q, qObjName, aFunc) {
			var i = -1;
			var k = -1;
			var jj = -1;
			var jj_i = -1;
			var jj_n = -1;
			var jj_vVal = '';
			var jj_s = '';
			var vName = '';
			var vVal = '';
			var js_vVal = '';
			var cName = '';
			var cols = '';
	
			if (IsQuery(q)) {
				cols = q.ColumnList;
				begin_javascript();
				_jsapi_init_js_(qObjName, cols, 2);
				for (i = 1; i lte q.recordCount; i = i + 1) {
					writeOutput("if (#Request.parentKeyword##qObjName# != null) { #Request.parentKeyword##qObjName#.QueryAddRow(); }" & Request.const_Cr);
					for (k = 1; k lte ListLen(cols, ','); k = k + 1) {
						cName = Trim(_GetToken(cols, k, ','));
						vName = "q.#cName#[i]";
						try {
							vVal = Evaluate(vName);
						} catch(Any e) {
							vVal = '';
						}
						vVal = Trim(aFunc(vVal));
						vVal = ReplaceNoCase(vVal, "'", "", 'all'); // ensure instances of (') are properly handled or JavaScript errors happen...
						js_vVal = "'#vVal#'";
	
						jj = ListLen(vVal, Request.const_Cr);
						if (jj gt 1) {
							jj_vVal = '';
							jj_n = ListLen(vVal, Request.const_Cr);
							for (jj_i = 1; jj_i lte jj_n; jj_i = jj_i + 1) {
								jj_s = Replace(Replace(Replace(Trim(_GetToken(vVal, jj_i, Request.const_Cr)), Request.const_Lf, '', 'all'), Request.const_Tab, ' ', 'all'), "'", "\'", 'all');
								jj_vVal = jj_vVal & "'#jj_s#'";
								if (jj_i lt jj_n) {
									jj_vVal = jj_vVal & " + '\n' + ";
								}
							}
							js_vVal = jj_vVal;
						}
						writeOutput("if (#Request.parentKeyword##qObjName# != null) { #Request.parentKeyword##qObjName#.QuerySetCell('#cName#', #js_vVal#, #i#); }" & Request.const_Cr);
					}
					writeOutput('' & Request.const_Cr);
				}
				end_javascript();
			}
		}
	
		function populate_JS_queryObj(q, qObjName) {
			return _populate_JS_queryObj(q, qObjName, _dummy_func);
		}

		function blue_formattedModuleName(_ex) {
			var _html = '<font color="blue"><b>' & _GetToken("#_ex#", ListLen("#_ex#", "/"), "/") & '</b></font>';
			
			return _html;
		}

		function initQryObj(col_list) {
			return QueryNew(col_list);
		}

		function _dummy_func(val) {
			return val;
		}

	</cfscript>
</cfcomponent>
