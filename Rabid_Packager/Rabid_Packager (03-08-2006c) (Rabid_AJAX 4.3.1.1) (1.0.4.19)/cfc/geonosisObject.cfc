<cfcomponent displayname="geonosisObject" output="Yes" extends="geonosisCode">

	<cfscript>
		this.qObject = -1;
		this.objectID = -1;
		this.attrID = -1;
		this.qAttrs = -1;
		this.qCommitAttrs = -1;
		this.attrValueChanges = -1;
		this.qMetaDataObjectAttr = -1;
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
			var kAR = StructKeyArray(this.attrValueChanges);
			var n = ArrayLen(kAR);
		//	writeOutput(cf_dump(kAR, 'kAR', false));
			this.qMetaDataObjectAttr = getDbMetaDataForObjectAttributes().QCOLUMNS;
			if (IsQuery(this.qMetaDataObjectAttr)) {
				nn = this.qMetaDataObjectAttr.recordCount;
			//	writeOutput(cf_dump(this.qMetaDataObjectAttr, 'this.qMetaDataObjectAttr', false));
				for (i = 1; i lte n; i = i + 1) {
					for (j = 1; j lte nn; j = j + 1) {
						if (UCASE(this.qMetaDataObjectAttr.COLUMN_NAME[j]) eq UCASE(kAR[i])) {
							datatype = this.qMetaDataObjectAttr.DATA_TYPE[j];
							break;
						}
					}
					bool_inhibit = false;
					datumFormatted = URLDecode(this.attrValueChanges[kAR[i]]);
					switch (UCASE(datatype)) {
						case 'VARCHAR':
						case 'LONGVARCHAR':
							datumFormatted = "'" & filterQuotesForSQL(datumFormatted) & "'";
						break;

						case 'TIMESTAMP':
							try {
								datumFormatted = CreateODBCDateTime(ParseDateTime(filterQuotesForSQL(datumFormatted)));
							} catch (Any e) {
							//	WriteOutput(cf_dump(e, 'CF Error [datumFormatted=#datumFormatted#]', false));
								bool_inhibit = true;
							}
						break;
					}
				//	writeOutput('<b>j = [#j#], kAR[#i#] = [#kAR[i]#], this.attrValueChanges[#kAR[i]#] = [#datumFormatted#]</b><br>');
					if (NOT bool_inhibit) {
						changesAR[ArrayLen(changesAR) + 1] = kAR[i] & ' = ' & datumFormatted;
					}
				}
			//	writeOutput(cf_dump(changesAR, 'changesAR', false));
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

	<cfscript>
		function init(sDSN) {
			super.init(sDSN);
			this.attrValueChanges = StructNew();
			return this;
		}
		
		function registerChangedAttrValue(aName, aValue) {
			this.attrValueChanges[aName] = aValue;
			return this;
		}
		
		function commitChangedAttrValues() {
			var sql_statement = '';
			this.qCommitAttrs = -1;
			if ( (IsQuery(this.qAttrs)) AND (IsStruct(this.attrValueChanges)) ) {
				sql_statement = sql_GeonosisObjectCommitAttrs();
				if (Len(Trim(sql_statement)) gt 0) {
					writeOutput('<b>sql_statement = [#sql_statement#]</b><br>');
					safely_execSQL('this.qCommitAttrs', this.DSN, sql_statement);
					if (Request.dbError) {
						this.qCommitAttrs = -1;
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
