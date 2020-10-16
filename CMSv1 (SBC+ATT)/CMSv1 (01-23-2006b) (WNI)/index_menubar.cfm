<cfoutput>
	<div id="sepg_links">
		<cfif (_ReleaseMode eq 1)>
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr>
					<td width="38%">
		</cfif>
		<p><small>
			<cfif (_AdminMode eq 1) OR (_ReleaseMode eq 1) OR (_SecurityMode eq 1) OR (_LayoutMode eq 1)>
				<cfif (CommonCode.is_htmlArea_editor())>
					<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("_actualSize_percent_display", "positional_delayed_tooltips_menuBar")>
				<cfelse>
					<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_actualSize_percent_display")>
				</cfif>
				<a #_tooltips_# title="This is the actual percentage of #Request._maxDbSize_mb_# MB SQL Server 2000 Reports has been allocated to the database - SQL Server 2000 cannot know how much physical disk space exists for this database only the size of the data files that have been allocated by SQL Server 2000.  Database Log Files can consume a fair amount of disk space so it becomes necessary to truncate the Log Files on a regular basis in order to keep the database as small as possible relative to the physical disk space being consumed by the database files.  Certain database settings can affect the size of the data files; see your DBA (DataBase Administrator) or others who can adjust these settings for your database."><font color="##0000ff" size="1"><small>[DB #_actualSize_percent#%]</small></font></a>
			</cfif>
			<cfif (_AdminMode eq 1) AND (IsDefined("GetLatestStagedReleases")) AND (GetLatestStagedReleases.recordCount gt 0)>
				<cfset verbose_releaseStatus = Trim(CommonCode.getVerboseReleaseStatus(commonCode.getReleaseStatus( "", "", "", GetLatestStagedReleases.stageDateTime)))>
				<cfset _dateTime = CommonCode.formattedDateTimeTZ(GetLatestStagedReleases.stageDateTime)>
				<cfset _stagingLinkTitle = " (The Staging Release can be viewed by clicking this link.  There can be only one Staging Releases in the Database.)">
				#CommonCode.makePopupStagingLink("currentPage", currentPage, "Staging Release ###GetLatestStagedReleases.releaseNumber#&nbsp;&nbsp;(#GetLatestStagedReleases.currentRow#/#GetLatestStagedReleases.recordCount#)&nbsp;&nbsp;#UCase(verbose_releaseStatus)#&nbsp;#_dateTime##_stagingLinkTitle#", "_blank")#
				<br>
			</cfif>
			<a href="#cgi_SCRIPT_NAME#?currentPage=#homePage_symbol#" title="PM Pofessionalism Home Page">#Request._site_name# #Request._adminTitle#Home Page&nbsp;</a>
			<cfif (_ReleaseMode eq 0) AND (_SecurityMode eq 0) AND (_LayoutMode eq 0) AND (NOT is_htmlArea_editor)>
				<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("id_site_search_link")>
				<cfset _siteSearchTips = "Only user-supplied Pages of Content that are displayable in the main Content area are searched. The types of content that are NOT searched are pages such as those that appear in the following Layout areas: Header, Marquee, MenuBar, Menu, QuickLinks, Pix, RightSide and Footer.">
				<a href="" #_tooltips_# name="id_site_search_link" title="Site Search Facility - allows content for this site to be searched using Keywords. #_siteSearchTips#" onclick="return processSiteSearchClick(this.id);" ondblclick="return false;">#function_siteSearch_symbol#</a>
			</cfif>
			<cfif (_AdminMode eq 1) AND 0>
				[#(_AdminMode eq 1)#] [#(UCASE(function) neq UCASE(_uploadImageAction_symbol))#] [#(IsDefined("VerifySecurity_UploadImages"))#] [#(VerifySecurity_UploadImages.recordCount gt 0)#] [#(IsDefined("GetCurrentContent"))#] [#(GetCurrentContent.recordCount gt 0)#]
			</cfif>
			<cfif (_AdminMode eq 1) AND (UCASE(function) neq UCASE(_uploadImageAction_symbol)) AND (IsDefined("VerifySecurity_UploadImages")) AND (VerifySecurity_UploadImages.recordCount gt 0) AND (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0)>
				#_imagesUploaderLink#
			</cfif>
			<cfif (_AdminMode eq 1) AND (NOT is_htmlArea_editor) AND (IsDefined("VerifySecurity_SiteCSS")) AND (VerifySecurity_SiteCSS.recordCount gt 0) AND (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0)>
				#_siteCSSEditorLink#
			</cfif>
			<cfif (_ReleaseMode eq 0) AND (_SecurityMode eq 0) AND (_LayoutMode eq 0) AND (NOT is_htmlArea_editor)>
				<cfif (_AdminMode eq 1) AND (IsDefined("VerifySecurity_sepg_links")) AND (VerifySecurity_sepg_links.recordCount gt 0)>
					<cfif (IsDefined("_editorAction_symbol")) AND (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.sepg_links")) AND (GetCurrentContent.recordCount gt 0)>
						<!--- BEGIN: This is the sepg_links which is in the menubar of the site... --->
						<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Menu Bar page of content.">
						<cfif 0>
							<cfset _sepg_links_editor = CommonCode.makeUserPageEditorLink( _editorAction_symbol, "", _sepg_links_pageName_symbol, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
						<cfelse>
							<cfset _sepg_links_editor = CommonCode.makeUserPageEditorLink2( "_menuBarPage_editor_", _editor_title_, _editorAction_symbol, "", _sepg_links_pageName_symbol, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
						</cfif>
						#_sepg_links_editor#
						<!--- END! This is the sepg_links which is in the menubar of the site... --->
					</cfif>
				</cfif>
				<cfif (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.sepg_links")) AND (GetCurrentContent.recordCount gt 0)>
					<cfloop query="GetCurrentContent" startrow="1" endrow="#GetCurrentContent.recordCount#">
						<cfif Len(GetCurrentContent.sepg_links) gt 0>
							<cfset _sepg_links_html = CommonCode.correctHTMLtags( GetCurrentContent.sepg_links, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
							<cfset _sepg_links_html = CommonCode.correctHTMLtags( _sepg_links_html, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>
							#_sepg_links_html#
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfif (_SecurityMode eq 1) AND (NOT is_htmlArea_editor) AND 0>
				<A title=Webphone href="http://phone.sbc.com" target=_blank>&nbsp;web phone&nbsp;</A>
			</cfif>
			<cfif (_ReleaseMode eq 1) AND (CommonCode.isServerLocal())>
				<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetDatabaseConversionStats" datasource="#DSNSource#">
					SELECT count(id) as recCount FROM #_ReleaseManagementComments# WHERE (aDateTime IS NULL)
				</cfquery>
				<cfif (IsDefined("GetDatabaseConversionStats")) AND (GetDatabaseConversionStats.recordCount gt 0) AND (GetDatabaseConversionStats.recCount gt 0)>
					<A href="database_conversion_add_datetime_to_comments.cfm" target=_blank>&nbsp;[database_conversion_add_datetime_to_comments.cfm]&nbsp;</A>
				</cfif>
			</cfif>
		</small>
		<cfif (CommonCode.is_htmlArea_editor())>
			<span style="display: inline; visibility: hidden;"><a href="" name="positional_delayed_tooltips_menuBar" id="positional_delayed_tooltips_menuBar">xxx</a></span>
		</cfif>
		</p>
		<cfif (_ReleaseMode eq 1)>
					</td>
					<td width="*">
						<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("open_process_indicator")>
						<input type="text" #_tooltips_# size="55" maxlength="255" readonly #_textarea_style_symbol#>
		</cfif>
		<cfif (_ReleaseMode eq 1)>
					</td>
				</tr>
			</table>
		</cfif>
	</div>
	<cfif (_ReleaseMode eq 0) AND (_SecurityMode eq 0) AND (_LayoutMode eq 0) AND (NOT is_htmlArea_editor)>
		<div id="form_site_search_link" style="display: none; position: absolute;">
			<table width="400px" bgcolor="##FFFFBF" border="1" cellpadding="-1" cellspacing="-1">
				<tr>
					<td>
						<form action="#CGI.SCRIPT_NAME#" method="post" onsubmit="return processSiteSearchFormSubmit(this);">
							<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
							<small><b>Keyword:</b></small>&nbsp;<input type="text" name="site_search_keyword" id="site_search_keyword" size="20" maxlength="50"><br>
							<input type="hidden" name="_submit_" value="#function_performSearch_symbol#">
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("id_submitButton")>
							<input type="button" #_tooltips_# name="submitButton" value="#function_performSearch_symbol#" title="Click this button to perform a keyword search on all the content for this site. #_siteSearchTips#" #_textarea_style_symbol# onclick="return processSiteSearchFormSubmit(this.form);" ondblclick="return false;">&nbsp;
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("id_cancelButton")>
							<input type="button" #_tooltips_# name="cancelButton" value="#function_cancelButton_symbol#" title="Click this button to close this dialog." #_textarea_style_symbol# onclick="return processCloseSiteSearchDialog();" ondblclick="return false;">
						</form>
					</td>
				</tr>
			</table>
		</div>
	</cfif>
</cfoutput>

