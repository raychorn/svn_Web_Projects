<cfcomponent displayname="geonosisObject" output="Yes" extends="geonosisCode">

	<cfscript>
		this.qObject = -1;
		this.objectID = -1;
		this.attrID = -1;
		this.qAttrs = -1;
		this.qCommitAttrs = -1;
		this.attrValueChanges = -1;
	</cfscript>

	<cffunction name="sql_GeonosisObjectCommitAttrs" access="private" returntype="string">
		<cfscript>
			var i = -1;
			var changesAR = ArrayNew(1);
			var kAR = StructKeyArray(this.attrValueChanges);
			var n = ArrayLen(kAR);
			writeOutput(cf_dump(kAR, 'kAR', false));
			for (i = 1; i lte n; i = i + 1) {
				writeOutput('<b>kAR[#i#] = [#kAR[i]#], this.attrValueChanges[#kAR[i]#] = [#this.attrValueChanges[kAR[i]]#]</b><br>');
				changesAR[ArrayLen(changesAR) + 1] = kAR[i] & ' = ' & this.attrValueChanges[kAR[i]];
			}
			writeOutput(cf_dump(changesAR, 'changesAR', false));
		</cfscript>

		<cfsavecontent variable="_sql_GeonosisObjectCommitAttrs">
			<cfif (IsDefined("this.qAttrs.OBJECTID")) AND (IsDefined("this.qAttrs.ID"))>
			</cfif>
			<cfoutput>
				UPDATE objectAttributes
				SET #Replace(ArrayToList(changesAR, ','), ',', ', ', 'all')#
				WHERE (objectID = #this.qAttrs.OBJECTID#) AND (id = #this.qAttrs.ID#)
			</cfoutput>
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
				writeOutput('<b>sql_statement = [#sql_statement#]</b><br>');
				safely_execSQL('this.qCommitAttrs', this.DSN, sql_statement);
				if (Request.dbError) {
					this.qCommitAttrs = -1;
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
