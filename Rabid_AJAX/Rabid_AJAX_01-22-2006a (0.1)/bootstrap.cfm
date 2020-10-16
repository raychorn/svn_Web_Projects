<cfsetting showdebugoutput="No" enablecfoutputonly="Yes">

<cfif 1>
<cfsavecontent variable="js_gatewayObject">
<cfoutput><cfinclude template="js/gatewayApi_2.03/gateway.js"></cfoutput>
</cfsavecontent>
	
<cfoutput>
/* BOF CFAJAX */
#js_gatewayObject#
/* EOF CFAJAX */
</cfoutput>
<cfelse>
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
				
				cf_const_carriage_return = '\x0d';
				cf_const_literal_doubleQuote = '\x22';
				cf_const_literal_singleQuote = '\x27';
				
				cf_const_begin_jsComment_block = '/' & '*';
				cf_const_end_jsComment_block = '*' & '/';
	
				cf_const_simple_jsComment_token = '/' & '/';
				
				cf_const_single_doubleQuote_token = "'" & '"'; // "GatewayAPI.items[" + ' + "" + i + "']"
				
				cf_const_false_begin_jsComment_block = '\' & '/' & '*'; // this pattern "might" happen in a JS source file but not the false end comments due to the need to escape the slash character...
				
				cf_const_literalEscaped_doubleQuote_replacement = "' + #cf_const_literal_doubleQuote# + '";
				cf_const_literalEscaped_singleQuote_replacement = "' + #cf_const_literal_singleQuote# + '";
				
				cf_const_carriage_return_replacement = "' + #cf_const_carriage_return# + '";
				
				bool_inside_jsComments = false;
			</cfscript>
	
			<!--- BEGIN: JS Code Conversion Rules:
				(1). Convert literal escaped '\"' to [' + \x22 + '].
				(2). Convert literal escaped "\'" to [' + \x27 + '].
				(2a). Convert "'" to "\'" before step (3) below.
				(3). Convert literal '"' to "'" to cause all literal strings to be defined using "'" rather than '"'.
	
				const_literal_doubleQuote = \x22;
				const_literal_singleQuote = \x27;
			 --->
			<cfsavecontent variable="jsCode">
				<cfif 0>
					//	if (!!parent.__jsObject__) { parent.__jsObject__ = 'Hello World'; }; 
				</cfif>
				if (!!parent.__callback) { 
					var _html = ''; 
					<cfif 1>
						<cfloop index="_i" from="1" to="#ArrayLen(ar)#">
							<cfscript>
								if ( (Find(cf_const_begin_jsComment_block, ar[_i]) gt 0) AND (Find(cf_const_false_begin_jsComment_block, ar[_i]) eq 0) ) { 
									bool_inside_jsComments = true;
								}
								if (NOT bool_inside_jsComments) {
									aLOC = ReplaceNoCase(ar[_i], '\"', cf_const_literalEscaped_doubleQuote_replacement, 'all');
									aLOC = ReplaceNoCase(aLOC, "\'", cf_const_literalEscaped_singleQuote_replacement, 'all');
									aLOC = ReplaceNoCase(aLOC, "\n", cf_const_carriage_return_replacement, 'all');
									aLOC = ReplaceNoCase(aLOC, '"', "'", 'all');
									tokLoc = Find(cf_const_simple_jsComment_token, aLOC);
									if ((tokLoc - 1) gt 0) {
										aLOC = Left(aLOC, tokLoc - 1);
										tokLoc = 0;
									}
									if ( (tokLoc eq 0) AND (Len(aLOC) gt 0) ) writeOutput('_html += "#aLOC#" + "\n";' & Chr(13));
								} else {
									if (Find(cf_const_end_jsComment_block, ar[_i]) gt 0) {
										bool_inside_jsComments = false;
									}
								}
							</cfscript>
						</cfloop>
					</cfif>
	
					_html += "function _getGUIObjectInstanceById(id) {" + "\n"; 
					_html += "var obj = -1;" + "\n"; 
					_html += "obj = ((document.getElementById) ? document.getElementById(id) : ((document.all) ? document.all[id] : ((document.layers) ? document.layers[id] : null)));" + "\n"; 
					_html += "return obj;" + "\n"; 
					_html += "}" + "\n"; 
		
					_html += "var cObj = _getGUIObjectInstanceById('div_boostrap_loader');" + "\n"; 
					_html += "if (!!cObj) {" + "\n"; 
					_html += "cObj.innerHTML = '';" + "\n"; 
					_html += "}" + "\n"; 
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
</cfif>
