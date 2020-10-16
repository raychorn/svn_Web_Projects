<!--- BEGIN: Purpose of this module is to provide the functionality for the SiteSearch function. --->
<cfparam name="_SQL_statement" type="string" default="">

<cfset _aSQLStatement = CommonCode.sql_getCurrentRelease_rid( _adminMode, _ReleaseManagement)>
<cfset _SQL_statement = "#_SQL_statement##_aSQLStatement#">

<!--- BEGIN: Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->
<cfif (IsDefined("_submit_")) AND (Len(Trim(submit)) eq 0)>
	<cfset submit = _submit_>
</cfif>
<!--- END! Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->

<cfparam name="site_search_keyword" type="string" default="">

<cfset queryArray = ArrayNew(1)>

<!--- BEGIN: Site search is composed of many queries, one for each content table - this could have been done with a huge monolithic query but doing so would not have been faster than doing this, in the balance. --->
<cfif (Len(Trim(site_search_keyword)) gt 0) AND (submit eq function_performSearch_symbol)>
	<cfset temp = ArrayAppend( queryArray, CommonCode.sql_SiteSearchQuery(_DynamicHTMLContent, _SQL_statement))>
</cfif>
<!--- END! Site search is composed of many queries, one for each content table - this could have been done with a huge monolithic query but doing so would not have been faster than doing this, in the balance. --->

<cfoutput>
	<cfif (IsDefined("queryArray")) AND (ArrayLen( queryArray) gt 0)>
		<cfscript>
			function GetResultSetFrom(qArray) {
				var _i = -1;
				var _j = -1;
				var _p = '';
				var s_html = '';
				var q = QueryNew("pageId");
				
				if (IsArray(qArray)) {
					for (_i = 1; _i lte ArrayLen(qArray); _i = _i + 1) {
						_p = qArray[_i];
						GetSiteData = CommonCode.safelyExecSQL(DSNUser, DSNPassword, DSNSource, _p, CreateTimeSpan(0, 0, 0, 0));
						if ( (IsDefined("GetSiteData")) AND IsQuery(GetSiteData) ) {
							if (GetSiteData.recordCount gt 0) {
								for (_j = 1; _j lte GetSiteData.recordCount; _j = _j + 1) {
									s_html = Trim(CommonCode.stripHTML(GetSiteData.html[_j]));
									if ( (Len(s_html) gt 0) AND (FindNoCase(Trim(site_search_keyword), s_html) gt 0) ) {
										QueryAddRow(q, 1);
										QuerySetCell(q, "pageId", GetSiteData.pageId[_j]);
									}
								}
							}
						}
					}
				}
				return q;
			}
		</cfscript>

		<cfset resultSet = GetResultSetFrom(queryArray)>
		
		<CFQUERY dbtype="query" name="GetPagesForSearch">
			SELECT DISTINCT pageId
			FROM resultSet
			WHERE (pageId IS NOT NULL)
			ORDER BY pageId
		</cfquery>

		<cfif (IsDefined("GetPagesForSearch")) AND (GetPagesForSearch.recordCount gt 0)>
			<cfset _inClause = "">
			<cfloop query="GetPagesForSearch" startrow="1" endrow="#GetPagesForSearch.recordCount#">
				<cfset _inClause = "#_inClause##GetPagesForSearch.pageId#">
				<cfif (GetPagesForSearch.currentRow neq GetPagesForSearch.recordCount)>
					<cfset _inClause = "#_inClause#,">
				</cfif>
			</cfloop>

			<cfset __SQL_statement = "#_SQL_statement#
				SELECT DISTINCT pageId, pageName, PageTitle
				FROM #_DynamicPageManagement#
				WHERE (rid = @prid) AND (pageId IN (#_inClause#))
				ORDER BY pageName;
			">

			<cfquery name="GetSiteSearchHits" datasource="#DSNSource#" username="#DSNUser#" password="#DSNPassword#">
				#PreserveSingleQuotes(__SQL_statement)#
			</cfquery>

			<cfif (IsDefined("GetSiteSearchHits")) AND (GetSiteSearchHits.recordCount gt 0)>
				<div id="div_site_search_results" style="position: absolute; top: 200px; left: 200px; width: 600px; height: 400px; display: inline;">
					<table width="100%" border="1" cellpadding="-1" cellspacing="-1" bgcolor="##FFFFC4">
						<tr>
							<td>
								<UL>
									<LI>Site Search for (#Trim(site_search_keyword)#) ::
										<OL>
											<cfloop query="GetSiteSearchHits" startrow="1" endrow="#GetSiteSearchHits.recordCount#">
												<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("id_search_link#GetSiteSearchHits.currentRow#")>
												<LI><small><a #_tooltips_# href="#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(GetSiteSearchHits.pageName)##Request.next_splashscreen_inhibitor#" title="Click this link to view this page of content." target="_blank">#GetSiteSearchHits.PageTitle#</a></small></LI>
											</cfloop>
										</OL>
									</LI>
								</UL>
							</td>
						</tr>
					</table>
				</div>
			</cfif>
		</cfif>
	</cfif>
</cfoutput>
<!--- END! Purpose of this module is to provide the functionality for the SiteSearch function. --->
