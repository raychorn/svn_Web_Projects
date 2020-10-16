/*
 menu_editor_obj.js -- menuEditorObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

menuEditorObj = function(id, div_menuBrowserID, menuBrowserID, _menu_textColor, _outerWidth) {
	this.id = id;									// the id is the position within the global ButtonBarObj.instances array...
	this.div_menuBrowserID = div_menuBrowserID;		// this is the menu browser div that the menu browser resides within...
	this.menuBrowserID = menuBrowserID;				// this is the id of the menu browser select widget...
	this.guiHTML = menuEditorObj.defaultGUI(this, _menu_textColor, _outerWidth); 	// create the default GUI - this default GUI can be overridden with another that specifies the same DOM Object ID's...
};

menuEditorObj.$ = [];

menuEditorObj.get$ = function(_div_menuBrowserID, _menuBrowserID, menuTextColor, outerWidth) {
	// the object.id is the position within the array that holds onto the objects...
	var instance = menuEditorObj.$[menuEditorObj.$.length];
	if(instance == null) {
		instance = menuEditorObj.$[menuEditorObj.$.length] = new menuEditorObj(menuEditorObj.$.length, _div_menuBrowserID, _menuBrowserID, menuTextColor, outerWidth);
	}
	return instance;
};

menuEditorObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < menuEditorObj.$.length) ) {
		var instance = menuEditorObj.$[id];
		if (!!instance) {
			menuEditorObj.$[id] = object_destructor(instance);
			ret_val = (menuEditorObj.$[id] == null);
		}
	}
	return ret_val;
};

menuEditorObj._remove$ = function() {
	var ret_val = true;
	for (var i = 0; i < menuEditorObj.$.length; i++) {
		menuEditorObj.remove$(i);
	}
	menuEditorObj.$ = [];
	return ret_val;
};

menuEditorObj.const_menuCopyToClipboard$ = 'menu_copy_to_clipboard';
menuEditorObj.const_menuDeleteItem$ = 'menu_delete_item';
menuEditorObj.const_clipboardPasteToMenu$ = 'clipboard_paste_to_menu';

menuEditorObj.pasteItemToMenu = function(v, isAfter, menuEditorObj) {
	v = ((!!v) ? v : ' | | ');
	isAfter = ((!!isAfter) ? isAfter : false);
	return ( ( (!!menuEditorObj) && (!!v) && (!!isAfter) ) ? menuEditorObj._pasteItemToMenu(v, isAfter) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + '), v is (' + v + ') and isAfter is (' + isAfter + ') in function known as menuEditorObj.pasteItemToMenu().'));
};

menuEditorObj.pasteSubMenuToMenu = function(_prompt, isAfter, menuEditorObj) {
	_prompt = ((!!_prompt) ? _prompt : ' ');
	isAfter = ((!!isAfter) ? isAfter : false);
	return ( ( (!!menuEditorObj) && (!!_prompt) && (!!isAfter) ) ? menuEditorObj._pasteSubMenuToMenu(_prompt, isAfter) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + '), _prompt is (' + _prompt + ') and isAfter is (' + isAfter + ') in function known as menuEditorObj.pasteSubMenuToMenu().'));
};

menuEditorObj._pasteSubMenuToMenu = function(v, isAfter, menuEditorObj) {
	v = ((!!v) ? v : ' ');
	isAfter = ((!!isAfter) ? isAfter : false);
	return ( ( (!!menuEditorObj) && (!!v) && (!!isAfter) ) ? menuEditorObj.__pasteSubMenuToMenu(v, isAfter) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + '), v is (' + v + ') and isAfter is (' + isAfter + ') in function known as menuEditorObj.pasteSubMenuToMenu().'));
};

menuEditorObj.processClipboardPasteBecomesMove = function(anObj) {
	var dObj = $('clipboard_paste_becomes_move_div');
	var rObj = $('clipboard_remove_item');
	var pmObj = $(menuEditorObj.const_clipboardPasteToMenu$);
	if ( (!!anObj) && (!!dObj) && (!!rObj) && (!!pmObj) ) {
		var joining_symbol = '';
		if (anObj.checked) {
			joining_symbol = '+';
			rObj.style.display = const_none_style;
			pmObj.value = 'Move to Menu';
		} else {
			joining_symbol = '-';
			rObj.style.display = const_inline_style;
			pmObj.value = 'Paste to Menu';
		}
		flushGUIObjectChildrenForObj(dObj);
		dObj.innerHTML = '<font size="-1" id="clipboard_paste_becomes_move_font"><small><b>Clipboard Paste to Menu<br>&nbsp;&nbsp;&nbsp;' + joining_symbol + 'Remove</b></small></font>';
	}
};

menuEditorObj.processMenuCutToThinAir = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuCutToClipboard(brObj, false) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorObj.processMenuCutToThinAir().'));
};

menuEditorObj.processMenuCutToClipboard = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuCutToClipboard(brObj, true) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorObj.processMenuCutToClipboard().'));
};

menuEditorObj.processMenuCopyToClipboard = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuCopyToClipboard(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorObj.processMenuCopyToClipboard().'));
};

menuEditorObj.processClipboardPasteToMenu = function(clipObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!clipObj) ) ? menuEditorObj._processClipboardPasteToMenu(clipObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and clipObj is (' + clipObj + ') in function known as menuEditorObj.processClipboardPasteToMenu().'));
};

menuEditorObj.processClipboardRemoveSelected = function(clipObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!clipObj) ) ? menuEditorObj._processClipboardRemoveSelected(clipObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and clipObj is (' + clipObj + ') in function known as menuEditorObj.processClipboardRemoveSelected().'));
};

menuEditorObj.processSelectedClipboardItem = function(clipObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!clipObj) ) ? menuEditorObj._processSelectedClipboardItem(clipObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and clipObj is (' + clipObj + ') in function known as menuEditorObj.processSelectedClipboardItem().'));
};

menuEditorObj.processMenuBrowseInto = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuBrowseInto(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorObj.processMenuBrowseInto().'));
};

menuEditorObj.processMenuBrowseOut = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuBrowseOut(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorObj.processMenuBrowseOut().'));
};

menuEditorObj.ProcessMenuSaveToDatabase = function(mcObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!mcObj) ) ? menuEditorObj._ProcessMenuSaveToDatabase(mcObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and mcObj is (' + mcObj + ') in function known as menuEditorObj.ProcessMenuSaveToDatabase().'));
};

menuEditorObj.processCancelMenuItemEditor = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._processCancelMenuItemEditor() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorObj.processCancelMenuItemEditor().'));
};

menuEditorObj.processSaveMenuItemEditor = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._processSaveMenuItemEditor() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorObj.processSaveMenuItemEditor().'));
};

menuEditorObj.refreshUrlType = function(_url, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!_url) ) ? menuEditorObj._refreshUrlType(_url) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and _url is (' + _url + ') in function known as menuEditorObj.refreshUrlType().'));
};

menuEditorObj._refreshUrlType = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj.__refreshUrlType() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorObj._refreshUrlType().'));
};

menuEditorObj.processChangedUrlType = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._processChangedUrlType() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorObj.processChangedUrlType().'));
};

menuEditorObj.processMenuSubMenuAdditor = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuSubMenuAdditor(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorObj.processMenuSubMenuAdditor().'));
};

menuEditorObj.processMenuItemAdditor = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuItemAdditor(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorObj.processMenuItemAdditor().'));
};

menuEditorObj.processMenuItemEditor = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj.__processMenuItemEditor(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorObj.processMenuItemEditor().'));
};

menuEditorObj.refreshMenuItemEditorSaveButton = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._refreshMenuItemEditorSaveButton() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorObj.refreshMenuItemEditorSaveButton().'));
};

menuEditorObj.handle_menuBrowser_dblclick = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._handle_menuBrowser_dblclick() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorObj.handle_menuBrowser_dblclick().'));
};

menuEditorObj.handle_menuBrowser_change = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._handle_menuBrowser_change() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorObj.handle_menuBrowser_change().'));
};

menuEditorObj.defaultGUI = function(menuEditorObj, _site_menu_text_color, _outerTableWidth) {
	var _html = '';
	
	if ( (menuEditorObj == null) || (menuEditorObj.id == null) ) {
		alert('ERROR: Programming Error - Missing menuEditorObj (' + menuEditorObj + ') menuEditorObj.id = [' + menuEditorObj.id + '] in menuEditorObj.defaultGUI().');
		return;
	}

	_site_menu_text_color = ((!!_site_menu_text_color) ? _site_menu_text_color : '');
	
	_outerTableWidth = ((!!_outerTableWidth) ? _outerTableWidth : 800);

	_html += '<input type="hidden" id="_GetCurrentContent_pageList" value="">';
	_html += '<input type="hidden" id="_GetCurrentContent_notLinkables" value="">';
	
	_html += '<table width="' + _outerTableWidth + '" border="0" cellpadding="-1" cellspacing="-1">';
	_html += '<tr>';
	_html += '<td align="left" valign="top">';
	_html += '<div id="menu_editor_pane">';
	_html += '<table width="*" cellpadding="-1" cellspacing="-1">';
	_html += '<tr>';
	_html += '<td width="*" align="right" valign="top">';
	_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
	_html += '<tr>';
	_html += '<td>';
	_html += '<table cellpadding="-1" cellspacing="-1">';
	_html += '<tr>';
	_html += '<td>';
	_html += '<div id="_menu_item_editor_button" style="display: inline;">';
	_html += '<input type="button" id="edit_menu_item" value="Edit Menu Item" disabled class="buttonClass" title="Click this button to edit or modify the menu item that is highlighted in the list to the right of this button.  Menu Items differ from SubMenu Items in that a Menu Item is an individual item that appears on the Menu and a SubMenu Item is a collection of Menu Items.  You may Open a SubMenu to Edit the individual Menu Items by double-clicking the SubMenu or by clicking the appropriate button that appears below the list to the right of this button. SubMenu Items are displayed the same as Menu Items except the SubMenu Item appears enclosed by parenthesis." onClick="var brObj = $(\'menu_browser\'); if (brObj != null) { menuEditorObj.processMenuItemEditor(brObj, menuEditorObj.$[' + menuEditorObj.id + ']) } return false;">';
	_html += '</div>';
	_html += '</td>';
	_html += '</tr>';
	_html += '<tr>';
	_html += '<td>';
	_html += '&nbsp;';
	_html += '</td>';
	_html += '</tr>';
	_html += '<tr>';
	_html += '<td>';
	_html += '<div id="_menu_item_additor_button" style="display: inline;">';
	_html += '<input type="button" id="addit_menu_item" value="Add Menu Item" class="buttonClass" title="Click this button to add a menu item.  Menu items are used to link to internal pages of content or to external documents such as Panagons docs or to external sites.  Menu items are different than SubMenu Items in that a Menu Item provides a single link to something whereas a SubMenu provides a container for a number of Menu Items." onClick="var brObj = $(\'menu_browser\'); if (brObj != null) { menuEditorObj.processMenuItemAdditor(brObj, menuEditorObj.$[' + menuEditorObj.id + ']) } return false;">';
	_html += '</div>';
	_html += '</td>';
	_html += '</tr>';
	_html += '<tr>';
	_html += '<td>';
	_html += '&nbsp;';
	_html += '</td>';
	_html += '</tr>';
	_html += '<tr>';
	_html += '<td>';
	_html += '<div id="_menu_submenu_additor_button" style="display: inline;">';
	_html += '<input type="button" id="addit_menu_submenu" value="Add Empty\nSubMenu" class="buttonClass" title="Click this button to add a SubMenu Item.  SubMenu Items may contain one or more Menu Items and are used to extend the menu horizontally whereas Menu Items extend the Menu vertically." onClick="var brObj = $(\'menu_browser\'); if (brObj != null) { menuEditorObj.processMenuSubMenuAdditor(brObj, menuEditorObj.$[' + menuEditorObj.id + ']) } return false;">';
	_html += '</div>';
	_html += '</td>';
	_html += '</tr>';
	_html += '<tr>';
	_html += '<td>';
	_html += '&nbsp;';
	_html += '</td>';
	_html += '</tr>';
	_html += '<tr>';
	_html += '<td>';
	_html += '&nbsp;';
	_html += '</td>';
	_html += '</tr>';
	_html += '</table>';
	_html += '</td>';
	_html += '</tr>';
	_html += '</table>';
	_html += '</td>';
	_html += '<td width="*" valign="top" align="right">';
	_html += '<table cellpadding="-1" cellspacing="-1">';
	_html += '<tr>';
	_html += '<td align="center" valign="top">';
	_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
	_html += '<tr>';
	_html += '<td bgcolor="#FFFF80">';
	_html += '<div id="div_menu_browser" style="display: inline;"></div>';
	_html += '<div id="_div_menu_browser" style="display: inline;"></div>';
	_html += '</td>';
	_html += '</tr>';
	_html += '<tr>';
	_html += '<td>';
	_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
	_html += '<tr>';
	_html += '<td width="50%" align="left">';
	_html += '<input type="button" id="menu_browse_into" value="Open\nSub Menu" disabled class="buttonClass" title="Click this button to Open a SubMenu, the SubMenu that is highlighted in the list directly above this button.  The other way to Open a SubMenu is to double-click the SubMenu item." onClick="var brObj = $(\'menu_browser\'); if (brObj != null) { menuEditorObj.processMenuBrowseInto(brObj, menuEditorObj.$[' + menuEditorObj.id + ']) } return false;">';
	_html += '</td>';
	_html += '<td width="50%" align="right">';
	_html += '<input type="button" id="menu_browse_out" id="menu_browse_out" value="Close\nSub Menu" disabled class="buttonClass" title="Click this button to Close a SubMenu that was previously opened." onClick="var brObj = $(\'menu_browser\'); if (brObj != null) { menuEditorObj.processMenuBrowseOut(brObj, menuEditorObj.$[' + menuEditorObj.id + ']) } return false;">';
	_html += '</td>';
	_html += '</tr>';
	_html += '</table>';
	_html += '</td>';
	_html += '</tr>';
	_html += '</table>';
	_html += '</td>';
	_html += '<td align="center" valign="top">';
	_html += '<input type="button" id="menu_cut_to_clipboard" disabled value="Cut to\nClipboard" class="buttonClass" title="Click this button to Cut a Menu Item or SubMenu Item to the ClipBoard. This function allows you to reorder the Menu; once a Menu Item or SubMenu is on the ClipBoard it may be Moved back to the Menu in a different position or into a different SubMenu container." onClick="var brObj = $(\'menu_browser\'); if (brObj != null) { menuEditorObj.processMenuCutToClipboard(brObj, menuEditorObj.$[' + menuEditorObj.id + ']) } return false;">';
	_html += '<br><br>';
	_html += '<input type="button" id="menu_delete_item" disabled value="Delete\nItem" class="buttonClass" title="Click this button to delete a Menu Item from the Menu.  You may also delete a SubMenu after the SubMenu is empty.  Use this button to delete each Menu Item from the SubMenu and then close the SubMenu to use this button to delete the empty SubMenu." onClick="var brObj = $(\'menu_browser\'); if (brObj != null) { menuEditorObj.processMenuCutToThinAir(brObj, menuEditorObj.$[' + menuEditorObj.id + ']) } return false;">';
	_html += '</td>';
	_html += '</tr>';
	_html += '</table>';
	_html += '</td>';
	_html += '</tr>';
	_html += '</table>';
	_html += '</div>';
	_html += '</td>';
	_html += '<td align="left" valign="top">';
	_html += '<div id="rightmenu_wrapper"></div>';
	_html += '</td>';
	_html += '</tr>';

	_html += '<tr>';
	_html += '<td>';
	_html += '<div id="_menu_item_editor" style="display: none;"></div>';
	_html += '</td>';
	_html += '</tr>';

	_html += '</table>';

	return _html;
};

menuEditorObj.prototype = {
	id : -1,
	bool_suppressEvents: false, // when this boolean is true the normal events are suppressed such as when menu items are being jammed into this object during initialization...
	bool_useUUID_nodeIDs : true, // when this boolean is true each node begins with http:// otherwise a uuid() is used as a node id (first item in node is either UUID or HTTP)... the orginal design assumed URL's would be passed along within each node's data structure...
	div_menuBrowserID : -1,
	menuBrowserID : -1,
	old_Ellipsis_symbol : '...',
	const_UUID_symbol : 'UUID',
	const_cancelButton_symbol : '[Cancel]',
	const_currentPage_symbol : '?currentPage=',
	const_subMenu_symbol : '##',
	const_subMenuEnds_symbol : '##-1',
	listOfRequiredSpecialPages : '',
//	const_menu_copy_to_clipboard_symbol : menuEditorObj.const_menuCopyToClipboard$, // this allows the copy to clipboard to be replaced by a delete item button without having to recode a lot of logic...
	const_menu_copy_to_clipboard_symbol : menuEditorObj.const_menuDeleteItem$,       // this allows the copy to clipboard to be replaced by a delete item button without having to recode a lot of logic...
	const_ClipboardPasteMode_symbol : 'ClipboardPasteMode',
	const_ClipboardEmpty_symbol : 'Clipboard Empty',
	const_menu_url_typelist : 'menu_url_typelist',
	const_menu_item_editor_saveButton : 'menu_item_editor_saveButton',
	const_menu_item_editor_cancelButton : 'menu_item_editor_cancelButton',
	const_positional_delayed_tooltips4 : 'positional_delayed_tooltips4',
	const_forward_slash_symbol : '/',
	const_ClipboardEmpty_value : -1,
	isAddingMenuItem : -1,
	isAddingMenuSubMenu : -1,
	bool_autoHideShowEditorFormButtons : false, // make this true to cause the menu editor bottons disappear whenever the editor form appears and vice-versa...
	const_empty_symbol : '',
	guiHTML : '',
	_menu_in_browser : null,
	menuArray : [],
	_menu_stack : [],
	_menu_clipboard : [],
	_menu_widgets_stack : [],
	_stack_remember_to_remove_from_pglist : [],
	_global_menu_mode : false, // true for the new menu, false for the original menu...
	toString : function() {
		var s = 'id = [' + this.id + '] ';
		return s;
	},
	// BEGIN: CallBacks, CallBacks and more CallBacks...
	onCommitSubMenu : function(v) {
		return v; // override this function to implement a callBack...
	},
	onCommitMenuItem : function(v) {
		return v; // override this function to implement a callBack...
	},
	onChangeMenuItem : function(v) {
		return v; // override this function to implement a callBack...
	},
	onChangeSubMenu : function(v) {
		return v; // override this function to implement a callBack...
	},
	onOpenSubMenu : function(v) {
		return v; // override this function to implement a callBack...
	},
	onCloseSubMenu : function(v) {
		return v; // override this function to implement a callBack...
	},
	onCutToClipboardMenuItem : function(v) {
		return v; // override this function to implement a callBack...
	},
	onCutToClipboardSubMenu : function(v) {
		return v; // override this function to implement a callBack...
	},
	onDeleteMenuItem : function(v) {
		return v; // override this function to implement a callBack...
	},
	rebuildMenu : function(mm, includeLinks) {
		// this is a placeholder that signals that the menu needs to be rebuilt...
	},
	// END! CallBacks, CallBacks and more CallBacks...
	cleanUpMenuArray : function(mm) {  // clean-up the array by taking out things that are now null from the end of the array...
		while (mm[mm.length - 1] == null) {
			mm.pop();
		}
	
		var ix = 0;
		var toks = [];
		var _url = '';
		for (var ii = mm.length - 1; ii > 0; ii--) {
			if ((typeof mm[ii]) != const_object_symbol) {
				toks = mm[ii].split('|');
				if (toks.length > 0) {
					_url = toks[0].trim().URLDecode();
					if (_url.trim() == this.const_subMenuEnds_symbol.trim()) {
						ix++;
					} else {
						break;
					}
				}
			}
		}
		if (ix > 0) {
			for ( ; ix > 0; ix--) {
				mm.pop();
			}
		}
	},
	loadMenuEditor : function(sObj) {
		s = '';
		if (isObjValidHTMLValueHolder(sObj)) {
			s = sObj.value;
		}
		
		var menuArray_i = 0;
	
		var a = s.split(",");
		for (var i = 0; i < a.length; i++) {
			this.menuArray[this.menuArray.length] = a[i];
		}
	
		var somethingToDo = true;
		var lastBegin_i = -1;
		var lastEnd_i = -1;
	
		while (somethingToDo) {
			for (i = 0; i < this.menuArray.length; i++) {
				if (this.menuArray[i] == null) {
					break;
				}
				if ((typeof this.menuArray[i]) != const_object_symbol) {
					toks = this.menuArray[i].split("|");
					if (toks[0].URLDecode() == this.const_subMenu_symbol) {
						lastBegin_i = i;
					}
					if (toks[0].URLDecode() == this.const_subMenuEnds_symbol) {
						lastEnd_i = i;
						break;
					}
				}
			}
			somethingToDo = ( (lastBegin_i != -1) && (lastEnd_i != -1) );
			if (somethingToDo) {
				var container = new Array(0);
				for (i = lastBegin_i; i <= lastEnd_i; i++) {
					container[container.length] = this.menuArray[i];
				}
				this.menuArray[lastBegin_i] = container;
				
				var _d = lastBegin_i + 1;
				var _s = lastEnd_i + 1;
				for (; _s < this.menuArray.length; _s++) {
					this.menuArray[_d] = this.menuArray[_s];
					_d++;
				}
				for (; _d < this.menuArray.length; _d++) {
					this.menuArray[_d] = null;
				}
				
				lastBegin_i = -1;
				lastEnd_i = -1;
			}
		}
	
		this.cleanUpMenuArray(this.menuArray);
	},
	debugMenu : function(mm) {
		var _do = '';
		var _i = 0;
	
		function debugMenuNode(c) {
			_do += '=======================================================\n';
			for (var i = 0; i < c.length; i++) {
				if (!!c[i]) {
					if (typeof c[i] == const_object_symbol) {
						debugMenuNode(c[i]);
					} else {
						_do += c[i] + '\n';
						_i++;
					}
				}
			}
			_do += '=======================================================\n\n';
			return _do;
		}
		return debugMenuNode(mm) + '_i = ' + _i;
	},
	joinMenu : function(mm) {
		var _do = '';
	
		function joinMenuNode(c) {
			for (var i = 0; i < c.length; i++) {
				if (!!c[i]) {
					if (typeof c[i] == const_object_symbol) {
						joinMenuNode(c[i]);
					} else {
						_do += c[i] + ',';
					}
				}
			}
			return _do;
		}
		_do = joinMenuNode(mm);
		var a = _do.split(',');
		while (a[a.length - 1].length == 0) {
			a.pop();
		}
		a.push(this.const_subMenuEnds_symbol);
		return a.join(',');
	},
	performMenuPasteAtLevel : function(value, offset) {
		if (!!this._menu_in_browser) {
			insertArrayItem(this._menu_in_browser,value,offset);
		}
		return this._menu_in_browser;
	},
	performMenuCutAtLevel : function(offset) {
		if (!!this._menu_in_browser) {
			removeArrayItem(this._menu_in_browser,offset);
		}
		return this._menu_in_browser;
	},
	isClipboardActuallyEmpty : function() {
		var clipObj = $('menu_clipboard');
		if (!!clipObj) {
			return ( (clipObj.options.length == 1) && (clipObj.options[0].text.toUpperCase() == this.const_ClipboardEmpty_symbol.toUpperCase()) );
		}
		return false;
	},
	_processMenuCutToClipboard : function(brObj, bool_copy_to_clipboard) {
		var clipObj = $('menu_clipboard');
		var bcutObj = $('menu_cut_to_clipboard');
		var bcopyObj = $(this.const_menu_copy_to_clipboard_symbol);
		var bcpasteObj = $(menuEditorObj.const_clipboardPasteToMenu$);
		var beforeObj = $('clipboard_paste_before');
		var afterObj = $('clipboard_paste_after');
		var bfontObj = $('clipboard_paste_before_font');
		var afontObj = $('clipboard_paste_after_font');
		var pgObj = $('menu_item_editor_pageList');
		if ( (!!brObj) && (!!clipObj) && (!!bcutObj) && (!!bcopyObj) && (!!bcpasteObj) && (!!pgObj) ) {
			var t = '';
			var sel = brObj.selectedIndex;
			if (sel != -1) {
				t = brObj.options[sel].text;
			} else {
				sel = 0; // cannot allow -1 which means nothing selected.
			}
			var v = '';
	
			var c = this.retrieveMenuAtLevel(this.menuArray, this._menu_stack, 0);
			var offset = (this._menu_stack.length == 0) ? 0 : 1;
			v = c[sel + offset];
			
			var isSubMenu = false;
			var _v = v;
			
			if (bool_copy_to_clipboard == true) {
				if (this.isClipboardActuallyEmpty()) {
					clipObj.options[0] = null;
				}
				var i = clipObj.options.length;
				this._menu_clipboard[i] = v;
				if (typeof v == const_object_symbol) {
					isSubMenu = true;
					var _prompt = '';
					var toks = v[0].split('|');
					if (toks.length > 2) {
						_prompt = toks[2].URLDecode().trim();
					}
					v = '(' + _prompt.clipCaselessReplace(this.old_Ellipsis_symbol, '') + ')';
				}
				var oObj = new Option( t, v);
				clipObj.options[i] = oObj;
				clipObj.options[i].selected = false;
				
				clipObj.disabled = false;
			}		
	
			if (typeof v != const_object_symbol) {
				var _url = '';
				var _curPage = '';
				var toks = v.split('|');
				if (toks.length > 1) {
					_url = toks[0].URLDecode().trim();
				}
				if (_url.toUpperCase().indexOf(this.const_currentPage_symbol.trim().toUpperCase()) != -1) {
					var _url_toks = _url.split('?');
					if (_url_toks.length > 1) {
						var _url_toks2 = _url_toks[1].split('=');
						if (_url_toks2.length > 1) {
							_curPage = _url_toks2[1];
						}
					}
					if (_curPage.trim().length > 0) {
						var opts = [];
						var optObj = new Option(_curPage, _curPage);
						for (var i = 0; i < pgObj.options.length; i++) {
							opts.push(pgObj.options[i]);
						}
						while (pgObj.options.length > 0) {
							pgObj.options[0] = null;
						}
						insertArrayItem(opts,optObj,0);
						for (var i = 0; i < opts.length; i++) {
							pgObj.options[i] = opts[i];
						}
					}
				}
			}
			
			if (isSubMenu) {
				this.onCutToClipboardSubMenu(_v);
			} else {
				if (bool_copy_to_clipboard == true) {
					this.onCutToClipboardMenuItem(_v);
				} else {
					this.onDeleteMenuItem(_v);
				}
			}
			
			bcutObj.disabled = true;
			bcopyObj.disabled = true;
			bcpasteObj.disabled = true;
			if (!!beforeObj) beforeObj.disabled = true;
			if (!!afterObj) afterObj.disabled = true;
			if (!!bfontObj) bfontObj.color = 'silver';
			if (!!afontObj) afontObj.color = 'silver';
	
			var offset = (this._menu_stack.length == 0) ? 0 : 1;
	
			this.performMenuCutAtLevel(sel + offset);
	
			this.populateSelectWithMenu(brObj, c);
			this.rebuildMenu(this.menuArray, false);
		}
	},
	_processMenuCopyToClipboard : function(brObj) {
		var clipObj = $('menu_clipboard');
		var bcutObj = $('menu_cut_to_clipboard');
		var bcopyObj = $(this.const_menu_copy_to_clipboard_symbol);
		if ( (!!brObj) && (!!clipObj) && (!!bcutObj) && (!!bcopyObj) ) {
	
			var t = '';
			var sel = brObj.selectedIndex;
			if (sel != -1) {
				t = brObj.options[sel].text;
			} else {
				sel = 0; // cannot allow -1 which means nothing selected.
			}
			var v = '';
	
			var c = this.retrieveMenuAtLevel(this.menuArray, this._menu_stack, 0);
			var offset = (this._menu_stack.length == 0) ? 0 : 1;
			v = c[sel + offset];
			
			if (this.isClipboardActuallyEmpty()) {
				clipObj.options[0] = null;
			}
			var i = clipObj.options.length;
			this._menu_clipboard[i] = v;
			if (typeof v == const_object_symbol) {
				var _prompt = '';
				var toks = v[0].split('|');
				if (toks.length > 2) {
					_prompt = toks[2].URLDecode().trim();
				}
				v = '(' + _prompt.clipCaselessReplace(this.old_Ellipsis_symbol, '') + ')';
			}
			var oObj = new Option( t, v);
			clipObj.options[i] = oObj;
			clipObj.options[i].selected = false;
			
			clipObj.disabled = false;
			
			bcutObj.disabled = true;
			bcopyObj.disabled = true;
		}
	},
	hideShowMenuSaveButtons : function(bool) { // bool == true controls the hide/show for the real menu save button - the other button follows suit...
		var msbObj1 = $('menu_savedata_button');
		var msbObj2 = $('menu_savedata_button2');
		if ( (!!msbObj1) && (!!msbObj2) ) {
			msbObj1.style.display = ((bool == true) ? const_inline_style : const_none_style);
			msbObj2.style.display = ((bool == true) ? const_none_style : const_inline_style);
		}
	},
	isClipboardPaste : function() { // bool == true controls the hide/show for the real menu save button - the other button follows suit...
		var anObj = $('clipboard_paste_becomes_move'); 
		if (!!anObj) { 
			return (anObj.checked);
		}
		return true; // default is true when there is no other choice available...
	},
	_pasteItemToMenu : function(v, isAfter) {
		var brObj = $('menu_browser');
		if (!!brObj) {
			var sel = brObj.selectedIndex;
			if (brObj.options.length == 0) {
				sel = 0;
				isAfter = false;
			}
			if (sel == -1) {
				sel = 0; // cannot allow -1 which means nothing selected.
			}
			var offset = (this._menu_stack.length == 0) ? 0 : 1;
			if (isAfter == true) {
				offset = sel + 1 + offset;
			} else {
				offset = sel + offset;
			}
			var c = this.performMenuPasteAtLevel(v, offset);
			if (!!c) {
				this.populateSelectWithMenu(brObj, c);
				if (isAfter == false) {
					brObj.options[sel].selected = false;
					if ((sel + 1) < brObj.options.length) {
						sel++;
					}
					brObj.options[sel].selected = true;
				}

				if (this.bool_suppressEvents) return;
				
				if (typeof v == const_object_symbol) {
					this.onCommitSubMenu(v);
				} else {
					this.onCommitMenuItem(v);
				}
				this.rebuildMenu(this.menuArray, false);
			}
		}
	},
	_processClipboardPasteToMenu : function(clipObj) {
		var brObj = $('menu_browser');
		var bcpasteObj = $(menuEditorObj.const_clipboardPasteToMenu$);
		var bcremoveObj = $('clipboard_remove_item');
		var beforeObj = $('clipboard_paste_before');
		var afterObj = $('clipboard_paste_after');
		if ( (!!brObj) && (!!clipObj) && (!!bcpasteObj) && (!!bcremoveObj) ) {
			if (clipObj.selectedIndex != -1) {
				var v = this._menu_clipboard[clipObj.selectedIndex];
				var b = this.isClipboardPaste();
				this._pasteItemToMenu(v, ((!!afterObj) ? afterObj.checked : true));
				if (b) {
					var clipObj = $('menu_clipboard'); 
					if (!!clipObj) { 
						this._processClipboardRemoveSelected(clipObj);
					}
				}
			}
			if (this.isClipboardActuallyEmpty()) {
				this.hideShowMenuSaveButtons(true);
			}
		}
	},
	_processClipboardRemoveSelected : function(clipObj) {
		var brObj = $('menu_browser');
		var bcpasteObj = $(menuEditorObj.const_clipboardPasteToMenu$);
		var bcremoveObj = $('clipboard_remove_item');
		var beforeObj = $('clipboard_paste_before');
		var afterObj = $('clipboard_paste_after');
		var bfontObj = $('clipboard_paste_before_font');
		var afontObj = $('clipboard_paste_after_font');
		if ( (!!brObj) && (!!clipObj) && (!!bcpasteObj) && (!!bcremoveObj) ) {
			var sel = clipObj.selectedIndex;
			if (sel != -1) {
				clipObj.options[sel] = null;
				removeArrayItem(this._menu_clipboard,sel);
	
				if ( (clipObj.options.length == 0) || (this.isClipboardActuallyEmpty()) ) {
					bcpasteObj.disabled = true;
					if (!!beforeObj) beforeObj.disabled = true;
					if (!!afterObj) afterObj.disabled = true;
					bcremoveObj.disabled = true;
					if (!!bfontObj) bfontObj.color = 'silver';
					if (!!afontObj) afontObj.color = 'silver';
				} else {
					bcpasteObj.disabled = false;
					if (!!beforeObj) beforeObj.disabled = false;
					if (!!afterObj) afterObj.disabled = false;
					bcremoveObj.disabled = false;
					if (!!bfontObj) bfontObj.color = 'black';
					if (!!afontObj) afontObj.color = 'black';
				}
				if (clipObj.options.length == 0) {
					optObj = new Option(this.const_ClipboardEmpty_symbol, this.const_ClipboardEmpty_value);
					clipObj.options[0] = optObj;
					clipObj.options[0].selected = true;
				}
			}
		}
	},
	_processSelectedClipboardItem : function(clipObj) {
		var brObj = $('menu_browser');
		var bcpasteObj = $(menuEditorObj.const_clipboardPasteToMenu$);
		var bcremoveObj = $('clipboard_remove_item');
		var beforeObj = $('clipboard_paste_before');
		var afterObj = $('clipboard_paste_after');
		var bfontObj = $('clipboard_paste_before_font');
		var afontObj = $('clipboard_paste_after_font');
		if ( (!!brObj) && (!!clipObj) && (!!bcpasteObj) && (!!bcremoveObj) ) {
			var _text = '';
			if (clipObj.selectedIndex != -1) {
				_text = clipObj.options[clipObj.selectedIndex].text;
			}
			if (_text.toUpperCase() == this.const_ClipboardEmpty_symbol.toUpperCase()) {
				bcremoveObj.disabled = true;
			} else {
				bcremoveObj.disabled = false;
			}
			if ( (brObj.selectedIndex == -1) && (brObj.options.length > 0) ) {
				brObj.options[brObj.options.length - 1].selected = true;
			}
			if ( ( (brObj.selectedIndex == -1) && (brObj.options.length > 0) ) || (bcremoveObj.disabled == true) ) {
				bcpasteObj.disabled = true;
				if (!!beforeObj) beforeObj.disabled = true;
				if (!!afterObj) afterObj.disabled = true;
				if (!!bfontObj) bfontObj.color = 'silver';
				if (!!afontObj) afontObj.color = 'silver';
			} else if (brObj.options.length == 0) {
				bcpasteObj.disabled = false;
				if (!!beforeObj) beforeObj.disabled = true;
				if (!!afterObj) afterObj.disabled = true;
				if (!!bfontObj) bfontObj.color = 'silver';
				if (!!afontObj) afontObj.color = 'silver';
			} else {
				bcpasteObj.disabled = false;
				if (!!beforeObj) beforeObj.disabled = false;
				if (!!afterObj) afterObj.disabled = false;
				if (!!bfontObj) bfontObj.color = 'black';
				if (!!afontObj) afontObj.color = 'black';
			}
			if ( (!!beforeObj) && (!!afterObj) ) {
				if ( (beforeObj.disabled == false) && (afterObj.disabled == false) && (beforeObj.checked == false) && (afterObj.checked == false) ) {
					afterObj.checked = true;
				}
			}
		}
	},
	_processMenuBrowseInto : function(brObj) {
		var bbutObj = $('menu_browse_into');
		var cbutObj = $('menu_browse_out');
		if ( (!!brObj) && (!!bbutObj) && (!!cbutObj) ) {
			if (brObj.selectedIndex != -1) {
				bbutObj.disabled = true;
				cbutObj.disabled = false;
	
				var offset = (this._menu_stack.length == 0) ? 0 : 1;
				this._menu_stack.push(brObj.selectedIndex + offset);

				var s = brObj.options[brObj.selectedIndex].text;
				var o = brObj.options[brObj.selectedIndex].value;
				
				brObj.disabled = true;
				while (brObj.options.length > 0) {
					brObj.options[0] = null;
				}
				
				var c = this.retrieveMenuAtLevel(this.menuArray, this._menu_stack, 0);
				if (!!c) {
					this.populateSelectWithMenu(brObj, c);
					this.onOpenSubMenu(c);
				}
				brObj.disabled = false;
			}
		}
	},
	_ProcessMenuSaveToDatabase : function(mcObj) {
		var clipObj = $('menu_clipboard');
		if (!!clipObj) {
			if ( (clipObj.options.length > 0) && (this.isClipboardActuallyEmpty() == false) ) {
				this.hideShowMenuSaveButtons(false);  // clipboard is not empty so let the user know what's wrong...
			} else {
				if (isObjValidHTMLValueHolder(mcObj)) {
					mcObj.value = this.joinMenu( this.menuArray);
					return true;
				}
			}
		}
		return false;
	},
	_processCancelMenuItemEditor : function() {
		var eObj = $('_menu_item_editor');
		var ebutObj = $('_menu_item_editor_button');
		var abutObj = $('_menu_item_additor_button');
		var asbutObj = $('_menu_submenu_additor_button');
		var clipObj = $('menu_clipboard'); 
		var brObj = $('menu_browser'); 
		if ( (!!eObj) && (!!ebutObj) && (!!abutObj) && (!!asbutObj) && (!!clipObj) && (!!brObj) ) { 
			eObj.style.display = const_none_style;
			
			if (this.bool_autoHideShowEditorFormButtons) {
				ebutObj.style.display = const_inline_style; 
				abutObj.style.display = const_inline_style; 
				asbutObj.style.display = const_inline_style; 
			}
	
			var a = -1;
			while (this._menu_widgets_stack.length > 0) {
				a = this._menu_widgets_stack.pop();
				var anObj = $(a[0]);
				if (!!anObj) {
					anObj.disabled = a[1];
				}
			}
	
			var pgObj = $('menu_item_editor_pageList');
			if (!!pgObj) {
				while (this._stack_remember_to_remove_from_pglist.length > 0) {
					a = this._stack_remember_to_remove_from_pglist.pop();
					for (var i = 0; i < pgObj.options.length; i++) {
						if (pgObj.options[i].text.trim().toUpperCase() == a.text.trim().toUpperCase()) {
							pgObj.options[i] = null;
							break;
						}
					}
				}
			}
	
			this.processSelectedmenuItem(brObj);
			this._processSelectedClipboardItem(clipObj);
		}
	},
	_processSaveMenuItemEditor : function() {
		var brObj = $('menu_browser');
		var epObj = $('_menu_item_editor_prompt');
		var iObj = $('_menu_item_editor_internal');
		var pgObj = $('menu_item_editor_pageList');
		var hObj = $('menu_item_editor_http');
		if ( (!!epObj) && (!!brObj) && (!!pgObj) && (!!hObj) ) {
			var c = this.retrieveMenuAtLevel(this.menuArray, this._menu_stack, 0);
			if (!!c) {
				var offset = (this._menu_stack.length == 0) ? 0 : 1;
				var sel = brObj.selectedIndex;
				if (sel < 0) {
					sel = 0;
				}
				if ( (this.isAddingMenuItem == false) && (this.isAddingMenuSubMenu == false) ) {
					var v = c[sel + offset];
					var _v = v;

					var _isSubMenu = false;
					if (typeof v == const_object_symbol) {
						v = v[0];
						_isSubMenu = true;
					}

					var _prompt = epObj.value.URLDecode().trim();
					if (_prompt.length == 0) {
						_prompt = ' ';
					}
					
					if (this.bool_useUUID_nodeIDs) {
						var ar = v.split('|');

						var v = this.const_UUID_symbol + '|' + ((ar.length == 3) ? ar[1] : uuid()) + '|' + _prompt.stripIllegalChars();
					} else {
						var _url = ' ';
						var _target = ' ';
						if ( (!!iObj) && (iObj.checked == true) ) {
							_url = const_cgi_script_name_symbol + this.const_currentPage_symbol + pgObj.options[pgObj.selectedIndex].text.trim();
							_target = '_top';
						} else {
							_url = hObj.value.URLDecode().trim();
							_target = '_new';
						}
						// _prompt must NOT contain (|) or (,) characters or bad evil things will happen to the integrity of the menu data model due to the lists being used that use both characters...
						if ( (_url.toUpperCase().indexOf(const_http_symbol.toUpperCase()) == -1) && (_url.toUpperCase().indexOf(const_https_symbol.toUpperCase()) == -1) && (_url.toUpperCase().indexOf(const_mailto_symbol.toUpperCase()) == -1) && (_url.toUpperCase().indexOf(const_ftp_symbol.toUpperCase()) == -1) ) {
							_url = const_http_symbol + _url;
						}
						var v = _url.stripIllegalChars() + '|' + _target + '|' + _prompt.stripIllegalChars();
					}
					if (_isSubMenu) {
						_v[0] = v;
						c[sel + offset] = _v;
						this.onChangeSubMenu(v);
					} else {
						c[sel + offset] = v;
						this.onChangeMenuItem(v);
					}
					this.populateSelectWithMenu(brObj, c);
					this.rebuildMenu(this.menuArray, false);
				} else if (this.isAddingMenuItem == true) {
					var _prompt = epObj.value.URLDecode().trim();
					if (_prompt.length == 0) {
						_prompt = ' ';
					}
					if (this.bool_useUUID_nodeIDs) {
						var v = this.const_UUID_symbol + '|' + uuid() + '|' + _prompt.stripIllegalChars();
					} else {
						var _url = ' ';
						var _target = ' ';
						if ( (!!iObj) && (iObj.checked == true) ) {
							_url = const_cgi_script_name_symbol + this.const_currentPage_symbol + pgObj.options[pgObj.selectedIndex].text.trim();
							_target = '_top';
						} else {
							_url = hObj.value.URLDecode().trim();
							_target = '_new';
						}
						var v = _url.stripIllegalChars() + '|' + _target + '|' + _prompt.stripIllegalChars();
					}
					this._pasteItemToMenu(v, true);
					if (pgObj.selectedIndex != -1) {
						pgObj.options[pgObj.selectedIndex] = null;
					}
				} else if (this.isAddingMenuSubMenu == true) {
					var _prompt = epObj.value.URLDecode().trim();
					if (_prompt.length == 0) {
						_prompt = ' ';
					}

					this._pasteSubMenuToMenu(_prompt, true);	
				}
			}
		}
	
		return this._processCancelMenuItemEditor();
	},
	_refreshUrlType : function(_url) {
		var tlObj = $(this.const_menu_url_typelist);
		if (!!tlObj) {
			var val = '';
			var isAnySelected = false;
			for (var i = 0; i < tlObj.options.length; i++) {
				val = tlObj.options[i].value.trim();
				if ( (val.length > 0) && (_url.trim().toUpperCase().indexOf(val.toUpperCase()) != -1) ) {
					isAnySelected = true;
					break;
				}
			}
	
			if (isAnySelected == false) {
				i = -1;
			}
			for (var j = 0; j < tlObj.options.length; j++) {
				tlObj.options[j].selected = ((j == i) ? true : false);
			}
			if (isAnySelected == false) {
				tlObj.options[0].selected = true;
			}
		}
	},
	__refreshUrlType : function() {
		var hObj = $('menu_item_editor_http');
		if (!!hObj) {
			this._refreshUrlType(hObj.value.trim());
		}
	},
	_processChangedUrlType : function() {
		var hObj = $('menu_item_editor_http');
		var tlObj = $(this.const_menu_url_typelist);
		if ( (!!hObj) && (!!tlObj) ) {
			var sel = tlObj.selectedIndex;
			if (sel != -1) {
				var val = tlObj.options[sel].value.trim();
				if (val.trim().length == 0) {
					var a = hObj.value.trim().split(':');
					if (a.length > 1) {
						hObj.value = a[1];
					}
					var i_slashes = hObj.value.trim().indexOf('\/\/');
					if (i_slashes != -1) {
						hObj.value = hObj.value.replaceSubString(i_slashes, i_slashes + 2, '');
					}
				} else {
					if (hObj.value.trim().length > 0) {
						var a = hObj.value.trim().split(':');
						if (a.length > 1) {
							var b = val.trim().split(':');
							if (b.length > 1) {
								hObj.value = b[0] + ':' + a[1];
								i_slashes = hObj.value.trim().indexOf('\/\/');
								if ( (b[1].trim().length == 0) && (i_slashes != -1) ) {
									hObj.value = hObj.value.replaceSubString(i_slashes, i_slashes + 2, '');
								}
							}
							var i_slashes_t = val.trim().indexOf('\/\/');
							var i_slashes_u = hObj.value.trim().indexOf('\/\/');
							if ( (i_slashes_t != -1) && (i_slashes_u == -1) ) {
								var aa = hObj.value.trim().split(':');
								if (aa.length > 1) {
									hObj.value = aa[0] + ':' + '\/\/' + aa[1];
								}
							}
						} else {
							if (hObj.value.trim().toUpperCase().indexOf(val.trim().toUpperCase()) == -1) {
								hObj.value = val.trim() + hObj.value;
							}
						}
					} else {
						hObj.value = val;
					}
				}
			}
		}
	},
	processMenuEditorCheckLinkType : function() {
		var iObj = $('_menu_item_editor_internal');
		var eObj = $('_menu_item_editor_external');
		var pObj = $('menu_item_editor_pageList_pane');
		var phObj = $('menu_item_editor_http_pane');
		var pgObj = $('menu_item_editor_pageList');
		var hObj = $('menu_item_editor_http');
		if ( (!!iObj) && (!!eObj) && (!!pObj) && (!!phObj) && (!!pgObj) && (!!hObj) ) {
			pObj.style.display = (iObj.checked == true) ? const_inline_style : const_none_style;
			pgObj.style.display = (iObj.checked == true) ? const_inline_style : const_none_style;
			phObj.style.display = (eObj.checked == true) ? const_inline_style : const_none_style;
			hObj.style.display = (eObj.checked == true) ? const_inline_style : const_none_style;
			this._refreshMenuItemEditorSaveButton();
		}
	},
	_processMenuItemEditor : function(brObj) {
		var ebObj = $('_menu_item_editor_button');
		var abObj = $('_menu_item_additor_button'); 
		var asObj = $('_menu_submenu_additor_button');
		var edObj = $('_menu_item_editor');
		var epObj = $('_menu_item_editor_prompt');
		var clipObj = $('menu_clipboard');
		var iObj = $('_menu_item_editor_internal');
		var eObj = $('_menu_item_editor_external');
		var ifontObj = $('_menu_item_editor_internal_font');
		var efontObj = $('_menu_item_editor_external_font');
		var pgObj = $('menu_item_editor_pageList');
		var hObj = $('menu_item_editor_http');
		if ( (!!brObj) && (!!ebObj) && (!!abObj) && (!!asObj) && (!!edObj) && (!!epObj) && (!!clipObj) && (!!pgObj) && (!!hObj) ) {
			edObj.style.display = const_inline_style;
			
			if (this.bool_autoHideShowEditorFormButtons) {
				ebObj.style.display = const_none_style;
				abObj.style.display = const_none_style;
				asObj.style.display = const_none_style;
			}
	
			var c = this.retrieveMenuAtLevel(this.menuArray, this._menu_stack, 0);
			if (!!c) {
				var offset = (this._menu_stack.length == 0) ? 0 : 1;
				var _prompt = '';
				var _url = '';
				var i_checked = true;
				var e_checked = false;
	
				var sel = brObj.selectedIndex;
				if (sel == -1) {
					sel = 0;
				}
	
				var v = c[sel + offset];
				var _isSubMenu = false;
				if (typeof v == const_object_symbol) {
					v = v[0];
					_isSubMenu = true;
				}
	
				if ( (this.isAddingMenuItem == true) || (this.isAddingMenuSubMenu == true) ) {
					// adding something means we don't care about the current item that's in the menu...
					v = '';
					_isSubMenu = false;
				}
	
				var toks = v.split('|');
				if (toks.length > 1) {
					_url = toks[0].URLDecode().trim();
				}
				hObj.value = _url;
				this._refreshUrlType(_url);
	
				if (_isSubMenu == false) {
					if (_url.toUpperCase().indexOf(this.const_currentPage_symbol.trim().toUpperCase()) != -1) {
						i_checked = true;
						e_checked = false;
						var _url_toks = _url.split('?');
						if (_url_toks.length > 1) {
							var _url_toks2 = _url_toks[1].split('=');
							if (_url_toks2.length > 1) {
								_url = _url_toks2[1];
								if (pgObj.selectedIndex != -1) {
									pgObj.options[pgObj.selectedIndex].selected = false;
								}
								var optObj = new Option(_url, _url);
								var opts = [];
								for (var i = 0; i < pgObj.options.length; i++) {
									opts.push(pgObj.options[i]);
								}
								while (pgObj.options.length > 0) {
									pgObj.options[0] = null;
								}
								insertArrayItem(opts,optObj,0);
								this._stack_remember_to_remove_from_pglist.push(optObj);
								for (var i = 0; i < opts.length; i++) {
									pgObj.options[i] = opts[i];
								}
								pgObj.options[0].selected = true;
								hObj.value = '';
							}
						}
					} else {
						i_checked = false;
						e_checked = true;
	
						if (pgObj.selectedIndex != -1) {
							pgObj.options[pgObj.selectedIndex].selected = false;
						}
					}
				}
	
				if (toks.length > 2) {
					_prompt = toks[2].URLDecode().trim();
				}
				epObj.value = _prompt;
	
				if (this.isAddingMenuItem == true) {
					if (!!iObj) iObj.style.display = const_inline_style;
					if (!!eObj) eObj.style.display = const_inline_style;
					if (!!ifontObj) ifontObj.style.display = const_inline_style;
					if (!!efontObj) efontObj.style.display = const_inline_style;
					pgObj.style.display = (i_checked) ? const_inline_style : const_none_style;
					hObj.style.display = (e_checked) ? const_inline_style : const_none_style;
	
					epObj.value = '';
					if (!!iObj) iObj.checked = i_checked;
					if (!!eObj) eObj.checked = e_checked;
					hObj.value = const_http_symbol;
					pgObj.selectedIndex = -1;
					this.__refreshUrlType();
				} else if ( (this.isAddingMenuSubMenu == true) || (_isSubMenu == true) ) {
					if (!!iObj) iObj.style.display = const_none_style;
					if (!!eObj) eObj.style.display = const_none_style;
					if (!!ifontObj) ifontObj.style.display = const_none_style;
					if (!!efontObj) efontObj.style.display = const_none_style;
					pgObj.style.display = const_none_style;
					hObj.style.display = const_none_style;
	
					if ( (this.isAddingMenuSubMenu == true) || (_isSubMenu == true) ) {
						if (!!iObj) iObj.checked = false;
						if (!!eObj) eObj.checked = false;
					} else if (_isSubMenu == false) {
						epObj.value = '';
					}
				} else if ( (this.isAddingMenuItem == false) && (this.isAddingMenuSubMenu == false) ) {
					// need to determine if this is a submenu or a menuitem and then handle each accordingly...
					if (!!iObj) iObj.style.display = const_inline_style;
					if (!!eObj) eObj.style.display = const_inline_style;
					if (!!ifontObj) ifontObj.style.display = const_inline_style;
					if (!!efontObj) efontObj.style.display = const_inline_style;
					if (!!iObj) iObj.checked = i_checked;
					if (!!eObj) eObj.checked = e_checked;
					pgObj.style.display = (i_checked) ? const_inline_style : const_none_style;
					hObj.style.display = (e_checked) ? const_inline_style : const_none_style;
				}
	
				this.processMenuEditorCheckLinkType();
	
				setFocusSafely(epObj);
	
				var b1Obj = $('menu_browse_into');
				var b2Obj = $('menu_browse_out');
				var b3Obj = $('menu_cut_to_clipboard');
				var b3Obj = $(this.const_menu_copy_to_clipboard_symbol);
				var b4Obj = $(menuEditorObj.const_clipboardPasteToMenu$);
				var r1Obj = $('clipboard_paste_before');
				var r2Obj = $('clipboard_paste_after');
				var b5Obj = $('menu_cut_to_clipboard');
				if ( (!!b1Obj) && (!!b2Obj) && (!!b3Obj) && (!!b4Obj) && (!!b5Obj) && (!!r1Obj) && (!!r2Obj) ) {
					var a = new Array(0);
					a[0] = b1Obj.id;
					a[1] = b1Obj.disabled;
					this._menu_widgets_stack.push(a);
	
					b1Obj.disabled = true;
	
					var a = new Array(0);
					a[0] = b2Obj.id;
					a[1] = b2Obj.disabled;
					this._menu_widgets_stack.push(a);
	
					b2Obj.disabled = true;
	
					var a = new Array(0);
					a[0] = b3Obj.id;
					a[1] = b3Obj.disabled;
					this._menu_widgets_stack.push(a);
	
					b3Obj.disabled = true;
	
					var a = new Array(0);
					a[0] = b4Obj.id;
					a[1] = b4Obj.disabled;
					this._menu_widgets_stack.push(a);
	
					b4Obj.disabled = true;
	
					var a = new Array(0);
					a[0] = b5Obj.id;
					a[1] = b5Obj.disabled;
					this._menu_widgets_stack.push(a);
	
					b5Obj.disabled = true;
	
					var a = new Array(0);
					a[0] = r1Obj.id;
					a[1] = r1Obj.disabled;
					this._menu_widgets_stack.push(a);
	
					r1Obj.disabled = true;
	
					var a = new Array(0);
					a[0] = r2Obj.id;
					a[1] = r2Obj.disabled;
					this._menu_widgets_stack.push(a);
	
					r2Obj.disabled = true;
				}
	
				var a = new Array(0);
				a[0] = clipObj.id;
				a[1] = clipObj.disabled;
				this._menu_widgets_stack.push(a);
				clipObj.disabled = true;
	
				var a = new Array(0);
				a[0] = brObj.id;
				a[1] = brObj.disabled;
				this._menu_widgets_stack.push(a);
				brObj.disabled = true;
			}
		}
	},
	_processMenuSubMenuAdditor : function(brObj) {
		var tObj = $('_menu_item_editor_title');
		if (!!tObj) {
			flushGUIObjectChildrenForObj(tObj);
			tObj.innerHTML = '<small><b>Add Empty SubMenu</b></small>';
		}
		this.isAddingMenuSubMenu = true;
		this.isAddingMenuItem = false;
		return this._processMenuItemEditor(brObj);
	},
	_processMenuItemAdditor : function(brObj) {
		var tObj = $('_menu_item_editor_title');
		if (!!tObj) {
			flushGUIObjectChildrenForObj(tObj);
			tObj.innerHTML = '<small><b>Add Menu Item</b></small>';
		}
		this.isAddingMenuItem = true;
		this.isAddingMenuSubMenu = false;
		return this._processMenuItemEditor(brObj);
	},
	__processMenuItemEditor : function(brObj) {
		var tObj = $('_menu_item_editor_title');
		if (!!tObj) {
			flushGUIObjectChildrenForObj(tObj);
			tObj.innerHTML = '<small><b>Edit Menu Item</b></small>';
		}
		this.isAddingMenuItem = false;
		this.isAddingMenuSubMenu = false;
		return this._processMenuItemEditor(brObj);
	},
	_refreshMenuItemEditorSaveButton : function() {
		var iObj = $('_menu_item_editor_internal');
		var pgObj = $('menu_item_editor_pageList');
		var sbObj = $(this.const_menu_item_editor_saveButton);
		var prObj = $('_menu_item_editor_prompt');
		var hObj = $('menu_item_editor_http');
		if ( (!!pgObj) && (!!sbObj) && (!!prObj) && (!!hObj) ) {
			if (this.isAddingMenuItem == true) {
				if ( (!!iObj) && (iObj.checked == true) ) {
					if ( (pgObj.selectedIndex != -1) && (prObj.value.trim().length > 0) ) {
						sbObj.disabled = false;
					} else {
						sbObj.disabled = true;
					}
				} else {
					if ( (prObj.value.trim().length > 0) && (hObj.value.trim().length > 0) ) {
						sbObj.disabled = false;
					} else {
						sbObj.disabled = true;
					}
				}
			} else {
				sbObj.disabled = false;
			}
		}
	},
	_processMenuBrowseOut : function(brObj) {
		var cbutObj = $('menu_browse_out');
		if ( (!!brObj) && (!!cbutObj) ) {
			var i = this._menu_stack.pop();
			if (this._menu_stack.length == 0) {
				cbutObj.disabled = true;
			}
	
			brObj.disabled = true;
			while (brObj.options.length > 0) {
				brObj.options[0] = null;
			}
			
			var c = this.retrieveMenuAtLevel(this.menuArray, this._menu_stack, 0);
			if (!!c) {
				var bObj = $('menu_browser');
				if (!!bObj) {
					this.populateSelectWithMenu(bObj, c);
					this.onCloseSubMenu(c);
				}
			}
			brObj.disabled = false;
		}
	},
	__pasteSubMenuToMenu : function(v, isAfter) {
		var _empty_subMenu = new Array(0);

		_empty_subMenu[0] = v;

		var _url = ' ';
		var _target = ' ';
		var _prompt = 'placeholder';
		if (_prompt.length == 0) {
			_prompt = ' ';
		}
		var v = _url.stripIllegalChars() + '|' + _target + '|' + _prompt.stripIllegalChars();

		_empty_subMenu[1] = v;
		_empty_subMenu[2] = this.const_subMenuEnds_symbol;

		this._pasteItemToMenu(_empty_subMenu, true);
	},
	_pasteSubMenuToMenu : function(_prompt, isAfter) {
		var _url = this.const_subMenu_symbol;

		if (this.bool_useUUID_nodeIDs) {
			var v = _url.stripIllegalChars() + '|' + uuid() + '|' + _prompt.stripIllegalChars();
		} else {
			var _target = ' ';
			var v = _url.stripIllegalChars() + '|' + _target + '|' + _prompt.stripIllegalChars();
		}
		this.__pasteSubMenuToMenu(v, isAfter);
	},
	processMenuModeChange : function() {
		this._global_menu_mode = ((this._global_menu_mode == true) ? false : true);
		this.rebuildMenu(this.menuArray, true);
	},
	retrieveMenuPrompt : function(mm) {
		if (typeof mm[0] == const_object_symbol) {
			return this.retrieveMenuPrompt(mm[0]);
		} else {
			var toks = mm[0].split('|');
			if (toks.length > 2) {
				return toks[2].trim();
			}
		}
		return '';
	},
	retrieveMenuAtLevel : function(mm, stack, i) {
		var c = mm;
		if (stack.length > 0) {
			c = mm[stack[i]];
			i++;
			if (i < stack.length) {
				return this.retrieveMenuAtLevel(c, stack, i);
			}
		}
		this._menu_in_browser = c;
		return c;
	},
	trueItemCountOfMenuContainer : function(m) {
		var a = [];
		var cnt = 0;
		if (m.length > 1) {
			for (var i = 1; i < m.length; i++) {
				var o = m[i];
				if ( (typeof o != const_object_symbol) && (!!o) ) {
					a = o.split('|');
					if (a.length == 3) {
						if ( (a[0].toString().trim().length > 0) && (a[0].toString().trim().toUpperCase() != this.const_subMenuEnds_symbol.trim().toUpperCase()) ) {
							cnt++;
						}
					}
				}
			}
		}
		return cnt;
	},
	processSelectedmenuItem : function(brObj) {
		var clipObj = $('menu_clipboard');
		var bbutObj = $('menu_browse_into');
		var bcutObj = $('menu_cut_to_clipboard');
		var bcopyObj = $(this.const_menu_copy_to_clipboard_symbol);
		var bcpasteObj = $(menuEditorObj.const_clipboardPasteToMenu$);
		var beforeObj = $('clipboard_paste_before');
		var afterObj = $('clipboard_paste_after');
		var bfontObj = $('clipboard_paste_before_font');
		var afontObj = $('clipboard_paste_after_font');
		var edmiObj = $('edit_menu_item');
		var abObj = $('addit_menu_item'); 
		var asObj = $('addit_menu_submenu');
		if ( (!!brObj) && (!!bbutObj) && (!!bcutObj) && (!!bcopyObj) && (!!edmiObj) && (!!abObj) && (!!asObj) ) {
			if (brObj.selectedIndex > -1) {
				var s = brObj.options[brObj.selectedIndex].text;
				var o = brObj.options[brObj.selectedIndex].value;
				if (o == const_object_symbol) {
					bbutObj.disabled = false;
					// disable the delete item button here, unless the submenu is empty ?!?
					var c = this.retrieveMenuAtLevel(this.menuArray, this._menu_stack, 0);
					var offset = (this._menu_stack.length == 0) ? 0 : 1;
					var m = c[brObj.selectedIndex + offset];
					var cnt = this.trueItemCountOfMenuContainer(m);
					bcopyObj.disabled = ((cnt == 0) ? false : true);
				} else {
					bbutObj.disabled = true;
					// enable the delete item button here
					bcopyObj.disabled = false;
				}
				edmiObj.disabled = false;
				bcutObj.disabled = false;
				abObj.disabled = false;
				asObj.disabled = false;
				if ( (!!clipObj) && ( (clipObj.selectedIndex == -1) || (this.isClipboardActuallyEmpty()) ) ) {
					if (!!bcpasteObj) bcpasteObj.disabled = true;
					if (!!beforeObj) beforeObj.disabled = true;
					if (!!afterObj) afterObj.disabled = true;
					if (!!bfontObj) bfontObj.color = 'silver';
					if (!!afontObj) afontObj.color = 'silver';
				} else {
					if (!!bcpasteObj) bcpasteObj.disabled = false;
					if (!!beforeObj) beforeObj.disabled = false;
					if (!!afterObj) afterObj.disabled = false;
					if (!!bfontObj) bfontObj.color = 'black';
					if (!!afontObj) afontObj.color = 'black';
				}
			} else {
				edmiObj.disabled = true;
				bcutObj.disabled = true;
				bcopyObj.disabled = true;
				if (!!bcpasteObj) bcpasteObj.disabled = true;
				if (!!beforeObj) beforeObj.disabled = true;
				if (!!afterObj) afterObj.disabled = true;
				if (!!bfontObj) bfontObj.color = 'silver';
				if (!!afontObj) afontObj.color = 'silver';
			}
		}
	},
	populateSelectWithMenu : function(bObj, mm) {
		if (!!bObj) {
			var oObj;
			var _prompt;
			var toks;
			var option_index_i = 0;
	
			var sel = bObj.selectedIndex;
			bObj.disabled = true;
			while (bObj.options.length > 0) {
				bObj.options[0] = null;
			}
	
			for (var i = (this._menu_stack.length == 0) ? 0 : 1; i < mm.length; i++) {
				if (!!mm[i]) {
					if (typeof mm[i] == const_object_symbol) {
						var c = mm[i];
						_prompt = '(' + this.retrieveMenuPrompt(c).URLDecode().clipCaselessReplace(this.old_Ellipsis_symbol, '') + ')';
					} else {
						toks = mm[i].split('|');
						_prompt = '';
						if (toks.length > 2) {
							_prompt = toks[2].URLDecode().trim();
						}
					}
					if (_prompt.length > 0) {
						oObj = new Option( _prompt, typeof mm[i]);
						bObj.options[option_index_i] = oObj;
						bObj.options[option_index_i].selected = ((sel == -1) ? false : ((sel == option_index_i) ? true : false));
						option_index_i++;
					}
				}
			}
			bObj.disabled = false;
			this.processSelectedmenuItem(bObj);
		}
	},
	_handle_menuBrowser_dblclick : function() { // bool == true controls the hide/show for the real menu save button - the other button follows suit...
		var brObj = $('menu_browser'); 
		if (brObj != null) { 
			if (brObj.selectedIndex > -1) {
				var o = brObj.options[brObj.selectedIndex].value;
				if (o == const_object_symbol) {
					this._processMenuBrowseInto(brObj);
				}
			}
		} 
		
		return false;
	},
	_handle_menuBrowser_change : function() {
		var brObj = $('menu_browser'); 
		if (!!brObj) { 
			this.processSelectedmenuItem(brObj);
		} 
		
		return false;
	},
	initMenuEditorClipboardObjects : function() {
		var dObj = $(this.div_menuBrowserID);
		if (!!dObj) {
			flushGUIObjectChildrenForObj(dObj);
			dObj.innerHTML = '<select id="' + this.menuBrowserID + '" size="10" style="font-size: 10px; line-height: 10px; width: 100%;" ondblclick="return menuEditorObj.handle_menuBrowser_dblclick(menuEditorObj.$[' + this.id + ']);" onchange="return menuEditorObj.handle_menuBrowser_change(menuEditorObj.$[' + this.id + ']);"></select>';
	
			var bObj = $(this.menuBrowserID);
			if (!!bObj) {
				this.populateSelectWithMenu(bObj, this.menuArray);
			}
		}

		var rObj = $('rightmenu_wrapper');
		if (!!rObj) {
			var html = '';
			html += '<div id="right_side_content">';
			html += '<div id="welcome">';
			html += '</div>';
			html += '<table cellpadding="-1" cellspacing="-1">';
			html += '<tr>';
			html += '<td>';
		
			html += '<table cellpadding="-1" cellspacing="-1">';
			html += '<tr>';
			html += '<td>';
			html += '<center>';
			html += '<select id="menu_clipboard" size="5" style="font-size: 10px; line-height: 10px;" onchange="var clipObj = $(\'menu_clipboard\'); if (!!clipObj) { menuEditorObj.processSelectedClipboardItem(clipObj, menuEditorObj.$[' + this.id + ']) } return false;">';
			html += '</select>';
			html += '</center>';
			html += '</td>';
			html += '</tr>';
		
			html += '<tr>';
			html += '<td>';
			html += '<input type="button" id="clipboard_remove_item" value="Remove Clipboard Item" disabled class="buttonClass" onClick="var clipObj = $(\'menu_clipboard\'); if (!!clipObj) { menuEditorObj.processClipboardRemoveSelected(clipObj, menuEditorObj.$[' + this.id + ']) } return false;">';
			html += '</td>';
			html += '</tr>';
		
			html += '<tr>';
			html += '<td>';
		
			html += '<table cellpadding="-1" cellspacing="-1">';
			html += '<tr>';
			html += '<td>';
			var _html = _setup_tooltip_handlers(menuEditorObj.const_clipboardPasteToMenu$, this.const_empty_symbol);
			html += '<input type="button" ' + _html + ' disabled value="Paste to Menu" class="buttonClass" title="Click this button to move a Menu Item or SubMenu Item from the ClipBoard to the Menu perhaps to a different position than the item had been in originally for the purpose or reorganizing or reordering the Menu." onClick="var clipObj = $(\'menu_clipboard\'); if (!!clipObj) { menuEditorObj.processClipboardPasteToMenu(clipObj, menuEditorObj.$[' + this.id + ']) } return false;">';
	
			html += '</td>';
			html += '<td>';
	
			html += '<table cellpadding="-1" cellspacing="-1">';
			html += '<tr>';
			html += '<td>';
			html += '<div id="div_clipboard_paste_before_caption"></div>';
			html += '</td>';
			html += '</tr>';
			html += '<tr>';
			html += '<td>';
			html += '<div id="div_clipboard_paste_after_caption"></div>';
			html += '</td>';
			html += '</tr>';
			html += '</table>';
		
			html += '</td>';
			html += '</tr>';
			html += '</table>';
		
			html += '</td>';
			html += '</tr>';
			html += '<tr>';
			html += '<td>';
			html += '<div style="display: none;">'; // this option is hidden due to a design change
			html += '<NOBR><input type="checkbox" id="clipboard_paste_becomes_move" value="MOVE" alt="(Plus sign means auto-Remove from ClipBoard)" onClick="var anObj = $(\'clipboard_paste_becomes_move\'); if (!!anObj) { menuEditorObj.processClipboardPasteBecomesMove(anObj); setCookie(this.const_ClipboardPasteMode_symbol, anObj.checked, this.const_forward_slash_symbol); } return true;">&nbsp;<span id="clipboard_paste_becomes_move_div" style="line-height: 10px;"><font size="-1" id="clipboard_paste_becomes_move_font"><small><b>Clipboard Paste to Menu with auto-Remove</b></small></font></span></NOBR>';
			html += '</div>';
			html += '</td>';
			html += '</tr>';
			html += '</table>';
		
			html += '</td>';
			html += '</tr>';
			html += '</table>';
			html += '</div>';
			flushGUIObjectChildrenForObj(rObj);
			rObj.innerHTML = html;
			
			// BEGIN: Initialize this item...
			var anObj = $('clipboard_paste_becomes_move'); 
			if (!!anObj) { 
				var c = getCookie(this.const_ClipboardPasteMode_symbol);
				if ( (!!c) && (c.length > 0) ) {
					anObj.checked = eval(c);
				}
				menuEditorObj.processClipboardPasteBecomesMove(anObj);
			} else {
				alert('ERROR: Programming Error - Missing div named (clipboard_paste_becomes_move).');
			}
			anObj.checked = true;
			menuEditorObj.processClipboardPasteBecomesMove(anObj);
			// END! Initialize this item...
		
			var sObj = $('menu_clipboard');
			var beforeObj = $('clipboard_paste_before');
			var afterObj = $('clipboard_paste_after');
			var bfontObj = $('clipboard_paste_before_font');
			var afontObj = $('clipboard_paste_after_font');
			if (!!sObj) {
				var optObj;
				if (sObj.options.length == 0) {
					optObj = new Option(this.const_ClipboardEmpty_symbol, this.const_ClipboardEmpty_value);
					sObj.options[0] = optObj;
					sObj.options[0].selected = true;
				}
				sObj.disabled = true;
				if (!!beforeObj) {
					beforeObj.checked = true;
					beforeObj.disabled = true;
				}
				if (!!bfontObj) {
					bfontObj.color = 'silver';
				}
				if (!!afterObj) {
					afterObj.checked = false;
					afterObj.disabled = true;
				}
				if (!!afontObj) {
					afontObj.color = 'silver';
				}
			} else {
				alert('ERROR: Programming Error - Missing div named (menu_clipboard).');
			}
		} else {
			alert('ERROR: Programming Error - Missing div named (rightmenu_wrapper).');
		}
	
		var criObj = $('clipboard_remove_item');
		if (!!criObj) {
			// it was deemed "just too easy" for the end-user to delete items with this button active however allowing them to delete right from the menu was deemed okay ?!?  Go figure !
			criObj.style.display = const_none_style;
		} else {
			alert('ERROR: Programming Error - Missing div named (clipboard_remove_item).');
		}
		
		var eObj = $('_menu_item_editor');
		if (!!eObj) {
			var html = '';
		
			var pListObj = $('_GetCurrentContent_pageList');
			var pnListObj = $('_GetCurrentContent_notLinkables');
			if ( (isObjValidHTMLValueHolder(pListObj)) && (isObjValidHTMLValueHolder(pnListObj)) ) {
				var s = pListObj.value;
				var sn = pnListObj.value;
	
				html += '<form>';
				html += '<table cellpadding="-1" cellspacing="-1">';
				html += '<tr bgcolor="#c0c0c0">';
				html += '<td align="center">';
				html += '<div id="_menu_item_editor_title">';
				html += '<small><b>Edit Menu Item</b></small>';
				html += '</div>';
				html += '</td>';
				html += '</tr>';
				html += '<tr>';
				html += '<td align="left">';
				html += '<font size="1"><small><b>Prompt:</b></small></font>&nbsp;<input type="text" id="_menu_item_editor_prompt" size="39" maxlength="50" class="textEntryClass" onkeyup="menuEditorObj.refreshMenuItemEditorSaveButton(menuEditorObj.$[' + this.id + ']); return true;">';
				html += '</td>';
				html += '</tr>';
		
				html += '<tr>';
				html += '<td align="left">';
				html += '<table cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td>';
				html += '<div id="div_menu_item_editor_internal"></div>';
				html += '</td>';
				html += '<td>';
				html += '<div id="div_menu_item_editor_external"></div>';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
				html += '</td>';
				html += '</tr>';
		
				html += '<tr>';
				html += '<td align="left">';
				html += '<div id="menu_item_editor_pageList_pane" style="display: none;">';
				html += '<select id="menu_item_editor_pageList" size="4" style="font-size: 10px; line-height: 10px;" onchange="menuEditorObj.refreshMenuItemEditorSaveButton(menuEditorObj.$[' + this.id + ']); return true;">';
				html += '</select>';
				html += '</div>';
	
				html += '<div id="menu_item_editor_http_pane" style="display: none;">';
				html += '<table cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td valign="middle">';
				var _html = 'id="' + this.const_menu_url_typelist + '"';
				html += '<select ' + _html + ' size="1" style="font-size: 10px; line-height: 10px;" onchange="menuEditorObj.processChangedUrlType(menuEditorObj.$[' + this.id + ']); return true;">';
				html += '</select>';
				html += '</td>';
				html += '</tr>';
				html += '<tr>';
				html += '<td>';
				html += '<table cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td>';
				html += '<textarea cols="35" rows="5" name="menu_item_editor_http" wrap="soft" style="font-size: 10px; line-height: 10px;" onkeyup="menuEditorObj._refreshUrlType(menuEditorObj.$[' + this.id + ']); menuEditorObj.refreshMenuItemEditorSaveButton(menuEditorObj.$[' + this.id + ']); return true;"></textarea>';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
				html += '</div>';
	
				html += '</td>';
				html += '</tr>';
		
				html += '<tr>';
				html += '<td align="center" colspan="2">';
				html += '<table cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td>';
				var _html = _setup_tooltip_handlers(this.const_menu_item_editor_saveButton, this.const_positional_delayed_tooltips4);
				html += '<input type="button" ' + _html + ' disabled value="[Save]" class="buttonClass" title="Click this button to Save the Menu Item in the Menu.  Typically this button is used to Save any changes made to the Menu Item you may have been editing or adding to the Menu." onClick="menuEditorObj.processSaveMenuItemEditor(menuEditorObj.$[' + this.id + ']); return false;">';
				html += '</td>';
				html += '<td>';
				html += '&nbsp;';
				html += '</td>';
				html += '<td>';
				var _html = _setup_tooltip_handlers(this.const_menu_item_editor_cancelButton, this.const_positional_delayed_tooltips4);
				html += '<input type="button" ' + _html + ' value="' + this.const_cancelButton_symbol + '" class="buttonClass" title="Click this button to Cancel the operation currently in-process." onClick="menuEditorObj.processCancelMenuItemEditor(menuEditorObj.$[' + this.id + ']); return false;">';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
				html += '</form>';
		
				flushGUIObjectChildrenForObj(eObj);
				eObj.innerHTML = html;
		
				var eObj = $('menu_item_editor_pageList');
				var sbObj = $(this.const_menu_item_editor_saveButton);
				if ( (!!eObj) && (!!sbObj) ) {
					var a = s.split(',');
					for (var i = 0; i < a.length; i++) {
						oObj = new Option( a[i], a[i]);
						eObj.options[eObj.options.length] = oObj;
					}
					a = sn.split(',');
					for (var i = 0; i < a.length; i++) {
						a[i] = a[i].stripTickMarks();
					}
					aa = this.listOfRequiredSpecialPages.split(',');
					for (var i = 0; i < aa.length; i++) {
						var ii = locateArrayItemsCaseless(a, aa[i], 0);
						if (ii != -1) {
							removeArrayItem(a,ii);
						}
					}
					for (var i = 0; i < a.length; i++) {
						if ( (!!a[i]) && (a[i].trim().length > 0) ) {
							oObj = new Option( a[i], a[i]);
							eObj.options[eObj.options.length] = oObj;
						}
					}
					for (var i = 0; i < aa.length; i++) {
						if ( (!!aa[i]) && (aa[i].trim().length > 0) ) {
							for (var ik = 0; ik < eObj.options.length; ik++) {
								if (eObj.options[ik].text.trim().toUpperCase() == aa[i].trim().toUpperCase()) {
									eObj.options[ik] = null;
								}
							}
						}
					}
					sbObj.disabled = true;
				} else {
					alert('ERROR: Programming Error - Missing objects (menu_item_editor_pageList or this.const_menu_item_editor_saveButton).');
				}
				
				var tlObj = $(this.const_menu_url_typelist);
				if (!!tlObj) {
					oObj = new Option( const_other_symbol, '');
					tlObj.options[tlObj.options.length] = oObj;
		
					oObj = new Option( const_http_symbol, const_http_symbol);
					tlObj.options[tlObj.options.length] = oObj;
		
					oObj = new Option( const_https_symbol, const_https_symbol);
					tlObj.options[tlObj.options.length] = oObj;
		
					oObj = new Option( const_ftp_symbol, const_ftp_symbol);
					tlObj.options[tlObj.options.length] = oObj;
		
					oObj = new Option( const_mailto_symbol, const_mailto_symbol);
					tlObj.options[tlObj.options.length] = oObj;
				} else {
					alert('ERROR: Programming Error - Missing object (this.const_menu_url_typelist).');
				}
			} else {
				alert('ERROR: Programming Error - Not valid value holders (_GetCurrentContent_pageList or _GetCurrentContent_notLinkables).');
			}
		} else {
			alert('ERROR: Programming Error - Missing div named (_menu_item_editor).');
		}
	},
	writeGUI : function() {
		document.write('<div id="div_menuEditor_container"></div>');
		var cObj = $('div_menuEditor_container');
		if (!!cObj) {
			flushGUIObjectChildrenForObj(cObj);
			cObj.innerHTML = this.guiHTML;
		}
		this.initMenuEditorClipboardObjects();
	},
	getGUIcontainer : function(id) {
		id = ((!!id) ? id : 'div_menuEditor_container');
		return '<div id="' + id + '"></div>';
	},
	populateGUIcontainer : function(id) {
		id = ((!!id) ? id : 'div_menuEditor_container');
		var cObj = $(id);
		if (!!cObj) {
			flushGUIObjectChildrenForObj(cObj);
			cObj.innerHTML = this.guiHTML;
		}
		this.initMenuEditorClipboardObjects();
	},
	init : function() {
		return this;
	},
	destructor : function() {
		return (this.id = menuEditorObj.$[this.id] = null);
	},
	dummy : function() {
		return false;
	}
};
