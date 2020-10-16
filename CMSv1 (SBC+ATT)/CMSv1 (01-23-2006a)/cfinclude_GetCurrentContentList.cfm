<cfset _aSQL = "#_aSQL#
	DECLARE @pg as varchar(8000);
	
	DECLARE _cursor CURSOR FOR 
		SELECT DISTINCT
		    #_ContentList#.pageName 
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
		WHERE (@prid = #_DynamicPageManagement#.rid) AND (#_UserSecurity#.id = #VerifyUserSecurity2.uid#)
				AND (#_DynamicPageManagement#.pageName NOT IN ('#menuColorPage_symbol#', '#menuTextColorPage_symbol#'))
		ORDER BY #_ContentList#.pageName;
	
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
">
