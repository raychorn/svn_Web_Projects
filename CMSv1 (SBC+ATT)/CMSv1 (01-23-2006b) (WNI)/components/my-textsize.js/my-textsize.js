_cache_fontSizeAdjustments_functions = [];
_cache_fontSizeAdjustments_init = [];

cache_performed_fontSizeAdjustments_forTab = [];

function init_cache_performed_fontSizeAdjustments() {
	cache_performed_fontSizeAdjustments_forTab = [];
}

function getFontSizeBaselineById(id) {
	var fs = 10; // this is the default...
	if (id.trim().length > 0) {
		if (_cache_fontSizeAdjustments_init[id] == null) {
			var obj = getGUIObjectInstanceById(id);
			if (obj != null) {
				var v = getStyle(obj, "fontSize");
				var _fs = parseInt(v);
				if (isNaN(_fs) == false) {
					fs = _fs;
					_cache_fontSizeAdjustments_init[id] = fs;
				}
			}
		} else {
			fs = _cache_fontSizeAdjustments_init[id];
		}
	}
	return fs;
}

function register_fontSizeAdjustments_function(f) {
	_cache_fontSizeAdjustments_functions.push(f);
}

function handle_fontSizeAdjustments_functions(newSize) {
	var j = 0;
	for (var i = 0; i < _cache_fontSizeAdjustments_functions.length; i++) {
		var f = _cache_fontSizeAdjustments_functions[i];
		f(newSize);
		j++;
	}
	return j;
}

function handleFontSizeAdjustmentsFor(obj, newSize) {
	if ( (obj != null) && (obj.id.trim().length > 0) && ((obj.type == "text") || (obj.type == "textarea")) ) {
		var p = parseInt(newSize) / 100;
		var b = getFontSizeBaselineById(obj.id); // cache the baseline or retrieve the baseline...
		fs = _int(b * p);
		if (p == 1) {
			fs = b;
		}
		if (isNaN(fs) == false) {
			var _fs = fs + 'px';
			obj.style.setAttribute("fontSize", _fs); // works for IE 6 ? only ?!?
		}
		var cst = getStyle(obj, "cssText");
		return true;
	}
	return false;
}

function handleFontSizeAdjustmentsById(id, newSize) {
	var obj = getGUIObjectInstanceById(id);
	return handleFontSizeAdjustmentsFor(obj, newSize);
}

function myTextSize(chgsize) {
	if (!document.documentElement || !document.body) return;
	var newSize = 100;
	var startSize = parseInt(myGetCookie("my-textsize")); // parseInt(getTextSize());
	if (!startSize || startSize < 50) startSize = 100;
	switch (chgsize) {
		case "incr":
			newSize = startSize + 5;
			break;
		case "decr":
			newSize = startSize - 5;
			break;
		case "reset":
			newSize = 100;
			break;
		default:
			newSize = parseInt(myGetCookie("my-textsize"));
			if (!newSize) newSize = startSize;
			break;
	}
	if (newSize < 50) newSize = 50;
	newSize += "%";
	handle_fontSizeAdjustments_functions(newSize);
//	document.documentElement.style.fontSize = newSize;
//	document.body.style.fontSize = newSize;
	mySetCookie("my-textsize",newSize,365);
	var obj = getGUIObjectInstanceById('myTextSize_percent');
	if (obj != null) {
		obj.innerHTML = '<small>' + newSize + '</small>';
	}
	return newSize;
}

function getTextSize() {
	if (!document.body) return 0;
	var size = 0;
	var body = document.body;
	if (body.style && body.style.fontSize) {
		size = body.style.fontSize;
	} else if (typeof(getComputedStyle) != "undefined") {
		size = getComputedStyle(body,'').getPropertyValue("font-size");
	} else if (body.currentStyle) {
		size = body.currentStyle.fontSize;
	}
	return size;
}

function mySetCookie(name,value,days) {
	var cookie = name + "=" + value + ";";
	if (days) {
		var myDate=new Date();
		myDate.setTime(myDate.getTime()+(days*24*60*60*1000));
		cookie += " expires=" + myDate.toGMTString() + ";";
	}
	cookie += " path=/";
	document.cookie = cookie;
}

function myGetCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(";");
	for(var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == " ") c = c.substring(1, c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return;
}

function init_myTextSize() {
	return myTextSize();
}

// This is the "hook" into the rest of the system...
register_onload_function('init_myTextSize();');
