<cfcomponent>

	<cftry>
		<cfinclude template="includes/cfinclude_explainError.cfm">
		<cfinclude template="includes/cfinclude_cflog.cfm">
		<cfinclude template="includes/cfinclude_cfdump.cfm">

		<cfcatch type="Any">
		</cfcatch>
	</cftry>

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
	</cfscript>
	<cfset This.clientManagement = "Yes">
	<cfset This.sessionManagement = "Yes">
	<cfset This.sessionTimeout = CreateTimeSpan(0,1,0,0)>
	<cfset This.applicationTimeout = CreateTimeSpan(1,0,0,0)>
	<cfset This.clientStorage = "clientvars">
	<cfset This.loginStorage = "session">
	<cfset This.setClientCookies = "No">
	<cfset This.setDomainCookies = "No">
	<cfset This.scriptProtect = "All">

	<cffunction name="errorPage" output="No">
		<cfinclude template="error.cfm">
	</cffunction>

	<cffunction name="ajaxFooterPage" output="No">
		<cfinclude template="AJAX-Framework/AJAX/cfinclude_AJAX_Init.cfm">
		<cfinclude template="AJAX-Framework/AJAX/cfinclude_AJAX_End.cfm">
	</cffunction>

	<cfscript>
		this.cf_log = cf_log;
		this.cf_dump = cf_dump;

		function onError(Exception, EventName) {
			var errorExplanation = '';
			var isUsing_AJAXFramework = (FindNoCase('/AJAX-Framework/', CGI.SCRIPT_NAME) gt 0);
			
			Request._explainError = _explainError;
			Request.explainError = explainError;
			Request.explainErrorWithStack = explainErrorWithStack;

			errorExplanation = Request.explainErrorWithStack(Exception, false);

			if ( (Len(Trim(EventName)) gt 0) AND (Len(Trim(errorExplanation)) gt 0) ) {
				this.cf_log('[#EventName#] [#errorExplanation#]');
			}

			if (NOT ( (EventName IS "onSessionEnd") OR (EventName IS "onApplicationEnd") ) ) {
				if (isUsing_AJAXFramework) {
					arList = 'Exception.template,Exception.dateTime,Exception.mailTo,Exception.browser,Exception.remoteAddress,Exception.HTTPReferer,Exception.message,Exception.queryString,Exception.rootCause,Exception.diagnostics,Exception.validationHeader,Exception.invalidFields,Exception.validationFooter';
				
					errorMsg = errorMsg & 'An unexpected error occurred.' & Chr(13);
					ar = ListToArray(arList, ',');
					arN = ArrayLen(ar);
					for (i = 1; i lte arN; i = i + 1) {
						try {
							errorMsg = errorMsg & ar[i] & ': ' & Request.commonCode.compressErrorMsgs(Evaluate(ar[i])) & Chr(13);
						} catch (Any e) {
						}
					}
					errorMsg = errorMsg & 'Error details:' & Chr(13);
				
					errorMsg = errorMsg & Request.commonCode.compressErrorMsgs(Request.commonCode.explainErrorWithStack(Exception, false));
				
					qObj = QueryNew('id, errorMsg');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', errorMsg, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					
					ajaxFooterPage();
				} else {
					if (isDebugMode()) {
						writeOutput('<table width="100%" cellpadding="-1" cellspacing="-1">');
						writeOutput('<tr>');
						writeOutput('<td>');
						writeOutput(cf_dump(Application, 'Application Scope', false));
						writeOutput('</td>');
						writeOutput('<td>');
						writeOutput(cf_dump(Session, 'Session Scope', false));
						writeOutput('</td>');
						writeOutput('<td>');
						writeOutput(cf_dump(CGI, 'CGI Scope', false));
						writeOutput('</td>');
						writeOutput('<td>');
						writeOutput(cf_dump(URL, 'URL Scope', false));
						writeOutput('</td>');
						writeOutput('<td>');
						writeOutput(cf_dump(FORM, 'FORM Scope', false));
						writeOutput('</td>');
						writeOutput('<td>');
						writeOutput(cf_dump(Exception, 'CF Error: (' & EventName & ')', false));
						writeOutput('</td>');
						writeOutput('</tr>');
						writeOutput('</table>');
					} else {
						Request.Exception = Exception;
						errorPage();
					}
				}
			}
		}
	</cfscript>

	<cffunction name="onSessionStart">
		<cfset Session.started = now()>
		<cfset Application.sessions = Application.sessions + 1>
		<cflog file="#Application.applicationName#" type="Information" text="Session #Session.sessionid# started. Active sessions: #Application.sessions#">
	</cffunction>

	<cffunction name="onSessionEnd">
		<cfargument name = "SessionScope" required=true/>
		<cfargument name = "AppScope" required=true/>
	
		<cfset var sessionLength = TimeFormat(Now() - SessionScope.started, "H:mm:ss")>
		<cfif (NOT IsDefined("Arguments.AppScope.sessions"))>
			<cfset ApplicationScope.sessions = 0>
		</cfif>
		<cfset Arguments.AppScope.sessions = Arguments.AppScope.sessions - 1>

		<cfif 0>
			<cfscript>
				if ( (IsDefined("Session.sessID")) AND (Session.sessID gt 0) ) {
					_sqlStatement = "DELETE FROM Sessions WHERE (sessionUUID = '#Session.sessID#')";
					Request.commonCode.safely_execSQL('Request.qDropSession', Request.ClusterDB_DSN, _sqlStatement);
					if (Request.dbError) {
						Request.commonCode.cf_log('[#Request.explainErrorText#] [#_sqlStatement#]');
					}
				}
			</cfscript>
		</cfif>

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
			var err_commonCode = -1;
			var err_commonCodeMsg = -1;
			var isUsing_AJAXFramework = (FindNoCase('/AJAX-Framework/', CGI.SCRIPT_NAME) gt 0);
		</cfscript>

		<cfscript>
		//	Request.bool_isDebugUser = ( (CGI.REMOTE_ADDR eq '127.0.0.1') OR (Find('192.168.', CGI.REMOTE_ADDR) gt 0) );
		//	Request.bool_isDebugUser = (CGI.REMOTE_ADDR eq '127.0.0.1');
			Request.bool_isDebugUser = false;

		//	Request.bool_isDebugMode = ( (CGI.REMOTE_ADDR eq '127.0.0.1') OR (Find('192.168.', CGI.REMOTE_ADDR) gt 0) );
			Request.bool_isDebugMode = false;
			
			if (isUsing_AJAXFramework) {
				Request.DSN = 'KLADB';
				
				Request.bool_useNewMenu = (CGI.REMOTE_ADDR eq "127.0.0.1");
				
				Request.const_Cr = Chr(13);
				Request.const_Lf = Chr(10);
				Request.const_Tab = Chr(9);
				Request.const_CrLf = Request.const_Cr & Request.const_Lf;
				Request.parentKeyword = 'parent.';
				Request.cf_html_container_symbol = "html_container";
				Request.const_jsapi_loading_image = "images/loading.gif";
				Request.const_busy_loading_image = "images/wait.gif";
				Request.const_paper_color_light_yellow = '##FFFFBF';
				Request.const_color_light_blue = '##80FFFF';
				
				temporalIndex = '#GetTickCount()#';
				Randomize(Right(temporalIndex, Min(Len(temporalIndex), 9)), 'SHA1PRNG');
				
				Request.cf_div_floating_debug_menu = 'div_floating_debug_menu';
				
				Request.AUTH_USER = 'admin';
			
				err_ajaxCode = false;
				err_ajaxCodeMsg = '';
				try {
				   Request.commonCode = CreateObject("component", ListFirst(CGI.SCRIPT_NAME, '/') & ".AJAX-Framework.ajax.cfc.ajaxCode");
				} catch(Any e) {
					err_ajaxCode = true;
					err_ajaxCodeMsg = '(1) The ajaxCode component has NOT been created.';
					writeOutput('<font color="red"><b>#err_ajaxCodeMsg# | Reason: [#e.message#] [#e.detail#]</b></font><br>');
				}
				if (err_ajaxCode) {
					this.cf_log('[#err_ajaxCodeMsg#]');
				}
				
				err_someCode = false;
				err_someCodeMsg = '';
				try {
				   Request.pythonCode = CreateObject("component", ListFirst(CGI.SCRIPT_NAME, '/') & ".AJAX-Framework.cfc.pythonInterpreter");
				} catch(Any e) {
					err_someCode = true;
					err_someCodeMsg = '(1) The pythonInterpreter component has NOT been created.';
					writeOutput('<font color="red"><b>#err_someCodeMsg# | Reason: [#e.message#] [#e.detail#]</b></font><br>');
				}
				if (err_someCode) {
					this.cf_log('[#err_someCodeMsg#]');
				}
			
				Request._cfm_path = '/' & ListFirst(CGI.SCRIPT_NAME, '/') & "/ajax/";
				Request.cfm_gateway_process_html = "#Request._cfm_path#AJAX_functions.cfm";
			} else {
				err_commonCode = false;
				err_commonCodeMsg = '';
				try {
				   Request.commonCode = CreateObject("component", "cfc.commonCode");
				} catch(Any e) {
					Request.commonCode = -1;
					err_commonCode = true;
					err_commonCodeMsg = '(1) The commonCode component has NOT been created.';
					writeOutput('<font color="red"><b>#err_commonCodeMsg#</b></font><br>');
			   		if (Request.bool_isDebugUser) writeOutput(cf_dump(e, 'Exception (e)', false));
				}
			}

			Request.pagesThatMustHaveReferrer = 'agooglead.cfm,cfcontent_img.cfm,cfcontent_js.cfm,addcomment.cfm,category_editor.cfm,contactUs.cfm,editor.cfm,eula.cfm,forgotPassword.cfm,login.cfm,print.cfm,register.cfm,stats.cfm,trackback.cfm,trackbacks.cfm,unsubscribe.cfm,newCalendar.cfm,newDownloads.cfm';

			if (ListFindNoCase(Request.pagesThatMustHaveReferrer, ListLast(_targetPage, "/"), ",") gt 0) {
				if (Request.commonCode.getClusterizedDomainFromReferrer(CGI.HTTP_REFERER) neq Request.commonCode._clusterizeURL('http://' & CGI.SERVER_NAME)) return false;
			}
		</cfscript>

		<cfinclude template="includes/cfinclude_encryptionSupport.cfm">
				
		<cfscript>
			Request.const_owners_blog_url = 'http://rabid.contentopia.net/blog/';
			Request.typeOf_emailsContent = 'HTML';

			Request.folder_mask = "_433511201010924803";
			
			if (IsDefined("Request.commonCode.cf_log")) {
				Request.cf_log = Request.commonCode.cf_log;
			}
			if (IsDefined("Request.commonCode.cf_dump")) {
				Request.cf_dump = Request.commonCode.cf_dump;
			}
			if (IsDefined("Request.commonCode._explainError")) {
				Request._explainError = Request.commonCode._explainError;
			}
			if (IsDefined("Request.commonCode.explainError")) {
				Request.explainError = Request.commonCode.explainError;
			}
			if (IsDefined("Request.commonCode.explainErrorWithStack")) {
				Request.explainErrorWithStack = Request.commonCode.explainErrorWithStack;
			}
		</cfscript>
		
		<cfscript>
			if (0) {
				Request.SSL_Server_Matrix = 'rabid.1.contentopia.net/blog=babylon5.ssl-docs.com/blog,rabid.2.contentopia.net/blog=babylon5.ssl-docs.com/blog';
			} else {
				Request.SSL_Server_Matrix = 'rabid.1.contentopia.net/blog=rabid.1.contentopia.net/blog,rabid.2.contentopia.net/blog=rabid.2.contentopia.net/blog';
			}
		
			Request.doNotSessionThesePages = 'agooglead.cfm,cfcontent_img.cfm,cfcontent_js.cfm,external.cfm,validateUserAccount.cfm';
			
			Request.bool_doNotSessionThesePages = NOT (ListFindNoCase(Request.doNotSessionThesePages, ListLast(_targetPage, "/"), ",") eq 0);
		</cfscript>

		<cfif (NOT Request.bool_doNotSessionThesePages)>
			<cfscript>
				if (IsDefined("URL.sessid")) {
					Request.commonCode.readSessionFromDb(URL.sessid);
				} else {
					Request.commonCode.readSessionFromDb();
				}
			</cfscript>
		</cfif>

		<cfscript>
			Request.const_blogURLMode_IIS = 'IIS';
			Request.const_blogURLMode_APACHE = 'APACHE';
			Request.const_blogURLMode_APACHE2 = 'APACHE2';
			if (FindNoCase(Request.const_blogURLMode_APACHE, CGI.SERVER_SOFTWARE) gt 0) {
				if ( (FindNoCase('\Apache2\htdocs\', CGI.PATH_TRANSLATED) gt 0) OR (FindNoCase('C:\Inetpub\wwwroot\', CGI.PATH_TRANSLATED) gt 0) ) {
					Request.blogURLMode = Request.const_blogURLMode_APACHE2;
				} else {
					Request.blogURLMode = Request.const_blogURLMode_APACHE;
				}
			} else {
				Request.blogURLMode = Request.const_blogURLMode_IIS;
			}
			Request.overrideServerMode = false;
			
			temporalIndex = '#GetTickCount()#';
			Randomize(Right(temporalIndex, Min(Len(temporalIndex), 9)), 'SHA1PRNG');
		</cfscript>
		
		<cfscript>
			bool_isInvalidReferral = false;
		//	allowedReferers = 'paypal.com,google.com,google.de,google.com.au,yahoo.com,macromedia.com,contentopia.net,halsmalltalker.com,postami.com,blogspot.com';
			allowedReferers = '';
		</cfscript>

		<!--- BEGIN: SpiderBots are assumed to have empty CGI.HTTP_REFERER because Bots are headless programs that collect content to index --->
		<cfif (NOT Request.commonCode.isSpiderBot())>
			<cfscript>
				if (IsDefined("session.persistData.assumedToBeSpiderBot")) {
					if (session.persistData.assumedToBeSpiderBot) {
						session.persistData.assumedToBeSpiderBot = false;
						session.persistData.loggedin = false; // the user was "assumed" to be a spiderBot but is not now which means the user spoofed being a spiderBot to gain access but then clicked on something to make the CGI.HTTP_REFERER something other than blank...
					}
				}
				
				bool_isInvalidReferral = false; // relax this for now because only Registered User can see content...
				if ( (Len(allowedReferers) gt 0) AND (Len(CGI.HTTP_REFERER) gt 0) ) {
					bool_isInvalidReferral = true;
					ar_allowedReferers = ListToArray(allowedReferers, ',');
					n = ArrayLen(ar_allowedReferers);
					for (i = 1; i lte n; i = i + 1) {
						if (FindNoCase(ar_allowedReferers[i], CGI.HTTP_REFERER) gt 0) {
							bool_isInvalidReferral = false;
							break;
						}
					}
				}
			</cfscript>
		<cfelse>
			 <!--- the user is a spider bot at this point --->
			<cfif (NOT session.persistData.loggedin)>
				<cfset session.persistData.assumedToBeSpiderBot = true>
				<cfset session.persistData.loggedin = true> <!--- grant full access until no longer a spider-bot --->
			</cfif>
		</cfif>
		<!--- END! SpiderBots are assumed to have empty CGI.HTTP_REFERER because Bots are headless programs that collect content to index --->

		<cfif (NOT IsDefined("Session.persistData"))>
			<cfset Session.persistData = StructNew()>
		</cfif>
		
		<cfif (NOT IsDefined("Session.persistData.loggedin"))>
			<cfset Session.persistData.loggedin = false>
		</cfif>

		<cfset Request.bool_applicationCFC_mode = true>
		<cfif (NOT Request.bool_doNotSessionThesePages)>
			<cfinclude template="original_Application.cfm">
		</cfif>

		<cfif (NOT bool_isInvalidReferral)>
			<cfif (NOT IsDefined("instance")) AND (IsDefined("application.blog.instance"))>
				<cfset instance = application.blog.instance>
			</cfif>

			<cfset dbError = false>
			<cftry>
				<cfquery name="qIsIPAddrFromPastViolation" datasource="#instance.dsn#">
					<cfoutput>
						SELECT COUNT(REMOTE_ADDR) as cnt
						FROM tblCopyrightViolations
						WHERE (REMOTE_ADDR = '#CGI.REMOTE_ADDR#')
					</cfoutput>
				</cfquery>
			
				<cfcatch type="Any">
					<cfset dbError = true>
				</cfcatch>
			</cftry>
			
			<cfset Request.ipAddressWasPreviouslyAbused = false>
			<cfif (NOT dbError) AND (IsDefined("qIsIPAddrFromPastViolation.cnt"))>
				<cfif (qIsIPAddrFromPastViolation.cnt gt 0)>
					<cfset Request.ipAddressWasPreviouslyAbused = true>
					<cfset bool_isInvalidReferral = true>
				</cfif>
			</cfif>
		</cfif>		
		
		<cfif (bool_isInvalidReferral) AND (FindNoCase("/rss.cfm", CGI.SCRIPT_NAME) eq 0)>
			<cfinclude template="invalid_refereral_handler.cfm">
			<cfreturn False>
		</cfif>

		<cfscript>
			Request.invalidEmailDomains = Request.commonCode.getInvalidEmailDomains();

			// determine list of invalid email domains from those user accounts that have been flagged as invalid...
			_sqlStatement = "SELECT SUBSTRING(username, PATINDEX('%@%', username), LEN(username) - PATINDEX('%@%', username) + 1) AS invalidEmailDomain FROM tblUsers WHERE (isValid = 0) AND (PATINDEX('%@%', username) > 0)";
			Request.commonCode.safely_execSQL('Request.qGetInvalidEmailDomains', instance.DSN, _sqlStatement);
			if (Request.dbError) {
				Request.commonCode.cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#] [#_sqlStatement#]');
			} else {
				for (i = 1; i lte Request.qGetInvalidEmailDomains.recordCount; i = i + 1) {
					if (ListFindNoCase(Request.invalidEmailDomains, Request.qGetInvalidEmailDomains.invalidEmailDomain[i], ',') eq 0) {
						Request.invalidEmailDomains = ListAppend(Request.invalidEmailDomains, Request.qGetInvalidEmailDomains.invalidEmailDomain[i], ',');
					}
				}
			}
		</cfscript>

		<!--- Security Related --->
		<cfif isDefined("url.logout") and Request.commonCode.isLoggedIn()>
			<cfset structDelete(session,"loggedin")>
			<cfset session.persistData.loggedin = false>
			<cfscript>
				StructDelete(Session.persistData, 'qAuthUser');
				Session.persistData.loginFailure = 0;
			</cfscript>
			<cflogout>
			<cfmodule template="tags/scopecache.cfm" scope="db" clearall="true">		
		</cfif>
		
		<cfreturn True>
	</cffunction>

	<cffunction name="onRequestEnd" access="public">
		<cfargument name = "_targetPage" required=true/>

		<cfset var _sqlStatement = -1>

		<cfif (ListFindNoCase(Request.doNotSessionThesePages, ListLast(_targetPage, "/"), ",") eq 0)>
			<cfscript>
				Request.commonCode.commitSessionToDb();
			</cfscript>
			
			<cfif (IsDefined("Request.redirectOnRequestEnd")) AND (Len(Trim(Request.redirectOnRequestEnd)) gt 0)>
				<cflocation url="#Request.redirectOnRequestEnd#" addtoken="No">
			</cfif>
		</cfif>

	</cffunction>
</cfcomponent>
