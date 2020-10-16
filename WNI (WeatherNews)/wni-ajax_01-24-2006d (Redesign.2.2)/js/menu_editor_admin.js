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

