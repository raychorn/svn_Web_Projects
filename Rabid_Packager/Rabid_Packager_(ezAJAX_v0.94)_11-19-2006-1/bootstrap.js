function _jsErrorExplainer(e, funcName, bool_useAlert) {var _db = ''; var msg = '';	bool_useAlert = ((bool_useAlert == true) ? bool_useAlert : false);_db += "e.number is: " + (e.number & 0xFFFF) + '\n'; _db += "e.description is: " + e.description + '\n'; _db += "e.name is: " + e.name + '\n'; _db += "e.message is: " + e.message + '\n';msg = funcName + '\n' + e.toString() + '\n' + _db;if (bool_useAlert) alert(msg);return msg;}
function _$(id) { var obj = -1; if (typeof id == 'string') {obj = ((document.getElementById) ? document.getElementById(id) : ((document.all) ? document.all[id] : ((document.layers) ? document.layers[id] : null)));} return obj;}
function uuid() { var uuid = (new Date().getTime() + "" + Math.floor(1000 * Math.random())); return uuid;}
function _URLDecode() {return unescape(this);}
String.prototype.URLDecode = _URLDecode;
function stripCrLfs() {return this.replace(/\n/ig, "").replace(/\r/ig, "");}
String.prototype.stripCrLfs = stripCrLfs;
function trim() {var s = null; s = this.replace(/^[\s]+/,""); s = s.replace(/[\s]+$/,""); return s;}
String.prototype.trim = trim;
var xmlHttp_reqObject = -1;
const_bof_cfajax_comment = '\/* BOF CFAJAX *\/';
const_eof_cfajax_comment = '\/* EOF CFAJAX *\/';
function __callback(h) {
	var hh = '';
	if ( (!!h) && (typeof h == 'string') && (!!h.length) && (h.length > 0) ) {
		hh = h.trim().URLDecode();

		try {
		//	if (!!_alert) _alert(hh);
			eval(hh); // the content passed-down from the server is JavaScript executable code.
		} catch(e) {
			if (!!_alertError) {
				_alertError(_jsErrorExplainer(e, '__callback()'));
			} else {
				_alert(_jsErrorExplainer(e, '__callback()'));
			}
		} finally {
		}

		_init(); // this entry-point resolves the apparent synchronization issues that seem to exist between this callBack and the window.onload() entry-point.
	}
}

function processReqChange() {
    if ( (!!xmlHttp_reqObject) && (xmlHttp_reqObject.readyState == 4) ) {
        try {
            if (xmlHttp_reqObject.status && xmlHttp_reqObject.status == 200) {
				var response = xmlHttp_reqObject.responseText; // .stripCrLfs();
				var bof_f = response.toUpperCase().indexOf(const_bof_cfajax_comment.toUpperCase());
				var eof_f = response.toUpperCase().indexOf(const_eof_cfajax_comment.toUpperCase());
				if (eof_f > 0) {
					eof_f += const_eof_cfajax_comment.length; // skip over the comment header...
				}
				if (bof_f > 0) {
					response = response.substring(Math.min(bof_f, eof_f),Math.max(bof_f, eof_f));
				}
				__callback(response);
            } else {
				var response = xmlHttp_reqObject.responseText;
                alert('xmlHttp Error:\n' + response.stripCrLfs());
            }
        } catch (ex) {
			_jsErrorExplainer(ex, 'B. loadXMLDoc');
        }
	}
}

function loadXMLDoc(url, method) {
	var bool = false;
    if (window.XMLHttpRequest) { // branch for native XMLHttpRequest object
    	try {
			xmlHttp_reqObject = new XMLHttpRequest();
			bool = true;
        } catch(e) {
			xmlHttp_reqObject = false;
			bool = false;
        }
    } else if (window.ActiveXObject) { // branch for IE/Windows ActiveX version
       	try {
        	xmlHttp_reqObject = new ActiveXObject("Msxml2.XMLHTTP");
			bool = true;
      	} catch(e) {
        	try {
          		xmlHttp_reqObject = new ActiveXObject("Microsoft.XMLHTTP");
				bool = true;
        	} catch(e) {
          		xmlHttp_reqObject = false;
				bool = false;
        	}
		}
    }

	try {
		switch (method) {
			case 'post':
				if (xmlHttp_reqObject) {
					xmlHttp_reqObject.onreadystatechange = processReqChange;
					var a = url.split('?');
					if (a.length == 2) {
						xmlHttp_reqObject.open("POST", a[0], true);
						xmlHttp_reqObject.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");			
		                xmlHttp_reqObject.send('QUERY_STRING=' + a[1].URLEncode());
					} else {
						bool = false;
					}
				}
			break;
	
			case 'get':
				if (xmlHttp_reqObject) {
					xmlHttp_reqObject.onreadystatechange = processReqChange;
					xmlHttp_reqObject.open("GET", url, true);
					xmlHttp_reqObject.send(null);
				}
			break;
		}
	} catch(e) {
		bool = false;
		_jsErrorExplainer(e, 'loadXMLDoc :: ERROR ' + method + ', bool = [' + bool + ']');
	}
	return bool;
}

loadXMLDoc('bootstrap.cfm?uuid=' + uuid(), 'get');
