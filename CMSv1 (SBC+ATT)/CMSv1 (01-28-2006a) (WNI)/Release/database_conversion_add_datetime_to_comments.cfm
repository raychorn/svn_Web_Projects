<!--- Purpose:  This was written as a system-level utility and is not part of the production configuration.
 --->

<cfparam name="_function" type="string" default="">

<cfparam name="_tables_mode" type="string" default="">
<cfparam name="_table_owner" type="string" default="">
<cfparam name="_run_mode" type="string" default="">

<cfset const_dbo_symbol = "dbo.">
<cfset const_non_dbo_symbol = "[ITSERVICES\ps6473].">

<cfset const_localhost_symbol = "">
<cfset const_sqldevsl5_symbol = "SQLDEVSL5.pmprofessionalism">
<cfset const_SQLPRODSL4_symbol = "SQLPRODSL4.pmprofessionalism">

<cfset const_function_go_symbol = "[GO]">

<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>database_conversion_add_datetime_to_comments.cfm</title>
	</head>
	
	<body>
	
	<cfif (Len(Trim(_function)) eq 0)>
		<form action="#CGI.SCRIPT_NAME#" method="post">
			<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
			<table width="*" cellpadding="-1" cellspacing="-1">
				<tr>
					<td>
						<small><b>Tables Mode:</b></small>
						<select name="_tables_mode" size="1" style="font-size: 10px;">
							<option value="" SELECTED>Choose...</option>
							<option value="#const_dbo_symbol#">#const_dbo_symbol#</option>
							<option value="#const_non_dbo_symbol#">#const_non_dbo_symbol#</option>
						</select>
					</td>
					<td>
						<small><b>Table Owner:</b></small>
						<select name="_table_owner" size="1" style="font-size: 10px;">
							<option value="" SELECTED>Choose...</option>
							<option value="#const_localhost_symbol#">(localhost)</option>
							<option value="#const_sqldevsl5_symbol#">#const_sqldevsl5_symbol#</option>
							<option value="#const_SQLPRODSL4_symbol#">#const_SQLPRODSL4_symbol#</option>
						</select>
					</td>
					<td>
						<small><b>Run Mode:</b></small>
						<select name="_run_mode" size="1" style="font-size: 10px;">
							<option value="" SELECTED>Choose...</option>
							<option value="(commit)">(commit)</option>
						</select>
					</td>
					<td>
						<input type="submit" name="_function" value="#const_function_go_symbol#">
					</td>
				</tr>
			</table>
		</form>
	<cfelseif (UCASE(Trim(_function)) eq UCASE(Trim(const_function_go_symbol)))>
		<BIG><b><a href="#CGI.SCRIPT_NAME#?_function=#Request.next_splashscreen_inhibitor#">#const_function_go_symbol#</a>&nbsp;[#_run_mode#]</b></BIG><br><br>
		<cfscript>
			if (Len(Trim(_tables_mode)) gt 0) {
				if (FindNoCase(_tables_mode, _ReleaseManagementComments) eq 0) {
					_src = const_non_dbo_symbol;
					_filter = '2';
					if (FindNoCase(const_dbo_symbol, _ReleaseManagementComments) gt 0) {
						_src = const_dbo_symbol;
						_filter = '';
					}
					_ReleaseManagementComments = ReplaceNoCase(_ReleaseManagementComments, _src, _tables_mode);
					if (Len(Trim(_filter)) gt 0) {
						_ReleaseManagementComments = ReplaceNoCase(_ReleaseManagementComments, _filter, '');
					}
				}
			}

			if (Len(Trim(_table_owner)) gt 0) {
				_ReleaseManagementComments = _table_owner & '.' & _ReleaseManagementComments;
			}
		</cfscript>
		
		<cfset _SQL_statement = "
			SELECT *, SUBSTRING( comments, 1, PATINDEX ( '%T: %' , comments)) as t_stamp 
			FROM #_ReleaseManagementComments#
			WHERE (aDateTime IS NULL) AND (comments LIKE 'SBCUID%on%:%');
		">
		
		<cfquery name="GetReleaseData0" datasource="#DSNSource#" username="#DSNUser#" password="#DSNPassword#">
			#PreserveSingleQuotes(_SQL_statement)#
		</cfquery>
		
		<cfif (IsDefined("GetReleaseData0")) AND (GetReleaseData0.recordCount gt 0)>
			<cfscript>
				_SQL_statement = "";
	
				const_on_symbol = ' on ';
				const_on_symbol2 = ' on :';
				const_whitespace_symbol = ' ';
				
				_Cr = Chr(13) & Chr(10);
			</cfscript>
	
			[#GetReleaseData0.recordCount#]<br>
			<cfloop query="GetReleaseData0" startrow="1" endrow="#GetReleaseData0.recordCount#">
				<small>
				[#t_stamp#]&nbsp; <!--- SBCUID ms1357 on 10/28/2004 05:09 pm CDT --->
				<cfscript>
					_ts_d = '';
					_ts_dt = '';
					
					_ts_i = FindNoCase(const_on_symbol, t_stamp);
					if (_ts_i gt 0) {
						_ts_i = _ts_i + Len(const_on_symbol);
						_ts_ = Mid(t_stamp, _ts_i, Len(t_stamp) - _ts_i + 1);
						_ts_di = FindNoCase(const_whitespace_symbol, _ts_);
						if (_ts_di gt 0) {
							_ts_dt = Mid(_ts_, 1, _ts_di - Len(const_whitespace_symbol));
							if (IsDate(_ts_dt)) {
								_ts_d = ParseDateTime(_ts_dt);
								_ts_2 = Replace(_ts_, _ts_dt, '');
							}
							_ts_dt2 = _ts_;
							if (NOT IsDate(_ts_)) {
								_tz_i = Find(const_whitespace_symbol, Reverse(_ts_));
								if (_tz_i gt 0) {
									_tz_i = Len(_ts_) - _tz_i;
								}
								_ts_dt2 = Mid(_ts_, 1, _tz_i);
							}
							if (IsDate(_ts_dt2)) {
								_ts_d2 = ParseDateTime(_ts_dt2);
								_comments = Replace(ReplaceNoCase(Replace(comments, "''", "'", 'all'), _ts_, ''), "'", "''", 'all');
								_comments = Replace(_comments, const_on_symbol2, ':');
								_SQL_statement = _SQL_statement & "UPDATE #_ReleaseManagementComments# SET aDateTime = #CreateODBCDateTime(_ts_d2)#, comments = '#_comments#' WHERE (id = #id#) AND (rid = #rid#);" & _Cr;
							}
						}
					}
				</cfscript>
	
				[#_ts_#] [#_ts_dt#] [#_ts_d#] [#_ts_2#] [#_ts_dt2#] [#_ts_d2#]<br>
				</small>
			</cfloop>
			
			<textarea cols="150" rows="20" readonly wrap="soft" style="font-size: 10px;">#_SQL_statement#</textarea>
			
			<cfif (Len(Trim(_run_mode)) gt 0)>
				<cfquery name="GetReleaseData0" datasource="#DSNSource#" username="#DSNUser#" password="#DSNPassword#">
					#PreserveSingleQuotes(_SQL_statement)#
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	
	</body>
	</html>
</cfoutput>
