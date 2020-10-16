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
	var nRecs = -1;
	var oParms = -1;
	var _spanName = js_const_getOBJECTS_symbol;

	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...

	_alert('global_dict = [' + global_dict + ']');
	
	var qStats = qObj.named('qDataNum');
	if (!!qStats) {
		nRecs = qStats.dataRec[1];
	}
	if (nRecs > 0) { // at present only the first data record is consumed...
		var qData = qObj.named('qData1');
		if (!!qData) {
			oParms = qObj.named('qParms');
			if (!!oParms) {
				// no parms are expected so doesn't matter if they arrived...
				_alert('oParms = [' + oParms + ']');

				oAJAXEngine.setContextName(_spanName);
			}
			_alert('qData = [' + qData + ']');
		}
	}
}
