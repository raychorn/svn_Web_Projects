<cfcomponent name="geonosisCode" extends="ezAjaxCode">
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
		<cfargument name="_attrID_" type="numeric" default="-1">

		<cfsavecontent variable="_sql_GeonosisObjectAttrsByObjID">
			<cfoutput>
				SELECT id, objectID, attributeName, valueString, valueText, displayOrder, startVersion, lastVersion, created, createdBy, updated, updatedBy
				FROM objectAttributes
				WHERE (objectID = #_id_#)<cfif (_attrID_ gt -1)> AND (id = #_attrID_#)</cfif>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisObjectAttrsByObjID>
	</cffunction>
	
	<cffunction name="sql_GeonosisObjectNamesByType" access="private" returntype="string">
		<cfargument name="_aType_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisObjectNamesByType">
			<cfoutput>
				SELECT objects.id, objects.objectName
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

	<cffunction name="sql_GeonosisDropAttributeById" access="private" returntype="string">
		<cfargument name="_attrID_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisDropAttributeById">
			<cfoutput>
				DELETE FROM objectAttributes WHERE (id = #_attrID_#);
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisDropAttributeById>
	</cffunction>

	<cffunction name="sql_GeonosisCheckObjectLinksForObjectIds" access="private" returntype="string">
		<cfargument name="_objectID1_" type="numeric" required="yes">
		<cfargument name="_objectID2_" type="numeric" required="yes">

		<cfsavecontent variable="_sql_GeonosisCheckObjectLinksForObjectIds">
			<cfoutput>
				SELECT objectLinks.id, objectLinks.ownerId, objectLinks.relatedId, objectLinks.ownerPropertyName, objectLinks.relatedPropertyName, 
				       objectLinks.ownerAutoload, objectLinks.relatedAutoload, objectLinks.displayOrder, objectLinks.startVersion, objectLinks.lastVersion, 
				       objectLinks.created, objectLinks.createdBy, objectLinks.updated, objectLinks.updatedBy, objects.id AS 'objid', objects.objectClassID, 
				       objects.objectName, objects.publishedVersion, objects.editVersion, objects.created AS 'objcreated', objects.createdBy AS 'objcreatedBy', 
				       objects.updated AS 'objupdated', objects.updatedBy AS 'objupdatedBy', objectClassDefinitions.className, 
				       ownerObject.objectName AS ownerObjectName, relatedObject.objectName AS relatedObjectName, 
				       relatedObjectClassDefinitions.className AS 'relatedObjectClassName', ownerObjectClassDefinitions.className AS 'ownerObjectClassName'
				FROM objectLinks INNER JOIN
				     objects ON objectLinks.ownerId = objects.id OR objectLinks.relatedId = objects.id INNER JOIN
				     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID INNER JOIN
				     objects AS ownerObject ON objectLinks.ownerId = ownerObject.id INNER JOIN
				     objectClassDefinitions AS ownerObjectClassDefinitions ON ownerObject.objectClassID = ownerObjectClassDefinitions.objectClassID INNER JOIN
				     objects AS relatedObject ON objectLinks.relatedId = relatedObject.id INNER JOIN
				     objectClassDefinitions AS relatedObjectClassDefinitions ON relatedObject.objectClassID = relatedObjectClassDefinitions.objectClassID
				WHERE ( (objectLinks.ownerId = #_objectID1_#) AND (objectLinks.relatedId = #_objectID2_#) ) OR ( (objectLinks.ownerId = #_objectID2_#) AND (objectLinks.relatedId = #_objectID1_#) )
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisCheckObjectLinksForObjectIds>
	</cffunction>

	<cffunction name="sql_GeonosisGetObjectLinksForObjectId" access="private" returntype="string">
		<cfargument name="_objectID_" type="numeric" required="yes">

		<cfsavecontent variable="_sql_GeonosisGetObjectLinksForObjectId">
			<cfoutput>
				SELECT objectLinks.id, objectLinks.ownerId, objectLinks.relatedId, objectLinks.ownerPropertyName, objectLinks.relatedPropertyName, 
				       objectLinks.ownerAutoload, objectLinks.relatedAutoload, objectLinks.displayOrder, objectLinks.startVersion, objectLinks.lastVersion, 
				       objectLinks.created, objectLinks.createdBy, objectLinks.updated, objectLinks.updatedBy, objects.id AS 'objid', objects.objectClassID, 
				       objects.objectName, objects.publishedVersion, objects.editVersion, objects.created AS 'objcreated', objects.createdBy AS 'objcreatedBy', 
				       objects.updated AS 'objupdated', objects.updatedBy AS 'objupdatedBy', objectClassDefinitions.className, 
				       ownerObject.objectName AS ownerObjectName, relatedObject.objectName AS relatedObjectName, 
				       relatedObjectClassDefinitions.className AS 'relatedObjectClassName', ownerObjectClassDefinitions.className AS 'ownerObjectClassName'
				FROM objectLinks INNER JOIN
				     objects ON objectLinks.ownerId = objects.id OR objectLinks.relatedId = objects.id INNER JOIN
				     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID INNER JOIN
				     objects AS ownerObject ON objectLinks.ownerId = ownerObject.id INNER JOIN
				     objectClassDefinitions AS ownerObjectClassDefinitions ON ownerObject.objectClassID = ownerObjectClassDefinitions.objectClassID INNER JOIN
				     objects AS relatedObject ON objectLinks.relatedId = relatedObject.id INNER JOIN
				     objectClassDefinitions AS relatedObjectClassDefinitions ON relatedObject.objectClassID = relatedObjectClassDefinitions.objectClassID
				WHERE (objectLinks.ownerId = #_objectID_#) OR (objectLinks.relatedId = #_objectID_#)
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisGetObjectLinksForObjectId>
	</cffunction>

	<cffunction name="sql_GeonosisGetAttributeById" access="private" returntype="string">
		<cfargument name="_attrID_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisGetAttributeById">
			<cfoutput>
				SELECT * FROM objectAttributes WHERE (id = #_attrID_#);
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisGetAttributeById>
	</cffunction>

	<cffunction name="sql_GeonosisGetAttributesForObjectId" access="private" returntype="string">
		<cfargument name="_objectID_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisGetAttributesForObjectId">
			<cfoutput>
				SELECT * FROM objectAttributes WHERE (objectID = #_objectID_#);
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisGetAttributesForObjectId>
	</cffunction>

	<cffunction name="sql_GeonosisAddAttribute" access="private" returntype="string">
		<cfargument name="_objectID_" type="numeric" required="yes">
		<cfargument name="_attributeName_" type="string" required="yes">
		<cfargument name="_dataStruct_" type="struct" required="yes">

		<cfset var i = -1>
		<cfset var n = -1>
		<cfset var bool_dataElementExists = false>
		<cfset var colsToAdd = "">
		<cfset var _colsToAdd = "">
		<cfset var valsToAdd = "">
		<cfset var _valsToAdd = "">
		<cfset var colVal = "">
		<cfset var qMetaData = getDbMetaDataForObjectAttributes().QCOLUMNS>
		<cfset var colsList = ArrayNew(1)>
		<cfset var mdataList = ArrayNew(1)>
		
		<cfscript>
			n = qMetaData.recordCount;
			for (i = 1; i lte n; i = i + 1) {
				if ( (UCASE(qMetaData.COLUMN_NAME[i]) neq UCASE('objectID')) AND (UCASE(qMetaData.COLUMN_NAME[i]) neq UCASE('attributeName')) ) {
					colsList[ArrayLen(colsList) + 1] = qMetaData.COLUMN_NAME[i];
					mdataList[ArrayLen(mdataList) + 1] = qMetaData.TYPE_NAME[i];
				}
			}
		
			n = ArrayLen(colsList);
			for (i = 1; i lte n; i = i + 1) {
				bool_dataElementExists = true;
				try {
					colVal = URLDecode(_dataStruct_[colsList[i]]);
				} catch (Any e) {
					bool_dataElementExists = false;
				}
				if (bool_dataElementExists) {
					colsToAdd = ListAppend(colsToAdd, colsList[i], ',');
					switch (mdataList[i]) {
						case 'smalldatetime':
							colVal = CreateODBCDateTime(ParseDateTime(colVal));
						break;

						case 'text':
						case 'varchar':
							colVal = "'#colVal#'";
						break;
					}
					valsToAdd = ListAppend(valsToAdd, colVal, ',');
				}
			}
			if (ListLen(colsToAdd, ',') gt 0) {
				_colsToAdd = ',' & colsToAdd;
			}
			if (ListLen(valsToAdd, ',') gt 0) {
				_valsToAdd = ',' & valsToAdd;
			}
		</cfscript>
		
		<cfsavecontent variable="_sql_GeonosisAddAttribute">
			<cfoutput>
				INSERT INTO objectAttributes
				       (objectID, attributeName#_colsToAdd#)
				VALUES (#_objectID_#,'#_attributeName_#'#_valsToAdd#);
				SELECT @@IDENTITY as 'id';
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisAddAttribute>
	</cffunction>

	<cffunction name="sql_GeonosisAddObject" access="private" returntype="string">
		<cfargument name="_objectClassID_" type="numeric" required="yes">
		<cfargument name="_objectName_" type="string" required="yes">
		<cfargument name="_dataStruct_" type="struct" required="yes">

		<cfset var i = -1>
		<cfset var n = -1>
		<cfset var bool_dataElementExists = false>
		<cfset var colsToAdd = "">
		<cfset var _colsToAdd = "">
		<cfset var valsToAdd = "">
		<cfset var _valsToAdd = "">
		<cfset var colVal = "">
		<cfset var qMetaData = getDbMetaDataForObjects().QCOLUMNS>
		<cfset var colsList = ArrayNew(1)>
		<cfset var mdataList = ArrayNew(1)>
		
		<cfscript>
			n = qMetaData.recordCount;
			for (i = 1; i lte n; i = i + 1) {
				if ( (UCASE(qMetaData.COLUMN_NAME[i]) neq UCASE('objectClassID')) AND (UCASE(qMetaData.COLUMN_NAME[i]) neq UCASE('objectName')) ) {
					colsList[ArrayLen(colsList) + 1] = qMetaData.COLUMN_NAME[i];
					mdataList[ArrayLen(mdataList) + 1] = qMetaData.TYPE_NAME[i];
				}
			}
		
			n = ArrayLen(colsList);
			for (i = 1; i lte n; i = i + 1) {
				bool_dataElementExists = true;
				try {
					colVal = URLDecode(_dataStruct_[colsList[i]]);
				} catch (Any e) {
					bool_dataElementExists = false;
				}
				if (bool_dataElementExists) {
					colsToAdd = ListAppend(colsToAdd, colsList[i], ',');
					switch (mdataList[i]) {
						case 'smalldatetime':
							colVal = CreateODBCDateTime(ParseDateTime(colVal));
						break;

						case 'varchar':
							colVal = "'#colVal#'";
						break;
					}
					valsToAdd = ListAppend(valsToAdd, colVal, ',');
				}
			}
			if (ListLen(colsToAdd, ',') gt 0) {
				_colsToAdd = ',' & colsToAdd;
			}
			if (ListLen(valsToAdd, ',') gt 0) {
				_valsToAdd = ',' & valsToAdd;
			}
		</cfscript>
		
		<cfsavecontent variable="_sql_GeonosisAddObject">
			<cfoutput>
				INSERT INTO objects
				       (objectClassID, objectName#_colsToAdd#)
				VALUES (#_objectClassID_#,'#_objectName_#'#_valsToAdd#);
				SELECT @@IDENTITY as 'id';
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisAddObject>
	</cffunction>

	<cffunction name="sql_GeonosisDropObjectById" access="private" returntype="string">
		<cfargument name="_objectID_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisDropObjectById">
			<cfoutput>
				DECLARE @numRecs as int; 
				
				SELECT @numRecs = (SELECT COUNT(objectID) as cnt
				                   FROM objectAttributes
				                   WHERE (objectID = #_objectID_#));
				                   
				SELECT @numRecs = @numRecs + (SELECT COUNT(id) as cnt
				                              FROM objectLinks
				                              WHERE (ownerId = #_objectID_#) OR (relatedId = #_objectID_#));
				
				IF (@numRecs = 0)
				BEGIN
					DELETE FROM objects WHERE (id = #_objectID_#);
				END;
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisDropObjectById>
	</cffunction>

	<cffunction name="sql_GeonosisAddClassDef" access="private" returntype="string">
		<cfargument name="_className_" type="string" required="yes">
		<cfargument name="_classPath_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisAddClassDef">
			<cfoutput>
				INSERT INTO objectClassDefinitions
				       (className, classPath)
				VALUES ('#_className_#','#_classPath_#')
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisAddClassDef>
	</cffunction>

	<cffunction name="sql_GeonosisDropClassDef" access="private" returntype="string">
		<cfargument name="_objectClassID_" type="string" required="yes">

		<cfsavecontent variable="_sql_GeonosisDropClassDef">
			<cfoutput>
				DECLARE @numRecs as int; 
				
				SELECT @numRecs = (SELECT COUNT(objectClassID) AS cnt
				                   FROM objects
				                   WHERE (objectClassID = #_objectClassID_#));
				                   
				IF (@numRecs = 0)
				BEGIN
					DELETE FROM objectClassDefinitions WHERE (objectClassID = #_objectClassID_#);
				END;
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_GeonosisDropClassDef>
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
		
		function getDbMetaDataForObjectClassDefs() {
			return _getDbMetaData(Request.Geonosis_DBname, 'objectClassDefinitions');
		}
		
		function getDbMetaDataForObjects() {
			var i = -1;
			var qO = _getDbMetaData(Request.Geonosis_DBname, 'objects');
			for (i = 1; i lte qO.QCOLUMNS.recordCount; i = i + 1) {
				if (UCASE(qO.QCOLUMNS.COLUMN_NAME[i]) eq UCASE('objectClassID')) {
					qO.QCOLUMNS.TYPE_NAME[i] = qO.QCOLUMNS.TYPE_NAME[i] & ' identity'; // flag this column manually because there is no referential integrity check in the Db for this fact...
					break;
				}
			}
			return qO;
		}
		
		function getDbMetaDataForObjectAttributes() {
			var i = -1;
			var qO = _getDbMetaData(Request.Geonosis_DBname, 'objectAttributes');
			for (i = 1; i lte qO.QCOLUMNS.recordCount; i = i + 1) {
				if (UCASE(qO.QCOLUMNS.COLUMN_NAME[i]) eq UCASE('objectID')) {
					qO.QCOLUMNS.TYPE_NAME[i] = qO.QCOLUMNS.TYPE_NAME[i] & ' identity'; // flag this column manually because there is no referential integrity check in the Db for this fact...
					break;
				}
			}
			return qO;
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
