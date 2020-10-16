<cfoutput>
	<table cellpadding="5" cellspacing="-1">
		<tr>
			<td>
				<span style="display: inline; visibility: hidden;"><a href="" name="positional_delayed_tooltips" id="positional_delayed_tooltips">xxx</a></span>
				<h2><NOBR>#Request._site_name# - Admin</NOBR></h2>
			</td>
			<cfset _button_bgcolor = "">
			<cfif (function eq _htmlMenuEditorAction_symbol) AND (IsDefined("GetEditableContent")) AND (GetEditableContent.recordCount gt 0) AND (GetEditableContent.uid eq VerifyUserSecurity2.uid)>
				<cfset _button_bgcolor = 'bgcolor="red"'>
			</cfif>
			<td id="td_menu_savedata_button" #_button_bgcolor# valign="middle">
				<cfif (Len(_button_bgcolor) gt 0)>
					<br>
					<form action="#CGI.SCRIPT_NAME#" method="post" onSubmit="var okayToProcess = true; var obj = getGUIObjectInstanceById('menu_savedata_button'); var mcObj = getGUIObjectInstanceById('menu_container'); if ( (obj != null) && (mcObj != null) ) { obj.disable; okayToProcess = ProcessMenuSaveToDatabase(mcObj) } return okayToProcess;">
						<input type="hidden" name="menu_container" id="menu_container" value="">
						<input type="hidden" name="menu_color" id="menu_color" value="">
						<input type="hidden" name="menu_text_color" id="menu_text_color" value="">
						<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
						<input type="hidden" name="submit" value="#_htmlMenuCommitAction_symbol#">
						<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("menu_savedata_button")>
						<input type="submit" name="submitButton" #_tooltips_# value="Save Menu Changes#CR#Release Menu Lock" style="font-size: 12px; color: ##DC143C; display: inline;" title="Click this button to Save your changes to the database. You may not be allowed to save your changes to the database unless the ClipBoard is empty.">
						<cfset _tooltips_ = CommonCode.setup_tooltip_handlers("menu_savedata_button2")>
						<input type="submit" name="submitButton" disabled #_tooltips_# value="Cannot Save Menu#CR#Clipboard Not Empty" style="font-size: 10px; color: yellow; display: none;" title="Click this button to Save your changes to the database. You may not be allowed to save your changes to the database unless the ClipBoard is empty.">
					</form>
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		</tr>
	</table>
	<cfif (function eq _menuTableEditorAction_symbol)>
		<h3>Menu Editor [Menu List]</h3>
		<table border="1" cellpadding="-1" cellspacing="-1">
			<tr bgcolor="##c0c0c0">
				<td width="10%" align="center">
					<small><b>Level</b></small>
				</td>
				<td width="30%" align="center">
					<small><b>URL</b></small>
				</td>
				<td width="*" align="center">
					<small><b>Prompt</b></small>
				</td>
				<td width="5%" align="center">
					<small><b>Target</b></small>
				</td>
			</tr>
			<!--- BEGIN: Determine which pages are being linked to in the current Menu, then exclude those from the query --->
			<cfset _notLinkables = CommonCode.getUnlinkables( _menuContent, _baseline_pages_not_linkable, _menuSubMenuURL_symbol, _menuSubMenuEndsURL_symbol, _currentPage_symbol)>
			<!--- END! Determine which pages are being linked to in the current Menu, then exclude those from the query --->

			<cfset _urlParms = "&_menuContent=&_notLinkables=#URLEncodedFormat(_notLinkables)#&currentPage=#URLEncodedFormat(currentPage)#&_object=#URLEncodedFormat(_object)#">
			<cfset _urlParms2 = "&_prompt=&_target=&_url=">
			<cfset _urlParms2c = "&_prompt=&_target=&_url=#URLEncodedFormat(_menuSubMenuURL_symbol)#">
			<cfset _urlParms2d = "&_prompt=&_target=&_url=#URLEncodedFormat(_menuSubMenuEndsURL_symbol)#">
			
			<cfset _anyAddLinksShown = "False">
			<cfset _subFunc = _editorMenuEditAction_symbol>
			<cfset _menulevel = 1>
			<cfset _itemIndex = 1>
			<cfset _itemIndexMax = ListLen(_menuContent, ",")>
			<cfloop index="_anItem" list="#_menuContent#" delimiters=",">
				<cfif ListLen(_anItem, "|") gt 0>
					<cfset _url = GetToken(_anItem, 1, "|")>
					<cfset _target = GetToken(_anItem, 2, "|")>
					<cfset _prompt = GetToken(_anItem, 3, "|")>

					<cfset _urlParms2a = "&_prompt=#URLEncodedFormat(_prompt)#&_target=#URLEncodedFormat(_target)#&_url=#URLEncodedFormat(_url)#">
					<cfset _urlParms2b = "&_prompt=#URLEncodedFormat(_prompt)#&_target=&_url=#URLEncodedFormat(_url)#">
					<cfset _urlParms3 = "&_itemIndex=#_itemIndex#&_itemIndexMax=#_itemIndexMax#">
					<cfset _bgColor = Trim(commonCode.reportTableRowColor(_itemIndex))>
					<cfset _dropLink = commonCode.makeLink( "#function#@#_editorMenuDropAction_symbol#", "#_urlParms##_urlParms3#", _editorMenuDropAction_symbol)>
					<cfif (_url eq _menuSubMenuURL_symbol)>
						<cfset _menulevel = IncrementValue(_menulevel)>
						<cfset _parms = _urlParms2b>
					<cfelseif (_url eq _menuSubMenuEndsURL_symbol)>
						<cfset _menulevel = DecrementValue(_menulevel)>
						<cfset _parms = _urlParms2b>
					</cfif>
					<cfset _menulevelParms = "&_menulevel=#_menulevel#">
					<cfset _addLink = commonCode.makeLink( "#function#@#_editorMenuAddAction_symbol#", "#_urlParms##_urlParms2##_urlParms3##_menulevelParms#", _editorMenuAddAction_symbol)>
					<tr bgcolor="#_bgColor#">
						<td align="center">
							<table cellpadding="-1" cellspacing="-1">
								<tr>
									<td width="25%" align="left" valign="top">
										<table cellpadding="-1" cellspacing="-1">
											<tr>
												<td valign="top">
													<small>#_dropLink#</small>
												</td>
											</tr>
											<tr>
												<td valign="bottom">
													<small>#_addLink#</small>
												</td>
											</tr>
										</table>
									</td>
									<td width="*" align="center" valign="middle">
										<small>#_menulevel#</small>
									</td>
								</tr>
							</table>
						</td>
						<cfset _alignment = "">
						<cfif (_url eq _menuSubMenuURL_symbol) OR (_url eq _menuSubMenuEndsURL_symbol)>
							<cfset _alignment = ' align="center"'>
						</cfif>
						<td#_alignment#>
							<cfif 0>
								<cfset _editSubMenuContainerLink = commonCode.makeLink( "#function#@#_editorMenuEditSubMenuContainerAction_symbol#", "#_urlParms##_urlParms2##_urlParms3#", "")>
							<cfelseif (_url eq _menuSubMenuEndsURL_symbol)>
								<cfset _editSubMenuContainerLink = "<small><i>Close SubMenu Container</i></small>">
							<cfelse>
								<cfset _editSubMenuContainerLink = "<small><i>SubMenu Container</i></small>">
							</cfif>
							<cfif (_url eq _menuSubMenuURL_symbol) OR (_url eq _menuSubMenuEndsURL_symbol)>
								<small><b>#_editSubMenuContainerLink#</b></small>
							<cfelseif (_url neq _menuSubMenuEndsURL_symbol)>
								<small><font size="1">#_url#</font></small>
							</cfif>
						</td>
						<td align="left">
							<cfset _parms = _urlParms2a>
							<cfset _editLink = commonCode.makeLink( "#function#@#_subFunc#", "#_urlParms##_parms##_urlParms3#", _prompt)>
							<cfset _addSubMenuLink = commonCode.makeLink( "#function#@#_editorMenuAddSubMenuAction_symbol#", "#_urlParms##_urlParms2c##_urlParms3##_menulevelParms#", _editorMenuAddSubMenuAction_symbol)>
							<small>#_editLink#</small>
							<cfset _anyAddLinksShown = "True">
						</td>
						<td align="center">
							<table cellpadding="-1" cellspacing="-1">
								<tr>
									<td width="*">
										<cfif Len(Trim(_target)) gt 0>
											<small>#_target#</small>
										<cfelse>
											&nbsp;
										</cfif>
									</td>
									<td width="25%">
										<small>#_addSubMenuLink#</small>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<cfset _itemIndex = IncrementValue(_itemIndex)>
				</cfif>
			</cfloop>
			<cfset _urlParms3 = "&_itemIndex=#(_itemIndex - 1)#&_itemIndexMax=#_itemIndexMax#">
			<cfset _addLink = commonCode.makeLink( "#function#@#_editorMenuAddAction_symbol#", "#_urlParms##_urlParms2##_urlParms3#&_menulevel=1", _editorMenuAddAction_symbol)>
			<cfset _addSubMenuLink = commonCode.makeLink( "#function#@#_editorMenuAddSubMenuAction_symbol#", "#_urlParms##_urlParms2c##_urlParms3#&_menulevel=#_menulevel#", _editorMenuAddSubMenuAction_symbol)>
			<cfset _closeSubMenuLink = commonCode.makeLink( "#function#@#_editorMenuAddCloseSubMenuAction_symbol#", "#_urlParms##_urlParms2d##_urlParms3#&_menulevel=#_menulevel#", "[<<]")>
			<tr bgcolor="##c0c0c0">
				<td width="5%" align="center">
					<small>#_menulevel#</small>
					<cfif _menulevel gt 1>
						<small><font size="1">#_closeSubMenuLink#</font></small>
					</cfif>
					<cfif NOT _anyAddLinksShown>
						<small><b>#_addLink#</b></small>|
						<small><b>#_addSubMenuLink#</b></small>
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td width="*" align="center">
					&nbsp;
				</td>
				<td width="40%" align="center">
					&nbsp;
				</td>
				<td width="5%" align="center">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<form action="#CGI.SCRIPT_NAME#" method="post">
						<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
						<input name="cancelPopUp" type="submit" value="#_cancelButton_symbol#">
					</form>
				</td>
			</tr>
		</table>
	<cfelseif (function eq _menuEditorAction_symbol) OR (function eq _menuTableEditorAction_symbol) OR ( ( (GetToken(function, 1, "@") eq _menuEditorAction_symbol) OR (GetToken(function, 1, "@") eq _menuTableEditorAction_symbol) ) AND (GetToken(function, 2, "@") eq _editorMenuEditSubMenuContainerAction_symbol) )>
		<cfset menu_table_symbol = "">
		<cfset menu_object_symbol = _object>
		<cfif (function eq _menuTableEditorAction_symbol) OR (GetToken(function, 1, "@") eq _menuTableEditorAction_symbol)>
			<cfset menu_table_symbol = "Table ">
		</cfif>
		<cfif (GetToken(function, 2, "@") eq _editorMenuEditSubMenuContainerAction_symbol)>
			<cfset menu_object_symbol = "submenu container">
		</cfif>
		<h3>Menu #menu_table_symbol#Editor [#menu_object_symbol#]</h3>
		<table border="1" cellpadding="-1" cellspacing="-1">
			<tr bgcolor="##c0c0c0">
				<td align="left">
					<cfset _urlParms = "&_menuContent=&currentPage=#URLEncodedFormat(currentPage)#&_object=#URLEncodedFormat(_object)#">
					<cfset _urlParms2 = "&_prompt=&_target=&_url=">
					<cfset _addLink = commonCode.makeLink( "#function#@#_editorMenuAddAction_symbol#", "#_urlParms##_urlParms2#", _editorMenuAddAction_symbol)>
					<small><b>#_addLink#</b></small>
				</td>
				<td colspan="3" align="left">
					<cfset _forContainer = "">
					<b>Menu Items#_forContainer#</b>
				</td>
			</tr>
			<tr bgcolor="##c0c0c0">
				<td width="5%">
					<small><b>Actions</b></small>
				</td>
				<td width="*">
					<small><b>URL</b></small>
				</td>
				<td width="40%">
					<small><b>Prompt</b></small>
				</td>
				<td width="5%">
					<small><b>Target</b></small>
				</td>
			</tr>
			<cfset _itemIndex = 1>
			<cfset _itemIndexMax = ListLen(_menuContent, ",")>
			<cfloop index="_anItem" list="#_menuContent#" delimiters=",">
				<cfif ListLen(_anItem, "|") gt 0>
					<cfset _url = GetToken(_anItem, 1, "|")>
					<cfset _target = GetToken(_anItem, 2, "|")>
					<cfset _prompt = GetToken(_anItem, 3, "|")>
					<tr>
						<td>
							<cfset _urlParms2 = "&_prompt=#URLEncodedFormat(_prompt)#&_target=#URLEncodedFormat(_target)#&_url=#URLEncodedFormat(_url)#">
							<cfset _urlParms3 = "&_itemIndex=#_itemIndex#&_itemIndexMax=#_itemIndexMax#">
							<cfset _subFunc = _editorMenuEditAction_symbol>
							<cfif _url eq _menuSubMenuURL_symbol>
								<cfset _subFunc = _editorMenuEditSubMenuAction_symbol>
							</cfif>
							<cfset _editLink = commonCode.makeLink( "#function#@#_subFunc#", "#_urlParms##_urlParms2##_urlParms3#", _editorMenuEditAction_symbol)>
							<cfset _dropLink = commonCode.makeLink( "#function#@#_editorMenuDropAction_symbol#", "#_urlParms##_urlParms3#", _editorMenuDropAction_symbol)>
							<cfset _urlParms2a = "&_prompt=&_target=&_url=">
							<cfset _addSubMenuLink = commonCode.makeLink( "#function#@#_editorMenuAddSubMenuAction_symbol#", "#_urlParms##_urlParms2a##_urlParms3#", _editorMenuAddSubMenuAction_symbol)>
							<small><b>#_editLink#</b></small>|
							<small><b>#_dropLink#</b></small>
							<br>
							<small><b>#_addSubMenuLink#</b></small>
						</td>
						<cfset _alignment = "">
						<cfif _url eq _menuSubMenuURL_symbol>
							<cfset _alignment = ' align="center"'>
						</cfif>
						<td#_alignment#>
							<cfset _editSubMenuContainerLink = commonCode.makeLink( "#function#@#_editorMenuEditSubMenuContainerAction_symbol#", "#_urlParms##_urlParms2a##_urlParms3#", "<small><i>SubMenu Container</i></small>")>
							<cfif _url eq _menuSubMenuURL_symbol>
								<small><b>#_editSubMenuContainerLink#</b></small>
							<cfelse>
								<small>#_url#</small>
							</cfif>
						</td>
						<td>
							<small>#_prompt#</small>
						</td>
						<td>
							<small>#_target#</small>
						</td>
					</tr>
					<cfset _itemIndex = IncrementValue(_itemIndex)>
				</cfif>
			</cfloop>
			<tr>
				<td colspan="4">
					<form action="#CGI.SCRIPT_NAME#" method="post">
						<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
						<input name="cancelPopUp" type="submit" value="#_cancelButton_symbol#">
					</form>
				</td>
			</tr>
		</table>
	<cfelseif ( (GetToken(function, 1, "@") eq _menuEditorAction_symbol) OR (GetToken(function, 1, "@") eq _menuTableEditorAction_symbol) ) AND ( ( (GetToken(function, 2, "@") eq _editorMenuAddAction_symbol) AND (Len(submitButton) eq 0) ) OR ( (GetToken(function, 2, "@") eq _editorMenuEditAction_symbol) AND (Len(submitButton) eq 0) ) OR ( (GetToken(function, 2, "@") eq _editorMenuAddSubMenuAction_symbol) AND (Len(submitButton) eq 0) ) OR (GetToken(function, 2, "@") eq _editorMenuEditSubMenuAction_symbol))>
		<cfset menu_table_symbol = "">
		<cfset menu_object_symbol = _object>
		<cfif (function eq _menuTableEditorAction_symbol) OR (GetToken(function, 1, "@") eq _menuTableEditorAction_symbol)>
			<cfset menu_table_symbol = "Table ">
		</cfif>
		<cfif (GetToken(function, 2, "@") eq _editorMenuAddSubMenuAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuEditSubMenuContainerAction_symbol)>
			<cfset menu_object_symbol = "submenu container">
		</cfif>
		<h3>Menu #menu_table_symbol#Editor <small>[#menu_object_symbol#]</small></h3>
		<table>
			<form action="#CGI.SCRIPT_NAME#" method="post">
				<cfset _displayableFunction = GetToken(function, 2, "@")>
				<cfif Len(_displayableFunction) eq 0>
					<cfset _displayableFunction = function>
				</cfif>
				<input name="_menuContent" type="hidden" value="">
				<input name="_object" type="hidden" value="#_object#">
				<input name="currentPage" type="hidden" value="#currentPage#">
				<cfif IsDefined("_itemIndex")>
					<input name="_itemIndex" type="hidden" value="#_itemIndex#">
				</cfif>
				<cfif IsDefined("_itemIndexMax")>
					<input name="_itemIndexMax" type="hidden" value="#_itemIndexMax#">
				</cfif>
				<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
				<input name="function" type="hidden" value="#function#">
				<cfset _aStyle = 'style="display: none;"'>
				<tr valign="top">
					<td <cfif _adminMethod eq _adminMethod_nopopups><cfelse>colspan="2"</cfif>>
						<small>Prompt:</small>&nbsp;<input type="text" name="_prompt" value="#_prompt#" size="50" maxlength="50"><br>
						<cfif (_url neq _menuSubMenuURL_symbol) OR (FindNoCase(_currentPage_symbol, _url) gt 0)>
							<cfif IsDefined("GetEditableContent")>
								<cfset _curPage = CommonCode.getCurrentPageFromURL( _url, _currentPage_symbol)>
								<cfif Len(_curPage) eq 0>
									<cfset _aStyle = 'style="display: inline;"'>
								</cfif>
								<cfif (GetEditableContent.recordCount gt 0)>
									<select name="_linkage" style="font-size: 10px;" onFocus="hideShow(this.form)" onBlur="hideShow(this.form)" onChange="hideShow(this.form)">
										<option value="" <cfif Len(_curPage) eq 0>SELECTED</cfif>>External URL (enter it below)</option>
										<cfset _my_pageName = "">
										<cfloop query="GetEditableContent" startrow="1" endrow="#GetEditableContent.recordCount#">
											<cfif _my_pageName neq GetEditableContent.pageName>
												<cfset _my_pageName = GetEditableContent.pageName>
												<option value="#_my_pageName#|#GetEditableContent.PageTitle#" <cfif UCASE(_curPage) eq UCASE(_my_pageName)>SELECTED</cfif>>#GetEditableContent.PageTitle#</option>
											</cfif>
										</cfloop>
									</select>
								<cfelse>
									<!--- users must be able to view but not edit the URL even if this is an internal link --->
									<cfif Len(_curPage) neq 0>
										<cfset _aStyle = 'style="display: inline;" disabled readonly'>
										<input name="_linkage" type="hidden" value="#_curPage#|.">
									<cfelse>
										<select name="_linkage" style="font-size: 10px;">
											<option value="" <cfif Len(_curPage) eq 0>SELECTED</cfif>>External URL (enter it below)</option>
										</select>
									</cfif>
								</cfif>
							<cfelse>
								<small>Target:</small>&nbsp;<input type="text" name="_target" value="#_target#" size="15" maxlength="50"><br>
							</cfif>
							<cfif (Len(_url) eq 0)>
								<cfset _url = "http://">
							</cfif>
							<div id="_url_text" #_aStyle#><small>Url:</small></div>&nbsp;<textarea #_aStyle# cols="50" rows="2" name="_url" wrap="soft">#_url#</textarea><br> <!---  class="onLoad" onMouseOver="this.className='onMouseOver'" onMouseOut="this.className='onMouseOut'" --->
						<cfelse>
							<!--- SubMenu's are identified to the system as the following differences from MenuItems... --->
							<input name="_target" type="hidden" value=" ">
							<input name="_url" type="hidden" value="#_menuSubMenuURL_symbol#">
						</cfif>
					</td>
				</tr>
				<tr valign="top">
					<td <cfif _adminMethod eq _adminMethod_nopopups><cfelse>colspan="2"</cfif>>
						<cfset _urlParms = "&_menuContent=&currentPage=#URLEncodedFormat(currentPage)#&_object=#URLEncodedFormat(_object)#&_prompt=&_target=&_url=">
						<input name="submitButton" type="submit" value="Save [#_object#]">&nbsp;
						<cfset _func = GetToken(function, 1, "@")>
						<cfset _aURL = "#CGI.SCRIPT_NAME#?function=#URLEncodedFormat(_func)##Request.next_splashscreen_inhibitor##_urlParms#">
						<cfif (Len(_redir) gt 0)>
							<cfset _aURL = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">
						</cfif>
						<input name="_redir" type="hidden" value="#_redir#">
						<input type="button" name="cancelButton" value="#_cancelButton_symbol#" onClick="window.location.href = '#_aURL##Request.first_splashscreen_inhibitor#';">
					</td>
				</tr>
			</form>
		</table>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			setFocusSafelyById("_prompt");
		-->
		</script>
	<cfelseif ( (GetToken(function, 1, "@") eq _menuEditorAction_symbol) OR (GetToken(function, 1, "@") eq _menuTableEditorAction_symbol) ) AND (GetToken(function, 2, "@") eq _editorMenuDropAction_symbol)>
		<cfset _listMax = ListLen(_menuContent, ",")>
		<cfif (_itemIndex gt 0) AND (_itemIndex lte _listMax)>
			<cfset _aMenuItem = ListGetAt(_menuContent, _itemIndex, ",")>
			<cfif (GetToken(_aMenuItem, 1, "|") eq _menuSubMenuURL_symbol)>
				<!--- BEGIN: Remove all items for this submenu container from _itemIndex to end of container (inclusive) --->
				<cfloop index="_k" from="#_itemIndex#" to="#_listMax#">
					<cfset _aMenuEndItem = ListGetAt(_menuContent, _k, ",")>
					<cfif (GetToken(_aMenuEndItem, 1, "|") eq _menuSubMenuEndsURL_symbol)>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfloop index="_kk" from="#_k#" to="#_itemIndex#" step="-1">
					<!--- Items are dropped at a specific index within the list because the list will compress towards this index as items are dropped from the list --->
					<cfset _menuContent = ListDeleteAt(_menuContent, _itemIndex, ",")>
				</cfloop>
				<!--- END! Remove all items for this submenu container from _itemIndex to end of container (inclusive) --->
			<cfelse>
				<cfset _menuContent = ListDeleteAt(_menuContent, _itemIndex, ",")>
			</cfif>
		</cfif>
		
		<cfset _urlParms = "&_menuContent=&currentPage=#URLEncodedFormat(currentPage)#&_object=#URLEncodedFormat(_object)#">
		<cfset _func = GetToken(function, 1, "@")>

		<cfset _menuContent = Replace(_menuContent, "'", "''", "all")>
		<cfset _SQL_statement = CommonCode.sql_getCurrentRelease_rid( _adminMode, _ReleaseManagement)>
		<cfset _aSQLStatement = CommonCode.sql_saveSiteMenu( _menuContent, _DynamicPageManagement, _DynamicHTMLmenu)>
		<cfset _SQL_statement = "#_SQL_statement##CR##_aSQLStatement#">

		<cfif Len(_SQL_statement) gt 0>
			<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="SaveEditableMenu" datasource="#DSNSource#">
				#PreserveSingleQuotes(_SQL_statement)#
			</cfquery>
		</cfif>

<cfif 1>
		<cfset _aURL = "#CGI.SCRIPT_NAME#?function=#URLEncodedFormat(_func)##_urlParms##Request.next_splashscreen_inhibitor#">
		<cfif (Len(_redir) gt 0)>
			<cfset _aURL = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">
		</cfif>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			window.location.href = '#_aURL##Request.first_splashscreen_inhibitor#';
		-->
		</script>
</cfif>
	<cfelseif ( (GetToken(function, 1, "@") eq _menuEditorAction_symbol) OR (GetToken(function, 1, "@") eq _menuTableEditorAction_symbol) ) AND ( (GetToken(function, 2, "@") eq _editorMenuAddAction_symbol) AND (Len(submitButton) gt 0 ) OR (GetToken(function, 2, "@") eq _editorMenuEditAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuAddSubMenuAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuEditSubMenuAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuAddCloseSubMenuAction_symbol) )>
		<cfif Len(_target) eq 0>
			<!--- BEGIN: space-pad to allow this code to function --->
			<cfset _target = "#_target# ">
			<!--- END! space-pad to allow this code to function --->
		</cfif>
		<cfset _prompt = CommonCode.filterListDelims(_prompt)>
		<cfif Len(_prompt) eq 0>
			<!--- BEGIN: space-pad to allow this code to function --->
			<cfset _prompt = "#_prompt# ">
			<!--- END! space-pad to allow this code to function --->
		<cfelseif (_url eq _menuSubMenuURL_symbol) AND (Find("...", _prompt) eq 0)>
			<!--- BEGIN: ... for subMenus --->
			<cfset _prompt = "#_prompt#...">
			<!--- END! ... for subMenus --->
		</cfif>
		<cfif Len(_url) eq 0>
			<!--- BEGIN: space-pad to allow this code to function --->
			<cfset _url = "#_url# ">
			<!--- END! space-pad to allow this code to function --->
		</cfif>
		<cfif Len(_linkage) eq 0>
			<!--- do external link --->
			<cfset _target = "_blank">
		<cfelseif (_url neq _menuSubMenuURL_symbol) AND (_url neq _menuSubMenuEndsURL_symbol)>
			<!--- do internal link --->
			<cfset _aPageName = GetToken(_linkage, 1, "|")>
			<cfset _aPageTitle = GetToken(_linkage, 2, "|")>
			<cfset this_url_prefix = ReplaceNoCase(CGI.SCRIPT_NAME, _adminURLPrefix_symbol, "/")>
			<cfset _url = "#this_url_prefix##_currentPage_symbol##_aPageName#">
		</cfif>
		<!--- do a sanity check to determine if the link is really off-site --->
		<cfset _curPage = CommonCode.getCurrentPageFromURL( _url, _currentPage_symbol)>
		<cfif Len(_curPage) neq 0>
			<cfset _target = " "> <!--- the " " is a place-holder that gets removed later on... --->
		</cfif>
		<cfset _newMenuItem = "#_url#|#_target#|#_prompt#">
		<cfif (Len(_redir) gt 0) AND (_url eq _menuSubMenuURL_symbol)>
			<!--- BEGIN: Here we want to automatically drop in a placeholder and the ending container symbol --->
			<cfset _placeholderMenuItem = ".| |Placeholder">
			<cfset _newMenuItem = ListAppend(_newMenuItem, _placeholderMenuItem, ",")>
			<cfset _endSubMenuItem = "#_menuSubMenuEndsURL_symbol#| | ">
			<cfset _newMenuItem = ListAppend(_newMenuItem, _endSubMenuItem, ",")>
			<!--- END! Here we want to automatically drop in a placeholder and the ending container symbol --->
		</cfif>
		<cfif (GetToken(function, 2, "@") eq _editorMenuAddAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuAddSubMenuAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuAddCloseSubMenuAction_symbol)>
			<cfset _doAppend = "False">
			<cfif IsDefined("_itemIndex") AND IsDefined("_itemIndexMax") AND (_itemIndex eq _itemIndexMax)>
				<cfset _doAppend = "True">
			</cfif>
			<cfif _doAppend>
				<cfset _menuContent = ListAppend(_menuContent, _newMenuItem, ",")>
			<cfelse>
				<cfset _itemOffset = 0>
				<cfif _itemIndex eq 1>
					<cfset _itemIndex = 2>
				<cfelse>
					<cfset _itemOffset = 1>
				</cfif>
				<cfset _menuContent = ListInsertAt(_menuContent, _itemIndex + _itemOffset, _newMenuItem, ",")>
			</cfif>
		<cfelseif (GetToken(function, 2, "@") eq _editorMenuEditAction_symbol) OR (GetToken(function, 2, "@") eq _editorMenuEditSubMenuAction_symbol)>
			<cfset _menuContent = ListSetAt(_menuContent, _itemIndex, _newMenuItem, ",")>
		</cfif>
		<cfset _urlParms = "&_menuContent=&currentPage=#URLEncodedFormat(currentPage)#&_object=#URLEncodedFormat(_object)#">
		<cfset _func = GetToken(function, 1, "@")>
	
		<cfif Len(_menuContent) gt 0>
			<cfset _menuContent = Replace(_menuContent, "'", "''", "all")>
			<cfset _SQL_statement = CommonCode.sql_getCurrentRelease_rid( _adminMode, _ReleaseManagement)>
			<cfset _aSQLStatement = CommonCode.sql_saveSiteMenu( _menuContent, _DynamicPageManagement, _DynamicHTMLmenu)>
			<cfset _SQL_statement = "#_SQL_statement##CR##_aSQLStatement#">
		</cfif>

		<cfif Len(_SQL_statement) gt 0>
			<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="SaveEditableMenu" datasource="#DSNSource#">
				#PreserveSingleQuotes(_SQL_statement)#
			</cfquery>
		</cfif>

		<cfif 1>
			<cfset _delayed_window_location_href = "#CGI.SCRIPT_NAME#?function=#URLEncodedFormat(_func)##_urlParms##Request.next_splashscreen_inhibitor#">
			<cfif (Len(_redir) gt 0)>
				<cfset _delayed_window_location_href = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">
			</cfif>
			<cfoutput>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					window.location.href = '#_delayed_window_location_href##Request.first_splashscreen_inhibitor#';
				-->
				</script>
			</cfoutput>
		</cfif>
	<cfelseif (GetToken(function, 1, "@") eq _menuTableEditorAction_symbol) AND ( (GetToken(function, 2, "@") eq _reorganizeMenuDnAction_symbol) OR (GetToken(function, 2, "@") eq _reorganizeMenuUpAction_symbol) OR (GetToken(function, 2, "@") eq _reorganizeSubMenuDnAction_symbol) OR (GetToken(function, 2, "@") eq _reorganizeSubMenuUpAction_symbol) )>
		<cfset _listMax = ListLen(_menuContent, ",")>
		<cfif (_itemIndex gt 0) AND (_itemIndex lte _listMax)>
			<!--- First delete the item being pointed to... --->
			<cfif (GetToken(function, 2, "@") eq _reorganizeSubMenuDnAction_symbol) OR (GetToken(function, 2, "@") eq _reorganizeSubMenuUpAction_symbol)>
				<!--- BEGIN: Remove all items for this submenu container from _itemIndex to end of container (inclusive) --->
				<cfset _aMenuItem = "">
				<cfloop index="_k" from="#_itemIndex#" to="#_listMax#">
					<cfset _aMenuEndItem = ListGetAt(_menuContent, _k, ",")>
					<cfset _aMenuItem = ListAppend(_aMenuItem, _aMenuEndItem, ",")>
					<cfif (GetToken(_aMenuEndItem, 1, "|") eq _menuSubMenuEndsURL_symbol)>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfloop index="_kk" from="#_k#" to="#_itemIndex#" step="-1">
					<!--- Items are dropped at a specific index within the list because the list will compress towards this index as items are dropped from the list --->
					<cfset _menuContent = ListDeleteAt(_menuContent, _itemIndex, ",")>
				</cfloop>
				<!--- END! Remove all items for this submenu container from _itemIndex to end of container (inclusive) --->
			<cfelse>
				<cfset _aMenuItem = ListGetAt(_menuContent, _itemIndex, ",")>
				<cfset _menuContent = ListDeleteAt(_menuContent, _itemIndex, ",")>
			</cfif>
			<!--- Then insert the item being pointed to in the next slot... --->
			<cfset _itemOffset = 1>
			<cfif (GetToken(function, 2, "@") eq _reorganizeMenuUpAction_symbol) OR (GetToken(function, 2, "@") eq _reorganizeSubMenuUpAction_symbol)>
				<cfset _itemOffset = -1>
			</cfif>
			<cfset _menuContent = ListInsertAt(_menuContent, _itemIndex + _itemOffset, _aMenuItem, ",")>
		</cfif>
		
		<cfset _urlParms = "&_menuContent=&currentPage=#URLEncodedFormat(currentPage)#&_object=#URLEncodedFormat(_object)#">
		<cfset _func = GetToken(function, 1, "@")>

		<cfset _menuContent = Replace(_menuContent, "'", "''", "all")>
		<cfset _SQL_statement = CommonCode.sql_getCurrentRelease_rid( _adminMode, _ReleaseManagement)>
		<cfset _aSQLStatement = CommonCode.sql_saveSiteMenu( _menuContent, _DynamicPageManagement, _DynamicHTMLmenu)>
		<cfset _SQL_statement = "#_SQL_statement##CR##_aSQLStatement#">

		<cfif Len(_SQL_statement) gt 0>
			<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="SaveEditableMenu" datasource="#DSNSource#">
				#PreserveSingleQuotes(_SQL_statement)#
			</cfquery>
		</cfif>

		<cfif 1>
			<cfset _aURL = "#CGI.SCRIPT_NAME#?function=#URLEncodedFormat(_func)##_urlParms##Request.next_splashscreen_inhibitor#">
			<cfif (Len(_redir) gt 0)>
				<cfset _aURL = "#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">
			</cfif>
			<script language="JavaScript1.2" type="text/javascript">
			<!--
				window.location.href = '#_aURL##Request.first_splashscreen_inhibitor#';
			-->
			</script>
		</cfif>
	<cfelseif (function eq _htmlMenuEditorAction_symbol)>
		<!--- BEGIN: This block of code only executes when running on the localhost server (not sure why this is needed ?!?) --->
		<cfif (ListLen(GetEditableContent.columnList, ",") eq 0) AND (CommonCode.isServerLocal())>
			<cflocation url="#CGI.SCRIPT_NAME#?function=#URLEncodedFormat(function)##Request.next_splashscreen_inhibitor#" addtoken="No">
		</cfif>
		<!--- END! This block of code only executes when running on the localhost server (not sure why this is needed ?!?) --->
		<cfif (IsDefined("GetEditableContent")) AND (GetEditableContent.recordCount gt 0) AND (GetEditableContent.uid eq VerifyUserSecurity2.uid)>
			<div id="welcome">
				<span style="display: inline; visibility: hidden;"><a href="" name="positional_delayed_tooltips2" id="positional_delayed_tooltips2">xxx</a></span>
				<p align="justify" style="font-size: 10px; line-height: 10px;">
				This is the Menu Editor.  The Menu Editor shows you the Site Menu to the left without links so you can see what the Menu looks like as you are making changes to the Menu using the interface you see below. In case you make a mistake during your menu editing session and you wish to start-over you may either click the refresh browser button or the site menu bar to refresh this page. The database is not updated until you click the silver button that has red text that says "Save Menu Changes / Release Menu Lock".
				</p>
			</div>
			<div id="menu_editor_pane">
				<table cellpadding="-1" cellspacing="-1">
					<tr>
						<td width="100%" align="right" valign="top">
							<span style="display: inline; visibility: hidden;"><A HREF="" NAME="ColorPicker" ID="ColorPicker">xxx</A></span>
							<span style="display: inline; visibility: hidden;"><A HREF="" NAME="ColorPicker2" ID="ColorPicker2">xxx</A></span>
						</td>
					</tr>
					<tr>
						<td width="50%" align="right" valign="top">
							<table cellpadding="-1" cellspacing="-1">
								<tr>
									<td>
										<div id="_menu_item_editor" style="display: none;">
										</div>
									</td>
									<td>
										<table cellpadding="-1" cellspacing="-1">
											<tr>
												<td>
													<div id="_menu_item_editor_button" style="display: inline;">
														<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("edit_menu_item", "positional_delayed_tooltips")>
														<input type="button" #_tooltips_# value="Edit Menu Item" disabled style="font-size: 9px;" title="Click this button to edit or modify the menu item that is highlighted in the list to the right of this button.  Menu Items differ from SubMenu Items in that a Menu Item is an individual item that appears on the Menu and a SubMenu Item is a collection of Menu Items.  You may Open a SubMenu to Edit the individual Menu Items by double-clicking the SubMenu or by clicking the appropriate button that appears below the list to the right of this button. SubMenu Items are displayed the same as Menu Items except the SubMenu Item appears enclosed by parenthesis." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuItemEditor(brObj) } return false;">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													&nbsp;
												</td>
											</tr>
											<tr>
												<td>
													<div id="_menu_item_additor_button" style="display: inline;">
														<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("addit_menu_item", "positional_delayed_tooltips2")>
														<input type="button" #_tooltips_# value="Add Menu Item" style="font-size: 9px;" title="Click this button to add a menu item.  Menu items are used to link to internal pages of content or to external documents such as Panagons docs or to external sites.  Menu items are different than SubMenu Items in that a Menu Item provides a single link to something whereas a SubMenu provides a container for a number of Menu Items." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuItemAdditor(brObj) } return false;">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													&nbsp;
												</td>
											</tr>
											<tr>
												<td>
													<div id="_menu_submenu_additor_button" style="display: inline;">
														<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("addit_menu_submenu", "positional_delayed_tooltips2")>
														<input type="button" #_tooltips_# value="Add Empty#CR#SubMenu" style="font-size: 9px;" title="Click this button to add a SubMenu Item.  SubMenu Items may contain one or more Menu Items and are used to extend the menu horizontally whereas Menu Items extend the Menu vertically." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuSubMenuAdditor(brObj) } return false;">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													&nbsp;
												</td>
											</tr>
											<tr>
												<td id="hilite_color_preview" bgcolor="#_site_menu_background_color#">
													<div id="_menu_colors_button" style="display: inline;">
														<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("change_menu_colors", "positional_delayed_tooltips2")>
														<input type="button" #_tooltips_# value="Menu Color" style="font-size: 9px;" title="Click this button to change the menu's background color.  This is the color of the menu and not the text color." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuChangeColors(brObj) } return false;">
														<input type="hidden" id="hilite_color" value="#_site_menu_background_color#">
													</div>
												</td>
											</tr>
											<tr>
												<td>
													&nbsp;
												</td>
											</tr>
											<tr>
												<td id="hilite_color_preview2" bgcolor="#_site_menu_text_color#">
													<div id="_menu_colors_button2" style="display: inline;">
														<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("change_menu_colors2", "positional_delayed_tooltips2")>
														<input type="button" #_tooltips_# value="Menu#Cr#Text Color" style="font-size: 9px;" title="Click this button to change the menu's text color.  This is the color of the text and not the menu color." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuChangeTextColors(brObj) } return false;">
														<input type="hidden" id="hilite_color2" value="#_site_menu_text_color#">
													</div>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
						<td width="50%" valign="top" align="right">
							<table cellpadding="-1" cellspacing="-1">
								<tr>
									<td align="center" valign="top">
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td>
													<div id="div_menu_browser" style="display: inline;"></div>
													<div id="_div_menu_browser" style="display: inline;">
														<script language="JavaScript" type="text/javascript">
														<!--
															function ColorPicker_pickedColor( color) {
																if (pressed_color_button_flag == 0) {
																	modifyMenuColors(color);
																	setCookie("ColorPicker", color, "/");
																} else if (pressed_color_button_flag == 1) {
																	modifyMenuTextColors(color);
																	setCookie("ColorPicker2", color, "/");
																}
															}
															
															function ColorPicker_dismissed( bool) {
																while (_stack_hilite_color_preview.length > 0) {
																	var a = _stack_hilite_color_preview.pop();
																	if (a != null) {
																		var _bgColor = a.pop();
																		var _id = a.pop();
																		if (_id != null) {
																			var hcpObj = getGUIObjectInstanceById(_id);
																			if (hcpObj != null) {
																				hcpObj.bgColor = _bgColor;
																			}
																		}
																	}
																}
															}
															
															var cp = new ColorPicker("colorPickerDiv", false, 18, false, false);
															// var cp = new ColorPicker("", true, 18, false);
															if (cp != null) {
																cp.writeDiv();
																var obj = getGUIObjectInstanceById('hilite_color_preview');
																if (obj != null) {
																	var bgColor = getCookie("ColorPicker");
																	if (bgColor != null) {
																		obj.bgColor = bgColor;
																	}
																}
																var obj = getGUIObjectInstanceById('hilite_color_preview2');
																if (obj != null) {
																	var bgColor = getCookie("ColorPicker2");
																	if (bgColor != null) {
																		obj.bgColor = bgColor;
																	}
																}
																ColorPicker_register_dismiss_function(ColorPicker_dismissed);
																register_onload_function('modifyMenuColorsFromPreviewById("hilite_color_preview"); modifyMenuTextColorsFromPreviewById("hilite_color_preview2");');
															} else {
																// alert('ColorPicker() failed !');
															}
														-->
														</script>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<table width="100%" cellpadding="-1" cellspacing="-1">
														<tr>
															<td width="50%" align="left">
																<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("menu_browse_into", "positional_delayed_tooltips3")>
																<input type="button" #_tooltips_# value="Open#CR#Sub Menu" disabled style="font-size: 9px;" title="Click this button to Open a SubMenu, the SubMenu that is highlighted in the list directly above this button.  The other way to Open a SubMenu is to double-click the SubMenu item." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuBrowseInto(brObj) } return false;">
															</td>
															<td width="50%" align="right">
																<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("menu_browse_out", "positional_delayed_tooltips3")>
																<input type="button" #_tooltips_# id="menu_browse_out" value="Close#CR#Sub Menu" disabled style="font-size: 9px;" title="Click this button to Close a SubMenu that was previously opened." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuBrowseOut(brObj) } return false;">
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
									<td align="center" valign="top">
										<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("menu_cut_to_clipboard", "positional_delayed_tooltips2")>
										<input type="button" #_tooltips_# disabled value="Cut to#CR#Clipboard" style="font-size: 9px;" title="Click this button to Cut a Menu Item or SubMenu Item to the ClipBoard. This function allows you to reorder the Menu; once a Menu Item or SubMenu is on the ClipBoard it may be Moved back to the Menu in a different position or into a different SubMenu container." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuCutToClipboard(brObj) } return false;">
										<cfif 0>
											<br><br>
											<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("menu_copy_to_clipboard", "positional_delayed_tooltips2")>
											<input type="button" #_tooltips_# disabled value="Copy to#CR#Clipboard" style="font-size: 9px;" title="Click this button to Copy a Menu Item or SubMenu Item to the ClipBoard. This function allows you to clone a Menu or SubMenu Item to make a copy of the item being copied to the ClipBoard; once a Menu Item or SubMenu is on the ClipBoard it may be Moved back to the Menu in a different position or into a different SubMenu container." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuCopyToClipboard(brObj) } return false;">
										<cfelse>
											<br><br>
											<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("menu_delete_item", "positional_delayed_tooltips2")>
											<input type="button" #_tooltips_# disabled value="Delete#CR#Item" style="font-size: 9px;" title="Click this button to delete a Menu Item from the Menu.  You may also delete a SubMenu after the SubMenu is empty.  Use this button to delete each Menu Item from the SubMenu and then close the SubMenu to use this button to delete the empty SubMenu." onClick="var brObj = getGUIObjectInstanceById('menu_browser'); if (brObj != null) { processMenuCutToThinAir(brObj) } return false;">
										</cfif>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<cfset __urlParms = "&currentPage=#URLEncodedFormat(currentPage)#">
			<cfinclude template="../cfinclude_GetCurrentContent.cfm">
			<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (IsDefined("GetCurrentContent.menu")) AND (IsDefined("GetCurrentContent.pageList"))>
				<input type="hidden" id="_GetCurrentContent_menu" value="#CommonCode.correctSiteMenuLinks(GetCurrentContent.menu, _currentPage_symbol)#">

				<!--- BEGIN: Determine which pages are being linked to in the current Menu, then exclude those from the query --->
				<cfset _notLinkables = CommonCode.getUnlinkables( GetCurrentContent.menu, _baseline_pages_not_linkable, _menuSubMenuURL_symbol, _menuSubMenuEndsURL_symbol, _currentPage_symbol)>
				<!--- END! Determine which pages are being linked to in the current Menu, then exclude those from the query --->

				<input type="hidden" id="_GetCurrentContent_notLinkables" value="#_notLinkables#">

				<!--- BEGIN: Filter out those page names that are already linked within the raw menu content... --->
				<cfset _nl = Replace(_notLinkables, "'", "", "all")>
				<cfset pl = GetCurrentContent.pageList>
				<cfloop index="_item" list="#_nl#" delimiters=",">
					<cfset _i = ListFindNoCase(pl, Trim(_item), ",")>
					<cfif (_i gt 0)>
						<cfset pl = ListDeleteAt(pl, _i, ",")>
					</cfif>
				</cfloop>
				<!--- END! Filter out those page names that are already linked within the raw menu content... --->

				<input type="hidden" id="_GetCurrentContent_pageList" value="#pl#">

				<script language="JavaScript1.2" type="text/javascript">
					<!--
					var global_menuItemEditorsList = '';

					var const_menu_note_symbol = '#_images_folder#note.gif';
	
					var const_menu_folderclosed_symbol = '#_images_folder#folderclosed.gif';
					
					var _urlParms = '#__urlParms#';
					
					loadMenuEditor(getGUIObjectInstanceById('_GetCurrentContent_menu'));
					-->
				</script>
				<cfif (_AdminMode eq 1)>
					<script language="JavaScript1.2" type="text/javascript">
						<!--
						initMenuEditorClipboardObjects();
						-->
					</script>
				</cfif>
				<script language="JavaScript1.2" type="text/javascript">
					<!--
					rebuildMenu(menuArray, false, '#CGI.SCRIPT_NAME##Request.first_splashscreen_inhibitor#');
					-->
				</script>
			</cfif>
		<cfelse>
			<h3 align="center"><font color="##ff0000">Access to the Menu Editor is <U>DENIED</U> at this time.</font></h3>
			<br><br>
			<cfif 0>
				<cfset _emailLink = '<a href="mailto:#GetEditableContent.userid#?subject=Menu Editor Access">#GetEditableContent.userid#</a>'>
			<cfelse>
				<cfset _emailLink = CommonCode.makeMenuInUseContactUserLink(GetEditableContent.userid)>
			</cfif>
			<cfset _timeString = CommonCode.formattedDateTimeTZ(ParseDateTime(GetEditableContent.d_locked))>
			<h4 align="center"><font color="##ff0000">The Menu Editor is in-use by user #_emailLink# since <font color="##0000ff" size="1"><small>#_timeString#</small></font>; you may coordinate access to the Menu Editor with user #_emailLink# or contact your Security Manager to override access.</font></h4>
		</cfif>
	<cfelse>
		<table>
			<cfset _displayableFunction = GetToken(function, 2, "|")>
			<cfset _existingPageNameList = "">
			<cfset _saveButton_options = "">
			<cfset _cancelPopUp_options = "">
			<cfset _form_options = "">
			<cfset _show_pageTitle = "True">
			<cfif Len(_displayableFunction) eq 0>
				<cfset _displayableFunction = "New Page">
				<cfloop query="GetEditableContent" startrow="1" endrow="#GetEditableContent.recordCount#">
					<cfif (IsDefined("GetEditableContent.pageName"))>
						<cfset _existingPageNameList = ListAppend(_existingPageNameList, GetEditableContent.pageName, ",")>
					</cfif>
				</cfloop>
				<cfif (NOT IsDefined("GetEditableContent.pageName"))>
					<!--- BEGIN: Inhibit the display of the page title when there isn't a pageName --->
					<cfset _show_pageTitle = "False">
					<!--- BEGIN: Inhibit the display of the page title when there isn't a pageName --->
				<cfelse>
					<cfset _saveButton_options = "disabled">
					<cfset _existingPageNameList = "'#_existingPageNameList#'">
					<cfset _form_options = 'onsubmit = "return( validateUniquePageName(#_existingPageNameList#));"'>
				</cfif>
				<cfset _cancelPopUp_options = 'onclick="okayToSubmit = -1;"'>
			</cfif>

			<cfset _jsParms = "this.form.saveButton,document.all._errorMessage,this.form._pageTitle,getGUIObjectInstanceById('t_existingPageNameList'),false">
			<form name="myForm" action="#CGI.SCRIPT_NAME#" method="post" #_form_options#>
				<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
				<input type="hidden" id="t_existingPageNameList" value="#_existingPageNameList#">
				<tr valign="top">
					<td <cfif _adminMethod eq _adminMethod_nopopups><cfelse>colspan="3"</cfif>>
						<cfif 0> <!--- versioning is disabled at this time... this was a proof of concept... --->
							<cfset _someHTML = '
								<select name="_titleVersion" style="font-size:9px;" onChange="changePage(this.form._titleVersion)">
							'>
							<cfset _numberOfItems = 0>
							<cfloop query="GetEditableContent" startrow="1" endrow="#GetEditableContent.recordCount#">
								<cfif Len(GetEditableContent.versionDateTime) gt 0>
									<cfset _selected = "">
									<cfif (Len(_id) gt 0) AND (_id eq GetEditableContent.id)>
										<cfset _selected = "selected">
									</cfif>
									<cfset _numberOfItems = IncrementValue(_numberOfItems)>
									<cfset _someHTML = '#_someHTML#
										<option #_selected# value="#CGI.SCRIPT_NAME#?_id=#GetEditableContent.id#&function=#URLEncodedFormat(function)#&_pageTitle=#URLEncodedFormat(GetEditableContent.PageTitle)#&pageName=#URLEncodedFormat(pageName)#&currentPage=#URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">#DateFormat(GetEditableContent.versionDateTime, "mm/dd/yyyy")# #TimeFormat(GetEditableContent.versionDateTime, "h:mm tt")# | #GetEditableContent.PageTitle#</option>
									'>
								</cfif>
							</cfloop>
							<cfset _someHTML = '#_someHTML#
								</select>
							'>
							<cfif (_numberOfItems gt 0)>
								#_someHTML#
							</cfif>
						</cfif>
						<cfif (Len(_pageTitle) eq 0) AND (IsDefined("GetEditableContent.PageTitle"))>
							<cfset _pageTitle = GetEditableContent.PageTitle>
						<cfelse>
							<cfset _pageTitle = "">
						</cfif>
						<cfset _readOnly = "">
						<cfif (pageName eq _quickLinksPageName_symbol) OR (pageName eq _sepg_section_pageName_symbol) OR (pageName eq _sepg_links_pageName_symbol) OR (pageName eq _right_side_pageName_symbol) OR (pageName eq _footer_pageName_symbol)>
							<cfset _readOnly = "readonly disabled">
							<cfset _displayableFunction = pageName>
							<cfif (pageName eq _quickLinksPageName_symbol)>
								<cfset function = quickLinksEditorAction_symbol>
							<cfelseif (pageName eq _sepg_section_pageName_symbol)>
								<cfset function = sepg_sectionEditorAction_symbol>
							<cfelseif (pageName eq _sepg_links_pageName_symbol)>
								<cfset function = sepg_linksEditorAction_symbol>
							<cfelseif (pageName eq _right_side_pageName_symbol)>
								<cfset function = right_sideEditorAction_symbol>
							<cfelseif (pageName eq _footer_pageName_symbol)>
								<cfset function = footerEditorAction_symbol>
							</cfif>
						</cfif>
						<cfset _js = "ensureUnique(#_jsParms#)">
						<cfif _show_pageTitle>
							<input name="_pageTitle" type="text" value="#_pageTitle#" size="30" maxlength="50" #_readOnly# tabindex="1" onChange="#_js#" onBlur="#_js#" onfocus="document.all._errorMessage.style.display = const_none_style; document.all._errorMessage2.style.display = const_none_style; this.form.saveButton.disabled = false;">
						<cfelse>
							<input name="_pageTitle" type="hidden" value="">
						</cfif>
						<div id="_errorMessage" style="display: none;"><font size="2" color="##ff0000"><b>This Page Title is already in-use.</b></font></div>
						<div id="_errorMessage2" style="display: none;"><font size="2" color="##ff0000"><b>This Page Title is already in-use. <U>CANNOT</U> Submit !</b></font></div>
					</td>
				</tr>
				<tr valign="top">
					<cfset _pageContent = "">
					<cfif IsDefined("GetEditableContent.quickLinks") AND (Len(GetEditableContent.quickLinks) gt 0)>
						<cfset _pageContent = GetEditableContent.quickLinks>
					<cfelseif IsDefined("GetEditableContent.sepg_section") AND (Len(GetEditableContent.sepg_section) gt 0)>
						<cfset _pageContent = GetEditableContent.sepg_section>
					<cfelseif IsDefined("GetEditableContent.sepg_links") AND (Len(GetEditableContent.sepg_links) gt 0)>
						<cfset _pageContent = GetEditableContent.sepg_links>
					<cfelseif IsDefined("GetEditableContent.right_side") AND (Len(GetEditableContent.right_side) gt 0)>
						<cfset _pageContent = GetEditableContent.right_side>
					<cfelseif IsDefined("GetEditableContent.footer") AND (Len(GetEditableContent.footer) gt 0)>
						<cfset _pageContent = GetEditableContent.footer>
					<cfelseif IsDefined("GetEditableContent.html") AND (Len(GetEditableContent.html) gt 0)>
						<cfset _pageContent = GetEditableContent.html>
					</cfif>
					<td <cfif _adminMethod eq _adminMethod_nopopups><cfelse>colspan="3"</cfif>>
						<cfset _readonly = "">
						<cfset _cols = 60>
						<cfset _rows = 20>
						<cfif _adminMethod eq _adminMethod_nopopups>
							<cfset _cols = 82>
							<cfset _rows = 25>
						</cfif>
						<textarea name="_pageContent" cols="#_cols#" rows="#_rows#" #_readonly# wrap="virtual" tabindex="2" #_textarea_style_symbol#>#_pageContent#</textarea>
					</td>
				</tr>
				<cfif _adminMethod eq _adminMethod_nopopups>
				<cfelse>
					<input name="function" type="hidden" value="#function#">
				</cfif>
				<input name="pageName" type="hidden" value="#pageName#">
				<input name="currentPage" type="hidden" value="#currentPage#">
				<input name="submit" type="hidden" value="#function#">
				<tr valign="top">
					<td <cfif _adminMethod eq _adminMethod_nopopups><cfelse>colspan="2"</cfif>>
						<input name="saveButton" #_saveButton_options# tabindex="3" type="submit" value="Save HTML for [#_displayableFunction#]">&nbsp;
						<input name="cancelPopUp" type="submit" tabindex="4" value="#_cancelButton_symbol#" #_cancelPopUp_options#>
					</td>
				</tr>
			</form>

			<cfset _formElementGettingFocus = "_pageTitle">
			<cfif (NOT _show_pageTitle)>
				<cfset _formElementGettingFocus = "_pageContent">
			</cfif>

			<script language="JavaScript1.2" type="text/javascript">
			<!--
				setFocusSafelyById("#_formElementGettingFocus#");
			-->
			</script>
		</table>
	</cfif>
</cfoutput>
