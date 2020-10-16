<cfset _loadJSCode_js = "../components/_js/loadJSCode_.js">
<cfset _disable_right_click_script_III_js = "../components/_js/disable-right-click-script-III_.js">
<cfset _MathAndStringExtend_js = "../components/js/MathAndStringExtend.js">

<cfset _layout_css = "#siteCSS_base_fileName_symbol#">
<cfset _min_width_js = "../../components/js/min_width.js">
<cfset _drop_down_js = "../../components/js/drop_down.js">
<cfset _utility_js = "../../components/js/utility.js">
<cfset _mytextsize_js = "../../components/my-textsize.js/my-textsize.js">
<cfset _marquee_scroller_core_js = "../../components/js/marquee_scroller_core.js">
<cfset _menu_editor_core_js = "../../components/js/menu_editor_core.js">
<cfset _right_menu_core_js = "../../components/js/right_menu_core.js">
<cfset _support_js = "../../components/js/support.js">
<cfset _tabs_support_js = "../../components/js/tabs_support.js">
<cfset _tabs_security_js = "../../components/js/tabs_security.js">
<cfset _tabs_release_js = "../../components/js/tabs_release.js">
<cfset _cookie_js = "../../components/tabs.js/readable/cookie.js">
<cfset _htmlarea_path = "../../components/htmlarea.js/">

<cfset _calendar_css = "components/jscalendar-0.9.6/calendar-win2k-1.css">
<cfset _calendar_js = "../../components/jscalendar-0.9.6/calendar.js">
<cfset _calendar_en_js = "../../components/jscalendar-0.9.6/lang/calendar-en.js">
<cfset _calendar_setup_js = "../../components/jscalendar-0.9.6/calendar-setup.js">

<cfset _index_header_cfm = "index_header.cfm">
<cfset _index_menu_cfm = "index_menu.cfm">
<cfset _index_rightmenu_cfm = "index_rightmenu.cfm">
<cfset _index_main_cfm = "index_main.cfm">
<cfset _index_layout_cfm = "index_layout.cfm">
<cfset _index_footer_cfm = "index_footer.cfm">
<cfset _index_quicklinks_cfm = "index_quicklinks.cfm">

<cfinclude template="../cfinclude_adminDefinitions.cfm">

<cfset _AnchorPosition_js = "../../components/color-picker.js/AnchorPosition.js">
<cfset _PopupWindow_js = "../../components/color-picker.js/PopupWindow.js">

<cfif _adminMethod eq _adminMethod_nopopups>
	<cfinclude template="../../#_index_cfm_fileName#">
</cfif>

