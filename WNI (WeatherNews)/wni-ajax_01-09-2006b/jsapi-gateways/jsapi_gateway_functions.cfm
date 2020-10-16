<!--- BEGIN: This block of code sets-up the Request.qryObj which is a ColdFusion Query Object that holds the parms from the AJAX call --->
<!--- Request.qryStruct also contains the variables that were passed-in from the caller... --->
<cfinclude template="cfinclude_jsapi_gateway_abstractions.cfm">
<!--- END! This block of code sets-up the Request.qryObj which is a ColdFusion Query Object that holds the parms from the AJAX call --->

<!--- This is where you may code your ColdFusion code that processes the AJAX Function --->
<cfscript>
	switch (Request.qryStruct.cfm) {
		case 'getTopLevelMenuNames':
			QueryAddRow(Request.qryObj, 1);
			QuerySetCell(Request.qryObj, 'NAME', 'Rcvd', Request.qryObj.recordCount);
			QuerySetCell(Request.qryObj, 'VAL', 'getTopLevelMenuNames', Request.qryObj.recordCount);
		break;
	}
</cfscript>
<cfdump var="#Request.qryStruct#" label="Request.qryStruct" expand="No">
<!--- the name of the cfm page is stored in the following variable: Request.qryObj.NAME["cfm"] --->

<!--- BEGIN: This block of code passes the Request.qryObj which is a ColdFusion Query Object back to the AJAX caller via a JavaScript object called qObj --->
<cfinclude template="cfinclude_jsapi_gateway_abstractions_finale.cfm">
<!--- END! This block of code passes the Request.qryObj which is a ColdFusion Query Object back to the AJAX caller via a JavaScript object called qObj --->
