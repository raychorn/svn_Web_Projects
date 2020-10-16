var _const_menu_copy_to_clipboard_symbol = 'menu_copy_to_clipboard';
var _const_menu_delete_item_symbol = 'menu_delete_item';

// var const_menu_copy_to_clipboard_symbol = _const_menu_copy_to_clipboard_symbol; // this allows the copy to clipboard to be replaced by a delete item button without having to recode a lot of logic...
var const_menu_copy_to_clipboard_symbol = _const_menu_delete_item_symbol;          // this allows the copy to clipboard to be replaced by a delete item button without having to recode a lot of logic...

var const_ClipboardPasteMode_symbol = 'ClipboardPasteMode';
var const_forward_slash_symbol = '/';

var _menu_stack = new Array(0);
var _menu_clipboard = new Array(0);

var _menu_widgets_stack = new Array(0);

var const_ClipboardEmpty_symbol = 'Clipboard Empty';
var const_ClipboardEmpty_value = -1;

var const_clipboard_paste_to_menu = 'clipboard_paste_to_menu';
var const_menu_url_typelist = 'menu_url_typelist';
var const_menu_item_editor_saveButton = 'menu_item_editor_saveButton';
var const_menu_item_editor_cancelButton = 'menu_item_editor_cancelButton';

var const_empty_symbol = '';
var const_positional_delayed_tooltips4 = 'positional_delayed_tooltips4';

var _menu_in_browser = null;

var isAddingMenuItem = -1;
var isAddingMenuSubMenu = -1;

var _stack_remember_to_remove_from_pglist = [];

function retrieveMenuPrompt(mm) {
	if (typeof mm[0] == const_object_symbol) {
		return retrieveMenuPrompt(mm[0]);
	} else {
		var toks = mm[0].split('|');
		if (toks.length > 2) {
			return toks[2].trim();
		}
	}
	return '';
}

function retrieveMenuAtLevel(mm, stack, i) {
	var c = mm;
	if (stack.length > 0) {
		c = mm[stack[i]];
		i++;
		if (i < stack.length) {
			return retrieveMenuAtLevel(c, stack, i);
		}
	}
	_menu_in_browser = c;
	return c;
}

function debugMenu( mm) {
	var _do = '';
	var _i = 0;

	function debugMenuNode(c) {
		_do += '=======================================================\n';
		for (var i = 0; i < c.length; i++) {
			if (c[i] != null) {
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
}

function joinMenu( mm) {
	var _do = '';

	function joinMenuNode(c) {
		for (var i = 0; i < c.length; i++) {
			if (c[i] != null) {
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
	a.push(const_subMenuEnds_symbol);
	return a.join(',');
}

function performMenuPasteAtLevel(value, offset) {
	if (_menu_in_browser != null) {
		insertArrayItem(_menu_in_browser,value,offset);
	}
	return _menu_in_browser;
}

function performMenuCutAtLevel(offset) {
	if (_menu_in_browser != null) {
		removeArrayItem(_menu_in_browser,offset);
	}
	return _menu_in_browser;
}

function isClipboardActuallyEmpty() {
	var clipObj = getGUIObjectInstanceById('menu_clipboard');
	if (clipObj != null) {
		return ( (clipObj.options.length == 1) && (clipObj.options[0].text.toUpperCase() == const_ClipboardEmpty_symbol.toUpperCase()) );
	}
	return false;
}

function _processMenuCutToClipboard(brObj, bool_copy_to_clipboard) {
	var clipObj = getGUIObjectInstanceById('menu_clipboard');
	var bcutObj = getGUIObjectInstanceById('menu_cut_to_clipboard');
	var bcopyObj = getGUIObjectInstanceById(const_menu_copy_to_clipboard_symbol);
	var bcpasteObj = getGUIObjectInstanceById(const_clipboard_paste_to_menu);
	var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
	var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
	var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
	var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
	var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
	if ( (brObj != null) && (clipObj != null) && (bcutObj != null) && (bcopyObj != null) && (bcpasteObj != null) && (beforeObj != null) && (afterObj != null) && (bfontObj != null) && (afontObj != null) && (pgObj != null) ) {
		var t = '';
		var sel = brObj.selectedIndex;
		if (sel != -1) {
			t = brObj.options[sel].text;
		} else {
			sel = 0; // cannot allow -1 which means nothing selected.
		}
		var v = '';

		var c = retrieveMenuAtLevel(menuArray, _menu_stack, 0);
		var offset = (_menu_stack.length == 0) ? 0 : 1;
		v = c[sel + offset];
		
		if (bool_copy_to_clipboard == true) {
			if (isClipboardActuallyEmpty()) {
				clipObj.options[0] = null;
			}
			var i = clipObj.options.length;
			_menu_clipboard[i] = v;
			if (typeof v == const_object_symbol) {
				var _prompt = '';
				var toks = v[0].split('|');
				if (toks.length > 2) {
					_prompt = toks[2].URLDecode().trim();
				}
				v = '(' + _prompt.clipCaselessReplace(const_old_Ellipsis_symbol, '') + ')';
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
			if (_url.toUpperCase().indexOf(const_currentPage_symbol.trim().toUpperCase()) != -1) {
				var _url_toks = _url.split('?');
				if (_url_toks.length > 1) {
					var _url_toks2 = _url_toks[1].split('=');
					if (_url_toks2.length > 1) {
						_curPage = _url_toks2[1];
					}
				}
				if (_curPage.trim().length > 0) {
					// +++
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
		beforeObj.disabled = true;
		afterObj.disabled = true;
		bfontObj.color = 'silver';
		afontObj.color = 'silver';

		var offset = (_menu_stack.length == 0) ? 0 : 1;

		performMenuCutAtLevel(sel + offset);

		populateSelectWithMenu(brObj, c);
		rebuildMenu(menuArray, false);
	}
}

function processMenuCutToThinAir(brObj) {
	return _processMenuCutToClipboard(brObj, false);
}

function processMenuCutToClipboard(brObj) {
	return _processMenuCutToClipboard(brObj, true);
}

function processMenuCopyToClipboard(brObj) {
	var clipObj = getGUIObjectInstanceById('menu_clipboard');
	var bcutObj = getGUIObjectInstanceById('menu_cut_to_clipboard');
	var bcopyObj = getGUIObjectInstanceById(const_menu_copy_to_clipboard_symbol);
	if ( (brObj != null) && (clipObj != null) && (bcutObj != null) && (bcopyObj != null) ) {

		var t = '';
		var sel = brObj.selectedIndex;
		if (sel != -1) {
			t = brObj.options[sel].text;
		} else {
			sel = 0; // cannot allow -1 which means nothing selected.
		}
		var v = '';

		var c = retrieveMenuAtLevel(menuArray, _menu_stack, 0);
		var offset = (_menu_stack.length == 0) ? 0 : 1;
		v = c[sel + offset];
		
		if (isClipboardActuallyEmpty()) {
			clipObj.options[0] = null;
		}
		var i = clipObj.options.length;
		_menu_clipboard[i] = v;
		if (typeof v == const_object_symbol) {
			var _prompt = '';
			var toks = v[0].split('|');
			if (toks.length > 2) {
				_prompt = toks[2].URLDecode().trim();
			}
			v = '(' + _prompt.clipCaselessReplace(const_old_Ellipsis_symbol, '') + ')';
		}
		var oObj = new Option( t, v);
		clipObj.options[i] = oObj;
		clipObj.options[i].selected = false;
		
		clipObj.disabled = false;
		
		bcutObj.disabled = true;
		bcopyObj.disabled = true;
	}
}

function _pasteItemToMenu(v, isAfter) {
	var brObj = getGUIObjectInstanceById('menu_browser');
	if (brObj != null) {
		var sel = brObj.selectedIndex;
		if (brObj.options.length == 0) {
			sel = 0;
			isAfter = false;
		}
		if (sel == -1) {
			sel = 0; // cannot allow -1 which means nothing selected.
		}
		var offset = (_menu_stack.length == 0) ? 0 : 1;
		if (isAfter == true) {
			offset = sel + 1 + offset;
		} else {
			offset = sel + offset;
		}
		var c = performMenuPasteAtLevel(v, offset);
		if (c != null) {
			populateSelectWithMenu(brObj, c);
			if (isAfter == false) {
				brObj.options[sel].selected = false;
				if ((sel + 1) < brObj.options.length) {
					sel++;
				}
				brObj.options[sel].selected = true;
			}
			rebuildMenu(menuArray, false);
		}
	}
}

function processClipboardPasteToMenu(clipObj) {
	var brObj = getGUIObjectInstanceById('menu_browser');
	var bcpasteObj = getGUIObjectInstanceById(const_clipboard_paste_to_menu);
	var bcremoveObj = getGUIObjectInstanceById('clipboard_remove_item');
	var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
	var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
	if ( (brObj != null) && (clipObj != null) && (bcpasteObj != null) && (bcremoveObj != null) && (beforeObj != null) && (afterObj != null) ) {
		if (clipObj.selectedIndex != -1) {
			var v = _menu_clipboard[clipObj.selectedIndex];
			var b = isClipboardPaste();
			_pasteItemToMenu(v, afterObj.checked);
			if (b) {
				var clipObj = getGUIObjectInstanceById('menu_clipboard'); 
				if (clipObj != null) { 
					processClipboardRemoveSelected(clipObj);
				}
			}
		}
		if (isClipboardActuallyEmpty()) {
			hideShowMenuSaveButtons(true);
		}
	}
}

function processClipboardRemoveSelected(clipObj) {
	var brObj = getGUIObjectInstanceById('menu_browser');
	var bcpasteObj = getGUIObjectInstanceById(const_clipboard_paste_to_menu);
	var bcremoveObj = getGUIObjectInstanceById('clipboard_remove_item');
	var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
	var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
	var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
	var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
	if ( (brObj != null) && (clipObj != null) && (bcpasteObj != null) && (bcremoveObj != null) && (beforeObj != null) && (afterObj != null) && (bfontObj != null) && (afontObj != null) ) {
		var sel = clipObj.selectedIndex;
		if (sel != -1) {
			clipObj.options[sel] = null;
			removeArrayItem(_menu_clipboard,sel);

			if ( (clipObj.options.length == 0) || (isClipboardActuallyEmpty()) ) {
				bcpasteObj.disabled = true;
				beforeObj.disabled = true;
				afterObj.disabled = true;
				bcremoveObj.disabled = true;
				bfontObj.color = 'silver';
				afontObj.color = 'silver';
			} else {
				bcpasteObj.disabled = false;
				beforeObj.disabled = false;
				afterObj.disabled = false;
				bcremoveObj.disabled = false;
				bfontObj.color = 'black';
				afontObj.color = 'black';
			}
			if (clipObj.options.length == 0) {
				optObj = new Option(const_ClipboardEmpty_symbol,const_ClipboardEmpty_value);
				clipObj.options[0] = optObj;
				clipObj.options[0].selected = true;
			}
		}
	}
}

function processSelectedClipboardItem(clipObj) {
	var brObj = getGUIObjectInstanceById('menu_browser');
	var bcpasteObj = getGUIObjectInstanceById(const_clipboard_paste_to_menu);
	var bcremoveObj = getGUIObjectInstanceById('clipboard_remove_item');
	var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
	var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
	var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
	var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
	if ( (brObj != null) && (clipObj != null) && (bcpasteObj != null) && (bcremoveObj != null) && (beforeObj != null) && (afterObj != null) && (bfontObj != null) && (afontObj != null) ) {
		var _text = '';
		if (clipObj.selectedIndex != -1) {
			_text = clipObj.options[clipObj.selectedIndex].text;
		}
		if (_text.toUpperCase() == const_ClipboardEmpty_symbol.toUpperCase()) {
			bcremoveObj.disabled = true;
		} else {
			bcremoveObj.disabled = false;
		}
		if ( (brObj.selectedIndex == -1) && (brObj.options.length > 0) ) {
			brObj.options[brObj.options.length - 1].selected = true;
		}
		if ( ( (brObj.selectedIndex == -1) && (brObj.options.length > 0) ) || (bcremoveObj.disabled == true) ) {
			bcpasteObj.disabled = true;
			beforeObj.disabled = true;
			afterObj.disabled = true;
			bfontObj.color = 'silver';
			afontObj.color = 'silver';
		} else if (brObj.options.length == 0) {
			bcpasteObj.disabled = false;
			beforeObj.disabled = true;
			afterObj.disabled = true;
			bfontObj.color = 'silver';
			afontObj.color = 'silver';
		} else {
			bcpasteObj.disabled = false;
			beforeObj.disabled = false;
			afterObj.disabled = false;
			bfontObj.color = 'black';
			afontObj.color = 'black';
		}
		if ( (beforeObj.disabled == false) && (afterObj.disabled == false) && (beforeObj.checked == false) && (afterObj.checked == false) ) {
			afterObj.checked = true;
		}
	}
}

function debugObject(obj) {
	var _db = '' + (typeof obj) + '\n';
	if (typeof obj == const_object_symbol) {
		if (obj.length > 0) {
			for (var i = 0; i < obj.length; i++) {
				_db += obj[i] + '\n';
			}
		}
	} else {
		_db += obj + '\n';
	}
	return _db;
}

function trueItemCountOfMenuContainer(m) {
	var a = [];
	var cnt = 0;
	if (m.length > 1) {
		for (var i = 1; i < m.length; i++) {
			var o = m[i];
			if ( (typeof o != const_object_symbol) && (o != null) ) {
				a = o.split('|');
				if (a.length == 3) {
					if ( (a[0].toString().trim().length > 0) && (a[0].toString().trim().toUpperCase() != const_menuSubMenuEndsURL_symbol.trim().toUpperCase()) ) {
						cnt++;
					}
				}
			}
		}
	}
	return cnt;
}

function processSelectedmenuItem(brObj) {
	var clipObj = getGUIObjectInstanceById('menu_clipboard');
	var bbutObj = getGUIObjectInstanceById('menu_browse_into');
	var bcutObj = getGUIObjectInstanceById('menu_cut_to_clipboard');
	var bcopyObj = getGUIObjectInstanceById(const_menu_copy_to_clipboard_symbol);
	var bcpasteObj = getGUIObjectInstanceById(const_clipboard_paste_to_menu);
	var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
	var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
	var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
	var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
	var edmiObj = getGUIObjectInstanceById('edit_menu_item');
	var abObj = getGUIObjectInstanceById('addit_menu_item'); 
	var asObj = getGUIObjectInstanceById('addit_menu_submenu'); 
	if ( (brObj != null) && (bbutObj != null) && (bcutObj != null) && (bcopyObj != null) && (bcpasteObj != null) && (clipObj != null) && (beforeObj != null) && (afterObj != null) && (bfontObj != null) && (afontObj != null) && (edmiObj != null) && (abObj != null) && (asObj != null) ) {
		if (brObj.selectedIndex > -1) {
			var s = brObj.options[brObj.selectedIndex].text;
			var o = brObj.options[brObj.selectedIndex].value;
			if (o == const_object_symbol) {
				bbutObj.disabled = false;
				// disable the delete item button here, unless the submenu is empty ?!?
				var c = retrieveMenuAtLevel(menuArray, _menu_stack, 0);
				var offset = (_menu_stack.length == 0) ? 0 : 1;
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
			if ( (clipObj.selectedIndex == -1) || (isClipboardActuallyEmpty()) ) {
				bcpasteObj.disabled = true;
				beforeObj.disabled = true;
				afterObj.disabled = true;
				bfontObj.color = 'silver';
				afontObj.color = 'silver';
			} else {
				bcpasteObj.disabled = false;
				beforeObj.disabled = false;
				afterObj.disabled = false;
				bfontObj.color = 'black';
				afontObj.color = 'black';
			}
		} else {
//			asObj.disabled = true;
//			abObj.disabled = true;
			edmiObj.disabled = true;
			bcutObj.disabled = true;
			bcopyObj.disabled = true;
			bcpasteObj.disabled = true;
			beforeObj.disabled = true;
			afterObj.disabled = true;
			bfontObj.color = 'silver';
			afontObj.color = 'silver';
		}
	}
}

function processMenuBrowseInto(brObj) {
	var bbutObj = getGUIObjectInstanceById('menu_browse_into');
	var cbutObj = getGUIObjectInstanceById('menu_browse_out');
	if ( (brObj != null) && (bbutObj != null) && (cbutObj != null) ) {
		if (brObj.selectedIndex != -1) {
			bbutObj.disabled = true;
			cbutObj.disabled = false;

			var offset = (_menu_stack.length == 0) ? 0 : 1;
			_menu_stack.push(brObj.selectedIndex + offset);
			
			var s = brObj.options[brObj.selectedIndex].text;
			var o = brObj.options[brObj.selectedIndex].value;
			
			brObj.disabled = true;
			while (brObj.options.length > 0) {
				brObj.options[0] = null;
			}
			
			var c = retrieveMenuAtLevel(menuArray, _menu_stack, 0);
			if (c != null) {
				populateSelectWithMenu(brObj, c);
			}
			brObj.disabled = false;
		}
	}
}

function processMenuBrowseOut(brObj) {
	var cbutObj = getGUIObjectInstanceById('menu_browse_out');
	if ( (brObj != null) && (cbutObj != null) ) {
		var i = _menu_stack.pop();
		if (_menu_stack.length == 0) {
			cbutObj.disabled = true;
		}

		brObj.disabled = true;
		while (brObj.options.length > 0) {
			brObj.options[0] = null;
		}
		
		var c = retrieveMenuAtLevel(menuArray, _menu_stack, 0);
		if (c != null) {
			var bObj = getGUIObjectInstanceById('menu_browser');
			if (bObj != null) {
				populateSelectWithMenu(bObj, c);
			}
		}
		brObj.disabled = false;
	}
}

function populateSelectWithMenu(bObj, mm) {
	if (bObj != null) {
		var oObj;
		var _prompt;
		var toks;
		var option_index_i = 0;

		var sel = bObj.selectedIndex;
		bObj.disabled = true;
		while (bObj.options.length > 0) {
			bObj.options[0] = null;
		}

		for (var i = (_menu_stack.length == 0) ? 0 : 1; i < mm.length; i++) {
			if (mm[i] != null) {
				if (typeof mm[i] == const_object_symbol) {
					var c = mm[i];
					_prompt = '(' + retrieveMenuPrompt(c).URLDecode().clipCaselessReplace(const_old_Ellipsis_symbol, '') + ')';
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
		processSelectedmenuItem(bObj);
	}
}

function hideShowMenuSaveButtons(bool) {
	// bool == true controls the hide/show for the real menu save button - the other button follows suit...
	var msbObj1 = getGUIObjectInstanceById('menu_savedata_button');
	var msbObj2 = getGUIObjectInstanceById('menu_savedata_button2');
	if ( (msbObj1 != null) && (msbObj2 != null) ) {
		msbObj1.style.display = ((bool == true) ? const_inline_style : const_none_style);
		msbObj2.style.display = ((bool == true) ? const_none_style : const_inline_style);
	}
}

function ProcessMenuSaveToDatabase(mcObj) {
	var clipObj = getGUIObjectInstanceById('menu_clipboard');
	if (clipObj != null) {
		if ( (clipObj.options.length > 0) && (isClipboardActuallyEmpty() == false) ) {
			// clipboard is not empty so let the user know what's wrong...
			hideShowMenuSaveButtons(false);
		} else {
			if (isObjValidHTMLValueHolder(mcObj)) {
				mcObj.value = joinMenu( menuArray);
				var pObj = getGUIObjectInstanceById('hilite_color_preview');
				var dObj = getGUIObjectInstanceById('menu_color');
				var pObj2 = getGUIObjectInstanceById('hilite_color_preview2');
				var tObj = getGUIObjectInstanceById('menu_text_color');
				if ( (pObj != null) && (pObj2 != null) && (isObjValidHTMLValueHolder(dObj)) && (isObjValidHTMLValueHolder(tObj)) ) {
					dObj.value = pObj.bgColor;
					tObj.value = pObj2.bgColor;
				}
				return true;
			}
		}
	}
	return false;
}

function processCancelMenuItemEditor() {
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
	if ( (eObj != null) && (ebutObj != null) && (abutObj != null) && (asbutObj != null) && (clipObj != null) && (brObj != null) && (cmcObj != null) && (cmcObj2 != null) && (hcpObj != null) && (hcpObj2 != null) ) { 
		eObj.style.display = const_none_style; 
		ebutObj.style.display = const_inline_style; 
		abutObj.style.display = const_inline_style; 
		asbutObj.style.display = const_inline_style; 

		cmcObj.style.display = const_inline_style;
		cmcObj2.style.display = const_inline_style;
		
		hcpObj.style.display = const_inline_style;
		hcpObj2.style.display = const_inline_style;
		
		var a = -1;
		while (_menu_widgets_stack.length > 0) {
			a = _menu_widgets_stack.pop();
			var anObj = getGUIObjectInstanceById(a[0]);
			if (anObj != null) {
				anObj.disabled = a[1];
			}
		}

		var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
		if (pgObj != null) {
			// +++
			while (_stack_remember_to_remove_from_pglist.length > 0) {
				a = _stack_remember_to_remove_from_pglist.pop();
				for (var i = 0; i < pgObj.options.length; i++) {
					if (pgObj.options[i].text.trim().toUpperCase() == a.text.trim().toUpperCase()) {
						pgObj.options[i] = null;
						break;
					}
				}
			}
		}

		processSelectedmenuItem(brObj);
		processSelectedClipboardItem(clipObj);
	}
}

function processSaveMenuItemEditor() {
	var brObj = getGUIObjectInstanceById('menu_browser');
	var epObj = getGUIObjectInstanceById('_menu_item_editor_prompt');
	var iObj = getGUIObjectInstanceById('_menu_item_editor_internal');
	var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
	var hObj = getGUIObjectInstanceById('menu_item_editor_http');
	if ( (epObj != null) && (brObj != null) && (iObj != null) && (pgObj != null) && (hObj != null) ) {
		var c = retrieveMenuAtLevel(menuArray, _menu_stack, 0);
		if (c != null) {
			var offset = (_menu_stack.length == 0) ? 0 : 1;
			var sel = brObj.selectedIndex;
			if (sel < 0) {
				sel = 0;
			}

			if ( (isAddingMenuItem == false) && (isAddingMenuSubMenu == false) ) {
				var v = c[sel + offset];
				var _isSubMenu = false;
				if (typeof v == const_object_symbol) {
					v = v[0];
					_isSubMenu = true;
				}
				
				var _url = ' ';
				var _target = ' ';
				if (iObj.checked == true) {
					_url = const_cgi_script_name_symbol + const_currentPage_symbol + pgObj.options[pgObj.selectedIndex].text.trim();
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
				populateSelectWithMenu(brObj, c);
				rebuildMenu(menuArray, false);
			} else if (isAddingMenuItem == true) {
				var _url = ' ';
				var _target = ' ';
				if (iObj.checked == true) {
					_url = const_cgi_script_name_symbol + const_currentPage_symbol + pgObj.options[pgObj.selectedIndex].text.trim();
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
				_pasteItemToMenu(v, true);
				if (pgObj.selectedIndex != -1) {
					pgObj.options[pgObj.selectedIndex] = null;
				}
			} else if (isAddingMenuSubMenu == true) {
				var _empty_subMenu = new Array(0);

				var _url = const_subMenu_symbol;
				var _target = ' ';
				var _prompt = epObj.value.URLDecode().trim();
				if (_prompt.length == 0) {
					_prompt = ' ';
				} else {
					if (_prompt.indexOf(const_Ellipsis_symbol) == -1) {
						// _prompt += const_Ellipsis_symbol;
					}
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

				_empty_subMenu[2] = const_subMenuEnds_symbol;

				_pasteItemToMenu(_empty_subMenu, true);
			}
		}
	}

	return processCancelMenuItemEditor();
}

function refreshUrlType(_url) {
	var tlObj = getGUIObjectInstanceById(const_menu_url_typelist);
	if (tlObj != null) {
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
}

function _refreshUrlType() {
	var hObj = getGUIObjectInstanceById('menu_item_editor_http');
	if (hObj != null) {
		refreshUrlType(hObj.value.trim());
	}
}

function processChangedUrlType() {
	var hObj = getGUIObjectInstanceById('menu_item_editor_http');
	var tlObj = getGUIObjectInstanceById(const_menu_url_typelist);
	if ( (hObj != null) && (tlObj != null) ) {
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
}

function _processMenuItemEditor(brObj) {
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
	if ( (brObj != null) && (ebObj != null) && (abObj != null) && (asObj != null) && (edObj != null) && (epObj != null) && (clipObj != null) && (iObj != null) && (eObj != null) && (pgObj != null) && (hObj != null) && (cmcObj != null) && (cmcObj2 != null) && (hcpObj != null) && (hcpObj2 != null) ) {
		ebObj.style.display = const_none_style;
		edObj.style.display = const_inline_style;
		abObj.style.display = const_none_style;
		asObj.style.display = const_none_style;

		cmcObj.style.display = const_none_style;
		cmcObj2.style.display = const_none_style;
		
		hcpObj.style.display = const_none_style;
		hcpObj2.style.display = const_none_style;

		var c = retrieveMenuAtLevel(menuArray, _menu_stack, 0);
		if (c != null) {
			var offset = (_menu_stack.length == 0) ? 0 : 1;
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

			if ( (isAddingMenuItem == true) || (isAddingMenuSubMenu == true) ) {
				// adding something means we don't care about the current item that's in the menu...
				v = '';
				_isSubMenu = false;
			}

			var toks = v.split('|');
			if (toks.length > 1) {
				_url = toks[0].URLDecode().trim();
			}
			hObj.value = _url;
			refreshUrlType(_url);

			if (_isSubMenu == false) {
				if (_url.toUpperCase().indexOf(const_currentPage_symbol.trim().toUpperCase()) != -1) {
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
							// +++
							var optObj = new Option(_url, _url);
							var opts = [];
							for (var i = 0; i < pgObj.options.length; i++) {
								opts.push(pgObj.options[i]);
							}
							while (pgObj.options.length > 0) {
								pgObj.options[0] = null;
							}
							insertArrayItem(opts,optObj,0);
							_stack_remember_to_remove_from_pglist.push(optObj);
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

			if (isAddingMenuItem == true) {
				iObj.style.display = const_inline_style;
				eObj.style.display = const_inline_style;
				ifontObj.style.display = const_inline_style;
				efontObj.style.display = const_inline_style;
				pgObj.style.display = (i_checked) ? const_inline_style : const_none_style;
				hObj.style.display = (e_checked) ? const_inline_style : const_none_style;

				epObj.value = '';
				iObj.checked = i_checked;
				eObj.checked = e_checked;
				hObj.value = const_http_symbol;
				pgObj.selectedIndex = -1;
				_refreshUrlType();
			} else if ( (isAddingMenuSubMenu == true) || (_isSubMenu == true) ) {
				iObj.style.display = const_none_style;
				eObj.style.display = const_none_style;
				ifontObj.style.display = const_none_style;
				efontObj.style.display = const_none_style;
				pgObj.style.display = const_none_style;
				hObj.style.display = const_none_style;

				if ( (isAddingMenuSubMenu == true) || (_isSubMenu == true) ) {
					iObj.checked = false;
					eObj.checked = false;
				} else if (_isSubMenu == false) {
					epObj.value = '';
				}
			} else if ( (isAddingMenuItem == false) && (isAddingMenuSubMenu == false) ) {
				// need to determine if this is a submenu or a menuitem and then handle each accordingly...
				iObj.style.display = const_inline_style;
				eObj.style.display = const_inline_style;
				ifontObj.style.display = const_inline_style;
				efontObj.style.display = const_inline_style;
				iObj.checked = i_checked;
				eObj.checked = e_checked;
				pgObj.style.display = (i_checked) ? const_inline_style : const_none_style;
				hObj.style.display = (e_checked) ? const_inline_style : const_none_style;
			}

			processMenuEditorCheckLinkType();

			setFocusSafely(epObj);

			var b1Obj = getGUIObjectInstanceById('menu_browse_into');
			var b2Obj = getGUIObjectInstanceById('menu_browse_out');
			var b3Obj = getGUIObjectInstanceById('menu_cut_to_clipboard');
			var b3Obj = getGUIObjectInstanceById(const_menu_copy_to_clipboard_symbol);
			var b4Obj = getGUIObjectInstanceById(const_clipboard_paste_to_menu);
			var r1Obj = getGUIObjectInstanceById('clipboard_paste_before');
			var r2Obj = getGUIObjectInstanceById('clipboard_paste_after');
			var b5Obj = getGUIObjectInstanceById('menu_cut_to_clipboard');
			if ( (b1Obj != null) && (b2Obj != null) && (b3Obj != null) && (b4Obj != null) && (b5Obj != null) && (r1Obj != null) && (r2Obj != null) ) {
				var a = new Array(0);
				a[0] = b1Obj.id;
				a[1] = b1Obj.disabled;
				_menu_widgets_stack.push(a);

				b1Obj.disabled = true;

				var a = new Array(0);
				a[0] = b2Obj.id;
				a[1] = b2Obj.disabled;
				_menu_widgets_stack.push(a);

				b2Obj.disabled = true;

				var a = new Array(0);
				a[0] = b3Obj.id;
				a[1] = b3Obj.disabled;
				_menu_widgets_stack.push(a);

				b3Obj.disabled = true;

				var a = new Array(0);
				a[0] = b4Obj.id;
				a[1] = b4Obj.disabled;
				_menu_widgets_stack.push(a);

				b4Obj.disabled = true;

				var a = new Array(0);
				a[0] = b5Obj.id;
				a[1] = b5Obj.disabled;
				_menu_widgets_stack.push(a);

				b5Obj.disabled = true;

				var a = new Array(0);
				a[0] = r1Obj.id;
				a[1] = r1Obj.disabled;
				_menu_widgets_stack.push(a);

				r1Obj.disabled = true;

				var a = new Array(0);
				a[0] = r2Obj.id;
				a[1] = r2Obj.disabled;
				_menu_widgets_stack.push(a);

				r2Obj.disabled = true;
			}

			var a = new Array(0);
			a[0] = clipObj.id;
			a[1] = clipObj.disabled;
			_menu_widgets_stack.push(a);
			clipObj.disabled = true;

			var a = new Array(0);
			a[0] = brObj.id;
			a[1] = brObj.disabled;
			_menu_widgets_stack.push(a);
			brObj.disabled = true;
		}
	}
}

function processMenuSubMenuAdditor(brObj) {
	var tObj = getGUIObjectInstanceById('_menu_item_editor_title');
	if (tObj != null) {
		tObj.innerHTML = '<small><b>Add Empty SubMenu</b></small>';
	}
	isAddingMenuSubMenu = true;
	isAddingMenuItem = false;
	return _processMenuItemEditor(brObj);
}

function processMenuItemAdditor(brObj) {
	var tObj = getGUIObjectInstanceById('_menu_item_editor_title');
	if (tObj != null) {
		tObj.innerHTML = '<small><b>Add Menu Item</b></small>';
	}
	isAddingMenuItem = true;
	isAddingMenuSubMenu = false;
	return _processMenuItemEditor(brObj);
}

function processMenuItemEditor(brObj) {
	var tObj = getGUIObjectInstanceById('_menu_item_editor_title');
	if (tObj != null) {
		tObj.innerHTML = '<small><b>Edit Menu Item</b></small>';
	}
	isAddingMenuItem = false;
	isAddingMenuSubMenu = false;
	return _processMenuItemEditor(brObj);
}

function refreshMenuItemEditorSaveButton() {
	var iObj = getGUIObjectInstanceById('_menu_item_editor_internal');
	var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
	var sbObj = getGUIObjectInstanceById(const_menu_item_editor_saveButton);
	var prObj = getGUIObjectInstanceById('_menu_item_editor_prompt');
	var hObj = getGUIObjectInstanceById('menu_item_editor_http');
	if ( (iObj != null) && (pgObj != null) && (sbObj != null) && (prObj != null) && (hObj != null) ) {
		if (isAddingMenuItem == true) {
			if (iObj.checked == true) {
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
}

function processMenuEditorCheckLinkType() {
	var iObj = getGUIObjectInstanceById('_menu_item_editor_internal');
	var eObj = getGUIObjectInstanceById('_menu_item_editor_external');
	var pObj = getGUIObjectInstanceById('menu_item_editor_pageList_pane');
	var phObj = getGUIObjectInstanceById('menu_item_editor_http_pane');
	var pgObj = getGUIObjectInstanceById('menu_item_editor_pageList');
	var hObj = getGUIObjectInstanceById('menu_item_editor_http');
	if ( (iObj != null) && (eObj != null) && (pObj != null) && (phObj != null) && (pgObj != null) && (hObj != null) ) {
		pObj.style.display = (iObj.checked == true) ? const_inline_style : const_none_style;
		pgObj.style.display = (iObj.checked == true) ? const_inline_style : const_none_style;
		phObj.style.display = (eObj.checked == true) ? const_inline_style : const_none_style;
		hObj.style.display = (eObj.checked == true) ? const_inline_style : const_none_style;
		refreshMenuItemEditorSaveButton();
	}
}

function processClipboardPasteBecomesMove(anObj) {
	var dObj = getGUIObjectInstanceById('clipboard_paste_becomes_move_div');
	var rObj = getGUIObjectInstanceById('clipboard_remove_item');
	var pmObj = getGUIObjectInstanceById(const_clipboard_paste_to_menu);
	if ( (anObj != null) && (dObj != null) && (rObj != null) && (pmObj != null) ) {
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
		dObj.innerHTML = '<font size="-1" id="clipboard_paste_becomes_move_font"><small><b>Clipboard Paste to Menu<br>&nbsp;&nbsp;&nbsp;' + joining_symbol + 'Remove</b></small></font>';
	}
}

function isClipboardPaste() {
	var anObj = getGUIObjectInstanceById('clipboard_paste_becomes_move'); 
	if (anObj != null) { 
		return (anObj.checked);
	}
	return false;
}

function handle_menuBrowser_dblclick() {
	var brObj = getGUIObjectInstanceById('menu_browser'); 
	if (brObj != null) { 
		if (brObj.selectedIndex > -1) {
			var o = brObj.options[brObj.selectedIndex].value;
			if (o == const_object_symbol) {
				processMenuBrowseInto(brObj);
			}
		}
	} 
	
	return false;
}

function handle_menuBrowser_change() {
	var brObj = getGUIObjectInstanceById('menu_browser'); 
	if (brObj != null) { 
		processSelectedmenuItem(brObj);
	} 
	
	return false;
}

function initMenuEditorClipboardObjects() {
	var rObj = getGUIObjectInstanceById('rightmenu_wrapper');
	if (rObj != null) {
		var html = '';
		html += '<br><br><br><br><br>';
		html += '<div id="right_side_content">';
		html += '<div id="welcome">';
		html += '<p align="justify" style="font-size: 10px; line-height: 10px;">';
		html += 'This is the ClipBoard.  The ClipBoard can hold onto Menu Items to allow you to Copy-And-Paste using the buttons and controls you see in the interface below the ClipBoard.';
		html += '</p>';
		html += '</div>';
		html += '<table cellpadding="-1" cellspacing="-1">';
		html += '<tr>';
		html += '<td>';
	
		html += '<table cellpadding="-1" cellspacing="-1">';
		html += '<tr>';
		html += '<td>';
		html += '<center>';
		html += '<select id="menu_clipboard" size="5" style="font-size: 10px; line-height: 10px;" onchange="var clipObj = getGUIObjectInstanceById(\'menu_clipboard\'); if (clipObj != null) { processSelectedClipboardItem(clipObj) } return false;">';
		html += '</select>';
		html += '</center>';
		html += '</td>';
		html += '</tr>';
	
		html += '<tr>';
		html += '<td>';
		html += '<input type="button" id="clipboard_remove_item" value="Remove Clipboard Item" disabled style="font-size: 10px;" onClick="var clipObj = getGUIObjectInstanceById(\'menu_clipboard\'); if (clipObj != null) { processClipboardRemoveSelected(clipObj) } return false;">';
		html += '</td>';
		html += '</tr>';
	
		html += '<tr>';
		html += '<td>';
	
		html += '<table cellpadding="-1" cellspacing="-1">';
		html += '<tr>';
		html += '<td>';
		var _html = _setup_tooltip_handlers(const_clipboard_paste_to_menu, const_empty_symbol);
		html += '<input type="button" ' + _html + ' disabled value="Paste to Menu" style="font-size: 10px;" title="Click this button to move a Menu Item or SubMenu Item from the ClipBoard to the Menu perhaps to a different position than the item had been in originally for the purpose or reorganizing or reordering the Menu." onClick="var clipObj = getGUIObjectInstanceById(\'menu_clipboard\'); if (clipObj != null) { processClipboardPasteToMenu(clipObj) } return false;">';

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
		html += '<NOBR><input type="checkbox" id="clipboard_paste_becomes_move" value="MOVE" alt="(Plus sign means auto-Remove from ClipBoard)" onClick="var anObj = getGUIObjectInstanceById(\'clipboard_paste_becomes_move\'); if (anObj != null) { processClipboardPasteBecomesMove(anObj); setCookie(const_ClipboardPasteMode_symbol, anObj.checked, const_forward_slash_symbol); } return true;">&nbsp;<span id="clipboard_paste_becomes_move_div" style="line-height: 10px;"><font size="-1" id="clipboard_paste_becomes_move_font"><small><b>Clipboard Paste to Menu with auto-Remove</b></small></font></span></NOBR>';
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
		if (anObj != null) { 
			var c = getCookie(const_ClipboardPasteMode_symbol);
			if ( (c != null) && (c.length > 0) ) {
				anObj.checked = eval(c);
			}
			processClipboardPasteBecomesMove(anObj);
		}
		anObj.checked = true;
		processClipboardPasteBecomesMove(anObj);
		// END! Initialize this item...
	
		var sObj = getGUIObjectInstanceById('menu_clipboard');
		var beforeObj = getGUIObjectInstanceById('clipboard_paste_before');
		var afterObj = getGUIObjectInstanceById('clipboard_paste_after');
		var bfontObj = getGUIObjectInstanceById('clipboard_paste_before_font');
		var afontObj = getGUIObjectInstanceById('clipboard_paste_after_font');
		if (sObj != null) {
			var optObj;
			if (sObj.options.length == 0) {
				optObj = new Option(const_ClipboardEmpty_symbol,const_ClipboardEmpty_value);
				sObj.options[0] = optObj;
				sObj.options[0].selected = true;
			}
			sObj.disabled = true;
			if (beforeObj != null) {
				beforeObj.checked = true;
				beforeObj.disabled = true;
			}
			if (bfontObj != null) {
				bfontObj.color = 'silver';
			}
			if (afterObj != null) {
				afterObj.checked = false;
				afterObj.disabled = true;
			}
			if (afontObj != null) {
				afontObj.color = 'silver';
			}
		}
	}

	var criObj = getGUIObjectInstanceById('clipboard_remove_item');
	if (criObj != null) {
		// it was deemed "just too easy" for the end-user to delete items with this button active however allowing them to delete right from the menu was deemed okay ?!?  Go figure !
		criObj.style.display = const_none_style;
	}
	
	var eObj = getGUIObjectInstanceById('_menu_item_editor');
	if (eObj != null) {
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
			// html += '<td valign="top">';
			// html += '<font size="1"><small><b>Url:</b></small></font>';
			// html += '</td>';
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
			html += '<input type="button" ' + _html + ' value="' + const_cancelButton_symbol + '" style="font-size: 9px;" title="Click this button to Cancel the operation currently in-process." onClick="processCancelMenuItemEditor(); return false;">';
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
			if ( (eObj != null) && (sbObj != null) ) {
				var a = s.split(',');
				for (var i = 0; i < a.length; i++) {
					oObj = new Option( a[i], a[i]);
					eObj.options[eObj.options.length] = oObj;
				}
				a = sn.split(',');
				for (var i = 0; i < a.length; i++) {
					a[i] = a[i].stripTickMarks();
				}
				aa = const_listOfRequiredSpecialPages.split(',');
				for (var i = 0; i < aa.length; i++) {
					var ii = locateArrayItemsCaseless(a, aa[i], 0);
					if (ii != -1) {
						removeArrayItem(a,ii);
					}
				}
				for (var i = 0; i < a.length; i++) {
					if ( (a[i] != null) && (a[i].trim().length > 0) ) {
						oObj = new Option( a[i], a[i]);
						eObj.options[eObj.options.length] = oObj;
					}
				}
				for (var i = 0; i < aa.length; i++) {
					if ( (aa[i] != null) && (aa[i].trim().length > 0) ) {
						for (var ik = 0; ik < eObj.options.length; ik++) {
							if (eObj.options[ik].text.trim().toUpperCase() == aa[i].trim().toUpperCase()) {
								eObj.options[ik] = null;
							}
						}
					}
				}
				sbObj.disabled = true;
			}
			
			var tlObj = getGUIObjectInstanceById(const_menu_url_typelist);
			if (tlObj != null) {
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
			}
		}
	}
}

function openCloseMenuChangeColors(bool) {
	var dObj1 = getGUIObjectInstanceById('div_menu_browser');
	var dObj2 = getGUIObjectInstanceById('_div_menu_browser');
	if ( (dObj1 != null) && (dObj2 != null) ) {
		dObj1.style.display = ((bool == true) ? const_none_style : const_inline_style);
		dObj2.style.display = ((bool == true) ? const_inline_style : const_none_style);
	}
	return ((bool == true) ? false : true);
}

var pressed_color_button_flag = -1;

var _stack_hilite_color_preview = [];

function processMenuChangeColors(brObj) {
	var hcObj = getGUIObjectInstanceById('hilite_color');
	var hcpObj = getGUIObjectInstanceById('hilite_color_preview');
	if ( (hcObj != null) && (hcpObj != null) ) {
		pressed_color_button_flag = 0;
		var a = [];
		a.push(hcpObj.id);
		a.push(hcpObj.bgColor);
		_stack_hilite_color_preview.push(a);
		cp.select(hcObj,hcpObj,'ColorPicker', -330, 0); 
	}
	return false;
}

function processMenuChangeTextColors(brObj) {
	var hcObj = getGUIObjectInstanceById('hilite_color2');
	var hcpObj = getGUIObjectInstanceById('hilite_color_preview2');
	if ( (hcObj != null) && (hcpObj != null) ) {
		pressed_color_button_flag = 1;
		var a = [];
		a.push(hcpObj.id);
		a.push(hcpObj.bgColor);
		_stack_hilite_color_preview.push(a);
		cp.select(hcObj,hcpObj,'ColorPicker', -330, 0); 
	}
	return false;
}

function debugCSS() {
	var _db = '';
	_db += 'document.styleSheets.length = ' + document.styleSheets.length;
//	_db += 'CSSStyleSheet.cssRules.length = ' + CSSStyleSheet.cssRules.length;
	for (var i = 0; i < document.styleSheets.length; i++) {
//		_db += 'document.styleSheets[i].{cssrules}[0].selectorText = ' + document.styleSheets[i].{cssrules}[0].selectorText;
		// alert(document.styleSheets[i].{cssrules}[0].selectorText);
		if (document.styleSheets[i].cssText) {
//			_db += 'document.styleSheets[' + i + '].cssText = \n(' + document.styleSheets[i].cssText + ')';
		}
	}
	alert('debugCSS()\n' + _db);
}
