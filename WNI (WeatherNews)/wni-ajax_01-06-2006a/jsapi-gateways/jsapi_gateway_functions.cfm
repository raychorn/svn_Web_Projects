<!--- 
	This is the dispatcher process that issues commands to other gateway processors - that makes this process a proxy, doesn't it ?
	
	
	WARNING: DO NOT CREATE JAVASCRIPT VARIABLES WITHIN THE SCOPE OF THE SERVER PROCESS OR BAD EVIL THINGS MAY RESULT.
			IF YOU MUST CREATE JAVASCRIPT VARIABLES THEN DO SO USING THE SCOPE OF THE CLIENT AS SEEN IN THE CODE THAT
			HAS ALREADY BEEN WRITTEN.
			
			IN OTHER WORDS, ALL JAVASCRIPT VARIABLES EXIST IN THE PARENT. SCOPE SINCE THIS CODE RUNS IN THE CONTEXT OF
			A HIDDEN IFRAME.
 --->
<cfinclude template="cfinclude_jsapi_gateway_abstractions.cfm">
 
<cfset _SQL_statement = "">

<cfdump var="#URL#" label="URL Scope" expand="No">

<cfdump var="#FORM#" label="FORM Scope" expand="No">

<!--- BEGIN: create a JavaScript object to store the query object --->
<cfscript>
	Request.commonCode.populate_JS_queryObj(Request.qryObj, 'qObj');
</cfscript>
<!--- END! create a JavaScript object to store the query object --->

<cfoutput>
	<script language="JavaScript1.2" type="text/javascript">
	<!--//
		#Request.parentKeyword#server_response_queue = [];
		
		#Request.parentKeyword#server_response_queue.push(#Request.parentKeyword#qObj);

		// this passes the packet back to the client
		if (#Request.parentKeyword#oGateway) {
			#Request.parentKeyword#oGateway.receivePacket(#Request.parentKeyword#server_response_queue);
		}
	//-->
	</script>
</cfoutput>

</body>
</html>
