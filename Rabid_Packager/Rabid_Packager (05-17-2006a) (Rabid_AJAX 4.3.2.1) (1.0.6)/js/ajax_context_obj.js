/*
 ajax_context_obj.js -- AJaxContextObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

AJaxContextObj = function(id){
	this.id = id;				// the id is the position within the global ButtonBarObj.instances array
	this.queryString = '';
	this.parmsDict = -1;
	this.argsDict = -1;
};

AJaxContextObj.$ = [];

AJaxContextObj.get$ = function() {
	// the object.id is the position within the array that holds onto the objects...
	// aSpec is a key=value, list from which the dictionary can be created with contents...
	var instance = AJaxContextObj.$[AJaxContextObj.$.length];
	if (instance == null) {
		instance = AJaxContextObj.$[AJaxContextObj.$.length] = new AJaxContextObj(AJaxContextObj.$.length);
	}
	return instance;
};

AJaxContextObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < AJaxContextObj.$.length) ) {
		var instance = AJaxContextObj.$[id];
		if (!!instance) {
			AJaxContextObj.$[id] = object_destructor(instance);
			ret_val = (AJaxContextObj.$[id] == null);
		}
	}
	return ret_val;
};

AJaxContextObj._remove$ = function() {
	var ret_val = true;
	for (var i = 0; i < AJaxContextObj.$.length; i++) {
		AJaxContextObj.remove$(i);
	}
	AJaxContextObj.$ = [];
	return ret_val;
};

AJaxContextObj.prototype = {
	id : -1,
	queryString : '',
	parmsDict : -1,
	argsDict : -1,
	toString : function() {
		var aKey = -1;
		var s = '\nAJaxContextObj(' + this.id + ') :: (\n';
		s += 'queryString = [' + this.queryString + ']' + '\n';
		s += 'parmsDict = [' + this.parmsDict + ']' + '\n';
		s += 'argsDict = [' + this.argsDict + ']' + '\n';
		s += ')';
		return s;
	},
	init : function() {
		this.queryString = '';
		try {
			this.parmsDict.destructor();
		} catch(e) {
		} finally {
		}
		this.parmsDict = -1;
		try {
			this.argsDict.destructor();
		} catch(e) {
		} finally {
		}
		this.argsDict = -1;
		return this;
	},
	destructor : function() {
		try {
			this.parmsDict.destructor();
		} catch(e) {
		} finally {
		}
		this.parmsDict = -1;
		try {
			this.argsDict.destructor();
		} catch(e) {
		} finally {
		}
		return (this.id = AJaxContextObj.$[this.id] = this.queryString = this.parmsDict = this.argsDict = null);
	},
	dummy : function() {
		return false;
	}
};
