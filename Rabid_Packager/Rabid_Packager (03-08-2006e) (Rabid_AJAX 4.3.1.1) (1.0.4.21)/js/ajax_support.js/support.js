var bool_isAnyErrorRecords = -1;
var bool_isAnyPKErrorRecords = -1;

function _anyErrorRecords(_ri, _dict, boolShowError) {
	var errorMsg = '';
	var isPKerror = '';
	
	boolShowError = ((boolShowError == true) ? boolShowError : false);
	
	try {
		errorMsg = _dict.getValueFor('ERRORMSG');
		isPKerror = _dict.getValueFor('ISPKVIOLATION');
	} catch(e) {
	} finally {
	}

	bool_isAnyErrorRecords = ( (!!errorMsg) && (errorMsg.length > 0) );
	bool_isAnyPKErrorRecords = ( (!!isPKerror) && (isPKerror.length > 0) );

	s_explainError = '';

	if ( (bool_isAnyErrorRecords) || (bool_isAnyPKErrorRecords) ) {
		if (boolShowError) {
			var _EXPLAINERROR = _dict.getValueFor('EXPLAINERROR');
			var _MOREERRORMSG = _dict.getValueFor('MOREERRORMSG');
			_alertError(unescape(errorMsg) + '\n\n' + unescape(_EXPLAINERROR) + '\n\n' + unescape(_MOREERRORMSG));
		} else {
			try {
				s_explainError = errorMsg.stripHTML().stripSpacesBy2s().stripCrLfs().stripTabs(' ');
			} catch(e) {
			} finally {
			}
		}
	}
}

function anyErrorRecords(_ri, _dict, _rowCntName) {
	return _anyErrorRecords(_ri, _dict, false);
}

function displayErrorRecord(_ri, _dict, _rowCntName) {
	return _anyErrorRecords(_ri, _dict, true);
}

//document.write('<div id="div_errorHome" style="position: absolute; top: 200px; left: 0px; width: 990px; height: 400px;"></div>');
