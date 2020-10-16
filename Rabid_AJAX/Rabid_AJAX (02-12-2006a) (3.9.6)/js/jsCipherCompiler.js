/*
 jsCipherCompiler.js -- jsCipherCompilerObj
 
	WARNING:	This object contains or holds onto references to functions that are contained within the body of
				other functions which might result in accidental closures that need to be freed or a memory leak
				may result.  Make sure you are using the destructor method to properly release all objects being
				referenced by every instance of this object in order to avoid any possible memory leak problems.
*/

jsCipherCompilerObj = function(id){
	this.id = id;
};

jsCipherCompilerObj.instances = [];

jsCipherCompilerObj.getInstance = function() {
	var instance = jsCipherCompilerObj.instances[jsCipherCompilerObj.instances.length];
	if(instance == null) {
		instance = jsCipherCompilerObj.instances[jsCipherCompilerObj.instances.length] = new jsCipherCompilerObj(jsCipherCompilerObj.instances.length);
	}
	return instance;
};

jsCipherCompilerObj.removeInstance = function(id) {
	var ret_val = false;
	if ( (id > -1) && (id < jsCipherCompilerObj.instances.length) ) {
		var instance = jsCipherCompilerObj.instances[id];
		if (!!instance) {
			jsCipherCompilerObj.instances[id] = object_destructor(instance);
			ret_val = (jsCipherCompilerObj.instances[id] == null);
		}
	}
	return ret_val;
};

jsCipherCompilerObj.removeInstances = function() {
	var ret_val = true;
	for (var i = 0; i < jsCipherCompilerObj.instances.length; i++) {
		jsCipherCompilerObj.removeInstance(i);
	}
	return ret_val;
};

jsCipherCompilerObj.prototype = {
	id : -1,
	metode : "xor",
	parameter : "2",
	plaintext : "",
	ciphertext : "",
	decipher : "",
	bool_useDocumentWrite : false,
	input_length : -1,
	enkrip_length : -1,
	diff_length : -1,
	const_metode_xor : "xor",
	toString : function() {
		var aKey = -1;
		var s = '\njsCipherCompilerObj(' + this.id + ') :: (\n';
		s += 'metode = [' + this.metode + ']' + '\n';
		s += 'parameter = [' + this.parameter + ']' + '\n';
		s += 'input_length = [' + this.input_length + ']' + '\n';
		s += 'enkrip_length = [' + this.enkrip_length + ']' + '\n';
		s += 'diff_length = [' + this.diff_length + ']' + '\n';
		s += ')';
		return s;
	},
	set_metode_xor : function() {
		this.metode = this.const_metode_xor;
	},
	enkrip : function(formnya) {
		var kode1 = escape(this.plaintext);
		var kode2 = "";
		var dop = "";
		var key_i = 0;
		var ch = -1;
		var key = this.parameter;
		var panjang = kode1.length;
		for (i = 0; i < panjang; i++)  {
		    if (this.metode=="kurang") {
				ch = String.fromCharCode(kode1.charCodeAt(i)-key.charAt(key_i));
				ch = ((ch.charCodeAt(0) == 34) ? '\\"' : ch);
				kode2 += ch;
				dop="+";
		    } else if (this.metode=="tambah") {
				ch = String.fromCharCode(kode1.charCodeAt(i)+key.charAt(key_i));
				ch = ((ch.charCodeAt(0) == 34) ? '\\"' : ch);
				kode2 += ch;
				dop="-";
			} else if (this.metode == this.const_metode_xor) {
				ch = String.fromCharCode(kode1.charCodeAt(i)^key.charAt(key_i));
				ch = ((ch.charCodeAt(0) == 34) ? '\\"' : ch);
				kode2 += ch;
				dop="^";
            }
			key_i++;
			if (key_i >= key.length) {
				key_i = 0;
			}
		}
		
		this.ciphertext = 'var enkripsi="'+kode2+'";';

		var dekripsinya = 'function decipher(enc, p){'+'var teks=""; var teksasli="";'+'var panjang=enc.length;'+
		'var p_i=0;'+
		'for (var i=0;i<panjang;i++)'+'{ teks+=String.fromCharCode(enc.charCodeAt(i)'+dop+'p.charAt(p_i)'+'); p_i++; if (p_i >= p.length) { p_i = 0; }; }'+
		'teksasli=unescape(teks);'+
		((this.bool_useDocumentWrite) ? 'document.write(teksasli);' : 'alert(teksasli);')+
		'};'+'decipher(enkripsi,\'' + this.parameter + '\');';
		
		this.decipher = dekripsinya;
		
		this.input_length = this.plaintext.length;
		this.enkrip_length = this.ciphertext.length;
		this.diff_length = this.ciphertext.length - this.plaintext.length;
	},
	init : function() {
		return this;
	},
	destructor : function() {
		return (this.id = jsCipherCompilerObj.instances[this.id] = null);
	},
	dummy : function() {
		return false;
	}
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
