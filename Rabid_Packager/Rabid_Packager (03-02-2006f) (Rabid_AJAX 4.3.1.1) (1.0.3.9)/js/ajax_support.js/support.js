function anyErrorRecords(_ri, _dict, _rowCntName) {
	var errorMsg = '';
	var isPKerror = '';
	
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
		try {
			s_explainError = _dict.getValueFor('ERRORMSG').stripHTML().stripSpacesBy2s().stripCrLfs().stripTabs(' ');
		} catch(e) {
		} finally {
		}
	}
}

