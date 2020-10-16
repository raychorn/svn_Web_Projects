/*
 object_destructor.js -- object_destructor()
 
*/

function object_destructor(anObj) {
	var ret_val = -1;
	
	try { ret_val = anObj.destructor(); } catch(e) { ret_val = null; } finally { ret_val = null; };

	return ret_val;
}
