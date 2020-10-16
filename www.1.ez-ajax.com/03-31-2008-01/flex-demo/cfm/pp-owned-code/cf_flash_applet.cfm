<cfparam name="parms" type="string" default="">
<cftry>
	<cfif (IsDefined("Client._focus_area"))>
		<cfparam name="_focus_area" type="string" default="#Client._focus_area#">
	<cfelse>
		<cfparam name="_focus_area" type="string" default="">
	</cfif>

	<cfcatch type="Any">
		<cfparam name="_focus_area" type="string" default="">
	</cfcatch>
</cftry>

<cfscript>
	function processParms(p_parms) {
		var i = -1;
		var aParm = '';
		var aName = '';
		var aVal = '';

		for (i = 1; i lte ListLen(p_parms, ','); i = i + 1) {
			aParm = GetToken(p_parms, i, ',');
			if (ListLen(aParm, '=') eq 2) {
				aName = GetToken(aParm, 1, '=');
				aVal = GetToken(aParm, 2, '=');
				SetVariable(aName, aVal);
			}
		}
	}

	function queryAddressId(full_addrs) {
		var s_addr1 = '';
		var s_addr2 = '';
		var s_city = '';
		var s_state = '';
		var s_zip = '';
		var s_sql_code = '';

		s_addr1 = Trim(GetToken(full_addrs, 1, ','));
		s_addr2 = Trim(GetToken(full_addrs, 2, ','));
		s_city = Trim(GetToken(full_addrs, 3, ','));
		s_state = Trim(GetToken(full_addrs, 4, ','));
		s_zip = Trim(GetToken(full_addrs, 5, ','));
		s_sql_code = "SELECT Addresses.id FROM Addresses INNER JOIN Cities ON Addresses.city_id = Cities.id INNER JOIN States ON Addresses.state_id = States.id INNER JOIN ZipCodes ON Addresses.zipcode_id = ZipCodes.id WHERE (Cities.city_name = '#s_city#') AND (States.state_abbrev = '#s_state#') AND (ZipCodes.zipcode = '#s_zip#')";
		qAddr = Request.primitiveCode.safely_execSQL('', '', Request.DSN, s_sql_code, '');
		
		return qAddr;
	}

	processParms(parms);
</cfscript>

<cfset Cr = Chr(13)>

<cfset Cr = "<br>">

<cfset _style = "background-color: ##669846; font-family: Verdana; font-size: 10px;">

<style>
	BODY {
		margin: 0px;
		padding: 0px;
		background-color: #669846;
		color: #000000;
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: xx-small;
	}

	A:link {
		color: Blue;
	}
	A:visited {
		color: Blue;
	}
	A:active {
		color: Maroon;
	}
	A:hover {
		color: black;
	}

	.paragraphClass {
		font-size: 14px;
		text-align: justify;
	}

	.statusMsgClass {
		font-size: 10px;
		text-align: justify;
		color: Aqua;
	}

	.todoMsgClass {
		font-size: 12px;
		text-align: justify;
		color: Aqua;
	}
</style>

<cfset _filler_spaces = "">

<cfoutput>
	<cfsavecontent variable="sql_GetAddresses">
		SELECT Addresses.id, Addresses.street_address1, Addresses.street_address2, Addresses.city_id, Cities.city_name, Addresses.state_id, States.state_abbrev, 
		       Addresses.zipcode_id, ZipCodes.zipcode<cfif (LCase(_focus_area) eq LCase('Stores')) OR (LCase(_focus_area) eq LCase('Personnel'))>, (Addresses.street_address1 + ', ' + Addresses.street_address2 + ', ' + Cities.city_name + ', ' + States.state_abbrev + ', ' + ZipCodes.zipcode) as full_address</cfif>
		FROM Addresses INNER JOIN
		     Cities ON Addresses.city_id = Cities.id INNER JOIN
		     States ON Addresses.state_id = States.id INNER JOIN
		     ZipCodes ON Addresses.zipcode_id = ZipCodes.id
	</cfsavecontent>

	<cfif (IsDefined("StoresAddressUpdated"))>
		<cfscript>
			writeOutput('<p class="statusMsgClass">');

			qAddr = queryAddressId(stores_address);

			if (Request.db_err) {
				writeOutput('The Stores Address Record has NOT been successfully retrieved from the database due to an error.<BR>');
				writeOutput(Request.db_err_content);
			} else {
				Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO Stores (name, address_id) VALUES ('#stores_name#',#qAddr.id#)", '');
				if (Request.db_err) {
					qStore = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM Stores WHERE (name = '#stores_name#')", '');
					if (Request.db_err) {
						writeOutput('The Stores Record cannot be found in the database to perform an update.<BR>');
						writeOutput(Request.db_err_content);
					} else {
						Request.primitiveCode.safely_execSQL('', '', Request.DSN, "UPDATE Stores SET name = '#stores_name#', address_id = #qAddr.id# WHERE (id = #qStore.id#)", '');
						if (Request.db_err) {
							writeOutput('The Stores Record cannot be updated in the database due to an error.<BR>');
							writeOutput(Request.db_err_content);
						} else {
							writeOutput('The Stores Address record has been updated in the database.<BR>');
						}
					}
				} else {
					writeOutput('The Stores Address record has been inserted into to the database.<BR>');
				}
			}

			if (Len(Trim(store_email_address)) gt 0) {
				qEMail = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM EMailAddresses WHERE (email_address = '#store_email_address#')", '');
				if (IsQuery(qEMail)) {
					if (qEMail.recordCount eq 0) {
						sql_code = "INSERT INTO EMailAddresses (email_address) VALUES ('#store_email_address#'); SELECT @@IDENTITY AS 'id';";
						qEMail = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');
						if (Request.db_err) {
							writeOutput('The EMail Address Record cannot be inserted into the database due to an error.<br>');
							writeOutput(Request.db_err_content);
						} else {
							writeOutput('The EMail Address record has been inserted into the database.<br>');
						}
					}
				}
				if (NOT Request.db_err) {
					if ( (IsDefined("qStore.id")) AND (IsDefined("qEMail.id")) ) {
						if ( (qStore.id gt 0) AND (qEMail.id gt 0) ) {
							sql_code = "SELECT id, store_id, email_id FROM StoreEmailAddresses WHERE (store_id = #qStore.id#)";
							qStoreEmailAddress = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');
							if (IsQuery(qStoreEmailAddress)) {
								if ( (IsDefined("qStoreEmailAddress.id")) AND (qStoreEmailAddress.id gt 0) ) {
									// update the existing linkage
									sql_code = "UPDATE StoreEmailAddresses SET email_id = #qEMail.id# WHERE (store_id = #qStore.id#)";
									Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');
									if (Request.db_err) {
										writeOutput('The EMail Address Record linkage to the Store Record cannot be updated in the database due to an error.<br>');
										writeOutput(Request.db_err_content);
									} else {
										writeOutput('The EMail Address Record linkage to the Store Record has been updated in the database.<br>');
									}
								} else {
									// insert a new linkage
									sql_code = "INSERT INTO StoreEmailAddresses (store_id, email_id) VALUES (#qStore.id#,#qEMail.id#)";
									Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');
									if (Request.db_err) {
										writeOutput('The EMail Address Record linkage to the Store Record cannot be inserted into the database due to an error.<br>');
										writeOutput(Request.db_err_content);
									} else {
										writeOutput('The EMail Address Record linkage to the Store Record has been inserted in the database.<br>');
									}
								}
							}
						}
					}
				}
			}

			writeOutput('</p>');
		</cfscript>
	</cfif>

	<cfif (IsDefined("PersonnelUpdated"))>
		<cfscript>
			writeOutput('<p class="statusMsgClass">');

			qAddr = queryAddressId(personnel_address);

			if (Request.db_err) {
				writeOutput('The Personnel Address Record has NOT been successfully retrieved from the database due to an error.<br>');
				writeOutput(Request.db_err_content);
			} else {
				qStore = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM Stores WHERE (name = '#personnel_store#')", '');

				if (Request.db_err) {
					writeOutput('The Personnel Store Record has NOT been successfully retrieved from the database due to an error.<br>');
					writeOutput(Request.db_err_content);
				} else {
					sql_code = "INSERT INTO Personnel (name, store_id, address_id) VALUES ('#personnel_name#',#qStore.id#,#qAddr.id#)";
					Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');

					if (Request.db_err) {
						sql_code = "SELECT id FROM Personnel WHERE (name = '#personnel_name#')";
						qPersonnel = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');

						if (Request.db_err) {
							writeOutput('The Personnel Record cannot be found in the database to perform an update.<br>');
							writeOutput(Request.db_err_content);
						} else {
							Request.primitiveCode.safely_execSQL('', '', Request.DSN, "UPDATE Personnel SET store_id = #qStore.id#, address_id = #qAddr.id# WHERE (id = #qPersonnel.id#)", '');
							if (Request.db_err) {
								writeOutput('The Personnel Record cannot be updated in the database due to an error.<br>');
								writeOutput(Request.db_err_content);
							} else {
								writeOutput('The Personnel record has been updated in the database.<br>');
							}
						}
					} else {
						writeOutput('The Personnel record has been inserted into the database.<br>');
					}
				}
			}

			if (Len(Trim(personnel_email_address)) gt 0) {
				qEMail = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM EMailAddresses WHERE (email_address = '#personnel_email_address#')", '');
				if (IsQuery(qEMail)) {
					if (qEMail.recordCount eq 0) {
						sql_code = "INSERT INTO EMailAddresses (email_address) VALUES ('#personnel_email_address#'); SELECT @@IDENTITY AS 'id';";
						qEMail = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');
						if (Request.db_err) {
							writeOutput('The EMail Address Record cannot be inserted into the database due to an error.<br>');
							writeOutput(Request.db_err_content);
						} else {
							writeOutput('The EMail Address record has been inserted into the database.<br>');
						}
					}
				}
				if (NOT Request.db_err) {
					if ( (IsDefined("qPersonnel.id")) AND (IsDefined("qEMail.id")) ) {
						if ( (qPersonnel.id gt 0) AND (qEMail.id gt 0) ) {
							sql_code = "SELECT id, personnel_id, email_id FROM PersonnelEmailAddresses WHERE (personnel_id = #qPersonnel.id#)";
							qPersonnelEmailAddress = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');
							if (IsQuery(qPersonnelEmailAddress)) {
								if ( (IsDefined("qPersonnelEmailAddress.id")) AND (qPersonnelEmailAddress.id gt 0) ) {
									// update the existing linkage
									sql_code = "UPDATE PersonnelEmailAddresses SET email_id = #qEMail.id# WHERE (personnel_id = #qPersonnel.id#)";
									Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');
									if (Request.db_err) {
										writeOutput('The EMail Address Record linkage to the Personnel Record cannot be updated in the database due to an error.<br>');
										writeOutput(Request.db_err_content);
									} else {
										writeOutput('The EMail Address Record linkage to the Personnel Record has been updated in the database.<br>');
									}
								} else {
									// insert a new linkage
									sql_code = "INSERT INTO PersonnelEmailAddresses (personnel_id, email_id) VALUES (#qPersonnel.id#,#qEMail.id#)";
									Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_code, '');
									if (Request.db_err) {
										writeOutput('The EMail Address Record linkage to the Personnel Record cannot be inserted into the database due to an error.<br>');
										writeOutput(Request.db_err_content);
									} else {
										writeOutput('The EMail Address Record linkage to the Personnel Record has been inserted in the database.<br>');
									}
								}
							}
						}
					}
				}
			}

			writeOutput('</p>');
		</cfscript>
	</cfif>

	<cfif (IsDefined("UsersUpdated"))>
		<cfscript>
			s_personnel_name = Trim(GetToken(Users_personnel, 1, ','));
			s_store_name = Trim(GetToken(Users_personnel, 2, ','));

			qPersonnel = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT Personnel.id, Personnel.name, Stores.name AS store_name FROM Personnel INNER JOIN Stores ON Personnel.store_id = Stores.id WHERE (Personnel.name = '#s_personnel_name#') AND (Stores.name = '#s_store_name#')", '');
			if (Request.db_err) {
				writeOutput('<p class="statusMsgClass">The Personnel Record has NOT been successfully retrieved from the database due to an error.</p>');
				writeOutput(Request.db_err_content);
			} else {
				password_is_okay = true;
				try {
					theKey = generateSecretKey('BLOWFISH');
					e_password = Encrypt(Users_password, theKey, 'BLOWFISH', 'Hex') & ',' & theKey;
				} catch (Any e) {
					password_is_okay = false;
					writeOutput('<p class="statusMsgClass">Programming Error: Something terribly wrong just happened - PLS contact the developer(s) and report this error.</p>');
					writeOutput(Request.primitiveCode.cf_dump(e, "Encrypt('#Users_password#', '#Users_username#', 'BLOWFISH', 'Hex')", false));
				}
				if (password_is_okay) {
					Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO Users (username, password, personnel_id) VALUES ('#Users_username#','#e_password#',#qPersonnel.id#)", '');
	
					if (Request.db_err) {
						qUser = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, username, password, personnel_id FROM Users WHERE (username = '#Users_username#')", '');
	
						if (Request.db_err) {
							writeOutput('<p class="statusMsgClass">The Personnel Record has NOT been successfully retrieved from the database due to an error.</p>');
							writeOutput(Request.db_err_content);
						} else {
							Request.primitiveCode.safely_execSQL('', '', Request.DSN, "UPDATE Users SET password = '#e_password#', personnel_id = #qPersonnel.id# WHERE (id = #qUser.id#)", '');
	
							if (Request.db_err) {
								writeOutput('<p class="statusMsgClass">The Personnel Record has NOT been successfully updated in the database due to an error.</p>');
								writeOutput(Request.db_err_content);
							} else {
								writeOutput('<p class="statusMsgClass">The Personnel Record has been successfully updated in the database.</p>');
							}
						}
					} else {
						writeOutput('<p class="statusMsgClass">The Personnel Record has been successfully inserted in the database.</p>');
	
						qUser = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, username, password, personnel_id FROM Users WHERE (username = '#Users_username#')", '');
	
						if (Request.db_err) {
							writeOutput('<p class="statusMsgClass">The Personnel Record has NOT been successfully verified in the database due to an error.</p>');
							writeOutput(Request.db_err_content);
						} else {
							writeOutput('<p class="statusMsgClass">The Personnel Record has been successfully verified in the database.</p>');
						}
					}
				}
			}
		</cfscript>
	</cfif>

	<cfif (IsDefined("RolesUpdated"))>
		<cfscript>
			_username = Trim(GetToken(Roles_user, 1, ','));
			qGetUser = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM Users WHERE (username = '#_username#')", '');

			if (NOT Request.db_err) {
				db_action = '';
				if (LCASE(Roles_rolename) neq LCASE(Roles_role)) {
					db_action = 'inserted into';
					Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO UserRoles (role_name, user_id) VALUES ('#Roles_rolename#',#qGetUser.id#)", '');
				} else {
					db_action = 'updated in';
					Request.primitiveCode.safely_execSQL('', '', Request.DSN, "UPDATE UserRoles SET role_name = '#Roles_rolename#' WHERE (user_id = #qGetUser.id#)", '');
				}

				if (NOT Request.db_err) {
					writeOutput('<p class="statusMsgClass">The Roles Record has been successfully #db_action# the database.</p>');
				} else {
					writeOutput('<p class="statusMsgClass">The Roles Record has NOT been successfully #db_action# the database due to an error.</p>');
				}
			} else {
				writeOutput('<p class="statusMsgClass">The User Record has NOT been successfully retrieved from the database due to an error.</p>');
			}
		</cfscript>
	</cfif>
	
	<cfif (IsDefined("myForm.zipCodeGridUpdated"))>
		<cfgridupdate grid = "ZipCodeGrid" dataSource = "#Request.DSN#" Keyonly="true" tableName = "ZipCodes">
	</cfif>
	
	<cfif (IsDefined("myForm.StatesGridUpdated"))>
		<cfgridupdate grid = "StatesGrid" dataSource = "#Request.DSN#" Keyonly="true" tableName = "States">
	</cfif>

	<cfif (IsDefined("myForm.CitiesGridUpdated"))>
		<cfgridupdate grid = "CitiesGrid" dataSource = "#Request.DSN#" Keyonly="true" tableName = "Cities">
	</cfif>

	<cfif (IsDefined("AddressesDataUpdated"))>
		<cfscript>
			qZipCode = -1;
			qStateCode = -1;
			qCityCode = -1;
		</cfscript>
		<cfif (Form.addresses_zipcode neq Form.addresses_zipcode_other)>
			<!--- BEGIN: The other ZipCode is different than the selection field so try to add a new zipcode --->
			<cfscript>
				Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO ZipCodes (zipcode) VALUES ('#Form.addresses_zipcode_other#')", '');

				qZipCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM ZipCodes WHERE (zipcode = '#Form.addresses_zipcode_other#')", '');
			</cfscript>
			<!--- END! The other ZipCode is different than the selection field so try to add a new zipcode --->
		<cfelse>
			<!--- BEGIN: The other ZipCode is NOT different than the selection field so try to get the id for the zipcode --->
			<cfscript>
				qZipCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM ZipCodes WHERE (zipcode = '#Form.addresses_zipcode#')", '');
			</cfscript>
			<!--- END! The other ZipCode is NOT different than the selection field so try to get the id for the zipcode --->
		</cfif>

		<cfif (Form.addresses_state neq Form.addresses_state_abbrev)>
			<!--- BEGIN: The other State is different than the selection field so try to add a new state --->
			<cfscript>
				Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO States (state_abbrev) VALUES ('#Form.addresses_state_abbrev#')", '');

				qStateCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM States WHERE (state_abbrev = '#Form.addresses_state_abbrev#')", '');
			</cfscript>
			<!--- END! The other State is different than the selection field so try to add a new state --->
		<cfelse>
			<!--- BEGIN: The other State is NOT different than the selection field so try to get the id for the state_abbrev --->
			<cfscript>
				qStateCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM States WHERE (state_abbrev = '#Form.addresses_state#')", '');
			</cfscript>
			<!--- END! The other State is NOT different than the selection field so try to get the id for the state_abbrev --->
		</cfif>

		<cfif (Form.addresses_city neq Form.addresses_city_name)>
			<!--- BEGIN: The other State is different than the selection field so try to add a new state --->
			<cfscript>
				s_city_name = ReplaceNoCase(Form.addresses_city_name, ',', '', 'all');
				s_city_name = ReplaceNoCase(s_city_name, '"', '', 'all');
				Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO Cities (city_name) VALUES ('#s_city_name#')", '');

				qCityCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM Cities WHERE (city_name = '#Form.addresses_city_name#')", '');
			</cfscript>
			<!--- END! The other State is different than the selection field so try to add a new state --->
		<cfelse>
			<!--- BEGIN: The other Cities is NOT different than the selection field so try to get the id for the city_name --->
			<cfscript>
				qCityCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM Cities WHERE (city_name = '#Form.addresses_city#')", '');
			</cfscript>
			<!--- END! The other Cities is NOT different than the selection field so try to get the id for the city_name --->
		</cfif>

		<cfscript>
			if ( (IsQuery(qZipCode)) AND (IsQuery(qStateCode)) AND (IsQuery(qCityCode)) ) {
				if ( (IsDefined("qZipCode.id")) AND (IsDefined("qStateCode.id")) AND (IsDefined("qCityCode.id")) ) {
					if ( (IsNumeric(qZipCode.id)) AND (IsNumeric(qStateCode.id)) AND (IsNumeric(qCityCode.id)) ) {
						qAddr = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id FROM Addresses WHERE (street_address1 = '#addresses_StreetAddr1#')", '');
						db_action = '';
						if ( (IsQuery(qAddr)) AND (IsDefined("qAddr.id")) AND (qAddr.id gt 0) ) {
							db_action = 'updated in';
							Request.primitiveCode.safely_execSQL('', '', Request.DSN, "UPDATE Addresses SET street_address1 = '#addresses_StreetAddr1#', street_address2 = '#addresses_StreetAddr2#', city_id = #qCityCode.id#, state_id = #qStateCode.id#, zipcode_id = #qZipCode.id# WHERE (id = #qAddr.id#)", '');
						} else {
							db_action = 'saved to';
							Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO Addresses (street_address1, street_address2, city_id, state_id, zipcode_id) VALUES ('#addresses_StreetAddr1#','#addresses_StreetAddr2#',#qCityCode.id#,#qStateCode.id#,#qZipCode.id#)", '');
						}
						if (NOT Request.db_err) {
							writeOutput('<p class="statusMsgClass">The Address Record has been successfully #db_action# the database as requested.</p>');
						} else {
							writeOutput('<p class="statusMsgClass">The Address Record has NOT been successfully saved to the database due to an error.</p>');
						}
					}
				} else {
					writeOutput('<p class="statusMsgClass">The Address Record has NOT been successfully saved to the database due to an error (#qZipCode.id#, #qStateCode.id#, #qCityCode.id# - are non-numerics).</p>');
				}
			} else {
				writeOutput('<p class="statusMsgClass">The Address Record has NOT been successfully saved to the database due to an error.</p>');
			}

			writeOutput(Request.db_err_content);
		</cfscript>
	</cfif>

	<cfif (IsDefined("Form")) AND 0>
		<cfdump var="#Form#" label="Form">
	</cfif>

	<cfif (IsDefined("btn_chooseEmployee"))>
		<cfscript>
			if ( (Len(personnel_name) gt 0) AND (Len(employeePhoneNumber) gt 0) ) {
				qPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, phone_number FROM PhoneNumbers WHERE (phone_number = '#employeePhoneNumber#')", '');
				if ( (IsDefined("qPhoneNumber.id")) AND (Len(qPhoneNumber.id) eq 0) ) {
					sql_qPhoneNumber = "INSERT INTO PhoneNumbers (phone_number) VALUES ('#employeePhoneNumber#'); SELECT @@IDENTITY as id;";
					qPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qPhoneNumber, '');
				}

				if ( (IsDefined("qPhoneNumber.id")) AND (Len(qPhoneNumber.id) gt 0) ) {
					qEmployee = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, name FROM Personnel WHERE (UPPER(name) = '#UCASE(personnel_name)#')", '');
					if ( (IsDefined("qEmployee.id")) AND (Len(qEmployee.id) gt 0) ) {
						qEmployeePhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO PersonnelPhoneNumbers (personnel_id, phone_id) VALUES (#qEmployee.id#,#qPhoneNumber.id#); SELECT @@IDENTITY as id;", '');
						if (NOT Request.db_err) {
							writeOutput('<p class="statusMsgClass">The Employee Phone Record has been successfully inserted into the database as requested.</p>');
						} else {
							writeOutput('<p class="statusMsgClass">The Address Record has NOT been successfully inserted into the database due to an error.</p>');
						}
					}
				}
			}
		</cfscript>
	</cfif>

	<cfif (IsDefined("btn_UpdateEmpPhoneGrid"))>
		<cfscript>
			if ( (IsDefined("PersonnelPhoneGrid.rowstatus.action")) AND (IsDefined("PersonnelPhoneGrid.original.name")) AND (IsDefined("PersonnelPhoneGrid.original.phone_number")) ) {
				if ( (IsArray(PersonnelPhoneGrid.rowstatus.action)) AND (IsArray(PersonnelPhoneGrid.original.name)) AND (IsArray(PersonnelPhoneGrid.original.phone_number)) ) {
					for (i = 1; i lte ArrayLen(PersonnelPhoneGrid.rowstatus.action); i = i + 1) {
						sql_qGetPersonnel = "SELECT id FROM Personnel WHERE (name = '#PersonnelPhoneGrid.original.name[i]#')";
						qGetPersonnel = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qGetPersonnel, '');
						sql_qGetPhoneNumber = "SELECT id FROM PhoneNumbers WHERE (phone_number = '#PersonnelPhoneGrid.original.phone_number[i]#')";
						qGetPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qGetPhoneNumber, '');
						if ( (IsDefined("qGetPersonnel.id")) AND (Len(qGetPersonnel.id) gt 0) AND (IsDefined("qGetPhoneNumber.id")) AND (Len(qGetPhoneNumber.id) gt 0) ) {
							sql_qGetPersonnelPhoneNumber = "SELECT id FROM PersonnelPhoneNumbers WHERE (personnel_id = #qGetPersonnel.id#) AND (phone_id = #qGetPhoneNumber.id#)";
							qGetPersonnelPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qGetPersonnelPhoneNumber, '');
							if ( (IsDefined("qGetPersonnelPhoneNumber.id")) AND (Len(qGetPersonnelPhoneNumber.id) gt 0) ) {
								if (LCASE(PersonnelPhoneGrid.rowstatus.action[i]) eq LCASE('D')) {
									Request.primitiveCode.safely_execSQL('', '', Request.DSN, "DELETE FROM PersonnelPhoneNumbers WHERE id = #qGetPersonnelPhoneNumber.id#", '');
									if (NOT Request.db_err) {
										writeOutput('<p class="statusMsgClass">The Employee Phone Record has been successfully deleted from the database as requested.</p>');
									} else {
										writeOutput('<p class="statusMsgClass">The Employee Phone Record has NOT been successfully deleted from the database due to an error.</p>');
									}
								} else if (LCASE(PersonnelPhoneGrid.rowstatus.action[i]) eq LCASE('U')) {
									sql_qGetNewPhoneNumber = "SELECT id FROM PhoneNumbers WHERE (phone_number = '#PersonnelPhoneGrid.phone_number[i]#')";
									qGetNewPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qGetNewPhoneNumber, '');
									if ( (IsDefined("qGetNewPhoneNumber.id")) AND (Len(qGetNewPhoneNumber.id) eq 0) ) {
										sql_qInsertNewPhoneNumber = "INSERT INTO PhoneNumbers (phone_number) VALUES ('#PersonnelPhoneGrid.phone_number[i]#'); SELECT @@IDENTITY as id;";
										qGetNewPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qInsertNewPhoneNumber, '');
									}
									if ( (IsDefined("qGetNewPhoneNumber.id")) AND (Len(qGetNewPhoneNumber.id) gt 0) ) {
										Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO PersonnelPhoneNumbers (personnel_id, phone_id) VALUES (#qGetPersonnel.id#,#qGetNewPhoneNumber.id#); SELECT @@IDENTITY as id;", '');
										if (NOT Request.db_err) {
											writeOutput('<p class="statusMsgClass">The Employee Phone Record has been successfully updated in the database as requested.</p>');
										} else {
											writeOutput('<p class="statusMsgClass">The Employee Phone Record has NOT been successfully updated in the database due to an error.</p>');
										}
									}
								}
							}
						}
					}
				} else {
					writeOutput('<p class="statusMsgClass">Cannot update the PersonnelPhoneGrid due to some kind of programming error (NOT Arrays).</p>');
				}
			} else {
				writeOutput('<p class="statusMsgClass">Cannot update the PersonnelPhoneGrid due to some kind of programming error (NOT Defined).</p>');
			}
		</cfscript>
	</cfif>

	<!--- +++ --->
	<cfif (IsDefined("btn_chooseStore"))>
		<cfscript>
			if ( (Len(store_name) gt 0) AND (Len(storePhoneNumber) gt 0) ) {
				qPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, phone_number FROM PhoneNumbers WHERE (phone_number = '#storePhoneNumber#')", '');
				if ( (IsDefined("qPhoneNumber.id")) AND (Len(qPhoneNumber.id) eq 0) ) {
					sql_qPhoneNumber = "INSERT INTO PhoneNumbers (phone_number) VALUES ('#storePhoneNumber#'); SELECT @@IDENTITY as id;";
					qPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qPhoneNumber, '');
				}

				if ( (IsDefined("qPhoneNumber.id")) AND (Len(qPhoneNumber.id) gt 0) ) {
					qStore = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, name FROM Stores WHERE (UPPER(name) = '#UCASE(store_name)#')", '');
					if ( (IsDefined("qStore.id")) AND (Len(qStore.id) gt 0) ) {
						qStorePhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO StorePhoneNumbers (store_id, phone_id) VALUES (#qStore.id#,#qPhoneNumber.id#); SELECT @@IDENTITY as id;", '');
						if (NOT Request.db_err) {
							writeOutput('<p class="statusMsgClass">The Store Phone Record has been successfully inserted into the database as requested.</p>');
						} else {
							writeOutput('<p class="statusMsgClass">The Store Record has NOT been successfully inserted into the database due to an error.</p>');
						}
					}
				}
			}
		</cfscript>
	</cfif>

	<cfif (IsDefined("btn_UpdateStorePhoneGrid"))>
		<cfscript>
			if ( (IsDefined("StorePhoneGrid.rowstatus.action")) AND (IsDefined("StorePhoneGrid.original.name")) AND (IsDefined("StorePhoneGrid.original.phone_number")) ) {
				if ( (IsArray(StorePhoneGrid.rowstatus.action)) AND (IsArray(StorePhoneGrid.original.name)) AND (IsArray(StorePhoneGrid.original.phone_number)) ) {
					for (i = 1; i lte ArrayLen(StorePhoneGrid.rowstatus.action); i = i + 1) {
						sql_qGetStore = "SELECT id FROM Stores WHERE (name = '#StorePhoneGrid.original.name[i]#')";
						qGetStore = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qGetStore, '');
						sql_qGetPhoneNumber = "SELECT id FROM PhoneNumbers WHERE (phone_number = '#StorePhoneGrid.original.phone_number[i]#')";
						qGetPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qGetPhoneNumber, '');
						if ( (IsDefined("qGetStore.id")) AND (Len(qGetStore.id) gt 0) AND (IsDefined("qGetPhoneNumber.id")) AND (Len(qGetPhoneNumber.id) gt 0) ) {
							sql_qGetStorePhoneNumber = "SELECT id FROM StorePhoneNumbers WHERE (store_id = #qGetStore.id#) AND (phone_id = #qGetPhoneNumber.id#)";
							qGetStorePhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qGetStorePhoneNumber, '');
							if ( (IsDefined("qGetStorePhoneNumber.id")) AND (Len(qGetStorePhoneNumber.id) gt 0) ) {
								if (LCASE(StorePhoneGrid.rowstatus.action[i]) eq LCASE('D')) {
									Request.primitiveCode.safely_execSQL('', '', Request.DSN, "DELETE FROM StorePhoneNumbers WHERE id = #qGetStorePhoneNumber.id#", '');
									if (NOT Request.db_err) {
										writeOutput('<p class="statusMsgClass">The Store Phone Record has been successfully deleted from the database as requested.</p>');
									} else {
										writeOutput('<p class="statusMsgClass">The Store Phone Record has NOT been successfully deleted from the database due to an error.</p>');
									}
								} else if (LCASE(StorePhoneGrid.rowstatus.action[i]) eq LCASE('U')) {
									sql_qGetNewPhoneNumber = "SELECT id FROM PhoneNumbers WHERE (phone_number = '#StorePhoneGrid.phone_number[i]#')";
									qGetNewPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qGetNewPhoneNumber, '');
									if ( (IsDefined("qGetNewPhoneNumber.id")) AND (Len(qGetNewPhoneNumber.id) eq 0) ) {
										sql_qInsertNewPhoneNumber = "INSERT INTO PhoneNumbers (phone_number) VALUES ('#StorePhoneGrid.phone_number[i]#'); SELECT @@IDENTITY as id;";
										qGetNewPhoneNumber = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_qInsertNewPhoneNumber, '');
									}
									if ( (IsDefined("qGetNewPhoneNumber.id")) AND (Len(qGetNewPhoneNumber.id) gt 0) ) {
										Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO StorePhoneNumbers (store_id, phone_id) VALUES (#qGetStore.id#,#qGetNewPhoneNumber.id#); SELECT @@IDENTITY as id;", '');
										if (NOT Request.db_err) {
											writeOutput('<p class="statusMsgClass">The Store Phone Record has been successfully updated in the database as requested.</p>');
										} else {
											writeOutput('<p class="statusMsgClass">The Store Phone Record has NOT been successfully updated in the database due to an error.</p>');
										}
									}
								}
							}
						}
					}
				} else {
					writeOutput('<p class="statusMsgClass">Cannot update the StorePhoneGrid due to some kind of programming error (NOT Arrays).</p>');
				}
			} else {
				writeOutput('<p class="statusMsgClass">Cannot update the StorePhoneGrid due to some kind of programming error (NOT Defined).</p>');
			}
		</cfscript>
	</cfif>
	<!--- +++ --->

	<cfif (IsDefined("Form.addresses_zipcode")) AND (IsDefined("Form.addresses_zipcode_other"))>
		<cfscript>
			_zipCode = '';
			if (Len(Form.addresses_zipcode) gt 0) {
				_zipCode = Form.addresses_zipcode;
			} else if (Len(Form.addresses_zipcode_other) gt 0) {
				_zipCode = Form.addresses_zipcode_other;
			}
			
			if (Len(_zipCode) gt 0) {
				qGetZipCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, zipcode FROM ZipCodes WHERE (zipcode = '#_zipCode#')", '');
				if ( (IsDefined("qGetZipCode")) AND (IsDefined("qGetZipCode.zipcode")) AND (IsDefined("qGetZipCode.recordCount")) ) {
					if (qGetZipCode.recordCount eq 0) {
						Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO ZipCodes (zipcode) VALUES ('#_zipCode#')", '');
	
						if (NOT Request.db_err) {

							qGetZipCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, zipcode FROM ZipCodes WHERE (zipcode = '#_zipCode#')", '');

							if (NOT Request.db_err) {
							} else {
								writeOutput('<p class="statusMsgClass">The Zip Code Record that was saved to the database has NOT been successfully verified in the database due to an error.</p>');
							}
						} else {
							writeOutput('<p class="statusMsgClass">I. The Zip Code Record has NOT been successfully saved to the database due to an error.</p>');
						}
					}
				}
			}
		</cfscript>
	</cfif>
	
	<cfif (IsDefined("Form.addresses_state")) AND (IsDefined("Form.addresses_state_abbrev"))>
		<cfscript>
			_stateCode = '';
			if (Len(Form.addresses_state) gt 0) {
				_stateCode = Form.addresses_state;
			} else if (Len(Form.addresses_state_abbrev) gt 0) {
				_stateCode = Form.addresses_state_abbrev;
			}
			if (Len(_stateCode) gt 0) {
				qGetStateCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, state_abbrev FROM States WHERE (state_abbrev = '#_stateCode#')", '');
				
				if ( (IsDefined("qGetStateCode")) AND (IsDefined("qGetStateCode.state_abbrev")) AND (IsDefined("qGetStateCode.recordCount")) ) {
					if (qGetStateCode.recordCount eq 0) {
						Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO States (state_abbrev) VALUES ('#_stateCode#')", '');
	
						if (NOT Request.db_err) {

							qGetStateCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, state_abbrev FROM States WHERE (state_abbrev = '#_stateCode#')", '');

							if (NOT Request.db_err) {
							} else {
								writeOutput('<p class="statusMsgClass">The State Record that was saved to the database has NOT been successfully verified in the database due to an error.</p>');
							}
						} else {
							writeOutput('<p class="statusMsgClass">I. The State Record has NOT been successfully saved to the database due to an error.</p>');
						}
					}
				}
			}
		</cfscript>
	</cfif>

	<cfif (IsDefined("Form.addresses_city")) AND (IsDefined("Form.addresses_city_name"))>
		<cfscript>
			_cityCode = '';
			if (Len(Form.addresses_city) gt 0) {
				_cityCode = Form.addresses_city;
			} else if (Len(Form.addresses_city_name) gt 0) {
				_cityCode = Form.addresses_city_name;
			}
			if (Len(_cityCode) gt 0) {
				qGetCityCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, city_name FROM Cities WHERE (city_name = '#_cityCode#')", '');
				
				if ( (IsDefined("qGetCityCode")) AND (IsDefined("qGetCityCode.state_abbrev")) AND (IsDefined("qGetCityCode.recordCount")) ) {
					if (qGetCityCode.recordCount eq 0) {
						Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO Cities (city_name) VALUES ('#_cityCode#')", '');
	
						if (NOT Request.db_err) {
							qGetStateCode = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, city_name FROM Cities WHERE (city_name = '#_cityCode#')", '');

							if (NOT Request.db_err) {
//								writeOutput('<p class="statusMsgClass">The City Record that was saved to the database has been successfully verified in the database as requested.</p>');
							} else {
								writeOutput('<p class="statusMsgClass">The City Record that was saved to the database has NOT been successfully verified in the database due to an error.</p>');
							}
						} else {
							writeOutput('<p class="statusMsgClass">I. The City Record has NOT been successfully saved to the database due to an error.</p>');
						}
					}
				}
			}
		</cfscript>
	</cfif>

	<cfif (IsDefined("Form.addresses_streetaddr1")) AND (IsDefined("Form.addresses_streetaddr2"))>
		<cfsavecontent variable="sql_GetAddress">
			<cfoutput>
				SELECT id, street_address1, street_address2, city_id, state_id, zipcode_id
				FROM Addresses
				WHERE (street_address1 = '#Form.addresses_streetaddr1#')
					<cfif (Len(Form.addresses_streetaddr2) gt 0)>
						AND (street_address2 = '#Form.addresses_streetaddr2#')
					</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfscript>
			qGetAddress = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_GetAddress, '');

			if ( (IsDefined("qGetAddress")) AND (IsDefined("qGetAddress.street_address1")) AND (IsDefined("qGetAddress.recordCount")) AND (IsDefined("qGetAddress.id")) AND (IsDefined("qGetAddress.id")) AND (IsDefined("qGetAddress.id")) ) {
				if (qGetAddress.recordCount eq 0) {
					Request.primitiveCode.safely_execSQL('', '', Request.DSN, "INSERT INTO Addresses (street_address1, street_address2, city_id, state_id, zipcode_id) VALUES ('#Form.addresses_streetaddr1#', '#Form.addresses_streetaddr2#', #qGetCityCode.id#, #qGetStateCode.id#, #qGetZipCode.id#)", '');

					_filler_spaces = RepeatString('<br>', 5);
					writeOutput(_filler_spaces);

					if (NOT Request.db_err) {
						writeOutput('<p class="statusMsgClass">The Address Record has been successfully saved to the database as requested.</p>');
					} else {
						writeOutput('<p class="statusMsgClass">The Address Record has NOT been successfully saved to the database due to an error.</p>');
					}
				}
			}
		</cfscript>
	</cfif>

	<cfif (LCase(_focus_area) eq LCase("To-Do"))>
		<cfform action="#CGI.SCRIPT_NAME#" method="POST" name="myForm" width="980" format="Flash" timeout="0" style="#_style#" skin="haloGreen" wmode="tranparent" enctype="application/x-www-form-urlencoded">
			<cfformgroup  type="panel" label="To-Do List (This To-Do List is updated on a regular basis - PLS review each item.)" width="950" visible="Yes" enabled="Yes">
				<cftree name="todo_tree" lookandfeel="METAL" height="450" bold="No" italic="No" border="Yes" hscroll="Yes" vscroll="Yes" required="No" completepath="No" appendkey="Yes" highlighthref="Yes">
					<cftreeitem display="To-Do List:" value="1.0">
	
					<cftreeitem display="Optional Data Entry Technique(s):" expand="No" parent="1.0" value="1.0.1">
					<cftreeitem display="Recently developed a technique for Flash Forms that removes the need to perform a POST to the server each time the Submit button is pressed." parent="1.0.1" value="1.0.1.1">
					<cftreeitem display="As using this technique requires additional development effort although it is a very simple technique to use this is an OPTIONAL technique." parent="1.0.1" value="1.0.1.2">
	
					<cftreeitem display="As to the benefits of using this technique:" expand="No" parent="1.0.1" value="1.0.1.3">
					<cftreeitem display="Faster data entry can be achieved because the end-user does NOT need to wait each time data has been entered." parent="1.0.1.3" value="1.0.1.3.1">
					<cftreeitem display="Data is automatically populated into the appropriate fields whenever any data element is entered." parent="1.0.1.3" value="1.0.1.3.2">
					<cftreeitem display="The end-user would still need to click the Submit button but the Flash Form remains visible while the data is being saved to the database." parent="1.0.1.3" value="1.0.1.3.3">
					<cftreeitem display="The entire GUI could be made into a single Flash Form allowing end-users to quickly and easily enter data without waiting between interactions." parent="1.0.1.3" value="1.0.1.3.4">
					<cftreeitem display="The development cost would be approx. 40 hours to implement this technique for all 5 current Flash Forms" parent="1.0.1.3" value="1.0.1.3.5">
					<cftreeitem display="The use of this technique is one that I originally developed for HTML/DHTML forms that must make heavy use of JavaScript." parent="1.0.1.3" value="1.0.1.3.7">
	
					<cftreeitem display="Users Data Entry is minimally functional, except for the following items that reside outside the bounds of the currently approved work:" expand="No" parent="1.0" value="1.0.2">
					<cftreeitem display="Users Delete function - allows unlinked Users to be deleted from the database (does not delete stores or personnel)" parent="1.0.2" value="1.0.2.1">
					<cftreeitem display="Users Query function - allows Users records to be found based on a query by example." parent="1.0.2" value="1.0.2.2">
					<cftreeitem display="Users Report function - allows Users records to be printed in a Report Format via Query." parent="1.0.2" value="1.0.2.3">
	
					<cftreeitem display="Roles Data Entry is minimally functional, except for the following items that reside outside the bounds of the currently approved work:" expand="No" parent="1.0" value="1.0.3">
					<cftreeitem display="Roles Delete function - allows unlinked Roles to be deleted from the database (does not delete users or stores)" parent="1.0.3" value="1.0.3.1">
					<cftreeitem display="Roles Query function - allows Roles records to be found based on a query by example." parent="1.0.3" value="1.0.3.2">
					<cftreeitem display="Roles Report function - allows Roles records to be printed in a Report Format via Query." parent="1.0.3" value="1.0.3.3">

					<cftreeitem display="Stores Data Entry is minimally functional, except for the following items that reside outside the bounds of the currently approved work:" expand="No" parent="1.0" value="1.0.4">
					<cftreeitem display="Stores Delete function - allows unlinked stores to be deleted from the database (does not delete addresses)" parent="1.0.4" value="1.0.4.1">
					<cftreeitem display="Stores Query function - allows stores records to be found based on a query by example." parent="1.0.4" value="1.0.4.2">
					<cftreeitem display="Stores Report function - allows stores records to be printed in a Report Format via Query." parent="1.0.4" value="1.0.4.3">

					<cftreeitem display="Personnel Data Entry is minimally functional, except for the following items that reside outside the bounds of the currently approved work:" expand="No" parent="1.0" value="1.0.5">
					<cftreeitem display="Personnel Delete function - allows unlinked personnel to be deleted from the database (does not delete stores or addresses)" parent="1.0.5" value="1.0.5.1">
					<cftreeitem display="Personnel Query function - allows personnel records to be found based on a query by example." parent="1.0.5" value="1.0.5.2">
					<cftreeitem display="Personnel Report function - allows personnel records to be printed in a Report Format via Query." parent="1.0.5" value="1.0.5.3">

					<cftreeitem display="Addresses Data Entry is minimally functional, except for the following items that reside outside the bounds of the currently approved work:" expand="No" parent="1.0" value="1.0.6">
					<cftreeitem display="Addresses Delete function - allows unlinked address to be deleted from the database (does not delete City/State/Zip)" parent="1.0.6" value="1.0.6.1">
					<cftreeitem display="Addresses Query function - allows address records to be found based on a query by example." parent="1.0.6" value="1.0.6.2">
					<cftreeitem display="Addresses Report function - allows address records to be printed in a Report Format via Query." parent="1.0.6" value="1.0.6.3">
				</cftree>
			</cfformgroup>
		</cfform>
	<cfelseif (Len(Trim(_focus_area)) gt 0)>
		<cfform action="#CGI.SCRIPT_NAME#" method="POST" name="myForm" format="Flash" timeout="0" style="#_style#" skin="haloGreen" wmode="tranparent" enctype="application/x-www-form-urlencoded">
			<cfif (LCase(_focus_area) eq LCase('Users'))>
				<cfformgroup  type="panel" label="Users" visible="Yes" enabled="Yes">
					<cfformgroup  type="vdividedbox" visible="Yes" enabled="Yes">
						<cfformgroup  type="page" width="700" visible="Yes" enabled="Yes">
							<cfscript>
								qGetPersonnel = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT Personnel.name, Stores.name AS store_name, (Personnel.name + ', ' + Stores.name) as full_personnel FROM Personnel INNER JOIN Stores ON Personnel.store_id = Stores.id ORDER BY Personnel.name", '');
							</cfscript>

							<cfsavecontent variable="Users_password_onchange">
								alert('Users_username = [' + Users_username.text + ']' + ', Users_password = [' + Users_password.text + ']');
								return false;
							</cfsavecontent>

							<cfinput type="Text" name="Users_username" label="UserName:" required="Yes" visible="Yes" enabled="Yes" size="20" maxlength="50">
							<cfinput type="Password" name="Users_password" label="Password:" required="Yes" size="20" maxlength="50" visible="Yes" enabled="Yes">
							<cfselect name="Users_personnel" value="full_personnel" query="qGetPersonnel" width="500" style="#_style#" label="Employee:" required="Yes" visible="Yes" enabled="Yes"></cfselect>
							<br>
							<cfinput type="Submit" name="UsersUpdated" value="[Update User]" visible="Yes" enabled="Yes">
						</cfformgroup>
	
						<cfformgroup  type="page" visible="Yes" enabled="Yes">
							<cfscript>
								qGetUsers = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT Users.id, Users.username, Personnel.id AS personnel_id, Personnel.name, Stores.name AS store_name, Users.password, (Personnel.name + ', ' + Stores.name) as full_user_store FROM Users INNER JOIN Personnel ON Users.personnel_id = Personnel.id INNER JOIN Stores ON Personnel.store_id = Stores.id ORDER BY Personnel.name, Stores.name", '');
							</cfscript>

							<cfsavecontent variable="UsersGrid_action">
								function selectThisItem(oObj, itemValue) {
									var a = oObj.dataProvider.slice(0);
									for (var i = 0; i < a.length; i++) {
										if (a[i].data == itemValue) {
											oObj.selectedIndex = i;
											break;
										}
									}
								}

								Users_username.htmlText = UsersGrid.dataProvider[UsersGrid.selectedIndex].username;
								Users_password.htmlText = '';

								selectThisItem(Users_personnel, UsersGrid.dataProvider[UsersGrid.selectedIndex].full_user_store);
							</cfsavecontent>

							<cfscript>
								if (IsQuery(qGetUsers)) {
									for (i = 1; i lte qGetUsers.recordCount; i = i + 1) {
										_theKey = qGetUsers.username[i];
										if (ListLen(qGetUsers.password[i], ',') gt 1) {
											_theKey = GetToken(qGetUsers.password[i], 2, ',');
										}
//										pwd = Decrypt(GetToken(qGetUsers.password[i], 1, ','), _theKey, 'BLOWFISH', 'Hex');
										pwd = '--- Encrypted ---';
										QuerySetCell(qGetUsers, 'password', pwd, i);
									}
								}
							</cfscript>

							<cfgrid name="UsersGrid" query="qGetUsers" width="900" height="200" insert="Yes" delete="Yes" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="blue" colheaderitalic="No" colheaderbold="Yes" selectmode="BROWSE" picturebar="No" insertbutton="[+}" deletebutton="[-]" onchange="#UsersGrid_action#">
								<cfgridcolumn name = "id" display = "No">
								<cfgridcolumn name="username" header="UserName" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name="password" header="Password" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name = "personnel_id" display = "No">
								<cfgridcolumn name="full_user_store" header="Employee / Store" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
							</cfgrid>
						</cfformgroup>
					</cfformgroup>
				</cfformgroup>
			</cfif>

			<cfif (LCase(_focus_area) eq LCase('Roles'))>
				<cfformgroup  type="panel" label="Roles" visible="Yes" enabled="Yes">
					<cfformgroup  type="vdividedbox" visible="Yes" enabled="Yes">

						<cfscript>
							qGetUsers = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT Users.username, Personnel.name, Stores.name AS store_name, (Users.username + ', ' + Personnel.name + ', ' + Stores.name) as full_user_store FROM Users INNER JOIN Personnel ON Users.personnel_id = Personnel.id INNER JOIN Stores ON Personnel.store_id = Stores.id", '');
						</cfscript>

						<cfscript>
							qGetRoleCodes = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT role_name FROM UserRoles ORDER BY role_name", '');
						</cfscript>

						<cfformgroup  type="horizontal" visible="Yes" enabled="Yes" style="margin-left: -50px;">
							<cfselect name="Roles_role" width="150" style="#_style#" label="Choose a Role" query="qGetRoleCodes" value="role_name" required="No" visible="Yes" enabled="Yes" tooltip="This list is automatically populated from the database to make data entry faster."></cfselect>
							<cfinput type="Text" name="Roles_rolename" label="OR Enter a new Role Name" required="Yes" visible="Yes" enabled="Yes" size="20" maxlength="50" bind="{Roles_role.value}">
						</cfformgroup>

						<cfselect name="Roles_user" width="575" style="#_style#" label="User:" value="full_user_store" query="qGetUsers" required="Yes" visible="Yes" enabled="Yes"></cfselect>
						<br>
						<cfinput type="Submit" name="RolesUpdated" value="[Update Roles]" visible="Yes" enabled="Yes">
	
						<cfformgroup  type="page" visible="Yes" enabled="Yes">
							<cfscript>
								qGetRoles = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT UserRoles.role_name, (Users.username + ', ' + Personnel.name + ', ' + Stores.name) as full_user_store FROM UserRoles INNER JOIN Users ON UserRoles.user_id = Users.id INNER JOIN Personnel ON Users.personnel_id = Personnel.id INNER JOIN Stores ON Personnel.store_id = Stores.id ORDER BY UserRoles.role_name, Users.username, Personnel.name, Stores.name", '');
							</cfscript>

							<cfsavecontent variable="RolesGrid_action">
								function selectThisItem(oObj, itemValue) {
									var a = oObj.dataProvider.slice(0);
									for (var i = 0; i < a.length; i++) {
										if (a[i].data == itemValue) {
											oObj.selectedIndex = i;
											break;
										}
									}
								}

								selectThisItem(Roles_role, RolesGrid.dataProvider[RolesGrid.selectedIndex].role_name);
								Roles_rolename.htmlText = RolesGrid.dataProvider[RolesGrid.selectedIndex].role_name;

								selectThisItem(Roles_user, RolesGrid.dataProvider[RolesGrid.selectedIndex].full_user_store);
							</cfsavecontent>

							<cfgrid name="RolesGrid" width="850" height="200" query="qGetRoles" insert="No" delete="No" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="blue" colheaderitalic="No" colheaderbold="Yes" selectmode="BROWSE" picturebar="No" insertbutton="[+}" deletebutton="[-]" onchange="#RolesGrid_action#">
								<cfgridcolumn name="role_name" header="Role Name" width="200" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name="full_user_store" header="User Record" width="650" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
							</cfgrid>
						</cfformgroup>
					</cfformgroup>
				</cfformgroup>
			</cfif>

			<cfif (LCase(_focus_area) eq LCase('Stores'))>
				<cfscript>
					qGetAddresses = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_GetAddresses, '');
				</cfscript>

				<cfformgroup  type="panel" label="Stores" visible="Yes" enabled="Yes">
					<cfformgroup  type="vdividedbox" visible="Yes" enabled="Yes">
						<cfformgroup  type="page" width="900" height="150" visible="Yes" enabled="Yes">
							<cfinput type="Text" name="stores_name" label="Store Name:" required="Yes" visible="Yes" enabled="Yes" size="45" maxlength="50">
							<cfselect name="stores_address" value="full_address" width="550" style="#_style#" query="qGetAddresses" label="Address:" required="Yes" visible="Yes" enabled="Yes"></cfselect>

							<cfscript>
								qGetEMailAddresses = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, email_address FROM EMailAddresses ORDER BY email_address", '');
							</cfscript>

							<cfformgroup  type="horizontal" visible="Yes" enabled="Yes" style="margin-left: -115px;">
								<cfselect name="store_email" width="250" style="#_style#" label="Choose an EMail Address" query="qGetEMailAddresses" value="email_address" required="No" visible="Yes" enabled="Yes" tooltip="This list is automatically populated from the database to make data entry faster."></cfselect>
								<cfinput type="Text" name="store_email_address" label="OR Enter a new EMail Address" required="Yes" visible="Yes" enabled="Yes" size="25" maxlength="50" bind="{store_email.value}">
							</cfformgroup>

							<cfinput type="Submit" name="StoresAddressUpdated" value="[Update Store]" visible="Yes" enabled="Yes">
						</cfformgroup>
	
						<cfformgroup  type="page" visible="Yes" enabled="Yes">
							<cfsavecontent variable="sql_GetStores">
								SELECT Stores.id, Stores.name, Stores.address_id, 
								       Addresses.street_address1 + ', ' + Addresses.street_address2 + ', ' + Cities.city_name + ', ' + States.state_abbrev + ', ' + ZipCodes.zipcode
								       AS full_address, EMailAddresses.email_address as email_addr
								FROM EMailAddresses INNER JOIN
								     StoreEMailAddresses ON EMailAddresses.id = StoreEMailAddresses.email_id RIGHT OUTER JOIN
								     Stores INNER JOIN
								     Addresses ON Stores.address_id = Addresses.id INNER JOIN
								     Cities ON Addresses.city_id = Cities.id INNER JOIN
								     States ON Addresses.state_id = States.id INNER JOIN
								     ZipCodes ON Addresses.zipcode_id = ZipCodes.id ON StoreEMailAddresses.store_id = Stores.id
								ORDER BY Stores.name
					  		</cfsavecontent>

							<cfscript>
								qGetStores = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_GetStores, '');
							</cfscript>

							<cfsavecontent variable="StoresGrid_action">
								function selectThisItem(oObj, itemValue) {
									var a = oObj.dataProvider.slice(0);
									for (var i = 0; i < a.length; i++) {
										if (a[i].data == itemValue) {
											oObj.selectedIndex = i;
											break;
										}
									}
								}

								stores_name.htmlText = StoresGrid.dataProvider[StoresGrid.selectedIndex].name;

								selectThisItem(stores_address, StoresGrid.dataProvider[StoresGrid.selectedIndex].full_address);
								
								selectThisItem(store_email, StoresGrid.dataProvider[StoresGrid.selectedIndex].email_addr);
							</cfsavecontent>

							<cfgrid name="StoresGrid" width="800" height="200" query="qGetStores" insert="No" delete="No" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="blue" colheaderitalic="No" colheaderbold="Yes" selectmode="BROWSE" picturebar="No" deletebutton="[-]" onchange="#StoresGrid_action#">
								<cfgridcolumn name = "id" display = "No">
								<cfgridcolumn name="name" header="Store Name" width="250" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name="email_addr" header="EMail Addrs" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name = "address_id" display = "No">
								<cfgridcolumn name="full_address" header="Store Address" width="#(800 - 250)#" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
							</cfgrid>
						</cfformgroup>
					</cfformgroup>
				</cfformgroup>
			</cfif>

			<cfif (LCase(_focus_area) eq LCase('Personnel'))>
				<cfscript>
					qGetAddresses = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_GetAddresses, '');

					qGetStores = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT name FROM Stores ORDER BY name", '');
				</cfscript>

				<cfformgroup  type="panel" label="Personnel" visible="Yes" enabled="Yes">
					<cfformgroup  type="vdividedbox" visible="Yes" enabled="Yes">
						<cfformgroup  type="page" width="900" visible="Yes" enabled="Yes">
							<cfinput type="Text" name="personnel_name" label="Employee Name:" required="Yes" visible="Yes" enabled="Yes" size="40" maxlength="50">
							<cfselect name="personnel_store" value="name" width="500" style="#_style#" query="qGetStores" label="Store Name:" required="Yes" visible="Yes" enabled="Yes"></cfselect>
							<cfselect name="personnel_address" value="full_address" width="550" style="#_style#" query="qGetAddresses" label="Address:" required="Yes" visible="Yes" enabled="Yes"></cfselect>
							<br>

							<cfscript>
								qGetEMailAddresses = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, email_address FROM EMailAddresses ORDER BY email_address", '');
							</cfscript>

							<cfformgroup  type="horizontal" visible="Yes" enabled="Yes" style="margin-left: -115px;">
								<cfselect name="personnel_email" width="250" style="#_style#" label="Choose an EMail Address" query="qGetEMailAddresses" value="email_address" required="No" visible="Yes" enabled="Yes" tooltip="This list is automatically populated from the database to make data entry faster."></cfselect>
								<cfinput type="Text" name="personnel_email_address" label="OR Enter a new EMail Address" required="Yes" visible="Yes" enabled="Yes" size="25" maxlength="50" bind="{personnel_email.value}">
							</cfformgroup>

							<cfinput type="Submit" name="PersonnelUpdated" value="[Update Employee]" visible="Yes" enabled="Yes">
						</cfformgroup>
	
						<cfformgroup  type="page" visible="Yes" enabled="Yes">
							<cfsavecontent variable="sql_GetPersonnel">
								SELECT Personnel.id, Personnel.name, Stores.name AS store_name, Personnel.store_id, Personnel.address_id, 
								       Addresses.street_address1 + ', ' + Addresses.street_address2 + ', ' + Cities.city_name + ', ' + States.state_abbrev + ', ' + ZipCodes.zipcode
								       AS full_address, EMailAddresses.email_address as email_addr
								FROM EMailAddresses INNER JOIN
								     PersonnelEmailAddresses ON EMailAddresses.id = PersonnelEmailAddresses.email_id RIGHT OUTER JOIN
								     Personnel INNER JOIN
								     Stores ON Personnel.store_id = Stores.id INNER JOIN
								     Addresses ON Personnel.address_id = Addresses.id INNER JOIN
								     Cities ON Addresses.city_id = Cities.id INNER JOIN
								     States ON Addresses.state_id = States.id INNER JOIN
								     ZipCodes ON Addresses.zipcode_id = ZipCodes.id ON PersonnelEmailAddresses.personnel_id = Personnel.id
								ORDER BY Personnel.name
							</cfsavecontent>

							<cfscript>
								qGetPersonnel = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_GetPersonnel, '');
							</cfscript>

							<cfsavecontent variable="PersonnelGrid_action">
								function selectThisItem(oObj, itemValue) {
									var a = oObj.dataProvider.slice(0);
									for (var i = 0; i < a.length; i++) {
										if (a[i].data == itemValue) {
											oObj.selectedIndex = i;
											break;
										}
									}
								}

								personnel_name.htmlText = PersonnelGrid.dataProvider[PersonnelGrid.selectedIndex].name;

								selectThisItem(personnel_store, PersonnelGrid.dataProvider[PersonnelGrid.selectedIndex].store_name);

								selectThisItem(personnel_address, PersonnelGrid.dataProvider[PersonnelGrid.selectedIndex].full_address);
								
								selectThisItem(personnel_email, PersonnelGrid.dataProvider[PersonnelGrid.selectedIndex].email_addr);
							</cfsavecontent>

							<cfgrid name="PersonnelGrid" query="qGetPersonnel" width="900" height="200" insert="No" delete="No" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="blue" colheaderitalic="No" colheaderbold="Yes" selectmode="BROWSE" picturebar="No" deletebutton="[-]" onchange="#PersonnelGrid_action#">
								<cfgridcolumn name = "id" display = "No">
								<cfgridcolumn name="name" header="Emp. Name" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name = "store_id" display = "No">
								<cfgridcolumn name = "address_id" display = "No">
								<cfgridcolumn name="store_name" header="Store Name" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name="email_addr" header="EMail Addrs" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name="full_address" header="Store Address" width="400" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
							</cfgrid>
						</cfformgroup>
					</cfformgroup>
				</cfformgroup>
			</cfif>

			<cfif (LCase(_focus_area) eq LCase('Addresses'))>
				<cfformgroup  type="Panel" label="Addresses (Cities/States/Zip Codes)" visible="Yes" enabled="Yes">
					<cfformgroup  type="hdividedbox" visible="Yes" enabled="Yes">
						<cfset left_panel_width = 750>
						<cfformgroup  type="accordion" name="accordion1" visible="Yes" enabled="Yes" width="#left_panel_width#">
							<cfformgroup type="page" label="Addresses Data Entry" visible="Yes" enabled="Yes">
								<cfformgroup  type="horizontal" visible="Yes" enabled="Yes">
									<cfsavecontent variable="addresses_new_rb_action">
										addresses_city.visible = false;
										addresses_city_name.visible = true;
										
										addresses_state.visible = false;
										addresses_state_abbrev.visible = true;
										
										addresses_zipcode.visible = false;
										addresses_zipcode_other.visible = true;
									</cfsavecontent>
									
									<cfsavecontent variable="addresses_edit_rb_action">
										addresses_city.visible = true;
										addresses_city_name.visible = false;

										addresses_state.visible = true;
										addresses_state_abbrev.visible = false;

										addresses_zipcode.visible = true;
										addresses_zipcode_other.visible = false;
									</cfsavecontent>
									
									<cfsavecontent variable="addresses_both_rb_action">
										addresses_city.visible = true;
										addresses_city_name.visible = true;

										addresses_state.visible = true;
										addresses_state_abbrev.visible = true;

										addresses_zipcode.visible = true;
										addresses_zipcode_other.visible = true;
									</cfsavecontent>
									
									<cfinput type="Radio" name="addresses_new_rb" value="New Address" checked="No" visible="Yes" enabled="Yes" tooltip="Click this to hide the city/state/zip selections." onclick="#addresses_new_rb_action#">
									<cfinput type="Radio" name="addresses_new_rb" value="Edit Address" checked="No" visible="Yes" enabled="Yes" tooltip="Click this to hide the city/state/zip entry fields." onclick="#addresses_edit_rb_action#">
									<cfinput type="Radio" name="addresses_new_rb" value="Combined Address" checked="Yes" visible="Yes" enabled="Yes" tooltip="Click this to show the city/state/zip selections and entry fields." onclick="#addresses_both_rb_action#">
								</cfformgroup>

								<cfinput type="Text" name="addresses_StreetAddr1" label="Street Address 1:" required="Yes" visible="Yes" enabled="Yes" size="30" maxlength="50">
								<cfinput type="Text" name="addresses_StreetAddr2" label="Street Address 2:" required="No" visible="Yes" enabled="Yes" size="30" maxlength="50">

								<cfscript>
									qGetCityCodes = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT city_name FROM Cities ORDER BY city_name", '');
								</cfscript>
								
								<cfformgroup  type="horizontal" visible="Yes" enabled="Yes" style="margin-left: -115px;">
									<cfselect name="addresses_city" width="150" style="#_style#" label="Choose a City" query="qGetCityCodes" value="city_name" required="No" visible="Yes" enabled="Yes" tooltip="This list is automatically populated from the database to make data entry faster."></cfselect>
									<cfinput type="Text" name="addresses_city_name" label="OR Enter a new City" required="Yes" visible="Yes" enabled="Yes" size="15" maxlength="50" bind="{addresses_city.value}">
								</cfformgroup>

								<cfscript>
									qGetStateCodes = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT state_abbrev FROM States ORDER BY state_abbrev", '');
								</cfscript>

								<cfformgroup  type="horizontal" visible="Yes" enabled="Yes" style="margin-left: -115px;">
									<cfselect name="addresses_state" width="90" style="#_style#" label="Choose a State" query="qGetStateCodes" value="state_abbrev" required="No" visible="Yes" enabled="Yes" tooltip="This list is automatically populated from the database to make data entry faster."></cfselect>
									<cfinput type="Text" name="addresses_state_abbrev" bind="{addresses_state.value}" label="OR Enter a new State:" mask="AA" validateat="onBlur" required="Yes" visible="Yes" enabled="Yes" size="3" maxlength="2">
								</cfformgroup>

								<cfscript>
									qGetZipCodes = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT zipcode FROM ZipCodes ORDER BY zipcode", '');
								</cfscript>

								<cfformgroup  type="horizontal" visible="Yes" enabled="Yes" style="margin-left: -115px;">
									<cfselect name="addresses_zipcode" width="100" style="#_style#" label="Choose a Zip Code" query="qGetZipCodes" value="zipcode" required="No" visible="Yes" enabled="Yes" tooltip="This list is automatically populated from the database to make data entry faster."></cfselect>
									<cfinput type="Text" name="addresses_zipcode_other" bind="{addresses_zipcode.value}" label="OR Enter a new Zip Code" mask="99999+9999" validateat="onBlur" required="Yes" visible="Yes" enabled="Yes" size="11" maxlength="10">
								</cfformgroup>

								<cfformgroup type="horizontal">
									<cfinput type="Submit" name="AddressesDataUpdated" value="[Update]" visible="Yes" enabled="Yes">
									<cfinput type = "reset" name="addresses_reset" width="100" value = "[Reset Fields]">
									<cfformitem  type="html" visible="Yes" enabled="Yes">
										Note: USPS Address Verification is <b><u>not</u></b> being performed at this time.
									</cfformitem>
								</cfformgroup>
							</cfformgroup>
							<cfformgroup type="page" label="Browse Addresses - Select an Address from this grid to populate the data entry fields to edit the data items" visible="Yes" enabled="Yes">
								<cfscript>
									qGetAddresses = Request.primitiveCode.safely_execSQL('', '', Request.DSN, sql_GetAddresses, '');
								</cfscript>

								<cfscript>
									grid_columns_array = ArrayNew( 1);
									grid_columns_array[1] = 30;		// no more than 30
									grid_columns_array[2] = 150;
									grid_columns_array[3] = 150;
									grid_columns_array[4] = 100;
									grid_columns_array[5] = 30;		// no more than 30
									grid_columns_array[6] = 100;	// no more than 100
									grid_columns_array[7] = 50;		// no more than 50
									
									_total = ArraySum(grid_columns_array);
									_left_panel_width = left_panel_width - 46;
									_diff = _left_panel_width - _total;
									_qtr_diff = -1;
									if (_diff gt 0) {
										_qtr_diff = Int(_diff / 4);
										_qtr_diff2 = Int(_qtr_diff / 2);
										grid_columns_array[4] = grid_columns_array[4] + _qtr_diff;
										grid_columns_array[2] = grid_columns_array[2] + _qtr_diff2;
										grid_columns_array[3] = grid_columns_array[3] + _qtr_diff2;
									}
								</cfscript>

								<cfsavecontent variable="AddressesGrid_action">
									function selectThisItem(oObj, itemValue) {
										var a = oObj.dataProvider.slice(0);
										for (var i = 0; i < a.length; i++) {
											if (a[i].data == itemValue) {
												oObj.selectedIndex = i;
												break;
											}
										}
									}

									addresses_StreetAddr1.htmlText = AddressesGrid.dataProvider[AddressesGrid.selectedIndex].street_address1;
									addresses_StreetAddr2.htmlText = AddressesGrid.dataProvider[AddressesGrid.selectedIndex].street_address2;

									selectThisItem(addresses_city, AddressesGrid.dataProvider[AddressesGrid.selectedIndex].city_name);

									selectThisItem(addresses_state, AddressesGrid.dataProvider[AddressesGrid.selectedIndex].state_abbrev);

									selectThisItem(addresses_zipcode, AddressesGrid.dataProvider[AddressesGrid.selectedIndex].zipcode);
									
									accordion1.selectedIndex = 0; // select the Addresses data entry
								</cfsavecontent>

								<cfgrid name="AddressesGrid" width="#_left_panel_width#" query="qGetAddresses" insert="No" delete="No" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="blue" colheaderitalic="No" colheaderbold="Yes" selectmode="BROWSE" picturebar="No" insertbutton="[+]" deletebutton="[-]" onchange="#AddressesGrid_action#">
									<cfgridcolumn name = "id" display = "Yes" width="#grid_columns_array[1]#">
									<cfgridcolumn name="street_address1" header="Addr1" width="#grid_columns_array[2]#" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
									<cfgridcolumn name="street_address2" header="Addr2" width="#grid_columns_array[3]#" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
									<cfgridcolumn name = "city_id" display = "No">
									<cfgridcolumn name="city_name" header="City" width="#grid_columns_array[4]#" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
									<cfgridcolumn name = "state_id" display = "No">
									<cfgridcolumn name="state_abbrev" header="ST" width="#grid_columns_array[5]#" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
									<cfgridcolumn name = "zipcode_id" display = "No">
									<cfgridcolumn name="zipcode" header="Zip Code" width="#grid_columns_array[7]#" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								</cfgrid>
							</cfformgroup>
							<cfformgroup type="page" label="Online Help - Learn how this data entry form was designed and how to best use it for your specific needs" visible="Yes" enabled="Yes">
								<cfformgroup  type="tabnavigator" visible="Yes" enabled="Yes" height="300">
									<cfformgroup type="page" label="Online Help - Part 1" visible="Yes" enabled="Yes">
										<cfformitem  type="html" visible="Yes" enabled="Yes">
											This is a Data Entry Form that was designed to make entering new data or editing existing data fast and easy.<br><br>
											The City and Other City, State and Other State Abbrev, Zip Code and Other Zip Code all have a selection list and entry field which may appear a bit confusion at first glance however in practice makes more sense.<br><br>
										</cfformitem>
									</cfformgroup>
									<cfformgroup type="page" label="Online Help - Part 2" visible="Yes" enabled="Yes">
										<cfformitem  type="html" visible="Yes" enabled="Yes">
											Consider for a moment that you wish to enter a New Address that is composed of a name of a City that may already be in the database.  You would not want to have to enter the City Name that already exists in the database so you simply choose the city name from the selection list.<br><br>
											OR let us suppose that you wish to enter a New Address that is composed of a State Abbreviation that may already be in the database.  You would not want to have to enter the State Abbreviation that already exists in the database so you simply choose the State Abbreviation from the selection list.<br><br>
											OR let us suppose that you wish to enter a New Address that is composed of a Zip Code that may already be in the database.  You would not want to have to enter the Zip Code that already exists in the database so you simply choose the Zip COde from the selection list.<br><br>
											This allows you to more quickly see those Cities, States or Zip Codes that have been previously entered in the database to make it easier to enter or edit Addresses that are composed of items that are already in the database and therefor do not need to be typed in again.<br><br>
										</cfformitem>
									</cfformgroup>
									<cfformgroup type="page" label="Online Help - Part 3" visible="Yes" enabled="Yes">
										<cfformitem  type="html" visible="Yes" enabled="Yes">
											A word about the New Address / Edit Address / Combined Address Radio Buttons<br><br>
											Click the New Address radio button to hide the city / state/ zip code selection lists - do this if you know you want to simply type in the city / state / zip code regardless of what data may be in the database.<br><br>
											Click the Edit Address radio button to hide the city / state/ zip code entry fields - do this if you know you want to simply edit the city / state / zip code using data that is already in the database.<br><br>
											Click the Combined Address radio button to show the city / state/ zip code entry fields and selection lists - do this if you know you want to use the full power of the combined data entry form.<br><br>
										</cfformitem>
									</cfformgroup>
								</cfformgroup>
							</cfformgroup>
							<cfif (Request.CommonCode.isServerLocal())>
								<cfformgroup type="page" label="Debug - #Request.CommonCode.isServerLocal()#" visible="#Request.CommonCode.isServerLocal()#" enabled="Yes">
									<cfformitem  type="html" visible="Yes" enabled="Yes">
										_left_panel_width = [#_left_panel_width#], _total = [#_total#], _diff = [#_diff#], _qtr_diff = [#_qtr_diff#]<br>
										[#grid_columns_array[1]#], [#grid_columns_array[2]#], [#grid_columns_array[3]#], [#grid_columns_array[4]#], [#grid_columns_array[5]#], [#grid_columns_array[6]#], [#grid_columns_array[7]#]<br>
										[#ArraySum(grid_columns_array)#]<br>
									</cfformitem>
								</cfformgroup>
							</cfif>
						</cfformgroup>

						<cfformgroup  type="tabnavigator" visible="Yes" enabled="Yes">
							<cfformgroup  type="page" label="Cities" visible="Yes" enabled="Yes">

								<cfscript>
									qGetCities = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, city_name FROM Cities ORDER BY city_name", '');
								</cfscript>

								<cfformitem  type="html" visible="Yes" enabled="Yes">
									This Grid is Read-Only - shows the contents of the database for verification.
								</cfformitem>
								<cfgrid name="CitiesGrid" width="150" height="200" query="qGetCities" insert="No" delete="No" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="blue" colheaderitalic="No" colheaderbold="Yes" selectmode="BROWSE" picturebar="No" insertbutton="[+]" deletebutton="[-]">
									<cfgridcolumn name = "id" display = "No">
									<cfgridcolumn name="city_name" header="Name" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								</cfgrid><br>
								<cfinput type="Submit" name="CitiesGridUpdated" value="[Update]" visible="No" enabled="Yes">

							</cfformgroup>
							<cfformgroup  type="page" label="States" visible="Yes" enabled="Yes">

								<cfscript>
									qGetStates = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, state_abbrev FROM States ORDER BY state_abbrev", '');
								</cfscript>

								<cfformitem  type="html" visible="Yes" enabled="Yes">
									This Grid is Read-Only - shows the contents of the database for verification.
								</cfformitem>
								<cfgrid name="StatesGrid" width="50" height="200" query="qGetStates" insert="No" delete="No" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="blue" colheaderitalic="No" colheaderbold="Yes" selectmode="BROWSE" picturebar="No" insertbutton="[+]" deletebutton="[-]">
									<cfgridcolumn name = "id" display = "No">
									<cfgridcolumn name="state_abbrev" header="State" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								</cfgrid><br>
								<cfinput type="Submit" name="StatesGridUpdated" value="[Update]" visible="No" enabled="Yes">

							</cfformgroup>
							<cfformgroup  type="page" label="Zip Codes" visible="Yes" enabled="Yes">

								<cfscript>
									qGetZipCodes = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, zipcode FROM ZipCodes ORDER BY zipcode", '');
								</cfscript>

								<cfformitem  type="html" visible="Yes" enabled="Yes">
									This Grid is Read-Only - shows the contents of the database for verification.
								</cfformitem>
								<cfgrid name="ZipCodeGrid" width="100" height="200" query="qGetZipCodes" insert="No" delete="No" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="blue" colheaderitalic="No" colheaderbold="Yes" selectmode="BROWSE" picturebar="No" insertbutton="[+]" deletebutton="[-]">
									<cfgridcolumn name = "id" display = "No">
									<cfgridcolumn name="zipcode" header="Zip Code" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
								</cfgrid><br>
								<cfinput type="Submit" name="zipCodeGridUpdated" value="[Update]" visible="No" enabled="Yes">
								
							</cfformgroup>
						</cfformgroup>
					</cfformgroup>
				</cfformgroup>
			</cfif>

			<cfif (LCase(_focus_area) eq LCase('Phones'))>
				<cfformgroup  type="Panel" label="Phones for Personnel and Stores" visible="Yes" enabled="Yes">
					<cfscript>
						qGetPersonnelList = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, name FROM Personnel ORDER BY name", '');
					</cfscript>

					<cfscript>
						qGetStoreList = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT id, name FROM Stores ORDER BY name", '');
					</cfscript>

					<cfformitem  type="html" visible="Yes" enabled="Yes">
						Choose an Employee or a Store from their respective list below then click either the [Assign Employee Phone] or [Assign Store Phone] button below.
					</cfformitem>

					<cfformgroup  type="horizontal" visible="Yes" enabled="Yes" style="margin-left: -5px;">
						<cfselect name="personnel_name" width="150" style="#_style#" label="Choose an Employee" query="qGetPersonnelList" value="name" required="No" visible="Yes" enabled="Yes" tooltip="This list is automatically populated from the database to make data entry faster."></cfselect>
						<cfselect name="store_name" width="150" style="#_style#" label="Choose a Store" query="qGetStoreList" value="name" required="No" visible="Yes" enabled="Yes" tooltip="This list is automatically populated from the database to make data entry faster."></cfselect>
					</cfformgroup>

					<cfformgroup  type="horizontal" visible="Yes" enabled="Yes" style="margin-left: -5px;">
						<cfinput type="Text" name="employeePhoneNumber" label="Phone:" validate="telephone" required="No" visible="Yes" enabled="Yes" size="24" maxlength="32">
						<cfinput type="Text" name="storePhoneNumber" label="Phone:" validate="telephone" required="No" visible="Yes" enabled="Yes" size="24" maxlength="32">
					</cfformgroup>

					<cfformgroup  type="horizontal" visible="Yes" enabled="Yes" style="margin-left: -5px;">
						<cfinput type="Submit" name="btn_chooseEmployee" value="[Assign Employee Phone]" visible="Yes" enabled="Yes" style="margin-left: 75px; margin-right: 75px;">
						<cfinput type="Submit" name="btn_chooseStore" value="[Assign Store Phone]" visible="Yes" enabled="Yes" style="margin-left: 75px; margin-right: 75px;">
					</cfformgroup>

					<cfscript>
						qGetPersonnelPhone = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT PersonnelPhoneNumbers.id, Personnel.name, PhoneNumbers.phone_number FROM PersonnelPhoneNumbers INNER JOIN Personnel ON PersonnelPhoneNumbers.personnel_id = Personnel.id INNER JOIN PhoneNumbers ON PersonnelPhoneNumbers.phone_id = PhoneNumbers.id ORDER BY Personnel.name, PhoneNumbers.phone_number", '');

						qGetStorePhone = Request.primitiveCode.safely_execSQL('', '', Request.DSN, "SELECT Stores.name, PhoneNumbers.phone_number FROM StorePhoneNumbers INNER JOIN Stores ON StorePhoneNumbers.store_id = Stores.id INNER JOIN PhoneNumbers ON StorePhoneNumbers.phone_id = PhoneNumbers.id ORDER BY Stores.name, PhoneNumbers.phone_number", '');
					</cfscript>

 					<cfformgroup  type="horizontal" style="margin-left: -5px;" visible="Yes" enabled="Yes">
						<cfformgroup  type="vertical" width="320" style="margin-left: -5px;" visible="Yes" enabled="Yes">
							<cfgrid name="PersonnelPhoneGrid" height="150" width="300" query="qGetPersonnelPhone" insert="No" delete="Yes" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="##0000FF" colheaderitalic="No" colheaderbold="Yes" selectmode="EDIT" picturebar="No" deletebutton="[-]">
								<cfgridcolumn name="name" header="Emp. Name" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="No" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name="phone_number" header="Phone ##" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
							</cfgrid>
		
							<cfinput type="Submit" name="btn_UpdateEmpPhoneGrid" value="[Upd Employee Phone]" visible="Yes" enabled="Yes">
						</cfformgroup>
						<cfformgroup  type="vertical" width="320" style="margin-left: -5px;" visible="Yes" enabled="Yes">
							<cfgrid name="StorePhoneGrid" height="150" width="300" query="qGetStorePhone" insert="No" delete="Yes" sort="Yes" font="Verdana" bold="No" italic="No" autowidth="true" appendkey="No" highlighthref="No" enabled="Yes" visible="Yes" griddataalign="LEFT" gridlines="Yes" rowheaders="No" rowheaderalign="LEFT" rowheaderitalic="No" rowheaderbold="No" colheaders="Yes" colheaderalign="LEFT" colheadertextcolor="##0000FF" colheaderitalic="No" colheaderbold="Yes" selectmode="EDIT" picturebar="No" deletebutton="[-]">
								<cfgridcolumn name="name" header="Emp. Name" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="No" display="Yes" headerbold="No" headeritalic="No">
								<cfgridcolumn name="phone_number" header="Phone ##" width="150" headeralign="CENTER" dataalign="LEFT" bold="Yes" italic="No" select="Yes" display="Yes" headerbold="No" headeritalic="No">
							</cfgrid>
		
							<cfinput type="Submit" name="btn_UpdateStorePhoneGrid" value="[Upd Store Phone]" visible="Yes" enabled="Yes">
						</cfformgroup>
					</cfformgroup>
				</cfformgroup>
			</cfif>
		</cfform>
	<cfelse>
		#RepeatString('<br>', Abs(1 - Len(_filler_spaces)))#
		<h3 align="center">Please choose a function from the menubar above...</h3>
		#RepeatString('<br>', 25)#
	</cfif>

<cfif (Len(Trim(_focus_area)) gt 0)>
	<cfset Client._focus_area = _focus_area>
</cfif>
	
<script language="JavaScript1.2" type="text/javascript">
<!--//
	parent.confirmFlashLoaded();
//-->
</script>

</cfoutput>
