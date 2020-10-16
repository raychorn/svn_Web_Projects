<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html><head><title>Decryption Utility</title></head>
<body>
<div><b>Decryption Utility</b></div>
<hr />


<cfif NOT IsDefined("form.InputFile")>

<form action="index.cfm" method="post" enctype="multipart/form-data"><div>
Enter location of your encrypted CF template:<br />
<input type="file" name="InputFile"/>&nbsp;<input type="submit" name="submit" value="Decrypt"/>
</div></form>
</cfif>



<cfif IsDefined("form.InputFile")>

<form action="index.cfm" method="post" enctype="multipart/form-data"><div>
Enter location of your encrypted CF template:<br />
<input type="file" name="InputFile"/>&nbsp;<input type="submit" name="submit" value="Decrypt"/>
</div></form>

<CFX_CFMENCRYPT MODE="DECRYPT" 
INFILE="#form.InputFile#" OUTPUT="OutputFile">

<cfif OutputFile EQ "">

File is Not Encrypted.
<cfelse>


<script type="text/javascript">
<!-- 
	function copyText( obj ) {
		if (obj.type=="text" || obj.type=="textarea"){
			var rng = obj.createTextRange();
		} else {
			var rng = document.body.createTextRange();
			rng.moveToElementText(obj);
		}
		rng.scrollIntoView();
		rng.select();
		
		if (confirm('Copy the selected text to the ClipBoard?')) rng.execCommand("Copy");
		rng.collapse(false);
		rng.select();
	}

	function copy(inElement) {
	  if (inElement.createTextRange) {
	    var range = inElement.createTextRange();
	    if (range && BodyLoaded==1)
	      range.execCommand('Copy');
	  } else {
	    var flashcopier = 'flashcopier';
	    if(!document.getElementById(flashcopier)) {
	      var divholder = document.createElement('div');
	      divholder.id = flashcopier;
	      document.body.appendChild(divholder);
	    }
	    document.getElementById(flashcopier).innerHTML = '';
	    var divinfo = '<embed src="_clipboard.swf" FlashVars="clipboard='+encodeURIComponent(inElement.value)+'" width="0" height="0" type="application/x-shockwave-flash"></embed>';
	    document.getElementById(flashcopier).innerHTML = divinfo;
	  }
	}
 -->
</script>

<a href="javascript:copyText(document.getElementById('testCopy'));">Copy Source to Clipboard</a><BR>

<cfoutput><span class="JavaScript" id="testCopy"><textarea cols="110" rows="30" wrap="hard" name="Output">
&lt;!--- Decrypted Code Courtesy of the WebDog ---&gt;

#OutputFile#

&lt;!--- End of Decrypted Code Courtesy of the WebDog ---&gt;
</textarea></span>
</cfoutput>
</form>
</cfif>
</cfif>
</body></html>