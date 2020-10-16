<cfcomponent displayname="geonosisAttributeCollector" output="Yes" extends="geonosisCode">

	<cfscript>
		this.DSN = '';
		this.collection = -1;
		this.qAttributeNames = -1;
		this.qDropAttr = -1;
		this.qGetAttr = -1;
		this.qGetAttrs = -1;
		
		function init(sDSN) {
			super.init(sDSN);
			this.DSN = sDSN;
			this.collection = StructNew();
			return this;
		}
		
		function addAttribute(objectID, attributeName, dataStruct) {
			var sql_statement = sql_GeonosisAddAttribute(objectID, attributeName, dataStruct);
			ezExecSQL('this.qAttributeNames', this.DSN, sql_statement);
			return this;
		}

		function dropAttribute(attrID) {
			var sql_statement = sql_GeonosisDropAttributeById(attrID);
			ezExecSQL('this.qDropAttr', this.DSN, sql_statement);
			return this;
		}

		function getAttribute(attrID) {
			var sql_statement = sql_GeonosisGetAttributeById(attrID);
			ezExecSQL('this.qGetAttr', this.DSN, sql_statement);
			return this;
		}

		function getAttributesForObjectId(objectID) {
			var sql_statement = sql_GeonosisGetAttributesForObjectId(objectID);
			ezExecSQL('this.qGetAttrs', this.DSN, sql_statement);
			return this;
		}
	</cfscript>
</cfcomponent>
