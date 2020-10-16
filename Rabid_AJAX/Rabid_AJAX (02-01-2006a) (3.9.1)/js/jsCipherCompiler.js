/*
<input type="hidden" name="metode" value="xor" />
<input type="hidden" name="parameter" value="2" /> 
<input type="hidden" name="preview" value="Tidak" />
<TEXTAREA class="input_1" rows="8" name="kodeawal" cols="70" wrap="virtual"></TEXTAREA>
*/
function enkrip(formnya) {
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
}
