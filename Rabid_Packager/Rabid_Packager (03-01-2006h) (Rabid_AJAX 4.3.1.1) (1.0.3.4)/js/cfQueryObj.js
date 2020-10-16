/*
 cfQueryObj.js -- cfQueryObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

cfQueryObj = function(id, _colNames){
	var i = -1;
	this.id = id;				// the id is the position within the global cfQueryObj.instances array
	this.colNames = _colNames.URLDecode().trim().split(',');
	for (i = 0; i < this.colNames.length; i++) {
		this.colNames[i] = this.colNames[i].trim();
	}
	this._recordCount = 0;
	this.dataRec = [];
};

cfQueryObj.instances = [];

cfQueryObj.getInstance = function(_colNames) {
	// the object.id is the position within the array that holds onto the objects...
	var instance = cfQueryObj.instances[cfQueryObj.instances.length];
	if(instance == null) {
		instance = cfQueryObj.instances[cfQueryObj.instances.length] = new cfQueryObj(cfQueryObj.instances.length, _colNames);
	}
	return instance;
};

cfQueryObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < cfQueryObj.instances.length) ) {
		var instance = cfQueryObj.instances[id];
		if (!!instance) {
			cfQueryObj.instances[id] = object_destructor(instance);
			ret_val = (cfQueryObj.instances[id] == null);
		}
	}
	return ret_val;
};

cfQueryObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < cfQueryObj.instances.length; i++) {
		cfQueryObj.removeInstance(i);
	}
	return ret_val;
};

cfQueryObj.prototype = {
	id : -1,
	colNames : [],
	dataRec : [],             // this.dataRec[this.colNames[0]]
	_recordCount : 0,
	rowCntName : 'rowCnt',
	_toString : function(_data, _ri, _cols) {
		var n = _cols.length;
		var s_toString += ((_ri > 1) ? '\n' : '') + '[' + _ri + '] :: ';
		for ()
		for (var i = 0; i < n; i++) {
			if (this.dataRec[this.colNames[i]][j].trim().length > 0) {
				s_toString += '{' + _cols[i] + '}=<' + _aRec[i] + '>';
				if (i < (_aRec.length - 1)) {
					s_toString += ', ';
				}
			}
		}
		return s_toString += '';
	},
	toString : function() {
		var s_toString = 'cfQueryObj(' + this.id + ') :: \ncolumnList = (' + this.columnList() + '), recordCount = ' + this._recordCount + '\n\n';
		this.iterate(this._toString);
		return s_toString;
	},
	recordCount : function() {
		return this._recordCount;
	},
	columnList : function() {
		return this.colNames.join(',');
	},
	iterate : function(func) {
		if ( (!!func) && (typeof func == const_function_symbol) ) {
			for (var ri = 0; ri < this._recordCount; ri++) {
				func(this.dataRec, ri, this.colNames);
			}
		}
	},
	iterateRecObjs : function(func) {
		var i = -1;
		var _f = -1;
		var rN = this.dataRec.length;
		var rowArray = [];
		var oDict = DictionaryObj.getInstance();
		var _cols = this.columnList();
		
		if ( (!!func) && (typeof func == const_function_symbol) ) {
			for (var ri = 1; ri < rN; ri++) {
				rowArray = this.dataRec[ri];
				for (i = 0; i < _cols.length; i++) {
					oDict.push(_cols[i], rowArray[i]);
				}
				oDict.push(this.rowCntName, rN - 1);
				_f = func(ri, oDict, this.rowCntName, this);
				_f = ((!!_f) ? _f : -1);
				if (_f != -1) {
					break;
				}
				oDict.init();
			}
		}
		DictionaryObj.removeInstance(oDict.id);
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
			if (rowNum <= this._recordCount) {
				d = this.dataRec[rowNum];
				for (ci = 0; ci < this.dataRec[0].length; ci++) {
					if (ci == colNum) {
						d[ci] = vVal.URLDecode();
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
		var colNum = this.getColNumFromColName(colName); // which column offset is this value stored in ?
		var valNum = this.getColNumFromColName(valName); // which column offset is this value stored in ?
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
		return (this.id = cfQueryObj.instances[this.id] = this.colNames = this.dataRec = this.rowCntName = null);
	},
	dummy : function() {
		return false;
	}
};
