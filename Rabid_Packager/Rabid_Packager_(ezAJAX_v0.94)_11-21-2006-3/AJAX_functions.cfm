<cfsetting showdebugoutput="No" enablecfoutputonly="Yes">

<cfscript>
	err_ajaxFunctions = false;
	err_ajaxFunctionsMsg = '';
	try {
		ajaxFunctions = CreateObject("component", "cfc.ajaxFunctions");
	} catch(Any e) {
		Request.commonCode = -1;
		err_ajaxFunctions = true;
		err_ajaxFunctionsMsg = '(1+) The ajaxFunctions component has NOT been created.';
		writeOutput('<font color="red"><b>#err_ajaxFunctionsMsg#</b></font><br>');
	}
	
	ajaxFunctions.doAJAXFunction();
</cfscript>
