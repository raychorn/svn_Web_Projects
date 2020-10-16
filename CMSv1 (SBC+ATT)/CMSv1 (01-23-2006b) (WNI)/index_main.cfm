<cfoutput>
	<div id="main">
		<cfif (Len(function) eq 0)>
			<!--- BEGIN: This can be generalized by placing the symbol in a struct with the editor string as the value --->
			<cfif (NOT CommonCode.isStagingView()) AND (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount neq 0) AND (IsDefined("VerifyCurrentPageSecurity")) AND (VerifyCurrentPageSecurity.recordCount gt 0)>
				<cfif (currentPage eq expressProgramsProcPage_symbol)>
					#_expressPage_editor#
				<cfelseif (currentPage eq homePage_symbol)>
					#_homePage_editor#
				<cfelseif (currentPage eq methodPage_symbol)>
					#_methodPage_editor#
				<cfelseif (currentPage eq pmControlsPage_symbol)>
					#_controlsPage_editor#
				<cfelseif (currentPage eq pmHiringProcedurePage_symbol)>
					#_hiringPage_editor#
				<cfelseif (currentPage eq pmRoleDefinitionPage_symbol)>
					#_rolesPage_editor#
				<cfelseif (currentPage eq professionalDevelopmentPage_symbol)>
					#_developmentPage_editor#
				<cfelseif (currentPage eq programMgtProcPage_symbol)>
					#_managementPage_editor#
				<cfelseif (currentPage eq sapxRPMPage_symbol)>
					#_sapPage_editor#
				<cfelseif (currentPage eq aboutPage_symbol)>
					#_aboutPage_editor#
				<cfelseif (currentPage eq faqPage_symbol)>
					#_faqPage_editor#
				<cfelseif (IsDefined("_editorAction_symbol")) AND (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.pageName")) AND (GetCurrentContent.recordCount gt 0)>
					<!--- BEGIN: This must be a page that was added by the user... --->
					<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the '#GetCurrentContent.pageTitle#' (#GetCurrentContent.pageName#) page of content.">
					<cfif 0>
						<cfset _userPage_editor = CommonCode.makeUserPageEditorLink( _editorAction_symbol, GetCurrentContent.pageName, GetCurrentContent.pageName, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
					<cfelse>
						<cfset _userPage_editor = CommonCode.makeUserPageEditorLink2( "_#GetCurrentContent.pageName#_editor_", _editor_title_, _editorAction_symbol, GetCurrentContent.pageName, GetCurrentContent.pageName, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
					</cfif>
					#_userPage_editor#
					<!--- END! This must be a page that was added by the user... --->
				</cfif>
			</cfif>
			<!--- END! This can be generalized by placing the symbol in a struct with the editor string as the value --->
			<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0)>
				<cfloop query="GetCurrentContent" startrow="1" endrow="#GetCurrentContent.recordCount#">
					<cfif Len(GetCurrentContent.html) gt 0>
						<cfset _html_html = CommonCode.correctHTMLtags( GetCurrentContent.html, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
						<cfset _html_html = CommonCode.correctHTMLtags( _html_html, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>
						#_html_html#
					</cfif>
				</cfloop>
			</cfif>
		<cfelseif (_AdminMode eq 1) AND (UCASE(function) eq UCASE(_uploadImageAction_symbol))>
			<cfif (IsDefined("VerifySecurity_UploadImages")) AND (VerifySecurity_UploadImages.recordCount gt 0)>
				<cfset _path = ReplaceNoCase(GetDirectoryFromPath(CGI.CF_TEMPLATE_PATH), "#_AdminSubSysName_symbol#\", "#_images_prime_symbol#\")>
				<cfset _path = ReplaceNoCase(_path, "\#_images_prime_symbol#\", "\#_images_uploaded_symbol#\")>
				
				<cfset _retVal = CommonCode.safely_cfdirectory("CREATE", _path)>
				<!--- BEGIN: This upload function MUST remain here because it requires visability to the form that was posted --->
				<cflock name="#_path#" timeout="10" type="exclusive">
					<cfif (CommonCode.isDomainSBC())>
						<CF_SANFILE action="UPLOAD" filefield="_fileName" destination="#_path#" nameconflict="OVERWRITE" accept="image/gif,image/jpeg,image/jpg,image/pjpeg">
					<cfelse>
						<cffile action="UPLOAD" filefield="_fileName" destination="#_path#" nameconflict="OVERWRITE" accept="image/gif,image/jpeg,image/jpg,image/pjpeg">
					</cfif>
				</cflock>
				<!--- END! This upload function MUST remain here because it requires visability to the form that was posted --->
	
				<cfif (IsDefined("cffile.serverFile"))>
					<h4 align="center"><font color="blue">Uploading image file named "#cffile.serverFile#"...</font></h4>
					<h5 align="center"><font color="blue"><a href="#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#">Click here to proceed...</a></font></h5>
					<center><a id="_click_to_proceed"></a>#RepeatString("&nbsp;", 90)#</center>
				</cfif>
	
				<cfset s_msg = CommonCode.explainUploadOperaton(cffile, _AdminSubSysName_symbol, _images_uploaded_symbol)>
				
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					processUploaderUserFeedback('_click_to_proceed', '#s_msg#');
					// alert('#s_msg#');
					// window.location.href = '#CGI.SCRIPT_NAME##_currentPage_symbol##URLEncodedFormat(currentPage)##Request.next_splashscreen_inhibitor#';
				-->
				</script>
			<cfelse>
				<cfset disabled_image_uploader_title = "Access to the Image Uploader has been revoked at this time by the /Security subsystem.">
			
				<div style="margin-top: 50px; margin-bottom: 50px;">
					<table width="95%" align="center" bgcolor="##FFFFBF" cellpadding="-1" cellspacing="-1">
						<tr>
							<td>
								<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
									<tr>
										<td>
											<span style="font-size: 20px;"><font color="red"><small><b>#disabled_image_uploader_title#</b></small></font></span>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</cfif>
		<cfelseif (_adminMode eq 1)>
			<div id="maintext">
				<cfinclude template="#_adminModePathSuffix#cfinclude_htmlEditor.cfm">
			</div>
		</cfif>
	</div>
</cfoutput>
