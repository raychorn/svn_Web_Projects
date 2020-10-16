<cfsetting showdebugoutput="No">

<cfset _js_path = "js/">

<cfset _wni_menuEditor_js = "#_js_path#wni_menuEditor.js">

<cfoutput>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	
	<html>
	<head>
		<title>wni-ajax v1.0</title>
		<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 
	
		<script language="JavaScript1.2" src="#_wni_menuEditor_js#" type="text/javascript"></script>

	</head>
	
	<cfinclude template="cfinclude_index_body.cfm">

	</html>
</cfoutput>
