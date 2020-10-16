<cfoutput>
	<table width="990px" cellpadding="-1" cellspacing="-1">
		<tr>
			<td>
				<div id="header">
					<div id="welcome">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									<h2><NOBR>SBC PM Professionalism - Layout</NOBR></h2>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td bgcolor="##c0c0c0" height="30px">
			</td>
		</tr>
		<tr>
			<td>
				<div id="maintext">
					<!--- BEGIN: Tabbed Interface goes here... --->
					<div id="TabSystem1" class="content">
						<div class="tabs">
							<cfset _disp_tabNum = 1>
							<cfset _displayableNum = 1>
							<cfset _displaying_tabNum = 1>
							
							<cfset _class = "tab">
							<cfif (_displaying_tabNum eq 1)>
								<cfset _class = "tab tabActive">
							</cfif>

							<cfset _display = "inline">
							<cfif (_disp_tabNum gt _num_tabs_max)>
								<cfset _display = "none">
							</cfif>

							<cfset _href_data = -1>
							<cfset _title_data = "">
							<cfset _anchor_caption = "">
							
							<div id="cell_tab#_disp_tabNum#" style="display: #_display#;">
								<a href="###_href_data#" accesskey="#_disp_tabNum#" tabindex="#_disp_tabNum#" id="tab#_disp_tabNum#" title="#_title_data#" class="#_class#">
									&nbsp;<font size="1"><small>#_anchor_caption#&nbsp;(#_disp_tabNum#/#_displayableNum#)</small></font>
								</a>
							</div>
						</div>
						#CommonCode.div_loadingContent("Layout Data")#

						<div id="content#_disp_tabNum#" class="content" style="display: none;">
							bool_missing_draft_condition = [#bool_missing_draft_condition#]
						</div>
				</div>
				#RepeatString("<BR>", 25)#
			</td>
		</tr>
		<tr>
			<td bgcolor="##c0c0c0">
				<hr width="100%" size="1" color="##0000FF">
			</td>
		</tr>
	</table>
</cfoutput>
