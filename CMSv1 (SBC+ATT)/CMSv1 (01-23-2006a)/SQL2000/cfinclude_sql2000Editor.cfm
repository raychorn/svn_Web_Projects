<cfset _num_tabs_max = 4>
<cfset _tabs_js_path = "../components/tabs.js/">

<cfoutput>
	<table width="990px" cellpadding="-1" cellspacing="-1">
		<tr>
			<td>
				<div id="header">
					<div id="welcome">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									<table width="100%" cellpadding="-1" cellspacing="-1">
										<tr>
											<td>
												<h2><NOBR>SBC #Request._site_name#</NOBR></h2>
											</td>
											<td>
												<h4><NOBR>SQL2000 - SQL Server 2000 Database Wizard</NOBR></h4>
											</td>
										</tr>
									</table>
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

							<cfif (_sql2000_wizard_i eq 1)>
								<cfset _href_data = _disp_tabNum>
								<cfset _title_data = "Define Sub-Site">
								<cfset _anchor_caption = "Define Sub-Site">
								
								<div id="cell_tab#_disp_tabNum#" style="display: #_display#;">
									<a href="###_href_data#" accesskey="#_disp_tabNum#" tabindex="#_disp_tabNum#" id="tab#_disp_tabNum#" title="#_title_data#" class="#_class#">
										&nbsp;<font size="1"><small>#_anchor_caption#</small></font> <!--- &nbsp;(#_disp_tabNum#/#_displayableNum#) --->
									</a>
								</div>
							</cfif>

							<cfif (Len(subsite_name) eq 0)>
								<cfset _disp_tabNum = IncrementValue(_disp_tabNum)>
	
								<cfset _href_data = _disp_tabNum>
								<cfset _title_data = "Define Primary-Site">
								<cfset _anchor_caption = "Define Primary-Site">
								
								<div id="cell_tab#_disp_tabNum#" style="display: #_display#;">
									<a href="###_href_data#" accesskey="#_disp_tabNum#" tabindex="#_disp_tabNum#" id="tab#_disp_tabNum#" title="#_title_data#" class="#_class#">
										&nbsp;<font size="1"><small>#_anchor_caption#</small></font> <!--- &nbsp;(#_disp_tabNum#/#_displayableNum#) --->
									</a>
								</div>
							</cfif>
						</div>
						
						#CommonCode.div_loadingContent("SQL2000 Data")#

						<cfset _disp_tabNum = 1>

						<cfif (_sql2000_wizard_i eq 1)>
							<div id="content#_disp_tabNum#" class="content" style="display: none;">
								<cfinclude template="cfinclude_sql2000Editor_SubSite.cfm">
							</div>
						</cfif>

						<cfif (Len(subsite_name) eq 0)>
							<cfset _disp_tabNum = IncrementValue(_disp_tabNum)>
	
							<div id="content#_disp_tabNum#" class="content" style="display: none;">
								<cfinclude template="cfinclude_sql2000Editor_Wizard.cfm">
							</div>
						</cfif>
				</div>
<cfif (CommonCode.isServerLocal()) AND 0>
	#RepeatString("<BR>", 40)#
	_sql2000_wizard_i = [#_sql2000_wizard_i#]<br>
	_sql2000_wizard_dsn = [#_sql2000_wizard_dsn#]<br>
	_sql2000_wizard_dsn_username = [#_sql2000_wizard_dsn_username#]<br>
	_sql2000_wizard_dsn_password = [#_sql2000_wizard_dsn_password#]<br>
	_sql2000_wizard_table_prefix = [#_sql2000_wizard_table_prefix#]<br>
	bool_missing_draft_condition = [#bool_missing_draft_condition#]<br>
</cfif>
			</td>
		</tr>
		<tr>
			<td bgcolor="##c0c0c0">
				<hr width="100%" size="1" color="##0000FF">
			</td>
		</tr>
	</table>
	
</cfoutput>
