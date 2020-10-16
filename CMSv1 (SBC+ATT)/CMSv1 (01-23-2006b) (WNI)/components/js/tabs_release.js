const_lookupSearchAction_symbol = '[Search]';

function RefreshVCRControls() {
 	var ts = TabSystem.list['TabSystem1'];

	_vcr_beginObj = getGUIObjectInstanceById('_vcrControl_Begin');
	_vcr_prevObj = getGUIObjectInstanceById('_vcrControl_Prev');
	_vcr_nextObj = getGUIObjectInstanceById('_vcrControl_Next');
	_vcr_prevPgObj = getGUIObjectInstanceById('_vcrControl_PrevPage');
	_vcr_nextPgObj = getGUIObjectInstanceById('_vcrControl_NextPage');
	_vcr_endObj = getGUIObjectInstanceById('_vcrControl_End');
	disabled_vcr_beginObj = getGUIObjectInstanceById('_vcrControl_Begin_disabled');
	disabled_vcr_prevObj = getGUIObjectInstanceById('_vcrControl_Prev_disabled');
	disabled_vcr_nextObj = getGUIObjectInstanceById('_vcrControl_Next_disabled');
	disabled_vcr_prevPgObj = getGUIObjectInstanceById('_vcrControl_PrevPage_disabled');
	disabled_vcr_nextPgObj = getGUIObjectInstanceById('_vcrControl_NextPage_disabled');
	disabled_vcr_endObj = getGUIObjectInstanceById('_vcrControl_End_disabled');
	if ( (_vcr_beginObj != null) && (_vcr_prevObj != null) && (_vcr_nextObj != null) && (_vcr_prevPgObj != null) && (_vcr_nextPgObj != null) && (_vcr_endObj != null) && (disabled_vcr_beginObj != null) && (disabled_vcr_prevObj != null) && (disabled_vcr_nextObj != null) && (disabled_vcr_prevPgObj != null) && (disabled_vcr_nextPgObj != null) && (disabled_vcr_endObj != null) ) {
		if (ts.tabs.length > _num_vis_tabs_max) {
			_vcr_beginObj.style.display = const_inline_style;
			_vcr_prevObj.style.display = const_inline_style;
			_vcr_nextObj.style.display = const_inline_style;
			_vcr_prevPgObj.style.display = const_inline_style;
			_vcr_nextPgObj.style.display = const_inline_style;
			_vcr_endObj.style.display = const_inline_style;

			disabled_vcr_beginObj.style.display = const_none_style;
			disabled_vcr_prevObj.style.display = const_none_style;
			disabled_vcr_nextObj.style.display = const_none_style;
			disabled_vcr_prevPgObj.style.display = const_none_style;
			disabled_vcr_nextPgObj.style.display = const_none_style;
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
			if ((_vis_tabs_end + _num_vis_tabs_max) > ts.tabs.length) {
				_vcr_nextPgObj.style.display = const_none_style;

				disabled_vcr_nextPgObj.style.display = const_inline_style;
			}
			if ((_vis_tabs_begin - _num_vis_tabs_max) < 1) {
				_vcr_prevPgObj.style.display = const_none_style;

				disabled_vcr_prevPgObj.style.display = const_inline_style;
			}
		} else {
			_vcr_beginObj.style.display = const_none_style;
			_vcr_prevObj.style.display = const_none_style;
			_vcr_nextObj.style.display = const_none_style;
			_vcr_prevPgObj.style.display = const_none_style;
			_vcr_nextPgObj.style.display = const_none_style;
			_vcr_endObj.style.display = const_none_style;

			disabled_vcr_beginObj.style.display = const_inline_style;
			disabled_vcr_prevObj.style.display = const_inline_style;
			disabled_vcr_nextObj.style.display = const_inline_style;
			disabled_vcr_prevPgObj.style.display = const_inline_style;
			disabled_vcr_nextPgObj.style.display = const_inline_style;
			disabled_vcr_endObj.style.display = const_inline_style;
		}
		hideShowSearchLinks(ts);
	}
}

function performCloseSBCUIDEditor(tabnum) {
	// this function is stubbed out here because this function exists in the /Security subsystem however the code that calls it is common to all subsystems.
}

function initGUIObjectCacheTrio() {
	_cache_gui_objects_trio = [];
}

function getGUIObjectTrioInstanceById(id) {
	var obj = -1;
	if (_cache_gui_objects_trio[id] == null) {
		obj = document.getElementById(id);
		_cache_gui_objects_trio[id] = obj;
	} else {
		obj = _cache_gui_objects_trio[id];
	}
	return obj;
}

function _getFirstVisibleRow(_relNum, _numRows) {
	var _k = -1;
	
	for (var _i = 1; _i <= _numRows; _i++) {
		var objE = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _i.toString() + '.1');
		if (objE != null) {
			if (objE.style.display != const_none_style) {
				_k = _i;
				break;
			}
		}
	}
	
	return _k;
}

function _getLastVisibleRow(_relNum, _numRows) {
	var _k = -1;
	
	for (var _i = _numRows; _i >= 1 ; _i--) {
		var objE = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _i.toString() + '.1');
		if (objE != null) {
			if (objE.style.display != const_none_style) {
				_k = _i;
				break;
			}
		}
	}
	
	return _k;
}

function _prevVCRControls2(_relNum, _numRows) {
	var _fvr = _getFirstVisibleRow(_relNum, _numRows);
	if (_fvr != 1) {
		var _objB = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + (_fvr - 1).toString() + '.1');
		if (_objB != null) {
			_objB.style.display = const_inline_style;
		}
		var _objB = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + (_fvr - 1).toString() + '.2');
		if (_objB != null) {
			_objB.style.display = const_inline_style;
		}
		var _objB = getGUIObjectInstanceById('tr_releaseLogReportDetail.' + _relNum.toString() + '.' + (_fvr - 1).toString());
		if (_objB != null) {
			_objB.style.display = const_inline_style;
		}

		var _lvr = _getLastVisibleRow(_relNum, _numRows);
		var _objE = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _lvr.toString() + '.1');
		if (_objE != null) {
			_objE.style.display = const_none_style;
		}
		var _objE = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _lvr.toString() + '.2');
		if (_objE != null) {
			_objE.style.display = const_none_style;
		}
		var _objE = getGUIObjectInstanceById('tr_releaseLogReportDetail.' + _relNum.toString() + '.' + _lvr.toString());
		if (_objE != null) {
			_objE.style.display = const_none_style;
		}
	}
}

function _setRowDisplayStyle(_relNum, _row, _style) {
	var _obj = getGUIObjectTrioInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _row.toString() + '.1');
	if (_obj != null) {
		_obj.style.display = _style;
	}
	var _obj = getGUIObjectTrioInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _row.toString() + '.2');
	if (_obj != null) {
		_obj.style.display = _style;
	}
	var _obj = getGUIObjectTrioInstanceById('tr_releaseLogReportDetail.' + _relNum.toString() + '.' + _row.toString());
	if (_obj != null) {
		_obj.style.display = _style;
	}
}

function _makeRowVisible(_relNum, _row) {
	return _setRowDisplayStyle(_relNum, _row, const_inline_style);
}

function _makeRowNotVisible(_relNum, _row) {
	return _setRowDisplayStyle(_relNum, _row, const_none_style);
}

function prevVCRControls2(_relNum, _numRows, _maxVisibleRows) {
	for (var _i = _maxVisibleRows; _i > 0; _i--) {
		_prevVCRControls2(_relNum, _numRows);
	}
	var _fvr = _getFirstVisibleRow(_relNum, _numRows);
	var _lvr = _getLastVisibleRow(_relNum, _numRows);
	var _av = (_lvr - _fvr) + 1;
	if (_av != _maxVisibleRows) {
		for (var _j = _maxVisibleRows - _av; _j > 0; _j--) {
			_makeRowVisible(_relNum, _lvr + _j);
		}
	}
}

function _nextVCRControls2(_relNum, _numRows) {
	var _lvr = _getLastVisibleRow(_relNum, _numRows);
	if (_lvr != 1) {
		var _objE = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + (_lvr + 1).toString() + '.1');
		if (_objE != null) {
			_objE.style.display = const_inline_style;
		}
		var _objE = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + (_lvr + 1).toString() + '.2');
		if (_objE != null) {
			_objE.style.display = const_inline_style;
		}
		var _objE = getGUIObjectInstanceById('tr_releaseLogReportDetail.' + _relNum.toString() + '.' + (_lvr + 1).toString());
		if (_objE != null) {
			_objE.style.display = const_inline_style;
		}

		var _fvr = _getFirstVisibleRow(_relNum, _numRows);
		var _objB = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _fvr.toString() + '.1');
		if (_objB != null) {
			_objB.style.display = const_none_style;
		}
		var _objB = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _fvr.toString() + '.2');
		if (_objB != null) {
			_objB.style.display = const_none_style;
		}
		var _objB = getGUIObjectInstanceById('tr_releaseLogReportDetail.' + _relNum.toString() + '.' + _fvr.toString());
		if (_objB != null) {
			_objB.style.display = const_none_style;
		}
	}
}

function nextVCRControls2(_relNum, _numRows, _maxVisibleRows) {
	for (var _i = _maxVisibleRows; _i > 0; _i--) {
		_nextVCRControls2(_relNum, _numRows);
	}
	var _fvr = _getFirstVisibleRow(_relNum, _numRows);
	var _lvr = _getLastVisibleRow(_relNum, _numRows);
	var _av = (_lvr - _fvr) + 1;
	if (_av != _maxVisibleRows) {
		for (var _j = _maxVisibleRows - _av; _j > 0; _j--) {
			_makeRowVisible(_relNum, _fvr - _j);
		}
	}
}

function ffwdVCRControls2(_relNum, _numRows, _maxVisibleRows) {
	var _k = _maxVisibleRows;
	
	for (var _i = _numRows; _i >= 1 ; _i--) {
		var _objE0 = getGUIObjectInstanceById('tr_releaseLogReportDetail.' + _relNum.toString() + '.' + _i.toString());
		var _objE1 = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _i.toString() + '.1');
		var _objE2 = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _i.toString() + '.2');
		if ( (_objE0 != null) && (_objE1 != null) && (_objE2 != null) ) {
			if ((_k - 1) >= 0) {
				_objE0.style.display = const_inline_style;
				_objE1.style.display = const_inline_style;
				_objE2.style.display = const_inline_style;
				_k--;
			} else {
				_objE0.style.display = const_none_style;
				_objE1.style.display = const_none_style;
				_objE2.style.display = const_none_style;
			}
		}
	}
}

function rewindVCRControls2(_relNum, _numRows, _maxVisibleRows) {
	var _k = _maxVisibleRows;
	
	for (var _i = 1; _i <= _numRows; _i++) {
		var _objB0 = getGUIObjectInstanceById('tr_releaseLogReportDetail.' + _relNum.toString() + '.' + _i.toString());
		var _objB1 = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _i.toString() + '.1');
		var _objB2 = getGUIObjectInstanceById('td_releaseLogReportDetail.' + _relNum.toString() + '.' + _i.toString() + '.2');
		if ( (_objB0 != null) && (_objB1 != null) && (_objB2 != null) ) {
			if ((_k - 1) >= 0) {
				_objB0.style.display = const_inline_style;
				_objB1.style.display = const_inline_style;
				_objB2.style.display = const_inline_style;
				_k--;
			} else {
				_objB0.style.display = const_none_style;
				_objB1.style.display = const_none_style;
				_objB2.style.display = const_none_style;
			}
		}
	}
}

function disableLogHeightControlMinus(bool, _relNum) {
	var btnObj = getGUIObjectInstanceById('btnMinus_releaseLogReportDetail.' + _relNum.toString() + '.1.1');
	if ( (btnObj != null) && (btnObj.disabled == false) ) {
		btnObj.disabled = ((bool == true) ? true : false);
	}
}

function disableLogHeightControlPlus(bool, _relNum) {
	var btnObj = getGUIObjectInstanceById('btnPlus_releaseLogReportDetail.' + _relNum.toString() + '.1.1');
	if ( (btnObj != null) && (btnObj.disabled == false) ) {
		btnObj.disabled = ((bool == true) ? true : false);
	}
}

function _showHideLogHeightControls( bool, row, _relNum, _numRows, delta) {
	var _objBB2 = getGUIObjectInstanceById('btnPlus_releaseLogReportDetail.' + _relNum.toString() + '.1.1');
	var _objBB3 = getGUIObjectInstanceById('btnMinus_releaseLogReportDetail.' + _relNum.toString() + '.1.1');
	if ( (_objBB2 != null) && (_objBB3 != null) ) {

		_objBB2.style.display = const_inline_style;
		_objBB3.style.display = const_inline_style;
		
		if ( (bool == true) && (delta != 0) ) {
			if ((_maxVisibleRows + delta) < 2) {
				_objBB3.disabled = true; // cannot decrease any more so disable the button
			} else {
				_objBB3.disabled = false;
			}
			if ((_maxVisibleRows + delta) >= _numRows) {
				_objBB2.disabled = true; // cannot increase any more so disable the button
			} else {
				_objBB2.disabled = false;
			}
		}
	}
}

function read_maxVisibleRows_cookie(default_mx, _relNum, _numRows) {
	_mx = getCookie('_maxVisibleRows');
	if (_mx != null) {
		_maxVisibleRows = eval(_mx);
		_refreshVisibleReleaseLogRows(_relNum, _numRows);
	} else {
		_maxVisibleRows = default_mx;
	}
}

function _refreshVisibleReleaseLogRows(_relNum, _numRows) {
	var _fvr = _getFirstVisibleRow(_relNum, _numRows);
	var _lvr = _getLastVisibleRow(_relNum, _numRows);

	if ((_lvr - _fvr + 1) != _maxVisibleRows) {
		for (var _row = _fvr; _row <= _lvr; _row++) {
			_makeRowNotVisible(_relNum, _row);
		}
		_lvr = (_fvr + _maxVisibleRows) - 1;
		if (_lvr > _numRows) {
			_fvr -= (_lvr - _numRows);
			if (_fvr < 1) {
				_fvr = 1;
			}
		}
		for (var _row = _fvr; _row <= _lvr; _row++) {
			_makeRowVisible(_relNum, _row);
		}
	}
}

function performIncreaseReleaseLogHeight(i, _relNum, _numRows) {
	if ( ((_maxVisibleRows + i) >= 2) && ((_maxVisibleRows + i) < _numRows) ) {
		_maxVisibleRows += i;
		
		_refreshVisibleReleaseLogRows(_relNum, _numRows);
		_refreshLogHeightControls(_relNum, _numRows, i);

		if (i != 0) {
			setCookie('_maxVisibleRows', _maxVisibleRows, '/');
		}
	} else {
		window.status = 'Cannot adjust the number of Release Log rows to be less than 2 nor greater than the total number of entries.';
	}
}

function _refreshLogHeightControls(_relNum, _numRows, delta) {
	var _lvr = -1;

	if (_stack_LogHeightControls.length > 0) {
		_lvr = _stack_LogHeightControls.pop();
		_showHideLogHeightControls( false, _lvr, _relNum, _numRows, delta);
	}

	_lvr = _getLastVisibleRow(_relNum, _numRows);
	_stack_LogHeightControls.push(_lvr);
	_showHideLogHeightControls( true, _lvr, _relNum, _numRows, delta);
}

function RefreshVCRControls2(_relNum, _numRows, _maxVisibleRows) {
	_vcr_beginObj = getGUIObjectInstanceById('_vcrControl_Begin2' + _relNum.toString());
	_vcr_prevObj = getGUIObjectInstanceById('_vcrControl_Prev2' + _relNum.toString());
	_vcr_nextObj = getGUIObjectInstanceById('_vcrControl_Next2' + _relNum.toString());
	_vcr_endObj = getGUIObjectInstanceById('_vcrControl_End2' + _relNum.toString());
	disabled_vcr_beginObj = getGUIObjectInstanceById('disabled_vcrControl_Begin2' + _relNum.toString());
	disabled_vcr_prevObj = getGUIObjectInstanceById('disabled_vcrControl_Prev2' + _relNum.toString());
	disabled_vcr_nextObj = getGUIObjectInstanceById('disabled_vcrControl_Next2' + _relNum.toString());
	disabled_vcr_endObj = getGUIObjectInstanceById('disabled_vcrControl_End2' + _relNum.toString());
	if ( (_vcr_beginObj != null) && (_vcr_prevObj != null) && (_vcr_nextObj != null) && (_vcr_endObj != null) && (disabled_vcr_beginObj != null) && (disabled_vcr_prevObj != null) && (disabled_vcr_nextObj != null) && (disabled_vcr_endObj != null) ) {
		if (_numRows > _maxVisibleRows) {
			_vcr_beginObj.style.display = const_inline_style;
			_vcr_prevObj.style.display = const_inline_style;
			_vcr_nextObj.style.display = const_inline_style;
			_vcr_endObj.style.display = const_inline_style;

			disabled_vcr_beginObj.style.display = const_none_style;
			disabled_vcr_prevObj.style.display = const_none_style;
			disabled_vcr_nextObj.style.display = const_none_style;
			disabled_vcr_endObj.style.display = const_none_style;
	
			var _fvr = _getFirstVisibleRow(_relNum, _numRows);
			var _lvr = _getLastVisibleRow(_relNum, _numRows);

			if (_fvr == 1) {
				_vcr_beginObj.style.display = const_none_style;
				_vcr_prevObj.style.display = const_none_style;

				disabled_vcr_beginObj.style.display = const_inline_style;
				disabled_vcr_prevObj.style.display = const_inline_style;
			} else if (_lvr == _numRows) {
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
	_refreshLogHeightControls(_relNum, _numRows, 0);
}

function FocusOnTabWithAnchorText(val) {
 	var ts = TabSystem.list['TabSystem1'];

	var len = ts.tabs.length;
	var _f = -1;
	for(var i = 0; i < len; i++) {
		var tab = ts.tabs[i];
		var _h = getGUIObjectInstanceById(tab.id).href;
		var _a = _h.split("#");
		var _aa = _a[1].split("|");
		_f = _aa[1].toUpperCase().indexOf(val.toUpperCase());
		if (_f != -1) {
			FocusOnThisTab(i);
			break;
		}
	}
	if ( (_f == -1) && (i == len) ) {
		alert('Unable to locate a ' + val + ' Release - check to make sure a ' + val + ' Release has been made or make a ' + val + ' Release from a suitable source Release.');
	}
}

function _stylesOnAllLinksLikeThis(name, style_display) {
 	var ts = TabSystem.list['TabSystem1'];

	var len = ts.tabs.length;
	for(var i = 0; i < len; i++) {
		var _obj_name = name + i.toString();
		var _obj = getGUIObjectInstanceById(_obj_name);
		if (_obj != null) {
			_obj.style.display = style_display;
		}
	}
}

function showAllLinksLikeThis(name) {
	return _stylesOnAllLinksLikeThis(name, const_inline_style);
}

function hideAllLinksLikeThis(name) {
	return _stylesOnAllLinksLikeThis(name, const_none_style);
}

function PressedReleaseLogViewLink(i) {
	var rObj = getGUIObjectInstanceById('_releaseLogSubReport' + i.toString());
	var clObj = getGUIObjectInstanceById('close_releaseLogLink' + i.toString());
	var rlObj = getGUIObjectInstanceById('_releaseLogLink' + i.toString());
	if ( (rObj != null) && (clObj != null) && (rlObj != null) ) {
		rObj.style.display = const_inline_style; 
		clObj.style.display = const_inline_style; 
		rlObj.style.display = const_none_style;
	}
	initGUIObjectCache();
}

function PressedCancelReleaseLogViewLink(i) {
	var rObj = getGUIObjectInstanceById('_releaseLogSubReport' + i.toString());
	var clObj = getGUIObjectInstanceById('close_releaseLogLink' + i.toString());
	var rlObj = getGUIObjectInstanceById('_releaseLogLink' + i.toString());
	if ( (rObj != null) && (clObj != null) && (rlObj != null) ) {
		rObj.style.display = const_none_style; 
		clObj.style.display = const_none_style; 
		rlObj.style.display = const_inline_style;
	}
	initGUIObjectCache();
}

function activeTabNum() {
	var ts = TabSystem.list['TabSystem1']; 
	var tab_num = activeTabNumFrom(ts); 
	return tab_num;
}

function processClearSearchKeyword() {
	SearchObj.getObjectInstanceById = getGUIObjectInstanceById;
	if (SearchObj.instances.length > 0) {
		var so = SearchObj.instances[SearchObj.position];
		if (so._f != -1) {
			so.cleanUp(_const_releaseLogSubReport, handleReleaseLogSearchCleanUp);
		}
	}
	SearchObj.keyword = '';
	SearchObj.position = 0;
	SearchObj.instances = [];
	
	initGUIObjectCacheTrio();
	
	clearOnTabChangedRegistrations(true);

	var btnObj = getGUIObjectInstanceById('_submit_keyword_search_button');
	var cBtnObj = getGUIObjectInstanceById('cancel_keyword_search_button');
	if ( (btnObj != null) && (cBtnObj != null) ) {
		btnObj.value = const_lookupSearchAction_symbol;
		btnObj.disabled = false;
		btnObj.style.color = 'black';
		cBtnObj.disabled = false;
		_cache_requestSubmitted = []; // this is crude but it replaced: requestSubmitted = false;
	}
}

function processClickSearchKeywordLink(_reset) {
	// _reset is true when the prior search is being reset and we're not doing another search otherwise we're doing another search...
	var dfObj = getGUIObjectInstanceById('div_findKeywordRelease');
	var fkObj = getGUIObjectInstanceById('_findKeywordRelease');
	var trObj = getGUIObjectInstanceById('tr_extraRowInHeader');
	var tdObj = getGUIObjectInstanceById('td_extraRowInHeader');
	var _obj = getGUIObjectInstanceById('_keyword');
	var nbObj = getGUIObjectInstanceById('next_findKeywordRelease');
	var pbObj = getGUIObjectInstanceById('prev_findKeywordRelease');
	var sdObj = getGUIObjectInstanceById('status_findKeywordRelease');
	if ( (dfObj != null) && (fkObj != null) && (trObj != null) && (tdObj != null) && (_obj != null) && (nbObj != null) && (pbObj != null) && (sdObj != null) ) {
		dfObj.style.display = ((_reset) ? const_none_style : const_inline_style);
		if (_reset == false) {
			fkObj.style.display = const_none_style;
			trObj.style.display = const_none_style;
			tdObj.style.display = const_none_style;
		} else {
			fkObj.style.display = const_inline_style;
			trObj.style.display = const_inline_style;
			tdObj.style.display = const_inline_style;
		}
		nbObj.style.display = const_none_style;
		pbObj.style.display = const_none_style;
		sdObj.style.display = const_none_style;
//		_obj.value = ''; 
		if (_reset == false) {
			setFocusSafely(_obj);
		}
		processClearSearchKeyword();
	}
}

function _findClosestTRtagEx(_s) {
	var _a2 = _s.split('.');

	if (_a2.length >= 3) {
		var _tabNum = eval(_a2[1]);
		var _rowNum = eval(_a2[2]) + 1;
		if (_rowNum < _maxVisibleRows) {
			_rowNum = _maxVisibleRows;
		}

		if ( (_tabNum > 0) && (_tabNum < _array_numRows.length) ) {
			var _numRows = _array_numRows[_tabNum];

			for (var _j = 1; _j <= _numRows; _j++) {
				_makeRowNotVisible(_tabNum, _j);
			}
			for (_j = _maxVisibleRows; _j > 0; _j--) {
				_makeRowVisible(_tabNum, _rowNum - _j);
			}
			RefreshVCRControls2(_tabNum, _numRows, _maxVisibleRows);
		} else {
			alert('tabs_release.js :: _findClosestTRtagEx() :: Missing or invalid value in _tabNum.');
		}
	}
}

function _findClosestTRtag(_innerHTML, _fLoc) {
	var _f = 0;
	var _ff = 0;
	
	while ( (_f < _fLoc) && (_f != -1) ) {
		_f = _innerHTML.toUpperCase().indexOf(_const_tr_tag_begin.toUpperCase(), _f);
		if ( (_f < _fLoc) && (_f != -1) ) {
			_ff = _f;
			_f += _const_tr_tag_begin.length;
		}
	}

	if ( (_ff < _fLoc) && (_ff != -1) ) {
		var _ftok = _innerHTML.substring(_ff, _fLoc - 1);
		var _fid = _ftok.toUpperCase().indexOf(_const_id_param_begin.toUpperCase(), _const_tr_tag_begin.length);
		var _fstyle = _ftok.toUpperCase().indexOf(_const_style_param_begin.toUpperCase(), _const_tr_tag_begin.length);

		if ( (_fid != -1) && (_fstyle != -1) ) {
			var _fsubtok = _ftok.substring(Math.min(_fid, _fstyle), Math.max(_fid, _fstyle) - 1);
			var _a = _fsubtok.split('=');

			if (_a.length == 2) {
				_findClosestTRtagEx(_a[1]);
			}
		}
	}

	return _f;
}

function handleReleaseLogSearchResults(so, cObj) {
	PressedReleaseLogViewLink(so.tabNum);
	cObj.innerHTML = _dropSearchHiLite(so.innerHTML, so._f, SearchObj.keyword.length);
	var divObj = getGUIObjectInstanceById(so.div);
	if (divObj != null) {
		_findClosestTRtagEx(divObj.id);
	} else {
		_findClosestTRtag(so.innerHTML, so._f);
	}
}

function handleReleaseLogSearchCleanUp(so) {
	return PressedCancelReleaseLogViewLink(so.tabNum);
}

function stepKeywordSearch(step) {
	var nbObj = getGUIObjectInstanceById('next_findKeywordRelease');
	var pbObj = getGUIObjectInstanceById('prev_findKeywordRelease');
	var sdObj = getGUIObjectInstanceById('status_findKeywordRelease');
	if ( (SearchObj.instances.length > 0) && (nbObj != null) && (pbObj != null) && (sdObj != null) ) {
		var so = SearchObj.instances[SearchObj.position];
		if (so._f != -1) {
			so.cleanUp(_const_releaseLogSubReport, handleReleaseLogSearchCleanUp);
	
			SearchObj.position += step;
			if (SearchObj.position < SearchObj.instances.length) {
				so = SearchObj.instances[SearchObj.position];
				if (so._f != -1) {
					so.hilite(_const_releaseLogSubReport, handleReleaseLogSearchResults);
					pbObj.style.display = (SearchObj.position > 0) ? const_inline_style : const_none_style;
					nbObj.style.display = (SearchObj.position < (SearchObj.instances.length - 1)) ? const_inline_style : const_none_style;
					sdObj.style.display = const_inline_style;
					sdObj.innerHTML = SearchObj.statusHTML();
				}
			}
		}
	}
}

function prevKeywordSearch() {
	return stepKeywordSearch(-1);
}

function nextKeywordSearch() {
	return stepKeywordSearch(1);
}

function noticeFocusForComments(obj) {
	if ( (SearchObj.instances.length > 0) && (obj != null) ) {
		var so = SearchObj.instances[SearchObj.position];
		if (so._f != -1) {
			var cObj = SearchObj.getObjectInstanceById(so.area + so.tabNum);
			if ( (cObj != null) && (cObj.id == obj.id) ) {
				var cnt = obj.value.substr(0, so._f).countCrs();
				setSelectionRange(SearchObj.keyword, obj, so._f - cnt, so._f + SearchObj.keyword.length - cnt);
			}
		}
	}
}

function _noticeFocusForComments(id, _num) {
	var obj = getGUIObjectInstanceById(id); 
	if (obj != null) { 
		_clearOnTabChangedRegistrationsForTab(false, _num);
		return noticeFocusForComments(obj);
	}
	return -1;
}

var const_depth_last = 'depth-last';
var const_depth_first = 'depth-first';
var const_tab_titles = 'tab-titles';

// sample - actuallyPerformKeywordSearch('Staging', TabSystem.list['TabSystem1'], 'tab-titles');
function actuallyPerformKeywordSearch(_keyword, ts, _strategy) {
	function notFoundMessage(_keyword, _strategy_expanded) {
		var s = "Unable to locate a Release that contains the keyword '" + _keyword + "'" + _strategy_expanded + ".";
		return s;
	}

	if (_previousKeywordSearch_area.length > 0) {	// here we restore the state of the last search
		var cObj = getGUIObjectInstanceById(_previousKeywordSearch_area + _previousKeywordSearch_tabNum.toString());
		if ( (cObj != null) && (isTextarea(cObj) == false) ) {
			if (_previousKeywordSearch_innerHTML.trim().length > 0) {
				cObj.innerHTML = _previousKeywordSearch_innerHTML;
			}
		}
	}
	_previousKeywordSearch_tabNum = -1;		// initialize
	_previousKeywordSearch_area = '';		// initialize
	_previousKeywordSearch_innerHTML = '';	// initialize

	var _strategy_hint = '';
	var _strategy_expanded = '';
	if (_strategy.trim().length > 0) {
		_strategy_expanded = ' using keyword search strategy of ' + _strategy;
		if (_strategy.toUpperCase() == const_depth_first.toUpperCase()) {
			_strategy_hint = ' - Searching each tab from top to bottom then left to right.';
		} else if (_strategy.toUpperCase() == const_depth_last.toUpperCase()) {
			_strategy_hint = ' - Searching each tab from left to right then top to bottom.';
		} else if (_strategy.toUpperCase() == const_tab_titles.toUpperCase()) {
			_strategy_hint = ' - Searching each tab from left to right (limited to tab titles only).';
		}
		window.status = 'Keyword search strategy is ' + _strategy + _strategy_hint;
	}

	var len = ts.tabs.length;
	var _f = -1;
	var _isAnySearchedComments = 0;
	if ( (_strategy.trim().length == 0) || (_strategy.toUpperCase() == const_depth_first.toUpperCase()) ) {
		for(var i = 0; i < len; i++) {
			var tab = ts.tabs[i];
			var cObj = getGUIObjectInstanceById(_const__tab + (i + 1).toString());
			if (cObj != null) {
				_f = cObj.innerHTML.keywordSearchCaseless(_keyword);
				if (_f != -1) {
					_previousKeywordSearch_tabNum = (i + 1);
					_previousKeywordSearch_area = _const__tab;
					_previousKeywordSearch_innerHTML = cObj.innerHTML;
					SearchObj.getInstance(_previousKeywordSearch_tabNum, _previousKeywordSearch_area, _previousKeywordSearch_innerHTML, _f);
				}
			}
			if (_f == -1) {
				var cObj = getGUIObjectInstanceById(_const_content + (i + 1).toString());
				if (cObj != null) {
					_f = cObj.innerHTML.keywordSearchCaseless(_keyword);
					if (_f != -1) {
						_previousKeywordSearch_tabNum = (i + 1);
						_previousKeywordSearch_area = _const_content;
						_previousKeywordSearch_innerHTML = cObj.innerHTML;
						SearchObj.getInstance(_previousKeywordSearch_tabNum, _previousKeywordSearch_area, _previousKeywordSearch_innerHTML, _f);
					}
				}
			}
			if (_f == -1) {
				var cObj = getGUIObjectInstanceById(_const_comments_symbol + (i + 1).toString());
				if (cObj != null) {
					_f = cObj.value.keywordSearchCaseless(_keyword);
					if (_f != -1) {
						_isAnySearchedComments++;
						_previousKeywordSearch_tabNum = (i + 1);
						_previousKeywordSearch_area = _const_comments_symbol;
						_previousKeywordSearch_innerHTML = ''; // there is no need to refresh the contents of a textarea to clear the previous search...
						SearchObj.getInstance(_previousKeywordSearch_tabNum, _previousKeywordSearch_area, _previousKeywordSearch_innerHTML, _f);
					}
				}
			}
			if (_f == -1) {
				for (var td_i = 1; td_i <= _array_numRows[(i + 1)]; td_i++) {
					var cObj = getGUIObjectInstanceById(_const_releaseLogSubReportRow + (i + 1).toString() + '.' +  + td_i.toString() + '.2');
					if (cObj != null) {
						_f = cObj.innerHTML.keywordSearchCaseless(_keyword);
						if (_f != -1) {
							_previousKeywordSearch_tabNum = (i + 1);
							_previousKeywordSearch_area = _const_releaseLogSubReport;
							_previousKeywordSearch_innerHTML = cObj.innerHTML;
							SearchObj.getInstanceEx(_previousKeywordSearch_tabNum, _previousKeywordSearch_area, cObj.id, _previousKeywordSearch_innerHTML, _f);
						}
					}
				}
			}
		}
	} else if ( (_strategy.toUpperCase() == const_depth_last.toUpperCase()) || (_strategy.toUpperCase() == const_tab_titles.toUpperCase()) ) {
		for(var i = 0; (i < len); i++) {
			var cObj = getGUIObjectInstanceById(_const__tab + (i + 1).toString());
			if (cObj != null) {
				_f = cObj.innerHTML.keywordSearchCaseless(_keyword);
				if (_f != -1) {
					_previousKeywordSearch_tabNum = (i + 1);
					_previousKeywordSearch_area = _const__tab;
					_previousKeywordSearch_innerHTML = cObj.innerHTML;
					SearchObj.getInstance(_previousKeywordSearch_tabNum, _previousKeywordSearch_area, _previousKeywordSearch_innerHTML, _f);
				}
			}
		}

		if (_strategy.toUpperCase() != const_tab_titles.toUpperCase()) {
			if (_f == -1) {
				for(var i = 0; (i < len); i++) {
					for (var td_i = 1; td_i <= _array_numRows[(i + 1)]; td_i++) {
						var cObj = getGUIObjectInstanceById(_const_releaseLogSubReportRow + (i + 1).toString() + '.' +  + td_i.toString() + '.2');
						if (cObj != null) {
							_f = cObj.innerHTML.keywordSearchCaseless(_keyword);
							if (_f != -1) {
								_previousKeywordSearch_tabNum = (i + 1);
								_previousKeywordSearch_area = _const_releaseLogSubReport;
								_previousKeywordSearch_innerHTML = cObj.innerHTML;
								SearchObj.getInstanceEx(_previousKeywordSearch_tabNum, _previousKeywordSearch_area, cObj.id, _previousKeywordSearch_innerHTML, _f);
							}
						}
					}
				}
			}

			if (_f == -1) {
				for(var i = 0; (i < len); i++) {
					var cObj = getGUIObjectInstanceById(_const_comments_symbol + (i + 1).toString());
					if (cObj != null) {
						_f = cObj.value.keywordSearchCaseless(_keyword);
						if (_f != -1) {
							_isAnySearchedComments++;
							_previousKeywordSearch_tabNum = (i + 1);
							_previousKeywordSearch_area = _const_comments_symbol;
							_previousKeywordSearch_innerHTML = ''; // there is no need to refresh the contents of a textarea to clear the previous search...
							SearchObj.getInstance(_previousKeywordSearch_tabNum, _previousKeywordSearch_area, _previousKeywordSearch_innerHTML, _f);
						}
					}
				}
			}

			if (_f == -1) {
				for(var i = 0; (i < len); i++) {
					var cObj = getGUIObjectInstanceById(_const_content + (i + 1).toString());
					if (cObj != null) {
						_f = cObj.innerHTML.keywordSearchCaseless(_keyword);
						if (_f != -1) {
							_previousKeywordSearch_tabNum = (i + 1);
							_previousKeywordSearch_area = _const_content;
							_previousKeywordSearch_innerHTML = cObj.innerHTML;
							SearchObj.getInstance(_previousKeywordSearch_tabNum, _previousKeywordSearch_area, _previousKeywordSearch_innerHTML, _f);
						}
					}
				}
			}
		}
	}

	if (SearchObj.instances.length == 0) {
		alert(notFoundMessage(_keyword, _strategy_expanded));
	} else {
		var nbObj = getGUIObjectInstanceById('next_findKeywordRelease');
		var sdObj = getGUIObjectInstanceById('status_findKeywordRelease');
		if ( (nbObj != null) && (sdObj != null) ) {
			var so = SearchObj.instances[SearchObj.position];
			if (so._f != -1) {
				SearchObj.keyword = _keyword;
				so.hilite(_const_releaseLogSubReport, handleReleaseLogSearchResults);
				nbObj.style.display = (SearchObj.instances.length > 1) ? const_inline_style : const_none_style;
				sdObj.style.display = const_inline_style;
				sdObj.innerHTML = SearchObj.statusHTML();
			}
		}
	}
}

global_PerformKeywordSearch_arg = '';

function deferred_PerformKeywordSearch() {
	// global_PerformKeywordSearch_arg holds the keyword to be searched...
	var kw = global_PerformKeywordSearch_arg;
	global_PerformKeywordSearch_arg = '';
	if (kw.trim().length > 0) {
		// this is a single-shot function however the hook will remain until the page is refreshed.
		return PerformKeywordSearch(kw);
	}
}

function PerformKeywordSearch(_keyword) {
 	var ts = TabSystem.list['TabSystem1'];

	var _strategy = '';
	var ssObj = getGUIObjectInstanceById('strategy_shallow_findKeywordRelease');
	var sdObj = getGUIObjectInstanceById('strategy_deep_findKeywordRelease');
	var stObj = getGUIObjectInstanceById('strategy_tabsTitles_findKeywordRelease');
	if ( (ssObj != null) && (sdObj != null) && (stObj != null) ) {
		_strategy = ((ssObj.checked) ? ssObj.value : ( (sdObj.checked) ? sdObj.value : ( (stObj.checked) ? stObj.value : '')));
	}

	return actuallyPerformKeywordSearch(_keyword, ts, _strategy);
}

function IsActiveTabThis(ts, _keyword, e_id) {
	var cObj = getGUIObjectInstanceById("cell_" + ts.activeTab.id);
	if (cObj != null) {
		_f = cObj.innerHTML.toUpperCase().indexOf(_keyword.toUpperCase());
		if (_f != -1) {
			getGUIObjectInstanceById(e_id).style.display = const_none_style;
		} else {
			getGUIObjectInstanceById(e_id).style.display = const_inline_style;
		}
	}
}

function hideShowSearchLinks(ts) {
	IsActiveTabThis(ts, 'Production', '_findProductionRelease');
	IsActiveTabThis(ts, 'Draft', '_findDraftRelease');
	IsActiveTabThis(ts, 'Staging', '_findStagingRelease');
}

function coordinatReleaseFunctionsFor(di, bool) {
	var diObj = getGUIObjectInstanceById(di);
	if (diObj != null) {
		diObj.style.display = ( (bool == true) ? const_inline_style : const_none_style);
	}
}

function suppress_button_double_click2(btnObj, btnObj2, formObj) {
	return disableButton(btnObj,btnObj2,formObj,null);
}
