/*
 geonosis_obj.js -- GeonosisObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

GeonosisObj = function(id){
	this.id = id;				// the id is the position within the global GeonosisObj.$ array
};

GeonosisObj.$ = [];

GeonosisObj.get$ = function() {
	// the object.id is the position within the array that holds onto the objects...
	var instance = GeonosisObj.$[GeonosisObj.$.length];
	if(instance == null) {
		instance = GeonosisObj.$[GeonosisObj.$.length] = new GeonosisObj(GeonosisObj.$.length);
	}
	return instance;
};

GeonosisObj.i = function() {
	return GeonosisObj.get$(); // this is an alias that aids the transmission of code from the server to the client...
};

GeonosisObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < GeonosisObj.$.length) ) {
		var instance = GeonosisObj.$[id];
		if (!!instance) {
			GeonosisObj.$[id] = object_destructor(instance);
			ret_val = (GeonosisObj.$[id] == null);
		}
	}
	return ret_val;
};

GeonosisObj._remove$ = function() {
	var ret_val = true;
	for (var i = 0; i < GeonosisObj.$.length; i++) {
		GeonosisObj.remove$(i);
	}
	GeonosisObj.$ = [];
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
	for (i = 0; i < GeonosisObj.$.length; i++) {
		oO = ((use_qData) ? GeonosisObj.$[i].qData : GeonosisObj.$[i].qAttrs);
		oO.iterateRecObjs(anyErrorRecords);
		if (!bool_isAnyErrorRecords) {
			if (recNum != null) {
				oO.QuerySetCell(selector, datum, recNum + 1); // query obj's use row 0 for the column names but data begins on row 1...
			} else {
				oO.iterateRecObjs(searchRecord);
			}
		}
	}

	var aDict = DictionaryObj.get$();
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
		return (this.id = GeonosisObj.$[this.id] = this.qData = this.qAttrs = null);
	},
	dummy : function() {
		return false;
	}
};
