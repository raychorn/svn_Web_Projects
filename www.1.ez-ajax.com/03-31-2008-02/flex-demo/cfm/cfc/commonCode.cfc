<cfcomponent output="no">

	<cfscript>
		function isServerLocal() {
			var CGI_HTTP_HOST = UCASE(TRIM(CGI.HTTP_HOST));
			return ( (FindNoCase('LOCALHOST', CGI_HTTP_HOST) gt 0) OR (FindNoCase('127.0.0.1', CGI_HTTP_HOST) gt 0) OR (FindNoCase('trosquesere', CGI_HTTP_HOST) gt 0) );
		}

		function nocacheParm() {
			return 'nocache=#Abs(RandRange(0, 2147483647, 'SHA1PRNG'))#';
		}

		function cfm_to_htmlFileName(cfmName) {
			return Replace(Replace(GetToken(cfmName, 1, '.'), '.', '_', 'all'), '/', '_', 'all') & '_.htm';
		}

		function stripHTML(p_html) {
			var _html = '';

			_html = REReplace(p_html, "<[^>]*>", "", "all");
			_html = REReplace(_html, "&[^;]*;", "", "all");
			
			return _html;
		}

		function stripHTMLbetweenTokens(tok1, tok2, p_str) {
			var ss = '';
			var _beginTok = -1;
			var _endTok = -1;

			_beginTok = FindNoCase(tok1, p_str);
			_endTok = FindNoCase(tok2, p_str, _beginTok + 1);
			ss = stripHTML(Mid(p_str, _beginTok + Len(tok1), _endTok - (_beginTok + Len(tok1)) + Len(tok2)));

			return Mid(p_str, 1, _beginTok + Len(tok1) - 1) & ss & Mid(p_str, _endTok, Len(p_str) - _endTok + 1);
		}

		function insertStringAfterToken(str, tok, p_str) {
			var ss = '';
			var tokBegin = -1;

			tokBegin = FindNoCase(tok, p_str);
			if (tokBegin gt 0) {
				ss = Mid(p_str, 1, tokBegin + Len(tok) - 1) & str & Mid(p_str, (tokBegin + Len(tok) + 1), Len(p_str) - (tokBegin + Len(tok)) + 1);
			}
			return ss;
		}

		function path_to_url(path, scriptName) {
			var fp = '';
			var _f = -1;
			var urlPrefix = '';
			var url = 'unknown';

			urlPrefix = ReplaceNoCase(scriptName, GetToken(scriptName, ListLen(scriptName, '/'), '/'), '');
			fp = ReplaceNoCase(path, '\', '/', 'all');
			_f = FindNoCase(urlPrefix, fp);
			if (_f gt 0) {
				url = Right(fp, Len(fp) - _f + 1);
				if (Right(url, 1) neq '/') {
					url = url & '/';
				}
			}
			return url;
		}

		function fullyQualifiedURLprefix(prefix) {
			return "http://" & CGI.SERVER_NAME & prefix;
		}

		function dbErrorLog(_cfcatch) {
			var _dbErrorMsg = '';
			var bool_add_comma = false;
			
			if (IsDefined("_cfcatch.Detail")) {
				_dbErrorMsg = _dbErrorMsg & 'Detail = [' & _cfcatch.Detail & ']';
				bool_add_comma = true;
			}
	
			if (IsDefined("_cfcatch.Message")) {
				if (bool_add_comma) {
					_dbErrorMsg = _dbErrorMsg & ', ';
					bool_add_comma = false;
				}
				_dbErrorMsg = _dbErrorMsg & 'Message = [' & _cfcatch.Message & ']';
				bool_add_comma = true;
			}
	
			if (IsDefined("_cfcatch.RootCause.Message")) {
				if (bool_add_comma) {
					_dbErrorMsg = _dbErrorMsg & ', ';
					bool_add_comma = false;
				}
				_dbErrorMsg = _dbErrorMsg & 'RootCause.Message = [' & _cfcatch.RootCause.Message & ']';
				bool_add_comma = true;
			}
	
			if (IsDefined("_cfcatch.RootCause.Type")) {
				if (bool_add_comma) {
					_dbErrorMsg = _dbErrorMsg & ', ';
					bool_add_comma = false;
				}
				_dbErrorMsg = _dbErrorMsg & 'RootCause.Type = [' & _cfcatch.RootCause.Type & ']';
				bool_add_comma = true;
			}
	
			if (IsDefined("_cfcatch.RootCause.Element")) {
				if (bool_add_comma) {
					_dbErrorMsg = _dbErrorMsg & ', ';
					bool_add_comma = false;
				}
				_dbErrorMsg = _dbErrorMsg & 'RootCause.Element = [' & _cfcatch.RootCause.Element & ']';
				bool_add_comma = true;
			}
	
			if (IsDefined("_cfcatch.Type")) {
				if (bool_add_comma) {
					_dbErrorMsg = _dbErrorMsg & ', ';
					bool_add_comma = false;
				}
				_dbErrorMsg = _dbErrorMsg & 'Type = [' & _cfcatch.Type & ']';
				bool_add_comma = true;
			}
	
			if (IsDefined("_cfcatch.Name")) {
				if (bool_add_comma) {
					_dbErrorMsg = _dbErrorMsg & ', ';
					bool_add_comma = false;
				}
				_dbErrorMsg = _dbErrorMsg & 'Name = [' & _cfcatch.Name & ']';
				bool_add_comma = true;
			}
			
			return _dbErrorMsg;
		}

		function dbError(_cfcatch, bool) {
			var _dbErrorMsg = '';
			
			if (NOT IsBoolean(bool)) {
				bool = false;
			}
	
			_dbErrorMsg = _dbErrorMsg &	Request.primitiveCode.cf_dump(_cfcatch, '_cfcatch');
	
			if (bool) {
				cf_log(dbErrorLog(_cfcatch), "APPLICATION", "Error");
			}
			return _dbErrorMsg;
		}

		function _safely_execQofQ( _qryName, _SQL_) {
			var _dbError = '';
			var q = QueryNew('dbError');
			
			try {
				q = execQofQ( _qryName, _SQL_);
			} catch(Any e) {
				QueryAddRow(q);
				_dbError = '<p><font color="red"><b>_qryName = [#_qryName#]</b></font><br>';
				_dbError = _dbError & '<font color="red"><b>_SQL_ = [#_SQL_#]</b></font><br>';
				_dbError = _dbError & dbError(e, true);
				_dbError = _dbError & '</p>';
				QuerySetCell(q, 'dbError', _dbError);
				if (isServerLocal()) {
					writeOutput(_dbError);
				}
			}
			return q;
		}
	
		function makeListIntoSQLList(_list) {
			var i = -1;
			var _anItem = -1;
			var _sqlList = "";
			var i_max = ListLen(_list, ",");
			for (i = 1; i lte i_max; i = i + 1) {
				_anItem = Replace(GetToken(_list, i, ","), "'", "''", "all");
				_sqlList = _sqlList & "'#_anItem#'";
				if (i lt i_max) {
					_sqlList = _sqlList & ",";
				}
			}
			
			return _sqlList;
		}

	</cfscript>

</cfcomponent>
