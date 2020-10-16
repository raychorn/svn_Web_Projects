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
</cfscript>

<cfif (bool_using_xmlHttpRequest)>
	<cfscript>
	//	writeOutput(Request.explainObject(CGI, false));
		_CGI_QUERY_STRING = '';
		if (IsDefined("CGI.QUERY_STRING")) {
			_CGI_QUERY_STRING = URLDecode(CGI.QUERY_STRING);
		}
		_form_QUERY_STRING = '';
		if (IsDefined("form.QUERY_STRING")) {
			_form_QUERY_STRING = URLDecode(form.QUERY_STRING);
		}

		_QUERY_STRING = '';
		if (bool_using_xmlHttpRequest_viaGET) {
			_QUERY_STRING = '#_CGI_QUERY_STRING#';
		} else if (bool_using_xmlHttpRequest_viaPOST) {
			_QUERY_STRING = '#_form_QUERY_STRING#';
		}
	</cfscript>
<cfelse>
	<cfoutput>
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		
		<html>
		<head>
			<cfoutput>
				#Request.commonCode.html_nocache()#
			</cfoutput>
			<cfscript>
				if (bool_canDebugHappen) {
					_prefix = '.';
					if (FileExists(ExpandPath('..\StyleSheet.css'))) {
						_prefix = '../';
					} else if (FileExists(ExpandPath('StyleSheet.css'))) {
						_prefix = '';
					}
					if (_prefix neq '.') {
						writeOutput('<LINK rel="STYLESHEET" type="text/css" href="#_prefix#StyleSheet.css"> ');
					}
				}
			</cfscript>
		</head>
		<body>
	</cfoutput>
	
	<cfif (bool_canDebugHappen)>
		<cfoutput>
			<cfif 1>
				<cfdump var="#URL#" label="URL Scope" expand="No">
				<cfdump var="#FORM#" label="FORM Scope" expand="No">
				<cfdump var="#CGI#" label="CGI Scope" expand="No">
			</cfif>

			BEGIN: #Request.commonCode.blue_formattedModuleName('cfinclude_jsapi_gateway_abstractions.cfm')#<br>
			(isDefined("url.data")) = [#(isDefined("url.data"))#]<br>
			(isDefined("form.packet")) = [#(isDefined("form.packet"))#]<br>
			(isDefined("url.wddx")) = [#(isDefined("url.wddx"))#]<br>
			(isDefined("form.wddx")) = [#(isDefined("form.wddx"))#]<br>
			(isDefined("CGI.QUERY_STRING")) = [#(isDefined("CGI.QUERY_STRING"))#]<br>
			
			<!--- BEGIN: Determine the data source from all available sources of data and route to _QUERY_STRING --->
			<cfscript>
				_QUERY_STRING = '';
				if (isDefined("url.data")) {
					if (Len(url.data) gt 0) {
						_QUERY_STRING = TRIM(URLDecode(url.data));
					}
				} else if (isDefined("form.packet")) {
					if (Len(form.packet) gt 0) {
						_QUERY_STRING = TRIM(URLDecode(form.packet));
					}
				} else if (isDefined("CGI.QUERY_STRING")) {
					if (Len(CGI.QUERY_STRING) gt 0) {
						_QUERY_STRING = TRIM(URLDecode(CGI.QUERY_STRING));
					}
				}
			</cfscript>
			<!--- END! Determine the data source from all available sources of data and route to _QUERY_STRING --->
			
			<cfif (Len(_QUERY_STRING) gt 0)>
				_QUERY_STRING = [#_QUERY_STRING#]<br>
				<cfloop index="_item" list="#_QUERY_STRING#" delimiters="&">
					_item = [#_item#]
					<cfif (ListLen(_item, "=") eq 2)>
						&nbsp;[#Request.commonCode._GetToken(_item, 1, "=")#]&nbsp;[#Request.commonCode._GetToken(_item, 2, "=")#]<br>
						<cfif (LCase(Request.commonCode._GetToken(_item, 1, "=")) eq LCase("wddx"))>
							0. Exec WDDX2CFML<br>
							[#Request.commonCode._GetToken(_item, 2, "=")#]<br>
							<cfset input_item = Request.commonCode._GetToken(_item, 2, "=")>
							input_item = [#input_item#]<br>
							<cfwddx action="WDDX2CFML" input="#input_item#" output="_CMD_">
		
							<cfif (IsDefined("_CMD_"))>
								<cfif (IsQuery(_CMD_))>
									<cfdump var="#_CMD_#" label="_CMD_" expand="No">
								<cfelse>
									_CMD_ = [#_CMD_#]<br>
								</cfif>
							</cfif>
						<cfelse>
							<cfparam name="_CMD_" type="string" default="">
							<cfset _CMD_ = ListAppend(_CMD_, _item, "&")>
						</cfif>
					</cfif>
					<br>
				</cfloop>
			</cfif>
			<cfif (isDefined("url.wddx"))>
				url.wddx = [#url.wddx#] [#URLDecode(url.wddx)#]<br>
			<cfelseif (isDefined("form.wddx"))>
				form.wddx = [#URLDecode(form.wddx)#]<br>
			</cfif>
			END! #Request.commonCode.blue_formattedModuleName('cfinclude_jsapi_gateway_abstractions.cfm')#<br>
		</cfoutput>
	</cfif>
	
	<cfif (isDefined("url.wddx"))>
		<cfif (bool_canDebugHappen)>
			<cfoutput>
				A. Exec WDDX2CFML<br>
			</cfoutput>
		</cfif>
	
		<cfwddx action="WDDX2CFML" input="#url.wddx#" output="_CMD_">
	<cfelseif (isDefined("form.wddx"))>
		<cfif (bool_canDebugHappen)>
			<cfoutput>
				B. Exec WDDX2CFML<br>
			</cfoutput>
		</cfif>
	
		<cfwddx action="WDDX2CFML" input="#form.wddx#" output="_CMD_">
	</cfif>

	<cfset Request._CMD_ = _CMD_>
	
	<cfif (bool_canDebugHappen)>
		<cfoutput>
			BEGIN: #Request.commonCode.blue_formattedModuleName('cfinclude_jsapi_gateway_abstractions.cfm')#<br>
			(IsDefined("Request._CMD_") = [#IsDefined("Request._CMD_")#]<br>
			<cfif (IsDefined("Request._CMD_"))>
				(IsQuery(Request._CMD_)) = [#(IsQuery(Request._CMD_))#]<br>
				<cfif (IsQuery(Request._CMD_))>
					#Request.primitiveCode.debugQueryInTable(Request._CMD_, "Request._CMD_")#
				<cfelse>
					Request._CMD_ = [#Request._CMD_#]<br>
				</cfif>
			</cfif>
			END! #Request.commonCode.blue_formattedModuleName('cfinclude_jsapi_gateway_abstractions.cfm')#<br>
		</cfoutput>
	</cfif>

	<cfscript>
		_QUERY_STRING = Request._CMD_;
	</cfscript>
</cfif>

<cfscript>
	aa = ListToArray(_QUERY_STRING, '&');
	aaN = ArrayLen(aa);
	for (i = 1; i lte aaN; i = i + 1) {
		QueryAddRow(Request.qryObj, 1);
		aaP = ListToArray(URLDecode(aa[i]), '=');
		QuerySetCell(Request.qryObj, 'NAME', aaP[1], Request.qryObj.recordCount);
		QuerySetCell(Request.qryObj, 'VAL', aaP[2], Request.qryObj.recordCount);
		Request.qryStruct[aaP[1]] = aaP[2];
	}
</cfscript>