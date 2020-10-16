<cfoutput>
	<cfset _footerDivName = "footer">
	<cfif _ReleaseMode neq 0>
		<cfset _footerDivName = "footerRelease">
	</cfif>
	
	<div id="#_footerDivName#">
		<table width="100%" cellpadding="-1" cellspacing="-1">
			<tr>
				<td align="left" valign="top">
					<span style="display: inline; visibility: hidden;"><A HREF="" NAME="footer_top" ID="footer_top">xxx</A></span>
					<div><img src="#_images_folder#your-logo-goes-here.gif" title="Your Logo Goes Here" width="64"></div>
				</td>
				<td>
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
							<cfif (_AdminMode eq 1) AND (NOT is_htmlArea_editor)>
								<cfif (IsDefined("VerifySecurity_footer")) AND (VerifySecurity_footer.recordCount gt 0)>
									<cfif (NOT CommonCode.isStagingView()) AND (IsDefined("_editorAction_symbol")) AND (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.footer")) AND (GetCurrentContent.recordCount gt 0)>
										<!--- BEGIN: This is the footer which is in the footer of the site... --->
										<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Footer page of content.">
										<cfif 0>
											<cfset _footer_editor = CommonCode.makeUserPageEditorLink( _editorAction_symbol, "", _footer_pageName_symbol, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
										<cfelse>
											<cfset _footer_editor = CommonCode.makeUserPageEditorLink2( "_footerPage_editor_", _editor_title_, _editorAction_symbol, "", _footer_pageName_symbol, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
										</cfif>
										<td align="left" valign="top">
											#_footer_editor#
										</td>
										<!--- END! This is the footer which is in the footer of the site... --->
									</cfif>
								</cfif>
							</cfif>
							<td align="left" valign="top">
								<table cellpadding="-1" cellspacing="-1">
									<tr>
										<td colspan="2">
											<span style="display: inline; visibility: hidden;"><a href="" name="positional_delayed_tooltips4" id="positional_delayed_tooltips4">xxx</a></span>
										</td>
									</tr>
									<tr>
										<td>
											<cfif (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.footer")) AND (GetCurrentContent.recordCount gt 0)>
												<cfloop query="GetCurrentContent" startrow="1" endrow="#GetCurrentContent.recordCount#">
													<cfif Len(GetCurrentContent.footer) gt 0>
														<cfset _footer_html = CommonCode.correctHTMLtags( GetCurrentContent.footer, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
														<cfset _footer_html = CommonCode.correctHTMLtags( _footer_html, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>
														#_footer_html#
														<cfbreak>
													</cfif>
												</cfloop>
											</cfif>
										</td>
										<td>
											<span style="display: inline; visibility: hidden;"><a href="" name="positional_delayed_tooltips3" id="positional_delayed_tooltips3">xxx</a></span>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="left" valign="top" colspan="2">
								<div id="restricted">
									<p align="justify">
										<font size="1"><small><strong>RESTRICTED - PROPRIETARY INFORMATION</strong></small></font>
										<font size="1"><small>
										The Information contained herein is for use only by authorized employees of <i>Your Company Name</i>,
										and authorized Affiliates thereof, 
										and is not for general distribution within or outside the respective companies.
										</small></font>
									</p>
								</div>
							</td>
						</tr>
					</table>
				</td>
				<td align="right" valign="top">
					<cfif (IsDefined("GetCurrentContent.rdate")) AND (IsDate(GetCurrentContent.rdate))>
						#commonCode.divUpdates2(GetCurrentContent.rdate)#
					<cfelse>
						#commonCode.divUpdates("")#
					</cfif>
				</td>
			</tr>
		</table>
	</div><!--End footer - Bottom Portion-->
</cfoutput>
