<cfsetting showdebugoutput="No" enablecfoutputonly="Yes">

<cfsavecontent variable="js_AJAXObject">
<cfoutput><cfinclude template="js/ajax_engine.js"></cfoutput>
</cfsavecontent>

<cfscript>
	_jsCode = "/* BOF CFAJAX */" & js_AJAXObject & "/* EOF CFAJAX */";
</cfscript>

<cfoutput>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		//*** BEGIN: URLDecode() ***********************************************************************/
		
		function URLDecode(encoded) {
		   var HEXCHARS = "0123456789ABCDEFabcdef"; 
		   var plaintext = "";
		   var i = 0;
		   while (i < encoded.length) {
		       var ch = encoded.charAt(i);
			   if (ch == "+") {
			       plaintext += " ";
				   i++;
			   } else if (ch == "%") {
					if (i < (encoded.length-2) 
							&& HEXCHARS.indexOf(encoded.charAt(i+1)) != -1 
							&& HEXCHARS.indexOf(encoded.charAt(i+2)) != -1 ) {
						plaintext += unescape( encoded.substr(i,3) );
						i += 3;
					} else {
						alert( 'Bad escape combination near ...' + encoded.substr(i) );
						plaintext += "%[ERROR]";
						i++;
					}
				} else {
				   plaintext += ch;
				   i++;
				}
			} // while
		   return plaintext;
		}
		
		//*** END! URLDecode() ***********************************************************************/
		
		function _URLDecode() {
			return URLDecode(this);
		}
		
		String.prototype.URLDecode = _URLDecode;

		parent.global_jsCode = "#URLEncodedFormat(Request.commonCode.obfuscateJScode(_jsCode))#";;
		parent._eval = function (c) { /*if (!!parent._alert) parent._alert(c.URLDecode());*/  if (!!parent._init) parent._init(c); };
		parent._eval(parent.global_jsCode);
	//-->
	</script>
</cfoutput>

