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

function displayObjectBrowser(qObj) {
	var i = -1;
	var qData = -1;
	var nRecs = -1;
	var oParms = -1;
	var _contextName = js_const_getOBJECTS_symbol;

	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...

	_alert('global_dict = [' + global_dict + ']');
	_alert('==============================================================\n\n');

//	_alert('qObj = [' + qObj + ']');
	
	var qStats = qObj.named('qDataNum');
	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	_alert('nRecs = [' + nRecs + ']');
	_alert('==============================================================\n\n');
	if (nRecs > 0) {
		oParms = qObj.named('qParms');
		if (!!oParms) {
			_alert('oParms = [' + oParms + ']');
			_alert('==============================================================\n\n');
		}

		oAJAXEngine.setContextName(_contextName);
		for (i = 1; i <= nRecs; i++) {
			qData = qObj.named('qData' + i);
			if (!!qData) {
				_alert('qData' + i + ' = [' + qData + ']');
				_alert('==============================================================\n\n');
			}
		}
	}
}
