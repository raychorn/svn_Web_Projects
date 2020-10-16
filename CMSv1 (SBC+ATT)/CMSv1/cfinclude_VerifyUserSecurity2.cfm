<cfif IsDefined("VerifyUserSecurity") AND (VerifyUserSecurity.recordCount gt 0)>
	<CFQUERY dbtype="query" name="VerifyUserSecurity2">
		SELECT *
		FROM VerifyUserSecurity
		WHERE (userid IS NOT NULL) AND (UPPER(userid) = <cfqueryparam value="#UCASE(_AUTH_USER)#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">)
	</cfquery>

	<cfif ( (_ReleaseMode eq 1) OR (_adminMode eq 1) OR (_LayoutMode eq 1) ) AND (Len(_AUTH_USER) gt 0)>
		<cfif (NOT IsDefined("VerifyUserSecurity2")) OR (VerifyUserSecurity2.recordCount eq 0) OR (Len(VerifyUserSecurity2.sid) eq 0) OR (Len(VerifyUserSecurity2.uid) eq 0)>
			<cfset _message = "SBCUID #_AUTH_USER# does NOT have access to /#_subsysName# within this application.  PLS consult your Security Manager to gain access.">
			<cfoutput>
				<html>
					<head>
					<meta http-equiv="expires" content="-1">
					<meta http-equiv="pragma" content="no-cache">
				</head>
				<cfset _myPath = GetBaseTemplatePath()>
				<cfset _myImg = "images/access-denied-transparent-background.gif">
				<cfif (NOT FileExists("#_myPath##Replace(_myImg, "/", "\", "all")#"))>
					<cfset _myImg = "../#_myImg#">
				</cfif>
				<body background="#_myImg#">
					#RepeatString("<BR>", 12)#
					<h1 align="center">#_message#</h1>
				</body>
				</html>
				<cfabort>
			</cfoutput>
		</cfif>
	</cfif>

	<cfif (_ReleaseMode eq 0) AND (_SecurityMode eq 0)>
		<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetContentSecurity" datasource="#DSNSource#">
			DECLARE @sid as int;
			DECLARE @sid2 as int;
			DECLARE @sid3 as int;
			DECLARE @sid4 as int;
			
			SELECT @sid = (SELECT #_SubsystemSecurity#.sid
			FROM #_SubsystemList# INNER JOIN
			    #_SubsystemSecurity# ON 
			    #_SubsystemList#.id = #_SubsystemSecurity#.sid INNER JOIN
			    #_UserSecurity# ON 
			    #_SubsystemSecurity#.uid = #_UserSecurity#.id
			WHERE (#_UserSecurity#.userid = '#UCASE(_AUTH_USER)#') AND 
			    (#_SubsystemList#.subsystem_name = '#_Admin_Add_New_Pages_symbol#'));
			
			SELECT @sid2 = (SELECT #_SubsystemSecurity#.sid
			FROM #_SubsystemList# INNER JOIN
			    #_SubsystemSecurity# ON 
			    #_SubsystemList#.id = #_SubsystemSecurity#.sid INNER JOIN
			    #_UserSecurity# ON 
			    #_SubsystemSecurity#.uid = #_UserSecurity#.id
			WHERE (#_UserSecurity#.userid = '#UCASE(_AUTH_USER)#') AND 
			    (#_SubsystemList#.subsystem_name = '#_Admin_Edit_Marquee_symbol#'));

			SELECT @sid3 = (SELECT #_SubsystemSecurity#.sid
			FROM #_SubsystemList# INNER JOIN
			    #_SubsystemSecurity# ON 
			    #_SubsystemList#.id = #_SubsystemSecurity#.sid INNER JOIN
			    #_UserSecurity# ON 
			    #_SubsystemSecurity#.uid = #_UserSecurity#.id
			WHERE (#_UserSecurity#.userid = '#UCASE(_AUTH_USER)#') AND 
			    (#_SubsystemList#.subsystem_name = '#_Admin_Upload_Images_symbol#'));

			SELECT @sid4 = (
				SELECT #_ContentSecurity#.pid
				FROM #_ContentSecurity# INNER JOIN
				    #_ContentList# ON 
				    #_ContentSecurity#.pid = #_ContentList#.id INNER JOIN
				    #_UserSecurity# ON 
				    #_ContentSecurity#.uid = #_UserSecurity#.id
				WHERE (#_UserSecurity#.userid = '#UCASE(_AUTH_USER)#')
					AND (#_ContentList#.pageName = '#siteCSSPage_symbol#')
			);

			DECLARE @pid as int;
			
			SELECT @pid = (SELECT TOP 1 #_ContentSecurity#.pid
					FROM #_ContentSecurity# INNER JOIN
					    #_ContentList# ON 
					    #_ContentSecurity#.pid = #_ContentList#.id INNER JOIN
					    #_UserSecurity# ON 
					    #_ContentSecurity#.uid = #_UserSecurity#.id
					WHERE (#_UserSecurity#.userid = '#UCASE(_AUTH_USER)#')
			);
			
			IF @pid IS NULL
			BEGIN
				SELECT NULL as pid, NULL as uid, NULL as userid, '' as user_name, 
						    '' as user_phone, '' as pageName, @sid as sid, @sid2 as sid2, @sid3 as sid3, @sid4 as sid4
			END
			ELSE
			BEGIN
				SELECT #_ContentSecurity#.pid, #_ContentSecurity#.uid, 
						    #_UserSecurity#.userid, #_UserSecurity#.user_name, 
						    #_UserSecurity#.user_phone, 
						    #_ContentList#.pageName,
							@sid as sid, @sid2 as sid2, @sid3 as sid3, @sid4 as sid4
						FROM #_ContentSecurity# INNER JOIN
						    #_ContentList# ON 
						    #_ContentSecurity#.pid = #_ContentList#.id INNER JOIN
						    #_UserSecurity# ON 
						    #_ContentSecurity#.uid = #_UserSecurity#.id
						WHERE (#_UserSecurity#.userid = '#UCASE(_AUTH_USER)#')
			END;
		</cfquery>
	
		<cfif IsDefined("GetContentSecurity") AND (GetContentSecurity.recordCount gt 0)>
			<CFQUERY dbtype="query" name="VerifyQuickLinksSecurity">
				SELECT *
				FROM GetContentSecurity
				WHERE (UPPER(pageName) = <cfqueryparam value="#UCASE(_quickLinksPageName_symbol)#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">)
			</cfquery>
	
			<CFQUERY dbtype="query" name="VerifyMenuPageSecurity">
				SELECT *
				FROM GetContentSecurity
				WHERE (UPPER(pageName) = <cfqueryparam value="#UCASE(_menuPageName_symbol)#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">)
			</cfquery>
	
			<CFQUERY dbtype="query" name="VerifySecurity_sepg_section">
				SELECT *
				FROM GetContentSecurity
				WHERE (UPPER(pageName) = <cfqueryparam value="#UCASE(_sepg_section_pageName_symbol)#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">)
			</cfquery>
	
			<CFQUERY dbtype="query" name="VerifySecurity_sepg_links">
				SELECT *
				FROM GetContentSecurity
				WHERE (UPPER(pageName) = <cfqueryparam value="#UCASE(_sepg_links_pageName_symbol)#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">)
			</cfquery>
	
			<CFQUERY dbtype="query" name="VerifySecurity_right_side">
				SELECT *
				FROM GetContentSecurity
				WHERE (UPPER(pageName) = <cfqueryparam value="#UCASE(_right_side_pageName_symbol)#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">)
			</cfquery>
	
			<CFQUERY dbtype="query" name="VerifySecurity_footer">
				SELECT *
				FROM GetContentSecurity
				WHERE (UPPER(pageName) = <cfqueryparam value="#UCASE(_footer_pageName_symbol)#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">)
			</cfquery>
	
			<CFQUERY dbtype="query" name="VerifyCurrentPageSecurity">
				SELECT *
				FROM GetContentSecurity
				WHERE (UPPER(pageName) = <cfqueryparam value="#UCASE(currentPage)#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">)
			</cfquery>
	
			<CFQUERY dbtype="query" name="VerifySecurity_AddNewPages">
				SELECT *
				FROM GetContentSecurity
				WHERE (sid IS NOT NULL)
			</cfquery>

			<CFQUERY dbtype="query" name="VerifySecurity_MarqueeEditor">
				SELECT *
				FROM GetContentSecurity
				WHERE (sid2 IS NOT NULL)
			</cfquery>

			<CFQUERY dbtype="query" name="VerifySecurity_UploadImages">
				SELECT *
				FROM GetContentSecurity
				WHERE (sid3 IS NOT NULL)
			</cfquery>

			<CFQUERY dbtype="query" name="VerifySecurity_SiteCSS">
				SELECT *
				FROM GetContentSecurity
				WHERE (sid4 IS NOT NULL)
			</cfquery>

		</cfif>
	</cfif>
</cfif>

