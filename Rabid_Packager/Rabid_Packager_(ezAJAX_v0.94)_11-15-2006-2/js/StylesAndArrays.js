function  getStylesBeginningWith(_targetSelector, func) {
	var s = [];
	var ss = document.styleSheets[document.styleSheets.length - 1];
	for(var i = 0; i < ss.rules.length; i++) {
		if (ss.rules[i].selectorText.trim().toUpperCase().indexOf(_targetSelector.trim().toUpperCase()) != -1) {
			s.push(ss.rules[i].style);
			if (func) {
				func(ss.rules[i].selectorText.trim(), s);
			}
		}
	}
	return s;
}

function totalWidthOfStyles(styles, colsOrNull) {
	var _widths = 0;
	var _cols_width = -1;
	if ((colsOrNull)) {
		if (typeof colsOrNull == const_object_symbol) {
			_cols_width = ((colsOrNull) ? colsOrNull.length : styles.length);
		} else {
			_cols_width = colsOrNull;
		}
	}
	var _maxNum = Math.min(_cols_width, styles.length);
	for (var j = 0; j < _maxNum; j++) {
		_widths += parseInt(styles[j].width) + ((colsOrNull) ? 0 : 10);
	}
	return _widths;
}

function setWidthsOfStyles(styles, a) {
	var _widths = 0;
	if (typeof a == const_object_symbol) {
		for (var j = 0; j < Math.min(styles.length, a.length); j++) {
			styles[j].width = a[j];
			_widths += parseInt(styles[j].width);
		}
	}
	return _widths;
}

function getRowHeaderWidth(obj) {
	var _w1 = -1;
	var layout = obj.getTemplate("layout");
	if (!!layout) {
		_w1 = layout.getContent("left").getStyle("width");
	}
	return parseInt(_w1);
}

function getControlsColumnNum(col_headers) {
	var controls_column_i = -1;
	for (var cols_i = 0; cols_i < col_headers.length; cols_i++) {
		if (col_headers[cols_i].trim().toUpperCase().indexOf(const_Controls_symbol.trim().toUpperCase()) != -1) {
			controls_column_i = cols_i;
			break;
		}
	}
	return controls_column_i;
}

function assignControlsToGrid(_raw_data, col_headers, controls) {
	var aRow = [];
	var controls_column_i = getControlsColumnNum(col_headers);
	if (controls_column_i != -1) {
		for (var rows_i = 0; rows_i < _raw_data.length; rows_i++) {
			aRow = _raw_data[rows_i];
			aRow[controls_column_i] = controls;
		}
	}
}

function DropStylesLike(aStyle, styles, keyword) {
	try {
		var a = styles.split(';');
		for (var i = 0; i < a.length; i++) {
			if (a[i].trim().toUpperCase().indexOf(keyword.trim().toUpperCase()) != -1) {
				DropStyle(aStyle, a[i].trim());
			}
		}
	} catch(e) {
	} finally {
	}
}

function DropStyle(aStyle, styles) {
	try {
		var a = styles.split(';');
		for (var i = 0; i < a.length; i++) {
			var b = a[i].trim().split(':');
			if (b.length == 2) {
				aStyle[b[0].trim()] = null;
			}
		}
	} catch(e) {
	} finally {
	}
}

function Style2String(aStyle) {
	var st = '';
	try {
		var i = 0;
		for (var s in aStyle) {
			if (aStyle[s].length > 0) {
				i++;
			}
		}
		var j = 0;
		for (var s in aStyle) {
			if (aStyle[s].length > 0) {
				st += s + '=' + aStyle[s] + ((j < i) ? ',' : '');
				j++;
			}
		}
	} catch(e) {
	} finally {
	}
	return st;
}

function setStyle(aStyle, styles) {
	try {
		var a = styles.split(';');
		for (var i = 0; i < a.length; i++) {
			var b = a[i].trim().split(':');
			if (b.length == 2) {
				aStyle[b[0].trim()] = b[1].trim();
			}
		}
	} catch(e) {
	} finally {
	}
}

function _getStyle(sStyle, aName) {
	try {
		var a = sStyle.split(',');
		for (var i = 0; i < a.length; i++) {
			var b = a[i].trim().split('=');
			if (b.length == 2) {
				if (b[0].toUpperCase() == aName.toUpperCase()) {
					return b[1];
				}
			}
		}
	} catch(e) {
	} finally {
	}

	return '';
}


function getAllStyleSheets() {
	if (!window.ScriptEngine && navigator.__ice_version) { return document.styleSheets; }
	if (document.getElementsByTagName) { 
		var Lt = document.getElementsByTagName('link'), St = document.getElementsByTagName('style');
	} else if( document.styleSheets && document.all ) { 
		var Lt = document.all.tags('LINK'), St = document.all.tags('STYLE');
	} else { return []; } 
	for( var x = 0, os = []; Lt[x]; x++ ) {
		var rel = Lt[x].rel ? Lt[x].rel : Lt[x].getAttribute ? Lt[x].getAttribute('rel') : '';
	  if (typeof( rel) == 'string' && rel.toLowerCase().indexOf('style') + 1) { os[os.length] = Lt[x]; }
	} 
	for( var x = 0; St[x]; x++ ) { os[os.length] = St[x]; } 
	return os;
}

function changeStyle() {
	for( var x = 0, ss = getAllSheets(); ss[x]; x++ ) {
    	if( ss[x].title ) { ss[x].disabled = true; }
    	for( var y = 0; y < arguments.length; y++ ) {
			if( ss[x].title == arguments[y] ) { ss[x].disabled = false; }
		} 
	}
}

/*** BEGIN: taken from drag.js ***********************************************************************/

function toCamelCase( sInput ) {
	var sArray = sInput.split('-');
	if(sArray.length == 1)	
		return sArray[0];
	var ret = "";
	for(var i = 0, len = sArray.length; i < len; i++){
		var s = sArray[i];
		ret += s.charAt(0).toUpperCase()+s.substring(1)
	}
	return ret;
}

function getStyle(el, style) {
    var value = '';
	if (!!el) {
		try {
		    value = el.style[toCamelCase(style)];
		} catch(e) {
		} finally {
		}
	   
	    if(!value) {
	        if(typeof document.defaultView == "object") {
	            value = document.defaultView.getComputedStyle(el, "").getPropertyValue(style);
			}
	        else if (el.currentStyle) {
	            value = el.currentStyle[toCamelCase(style)];
			}
		}
	}

	return value || "";
}

/*** END! taken from drag.js ***********************************************************************/

/**************************************************************************/

function insertArrayItem(a,newValue,position) {
	if (position && position > -1) {
		a.splice(position,0,newValue);
	}
	else {
		a.unshift(newValue);
	}
}

function insertArrayItemBefore(a,newValue,beforeWhat) {
	var targetIndex = locateArrayItems(a, beforeWhat);
	if (targetIndex == -1) {
		a.push(newValue);
	}
	else {
		a.insert(newValue,targetIndex);
	}
}

function insertArrayItemAfter(a,newValue,afterWhat) {
	targetIndex = locateArrayItems(a, afterWhat);
	if (targetIndex == -1) {
		a.push(newValue);
	}
	else {
		a.insert(newValue,targetIndex+1);
	}
}

function locateRemoveArrayItem(a,toDelete) {
	var tmp = a.splice(locateArrayItems(a, toDelete),1);
}

function removeArrayItem(a,i) {
	var j = a.length;
	for (; i < j; i++) {
		if (a[i] == null) {
			break;
		}
		a[i] = a[i + 1];
	}
	a[i] = null;
}

function sumArrayItems(a) {
	var i,mySum=0;
	for (i=a.length; i>0; i--) {
		mySum += parseInt(a[i-1],10);
	}
	return mySum;
}

function avgArrayItems(a) {
	return (sumArrayItems(a)/a.length);
}

function maxArrayItems(a) {
	var m = -1;
	if (typeof a[0] == "number") {
		m = a[0];
	}
	for (i=a.length; i>0; i--) {
		if (typeof a[i] == "number") {
			m = Math.max(m,a[i]);
		}
	}
	return m;
}

function minArrayItems(a) {
	var m = -1;
	if (typeof a[0] == "number") {
		m = a[0];
	}
	for (i=a.length; i>0; i--) {
		if (typeof a[i] == "number") {
			m = Math.min(m,a[i]);
		}
	}
	return m;
}

function searchArrayItems(a,searchFor) {
	var i=0;
	var j=0;
	var results=Array(0);
	var start = 0;
	found = -1;
	for (i=0; i<a.length; i++) {
		found = locateArrayItems(a, searchFor,start);
		if (found>-1) {
			results.push(a[found]);
			start = found+1;
		}
	}
	return results;
}

function locateArrayItems(a, what, start){
	var f = 0;
	if (start) {
		startWhere = start 
	}
	else {
		startWhere = 0;
	}
	for(f=startWhere; f<a.length; f++) {
		if(a[f].toString().substr(0,what.length) == what.toString()) {
			return f;
		}
	}
	return -1;
}

function locateArrayItemsCaseless(a, what, start){
	var f = 0;
	if (start) {
		startWhere = start 
	}
	else {
		startWhere = 0;
	}
	for(f = startWhere; f < a.length; f++) {
		if (!!a[f]) {
			if(a[f].toString().trim().toUpperCase().substr(0,what.length) == what.toString().trim().toUpperCase()) {
				return f;
			}
		}
	}
	return -1;
}

function swapArrayItems(a,index1,index2) { 
	var temp = a[index1];
	a[index1] = a[index2];
	a[index2] = temp;
	return;
}

function shuffleArrayItems(a) { 
	var l = a.length;
	for(var i=0; i<l; i++) { 
		ind1 = Math.floor(Math.random()*l);
		ind2 = Math.floor(Math.random()*l);
		swapArrayItems(a,ind1,ind2);
	}
	return;
}

/*** END! utility.js ***********************************************************************/
