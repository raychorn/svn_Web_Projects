/*
 cf_query_obj.js -- QueryObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

QueryObj = function(id, _colNames){
	this.id = id;				// the id is the position within the global QueryObj.instances array
	this.colNames = _colNames;
	this.dataRec = [];
	var a = _colNames.trim().split(',');
	this.dataRec.push(a);
};

QueryObj.instances = [];

QueryObj.getInstance = function(_colNames) {
//if (_isQueryObjDebugMode) alert('QueryObj.getInstance(' + _colNames + ')');
	// the object.id is the position within the array that holds onto the objects...
	var instance = QueryObj.instances[QueryObj.instances.length];
	if(instance == null) {
		instance = QueryObj.instances[QueryObj.instances.length] = new QueryObj(QueryObj.instances.length, _colNames);
	}
	return instance;
};

QueryObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < QueryObj.instances.length) ) {
		var instance = QueryObj.instances[id];
		if (instance != null) {
			QueryObj.instances[id] = object_destructor(instance);
			ret_val = (QueryObj.instances[id] == null);
		}
	}
	return ret_val;
};

QueryObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < QueryObj.instances.length; i++) {
		QueryObj.removeInstance(i);
	}
	return ret_val;
};

QueryObj.prototype = {
	id : -1,
	s_toString : '',
	colNames : '',
	dataRec : [],
	_toString : function(_aRec, _ri, _cols) {
		s_toString += ((_ri > 1) ? '\n' : '') + '[' + _ri + '] :: ';
		for (var i = 0; i < _aRec.length; i++) {
			if (_aRec[i].trim().length > 0) {
				s_toString += '{' + _cols[i] + '}=<' + _aRec[i] + '>';
				if (i < (_aRec.length - 1)) {
					s_toString += ', ';
				}
			}
		}
		return s_toString += '';
	},
	toString : function() {
		s_toString = 'columnList = (' + this.columnList() + '), recordCount = ' + this.recordCount() + '\n' + 'dataRec = (' + this.dataRec.toString() + ')\n';
		this.iterate(this._toString);
		return s_toString;
	},
	recordCount : function() {
		return (this.dataRec.length - 1); // this.dataRec[0] is where the colNames are stored...
	},
	columnList : function() {
		return ((this.dataRec.length > 0) ? this.dataRec[0] : []); // this.dataRec[0] is where the colNames are stored...
	},
	data : function() {
		return (this.dataRec.slice(1,this.dataRec.length));
	},
	iterate : function(func) {
		var _cols = this.columnList();
		for (var ri = 1; ri < this.dataRec.length; ri++) {
			if (func) {
				func(this.dataRec[ri], ri, _cols);
			}
		}
	},
	QueryAddRow : function() {
		var d = [];
		this.dataRec.push(d);
	},
	getColNumFromColName : function(colName) {
		var colNum = -1;
		for (var i = 0; i < this.dataRec[0].length; i++) { // this.dataRec[0] is where the colNames are stored...
			if (colName.trim().toUpperCase() == this.dataRec[0][i].trim().toUpperCase()) {
				colNum = i;
				break;
			}
		}
		return colNum;
	},
	QuerySetCell : function(cName, vVal, rowNum) {
		var d = [];
		var ci = -1;
		var colNum = this.getColNumFromColName(cName);
		if (colNum != -1) {
			if (rowNum <= this.recordCount()) {
				d = this.dataRec[rowNum];
				for (ci = 0; ci < this.dataRec[0].length; ci++) {
					if (ci == colNum) {
						d[ci] = vVal;
						break;
					}
				}
				this.dataRec[rowNum] = d;
			}
		}
		return false;
	},
	getValueFromName : function(cName, colName, valName) {
		var row = [];
		var ri = -1;
		var colNum = this.getColNumFromColName(colName);
		var valNum = this.getColNumFromColName(valName);
		if ( (colNum != -1) && (valNum != -1) ) {
			for (ri = 1; ri < this.dataRec.length; ri++) {
				row = this.dataRec[ri];
				if (row[colNum].trim().toUpperCase() == cName.trim().toUpperCase()) {
					return row[valNum];
				}
			}
		}
		return '';
	},
	getValueFromNameAtRow : function(cName, colName, valName, iRow) {
		var row = [];
		var ri = -1;
		var colNum = this.getColNumFromColName(colName);
		var valNum = this.getColNumFromColName(valName);
		if ( (colNum != -1) && (valNum != -1) ) {
			if ( (iRow > 0) && (iRow < this.dataRec.length) ) {
				row = this.dataRec[iRow];
				if (row[colNum].trim().toUpperCase() == cName.trim().toUpperCase()) {
					return row[valNum];
				}
			}
		}
		return '';
	},
	as_JS_array_source : function(cName) {
		var _parms = URLDecode(this.getValueFromName(cName, 'name', 'val'));
		var _pa = _parms.split(',');
		var _pb = [];
		var _pc = [];
		var aa = '[[]]'; // this is the correct default value because if there are no values this function must still return a usable array...
		if (_pa.length > 1) {
			aa = '[';
			for (var i = 0; i < _pa.length; i++) {
				_pb = _pa[i].split('=');
				if (_pb.length == 2) {
					_pc = [];
					_pc.push(_pb[0]);
					_pc.push(_pb[1]);
					aa += '[' + _pc.cfString() + ']';
					if (i < (_pa.length - 1)) {
						aa += ', ';
					}
				}
			}
			aa += ']';
		}
		return aa;
	},
	destructor : function() {
		return (this.id = QueryObj.instances[this.id] = this.s_toString = this.colNames = this.dataRec = null);
	},
	dummy : function() {
		return false;
	}
};
