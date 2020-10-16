function handleEmailNewsletters(qObj, nRecs, qStats, argsDict, qData1) {
	var _STATUSMSG = '';

	function searchForStatusRecs(_ri, _dict, _rowCntName) {
		_STATUSMSG = _dict.getValueFor('STATUSMSG');
		_STATUSMSG = ((_STATUSMSG == null) ? '' : _STATUSMSG);
	};

	nRecs = ((nRecs != null) ? nRecs : -1);
	if (!!qStats) {
		if (!!argsDict) {
			if (!!qData1) {
				qData1.iterateRecObjs(searchForStatusRecs);
				
				if (_STATUSMSG.length > 0) {
					ezAlert(_STATUSMSG);
				} else {
					ezAlertCODE(qData1)
				}
			} else {
				ezAlertError('Error - qData1 has an invalid value.');
			}

			ezDictObj.remove$(argsDict.id);
		} else {
			ezAlertError('Error - argsDict has an invalid value.');
		}
	} else {
		ezAlertError('Error - qStats has an invalid value.');
	}
}
