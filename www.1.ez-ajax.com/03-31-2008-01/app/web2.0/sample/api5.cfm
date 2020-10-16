<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">
<cftry>
	<cfparam name="URL.callback" type="string" default="ezAlertError">

	<cfscript>
		aQueryObj = QueryNew('id, number, dataNode');
		QueryAddRow(aQueryObj, 1);
		QuerySetCell(aQueryObj, 'id', aQueryObj.RecordCount, aQueryObj.RecordCount);
		QuerySetCell(aQueryObj, 'number', 101, aQueryObj.RecordCount);
		QuerySetCell(aQueryObj, 'dataNode', 'Sample Data Node 1', aQueryObj.RecordCount);
		QueryAddRow(aQueryObj, 1);
		QuerySetCell(aQueryObj, 'id', aQueryObj.RecordCount, aQueryObj.RecordCount);
		QuerySetCell(aQueryObj, 'number', 102, aQueryObj.RecordCount);
		QuerySetCell(aQueryObj, 'dataNode', 'Sample Data Node 2', aQueryObj.RecordCount);
	</cfscript>
	
	<cfcatch type="Any">
		<cfscript>
			aQueryObj = QueryNew('id, errorMsg');
			QueryAddRow(aQueryObj, 1);
			QuerySetCell(aQueryObj, 'id', aQueryObj.RecordCount, aQueryObj.RecordCount);
			QuerySetCell(aQueryObj, 'errorMsg', Request.commonCode.ezCFDump(cfcatch, 'CF Error', false), aQueryObj.RecordCount);
		</cfscript>

		<cfset URL.callback = "handleServerErrorCallback">
	</cfcatch>
</cftry>

<cfsavecontent variable="jsonCode"><cfoutput>#URL.callback#<cfif (Len(URL.callback) gt 0)>(</cfif>#Request.commonCode.ezJSONencode(aQueryObj)#<cfif (Len(URL.callback) gt 0)>);</cfif></cfoutput></cfsavecontent>

<cfoutput>
	<CFHEADER NAME="Expires" VALUE="Mon, 06 Jan 1990 00:00:01 GMT">
	<CFHEADER NAME="Pragma" VALUE="no-cache">
	<CFHEADER NAME="cache-control" VALUE="no-cache">
	<cfcontent type="text/javascript" variable="#ToBinary(ToBase64(jsonCode))#">
</cfoutput>
