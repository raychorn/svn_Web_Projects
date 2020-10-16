// alert('utility.js loaded');

function _getElementById(id) {
	var obj = null;
	try {
		obj = document.getElementById(id);
	} catch(e) {
	} finally {
	}
	return obj;
}

/**************************************************************************/

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
	if (el != null) {
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
	targetIndex = locateArrayItems(a, beforeWhat);
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
	var s = a.sum();
	return s/a.length;
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
		if (a[f] != null) {
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

/**************************************************************************/
