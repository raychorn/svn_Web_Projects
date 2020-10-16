<cfoutput>
	<cfif (Len(function) eq 0) AND (Len(submit) eq 0)>
		<div ID="rightmenu" #_div_styles_rightmenu#>
			<cfif (_LayoutMode eq 1) AND 0>
				<div id='weight-track' class='scrollbar-track' style="top: 40px; left: 0px; position: absolute; width: 10px; margin-left: 0px; margin-top: 0px; border-left-width: 0;">
					<img id="weight-handle" src='#_images_folder#slider_osx.gif' class="scrollbar-handle" style="top: 40px;">
				</div>
				
				<div id='weight-vertical-track' class='scrollbar-track' style="top: 40px; left: 0px; width: 1px; border-bottom-width: 0; position: absolute; height: 100px;">
					<img id="weight-vertical-handle" src='#_images_folder#slider_osx-v.gif' class="scrollbar-handle" style="position: absolute; top: 123px; left: -4px;">
				</div>
			</cfif>

			<cfset _div_js_rightside_onmouseover = "">
			<cfset _div_js_rightside_onmouseout = "">
			<!--- Note: At one point the HTML on the right-side was supposed to be draggable but a bug arose and the quick-fix was to disable the drag-n-drop code for the right-side since the quick-links drag-n-drop worked better. --->
			<cfif (_LayoutMode eq 1) AND 0>
				<cfset _div_js_rightside_onmouseover = "makeElementHilite(document.getElementById('rightside_content')); return false;">
				<cfset _div_js_rightside_onmouseout = "makeElementNoHilite(document.getElementById('rightside_content')); return false;">
			</cfif>
			<div ID="rightside_wrapper">
				<div ID="rightside_content" onmouseover="#_div_js_rightside_onmouseover#" onmouseout="#_div_js_rightside_onmouseout#">
<cfif 0>
					<cfif (_LayoutMode eq 1) AND (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0)>
						<img id="rightside_dragmark" src="#_images_folder#folderclosed.gif" align="left" height="12" onmousedown="makeElementDragable(document.getElementById('rightside_dragmark'), document.getElementById('rightside_content'), document.getElementById('rightmenu_wrapper'), document.getElementById('rightside_wrapper'), document.getElementById('quicklinks_wrapper'), document.getElementById('leftmenu_wrapper')); return false;">
					</cfif>
</cfif>
					<cfif (IsDefined("VerifySecurity_right_side")) AND (VerifySecurity_right_side.recordCount gt 0)>
						<cfif (NOT CommonCode.isStagingView()) AND (IsDefined("_editorAction_symbol")) AND (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.right_side")) AND (GetCurrentContent.recordCount gt 0)>
							<!--- BEGIN: This is the right_side which is under the images on the right-side of the site... --->
							<cfset _editor_title_ = "Click this link to open the WYSIWYG HTML Editor for the Right-Side page of content.">
							<cfif 0>
								<cfset _right_side_editor = CommonCode.makeUserPageEditorLink( _editorAction_symbol, "", _right_side_pageName_symbol, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
							<cfelse>
								<cfset _right_side_editor = CommonCode.makeUserPageEditorLink2( "_rightsidePage_editor_", _editor_title_, _editorAction_symbol, "", _right_side_pageName_symbol, currentPage, _adminMethod, _adminMethod_nopopups, _backUrl_parms)>
							</cfif>
							#_right_side_editor#
							<!--- END! This is the right_side which is under the images on the right-side of the site... --->
						</cfif>
					</cfif>
					<cfif (IsDefined("GetCurrentContent")) AND (IsDefined("GetCurrentContent.right_side")) AND (GetCurrentContent.recordCount gt 0)>
						<cfloop query="GetCurrentContent" startrow="1" endrow="#GetCurrentContent.recordCount#">
							<cfif Len(GetCurrentContent.right_side) gt 0>
								<cfset _right_side_html = CommonCode.correctHTMLtags( GetCurrentContent.right_side, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol)>
								<cfset _right_side_html = CommonCode.correctHTMLtags( _right_side_html, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol)>
								#_right_side_html#
								<cfbreak>
							</cfif>
						</cfloop>
					</cfif>
				</div>
			</div>
			<cfif (_LayoutMode eq 1) AND 0>
				<!--- 
				To Do:	(1) - Make an edit mark (graphic) a user must click-on to begin editing an image.
						(2) - Make an edit mark (graphic) a user much click-on to end editing an image.
						(3) - Update database based on the new image size and refresh page with new values.
				 --->
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					var objH = document.getElementById("weight-track");
					var objHimg = document.getElementById("weight-handle");
					var objV = document.getElementById("weight-vertical-track");
					var objVimg = document.getElementById("weight-vertical-handle");
					var imgObj = document.getElementById("bannerimg");
					var rmObj = document.getElementById("rightmenu");
					var rmwrObj = document.getElementById("rightmenu_wrapper");
					var rswrObj = document.getElementById("rightside_wrapper");
					var sepgObj = document.getElementById("sepg_section");

//					alert(objH + ', ' + objHimg + ', ' + objV + ', ' + imgObj + ', ' + rmObj + ', ' + rmwrObj + ', ' + rswrObj + ', ' + sepgObj);

					if ( (objH != null) && (objV != null) && (imgObj != null) && (rmObj != null) && (rmwrObj != null) && (rswrObj != null) && (sepgObj != null) && (objHimg != null) && (objVimg != null) ) {
						objH.style.width = parseInt(imgObj.width).toString() + "px";
						objV.style.height = parseInt(imgObj.height).toString() + "px";
						var h_top = getStyle(objH, "top");
						var h_left = getStyle(objH, "left");
						var rm_top = getStyle(rmObj, "top");
						var rm_left = getStyle(rmObj, "left");
						var rmwr_top = getStyle(rmwrObj, "top");
						var rmwr_left = getStyle(rmwrObj, "left");
						var sepg_height = getStyle(sepgObj, "height");
						var new_i_top = parseInt(rmwr_top) + parseInt(rm_top);
						var new_i_left = parseInt(rmwr_left) + parseInt(rm_left);
						imgObj.style.top = parseInt(new_i_top).toString() + "px";
						imgObj.style.left = parseInt(new_i_left).toString() + "px";
						var i_top = getStyle(imgObj, "top");
						var i_left = getStyle(imgObj, "left");
						objH.style.top = (0 + parseInt(imgObj.height)).toString() + "px";
						rswrObj.style.top = (parseInt(objHimg.height) + parseInt(imgObj.height)).toString() + "px";
						
						initSliders(imgObj, parseInt(imgObj.width), parseInt(imgObj.height), objHimg, objVimg);
//						alert('i.width = ' + imgObj.width + ', i.height = ' + imgObj.height + ', i_top = ' + i_top + ', i_left = ' + i_left + ', rm_top = ' + rm_top + ', rm_left = ' + rm_left + ', rmwr_top = ' + rmwr_top + ', rmwr_left = ' + rmwr_left + ', h_top = ' + h_top + ', h_left = ' + h_left);
					}
				-->
				</script>
			</cfif>
		</div>
	</cfif>
</cfoutput>
