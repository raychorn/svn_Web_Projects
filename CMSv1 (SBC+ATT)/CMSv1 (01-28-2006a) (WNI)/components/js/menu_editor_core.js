//var const_Ellipsis_symbol = '...';
var const_Ellipsis_symbol = '&raquo;'; // String.fromCharCode(187);

var const_old_Ellipsis_symbol = '...';

function cleanUpMenuArray(mm) {
	// clean-up the array by taking out things that are now null from the end of the array...
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
				if (_url.trim() == const_subMenuEnds_symbol.trim()) {
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
}

function loadMenuEditor(sObj) {
	var isDebug = false;
	
	s = '';
	if (isObjValidHTMLValueHolder(sObj)) {
		s = sObj.value;
	}
	
	if (isDebug) {
		var _do = '' + s + '\n\n========================================\n\n';
	}
	
	var menuArray_i = 0;

	if (isDebug) {
		_do += 'typeof menuArray=(' + (typeof menuArray) + ')\n';
		_do += 'typeof _do=(' + (typeof _do) + ')\n\n';
	}
	
	var a = s.split(",");
	for (var i = 0; i < a.length; i++) {
		menuArray[menuArray.length] = a[i];
	}

	var somethingToDo = true;
	var lastBegin_i = -1;
	var lastEnd_i = -1;

	if (isDebug) {
		_do += 'menuArray.length=(' + menuArray.length + ')\n\n';
	}
	
	while (somethingToDo) {
		for (i = 0; i < menuArray.length; i++) {
			if (menuArray[i] == null) {
				break;
			}
			if ((typeof menuArray[i]) != const_object_symbol) {
				toks = menuArray[i].split("|");
				if (toks[0].URLDecode() == const_subMenu_symbol) {
					lastBegin_i = i;
				}
				if (toks[0].URLDecode() == const_subMenuEnds_symbol) {
					lastEnd_i = i;
					break;
				}
			}
		}
		somethingToDo = ( (lastBegin_i != -1) && (lastEnd_i != -1) );
		if (somethingToDo) {
			var container = new Array(0);
			for (i = lastBegin_i; i <= lastEnd_i; i++) {
				container[container.length] = menuArray[i];
			}
			menuArray[lastBegin_i] = container;
			
			var _d = lastBegin_i + 1;
			var _s = lastEnd_i + 1;
			for (; _s < menuArray.length; _s++) {
				menuArray[_d] = menuArray[_s];
				_d++;
			}
			for (; _d < menuArray.length; _d++) {
				menuArray[_d] = null;
			}
			
			if (isDebug) {
				_do += 'lastBegin_i=(' + lastBegin_i + ')' + ', lastEnd_i=(' + lastEnd_i + ')' + ', menuArray[lastBegin_i].length=(' + menuArray[lastBegin_i].length + ')' + ', menuArray.length=(' + menuArray.length + ')';
				_do += '\n\n';
			}

			lastBegin_i = -1;
			lastEnd_i = -1;

			if (isDebug) {
				// BEGIN: Debug Code...
				for (i = 0; i < menuArray.length; i++) {
					if (menuArray[i] == null) {
						break;
					}
					if ((typeof menuArray[i]) != const_object_symbol) {
						toks = menuArray[i].split("|");
						var _url = toks[0];
						_do += '_url[' + i + ']=(' + _url + ')\n';
					} else {
						_do += 'subMenu[' + i + ']=(' + menuArray[i] + ')\n';
					}
				}
				// END! Debug Code...
			}
		}
	}

	if (isDebug) {
		// BEGIN: Debug Code...
		for (i = 0; i < menuArray.length; i++) {
			if (menuArray[i] == null) {
				break;
			}
			if ((typeof menuArray[i]) != const_object_symbol) {
				toks = menuArray[i].split("|");
				var _url = toks[0];
				_do += '_url[' + i + ']=(' + _url + ')\n';
			} else {
				_do += 'subMenu[' + i + ']=(' + menuArray[i] + ')\n';
			}
		}
				
		if ( (isDebug) && (_do.length > 0) ) {
			var cp = DebugPopUp('', true, 800, 600, 'Debugger Window for loadMenuEditor()',  _do);
			cp.show(null);
			_do = '';
		}
	}
	// END! Debug Code...

	cleanUpMenuArray(menuArray);
}

var _do = '';

function DebugPopUp_show(anchorname, offsetX, offsetY) {
	this.offsetX = offsetX;
	this.offsetY = offsetY;
	this.showPopup(anchorname);
}

function DebugPopUp_autoHideFunction() {
}

function DebugPopUp(divname, windowMode, width, height, title, contents) {
	// Create a new PopupWindow object
	/*
		ColorPicker('divname', false, width)
				or
		ColorPicker('', true, width)
	*/
	
	if (divname != "") {
		var cp = new PopupWindow(divname);
	} else {
		var cp = new PopupWindow();
		cp.setSize(width,height);
	}

	// Method Mappings
	cp.show = DebugPopUp_show;

	var cp_contents = "";
	var windowRef = (windowMode)?"window.opener.":"";
	if (windowMode) {
		cp_contents += '<HTML><HEAD><TITLE>' + title + '</TITLE></HEAD>';
		cp_contents += '<BODY MARGINWIDTH=0 MARGINHEIGHT=0 LEFTMARGIN=0 TOPMARGIN=0><CENTER>';
	}
	var bgColor = '#FFFFBB';
	cp_contents += '<table cellspacing="-1" cellpadding="-1">';

	cp_contents += '<tr><td>';
	cp_contents += '<table border="1" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" cellspacing="1" cellpadding="0">';
	cp_contents += '<tr><td>';
	cp_contents += '<textarea cols="110" rows="40" readonly wrap="soft" style="font-size: 11px; background-color: ' + bgColor + ';">';
	cp_contents += contents;
	cp_contents += '</textarea>';
	cp_contents += '</td></tr>';
	cp_contents += '</TABLE>';
	cp_contents += '</td></tr>';

	cp_contents += '<tr><td align="center" valign="top">';
	cp_contents += '<center><a href="" onclick="window.close(); return false;"><small style="font-size: 12px;"><b>[Close Window]</b></small></a></center>';
	cp_contents += '</td></tr>';

	cp_contents += '</TABLE>';

	if (windowMode) {
		cp_contents += '</CENTER></BODY></HTML>';
	}
	// end populate code

	// Write the contents to the popup object
	cp.populate(cp_contents+"\n");
	// Move the table down a bit so you can see it
	cp.offsetX = 0;
	cp.offsetY = 0;
	cp.autoHide(DebugPopUp_autoHideFunction);
	return cp;
}

function makeSiteUrl(_functionSymbol, _functionArgs) {
	var aSiteUrl = "";

	var scriptName = const_cgi_script_name_symbol;
	aSiteUrl +=	scriptName + "?function=" + escape(_functionSymbol) + _functionArgs;

	return aSiteUrl;
}

function getCurrentPageFromURL(_theUrl, currentPage_symbol) {
	var _curPage = '';
	
	if (_theUrl.toUpperCase().indexOf(currentPage_symbol.toUpperCase()) > -1) {
		var toks = _theUrl.split('?');
		var toks2 = toks[1].split('=')
		_curPage = toks2[1];
	}
	
	return _curPage;
}

function processMenuModeChange() {
	_global_menu_mode = ((_global_menu_mode == true) ? false : true);
	rebuildMenu(menuArray, true);
}

function rebuildMenu( mm, includeLinks) {
	// if includeLinks == false then we're in the menu editor so rebuild the pagelist...
	var _html = '';

	var pglistObj = null;
	if (includeLinks == false) {
		pglistObj = getGUIObjectInstanceById('menu_item_editor_pageList');
	}

	var a_breadCrumbs = [];
	
	var _parentTagName = 'ul';
	var _tagClass = 'class="cascadingMenu"';
	var _childTagName = 'li';
	var _tagColors = '';
	var parent_tagColors = '';
	var _tagStyles = '';
	var e_tagStyles = '';
	var anchor_tagStyles = '';
	var e_anchor_tagStyles = '';
	var lastone_tagStyles = '';
	if (_global_menu_mode == true) {
		_parentTagName = 'div';
		_tagClass = '';
		_childTagName = 'div';
		parent_tagColors = 'background: #3081e4; margin: 0px; padding: 2px; ';
		lastone_tagStyles = 'border-bottom: 1px solid black;';
		_tagStyles = getTagStyles(getDisplayTagStyles(false) + getTagColors(162, parent_tagColors), '');
		anchor_tagStyles = const_anchor_menu_anchorStyles;
		e_tagStyles = getTagStyles(getDisplayTagStyles(true) + getTagColors(162, parent_tagColors), '');
	}

	if (b_isServerLocal) {
//		_html += '<center><input type="button" value="[' + ((_global_menu_mode == true) ? 'Old' : 'New') + ']" style="font-size: 10px; font-weight: bold;" onclick="processMenuModeChange(); return false;" ondblclick="return false;"></center>';
	}

	_html += '<' + _parentTagName + ' id="nav" ' + _tagClass + ' ' + e_tagStyles + '>';

	var _editableFlag = true;
	if (global_menuItemEditorsList.length > 0) {
		if (_global_menu_mode) {
			_html += '<' + _parentTagName + ' id="navEdits">';
		}
		var sArray = global_menuItemEditorsList.split('|');

		for (var si = 0; si < sArray.length; si++) {
			_html += '<' + _childTagName + ' ' + e_tagStyles + '>' + sArray[si] + '</' + _childTagName + '>';
		}
		_editableFlag = true;
		if (_global_menu_mode) {
			_html += '</' + _parentTagName + '>';
		}
	}

	function getTagColors(width, parent_tagColors) {
		var _tagColors = '';
		if (parent_tagColors) {
		} else {
			parent_tagColors = '';
		}
		if (_global_menu_mode == true) {
			_tagColors = parent_tagColors + ' width: ' + parseInt(width) + 'px; ' + 'border-top: 1px solid black; border-left: 1px solid black; border-right: 1px solid black;';
		}
		return _tagColors;
	}
	
	function getTagStyles(styles, lastOne) {
		if (styles) {
		} else {
			styles = '';
		}
		if (lastOne) {
		} else {
			lastOne = '';
		}
		var s = 'style="' + styles + ' ' + lastOne + '"';
		return ((_global_menu_mode == true) ? s : '');
	}

	function getDisplayTagStyles(isShown) {
		var s = 'display: ' + ((isShown == true) ? const_block_style : const_none_style) + '; ';
		return ((_global_menu_mode == true) ? s : '');
	}

	function newTagNamed(tagName, isParent) {
		if (_global_menu_mode == true) {
			var _id = 'navNode' + ((isParent == true) ? 'p' : 'c') + '_';
			for (var i = 0; i < a_breadCrumbs.length; i++) {
				_id += a_breadCrumbs[i].toString() + ((i == (a_breadCrumbs.length - 1)) ? '' : '_');
			}
		}
		var s = tagName;
		if (_global_menu_mode == true) {
			s += ' id="' + _id + '"';
		}
		return s;
	}

	function processUnlinkableContentPageName(_curPage) {
		if (pglistObj != null) {
			for (var i = 0; i < pglistObj.options.length; i++) {
				if (pglistObj.options[i].text.trim().toUpperCase() == _curPage.trim().toUpperCase()) {
					// the page of content is on the list so remove it from the list and stop processing...
					pglistObj.options[i] = null;
					break;
				}
			}
		}
	}
	
	function rebuildMenuNode(c) {
		var menuLink = '';
		var _theLink = '';

		function makeMenuItemControlPanel(menuLink, isSubMenu) {
			var _html = '';

			var _width1 = '162px';
			var _width2 = '10px';
			if (isSubMenu == true) {
				_width1 = '152px';
				_width2 = '10px';
			}
			
			_a_style = 'style="border: thin outset Silver; width: 16px; text-align: center; vertical-align: bottom;"';

			_html += '<table cellpadding="1" cellspacing="2">';

			_html += '<tr>';
			_html += '<td width="' + _width1 + '" align="left">';
			_html += '<font size="1" style="font-size: 9px;">';
			_html += menuLink;
			_html += '</font>';
			_html += '</td>';
			_html += '<td width="' + _width2 + '" align="right">';
			_html += '<font color="white">';
			_html += ((isSubMenu == true) ? const_Ellipsis_symbol : '&nbsp;');
			_html += '</font>';
			_html += '</td>';
			_html += '</tr>';

			_html += '</table>';
			return _html;
		}

		var _db = '';
		if (a_breadCrumbs.length == 1) {
			_db = '\n(' + c + ')';
		}
//alert('c.length = ' + c.length + ', c = (' + c + '), a_breadCrumbs.length = ' + a_breadCrumbs.length + _db);
		for (var i = 0; i < c.length; i++) {
			a_breadCrumbs.pop(); 			// this throws the current breadCrumb away...
			a_breadCrumbs.push(i);          // this makes a new breadCrumb to mark where we are... on this level...
			if (c[i] != null) {
				if (typeof c[i] == const_object_symbol) {
					a_breadCrumbs.push(i);  // this makes a new breadCrumb to mark where we are... on the next level...
					rebuildMenuNode(c[i]);
				} else if (c[i].trim().length > 0) {
					// BEGIN: Process a node from the menu
//alert('c[' + i + '] = ' + c[i]);
					var toks = c[i].split('|');
					var _url = '';
					if (toks.length > 0) {
						_url = toks[0].trim().URLDecode();
					}
					var _target = '';
					if (toks.length > 1) {
						_target = toks[1].trim();
					}
					var _prompt = '';
					if (toks.length > 2) {
						_prompt = toks[2].trim();
					}
					
					if (_prompt.length == 0) {
						_prompt = '.';
					} else {
						_prompt = _prompt.URLDecode();
					}

					if (_prompt.length > 0) {
						_lastOne = '';

						if (_url.trim() == const_subMenu_symbol.trim()) {
							menuLink = '<NOBR>' + _prompt.clipCaselessReplace(const_old_Ellipsis_symbol, '') + '</NOBR>';
							// subMenu's don't get links at this time...
							if ( (includeLinks) && (0) ) {
								menuLink = '<a href="' + _url.trim() + '" ' + getTagStyles(anchor_tagStyles) + '>' + menuLink + '</a>';
							} else {
								// hovers only work when there is a link so give it a bogus link...
								menuLink = '<a href="#" ' + getTagStyles(anchor_tagStyles) + '>' + menuLink + '</a>';
							}
							_theLink = menuLink;
							
							if (_editableFlag) {
								_theLink = makeMenuItemControlPanel( _theLink, true);
							}
							_theLink += '<' + newTagNamed(_parentTagName, true) + ' ' + getTagStyles(getDisplayTagStyles(a_breadCrumbs.length == 2) + parent_tagColors, '') + '>';
							_html += '<' + newTagNamed(_childTagName, false) + ' ' + getTagStyles(getDisplayTagStyles(a_breadCrumbs.length == 2) + getTagColors(162, parent_tagColors), _lastOne) + '>' + _theLink;
						} else if (_url.trim() == const_subMenuEnds_symbol.trim()) {
							_html += '</' + _parentTagName + '></' + _childTagName + '>';
						} else {
							var _docIcon = '';
							var _curPage = getCurrentPageFromURL( _url, const_currentPage_symbol);
							if (_curPage.length > 0) {
								var baseURL = _url;
								var parmsURL = '';
								var _toks = _url.split('?');
								if (_toks.length == 2) {
									baseURL = const_cgi_script_name_symbol + '?';
									parmsURL = _toks[1];
									var _toks2 = parmsURL.split('=');
									var parmsL = _toks2[0];
									var parmsR = _toks2[1];
									parmsURL = parmsL + '=' + escape(parmsR);
								}
								_url = baseURL + parmsURL;
								processUnlinkableContentPageName(_curPage);
							} else {
								// BEGIN: Determine if this is a Panagons link or another external link
								if (_url.toUpperCase().indexOf(const_panagons_link_symbol.toUpperCase()) > -1) {
									_docIcon = '<img src="' + const_menu_note_symbol + '" alt="Link to a Panagons Document" width="10" border="0">&nbsp;';
								} else if (_url.trim().length > 0) {
									_docIcon = '<img src="' + const_menu_folderclosed_symbol + '" alt="Link to an External Document" width="10" border="0">&nbsp;';
								} else {
									_docIcon = '';
								}
								// END! Determine if this is a Panagons link or another external link
							}
							_theLink = '<NOBR>' + _docIcon + _prompt + '</NOBR>';
							if (includeLinks) {
								_menuLink = '<a href="' + _url + '" ' + getTagStyles(anchor_tagStyles);
								if (_target.length > 0) {
									_menuLink += ' target="' + _target + '"';
								}
								_menuLink += '>' + _theLink + '</a>';
								_theLink = _menuLink;
							} else {
								_menuLink = '<a href="#" ' + getTagStyles(anchor_tagStyles);
								_menuLink += '>' + _theLink + '</a>';
								_theLink = _menuLink;
							}
							if (_editableFlag) {
								_theLink = makeMenuItemControlPanel( _theLink, false);
							}
							_html += '<' + newTagNamed(_childTagName, false) + ' ' + getTagStyles(getDisplayTagStyles(a_breadCrumbs.length == 1) + getTagColors(162, parent_tagColors), _lastOne) + '>' + _theLink + '</' + _childTagName + '>';
						}
					}
					// END! Process a node from the menu
				}
			}
		}
		a_breadCrumbs.pop(); // this throws the current breadCrumb away... takes us back to the level above...
		return _html;
	}
	var obj = getGUIObjectInstanceById("leftmenu");
	if (obj != null) {
		a_breadCrumbs.push(0);
		rebuildMenuNode(mm);
		flushGUIObjectChildrenForObj(obj);
		obj.innerHTML = _html;
		sfHover();
	}
	return _html;
}
