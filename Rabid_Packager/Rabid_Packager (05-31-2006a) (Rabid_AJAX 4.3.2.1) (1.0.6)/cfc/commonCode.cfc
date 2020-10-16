<cfcomponent displayname="commonCode" output="No" extends="primitiveCode">
	<cfinclude template="../includes/cfinclude_explainError.cfm">

	<cfscript>
		this.HEX = "0123456789ABCDEF";
		this.hexMask = BitSHLN(255, 24);  // FF000000
		
		this.struct_CFtoJS_variables = StructNew();

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

		function StructExplainer(st, _bool_asHTML) {
			var e = -1;
			var v = -1;
			var i = -1;
			var sMisc = -1;
			var _content = '';
			var sCurrent = -1;
			var sMiscList = -1;
			var nTagStack = -1;
			var bool_isError = -1;
			var content_specialList = '';
			var _StackTraceSymbol = '<StackTrace>';
			
			if (NOT IsBoolean(_bool_asHTML)) {
				_bool_asHTML = false;
			}
			
			if (_bool_asHTML) {
				_content = _content & '<UL>';
			}
			try {
				for (e in st) {
					if (NOT IsCustomFunction(st)) {
						try {
							v = st[e];
						} catch (Any ee) {
							v = '--- ERROR --';
						}
					} else {
						v = '--- FUNCTION --';
					}
					if (IsSimpleValue(v)) {
						if (NOT _bool_asHTML) {
							_content = _content & '#e#=#v#,' & Chr(13);
						} else {
							_content = _content & '<li><b>#e#</b>&nbsp;#v#</li>';
						}
					} else {
						try {
							if (NOT _bool_asHTML) {
								_content = _content & '#e#=#StructExplainer(v, _bool_asHTML)#,' & Chr(13);
							} else {
								_content = _content & '<li><b>#e#</b>&nbsp;#StructExplainer(v, _bool_asHTML)#</li>';
							}
						} catch (Any e4) {
						}
					}
				}
			} catch (Any ee) {
			}
			_content = _content & content_specialList;
			if (_bool_asHTML) {
				_content = _content & '</UL>';
			}
			return _content;
		}
	
		function QueryStats(qQ) {
			var bytes = 0;
			var colsAR = -1;
			var nAR = -1;
			var i = -1;
			var k = -1;
			
			if (IsQuery(qQ)) {
				colsAR = ListToArray(qQ.columnList, ',');
				nAR = ArrayLen(colsAR);
				for (i = 1; i lte qQ.recordCount; i = i + 1) {
					for (k = 1; k lte nAR; k = k + 1) {
						bytes = bytes + Len(qQ[colsAR[k]][i]);
					}
				}
			}
			return bytes;
		}

		function listToSQLList(aList) {
			var i = -1;
			var n = ListLen(aList, ',');
			for (i = 1; i lte n; i = i + 1) {
				aList = ListSetAt(aList, i, "'" & ListGetAt(aList, i, ',') & "'", ',');
			}
			return aList;
		}
		
		function countInstancesOfInList(aTok, aList, aDelim) {
			var i = -1;
			var cnt = 0;
			var ar = ListToArray(aList, aDelim);
			var n = ArrayLen(ar);
			for (i = 1; i lte n; i = i + 1) {
				if (FindNoCase(aTok, ar[i]) gt 0) {
					cnt = cnt + 1;
				}
			}
			return cnt;
		}
		
		function dropFirstInstanceLikeFromList(aTok, aList, aDelim) {
			var i = -1;
			var ar = ListToArray(aList, aDelim);
			var n = ArrayLen(ar);
			for (i = 1; i lte n; i = i + 1) {
				if (FindNoCase(aTok, ar[i]) gt 0) {
					aList = ListDeleteAt(aList, i, aDelim);
					break;
				}
			}
			return aList;
		}
		
		function dropAllInstancesLikeExceptLast(aTok, aList, aDelim) {
			var i = -1;
			var iCnt = countInstancesOfInList(aTok, aList, aDelim);
			if (iCnt gt 1) {
				for (i = iCnt - 1; i gte 1; i = i - 1) {
					aList = dropFirstInstanceLikeFromList(aTok, aList, aDelim);
				}
			}
			return aList;
		}
				
		function _dropAllInstancesLike(aTok, aList, aDelim, minCount) {
			var i = -1;
			var iCnt = countInstancesOfInList(aTok, aList, aDelim);
			if (NOT IsNumeric(minCount)) {
				minCount = 0;
			}
			if (iCnt gt minCount) {
				for (i = iCnt; i gte minCount; i = i - 1) {
					aList = dropFirstInstanceLikeFromList(aTok, aList, aDelim);
				}
			}
			return aList;
		}
		
		function dropAllInstancesLike(aTok, aList, aDelim) {
			return _dropAllInstancesLike(aTok, aList, aDelim, 1);
		}
		
		function dropAllNonUniqueInstancesExceptLast(aList, aDelim) {
			var i = -1;
			var aUniqueList = '';
			var ar_List = ListToArray(aList, aDelim);
			var n = ArrayLen(ar_List);
			var ar_UniqueList = -1;
			var nUniqueList = -1;
			for (i = 1; i lte n; i = i + 1) {
				if (ListFindNoCase(aUniqueList, ar_List[i], aDelim) eq 0) {
					aUniqueList = ListAppend(aUniqueList, ar_List[i], aDelim);
				}
			}
			ar_UniqueList = ListToArray(aUniqueList, aDelim);
			nUniqueList = ArrayLen(ar_UniqueList);
			for (i = 1; i lte nUniqueList; i = i + 1) {
				aList = dropAllInstancesLikeExceptLast(ListFirst(ar_UniqueList[i], '=') & '=', aList, '&');
			}
			return aList;
		}
				
		function dropURLScopeFromURL(aURL) {
			var ar = ListToArray(aURL, '?');
			var ar2 = -1;
			var i = -1;
			var j = -1;
			var n2 = -1;
			var ar3 = -1;
			if (ArrayLen(ar) eq 2) {
				ar2 = ListToArray(ar[2], '&');
				n2 = ArrayLen(ar2);
				for (i = 1; i lte n2; i = i + 1) {
					ar3 = ListToArray(ar2[i], '=');
					try {
						if (Len(URL[ar3[1]]) gt 0) {
							ar2[i] = '';
						}
					} catch (Any e) {
					}
				}
				for (j = n2; j gte 1; j = j - 1) {
					if (Len(ar2[j]) eq 0) {
						ArrayDeleteAt( ar2, j);
					}
				}
				ar[2] = ArrayToList(ar2, '&');
			}
			return ArrayToList(ar, '?');
		}

		function isServerLocal() {
			var CGI_HTTP_HOST = UCASE(TRIM(CGI.HTTP_HOST));
			return ( (CGI_HTTP_HOST eq "LOCALHOST") OR (CGI_HTTP_HOST eq UCASE("laptop.halsmalltalker.com")) );
		}
	
		function filterQuotesForSQL(s) {
			return ReplaceNoCase(s, "'", "''", 'all');
		}
		
		function filterIntForSQL(s) {
			var t = reReplace(s, "(\+|-)?[0-9]+(\.[0-9]*)?", "", "all"); // flter-out numerics thus leaving non-numerics...
			var ar = ArrayNew(1);
			var ar2 = ArrayNew(1);
			var i = -1;
			for (i = 1; i lte Len(t); i = i + 1) {
				ar[ArrayLen(ar) + 1] = Mid(t, i, 1);
				ar2[ArrayLen(ar2) + 1] = '';
			}
			return ReplaceList(s, ArrayToList(ar, ','), ArrayToList(ar2, ','));
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
			
			cfm_nocache();
	
			_html = _html & '<META HTTP-EQUIV="Pragma" CONTENT="no-cache">' & Request.const_Cr;
			_html = _html & '<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">' & Request.const_Cr;
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

		function _AJAX_init_js_(qObjName, cols, _method) {
			var _jsCode = '';
			if (_method eq 1) {
				_jsCode = _jsCode & "if (#Request.parentKeyword#AJAX_init_js_#qObjName#) {" & Request.const_Cr;
				_jsCode = _jsCode & "#Request.parentKeyword#AJAX_init_js_#qObjName#('#cols#');" & Request.const_Cr;
				_jsCode = _jsCode & "} else {" & Request.const_Cr;
				_jsCode = _jsCode & "alert('Missing function named #Request.parentKeyword#AJAX_init_js_#qObjName#.');" & Request.const_Cr;
				_jsCode = _jsCode & "} " & Request.const_Cr;
			} else {
				_jsCode = _jsCode & "if (#Request.parentKeyword#AJAX_init_js_q) {" & Request.const_Cr;
				_jsCode = _jsCode & "#Request.parentKeyword#initJSQ('#qObjName#','#cols#');" & Request.const_Cr;
				_jsCode = _jsCode & "} else {" & Request.const_Cr;
				_jsCode = _jsCode & "alert('Missing function named #Request.parentKeyword#initJSQ().');" & Request.const_Cr;
				_jsCode = _jsCode & "} " & Request.const_Cr;
			}
			return _jsCode;
		}
	
		function _populate_JS_queryObj(q, qObjName, aFunc, bool_asJScode) {
			var i = -1;
			var k = -1;
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
					_jsCode = _jsCode & _AJAX_init_js_(qObjName, cols, 2);
				} else {
					_jsCode = _jsCode & qObjName & " = QueryObj.i('#cols#');";
				}
				for (i = 1; i lte q.recordCount; i = i + 1) {
					_jsCode = _jsCode & "if (!!#Request.parentKeyword##qObjName#) { #Request.parentKeyword##qObjName#.qar(); " & Request.const_Cr;
					for (k = 1; k lte ListLen(cols, ','); k = k + 1) {
						cName = Trim(_GetToken(cols, k, ','));
						vVal = q[cName][i];
						if (IsCustomFunction(aFunc)) {
							vVal = Trim(aFunc(vVal));
						}
						vVal = URLEncodedFormat(vVal); // the consumer of the data has the responsability of decoding the data stream as-needed...
						js_vVal = "'#vVal#'";
	
						_jsCode = _jsCode & "#Request.parentKeyword##qObjName#.qsc('#cName#', #js_vVal#, #i#); " & Request.const_Cr;
					}
					_jsCode = _jsCode & ' }; ' & Request.const_Cr;
				}
				if (NOT bool_asJScode) _jsCode = _jsCode & end_javascript();
			}
			return _jsCode;
		}
	
		function _populate_JS_queryObjBulk(q, qObjName, aFunc, bool_asJScode) {
			var i = -1;
			var k = -1;
			var vVal = '';
			var js_vVal = '';
			var cName = '';
			var cols = '';
			var colsCopy = '';
			var kN = -1;
			var _jsCode = '';
			var cAR = -1;
			var n = -1;
			var js_vValAR = StructNew();
			var delayedErrorMsg = '';
			
			if (NOT IsBoolean(bool_asJScode)) {
				bool_asJScode = false;
			}

			Request.jsQueryObjError = false;
			Request.jsQueryObjErrorMsg = '';
			try {
				if (IsQuery(q)) {
					cols = q.ColumnList;
					if (NOT bool_asJScode) _jsCode = _jsCode & begin_javascript();
					if (NOT bool_asJScode) {
						_jsCode = _jsCode & _AJAX_init_js_(qObjName, cols, 2);
					} else {
						_jsCode = _jsCode & qObjName & " = QueryObj.i('#cols#');";
					}
					kN = ListLen(cols, ',');
					for (k = 1; k lte kN; k = k + 1) {
						cName = Trim(_GetToken(cols, k, ','));
						if (ListFindNoCase(colsCopy, cName, ',') eq 0) {
							colsCopy = ListAppend(colsCopy, cName, ',');
							js_vValAR[cName] = ArrayNew(1);
						} else {
							Request.jsQueryObjError = true;
							delayedErrorMsg = ListAppend(delayedErrorMsg, cName, ',');
						}
					}
					if (Len(delayedErrorMsg) gt 0) {
						Request.jsQueryObjErrorMsg = Request.jsQueryObjErrorMsg & 'WARNING: The Query being passed back from the AJAX Server has a duplicate column(s) named "#delayedErrorMsg#" - kindly correct this problem by adjusting the SQL Code that generated this condition because data is being lost due to this condition.' & Chr(13);
					}
					cols = colsCopy;
					kN = ListLen(cols, ',');
					for (i = 1; i lte q.recordCount; i = i + 1) {
						for (k = 1; k lte kN; k = k + 1) {
							cName = Trim(_GetToken(cols, k, ','));
							vVal = q[cName][i];
							if (IsCustomFunction(aFunc)) {
								vVal = Trim(aFunc(vVal));
							}
							vVal = URLEncodedFormat(vVal); // the consumer of the data has the responsability of decoding the data stream as-needed...
							js_vVal = "'#vVal#'";
							js_vValAR[cName][ArrayLen(js_vValAR[cName]) + 1] = js_vVal;
						}
					}
					for (k = 1; k lte kN; k = k + 1) {
						cName = Trim(_GetToken(cols, k, ','));
						js_vValAR[cName] = '[' & ArrayToList(js_vValAR[cName], ',') & ']';
						_jsCode = _jsCode & "#Request.parentKeyword##qObjName#.qsc$('#cName#', #js_vValAR[cName]#, 1); " & Request.const_Cr;
					}
					if (NOT bool_asJScode) _jsCode = _jsCode & end_javascript();
				}
			} catch (Any e) {
				Request.jsQueryObjError = true;
				cAR = ListToArray(Replace(explainErrorWithStack(e, false), Chr(13), '', 'all'), Chr(10));
				n = ArrayLen(cAR);
				for (i = 1; i lte n; i = i + 1) {
					Request.jsQueryObjErrorMsg = Request.jsQueryObjErrorMsg & filterQuotesForJS(cAR[i]) & Chr(13);
				}
			}
			return _jsCode;
		}
	
		function populate_JS_queryObjBulk(q, qObjName, bool_asJScode) {
			return _populate_JS_queryObjBulk(q, qObjName, _dummy_func, bool_asJScode);
		}

		function _populate_JS_queryObjBulk2(q, qObjName, aFunc, bool_asJScode) {
			var i = -1;
			var k = -1;
			var vVal = '';
			var js_vVal = '';
			var cName = '';
			var cols = '';
			var colsCopy = '';
			var kN = -1;
			var _jsCode = '';
			var cAR = -1;
			var n = -1;
			var js_vValAR = StructNew();
			var delayedErrorMsg = '';
			
			if (NOT IsBoolean(bool_asJScode)) {
				bool_asJScode = false;
			}

			Request.jsQueryObjError = false;
			Request.jsQueryObjErrorMsg = '';
			try {
				if (IsQuery(q)) {
					cols = q.ColumnList;
					if (NOT bool_asJScode) _jsCode = _jsCode & begin_javascript();
					if (NOT bool_asJScode) {
						_jsCode = _jsCode & _AJAX_init_js_(qObjName, cols, 2);
					} else {
						_jsCode = _jsCode & qObjName & " = QueryObj.i$(['#cols#'";
					}
					kN = ListLen(cols, ',');
					for (k = 1; k lte kN; k = k + 1) {
						cName = Trim(_GetToken(cols, k, ','));
						if (ListFindNoCase(colsCopy, cName, ',') eq 0) {
							colsCopy = ListAppend(colsCopy, cName, ',');
							js_vValAR[cName] = ArrayNew(1);
						} else {
							Request.jsQueryObjError = true;
							delayedErrorMsg = ListAppend(delayedErrorMsg, cName, ',');
						}
					}
					if (Len(delayedErrorMsg) gt 0) {
						Request.jsQueryObjErrorMsg = Request.jsQueryObjErrorMsg & 'WARNING: The Query being passed back from the AJAX Server has a duplicate column(s) named "#delayedErrorMsg#" - kindly correct this problem by adjusting the SQL Code that generated this condition because data is being lost due to this condition.' & Chr(13);
					}
					cols = colsCopy;
					kN = ListLen(cols, ',');
					for (i = 1; i lte q.recordCount; i = i + 1) {
						for (k = 1; k lte kN; k = k + 1) {
							cName = Trim(_GetToken(cols, k, ','));
							vVal = q[cName][i];
							if (IsCustomFunction(aFunc)) {
								vVal = Trim(aFunc(vVal));
							}
							vVal = URLEncodedFormat(vVal); // the consumer of the data has the responsability of decoding the data stream as-needed...
							js_vVal = "'#vVal#'";
							js_vValAR[cName][ArrayLen(js_vValAR[cName]) + 1] = js_vVal;
						}
					}
					for (k = 1; k lte kN; k = k + 1) {
						cName = Trim(_GetToken(cols, k, ','));
						js_vValAR[cName] = '[' & ArrayToList(js_vValAR[cName], ',') & ']';
						_jsCode = _jsCode & ",'#cName#', #js_vValAR[cName]#";
					}
					if (NOT bool_asJScode) {
						_jsCode = _jsCode & end_javascript();
					} else {
						_jsCode = _jsCode & "]);" & Request.const_Cr;
					}
				}
			} catch (Any e) {
				Request.jsQueryObjError = true;
				cAR = ListToArray(Replace(explainErrorWithStack(e, false), Chr(13), '', 'all'), Chr(10));
				n = ArrayLen(cAR);
				for (i = 1; i lte n; i = i + 1) {
					Request.jsQueryObjErrorMsg = Request.jsQueryObjErrorMsg & filterQuotesForJS(cAR[i]) & Chr(13);
				}
			}
			return _jsCode;
		}
	
		function populate_JS_queryObj(q, qObjName, bool_asJScode) {
		//	return _populate_JS_queryObj(q, qObjName, _dummy_func, bool_asJScode);
		//	return _populate_JS_queryObjBulk(q, qObjName, _dummy_func, bool_asJScode);
			return _populate_JS_queryObjBulk2(q, qObjName, _dummy_func, bool_asJScode);
		}

		function registerCFtoJS_variable(vName, vVal) {
			if (NOT IsDefined("this.struct_CFtoJS_variables.names_stack")) {
				this.struct_CFtoJS_variables.names_stack = ArrayNew(1);
				this.struct_CFtoJS_variables.names_cache = StructNew();
			}
			this.struct_CFtoJS_variables.names_stack[ArrayLen(this.struct_CFtoJS_variables.names_stack) + 1] = vName;
			this.struct_CFtoJS_variables.names_cache[vName] = vVal;
		}

		function emitCFtoJS_variables() {
			var i = -1;
			var aName = '';
			var ar = -1;
			var n = ArrayLen(this.struct_CFtoJS_variables.names_stack);

			writeOutput(begin_javascript() & Request.const_Cr);			
			for (i = 1; i lte n; i = i + 1) {
				aName = this.struct_CFtoJS_variables.names_stack[i];
				ar = ListToArray(aName, '_');
				if (UCASE(ar[1]) eq UCASE('cf')) {
					ar[1] = 'js';
				}
				writeOutput(ArrayToList(ar, '_') & " = '#JSStringFormat(this.struct_CFtoJS_variables.names_cache[aName])#';" & Request.const_Cr);
			}
			writeOutput(end_javascript() & Request.const_Cr);
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

		function objectForType(objType) {
			var anObj = -1;
			var bool_isError = false;
			var dotPath = objType;
			var _sql_statement = '';
			var thePath = '';

			bool_isError = cf_directory('Request.qDir', ListDeleteAt(CGI.CF_TEMPLATE_PATH, ListLen(CGI.CF_TEMPLATE_PATH, '\'), '\'), objType & '.cfc', true);
			if (NOT bool_isError) {
				bool_isError = cf_directory('Request.qDir2', ListDeleteAt(CGI.CF_TEMPLATE_PATH, ListLen(CGI.CF_TEMPLATE_PATH, '\'), '\'), 'commonCode.cfc', true);
				thePath = Trim(ReplaceNoCase(ReplaceNoCase(Request.qDir.DIRECTORY, Request.qDir2.DIRECTORY, ''), '\', '.'));
			}

			if (Len(thePath) gt 0) {
				thePath = thePath & '.';
			}
			dotPath = thePath & dotPath;
			if (Left(dotPath, 1) eq '.') {
				dotPath = Right(dotPath, Len(dotPath) - 1);
			}

			Request.err_objectFactory = false;
			Request.err_objectFactoryMsg = '';
			try {
			   anObj = CreateObject("component", dotPath);
			} catch(Any e) {
				Request.err_objectFactory = true;
				Request.err_objectFactoryMsg = 'The object factory was unable to create the object for type "#objType#".';
				writeOutput('<font color="red"><b>#Request.err_objectFactoryMsg# [dotPath=#dotPath#] (#explainError(e, true)#)</b></font><br>');
			}
			return anObj;
		}

		function structToQuery(ses) {
			var i = -1;
			var n = -1;
			var val = -1;
			var keys = -1;
			var q = QueryNew('');
	
			if (IsStruct(ses)) {
				keys = StructKeyArray(ses);
				q = QueryNew('id,' & ArrayToList(keys, ','));
				n = ArrayLen(keys);
				for (i = 1; i lte n; i = i + 1) {
					val = StructFind(ses, keys[i]);
					if (IsSimpleValue(val)) {
						if (i eq 1) {
							QueryAddRow(q, 1);
							QuerySetCell(q, 'id', q.recordCount, q.recordCount);
						}
						QuerySetCell(q, keys[i], val, q.recordCount);
					}
				}
			}
			return q;
		}

		function _dummy_func(val) {
			return val;
		}

		function asHex(ch) {
		    var c = BitAnd(ch, 255);
			return Mid(this.HEX, BitAnd(BitSHRN(c, 4), 15) + 1, 1) & Mid(this.HEX, BitAnd(c, 15) + 1, 1);
		}

		function _num2Hex(n) {
			var i = -1;
			var hx = '';
			var mask = this.hexMask;
			var masked = 0;
			var shiftVal = 24;
			
			for (i = 1; i lte 4; i = i + 1) {
				masked = BitSHRN(BitAnd(n, mask), shiftVal);
				if (masked gt 0) {
					hx = hx & Chr(Asc(Mid(this.HEX, BitAnd(BitSHRN(masked, 4), 15) + 1, 1)) + 16);
					hx = hx & Chr(Asc(Mid(this.HEX, BitAnd(masked, 15) + 1, 1)) + 16);
				}
				mask = BitSHRN(mask, 8);
				shiftVal = shiftVal - 8;
			}
			
			return hx;
		}
		
		function num2Hex(n) {
			return Chr(Asc(Len(n)) + 32) & _num2Hex(n);
		}
		
		function hex2num(h) {
			var i = -1;
			var n = -1;
			var x = -1;
			var ch = -1;
			var num = 0;
			
			n = Len(h);
			for (i = 1; i lte n; i = i + 1) {
				if (i gt 1) num = BitSHLN(num, 4);
				ch = Mid(h, i, 1);
				x = (Asc(ch) - 16) - Asc('0');
				if (x gt 9) {
					x = x - 7;
				}
				num = num + x;
			}
			return num;
		}
		
		function encodedEncryptedString(plainText) {
			var theKey = generateSecretKey(Request.const_encryption_method);
			var _encrypted = encrypt(plainText, theKey, Request.const_encryption_method, Request.const_encryption_encoding);
			return num2Hex(Len(theKey)) & theKey & num2Hex(Len(_encrypted)) & _encrypted;
		}

		function computeChkSum(s) {
			var i = -1;
			var chkSum = 0;
			var n = Len(s);

			for (i = 1; i lte n; i = i + 1) {
				chkSum = chkSum + Asc(Mid(s, i, 1));
			}
			return chkSum;
		}
		
		function encodedEncryptedString2(plainText) {
			var enc = encodedEncryptedString(plainText);
			var h_chkSum = 0;
			
			h_chkSum = num2Hex(computeChkSum(enc));
			return num2Hex(Len(h_chkSum)) & h_chkSum & enc;
		}

		function decodeEncodedEncryptedString(eStr) {
			var i = 1;
			var data = StructNew();
			data.hexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.keyLen = hex2num(Mid(eStr, i, data.hexLen));
			i = i + data.hexLen;
			data.theKey = Mid(eStr, i, data.keyLen);
			i = i + data.keyLen;
			data.isKeyValid = (Len(data.theKey) eq data.keyLen);
			data.i = i;

			data.encHexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.encLen = hex2num(Mid(eStr, i, data.encHexLen));
			i = i + data.encHexLen;
			data.encrypted = Mid(eStr, i, data.encLen);
			i = i + data.encLen;
			data.isEncValid = (Len(data.encrypted) eq data.encLen);
			data.i = i - 1;

			data.iLen = Len(eStr);
			data.iValid = (data.i eq data.iLen);
			
			data.error = '';
			data.plaintext = '';
			try {
				data.plaintext = Decrypt(data.encrypted, data.theKey, Request.const_encryption_method, Request.const_encryption_encoding);
			} catch (Any e) {
				data.error = 'ERROR - cannot decrypt your encrypted data. ' & '[' & explainError(e, false) & ']' & ', [const_encryption_method=#Request.const_encryption_method#]' & ', [const_encryption_encoding=#Request.const_encryption_encoding#]';
			}

			return data;
		}

		function decodeEncodedEncryptedString2(eStr) {
			var i = 1;
			var data = StructNew();

			try {
				data.hexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
				i = i + 1;
				data.chkSumLen = hex2num(Mid(eStr, i, data.hexLen));
				i = i + data.hexLen;
				data._chkSumHexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
				i = i + 1;
				data._chkSumHex = Mid(eStr, i, data._chkSumHexLen);
				i = i + data._chkSumHexLen;
				data._chkSum = hex2num(data._chkSumHex);
				data.enc = Mid(eStr, i, Len(eStr) - i + 1);
				data.chkSum = computeChkSum(data.enc);
				data.isChkSumValid = (data._chkSum eq data.chkSum);
				data.data = decodeEncodedEncryptedString(data.enc);
			} catch (Any e) {
				writeOutput(cf_dump(data, 'data :: decodeEncodedEncryptedString2(#eStr#)', false));
				writeOutput(cf_dump(e, 'CF Error', false));
				cf_abort('CF Error Caused this abort.');
			}
			return data;
		}

		function stripHTML(p_html) {
			var _html = REReplace(p_html, "<[^>]*>", "", "all");
			return REReplace(_html, "&[^;]*;", "", "all");
		}
		
		function stripCommentBlocks(p) {
			return REReplace(p, "/\*[^/\*]*\*/", "", "all");
		}
		
		function stripComments(p) {
			var re = '\/' & '\/' & '.*$';
			return REReplace(p, re, "", "all");
		}
		
		function obfuscateJScode(jsIn) {
			// JavaScript Obfuscation techniques:
			// Function name replacements - easy assuming one can determine the names of functions...
			// Variable name replacements - locate "var" keyword usage then replace only within each function...
			var ar = ListToArray(Replace(Replace(stripCommentBlocks(jsIn), Chr(9), ' ', 'all'), Chr(10), '', 'all'), Chr(13));
			var i = -1;
			var n = ArrayLen(ar);

			for (i = 1; i lte n; i = i + 1) {
				ar[i] = Trim(stripComments(ar[i]));
				if (Len(ar[i]) eq 0) {
					ArrayDeleteAt( ar, i);
					n = n - 1;
					i = i - 1;
				}
			}
			return ArrayToList(ar, ' ');
		}
		
		function processComplexHTMLContent(html) { // splits apart complex HTML content such as <cfdump> output into HTML, styles and scripts...
			var i = -1;
			var t = '';
			var aStruct = StructNew();
			var ar = ListToArray(html, Chr(13));
			var n = ArrayLen(ar);
			var bool_insideStyleTags = false;
			var bool_insideScriptTags = false;

			aStruct.styleContent = '';
			aStruct.jsContent = '';
			aStruct.htmlContent = '';
			for (i = 1; i lte n; i = i + 1) {
				t = Trim(ar[i]);
				t = Replace(t, Chr(10), '', 'all');
				if (bool_insideStyleTags) {
					if (FindNoCase('<' & '/' & 'style>', t) gt 0) {
						bool_insideStyleTags = false;
						t = '';  // force the end of style tag to be removed from the data stream...
					}

					if (bool_insideStyleTags) {
						aStruct.styleContent = aStruct.styleContent & t & Chr(13);
						t = '';  // force the end of style tag to be removed from the data stream...
					}
				} else {
					if (FindNoCase('<' & 'style>', t) gt 0) {
						bool_insideStyleTags = true;
						t = '';  // force the end of style tag to be removed from the data stream...
					}
				}
				if (bool_insideScriptTags) {
					if (FindNoCase('<' & '/' & 'script>', t) gt 0) {
						bool_insideScriptTags = false;
						t = '';  // force the end of style tag to be removed from the data stream...
					}

					if (bool_insideScriptTags) {
						aStruct.jsContent = aStruct.jsContent & t & Chr(13);
						t = '';  // force the end of style tag to be removed from the data stream...
					}
				} else {
					if (FindNoCase('<' & 'script', t) gt 0) {
						bool_insideScriptTags = true;
						t = '';  // force the end of style tag to be removed from the data stream...
					}
				}
				if (Len(t) gt 0) {
					t = Request.commonCode.filterQuotesForJS(t);
					aStruct.htmlContent = aStruct.htmlContent & t;
				}
			}
			aStruct.jsContent = obfuscateJScode(aStruct.jsContent);
			aStruct.styleContent = obfuscateJScode(aStruct.styleContent);
			return aStruct;
		}

		function QueryToStructOfStructures(theQuery, primaryKey) {
		  var theStructure  = structnew();
		  // remove primary key from cols listing
		  var cols          = ListToArray(ListDeleteAt(theQuery.columnlist, ListFindNoCase(theQuery.columnlist, primaryKey)));
		  var row           = 1;
		  var thisRow       = "";
		  var col           = 1;
		
		  for(row = 1; row LTE theQuery.recordcount; row = row + 1){
		    thisRow = structnew();
		    for(col = 1; col LTE arraylen(cols); col = col + 1){
		      thisRow[cols[col]] = theQuery[cols[col]][row];
		    }
		    theStructure[theQuery[primaryKey][row]] = duplicate(thisRow);
		  }
		  return(theStructure);
		}
		
	</cfscript>
</cfcomponent>
