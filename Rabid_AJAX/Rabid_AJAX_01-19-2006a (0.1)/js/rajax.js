function __callback(h) {
	if (!!h) {
		alert(h);
		eval(h); // the content passed-down from the server is JavaScript executable code.
	}
}

document.write('<div id="div_boostrap_loader" style="display: inline;">');
document.write('<iframe id="frame_boostrap_loader" width="100%" height="200" frameborder="1" src="bootstrap.cfm" style="display: inline;"></iframe>');
document.write('</div>');
