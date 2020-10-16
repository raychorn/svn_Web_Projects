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
	this.aspectDict = DictonaryObj.getInstance();
	this.stylesDict = DictonaryObj.getInstance();
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
		if (instance != null) {
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
	return ret_val;
};

GUIActionsObj.prototype = {
	id : -1,
	stack : [],
	ooStack : [],
	aspectDict : -1,
	stylesDict : -1,
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
		var oo = getGUIObjectInstanceById(id);
		if (!!oo) {
			this.stack.push(id);
			this.ooStack.push(oo);
			aHandle = this.stack.length - 1;
		}
		return aHandle; // the handle is the current position for the newly added item...
	},
	pop : function(aHandle) {
		var oo = -1;
		if ( (aHandle > -1) && (aHandle == (this.ooStack.length - 1)) ) {
			oo = this.ooStack.pop();
			return this.stack.pop();
		} else {
			alert('WARNING: Programming Error - Cannot pop from anywhere but the end of the stack towards beginning of the stack - the stack is a LIFO buffer...');
		}
		return -1;
	},
	replaceAspectNamedFor : function(aHandle, aName, aVal) {
		var oo = -1;
		if ( (aHandle > -1) && (aHandle < this.ooStack.length) ) {
			oo = this.ooStack[aHandle];
			if (oo != null) {
				if (!!aName) {
					this.aspectDict.push(aName, oo[aName]);
					oo[aName] = aVal;
					return aHandle;
				}
			}
		}
		return -1;
	},
	replaceStyleNamedFor : function(aHandle, aName, aVal) {
	},
	length : function() {
		return (this.stack.length);
	},
	init : function() {
		this.stack = [];
		this.ooStack = [];
		if ( (!!this.aspectDict) && (this.aspectDict != -1) ) {
			this.aspectDict.init();
		}
		if ( (!!this.stylesDict) && (this.stylesDict != -1) ) {
			this.stylesDict.init();
		}
		return this;
	},
	destructor : function() {
		if (!!this.aspectDict.id) {
			DictonaryObj.removeInstance(this.aspectDict.id);
		}
		if (!!this.stylesDict.id) {
			DictonaryObj.removeInstance(this.stylesDict.id);
		}
		return (this.id = GUIActionsObj.instances[this.id] = this.stylesDict = this.aspectDict = this.ooStack = this.stack = null);
	},
	dummy : function() {
		return false;
	}
};
