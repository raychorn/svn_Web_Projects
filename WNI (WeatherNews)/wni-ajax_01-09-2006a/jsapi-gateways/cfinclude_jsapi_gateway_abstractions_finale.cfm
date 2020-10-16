<cfif (bool_using_xmlHttpRequest)>
	<cfoutput>
		/* BOF CFAJAX */
		#Request.commonCode.populate_JS_queryObj(Request.qryObj, 'qObj', true)#
		/* EOF CFAJAX */
	</cfoutput>
<cfelse>
	<!--- BEGIN: create a JavaScript object to store the query object --->
	<cfscript>
		_jsCode = Request.commonCode.populate_JS_queryObj(Request.qryObj, 'qObj', true);
		_jsCode = ReplaceList(_jsCode, Chr(13) & "," & Chr(10) & ",parent.", ",,");
		writeOutput('JS Code: <textarea cols="100" readonly rows="10" style="font-size: 10px; font-family: courier;">[#_jsCode#]</textarea><br>');
	</cfscript>
	<!--- END! create a JavaScript object to store the query object --->

	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			#Request.parentKeyword#server_response_queue = [];
			
			#Request.parentKeyword#server_response_queue.push("#_jsCode#");
	
			// this passes the packet back to the client
			if (#Request.parentKeyword#oGateway) {
				#Request.parentKeyword#oGateway.receivePacket(#Request.parentKeyword#server_response_queue);
			}
		//-->
		</script>
	</cfoutput>

	</body>
	</html>
</cfif>
 