//force IE min-width

var minlimit = 800 // This value (in pixels) sets the limit where the fixed width should be applied.

window.onload = minWidth;
window.onresize = minWidth;

function minWidth()  {
	if(document.getElementById) {
		if(document.body.offsetWidth <= minlimit) { // The equal sign seems to prevent IE6 from freezing.
			var obj = document.getElementById('container');
			if (obj != null) {
				obj.className='fixedwidth';
			}
		} else {
			var obj = document.getElementById('container');
			if (obj != null) {
				obj.className='fluid';
			}
		}
	}
	else return false;
}
