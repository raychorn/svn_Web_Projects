<!--- BEGIN: This block of code sets-up the Request.qryObj which is a ColdFusion Query Object that holds the parms from the AJAX call --->
<!--- Request.qryStruct also contains the variables that were passed-in from the caller... --->
<cfinclude template="cfinclude_AJAX_Begin.cfm">
<!--- END! This block of code sets-up the Request.qryObj which is a ColdFusion Query Object that holds the parms from the AJAX call --->

<cfsavecontent variable="sql_qGetMenuGroupNames">
	<cfoutput>
		SELECT AvnMenuGroups.id, AvnMenuGroups.menu_id, AvnMenu.menuName, AvnMenuGroups.group_id, AvnGroupName.layerGroupName, AvnMenuGroups.disp_order
		FROM AvnMenuGroups INNER JOIN
		     AvnMenu ON AvnMenuGroups.menu_id = AvnMenu.id INNER JOIN
		     AvnGroupName ON AvnMenuGroups.group_id = AvnGroupName.id
		ORDER BY AvnMenuGroups.disp_order, AvnMenu.menuName, AvnGroupName.layerGroupName;
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="sql_qGetLayerGroupNames">
	<cfoutput>
		SELECT AvnLayerGroups.id, AvnLayerGroups.AvnGroupNameID, AvnGroupName.layerGroupName, AvnLayerGroups.AvnLayerID, AvnLayer.layerDisplayName, 
		       AvnLayerGroups.disp_order
		FROM AvnLayerGroups INNER JOIN
		     AvnLayer ON AvnLayerGroups.AvnLayerID = AvnLayer.id INNER JOIN
		     AvnGroupName ON AvnLayerGroups.AvnGroupNameID = AvnGroupName.id
		ORDER BY AvnLayerGroups.disp_order, AvnGroupName.layerGroupName, AvnLayer.layerDisplayName;
	</cfoutput>
</cfsavecontent>

<!--- BEGIN: This block of code was provided by WeatherNews (Bryan Reinhardt) and may not work going forward since the author of this code had no idea what this was was designed to do... --->
<cfsavecontent variable="sql_qGetMonoLithicMenuRecs">
	<cfoutput>
		SELECT e1.id as id, 
		CASE e1.srcTableName
		         WHEN 'AvnMenu' THEN (SELECT TOP 1 menuName FROM AvnMenu WHERE (id = e1.srcId))
		          WHEN 'AvnGroupName' THEN ( SELECT TOP 1 gn.layerGroupName FROM AvnGroupName as gn WHERE gn.id = e1.srcId )
		          WHEN 'AvnLayer' THEN ( SELECT TOP 1 lyr.layerDisplayName FROM AvnLayer as lyr WHERE lyr.id = e1.srcId )
		          ELSE 'Placeholder'
		END as prompt,
		e1.srcTableName as srcTableName, 
		e1.srcId as srcId,
		e1.menuUUID as menuUUID,
		e1.parent_id as parent_id, 
		( SELECT DISTINCT p1.menuUUID
		         FROM AvnMenuEditor as p1
		         WHERE p1.id = e1.parent_id ) as parentUUID,
		e1.dispOrder as dispOrder
		FROM AvnMenuEditor as e1
		ORDER BY e1.parent_id, e1.dispOrder
 	</cfoutput>
</cfsavecontent>
<!--- END! This block of code was provided by WeatherNews (Bryan Reinhardt) and may not work going forward since the author of this code had no idea what this was was designed to do... --->

<!--- This is where you may code your ColdFusion code that processes the AJAX Function --->
<cfscript>
	bool_onChangeSubMenu = false;
	switch (Request.qryStruct.cfm) {
		case 'onDeleteMenuItem':
			if (Request.qryStruct.argCnt gt 0) {
				ar = ArrayNew(1);
				for (i = 2; i lte Request.qryStruct.argCnt; i = i + 1) {
					ar[ArrayLen(ar) + 1] = Request.commonCode.filterIntForSQL(Request.qryStruct['arg#i#']);
				}
				_sql_statement = "DELETE FROM AvnMenuEditor WHERE (menuUUID in ('#ArrayToList(ar, "','")#')); ";
				Request.commonCode.safely_execSQL('Request.qOnDeleteMenuItem', Request.INTRANET_DS, _sql_statement & sql_qGetMonoLithicMenuRecs);

				if (NOT Request.dbError) {
					// reorder the siblings for each deleted item... 
					_sql_statement = "SELECT id, dispOrder FROM Request.qOnDeleteMenuItem WHERE (parentUUID = '#Request.commonCode.filterIntForSQL(Request.qryStruct.arg1)#') ORDER BY dispOrder";
					Request.commonCode.safely_execSQL('Request.qOnDeleteReorderSiblings', '', _sql_statement);
					if (NOT Request.dbError) {
						_sql_statement = "";
						for (i = 1; i lte Request.qOnDeleteReorderSiblings.recordCount; i = i + 1) {
							_sql_statement = _sql_statement & "UPDATE AvnMenuEditor SET dispOrder = #(i - 1)# WHERE (id = #Request.qOnDeleteReorderSiblings.id#); ";
						}
						Request.commonCode.safely_execSQL('Request.qOnDeleteUpdateSiblings', Request.INTRANET_DS, _sql_statement & sql_qGetMonoLithicMenuRecs);
						if (NOT Request.dbError) {
							Request.commonCode.registerQueryFromAJAX(Request.qOnDeleteUpdateSiblings);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: onDeleteMenuItem - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'onPasteSubMenu':
			if (Request.qryStruct.argCnt gte 3) {
				// look-up the menu item being acted upon using the '#Request.commonCode.filterIntForSQL(Request.qryStruct.arg1)#' -> menuUUID and the #Request.commonCode.filterIntForSQL(Request.qryStruct.arg2)# -> dispOrder
				// what is the parent_id ?  this tells us the family and the siblings we need to act upon...
				self_id = -1;
				parent_id = -1;
				Request.commonCode.safely_execSQL('Request.qLookupParentsID', Request.INTRANET_DS, "SELECT id, parent_id FROM AvnMenuEditor WHERE (menuUUID = '#Request.commonCode.filterIntForSQL(Request.qryStruct.arg1)#')");
				if (NOT Request.dbError) {
					self_id = Request.qLookupParentsID.id;
					parent_id = Request.qLookupParentsID.parent_id;
				}
				
				if (self_id neq -1) {
					Request.commonCode.safely_execSQL('Request.qLookupParentsKids', Request.INTRANET_DS, "SELECT id, menuUUID, dispOrder FROM AvnMenuEditor WHERE (parent_id = #parent_id#) ORDER BY dispOrder"); //  AND (id <> #self_id#)
					if (NOT Request.dbError) {
						// is there a collision between the #Request.commonCode.filterIntForSQL(Request.qryStruct.arg2)# -> dispOrder we want to use and any existing dispOrders in-use by the siblings ?
						// in other words, make sure the resulting dispOrders are sequential from 0 through the max based on the item count AFTER the potential collion is resolved...
						_sql_statement = "";
						newDispOrder = Request.commonCode.filterIntForSQL(Request.qryStruct.arg2);
						Request.commonCode.safely_execSQL('Request.qLookupSiblingDispOrderCollisions', '', "SELECT id, menuUUID, dispOrder FROM Request.qLookupParentsKids ORDER BY dispOrder");
						if (NOT Request.dbError) {
							if (Request.qLookupSiblingDispOrderCollisions.RecordCount gt 0) {
								_ar = ArrayNew(1);
								for (i = 1; i lte Request.qLookupParentsKids.RecordCount; i = i + 1) {
									if (Request.qLookupParentsKids.id[i] neq self_id) {
										_ar[ArrayLen(_ar) + 1] = Request.qLookupParentsKids.id[i];
									}
								}
								try {
									ArrayInsertAt( _ar, newDispOrder + 1, self_id);
								} catch (Any e) {
									_ar[ArrayLen(_ar) + 1] = self_id;
								}

								for (i = 1; i lte ArrayLen(_ar); i = i + 1) {
									_sql_statement = _sql_statement & "UPDATE AvnMenuEditor SET dispOrder = #(i - 1)# WHERE (id = #_ar[i]#); ";
								}
							}
						}
						
						_sql_statement = _sql_statement & "UPDATE AvnMenuEditor SET parent_id = #parent_id# WHERE (id = #self_id#); ";
						Request.commonCode.safely_execSQL('Request.qOnPasteSubMenu', Request.INTRANET_DS, _sql_statement & sql_qGetMonoLithicMenuRecs);
		
						if (NOT Request.dbError) {
							Request.commonCode.registerQueryFromAJAX(Request.qOnPasteSubMenu);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: onPasteSubMenu - Unable to determine the siblings based on the parent - possible programming error or database corruption.', qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: onPasteSubMenu - Unable to determine the parent id based on the MenuUUID - possible programming error or database corruption.', qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: onPasteSubMenu - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'onChangeSubMenu':
			bool_onChangeSubMenu = true;
		case 'onCommitSubMenu':
			if (Request.qryStruct.argCnt gte 5) {
				parent_uuid = Request.commonCode.filterIntForSQL(Request.qryStruct.arg4);
				
				parent_id = -1;
				if (parent_uuid neq -1) {
					Request.commonCode.safely_execSQL('Request.qLookupParentsUUID', Request.INTRANET_DS, "SELECT id FROM AvnMenuEditor WHERE (menuUUID = '#parent_uuid#')");
					if (NOT Request.dbError) {
						parent_id = Request.qLookupParentsUUID.id;
					}
				}

				if (bool_onChangeSubMenu) {
					_sql_statement = "";
					if (IsDefined("Request.qryStruct.arg1")) {
						_sql_statement = _sql_statement & "srcTableName = '#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#'";
					}
					if (IsDefined("Request.qryStruct.arg2")) {
						srcId = Request.commonCode.filterIntForSQL(Request.qryStruct.arg2);
						if (srcId neq -1) {
							if (Len(_sql_statement) gt 0) {
								_sql_statement = _sql_statement & ", ";
							}
							_sql_statement = _sql_statement & "srcId = #srcId#";
						}
					}
					if (parent_id neq -1) {
						if (Len(_sql_statement) gt 0) {
							_sql_statement = _sql_statement & ", ";
						}
						_sql_statement = _sql_statement & "parent_id = #parent_id#";
					}
					if (IsDefined("Request.qryStruct.arg5")) {
						if (Len(_sql_statement) gt 0) {
							_sql_statement = _sql_statement & ", ";
						}
						_sql_statement = _sql_statement & "dispOrder = #Request.commonCode.filterIntForSQL(Request.qryStruct.arg5)#";
					}
					_sql_statement = "UPDATE AvnMenuEditor SET " & _sql_statement & " WHERE (menuUUID = '#Request.commonCode.filterIntForSQL(Request.qryStruct.arg3)#'); ";
					Request.commonCode.safely_execSQL('Request.qOnCommitSubMenu', Request.INTRANET_DS, _sql_statement & sql_qGetMonoLithicMenuRecs);
				} else {
					_newUUID = Request.commonCode.filterIntForSQL(Request.qryStruct.arg3) & '1';
					Request.commonCode.safely_execSQL('Request.qOnCommitSubMenu', Request.INTRANET_DS, "INSERT INTO AvnMenuEditor (srcTableName, srcId, menuUUID, parent_id, dispOrder) VALUES ('#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#',#Request.commonCode.filterIntForSQL(Request.qryStruct.arg2)#,'#Request.commonCode.filterIntForSQL(Request.qryStruct.arg3)#',#parent_id#,#Request.commonCode.filterIntForSQL(Request.qryStruct.arg5)#); DECLARE @ID as int; SELECT @ID = @@IDENTITY; INSERT INTO AvnMenuEditor (srcTableName, srcId, menuUUID, parent_id, dispOrder) VALUES ('+++',-1,'#_newUUID#',@ID,0); " & sql_qGetMonoLithicMenuRecs);
				}

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qOnCommitSubMenu);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: qOnCommitSubMenu - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'onCommitMenuItem':
			if (Request.qryStruct.argCnt gte 5) {
				parent_uuid = Request.commonCode.filterIntForSQL(Request.qryStruct.arg4);
				
				parent_id = -1;
				if (parent_uuid neq -1) {
					Request.commonCode.safely_execSQL('Request.qLookupParentsUUID', Request.INTRANET_DS, "SELECT id FROM AvnMenuEditor WHERE (menuUUID = '#parent_uuid#')");
					if (NOT Request.dbError) {
						parent_id = Request.qLookupParentsUUID.id;
					}
				}

				Request.commonCode.safely_execSQL('Request.qOnCommitMenuItem', Request.INTRANET_DS, "INSERT INTO AvnMenuEditor (srcTableName, srcId, menuUUID, parent_id, dispOrder) VALUES ('#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#',#Request.commonCode.filterIntForSQL(Request.qryStruct.arg2)#,'#Request.commonCode.filterIntForSQL(Request.qryStruct.arg3)#',#parent_id#,#Request.commonCode.filterIntForSQL(Request.qryStruct.arg5)#); " & sql_qGetMonoLithicMenuRecs);

				if (NOT Request.dbError) {
					_sql_statement = "SELECT id, dispOrder FROM Request.qOnCommitMenuItem WHERE (parent_id = #parent_id#) ORDER BY dispOrder";
					Request.commonCode.safely_execSQL('Request.qOnCommitReorderSiblings', '', _sql_statement);
					if (NOT Request.dbError) {
						_sql_statement = "";
						for (i = 1; i lte Request.qOnCommitReorderSiblings.recordCount; i = i + 1) {
							_sql_statement = _sql_statement & "UPDATE AvnMenuEditor SET dispOrder = #(i - 1)# WHERE (id = #Request.qOnCommitReorderSiblings.id[i]#); ";
						}
						Request.commonCode.safely_execSQL('Request.qOnCommitUpdateSiblings', Request.INTRANET_DS, _sql_statement & sql_qGetMonoLithicMenuRecs);

						if (NOT Request.dbError) {
							Request.commonCode.registerQueryFromAJAX(Request.qOnCommitUpdateSiblings);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: qOnCommitMenuItem - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'getMenuEditorContents':
			Request.commonCode.safely_execSQL('Request.qGetMenuEditorContents', Request.INTRANET_DS, sql_qGetMonoLithicMenuRecs);

			if (NOT Request.dbError) {
				Request.commonCode.registerQueryFromAJAX(Request.qGetMenuEditorContents); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
				QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;
		
		case 'getLayerGroupNames':
			Request.commonCode.safely_execSQL('Request.qGetLayerGroupNames', Request.INTRANET_DS, sql_qGetLayerGroupNames);

			if (NOT Request.dbError) {
				Request.commonCode.registerQueryFromAJAX(Request.qGetLayerGroupNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
				QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'saveLayerName_v': // the variable version of this command - requires a variable number of cols to be handled...
			if (Request.qryStruct.argCnt gt 0) {
				// Request.qryStruct.arg1 contains the number of instances to save... however since this command requires 4 pieces of data per instance we need to handle it that way...
				subArgCnt = Request.commonCode.filterIntForSQL(Request.qryStruct.arg1);
				numInstances = Int(subArgCnt / 4);
				_sql_statement = '';
				vArgI = 2;
				for (i = 1; i lte numInstances; i = i + 1) {
					vArg1Name = 'arg' & vArgI;
					vArgIdName = 'arg' & (vArgI + 1);
					vArg2Name = 'arg' & (vArgI + 2);
					_sql_statement = _sql_statement & "UPDATE AvnLayer SET layerName = '#Request.commonCode.filterQuotesForSQL(Request.qryStruct[vArg1Name])#', layerDisplayName = '#Request.commonCode.filterQuotesForSQL(Request.qryStruct[vArg2Name])#' WHERE (id = #Request.commonCode.filterIntForSQL(Request.qryStruct[vArgIdName])#); ";
					vArgI = vArgI + 4;
				}

				Request.commonCode.safely_execSQL('Request.qSaveLayerName', Request.INTRANET_DS, _sql_statement & "SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qSaveLayerName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg' & ', _sql_statement = [#_sql_statement#]', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'addLayerName_v': // the variable version of this command - requires a variable number of cols to be handled...
			if (Request.qryStruct.argCnt gt 0) {
				// Request.qryStruct.arg1 contains the number of instances to save... however since this command requires 2 pieces of data per instance we need to handle it that way...
				subArgCnt = Request.commonCode.filterIntForSQL(Request.qryStruct.arg1);
				numInstances = Int(subArgCnt / 2);
				_sql_statement = '';
				for (i = 1; i lte numInstances; i = i + 1) {
					vArg1Name = 'arg' & (2 * i);
					vArg2Name = 'arg' & ((2 * i) + 1);
					_sql_statement = _sql_statement & "INSERT INTO AvnLayer (layerName, layerDisplayName) VALUES ('#Request.commonCode.filterQuotesForSQL(Request.qryStruct[vArg1Name])#','#Request.commonCode.filterQuotesForSQL(Request.qryStruct[vArg2Name])#'); ";
				}

				Request.commonCode.safely_execSQL('Request.qAddLayerName', Request.INTRANET_DS, _sql_statement & "SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qAddLayerName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg' & ', _sql_statement = [#_sql_statement#]', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'addLayerName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qAddLayerName', Request.INTRANET_DS, "INSERT INTO AvnLayer (layerName, layerDisplayName) VALUES ('#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#','#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg2)#'); SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qAddLayerName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'saveLayerName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qSaveLayerName', Request.INTRANET_DS, "UPDATE AvnLayer SET layerName = '#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#', layerDisplayName = '#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#' WHERE (id = #Request.commonCode.filterIntForSQL(Request.qryStruct.arg3)#); SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qSaveLayerName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'dropLayerName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qDropLayerName', Request.INTRANET_DS, "DELETE FROM AvnLayer WHERE (id = #Request.commonCode.filterIntForSQL(Request.qryStruct.arg1)#); SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qDropLayerName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'encryptJSCode':
			const_openScript = '<script';
			const_closeScript = '</script>';

			if (Request.qryStruct.argCnt gt 0) {
				qObj = QueryNew('id, name, val');
				
				actualArgCnt = 0;
				for (i = 1; i lte Request.qryStruct.argCnt; i = i + 1) {
					isError = false;
					try {
						aLineOfCode = Request.qryStruct['arg' & i];
					} catch (Any e) {
						aLineOfCode = '';
						isError = true;
					}

					if ( (FindNoCase(const_openScript, aLineOfCode) gt 0) OR (FindNoCase(const_closeScript, aLineOfCode) gt 0) ) {
						aLineOfCode = '';
					}
					
					if (Len(aLineOfCode) gt 0) {
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'name', 'arg' & actualArgCnt, qObj.recordCount);
						QuerySetCell(qObj, 'val', Request.commonCode.encodedEncryptedString2(aLineOfCode), qObj.recordCount);

						if (isError eq false) {
							actualArgCnt = actualArgCnt + 1;
						}
					}
				}
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'name', 'argCnt', qObj.recordCount);
				QuerySetCell(qObj, 'val', actualArgCnt - 1, qObj.recordCount);
				
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: encryptJSCode - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'setMenuGroupDispOrder':
			if (Request.qryStruct.argCnt gt 0) {
				ar = ListToArray(Request.qryStruct.arg1, '_');
				arLen = ArrayLen(ar);
				n = ar[arLen - 2];
				m = ar[arLen - 1];
				id = ar[arLen];

				Request.commonCode.safely_execSQL('Request.qSetMenuGroupDispOrder', Request.INTRANET_DS, "UPDATE AvnMenuGroups SET disp_order = #Request.commonCode.filterIntForSQL(Request.qryStruct.arg2)# WHERE (id = #id#); " & sql_qGetMenuGroupNames);

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qSetMenuGroupDispOrder);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: setMenuGroupDispOrder - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		
			if (0) {
				qObj = QueryNew('id, argCnt, arg1, arLen, n, m, recid');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'argCnt', Request.qryStruct.argCnt, qObj.recordCount);
				QuerySetCell(qObj, 'arg1', Request.qryStruct.arg1, qObj.recordCount);
				QuerySetCell(qObj, 'arLen', arLen, qObj.recordCount);
				QuerySetCell(qObj, 'n', n, qObj.recordCount);
				QuerySetCell(qObj, 'm', m, qObj.recordCount);
				QuerySetCell(qObj, 'recid', id, qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'dropMenuGroupAssociation':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qDropMenuGroupAssociation', Request.INTRANET_DS, "DELETE FROM AvnMenuGroups WHERE (id = #Request.commonCode.filterIntForSQL(Request.qryStruct.arg1)#); " & sql_qGetMenuGroupNames);
	
				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qDropMenuGroupAssociation);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: dropTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'saveMenuGroupAssociation':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qSaveMenuGroupAssociation', Request.INTRANET_DS, "INSERT INTO AvnMenuGroups (menu_id, group_id) VALUES (#Request.commonCode.filterIntForSQL(Request.qryStruct.arg1)#,#Request.commonCode.filterIntForSQL(Request.qryStruct.arg2)#); " & sql_qGetMenuGroupNames);

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qSaveMenuGroupAssociation);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: saveMenuGroupAssociation - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'getMenuGroupNames':
			Request.commonCode.safely_execSQL('Request.qGetMenuGroupNames', Request.INTRANET_DS, sql_qGetMenuGroupNames);

			if (NOT Request.dbError) {
				Request.commonCode.registerQueryFromAJAX(Request.qGetMenuGroupNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
				QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'saveTopLevelMenuName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qSaveTopLevelMenuName', Request.INTRANET_DS, "UPDATE AvnMenu SET menuName = '#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#' WHERE (id = #Request.commonCode.filterIntForSQL(Request.qryStruct.arg2)#); SELECT id, menuName FROM AvnMenu ORDER BY menuName");

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qSaveTopLevelMenuName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: dropTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'dropTopLevelMenuName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qDropTopLevelMenuName', Request.INTRANET_DS, "DELETE FROM AvnMenu WHERE (id = #Request.commonCode.filterIntForSQL(Request.qryStruct.arg1)#); SELECT id, menuName FROM AvnMenu ORDER BY menuName");
	
				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qDropTopLevelMenuName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: dropTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'addTopLevelMenuName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qAddTopLevelMenuName', Request.INTRANET_DS, "INSERT INTO AvnMenu (menuName) VALUES ('#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#'); SELECT id, menuName FROM AvnMenu ORDER BY menuName");
	
				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qAddTopLevelMenuName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'getLayerNames':
			Request.commonCode.safely_execSQL('Request.qGetLayerNames', Request.INTRANET_DS, "SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerDisplayName, layerName");

			if (NOT Request.dbError) {
				Request.commonCode.registerQueryFromAJAX(Request.qGetLayerNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
				QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'getGroupNames':
			Request.commonCode.safely_execSQL('Request.qGetGroupNames', Request.INTRANET_DS, "SELECT id, layerGroupName FROM AvnGroupName ORDER BY layerGroupName");

			if (NOT Request.dbError) {
				Request.commonCode.registerQueryFromAJAX(Request.qGetGroupNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
				QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'addGroupName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qAddGroupName', Request.INTRANET_DS, "INSERT INTO AvnGroupName (layerGroupName) VALUES ('#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#'); SELECT id, layerGroupName FROM AvnGroupName ORDER BY layerGroupName");

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qAddGroupName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'saveGroupName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qSaveGroupName', Request.INTRANET_DS, "UPDATE AvnGroupName SET layerGroupName = '#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#' WHERE (id = #Request.commonCode.filterIntForSQL(Request.qryStruct.arg2)#); SELECT id, layerGroupName FROM AvnGroupName ORDER BY layerGroupName");

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qSaveGroupName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'dropGroupName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qDropGroupName', Request.INTRANET_DS, "DELETE FROM AvnGroupName WHERE (id = #Request.commonCode.filterIntForSQL(Request.qryStruct.arg1)#); SELECT id, layerGroupName FROM AvnGroupName ORDER BY layerGroupName");

				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qDropGroupName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'getTopLevelMenuNames':
			Request.commonCode.safely_execSQL('Request.qGetTopLevelMenuNames', Request.INTRANET_DS, "SELECT id, menuName FROM AvnMenu ORDER BY menuName");
			
			if (NOT Request.dbError) {
				Request.commonCode.registerQueryFromAJAX(Request.qGetTopLevelMenuNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
				QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;
	}
</cfscript>
<!--- the name of the cfm page is stored in the following variable: Request.qryObj.NAME["cfm"] --->

<!--- BEGIN: This block of code passes the Request.qryObj which is a ColdFusion Query Object back to the AJAX caller via a JavaScript object called qObj --->
<cfinclude template="cfinclude_AJAX_End.cfm">
<!--- END! This block of code passes the Request.qryObj which is a ColdFusion Query Object back to the AJAX caller via a JavaScript object called qObj --->
