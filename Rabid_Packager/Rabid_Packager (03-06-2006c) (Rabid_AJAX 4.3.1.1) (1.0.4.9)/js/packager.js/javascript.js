function queueUp_AJAX_Sessions(sCmd, sArgsQueryString) {
	sArgsQueryString = ((!!sArgsQueryString) ? sArgsQueryString : '');
	switch (sCmd) {
		case js_const_chgDataForObject_symbol:
			pQueryString = '';
			oAJAXEngine.setContextName(js_const_Objects_symbol);
			doAJAX_func('performSetGeonosisObject', 'displayObjectBrowser(' + oAJAXEngine.js_global_varName + ')', sArgsQueryString);
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
var stack_breadCrumbs = [];

var objectsMetaDataStack = [];
var objectAttributesMetaDataStack = [];

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
			stack_breadCrumbs.push('_handleEditableGrid_onClick|' + cObj.id + '|' + aSpec);
		}
	//	_alert('handleEditableGrid_onClick(id = [' + cObj.id + '], ' + cObj.innerHTML + ')' + ', dict = [' + dict + ']' + '\n' + 'aSpec = [' + aSpec + ']');
		DictionaryObj.removeInstance(dict.id);
	}
}

function _handleEditableGrid_onClick(id, qStringEnc) {
	return handleEditableGrid_onClick($(id), qStringEnc);
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
				stack_breadCrumbs.push('_handle_objectName_onChange|' + cObj.id + '|' + sel);
				
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
//	_alert('_handle_objectName_onChange(id = [' + id + '], sel = [' + sel + '])' + ', cObj = [' + cObj + ']');
	if (!!cObj) {
		cObj.selectedIndex = sel;
		return handle_objectName_onChange(cObj);
	}
}

function handle_className_onChange(cObj) {
	var _html = '';
	if (!!cObj) {
		var dObj = $('div_objectsBrowser');
		if (!!dObj) {
			var sel = cObj.selectedIndex;
			if (sel > -1) {
				stack_breadCrumbs.push('_handle_className_onChange|' + cObj.id + '|' + sel);

				// cObj.options[sel].value is the OBJECTCLASSID
			//	_alert('handle_className_onChange() :: ' + 'text = [' + cObj.options[sel].text + ']' + ', value = [' + cObj.options[sel].value + ']');

				queueUp_AJAX_Sessions(js_const_getOBJECTS_symbol, '&CLASSNAME=' + cObj.options[sel].text.toString().URLEncode() + '&hasMetaData=' + (((objectsMetaDataStack.length > 0) && (objectAttributesMetaDataStack.length > 0)) ? 'true' : 'false').URLEncode());

				if (0) {
					var aDict = GeonosisObj.searchInstancesForClassName(cObj.options[sel].text);
					var _OBJECTNAME = aDict.getValueFor('OBJECTNAME');
					var _ID = aDict.getValueFor('ID');
					var oObj = -1;
					if ( (!!_OBJECTNAME) && (typeof _OBJECTNAME == const_object_symbol) && (!!_ID) && (typeof _ID == const_object_symbol) && (_OBJECTNAME.length == _ID.length) ) {
						_html += beginTable('Objects', '&tr=' + 'bgcolor="silver"'.URLEncode() + '&td=' + 'align="center"'.URLEncode() + '&span=' + 'class="boldPromptTextClass"'.URLEncode());
						_html += '<tr>' + '<td>';
			
						_html += '<select id="selection_objectName" size="' + Math.min(aDict.length(), 20) + '" class="boldPromptTextClass" style="width: 200px;" onchange="handle_objectName_onChange(this); return true;">';
	
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
}

function _handle_className_onChange(id, sel) {
	var cObj = $(id);
	if (!!cObj) {
		cObj.selectedIndex = sel;
		return handle_className_onChange(cObj);
	}
}

function displayObjectsBrowser(qObj) {
	var i = -1;
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var _contextName = js_const_Objects_symbol;

	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...

//	_alert('qObj = [' + qObj + ']');
//	_alert('==============================================================\n\n');

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
			//	_alert('qSchema = [' + qSchema + ']');
			//	_alert('==============================================================\n\n');

				GeonosisObj.removeInstances(); // do this because we also use this function to display data after editing actions that may change data...

				var nn = Math.min(qSchema_OBJECTSMETDATARECORD, qSchema_OBJECTATTRIBUTESMETDATARECORD);
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
					_alert('oGeonosis #' + oGeonosis.id + '\n\noGeonosis.qData = [' + oGeonosis.qData + ']' + '\n\noGeonosis.qAttrs = [' + oGeonosis.qAttrs + ']');
					_alert('==============================================================\n\n');
				}
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
							
							try {
								eval(xS);
							} catch(ee) {
								_alert(jsErrorExplainer(ee, '333'));
							} finally {
							}
						}
					}
				}
			}
		} else {
			qData.iterateRecObjs(displayErrorRecord);
		}
	}
}
