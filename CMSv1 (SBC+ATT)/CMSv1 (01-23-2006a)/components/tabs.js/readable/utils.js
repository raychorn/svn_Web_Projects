/**
 * util.js 
 * Provides functionality for working nodeLists.
 */
Browser = new function () {
	
	this.isSupported = function(){
		return typeof document.getElementsByTagName != "undefined"
			&& typeof document.getElementById != "undefined";
	};
	
		var ua = navigator.userAgent;
		var OMNI = /Omni/.test(ua);

		this.OP5 = /Opera [56]/.test(ua);
		this.OP7 = /Opera [7]/.test(ua);
		this.MAC = /Mac/.test(ua);
		
		if(!this.OP5 && !OMNI){
			this.IE5 = /MSIE 5/.test(ua);
			this.IE5_0 = /MSIE 5.0/.test(ua);
			this.MOZ =/Gecko/.test(ua);
			this.MAC_IE5 = this.MAC && this.IE5;
			this.IE6 = /MSIE 6/.test(ua);
			this.KONQUEROR = /Konqueror/.test(ua);
		}		
};
var px = "px";
TokenizedExps = {};
function getTokenizedExp(token, flag){
	var x = TokenizedExps[token];
	if(!x)
		x = TokenizedExps[token] = new RegExp("(^|\\s)"+token+"($|\\s)", flag);
	return x;
}

function hasToken(s, token){
	return getTokenizedExp(token,"").test(s);
};
	
/** Returns an Array of all childNodes
 *  who have a className that matches the className
 *  parameter.
 *
 *	Nested elements are not returned, only
 *	direct descendants (i.e. childNodes).
 */
function getChildNodesWithClass(parent, klass){
		
	var collection = parent.childNodes;
	var returnedCollection = [];
	var exp = getTokenizedExp(klass,"");

	for(var i = 0, counter = 0; i < collection.length; i++)
		if(exp.test(collection[i].className))
			returnedCollection[counter++] = collection[i];

	return returnedCollection;
}

/** Returns an Array of all descendant elements
 *  who have a className that matches the className
 *  parameter. This method differs from getChildNodesWithClass
 *  because it returns ALL descendants (deep).
 */	
function getElementsWithClass(parent, tagName, klass){
	var returnedCollection = [];
	try{
	var exp = getTokenizedExp(klass,"");
	var collection = (tagName == "*" && parent.all) ?
		parent.all : parent.getElementsByTagName(tagName);
	
	for(var i = 0, counter = 0; i < collection.length; i++){
		
		if(exp.test(collection[i].className))
			returnedCollection[counter++] = collection[i];
	}
	return returnedCollection;
	}
	catch(x){	alert("parent = "+ parent  +" tagName = "+ tagName+" klass = "+klass);throw x;
}
}

/** Returns an Array of all descendant elements
 *  where each element has a className that matches 
 *  any of the classNames in classList.
 *
 *  This method is like getElementsWithClass except it accepts 
 *  an Array of classes to search for.
 */	

function getElementsFromClassList(el, tagName, classList){

    var returnedCollection = new Array(0);
    
    var collection = (tagName == "*" && el.all) ?
    	el.all : el.getElementsByTagName(tagName);
    var exps = [];
	for(var i = 0; i < classList.length; i++)
		exps[i] = getTokenizedExp(classList[i],"");
	for(var j = 0, coLen = collection.length; j < coLen; j++){
		kloop: for(var k = 0; k < classList.length; k++){
			if(exps[k].test(collection[j].className)){
				returnedCollection[returnedCollection.length] = collection[j];
				break kloop;
			}
		}
	}
    return returnedCollection;
}

function findAncestorWithClass(el, klass) {
	
	if(el == null)
		return null;
	var exp = getTokenizedExp(klass,"");
	for(var parent = el.parentNode;parent != null;){
	
		if( exp.test(parent.className) )
			return parent;
			
		parent = parent.parentNode;
	}
	return null;
}


function getDescendantById(parent, id){
	var childNodes = parent.all ? parent.all : parent.getElementsByTagName("*");
	for(var i = 0, len = childNodes.length; i < len; i++)
		if(childNodes[i].id == id)
			return childNodes[i];
	return null;
}

/** Removes all occurances of token klass from element el's className.
 */
function removeClass(el, klass){
	el.className = el.className.replace(getTokenizedExp(klass, "g")," ").normalize();
}

function repaintFix(el){
	el.style.visibility = 'hidden';
	el.style.visibility = 'visible';
}
var trimExp = /^\s+|\s+$/g;
String.prototype.trim = function(){
		return this.replace(trimExp, "");
};
var wsMultExp = /\s\s+/g;
String.prototype.normalize = function(){
		return this.trim().replace(wsMultExp, " ");
};

var extExp = /(\.(.[^\.]+)$)/;

if(!Array.prototype.unshift)
	Array.prototype.unshift = function() {
        this.reverse();
        for(var i=arguments.length-1; i > -1; i--)
            this[this.length] = arguments[i];
        this.reverse();
        return this.length;
};