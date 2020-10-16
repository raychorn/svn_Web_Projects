function jsErrorExplainer(e, funcName, bool_useAlert) {
	var _db = '';
	var msg = '';
	bool_useAlert = ((bool_useAlert == true) ? bool_useAlert : false);
	_db += "e.number is: " + (e.number & 0xFFFF) + '\n'; 
	_db += "e.description is: " + e.description + '\n'; 
	_db += "e.name is: " + e.name + '\n'; 
	_db += "e.message is: " + e.message + '\n';
	msg = funcName + '\n' + e.toString() + '\n' + _db;
	if (bool_useAlert) alert(msg);
	return msg;
}

function __callback(h) {
	if (!!h) {
		alert(h); // 'ch = [\x22]\n'
		eval(h); // the content passed-down from the server is JavaScript executable code.
//		try {
//		} catch(e) {
//			jsErrorExplainer(e, '__callback()', true);
//		} finally {
//		}
	}
}

document.write('<div id="div_boostrap_loader" style="display: inline;">');
document.write('<iframe id="frame_boostrap_loader" width="100%" height="200" frameborder="1" src="bootstrap.cfm" style="display: inline;"></iframe>');
document.write('</div>');
