var m$ = "";
function $IE() { if (document.all) {(m$); return false;} };
function $NS(e) { if (document.layers||(document.getElementById&&!document.all)) { if (e.which==2||e.which==3) { (m$); return false;} } }
if (document.layers) { document.captureEvents(Event.MOUSEDOWN); document.onmousedown=$NS; }
else { document.onmouseup=$NS; document.oncontextmenu=$IE; }
document.oncontextmenu = new Function("return false");
