<cfset _aSQL_ = CommonCode.sql_getCurrentRelease_rid( (_adminMode OR _LayoutMode), _ReleaseManagement)>

<cfif 0>
	<!--- BEGIN: The following block of code simulates a condition in which the user community has chosen to trigger the usage of the original static site content rather than the dynamic site content by NULLing out the Production timestamp in the database... --->
	<cfset _aSQL = "#_aSQL#
		SELECT @prid = NULL;
	">
	<!--- END! The following block of code simulates a condition in which the user community has chosen to trigger the usage of the original static site content rather than the dynamic site content by NULLing out the Production timestamp in the database... --->
</cfif>

<cfset _preSQL1 = "
	DECLARE @_pageId as int;
	SELECT @_pageId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#currentPage#') AND (rid = @prid) ORDER BY versionDateTime DESC);
">

<cfset _preSQL2 = "
	DECLARE @_padPageId as int;
	SELECT @_padPageId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#_listOfRequiredQuickLinksPages#') AND (rid = @prid) ORDER BY #_DynamicPageManagement#.versionDateTime DESC);
">

<cfset _preSQL3 = "
	DECLARE @_menuPageId as int;
	SELECT @_menuPageId = (SELECT TOP 1 pageId FROM #_DynamicHTMLmenu# WHERE (rid = @prid));
">

<cfset _preSQL4 = "
	DECLARE @sepgId as int;
	SELECT @sepgId = (SELECT TOP 1 pageId FROM #_DynamicHTMLsepg_section# WHERE (rid = @prid));
">

<cfset _preSQL5 = "
	DECLARE @sepgLinksId as int;
	SELECT @sepgLinksId = (SELECT TOP 1 pageId FROM #_DynamicHTMLsepg_links# WHERE (rid = @prid));
">

<cfset _preSQL6 = "
	DECLARE @rightSideId as int;
	SELECT @rightSideId = (SELECT TOP 1 pageId FROM #_DynamicHTMLright_side# WHERE (rid = @prid));
">

<cfset _preSQL7 = "
	DECLARE @footerId as int;
	SELECT @footerId = (SELECT TOP 1 pageId FROM #_DynamicHTMLfooter# WHERE (rid = @prid));
">

<cfset _aSQL = "#_aSQL_#
	DECLARE @layid as int;
	SELECT @layid = (SELECT TOP 1 layout_id FROM #_ReleaseManagement# WHERE (id = @prid));
	
	DECLARE @layoutName as varchar(50);
	SELECT @layoutName = '';

	DECLARE @layoutSpec as varchar(8000);
	SELECT @layoutSpec = '';

	IF @layid IS NOT NULL
	BEGIN
		SELECT @layoutName = (SELECT TOP 1 layout_name FROM #_LayoutManagement# WHERE (id = @layid));
		SELECT @layoutSpec = (SELECT TOP 1 layout_spec FROM #_LayoutManagement# WHERE (id = @layid));
	END;

	DECLARE @_pageTitle as varchar(50);
	SELECT @_pageTitle = (SELECT TOP 1 PageTitle FROM #_DynamicPageManagement# WHERE (pageName = '#currentPage#') AND (rid = @prid) ORDER BY versionDateTime DESC);
				
	DECLARE @_pageName as varchar(50);
	SELECT @_pageName = (SELECT TOP 1 pageName FROM #_DynamicPageManagement# WHERE (pageName = '#currentPage#') AND (rid = @prid) ORDER BY versionDateTime DESC);
				
	#_preSQL1#
	
	#_preSQL2#
	
	#_preSQL3#
	
	#_preSQL4#

	#_preSQL5#
	
	#_preSQL6#
	
	#_preSQL7#
">

<cfif (_adminMode eq 1) OR (_LayoutMode eq 1)>
	<cfset _aSQL = "#_aSQL#
		IF @prid IS NOT NULL
		BEGIN
			DECLARE @_aPageId as int;

			DECLARE @_i as int;
			DECLARE @_j as int;
			DECLARE @_iMax as int;
			DECLARE @_str as varchar(8000);
			DECLARE @_delim as varchar(1);
			DECLARE @_tok as varchar(8000);
			
			SELECT @_delim = ',';
			SELECT @_str = '#_listOfRequiredSpecialPages#';
			
			SELECT @_i = 1;
			SELECT @_j = 1;
			SELECT @_iMax = Len(@_str);

			WHILE (@_j < @_iMax)
			BEGIN
				SELECT @_i = CHARINDEX( @_delim, @_str, @_j);
				IF @_i = 0
					SELECT @_i = @_iMax + 1;
				SELECT @_tok = SUBSTRING( @_str, @_j, (@_i - @_j));

				SELECT @_aPageId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = @_tok) AND (rid = @prid));

				IF @_aPageId IS NULL
				BEGIN
					SELECT @_aPageId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (rid = @prid) ORDER BY pageId DESC);

					IF @_aPageId IS NULL
						SELECT @_aPageId = 1;
					ELSE
						SELECT @_aPageId = (@_aPageId + 1);

					INSERT INTO #_DynamicPageManagement# (pageId, pageName, PageTitle, versionDateTime, rid)
						VALUES (@_aPageId, @_tok, ('['+ @_tok + ']'), NULL, @prid);
				END

				SELECT @_j = @_i + 1;
			END
			
			IF @sepgId IS NULL
			BEGIN
				SELECT @_aPageId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#_listOfRequiredSepg_sectionPages#') AND (rid = @prid));
				INSERT INTO #_DynamicHTMLsepg_section# (pageId, html, rid) VALUES (@_aPageId, '', @prid);
				SELECT @sepgId = (SELECT TOP 1 pageId FROM #_DynamicHTMLsepg_section# WHERE (rid = @prid));
			END
			
			IF @sepgLinksId IS NULL
			BEGIN
				SELECT @_aPageId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#_listOfRequiredSepg_linksPages#') AND (rid = @prid));
				INSERT INTO #_DynamicHTMLsepg_links# (pageId, html, rid) VALUES (@_aPageId, '', @prid);
				SELECT @sepgLinksId = (SELECT TOP 1 pageId FROM #_DynamicHTMLsepg_links# WHERE (rid = @prid));
			END

			IF @rightSideId IS NULL
			BEGIN
				SELECT @_aPageId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#_listOfRequiredRight_sidePages#') AND (rid = @prid));
				INSERT INTO #_DynamicHTMLright_side# (pageId, html, rid) VALUES (@_aPageId, '', @prid);
				SELECT @rightSideId = (SELECT TOP 1 pageId FROM #_DynamicHTMLright_side# WHERE (rid = @prid));
			END

			IF @footerId IS NULL
			BEGIN
				SELECT @_aPageId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#_listOfRequiredFooterPages#') AND (rid = @prid));
				INSERT INTO #_DynamicHTMLfooter# (pageId, html, rid) VALUES (@_aPageId, '', @prid);
				SELECT @footerId = (SELECT TOP 1 pageId FROM #_DynamicHTMLfooter# WHERE (rid = @prid));
			END
		END
	">
</cfif>

<cfset _aSQL = "#_aSQL#
	DECLARE @aList as varchar(8000);
	
	SELECT @aList = ('');
">

<cfset _aSQL = "#_aSQL#
	DECLARE @lockedMenu as datetime;
	SELECT @lockedMenu = NULL;

	DECLARE @lockedMenuBy as int;
	SELECT @lockedMenuBy = NULL;

	DECLARE @lockedMenuSBCUID as varChar(8000);
	SELECT @lockedMenuSBCUID = NULL;
">

<!--- BEGIN: The data that is derived from this query is also being pulled from the GetContentSecurity query however here we need those pages that are NOT currently linked. --->
<cfif (_adminMode eq 1) OR (CommonCode.isStagingView()) OR (CommonCode.is_htmlArea_editor())>
	<!--- BEGIN: This block of code queries the database to determine if the Menu Editor is locked or not --->
	<cfset _aSQL = "#_aSQL#
		SELECT @lockedMenu = (SELECT TOP 1 d_locked FROM #_MenuEditorAccess#);
	
		SELECT @lockedMenuBy = (SELECT TOP 1 uid FROM #_MenuEditorAccess#);
	
		IF @lockedMenuBy IS NOT NULL
			SELECT @lockedMenuSBCUID = (SELECT TOP 1 userid FROM #_UserSecurity# WHERE (id = @lockedMenuBy));
	">
	<!--- END! This block of code queries the database to determine if the Menu Editor is locked or not --->

	<cfif (_adminMode eq 1) OR (CommonCode.isStagingView())>
		<cfif (IsDefined("VerifyUserSecurity2.uid")) AND (Len(Trim(VerifyUserSecurity2.uid)) gt 0)>
			<cfinclude template="cfinclude_GetCurrentContentList.cfm">
		<cfelse>
			<cfabort showerror="Missing user authentication - Application Server Setup Issue.">
		</cfif>
	</cfif>
</cfif>
<!--- END! The data that is derived from this query is also being pulled from the GetContentSecurity query however here we need those pages that are NOT currently linked. --->

<cfset _aSQL = "#_aSQL#
	IF @prid IS NOT NULL
		SELECT TOP 1
			@aList as pageList,
			@lockedMenu as lockedMenu,
			@lockedMenuBy as lockedMenuBy,
			@lockedMenuSBCUID as lockedMenuSBCUID,
			@prid as rid,
			@pdate as rdate, 
			@layid as layid,
			@layoutName as layoutName,
			@layoutSpec as layoutSpec,
			@_pageTitle as pageTitle, 
			@_pageName as pageName, 
			@_pageId as pageId,
			@sepgId as sepgId,
			@sepgLinksId as sepgLinksId,
			@rightSideId as rightSideId,
			@footerId as footerId,
			'' as html,
			'' as quickLinks,
			'' as menu,
			'' as #_sepg_section_pageName_symbol#,
			'' as #_sepg_links_pageName_symbol#,
			'' as #_right_side_pageName_symbol#,
			'' as #_footer_pageName_symbol#;
">

<cfset _SQL_statement = _aSQL>

<cfset _SQL_statement1 = "#_aSQL_#
	#_preSQL1#
	SELECT TOP 1
		#_DynamicHTMLContent#.html 
	FROM #_DynamicHTMLContent#
	WHERE ((#_DynamicHTMLContent#.rid = @prid) AND 
	    (#_DynamicHTMLContent#.pageId = @_pageId));
">

<cfset _SQL_statement2 = "#_aSQL_#
	#_preSQL2#
	SELECT TOP 1
	    #_DynamicHTMLpad#.html AS quickLinks 
	FROM #_DynamicHTMLpad# 
	WHERE 
		((#_DynamicHTMLpad#.rid = @prid) AND 
	    (#_DynamicHTMLpad#.pageId = @_padPageId));
">

<cfset _SQL_statement3 = "#_aSQL_#
	#_preSQL3#
	SELECT TOP 1
	    #_DynamicHTMLmenu#.html AS menu
	FROM #_DynamicHTMLmenu#
	WHERE ((#_DynamicHTMLmenu#.rid = @prid) AND 
	    (#_DynamicHTMLmenu#.pageId = @_menuPageId));
">

<cfset _SQL_statement4 = "#_aSQL_#
	#_preSQL4#
	SELECT TOP 1
		#_DynamicHTMLsepg_section#.html as #_sepg_section_pageName_symbol#
	FROM #_DynamicHTMLsepg_section#
	WHERE ((#_DynamicHTMLsepg_section#.rid = @prid) AND 
	    (#_DynamicHTMLsepg_section#.pageId = @sepgId));
">

<cfset _SQL_statement5 = "#_aSQL_#
	#_preSQL5#
	SELECT TOP 1
		#_DynamicHTMLsepg_links#.html as #_sepg_links_pageName_symbol#
	FROM #_DynamicHTMLsepg_links#
	WHERE ((#_DynamicHTMLsepg_links#.rid = @prid) AND 
	    (#_DynamicHTMLsepg_links#.pageId = @sepgLinksId));
">

<cfset _SQL_statement6 = "#_aSQL_#
	#_preSQL6#
	SELECT TOP 1
		#_DynamicHTMLright_side#.html as #_right_side_pageName_symbol#
	FROM 
		#_DynamicHTMLright_side#
	WHERE ((#_DynamicHTMLright_side#.rid = @prid) AND 
	    (#_DynamicHTMLright_side#.pageId = @rightSideId));
">

<cfset _SQL_statement7 = "#_aSQL_#
	#_preSQL7#
	SELECT TOP 1
		#_DynamicHTMLfooter#.html as #_footer_pageName_symbol#
	FROM #_DynamicHTMLfooter#
	WHERE ((#_DynamicHTMLfooter#.rid = @prid) AND 
	    (#_DynamicHTMLfooter#.pageId = @footerId));
">

<cfif Len(_SQL_statement) gt 0>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetCurrentContent" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement)#
	</cfquery>

	<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount eq 0)>
		<cfoutput>
			<script language="JavaScript1.2" type="text/javascript">
			<!--
				handleDatabaseMissing('#_prodName#', '#_subsysName#');
			-->
			</script>
		</cfoutput>
	<cfelseif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0)>
		<!--- BEGIN: integrate all the separate queries into the one result-set to save coding time --->
		<cfscript>
			function integrateQueries(q, num) {
				var _kk = -1;
				var _sqlCode = '';
				var tempQry1 = -1;
				var _columList_ = '';
				var _ko = '';
				var _ki = -1;
				var _kx = -1;
				var _val = '';
				var newDataArray = -1;
				var isErr = false;
				
				if ( (IsQuery(q)) AND (num gt 0) ) {
					_columList_ = q.columnList;
					for (_kk = 1; _kk lte num; _kk =_kk + 1) {
						if (NOT IsDefined("_SQL_statement#_kk#")) {
							break;
						}
						_sqlCode = Trim(Evaluate("_SQL_statement#_kk#"));
						if (Len(_sqlCode) gt 0) {
							tempQry1 = CommonCode.safelyExecSQL(DSNUser, DSNPassword, DSNSource, _sqlCode, CreateTimeSpan(0, 0, 0, 0));
							if ( (IsDefined("tempQry1")) AND IsQuery(tempQry1) ) {
								if (tempQry1.recordCount gt 0) {
									_kx = ListLen(tempQry1.columnList, ",");
									for (_ki = 1; _ki lte _kx; _ki = _ki + 1) {
										_ko = GetToken(tempQry1.columnList, _ki, ",");
										if (UCASE(_ko) neq UCASE('status')) {
											isErr = false;
											try {
												_val = Evaluate("tempQry1.#_ko#");
											} catch (Any e) {
												isErr = true;
											}
											if (NOT isErr) {
												if (ListFindNoCase(_columList_, _ko, ",") eq 0) {
													newDataArray = ArrayNew(1);
													newDataArray[1] = _val;
													QueryAddColumn(q, _ko, newDataArray);
												} else {
													QuerySetCell(q, _ko, _val);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			
			integrateQueries(GetCurrentContent, 99);
		</cfscript>
		<!--- END! integrate all the separate queries into the one result-set to save coding time --->
	</cfif>
	
	<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (IsDefined("GetCurrentContent.menu"))>
		<cfset _menuContent = GetCurrentContent.menu>
	</cfif>
	
	<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (IsDefined("GetCurrentContent.pageList"))>
		<cfset _ContentPageList = GetCurrentContent.pageList>
	</cfif>

	<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0)>
		<cfif (IsDefined("GetCurrentContent.lockedMenu")) AND (Len(Trim(GetCurrentContent.lockedMenu)) gt 0)>
			<cfset is_locked_menuEditor = "True">
			<cfset emailLink_locked_timeString = '<font color="blue">#CommonCode.formattedDateTimeTZ(ParseDateTime(GetCurrentContent.lockedMenu))#</font>'>
		</cfif>

		<cfif (IsDefined("GetCurrentContent.lockedMenuSBCUID")) AND (Len(Trim(GetCurrentContent.lockedMenuSBCUID)) gt 0)>
			<cfif (UCASE(GetCurrentContent.lockedMenuSBCUID) neq UCASE(_AUTH_USER))>
				<cfset uid_locked_menuEditor = GetCurrentContent.lockedMenuSBCUID>
				<cfset emailLink_locked_menuEditor = CommonCode.makeMenuInUseContactUserLink(GetCurrentContent.lockedMenuSBCUID, "blue")>
			<cfelse>
				<cfset is_locked_menuEditor = "False">
				<cfset emailLink_locked_timeString = "">
			</cfif>
		</cfif>
	</cfif>
</cfif>

<!--- BEGIN: This block of code is needed to "bounce" the user back to the home page in case the Menu editor is locked - user got here by means that are not allowed... --->
<cfif ( (function eq _htmlMenuEditorAction_symbol) OR (CommonCode.is_htmlArea_editor()) ) AND (is_locked_menuEditor)>
	<cfset p_aURL = "#CGI.SCRIPT_NAME##Request.first_splashscreen_inhibitor#">
	<cfif (CommonCode.is_htmlArea_editor())>
		<cfset p_aURL = "#backUrl#">
	</cfif>
	<cfset _aURL = "#p_aURL##_currentPage_symbol##URLEncodedFormat(currentPage)#">
	<cflocation url="#_aURL#" addtoken="No">
</cfif>
<!--- END! This block of code is needed to "bounce" the user back to the home page in case the Menu editor is locked - user got here by means that are not allowed... --->

<cfset _SQL_statement = "
	SELECT id, headline, article_text, begin_dt, end_dt
	FROM #_MarqueeScrollerData#
	ORDER BY begin_dt, end_dt
">

<cfif Len(_SQL_statement) gt 0>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetEditableMarqueeContent" datasource="#DSNSource#" cachedwithin="#CreateTimeSpan(0, 0, 0, 10)#">
		#PreserveSingleQuotes(_SQL_statement)#
	</cfquery>
</cfif>

<cfset _SQL_statement2 = "
	SELECT DISTINCT TOP 1
		#_ReleaseManagement#.id, 
	    #_ReleaseManagement#.releaseNumber, 
	    #_ReleaseManagement#.uid, 
	    #_ReleaseManagement#.stageDateTime 
	FROM #_ReleaseManagement#
	WHERE (#_ReleaseManagement#.stageDateTime IS NOT NULL)
	ORDER BY #_ReleaseManagement#.stageDateTime DESC;
">

<cfif (IsDefined("_SQL_statement2")) AND (Len(_SQL_statement2) gt 0)>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetLatestStagedReleases" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement2)#
	</cfquery>
</cfif>


