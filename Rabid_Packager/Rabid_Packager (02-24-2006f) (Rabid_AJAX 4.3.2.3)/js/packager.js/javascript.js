function queueUp_AJAX_Sessions() {
	pQueryString = '';
	oAJAXEngine.addNamedContext('#const_emailTest_symbol#', pQueryString);
	doAJAX_func('performEmailTest', 'displayEMailTestResults(' + oAJAXEngine.js_global_varName + ')');
}

function displayEMailTestResults(qObj) {
	var nRecs = -1;
	var oParms = -1;
	var _spanName = '#const_emailTest_symbol#';

	global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...
	
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
			//	_alert(oParms);

				oAJAXEngine.setContextName(_spanName);
			}
			_alert(qData);
		}
	}
}
