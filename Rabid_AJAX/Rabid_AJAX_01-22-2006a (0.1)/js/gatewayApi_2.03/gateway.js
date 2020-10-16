/******************************************************************************
 Rabid_AJAX v0.1

 Author: Ray C Horn (c). Copyright 2006, Hierarchical Application Limited
 Date:   01-19-2006
 Build:  001
******************************************************************************/
_cache_counters_GatewayAPI = [];

xmlHttp_reqObject = new Object();

if (xmlHttp_reqObject) {
	xmlHttp_reqObject.oRequest = false;
	xmlHttp_reqObject.oGateway = -1;
}

const_bof_cfajax_comment = '\/* BOF CFAJAX *\/';
const_eof_cfajax_comment = '\/* EOF CFAJAX *\/';

const_release_mode_symbol = "release";
const_debug_mode_symbol = "debug";

function _GatewayAPI(){
	this.build = "203-Rabid";
	this.items = [];
	this.opera = (new RegExp("opera( |/)[56]", "i")).test(navigator.userAgent);
	this.opera5 = (new RegExp("opera( |/)5", "i")).test(navigator.userAgent);
	this.supported = (document.layers || document.all || document.getElementById);
}
GatewayAPI = new _GatewayAPI();

_GatewayAPI.prototype.register = function (o){
	var i = this.items.length;
	this.items[i] = o;
	return "GatewayAPI.items['" + i + "']";
}
/*
// define Gateway object
function Gateway(u, _d){
	// create an array to store any errors that are found
	this.errors = [];
	this.cache = {};
	if(!u) this.throwError("No server gateway was specified.", true);
	if(!GatewayAPI.supported) this.throwError("Your browser does not meet the minimum requirements. \nPortions of the page have been disabled and therefore \nthe page may not work as expected.", true);

	this.disabled = false;
	this.url = u;
	this.useWddx = false; // (!!window.WddxSerializer); // Cannot use the WDDX serailizer because we are using xmlHttpRequest() as an alternate mode of delivery...
	this.enableCache = (GatewayAPI.opera5) ? false : true;
	this.iframeSrc = null;

	this.mode = (!!_d && _d == true) ? const_debug_mode_symbol : const_release_mode_symbol;
	this.html = "";
	this.sent = null;
	this.received = null;
	this.counter = 0;
	this.status = this.constIdle_symbol();
	this.multithreaded = true;
	this.delay = 1;        // in milliseconds
	this.timeout = 60;      // in seconds
	this.statusReset = 3;  // in seconds
	this.statusdelay = 333;
	this.statusID = null;
	this.delayID = null;
	this.timeoutID = null;
	this.statusResetID = null;
	this.method = this.constGet_symbol();
	this.isFrameShown = false;
	this.browser_is_opera = (/opera/i.test(navigator.userAgent));
	this.browser_is_ie = ( ( (/msie/i.test(navigator.userAgent)) || (/Gecko/i.test(navigator.userAgent)) || (/Firefox/i.test(navigator.userAgent)) || (/Netscape/i.test(navigator.userAgent)) || (this.browser_is_opera) ) );
	this.isXmlHttpPreferred = false; // make this true to favor using xmlHttpRequest() if possible however if doing so is not possible the default behavior is to use the iFrame/iLayer method instead.
	this.js_global_varName = 'qObj'; // the default is qObj for simplcity...
	
	this.currentContextName = '';
	this.namedContextCache = []; // holds named contexts of parms that are auto-sent with each AJAX Session. "this.namedContextCache[aName] = new Object(); this.namedContextCache[aName].queryString, this.namedContextCache[aName].parmsDict, this.namedContextCache[aName].argsDict"
	this.namedContextStack = []; // holds named contexts as a LIFO buffer. each array item holds aName
	
	// hold current object in place holder
	this.idGateway = "idGatewayAPI_" + GatewayAPI.items.length;
	this.idForm = "idGatewayAPI_Form_" + GatewayAPI.items.length;

	this.id = GatewayAPI.register(this);
}

Gateway.prototype.iterateNamedContexts = function(func){
	var i = -1;
	if ( (!!func) && (typeof func == const_function_symbol) ) {
		for (i = 1; i < this.namedContextStack.length; i++) {
			func(this.namedContextStack[i]);
		}
	}
}

Gateway.prototype.addNamedContext = function(aName, parmsQueryString){
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
		this.namedContextCache[aName] = new Object(); 
		this.namedContextCache[aName].queryString = parmsQueryString;
		this.namedContextCache[aName].parmsDict = pDict;
		this.namedContextCache[aName].argsDict = oDict;
		this.namedContextStack.push(aName);
		this.currentContextName = aName;
	}
}

Gateway.prototype.setContextName = function(aName){
	if (!!this.namedContextCache[aName]) {
		this.currentContextName = aName;
	} else {
		alert('ERROR: Programming Error - Context Name (' + aName + ') is not valid at this time - the list of valid Context Names is (' + this.namedContextStack + ').');
	}
}

Gateway.prototype.isCurrentContextValid = function(){
	return (!!this.namedContextCache[this.currentContextName]);
}

Gateway.prototype.isIdle = function(){
	return ( (this.status.trim().toUpperCase() == this.constIdle_symbol().trim().toUpperCase()) || ( (this.status.trim().toUpperCase() != this.constReceived_symbol().trim().toUpperCase()) && (this.status.trim().toUpperCase() != this.constSending_symbol().trim().toUpperCase()) ) );
}

Gateway.prototype.constIdle_symbol = function(){
	return ("idle");
}

Gateway.prototype.constGet_symbol = function(){
	return ("get");
}

Gateway.prototype.constPost_symbol = function(){
	return ("post");
}

Gateway.prototype.constReceived_symbol = function(){
	return ("received");
}

Gateway.prototype.constSending_symbol = function(){
	return ("sending");
}

Gateway.prototype.setMethodGet = function(){
	this.method = this.constGet_symbol();
	return (this.method);
}

Gateway.prototype.setMethodPost = function(){
	this.method = this.constPost_symbol();
	return (this.method);
}

Gateway.prototype.isMethodGet = function(){
	return (this.method == this.constGet_symbol());
}

Gateway.prototype.isMethodPost = function(){
	return (this.method == this.constPost_symbol());
}

Gateway.prototype.isWddxEnabled = function(){
	return (!!window.WddxSerializer && this.useWddx);
}

Gateway.prototype.getUrl = function(){
	var uuid = ((this.url.indexOf("?") == -1) ? "?" : "&") + "uuid=" + (new Date().getTime() + "" + Math.floor(1000 * Math.random()));
	return this.url + uuid;
}

// define Gateway onReceive(); prototype
Gateway.prototype.onReceive = function(){}

// define Gateway onSend(); prototype
Gateway.prototype.onSend = function(){}

// define Gateway onTimeout(); prototype
Gateway.prototype.onTimeout = function(){
	this.throwError("(Warning) The current request has timed out. Please \ntry your request again.");
}

Gateway.prototype.isReleaseMode = function(){
	return (this.mode == const_release_mode_symbol);
}

Gateway.prototype.isDebugMode = function(){
	return (this.mode == const_debug_mode_symbol);
}

Gateway.prototype.setReleaseMode = function(){
	this.mode = const_release_mode_symbol;
}

Gateway.prototype.setDebugMode = function(){
	this.mode = const_debug_mode_symbol;
}

Gateway.prototype.create = function(){
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
}

Gateway.prototype.hideFrame = function(){
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
}

Gateway.prototype.showFrame = function(){
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
}

Gateway.prototype.throwError = function(error, _disable){
	var disable = (typeof _disable == "boolean") ? _disable : false;
	this.errors[this.errors.length++] = error;
	if( this.status == this.constSending_symbol() ) this.receivePacket(null, false);
	if( disable ) this.disabled = true;
	
	this.showFrame();

	alert(error);
}

Gateway.prototype.createCSS = function(){
	this.html += "<style type=\"text\/css\">\n";
	this.html += "#" + this.idGateway + " {width: " + this.width + "; height: " + this.height + "; left: " + this.left + " visibility: " + this.visibility + "; background: cyan; }\n";
	this.html += "#table_" + this.idGateway + " {position:absolute; width: " + this.width + "; top: " + (parseInt(this.top) - 20) + "px; left: " + this.left + " visibility: " + this.visibility + "; background: " + this.bgcolor + "; }\n";
	this.html += "</style>\n";
}

Gateway.prototype.createForm = function(){
	this.html += "<form name=\"" + this.idForm + "\" action=\"" + this.url + "\" target=\"" + this.idGateway + "\" method=\"post\" style=\"width:0px; height:0px; margin:0px 0px 0px 0px;\">\n";
	if (this.isWddxEnabled()) {
		this.html += "<input type=\"Hidden\" name=\"wddx\" value=\"\">";
	} else {
		this.html += "<input type=\"Hidden\" name=\"packet\" value=\"\">";
	}
	this.html += "</form>\n";
}

Gateway.prototype.createFrame = function(){
	var sSrc = (typeof this.iframeSrc == "string") ? "src=\"" + this.iframeSrc + "\" " : (GatewayAPI.opera) ? "src=\"opera:about\" " : "";
	this.html += '<table id="' + 'table_' + this.idGateway + '" border="1" bgcolor="' + this.bgcolor + '" cellpadding="-1" cellspacing="-1" style="visibility: ' + this.visibility + '">';
	this.html += '<tr>';
	this.html += '<td>';
	if (document.layers) this.html += "<ilayer name=\"" + this.idGateway + "\" id=\"" + this.idGateway + "\" width=\"" + this.width + "\" height=\"" + this.height + "\" bgcolor=\"" + this.bgcolor + "\" visibility=\"" + this.visibility + "\"></ilayer>\n";
	else this.html += "<iframe " + sSrc + "width=\"" + this.width + "\" height=\"" + this.height + "\" name=\"" + this.idGateway + "\" id=\"" + this.idGateway + "\" frameBorder=\"1\" frameSpacing=\"0\" marginWidth=\"0\" marginHeight=\"0\" scrolling=\"Auto\"></iframe>\n";
	this.html += '</td>';
	this.html += '</tr>';
	this.html += '</table>';
}

Gateway.prototype.serverTimeout = function(id){
	if( this.status == this.constSending_symbol() && this.counter == id ){
		this.status = "timedout";
		clearInterval(this.statusID);  // stop updating status bar
		if (this.isDebugMode()) window.status = "";
		this.timeoutID = null;
		this.onTimeout();
	}
}

Gateway.prototype.resetStatus = function(){
	this.status = this.constIdle_symbol();
	this.statusResetID = null;
}

Gateway.prototype.receivePacket = function(packet, _bRunEvent){
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

	clearInterval(this.statusID); // stop updating status bar
	this.statusID = null;
	this.status = this.constReceived_symbol();

	this.statusResetID = setTimeout(this.id + ".resetStatus();", this.statusReset * 1000);  // make sure to reset the status
}

Gateway.prototype.sendPacket = function(packet, _bUseCache){
	if( this.disabled ) return false;
	var bUseCache = (typeof _bUseCache == "boolean") ? _bUseCache : true;

	this.onSend();  // run the onSend function

	if( !this.multithreaded && this.status == this.constSending_symbol() ) return false;
	if( !!this.delayID ) clearTimeout(this.delayID);
	if( !!this.statusResetID ) clearTimeout(this.statusResetID);

	// tag the data stream with the name of the this.js_global_varName to ensure the AJAX server responds are required...
	this.sent = '&___jsName___=' + this.js_global_varName + packet;
	
	this.delayID = setTimeout(this.id + ".serializeAndSend(" + String(bUseCache) + ")", this.delay);
}

Gateway.prototype.isReceivedFromCFAjax = function(){
	if ( (!!this.received) && (typeof this.received != const_object_symbol) ) {
		var bof_f = this.received.toUpperCase().indexOf(const_bof_cfajax_comment.toUpperCase());
		var eof_f = this.received.toUpperCase().indexOf(const_eof_cfajax_comment.toUpperCase());
		return ( (bof_f >= 0) && (eof_f >= 0) && (bof_f < eof_f) );
	} else {
		return false;
	}
}

Gateway.prototype.processReqChange = function(){
    if ( (!!xmlHttp_reqObject.oRequest) && (xmlHttp_reqObject.oRequest.readyState == 4) ) {
        try {
            if (xmlHttp_reqObject.oRequest.status && xmlHttp_reqObject.oRequest.status == 200) {
				var response = xmlHttp_reqObject.oRequest.responseText;
			 	response = response.stripCrLfs();
				var bof_f = response.toUpperCase().indexOf(const_bof_cfajax_comment.toUpperCase());
				var eof_f = response.toUpperCase().indexOf(const_eof_cfajax_comment.toUpperCase());
				if (eof_f > 0) {
					eof_f += 16; // skip over the comment header...
				}
				if (bof_f > 0) {
					response = response.substring(Math.min(bof_f, eof_f),Math.max(bof_f, eof_f));
				}
				if (!!xmlHttp_reqObject.oGateway) {
					xmlHttp_reqObject.oGateway.receivePacket(response);
				}
            } else {
				var response = xmlHttp_reqObject.oRequest.responseText;
                alert('xmlHttp Error:\n' + response.stripCrLfs());
            }
        } catch (ex) {
			jsErrorExplainer(ex, 'B. loadXMLDoc');
        }
	}
}

Gateway.prototype.loadXMLDoc = function(url){
	var bool = false;
    
    if (window.XMLHttpRequest) {  // branch for native XMLHttpRequest object
    	try {
			xmlHttp_reqObject.oRequest = new XMLHttpRequest();
			bool = true;
        } catch(e) {
			xmlHttp_reqObject.oRequest = false;
			bool = false;
        }
    } else if (window.ActiveXObject) {  // branch for IE/Windows ActiveX version
       	try {
        	xmlHttp_reqObject.oRequest = new ActiveXObject("Msxml2.XMLHTTP");
			bool = true;
      	} catch(e) {
        	try {
          		xmlHttp_reqObject.oRequest = new ActiveXObject("Microsoft.XMLHTTP");
				bool = true;
        	} catch(e) {
          		xmlHttp_reqObject.oRequest = false;
				bool = false;
        	}
		}
    }

	try {
		switch (this.method) {
			case this.constPost_symbol():
				if (xmlHttp_reqObject.oRequest) {
					xmlHttp_reqObject.oRequest.onreadystatechange = this.processReqChange;
					xmlHttp_reqObject.oGateway = this; // allow the this.processReqChange function to be aware of the instance of the Gateway object it should interact with upon completion.

					var a = url.split('?');
					if (a.length == 2) {
						xmlHttp_reqObject.oRequest.open("POST", a[0], true);
						xmlHttp_reqObject.oRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");			
		                xmlHttp_reqObject.oRequest.send('QUERY_STRING=' + a[1].URLEncode());
					} else {
						bool = false;
					}
				}
			break;
	
			case this.constGet_symbol():
				if (xmlHttp_reqObject.oRequest) {
					xmlHttp_reqObject.oRequest.onreadystatechange = this.processReqChange;
					xmlHttp_reqObject.oGateway = this; // allow the this.processReqChange function to be aware of the instance of the Gateway object it should interact with upon completion.
					xmlHttp_reqObject.oRequest.open("GET", url, true);
					xmlHttp_reqObject.oRequest.send(null);
				}
			break;
		}
	} catch(e) {
		bool = false;
		jsErrorExplainer(e, 'loadXMLDoc :: ERROR ' + this.method + ', bool = [' + bool + ']');
	}
	return bool;
}

Gateway.prototype.serializeAndSend = function(_bUseCache){
	if( this.disabled ) return false;

	this.counter++;  // update window status
	this.delayID = null; // clear the delay timeout
	this.received = null; // clear the received packet
	this.status = this.constSending_symbol();
	if (this.isDebugMode()) window.status = "Sending.";
	_cache_counters_GatewayAPI[this.counter] = 0;
	if( !!this.statusID ) clearInterval(this.statusID);
	var s_ticker = "_cache_counters_GatewayAPI[" + this.counter + "]++;";
	if (this.isDebugMode()) {
		s_ticker += " window.status = window.status + (((_cache_counters_GatewayAPI[" + this.counter + "] % " + parseInt((1000/this.statusdelay).toString()) + ") == 0) ? (_cache_counters_GatewayAPI[" + this.counter + "] / " + parseInt((1000/this.statusdelay).toString()) + ").toString() : '.')";
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
		case this.constPost_symbol():
			if (this.isXmlHttpPreferred) {
				var bool = this.loadXMLDoc(this.getUrl() + '&cfajax=1' + '&' + this.sent);
				if (bool == false) {
					this.methodPost(this.sent, _bUseCache);
				}
			} else {
				this.methodPost(this.sent, _bUseCache);
			}
		break;

		case this.constGet_symbol():
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
}

Gateway.prototype.formatPacket = function(packet){
	if( this.isWddxEnabled() ){
		// create serializer object
		var oWddx = new WddxSerializer();
		return "&wddx=" + oWddx.serialize(packet);
	} else {
		if( typeof packet == "string" ) return packet; // "&data=" + packet;
		else if( typeof packet == "object" ){
			var p = [];
			for( var k in packet ) p[p.length] = k + "=" + escape(packet[k]);
			return "&" + p.join("&");
		}
	}
}

Gateway.prototype.methodPost = function(packet, _bUseCache){
	if (this.browser_is_ie == false)
		return alert("The post method is currently unsupported. Netscape v4.0 does not support posting to a layer.");
	if( this.disabled ) return false;
	oForm = document[this.idForm];
	if (oForm) {
		if (this.isWddxEnabled()) {
			// create serializer object
			var oWddx = new WddxSerializer();
			packet = oWddx.serialize(packet);
			oForm.wddx.value = packet;
		} else {
			oForm.packet.value = packet;
		}
		oForm.submit();  // submit the packet to the server
	}
}

Gateway.prototype.methodGet = function(fPacket, _bUseCache){
	// get the packet to send to the server
	var sPacket = fPacket;
	// generate the url and packet to send

	var sUrl = this.getUrl() + sPacket;

	// check to see if you should use a cached version of the request
	// and if so, pass the cached results to the recievePacket method
	if( this.enableCache && (_bUseCache == true) && !!this.cache[sPacket] ) return this.receivePacket(this.cache[sPacket]);

	this.cacheResults = (this.enableCache && (_bUseCache == true));
	this.packetString = sPacket;

	try {
		// if IE then change the location of the IFRAME
		if( !!document.getElementById && !!document.getElementById(this.idGateway).contentDocument ){
			// this loads the URL stored in the sUrl variable into the hidden frame
			document.getElementById(this.idGateway).contentDocument.location.replace(sUrl);
	
		} else if( GatewayAPI.opera ){
			document.getElementById(this.idGateway).location.replace(sUrl);
	
		} else if( document.all ){
			// this loads the URL stored in the sUrl variable into the
			// hidden frame
			document[this.idGateway].location.replace(sUrl);
	
		// otherwise, change Netscape v4's ILAYER source file
		} else if( document.layers ){
			// this loads the URL stored in the sUrl variable into the
			// hidden frame
			document[this.idGateway].src = sUrl;
		}
	} catch(e) {
		alert('Programming Error... The Programmer obviously forgot to initialize the JSAPI Interface properly.');
		return;
	} finally {
	}
}
*/