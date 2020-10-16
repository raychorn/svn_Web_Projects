<cfcomponent name="geonosisObject" extends="commonCode">
	<cfscript>
		this.DSN = '';
		this.qObjectID = -1;
	</cfscript>

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

	<cfscript>
		function init(sDSN) {
			this.DSN = sDSN;
			return this;
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
