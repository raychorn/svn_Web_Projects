/*
 dictionary_obj.js -- DictionaryObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

DictionaryObj = function(id){
	this.id = id;				// the id is the position within the global ButtonBarObj.instances array
	this.keys = [];
	this.cache = [];
};

DictionaryObj.instances = [];

DictionaryObj.getInstance = function(aSpec) {
	// the object.id is the position within the array that holds onto the objects...
	// aSpec is a key=value, list from which the dictionary can be created with contents...
	var instance = DictionaryObj.instances[DictionaryObj.instances.length];
	if(instance == null) {
		instance = DictionaryObj.instances[DictionaryObj.instances.length] = new DictionaryObj(DictionaryObj.instances.length);
	}
	instance.fromSpec(aSpec);
	return instance;
};

DictionaryObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < DictionaryObj.instances.length) ) {
		var instance = DictionaryObj.instances[id];
		if (!!instance) {
			DictionaryObj.instances[id] = object_destructor(instance);
			ret_val = (DictionaryObj.instances[id] == null);
		}
	}
	return ret_val;
};

DictionaryObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < DictionaryObj.instances.length; i++) {
		DictionaryObj.removeInstance(i);
	}
	DictionaryObj.instances = [];
	return ret_val;
};

DictionaryObj.prototype = {
	id : -1,
	keys : [],
	cache : [],
	bool_returnArray : false,
	toString : function() {
		var aKey = -1;
		var s = 'DictionaryObj(' + this.id + ') :: (';
		s += 'bool_returnArray = [' + this.bool_returnArray + ']' + '\n';
		s += '\n';
		for (var i = 0; i < this.keys.length; i++) {
			aKey = this.keys[i];
			s += aKey + ' = [' + this.getValueFor(aKey) + ']' + '\n';
		}
		s += ')';
		return s;
	},
	fromSpec : function(aSpec) {
		var i = -1;
		var ar = [];
		var ar2 = [];

		if (!!aSpec) {
			ar = aSpec.split(',');
			if (ar.length == 1) {
				ar = aSpec.split('&'); // also parses standard HTTP QueryStrings...
			}
			for (i = 0; i < ar.length; i++) {
				if (ar[i].length > 0) { // ignore any parsed parms that are blank due to leading delimiter...
					ar2 = ar[i].split('=');
					if (ar2.length == 2) {
						this.push(ar2[0], ar2[1]);
					} else {
						this.push(ar[i], ar[i + 1]);
						i++;
					}
				}
			}
		}
	},
	asQueryString : function(bool_encode, ch_delim) { // when ch_delim is null the result is a properly encoded URL QueryString...
		var aKey = -1;
		var aVal = '';
		var n = this.keys.length;
		var n1 = (n - 1);
		ch_delim = ((!!ch_delim) ? ch_delim : '&');
		var s = ((n > 0) ? ch_delim : '');
		bool_encode = ((bool_encode == true) ? bool_encode : false);
		for (var i = 0; i < n; i++) {
			aKey = this.keys[i];
			aVal = this.getValueFor(aKey);
			s += aKey + '=' + ((bool_encode) ? URLEncode(aVal.toString()) : aVal) + ((i < n1) ? ch_delim : '');
		}
		return s;
	},
	asQueryStringForColumn : function(colNum) { // this method returns a dict obj for a specific column of databased on the way the getValueFor method returns data...
		var i = -1;
		var qString = '';
		var aKey = -1;
		var aVal = '';
		var ar = [];
		var n = this.keys.length;

		for (i = 0; i < n; i++) {
			aKey = this.keys[i];
			aVal = this.getValueFor(aKey);
			if (typeof aVal != const_object_symbol) {
				ar = [];
				ar.push(aVal);
				aVal = ar;
			}
			qString += '&' + aKey + '=' + (( (colNum >= 0) && (colNum < aVal.length) ) ? aVal[colNum] : '');
		}
		return qString;
	},
	dictForColumn : function(colNum) { // this method returns a dict obj for a specific column of databased on the way the getValueFor method returns data...
		return DictionaryObj.getInstance(this.asQueryStringForColumn(colNum));
	},
	push : function(key, value) {
		var _f = -1;
		var _key = key.trim().toUpperCase();
		for (var i = 0; i < this.keys.length; i++) {
			if (this.keys[i].trim().toUpperCase() == _key) {
				_f = i;
				break;
			}
		}
		if (_f == -1) {
			this.keys.push(key);
			this.cache[key] = value;
			return true;
		} else { // key already has a value so make the value into a DictionaryObj so it can store many values, if necessary...
			if (typeof this.cache[key] != const_object_symbol) {
				var a = [];
				a.push(this.cache[key]);
				this.cache[key] = a;
			}
			this.cache[key].push(value);
		}
		return false;
	},
	put : function(key, value) {
		if (!!this.cache[key]) {
			this.cache[key] = value;
		}
	},
	getValueFor : function(key, bool_caseless) {
		var val = this.cache[key];
		if (!!val) {
			this.bool_returnArray = ((this.bool_returnArray == true) ? this.bool_returnArray : false);
			if ( (this.bool_returnArray) && (typeof val != const_object_symbol) ) {
				var _ar = [];
				_ar.push(val);
				val = _ar;
			}
		}
		return (val);
	},
	getKeys : function() {
		return (this.keys);
	},
	getKeysMatching : function(func) { // func(val) returns true or false to determine if the value matches a known pattern that is governed by the function func...
		var k = this.keys;
		if ( (!!func) && (typeof func == const_function_symbol) ) {
			k = [];
			for (var i = 0; i < this.keys.length; i++) {
				if (func(this.keys[i])) {
					k.push(this.keys[i]);
				}
			}
		}
		return (k); // this returns either all the keys or only those that match the function func()...
	},
	adjustKeyNames : function(func) { // return keys adjusted by the function func()...
		var k = this.keys;
		if ( (!!func) && (typeof func == const_function_symbol) ) {
			k = [];
			for (var i = 0; i < this.keys.length; i++) {
				k.push(func(this.keys[i]));
			}
		}
		return (k); // this returns either all the keys or only those that match the function func()...
	},
	length : function() {
		return (this.keys.length);
	},
	init : function() {
		this.keys = [];
		this.cache = [];
		return this;
	},
	destructor : function() {
		return (this.id = DictionaryObj.instances[this.id] = this.keys = this.cache = null);
	},
	dummy : function() {
		return false;
	}
};
