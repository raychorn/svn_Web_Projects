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

AJaxContextObj.instances = [];

AJaxContextObj.getInstance = function() {
	// the object.id is the position within the array that holds onto the objects...
	// aSpec is a key=value, list from which the dictionary can be created with contents...
	var instance = AJaxContextObj.instances[AJaxContextObj.instances.length];
	if(instance == null) {
		instance = AJaxContextObj.instances[AJaxContextObj.instances.length] = new AJaxContextObj(AJaxContextObj.instances.length);
	}
	return instance;
};

AJaxContextObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < AJaxContextObj.instances.length) ) {
		var instance = AJaxContextObj.instances[id];
		if (!!instance) {
			AJaxContextObj.instances[id] = object_destructor(instance);
			ret_val = (AJaxContextObj.instances[id] == null);
		}
	}
	return ret_val;
};

AJaxContextObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < AJaxContextObj.instances.length; i++) {
		AJaxContextObj.removeInstance(i);
	}
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
		return (this.id = AJaxContextObj.instances[this.id] = this.queryString = this.parmsDict = this.argsDict = null);
	},
	dummy : function() {
		return false;
	}
};
