<!------------------------------------------------------------
// This file is automatically included in all *.cfm files
// Enables application management, error control, and default
// document type.
//
------------------------------------------------------------->
<cfset _debugIP = "129.245.103.76">

<cfset product_version = "CMSv1">

<cfset Request.product_metaTags_args = 'author=#URLEncodedFormat("&copy;2005, Hierarchical Applications Limited - All Rights Reserved")#,keywords=,description=#URLEncodedFormat("Web Based Content Management System v1. No part of this product may be used, reproduced or distributed without the expressed conscent, in writing, of Hierarchical Applications Limited or a duly authorized agent of same.")#,robots=all,category=home page'>

<cfset product_dsn = "CMSv1_Config">
<cfset product_dsn_username = "cms_cf">
<cfset product_dsn_password = "cms">

<cfset Request.varname_splashscreen_inhibitor = "nosplash">
<cfset Request.varval_splashscreen_inhibitor = "1">
<cfset Request.splashscreen_inhibitor = Request.varname_splashscreen_inhibitor & "=" & Request.varval_splashscreen_inhibitor>
<cfset Request.first_splashscreen_inhibitor = "?" & Request.splashscreen_inhibitor>
<cfset Request.next_splashscreen_inhibitor = "&" & Request.splashscreen_inhibitor>

<cfif (CGI.REMOTE_HOST eq _debugIP)>
	<cfsetting showdebugoutput="Yes">
</cfif>

<cfset bool_missing_draft_condition = "False">

<!--System application.cfm-->
<cfinclude template="/Application.cfm">
<!--- Define the application parameters --->

<cfscript>
	if (NOT IsDefined("commonCode")) {
		err_commonCode = false;
		try {
			commonCode = CreateObject("component","components.commonCode");
			Request.commonCode = commonCode;
		} catch(Any e) {
			err_commonCode = true;
		}
	}

	if (NOT IsDefined("SQL2000")) {
		err_SQL2000code = false;
		try {
			SQL2000 = CreateObject("component","components.SQL2000");
			Request.SQL2000 = SQL2000;
		} catch(Any e) {
			err_SQL2000code = true;
		}
	}
</cfscript>

<!--- BEGIN: Handle the scenario of when the user issue a URL that states ?site= --->
<cfset _deferred_site_reset = "False">
<cfif IsDefined("site")>
	<cfif Len(Trim(site)) eq 0>
		<cfset _deferred_site_reset = "True">
	</cfif>
</cfif>
<!--- END! Handle the scenario of when the user issue a URL that states ?site= --->

<cfparam name="site" type="string" default="">

<cfscript>
	const_cfapplication_name_default_symbol = "[Demo Mode]";

	if (FindNoCase(LCase('\go\'), LCase(CGI.PATH_TRANSLATED)) gt 0) {
		_cfapplication_name = "GO";
	} else if (FindNoCase(LCase('\epo\'), LCase(CGI.PATH_TRANSLATED)) gt 0) {
		_cfapplication_name = "EPO";
	} else if (FindNoCase(LCase('\projectsport\'), LCase(CGI.PATH_TRANSLATED)) gt 0) {
		_cfapplication_name = "ProjectSPORT";
	} else {
		_cfapplication_name = const_cfapplication_name_default_symbol;
	}
</cfscript>

<cfscript>
	if (CommonCode.isServerLocal()) {
		variables.thisServerType = 'dev-test';
//		_cfapplication_name = "GO";
	}
</cfscript>

<cfapplication name="#_cfapplication_name#"
               clientmanagement="Yes"
			   CLIENTSTORAGE="clientvars"
               sessionmanagement="Yes"
			   setclientcookies="Yes"
			   setdomaincookies="Yes"
               sessiontimeout="#CreateTimeSpan(0,0,30,0)#"
               applicationtimeout="#CreateTimeSpan(1,0,0,0)#">

<cfset Request._domainName = "">
<cfset Request._splashScreen_bgColor = "##0080FF">
<cfif (FindNoCase(' SBC; ', CGI.HTTP_USER_AGENT) gt 0)>
	<cfset Request._domainName = "-sbc">
	<cfset Request._splashScreen_bgColor = "##3c6da5">
<cfelseif (NOT Request.commonCode.isDomainSBC())>
	<cfset Request._domainName = "">
</cfif>
<cfset splashScreen_html = "splashScreen#Request._domainName#.html">
<cfset Request._splashScreen_url = Request.commonCode.fullyQualifiedURLprefix(Request.commonCode.scriptPrefix(CGI.SCRIPT_NAME)) & splashScreen_html>
<cfparam name="nosplash" type="string" default="">

<cfparam name="Client._site_" type="string" default="">
<cfparam name="Client._splashScreen_" type="string" default="">

<cfscript>
	if (_deferred_site_reset) {
		Client._site_ = '';
		_deferred_site_reset = false;
	} else {
		if (Len(Trim(site)) eq 0) {
		} else {
			Client._site_ = site;
		}
	}
</cfscript>

<!----------------------------------------------------------->
<cfset _mailto = "raychorn@hotmail.com">
<cfif (CommonCode.isServerLocal())>
	<cfset _mailto = _mailto>
</cfif>

<cfinclude template="/errhandler.cfm">

<!--- BEGIN: This code block is required by ICHKOWSKY, MELISSA G (SBCSI) --->
<CFERROR TYPE="Exception" template="SiteErrorHandler.cfm" mailto="#_mailto#">
<CFERROR TYPE="Request" template="SiteErrorHandler.cfm" mailto="#_mailto#">
<CFERROR TYPE="Validation" template="SiteErrorHandler.cfm" mailto="#_mailto#">
<!--- END! This code block is required by ICHKOWSKY, MELISSA G (SBCSI) --->
<!------------------------------------------------------------->

<!--- MX migration code --->
<cfscript>
	_dbo = "dbo.";

	if (IsDefined("Client._site_")) {
		if (Len(Trim(Client._site_)) gt 0) {
			_dbo = "dbo." & Client._site_ & '_';
		}
	}

	_DynamicHTMLContent = _dbo & "DynamicHTMLContent";
	_ReleaseManagement = _dbo & "ReleaseManagement";
	_ReleaseManagementComments = _dbo & "ReleaseManagementComments";
	_ReleaseActivityLog = _dbo & "ReleaseActivityLog";
	_DynamicPageManagement = _dbo & "DynamicPageManagement";
	_DynamicHTMLpad = _dbo & "DynamicHTMLpad";
	_DynamicHTMLmenu = _dbo & "DynamicHTMLmenu";
	_UserSecurity = _dbo & "UserSecurity";
	_ContentList = _dbo & "ContentList";
	_ContentSecurity = _dbo & "ContentSecurity";
	_SubsystemList = _dbo & "SubsystemList";
	_SubsystemSecurity = _dbo & "SubsystemSecurity";
	_DynamicHTMLsepg_section = _dbo & "DynamicHTMLsepg_section";
	_DynamicHTMLsepg_links = _dbo & "DynamicHTMLsepg_links";
	_DynamicHTMLright_side = _dbo & "DynamicHTMLright_side";
	_DynamicHTMLfooter = _dbo & "DynamicHTMLfooter";
	_MenuEditorAccess = _dbo & "MenuEditorAccess";
	_MarqueeScrollerData = _dbo & "MarqueeScrollerData";
	_DynamicLayoutSpecification = _dbo & "DynamicLayoutSpecification";
	_LayoutManagement = _dbo & "LayoutManagement";

//	The following line of code is needed whenever the developer working on the development server wish to use the 
//	staging server's database (eg. those tables that are being used for staging).

	if (FindNoCase(LCase('\go\'), LCase(CGI.PATH_TRANSLATED)) gt 0) {
		Request._site_name = "SBC GO";
		DSNUser = "go_cf";
		DSNPassword = "go";

		switch(variables.thisServerType) {
			case "dev": {
				DSNSource = "sqldevsl5";
			 	break;
			}
			case "stage": {
				DSNSource = "sqldevsl5";
			 	break;
			}
			case "prod": {
				DSNSource = "SQLPRODSL4";
			 	break;
			}
		}
	} else if (FindNoCase(LCase('\epo\'), LCase(CGI.PATH_TRANSLATED)) gt 0) {
		Request._site_name = "SBC EPO";
		DSNUser = "epo_cf";
		DSNPassword = "epo";

		switch(variables.thisServerType) {
			case "dev": {
				DSNSource = "sqldevsl5";
			 	break;
			}
			case "stage": {
				DSNSource = "sqldevsl5";
			 	break;
			}
			case "prod": {
				DSNSource = "SQLPRODSL4";
			 	break;
			}
		}
	} else if (FindNoCase(LCase('\projectsport\'), LCase(CGI.PATH_TRANSLATED)) gt 0) {
		Request._site_name = "SBC SPORT";
		DSNUser = "projectsport_cf";
		DSNPassword = "projectsport";

		switch(variables.thisServerType) {
			case "dev": {
				DSNSource = "sqldevsl5";
			 	break;
			}
			case "stage": {
				DSNSource = "sqldevsl5";
			 	break;
			}
			case "prod": {
				DSNSource = "SQLPRODSL4";
			 	break;
			}
		}
	} else {
		Request._site_name = "SBC PM Professionalism";
		DSNUser = "pmprofessionalism_cf";
		DSNPassword = "pmprofessionalism";

		switch(variables.thisServerType) {
			case "dev": {
				DSNSource = "sqldevsl5";
				
				_dbo = "[ITSERVICES\ps6473].";
				_DynamicHTMLContent = _dbo & "DynamicHTMLContent2";
				_ReleaseManagement = _dbo & "ReleaseManagement2";
				_ReleaseManagementComments = _dbo & "ReleaseManagementComments2";
				_ReleaseActivityLog = _dbo & "ReleaseActivityLog2";
				_DynamicPageManagement = _dbo & "DynamicPageManagement2";
				_DynamicHTMLpad = _dbo & "DynamicHTMLpad2";
				_DynamicHTMLmenu = _dbo & "DynamicHTMLmenu2";
				_UserSecurity = _dbo & "UserSecurity2";
				_ContentList = _dbo & "ContentList2";
				_ContentSecurity = _dbo & "ContentSecurity2";
				_SubsystemList = _dbo & "SubsystemList2";
				_SubsystemSecurity = _dbo & "SubsystemSecurity2";
				_DynamicHTMLsepg_section = _dbo & "DynamicHTMLsepg_section2";
				_DynamicHTMLsepg_links = _dbo & "DynamicHTMLsepg_links2";
				_DynamicHTMLright_side = _dbo & "DynamicHTMLright_side2";
				_DynamicHTMLfooter = _dbo & "DynamicHTMLfooter2";
				_MenuEditorAccess = _dbo & "MenuEditorAccess2";
				_MarqueeScrollerData = _dbo & "MarqueeScrollerData2";
				_DynamicLayoutSpecification = _dbo & "DynamicLayoutSpecification2";
				_LayoutManagement = _dbo & "LayoutManagement2";
			 	break;
			}
			case "dev-ppml": {
				DSNSource = "cms_ppml";
				DSNUser = "ppml_cf";
				DSNPassword = "ppml";
			 	break;
			}
			case "dev-go": {
				DSNSource = "sqldevsl5";
				DSNUser = "go_cf";
				DSNPassword = "go";
			 	break;
			}
			case "dev-test": {
				Request._site_name = _cfapplication_name;
				DSNSource = "test-cms1";
				DSNUser = "test_cf";
				DSNPassword = "test";
			 	break;
			}
			case "go-staging": {
				DSNSource = "GO-staging";
				DSNUser = "go_cf";
				DSNPassword = "go";
			 	break;
			}
			case "stage": {
				DSNSource = "sqldevsl5";
			 	break;
			}
			case "prod": {
				DSNSource = "SQLPRODSL4";
			 	break;
			}
		}
	}
	
	if (IsDefined("Client._site_")) {
		if (Len(Trim(Client._site_)) gt 0) {
			Request._site_name = Request._site_name & '/' & Client._site_;
		}
	}
	// writeOutput('variables.thisServerType = [#variables.thisServerType#], [#_SubsystemList#]<br>');
</cfscript>

<cfif 0>
	<!---if it is sunday--->
	<cfif DayOfWeek(Now()) eq 1 >
	<!---and the hour is between 9am and 10am, display an application
		unavailable message due to database server maitenance--->
		<cfset currentHour = Hour(Now())>
		<cfif (currentHour GTE 9) AND (currentHour LT 11)>
			<cfoutput>
				<html>
					<head>
					<meta http-equiv="expires" content="-1">
					<meta http-equiv="pragma" content="no-cache">
				</head>
				<body>
					This application is unavailable between 9am and 10am #CommonCode.serverTimeZone(Now())# on Sundays
				</body>
				</html>
			</cfoutput>
			<cfabort>
		</cfif>
	</cfif>
</cfif>

<cfset AdminPassword = ''>

<CFSET #HomePage# = "http://#CGI.SERVER_NAME#/#CGI.SCRIPT_NAME#">
<CFIF #FindNoCase('MSIE','#HTTP_USER_AGENT#',1)# IS 0>
	<CFSET #ClientBrowser# = "Netscape">
<CFELSE>
	<CFSET #ClientBrowser# = "Explorer">
</CFIF>

<cfset CR = CHR(13)>
<cfset TAB = CHR(9)>
<cfset SOFTTAB = "#RepeatString('&nbsp;', 8)#&sect;">
<cfset LF = CHR(10)>
<cfset SQLCR = ";#CR##LF#">

<cfset AsciiBullet = "*">

<cfset _expressProcessURL = "">

<cfset _index_cfm_fileName = "index.cfm">

<cfset _css_default_font_family = "font-family: Verdana, Arial, Helvetica, sans-serif;">
<cfset _css_default_font_size = "font-size: xx-small;">

<cfset _disabled_color = "##808080">
<cfset _enabled_color = "##0000FF">
<cfset _disabled_color2 = _disabled_color>

<cfset _error_color = "##FF9F9F">

<cfset const_Default_Layout_name_symbol = "Default Layout">

<cfparam name="_htmlMenuEditorAction_symbol" default="" type="string">

<cfset _layout_using_tables = "True">

<cfset Request._title = "">

<cfset _site_menu_background_color = "##3081e4">
<cfset _site_menu_floats = "left">
<cfif 1>
	<cfset _site_menu_orientation = "left: 161px">
<cfelse>
	<cfset _site_menu_orientation = "right: 161px">
</cfif>

<cfset _site_menu_text_color = "white">

<cfset _forceMenuUnlockAction_symbol = "[Menu-Unlock]">

<cfset menuColorPage_symbol = "[menuColor]">
<cfset menuTextColorPage_symbol = "[menuTextColor]">

<cfset siteCSS_fileName_symbol = "site-">
<cfset siteCSS_base_fileName_symbol = "layout.css">
<cfset siteCSSPage_symbol = "[site-css]">
<cfset _siteCSSEditorAction_symbol = "[CSS]">

<cfparam name="_submit_" type="string" default="">

<cfset function_siteSearch_symbol = "[Site Search]">
<cfset function_performSearch_symbol = "[Perform Search]">
<cfset function_cancelButton_symbol = "[Cancel]">

<cfset homePage_symbol = "homePage">
<cfset aboutPage_symbol = "aboutPage">
<cfset faqPage_symbol = "faqPage">
<cfset methodPage_symbol = "methodPage">
<cfset programMgtProcPage_symbol = "programMgtProcPage">
<cfset expressProgramsProcPage_symbol = "expressProgramsProcPage">
<cfset pmRoleDefinitionPage_symbol = "pmRoleDefinitionPage">
<cfset professionalDevelopmentPage_symbol = "professionalDevelopmentPage">
<cfset pmHiringProcedurePage_symbol = "pmHiringProcedurePage">
<cfset pmControlsPage_symbol = "pmControlsPage">
<cfset sapxRPMPage_symbol = "sapxRPMPage">
<cfset underConstructionPage_symbol = "underConstructionPage">

<cfparam name="_adminMode" default="0" type="string">
<cfparam name="_ReleaseMode" default="0" type="string">
<cfparam name="_SecurityMode" default="0" type="string">
<cfparam name="_LayoutMode" default="0" type="string">
<cfparam name="_SQL2000Mode" default="0" type="string">

<cfparam name="_adminModeBackgroundImage" default="" type="string">

<cfparam name="function" default="" type="string">
<cfparam name="submit" default="" type="string">

<cfparam name="submitButton" default="" type="string">

<cfparam name="_id" default="" type="string">
<cfparam name="pageName" default="" type="string">

<cfparam name="_rid" default="-1" type="string">
<cfparam name="_relNum" default="-1" type="string">

<cfparam name="prevPage" default="" type="string">
<cfparam name="nextPage" default="" type="string">
<cfparam name="cancelPopUp" default="" type="string">

<cfparam name="currentPage" default="#homePage_symbol#" type="string">
<cfparam name="_pageContent" default="" type="string">
<cfparam name="_pageTitle" default="" type="string">

<cfparam name="_marqueeEditorLink" default="" type="string">
<cfparam name="_imagesUploaderLink" default="" type="string">
<cfparam name="_siteCSSEditorLink" default="" type="string">

<cfset _uploadImageAction_symbol = "[Upload Image]">

<cfparam name="_fileName" default="" type="string">

<cfparam name="s_msg" default="" type="string">

<cfset function_marqueeDataFillerLink = "[x--x]">

<cfset _textarea_style_ = "font-size: 11px;">
<cfset _textarea_style_symbol = 'style="#_textarea_style_#"'>

<cfset _text_style_symbol = 'style="font-size: 10px;"'>

<cfparam name="_quickLinks_editor" default="" type="string">
<cfparam name="_aboutPage_editor" default="" type="string">
<cfparam name="_faqPage_editor" default="" type="string">
<cfparam name="_expressPage_editor" default="" type="string">
<cfparam name="_homePage_editor" default="" type="string">
<cfparam name="_methodPage_editor" default="" type="string">
<cfparam name="_controlsPage_editor" default="" type="string">
<cfparam name="_hiringPage_editor" default="" type="string">
<cfparam name="_rolesPage_editor" default="" type="string">
<cfparam name="_developmentPage_editor" default="" type="string">
<cfparam name="_managementPage_editor" default="" type="string">
<cfparam name="_sapPage_editor" default="" type="string">

<cfparam name="_newPage_editor" default="" type="string">

<cfparam name="_notLinkables" default="''" type="string">

<cfparam name="_layout_spec_graphic" default="" type="string">

<cfparam name="_redir" default="" type="string">

<cfparam name="_num_tabs_max" default="-1" type="string">

<cfset Request.const_TABLE_NAME_symbol = "TABLE_NAME">
<cfset Request.const_TABLE_OWNER_symbol = "TABLE_OWNER">
<cfset Request.const_TABLE_OWNER_DBO_symbol = "dbo">

<cfset Request.special_tables_list = "DynamicHTMLright_side,DynamicHTMLsepg_links,DynamicHTMLsepg_section">

<cfset _baseMenuContents = URLDecode("http%3A%2F%2Fpanagonsl02%2Esbc%2Ecom%2FServices%2Fredir%2Easp%3FNewLocation%3Ddoccontent%2Easp%3Fdocid%3D004100957%7C%5Fblank%7CPROMISE%20PDP%2E%2E%2E%2C%23%7C%20%7CPROMISE%20Sub%2DPrograms%2E%2E%2E%2C%23%7C%20%7CProgram%20Management%2E%2E%2E%2C%2Fpmprofessionalism%2Fadmin%2Findex%2Ecfm%3FcurrentPage%3DprogramMgtProcPage%7C%20%7CProgram%20Management%20Procedure%2C%2Fpmprofessionalism%2Fadmin%2Findex%2Ecfm%3FcurrentPage%3DexpressProgramsProcPage%7C%20%7C%5BEXPRESS%20Process%20for%20Programs%5D%2C%23%2D1%7C%20%7C%20%2C%2Fpmprofessionalism%2Fadmin%2Findex%2Ecfm%3FcurrentPage%3DmethodPage%7C%20%7CPM%20Methodology%2C%2Fpmprofessionalism%2Fadmin%2Findex%2Ecfm%3FcurrentPage%3DpmRoleDefinitionPage%7C%20%7CPM%20Role%20Definition%2C%2Fpmprofessionalism%2Fadmin%2Findex%2Ecfm%3FcurrentPage%3DprofessionalDevelopmentPage%7C%20%7CProfessional%20Development%2C%2Fpmprofessionalism%2Fadmin%2Findex%2Ecfm%3FcurrentPage%3DpmHiringProcedurePage%7C%20%7CPM%20Hiring%20Procedure%2C%2Fpmprofessionalism%2Fadmin%2Findex%2Ecfm%3FcurrentPage%3DpmControlsPage%7C%20%7CPM%20Controls%2C%23%2D1%7C%20%7C%20%2Chttp%3A%2F%2Fpanagonsl02%2Esbc%2Ecom%2FIDMWSGuest2%2Fdoccontent%2Edll%3FLibrary%3DLIBSYS1%5EPANAGONSL03%26ID%3D004086704%7C%5Fblank%7CPROMISE%20Schedule%2C%23%7C%20%7CPM%20Industry%20Links%2E%2E%2E%2Chttp%3A%2F%2Fwww%2Epmi%2Eorg%2Finfo%2Fdefault%2Easp%7C%5Fblank%7CPMI%20Website%2Chttp%3A%2F%2Fwww%2Esei%2Ecmu%2Eedu%2F%7C%5Fblank%7CSEI%20Website%2C%23%2D1%7C%20%7C%20%2C%2Fpmprofessionalism%2Fadmin%2Findex%2Ecfm%3FcurrentPage%3DsapxRPMPage%7C%20%7CSAP%20xRPM%2Chttp%3A%2F%2Fpanagonsl02%2Esbc%2Ecom%2FIDMWSGuest2%2Fdoccontent%2Edll%3FLibrary%3DLIBSYS1%5EPANAGONSL03%26ID%3D004076690%7C%5Fblank%7CContact%20List%2Chttp%3A%2F%2Fpanagonsl02%2Esbc%2Ecom%2FIDMWSGuest2%2Fdoccontent%2Edll%3FLibrary%3DLIBSYS1%5EPANAGONSL03%26ID%3D004153954%7C%5Fblank%7CTeam%20Structure")>

<cfif (_cfapplication_name eq const_cfapplication_name_default_symbol)>
	<!--- BEGIN: This list MUST be a single item or else evil things will happen --->
	<cfset _listOfRequiredQuickLinksPages = "quickLinks">
	<!--- END! This list MUST be a single item or else evil things will happen --->

	<cfset _listOfRequiredMenuPagePages = "menuPage">
	<cfset _listOfRequiredSepg_sectionPages = "sepg_section">
	<cfset _listOfRequiredSepg_linksPages = "sepg_links">
	<cfset _listOfRequiredRight_sidePages = "right_side">
	<cfset _listOfRequiredFooterPages = "footer">
	<cfset _listOfRequiredSiteCssPages = siteCSSPage_symbol>
	<cfset _listOfRequiredSpecialPages = "#_listOfRequiredQuickLinksPages#,#_listOfRequiredMenuPagePages#,#_listOfRequiredSepg_sectionPages#,#_listOfRequiredSepg_linksPages#,#_listOfRequiredRight_sidePages#,#_listOfRequiredFooterPages#,#_listOfRequiredSiteCssPages#">
	<cfset _listOfRequiredSpecialPages2 = "aboutPage,faqPage,homePage,#_listOfRequiredQuickLinksPages#,#_listOfRequiredMenuPagePages#,#_listOfRequiredSepg_sectionPages#,#_listOfRequiredSepg_linksPages#,#_listOfRequiredRight_sidePages#,#_listOfRequiredFooterPages#,#_listOfRequiredSiteCssPages#">
	<cfset _listOfRequiredPages = "aboutPage,expressProgramsProcPage,faqPage,homePage,methodPage,pmControlsPage,pmHiringProcedurePage,pmRoleDefinitionPage,professionalDevelopmentPage,programMgtProcPage,sapxRPMPage,#_listOfRequiredSpecialPages#">
<cfelse>
	<!--- BEGIN: This list MUST be a single item or else evil things will happen --->
	<cfset _listOfRequiredQuickLinksPages = "">
	<!--- END! This list MUST be a single item or else evil things will happen --->

	<cfset _listOfRequiredMenuPagePages = "menuPage">
	<cfset _listOfRequiredSepg_sectionPages = "sepg_section">
	<cfset _listOfRequiredSepg_linksPages = "sepg_links">
	<cfset _listOfRequiredRight_sidePages = "right_side">
	<cfset _listOfRequiredFooterPages = "footer">
	<cfset _listOfRequiredSiteCssPages = siteCSSPage_symbol>
	<cfset _listOfRequiredSpecialPages = "#_listOfRequiredQuickLinksPages#,#_listOfRequiredMenuPagePages#,#_listOfRequiredSepg_sectionPages#,#_listOfRequiredSepg_linksPages#,#_listOfRequiredRight_sidePages#,#_listOfRequiredFooterPages#,#_listOfRequiredSiteCssPages#">
	<cfset _listOfRequiredSpecialPages2 = "aboutPage,faqPage,homePage,#_listOfRequiredQuickLinksPages#,#_listOfRequiredMenuPagePages#,#_listOfRequiredSepg_sectionPages#,#_listOfRequiredSepg_linksPages#,#_listOfRequiredRight_sidePages#,#_listOfRequiredFooterPages#,#_listOfRequiredSiteCssPages#">
	<cfset _listOfRequiredPages = "homePage,#_listOfRequiredSpecialPages#">
</cfif>

<cfset _menuEditorAction_symbol = "[MenuEditor]">
<cfset _menuTableEditorAction_symbol = "[MenuTableEditor]">

<cfset _editorMenuAddAction_symbol = "[+]">
<cfset _editorMenuDropAction_symbol = "[-]">
<cfset _editorMenuEditAction_symbol = "[*]">
<cfset _editorMenuAddSubMenuAction_symbol = "[++]">
<cfset _editorMenuAddSubMenuContainerAction_symbol = "[@]">
<cfset _editorMenuAddCloseSubMenuAction_symbol = "[+)]">
<cfset _editorMenuEditSubMenuAction_symbol = "[*+]">
<cfset _editorMenuEditSubMenuContainerAction_symbol = "[**]">

<cfset _images_folder = "images/">

<cfset const_scroller_open_state = "_open">
<cfset const_scroller_close_state = "_close">

<cfset _reorganizeMenuUpAction_symbol = "[up]">
<cfset _reorganizeSubMenuUpAction_symbol = "[+up]">
<cfset _reorganizeMenuUpImage_symbol = "#_images_folder#arrow36-up-small.gif">
<cfset _reorganizeMenuDnAction_symbol = "[dn]">
<cfset _reorganizeSubMenuDnAction_symbol = "[+dn]">
<cfset _reorganizeMenuDnImage_symbol = "#_images_folder#arrow36-dn-small.gif">

<cfset _img_tag_preamble_symbol = "<img ">
<cfset _img_tag_postamble_symbol = ">">
<cfset _img_tag_src_symbol = "src">

<cfset _anchor_tag_preamble_symbol = "<a ">
<cfset _anchor_tag_postamble_symbol = "</a>">
<cfset _anchor_tag_href_symbol = "href">

<cfset _menuSubMenuURL_symbol = "##">
<cfset _menuSubMenuEndsURL_symbol = "##-1">

<cfset _adminURLPrefix_symbol = "/admin/">
<cfset _layoutURLPrefix_symbol = "/layout/">

<cfparam name="_object" default="" type="string">
<cfparam name="_itemIndex" default="-1" type="string">
<cfparam name="_itemIndexMax" default="-1" type="string">
<cfparam name="_containers" default="" type="string">

<!--- BEGIN: This variable cannot be an empty string by default --->
<cfparam name="_linkage" default="." type="string">
<!--- END! This variable cannot be an empty string by default --->

<cfparam name="_url" default="" type="string">
<cfparam name="_target" default="" type="string">
<cfparam name="_prompt" default="" type="string">

<cfparam name="_allowNewPages" default="False" type="string">
<cfparam name="_existingPageNameList" default="" type="string">

<cfset _currentPage_symbol = "?currentPage=">

<cfset swapSidesEditorAction_symbol = "[SwapSides]">

<cfset _backUrl_parms = "&backUrl=#URLEncodedFormat(CGI.SCRIPT_NAME & Request.first_splashscreen_inhibitor)#">

<cfset _baseline_pages_not_linkable = "'aboutPage', 'faqPage', 'homePage', 'footer', 'menuPage', 'quickLinks', 'right_side', 'sepg_links', 'sepg_section'">

<cfset const_newPage_editor_prompt_symbol = "#SOFTTAB#Add New Page...">
<cfset const_menuEditor_prompt_symbol = "#SOFTTAB#Edit Menu...">

<cfset is_htmlArea_editor = "False">

<cfset is_locked_menuEditor = "False">
<cfset uid_locked_menuEditor = "">
<cfset emailLink_locked_menuEditor = "">
<cfset emailLink_locked_timeString = "">

<cfset _cancelButton_symbol = "[Cancel]">

<cfset _nextPageButton_symbol = ">>">
<cfset _prevPageButton_symbol = "<<">

<cfset _warningHeader_symbol = "WARNING:">

<!--- BEGIN: DO NOT CHANGE UNLESS YOU ALSO CHANGE THE commonCode.cfc file to match. --->
<cfset _development_status_symbol = "D">
<cfset _production_status_symbol = "P">
<cfset _archive_status_symbol = "A">
<cfset _staging_status_symbol = "S">
<!--- END! DO NOT CHANGE UNLESS YOU ALSO CHANGE THE commonCode.cfc file to match. --->

<!--- BEGIN: DO NOT move or change these lines of code or the security data model will most-likely fail. --->
<cfset const_TempAdmin_symbol = "TempAdmin">
<cfset _Admin_Add_New_Pages_symbol = "Admin-Add-New-Pages">
<cfset _Admin_Edit_Marquee_symbol = "Admin-Edit-Marquee">
<cfset _Admin_Upload_Images_symbol = "Admin-Upload-Images">
<cfset _quickLinksPageName_symbol = "quickLinks">
<cfset _menuPageName_symbol = "menuPage">
<cfset _AdminSubSysName_symbol = "Admin">
<cfset _images_prime_symbol = "images">
<cfset _images_uploaded_symbol = "uploaded-images">
<cfset _sepg_section_pageName_symbol = "sepg_section">
<cfset _sepg_links_pageName_symbol = "sepg_links">
<cfset _right_side_pageName_symbol = "right_side">
<cfset _footer_pageName_symbol = "footer">
<!--- END! DO NOT move or change these lines of code or the security data model will most-likely fail. --->

<!--- BEGIN: DO NOT move or change these lines of code or the security data model will most-likely fail. --->
<cfset _layoutModePathSuffix = "layout/">
<cfset _layoutModePath = "/#_layoutModePathSuffix#">

<cfset _releaseModePathSuffix = "release/">
<cfset _releaseModePath = "/#_releaseModePathSuffix#">

<cfset _adminModePathSuffix = "admin/">
<cfset _adminModePath = "/#_adminModePathSuffix#">

<cfset _securityModePathSuffix = "security/">
<cfset _securityModePath = "/#_securityModePathSuffix#">

<cfset _SQL2000ModePathSuffix = "SQL2000/">
<cfset _SQL2000ModePath = "/#_SQL2000ModePathSuffix#">

<cfset Request._subsystem_list_ = _AdminSubSysName_symbol & ",Layout,Release,SQL2000">
<cfset Request.subsystem_list_ = _Admin_Add_New_Pages_symbol & "," & _Admin_Edit_Marquee_symbol & Request._subsystem_list_>
<cfset Request._subsystem_list_ = Request._subsystem_list_ & ",Security">
<!--- END! DO NOT move or change these lines of code or the security data model will most-likely fail. --->

<!--- BEGIN: Determine the subsystem --->
<cfset _subsysNameOffset = 1>
<cfif (CommonCode.isStagingView())>
	<cfset _subsysNameOffset = 2>
</cfif>
<cfset _subsysName = GetToken(CGI.SCRIPT_NAME, (ListLen(CGI.SCRIPT_NAME, "/") - _subsysNameOffset), "/")>
<cfset Request._subsysName = _subsysName>

<cfset Request.referer_is_subsysName_valid = "False">
<cfloop index="_item" list="#Request._subsystem_list_#" delimiters=",">
	<cfset Request.referer_is_subsysName_valid = (FindNoCase("/" & _item & "/", CGI.HTTP_REFERER) gt 0)>
	<cfif (Request.referer_is_subsysName_valid)>
		<cfbreak>
	</cfif>
</cfloop>

<cfset Request._prefixName = CommonCode.getURLprefixBasedOn("http://" & CGI.SERVER_NAME & CGI.SCRIPT_NAME, _subsysName)>

<cfset base_siteName = Replace(Replace(Request._prefixName, CGI.SERVER_NAME, ""), "http://", "")>
<cfset Request.base_siteName = base_siteName>
<!--- END! Determine the subsystem --->

<cfset Request.cont_subsysNames = 'admin,release,security,layout,sql2000'>

<cfif (FindNoCase(_subsysName, _releaseModePath) gt 0)>
	<cfset _ReleaseMode = 1>
<cfelseif (FindNoCase(_subsysName, _adminModePath) gt 0)>
	<cfset _adminMode = 1>
<cfelseif (FindNoCase(_subsysName, _securityModePath) gt 0)>
	<cfset _SecurityMode = 1>
<cfelseif (FindNoCase(_subsysName, _layoutModePath) gt 0)>
	<cfset _LayoutMode = 1>
<cfelseif (FindNoCase(_subsysName, _SQL2000ModePath) gt 0)>
	<cfset _SQL2000Mode = 1>
<cfelse>
	<cfset Request._subsysName = "">  <!--- No valid subsystem name was found so flag this as a non-subsystem --->
</cfif>

<!--- BEGIN: This block of code is needed because there is some hidden syntax error that causes the menu editor's clipboard to not appear --->
<cfif (_AdminMode eq 1) AND 1>
	<cfset _layout_using_tables = "False">
</cfif>
<!--- END! This block of code is needed because there is some hidden syntax error that causes the menu editor's clipboard to not appear --->

<!--- BEGIN: Determine the subsystem --->
<cfset _prodName = _subsysName>
<cfif (_ReleaseMode eq 1) OR (_adminMode eq 1) OR (_SecurityMode eq 1) OR (_LayoutMode eq 1)>
	<cfset _prodNameOffset = _subsysNameOffset + 1>
	<cfset _prodName = GetToken(CGI.SCRIPT_NAME, (ListLen(CGI.SCRIPT_NAME, "/") - _prodNameOffset), "/")>
</cfif>
<!--- END! Determine the subsystem --->

<!--- BEGIN: When in Staging view none of the subsystems will function because this is an alternate "live" site view --->
<cfif (CommonCode.isStagingView())>
	<cfset _ReleaseMode = 0>
	<cfset _adminMode = 0>
	<cfset _SecurityMode = 0>
	<cfset _LayoutMode = 0>
</cfif>
<!--- END! When in Staging view none of the subsystems will function because this is an alternate "live" site view --->

<cfset _theURLPrefix_symbol = "/#Replace(_subsysName, "/", "", "all")#/">

<!--- Allow this variable to be defined in the parent application.cfm file if necessary in order to bypass LDAP completely --->
<cfparam name="_AUTH_USER" type="string" default="#CGI.AUTH_USER#">

<!--- END! this block of code redirects the user to the static site backup in case of a database malfunction or whenever there is no Production Release in the database... --->

<!--- BEGIN: this block of code determines the amount of space allocated to SQL Server's Data Files... --->
<cfset Request._maxDbSize_mb_ = 100>
<cfset _actualSize_percent = CommonCode.sqlVerifyDbSpace(DSNUser, DSNPassword, DSNSource, Request._maxDbSize_mb_)>
<!--- END! this block of code determines the amount of space allocated to SQL Server's Data Files... --->

<cfscript>
	err_VerifyUserSecurity = false;
	try {
		VerifyUserSecurity = CommonCode.sqlVerifyUserSecurity(_AUTH_USER, _subsysName, DSNUser, DSNPassword, DSNSource, _UserSecurity, _SubsystemList, _SubsystemSecurity);
	} catch(Database e) {
		err_VerifyUserSecurity = true;
	}
</cfscript>

<cfinclude template="cfinclude_VerifyUserSecurity2.cfm">

<cfif (_SQL2000Mode eq 0)>
	<cfif (NOT CommonCode.is_htmlArea_editor())>
		<cfset _aSQL = CommonCode.sql_getCurrentRelease_rid( (_adminMode OR _LayoutMode), _ReleaseManagement)>
		<cfset _SQL_statement = "#_aSQL#
			DECLARE @menuColorPgId as int;
			SELECT @menuColorPgId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#menuColorPage_symbol#') AND (rid = @prid));
		
			SELECT TOP 1 html as menuBgColor FROM #_DynamicHTMLpad# WHERE (pageId = @menuColorPgId) AND (rid = @prid);
		">
		
		<cfif Len(_SQL_statement) gt 0>
			<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetMenuColor" datasource="#DSNSource#">
				#PreserveSingleQuotes(_SQL_statement)#
			</cfquery>
			<cfset _SQL_statement = "">
		</cfif>
		
		<cfset _SQL_statement = "#_aSQL#
			DECLARE @menuColorPgId as int;
			SELECT @menuColorPgId = (SELECT TOP 1 pageId FROM #_DynamicPageManagement# WHERE (pageName = '#menuTextColorPage_symbol#') AND (rid = @prid));
		
			SELECT TOP 1 html as menuTextColor FROM #_DynamicHTMLpad# WHERE (pageId = @menuColorPgId) AND (rid = @prid);
		">
		
		<cfif Len(_SQL_statement) gt 0>
			<CFQUERY username='#DSNUser#' password='#DSNPassword#' name="GetMenuTextColor" datasource="#DSNSource#">
				#PreserveSingleQuotes(_SQL_statement)#
			</cfquery>
			<cfset _SQL_statement = "">
		</cfif>
	</cfif>
</cfif>

<cfset cgi_SCRIPT_NAME = CGI.SCRIPT_NAME>
<cfif (IsDefined("backUrl"))>
	<cfset cgi_SCRIPT_NAME = backUrl>
</cfif>
