<cfcomponent displayname="ajaxFunctions" output="Yes" extends="ajaxCode">
	<cffunction name="doAJAXFunction" access="public" returntype="Any">
		<cfscript>
			beginAJAX();
		</cfscript>

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
		
		<cfsavecontent variable="sql_qGetMonoLithicMenuRecs">
			<cfoutput>
				CREATE TABLE ##GetGetMonoLithicMenuRecsTemp (id int, prompt varchar(1024), srcTableName varchar(50), srcId int, menuUUID varchar(32), parent_id int, dispOrder int)
				
				INSERT INTO ##GetGetMonoLithicMenuRecsTemp (id, prompt, srcTableName, srcId, menuUUID, parent_id, dispOrder)
					SELECT id, 
				      CASE srcTableName
				         WHEN 'AvnMenu' THEN (SELECT menuName FROM AvnMenu WHERE (id = srcId))
				         WHEN 'AvnGroupName' THEN (SELECT layerGroupName FROM AvnGroupName WHERE (id = srcId))
				         WHEN 'AvnLayer' THEN (SELECT layerDisplayName FROM AvnLayer WHERE (id = srcId))
				         ELSE ''
				      END as prompt,
					srcTableName, 
					srcId,
					menuUUID, 
					parent_id, 
					dispOrder
					FROM AvnMenuEditor
					ORDER BY dispOrder
				
				SELECT * FROM ##GetGetMonoLithicMenuRecsTemp
				
				DROP TABLE ##GetGetMonoLithicMenuRecsTemp
			</cfoutput>
		</cfsavecontent>
		
		<cfsavecontent variable="html_theForm">
			<cfoutput>
				<form id="form_enkrip">
					<TEXTAREA class="textClass" rows="8" name="kodeawal" id="kodeawal" cols="70" wrap="virtual"></TEXTAREA> 
					<TEXTAREA class="textClass" readonly rows="8" name="hasil" id="hasil" cols="70" wrap="virtual"></TEXTAREA>
					<br><span class="textClass">Key:&nbsp;</span><input type="text" class="textClass" name="parameter" value="2" size="30" maxlength="50"> 
					<br><span class="textClass">Input Length:&nbsp;</span><input type="text" class="textClass" id="form_enkrip_input_length" size="11" />
					<br><span class="textClass">Diff Length:&nbsp;</span><input type="text" class="textClass" name="form_enkrip_diff_length" size="11" />
					<br><span class="textClass">Enkrip Length:&nbsp;</span><input type="text" class="textClass" name="form_enkrip_enkrip_length" size="11" />
				</form>
			</cfoutput>
		</cfsavecontent>
		
		<!--- This is where you may code your ColdFusion code that processes the AJAX Function --->
		<cfscript>
			switch (Request.qryStruct.cfm) {
				case 'performJsCompilerTest':
					qObj = QueryNew('id, status, theForm');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'status', '-1', qObj.recordCount);
					QuerySetCell(qObj, 'theForm', URLEncodedFormat(html_theForm), qObj.recordCount);
					registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				break;
		
				case 'performEmailTest':
					safely_cfmail('rabid_one@contentopia.net', 'raychorn@sbcglobal.net', 'Re: Testing', 'Testing 1.2.3.');
		
					qObj = QueryNew('id, status');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'status', 'Request.anError = [#Request.anError#], Request.errorMsg = [#Request.errorMsg#]', qObj.recordCount);
					registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				break;
		
				case 'onCommitSubMenu':
					if (Request.qryStruct.argCnt eq 5) {
						safely_execSQL('Request.qOnCommitSubMenu', Request.INTRANET_DS, "INSERT INTO AvnMenuEditor (srcTableName, srcId, menuUUID, parent_id, dispOrder) VALUES ('#filterQuotesForSQL(Request.qryStruct.arg1)#',#filterIntForSQL(Request.qryStruct.arg2)#,'#filterIntForSQL(Request.qryStruct.arg3)#',#filterIntForSQL(Request.qryStruct.arg4)#,#filterIntForSQL(Request.qryStruct.arg5)#); " & sql_qGetMonoLithicMenuRecs);
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qOnCommitSubMenu);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: qOnCommitSubMenu - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'onCommitMenuItem':
					if (Request.qryStruct.argCnt eq 5) {
						safely_execSQL('Request.qOnCommitMenuItem', Request.INTRANET_DS, "INSERT INTO AvnMenuEditor (srcTableName, srcId, menuUUID, parent_id, dispOrder) VALUES ('#filterQuotesForSQL(Request.qryStruct.arg1)#',#filterIntForSQL(Request.qryStruct.arg2)#,'#filterIntForSQL(Request.qryStruct.arg3)#',#filterIntForSQL(Request.qryStruct.arg4)#,#filterIntForSQL(Request.qryStruct.arg5)#); " & sql_qGetMonoLithicMenuRecs);
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qOnCommitMenuItem);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: qOnCommitMenuItem - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'getMenuEditorContents':
					safely_execSQL('Request.qGetMenuEditorContents', Request.INTRANET_DS, sql_qGetMonoLithicMenuRecs);
		
					if (NOT Request.dbError) {
						registerQueryFromAJAX(Request.qGetMenuEditorContents); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
				
				case 'getLayerGroupNames':
					safely_execSQL('Request.qGetLayerGroupNames', Request.INTRANET_DS, sql_qGetLayerGroupNames);
		
					if (NOT Request.dbError) {
						registerQueryFromAJAX(Request.qGetLayerGroupNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'saveLayerName_v': // the variable version of this command - requires a variable number of cols to be handled...
					if (Request.qryStruct.argCnt gt 0) {
						// Request.qryStruct.arg1 contains the number of instances to save... however since this command requires 4 pieces of data per instance we need to handle it that way...
						subArgCnt = filterIntForSQL(Request.qryStruct.arg1);
						numInstances = Int(subArgCnt / 4);
						_sql_statement = '';
						vArgI = 2;
						for (i = 1; i lte numInstances; i = i + 1) {
							vArg1Name = 'arg' & vArgI;
							vArgIdName = 'arg' & (vArgI + 1);
							vArg2Name = 'arg' & (vArgI + 2);
							_sql_statement = _sql_statement & "UPDATE AvnLayer SET layerName = '#filterQuotesForSQL(Request.qryStruct[vArg1Name])#', layerDisplayName = '#filterQuotesForSQL(Request.qryStruct[vArg2Name])#' WHERE (id = #filterIntForSQL(Request.qryStruct[vArgIdName])#); ";
							vArgI = vArgI + 4;
						}
		
						safely_execSQL('Request.qSaveLayerName', Request.INTRANET_DS, _sql_statement & "SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qSaveLayerName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg' & ', _sql_statement = [#_sql_statement#]', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'addLayerName_v': // the variable version of this command - requires a variable number of cols to be handled...
					if (Request.qryStruct.argCnt gt 0) {
						// Request.qryStruct.arg1 contains the number of instances to save... however since this command requires 2 pieces of data per instance we need to handle it that way...
						subArgCnt = filterIntForSQL(Request.qryStruct.arg1);
						numInstances = Int(subArgCnt / 2);
						_sql_statement = '';
						for (i = 1; i lte numInstances; i = i + 1) {
							vArg1Name = 'arg' & (2 * i);
							vArg2Name = 'arg' & ((2 * i) + 1);
							_sql_statement = _sql_statement & "INSERT INTO AvnLayer (layerName, layerDisplayName) VALUES ('#filterQuotesForSQL(Request.qryStruct[vArg1Name])#','#filterQuotesForSQL(Request.qryStruct[vArg2Name])#'); ";
						}
		
						safely_execSQL('Request.qAddLayerName', Request.INTRANET_DS, _sql_statement & "SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qAddLayerName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg' & ', _sql_statement = [#_sql_statement#]', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'addLayerName':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qAddLayerName', Request.INTRANET_DS, "INSERT INTO AvnLayer (layerName, layerDisplayName) VALUES ('#filterQuotesForSQL(Request.qryStruct.arg1)#','#filterQuotesForSQL(Request.qryStruct.arg2)#'); SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qAddLayerName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'saveLayerName':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qSaveLayerName', Request.INTRANET_DS, "UPDATE AvnLayer SET layerName = '#filterQuotesForSQL(Request.qryStruct.arg1)#', layerDisplayName = '#filterQuotesForSQL(Request.qryStruct.arg1)#' WHERE (id = #filterIntForSQL(Request.qryStruct.arg3)#); SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qSaveLayerName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'dropLayerName':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qDropLayerName', Request.INTRANET_DS, "DELETE FROM AvnLayer WHERE (id = #filterIntForSQL(Request.qryStruct.arg1)#); SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerName");
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qDropLayerName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
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
								QuerySetCell(qObj, 'val', encodedEncryptedString2(aLineOfCode), qObj.recordCount);
		
								if (isError eq false) {
									actualArgCnt = actualArgCnt + 1;
								}
							}
						}
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'name', 'argCnt', qObj.recordCount);
						QuerySetCell(qObj, 'val', actualArgCnt - 1, qObj.recordCount);
						
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: encryptJSCode - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'setMenuGroupDispOrder':
					if (Request.qryStruct.argCnt gt 0) {
						ar = ListToArray(Request.qryStruct.arg1, '_');
						arLen = ArrayLen(ar);
						n = ar[arLen - 2];
						m = ar[arLen - 1];
						id = ar[arLen];
		
						safely_execSQL('Request.qSetMenuGroupDispOrder', Request.INTRANET_DS, "UPDATE AvnMenuGroups SET disp_order = #filterIntForSQL(Request.qryStruct.arg2)# WHERE (id = #id#); " & sql_qGetMenuGroupNames);
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qSetMenuGroupDispOrder);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: setMenuGroupDispOrder - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
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
						Request.cf_dump(qObj, 'qObj', false);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'dropMenuGroupAssociation':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qDropMenuGroupAssociation', Request.INTRANET_DS, "DELETE FROM AvnMenuGroups WHERE (id = #filterIntForSQL(Request.qryStruct.arg1)#); " & sql_qGetMenuGroupNames);
			
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qDropMenuGroupAssociation);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: dropTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'saveMenuGroupAssociation':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qSaveMenuGroupAssociation', Request.INTRANET_DS, "INSERT INTO AvnMenuGroups (menu_id, group_id) VALUES (#filterIntForSQL(Request.qryStruct.arg1)#,#filterIntForSQL(Request.qryStruct.arg2)#); " & sql_qGetMenuGroupNames);
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qSaveMenuGroupAssociation);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: saveMenuGroupAssociation - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'getMenuGroupNames':
					safely_execSQL('Request.qGetMenuGroupNames', Request.INTRANET_DS, sql_qGetMenuGroupNames);
		
					if (NOT Request.dbError) {
						registerQueryFromAJAX(Request.qGetMenuGroupNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'saveTopLevelMenuName':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qSaveTopLevelMenuName', Request.INTRANET_DS, "UPDATE AvnMenu SET menuName = '#filterQuotesForSQL(Request.qryStruct.arg1)#' WHERE (id = #filterIntForSQL(Request.qryStruct.arg2)#); SELECT id, menuName FROM AvnMenu ORDER BY menuName");
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qSaveTopLevelMenuName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: dropTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'dropTopLevelMenuName':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qDropTopLevelMenuName', Request.INTRANET_DS, "DELETE FROM AvnMenu WHERE (id = #filterIntForSQL(Request.qryStruct.arg1)#); SELECT id, menuName FROM AvnMenu ORDER BY menuName");
			
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qDropTopLevelMenuName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: dropTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'addTopLevelMenuName':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qAddTopLevelMenuName', Request.INTRANET_DS, "INSERT INTO AvnMenu (menuName) VALUES ('#filterQuotesForSQL(Request.qryStruct.arg1)#'); SELECT id, menuName FROM AvnMenu ORDER BY menuName");
			
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qAddTopLevelMenuName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'getLayerNames':
					safely_execSQL('Request.qGetLayerNames', Request.INTRANET_DS, "SELECT id, layerName, layerDisplayName FROM AvnLayer ORDER BY layerDisplayName, layerName");
		
					if (NOT Request.dbError) {
						registerQueryFromAJAX(Request.qGetLayerNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'getGroupNames':
					safely_execSQL('Request.qGetGroupNames', Request.INTRANET_DS, "SELECT id, layerGroupName FROM AvnGroupName ORDER BY layerGroupName");
		
					if (NOT Request.dbError) {
						registerQueryFromAJAX(Request.qGetGroupNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'addGroupName':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qAddGroupName', Request.INTRANET_DS, "INSERT INTO AvnGroupName (layerGroupName) VALUES ('#filterQuotesForSQL(Request.qryStruct.arg1)#'); SELECT id, layerGroupName FROM AvnGroupName ORDER BY layerGroupName");
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qAddGroupName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'saveGroupName':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qSaveGroupName', Request.INTRANET_DS, "UPDATE AvnGroupName SET layerGroupName = '#filterQuotesForSQL(Request.qryStruct.arg1)#' WHERE (id = #filterIntForSQL(Request.qryStruct.arg2)#); SELECT id, layerGroupName FROM AvnGroupName ORDER BY layerGroupName");
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qSaveGroupName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'dropGroupName':
					if (Request.qryStruct.argCnt gt 0) {
						safely_execSQL('Request.qDropGroupName', Request.INTRANET_DS, "DELETE FROM AvnGroupName WHERE (id = #filterIntForSQL(Request.qryStruct.arg1)#); SELECT id, layerGroupName FROM AvnGroupName ORDER BY layerGroupName");
		
						if (NOT Request.dbError) {
							registerQueryFromAJAX(Request.qDropGroupName);
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
		
				case 'getTopLevelMenuNames':
				//	QueryAddRow(Request.qryObj, 1);
				//	QuerySetCell(Request.qryObj, 'NAME', 'Rcvd', Request.qryObj.recordCount);
				//	QuerySetCell(Request.qryObj, 'VAL', 'getTopLevelMenuNames', Request.qryObj.recordCount);
		
					// Your code goes here to perform SQL Query or other processing
				//	qObj = QueryNew('id, myCol1, myCol2');
				//	QueryAddRow(qObj, 1);
				//	QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				//	QuerySetCell(qObj, 'myCol1', 'This is my data element ##1', qObj.recordCount);
				//	QuerySetCell(qObj, 'myCol2', 'This is my data element ##2', qObj.recordCount);
				//	registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
		
				//	registerQueryFromAJAX(Request.qryObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
		
					safely_execSQL('Request.qGetTopLevelMenuNames', Request.INTRANET_DS, "SELECT id, menuName FROM AvnMenu ORDER BY menuName");
					
					if (NOT Request.dbError) {
						registerQueryFromAJAX(Request.qGetTopLevelMenuNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
						QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				break;
			}
		</cfscript>
		<cfdump var="#Request.qryStruct#" label="Request.qryStruct" expand="No">
		<!--- the name of the cfm page is stored in the following variable: Request.qryObj.NAME["cfm"] --->
	
		<cfscript>
			endAJAX();
		</cfscript>
	</cffunction>

</cfcomponent>
