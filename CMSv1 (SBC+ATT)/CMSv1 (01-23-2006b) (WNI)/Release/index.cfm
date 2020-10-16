<cfset _images_folder = "../images/">

<cfset _adminModeBackgroundImage = 'background="#_images_folder#release-transparent-background.gif"'>

<cfset _productionReleaseStageAction_symbol = "[Release Staging to Production]">
<cfset _productionReleaseAction_symbol = "[Release to Staging]">
<cfset _productionArchiveDevelopAction_symbol = "[Make Draft]">
<cfset _initialDevelopAction_symbol = "[Make Initial Draft]">
<cfset _revertStagingReleaseAction_symbol = "[Revert to Draft]">

<cfset _commentsEditorAction_symbol = "[Add Comments]">
<cfset _releaseLogReportAction_symbol = "[Release Log Report]">
<cfset _releaseLogSubReportAction_symbol = "[Release Log]">

<cfset _performReleasePurge_symbol = "Release Perform Purge on">
<cfset _genericCancelAction_symbol = _cancelButton_symbol>

<cfset _performReleaseAbstractAction_symbol = "to Staging.">
<cfset _performRevertReleaseAbstractAction_symbol = "Revert to">
<cfset _performProductionReleaseAbstractAction_symbol = "Perform Production Release">
<cfset _performMakeDraftAbstractAction_symbol = "Make Draft from">

<cfset _genericAddAction_symbol = _editorMenuAddAction_symbol>
<cfset _genericDropAction_symbol = _editorMenuDropAction_symbol>

<cfset _purgeUnwantedArchivesAction_symbol = "[Selective Release Purge]">
<cfset _purgeThisArchivesAction_symbol = "[Purge Release]">
<cfset _purgeCancelAction_symbol = "[Cancel Purge Mode]">

<cfset _purgedArchivesReportAction_symbol = "[Purged Archives Report]">

<cfset _vcrBeginAction_symbol = "[|<]">
<cfset _vcrPrevAction_symbol = "[<]">
<cfset _vcrNextAction_symbol = "[>]">
<cfset _vcrPrevPageAction_symbol = "[<<]">
<cfset _vcrNextPageAction_symbol = "[>>]">
<cfset _vcrEndAction_symbol = "[>|]">

<cfset _lookupStagingAction_symbol = "[Staging Search]">
<cfset _lookupDraftAction_symbol = "[Draft Search]">
<cfset _lookupProductionAction_symbol = "[Production Search]">
<cfset _lookupKeywordAction_symbol = "[Keyword Search]">
<cfset _lookupSearchAction_symbol = "[Search]">

<cfset _lookupNextAction_symbol = "[Next]">
<cfset _lookupPrevAction_symbol = "[Prev]">

<cfset _loadJSCode_js = "../components/_js/loadJSCode_.js">
<cfset _disable_right_click_script_III_js = "../components/_js/disable-right-click-script-III_.js">
<cfset _MathAndStringExtend_js = "../components/js/MathAndStringExtend.js">

<cfset _layout_css = "#siteCSS_base_fileName_symbol#">
<cfset _min_width_js = "../components/js/min_width.js">
<cfset _drop_down_js = "../components/js/drop_down.js">
<cfset _utility_js = "../components/js/utility.js">
<cfset _mytextsize_js = "../components/my-textsize.js/my-textsize.js">
<cfset _support_js = "../components/js/support.js">
<cfset _tabs_support_js = "../components/js/tabs_support.js">
<cfset _tabs_security_js = "../components/js/tabs_security.js">
<cfset _tabs_release_js = "../components/js/tabs_release.js">
<cfset _index_header_cfm = "index_header.cfm">
<cfset _index_menu_cfm = "index_menu.cfm">
<cfset _index_rightmenu_cfm = "index_rightmenu.cfm">
<cfset _index_main_cfm = "index_main.cfm">
<cfset _index_footer_cfm = "index_footer.cfm">
<cfset _index_layout_cfm = "index_layout.cfm">
<cfset _index_quicklinks_cfm = "index_quicklinks.cfm">
<cfset Request._adminTitle = " [Release Overlay] ">

<cfset _menuBar_extraSpaces = 70>

<cfset _num_tabs_max = 4>

<cfset _SQL_statement = "">

<cfparam name="_comments" default="" type="string">

<cfinclude template="../#_index_cfm_fileName#">

