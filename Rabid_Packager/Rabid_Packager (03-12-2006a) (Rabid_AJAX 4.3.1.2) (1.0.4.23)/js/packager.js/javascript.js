var stack_allow_breadCrumbs = [];

function queueUp_AJAX_Sessions(sCmd, sArgsQueryString) {
	sArgsQueryString = ((!!sArgsQueryString) ? sArgsQueryString : '');
	switch (sCmd) {
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

var objectsMetaDataStack = [];
var objectAttributesMetaDataStack = [];

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
		var dict = DictionaryObj.getInstance(aSpec);
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
		DictionaryObj.removeInstance(dict.id);
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
		var dict = DictionaryObj.getInstance(aSpec);
		var ar = id.split('_');
		dict.put(ar[ar.length - 2], eObj.value);
		dict.push('_updatedColumn_', ar[ar.length - 2]);
		eObj.style.border = 'thin solid green';

		queueUp_AJAX_Sessions(((ar[1].toUpperCase() == 'Attrs'.toUpperCase()) ? js_const_chgAttrsForObject_symbol : js_const_chgDataForObject_symbol), dict.asQueryString());
		DictionaryObj.removeInstance(dict.id);
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
				_html += '<tr>';
				_html += '<td align="left" valign="top" bgcolor="silver">';
				_html += '<span class="boldPromptTextClass">' + aKey + '</span>';
				_html += '</td>';
				datum = d.getValueFor(_keys[i]);
				if ( (!!datum) && (typeof datum == const_object_symbol) ) {
					if ( (numCols == -1) && (datum.length > 0) ) {
						numCols = datum.length;
					}
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
	return _html;
}

function handle_objectName_onChange(cObj) {
	var _html = '';
	if (!!cObj) {
		dObj = $('div_attrsBrowser');
		if (!!dObj) {
			var sel = cObj.selectedIndex;
			if (sel > -1) {
				var aDict = GeonosisObj.searchInstancesForObjectID(cObj.options[sel].value);
				_html += beginTable('Attrs', '&table=' + 'border="1"'.URLEncode() + '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
				_html += displayDictForBrowser('Attrs', aDict);
				_html += endTable();

				if (dObj.innerHTML.length > 0) flushGUIObjectChildrenForObj(dObj);
				dObj.innerHTML = _html;

				oObj = $('div_objectBrowser');
				if (!!oObj) {
					var _aDict = GeonosisObj.searchInstancesForID(cObj.options[sel].value);

					_html = beginTable('Object: ' + cObj.options[sel].text, '&table=' + 'border="1"'.URLEncode() + '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
					_html += displayDictForBrowser('Objects', _aDict);
					_html += endTable();

					if (oObj.innerHTML.length > 0) flushGUIObjectChildrenForObj(oObj);
					oObj.innerHTML = _html;

					DictionaryObj.removeInstance(_aDict.id);
				}

				DictionaryObj.removeInstance(aDict.id);
			}
		}
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
	if ( (!!cObj) && (!!dObj) && (!!oObj) ) { // cObj.options[sel].value is the OBJECTCLASSID
		var sel = cObj.selectedIndex;
		if (sel > -1) {
			if (dObj.innerHTML.length > 0) flushGUIObjectChildrenForObj(dObj);
			dObj.innerHTML = '';
			if (oObj.innerHTML.length > 0) flushGUIObjectChildrenForObj(oObj);
			oObj.innerHTML = '';

			queueUp_AJAX_Sessions(js_const_getOBJECTS_symbol, '&CLASSNAME=' + cObj.options[sel].text.toString().URLEncode() + '&hasMetaData=' + (((objectsMetaDataStack.length > 0) && (objectAttributesMetaDataStack.length > 0)) ? 'true' : 'false').URLEncode());
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

function displayObjectsBrowserGUI() {
	var _html = '';
	var cObj = $('selection_className');
	var dObj = $('div_objectsBrowser');
	if ( (!!dObj) && (!!cObj) ) {
		var sel = cObj.selectedIndex;
		if (sel > -1) {
			var aDict = GeonosisObj.searchInstancesForClassName(cObj.options[sel].text);
			var _OBJECTNAME = aDict.getValueFor('OBJECTNAME');
			var _ID = aDict.getValueFor('ID');
			var oObj = -1;
			if ( (!!_OBJECTNAME) && (typeof _OBJECTNAME == const_object_symbol) && (!!_ID) && (typeof _ID == const_object_symbol) && (_OBJECTNAME.length == _ID.length) ) {
				_html += beginTable('Objects', '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
				_html += '<tr>' + '<td>';
	
				_html += '<select id="selection_objectName" size="' + Math.min(aDict.length(), 20) + '" class="boldPromptTextClass" style="width: 200px;" onchange="handle_objectName_onChange(this); return true;">';
	
				var btnObj = $('btn_classes_remove');
				if (!!btnObj) {
					btnObj.disabled = ((_OBJECTNAME.length > 0) ? true : false);
				}
				
				for (var i = 0; i < _OBJECTNAME.length; i++) {
					_html += '<option value="' + _ID[i] + '">' + _OBJECTNAME[i] + '</option>';
				}
//_alert('_OBJECTNAME.length = [' + _OBJECTNAME.length + ']');
//_alert('_OBJECTNAME = [' + _OBJECTNAME + ']');
				_html += '</select>';
				
				_html += '</td>' + '</tr>';
				_html += endTable();
			}
			if (dObj.innerHTML.length > 0) flushGUIObjectChildrenForObj(dObj);
			dObj.innerHTML = _html;
			
			DictionaryObj.removeInstance(aDict.id);
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
		for (i = 1; i <= nRecs; i++) {
			qData = qObj.named('qData' + i);

			qData.iterateRecObjs(anyErrorRecords);
			if (bool_isAnyErrorRecords) {
				qData.iterateRecObjs(displayErrorRecord);
				break;
			}
		}
		// END! Scan for and handle any errors...

		if (!bool_isAnyErrorRecords) {
			var qSchema = qObj.named('qData1');
			if (!!qSchema) {
				var qSchema_OBJECTSMETDATARECORD = qSchema.getValueFor('OBJECTSMETDATARECORD');
				if (typeof qSchema_OBJECTSMETDATARECORD == const_object_symbol) {
					qSchema_OBJECTSMETDATARECORD = qSchema_OBJECTSMETDATARECORD.pop();
				}
				if (qSchema_OBJECTSMETDATARECORD > -1) {
					objectsMetaDataStack.push(qObj.named('qData' + qSchema_OBJECTSMETDATARECORD));
				}
				var qSchema_OBJECTATTRIBUTESMETDATARECORD = qSchema.getValueFor('OBJECTATTRIBUTESMETDATARECORD');
				if (typeof qSchema_OBJECTATTRIBUTESMETDATARECORD == const_object_symbol) {
					qSchema_OBJECTATTRIBUTESMETDATARECORD = qSchema_OBJECTATTRIBUTESMETDATARECORD.pop();
				}
				if (qSchema_OBJECTATTRIBUTESMETDATARECORD > -1) {
					objectAttributesMetaDataStack.push(qObj.named('qData' + qSchema_OBJECTATTRIBUTESMETDATARECORD));
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

				GeonosisObj.removeInstances(); // do this because we also use this function to display data after editing actions that may change data...

				var nn = (((qSchema_OBJECTSMETDATARECORD > -1) && (qSchema_OBJECTATTRIBUTESMETDATARECORD > -1)) ? Math.min(qSchema_OBJECTSMETDATARECORD, qSchema_OBJECTATTRIBUTESMETDATARECORD) : nRecs);
				for (i = 2; i < nn; i += 2) {
					qObject = qObj.named('qData' + i);
					qObjectAttrs = qObj.named('qData' + (i + 1));

					oGeonosis = GeonosisObj.getInstance();
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

function displayClassesBrowser(qObj) {
	var i = -1;
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var oGeonosis = -1;
	var _contextName = js_const_Objects_symbol;
	var _html = '';
	var width_of_class_panel = 200;
	
	function displayClassBrowser(qO, nR) {
		var _html = '';
		
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

			_html += '<option value="' + _OBJECTCLASSID + '">' + _CLASSNAME + '</option>';
		};

		var qData = qO.named('qData' + nR);
		if (!!qData) {
			var _btnHtmlL = '<button id="btn_classes_remove" disabled class="buttonClass" title="Click this button to remove the selected Class." onclick="alert(111); return false;">[-]</button>';
			var _btnHtmlR = '<button id="btn_classes_add" class="buttonClass" title="Click this button to add a new Class." onclick="alert(222); return false;">[+]</button>';
			_html += beginTable(_btnHtmlL + '&nbsp;' + 'Classes' + '&nbsp;' + _btnHtmlR, '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
			_html += '<tr>' + '<td>';

			_html += '<select id="selection_className" size="' + Math.min(qData.recordCount(), 20) + '" class="boldPromptTextClass" style="width: ' + width_of_class_panel + 'px;" onchange="handle_className_onChange(this); return true;">';

			qData.iterateRecObjs(anyErrorRecords);
			if (!bool_isAnyErrorRecords) {
				qData.iterateRecObjs(displayRecord);
			}

			_html += '</select>';
			
			_html += '</td>' + '</tr>';
			_html += endTable();
		}
		return _html;
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
			var cObj = $('div_contentHome');
			if (!!cObj) {
				cObj.style.width = clientWidth();
				cObj.style.height = clientHeight();
	
				_html += beginTable();
				_html += '<tr>';
				_html += '<td align="left" valign="top" width="' + width_of_class_panel + '">';
				_html += displayClassBrowser(qObj, nRecs);
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
				_html += '</tr>';
	
				_html += '<tr>';
				_html += '<td colspan="2" align="right" valign="top">';
				_html += '<div id="div_objectBrowser">';
				_html += '&nbsp;&nbsp;&nbsp;&nbsp;<b>Object</b>';
				_html += '</div>';
				_html += '</td>';
				_html += '<td>';
				_html += '&nbsp;';
				_html += '</td>';
				_html += '</tr>';
				_html += endTable();
	
				if (cObj.innerHTML.length > 0) flushGUIObjectChildrenForObj(cObj);
				cObj.innerHTML = _html;
				
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
					if (eAR.length == 4) {
						var eKey = eAR[eAR.length - 2];
						var eNum = parseInt(eAR[eAR.length - 1]);
						var eDatum = oDict.getValueFor(eKey)[eNum];
						
						var eObj = $(bcAR.asAltIDUsing('input'));
						var gObj = $(bcAR);
						if ( (!!eObj) && (!!gObj) ) {
							eVal = eObj.value;
							oObj.options[oSel].text = eVal;

							GeonosisObj.searchInstancesForObjects(eVal, eKey, bool_usingObjectData, eNum);

							if (gObj.innerHTML.length > 0) flushGUIObjectChildrenForObj(gObj);
							gObj.innerHTML = eVal;

							popCurrentlyEditedInput();
							
							if ( (sCmd.toUpperCase() == js_const_chgDataForObject_symbol.toUpperCase()) && (cObj.id.toUpperCase().indexOf(eKey.toUpperCase()) != -1) ) {
								cObj.options[cSel].text = eVal;
							}
						}
					}
					DictionaryObj.removeInstance(cDict.id);
					DictionaryObj.removeInstance(oDict.id);
				}
			}
		} else {
			qData.iterateRecObjs(displayErrorRecord);
		}
	}
}

