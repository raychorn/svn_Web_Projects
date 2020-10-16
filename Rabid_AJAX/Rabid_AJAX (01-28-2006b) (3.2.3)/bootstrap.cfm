<cfsetting showdebugoutput="No" enablecfoutputonly="Yes">

<cfsavecontent variable="js_AJAXObject">
<cfoutput><cfinclude template="js/ajax_engine.js"></cfoutput>
</cfsavecontent>

<cfscript>
	_jsCode = "/* BOF CFAJAX */" & js_AJAXObject & "/* EOF CFAJAX */";
</cfscript>

<cfoutput>
#URLEncodedFormat(_jsCode)#
</cfoutput>
