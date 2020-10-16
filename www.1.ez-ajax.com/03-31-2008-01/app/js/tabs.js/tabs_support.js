_stack_disableAllButtonsInContentArea = [];
_stack_open_functions = [];
_stack_function_opened_on_tab = [];

function RefreshVCRControls() {
 	var ts = TabSystem.list['TabSystem1'];

	_vcr_beginObj = _$('_vcrControl_Begin');
	_vcr_prevObj = _$('_vcrControl_Prev');
	_vcr_nextObj = _$('_vcrControl_Next');
	_vcr_endObj = _$('_vcrControl_End');
	disabled_vcr_beginObj = _$('_vcrControl_Begin_disabled');
	disabled_vcr_prevObj = _$('_vcrControl_Prev_disabled');
	disabled_vcr_nextObj = _$('_vcrControl_Next_disabled');
	disabled_vcr_endObj = _$('_vcrControl_End_disabled');
	if ( (_vcr_beginObj != null) && (_vcr_prevObj != null) && (_vcr_nextObj != null) && (_vcr_endObj != null) && (disabled_vcr_beginObj != null) && (disabled_vcr_prevObj != null) && (disabled_vcr_nextObj != null) && (disabled_vcr_endObj != null) ) {
		if (ts.tabs.length > _num_vis_tabs_max) {
			_vcr_beginObj.style.display = const_inline_style;
			_vcr_prevObj.style.display = const_inline_style;
			_vcr_nextObj.style.display = const_inline_style;
			_vcr_endObj.style.display = const_inline_style;

			disabled_vcr_beginObj.style.display = const_none_style;
			disabled_vcr_prevObj.style.display = const_none_style;
			disabled_vcr_nextObj.style.display = const_none_style;
			disabled_vcr_endObj.style.display = const_none_style;
	
			if (_vis_tabs_begin == 1) {
				_vcr_beginObj.style.display = const_none_style;
				_vcr_prevObj.style.display = const_none_style;

				disabled_vcr_beginObj.style.display = const_inline_style;
				disabled_vcr_prevObj.style.display = const_inline_style;
			} else if (_vis_tabs_end == ts.tabs.length) {
				_vcr_nextObj.style.display = const_none_style;
				_vcr_endObj.style.display = const_none_style;

				disabled_vcr_nextObj.style.display = const_inline_style;
				disabled_vcr_endObj.style.display = const_inline_style;
			}
		} else {
			_vcr_beginObj.style.display = const_none_style;
			_vcr_prevObj.style.display = const_none_style;
			_vcr_nextObj.style.display = const_none_style;
			_vcr_endObj.style.display = const_none_style;

			disabled_vcr_beginObj.style.display = const_inline_style;
			disabled_vcr_prevObj.style.display = const_inline_style;
			disabled_vcr_nextObj.style.display = const_inline_style;
			disabled_vcr_endObj.style.display = const_inline_style;
		}
	}
}

function captureTabFunctionOpenedFor(for_handle) {
	if (_stack_function_opened_on_tab[for_handle] == null) {
		var ts = TabSystem.list["TabSystem1"];
		var _num = activeTabNumFrom(ts).toString();
		_stack_function_opened_on_tab[for_handle] = _num;
	}
}

function enableAllButtonsInContentArea(for_handle) {
	var cbObj = -1;
	if (for_handle == null) {
		for_handle = 'xxx';
	}
	if (for_handle != null) {
		// for_handle is an index into the stack - this allows for multiple stacks within a single array.
		var x = _stack_disableAllButtonsInContentArea[for_handle];
		if (x == null) {
			x = [];
			_stack_disableAllButtonsInContentArea[for_handle] = x;
		}
		while (x.length > 0) {
			cbObj = x.pop();
			cbObj.disabled = false;
		}
		_stack_disableAllButtonsInContentArea[for_handle] = null;
		for (k = 0; k < _stack_open_functions.length; k++) {
			if (_stack_open_functions[k] == for_handle) {
				_stack_open_functions[k] = null;
				_stack_function_opened_on_tab[for_handle] = null;
				break;
			}
		}
	} else {
		while (_stack_disableAllButtonsInContentArea.length > 0) {
			cbObj = _stack_disableAllButtonsInContentArea.pop();
			cbObj.disabled = false;
		}
		_stack_disableAllButtonsInContentArea = [];
	}
	giveStatusForOpenItems(_stack_open_functions);
}

function giveStatusForOpenItems(_a) {
	var _db = '';
	var _dbEx = '';

	function explainItemsInThis(a) {
		var s = '';
		var t = '';
		var _cnt = 0;
		var t_cnt = countItemsInThis(a);
		for (var k = 0; k < a.length; k++) {
			if (a[k] != null) {
				_cnt++;
				t = _stack_function_opened_on_tab[a[k]];
				s += a[k] + ((t == null) ? '' : ' on tab ' + t.toString()) + ((_cnt != t_cnt) ? ', ' : '');
			}
		}
		return s;
	}

	function countItemsInThis(a) {
		var _cnt = 0;
		for (var k = 0; k < a.length; k++) {
			if (a[k] != null) {
				_cnt++;
			}
		}
		return _cnt;
	}

	var statObj = _$('open_process_indicator');
	if (statObj != null) {
		var _cnt = countItemsInThis(_a);
		_db += '(' + _cnt + ')';
		_dbEx += 'There are ' + _cnt + ' open items needing to be closed.';

		if (_cnt > 0) {
			_db += ' (' + explainItemsInThis(_a) + ')';
			_dbEx += '\nThe open items are as follows: (' + explainItemsInThis(_a) + ').';
		} else {
			_db = _dbEx;
		}

		statObj.value = _db;
		statObj.title = _dbEx;
	}
}

function _disableAllButtonsInContentAreaForTab(_num, exceptThisButtonValue, for_handle) {
	var obj = _$(_const__content + _num);
	if (obj != null) {
		var cbObj = -1;
		var a = obj.getElementsByTagName("INPUT");
		for (var i = 0; i < a.length; i++) {
			cbObj = a[i];
			if ( (cbObj.type.trim().toUpperCase() == const_button_symbol.trim().toUpperCase()) && (cbObj.value.trim().toUpperCase().indexOf(const_cancel_symbol.trim().toUpperCase()) == -1) ) {
				var allowAction = true;
				if (exceptThisButtonValue != null) {
					if (typeof exceptThisButtonValue == const_object_symbol) {
						for (var j = 0; j < exceptThisButtonValue.length; j++) {
							if (cbObj.value.trim().toUpperCase().indexOf(exceptThisButtonValue[j].trim().toUpperCase()) != -1) {
								allowAction = false;
								break; // doesn't matter if there are any more than one instance of this, cuz one instance is all it takes from a boolean expression viewpoint...
							}
						}
					} else {
						if (cbObj.value.trim().toUpperCase().indexOf(exceptThisButtonValue.trim().toUpperCase()) != -1) {
							allowAction = false;
						}
					}
				}
				if ( (allowAction == true) && (cbObj.disabled == false) ) {
					cbObj.disabled = true;
					if (for_handle != null) {
						// for_handle is an index into the stack - this allows for multiple stacks within a single array.
						var x = _stack_disableAllButtonsInContentArea[for_handle];
						if (x == null) {
							x = [];
							_stack_disableAllButtonsInContentArea[for_handle] = x;
							_stack_open_functions.push(for_handle);
						}
						x.push(cbObj);
						captureTabFunctionOpenedFor(for_handle);
						_stack_disableAllButtonsInContentArea[for_handle] = x;
					} else {
						_stack_disableAllButtonsInContentArea.push(cbObj);
					}
				}
			}
		}
	}
	giveStatusForOpenItems(_stack_open_functions);
}

function disableAllButtonsInContentArea(_num, exceptThisButtonValue, for_handle) {
	var b_forTab = true;
	if (_num == null) {
		b_forTab = false;
		var ts = TabSystem.list["TabSystem1"];
		_num = activeTabNumFrom(ts).toString();
	}
	if (for_handle == null) {
		for_handle = 'xxx';
	}
	if (b_forTab == true) {
		_disableAllButtonsInContentAreaForTab(_num, exceptThisButtonValue, for_handle);
	} else {
		for (var ii = 1; ii <= ts.tabs.length; ii++) {
			_disableAllButtonsInContentAreaForTab(ii, exceptThisButtonValue, for_handle);
		}
	}
}

function FocusOnThisTab(i) {
 	var ts = TabSystem.list['TabSystem1'];
	var len = ts.tabs.length;

	if ((i >= 0) && (i < len)) {
		var tab = ts.tabs[i];

		for(var j = 1; j <= len; j++) {
			var _objE = _$(_const_cell_tab + j.toString());
			if (_objE != null) {
				_objE.style.display = const_none_style;
			}
		}

		var _firstTab = (_int((i + 1) / _num_vis_tabs_max) * _num_vis_tabs_max);
		if (_firstTab < _num_vis_tabs_max) {
			_firstTab = 1;
		}
		_vis_tabs_begin = _firstTab;
		_vis_tabs_end = _vis_tabs_begin + (_num_vis_tabs_max - 1);
		if (_vis_tabs_end > len) {
			_vis_tabs_end = len;
			_vis_tabs_begin = _vis_tabs_end - (_num_vis_tabs_max - 1);
		}

		for(var j = _vis_tabs_begin; j <= _vis_tabs_end; j++) {
			_objE = _$(_const_cell_tab + j.toString());
			if (_objE != null) {
				_objE.style.display = const_inline_style;
			}
		}

		var _rvc = _allow_RefreshVCRControls;
		var _ata = _allow_AutoTabsAdjustment;
		
		_allow_AutoTabsAdjustment = false;
		_allow_RefreshVCRControls = false;

		tab.depress();
		_allow_RefreshVCRControls = _rvc;
		_allow_AutoTabsAdjustment = _ata;
		
		if (_allow_RefreshVCRControls) {
			RefreshVCRControls();
		}
	}
}

function _FocusOnThisTab(i) {
	return FocusOnThisTab(i - 1);
}

function handle_fontSizeAdjustments_forTabs(newSize) {
	var ts = TabSystem.list["TabSystem1"];
	var _num = activeTabNumFrom(ts);
	var dObj = _$(_const__content + _num);
	if (dObj != null) {
		var a = dObj.all;
		for (var i = 0; i < a.length; i++) {
			handleFontSizeAdjustmentsFor(a[i], newSize);
		}
	}
}

function _tabChanged(_num) {
	if (_allow_AutoTabsAdjustment) {
		var _vis_tabs_max = _num_vis_tabs_max - 1;
		
		if (_num == _vis_tabs_end) {
			_objE = _$(_const_cell_tab + (_num + 1));
			if (_objE != null) {
				_objE.style.display = const_inline_style;
				_vis_tabs_begin++;
				_vis_tabs_end++;

				_objB_name = _const_cell_tab + (_num - _vis_tabs_max);
				_objB = _$(_objB_name);
				if (_objB != null) {
					_objB.style.display = const_none_style;
				}
			}
		}
		if (_num == _vis_tabs_begin) {
			_objB_name = _const_cell_tab + (_num - 1);
			_objB = _$(_objB_name);
			if (_objB != null) {
				_objB.style.display = const_inline_style;
				_vis_tabs_begin--;
				_vis_tabs_end--;

				_objE = _$(_const_cell_tab + (_num + _vis_tabs_max));
				if (_objE != null) {
					_objE.style.display = const_none_style;
				}
			}
		}
	}

	var _obj = _$(_const__content + _num.toString());
	if (_obj != null) {
		_obj.style.display = const_inline_style;
	}

	if (_allow_RefreshVCRControls) {
		RefreshVCRControls();
	}
}

function register_performFunctionsOnTabChanged(tab, func) {
	var a = [];
	var timerId = -1;
	a.push(tab);
	a.push(func);
	a.push(timerId);
	stack_performFunctionsOnTabChanged.push(a);
}

function _clearOnTabChangedRegistrationsForTab(bool, _num) {
	for (var i = 0; i < stack_performFunctionsOnTabChanged.length ; i++) {
		var a = stack_performFunctionsOnTabChanged[i];
		var _okay = true;
		if (_num != null) {
			_okay = (_num == a[0]) ? true : false;
		}
		if ( (_okay) && (a[2] != -1) ) {
			clearInterval(a[2]); 				// clear the function associated with the timer...
			a[2] = -1;
			stack_performFunctionsOnTabChanged[i] = a; // update the saved timerId in the array so this will happen again...
			if (bool == false) break;
		}
	}
}

function clearOnTabChangedRegistrations(bool) {
	return _clearOnTabChangedRegistrationsForTab(bool, null);
}

function registerFunctionsOnTabChanged(tab_num) {
	for (var i = 0; i < stack_performFunctionsOnTabChanged.length ; i++) {
		var a = stack_performFunctionsOnTabChanged[i];
		if ( (a[0] == tab_num) && (a[2] == -1) ) {
			a[2] = setInterval(a[1], 500); 				// give the tab time to show-up... then repeat to keep the highlighted area showing...
			stack_performFunctionsOnTabChanged[i] = a; // update the saved timerId in the array so this wont happen again...
			break;
		}
	}
}

function activeTabNumFrom(ts) {
	var ch = -1;
	if (ts != null) {
		var _activeTab = ts.activeTab;
		if (_activeTab != null) {
			var s = _activeTab.id.trim();
			for (var i = s.length - 1; i >= 0; i--) {
				ch = s.charCodeAt(i);
				if ( (ch < 48) || (ch > 57) ) {
					i++;
					break;
				}
			}
			var _num = parseInt(s.substring(i, s.length).trim());
			return (isNaN(_num) == false) ? _num : -1;
		}
	}
	return -1;
}

function setStyleForAllTabs(s, i, j) {
	for(; i <= j; i++) {
		var _obj = _$(_const_cell_tab + i.toString());
		if (_obj != null) {
			_obj.style.display = s;
		}
	}
}

function refreshTabs(ts) {
	var _id = -1;
	if ( (ts != null) && (ts.activeTab != null) ) {
		_id = ts.activeTab.id
	}
	var _obj = _$("cell_" + _id);
	var _num = activeTabNumFrom(ts);
	var d = '';
	if (_obj != null) {
		d = _obj.style.display;
	}

	if ( (_num > _vis_tabs_end) && (d.toUpperCase() == const_none_style.toUpperCase()) ) {
		_vis_tabs_end = _num;
		_vis_tabs_begin = (_vis_tabs_end - _num_vis_tabs_max) + 1;
		setStyleForAllTabs(const_none_style, 1, ts.tabs.length);
		setStyleForAllTabs(const_inline_style, _vis_tabs_begin, _vis_tabs_end);
	}
}

// +++++++ BEGIN: Search Objects ++++++++++++++++++++++++++++++++++++++++++++++++++++

_previousKeywordSearch_tabNum = -1;		// this is the tab num
_previousKeywordSearch_area = '';		// this is the area by name
_previousKeywordSearch_innerHTML = '';	// this is the actual original HTML

SearchObj = function(_tabNum, _area, _innerHTML, _f){
	this.tabNum = _tabNum;
	this.area = _area;
	this.innerHTML = _innerHTML;
	this._f = _f;
};

SearchObj.position = 0;
SearchObj.instances = [];
SearchObj.keyword = '';

SearchObj.getInstance = function(_tabNum, _area, _innerHTML, _f) {
	var el_id = _area + _tabNum;
	var instance = SearchObj.instances[el_id];
	if(instance == null) {
		instance = SearchObj.instances[el_id] = SearchObj.instances[SearchObj.instances.length] = new SearchObj(_tabNum, _area, _innerHTML, _f);
	}
	return instance;
};

SearchObj.getInstanceEx = function(_tabNum, _area, _div, _innerHTML, _f) {
	var el_id = _area + _tabNum;
	var instance = SearchObj.instances[el_id];
	if(instance == null) {
		instance = SearchObj.instances[el_id] = SearchObj.instances[SearchObj.instances.length] = new SearchObj(_tabNum, _area, _innerHTML, _f);
		instance.div = _div;
	}
	return instance;
};

SearchObj.statusHTML = function() {
	var _html = '<NOBR><font size="1"><small>' + (SearchObj.position + 1) + '<b>/</b>' + SearchObj.instances.length + '</small></font></NOBR>&nbsp;';
	return _html;
};

SearchObj.getObjectInstanceById = function(id) {
};

SearchObj.prototype = {
	tabNum : -1,
	area : '',
	div : '',
	innerHTML : '',
	_f : -1,
	toString : function() {
		var s = 'area = ' + this.area + ', tabNum = ' + this.tabNum + ', _f = ' + this._f; // + ', innerHTML = (' + this.innerHTML + ')';
		return s;
	},
	cleanUp : function(special_area_tag, special_area_func) {
		if (this._f != -1) {
			var cObj = SearchObj.getObjectInstanceById(this.area + this.tabNum.toString());
			if ( (cObj != null) && (isTextarea(cObj) == false) ) {
				var hdObj = SearchObj.getObjectInstanceById(_const_hiliteDiv_id);
				var divObj = _$(this.div);
				if ( (cObj != null) && (hdObj != null) || (divObj != null) ) {
					if (divObj != null) {
						divObj.innerHTML = this.innerHTML;
					} else {
						cObj.innerHTML = this.innerHTML;
					}
				}
				if ( (special_area_tag != null) && (special_area_func != null) && (special_area_tag.trim().length > 0) && (this.area.trim().toUpperCase() == special_area_tag.trim().toUpperCase()) ) {
					special_area_func(this);
				}
			}
			return true;
		}
		return false;
	},
	hilite : function(special_area_tag, special_area_func) {
		var cObj = SearchObj.getObjectInstanceById(this.area + this.tabNum);
		if (cObj != null) {
			if ( (special_area_tag != null) && (special_area_func != null) && (special_area_tag.trim().length > 0) && (this.area.trim().toUpperCase() == special_area_tag.trim().toUpperCase()) ) {
				var divObj = _$(this.div);
				if (divObj != null) {
					special_area_func(this, divObj);
				} else {
					special_area_func(this, cObj);
				}
			} else if ( (cObj.value) && (isTextarea(cObj)) ) {
				setSelectionRange(SearchObj.keyword, cObj, this._f, this._f + SearchObj.keyword.length);
			} else {
				cObj.innerHTML = _dropSearchHiLite(this.innerHTML, this._f, SearchObj.keyword.length);
			}
			FocusOnThisTab(this.tabNum - 1);
			return true;
		}
		return false;
	}
};

function setSelectionRange(kw, obj, selectionStart, selectionEnd) {
	if (isObjValidTextHolder(obj)) {
		var _f = obj.value.toUpperCase().indexOf(kw.toUpperCase());
		if (_f != -1) {
			selectionStart = _f;
			selectionEnd = selectionStart + kw.length;
window.status = 's = ' + selectionStart + ', e = ' + selectionEnd + ', r = ' + obj.setSelectionRange + ', c = ' + obj.createTextRange;
		}
		if (obj.setSelectionRange) {
			setFocusSafely(obj);
			obj.setSelectionRange(selectionStart, selectionEnd);
		}
		else if (obj.createTextRange) {
			var range = obj.createTextRange();
			range.collapse(true);
			range.moveEnd('character', selectionEnd);
			range.moveStart('character', selectionStart);
			range.select();
		}
	}
}

function _dropSearchHiLite(_innerHTML, _fLoc, _keyLen) {
	var _html = _innerHTML.substring(0, _fLoc);
	_html += _const_begin_hilite;
	_html += _innerHTML.substring(_fLoc, _fLoc + _keyLen);
	_html += _const_end_hilite;
	var c = _innerHTML.charCodeAt(_fLoc + _keyLen);
	if (c == 32) {
		_html += '&nbsp;'; // if there is an ' ' (space character) immediately following the div tag then the browser will automagically replace the ' ' with an '' (empty string) and this must be handled...
		_fLoc++;
	}
	_html += _innerHTML.substring(_fLoc + _keyLen, _innerHTML.length);

	return _html;
}

// +++++++ END!   Search Obejcts +++++++++++++++++++++++++++++++++++++++++++++++++++
