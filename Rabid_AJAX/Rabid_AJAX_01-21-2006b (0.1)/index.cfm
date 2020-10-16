<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfset _js_path = "js/">

<cfset _rajax_js = "#_js_path#rajax.js">

<cfoutput>

	<html>
	<head>
		<title>Rabid_AJAX 0.1</title>
		<link rel="shortcut icon" href="/favicon.ico">
	</head>
	
	<body>

	<!--- BEGIN: This is the minimal amount of code that must be on the client to support a remote boosteap loader for an AJAX Application --->
	<script language="JavaScript1.2" src="#_rajax_js#" type="text/javascript"></script>
	<!--- END! This is the minimal amount of code that must be on the client to support a remote boosteap loader for an AJAX Application --->

	</body>
	</html>

</cfoutput>

