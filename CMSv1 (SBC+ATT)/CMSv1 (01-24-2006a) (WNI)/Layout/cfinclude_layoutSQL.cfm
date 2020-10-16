<cfset _timeString = CommonCode.formattedDateTimeTZ(Now())>
<cfset _formattedString = "on #_timeString#">

<cfset _SBCUID = "">
<cfif (IsDefined("VerifyUserSecurity2.userid"))>
	<cfset _SBCUID = "#VerifyUserSecurity2.userid#">
</cfif>

<!--- BEGIN: Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->
<cfif (IsDefined("_submit_")) AND (Len(Trim(submit)) eq 0)>
	<cfset submit = _submit_>
</cfif>
<!--- END! Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->

<cfif (submit eq layoutSaveAction_symbol)>
	<cfif (NOT _editable_layout_change_name)>
		<cfset _layout_id = -1>
	</cfif>

	<cfif (_layout_id gt -1)>
		<cfset _SQL_layout_name = "">
		<cfif (IsDefined("_editable_layout_name"))>
			<cfset _SQL_layout_name = "layout_name = '#_editable_layout_name#',">
			<cfset _editable_layout_name = Replace(URLDecode(_editable_layout_name), "'", "''", "all")>
		<cfelse>
			<cfset _editable_layout_name = "Default Layout">
			<cfset _SQL_layout_name = "layout_name = '#_editable_layout_name#',">
		</cfif>
		<!--- BEGIN: Perform an Update --->
		<cfset _SQL_statement = "#_SQL_statement#
			DECLARE @old_name as varchar(128);
			SELECT @old_name = (SELECT TOP 1 layout_name FROM #_LayoutManagement# WHERE (id = #_layout_id#));

			UPDATE #_LayoutManagement# 
				SET #_SQL_layout_name# layout_spec = '#_editable_layout_spec#'
			WHERE (id = #_layout_id#);

			DECLARE @spid as int;
			SELECT @spid = (SELECT TOP 1 id FROM #_LayoutManagement# WHERE (layout_name = '#_editable_layout_name#') ORDER BY id desc);

			DECLARE @new_name as varchar(128);
			SELECT @new_name = (SELECT TOP 1 layout_name FROM #_LayoutManagement# WHERE (id = #_layout_id#));
			IF @new_name <> @old_name
			BEGIN
				DECLARE @msg as varchar(256);
				SELECT @msg = 'SBCUID #_SBCUID#: Updated Layout with new name, name was [' + @old_name + '], name now is [' + @new_name + '] #_formattedString#';
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),@msg);
			END;

			SELECT @spid = (SELECT TOP 1 id FROM #_LayoutManagement# WHERE (layout_name = '#_editable_layout_name#') ORDER BY id desc);

			IF @spid IS NOT NULL
			BEGIN
				UPDATE #_ReleaseManagement# SET layout_id = @spid WHERE (id = @prid);
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #_SBCUID#: Updated Layout [#_editable_layout_name#] #_formattedString#');
			END;
		">
		<!--- END! Perform an Update --->
	<cfelse>
		<cfif (NOT IsDefined("_editable_layout_name")) OR (Len(Trim(_editable_layout_name)) eq 0)>
			<cfset _editable_layout_name = CreateUUID()>
		</cfif>
		<!--- BEGIN: Perform a New Save --->
		<cfset _SQL_statement = "#_SQL_statement#
			INSERT INTO #_LayoutManagement#
			    (layout_name, layout_spec)
			VALUES ('#_editable_layout_name#','#_editable_layout_spec#');
			
			DECLARE @spid as int;
			SELECT @spid = (SELECT TOP 1 id FROM #_LayoutManagement# WHERE (layout_name = '#_editable_layout_name#') ORDER BY id desc);
			
			IF @spid IS NOT NULL
			BEGIN
				UPDATE #_ReleaseManagement# SET layout_id = @spid WHERE (id = @prid);
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #_SBCUID#: Saved New Layout [#_editable_layout_name#] #_formattedString#');
			END;
		">
		<!--- END! Perform a New Save --->
	</cfif>
<cfelseif (submit eq layoutUseItAction_symbol)>
	<cfif (_layout_id gt -1)>
		<!--- BEGIN: Perform a New Save --->
		<cfset _msg = "Associated Layout [#_editable_layout_name#] with this Release">
		<cfset _SQL_statement = "#_SQL_statement#
			UPDATE #_ReleaseManagement# SET layout_id = #_layout_id# WHERE (id = @prid);
			INSERT INTO #_ReleaseManagementComments# (rid, aDateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #_SBCUID# : #_msg#.');
			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #_SBCUID#: #_msg# #_formattedString#');
		">
		<!--- END! Perform a New Save --->
	</cfif>
<cfelseif (submit eq swapSidesEditorAction_symbol)>
	<cfset _SQL_statement = "#_SQL_statement#
		DECLARE @tpid as int;
		SELECT @tpid = -1;

		DECLARE @pid as int;
		SELECT @pid = (SELECT TOP 1 pageId FROM #_DynamicHTMLright_side# WHERE (rid = @prid) ORDER BY pageId desc);
		
		INSERT INTO #_DynamicHTMLright_side# (pageId, html, rid)
			SELECT @tpid, html, rid
			FROM #_DynamicHTMLpad#
			WHERE (rid = @prid) AND (pageId <> @tpid);

		DECLARE @pid2 as int;
		SELECT @pid2 = (SELECT TOP 1 pageId FROM #_DynamicHTMLpad# WHERE (rid = @prid) ORDER BY pageId desc);

		INSERT INTO #_DynamicHTMLpad# (pageId, html, rid)
			SELECT @tpid, html, rid
			FROM #_DynamicHTMLright_side#
			WHERE (rid = @prid) AND (pageId <> @tpid);
			
		DELETE FROM #_DynamicHTMLright_side#
		WHERE (rid = @prid) AND (pageId = @pid);

		DELETE FROM #_DynamicHTMLpad#
		WHERE (rid = @prid) AND (pageId = @pid2);
		
		UPDATE #_DynamicHTMLright_side# SET pageId = @pid WHERE (rid = @prid) AND (pageId = @tpid);

		UPDATE #_DynamicHTMLpad# SET pageId = @pid2 WHERE (rid = @prid) AND (pageId = @tpid);
		
		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #_SBCUID#: Performed Layout :: [#function#] #_formattedString#');
	">
<cfelseif (submit eq layoutSaveAction_symbol) AND 0>
	<cfoutput>
	[#submit#] [#Len(current_LayoutSpec)#]<br>
	<textarea cols="100" rows="5" style="font-size: 10px;">#current_LayoutSpec#</textarea>
	</cfoutput>

	<cfset _current_LayoutSpec = URLEncodedFormat(Replace(current_LayoutSpec, "'", "''", "all"))>
	<cfset _SQL_statement = "#_SQL_statement#
		DECLARE @spid as int;
		SELECT @spid = (SELECT TOP 1 id FROM #_DynamicLayoutSpecification# WHERE (rid = @prid) ORDER BY id desc);

		IF @spid IS NULL
			INSERT INTO #_DynamicLayoutSpecification# (layout_vc, rid) VALUES ('#_current_LayoutSpec#',@prid);
		ELSE
			UPDATE #_DynamicLayoutSpecification# SET layout_vc = '#_current_LayoutSpec#' WHERE (rid = @prid) AND (id = @spid);
	">
</cfif>

<!--- BEGIN: Save the comments if they have been defined... --->
<cfif (IsDefined("_comments")) AND (Len(Trim(_comments)) gt 0)>
	<cfset _comments = Replace(_comments, "'", "''", "all")>
	<cfset _editable_layout_name = Replace(URLDecode(_editable_layout_name), "'", "''", "all")>
	<cfset _pageName_ = '"#_editable_layout_name#"'>
	<cfset _pageComments_ = "Layout Name #_pageName_# :: #_comments#">
	<cfset _SQL_ = CommonCode.sql_saveReleaseComments(_pageComments_, _ReleaseManagementComments, _ReleaseActivityLog, _rid, VerifyUserSecurity2.userid, "while editing layout named #_pageName_# on #_timeString#")>
	<cfset _SQL_statement = "#_SQL_statement##_SQL_#">
</cfif>
<!--- END! Save the comments if they have been defined... --->

<!--- BEGIN: Collect up the Layouts for the Tabbed Interface --->
<cfset _SQL_statement = "#_SQL_statement#
	DECLARE @sdid as int;
	SELECT @sdid = (SELECT TOP 1 id FROM #_LayoutManagement# WHERE (layout_name = '#const_Default_Layout_name_symbol#') ORDER BY id desc);

	SELECT id, layout_name, layout_spec, 1 as sort_order, @sdid as sdid
	FROM #_LayoutManagement#
	ORDER BY layout_name;
">
<!--- END! Collect up the Layouts for the Tabbed Interface --->

<cfif (IsDefined("_SQL_statement")) AND (Len(_SQL_statement) gt 0)>
	<cfif (submit eq layoutSaveAction_symbol)>
		<cfscript>
			GetLayoutData = CommonCode.safelyExecSQL(DSNUser, DSNPassword, DSNSource, _SQL_statement, CreateTimeSpan(0, 0, 0, 10));
		</cfscript>

		<cfif ( (IsDefined("GetLayoutData")) AND (IsDefined("GetLayoutData.status")) AND (GetLayoutData.status LT -1) )>
			<cfset _debugInfo = "">
			<cfif (CommonCode.isServerLocal())>
				<cfset _debugInfo = " \nGetLayoutData.status = [#GetLayoutData.status#]">
			</cfif>
			<cfset _aURL = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">
			<cfoutput>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					alert("Layout Name of #_editable_layout_name# is already in the database and CANNOT be saved a second time.\nPlease edit the Layout Name and try again.#_debugInfo#");
					window.location.href = '#_aURL#';
				-->
				</script>
			</cfoutput>
		</cfif>
	<cfelse>
		<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetLayoutData" datasource="#DSNSource#">
			#PreserveSingleQuotes(_SQL_statement)#
		</cfquery>
	</cfif>
</cfif>

<cfif ( (submit eq layoutSaveAction_symbol) OR (submit eq layoutUseItAction_symbol) OR (submit eq swapSidesEditorAction_symbol) )>
	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
			<!--
			  window.location.href = '#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#';
			-->
		</script>
	</cfoutput>
</cfif>

<cfif (IsDefined("GetLayoutData")) AND (GetLayoutData.recordCount gt 0) AND (IsDefined("GetLayoutData.layout_name"))>
	<cfloop query="GetLayoutData" startrow="1" endrow="#GetLayoutData.recordCount#">
		<cfif (UCASE(TRIM(GetLayoutData.layout_name)) eq UCASE(TRIM(const_Default_Layout_name_symbol)))>
			<cfset tmp = QuerySetCell(GetLayoutData, "sort_order", 0, GetLayoutData.currentRow)>
			<cfbreak>
		</cfif>
	</cfloop>

	<CFQUERY dbtype="query" name="GetDefaultLayoutList">
		SELECT id, layout_name, layout_spec, sort_order, sdid
		FROM GetLayoutData
		ORDER BY sort_order
	</cfquery>
</cfif>
