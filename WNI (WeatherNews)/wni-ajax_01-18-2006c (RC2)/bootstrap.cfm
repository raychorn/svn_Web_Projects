<cfsetting showdebugoutput="No" enablecfoutputonly="Yes">

<cfsavecontent variable="byLine">
	<cfoutput>
		(&copy;). Hierarchical Applications Limited, All Rights Reserved.
	</cfoutput>
</cfsavecontent>

<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>#byLine#</title>
		#Request.commonCode.html_nocache()#
	</head>
	
	<body>
	
	#byLine#
	
	<cfif (NOT IsDefined("bypass"))>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			if (!!parent.__jsObject__) {
				parent.__jsObject__ = 'Hello World'; // create the object here...
			}
	
			if (!!parent.__callback) { // alternatively this conduit could be used to transport JS Source code to the client...
				var _html = '';
				// BEGIN: This block of code will remove the <iFRAME></iframe> from the client's view...
				_html += "var cObj = getGUIObjectInstanceById('div_boostrap_loader');";
				_html += "if (!!cObj) {";
				_html += "cObj.innerHTML = '';";
				_html += "}";
				// END! This block of code will remove the <iFRAME></iframe> from the client's view...
					
				parent.__callback(_html); // execute the JS Code and perform some magic - kick-start the system...
			}
			window.location.href = 'http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?bypass=1';
		//-->
		</script>
	<cfelseif 0>
		bypass = [#bypass#]<br>
	</cfif>
	
	</body>
	</html>
</cfoutput>
