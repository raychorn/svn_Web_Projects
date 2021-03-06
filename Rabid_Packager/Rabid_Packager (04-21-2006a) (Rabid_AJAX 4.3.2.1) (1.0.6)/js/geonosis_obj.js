/*
 geonosis_obj.js -- GeonosisObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

GeonosisObj = function(id){
	this.id = id;				// the id is the position within the global GeonosisObj.instances array
};

GeonosisObj.instances = [];

GeonosisObj.getInstance = function() {
	// the object.id is the position within the array that holds onto the objects...
	var instance = GeonosisObj.instances[GeonosisObj.instances.length];
	if(instance == null) {
		instance = GeonosisObj.instances[GeonosisObj.instances.length] = new GeonosisObj(GeonosisObj.instances.length);
	}
	return instance;
};

GeonosisObj.i = function() {
	return GeonosisObj.getInstance(); // this is an alias that aids the transmission of code from the server to the client...
};

GeonosisObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < GeonosisObj.instances.length) ) {
		var instance = GeonosisObj.instances[id];
		if (!!instance) {
			GeonosisObj.instances[id] = object_destructor(instance);
			ret_val = (GeonosisObj.instances[id] == null);
		}
	}
	return ret_val;
};

GeonosisObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < GeonosisObj.instances.length; i++) {
		GeonosisObj.removeInstance(i);
	}
	GeonosisObj.instances = [];
	return ret_val;
};

GeonosisObj.searchInstancesForObjects = function(datum, selector, use_qData, recNum) {
	var ar = [];
	var oO = -1;
	use_qData = ((use_qData == true) ? use_qData : false);

	function searchRecord(_ri, _dict, _rowCntName) {
		var i = -1;
		var _data = '';
		
		try {
			_data = _dict.getValueFor(selector);
		} catch(e) {
		} finally {
		}

		if (_data == datum) {
			ar.push(_dict.asQueryString());
		}
	};

	var i = -1;
//	_alert('\n(111.0) use_qData = [' + use_qData + ']');
	for (i = 0; i < GeonosisObj.instances.length; i++) {
	//	_alert('\n(111.1) GeonosisObj.instances[i].qData = [' + GeonosisObj.instances[i].qData + ']');
		oO = ((use_qData) ? GeonosisObj.instances[i].qData : GeonosisObj.instances[i].qAttrs);
		oO.iterateRecObjs(anyErrorRecords);
		if (!bool_isAnyErrorRecords) {
			if (recNum != null) {
			//	_alert('(+++) recNum = [' + recNum + ']');
			//	_alert('(+++) selector = [' + selector + ']');
			//	_alert('(+++) datum = [' + datum + ']');
			//	_alert('(+++) (B4) oO = [' + oO + ']');
				oO.QuerySetCell(selector, datum, recNum + 1); // query obj's use row 0 for the column names but data begins on row 1...
			//	_alert('\n(+++) oO = [' + oO + ']');
			} else {
				oO.iterateRecObjs(searchRecord);
			}
		}
	}

	var aDict = DictionaryObj.getInstance();
	aDict.bool_returnArray = true;
	for (i = 0; i < ar.length; i++) {
		aDict.fromSpec(ar[i]);
	}

	return aDict;
};

GeonosisObj.searchInstancesForClassName = function(aClassName) {
	return GeonosisObj.searchInstancesForObjects(aClassName, 'CLASSNAME', true);
};

GeonosisObj.searchInstancesForObjectID = function(anID) {
	return GeonosisObj.searchInstancesForObjects(anID, 'OBJECTID', false);
};

GeonosisObj.searchInstancesForID = function(anID) {
	return GeonosisObj.searchInstancesForObjects(anID, 'ID', true);
};

GeonosisObj.prototype = {
	id : -1,
	qData : -1,
	qAttrs : -1,
	toString : function() {
		function toStr() {
			var s = '[';

			s += "qData = {" + this.qData.toString() + "}" + '\n';
			s += "qAttrs = {" + this.qAttrs.toString() + "}" + '\n';

			s += ']';
			return s;
		}
		var s = 'id = [' + this.id + ']\n' + toStr();
		return s;
	},
	init : function() {
		this.qData = -1;
		this.qAttrs = -1;
		return this;
	},
	destructor : function() {
		if (this.qData != -1) this.qData.destructor();
		if (this.qAttrs != -1) this.qAttrs.destructor();
		return (this.id = GeonosisObj.instances[this.id] = this.qData = this.qAttrs = null);
	},
	dummy : function() {
		return false;
	}
};
