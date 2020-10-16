<cfoutput>
	<cfset _isLocal = Trim(CommonCode.isServerLocal())>
	<!--- BEGIN: These globals are defined from ColdFusion variables... --->
	<script language="JavaScript1.2" type="text/javascript">
		<!--
		var const_currentPage_symbol = '#_currentPage_symbol#';
		var const_cgi_script_name_symbol = '#CGI.SCRIPT_NAME#';
		var _currentPage_ = '#currentPage#';

		var _isServerLocal_ = '#_isLocal#';
		
		var b_isServerLocal = ((_isServerLocal_.toUpperCase() == 'YES') ? true : false);
		if (b_isServerLocal) {
			_global_menu_mode = b_isServerLocal; // true for the new menu, false for the original menu...
		}
		_global_menu_mode = false; // true for the new menu, false for the original menu...
		
		var const_cgi_server_name_symbol = '#CGI.SERVER_NAME#';
		
		var const_listOfRequiredSpecialPages = '#_listOfRequiredSpecialPages2#';
		
		var _const_clipboard_paste_before_caption = '';
		var _const_clipboard_paste_before_title = '';

		var const_menuSubMenuEndsURL_symbol = '#_menuSubMenuEndsURL_symbol#';
		
		var const_termianteDragDrop_url = '#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#';
		var const_makeElementDragable_url = '#CGI.SCRIPT_NAME#?submit=#URLEncodedFormat(swapSidesEditorAction_symbol)##Request.next_splashscreen_inhibitor#';
		-->
	</script>
	<!--- END! These globals are defined from ColdFusion variables... --->
</cfoutput>

<cfif (_AdminMode eq 1)>
	<cfoutput>
		<!--- BEGIN: These globals are defined from ColdFusion variables... --->
		<script language="JavaScript1.2" type="text/javascript">
			<!--
				function initColdFusion2JavaScript() {
					// BEGIN: Loading ColdFusion variables for use within a JavaScript module...
					var obj = getGUIObjectInstanceById('_const_clipboard_paste_before_caption');
					var obj2 = getGUIObjectInstanceById('_const_clipboard_paste_before_title');
					var obj3 = getGUIObjectInstanceById('_const_clipboard_paste_before_tooltips');
					var dObj = getGUIObjectInstanceById('div_clipboard_paste_before_caption');
					if ( (obj != null) && (obj2 != null) && (obj3 != null) && (dObj != null) && isObjValidHTMLValueHolder(obj) && isObjValidHTMLValueHolder(obj2) && isObjValidHTMLValueHolder(obj3) ) {
						var _caption = URLDecode(obj.value.trim());
						var _title = URLDecode(obj2.value.trim());
						var _tooltips = URLDecode(obj3.value.trim());
						dObj.innerHTML = '<input type="radio" ' + _tooltips + ' name="clipboard_paste_beforeOrAfter" value="BEFORE" title="' + _title + '">&nbsp;' + _caption;
					}
					
					var obj = getGUIObjectInstanceById('_const_clipboard_paste_after_caption');
					var obj2 = getGUIObjectInstanceById('_const_clipboard_paste_after_title');
					var obj3 = getGUIObjectInstanceById('_const_clipboard_paste_after_tooltips');
					var dObj = getGUIObjectInstanceById('div_clipboard_paste_after_caption');
					if ( (obj != null) && (obj2 != null) && (obj3 != null) && (dObj != null) && isObjValidHTMLValueHolder(obj) && isObjValidHTMLValueHolder(obj2) && isObjValidHTMLValueHolder(obj3) ) {
						var _caption = URLDecode(obj.value.trim());
						var _title = URLDecode(obj2.value.trim());
						var _tooltips = URLDecode(obj3.value.trim());
						dObj.innerHTML = '<input type="radio" ' + _tooltips + ' name="clipboard_paste_beforeOrAfter" value="AFTER" title="' + _title + '">&nbsp;' + _caption;
					}

					var obj = getGUIObjectInstanceById('_const_menu_item_editor_internal_caption');
					var obj2 = getGUIObjectInstanceById('_const_menu_item_editor_internal_title');
					var obj3 = getGUIObjectInstanceById('_const_menu_item_editor_internal_tooltips');
					var dObj = getGUIObjectInstanceById('div_menu_item_editor_internal');
					if ( (obj != null) && (obj2 != null) && (obj3 != null) && (dObj != null) && isObjValidHTMLValueHolder(obj) && isObjValidHTMLValueHolder(obj2) && isObjValidHTMLValueHolder(obj3) ) {
						var _caption = URLDecode(obj.value.trim());
						var _title = URLDecode(obj2.value.trim());
						var _tooltips = URLDecode(obj3.value.trim());
						dObj.innerHTML = '<input type="radio" checked ' + _tooltips + ' name="menu_item_editor_InternalOrExternal" value="INTERNAL" title="' + _title + '" onClick="processMenuEditorCheckLinkType(); return true;">&nbsp;' + _caption;
					}
					
					var obj = getGUIObjectInstanceById('_const_menu_item_editor_external_caption');
					var obj2 = getGUIObjectInstanceById('_const_menu_item_editor_external_title');
					var obj3 = getGUIObjectInstanceById('_const_menu_item_editor_external_tooltips');
					var dObj = getGUIObjectInstanceById('div_menu_item_editor_external');
					if ( (obj != null) && (obj2 != null) && (obj3 != null) && (dObj != null) && isObjValidHTMLValueHolder(obj) && isObjValidHTMLValueHolder(obj2) && isObjValidHTMLValueHolder(obj3) ) {
						var _caption = URLDecode(obj.value.trim());
						var _title = URLDecode(obj2.value.trim());
						var _tooltips = URLDecode(obj3.value.trim());
						dObj.innerHTML = '<input type="radio" ' + _tooltips + ' name="menu_item_editor_InternalOrExternal" value="EXTERNAL" title="' + _title + '" onClick="processMenuEditorCheckLinkType(); return true;">&nbsp;' + _caption;
					}
					
					var dObj = getGUIObjectInstanceById('div_menu_browser');
					if (dObj != null) {
						dObj.innerHTML = '<select id="menu_browser" size="10" style="font-size: 10px; line-height: 10px;" ondblclick="return handle_menuBrowser_dblclick();" onchange="return handle_menuBrowser_change();"></select>';

						var bObj = getGUIObjectInstanceById('menu_browser');
						if (bObj != null) {
							populateSelectWithMenu(bObj, menuArray);
						}
					}
					// END! Loading ColdFusion variables for use within a JavaScript module...
				}
			-->
		</script>
		<!--- END! These globals are defined from ColdFusion variables... --->
	</cfoutput>
</cfif>
