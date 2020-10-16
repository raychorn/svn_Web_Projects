/*
 menu_editor_core_obj.js -- menuEditorCoreObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

menuEditorCoreObj = function(id){
	this.id = id;				// the id is the position within the global ButtonBarObj.instances array
};

menuEditorCoreObj.instances = [];

menuEditorCoreObj.getInstance = function() {
	// the object.id is the position within the array that holds onto the objects...
	var instance = menuEditorCoreObj.instances[menuEditorCoreObj.instances.length];
	if(instance == null) {
		instance = menuEditorCoreObj.instances[menuEditorCoreObj.instances.length] = new menuEditorCoreObj(menuEditorCoreObj.instances.length);
	}
	return instance;
};

menuEditorCoreObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < menuEditorCoreObj.instances.length) ) {
		var instance = menuEditorCoreObj.instances[id];
		if (!!instance) {
			menuEditorCoreObj.instances[id] = object_destructor(instance);
			ret_val = (menuEditorCoreObj.instances[id] == null);
		}
	}
	return ret_val;
};

menuEditorCoreObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < menuEditorCoreObj.instances.length; i++) {
		menuEditorCoreObj.removeInstance(i);
	}
	return ret_val;
};

menuEditorCoreObj.prototype = {
	id : -1,
	old_Ellipsis_symbol : '...',
	menuArray : [],
	_global_menu_mode : false, // true for the new menu, false for the original menu...
	toString : function() {
		var s = 'id = [' + this.id + '] ';
		return s;
	},
	cleanUpMenuArray : function(mm) {  // clean-up the array by taking out things that are now null from the end of the array...
		while (mm[mm.length - 1] == null) {
			mm.pop();
		}
	
		var ix = 0;
		var toks = [];
		var _url = '';
		for (var ii = mm.length - 1; ii > 0; ii--) {
			if ((typeof mm[ii]) != const_object_symbol) {
				toks = mm[ii].split('|');
				if (toks.length > 0) {
					_url = toks[0].trim().URLDecode();
					if (_url.trim() == const_subMenuEnds_symbol.trim()) {
						ix++;
					} else {
						break;
					}
				}
			}
		}
		if (ix > 0) {
			for ( ; ix > 0; ix--) {
				mm.pop();
			}
		}
	},
	loadMenuEditor : function(sObj) {
		s = '';
		if (isObjValidHTMLValueHolder(sObj)) {
			s = sObj.value;
		}
		
		var menuArray_i = 0;
	
		var a = s.split(",");
		for (var i = 0; i < a.length; i++) {
			this.menuArray[this.menuArray.length] = a[i];
		}
	
		var somethingToDo = true;
		var lastBegin_i = -1;
		var lastEnd_i = -1;
	
		while (somethingToDo) {
			for (i = 0; i < this.menuArray.length; i++) {
				if (this.menuArray[i] == null) {
					break;
				}
				if ((typeof this.menuArray[i]) != const_object_symbol) {
					toks = this.menuArray[i].split("|");
					if (toks[0].URLDecode() == const_subMenu_symbol) {
						lastBegin_i = i;
					}
					if (toks[0].URLDecode() == const_subMenuEnds_symbol) {
						lastEnd_i = i;
						break;
					}
				}
			}
			somethingToDo = ( (lastBegin_i != -1) && (lastEnd_i != -1) );
			if (somethingToDo) {
				var container = new Array(0);
				for (i = lastBegin_i; i <= lastEnd_i; i++) {
					container[container.length] = this.menuArray[i];
				}
				this.menuArray[lastBegin_i] = container;
				
				var _d = lastBegin_i + 1;
				var _s = lastEnd_i + 1;
				for (; _s < this.menuArray.length; _s++) {
					this.menuArray[_d] = this.menuArray[_s];
					_d++;
				}
				for (; _d < this.menuArray.length; _d++) {
					this.menuArray[_d] = null;
				}
				
				lastBegin_i = -1;
				lastEnd_i = -1;
			}
		}
	
		this.cleanUpMenuArray(this.menuArray);
	},
	rebuildMenu : function(mm, includeLinks) {
		// this is a placeholder that signals that the menu needs to be rebuilt...
	},
	processMenuModeChange : function() {
		this._global_menu_mode = ((this._global_menu_mode == true) ? false : true);
		this.rebuildMenu(this.menuArray, true);
	},
	init : function() {
		return this;
	},
	destructor : function() {
		return (this.id = menuEditorCoreObj.instances[this.id] = null);
	},
	dummy : function() {
		return false;
	}
};
