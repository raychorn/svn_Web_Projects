<cfcomponent displayname="performGetGeonosisObjects" output="No" extends="userDefinedAJAXFunctions">
	<cfscript>
		function _userDefinedAJAXFunctions(qryStruct) {
			var errMsg = '';
			var scopesContent = '';
			try {
				switch (qryStruct.ezCFM) {
					case 'performGetGeonosisObjects':
						if (qryStruct.argCnt gte 1) {
							if (IsDefined("qryStruct.NAMEDARGS.CLASSNAME")) {
								_CLASSNAME = ezFilterQuotesForSQL(qryStruct.NAMEDARGS.CLASSNAME);
								_hasMetaData = false;
								if (IsDefined("qryStruct.NAMEDARGS.hasMetaData")) {
									_hasMetaData = (UCASE(qryStruct.NAMEDARGS.hasMetaData) eq UCASE('true'));
								}
								aGeonosisObjCollector = Request.commonCode.objectForType('geonosisObjectCollector').init(Request.Geonosis_DSN).getObjectsOfType(_CLASSNAME);

								qSchema = QueryNew('id, objectCnt, objectsMetDataRecord, objectAttributesMetDataRecord, scopesContentQuery');
								QueryAddRow(qSchema, 1);
								QuerySetCell(qSchema, 'id', qSchema.recordCount, qSchema.recordCount);
								QuerySetCell(qSchema, 'objectCnt', aGeonosisObjCollector.collection.count, qSchema.recordCount);
								if (_hasMetaData) {
									QuerySetCell(qSchema, 'objectsMetDataRecord', -1, qSchema.recordCount);
									QuerySetCell(qSchema, 'objectAttributesMetDataRecord', -1, qSchema.recordCount);
								} else {
									QuerySetCell(qSchema, 'objectsMetDataRecord', 1, qSchema.recordCount);
									QuerySetCell(qSchema, 'objectAttributesMetDataRecord', 1, qSchema.recordCount);
								}
								QuerySetCell(qSchema, 'scopesContentQuery', -1, qSchema.recordCount);
								ezRegisterNamedQueryFromAJAX('qSchema', qSchema); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...

								for (j = 1; j lte aGeonosisObjCollector.collection.count; j = j + 1) {
									ezRegisterNamedQueryFromAJAX('qObject#j#', aGeonosisObjCollector.collection.bag[j].qObject); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
									ezRegisterNamedQueryFromAJAX('qAttrs#j#', aGeonosisObjCollector.collection.bag[j].qAttrs); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								}

								if (NOT _hasMetaData) {
									ezRegisterNamedQueryFromAJAX('qObjectsMetDataRecord', aGeonosisObjCollector.getDbMetaDataForObjects().QCOLUMNS); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
									ezRegisterNamedQueryFromAJAX('qObjectAttributesMetDataRecord', aGeonosisObjCollector.getDbMetaDataForObjectAttributes().QCOLUMNS); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								}
							} else {
								qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation, isHTML');
								QueryAddRow(qObj, 1);
								QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
								QuerySetCell(qObj, 'errorMsg', 'ERROR: Missing argument named (CLASSNAME) in AJAX Function known as ("#qryStruct.ezCFM#") in #CGI.SCRIPT_NAME#', qObj.recordCount);
								QuerySetCell(qObj, 'isHTML', 1, qObj.recordCount);
								ezRegisterQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
							}
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', 'ERROR: Missing arguments in AJAX Function known as ("#qryStruct.ezCFM#") in #CGI.SCRIPT_NAME#.', qObj.recordCount);
							ezRegisterQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					break;
				}
			} catch (Any e) {
				errMsg = ezExplainError(e, false);
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation, isHTML');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				if (CGI.REMOTE_HOST is '127.0.0.1') {
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
