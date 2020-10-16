<cfcomponent displayname="geonosisObjectCollector" output="Yes" extends="geonosisCode">

	<cfscript>
		this.DSN = '';
		this.collection = -1;
		this.qObjectNames = '';
		
		function init(sDSN) {
			super.init(sDSN);
			this.DSN = sDSN;
			this.collection = StructNew();
			return this;
		}
		
		function addObject(objectClassID, objectName, dataStruct) {
			var sql_statement = sql_GeonosisAddObject(objectClassID, objectName, dataStruct);
			safely_execSQL('this.qObjectNames', this.DSN, sql_statement);
		//	if ( (Request.dbError) OR (NOT IsQuery(this.qObjectNames)) ) {
		//		this.qObjectNames = -1;
		//	}
			return this;
		}

		function dropObjectById(objectID) {
			var sql_statement = sql_GeonosisDropObjectById(objectID);
//	writeOutput('<b>(dropObjectById(#objectID#)) :: sql_statement = [#sql_statement#]</b><br>');
			safely_execSQL('this.qObjectNames', this.DSN, sql_statement);
//	writeOutput('<b>(dropObjectById(#objectID#)) :: Request.dbError = [#Request.dbError#]</b><br>');
		//	if ( (Request.dbError) OR (NOT IsQuery(this.qObjectNames)) ) {
		//		this.qObjectNames = -1;
		//	}
			return this;
		}

		function getNames(aType) {
			var sql_statement = -1;
			this.collection.type = aType;
			sql_statement = sql_GeonosisObjectNamesByType(aType);
			safely_execSQL('this.qObjectNames', this.DSN, sql_statement);
		//	if ( (Request.dbError) OR (NOT IsQuery(this.qObjectNames)) ) {
		//		this.qObjectNames = -1;
		//	}
			return this;
		}

		function getObjectsOfType(aType) {
			var i = -1;
			var n = -1;
			var o = -1;
			
			getNames(aType);
			if (IsQuery(this.qObjectNames)) {
				n = this.qObjectNames.recordCount;
				this.collection.count = n;
				this.collection.bag = ArrayNew(1);
				for (i = 1; i lte n; i = i + 1) {
					o = objectForType('geonosisObject').init(this.DSN);
					o.readObjectById(this.qObjectNames.id[i]).getObject().getAttrs();
					this.collection.bag[ArrayLen(this.collection.bag) + 1] = o;
				}
			}
			return this;
		}

		function getObjectsForAttributeByID(anAttrID) {
			var aType = getObjectsTypeForAttributeByID(anAttrID);
			return getObjectsOfType(aType);
		}

		function getObjectForAttributeByID(anAttrID) {
			var o = -1;
			var objID = getObjectForAttributeByID(anAttrID);
			
			if (objID gt -1) {
				this.collection.count = 1;
				this.collection.bag = ArrayNew(1);
				o = objectForType('geonosisObject').init(this.DSN);
				o.getObjectByID(objID).getAttrs();
				this.collection.bag[ArrayLen(this.collection.bag) + 1] = o;
			}
			return this;
		}
	</cfscript>
</cfcomponent>
