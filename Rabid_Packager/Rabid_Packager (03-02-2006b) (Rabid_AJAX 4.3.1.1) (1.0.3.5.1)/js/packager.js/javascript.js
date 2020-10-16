function queueUp_AJAX_Sessions(sCmd, sArgsQueryString) {
	sArgsQueryString = ((!!sArgsQueryString) ? sArgsQueryString : '');
	switch (sCmd) {
		case js_const_chgDataForObject_symbol:
			pQueryString = '';
			try {
				oAJAXEngine.setContextName(js_const_getOBJECTS_symbol);
			} catch(ee) {
				jsErrorExplainer(ee, 'queueUp_AJAX_Sessions(sCmd = [' + sCmd + '])', true);
			} finally {
			}
		//	_alert('sArgsQueryString = [' + sArgsQueryString + ']');
			doAJAX_func('performSetGeonosisObject', 'displayObjectBrowser(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;

		case js_const_Objects_symbol:
			pQueryString = '';
			try {
				oAJAXEngine.addNamedContext(js_const_getOBJECTS_symbol, pQueryString);
			} catch(ee) {
				jsErrorExplainer(ee, 'queueUp_AJAX_Sessions(sCmd = [' + sCmd + '])', true);
			} finally {
			}
			doAJAX_func('performGetGeonosisObjects', 'displayObjectBrowser(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
		break;
	}
}

var stack_current_span_inEdit = [];

var stack_breadCrumbs = [];

function handleEditableGrid_onClick(cObj, qStringEnc) {
	// ID is always the key for the object's data being edited...
	if (!!cObj) {
		var aSpec = qStringEnc.URLDecode();
		var dict = DictionaryObj.getInstance(aSpec);
		var dObj = $(cObj.id.asAltIDUsing('div'));
		var eObj = $(cObj.id.asAltIDUsing('input'));
		if ( (!!dObj) && (!!eObj) ) {
			if (stack_current_span_inEdit.length > 0) {
				var pID = stack_current_span_inEdit.pop();
				var p_cObj = $(pID);
				var p_dObj = $(pID.asAltIDUsing('div'));
				if ( (!!p_cObj) && (!!p_dObj) ) {
					p_dObj.style.display = const_none_style;
					p_cObj.style.display = const_inline_style;
				}
			}
			eObj.value = cObj.innerHTML.stripHTML();
			dObj.style.display = const_inline_style;
			cObj.style.display = const_none_style;
			stack_current_span_inEdit.push(cObj.id);
		}
	//	_alert('handleEditableGrid_onClick(id = [' + cObj.id + '], ' + cObj.innerHTML + ')' + ', dict = [' + dict + ']' + '\n' + 'aSpec = [' + aSpec + ']');
		DictionaryObj.removeInstance(dict.id);
	}
}

function processEditableGridInputAction(id, qStringEnc) {
	// ID is always the key for the object's data being edited...
	var cObj = $(id.asAltIDUsing('span'));
	var dObj = $(id.asAltIDUsing('div'));
	var eObj = $(id);
	if ( (!!cObj) && (!!dObj) && (!!eObj) ) {
		var aSpec = qStringEnc.URLDecode();
		var dict = DictionaryObj.getInstance(aSpec);
		var ar = id.split('_');
		dict.put(ar[ar.length - 1], eObj.value);
		eObj.style.border = 'thin solid green';
		queueUp_AJAX_Sessions(js_const_chgDataForObject_symbol, dict.asQueryString() + '&breadCrumbs=' + stack_breadCrumbs.toString().URLEncode());
	//	_alert('processEditableGridInputAction(id = [' + id + '])' + ', dict = [' + dict + ']');
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
							_html += '<td id="td_' + objType + '_' + aKey + '" align="left" valign="top">';
							_html += '<span id="span_' + objType + '_' + aKey + '" class="textClass" style="display: inline; cursor:hand; cursor:pointer;" onclick="handleEditableGrid_onClick(this,\'' + qString.URLEncode() + '\'); return false;">' + ((datum[j].length == 0) ? '_' : '&nbsp;' + datum[j]) + '</span>';
							_html += '<div id="div_' + objType + '_' + aKey + '" style="display: none;">' + '<input id="input_' + objType + '_' + aKey + '" class="normalStatusBoldClass" size="30" maxlength="50" onkeydown="if (event.keyCode == 13) { processEditableGridInputAction(this.id,\'' + qString.URLEncode() + '\'); }; return true;">' + '</span>';
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
				stack_breadCrumbs.push('handle_objectName_onChange|' + cObj.id);
				
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

function handle_className_onChange(cObj) {
	var _html = '';
	if (!!cObj) {
		var dObj = $('div_objectsBrowser');
		if (!!dObj) {
			var sel = cObj.selectedIndex;
			if (sel > -1) {
				stack_breadCrumbs.push('handle_className_onChange|' + cObj.id);

				var aDict = GeonosisObj.searchInstancesForClassName(cObj.options[sel].text);
				var _OBJECTNAME = aDict.getValueFor('OBJECTNAME');
				var _ID = aDict.getValueFor('ID');
				var oObj = -1;
				if ( (!!_OBJECTNAME) && (typeof _OBJECTNAME == const_object_symbol) && (!!_ID) && (typeof _ID == const_object_symbol) && (_OBJECTNAME.length == _ID.length) ) {
					_html += beginTable('Objects', '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
					_html += '<tr>' + '<td>';
		
					_html += '<select id="selection_className" size="' + Math.min(aDict.length(), 20) + '" class="boldPromptTextClass" style="width: 200px;" onchange="handle_objectName_onChange(this); return true;">';

					for (var i = 0; i < _OBJECTNAME.length; i++) {
						_html += '<option value="' + _ID[i] + '">' + _OBJECTNAME[i] + '</option>';
					}
							
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
}

var bool_isAnyErrorRecords = -1;
var bool_isAnyPKErrorRecords = -1;

function displayObjectBrowser(qObj) {
	var i = -1;
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var oGeonosis = -1;
	var _contextName = js_const_getOBJECTS_symbol;
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
			_html += beginTable('Classes', '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
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
		oParms = qObj.named('qParms');
		if (!!oParms) {
		//	_alert('oParms = [' + oParms + ']');
		//	_alert('==============================================================\n\n');
		}

		oAJAXEngine.setContextName(_contextName);

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
		}

		GeonosisObj.removeInstances(); // do this because we also use this function to display data after editing actions that may change data...
		
		for (i = 1; i <= (nRecs - 1); i += 2) {
			oGeonosis = GeonosisObj.getInstance();
			qData = qObj.named('qData' + i);
			if (!!qData) {
				oGeonosis.qData = qData;
			}
			qData = qObj.named('qData' + (i + 1));
			if (!!qData) {
				oGeonosis.qAttrs = qData;
			}
		//	_alert('oGeonosis #' + oGeonosis.id + '\n\noGeonosis.qData = [' + oGeonosis.qData + ']' + '\n\noGeonosis.qAttrs = [' + oGeonosis.qAttrs + ']');
		//	_alert('==============================================================\n\n');
		}
	}
}