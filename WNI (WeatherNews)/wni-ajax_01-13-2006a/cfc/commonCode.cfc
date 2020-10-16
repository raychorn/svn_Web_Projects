<cfcomponent displayname="commonCode" output="No" extends="primitiveCode">
	<cfinclude template="../includes/cfinclude_explainError.cfm">

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
	
		function filterQuotesForSQL(s) {
			return ReplaceNoCase(s, "'", "''", 'all');
		}
		
		function filterIntForSQL(s) {
			return reReplace(s, "[^0-9]", "", "all");
		}
	
		function filterQuotesForJS(s) {
			return ReplaceNoCase(s, "'", "\'", 'all');
		}
	
		function filterOutCr(s) {
			return ReplaceNoCase(s, Chr(13), "", 'all');
		}
	
		function filterDoubleQuotesForJS(s) {
			return ReplaceNoCase(s, '"', '\"', 'all');
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
			var _jsCode = '';

			_jsCode = _jsCode & '<scr' & 'ipt language="JavaScript1.2" type="text/javascript">' & Request.const_Cr;
			_jsCode = _jsCode & '<!--\/\/' & Request.const_Cr;
			
			return _jsCode;
		}
	
		function end_javascript() {
			var _jsCode = '';

			_jsCode = _jsCode & '\/\/-->' & Request.const_Cr;
			_jsCode = _jsCode & '</scr' & 'ipt>' & Request.const_Cr;

			return _jsCode;
		}

		function _jsapi_init_js_(qObjName, cols, _method) {
			var _jsCode = '';
			if (_method eq 1) {
				_jsCode = _jsCode & "if (#Request.parentKeyword#jsapi_init_js_#qObjName#) {" & Request.const_Cr;
				_jsCode = _jsCode & "#Request.parentKeyword#jsapi_init_js_#qObjName#('#cols#');" & Request.const_Cr;
				_jsCode = _jsCode & "} else {" & Request.const_Cr;
				_jsCode = _jsCode & "alert('Missing function named #Request.parentKeyword#jsapi_init_js_#qObjName#.');" & Request.const_Cr;
				_jsCode = _jsCode & "} " & Request.const_Cr;
			} else {
				_jsCode = _jsCode & "if (#Request.parentKeyword#jsapi_init_js_q) {" & Request.const_Cr;
				_jsCode = _jsCode & "#Request.parentKeyword#jsapi_init_js_q('#qObjName#','#cols#');" & Request.const_Cr;
				_jsCode = _jsCode & "} else {" & Request.const_Cr;
				_jsCode = _jsCode & "alert('Missing function named #Request.parentKeyword#jsapi_init_js_q().');" & Request.const_Cr;
				_jsCode = _jsCode & "} " & Request.const_Cr;
			}
			return _jsCode;
		}
	
		function _populate_JS_queryObj(q, qObjName, aFunc, bool_asJScode) {
			var i = -1;
			var k = -1;
			var jj = -1;
			var jj_i = -1;
			var jj_n = -1;
			var jj_vVal = '';
			var jj_s = '';
			var vVal = '';
			var js_vVal = '';
			var cName = '';
			var cols = '';
			var _jsCode = '';
			
			if (NOT IsBoolean(bool_asJScode)) {
				bool_asJScode = false;
			}
	
			if (IsQuery(q)) {
				cols = q.ColumnList;
				if (NOT bool_asJScode) _jsCode = _jsCode & begin_javascript();
				if (NOT bool_asJScode) {
					_jsCode = _jsCode & _jsapi_init_js_(qObjName, cols, 2);
				} else {
					_jsCode = _jsCode & qObjName & " = QueryObj.getInstance('#cols#');";
				}
				for (i = 1; i lte q.recordCount; i = i + 1) {
					_jsCode = _jsCode & "if (#Request.parentKeyword##qObjName# != null) { #Request.parentKeyword##qObjName#.QueryAddRow(); } " & Request.const_Cr;
					for (k = 1; k lte ListLen(cols, ','); k = k + 1) {
						cName = Trim(_GetToken(cols, k, ','));
						vVal = q[cName][i];
						if (IsCustomFunction(aFunc)) {
							vVal = Trim(aFunc(vVal));
						}
						vVal = URLEncodedFormat(vVal); // the consumer of the data has the responsability of decoding the data stream as-needed...
						js_vVal = "'#vVal#'";
	
						_jsCode = _jsCode & "if (#Request.parentKeyword##qObjName# != null) { #Request.parentKeyword##qObjName#.QuerySetCell('#cName#', #js_vVal#, #i#); } " & Request.const_Cr;
					}
					_jsCode = _jsCode & '' & Request.const_Cr;
				}
				if (NOT bool_asJScode) _jsCode = _jsCode & end_javascript();
			}
			return _jsCode;
		}
	
		function populate_JS_queryObj(q, qObjName, bool_asJScode) {
			return _populate_JS_queryObj(q, qObjName, _dummy_func, bool_asJScode);
		}

		function blue_formattedModuleName(_ex) {
			var _html = '<font color="blue"><b>' & _GetToken("#_ex#", ListLen("#_ex#", "/"), "/") & '</b></font>';
			
			return _html;
		}

		function initQryObj(col_list) {
			return QueryNew(col_list);
		}

		function indexForNamedQueryColumn(qQ, colName, findName) {
			var i = -1;
			var j = -1;

			if (IsQuery(qQ)) {
				for (j = 1; j lte qQ.recordCount; j = j + 1) {
					if (UCASE(qQ[colName][j]) eq UCASE(findName)) {
						i = j;
						break;
					}
				}
			}
			return i;
		}

		function _dummy_func(val) {
			return val;
		}

	</cfscript>
</cfcomponent>
