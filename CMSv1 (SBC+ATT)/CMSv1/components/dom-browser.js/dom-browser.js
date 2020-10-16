<!-- Original:  Cyanide_7 (leo7278@hotmail.com) -->
<!-- Web Site:  http://www7.ewebcity.com/cyanide7 -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

var objects = new Array(), browser = null, expanded = null;

// begin objects array with the document
objects[0] = new Array(document, "_document", false);

function openDOMBrowserFor(obj){
	// opens/reopens the window
	args = "width=800,height=600,left=20,top=20,scrollbars,resizable,top=0,left=0";
	browser = window.open('',"DOMBrowser",args);
	browser.focus();
	// clears the expanded array (to avoid infinate loops in the DOM)
	expanded = new Array();
	// document is about to be expanded
	expanded["_document"] = true;
	// writes HTML to the window
	browser.document.open("text/html","replace");
	browser.document.writeln("<HTML><HEAD><TITLE>DOM Browser</TITLE></HEAD>");
	browser.document.writeln("<BODY BGCOLOR=BBBBBB link=FFFFF vlink=FFFFF>");
	browser.document.writeln("<h3>document:</h3><ul>");
	// calls recurrsive property writing function
	getProps(obj);
	// finishes writing HTML and closes
	browser.document.writeln("</ul></BODY></HTML>");
	browser.document.close();
	// returns false for event handlers
	return false;
}

function openDOMBrowser(activeElement){
	// finds index of incoming object by its key
	activeIndex = arrayIndexOf(objects, activeElement, 1);
	// toggles its expanded boolean
	objects[activeIndex][2] = !objects[activeIndex][2];
	// opens/reopens the window
	args = "width=800,height=600,left=20,top=20,scrollbars,resizable,top=0,left=0";
	browser = window.open('',"DOMBrowser",args);
	browser.focus();
	// clears the expanded array (to avoid infinate loops in the DOM)
	expanded = new Array();
	// document is about to be expanded
	expanded["_document"] = true;
	// writes HTML to the window
	browser.document.open("text/html","replace");
	browser.document.writeln("<HTML><HEAD><TITLE>DOM Browser</TITLE></HEAD>");
	browser.document.writeln("<BODY BGCOLOR=BBBBBB link=FFFFF vlink=FFFFF>");
	browser.document.writeln("<h3>document:</h3><ul>");
	// calls recurrsive property writing function
	getProps(document);
	// finishes writing HTML and closes
	browser.document.writeln("</ul></BODY></HTML>");
	browser.document.close();
	// returns false for event handlers
	return false;
}

// recurrsive function to get properties of objects
function getProps(obj){
	// for loop to run through properties of incoming object
	for(var prop in obj){
	browser.document.writeln("<li>");
	// if the property is an object itself, but not null...
	if(typeof(obj[prop])=="object" && obj[prop]!=null){
		// get index of object in objects array
		valIndex = arrayIndexOf(objects, obj[prop], 0);
		// if not in index array, add it and create its key
		if(valIndex==-1){
			valIndex = objects.length;
			key = ((new Date()).getTime()%10000) + "_" + (Math.floor(Math.random()*10000));
			objects[valIndex] = new Array(obj[prop], key, false);
		}
		// write link for this object to call openDOMBrowser with its key
		browser.document.writeln("<b>"+prop+"</b> : <a href=\"javascript:void(0)\" onClick=\"window.opener.openDOMBrowser('"+
		objects[valIndex][1]+"');return false;\">"+(new String(obj[prop])).replace(/</g,"<")+"</a>");
		// determine whether object should be expanded/was already expanded
		if(objects[valIndex][2] && !expanded[objects[valIndex][1]]){
			// if it needs to be expanded, add to expanded array
			expanded[objects[valIndex][1]] = true;
			// write nested list tag and recurrsive call to getProps
			browser.document.writeln("<ul>");
			getProps(obj[prop]);
			browser.document.writeln("</ul>");
		}
	} else
		// if not an object, just write property, value pair
		try {
			browser.document.writeln("<b>"+prop+"</b> : " + (new String(obj[prop])).replace(/</g,"<"));
		} catch(e) {
		} finally {
		}
		browser.document.writeln("</li>");
   }
}

// function to find object in an array by field value
function arrayIndexOf(array, value, field){
	var found = false;
	var index = 0;
	while(!found && index < array.length){
	// field may be object reference or key
	if(array[index][field]==value)
		found = true;
		else
		index++;
	}
	return (found)?index:-1;
}

