// Image's width and height.
var iwidth = 150;
var iheight = 150;

var n = 0;

if (right_side_image_links.length > 0) {
	n = parseInt(Math.round(Math.random() * right_side_image_links.length).toString());
	
	var htmltag = "";
	if (_LayoutMode == 0) {
		htmltag += "<a href='javascript:gotoUrl(" + n + ")' OnMouseOver=\"showStatus(" + n + ");return true\" ";
		htmltag += "OnMouseOut=\"window.status=''\">";
	} else {
		
	}
	htmltag += '<img border="' + ((_LayoutMode == 0) ? 0 : (_LayoutMode + 0)).toString() + '" width="' + iwidth.toString() + '" height="' + iheight.toString() + '" id="bannerimg" src="' + getImageName(n) + '"';
	if (_LayoutMode == 1) {
		htmltag += ' ondrag="resizeImage(event,\'bannerimg\')"';
	}
	htmltag += "\">";
	if (_LayoutMode == 0) {
		htmltag += "</a>";
	}
	document.write(htmltag); 
}
