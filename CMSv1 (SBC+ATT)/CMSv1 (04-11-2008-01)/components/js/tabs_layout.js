var _stack_cancel_button_operations = [];

function processCancelButtonOpsStack() {
	var s_op = '';
	while (_stack_cancel_button_operations.length > 0) {
		s_op = _stack_cancel_button_operations.pop();
		eval(s_op);
	}
}

function RefreshVCRControls() {
 	var ts = TabSystem.list['TabSystem1'];
	
	processCancelButtonOpsStack();

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
//		hideShowSearchLinks(ts);
	}
}

function init_stack_cancel_button_operations() {
	_stack_cancel_button_operations = [];
}

function performCloseSBCUIDEditor(tabnum) {
	// this function is stubbed out here because this function exists in the /Security subsystem however the code that calls it is common to all subsystems.
}

function suppress_button_double_click2(btnObj, btnObj2, formObj) {
	return disableButton(btnObj,btnObj2,formObj,null);
}

function cycleEditThisLayoutSpecPanes(_num) {
	var obj1 = getGUIObjectInstanceById('_show_layout_spec_graphic' + _num.toString());
	var obj2 = getGUIObjectInstanceById('_edit_layout_spec_graphic' + _num.toString());
	if ( (obj1 != null) && (obj2 != null) ) {
		obj1.style.display = ((obj1.style.display == const_inline_style) ? const_none_style : const_inline_style);
		obj2.style.display = ((obj2.style.display == const_inline_style) ? const_none_style : const_inline_style);
	}
}

function processEditThisLayoutSpec(_num, btnValue) {
	cycleEditThisLayoutSpecPanes(_num);
	var obj1 = getGUIObjectInstanceById('_layout_spec_codes' + _num.toString());
	var obj2 = getGUIObjectInstanceById('_editable_layout_spec' + _num.toString());
	if ( (isObjValidHTMLValueHolder(obj1)) && (isObjValidHTMLValueHolder(obj2)) ) {
		obj2.value = obj1.value.URLDecode();
		var s_op = "processCancelThisLayoutSpecEdit(" + _num.toString() + ", 'button_layoutEditItAction" + _num.toString() + "', '" + btnValue + "'); processShowCommentsDialog(" + _num.toString() + ", false);";
		_stack_cancel_button_operations.push(s_op);
	}
}

function processCancelThisLayoutSpecEdit(_num, btn_id, btnFace) {
	cycleEditThisLayoutSpecPanes(_num);
	var btnObj = getGUIObjectInstanceById(btn_id);
	if (btnObj != null) {
		btnObj.disabled = false;
		btnObj.value = ((btnFace == null) ? '' : btnFace);

		var _id = getStandardFormIdFor(null);
		_cache_requestSubmitted[_id] = null;
	}
	return false;
}

function processSaveNewLayoutPrep(newVal, _num) {
	var obj1 = getGUIObjectInstanceById('_layout_id');
	var obj2 = getGUIObjectInstanceById('_editable_layout_spec' + _num.toString());
	var obj3 = getGUIObjectInstanceById('fake_editable_layout_spec' + _num.toString());
	var obj3a = getGUIObjectInstanceById('fak_editable_layout_spec' + _num.toString());
	var obj4 = getGUIObjectInstanceById('real_editable_layout_spec' + _num.toString());

	var obj5 = getGUIObjectInstanceById('real_editable_layout_name' + _num.toString());
	var obj5a = getGUIObjectInstanceById('_editable_layout_name' + _num.toString());

	var obj6 = getGUIObjectInstanceById('fake_editable_layout_name' + _num.toString());
	var obj6a = getGUIObjectInstanceById('fak_editable_layout_name' + _num.toString());
	
	var obj7 = getGUIObjectInstanceById('real_editable_layout_change_name' + _num.toString());
	var obj7a = getGUIObjectInstanceById('_editable_layout_change_name' + _num.toString());
	
	var obj8 = getGUIObjectInstanceById('fake_editable_layout_change_name' + _num.toString());
	var obj8a = getGUIObjectInstanceById('fak_editable_layout_change_name' + _num.toString());

// alert('isObjValidHTMLValueHolder(obj1) = ' + isObjValidHTMLValueHolder(obj1) + ', isObjValidHTMLValueHolder(obj2) = ' + isObjValidHTMLValueHolder(obj2) + ', obj3 = ' + obj3 + ', obj3a = ' + obj3a + ', obj4 = ' + obj4 + ', obj5 = ' + obj5 + ', obj6 = ' + obj6 + ', isObjValidHTMLValueHolder(obj5a) = ' + isObjValidHTMLValueHolder(obj5a) + ', isObjValidHTMLValueHolder(obj6a) = ' + isObjValidHTMLValueHolder(obj6a) + ', obj7 = ' + obj7 + ', obj7a = ' + obj7a + ', obj8 = ' + obj8 + ', obj8a = ' + obj8a);
	if ( (isObjValidHTMLValueHolder(obj1)) && (isObjValidHTMLValueHolder(obj2)) && (obj3 != null) && (obj3a != null) && (obj4 != null) && (obj5 != null) && (obj6 != null) && (isObjValidHTMLValueHolder(obj5a)) && (isObjValidHTMLValueHolder(obj6a)) && (obj7 != null) && (obj7a != null) && (obj8 != null) && (obj8a != null) ) {
		obj3a.value = obj2.value;
		obj3a.readonly = true;
		obj3a.disabled = true;
		obj3.style.display = const_inline_style;
		obj4.style.display = const_none_style;
		obj1.value = ( (newVal != null) ? newVal : obj1.value);
		obj2.value = obj2.value.trim().trim().URLEncode();
//alert('obj1.value = ' + obj1.value + ', newVal = ' + newVal);
		obj6a.value = obj5a.value;
		obj6a.disabled = true;
		obj6.style.display = const_inline_style;
		obj5.style.display = const_none_style;
		obj5a.value = obj5a.value.trim().stripCrLfs().trim().URLEncode();

		obj8a.checked = obj7a.checked;
		obj8a.disabled = true;
		obj7.style.display = const_none_style;
		obj8.style.display = const_inline_style;
	}
}

function processSaveModeChange(_num, saveFace, saveNewFace, cb_id, isDefault) {
	var btnObj = getGUIObjectInstanceById('submitButton' + _num.toString());
	var cbObj = getGUIObjectInstanceById(cb_id);
//window.status = 'isDefault = ' + isDefault;
	if ( (btnObj != null) && (cbObj != null) && (isDefault.trim().toUpperCase() != const_true_value_symbol.trim().toUpperCase()) ) {
		btnObj.value = ((cbObj.checked == false) ? saveNewFace : saveFace);
	}
}

function processShowCommentsDialog(_num, bool) {
	var cBtnObj = getGUIObjectInstanceById('comments_button' + _num.toString());
	var sBtnObj = getGUIObjectInstanceById('save_button' + _num.toString());
	var eDivObj = getGUIObjectInstanceById('real_editable_layout_spec' + _num.toString());
	var cDivObj = getGUIObjectInstanceById('comments_editable_layout_spec' + _num.toString());
	var eTblObj = getGUIObjectInstanceById('table_editable_layout_spec' + _num.toString());
	var cTblObj = getGUIObjectInstanceById('table_comments_layout_spec' + _num.toString());
	var eTdObj = getGUIObjectInstanceById('td_editable_layout_spec_cancel' + _num.toString());
	var cTdObj = getGUIObjectInstanceById('td_comments_layout_spec_cancel' + _num.toString());
	if ( (cBtnObj != null) && (sBtnObj != null) && (eDivObj != null) && (cDivObj != null) && (eTblObj != null) && (cTblObj != null) ) {
		sBtnObj.style.display = ((bool == true) ? const_none_style : const_inline_style);
		cBtnObj.style.display = ((bool == true) ? const_inline_style : const_none_style);

		eDivObj.style.display = ((bool == true) ? const_none_style : const_inline_style);
		cDivObj.style.display = ((bool == true) ? const_inline_style : const_none_style);

		eTblObj.style.display = ((bool == true) ? const_none_style : const_inline_style);
		cTblObj.style.display = ((bool == true) ? const_inline_style : const_none_style);

		eTdObj.style.display = ((bool == true) ? const_none_style : const_inline_style);
		cTdObj.style.display = ((bool == true) ? const_inline_style : const_none_style);
		
		if (cDivObj.style.display == const_inline_style) {
			var cTxtObj = getGUIObjectInstanceById('_comments_layout_spec' + _num.toString());
			if (cTxtObj != null) {
				cTxtObj.focus();
			}
		}
	}
}

function showErrorMessage(id, bool) {
	var eMsgObj = getGUIObjectInstanceById(id);
	if (eMsgObj != null) {
		eMsgObj.style.display = ((bool == true) ? const_inline_style : const_none_style);
	}
}

function processCommentsGotFocus() {
	showErrorMessage('_errorMessage1', false);
	showErrorMessage('user_notices1', true);
}

function processClickSearchKeywordLink(bool) {
}

function FocusOnTabWithAnchorText(val) {
 	var ts = TabSystem.list['TabSystem1'];

	var len = ts.tabs.length;
	var _f = -1;
	for(var i = 0; i < len; i++) {
		var tab = ts.tabs[i];
		var _h = getGUIObjectInstanceById(_const__tab + (i + 1).toString());
		if (_h != null) {
			_f = _h.innerHTML.stripHTML().toUpperCase().indexOf(val.toUpperCase());
			if (_f != -1) {
				FocusOnThisTab(i);
				break;
			}
		}
	}
	if ( (_f == -1) && (i == len) ) {
		alert('Unable to locate the desired Layout.');
	}
}

function processClickOpenUsageKeyLink(bool, id) {
	showErrorMessage('div_usage_key', ((bool == true) ? true : false));
	if (bool == false) {
		processCancelButtonOpsStack();
	} else if ( (bool == true) && (id != null) ) {
		var s_op = "var _obj = getGUIObjectInstanceById('" + id + "'); if (_obj != null) { _obj.disabled = false; }";
		_stack_cancel_button_operations.push(s_op);
	}
}
