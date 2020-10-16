<cfparam name="parms" type="string" default="">

<cfscript>
	Request.const_Lf = Chr(10);
	Request.const_CrLf = Chr(13) & Request.const_Lf;
	
	function cf_br2cr_string(s) {
		return Replace(Replace(s, ".  ", ".", "all"), Request.const_CrLf, "<br>", "all");
	}

	function cf_to_js_string(s_cf) {
		return cf_br2cr_string(Replace(Replace(s_cf, "'", '"', "all"), Request.const_Lf, "", "all"));
	}
</cfscript>

<cfsavecontent variable="_htmlContent">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Pasta Pomodoro Intranet &copy;2005, Hierarchical Applications Limited - All Rights Reserved</title>
	<META NAME="COPYRIGHT" CONTENT="&copy;2005, Hierarchical Applications Limited - All Rights Reserved">
	<meta name="robots" content="index,follow">

	<META HTTP-EQUIV="Pragma" CONTENT="NO-CACHE">
	<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
	<META HTTP-EQUIV="EXPIRES" CONTENT="Mon, 1 Jan 2000 00:00:00 GMT">
	<META HTTP-EQUIV="CONTENT-LANGUAGE" CONTENT="en-US">
	<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=UTF-8">
	<META NAME="GOOGLEBOT" CONTENT="ARCHIVE">

	<style>
		BODY {
			margin: 0px;
			padding: 0px;
			background-color: #669846;
			color: #000000;
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-size: xx-small;
		}
	</style>

</head>

<body>

<cfoutput>

<cfset _src = "cfm/pp-owned-code/cf_flash_applet.cfm?parms=#URLEncodedFormat(parms)#&#Request.commonCode.nocacheParm()#">

<br>

<cfif (Request.CommonCode.isServerLocal()) AND 0>
	<cfdump var="#url#" label="url, _src = [#_src#], parms = [#parms#]">
</cfif>
<iframe src="#_src#" width="99%" height="100%" frameborder="0"></iframe>
</cfoutput>

</body>
</html>

</cfsavecontent>

<cfset _cnt = Len(_htmlContent)>

<cfset js_htmlContent = cf_to_js_string(_htmlContent)>

<cfset _cnt2 = Len(js_htmlContent)>

<cfoutput>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		if (parent.decodeContent == null) {
			window.location.href = '#Request.commonCode.fullyQualifiedURLprefix('/' & GetToken(Request.url_prefix, 1, "/") & '/')#index.html';
		}
	//-->
	</script>

	<cfscript>
		function carveUpContent(varName, s) {
			var i = -1;
			var t = '';
			var n = -1;
			var m = -1;
			var nn = 256;

			writeOutput('<script language="JavaScript1.2" type="text/javascript">' & Request.const_CrLf);
			writeOutput('<!--' & Request.const_CrLf);

			writeOutput("parent.#varName# = [];" & Request.const_CrLf);

			m = Len(s);
			for (i = 1; i lt m; ) {
				n = Min(nn, m - i + 1);
				t = Mid(s, i, n);
				writeOutput("parent.#varName#.push('#URLEncodedFormat(t)#');" & Request.const_CrLf);
				if (n lt nn) {
				}
				i = i + n;
			}

			writeOutput('//-->' & Request.const_CrLf);
			writeOutput('</script>' & Request.const_CrLf);
		}
		
		carveUpContent('html_content', js_htmlContent);
	</cfscript>

	<script language="JavaScript1.2" type="text/javascript">
	<!--
		parent.decodeContent();
//		alert(parent.html_content);
		parent.resizeObjBasedOnClientAreaById('iframe_cf_flash_siteMenu');
	//-->
	</script>
</cfoutput>

