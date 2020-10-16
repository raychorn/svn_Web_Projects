<cfapplication name="Pasta-Pomodoro" clientmanagement="Yes" sessionmanagement="Yes" sessiontimeout="#CreateTimeSpan(0, 0, 20, 0)#" applicationtimeout="#CreateTimeSpan(1, 0, 0, 0)#" clientstorage="clientvars" loginstorage="Session"> <!---  setdomaincookies="Yes" --->

<cfset Request.product_metaTags_args = 'GOOGLEBOT=NOARCHIVE,COPYRIGHT=#URLEncodedFormat("&copy;2005, Hierarchical Applications Limited - All Rights Reserved")#,author=#URLEncodedFormat("&copy;2005, Hierarchical Applications Limited - All Rights Reserved")#,keywords=,description=#URLEncodedFormat("No part of this product may be used, reproduced or distributed without the expressed conscent, in writing, of Hierarchical Applications Limited or a duly authorized agent of same.")#,robots=#URLEncodedFormat("index,follow")#,category=home page'>
<cfset Request.cfFlash_metaTags_args = 'GOOGLEBOT=NOARCHIVE,COPYRIGHT=#URLEncodedFormat("&copy;2005, Hierarchical Applications Limited - All Rights Reserved")#,author=#URLEncodedFormat("&copy;2005, Hierarchical Applications Limited - All Rights Reserved")#,keywords=,description=#URLEncodedFormat("No part of this product may be used, reproduced or distributed without the expressed conscent, in writing, of Hierarchical Applications Limited or a duly authorized agent of same.")#,robots=#URLEncodedFormat("noindex,nofollow")#,category=private'>

<cfset Request.url_prefix = ReplaceNoCase(CGI.SCRIPT_NAME, GetToken(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '/'), '')>
<cfset Request.url_prefix_one_level_up = ReplaceNoCase(Request.url_prefix, GetToken(Request.url_prefix, ListLen(Request.url_prefix, '/'), '/'), '')>

<cfset Request.DSN = "pastapomodoro">

<cfscript>
	Randomize(Right('#GetTickCount()#', 9), 'SHA1PRNG');
</cfscript>

<cfscript>
	err_CommonCode = false;
	try {
	   Request.CommonCode = CreateObject("component", "cfc.commoncode");
	} catch(Any e) {
		err_CommonCode = true;
	   writeOutput('<font color="red"><b>CommonCode component has NOT been created.</b></font><br>');
	}
</cfscript>

<cfif (err_CommonCode)>
	<cfabort showerror="ERROR: Missing CommonCode component !">
</cfif>

<cfscript>
	err_primitiveCode = false;
	try {
	   Request.primitiveCode = CreateObject("component", "cfc.primitiveCode");
	} catch(Any e) {
		err_primitiveCode = true;
	   writeOutput('<font color="red"><b>primitiveCode component has NOT been created.</b></font><br>');
	}
</cfscript>

<cfif (err_primitiveCode)>
	<cfabort showerror="ERROR: Missing primitiveCode component !">
</cfif>

<cfset Request.js_base_path = "../js">

<cfparam name="Request._disabl_right_click_script_III_js" default="#Request.js_base_path#/disable-right-click-script-III_.js" type="string">

<cfscript>
	Request.primitiveCode.LockAndSet('Application.DSN', Request.DSN, 'Application', '10', 'EXCLUSIVE');
</cfscript>
