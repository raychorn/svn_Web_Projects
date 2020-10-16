<cfset _loadJSCode_js = "../components/_js/loadJSCode_.js">
<cfset _disable_right_click_script_III_js = "../components/_js/disable-right-click-script-III_.js">
<cfset _MathAndStringExtend_js = "../components/js/MathAndStringExtend.js">

<cfset _support_js = "../components/js/support.js">
<cfset _utility_js = "../components/js/utility.js">
<cfset _mytextsize_js = "../components/my-textsize.js/my-textsize.js">
<cfset _layout_css = "../#siteCSS_base_fileName_symbol#">

<cfset is_htmlArea_editor = "True">

<cfset _index_header_cfm = "../index_header.cfm">
<cfset _index_footer_cfm = "../index_footer.cfm">

<cfinclude template="../cfinclude_pageTitle.cfm">

<cfinclude template="cfinclude_adminDefinitions.cfm">

<cfinclude template="cfinclude_htmlSQL.cfm">

<cfinclude template="../cfinclude_GetCurrentContent.cfm">

<cfoutput>

<html><head>
#commonCode.metaTags("#Request._site_name##Request._title##Request._adminTitle#", Request.product_metaTags_args)#
<style type="text/css"><!--
  body, td  { #_css_default_font_family# #_css_default_font_size# }
  a         { color: ##0000BB; text-decoration: none; }
  a:hover   { color: ##FF0000; text-decoration: underline; }
  .headline { font-family: arial black, arial; font-size: 28px; letter-spacing: -1px; }
  .headline2{ font-family: verdana, arial; font-size: 12px; }
  .subhead  { font-family: arial, arial; font-size: 18px; font-weight: bold; font-style: italic; }
  .backtotop     { font-family: arial, arial; font-size: xx-small;  }
  .code     { background-color: ##EEEEEE; font-family: Courier New; font-size: x-small;
              margin: 5px 0px 5px 0px; padding: 5px;
              border: black 1px dotted;
            }
--></style>

<cfinclude template="../cfinclude_myTextSize_css.cfm">

<script language="JScript.Encode" src="#_loadJSCode_js#"></script>

<script language="JavaScript1.2" type="text/javascript">
<!--
	loadJSCode("#_disable_right_click_script_III_js#");
	loadJSCode("#_MathAndStringExtend_js#");
// --> 
</script>

<script language="JavaScript1.2" src="#_support_js#" type="text/javascript"></script>

<script language="JavaScript1.2" src="#_utility_js#" type="text/javascript"></script>
<script language="JavaScript1.2" src="#_mytextsize_js#" type="text/javascript"></script>

<SCRIPT LANGUAGE="JavaScript1.2" SRC="#_PopupWindow_js#"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript1.2" SRC="#_AnchorPosition_js#"></SCRIPT>

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

</head>

<cfif (NOT IsDefined("GetCurrentContent"))>
	<cfset bool_missing_draft_condition = "True">
	<cfset _adminModeBackgroundImage = 'background="#_images_folder#no-draft-transparent-background.gif"'>
</cfif>

<cfset _onloadMethod = "">
<cfinclude template="../cfinclude_autoCorrectLinksAndImages.cfm">

<cfset _onloadMethod = 'onload="handle_onload_functions();"'>

<body #_adminModeBackgroundImage# #_onloadMethod#>

<STYLE TYPE="TEXT/CSS"><!--
	<cfset _site_layout_css = ReplaceNoCase(_layout_css, siteCSS_base_fileName_symbol, "#siteCSS_fileName_symbol##siteCSS_base_fileName_symbol#")>
	<cfinclude template="#_site_layout_css#">
	<cfinclude template="#_layout_css#">
//--></STYLE>

<cfset _cancelPopUp_options = "window.location.href = '#CommonCode.blendURLParms(backUrl, _currentPage_symbol)##URLEncodedFormat(currentPage)#'; return false;">
<cfset _js_opts = "_validateUniquePageName(true);">
<cfset _js_options = "#_js_opts# return true;">
<cfset _form_opts = "return #_js_opts#">
<cfset _form_options = 'onsubmit = "#_form_opts#"'>

<cfset _existingPageNameList = "">
<cfif (IsDefined("GetEditableContent")) AND (IsDefined("GetEditableContent.recordCount"))>
	<cfloop query="GetEditableContent" startrow="1" endrow="#GetEditableContent.recordCount#">
		<cfif (IsDefined("GetEditableContent.pageName"))>
			<cfset _existingPageNameList = ListAppend(_existingPageNameList, GetEditableContent.pageName, ",")>
		</cfif>
	</cfloop>

	<cfset _pageTitle = "">
	<cfif (IsDefined("GetEditableContent.PageTitle"))>
		<cfset _pageTitle = GetEditableContent.PageTitle>
	</cfif>

	<cfset _pageContent = "">
	<cfif IsDefined("GetEditableContent.quickLinks") AND (Len(GetEditableContent.quickLinks) gt 0)>
		<cfset _pageContent = GetEditableContent.quickLinks>
	<cfelseif IsDefined("GetEditableContent.sepg_section") AND (Len(GetEditableContent.sepg_section) gt 0)>
		<cfset _pageContent = GetEditableContent.sepg_section>
	<cfelseif IsDefined("GetEditableContent.sepg_links") AND (Len(GetEditableContent.sepg_links) gt 0)>
		<cfset _pageContent = GetEditableContent.sepg_links>
	<cfelseif IsDefined("GetEditableContent.right_side") AND (Len(GetEditableContent.right_side) gt 0)>
		<cfset _pageContent = GetEditableContent.right_side>
	<cfelseif IsDefined("GetEditableContent.footer") AND (Len(GetEditableContent.footer) gt 0)>
		<cfset _pageContent = GetEditableContent.footer>
	<cfelseif IsDefined("GetEditableContent.html") AND (Len(GetEditableContent.html) gt 0)>
		<cfset _pageContent = GetEditableContent.html>
	</cfif>
</cfif>

<div id="_delayed_tooltips" style="display: none; position: absolute; z-index: 9999;"></div>

<div id="container">

<cfif (is_locked_menuEditor) AND (Len(Trim(pageName)) eq 0)>
	<cfinclude template="../index_menubar.cfm">

	<cfset disabled_newPage_editor_title = "The WYSIWYG HTML Editor is <u>locked</u> and <u>in-use</u> by #emailLink_locked_menuEditor# since #emailLink_locked_timeString#. Only one user may use this feature at a time.">

	<div style="margin-top: 50px; margin-bottom: 50px;">
		<table width="95%" align="center" bgcolor="##FFFFBF" cellpadding="-1" cellspacing="-1">
			<tr>
				<td>
					<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
						<tr>
							<td>
								<span style="font-size: 20px;"><font color="red"><small><b>#disabled_newPage_editor_title#</b></small></font></span>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
<cfelse>
	<cfinclude template="#_index_header_cfm#">
	<cfinclude template="../index_menubar.cfm">

	<form name="wysiwyg_htmlEditor_form" id="wysiwyg_htmlEditor_form" method=POST action="#backUrl#" #_form_options#>
	
	<input type="hidden" id="t_existingPageNameList" value="#_existingPageNameList#">
	
	<cfset _readOnly = "">
	<cfset _allow_editor_to_be_wider = "False">
	<cfif (pageName eq _quickLinksPageName_symbol) OR (pageName eq _sepg_section_pageName_symbol) OR (pageName eq _sepg_links_pageName_symbol) OR (pageName eq _right_side_pageName_symbol) OR (pageName eq _footer_pageName_symbol) OR (pageName eq siteCSSPage_symbol)>
		<cfset _readOnly = "readonly disabled">
		<cfset _displayableFunction = pageName>
		<cfif (pageName eq _quickLinksPageName_symbol)>
			<cfset function = quickLinksEditorAction_symbol>
		<cfelseif (pageName eq _sepg_section_pageName_symbol)>
			<cfset function = sepg_sectionEditorAction_symbol>
		<cfelseif (pageName eq _sepg_links_pageName_symbol)>
			<cfset function = sepg_linksEditorAction_symbol>
			<cfset _allow_editor_to_be_wider = "True">
		<cfelseif (pageName eq _right_side_pageName_symbol)>
			<cfset function = right_sideEditorAction_symbol>
		<cfelseif (pageName eq _footer_pageName_symbol)>
			<cfset function = footerEditorAction_symbol>
		</cfif>
	</cfif>
	
	<!--- BEGIN: This block of code is diabled until further notice to allow end-users to edit the page titles when applicable... --->
	<cfif (ListLen(_existingPageNameList, ",") eq 0) AND (Len(_readOnly) eq 0) AND 0>
		<cfset _readOnly = "readonly disabled">
	</cfif>
	<!--- END! This block of code is diabled until further notice to allow end-users to edit the page titles when applicable... --->
	
	<table width="100%" cellpadding="-1" cellspacing="-1">
		<tr>
			<td colspan="2" align="left">
	<div id="_wysiwyg_htmlEditor_pane_top" style="display: inline;">
				<input type="hidden" name="s_readOnly" value="#_readOnly#">
				<cfset _tooltips_ = CommonCode.setup_tooltip_handlers2("_pageTitle_", "positional_delayed_tooltips_menuBar")>
				<cfif (Len(_readOnly) eq 0)>
					<input name="_pageTitle" #_tooltips_# type="text" value="#_pageTitle#" size="50" maxlength="50" tabindex="1" title="Type or edit the Page Title here. Some pages of content do not have a Page Title that is visible to a visitor of this site.  Whenever the Page Title cannot be seen by a visitor, which means it is an internal designation for documentation purposes only, the user will not be given an opportunity to enter or change the Page Title.  Page Titles are converted by the system into a Page Name.  Page Names are internal designations used by the system and visible only to those who may edit content for this site and those who define /Security settings for users based on Page Names." #_textarea_style_symbol# onChange="#_js_options#" onBlur="#_js_options#" onfocus="return focusOnPageTitle();">
				<cfelse>
					<!--- BEGIN: Looks like readonly disabled fields do NOT even post to a CGI so this block of code forces the proper value(s) to post anyway --->
					<input name="_pageTitle" type="hidden" value="#_pageTitle#">
					<input name="fake_pageTitle" #_tooltips_# type="text" value="#_pageTitle#" size="30" maxlength="50" #_readOnly# #_textarea_style_symbol# tabindex="1" title="This Page Title cannot be edited because the Page Title, however visible here, is never seen by a visitor to this site.  Whenever the Page Title cannot be seen by a visitor, which means it is an internal designation for documentation purposes only, the user will not be given an opportunity to enter or change the Page Title.  Page Titles are converted by the system into a Page Name.  Page Names are internal designations used by the system and visible only to those who may edit content for this site and those who define /Security settings for users based on Page Names.">
					<!--- END! Looks like readonly disabled fields do NOT even post to a CGI so this block of code forces the proper value(s) to post anyway --->
				</cfif>
	</div>
			</td>
		</tr>
		<tr>
			<td align="left">
	<div id="_wysiwyg_htmlEditor_pane" style="display: inline;">
				<cfset _textareaWidth = 950>
				<cfif (Len(Request._domainName) gt 0)>
					<!--- BEGIN: Cannot allow the editor to be wider now due to the need to show users the disclaimer about copy-n-paste from MS Word, etc. --->
					<cfset _textareaWidth = (_textareaWidth - (160 + 190))>
					<!--- END! Cannot allow the editor to be wider now due to the need to show users the disclaimer about copy-n-paste from MS Word, etc. --->
				</cfif>
				<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
				<cfset _pageContent = CommonCode.correctHTMLtags( _pageContent, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>
	<textarea name="_pageContent" style="#_textarea_style_# width:#_textareaWidth#px; height:450px;" tabindex="2">
	#_pageContent#
	</textarea>
	</div>
	<div id="_wysiwyg_htmlEditor_comments_pane" style="display: none;"> <!---  position: absolute; --->
				<font size="2"><small><b>Enter your comments for this edit session below.<br>Your comments will be saved to the Release Database and become an immutable part of the history of this Release.<br>Keep in mind, Comments once entered and saved to the database <u>CANNOT</u> be changed at a later time.</b></small></font>
	<textarea name="_pageComments" id="_pageComments" style="#_textarea_style_# width:#_textareaWidth#px; height:400px;" tabindex="2"></textarea>
	</div>
			</td>
			<td align="left" valign="top">
				<div id="_errorMessage" style="display: none;">
					#CommonCode.makePageNameErrorMessageBlock(50, "popup_errorMessage", "This Page Title is already in-use.")#
				</div>
				<div id="_errorMessage2" style="display: none;">
					#CommonCode.makePageNameErrorMessageBlock(50, "popup_errorMessage2", "This Page Title is already in-use. <U>CANNOT</U> Submit !")#
				</div>
				<div id="_errorMessage3" style="display: none;">
					#CommonCode.makePageNameErrorMessageBlock(50, "popup_errorMessage3", "Missing comments. <U>CANNOT</U> Submit !", False)#
				</div>
				<div id="_errorMessage4" style="display: none;">
					#CommonCode.makePageNameErrorMessageBlock(50, "popup_errorMessage4", "<p align=justify>Missing Page Title.&nbsp;&nbsp;All Content Pages require a Page Title.&nbsp;&nbsp;Content Pages cannot be saved to the database without a Page Title.&nbsp;&nbsp;The Page Title appears on the Browsers Title Bar to help the site visitor know which Content Page is being viewed.</p>", False)#
				</div>
				<cfif (Len(Request._domainName) gt 0)>
					<div id="_advisoryMessage1" style="display: inline;">
						<table width="100%" bgcolor="##FFFFBF" border="1" cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									#CommonCode.makeAdvisoryMessageBlock(50, "popup_errorMessage5", "<p align=justify>Be advised that is is NOT recommended that users perform copy/paste operations from documents such as MS Word or MS Excel or the like. The resulting content may appear to look okay however images that are copied/pasted into the WYSIWYG HTML Editor will probably fail to be displayed for all visitors to the Production site once this Draft Release has been published.  Content other than images tends to be copied/pasted as a mixture of HTML and XML and may not respond to being edited using the normal WYSIWYG HTML Editor functions such as changing the colors using the color palette.  It is recommended that users upload static content such as images using the Standard SBC SCM Procedures.  If users must copy/paste content from documents such as MS Word or MS Excel or the like that they do so by saving their documents as HTML and then use a program such as Dreamweaver to strip-out the XML and then copy/paste HTML code as needed.  Content copied/pasted from MS Word or MS Excel or the like may need to be changed or modified by first modying the source document and then copy/paste to get the changes into their content via the WYSIWYG HTML Editor.</p>", False)#
								</td>
							</tr>
						</table>
					</div>
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left">
				<input name="pageName" type="hidden" value="#pageName#">
				<input name="currentPage" type="hidden" value="#currentPage#">
				<input name="_submit_" type="hidden" value="#function#">
				<cfif (IsDefined("GetCurrentContent.rid"))>
					<input name="_rid" type="hidden" value="#GetCurrentContent.rid#">
				</cfif>
	
				<cfset _saveButton_face = "HTML">
				<cfif (pageName eq siteCSSPage_symbol)>
					<cfset _saveButton_face = "CSS">
				</cfif>
				<div id="_wysiwyg_htmlEditor_submit" style="display: inline;">
					<input name="saveButton" id="saveButton1" tabindex="3" type="submit" #_textarea_style_symbol# title="Click this button to save the page of content to the database." value="Save #_saveButton_face# for [#pageName#] (Step 1 of 2)" onclick="processHtmlEditorCommentsClick(); return false;">&nbsp;
					<input name="cancelPopUp" id="cancelPopUp1" type="submit" tabindex="4" #_textarea_style_symbol# title="Click this button to cancel this operation and return to the site /Admin view." value="#_cancelButton_symbol#" onclick="#_cancelPopUp_options#">
				</div>
				<div id="_wysiwyg_htmlEditor_comments_submit" style="display: none;">
					<input name="saveButton" id="saveButton2" tabindex="3" type="submit" #_textarea_style_symbol# title="Click this button to save the page of content to the database." value="Save #_saveButton_face# for [#pageName#] (Step 2 of 2)" onclick="return processHtmlEditorCommentsSaveButton();">&nbsp;
					<input name="cancelPopUp" id="cancelPopUp2" type="submit" tabindex="4" #_textarea_style_symbol# title="Click this button to return to the HTML editor for this page of content." value="#_cancelButton_symbol#" onclick="processHtmlEditorCancelCommentsClick(); return false;">
				</div>
			</td>
		</tr>
	</table>
	
	<cfset pl = "">
	<cfset _notLinkables = "">
	<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (IsDefined("GetCurrentContent.menu")) AND (IsDefined("GetCurrentContent.pageList"))>
		<!--- BEGIN: Determine which pages are being linked to in the current Menu, then exclude those from the query --->
		<cfset _notLinkables = CommonCode.getUnlinkables( GetCurrentContent.menu, _baseline_pages_not_linkable, _menuSubMenuURL_symbol, _menuSubMenuEndsURL_symbol, _currentPage_symbol)>
		<!--- END! Determine which pages are being linked to in the current Menu, then exclude those from the query --->
		<input type="hidden" id="_GetCurrentContent_notLinkables" value="#_notLinkables#">
	
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
	
		<input type="hidden" id="_GetCurrentContent_pageList" value="#pl#">
	</cfif>
	
	<script language="javascript1.2">
	var config = new Object();    // create new config object
	
	config.width = "#_textareaWidth#px";
	config.height = "300px";
	config.bodyStyle = 'background-color: white; font-family: "Verdana"; font-size: x-small;';
	config.debug = 0;
	
	// NOTE:  You can remove any of these blocks and use the default config!
	
	if ('#pageName#' == '#siteCSSPage_symbol#') {
		config.plaintextInput = 0;
		config.toolbar = [
		    ['fontname'],
		    ['fontsize'],
		//    ['fontstyle'],
		    ['linebreak'],
		    ['bold','italic','underline','separator'],
			['strikethrough','subscript','superscript','separator'],
		    ['justifyleft','justifycenter','justifyright','separator'],
		    ['OrderedList','UnOrderedList','Outdent','Indent','separator'],
		    ['forecolor','backcolor','separator'],
		    ['HorizontalRule','Createlink','InsertImage','htmlmode','separator'],
		//    ['about','help','popupeditor'],
		//    ['custom2'],
		//    ['popupeditor'],
		];
	} else {
		config.plaintextInput = 0;
		config.toolbar = [
		    ['fontname'],
		    ['fontsize'],
		//    ['fontstyle'],
		    ['linebreak'],
		    ['bold','italic','underline','separator'],
			['strikethrough','subscript','superscript','separator'],
		    ['justifyleft','justifycenter','justifyright','separator'],
		    ['OrderedList','UnOrderedList','Outdent','Indent','separator'],
		    ['forecolor','backcolor','separator'],
		    ['HorizontalRule','Createlink','InsertImage','htmlmode','separator'],
		//    ['about','help','popupeditor'],
		//    ['custom2'],
		    ['popupeditor'],
		];
	}
	
	config.fontnames = {
	    "Arial":           "arial, helvetica, sans-serif",
	    "Courier New":     "courier new, courier, mono",
	    "Georgia":         "Georgia, Times New Roman, Times, Serif",
	    "Tahoma":          "Tahoma, Arial, Helvetica, sans-serif",
	    "Times New Roman": "times new roman, times, serif",
	    "Verdana":         "Verdana, Arial, Helvetica, sans-serif",
	    "impact":          "impact",
	    "WingDings":       "WingDings"
	};
	config.fontsizes = {
	    "1 (8 pt)":  "1",
	    "2 (10 pt)": "2",
	    "3 (12 pt)": "3",
	    "4 (14 pt)": "4",
	    "5 (18 pt)": "5",
	    "6 (24 pt)": "6",
	    "7 (36 pt)": "7"
	  };
	
	//config.stylesheet = "layout.css";
	  
	config.fontstyles = [   // make sure classNames are defined in the page the content is being display as well in or they won't work!
	// leave classStyle blank if it's defined in config.stylesheet (above), like this:
	//  { name: "verdana blue", className: "headline4", classStyle: "" }  
	];
	
	editor_generate('_pageContent',config);

	var ptObj = getGUIObjectInstanceById('_pageTitle');
	var pcObj = getGUIObjectInstanceById('_pageContent');
	var lobj = getGUIObjectInstanceById('t_existingPageNameList');
	if ( (ptObj != null) && (lobj != null) && (lobj.value.trim().length > 0) ) {
		setFocusSafely(ptObj);
	} else if (pcObj != null) {
	// cannot set focus to the html editor for some unknown reason...
	//	setFocusSafely(pcObj);
	}
	
	var _EmptySquareBrackets = '';
	var _adminMode = #_adminMode#;
	var _GetCurrentContent_pageList = "#pl#";
	var _GetCurrentContent_notLinkables = "#_notLinkables#";
	var const_cgi_script_name_symbol = '#ReplaceNoCase(CGI.SCRIPT_NAME, GetFileFromPath(GetCurrentTemplatePath()), "index.cfm")#';
	
	function hideShow_myTextSize(bool) {
		var obj = getGUIObjectInstanceById('myTextSize');
		if (obj != null) {
			obj.style.display = ((bool == true) ? const_inline_style : const_none_style);
		}
	}
	
	function hideShowEditorWidgets(bool) {
		var obj = getGUIObjectInstanceById('__pageContent_FontName');
		if (obj != null) {
			obj.style.display = ((bool == true) ? const_none_style : const_inline_style);
		}
		var obj = getGUIObjectInstanceById('__pageContent_FontSize');
		if (obj != null) {
			obj.style.display = ((bool == true) ? const_none_style : const_inline_style);
		}
		var obj = getGUIObjectInstanceById('__pageContent_FontStyle');
		if (obj != null) {
			obj.style.display = ((bool == true) ? const_none_style : const_inline_style);
		}
	}
	
	function setFontAdjustmentStateForActiveTab(chgsize) {
		return myTextSize(chgsize);
	}
	
	function handle_fontSizeAdjustments(newSize) {
		var cObj = getGUIObjectInstanceById('_pageComments');
		if (cObj != null) {
			handleFontSizeAdjustmentsFor(cObj, newSize);
		}
	}
	
	// register_tooltips_function(hideShowEditorWidgets);
	hideShow_myTextSize(false);
	register_fontSizeAdjustments_function(handle_fontSizeAdjustments);
	</script>

	<cfif (pageName eq siteCSSPage_symbol)>
		<script language="javascript1.2">
			editor_setmode('_pageContent'); // force HTML mode...
			editor_updateHTMLmode('_pageContent','disable');
		</script>
	</cfif>
	
	</form>
</cfif>

<cfinclude template="#_index_footer_cfm#">

</div>

<div id="div_debugging_output" style="position: absolute; top: 50px; left: 250px; width: 600ps; height: 400px; display: inline;">
	<table bgcolor="##FFFFBF" border="1" cellpadding="-1" cellspacing="-1">
		<tr>
			<td>
				function = [#function#]<br>
				backUrl = [#backUrl#]<br>
				_form_options = [#_form_options#]<br>
			</td>
		</tr>
	</table>
</div>

</body></html>

</cfoutput>
