<cfset _adminMethod_popups = 1>
<cfset _adminMethod_nopopups = 2>
<cfset _adminMethod = _adminMethod_nopopups>

<cfset _ch = Chr(167)>
<cfset _editorAction_symbol = "[#_ch#]">

<cfset _ch2 = Chr(206)>
<cfset _uploaderAction_symbol = "[#_ch2#]">

<cfset Request._adminTitle = " [Admin Overlay] ">

<cfset quickLinksEditorAction_symbol = "[QuickLinks]">
<cfset sepg_sectionEditorAction_symbol = "[sepg_section]">
<cfset sepg_linksEditorAction_symbol = "[sepg_links]">
<cfset right_sideEditorAction_symbol = "[right_side]">
<cfset footerEditorAction_symbol = "[footer]">

<cfset _htmlEditorNewPageAction_symbol = "#_editorAction_symbol#|">

<cfset _htmlMenuEditorAction_symbol = "#_editorAction_symbol#|[Menu]">
<cfset _htmlMenuCommitAction_symbol = "|[Menu-Commit]">

<cfif (CommonCode.isStagingView())>
	<cfset _images_folder = "../../images/">
<cfelse>
	<cfset _images_folder = "../images/">
</cfif>

<cfset _adminModeBackgroundImage = 'background="#_images_folder#draft-transparent-background.gif"'>

<cfset _cancelButton_symbol = "[Cancel]">
<cfset _saveMarqueeButton_symbol = "[Save]">
<cfset _removeMarqueeButton_symbol = "[Remove]">
<cfset const_Marquee_symbol = "[Marquee]">
<cfset _editMarquee_symbol = "#_editorAction_symbol#|#const_Marquee_symbol#">

<cfset _AnchorPosition_js = "../components/color-picker.js/AnchorPosition.js">
<cfset _PopupWindow_js = "../components/color-picker.js/PopupWindow.js">

<cfinclude template="../cfinclude_ColdFusionJavaScript_globals.cfm">

