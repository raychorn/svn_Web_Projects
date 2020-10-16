<cfoutput>
	<div id="leftmenu" #_div_styles_leftmenu#>
	</div>
		<cfset _menuItemEditorsList = "">
		<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (IsDefined("GetCurrentContent.menu")) AND (IsDefined("GetCurrentContent.pageList"))>
			<cfset _urlParms = "&_menuContent=&currentPage=#URLEncodedFormat(currentPage)#">
			<cfset _menuItemEditor = commonCode.makeLink( _menuTableEditorAction_symbol, "#_urlParms#&_object=menuItem", "#SOFTTAB#Edit Menu Item(s)")>
			<cfset _menuSubEditor = commonCode.makeLink( _menuEditorAction_symbol, "#_urlParms#&&_object=submenu", "Add Sub-Menu")>
			<cfset _editMode = "False">
			<cfset _editLink = "">
			<cfset _notLinkables = "">
			<cfset _urlParms = "">
			<cfset _allowNewPages = "False">
			<cfset __urlParms = "&currentPage=#URLEncodedFormat(currentPage)#">
			<cfif _adminMode>
				<cfset _editMode = "False">
				<cfif (IsDefined("VerifyMenuPageSecurity")) AND (VerifyMenuPageSecurity.recordCount gt 0)>
					<cfset _editMode = "True">
				</cfif>
				<cfif (UCASE(_subsysName) eq UCASE(_AdminSubSysName_symbol))>
					<cfset _allowNewPages = "True">
				</cfif>
				<cfset _notLinkables = CommonCode.getUnlinkables( _menuContent, _baseline_pages_not_linkable, _menuSubMenuURL_symbol, _menuSubMenuEndsURL_symbol, _currentPage_symbol)>
				<cfset _urlParms = "&_notLinkables=#URLEncodedFormat(_notLinkables)##__urlParms#">

				<cfset _menuItemEditorsList = "">
				<cfif (NOT CommonCode.isStagingView()) AND (IsDefined("VerifySecurity_AddNewPages")) AND (VerifySecurity_AddNewPages.recordCount gt 0)>
					<cfif (is_locked_menuEditor)>
						<cfset disabled_newPage_editor_title = "The WYSIWYG HTML Editor is <u>locked</u> and <u>in-use</u> by #emailLink_locked_menuEditor# since #emailLink_locked_timeString#. Only one user may use this feature at a time.">
						<cfset disabled_newPage_editor = CommonCode.makeContentEditorLink("True", _adminMethod, _adminMethod_nopopups, "True", disabled_newPage_editor_title, _htmlEditorNewPageAction_symbol, "", const_newPage_editor_prompt_symbol)>

						<cfset disabled_editor_prompt_symbol = const_menuEditor_prompt_symbol>
						<cfset disabled_newMenu_editor_title = "The Menu Editor is <u>locked</u> and <u>in-use</u> by #emailLink_locked_menuEditor# since #emailLink_locked_timeString#. Only one user may use this feature at a time.">
						<cfset disabled_newMenu_editor = CommonCode.makeContentEditorLink("True", _adminMethod, _adminMethod_nopopups, "False", disabled_newMenu_editor_title, _htmlMenuEditorAction_symbol, _urlParms, disabled_editor_prompt_symbol)>

						<cfset _menuItemEditorsList = "#disabled_newPage_editor#|#disabled_newMenu_editor#">

						<div style="margin-bottom: 10px;">
							<table width="100%" bgcolor="##FFFFBF" cellpadding="-1" cellspacing="-1">
								<tr>
									<td>
										<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
											<tr>
												<td>
													<font color="red"><small><b>#disabled_newPage_editor_title#</b></small></font>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<hr width="80%" color="##0000FF">
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
											<tr>
												<td>
													<font color="red"><small><b>#disabled_newMenu_editor_title#</b></small></font>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>
					<cfelse>
						<cfset _menuItemEditorsList = "#_newPage_editor#|#_newMenu_editor#">
					</cfif>
				</cfif>
			</cfif>
			
			<input type="hidden" id="_GetCurrentContent_menu" value="#CommonCode.correctSiteMenuLinks(GetCurrentContent.menu, _currentPage_symbol)#">
			
			<script language="JavaScript1.2" type="text/javascript">
				<!--
				var global_menuItemEditorsList = '#_menuItemEditorsList#';
				-->
			</script>

			<cfif (_adminMode)>
				<script language="JavaScript1.2" type="text/javascript">
					<!--
					var const_menuTableEditorAction_symbol = '#_menuTableEditorAction_symbol#';
					var const_editorMenuEditAction_symbol = '#_editorMenuEditAction_symbol#';
					var const_editorMenuAddAction_symbol = '#_editorMenuAddAction_symbol#';
					var const_editorMenuDropAction_symbol = '#_editorMenuDropAction_symbol#';
					var const_editorMenuAddSubMenuAction_symbol = '#_editorMenuAddSubMenuAction_symbol#';
					var const_editorMenuAddSubMenuContainerAction_symbol = '#_editorMenuAddSubMenuContainerAction_symbol#';
					
					var const_reorganizeMenuUpImage_symbol = '#_reorganizeMenuUpImage_symbol#';
					var const_reorganizeMenuDnAction_symbol = '#_reorganizeMenuDnAction_symbol#';
					var const_reorganizeMenuDnImage_symbol = '#_reorganizeMenuDnImage_symbol#';
					var const_reorganizeSubMenuUpAction_symbol = '#_reorganizeSubMenuUpAction_symbol#';
					var const_reorganizeSubMenuDnAction_symbol = '#_reorganizeSubMenuDnAction_symbol#';
					-->
				</script>
			</cfif>

			<cfif (_SecurityMode eq 0) AND (_ReleaseMode eq 0)>
				<script language="JavaScript1.2" type="text/javascript">
					<!--
					var const_images_folder_symbol = '#_images_folder#';
					
					var const_menu_note_symbol = const_images_folder_symbol + 'note.gif';
	
					var const_menu_folderclosed_symbol = const_images_folder_symbol + 'folderclosed.gif';
					
					var const_currentPage_symbol = '#_currentPage_symbol#';
					
					var _urlParms = '#__urlParms#';
					
					loadMenuEditor(document.getElementById('_GetCurrentContent_menu'));
					-->
				</script>
			</cfif>
		</cfif>

	<cfif (_SecurityMode eq 0) AND (_ReleaseMode eq 0)>
		<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (IsDefined("GetCurrentContent.menu"))>
			<script language="JavaScript1.2" type="text/javascript">
				<!--
				rebuildMenu(menuArray, true);
				-->
			</script>
		</cfif>
	</cfif>
</cfoutput>
