<cfset _quickLinksEditorAction_symbol = "[&sect;]">

<cfinclude template="cfinclude_adminDefinitions.cfm">

<cfset _editor_title_ = "Click this link to open the Marquee Announcements Editor.">
<cfset _editor_title_id = "_id_marqueeEditorLink_">
<cfset _marqueeEditorLink = '<div id="id_marqueeEditorLink" style="background-color:white;"><font size="1"><a href="" #CommonCode.setup_tooltip_handlers(_editor_title_id)# title="#_editor_title_#" onclick="openMarqueeEditorAction(); return false;">#_editorAction_symbol#</a></font></div>'>

<cfset _editor_title_ = "Click this link to open the Images Upload Dialog."> <!---  #CommonCode.asciiChart()# --->
<cfset _editor_title_id = "_id_imagesUploaderLink_">
<cfset js_editor_title_id = "'#_editor_title_id#'">
<cfset _imagesUploaderLink = '<span id="id_imagesUploaderLink"><font size="1"><a href="" #CommonCode.setup_tooltip_handlers(_editor_title_id)# title="#_editor_title_#" onclick="openImagesUploaderAction(this.id, true); return false;">#_uploaderAction_symbol#</a></font></span>'>

<cfif 1> <!--- (CGI.REMOTE_HOST eq _debugIP) --->
	<cfset _marqueeDataFillerLink = '<div id="id_marqueeDataFillerLink"><font size="1"><a href="#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)#&submit=#URLEncodedFormat(function_marqueeDataFillerLink)##Request.next_splashscreen_inhibitor#">#function_marqueeDataFillerLink#</a></font></div>'>
</cfif>

<cfset _closeButton_symbol = "[x]">

<cfset _htmlEditorAboutAction_symbol = "#_editorAction_symbol#|#aboutPage_symbol#">
<cfset _htmlEditorFaqAction_symbol = "#_editorAction_symbol#|#faqPage_symbol#">
<cfset _htmlEditorExpressAction_symbol = "#_editorAction_symbol#|#expressProgramsProcPage_symbol#">
<cfset _htmlEditorHomeAction_symbol = "#_editorAction_symbol#|#homePage_symbol#">
<cfset _htmlEditorMethodAction_symbol = "#_editorAction_symbol#|#methodPage_symbol#">
<cfset _htmlEditorControlsAction_symbol = "#_editorAction_symbol#|#pmControlsPage_symbol#">
<cfset _htmlEditorHiringAction_symbol = "#_editorAction_symbol#|#pmHiringProcedurePage_symbol#">
<cfset _htmlEditorRolesAction_symbol = "#_editorAction_symbol#|#pmRoleDefinitionPage_symbol#">
<cfset _htmlEditorDevelopmentAction_symbol = "#_editorAction_symbol#|#professionalDevelopmentPage_symbol#">
<cfset _htmlEditorManagementAction_symbol = "#_editorAction_symbol#|#programMgtProcPage_symbol#">
<cfset _htmlEditorSapAction_symbol = "#_editorAction_symbol#|#sapxRPMPage_symbol#">
<cfset _htmlEditorCSSAction_symbol = "#_editorAction_symbol#|#siteCSSPage_symbol#">

<cfset _loadJSCode_js = "../components/_js/loadJSCode_.js">
<cfset _disable_right_click_script_III_js = "../components/_js/disable-right-click-script-III_.js">
<cfset _MathAndStringExtend_js = "../components/js/MathAndStringExtend.js">

<cfset _layout_css = "#siteCSS_base_fileName_symbol#">
<cfset _min_width_js = "../components/js/min_width.js">
<cfset _drop_down_js = "../components/js/drop_down.js">
<cfset _utility_js = "../components/js/utility.js">
<cfset _mytextsize_js = "../components/my-textsize.js/my-textsize.js">
<cfset _menu_editor_core_js = "../components/js/menu_editor_core.js">
<cfset _marquee_scroller_core_js = "../components/js/marquee_scroller_core.js">
<cfset _marquee_scroller_admin_js = "../components/js/marquee_scroller_admin.js">
<cfset _images_uploader_admin_js = "../components/js/images_uploader_admin.js">
<cfset _menu_editor_admin_js = "../components/js/menu_editor_admin.js">
<cfset _right_menu_core_js = "../components/js/right_menu_core.js">
<cfset _support_js = "../components/js/support.js">
<cfset _tabs_support_js = "../components/js/tabs_support.js">
<cfset _tabs_security_js = "../components/js/tabs_security.js">
<cfset _tabs_release_js = "../components/js/tabs_release.js">
<cfset _cookie_js = "../components/tabs.js/readable/cookie.js">
<cfset _htmlarea_path = "../components/htmlarea.js/">
<cfset _ColorPicker2_js = "../components/color-picker.js/ColorPicker2.js">

<cfset _calendar_css = "components/jscalendar-0.9.6/calendar-win2k-1.css">
<cfset _calendar_js = "../components/jscalendar-0.9.6/calendar.js">
<cfset _calendar_en_js = "../components/jscalendar-0.9.6/lang/calendar-en.js">
<cfset _calendar_setup_js = "../components/jscalendar-0.9.6/calendar-setup.js">

<cfset _index_header_cfm = "index_header.cfm">
<cfset _index_menu_cfm = "index_menu.cfm">
<cfset _index_rightmenu_cfm = "index_rightmenu.cfm">
<cfset _index_main_cfm = "index_main.cfm">
<cfset _index_layout_cfm = "index_layout.cfm">
<cfset _index_footer_cfm = "index_footer.cfm">
<cfset _index_quicklinks_cfm = "index_quicklinks.cfm">

<cfset _urlParms = "&pageName=&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfset _editor_prompt_symbol = const_newPage_editor_prompt_symbol>
<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for a new page of content.">
<cfset _newPage_editor = CommonCode.makeContentEditorLink("False", _adminMethod, _adminMethod_nopopups, "True", _editor_title_, _htmlEditorNewPageAction_symbol, _urlParms, _editor_prompt_symbol)>

<cfset _editor_prompt_symbol = const_menuEditor_prompt_symbol>
<cfset _editor_title_ = "Click this link to open the Menu Editor.">
<cfset _newMenu_editor = CommonCode.makeContentEditorLink("False", _adminMethod, _adminMethod_nopopups, "False", _editor_title_, _htmlMenuEditorAction_symbol, _urlParms, _editor_prompt_symbol)>

<cfset _urlParms = "&pageName=#URLEncodedFormat(_quickLinksPageName_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the QuickLinks.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_quickLinks_editor_", _editor_title_, "True", _quickLinksEditorAction_symbol, _urlParms, _quickLinksEditorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _quickLinksEditorAction_symbol, _urlParms, _quickLinksEditorAction_symbol)>
</cfif>
<cfset _quickLinks_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(aboutPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the About page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_aboutPage_editor_", _editor_title_, "True", _htmlEditorAboutAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorAboutAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _aboutPage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(faqPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Faq page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_faqPage_editor_", _editor_title_, "True", _htmlEditorFaqAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorFaqAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _faqPage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(expressProgramsProcPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Express page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_expressPage_editor_", _editor_title_, "True", _htmlEditorExpressAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorExpressAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _expressPage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(homePage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Home page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_homePage_editor_", _editor_title_, "True", _htmlEditorHomeAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorHomeAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _homePage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(siteCSSPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the CSS page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_cssPage_editor_", _editor_title_, "True", _htmlEditorCSSAction_symbol, _urlParms, _siteCSSEditorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorCSSAction_symbol, _urlParms, _siteCSSEditorAction_symbol)>
</cfif>
<cfset _siteCSSEditorLink = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(methodPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Methods page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_methodPage_editor_", _editor_title_, "True", _htmlEditorMethodAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorMethodAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _methodPage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(pmControlsPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Controls page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_controlsPage_editor_", _editor_title_, "True", _htmlEditorControlsAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorControlsAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _controlsPage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(pmHiringProcedurePage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Hiring page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_hiringPage_editor_", _editor_title_, "True", _htmlEditorHiringAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorHiringAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _hiringPage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(pmRoleDefinitionPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Roles page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_rolesPage_editor_", _editor_title_, "True", _htmlEditorRolesAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorRolesAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _rolesPage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(professionalDevelopmentPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Development page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_developmentPage_editor_", _editor_title_, "True", _htmlEditorDevelopmentAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorDevelopmentAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _developmentPage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(programMgtProcPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Management page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_managementPage_editor_", _editor_title_, "True", _htmlEditorManagementAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorManagementAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _managementPage_editor = '<font size="1">#_editor#</font>'>

<cfset _urlParms = "&pageName=#URLEncodedFormat(sapxRPMPage_symbol)#&currentPage=#URLEncodedFormat(currentPage)##_backUrl_parms#">
<cfif _adminMethod eq _adminMethod_nopopups>
	<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Sap page of content.">
	<cfset _editor = commonCode.makeHTMLEditorLink2( "_sapPage_editor_", _editor_title_, "True", _htmlEditorSapAction_symbol, _urlParms, _editorAction_symbol)>
<cfelse>
	<cfset _editor = commonCode.makePopupLink( _htmlEditorSapAction_symbol, _urlParms, _editorAction_symbol)>
</cfif>
<cfset _sapPage_editor = '<font size="1">#_editor#</font>'>

<cfset _menuBar_extraSpaces = 70>

<cfset _SQL_statement = "">

<cfif 0>
	<cfif (Len(_object) gt 0) AND (cancelPopUp eq _cancelButton_symbol) AND (Len(submit) gt 0)>
		<cfoutput>
			<script language="JavaScript1.2" type="text/javascript">
			<!--
				window.opener.location.href = '#CGI.SCRIPT_NAME#?currentPage=#URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#';
				window.close();
			-->
			</script>
		</cfoutput>
	</cfif>
</cfif>

<cfif _adminMethod eq _adminMethod_nopopups>
	<cfinclude template="../#_index_cfm_fileName#">
<cfelse>
	<cfif Len(function) eq 0>
		<cfinclude template="../#_index_cfm_fileName#">
	<cfelseif (Len(function) gt 0)>
		<cfinclude template="cfinclude_htmlSQL.cfm">
		
		<cfif (cancelPopUp eq _cancelButton_symbol) OR (Len(submit) gt 0)>
			<cfoutput>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					window.opener.location.href = '#CGI.SCRIPT_NAME#?currentPage=#URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#';
					window.close();
				-->
				</script>
			</cfoutput>
		</cfif>
	
		<cfoutput>
			<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
			<html>
			<head>
				#commonCode.metaTags("#Request._site_name##Request._title##Request._adminTitle#", Request.product_metaTags_args)#
				<link rel="stylesheet" href="../#siteCSS_base_fileName_symbol#">
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			</head>
			
			<cfset _bodyParms = "">
			<body #_bodyParms#>
	
			<cfinclude template="cfinclude_htmlEditor.cfm">
		</cfoutput>
	</cfif>
</cfif>

