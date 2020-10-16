<cfset _adminModeBackgroundImage = 'background="../images/security-transparent-background.gif"'>

<cfset _addUserAction_symbol = "[Add SBCUID]">
<cfset _dropUserAction_symbol = "[Delete SBCUID]">
<cfset _editUserAction_symbol = "[Edit SBCUID]">

<cfset _editViewSettingsAction_symbol = "[Edit/View Settings for current Draft Release]">

<cfset _addSubSystemAction_symbol = "[+]@S">
<cfset _dropSubSystemAction_symbol = "[-]@S">
<cfset _editSubSystemAction_symbol = "[*]@S">

<cfset _lookupUserAction_symbol = "[+]">

<cfset _lookupUserAction_prompt = "[Keyword Search]">
<cfset _lookupPageNameAction_prompt = "[Search for Content Page]">
<cfset _lookupNextPageNameAction_prompt = "[Next Page]">

<cfset _lookupNextAction_symbol = "[?->]">

<cfset _vcrBeginAction_symbol = "[|<]">
<cfset _vcrPrevAction_symbol = "[<]">
<cfset _vcrNextAction_symbol = "[>]">
<cfset _vcrPrevPageAction_symbol = "[<<]">
<cfset _vcrNextPageAction_symbol = "[>>]">
<cfset _vcrEndAction_symbol = "[>|]">

<cfset _lookupNextAction_symbol = "[Next]">
<cfset _lookupPrevAction_symbol = "[Prev]">

<cfset index_method_inline = 1>
<cfset index_method_terse = -1>

<cfset _ss_maxRowsPerColumn = 10>
<cfset _ss_maxCharsPerColumn = 25>
<cfset _ss_minCharsPerColumn = (_ss_maxCharsPerColumn + 5)>

<cfset _ss_maxVisibleCols = 3>

<cfset _ss_maxDisplayableUserIndex = 20>

<cfset _updateSubSystemAccessAction_symbol = "[*]@SSA">
<cfset _updatePageAccessAction_symbol = "[*]@PA">

<cfset _updateSubSystemPageAccessAction_symbol = "[*]@SSAPA">

<cfset _directory_type_symbol = "Dir">

<cfset _num_tabs_max = 7>

<cfparam name="_userid" default="" type="string">
<cfparam name="_user_name" default="" type="string">
<cfparam name="_user_phone" default="" type="string">

<cfparam name="_subsystemId" default="" type="string">
<cfparam name="_pageId" default="" type="string">

<cfparam name="_id" default="" type="string">

<cfset _webphone_searchfor_sbcuid_url = "">

<cfset _webphone_searchfor_status_code_symbol = "200 OK">
<cfset _webphone_searchfor_last_name_symbol = "Last Name:">
<cfset _webphone_searchfor_first_name_symbol = "First Name:">
<cfset _webphone_searchfor_phone_symbol = "Phone:">
<cfset _webphone_searchfor_token2_symbol = "&nbsp;">
<cfset _webphone_searchfor_openTag_symbol = Chr(60)>
<cfset _webphone_searchfor_closeTag_symbol = Chr(62)>
<cfset _webphone_searchfor_openEscape_symbol = "&">
<cfset _webphone_searchfor_closeEscape_symbol = ";">

<cfset _loadJSCode_js = "../components/_js/loadJSCode_.js">
<cfset _disable_right_click_script_III_js = "../components/_js/disable-right-click-script-III_.js">
<cfset _MathAndStringExtend_js = "../components/js/MathAndStringExtend.js">

<cfset _layout_css = "#siteCSS_base_fileName_symbol#">
<cfset _min_width_js = "../components/js/min_width.js">
<cfset _drop_down_js = "../components/js/drop_down.js">
<cfset _utility_js = "../components/js/utility.js">
<cfset _mytextsize_js = "../components/my-textsize.js/my-textsize.js">
<cfset _SBCUIDPicker_js = "../components/js/SBCUIDPicker.js">
<cfset _support_js = "../components/js/support.js">
<cfset _tabs_support_js = "../components/js/tabs_support.js">
<cfset _tabs_security_js = "../components/js/tabs_security.js">
<cfset _tabs_release_js = "../components/js/tabs_release.js">
<cfset _ColorPicker2_js = "../components/color-picker.js/ColorPicker2.js">
<cfset _AnchorPosition_js = "../components/color-picker.js/AnchorPosition.js">
<cfset _PopupWindow_js = "../components/color-picker.js/PopupWindow.js">
<cfset _index_header_cfm = "index_header.cfm">
<cfset _index_menu_cfm = "index_menu.cfm">
<cfset _index_rightmenu_cfm = "index_rightmenu.cfm">
<cfset _index_main_cfm = "index_main.cfm">
<cfset _index_footer_cfm = "index_footer.cfm">
<cfset _index_layout_cfm = "index_layout.cfm">
<cfset _index_quicklinks_cfm = "index_quicklinks.cfm">
<cfset Request._adminTitle = " [Security Overlay] ">
<cfset _images_folder = "../images/">

<cfset _menuBar_extraSpaces = 70>

<cfset _SQL_statement = "">

<cfinclude template="../#_index_cfm_fileName#">

