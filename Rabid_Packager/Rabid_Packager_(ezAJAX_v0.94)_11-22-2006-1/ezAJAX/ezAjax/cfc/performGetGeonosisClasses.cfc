<cfcomponent displayname="performGetGeonosisClasses" output="No" extends="userDefinedAJAXFunctions">
	<cfinclude template="../../cfinclude_constants.cfm">
	<cfsavecontent variable="html_masterBrowser">
		<cfoutput>
			<table width="400" border="1" cellpadding="-1" cellspacing="-1">
				<tr>
					<td>
						<button name="btn_getContents" id="btn_getContents" class="buttonMenuClass" onclick="this.disabled = true; oAJAXEngine.doAJAX('performGetGeonosisClasses', 'handle_ezAJAXCallBack'); return false;" style="cursor:hand; cursor:pointer;"><table cellpadding="1" cellspacing="1"><tr><td><small>Get Classes</small></td><td><img src="images/Geonosis/32x32/small-icons.gif" title="#cf_const_Objects_symbol# - Get Objects" border="0"></td></tr></table></button>
					</td>
				</tr>
				<tr>
					<td bgcolor="silver" align="center" class="boldPromptTextClass">
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td width="45%" align="center">
									<cfif 1>
										<button id="btn_objectClass_drop" class="buttonClass" title="Click this button to ADD a new Class." onclick="alert(101); return false;" style="cursor:hand; cursor:pointer;"><img src="images/Geonosis/32x32/add-script.gif" border="0" title="Add a New Class"></button>
									<cfelse>
										<a href="" onclick="alert('+'); return false;"><img src="images/Geonosis/16x16/add.gif" border="0" title="Add a New Class"></a>
									</cfif>
								</td>
								<td width="*" align="center">
									<BIG>Classes</BIG>
								</td>
								<td width="45%" align="center">
									<cfif 1>
										<button id="btn_objectClass_add" class="buttonClass" title="Click this button to drop the selected Class." onclick="alert(202); return false;" style="cursor:hand; cursor:pointer;"><img src="images/Geonosis/32x32/delete-script.gif" border="0" title="Delete the selected Class"></button>
									<cfelse>
										<a href="" onclick="alert('-'); return false;"><img src="images/Geonosis/16x16/delete.gif" border="0" title="Delete the selected Class"></a>
									</cfif>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<div id="div_classesBrowser">
							<i><b>Classes</b></i>
						</div>
					</td>
				</tr>
			</table>
		</cfoutput>
	</cfsavecontent>

	<cfsavecontent variable="html_masterBrowser2">
		<cfoutput>
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr>
					<td align="left" valign="top">
					</td>
					<td align="left" valign="top">
						<div id="div_objectsBrowser">
							<b>Objects</b>
						</div>
					</td>
					<td align="left" valign="top">
						<div id="div_attrsBrowser">
							<b>Attrs</b>
						</div>
					</td>

					<td align="left" valign="top">

						<table cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									<div id="div_objectsToLinkBrowser">
										&nbsp;<button id="btn_objectLink_add" disabled class="buttonClass" title="Click this button to link the two selected objects." onclick="performLinkObjects(); return false;">[+]</button>
										<button id="btn_objectLink_drop" disabled class="buttonClass" title="Click this button to remove the selected object(s) from the Objects to Link list." onclick="performDropLinkObjects(); return false;">[-]</button>&nbsp;
										<table width="200" cellpadding="-1" cellspacing="-1">
											<tr>
												<td bgcolor="silver" align="center" class="boldPromptTextClass">
													Objects to Link
												</td>
											</tr>
											<tr>
												<td>
													<select id="selection_objects2Link" multiple size="2" class="boldPromptTextClass" style="width: 200px;" onchange="handle_onChange_objects2Link(this); return true;">
													</select>
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<div id="div_objectsLinkedBrowser">
										<table width="200" cellpadding="-1" cellspacing="-1">
											<tr>
												<td bgcolor="silver" align="center" class="boldPromptTextClass">
													Linked Objects
												</td>
											</tr>
											<tr>
												<td>
													<select id="selection_linkedObjects" multiple size="2" class="boldPromptTextClass" style="width: 200px;" onchange="handle_onChange_linkedObjects(this); return true;">
													</select>
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
						
						<div id="div_abstract_Drag-n-Drop_Container">  <!---  style="position: absolute; top: 0px; left: 0px; width: 0px; height: 0px; display: none;" --->
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="right" valign="top">
						<div id="div_objectBrowser">
							<b>Object</b>
						</div>
					</td>
					<td>
					</td>
				</tr>
			</table>
		</cfoutput>
	</cfsavecontent>

	<cfscript>
		function _userDefinedAJAXFunctions(qryStruct) {
			var errMsg = '';
			var scopesContent = '';
			try {
				switch (qryStruct.ezCFM) {
					case 'performGetGeonosisClasses':
						aGeonosisClassCollector = Request.commonCode.objectForType('geonosisClassCollector').init(Request.Geonosis_DSN).getClasses();
	
						qObj = aGeonosisClassCollector.qClassNames;
						if (IsQuery(qObj)) {
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						}
						ezRegisterNamedQueryFromAJAX('qData1', qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						ezRegisterNamedQueryFromAJAX('qMetaDataForObjectClassDefs', aGeonosisClassCollector.getDbMetaDataForObjectClassDefs().QCOLUMNS); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						
						qObj = QueryNew('id, htmlContent');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'htmlContent', html_masterBrowser, qObj.recordCount);
						ezRegisterNamedQueryFromAJAX('qContent', qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					break;
				}
			} catch (Any e) {
				errMsg = ezExplainError(e, false);
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation, isHTML');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				if (CGI.REMOTE_HOST is '127.0.0.1') {
					if (IsDefined("Request._CMS_user_data")) {
						scopesContent = scopesContent & '<br>Request._CMS_user_data = [#Request._CMS_user_data#]';
					}
	//				scopesContent = scopesContent & '<br><table width="100%"><tr><td>' & ezCfDump(e, 'CF Error', false) & '</td><td>' & ezCfDump(Application, 'App Scope', false) & '</td><td>' & ezCfDump(Session, 'Session Scope', false) & '</td><td>' & ezCfDump(Request, 'Request Scope', false) & '</td></tr></table>';
	//				scopesContent = scopesContent & '<br><table width="100%"><tr><td>' & ezCfDump(e, 'CF Error', false) & '</td><td>' & ezCfDump(Request, 'Request Scope', false) & '</td></tr></table>';
					scopesContent = scopesContent & '<br><table width="100%"><tr><td>' & ezCfDump(e, 'CF Error', false) & '</td></tr></table>';
				}
				QuerySetCell(qObj, 'errorMsg', '<font color="red"><b>Something just went wrong in "#CGI.SCRIPT_NAME#"... :: Reason: "#errMsg#".</b></font>' & scopesContent, qObj.recordCount);
				QuerySetCell(qObj, 'moreErrorMsg', '', qObj.recordCount);
				QuerySetCell(qObj, 'explainError', '', qObj.recordCount);
				QuerySetCell(qObj, 'isPKviolation', '', qObj.recordCount);
				QuerySetCell(qObj, 'isHTML', 1, qObj.recordCount);
				ezRegisterQueryFromAJAX(qObj); // this function is used to tell the ezAJAX(tm) system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		}
	</cfscript>
</cfcomponent>
