// This module works by adjusting the HTML tags that are part of the menu at run-time...
sfHover = function() {
	var navObj = document.getElementById("nav");
	window.status = '';
	if (navObj != null) {
		if (_global_menu_mode == true) {
			var e_navObj = document.getElementById("navEdits");
			window.status = 'e_navObj = ' + e_navObj;
			if (e_navObj != null) {
				var a_s = const_anchor_menu_anchorStyles.split(';');
				var sfEls = e_navObj.getElementsByTagName("A");
				window.status += ' sfEls.length = ' + sfEls.length;
				for (var i = 0; i < sfEls.length; i++) {
					for (var j = 0; j < a_s.length; j++) {
						setStyle(sfEls[i].style, a_s[j] + ';');
					}
				}
			}
			var _db = '';
			var kids = navObj.getElementsByTagName("*");
			for (var i = 0; i < kids.length; i++) {
				if (kids[i].id) {
					_db += '\n' + kids[i].id; // + ', (' + kids[i].innerHTML.stripHTML().trim() + ')';
				}
			}
			// alert(_db);
		} else {
			var sfEls = navObj.getElementsByTagName("LI");
			for (var i = 0; i < sfEls.length; i++) {
				sfEls[i].onmouseover=function() {
					this.className += " sfhover";
					var _clientWidth = clientWidth();
					var _width = parseInt(getStyle(this, 'width'));
					// window.status = 'event.clientX/Y = (' + event.clientX + ', ' + event.clientY + ')' + ', _width = ' + _width + ', _clientWidth = ' + _clientWidth;
					if ((event.clientX + _width) > _clientWidth) {
						setStyle(this.style, 'float: right;');
						var kids = this.getElementsByTagName("*");
						// window.status += ' xxx' + ' kids.length = ' + kids.length;
						// modifyMenuBehavior(true);
					}
				}
				sfEls[i].onmouseout=function() {
					this.className = this.className.replace(new RegExp(" sfhover\\b"), "");
				}
			}
		}
		if (window.attachEvent) window.attachEvent("onload", sfHover);
		refreshMenuColorsFromCookies();
	}
}

function modifyMenuBehavior(bool) {
	var navObj = getGUIObjectInstanceById("nav");
	if (navObj != null) {
		var sfEls = navObj.getElementsByTagName("LI");
		for (var i = 0; i < sfEls.length; i++) {
			var _left = getStyle(sfEls[i], 'left');
//window.status = '_left[' + i + '] = ' + _left;
			if (_left) {
				if (parseInt(_left) > 0) {
//window.status = '_left = ' + _left;
					setStyle(sfEls[i].style, 'left: -' + parseInt(_left) + 'px;');
				}
			}
		}
	}
}

function modifyMenuColors(color) {
	var navObj = getGUIObjectInstanceById("nav");
	if (navObj != null) {
		var sfEls = navObj.getElementsByTagName("LI");
		for (var i = 0; i < sfEls.length; i++) {
			setStyle(sfEls[i].style, 'background: ' + color + ';');
		}
	}
}

function modifyMenuTextColors(color) {
	var navObj = getGUIObjectInstanceById("nav");
	if (navObj != null) {
		var sfEls = navObj.getElementsByTagName("A");
		for (var i = 0; i < sfEls.length; i++) {
			setStyle(sfEls[i].style, 'color: ' + color + ';');
		}
	}
}


function modifyMenuColorsFromPreviewById(id) {
	var obj = getGUIObjectInstanceById(id);
	if (obj != null) {
		modifyMenuColors(obj.bgColor);
	}
}

function modifyMenuTextColorsFromPreviewById(id) {
	var obj = getGUIObjectInstanceById(id);
	if (obj != null) {
		modifyMenuTextColors(obj.bgColor);
	}
}

function refreshMenuColorsFromCookies() {
	var bgColor = getCookie("ColorPicker");
	if (bgColor != null) {
		modifyMenuColors(bgColor);
	}
	var bgColor = getCookie("ColorPicker2");
	if (bgColor != null) {
		modifyMenuTextColors(bgColor);
	}
}
