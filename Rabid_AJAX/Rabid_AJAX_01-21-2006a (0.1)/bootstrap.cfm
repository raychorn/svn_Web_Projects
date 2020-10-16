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
		<cfsavecontent variable="js_gatewayObject">
			<cfinclude template="js/gatewayApi_2.03/gateway.js">
		</cfsavecontent>
		
		<cfscript>
			ar = ListToArray(Replace(js_gatewayObject, Chr(10), '', 'all'), Chr(13));
			writeOutput('Len = ' & ArrayLen(ar));
		</cfscript>

		<cfsavecontent variable="jsCode">
			<cfif 0>
				<cfloop index="_i" from="1" to="#ArrayLen(ar)#">
					#ar[_i]##Chr(13)#
				</cfloop>
			</cfif>
		//	if (!!parent.__jsObject__) { parent.__jsObject__ = 'Hello World'; }; 
			if (!!parent.__callback) { 
				var _html = ''; 
				_html += "function _getGUIObjectInstanceById(id) {"; 
				_html += "var obj = -1;"; 
				_html += "obj = ((document.getElementById) ? document.getElementById(id) : ((document.all) ? document.all[id] : ((document.layers) ? document.layers[id] : null)));"; 
				_html += "return obj;"; 
				_html += "}"; 
	
				_html += "var cObj = _getGUIObjectInstanceById('div_boostrap_loader');"; 
				_html += "if (!!cObj) {"; 
				_html += "cObj.innerHTML = '';"; 
				_html += "}"; 
				parent.__callback(_html);
			}
		</cfsavecontent>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			#jsCode#
		//	window.location.href = 'http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?bypass=1';
		//-->
		</script>
	<cfelseif 0>
		bypass = [#bypass#]<br>
	</cfif>
	
	</body>
	</html>
</cfoutput>
