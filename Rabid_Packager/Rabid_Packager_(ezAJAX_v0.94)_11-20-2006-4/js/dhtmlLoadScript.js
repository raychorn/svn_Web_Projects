	function dhtmlLoadScript(url) {
		var e = document.createElement("script");
		e.src = url;
		e.type="text/javascript";
		document.getElementsByTagName("head")[0].appendChild(e);	  
	}

	function dhtmlLoadStyle(text) { 
		var styles = document.createElement('style');
		styles.setAttribute('type', 'text/css');
	
		var newStyle = document.createTextNode(text); 
		styles.appendChild(newStyle);
	  
		var headRef = document.getElementsByTagName('head')[0];
		headRef.appendChild(styles); 
	}

	function appendChild(node, text) {
		if (null == node.canHaveChildren || node.canHaveChildren) {
			node.appendChild(document.createTextNode(text));
		} else {
			node.text = text;
		}
	}
	/*...*/
//	var script = document.createElement("script");
//	script.setAttribute('type','text/javascript');
//	appendChild(script, "show_AS("+row_num+");");
