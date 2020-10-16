<cfoutput>
	<cfif (_LayoutMode eq 0) AND (NOT is_htmlArea_editor)>
		<div id="marquee_header">
			<div id="marquee_section">
				<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (IsDefined("GetEditableMarqueeContent")) AND (_ReleaseMode eq 0) AND (_SecurityMode eq 0) AND (Len(function) eq 0) AND (Len(submit) eq 0)>
					<td valign="top">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td valign="top">
									<cfif (_AdminMode eq 1) AND (IsDefined("VerifySecurity_MarqueeEditor")) AND (VerifySecurity_MarqueeEditor.recordCount gt 0)>
										#_marqueeEditorLink#
									<cfelse>
										&nbsp;
									</cfif>
									<cfif (CGI.REMOTE_HOST eq _debugIP) AND 0>
										<br><br>#_marqueeDataFillerLink#
									</cfif>
								</td>
								<td valign="top">
									<cfset _scrollerContent = '
										<span>
											#CommonCode.marqueeArticle_list(GetEditableMarqueeContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol, _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _ContentPageList)#
										</span>
									'>
									<cfset _scrollerHeadlines = '
										<span>
											#CommonCode.marqueeHeadlines_list(GetEditableMarqueeContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol, _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _ContentPageList)#
										</span>
									'>
									<cfset site_width = CommonCode.getSiteWidthSpecFromLayoutCodes(_layout_spec_codes, "True", 'width="990px"')>
									<cfset _site_width = ReplaceNoCase(ReplaceNoCase(site_width, "px", ""), '"', '', 'all')>
									<cfset _width = CommonCode.getMarqueeWidthSpecFromLayoutCodes(_layout_spec_codes, "True", 'width="990px"')>
									<cfif (Find("%", _width) gt 0)>
										<cfif (Find("%", site_width) eq 0)>
											<cfset _width = (_site_width * (Int(ReplaceNoCase(_width, "%", "")) / 100.0))>
										</cfif>
									<cfelse>
										<cfset _width = ReplaceNoCase(_width, "px", "")>
									</cfif>
									#CommonCode.announcementScrollerMarquee(_images_folder, 45, _width, _scrollerHeadlines, _scrollerContent)#
								</td>
							</tr>
						</table>
					</td>
				</cfif>
			</div>
		</div>
	
		<cfset _file = GetFileFromPath(CGI.CF_TEMPLATE_PATH)>
		<cfif ( (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (_adminMode eq 1) AND (UCASE(_file) eq UCASE(_index_cfm_fileName)) )>
			<div id="sepg_section">
				<div id="marqueeEditor_pane" style="display: none;">
					<cfset _theFontColor = "black">
					<cfif (IsDefined("VerifySecurity_MarqueeEditor")) AND (VerifySecurity_MarqueeEditor.recordCount gt 0)>
						<table width="990px" bgcolor="##FFFFBF" cellpadding="-1" cellspacing="-1">
							<tr>
								<td width="300px" valign="top">
									<table border="1" width="20%" cellpadding="1" cellspacing="1" id="marqueeRecordEditor_pane" style="display: none;">
										<tr>
											<td>
												<form action="#CGI.SCRIPT_NAME#" method="post" onsubmit="return handleMarqueeRecordValidationForSubmit();">
												<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
												<NOBR><font color="#_theFontColor#" size="1"><small><b>Headline:</b></small></font></NOBR>
											</td>
											<td>
												<input type="button" id="headline_openeditor_button" title="Open the WYSIWYG HTML Editor for the headline..." value="..." onclick="openWYSIWYG_htmlEditor('headline'); return false;">
												#CommonCode.wysiwygEditor_pane("headline")#
											</td>
										</tr>
										<tr>
											<td>
												<NOBR><font color="#_theFontColor#" size="1"><small><b>Article:</b></small></font>&nbsp;</NOBR>
											</td>
											<td>
												<input type="button" id="article_openeditor_button" title="Open the WYSIWYG HTML Editor for the article..." value="..." onclick="openWYSIWYG_htmlEditor('article'); return false;">
												#CommonCode.wysiwygEditor_pane("article")#
											</td>
										</tr>
										<tr>
											<td>
												<NOBR><font color="#_theFontColor#" size="1"><small><b>Begin Date:</b></small></font></NOBR>
											</td>
											<td>
												#CommonCode.wysiwygDate_pane("BeginDate", _textarea_style_symbol)#
											</td>
										</tr>
										<tr>
											<td>
												<NOBR><font color="#_theFontColor#" size="1"><small><b>End Date:</b></small></font></NOBR>
											</td>
											<td>
												#CommonCode.wysiwygDate_pane("EndDate", _textarea_style_symbol)#
											</td>
										</tr>
										<tr>
											<td colspan="2" align="center" valign="top">
												<input type="hidden" name="recid" id="marqueeRecordEditor_recid" value="-1">
												<input type="hidden" name="m_curpage" id="marqueeRecordEditor_curPage" value="-1">
												<input type="submit" name="submit" id="marqueeRecordEditor_actionButton" title="Click this button to perform the function shown on the button's face." value="#_saveMarqueeButton_symbol#" style="font-size: 10px;">
												<input type="button" value="#_cancelButton_symbol#" style="font-size: 10px;" title="Click this button to cancel this operation." onClick="closeMarqueeEditorAction(); return false;">
												<p align="justify" style="font-size: 9px;"><font color="#_theFontColor#">Headline and Article fields are required however the beginning and ending dates are not required and are optional. The Headline is shown when the Marquee is shown in the default state and the full Article is shown when the Marquee is shown in the expanded or open state.  The Headline should be a more condensed version of the Article or simply the "headline".  The analogy is similar to a newspaper story that has a "headline" to grab the readers attention and the article that gives the details.  Specify a Begin Date to cause an Announcement to be show beginning on that date/time. Specify an End Date to cause an Announcement to be cease being shown on that date/time.  End Date(s) <u><b>MUST</b></u> be after the Begin Date(s) in all instances.</font></p>
												<p align="justify" style="font-size: 9px;"><font color="#_theFontColor#">Once begin/end dates have been specified they cannot be removed however they can be made arbitrarily long which is the same as removing them from the database.</font></p>
												<p align="justify" style="font-size: 9px;"><font color="#_theFontColor#"><b>Note:</b> Announcements are "live" the moment they are saved in the database which is to say visitors to the "live" Production site view will see all Announcements based on the begin/end dates for each Announcement.</font></p>
												<p align="justify" style="font-size: 9px;"><font color="#_theFontColor#"><b>Addendum:</b> Announcements that reference web links that resolve to pages of content that "may" not be available at run-time will not be shown from those Releases where those unavailable pages of content are in-fact not available.  In other words, be very careful when creating Announcements that have web links to internal pages of content because Announcements are global to all Releases but not all pages of content exist in all Releases.</font></p>
												</form>
											</td>
										</tr>
									</table>
								</td>
								<td width="690px" valign="top" align="right"> <!---  bgcolor="##00ffff" --->
									<cfset _marqueeTableBrowser_pane_style = "display: none;">
									<cfif (IsDefined("GetEditableMarqueeContent"))>
										<cfset _marqueeTableBrowser_pane_style = "display: inline;">
									</cfif>
									<div id="marqueeTableBrowser_pane" style="#_marqueeTableBrowser_pane_style#">
										<table border="1" width="100%" cellpadding="1" cellspacing="1">
											<tr>
												<td align="right">
													<cfif (IsDefined("GetEditableMarqueeContent"))>
														#CommonCode.marqueeBrowser_pane(GetEditableMarqueeContent)#
													</cfif>
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</cfif>
				</div>
			</div>
		</cfif>
	</cfif>
</cfoutput>

