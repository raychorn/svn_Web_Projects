<cfset _layout_id = -1>
<cfif (IsDefined("GetCurrentContent.layid")) AND (Len(Trim(GetCurrentContent.layid)) gt 0) AND (IsNumeric(GetCurrentContent.layid))>
	<cfset _layout_id = GetCurrentContent.layid>
</cfif>

<cfoutput>
	<table width="990px" cellpadding="-1" cellspacing="-1">
		<tr>
			<td>
				<div id="header">
					<div id="welcome">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									<h2><NOBR>#Request._site_name# - Layout</NOBR></h2>
								</td>
								<td>
									<div id="user_notices1" style="display: inline; position: absolute; top: 1px; left: 400px">
										<!--- BEGIN: This code was here to keep users from using the Layout subsystem when there was NO Draft --->
										<cfif (NOT bool_missing_draft_condition)>
										</cfif>
										<!--- END! This code was here to keep users from using the Layout subsystem when there was NO Draft --->
										<textarea cols="95" rows="5" readonly wrap="soft" style="font-size: 10px;">Note: Changes made to the Site Layout for the Draft Release will have immediate effect on the Draft Release.  The Site Layout that is IN-USE for the Draft Release will be associated with the Release throughout the life-cycle of the Release which is to say the Site Layout defined when the Release is the Draft will be the same site layout IN-USE when the Release is Staging or Production.  Site Layout changes cannot be made to Releases other than the Draft.  Draft Release will not have a Layout defined until the /Layout SubSystem has been used to define which Layout Spec the Draft Release is to use, this is by-design.</textarea>
									</div>
								</td>
								<td>
									<div id="_errorMessage1" style="display: none;">
										#CommonCode.makePageNameErrorMessageBlock(50, "popup_errorMessage1", "Missing comments. <U>CANNOT</U> Submit !", False)#
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td bgcolor="##c0c0c0" height="36px" valign="top">
				<!--- BEGIN: This code was here to keep users from using the Layout subsystem when there was NO Draft --->
				<cfif (NOT bool_missing_draft_condition)>
				</cfif>
				<!--- END! This code was here to keep users from using the Layout subsystem when there was NO Draft --->
				<table width="550px" cellpadding="-1" cellspacing="-1">
					<tr>
						<cfset _this_table_cells_width = "40px">
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
						<td width="50px" align="center" valign="top">
							&nbsp;
						</td>
						<td width="100px" align="left" valign="top">
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_findInUseLayout")>
							<input type="button" #_tooltips_# #_text_style_symbol# value="#_lookupInUseAction_symbol#" title="Search for the In-Use Layout - there can be only one Layout that is In-Use in the database at any point in time." style="display: inline;" onclick="this.disabled = true; _allow_RefreshVCRControls = false; processClickSearchKeywordLink(true); FocusOnTabWithAnchorText('IN-USE'); RefreshVCRControls(); _allow_RefreshVCRControls = true; this.disabled = false; return false;" ondblclick="return false;">
						</td>
						<td width="200px" align="right" valign="top">
							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_openUsageKeyLayout")>
							<input type="button" #_tooltips_# #_text_style_symbol# value="#_openUsageKeyAction_symbol#" title="Open the Usage Key to see how certain items are used within the /Layout SubSystem." style="display: inline;" onclick="this.disabled = true; processClickOpenUsageKeyLink(true, this.id); return false;" ondblclick="return false;">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<div id="maintext">
					<!--- BEGIN: Tabbed Interface goes here... --->
					<div id="TabSystem1" class="content">
						<div class="tabs">
							<cfset _disp_tabNum = 1>
							<cfset _displayableNum = 1>
							<cfset _displaying_tabNum = 1>
							
							<!--- BEGIN: This code was here to keep users from using the Layout subsystem when there was NO Draft --->
							<cfif (NOT bool_missing_draft_condition) AND (IsDefined("GetDefaultLayoutList")) AND (GetDefaultLayoutList.recordCount gt 0)>
							</cfif>
							<!--- END! This code was here to keep users from using the Layout subsystem when there was NO Draft --->

							<cfset _displayableNum = GetDefaultLayoutList.recordCount>

							<cfloop query="GetDefaultLayoutList" startrow="1" endrow="#GetDefaultLayoutList.recordCount#">
								<cfset _class = "tab">
								<cfif (_displaying_tabNum eq 1)>
									<cfset _class = "tab tabActive">
								</cfif>
	
								<cfset _display = "inline">
								<cfif (_disp_tabNum gt _num_tabs_max)>
									<cfset _display = "none">
								</cfif>

								<cfset _href_data = GetDefaultLayoutList.id>
								<cfset _title_data = "The #URLDecode(GetDefaultLayoutList.layout_name)#.">
								<cfset _anchor_caption = "#_title_data#">

								<cfset _in_use_flag = "">
								<cfif (_layout_id eq GetDefaultLayoutList.id)>
									<cfset _in_use_flag = "(<U>IN-USE</U>)">
								</cfif>
								
								<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("cell_tab#_disp_tabNum#")>
								<div #_tooltips_# title="#_title_data#" style="display: #_display#;">
									<a href="###_href_data#" accesskey="#_disp_tabNum#" tabindex="#_disp_tabNum#" id="tab#_disp_tabNum#" title="#_title_data#" class="#_class#">
										&nbsp;<font size="1"><small>#_in_use_flag#&nbsp;Layout&nbsp;(#_disp_tabNum#/#_displayableNum#)</small></font>
									</a>
								</div>

								<cfset _disp_tabNum = IncrementValue(_disp_tabNum)>
							</cfloop>
							<!--- BEGIN: This code was here to keep users from using the Layout subsystem when there was NO Draft --->
							<cfif 0>
								<cfset _class = "tab">
								<cfif (_displaying_tabNum eq 1)>
									<cfset _class = "tab tabActive">
								</cfif>
	
								<cfset _display = "inline">
								<cfif (_disp_tabNum gt _num_tabs_max)>
									<cfset _display = "none">
								</cfif>

								<cfset _href_data = 1>
								<cfset _title_data = "The #const_Default_Layout_name_symbol#.">
								<cfset _anchor_caption = "#const_Default_Layout_name_symbol#">

								<div id="cell_tab#_disp_tabNum#" style="display: #_display#;">
									<a href="###_href_data#" accesskey="#_disp_tabNum#" tabindex="#_disp_tabNum#" id="tab#_disp_tabNum#" title="#_title_data#" class="#_class#">
										&nbsp;<font size="1"><small>#_anchor_caption#&nbsp;(#_disp_tabNum#/#_displayableNum#)</small></font>
									</a>
								</div>
							</cfif>
							<!--- END! This code was here to keep users from using the Layout subsystem when there was NO Draft --->
						</div>
						#CommonCode.div_loadingContent("Layout Data")#

						<cfset _global_button_disable = "disabled">
						<cfset _global_button_disable_msg = " This button has been disabled because there is NO Draft to act upon.">
						<cfif (NOT bool_missing_draft_condition) AND (IsDefined("GetDefaultLayoutList")) AND (GetDefaultLayoutList.recordCount gt 0)>
							<cfset _global_button_disable = "">
							<cfset _global_button_disable_msg = "">
						</cfif>

						<cfset _disp_tabNum = 1>
						<cfloop query="GetDefaultLayoutList" startrow="1" endrow="#GetDefaultLayoutList.recordCount#">
							<cfset isThisDefaultLayout = "False">
							<cfset _title_data = URLDecode(GetDefaultLayoutList.layout_name)>
							<cfif (UCASE(TRIM(_title_data)) eq UCASE(TRIM(const_Default_Layout_name_symbol)))>
								<cfset isThisDefaultLayout = "True">
							</cfif>
							<div id="content#_disp_tabNum#" class="content" style="display: none;">
								<table width="100%" cellpadding="-1" cellspacing="-1">
									<tr>
										<td valign="top" align="left">
											<BIG><b>#_title_data#</b></BIG>
										</td>
									</tr>
									<tr>
										<td valign="top" align="left">
											<table width="300px" cellpadding="-1" cellspacing="-1">
												<tr>
													<td>
														<cfset _button_disabled = "disabled">
														<cfif (_layout_id neq GetDefaultLayoutList.id)>
															<cfset _button_disabled = _global_button_disable>
														</cfif>
														<form name="form_layoutUseItAction#_disp_tabNum#" action="#CGI.SCRIPT_NAME#" method="post" onSubmit="return checkandsubmit(this);">
															<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
															<input type="hidden" name="_submit_" value="#layoutUseItAction_symbol#">
															<input type="hidden" name="_layout_id" value="#GetDefaultLayoutList.id#">
															<cfset _anchor_caption = "#_title_data#">
															<input type="hidden" name="_editable_layout_name" value="#_anchor_caption#">
															<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("button_layoutUseItAction#_disp_tabNum#")>
															<input type="button" #_button_disabled# #_tooltips_# #_text_style_symbol# value="#layoutUseItAction_symbol#" title="Click this button to associate this layout with the current Draft Release.#_global_button_disable_msg#" onclick="return suppress_button_double_click2(this, null, this.form);" ondblclick="return false;">
														</form>
													</td>
													<td>
														<cfset _button_disabled = "">
														<form name="form_layoutEditItAction#_disp_tabNum#">
															<input type="hidden" id="_layout_spec_codes#_disp_tabNum#" value="#GetDefaultLayoutList.layout_spec#">
															<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("button_layoutEditItAction#_disp_tabNum#")>
															<input type="button" #_button_disabled# #_tooltips_# #_text_style_symbol# value="#layoutEditItAction_symbol#" title="Click this button to Edit this layout or make a new Layout Spec." onclick="var btn_value = this.value; suppress_button_double_click2(this, null, null); return processEditThisLayoutSpec(#_disp_tabNum#, btn_value);" ondblclick="return false;">
														</form>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>
											<table width="100%" cellpadding="-1" cellspacing="-1">
												<tr>
													<td valign="<cfif 0>middle<cfelse>top</cfif>" align="left">
														<div id="_show_layout_spec_graphic#_disp_tabNum#" style="display: inline;">
															<cfset _layout_spec = URLDecode(GetDefaultLayoutList.layout_spec)>
															<cfset _layout_graphic = CommonCode.makeSiteLayoutSpecFromCodes(_layout_spec, "True", 'width="400px"')>
															#_layout_graphic#
															<p align="justify"><small><b>(<i>Colors shown in the graphical representation (above) are intended to make the layout easier to read and do not indicate the actual colors used at run-time when the layout is actually being used; however it is possible to options within the layout that will not be shown until the layout is actually used at run-time.  Cell heights that are specified within the Layout Spec will be removed from the actual layout when the Layout Spec is used to render the actual layout.  Users may adjust their content to achieve the desired heights of cells whenever doing so might have been achieved by adjusting the Layout Spec.  The Layout Spec should be thought of as being nothing more than a scaffold onto which the content is placed.</i>)</b></small></p>
														</div>
														<div id="_edit_layout_spec_graphic#_disp_tabNum#" style="display: none;">
															<form name="form_layoutSaveLayoutAction#_disp_tabNum#" action="#CGI.SCRIPT_NAME#" method="post" onSubmit="return checkandsubmit(this);">
																<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
																<table width="100%" cellpadding="-1" cellspacing="-1">
																	<tr>
																		<td>
																			<table width="100%" cellpadding="-1" cellspacing="-1" id="table_editable_layout_spec#_disp_tabNum#" style="display: inline;">
																				<tr>
																					<td width="45%" align="left">
																						<cfset _input_title = "This is the #const_Default_Layout_name_symbol# spec so the Layout Spec Name cannot be edited at this time.">
																						<cfset _input_disabled = "disabled">
																						<cfif (_displayableNum gt 1)>
																							<cfset _input_disabled = "">
																							<cfset _input_title = "Enter the Layout Spec Name here.  This is the name that will appear on the Tabs title for each Layout Spec in the database. The Layout Spec Name must be unique and cannot be saved to the database if there is already a Layout Spec with the same name entered here.">
																						</cfif>
																						<cfset _anchor_caption = _title_data>
																						<div id="real_editable_layout_name#_disp_tabNum#" style="display: inline;">
																							<cfset _input_readonly = "">
																							<cfif (isThisDefaultLayout) OR (Len(Trim(_global_button_disable)) neq 0)>
																								<cfset _input_readonly = "readonly">
																							</cfif>
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_editable_layout_name#_disp_tabNum#")>
																							<input name="_editable_layout_name" #_input_readonly# #_input_disabled# #_tooltips_# #_text_style_symbol# value="#_anchor_caption#" size="65" maxlength="50" title="#_input_title#">
																						</div>
																						<div id="fake_editable_layout_name#_disp_tabNum#" style="display: none;">
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("fak_editable_layout_name#_disp_tabNum#")>
																							<input #_tooltips_# #_text_style_symbol# value="" size="65" maxlength="50">
																						</div>
																					</td>
																					<td width="*" align="left" style="display: inline;">
																						<cfset _cb_title = "Click this checkbox to cause the Layout Name to be changed otherwise a new Layout will be created using the name entered.">
																						<div id="real_editable_layout_change_name#_disp_tabNum#" style="display: inline;">
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_editable_layout_change_name#_disp_tabNum#")>
																							<cfset _cb_caption = CommonCode.osStyleRadioButtonCaption( "True", _cb_title, "_editable_layout_change_name#_disp_tabNum#", '<font id="_menu_item_editor_internal_font" size="1"><small><b>Change Layout Name</b></small></font>', "processSaveModeChange(#_disp_tabNum#, '#layoutSaveLayoutAction_symbol#', '#layoutSaveNewLayoutAction_symbol#', '_editable_layout_change_name#_disp_tabNum#', '#isThisDefaultLayout#');")>
																							<cfset _cb_caption2 = '<font color="##c0c0c0" id="_menu_item_editor_internal_font" size="1"><small><b>Change Layout Name</b></small></font>'>
																							<cfset cb_checked = "checked">
																							<cfset non_default_caption_display_style = "inline">
																							<cfset default_caption_display_style = "none">
																							<cfset _input_disabled = "">
																							<cfif (isThisDefaultLayout) AND (NOT CommonCode.isServerLocal())>
																								<cfset cb_checked = "">
																								<cfset _input_disabled = "disabled">
																								<cfset non_default_caption_display_style = "none">
																								<cfset default_caption_display_style = "inline">
																							</cfif>
																							<input type="checkbox" name="_editable_layout_change_name" value="True" #_input_disabled# #cb_checked# #_tooltips_# #_text_style_symbol# title="#_cb_title#">&nbsp;<span id="non_default_caption#_disp_tabNum#" style="display: #non_default_caption_display_style#">#_cb_caption#</span><span id="default_caption#_disp_tabNum#" style="display: #default_caption_display_style#">#_cb_caption2#</span>
																						</div>
																						<div id="fake_editable_layout_change_name#_disp_tabNum#" style="display: none;">
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("fak_editable_layout_change_name#_disp_tabNum#")>
																							<cfset _cb_caption = '<font id="_menu_item_editor_internal_font" size="1"><small><b>Change Layout Name</b></small></font>'>
																							<input type="checkbox" #_input_disabled# #_tooltips_# #_text_style_symbol# title="#_cb_title#">&nbsp;#_cb_caption#
																						</div>
																					</td>
																				</tr>
																			</table>
																			<table width="100%" cellpadding="-1" cellspacing="-1" id="table_comments_layout_spec#_disp_tabNum#" style="display: none;">
																				<tr>
																					<td>
																						<font size="1"><small><b>Comments: (Enter your comments below. Comments are non-editable once they have been saved. Comments are associated with the Draft Release and appear in this Release's Comments log.)</b></small></font>
																					</td>
																				</tr>
																			</table>
																		</td>
																	</tr>
																	<tr>
																		<td>
																			<div id="real_editable_layout_spec#_disp_tabNum#" style="display: inline;">
																				<cfset _input_readonly = "">
																				<cfif ( (isThisDefaultLayout) AND (NOT CommonCode.isServerLocal()) ) OR (Len(Trim(_global_button_disable)) neq 0)>
																					<cfset _input_readonly = "readonly">
																				</cfif>
																				<textarea cols="100" rows="20" #_input_readonly# name="_editable_layout_spec" id="_editable_layout_spec#_disp_tabNum#" #_text_style_symbol# wrap="off"></textarea>
																			</div>
																			<div id="fake_editable_layout_spec#_disp_tabNum#" style="display: none;">
																				<textarea cols="100" rows="20" id="fak_editable_layout_spec#_disp_tabNum#" #_text_style_symbol# wrap="off"></textarea>
																			</div>
																			<div id="comments_editable_layout_spec#_disp_tabNum#" style="display: none;">
																				<textarea cols="100" rows="20" name="_comments" id="_comments_layout_spec#_disp_tabNum#" #_text_style_symbol# wrap="soft" onfocus="processCommentsGotFocus(); return true;"></textarea>
																			</div>
																		</td>
																	</tr>
																	<tr>
																		<td height="40px">
																			<table width="100%" cellpadding="-1" cellspacing="-1">
																				<tr>
																					<td width="50%" align="left">
																						<input type="hidden" name="_num" value="#_disp_tabNum#">
																						<cfset _rid = -1>
																						<cfif (IsDefined("GetCurrentContent.rid"))>
																							<cfset _rid = GetCurrentContent.rid>
																						</cfif>
																						<input type="hidden" name="_rid" value="#_rid#">
																						<input type="hidden" name="_layout_id" value="#GetDefaultLayoutList.id#">
																						<input type="hidden" name="_submit_" value="#layoutSaveAction_symbol#">
																						<!--- BEGIN: User's CANNOT edit the default but they can save a new one based on it --->
																						<cfset _button_title = "This button is generally used to Save this Layout Spec as the Same Layout Spec being edited; this would be an Update operation however this button is now disabled because it is not possible to change the Default Layout Spec but you may save this Layout Spec as a New Layout Spec and then change the New Layout Spec.#_global_button_disable_msg#">
																						<cfset _button_disabled = "disabled">
																						<cfif (NOT isThisDefaultLayout) OR (CommonCode.isServerLocal())>
																							<cfset _button_disabled = _global_button_disable>
																							<cfset _button_title = "Click this button to Save this Layout Spec as the Same Layout Spec being edited.  This is an Update operation.#_global_button_disable_msg#">
																						</cfif>
																						<!--- END! User's CANNOT edit the default but they can save a new one based on it --->

																						<div id="comments_button#_disp_tabNum#" style="display: none;">
																							<cfset _comments_button_title = "This button is generally used to Save this Layout Spec as the Same Layout Spec being edited; this would be an Update operation however this button is now disabled because it is not possible to change the Default Layout Spec but you may save this Layout Spec as a New Layout Spec and then change the New Layout Spec.">
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("button_layoutSaveCommentsAction#_disp_tabNum#")>
																							<input type="button" name="submitCommentsButton#_disp_tabNum#" #_button_disabled# #_tooltips_# #_text_style_symbol# value="#layoutSaveCommentsAction_symbol#" title="#_comments_button_title#" onclick="var obj = getGUIObjectInstanceById('_comments_layout_spec#_disp_tabNum#'); if (isObjValidHTMLValueHolder(obj)) { if (obj.value.trim().length > 0) { processShowCommentsDialog(#_disp_tabNum#, false); processSaveNewLayoutPrep(null, #_disp_tabNum#); return suppress_button_double_click2(this, this.form.cancelButton#_disp_tabNum#, this.form); } } showErrorMessage('user_notices1', false); return showErrorMessage('_errorMessage1', true);" ondblclick="return false;"> <!--- +++ --->
																						</div>

																						<div id="save_button#_disp_tabNum#" style="display: inline;">
																							<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("button_layoutSaveLayoutAction#_disp_tabNum#")>
																							<input type="button" name="submitButton#_disp_tabNum#" #_button_disabled# #_tooltips_# #_text_style_symbol# value="#layoutSaveLayoutAction_symbol#" title="#_button_title#" onclick="processShowCommentsDialog(#_disp_tabNum#, true); return false;" ondblclick="return false;">
																						</div>
																					</td>
																					<td width="50%" align="right" style="display: none;">
																						<cfset _button_disabled = "">
																						<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("button_layoutSaveNewLayoutAction#_disp_tabNum#")>
																						<input type="button" name="submitButton2#_disp_tabNum#" #_button_disabled# #_tooltips_# #_text_style_symbol# value="#layoutSaveNewLayoutAction_symbol#" title="Click this button to Save this Layout Spec as a New Layout Spec.  Layout Specs CANNOT be removed from the database.  Layout Specs must be visible to all Releases that may reference them however the Layout Spec is NOT stored within the Release to which it is associated." onclick="processSaveNewLayoutPrep(-1, #_disp_tabNum#); return suppress_button_double_click2(this, this.form.cancelButton#_disp_tabNum#, this.form);" ondblclick="return false;">
																					</td>
																				</tr>
																				<tr>
																					<td align="center" colspan="2" id="td_editable_layout_spec_cancel#_disp_tabNum#" style="display: inline;">
																						<input type="button" name="cancelButton#_disp_tabNum#" id="cancelPopUp#_disp_tabNum#" title="Click this button to Cancel this operation." value="#_cancelButton_symbol#" #_text_style_symbol# onClick="init_stack_cancel_button_operations(); return processCancelThisLayoutSpecEdit(#_disp_tabNum#, 'button_layoutEditItAction#_disp_tabNum#', '#layoutEditItAction_symbol#');" ondblclick="return false;">
																					</td>
																					<td align="center" colspan="2" id="td_comments_layout_spec_cancel#_disp_tabNum#" style="display: none;">
																						<input type="button" name="cancelButton#_disp_tabNum#" id="cancelPopUp#_disp_tabNum#" title="Click this button to Cancel this operation." value="#_cancelButton_symbol#" #_text_style_symbol# onClick="return processShowCommentsDialog(#_disp_tabNum#, false);" ondblclick="return false;">
																					</td>
																				</tr>
																			</table>
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
							</div>
							<cfset _disp_tabNum = IncrementValue(_disp_tabNum)>
						</cfloop>
						<!--- BEGIN: This code was here to keep users from using the Layout subsystem when there was NO Draft --->
						<cfif 0>
							<div id="content#_disp_tabNum#" class="content" style="display: none;">
								<font size="2"><b>At times like this, when there is NO Draft Release available it is not possible to edit or manipulate Site Layouts because it is only meaningful to edit or manipulate Site Layouts when the Draft Release is available.  Please coordinate with the user(s) who have access to the /Release SubSystem to have the Draft Release made available.</b></font>
							</div>
						</cfif>
						<!--- END! This code was here to keep users from using the Layout subsystem when there was NO Draft --->
					</div>
				</div>
				#RepeatString("<BR>", 25)#

				<cfif (CommonCode.isServerLocal()) AND 0>
					<br><br>
					bool_missing_draft_condition = [#bool_missing_draft_condition#], CommonCode.isServerLocal() = [#CommonCode.isServerLocal()#] (Default Layout editing rules have been relaxed for ease of development.)
				</cfif>
			</td>
		</tr>
		<tr>
			<td bgcolor="##c0c0c0">
				<hr width="100%" size="1" color="##0000FF">
			</td>
		</tr>
	</table>

	<div id="div_usage_key" style="display: none; position: absolute; top: 95px; left: 550px; z-index: 9999">
		<table width="400px" bgcolor="##FFFFBF" cellpadding="-1" cellspacing="-1">
			<tr>
				<td width="100%" align="right">
					<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("_closeUsageKeyLayout")>
					<input type="button" #_tooltips_# #_text_style_symbol# value="#_closeUsageKeyAction_symbol#" title="Close the Usage Key." style="display: inline;" onclick="this.disabled = true; processClickOpenUsageKeyLink(false); this.disabled = false; return false;" ondblclick="return false;">
				</td>
			</tr>
			<tr>
				<td valign="top" align="left">
					<table width="400px" bgcolor="##FFFFBF" #_text_style_symbol# border="0" bordercolor="##000000" cellpadding="1" cellspacing="1">
						<tr>
							<td valign="top" align="left">
								<UL #_text_style_symbol#>
									<LI>Usage Key:
										<UL>
											<LI>(Header)
												<UL>
													<LI>The Header consists of the Site Banner content which generally has some kind of graphic or image that depicts what the site is about.</LI>
												</UL>
											</LI>
											<LI>(Marquee)
												<UL>
													<LI>The Marquee Announcements consists of a scrolling area that displays Headlines or Articles for Announcements that may be displayed for certain date/time ranges.</LI>
												</UL>
											</LI>
											<LI>(Menu Bar)
												<UL>
													<LI>The Menu Bar consists of a navigational aid that can help visitors get back to the home page and may contain other useful links to content such as web phone or the like.</LI>
												</UL>
											</LI>
											<LI>(Menu)
												<UL>
													<LI>The Menu consists of the Site Cascading Menu which MUST be placed on the left side of the Layout Spec.  The Menu always opens to the right so it won't appear to function when placed on the right-side of the layout.</LI>
												</UL>
											</LI>
											<LI>(QuickLinks)
												<UL>
													<LI>The QuickLinks consists of a set of links to content users can get to quickly and easily however this content area may contain any useful information.</LI>
												</UL>
											</LI>
											<LI>(Content)
												<UL>
													<LI>The Content consists of the various Content Pages shown one at a time and serves as the central view-port for user defined content.</LI>
												</UL>
											</LI>
											<LI>(Right-Side)
												<UL>
													<LI>The Right-Side consists of an area of content that may be placed anywhere on the layout however typically this area has found itself on the right-side of the Content area.</LI>
												</UL>
											</LI>
											<LI>(Pix)
												<UL>
													<LI>The Rotating Images (aka. Pix) consists of a set of static and unchangable images that appear to be displayed dynamically each time the page is refreshed.</LI>
												</UL>
											</LI>
											<LI>(Footer)
												<UL>
													<LI>The Footer consists of the Company Logo, the Footer Content and the Content TimeStamp that is derived from the Release Management System. The Content TimeStamp may be different for each page of Content that appears in the central Content view-port.</LI>
												</UL>
											</LI>
										</UL>
									</LI>
								</UL>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</cfoutput>

