/*
 menu_editor_core_obj.js -- menuEditorCoreObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

menuEditorCoreObj = function(id, div_menuBrowserID, menuBrowserID) {
	this.id = id;								// the id is the position within the global ButtonBarObj.instances array...
	this.div_menuBrowserID = div_menuBrowserID;	// this is the menu browser div that the menu browser resides within...
	this.menuBrowserID = menuBrowserID;			// this is the id of the menu browser select widget...

	this.initMenuEditorClipboardObjects();
};

menuEditorCoreObj.instances = [];

menuEditorCoreObj.getInstance = function(_div_menuBrowserID, _menuBrowserID) {
	// the object.id is the position within the array that holds onto the objects...
	var instance = menuEditorCoreObj.instances[menuEditorCoreObj.instances.length];
	if(instance == null) {
		instance = menuEditorCoreObj.instances[menuEditorCoreObj.instances.length] = new menuEditorCoreObj(menuEditorCoreObj.instances.length, _div_menuBrowserID, _menuBrowserID);
	}
	return instance;
};

menuEditorCoreObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < menuEditorCoreObj.instances.length) ) {
		var instance = menuEditorCoreObj.instances[id];
		if (!!instance) {
			menuEditorCoreObj.instances[id] = object_destructor(instance);
			ret_val = (menuEditorCoreObj.instances[id] == null);
		}
	}
	return ret_val;
};

menuEditorCoreObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < menuEditorCoreObj.instances.length; i++) {
		menuEditorCoreObj.removeInstance(i);
	}
	return ret_val;
};

menuEditorCoreObj._const_menu_copy_to_clipboard_symbol = 'menu_copy_to_clipboard';
menuEditorCoreObj._const_menu_delete_item_symbol = 'menu_delete_item';

menuEditorCoreObj.prototype = {
	id : -1,
	div_menuBrowserID : -1,
	menuBrowserID : -1,
	old_Ellipsis_symbol : '...',
	const_cancelButton_symbol : '[Cancel]',
	const_currentPage_symbol : '?currentPage=',
	const_subMenu_symbol : '##',
	const_subMenuEnds_symbol : '##-1',
	listOfRequiredSpecialPages : '',
//	const_menu_copy_to_clipboard_symbol : menuEditorCoreObj._const_menu_copy_to_clipboard_symbol, // this allows the copy to clipboard to be replaced by a delete item button without having to recode a lot of logic...
	const_menu_copy_to_clipboard_symbol : menuEditorCoreObj._const_menu_delete_item_symbol,       // this allows the copy to clipboard to be replaced by a delete item button without having to recode a lot of logic...
	const_ClipboardPasteMode_symbol : 'ClipboardPasteMode',
	const_forward_slash_symbol : '/',
	menuArray : [],
	_menu_stack : [],
	_global_menu_mode : false, // true for the new menu, false for the original menu...
	toString : function() {
		var s = 'id = [' + this.id + '] ';
		return s;
	},
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
	rebuildMenu : function(mm, includeLinks) {
		// this is a placeholder that signals that the menu needs to be rebuilt...
	},
	processMenuModeChange : function() {
		this._global_menu_mode = ((this._global_menu_mode == true) ? false : true);
		this.rebuildMenu(this.menuArray, true);
	},
	processSelectedmenuItem : function(brObj) {
		var clipObj = getGUIObjectInstanceById('menu_clipboard');
		var bbutObj = getGUIObjectInstanceById('menu_browse_into');
		var bcutObj = getGUIObjectInstanceById('menu_cut_to_clipboard');
		var bcopyObj = getGUIObjectInstanceById(this.const_menu_copy_to_clipboard_symbol);
		var bcpasteObj = getGUIObjectInstanceById(const_clipboard_paste_to_menu);
		var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
		var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
		var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
		var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
		var edmiObj = getGUIObjectInstanceById('edit_menu_item');
		var abObj = getGUIObjectInstanceById('addit_menu_item'); 
		var asObj = getGUIObjectInstanceById('addit_menu_submenu');
		if ( (brObj != null) && (bbutObj != null) && (bcutObj != null) && (bcopyObj != null) && (edmiObj != null) && (abObj != null) && (asObj != null) ) {
			if (brObj.selectedIndex > -1) {
				var s = brObj.options[brObj.selectedIndex].text;
				var o = brObj.options[brObj.selectedIndex].value;
				if (o == const_object_symbol) {
					bbutObj.disabled = false;
					// disable the delete item button here, unless the submenu is empty ?!?
					var c = retrieveMenuAtLevel(this.menuArray, this._menu_stack, 0);
					var offset = (this._menu_stack.length == 0) ? 0 : 1;
					var m = c[brObj.selectedIndex + offset];
					var cnt = trueItemCountOfMenuContainer(m);
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
				if ( (!!clipObj) && ( (clipObj.selectedIndex == -1) || (isClipboardActuallyEmpty()) ) ) {
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
						_prompt = '(' + retrieveMenuPrompt(c).URLDecode().clipCaselessReplace(this.old_Ellipsis_symbol, '') + ')';
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
	initMenuEditorClipboardObjects : function() {
		var dObj = getGUIObjectInstanceById(this.div_menuBrowserID);
		if (!!dObj) {
			flushGUIObjectChildrenForObj(dObj);
			dObj.innerHTML = '<select id="' + this.menuBrowserID + '" size="10" style="font-size: 10px; line-height: 10px; width: 100%;" ondblclick="return handle_menuBrowser_dblclick();" onchange="return handle_menuBrowser_change();"></select>';
	
			var bObj = getGUIObjectInstanceById(this.menuBrowserID);
			if (!!bObj) {
				this.populateSelectWithMenu(bObj, this.menuArray);
			}
		}

		var rObj = getGUIObjectInstanceById('rightmenu_wrapper');
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
			html += '<select id="menu_clipboard" size="5" style="font-size: 10px; line-height: 10px;" onchange="var clipObj = getGUIObjectInstanceById(\'menu_clipboard\'); if (!!clipObj) { processSelectedClipboardItem(clipObj) } return false;">';
			html += '</select>';
			html += '</center>';
			html += '</td>';
			html += '</tr>';
		
			html += '<tr>';
			html += '<td>';
			html += '<input type="button" id="clipboard_remove_item" value="Remove Clipboard Item" disabled style="font-size: 10px;" onClick="var clipObj = getGUIObjectInstanceById(\'menu_clipboard\'); if (!!clipObj) { processClipboardRemoveSelected(clipObj) } return false;">';
			html += '</td>';
			html += '</tr>';
		
			html += '<tr>';
			html += '<td>';
		
			html += '<table cellpadding="-1" cellspacing="-1">';
			html += '<tr>';
			html += '<td>';
			var _html = _setup_tooltip_handlers(const_clipboard_paste_to_menu, const_empty_symbol);
			html += '<input type="button" ' + _html + ' disabled value="Paste to Menu" style="font-size: 10px;" title="Click this button to move a Menu Item or SubMenu Item from the ClipBoard to the Menu perhaps to a different position than the item had been in originally for the purpose or reorganizing or reordering the Menu." onClick="var clipObj = getGUIObjectInstanceById(\'menu_clipboard\'); if (!!clipObj) { processClipboardPasteToMenu(clipObj) } return false;">';
	
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
			html += '<NOBR><input type="checkbox" id="clipboard_paste_becomes_move" value="MOVE" alt="(Plus sign means auto-Remove from ClipBoard)" onClick="var anObj = getGUIObjectInstanceById(\'clipboard_paste_becomes_move\'); if (!!anObj) { processClipboardPasteBecomesMove(anObj); setCookie(this.const_ClipboardPasteMode_symbol, anObj.checked, this.const_forward_slash_symbol); } return true;">&nbsp;<span id="clipboard_paste_becomes_move_div" style="line-height: 10px;"><font size="-1" id="clipboard_paste_becomes_move_font"><small><b>Clipboard Paste to Menu with auto-Remove</b></small></font></span></NOBR>';
			html += '</div>';
			html += '</td>';
			html += '</tr>';
			html += '</table>';
		
			html += '</td>';
			html += '</tr>';
			html += '</table>';
			html += '</div>';
			rObj.innerHTML = html;
			
			// BEGIN: Initialize this item...
			var anObj = getGUIObjectInstanceById('clipboard_paste_becomes_move'); 
			if (!!anObj) { 
				var c = getCookie(this.const_ClipboardPasteMode_symbol);
				if ( (!!c) && (c.length > 0) ) {
					anObj.checked = eval(c);
				}
				processClipboardPasteBecomesMove(anObj);
			} else {
				alert('ERROR: Programming Error - Missing div named (clipboard_paste_becomes_move).');
			}
			anObj.checked = true;
			processClipboardPasteBecomesMove(anObj);
			// END! Initialize this item...
		
			var sObj = getGUIObjectInstanceById('menu_clipboard');
			var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
			var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
			var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
			var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
			if (!!sObj) {
				var optObj;
				if (sObj.options.length == 0) {
					optObj = new Option(const_ClipboardEmpty_symbol,const_ClipboardEmpty_value);
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
	
		var criObj = getGUIObjectInstanceById('clipboard_remove_item');
		if (!!criObj) {
			// it was deemed "just too easy" for the end-user to delete items with this button active however allowing them to delete right from the menu was deemed okay ?!?  Go figure !
			criObj.style.display = const_none_style;
		} else {
			alert('ERROR: Programming Error - Missing div named (clipboard_remove_item).');
		}
		
		var eObj = getGUIObjectInstanceById('_menu_item_editor');
		if (!!eObj) {
			var html = '';
		
			var pListObj = getGUIObjectInstanceById('_GetCurrentContent_pageList');
			var pnListObj = getGUIObjectInstanceById('_GetCurrentContent_notLinkables');
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
				html += '<font size="1"><small><b>Prompt:</b></small></font>&nbsp;<input type="text" id="_menu_item_editor_prompt" size="39" maxlength="50" style="font-size: 9px;" onkeyup="refreshMenuItemEditorSaveButton(); return true;">';
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
				html += '<select id="menu_item_editor_pageList" size="4" style="font-size: 10px; line-height: 10px;" onchange="refreshMenuItemEditorSaveButton(); return true;">';
				html += '</select>';
				html += '</div>';
	
				html += '<div id="menu_item_editor_http_pane" style="display: none;">';
				html += '<table cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td valign="middle">';
				var _html = 'id="' + const_menu_url_typelist + '"';
				html += '<select ' + _html + ' size="1" style="font-size: 10px; line-height: 10px;" onchange="processChangedUrlType(); return true;">';
				html += '</select>';
				html += '</td>';
				html += '</tr>';
				html += '<tr>';
				html += '<td>';
				html += '<table cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td>';
				html += '<textarea cols="35" rows="5" name="menu_item_editor_http" wrap="soft" style="font-size: 10px; line-height: 10px;" onkeyup="_refreshUrlType(); refreshMenuItemEditorSaveButton(); return true;"></textarea>';
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
				var _html = _setup_tooltip_handlers(const_menu_item_editor_saveButton, const_positional_delayed_tooltips4);
				html += '<input type="button" ' + _html + ' disabled value="[Save]" style="font-size: 9px;" title="Click this button to Save the Menu Item in the Menu.  Typically this button is used to Save any changes made to the Menu Item you may have been editing or adding to the Menu." onClick="processSaveMenuItemEditor(); return false;">';
				html += '</td>';
				html += '<td>';
				html += '&nbsp;';
				html += '</td>';
				html += '<td>';
				var _html = _setup_tooltip_handlers(const_menu_item_editor_cancelButton, const_positional_delayed_tooltips4);
				html += '<input type="button" ' + _html + ' value="' + this.const_cancelButton_symbol + '" style="font-size: 9px;" title="Click this button to Cancel the operation currently in-process." onClick="processCancelMenuItemEditor(); return false;">';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
				html += '</form>';
		
				eObj.innerHTML = html;
		
				var eObj = getGUIObjectInstanceById('menu_item_editor_pageList');
				var sbObj = getGUIObjectInstanceById(const_menu_item_editor_saveButton);
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
					alert('ERROR: Programming Error - Missing objects (menu_item_editor_pageList or const_menu_item_editor_saveButton).');
				}
				
				var tlObj = getGUIObjectInstanceById(const_menu_url_typelist);
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
					alert('ERROR: Programming Error - Missing object (const_menu_url_typelist).');
				}
			} else {
				alert('ERROR: Programming Error - Not valid value holders (_GetCurrentContent_pageList or _GetCurrentContent_notLinkables).');
			}
		} else {
			alert('ERROR: Programming Error - Missing div named (_menu_item_editor).');
		}
	},
	init : function() {
		return this;
	},
	destructor : function() {
		return (this.id = menuEditorCoreObj.instances[this.id] = null);
	},
	dummy : function() {
		return false;
	}
};
