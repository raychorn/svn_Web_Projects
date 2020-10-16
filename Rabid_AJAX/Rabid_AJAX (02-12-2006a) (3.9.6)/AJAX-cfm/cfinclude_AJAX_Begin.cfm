<cfsetting showdebugoutput="Yes">
<cfsetting showdebugoutput="No" enablecfoutputonly="Yes">

<cfparam name="_AUTH_USER" type="string" default="">

<cfparam name="bool_isServerLocal" type="boolean" default="#Request.commonCode.isServerLocal()#">

<cfset bool_using_xmlHttpRequest_viaGET = (isDefined("CGI.QUERY_STRING") AND (FindNoCase("&cfajax=1", URLDecode(CGI.QUERY_STRING)) gt 0))>
<cfset bool_using_xmlHttpRequest_viaPOST = (isDefined("form.QUERY_STRING") AND (FindNoCase("&cfajax=1", URLDecode(form.QUERY_STRING)) gt 0))>
<cfset bool_using_xmlHttpRequest = (bool_using_xmlHttpRequest_viaGET) OR (bool_using_xmlHttpRequest_viaPOST)>

<cfset bool_canDebugHappen = bool_isServerLocal>

<cfscript>
	Request.qryObj = Request.commonCode.initQryObj("name, val");
	Request.qryStruct = StructNew();

	Request.bool_using_xmlHttpRequest = bool_using_xmlHttpRequest;
	Request.bool_using_xmlHttpRequest_viaGET = bool_using_xmlHttpRequest_viaGET;
	Request.bool_using_xmlHttpRequest_viaPOST = bool_using_xmlHttpRequest_viaPOST;
	Request.bool_canDebugHappen = bool_canDebugHappen;
	Request.commonCode.beginAJAX();
</cfscript>

