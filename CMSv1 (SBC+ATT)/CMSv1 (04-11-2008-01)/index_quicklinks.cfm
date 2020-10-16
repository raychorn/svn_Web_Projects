<cfoutput>
	<cfset _div_js_quicklinks_onmouseover = "">
	<cfset _div_js_quicklinks_onmouseout = "">
	<cfif (_LayoutMode eq 1) AND 0>
		<cfset _div_js_quicklinks_onmouseover = "makeElementHilite(document.getElementById('quicklinks')); return false;">
		<cfset _div_js_quicklinks_onmouseout = "makeElementNoHilite(document.getElementById('quicklinks')); return false;">
	<cfelse>
		<cfset _div_js_quicklinks_onmouseover = "">
		<cfset _div_js_quicklinks_onmouseout = "">
	</cfif>
	<div id="quicklinks_wrapper">
		<div id="quicklinks" #_div_styles_quicklinks# onmouseover="#_div_js_quicklinks_onmouseover#" onmouseout="#_div_js_quicklinks_onmouseout#">
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr valign="bottom">
					<td valign="top" align="center">
						<cfif (_LayoutMode eq 1) AND 0 AND (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0)>
							<img id="quicklinks_dragmark" src="#_images_folder#folderclosed.gif" align="left" height="12" onmousedown="makeElementDragable(document.getElementById('quicklinks_dragmark'), document.getElementById('quicklinks'), document.getElementById('leftmenu_wrapper'), document.getElementById('quicklinks_wrapper'), document.getElementById('rightside_wrapper'), document.getElementById('rightmenu_wrapper')); return false;">
						</cfif>
						<cfif (NOT CommonCode.isStagingView()) AND (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount neq 0) AND (IsDefined("VerifyQuickLinksSecurity")) AND (VerifyQuickLinksSecurity.recordCount gt 0)>
							#RepeatString("<br>", 1)#
							&nbsp;#_quickLinks_editor#
						</cfif>
					</td>
					<td valign="bottom" align="left">
						<br>
						<cfif (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.quickLinks")) AND (GetCurrentContent.recordCount gt 0)>
							<cfloop query="GetCurrentContent" startrow="1" endrow="#GetCurrentContent.recordCount#">
								<cfif Len(GetCurrentContent.quickLinks) gt 0>
									<cfset _quickLinks_html = CommonCode.correctHTMLtags( GetCurrentContent.quickLinks, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
									<cfset _quickLinks_html = CommonCode.correctHTMLtags( _quickLinks_html, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>
									#_quickLinks_html#
									<cfbreak>
								</cfif>
							</cfloop>
						</cfif>
					</td>
				</tr>
			</table>
		</div>
	</div>
</cfoutput>
