<cfcomponent name="geonosisObject" extends="commonCode">
	<cfscript>
		this.DSN = '';
		this.qObjectID = -1;
		this.qObjectType = -1;

		this.uname = "RAHl3J6MvJg88x%2BFkqY5kEmRg%3D%3DRA%4056505CE2AF97989F";
		this.pwd = "RAH8gvyktucAcyvk8hVs%2FjsgQ%3D%3DRB%402A2DB4853AC7CE7860168B8740318499";
		this.mdata = -1;
		this.pwdDecoder = -1;
		this.unameDecoder = -1;
	</cfscript>

	<cffunction name="sql_GeonosisObjectsTypeForAttributeByID" access="private" returntype="string">
		<cfargument name="_anAttrID_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisObjectsTypeForAttributeByID">
			<cfoutput>
				SELECT TOP 1 objectClassDefinitions.className
				FROM objectAttributes INNER JOIN
				     objects ON objectAttributes.objectID = objects.id INNER JOIN
				     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID
				WHERE (objectAttributes.id = #_anAttrID_#)
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectsTypeForAttributeByID>
	</cffunction>

	<cffunction name="sql_GeonosisObjectForAttributeByID" access="private" returntype="string">
		<cfargument name="_anAttrID_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisObjectForAttributeByID">
			<cfoutput>
				SELECT TOP 1 objects.id
				FROM objectAttributes INNER JOIN
				     objects ON objectAttributes.objectID = objects.id
				WHERE (objectAttributes.id = #_anAttrID_#)
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectForAttributeByID>
	</cffunction>

	<cffunction name="sql_GeonosisObjectByNameAndType" access="private" returntype="string">
		<cfargument name="_aName_" type="string" required="yes">
		<cfargument name="_aType_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisObjectByNameAndType">
			<cfoutput>
				SELECT TOP 1 objects.id
				FROM objects INNER JOIN
				     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID
				WHERE (objects.objectName = '#_aName_#')
					AND (objectClassDefinitions.className = '#_aType_#')
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectByNameAndType>
	</cffunction>

	<cffunction name="sql_GeonosisObjectByID" access="private" returntype="string">
		<cfargument name="_id_" type="numeric" required="yes">

		<cfsavecontent variable="_sql_GeonosisObjectByID">
			<cfoutput>
				SELECT objects.id, objects.objectClassID, objects.objectName, objects.publishedVersion, objects.editVersion, objects.created, objects.createdBy, 
				       objects.updated, objects.updatedBy, objectClassDefinitions.className, objectClassDefinitions.classPath
				FROM objects INNER JOIN
				     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID
				WHERE (objects.id = #_id_#)
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectByID>
	</cffunction>

	<cffunction name="sql_GeonosisObjectAttrsByObjID" access="private" returntype="string">
		<cfargument name="_id_" type="numeric" required="yes">

		<cfsavecontent variable="_sql_GeonosisObjectAttrsByObjID">
			<cfoutput>
				SELECT id, objectID, attributeName, valueString, valueText, displayOrder, startVersion, lastVersion, created, createdBy, updated, updatedBy
				FROM objectAttributes
				WHERE (objectID = #_id_#)
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectAttrsByObjID>
	</cffunction>

	<cffunction name="sql_GeonosisObjectNamesByType" access="private" returntype="string">
		<cfargument name="_aType_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisObjectNamesByType">
			<cfoutput>
				SELECT objects.objectName
				FROM objects INNER JOIN
				     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID
				WHERE (objectClassDefinitions.className = '#_aType_#')
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectNamesByType>
	</cffunction>

	<cffunction name="sql_GeonosisClassNames" access="private" returntype="string">

		<cfsavecontent variable="_sql_GeonosisClassNames">
			<cfoutput>
				SELECT objectClassID, className, classPath
				FROM objectClassDefinitions
				ORDER BY className
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisClassNames>
	</cffunction>

	<cffunction name="sql_GeonosisObjectClassMetaData" access="private" returntype="string">

		<cfsavecontent variable="_sql_GeonosisObjectClassMetaData">
			<cfoutput>
				sp_columns @table_name = 'objectClassDefinitions', @table_owner = 'dbo'
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectClassMetaData>
	</cffunction>

	<cffunction name="sql_GeonosisObjectsMetaData" access="private" returntype="string">

		<cfsavecontent variable="_sql_GeonosisObjectsMetaData">
			<cfoutput>
				sp_columns @table_name = 'objects', @table_owner = 'dbo'
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectsMetaData>
	</cffunction>

	<cffunction name="sql_GeonosisObjectAttributesMetaData" access="private" returntype="string">

		<cfsavecontent variable="_sql_GeonosisObjectAttributesMetaData">
			<cfoutput>
				sp_columns @table_name = 'objectAttributes', @table_owner = 'dbo'
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectAttributesMetaData>
	</cffunction>

	<cffunction name="sql_GeonosisObjectLinksMetaData" access="private" returntype="string">

		<cfsavecontent variable="_sql_GeonosisObjectLinksMetaData">
			<cfoutput>
				sp_columns @table_name = 'objectLinks', @table_owner = 'dbo'
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectLinksMetaData>
	</cffunction>

	<cfscript>
		function init(sDSN) {
			this.DSN = sDSN;
			this.pwdDecoder = decodeEncodedEncryptedString(URLDecode(this.pwd));
			this.unameDecoder = decodeEncodedEncryptedString(URLDecode(this.uname));
			this.mdata = oJDBCMetaData(this.DSN, this.unameDecoder.PLAINTEXT, this.pwdDecoder.PLAINTEXT);
			return this;
		}
		
		function _getDbMetaData(dbName, tableName) {
			return qJDBCColumns(this.mdata, dbName, tableName);
		}
		
		function getDbMetaDataForObjects() {
			return _getDbMetaData(Request.Geonosis_DBname, 'objects');
		}
		
		function getDbMetaDataForObjectAttributes() {
			return _getDbMetaData(Request.Geonosis_DBname, 'objectAttributes');
		}
		
		function getObjectsTypeForAttributeByID(anAttrID) {
			var aType = -1;
			var sql_statement = sql_GeonosisObjectsTypeForAttributeByID(anAttrID);
			safely_execSQL('this.qObjectType', this.DSN, sql_statement);
			if ( (NOT Request.dbError) AND (IsDefined("this.qObjectType")) ) {
				aType = this.qObjectType.className;
			}
			return aType;
		}

		function getObjectForAttributeByID(anAttrID) {
			var id = -1;
			var sql_statement = sql_GeonosisObjectForAttributeByID(anAttrID);
			safely_execSQL('this.qObjectID', this.DSN, sql_statement);
			if ( (NOT Request.dbError) AND (IsDefined("this.qObjectID.id")) ) {
				id = this.qObjectID.id;
			}
			return id;
		}

		function getObjectIdByNameAndType(aName, aType) {
			var id = -1;
			var sql_statement = sql_GeonosisObjectByNameAndType(aName, aType);
			safely_execSQL('this.qObjectID', this.DSN, sql_statement);
			if ( (NOT Request.dbError) AND (IsDefined("this.qObjectID.id")) ) {
				id = this.qObjectID.id;
			}
			return id;
		}
	</cfscript>
</cfcomponent>
