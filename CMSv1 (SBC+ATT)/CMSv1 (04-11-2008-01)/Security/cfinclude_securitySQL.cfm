<cfset _inhibit_database_actions = "False">
<cfif ( (GetToken(function, 1, "@") eq _addUserAction_symbol) OR (GetToken(function, 1, "@") eq _editUserAction_symbol) ) AND (GetToken(function, 2, "@") eq _lookupUserAction_symbol)>
	<cfset _inhibit_database_actions = "True">
</cfif>

<!--- BEGIN: Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->
<cfif (IsDefined("_submit_")) AND (Len(Trim(submit)) eq 0)>
	<cfset submit = _submit_>
</cfif>
<!--- END! Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->

<cfset _timeString = CommonCode.formattedDateTimeTZ(Now())>

<cfset _aSQL = CommonCode.sql_getCurrentRelease_rid( _SecurityMode, _ReleaseManagement)>

<cfparam name="__SQL_statement" type="string" default="">

<cfset _SQL_statement3_subsystems_users = "">
<cfset _SQL_statement3_content_users = "">

<cfset _SQL_statement = "#_SQL_statement##_aSQL#">

<cfset _SQL_statement1 = "">

<cfset _MasterSubSystemList = "">

<cfset _np = "">
<cfset _npi = 1>
<cfset _npimax = ListLen(GetTemplatePath(), "\") - 2>
<cfloop index="_it" list="#GetTemplatePath()#" delimiters="\">
	<cfif (_npi lte _npimax)>
		<cfset _np = "#_np##_it#\">
	</cfif>
	<cfset _npi = IncrementValue(_npi)>
</cfloop>
<cfset _cf = ListGetAt(GetTemplatePath(), _npimax + 1, "\")>

<cfdirectory 
   directory="#GetDirectoryFromPath(_np)#"
   name="myDirectory"
   sort="name ASC, size DESC">
<cfloop query="myDirectory" startrow="1" endrow="#myDirectory.recordCount#">
	<cfif (UCASE(myDirectory.type) eq UCASE(_directory_type_symbol)) AND (FileExists("#_np##myDirectory.name#\#_index_cfm_fileName#")) AND (UCASE(myDirectory.name) neq UCASE(_cf))>
		<cfif (UCASE(myDirectory.name) neq UCASE(const_TempAdmin_symbol))>
			<cfset _MasterSubSystemList = ListAppend(_MasterSubSystemList, "#myDirectory.name#", ",")>
		</cfif>
	</cfif>
</cfloop>

<cfif (ListFindNoCase(_MasterSubSystemList, _Admin_Add_New_Pages_symbol, ",") eq 0)>
	<cfset _MasterSubSystemList = ListAppend(_MasterSubSystemList, "#_Admin_Add_New_Pages_symbol#", ",")>
</cfif>

<cfif (ListFindNoCase(_MasterSubSystemList, _Admin_Edit_Marquee_symbol, ",") eq 0)>
	<cfset _MasterSubSystemList = ListAppend(_MasterSubSystemList, "#_Admin_Edit_Marquee_symbol#", ",")>
</cfif>

<!--- BEGIN: In case this code loses any settings it would become necessary to collect up all the associations prior to recreating the list followed by recreating the associations --->
<cfif (ListLen(_MasterSubSystemList, ",") gt 0)>
	<cfset _SQL_statement = "#_SQL_statement#
		DECLARE @sid as int;
	">
	<cfloop index="_anItem" list="#_MasterSubSystemList#" delimiters=",">
		<cfset _SQL_statement = "#_SQL_statement#
			SELECT @sid = (SELECT TOP 1 id FROM #_SubsystemList# WHERE (subsystem_name = '#_anItem#'));
			IF @sid IS NULL
				INSERT INTO #_SubsystemList# (subsystem_name) VALUES ('#_anItem#');
		">
	</cfloop>
</cfif>

<cfif (ListLen(_listOfRequiredPages, ",") gt 0)>
	<cfloop index="_anItem" list="#_listOfRequiredPages#" delimiters=",">
		<cfset _SQL_statement = "#_SQL_statement#
			SELECT @sid = (SELECT TOP 1 id FROM #_ContentList# WHERE (pageName = '#_anItem#'));
			IF @sid IS NULL
				INSERT INTO #_ContentList# (pageName) VALUES ('#_anItem#');
		">
	</cfloop>
</cfif>
<!--- END! In case this code loses any settings it would become necessary to collect up all the associations prior to recreating the list followed by recreating the associations --->

<cfif NOT _inhibit_database_actions>
	<cfif (submit eq _addUserAction_symbol)>
		<cfset _userid = Replace(Trim(_userid), "'", "''", "all")>

		<cfif (CommonCode.isSBCUIDvalid(_userid))>
			<cfset _SQL_statement = "#_SQL_statement#
				INSERT INTO #_UserSecurity#
				    (userid, user_name, user_phone)
				VALUES ('#_userid#','','');
			">
		<cfelse>
			<cfset _aURL = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">
			<cfoutput>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					alert("SBCUID of #_userid# is NOT valid at this time because it cannot be located in the webphone database.");
					window.location.href = '#_aURL#';
				-->
				</script>
			</cfoutput>
		</cfif>	
	<cfelseif (function eq _dropUserAction_symbol)>
		<!--- The following tables might have references to an SBCUID :: ContentSecurity, MenuEditorAccess, ReleaseManagement, SubsystemSecurity --->
		<cfset _SQL_statement = "#_SQL_statement#
			DECLARE @csLinks as int;
			DECLARE @meLinks as int;
			DECLARE @rmLinks as int;
			DECLARE @ssLinks as int;

			DECLARE @totLinks as int;

			SELECT @csLinks = (SELECT Count(#_UserSecurity#.id) FROM #_ContentSecurity# INNER JOIN #_UserSecurity# ON #_ContentSecurity#.uid = #_UserSecurity#.id WHERE (#_UserSecurity#.id = #_id#));
			SELECT @meLinks = (SELECT Count(#_UserSecurity#.id) FROM #_UserSecurity# INNER JOIN #_MenuEditorAccess# ON #_UserSecurity#.id = #_MenuEditorAccess#.uid	WHERE (#_UserSecurity#.id = #_id#));
			SELECT @rmLinks = (SELECT COUNT(#_UserSecurity#.id) FROM #_UserSecurity# INNER JOIN #_ReleaseManagement# ON #_UserSecurity#.id = #_ReleaseManagement#.uid WHERE (#_UserSecurity#.id = #_id#));
			SELECT @ssLinks = (SELECT COUNT(#_UserSecurity#.id) FROM #_UserSecurity# INNER JOIN #_SubsystemSecurity# ON #_UserSecurity#.id = #_SubsystemSecurity#.uid WHERE (#_UserSecurity#.id = #_id#));

			SELECT @totLinks = (@csLinks + @meLinks + @rmLinks + @ssLinks);

			IF @totLinks = 0
				DELETE FROM #_UserSecurity# WHERE (id = #_id#);
		">

		<!--- BEGIN: Had to make this a separate query because this query has to collect stats across a bunch of tables that wouldn't easily fit into the primary query for this subsystem --->
		<cfset _SQL_statement1 = "
			DECLARE @csLinks as int;
			DECLARE @meLinks as int;
			DECLARE @rmLinks as int;
			DECLARE @ssLinks as int;

			DECLARE @totLinks as int;

			SELECT @csLinks = (SELECT Count(#_UserSecurity#.id) FROM #_ContentSecurity# INNER JOIN #_UserSecurity# ON #_ContentSecurity#.uid = #_UserSecurity#.id WHERE (#_UserSecurity#.id = #_id#));
			SELECT @meLinks = (SELECT Count(#_UserSecurity#.id) FROM #_UserSecurity# INNER JOIN #_MenuEditorAccess# ON #_UserSecurity#.id = #_MenuEditorAccess#.uid	WHERE (#_UserSecurity#.id = #_id#));
			SELECT @rmLinks = (SELECT COUNT(#_UserSecurity#.id) FROM #_UserSecurity# INNER JOIN #_ReleaseManagement# ON #_UserSecurity#.id = #_ReleaseManagement#.uid WHERE (#_UserSecurity#.id = #_id#));
			SELECT @ssLinks = (SELECT COUNT(#_UserSecurity#.id) FROM #_UserSecurity# INNER JOIN #_SubsystemSecurity# ON #_UserSecurity#.id = #_SubsystemSecurity#.uid WHERE (#_UserSecurity#.id = #_id#));

			SELECT @totLinks = (@csLinks + @meLinks + @rmLinks + @ssLinks);
			
			SELECT @csLinks as csLinks, @meLinks as meLinks, @rmLinks as rmLinks, @ssLinks as ssLinks, @totLinks as totLinks;
		">
		<!--- END! Had to make this a separate query because this query has to collect stats across a bunch of tables that wouldn't easily fit into the primary query for this subsystem --->
	<cfelseif (submit eq _editUserAction_symbol)>
		<cfset _userid = Replace(Trim(_userid), "'", "''", "all")>
	
		<cfif (CommonCode.isSBCUIDvalid(_userid))>
			<cfset _SQL_statement = "#_SQL_statement#
				UPDATE #_UserSecurity#
				SET userid = '#_userid#', user_name = '', user_phone = ''
				WHERE (id = #_id#);
			">
		<cfelse>
			<cfset _aURL = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">
			<cfoutput>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					alert("SBCUID of #_userid# is NOT valid at this time because it cannot be located in the webphone database.");
					window.location.href = '#_aURL#';
				-->
				</script>
			</cfoutput>
		</cfif>	
	<cfelseif (submit eq _updatePageAccessAction_symbol) OR (submit eq _updateSubSystemPageAccessAction_symbol)>
		<cfset _sqlList = CommonCode.makeListIntoSQLList(_pageId)>

		<!--- BEGIN: This block of code removes settings from the database for this user for those settings that were not checked... --->
		<cfset _SQL_clause = "">
		<cfif (ListLen(_sqlList, ",") gt 0)>
			<cfset _SQL_clause = "#_SQL_clause#
				AND (#_ContentList#.pageName NOT IN (#PreserveSingleQuotes(_sqlList)#))
			">
		</cfif>

		<!--- BEGIN: Inside this block of code the SQL statements need to be collected into the variable __SQL_statement because they need to do inside a block of T-SQL code that only executes them when there is a valid Release (such as a Draft) --->
		<cfset __SQL_statement = "#__SQL_statement#
			DELETE FROM #_ContentSecurity#
			WHERE id IN 
			   (
					SELECT #_ContentSecurity#.id
					FROM #_ContentList# INNER JOIN
					    #_ContentSecurity# ON 
					    #_ContentList#.id = #_ContentSecurity#.pid
					WHERE (#_ContentSecurity#.uid = #_id#) #_SQL_clause#
			    );
		">
		<!--- END! This block of code removes settings from the database for this user for those settings that were not checked... --->

		<cfset _SQL_statement = "#_SQL_statement#
			DECLARE @val as int;
			DECLARE @_pid as int;
		">

		<cfloop index="_anItem" list="#_pageId#" delimiters=",">
			<cfset _anItem = Replace(Trim(_anItem), "'", "''", "all")>
			<cfset __SQL_statement = "#__SQL_statement#
				SELECT @_pid = (SELECT TOP 1 id FROM #_ContentList# WHERE (pageName = '#_anItem#'));
				SELECT @val = (SELECT TOP 1 id FROM #_ContentSecurity# WHERE (pid = @_pid) AND (uid = #_id#));
				
				IF @val IS NULL
					INSERT INTO #_ContentSecurity# (pid, uid) VALUES (@_pid,#_id#);
				ELSE
					UPDATE #_ContentSecurity# SET pid = @_pid, uid = #_id# WHERE (id = @val);
			">
		</cfloop>
		<!--- END! Inside this block of code the SQL statements need to be collected into the variable __SQL_statement because they need to do inside a block of T-SQL code that only executes them when there is a valid Release (such as a Draft) --->
	</cfif>
	<cfif (submit eq _updateSubSystemAccessAction_symbol) OR (submit eq _updateSubSystemPageAccessAction_symbol)>
		<cfif (submit eq _updateSubSystemPageAccessAction_symbol)>
			<cfset _subsystemId = "">
			<cfloop index="_itemNum" from="1" to="#_currentSubSystemRow#">
				<cfset _subsystemId = ListAppend(_subsystemId, Evaluate("_subsystemId#_itemNum#"), ",")>
			</cfloop>

			<cfset _inhibit_database_actions = "False">
		</cfif>
		<cfset _sqlList = CommonCode.makeListIntoSQLList(_subsystemId)>

		<!--- BEGIN: This block of code removes settings from the database for this user for those settings that were not checked... --->
		<cfset _SQL_clause = "">
		<cfif (ListLen(_sqlList, ",") gt 0)>
			<cfset _SQL_clause = "#_SQL_clause#
				AND (#_SubsystemList#.subsystem_name NOT IN (#PreserveSingleQuotes(_sqlList)#))
			">
		</cfif>

		<cfset _SQL_statement = "#_SQL_statement#
			DELETE FROM #_SubsystemSecurity#
			WHERE id IN 
			   (
			   SELECT #_SubsystemSecurity#.id
				FROM #_SubsystemList# INNER JOIN
				    #_SubsystemSecurity# ON 
				    #_SubsystemList#.id = #_SubsystemSecurity#.sid
				WHERE (#_SubsystemSecurity#.uid = #_id#) #_SQL_clause#
			   );
		">
		<!--- END! This block of code removes settings from the database for this user for those settings that were not checked... --->

		<cfif (submit neq _updateSubSystemPageAccessAction_symbol)>
			<cfset _SQL_statement = "#_SQL_statement#
				DECLARE @val as int;
				DECLARE @_sid as int;
			">
		<cfelse>
			<cfset _SQL_statement = "#_SQL_statement#
				DECLARE @_sid as int;
			">
		</cfif>

		<cfloop index="_anItem" list="#_subsystemId#" delimiters=",">
			<cfset _SQL_statement = "#_SQL_statement#
				SELECT @_sid = (SELECT TOP 1 id FROM #_SubsystemList# WHERE (subsystem_name = '#_anItem#'));
				SELECT @val = (SELECT TOP 1 id FROM #_SubsystemSecurity# WHERE (sid = @_sid) AND (uid = #_id#));
				
				IF @val IS NULL
					INSERT INTO #_SubsystemSecurity# (sid, uid) VALUES (@_sid,#_id#);
				ELSE
					UPDATE #_SubsystemSecurity# SET sid = @_sid, uid = #_id# WHERE (id = @val);
			">
		</cfloop>

	</cfif>
	<cfif (submit eq _forceMenuUnlockAction_symbol)>
		<cfset _SQL_statement = "#_SQL_statement#
			DELETE FROM #_MenuEditorAccess#;

			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Forced Menu Editor Unlock on #_timeString#');
		">
	</cfif>
</cfif>

<cfset _MasterContentList = "">

<cfset _SQL_statement2 = "
	DECLARE @pg as varchar(8000);
	DECLARE @aList as varchar(8000);
	
	SELECT @aList = ('');
	
	DECLARE _cursor CURSOR FOR 
		SELECT DISTINCT pageName FROM #_DynamicPageManagement# WHERE (pageName IS NOT NULL) AND (LEN(pageName) > 0) ORDER BY pageName;
	
	OPEN _cursor;
	
	FETCH NEXT FROM _cursor
	INTO @pg;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF LEN(@aList) > 0
			SELECT @aList = (@aList + ',');
		SELECT @aList = (@aList + @pg);
	
		FETCH NEXT FROM _cursor 
		INTO @pg;
	END
	
	CLOSE _cursor;
	DEALLOCATE _cursor;
	
	SELECT @aList as aList;
">

<cfif Len(_SQL_statement2) gt 0>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetSecurityList" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement2)#
	</cfquery>
</cfif>

<cfif IsDefined("GetSecurityList") AND (GetSecurityList.recordCount gt 0)>
	<cfset _MasterContentList = GetSecurityList.aList>

	<cfif (ListLen(_MasterContentList, ",") gt 0)>
		<cfset _sqlList = CommonCode.makeListIntoSQLList(_MasterContentList)>
		
		<cfset _SQL_statement = "#_SQL_statement#
			DECLARE @pid as int;
		">
		<cfloop index="_anItem" list="#_MasterContentList#" delimiters=",">
			<cfset _anItem = Replace(_anItem, "'", "''", "all")>
			<cfset _SQL_statement = "#_SQL_statement#
				SELECT @pid = (SELECT TOP 1 id FROM #_ContentList# WHERE (pageName = '#_anItem#'));
				IF @pid IS NULL
					INSERT INTO #_ContentList# (pageName) VALUES ('#_anItem#');
			">
		</cfloop>
	</cfif>
</cfif>

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

<cfif 0>
	<!--- BEGIN: Had to make this query separate because a syntax error in a T-SQL Script will cause the whole T-SQL Script to fail (all or nothing) --->
	<cfset _SQL_statement3 = "#_aSQL#
		DECLARE @locked as datetime;
		SELECT @locked = (SELECT TOP 1 d_locked FROM #_MenuEditorAccess#);
	
		DECLARE @lockedBy as int;
		SELECT @lockedBy = (SELECT TOP 1 uid FROM #_MenuEditorAccess#);
	
		DECLARE @lockedSBCUID as varChar(8000);
		SELECT @lockedSBCUID = NULL;
		IF @lockedBy IS NOT NULL
			SELECT @lockedSBCUID = (SELECT TOP 1 userid FROM #_UserSecurity# WHERE (id = @lockedBy));
	
		SELECT @prid as rid, @locked as locked, @lockedBy as lockedBy, @lockedSBCUID as lockedSBCUID,
			#_SubsystemList#.subsystem_name as subsystemname, 
		    #_UserSecurity#.id AS uid, 
		    #_SubsystemSecurity#.sid, 
		    #_UserSecurity#.userid, 
		    #_ContentSecurity#.pid, 
		    #_ContentList#.pageName, 
		    #_SubsystemList#.id AS ssid, 
		    #_ContentList#.id AS cpid, 
		    #_DynamicPageManagement#.PageTitle,
			#_DynamicPageManagement#.rid as pgrid
		FROM #_DynamicPageManagement# INNER JOIN
		    #_ContentList# ON 
		    #_DynamicPageManagement#.pageName = #_ContentList#.pageName
		     FULL OUTER JOIN
		    #_ContentSecurity# RIGHT OUTER JOIN
		    #_UserSecurity# ON 
		    #_ContentSecurity#.uid = #_UserSecurity#.id
		     LEFT OUTER JOIN
		    #_SubsystemSecurity# ON 
		    #_UserSecurity#.id = #_SubsystemSecurity#.uid
		     ON 
		    #_ContentList#.id = #_ContentSecurity#.pid
		     FULL OUTER JOIN
		    #_SubsystemList# ON 
		    #_SubsystemSecurity#.sid = #_SubsystemList#.id
		WHERE (#_ContentList#.pageName NOT IN ('#menuColorPage_symbol#', '#menuTextColorPage_symbol#'))
		ORDER BY #_UserSecurity#.userid, 
		    #_SubsystemList#.subsystem_name, 
		    #_ContentList#.pageName;
	">
	<!--- END! Had to make this query separate because a syntax error in a T-SQL Script will cause the whole T-SQL Script to fail (all or nothing) --->
<cfelse>
	<cfset _SQL_statement3 = "#_aSQL#
		DECLARE @locked as datetime;
		SELECT @locked = (SELECT TOP 1 d_locked FROM #_MenuEditorAccess#);
	
		DECLARE @lockedBy as int;
		SELECT @lockedBy = (SELECT TOP 1 uid FROM #_MenuEditorAccess#);
	
		DECLARE @lockedSBCUID as varChar(8000);
		SELECT @lockedSBCUID = NULL;
		IF @lockedBy IS NOT NULL
			SELECT @lockedSBCUID = (SELECT TOP 1 userid FROM #_UserSecurity# WHERE (id = @lockedBy));
	
		SELECT @prid as rid, @locked as locked, @lockedBy as lockedBy, @lockedSBCUID as lockedSBCUID,
	">

	<cfset _SQL_statement3_subsystems_users = "#_SQL_statement3#
			#_SubsystemList#.subsystem_name AS subsystemname, #_UserSecurity#.id AS uid, #_SubsystemSecurity#.sid, #_UserSecurity#.userid, #_SubsystemList#.id AS ssid
		FROM #_SubsystemList# INNER JOIN
             #_UserSecurity# INNER JOIN
             #_SubsystemSecurity# ON #_UserSecurity#.id = #_SubsystemSecurity#.uid ON #_SubsystemList#.id = #_SubsystemSecurity#.sid
		ORDER BY #_UserSecurity#.userid, #_SubsystemList#.subsystem_name;
	">

	<cfset _SQL_statement3_content_users = "#_SQL_statement3#
			#_ContentSecurity#.pid, #_ContentList#.pageName, #_ContentList#.id AS cpid, #_DynamicPageManagement#.PageTitle, #_DynamicPageManagement#.rid AS pgrid, #_ContentSecurity#.uid
		FROM #_DynamicPageManagement# INNER JOIN
             #_ContentList# ON #_DynamicPageManagement#.pageName = #_ContentList#.pageName LEFT OUTER JOIN
             #_ContentSecurity# ON #_ContentList#.id = #_ContentSecurity#.pid
		WHERE (#_ContentList#.pageName NOT IN ('[menuColor]', '[menuTextColor]'))
		ORDER BY #_ContentList#.pageName;
	">
</cfif>

<!--- BEGIN: Had to make this query separate because the user list needs to be separate from the links between users and other records --->
<cfset _SQL_statement4 = "#_aSQL#
	SELECT DISTINCT id as uid, userid, @prid as rid FROM #_UserSecurity# ORDER BY userid;
">
<!--- END! Had to make this query separate because the user list needs to be separate from the links between users and other records --->

<cfif Len(_SQL_statement) gt 0>
	<cfif (submit eq _addUserAction_symbol) OR (submit eq _editUserAction_symbol)>
		<cfscript>
			SetSecurityData = CommonCode.safelyExecSQL(DSNUser, DSNPassword, DSNSource, _SQL_statement, CreateTimeSpan(0, 0, 0, 10));
		</cfscript>

		<cfif ( (IsDefined("SetSecurityData")) AND (IsDefined("SetSecurityData.status")) AND (SetSecurityData.status LT -1) )>
			<cfset _debugInfo = "">
			<cfif (CommonCode.isServerLocal())>
				<cfset _debugInfo = " \nSetSecurityData.status = [#SetSecurityData.status#]">
			</cfif>
			<cfset _aURL = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">
			<cfoutput>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					alert("SBCUID of #_userid# is already in the database and CANNOT be added a second time.#_debugInfo#");
					window.location.href = '#_aURL#';
				-->
				</script>
			</cfoutput>
		</cfif>
	<cfelse>
		<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="SetSecurityData" datasource="#DSNSource#" cachedwithin="#CreateTimeSpan(0, 0, 0, 10)#">
			#PreserveSingleQuotes(_SQL_statement)#
		</cfquery>
	</cfif>
</cfif>

<cfif Len(_SQL_statement3_subsystems_users) gt 0>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetSecurityDataUsersSubsystems" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement3_subsystems_users)#
	</cfquery>
</cfif>

<cfif Len(_SQL_statement3_content_users) gt 0>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetSecurityDataUsersContent" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement3_content_users)#
	</cfquery>
</cfif>

<cfif Len(_SQL_statement4) gt 0>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetSecurityUserList" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement4)#
	</cfquery>
</cfif>

<cfif (function eq _dropUserAction_symbol) AND Len(_SQL_statement1) gt 0>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetUserSecurityStats" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement1)#
	</cfquery>
	
	<cfif (IsDefined("GetUserSecurityStats")) AND (GetUserSecurityStats.recordCount gt 0)>

		<cfset _total_links_to_sbcuid = 0>
		<cfif (IsDefined("GetUserSecurityStats")) AND (IsDefined("GetUserSecurityStats.totLinks"))>
			<cfset _total_links_to_sbcuid = GetUserSecurityStats.totLinks>
		</cfif>

		<cfif (_total_links_to_sbcuid gt 0)>
			<cfoutput>
			<script language="JavaScript1.2" type="text/javascript">
			<!--
				alert('WARNING: User attempted to Delete SBCUID #_userid# however there are records linked to this user in the database.\n The corrective action is to delete or remove all existing references to the user and then attempt to delete again.\n\n The types of references that need to be removed or deleted are specified in the Security Settings dialog for this user, the Menu Editor and the /Release SubSystem. Be sure to uncheck all SubSystems and Pages of Content this user has access to in the Security Settings dialog. Be sure this user does not have a pending Menu Editor sessions. And be sure this user has not created or modified any Release in the /Release SubSystem.');
			-->
			</script>
			</cfoutput>
		</cfif>
	</cfif>
</cfif>

<cfif ( (NOT IsDefined("GetSecurityDataUsersSubsystems")) OR (Len(GetSecurityDataUsersSubsystems.rid) eq 0) )>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		alert('WARNING: User attempted to change Security Settings for Pages of Content in the Draft Release but there is NO DRAFT - changes were NOT saved to the database.\n Subsystem Security Setting changes, if any were changed, were saved to the database.');
	-->
	</script>
</cfif>

<cfset _SubSystemList_ = "">

<!--- BEGIN: This Query pulls only those subsystemname that are valid from the shot-gun query --->
<CFQUERY dbtype="query" name="GetSubSystemNameList">
	SELECT DISTINCT subsystemname, ssid, uid
	FROM GetSecurityDataUsersSubsystems
	WHERE (subsystemname IS NOT NULL)
	ORDER BY subsystemname, ssid, uid
</cfquery>
<!--- END! This Query pulls only those subsystemname that are valid from the shot-gun query --->

<cfloop query="GetSubSystemNameList" startrow="1" endrow="#GetSubSystemNameList.recordCount#">
	<cfset _SubSystemList_ = ListAppend(_SubSystemList_, "#GetSubSystemNameList.ssid#=#GetSubSystemNameList.subsystemname#|#GetSubSystemNameList.uid#", ",")>
</cfloop>

<cfif 0>
	<cfset _SQL_statement3a = "#_aSQL#
		SELECT #_SubsystemList#.id AS ssid,
			#_SubsystemList#.subsystem_name as subsystemname,
			NULL as uid
		FROM #_SubsystemList#
		WHERE (#_SubsystemList#.subsystem_name IS NOT NULL)
		ORDER BY #_SubsystemList#.subsystem_name;
	">
	
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="_GetSubSystemNameList" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement3a)#
	</cfquery>
	
	<cfloop query="_GetSubSystemNameList" startrow="1" endrow="#_GetSubSystemNameList.recordCount#">
		<cfif (ListContainsNoCase(_SubSystemList_, "=#_GetSubSystemNameList.subsystemname#|", ",") eq 0)>
			<cfset _SubSystemList_ = ListAppend(_SubSystemList_, "#_GetSubSystemNameList.ssid#=#_GetSubSystemNameList.subsystemname#|#_GetSubSystemNameList.uid#", ",")>
		</cfif>
	</cfloop>
</cfif>

<!--- BEGIN: This Query pulls only those pages that are associated with the current Draft Release --->
<CFQUERY dbtype="query" name="GetContentPageList">
	SELECT *
	FROM GetSecurityDataUsersContent
	WHERE (rid = pgrid)
	ORDER BY pageName
</cfquery>
<!--- END! This Query pulls only those pages that are associated with the current Draft Release --->

<cfset _mcl = _MasterContentList>
<cfset _ContentPageList = "">
<cfloop query="GetContentPageList" startrow="1" endrow="#GetContentPageList.recordCount#">
	<cfif (Len(GetContentPageList.cpid) gt 0) AND (Len(GetContentPageList.pageName) gt 0)>
		<cfset _ContentPageList = ListAppend(_ContentPageList, "#GetContentPageList.cpid#=#GetContentPageList.pageName#@#GetContentPageList.PageTitle#|#GetContentPageList.uid#", ",")>

		<cfset _mcl_i = ListFindNoCase(_mcl, GetContentPageList.pageName, ",")>
		<cfif (_mcl_i gt 0)>
			<cfset _mcl = ListDeleteAt(_mcl, _mcl_i, ",")>
		</cfif>
	</cfif>
</cfloop>

<cfif (NOT _inhibit_database_actions)>
	<cfoutput>
		<cfif ( (submit eq _addUserAction_symbol) OR (submit eq _editUserAction_symbol) OR (function eq _dropUserAction_symbol) OR (submit eq _updateSubSystemAccessAction_symbol) OR (submit eq _updatePageAccessAction_symbol) OR (submit eq _updateSubSystemPageAccessAction_symbol) OR (submit eq _forceMenuUnlockAction_symbol) )>
			<cfset _aURL = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">
			<cfif (submit eq _addUserAction_symbol)>
				<cfset _aURL = "#_aURL#&x_function=#URLEncodedFormat(_lookupUserAction_symbol)#&x_userid=#URLEncodedFormat(_userid)#">
			</cfif>
			<script language="JavaScript1.2" type="text/javascript">
			<!--
				window.location.href = '#_aURL#';
			-->
			</script>
		</cfif>
	</cfoutput>
</cfif>
