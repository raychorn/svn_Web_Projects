<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Missing Template Handler</title>
</head>

<body>

<cfscript>
	errorHandled = false;
	bool_redirect = false;
	const_SiteErrorHandler_symbol = 'SiteErrorHandler.cfm';
	
	nPT = ListLen(CGI.PATH_TRANSLATED, '\');
	nSN = ListLen(CGI.SCRIPT_NAME, '/');
	j = 1;
	path = '';
	url = '/';
	for (i = 1; i lte nPT; i = i + 1) {
		tokPT = GetToken(CGI.PATH_TRANSLATED, i, '\');
		tokSN = GetToken(CGI.SCRIPT_NAME, j, '/');
		path = path & tokPT & '\';
		if (UCASE(tokPT) eq UCASE(tokSN)) {
			url = url & tokSN;
			if (FileExists(path & const_SiteErrorHandler_symbol)) {
				url = url & '/' & const_SiteErrorHandler_symbol;
				bool_redirect = true;
			}
			writeOutput('[i=#i#], [tokPT=#tokPT#], [j=#j#], [tokSN=#tokSN#]<br>');
			break;
		}
	}
</cfscript>

<cfif (bool_redirect) AND 0>
	<cflocation url="#url#" addtoken="No">
</cfif>

<cfif (NOT errorHandled)>
	<cfif (IsDefined("error"))>
		<cfdump var="#error#" label="error">
	</cfif>
	<cfif (IsDefined("cfcatch"))>
		<cfdump var="#cfcatch#" label="cfcatch">
	</cfif>
	<cfif (IsDefined("Application"))>
		<cfdump var="#Application#" label="cfcatch">
	</cfif>
	<cfif (IsDefined("Session"))>
		<cfdump var="#Session#" label="cfcatch">
	</cfif>
</cfif>

</body>
</html>
