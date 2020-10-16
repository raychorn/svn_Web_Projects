function hideSecuritySettingsForm() {
 	var ts = TabSystem.list['TabSystem1'];
	var _num = activeTabNumFrom(ts);

	var obj = getGUIObjectInstanceById('_securitySettings');
	if (obj != null) {
		obj.style.display = const_none_style;
	}
	var obj = getGUIObjectInstanceById('_EditView_Settings' + _num.toString());
	if (obj != null) {
		obj.style.display = const_inline_style;
	}
	var obj = getGUIObjectInstanceById('_securitySettings_help' + _num.toString());
	if (obj != null) {
		obj.style.display = const_none_style;
	}
}

function showSecuritySettingsForm() {
 	var ts = TabSystem.list['TabSystem1'];
	var _num = activeTabNumFrom(ts);

	var obj = getGUIObjectInstanceById('_securitySettings');
	if (obj != null) {
		obj.style.display = const_inline_style;
	}
	var obj = getGUIObjectInstanceById('_EditView_Settings' + _num.toString());
	if (obj != null) {
		obj.style.display = const_none_style;
	}
	var obj = getGUIObjectInstanceById('_securitySettings_help' + _num.toString());
	if (obj != null) {
		obj.style.display = const_inline_style;
	}
}

function suppress_button_double_click2(btnObj, btnObj2, formObj) {
	return disableButton(btnObj,btnObj2,formObj,null);
}

function process_disable_clickable_controls(bool) {
	var obj = getGUIObjectInstanceById('_securitySettings');
	if (obj != null) {
		var cbObj = null;
		var a = obj.getElementsByTagName("INPUT");
		for (var i = 0; i < a.length; i++) {
			cbObj = a[i];
			if (cbObj.type.trim().toUpperCase() == const_checkbox_symbol.trim().toUpperCase()) {
				// if the checkbox is for a page name then collect up the page name list and put it into _pageId
				// To-Do: Try to make it look like the checkbox is disabled when it in-fact is not disabled but inhibit the user making changes...
				var dObjE = getGUIObjectInstanceById('enabled_cb' + cbObj.id);
				if (dObjE != null) {
					dObjE.style.display = const_none_style;
				}
				var pObjE = getGUIObjectInstanceById('enabled_p' + cbObj.id);
				if (pObjE != null) {
					pObjE.style.display = const_none_style;
				}
				var dObjE = getGUIObjectInstanceById('disabled_cb' + cbObj.id);
				if (dObjE != null) {
					dObjE.style.display = const_inline_style;
				}
				var pObjE = getGUIObjectInstanceById('disabled_p' + cbObj.id);
				if (pObjE != null) {
					pObjE.style.display = const_inline_style;
				}
				var cbObjD = getGUIObjectInstanceById('disabled' + cbObj.id);
				if (cbObjD != null) {
					cbObjD.disabled = false;
					cbObjD.checked = cbObj.checked;
					cbObjD.disabled = true;
				}
			} else if (cbObj.type.trim().toUpperCase() == const_button_symbol.trim().toUpperCase()) {
				cbObj.disabled = true;
			}
		}
	}
	disableAllButtonsInContentArea(null);
	clicked_cancelAddNewUser();
	processCancelDeleteUserButton(null, null);
	disableDeleteUserButton(true, null);
	disableAddNewUserSubmitButton(true);
	disableSearchForUserButton(true);
}

function disableSearchForUserButton(bool) {
	var obj = getGUIObjectInstanceById('_searchForUser');
	if (obj != null) {
		obj.disabled = ((bool == true) ? true : false);
	}
}

function processClickDeleteUserButton(btnObj, _num) {
	disableAllButtonsInContentArea(_num);
	var obj = getGUIObjectInstanceById('dropThisUser' + _num.toString());
	if (obj != null) {
		obj.style.display = const_inline_style;
		obj = getGUIObjectInstanceById('_dropThisUser' + _num.toString());
		if (obj != null) {
			obj.style.display = const_none_style;
			obj = getGUIObjectInstanceById('form_dropThisUser' + _num.toString());
			if (obj != null) {
				setFocusSafely(obj._dropVerify); 
				disableAddNewUserSubmitButton(true);
				clicked_cancelAddNewUser();
				disableSearchForUserButton(true);
			}
		}
	}
	return false;
}

function processCancelDeleteUserButton(btnObj, _num) {
	if (_num == null) {
		var ts = TabSystem.list["TabSystem1"];
		_num = activeTabNumFrom(ts);
	}
	enableAllButtonsInContentArea();
	var obj = getGUIObjectInstanceById('dropThisUser' + _num.toString());
	if (obj != null) {
		obj.style.display = const_none_style; 
		obj = getGUIObjectInstanceById('_dropThisUser' + _num.toString());
		if (obj != null) {
			obj.style.display = const_inline_style;
			disableAddNewUserSubmitButton(false);
			disableSearchForUserButton(false);
		}
	}
	return false;
}

function disableDeleteUserButton(bool, _num) {
	if (_num == null) {
		var ts = TabSystem.list["TabSystem1"];
		_num = activeTabNumFrom(ts);
	}
	var _obj1 = getGUIObjectInstanceById('_dropThisUser' + _num.toString());
	if (_obj1 != null) {
		_obj1.disabled = ((bool == true) ? true : false);
	}
}

function disableAddNewUserSubmitButton(bool) {
	var _obj1 = getGUIObjectInstanceById('addNewUser_submitButton');
	if (_obj1 != null) {
		_obj1.disabled = ((bool == true) ? true : false);
	}
	var _obj2 = getGUIObjectInstanceById('_addNewUser');
	if (_obj2 != null) {
		_obj2.disabled = ((bool == true) ? true : false);
	}
}

function processConfirmedDeleteSBCUID(thisSel, _num) {
	if (thisSel.form._dropVerify.options[thisSel.form._dropVerify.selectedIndex].value.trim().toUpperCase() == const_no_response_symbol.trim().toUpperCase()) { 
		processCancelDeleteUserButton(null, _num);
		disableDeleteUserButton(false, _num);
		disableAddNewUserSubmitButton(false);
		disableSearchForUserButton(false);
		return false;
	} else { 
		var bObj = getGUIObjectInstanceById('cancel_dropThisUser' + _num.toString()); 
		if (bObj != null) { 
			bObj.disabled = true; 
		} 
		thisSel.disabled = true;
		disableAllButtonsInContentArea(_num);
		hideSecuritySettingsForm();
		clicked_cancelAddNewUser();
		disableSearchForUserButton(true);
		changePage(thisSel.form._dropVerify);
		return true;
	}
}

function processCheckBoxChange(cbObj, ev) {
	var obj = getGUIObjectInstanceById('submitButton_security_settings');
	if (obj != null) {
		return (obj.disabled == false); // inhibit only when submit button is disabled...
	}
	return false; // default is to inhibit
}

function _processCheckAllSubSystems(num, bool) {
	var any_clicked = 0;
	for (var i = 1; i <= num; i++) { 
		var _obj = getGUIObjectInstanceById('_subsystemId' + i.toString()); 
		if (_obj != null) { 
			if (_obj.disabled == false) { 
				_obj.checked = ((bool == true) ? true : false);
				processSubsystemId_click(i);
				any_clicked++;
			} 
		}  
	}
	if (any_clicked > 0) {
		var _obj2 = getGUIObjectInstanceById('_checkAllSubsystems');
		if (_obj2 != null) {
			_obj2.style.display = ((bool == true) ? const_none_style : const_inline_style); 
		}
		var _obj3 = getGUIObjectInstanceById('_uncheckAllSubsystems');
		if (_obj3 != null) {
			_obj3.style.display = ((bool == true) ? const_inline_style : const_none_style);
		}
	}
	
	return false;
}

function _processCheckAllPages(bool) {
	var _obj = -1; 
	var i = 1; 
	var any_clicked = 0;
	while (_obj != null) { 
		_obj = getGUIObjectInstanceById('_pageId' + i.toString()); 
		if (_obj != null) { 
			if (_obj.disabled == false) { 
				_obj.checked = ((bool == true) ? true : false);
				any_clicked++;
			} 
			i++; 
		} 
	} 
	if (any_clicked > 0) {
		var _obj2 = getGUIObjectInstanceById('_checkAllPages');
		if (_obj2 != null) {
			_obj2.style.display = ((bool == true) ? const_none_style : const_inline_style); 
		}
		var _obj3 = getGUIObjectInstanceById('_uncheckAllPages');
		if (_obj3 != null) {
			_obj3.style.display = ((bool == true) ? const_inline_style : const_none_style);
		}
	}
	return false;
}

function processCheckAllPages() {
	return _processCheckAllPages(true);
}

function processUnCheckAllPages() {
	return _processCheckAllPages(false);
}

function processCheckAllSubSystems(num) {
	return _processCheckAllSubSystems(num, true);
}

function processUnCheckAllSubSystems(num) {
	return _processCheckAllSubSystems(num, false);
}

_last_user_index_selection_i = -1;
_last_user_index_selection_bgColor = -1;

function RefreshUserIndex() {
 	var ts = TabSystem.list['TabSystem1'];

	var tab = ts.tabs[_vis_tabs_begin - 1];
	if (tab != null) {
		var _a = getGUIObjectInstanceById(tab.id).href.split("#");
	
		for (var i = 1; i <= user_index_displayableNum; i++) {
			var _anchor = getGUIObjectInstanceById('_user_index_link' + i.toString());
			var _aLink_name = _anchor.name;
			var _aLink_style = _anchor.style.display;
			if (_a[1].toUpperCase() == _aLink_name.toUpperCase()) {
				var _centerOfList = _int(_ss_maxDisplayableUserIndex / 2);
				var _i = 1;
				if (i <= _centerOfList) {
					_i = 1;
				} else {
					_i = i - _centerOfList;
				}
				if ((_i + _ss_maxDisplayableUserIndex) > user_index_displayableNum) {
					_i = (user_index_displayableNum - _ss_maxDisplayableUserIndex) + 1;
				}
	
				for (var j = 1; j <= user_index_displayableNum; j++) {
					var _objTR = getGUIObjectInstanceById('div_user_index_on' + j.toString());
					if (_objTR != null) {
						_objTR.style.display = const_none_style;
					}
					
					var _objTD = getGUIObjectInstanceById('div_user_index_off' + j.toString());
					if (_objTD != null) {
						_objTD.style.display = const_inline_style;
					}
				}
	
				for (j = _i; j <= (_ss_maxDisplayableUserIndex + (_i - 1)); j++) {
					var _objTR = getGUIObjectInstanceById('div_user_index_on' + j.toString());
					var _objTD = getGUIObjectInstanceById('div_user_index_off' + j.toString());
					if (_objTR != null) {
						_objTR.style.display = const_inline_style;
					}
					if (_objTD != null) {
						_objTD.style.display = const_none_style;
					}
				}
	
				if (_last_user_index_selection_i != -1) {
					var _objTD = getGUIObjectInstanceById('_user_index_td' + _last_user_index_selection_i.toString());
					if (_objTD != null) {
						_objTD.bgColor = _last_user_index_selection_bgColor;
					}
					_last_user_index_selection_i = -1;
				}
				
				var _objTD = getGUIObjectInstanceById('_user_index_td' + i.toString());
				if (_objTD != null) {
					_last_user_index_selection_i = i;
					_last_user_index_selection_bgColor = _objTD.bgColor;
					_objTD.bgColor = 'Aqua';
				}
				break;
			}
		}
	}
}

function RefreshVCRControls() {
 	var ts = TabSystem.list['TabSystem1'];

	hideSecuritySettingsForm();
	
	var _vcrBeginObj = getGUIObjectInstanceById('_vcrControl_Begin');
	var _vcrPrevObj = getGUIObjectInstanceById('_vcrControl_Prev');
	var _vcrNextObj = getGUIObjectInstanceById('_vcrControl_Next');
	var _vcrPrevPageObj = getGUIObjectInstanceById('_vcrControl_PrevPage');
	var _vcrNextPageObj = getGUIObjectInstanceById('_vcrControl_NextPage');
	var _vcrEndObj = getGUIObjectInstanceById('_vcrControl_End');
	var disabled_vcrBeginObj = getGUIObjectInstanceById('disabled_vcrControl_Begin');
	var disabled_vcrPrevObj = getGUIObjectInstanceById('disabled_vcrControl_Prev');
	var disabled_vcrNextObj = getGUIObjectInstanceById('disabled_vcrControl_Next');
	var disabled_vcrPrevPageObj = getGUIObjectInstanceById('disabled_vcrControl_PrevPage');
	var disabled_vcrNextPageObj = getGUIObjectInstanceById('disabled_vcrControl_NextPage');
	var disabled_vcrEndObj = getGUIObjectInstanceById('disabled_vcrControl_End');
	if ( (_vcrBeginObj != null) && (_vcrPrevObj != null) && (_vcrNextObj != null) && (_vcrPrevPageObj != null) && (_vcrNextPageObj != null) && (_vcrEndObj != null) && (disabled_vcrBeginObj != null) && (disabled_vcrPrevObj != null) && (disabled_vcrNextObj != null) && (disabled_vcrPrevPageObj != null) && (disabled_vcrNextPageObj != null) && (disabled_vcrEndObj != null) ) {
		if (ts.tabs.length > _num_vis_tabs_max) {
			_vcrBeginObj.style.display = const_inline_style;
			_vcrPrevObj.style.display = const_inline_style;
			_vcrNextObj.style.display = const_inline_style;
			_vcrPrevPageObj.style.display = const_inline_style;
			_vcrNextPageObj.style.display = const_inline_style;
			_vcrEndObj.style.display = const_inline_style;

			disabled_vcrBeginObj.style.display = const_none_style;
			disabled_vcrPrevObj.style.display = const_none_style;
			disabled_vcrNextObj.style.display = const_none_style;
			disabled_vcrPrevPageObj.style.display = const_none_style;
			disabled_vcrNextPageObj.style.display = const_none_style;
			disabled_vcrEndObj.style.display = const_none_style;
	
			if (_vis_tabs_begin == 1) {
				_vcrBeginObj.style.display = const_none_style;
				_vcrPrevObj.style.display = const_none_style;

				disabled_vcrBeginObj.style.display = const_inline_style;
				disabled_vcrPrevObj.style.display = const_inline_style;
			} else if (_vis_tabs_end == ts.tabs.length) {
				_vcrNextObj.style.display = const_none_style;
				_vcrEndObj.style.display = const_none_style;

				disabled_vcrNextObj.style.display = const_inline_style;
				disabled_vcrEndObj.style.display = const_inline_style;
			}
			if ((_vis_tabs_end + _num_vis_tabs_max) > ts.tabs.length) {
				_vcrNextPageObj.style.display = const_none_style;

				disabled_vcrNextPageObj.style.display = const_inline_style;
			}
			if ((_vis_tabs_begin - _num_vis_tabs_max) < 1) {
				_vcrPrevPageObj.style.display = const_none_style;

				disabled_vcrPrevPageObj.style.display = const_inline_style;
			}
		} else {
			_vcrBeginObj.style.display = const_none_style;
			_vcrPrevObj.style.display = const_none_style;
			_vcrNextObj.style.display = const_none_style;
			_vcrPrevPageObj.style.display = const_none_style;
			_vcrNextPageObj.style.display = const_none_style;
			_vcrEndObj.style.display = const_none_style;

			disabled_vcrBeginObj.style.display = const_inline_style;
			disabled_vcrPrevObj.style.display = const_inline_style;
			disabled_vcrNextObj.style.display = const_inline_style;
			disabled_vcrPrevPageObj.style.display = const_inline_style;
			disabled_vcrNextPageObj.style.display = const_inline_style;
			disabled_vcrEndObj.style.display = const_inline_style;
		}
	}
	RefreshUserIndex();
}

function getFirstVisibleColumnObj(_numColumns) {
	var _obj = null;
	
	for (var _i = 1; _i <= _numColumns; _i++) {
		var objE = getGUIObjectInstanceById('_securitySettingsCol' + _i.toString());
		if (objE != null) {
			if (objE.style.display != const_none_style) {
				_obj = objE;
				break;
			}
		}
	}
	
	return _obj;
}

function getFirstVisibleColumn(_numColumns) {
	var _k = -1;
	
	for (var _i = 1; _i <= _numColumns; _i++) {
		var objE = getGUIObjectInstanceById('_securitySettingsCol' + _i.toString());
		if (objE != null) {
			if (objE.style.display != const_none_style) {
				_k = _i;
				break;
			}
		}
	}
	
	return _k;
}

function getLastVisibleColumnObj(_numColumns) {
	var _obj = null;
	
	for (var _i = _numColumns; _i >= 1 ; _i--) {
		var objE = getGUIObjectInstanceById('_securitySettingsCol' + _i.toString());
		if (objE != null) {
			if (objE.style.display != const_none_style) {
				_obj = objE;
				break;
			}
		}
	}
	
	return _obj;
}

function getLastVisibleColumn(_numColumns) {
	var _k = -1;
	
	for (var _i = _numColumns; _i >= 1 ; _i--) {
		var objE = getGUIObjectInstanceById('_securitySettingsCol' + _i.toString());
		if (objE != null) {
			if (objE.style.display != const_none_style) {
				_k = _i;
				break;
			}
		}
	}
	
	return _k;
}

function RefreshVCRControls2(_numColumns, _maxVisibleCols) {
	var _vcrBeginObj = getGUIObjectInstanceById('_vcrControl_Begin2');
	var _vcrPrevObj = getGUIObjectInstanceById('_vcrControl_Prev2');
	var _vcrNextObj = getGUIObjectInstanceById('_vcrControl_Next2');
	var _vcrEndObj = getGUIObjectInstanceById('_vcrControl_End2');
	var disabled_vcrBeginObj = getGUIObjectInstanceById('disabled_vcrControl_Begin2');
	var disabled_vcrPrevObj = getGUIObjectInstanceById('disabled_vcrControl_Prev2');
	var disabled_vcrNextObj = getGUIObjectInstanceById('disabled_vcrControl_Next2');
	var disabled_vcrEndObj = getGUIObjectInstanceById('disabled_vcrControl_End2');
	if ( (_vcrBeginObj != null) && (_vcrPrevObj != null) && (_vcrNextObj != null) && (_vcrEndObj != null) && (disabled_vcrBeginObj != null) && (disabled_vcrPrevObj != null) && (disabled_vcrNextObj != null) && (disabled_vcrEndObj != null) ) {
		if (_numColumns > _maxVisibleCols) {
			_vcrBeginObj.style.display = const_inline_style;
			_vcrPrevObj.style.display = const_inline_style;
			_vcrNextObj.style.display = const_inline_style;
			_vcrEndObj.style.display = const_inline_style;

			disabled_vcrBeginObj.style.display = const_none_style;
			disabled_vcrPrevObj.style.display = const_none_style;
			disabled_vcrNextObj.style.display = const_none_style;
			disabled_vcrEndObj.style.display = const_none_style;
	
			if (getFirstVisibleColumn(_numColumns) == 1) {
				_vcrBeginObj.style.display = const_none_style;
				_vcrPrevObj.style.display = const_none_style;

				disabled_vcrBeginObj.style.display = const_inline_style;
				disabled_vcrPrevObj.style.display = const_inline_style;
			} else if (getLastVisibleColumn(_numColumns) == _numColumns) {
				_vcrNextObj.style.display = const_none_style;
				_vcrEndObj.style.display = const_none_style;

				disabled_vcrNextObj.style.display = const_inline_style;
				disabled_vcrEndObj.style.display = const_inline_style;
			}
		} else {
			_vcrBeginObj.style.display = const_none_style;
			_vcrPrevObj.style.display = const_none_style;
			_vcrNextObj.style.display = const_none_style;
			_vcrEndObj.style.display = const_none_style;

			disabled_vcrBeginObj.style.display = const_inline_style;
			disabled_vcrPrevObj.style.display = const_inline_style;
			disabled_vcrNextObj.style.display = const_inline_style;
			disabled_vcrEndObj.style.display = const_inline_style;
		}
	}
}

function prevVCRControls2(_numColumns) {
	var _fvc = getFirstVisibleColumn(_numColumns);
	if (_fvc != 1) {
		var _objB = getGUIObjectInstanceById('_securitySettingsCol' + (_fvc - 1).toString());
		if (_objB != null) {
			_objB.style.display = const_inline_style;
		}
		var _objE = getLastVisibleColumnObj(_numColumns);
		if (_objE != null) {
			_objE.style.display = const_none_style;
		}
	}
}

function nextVCRControls2(_numColumns) {
	var _lvc = getLastVisibleColumn(_numColumns);
	if (_lvc != _numColumns) {
		var _objE = getGUIObjectInstanceById('_securitySettingsCol' + (_lvc + 1).toString());
		if (_objE != null) {
			_objE.style.display = const_inline_style;
		}
		var _objB = getFirstVisibleColumnObj(_numColumns);
		if (_objB != null) {
			_objB.style.display = const_none_style;
		}
	}
}

function ffwdVCRControls2(_numColumns, _maxVisibleCols) {
	var _k = _maxVisibleCols;
	
	for (var _i = _numColumns; _i >= 1 ; _i--) {
		var objE = getGUIObjectInstanceById('_securitySettingsCol' + _i.toString());
		if (objE != null) {
			if ((_k - 1) >= 0) {
				objE.style.display = const_inline_style;
				_k--;
			} else {
				objE.style.display = const_none_style;
			}
		}
	}
}

function rewindVCRControls2(_numColumns, _maxVisibleCols) {
	var _k = _maxVisibleCols;
	
	for (var _i = 1; _i <= _numColumns; _i++) {
		var objB = getGUIObjectInstanceById('_securitySettingsCol' + _i.toString());
		if (objB != null) {
			if ((_k - 1) >= 0) {
				objB.style.display = const_inline_style;
				_k--;
			} else {
				objB.style.display = const_none_style;
			}
		}
	}
}

function quietlyPerformSearch(val) {
 	var ts = TabSystem.list['TabSystem1'];
	var _f = -1;
	
	var len = ts.tabs.length;
	for(var i = 0; i < len; i++) {
		var tab = ts.tabs[i];
		var _a = getGUIObjectInstanceById(tab.id).href.split("#");
		_f = _a[1].toUpperCase().indexOf(val.toUpperCase());
		if (_f != -1) {
			_f = i; // returns the tab num instead of the locale of the searched val.
			break;
		}
	}
	if (_f == -1) {
		for(var i = 1; i <= len; i++) {
			var obj = getGUIObjectInstanceById(_const_cell_tab + i.toString());
			if (obj != null) {
				_f = obj.innerHTML.toUpperCase().indexOf(val.toUpperCase());
				if (_f != -1) {
					_f = i - 1; // returns the tab num instead of the locale of the searched val.
					break;
				}
			}
		}
	}
	return _f;
 }

function _noticeSearchResult(i, tab_symbol, cObj, _f) {
	_previousKeywordSearch_tabNum = (i + 1);
	_previousKeywordSearch_area = tab_symbol;
	_previousKeywordSearch_innerHTML = cObj.innerHTML;
	SearchObj.getInstance(_previousKeywordSearch_tabNum, _previousKeywordSearch_area, _previousKeywordSearch_innerHTML, _f);
}

function stepKeywordSearch(step) {
	var nbObj = getGUIObjectInstanceById('next_findKeywordRelease');
	var pbObj = getGUIObjectInstanceById('prev_findKeywordRelease');
	var sdObj = getGUIObjectInstanceById('status_findKeywordRelease');
	if ( (SearchObj.instances.length > 0) && (nbObj != null) && (pbObj != null) && (sdObj != null) ) {
		var so = SearchObj.instances[SearchObj.position];
		if (so._f != -1) {
			so.cleanUp(null, null);
	
			SearchObj.position += step;
			if (SearchObj.position < SearchObj.instances.length) {
				so = SearchObj.instances[SearchObj.position];
				if (so._f != -1) {
					so.hilite(null, null);
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

function _showSearchResults(_keyword) {
	if (SearchObj.instances.length == 0) {
		alert('User search did NOT locate "' + _keyword + '".');
	} else {
		var nbObj = getGUIObjectInstanceById('next_findKeywordRelease');
		var sdObj = getGUIObjectInstanceById('status_findKeywordRelease');
		if ( (nbObj != null) && (sdObj != null) ) {
			var so = SearchObj.instances[SearchObj.position];
			if (so._f != -1) {
				SearchObj.keyword = _keyword;
				so.hilite(null, null);
				nbObj.style.display = (SearchObj.instances.length > 1) ? const_inline_style : const_none_style;
				sdObj.style.display = const_inline_style;
				sdObj.innerHTML = SearchObj.statusHTML();
			}
		}
	}
}

function _quietlyPerformSearch(val) {
 	var ts = TabSystem.list['TabSystem1'];
	var _f = -1;
	
	var len = ts.tabs.length;
	if (_f == -1) {
		for(var i = 1; i <= len; i++) {
			var obj = getGUIObjectInstanceById(_const__content + i.toString()); // _const_cell_tab
			if (obj != null) {
				_f = obj.innerHTML.toUpperCase().indexOf(val.toUpperCase());
				if (_f != -1) {
					_noticeSearchResult((i - 1), _const__content, obj, _f);  // _const_cell_tab
				}
			}
		}
	}
	return _f;
 }

function PerformTabSearch(val) {
	var _f = quietlyPerformSearch(val);

	if (_f != -1) {
		FocusOnThisTab(_f);
	}
	if (_f == -1) {
		alert('User search did NOT locate "' + val + '".');
	} else {
		alert('User search successfully located "' + val + '" on the currently selected tab.');
	}
 }

function PerformSearch(val) {
	_quietlyPerformSearch(val);

	_showSearchResults(val);
 }

function initKeywordSearch() {
	var nbObj = getGUIObjectInstanceById('next_findKeywordRelease');
	var pbObj = getGUIObjectInstanceById('prev_findKeywordRelease');
	var sdObj = getGUIObjectInstanceById('status_findKeywordRelease');
	if ( (nbObj != null) && (pbObj != null) && (sdObj != null) ) {
		nbObj.style.display = const_none_style;
		pbObj.style.display = const_none_style;
		sdObj.style.display = const_none_style;

		SearchObj.getObjectInstanceById = getGUIObjectInstanceById;
		if (SearchObj.instances.length > 0) {
			var so = SearchObj.instances[SearchObj.position];
			if (so._f != -1) {
				so.cleanUp(null, null);
			}
		}
		SearchObj.keyword = '';
		SearchObj.position = 0;
		SearchObj.instances = [];
	}
}

function ClearPageNameSearch(_numItems) {
	var _bgColor = "";
	
	for (var i = 1; i <= _numItems ; i++) {
		var _trName = '_row_pageId' + i.toString();
		var _tr = getGUIObjectInstanceById(_trName);
		if (_tr != null) {
			_bgColor = _tr.bgColor;
		}

		if (_bgColor.length > 0) {
			var _tdName = '_cell_pageId' + i.toString();
			var _td = getGUIObjectInstanceById(_tdName);
			if (_td != null) {
				_td.bgColor = _bgColor;
			}
		}
	}
}

function _ClearPageNameSearch() {
	if (_last_page_name_search_i != -1) {
		var _tdName = '_cell_pageId' + _last_page_name_search_i.toString();
		var _td = getGUIObjectInstanceById(_tdName);
		if (_td != null) {
			_td.bgColor = _last_page_name_search_bgColor;
			_last_page_name_search_i = -1;
		}
	}
}

_last_page_name_search_i = -1;
_last_page_name_search_bgColor = -1;

function PerformPageNameSearch(val, _numColumns, _maxVisibleCols, _ss_maxRowsPerColumn, _hilite_color) {
	var i = 1; 
	if (_last_page_name_search_i > -1) {
		i = _last_page_name_search_i + 1;
		_ClearPageNameSearch();
	}
	var dpn_obj = -1; 
	var dpt_obj = -1; 
	while ( (dpn_obj != null) && (dpt_obj != null) ) { 
		dpn_obj = getGUIObjectInstanceById('div_page_name' + i.toString()); 
		dpt_obj = getGUIObjectInstanceById('div_page_title' + i.toString()); 
		if ( (dpn_obj != null) && (dpt_obj != null) ) { 
			var _b = '';
			if (dpn_obj.style.display.trim().toUpperCase() == const_inline_style.trim().toUpperCase()) {
				_b = dpn_obj.innerHTML.stripHTML();
			} else if (dpt_obj.style.display.trim().toUpperCase() == const_inline_style.trim().toUpperCase()) {
				_b = dpt_obj.innerHTML.stripHTML();
			}

			if (_b.trim().toUpperCase().indexOf(val.trim().toUpperCase()) != -1) {
				var _ci = Math.ceil(i / _ss_maxRowsPerColumn);
	
				var _tdName = '_cell_pageId' + i.toString();
				var _td = getGUIObjectInstanceById(_tdName);
				if (_td != null) {
					_last_page_name_search_i = i;
					_last_page_name_search_bgColor = _td.bgColor;
					_td.bgColor = _hilite_color;
				}

				var _obj = getGUIObjectInstanceById('_securitySettingsCol' + _ci.toString());
				if (_obj != null) {
					if (_obj.style.display == const_none_style) {
						rewindVCRControls2(_numColumns, _maxVisibleCols);
						var _okToStop = false;
						while (!_okToStop) {
							var _obj = getGUIObjectInstanceById('_securitySettingsCol' + _ci.toString());
							if (_obj != null) {
								if (_obj.style.display == const_none_style) {
									nextVCRControls2(_numColumns);
								} else {
									_okToStop = true;
								}
							}
						}
						RefreshVCRControls2(_numColumns, _maxVisibleCols);
					}
				}
				break;
			}
			i++; 
		}
	}
	if (_last_page_name_search_i == -1) {
		alert('Search for page named (' + val + ') resulted in nothing found or nothing additional found.\nAre you searching for a Page Name while viewing Page Titles or vice-versa ?');
	}
}
		 
function ProcessCheckBoxes(_uid, sObj, cObj) {
	var _SubSystemList_aList = '';
	if (isObjValidHTMLValueHolder(sObj)) {
		_SubSystemList_aList = sObj.value;
	}
	var _ContentList_aList = '';
	if (isObjValidHTMLValueHolder(cObj)) {
		_ContentList_aList = cObj.value;
	}

 	var _aSubSysList_Array = _SubSystemList_aList.split(",");
 	var _aContentList_Array = _ContentList_aList.split(",");

	var _subsystemId_numChecked = 0;
	for (var i = 0; i < _aSubSysList_Array.length; i++) {
		var _toks = _aSubSysList_Array[i].split("=");
		if (_toks.length == 2) {
			var _uids = _toks[1].split("|");
			var _cbName = '_subsystemId' + (i + 1).toString();
			var _cb = getGUIObjectInstanceById(_cbName);
			if (_cb != null) {
				_cb.checked = false;
			}
			for (var j = 0; j < _uids.length; j++) {
				if (_uids[j] == _uid) {
					if (_cb != null) {
						_cb.checked = true;
						_subsystemId_numChecked++;
					}
				}
			}
		}
	}
	
	if (_subsystemId_numChecked != _aSubSysList_Array.length) {
		getGUIObjectInstanceById('_checkAllSubsystems').style.display = const_inline_style; 
		getGUIObjectInstanceById('_uncheckAllSubsystems').style.display = const_none_style;
	} else {
		getGUIObjectInstanceById('_checkAllSubsystems').style.display = const_none_style; 
		getGUIObjectInstanceById('_uncheckAllSubsystems').style.display = const_inline_style;
	}

	var _pageId_numChecked = 0;
	for (var i = 0; i < _aContentList_Array.length; i++) {
		var _toks = _aContentList_Array[i].split("=");
		if (_toks.length == 2) {
			var _uids = _toks[1].split("|");
			var _cbName = '_pageId' + (i + 1).toString();
			var _cb = getGUIObjectInstanceById(_cbName);
			if (_cb != null) {
				_cb.checked = false;
			}
			for (var j = 0; j < _uids.length; j++) {
				if (_uids[j] == _uid) {
					if (_cb != null) {
						_cb.checked = true;
						_pageId_numChecked++;
					}
				}
			}
		}
	}
	
	if (_pageId_numChecked != _aContentList_Array.length) {
		getGUIObjectInstanceById('_checkAllPages').style.display = const_inline_style; 
		getGUIObjectInstanceById('_uncheckAllPages').style.display = const_none_style;
	} else {
		getGUIObjectInstanceById('_checkAllPages').style.display = const_none_style; 
		getGUIObjectInstanceById('_uncheckAllPages').style.display = const_inline_style;
	}

	var _hf = getGUIObjectInstanceById('_subsystem_uid');
	if (_hf != null) {
		_hf.value = _uid;
	}

	var _hf = getGUIObjectInstanceById('_page_uid');
	if (_hf != null) {
		_hf.value = _uid;
	}
 }
 
 function SubmitUpdateSecuritySettings(_cgiScriptName, _action_symbol) {
 	var aUrl = _cgiScriptName + '?submit=' + _action_symbol;
	
	var i = 1;
	var _objCB = -1;
	
	aUrl = aUrl + '&_subsystemId=';
	
	while (_objCB != null) {
		_objCB = getGUIObjectInstanceById('_subsystemId' + i.toString());
		if (_objCB != null) {
			aUrl = aUrl + _objCB.value + ',';
			i++;
		}
	}
	if (i > 1) {
		aUrl = aUrl.substring(1, aUrl.length - 1);
	}

	var i = 1;
	var _objCB = -1;
	
	aUrl = aUrl + '&_pageId=';
	
	while (_objCB != null) {
		_objCB = getGUIObjectInstanceById('_pageId' + i.toString());
		if (_objCB != null) {
			aUrl = aUrl + _objCB.value + ',';
			i++;
		}
	}
	if (i > 1) {
		aUrl = aUrl.substring(1, aUrl.length - 1);
	}

	window.location.href = aUrl;
 }
 
 function init_m_subsystemId() {
	var i = 1;
	var _objCB = -1;
	var m_objCB = -1;
	while ( (_objCB != null) && (m_objCB != null) ) {
		_objCB = getGUIObjectInstanceById('_subsystemId' + i.toString());
		m_objCB = getGUIObjectInstanceById('m_subsystemId' + i.toString());
		if ( (_objCB != null) && (m_objCB != null) ) {
			if (_objCB.checked == true) {
				m_objCB.value = _objCB.value;
			}
			i++;
		}
	}
 }

function processSubsystemId_click(i) {
	var m_objCB = getGUIObjectInstanceById('m_subsystemId' + i.toString()); 
	var _objCB = getGUIObjectInstanceById('_subsystemId' + i.toString()); 
	if ( (m_objCB != null) && (_objCB != null) ) { 
		if (_objCB.checked == true) { 
			m_objCB.value = _objCB.value;
		} else { 
			m_objCB.value = '';
		} 
	}
}

function isSBCUID_KeycodeValid(ch) {
	var aBool = false;
	
	if ( ( (ch >= 48) && (ch <= 57) ) || ( (ch >= 97) && (ch <= 122) ) || ( (ch >= 65) && (ch <= 90) ) ) {
		aBool = true;
		window.status = '';
	} else {
		window.status = 'You have entered an invalid character that cannot be part of a valid SBCUID.';
	}
	
	return aBool;
}

function isSBCUIDValid(value) {
	var aBool = false;

	value = value.trim();
	if (value.length == 6) {
		var mapping = '';
		for (var i = 0; i < value.length; i++) {
			var ch = value.substring(i, i + 1).toUpperCase();
			mapping += ( (ch >= 'A') && (ch <= 'Z') ) ? 'A' : ( ( (ch >= '0') && (ch <= '9') ) ? 'N' :  'X');
		}
		if (mapping == 'AANNNN') {
			aBool = true;
		}
	}

	return aBool;
}

function _toggleShowPageNamesTitles() {
	var dpn_obj = -1; 
	var dpt_obj = -1; 
	var dpn_objD = -1; 
	var dpt_objD = -1; 
	var i = 1;
	while ( (dpn_obj != null) && (dpt_obj != null) ) { 
		dpn_obj = getGUIObjectInstanceById('div_page_name' + i.toString()); 
		dpt_obj = getGUIObjectInstanceById('div_page_title' + i.toString()); 
		dpn_objD = getGUIObjectInstanceById('disabled_div_page_name' + i.toString()); 
		dpt_objD = getGUIObjectInstanceById('disabled_div_page_title' + i.toString()); 
		if ( (dpn_obj != null) && (dpt_obj != null) && (dpn_objD != null) && (dpt_objD != null) ) {
			dpn_obj.style.display = ((dpn_obj.style.display.trim().toUpperCase() == const_inline_style.trim().toUpperCase()) ? const_none_style : const_inline_style);
			dpt_obj.style.display = ((dpt_obj.style.display.trim().toUpperCase() == const_inline_style.trim().toUpperCase()) ? const_none_style : const_inline_style);
			dpn_objD.style.display = dpn_obj.style.display;
			dpt_objD.style.display = dpt_obj.style.display;
		}
		i++;
	}
}

function performShowPageNames() {
	var spnObj = getGUIObjectInstanceById('_showPageNames');
	var sptObj = getGUIObjectInstanceById('_showPageTitles');
	if ( (spnObj != null) && (sptObj != null) ) {
		_toggleShowPageNamesTitles();
		spnObj.style.display = const_none_style; 
		sptObj.style.display = const_inline_style;
	}
	_ClearPageNameSearch();
}

function performShowPageTitles() {
	var spnObj = getGUIObjectInstanceById('_showPageNames');
	var sptObj = getGUIObjectInstanceById('_showPageTitles');
	if ( (spnObj != null) && (sptObj != null) ) {
		_toggleShowPageNamesTitles();
		spnObj.style.display = const_inline_style; 
		sptObj.style.display = const_none_style;
	}
	_ClearPageNameSearch();
}

function performCloseSBCUIDEditor(tabnum) {
	var obj = getGUIObjectInstanceById('editor' + tabnum.toString()); 
	var obj3 = getGUIObjectInstanceById('open_editor_link' + tabnum.toString()); 
	var obj4 = getGUIObjectInstanceById('opened_editor_link' + tabnum.toString());
	if ( (obj != null) && (obj3 != null) && (obj4 != null) ) {
		obj.style.display = const_none_style;
		obj4.style.display = const_none_style;
		obj3.style.display = const_inline_style;
	}
}

function performClickEditSBCUIDLink(tabnum) {
	var obj = getGUIObjectInstanceById('editor' + tabnum.toString()); 
	var obj3 = getGUIObjectInstanceById('open_editor_link' + tabnum.toString());
	var obj4 = getGUIObjectInstanceById('opened_editor_link' + tabnum.toString());
	if ( (obj != null) && (obj3 != null) && (obj4 != null) ) {
		obj.style.display = const_inline_style;
		obj3.style.display = const_none_style;
		obj4.style.display = const_inline_style;
	}
}

function disableUserIndexHeightControlMinus(bool) {
	var btnObj = getGUIObjectInstanceById('btnMinus_securityUserIndex');
	if (btnObj != null) {
		btnObj.disabled = ((bool == true) ? true : false);
	}
}

function disableUserIndexHeightControlPlus(bool) {
	var btnObj = getGUIObjectInstanceById('btnPlus_securityUserIndex');
	if (btnObj != null) {
		btnObj.disabled = ((bool == true) ? true : false);
	}
}

function hideShowUserIndexHeightControlMinus(bool) {
	var btnObj = getGUIObjectInstanceById('btnMinus_securityUserIndex');
	if (btnObj != null) {
		btnObj.style.display = ((bool == true) ? const_inline_style : const_none_style);
	}
}

function hideShowUserIndexHeightControlPlus(bool) {
	var btnObj = getGUIObjectInstanceById('btnPlus_securityUserIndex');
	if (btnObj != null) {
		btnObj.style.display = ((bool == true) ? const_inline_style : const_none_style);
	}
}

function _getFirstVisibleUserIndexRow(_numRows) {
	var _k = -1;
	
	for (var _i = 1; _i <= _numRows; _i++) {
		var objE = getGUIObjectInstanceById('div_user_index_on' + _i.toString());
		if (objE != null) {
			if (objE.style.display != const_none_style) {
				_k = _i;
				break;
			}
		}
	}
	
	return _k;
}

function _getLastVisibleUserIndexRow(_numRows) {
	var _k = -1;
	
	for (var _i = _numRows; _i >= 1 ; _i--) {
		var objE = getGUIObjectInstanceById('div_user_index_on' + _i.toString());
		if (objE != null) {
			if (objE.style.display != const_none_style) {
				_k = _i;
				break;
			}
		}
	}
	
	return _k;
}

function refreshUserIndexHeightControls() {
	var _fvr = _getFirstVisibleUserIndexRow(user_index_displayableNum);
	var _lvr = _getLastVisibleUserIndexRow(user_index_displayableNum);
	var _rows = (_lvr - _fvr);

	hideShowUserIndexHeightControlMinus(((_rows > _num_vis_tabs_max) ? true : false));
	hideShowUserIndexHeightControlPlus(((_lvr != user_index_displayableNum) && (_rows <= Math.min(user_index_displayableNum, 30)) ? true : false));
}

function read_UserIndexHeight_cookie(default_mx) {
	_mx = getCookie('UserIndexHeight');
	if (_mx != null) {
		_mx = eval(_mx);
	} else {
		_mx = default_mx;
	}
	return _mx;
}

function refreshUserIndexHeight() {
	var _fvr = _getFirstVisibleUserIndexRow(user_index_displayableNum);
	var _lvr = _getLastVisibleUserIndexRow(user_index_displayableNum);
	var _rows = (_lvr - _fvr) + 1;
	
	xtraRows = user_index_displayablePref - _rows;
	performIncreaseUserIndexHeight(xtraRows);
}

function _performIncreaseUserIndexHeight(i) {
	var _lvr = _getLastVisibleUserIndexRow(user_index_displayableNum);

	if ( ((_lvr + i) >= _num_vis_tabs_max) && ((_lvr + i) <= user_index_displayableNum) ) {
		if (i > 0) {
			_lvr += i;
		}
		var on_obj = getGUIObjectInstanceById('div_user_index_on' + _lvr.toString());
		var off_obj = getGUIObjectInstanceById('div_user_index_off' + _lvr.toString());

		if ( (on_obj != null) && (off_obj != null) ) {
			if (i > 0) {
				var on_style = const_inline_style;
				var off_style = const_none_style;
			} else {
				var on_style = const_none_style;
				var off_style = const_inline_style;
			}

			on_obj.style.display = on_style;
			off_obj.style.display = off_style;
			if (i < 0) {
				_lvr += i;
			}

			setCookie('UserIndexHeight', _lvr, '/');
			refreshUserIndexHeightControls();
		}
	}
}
function performIncreaseUserIndexHeight(i) {
	for (var j = Math.abs(i); j > 0; j--) {
		var _i = ((i > 0) ? 1 : -1);
		_performIncreaseUserIndexHeight(_i);
	}
}

function clicked_searchForUser() {
	var sfuObj = getGUIObjectInstanceById('searchForUser');
	var _sfuObj = getGUIObjectInstanceById('_searchForUser');
	var _anuObj = getGUIObjectInstanceById('_addNewUser');
	var _ffObj = getGUIObjectInstanceById('form_searchForUser');
	var tdObj = getGUIObjectInstanceById('td_addNewUser');
	if ( (sfuObj != null) && (_sfuObj != null) && (_anuObj != null) && (_ffObj != null) && (tdObj != null) ) {
		sfuObj.style.display = const_inline_style;
		_sfuObj.style.display = const_none_style;
		tdObj.style.display = const_none_style;
		_anuObj.disabled = true; // .style.display = const_none_style;
		_ffObj._userid.value = ''; 
		setFocusSafely(_ffObj._userid);
		disableDeleteUserButton(true, null);
	}
}

function clicked_cancelSearchForUser() {
	var sfuObj = getGUIObjectInstanceById('searchForUser');
	var _sfuObj = getGUIObjectInstanceById('_searchForUser');
	var _anuObj = getGUIObjectInstanceById('_addNewUser');
	var tdObj = getGUIObjectInstanceById('td_addNewUser');
	if ( (sfuObj != null) && (_sfuObj != null) && (_anuObj != null) && (tdObj != null) ) {
		sfuObj.style.display = const_none_style;
		_sfuObj.style.display = const_inline_style;
		_anuObj.disabled = false; // .style.display = const_inline_style;
		tdObj.style.display = const_inline_style;
		disableDeleteUserButton(false, null);
	}
}

function clicked_addNewUser() {
	var anuObj = getGUIObjectInstanceById('addNewUser');
	var _anuObj = getGUIObjectInstanceById('_addNewUser');
	var _sfuObj = getGUIObjectInstanceById('_searchForUser');
	var _ffObj = getGUIObjectInstanceById('form_addNewUser');
	var tdObj = getGUIObjectInstanceById('td_searchForUser');
	if ( (_sfuObj != null) && (anuObj != null) && (_anuObj != null) && (_ffObj != null) && (tdObj != null) ) {
		anuObj.style.display = const_inline_style;
		_anuObj.style.display = const_none_style;
		// tdObj.style.display = const_none_style;
		_sfuObj.disabled = true; // .style.display = const_none_style;
		_ffObj._userid.value = '';
		setFocusSafely(_ffObj._userid);
	}
}

function clicked_cancelAddNewUser() {
	var anuObj = getGUIObjectInstanceById('addNewUser');
	var _anuObj = getGUIObjectInstanceById('_addNewUser');
	var _sfuObj = getGUIObjectInstanceById('_searchForUser');
	var tdObj = getGUIObjectInstanceById('td_searchForUser');
	if ( (_sfuObj != null) && (anuObj != null) && (_anuObj != null) && (tdObj != null) ) {
		anuObj.style.display = const_none_style;
		_anuObj.style.display = const_inline_style;
		_sfuObj.disabled = false; // .style.display = const_inline_style;
		// tdObj.style.display = const_inline_style;
	}
}