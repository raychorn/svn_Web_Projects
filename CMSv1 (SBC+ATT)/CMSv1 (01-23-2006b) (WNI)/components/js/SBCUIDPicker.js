/* 
DESCRIPTION: This widget is used to select an SBCUID from the web phone application via an IFRAME.

COMPATABILITY: See notes in AnchorPosition.js and PopupWindow.js.

USAGE:
// Create a new SBCUIDPicker object using DHTML popup
var cp = new SBCUIDPicker();

// Create a new SBCUIDPicker object using Window Popup
var cp = new SBCUIDPicker('window');

// Add a link in your page to trigger the popup. For example:
<A HREF="#" onClick="cp.show('pick');return false;" NAME="pick" ID="pick">Pick</A>

// Or use the built-in "select" function to do the dirty work for you:
<A HREF="#" onClick="cp.select(document.forms[0].color,'pick');return false;" NAME="pick" ID="pick">Pick</A>

// If using DHTML popup, write out the required DIV tag near the bottom
// of your page.
<SCRIPT LANGUAGE="JavaScript">cp.writeDiv()</SCRIPT>

// Write the 'pickSBCUID' function that will be called when the user clicks
// the button to use the current SBCUID. This is only required if you
// want to do something other than simply populate a form field, which is 
// what the 'select' function will give you.
function pickSBCUID(sbcuid) {
	field.value = sbcuid;
	}

NOTES:
1) Requires the functions in AnchorPosition.js and PopupWindow.js

2) Your anchor tag MUST contain both NAME and ID attributes which are the 
   same. For example:
   <A NAME="test" ID="test"> </A>

3) There must be at least a space between <A> </A> for IE5.5 to see the 
   anchor tag correctly. Do not do <A></A> with no space.

4) When a SBCUIDPicker object is created, a handler for 'onmouseup' is
   attached to any event handler you may have already defined. Do NOT define
   an event handler for 'onmouseup' after you define a SBCUIDPicker object or
   the sbcuid picker will not hide itself correctly.
*/ 
SBCUIDPicker_targetInput = null;
SBCUIDPicker_remainSilent = true;
SBCUIDPicker_previewInput = null;

function SBCUIDPicker_writeDiv(s) {
	var style;
	if ( (style == null) || (style.length == 0) ) {
		style = "position:absolute;visibility:hidden;";
	} else {
		style = s;
	}
	document.writeln("<DIV ID=\"SBCUIDPickerDiv\" STYLE=\"" + style + "\"> </DIV>");
	}

function SBCUIDPicker_show(anchorname, offsetX, offsetY) {
	this.offsetX = offsetX;
	this.offsetY = offsetY;
	this.showPopup(anchorname);
}

function searchtablesForString(t, s) {
	var _i = -1;
	var _a = [];
	var a = [];
	a.push(_i);
	_a.push(a);
	for (var i = 0; i < t.length; i++) {
		var tbl = t[i];
		var rows = tbl.rows;
		for (var ri = 0; ri < rows.length; ri++) {
			var cols = rows[ri].cells;
			for (var ci = 0; ci < cols.length; ci++) {
				_i = cols[ci].innerHTML.stripHTML().toUpperCase().indexOf(s.trim().toUpperCase());
				if (_i != -1) {
					_a.pop(); // throw away the initial values because they're no longer valid...
					a = [];
					a.push(tbl);
					a.push(ri);
					a.push(ci);
					a.push(_i);
					_a.push(a);
				}
			}
		}
	}
	return _a;
}

function _SBCUIDPicker_dismissPopup(i) {
	var obj = popupWindowObjects[i];
	var iObj = document.getElementById('ifrm');
	if ( (obj != null) && (iObj != null) ) {
		var _tables = iObj.getElementsByTagName("table");
		if ( (_tables != null) && (typeof _tables == 'object') ) {
			var _a = searchtablesForString(_tables, 'SBCUID:');
alert('_a.length = ' + _a.length);
			for (var i = 0; i < _a.length; i++) {
				var a = _a[i];
alert('a.length = ' + a.length);
				if ( (a.pop() != -1) && (a.length == 3) ) {
					var ci = a.pop();
					var ri = a.pop();
					var tbl = a.pop();
					var rows = tbl.rows;
					var cols = rows[ri].cells;
					var _html = cols[ci].innerHTML.stripHTML();
					alert('(' + i + ' of ' + _a.length + ') Found ' + ' ri = ' + ri + ', ci = ' + ci + ', _html = (' + _html + ')');
				}
			}
		}
		obj.hidePopup();
		var _obj = getGUIObjectInstanceById('div_sbcuid_picker'); 
		if (_obj != null) { 
			_obj.style.display = const_none_style; 
		}
	}
}

function SBCUIDPicker_dismissPopup(i) {
	var obj = popupWindowObjects[i];
	var iObj = document.getElementById('ifrm');
	if ( (obj != null) && (iObj != null) ) {
		obj.hidePopup();
		var _obj = getGUIObjectInstanceById('div_sbcuid_picker'); 
		if (_obj != null) { 
			_obj.style.display = const_none_style; 
		}
	}
}

// This function is the easiest way to popup the window, select a color, and
// have the value populate a form field, which is what most people want to do.
function SBCUIDPicker_select(inputobj,previewObj,linkname, offsetX, offsetY) {
	if (inputobj.type!="text" && inputobj.type!="hidden" && inputobj.type!="textarea") { 
		if (SBCUIDPicker_remainSilent != true) {
			alert("SBCUIDPicker.select: Input object passed is not a valid form input object"); 
			window.SBCUIDPicker_targetInput=null;
			return;
		}
	}
	window.SBCUIDPicker_targetInput = inputobj;
	this.show(linkname, offsetX, offsetY);
}
	
function SBCUIDPicker_autoHideFunction() {
}

function SBCUIDPicker(divname, windowMode, url) {
	// Create a new PopupWindow object
	/*
		SBCUIDPicker('divname', false)
				or
		SBCUIDPicker('', true)
	*/
	
	if (divname != "") {
		var cp = new PopupWindow(divname);
		cp.setSize(800,600);
	} else {
		var cp = new PopupWindow();
		cp.setSize(800,600);
	}
	
	if ( (url == null) || (url.trim().length == 0) ) {
		var _url = const_http_symbol + 'phone';
	} else {
		var _url = url;
	}
	
	var selectedColor_width = 'width="100%"';
	var _style_colorCode = 'display: none;';
	
	// Method Mappings
	cp.writeDiv = SBCUIDPicker_writeDiv;
	cp.show = SBCUIDPicker_show;
	cp.select = SBCUIDPicker_select;

	var cp_contents = "";
	var windowRef = ((windowMode) ? "window.opener." : "");
	if (windowMode) {
		cp_contents += '<HTML><HEAD><TITLE>Select SBCUID</TITLE></HEAD>';
		cp_contents += '<BODY MARGINWIDTH=0 MARGINHEIGHT=0 LEFTMARGIN=0 TOPMARGIN=0><CENTER>';
	}
	cp_contents += '<table width="' + (cp.width - 50) + 'px" border="1" bordercolor="#000000" bordercolorlight="#000000" bordercolordark="#000000" cellspacing="1" cellpadding="0">';
	cp_contents += '<TR><TD align="right"><input type="button" name="accept_sbcuid_button" id="accept_sbcuid_button" value="[Use This SBCUID]" style="font-size: 10px;" onclick="SBCUIDPicker_dismissPopup(' + cp.index + '); return false;"></TD></TR>';
	cp_contents += '<TR>';
	cp_contents += '<TD>';
	cp_contents += '<iframe id="ifrm" name="ifrm" src="' + _url + '" onLoad="this.outerHTML=document.frames[\'ifrm\'].document.body.innerHTML" scrolling="no" width="' + (cp.width - 50) + '" height="' + (cp.height - 20) + '" frameborder="0">';
	cp_contents += '[Your browser does not support the features provided by this site.]';
	cp_contents += '</iframe>';
	cp_contents += '</TD>';
	cp_contents += '</TR>';
	// If the browser supports dynamically changing TD cells, add the fancy stuff
	cp_contents += '</TABLE>';
	if (windowMode) {
		cp_contents += '</CENTER></BODY></HTML>';
	}
	// end populate code

	// Write the contents to the popup object
	cp.populate(cp_contents+"\n");
	// Move the table down a bit so you can see it
	cp.offsetY = 0;
	cp.autoHide(SBCUIDPicker_autoHideFunction);
	return cp;
}
