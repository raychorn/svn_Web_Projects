<cfcomponent displayname="geonosisAttributeCollector" output="Yes" extends="geonosisCode">

	<cfscript>
		this.DSN = '';
		this.collection = -1;
		this.qAttributeNames = -1;
		
		function init(sDSN) {
			super.init(sDSN);
			this.DSN = sDSN;
			this.collection = StructNew();
			return this;
		}
		
		function addAttribute(objectID, attributeName, dataStruct) {
			var sql_statement = sql_GeonosisAddAttribute(objectID, attributeName, dataStruct);
			safely_execSQL('this.qAttributeNames', this.DSN, sql_statement);
			return this;
		}
	</cfscript>
</cfcomponent>
