<cfset _delayed_window_location_href = "">

<cfset _timeString = CommonCode.formattedDateTimeTZ(Now())>

<cfparam name="_SQL_statement" type="string" default="">

<cfset _aSQLStatement = CommonCode.sql_getCurrentRelease_rid( _adminMode, _ReleaseManagement)>
<cfset _SQL_statement = "#_SQL_statement##_aSQLStatement#">

<cfparam name="__SQL_statement" type="string" default="">

<!--- BEGIN: Not sure why this is required when running on the localhost... but it seems to be... --->
<cfif (CommonCode.isServerLocal()) AND (FindNoCase(Chr(194), submit) gt 0)>
	<cfset submit = ReplaceNoCase(submit, Chr(194), "")>
</cfif>
<!--- END! Not sure why this is required when running on the localhost... but it seems to be... --->

<!--- BEGIN: Inside this block of code the SQL statements need to be collected into the variable __SQL_statement because they need to do inside a block of T-SQL code that only executes them when there is a valid Release (such as a Draft) --->
<cfif (GetToken(submit, 1, "|") eq _editorAction_symbol)>
	<cfset _contentTableName = _DynamicHTMLContent>
	<cfif (GetToken(submit, 2, "|") eq siteCSSPage_symbol)>
		<cfset _contentTableName = _DynamicHTMLpad>
	</cfif>
	
	<cfset _pageContent = Replace(_pageContent, "'", "''", "all")>

	<cfset _user_may_change_pageName = "False">
	<cfset _pageTitle = Replace(_pageTitle, "'", "''", "all")>
	<cfif (Len(pageName) eq 0)>
		<cfset _user_may_change_pageName = "True">
		<cfset pageName = CommonCode.mungePageTitleIntoPageName(_pageTitle)>
	</cfif>
	<cfif (_user_may_change_pageName)>
	</cfif>
	<cfset pageName = Replace(pageName, "'", "''", "all")>

	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>

	<cfset __SQL_statement = "#__SQL_statement#
		DECLARE @newPageFlag int;
		DECLARE @pidNew int;
		DECLARE @pidOld int;
		DECLARE @ppid int;
		DECLARE @pidNew_id int;

		SELECT @newPageFlag = 0;
		
		SELECT @pidOld = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#pageName#') AND (rid = @prid) ORDER BY #_DynamicPageManagement#.versionDateTime DESC);
		IF @pidOld IS NULL
		BEGIN
			SELECT @pidOld = (SELECT DISTINCT TOP 1 pageId FROM #_DynamicPageManagement# ORDER BY pageId DESC);
			SELECT @pidOld = (@pidOld + 1);
			SELECT @newPageFlag = 1;
		END
	">
	<cfif (_user_may_change_pageName)>
		<cfset __SQL_statement = "#__SQL_statement#
			INSERT INTO #_DynamicPageManagement# (pageId, pageName, PageTitle, versionDateTime, rid) VALUES (@pidOld,'#pageName#', '#_pageTitle#', #CreateODBCDateTime(Now())#, @prid);
			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Defined Page Title as (#_pageTitle#) #_timeString#');
		">
	<cfelseif (Len(Trim(s_readOnly)) eq 0)>
		<!--- BEGIN: Users can only change the Page Title when the page title can be edited which means this is not an invisible page title --->
		<cfset __SQL_statement = "#__SQL_statement#
			UPDATE #_DynamicPageManagement# SET PageTitle = '#_pageTitle#', versionDateTime = #CreateODBCDateTime(Now())# WHERE ( (pageId = @pidOld) AND (rid = @prid) );
			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Changed Page Title to (#_pageTitle#) #_timeString#');
		">
		<!--- END! Users can only change the Page Title when the page title can be edited which means this is not an invisible page title --->
	</cfif>
	<cfset __SQL_statement = "#__SQL_statement#
		SELECT @pidNew = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#pageName#') AND (rid = @prid) ORDER BY #_DynamicPageManagement#.versionDateTime DESC);
		SELECT @pidNew_id = (SELECT TOP 1 id FROM #_DynamicPageManagement# WHERE (pageId = @pidNew) AND (rid = @prid) ORDER BY #_DynamicPageManagement#.versionDateTime DESC);
		IF @newPageFlag = 0
			UPDATE #_contentTableName# SET html = '#_pageContent#', pageId = @pidNew WHERE (pageId = @pidOld) AND (rid = @prid);
		ELSE
			INSERT INTO #_contentTableName# (pageId, html, rid) VALUES (@pidNew,'#_pageContent#',@prid);

		DECLARE @pid as int;
		SELECT @pid = (SELECT TOP 1 id FROM #_ContentList# WHERE (pageName = '#pageName#'));
		IF @pid IS NULL
			INSERT INTO #_ContentList# (pageName) VALUES ('#pageName#');
		SELECT @pid = (SELECT TOP 1 id FROM #_ContentList# WHERE (pageName = '#pageName#'));
			
		DECLARE @val as int;
		SELECT @val = (SELECT TOP 1 id FROM #_ContentSecurity# WHERE (pid = @pid) AND (uid = #VerifyUserSecurity2.uid#));
		
		IF @val IS NULL
			INSERT INTO #_ContentSecurity# (pid, uid) VALUES (@pid,#VerifyUserSecurity2.uid#);
		ELSE
			UPDATE #_ContentSecurity# SET pid = @pid, uid = #VerifyUserSecurity2.uid# WHERE (id = @val);

		IF (@prid IS NOT NULL) AND (@pidNew IS NOT NULL) AND (@pidNew_id IS NOT NULL) AND (@pidNew <> @pidOld)
			DELETE FROM #_DynamicPageManagement#
				WHERE (rid = @prid) AND (PageId = @pidNew) AND (id <> @pidNew_id);
	">
<cfelseif (submit eq quickLinksEditorAction_symbol)>
	<cfset pageName = Replace(pageName, "'", "''", "all")>
	<cfset _pageContent = Replace(_pageContent, "'", "''", "all")>

	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>

	<cfset __SQL_statement = "#__SQL_statement#
		DECLARE @pid int;
		SELECT @pid = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#pageName#') AND (rid = @prid));
		IF @pid IS NOT NULL
			UPDATE #_DynamicHTMLpad# SET html = '#_pageContent#' WHERE (pageId = @pid) AND (rid = @prid);
	">
<cfelseif (submit eq sepg_sectionEditorAction_symbol)>
	<cfset pageName = Replace(pageName, "'", "''", "all")>
	<cfset _pageContent = Replace(_pageContent, "'", "''", "all")>

	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>

	<cfset __SQL_statement = "#__SQL_statement#
		DECLARE @pid int;
		SELECT @pid = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#pageName#') AND (rid = @prid));
		IF @pid IS NOT NULL
			UPDATE #_DynamicHTMLsepg_section# SET html = '#_pageContent#' WHERE (pageId = @pid) AND (rid = @prid);
	">
<cfelseif (submit eq sepg_linksEditorAction_symbol)>
	<cfset pageName = Replace(pageName, "'", "''", "all")>
	<cfset _pageContent = Replace(_pageContent, "'", "''", "all")>

	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>

	<cfset __SQL_statement = "#__SQL_statement#
		DECLARE @pid int;
		SELECT @pid = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#pageName#') AND (rid = @prid));
		IF @pid IS NOT NULL
			UPDATE #_DynamicHTMLsepg_links# SET html = '#_pageContent#' WHERE (pageId = @pid) AND (rid = @prid);
	">
<cfelseif (submit eq right_sideEditorAction_symbol)>
	<cfset pageName = Replace(pageName, "'", "''", "all")>
	<cfset _pageContent = Replace(_pageContent, "'", "''", "all")>

	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>

	<cfset __SQL_statement = "#__SQL_statement#
		DECLARE @pid int;
		SELECT @pid = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#pageName#') AND (rid = @prid));
		IF @pid IS NOT NULL
			UPDATE #_DynamicHTMLright_side# SET html = '#_pageContent#' WHERE (pageId = @pid) AND (rid = @prid);
	">
<cfelseif (submit eq footerEditorAction_symbol)>
	<cfset pageName = Replace(pageName, "'", "''", "all")>
	<cfset _pageContent = Replace(_pageContent, "'", "''", "all")>

	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
	<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>

	<cfset __SQL_statement = "#__SQL_statement#
		DECLARE @pid int;
		SELECT @pid = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#pageName#') AND (rid = @prid));
		IF @pid IS NOT NULL
			UPDATE #_DynamicHTMLfooter# SET html = '#_pageContent#' WHERE (pageId = @pid) AND (rid = @prid);
	">
<cfelseif ( (function eq _menuEditorAction_symbol) OR (function eq _menuTableEditorAction_symbol) ) OR ( (GetToken(function, 1, "@") eq _menuEditorAction_symbol) OR (GetToken(function, 1, "@") eq _menuTableEditorAction_symbol) ) AND ( ( (GetToken(function, 2, "@") eq _editorMenuAddAction_symbol) AND (Len(submitButton) gt 0) ) OR ( (GetToken(function, 2, "@") eq _editorMenuEditAction_symbol) AND (Len(submitButton) gt 0) ) OR ( (GetToken(function, 2, "@") eq _editorMenuAddSubMenuAction_symbol) AND (Len(submitButton) gt 0) ) OR (GetToken(function, 2, "@") eq _editorMenuEditSubMenuAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuDropAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuAddCloseSubMenuAction_symbol) OR (GetToken(function, 2, "@") eq _reorganizeMenuDnAction_symbol) OR (GetToken(function, 2, "@") eq _reorganizeMenuUpAction_symbol) OR (GetToken(function, 2, "@") eq _reorganizeSubMenuDnAction_symbol) OR (GetToken(function, 2, "@") eq _reorganizeSubMenuUpAction_symbol) )>
	<cfset __SQL_statement = "#__SQL_statement#
		DECLARE @_menuPageId as varchar(50);
		SELECT @_menuPageId = (SELECT TOP 1 pageId FROM #_DynamicHTMLmenu# WHERE (rid = @prid));

		SELECT TOP 1
		    #_DynamicHTMLmenu#.html AS menu
		FROM #_DynamicHTMLmenu#
		WHERE ((#_DynamicHTMLmenu#.rid = @prid) AND 
		    (#_DynamicHTMLmenu#.pageId = @_menuPageId));
	">
<cfelseif ( (GetToken(function, 1, "@") eq _menuEditorAction_symbol) OR (GetToken(function, 1, "@") eq _menuTableEditorAction_symbol) ) AND ( (GetToken(function, 2, "@") eq _editorMenuAddAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuEditAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuAddSubMenuAction_symbol) )>
	<cfset __SQL_statement = "#__SQL_statement#
		SELECT #_DynamicPageManagement#.pageName, 
		    DynamicPageManagement1.PageTitle, 
		    DynamicPageManagement1.versionDateTime,
    		DynamicPageManagement1.pageId			
		FROM #_DynamicHTMLContent# INNER JOIN
		    #_DynamicPageManagement# ON 
		    #_DynamicHTMLContent#.pageId = #_DynamicPageManagement#.pageId
		     AND 
		    #_DynamicHTMLContent#.rid = #_DynamicPageManagement#.rid
		     INNER JOIN
		    #_DynamicPageManagement# DynamicPageManagement1 ON 
		    #_DynamicPageManagement#.id = DynamicPageManagement1.id
		WHERE (#_DynamicHTMLContent#.rid = @prid) 
			AND (#_DynamicPageManagement#.pageName NOT IN (#PreserveSingleQuotes(_notLinkables)#))
		ORDER BY #_DynamicPageManagement#.pageName, 
		    DynamicPageManagement1.versionDateTime DESC
	">
<cfelseif (function eq _htmlEditorNewPageAction_symbol)>
	<!--- BEGIN: Get a list of existing pages so we can ensure the user is entering a unique new page name --->
	<cfset __SQL_statement = "#__SQL_statement#
		SELECT DISTINCT pageName
		FROM #_DynamicPageManagement#
		WHERE (pageName IS NOT NULL) AND (Len(pageName) > 0)
		ORDER BY pageName;
	">
	<!--- END! Get a list of existing pages so we can ensure the user is entering a unique new page name --->
<cfelseif (function eq _htmlMenuEditorAction_symbol)>
	<!--- BEGIN: Determine if the current user can be granted access to the Menu Editor --->
	<cfset __SQL_statement = "#__SQL_statement#
		DECLARE @locked as datetime;
		SELECT @locked = (SELECT TOP 1 d_locked FROM #_MenuEditorAccess# WHERE (uid = #VerifyUserSecurity2.uid#));
		
		IF @locked IS NULL
		BEGIN
			INSERT INTO #_MenuEditorAccess# (uid, d_locked) VALUES (#VerifyUserSecurity2.uid#,GETDATE());
			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Locked Menu Editor for updates on #_timeString#');
		END;

		SELECT TOP 1 #_MenuEditorAccess#.uid, 
		    #_MenuEditorAccess#.d_locked, 
		    #_MenuEditorAccess#.id, 
		    #_UserSecurity#.userid
		FROM #_MenuEditorAccess# INNER JOIN
		    #_UserSecurity# ON 
		    #_MenuEditorAccess#.uid = #_UserSecurity#.id;
	">
	<!--- END! Get a list of existing pages so we can ensure the user is entering a unique new page name --->
<cfelseif (submit eq _htmlMenuCommitAction_symbol)>
	<cfif (IsDefined("menu_container")) AND (Len(menu_container) gt 0)>
		<cfset _aSQLStatement = CommonCode.sql_saveSiteMenu( menu_container, _DynamicPageManagement, _DynamicHTMLmenu)>
		<cfset __SQL_statement = "#__SQL_statement##CR##_aSQLStatement#">
		<cfset __SQL_statement = "#__SQL_statement#
			DELETE FROM #_MenuEditorAccess#;

			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Released Menu Editor Lock upon saving Menu Changes on #_timeString#');
		">
	</cfif>
	<cfset _isInitMode = "False">
	<cfif (IsDefined("menu_color")) AND (Len(menu_color) gt 0)>
		<cfif (NOT _isInitMode)>
			<cfset _isInitMode = "True">
		</cfif>
		<cfset _aSQL_ = CommonCode.sql_saveMenuColor(_isInitMode, menuColorPage_symbol, menu_color, VerifyUserSecurity2.userid, _DynamicPageManagement, _DynamicHTMLpad, _ReleaseActivityLog)>
		<cfset __SQL_statement = "#__SQL_statement##_aSQL_#">
	</cfif>
	<cfif (IsDefined("menu_text_color")) AND (Len(menu_text_color) gt 0)>
		<cfif (NOT _isInitMode)>
			<cfset _isInitMode = "True">
		<cfelse>
			<cfset _isInitMode = "False">
		</cfif>
		<cfset _aSQL_ = CommonCode.sql_saveMenuColor(_isInitMode, menuTextColorPage_symbol, menu_text_color, VerifyUserSecurity2.userid, _DynamicPageManagement, _DynamicHTMLpad, _ReleaseActivityLog)>
		<cfset __SQL_statement = "#__SQL_statement##_aSQL_#">
	</cfif>
<cfelseif (submit eq _saveMarqueeButton_symbol)>
	<cfset _beginDate = "NULL">
	<cfif (Len(Trim(BeginDateContainer)) gt 0)>
		<cfset _beginDate = CreateODBCDateTime(ParseDateTime(BeginDateContainer))>
	</cfif>
	<cfset _endDate = "NULL">
	<cfif (Len(Trim(EndDateContainer)) gt 0)>
		<cfset _endDate = CreateODBCDateTime(ParseDateTime(EndDateContainer))>
	</cfif>
	<cfset headlineContent = Replace(headlineContent, "'", "''", "all")>
	<cfset articleContent = Replace(articleContent, "'", "''", "all")>

	<cfset headlineContent = CommonCode.correctHTMLtags( headlineContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
	<cfset headlineContent = CommonCode.correctHTMLtags( headlineContent, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>
	
	<cfset articleContent = CommonCode.correctHTMLtags( articleContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
	<cfset articleContent = CommonCode.correctHTMLtags( articleContent, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>
	
	<cfif (IsDefined("recid")) AND (recid neq -1)>
		<cfset __SQL_statement = "#__SQL_statement#
			UPDATE #_MarqueeScrollerData#
		">
		<cfset __SQL_statement = "#__SQL_statement#
				SET 
		">
		<cfif (Len(Trim(headlineContent)) gt 0)>
			<cfset __SQL_statement = "#__SQL_statement#
					headline = '#headlineContent#', 
			">
		</cfif>
		<cfif (Len(Trim(articleContent)) gt 0)>
			<cfset __SQL_statement = "#__SQL_statement#
					article_text = '#articleContent#', 
			">
		</cfif>
		<cfset __SQL_statement = "#__SQL_statement#
				begin_dt = #_beginDate#, end_dt = #_endDate#
		">
		<cfset __SQL_statement = "#__SQL_statement#
			WHERE (id = #recid#);
		">
	<cfelse>
		<cfset __SQL_statement = "#__SQL_statement#
			INSERT INTO #_MarqueeScrollerData# 
				(headline, article_text, begin_dt, end_dt)
				VALUES ('#Mid(headlineContent, 1, Min(Len(headlineContent), 8000))#', '#Mid(articleContent, 1, Min(Len(articleContent), 8000))#', #_beginDate#, #_endDate#);
		">
	</cfif>
<cfelseif (submit eq _removeMarqueeButton_symbol)>
	<cfif (IsDefined("recid")) AND (recid neq -1)>
		<cfset __SQL_statement = "#__SQL_statement#
			DELETE FROM #_MarqueeScrollerData#
			WHERE (id = #recid#);
		">
	</cfif>
<cfelseif (submit eq function_marqueeDataFillerLink)>  <!--- (CGI.REMOTE_HOST eq _debugIP) AND  --->
	<cfset _zz = Randomize(Second(Now()))>
	<cfloop index="_iz" from="1" to="#RandRange(9, 19)#">
		<cfset fake_headlineContent = "<STRONG><FONT size=3>Headline ##99.#_iz#</FONT></STRONG>">
		<cfset fake_articleContent = "<STRONG>Article ##99.#_iz#</STRONG>">
		<cfset fake_beginDate = CreateODBCDateTime(DateAdd("d", -RandRange(1, 9), Now()))>
		<cfset fake_endDate = CreateODBCDateTime(DateAdd("d", RandRange(1, 19), Now()))>

		<cfset __SQL_statement = "#__SQL_statement#
			INSERT INTO #_MarqueeScrollerData# 
				(headline, article_text, begin_dt, end_dt)
				VALUES ('#Mid(fake_headlineContent, 1, Min(Len(fake_headlineContent), 8000))#', '#Mid(fake_articleContent, 1, Min(Len(fake_articleContent), 8000))#', #fake_beginDate#, #fake_endDate#);
		">
	</cfloop>
</cfif>

<cfif (IsDefined("_pageComments")) AND (Len(Trim(_pageComments)) gt 0)>
	<cfset _pageComments = Replace(_pageComments, "'", "''", "all")>
	<cfset _pageName_ = '"#pageName#"'>
	<cfset _pageComments_ = "Page Name #_pageName_# :: #_pageComments#">
	<cfset _SQL_ = CommonCode.sql_saveReleaseComments(_pageComments_, _ReleaseManagementComments, _ReleaseActivityLog, _rid, VerifyUserSecurity2.userid, "while editing content for page named #_pageName_# on #_timeString#")>
	<cfset __SQL_statement = "#__SQL_statement##_SQL_#">
</cfif>
<!--- END! Inside this block of code the SQL statements need to be collected into the variable __SQL_statement because they need to do inside a block of T-SQL code that only executes them when there is a valid Release (such as a Draft) --->

<cfif (Len(__SQL_statement) gt 0)>
	<!--- BEGIN: This block of code checks the @prid value to make sure it is not null in order for T-SQL to be executed --->
	<cfset _SQL_statement = "#_SQL_statement#
		IF @prid IS NOT NULL
		BEGIN
	">
	<!--- END! This block of code checks the @prid value to make sure it is not null in order for T-SQL to be executed --->
	<cfset _SQL_statement = "#_SQL_statement##__SQL_statement#">
	<!--- BEGIN: This block of code checks the @prid value to make sure it is not null in order for T-SQL to be executed --->
	<cfset _SQL_statement = "#_SQL_statement#
		END
	">
	<!--- END! This block of code checks the @prid value to make sure it is not null in order for T-SQL to be executed --->
</cfif>

<cfset _aSQL = "
	DECLARE @aList as varchar(8000);
">

<cfinclude template="../cfinclude_GetCurrentContentList.cfm">

<cfif Len(pageName) gt 0>
	<cfset pageName = Replace(pageName, "'", "''", "all")>
	<cfset _SQL_statement = "#_SQL_statement#
		#_aSQL#
		
		DECLARE @sanityPgId as int;
		SELECT @sanityPgId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#pageName#') AND (rid = @prid) ORDER BY #_DynamicPageManagement#.versionDateTime DESC);

		DECLARE @sanityPadId as int;
		SELECT @sanityPadId = (SELECT TOP 1 id FROM #_DynamicHTMLpad# WHERE (pageId = @sanityPgId) AND (rid = @prid));

		IF @sanityPadId IS NOT NULL
			SELECT TOP 1
				@prid as prid,
				@aList as pageList,
				#_DynamicHTMLpad#.pageId, 
				#_DynamicHTMLpad#.html, 
				#_DynamicPageManagement#.id,
				#_DynamicPageManagement#.PageTitle,
				#_DynamicPageManagement#.versionDateTime
			FROM #_DynamicPageManagement# LEFT OUTER JOIN
				#_DynamicHTMLpad# ON 
				#_DynamicPageManagement#.pageId = #_DynamicHTMLpad#.pageId
			WHERE ((#_DynamicPageManagement#.pageName = '#pageName#') AND (#_DynamicPageManagement#.pageId = @sanityPgId) AND (#_DynamicHTMLpad#.rid = @prid))
			ORDER BY #_DynamicPageManagement#.versionDateTime DESC

		DECLARE @sanityContentId as int;
		SELECT @sanityContentId = (SELECT TOP 1 id FROM #_DynamicHTMLContent# WHERE (pageId = @sanityPgId) AND (rid = @prid));

		IF @sanityContentId IS NOT NULL
			SELECT TOP 1
				@prid as prid,
				@aList as pageList,
				#_DynamicHTMLContent#.pageId, 
				#_DynamicHTMLContent#.html, 
				#_DynamicPageManagement#.id,
				#_DynamicPageManagement#.PageTitle,
				#_DynamicPageManagement#.versionDateTime
			FROM #_DynamicPageManagement# LEFT OUTER JOIN
				#_DynamicHTMLContent# ON 
				#_DynamicPageManagement#.pageId = #_DynamicHTMLContent#.pageId
			WHERE ((#_DynamicPageManagement#.pageName = '#pageName#') AND (#_DynamicPageManagement#.pageId = @sanityPgId) AND (#_DynamicHTMLContent#.rid = @prid))
			ORDER BY #_DynamicPageManagement#.versionDateTime DESC

		DECLARE @sanityFooterId as int;
		SELECT @sanityFooterId = (SELECT TOP 1 id FROM #_DynamicHTMLfooter# WHERE (pageId = @sanityPgId) AND (rid = @prid));

		IF @sanityFooterId IS NOT NULL
			SELECT TOP 1
				@prid as prid,
				@aList as pageList,
				#_DynamicHTMLfooter#.pageId, 
				#_DynamicHTMLfooter#.html, 
				#_DynamicPageManagement#.id,
				#_DynamicPageManagement#.PageTitle,
				#_DynamicPageManagement#.versionDateTime
			FROM #_DynamicPageManagement# LEFT OUTER JOIN
				#_DynamicHTMLfooter# ON 
				#_DynamicPageManagement#.pageId = #_DynamicHTMLfooter#.pageId
			WHERE ((#_DynamicPageManagement#.pageName = '#pageName#') AND (#_DynamicPageManagement#.pageId = @sanityPgId) AND (#_DynamicHTMLfooter#.rid = @prid))
			ORDER BY #_DynamicPageManagement#.versionDateTime DESC

		DECLARE @sanityMenuId as int;
		SELECT @sanityMenuId = (SELECT TOP 1 id FROM #_DynamicHTMLmenu# WHERE (pageId = @sanityPgId) AND (rid = @prid));

		IF @sanityMenuId IS NOT NULL
			SELECT TOP 1
				@prid as prid,
				@aList as pageList,
				#_DynamicHTMLmenu#.pageId, 
				#_DynamicHTMLmenu#.html, 
				#_DynamicPageManagement#.id,
				#_DynamicPageManagement#.PageTitle,
				#_DynamicPageManagement#.versionDateTime
			FROM #_DynamicPageManagement# LEFT OUTER JOIN
				#_DynamicHTMLmenu# ON 
				#_DynamicPageManagement#.pageId = #_DynamicHTMLmenu#.pageId
			WHERE ((#_DynamicPageManagement#.pageName = '#pageName#') AND (#_DynamicPageManagement#.pageId = @sanityPgId) AND (#_DynamicHTMLmenu#.rid = @prid))
			ORDER BY #_DynamicPageManagement#.versionDateTime DESC

		DECLARE @sanityRightId as int;
		SELECT @sanityRightId = (SELECT TOP 1 id FROM #_DynamicHTMLright_side# WHERE (pageId = @sanityPgId) AND (rid = @prid));

		IF @sanityRightId IS NOT NULL
			SELECT TOP 1
				@prid as prid,
				@aList as pageList,
				#_DynamicHTMLright_side#.pageId, 
				#_DynamicHTMLright_side#.html, 
				#_DynamicPageManagement#.id,
				#_DynamicPageManagement#.PageTitle,
				#_DynamicPageManagement#.versionDateTime
			FROM #_DynamicPageManagement# LEFT OUTER JOIN
				#_DynamicHTMLright_side# ON 
				#_DynamicPageManagement#.pageId = #_DynamicHTMLright_side#.pageId
			WHERE ((#_DynamicPageManagement#.pageName = '#pageName#') AND (#_DynamicPageManagement#.pageId = @sanityPgId) AND (#_DynamicHTMLright_side#.rid = @prid))
			ORDER BY #_DynamicPageManagement#.versionDateTime DESC

		DECLARE @sanitySepgId as int;
		SELECT @sanitySepgId = (SELECT TOP 1 id FROM #_DynamicHTMLsepg_links# WHERE (pageId = @sanityPgId) AND (rid = @prid));

		IF @sanitySepgId IS NOT NULL
			SELECT TOP 1
				@prid as prid,
				@aList as pageList,
				#_DynamicHTMLsepg_links#.pageId, 
				#_DynamicHTMLsepg_links#.html, 
				#_DynamicPageManagement#.id,
				#_DynamicPageManagement#.PageTitle,
				#_DynamicPageManagement#.versionDateTime
			FROM #_DynamicPageManagement# LEFT OUTER JOIN
				#_DynamicHTMLsepg_links# ON 
				#_DynamicPageManagement#.pageId = #_DynamicHTMLsepg_links#.pageId
			WHERE ((#_DynamicPageManagement#.pageName = '#pageName#') AND (#_DynamicPageManagement#.pageId = @sanityPgId) AND (#_DynamicHTMLsepg_links#.rid = @prid))
			ORDER BY #_DynamicPageManagement#.versionDateTime DESC

		DECLARE @sanitySepgSectId as int;
		SELECT @sanitySepgSectId = (SELECT TOP 1 id FROM #_DynamicHTMLsepg_section# WHERE (pageId = @sanityPgId) AND (rid = @prid));

		IF @sanitySepgSectId IS NOT NULL
			SELECT TOP 1
				@prid as prid,
				@aList as pageList,
				#_DynamicHTMLsepg_section#.pageId, 
				#_DynamicHTMLsepg_section#.html, 
				#_DynamicPageManagement#.id,
				#_DynamicPageManagement#.PageTitle,
				#_DynamicPageManagement#.versionDateTime
			FROM #_DynamicPageManagement# LEFT OUTER JOIN
				#_DynamicHTMLsepg_section# ON 
				#_DynamicPageManagement#.pageId = #_DynamicHTMLsepg_section#.pageId
			WHERE ((#_DynamicPageManagement#.pageName = '#pageName#') AND (#_DynamicPageManagement#.pageId = @sanityPgId) AND (#_DynamicHTMLsepg_section#.rid = @prid))
			ORDER BY #_DynamicPageManagement#.versionDateTime DESC
	">
</cfif>

<cfif Len(_SQL_statement) gt 0>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetEditableContent" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement)#
	</cfquery>

	<cfif (IsDefined("GetEditableContent")) AND (GetEditableContent.recordCount gt 0) AND (IsDefined("GetEditableContent.menu"))>
		<cfset _menuContent = GetEditableContent.menu>
	</cfif>
	
	<cfif (IsDefined("GetEditableContent")) AND (GetEditableContent.recordCount gt 0) AND (IsDefined("GetEditableContent.pageList"))>
		<cfset _ContentPageList = GetEditableContent.pageList>
	</cfif>
</cfif>

<cfif ( (bool_missing_draft_condition) AND (Len(__SQL_statement) gt 0) )>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		alert('WARNING: User attempted to change the Draft Release but there is NO DRAFT - changes were NOT saved to the database.');
	-->
	</script>
</cfif>
