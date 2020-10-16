function queueUp_AJAX_Sessions(sCmd) {
//	_alert('js_const_Objects_symbol = [' + js_const_Objects_symbol + ']');
//	_alert('js_const_getOBJECTS_symbol = [' + js_const_getOBJECTS_symbol + ']');
	
	switch (sCmd) {
		case js_const_Objects_symbol:
			pQueryString = '';
			try {
				oAJAXEngine.addNamedContext(js_const_getOBJECTS_symbol, pQueryString);
			} catch(ee) {
				jsErrorExplainer(ee, 'queueUp_AJAX_Sessions(sCmd = [' + sCmd + '])', true);
			} finally {
			}
			doAJAX_func('performGetGeonosisObjects', 'displayObjectBrowser(' + oAJAXEngine.js_global_varName + ')');
		break;
	}
}

var bool_isAnyErrorRecords = -1;
var bool_isAnyPKErrorRecords = -1;

function handle_className_onChange(cObj) {
	if (!!cObj) {
		var sel = cObj.selectedIndex;
		if (sel > -1) {
			_alert('sel = [' + sel + ']');
			_alert('value = [' + cObj.options[sel].value + ']');
			_alert('text = [' + cObj.options[sel].text + ']');
		}
	}
}

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

//	_alert('global_dict = [' + global_dict + ']');
//	_alert('==============================================================\n\n');

//	_alert('qObj = [' + qObj + ']');
	
	var qStats = qObj.named('qDataNum');
	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
//	_alert('nRecs = [' + nRecs + ']');
//	_alert('==============================================================\n\n');
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
			if (cObj.innerHTML.length > 0) flushGUIObjectChildrenForObj(cObj);
			_html += beginTable();
			_html += '<tr>';
			_html += '<td width="' + width_of_class_panel + '">';
			_html += displayClassBrowser(qObj, nRecs);
			_html += '</td>';
			_html += '<td>';
			_html += '<b>Objects</b>';
			_html += '</td>';
			_html += '<td>';
			_html += '<b>Attrs</b>';
			_html += '</td>';
			_html += '</tr>';
			_html += endTable();
		//	_alert(_html);
			cObj.innerHTML = _html;
		}

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
