<cfif 0>
	<cfsetting enablecfoutputonly="No" showdebugoutput="No">
</cfif>

<cfparam name="bypassDebuggingWindow" default="" type="string">

<cfparam name="_loadJSCode_js" default="components/_js/loadJSCode_.js" type="string">
<cfparam name="_disable_right_click_script_III_js" default="components/_js/disable-right-click-script-III_.js" type="string">
<cfparam name="_MathAndStringExtend_js" default="components/js/MathAndStringExtend.js" type="string">

<cfparam name="_layout_css" default="#siteCSS_base_fileName_symbol#" type="string">
<cfparam name="_min_width_js" default="components/js/min_width.js" type="string">
<cfparam name="_drop_down_js" default="components/js/drop_down.js" type="string">
<cfparam name="_dom_browser_js" default="components/dom-browser.js/dom-browser.js" type="string">
<cfparam name="_utility_js" default="components/js/utility.js" type="string">
<cfparam name="_mytextsize_js" default="components/my-textsize.js/my-textsize.js" type="string">
<cfparam name="_menu_editor_core_js" default="components/js/menu_editor_core.js" type="string">
<cfparam name="_menu_editor_admin_js" default="components/js/menu_editor_admin.js" type="string">
<cfparam name="_layout_editor_core_js" default="components/js/layout_editor_core.js" type="string">
<cfparam name="_layout_core_js" default="components/js/layout_core.js" type="string">
<cfparam name="_marquee_scroller_admin_js" default="components/js/marquee_scroller_admin.js" type="string">
<cfparam name="_images_uploader_admin_js" default="components/js/images_uploader_admin.js" type="string">
<cfparam name="_marquee_scroller_core_js" default="components/js/marquee_scroller_core.js" type="string">
<cfparam name="_right_menu_core_js" default="components/js/right_menu_core.js" type="string">
<cfparam name="_SBCUIDPicker_js" default="components/js/SBCUIDPicker.js" type="string">
<cfparam name="_support_js" default="components/js/support.js" type="string">
<cfparam name="_tabs_support_js" default="components/js/tabs_support.js" type="string">
<cfparam name="_tabs_security_js" default="components/js/tabs_security.js" type="string">
<cfparam name="_tabs_release_js" default="components/js/tabs_release.js" type="string">
<cfparam name="_tabs_layout_js" default="components/js/tabs_layout.js" type="string">
<cfparam name="_tabs_sql2000_js" default="components/js/tabs_sql2000.js" type="string">
<cfparam name="_ColorPicker2_js" default="components/color-picker.js/ColorPicker2.js" type="string">
<cfparam name="_cookie_js" default="components/tabs.js/readable/cookie.js" type="string">

<cfparam name="_calendar_css" default="components/jscalendar-0.9.6/calendar-win2k-1.css" type="string">
<cfparam name="_calendar_js" default="components/jscalendar-0.9.6/calendar.js" type="string">
<cfparam name="_calendar_en_js" default="components/jscalendar-0.9.6/lang/calendar-en.js" type="string">
<cfparam name="_calendar_setup_js" default="components/jscalendar-0.9.6/calendar-setup.js" type="string">

<cfparam name="_htmlarea_path" default="components/htmlarea.js/" type="string">
<cfparam name="_AnchorPosition_js" default="components/color-picker.js/AnchorPosition.js" type="string">
<cfparam name="_PopupWindow_js" default="components/color-picker.js/PopupWindow.js" type="string">
<cfparam name="_index_header_cfm" default="index_header.cfm" type="string">
<cfparam name="_index_menu_cfm" default="index_menu.cfm" type="string">
<cfparam name="_index_rightmenu_cfm" default="index_rightmenu.cfm" type="string">
<cfparam name="_index_main_cfm" default="index_main.cfm" type="string">
<cfparam name="_index_footer_cfm" default="index_footer.cfm" type="string">
<cfparam name="_index_layout_cfm" default="index_layout.cfm" type="string">
<cfparam name="_index_quicklinks_cfm" default="index_quicklinks.cfm" type="string">
<cfparam name="Request._adminTitle" default="" type="string">
<cfparam name="_images_folder" default="images/" type="string">
<cfparam name="_quickLinks_editor" default="" type="string">
<cfparam name="_aboutPage_editor" default="" type="string">
<cfparam name="_menuBar_extraSpaces" default="90" type="string">
<cfparam name="_faqPage_editor" default="" type="string">

<!--- BEGIN: Only used for /Release and /Security subsystems --->
<cfset _tabs_js_path = "../components/tabs.js/">
<!--- END! Only used for /Release and /Security subsystems --->

<!--- BEGIN: Only used for /Layout subsystem --->
<cfset _drag_n_drop_js_path = "../components/drag-n-drop.js/">
<!--- END! Only used for /Layout subsystem --->

<cfset _adminLink = "Admin/">

<cfset contactUs_url = "mailto:#_mailto#?subject=CMSv1: Contact Us">

<cfset _externalURLs_target = "target=_blank">

<cfset _SQL_statement = "">

<cfset bool_splashScreen_shown = "False">

<cfscript>
	// BEGIN: Always force the user to enter via the splash screen to ensure the system is being entered correctly via a Modal Dialog...
	Request._splashScreen_url = ReplaceNoCase(Request._splashScreen_url, '/' & Request._subsysName & '/', '/');
	if ( (Len(Request._subsysName) gt 0) AND (nosplash neq 1) AND (NOT Request.referer_is_subsysName_valid) ) {
//		Request.commonCode.cf_location(Request._splashScreen_url);
		writeOutput(CommonCode.docHeaderBegin() & CommonCode.docHeaderEnd());
		writeOutput('<body bgcolor="#Request._splashScreen_bgColor#">');
		Request.commonCode.iframe(Request._splashScreen_url);
		bool_splashScreen_shown = true;
	} else if (nosplash eq 1) {
		Client._splashScreen_ = Now();
	}

	// BEGIN: This code is not being used atm because the splash screen is always being used as an entry point...
	if (0) {
		_dt = -1;
		if ( (IsDate(Client.LastVisit)) AND (IsDate(Client._splashScreen_)) ) {
			_dt = DateDiff('n', Client.LastVisit, Client._splashScreen_);
		}
		if ( (_dt lt 0) OR (_dt gt 20) ) {
//			Request.commonCode.cf_location(Request._splashScreen_url);
			writeOutput(CommonCode.docHeaderBegin() & CommonCode.docHeaderEnd());
			writeOutput('<body bgcolor="#Request._splashScreen_bgColor#">');
			Request.commonCode.iframe(Request._splashScreen_url);
			bool_splashScreen_shown = true;
		}
	}
	// END! This code is not being used atm because the splash screen is always being used as an entry point...
	// END! Always force the user to enter via the splash screen to ensure the system is being entered correctly via a Modal Dialog...
</cfscript>

<cfif (NOT bool_splashScreen_shown)>
	<cfinclude template="#_index_layout_cfm#">
	
	<!--- BEGIN: Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->
	<cfif (IsDefined("_submit_")) AND (Len(Trim(submit)) eq 0)>
		<cfset submit = _submit_>
	</cfif>
	<!--- END! Bridge the gap between the double-click suppressor and the orginal design that didn't care about double-clicks --->
	
	<cfif (cancelPopUp eq _cancelButton_symbol)>
		<cfset function = "">
		<cfset submit = "">
	</cfif>
	
	<cfparam name="_onloadMethod" type="string" default="">
	
	<cfif (_adminMode eq 1) AND (ListLen(currentPage, "|") eq 4) AND (UCASE(GetToken(currentPage, 1, "|")) eq UCASE(_editorAction_symbol)) AND (UCASE(GetToken(currentPage, 2, "|")) eq UCASE(const_Marquee_symbol))>
		<cfset m_curpage = GetToken(currentPage, 4, "|")>
		<cfset currentPage = GetToken(currentPage, 3, "|")>
		<cfif 0>
			<cfset _onloadMethod = '#_onloadMethod# onload="_openMarqueeEditorAction(#m_curpage#);"'>
		<cfelse>
			<cfoutput>
				#CommonCode.register_onload_function("_openMarqueeEditorAction(#m_curpage#);")#
			</cfoutput>
		</cfif>
	</cfif>
	
	<cfif (_SQL2000Mode eq 0)>
		<cfif (_ReleaseMode eq 0) AND (_SecurityMode eq 0)>
			<cfif (Len(function) eq 0) AND (Len(submit) eq 0)>
				<cfinclude template="cfinclude_GetCurrentContent.cfm">
			<cfelseif (_adminMode eq 1) AND (_submit_ neq function_performSearch_symbol)>
				<cfinclude template="#_adminModePathSuffix#cfinclude_htmlSQL.cfm">
		
				<cfif (Len(submit) gt 0) AND 0>
					<cfif (submit eq _saveMarqueeButton_symbol) OR (submit eq _removeMarqueeButton_symbol)>
						<cfset currentPage = "#_editMarquee_symbol#|#currentPage#">
						<cfif (IsDefined("m_curpage"))>
							<cfset currentPage = "#currentPage#|#m_curpage#">
						</cfif>
					</cfif>
					<cfoutput>
						<script language="JavaScript1.2" type="text/javascript">
						<!--
							window.location.href = '#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#';
						-->
						</script>
					</cfoutput>
				</cfif>
			</cfif>
		<cfelseif (_ReleaseMode eq 1)>
			<cfinclude template="#_releaseModePathSuffix#cfinclude_releaseSQL.cfm">
		<cfelseif (_SecurityMode eq 1)>
			<cfinclude template="#_securityModePathSuffix#cfinclude_securitySQL.cfm">
		</cfif>
	</cfif>
	
	<cfif (_ReleaseMode eq 0) AND (_SecurityMode eq 0) AND (_LayoutMode eq 0) AND (_SQL2000Mode eq 0)>
		<!--- BEGIN: Process the Site Search function and any others specified for all modes that display content --->
		<cfinclude template="cfinclude_htmlSQL.cfm">
		<!--- END! Process the Site Search function and any others specified for all modes that display content --->
	</cfif>
	
	<cfif (_LayoutMode eq 1)>
		<cfset _SQL_statement = CommonCode.sql_getCurrentRelease_rid( (_adminMode OR _LayoutMode), _ReleaseManagement)>
		<cfinclude template="#_layoutModePathSuffix#cfinclude_layoutSQL.cfm">
	</cfif>
	
	<cfinclude template="cfinclude_pageTitle.cfm">
	
	<cfif (CommonCode.isServerLocal())>
		<cfset Request._title = Request._title & " [#CGI.HTTP_REFERER#]">
	</cfif>
	
	<cfoutput>#CommonCode.docHeaderBegin()#</cfoutput>
	
		<cfinclude template="cfinclude_myTextSize_css.cfm">

		<cfoutput>
			<script language="JScript.Encode" src="#_loadJSCode_js#"></script>
	
			<cfif (NOT CommonCode.isServerLocal())>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					loadJSCode("#_disable_right_click_script_III_js#");
				// --> 
				</script>
			</cfif>

			<script language="JavaScript1.2" type="text/javascript">
			<!--
				loadJSCode("#_MathAndStringExtend_js#");
			// --> 
			</script>
	
			<!--- BEGIN: General purpose JavaScript routines... --->
			<cfif (_AdminMode eq 1) OR (_ReleaseMode eq 1) OR (_SecurityMode eq 1) OR (_LayoutMode eq 1) OR (_SQL2000Mode eq 1)>
				<script language="JavaScript1.2" src="#_mytextsize_js#" type="text/javascript"></script>
			</cfif>
			<script language="JavaScript1.2" src="#_utility_js#" type="text/javascript"></script>
			<cfif (CommonCode.isServerLocal()) AND 0>
				<!--- BEGIN: JavaScript code in support of debugging... --->
				<script language="JavaScript1.2" src="#_dom_browser_js#" type="text/javascript"></script>
				<!--- END! JavaScript code in support of debugging... --->
			</cfif>
			<!--- END! General purpose JavaScript routines... --->
	
			<cfif (_SecurityMode eq 0) AND (_ReleaseMode eq 0) AND (_LayoutMode eq 0) AND (_SQL2000Mode eq 0)>
				<script language="JavaScript1.2" src="#_marquee_scroller_core_js#" type="text/javascript"></script>
			</cfif>
		</cfoutput>
		
		<cfif (_releaseMode eq 1) OR (_SecurityMode eq 1) OR (_LayoutMode eq 1) OR (_SQL2000Mode eq 1)>
			<cfoutput>
				<script language="JavaScript1.2" src="#_tabs_support_js#" type="text/javascript"></script>
			</cfoutput>
		</cfif>
	
		<cfif (_SecurityMode eq 0) AND (_ReleaseMode eq 0) AND (_LayoutMode eq 0) AND (_SQL2000Mode eq 0) AND ( (NOT IsDefined("_htmlMenuCommitAction_symbol")) OR (submit neq _htmlMenuCommitAction_symbol) )>
			<cfoutput>
				<script language="JavaScript1.2" src="#_min_width_js#" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_drop_down_js#" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_cookie_js#" type="text/javascript"></script>
			</cfoutput>
		</cfif>
	
		<cfif (_SecurityMode eq 1)>
			<cfoutput>
				<SCRIPT LANGUAGE="JavaScript1.2" SRC="#_ColorPicker2_js#" type="text/javascript"></SCRIPT>
				<script language="JavaScript1.2" src="#_SBCUIDPicker_js#" type="text/javascript"></script>
			</cfoutput>
	
			<cfset _yOffset = 116>
			<cfif (IsDefined("GetSecurityDataUsersSubsystems.rid")) AND (Len(GetSecurityDataUsersSubsystems.rid) gt 0) AND (Len(GetSecurityDataUsersSubsystems.lockedSBCUID) gt 0) AND (UCASE(GetSecurityDataUsersSubsystems.lockedSBCUID) NEQ UCASE(_AUTH_USER))>
				<cfset _yOffset = 150>
			</cfif>
			<cfset _onloadMethod = 'windowLoaded()'>
			<cfoutput>
				#CommonCode.register_onload_function("#_onloadMethod#;")#
				#CommonCode.tabsHeader(_onloadMethod, _tabs_js_path, "", "#_yOffset#px", "20px", "830", "0px", 1, _num_tabs_max)#
			</cfoutput>
		<cfelseif (_SQL2000Mode eq 1)>
			<cfset _yOffset = 70>
			<cfset _onloadMethod = 'windowLoaded()'>
	
			<cfoutput>
				#CommonCode.register_onload_function("#_onloadMethod#;")#
				#CommonCode.tabsHeader(_onloadMethod, _tabs_js_path, "", "#_yOffset#px", "20px", "830", "0px", 1, _num_tabs_max)#
			</cfoutput>
		<cfelseif (_releaseMode eq 1)>
			<script language="JavaScript1.2" type="text/javascript">
				<!--
					_stack_LogHeightControls = [];
					_array_numRows = [];
					_maxVisibleRows = -1;
					_cache_gui_objects_trio = [];
				-->
			</script>
			<cfset _onloadMethod = 'windowLoaded()'>
			<cfoutput>
				#CommonCode.register_onload_function("#_onloadMethod#;")#
				#CommonCode.tabsHeader(_onloadMethod, _tabs_js_path, "30px", "120px", "0px", "800", "0px", 1, _num_tabs_max)#
			</cfoutput>
		<cfelseif (_AdminMode eq 1)>
			<style type="text/css"><!--
			  .headline { font-family: arial black, arial; font-size: 28px; letter-spacing: -1px; }
			  .headline2{ font-family: verdana, arial; font-size: 12px; }
			  .subhead  { font-family: arial, arial; font-size: 18px; font-weight: bold; font-style: italic; }
			  .backtotop     { font-family: arial, arial; font-size: xx-small;  }
			  .code     { background-color: #EEEEEE; font-family: Courier New; font-size: x-small;
			              margin: 5px 0px 5px 0px; padding: 5px;
			              border: black 1px dotted;
			            }
			--></style>
	
			<cfset calendar_font_size = "11px">
			<STYLE TYPE="TEXT/CSS"><!--
				<cfinclude template="#_calendar_css#">
			//--></STYLE>
	
			<script language="Javascript1.2"><!-- // load htmlarea
			_editor_url = "../components/htmlarea.js/";                     // URL to htmlarea files
			var win_ie_ver = parseFloat(navigator.appVersion.split("MSIE")[1]);
			if (navigator.userAgent.indexOf('Mac')        >= 0) { win_ie_ver = 0; }
			if (navigator.userAgent.indexOf('Windows CE') >= 0) { win_ie_ver = 0; }
			if (navigator.userAgent.indexOf('Opera')      >= 0) { win_ie_ver = 0; }
			if (win_ie_ver >= 5.5) {
			  document.write('<scr' + 'ipt src="' +_editor_url+ 'editor.js"');
			  document.write(' language="Javascript1.2"></scr' + 'ipt>');  
			} else { document.write('<scr'+'ipt>function editor_generate() { return false; }</scr'+'ipt>'); }
			// --></script>
	
			<cfoutput>
				<script language="JavaScript1.2" src="#_calendar_js#" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_calendar_en_js#" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_calendar_setup_js#" type="text/javascript"></script>
	
				<script language="JavaScript1.2" type="text/javascript">
					<!--
					const_closeButton_symbol = '#_closeButton_symbol#';
					const_cancelButton_symbol = '#_cancelButton_symbol#';
					const_saveMarqueeButton_symbol = '#_saveMarqueeButton_symbol#';
					const_removeMarqueeButton_symbol = '#_removeMarqueeButton_symbol#';
					
					const_begin_symbol = 'BeginDate';
					const_end_symbol = 'EndDate';
					
					const_disabled_symbol = 'disabled';
					const_Container_symbol = 'Container';
					const_Content_symbol = 'Content';
					const_bgColor = '##FFFFBB';
					const_display_style = 'display';
					const_save_button_symbol = 'save';
					
					const_marqueeBrowser_panel_symbol = 'marqueeBrowser_panel';
					
					const_empty_table_cell = '<TD></TD>';
	
					_last_opened_WYSIWYG_for_stack = [];
					date_widget_validation_stack = [];
					date_widget_style_stack = [];
					widget_action_stack = [];
					button_widget_style_stack = [];
					widget_registration_stack = []; // array of array objects
					
					current_visible_page_of_headlines = 1;
					max_visible_page_of_headlines = -1;
					
					widget_value_stack = [];
					
					register_onload_function('initColdFusion2JavaScript();');
	
					var bgColor = getCookie("ColorPicker");
					if (bgColor != null) {
						register_onload_function('modifyMenuColors("' + bgColor + '");');
					}
					var bgColor2 = getCookie("ColorPicker2");
					if (bgColor2 != null) {
						register_onload_function('modifyMenuTextColors("' + bgColor2 + '");');
					}
					-->
				</script>
				<script language="JavaScript1.2" src="#_menu_editor_admin_js#" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_marquee_scroller_admin_js#" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_images_uploader_admin_js#" type="text/javascript"></script>
				<SCRIPT LANGUAGE="JavaScript1.2" SRC="#_ColorPicker2_js#" type="text/javascript"></SCRIPT>
			</cfoutput>
		<cfelseif (_LayoutMode eq 1) AND 0>  <!--- this code was for the table-driven layout editor, not being used as of 01-20-2005 --->
			<cfif 0>
				<cfset _onloadMethod = 'onload="initLayoutEditor()"'>
			<cfelse>
				<cfoutput>
					#CommonCode.register_onload_function("initLayoutEditor();")#
				</cfoutput>
			</cfif>
	
			<script language="JavaScript1.2" src="#_layout_editor_core_js#" type="text/javascript"></script>
		<cfelseif (_LayoutMode eq 1) AND 0>
			<cfif 0>
				<cfset _onloadMethod = 'onload="windowLoaded()"'>
			<cfelse>
				<cfoutput>
					#CommonCode.register_onload_function("windowLoaded();")#
				</cfoutput>
			</cfif>
			<style type="text/css" media="screen">
				
			.scrollbar-track {
				position: relative;
			 	height: 1px;
				border: 1px inset #444;
				background: scrollbar;
				z-index: 10;
			}
	
			.scrollbar-track-active {
				border-color: #333;
				background: #ccc;;
			}
			
			.scrollbar-handle {
				position: absolute;
			}
			
			</style>
			<cfoutput>
				<script language="JavaScript1.2" src="#_drag_n_drop_js_path#listener.js" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_drag_n_drop_js_path#drag.js" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_drag_n_drop_js_path#slider.js" type="text/javascript"></script>
			</cfoutput>
			<script language="JavaScript1.2" src="#_layout_core_js#" type="text/javascript"></script>
		<cfelseif (_LayoutMode eq 1)>
			<cfset _yOffset = 110>
	
			<cfset _onloadMethod = 'windowLoaded()'>
			<cfoutput>
				#CommonCode.register_onload_function("#_onloadMethod#;")#
				#CommonCode.tabsHeader(_onloadMethod, _tabs_js_path, "", "#_yOffset#px", "20px", "830", "0px", 1, _num_tabs_max)#
			</cfoutput>
		<cfelse>
		</cfif>
	
		<cfoutput>
			<SCRIPT LANGUAGE="JavaScript1.2" SRC="#_PopupWindow_js#"></SCRIPT>
			<SCRIPT LANGUAGE="JavaScript1.2" SRC="#_AnchorPosition_js#"></SCRIPT>
			<cfif (_SecurityMode eq 0) AND (_ReleaseMode eq 0) AND (_LayoutMode eq 0) AND (_SQL2000Mode eq 0)>
				<script language="JavaScript1.2" type="text/javascript">
					<!--
					var const_subMenu_symbol = '#_menuSubMenuURL_symbol#';
					var const_subMenuEnds_symbol = '#_menuSubMenuEndsURL_symbol#';
					-->
				</script>
				<SCRIPT LANGUAGE="JavaScript1.2" SRC="#_menu_editor_core_js#"></SCRIPT>
			</cfif>
		</cfoutput>
		
	<!--- BEGIN: Force the table layout when NOT in the Menu Editor --->
	<cfif (function eq _htmlMenuEditorAction_symbol) AND (IsDefined("GetEditableContent")) AND (GetEditableContent.recordCount gt 0) AND (GetEditableContent.uid eq VerifyUserSecurity2.uid)>
		<cfset _layout_using_tables = "False">
	<cfelse>
		<cfset _layout_using_tables = "True">
	</cfif>
	<!--- END! Force the table layout when NOT in the Menu Editor --->
	
	<cfif (IsDefined("GetMenuColor")) AND (GetMenuColor.recordCount gt 0) AND (IsDefined("GetMenuColor.menuBgColor")) AND (Len(Trim(GetMenuColor.menuBgColor)) gt 0)>
		<cfset _site_menu_background_color = GetMenuColor.menuBgColor>
	</cfif>
	
	<cfif (IsDefined("GetMenuTextColor")) AND (GetMenuTextColor.recordCount gt 0) AND (IsDefined("GetMenuTextColor.menuTextColor")) AND (Len(Trim(GetMenuTextColor.menuTextColor)) gt 0)>
		<cfset _site_menu_text_color = GetMenuTextColor.menuTextColor>
	</cfif>
	
	<STYLE TYPE="TEXT/CSS"><!--
		<cfset _site_layout_css = ReplaceNoCase(_layout_css, siteCSS_base_fileName_symbol, "#siteCSS_fileName_symbol##siteCSS_base_fileName_symbol#")>
		<cfinclude template="#_site_layout_css#">
		<cfinclude template="#_layout_css#">
	//--></STYLE>
	
		<cfoutput>#CommonCode.docHeaderEnd()#</cfoutput>
	
	<cfif (NOT IsDefined("GetCurrentContent")) AND (_ReleaseMode eq 0) AND (_SecurityMode eq 0) AND (_sql2000Mode eq 0) AND (Len(Trim(function)) eq 0) AND (Len(Trim(submit)) eq 0)>
		<cfset bool_missing_draft_condition = "True">
		<cfset _adminModeBackgroundImage = 'background="#_images_folder#no-draft-transparent-background.gif"'>
		<cfif (_LayoutMode eq 1)>
			<cfset _adminModeBackgroundImage = 'background="#_images_folder#no-draft-layout-transparent-background.gif"'>
		</cfif>
	</cfif>
	
	<cfif (_SecurityMode eq 1)>
		<cfif (NOT IsDefined("GetSecurityDataUsersSubsystems.rid")) OR (Len(GetSecurityDataUsersSubsystems.rid) eq 0)>
			<cfset bool_missing_draft_condition = "True">
			<cfset _adminModeBackgroundImage = 'background="#_images_folder#no-draft-security-transparent-background.gif"'>
		</cfif>
	</cfif>
	
	<cfif (CommonCode.isStagingView())>
		<cfset _adminModeBackgroundImage = 'background="#_images_folder#staging-transparent-background.gif"'>
		<cfif (NOT IsDefined("GetCurrentContent"))>
			<cflocation url="../#_index_cfm_fileName#" addtoken="No">
		</cfif>
	</cfif>
	
	<cfinclude template="cfinclude_autoCorrectLinksAndImages.cfm">
	
	<cfset _onloadMethod = 'onload="handle_onload_functions();"'>

	<cfoutput>
	<body #_adminModeBackgroundImage# #_onloadMethod#>
	</cfoutput>
	
	<cfif (CommonCode.isServerLocal()) AND 0>
		<!--- BEGIN: JavaScript code in support of debugging... --->
		<center>
		<form>
		<input type=button value="Open DOM Browser" onClick="openDOMBrowser('_document');">
		</form>
		</center>
		<!--- END! JavaScript code in support of debugging... --->
	</cfif>
	
	<div id="_delayed_tooltips" style="display: none; position: absolute; z-index: 32767;"></div>
	
	<cfif (_AdminMode eq 1)>
		<cfoutput>
			#CommonCode.imagesUploaderDialog(_textarea_style_symbol, _uploadImageAction_symbol, _cancelButton_symbol)#
		</cfoutput>
	</cfif>
	
	<cfset pl = "">
	<cfset _notLinkables = "">
	<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (IsDefined("GetCurrentContent.menu")) AND (IsDefined("GetCurrentContent.pageList"))>
		<!--- BEGIN: Determine which pages are being linked to in the current Menu, then exclude those from the query --->
		<cfset _notLinkables = CommonCode.getUnlinkables( GetCurrentContent.menu, _baseline_pages_not_linkable, _menuSubMenuURL_symbol, _menuSubMenuEndsURL_symbol, _currentPage_symbol)>
		<!--- END! Determine which pages are being linked to in the current Menu, then exclude those from the query --->
		<cfoutput>
		<input type="hidden" id="_GetCurrentContent_notLinkables" value="#_notLinkables#">
		</cfoutput>
	
		<!--- BEGIN: Filter out those page names that are already linked within the raw menu content... --->
		<cfset _nl = Replace(_notLinkables, "'", "", "all")>
		<cfset pl = GetCurrentContent.pageList>
		<cfloop index="_item" list="#_nl#" delimiters=",">
			<cfset _i = ListFindNoCase(pl, Trim(_item), ",")>
			<cfif (_i gt 0)>
				<cfset pl = ListDeleteAt(pl, _i, ",")>
			</cfif>
		</cfloop>
		<!--- END! Filter out those page names that are already linked within the raw menu content... --->
	
		<cfoutput>
		<input type="hidden" id="_GetCurrentContent_pageList" value="#pl#">
		</cfoutput>
	</cfif>
	
	<cfoutput>
		<script language="JavaScript1.2" src="#_support_js#" type="text/javascript"></script>
	
		<cfinclude template="cfinclude_ColdFusionJavaScript_globals.cfm">
		
		<cfif (_AdminMode eq 1)>
			<!--- BEGIN: ColdFusion variables are preloaded with values to be passed into JavaScript --->
			<cfset _const_clipboard_paste_before_title = "Paste Clipboard item to Menu Before selected item in Menu.">
			<cfset _const_clipboard_paste_before_caption = CommonCode.osStyleRadioButtonCaption( "True", _const_clipboard_paste_before_title, "clipboard_paste_before", '<font id="clipboard_paste_before_font" size="1"><small><b>Before</b></small></font>')>
	
			<cfset _const_clipboard_paste_after_title = "Paste Clipboard item to Menu After selected item in Menu.">
			<cfset _const_clipboard_paste_after_caption = CommonCode.osStyleRadioButtonCaption( "True", _const_clipboard_paste_after_title, "clipboard_paste_after", '<font id="clipboard_paste_after_font" size="1"><small><b>After</b></small></font>')>
	
			<cfset _const_menu_item_editor_internal_title = "Internal Links are those that remain within the boundaries of this website.">
			<cfset _const_menu_item_editor_internal_caption = CommonCode.osStyleRadioButtonCaption2( "True", _const_menu_item_editor_internal_title, "_menu_item_editor_internal", "positional_delayed_tooltips4", '<font id="_menu_item_editor_internal_font" size="1"><small><b>Internal Link</b></small></font>', "processMenuEditorCheckLinkType();")>
	
			<cfset _const_menu_item_editor_external_title = "External Links are those that do not remain within the boundaries of this website and may reference the Internet, Intranet or Extranet.">
			<cfset _const_menu_item_editor_external_caption = CommonCode.osStyleRadioButtonCaption2( "True", _const_menu_item_editor_external_title, "_menu_item_editor_external", "positional_delayed_tooltips4", '<font id="_menu_item_editor_external_font" size="1"><small><b>External Link</b></small></font>', "processMenuEditorCheckLinkType();")>
			<!--- END! ColdFusion variables are preloaded with values to be passed into JavaScript --->
	
			<!--- BEGIN: HTML variables are preloaded with values to be passed into JavaScript from ColdFusion --->
			<cfoutput>
			<input type="hidden" id="_const_clipboard_paste_before_tooltips" value="#URLEncodedFormat(CommonCode.setup_tooltip_handlers('clipboard_paste_before'))#">
			<input type="hidden" id="_const_clipboard_paste_before_title" value="#URLEncodedFormat(_const_clipboard_paste_before_title)#">
			<input type="hidden" id="_const_clipboard_paste_before_caption" value="#URLEncodedFormat(_const_clipboard_paste_before_caption)#">
	
			<input type="hidden" id="_const_clipboard_paste_after_tooltips" value="#URLEncodedFormat(CommonCode.setup_tooltip_handlers('clipboard_paste_after'))#">
			<input type="hidden" id="_const_clipboard_paste_after_title" value="#URLEncodedFormat(_const_clipboard_paste_after_title)#">
			<input type="hidden" id="_const_clipboard_paste_after_caption" value="#URLEncodedFormat(_const_clipboard_paste_after_caption)#">
	
			<input type="hidden" id="_const_menu_item_editor_internal_tooltips" value="#URLEncodedFormat(CommonCode.setup_tooltip_handlers2('_menu_item_editor_internal', 'positional_delayed_tooltips4'))#">
			<input type="hidden" id="_const_menu_item_editor_internal_title" value="#URLEncodedFormat(_const_menu_item_editor_internal_title)#">
			<input type="hidden" id="_const_menu_item_editor_internal_caption" value="#URLEncodedFormat(_const_menu_item_editor_internal_caption)#">
	
			<input type="hidden" id="_const_menu_item_editor_external_tooltips" value="#URLEncodedFormat(CommonCode.setup_tooltip_handlers2('_menu_item_editor_external', 'positional_delayed_tooltips4'))#">
			<input type="hidden" id="_const_menu_item_editor_external_title" value="#URLEncodedFormat(_const_menu_item_editor_external_title)#">
			<input type="hidden" id="_const_menu_item_editor_external_caption" value="#URLEncodedFormat(_const_menu_item_editor_external_caption)#">
			</cfoutput>
			<!--- END! HTML variables are preloaded with values to be passed into JavaScript from ColdFusion --->
		</cfif>
		
		<cfif (_ReleaseMode eq 0) AND (_SecurityMode eq 0) AND (_LayoutMode eq 0) AND (_SQL2000Mode eq 0)>
			<!--- BEGIN: These globals are defined from ColdFusion variables... --->
			<script language="JavaScript1.2" type="text/javascript">
				<!--
				var _LayoutMode = #_LayoutMode#;
		
				var _GetCurrentContent_pageList = "#pl#";
				var _GetCurrentContent_notLinkables = "#_notLinkables#";
		
				// Specify the links.
				// Format: "URL,description,target,imageurl".
				var right_side_image_links = [];
	//			right_side_image_links.push(new LinkObj("#_expressProcessURL#", "Express Process!!!", "_blank", "#_images_folder#ExpressProcess1.gif"));
	//			right_side_image_links.push(new LinkObj("#_expressProcessURL#", "Express Process!!!", "_blank", "#_images_folder#ExpressProcess2.gif"));
	//			right_side_image_links.push(new LinkObj("#_expressProcessURL#", "Express Process!!!", "_blank", "#_images_folder#ExpressProcess3.gif"));
	//			right_side_image_links.push(new LinkObj("#_expressProcessURL#", "Express Process!!!", "_blank", "#_images_folder#ExpressProcess4.gif"));
	//			right_side_image_links.push(new LinkObj("#_expressProcessURL#", "Express Process!!!", "_blank", "#_images_folder#ExpressProcess5.gif"));
	//			right_side_image_links.push(new LinkObj("#_expressProcessURL#", "Express Process!!!", "_blank", "#_images_folder#ExpressProcess6.gif"));
				-->
			</script>
			<!--- END! These globals are defined from ColdFusion variables... --->
		</cfif>
	</cfoutput>
	
	<cfoutput>
		<cfset styles_container = "">
		<cfif (_adminMode eq 1) OR (_ReleaseMode eq 1) OR (_SecurityMode eq 1) OR (_LayoutMode eq 1) OR (_SQL2000Mode eq 1)>
			<cfset height_div_nav_bar = "25">
			<div id="div_nav_bar" style="display: block; position: absolute; top: 0px; left: 0px;">
				<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
					<tr>
						<td>
							<table align="center" width="100%" height="#height_div_nav_bar#px" bgcolor="##B3D9FF" cellpadding="-1" cellspacing="-1" style="font-size: 10px;">
								<tr>
									<td>
										<cfscript>
											function list_select_item(_anItem, _item_method, _num_done) {
												var _site_is_selected = '';
												if (UCASE(Client._site_) eq UCASE(_anItem)) {
													_site_is_selected = 'selected';
												}
												writeOutput('<option #_site_is_selected# value="#Request.commonCode.makeProperURLPrefix(Request.base_siteName & Request._subsysName)#?site=#_anItem#">#_anItem#</option>');
											}
	
											SQL2000WizardQueryTables0 = SQL2000.enumerateDbTables(commonCode, DSNUser, DSNPassword, DSNSource);
											q_verifyRequiredTables = SQL2000.verifyRequiredTables(SQL2000WizardQueryTables0, SQL2000.requiredTablesList());
	
											_site_chooser_is_disabled = '';
											_site_chooser_title = '';
											if ( (IsQuery(q_verifyRequiredTables)) AND (IsDefined("q_verifyRequiredTables.sub_sites")) ) {
												if (Len(q_verifyRequiredTables.sub_sites) eq 0) {
													_site_chooser_is_disabled = 'disabled';
													_site_chooser_title = 'The Site Chooser is currently offline due to the lack of sub-sites from which to choose.  The Site Chooser will be back online as soon as there are sub-sites to choose.';
												}
											}
	
											writeOutput('<select id="subsites_select" name="subsites_select" #_site_chooser_is_disabled# title="#_site_chooser_title#" style="font-size: 9px;" onChange="changePage(this)">');
											writeOutput('<option value="##" SELECTED>Site Chooser...</option>');
											_site_is_selected = '';
											if (Client._site_ eq '') {
												_site_is_selected = 'selected';
											}
											writeOutput('<option #_site_is_selected# value="#Request.commonCode.makeProperURLPrefix(Request.base_siteName & Request._subsysName)#?site=">Primary</option>');
											if ( (IsQuery(q_verifyRequiredTables)) AND (IsDefined("q_verifyRequiredTables.sub_sites")) ) {
												commonCode.list_iterator(q_verifyRequiredTables.sub_sites, ',', list_select_item, -1);
											}
											writeOutput('</select>');
										</cfscript>
									</td>
									<cfset const_tooltips = " - Click this link to switch to this subsystem or view.">
									<cfloop index="_item" list="#Request.cont_subsysNames#" delimiters=",">
										<td>
											<cfset _tooltips = CommonCode.setup_tooltip_handlers('nav_bar_anchor_' & _item)>
											<cfset varName = "_#_item#Mode">
											<cfset linkSymbol = "[" & UCase(_item) & "]">
											<cfif (Evaluate(varName) eq 1)>
												<div #_tooltips# title="Current View or SubSystem now in-use"><i>#linkSymbol#</i></div>
											<cfelse>
												<a #_tooltips# href="#commonCode.makeProperURLPrefix(base_siteName & _item)#" title="#UCase(_item)# View or SubSystem#const_tooltips#" target="myCMSv1">#linkSymbol#</a>
											</cfif>
										</td>
									</cfloop>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<cfset styles_container = 'style="display: block; position: absolute; top: #(height_div_nav_bar + 5)#; left: 0px;"'>
		</cfif>
	
		<div id="container" #styles_container#>
	</cfoutput>
	
	<cfoutput>
	<cfif (_SecurityMode eq 1)>
		<script language="JavaScript1.2" src="#_tabs_security_js#" type="text/javascript"></script>
	<cfelseif (_ReleaseMode eq 1)>
		<script language="JavaScript1.2" src="#_tabs_release_js#" type="text/javascript"></script>
	<cfelseif (_LayoutMode eq 1)>
		<script language="JavaScript1.2" src="#_tabs_layout_js#" type="text/javascript"></script>
	<cfelseif (_SQL2000Mode eq 1)>
		<script language="JavaScript1.2" src="#_tabs_sql2000_js#" type="text/javascript"></script>
	</cfif>
	</cfoutput>
	
	<!--- BEGIN: Use this for dynamic textarea colors --->
	<STYLE TYPE="TEXT/CSS"><!--
	.onLoad	{
	color:cyan;
	background:silver;
	scrollbar-base-color:black;
		}
	.onMouseOver	{
	background:red;
		}
	.onMouseOut	{
	background:silver;
		}
	//--></STYLE>
	<!--- END! Use this for dynamic textarea colors --->
	
	<cfoutput>
		<cfif (_layout_using_tables) AND (UCASE(function) neq UCASE(_uploadImageAction_symbol)) AND (_SecurityMode eq 0) AND (_ReleaseMode eq 0) AND (_LayoutMode eq 0) AND (_SQL2000Mode eq 0)>
			<cfset _layout_id = 0>
			<!--- BEGIN: There is only one ColdFusion layout processor - originally, the Layout Spec was to be hard-coded in ColdFusion files but not now... --->
			<cfinclude template="cfinclude_siteLayout#_layout_id#.cfm">
			<!--- END! There is only one ColdFusion layout processor - originally, the Layout Spec was to be hard-coded in ColdFusion files but not now... --->
		<cfelseif (_SQL2000Mode eq 0)>
			<cfinclude template="#_index_header_cfm#">
			<cfinclude template="index_menubar.cfm">
			
			<div id="wrapper">
				<cfif (_ReleaseMode eq 0) AND (_SecurityMode eq 0) AND (_LayoutMode eq 0) AND (_SQL2000Mode eq 0)>
					<div id="leftmenu_wrapper">
						<cfinclude template="#_index_menu_cfm#">
						<cfinclude template="#_index_quicklinks_cfm#">
					</div>
			
					<div id="rightmenu_wrapper">
						<cfinclude template="#_index_rightmenu_cfm#">
					</div>
			
					<cfinclude template="#_index_main_cfm#">
			
				<cfelseif (_ReleaseMode eq 1)>
					<cfinclude template="#_releaseModePathSuffix#cfinclude_releaseEditor.cfm">
				<cfelseif (_SecurityMode eq 1)>
					<cfinclude template="#_securityModePathSuffix#cfinclude_securityEditor.cfm">
				<cfelseif (_LayoutMode eq 1)>
					<cfinclude template="#_layoutModePathSuffix#cfinclude_layoutEditor.cfm">
				</cfif>
			</div><!--End wrapper - Middle Portion-->
			
			<cfinclude template="#_index_footer_cfm#">
		<cfelseif (_SQL2000Mode eq 1)>
			<cfinclude template="#_sql2000ModePathSuffix#cfinclude_sql2000Editor.cfm">
		</cfif>
	</cfoutput>
	
	</div> <!--- Container --->
</cfif>

</body>
</html>