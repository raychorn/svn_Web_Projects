<cfoutput>
	<cfscript>
		_sql2000_wizard_allow_processing_wizard = true;
	</cfscript>

	<form>
		<table width="80%" align="center" cellpadding="-1" cellspacing="-1">
			<tr>
				<td>
				</td>
			</tr>
			<cfif (Len(subsite_name) eq 0)>
				<tr>
					<td>
						<UL>
							<LI><small><b>You will be able to perform the following functions using this Wizard:</b></small>
								<OL>
									<LI><small><b>Create an initial Database for CMS 1.0 that contains minimal content as placeholders.</b></small></LI>
									<LI><small><b>Append multiple sets of Database Tables to an existing CMS 1.0 Database</b></small>
										<UL>
											<LI><small><b>This feature is useful when you wish to reuse an existing database to store content for more than one web site.</b></small></LI>
										</UL>
									</LI>
								</OL>
							</LI>
						</UL>
						<UL>
							<LI><b>DO NOT</b>
								<OL>
									<LI><b>DO NOT - </b><small><b>Attempt to create a Primary Site Database in a database that already has a Primary Site defined for CMS 1.0.</b></small></LI>
									<LI><b>DO NOT - </b><small><b>Attempt to create a Primary Site Database in a database that has not been set-up specifically for CMS 1.0.</b></small></LI>
								</OL>
							</LI>
						</UL>
						<UL>
							<LI><b>DO</b>
								<OL>
									<LI><b>DO - </b><small><b>Attempt to create a Primary Site Database in a database that has not been set-up specifically for CMS 1.0 and is known to have NO TABLES defined prior to using this Wizard.</b></small></LI>
								</OL>
							</LI>
						</UL>
					</td>
				</tr>
			</cfif>
			<cfif (_sql2000_wizard_i eq 1)>
				<tr>
					<td>
						<b>Step ###_sql2000_wizard_i#:</b><br><br>
						<b>ColdFusion Data Source Name:</b>&nbsp;<input type="text" name="_sql2000_wizard_dsn" size="30" maxlength="50"><br><br>
					</td>
				</tr>
			<cfelseif (_sql2000_wizard_i eq 2)>
				<tr>
					<td>
						<b>Step ###_sql2000_wizard_i#:</b><br><br>
						<b>ColdFusion Data Source User Name:</b>&nbsp;<input type="text" name="_sql2000_wizard_dsn_username" size="30" maxlength="50"><br><br>
					</td>
				</tr>
			<cfelseif (_sql2000_wizard_i eq 3)>
				<tr>
					<td>
						<b>Step ###_sql2000_wizard_i#:</b><br><br>
						<b>ColdFusion Data Source Password:</b>&nbsp;<input type="password" name="_sql2000_wizard_dsn_password" size="30" maxlength="50"><br><br>
					</td>
				</tr>
			<cfelseif (_sql2000_wizard_i eq 4)>
				<tr>
					<td>
						<table width="80%" align="center" cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									<b>Step ###_sql2000_wizard_i#:</b>
								</td>
							</tr>
							<tr>
								<td>
									<b>Checking the Database...</b>
								</td>
							</tr>

							<cfscript>
								_SQL_statement = "exec sp_tables @table_type = " & '"' & "'TABLE'" & '"';
								SQL2000WizardQueryTables0 = CommonCode.safelyExecSQL(_sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
							</cfscript>
								
							<cfscript>
								_invalid_login_message = 'ERROR: INVALID COLDFUSION DATASOURCE NAME (#_sql2000_wizard_dsn#) USED OR INVALID COLDFUSION DATASOURCE USERNAME (#_sql2000_wizard_dsn_username#) USED OR INVALID COLDFUSION DATASOURCE PASSWORD (#_sql2000_wizard_dsn_password#) USED.  RETRY USING VALID INFORMATION.';
								if ( (NOT IsDefined("SQL2000WizardQueryTables0")) OR (NOT IsQuery(SQL2000WizardQueryTables0)) ) {
									writeOutput('<b>' & _invalid_login_message & '</b>');
									_sql2000_wizard_allow_processing_wizard = false;
								} else if ( (IsDefined("SQL2000WizardQueryTables0")) AND (IsQuery(SQL2000WizardQueryTables0)) ) {
									if ( (IsDefined("SQL2000WizardQueryTables0.status")) AND (SQL2000WizardQueryTables0.status lt 0) ) {
										writeOutput('<b>' & _invalid_login_message & '</b>');
										_sql2000_wizard_allow_processing_wizard = false;
									}
								}
							</cfscript>
	
							<cfif (NOT _sql2000_wizard_allow_processing_wizard)>
								<font color="##ff0000"><b>Processing Stops due to an error...</b></font>
							<cfelse>
								<cfscript>
									_SQL_ = "SELECT * FROM SQL2000WizardQueryTables0 WHERE (Lower(#Request.const_TABLE_NAME_symbol#) <> 'dtproperties')";
									SQL2000WizardQueryTables = CommonCode.safelyExecQofQ('SQL2000WizardQueryTables', _SQL_, SQL2000WizardQueryTables0, 'SQL2000WizardQueryTables0');
								</cfscript>
		
								<cfif (IsDefined("SQL2000WizardQueryTables")) AND (SQL2000WizardQueryTables.recordCount eq 0)>
									<!--- BEGIN: There are no tables in this database so feel free to create CMS 1.0 Tables --->
									<cfinclude template="cfinclude_sql2000CreateDbTables.cfm">
									<!--- END! There are no tables in this database so feel free to create CMS 1.0 Tables --->
								<cfelse>
									<!--- BEGIN: There are some tables in this database so feel free to perform a sanity check on existing CMS 1.0 Tables --->
									<cfif 0>
										#CommonCode.debugQueryInTable(SQL2000WizardQueryTables, 'SQL2000WizardQueryTables')#
									</cfif>
		
									<cfset _list0_ = SQL2000.requiredTablesList()>
									<cfset _list_ = CommonCode.makeListIntoSQLList(LCase(_list0_))>
		
									<CFQUERY dbtype="query" name="SQL2000WizardVerifyTables">
										SELECT *
										FROM SQL2000WizardQueryTables0
										WHERE (Lower(#Request.const_TABLE_NAME_symbol#) IN (#PreserveSingleQuotes(_list_)#)) AND (Lower(Request.const_TABLE_OWNER_symbol) = 'dbo')
									</cfquery>
		
									<cfif (IsDefined("SQL2000WizardVerifyTables")) AND (IsQuery(SQL2000WizardVerifyTables))>
										<cfif (SQL2000WizardVerifyTables.recordCount eq ListLen(_list0_, ","))>
											<cfset is_processDone = "false">
		
											<cfif 0>
												#CommonCode.debugQueryInTable(SQL2000WizardVerifyTables, 'SQL2000WizardVerifyTables')#
											</cfif>
		
											<cfset _sql2000_wizard_i = IncrementValue(_sql2000_wizard_i)>
											<tr>
												<td>
													<br><br>
													<b>Step ###_sql2000_wizard_i#:</b>&nbsp;(This is an advanced feature that is designed to allow content for more than one site to be stored in the same CMS 1.0 database. The goal for using this feature is to perhaps allow all sites for a Portal to be stored in the same database OR to allow many sites to share the same physical database but each is treated as a distinct site. The use of this feature will require a suitably skilled ColdFusion programmer to make some adjustments to the application.cfm file as indicated by the programmer's notes you will be shown upon proceeding to the next step in this process.)<br><br>
													<b>CMS 1.0 Table Prefix Name:</b>&nbsp;<input type="text" name="_sql2000_wizard_table_prefix" size="30" maxlength="50"><br><br>
												</td>
											</tr>
										</cfif>
									</cfif>
									<!--- END! There are some tables in this database so feel free to perform a sanity check on existing CMS 1.0 Tables --->
								</cfif>
							</cfif>

							<tr>
								<td>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			<cfelseif (_sql2000_wizard_i eq 6)>
				<cfset _sql2000_wizard_table_prefix = SQL2000.makeTablePrefixCorrect(_sql2000_wizard_table_prefix)>
				<cfif (Len(_sql2000_wizard_table_prefix) gt 0)>
	
					<cfset _list0_ = SQL2000.requiredPrefixedTablesList(_sql2000_wizard_table_prefix)>
					<cfset _list_ = CommonCode.makeListIntoSQLList(LCase(_list0_))>
	
					<cfif (NOT IsDefined("SQL2000WizardQueryTables0")) OR (NOT IsQuery(SQL2000WizardQueryTables0))>
						<CFQUERY username='#_sql2000_wizard_dsn_username#' password='#_sql2000_wizard_dsn_password#' name="SQL2000WizardQueryTables0" datasource="#_sql2000_wizard_dsn#">
							exec sp_tables @table_type = "'TABLE'"
						</cfquery>
					</cfif>
	
					<CFQUERY dbtype="query" name="SQL2000WizardVerifyPrefixedTables">
						SELECT *
						FROM SQL2000WizardQueryTables0
						WHERE (Lower(#Request.const_TABLE_NAME_symbol#) IN (#PreserveSingleQuotes(_list_)#)) AND (Lower(#Request.const_TABLE_OWNER_symbol#) = 'dbo')
					</cfquery>
	
					<cfif (IsDefined("SQL2000WizardVerifyPrefixedTables")) AND (IsQuery(SQL2000WizardVerifyPrefixedTables))>
						<cfif (SQL2000WizardVerifyPrefixedTables.recordCount neq ListLen(_list0_, ","))>
							<cfset _sql2000_wizard_table_prefix = "#_sql2000_wizard_table_prefix#_">
							<cfinclude template="cfinclude_sql2000CreateDbTables.cfm">
						<cfelse>
							<cfset is_processError = "true">
							<font color="##ff0000"><BIG><b>ERROR: The Table Prefix entered cannot be used because it is already being used within this database. Please enter one that can be used and try again.</b></BIG></font>
						</cfif>
					</cfif>
				<cfelse>
					<cfset is_processError = "true">
					<font color="##ff0000"><BIG><b>ERROR: The Table Prefix entered cannot be used. Please enter one that can be used and try again.</b></BIG></font>
				</cfif>
			</cfif>
			<cfif (Len(subsite_name) eq 0)>
				<tr>
					<td>
						<cfif (is_processError)>
							<cfif (_sql2000_wizard_i eq 6)>
								<input type="hidden" name="_sql2000_wizard_i" value="#(_sql2000_wizard_i - 2)#">
							<cfelse>
								<input type="hidden" name="_sql2000_wizard_i" value="#(_sql2000_wizard_i - 1)#">
							</cfif>
						<cfelse>
							<input type="hidden" name="_sql2000_wizard_i" value="#(_sql2000_wizard_i + 1)#">
						</cfif>
						<cfif (_sql2000_wizard_i neq 1)>
							<input type="hidden" name="_sql2000_wizard_dsn" value="#_sql2000_wizard_dsn#">
						</cfif>
						<cfif (_sql2000_wizard_i neq 2)>
							<input type="hidden" name="_sql2000_wizard_dsn_username" value="#_sql2000_wizard_dsn_username#">
						</cfif>
						<cfif (_sql2000_wizard_i neq 3)>
							<input type="hidden" name="_sql2000_wizard_dsn_password" value="#_sql2000_wizard_dsn_password#">
						</cfif>
						<cfif ( (_sql2000_wizard_i neq 4) AND (_sql2000_wizard_i neq 6) ) OR (NOT is_processDone)>
							<cfif (is_processError)>
								<input type="submit" name="submitButton" value="[Prev]">
							<cfelse>
								<input type="submit" name="submitButton" value="[Next]">
							</cfif>
						<cfelse>
							<input type="submit" name="submitButton" value="[DONE]" disabled>
							<cfif (_sql2000_wizard_i eq 4)>
								&nbsp;Click <a href="#CGI.SCRIPT_NAME##Request.first_splashscreen_inhibitor#" target="myCMSv1"><b>here</b></a> to access the Advanced Features...
							</cfif>
							<cfif (_sql2000_wizard_i eq 6)>
								&nbsp;
								<table width="100%" cellpadding="-1" cellspacing="-1">
									<tr>
										<td bgcolor="##c0c0c0">
										<b>ColdFusion Programmer's Notes:</b>
										</td>
									</tr>
									<tr>
										<td bgcolor="##c0c0c0">
											<b>The following changes or modification need to be made to the application.cfm file for your copy of CMS 1.0 in order to use the database tables that have the prefix of '#_sql2000_wizard_table_prefix#'.</b>
										</td>
									</tr>
									<tr>
										<td bgcolor="##FFFFBF">
											<OL>
												<LI><b>The line of code that says, [_dbo = "dbo.";] needs to be changed to [_dbo = "dbo.#_sql2000_wizard_table_prefix#";]</b></LI>
											</OL>
										</td>
									</tr>
								</table>
							</cfif>
						</cfif>
						<a href="#CGI.SCRIPT_NAME##Request.first_splashscreen_inhibitor#" target="myCMSv1"><b>Click HERE to proceed...</b></a>
					</td>
				</tr>
			</cfif>
		</table>
	</form>
</cfoutput>
