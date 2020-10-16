<cfparam name="bool_isServerLocal" type="boolean" default="False">

<cfset bool_canDebugHappen = false>

<cfscript>
	Request.Geonosis_DSN = 'CMS';
	Request.Geonosis_DBname = 'CMS';
</cfscript>