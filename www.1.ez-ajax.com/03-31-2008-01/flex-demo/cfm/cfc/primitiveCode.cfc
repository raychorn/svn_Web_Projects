<cfcomponent output="no">

	<cffunction name="div_loadingContent" access="public" returntype="string">
		<cfargument name="_info_" type="string" default="Data" required="yes">
		<cfargument name="_path_" type="string" default="">
	
		<cfset _html = '
			<div id="content_loading" class="content" style="display: inline;">
				<table width="100%" height="200px" cellpadding="-1" cellspacing="-1">
					<tr valign="middle">
						<td align="center">
							<h3 align="center"><b><font face="Arial,''Arial Narrow'',''Arial MT Condensed Light'',sans-serif" color="##0000FF">Loading #_info_# from Database...<br><br>Please Wait... Briefly.</font></b></h3>
						</td>
					</tr>
					<tr valign="middle">
						<td align="center">
							<img src="#_path_#images/loading/xp/loading.gif" alt="" width="107" height="13" border="0" title="Loading..."><br>
							<font size="1"><small><i>Loading Indicator...</i></small></font>
						</td>
					</tr>
				</table>
			</div>
		'>
	
		<cfreturn _html>
	</cffunction>

	<cffunction name="cfm_nocache" access="public" returntype="string">
		<cfargument name="LastModified" type="string" default="Mon, 1 Jul 1959 00:00:00 EST">

		<CFSETTING ENABLECFOUTPUTONLY="YES">
		<CFHEADER NAME="Pragma" VALUE="no-cache">
		<CFHEADER NAME="Cache-Control" VALUE="no-cache, must-revalidate">
		<CFHEADER NAME="Last-Modified" VALUE="#LastModified#">
		<CFHEADER NAME="Expires" VALUE="Mon, 26 Jul 1997 05:00:00 EST">
		<CFSETTING ENABLECFOUTPUTONLY="NO">
		
	</cffunction>

	<cffunction name="_execSQL" access="public" returntype="query" output="yes">
		<cfargument name="_qryName" required="yes" type="string">
		<cfargument name="_DSNUser" required="yes" type="string">
		<cfargument name="_DSNPassword" required="yes" type="string">
		<cfargument name="_DSNSource" required="yes" type="string">
		<cfargument name="_SQL_" required="yes" type="string">
		<cfargument name="_cachedwithin_" type="string" default="">

		<cfif ( (IsDefined("_cachedwithin_")) AND (Len(Trim(_cachedwithin_)) gt 0) )>
			<CFQUERY username='#_DSNUser#' password='#_DSNPassword#' name="#_qryName#" datasource="#_DSNSource#" cachedwithin="#_cachedwithin_#">
				#PreserveSingleQuotes(_SQL_)#
			</cfquery>
		<cfelse>
			<CFQUERY username='#_DSNUser#' password='#_DSNPassword#' name="#_qryName#" datasource="#_DSNSource#">
				#PreserveSingleQuotes(_SQL_)#
			</cfquery>
		</cfif>

		<cfset q = QueryNew("none")>
		<cfif (IsDefined("#_qryName#"))>
			<cfset _q = Evaluate(_qryName)>
			<cfif (IsQuery(_q))>
				<cfset q = _q>
			</cfif>
		</cfif>
		<cfreturn q>
	</cffunction>

	<cffunction name="execSQL" access="public" returntype="query">
		<cfargument name="_DSNUser" required="yes" type="string">
		<cfargument name="_DSNPassword" required="yes" type="string">
		<cfargument name="_DSNSource" required="yes" type="string">
		<cfargument name="_SQL_" required="yes" type="string">
		<cfargument name="_cachedwithin_" type="string" default="">

		<cfreturn _execSQL("tempQuery", _DSNUser, _DSNPassword, _DSNSource, _SQL_, _cachedwithin_)>
	</cffunction>

	<cffunction name="__debugQueryInTable" access="public" returntype="string">
		<cfargument name="q" type="query" required="yes">
		<cfargument name="qName" type="string" required="yes">
		<cfargument name="isHorz" type="boolean" default="False">
		
		<cfsavecontent variable="_html">
			<cfoutput>
				<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
					<tr>
						<td bgcolor="silver" class="normalBoldClass">
							(#qName#) #qName#.recordCount = [#q.recordCount#]
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
								<cfif (isHorz)>
									<cfloop index="_i" list="#q.columnList#" delimiters=",">
										<tr>
											<td bgcolor="silver" class="normalBoldClass">#LCase(_i)#</td>
											<cfloop query="q" startrow="1" endrow="#q.recordCount#">
												<td class="normalClass">
													<cfset _val = Evaluate("q.#_i#")>
													<cfif (Len(Trim(_val)) gt 0)>
														#_val#
													<cfelse>
														&nbsp;
													</cfif>
												</td>
											</cfloop>
										</tr>
									</cfloop>
								<cfelse>
									<tr>
										<cfloop index="_i" list="#q.columnList#" delimiters=",">
											<td bgcolor="silver" class="normalBoldClass">#LCase(_i)#</td>
										</cfloop>
									</tr>
									<cfloop query="q" startrow="1" endrow="#q.recordCount#">
										<tr>
											<cfloop index="_i" list="#q.columnList#" delimiters=",">
												<td class="normalClass">
													<cfset _val = Evaluate("q.#_i#")>
													<cfif (IsSimpleValue(_val))>
														<cfif (Len(Trim(_val)) gt 0)>
															#_val#
														<cfelse>
															&nbsp;
														</cfif>
													<cfelse>
														<small><i>(Too Complex !)</i></small>
													</cfif>
												</td>
											</cfloop>
										</tr>
									</cfloop>
								</cfif>
							</table>
						</td>
					</tr>
				</table>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>

	</cffunction>

	<cffunction name="cf_dump" access="public" returntype="string">
		<cfargument name="var" type="any" required="yes">
		<cfargument name="varName" type="string" required="yes">
		<cfargument name="is_expanded" type="string" default="No">
		
		<cfsavecontent variable="_html">
			<cfdump var="#var#" label="#varName#" expand="#is_expanded#">
		</cfsavecontent>
		
		<cfreturn _html>

	</cffunction>

	<cffunction name="cf_abort" access="public" returntype="string">
		<cfargument name="_reason_" type="any" required="yes">
		
		<cfabort showerror="#_reason_#">
		
	</cffunction>

	<cffunction name="_debugQueryInTable" access="public" returntype="string">
		<cfargument name="q" type="query" required="yes">
		<cfargument name="qName" type="string" required="yes">
		<cfargument name="isHorz" type="boolean" default="False">
		
		<cfsavecontent variable="_html">
			<cfdump var="#q#" label="#qName#">
		</cfsavecontent>
		
		<cfreturn _html>

	</cffunction>

	<cffunction name="debugQueryInTable" access="public" returntype="string" output="yes">
		<cfargument name="q" type="query" required="yes">
		<cfargument name="qName" type="string" required="yes">
		<cfargument name="isHorz" type="boolean" default="False">

		#_debugQueryInTable(q, qName, isHorz)#
	</cffunction>

	<cffunction name="cf_log" access="public">
		<cfargument name="_text" type="string" required="yes">
		<cfargument name="_log" type="string" required="yes">
		<cfargument name="_type" type="string" required="yes">

		<cflog text = "#_text#" log = "#_log#" type = "#_type#" application="yes">
	</cffunction>
	
	<cffunction name="cfhttp" access="public" returntype="query">
		<cfargument name="_url" type="string" required="yes">

		<cfhttp url="#_url#" method="GET"></cfhttp>
		
		<cfset cfhttpQuery = QueryNew('url, charSet, errorDetail, fileContent, header, mimeType, responseHeader, statusCode, text')>
		
		<cfset dummy = QueryAddRow(cfhttpQuery, 1)>

		<cfset dummy = QuerySetCell(cfhttpQuery, 'url', _url, cfhttpQuery.recordCount)>

		<cfif (IsDefined("cfhttp.charSet"))>
			<cfset dummy = QuerySetCell(cfhttpQuery, 'charSet', cfhttp.charSet, cfhttpQuery.recordCount)>
		</cfif>
 
		<cfif (IsDefined("cfhttp.errorDetail"))>
			<cfset dummy = QuerySetCell(cfhttpQuery, 'errorDetail', cfhttp.errorDetail, cfhttpQuery.recordCount)>
		</cfif>
 
		<cfif (IsDefined("cfhttp.fileContent"))>
			<cfset dummy = QuerySetCell(cfhttpQuery, 'fileContent', cfhttp.fileContent, cfhttpQuery.recordCount)>
		</cfif>
 
		<cfif (IsDefined("cfhttp.header"))>
			<cfset dummy = QuerySetCell(cfhttpQuery, 'header', cfhttp.header, cfhttpQuery.recordCount)>
		</cfif>
 
		<cfif (IsDefined("cfhttp.mimeType"))>
			<cfset dummy = QuerySetCell(cfhttpQuery, 'mimeType', cfhttp.mimeType, cfhttpQuery.recordCount)>
		</cfif>
 
		<cfif (IsDefined("cfhttp.responseHeader"))>
			<cfset dummy = QuerySetCell(cfhttpQuery, 'responseHeader', cfhttp.responseHeader, cfhttpQuery.recordCount)>
		</cfif>
 
		<cfif (IsDefined("cfhttp.statusCode"))>
			<cfset dummy = QuerySetCell(cfhttpQuery, 'statusCode', cfhttp.statusCode, cfhttpQuery.recordCount)>
		</cfif>
 
		<cfif (IsDefined("cfhttp.text"))>
			<cfset dummy = QuerySetCell(cfhttpQuery, 'text', cfhttp.text, cfhttpQuery.recordCount)>
		</cfif>
		
		<cfreturn cfhttpQuery>
	</cffunction>
	
	<cffunction name="cfwddx" access="public" returntype="any">
		<cfargument name="_in_" type="any" required="yes">
		<cfargument name="_action_" type="string" default="CFML2WDDX">

		<cfwddx action="#_action_#" input="#_in_#" output="_out_">
		
		<cfreturn _out_>
	</cffunction>

	<cffunction name="cfwddx_CFML2JS" access="public" returntype="any">
		<cfargument name="_in_" type="any" required="yes">
		<cfargument name="_out_" type="any" required="yes">

		<cfwddx action="CFML2JS" input="#_in_#" toplevelvariable="#_out_#">
		
		<cfreturn "True">
	</cffunction>

	<cffunction name="cffile_DELETE" access="public" returntype="string">
		<cfargument name="_file_" type="string" required="yes">

		<cffile action="DELETE" file="#_file_#">
		
	</cffunction>

	<cffunction name="cffile_READBINARY" access="public" returntype="any">
		<cfargument name="_file_" type="string" required="yes">

		<cffile action="READBINARY" file="#_file_#" variable="bVal">
		
		<cfreturn bVal>
	</cffunction>

	<cffunction name="cffile_READ" access="public" returntype="string">
		<cfargument name="_file_" type="string" required="yes">

		<cffile action="READ" file="#_file_#" variable="sVal">
		
		<cfreturn sVal>
	</cffunction>

	<cffunction name="cffile_WRITE" access="public" returntype="string">
		<cfargument name="_file_" type="string" required="yes">
		<cfargument name="_out_" type="string" required="yes">
		<cfargument name="_addnewline_" type="boolean" default="Yes">

		<cffile action="WRITE" file="#_file_#" output="#_out_#" attributes="Normal" addnewline="#_addnewline_#">
		
	</cffunction>

	<cffunction name="cfdirectory_LIST" access="public" returntype="query">
		<cfargument name="_qName_" type="string" required="yes">
		<cfargument name="_dir_" type="string" required="yes">
		<cfargument name="_filter_" type="string" required="yes">

		<cfdirectory action="LIST" directory="#_dir_#" name="#_qName_#" filter="#_filter_#">
		
		<cfreturn Evaluate(_qName_)>
	</cffunction>

	<cffunction name="LockAndSet">
		<cfargument name="variableName" type="string" required="yes"> 
		<cfargument name="variableValue" type="any" required="yes"> 
		<cfargument name="scope" type="string" required="yes"> 
		<cfargument name="timeout" type="string" required="yes"> 
		<cfargument name="type" type="string" required="yes"> 
		<cfargument name="throwOnTimeout" type="boolean" default="No"> 
	
		<cflock timeout="#timeout#" throwontimeout="#throwOnTimeout#" type="#type#" scope="#scope#"> 
			<cfscript>
				SetVariable(variableName, variableValue);
			</cfscript>
		</cflock> 
	
	</cffunction> 

	<cffunction name="LockAndSetByName">
		<cfargument name="variableName" type="string" required="yes"> 
		<cfargument name="variableValue" type="any" required="yes"> 
		<cfargument name="name" type="string" required="yes"> 
		<cfargument name="timeout" type="string" required="yes"> 
		<cfargument name="type" type="string" required="yes"> 
		<cfargument name="throwOnTimeout" type="boolean" default="No"> 
	
		<cfif (Len(Trim(name)) eq 0)>
			<cfthrow message="Missing Lock Name" type="Missing_Lock_Name" detail="Lock Name cannot be (#name#)" errorcode="-999">
		<cfelse>
			<cflock timeout="#timeout#" throwontimeout="#throwOnTimeout#" type="#type#" name="#name#"> 
				<cfscript>
					SetVariable(variableName, variableValue);
				</cfscript>
			</cflock> 
		</cfif>
	
	</cffunction> 

	<cffunction name="LockAndExecFunction">
		<cfargument name="f" type="any" required="yes"> 
		<cfargument name="scope" type="string" required="yes"> 
		<cfargument name="timeout" type="string" required="yes"> 
		<cfargument name="type" type="string" required="yes"> 
		<cfargument name="throwOnTimeout" type="boolean" default="No"> 
	
		<cflock timeout="#timeout#" throwontimeout="#throwOnTimeout#" type="#type#" scope="#scope#"> 
			<cfscript>
				f();
			</cfscript>
		</cflock> 
	
	</cffunction> 

	<cffunction name="LockAndRead">
		<cfargument name="variableName" type="string" required="yes"> 
		<cfargument name="scope" type="string" required="yes"> 
		<cfargument name="timeout" type="string" required="yes"> 
		<cfargument name="throwOnTimeout" type="boolean" default="No"> 
	
		<cflock timeout="#timeout#" throwontimeout="No" type="READONLY" scope="#scope#"> 
			<cfscript>
				try {
					x = Evaluate(variableName);
				} catch (Any e) {
					x = -1;
				}
			</cfscript>
		</cflock> 
	
		<cfreturn x>
	</cffunction> 

	<cffunction name="ApplicationFooter">
		<cfargument name="p_imagesFolder" type="string" required="yes"> 
	
		<cfif (NOT IsDefined("Application.Footer_html"))>
			<cfsavecontent variable="x_html">
				<cfoutput>
					<div id="footer" class="footerClass">
						<table width="80%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td align="left" valign="top">
									<div><img src="#p_imagesFolder#sbc_md.gif" alt="SBC" width="63" height="54"></div>
								</td>
								<td>
									<div id="restricted" class="restrictedFooterClass">
										<p align="justify">
											<font size="1"><small><strong>RESTRICTED - PROPRIETARY INFORMATION</strong></small></font>
											<font size="1"><small>
											The Information contained herein is for use only by authorized employees of SBC Services, Inc.,
											and authorized Affiliates of SBC Services, Inc., 
											and is not for general distribution within or outside the respective companies.
											</small></font>
										</p>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</cfoutput>
			</cfsavecontent>

			<cfscript>
				LockAndSet('Application.Footer_html', x_html, 'Application', '10', 'EXCLUSIVE');
			</cfscript>
		</cfif>
		
		<cfreturn LockAndRead('Application.Footer_html', 'Application', '10')>
	</cffunction> 

	<cffunction name="cfinclude" access="public" returntype="any">
		<cfargument name="_file_" type="string" required="yes">

		<cfinclude template="#_file_#">
		
		<cfreturn "True">
	</cffunction>

	<cffunction name="cflocation" access="public" returntype="any">
		<cfargument name="_url_" type="string" required="yes">
		<cfargument name="_addtoken_" type="boolean" default="No">

		<cflocation url="#_url_#" addtoken="#_addtoken_#">
		
		<cfreturn "True">
	</cffunction>

	<cffunction name="execQofQ" access="public" returntype="query" output="yes">
		<cfargument name="_qryName" required="yes" type="string">
		<cfargument name="_SQL_" required="yes" type="string">

		<CFQUERY dbtype="query" name="#_qryName#">
			#PreserveSingleQuotes(_SQL_)#
		</cfquery>

		<cfreturn Evaluate(_qryName)>
	</cffunction>

	<cffunction name="metaTags" access="public" returntype="string">
		<cfargument name="_title" required="yes" default="" type="string">
		<cfargument name="p_args" type="string" default="">  <!--- comma delimited list name=content,... --->

		<cfscript>
			theTags = "";
		</cfscript>
		
		<cfsavecontent variable="theTags">
			<cfoutput>
				<title>#_title#</title>
				<cfloop index="_item" list="#p_args#" delimiters=",">
					<cfif (ListLen(_item, "=") eq 2)>
						<META content="#URLDecode(GetToken(_item, 2, "="))#" name="#GetToken(_item, 1, "=")#">
					</cfif>
				</cfloop>
				<META HTTP-EQUIV="Pragma" CONTENT="NO-CACHE">
				<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
				<META HTTP-EQUIV="EXPIRES" CONTENT="Mon, 1 Jan 2000 00:00:00 GMT">
				<META HTTP-EQUIV="CONTENT-LANGUAGE" CONTENT="en-US">
				<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=UTF-8">
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn theTags>
	</cffunction>

	<cffunction name="cfEmitContentWithoutWatermark" access="public" returntype="boolean">
		<cfargument name="_moduleName_" type="string" required="yes">
		<cfargument name="_htmlContent_" type="string" required="yes">
		<cfargument name="_bool_" type="boolean" default="True">

		<cfscript>
			var folderName = '';
			var targetName = '';
			var fname_htmlContent = '';
			var qDir = -1;
			var q = -1;
			var qt = -1;
			var _SQL = '';
			var i = -1;
			var m = -1;
			var tok = '';
			var retCode = -1;

			folderName = GetDirectoryFromPath(GetBaseTemplatePath());
			targetName = cfm_to_htmlFileName(_moduleName_);
			fname_htmlContent = folderName & targetName;
		</cfscript>

		<cflock timeout="10" throwontimeout="No" name="#fname_htmlContent#" type="EXCLUSIVE">
			<cfscript>
				try {
					cffile_WRITE(fname_htmlContent, _htmlContent_);
					if (_bool_) {
						cflocation(fullyQualifiedURLprefix(Request.url_prefix) & targetName);
					}
				} catch (Any e) {
					retCode = false;
				}
				
				retCode = true;
			</cfscript>
		</cflock>

		<cfreturn retCode>
	</cffunction>

	<cffunction name="safely_execSQL" access="public" returntype="any">
		<cfargument name="p_DSNUser" required="yes" type="string">
		<cfargument name="p_DSNPassword" required="yes" type="string">
		<cfargument name="p_DSNSource" required="yes" type="string">
		<cfargument name="p_SQL" type="string" required="yes">
		<cfargument name="p_cachedwithin" type="string" default="">

		<cfscript>
			var q = -1;
		</cfscript>

		<cfset Request.db_err = "False">
		<cfset Request.db_err_content = "">
		<cfset Request.db_NativeErrorCode = -1>
		<cftry>
			<cfscript>
				q = execSQL(p_DSNUser, p_DSNPassword, p_DSNSource, p_SQL, p_cachedwithin);
			</cfscript>
	
			<cfcatch type="Database">
				<cfset Request.db_err = "True">
				<cfset Request.db_NativeErrorCode = cfcatch.NativeErrorCode>
				<cfsavecontent variable="Request.db_err_content">
					<cfdump var="#cfcatch#" label="cfcatch" expand="No">
				</cfsavecontent>
			</cfcatch>
		</cftry>
		
		<cfreturn q>
	</cffunction>

</cfcomponent>
