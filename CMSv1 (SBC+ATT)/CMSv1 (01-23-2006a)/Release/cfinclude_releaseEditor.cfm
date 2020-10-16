<cfset _small_style_symbol = 'style="font-size: 10px;"'>
<cfset _text_style_symbol = 'style="font-size: 10px;"'>

<cfset _saveButton_style_symbol = 'style="font-size: 10px; color: black;"'>

<cfset _textarea_style_symbol = 'style="font-size: 11px;"'>
<cfset _textarea_cols = 110>
<cfset _textarea_rows = 10>

<cfset isMenuLocked = "False">

<cfoutput>
	<div id="header">
		<div id="welcome">
			<table width="990px" cellpadding="-1" cellspacing="-1">
				<tr>
					<td width="44%">
						<h2>#Request._site_name# - Release</h2>
					</td>
					<td width="*" valign="top">
						<cfif (IsDefined("GetSecurityData")) AND (GetSecurityData.recordCount gt 0) AND (IsDefined("GetSecurityData.rid")) AND (Len(GetSecurityData.rid) gt 0) AND (Len(GetSecurityData.lockedSBCUID) gt 0)>
							<cfset isMenuLocked = "True">
							<cfset _timeString = CommonCode.formattedDateTimeTZ(Now())>
							<cfset locked_timeString = CommonCode.formattedDateTimeTZ(ParseDateTime(GetSecurityData.locked))>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td valign="top">
										<span style="font-size: 9px;">
											<font size="1">
											<small>
											<cfset emailLink_locked_menuEditor = CommonCode.makeMenuInUseContactUserLink(GetSecurityData.lockedSBCUID, "blue")>
											<cfif (UCASE(GetSecurityData.lockedSBCUID) EQ UCASE(_AUTH_USER))>
												<cfset emailLink_locked_menuEditor = GetSecurityData.lockedSBCUID>
											</cfif>
											<b>#_timeString# :: Menu Editor is currently <u>in-use</u> by SBCUID <font color="##0000ff">#emailLink_locked_menuEditor#</font> as of<br><font color="##0000ff">#locked_timeString#</font>.</b>
											</small>
											</font>
											&nbsp;
											<font size="1">
											<small>
											<font color="##ff0000"><b>The "state" of the Draft Release <u>CANNOT</u> be changed until the Menu Editor Lock has been released by either the user who has the lock or the /Security SubSystem.</b></font>
											</small>
											</font>
										</span>
									</td>
								</tr>
							</table>
						<cfelse>
							&nbsp;
						</cfif>
					</td>
				</tr>
			</table>
		</div>

		<div id="maintext">
			<table width="990px" cellspacing="-1" cellpadding="-1" style="font-size: 10px;">
				<cfset _this_table_cells_width = "30px">
				<tr bgcolor="##c0c0c0">
					<td width="#_this_table_cells_width#" align="center" valign="top">
						<div id="_vcrControl_Begin" style="display: none;">
							<font color="#_enabled_color#">
							<small>
							<b>
							<a href="" name="_vcrControl_Begin" title="Scroll to First Tab" onClick="_allow_RefreshVCRControls = false; _FocusOnThisTab(1); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrBeginAction_symbol#</a>
							</b>
							</small>
							</font>
						</div>
						<div id="_vcrControl_Begin_disabled" style="display: none;">
							<font color="#_disabled_color#">
							<small>
							#_vcrBeginAction_symbol#
							</small>
							</font>
						</div>
					</td>
					<td width="#_this_table_cells_width#" align="center" valign="top">
						<div id="_vcrControl_PrevPage" style="display: none;">
							<font color="#_enabled_color#">
							<small>
							<b>
							<a href="" title="Scroll Left Two Pages of Tabs" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(_vis_tabs_begin - _num_vis_tabs_max); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrPrevPageAction_symbol#</a>
							</b>
							</small>
							</font>
						</div>
						<div id="_vcrControl_PrevPage_disabled" style="display: none;">
							<font color="#_disabled_color#">
							<small>
							#_vcrPrevPageAction_symbol#
							</small>
							</font>
						</div>
					</td>
					<td width="#_this_table_cells_width#" align="center" valign="top">
						<div id="_vcrControl_Prev" style="display: none;">
							<font color="#_enabled_color#">
							<small>
							<b>
							<a href="" title="Scroll Left One Page of Tabs" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(_vis_tabs_begin - 1); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrPrevAction_symbol#</a>
							</b>
							</small>
							</font>
						</div>
						<div id="_vcrControl_Prev_disabled" style="display: none;">
							<font color="#_disabled_color#">
							<small>
							#_vcrPrevAction_symbol#
							</small>
							</font>
						</div>
					</td>
					<td width="#_this_table_cells_width#" align="center" valign="top">
						<div id="_vcrControl_Next" style="display: none;">
							<font color="#_enabled_color#">
							<small>
							<b>
							<a href="" title="Scroll Right One Page of Tabs" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(_vis_tabs_end + 1); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrNextAction_symbol#</a>
							</b>
							</small>
							</font>
						</div>
						<div id="_vcrControl_Next_disabled" style="display: none;">
							<font color="#_disabled_color#">
							<small>
							#_vcrNextAction_symbol#
							</small>
							</font>
						</div>
					</td>
					<td width="#_this_table_cells_width#" align="center" valign="top">
						<div id="_vcrControl_NextPage" style="display: none;">
							<font color="#_enabled_color#">
							<small>
							<b>
							<a href="" title="Scroll Right Two Pages of Tabs" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(_vis_tabs_end + _num_vis_tabs_max); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrNextPageAction_symbol#</a>
							</b>
							</small>
							</font>
						</div>
						<div id="_vcrControl_NextPage_disabled" style="display: none;">
							<font color="#_disabled_color#">
							<small>
							#_vcrNextPageAction_symbol#
							</small>
							</font>
						</div>
					</td>
					<td width="#_this_table_cells_width#" align="center" valign="top">
						<div id="_vcrControl_End" style="display: none;">
							<font color="#_enabled_color#">
							<small>
							<b>
							<a href="" title="Scroll to Last Tab" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(TabSystem.list['TabSystem1'].tabs.length); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrEndAction_symbol#</a>
							</b>
							</small>
							</font>
						</div>
						<div id="_vcrControl_End_disabled" style="display: none;">
							<font color="#_disabled_color#">
							<small>
							#_vcrEndAction_symbol#
							</small>
							</font>
						</div>
					</td>
					<cfset _this_table_cells_width6 = (Evaluate(Replace(_this_table_cells_width, 'px', '')) * 8)>
					<td width="#_this_table_cells_width6#px" height="30px" align="center" valign="top">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									<div id="_findKeywordRelease" style="display: inline;">
										<cfif 0>
											<NOBR>
											<font size="1">
											<small>
											<b>
											<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_lookupKeywordAction_")>
											<a href="" #_tooltips_# title="Perform an exhaustive Keyword Search within the Releases (searches the Tab Titles, the Release Comments and the Release Logs; the Tab Content, to the left of the comments, is not searched because that information is replicated in the Tab Titles). Because this is an exhaustive search it may run a bit slowly unless searching only the Tab Titles." onclick="processClickSearchKeywordLink(false); return false;">#_lookupKeywordAction_symbol#</a>
											</b>
											</small>
											</font>
											</NOBR>
										<cfelse>
											<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_lookupKeywordAction_")>
											<input type="button" #_text_style_symbol# #_tooltips_# value="#_lookupKeywordAction_symbol#" title="Perform an exhaustive Keyword Search within the Releases (searches the Tab Titles, the Release Comments and the Release Logs; the Tab Content, to the left of the comments, is not searched because that information is replicated in the Tab Titles). Because this is an exhaustive search it may run a bit slowly unless searching only the Tab Titles." style="display: inline;" onclick="this.disabled = true; processClickSearchKeywordLink(false); this.disabled = false; return false;" ondblclick="return false;">
										</cfif>
									</div>
								</td>
								<td>
									<div id="prev_findKeywordRelease" style="display: none;">
										<cfif 0>
											<NOBR>
											<font size="1">
											<small>
											<b>
											<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_lookupPrevAction_")>
											<a href="" #_tooltips_# title="Previous Keyword found from previous search operation." onclick="prevKeywordSearch(); return false;">#_lookupPrevAction_symbol#</a>
											</b>
											</small>
											</font>
											</NOBR>
										<cfelse>
											<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_lookupPrevAction_")>
											<input type="button" #_text_style_symbol# #_tooltips_# value="#_lookupPrevAction_symbol#" title="Previous Keyword found from previous search operation." style="display: inline;" onclick="this.disabled = true; prevKeywordSearch(); this.disabled = false; return false;" ondblclick="return false;">
										</cfif>
									</div>
								</td>
								<td>
									<div id="status_findKeywordRelease" style="display: none;">
									</div>
								</td>
								<td>
									<div id="next_findKeywordRelease" style="display: none;">
										<cfif 0>
											<NOBR>
											<font size="1">
											<small>
											<b>
											<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_lookupNextAction_")>
											<a href="" #_tooltips_# title="Next Keyword found from previous search operation." onclick="nextKeywordSearch(); return false;">#_lookupNextAction_symbol#</a>
											</b>
											</small>
											</font>
											</NOBR>
										<cfelse>
											<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_lookupNextAction_")>
											<input type="button" #_text_style_symbol# #_tooltips_# value="#_lookupNextAction_symbol#" title="Next Keyword found from previous search operation." style="display: inline;" onclick="this.disabled = true; nextKeywordSearch(); this.disabled = false; return false;" ondblclick="return false;">
										</cfif>
									</div>
								</td>
								<td>
									<div id="div_findKeywordRelease" style="display: none; position: absolute; top: 30px; left: 425px">
										<table width="400px" bgcolor="##FFFFBF" border="1" cellpadding="-1" cellspacing="-1">
											<tr>
												<td>
													<cfset _formAction = "var obj = getGUIObjectInstanceById('div_findKeywordRelease'); if (obj != null) { obj.style.display = const_none_style; } var obj = getGUIObjectInstanceById('_findKeywordRelease'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('tr_extraRowInHeader'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('td_extraRowInHeader'); if (obj != null) { obj.style.display = const_inline_style; }">
													<form id="form_findKeywordRelease" onSubmit="return checkandsubmit(null);">
														<table cellpadding="-1" cellspacing="-1">
															<tr>
																<td>
																	<small #_small_style_symbol#><b>Keyword:</b></small>&nbsp;
																	<input #_text_style_symbol# title="Enter the keyword you wish to search here. Keywords may not be regular expressions." type="text" id="_keyword" value="" size="80" maxlength="50" onkeydown="if (event.keyCode == 13) { #_formAction# var obj = getGUIObjectInstanceById('_keyword'); if (obj != null) { PerformKeywordSearch(obj.value); } return false;} else { return true; }">
																</td>
															</tr>
															<tr>
																<td>
																	<table cellpadding="1" cellspacing="1">
																		<tr>
																			<td>
																				<cfset _tabsOnly_title = "Tab-Title searches left to right from tab to tab but limited only to the tab titles.">
																				<input type="radio" title="#_tabsOnly_title#" id="strategy_tabsTitles_findKeywordRelease" name="strategy_findKeywordRelease" value="tab-titles">&nbsp;#CommonCode.osStyleRadioButtonCaption( "True", _tabsOnly_title, "strategy_tabsTitles_findKeywordRelease", '<NOBR><font size="1"><small #_small_style_symbol#><b>Tab-Titles</b></small></font></NOBR>')#
																			</td>
																			<td>
																				<cfset _depth_last_title = "Depth-Last searches left to right then top to bottom which means the bottom row is searched last.">
																				<input type="radio" title="#_depth_last_title#" id="strategy_shallow_findKeywordRelease" name="strategy_findKeywordRelease" checked value="depth-last">&nbsp;#CommonCode.osStyleRadioButtonCaption( "True", _depth_last_title, "strategy_shallow_findKeywordRelease", '<NOBR><font size="1"><small #_small_style_symbol#><b>Depth-Last</b></small></font></NOBR>')#
																			</td>
																			<td>
																				<cfset _depth_first_title = "Depth-First searches top to bottom then left to right which means the last tab is searched last.">
																				<input type="radio" title="#_depth_first_title#" id="strategy_deep_findKeywordRelease" name="strategy_findKeywordRelease" value="depth-first">&nbsp;#CommonCode.osStyleRadioButtonCaption( "True", _depth_first_title, "strategy_deep_findKeywordRelease", '<NOBR><font size="1"><small #_small_style_symbol#><b>Depth-First</b></small></font></NOBR>')#
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
															<tr>
																<td>
																	<input id="_submit_keyword_search_button" #_text_style_symbol# title="Press this button to begin the search process." type="submit" value="#_lookupSearchAction_symbol#" onclick="var kObj = getGUIObjectInstanceById('_keyword'); var cBtnObj = getGUIObjectInstanceById('cancel_keyword_search_button'); var formObj = getGUIObjectInstanceById('form_findKeywordRelease'); if ( (kObj != null) && (cBtnObj != null) && (formObj != null) ) { if (kObj.value.trim().length > 0) { #_formAction# global_PerformKeywordSearch_arg = kObj.value; register_disableButtons_function(deferred_PerformKeywordSearch); suppress_button_double_click2(this, cBtnObj, null); } else { alert('Cannot search for a blank keyword.'); } } return false;" ondblclick="return false;">&nbsp;
																</td>
																<td>
																	<input type="button" id="cancel_keyword_search_button" #_text_style_symbol# title="Press this button to cancel the keyword search dialog." value="#_cancelButton_symbol#" onClick="processClickSearchKeywordLink(true); return false;">
																</td>
															</tr>
														</table>
													</form>
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</td>
					<cfset _this_table_cells_width2 = Int((Evaluate(Replace(_this_table_cells_width, 'px', '')) * 1.5))>
					<td width="#_this_table_cells_width2#px" align="center" valign="top">
						<cfif 0>
							<NOBR>
							<font size="1">
							<small>
							<b>
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_findDraftRelease")>
							<a href="" #_tooltips_# title="Search for the Draft Release - there can be only one Draft Release in the database at any point in time. The Draft Release is the Release the users of the /Admin Subsystem interact with when working with their content." style="display: inline;" onclick="_allow_RefreshVCRControls = false; processClickSearchKeywordLink(true); FocusOnTabWithAnchorText('Draft'); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_lookupDraftAction_symbol#</a>
							</b>
							</small>
							</font>
							</NOBR>
						<cfelse>
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_findDraftRelease")>
							<input type="button" #_text_style_symbol# #_tooltips_# value="#_lookupDraftAction_symbol#" title="Search for the Draft Release - there can be only one Draft Release in the database at any point in time. The Draft Release is the Release the users of the /Admin Subsystem interact with when working with their content." style="display: inline;" onclick="this.disabled = true; _allow_RefreshVCRControls = false; processClickSearchKeywordLink(true); FocusOnTabWithAnchorText('Draft'); RefreshVCRControls(); _allow_RefreshVCRControls = true; this.disabled = false; return false;" ondblclick="return false;">
						</cfif>
					</td>
					<td width="#_this_table_cells_width2#px" align="center" valign="top">
						<cfif 0>
							<NOBR>
							<font size="1">
							<small>
							<b>
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_findStagingRelease")>
							<a href="" #_tooltips_# title="Search for the Staging Release - there can be only one Staging Release in the database at any point in time. The Staging Release is the Release the users of the /Admin Subsystem interact with when viewing their content when there is No Draft Release and there is a Staging Release." style="display: inline;" onclick="_allow_RefreshVCRControls = false; processClickSearchKeywordLink(true); FocusOnTabWithAnchorText('Staging'); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_lookupStagingAction_symbol#</a>
							</b>
							</small>
							</font>
							</NOBR>
						<cfelse>
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_findStagingRelease")>
							<input type="button" #_tooltips_# #_text_style_symbol# value="#_lookupStagingAction_symbol#" title="Search for the Staging Release - there can be only one Staging Release in the database at any point in time. The Staging Release is the Release the users of the /Admin Subsystem interact with when viewing their content when there is No Draft Release and there is a Staging Release." style="display: inline;" onclick="this.disabled = true; _allow_RefreshVCRControls = false; processClickSearchKeywordLink(true); FocusOnTabWithAnchorText('Staging'); RefreshVCRControls(); _allow_RefreshVCRControls = true; this.disabled = false; return false;" ondblclick="return false;">
						</cfif>
					</td>
					<td width="#_this_table_cells_width2#px" align="center" valign="top">
						<cfif 0>
							<NOBR>
							<font size="1">
							<small>
							<b>
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_findProductionRelease")>
							<a href="" #_tooltips_# title="Search for the Production Release - there can be only one Production Release in the database at any point in time.  The Production Release is the Release the visitors of this site will see; this is NOT the Release the users of the /Admin Subsystem interact with when working with their content." style="display: inline;" onclick="_allow_RefreshVCRControls = false; processClickSearchKeywordLink(true); FocusOnTabWithAnchorText('Production'); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_lookupProductionAction_symbol#</a>
							</b>
							</small>
							</font>
							</NOBR>
						<cfelse>
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_findProductionRelease")>
							<input type="button" #_text_style_symbol# #_tooltips_# value="#_lookupProductionAction_symbol#" title="Search for the Production Release - there can be only one Production Release in the database at any point in time.  The Production Release is the Release the visitors of this site will see; this is NOT the Release the users of the /Admin Subsystem interact with when working with their content." style="display: inline;" onclick="this.disabled = true; _allow_RefreshVCRControls = false; processClickSearchKeywordLink(true); FocusOnTabWithAnchorText('Production'); RefreshVCRControls(); _allow_RefreshVCRControls = true; this.disabled = false; return false;" ondblclick="return false;">
						</cfif>
					</td>
				</tr>
				<tr id="tr_extraRowInHeader" bgcolor="##c0c0c0">
					<td id="td_extraRowInHeader" width="100%" colspan="10">
						&nbsp;
					</td>
				</tr>
			</table>

			<cfset _releaseNumber = -1>
			<cfset _releaseNumber_iMax = 1>
			<cfset _areThereDinDb = "False">
			<cfset _areThereSinDb = "False">
			<cfif (IsDefined("GetReleaseData")) AND (GetReleaseData.recordCount gt 0)>
				<CFQUERY dbtype="query" name="GetNumReleases">
					SELECT DISTINCT releaseNumber
					FROM GetReleaseData
				</cfquery>

				<cfset _releaseNumber_iMax = 0>
				<cfif (IsDefined("GetNumReleases")) AND (GetNumReleases.recordCount gt 0)>
					<cfset _releaseNumber_iMax = GetNumReleases.recordCount>
				</cfif>
			</cfif>

			<CFQUERY dbtype="query" name="GetDraftReleases">
				SELECT DISTINCT releaseNumber
				FROM GetReleaseData
				WHERE (devDateTime IS NOT NULL)
			</cfquery>

			<cfif (IsDefined("GetDraftReleases")) AND (GetDraftReleases.recordCount gt 0)>
				<cfset _areThereDinDb = "True">
			</cfif>

			<CFQUERY dbtype="query" name="GetStagingReleases">
				SELECT DISTINCT releaseNumber
				FROM GetReleaseData
				WHERE (stageDateTime IS NOT NULL)
			</cfquery>

			<cfif (IsDefined("GetStagingReleases")) AND (GetStagingReleases.recordCount gt 0)>
				<cfset _areThereSinDb = "True">
			</cfif>
			
			<!--- BEGIN: Tabbed Interface goes here... --->
			<div id="TabSystem1" class="content">
				<div class="tabs">
					<cfset _class = "tab tabActive">
					<cfset _releaseNumber = -1>
					<cfset _releaseNumber_i = 1>
					<cfif (IsDefined("GetReleaseData")) AND (GetReleaseData.recordCount gt 0)>
						<CFQUERY dbtype="query" name="GetActualReleases">
							SELECT DISTINCT id, releaseNumber, devDateTime, prodDateTime, archDateTime, stageDateTime
							FROM GetReleaseData
							ORDER BY releaseNumber
						</cfquery>
	
						<cfif (IsDefined("GetActualReleases")) AND (GetActualReleases.recordCount gt 0)>
							<cfloop query="GetActualReleases" startrow="1" endrow="#GetActualReleases.recordCount#">
								<cfset _display = "inline">
								<cfif (GetActualReleases.currentRow gt _num_tabs_max)>
									<cfset _display = "none">
								</cfif>
								<div id="cell_tab#GetActualReleases.currentRow#" style="display: #_display#;">
									<cfset _dateTime = "">
									<cfif (Len(GetActualReleases.devDateTime) gt 0)>
										<cfset _dateTime = CommonCode.formattedDateTimeTZ(GetActualReleases.devDateTime)>
									<cfelseif (Len(GetActualReleases.prodDateTime) gt 0)>
										<cfset _dateTime = CommonCode.formattedDateTimeTZ(GetActualReleases.prodDateTime)>
									<cfelseif (Len(GetActualReleases.archDateTime) gt 0)>
										<cfset _dateTime = CommonCode.formattedDateTimeTZ(GetActualReleases.archDateTime)>
									<cfelseif (Len(GetActualReleases.stageDateTime) gt 0)>
										<cfset _dateTime = CommonCode.formattedDateTimeTZ(GetActualReleases.stageDateTime)>
									</cfif>
									<cfset verbose_releaseStatus = Trim(CommonCode.getVerboseReleaseStatus(commonCode.getReleaseStatus( GetActualReleases.devDateTime, GetActualReleases.prodDateTime, GetActualReleases.archDateTime, GetActualReleases.stageDateTime)))>
	
									<a href="###GetActualReleases.releaseNumber#|#UCase(verbose_releaseStatus)#" accesskey="#GetActualReleases.releaseNumber#" tabindex="#GetActualReleases.currentRow#" id="tab#GetActualReleases.currentRow#" class="#_class#">
										<font size="1"><small>Release ###GetActualReleases.releaseNumber#&nbsp;&nbsp;(#GetActualReleases.currentRow#/#_releaseNumber_iMax#)&nbsp;&nbsp;#UCase(verbose_releaseStatus)#<br>#_dateTime#</small></font>
									</a>
								</div>
		
								<cfset _class = "tab">
							</cfloop>
						</cfif>
					</cfif>
				</div>

				<script language="JavaScript1.2" type="text/javascript">
				<!--
					disableVisibleButtons(true, 'maintext');
					register_onload_function('disableVisibleButtons(false, "maintext");');
				-->
				</script>

				#CommonCode.div_loadingContent("Release Data")#

				<cfset _releaseNumber = -1>
				<cfset _releaseNumber_i = 1>
				<cfif (IsDefined("GetReleaseData")) AND (GetReleaseData.recordCount gt 0)>
					<cfif (IsDefined("GetActualReleases")) AND (GetActualReleases.recordCount gt 0)>
						<cfloop query="GetActualReleases" startrow="1" endrow="#GetActualReleases.recordCount#">
							<cfset _releaseStatus = Trim(commonCode.getReleaseStatus( GetActualReleases.devDateTime, GetActualReleases.prodDateTime, GetActualReleases.archDateTime, GetActualReleases.stageDateTime))>
							<div id="content#GetActualReleases.currentRow#" class="content" style="display: none;">
								<table width="95%" cellpadding="-1" cellspacing="-1">
									<tr valign="top">
										<td>
											<table width="100%" cellpadding="-1" cellspacing="-1">
												<tr bgcolor="##c0c0c0">
													<td align="left">
														<cfset _urlParms = "">
														<cfset _releaseLogLink = commonCode.makeLink( _releaseLogReportAction_symbol, _urlParms, _releaseLogReportAction_symbol)>
														<cfif 0>
														#_releaseLogLink#
														</cfif>
														#RepeatString("&nbsp;", 15)#
														<b>Current Release</b>
													</td>
												</tr>
												<cfset _beginItalics = "">
												<cfset _endItalics = "">
												<tr>
													<td width="*">
														<!--- BEGIN: This block of code was left in to keep the keyword search functions from breaking however the information that might have been searched in this area is repeated on the tab titles --->
														<div id="content_areaAboveReports#GetActualReleases.currentRow#">
														</div>
														<!--- END! This block of code was left in to keep the keyword search functions from breaking however the information that might have been searched in this area is repeated on the tab titles --->
														<table width="100%" cellpadding="-1" cellspacing="-1">
															<tr bgcolor="##c0c0c0">
																<td>
																	<table width="20%" cellpadding="-1" cellspacing="-1">
																		<tr>
																			<td align="center" width="10%">
																				<small><b>Release<br>Number</b></small>
																			</td>
																			<td align="center" width="10%">
																				<small><b>Release<br>Date/Time</b></small>
																			</td>
																			<td align="left" width="5%">
																				<small><b><u>Status</u>:<br><font size="1">D=Dev<br>S=Stage<br>P=Prod<br>A=Archive<br></font></b></small>
																			</td>
																		</tr>
																		<tr>
																			<td align="center" valign="top">
																				<br>
																				#_beginItalics#
																				#GetActualReleases.releaseNumber#
																				#_endItalics#
																			</td>
																			<td align="center" valign="top">
																				<table width="100%" cellpadding="-1" cellspacing="-1">
																					<tr>
																						<td>
																							<br>
																							<cfset _dateTime = "">
																							<cfif (Len(GetActualReleases.devDateTime) gt 0)>
																								<cfset _dateTime = CommonCode.formattedDateTimeTZ(GetActualReleases.devDateTime)>
																							<cfelseif (Len(GetActualReleases.prodDateTime) gt 0)>
																								<cfset _dateTime = CommonCode.formattedDateTimeTZ(GetActualReleases.prodDateTime)>
																							<cfelseif (Len(GetActualReleases.archDateTime) gt 0)>
																								<cfset _dateTime = CommonCode.formattedDateTimeTZ(GetActualReleases.archDateTime)>
																							</cfif>
																							#_beginItalics#
																							<NOBR><small><font size="1">#_dateTime#</font></small></NOBR>
																							#_endItalics#
																						</td>
																					</tr>
																					<tr>
																						<td>
																							<br>
																							<cfset _urlParms = "&_relNum=#GetActualReleases.releaseNumber#">
																							<cfset _releaseLogLink = commonCode.makeLink( _releaseLogSubReportAction_symbol, _urlParms, _releaseLogSubReportAction_symbol)>
																							<cfif 0>
																								#_beginItalics#
																								<cfif (function eq _releaseLogSubReportAction_symbol) AND (_releaseNumber eq _relNum)>
																									&nbsp;
																								<cfelse>
																									<NOBR><small><b><font size="1"><b>
																									<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_releaseLogLink#GetActualReleases.currentRow#")>
																									<a href="" #_tooltips_# title="Click this link to View the Release Log for this Release.  The Release Log contains status messages that may be useful when diagnosing problems with the database or when diagnosing problems with the system." style="display: inline;" onClick="PressedReleaseLogViewLink(#GetActualReleases.currentRow#); return false;">#_releaseLogSubReportAction_symbol#</a>
																									<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("close_releaseLogLink#GetActualReleases.currentRow#")>
																									<a href="" #_tooltips_# title="Click this link to Cancel the Release Log Viewer for this Release." style="display: none;" onClick="PressedCancelReleaseLogViewLink(#GetActualReleases.currentRow#); return false;">#_cancelButton_symbol##_releaseLogSubReportAction_symbol#</a>
																									</b></font></b></small></NOBR>
																								</cfif>
																								#_endItalics#
																							</cfif>
																						</td>
																					</tr>
																					<tr>
																						<td>
																							<br>
																							<cfset _urlParms = "&_rid=#GetActualReleases.id#&_relNum=#GetActualReleases.releaseNumber#">
																							<cfset _actionLink = "">
																							<cfif (_releaseStatus eq _development_status_symbol)>
																								<cfset _actionLink = commonCode.makeLink( _productionReleaseAction_symbol, _urlParms, _productionReleaseAction_symbol)>
																							<cfelse>
																								<cfif (function eq _purgeUnwantedArchivesAction_symbol)>
																									<cfif (_releaseStatus eq _archive_status_symbol)>
																										<cfset _actionLink = commonCode.makeLink( _purgeThisArchivesAction_symbol, _urlParms, _purgeThisArchivesAction_symbol)>
																									<cfelseif (_releaseStatus eq _production_status_symbol)>
																										<cfset _actionLink = commonCode.makeLink( "", "", _purgeCancelAction_symbol)>
																									</cfif>
																								<cfelse>
																									<cfif ((_releaseStatus eq _production_status_symbol) OR (_releaseStatus eq _archive_status_symbol)) AND (NOT _areThereDinDb)>
																										<cfset _actionLink = commonCode.makeLink( _productionArchiveDevelopAction_symbol, _urlParms, _productionArchiveDevelopAction_symbol)>
																									</cfif>
																								</cfif>
																							</cfif>
																						</td>
																					</tr>
																				</table>
																			</td>
																			<td align="center" valign="top">
																				<br>
																				#_beginItalics#
																				#_releaseStatus#
																				#_endItalics#
																			</td>
																		</tr>
																	</table>
																</td>
																<td align="center" width="*">
																	<table width="100%" cellpadding="-1" cellspacing="-1">
																		<tr>
																			<td>
																				<!--- +++ --->
																				<table width="100%" cellpadding="-1" cellspacing="-1">
																					<tr>
																						<td height="25px">
																							<cfset _purge_mode_warning = "Notice: Purge actions are final and CANNOT be undone.  Whenever an Release has been Purged from the database all data associated with them is also purged from the database.  Purging unwanted Releases may not necessarily reduce the amount of space SQL Server 2000 has allocated for the database but it can allow SQL Server 2000 to reuse previously allocated and previously used space for additional work.  Choose to Purge unwanted Archived Releases carefully.">
																							<cfif (function neq _purgeUnwantedArchivesAction_symbol) AND (IsDefined("GetReleaseData")) AND (GetActualReleases.recordCount gt 0)>
																								<cfset _purgeLink = commonCode.makeLink( _purgeUnwantedArchivesAction_symbol, _urlParms, _purgeUnwantedArchivesAction_symbol)>
																								<small><font size="1"><b>
																								<cfif (_releaseStatus eq _archive_status_symbol) OR ( (_releaseStatus eq _staging_status_symbol) AND (GetActualReleases.id neq GetLatestStagedRelease.id) )>
																									<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_purgeModeLink#GetActualReleases.currentRow#")>
																									<cfif 0>
																										<a href="" #_tooltips_# title="Enter Selective Archive Purge Mode - this allows the user to choose which Archived Releases the user wishes to Purge.  #_purge_mode_warning#" style="display: inline;" onClick="showAllLinksLikeThis('_purgeArchiveLink'); showAllLinksLikeThis('close_purgeModeLink'); hideAllLinksLikeThis('_purgeModeLink'); return false;">#_purgeUnwantedArchivesAction_symbol#</a>
																									<cfelse>
																										<input type="Button" #_tooltips_# value="#_purgeUnwantedArchivesAction_symbol#" style="display: inline; font-size: 10px;" title="Enter Selective Archive Purge Mode - this allows the user to choose which Archived Releases the user wishes to Purge.  #_purge_mode_warning#" onClick="disableAllButtonsInContentArea(null, makeArrayFromThese('#_purgeThisArchivesAction_symbol#', '#_performReleasePurge_symbol#', '#_genericCancelAction_symbol#'), '#_purgeUnwantedArchivesAction_symbol#'); showAllLinksLikeThis('_purgeArchiveLink'); showAllLinksLikeThis('close_purgeModeLink'); hideAllLinksLikeThis('_purgeModeLink'); return false;" ondblclick="return false;">
																									</cfif>
																									<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("close_purgeModeLink#GetActualReleases.currentRow#")>
																									<cfif 0>
																										<a href="" #_tooltips_# title="Cancel Selective Archive Purge Mode." style="display: none;" onClick="hideAllLinksLikeThis('_purgeArchiveLink'); hideAllLinksLikeThis('close_purgeModeLink'); showAllLinksLikeThis('_purgeModeLink'); return false;">#_cancelButton_symbol##_purgeUnwantedArchivesAction_symbol#</a>
																									<cfelse>
																										<input type="Button" #_tooltips_# value="#_cancelButton_symbol##_purgeUnwantedArchivesAction_symbol#" style="display: none; font-size: 10px;" title="Cancel Selective Archive Purge Mode." onClick="enableAllButtonsInContentArea('#_purgeUnwantedArchivesAction_symbol#'); hideAllLinksLikeThis('_purgeArchiveLink'); hideAllLinksLikeThis('close_purgeModeLink'); showAllLinksLikeThis('_purgeModeLink'); return false;" ondblclick="return false;">
																									</cfif>
																								</cfif>
																								</b></font></small>
																								<cfif (function neq _purgedArchivesReportAction_symbol) AND 0>
																									#RepeatString("&nbsp;", 18)#
																									<cfset _purgedReportsLink = commonCode.makeLink( _purgedArchivesReportAction_symbol, _urlParms, _purgedArchivesReportAction_symbol)>
																									<small><font size="1">#_purgedReportsLink#</font></small>
																								</cfif>
																							<cfelseif (function neq _initialDevelopAction_symbol) AND (IsDefined("GetReleaseData")) AND (GetActualReleases.recordCount eq 0)>
																								#RepeatString("&nbsp;", 65)#
																								<cfset _makeDraftLink = commonCode.makeLink( _initialDevelopAction_symbol, _urlParms, _initialDevelopAction_symbol)>
																								<small><font size="1">#_makeDraftLink#</font></small>
																							</cfif>
																						</td>
																					</tr>
																					<tr>
																						<td height="25px">
																							<NOBR><small><b><font size="1"><b>
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_releaseLogLink#GetActualReleases.currentRow#")>
																							<cfif 0>
																								<a href="" #_tooltips_# title="Click this link to View the Release Log for this Release.  The Release Log contains status messages that may be useful when diagnosing problems with the database or when diagnosing problems with the system." style="display: inline;" onClick="PressedReleaseLogViewLink(#GetActualReleases.currentRow#); return false;">#_releaseLogSubReportAction_symbol#</a>
																							<cfelse>
																								<input type="Button" #_tooltips_# value="#_releaseLogSubReportAction_symbol#" style="display: inline; font-size: 10px;" title="Click this link to View the Release Log for this Release.  The Release Log contains status messages that may be useful when diagnosing problems with the database or when diagnosing problems with the system." onClick="PressedReleaseLogViewLink(#GetActualReleases.currentRow#); return false;" ondblclick="return false;">
																							</cfif>
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("close_releaseLogLink#GetActualReleases.currentRow#")>
																							<cfif 0>
																								<a href="" #_tooltips_# title="Click this link to Cancel the Release Log Viewer for this Release." style="display: none;" onClick="PressedCancelReleaseLogViewLink(#GetActualReleases.currentRow#); return false;">#_cancelButton_symbol##_releaseLogSubReportAction_symbol#</a>
																							<cfelse>
																								<input type="Button" #_tooltips_# value="#_cancelButton_symbol##_releaseLogSubReportAction_symbol#" style="display: none; font-size: 10px;" title="Click this link to Cancel the Release Log Viewer for this Release." onClick="PressedCancelReleaseLogViewLink(#GetActualReleases.currentRow#); return false;" ondblclick="return false;">
																							</cfif>
																							</b></font></b></small></NOBR>
																						</td>
																					</tr>
																					<tr>
																						<td height="25px">
																							<div id="div_user_action_link#GetActualReleases.currentRow#" style="display: inline;">
																								<table width="100%" cellpadding="-1" cellspacing="-1">
																									<tr>
																										<td height="25px">
																											<cfif (_releaseStatus eq _archive_status_symbol) OR ( (_releaseStatus eq _staging_status_symbol) AND (GetActualReleases.id neq GetLatestStagedRelease.id) )>
																												<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_purgeArchiveLink#GetActualReleases.currentRow#")>
																												<cfif 0>
																													#_beginItalics#
																													<b><small><font size="1">
																													<NOBR>
																													<a href="" #_tooltips_# title="Click this link to begin the Selective Release Purge Process for this Archived or Staged Release. You will be asked to Confirm or Cancel this Purge Process. #_purge_mode_warning#" style="display: none;" onClick="coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', false); var obj = getGUIObjectInstanceById('_purgeArchive#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('_purgeArchiveLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } return false;">#_purgeThisArchivesAction_symbol#</a>
																													</NOBR>
																													<br><br><br>
																													</font></small></b>
																													#_endItalics#
																												<cfelse>
																													<input type="Button" #_tooltips_# value="#_purgeThisArchivesAction_symbol#" style="display: none; font-size: 10px;" title="Click this link to begin the Selective Release Purge Process for this Archived or Staged Release. You will be asked to Confirm or Cancel this Purge Process. #_purge_mode_warning#" onClick="coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', false); var obj = getGUIObjectInstanceById('_purgeArchive#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('_purgeArchiveLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } return false;" ondblclick="return false;">
																												</cfif>
																											</cfif>
																										</td>
																									</tr>
																									<tr>
																										<td height="25px">
																											<cfif (_releaseStatus eq _development_status_symbol)>
																												<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_productionReleaseLink#GetActualReleases.currentRow#")>
																												<cfif 0>
																													#_beginItalics#
																													<b><small><font size="1">
																													<NOBR>
																													<a href="" #_tooltips_# title="Click this link to begin the process or making the Draft into a Staging Release. There can be only one Staging Release however after this process completes there will be no Draft Release until a new Draft Release has been made from an Archive Release or the Production Release or a Staging Release. The Staging Release may be made into the Draft Release assuming there is no Draft Release in the database at the time the user wishes to make a Staging Release into the Draft Release.  This means you may UN-DO or reverse the effects of making the Draft Release into the Staging Release.  You will be asked to Confirm or Cancel this operation." style="display: inline;" onClick="coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', false); processClickSearchKeywordLink(true); var obj = getGUIObjectInstanceById('_productionRelease#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('_productionReleaseLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } return false;">#_productionReleaseAction_symbol#</a>
																													</NOBR>
																													<br><br><br>
																													</font></small></b>
																													#_endItalics#
																												<cfelse>
																													<cfset _button_disabled = "">
																													<cfset _button_disabled_reason = "">
																													<cfif isMenuLocked>
																														<cfset _button_disabled = "disabled">
																														<cfset _button_disabled_reason = "(This button has been disabled because the Menu Editor is locked... See the details at the top of thie page.) ">
																													</cfif>
																													<cfset _button_parameters = '#_tooltips_# #_button_disabled# style="display: inline; font-size: 10px;" title="#_button_disabled_reason#Click this link to begin the process or making the Draft into a Staging Release. There can be only one Staging Release however after this process completes there will be no Draft Release until a new Draft Release has been made from an Archive Release or the Production Release or a Staging Release. The Staging Release may be made into the Draft Release assuming there is no Draft Release in the database at the time the user wishes to make a Staging Release into the Draft Release.  This means you may UN-DO or reverse the effects of making the Draft Release into the Staging Release.  You will be asked to Confirm or Cancel this operation." onClick="disableAllButtonsInContentArea(null, makeArrayFromThese(''#_genericCancelAction_symbol#'', ''#_performReleaseAbstractAction_symbol#''), ''#_productionReleaseAction_symbol#''); coordinatReleaseFunctionsFor(''div_user_action_link#GetActualReleases.currentRow#'', false); processClickSearchKeywordLink(true); var obj = getGUIObjectInstanceById(''_productionRelease#GetActualReleases.currentRow#''); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById(''_productionReleaseLink#GetActualReleases.currentRow#''); if (obj != null) { obj.style.display = const_none_style; } return false;" ondblclick="return false;"'>
																													<cfif isMenuLocked>
																														<button #_button_parameters#>#_productionReleaseAction_symbol#</button>
																													<cfelse>
																														<input type="Button" value="#_productionReleaseAction_symbol#" #_button_parameters#>
																													</cfif>
																												</cfif>
																											<cfelseif ((_releaseStatus eq _production_status_symbol) OR (_releaseStatus eq _archive_status_symbol)) AND (NOT _areThereDinDb) AND (NOT _areThereSinDb)>
																												<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_productionArchiveDevelopLink#GetActualReleases.currentRow#")>
																												<cfif 0>
																													#_beginItalics#
																													<b><small><font size="1">
																													<NOBR>
																													<a href="" #_tooltips_# title="Click this link to begin the process of making this Release into the Draft Release.  There can be only ONE Draft Release at a time. You will be asked to Confirm or Cancel this operation." style="display: inline;" onClick="coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', false); processClickSearchKeywordLink(true); var obj = getGUIObjectInstanceById('_productionArchiveDevelop#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('_productionArchiveDevelopLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } return false;">#_productionArchiveDevelopAction_symbol#</a>
																													</NOBR>
																													<br><br><br>
																													</font></small></b>
																													#_endItalics#
																												<cfelse>
																													<input type="Button" #_tooltips_# value="#_productionArchiveDevelopAction_symbol#" style="display: inline; font-size: 10px;" title="Click this link to begin the process of making this Release into the Draft Release.  There can be only ONE Draft Release at a time. You will be asked to Confirm or Cancel this operation." onClick="disableAllButtonsInContentArea(null, makeArrayFromThese('#_genericCancelAction_symbol#', '#_performMakeDraftAbstractAction_symbol#'), '#_productionArchiveDevelopAction_symbol#'); coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', false); processClickSearchKeywordLink(true); var obj = getGUIObjectInstanceById('_productionArchiveDevelop#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('_productionArchiveDevelopLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } return false;" ondblclick="return false;">
																												</cfif>
																											<cfelseif (_releaseStatus eq _staging_status_symbol)>
																												<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_stagingReleaseLink#GetActualReleases.currentRow#")>
																												<cfif 0>
																													#_beginItalics#
																													<b><small><font size="1">
																													<NOBR>
																													<a href="" #_tooltips_# title="Click this link to begin the process or making a Staging Release into the Production Release. There can be only ONE Production Release. You will be asked to Confirm or Cancel this operation." style="display: inline;" onClick="coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', false); processClickSearchKeywordLink(true); var obj = getGUIObjectInstanceById('_stagingRelease#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('_stagingReleaseLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } return false;">#_productionReleaseStageAction_symbol#</a>
																													</NOBR>
																													<br><br><br>
																													</font></small></b>
																													#_endItalics#
																												<cfelse>
																													<input type="Button" #_tooltips_# value="#_productionReleaseStageAction_symbol#" style="display: inline; font-size: 10px;" title="Click this link to begin the process or making a Staging Release into the Production Release. There can be only ONE Production Release. You will be asked to Confirm or Cancel this operation." onClick="disableAllButtonsInContentArea(null, makeArrayFromThese('#_genericCancelAction_symbol#', '#_performProductionReleaseAbstractAction_symbol#'), '#_productionReleaseStageAction_symbol#'); coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', false); processClickSearchKeywordLink(true); var obj = getGUIObjectInstanceById('_stagingRelease#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('_stagingReleaseLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } return false;" ondblclick="return false;">
																												</cfif>
																												<cfif (NOT _areThereDinDb)>
																													<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_revertStagingReleaseLink#GetActualReleases.currentRow#")>
																													<cfif 0>
																														#_beginItalics#
																														<b><small><font size="1">
																														<NOBR>
																														<a href="" #_tooltips_# title="Click this link to begin the process or making a Staging Release back into the Draft Release. There can be only ONE Draft Release. You will be asked to Confirm or Cancel this operation." style="display: inline;" onClick="coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', false); processClickSearchKeywordLink(true); var obj = getGUIObjectInstanceById('_revertStagingRelease#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('_revertStagingReleaseLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } return false;">#_revertStagingReleaseAction_symbol#</a>
																														</NOBR>
																														<br><br><br>
																														</font></small></b>
																														#_endItalics#
																													<cfelse>
																														<input type="Button" #_tooltips_# value="#_revertStagingReleaseAction_symbol#" style="display: inline; font-size: 10px;" title="Click this link to begin the process or making a Staging Release back into the Draft Release. There can be only ONE Draft Release. You will be asked to Confirm or Cancel this operation." onClick="disableAllButtonsInContentArea(null, makeArrayFromThese('#_genericCancelAction_symbol#', '#_performRevertReleaseAbstractAction_symbol#'), '#_revertStagingReleaseAction_symbol#'); coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', false); processClickSearchKeywordLink(true); var obj = getGUIObjectInstanceById('_revertStagingRelease#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } var obj = getGUIObjectInstanceById('_revertStagingReleaseLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } return false;" ondblclick="return false;">
																													</cfif>
																												</cfif>
																											</cfif>
																										</td>
																									</tr>
																								</table>
																							</div>
																						</td>
																					</tr>
																					<tr>
																						<td height="25px">
																							<div id="_productionRelease#GetActualReleases.currentRow#" style="display: none;">
																								<cfset _cancelActions = "enableAllButtonsInContentArea('#_productionReleaseAction_symbol#'); coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', true); var obj = getGUIObjectInstanceById('_productionRelease#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } var obj = getGUIObjectInstanceById('_productionReleaseLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style }">
																								<cfset _paternToReplace = "%_yesFunction%">
																								<cfset _url = "#CGI.SCRIPT_NAME#?_rid=#GetActualReleases.id#&_relNum=#GetActualReleases.releaseNumber#&submit=#_paternToReplace##Request.next_splashscreen_inhibitor#">
																								<cfset _acceptActions = "disableVisibleButtons(true, 'maintext'); disableAllButtonsInContentArea(null, '#_genericCancelAction_symbol#', '_productionRelease#GetActualReleases.currentRow#'); window.location.href = '#_url#'">
																								#CommonCode.releaseConfirmationForm(_productionReleaseAction_symbol, GetActualReleases.releaseNumber, GetActualReleases.id, _acceptActions, _cancelActions, _cancelButton_symbol, _paternToReplace, _productionArchiveDevelopAction_symbol, _initialDevelopAction_symbol, _purgeThisArchivesAction_symbol, _productionReleaseStageAction_symbol, _revertStagingReleaseAction_symbol)#
																							</div>
																							<div id="_productionArchiveDevelop#GetActualReleases.currentRow#" style="display: none;">
																								<cfset _cancelActions = "enableAllButtonsInContentArea('#_productionArchiveDevelopAction_symbol#'); coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', true); var obj = getGUIObjectInstanceById('_productionArchiveDevelop#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } var obj = getGUIObjectInstanceById('_productionArchiveDevelopLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style }">
																								<cfset _paternToReplace = "%_yesFunction%">
																								<cfset _url = "#CGI.SCRIPT_NAME#?_rid=#GetActualReleases.id#&_relNum=#GetActualReleases.releaseNumber#&submit=#_paternToReplace##Request.next_splashscreen_inhibitor#">
																								<cfset _acceptActions = "disableVisibleButtons(true, 'maintext'); disableAllButtonsInContentArea(null, '#_genericCancelAction_symbol#', '_productionArchiveDevelop#GetActualReleases.currentRow#'); window.location.href = '#_url#'">
																								#CommonCode.releaseConfirmationForm(_productionArchiveDevelopAction_symbol, GetActualReleases.releaseNumber, GetActualReleases.id, _acceptActions, _cancelActions, _cancelButton_symbol, _paternToReplace, _productionArchiveDevelopAction_symbol, _initialDevelopAction_symbol, _purgeThisArchivesAction_symbol, _productionReleaseStageAction_symbol, _revertStagingReleaseAction_symbol)#
																							</div>
																							<div id="_purgeArchive#GetActualReleases.currentRow#" style="display: none;">
																								<cfset _cancelActions = "enableAllButtonsInContentArea('_purgeArchive#GetActualReleases.currentRow#'); coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', true); var obj = getGUIObjectInstanceById('_purgeArchive#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } var obj = getGUIObjectInstanceById('_purgeArchiveLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style }">
																								<cfset _paternToReplace = "%_yesFunction%">
																								<cfset _url = "#CGI.SCRIPT_NAME#?_rid=#GetActualReleases.id#&_relNum=#GetActualReleases.releaseNumber#&submit=#_paternToReplace##Request.next_splashscreen_inhibitor#">
																								<cfset _acceptActions = "disableVisibleButtons(true, 'maintext'); disableAllButtonsInContentArea(null, '#_genericCancelAction_symbol#', '_purgeArchive#GetActualReleases.currentRow#'); window.location.href = '#_url#'">
																								#CommonCode.releaseConfirmationForm(_purgeThisArchivesAction_symbol, GetActualReleases.releaseNumber, GetActualReleases.id, _acceptActions, _cancelActions, _cancelButton_symbol, _paternToReplace, _productionArchiveDevelopAction_symbol, _initialDevelopAction_symbol, _purgeThisArchivesAction_symbol, _productionReleaseStageAction_symbol, _revertStagingReleaseAction_symbol)#
																							</div>
																							<div id="_stagingRelease#GetActualReleases.currentRow#" style="display: none;">
																								<cfset _cancelActions = "enableAllButtonsInContentArea('#_productionReleaseStageAction_symbol#'); coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', true); var obj = getGUIObjectInstanceById('_stagingRelease#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } var obj = getGUIObjectInstanceById('_stagingReleaseLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style }">
																								<cfset _paternToReplace = "%_yesFunction%">
																								<cfset _url = "#CGI.SCRIPT_NAME#?_rid=#GetActualReleases.id#&_relNum=#GetActualReleases.releaseNumber#&submit=#_paternToReplace##Request.next_splashscreen_inhibitor#">
																								<cfset _acceptActions = "disableVisibleButtons(true, 'maintext'); disableAllButtonsInContentArea(null, '#_genericCancelAction_symbol#', '_stagingRelease#GetActualReleases.currentRow#'); window.location.href = '#_url#'">
																								#CommonCode.releaseConfirmationForm(_productionReleaseStageAction_symbol, GetActualReleases.releaseNumber, GetActualReleases.id, _acceptActions, _cancelActions, _cancelButton_symbol, _paternToReplace, _productionArchiveDevelopAction_symbol, _initialDevelopAction_symbol, _purgeThisArchivesAction_symbol, _productionReleaseStageAction_symbol, _revertStagingReleaseAction_symbol)#
																							</div>
																							<div id="_revertStagingRelease#GetActualReleases.currentRow#" style="display: none;">
																								<cfset _cancelActions = "enableAllButtonsInContentArea('#_revertStagingReleaseAction_symbol#'); coordinatReleaseFunctionsFor('div_user_action_link#GetActualReleases.currentRow#', true); var obj = getGUIObjectInstanceById('_revertStagingRelease#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } var obj = getGUIObjectInstanceById('_revertStagingReleaseLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style }">
																								<cfset _paternToReplace = "%_yesFunction%">
																								<cfset _url = "#CGI.SCRIPT_NAME#?_rid=#GetActualReleases.id#&_relNum=#GetActualReleases.releaseNumber#&submit=#_paternToReplace##Request.next_splashscreen_inhibitor#">
																								<cfset _acceptActions = "disableVisibleButtons(true, 'maintext'); disableAllButtonsInContentArea(null, '#_genericCancelAction_symbol#', '_revertStagingRelease#GetActualReleases.currentRow#'); window.location.href = '#_url#'">
																								#CommonCode.releaseConfirmationForm(_revertStagingReleaseAction_symbol, GetActualReleases.releaseNumber, GetActualReleases.id, _acceptActions, _cancelActions, _cancelButton_symbol, _paternToReplace, _productionArchiveDevelopAction_symbol, _initialDevelopAction_symbol, _purgeThisArchivesAction_symbol, _productionReleaseStageAction_symbol, _revertStagingReleaseAction_symbol)#
																							</div>
																						</td>
																					</tr>
																				</table>
																			</td>
																			<td>
																				<cfset _actionLink = "">
																				<cfif (_releaseStatus eq _development_status_symbol)>
																					<cfset _actionLink = commonCode.makeLink( _commentsEditorAction_symbol, _urlParms, _commentsEditorAction_symbol)>
																				</cfif>
																				<cfif (Len(_actionLink) gt 0)>
																					&nbsp;
																					<cfif (Len(_actionLink) gt 0)>
																						<cfif 0>
																							#_beginItalics#
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_commentsEditorLink#GetActualReleases.currentRow#")>
																							<a href="" #_tooltips_# title="Click this link to Add Comments to the Draft Release.&nbsp;&nbsp;Comments may only be added to the Draft Release.&nbsp;&nbsp;Comments may NOT be added to any Staging, Archived or Producton Releases.&nbsp;&nbsp;Clicking this link will also clear the last Keyword Search Results." style="display: inline;" onClick="var edObj = getGUIObjectInstanceById('_commentsEditor#GetActualReleases.currentRow#'); if (edObj != null) { edObj.style.display = const_inline_style; var etObj = getGUIObjectInstanceById('_comments#GetActualReleases.currentRow#'); if (etObj != null) { setFocusSafely(etObj); } } var eObj = getGUIObjectInstanceById('_commentsEditorLink#GetActualReleases.currentRow#'); if (eObj != null) { eObj.style.display = const_none_style; processClickSearchKeywordLink(true); } return false;">#_commentsEditorAction_symbol#</a>
																							#_endItalics#
																						<cfelse>
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_commentsEditorLink#GetActualReleases.currentRow#")>
																							<input type="Button" #_tooltips_# value="#_commentsEditorAction_symbol#" style="display: inline; font-size: 10px;" title="Click this link to Add Comments to the Draft Release.&nbsp;&nbsp;Comments may only be added to the Draft Release.&nbsp;&nbsp;Comments may NOT be added to any Staging, Archived or Producton Releases.&nbsp;&nbsp;Clicking this link will also clear the last Keyword Search Results." onClick="disableAllButtonsInContentArea(null, '#_genericCancelAction_symbol#', '#_commentsEditorAction_symbol#'); var edObj = getGUIObjectInstanceById('_commentsEditor#GetActualReleases.currentRow#'); if (edObj != null) { edObj.style.display = const_inline_style; var etObj = getGUIObjectInstanceById('_comments#GetActualReleases.currentRow#'); if (etObj != null) { setFocusSafely(etObj); } } var eObj = getGUIObjectInstanceById('_commentsEditorLink#GetActualReleases.currentRow#'); if (eObj != null) { eObj.style.display = const_none_style; processClickSearchKeywordLink(true); } return false;" ondblclick="return false;">
																						</cfif>
																					</cfif>
																				</cfif>
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
															<cfset _currentRow = GetActualReleases.currentRow>
															
															<cfset _bgColor = Trim(commonCode.reportTableRowColor(_currentRow))>
															<tr bgcolor="#_bgColor#">
																<td align="left" colspan="2" style="border-left: thin solid Silver; border-right: thin solid Silver;">
																	<table width="100%" cellpadding="-1" cellspacing="-1">
																		<tr>
																			<td bgcolor="##c0c0c0">
																				<small><b>Comments</b></small>
																			</td>
																		</tr>
																		<tr>
																			<td>
																				<cfscript>
																					_SQL_ = 'SELECT DISTINCT cid, aDateTime, comments FROM GetReleaseData0 WHERE (releaseNumber = #GetActualReleases.releaseNumber#) AND (comments IS NOT NULL) AND (aDateTime IS NOT NULL) ORDER BY aDateTime';
																					GetReleaseComments = CommonCode.safelyExecQofQ('GetReleaseComments', _SQL_, GetReleaseData0, 'GetReleaseData0');
																				</cfscript>

																				<cfscript>
																					_SQL_ = 'SELECT theComment FROM GetReleaseData0 WHERE (id = #GetActualReleases.id#)';
																					GetTheReleaseComment = CommonCode.safelyExecQofQ('GetTheReleaseComment', _SQL_, GetReleaseData0, 'GetReleaseData0');
																				</cfscript>

																				<cfset _theComments = "">
																				<cfif (IsDefined("GetTheReleaseComment")) AND (GetTheReleaseComment.recordCount gt 0)>
																					<cfif (Len(Trim(GetTheReleaseComment.theComment)) gt 0)>
																						<cfset _theComments = "#AsciiBullet##GetTheReleaseComment.theComment##Cr##Cr#">
																					</cfif>
																				</cfif>
																				<cfif (GetReleaseComments.recordCount gt 0) OR (Len(Trim(_theComments)) gt 0)>
																					<cfloop query="GetReleaseComments" startrow="1" endrow="#GetReleaseComments.recordCount#">
																						<cfset _theComments = "#_theComments##AsciiBullet##CommonCode.formattedDateTimeTZ(GetReleaseComments.aDateTime)#&nbsp;|&nbsp;#GetReleaseComments.comments##Cr##Cr#">
																					</cfloop>
																					<cfset _id_comments = "_comments_#GetActualReleases.currentRow#">
																					<cfset js_id_comments = '"#_id_comments#"'>
																					<input type="hidden" id="copy#_id_comments#" value="#URLEncodedFormat(_theComments)#">
																					<textarea id="#_id_comments#" cols="#_textarea_cols#" rows="#_textarea_rows#" readonly wrap="soft" #_textarea_style_symbol# onmouseup="return false; alert('_getSelection() = ' + _getSelection()); return false;">#_theComments#</textarea>
			
																					<script language="JavaScript1.2" type="text/javascript">
																					<!--
																						register_performFunctionsOnTabChanged(#GetActualReleases.currentRow#, '_noticeFocusForComments(#js_id_comments#, #GetActualReleases.currentRow#);');
																					-->
																					</script>
																				<cfelse>
																					<p align="justify">
																					<font size="1"><small><b>There are no comments for this Release in the database at this time. Comments are specific for the Release and are not carried along with a Draft that is made from an Archive or a Production Release.  Draft Releases are considered to be a clean-slate, so to speak, where Comments are concerned.  Comments do however follow the Release they are associated with for a long as a Release is in the database.</b></small></font>
																					</p>
																				</cfif>
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</td>
												</tr>
												<tr>
													<td>
														<div id="_releaseLogSubReport#GetActualReleases.currentRow#" style="display: none;">
															<table cellpadding="-1" cellspacing="-1" style="font-size: 10px;">
																<tr bgcolor="##c0c0c0">
																	<td align="left">
																		<b>Release Log</b>
																	</td>
																	<td align="center">
																		<div id="_vcrControl_Begin2#GetActualReleases.currentRow#" style="display: none;">
																			<font color="#_enabled_color#">
																			<small>
																			<b>
																			<a href="" title="Scroll to First Release Log Page" onClick="rewindVCRControls2(#GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#], _maxVisibleRows); RefreshVCRControls2(#GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#], _maxVisibleRows); return false;">#_vcrBeginAction_symbol#</a>
																			</b>
																			</small>
																			</font>
																		</div>
																		<div id="disabled_vcrControl_Begin2#GetActualReleases.currentRow#" style="display: none;">
																			<font color="#_disabled_color#">
																			<small>
																			<b>
																			#_vcrBeginAction_symbol#
																			</b>
																			</small>
																			</font>
																		</div>
																		<div id="_vcrControl_Prev2#GetActualReleases.currentRow#" style="display: none;">
																			<font color="#_enabled_color#">
																			<small>
																			<b>
																			<a href="" title="Scroll to Previous Release Log Page" onclick="prevVCRControls2(#GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#], _maxVisibleRows); RefreshVCRControls2(#GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#], _maxVisibleRows); return false;">#_vcrPrevPageAction_symbol#</a>
																			</b>
																			</small>
																			</font>
																		</div>
																		<div id="disabled_vcrControl_Prev2#GetActualReleases.currentRow#" style="display: none;">
																			<font color="#_disabled_color#">
																			<small>
																			<b>
																			#_vcrPrevPageAction_symbol#
																			</b>
																			</small>
																			</font>
																		</div>
																		<div id="_vcrControl_Next2#GetActualReleases.currentRow#" style="display: none;">
																			<font color="#_enabled_color#">
																			<small>
																			<b>
																			<a href="" title="Scroll to Next Release Log Page" onclick="nextVCRControls2(#GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#], _maxVisibleRows); RefreshVCRControls2(#GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#], _maxVisibleRows); return false;">#_vcrNextPageAction_symbol#</a>
																			</b>
																			</small>
																			</font>
																		</div>
																		<div id="disabled_vcrControl_Next2#GetActualReleases.currentRow#" style="display: none;">
																			<font color="#_disabled_color#">
																			<small>
																			<b>
																			#_vcrNextPageAction_symbol#
																			</b>
																			</small>
																			</font>
																		</div>
																		<div id="_vcrControl_End2#GetActualReleases.currentRow#" style="display: none;">
																			<font color="#_enabled_color#">
																			<small>
																			<b>
																			<a href="" title="Scroll to Last Release Log Page" onclick="ffwdVCRControls2(#GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#], _maxVisibleRows); RefreshVCRControls2(#GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#], _maxVisibleRows); return false;">#_vcrEndAction_symbol#</a>
																			</b>
																			</small>
																			</font>
																		</div>
																		<div id="disabled_vcrControl_End2#GetActualReleases.currentRow#" style="display: none;">
																			<font color="#_disabled_color#">
																			<small>
																			<b>
																			#_vcrEndAction_symbol#
																			</b>
																			</small>
																			</font>
																		</div>
																	</td>
																</tr>
																<tr>
																	<td align="left" colspan="2">
																		<table width="800px" cellspacing="-1" cellpadding="-1" style="font-size: 10px;">
																			<tr bgcolor="##c0c0c0">
																				<td align="center" width="10%">
																					<small><b>Row/Total</b></small>
																				</td>
																				<cfif 0>
																					<td width="15%">
																						<small><b>Date<br>Time</b></small>
																					</td>
																				</cfif>
																				<td align="center" width="*">
																					<small><b>Release Log Entries</b></small>
																				</td>
																			</tr>
																			<cfparam name="_beginRow" type="string" default="1">
																			<cfparam name="_maxitems" type="string" default="7">
																			
																			<cfif (nextPage eq _nextPageButton_symbol)>
																				<cfset _beginRow = _beginRow + _maxitems>
																			<cfelseif (prevPage eq _prevPageButton_symbol)>
																				<cfset _beginRow = _beginRow - _maxitems>
																			</cfif>

																			<cfscript>
																				_SQL_ = 'SELECT DISTINCT lid, releaseLog FROM GetReleaseData0 WHERE (releaseNumber = #GetActualReleases.releaseNumber#) AND (releaseLog IS NOT NULL)';
																				GetReleaseLog = CommonCode.safelyExecQofQ('GetReleaseLog', _SQL_, GetReleaseData0, 'GetReleaseData0');
																			</cfscript>
					
																			<cfset _endRow = Min((_beginRow + _maxitems) - 1, GetReleaseLog.recordCount)>
					
																			<cfif (function eq _releaseLogSubReportAction_symbol)>
																				<cfset _beginRow = 1>
																				<cfset _endRow = GetReleaseLog.recordCount>
																			</cfif>
	
																			<cfset _endRow = GetReleaseLog.recordCount>
	
																			<tr>
																				<td width="120%" colspan="2">
																					<table width="100%" cellspacing="-1" cellpadding="-1">
																						<tr>
																							<td width="3%" align="left" valign="top" bgcolor="##c0c0c0">
																								<table width="100%" cellspacing="-1" cellpadding="-1">
																									<tr>
																										<td>
																											<input type="button" id="btnMinus_releaseLogReportDetail.#GetActualReleases.currentRow#.1.1" value="#_genericDropAction_symbol#" title="Decrease Rows in Release Log by One" style="display: none; font-size: 11px;" onclick="disableLogHeightControlMinus(true, #GetActualReleases.currentRow#); performIncreaseReleaseLogHeight(-1, #GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#]); disableLogHeightControlMinus(false, #GetActualReleases.currentRow#); return false;">
																										</td>
																									</tr>
																									<tr>
																										<td>
																											<input type="button" id="btnPlus_releaseLogReportDetail.#GetActualReleases.currentRow#.1.1" value="#_genericAddAction_symbol#" title="Increase Rows in Release Log by One" style="display: none; font-size: 10px;" onclick="disableLogHeightControlPlus(true, #GetActualReleases.currentRow#); performIncreaseReleaseLogHeight(1, #GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#]); disableLogHeightControlPlus(false, #GetActualReleases.currentRow#); return false;">
																										</td>
																									</tr>
																								</table>
																							</td>
																							<td width="100%" align="left" valign="top">
																								<table width="100%" cellspacing="-1" cellpadding="-1">
																									<cfset t_releaseNumber = GetActualReleases.releaseNumber>
																									<cfloop query="GetReleaseLog" startrow="#_beginRow#" endrow="#_endRow#">
																										<cfset _showReleaseRow = "True">
											
																										<cfif _showReleaseRow>
																											<cfset _bgColor = Trim(commonCode.reportTableRowColor(GetReleaseLog.currentRow))>
																											<cfset _display_style = "inline">
																											<cfif (GetReleaseLog.currentRow gt _maxitems)>
																												<cfset _display_style = "none">
																											</cfif>
																											<tr bgcolor="#_bgColor#" id="tr_releaseLogReportDetail.#GetActualReleases.currentRow#.#GetReleaseLog.currentRow#" style="display: #_display_style#;">
																												<td width="#(Len(GetReleaseLog.recordCount) * 2 * 10)#px" align="center" id="td_releaseLogReportDetail.#GetActualReleases.currentRow#.#GetReleaseLog.currentRow#.1" style="display: #_display_style#;">
																													<table width="100%" cellspacing="-1" cellpadding="-1">
																														<tr>
																															<td align="center" valign="top">
																																<font size="1">
																																<small>
																																#GetReleaseLog.currentRow#/#GetReleaseLog.recordCount#
																																</small>
																																</font>
																															</td>
																														</tr>
																														<cfif 0>
																															<tr id="tr_releaseLogReportDetail.#GetActualReleases.currentRow#.#GetReleaseLog.currentRow#.1.1" style="display: none;">
																																<td id="td_releaseLogReportDetail.#GetActualReleases.currentRow#.#GetReleaseLog.currentRow#.1.1" style="display: none;">
																																	<input type="button" id="btnMinus_releaseLogReportDetail.#GetActualReleases.currentRow#.#GetReleaseLog.currentRow#.1.1" value="#_genericDropAction_symbol#" title="Decrease Rows in Release Log by One" style="display: none; font-size: 10px;" onclick="performIncreaseReleaseLogHeight(-1, #GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#]); return false;">
																																	&nbsp;
																																	<input type="button" id="btnPlus_releaseLogReportDetail.#GetActualReleases.currentRow#.#GetReleaseLog.currentRow#.1.1" value="#_genericAddAction_symbol#" title="Increase Rows in Release Log by One" style="display: none; font-size: 10px;" onclick="performIncreaseReleaseLogHeight(1, #GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#]); return false;">
																																</td>
																															</tr>
																														</cfif>
																													</table>
																												</td>
																												<td width="*" align="left" id="td_releaseLogReportDetail.#GetActualReleases.currentRow#.#GetReleaseLog.currentRow#.2" style="display: #_display_style#;">
																													<cfset _aColor = "">
																													<cfif FindNoCase(_warningHeader_symbol, GetReleaseLog.releaseLog) gt 0>
																														<cfset _aColor = 'color="##ff0000"'>
																													</cfif>
																													<small><b><font #_aColor# size="1">#GetReleaseLog.releaseLog#</font></b></small>
																												</td>
																											</tr>
																										</cfif>
																									</cfloop>
																								</table>
																							</td>
																						</tr>
																					</table>
																				</td>
																			</tr>
	
																		</table>
																	</td>
																</tr>
															</table>
															<script language="JavaScript1.2" type="text/javascript">
															<!--
																_array_numRows[#GetActualReleases.currentRow#] = #GetReleaseLog.recordCount#;
	
																read_maxVisibleRows_cookie(#_maxitems#, #GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#]);

																RefreshVCRControls2(#GetActualReleases.currentRow#, _array_numRows[#GetActualReleases.currentRow#], _maxVisibleRows);
															-->
															</script>
														</div>
														<div id="_commentsEditor#GetActualReleases.currentRow#" style="display: none;">
															<table align="right">
																<form action="#CGI.SCRIPT_NAME#" name="save_comments_form#GetActualReleases.currentRow#" method="post" onSubmit="return checkandsubmit(this);">
																	<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																	<tr valign="top">
																		<td>
																			<cfset _comments = "">
																			<cfset _readonly = "">
																			<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_comments#GetActualReleases.currentRow#")>
																			<textarea name="_comments" #_tooltips_# tabindex="1" title="Enter your Comments here then Press one of the buttons below to either Save your comments to the database or Cancel this operation." cols="#_textarea_cols#" rows="#Int(_textarea_rows / 2)#" #_readonly# wrap="virtual" #_textarea_style_symbol#>#_comments#</textarea>
																		</td>
																	</tr>
																	<input name="_rid" type="hidden" value="#GetActualReleases.id#">
																	<input name="_submit_" type="hidden" value="#_commentsEditorAction_symbol#">
																	<tr valign="top">
																		<td>
																			<input id="_submit_save_comments_button" type="submit" title="Click this button to Save Comments to the database." tabindex="2" value="#_commentsEditorAction_symbol#" #_saveButton_style_symbol# onclick="var obj = getGUIObjectInstanceById('_comments#GetActualReleases.currentRow#'); var obj2 = getGUIObjectInstanceById('cancelPopUp#GetActualReleases.currentRow#'); var formObj = getGUIObjectInstanceById('save_comments_form#GetActualReleases.currentRow#'); if ( (obj != null) && (obj2 != null) && (formObj != null) ) { if (obj.value.trim().length > 0) { this.style.color = '##FFFF00'; return suppress_button_double_click2(this, obj2, formObj); } } alert('Cannot save a comment unless there is a comment to save... Please enter a comment and try again.'); if (obj != null) { setFocusSafely(obj); } return false;" ondblclick="return false;">&nbsp;
																			<input type="button" id="cancelPopUp#GetActualReleases.currentRow#" tabindex="3" title="Click this button to Cancel the Comments." value="#_cancelButton_symbol#" #_text_style_symbol# onClick="enableAllButtonsInContentArea('#_commentsEditorAction_symbol#'); var obj = getGUIObjectInstanceById('_commentsEditor#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_none_style; } var obj = getGUIObjectInstanceById('_commentsEditorLink#GetActualReleases.currentRow#'); if (obj != null) { obj.style.display = const_inline_style; } return false;">
																		</td>
																	</tr>
																</form>
															</table>
														</div>
													</td>
												</tr>
												<cfif 0>
													<tr>
														<td align="right">
															<cfif (function eq _releaseLogReportAction_symbol) OR (function eq _releaseLogSubReportAction_symbol)>
																<table cellpadding="-1" cellspacing="-1">
																	<tr bgcolor="##c0c0c0">
																		<td>
																			<b>Release Log</b>
																		</td>
																	</tr>
																	<tr>
																		<td>
																			<table width="800px" cellpadding="-1" cellspacing="-1">
																				<tr bgcolor="##c0c0c0">
																					<td align="center" width="10%">
																						<small><b>Release<br>Number</b></small>
																					</td>
																					<cfif 0>
																						<td width="15%">
																							<small><b>Date<br>Time</b></small>
																						</td>
																					</cfif>
																					<td align="center" width="*">
																						<small><b>Comments</b></small>
																					</td>
																				</tr>
																				<cfparam name="_beginRow" type="string" default="1">
																				<cfparam name="_maxitems" type="string" default="10">
																				
																				<cfif (nextPage eq _nextPageButton_symbol)>
																					<cfset _beginRow = _beginRow + _maxitems>
																				<cfelseif (prevPage eq _prevPageButton_symbol)>
																					<cfset _beginRow = _beginRow - _maxitems>
																				</cfif>

																				<cfscript>
																					_SQL_ = 'SELECT DISTINCT lid, releaseLog FROM GetReleaseData0 WHERE (releaseNumber = #_relNum#) AND (releaseLog IS NOT NULL)';
																					GetReleaseLog = CommonCode.safelyExecQofQ('GetReleaseLog', _SQL_, GetReleaseData0, 'GetReleaseData0');
																				</cfscript>
						
																				<cfset _endRow = Min((_beginRow + _maxitems) - 1, GetReleaseLog.recordCount)>
						
																				<cfif (function eq _releaseLogSubReportAction_symbol)>
																					<cfset _beginRow = 1>
																					<cfset _endRow = GetReleaseLog.recordCount>
																				</cfif>
						
																				<cfloop query="GetReleaseLog" startrow="#_beginRow#" endrow="#_endRow#">
																					<cfset _showReleaseRow = "True">
						
																					<cfif _showReleaseRow>
																						<cfset _bgColor = Trim(commonCode.reportTableRowColor(GetReleaseLog.currentRow))>
																						<tr bgcolor="#_bgColor#">
																							<td align="center">
																								#_relNum#
																							</td>
																							<cfif 0>
																								<td>
																									<cfset _thisDate = DateFormat(GetReleaseLog.dateTime, "mm/dd/yyyy")>
																									<cfset _timeZone = UCASE(Right(TimeFormat(GetReleaseLog.dateTime, "long"), 3))>
																									<cfset _thisTime = TimeFormat(GetReleaseLog.dateTime, "hh:mm tt")>
																									<small><b><font size="1">#_thisDate#&nbsp;#_thisTime#&nbsp;#_timeZone#</font></b></small>
																								</td>
																							</cfif>
																							<td align="left">
																								<cfset _aColor = "">
																								<cfif FindNoCase(_warningHeader_symbol, GetReleaseLog.releaseLog) gt 0>
																									<cfset _aColor = 'color="##ff0000"'>
																								</cfif>
																								<small><b><font #_aColor# size="1">#GetReleaseLog.releaseLog#</font></b></small>
																							</td>
																						</tr>
																					</cfif>
																				</cfloop>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td>
																			<form action="#CGI.SCRIPT_NAME#" method="post">
																				<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																				<tr valign="top">
																					<td>
																						<input type="hidden" name="_beginRow" value="#_beginRow#">
																						<input type="hidden" name="_maxitems" value="#_maxitems#">
						
																						<input type="hidden" name="function" value="#function#">
																						
																						<cfif IsDefined("_relNum")>
																							<input type="hidden" name="_relNum" value="#_relNum#">
																						</cfif>
						
																						<cfif (_beginRow gte _maxitems)>
																							<input name="prevPage" type="submit" value="#_prevPageButton_symbol#">
																						</cfif>
																						<cfif (_endRow lt GetReleaseLog.recordCount) AND (_beginRow lt _releaseCount)>
																							<input name="nextPage" type="submit" value="#_nextPageButton_symbol#">
																						</cfif>
																						<input name="cancelPopUp" type="submit" value="#_cancelButton_symbol#">
																					</td>
																				</tr>
																			</form>
																		</td>
																	</tr>
																</table>
															</cfif>
														</td>
													</tr>
												</cfif>
											</table>
										</td>
									</tr>
								</table>

								<cfif 0>
									<div class="padder"></div>
								</cfif>
							</div>
						</cfloop>
					</cfif>
				</cfif>
			</div>
			<!--- END! Tabbed Interface goes here... --->

			#RepeatString("<BR>", 37)#
			
			<!--- BEGIN: The block of code performs an automatic search for the 'Draft' Release whenever a new Draft has been made in the database. --->			
			<cfif (ListLen(submit, "|") eq 2) AND (GetToken(submit, 1, "|") eq _productionArchiveDevelopAction_symbol)>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					if (stack_FocusOnTabWithAnchorText.length == 0) {
						stack_FocusOnTabWithAnchorText.push('Draft');
					}
				-->
				</script>
			</cfif>
			<!--- END! The block of code performs an automatic search for the 'Draft' Release whenever a new Draft has been made in the database. --->			
		</div>
	</div>
</cfoutput>
