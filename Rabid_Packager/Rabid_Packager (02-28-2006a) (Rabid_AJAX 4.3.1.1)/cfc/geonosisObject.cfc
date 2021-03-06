<cfcomponent displayname="geonosisObject" output="Yes" extends="geonosisCode">

	<cfscript>
		this.qObject = -1;
		this.objectID = -1;
		
		function init(sDSN) {
			super.init(sDSN);
			return this;
		}
		
		function readObjectNamedOfType(aName, aType) {
			this.objectID = getObjectIdByNameAndType(aName, aType);
			return this;
		}

		function getObject() {
			var sql_statement = sql_GeonosisObjectByID(this.objectID);
			safely_execSQL('this.qObject', this.DSN, sql_statement);
			if ( (Request.dbError) OR (NOT IsQuery(this.qObject)) ) {
				this.qObject = -1;
			}
			return this;
		}
	</cfscript>
</cfcomponent>
