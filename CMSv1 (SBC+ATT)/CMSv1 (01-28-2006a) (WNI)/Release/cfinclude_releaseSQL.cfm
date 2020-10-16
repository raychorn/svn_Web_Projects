<cfset _timeString = CommonCode.formattedDateTimeTZ(Now())>
<cfset _formattedString = "on #_timeString#">
<cfset _formattedString = Replace(_formattedString, "'", "''", "all")>

<!--- BEGIN: Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->
<cfif (IsDefined("_submit_")) AND (Len(Trim(submit)) eq 0)>
	<cfset submit = _submit_>
</cfif>
<!--- END! Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->

<cfif (submit eq _commentsEditorAction_symbol)>
	<cfif (Len(Trim(_comments)) gt 0)>
		<cfset _comments = Replace(_comments, "'", "''", "all")>
		<cfset _SQL_ = CommonCode.sql_saveReleaseComments(_comments, _ReleaseManagementComments, _ReleaseActivityLog, _rid, VerifyUserSecurity2.userid, "Via the /Release subsystem #_formattedString#")>
		<cfset _SQL_statement = "#_SQL_statement##_SQL_#">
	</cfif>
<cfelseif (ListLen(submit, "|") eq 2) AND (GetToken(submit, 1, "|") eq _productionReleaseAction_symbol)>
	<cfset _SQL_statement = "#_SQL_statement#
		DECLARE @pid as int;
		SELECT @pid = (SELECT TOP 1 id FROM #_ReleaseManagement# WHERE (devDateTime IS NOT NULL));
		UPDATE #_ReleaseManagement# SET devDateTime = NULL, prodDateTime = NULL, stageDateTime = GETDATE(), archDateTime = NULL WHERE (id = @pid);
		IF @pid IS NULL
			SELECT @pid = (SELECT TOP 1 id FROM #_ReleaseManagement# WHERE (stageDateTime IS NOT NULL) ORDER BY stageDateTime DESC);
		IF @pid IS NOT NULL
			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@pid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Staged #_formattedString#');
	">
<cfelseif (ListLen(submit, "|") eq 2) AND (GetToken(submit, 1, "|") eq _revertStagingReleaseAction_symbol)>
	<cfset _SQL_statement = "#_SQL_statement#
		DECLARE @dpid as int;
		SELECT @dpid = (SELECT TOP 1 id FROM #_ReleaseManagement# WHERE (devDateTime IS NOT NULL));

		IF @dpid IS NULL
		BEGIN
			DECLARE @pid as int;
			SELECT @pid = (SELECT TOP 1 id FROM #_ReleaseManagement# WHERE (stageDateTime IS NOT NULL) ORDER BY stageDateTime DESC);
			UPDATE #_ReleaseManagement# SET devDateTime = GETDATE(), prodDateTime = NULL, stageDateTime = NULL, archDateTime = NULL WHERE (id = @pid);
			IF @pid IS NULL
				SELECT @pid = (SELECT TOP 1 id FROM #_ReleaseManagement# WHERE (devDateTime IS NOT NULL) ORDER BY devDateTime DESC);
			IF @pid IS NOT NULL
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@pid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Reverted Staged to Draft #_formattedString#');
		END
		ELSE
		BEGIN
			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@dpid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Aborted attempt to Revert Staged to Draft because there is already a Draft in the database #_formattedString#');
		END
	">
<cfelseif (ListLen(submit, "|") eq 2) AND (GetToken(submit, 1, "|") eq _productionReleaseStageAction_symbol)>
	<cfset _SQL_statement = "#_SQL_statement#
		DECLARE @pid as int;
		SELECT @pid = (SELECT TOP 1 id FROM #_ReleaseManagement# WHERE (prodDateTime IS NOT NULL));
		UPDATE #_ReleaseManagement# SET devDateTime = NULL, prodDateTime = NULL, archDateTime = GETDATE() WHERE (id = @pid);
		IF @pid IS NOT NULL
			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@pid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Archived #_formattedString#');

		UPDATE #_ReleaseManagement# SET devDateTime = NULL, prodDateTime = GETDATE(), stageDateTime = NULL, archDateTime = NULL WHERE (id = #_rid#);

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Pushed into Production #_formattedString#');
	">
<cfelseif (ListLen(submit, "|") eq 2) AND (GetToken(submit, 1, "|") eq _productionArchiveDevelopAction_symbol)>
	<cfset _SQL_statement = "#_SQL_statement#
		DECLARE @num as int;
		SELECT @num = (SELECT count(id) FROM #_ReleaseManagement# WHERE (devDateTime IS NOT NULL));
		
		IF @num = 0
		BEGIN
			DECLARE @bRid as int;
			DECLARE @rNum as int;
			DECLARE @bNum as int;
			DECLARE @_rid as int;
			
			DECLARE @dd as varchar(100);
			DECLARE @dd2 as varchar(100);
	
			SELECT @rNum = (SELECT TOP 1 releaseNumber FROM #_ReleaseManagement# WHERE (devDateTime IS NULL) ORDER BY releaseNumber DESC);
	
			IF @rNum IS NULL
			BEGIN
				SELECT @rNum = 1;
				SELECT @bNum = 0;
	
				SELECT @_rid = (SELECT TOP 1 releaseNumber FROM #_ReleaseManagement# WHERE (releaseNumber = @rNum));
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Cannot create New Release (Cannot find a Production Release to use for the basis for the new release) #_formattedString#');
			END
			ELSE
			BEGIN
				DECLARE @recCount as int;

				SELECT @bNum = @rNum;
				SELECT @bRid = #_rid#;
	
				SELECT @rNum = (@bNum + 1);

				DECLARE @layoutId as int;
				SELECT @layoutId = (SELECT layout_id FROM #_ReleaseManagement# WHERE (id = @bRid));

				DECLARE @s_layoutId as varchar(100);
				SELECT @s_layoutId = '<Undefined>'; 
				IF @layoutId IS NOT NULL
					SELECT @s_layoutId = CAST(@layoutId as varchar(100)); 

				INSERT INTO #_ReleaseManagement# (layout_id, releaseNumber, devDateTime, uid, prodDateTime, archDateTime, stageDateTime, comments) 
					VALUES (@layoutId,@rNum,GETDATE(),#VerifyUserSecurity2.uid#,NULL,NULL,NULL,'New Release based on Release ###_relNum# using the inherited Layout Spec (' + @s_layoutId + ') Created by SBCUID #VerifyUserSecurity2.userid#')
		
				SELECT @_rid = (SELECT TOP 1 id FROM #_ReleaseManagement# WHERE (releaseNumber = @rNum));
	
				SELECT @dd = CAST(@bRid as varchar(100)); 
				SELECT @dd2 = CAST(@_rid as varchar(100)); 
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Created New Release (@bRid=' + @dd + ', @_rid=' + @dd2 + ') #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Copying #_DynamicPageManagement# entities #_formattedString#');

				SELECT @recCount = (SELECT count(id) FROM #_DynamicPageManagement#);
	
				IF @recCount IS NOT NULL
					INSERT INTO #_DynamicPageManagement# (pageId, pageName, PageTitle, versionDateTime, rid)
						SELECT pageId, pageName, PageTitle, versionDateTime, @_rid
						FROM #_DynamicPageManagement#
						WHERE (rid = @bRid);
				ELSE
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: WARNING: Empty table #_DynamicPageManagement# #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Copied #_DynamicPageManagement# entities #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Copying #_DynamicHTMLContent# entities #_formattedString#');

				SELECT @recCount = (SELECT count(id) FROM #_DynamicHTMLContent#);
	
				IF @recCount IS NOT NULL
					INSERT INTO #_DynamicHTMLContent# (pageId, html, rid)
						SELECT pageId, html, @_rid
						FROM #_DynamicHTMLContent#
						WHERE (rid = @bRid);
				ELSE
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: WARNING: Empty table #_DynamicHTMLContent# #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Copied #_DynamicHTMLContent# entities #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Copying #_DynamicHTMLpad# entities from #_formattedString#');
	
				SELECT @recCount = (SELECT count(id) FROM #_DynamicHTMLpad#);

				IF @recCount IS NOT NULL
					INSERT INTO #_DynamicHTMLpad# (pageId, html, rid)
						SELECT pageId, html, @_rid
						FROM #_DynamicHTMLpad#
						WHERE (rid = @bRid);
				ELSE
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: WARNING: Empty table #_DynamicHTMLpad# #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Copied #_DynamicHTMLpad# entities #_formattedString#');

				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Copying #_DynamicHTMLmenu# entities from #_formattedString#');

				SELECT @recCount = (SELECT count(id) FROM #_DynamicHTMLmenu#);
	
				IF @recCount IS NOT NULL
					INSERT INTO #_DynamicHTMLmenu# (pageId, html, rid)
						SELECT pageId, html, @_rid
						FROM #_DynamicHTMLmenu#
						WHERE (rid = @bRid);
				ELSE
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: WARNING: Empty table #_DynamicHTMLmenu# #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Copied #_DynamicHTMLmenu# entities #_formattedString#');

				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Copying #_DynamicHTMLsepg_section# entities from #_formattedString#');

				SELECT @recCount = (SELECT count(id) FROM #_DynamicHTMLsepg_section#);
	
				IF @recCount IS NOT NULL
					INSERT INTO #_DynamicHTMLsepg_section# (pageId, html, rid)
						SELECT pageId, html, @_rid
						FROM #_DynamicHTMLsepg_section#
						WHERE (rid = @bRid);
				ELSE
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: WARNING: Empty table #_DynamicHTMLsepg_section# #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Copied #_DynamicHTMLsepg_section# entities #_formattedString#');

				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Copying #_DynamicHTMLsepg_links# entities from #_formattedString#');

				SELECT @recCount = (SELECT count(id) FROM #_DynamicHTMLsepg_links#);
	
				IF @recCount IS NOT NULL
					INSERT INTO #_DynamicHTMLsepg_links# (pageId, html, rid)
						SELECT pageId, html, @_rid
						FROM #_DynamicHTMLsepg_links#
						WHERE (rid = @bRid);
				ELSE
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: WARNING: Empty table #_DynamicHTMLsepg_links# #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Copied #_DynamicHTMLsepg_links# entities #_formattedString#');

				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Copying #_DynamicHTMLright_side# entities from #_formattedString#');

				SELECT @recCount = (SELECT count(id) FROM #_DynamicHTMLright_side#);
	
				IF @recCount IS NOT NULL
					INSERT INTO #_DynamicHTMLright_side# (pageId, html, rid)
						SELECT pageId, html, @_rid
						FROM #_DynamicHTMLright_side#
						WHERE (rid = @bRid);
				ELSE
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: WARNING: Empty table #_DynamicHTMLright_side# #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Copied #_DynamicHTMLright_side# entities #_formattedString#');

				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Copying #_DynamicHTMLfooter# entities from #_formattedString#');

				SELECT @recCount = (SELECT count(id) FROM #_DynamicHTMLfooter#);
	
				IF @recCount IS NOT NULL
					INSERT INTO #_DynamicHTMLfooter# (pageId, html, rid)
						SELECT pageId, html, @_rid
						FROM #_DynamicHTMLfooter#
						WHERE (rid = @bRid);
				ELSE
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: WARNING: Empty table #_DynamicHTMLfooter# #_formattedString#');
	
				INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Copied #_DynamicHTMLfooter# entities #_formattedString#');
	">

	<cfif (IsDefined("_listOfRequiredPages")) AND (Len(_listOfRequiredPages) gt 0) AND (_cfapplication_name eq const_cfapplication_name_default_symbol)>
		<cfset _aSQLStatement = CommonCode.sql_getCurrentRelease_rid( "True", _ReleaseManagement)>

		<cfset _SQL_statement = "#_SQL_statement#
				DECLARE @prid as int;
				
				SELECT @prid = @_rid;
				
				IF @prid IS NOT NULL
				BEGIN
					DECLARE @_aPageId as int;
					DECLARE @_cid as int;
					DECLARE @_pgid as int;

					DECLARE @_pati as int;
					DECLARE @_patt as varchar(80);
					
					DECLARE @_placeHolder as varchar(80);
					
					DECLARE @_listOfRequiredSpecialPages as varchar(8000);
					DECLARE @_listOfRequiredQuickLinksPages as varchar(8000);
					DECLARE @_listOfRequiredMenuPagePages as varchar(8000);
					DECLARE @_listOfRequiredSepg_sectionPages as varchar(8000);
					DECLARE @_listOfRequiredSepg_linksPages as varchar(8000);
					DECLARE @_listOfRequiredRight_sidePages as varchar(8000);
					DECLARE @_listOfRequiredFooterPages as varchar(8000);
	
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Sanity Check for Required Pages #_formattedString#');
	
					DECLARE @_i as int;
					DECLARE @_j as int;
					DECLARE @_iMax as int;
					DECLARE @_str as varchar(8000);
					DECLARE @_delim as varchar(1);
					DECLARE @_tok as varchar(8000);
					
					SELECT @_delim = ',';
					SELECT @_str = '#_listOfRequiredPages#';
					
					SELECT @_listOfRequiredSpecialPages = '#_listOfRequiredSpecialPages#';
					SELECT @_listOfRequiredQuickLinksPages = '#_listOfRequiredQuickLinksPages#';
					SELECT @_listOfRequiredMenuPagePages = '#_listOfRequiredMenuPagePages#';
					SELECT @_listOfRequiredSepg_sectionPages = '#_listOfRequiredSepg_sectionPages#';
					SELECT @_listOfRequiredSepg_linksPages = '#_listOfRequiredSepg_linksPages#';
					SELECT @_listOfRequiredRight_sidePages = '#_listOfRequiredRight_sidePages#';
					SELECT @_listOfRequiredFooterPages = '#_listOfRequiredFooterPages#';
					
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

						INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (1) DEBUG: pageName = ' + @_tok + ' #_formattedString#');

						IF @_aPageId IS NULL
						BEGIN
							INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (2) DEBUG: @_aPageId = NULL #_formattedString#');

							SELECT @_aPageId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (rid = @prid) ORDER BY pageId DESC);

							IF @_aPageId IS NULL
							BEGIN
								INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (3) DEBUG: @_aPageId = NULL #_formattedString#');
								SELECT @_aPageId = 1;
							END
							ELSE
								SELECT @_aPageId = (@_aPageId + 1);

							INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (4) DEBUG: @_aPageId ' + CAST(@_aPageId AS varchar(10)) + ' #_formattedString#');
		
							INSERT INTO #_DynamicPageManagement# (pageId, pageName, PageTitle, versionDateTime, rid)
								VALUES (@_aPageId, @_tok, ('[' + @_tok + ']'), NULL, @prid);
		
							SELECT @_pgid = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageId = @_aPageId) AND (rid = @prid));

							INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (5) DEBUG: @_aPageId ' + CAST(@_pgid AS varchar(10)) + ' #_formattedString#');
			
							IF @_pgid IS NOT NULL
							BEGIN
								INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Created Required Page named ' + @_tok + ' #_formattedString#');

								SELECT @_placeHolder = '';
								
								SELECT @_patt = '%' + @_tok + '%';
								
								SELECT @_pati = PATINDEX( @_patt , @_listOfRequiredSpecialPages);
								INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (6) DEBUG: Is (' + @_patt + ') a pattern in (' + @_listOfRequiredSpecialPages + ') (' + CAST(@_pati AS varchar(10)) + ')');
								IF @_pati = 0
								BEGIN
									SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLContent# WHERE (pageId = @_aPageId) AND (rid = @prid));
				
									IF @_cid IS NULL
									BEGIN
										INSERT INTO #_DynamicHTMLContent# (pageId, html, rid) VALUES (@_aPageId, @_placeHolder, @prid);
									
										SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLContent# WHERE (pageId = @_aPageId) AND (rid = @prid));
					
										IF @_cid IS NOT NULL
										BEGIN
											INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (a) Created Blank Content for Required Page named ' + @_tok + ' #_formattedString#');
										END
									END
								END
								ELSE
								BEGIN
									SELECT @_pati = PATINDEX( @_patt , @_listOfRequiredQuickLinksPages);
									INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (7) DEBUG: Is (' + @_patt + ') a pattern in (' + @_listOfRequiredQuickLinksPages + ') (' + CAST(@_pati AS varchar(10)) + ')');
									IF @_pati > 0
									BEGIN
										SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLpad# WHERE (pageId = @_aPageId) AND (rid = @prid));
					
										IF @_cid IS NULL
										BEGIN
											INSERT INTO #_DynamicHTMLpad# (pageId, html, rid) VALUES (@_aPageId, @_placeHolder, @prid);
										
											SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLpad# WHERE (pageId = @_aPageId) AND (rid = @prid));
						
											IF @_cid IS NOT NULL
											BEGIN
												INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (b) Created Blank Content for Required Page named ' + @_tok + ' #_formattedString#');
											END
										END
									END
									ELSE
									BEGIN
										SELECT @_pati = PATINDEX( @_patt , @_listOfRequiredMenuPagePages);
										INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (8) DEBUG: Is (' + @_patt + ') a pattern in (' + @_listOfRequiredMenuPagePages + ') (' + CAST(@_pati AS varchar(10)) + ')');
										IF @_pati > 0
										BEGIN
											SELECT @_placeHolder = '.| |Placeholder,##-1';
											SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLmenu# WHERE (pageId = @_aPageId) AND (rid = @prid));
						
											IF @_cid IS NULL
											BEGIN
												INSERT INTO #_DynamicHTMLmenu# (pageId, html, rid) VALUES (@_aPageId, @_placeHolder, @prid);
											
												SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLmenu# WHERE (pageId = @_aPageId) AND (rid = @prid));
							
												IF @_cid IS NOT NULL
												BEGIN
													INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (c) Created Blank Content for Required Page named ' + @_tok + ' #_formattedString#');
												END
											END
										END
										ELSE
										BEGIN
											SELECT @_pati = PATINDEX( @_patt , @_listOfRequiredSepg_sectionPages);
											INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (9) DEBUG: Is (' + @_patt + ') a pattern in (' + @_listOfRequiredSepg_sectionPages + ') (' + CAST(@_pati AS varchar(10)) + ')');
											IF @_pati > 0
											BEGIN
												SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLsepg_section# WHERE (pageId = @_aPageId) AND (rid = @prid));
							
												IF @_cid IS NULL
												BEGIN
													INSERT INTO #_DynamicHTMLsepg_section# (pageId, html, rid) VALUES (@_aPageId, @_placeHolder, @prid);
												
													SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLsepg_section# WHERE (pageId = @_aPageId) AND (rid = @prid));
								
													IF @_cid IS NOT NULL
													BEGIN
														INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (d) Created Blank Content for Required Page named ' + @_tok + ' #_formattedString#');
													END
												END
											END
											ELSE
											BEGIN
												SELECT @_pati = PATINDEX( @_patt , @_listOfRequiredSepg_linksPages);
												INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (10) DEBUG: Is (' + @_patt + ') a pattern in (' + @_listOfRequiredSepg_linksPages + ') (' + CAST(@_pati AS varchar(10)) + ')');
												IF @_pati > 0
												BEGIN
													SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLsepg_links# WHERE (pageId = @_aPageId) AND (rid = @prid));
								
													IF @_cid IS NULL
													BEGIN
														INSERT INTO #_DynamicHTMLsepg_links# (pageId, html, rid) VALUES (@_aPageId, @_placeHolder, @prid);
													
														SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLsepg_links# WHERE (pageId = @_aPageId) AND (rid = @prid));
									
														IF @_cid IS NOT NULL
														BEGIN
															INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (e) Created Blank Content for Required Page named ' + @_tok + ' #_formattedString#');
														END
													END
												END
												ELSE
												BEGIN
													SELECT @_pati = PATINDEX( @_patt , @_listOfRequiredRight_sidePages);
													INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (11) DEBUG: Is (' + @_patt + ') a pattern in (' + @_listOfRequiredRight_sidePages + ') (' + CAST(@_pati AS varchar(10)) + ')');
													IF @_pati > 0
													BEGIN
														SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLright_side# WHERE (pageId = @_aPageId) AND (rid = @prid));
									
														IF @_cid IS NULL
														BEGIN
															INSERT INTO #_DynamicHTMLright_side# (pageId, html, rid) VALUES (@_aPageId, @_placeHolder, @prid);
														
															SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLright_side# WHERE (pageId = @_aPageId) AND (rid = @prid));
										
															IF @_cid IS NOT NULL
															BEGIN
																INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (f) Created Blank Content for Required Page named ' + @_tok + ' #_formattedString#');
															END
														END
													END
													ELSE
													BEGIN
														SELECT @_pati = PATINDEX( @_patt , @_listOfRequiredFooterPages);
														INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (12) DEBUG: Is (' + @_patt + ') a pattern in (' + @_listOfRequiredFooterPages + ') (' + CAST(@_pati AS varchar(10)) + ')');
														IF @_pati > 0
														BEGIN
															SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLfooter# WHERE (pageId = @_aPageId) AND (rid = @prid));
										
															IF @_cid IS NULL
															BEGIN
																INSERT INTO #_DynamicHTMLfooter# (pageId, html, rid) VALUES (@_aPageId, @_placeHolder, @prid);
															
																SELECT @_cid = (SELECT TOP 1 id FROM #_DynamicHTMLfooter# WHERE (pageId = @_aPageId) AND (rid = @prid));
											
																IF @_cid IS NOT NULL
																BEGIN
																	INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: (g) Created Blank Content for Required Page named ' + @_tok + ' #_formattedString#');
																END
															END
														END
													END
												END
											END
										END
									END
								END
							END
						END
						SELECT @_j = @_i + 1;
					END
	
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Sanity Check for Required Pages #_formattedString#');
				END
		">
	</cfif>

	<cfset _SQL_statement = "#_SQL_statement#
			END
		END
	">
<cfelseif (ListLen(submit, "|") eq 2) AND (GetToken(submit, 1, "|") eq _purgeThisArchivesAction_symbol)>
	<cfset _SQL_statement = "#_SQL_statement#
		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Performing Archive Purge (Release Number #_relNum#) #_formattedString#');

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Purging #_ReleaseManagement# entities #_formattedString#');

		DELETE FROM #_ReleaseManagement#
		WHERE (id = #_rid#);

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Purged #_ReleaseManagement# entities #_formattedString#');

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Purging #_DynamicPageManagement# entities #_formattedString#');
		
		DELETE FROM #_DynamicPageManagement#
		WHERE (rid = #_rid#);

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Purged #_DynamicPageManagement# entities #_formattedString#');

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Purging #_DynamicHTMLpad# entities #_formattedString#');
		
		DELETE FROM #_DynamicHTMLpad#
		WHERE (rid = #_rid#);

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Purged #_DynamicHTMLpad# entities #_formattedString#');

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Purging #_DynamicHTMLContent# entities #_formattedString#');
		
		DELETE FROM #_DynamicHTMLContent#
		WHERE (rid = #_rid#);

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Purged #_DynamicHTMLContent# entities #_formattedString#');

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Purging #_DynamicHTMLsepg_section# entities #_formattedString#');
		
		DELETE FROM #_DynamicHTMLsepg_section#
		WHERE (rid = #_rid#);

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Purged #_DynamicHTMLsepg_section# entities #_formattedString#');

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Purging #_DynamicHTMLsepg_links# entities #_formattedString#');
		
		DELETE FROM #_DynamicHTMLsepg_links#
		WHERE (rid = #_rid#);

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Purged #_DynamicHTMLsepg_links# entities #_formattedString#');

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Purging #_DynamicHTMLright_side# entities #_formattedString#');
		
		DELETE FROM #_DynamicHTMLright_side#
		WHERE (rid = #_rid#);

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Purged #_DynamicHTMLright_side# entities #_formattedString#');

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Purging #_DynamicHTMLfooter# entities #_formattedString#');
		
		DELETE FROM #_DynamicHTMLfooter#
		WHERE (rid = #_rid#);

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Purged #_DynamicHTMLfooter# entities #_formattedString#');

		INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid#,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Performed Archive Purge (Release Number #_relNum#) #_formattedString#');
	">
<cfelseif (ListLen(submit, "|") eq 2) AND (GetToken(submit, 1, "|") eq _initialDevelopAction_symbol)>
	<cfset _SQL_statement = "#_SQL_statement#
		DECLARE @rNum as int;
		DECLARE @_rid as int;
		DECLARE @pgid as int;
		DECLARE @_pgid as int;
		DECLARE @_newPgId as int;
		DECLARE @_cid as int;

		DECLARE @num as int;
		SELECT @num = (SELECT count(id) FROM #_ReleaseManagement# WHERE (devDateTime IS NOT NULL));

		IF @num = 0
		BEGIN
			SELECT @rNum = (@num + 1);

			INSERT INTO #_ReleaseManagement# (releaseNumber, devDateTime, uid, prodDateTime, archDateTime, comments) 
				VALUES (@rNum,GETDATE(),#VerifyUserSecurity2.uid#,NULL,NULL,'Initial Release Created by SBCUID #VerifyUserSecurity2.userid#')

			SELECT @_rid = (SELECT TOP 1 id FROM #_ReleaseManagement# WHERE (releaseNumber = @rNum));

			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Successfully created Initial Release #_formattedString#');

			SELECT @pgid = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# ORDER BY pageId DESC);
			
			IF @pgid IS NULL
				SELECT @pgid = 1;

			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: BEGIN: Creating Required Pages #_formattedString#');
	">

	<cfif (IsDefined("_listOfRequiredPages")) AND (Len(_listOfRequiredPages) gt 0) AND (_cfapplication_name eq const_cfapplication_name_default_symbol)>
		<cfset _pgNum = 1>
		<cfloop index="_aPageName" list="#_listOfRequiredPages#" delimiters=",">
			<cfset _SQL_statement = "#_SQL_statement#
				SELECT @_newPgId = (@pgid + #_pgNum#);
				
				INSERT INTO #_DynamicPageManagement# (pageId, pageName, PageTitle, versionDateTime, rid)
					VALUES (@_newPgId, '#_aPageName#', '[#_aPageName#]', NULL, @_rid);

				SELECT @_pgid = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageId = @_newPgId) AND (rid = @_rid));

				IF @_pgid IS NOT NULL
				BEGIN
					INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Created Required Page named #_aPageName# #_formattedString#');

			">

			<cfset _tableName = "">
			<cfset _placeHolder = "">
			<cfif (ListFindNoCase(_listOfRequiredSpecialPages, _aPageName, ",") eq 0)>
				<cfset _tableName = _DynamicHTMLContent>
			<cfelseif (ListFindNoCase(_listOfRequiredQuickLinksPages, _aPageName, ",") gt 0)>
				<cfset _tableName = _DynamicHTMLpad>
			<cfelseif (ListFindNoCase(_listOfRequiredMenuPagePages, _aPageName, ",") gt 0)>
				<cfset _tableName = _DynamicHTMLmenu>
				<cfset _placeHolder = ".| |Placeholder,##-1">
			<cfelseif (ListFindNoCase(_listOfRequiredSepg_sectionPages, _aPageName, ",") gt 0)>
				<cfset _tableName = _DynamicHTMLsepg_section>
			<cfelseif (ListFindNoCase(_listOfRequiredSepg_linksPages, _aPageName, ",") gt 0)>
				<cfset _tableName = _DynamicHTMLsepg_links>
			<cfelseif (ListFindNoCase(_listOfRequiredRight_sidePages, _aPageName, ",") gt 0)>
				<cfset _tableName = _DynamicHTMLright_side>
			<cfelseif (ListFindNoCase(_listOfRequiredFooterPages, _aPageName, ",") gt 0)>
				<cfset _tableName = _DynamicHTMLfooter>
			</cfif>
			
			<cfif (Len(_tableName) gt 0)>
				<cfset _SQL_statement = "#_SQL_statement#
					INSERT INTO #_tableName# (pageId, html, rid) VALUES (@_newPgId, '#_placeHolder#', @_rid);
				
					SELECT @_cid = (SELECT TOP 1 id FROM #_tableName# WHERE (pageId = @_newPgId) AND (rid = @_rid));

					IF @_cid IS NOT NULL
						INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: Created Blank Content for Required Page named #_aPageName# #_formattedString#');
				">
			</cfif>

			<cfset _SQL_statement = "#_SQL_statement#
				END
			">
			<cfset _pgNum = IncrementValue(_pgNum)>
		</cfloop>

		<cfset _SQL_statement = "#_SQL_statement#
			INSERT INTO #_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@_rid,GETDATE(),'SBCUID #VerifyUserSecurity2.userid#: END: Created Required Pages #_formattedString#');
		">
	</cfif>

	<cfset _SQL_statement = "#_SQL_statement#
		END
	">
</cfif>

<cfif (function neq _purgedArchivesReportAction_symbol)>
	<cfif (IsDefined("_SQL_statement")) AND (Len(_SQL_statement) gt 0)>
		<cfquery name="SetReleaseData" datasource="#DSNSource#" username="#DSNUser#" password="#DSNPassword#">
			#PreserveSingleQuotes(_SQL_statement)#
		</cfquery>
	</cfif>

	<cfset _SQL_statement = "
		SELECT #_ReleaseManagement#.id, 
		    #_ReleaseManagement#.releaseNumber, 
		    #_ReleaseManagement#.uid, 
		    #_ReleaseManagement#.devDateTime, 
		    #_ReleaseManagement#.prodDateTime, 
		    #_ReleaseManagement#.archDateTime, 
		    #_ReleaseManagement#.stageDateTime, 
		    #_ReleaseManagement#.comments as theComment, 
		    #_ReleaseActivityLog#.dateTime, 
			#_ReleaseManagementComments#.id AS cid,
		    #_ReleaseManagementComments#.aDateTime,
		    #_ReleaseManagementComments#.comments,
			#_ReleaseActivityLog#.id AS lid,
		     #_ReleaseActivityLog#.comments AS releaseLog
		FROM #_ReleaseManagementComments# RIGHT
		     OUTER JOIN
		    #_ReleaseActivityLog# ON 
		    #_ReleaseManagementComments#.rid = #_ReleaseActivityLog#.rid
		     RIGHT OUTER JOIN
		    #_ReleaseManagement# ON 
		    #_ReleaseActivityLog#.rid = #_ReleaseManagement#.id
		WHERE (#_ReleaseActivityLog#.comments NOT LIKE '%DEBUG:%')
		ORDER BY #_ReleaseManagement#.releaseNumber, #_ReleaseActivityLog#.id, #_ReleaseActivityLog#.dateTime DESC
	">

	<cfif (IsDefined("_SQL_statement")) AND (Len(_SQL_statement) gt 0)>
		<cfquery name="GetReleaseData0" datasource="#DSNSource#" username="#DSNUser#" password="#DSNPassword#" cachedwithin="#CreateTimeSpan(0, 0, 0, 10)#">
			#PreserveSingleQuotes(_SQL_statement)#
		</cfquery>

		<cfif 1>
			<CFQUERY dbtype="query" name="GetReleaseData">
				SELECT DISTINCT id, releaseNumber, uid, devDateTime, prodDateTime, archDateTime, stageDateTime, dateTime, theComment
				FROM GetReleaseData0
			</cfquery>
		<cfelse>
			<cfscript>
				i = -1;
				try {
					q = CommonCode.execQofQ(1);
				} catch(Database e) {
					WriteOutput(CommonCode.dbError(e));
				}
			</cfscript>
		</cfif>

		<cfif 1>
			<CFQUERY dbtype="query" name="GetLatestStagedRelease">
				SELECT DISTINCT id, releaseNumber, uid, devDateTime, prodDateTime, archDateTime, stageDateTime
				FROM GetReleaseData0
				WHERE (stageDateTime IS NOT NULL)
				ORDER BY stageDateTime DESC
			</cfquery>
		<cfelse>
			<cfscript>
				i = -1;
				try {
					q = CommonCode.execQofQ(2);
				} catch(Database e) {
					WriteOutput(CommonCode.dbError(e));
				}
			</cfscript>
		</cfif>
	</cfif>
<cfelse>
	<cfset _SQL_statement = "#_SQL_statement#
		SELECT TOP 100 PERCENT rid, dateTime, comments
		FROM #_ReleaseActivityLog#
		WHERE (rid NOT IN
		        (SELECT id AS rid
		      FROM #_ReleaseManagement#))
		ORDER BY rid, dateTime
	">

	<cfif (IsDefined("_SQL_statement")) AND (Len(_SQL_statement) gt 0)>
		<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetReleaseData" datasource="#DSNSource#">
			#PreserveSingleQuotes(_SQL_statement)#
		</cfquery>
	</cfif>
</cfif>

<cfset _aSQL = CommonCode.sql_getCurrentRelease_rid( _ReleaseMode, _ReleaseManagement)>

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

	SELECT @prid as rid, @locked as locked, @lockedBy as lockedBy, @lockedSBCUID as lockedSBCUID;
">
<!--- END! Had to make this query separate because a syntax error in a T-SQL Script will cause the whole T-SQL Script to fail (all or nothing) --->

<cfif Len(_SQL_statement3) gt 0>
	<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetSecurityData" datasource="#DSNSource#">
		#PreserveSingleQuotes(_SQL_statement3)#
	</cfquery>
</cfif>

