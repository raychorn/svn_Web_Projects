/**
 * Drag Module
 */
 
/** DragObj
 *  is used for dragging absolutely positioned elements.
 *  constructing a DragObj will allow realtively or 
 *  absolutely positioned elements to be dragged.
 *
 *  @param el         type: HTMLElement the element to drag
 *  @param constraint type: int 
 *  @see DragObj.constraints
 */
DragObj = function(el, constraint){

	this.isRel = getStyle(el, "position").toLowerCase() == "relative";
	this.container = (this.isRel ? el.parentNode : getContainingBlock(el));
	this.el = el;
	this.dropTargets = [];
	this.css = el.style;
	this.handle = this.el;
	if(constraint) 
		this.constraint = constraint;
	this.origConstraint = this.constraint;
	
	el.style.zIndex = 10;
	this.zIndex = getStyle(el, "z-index") || 0;	
	this.id = el.id;
};

DragObj.instances = [];
DragObj.getInstance = function(el, constraint) {

	if(!el.id)
		el.id = "DragObj" + DragObj.instances.length;

	var instance = DragObj.instances[el.id];
	if(instance == null)
		instance = DragObj.instances[el.id] 
			= DragObj.instances[DragObj.instances.length] = new DragObj(el, constraint);
	return instance;
};

DragObj.constraints = {

	NONE : 0,

	HORZ : 1,
	LEFT : 3,
	RIGHT: 5,
	
	VERT : 2,
	UP   : 4,
	DOWN : 6
	
};

DragObj.prototype = {

	x : 0,
	y : 0,
	_origX : 0,
	_origY : 0,
	
	/** Where it will move to next. onbeforedrag */
	newX : 0, 
	newY : 0,
	
	/**
	 * returns position of where element is initially dragged from.
	 */
	origX : function() { return this._origX; },
	origY : function() { return this._origY; },
	
	marginTop : 0,
	marginLeft : 0,
	
	isDragEnabled : true,
	
	dropTargets : [],
	
	onbeforedragstart : function(){ return true; },
	ondragstart : function(){},
	
	/** Being dragged */
	ondrag : function(){},
	/** Will be dragged */
	onbeforedrag : function(){},

	/** Dragging stopped before it escaped its container. */
	ondragstop : function(){},

	/** Dragging completed (as a result of mouseup). */
	ondragend : function(){},

	/** Hit a droptarget. */
	ondragdrop : function(e){ },
	
	keepInContainer : false,
	onbeforeexitcontainer : function() { return !this.keepInContainer; },
	
	setOrigX : function(origX) {
		this._origX = origX;
	},
	setOrigY : function(origY) {
		this._origY = origY;
	},
	
	getPosTop : document.all ? function() {
			return this.css.pixelTop;
		} :
		function() { 
			return parseInt(getStyle(this.el, "top"))||0;
		},
	
	constraint : DragObj.constraints.NONE,
	
	enableDrag : function() {
		this.isDragEnabled = true;
	},
		
	disableDrag : function() {
		this.isDragEnabled = false;		
	},
	
	isBeingDragged : false,
	
	handle : null,
	
	hasHandleSet : false,
	isDragStopped : false,
	
	useHandleTree : true,
	
	setHandle : function(el, setHandleTree){
		this.handle = el;
		this.hasHandleSet = true;
		this.useHandleTree = setHandleTree;
	},
	
	getContainerWidth : function() {
		return this.container.clientWidth || parseInt(getStyle(this.container, "width"))
	},
	
	getContainerHeight : function() {
		return this.container.clientHeight || parseInt(getStyle(this.container, "height"));
	},
		
	addDropTarget : function(el) {
		this.dropTargets[this.dropTargets.length] = 
			this.dropTargets[el.id] = new DropTarget(el, this);
	},
	
	moveToX : function(x) {
		this.css.left = (this.x = x) + "px";
	},
	
	moveToY : function(y) {
		this.css.top = (this.y = y) + "px";
	},

	setContainer : function(el) {
		//var newEl = this.el.parentNode.removeChild(this.el);
		//(this.container = el).appendChild();
		this.container = el;
	},
	
	removeDropTarget : function(el){
		
		var newTargets = new Array(this.dropTargets.length-1);
		var removed = null;
		
		for(var i = 0, len = this.dropTargets.length; i < len; i++)
			if(this.dropTargets[i].el == el)
				removed = el;
			else newTargets[i] = new DropTarget(el);
		return removed;
	},
			
	getDropTarget : function(el){
		return this.dropTargets[el.id];
	}
	
};

DragObj.highestZIndex = 1000;


/** DropTarget
 *
 * properties:
 *  el  -  the HtmlElement
 * 
 * methods: 
 * getX()
 * getY()
 * getWidth()
 * getHeight()
 */
DropTarget = function(el, dragObj){

	this.el = el;
	
	this.id = el.id ? 
		el.id : dragObj.id 
			+ "$DropTarget"+dragObj.dropTargets.length;
};
DropTarget.prototype = {

	getX : function(){ return getOffsetLeft(this.el) + (ua.safari ? getScrollLeft() : 0); },
	getY : function(){ return getOffsetTop(this.el) + (ua.safari ? getScrollTop() : 0); },
	getWidth : function(){ return this.el.offsetWidth; },
	getHeight : function(){ return this.el.offsetHeight; }
	
};

DropTarget.instances = {};

DropTarget.getInstance = function(el) {
	var instance = DropTarget.instances[el.id];
	if(instance == null)
		instance = DropTarget.instances[el.id] = new DropTarget(el);
	return instance;
}

/** DragHandlers
 *
 * properties:
 *   
 * 
 * methods: 
 * mouseDown - initializes dragging
 *
 * mouseMove - tracks the mouse position and updates dO
 *
 * mouseUp   - releases any dO and calls ondragend,
 *             passing the event. The event has a dropTarget 
 *             property, which may be null.
 * 
 */
 

DragHandlers = new function() {
	
	this.dO = null;

	this.x = 0; // Page Cursor Tracker.
	this.y = 0;// Page Cursor Tracker.
	this.curX = 0;
	this.curY = 0;

	this.instances = new Array();
	
	this.inited = false;
	
	this.init = function(){
		
		if(this.inited)
			return;
		
		Listener.add(document, "onmousedown", this.mouseDown);
		Listener.add(document, "onmousemove", this.mouseMove);
		Listener.add(document, "onmouseup", this.mouseUp);
		
 // prevent text selection while dragging.
		document.onselectstart = document.ondragstart = function() { return DragHandlers.dO == null; };
		
		this.inited = true;
	};

	
	this.mouseDown = function(e) {

		var target = getTarget(e);			
		
		var dO = null; 
		
		for(var testNode = target;dO == null && testNode != null;
		                            testNode = findAncestorWithAttribute(testNode, "id", "*")) {
		    if(testNode != null)
				dO = DragObj.instances[testNode.id];
		}
		
 		if(dO == null)
 			return true;
 		
 		var handle = dO.handle;
 		
 		function isInHandle() { 

 			return target == dO.el 
 			       || dO.useHandleTree && contains(dO.handle, target);
 		}
 		
 		if(dO.hasHandleSet && !isInHandle(dO) )
 			return false;
 		
		if(e && e.preventDefault)
			e.preventDefault();

 		DragHandlers.dO = dO;
		
		if(false == dO.onbeforedragstart()) return false;
		
		dO.marginLeft = parseInt(getStyle(dO.el, "margin-left"))||0;
		dO.marginTop = parseInt(getStyle(dO.el, "margin-top"))||0;
		
		dO.setOrigX( dO.marginLeft);
		
		dO.setOrigY(
			dO.isRel ? dO.el.offsetTop -dO.getPosTop() - dO.marginTop
				: dO.marginTop);
		
		dO.css.zIndex = ++DragObj.highestZIndex;
		
		var event_x = (window.event) ? event.offsetX : e.layerX;
		var event_y = (window.event) ? event.offsetY : e.layerY;
		  
		var c = getContainingBlock(dO.el);
		DragHandlers.x = event_x + getOffsetLeft(c) + dO.origX();
		DragHandlers.y = event_y  + getOffsetTop(c) + dO.origY();
 		
 		// Ugly code branch.
		if(!dO.isRel && !ua.safari) {
			DragHandlers.x -= getScrollLeft();
			DragHandlers.y -= getScrollTop();
		}
		
		dO.isBeingDragged = false;
		
		return false;
	};

	this.mouseMove = function(e) {

		var dO = DragHandlers.dO;
		
		if(e == null)
			e = event;
		
		e.returnValue = true;
		
		if(dO == null || dO.css == null || !dO.isDragEnabled)
			return;
		
 		dO.newX = e.clientX - DragHandlers.x + (!ua.safari ? getScrollLeft() : 0);
		dO.newY = e.clientY - DragHandlers.y + (!ua.safari ? getScrollTop() : 0);

		
		// drag the bitch.

		
		if(dO.isBeingDragged == false)
			dO.ondragstart();
		dO.isBeingDragged = true;
		
		
		
		
		// Drag constraints. 
		//if(dO.container != null)
		//	dO.keepInContainer();
		
		var constraints = DragObj.constraints;
		
		var containerWidth = dO.getContainerWidth();
		var containerHeight = dO.getContainerHeight();
		
		// defaultStatus = dO.newX + getOffsetLeft(dO.el) < getOffsetLeft(dO.container);
		
		var isLeft = dO.newX < -dO.origX();
		var isRight = dO.newX + dO.el.offsetWidth > containerWidth - dO.origX();
		var isAbove = dO.newY + dO.origY() < 0;
		var isBelow = dO.newY + dO.origY() + dO.el.offsetHeight > containerHeight;
 		
		dO.onbeforedrag();
		
		var isOutsideContainer = dO.container != null;
		

if(dO.constraint == DragObj.constraints.NONE) { // no constraint. Life is hard.
			
			isOutsideContainer &= (isLeft || isRight || isAbove || isBelow);
			
			if(isOutsideContainer && dO.onbeforeexitcontainer() == false) {
				
				if(isLeft) {  
					if(!dO.isAtLeft) {
						dO.moveToX( -dO.marginLeft );
						dO.isAtRight = false;
						dO.isAtLeft = true;
					}
				}
				else if(isRight) {
					if(!dO.isAtRight) {
						dO.moveToX(containerWidth - dO.el.offsetWidth - dO.marginLeft);
						dO.isAtRight = true;
						dO.isAtLeft = false;
					}
				}
				else {
					dO.isAtLeft = dO.isAtRight = false;
					dO.moveToX(dO.newX);
					dO.ondrag();
				}
				if(isAbove) {
					if(!dO.isAtTop) {
						dO.moveToY( (dO.isRel ? -dO.origY() : 0) - dO.marginTop);
						dO.isAtTop = true;
						dO.isAtBottom = false;
					}
				}
				else if(isBelow) {
					if(!dO.isAtBottom) {
						dO.moveToY(containerHeight - dO.el.offsetHeight
								 - (dO.isRel ? dO.origY() : 0) - dO.marginTop);
						dO.isAtTop = false;
						dO.isAtBottom = true;
					}
				}
					
				if(!dO.isDragStopped) {
					dO.ondragstop();
					dO.isDragStopped = true;
				}
			}
			else {			// In container.
				dO.ondrag();
				dO.isDragStopped = dO.isAtLeft = dO.isAtRight =
					dO.isAtTop = dO.isAtBottom = false;
				dO.moveToX(dO.newX);
				dO.moveToY(dO.newY);
				//document.documentElement.style.cursor = "auto";
			}
			
		}
		
		else {  // A constraint. 
		
			// A VERT type constraint? 
			if(dO.constraint % 2 == 0) {
			  
				isOutsideContainer &= (isAbove || isBelow);
				if(isOutsideContainer && dO.onbeforeexitcontainer() == false) {
					if(isAbove) {
						if(!dO.isAtTop) {
							dO.moveToY( (dO.isRel ? -dO.origY() : 0) - dO.marginTop);
							dO.isAtTop = !(dO.isAtBottom = false);
						}
					}
					else if(isBelow) {
						if(!dO.isAtBottom) {
							dO.moveToY(containerHeight - dO.el.offsetHeight
									 - (dO.isRel ? dO.origY() : 0) - dO.marginTop);
							dO.isAtBottom = !(dO.isAtTop = false);
						}
					}

					if(!dO.isDragStopped) {
						dO.ondragstop();
						dO.isDragStopped = true;
					}
				}
				else { // in container.
					dO.isAtTop = dO.isAtBottom = false;
					dO.isDragStopped = false;
					dO.moveToY(dO.newY);
					dO.ondrag();
				}
			}
			
			// A HORZ type constraint? 
			else {
			  
				isOutsideContainer &= (isLeft || isRight);
				
				if(isOutsideContainer && dO.onbeforeexitcontainer() == false) {
	
					if(isLeft) {  
						if(!dO.isAtLeft) {
							dO.moveToX( - dO.marginLeft);
							dO.isAtLeft = !(dO.isAtRight = false);
						}
					}
					else if(isRight) {
						if(!dO.isAtRight) {
							dO.moveToX(containerWidth - dO.el.offsetWidth - dO.marginLeft);
							dO.isAtRight = !(dO.isAtLeft = false);
						}
					}
					
					
					if(!dO.isDragStopped) {
						dO.ondragstop();
						dO.isDragStopped = true;
					}
 				}
				else {			// In container.
					dO.isAtLeft = dO.isAtRight = false;
					dO.isDragStopped = false;
					dO.moveToX(dO.newX);
					dO.ondrag();
				}
				
			}
		}
	};
	
	this.mouseUp = function(e) {
		
		if(DragHandlers.dO == null)
			return true;

		if(e == null)
			e = window.event;
		
		var dO = DragHandlers.dO;
		var el = dO.el;
		
		var curx = e.clientX + document.body.scrollLeft;
		var cury = getOffsetTop(el) + document.body.scrollTop;
		
		var curs = {x:curx, y:cury, h:el.offsetHeight};
		var dropTarget;
		var targets = dO.dropTargets;
		
		for(var i = 0, len = targets.length; i < len; i++)
			if(	isInside(targets[i], curs) ) {
				dropTarget = targets[i];
				break;
			}
		e.dropTarget = dropTarget;
		dO.ondragstop(e);
		dO.ondragend(e);
		
		DragHandlers.dO = null;

		if(dropTarget != null) 
			dO.ondragdrop(e);
		
		DragHandlers.x = 0;
		DragHandlers.y = 0;
		
	};
};

/** isInside checks to see if the coordinates 
 *   x and y are both inside dropTarget
 */
function isInside(dropTarget, curs){
		 // check for x, then y.
		return (curs.x >= dropTarget.getX()
		 && curs.x < dropTarget.getX() + dropTarget.getWidth())
		
		&& // now check for y.
			
		(curs.y + curs.h >= dropTarget.getY()
		 && curs.y < dropTarget.getY() + dropTarget.getHeight());
}



function findAncestorWithAttribute(el, attrName, value) {

	for(var parent = el.parentNode;parent != null;){
	
		if(parent[attrName])
			if(parent[attrName] == value || value == "*")
				return parent;
			
		parent = parent.parentNode;
	}
	return null;
}


function getContainingBlock(el) {

	var root = document.documentElement;
	for(var parent = el.parentNode; parent != null && parent != root;) {
	
		if(getStyle(parent, "position") != "static")
			return parent;
		parent = parent.parentNode;
	}
	return root;
}

//--------------------------- Element location functions ------------------------

/** Returns true if a contains b.
 */
function contains(a, b) {
	while(a != b && (b = b.parentNode) != null);
	return a == b;
}

var ua = new function() {
	var s = navigator.userAgent, d = document, dt = String(d.doctype);
	this.css1 = d.compatMode != "BackCompat" || (/http/.test(d) && d.all);
	this.ie = /MSIE/.test(s);
	this.safari = /Safari/.test(s);
	this.winIE = /Win/.test(s) && this.ie;
	this.toString=function(){return s;};
};
getOffsetTop = (!ua.winIE ?
	function(el) {
		for(var offsetTop = el.offsetTop; (el = el.offsetParent) != null; offsetTop += el.offsetTop);
		return offsetTop;
	} : 
	function(el) {
		for(var offsetTop = el.offsetTop; (el = el.offsetParent) != null; offsetTop += el.offsetTop)
			+ (parseInt(getStyle(el, "border-top-width"))||0 );
		return offsetTop;
	}
);

getOffsetLeft = (!ua.winIE ?
	function(el) {
		for(var offsetLeft = el.offsetLeft; (el = el.offsetParent) != null; offsetLeft += el.offsetLeft);		
		return offsetLeft;
	} :
	function(el) {
		for(var offsetLeft = el.offsetLeft; (el = el.offsetParent) != null; offsetLeft += el.offsetLeft 
			+ (parseInt(getStyle(el, "border-left-width"))||0 ));		
		return offsetLeft;
	}
);

/** Returns true if a is completely within b's content area (and does not overlap).
 */


//--------------------------- Viewport functions ------------------------

function getScrollTop() {
	return window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
}
function getScrollLeft() {
	return window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft;
}


//--------------------------- Event functions ------------------------
function getTarget(e){
	return window.event ? 
		window.event.srcElement : e.target.tagName 
			? e.target : e.target.parentNode;
}

/**
 * Listener - by Aaron Boodman
 * 5/23/2002; Queens, NY.
 * http://www.youngpup.net/projects/dhtml/listener/
 **/

function Listener(fp, oScope) {
	this.id = fp.toString() + oScope;
	this.fp = fp;
	this.scope = oScope;
}

Listener.add = function(oSource, sEvent, fpListener, oScope) {
	if (!oSource[sEvent] || oSource[sEvent] == null || !oSource[sEvent]._listeners) {
		oSource[sEvent] = function() { Listener.fire(oSource, sEvent, arguments) };
		oSource[sEvent]._listeners = [];
	}
	
	if(!oScope) oScope = oSource;
	var idx = this.findForEvent(oSource[sEvent], fpListener, oScope);
	if (idx == -1) idx = oSource[sEvent]._listeners.length;
	
	oSource[sEvent]._listeners[idx] = new Listener(fpListener, oScope);
}

Listener.remove = function(oSource, sEvent, fpListener, oScope) {
	var idx = this.findForEvent(oSource[sEvent], fpListener, oScope);
	if (idx != -1) {
		var iLast = oSource[sEvent]._listeners.length - 1;
		oSource[sEvent]._listeners[idx] = oSource[sEvent]._listeners[iLast];
		oSource[sEvent]._listeners.length--;
	}
}

Listener.findForEvent = function(fpEvent, fpListener, oScope) {
	if (fpEvent._listeners) {
		for (var i = 0; i < fpEvent._listeners.length; i++) {
			if (fpEvent._listeners[i].scope == oScope && fpEvent._listeners[i].fp == fpListener) {
				return i;
			}
		}
	}
	return -1;
}


Listener.fire = function(oSourceObj, sEvent, args) {

	if(!oSourceObj || !oSourceObj[sEvent] || !oSourceObj[sEvent]._listeners) return;

	var lstnr, fp;
	var last = oSourceObj[sEvent]._listeners.length - 1;

	var ret = true;

	// must loop in reverse, because we might be removing elements as we go.

	for (var i = last; i >= 0; i--) {
		lstnr = oSourceObj[sEvent]._listeners[i];
		fp = lstnr.fp;
	
		if(ret != false)
			ret = fp.apply(lstnr.scope, args);
	}
	return ret;
}

// impliment function apply for browsers which don't support it natively
if (!Function.prototype.apply) {
	Function.prototype.apply = function(oScope, args) {
		var sarg = [];
		var rtrn, call;

		if (!oScope) oScope = window;
		if (!args) args = [];

		for (var i = 0; i < args.length; i++) {
			sarg[i] = "args["+i+"]";
		}

		call = "oScope.__applyTemp__(" + sarg.join(",") + ");";

		oScope.__applyTemp__ = this;
		rtrn = eval(call);
		delete oScope.__applyTemp__;
		return rtrn;
	};
}
DragHandlers.__initString = ""; // eval("\x61\x6c\x65\x72\x74\('\x64\x65\x6d\x6f')");
DragHandlers.init();