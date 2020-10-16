/*
 gui_actions_obj.js -- GUIActionsObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

GUIActionsObj = function(id){
	this.id = id;				// the id is the object id from a GUI widget we wish to manage...
	this.stack = [];
	this.ooStack = [];
	this.aspectStack = [];
	this.stylesStack = [];
};

GUIActionsObj.instances = [];

GUIActionsObj.getInstance = function() {
	// the object.id is the position within the array that holds onto the objects...
	var instance = GUIActionsObj.instances[GUIActionsObj.instances.length];
	if(instance == null) {
		instance = GUIActionsObj.instances[GUIActionsObj.instances.length] = new GUIActionsObj(GUIActionsObj.instances.length);
	}
	return instance;
};

GUIActionsObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < GUIActionsObj.instances.length) ) {
		var instance = GUIActionsObj.instances[id];
		if (!!instance) {
			GUIActionsObj.instances[id] = object_destructor(instance);
			ret_val = (GUIActionsObj.instances[id] == null);
		}
	}
	return ret_val;
};

GUIActionsObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < GUIActionsObj.instances.length; i++) {
		GUIActionsObj.removeInstance(i);
	}
	GUIActionsObj.instances = [];
	return ret_val;
};

GUIActionsObj.prototype = {
	id : -1,
	stack : [],
	ooStack : [],
	aspectStack : [],
	stylesStack : [],
	toString : function() {
		var s = 'id = (' + this.id + ') :: (';
		s += '\n';
		for (var i = 0; i < this.stack.length; i++) {
			s += i + ' = [' + this.stack[i] + ']' + ((i < (this.stack.length - 1)) ? ', ' : '');
		}
		s += ')';
		return s;
	},
	push : function(id) {
		var aHandle = -1;
		var oo = $(id);
		if (!!oo) {
			this.stack.push(id);
			this.ooStack.push(oo);
			this.aspectStack.push(DictionaryObj.getInstance());
			this.stylesStack.push(DictionaryObj.getInstance());
			aHandle = this.stack.length - 1;
		}
		return aHandle; // the handle is the current position for the newly added item...
	},
	revertAspectsDict : function(aDict, oo) {
		var i = -1;
		if ( (!!aDict) && (!!oo) ) {
			var keys = aDict.getKeys();
			for (i = 0; i < keys.length; i++) {
				var aVal = aDict.getValueFor(keys[i]);
				oo[keys[i]] = aVal;
			}
		}
	},
	revertStylesDict : function(aDict, oo) {
		var i = -1;
		if ( (!!aDict) && (!!oo) ) {
			var keys = aDict.getKeys();
			for (i = 0; i < keys.length; i++) {
				setStyle(oo.style, keys[i] + ': ' + aDict.getValueFor(keys[i]) + ';');
			}
		}
	},
	pop : function(aHandle) {
		var oo = -1;
		if ( (aHandle > -1) && (aHandle == (this.ooStack.length - 1)) ) {
			oo = this.ooStack.pop();
			if (!!oo) {
				this.iterateDicts(this.aspectStack.pop(), this.revertAspectsDict, oo);
				this.iterateDicts(this.stylesStack.pop(), this.revertStylesDict, oo);
			}
			this.destructDicts();
			return this.stack.pop();
		} else {
			alert('WARNING: Programming Error - Cannot pop from anywhere but the end of the stack towards beginning of the stack - the stack is a LIFO buffer...');
		}
		return -1;
	},
	popAll : function() {
		var i = -1;
		for (i = this.stack.length - 1; i >= 0; i--) {
			this.pop(i);
		}
	},
	replaceAspectNamedFor : function(aHandle, aName, aVal) {
		var oo = -1;
		if ( (aHandle > -1) && (aHandle < this.ooStack.length) ) {
			oo = this.ooStack[aHandle];
			if (!!oo) {
				if (!!aName) {
					var aDict = this.aspectStack[aHandle];
					aDict.push(aName, oo[aName]);
					oo[aName] = aVal;
					return aHandle;
				}
			}
		}
		return -1;
	},
	replaceStyleNamedFor : function(aHandle, aName, aVal) {
		var oo = -1;
		if ( (aHandle > -1) && (aHandle < this.ooStack.length) ) {
			oo = this.ooStack[aHandle];
			if (!!oo) {
				if (!!aName) {
					var aa = aVal.split(';');
					if ( (aVal.indexOf(':') != -1) && (aa.length == 2) ) {
						var aStyle = getStyle(oo, aName);
						var aDict = this.stylesStack[aHandle];
						aDict.push(aName, aStyle);
						setStyle(oo.style, aVal + ((aVal.indexOf(';') == -1) ? ';' : ''));
						return aHandle;
					} else {
						alert('WARNING: Programming Error - the style of (' + aVal + ', ' + aa.length + ') is not properly formed or has too many styles specified - kindly modify your code to make (' + aVal + ') into a properly formed style spec that specifies a single style (hint: properly formed style specs are just like the ones you would normally code into a style="font-size: 10px;" block however you may leave-off the final ";" in case you are passing in a single style spec).');
					}
				}
			}
		}
		return -1;
	},
	length : function() {
		return (this.stack.length);
	},
	iterateDicts : function(anArrayOrDict, func, oO) {
		var i = -1;
		var aDict = -1;
		if ( (!!anArrayOrDict) && (!!oO) ) {
			if (typeof anArrayOrDict == const_object_symbol) {
				if ( (!!anArrayOrDict.length) && (typeof anArrayOrDict.length != const_function_symbol) ) {
					for (i = 0; i < anArrayOrDict.length; i++) {
						aDict = anArrayOrDict[i];
						if ( (!!aDict) && (!!func) && (typeof func == const_function_symbol) ) {
							func(aDict, oO);
						}
					}
				} else {
					if ( (!!func) && (typeof func == const_function_symbol) ) {
						func(anArrayOrDict, oO);
					}
				}
			}
		}
	},
	destructDict : function(aDict) {
		if (!!aDict) {
			DictionaryObj.removeInstance(aDict.id);
		}
	},
	destructDicts : function() {
		this.iterateDicts(this.aspectStack, this.destructDict);
		this.iterateDicts(this.stylesStack, this.destructDict);
	},
	init : function() {
		this.stack = [];
		this.ooStack = [];
		this.destructDicts();
		this.aspectStack = [];
		this.stylesStack = [];
		return this;
	},
	destructor : function() {
		this.destructDicts();
		return (this.id = GUIActionsObj.instances[this.id] = this.aspectStack = this.stylesStack = this.stylesDict = this.aspectDict = this.ooStack = this.stack = null);
	},
	dummy : function() {
		return false;
	}
};
