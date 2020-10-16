<cfscript>
	variables.thisServerType = 'dev';

//	_AUTH_USER = 'ms1357';
	_AUTH_USER = 'rh4142';

	_AUTH_PASSWORD = _AUTH_USER;
</cfscript>

<cfif 0>
	<cfscript>
		err_commonCode = false;
		if (FindNoCase('pmprofessionalism', CGI.CF_TEMPLATE_PATH) gt 0) {
			try {
			   commonCode = CreateObject("component","pmprofessionalism.components.commonCode");
	//		   writeOutput('A.');
			} catch(Any e) {
				commonCode = null;
				err_commonCode = true;
			}
		}
		
		if (FindNoCase('ContentManagementSystem', CGI.CF_TEMPLATE_PATH) gt 0) {
			try {
			   commonCode = CreateObject("component","ContentManagementSystem.components.cfc.commonCode");
	//		   writeOutput('B.');
			} catch(Any e) {
				commonCode = null;
				err_commonCode = true;
			}
		}
	
		if (FindNoCase('ContentManagementSystem2', CGI.CF_TEMPLATE_PATH) gt 0) {
			try {
			   commonCode = CreateObject("component","ContentManagementSystem2.components.cfc.commonCode");
	//		   writeOutput('C.');
			} catch(Any e) {
				commonCode = null;
				err_commonCode = true;
			}
		}
	</cfscript>
</cfif>
