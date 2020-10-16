/*
 cf_query_obj.js -- QueryObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.

	Recode this object to use a DictionaryObj to hold the data records rather than the array since the array falls apart like we knew it would.

*/

QueryObj = function(id, _colNames){
	this.id = id;				// the id is the position within the global QueryObj.$ array
	this.colNames = _colNames;
	this.dataRec = [];
	var a = _colNames.URLDecode().trim().split(',');
	this.dataRec.push(a);
};

QueryObj.$ = [];

QueryObj.get$ = function(_colNames) {
	// the object.id is the position within the array that holds onto the objects...
	var instance = QueryObj.$[QueryObj.$.length];
	if(instance == null) {
		instance = QueryObj.$[QueryObj.$.length] = new QueryObj(QueryObj.$.length, _colNames);
	}
	return instance;
};

QueryObj.i = function(_colNames) {
	return QueryObj.get$(_colNames); // this is an alias that aids the transmission of code from the server to the client...
};

QueryObj.i$ = function(ar) {
	var i = -1;
	var j = -1;
	var colAR = -1;
	var iCol = -1;
	var aName = '';
	var bool_isAddingRows = true;
	var aRec = [];
	var dRecs = [];
	try {
		if (typeof ar == const_object_symbol) {
			var oQuery = QueryObj.get$(ar[0]);
			colAR = ar[0].split(',');
			for (i = 1; i < ar.length; i += 2) {
				aRec = [];
				aRec.push(ar[i]);
				aRec.push(ar[i + 1]);
				dRecs.push(aRec);
			}
			for (i = 0; i < dRecs.length; i++) {
				if (dRecs[i].length == 2) {
					aName = dRecs[i][0];
					for (j = 0; j < dRecs[i][1].length; j++) {
						if (bool_isAddingRows) oQuery.qar();
						oQuery.qsc(aName, dRecs[i][1][j], j + 1);
					}
					bool_isAddingRows = false;
				}
			}
			return oQuery; // this is an alias that aids the transmission of code from the server to the client...
		}
	} catch(e) {
		_alertError(jsErrorExplainer(e, 'QueryObj.i$(' + ar + ')'));
	} finally {
	}
	return null;
};

QueryObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < QueryObj.$.length) ) {
		var instance = QueryObj.$[id];
		if (!!instance) {
			QueryObj.$[id] = object_destructor(instance);
			ret_val = (QueryObj.$[id] == null);
		}
	}
	return ret_val;
};

QueryObj._remove$ = function() {
	var ret_val = true;
	for (var i = 0; i < QueryObj.$.length; i++) {
		QueryObj.remove$(i);
	}
	QueryObj.$ = [];
	return ret_val;
};

QueryObj.prototype = {
	id : -1,
	s_toString : '',
	colNames : '',
	dataRec : [],
	rowCntName : 'rowCnt',
	_toString : function(_aRec, _ri, _cols) {
		s_toString += ((_ri > 1) ? '\n' : '') + '[' + _ri + '] :: ';
		for (var i = 0; i < _aRec.length; i++) {
			if (_aRec[i].trim().length > 0) {
				s_toString += '{' + _cols[i] + '}=<' + unescape(_aRec[i]) + '>';
				if (i < (_aRec.length - 1)) {
					s_toString += ', ';
				}
			}
		}
		return s_toString += '';
	},
	toString : function() {
		s_toString = 'QueryObj(' + this.id + ') :: \ncolumnList = (' + this.columnList() + '), recordCount = ' + unescape(this.recordCount()) + '\n' + 'dataRec = (' + this.dataRec.toString() + ')\n\n';
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
		if ( (!!func) && (typeof func == const_function_symbol) ) {
			for (var ri = 1; ri < this.dataRec.length; ri++) {
				func(this.dataRec[ri], ri, _cols);
			}
		}
	},
	iterateRecObjs : function(func) {
		var i = -1;
		var _f = -1;
		var rN = this.dataRec.length;
		var rowArray = [];
		var oDict = DictionaryObj.get$();
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
		DictionaryObj.remove$(oDict.id);
	},
	getValueFor : function(aKey) {
		var ar = [];
		
		function searchForRecs(_ri, _dict, _rowCntName) {
			var n = _dict.getValueFor('NAME');
			var v = _dict.getValueFor('VAL');
			if ( (!!n) && (!!v) ) {
				if (n.trim() == aKey) {
					ar.push(v);
				}
			} else {
				v = _dict.getValueFor(aKey);
				if (!!v) ar.push(v);
			}
		}
		
		this.iterateRecObjs(searchForRecs);
		
		return ar;
	},
	getRecordForMatching : function(aKey, aVal, bool_caseless) {
		var ar = [];
		var aDict = -1;
		bool_caseless = ((bool_caseless == true) ? bool_caseless : false);
		
		function searchForRecs(_ri, _dict, _rowCntName) {
			var v = _dict.getValueFor(aKey);
			if (!!v) {
				if ( ( (bool_caseless) && (v.toUpperCase() == aVal.toUpperCase()) ) || (v == aVal) ) {
					aDict = DictionaryObj.get$(_dict.asQueryString());
					aDict.bool_returnArray = false;
					ar.push(aDict);
				}
			}
		}
		
		this.iterateRecObjs(searchForRecs);
		
		return ar;
	},
	QueryAddRow : function() {
		var d = [];
		this.dataRec.push(d);
	},
	qar : function() {
		return this.QueryAddRow(); // this is an alias that aids the transmission of code from the server to the client...
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
						d[ci] = vVal.URLDecode();
						break;
					}
				}
				this.dataRec[rowNum] = d;
			}
		}
		return false;
	},
	qsc : function(cName, vVal, rowNum) {
		return this.QuerySetCell(cName, vVal, rowNum); // this is an alias that aids the transmission of code from the server to the client...
	},
	QuerySetCells : function(cName, vValAR, rowNum) {
		var d = [];
		var ci = -1;
		var ri = -1;
		if (typeof vValAR != const_object_symbol) {
			var ar = [];
			ar.push(vValAR);
			vValAR = ar;
		}
		rowNum = ((rowNum == null) ? 1 : rowNum);
		var colNum = this.getColNumFromColName(cName);
		if (colNum != -1) {
			for (ri = 0; ri < vValAR.length; ri++) {
				d = this.dataRec[rowNum + ri];
				if ( (d == null) || (typeof d != const_object_symbol) ) {
					d = [];
				}
				d[colNum] = vValAR[ri].URLDecode();
				this.dataRec[rowNum + ri] = d;
			}
		}
		return false;
	},
	qsc$ : function(cName, vValAR, rowNum) {
		return this.QuerySetCells(cName, vValAR, rowNum); // this is an alias that aids the transmission of code from the server to the client in bulk...
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
		return (this.id = QueryObj.$[this.id] = this.s_toString = this.colNames = this.dataRec = null);
	},
	dummy : function() {
		return false;
	}
};
