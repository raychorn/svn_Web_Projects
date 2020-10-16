<cfcomponent>

	<cffunction name="cf_log" access="public">
		<cfargument name="_someText_" type="string" required="yes">
		
		<cflog file="#Application.applicationName#" type="Information" text="#_someText_#">
	</cffunction>

	<cffunction name="cf_dump" access="public">
		<cfargument name="_aVar_" type="any" required="yes">
		<cfargument name="_aLabel_" type="string" required="yes">
		<cfargument name="_aBool_" type="boolean" default="False">
		
		<cfif (_aBool_)>
			<cfdump var="#_aVar_#" label="#_aLabel_#" expand="Yes">
		<cfelse>
			<cfdump var="#_aVar_#" label="#_aLabel_#" expand="No">
		</cfif>
	</cffunction>

	<cfinclude template="includes/cfinclude_explainError.cfm">
	
	<cfscript>
		if (NOT IsDefined("This.name")) {
			aa = ListToArray(CGI.SCRIPT_NAME, '/');
			subName = aa[1];
			if (Len(subName) gt 0) {
				subName = '_' & subName;
			}

			myAppName = right(reReplace(CGI.SERVER_NAME & subName, "[^a-zA-Z]","_","all"), 64);
			myAppName = ArrayToList(ListToArray(myAppName, '_'), '_');
			This.name = UCASE(myAppName);
		}
		This.clientManagement = "Yes";
		This.sessionManagement = "Yes";
		This.sessionTimeout = "#CreateTimeSpan(0,0,5,0)#";
		This.applicationTimeout = "#CreateTimeSpan(1,0,0,0)#";
		This.clientStorage = "clientvars-ODBC";
		This.loginStorage = "session";
		This.setClientCookies = "Yes";
		This.setDomainCookies = "No";
		This.scriptProtect = "All";
		
		this.cf_log = cf_log;
		this.cf_dump = cf_dump;
		
		this.INTRANET_DS = 'INTRANETDB-ODBC';

		function onError(Exception, EventName) {
			var errorExplanation = '';

			Request.explainError = explainError;
			Request._explainError = _explainError;
			Request.explainErrorWithStack = explainErrorWithStack;
			
			errorExplanation = Request.explainErrorWithStack(Exception, false);

			if ( (Len(Trim(EventName)) gt 0) AND (Len(Trim(errorExplanation)) gt 0) ) {
				this.cf_log(Application.applicationname, 'Error', '[#EventName#] [#errorExplanation#]');
			}

			if (NOT ( (EventName IS "onSessionEnd") OR (EventName IS "onApplicationEnd") ) ) {
				writeOutput('<h2>An unexpected error occurred.</h2>');
				writeOutput('<p>Error Event: #EventName#</p>');
				writeOutput('<p>Error details:<br>');
				if (FindNoCase("DEEPSPACENINE", CGI.SERVER_NAME) gt 0) {
				//	cf_dump(Exception, EventName, false);
					writeOutput(Request.explainErrorWithStack(Exception, false));
				} else {
					writeOutput(Request.explainErrorWithStack(Exception, true));
				}
			}
		}

		function onSessionStart() {
			try {
				Session.started = now();
				if (NOT IsDefined("Application.sessions")) {
					Application.sessions = 0;
				}
				Application.sessions = Application.sessions + 1;
				this.cf_log('Session #Session.sessionid# started. Active sessions: #Application.sessions#');
			} catch (Any e) {
				this.cf_log('ERROR :: onSessonStart :: [#explainErrorWithStack(e, false)#]');
			}
		}
	</cfscript>

	<cffunction name="onSessionEnd">
		<cfargument name = "SessionScope" required=true/>
		<cfargument name = "AppScope" required=true/>
	
		<cfset var sessionLength = TimeFormat(Now() - SessionScope.started, "H:mm:ss")>
		<cflock name="AppLock" timeout="5" type="Exclusive">
			<cfif (NOT IsDefined("Arguments.AppScope.sessions"))>
				<cfset ApplicationScope.sessions = 0>
			</cfif>
			<cfset Arguments.AppScope.sessions = Arguments.AppScope.sessions - 1>
		</cflock>

		<cflog file="#Arguments.AppScope.applicationName#" type="Information" text="Session #Arguments.SessionScope.sessionid# ended. Length: #sessionLength# Active sessions: #Arguments.AppScope.sessions#">
	</cffunction>

	<cffunction name="onApplicationStart" access="public">
		<cfif 0>
			<cftry>
				<!--- Test whether the DB is accessible by selecting some data. --->
				<cfquery name="testDB" dataSource="#Request.INTRANET_DS#">
					SELECT TOP 1 * FROM AvnUsers
				</cfquery>
				<!--- If we get a database error, report an error to the user, log the
				      error information, and do not start the application. --->
				<cfcatch type="database">
					<cfoutput>
						This application encountered an error<br>
						Unable to use the ColdFusion Data Source named "#Request.INTRANET_DS#"<br>
						Please contact support.
					</cfoutput>
					<cflog file="#This.Name#" type="error" text="#Request.INTRANET_DS# DSN is not available. message: #cfcatch.message# Detail: #cfcatch.detail# Native Error: #cfcatch.NativeErrorCode#" >
					<cfreturn False>
				</cfcatch>
			</cftry>
		</cfif>

		<cflog file="#This.Name#" type="Information" text="Application Started">
		<!--- You do not have to lock code in the onApplicationStart method that sets
		      Application scope variables. --->
		<cfscript>
			Application.sessions = 0;
		</cfscript>
		<cfreturn True>
	</cffunction>

	<cffunction name="onApplicationEnd" access="public">
		<cfargument name="ApplicationScope" required=true/>
		<cflog file="#This.Name#" type="Information" text="Application #Arguments.ApplicationScope.applicationname# Ended" >
	</cffunction>

	<cffunction name="onRequestStart" access="public">
		<cfargument name = "_targetPage" required=true/>

		<cfscript>
			var err_ajaxCode = false;
			var err_ajaxCodeMsg = '';
			var errorExplanation = '';
		</cfscript>

		<cfscript>
			Request.cf_log = this.cf_log;
			Request.cf_dump = this.cf_dump;
			Request.explainError = explainError;
			Request.explainObject = explainError;
			Request._explainError = _explainError;
			Request.explainErrorWithStack = explainErrorWithStack;
		</cfscript>
		
		<cfscript>
			Request.INTRANET_DS = this.INTRANET_DS;
			
			Request.const_Cr = Chr(13);
			Request.const_Lf = Chr(10);
			Request.const_Tab = Chr(9);
			Request.const_CrLf = Request.const_Cr & Request.const_Lf;
			Request.parentKeyword = 'parent.';
			Request.cf_html_container_symbol = "html_container";
			Request.const_jsapi_loading_image = "images/loading.gif";
			Request.const_paper_color_light_yellow = '##FFFFBF';
			Request.const_color_light_blue = '##80FFFF';
			
			Request.const_SHA1PRNG = 'SHA1PRNG';
			Request.const_CFMX_COMPAT = 'CFMX_COMPAT';

			Request.const_encryption_method = 'BLOWFISH';
			Request.const_encryption_encoding = 'Hex';
			
			Request.const_js_gateway_time_out_symbol = 10; // allow user to take corrective action whenever the server doesn't respond in 10 secs...

			Request.AUTH_USER = 'admin';

			err_ajaxCode = false;
			err_ajaxCodeMsg = '';
			try {
			   Request.commonCode = CreateObject("component", "cfc.ajaxCode");
			} catch(Any e) {
				err_ajaxCode = true;
				err_ajaxCodeMsg = '(1) The ajaxCode component has NOT been created.';
				writeOutput('<font color="red"><b>#err_ajaxCodeMsg#</b></font><br>');
			}
			if (err_ajaxCode) {
				Request.cf_log(Application.applicationname, 'Error', '[#err_ajaxCodeMsg#]');
			}

			Request._cfm_path = "AJAX-cfm/";
			Request.cfm_gateway_process_html = "#Request._cfm_path#AJAX_functions.cfm";
		</cfscript>

		<cfreturn True>
	</cffunction>

	<cffunction name="onRequestEnd" access="public">
		<cfargument name = "_targetPage" required=true/>
	</cffunction>
</cfcomponent>
