<cfcomponent displayname="performGetGeonosisClasses" output="No" extends="userDefinedAJAXFunctions">
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
