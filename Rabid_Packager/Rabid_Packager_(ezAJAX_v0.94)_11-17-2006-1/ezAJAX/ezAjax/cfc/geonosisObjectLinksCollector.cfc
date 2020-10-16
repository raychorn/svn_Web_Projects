<cfcomponent displayname="geonosisObjectLinksCollector" output="Yes" extends="geonosisCode">

	<cfscript>
		this.DSN = '';
		this.collection = -1;
		this.qGetObjectLinks = -1;
		this.sql_statement = "";
		
		function init(sDSN) {
			super.init(sDSN);
			this.DSN = sDSN;
			this.collection = StructNew();
			return this;
		}
		
		function getObjectLinksForObjectId(objectID) {
			var sql_statement = sql_GeonosisGetObjectLinksForObjectId(objectID);
			ezExecSQL('this.qGetObjectLinks', this.DSN, sql_statement);
			return this;
		}

		function checkObjectLinksForObjectIds(objectID1, objectID2) {
			this.sql_statement = sql_GeonosisCheckObjectLinksForObjectIds(objectID1, objectID2);
			ezExecSQL('this.qGetObjectLinks', this.DSN, this.sql_statement);
			return this;
		}
	</cfscript>
</cfcomponent>
