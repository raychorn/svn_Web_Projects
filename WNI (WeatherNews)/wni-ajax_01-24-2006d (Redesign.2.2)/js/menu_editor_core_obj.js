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
menuEditorCoreObj.const_clipboard_paste_to_menu = 'clipboard_paste_to_menu';


menuEditorCoreObj.processClipboardPasteBecomesMove = function(anObj) {
	var dObj = getGUIObjectInstanceById('clipboard_paste_becomes_move_div');
	var rObj = getGUIObjectInstanceById('clipboard_remove_item');
	var pmObj = getGUIObjectInstanceById(menuEditorCoreObj.const_clipboard_paste_to_menu);
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

menuEditorCoreObj.processMenuCutToThinAir = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuCutToClipboard(brObj, false) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorCoreObj.processMenuCutToThinAir().'));
};

menuEditorCoreObj.processMenuCutToClipboard = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuCutToClipboard(brObj, true) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorCoreObj.processMenuCutToClipboard().'));
};

menuEditorCoreObj.processMenuCopyToClipboard = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuCopyToClipboard(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorCoreObj.processMenuCopyToClipboard().'));
};

menuEditorCoreObj.processClipboardPasteToMenu = function(clipObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!clipObj) ) ? menuEditorObj._processClipboardPasteToMenu(clipObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and clipObj is (' + clipObj + ') in function known as menuEditorCoreObj.processClipboardPasteToMenu().'));
};

menuEditorCoreObj.processClipboardRemoveSelected = function(clipObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!clipObj) ) ? menuEditorObj._processClipboardRemoveSelected(clipObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and clipObj is (' + clipObj + ') in function known as menuEditorCoreObj.processClipboardRemoveSelected().'));
};

menuEditorCoreObj.processSelectedClipboardItem = function(clipObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!clipObj) ) ? menuEditorObj._processSelectedClipboardItem(clipObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and clipObj is (' + clipObj + ') in function known as menuEditorCoreObj.processSelectedClipboardItem().'));
};

menuEditorCoreObj.processMenuBrowseInto = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuBrowseInto(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorCoreObj.processMenuBrowseInto().'));
};

menuEditorCoreObj.processMenuBrowseOut = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuBrowseOut(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorCoreObj.processMenuBrowseOut().'));
};

menuEditorCoreObj.ProcessMenuSaveToDatabase = function(mcObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!mcObj) ) ? menuEditorObj._ProcessMenuSaveToDatabase(mcObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and mcObj is (' + mcObj + ') in function known as menuEditorCoreObj.ProcessMenuSaveToDatabase().'));
};

menuEditorCoreObj.processCancelMenuItemEditor = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._processCancelMenuItemEditor() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorCoreObj.processCancelMenuItemEditor().'));
};

menuEditorCoreObj.processSaveMenuItemEditor = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._processSaveMenuItemEditor() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorCoreObj.processSaveMenuItemEditor().'));
};

menuEditorCoreObj.refreshUrlType = function(_url, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!_url) ) ? menuEditorObj._refreshUrlType(_url) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and _url is (' + _url + ') in function known as menuEditorCoreObj.refreshUrlType().'));
};

menuEditorCoreObj._refreshUrlType = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj.__refreshUrlType() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorCoreObj._refreshUrlType().'));
};

menuEditorCoreObj.processChangedUrlType = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._processChangedUrlType() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorCoreObj.processChangedUrlType().'));
};

menuEditorCoreObj.processMenuSubMenuAdditor = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuSubMenuAdditor(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorCoreObj.processMenuSubMenuAdditor().'));
};

menuEditorCoreObj.processMenuItemAdditor = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj._processMenuItemAdditor(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorCoreObj.processMenuItemAdditor().'));
};

menuEditorCoreObj.processMenuItemEditor = function(brObj, menuEditorObj) {
	return ( ( (!!menuEditorObj) && (!!brObj) ) ? menuEditorObj.__processMenuItemEditor(brObj) : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') and brObj is (' + brObj + ') in function known as menuEditorCoreObj.processMenuItemEditor().'));
};

menuEditorCoreObj.refreshMenuItemEditorSaveButton = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._refreshMenuItemEditorSaveButton() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorCoreObj.refreshMenuItemEditorSaveButton().'));
};

menuEditorCoreObj.handle_menuBrowser_dblclick = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._handle_menuBrowser_dblclick() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorCoreObj.handle_menuBrowser_dblclick().'));
};
// +++
menuEditorCoreObj.handle_menuBrowser_change = function(menuEditorObj) {
	return ( (!!menuEditorObj) ? menuEditorObj._handle_menuBrowser_change() : alert('ERROR: Programming Error - Undefined Objects menuEditorObj is (' + menuEditorObj + ') in function known as menuEditorCoreObj.handle_menuBrowser_change().'));
};
// +++
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
	const_ClipboardEmpty_symbol : 'Clipboard Empty',
	const_menu_url_typelist : 'menu_url_typelist',
	const_menu_item_editor_saveButton : 'menu_item_editor_saveButton',
	const_menu_item_editor_cancelButton : 'menu_item_editor_cancelButton',
	const_positional_delayed_tooltips4 : 'positional_delayed_tooltips4',
	const_forward_slash_symbol : '/',
	const_ClipboardEmpty_value : -1,
	isAddingMenuItem : -1,
	isAddingMenuSubMenu : -1,
	const_empty_symbol : '',
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
		var clipObj = getGUIObjectInstanceById('menu_clipboard');
		if (!!clipObj) {
			return ( (clipObj.options.length == 1) && (clipObj.options[0].text.toUpperCase() == this.const_ClipboardEmpty_symbol.toUpperCase()) );
		}
		return false;
	},
	_processMenuCutToClipboard : function(brObj, bool_copy_to_clipboard) {
		var clipObj = getGUIObjectInstanceById('menu_clipboard');
		var bcutObj = getGUIObjectInstanceById('menu_cut_to_clipboard');
		var bcopyObj = getGUIObjectInstanceById(this.const_menu_copy_to_clipboard_symbol);
		var bcpasteObj = getGUIObjectInstanceById(menuEditorCoreObj.const_clipboard_paste_to_menu);
		var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
		var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
		var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
		var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
		var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
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
			
			if (bool_copy_to_clipboard == true) {
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
		var clipObj = getGUIObjectInstanceById('menu_clipboard');
		var bcutObj = getGUIObjectInstanceById('menu_cut_to_clipboard');
		var bcopyObj = getGUIObjectInstanceById(this.const_menu_copy_to_clipboard_symbol);
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
		var msbObj1 = getGUIObjectInstanceById('menu_savedata_button');
		var msbObj2 = getGUIObjectInstanceById('menu_savedata_button2');
		if ( (!!msbObj1) && (!!msbObj2) ) {
			msbObj1.style.display = ((bool == true) ? const_inline_style : const_none_style);
			msbObj2.style.display = ((bool == true) ? const_none_style : const_inline_style);
		}
	},
	isClipboardPaste : function() { // bool == true controls the hide/show for the real menu save button - the other button follows suit...
		var anObj = getGUIObjectInstanceById('clipboard_paste_becomes_move'); 
		if (!!anObj) { 
			return (anObj.checked);
		}
		return true; // default is true when there is no other choice available...
	},
	_processClipboardPasteToMenu : function(clipObj) {
		var brObj = getGUIObjectInstanceById('menu_browser');
		var bcpasteObj = getGUIObjectInstanceById(menuEditorCoreObj.const_clipboard_paste_to_menu);
		var bcremoveObj = getGUIObjectInstanceById('clipboard_remove_item');
		var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
		var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
		if ( (!!brObj) && (!!clipObj) && (!!bcpasteObj) && (!!bcremoveObj) ) {
			if (clipObj.selectedIndex != -1) {
				var v = this._menu_clipboard[clipObj.selectedIndex];
				var b = this.isClipboardPaste();
				this._pasteItemToMenu(v, ((!!afterObj) ? afterObj.checked : true));
				if (b) {
					var clipObj = getGUIObjectInstanceById('menu_clipboard'); 
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
		var brObj = getGUIObjectInstanceById('menu_browser');
		var bcpasteObj = getGUIObjectInstanceById(menuEditorCoreObj.const_clipboard_paste_to_menu);
		var bcremoveObj = getGUIObjectInstanceById('clipboard_remove_item');
		var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
		var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
		var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
		var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
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
		var brObj = getGUIObjectInstanceById('menu_browser');
		var bcpasteObj = getGUIObjectInstanceById(menuEditorCoreObj.const_clipboard_paste_to_menu);
		var bcremoveObj = getGUIObjectInstanceById('clipboard_remove_item');
		var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
		var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
		var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
		var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
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
		var bbutObj = getGUIObjectInstanceById('menu_browse_into');
		var cbutObj = getGUIObjectInstanceById('menu_browse_out');
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
				}
				brObj.disabled = false;
			}
		}
	},
	_ProcessMenuSaveToDatabase : function(mcObj) {
		var clipObj = getGUIObjectInstanceById('menu_clipboard');
		if (!!clipObj) {
			if ( (clipObj.options.length > 0) && (this.isClipboardActuallyEmpty() == false) ) {
				this.hideShowMenuSaveButtons(false);  // clipboard is not empty so let the user know what's wrong...
			} else {
				if (isObjValidHTMLValueHolder(mcObj)) {
					mcObj.value = this.joinMenu( this.menuArray);
					var pObj = getGUIObjectInstanceById('hilite_color_preview');
					var dObj = getGUIObjectInstanceById('menu_color');
					var pObj2 = getGUIObjectInstanceById('hilite_color_preview2');
					var tObj = getGUIObjectInstanceById('menu_text_color');
					if ( (!!pObj) && (!!pObj2) && (isObjValidHTMLValueHolder(dObj)) && (isObjValidHTMLValueHolder(tObj)) ) {
						dObj.value = pObj.bgColor;
						tObj.value = pObj2.bgColor;
					}
					return true;
				}
			}
		}
		return false;
	},
	_processCancelMenuItemEditor : function() {
		var eObj = getGUIObjectInstanceById('_menu_item_editor');
		var ebutObj = getGUIObjectInstanceById('_menu_item_editor_button');
		var abutObj = getGUIObjectInstanceById('_menu_item_additor_button');
		var asbutObj = getGUIObjectInstanceById('_menu_submenu_additor_button');
		var clipObj = getGUIObjectInstanceById('menu_clipboard'); 
		var brObj = getGUIObjectInstanceById('menu_browser'); 
		var cmcObj = getGUIObjectInstanceById('change_menu_colors');
		var cmcObj2 = getGUIObjectInstanceById('change_menu_colors2');
		var hcpObj = getGUIObjectInstanceById('hilite_color_preview');
		var hcpObj2 = getGUIObjectInstanceById('hilite_color_preview2');
		if ( (!!eObj) && (!!ebutObj) && (!!abutObj) && (!!asbutObj) && (!!clipObj) && (!!brObj) && (!!hcpObj) && (!!hcpObj2) ) { 
			eObj.style.display = const_none_style; 
			ebutObj.style.display = const_inline_style; 
			abutObj.style.display = const_inline_style; 
			asbutObj.style.display = const_inline_style; 
	
			if (!!cmcObj) cmcObj.style.display = const_inline_style;
			if (!!cmcObj2) cmcObj2.style.display = const_inline_style;
			
			hcpObj.style.display = const_inline_style;
			hcpObj2.style.display = const_inline_style;
			
			var a = -1;
			while (this._menu_widgets_stack.length > 0) {
				a = this._menu_widgets_stack.pop();
				var anObj = getGUIObjectInstanceById(a[0]);
				if (!!anObj) {
					anObj.disabled = a[1];
				}
			}
	
			var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
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
		var brObj = getGUIObjectInstanceById('menu_browser');
		var epObj = getGUIObjectInstanceById('_menu_item_editor_prompt');
		var iObj = getGUIObjectInstanceById('_menu_item_editor_internal');
		var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
		var hObj = getGUIObjectInstanceById('menu_item_editor_http');
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
					var _isSubMenu = false;
					if (typeof v == const_object_symbol) {
						v = v[0];
						_isSubMenu = true;
					}
					
					var _url = ' ';
					var _target = ' ';
					if ( (!!iObj) && (iObj.checked == true) ) {
						_url = const_cgi_script_name_symbol + this.const_currentPage_symbol + pgObj.options[pgObj.selectedIndex].text.trim();
						_target = '_top';
					} else {
						_url = hObj.value.URLDecode().trim();
						_target = '_new';
					}
					var _prompt = epObj.value.URLDecode().trim();
					if (_prompt.length == 0) {
						_prompt = ' ';
					}
					// _prompt must NOT contain (|) or (,) characters or bad evil things will happen to the integrity of the menu data model due to the lists being used that use both characters...
					if ( (_url.toUpperCase().indexOf(const_http_symbol.toUpperCase()) == -1) && (_url.toUpperCase().indexOf(const_https_symbol.toUpperCase()) == -1) && (_url.toUpperCase().indexOf(const_mailto_symbol.toUpperCase()) == -1) && (_url.toUpperCase().indexOf(const_ftp_symbol.toUpperCase()) == -1) ) {
						_url = const_http_symbol + _url;
					}
					var v = _url.stripIllegalChars() + '|' + _target + '|' + _prompt.stripIllegalChars();
					c[sel + offset] = v;
					this.populateSelectWithMenu(brObj, c);
					this.rebuildMenu(this.menuArray, false);
				} else if (this.isAddingMenuItem == true) {
					var _url = ' ';
					var _target = ' ';
					if ( (!!iObj) && (iObj.checked == true) ) {
						_url = const_cgi_script_name_symbol + this.const_currentPage_symbol + pgObj.options[pgObj.selectedIndex].text.trim();
						_target = '_top';
					} else {
						_url = hObj.value.URLDecode().trim();
						_target = '_new';
					}
					var _prompt = epObj.value.URLDecode().trim();
					if (_prompt.length == 0) {
						_prompt = ' ';
					}
					var v = _url.stripIllegalChars() + '|' + _target + '|' + _prompt.stripIllegalChars();
					this._pasteItemToMenu(v, true);
					if (pgObj.selectedIndex != -1) {
						pgObj.options[pgObj.selectedIndex] = null;
					}
				} else if (this.isAddingMenuSubMenu == true) {
					var _empty_subMenu = new Array(0);
	
					var _url = this.const_subMenu_symbol;
					var _target = ' ';
					var _prompt = epObj.value.URLDecode().trim();
					if (_prompt.length == 0) {
						_prompt = ' ';
					}
					var v = _url.stripIllegalChars() + '|' + _target + '|' + _prompt.stripIllegalChars();
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
				}
			}
		}
	
		return this._processCancelMenuItemEditor();
	},
	_refreshUrlType : function(_url) {
		var tlObj = getGUIObjectInstanceById(this.const_menu_url_typelist);
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
		var hObj = getGUIObjectInstanceById('menu_item_editor_http');
		if (!!hObj) {
			this._refreshUrlType(hObj.value.trim());
		}
	},
	_processChangedUrlType : function() {
		var hObj = getGUIObjectInstanceById('menu_item_editor_http');
		var tlObj = getGUIObjectInstanceById(this.const_menu_url_typelist);
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
		var iObj = getGUIObjectInstanceById('_menu_item_editor_internal');
		var eObj = getGUIObjectInstanceById('_menu_item_editor_external');
		var pObj = getGUIObjectInstanceById('menu_item_editor_pageList_pane');
		var phObj = getGUIObjectInstanceById('menu_item_editor_http_pane');
		var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
		var hObj = getGUIObjectInstanceById('menu_item_editor_http');
		if ( (!!iObj) && (!!eObj) && (!!pObj) && (!!phObj) && (!!pgObj) && (!!hObj) ) {
			pObj.style.display = (iObj.checked == true) ? const_inline_style : const_none_style;
			pgObj.style.display = (iObj.checked == true) ? const_inline_style : const_none_style;
			phObj.style.display = (eObj.checked == true) ? const_inline_style : const_none_style;
			hObj.style.display = (eObj.checked == true) ? const_inline_style : const_none_style;
			this._refreshMenuItemEditorSaveButton();
		}
	},
	_processMenuItemEditor : function(brObj) {
		var ebObj = getGUIObjectInstanceById('_menu_item_editor_button');
		var abObj = getGUIObjectInstanceById('_menu_item_additor_button'); 
		var asObj = getGUIObjectInstanceById('_menu_submenu_additor_button');
		var edObj = getGUIObjectInstanceById('_menu_item_editor');
		var epObj = getGUIObjectInstanceById('_menu_item_editor_prompt');
		var clipObj = getGUIObjectInstanceById('menu_clipboard');
		var iObj = getGUIObjectInstanceById('_menu_item_editor_internal');
		var eObj = getGUIObjectInstanceById('_menu_item_editor_external');
		var ifontObj = getGUIObjectInstanceById('_menu_item_editor_internal_font');
		var efontObj = getGUIObjectInstanceById('_menu_item_editor_external_font');
		var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
		var hObj = getGUIObjectInstanceById('menu_item_editor_http');
		var cmcObj = getGUIObjectInstanceById('change_menu_colors');
		var cmcObj2 = getGUIObjectInstanceById('change_menu_colors2');
		var hcpObj = getGUIObjectInstanceById('hilite_color_preview');
		var hcpObj2 = getGUIObjectInstanceById('hilite_color_preview2');
		if ( (!!brObj) && (!!ebObj) && (!!abObj) && (!!asObj) && (!!edObj) && (!!epObj) && (!!clipObj) && (!!pgObj) && (!!hObj) && (!!hcpObj) && (!!hcpObj2) ) {
			ebObj.style.display = const_none_style;
			edObj.style.display = const_inline_style;
			abObj.style.display = const_none_style;
			asObj.style.display = const_none_style;
	
			if (!!cmcObj) cmcObj.style.display = const_none_style;
			if (!!cmcObj2) cmcObj2.style.display = const_none_style;
			
			hcpObj.style.display = const_none_style;
			hcpObj2.style.display = const_none_style;
	
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
	
				var b1Obj = getGUIObjectInstanceById('menu_browse_into');
				var b2Obj = getGUIObjectInstanceById('menu_browse_out');
				var b3Obj = getGUIObjectInstanceById('menu_cut_to_clipboard');
				var b3Obj = getGUIObjectInstanceById(this.const_menu_copy_to_clipboard_symbol);
				var b4Obj = getGUIObjectInstanceById(menuEditorCoreObj.const_clipboard_paste_to_menu);
				var r1Obj = getGUIObjectInstanceById('clipboard_paste_before');
				var r2Obj = getGUIObjectInstanceById('clipboard_paste_after');
				var b5Obj = getGUIObjectInstanceById('menu_cut_to_clipboard');
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
		var tObj = getGUIObjectInstanceById('_menu_item_editor_title');
		if (!!tObj) {
			flushGUIObjectChildrenForObj(tObj);
			tObj.innerHTML = '<small><b>Add Empty SubMenu</b></small>';
		}
		this.isAddingMenuSubMenu = true;
		this.isAddingMenuItem = false;
		return this._processMenuItemEditor(brObj);
	},
	_processMenuItemAdditor : function(brObj) {
		var tObj = getGUIObjectInstanceById('_menu_item_editor_title');
		if (!!tObj) {
			flushGUIObjectChildrenForObj(tObj);
			tObj.innerHTML = '<small><b>Add Menu Item</b></small>';
		}
		this.isAddingMenuItem = true;
		this.isAddingMenuSubMenu = false;
		return this._processMenuItemEditor(brObj);
	},
	__processMenuItemEditor : function(brObj) {
		var tObj = getGUIObjectInstanceById('_menu_item_editor_title');
		if (!!tObj) {
			flushGUIObjectChildrenForObj(tObj);
			tObj.innerHTML = '<small><b>Edit Menu Item</b></small>';
		}
		this.isAddingMenuItem = false;
		this.isAddingMenuSubMenu = false;
		return this._processMenuItemEditor(brObj);
	},
	_refreshMenuItemEditorSaveButton : function() {
		var iObj = getGUIObjectInstanceById('_menu_item_editor_internal');
		var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
		var sbObj = getGUIObjectInstanceById(this.const_menu_item_editor_saveButton);
		var prObj = getGUIObjectInstanceById('_menu_item_editor_prompt');
		var hObj = getGUIObjectInstanceById('menu_item_editor_http');
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
		var cbutObj = getGUIObjectInstanceById('menu_browse_out');
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
				var bObj = getGUIObjectInstanceById('menu_browser');
				if (!!bObj) {
					this.populateSelectWithMenu(bObj, c);
				}
			}
			brObj.disabled = false;
		}
	},
	_pasteItemToMenu : function(v, isAfter) {
		var brObj = getGUIObjectInstanceById('menu_browser');
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
				this.rebuildMenu(this.menuArray, false);
			}
		}
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
		var clipObj = getGUIObjectInstanceById('menu_clipboard');
		var bbutObj = getGUIObjectInstanceById('menu_browse_into');
		var bcutObj = getGUIObjectInstanceById('menu_cut_to_clipboard');
		var bcopyObj = getGUIObjectInstanceById(this.const_menu_copy_to_clipboard_symbol);
		var bcpasteObj = getGUIObjectInstanceById(menuEditorCoreObj.const_clipboard_paste_to_menu);
		var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
		var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
		var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
		var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
		var edmiObj = getGUIObjectInstanceById('edit_menu_item');
		var abObj = getGUIObjectInstanceById('addit_menu_item'); 
		var asObj = getGUIObjectInstanceById('addit_menu_submenu');
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
		var brObj = getGUIObjectInstanceById('menu_browser'); 
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
// +++ !
	_handle_menuBrowser_change : function() {
		var brObj = getGUIObjectInstanceById('menu_browser'); 
		if (brObj != null) { 
			this.processSelectedmenuItem(brObj);
		} 
		
		return false;
	},
// +++
	initMenuEditorClipboardObjects : function() {
		var dObj = getGUIObjectInstanceById(this.div_menuBrowserID);
		if (!!dObj) {
			flushGUIObjectChildrenForObj(dObj);
			dObj.innerHTML = '<select id="' + this.menuBrowserID + '" size="10" style="font-size: 10px; line-height: 10px; width: 100%;" ondblclick="return menuEditorCoreObj.handle_menuBrowser_dblclick(menuEditorCoreObj.instances[' + this.id + ']);" onchange="return menuEditorCoreObj.handle_menuBrowser_change(menuEditorCoreObj.instances[' + this.id + ']);"></select>';
	
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
			html += '<select id="menu_clipboard" size="5" style="font-size: 10px; line-height: 10px;" onchange="var clipObj = getGUIObjectInstanceById(\'menu_clipboard\'); if (!!clipObj) { menuEditorCoreObj.processSelectedClipboardItem(clipObj, menuEditorCoreObj.instances[' + this.id + ']) } return false;">';
			html += '</select>';
			html += '</center>';
			html += '</td>';
			html += '</tr>';
		
			html += '<tr>';
			html += '<td>';
			html += '<input type="button" id="clipboard_remove_item" value="Remove Clipboard Item" disabled style="font-size: 10px;" onClick="var clipObj = getGUIObjectInstanceById(\'menu_clipboard\'); if (!!clipObj) { menuEditorCoreObj.processClipboardRemoveSelected(clipObj, menuEditorCoreObj.instances[' + this.id + ']) } return false;">';
			html += '</td>';
			html += '</tr>';
		
			html += '<tr>';
			html += '<td>';
		
			html += '<table cellpadding="-1" cellspacing="-1">';
			html += '<tr>';
			html += '<td>';
			var _html = _setup_tooltip_handlers(menuEditorCoreObj.const_clipboard_paste_to_menu, this.const_empty_symbol);
			html += '<input type="button" ' + _html + ' disabled value="Paste to Menu" style="font-size: 10px;" title="Click this button to move a Menu Item or SubMenu Item from the ClipBoard to the Menu perhaps to a different position than the item had been in originally for the purpose or reorganizing or reordering the Menu." onClick="var clipObj = getGUIObjectInstanceById(\'menu_clipboard\'); if (!!clipObj) { menuEditorCoreObj.processClipboardPasteToMenu(clipObj, menuEditorCoreObj.instances[' + this.id + ']) } return false;">';
	
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
			html += '<NOBR><input type="checkbox" id="clipboard_paste_becomes_move" value="MOVE" alt="(Plus sign means auto-Remove from ClipBoard)" onClick="var anObj = getGUIObjectInstanceById(\'clipboard_paste_becomes_move\'); if (!!anObj) { menuEditorCoreObj.processClipboardPasteBecomesMove(anObj); setCookie(this.const_ClipboardPasteMode_symbol, anObj.checked, this.const_forward_slash_symbol); } return true;">&nbsp;<span id="clipboard_paste_becomes_move_div" style="line-height: 10px;"><font size="-1" id="clipboard_paste_becomes_move_font"><small><b>Clipboard Paste to Menu with auto-Remove</b></small></font></span></NOBR>';
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
			var anObj = getGUIObjectInstanceById('clipboard_paste_becomes_move'); 
			if (!!anObj) { 
				var c = getCookie(this.const_ClipboardPasteMode_symbol);
				if ( (!!c) && (c.length > 0) ) {
					anObj.checked = eval(c);
				}
				menuEditorCoreObj.processClipboardPasteBecomesMove(anObj);
			} else {
				alert('ERROR: Programming Error - Missing div named (clipboard_paste_becomes_move).');
			}
			anObj.checked = true;
			menuEditorCoreObj.processClipboardPasteBecomesMove(anObj);
			// END! Initialize this item...
		
			var sObj = getGUIObjectInstanceById('menu_clipboard');
			var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
			var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
			var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
			var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
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
				html += '<font size="1"><small><b>Prompt:</b></small></font>&nbsp;<input type="text" id="_menu_item_editor_prompt" size="39" maxlength="50" style="font-size: 9px;" onkeyup="menuEditorCoreObj.refreshMenuItemEditorSaveButton(menuEditorCoreObj.instances[' + this.id + ']); return true;">';
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
				html += '<select id="menu_item_editor_pageList" size="4" style="font-size: 10px; line-height: 10px;" onchange="menuEditorCoreObj.refreshMenuItemEditorSaveButton(menuEditorCoreObj.instances[' + this.id + ']); return true;">';
				html += '</select>';
				html += '</div>';
	
				html += '<div id="menu_item_editor_http_pane" style="display: none;">';
				html += '<table cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td valign="middle">';
				var _html = 'id="' + this.const_menu_url_typelist + '"';
				html += '<select ' + _html + ' size="1" style="font-size: 10px; line-height: 10px;" onchange="menuEditorCoreObj.processChangedUrlType(menuEditorCoreObj.instances[' + this.id + ']); return true;">';
				html += '</select>';
				html += '</td>';
				html += '</tr>';
				html += '<tr>';
				html += '<td>';
				html += '<table cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td>';
				html += '<textarea cols="35" rows="5" name="menu_item_editor_http" wrap="soft" style="font-size: 10px; line-height: 10px;" onkeyup="menuEditorCoreObj._refreshUrlType(menuEditorCoreObj.instances[' + this.id + ']); menuEditorCoreObj.refreshMenuItemEditorSaveButton(menuEditorCoreObj.instances[' + this.id + ']); return true;"></textarea>';
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
				html += '<input type="button" ' + _html + ' disabled value="[Save]" style="font-size: 9px;" title="Click this button to Save the Menu Item in the Menu.  Typically this button is used to Save any changes made to the Menu Item you may have been editing or adding to the Menu." onClick="menuEditorCoreObj.processSaveMenuItemEditor(menuEditorCoreObj.instances[' + this.id + ']); return false;">';
				html += '</td>';
				html += '<td>';
				html += '&nbsp;';
				html += '</td>';
				html += '<td>';
				var _html = _setup_tooltip_handlers(this.const_menu_item_editor_cancelButton, this.const_positional_delayed_tooltips4);
				html += '<input type="button" ' + _html + ' value="' + this.const_cancelButton_symbol + '" style="font-size: 9px;" title="Click this button to Cancel the operation currently in-process." onClick="menuEditorCoreObj.processCancelMenuItemEditor(menuEditorCoreObj.instances[' + this.id + ']); return false;">';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
				html += '</form>';
		
				flushGUIObjectChildrenForObj(eObj);
				eObj.innerHTML = html;
		
				var eObj = getGUIObjectInstanceById('menu_item_editor_pageList');
				var sbObj = getGUIObjectInstanceById(this.const_menu_item_editor_saveButton);
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
				
				var tlObj = getGUIObjectInstanceById(this.const_menu_url_typelist);
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
