<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">

<cfscript>
	aStruct = StructNew();
	aStruct.number = 101;
	aStruct.dataNode = 'Sample Data Node';
</cfscript>

<cfsavecontent variable="jsonCode"><cfoutput>#Request.commonCode.ezJSONencode(aStruct)#</cfoutput></cfsavecontent>

<cfoutput>
	<CFHEADER NAME="Expires" VALUE="Mon, 06 Jan 1990 00:00:01 GMT">
	<CFHEADER NAME="Pragma" VALUE="no-cache">
	<CFHEADER NAME="cache-control" VALUE="no-cache">
	<cfcontent type="text/javascript" variable="#ToBinary(ToBase64(jsonCode))#">
</cfoutput>
