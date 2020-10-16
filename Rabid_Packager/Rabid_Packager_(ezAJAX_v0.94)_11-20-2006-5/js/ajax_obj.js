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

AJAXObj.$ = [];

AJAXObj.get$ = function() {
	// the object.id is the position within the array that holds onto the objects...
	var instance = AJAXObj.$[AJAXObj.$.length];
	if(instance == null) {
		instance = AJAXObj.$[AJAXObj.$.length] = new AJAXObj(AJAXObj.$.length);
	}
	return instance;
};

AJAXObj.i = function() {
	return AJAXObj.get$(); // this is an alias that aids the transmission of code from the server to the client...
};

AJAXObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < AJAXObj.$.length) ) {
		var instance = AJAXObj.$[id];
		if (!!instance) {
			AJAXObj.$[id] = object_destructor(instance);
			ret_val = (AJAXObj.$[id] == null);
		}
	}
	return ret_val;
};

AJAXObj._remove$ = function() {
	var ret_val = true;
	for (var i = 0; i < AJAXObj.$.length; i++) {
		AJAXObj.remove$(i);
	}
	AJAXObj.$ = [];
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
					s += aName + " = \{" + d[aName].toString() + "\}" + '\n\n';
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
	p : function(aName, datum) {
		return this.push(aName, datum); // this is an alias that aids the transmission of code from the server to the client...
	},
	pop : function() {
		var aName = this.names.pop();
		return this.data[aName];
	},
	named : function(aName) {
		return this.data[aName];
	},
	destructor : function() {
		return (this.id = AJAXObj.$[this.id] = this.data = this.names = null);
	},
	dummy : function() {
		return false;
	}
};
