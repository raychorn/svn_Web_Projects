<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">
<cfscript>
	_serverName = ListDeleteAt(CGI.SERVER_NAME, 1, '.');
	while (ListLen(_serverName, '.') gt 2) {
		_serverName = ListDeleteAt(_serverName, 1, '.');
	}
</cfscript>

<cfscript>
	_jsName = '';
	if ( (IsDefined("URL.jsNameX")) AND (Len(URL.jsNameX) gt 0) ) {
		aStruct = Request.commonCode.decodeEncodedEncryptedString(URLDecode(URL.jsNameX));
		if (IsStruct(aStruct)) {
			_jsName = aStruct.plaintext;
		}
	} else if ( (IsDefined("URL.jsName")) AND (Len(URL.jsName) gt 0) ) {
		_jsName = URL.jsName;
	}
</cfscript>

<cfif (FindNoCase(_serverName, CGI.HTTP_REFERER) gt 0)>
	<cfif (Len(_jsName) gt 0)>
		<cfscript>
			jsName = ExpandPath(_jsName);
		</cfscript>
		<cfif (FileExists(jsName))>
			<cfoutput>
				<CFHEADER NAME="Expires" VALUE="Mon, 06 Jan 1990 00:00:01 GMT">
				<CFHEADER NAME="Pragma" VALUE="no-cache">
				<CFHEADER NAME="cache-control" VALUE="no-cache">
				<cfcontent type="text/javascript" file="#jsName#">
			</cfoutput>
		<cfelse>
			<cflog file="#Application.applicationName#" type="ERROR" text="[jsName=#jsName#] File is Missing.">
		</cfif>
	</cfif>
</cfif>

