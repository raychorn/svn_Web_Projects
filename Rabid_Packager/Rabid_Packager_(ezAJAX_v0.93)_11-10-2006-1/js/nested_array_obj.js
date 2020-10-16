/*
 nested_array_obj.js -- NestedArrayObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

NestedArrayObj = function(id, a){
	this.id = id;				// the id is the position within the global ButtonBarObj.instances array
	this.array = a;
};

NestedArrayObj.$ = [];

NestedArrayObj.get$ = function(a) {
	// the object.id is the position within the array that holds onto the objects...
	var instance = NestedArrayObj.$[NestedArrayObj.$.length];
	if(instance == null) {
		instance = NestedArrayObj.$[NestedArrayObj.$.length] = new NestedArrayObj(NestedArrayObj.$.length, a);
	}
	return instance;
};

NestedArrayObj.remove$ = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < NestedArrayObj.$.length) ) {
		var instance = NestedArrayObj.$[id];
		if (!!instance) {
			NestedArrayObj.$[id] = object_destructor(instance);
			ret_val = (NestedArrayObj.$[id] == null);
		}
	}
	return ret_val;
};

NestedArrayObj._remove$ = function() {
	var ret_val = true;
	for (var i = 0; i < NestedArrayObj.$.length; i++) {
		NestedArrayObj.remove$(i);
	}
	NestedArrayObj.$ = [];
	return ret_val;
};

NestedArrayObj.prototype = {
	id : -1,
	array : [],
	toString : function() {
		function toStr(a) {
			var s = '[';
			for (var i = 0; i < a.length; i++) {
				if (typeof a[i] == const_object_symbol) {
					s += toStr(a[i]) + ((i < (a.length - 1)) ? ', ' : '');
				} else {
					s += "'" + a[i].toString() + "'" + ((i < (a.length - 1)) ? ', ' : '');
				}
			}
			s += ']';
			return s;
		}
		
		var s = toStr(this.array);
		return s;
	},
	length : function() {
		return (this.array.length);
	},
	destructor : function() {
		return (this.id = NestedArrayObj.$[this.id] = this.array = null);
	},
	dummy : function() {
		return false;
	}
};
