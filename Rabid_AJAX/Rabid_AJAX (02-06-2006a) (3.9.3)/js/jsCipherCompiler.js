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
	preview : "Tidak",
	kodeawal : "",
	hasil : "",
	toString : function() {
		var aKey = -1;
		var s = '\njsCipherCompilerObj(' + this.id + ') :: (\n';
		s += 'metode = [' + this.metode + ']' + '\n';
		s += 'parameter = [' + this.parameter + ']' + '\n';
		s += 'preview = [' + this.preview + ']' + '\n';
		s += ')';
		return s;
	},
	enkrip : function(formnya) {
		/*
		<input type="hidden" name="metode" value="xor" />
		<input type="hidden" name="parameter" value="2" /> 
		<input type="hidden" name="preview" value="Tidak" />
		<TEXTAREA class="input_1" rows="8" name="kodeawal" cols="70" wrap="virtual"></TEXTAREA>
		<TEXTAREA class="input_1" rows="8" name="hasil" cols="70" wrap="virtual"></TEXTAREA>
		*/
		var kode1 = escape(formnya.kodeawal.value);
		var kode2="";
		var dop="";
		var key = formnya.parameter.value;
		var panjang = kode1.length;
		for (i=0;i<panjang;i++)  {
		    if (formnya.metode.value=="kurang") {
		        kode2+=String.fromCharCode(kode1.charCodeAt(i)-key);
		        dop="+";
		    }
		    else
		        if(formnya.metode.value=="tambah") {
		            kode2+=String.fromCharCode(kode1.charCodeAt(i)+key);
		            dop="-";
		        }
		        else
		            if(formnya.metode.value=="xor") {
		                kode2+=String.fromCharCode(kode1.charCodeAt(i)^key);
		                dop="^";
		            }
		}
		
		var dekripsinya = 
		'var enkripsi="'+kode2+'"; teks=""; teksasli="";'+
		'var panjang;'+
		'panjang=enkripsi.length;'+
		'for (i=0;i<panjang;i++)'+ 
		'{ teks+=String.fromCharCode(enkripsi.charCodeAt(i)'+dop+key+') }'+
		'teksasli=unescape(teks);'+
		'document.write(teksasli);';
		
		// formnya.hasil.value='\<SCRIPT\>'+dekripsinya+'\</SCRIPT\>';
		formnya.hasil.value=dekripsinya;
		
		if (formnya.preview.value=="Ya") {
		    handle=window.open();
		    handle.document.writeln("<HTML><HEAD><TITLE>Jazar's Free Tools - JavaScript</TITLE></HEAD>");
		    handle.document.write('<BODY>\<SCRIPT\>');
		    handle.document.write(dekripsinya);
		    handle.document.writeln('\</SCRIPT\></BODY></HEAD></HTML>');
		}
		
		<!-- Hitung hasilnya -->
		formnya.panjangasli.value=formnya.kodeawal.value.length;
		formnya.panjangenkripsi.value=formnya.hasil.value.length;
		formnya.pertambahan.value=formnya.hasil.value.length-formnya.kodeawal.value.length;
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
