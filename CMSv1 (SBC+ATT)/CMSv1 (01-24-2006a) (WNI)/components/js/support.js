function acceptsAlphaNumerics(ch) {
	return ( ( (ch >= 'a'.charCodeAt(0)) && (ch <= 'z'.charCodeAt(0)) ) || ( (ch >= 'A'.charCodeAt(0)) && (ch <= 'Z'.charCodeAt(0)) ) || ( (ch >= '0'.charCodeAt(0)) && (ch <= '9'.charCodeAt(0)) ) ? true : false);
}

function changePage(newLoc) {
	nextPage = newLoc.options[newLoc.selectedIndex].value
	
	if (nextPage != "") {
		document.location.href = nextPage
	}
 }
 
 function hideShow(myForm) {
	target = document.all('_url_text');
	// target is the element (in this case a div) with the name as shown...
	if (myForm._linkage.selectedIndex != 0)	{ 
		myForm._url.style.display = const_none_style;
		target.style.display = const_none_style;
		myForm._url.disabled = true;
	} else { 
		url_header = const_http_symbol;
		myForm._url.style.display = const_inline_style;
		target.style.display = const_inline_style;
		myForm._url.disabled = false;
		if (myForm._url.value.indexOf(url_header) == -1) {
			myForm._url.value = url_header + myForm._url.value;
		}
	}
	
	val = myForm._linkage.options[myForm._linkage.selectedIndex].value;
	i = val.indexOf("|");
	if (i != -1) {
		toks = val.split("|");
		pn = toks[0];
		pt = toks[1];
		myForm._prompt.value = pt;
	}
 }
 
 function mungeTitleIntoName(pName) {
	_theName = "";
	_pName = pName + "";
	
	for (i = 0; i < _pName.length; i++) {
		ch = _pName.substring(i, i + 1);
		if ( (ch >= "0") && (ch <= "z") ) {
			_theName = _theName + ch;
		} else {
			_theName = _theName + "_";
		}
	}

	return _theName;
 }
 
function focusOnPageTitle() {
	var emObj = getGUIObjectInstanceById('_errorMessage');
	var emObj2 = getGUIObjectInstanceById('_errorMessage2');
	var emObj3 = getGUIObjectInstanceById('_errorMessage3');
	var emObj4 = getGUIObjectInstanceById('_errorMessage4');
	var sbObj = getGUIObjectInstanceById('saveButton');
	if ( (emObj != null) && (emObj2 != null) && (emObj3 != null) && (emObj4 != null) && (sbObj != null) ) {
		emObj.style.display = const_none_style; 
		emObj2.style.display = const_none_style; 
		emObj3.style.display = const_none_style; 
		emObj4.style.display = const_none_style; 
		sbObj.disabled = false;
		return true;
	}
	return true;
}
 
function showPreviouslyUsedListPopUp(listObj, puObj) {
//	var puObj = getGUIObjectInstanceById('popup_errorMessage');
	if ( (puObj != null) && (listObj != null) && (isObjValidHTMLValueHolder(listObj)) ) {
		var _list = listObj.value;
		var toks = _list.split(",");

		var _html = '';
		for (var i = 0; i < toks.length; i++) {
			_html += '' + toks[i] + ', ';
		}
		_html += '';
		
		puObj.value = _html;
	}
}

var okayToSubmit = false;
var _EmptySquareBrackets = '';
 
function ensureUnique(_buttonObj, _errorMessageObj, _pageTitleObj, listObj, _okayToDisable) {
 	var _list = '';
	var _matched = "";

	if ( (_buttonObj != null) && (_errorMessageObj != null) && (_pageTitleObj != null) && (listObj != null) ) {
		if (isObjValidHTMLValueHolder(listObj)) {
			_list = listObj.value;
		}
		toks = _list.split(",");
		
		_pName = mungeTitleIntoName(_pageTitleObj.value);
		
		_buttonObj.disabled = false;
		_errorMessageObj.style.display = const_none_style;
		okayToSubmit = true;

		for (var i = 0; i < toks.length; i++) {
			if (_pName.toUpperCase() == toks[i].toUpperCase()) {
				_matched = "***";
			}
			if (_matched.length > 0) {
				okayToSubmit = false;
				if (_okayToDisable) {
					_buttonObj.disabled = true;
				}
				_errorMessageObj.style.display = const_inline_style;
				break;
			}
		}
	}

	if (_matched.length == 0) {
		var pname = '';
		var pnObj = getGUIObjectInstanceById('pageName');
		if ( (pnObj != null) && (isObjValidHTMLValueHolder(pnObj)) ) {
			pname = pnObj.value.trim();
		}
		// +++
		if (pname.trim().length == 0) {
			// the user only see's the page name change when the page is initially created otherwise not...
			if (_buttonObj.value.trim().toUpperCase().indexOf('[]') != -1) {
				if (_EmptySquareBrackets.trim().length == 0) {
					_EmptySquareBrackets = _buttonObj.value.trim();
				}
				_buttonObj.value = _EmptySquareBrackets.replace('[]', '[' + _pName + ']');
			} else {
				if (_EmptySquareBrackets.trim().length == 0) {
					_EmptySquareBrackets = _buttonObj.value.trim();
				}
				var _s = "[" + _pName + "]";
				var _toks = _EmptySquareBrackets.split('[');
				if (_toks.length > 1) {
					var _toks2 = _toks[1].split(']');
					if (_toks2.length > 1) {
						var _symbol = '[' + _toks2[0] + ']';
						_buttonObj.value = _EmptySquareBrackets.replace(_symbol, _s);
					}
				}
			}
		}
	} else if (_matched.length > 0) {
		var pueObj = getGUIObjectInstanceById('popup_errorMessage');
		showPreviouslyUsedListPopUp(listObj, pueObj);
	}
	
	return (_matched.length);
 }
 
function _validateUniquePageName(_okayToDisable) {
 	if (okayToSubmit != -1) {
		var lobj = getGUIObjectInstanceById('t_existingPageNameList');
		var sbObj = getGUIObjectInstanceById('saveButton');
		var emObj = getGUIObjectInstanceById('_errorMessage');
		var ptObj = getGUIObjectInstanceById('_pageTitle');
		var emObj2 = getGUIObjectInstanceById('_errorMessage2');
		var pueObj = getGUIObjectInstanceById('popup_errorMessage');
		var pueObj2 = getGUIObjectInstanceById('popup_errorMessage2');
		var emObj4 = getGUIObjectInstanceById('_errorMessage4');
		if ( (lobj != null) && (sbObj != null) && (emObj != null) && (ptObj != null) && (emObj2 != null) && (pueObj != null) && (pueObj2 != null) && (emObj4 != null) ) {
			emObj.style.display = const_none_style;
			emObj2.style.display = const_none_style;
			emObj4.style.display = const_none_style;
			_disableHtmlEditorButtons(true, false);

			if (ptObj.value.trim().length > 0) {
			 	var _result = ensureUnique(sbObj, emObj, ptObj, lobj, _okayToDisable);
				
				emObj.style.display = const_none_style;
				emObj2.style.display = const_none_style;
			 	if (okayToSubmit == false) {
					emObj2.style.display = const_inline_style;
					showPreviouslyUsedListPopUp(lobj, pueObj2);
					return false;
				} else {
					_disableHtmlEditorButtons(false, false);
					return true;
				}
			} else {
				emObj4.style.display = const_inline_style;
				return false;
			}
		}
	}
	return false; // assume there is a problem and the operation is a no-go...
 }
 function validateUniquePageName(_list) {
 	if (okayToSubmit != -1) {
	 	ensureUnique(document.all.saveButton, document.all._errorMessage, document.all._pageTitle, _list, false);
	}

	document.all._errorMessage.style.display = const_none_style;
	document.all._errorMessage2.style.display = const_none_style;
 	if (okayToSubmit == false) {
		document.all._errorMessage2.style.display = const_inline_style;
		return false;
	} else {
		return true;
	}
 }

 function getWindowScreenSize() {
	return screen.width + ',' + screen.height;
}

function isObjValidTextHolder(anObj) {
	var _retVal = false;

	if ( (anObj != null) && ((anObj.type == "text") || (anObj.type == "textarea")) ) {
		_retVal = true;
	}
	
	return _retVal;
}
			
function isObjValidHTMLValueHolder(anObj) {
	var _retVal = false;

	if ( (anObj != null) && ((anObj.type == "text") || (anObj.type == "hidden") || (anObj.type == "textarea")) ) {
		_retVal = true;
	}
	
	return _retVal;
}
			
function processHtmlEditorSaveButtonClick() {
	var pObj = getGUIObjectInstanceById('_pageContent');
	if (isObjValidHTMLValueHolder(pObj)) {
		pObj.value = pObj.value.trim(); // .stripCrLfs();
	}
}

function processHtmlEditorCommentsSaveButton() {
	var obj3 = getGUIObjectInstanceById('_pageComments');
	var mcObj = getGUIObjectInstanceById('_errorMessage3');
	var formObj = getGUIObjectInstanceById('wysiwyg_htmlEditor_form');
	if ( (obj3 != null) && (mcObj != null) && (formObj != null) ) {
		// try to also perform a gibberish checker here to make sure all words are English words with 1 or more vowels and 1 or more non-vowels.
		if (obj3.value.trim().stripCrLfs().trim().length == 0) {
			mcObj.style.display = const_inline_style;
			return false;
		} else {
			mcObj.style.display = const_none_style;
			processHtmlEditorCancelCommentsClick(); 
			_disableHtmlEditorButtons(true, true); 
			processHtmlEditorSaveButtonClick();
			formObj.submit(); // auto-submit the form because the submit button is disabled and the form won't submit by itself.
			return true;
		}
	}
	return false;
}

_stack_wysiwyg_htmlEditor_comments_pane = [];

function processHtmlEditorCommentsClick() {
	var obj0 = getGUIObjectInstanceById('_wysiwyg_htmlEditor_pane_top');
	var obj1 = getGUIObjectInstanceById('_wysiwyg_htmlEditor_pane');
	var obj2 = getGUIObjectInstanceById('_wysiwyg_htmlEditor_comments_pane');
	var obj1a = getGUIObjectInstanceById('_wysiwyg_htmlEditor_submit');
	var obj2a = getGUIObjectInstanceById('_wysiwyg_htmlEditor_comments_submit');
	var obj3 = getGUIObjectInstanceById('_pageComments');
	var mcObj = getGUIObjectInstanceById('_errorMessage3');
	if ( (obj0 != null) && (obj1 != null) && (obj2 != null) && (obj1a != null) && (obj2a != null) && (obj3 != null) && (mcObj != null) ) {
		obj0.style.display = const_none_style;
		obj1.style.display = const_none_style;
		obj2.style.display = const_inline_style;
		
		var _anchor_obj = getGUIObjectInstanceById('position_comments_pane');
		if (_anchor_obj != null) {
			var m_coord = getAnchorPosition(_anchor_obj.name);
			var a = [];
			a.push(obj2.id);
			a.push(obj2.style.left);
			_stack_wysiwyg_htmlEditor_comments_pane.push(a);
			// obj2.style.left = (m_coord.x - 200).toString() + 'px';
		}

		obj1a.style.display = const_none_style;
		obj2a.style.display = const_inline_style;
		mcObj.style.display = const_none_style;
		setFocusSafely(obj3);
		hideShow_myTextSize(true);
		
		var sbObj1 = getGUIObjectInstanceById('saveButton1');
		var sbObj2 = getGUIObjectInstanceById('saveButton2');
		if ( (sbObj1 != null) && (sbObj2 != null) ) {
			var sText = '';
			var a = sbObj1.value.split('[');
			if (a.length == 2) {
				var b = a[1].split(']');
				if (b.length == 2) {
					sText = b[0].trim();
				}
			}
			if (sText.trim().length > 0) {
				var sText2 = '';
				var a2 = sbObj2.value.split('[');
				if (a2.length == 2) {
					var b2 = a2[1].split(']');
					if (b2.length == 2) {
						sText2 = b2[0].trim();
						if (sText2.trim().length == 0) {
							sbObj2.value = a2[0].trim() + ' [' + sText.trim() + '] ' + b2[1].trim();
						}
					}
				}
			}
		}
	}
}

function _disableHtmlEditorButtons(bool, bool2) {
	var btnObj1 = getGUIObjectInstanceById('saveButton1');
	var btnObj1a = getGUIObjectInstanceById('cancelPopUp1');
	var btnObj2 = getGUIObjectInstanceById('saveButton2');
	var btnObj2a = getGUIObjectInstanceById('cancelPopUp2');
	if ( (btnObj1 != null) && (btnObj1a != null) && (btnObj2 != null) && (btnObj2a != null) ) {
		btnObj1.disabled = ((bool == true) ? true : false);
		btnObj1a.disabled = ((bool2 == true) ? true : false); // cancel buttons are NEVER disabled - user should be allowed to exit anytime
		btnObj2.disabled = ((bool == true) ? true : false);
		btnObj2a.disabled = ((bool2 == true) ? true : false); // cancel buttons are NEVER disabled - user should be allowed to exit anytime
	}
}

function processHtmlEditorCancelCommentsClick() {
	var obj0 = getGUIObjectInstanceById('_wysiwyg_htmlEditor_pane_top');
	var obj1 = getGUIObjectInstanceById('_wysiwyg_htmlEditor_pane');
	var obj2 = getGUIObjectInstanceById('_wysiwyg_htmlEditor_comments_pane');
	var obj1a = getGUIObjectInstanceById('_wysiwyg_htmlEditor_submit');
	var obj2a = getGUIObjectInstanceById('_wysiwyg_htmlEditor_comments_submit');
	if ( (obj0 != null) && (obj1 != null) && (obj2 != null) && (obj1a != null) && (obj2a != null) ) {
		obj0.style.display = const_inline_style;
		obj1.style.display = const_inline_style;
		
		var a = [];
		while (_stack_wysiwyg_htmlEditor_comments_pane.length > 0) {
			a = _stack_wysiwyg_htmlEditor_comments_pane.pop();
			var xPos = a.pop();
			var _id_ = a.pop();
			if (obj2.id == _id_) {
				obj2.style.left = xPos;
			}
		}
		
		obj2.style.display = const_none_style;
		obj1a.style.display = const_inline_style;
		obj2a.style.display = const_none_style;
		hideShow_myTextSize(false);
	}
}

function _autoCorrectLinksAndImages(_context, _images_context, _divName, bool_isServerLocal) {
	var _stack = [];
	
	var _divObj = getGUIObjectInstanceById(_divName);
	if ( (_divName != null) && (_divName.length > 0) && (_divObj != null) ) {
		_stack.push(_divObj);
	} else {
		var divObj = getGUIObjectInstanceById('container');
		if (divObj != null) {
			var divs = divObj.getElementsByTagName("DIV");
			for (var i = 0; i < divs.length; i++) {
				_divObj = divs[i];
				if ( (_divObj != null) && (_divObj.id) ) {
					_stack.push(divs[i]);
				}
			}
		}
	}
	
	function _autoCorrectLinkObj(obj, _c) {
		var s = '';
		var ii = obj.href.trim().toUpperCase().indexOf(const_currentPage_symbol.trim().toUpperCase());
		if (ii == -1) {
			if (obj.target.trim().toUpperCase() != const_blank_symbol.trim().toUpperCase()) {
				obj.target = const_blank_symbol.trim().toLowerCase();
				s += '[xx]';
			}
		} else {
			if (obj.target.trim().length > 0) {
				obj.target = '';
				s += '[xx]';
			}
			var i = obj.href.trim().indexOf(const_slash_slash_symbol.trim());
			if (i != -1) {
				i = obj.href.trim().indexOf(const_slash_slash_symbol.trim(), i++);
			} else {
				i = obj.href.trim().indexOf(const_slash_symbol.trim());
			}
			var tok0 = obj.href.trim().substring(0, i);
			obj.href = tok0 + _c + const_indexcfm_symbol + obj.href.trim().substring(ii, obj.href.trim().length);
		}
		return s;
	}

	function _autoCorrectImgSrc(src, _ic) {
		var _db = '';
		var _debugMode = false;
		var _rpath_prefix = '';
		var aa = const_cgi_script_name_symbol.trim().split('/');
		var _pfix = const_http_symbol + const_cgi_server_name_symbol + '/';
		var _f = src.trim().toUpperCase().indexOf(_pfix.trim().toUpperCase());
		if (_f != -1) {
			src = src.trim().substring(_f + _pfix.trim().length - 1, src.trim().length);
		}
		if (aa.length > 0) {
			for (var i = 0; i < aa.length; i++) {
				if (aa[i].trim().length > 0) {
					_rpath_prefix = '/' + aa[i].trim();
					break;
				}
			}
		}
		if (_debugMode) _db += 'bool_isServerLocal = ' + bool_isServerLocal + '\n';
		if (_debugMode) _db += 'src = ' + src + '\n';
		if (_debugMode) _db += 'aa = (' + aa + ')\n';
		if (_debugMode) _db += '_rpath_prefix = ' + _rpath_prefix + '\n';
		var _f_images_uploaded = src.trim().toUpperCase().indexOf(const_images_uploaded_symbol.trim().toUpperCase());
		if (_debugMode) _db += '_f_images_uploaded = ' + _f_images_uploaded + '\n';
		var _f_images_prime = src.trim().toUpperCase().indexOf(const_images_prime_symbol.trim().toUpperCase());
		if (_debugMode) _db += '_f_images_prime = ' + _f_images_prime + '\n';
		var _okay_to_process = false;
		if (src.trim().toUpperCase().indexOf(const_components_symbol.trim().toUpperCase()) == -1) {
			if (src.trim().toUpperCase().indexOf(const_images_symbol.trim().toUpperCase()) != -1) {
				if (src.trim().toUpperCase().indexOf(_rpath_prefix.trim().toUpperCase()) != -1) {
					_okay_to_process = true;
				}
			} else if ( (_f_images_prime == 0) && (_f_images_uploaded == -1) ) {
				_okay_to_process = true;
			}
		}
		if (_debugMode) _db += '_okay_to_process = ' + _okay_to_process + '\n';
		if (_okay_to_process) {
			var i = src.trim().indexOf(const_slash_slash_symbol.trim());
			if (i != -1) {
				i = src.trim().indexOf(const_slash_slash_symbol.trim(), i++);
			} else {
				i = src.trim().indexOf(const_slash_symbol.trim());
			}
			var tok0 = src.trim().substring(0, i);
			var tok = src.trim().substring(i, src.trim().length);
			var a = tok.split(const_slash_symbol);
			var _name = _ic.trim().toLowerCase() + a[a.length - 1];
	
			bool_isServerLocal = true; // this line of code and this variable may not be needed now so forcing true to test it...
			if (_debugMode) _db += 'a = (' + a + ')\n';
			if (_debugMode) _db += '_name = ' + _name + '\n';
			if (_debugMode) _db += '(tok0 + _name) = ' + (tok0 + _name) + '\n';
			if (_debugMode) _db += 'return = ' + ( (bool_isServerLocal == true) ? _name : (tok0 + _name) ) + '\n';
			if (_debugMode) alert('A. ' + _db);
			return ( (bool_isServerLocal == true) ? _name : (tok0 + _name) );
		} else {
			if (_debugMode) _db += 'return = ' + src + '\n';
			if (_debugMode) alert('B. ' + _db);
			return src;
		}
	}

	function _autoCorrectImgObj(obj, _ic) {
		obj.src = _autoCorrectImgSrc(obj.src, _ic);
	}

	var a_links = [];	
	var a_imgs = [];	
	for (; _stack.length > 0; ) {
		var obj = _stack.pop();
		if (obj != null) {
			var _links = '';
			var _imgs = '';
			try {
				_links = obj.getElementsByTagName("a");
			} catch(e) {
			} finally {
			}
			try {
				_imgs = obj.getElementsByTagName("img");
			} catch(e) {
			} finally {
			}
			if (_links.length > 0) {
				for (var i = 0; i < _links.length; i++) {
					a_links.push(_links[i]);
				}
			}
			if (_imgs.length > 0) {
				for (var i = 0; i < _imgs.length; i++) {
					a_imgs.push(_imgs[i]);
				}
			}
		}
	}

	var ss = '';
	for (var i = 0; i < a_imgs.length; i++) {
		var t_was = '';
		var l = a_imgs[i];
		if (l.src.trim().toUpperCase().indexOf(_images_context.trim().toUpperCase()) == -1) {
			_autoCorrectImgObj(l, _images_context.trim().toUpperCase());
		}
	}

	var s = '';
	var ss = '';
	for (var i = 0; i < a_links.length; i++) {
		var t_was = '';
		var l = a_links[i];
		if (l.href.trim().length > 0) {
			var i_context = l.href.trim().toUpperCase().indexOf(_context.trim().toUpperCase());
			if ( (l.href.trim().toUpperCase().indexOf(const_function_symbol.trim().toUpperCase()) == -1) && (l.href.trim().toUpperCase().indexOf(const_mailto_symbol.trim().toUpperCase()) == -1) ) {
				var _href_len = l.href.trim().length;
				var _context_len = ((i_context == -1) ? 0 : i_context) + _context.trim().length;
				if ( (i_context != -1) && (_href_len > _context_len) ) {
					t_was = l.target;
					ss = _autoCorrectLinkObj(l, _context);
				} else if ( (i_context != -1) && (_href_len != _context_len) ) {
					t_was = l.target;
					ss = _autoCorrectLinkObj(l, _context);
				} else if (i_context == -1) {
					t_was = l.target;
					ss = _autoCorrectLinkObj(l, _context);
				}
			}
		}
	}
	
	// collect up the special cases from the layout spec of all objects with id's beginning with cell_imageNN
	for (var i = 1; i < 100; i++) {
		var ciObj = getGUIObjectInstanceById('cell_image' + i.toString());
		if (ciObj == null) {
			break;
		} else {
			if (ciObj.background) {
				ciObj.background = _autoCorrectImgSrc(ciObj.background, _images_context.trim().toUpperCase());
			}
		}
	}
}

function LinkObj(url, description, target, img) {
  this.url = url;
  this.description = description;
  this.target = (target != null) ? target : "myCMSv1";
  this.image = img;
  return this;
}

function gotoUrl(x) {
  if (right_side_image_links[x].target != null)
	window.open(right_side_image_links[x].url, right_side_image_links[x].target);
  else
	location.href = right_side_image_links[x].url;
}

function showStatus(x) {
  window.status = right_side_image_links[x].description;
}

function getImageName(x) {
  return right_side_image_links[x].image;
}

function processSiteSearchClick(parked_id) {
	var fObj = getGUIObjectInstanceById('form_site_search_link');
	var sskObj = getGUIObjectInstanceById('site_search_keyword');
	if ( (fObj != null) && (sskObj != null) ) {
		var _width = clientWidth();
		var xPos_m = _width - (_width / 2);
		var yPos_m = 200;
		if ( (parked_id != null) && (parked_id.trim().length > 0) ) {
			var _tt_obj = getGUIObjectInstanceById(parked_id);
			if (_tt_obj != null) {
				var m_coord = getAnchorPosition(parked_id);
				xPos_m = m_coord.x;
				yPos_m = m_coord.y;
			}
		}
		fObj.style.left = xPos_m.toString() + 'px';
		fObj.style.top = yPos_m.toString() + 'px';
		fObj.style.display = const_inline_style;
		sskObj.focus();
	}
	return false;
}

function processCloseSiteSearchDialog() {
	var fObj = getGUIObjectInstanceById('form_site_search_link');
	if (fObj != null) {
		fObj.style.display = const_none_style;
	}
	return false;
}

function processSiteSearchFormSubmit(formObj) {
	var fObj = getGUIObjectInstanceById('form_site_search_link');
	var kObj = getGUIObjectInstanceById('site_search_keyword');
	if ( (fObj != null) && (isObjValidHTMLValueHolder(kObj)) ) {
		if (kObj.value.trim().length > 0) {
			fObj.style.display = const_none_style;
			formObj.submit();
			return true;
		}
	}
	alert('Cannot perform a search unless a keyword is entered other than (' + kObj.value.trim() + ').');
	kObj.focus();
	return false;
}
