<cfoutput>
	<div id="header">
		<cfif (_LayoutMode eq 0) AND (NOT is_htmlArea_editor)>
			<div id="sepg_section">
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td valign="top">
							<cfif (_AdminMode eq 1) AND (IsDefined("VerifySecurity_sepg_section")) AND (VerifySecurity_sepg_section.recordCount gt 0)>
								<cfif (NOT CommonCode.isStagingView()) AND (IsDefined("_editorAction_symbol")) AND (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.sepg_section")) AND (GetCurrentContent.recordCount gt 0)>
									<!--- BEGIN: This is the sepg_section which is in the header of the site... --->
									<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Header page of content.">
									<cfif 0>
										<cfset _sepg_section_editor = CommonCode.makeUserPageEditorLink( _editorAction_symbol, "", _sepg_section_pageName_symbol, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
									<cfelse>
										<cfset _sepg_section_editor = CommonCode.makeUserPageEditorLink2( "_headerPage_editor_", _editor_title_, _editorAction_symbol, "", _sepg_section_pageName_symbol, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
									</cfif>
									#_sepg_section_editor#
									<!--- END! This is the sepg_section which is in the header of the site... --->
								</cfif>
							<cfelseif (_ReleaseMode eq 0) AND (_SecurityMode eq 0)>
								<br>
							</cfif>
							<cfif (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.sepg_section")) AND (GetCurrentContent.recordCount gt 0)>
								<cfloop query="GetCurrentContent" startrow="1" endrow="#GetCurrentContent.recordCount#">
									<cfif Len(GetCurrentContent.sepg_section) gt 0>
										<cfset _sepg_section_html = CommonCode.correctHTMLtags( GetCurrentContent.sepg_section, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
										<cfset _sepg_section_html = CommonCode.correctHTMLtags( _sepg_section_html, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>
										#_sepg_section_html#
										<cfbreak>
									</cfif>
								</cfloop>
							</cfif>
						</td>
					</tr>
				</table>
			</div>
		</cfif>
	</div>
		<cfif (_ReleaseMode eq 1) OR (CommonCode.is_htmlArea_editor())>
			<script type="text/javascript"><!--
				if (document.cookie && (document.documentElement.style || document.body.style)) {
					document.write("<div id=\"myTextSize\">Adjust Text Size:&nbsp;");
					document.write("<a onclick=\"myTextSize('decr');\" title=\"Shrink text size (-5%)\">[&ndash;]</a>");
					document.write(" <a onclick=\"myTextSize('reset');\" title=\"Normal text size\">[N]</a> ");
					document.write("<a onclick=\"myTextSize('incr');\" title=\"Enlarge text size (+5%)\">[+]</a>");
					document.write("</div>");
				} // -->
			</script>
		</cfif>
	<!--End header - Top Portion-->
</cfoutput>
