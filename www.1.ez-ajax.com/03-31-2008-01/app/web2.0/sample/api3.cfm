<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">
<cfparam name="URL.callback" type="string" default="ezAlertError">
<cfscript>
	aStruct = StructNew();
	aStruct.number = 101;
	aStruct.dataNode = 'Sample Data Node';
</cfscript>

<cfsavecontent variable="jsonCode"><cfoutput>#URL.callback#<cfif (Len(URL.callback) gt 0)>(</cfif>#Request.commonCode.ezJSONencode(aStruct)#<cfif (Len(URL.callback) gt 0)>);</cfif></cfoutput></cfsavecontent>

<cfoutput>
	<CFHEADER NAME="Expires" VALUE="Mon, 06 Jan 1990 00:00:01 GMT">
	<CFHEADER NAME="Pragma" VALUE="no-cache">
	<CFHEADER NAME="cache-control" VALUE="no-cache">
	<cfcontent type="text/javascript" variable="#ToBinary(ToBase64(jsonCode))#">
</cfoutput>
