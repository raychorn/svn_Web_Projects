<cfset _small_style_symbol = 'style="font-size: 10px;"'>
<cfset _text_style_symbol = 'style="font-size: 10px;"'>
<cfset _links_style_symbol = 'style="font-size: 9px;"'>
<cfset _submit_button_style_symbol = 'style="font-size: 12px;"'>

<cfoutput>
	<div id="header">
		<div id="welcome">
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr>
					<td>
						<h2><NOBR>#Request._site_name# - Security</NOBR></h2>
					</td>
					<td>
						<cfif (IsDefined("GetSecurityDataUsersSubsystems")) AND (GetSecurityDataUsersSubsystems.recordCount gt 0) AND (IsDefined("GetSecurityDataUsersSubsystems.rid")) AND (Len(GetSecurityDataUsersSubsystems.rid) gt 0) AND (Len(GetSecurityDataUsersSubsystems.lockedSBCUID) gt 0)>
							<cfset _timeString = CommonCode.formattedDateTimeTZ(Now())>
							<cfset locked_timeString = CommonCode.formattedDateTimeTZ(ParseDateTime(GetSecurityDataUsersSubsystems.locked))>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td>
										<font size="1">
										<small>
										<cfset emailLink_locked_menuEditor = CommonCode.makeMenuInUseContactUserLink(GetSecurityDataUsersSubsystems.lockedSBCUID, "blue")>
										<cfif (UCASE(GetSecurityDataUsersSubsystems.lockedSBCUID) EQ UCASE(_AUTH_USER))>
											<cfset emailLink_locked_menuEditor = GetSecurityDataUsersSubsystems.lockedSBCUID>
										</cfif>
										<b>#_timeString# :: Menu Editor is currently <u>in-use</u> by SBCUID <font color="##0000ff">#emailLink_locked_menuEditor#</font> as of<br><font color="##0000ff">#locked_timeString#</font>.</b>
										</small>
										</font>
									</td>
								</tr>
								<cfif (UCASE(GetSecurityDataUsersSubsystems.lockedSBCUID) NEQ UCASE(_AUTH_USER))>
									<tr>
										<td>
											<cfset _aURL = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)#&submit=#URLEncodedFormat(_forceMenuUnlockAction_symbol)##Request.next_splashscreen_inhibitor#">
											<table width="100%" cellpadding="2" cellspacing="2">
												<tr>
													<td height="40px" bgcolor="red" valign="middle" align="center">
														<input type="button" id="menu_force_unlock_button" value="Unlock Menu Editor" style="font-size: 10px; color: ##DC143C;" onClick="var obj = getGUIObjectInstanceById('menu_force_unlock_button'); if (obj != null) { obj.disable } window.location.href = '#_aURL#'; return false;">
													</td>
													<td align="justify" valign="middle">
														<font size="1">
														<small>
														<i><b><font color="##ff0000">Warning: Forcibly unlocking the Menu Editor <u>"may"</u> result in lost Menu changes.  Double check with the user to be sure all changes have been saved to the database <u>BEFORE</u> taking this action.</font></b></i>
														</small>
														</font>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</cfif>
							</table>
						<cfelse>
							&nbsp;
						</cfif>
					</td>
				</tr>
			</table>
		</div>

		<div id="maintext">
			<cfif (Len(function) eq 0) AND (Len(submit) eq 0)>
				<cfif IsDefined("GetSecurityDataUsersSubsystems") AND (GetSecurityDataUsersSubsystems.recordCount gt 0)>
					<!--- BEGIN: This Query pulls only those subsystemname that are valid from the shot-gun query --->
					<CFQUERY dbtype="query" name="GetDisplayableUserList">
						SELECT DISTINCT uid, userid, rid
						FROM GetSecurityUserList
						WHERE (uid IS NOT NULL) AND (userid IS NOT NULL)
						ORDER BY userid, uid, rid
					</cfquery>
					<!--- END! This Query pulls only those subsystemname that are valid from the shot-gun query --->

					<cfset _displaying_uid = -1>
					<cfset _displayableNum = 0>
					<cfloop query="GetDisplayableUserList" startrow="1" endrow="#GetDisplayableUserList.recordCount#">
						<cfif _displaying_uid neq GetDisplayableUserList.uid>
							<cfset _displaying_uid = GetDisplayableUserList.uid>
	
							<cfif (Len(GetDisplayableUserList.userid) gt 0)>
								<cfset _displayableNum = IncrementValue(_displayableNum)>
							</cfif>
						</cfif>
					</cfloop>

					<table width="50px" cellpadding="-1" cellspacing="-1" align="left">
						<tr>
							<td width="10px" valign="top">
								<table width="100%" cellspacing="-1" cellpadding="-1">
									<tr>
										<td>
											<input type="button" id="btnMinus_securityUserIndex" value="#_editorMenuDropAction_symbol#" title="Decrease Rows in User Index by One" style="display: none; font-size: 11px;" onclick="disableUserIndexHeightControlMinus(true); performIncreaseUserIndexHeight(-1); disableUserIndexHeightControlMinus(false); return false;">
										</td>
									</tr>
									<tr>
										<td>
											<input type="button" id="btnPlus_securityUserIndex" value="#_editorMenuAddAction_symbol#" title="Increase Rows in User Index by One" style="display: none; font-size: 10px;" onclick="disableUserIndexHeightControlPlus(true); performIncreaseUserIndexHeight(1); disableUserIndexHeightControlPlus(false); return false;">
										</td>
									</tr>
								</table>
							</td>
							<td width="50px" valign="top">
								<table width="50px" cellpadding="-1" cellspacing="-1" align="left">
									<tr>
										<td height="21px" valign="top" align="center">
											<div style="line-height: 8px;">
											<font size="1"><small><b>User<br>Index</b></small></font>
											</div>
										</td>
									</tr>
									<tr>
										<td valign="top" align="center">
											<table cellpadding="-1" cellspacing="-1" align="center" style="line-height: 14px; font-size: 9px;">
												<cfset _displaying_uid = -1>
												<cfset _displayableNum_i = 1>
												<cfloop query="GetDisplayableUserList" startrow="1" endrow="#GetDisplayableUserList.recordCount#">
													<cfif _displaying_uid neq GetDisplayableUserList.uid>
														<cfset _displaying_uid = GetDisplayableUserList.uid>
							
														<cfset _userid = Trim(GetDisplayableUserList.userid)>
														<cfif (Len(_userid) gt 0)>
															<cfset _user_index_style_on = "none">
															<cfset _user_index_style_off = "inline">
															<cfif (_displayableNum_i lte _ss_maxDisplayableUserIndex)>
																<cfset _user_index_style_on = "inline">
																<cfset _user_index_style_off = "none">
															</cfif>
															<tr id="_user_index_tr#_displayableNum_i#" valign="top">
																<td id="_user_index_td#_displayableNum_i#" valign="top">
																	<div id="div_user_index_on#_displayableNum_i#" style="display: #_user_index_style_on#;">
																		<font size="1">
																		<small>
																		<b>
																		<a href="" id="_user_index_link#_displayableNum_i#" name="_user_index_link#_displayableNum_i#" title="Click this link to perform a search for the SBCUID." onClick="PerformTabSearch('#_userid#'); return false;">#_userid#</a>
																		<br>
																		</b>
																		</small>
																		</font>
																	</div>
																	<div id="div_user_index_off#_displayableNum_i#" style="display: #_user_index_style_off#;">
																		&nbsp;
																	</div>
																</td>
															</tr>
															<cfset _displayableNum_i = IncrementValue(_displayableNum_i)>
														</cfif>
													</cfif>
												</cfloop>
											</table>
											<script language="JavaScript1.2" type="text/javascript">
											<!--
												user_index_displayableNum = #_displayableNum#;
												_ss_maxDisplayableUserIndex = #_ss_maxDisplayableUserIndex#;
												
												user_index_displayablePref = read_UserIndexHeight_cookie(Math.min(user_index_displayableNum, 30));  // 30 is the most that can fit on 1024x768
												refreshUserIndexHeight();
												refreshUserIndexHeightControls();
											-->
											</script>
										</td>
									</tr>
								</table>
							</td>
							<td width="*" valign="top">
								<table width="990px" cellpadding="-1" cellspacing="-1">
									<cfset total_table_cells_width = 0>
									<cfset _this_table_cells_width = 35>
									<tr bgcolor="##c0c0c0">
										<cfset total_table_cells_width = total_table_cells_width + _this_table_cells_width>
										<td width="#_this_table_cells_width#px" align="center" valign="top">
											<div id="_vcrControl_Begin" style="display: none;">
												<font color="#_enabled_color#" size="1">
												<small>
												<b>
												<a href="" name="_vcrControl_Begin" title="Scroll to First Tab" onClick="_allow_RefreshVCRControls = false; _FocusOnThisTab(1); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrBeginAction_symbol#</a>
												</b>
												</small>
												</font>
											</div>
											<div id="disabled_vcrControl_Begin" style="display: none;">
												<font color="#_disabled_color#" size="1">
												<small>
												<b>
												#_vcrBeginAction_symbol#
												</b>
												</small>
												</font>
											</div>
										</td>
										<cfset total_table_cells_width = total_table_cells_width + _this_table_cells_width>
										<td width="#_this_table_cells_width#px" align="center" valign="top">
											<div id="_vcrControl_PrevPage" style="display: none;">
												<font color="#_enabled_color#" size="1">
												<small>
												<b>
												<a href="" title="Scroll Left Two Pages of Tabs" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(_vis_tabs_begin - _num_vis_tabs_max); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrPrevPageAction_symbol#</a>
												</b>
												</small>
												</font>
											</div>
											<div id="disabled_vcrControl_PrevPage" style="display: none;">
												<font color="#_disabled_color#" size="1">
												<small>
												<b>
												#_vcrPrevPageAction_symbol#
												</b>
												</small>
												</font>
											</div>
										</td>
										<cfset total_table_cells_width = total_table_cells_width + _this_table_cells_width>
										<td width="#_this_table_cells_width#px" align="center" valign="top">
											<div id="_vcrControl_Prev" style="display: none;">
												<font color="#_enabled_color#" size="1">
												<small>
												<b>
												<a href="" title="Scroll Left One Page of Tabs" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(_vis_tabs_begin - 1); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrPrevAction_symbol#</a>
												</b>
												</small>
												</font>
											</div>
											<div id="disabled_vcrControl_Prev" style="display: none;">
												<font color="#_disabled_color#" size="1">
												<small>
												<b>
												#_vcrPrevAction_symbol#
												</b>
												</small>
												</font>
											</div>
										</td>
										<cfset total_table_cells_width = total_table_cells_width + _this_table_cells_width>
										<td width="#_this_table_cells_width#px" align="center" valign="top">
											<div id="_vcrControl_Next" style="display: none;">
												<font color="#_enabled_color#" size="1">
												<small>
												<b>
												<a href="" title="Scroll Right One Page of Tabs" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(_vis_tabs_end + 1); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrNextAction_symbol#</a>
												</b>
												</small>
												</font>
											</div>
											<div id="disabled_vcrControl_Next" style="display: none;">
												<font color="#_disabled_color#" size="1">
												<small>
												<b>
												#_vcrNextAction_symbol#
												</b>
												</small>
												</font>
											</div>
										</td>
										<cfset total_table_cells_width = total_table_cells_width + _this_table_cells_width>
										<td width="#_this_table_cells_width#px" align="center" valign="top">
											<div id="_vcrControl_NextPage" style="display: none;">
												<font color="#_enabled_color#" size="1">
												<small>
												<b>
												<a href="" title="Scroll Right Two Pages of Tabs" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(_vis_tabs_end + _num_vis_tabs_max); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrNextPageAction_symbol#</a>
												</b>
												</small>
												</font>
											</div>
											<div id="disabled_vcrControl_NextPage" style="display: none;">
												<font color="#_disabled_color#" size="1">
												<small>
												<b>
												#_vcrNextPageAction_symbol#
												</b>
												</small>
												</font>
											</div>
										</td>
										<cfset total_table_cells_width = total_table_cells_width + _this_table_cells_width>
										<td width="#_this_table_cells_width#px" align="center" valign="top">
											<div id="_vcrControl_End" style="display: none;">
												<font color="#_enabled_color#" size="1">
												<small>
												<b>
												<a href="" title="Scroll to Last Tab" onclick="_allow_RefreshVCRControls = false; _FocusOnThisTab(TabSystem.list['TabSystem1'].tabs.length); RefreshVCRControls(); _allow_RefreshVCRControls = true; return false;">#_vcrEndAction_symbol#</a>
												</b>
												</small>
												</font>
											</div>
											<div id="disabled_vcrControl_End" style="display: none;">
												<font color="#_disabled_color#" size="1">
												<small>
												<b>
												#_vcrEndAction_symbol#
												</b>
												</small>
												</font>
											</div>
										</td>
										<td width="#(990 - total_table_cells_width)#px" align="center" valign="top">
											<table width="80%" align="center" cellpadding="-1" cellspacing="-1">
												<tr valign="top">
													<td id="td_addNewUser" width="50%" align="center" valign="top">
														<cfif 0>
															<b>
															<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_addNewUser")>
															<a href="" #_tooltips_# title="Add a new user to the Security database - you will be asked to enter an SBCUID for each user you wish to add to the database.  See your LDAP Administrator to have each SBCUID granted access to the appropriate folders as required to allow each user to access each functional area." onclick="clicked_addNewUser(); return false;"><font size="1"><small>#_addUserAction_symbol#</small></font></a>
															</b>
														<cfelse>
															<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_addNewUser")>
															<input type="button" #_tooltips_# title="Add a new user to the Security database - you will be asked to enter an SBCUID for each user you wish to add to the database.  See your LDAP Administrator to have each SBCUID granted access to the appropriate folders as required to allow each user to access each functional area." value="#_addUserAction_symbol#" #_textarea_style_symbol# onclick="clicked_addNewUser(); return false;" ondblclick="return false;">
														</cfif>
														<div id="addNewUser" style="display: none;">
															<cfset _formAction = "if (isSBCUIDValid(getGUIObjectInstanceById('_userid').value)) { hideSecuritySettingsForm(); disableAllButtonsInContentArea(null); this.submitButton.disabled = true; this.cancelPopUp.disabled = true; return true } else { alert('You have entered an invalid SBCUID. Please try again.'); return false }">
															<form action="#CGI.SCRIPT_NAME#" method="post" id="form_addNewUser" onsubmit="#_formAction#">
																<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																<table cellpadding="-1" cellspacing="-1">
																	<tr>
																		<td>
																			<cfif 0> <!--- This function was postponed due to the need to expend far too much time unless SBC has a ColdFusion module that can facilitate this SBCUID lookup using a Name rather than an SBCUID to derive a name, etc. --->
																				<A HREF="##" title="Click this link to open the SBCUID Web Phone dialog; this dialog allows you to find the SBCUID you wish to use when adding SBCUID's to this database. There is no need to retype nor copy/paste the SBCUID you have found; simply click the button to use it and the system will take care of the rest for you." onClick="var obj = getGUIObjectInstanceById('div_sbcuid_picker'); if (obj != null) { obj.style.display = const_inline_style; } _sbcuidPicker.show('SBCUIDPicker'); return false;" NAME="pickSBCUID" ID="pickSBCUID"><small #_small_style_symbol#><b>SBCUID:</b></small></A>&nbsp;
																			<cfelse>
																				<small #_small_style_symbol#><b>SBCUID:</b></small>&nbsp;
																			</cfif>
																			<input #_text_style_symbol# type="text" name="_userid" value="#_userid#" title="Enter the SBCUID in this entry field." size="7" maxlength="6" onkeypress="if (isSBCUID_KeycodeValid(event.keyCode)) { return true } else {return false }">
																			&nbsp;
																		</td>
																		<td>
																			<input name="submitButton" id="addNewUser_submitButton" type="submit" value="#_addUserAction_symbol#" title="Click this button to add the SBCUID to the database." #_textarea_style_symbol#>&nbsp;
																		</td>
																		<td>
																			<input type="button" name="cancelPopUp" value="#_cancelButton_symbol#" title="Click this button to cancel this operation." #_textarea_style_symbol# onClick="clicked_cancelAddNewUser(); return false;">
																		</td>
																	</tr>
																	<tr>
																		<td>
																			<cfif Len(_id) gt 0>
																				<input type="hidden" name="_id" value="#_id#">
																			</cfif>
																			<input type="hidden" name="submit" value="#_addUserAction_symbol#">
																		</td>
																	</tr>
																</table>
															</form>
														</div>
													</td>
													<td id="td_searchForUser" width="50%" height="30px" align="center" valign="top">
														<cfif 0>
															<b>
															<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_searchForUser")>
															<a href="" #_tooltips_# title="Search the tabs for a keyword.  Keywords may be any information that appears on any of the tabs found below.  You will see a pop-up message that tells you whether the search was successful or not.  The tab that contains the keyword you are searching for will be in-focus at the completion of the search function." onclick="initKeywordSearch(); clicked_searchForUser(); return false;"><font size="1"><small>#_lookupUserAction_prompt#</small></font></a>
															</b>
														<cfelse>
															<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_searchForUser")>
															<input type="button" #_tooltips_# title="Search the tabs for a keyword.  Keywords may be any information that appears on any of the tabs found below.  You will see a pop-up message that tells you whether the search was successful or not.  The tab that contains the keyword you are searching for will be in-focus at the completion of the search function." value="#_lookupUserAction_prompt#" #_textarea_style_symbol# onclick="initKeywordSearch(); clicked_searchForUser(); return false;" ondblclick="return false;">
														</cfif>
														<div id="prev_findKeywordRelease" style="display: none;">
															<NOBR>
															<font size="1">
															<small>
															<b>
															<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_lookupPrevAction_")>
															<a href="" #_tooltips_# title="Previous Keyword found from previous search criteria." onclick="prevKeywordSearch(); return false;">#_lookupPrevAction_symbol#</a>
															</b>
															</small>
															</font>
															</NOBR>
														</div>
														<div id="status_findKeywordRelease" style="display: none;">
														</div>
														<div id="next_findKeywordRelease" style="display: none;">
															<NOBR>
															<font size="1">
															<small>
															<b>
															<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_lookupNextAction_")>
															<a href="" #_tooltips_# title="Next Keyword found from previous search criteria." onclick="nextKeywordSearch(); return false;">#_lookupNextAction_symbol#</a>
															</b>
															</small>
															</font>
															</NOBR>
														</div>
														<div id="searchForUser" style="display: none;">
															<cfset _formAction = "if (this.form._userid.value.trim().length > 0) { clicked_cancelSearchForUser(); PerformTabSearch(this.form._userid.value); } else { alert('Cannot search for a blank user.'); } return false;">
															<form action="#CGI.SCRIPT_NAME##Request.first_splashscreen_inhibitor#" method="post" id="form_searchForUser" onsubmit="#_formAction#">
																<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																<table cellpadding="-1" cellspacing="-1">
																	<tr>
																		<td>
																			<NOBR><small #_small_style_symbol#><b>Keyword Search:</b></small></NOBR>&nbsp;
																			<input #_text_style_symbol# tabindex="1" type="text" name="_userid" value="#_userid#" size="30" maxlength="50" onkeydown="if (event.keyCode == 13) { #_formAction# }">
																			&nbsp;
																		</td>
																		<td>
																			<input name="submitButton" tabindex="2" title="Click this button to begin the search function." type="button" value="#_lookupUserAction_prompt#" #_text_style_symbol# onClick="#_formAction#">&nbsp;
																		</td>
																		<td>
																			<input type="button" tabindex="3" name="cancelPopUp" title="Click this button to cancel this operation." value="#_cancelButton_symbol#" #_text_style_symbol# onClick="clicked_cancelSearchForUser(); return false;">
																		</td>
																	</tr>
																	<tr>
																		<td>
																			<cfif Len(_id) gt 0>
																				<input type="hidden" name="_id" value="#_id#">
																			</cfif>
																			<input type="hidden" name="submit" value="#_lookupUserAction_symbol#">
																		</td>
																	</tr>
																</table>
															</form>
														</div>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>

								<div id="div_sbcuid_picker" style="display: none;">
									<br><br><br><br><br><br>
									<A HREF="" NAME="SBCUIDPicker" ID="SBCUIDPicker"></A>
									<script language="JavaScript" type="text/javascript">
									<!--
										var _sbcuidPicker = new SBCUIDPicker("sbcuidPickerDiv", false); // , "lookupSBCUID.cfm"
//										var _sbcuidPicker = new SBCUIDPicker("", true);
										if (_sbcuidPicker != null) {
											_sbcuidPicker.writeDiv();
										} else {
//											alert('SBCUIDPicker() failed !');
										}
									-->
									</script>
								</div>

								<div id="_securitySettings" style="display: none;">
									<cfset _securitySettings_width = 800>
									<table width="#_securitySettings_width#px" cellpadding="-1" cellspacing="-1">
										<tr>
											<td width="100%">
												<table cellpadding="-1" cellspacing="-1">
													<tr>
														<td height="135px">
															&nbsp;
														</td>
													</tr>
													<tr>
														<td>
															<table cellpadding="-1" cellspacing="-1">
																<tr>
																	<td valign="top" width="50%">
																		<table cellpadding="-1" cellspacing="-1">
																			<cfset _aList = CommonCode.processRecordList(_SubSystemList_)>
																			<cfset _aList_len = ListLen(_aList, ",")>
																			<tr bgcolor="##c0c0c0">
																				<td height="40px" colspan="2" valign="top">
																					<cfif 0>
																						<a href="" id="_checkAllSubsystems" title="Click this link to check all Subsystems." style="display: inline;" onclick="return processCheckAllSubSystems(#_aList_len#);"><font size="1"><small><b>(Check All)</b></small></font></a>
																						<a href="" id="_uncheckAllSubsystems" title="Click this link to uncheck all Subsystems." style="display: none;" onclick="return processUnCheckAllSubSystems(#_aList_len#);"><font size="1"><small><b>(Un-Check All)</b></small></font></a>
																					<cfelse>
																						<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_checkAllSubsystems")>
																						<input type="button" #_tooltips_# title="Click this link to check all Subsystems." style="display: inline;" onclick="return processCheckAllSubSystems(#_aList_len#);" value="(Check All)" #_text_style_symbol#>
																						<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_uncheckAllSubsystems")>
																						<input type="button" #_tooltips_# title="Click this link to uncheck all Subsystems." style="display: none;" onclick="return processUnCheckAllSubSystems(#_aList_len#);" value="(Un-Check All)" #_text_style_symbol#>
																					</cfif>
																					<br>
																				</td>
																			</tr>
																			<tr bgcolor="##c0c0c0">
																				<td>
																					<font size="1"><small><b>&nbsp;?</b></small></font>
																				</td>
																				<td>
																					<font size="1"><small><b>SubSystem</b></small></font>
																				</td>
																			</tr>
																			<cfset _currentSubSystemRow = 1>
																			<form action="#CGI.SCRIPT_NAME#" method="post">
																				<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																				<cfloop index="_anItem" list="#_aList#" delimiters=",">
																					<cfset _bgColor = Trim(commonCode.reportTableRowColor(_currentSubSystemRow))>
																					<cfset _name = GetToken(_anItem, 1, "=")>
							
																					<tr bgcolor="#_bgColor#">
																						<td>
																							<cfset _subsystem_security_advisory = "<br><br><font color=red>Access revoked by unchecking this feature may not necessarily keep a user from saving their last change made using this feature.  Revoked access will however keep a user from being able to gain access to the GUI for this feature.</font>">
																							<cfset _checkbox_subsystem_title = "Check this item to allow or disallow the selected user to access this subsystem.  See your LDAP Administrator to have the selected SBCUID granted access for the appropriate folder.">
																							<cfif (UCASE(_name) eq UCASE(_Admin_Add_New_Pages_symbol))>
																								<cfset _checkbox_subsystem_title = "Check this item to allow or disallow the selected user to access the Menu Editor. (Content Pages may only be added by those who are able to edit the site menu. While an internal site content page could be linked to almost any other part of the site such as the Menu Bar or the QuickLinks area it would be more typical for this type of link to be part of the site menu.)#_subsystem_security_advisory#">
																							<cfelseif (UCASE(_name) eq UCASE(_Admin_Edit_Marquee_symbol))>
																								<cfset _checkbox_subsystem_title = "Check this item to allow or disallow the selected user to access the Marquee Editor. (Marquee Announcements may only be added/edited/removed by those who are able to edit the Marquee.)#_subsystem_security_advisory#">
																							<cfelseif (UCASE(_name) eq UCASE(_Admin_Upload_Images_symbol))>
																								<cfset _checkbox_subsystem_title = "#_checkbox_subsystem_title##_subsystem_security_advisory#">
																							</cfif>
																							<div id="enabled_cb_subsystemId#_currentSubSystemRow#" style="display: inline;">
																								<input type="checkbox" id="_subsystemId#_currentSubSystemRow#" name="_subsystemId" value="#_name#" title="#_checkbox_subsystem_title#" onclick="processSubsystemId_click(#_currentSubSystemRow#); return true;" ondblclick="return false;">
																							</div>
	
																							<div id="disabled_cb_subsystemId#_currentSubSystemRow#" style="display: none;">
																								<input type="checkbox" id="disabled_subsystemId#_currentSubSystemRow#" disabled>
																							</div>
																						</td>
																						<td>
																							<div id="enabled_p_subsystemId#_currentSubSystemRow#" style="display: inline;">
																								#CommonCode.osStyleRadioButtonCaption( "True", _checkbox_subsystem_title, "_subsystemId#_currentSubSystemRow#", '<NOBR><font size="1"><small>#_name#</small></font></NOBR>')#
																							</div>
	
																							<div id="disabled_p_subsystemId#_currentSubSystemRow#" style="display: none;">
																								<NOBR><font size="1"><small>#_name#</small></font></NOBR>
																							</div>
																						</td>
																					</tr>
																					<cfset _currentSubSystemRow = IncrementValue(_currentSubSystemRow)>
																				</cfloop>
																				<input type="hidden" name="submit" value="#_updateSubSystemAccessAction_symbol#">
																				<input type="hidden" id="_subsystem_uid" name="_id" value="-1">
																			</form>
																		</table>
																	</td>
																	<td valign="top" width="*">
																		<cfset _aList = CommonCode.processRecordList(_ContentPageList)>
	
																		<cfset _aListLen = ListLen(_aList, ",")>
																		<cfset _extraColumn = 0>
																		<cfif (_aListLen MOD _ss_maxRowsPerColumn) gt 0>
																			<cfset _extraColumn = 1>
																		</cfif>
																		<cfset _numColumns = Int(_aListLen / _ss_maxRowsPerColumn) + _extraColumn>
																		
																		<cfset _tableWidth = 800>
																		<table width="#_tableWidth#px" cellpadding="-1" cellspacing="-1">
																			<tr>
																				<td>
																					<table cellpadding="-1" cellspacing="-1">
																						<tr bgcolor="##c0c0c0">
																							<td width="#_tableWidth#px">
																								<table border="0" width="100%" cellpadding="-1" cellspacing="-1">
																									<tr>
																										<td width="33%">
																											<table cellpadding="-1" cellspacing="-1">
																												<tr>
																													<td width="50%" align="left" valign="top">
																														<table cellpadding="-1" cellspacing="-1">
																															<tr>
																																<td>
																																	<cfif 0>
																																		<font size="1">
																																		<small>
																																		<b>
																																		<a href="" id="_checkAllPages" title="Click this link to check all Pages of Content." style="display: inline;" onclick="return processCheckAllPages();"><font size="-1"><small><b><NOBR>(Check All)</NOBR></b></small></font></a>
																																		<a href="" id="_uncheckAllPages" title="Click this link to uncheck all Pages of Content." style="display: none;" onclick="return processUnCheckAllPages();"><font size="-1"><small><b><NOBR>(Un-Check All)</NOBR></b></small></font></a>
																																		</b>
																																		</small>
																																		</font>
																																	<cfelse>
																																		<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_checkAllPages")>
																																		<input type="button" #_tooltips_# title="Click this link to check all Pages of Content." style="display: inline;" onclick="return processCheckAllPages();" value="(Check All)" #_text_style_symbol#>
																																		<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_uncheckAllPages")>
																																		<input type="button" #_tooltips_# title="Click this link to uncheck all Pages of Content." style="display: none;" onclick="return processUnCheckAllPages();" value="(Un-Check All)" #_text_style_symbol#>
																																	</cfif>
																																</td>
																															</tr>
																															<tr>
																																<td>
																																	<font size="1">
																																	<small>
																																	<b>
																																	<cfif 0>
																																		<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_showPageNames")>
																																		<a href="" #_tooltips_# title="Click this link to show Page Names instead of Page Titles. Page Names are assigned by the system based on the Page Title." style="display: none;" onclick="performShowPageNames(); return false;"><font size="-1"><small><b><NOBR>(Show Page Names)</NOBR></b></small></font></a>
																																		<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_showPageTitles")>
																																		<a href="" #_tooltips_# title="Click this link to show Page Titles instead of Page Names. Page Titles are entered by the user whenever a user creates or edits a Content Page via the /Admin subsystem." style="display: inline;" onclick="performShowPageTitles(); return false;"><font size="-1"><small><b><NOBR>(Show Page Titles)</NOBR></b></small></font></a>
																																	<cfelse>
																																		<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_showPageNames")>
																																		<input type="button" #_tooltips_# title="Click this link to show Page Names instead of Page Titles. Page Names are assigned by the system based on the Page Title." style="display: none;" onclick="performShowPageNames(); return false;" value="(Show Page Names)" #_text_style_symbol#>
																																		<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_showPageTitles")>
																																		<input type="button" #_tooltips_# title="Click this link to show Page Titles instead of Page Names. Page Titles are entered by the user whenever a user creates or edits a Content Page via the /Admin subsystem." style="display: inline;" onclick="performShowPageTitles(); return false;" value="(Show Page Titles)" #_text_style_symbol#>
																																	</cfif>
																																	</b>
																																	</small>
																																	</font>
																																</td>
																															</tr>
																														</table>
																													</td>
																													<td width="50%" align="left" valign="top" style="font-size: 10px;">
																														<div id="_vcrControl_Begin2" style="display: none;">
																															<font color="#_enabled_color#">
																															<small>
																															<b>
																															<a href="" title="Scroll to the First Column of Content Pages" onClick="rewindVCRControls2(_numColumns, _maxVisibleCols); RefreshVCRControls2(_numColumns, _maxVisibleCols); return false;">#_vcrBeginAction_symbol#</a>
																															</b>
																															</small>
																															</font>
																														</div>
																														<div id="disabled_vcrControl_Begin2" style="display: none;">
																															<font color="#_disabled_color2#">
																															<small>
																															#_vcrBeginAction_symbol#
																															</small>
																															</font>
																														</div>
																														&nbsp;
																														<div id="_vcrControl_Prev2" style="display: none;">
																															<font color="#_enabled_color#">
																															<small>
																															<b>
																															<a href="" title="Scroll Left One Column of Content Pages" onclick="prevVCRControls2(_numColumns); RefreshVCRControls2(_numColumns, _maxVisibleCols); return false;">#_vcrPrevAction_symbol#</a>
																															</b>
																															</small>
																															</font>
																														</div>
																														<div id="disabled_vcrControl_Prev2" style="display: none;">
																															<font color="#_disabled_color2#">
																															<small>
																															#_vcrPrevAction_symbol#
																															</small>
																															</font>
																														</div>
																														&nbsp;
																														<div id="_vcrControl_Next2" style="display: none;">
																															<font color="#_enabled_color#">
																															<small>
																															<b>
																															<a href="" title="Scroll Right One Column of Content Pages" onclick="nextVCRControls2(_numColumns); RefreshVCRControls2(_numColumns, _maxVisibleCols); return false;">#_vcrNextAction_symbol#</a>
																															</b>
																															</small>
																															</font>
																														</div>
																														<div id="disabled_vcrControl_Next2" style="display: none;">
																															<font color="#_disabled_color2#">
																															<small>
																															#_vcrNextAction_symbol#
																															</small>
																															</font>
																														</div>
																														&nbsp;
																														<div id="_vcrControl_End2" style="display: none;">
																															<font color="#_enabled_color#">
																															<small>
																															<b>
																															<a href="" title="Scroll to the Last Column of Content Pages" onclick="ffwdVCRControls2(_numColumns, _maxVisibleCols); RefreshVCRControls2(_numColumns, _maxVisibleCols); return false;">#_vcrEndAction_symbol#</a>
																															</b>
																															</small>
																															</font>
																														</div>
																														<div id="disabled_vcrControl_End2" style="display: none;">
																															<font color="#_disabled_color2#">
																															<small>
																															#_vcrEndAction_symbol#
																															</small>
																															</font>
																														</div>
																													</td>
																												</tr>
																											</table>
																										</td>
																										<td width="33%" valign="top">
																											<cfif 0>
																												<b>
																												<a href="" id="_searchForPageName" style="display: inline;" title="Search for Page Name" onclick="getGUIObjectInstanceById('searchForPageName').style.display = const_inline_style; getGUIObjectInstanceById('_searchForPageName').style.display = const_none_style; getGUIObjectInstanceById('_searchForNextPageName').style.display = const_none_style; var _ff = getGUIObjectInstanceById('form_searchForPageName'); _ff._pageName.value = ''; setFocusSafely(_ff._pageName); _ClearPageNameSearch(); return false;"><font size="1"><small><b>#_lookupPageNameAction_prompt#</b></small></font></a>
																												<a href="" id="_searchForNextPageName" style="display: none;" title="Search for Next Page Name" onclick="var _ff = getGUIObjectInstanceById('form_searchForPageName'); PerformPageNameSearch(_ff._pageName.value, _numColumns, _maxVisibleCols, _ss_maxRowsPerColumn, getGUIObjectInstanceById('hilite_color').value); if (_last_page_name_search_i == -1) { getGUIObjectInstanceById('_searchForNextPageName').style.display = const_none_style } return false;"><font size="1"><small><b>#_lookupNextPageNameAction_prompt#</b></small></font></a>
																												</b>
																											<cfelse>
																												<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_searchForPageName")>
																												<input type="button" #_tooltips_# style="display: inline;" title="Search for Page Name" onclick="getGUIObjectInstanceById('searchForPageName').style.display = const_inline_style; getGUIObjectInstanceById('_searchForPageName').style.display = const_none_style; getGUIObjectInstanceById('_searchForNextPageName').style.display = const_none_style; var _ff = getGUIObjectInstanceById('form_searchForPageName'); _ff._pageName.value = ''; setFocusSafely(_ff._pageName); _ClearPageNameSearch(); return false;" value="#_lookupPageNameAction_prompt#" #_text_style_symbol#>
																												<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_searchForNextPageName")>
																												<input type="button" #_tooltips_# style="display: none;" title="Search for Next Page Name" onclick="var _ff = getGUIObjectInstanceById('form_searchForPageName'); PerformPageNameSearch(_ff._pageName.value, _numColumns, _maxVisibleCols, _ss_maxRowsPerColumn, getGUIObjectInstanceById('hilite_color').value); if (_last_page_name_search_i == -1) { getGUIObjectInstanceById('_searchForNextPageName').style.display = const_none_style } return false;" value="#_lookupNextPageNameAction_prompt#" #_text_style_symbol#>
																											</cfif>
																											<div id="searchForPageName" style="display: none;">
																												<cfset _formAction = "var _ff = getGUIObjectInstanceById('form_searchForPageName'); if (_ff._pageName.value.trim().length > 0) { PerformPageNameSearch(_ff._pageName.value, _numColumns, _maxVisibleCols, _ss_maxRowsPerColumn, getGUIObjectInstanceById('hilite_color').value); getGUIObjectInstanceById('searchForPageName').style.display = const_none_style; getGUIObjectInstanceById('_searchForPageName').style.display = const_inline_style; if (_last_page_name_search_i > -1) { getGUIObjectInstanceById('_searchForNextPageName').style.display = const_inline_style } } else { alert('Cannot search for a blank page name.'); } return false;">
																												<form action="#CGI.SCRIPT_NAME#" method="post" id="form_searchForPageName" onsubmit="#_formAction#">
																													<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																													<table cellpadding="-1" cellspacing="-1">
																														<tr>
																															<td>
																																<NOBR><font size="1"><small #_small_style_symbol#><b>Search for Page Named:</b></small></font></NOBR>&nbsp;
																																<input #_text_style_symbol# tabindex="1" type="text" name="_pageName" value="" size="10" maxlength="50" onkeydown="if (event.keyCode == 13) { #_formAction# }">
																															</td>
																															<td>
																																<input name="submitButton" tabindex="2" type="button" value="#_lookupPageNameAction_prompt#" title="Click this button to begin the search function." #_text_style_symbol# onClick="#_formAction#">&nbsp;
																															</td>
																															<td>
																																<input type="button" tabindex="3" name="cancelPopUp" value="#_cancelButton_symbol#" #_text_style_symbol# title="Click this button to cancel this operation." onClick="getGUIObjectInstanceById('searchForPageName').style.display = const_none_style; getGUIObjectInstanceById('_searchForPageName').style.display = const_inline_style; return false;">
																															</td>
																														</tr>
																													</table>
																												</form>
																											</div>
																										</td>
																										<td width="33%" valign="top">
																											<table width="100%" border="1" cellspacing="-1" cellpadding="2" bordercolor="##808080">
																												<tr>
																													<td bgcolor="##c0c0c0" id="hilite_color_preview" width="100%" valign="middle">
																														<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_HiliteColorSelector_")>
																														<cfif 0>
																															<A HREF="" #_tooltips_# title="Click this link to open the Hilite Color Selector dialog; this dialog allows you to choose the Hilite Color you wish to use when performing searches for content pages. The Hilite Color is the table cell background color that is used to Hilite the cell that matches your search criteria." onClick="cp.select(getGUIObjectInstanceById('hilite_color'),getGUIObjectInstanceById('hilite_color_preview'),'ColorPicker', -210, 25); return false;"><font size="-1"><small><b>[HiLite Color]</b></small></font></A>
																														<cfelse>
																															<input type="button" #_tooltips_# title="Click this link to open the Hilite Color Selector dialog; this dialog allows you to choose the Hilite Color you wish to use when performing searches for content pages. The Hilite Color is the table cell background color that is used to Hilite the cell that matches your search criteria." onClick="cp.select(getGUIObjectInstanceById('hilite_color'),getGUIObjectInstanceById('hilite_color_preview'),'ColorPicker', -350, 35); return false;" value="[HiLite Color]" #_text_style_symbol#>
																														</cfif>
																													</td>
																												</tr>
																											</table>
																											<input type="hidden" id="hilite_color" value="##c0c0c0">
																										</td>
																									</tr>
																								</table>
																							</td>
																							<td width="0px" align="left" valign="top">
																								<A HREF="" NAME="ColorPicker" ID="ColorPicker"></A>
																								<script language="JavaScript" type="text/javascript">
																								<!--
																									function ColorPicker_pickedColor( color) {
																										setCookie("ColorPicker", color, "/");
																									}
																									
																									var cp = new ColorPicker("colorPickerDiv", false, 18, false, false);
//																									var cp = new ColorPicker("", true, 18, false);
																									if (cp != null) {
																										cp.writeDiv();
																										var obj = getGUIObjectInstanceById('hilite_color_preview');
																										if (obj != null) {
																											obj.bgColor = getCookie("ColorPicker");
																										}
																									} else {
//																										alert('ColorPicker() failed !');
																									}
																								-->
																								</script>
																							</td>
																						</tr>
																					</table>
																				</td>
																			</tr>

																			<form action="#CGI.SCRIPT_NAME#" id="form_Update_Security_Settings" name="form_Update_Security_Settings" method="post" onSubmit="return checkandsubmit(this);">
																				<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																			<tr>
																				<td>
																					<table cellpadding="-1" cellspacing="-1">
																						<tr>
																							<cfset _overallLength = 0>
																							<cfset _itemIndex = 1>
																							<cfloop index="_aCol" from="1" to="#_numColumns#">
																								<td width="#Ceiling(100 / _numColumns)#%" valign="top">
																									<cfset _maxLenForCol = -1>
																									<div id="_securitySettingsCol#_aCol#" style="display: none;">
																										<table width="100%" cellpadding="-1" cellspacing="-1">
																											<tr bgcolor="##c0c0c0">
																												<td width="10%">
																													<font size="1"><small><b>&nbsp;?</b></small></font>
																												</td>
																												<td width="90%">
																													<NOBR><font size="1"><small><b>Page Name <font size="1">(#_aCol#/#_numColumns#)</font></b></small></font></NOBR>
																												</td>
																											</tr>
																											<cfset _line_height = "20px">
																											<cfloop index="_aRow" from="1" to="#_ss_maxRowsPerColumn#">
																												<cfset _bgColor = Trim(commonCode.reportTableRowColor(_aRow))>
																												<tr id="_row_pageId#_itemIndex#" bgcolor="#_bgColor#">
																													<cfset _i = ((_aRow - 1) + (_ss_maxRowsPerColumn * (_aCol - 1))) + 1>
																													<cfset _anItem = "">
																													<cfif (ListLen(_aList, ",") gte _i)>
																														<cfset _anItem = ListGetAt(_aList, _i, ",")>
																													</cfif>
																													<cfif (Len(_anItem) gt 0)>
																														<cfset _maxLenForCol = Max(_maxLenForCol, Len(_anItem))>
																														<cfset p_name = GetToken(_anItem, 1, "=")>
																														<cfset p_title = GetToken(p_name, 2, "@")>
																														<cfset _name = GetToken(p_name, 1, "@")>
																														<td height="#_line_height#">
																															<input type="hidden" id="p_pageId#_itemIndex#" value='#p_name#'>
																															<cfset _subsystem_security_advisory = "<br><br><font color=red>Access revoked by unchecking this page of content may not necessarily keep a user from saving their last change made using the WYSIWYG HTML Editor.  Revoked access will however keep a user from being able to gain access to the GUI for the WYSIWYG HTML Editor for this page of content.</font>">
																															<cfset _page_name_title = "Click this checkbox item to grant the selected user access to this page of content.#_subsystem_security_advisory#">
																															<div id="enabled_cb_pageId#_itemIndex#" style="display: inline;">
																																<input type="checkbox" name="_pageId" id="_pageId#_itemIndex#" value="#_name#" onclick="return processCheckBoxChange(this, event);" ondblclick="return false;">
																															</div>

																															<div id="disabled_cb_pageId#_itemIndex#" style="display: none;">
																																<input type="checkbox" id="disabled_pageId#_itemIndex#" disabled>
																															</div>
																														</td>
																														<td id="_cell_pageId#_itemIndex#" height="#_line_height#">
																															<div id="enabled_p_pageId#_itemIndex#" style="display: inline;">
																																<div id="div_page_name#_itemIndex#" style="display: inline;">
																																	#CommonCode.osStyleRadioButtonCaption( "True", _page_name_title, "_pageId#_itemIndex#", '<NOBR><font size="1"><small>#_name#</small></font>')#
																																</div>
																																<div id="div_page_title#_itemIndex#" style="display: none;">
																																	#CommonCode.osStyleRadioButtonCaption( "True", _page_name_title, "_pageId#_itemIndex#", '<NOBR><font size="1"><small>#p_title#</small></font>')#
																																</div>
																																<cfif Len(_name) lt _ss_maxCharsPerColumn>
																																	#RepeatString("&nbsp;", _ss_maxCharsPerColumn - Len(_name))#
																																</cfif>
																																</NOBR>
																															</div>

																															<div id="disabled_p_pageId#_itemIndex#" style="display: none;">
																																<div id="disabled_div_page_name#_itemIndex#" style="display: inline;">
																																	<NOBR><font size="1"><small>#_name#</small></font>
																																</div>
																																<div id="disabled_div_page_title#_itemIndex#" style="display: none;">
																																	<NOBR><font size="1"><small>#p_title#</small></font>
																																</div>
																																<cfif Len(_name) lt _ss_maxCharsPerColumn>
																																	#RepeatString("&nbsp;", _ss_maxCharsPerColumn - Len(_name))#
																																</cfif>
																																</NOBR>
																															</div>
																														</td>
																														<cfset _itemIndex = IncrementValue(_itemIndex)>
																													<cfelse>
																														<td height="#_line_height#">
																															&nbsp;
																														</td>
																														<td height="#_line_height#">
																															#RepeatString("&nbsp;", _ss_maxCharsPerColumn)#
																														</td>
																													</cfif>
																												</tr>
																											</cfloop>
																											<cfset _overallLength = _overallLength + _maxLenForCol>
																										</table>
																									</div>
																								</td>
																							</cfloop>
																						</tr>
																					</table>
																					<cfset _maxVisibleCols = Min(_numColumns, _ss_maxVisibleCols)>

																					<script language="JavaScript1.2" type="text/javascript">
																					<!--
																						var _ss_maxRowsPerColumn = #_ss_maxRowsPerColumn#;
																						
																						var _maxVisibleCols = #_maxVisibleCols#;
																						for (var _i = 1; _i <= _maxVisibleCols; _i++) {
																							var objE = getGUIObjectInstanceById('_securitySettingsCol' + _i.toString());
																							if (objE != null) {
																								objE.style.display = const_inline_style;
																							}
																						}
																						
																						var _numColumns = #_numColumns#;
																						RefreshVCRControls2(_numColumns, _maxVisibleCols);
																					-->
																					</script>

																					<input type="hidden" name="_currentSubSystemRow" value="#(_currentSubSystemRow - 1)#">
																					<cfloop index="_itemNum" from="1" to="#(_currentSubSystemRow - 1)#">
																						<input type="hidden" id="m_subsystemId#_itemNum#" name="_subsystemId#_itemNum#" value="">
																					</cfloop>

																					<input type="hidden" id="_page_uid" name="_id" value="-1">
																				</td>
																			</tr>
																			<tr>
																				<td>
																					<cfif (_maxVisibleCols eq 0)>
																						<table width="100%" border="1" cellpadding="1" cellspacing="1">
																							<tr>
																								<td bgcolor="##ffffff">
																									<span style="font-size: 12px;"><b>(Cannot define Security Settings for Content Pages unless there is a current Draft Release however you may define Subsystem Security settings at this time - See your /Release Manager to have a Draft Release made and then return to this page and Refresh to proceed.)</b></span>
																									#RepeatString("<BR>", 2)#
																								</td>
																							</tr>
																						</table>
																					</cfif>
																					<input type="hidden" name="_submit_" value="#_updateSubSystemPageAccessAction_symbol#">
																					<input type="submit" name="submitButton" id="submitButton_security_settings" value="Update Security Settings" title="Click this button to save the changes made to the security settings to the database for the selected user." #_text_style_symbol# onclick="var cObj = getGUIObjectInstanceById('cancelPopUp_security_settings'); var formObj = getGUIObjectInstanceById('form_Update_Security_Settings'); if ( (cObj != null) && (formObj != null) ) { return suppress_button_double_click2(this, cObj, formObj); } return false;" ondblclick="return false;">
																					&nbsp;&nbsp;
																					<input type="button" id="cancelPopUp_security_settings" tabindex="3" title="Click this button to Cancel this dialog." value="#_cancelButton_symbol#" #_text_style_symbol# onClick="hideSecuritySettingsForm(); return false;">
																				</td>
																			</tr>
																			</form>

																			<script language="JavaScript1.2" type="text/javascript">
																			<!--
																				register_disableButtons_function(process_disable_clickable_controls); 
																			-->
																			</script>
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
								</div>
							</td>
						</tr>
					</table>

					<!--- BEGIN: Tabbed Interface goes here... --->
					<div id="TabSystem1" class="content">
						<div class="tabs">
							<cfset _disp_tabNum = 1>
							<cfset _displaying_uid = -1>
							<cfset _displaying_tabNum = 1>
							<cfscript>
								cache_sbcuid_objects = QueryNew("sbcuid, name, phone");
							</cfscript>
							<cfloop query="GetDisplayableUserList" startrow="1" endrow="#GetDisplayableUserList.recordCount#">
								<cfif _displaying_uid neq GetDisplayableUserList.uid>
									<cfset _displaying_uid = GetDisplayableUserList.uid>
	
									<cfif (Len(GetDisplayableUserList.userid) gt 0)>
										<cfset _class = "tab">
										<cfif (_displaying_tabNum eq 1)>
											<cfset _class = "tab tabActive">
										</cfif>
	
										<cfset _display = "inline">
										<cfif (_disp_tabNum gt _num_tabs_max)>
											<cfset _display = "none">
										</cfif>

										<cfscript>
											an_array = CommonCode.safely_getuserinfo2( GetDisplayableUserList.userid);
											_user_phone = an_array[4];
											_user_name = an_array[2] & ' ' & an_array[3];

											if (Len(Trim(_user_name)) gt 0) {
												_user_phone = CommonCode.formattedPhoneNumber(_user_phone);
											}
											CommonCode.cache_sbcuid_objects(cache_sbcuid_objects, GetDisplayableUserList.userid, "#_user_name#@#_user_phone#");
										</cfscript>

										<div id="cell_tab#_disp_tabNum#" style="display: #_display#;">
											<a href="###GetDisplayableUserList.userid#" accesskey="#_disp_tabNum#" tabindex="#_disp_tabNum#" id="tab#_disp_tabNum#" title="#_user_name# #_user_phone#" class="#_class#">
												&nbsp;<font size="1"><small>#GetDisplayableUserList.userid#&nbsp;(#_disp_tabNum#/#_displayableNum#)</small></font>
											</a>
										</div>
	
										<cfset _displaying_tabNum = IncrementValue(_displaying_tabNum)>
										<cfset _disp_tabNum = IncrementValue(_disp_tabNum)>
									</cfif>
								</cfif>
							</cfloop>
						</div>

						#CommonCode.div_loadingContent("Security Data")#

						<cfset _SubSystemList_aList = CommonCode.processRecordList(_SubSystemList_)>
						<cfset _ContentList_aList = CommonCode.processRecordList(_ContentPageList)>
						
						<cfset _disp_tabNum = 1>
						<cfset _displaying_uid = -1>
						<cfset _displaying_tabNum = 1>
						<cfloop query="GetDisplayableUserList" startrow="1" endrow="#GetDisplayableUserList.recordCount#">
							<cfif _displaying_uid neq GetDisplayableUserList.uid>
								<cfset _displaying_uid = GetDisplayableUserList.uid>
	
								<cfif (Len(GetDisplayableUserList.userid) gt 0)>
									<div id="content#_disp_tabNum#" class="content" style="display: none;">
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td width="25%" valign="top">
													<table width="100%" cellpadding="-1" cellspacing="-1">
														<tr>
															<td>
																<b>SBCUID:</b>&nbsp;#GetDisplayableUserList.userid#
															</td>
														</tr>
														<cfset _urlParms = "_id=#GetDisplayableUserList.uid#">

														<cfscript>
															_dataString = CommonCode.cache_sbcuid_objects(cache_sbcuid_objects, GetDisplayableUserList.userid);
															_user_name = "";
															_user_phone = "(Web Phone Offline)";
															if (ListLen(_dataString, "@") eq 2) {
																_user_name = GetToken(_dataString, 1, "@");
																_user_phone = GetToken(_dataString, 2, "@");
															}
														</cfscript>
														<tr>
															<td>
																<cfset _editUserLink = _user_name>
																<cfif (function neq _dropUserAction_symbol) AND (function neq _editUserAction_symbol) AND (function neq _addUserAction_symbol) AND (submit neq _dropUserAction_symbol) AND (submit neq _editUserAction_symbol) AND (submit neq _addUserAction_symbol)>
																	<cfset _urlParms2 = "&_userid=#URLEncodedFormat(GetDisplayableUserList.userid)#&_user_name=#URLEncodedFormat(_user_name)#&_user_phone=#URLEncodedFormat(_user_phone)#">
																</cfif>
																<NOBR>
																<b>Name:</b>&nbsp;
																<div id="open_editor_link#_disp_tabNum#" style="display: inline;">
																	<small>
																	<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_edit_sbcuid_")>
																	<a href="" #_tooltips_# title="Click this link to edit the SBCUID for this user to make this user into a different user." onclick="performClickEditSBCUIDLink(#_disp_tabNum#); return false;">#_user_name#</a>
																	</small>
																</div>
																<div id="opened_editor_link#_disp_tabNum#" style="display: none;">
																	<small>
																	#_user_name#
																	</small>
																</div>
																&nbsp;
																</NOBR>
															</td>
														</tr>
														<tr>
															<td>
																<b>Phone:</b>&nbsp;<small>#_user_phone#</small>
															</td>
														</tr>
														<tr>
															<td>
																<div id="editor#_disp_tabNum#" style="display: none;">
																	<hr color="##0000FF">
																	<cfset _formAction = "var obj = getGUIObjectInstanceById('_users_sbcuid'); var val = ''; if (obj != null) { val = obj.value; } if ( (isSBCUIDValid(val)) && (quietlyPerformSearch(val) == -1) ) { return true } else { alert('You have entered an invalid SBCUID or the SBCUID is already in the database. Please try again.'); return false }">
																	<form action="#CGI.SCRIPT_NAME#" method="post" id="form_editor#_disp_tabNum#" onsubmit="#_formAction#">
																		<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																		<table cellpadding="-1" cellspacing="-1">
																			<tr>
																				<td>
																					<small #_small_style_symbol#><b>SBCUID:</b></small>&nbsp;
																					<input #_text_style_symbol# type="text" name="_userid" id="_users_sbcuid" value="#Trim(GetDisplayableUserList.userid)#" size="7" maxlength="6" title="Enter a different SBCUID to reuse this user's slot in the /Security subsystem's database." onkeypress="if (isSBCUID_KeycodeValid(event.keyCode)) { return true } else {return false }">
																					<br>
																					<p align="justify" style="font-size: x-small; line-height: 11px;"><small #_small_style_symbol#><i>(Replace this user's SBCUID with a different SBCUID. This does not change any data associated with the selected user's SBCUID however it does allow this user's slot in the /Security database to be reused.)</i></small></p>
																				</td>
																			</tr>
																			<cfif 0>
																				<tr>
																					<td>
																						<small #_small_style_symbol#><b>User's Name:</b></small>&nbsp;
																						<input #_text_style_symbol# disabled type="text" name="_user_name" value="#_user_name#" size="32" maxlength="50">
																					</td>
																				</tr>
																				<tr>
																					<td>
																						<small #_small_style_symbol#><b>User's Phone:</b></small>&nbsp;
																						<input #_text_style_symbol# disabled type="text" name="_user_phone" value="#_user_phone#" size="32" maxlength="50">
																					</td>
																				</tr>
																			</cfif>
																			<tr>
																				<td>
																					<cfif Len(GetDisplayableUserList.uid) gt 0>
																						<input type="hidden" name="_id" value="#GetDisplayableUserList.uid#">
																					</cfif>
																					<input type="hidden" name="submit" value="#_editUserAction_symbol#">
																					<input name="submitButton" type="submit" title="Click this button to save the SBCUID to the selected user's record in the /Security subsystem's database." value="#_editUserAction_symbol#" #_textarea_style_symbol# onclick="performCloseSBCUIDEditor(#_disp_tabNum#); return true;">&nbsp;
																					<input type="button" name="cancelPopUp" value="#_cancelButton_symbol#" title="Click this button to cancel this operation." #_textarea_style_symbol# onClick="performCloseSBCUIDEditor(#_disp_tabNum#); return false;">
																				</td>
																			</tr>
																		</table>
																	</form>
																</div>
															</td>
														</tr>
														<tr>
															<td>
																<cfif (function neq _dropUserAction_symbol) AND (function neq _editUserAction_symbol) AND (function neq _addUserAction_symbol) AND (submit neq _dropUserAction_symbol) AND (submit neq _editUserAction_symbol) AND (submit neq _addUserAction_symbol)>
																	<b>
																	<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_dropThisUser#_disp_tabNum#")>
																	<cfif 0>
																		<a href="" #_tooltips_# title="Click this link to delete a user from the security database for this system only.  This operation will not make any changes to the web phone database." onclick="getGUIObjectInstanceById('dropThisUser#_disp_tabNum#').style.display = const_inline_style; getGUIObjectInstanceById('_dropThisUser#_disp_tabNum#').style.display = const_none_style; setFocusSafely(getGUIObjectInstanceById('form_dropThisUser#_disp_tabNum#')._dropVerify); getGUIObjectInstanceById('_addNewUser').style.display = const_none_style; getGUIObjectInstanceById('_searchForUser').style.display = const_none_style; return false;"><font size="1"><small>#_dropUserAction_symbol#</small></font></a>
																	<cfelse>
																		<input type="button" #_tooltips_# #_textarea_style_symbol# title="Click this link to delete a user from the security database for this system only.  This operation will not make any changes to the web phone database." onclick="return processClickDeleteUserButton(this, #_disp_tabNum#);" ondblclick="return false;" value="#_dropUserAction_symbol#">
																	</cfif>
																	</b>
																</cfif>
																<div id="dropThisUser#_disp_tabNum#" style="display: none;">
																	<form action="#CGI.SCRIPT_NAME#" method="post" id="form_dropThisUser#_disp_tabNum#">
																		<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																		<table cellpadding="-1" cellspacing="-1">
																			<tr>
																				<td>
																					<select name="_dropVerify" id="select_dropVerify#_disp_tabNum#" style="font-size:12px " onfocus="this.form._dropVerify.options[0].selected = 1; return false;" onChange="return processConfirmedDeleteSBCUID(this, #_disp_tabNum#);">
																						<option selected value="##">Confirm the action :: Delete SBCUID #GetDisplayableUserList.userid# ?</option>
																						<cfset _yesFunction = "#_dropUserAction_symbol#">
																						<cfset _promptText = "Deletion of SBCUID #GetDisplayableUserList.userid#">
																						<cfset _yesPrompt = "Yes - Perform #_promptText#.">
																						<option value="#CGI.SCRIPT_NAME#?_userid=#GetDisplayableUserList.userid#&#_urlParms#&function=#URLEncodedFormat(_yesFunction)##Request.next_splashscreen_inhibitor#">#GetToken(_yesFunction, 2, "|")##_yesPrompt#</option>
																						<cfset _noFunction = "No">
																						<cfset _noPrompt = "No - Do not perform #_promptText#.">
																						<option value="#_noFunction#">#GetToken(_noFunction, 2, "|")##_noPrompt#</option>
																					</select>
																				</td>
																			</tr>
																			<tr>
																				<td>
																					<input type="button" name="cancelPopUp" id="cancel_dropThisUser#_disp_tabNum#" value="#_cancelButton_symbol#" #_textarea_style_symbol# onClick="return processCancelDeleteUserButton(this, #_disp_tabNum#);">
																				</td>
																			</tr>
																		</table>
																	</form>
																</div>
															</td>
														</tr>
													</table>
												</td>
											<td>
												<table cellpadding="-1" cellspacing="-1">
													<tr>
														<td colspan="3">
															<cfset style_EditView_Settings = "inline">
															<cfset style_EditView_NoSettings = "none">
															<cfif (NOT IsDefined("GetDisplayableUserList.rid")) OR (Len(GetDisplayableUserList.rid) eq 0)>
																<cfset style_EditView_Settings = "none">
																<cfset style_EditView_NoSettings = "inline">
															</cfif>
															<div id="_EditView_Settings#_disp_tabNum#" style="display: #style_EditView_Settings#;">
																<cfif 0>
																	<b>
																	<small>
																	<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_EditView_Settings#_disp_tabNum#_")>
																	<a href="" #_tooltips_# title="Click this link to display the Security Settings for the selected user. Security Settings for Pages of Content may only be assigned when there is a Draft Release." onClick="showSecuritySettingsForm(); ProcessCheckBoxes(#GetDisplayableUserList.uid#, getGUIObjectInstanceById('t_SubSystemList_aList'), getGUIObjectInstanceById('t_ContentList_aList')); init_m_subsystemId(); return false;">#_editViewSettingsAction_symbol#</a>
																	</small>
																	</b>
																<cfelse>
																	<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_EditView_Settings#_disp_tabNum#_")>
																	<input type="button" #_tooltips_# title="Click this link to display the Security Settings for the selected user. Security Settings for Pages of Content may only be assigned when there is a Draft Release." #_textarea_style_symbol# onClick="showSecuritySettingsForm(); ProcessCheckBoxes(#GetDisplayableUserList.uid#, getGUIObjectInstanceById('t_SubSystemList_aList'), getGUIObjectInstanceById('t_ContentList_aList')); init_m_subsystemId(); return false;" value="#_editViewSettingsAction_symbol#">
																</cfif>
																<input type="hidden" id="t_SubSystemList_aList" value="#_SubSystemList_aList#">
																<input type="hidden" id="t_ContentList_aList" value="#_ContentList_aList#">
															</div>
															<div id="_EditView_NoSettings#_disp_tabNum#" style="display: #style_EditView_NoSettings#;">
																<cfif 0>
																	<b>
																	<small>
																	<i>
																	Edit/View Settings
																	</i>
																	</small>
																	</b>
																</cfif>
															</div>
															<div id="_securitySettings_help#_disp_tabNum#" style="display: none; background-color: ##FFFFE0; font-size: 10px;">
																<table width="100%" cellpadding="-1" cellspacing="-1">
																	<tr bgcolor="##FFFFE0">
																		<td>
																			<small><b>Security Settings Online Help.</b></small>
<textarea cols="100" rows="4" readonly wrap="soft" style="background-color: ##FFFFE0; font-size: 10px;">
There are two types of Security Settings that are used to specify to the system what level of access each user should be granted.  SubSystem and Page Name.  SubSystem access grants users those abilities associated with each SubSystem or part of the system.  Page Name access grants users the ability to edit, modify or maintain web content based on the name of a page of content.

The SubSystem is used to specify which part of the system the user may access. Users wishing to edit, modify or maintain content should be granted access to the Admin SubSystem. Users wishing to perform Releases such as migrating content from Draft to Production or vice-versa should be granted access to the Release SubSystem.

The Page Name is used to specify which content pages the user may edit, modify or maintain. Page Names are defined by the system based on the Page Title for each page of content. In cases where the name of the page may not be sufficient the user may also view the Page Titles for each page when making selections below.
</textarea>
																		</td>
																	</tr>
																</table>
															</div>
														</td>
													</tr>
												</table>
											</td>
										</table>

										<cfif 0>
											<div class="padder"></div>
										</cfif>
									</div>

									<cfset _displaying_tabNum = IncrementValue(_displaying_tabNum)>
									<cfset _disp_tabNum = IncrementValue(_disp_tabNum)>
								</cfif>
							</cfif>
						</cfloop>
					</div>
					<!--- END! Tabbed Interface goes here... --->
				</cfif>
			</cfif>

			#RepeatString("<BR>", 25)#
		</div>
	</div>
	<cfif (IsDefined("x_function")) AND (x_function eq _lookupUserAction_symbol) AND (IsDefined("x_userid")) AND (Len(x_userid) gt 0)>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
		_deferred_performSearchFor = '#x_userid#';
		-->
		</script>
	</cfif>
</cfoutput>
