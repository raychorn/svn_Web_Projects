/*
 ajax_obj.js -- AJAXObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

AJAXObj = function(id){
	this.id = id;				// the id is the position within the global ButtonBarObj.instances array
};

AJAXObj.instances = [];

AJAXObj.getInstance = function() {
	// the object.id is the position within the array that holds onto the objects...
	var instance = AJAXObj.instances[AJAXObj.instances.length];
	if(instance == null) {
		instance = AJAXObj.instances[AJAXObj.instances.length] = new AJAXObj(AJAXObj.instances.length);
	}
	return instance;
};

AJAXObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < AJAXObj.instances.length) ) {
		var instance = AJAXObj.instances[id];
		if (instance != null) {
			AJAXObj.instances[id] = object_destructor(instance);
			ret_val = (AJAXObj.instances[id] == null);
		}
	}
	return ret_val;
};

AJAXObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < AJAXObj.instances.length; i++) {
		AJAXObj.removeInstance(i);
	}
	return ret_val;
};

AJAXObj.prototype = {
	id : -1,
	data : [],
	names : [],
	toString : function() {
		function toStr(a, d) {
			var s = '[';
			var i = -1;
			var aName = '';

			try {
				var n = a.length;
				for (i = 0; i < n; i++) {
					aName = a[i];
					s += aName + " = \{" + d[aName].toString() + "\}" + '\n';
				}
			} catch(e) {
				jsErrorExplainer(e, '(1) ajax_obj.js :: toStr()');
			} finally {
			}

			s += ']';
			return s;
		}
		var s = 'id = [' + this.id + '], ' + toStr(this.names, this.data);
		return s;
	},
	init : function() {
		this.names = [];
		this.data = [];
		return this;
	},
	push : function(aName, datum) {
		this.names.push(aName);
		this.data[aName] = datum;
	},
	pop : function() {
		var aName = this.names.pop();
		return this.data[aName];
	},
	named : function(aName) {
		return this.data[aName];
	},
	destructor : function() {
		return (this.id = AJAXObj.instances[this.id] = this.data = this.names = null);
	},
	dummy : function() {
		return false;
	}
};
