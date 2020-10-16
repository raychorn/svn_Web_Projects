/*
 ajax_engine.js -- AJAXEngine
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

AJAXEngine = function(id){
	this.id = id;				// the id is the position within the global ButtonBarObj.instances array
	// create an array to store any errors that are found
	if(!u) this.throwError("No server gateway was specified.", true);
	if(!GatewayAPI.supported) this.throwError("Your browser does not meet the minimum requirements. \nPortions of the page have been disabled and therefore \nthe page may not work as expected.", true);

	this.url = u;

	this.enableCache = (GatewayAPI.opera5) ? false : true;

	this.mode = (!!_d && _d == true) ? this.debug_mode_symbol : this.release_mode_symbol;

	this.browser_is_opera = (/opera/i.test(navigator.userAgent));
	this.browser_is_ie = ( ( (/msie/i.test(navigator.userAgent)) || (/Gecko/i.test(navigator.userAgent)) || (/Firefox/i.test(navigator.userAgent)) || (/Netscape/i.test(navigator.userAgent)) || (this.browser_is_opera) ) );

	// hold current object in place holder
	this.idGateway = "idGatewayAPI_" + GatewayAPI.items.length;
	this.idForm = "idGatewayAPI_Form_" + GatewayAPI.items.length;
};

AJAXEngine.instances = [];

AJAXEngine.getInstance = function(url, _debugFlag) {
	// the object.id is the position within the array that holds onto the objects...
	var instance = AJAXEngine.instances[AJAXEngine.instances.length];
	if(instance == null) {
		instance = AJAXEngine.instances[AJAXEngine.instances.length] = new AJAXEngine(AJAXEngine.instances.length);
	}
	return instance;
};

AJAXEngine.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < AJAXEngine.instances.length) ) {
		var instance = AJAXEngine.instances[id];
		if (!!instance) {
			AJAXEngine.instances[id] = object_destructor(instance);
			ret_val = (AJAXEngine.instances[id] == null);
		}
	}
	return ret_val;
};

AJAXEngine.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < AJAXEngine.instances.length; i++) {
		AJAXEngine.removeInstance(i);
	}
	return ret_val;
};

AJAXEngine._cacheCounters = [];

AJAXEngine.xmlHttp_reqObject = function() {
	var oXmlHttpReqObj = new Object();
	
	if (!!oXmlHttpReqObj) {
		oXmlHttpReqObj.oRequest = false;
		oXmlHttpReqObj.oGateway = -1;
	}
	return oXmlHttpReqObj;
};

AJAXEngine._xmlHttp_reqObject = AJAXEngine.xmlHttp_reqObject();

AJAXEngine.prototype = {
	id : -1,
	build : '001-AJAXEngine',
	opera : (new RegExp("opera( |/)[56]", "i")).test(navigator.userAgent),
	opera5 : (new RegExp("opera( |/)5", "i")).test(navigator.userAgent),
	items : [],
	supported : (document.layers || document.all || document.getElementById),
	errors : [],
	cache : {},
	disabled : false,
	useWddx : false, // Cannot use the WDDX serailizer because we are using xmlHttpRequest() as an alternate mode of delivery...
	iframeSrc : null,
	html : "",
	sent : null,
	received : null,
	counter : 0,
	multithreaded : true,
	delay : 1,        // in milliseconds
	timeout : 60,      // in seconds
	statusReset : 3,  // in seconds
	statusdelay : 333,
	statusID : null,
	delayID : null,
	timeoutID : null,
	statusResetID : null,
	Get_symbol : 'get',
	method : this.Get_symbol,
	Idle_symbol : 'idle',
	status : this.Idle_symbol,
	Post_symbol = 'post',
	Received_symbol = 'received',
	Sending_symbol = 'sending',
	bof_cfajax_comment_symbol : '\/* BOF CFAJAX *\/',
	eof_cfajax_comment_symbol : '\/* EOF CFAJAX *\/',
	release_mode_symbol : "release",
	debug_mode_symbol : "debug",
	isFrameShown : false,
	isXmlHttpPreferred : false, // make this true to favor using xmlHttpRequest() if possible however if doing so is not possible the default behavior is to use the iFrame/iLayer method instead.
	js_global_varName : 'qObj', // the default is qObj for simplcity...
	currentContextName : '',
	namedContextCache : [], // holds named contexts of parms that are auto-sent with each AJAX Session. "this.namedContextCache[aName] = new Object(); this.namedContextCache[aName].queryString, this.namedContextCache[aName].parmsDict, this.namedContextCache[aName].argsDict"
	namedContextStack : [], // holds named contexts as a LIFO buffer. each array item holds aName
	toString : function() {
		var s = 'id = [' + this.id + '], ';
		return s;
	},
	onReceive : function() {}, // define onReceive(); callBack prototype
	onSend : function() {},    // define onSend(); callBack prototype
	onTimeout : function() {   // define onTimeout(); callBack prototype
		this.throwError("(Warning) The current request has timed out. Please \ntry your request again.");
	},
	setMethodGet : function() {
		this.method = this.Get_symbol;
		return (this.method);
	},
	setMethodPost : function() {
		this.method = this.Post_symbol;
		return (this.method);
	},
	isMethodGet : function() {
		return (this.method == this.Get_symbol);
	},
	isMethodPost : function() {
		return (this.method == this.Post_symbol);
	},
	isWddxEnabled : function() {
		return (!!window.WddxSerializer && this.useWddx);
	},
	getUrl = function() {
		return this.url + ((this.url.indexOf("?") == -1) ? "?" : "&") + "uuid=" + uuid();
	},
	isReleaseMode : function() {
		return (this.mode == this.release_mode_symbol);
	},
	isDebugMode : function() {
		return (this.mode == this.debug_mode_symbol);
	},
	setReleaseMode : function() {
		this.mode = this.release_mode_symbol;
	},
	setDebugMode : function() {
		this.mode = this.debug_mode_symbol;
	},
// +++
	create : function() {  // // define create(); prototype
		this.setDebugMode();
		this.top = ((this.isReleaseMode()) ? "0" : "650") + 'px';
		this.left = ((this.isReleaseMode()) ? "0" : "0") + 'px';
		this.width = ((this.isReleaseMode()) ? "1" : "990") + 'px';
		this.height = ((this.isReleaseMode()) ? "1" : "475") + 'px';
		this.bgcolor = (this.isReleaseMode()) ? "#ffffff" : "#FFFFBF";
		this.setReleaseMode();
		this.visibility = (this.isReleaseMode()) ? ((document.layers) ? "hide" : "hidden") : ((document.layers) ? "show" : "visible");
	
		if( this.disabled ) return false;
	
		this.createCSS();
		this.createFrame();
		this.createForm();
	
		document.write(this.html);
	},
	hideFrame : function() {
		if (this.isDebugMode()) {
			var oo = getGUIObjectInstanceById(this.idGateway);
			if (!!oo) {
				oo.style.visibility = ((document.layers) ? "hide" : "hidden");
				this.visibility = oo.style.visibility;
				this.isFrameShown = false;
			}
			var ooTable = getGUIObjectInstanceById('table_' + this.idGateway);
			if (!!ooTable) {
				ooTable.style.visibility = ((document.layers) ? "hide" : "hidden");
			}
		}
	},
	showFrame : function() {
		if (this.isDebugMode()) {
			var oo = getGUIObjectInstanceById(this.idGateway);
			if (!!oo) {
				oo.style.visibility = ((document.layers) ? "show" : "visible");
				this.visibility = oo.style.visibility;
				this.isFrameShown = true;
			}
			var ooTable = getGUIObjectInstanceById('table_' + this.idGateway);
			if (!!ooTable) {
				ooTable.style.visibility = ((document.layers) ? "show" : "visible");
			}
		}
	},
	throwError : function(error, _disable) {  // // define throwError(); prototype
		var disable = (typeof _disable == "boolean") ? _disable : false;
		this.errors[this.errors.length++] = error;
		if( this.status == this.Sending_symbol ) this.receivePacket(null, false);
		if( disable ) this.disabled = true;
		
		this.showFrame();
	
		alert(error);
	},
	createCSS : function() {  // define createCSS(); prototype
		this.html += "<style type=\"text\/css\">\n";
	//	this.html += "#" + this.idGateway + " {position:absolute; width: " + this.width + "px; height: " + this.height + "px; clip:rect(0px " + this.width + "px " + this.height + "px 0px); visibility: " + this.visibility + "; background: " + this.bgcolor + "; }\n";
	//	this.html += "#" + this.idGateway + " {position:absolute; width: " + this.width + "; height: " + this.height + "; top: " + this.top + "; left: " + this.left + " visibility: " + this.visibility + "; background: " + this.bgcolor + "; }\n";
		this.html += "#" + this.idGateway + " {width: " + this.width + "; height: " + this.height + "; left: " + this.left + " visibility: " + this.visibility + "; background: cyan; }\n";
		this.html += "#table_" + this.idGateway + " {position:absolute; width: " + this.width + "; top: " + (parseInt(this.top) - 20) + "px; left: " + this.left + " visibility: " + this.visibility + "; background: " + this.bgcolor + "; }\n";
		this.html += "</style>\n";
	},
	createForm : function() {  // define createForm(); prototype
		this.html += "<form name=\"" + this.idForm + "\" action=\"" + this.url + "\" target=\"" + this.idGateway + "\" method=\"post\" style=\"width:0px; height:0px; margin:0px 0px 0px 0px;\">\n";
		if (this.isWddxEnabled()) {
			this.html += "<input type=\"Hidden\" name=\"wddx\" value=\"\">";
		} else {
			this.html += "<input type=\"Hidden\" name=\"packet\" value=\"\">";
		}
		this.html += "</form>\n";
	},
	createFrame : function() {  // define createFrame(); prototype
		var sSrc = (typeof this.iframeSrc == "string") ? "src=\"" + this.iframeSrc + "\" " : (GatewayAPI.opera) ? "src=\"opera:about\" " : "";
		this.html += '<table id="' + 'table_' + this.idGateway + '" border="1" bgcolor="' + this.bgcolor + '" cellpadding="-1" cellspacing="-1" style="visibility: ' + this.visibility + '">';
		this.html += '<tr>';
		this.html += '<td>';
		if (document.layers) this.html += "<ilayer name=\"" + this.idGateway + "\" id=\"" + this.idGateway + "\" width=\"" + this.width + "\" height=\"" + this.height + "\" bgcolor=\"" + this.bgcolor + "\" visibility=\"" + this.visibility + "\"></ilayer>\n";
		else this.html += "<iframe " + sSrc + "width=\"" + this.width + "\" height=\"" + this.height + "\" name=\"" + this.idGateway + "\" id=\"" + this.idGateway + "\" frameBorder=\"1\" frameSpacing=\"0\" marginWidth=\"0\" marginHeight=\"0\" scrolling=\"Auto\"></iframe>\n";
		this.html += '</td>';
		this.html += '</tr>';
		this.html += '</table>';
	//	else this.html += ((this.isReleaseMode()) ? "" : '<table bgcolor="' + this.bgcolor + '" cellpadding="-1" cellspacing="-1"><tr><td bgcolor="silver" align="center"><small><b>Hidden Iframe</b></small></td></tr><tr><td align="left">') + "<iframe " + sSrc + "width=\"" + this.width + "\" height=\"" + this.height + "\" name=\"" + this.idGateway + "\" id=\"" + this.idGateway + "\" frameBorder=\"1\" frameSpacing=\"0\" marginWidth=\"0\" marginHeight=\"0\"></iframe>\n" + ((this.isReleaseMode()) ? "" : "</td></tr></table>");
	},
	serverTimeout : function(id) {  // define serverTimeout(); prototype
		if( this.status == this.Sending_symbol && this.counter == id ){
			this.status = "timedout";
			clearInterval(this.statusID);  // stop updating status bar
			if (this.isDebugMode()) window.status = "";
			this.timeoutID = null;
			this.onTimeout();
		}
	},
	resetStatus : function() {  // define resetStatus(); prototype
		this.status = this.Idle_symbol;
		this.statusResetID = null;
	},
	receivePacket = function(packet, _bRunEvent) {  // define receivePacket(); prototype
		if( this.disabled || this.status == "timedout" ) return false;
		var b = (typeof _bRunEvent != "boolean") ? true : _b;
	
		clearInterval(this.statusID);  // stop updating status bar
		if (this.isDebugMode()) window.status = "";
	
		this.received = packet;  // initialize the wddx packet to server
	
		if( this.cacheResults == true ){
			this.cache[this.packetString] = packet;
			this.cacheResults = null;
		}
	
		if( b ) this.onReceive();  // run the onReceive function
	
		clearInterval(this.statusID);  // stop updating status bar
		this.statusID = null;
		this.status = this.Received_symbol;
	
		// make sure to reset the status
		this.statusResetID = setTimeout(this.id + ".resetStatus();", this.statusReset * 1000);
	},
	sendPacket : function(packet, _bUseCache) {  // define sendPacket(); prototype
		if( this.disabled ) return false;
		var bUseCache = (typeof _bUseCache == "boolean") ? _bUseCache : true;
	
		this.onSend();  // run the onSend function
	
		if( !this.multithreaded && this.status == this.Sending_symbol ) return false;
		if( !!this.delayID ) clearTimeout(this.delayID);
		if( !!this.statusResetID ) clearTimeout(this.statusResetID);
	
		// tag the data stream with the name of the this.js_global_varName to ensure the AJAX server responds are required...
		this.sent = '&___jsName___=' + this.js_global_varName + packet;
		
		this.delayID = setTimeout(this.id + ".serializeAndSend(" + String(bUseCache) + ")", this.delay);
	},
	isReceivedFromCFAjax : function() {
		if ( (!!this.received) && (typeof this.received != const_object_symbol) ) {
			var bof_f = this.received.toUpperCase().indexOf(this.bof_cfajax_comment_symbol.toUpperCase());
			var eof_f = this.received.toUpperCase().indexOf(this.eof_cfajax_comment_symbol.toUpperCase());
			return ( (bof_f >= 0) && (eof_f >= 0) && (bof_f < eof_f) );
		} else {
			return false;
		}
	},
	processReqChange : function() {
	    if ( (!!AJAXEngine._xmlHttp_reqObject.oRequest) && (AJAXEngine._xmlHttp_reqObject.oRequest.readyState == 4) ) {
	        try {
	            if (AJAXEngine._xmlHttp_reqObject.oRequest.status && AJAXEngine._xmlHttp_reqObject.oRequest.status == 200) {
					var response = AJAXEngine._xmlHttp_reqObject.oRequest.responseText;
				 	response = response.stripCrLfs();
					var bof_f = response.toUpperCase().indexOf(this.bof_cfajax_comment_symbol.toUpperCase());
					var eof_f = response.toUpperCase().indexOf(this.eof_cfajax_comment_symbol.toUpperCase());
					if (eof_f > 0) {
						eof_f += this.eof_cfajax_comment_symbol.length; // skip over the comment header...
					}
					if (bof_f > 0) {
						response = response.substring(Math.min(bof_f, eof_f),Math.max(bof_f, eof_f));
					}
					if (!!AJAXEngine._xmlHttp_reqObject.oGateway) {
						AJAXEngine._xmlHttp_reqObject.oGateway.receivePacket(response);
					}
	            } else {
					var response = AJAXEngine._xmlHttp_reqObject.oRequest.responseText;
	                alert('xmlHttp Error:\n' + response.stripCrLfs());
	            }
	        } catch (ex) {
				jsErrorExplainer(ex, 'B. loadXMLDoc');
	        }
		}
	},
	loadXMLDoc : function(url) {
		var bool = false;
	    if (window.XMLHttpRequest) { // branch for native XMLHttpRequest object
	    	try {
				AJAXEngine._xmlHttp_reqObject.oRequest = new XMLHttpRequest();
				bool = true;
	        } catch(e) {
				AJAXEngine._xmlHttp_reqObject.oRequest = false;
				bool = false;
	        }
	    } else if (window.ActiveXObject) {  // branch for IE/Windows ActiveX version
	       	try {
	        	AJAXEngine._xmlHttp_reqObject.oRequest = new ActiveXObject("Msxml2.XMLHTTP");
				bool = true;
	      	} catch(e) {
	        	try {
	          		AJAXEngine._xmlHttp_reqObject.oRequest = new ActiveXObject("Microsoft.XMLHTTP");
					bool = true;
	        	} catch(e) {
	          		AJAXEngine._xmlHttp_reqObject.oRequest = false;
					bool = false;
	        	}
			}
	    }
	
		try {
			switch (this.method) {
				case this.Post_symbol:
					if (AJAXEngine._xmlHttp_reqObject.oRequest) {
						AJAXEngine._xmlHttp_reqObject.oRequest.onreadystatechange = this.processReqChange;
						AJAXEngine._xmlHttp_reqObject.oGateway = this; // allow the this.processReqChange function to be aware of the instance of the Gateway object it should interact with upon completion.
	
						var a = url.split('?');
						if (a.length == 2) {
							AJAXEngine._xmlHttp_reqObject.oRequest.open("POST", a[0], true);
							AJAXEngine._xmlHttp_reqObject.oRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");			
			                AJAXEngine._xmlHttp_reqObject.oRequest.send('QUERY_STRING=' + a[1].URLEncode());
						} else {
							bool = false;
						}
					}
				break;
		
				case this.Get_symbol:
					if (AJAXEngine._xmlHttp_reqObject.oRequest) {
						AJAXEngine._xmlHttp_reqObject.oRequest.onreadystatechange = this.processReqChange;
						AJAXEngine._xmlHttp_reqObject.oGateway = this; // allow the this.processReqChange function to be aware of the instance of the Gateway object it should interact with upon completion.
						AJAXEngine._xmlHttp_reqObject.oRequest.open("GET", url, true);
						AJAXEngine._xmlHttp_reqObject.oRequest.send(null);
					}
				break;
			}
		} catch(e) {
			bool = false;
			jsErrorExplainer(e, 'loadXMLDoc :: ERROR ' + this.method + ', bool = [' + bool + ']');
		}
		return bool;
	},
	serializeAndSend : function(_bUseCache) {  // define sendPacket(); prototype
		if( this.disabled ) return false;
	
		this.counter++;  // update window status
		this.delayID = null; // clear the delay timeout
		this.received = null; // clear the received packet
		this.status = this.Sending_symbol;
		if (this.isDebugMode()) window.status = "Sending.";
		AJAXEngine._cacheCounters[this.counter] = 0;
		if( !!this.statusID ) clearInterval(this.statusID);
		var s_ticker = "AJAXEngine._cacheCounters[" + this.counter + "]++;";
		if (this.isDebugMode()) {
			s_ticker += " window.status = window.status + (((AJAXEngine._cacheCounters[" + this.counter + "] % " + parseInt((1000/this.statusdelay).toString()) + ") == 0) ? (AJAXEngine._cacheCounters[" + this.counter + "] / " + parseInt((1000/this.statusdelay).toString()) + ").toString() : '.')";
		}
		this.statusID = setInterval(s_ticker, this.statusdelay);
		this.timeoutID = setTimeout(this.id + ".serverTimeout(" + this.counter + ")", this.timeout * 1000);
	
		if (this.isCurrentContextValid()) {
			// BEGIN: Apply the current named context, if it is valid, to the command stream...
			var argCnt = -1;
			var keys = [];
			var isContextShifted = false;
			var aDict = DictionaryObj.getInstance(this.sent.URLDecode());
			var tDict = this.namedContextCache[this.currentContextName].argsDict;
			var oDict = tDict;
	
			argCnt = this.namedContextCache[this.currentContextName].argsDict.length();
			var apparentArgCnt = parseInt(aDict.getValueFor('argCnt'));
			if (!apparentArgCnt) {
				apparentArgCnt = 0;
				aDict.push('argCnt', apparentArgCnt);
			}
			if (apparentArgCnt > 0) {
				tDict = DictionaryObj.getInstance();
	
				function adjustAndStoreEachKey(aKey) { 
					var newKey = aKey.filterInAlpha() + (parseInt(aKey.filterInNumeric()) + apparentArgCnt);
					tDict.push(newKey, oDict.getValueFor(aKey));
					return newKey;
				}
	
				keys = this.namedContextCache[this.currentContextName].argsDict.adjustKeyNames(adjustAndStoreEachKey);
				isContextShifted = true;
			}
			apparentArgCnt += argCnt;
			aDict.put('argCnt', apparentArgCnt);
			this.sent = aDict.asQueryString().URLEncode();
			argCnt = apparentArgCnt;
			this.sent += tDict.asQueryString().URLEncode();
			DictionaryObj.removeInstance(aDict.id);
			if (isContextShifted) DictionaryObj.removeInstance(tDict.id);
			// END! Apply the current named context, if it is valid, to the command stream...
		}
	
		if (this.isXmlHttpPreferred == false) {
			// this allows the user to choose to use xmlHttpRequest() as the preferred method along with the choice to use Gets or Posts because Posts can traverse cross domains when xmlHttpRequest() is used.
			var formattedPacket = this.formatPacket(this.sent);
			if (formattedPacket.length > 2000) {
				this.setMethodPost(); // switch to Post BEFORE the requested action crashes the server process via a buffer overflow...
			} else {
				this.setMethodGet(); // switch to Get to save some processing time for small packets...
			}
		}
	
		// send data to server
		switch (this.method) {
			case this.Post_symbol:
				if (this.isXmlHttpPreferred) {
					var bool = this.loadXMLDoc(this.getUrl() + '&cfajax=1' + '&' + this.sent);
					if (bool == false) {
						this.methodPost(this.sent, _bUseCache);
					}
				} else {
					this.methodPost(this.sent, _bUseCache);
				}
			break;
	
			case this.Get_symbol:
				if (this.isXmlHttpPreferred) {
					var bool = this.loadXMLDoc(this.getUrl() + '&cfajax=1' + '&' + this.sent);
					if (bool == false) {
						this.methodGet(formattedPacket, _bUseCache);
					}
				} else {
					this.methodGet(formattedPacket, _bUseCache);
				}
			break;
		}
	},
	formatPacket : function(packet) {
		if( this.isWddxEnabled() ){
			var oWddx = new WddxSerializer();  // create serializer object
			return "&wddx=" + oWddx.serialize(packet);
		} else {
			if( typeof packet == "string" ) return packet; // "&data=" + packet;
			else if( typeof packet == "object" ){
				var p = [];
				for( var k in packet ) p[p.length] = k + "=" + escape(packet[k]);
				return "&" + p.join("&");
			}
		}
	},
	methodPost : function(packet, _bUseCache) {
		if (this.browser_is_ie == false)
			return alert("The post method is currently unsupported. Netscape v4.0 does not support posting to a layer.");
		if (this.disabled) return false;
		oForm = document[this.idForm];
		if (oForm) {
			if (this.isWddxEnabled()) {
				var oWddx = new WddxSerializer();  // create serializer object
				packet = oWddx.serialize(packet);
				oForm.wddx.value = packet;
			} else {
				oForm.packet.value = packet;
			}
			oForm.submit();  // submit the packet to the server
		}
	},
	methodGet : function(fPacket, _bUseCache){
		var sPacket = fPacket;  // get the packet to send to the server
	
		var sUrl = this.getUrl() + sPacket;  // generate the url and packet to send
	
		// check to see if you should use a cached version of the request
		// and if so, pass the cached results to the recievePacket method
		if (this.enableCache && (_bUseCache == true) && !!this.cache[sPacket]) return this.receivePacket(this.cache[sPacket]);
	
		this.cacheResults = (this.enableCache && (_bUseCache == true));
		this.packetString = sPacket;
	
		try {
			if( !!document.getElementById && !!document.getElementById(this.idGateway).contentDocument ) {  // if IE then change the location of the IFRAME
				document.getElementById(this.idGateway).contentDocument.location.replace(sUrl);             // this loads the URL stored in the sUrl variable into the hidden frame
			} else if( GatewayAPI.opera ){
				document.getElementById(this.idGateway).location.replace(sUrl);
			} else if( document.all ){
				document[this.idGateway].location.replace(sUrl);  // this loads the URL stored in the sUrl variable into the hidden frame
			} else if( document.layers ){  // otherwise, change Netscape v4's ILAYER source file
				document[this.idGateway].src = sUrl;  // this loads the URL stored in the sUrl variable into the hidden frame
			}
		} catch(e) {
			alert('Programming Error... The Programmer obviously forgot to initialize the JSAPI Interface properly.');
			return;
		} finally {
		}
	},
	iterateNamedContexts : function(func) {
		var i = -1;
		if ( (!!func) && (typeof func == const_function_symbol) ) {
			for (i = 1; i < this.namedContextStack.length; i++) {
				func(this.namedContextStack[i]);
			}
		}
	},
	addNamedContext : function(aName, parmsQueryString) {
		var aDict = -1;
		var oDict = -1;
		var pDict = -1;
		var argCnt = -1;
		var keys = '';
		var i = -1;
		var j = -1;
		var v = '';
		if (!this.namedContextCache[aName]) {
			aDict = DictionaryObj.getInstance(parmsQueryString);
			oDict = DictionaryObj.getInstance();
			pDict = DictionaryObj.getInstance();
			argCnt = aDict.length();
			keys = aDict.getKeys();
			for (i = 0, j = 1; i < keys.length; i++, j += 2) {
				oDict.push('arg' + j, keys[i]);
				v = aDict.getValueFor(keys[i]);
				oDict.push('arg' + (j + 1), v);
				pDict.push(keys[i], v);
			}
			DictionaryObj.removeInstance(aDict.id);
			this.namedContextCache[aName] = AJaxContextObj.getInstance(); 
			this.namedContextCache[aName].queryString = parmsQueryString;
			this.namedContextCache[aName].parmsDict = pDict;
			this.namedContextCache[aName].argsDict = oDict;
			this.namedContextStack.push(aName);
			this.currentContextName = aName;
		}
	},
	setContextName : function(aName) {
		if (!!this.namedContextCache[aName]) {
			this.currentContextName = aName;
		} else {
			alert('ERROR: Programming Error - Context Name (' + aName + ') is not valid at this time - the list of valid Context Names is (' + this.namedContextStack + ').');
		}
	},
	isCurrentContextValid : function() {
		return (!!this.namedContextCache[this.currentContextName]);
	},
	isIdle : function() {
		return ( (this.status.trim().toUpperCase() == this.Idle_symbol.trim().toUpperCase()) || ( (this.status.trim().toUpperCase() != this.Received_symbol.trim().toUpperCase()) && (this.status.trim().toUpperCase() != this.Sending_symbol.trim().toUpperCase()) ) );
	},
	init : function() {
		return this;
	},
	destructor : function() {
		return (this.id = AJAXEngine.instances[this.id] = this.data = this.names = null);
	},
	dummy : function() {
		return false;
	}
};

