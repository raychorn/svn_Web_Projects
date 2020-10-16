function windowLoaded() {
}

_image_width_symbol = "w";
_image_height_symbol = "h";

function updateSliders(s, s2, imgObj, wh) {
	s2.setValue(s.rationalValue * (s2.maxValue - s2.minValue));
	
	if (wh.toUpperCase() == _image_width_symbol.toUpperCase()) {
		imgObj.width = s.value;
		imgObj.height = s2.value;
	} else if (wh.toUpperCase() == _image_height_symbol.toUpperCase()) {
		imgObj.height = s.value;
		imgObj.width = s2.value;
	}
}

function initSliders(imgObj, w, h, HORZ_slider_obj, VERT_slider_obj) {
	if ( (HORZ_slider_obj != null) && (VERT_slider_obj != null) && (imgObj != null) ) {
		slider = Slider.getInstance(HORZ_slider_obj, Slider.direction.HORZ);
		slider2 = Slider.getInstance(VERT_slider_obj, Slider.direction.VERT);
		
		slider.minValue = 1;
		slider.maxValue = w;
		
		slider2.minValue = 1;
		slider2.maxValue = h;
		
		slider.onslide = function () {
			updateSliders(this, slider2, imgObj, _image_width_symbol);
		};
		
		slider2.onslide = function () {
			updateSliders(this, slider, imgObj, _image_height_symbol);
		};
		
		slider.setValue(w);
		slider.onslide();
		slider2.setValue(h);
		slider.onslide();
	}
}

const_rightmenu_wrapper = "rightmenu_wrapper";
const_leftmenu_wrapper = "leftmenu_wrapper";

const_quicklinks = "quicklinks";
const_quicklinks_wrapper = "quicklinks_wrapper";

const_rightside_content = "rightside_content";

_drag_in_progress = false;

_old_style_position = null;
_old_style_left = null;
_old_style_top = null;

_new_style_position = null;
_new_style_left = null;
_new_style_top = null;

_original_source_innerHTML = null;
_original_dest_innerHTML = null;

function termianteDragDrop(obj) {
	if ( (obj != null) && (_drag_in_progress == true) ) {
		makeElementNoHilite(obj);
		colorDragTargets(obj, null);

		_drag_in_progress = false;
		
		_old_style_position = null;
		_old_style_left = null;
		_old_style_top = null;

		_new_style_position = null;
		_new_style_left = null;
		_new_style_top = null;
		
		_color_original_wrapper = null;
		_color_hilite_wrapper = null;
		
		if (_old_style_position != null) {
			obj.style.position = _old_style_position;
		}
		if (_old_style_left != null) {
			obj.style.left = _old_style_left;
		}
		if (_old_style_top != null) {
			obj.style.top = _old_style_top;
		}

		_old_style_position = null;
		_old_style_left = null;
		_old_style_top = null;

		window.location.href = const_termianteDragDrop_url;
	}
}

function makeElementDragable(dmObj, obj, sourceObj, wrapperObj, dest_wrapperObj, destObj) {
	if ( (obj != null) && (dmObj != null) && (sourceObj != null) && (wrapperObj != null) && (dest_wrapperObj != null) && (destObj != null) && (_drag_in_progress == false) ) {
		_old_style_position = getStyle(obj, "position");
		_old_style_left = getStyle(obj, "left");
		_old_style_top = getStyle(obj, "top");

		makeElementNoHilite(obj);
		_original_source_innerHTML = wrapperObj.innerHTML;
		_original_dest_innerHTML = dest_wrapperObj.innerHTML;
		makeElementHilite(obj);

		if (_new_style_position == null) {
			obj.style.position = 'absolute';
		} else {
			obj.style.position = _new_style_position;
		}
		if (_new_style_left == null) {
			obj.style.left = (event.offsetX - 0).toString() + 'px';
		} else {
			obj.style.left = _new_style_left;
		}
		if (_new_style_top == null) {
			obj.style.top = (event.offsetY + 0).toString() + 'px';
		} else {
			obj.style.top = _new_style_top;
		}

		if (destObj != null) {
		 	var dObj = DragObj.getInstance(obj);
		 	dObj.addDropTarget(destObj);
		 	dObj.keepInContainer = true;

			_drag_in_progress = true;
			colorDragTargets(obj, 'cyan');
		 	
		 	dObj.ondragdrop = function(e) {
				_drag_in_progress = false;
				colorDragTargets(obj, null);

				_new_style_position = obj.style.position;
				_new_style_left = obj.style.left;
				_new_style_top = obj.style.top;

				wrapperObj.innerHTML = _original_dest_innerHTML;
				dest_wrapperObj.innerHTML = _original_source_innerHTML;
				makeElementNoHilite(obj);

				_old_style_position = null;
				_old_style_left = null;
				_old_style_top = null;
				
				dObj.removeDropTarget(obj);

				window.location.href = const_makeElementDragable_url;
		 	};
			
		 	dObj.ondragstop = function(e) {
				wrapperObj.innerHTML = _original_source_innerHTML;
				termianteDragDrop(obj);
		 	};

		 	dObj.ondragend = function(e) {
				wrapperObj.innerHTML = _original_source_innerHTML;
				termianteDragDrop(obj);
		 	};
		}
	}
}

_color_original_wrapper = null;

_color_hilite_wrapper = null;

function colorDragTargets(obj, aColor) {
	if (obj != null) {
		if (obj.id.toUpperCase() == const_quicklinks.toUpperCase()) {
		 	var tObj = document.getElementById(const_rightmenu_wrapper);
		} else if (obj.id.toUpperCase() == const_rightside_content.toUpperCase()) {
		 	var tObj = document.getElementById(const_leftmenu_wrapper);
		}
		if (tObj != null) {
			if ( (aColor != null) && (_color_original_wrapper == null) ) {
				_color_original_wrapper = getStyle(tObj, "background");
				
				tObj.style.background = aColor;
			} else if ( (aColor == null) && (_color_original_wrapper != null) ) {
				tObj.style.background = _color_original_wrapper;
				
				_color_original_wrapper = null;
			}
		}
	}
}

function refreshColorDragTargets() {
	if (_color_rightmenu_wrapper != null) {
	 	var tObjR = document.getElementById(const_rightmenu_wrapper);
		if (tObjR != null) {
			tObjR.style.background = _color_rightmenu_wrapper;
		}
	}

	if (_color_leftmenu_wrapper != null) {
	 	var tObjL = document.getElementById(const_leftmenu_wrapper);
		if (tObjL != null) {
			tObjL.style.background = _color_leftmenu_wrapper;
		}
	}
}

function makeElementHilite(obj) {
	if (_drag_in_progress == false) {
		if (obj != null) {
			_color_hilite_wrapper = obj.style.background;
			obj.style.background = 'silver';
		}
	}
}

function makeElementNoHilite(obj) {
	if (_drag_in_progress == false) {
		if ( (obj != null) && (_color_hilite_wrapper != null) ) {
			obj.style.background = _color_hilite_wrapper;
			_color_hilite_wrapper = null;
		}
	}
}
