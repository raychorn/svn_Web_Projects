<cfcomponent displayname="ajaxFunctions" output="Yes" extends="ajaxCode">
	<cffunction name="doAJAXFunction" access="public" returntype="Any">
		<cfscript>
			beginAJAX();
		</cfscript>

		<!--- This is where you may code your ColdFusion code that processes the AJAX Function --->
		<cfscript>
			try {
				switch (Request.qryStruct.cfm) {
					case 'performGetGeonosisObjects':
						if (Request.qryStruct.argCnt gte 1) {
							if (IsDefined("Request.qryStruct.CLASSNAME")) {
								_CLASSNAME = Request.commonCode.filterQuotesForSQL(Request.qryStruct.CLASSNAME);
								aGeonosisObjCollector = Request.commonCode.objectForType('geonosisObjectCollector').init(Request.Geonosis_DSN).getObjectsOfType(_CLASSNAME);
								for (j = 1; j lte aGeonosisObjCollector.collection.count; j = j + 1) {
									registerQueryFromAJAX(aGeonosisObjCollector.collection.bag[j].qObject); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
									registerQueryFromAJAX(aGeonosisObjCollector.collection.bag[j].qAttrs); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								}
							}
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', 'ERROR: Missing arguments in AJAX Function known as ("#Request.qryStruct.cfm#") in #CGI.SCRIPT_NAME#.', qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					//	qObj = QueryNew('id, message');
					//	QueryAddRow(qObj, 1);
					//	QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					//	QuerySetCell(qObj, 'message', 'Request.qryStruct.argCnt = [#Request.qryStruct.argCnt#], _OBJECTCLASSID = [#_OBJECTCLASSID#]', qObj.recordCount);
					//	registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					break;
	
					case 'performGetGeonosisClasses':
					//	qSchema = QueryNew('id, metadataCnt');
					//	QueryAddRow(qSchema, 1);
					//	QuerySetCell(qSchema, 'id', qSchema.recordCount, qSchema.recordCount);
					//	QuerySetCell(qSchema, 'metadataCnt', 4, qSchema.recordCount);
					//	registerQueryFromAJAX(qSchema); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
	
					//	aGeonosisMetadataObj = Request.commonCode.objectForType('geonosisMetadata').init(Request.Geonosis_DSN).getGeonosisObjectClassMetaData();
					//	registerQueryFromAJAX(aGeonosisMetadataObj.qGeonosisObjectClassMetaData); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
	
					//	aGeonosisMetadataObj.getGeonosisObjectsMetaData();
					//	registerQueryFromAJAX(aGeonosisMetadataObj.qGeonosisObjectsMetaData); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
	
					//	aGeonosisMetadataObj.getGeonosisObjectAttributesMetaData();
					//	registerQueryFromAJAX(aGeonosisMetadataObj.qGeonosisObjectAttributesMetaData); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
	
					//	aGeonosisMetadataObj.getGeonosisObjectLinksMetaData();
					//	registerQueryFromAJAX(aGeonosisMetadataObj.qGeonosisObjectLinksMetaData); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						
						aGeonosisClassCollector = Request.commonCode.objectForType('geonosisClassCollector').init(Request.Geonosis_DSN).getClasses();
	
						qObj = aGeonosisClassCollector.qClassNames;
						if (IsQuery(qObj)) {
						//	for (i = 1; i lte qObj.recordCount; i = i + 1) {
						//		aGeonosisObjCollector = Request.commonCode.objectForType('geonosisObjectCollector').init(Request.Geonosis_DSN).getObjectsOfType(qObj.className[i]);
						//		for (j = 1; j lte aGeonosisObjCollector.collection.count; j = j + 1) {
						//			registerQueryFromAJAX(aGeonosisObjCollector.collection.bag[j].qObject); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						//			registerQueryFromAJAX(aGeonosisObjCollector.collection.bag[j].qAttrs); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						//		}
						//	}
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
							QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
						}
						registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					break;
				}
				
				if (Request.bool_canDebugHappen) cf_dump(Request.qryStruct, 'Request.qryStruct', false);
			} catch (Any e) {
				cAR = ListToArray(Replace(explainErrorWithStack(e, false), Chr(13), '', 'all'), Chr(10));
				n = ArrayLen(cAR);
				_explainError = '';
				for (i = 1; i lte n; i = i + 1) {
					_explainError = _explainError & cAR[i] & Chr(13);
				}

				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'ColdFusion Error', qObj.recordCount);
				QuerySetCell(qObj, 'moreErrorMsg', URLEncodedFormat(StructExplainer(Server, false, false)), qObj.recordCount);
				QuerySetCell(qObj, 'explainError', URLEncodedFormat(_explainError), qObj.recordCount);
				QuerySetCell(qObj, 'isPKviolation', false, qObj.recordCount);
				registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		</cfscript>
		<!--- the name of the cfm page is stored in the following variable: Request.qryObj.NAME["cfm"] --->
	
		<cfscript>
			endAJAX();
		</cfscript>
	</cffunction>

</cfcomponent>
