/******************************************************************************
 Client/Server Gateway JSAPI

 Author: Dan G. Switzer, II
 Date:   December 08, 2000
 Build:  203

 Description:
 This library provides the foundation for easily creating a communication
 gateway between the client and a server.

 With this library you'll be able to push and recieve information from
 the server, inline to the page.

 Version History
 ---------------
 Build 203 (July 24, 2003)
 - Added the GatewayAPI.build property
 - Added the iframeSrc attribute. It seems that on HTTPS
   IE was throwing a message complaining about secure and
   unsecure items running on the page together. If you're
   running SSL/HTTPS on the site, just set this property
   to a blank html document. I'm including one with the
   build you can use.
 - Added the LGPL to the build. Some asked me about
   licensing for the code.

 Build 202a (March 14, 2003)
 - Released the code w/an unused function I used for debugging
   as well as I forgot to update the build number in the comments.
   No real changes.

 Build 202 (March 14, 2003)
 - Opera 5 does not properly cache the variables--it seems to
   make pointers to the iframe, so once a page is reloaded
   the references no longer exist. To work around this problem
   caching is turned off automatically for Opera 5.
 - Fixed bugs causing Opera 5 & 6 not to work. In order for
   Opera to reload a document into an iframe, the iframe tag
   needed a src attribute
 - Removed the script tag that was trying to load the wddx library.
   This wasn't used anyway and was the result of some legacy code.
   This was causes problems in NS4.7x.

 Build 201 (March 12, 2003)
 - Added caching routine. Caching is enabled by default. You can
   either turn caching off completely setting the obj.enableCache
   to false, or you can overwrite the cache settings per call
   to the server using the obj.sendPacket(value, useCache) argument.

 Build 200 (March 10, 2003)
 - Rewrote majority of API

 Build 104 (December 20, 2000)
 - Made the status bar updatable by changing the hard code delay to a var
   (this.statusdelay)
 - Changed delay of status bar updates from 10 to 100

 Build 103
 - Added catch for testing whether or not the WDDX library was actually loaded
   if it's not, we warn the user and disable the gateway.
 - Changed the name of the disable variable to disabled
 - Added onTimeout prototype for defining a function to run if the event times
   out

 Build 102
 - First release
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
	this.build = "203";
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
	this.browser_is_ie = ( /msie/i.test(navigator.userAgent) &&	!/opera/i.test(navigator.userAgent) && !/Gecko/i.test(navigator.userAgent) && !/Netscape/i.test(navigator.userAgent) && !/Firefox/i.test(navigator.userAgent) );

	this.isXmlHttpPreferred = false; // make this true to favor using xmlHttpRequest() if possible however if doing so is not possible the default behavior is to use the iFrame/iLayer method instead.
	
	// hold current object in place holder
	this.idGateway = "idGatewayAPI_" + GatewayAPI.items.length;
	this.idForm = "idGatewayAPI_Form_" + GatewayAPI.items.length;

	this.id = GatewayAPI.register(this);
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

// define Gateway create(); prototype
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
		if (oo != null) {
			oo.style.visibility = ((document.layers) ? "hide" : "hidden");
			this.visibility = oo.style.visibility;
			this.isFrameShown = false;
		}
		var ooTable = getGUIObjectInstanceById('table_' + this.idGateway);
		if (ooTable != null) {
			ooTable.style.visibility = ((document.layers) ? "hide" : "hidden");
		}
	}
}

Gateway.prototype.showFrame = function(){
	if (this.isDebugMode()) {
		var oo = getGUIObjectInstanceById(this.idGateway);
		if (oo != null) {
			oo.style.visibility = ((document.layers) ? "show" : "visible");
			this.visibility = oo.style.visibility;
			this.isFrameShown = true;
		}
		var ooTable = getGUIObjectInstanceById('table_' + this.idGateway);
		if (ooTable != null) {
			ooTable.style.visibility = ((document.layers) ? "show" : "visible");
		}
	}
}

// define throwError(); prototype
Gateway.prototype.throwError = function(error, _disable){
	var disable = (typeof _disable == "boolean") ? _disable : false;
	this.errors[this.errors.length++] = error;
	if( this.status == this.constSending_symbol() ) this.receivePacket(null, false);
	if( disable ) this.disabled = true;
	
	this.showFrame();

	alert(error);
}

// define createCSS(); prototype
Gateway.prototype.createCSS = function(){
	this.html += "<style type=\"text\/css\">\n";
//	this.html += "#" + this.idGateway + " {position:absolute; width: " + this.width + "px; height: " + this.height + "px; clip:rect(0px " + this.width + "px " + this.height + "px 0px); visibility: " + this.visibility + "; background: " + this.bgcolor + "; }\n";
//	this.html += "#" + this.idGateway + " {position:absolute; width: " + this.width + "; height: " + this.height + "; top: " + this.top + "; left: " + this.left + " visibility: " + this.visibility + "; background: " + this.bgcolor + "; }\n";
	this.html += "#" + this.idGateway + " {width: " + this.width + "; height: " + this.height + "; left: " + this.left + " visibility: " + this.visibility + "; background: cyan; }\n";
	this.html += "#table_" + this.idGateway + " {position:absolute; width: " + this.width + "; top: " + (parseInt(this.top) - 20) + "px; left: " + this.left + " visibility: " + this.visibility + "; background: " + this.bgcolor + "; }\n";
	this.html += "</style>\n";
}

// define createForm(); prototype
Gateway.prototype.createForm = function(){
	this.html += "<form name=\"" + this.idForm + "\" action=\"" + this.url + "\" target=\"" + this.idGateway + "\" method=\"post\" style=\"width:0px; height:0px; margin:0px 0px 0px 0px;\">\n";
	if (this.isWddxEnabled()) {
		this.html += "<input type=\"Hidden\" name=\"wddx\" value=\"\">";
	} else {
		this.html += "<input type=\"Hidden\" name=\"packet\" value=\"\">";
	}
	this.html += "</form>\n";
}

// define createFrame(); prototype
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
//	else this.html += ((this.isReleaseMode()) ? "" : '<table bgcolor="' + this.bgcolor + '" cellpadding="-1" cellspacing="-1"><tr><td bgcolor="silver" align="center"><small><b>Hidden Iframe</b></small></td></tr><tr><td align="left">') + "<iframe " + sSrc + "width=\"" + this.width + "\" height=\"" + this.height + "\" name=\"" + this.idGateway + "\" id=\"" + this.idGateway + "\" frameBorder=\"1\" frameSpacing=\"0\" marginWidth=\"0\" marginHeight=\"0\"></iframe>\n" + ((this.isReleaseMode()) ? "" : "</td></tr></table>");
}

// define serverTimeout(); prototype
Gateway.prototype.serverTimeout = function(id){
	if( this.status == this.constSending_symbol() && this.counter == id ){
		this.status = "timedout";
		// stop updating status bar
		clearInterval(this.statusID);
		window.status = "";
		this.timeoutID = null;
		this.onTimeout();
	}
}

// define resetStatus(); prototype
Gateway.prototype.resetStatus = function(){
	this.status = this.constIdle_symbol();
	this.statusResetID = null;
}

// define receivePacket(); prototype
Gateway.prototype.receivePacket = function(packet, _bRunEvent){
	if( this.disabled || this.status == "timedout" ) return false;
	var b = (typeof _bRunEvent != "boolean") ? true : _b;

	// stop updating status bar
	clearInterval(this.statusID);
	window.status = "";

	// initialize the wddx packet to server
	this.received = packet;

	if( this.cacheResults == true ){
		this.cache[this.packetString] = packet;
		this.cacheResults = null;
	}

	// run the onReceive function
	if( b ) this.onReceive();

	// stop updating status bar
	clearInterval(this.statusID);
	this.statusID = null;
	this.status = this.constReceived_symbol();

	// make sure to reset the status
	this.statusResetID = setTimeout(this.id + ".resetStatus();", this.statusReset * 1000);
}

// define sendPacket(); prototype
Gateway.prototype.sendPacket = function(packet, _bUseCache){
	if( this.disabled ) return false;
	var bUseCache = (typeof _bUseCache == "boolean") ? _bUseCache : true;

	// run the onSend function
	this.onSend();

	if( !this.multithreaded && this.status == this.constSending_symbol() ) return false;
	if( this.delayID != null ) clearTimeout(this.delayID);
	if( this.statusResetID != null ) clearTimeout(this.statusResetID);

	this.sent = packet;

//	this.serializeAndSend(packet);
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
    // branch for native XMLHttpRequest object
    if (window.XMLHttpRequest) {
    	try {
			xmlHttp_reqObject.oRequest = new XMLHttpRequest();
			bool = true;
        } catch(e) {
			xmlHttp_reqObject.oRequest = false;
			bool = false;
        }
    // branch for IE/Windows ActiveX version
    } else if (window.ActiveXObject) {
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

// define sendPacket(); prototype
Gateway.prototype.serializeAndSend = function(_bUseCache){
	if( this.disabled ) return false;

	// update window status
	this.counter++;
	this.delayID = null; // clear the delay timeout
	this.received = null; // clear the received packet
	this.status = this.constSending_symbol();
	window.status = "Sending.";
	_cache_counters_GatewayAPI[this.counter] = 0;
	if( this.statusID != null ) clearInterval(this.statusID);
	var s_ticker = "_cache_counters_GatewayAPI[" + this.counter + "]++; window.status = window.status + (((_cache_counters_GatewayAPI[" + this.counter + "] % " + parseInt((1000/this.statusdelay).toString()) + ") == 0) ? (_cache_counters_GatewayAPI[" + this.counter + "] / " + parseInt((1000/this.statusdelay).toString()) + ").toString() : '.')";
	this.statusID = setInterval(s_ticker, this.statusdelay);
	this.timeoutID = setTimeout(this.id + ".serverTimeout(" + this.counter + ")", this.timeout * 1000);

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
