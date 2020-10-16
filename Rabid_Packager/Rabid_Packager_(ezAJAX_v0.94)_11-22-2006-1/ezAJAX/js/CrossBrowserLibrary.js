/** BEGIN: Globals ************************************************************************/
_cache_onload_functions = [];

_cache_tooltips = [];
_stack_tooltips_obj = [];
_cache_tooltips_timerId = [];
_cache_tooltips_functions = [];

const_text_symbol = 'text';
const_hidden_symbol = 'hidden';
const_textarea_symbol = 'textarea';
const_password_symbol = 'password';
const_select_one_symbol = 'select-one';

const_blank_symbol = '_blank';
const_slash_slash_symbol = '//';
const_slash_symbol = '/';
const_indexcfm_symbol = 'index.cfm';

const_http_symbol = 'http://';
const_https_symbol = 'https://';
const_mailto_symbol = 'mailto:';
const_ftp_symbol = 'ftp://';
const_other_symbol = '(other)';

const_cursor_hand = 'hand';
const_cursor_default = 'default';

const_radio_symbol = 'radio';
const_checkbox_symbol = 'checkbox';
const_button_symbol = 'button';

const_submit_symbol = 'submit';
const_cancel_symbol = 'cancel';

const_backgroundColor_symbol = 'backgroundColor';

const_no_response_symbol = 'No';

const_true_value_symbol = 'True';

const_gif_filetype_symbol = '.gif';
const_jpg_filetype_symbol = '.jpg';
const_jpeg_filetype_symbol = '.jpeg';

const_images_symbol = '/images/';             		// used by _autoCorrectLinksAndImages()
const_components_symbol = '/components/';     		// used by _autoCorrectLinksAndImages()
const_images_prime_symbol = 'images/';        		// used by _autoCorrectLinksAndImages()
const_images_uploaded_symbol = '/uploaded-images/'; // used by _autoCorrectLinksAndImages()

const_panagons_link_symbol = 'http://panagons';

const_anchor_menu_anchorStyles = 'text-decoration: none; font-weight: bold; color: white; padding: 2px;';

const_error_color_light_red = '#FF9A88';
const_button_hilite_color_light_yellow = '#FFFFBF';
const_paper_color_light_yellow = '#FFFFBF';
const_button_pressed_color_light_blue = '#B3D9FF';
const_site_menu_color_light_white = '#f1f1f1';
const_bgcolor_silver = '#c0c0c0';

/** END! Globals ************************************************************************/

function makeHrefGeneric(href) {
	var i = -1;
	var arToks = ['?', '.cfm', '.cfml', '.php', '.htm', '.html'];
	var j = -1;
	var k = -1;
	var _href = '';
	var bool_Okay2Null = false;
	var ar = href.split('/');
	for (i = ar.length - 1; ( (i >= 0) && (!bool_Okay2Null) ); i--) {
		for (j = 0; j < arToks.length; j++) {
			if (bool_Okay2Null = (ar[i].toUpperCase().indexOf(arToks[j].toUpperCase()) != -1)) {
				for (k = i; k < ar.length; k++) {
					ar[k] = null;
				}
				break;
			}
		}
	}
	_href = ar.join('/');
	return _href;
}

function isObjValidHTMLValueHolder(anObj) {
	return ( (anObj != null) && ((anObj.type.toLowerCase() == const_text_symbol.toLowerCase()) || (anObj.type.toLowerCase() == const_hidden_symbol.toLowerCase()) || (anObj.type.toLowerCase() == const_textarea_symbol.toLowerCase())) );
}
			
function _setup_tooltip_handlers(_id_, _parked_id_) {
	_html = '';
	
	_html += 'id="' + _id_ + '"';
	js_id = '\'' + _id_ + '\'';

	if (_parked_id_ == null) {
		_parked_id_ = '';
	}
	js_pid = '\'' + _parked_id_ + '\'';

	_html += ' onmouseover="handle_ToolTip_MouseOver(event, ' + js_id + ', ' + js_pid + '); return false;" onmouseout="handle_ToolTip_MouseOut(event, ' + js_id + '); return false;"';
	
	return _html;
}

function html_tooltips(s) {
	var _html = '';
	
	if ( (!!s) && (s.ezTrim().length > 0) ) {
		_html += '<div id="div_html_tooltips">';
		_html += '<p align="justify" style="font-size: 9px;"><b>' + s + '</b></p>';
		_html += '<a name="_table_html_tooltips_anchor"></a>';
		_html += '</div>';
	}
	
	return _html;
}

function toolTipWatcherProcess() {
	// this process exists in case the widget which had been enabled at the time the sticky tooltip was made visible then became disabled and the tooltip remained visible because a disabled widget doesn't get events...
	// the better way to do this might have been to handle events higher up in the DOM chain however this method took less development time, at the time it was conceived...
	var _obj = -1;
	for (var i = 0; i < _stack_tooltips_obj.length; i++) {
		_obj = _stack_tooltips_obj[i];
		try {
			if (!!_obj) {
				if ( (_obj.disabled == true) || (_obj.style.display == const_none_style) ) {
					handle_ToolTip_MouseOut(null, _obj.id);
				}
			}
		} catch(e) {
		} finally {
		}
	}
}

function terminateToolTipWatcherProcess() {
	var tid = -1;
	for (; _cache_tooltips_timerId.length > 0; ) {
		tid = _cache_tooltips_timerId.pop();
		clearInterval(tid);
	}
}

function startToolTipWatcherProcess() {
	// Make sure the clock is stopped
	terminateToolTipWatcherProcess();
	var tid = setInterval("toolTipWatcherProcess()", 333);
	_cache_tooltips_timerId.push(tid);
}

function handle_ToolTip_MouseOver(ev, id, parked_id) {
	var adjustedX = false;
	var adjustedY = false;
	var obj = _$(id);
	var anchorPos = ezAnchorPosition.get$(parked_id);
	if ( (!!obj) && (!!anchorPos) ) {
		var xPos_m = -1;
		var yPos_m = -1; // master x,y position for the tooltips if the anchor is defined...
		if ( (!!parked_id) && (parked_id.ezTrim().length > 0) ) {
			var _tt_obj = _$(parked_id);
			if (!!_tt_obj) {
				xPos_m = anchorPos.x;
				yPos_m = anchorPos.y; // master x,y position for the tooltips if the anchor is defined...
			}
		}
		var tt_obj = _$('_delayed_tooltips');
		if (!!tt_obj) {
			var _clientHeight = ezClientHeight();
			var _clientWidth = ezClientWidth();
			if ( (obj.title) && (obj.title.ezTrim().length > 0) ) {
				_cache_tooltips[id] = obj.title;
				obj.title = '';
			}
			_stack_tooltips_obj.push(obj);
			var xPos = (ev.clientX + document.body.scrollLeft);
			if ((xPos + 400) >= _clientWidth) {
				adjustedX = true;
				xPos = _clientWidth - 400;
			}
			if (xPos_m != -1) {
				xPos = xPos_m;
			}
			tt_obj.style.left = xPos.toString() + 'px';
			var yPos = (ev.clientY + document.body.scrollTop);
			var ns = _cache_tooltips[id];
			if (ns == null) {
				ns = '';
			}
			ns = ns.ezStripHTML();
			var ni = (((ns.length * 10) / (400 - 50)) + 2) * 10;
			if ((yPos + ni) >= _clientHeight) {
				adjustedY = true;
				yPos = _clientHeight - ni;
			} else if (adjustedX) {
				yPos += 20;
			}
			if (yPos_m != -1) {
				yPos = yPos_m;
			}
			tt_obj.style.top = yPos.toString() + 'px';
			tt_obj.innerHTML = html_tooltips(_cache_tooltips[id]);
			tt_obj.style.display = const_inline_style;

			if (obj.disabled == false) {
				startToolTipWatcherProcess();
			}
			handle_tooltips_functions(true);
		}
		ezAnchorPosition.remove$(anchorPos.id);
	}
}

function handle_ToolTip_MouseOut(ev, id) {
	var obj = _$(id);
	if ( (!!obj) && (!!_cache_tooltips[id]) ) {
		var tt_obj = _$('_delayed_tooltips');
		if (!!tt_obj) {
			// obj.title = _cache_tooltips[id];
			_stack_tooltips_obj.pop(); // flush the stack - also need to kill the background process at this point...
			terminateToolTipWatcherProcess();
			// _cache_tooltips[id] = null;
			tt_obj.style.display = const_none_style;
			handle_tooltips_functions(false);
		}
	}
}

function attachToolTipEvents(el) {
	if (el.attachEvent) { // IE
		el.attachEvent("onMouseOver", handle_ToolTip_MouseOver);
		el.attachEvent("onMouseOut", handle_ToolTip_MouseOut);
	} else if (document.addEventListener) { // Gecko / W3C
		el.addEventListener("onMouseOver", handle_ToolTip_MouseOver, true);
		el.addEventListener("onMouseOut", handle_ToolTip_MouseOut, true);
	} else {
		el["onMouseOver"] = handle_ToolTip_MouseOver;
		el["onMouseOut"] = handle_ToolTip_MouseOut;
	}
}

function attachToolTipEventsTo(a) {
	var s = '';
	if (!!a) {
		var ta = typeof a;
		if (ta.ezTrim().toUpperCase() == const_object_symbol.ezTrim().toUpperCase()) {
			for (var i = 0; i < a.length; i++) {
				if ( (a[i].title) && (a[i].id) && (a[i].id.ezTrim().length > 0) && (a[i].title.ezTrim().length > 40) ) {
					s += 'a[i].id = ' + a[i].id + ' (' + a[i].title.ezTrim().length + ')\n';
					attachToolTipEvents(a[i]);
				}
			}
		}
	}
}

function handleScroll(ev) {
	window.status = 'handleScroll() :: document.body.scrollLeft = ' + document.body.scrollLeft + ', document.body.scrollTop = ' + document.body.scrollTop;
}

function register_tooltips_function(f) {
	_cache_tooltips_functions.push(f);
}

function handle_tooltips_functions(bool) {
	for (var i = 0; i < _cache_tooltips_functions.length; i++) {
		var f = _cache_tooltips_functions[i];
		f(bool);
	}
}

function handle_onload_functions() {
	for (var i = 1; _cache_onload_functions.length > 0; i++) {
		var f = _cache_onload_functions.pop();
		if (!!f) {
			eval(f);
		}
	}
}

function register_onload_function(f) {
	_cache_onload_functions.push(f);
}

function isTextarea(obj) {
	if (!!obj) {
		return (obj.tagName.toLowerCase() == const_textarea_symbol.toLowerCase());
	}
	return false;
}

function _disable_button(btnObj) {
	if (!!btnObj) {
		btnObj.disabled = true;
	}
}

function debugProbe(arrayOfVarNames) {
	var _db = '';
	var varName = '';
	var varValue = '';

	for (var i = 0; i < arrayOfVarNames.length; i++) {
		varName = arrayOfVarNames[i].ezTrim();
		try {
			varValue = eval(varName);
		} catch(e) {
			// ezErrorExplainer(e, 'debugProbe(' + arrayOfVarNames + ')');
		} finally {
		}
		_db += varName + ' = (' + varValue + ')';
		if (i < (arrayOfVarNames.length - 1)) {
			_db += ', ';
		}
	}
	ezAlert('debugProbe(' + arrayOfVarNames + ')\n' + _db);
}

function makeArrayFromThese(vararg_params) {
	var i = 0;
	var a = [];
	
    for (i = 0; i < arguments.length; i++) {
		a.push(arguments[i]);
    }
	return a;
}

cache_flash_button_timers = [];

function unflash_button(btnObj) {
	// btnObj must have an id to be handled by this function...
	if (!!btnObj) {
		if (btnObj.id.ezTrim().length > 0) {
			if (!!cache_flash_button_timers[btnObj.id]) {
				var a = cache_flash_button_timers[btnObj.id];
				if (typeof a == const_object_symbol) {
					for (; a.length > 0; ) {
						clearTimeout(a.pop());
					}
				}
				cache_flash_button_timers[btnObj.id] = null;
			}
		}
	}
}

function _flash_button(btnObj, color1, color2) {
	// btnObj must have an id to be handled by this function...
	if (!!btnObj) {
		if (btnObj.id.ezTrim().length > 0) {
			if (!!cache_flash_button_timers[btnObj.id]) {
				var a = cache_flash_button_timers[btnObj.id];
				if (typeof a == const_object_symbol) {
					// make color change here...
					btnObj.style.color = color1;
					if (a.length == 1) {
						a.push(setInterval(_flash_button, 50, btnObj, color1, color2));
						cache_flash_button_timers[btnObj.id] = a;
					} else {
						btnObj.style.color = color2;
					}
				}
			}
		}
	}
}

function flash_button(btnObj, color1, color2) {
	// btnObj must have an id to be handled by this function...
	if (!!btnObj) {
		if (btnObj.id.ezTrim().length > 0) {
			if (cache_flash_button_timers[btnObj.id] == null) {
				var a = [];
				a.push(setInterval(_flash_button, 50, btnObj, color1, color2));
				cache_flash_button_timers[btnObj.id] = a;
			}
		}
	}
}

//*** BEGIN: Form double-click suppressor ***********************************************************************/

_cache_disableButtons_functions = [];

function register_disableButtons_function(f) {
	_cache_disableButtons_functions.push(f);
}

function handle_disableButtons_functions(bool) {
	for (var i = 0; i < _cache_disableButtons_functions.length; i++) {
		var f = _cache_disableButtons_functions[i];
		f(bool);
	}
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

function jsEventExplainer(e, newLine) {
	var _db = ''; 

	try {
		if (e.data) _db += "e.data is: " + e.data + newLine; 
	} catch(e) {
		_db += 'e.data is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.height) _db += "e.height is: " + e.height + newLine; 
	} catch(e) {
		_db += 'e.height is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.layerX) _db += "e.layerX is: " + e.layerX + newLine; 
	} catch(e) {
		_db += 'e.layerX is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.layerY) _db += "e.layerY is: " + e.layerY + newLine; 
	} catch(e) {
		_db += 'e.layerY is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.modifiers) _db += "e.modifiers is: " + e.modifiers + newLine; 
	} catch(e) {
		_db += 'e.modifiers is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.pageX) _db += "e.pageX is: " + e.pageX + newLine; 
	} catch(e) {
		_db += 'e.pageX is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.pageY) _db += "e.pageY is: " + e.pageY + newLine; 
	} catch(e) {
		_db += 'e.pageY is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.screenX) _db += "e.screenX is: " + e.screenX + newLine; 
	} catch(e) {
		_db += 'e.screenX is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.screenY) _db += "e.screenY is: " + e.screenY + newLine; 
	} catch(e) {
		_db += 'e.screenY is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.target) _db += "e.target is: " + e.target + newLine; 
	} catch(e) {
		_db += 'e.target is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.type) _db += "e.type is: " + e.type + newLine; 
	} catch(e) {
		_db += 'e.type is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.which) _db += "e.which is: " + e.which + newLine; 
	} catch(e) {
		_db += 'e.which is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.width) _db += "e.width is: " + e.width + newLine; 
	} catch(e) {
		_db += 'e.width is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.x) _db += "e.x is: " + e.x + newLine; 
	} catch(e) {
		_db += 'e.x is: -- UNKNOWN --' + newLine; 
	} finally {
	}

	try {
		if (e.y) _db += "e.y is: " + e.y + newLine; 
	} catch(e) {
		_db += 'e.y is: -- UNKNOWN --' + newLine; 
	} finally {
	}
	return _db;
}

var theForm;
var _cache_theForm_timerId = [];
var _cache_requestSubmitted = [];

function getStandardFormIdFor(form) {
	var _id = "null";
	if (!!form) {
		_id = form.id;
		if (_id == null) {
			_id = form.name;
		}
	}
	return _id;
}

function disableButton(btn,btn2,form,buttonType) {
	var _id = getStandardFormIdFor(form);
	if (_cache_requestSubmitted[_id] == null){
		if (!!buttonType) {
			var buttonName = buttonType;
			btn.src = buttonName.src; // image swap happens here
		} else {
			var submitMessage = "  Please Wait...  ";
			btn.value = submitMessage;
		}
		theForm = form;
		if (!!btn) {
			btn.disabled = true;
		}
		if (!!btn2) {
			btn2.disabled = true;
		}
		handle_disableButtons_functions(true);
		_cache_requestSubmitted[_id] = true;
		if (form == null) {
			return false;
		} else {
			var buts = theForm.getElementsByTagName("INPUT");
			var _db = '';
			for (var i = 0; i < buts.length; i++) {
				if (buts[i].type.ezTrim().toUpperCase() == const_button_symbol.ezTrim().toUpperCase()) {
					if (buts[i].disabled == false) {	
						buts[i].disabled = true;
					}
				}
			}

			_cache_theForm_timerId[_id] = setTimeout("submitIt()", 250);
		}
	} else {
		return false;
	}
}

function submitIt() {
	if (!!theForm) {
		theForm.submit();
	}
	var _id = getStandardFormIdFor(theForm);
	if (!!_cache_theForm_timerId[_id]) {
		clearTimeout(_cache_theForm_timerId[_id]);
		_cache_theForm_timerId[_id] = null;
	}
	return false;
}

function checkandsubmit(submitForm) {
	var _id = getStandardFormIdFor(submitForm);
	if(_cache_requestSubmitted[_id] == true) {
		return false;
	} else {
		_cache_requestSubmitted[_id] = true;
		if (!!submitForm) {
			submitForm.submit();
		}
		return false;
	}
}

//*** END! Form double-click suppressor ***********************************************************************/

//*** BEGIN: cross-browser getSelection() ***********************************************************************/

function _getSelection() {
	var txt = '';
	if (window.getSelection) {
		txt = window.getSelection();
	}
	else if (document.getSelection)	{
		txt = document.getSelection();
	}
	else if (document.selection) {
		var r = document.selection.createRange();
		txt = r.text;
	}
	else return;
}

//*** END! cross-browser getSelection() ***********************************************************************/

//**************************************************************************/

/** MathAndStringExtend.js
 *  JavaScript to extend String class
 *  - added trim methods 
 *    - uses regular expressions and pattern matching. 
 * *  eg. *    var s1 = new String("   abc   "); 
 *    var trimmedS1 = s1.trim(); 
 * *  similary for String.triml() and String.trimr(). 
 *
 //**************************************************************************/
 
function zeroPadLeading(num) {
	var s = '';
	num = ((!!num) ? num : this.length);
	var i = Math.max(this.length, num) - Math.min(this.length, num);
	for (; i > 0; i--) {
		s += '0';
	}
	return (s + this);
}

String.prototype.zeroPadLeading = zeroPadLeading;

/**************************************************************************/

function caselessIndexOfAll(s) {
	var _f = 0;
	var _fr = 0;
	var a = [];
	var sl = s.ezTrim().length;
	var st = this.ezTrim().length;
	while ((_f = this.ezTrim().toUpperCase().indexOf(s.ezTrim().toUpperCase(), _fr)) != -1) {
		a.push(_f);
		_fr += _f + sl;
		if (_fr >= st) {
			break;
		}
	}
	return a;
}

String.prototype.caselessIndexOfAll = caselessIndexOfAll;

/**************************************************************************/

function keywordSearchCaseless(kw) {
	var const_begin_tag_symbol = '<';
	var const_end_tag_symbol = '>';
	var const_begin_literal_symbol = '&';
	var const_end_literal_symbol = ';';

	var _debug_output = '';

	function gobbleUpCharsUntil(e_ch, _s) {
		var _ch = '';
		for (; i < _s.length; i++) {
			_ch = _s.substr(i, 1); // charAt(i);
			if (_ch == e_ch) {
				i++;
				_ch = _s.substr(i, 1); // charAt(i);
				break;
			}
		}
		return _ch;
	}

	var _s = this.ezTrim().ezStripHTML().ezTrim();
	var _hasHTMLtags = this.ezTrim().length != _s.length;
	var _kw = kw.ezTrim().ezStripHTML().ezTrim().toUpperCase();
	var _f = _s.toUpperCase().indexOf(_kw);
	if ( (_f != -1) && (_hasHTMLtags) ) {
		// found something - try to map it back into the HTML...
		// (1). scan thru this breaking apart words based on where the words fall relative to HTML tags.
		var _ch = '';
		var _word = '';
		var _words_array = [];
		_ch = this.substr(i, 1); // charAt(i);
		for (var i = 0; i < this.length; i++) {
			if (_ch == const_begin_tag_symbol) {
				// gobble-up chars until we reach the end tag symbol
				_ch = gobbleUpCharsUntil(const_end_tag_symbol, this);
			}
			if (_ch == const_begin_literal_symbol) {
				// gobble-up chars until we reach the end literal symbol
				_ch = gobbleUpCharsUntil(const_end_literal_symbol, this);
			}
			// now _ch should be at a char not within an HTML'ish tag or literal...
			// now collect chars until we encounter another HTML'ish symbol be it tag or literal...
			if ( (_ch != const_begin_tag_symbol) && (_ch != const_begin_literal_symbol) ) {
				_word = '';
				for (; i < this.length; i++) {
					_ch = this.substr(i, 1); // charAt(i);
					if ( (_ch == const_begin_tag_symbol) || (_ch == const_begin_literal_symbol) ) {
						break;
					}
					_word += _ch;
				}
				if (_word.ezTrim().length > 0) {
					// store the word in the array along with the index for the word...
					a = [];
					a.push(_word);
					a.push(i - _word.length);
					_words_array.push(a);
				}
			}
			_ch = this.substr(i, 1); // charAt(i);
		}
		if (_words_array.length > 0) {
			// we found some words so now we search the _words_array for the keyword...
			var a = [];
			for (i = 0; i < _words_array.length; i++) {
				a = _words_array[i];
				_s = a[0];
				var _ff = _s.toUpperCase().indexOf(_kw);
				if (_ff != -1) {
					// found the keyword...
					var o_f = _f;
					_f = a[1] + _ff;
					break;
				}
			}
		}
	} else if (_hasHTMLtags == false) {
		// there are no HTML tags to account for so just do the silly search...
		var _f = this.toUpperCase().indexOf(kw.toUpperCase());
	}
	return _f;
}

String.prototype.keywordSearchCaseless = keywordSearchCaseless;

/**************************************************************************/

function countCrs() {
	var cnt = 0;
	for (var i = 0; i < this.length; i++) {
		_ch = this.substr(i, 1);
		if (_ch == '\n') {
			cnt++;
		}
	}
	return cnt;
}

String.prototype.countCrs = countCrs;

/**************************************************************************/

function countCrLfs() {
	var cnt = 0;
	var _ch = '';
	for (var i = 0; i < this.length; i++) {
		_ch = this.substr(i, 1); // charAt(i);
		if ( (_ch == '\n') || (_ch == '\r') ) {
			cnt++;
		}
	}
	return cnt;
}

String.prototype.countCrLfs = countCrLfs;

/**************************************************************************/

function isAlpha(iLoc) {
	iLoc = ((!!iLoc) ? iLoc : 0);
	iLoc = ((iLoc < 0) ? 0 : iLoc);
	iLoc = ((iLoc > (this.length - 1)) ? this.length : iLoc);
	var _ch = this.substr(iLoc, 1);
	return ( (_ch.toLowerCase() >= 'a') && (_ch.toLowerCase() <= 'z') );
}

String.prototype.isAlpha = isAlpha;

/**************************************************************************/

function isNumeric(iLoc) {
	iLoc = ((!!iLoc) ? iLoc : 0);
	iLoc = ((iLoc < 0) ? 0 : iLoc);
	iLoc = ((iLoc > (this.length - 1)) ? this.length : iLoc);
	var _ch = this.substr(iLoc, 1);
	return ( (_ch >= '0') && (_ch <= '9') );
}

String.prototype.isNumeric = isNumeric;

/**************************************************************************/

function filterInAlpha() {
	var t = '';
	var _ch = '';
	for (var i = 0; i < this.length; i++) {
		_ch = this.substr(i, 1);
		if (_ch.isAlpha()) {
			t += _ch;
		}
	}
	return t;
}

String.prototype.filterInAlpha = filterInAlpha;

/**************************************************************************/

function filterInNumeric() {
	var _ch = '';
	var t = '';
	for (var i = 0; i < this.length; i++) {
		_ch = this.substr(i, 1);
		if (_ch.isNumeric()) {
			t += _ch;
		}
	}
	return t;
}

String.prototype.filterInNumeric = filterInNumeric;

/**************************************************************************/

function asAltIDUsing(aName, aPos, aDelim) {
	aDelim = ((!!aDelim) ? aDelim : '_');
	aPos = ((!!aPos) ? parseInt(aPos) : 0);
	var ar = this.split(aDelim);
	ar[aPos] = aName;
	return ar.join(aDelim);
}

String.prototype.asAltIDUsing = asAltIDUsing;

/**************************************************************************/

function stripTickMarks() {
	return this.replace(/\'/ig, "");
}

String.prototype.stripTickMarks = stripTickMarks;

/**************************************************************************/

function stripSpacesBy2s() {
	return this.replace(/\  /ig, "");
}

String.prototype.stripSpacesBy2s = stripSpacesBy2s;

/**************************************************************************/

function stripQuoteMarks() {
	return this.replace(/\"/ig, "");
}

String.prototype.stripQuoteMarks = stripQuoteMarks;

/**************************************************************************/

function replaceTickMarksWith(ch) {
	return this.replace(/\'/ig, ch);
}

String.prototype.replaceTickMarksWith = replaceTickMarksWith;

/**************************************************************************/

function _asHex_() {
	return ezHex(this);
}

String.prototype.asHex = _asHex_;

/**************************************************************************/

function explainChars() {
	var s = '';
	var ch = '';
	var i = -1;
	for (i = 0; i < this.length; i++) {
		ch = this.charCodeAt(i);
		var x = parseInt(ch.toString());
		s += ezHex(x) + '(' + ch.toString() + ')' + ':';
	}
	return s.substr(0, s.length - 1);
}

String.prototype.explainChars = explainChars;

/**************************************************************************/

function stripEmptyLines() {
	var i = -1;
	var s = '';
	var ar = this.split('\n');
	for (i = 0; i < ar.length; i++) {
		if (ar[i].ezTrim().length > 0) {
			s += ar[i];
		}
	}
	return s;
}

String.prototype.stripEmptyLines = stripEmptyLines;

/**************************************************************************/

function mungeIntoSymbol() {
	var _symbol = "";

	for (i = 0; i < this.length; i++) {
		ch = this.substring(i, i + 1);
		if ( (ch >= "0") && (ch <= "z") ) {
			_symbol += ch;
		} else {
			_symbol += "_";
		}
	}

	return _symbol;
}

String.prototype.mungeIntoSymbol = mungeIntoSymbol;
 
/**************************************************************************/

function sum() {
	var _sum = 0;

	for (i = 0; i < this.length; i++) {
		_sum += this[i];
	}

	return _sum;
}

Array.prototype.sum = sum;

/**************************************************************************/

function avg() {
	return (this.sum()/this.length);
}

Array.prototype.avg = avg;

/**************************************************************************/

function max() {
	var m = -1;
	if (typeof this[0] == const_number_symbol) {
		m = this[0];
	}
	for (var i = this.length; i > 0; i--) {
		if (typeof this[i] == const_number_symbol) {
			m = Math.max(m, this[i]);
		}
	}
	return m;
}

Array.prototype.max = max;

/**************************************************************************/

function min() {
	var m = -1;
	if (typeof this[0] == const_number_symbol) {
		m = this[0];
	}
	for (var i = this.length; i > 0; i--) {
		if (typeof this[i] == const_number_symbol) {
			m = Math.min(m, this[i]);
		}
	}
	return m;
}

Array.prototype.min = min;

/**************************************************************************/

function iMax() {
	var m = this.max();

	for (var i = 0; i < this.length; i++) {
		if (this[i] == m) {
			return i;
		}
	}
	return -1;
}

Array.prototype.iMax = iMax;

/**************************************************************************/

function iMin() {
	var m = this.min();

	for (var i = 0; i < this.length; i++) {
		if (this[i] == m) {
			return i;
		}
	}
	return -1;
}

Array.prototype.iMin = iMin;

/**************************************************************************/

function keyValFromKey(keyName) {
	var val = -1;
	var aa = [];

	keyName = keyName.ezTrim().toUpperCase();
	for (var i = 0; i < this.length; i++) {
		aa = this[i].toString().split(',');
		if (aa.length == 2) {
			if (aa[0].ezTrim().toUpperCase() == keyName) {
				val = aa[1];
				break;
			}
		}
	}
	return val;
}

Array.prototype.keyValFromKey = keyValFromKey;

/**************************************************************************/

function removeCurrentSelectionOptionsById(id) {
	var i = -1;
	var mObj = _$(id);
	if ( (!!mObj) && (!!mObj.options.length) ) {
		for (i = mObj.options.length - 1; i >= 0; i--) {
			if (mObj.options[i].selected) {
				mObj.options[i] = null;
			}
		}
	}
}

function removeAllSelectionOptionsByID(id) {
	var mObj = _$(id);
	if ( (!!mObj) && (!!mObj.options.length) ) {
		while (mObj.options.length > 0) {
			mObj.options[0] = null;
		}
	}
}

function currentSelectionByID(id) {
	var mObj = _$(id);
	if (!!mObj) {
		return mObj.selectedIndex;
	}
	return -1;
}

function setSelectionByID(id, sel) {
	var mObj = _$(id);
	if (!!mObj) {
		mObj.selectedIndex = sel;
	}
}

function appendSelectionOptionByID(id, t, v) {
	var mObj = _$(id);
	if ( (!!mObj) && (!!t) && (!!v) ) {
		mObj.options[mObj.options.length] = new Option( t, v);
	}
}

function adjustSelectionSizeByID(id, maxNum) {
	var mObj = _$(id);
	maxNum = ((!!maxNum) ? maxNum : 20);
	if (!!mObj) {
		mObj.size = ((mObj.options.length > maxNum) ? maxNum : mObj.options.length);
	}
}

function performDismissTable(divs) {
	var ar = unescape(divs).split('=');
	if (ar.length == 2) {
		var cObj = _$(ar[1]);
		if (!!cObj) {
			cObj.style.display = const_none_style;
		}
	}
}

function beginTable(aPrompt, vararg_params) {
	var html = '';

	function injectParmsFrom(d, aKey) {
		var _content = '';
		var _ar = d.getValueFor(aKey);
		if ( (!!_ar) && (typeof _ar == const_object_symbol) ) {
			for (var i = 0; i < _ar.length; i++) {
				if ( (!!_ar[i]) && (typeof _ar[i] == const_string_symbol) ) _content += ' ' + _ar[i].ezURLDecode();
			}
		}
		return _content;
	}
	
	aDict = ezDictObj.get$();
	aDict.bool_returnArray = true;

	if (arguments.length > 1) {
	    for (var i = 1; i < arguments.length; i++) {
			aDict.fromSpec(arguments[i]);
		}
	}
	
	var bool_includeDismissButton = false;
	var bAR = aDict.getValueFor('bool');
	if (!!bAR) {
		for (var j = 0; j < bAR.length; j++) {
			if ( (!!bAR[j]) && (typeof bAR[j] == const_string_symbol) ) {
				var bText = bAR[j].ezURLDecode();
				var pAR = bText.split('=');
				if (pAR.length == 2) if (pAR[0].toUpperCase() == 'includeDismissButton'.toUpperCase()) bool_includeDismissButton = ((pAR[1].toUpperCase() == 'true'.toUpperCase()) ? true : false);
			}
		}
	}
	var dAR = aDict.getValueFor('div');
	dAR = ((!!dAR) ? dAR : '');

	html += '<table' + injectParmsFrom(aDict, 'table') + ' cellpadding="-1" cellspacing="-1">';
	if (!!aPrompt) {
		if (aPrompt.ezTrim().length > 0) {
			html += '<tr' + injectParmsFrom(aDict, 'tr') + '>';
			html += '<td' + injectParmsFrom(aDict, 'td') + '>';
			if (bool_includeDismissButton) {
				html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
				html += '<tr>';
				html += '<td width="80%" align="center">';
			}
			html += '<span' + injectParmsFrom(aDict, 'span') + '>';
			html += aPrompt;
			html += '</span>';
			if (bool_includeDismissButton) {
				html += '</td>';
				html += '<td width="*" align="right">';
				html += '<button class="buttonMenuClass" onclick="performDismissTable(\'' + dAR + '\'); return false;">[X]</button>';
				html += '</td>';
				html += '</tr>';
				html += '</table>';
			}
			html += '</td>';
			html += '</tr>';
		}
	}
	ezDictObj.remove$(aDict.id);
	return html;
}

function endTable() {
	return '</table>';
}

function _setAbstractScopeDebugPanelContent(divName, _html) {
	var dbObj = _$(divName);
	if (!!dbObj) {
		dbObj.style.width = ((ezClientWidth() - 25) / 4) + 'px';
		dbObj.style.height = '25px';
		dbObj.innerHTML = unescape(_html);
	}
}

function setSessionScopeDebugPanelContent(_html) {
	return _setAbstractScopeDebugPanelContent('div_session_debug_panel', _html);
}

function setApplicationScopeDebugPanelContent(_html) {
	return _setAbstractScopeDebugPanelContent('div_application_debug_panel', _html);
}

function setCgiScopeDebugPanelContent(_html) {
	return _setAbstractScopeDebugPanelContent('div_cgiScope_debug_panel', _html);
}

function setRequestScopeDebugPanelContent(_html) {
	return _setAbstractScopeDebugPanelContent('div_requestScope_debug_panel', _html);
}

function setClientScopeDebugPanelContent(_html) {
	return _setAbstractScopeDebugPanelContent('div_clientScope_debug_panel', _html);
}
