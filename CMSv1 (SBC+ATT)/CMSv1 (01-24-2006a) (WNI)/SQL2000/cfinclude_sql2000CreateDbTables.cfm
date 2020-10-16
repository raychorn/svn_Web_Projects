<cfoutput>
	<tr>
		<td>
			<table width="80%" align="center" cellpadding="-1" cellspacing="-1">
				<tr>
					<td bgcolor="##c0c0c0">
						<b>Creating Tables for an empty CMS 1.0 Database...</b><br><br>
					</td>
				</tr>
				<tr>
					<td>
						<table width="80%" align="center" cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									<b>(1 of 26) Creating the #_sql2000_wizard_table_prefix#ContentList Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_ContentList(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable1', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>

								</td>
								<td>
									<b>(2 of 26) Creating the #_sql2000_wizard_table_prefix#ContentSecurity Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_ContentSecurity(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable2', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>

								</td>
								<td>
									<b>(3 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicHTMLContent Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicHTMLContent(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable3', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>

								</td>
								<td>
									<b>(4 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicHTMLfooter Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicHTMLfooter(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable4', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>

								</td>
								<td>
									<b>(5 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicHTMLmenu Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicHTMLmenu(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable5', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>

								</td>
							</tr>
							<tr>
								<td>
									<b>(6 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicHTMLpad Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicHTMLpad(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable6', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(7 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicHTMLright_side Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicHTMLright_side(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable7', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(8 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicHTMLsepg_links Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicHTMLsepg_links(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable8', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(9 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicHTMLsepg_section Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicHTMLsepg_section(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable9', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(10 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicLayoutSpecification Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicLayoutSpecification(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable10', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
							</tr>
							<tr>
								<td>
									<b>(11 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicPageManagement Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicPageManagement(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable11', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(12 of 26) Creating the #_sql2000_wizard_table_prefix#DynamicSiteManagement Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_DynamicSiteManagement(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable12', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(13 of 26) Creating the #_sql2000_wizard_table_prefix#LayoutManagement Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_LayoutManagement(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable13', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(14 of 26) Creating the #_sql2000_wizard_table_prefix#MarqueeScrollerData Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_MarqueeScrollerData(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable14', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(15 of 26) Creating the #_sql2000_wizard_table_prefix#MenuEditorAccess Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_MenuEditorAccess(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable15', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
							</tr>
							<tr>
								<td>
									<b>(16 of 26) Creating the #_sql2000_wizard_table_prefix#ReleaseActivityLog Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_ReleaseActivityLog(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable16', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(17 of 26) Creating the #_sql2000_wizard_table_prefix#ReleaseManagement Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_ReleaseManagement(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable17', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(18 of 26) Creating the #_sql2000_wizard_table_prefix#ReleaseManagementComments Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_ReleaseManagementComments(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable18', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(19 of 26) Creating the #_sql2000_wizard_table_prefix#SubsystemList Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_SubsystemList(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable19', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(20 of 26) Creating the #_sql2000_wizard_table_prefix#SubsystemSecurity Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_SubsystemSecurity(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable20', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
							</tr>
							<tr>
								<td>
									<b>(21 of 26) Creating the #_sql2000_wizard_table_prefix#UserSecurity Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_UserSecurity(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable21', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(22 of 26) Establishing Constraints for the #_sql2000_wizard_table_prefix#ContentList Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_Constraints_ContentList(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable22', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(23 of 26) Establishing Constraints for the #_sql2000_wizard_table_prefix#DynamicSiteManagement Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_Constraints_DynamicSiteManagement(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable23', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(24 of 26) Establishing Constraints for the #_sql2000_wizard_table_prefix#SubsystemList Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_Constraints_SubsystemList(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable24', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									<b>(25 of 26) Establishing Constraints for the #_sql2000_wizard_table_prefix#UserSecurity Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_Constraints_UserSecurity(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable25', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
							</tr>
							<tr>
								<td>
									<b>(26 of 26) Establishing Constraints for the #_sql2000_wizard_table_prefix#ReleaseManagement Table...</b><br><br>
									<cfset _SQL_statement = SQL2000.ddl_Constraints_ReleaseManagement(_dbOwner, _sql2000_wizard_table_prefix)>

									<cfscript>
										SQL2000WizardCreateTable('SQL2000WizardCreateTable26', _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement);
									</cfscript>
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									&nbsp;
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!--- +++ --->
				<tr>
					<td bgcolor="##c0c0c0">
						<b>Creating Data Elements for an empty CMS 1.0 Database...</b><br><br>
					</td>
				</tr>
				<tr>
					<td>
						<table width="80%" align="center" cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									<b>(1 of 10) Creating Data Elements for the #_sql2000_wizard_table_prefix#UserSecurity Table...</b><br><br>
									<CFQUERY username='#_sql2000_wizard_dsn_username#' password='#_sql2000_wizard_dsn_password#' name="SQL2000WizardCreateData1" datasource="#_sql2000_wizard_dsn#">
										INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#UserSecurity
										        (userid,user_name,user_phone)
										VALUES  ('#_AUTH_USER#',' ',' ')
									</cfquery>
								</td>
								<td>
									<b>(2 of 10) Creating Data Elements for the #_sql2000_wizard_table_prefix#SubsystemList Table...</b><br><br>
									<cfscript>
										_list_ = Request.subsystem_list_;
										for (_list_i = 1; _list_i lte ListLen(_list_, ','); _list_i = _list_i + 1) {
											_list_tok = GetToken(_list_, _list_i, ',');
											_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#SubsystemList (subsystem_name) VALUES  ('#_list_tok#')";
											SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
										}
									</cfscript>
								</td>
								<td>
									<b>(3 of 10) Creating Data Elements for the #_sql2000_wizard_table_prefix#SubsystemSecurity Table...</b><br><br>
									<cfscript>
										_SQL_statement = "SELECT id FROM [#_dbOwner#].#_sql2000_wizard_table_prefix#UserSecurity WHERE (userid IS NOT NULL)";
										GetUIDs = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
										
										if (IsQuery(GetUIDs)) {
											if (GetUIDs.recordCount gt 0) {
												_SQL_statement = "SELECT id FROM [#_dbOwner#].#_sql2000_wizard_table_prefix#SubsystemList WHERE (subsystem_name IS NOT NULL) ORDER BY subsystem_name";
												GetSIDs = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
	
												if (IsQuery(GetSIDs)) {
													if (GetSIDs.recordCount gt 0) {
														for (GetUIDs_i = 1; GetUIDs_i lte GetUIDs.recordCount; GetUIDs_i = GetUIDs_i + 1) {
															GetUIDs_data = GetUIDs.id[GetUIDs_i];
															for (GetSIDs_i = 1; GetSIDs_i lte GetSIDs.recordCount; GetSIDs_i = GetSIDs_i + 1) {
																GetSIDs_data = GetSIDs.id[GetSIDs_i];
																_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#SubsystemSecurity (sid,uid) VALUES  (#GetSIDs_data#,#GetUIDs_data#)";
																SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
															}
														}
													}
												}
											}
										}
									</cfscript>
								</td>
							</tr>
							<tr>
								<td>
									<b>(4 of 10) Creating Data Elements for the #_sql2000_wizard_table_prefix#ContentList Table...</b><br><br>
									<cfscript>
										_list_ = "[menuColor],[menuTextColor],[site-css],menuPage,quickLinks,sepg_section,sepg_links,right_side,footer,[menuColor],[menuTextColor],homePage";
										for (_list_i = 1; _list_i lte ListLen(_list_, ','); _list_i = _list_i + 1) {
											_list_tok = GetToken(_list_, _list_i, ',');
											_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#ContentList (pageName) VALUES  ('#_list_tok#')";
											SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
										}
									</cfscript>
								</td>
								<td>
									<b>(5 of 10) Creating Data Elements for the #_sql2000_wizard_table_prefix#ContentSecurity Table...</b><br><br>
									<cfscript>
										if (IsQuery(GetUIDs)) {
											if (GetUIDs.recordCount gt 0) {
												_SQL_statement = "SELECT id FROM [#_dbOwner#].#_sql2000_wizard_table_prefix#ContentList WHERE (pageName IS NOT NULL) ORDER BY pageName";
												GetPIDs = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
	
												if (IsQuery(GetPIDs)) {
													if (GetPIDs.recordCount gt 0) {
														for (GetUIDs_i = 1; GetUIDs_i lte GetUIDs.recordCount; GetUIDs_i = GetUIDs_i + 1) {
															GetUIDs_data = GetUIDs.id[GetUIDs_i];
															for (GetPIDs_i = 1; GetPIDs_i lte GetPIDs.recordCount; GetPIDs_i = GetPIDs_i + 1) {
																GetPIDs_data = GetPIDs.id[GetPIDs_i];
																_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#ContentSecurity (pid,uid) VALUES  (#GetPIDs_data#,#GetUIDs_data#)";
																SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
															}
														}
													}
												}
											}
										}
									</cfscript>
								</td>
								<td>
									<b>(6 of 10) Creating Data Elements for the #_sql2000_wizard_table_prefix#ReleaseManagement Table...</b><br><br>
									<cfscript>
										if (IsQuery(GetUIDs)) {
											if (GetUIDs.recordCount gt 0) {
												_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#ReleaseManagement (releaseNumber, uid, layout_id, devDateTime, stageDateTime, prodDateTime, archDateTime, comments) VALUES (1,#GetUIDs.id#,-1,NULL,NULL,#CreateODBCDateTime(Now())#,NULL,'Default Release created by the SQL2000 Subsystem.')";
												SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
											}
										}
									</cfscript>
								</td>
							</tr>
							<tr>
								<td>
									<b>(7 of 10) Creating Data Elements for the LayoutManagement Table...</b><br><br>
<cfset _defaultLayoutSpec = "
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
">
<cfset _sampleLayoutSpec1 = "
<table {Site}>
<tr>
<td {Header,width=100%,height=40px}>
{Header_Label, =[Header]}
</td>
</tr>
<tr>
<td {Cell,width=100%,height=40px}>
<table {Table,width=100%}>
<tr>
<td {RightSide,width=190px}>
{RightSide_Label, =[RightSide]}
</td>
<td {Content,width=(990 - (162 + 190))px}>
{Content_Label, =[Content]}
</td>
<td {Menu,width=162px}>
{Menu_Label, =[Menu]}
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
">
<cfset _sampleLayoutSpec2 = "
<table {Site}>
<tr>
<td {Header,width=100%,height=40px}>
{Header_Label, =[Header]}
</td>
</tr>
<tr>
<td {Footer,width=100%,height=40px}>
{Footer_Label, =[Footer]}
</td>
</tr>
<tr>
<td {Cell,width=100%,height=40px}>
<table {Table,width=100%}>
<tr>
<td {RightSide,width=190px}>
{RightSide_Label, =[RightSide]}
</td>
<td {Content,width=(990 - (162 + 190))px}>
{Content_Label, =[Content]}
</td>
<td {Menu,width=162px}>
{Menu_Label, =[Menu]}
</td>
</tr>
</table>
</td>
</tr>
</table>
">
<cfset _sampleLayoutSpec3 = "
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
">
									<cfscript>
										_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#LayoutManagement (layout_name, layout_spec) VALUES ('Default+Layout','#URLEncodedFormat(_defaultLayoutSpec)#')";
										SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));

										_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#LayoutManagement (layout_name, layout_spec) VALUES ('Sample+Layout+Spec+1','#URLEncodedFormat(_sampleLayoutSpec1)#')";
										SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));

										_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#LayoutManagement (layout_name, layout_spec) VALUES ('Sample+Layout+Spec+2','#URLEncodedFormat(_sampleLayoutSpec2)#')";
										SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));

										_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#LayoutManagement (layout_name, layout_spec) VALUES ('Sample+Layout+Spec+3','#URLEncodedFormat(_sampleLayoutSpec3)#')";
										SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
									</cfscript>
								</td>
								<td>
									<b>(8 of 10) Creating Data Elements for the #_sql2000_wizard_table_prefix#DynamicPageManagement Table...</b><br><br>
									<cfscript>
										_SQL_statement = "SELECT pageName FROM [#_dbOwner#].#_sql2000_wizard_table_prefix#ContentList ORDER BY pageName";
										GetPAGEs = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
	
										_SQL_statement = "SELECT id FROM [#_dbOwner#].#_sql2000_wizard_table_prefix#ReleaseManagement WHERE (devDateTime IS NULL) AND (stageDateTime IS NULL) AND (prodDateTime IS NOT NULL) AND (archDateTime IS NULL)";
										GetRIDs = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
	
										if (IsQuery(GetPAGEs)) {
											if (GetPAGEs.recordCount gt 0) {
												if (IsQuery(GetRIDs)) {
													if (GetRIDs.recordCount eq 1) {
														for (GetPAGEs_i = 1; GetPAGEs_i lte GetPAGEs.recordCount; GetPAGEs_i = GetPAGEs_i + 1) {
															GetPAGEs_data = GetPAGEs.pageName[GetPAGEs_i];
	
															_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#DynamicPageManagement (pageId, pageName, PageTitle, versionDateTime, rid) VALUES (#GetPAGEs_i#,'#GetPAGEs_data#','[#GetPAGEs_data#]',NULL,#GetRIDs.id#)";
															SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
														}
													}
												}
											}
										}
									</cfscript>
								</td>
								<td>
									<b>(9 of 10) Creating Data Elements for the #_sql2000_wizard_table_prefix#DynamicHTMLmenu Table...</b><br><br>
									<cfscript>
										if (IsQuery(GetRIDs)) {
											if (GetRIDs.recordCount eq 1) {
												_SQL_statement = "SELECT pageId FROM [#_dbOwner#].#_sql2000_wizard_table_prefix#DynamicPageManagement WHERE (pageName = 'menuPage') AND (rid = #GetRIDs.id#)";
												GetPIDs = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
	
												if (IsQuery(GetPIDs)) {
													if (GetPIDs.recordCount eq 1) {
														_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#DynamicHTMLmenu (pageId, html, rid) VALUES (#GetPIDs.pageId#,'%23| |submenu,%2Fadmin%2Findex.cfm%3FcurrentPage%3Dplaceholder|_top|placeholder,##-1,http%3A%2F%2Fcoldfusion.servehttp.com%2Frayhorn|_new|placeholder, ,##-1',#GetRIDs.id#)";
														SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
													}
												}
											}
										}
									</cfscript>
								</td>
							</tr>
							<tr>
								<td>
									<b>(10 of 10) Creating Data Elements for the #_sql2000_wizard_table_prefix#ReleaseActivityLog Table...</b><br><br>
									<cfscript>
										if (IsQuery(GetRIDs)) {
											if (GetRIDs.recordCount eq 1) {
												_SQL_statement = "INSERT INTO [#_dbOwner#].#_sql2000_wizard_table_prefix#ReleaseActivityLog (rid, dateTime, comments) VALUES (#GetRIDs.id#,#CreateODBCDateTime(Now())#,'Default Comments create by the SQL2000 Subsystem.')";
												SetDataElements = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
											}
										}
									</cfscript>
								</td>
								<td>
									&nbsp;
								</td>
								<td>
									&nbsp;
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</cfoutput>

