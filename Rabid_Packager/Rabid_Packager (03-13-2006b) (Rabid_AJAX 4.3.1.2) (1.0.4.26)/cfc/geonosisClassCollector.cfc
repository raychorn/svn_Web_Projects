<cfcomponent displayname="geonosisClassCollector" output="Yes" extends="geonosisCode">

	<cfscript>
		this.DSN = '';
		this.collection = -1;
		this.qClassNames = '';
		
		function init(sDSN) {
			super.init(sDSN);
			this.DSN = sDSN;
			this.collection = StructNew();
			return this;
		}
		
		function addClassName(className, classPath) {
			var sql_statement = sql_GeonosisAddClassDef(className, classPath) & ';' & sql_GeonosisClassNames() & ';';
			safely_execSQL('this.qClassNames', this.DSN, sql_statement);
			if ( (Request.dbError) OR (NOT IsQuery(this.qClassNames)) ) {
				this.qClassNames = -1;
			}
		}

		function getClassNames() {
			var sql_statement = sql_GeonosisClassNames();
			safely_execSQL('this.qClassNames', this.DSN, sql_statement);
			if ( (Request.dbError) OR (NOT IsQuery(this.qClassNames)) ) {
				this.qClassNames = -1;
			}
		}

		function getClasses() {
			var i = -1;
			var n = -1;
			var o = -1;
			
			getClassNames();
			if (IsQuery(this.qClassNames)) {
				n = this.qClassNames.recordCount;
				this.collection.count = n;
				this.collection.bag = ArrayNew(1);
				for (i = 1; i lte n; i = i + 1) {
					this.collection.bag[ArrayLen(this.collection.bag) + 1] = this.qClassNames.className[i];
				}
			}
			return this;
		}
	</cfscript>
</cfcomponent>
