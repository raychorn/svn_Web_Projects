<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="_debugMode" type="boolean" default="False">
<cfparam name="bool_isServerLocal" type="boolean" default="False">

<cfoutput>
	<html>
	<head>
		<title>SiteErrorHandler -- We're sorry -- An Error Occurred</title>

		<style type="text/css"><!--
			BODY {
			margin: 0px;
			padding: 0px;
			background-color: ##FFFFFF;
			color: ##000000;
			font-family: Verdana, Arial, Helvetica, sans-serif;
			font-size: xx-small;
		}
		--></style>
	</head>
	
	<body>
		<cfset Cr = Chr(13)>
		<cfset html_fmtDateTime = DateFormat(error.dateTime, "full") & "&nbsp;" & TimeFormat(error.dateTime, "long")>
		<cfset txt_fmtDateTime = REReplace(REReplace(html_fmtDateTime, "<[^>]*>", "", "all"), "&[^;]*;", "", "all")>
		<cfset terse_errorContent = "Your Location: #error.remoteAddress##Cr#Your Browser: #error.browser##Cr#Date and Time the Error Occurred: #txt_fmtDateTime##Cr#Page You Came From: #error.HTTPReferer##Cr#Message Content: #error.diagnostics##Cr#">
		<cfset _errorContent = "
			<ul>
			    <li><b>Your Location:</b> #error.remoteAddress#</li>
			    <li><b>Your Browser:</b> #error.browser#</li>
			    <li><b>Date and Time the Error Occurred:</b> #html_fmtDateTime#</li>
			    <li><b>Page You Came From:</b> #error.HTTPReferer#</li>
			    <li><b>Message Content</b>:
			    <p>#error.diagnostics#</p></li>
			</ul>
		">

		<cfset isSpecialTemplate = false>

		<cfscript>
			function explainError(_error) {
				var e = '';
				var v = '';
				var vn = '';
				var i = -1;
				var k = -1;
				var sCurrent = -1;
				var sId = -1;
				var sLine = -1;
				var sColumn = -1;
				var sTemplate = -1;
				var _content = '<ul>';
				var _ignoreList = '<remoteAddress>, <browser>, <dateTime>, <HTTPReferer>, <diagnostics>, <TagContext>';
				var _specialList = '<StackTrace>';
				var content_specialList = '';
				var aToken = '';
				var special_templatesList = '\client_server\html_gw.cfm'; // comma-delimited list or template keywords
				
				for (e in _error) {
					if (FindNoCase('<#e#>', _ignoreList) eq 0) {
						v = '--- UNKNOWN --';
						vn = "_error." & e;

						if (IsDefined(vn)) {
							v = Evaluate(vn);
						}

						if (FindNoCase('<#e#>', _specialList) neq 0) {
							v = '<textarea cols="100" rows="20" readonly style="font-size: 10px;">#v#</textarea>';
							content_specialList = content_specialList & '<li><b>#e#</b>&nbsp;#v#</li>';
						} else {
							_content = _content & '<li><b>#e#</b>&nbsp;#v#</li>';
						}
					}
				}
				_content = _content &	'<li><p><b>The contents of the tag stack are:</b>';
				for (i = 1; i neq ArrayLen(_error.TAGCONTEXT); i = i + 1) {
					sCurrent = _error.TAGCONTEXT[i];
					sId = sCurrent["ID"];
					sLine = sCurrent["LINE"];
					sColumn = sCurrent["COLUMN"];
					sTemplate = sCurrent["TEMPLATE"];
					isSpecialTemplate = false;
					for (k = 1; k lte ListLen(special_templatesList, ','); k = k + 1) {
						aToken = GetToken(special_templatesList, k, ',');
						if (FindNoCase(aToken, sTemplate) gt 0) {
							isSpecialTemplate = true;
						}
					}
					_content = _content &	'<br>#i# #sId#' &  '(#sLine#,#sColumn#)' & '#sTemplate#' & '.';
				}
				_content = _content & '</p></li>';
				_content = _content & content_specialList;
				_content = _content & '</ul>';
				
				return _content;
			}
			
			verbose_errorContent = explainError(error);
		</cfscript>

	    <h2>We're sorry -- An Error Occurred</h2>
	    <p>
	        If you continue to have this problem, please contact <a href="mailto:#error.mailTo#?subject=ColdFusion Error for CMS 1.0&body=#URLEncodedFormat(terse_errorContent)#" target="_blank">#error.mailTo#</a>
	        with the following information:</p>
	    <p>
		#_errorContent#
		<cfif (CommonCode.isServerLocal())>
			#verbose_errorContent#
		</cfif>
		
		<cfif (isSpecialTemplate)>
			<cfif (NOT _debugMode)>
				<cfmail to="#error.mailTo#" from="#error.mailTo#" subject="ColdFusion Error for CMS 1.0" replyto="#error.mailTo#" type="HTML">
					#_errorContent#
					#verbose_errorContent#
				</cfmail>
			</cfif>
		</cfif>
	
	</body>
	</html>
</cfoutput>
