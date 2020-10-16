<cfsetting showdebugoutput="No" requesttimeout="120" enablecfoutputonly="Yes">
<!--- 
		ezAJAX-Registrations/registerProduct.cfm
		This system takes the information from the client who is installing the product with the end result being a valid
		Runtime License file that is downloaded by the Installer program during the installation process.
 --->
<cfscript>
try {
	Request.myDSN = application.blog.instance.dsn;
} catch (Any e) {
	Request.myDSN = 'EZAJAX_USERS';
}
</cfscript>

<cfset defaultProductVersion = "0.94">

<cfparam name="URL.computerID" type="string" default="">
<cfparam name="URL.serverName" type="string" default="">
<cfparam name="URL.userName" type="string" default="">
<cfparam name="URL.osid" type="string" default="">
<cfparam name="URL.productVersion" type="string" default="#defaultProductVersion#">

<cfscript>
if ( (NOT IsNumeric(URL.productVersion)) OR (URL.productVersion lt defaultProductVersion) ) {
	URL.productVersion = defaultProductVersion;
}
</cfscript>

<cffunction name="ezCfHttp" returntype="string" access="public">
<cfargument name="_url" type="string" required="Yes">
<cfargument name="_method" type="string" required="Yes">
<cfargument name="_queryString" type="string" default="">

<cfscript>
	if ( (NOT (_method IS "POST")) AND (NOT (_method IS "GET")) ) {
		_method = "GET";
	}
</cfscript>

<cfset Request.cfhttpError = false>
<cfset Request.explainErrorText = "">
<cfset Request.explainErrorHTML = "">
<cftry>
	<cfhttp method="#_method#" url="#_url#">
		<cfhttpparam type="FORMFIELD" name="parms" value="#_queryString#">
	</cfhttp>

	<cfcatch type="Any">
		<cfset Request.cfhttpError = true>
		<cfsavecontent variable="Request.explainErrorText"><cfoutput>#ezExplainError(cfcatch, false)#</cfoutput></cfsavecontent>
		<cfsavecontent variable="Request.explainErrorHTML"><cfoutput>#ezExplainError(cfcatch, true)#</cfoutput></cfsavecontent>
	</cfcatch>
</cftry>
</cffunction>

<cffunction name="ezIsValidServerName" access="public" returntype="boolean">
<cfargument name="_serverName" type="string" required="Yes">

<cfset var invalidChars = "@">
<cfset var invalidCount = 0>
<cfset var i = -1>
<cfset var ch = -1>
<cfset var j = -1>
<cfset var _f = -1>
<cfset var invalidCharsN = Len(invalidChars)>

<cfscript>
	for (i = 1; i lte invalidCharsN; i = i + 1) {
		ch = Mid(invalidChars, i, 1);
		_f = FindNoCase(ch, _serverName, 1);
		if (_f gt 0) {
			invalidCount = invalidCount + 1;
		}
	}
</cfscript>

<cfreturn (invalidCount eq 0)>
</cffunction>

<cfset echoEmailAddrs = "support@ez-ajax.com">

<cfsavecontent variable="successfulProductRegistrationNotice">
	<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<H3 style="color: blue;">Congratulations on successfully Registering your copy of exAJAX&##8482 Community Edition Framework</H3>

<small>Your Runtime License file is attached.  Be sure you save this file as "runtimeLicense.dat" and place it in the root folder where you installed exAJAX&##8482 Community Edition Framework.</small><br>
<small>If you encounter any problems or you cannot find the attached file then contact our Support Department at support@ez-ajax.com for help with your issues.</small>
<small>You can also Manage your Runtime Licenses by <a href="http://www.ez-ajax.com/app/content_Runtime%20Licenses.html" target="_blank">clicking here</a>.</small>

</body>
</html>
	</cfoutput>
</cfsavecontent>

<cffunction name="do_resendProductRegistrationNotice" access="public" returntype="string">
	<cfset var _html = "">

	<cfsavecontent variable="_html">
		<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<H3 style="color: blue;">Congratulations Again on successfully Registering your copy of exAJAX&##8482 Community Edition Framework</H3>

<small>Your Runtime License file is attached.  Be sure you save this file as "runtimeLicense.dat" and place it in the root folder where you installed exAJAX&##8482 Community Edition Framework.</small><br>
<small>If you encounter any problems or you cannot find the attached file then contact our Support Department at support@ez-ajax.com for help with your issues.</small>
<small>You can also Manage your Runtime Licenses by <a href="http://www.ez-ajax.com/app/content_Runtime%20Licenses.html" target="_blank">clicking here</a>.</small>

</body>
</html>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn _html>
</cffunction>

<cffunction name="errorReportNotification" output="No" access="public" returntype="string">
	<cfargument name="_noticeTxt_" type="string" required="Yes">
	<cfargument name="_extraTxt_" type="string" required="Yes">
	
	<cfsavecontent variable="_html">
		<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>&copy; Hierarchical Applications Limited, All Rights Reserved.</title>
</head>

<body>

<H5 style="color: red;">#_noticeTxt_#, #_extraTxt_#</H5>

<cfdump var="#URL#" label="URL Scope" expand="Yes">

</body>
</html>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn _html>
</cffunction>

<cfscript>
Request.ezAJAX_DSN = 'EZAJAX-Registrations';

function getRuntimeLicenseForEndDate(aDate, aProductName, computerID, productVersion, aServerName, aFilePath) {
	var aStruct = StructNew();
	var _wddxData = '';
	var _wddxDataStream = '';
	aStruct.runtimeLicenseExpirationDate = aDate;
	aStruct.RuntimeLicenseStatus = '';
	aStruct.computerID = Trim(computerID);
	aStruct.ProductName = aProductName;
	aStruct.ServerName = aServerName;
	aStruct.productVersion = productVersion;
	aStruct.ColdfusionID = server.coldfusion.productname & ' ' & ListFirst(server.coldfusion.productversion) & '.' & ListGetAt(server.coldfusion.productversion, 2);
	aStruct.isCommunityEdition = true;
	aStruct.copyrightNotice = '&copy; 1990-#Year(Now())# Hierarchical Applications Limited, All Rights Reserved.  Use of or duplication of this software or any software derived from its use is illegal unless specific written permission has been granted by Hierarchical Applications Limited or a duly appointed Officer of this corporation.';
	_wddxData = Request.commonCode.CFML2WDDX(aStruct);
	_wddxDataStream = Request.commonCode.asBlowfishEncryptedHex(_wddxData);

	aStruct._wddxDataStream = _wddxDataStream;

	aStruct.isFileError = false;
	aStruct.filePath = CreateUUID() & "_" & aServerName & "_" & aFilePath;
	Request.commonCode.cf_file_write(ExpandPath(aStruct.filePath), _wddxDataStream);
	aStruct.isFileError = Request.fileError;

	return aStruct;
}

extraError = '';

endDate = DateAdd('d', 30, Now());
cf_trademarkSymbol = '&##8482';
productName = 'exAJAX#cf_trademarkSymbol# Community Edition Framework';
URL.computerID = Trim(URLDecode(URL.computerID));
URL.serverName = Trim(URLDecode(URL.serverName));
URL.userName = Trim(URLDecode(URL.userName));
URL.osid = Trim(URLDecode(URL.osid));
URL.productVersion = Trim(URLDecode(URL.productVersion));
productVersion = URL.productVersion;

URL.serverName = ReplaceNoCase(URL.serverName, 'http://', ''); // just remove the http:// from the server name because server names don't have http:// on them but some people just don't get it.

if (ListLen(URL.serverName, ':') gt 1) {
	URL.serverName = ListFirst(URL.serverName, ':');
}

dataStream = '';
_dataStream = '';

if ( (Len(Trim(URL.userName)) gt 0) AND (ListLen(URL.userName, '@') eq 2) AND (ListLen(URL.userName, '.') gte 1) ) {
	_sql_statement = "SELECT id, email_domain FROM InvalidEmailDomains WHERE (email_domain = '@#ListLast(URL.userName, '@')#')";
	Request.commonCode.safely_execSQL('Request.qIsUsernameInvalid', Request.myDSN, _sql_statement);
	if (NOT Request.dbError) {
		if (Request.qIsUsernameInvalid.recordCount gte 0) { // thRequest.myDSN		_sql_statement = "SELECT id, username FROM UserNames WHERE (username = '#URL.userName#')";
			Request.commonCode.safely_execSQL('Request.qGetUserID', Request.ezAJAX_DSN, _sql_statement);
			if (NOT Request.dbError) {
				uid = -1;
				if (Request.qGetUserID.recordCount gt 0) {
					uid = Request.qGetUserID.id;
				}
				if (uid eq -1) {
					_sql_statement = "INSERT INTO UserNames (username) VALUES ('#URL.userName#'); SELECT @@IDENTITY as 'id';";
					Request.commonCode.safely_execSQL('Request.qAddUserName', Request.ezAJAX_DSN, _sql_statement);
					if (NOT Request.dbError) {
						if (Request.qAddUserName.recordCount gt 0) {
							uid = Request.qAddUserName.id;
						}
					}
				}
	
				if (NOT Request.dbError) {
					sid = -1;
					if ( (Len(URL.serverName) gt 0) AND (ezIsValidServerName(URL.serverName)) ) { // this allows any server name one might imagine using even IP addresses...
						_sql_statement = "SELECT id, uid, serverName FROM ServerNames WHERE (serverName = '#URL.serverName#')";
						Request.commonCode.safely_execSQL('Request.qCheckServerName', Request.ezAJAX_DSN, _sql_statement);
						if (NOT Request.dbError) {
							bool_isServerNameTaken = false;
							if (Request.qCheckServerName.recordCount eq 0) {
								_sql_statement = "INSERT INTO ServerNames (uid, serverName) VALUES (#uid#, '#URL.serverName#'); SELECT @@IDENTITY as 'id';";
								Request.commonCode.safely_execSQL('Request.qAddServerName', Request.ezAJAX_DSN, _sql_statement);

								if (NOT Request.dbError) {
									sid = Request.qAddServerName.id;
								}
							} else {
								sid = Request.qCheckServerName.id;
								bool_isServerNameTaken = (uid neq Request.qCheckServerName.uid);
							}
	
							if ( (NOT Request.dbError) AND (sid neq -1) ) {
								arComputerID = ListToArray(URL.computerID, '|');
								if ( (Left(URL.computerID, 1) is '|') AND (ArrayLen(URL.computerID) eq 2) ) {
									URL.computerID = ' ' & URL.computerID;
									arComputerID = ListToArray(URL.computerID, '|');
								}
								if ( (ArrayLen(arComputerID) gte 2) AND (Len(URL.serverName) gt 0) ) {
									// If there is a runtime License in the DB then retrieve it or make one...
									_sql_statement = "SELECT id, RuntimeLicenseData FROM RuntimeLicenses WHERE (computerID = '#URL.computerID#') AND (sid = #sid#)";
									Request.commonCode.safely_execSQL('Request.qGetLicenseFromDb', Request.ezAJAX_DSN, _sql_statement);
									if (NOT Request.dbError) {
										if (Request.qGetLicenseFromDb.recordCount gt 0) {
											aFilePath = CreateUUID() & "_" & URL.serverName & '_runtimeLicense.dat';
											Request.commonCode.cf_file_write(ExpandPath(aFilePath), Request.qGetLicenseFromDb.RuntimeLicenseData);
											if (NOT Request.fileError) {
												optionsStruct = StructNew();
												optionsStruct.bcc = echoEmailAddrs;
												optionsStruct.cfmailparam = StructNew();
												optionsStruct.cfmailparam.type = 'text/plain';
												optionsStruct.cfmailparam.file = 'http:' & '/' & '/' & CGI.SERVER_NAME & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), aFilePath, '/');
												Request.commonCode.safely_cfmail(URL.userName, 'sales@ez-ajax.com', 'Attached is your Runtime License for ezAJAX(tm) for #URL.userName# / #URL.serverName#', do_resendProductRegistrationNotice(), optionsStruct);
												if (NOT Request.anError) {
													dataStream = 'Notice 102. Your Runtime License, which was previously created for you, has been resent to your email address.';	
												} else {
													dataStream = 'Warning 102. Another Runtime License cannot be created at this time because there is already a Runtime License issued for the same physical computer as the one just submitted. Only one Trial License per physical computer can be issued.  You can transfer a Trial License upon request for a nominal fee, contact us at sales@ez-ajax.com.  At this time you may perform an installation by proceeding with the Installer.';
												}
											} else {
												dataStream = 'Error 102.1 Cannot issue a Runtime License at this time due to a technical issue. Kindly contact our Support Department at support@ez-ajax.com to get this problem resolved.';
											}
										} else {
											aStruct = getRuntimeLicenseForEndDate(endDate, productName, URL.computerID, productVersion, URL.serverName, 'runtimeLicense.dat');
											bool_isCommunityEdition = 0;
											if (aStruct.isCommunityEdition) {
												bool_isCommunityEdition = 1;
											}
											_sql_statement = "INSERT INTO RuntimeLicenses (sid, expirationDate, computerID, ProductName, productVersion, ServerName, ColdfusionID, osID, isCommunityEdition, copyrightNotice, RuntimeLicenseData) VALUES (#sid#,#CreateODBCDateTime(aStruct.runtimeLicenseExpirationDate)#,'#Request.commonCode.filterQuotesForSQL(aStruct.computerID)#','#Request.commonCode.filterQuotesForSQL(aStruct.ProductName)#','#Request.commonCode.filterQuotesForSQL(aStruct.productVersion)#', '#Request.commonCode.filterQuotesForSQL(aStruct.ServerName)#','#Request.commonCode.filterQuotesForSQL(aStruct.ColdfusionID)#', '#Request.commonCode.filterQuotesForSQL(URL.osid)#',#bool_isCommunityEdition#,'#Request.commonCode.filterQuotesForSQL(aStruct.copyrightNotice)#','#Request.commonCode.filterQuotesForSQL(aStruct._wddxDataStream)#'); SELECT @@IDENTITY as 'id';";
											Request.commonCode.safely_execSQL('Request.qAddLicenseToDb', Request.ezAJAX_DSN, _sql_statement);
											if (NOT Request.dbError) {
												// email the file to the URL.userName...
												optionsStruct = StructNew();
												optionsStruct.bcc = echoEmailAddrs;
												optionsStruct.cfmailparam = StructNew();
												optionsStruct.cfmailparam.type = 'text/plain';
												optionsStruct.cfmailparam.file = 'http:' & '/' & '/' & CGI.SERVER_NAME & ListSetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), aStruct.filePath, '/');
												Request.commonCode.safely_cfmail(URL.userName, 'sales@ez-ajax.com', 'Attached is your Runtime License for ezAJAX(tm) for #URL.userName# / #aStruct.ServerName#', successfulProductRegistrationNotice, optionsStruct);
												if (NOT Request.anError) {
													dataStream = 'OK';
												} else {
													extraError = extraError & Request.errorMsg;
													dataStream = 'Error 101. The Runtime License has been assigned to you however it cannot be emailed to you due to some kind of technical issue that is being resolved.  Kindly send an email to registrations@ez-ajax.com to request that your Runtime License file be emailed to you directly and this will be done.';
												}
											} else {
												if (NOT Request.isPKviolation) {
													extraError = extraError & Request.explainErrorText;
													dataStream = 'Error 102.2 The Username entered cannot be used due to some kind of technical issue we are in the process of resolving.';
												} else {
													dataStream = 'Error 102.3 Cannot issue another Runtime License for Server Name of "#URL.serverName#" because a Runtime License was already issued for your Physical Server.  You may contact our Sales Department at sales@ez-ajax.com to purchase the Runtime Licenses you require to meet your specific needs.';
													_dataStream = 'Error 102.3 Cannot issue another Runtime License for Server Name of "#URL.serverName#" because a Runtime License was already issued for your Physical Server (#URL.computerID#).  You may contact our Sales Department at sales@ez-ajax.com to purchase the Runtime Licenses you require to meet your specific needs.';
												}
											}
										}
									} else {
										dataStream = 'Error 102.1 Cannot issue a Runtime License at this time due to a technical issue. Kindly contact our Support Department at support@ez-ajax.com to get this problem resolved.';
									}
								} else {
									dataStream = 'Error 103. Invalid or Missing parameters that were required for product registration.';	
								}
							} else {
								extraError = extraError & Request.explainErrorText;
								dataStream = 'Error 106. The Username (#URL.userName#) entered cannot be used due to some kind of technical issue we are in the process of resolving.';	
							}
						} else {
							extraError = extraError & Request.explainErrorText;
							dataStream = 'Error 107. The Username entered cannot be used due to some kind of technical issue we are in the process of resolving.';	
						}
					} else {
						dataStream = 'Error 108. The Server Name (#URL.serverName#) entered by (#URL.userName#) cannot be used because it does not appear to be a valid Domain Name or Server name for the purposes of creating a usable Runtime License for this product.  Your Server Name or Domain Name is the common name your web server responds to when accessing your web based content.  Carefully read the instructions as you use the Installer Program so you can get the Runtime License you need to use our product(s).';	
					}
				} else {
					extraError = extraError & Request.explainErrorText;
					dataStream = 'Error 109. The Username (#URL.userName#) entered cannot be used due to some kind of technical issue we are in the process of resolving.';	
				}
			} else {
				extraError = extraError & Request.explainErrorText;
				dataStream = 'Error 110. The Username (#URL.userName#) entered cannot be used due to some kind of technical issue we are in the process of resolving.';	
			}
		} else {
			dataStream = 'Error 111. The Username (#URL.userName#) entered cannot be used because it is invalid - the domain for the username is known to provide anonymous email services.';	
		}
	} else {
		extraError = extraError & Request.explainErrorText;
		dataStream = 'Error 112. The Username (#URL.userName#) entered cannot be used because the domain for your email address cannot be used. Please use a email address for an email account for a non-public non-Free domain. Email domains such as hotmail.com and gmail.com are far too easy for hackers to exploit.';	
	}
} else {
	dataStream = 'Error 113. The Username (#URL.userName#) entered cannot be used because it is invalid - your username MUST be a valid Internet Email address however (#URL.userName#) is not valid.';	
}
</cfscript>

<cfif (FindNoCase('Error ', dataStream) gt 0)>
<cfscript>
	if (Len(_dataStream) gt 0) {
		dataStream = _dataStream;
	}
	Request.commonCode.safely_cfmail(echoEmailAddrs, 'sales@ez-ajax.com', 'ezAJAX(tm) Registration System Error Report', errorReportNotification(dataStream, extraError));
</cfscript>
<cflog file="#Application.applicationName#_Registrations" type="Information" text="#dataStream#, #extraError#">
</cfif>

<cfoutput>
<CFHEADER NAME="Expires" VALUE="Mon, 06 Jan 1990 00:00:01 GMT">
<CFHEADER NAME="Pragma" VALUE="no-cache">
<CFHEADER NAME="cache-control" VALUE="no-cache">
<cfcontent type="text/html" variable="#ToBinary(ToBase64(dataStream))#">
</cfoutput>
