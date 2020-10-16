<!--- cfinclude_application.cfm --->

<cfset makeNewRuntimeLicense = (NOT FileExists(ExpandPath('runtimeLicense.dat')))>

<!--- BEGIN: Make a Runtime License File --->
<cfif (makeNewRuntimeLicense)>
	<cfscript>
		try {
			Request.commonCode.writeRuntimeLicenseForEndDate(CreateDateTime(2099, 12, 31, 23, 59, 59), Request.commonCode.productName, CGI.SERVER_NAME, false);
		} catch (Any e) {
		};
	</cfscript>
</cfif>
<!--- END! Make a Runtime License File --->

<cfscript>
	err_ezAjax_cfc_commonCode = false;
	err_ezAjax_cfc_commonCodeMsg = '';
	try {
		Request.commonCode = CreateObject("component", "ezAjax.cfc.commonCode");
	} catch(Any e) {
		Request.commonCode = -1;
		err_ezAjax_cfc_commonCode = true;
		err_ezAjax_cfc_commonCodeMsg = '(1*) The ezAjax.cfc.commonCode component has NOT been created.';
	}

	Request.Geonosis_DSN = 'CMS';
	Request.Geonosis_DBname = 'CMS';
	
	Request.const_Cr = Chr(13);
	Request.const_Lf = Chr(10);
	Request.const_Tab = Chr(9);
	Request.const_CrLf = Request.const_Cr & Request.const_Lf;
	Request.parentKeyword = 'parent.';
	Request.cf_html_container_symbol = "html_container";
	Request.const_AJAX_loading_image = "images/loading.gif";
	Request.const_paper_color_light_yellow = '##FFFFBF';
	Request.const_color_light_blue = '##80FFFF';
	
	Request.cf_div_floating_debug_menu = 'div_floating_debug_menu';

	Request.const_SHA1PRNG = 'SHA1PRNG';
	Request.const_CFMX_COMPAT = 'CFMX_COMPAT';

	Request.const_encryption_method = 'BLOWFISH';
	Request.const_encryption_encoding = 'Hex';
</cfscript>

<cfscript>
//	Request.cfincludeCFM = 'cfinclude_index_body.cfm'; // This can be a comma-delimited list of ColdFusion source files that are included in the order specified during the index.cfm processing cycle.
	Request.cfincludeCFM = 'cfinclude_index_body2.cfm'; // This can be a comma-delimited list of ColdFusion source files that are included in the order specified during the index.cfm processing cycle.
	// Comment out the following lines once you have read the information containd below.
//	writeOutput('<p align="justify"><small>This is the file called "cfinclude_application.cfm" that contains user-defined code that is included during the application.cfm processing cycle.</small></p>');
//	writeOutput('<p align="justify"><small>The purpose of the "cfinclude_application.cfm" file is to allow the end-user to create user-defined code that defines ColdFusion source files via the variable called "Request.cfincludeCFM" that are loaded sequentially during the processing of the index.cfm file.</small></p>');
//	writeOutput('<p align="justify"><small>This allows the end-user to create user-defined code that runs in the client browser from the context of the exAJAX<sup>(tm)</sup> Framework thus allowing ezAJAX<sup>(tm)</sup> Applications to be easily crafted with little effort.</small></p>');
//	writeOutput('<p align="justify"><small>At this time the following list of ColdFusion source files should contain executable source code "#Request.cfincludeCFM#".</small></p>');
	
	Request.DOCTYPE = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">';
	ezAJAX_title = 'Rabid Packager Powered by ezAJAX&##8482 !  ';
</cfscript>

<cfsavecontent variable="htmlHeader">
	<cfoutput>
		<LINK rel="STYLESHEET" type="text/css" href="#ezAJAX_webRoot#/app/style.css"> 
		<link rel="shortcut icon" type="image/x-icon" href="#ezAJAX_webRoot#/favicon.ico">
		<style type="text/css">
		<!--
		A.ssmItems:link		{color:black;text-decoration:none;}
		A.ssmItems:hover	{color:black;text-decoration:none;}
		A.ssmItems:active	{color:black;text-decoration:none;}
		A.ssmItems:visited	{color:black;text-decoration:none;}
		//-->
		</style>

		<script language="JavaScript1.2" src="#ezAJAX_webRoot#/js/drag-n-drop.js/drag.js" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#ezAJAX_webRoot#/js/drag-n-drop.js/listener.js" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#ezAJAX_webRoot#/js/drag-n-drop.js/slider.js" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#ezAJAX_webRoot#/js/packager.js/javascript.js" type="text/javascript"></script>
	</cfoutput>
</cfsavecontent>

<cfsetting showdebugoutput="No">
