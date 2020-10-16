<cfoutput>
	<cfscript>
		_sql2000_wizard_dsn = DSNSource;
		_sql2000_wizard_dsn_username = DSNUser;
		_sql2000_wizard_dsn_password = DSNPassword;
		
		_sql2000_wizard_allow_processing_subsite = true;
	</cfscript>

	<cfscript>
		SQL2000WizardQueryTables0 = SQL2000.enumerateDbTables(commonCode, _sql2000_wizard_dsn_username, _sql2000_wizard_dsn_password, _sql2000_wizard_dsn);
	</cfscript>

	<cfscript>
		_invalid_login_message = 'ERROR: INVALID COLDFUSION DATASOURCE NAME (#_sql2000_wizard_dsn#) USED OR INVALID COLDFUSION DATASOURCE USERNAME (#_sql2000_wizard_dsn_username#) USED OR INVALID COLDFUSION DATASOURCE PASSWORD (#_sql2000_wizard_dsn_password#) USED.  RETRY USING VALID INFORMATION.';
		if ( (NOT IsDefined("SQL2000WizardQueryTables0")) OR (NOT IsQuery(SQL2000WizardQueryTables0)) ) {
			writeOutput('(1) <b>' & _invalid_login_message & '</b>');
			_sql2000_wizard_allow_processing_subsite = false;
		} else if ( (IsDefined("SQL2000WizardQueryTables0")) AND (IsQuery(SQL2000WizardQueryTables0)) ) {
			if ( (IsDefined("SQL2000WizardQueryTables0.status")) AND (SQL2000WizardQueryTables0.status lt 0) ) {
				writeOutput('(2) <b>' & _invalid_login_message & '</b>');
				_sql2000_wizard_allow_processing_subsite = false;
			}
		}
	</cfscript>

	<cfscript>
		_invalid_db_message = 'ERROR: INVALID COLDFUSION DATASOURCE NAME (#_sql2000_wizard_dsn#) USED DUE TO DATABASE SETUP - DATABASE DOES NOT ALREADY HAVE PRIMARY SITE TABLES.';
		q_verifyRequiredTables = SQL2000.verifyRequiredTables(SQL2000WizardQueryTables0, SQL2000.requiredTablesList());
		if ( (NOT IsDefined("q_verifyRequiredTables")) OR (NOT IsQuery(q_verifyRequiredTables)) OR (NOT IsDefined("q_verifyRequiredTables.lst")) OR (Len(Trim(q_verifyRequiredTables.lst)) gt 0) ) {
			writeOutput('<b>' & _invalid_db_message & '</b>');
			_sql2000_wizard_allow_processing_subsite = false;
		}

		writeOutput('<UL>');
		writeOutput('<LI><b>The following Primary Site Tables have been setup in your database.</b>');
		writeOutput('<OL>');
		writeOutput('<LI>');
		Request._num_done = 0;
		if ( (IsDefined("q_verifyRequiredTables")) AND (IsQuery(q_verifyRequiredTables)) AND (IsDefined("q_verifyRequiredTables.sites")) ) {
			if (Len(Trim(q_verifyRequiredTables.sites)) gt 0) {
				Request.currently_managing_sites_count = Request.currently_managing_sites_count + 1;
				writeOutput('<font color="##0000ff"><b>#q_verifyRequiredTables.sites#</font></b>'); // &nbsp;(The base URL to access the Primary Site is: <font color="##0000ff">#Request._prefixName#?site=</font>)
				writeOutput('<table width="100%" cellpadding="-1" cellspacing="-1">');
				commonCode.list_iterator('.', ',', list_display_item, 2);
				writeOutput('</table>');
			} else {
				writeOutput('<b>None</b>');
			}
		}
		writeOutput('</LI>');
		writeOutput('</OL>');
		writeOutput('</LI>');
		writeOutput('</UL>');

		writeOutput('<UL>');
		writeOutput('<LI>');
		writeOutput('<b>The following Sub-Site Tables have been setup in your database.</b>');
		if (IsDefined("Client._site_")) {
			if (Len(Trim(Client._site_)) gt 0) {
				writeOutput('&nbsp;<b>(Remember, to select the Primary Site you must issue a URL that specifies "?site=")</b>');
			}
		}
		if ( (IsDefined("q_verifyRequiredTables")) AND (IsQuery(q_verifyRequiredTables)) AND (IsDefined("q_verifyRequiredTables.sub_sites")) ) {
			if (Len(Trim(q_verifyRequiredTables.sub_sites)) gt 0) {
				writeOutput('<table width="100%" cellpadding="-1" cellspacing="-1">');
				commonCode.list_iterator(q_verifyRequiredTables.sub_sites, ',', list_display_item, 2);
				writeOutput('</table>');
			} else {
				writeOutput('<OL>');
				writeOutput('<LI>');
				writeOutput('<b>None</b>');
				writeOutput('</LI>');
				writeOutput('</OL>');
			}
		}
		writeOutput('</LI>');
		writeOutput('</UL>');

		_plural = '';
		if (Request.currently_managing_sites_count gt 1) {
			_plural = '(s)';
		}
		writeOutput('<b>You are currently managing <big><font color="##0000ff">#Request.currently_managing_sites_count#</font></big> site#_plural# in your database.</b>');
	</cfscript>

	<form>
		<table width="80%" align="center" cellpadding="-1" cellspacing="-1">
			<tr>
				<td>
				</td>
			</tr>
			<tr>
				<td>
					<UL>
						<LI><small><b>You will be able to perform the following functions using this Sub-Site Wizard:</b></small>
							<OL>
								<LI><small><b>Append multiple sets of Database Tables to this existing CMS 1.0 Database</b></small>
									<UL>
										<LI><small><b>This feature is useful when you wish to create sub-sites within the boundaries of this site.</b></small></LI>
									</UL>
								</LI>
							</OL>
						</LI>
					</UL>
					<UL>
						<LI><b>DO NOT</b>
							<OL>
								<LI><b>DO NOT - </b><small><b>Attempt to create a Sub-Site Database in a database that does not have a Primary Site defined for CMS 1.0.</b></small></LI>
								<LI><b>DO NOT - </b><small><b>Attempt to create a Sub-Site Database in a database that has not been set-up specifically for CMS 1.0.</b></small></LI>
							</OL>
						</LI>
					</UL>
					<UL>
						<LI><b>DO</b>
							<OL>
								<LI><b>DO - </b><small><b>Attempt to create a Sub-Site Database in a database that has been set-up specifically for CMS 1.0 and is known to have a Primary Site defined prior to using this Wizard.</b></small></LI>
							</OL>
						</LI>
					</UL>
				</td>
			</tr>
			<tr>
				<td>
					<hr width="80%">
				</td>
			</tr>
			<cfif (NOT _sql2000_wizard_allow_processing_subsite)>
				<font color="##ff0000"><b>Processing Stops due to an error...</b></font>
			<cfelseif (Len(Trim(subsite_name)) gt 0)>
				<cfscript>
					_sub_sites = '';
					if ( (IsDefined("q_verifyRequiredTables")) AND (IsQuery(q_verifyRequiredTables)) AND (IsDefined("q_verifyRequiredTables.sub_sites")) ) {
						if (Len(Trim(q_verifyRequiredTables.sub_sites)) gt 0) {
							_sub_sites = q_verifyRequiredTables.sub_sites;
						}
					}
				</cfscript>

				<cfif (ListFindNoCase(_sub_sites, subsite_name, ",") eq 0)>
					<cfset _sql2000_wizard_i = 6>
					<cfset _sql2000_wizard_table_prefix = subsite_name>

					<a href="#CGI.SCRIPT_NAME##Request.first_splashscreen_inhibitor#" target="myCMSv1"><b>Click HERE to proceed...</b></a>

					<!--- BEGIN: Fake-out the system to allow this code to be reused here without the need to make a bunch of CommonCode routines... --->
					<cfinclude template="cfinclude_sql2000Editor_Wizard.cfm">
					<!--- END! Fake-out the system to allow this code to be reused here without the need to make a bunch of CommonCode routines... --->

					<cfscript>
						// BEGIN: Imhibit the processing of the wizard which uses these values...
						_sql2000_wizard_i = 1;
						_sql2000_wizard_table_prefix = '';
						_sql2000_wizard_dsn = '';
						_sql2000_wizard_dsn_username = '';
						_sql2000_wizard_dsn_password = '';
						subsite_name = '';
						// END! Imhibit the processing of the wizard which uses these values...
					</cfscript>

					<a href="#CGI.SCRIPT_NAME##Request.first_splashscreen_inhibitor#" target="myCMSv1"><b>Click HERE to proceed...</b></a>
				<cfelse>
					<font color="##ff0000"><b>ERROR: The Sub-Site name of (#subsite_name#) has previously been used to define a sub-site within your database and CANNOT be used again.  Kindly choose a different sub-site name and try again...</b></font>&nbsp;
					&nbsp;
					<a href="#CGI.SCRIPT_NAME##Request.first_splashscreen_inhibitor#" target="myCMSv1"><b>Click HERE to proceed...</b></a>
				</cfif>
			<cfelse>
				<tr>
					<td>
						<table width="80%" align="center" cellpadding="1" cellspacing="1">
							<tr>
								<td>
									<NOBR>Sub-Site Name:&nbsp;</NOBR><input type="text" name="subsite_name" id="subsite_name" size="20" maxlength="50" #_text_style_symbol# onkeypress="return acceptsAlphaNumerics(event.keyCode);">
								</td>
								<td align="justify">
									<i>(Sub-Site naming convention: Sub-Site Names must consist of only letters [A-Z] or [a-z] and/or Numbers [0-9]. Capitalization does not matter.)</i>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<button name="btn_proceed" id="btn_proceed" value="#create_sub_site_tables_button_symbol#" type="submit" #_text_style_symbol#>#create_sub_site_tables_button_symbol#</button>
					</td>
				</tr>
			</cfif>
		</table>
	</form>
</cfoutput>
