<cfsetting showdebugoutput="Yes">
<cfsetting showdebugoutput="No">

<cfparam name="_AUTH_USER" type="string" default="">

<cfparam name="bool_isServerLocal" type="boolean" default="#Request.commonCode.isServerLocal()#">

<cfset bool_canDebugHappen = bool_isServerLocal>

<cfif (bool_canDebugHappen)>
	<cfoutput>
		BEGIN: #Request.commonCode.blue_formattedModuleName('cfinclude_jsapi_gateway_abstractions.cfm')#<br>
		(isDefined("url.data")) = [#(isDefined("url.data"))#]<br>
		(isDefined("form.packet")) = [#(isDefined("form.packet"))#]<br>
		(isDefined("url.wddx")) = [#(isDefined("url.wddx"))#]<br>
		(isDefined("form.wddx")) = [#(isDefined("form.wddx"))#]<br>
		(isDefined("CGI.QUERY_STRING")) = [#(isDefined("CGI.QUERY_STRING"))#]<br>
		<cfif (isDefined("CGI.QUERY_STRING")) AND 0>
			CGI.QUERY_STRING = [#CGI.QUERY_STRING#]<br>
			<cfloop index="_item" list="#CGI.QUERY_STRING#" delimiters="&">
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
					</cfif>
				</cfif>
				<br>
			</cfloop>
		</cfif>
		<cfif (isDefined("url.data"))>
			url.data = [#TRIM(URLDecode(url.data))#]<br>
		<cfelseif (isDefined("form.packet"))>
			form.packet = [#TRIM(form.packet)#]<br>
		<cfelseif (isDefined("url.wddx"))>
			url.wddx = [#url.wddx#] [#URLDecode(url.wddx)#]<br>
		<cfelseif (isDefined("form.packet"))>
			form.packet = [#TRIM(form.packet)#]<br>
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
	<cfset Request._CMD_ = _CMD_>
<cfelseif (isDefined("form.wddx"))>
	<cfif (bool_canDebugHappen)>
		<cfoutput>
			B. Exec WDDX2CFML<br>
		</cfoutput>
	</cfif>

	<cfwddx action="WDDX2CFML" input="#form.wddx#" output="_CMD_">
	<cfset Request._CMD_ = _CMD_>
</cfif>

<cfif (bool_canDebugHappen)>
	<cfoutput>
		BEGIN: #Request.commonCode.blue_formattedModuleName('cfinclude_jsapi_gateway_abstractions.cfm')#<br>
		(IsQuery(Request._CMD_)) = [#(IsQuery(Request._CMD_))#]<br>
		<cfif (IsDefined("Request._CMD_"))>
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
	Request.qryObj = Request.commonCode.initQryObj("name, val");
</cfscript>

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

