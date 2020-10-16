<!--- This site layout spec is also known as cfinclude_siteLayout0.cfm
	Additional site layout specs can be added very easily, 
	just make sure the layout id from the layout table (yet to be defined),
	appears in the name of the layout spec as follows: 
		layout number 1 must be in the file named cfinclude_siteLayout1.cfm
		layout number 99 must be in the file named cfinclude_siteLayout99.cfm
		
	For now, layout specs must be created by a ColdFusion programmer with the
	appropriate entries in the correct tables so the system will use them, as needed.
	
	Each layout spec must include a graphical representation, used loosely here, of
	what the layout looks like so the /Layout SubSystem can show the user what the
	layout looks like.  Perhaps later on, time permitting, the "graphical representation"
	may even become a graphical image.  Perhaps someday, time permitting, the /Layout SubSystem
	might even be smart enough to do this for the user in addition to allowing ad-hoc layout
	specs to be created with no programming effort.
 --->
<cfset _layout_spec_width_full = 990>
<cfset _layout_spec_menu_width_full = 162>
<cfset _layout_spec_right_width_full = 190>

<cfset _layout_spec_row_height = 40>

<cfset _layout_spec_width = 400>
<cfset _layout_spec_menu_width = Int(_layout_spec_width * Int(_layout_spec_menu_width_full / _layout_spec_width_full))>
<cfset _layout_spec_right_width = Int(_layout_spec_width * Int(_layout_spec_right_width_full / _layout_spec_width_full))>
<cfset _layout_spec_content_width = _layout_spec_width - (_layout_spec_menu_width + _layout_spec_right_width)>

<cfset _layout_spec_includes_pix = "False">
<cfif (LCase(_cfapplication_name) eq LCase(const_cfapplication_name_default_symbol))>
	<cfset _layout_spec_includes_pix = "True">
</cfif>

<cfif (_layout_spec_includes_pix)>
	<cfset _layout_spec_codes = '
	<table {Site,width=990px}>
	<tr>
		<td {Cell,width=100%,height=40px,id=cell_image1,background=images/header_bg.jpg}>
			<table {Table,width=100%}>
			<tr>
				<td {Header,width=50%,align=left,valign=top,height=40px}>
					{Header_Label, =[Header]}
				</td>
				<td {Marquee,width=50%,align=left,valign=top,height=40px}>
					{Marquee_Label, =[Marquee]}
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td {MenuBar,width=100%,height=20px}>
			{MenuBar_Label, =[MenuBar]}
		</td>
	</tr>
	<tr>
		<td {Cell,width=100%,height=40px}>
			<table {Table,width=100%,height=100%,border=1}>
			<tr>
				<td {Cell,width=162px,valign=top,height=40px}>
					<table {Table,width=100%,height=100%,border=0}>
						<tr>
							<td {Menu,width=100%,height=50%,valign=top}>
								{Menu_Label, =[Menu]}
							</td>
						</tr>
						<tr>
							<td {QuickLinks,width=100%,height=50%,valign=bottom}>
								{QuickLinks_Label, =[QuickLinks]}
							</td>
						</tr>
					</table>
				</td>
				<td {Content,width=(990 - (162 + 190))px,valign=top}>
				{Content_Label, =[Content]}
				</td>
				<td {Cell,width=190px,height=40px,valign=top}>
					<table {Table,width=100%,height=100%,border=0}>
						<tr>
							<td {Pix,width=100%,height=50%,valign=top}>
								{Pix_Label, =[Pix]}
							</td>
						</tr>
						<tr>
							<td {RightSide,height=50%,valign=top}>
								{RightSide_Label, =[RightSide]}
							</td>
						</tr>
					</table>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td {Footer,width=100%,height=40px}>
			{Footer_Label, =[Footer]}
		</td>
	</tr>
	</table>
	'>
<cfelse>
	<cfset _layout_spec_codes = '
	<table {Site,width=990px}>
	<tr>
		<td {Cell,width=100%,height=40px,id=cell_image1,background=images/header_bg.jpg}>
			<table {Table,width=100%}>
			<tr>
				<td {Header,width=50%,align=left,valign=top,height=40px}>
					{Header_Label, =[Header]}
				</td>
				<td {Marquee,width=50%,align=left,valign=top,height=40px}>
					{Marquee_Label, =[Marquee]}
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td {MenuBar,width=100%,height=20px}>
			{MenuBar_Label, =[MenuBar]}
		</td>
	</tr>
	<tr>
		<td {Cell,width=100%,height=40px}>
			<table {Table,width=100%,height=100%,border=1}>
			<tr>
				<td {Cell,width=162px,valign=top,height=40px}>
					<table {Table,width=100%,height=100%,border=0}>
						<tr>
							<td {Menu,width=100%,height=50%,valign=top}>
								{Menu_Label, =[Menu]}
							</td>
						</tr>
						<tr>
							<td {QuickLinks,width=100%,height=50%,valign=bottom}>
								{QuickLinks_Label, =[QuickLinks]}
							</td>
						</tr>
					</table>
				</td>
				<td {Content,width=(990 - (162 + 190))px,valign=top}>
				{Content_Label, =[Content]}
				</td>
				<td {Cell,width=190px,height=40px,valign=top}>
					<table {Table,width=100%,height=100%,border=0}>
						<tr>
							<td {RightSide,height=50%,valign=top}>
								{RightSide_Label, =[RightSide]}
							</td>
						</tr>
					</table>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td {Footer,width=100%,height=40px}>
			{Footer_Label, =[Footer]}
		</td>
	</tr>
	</table>
	'>
</cfif>

<cfset _layout_spec_graphic = '
'>

<!--- BEGIN: After setting the defaults in case there is no layout in the database we grab the one from the database, if possible --->
		<cfif (IsDefined("GetCurrentContent.layid")) AND (Len(Trim(GetCurrentContent.layid)) gt 0) AND (IsNumeric(GetCurrentContent.layid))>
			<cfset _layout_id = GetCurrentContent.layid>
		</cfif>
		<cfif (IsDefined("GetCurrentContent.layoutName")) AND (Len(Trim(GetCurrentContent.layoutName)) gt 0)>
			<cfset _layoutName = GetCurrentContent.layoutName>
		</cfif>
		<cfif (IsDefined("GetCurrentContent.layoutSpec")) AND (Len(Trim(GetCurrentContent.layoutSpec)) gt 0)>
			<cfset _layout_spec_codes = URLDecode(GetCurrentContent.layoutSpec)>
		</cfif>
<!--- END! After setting the defaults in case there is no layout in the database we grab the one from the database, if possible --->

<cfset _layout_spec_graphic2 = CommonCode.makeSiteLayoutSpecFromCodes(_layout_spec_codes, "True", 'width="400px"')>

<cfoutput>
	<cfif (_ReleaseMode eq 0) AND (_SecurityMode eq 0) AND (_LayoutMode eq 0)>
		<!--- Normal site view --->
		<cfif 1>
			<cfset _html_ = CommonCode.makeSiteLayoutSpecFromCodes(_layout_spec_codes, "False", 'width="990px"')>

			<cfset _i = -1>
			<cfset _j = -1>
			<cfset _pos = -1>
			<cfset _template_name = ''>

			<cfset _pos = 1>  <!--- beginning of the string - this moves through the string... --->
			<cfloop condition="(_pos lte Len(_html_))">
				<cfset _i = FindNoCase('~', _html_, _pos)>
				<cfif (_i gt 0)>
					<cfset _j = FindNoCase('~', _html_, _i + 1)>
					<cfif (_j gt _i)>
						#Mid(_html_, _pos, (_i - _pos))#
						<cfset _template_name = Mid(_html_, _i + 1, (_j - _i) - 1)>
						<cfif 1>
							<cfinclude template="#_template_name#">
						<cfelse>
							(#_template_name#)
						</cfif>
						<cfset _pos = _j + 1>
					</cfif>
				<cfelse>
					#Mid(_html_, _pos, (Len(_html_) - _pos))#
					<cfbreak>
				</cfif>
			</cfloop>
		<cfelse>
			<table width="990px" cellpadding="-1" cellspacing="-1">
				<tr>
					<td>
						<cfinclude template="layout_header.cfm">
					</td>
				</tr>
				<tr>
					<td>
						<cfinclude template="layout_menubar.cfm">
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td width="162px" valign="top" align="left">
									<table width="100%" cellpadding="-1" cellspacing="-1">
										<tr>
											<td>
												<cfinclude template="layout_menu.cfm">
											</td>
										</tr>
										<tr>
											<td>
												<cfinclude template="layout_quicklinks.cfm">
											</td>
										</tr>
									</table>
								</td>
								<cfset _main_content_width = "#(990 - (160 + 190))#px">
								<cfset _main_content_style = 'style="border-left: 1px solid ##999; border-right: 1px solid ##999;"'>
								<cfif (_ReleaseMode eq 1) OR (_SecurityMode eq 1)>
									<cfset _main_content_width = "100%">
									<cfset _main_content_style = "">
								</cfif>
								<td width="#_main_content_width#" valign="top" align="left" #_main_content_style#>
									<table width="100%" cellpadding="1" cellspacing="1">
										<tr>
											<td>
												<cfinclude template="layout_content.cfm">
											</td>
										</tr>
									</table>
								</td>
								<td width="190px" valign="top" align="left">
									<table width="100%" cellpadding="-1" cellspacing="-1">
										<tr>
											<td>
												<cfinclude template="layout_pix.cfm">
											</td>
										</tr>
										<tr>
											<td>
												<cfinclude template="layout_RightSide.cfm">
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<cfinclude template="layout_footer.cfm">
					</td>
				</tr>
			</table>
		</cfif>
	<cfelse>
		<!--- SubSystem view --->
		<table width="990px" cellpadding="-1" cellspacing="-1">
			<tr>
				<td>
					<cfinclude template="layout_header.cfm">
				</td>
			</tr>
			<tr>
				<td>
					<cfinclude template="layout_menubar.cfm">
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" cellpadding="-1" cellspacing="-1">
						<tr>
							<cfset _main_content_width = "#(990 - (160 + 190))#px">
							<cfset _main_content_style = 'style="border-left: 1px solid ##999; border-right: 1px solid ##999;"'>
							<cfif (_ReleaseMode eq 1) OR (_SecurityMode eq 1)>
								<cfset _main_content_width = "100%">
								<cfset _main_content_style = "">
							</cfif>
							<td width="#_main_content_width#" valign="top" align="left" #_main_content_style#>
								<table width="100%" cellpadding="1" cellspacing="1">
									<tr>
										<td>
											<cfif (_ReleaseMode eq 1)>
												<cfinclude template="#_releaseModePathSuffix#cfinclude_releaseEditor.cfm">
											<cfelseif (_SecurityMode eq 1)>
												<cfinclude template="#_securityModePathSuffix#cfinclude_securityEditor.cfm">
											<cfelseif (_LayoutMode eq 1)>
												<cfinclude template="#_layoutModePathSuffix#cfinclude_layoutEditor.cfm">
											</cfif>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<cfinclude template="layout_footer.cfm">
				</td>
			</tr>
		</table>
	</cfif>
</cfoutput>
