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
	var i = -1;
	var ar = [];
	var ar2 = [];
	// the object.id is the position within the array that holds onto the objects...
	// aSpec is a key=value, list from which the dictionary can be created with contents...
	var instance = DictionaryObj.instances[DictionaryObj.instances.length];
	if(instance == null) {
		instance = DictionaryObj.instances[DictionaryObj.instances.length] = new DictionaryObj(DictionaryObj.instances.length);
	}
	if (!!aSpec) {
		ar = aSpec.split(',');
		if (ar.length == 1) {
			ar = aSpec.split('&'); // also parses standard HTTP QueryStrings...
		}
		for (i = 0; i < ar.length; i++) {
			if (ar[i].length > 0) { // ignore any parsed parms that are blank due to leading delimiter...
				ar2 = ar[i].split('=');
				if (ar2.length == 2) {
					instance.push(ar2[0], ar2[1]);
				} else {
					instance.push(ar[i], ar[i + 1]);
					i++;
				}
			}
		}
	}
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
	return ret_val;
};

DictionaryObj.prototype = {
	id : -1,
	keys : [],
	cache : [],
	toString : function() {
		var aKey = -1;
		var s = '(';
		s += '\n';
		for (var i = 0; i < this.keys.length; i++) {
			aKey = this.keys[i];
			s += aKey + ' = [' + this.getValueFor(aKey) + ']' + '\n';
		}
		s += ')';
		return s;
	},
	asQueryString : function(ch_delim) { // when ch_delim is null the result is a properly encoded URL QueryString...
		var aKey = -1;
		var s = '';
		for (var i = 0; i < this.keys.length; i++) {
			aKey = this.keys[i];
			if (!!ch_delim) {
				s += aKey + '=' + this.getValueFor(aKey) + ((i < (this.keys.length - 1)) ? ch_delim : '');
			} else {
				s += '&' + aKey + '=' + this.getValueFor(aKey);
			}
		}
		return s;
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
	getValueFor : function(key) {
		return (this.cache[key]);
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
