<cfcomponent displayname="geonosisObject" output="Yes" extends="geonosisCode">

	<cfscript>
		this.qObject = -1;
		this.objectID = -1;
		this.attrID = -1;
		this.qAttrs = -1;
		this.qCommitData = -1;
		this.structValueChanges = -1;
		this.qMetaDataObjectAttr = -1;
		this.qMetaDataObject = -1;
		this.qMetaDataObjectClassDefs = -1;
	</cfscript>

	<cffunction name="sql_GeonosisObjectCommitAttrs" access="private" returntype="string">
		<cfscript>
			var i = -1;
			var j = -1;
			var nn = -1;
			var datatype = '';
			var bool_inhibit = false;
			var datumFormatted = '';
			var changesAR = ArrayNew(1);
			var kAR = StructKeyArray(this.structValueChanges);
			var n = ArrayLen(kAR);
			this.qMetaDataObjectAttr = getDbMetaDataForObjectAttributes().QCOLUMNS;
			if (IsQuery(this.qMetaDataObjectAttr)) {
				nn = this.qMetaDataObjectAttr.recordCount;
				for (i = 1; i lte n; i = i + 1) {
					for (j = 1; j lte nn; j = j + 1) {
						if (UCASE(this.qMetaDataObjectAttr.COLUMN_NAME[j]) eq UCASE(kAR[i])) {
							datatype = this.qMetaDataObjectAttr.DATA_TYPE[j];
							break;
						}
					}
					bool_inhibit = false;
					datumFormatted = URLDecode(this.structValueChanges[kAR[i]]);
					switch (UCASE(datatype)) {
						case 'VARCHAR':
						case 'LONGVARCHAR':
							datumFormatted = "'" & filterQuotesForSQL(datumFormatted) & "'";
						break;

						case 'TIMESTAMP':
							try {
								datumFormatted = CreateODBCDateTime(ParseDateTime(filterQuotesForSQL(datumFormatted)));
							} catch (Any e) {
								bool_inhibit = true;
							}
						break;
					}
					if (NOT bool_inhibit) {
						changesAR[ArrayLen(changesAR) + 1] = kAR[i] & ' = ' & datumFormatted;
					}
				}
			}
		</cfscript>

		<cfsavecontent variable="_sql_GeonosisObjectCommitAttrs">
			<cfif (IsDefined("this.qAttrs.OBJECTID")) AND (IsDefined("this.qAttrs.ID")) AND (ArrayLen(changesAR) gt 0)>
				<cfoutput>
					UPDATE objectAttributes
					SET #Replace(ArrayToList(changesAR, ','), ',', ', ', 'all')#
					WHERE (objectID = #this.qAttrs.OBJECTID#) AND (id = #this.qAttrs.ID#)
				</cfoutput>
			</cfif>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectCommitAttrs>
	</cffunction>

	<cffunction name="sql_GeonosisObjectCommitData" access="private" returntype="string">
		<cfscript>
			var i = -1;
			var j = -1;
			var nn = -1;
			var nn2 = -1;
			var datatype = '';
			var dataTableName = '';
			var whereClause = '';
			var bool_inhibit = false;
			var datumFormatted = '';
			var changesAR = ArrayNew(1);
			var kAR = StructKeyArray(this.structValueChanges);
			var n = ArrayLen(kAR);
			this.qMetaDataObject = getDbMetaDataForObjects().QCOLUMNS;
			this.qMetaDataObjectClassDefs = getDbMetaDataForObjectClassDefs().QCOLUMNS;
			if (IsQuery(this.qMetaDataObject)) {
				nn = this.qMetaDataObject.recordCount;
				nn2 = this.qMetaDataObjectClassDefs.recordCount;
				for (i = 1; i lte n; i = i + 1) {
					datatype = '';
					for (j = 1; j lte nn; j = j + 1) {
						if (UCASE(this.qMetaDataObject.COLUMN_NAME[j]) eq UCASE(kAR[i])) {
							whereClause = "(id = #this.qObject.ID#)";
							dataTableName = this.qMetaDataObject.TABLE_NAME[j];
							datatype = this.qMetaDataObject.DATA_TYPE[j];
							break;
						}
					}
					if (Len(datatype) eq 0) {
						for (j = 1; j lte nn2; j = j + 1) {
							if (UCASE(this.qMetaDataObjectClassDefs.COLUMN_NAME[j]) eq UCASE(kAR[i])) {
								whereClause = "(OBJECTCLASSID = #this.qObject.OBJECTCLASSID#)";
								dataTableName = this.qMetaDataObjectClassDefs.TABLE_NAME[j];
								datatype = this.qMetaDataObjectClassDefs.DATA_TYPE[j];
								break;
							}
						}
					}

					bool_inhibit = false;
					datumFormatted = URLDecode(this.structValueChanges[kAR[i]]);
					switch (UCASE(datatype)) {
						case 'VARCHAR':
						case 'LONGVARCHAR':
							datumFormatted = "'" & filterQuotesForSQL(datumFormatted) & "'";
						break;

						case 'TIMESTAMP':
							try {
								datumFormatted = CreateODBCDateTime(ParseDateTime(filterQuotesForSQL(datumFormatted)));
							} catch (Any e) {
								bool_inhibit = true;
							}
						break;
					}
					if (NOT bool_inhibit) {
						changesAR[ArrayLen(changesAR) + 1] = kAR[i] & ' = ' & datumFormatted;
					}
				}
			}
		</cfscript>

		<cfsavecontent variable="_sql_GeonosisObjectCommitData">
			<cfif (IsDefined("this.qObject.ID")) AND (ArrayLen(changesAR) gt 0)>
				<cfoutput>
					UPDATE #dataTableName#
					SET #Replace(ArrayToList(changesAR, ','), ',', ', ', 'all')#
					WHERE #whereClause#
				</cfoutput>
			</cfif>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectCommitData>
	</cffunction>

	<cfscript>
		function init(sDSN) {
			super.init(sDSN);
			this.structValueChanges = StructNew();
			return this;
		}
		
		function registerChangedAttrValue(aName, aValue) {
			this.structValueChanges[aName] = aValue;
			return this;
		}
		
		function registerChangedObjectValue(aName, aValue) {
			return registerChangedAttrValue(aName, aValue); // simply reuse this code since the functionality is the same for both attrs and the object itself...
		}
		
		function commitChangedObjectValues() {
			var sql_statement = '';
			this.qCommitData = -1;
			if ( (IsQuery(this.qObject)) AND (IsStruct(this.structValueChanges)) ) {
				sql_statement = sql_GeonosisObjectCommitData();
				if (Len(Trim(sql_statement)) gt 0) {
					writeOutput('<b>sql_statement = [#sql_statement#]</b><br>');
					safely_execSQL('this.qCommitData', this.DSN, sql_statement);
					if (Request.dbError) {
						this.qCommitData = -1;
					}
				} else {
					Request.dbError = true;
					Request.errorMsg = 'WARNING: No SQL Code was produced by the CF function known as "commitChangedObjectValues".';
					Request.moreErrorMsg = '';
					Request.explainError = '';
					Request.isPKviolation = false;
				}
			}
			return this;
		}
		
		function commitChangedAttrValues() {
			var sql_statement = '';
			this.qCommitData = -1;
			if ( (IsQuery(this.qAttrs)) AND (IsStruct(this.structValueChanges)) ) {
				sql_statement = sql_GeonosisObjectCommitAttrs();
				if (Len(Trim(sql_statement)) gt 0) {
					safely_execSQL('this.qCommitData', this.DSN, sql_statement);
					if (Request.dbError) {
						this.qCommitData = -1;
					}
				} else {
					Request.dbError = true;
					Request.errorMsg = 'WARNING: No SQL Code was produced by the CF function known as "commitChangedAttrValues".';
					Request.moreErrorMsg = '';
					Request.explainError = '';
					Request.isPKviolation = false;
				}
			}
			return this;
		}
		
		function readObjectNamedOfType(aName, aType) {
			this.objectID = getObjectIdByNameAndType(aName, aType);
			return this;
		}
		
		function readObjectById(id) {
			this.objectID = id;
			return this;
		}
		
		function readObjectForAttributeByID(anAttrID) {
			this.objectID = getObjectForAttributeByID(anAttrID);
			return this;
		}

		function getObjectByID(anID) {
			var sql_statement = sql_GeonosisObjectByID(anID);
			safely_execSQL('this.qObject', this.DSN, sql_statement);
			if ( (Request.dbError) OR (NOT IsQuery(this.qObject)) ) {
				this.qObject = -1;
			}
			return this;
		}

		function getObject() {
			return getObjectByID(this.objectID);
		}

		function getAttrs() {
			var sql_statement = '';
			sql_statement = sql_GeonosisObjectAttrsByObjID(this.objectID, this.attrID);
			safely_execSQL('this.qAttrs', this.DSN, sql_statement);
			if ( (Request.dbError) OR (NOT IsQuery(this.qAttrs)) ) {
				this.qAttrs = -1;
			}
			return this;
		}

		function getAttrsByObjectID(objectID) {
			this.objectID = objectID;
			return getAttrs();
		}

		function getAttrsByObjectIDForAttrID(objectID, attrID) {
			this.attrID = attrID;
			return getAttrsByObjectID(objectID);
		}
	</cfscript>
</cfcomponent>
