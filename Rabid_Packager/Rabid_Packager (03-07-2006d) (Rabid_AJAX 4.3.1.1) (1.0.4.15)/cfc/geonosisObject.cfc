<cfcomponent displayname="geonosisObject" output="Yes" extends="geonosisCode">

	<cfscript>
		this.qObject = -1;
		this.objectID = -1;
		this.qAttrs = -1;
		
		function init(sDSN) {
			super.init(sDSN);
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
			var sql_statement = sql_GeonosisObjectAttrsByObjID(this.objectID);
			safely_execSQL('this.qAttrs', this.DSN, sql_statement);
			if ( (Request.dbError) OR (NOT IsQuery(this.qAttrs)) ) {
				this.qAttrs = -1;
			}
			return this;
		}
	</cfscript>
</cfcomponent>
