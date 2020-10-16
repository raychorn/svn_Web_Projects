var stack_allow_breadCrumbs = [];

function queueUp_AJAX_Sessions(sCmd, sArgsQueryString) {
	sArgsQueryString = ((!!sArgsQueryString) ? sArgsQueryString : '');
	switch (sCmd) {
		case js_const_checkLinkedObjects_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			doAJAX_func('performCheckGeonosisLinkedObjects', 'displayCheckedLinkedObjectsCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_getLinkedObjects_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			doAJAX_func('performGetGeonosisLinkedObjects', 'displayLinkedObjectsBrowserCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_addAttribute_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.addNamedContext(js_const_addAttribute_symbol, '');
			doAJAX_func('performAddGeonosisAttribute', 'displayAddOrDropAttributeCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_dropAttribute_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.addNamedContext(js_const_addAttribute_symbol, '');
			doAJAX_func('performDropGeonosisAttribute', 'displayAddOrDropAttributeCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_dropObject_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			doAJAX_func('performDropGeonosisObject', 'displayAddOrDropObjectCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_addObject_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			doAJAX_func('performAddGeonosisObject', 'displayAddOrDropObjectCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_dropClassDef_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			var cObj = $('selection_className');
			if (!!cObj) {
				cObj.disabled = true;
			}
			doAJAX_func('performDropGeonosisClassDef', 'displayAddOrDropClassDefCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_addClassDef_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			var cObj = $('selection_className');
			if (!!cObj) {
				cObj.disabled = true;
			}
			doAJAX_func('performAddGeonosisClassDef', 'displayAddOrDropClassDefCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_chgDataForObject_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			doAJAX_func('performSetGeonosisObjectData', 'displayObjectsBrowserEditCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_chgAttrsForObject_symbol:
			sArgsQueryString += '&sCmd=' + sCmd;
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			doAJAX_func('performSetGeonosisObjectAttribute', 'displayObjectsBrowserEditCompletion(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
		
		case js_const_getOBJECTS_symbol:
			pQueryString = '';
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			var cObj = $('div_objectsBrowser');
			if (!!cObj) {
				cObj.style.display = const_none_style;
			}
			var cObj = $('selection_className');
			if (!!cObj) {
				cObj.disabled = true;
			}
			doAJAX_func('performGetGeonosisObjects', 'displayObjectsBrowser(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;

		case js_const_Objects_symbol:
			pQueryString = '';
			oAJAXEngine.addNamedContext(js_const_Objects_symbol, pQueryString);
			doAJAX_func('performGetGeonosisClasses', 'displayClassesBrowser(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
	}
}

var stack_current_span_inEdit = [];

var stack_addClass_inEdit = [];
var stack_addObject_inEdit = [];
var	stack_addAttribute_inEdit = [];

var cache_input_associations = [];

var objectsMetaDataStack = [];
var objectAttributesMetaDataStack = [];
var objectClassDefinitionsMetDataStack = [];

function isIdentity(id) {
	try {
		var _ar = id.split('_');
		var browserName = _ar[1];
		var colName = _ar[_ar.length - 2];
		var vAR = ((browserName.toUpperCase() == 'Objects'.toUpperCase()) ? objectsMetaDataStack[0] : objectAttributesMetaDataStack[0]).getRecordForMatching('COLUMN_NAME', colName, true);
		vAR = ((typeof vAR == const_object_symbol) ? vAR.pop() : vAR);
		var vType = vAR.getValueFor('TYPE_NAME');
		vType = ((typeof vType == const_object_symbol) ? vType.pop() : vType);
		return (vType.indexOf(' identity') > -1);
	} catch(e) {
		return false;
	} finally {
	}
}

function popCurrentlyEditedInput() {
	if (stack_current_span_inEdit.length > 0) {
		var pID = stack_current_span_inEdit.pop();
		var p_cObj = $(pID);
		var p_dObj = $(pID.asAltIDUsing('div'));
		if ( (!!p_cObj) && (!!p_dObj) ) {
			p_dObj.style.display = const_none_style;
			p_cObj.style.display = const_inline_style;
		}
	}
}

function handleEditableGrid_onClick(cObj, qStringEnc) {
	// ID is always the key for the object's data being edited...
	if (!!cObj) {
		var aSpec = qStringEnc.URLDecode();
		var dict = DictionaryObj.get$(aSpec);
		var dObj = $(cObj.id.asAltIDUsing('div'));
		var eObj = $(cObj.id.asAltIDUsing('input'));
		if ( (!!dObj) && (!!eObj) ) {
			popCurrentlyEditedInput();

			var bool_isIdentity = isIdentity(cObj.id);

			eObj.value = cObj.innerHTML.stripHTML();
			eObj.disabled = (bool_isIdentity);
			eObj.style.border = 'thin solid ' + ((bool_isIdentity) ? 'red' : 'blue');
			eObj.title = ((bool_isIdentity) ? 'Cannot edit an identity element because this value cannot change in order to maintain the integrity of the database.' : 'Press the enter key while this entry field has focus to cause the changes to be stored in the database.');
			dObj.style.display = const_inline_style;
			cObj.style.display = const_none_style;
			stack_current_span_inEdit.push(cObj.id);
		}
		DictionaryObj.remove$(dict.id);
	}
}

function _handleEditableGrid_onClick(id, qStringEnc) {
	return handleEditableGrid_onClick($(id), qStringEnc);
}

function processEditableGridInputAction(id, qStringEnc) {
	var cObj = $(id.asAltIDUsing('span'));
	var dObj = $(id.asAltIDUsing('div'));
	var eObj = $(id); // the edit field that contains the updated data...
	if ( (!!cObj) && (!!dObj) && (!!eObj) ) {
		var aSpec = qStringEnc.URLDecode();
		var dict = DictionaryObj.get$(aSpec);
		var ar = id.split('_');
		var colOffset = ((ar.length == 3) ? 1 : 2);
		dict.put(ar[ar.length - colOffset], eObj.value);
		dict.push('_updatedColumn_', ar[ar.length - colOffset]);
		eObj.style.border = 'thin solid green';

		queueUp_AJAX_Sessions(((ar[1].toUpperCase() == 'Attrs'.toUpperCase()) ? js_const_chgAttrsForObject_symbol : js_const_chgDataForObject_symbol), dict.asQueryString(true));
		DictionaryObj.remove$(dict.id);
	}
}

function dictAsHTMLForBrowser(objType, dict) {
	var aKey = -1;
	var _html = '';
	var datum = -1;
	var qString = -1;
	if ( (!!objType) && (!!dict) ) {
		var _keys = dict.getKeys();

		qString = dict.asQueryString();
		for (var i = 0; i < _keys.length; i++) {
			aKey = _keys[i];
			if (aKey.trim().toUpperCase() != 'rowCnt'.toUpperCase()) {
				_html += '<tr>';
				_html += '<td align="left" valign="top" bgcolor="silver">';
				_html += '<span class="boldPromptTextClass">' + aKey + '</span>';
				_html += '</td>';
				datum = dict.getValueFor(aKey);
				if (!!datum) {
					if (datum.length > 0) {
						// the onClick handler needs all the data from just the datum col for this specific item because the unique ID is part of the datum for the specific column...
						_html += '<td id="td_' + objType + '_' + aKey + '" align="left" valign="top">';
						_html += '<span id="span_' + objType + '_' + aKey + '" class="textClass" style="display: inline; cursor:hand; cursor:pointer;" onmouseover="this.title = this.id;" onclick="handleEditableGrid_onClick(this,\'' + qString.URLEncode() + '\'); return false;">' + ((datum.length == 0) ? '_' : '&nbsp;' + datum) + '</span>';
						_html += '<div id="div_' + objType + '_' + aKey + '" style="display: none;">' + '<input id="input_' + objType + '_' + aKey + '" class="normalStatusBoldClass" size="30" maxlength="50" onkeydown="if (event.keyCode == 13) { processEditableGridInputAction(this.id,\'' + qString.URLEncode() + '\'); }; return true;">' + '</span>';
						_html += '</td>';
					}
				}
				_html += '</tr>';
			}
		}
	}
	return _html;
}

function populateQuickBrowserPanel(qbObj, objType) {
	var _html = '';
	if (!!qbObj) {
		var sel = qbObj.selectedIndex;
		var dD = DictionaryObj.get$(qbObj.options[sel].value)
		var qbDivObj = $('div_' + objType + '_browser');
		if (!!qbDivObj) {
			flushCache$(qbDivObj);
			_html = beginTable(objType, '&table=' + 'border="1"'.URLEncode() + '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
			_html += dictAsHTMLForBrowser(objType, dD);
			_html += endTable();
			qbDivObj.innerHTML = _html;
		}
	}
}

function populateQuickBrowser(objType, d) {
	var _html = '';
	var _quickBrowseObjName = 'selection_' + objType + '_browser';
	var qbObj = $(_quickBrowseObjName);
	if ( (!!qbObj) && (!!d) ) {
		var _keys = d.getKeys();
		var datum = -1;
		var i = -1;
		var j = -1;
		var aKey = '';
		var numCols = -1;
		var cObj = $('selection_objectName');
		for (i = 0; i < _keys.length; i++) {
			aKey = _keys[i];
			if (aKey.trim().toUpperCase() != 'rowCnt'.toUpperCase()) {
				datum = d.getValueFor(aKey);
				if ( (!!datum) && (typeof datum == const_object_symbol) ) {
					if ( (numCols == -1) && (datum.length > 0) ) {
						numCols = datum.length;
					}
				}
				if ( (objType.trim().toUpperCase() == 'Attrs'.toUpperCase()) && (aKey.trim().toUpperCase() == 'ATTRIBUTENAME'.toUpperCase()) ) {
					for (j = 0; j < datum.length; j++) {
						qString = d.asQueryStringForColumn(j);
						qbObj.options[qbObj.options.length] = new Option( datum[j], qString);
					}
					var btnObj = $('btn_attr_remove');
					if ( (!!btnObj) && (!!cObj) ) {
						btnObj.disabled = (( (qbObj.options.length > 0) && (cObj.selectedIndex > -1) ) ? false : true);
					}
				}
			}
		}
		populateQuickBrowserPanel(qbObj, objType);
		var btnObj = $('btn_attrs_add');
		if ( (!!btnObj) && (!!cObj) ) {
			btnObj.disabled = ((cObj.selectedIndex > -1) ? false : true);
		}
	}
}

function handle_quickBrowser_onChange(cObj) {
	if (!!cObj) {
		populateQuickBrowserPanel(cObj, 'Attrs');
	}
}

function displayDictForBrowser(objType, d) {
	var _html = '';
	var qString = '';
	if (!!d) {
		var _keys = d.getKeys();
		var datum = -1;
		var j = -1;
		var aKey = '';
		var numCols = -1;
		for (var i = 0; i < _keys.length; i++) {
			aKey = _keys[i];
			if (aKey.trim().toUpperCase() != 'rowCnt'.toUpperCase()) {
				datum = d.getValueFor(_keys[i]);
				if ( (!!datum) && (typeof datum == const_object_symbol) ) {
					if ( (numCols == -1) && (datum.length > 0) ) {
						numCols = datum.length;
					} else {
						break;
					}
				}
			}
		}
		var _quickBrowseObjName = '';
		if ( (numCols > 0) && (objType.toUpperCase() == 'ATTRS') ) {
			_quickBrowseObjName = 'selection_' + objType + '_browser';
			_html += '<td align="left" valign="top">';
			_html += '<select id="' + _quickBrowseObjName + '" class="boldPromptTextClass" onchange="handle_quickBrowser_onChange(this); return false;"></select>';
			_html += '</td>';
		}
		_html += '<tr>';
		_html += '<td align="left" valign="top">';
		_html += '<div id="div_' + objType + '_browser"></div>';
		_html += '</td>';
		_html += '</tr>';

		if ( (numCols == 1) && (objType.toUpperCase() != 'ATTRS') ) {
			for (var i = 0; i < _keys.length; i++) {
				aKey = _keys[i];
				if (aKey.trim().toUpperCase() != 'rowCnt'.toUpperCase()) {
					_html += '<tr>';
					_html += '<td align="left" valign="top" bgcolor="silver">';
					_html += '<span class="boldPromptTextClass">' + aKey + '</span>';
					_html += '</td>';
					datum = d.getValueFor(_keys[i]);
					if ( (!!datum) && (typeof datum == const_object_symbol) ) {
						if (datum.length > 0) {
							for (j = 0; j < datum.length; j++) {
								qString = d.asQueryStringForColumn(j);
								// the onClick handler needs all the data from just the datum col for this specific item because the unique ID is part of the datum for the specific column...
								_html += '<td id="td_' + objType + '_' + aKey + '_' + j + '" align="left" valign="top">';
								_html += '<span id="span_' + objType + '_' + aKey + '_' + j + '" class="textClass" style="display: inline; cursor:hand; cursor:pointer;" onclick="handleEditableGrid_onClick(this,\'' + qString.URLEncode() + '\'); return false;">' + ((datum[j].length == 0) ? '_' : '&nbsp;' + datum[j]) + '</span>';
								_html += '<div id="div_' + objType + '_' + aKey + '_' + j + '" style="display: none;">' + '<input id="input_' + objType + '_' + aKey + '_' + j + '" class="normalStatusBoldClass" size="30" maxlength="50" onkeydown="if (event.keyCode == 13) { processEditableGridInputAction(this.id,\'' + qString.URLEncode() + '\'); }; return true;">' + '</span>';
								_html += '</td>';
							}
						}
					}
					_html += '</tr>';
				}
			}
		}
	}
	return _html;
}

function performShowAddAttrPanel() {
	var cObj = $('div_addAttr_panel');
	if (!!cObj) {
		cObj.style.display = const_inline_style;
	}
	var iObj = $('input_addAttribute_attributeName');
	if (!!iObj) {
		setFocusSafely(iObj);
	}
}

function handle_onmousedown_beginDrag(draggableObj, el_dragtarget) {
	var dragBeginState = [];
	var dragTarget = $(el_dragtarget);
 	var drObj = DragObj.getInstance(draggableObj);
	if ( (!!dragTarget) && (!!draggableObj) && (!!DragObj) && (!!drObj) ) {
	 	drObj.addDropTarget(dragTarget);
	 	drObj.keepInContainer = false;

		dragBeginState.push(draggableObj.style.position);
		dragBeginState.push(draggableObj.style.top);
		dragBeginState.push(draggableObj.style.left);
		draggableObj.style.position = 'absolute';
		
		drObj.ondrag = function() {
		//	var id = 'input_Object_ID';
		//	window.status = 'Event: ondrag !' + ' (' + draggableObj.style.left + ',' + draggableObj.style.top + ')' + ', draggableObj.id = [' + draggableObj.id + ']';
	 	};
// +++
	 	drObj.ondragdrop = function(e) {
			var i = -1;
			var ar = draggableObj.id.split('_');
			var id = ar[ar.length - 1];
			var aDict = GeonosisObj.searchInstancesForID(id);
			if (!!dragTarget.options) {
				var boolFound = false;
				for (i = 0; i < dragTarget.options.length; i++) {
					if (dragTarget.options[i].value == id) {
						boolFound = true;
						break;
					}
				}
				if (!boolFound) {
					dragTarget.options[dragTarget.options.length] = new Option( aDict.getValueFor('CLASSNAME') + '::' + aDict.getValueFor('OBJECTNAME'), id);
					if (dragTarget.options.length > dragTarget.size) {
						dragTarget.size = dragTarget.options.length;
					}
				}
			}
		//	window.status = 'Event: ondragdrop !';
			drObj.removeDropTarget(draggableObj);
	 	};
		
	 	drObj.ondragstop = function() {
			if (dragBeginState.length > 0) {
				draggableObj.style.left = dragBeginState.pop();
				draggableObj.style.top = dragBeginState.pop();
				draggableObj.style.position = dragBeginState.pop();
			//	window.status = 'Event: ondragstop !';
			}
	 	};

	 	drObj.ondragend = function() {
			if (dragBeginState.length > 0) {
				draggableObj.style.left = dragBeginState.pop();
				draggableObj.style.top = dragBeginState.pop();
				draggableObj.style.position = dragBeginState.pop();
			//	window.status = 'Event: ondragend !';
			}
	 	};
	} else {
		alert('Programming Error: Missing one of ' + 'dragTarget = (' + dragTarget + ')' + ', draggableObj = (' + draggableObj + ')' + ', DragObj = (' + DragObj + ')' + ', dragAbstract = (' + dragAbstract + ')');
	}
}

function handle_onmouseover_beginDrag(draggableObj) {
	if (!!draggableObj) {
		draggableObj.style.cursor = const_cursor_hand;
	}
}

function handle_onmouseout_beginDrag(draggableObj) {
	if (!!draggableObj) {
		draggableObj.style.cursor = const_cursor_default;
	}
}

var currentlySelectedObject_sel = -1;

function handle_objectName_onChange(cObj) {
	var _html = '';
	if (!!cObj) {
		dObj = $('div_attrsBrowser');
		if (!!dObj) {
			var sel = cObj.selectedIndex;
			if (sel > -1) {
				currentlySelectedObject_sel = sel;
				var aDict = GeonosisObj.searchInstancesForObjectID(cObj.options[sel].value);
				var _btnHtmlL = '<button id="btn_attr_remove" disabled class="buttonClass" title="Click this button to remove the selected Attribute." onclick="performConfirmDropAttributeDialog(); return false;">[-]</button>&nbsp;';
				var _btnHtmlR = '&nbsp;<button id="btn_attrs_add" disabled class="buttonClass" title="Click this button to add a new Attribute." onclick="performShowAddAttrPanel(); return false;">[+]</button>';
				_html += beginTable(_btnHtmlL + 'Attrs' + _btnHtmlR, '&table=' + 'border="1"'.URLEncode() + '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
				_html += displayDictForBrowser('Attrs', aDict);
				_html += endTable();

				flushCache$(dObj);
				dObj.innerHTML = _html;

				populateQuickBrowser('Attrs', aDict);
				
				oObj = $('div_objectBrowser');
				if (!!oObj) {
					var _aDict = GeonosisObj.searchInstancesForID(cObj.options[sel].value);
// +++
					var dragHandle = '<div id="div_dragHandle_' + cObj.options[sel].value + '" title="This is a Draggable Object - Drag it to the Objects to Link Selection." onmousedown="handle_onmousedown_beginDrag(this, \'selection_objects2Link\'); return false;" onmouseover="handle_onmouseover_beginDrag(this); return false;" onmouseout="handle_onmouseout_beginDrag(this); return false;" style="border: thin dotted black;">' + 'Object: ' + cObj.options[sel].text + '</div>';
					_html = beginTable(dragHandle, '&table=' + 'border="1"'.URLEncode() + '&bool=' + 'includeDismissButton=true'.URLEncode() + '&div=' + 'dismissDiv=div_objectBrowser'.URLEncode() + '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&td=' + 'colspan="2"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
					_html += displayDictForBrowser('Objects', _aDict);
					_html += endTable();

					flushCache$(oObj);
					oObj.innerHTML = _html;
					
					DictionaryObj.remove$(_aDict.id);
				}

				btnObj = $('btn_objects_remove');
				if (!!btnObj) {
					btnObj.disabled = ((aDict.length() == 0) ? false : true);
				}

				DictionaryObj.remove$(aDict.id);
			}
		}
		var btnObj = $('btn_attrs_add');
		if (!!btnObj) {
			btnObj.disabled = ((cObj.selectedIndex > -1) ? false : true);
		}
		// +++

		var oSelLinkedObjects = $('selection_linkedObjects');
		if (!!oSelLinkedObjects) {
			while (oSelLinkedObjects.options.length > 0) {
				oSelLinkedObjects.options[0] = null;
			}
		}

		queueUp_AJAX_Sessions(js_const_getLinkedObjects_symbol, '&OBJECTID=' + cObj.options[sel].value.URLEncode());
	}
}

function _handle_objectName_onChange(id, sel) {
	var cObj = $(id);
	if (!!cObj) {
		cObj.selectedIndex = sel;
		return handle_objectName_onChange(cObj);
	}
}

function handle_className_onChange(cObj) {
	dObj = $('div_attrsBrowser');
	oObj = $('div_objectBrowser');
	var oSelLinkedObjects = $('selection_linkedObjects');
	if ( (!!cObj) && (!!dObj) && (!!oObj) ) { // cObj.options[sel].value is the OBJECTCLASSID
		var sel = cObj.selectedIndex;
		if (sel > -1) {
			flushCache$(dObj);
			dObj.innerHTML = '';
			flushCache$(oObj);
			oObj.innerHTML = '';

			queueUp_AJAX_Sessions(js_const_getOBJECTS_symbol, '&CLASSNAME=' + cObj.options[sel].text.toString().URLEncode() + '&hasMetaData=' + (((objectsMetaDataStack.length > 0) && (objectAttributesMetaDataStack.length > 0)) ? 'true' : 'false').URLEncode());
		}
	}
	if (!!oSelLinkedObjects) {
		while (oSelLinkedObjects.options.length > 0) {
			oSelLinkedObjects.options[0] = null;
		}
	}
}

function _handle_className_onChange(id, sel) {
	var cObj = $(id);
	if (!!cObj) {
		cObj.selectedIndex = sel;
		return handle_className_onChange(cObj);
	}
}

function handleBreadCrumbs(ar) {
	var i = -1;
	var iAR = -1;
	for (i = 0; i < ar.length; i++) {
		iAR = ar[i].split('|');
		if (iAR.length == 3) {
			if (iAR[0].toUpperCase() == '_handle_className_onChange'.toUpperCase()) {
			//	_handle_className_onChange(iAR[1], iAR[2]); // do not allow this to be handled or the whole GUI falls to crap and doesn't work right...
			} else if (iAR[0].toUpperCase() == '_handle_objectName_onChange'.toUpperCase()) {
				_handle_objectName_onChange(iAR[1], iAR[2]);
			}
		}
	}
}

function performShowAddObjectPanel() {
	var cObj = $('div_addObject_panel');
	if (!!cObj) {
		cObj.style.display = const_inline_style;
	}
	var iObj = $('input_addObject_objectName');
	if (!!iObj) {
		setFocusSafely(iObj);
	}
}

function performConfirmDropAttributeDialog() {
	var sel = -1;
	var cObj = $('selection_attrs_browser');
	var _cObj = _$('selection_attrs_browser');
	if (!!cObj) {
		if ((sel = cObj.selectedIndex) > -1) {
			var attrName = cObj.options[sel].text;
			var attrID = cObj.options[sel].value;
			var xBool = confirm('Are you sure you want to drop the Attribute known as "' + attrName + '" ?');
			if (xBool) {
				var _CLASSNAME = '';
				var cnObj = $('selection_className');
				if ( (!!cnObj) && ((sel = cnObj.selectedIndex) > -1) ) {
					_CLASSNAME = cnObj.options[sel].text;
				}
				var qStr = attrID + '&CLASSNAME=' + _CLASSNAME + '&hasMetaData=' + (((objectsMetaDataStack.length > 0) && (objectAttributesMetaDataStack.length > 0)) ? 'true' : 'false').URLEncode();
				queueUp_AJAX_Sessions(js_const_dropAttribute_symbol, qStr);
			}
		}
	}
}

function performConfirmDropObjectDialog() {
	var sel = -1;
	var cObj = $('selection_objectName');
	if (!!cObj) {
		if ((sel = cObj.selectedIndex) > -1) {
			var ObjectName = cObj.options[sel].text;
			var objectID = cObj.options[sel].value;
			var xBool = confirm('Are you sure you want to drop the Object known as "' + ObjectName + '" ?');
			if (xBool) {
				var _CLASSNAME = '';
				var cnObj = $('selection_className');
				if ( (!!cnObj) && ((sel = cnObj.selectedIndex) > -1) ) {
					_CLASSNAME = cnObj.options[sel].text;
				}
				queueUp_AJAX_Sessions(js_const_dropObject_symbol, '&objectID=' + objectID.URLEncode() + '&CLASSNAME=' + _CLASSNAME + '&hasMetaData=' + (((objectsMetaDataStack.length > 0) && (objectAttributesMetaDataStack.length > 0)) ? 'true' : 'false').URLEncode());
			}
		}
	}
}

function processAddObjectInputAction(id, qStr) {
	var i = -1;
	var kValuesCnt = 0;
	var iObj = -1;
	var currentNum = -1;
	var qString = '';
	var bool_hasAllValues = false;
	
	for (i = 0; i < stack_addObject_inEdit.length; i++) {
		iObj = $(stack_addObject_inEdit[i]);
		if ( (!!iObj) && (iObj.value.trim().length > 0) ) {
			kValuesCnt++;
		}
		if (currentNum == -1) {
			currentNum = ((stack_addObject_inEdit[i].toUpperCase() == id.toUpperCase()) ? i : -1);
		}
	}

	if (kValuesCnt == stack_addObject_inEdit.length) {
		for (i = 0; i < stack_addObject_inEdit.length; i++) {
			iObj = $(stack_addObject_inEdit[i]);
			if (!!iObj) {
				iObj.style.border = 'thin solid green';
				var ar = iObj.id.split('_');
				qString += '&' + ar[ar.length - 1] + '=' + escape(iObj.value);
			}
		}

		var sel = -1;
		var objectClassID = -1;
		var _CLASSNAME = '';
		var cObj = $('selection_className');
		if ( (!!cObj) && ((sel = cObj.selectedIndex) > -1) ) {
			objectClassID = cObj.options[sel].value;
			_CLASSNAME = cObj.options[sel].text;
		}
		queueUp_AJAX_Sessions(js_const_addObject_symbol, '&objectClassID=' + objectClassID + '&CLASSNAME=' + _CLASSNAME + '&hasMetaData=' + (((objectsMetaDataStack.length > 0) && (objectAttributesMetaDataStack.length > 0)) ? 'true' : 'false').URLEncode() + qString);
	} else if (currentNum > -1) {
		if (currentNum == (stack_addObject_inEdit.length - 1)) {
			currentNum = 0;
		} else {
			currentNum++;
		}
		iObj = $(stack_addObject_inEdit[currentNum]);
		if (!!iObj) {
			setFocusSafely(iObj);
		}
	}
}

function performSaveAttribute() {
	var i = -1;
	var iObj = -1;
	var qString = '';
	for (i = 0; i < stack_addAttribute_inEdit.length; i++) {
		iObj = $(stack_addAttribute_inEdit[i]);
		if (!!iObj) {
			iObj.style.border = 'thin solid green';
			var ar = iObj.id.split('_');
			qString += '&' + ar[ar.length - 1] + '=' + escape(iObj.value);
		}
	}

	var sel = -1;
	var objectID = -1;
	var _OBJECTNAME = '';
	var cObj = $('selection_objectName');
	if ( (!!cObj) && ((sel = cObj.selectedIndex) > -1) ) {
		objectID = cObj.options[sel].value;
		_OBJECTNAME = cObj.options[sel].text;
	}
	var _qStr = '&objectID=' + objectID + '&OBJECTNAME=' + _OBJECTNAME + '&hasMetaData=' + (((objectsMetaDataStack.length > 0) && (objectAttributesMetaDataStack.length > 0)) ? 'true' : 'false').URLEncode() + qString;
	queueUp_AJAX_Sessions(js_const_addAttribute_symbol, _qStr);
}

function processAddAttributeInputAction(id, qStr) {
	var btnObj = $('btn_attr_submit');
	var oAttributeName = $('input_addAttribute_attributeName');
	var oValueString = $('input_addAttribute_valueString');
	var oValueText = $('input_addAttribute_valueText');
	var oDisplayOrder = $('input_addAttribute_displayOrder');
	var oStartVersion = $('input_addAttribute_startVersion');
	var oLastVersion = $('input_addAttribute_lastVersion');
	var oCreated = $('input_addAttribute_created');
	var oCreatedBy = $('input_addAttribute_createdBy');
	var oUpdated = $('input_addAttribute_updated');
	var oUpdatedBy = $('input_addAttribute_updatedBy');
	if ( (!!btnObj) && (!!oAttributeName) && (!!oValueString) && (!!oValueText) && (!!oDisplayOrder) && (!!oDisplayOrder) && (!!oLastVersion) ) {
		btnObj.disabled = (( (oAttributeName.value.trim().length > 0) && ( (oValueString.value.trim().length > 0) || (oValueText.value.trim().length > 0) ) && (oDisplayOrder.value.trim().length > 0) && (oStartVersion.value.trim().length > 0) && (oLastVersion.value.trim().length > 0) && (oCreated.value.trim().length > 0) && (oCreatedBy.value.trim().length > 0) && (oUpdated.value.trim().length > 0) && (oUpdatedBy.value.trim().length > 0) ) ? false : true);
	}
}

function displayObjectsBrowserGUI() {
	var _html = '';
	var editingMetaDataFor = 'Object';
	var btnObj = -1;
	var cObj = $('selection_className');
	var dObj = $('div_objectsBrowser');

	function displayMetaDataRecord(_ri, _dict, _rowCntName) {
		var i = -1;
		var _COLUMN_NAME = '';
		var _COLUMN_SIZE = '';
		var _TYPE_NAME = '';
		var _rowCnt = -1;
		var idName = '';
		var defaultValue = '';
		var extraSize = 0;
		var todayDt = new Date();
		var defaultDt = '';
		var defaultUserName = '';
		
		try {
			_COLUMN_NAME = _dict.getValueFor('COLUMN_NAME');
			_COLUMN_SIZE = parseInt(_dict.getValueFor('COLUMN_SIZE'));
			_TYPE_NAME = _dict.getValueFor('TYPE_NAME');
			_rowCnt = parseInt(_dict.getValueFor(_rowCntName));
		} catch(e) {
		} finally {
		}

		if (_TYPE_NAME.toUpperCase().indexOf(' identity'.toUpperCase()) == -1) {
			idName = 'input_add' + editingMetaDataFor + '_' + _COLUMN_NAME;
			defaultValue = '';
			defaultUserName = 'raychorn@hotmail.com';
			defaultDt = todayDt.getYear() + '-' + todayDt.getMonth().toString().zeroPadLeading(2) + '-' + todayDt.getDay().toString().zeroPadLeading(2) + ' ' + todayDt.getHours().toString().zeroPadLeading(2) + ':' + todayDt.getMinutes().toString().zeroPadLeading(2) + ':' + todayDt.getSeconds().toString().zeroPadLeading(2) + '.0';
			switch (_COLUMN_NAME) {
				case 'publishedVersion':
					defaultValue = '0';
				break;

				case 'editVersion':
					defaultValue = '0';
				break;

				case 'created':
					defaultValue = defaultDt;
				break;

				case 'createdBy':
					defaultValue = defaultUserName;
				break;

				case 'updated':
					defaultValue = defaultDt;
				break;

				case 'updatedBy':
					defaultValue = defaultUserName;
				break;
			}
			extraSize = 0;
			switch (_TYPE_NAME) {
				case 'smalldatetime':
					extraSize = 5;
				break;
			}
			_html += '<tr>';
			_html += '<td bgcolor="silver"><span class="boldPromptTextClass">' + _COLUMN_NAME + '</span></td>';
			_html += '<td><input id="' + idName + '" class="normalStatusClass" value="' + defaultValue + '" size="' + ((_COLUMN_SIZE > 50) ? 50 : (_COLUMN_SIZE + extraSize)) + '" maxlength="' + (_COLUMN_SIZE + extraSize) + '" onkeydown="if ( (event.keyCode == 13) || (event.keyCode == 9) || (event.keyCode == 40) || (event.keyCode == 38) ) { processAdd' + editingMetaDataFor + 'InputAction(this.id,\'' + _dict.asQueryString().URLEncode() + '\'); }; return true;"></td>';
			_html += '</tr>';
			
			if (editingMetaDataFor.toUpperCase() == 'Object'.toUpperCase()) {
				stack_addObject_inEdit.push(idName);
			} else if (editingMetaDataFor.toUpperCase() == 'Attribute'.toUpperCase()) {
				stack_addAttribute_inEdit.push(idName);
			}
		}
	};

	if ( (!!dObj) && (!!cObj) ) {
		stack_addObject_inEdit = [];
		stack_addAttribute_inEdit = [];
		
		cObj.disabled = false; // enabled this because it was diabled when the AJAX call began...
		dObj.style.display = const_inline_style; // show this because it was hidden when the AJAX call began...

		var sel = cObj.selectedIndex;

		if (sel > -1) {
			var aDict = GeonosisObj.searchInstancesForClassName(cObj.options[sel].text);
			var _OBJECTNAME = aDict.getValueFor('OBJECTNAME');
			var _ID = aDict.getValueFor('ID');
			var oObj = -1;
			if ( (!!_OBJECTNAME) && (typeof _OBJECTNAME == const_object_symbol) && (!!_ID) && (typeof _ID == const_object_symbol) && (_OBJECTNAME.length == _ID.length) ) {
			} else {
				btnObj = $('btn_classes_remove');
				if (!!btnObj) {
					btnObj.disabled = false;
				}
			}
			var _btnHtmlL = '<button id="btn_objects_remove" disabled class="buttonClass" title="Click this button to remove the selected Object.  An Object may only be removed when there are no other objects linked to it such as Attributes or ObjectLinks." onclick="performConfirmDropObjectDialog(); return false;">[-]</button>&nbsp;';
			var _btnHtmlR = '&nbsp;<button id="btn_objects_add" class="buttonClass" title="Click this button to add a new Object." onclick="performShowAddObjectPanel(); return false;">[+]</button>';
			_html += beginTable(_btnHtmlL + 'Objects' + _btnHtmlR, '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
			_html += '<tr>' + '<td>';

			var width_of_objects_selection = '200';
			
			_html += '<select id="selection_objectName" size="' + Math.min(aDict.length(), 20) + '" class="boldPromptTextClass" style="width: ' + width_of_objects_selection + 'px;" onchange="handle_objectName_onChange(this); return true;">';

			btnObj = $('btn_classes_remove');
			if (!!btnObj) {
				btnObj.disabled = (((!!_OBJECTNAME) && (_OBJECTNAME.length > 0)) ? true : false);
			}
			
			if (!!_OBJECTNAME) {
				for (var i = 0; i < _OBJECTNAME.length; i++) {
					_html += '<option value="' + _ID[i] + '">' + _OBJECTNAME[i] + '</option>';
				}
			}

			_html += '</select>';
			
			_html += '</td>' + '</tr>';

			_html += endTable();

			_html += '<div id="div_addObject_panel" style="display: none;">';
			_html += beginTable('Add an Object', '&bool=' + 'includeDismissButton=true'.URLEncode() + '&div=' + 'dismissDiv=div_addObject_panel'.URLEncode() + '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
			_html += '<tr>' + '<td>';
			_html += beginTable();

			editingMetaDataFor = 'Object';
			objectsMetaDataStack[0].iterateRecObjs(displayMetaDataRecord);

			_html += endTable();
			_html += '</td>' + '</tr>';
			_html += endTable();
			_html += '</div>';

			_html += '<div id="div_addAttr_panel" style="display: none;">';
			var _btnHtmlL = '<button id="btn_attr_submit" disabled class="buttonClass" title="Click this button to save the Attribute being edited." onclick="performSaveAttribute(); return false;">[Save]</button>&nbsp;';
			_html += beginTable(_btnHtmlL + 'Add an Attribute', '&bool=' + 'includeDismissButton=true'.URLEncode() + '&div=' + 'dismissDiv=div_addAttr_panel'.URLEncode() + '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
			_html += '<tr>' + '<td>';
			_html += beginTable();

			editingMetaDataFor = 'Attribute';
			objectAttributesMetaDataStack[0].iterateRecObjs(displayMetaDataRecord);

			_html += endTable();
			_html += '</td>' + '</tr>';
			_html += endTable();
			_html += '</div>';
			
			flushCache$(dObj);
			dObj.innerHTML = _html;
			
			DictionaryObj.remove$(aDict.id);
		}
	}
}

function displayObjectsBrowser(qObj) {
	var i = -1;
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var _contextName = js_const_Objects_symbol;

	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...

	var qStats = qObj.named('qDataNum');
	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) {
		oParms = qObj.named('qParms');
		if (!!oParms) {
		}

		oAJAXEngine.setContextName(_contextName);

		// BEGIN: Scan for and handle any errors...
		for (i = 0; i < qObj.names.length; i++) {
			qData = qObj.named(qObj.names[i]);
			qData.iterateRecObjs(anyErrorRecords);
			if (bool_isAnyErrorRecords) {
				qData.iterateRecObjs(displayErrorRecord);
				break;
			}
		}
		// END! Scan for and handle any errors...

		if (!bool_isAnyErrorRecords) {
			var qSchema = qObj.named('qSchema');
			if (!!qSchema) {
				var qSchema_OBJECTSMETDATARECORD = qSchema.getValueFor('OBJECTSMETDATARECORD');
				if (typeof qSchema_OBJECTSMETDATARECORD == const_object_symbol) {
					qSchema_OBJECTSMETDATARECORD = qSchema_OBJECTSMETDATARECORD.pop();
				}
				if (qSchema_OBJECTSMETDATARECORD > -1) {
					objectsMetaDataStack.push(qObj.named('qObjectsMetDataRecord'));
				}
				var qSchema_OBJECTATTRIBUTESMETDATARECORD = qSchema.getValueFor('OBJECTATTRIBUTESMETDATARECORD');
				if (typeof qSchema_OBJECTATTRIBUTESMETDATARECORD == const_object_symbol) {
					qSchema_OBJECTATTRIBUTESMETDATARECORD = qSchema_OBJECTATTRIBUTESMETDATARECORD.pop();
				}
				if (qSchema_OBJECTATTRIBUTESMETDATARECORD > -1) {
					objectAttributesMetaDataStack.push(qObj.named('qObjectAttributesMetDataRecord'));
				}
				var qSchema_objectCnt = qSchema.getValueFor('OBJECTCNT');
				if (typeof qSchema_objectCnt == const_object_symbol) {
					qSchema_objectCnt = qSchema_objectCnt.pop();
				}
				var qSchema_SCOPESCONTENTQUERY = qSchema.getValueFor('SCOPESCONTENTQUERY');
				if (typeof qSchema_SCOPESCONTENTQUERY == const_object_symbol) {
					qSchema_SCOPESCONTENTQUERY = qSchema_SCOPESCONTENTQUERY.pop();
				}
				if (qSchema_SCOPESCONTENTQUERY > -1) {
					var qScopeContent = qObj.named('qData' + qSchema_SCOPESCONTENTQUERY)
					if (!!qScopeContent) {
						var scopeName = qScopeContent.getValueFor('SCOPENAME');
						if (typeof scopeName == const_object_symbol) {
							scopeName = scopeName.pop();
						}
						var scopeContent = qScopeContent.getValueFor('HTMLCONTENT');
						if (typeof scopeContent == const_object_symbol) {
							scopeContent = scopeContent.pop();
						}

						switch (scopeName.toUpperCase()) {
							case js_const_Session_symbol.toUpperCase():
								setSessionScopeDebugPanelContent(scopeContent);
							break;

							case js_const_Application_symbol.toUpperCase():
								setApplicationScopeDebugPanelContent(scopeContent);
							break;

							case js_const_CGI_symbol.toUpperCase():
								setCgiScopeDebugPanelContent(scopeContent);
							break;

							case js_const_Request_symbol.toUpperCase():
								setRequestScopeDebugPanelContent(scopeContent);
							break;
						}
					}
				}

				GeonosisObj._remove$(); // do this because we also use this function to display data after editing actions that may change data...

				var nn = qSchema_objectCnt;
				for (i = 1; i <= nn; i++) {
					qObject = qObj.named('qObject' + i);
					qObjectAttrs = qObj.named('qAttrs' + i);

					oGeonosis = GeonosisObj.get$();
					if (!!qObject) {
						oGeonosis.qData = qObject;
					}
					if (!!qObjectAttrs) {
						oGeonosis.qAttrs = qObjectAttrs;
					}
			//	_alert('oGeonosis #' + oGeonosis.id + '\n\noGeonosis.qData = [' + oGeonosis.qData + ']' + '\n\noGeonosis.qAttrs = [' + oGeonosis.qAttrs + ']');
			//	_alert('==============================================================\n\n');
				}

				displayObjectsBrowserGUI();
			}
		}
	}
}

function handleGetAttributesForOBJECT(qObj) {
	var i = -1;
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var _contextName = js_const_Objects_symbol;

	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...

	var qStats = qObj.named('qDataNum');
	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) {
		oParms = qObj.named('qParms');
		if (!!oParms) {
		}

		oAJAXEngine.setContextName(_contextName);

		// BEGIN: Scan for and handle any errors...
		for (i = 0; i < qObj.names.length; i++) {
			qData = qObj.named(qObj.names[i]);
			qData.iterateRecObjs(anyErrorRecords);
			if (bool_isAnyErrorRecords) {
				qData.iterateRecObjs(displayErrorRecord);
				break;
			}
		}
		// END! Scan for and handle any errors...

		if (!bool_isAnyErrorRecords) {
			qObjectAttrs = qObj.named('qAttrs');

			oGeonosis = GeonosisObj.get$();
			if (!!qObjectAttrs) {
				oGeonosis.qAttrs = qObjectAttrs;
			}
	//	_alert('oGeonosis #' + oGeonosis.id + '\n\noGeonosis.qData = [' + oGeonosis.qData + ']' + '\n\noGeonosis.qAttrs = [' + oGeonosis.qAttrs + ']');
	//	_alert('==============================================================\n\n');
		}
	}
	if (currentlySelectedObject_sel > -1) {
		var oSel = $('selection_objectName');
		if (!!oSel) {
			oSel.selectedIndex = currentlySelectedObject_sel;
			handle_objectName_onChange(oSel);
		}
	}
}

function processAddClassInputAction(id) {
	var i = -1;
	var kValuesCnt = 0;
	var iObj = -1;
	var currentNum = -1;
	var qString = '';
	var bool_hasAllValues = false;
	var qStr = cache_input_associations[id];

	for (i = 0; i < stack_addClass_inEdit.length; i++) {
		iObj = $(stack_addClass_inEdit[i]);
		if ( (!!iObj) && (iObj.value.trim().length > 0) ) {
			kValuesCnt++;
		}
		if (currentNum == -1) {
			currentNum = ((stack_addClass_inEdit[i].toUpperCase() == id.toUpperCase()) ? i : -1);
		}
	}

	if (kValuesCnt == stack_addClass_inEdit.length) {
		for (i = 0; i < stack_addClass_inEdit.length; i++) {
			iObj = $(stack_addClass_inEdit[i]);
			if (!!iObj) {
				iObj.style.border = 'thin solid green';
				var ar = iObj.id.split('_');
				qString += '&' + ar[ar.length - 1] + '=' + escape(iObj.value);
			}
		}

		queueUp_AJAX_Sessions(js_const_addClassDef_symbol, qString);
	} else if (currentNum > -1) {
		if (currentNum == (stack_addClass_inEdit.length - 1)) {
			currentNum = 0;
		} else {
			currentNum++;
		}
		iObj = $(stack_addClass_inEdit[currentNum]);
		if (!!iObj) {
			setFocusSafely(iObj);
		}
	}
}

function performShowAddClassPanel() {
	var cObj = $('div_addClass_panel');
	if (!!cObj) {
		cObj.style.display = const_inline_style;
	}
	var iObj = $('input_addClass_className');
	if (!!iObj) {
		setFocusSafely(iObj);
	}
}

function performConfirmDropClassDialog() {
	var sel = -1;
	var cObj = $('selection_className');
	if (!!cObj) {
		if ((sel = cObj.selectedIndex) > -1) {
			var className = cObj.options[sel].text;
			var classID = cObj.options[sel].value;
			var xBool = confirm('Are you sure you want to drop the Class known as "' + className + '" ?');
			if (xBool) {
				queueUp_AJAX_Sessions(js_const_dropClassDef_symbol, '&objectClassID=' + classID.URLEncode());
			}
		}
	}
}
// +++
function handle_onChange_objects2Link(oSel) {
	var i = -1;
	var sParms = '';
	var selectedOptions = [];
	var oBtn = $('btn_objectLink_add');
	if ( (!!oSel) && (!!oBtn) ) {
		for (i = 0; i < oSel.options.length; i++) {
			if (oSel.options[i].selected) {
				selectedOptions.push(oSel.options[i]);
			}
		}
		if (selectedOptions.length > 2) {
			var oO = selectedOptions.pop();
			oO.selected = false;
			oBtn.disabled = true;
			alert('Choose only 2 Objects to Link at a time.');
		} else {
			oBtn.disabled = ((selectedOptions.length == 2) ? false : true);
		}
		if (selectedOptions.length == 2) {
			for (i = 0; i < selectedOptions.length; i++) {
				sParms += '&OBJECTID' + (i + 1) + '=' + selectedOptions[i].value.URLEncode();
		//		_alert('selectedOptions[' + i + '].text = [' + selectedOptions[i].text + ']' + ', selectedOptions[' + i + '].value = [' + selectedOptions[i].value + ']');
			}
		//	_alert('sParms = [' + sParms + ']');
			queueUp_AJAX_Sessions(js_const_checkLinkedObjects_symbol, sParms);
		}
	}
}

function performLinkObjects() {
	var i = -1;
	var selectedOptions = [];
	var oSel = $('selection_objects2Link');
	var oBtn = $('btn_objectLink_add');
	if ( (!!oSel) && (!!oBtn) ) {
		for (i = 0; i < oSel.options.length; i++) {
			if (oSel.options[i].selected) {
				selectedOptions.push(oSel.options[i]);
			}
		}
		if (selectedOptions.length == 2) {
			removeCurrentSelectionOptionsById(oSel.id);
			_db = '';
			for (i = 0; i < selectedOptions.length; i++) {
				_db += 'selectedOptions[' + i + '].text = [' + selectedOptions[i].text + ']' + ', selectedOptions[' + i + '].value = [' + selectedOptions[i].value + ']\n';
			}
			oBtn.disabled = true;
			alert('Linking\n' + _db);
		}
	}
}

function handle_onChange_linkedObjects(oSel) {
	var sel = -1;
	if (!!oSel) {
		sel = oSel.selectedIndex;
	//	_alert('oSel = [' + oSel + ']'); +++ code the deletion of object links here...
	}
}

function displayClassesBrowser(qObj) {
	var i = -1;
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var oGeonosis = -1;
	var _contextName = js_const_Objects_symbol;
	var _html = '';
	var width_of_class_panel = 200;
	
	function displayClassBrowser(qO, nR, bool_justRefresh) {
		var html = '';
		var sel = -1;
		
		bool_justRefresh = ((bool_justRefresh == true) ? bool_justRefresh : false);
		
		function displayRecord(_ri, _dict, _rowCntName) {
			var i = -1;
			var _OBJECTCLASSID = '';
			var _CLASSNAME = '';
			var _rowCnt = -1;
			
			try {
				_OBJECTCLASSID = _dict.getValueFor('OBJECTCLASSID');
				_CLASSNAME = _dict.getValueFor('CLASSNAME');
				_rowCnt = _dict.getValueFor(_rowCntName);
			} catch(e) {
			} finally {
			}

			if (bool_justRefresh) {
				appendSelectionOptionByID('selection_className', _CLASSNAME, _OBJECTCLASSID);
			} else {
				html += '<option value="' + _OBJECTCLASSID + '">' + _CLASSNAME + '</option>';
			}
		};

		function displayMetaDataRecord(_ri, _dict, _rowCntName) {
			var i = -1;
			var _COLUMN_NAME = '';
			var _COLUMN_SIZE = '';
			var _TYPE_NAME = '';
			var _rowCnt = -1;
			var idName = '';
			
			try {
				_COLUMN_NAME = _dict.getValueFor('COLUMN_NAME');
				_COLUMN_SIZE = parseInt(_dict.getValueFor('COLUMN_SIZE'));
				_TYPE_NAME = _dict.getValueFor('TYPE_NAME');
				_rowCnt = parseInt(_dict.getValueFor(_rowCntName));
			} catch(e) {
			} finally {
			}

			if (_TYPE_NAME.toUpperCase().indexOf(' identity'.toUpperCase()) == -1) {
				idName = 'input_addClass_' + _COLUMN_NAME;
				if (bool_justRefresh) {
					var oO = $(idName);
					if (!!oO) {
						oO.style.border = 'thin solid silver';
					}
				} else {
					html += '<tr>';
					html += '<td bgcolor="silver"><span class="boldPromptTextClass">' + _COLUMN_NAME + '</span></td>';
					html += '<td><input id="' + idName + '" class="classDefEntryClass" size="' + ((_COLUMN_SIZE > 25) ? 25 : _COLUMN_SIZE) + '" maxlength="' + _COLUMN_SIZE + '" style="width: ' + (width_of_class_panel - 60) + 'px;" onkeydown="if (event.keyCode == 13) { processAddClassInputAction(this.id); }; return true;"></td>';
					html += '</tr>';
				}
				cache_input_associations[idName] = _dict.asQueryString();
				stack_addClass_inEdit.push(idName);
			}
		};
		
		var qData = qO.named('qData' + nR);
		if (!!qData) {
			if (bool_justRefresh) {
				sel = currentSelectionByID('selection_className');
				removeAllSelectionOptionsByID('selection_className');
				qData.iterateRecObjs(anyErrorRecords);
				if (!bool_isAnyErrorRecords) {
					qData.iterateRecObjs(displayRecord);
				}
				if (sel != -1) setSelectionByID('selection_className', sel);
				adjustSelectionSizeByID('selection_className');

				objectClassDefinitionsMetDataStack[0].iterateRecObjs(displayMetaDataRecord);
			} else {
				var _btnHtmlL = '<button id="btn_classes_remove" disabled class="buttonClass" title="Click this button to remove the selected Class." onclick="performConfirmDropClassDialog(); return false;">[-]</button>';
				var _btnHtmlR = '<button id="btn_classes_add" class="buttonClass" title="Click this button to add a new Class." onclick="performShowAddClassPanel(); return false;">[+]</button>';
				html += beginTable(_btnHtmlL + '&nbsp;' + 'Classes' + '&nbsp;' + _btnHtmlR, '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
				html += '<tr>' + '<td>';
	
				html += '<select id="selection_className" size="' + Math.min(qData.recordCount(), 20) + '" class="boldPromptTextClass" style="width: ' + width_of_class_panel + 'px;" onchange="handle_className_onChange(this); return true;">';
	
				qData.iterateRecObjs(anyErrorRecords);
				if (!bool_isAnyErrorRecords) {
					qData.iterateRecObjs(displayRecord);
				}
	
				html += '</select>';
				
				html += '</td>';

				html += '<td align="left" valign="top">';
				
				html += '</td>';

				html += '</tr>';
				
				html += endTable();
	
				html += '<div id="div_addClass_panel" style="display: none;">';
				html += beginTable('Add a Class', '&bool=' + 'includeDismissButton=true'.URLEncode() + '&div=' + 'dismissDiv=div_addClass_panel'.URLEncode() + '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
				html += '<tr>' + '<td>';
				html += beginTable();
	
				objectClassDefinitionsMetDataStack[0].iterateRecObjs(displayMetaDataRecord);
	
				html += endTable();
				html += '</td>' + '</tr>';
				html += endTable();
				html += '</div>';
			}
		}
		return html;
	}

	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...

	var qStats = qObj.named('qDataNum');
	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) {
		var bcAR = [];
		oParms = qObj.named('qParms');
		if (!!oParms) {
			var bc = oParms.getValueFor('breadCrumbs');
			if (!!bc) {
				if (typeof bc == const_object_symbol) {
					bc = bc[0];
				}
				bc = ((!!bc) ? bc.URLDecode() : '').URLDecode();
				if (bc.length > 0) {
					bcAR = bc.split(',');
				}
			}
		}

		oAJAXEngine.setContextName(_contextName);

		qData = qObj.named('qData1');
		qData.iterateRecObjs(anyErrorRecords);
		if (!bool_isAnyErrorRecords) {
			var qSchema = qObj.named('qMetaDataForObjectClassDefs');
			if (!!qSchema) {
				objectClassDefinitionsMetDataStack.push(qSchema);
			}

			stack_addClass_inEdit = []; // initialize this or bad evil things will happen...
			
			var cObj = $('div_contentHome');
			if (!!cObj) {
				cObj.style.width = clientWid$();
				cObj.style.height = clientHt$();
	
				if (cObj.innerHTML.length == 0) {
					_html += beginTable();
					_html += '<tr>';
					_html += '<td align="left" valign="top" width="' + width_of_class_panel + '">';
					_html += displayClassBrowser(qObj, 1); // the dat record of interest is always the first one...
					_html += '</td>';
					_html += '<td align="left" valign="top">';
					_html += '<div id="div_objectsBrowser">';
					_html += '&nbsp;&nbsp;&nbsp;&nbsp;<b>Objects</b>';
					_html += '</div>';
					_html += '</td>';
					_html += '<td align="left" valign="top">';
					_html += '<div id="div_attrsBrowser">';
					_html += '&nbsp;&nbsp;&nbsp;&nbsp;<b>Attrs</b>';
					_html += '</div>';
					_html += '</td>';

					_html += '<td align="left" valign="top">';

					_html += beginTable();
					_html += '<tr>';
					_html += '<td>';

					// +++
					_html += '<div id="div_objectsToLinkBrowser">';
					var width_of_objectLinker = '200';
					var _btnHtmlR = '&nbsp;<button id="btn_objectLink_add" disabled class="buttonClass" title="Click this button to link the two selected objects." onclick="performLinkObjects(); return false;">[+]</button>';
					_html += beginTable('Objects to Link' + _btnHtmlR, '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
					_html += '<tr>' + '<td>';
					_html += '<select id="selection_objects2Link" multiple size="' + Math.min(2, 20) + '" class="boldPromptTextClass" style="width: ' + width_of_objectLinker + 'px;" onchange="handle_onChange_objects2Link(this); return true;">';
					_html += '</select>';
					_html += '</td>' + '</tr>';
					_html += endTable();
					_html += '</div>';
					// +++

					_html += '</td>';
					_html += '</tr>';

					_html += '<tr>';
					_html += '<td>';

					// +++
					_html += '<div id="div_objectsLinkedBrowser">';
				//	var _btnHtmlL = '<button id="btn_attr_remove" disabled class="buttonClass" title="Click this button to remove the selected Attribute." onclick="performConfirmDropAttributeDialog(); return false;">[-]</button>&nbsp;';
					_html += beginTable('Linked Objects', '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
					_html += '<tr>' + '<td>';
					_html += '<select id="selection_linkedObjects" multiple size="' + Math.min(2, 20) + '" class="boldPromptTextClass" style="width: ' + width_of_objectLinker + 'px;" onchange="handle_onChange_linkedObjects(this); return true;">';
					_html += '</select>';
					_html += '</td>' + '</tr>';
					_html += endTable();
					_html += '</div>';
					// +++
					
					_html += '</td>';
					_html += '</tr>';
					
					_html += endTable();
					
					_html += '<div id="div_abstract_Drag-n-Drop_Container" style="position: absolute; top: 0px; left: 0px; width: 0px; height: 0px; display: none;">';
					_html += '</div>';
					
					_html += '</td>';

					_html += '</tr>';
		
					_html += '<tr>';
					_html += '<td colspan="2" align="right" valign="top">';
					_html += '<div id="div_objectBrowser">';
					_html += '&nbsp;&nbsp;&nbsp;&nbsp;<b>Object</b>';
					_html += '</div>';
					_html += '</td>';
					_html += '<td>';
					_html += '</td>';

					_html += '</tr>';
					_html += endTable();
				//	flushCache$(cObj);
					cObj.innerHTML = _html;
				} else {
					displayClassBrowser(qObj, 1, true);
				}
				
				if (bcAR.length > 0) {
					var _ar = [];
					for (i = 0; i < bcAR.length; i++) {
						_ar = bcAR[i].split('|');
						if (_ar.length > 1) {
							var xS = '-1';
							xS = _ar[0] + '("' + _ar[1] + ((_ar.length == 3) ? '"' + ',"' + _ar[2] : '') + '")';
							
							eval(xS);
						}
					}
				}
			}
		} else {
			qData.iterateRecObjs(displayErrorRecord);
		}
	}
}

function displayObjectsBrowserEditCompletion(qObj) {
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var _contextName = js_const_Objects_symbol;
	
	var sCmd = '';
	
	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...

	var qStats = qObj.named('qDataNum');
	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) {
		oParms = qObj.named('qParms');
		if (!!oParms) {
			sCmd = ((typeof (sCmd = oParms.getValueFor('sCmd')) == const_object_symbol) ? sCmd.pop() : sCmd);
		}

		oAJAXEngine.setContextName(_contextName);

		qData = qObj.named('qData1');
		qData.iterateRecObjs(anyErrorRecords);

		if (!bool_isAnyErrorRecords) {
			// update the client based data elements
			// remove the entry field and place the data from the entry field into the GUI
			var cObj = $('selection_className');
			var oObj = $('selection_objectName');
			if ( (!!cObj) && (!!oObj) ) {
				var cSel = cObj.selectedIndex;
				var oSel = oObj.selectedIndex;
				if ( (cSel > -1) && (oSel > -1) ) {
					var cDict = GeonosisObj.searchInstancesForClassName(cObj.options[cSel].text);
					var _OBJECTNAME = cDict.getValueFor('OBJECTNAME');
					var _ID = cDict.getValueFor('ID');
					var oDict = -1;
					var bool_usingObjectData = false;

					if (sCmd.toUpperCase() == js_const_chgAttrsForObject_symbol.toUpperCase()) {
						oDict = GeonosisObj.searchInstancesForObjectID(oObj.options[oSel].value);
					} else if (sCmd.toUpperCase() == js_const_chgDataForObject_symbol.toUpperCase()) {
						bool_usingObjectData = true;
						oDict = GeonosisObj.searchInstancesForClassName(cObj.options[cSel].text);
					}
					
					var bcAR = stack_current_span_inEdit[stack_current_span_inEdit.length - 1];
					var eAR = bcAR.split('_');

					if ( (eAR.length == 3) || (eAR.length == 4) ) {
						var eKey = -1;
						var eNum = -1;
						var eDatum = -1;
						
						if (eAR.length == 4) {
							eKey = eAR[eAR.length - 2];
							eNum = parseInt(eAR[eAR.length - 1]);
							eDatum = oDict.getValueFor(eKey)[eNum];
						} else if (eAR.length == 3) {
							var sel = -1;
							var _quickBrowseObjName = 'selection_' + eAR[1] + '_browser';
							qbObj = $(_quickBrowseObjName);
							if (!!qbObj) {
								sel = qbObj.selectedIndex;
							}

							eKey = eAR[eAR.length - 1];
							eNum = sel;
							eDatum = oDict.getValueFor(eKey)[eNum];
							
							if (sel > -1) {
								var datumDict = DictionaryObj.get$(qbObj.options[sel].value);
								var colName = qData.getValueFor('UPDATEDCOLUMN');
								var colVal = qData.getValueFor('UPDATEDCOLUMNVALUE');
								datumDict.put(colName, colVal);

								qbObj.options[sel] = new Option( qbObj.options[sel].text, datumDict.asQueryString());
								qbObj.selectedIndex = sel;
							}
						}
						
						var eObj = $(bcAR.asAltIDUsing('input'));
						var gObj = $(bcAR);

						if ( (!!eObj) && (!!gObj) ) {
							eVal = eObj.value;

							if ( (sCmd.toUpperCase() == js_const_chgDataForObject_symbol.toUpperCase()) && (cObj.id.toUpperCase().indexOf(eKey.toUpperCase()) != -1) ) {
								oObj.options[oSel].text = eVal;
							}

							GeonosisObj.searchInstancesForObjects(eVal, eKey, bool_usingObjectData, eNum);

							flushCache$(gObj);
							gObj.innerHTML = eVal;

							popCurrentlyEditedInput();
							
							if ( (sCmd.toUpperCase() == js_const_chgDataForObject_symbol.toUpperCase()) && (cObj.id.toUpperCase().indexOf(eKey.toUpperCase()) != -1) ) {
								cObj.options[cSel].text = eVal;
							}
						}
					}
					DictionaryObj.remove$(cDict.id);
					DictionaryObj.remove$(oDict.id);
				}
			}
		} else {
			qData.iterateRecObjs(displayErrorRecord);
		}
	}
}

function refreshAttributesBrowser() {
	var selObjName = -1;
	var cObj = $('selection_objectName');
	if (!!cObj) {
		selObjName = cObj.selectedIndex;
	}

	var cObj = $('selection_className');
	if (!!cObj) {
		var sel = cObj.selectedIndex;
		if (sel > -1) {
			cObj.selectedIndex = 0;
			handle_className_onChange(cObj);
			cObj.selectedIndex = sel;
			handle_className_onChange(cObj);
		}
	}
	cObj = $('selection_objectName');
	if (!!cObj) {
		cObj.selectedIndex = 0;
		handle_objectName_onChange(cObj);
		cObj.selectedIndex = selObjName;
		handle_objectName_onChange(cObj);
	}
}
// +++
function displayCheckedLinkedObjectsCompletion(qObj) {
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var aDict = -1;
	var i = -1;
	var j = -1;
	var _contextName = js_const_Objects_symbol;
	var argsDict = DictionaryObj.get$();

	function searchForArgRecs(_ri, _dict, _rowCntName) {
		var n = _dict.getValueFor('NAME');
		var v = _dict.getValueFor('VAL');
		argsDict.push(n.trim(), v);
	};
	
	function dictFromRecord(_ri, _dict, _rowCntName) {
		var _HASLINKS = _dict.getValueFor('HASLINKS');
		if (_HASLINKS != null) {
			btn_objectLink_add.disabled = ((_HASLINKS.toUpperCase() == 'YES') ? true : false);
		//	aDict = DictionaryObj.get$(_dict.asQueryString());
		}
	}
	
	var sCmd = '';
	
	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...
//_alert('qObj = [' + qObj + ']');
//_alert('============================================================\n');
	var qStats = qObj.named('qDataNum');

	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) {
		oParms = qObj.named('qParms');
		if (!!oParms) {
			sCmd = ((typeof (sCmd = oParms.getValueFor('sCmd')) == const_object_symbol) ? sCmd.pop() : sCmd);
			oParms.iterateRecObjs(searchForArgRecs);
		}

		oAJAXEngine.setContextName(_contextName);

		for (i = 0; i < qObj.names.length; i++) {
			qData = qObj.named(qObj.names[i]);
		//	_alert('qObj.names[' + i + '] = [' + qObj.names[i] + ']');
			qData.iterateRecObjs(anyErrorRecords);
			if (bool_isAnyErrorRecords) {
				qData.iterateRecObjs(displayErrorRecord);
				break;
			}
			qData.iterateRecObjs(dictFromRecord);
		//	_alert('aDict = [' + aDict + ']');
		}
		//	_alert('argsDict = [' + argsDict + ']');
	}
}

function displayLinkedObjectsBrowserCompletion(qObj) {
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var aDict = -1;
	var i = -1;
	var j = -1;
	var _contextName = js_const_Objects_symbol;
	var linksDict = DictionaryObj.get$();
	var oSelLinkedObjects = $('selection_linkedObjects');
	var oSelObjects2Link = $('selection_Objects2Link');
	var argsDict = DictionaryObj.get$();

	function searchForArgRecs(_ri, _dict, _rowCntName) {
		var n = _dict.getValueFor('NAME');
		var v = _dict.getValueFor('VAL');
		argsDict.push(n.trim(), v);
	};
	
	function dictFromRecord(_ri, _dict, _rowCntName) {
		aDict = DictionaryObj.get$(_dict.asQueryString());
	}
	
	function handleLinkedObjectsRecords(_ri, _dict, _rowCntName) {
		var anID = _dict.getValueFor('ID');
		var anOBJID = _dict.getValueFor('OBJID');
		var anOWNERID = _dict.getValueFor('OWNERID');
		var anOWNEROBJECTCLASSNAME = _dict.getValueFor('OWNEROBJECTCLASSNAME');
		var anOWNEROBJECTNAME = _dict.getValueFor('OWNEROBJECTNAME');
		var aRELATEDID = _dict.getValueFor('RELATEDID');
		var aRELATEDOBJECTCLASSNAME = _dict.getValueFor('RELATEDOBJECTCLASSNAME');
		var aRELATEDOBJECTNAME = _dict.getValueFor('RELATEDOBJECTNAME');
		var txt = '';
		var val = anID + ',';
		var _id = linksDict.getValueFor(anID);
		
		if (_id == null) {
			if (anOBJID == anOWNERID) {
				txt = anOWNEROBJECTCLASSNAME + '::' + anOWNEROBJECTNAME + '-->' + aRELATEDOBJECTCLASSNAME + '::' + aRELATEDOBJECTNAME;
				val += anOWNERID + ',' + aRELATEDID;
			} else if (anOBJID == aRELATEDID) {
				txt = aRELATEDOBJECTCLASSNAME + '::' + aRELATEDOBJECTNAME + '-->' + anOWNEROBJECTCLASSNAME + '::' + anOWNEROBJECTNAME;
				val += aRELATEDID + ',' + anOWNERID;
			}
			linksDict.push(anID, txt);
			if ( (!!oSelLinkedObjects) && (!!oSelObjects2Link) ) {
				var i = -1;
		//		var _db = '';
				for (i = 0; i < oSelObjects2Link.options.length; i++) {
		//			_db += 'value = [' + oSelObjects2Link.options[i].value + ']' + ', text = [' + oSelObjects2Link.options[i].text + ']' + '\n';
					queueUp_AJAX_Sessions(js_const_getLinkedObjects_symbol, '&OBJECTID=' + oSelObjects2Link.options[i].value.URLEncode() + '&DONOTCLEARLINKEDOBJECTS=1');
				}
		//		_alert(_db);
				oSelLinkedObjects.options[oSelLinkedObjects.options.length] = new Option( txt, val);
				oSelLinkedObjects.style.width = Math.max((txt.length * 6), parseInt(oSelLinkedObjects.style.width)) + 'px';
			}
		}
	}
	
	var sCmd = '';
	
	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...
//_alert('qObj = [' + qObj + ']');
//_alert('============================================================\n');
	var qStats = qObj.named('qDataNum');

	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) {
		oParms = qObj.named('qParms');
		if (!!oParms) {
			sCmd = ((typeof (sCmd = oParms.getValueFor('sCmd')) == const_object_symbol) ? sCmd.pop() : sCmd);
			oParms.iterateRecObjs(searchForArgRecs);
		}

		oAJAXEngine.setContextName(_contextName);

		for (i = 0; i < qObj.names.length; i++) {
			qData = qObj.named(qObj.names[i]);
		//	_alert('qObj.names[' + i + '] = [' + qObj.names[i] + ']');
			qData.iterateRecObjs(anyErrorRecords);
			if (bool_isAnyErrorRecords) {
				qData.iterateRecObjs(displayErrorRecord);
				break;
			}
		}
		if (!!oSelLinkedObjects) {
		//	_alert('argsDict = [' + argsDict + ']');
			var bool = argsDict.getValueFor('DONOTCLEARLINKEDOBJECTS');
			if ( (bool == null) || (!bool) ) {
				while (oSelLinkedObjects.options.length > 0) {
					oSelLinkedObjects.options[0] = null;
				}
			}
		}
		qData = qObj.named('qGetLinkedObjects');
		if (!!qData) {
			qData.iterateRecObjs(handleLinkedObjectsRecords);
		}
				
		if (!bool_isAnyErrorRecords) {

		} else {
			qData.iterateRecObjs(displayErrorRecord);
		}
	}
}
// +++
function displayAddOrDropAttributeCompletion(qObj) {
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var aDict = -1;
	var i = -1;
	var j = -1;
	var _contextName = js_const_addAttribute_symbol;
	
	function dictFromRecord(_ri, _dict, _rowCntName) {
		aDict = DictionaryObj.get$(_dict.asQueryString());
	}
	
	var sCmd = '';
	
	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...
//_alert('qObj = [' + qObj + ']');
//_alert('============================================================\n');
	var qStats = qObj.named('qDataNum');

	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) {
		oParms = qObj.named('qParms');
		if (!!oParms) {
			sCmd = ((typeof (sCmd = oParms.getValueFor('sCmd')) == const_object_symbol) ? sCmd.pop() : sCmd);
		}

		oAJAXEngine.setContextName(_contextName);

		for (i = 0; i < qObj.names.length; i++) {
			qData = qObj.named(qObj.names[i]);
			qData.iterateRecObjs(anyErrorRecords);
			if (bool_isAnyErrorRecords) {
				qData.iterateRecObjs(displayErrorRecord);
				break;
			}
		}
		
		if (!bool_isAnyErrorRecords) {
			var cObj = $('div_addAttr_panel');
			if (!!cObj) {
				cObj.style.display = const_none_style;
			}
			refreshAttributesBrowser();
			
			btnObj = $('btn_attrs_add');
			if (!!btnObj) {
				btnObj.disabled = true;
			}
			
			btnObj = $('btn_attr_remove');
			if (!!btnObj) {
				btnObj.disabled = true;
			}
			
			var qbObj = $('selection_Attrs_browser');
			if (sCmd.toUpperCase() == js_const_dropAttribute_symbol.toUpperCase()) {
				if (!!qbObj) {
					var qbDict = -1;
					var qStatus = qObj.named('qStatus');
					var attrID = qStatus.getValueFor('ATTRID');
					j = -1;
					for (i = 0; i < qbObj.options.length; i++) {
						qbDict = DictionaryObj.get$(qbObj.options[i].value);
						if (qbDict.getValueFor('ID') == attrID) {
							qbObj.options[i] = null;
							j = i;
							break;
						}
					}
					qbObj.selectedIndex = j - 1;
				}
			} else if (sCmd.toUpperCase() == js_const_addAttribute_symbol.toUpperCase()) {
				if (!!qbObj) {
					qObj.named('qGetAttr').iterateRecObjs(dictFromRecord);
					qbObj.options[qbObj.options.length] = new Option( aDict.getValueFor('ATTRIBUTENAME'), aDict.asQueryString());
					qbObj.selectedIndex = qbObj.options.length - 1;
				}
			}

		} else {
			qData.iterateRecObjs(displayErrorRecord);
		}
	}
}

function displayAddOrDropObjectCompletion(qObj) {
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var _contextName = js_const_Objects_symbol;
	
	var sCmd = '';
	
	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...

	var qStats = qObj.named('qDataNum');

	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) {
		oParms = qObj.named('qParms');
		if (!!oParms) {
			sCmd = ((typeof (sCmd = oParms.getValueFor('sCmd')) == const_object_symbol) ? sCmd.pop() : sCmd);
		}

		oAJAXEngine.setContextName(_contextName);

		for (i = 0; i < qObj.names.length; i++) {
			qData = qObj.named(qObj.names[i]);
			qData.iterateRecObjs(anyErrorRecords);
			if (bool_isAnyErrorRecords) {
				qData.iterateRecObjs(displayErrorRecord);
				break;
			}
		}
		
		if (!bool_isAnyErrorRecords) {
			var cObj = $('div_addObject_panel');
			if (!!cObj) {
				cObj.style.display = const_none_style;
			}
			displayObjectsBrowser(qObj);
		} else {
			qData.iterateRecObjs(displayErrorRecord);
		}
	}
}

function displayAddOrDropClassDefCompletion(qObj) {
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var _contextName = js_const_Objects_symbol;
	
	var sCmd = '';
	
	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...

	var qStats = qObj.named('qDataNum');
	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) {
		oParms = qObj.named('qParms');
		if (!!oParms) {
			sCmd = ((typeof (sCmd = oParms.getValueFor('sCmd')) == const_object_symbol) ? sCmd.pop() : sCmd);
		}

		oAJAXEngine.setContextName(_contextName);

		qData = qObj.named('qData1');
		qData.iterateRecObjs(anyErrorRecords);
		if (!bool_isAnyErrorRecords) {
			var cObj = $('div_addClass_panel');
			if (!!cObj) {
				cObj.style.display = const_none_style;
			}
			var cObj = $('selection_className');
			if (!!cObj) {
				cObj.disabled = false;
			}
			displayClassesBrowser(qObj);
		} else {
			qData.iterateRecObjs(displayErrorRecord);
		}
	}
}
