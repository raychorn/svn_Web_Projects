<cfcomponent displayname="geonosisObjectLinksCollector" output="Yes" extends="geonosisCode">

	<cfscript>
		this.DSN = '';
		this.collection = -1;
		this.qGetObjectLinks = -1;
		
		function init(sDSN) {
			super.init(sDSN);
			this.DSN = sDSN;
			this.collection = StructNew();
			return this;
		}
		
		function getObjectLinksForObjectId(objectID) {
			var sql_statement = sql_GeonosisGetObjectLinksForObjectId(objectID);
			safely_execSQL('this.qGetObjectLinks', this.DSN, sql_statement);
			return this;
		}
	</cfscript>
</cfcomponent>
