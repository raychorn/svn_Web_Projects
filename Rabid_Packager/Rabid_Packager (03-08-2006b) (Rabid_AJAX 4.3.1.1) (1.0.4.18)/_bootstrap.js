// _bootstrap.js

function _bootstrap() {
	function uuid() {
		var uuid = (new Date().getTime() + "" + Math.floor(1000 * Math.random()));
		return uuid;
	}

	var e = document.createElement("iframe");
	e.src = '_bootstrap.cfm?uuid=' + uuid();
	document.getElementsByTagName("head")[0].appendChild(e);
	_global_iframe = e;
}

_bootstrap();