<cfset _images_folder = "../images/">

<cfset _adminModeBackgroundImage = 'background="#_images_folder#layout-transparent-background.gif"'>

<cfparam name="_editable_layout_change_name" type="string" default="False">
<cfparam name="_layout_id" type="string" default="">
<cfparam name="_num" type="string" default="-1">

<cfset layoutSaveAction_symbol = "[Save Layout]">
<cfset layoutSaveCommentsAction_symbol = "[Save Comments]">

<cfset layoutUseItAction_symbol = "[Use this Layout]">

<cfset layoutEditItAction_symbol = "[Edit this Layout]">

<cfset layoutSaveLayoutAction_symbol = "[Save this Layout]">
<cfset layoutSaveNewLayoutAction_symbol = "[Save New Layout]">

<cfset _vcrBeginAction_symbol = "[|<]">
<cfset _vcrPrevAction_symbol = "[<]">
<cfset _vcrNextAction_symbol = "[>]">
<cfset _vcrPrevPageAction_symbol = "[<<]">
<cfset _vcrNextPageAction_symbol = "[>>]">
<cfset _vcrEndAction_symbol = "[>|]">

<cfset _lookupInUseAction_symbol = "[In-Use Search]">
<cfset _openUsageKeyAction_symbol = "[Open Usage Key]">
<cfset _closeUsageKeyAction_symbol = "[x]">

<cfset layoutEditorAction_symbol = "[New Table]">
<cfset layoutCloseAction_symbol = "[x]">
<cfset layoutSaveTableAction_symbol = "[Make Table]">
<cfset layoutAssignContentAction_symbol = "[Assign Content]">
<cfset layoutApplyChangesAction_symbol = "[Apply Changes]">

<cfset layoutPreviewHTMLAction_symbol = "[i]">
<cfset layoutPreviewHTMLAction_link = '<a href="" onclick="performPreviewHTML(); return false;"><font size="1"><small><b>#layoutPreviewHTMLAction_symbol#</b></small></font></a>'>

<cfset _loadJSCode_js = "../components/_js/loadJSCode_.js">
<cfset _disable_right_click_script_III_js = "../components/_js/disable-right-click-script-III_.js">
<cfset _MathAndStringExtend_js = "../components/js/MathAndStringExtend.js">

<cfset _layout_css = "#siteCSS_base_fileName_symbol#">
<cfset _min_width_js = "../components/js/min_width.js">
<cfset _drop_down_js = "../components/js/drop_down.js">
<cfset _utility_js = "../components/js/utility.js">
<cfset _layout_editor_core_js = "../components/js/layout_editor_core.js">
<cfset _layout_core_js = "../components/js/layout_core.js">
<cfset _mytextsize_js = "../components/my-textsize.js/my-textsize.js">
<cfset _support_js = "../components/js/support.js">
<cfset _tabs_support_js = "../components/js/tabs_support.js">
<cfset _tabs_security_js = "../components/js/tabs_security.js">
<cfset _tabs_release_js = "../components/js/tabs_release.js">
<cfset _tabs_layout_js = "../components/js/tabs_layout.js">
<cfset _index_header_cfm = "index_header.cfm">
<cfset _index_menu_cfm = "index_menu.cfm">
<cfset _index_rightmenu_cfm = "index_rightmenu.cfm">
<cfset _index_main_cfm = "index_main.cfm">
<cfset _index_footer_cfm = "index_footer.cfm">
<cfset _index_layout_cfm = "index_layout.cfm">
<cfset _index_quicklinks_cfm = "index_quicklinks.cfm">
<cfset Request._adminTitle = " [Layout Overlay] ">

<cfset _menuBar_extraSpaces = 70>

<cfset _num_tabs_max = 7>

<cfset _SQL_statement = "">

<cfinclude template="../#_index_cfm_fileName#">
