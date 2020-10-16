<cfcomponent displayname="ajaxFunctions" output="Yes" extends="ajaxCode">
	<cfscript>
		function flagSessionWithMetadata() {
			Session.metadataStruct = StructNew(); 
			Session.metadataStruct.bool_objectsMetData = true; 
			Session.metadataStruct.bool_objectAttributesMetData = true;
		}
	</cfscript>

	<cffunction name="doAJAXFunction" access="public" returntype="Any">
		<cfscript>
			beginAJAX();
		</cfscript>

		<!--- This is where you may code your ColdFusion code that processes the AJAX Function --->
		<cfscript>
			try {
				switch (Request.qryStruct.cfm) {
					case 'performSetGeonosisObjectAttribute':
						// what object is associated with the attribute that is being changed ?  Pass that object back...
						if (Request.qryStruct.argCnt gte 1) {
							if ( (IsDefined("Request.qryStruct.ID")) AND (IsDefined("Request.qryStruct._updatedColumn_")) AND (IsDefined("Request.qryStruct.OBJECTID")) ) {
								_ID = Request.commonCode.filterIntForSQL(Request.qryStruct.ID);
								_updatedColumn = Request.commonCode.filterQuotesForSQL(Request.qryStruct._updatedColumn_);
								try {
									_updatedColumnValue = Request.commonCode.filterQuotesForSQL(Request.qryStruct[_updatedColumn_]);
								} catch (Any e) {
									_updatedColumnValue = '';
								}
								_OBJECTID = Request.commonCode.filterIntForSQL(Request.qryStruct.OBJECTID);

								aGeonosisObject = Request.commonCode.objectForType('geonosisObject').init(Request.Geonosis_DSN).getAttrsByObjectIDForAttrID(_OBJECTID, _ID);

							//	Request.commonCode.cf_dump(aGeonosisObject, 'aGeonosisObject [_ID=#_ID#], [_updatedColumn=#_updatedColumn#], [_OBJECTID=#_OBJECTID#], [_updatedColumnValue=#_updatedColumnValue#]', false);
								
								if ( (IsDefined("aGeonosisObject.qAttrs")) AND (IsQuery(aGeonosisObject.qAttrs)) ) {
									aGeonosisObject.registerChangedAttrValue(_updatedColumn, _updatedColumnValue).commitChangedAttrValues();

									Request.commonCode.cf_dump(aGeonosisObject, 'aGeonosisObject [_ID=#_ID#], [_updatedColumn=#_updatedColumn#], [_OBJECTID=#_OBJECTID#], [_updatedColumnValue=#_updatedColumnValue#]', false);
									Request.commonCode.cf_dump(Request, 'Request', false);
									
									if (NOT Request.dbError) {
										qObj = QueryNew('id, status');
										QueryAddRow(qObj, 1);
										QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
										QuerySetCell(qObj, 'status', 1, qObj.recordCount);
									} else {
										qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
										QueryAddRow(qObj, 1);
										QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
										QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
										QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
										QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
										QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
									}
								} else {
									// replace this later on with a real error Query to return to the client...
									qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
									QueryAddRow(qObj, 1);
									QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
									QuerySetCell(qObj, 'errorMsg', 'ERROR: Geonosis Object Error (101) noticed in AJAX Function known as ("#Request.qryStruct.cfm#") in #CGI.SCRIPT_NAME#.', qObj.recordCount);
								}
								registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
							} else {
								qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
								QueryAddRow(qObj, 1);
								QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
								QuerySetCell(qObj, 'errorMsg', 'ERROR: Missing argument(s) named (ID, _updatedColumn_ OR OBJECTID) in AJAX Function known as ("#Request.qryStruct.cfm#") in #CGI.SCRIPT_NAME#.', qObj.recordCount);
								registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
							}
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', 'ERROR: Missing arguments in AJAX Function known as ("#Request.qryStruct.cfm#") in #CGI.SCRIPT_NAME#.', qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					break;

					case 'performGetGeonosisObjects':
						if (Request.qryStruct.argCnt gte 1) {
							if (IsDefined("Request.qryStruct.CLASSNAME")) {
								_CLASSNAME = Request.commonCode.filterQuotesForSQL(Request.qryStruct.CLASSNAME);
								_hasMetaData = false;
								if (IsDefined("Request.qryStruct.hasMetaData")) {
									_hasMetaData = (UCASE(Request.qryStruct.hasMetaData) eq UCASE('true'));
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
									QuerySetCell(qSchema, 'objectsMetDataRecord', (aGeonosisObjCollector.collection.count * 2) + 1 + 1, qSchema.recordCount);
									QuerySetCell(qSchema, 'objectAttributesMetDataRecord', (aGeonosisObjCollector.collection.count * 2) + 2 + 1, qSchema.recordCount);
								}
								QuerySetCell(qSchema, 'scopesContentQuery', -1, qSchema.recordCount);
								registerQueryFromAJAX(qSchema); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...

								for (j = 1; j lte aGeonosisObjCollector.collection.count; j = j + 1) {
									registerQueryFromAJAX(aGeonosisObjCollector.collection.bag[j].qObject); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
									registerQueryFromAJAX(aGeonosisObjCollector.collection.bag[j].qAttrs); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								}

								if (NOT _hasMetaData) {
									registerQueryFromAJAX(aGeonosisObjCollector.getDbMetaDataForObjects().QCOLUMNS); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
									registerQueryFromAJAX(aGeonosisObjCollector.getDbMetaDataForObjectAttributes().QCOLUMNS); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
								}
							}
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', 'ERROR: Missing arguments in AJAX Function known as ("#Request.qryStruct.cfm#") in #CGI.SCRIPT_NAME#.', qObj.recordCount);
							registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					break;
	
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
