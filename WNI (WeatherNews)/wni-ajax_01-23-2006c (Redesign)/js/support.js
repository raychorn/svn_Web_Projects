function isObjValidHTMLValueHolder(anObj) {
	var _retVal = false;

	if ( (anObj != null) && ((anObj.type == "text") || (anObj.type == "hidden") || (anObj.type == "textarea")) ) {
		_retVal = true;
	}
	
	return _retVal;
}
			
