<cfcomponent displayname="GeonosisSupport" hint="(c). Copyright 1990-2006 Hierarchical Applications Limited, All Rights Reserved. The functions and data contained herein may only be used within the context of the ezAJAX&##8482 Framework Product, any other use is strictly forbidden." output="No" extends="ezAjaxCode">
	<cfscript>
		this.HEX = "0123456789ABCDEF";
		this.hexMask = BitSHLN(255, 24);  // FF000000

		this.struct_CFtoJS_variables = StructNew();
	</cfscript>

	<cffunction name="rs2Query" output="false" access="private">
		<cfargument name="resultset" type="any" required="true">
		
		<cfset var rs = resultset>
		<cfset var x = false>
		<cfset var col = false>
		<cfset var colnames = "">
		<cfset var tableData = false>
		
		<cfif isobject(resultset) AND findnocase("resultset",resultset.getClass().getName())>
			<cfset tabledata = resultset.getMetaData()>
			<cfloop index="x" from="1" to="#tableData.getColumnCount()#">
				<cfset colnames = listappend(colnames,tableData.getColumnName(JavaCast("int",x)))>
			</cfloop>
			<cfset rs = querynew(colnames)>
			
			<cfloop condition="resultset.next()">
				<cfif resultset.getRow()>
					<cfset queryaddrow(rs)>
					<cfset x = rs.recordcount>
					<cfloop index="col" list="#colnames#">
						<cfset rs[col][x] = resultset.getString(JavaCast("string",col))>
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn rs>
	</cffunction>

	<cffunction name="jdbcType" output="false" returntype="string" access="private">
		<cfargument name="typeid" type="string" required="true">
		
		<cfset var sqltype = createobject("java","java.sql.Types")>
		<cfset var types = structnew()>
		
		<cfloop item="x" collection="#sqltype#">
			<cfset types[x] = sqltype[x]>
			<cfset types[sqltype[x]] = x>
		</cfloop>
		
		<cfreturn types[typeid]>
	</cffunction>

	<cffunction name="oJDBCMetaData" returntype="struct" access="private">
		<cfargument name="_dsn_" type="string" required="true">
		<cfargument name="_username_" type="string" required="true">
		<cfargument name="_password_" type="string" required="true">

		<cfscript>
			var aStruct = StructNew();
			var factory = -1;
		</cfscript>

		<cflock name="coldfusion.server.ServiceFactory" type="exclusive" timeout="10">
			<cfscript>
				factory = CreateObject("java", "coldfusion.server.ServiceFactory");
				aStruct.ds_service = factory.datasourceservice;
				aStruct.conn = aStruct.ds_service.getDataSource(_dsn_).getConnection(_username_,_password_);
				aStruct.mdata = aStruct.conn.getMetaData();
			</cfscript>			
		</cflock>
		
		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCCatalog" returntype="struct" access="private">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		
		<cfscript>
			var aStruct = StructNew();

			aStruct.rsCatalog = _oMetaData_.mdata.getCatalogs();
			aStruct.qCatalog = rs2Query(aStruct.rsCatalog);
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCSchema" returntype="struct" access="private">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		
		<cfscript>
			var aStruct = StructNew();

			aStruct.rsSchemas = _oMetaData_.mdata.getSchemas();
			aStruct.qSchemas = rs2Query(aStruct.rsSchemas);
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCTables" returntype="struct" access="private">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		<cfargument name="_schemaName_" type="string" required="true">
		
		<cfscript>
			var aStruct = StructNew();

			aStruct.rsTables = _oMetaData_.mdata.getTables(JavaCast("null",""), _schemaName_, JavaCast("null",""), JavaCast("null",""));
			aStruct.qTables = rs2Query(aStruct.rsTables);
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCTableTypes" returntype="struct" access="private">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		
		<cfscript>
			var aStruct = StructNew();

			aStruct.rsTableTypes =  _oMetaData_.mdata.getTableTypes();
			aStruct.qTableTypes = rs2Query(aStruct.rsTableTypes);
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCColumns" returntype="struct" access="private">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		<cfargument name="_DbName_" type="string" required="true">
		<cfargument name="_tableName_" type="string" required="true">
		
		<cfscript>
			var aStruct = StructNew();
			var i = -1;

			aStruct.rsColumns = _oMetaData_.mdata.getColumns(_DbName_,"%",_tableName_,"%");
			aStruct.qColumns = rs2Query(aStruct.rsColumns);

			for (i = 1; i lte aStruct.qColumns.recordCount; i = i + 1) {
				aStruct.qColumns.data_type[i] = jdbcType(aStruct.qColumns.data_type[i]);
			}
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cfscript>
		function registerCFtoJS_variable(vName, vVal) {
			if (NOT IsDefined("this.struct_CFtoJS_variables.names_stack")) {
				this.struct_CFtoJS_variables.names_stack = ArrayNew(1);
				this.struct_CFtoJS_variables.names_cache = StructNew();
			}
			this.struct_CFtoJS_variables.names_stack[ArrayLen(this.struct_CFtoJS_variables.names_stack) + 1] = vName;
			this.struct_CFtoJS_variables.names_cache[vName] = vVal;
		}

		function emitCFtoJS_variables() {
			var i = -1;
			var aName = '';
			var ar = -1;
			var n = ArrayLen(this.struct_CFtoJS_variables.names_stack);

			writeOutput(ezBeginJavaScript() & Request.const_Cr);			
			for (i = 1; i lte n; i = i + 1) {
				aName = this.struct_CFtoJS_variables.names_stack[i];
				ar = ListToArray(aName, '_');
				if (UCASE(ar[1]) eq UCASE('cf')) {
					ar[1] = 'js';
				}
				writeOutput(ArrayToList(ar, '_') & " = '#JSStringFormat(this.struct_CFtoJS_variables.names_cache[aName])#';" & Request.const_Cr);
			}
			writeOutput(ezEndJavaScript() & Request.const_Cr);
		}
		
		function objectForType(objType) {
			var anObj = -1;
			var bool_isError = false;
			var dotPath = objType;
			var _sql_statement = '';
			var thePath = '';

			bool_isError = ezCfDirectory('Request.qDir', ListDeleteAt(CGI.CF_TEMPLATE_PATH, ListLen(CGI.CF_TEMPLATE_PATH, '\'), '\'), objType & '.cfc', true);
			if (NOT bool_isError) {
				bool_isError = ezCfDirectory('Request.qDir2', ListDeleteAt(CGI.CF_TEMPLATE_PATH, ListLen(CGI.CF_TEMPLATE_PATH, '\'), '\'), 'ezAjaxCode.cfc', true);
				thePath = Trim(ReplaceNoCase(ReplaceNoCase(Request.qDir.DIRECTORY, Request.qDir2.DIRECTORY, ''), '\', '.'));
			}

			if (Len(thePath) gt 0) {
				thePath = thePath & '.';
			}
			dotPath = thePath & dotPath;
			if (Left(dotPath, 1) eq '.') {
				dotPath = Right(dotPath, Len(dotPath) - 1);
			}

			Request.err_objectFactory = false;
			Request.err_objectFactoryMsg = '';
			Request.err_objectFactoryMsgHtml = '';
			try {
			   anObj = CreateObject("component", dotPath);
			} catch(Any e) {
				Request.err_objectFactory = true;
				Request.err_objectFactoryMsg = 'The object factory was unable to create the object for type "#objType#".';
				Request.err_objectFactoryMsgHtml = '<font color="red"><b>#Request.err_objectFactoryMsg# [dotPath=#dotPath#] (#explainError(e, true)#)</b></font><br>';
			}
			return anObj;
		}

		function _num2Hex(n) {
			var i = -1;
			var hx = '';
			var mask = this.hexMask;
			var masked = 0;
			var shiftVal = 24;
			
			for (i = 1; i lte 4; i = i + 1) {
				masked = BitSHRN(BitAnd(n, mask), shiftVal);
				if (masked gt 0) {
					hx = hx & Chr(Asc(Mid(this.HEX, BitAnd(BitSHRN(masked, 4), 15) + 1, 1)) + 16);
					hx = hx & Chr(Asc(Mid(this.HEX, BitAnd(masked, 15) + 1, 1)) + 16);
				}
				mask = BitSHRN(mask, 8);
				shiftVal = shiftVal - 8;
			}
			
			return hx;
		}
		
		function num2Hex(n) {
			return Chr(Asc(Len(n)) + 32) & _num2Hex(n);
		}
		
		function hex2num(h) {
			var i = -1;
			var n = -1;
			var x = -1;
			var ch = -1;
			var num = 0;
			
			n = Len(h);
			for (i = 1; i lte n; i = i + 1) {
				if (i gt 1) num = BitSHLN(num, 4);
				ch = Mid(h, i, 1);
				x = (Asc(ch) - 16) - Asc('0');
				if (x gt 9) {
					x = x - 7;
				}
				num = num + x;
			}
			return num;
		}
		
		function encodedEncryptedString(plainText) {
			var theKey = generateSecretKey(Request.const_encryption_method);
			var _encrypted = encrypt(plainText, theKey, Request.const_encryption_method, Request.const_encryption_encoding);
			return num2Hex(Len(theKey)) & theKey & num2Hex(Len(_encrypted)) & _encrypted;
		}

		function decodeEncodedEncryptedString(eStr) {
			var i = 1;
			var data = StructNew();
			data.hexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.keyLen = hex2num(Mid(eStr, i, data.hexLen));
			i = i + data.hexLen;
			data.theKey = Mid(eStr, i, data.keyLen);
			i = i + data.keyLen;
			data.isKeyValid = (Len(data.theKey) eq data.keyLen);
			data.i = i;

			data.encHexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.encLen = hex2num(Mid(eStr, i, data.encHexLen));
			i = i + data.encHexLen;
			data.encrypted = Mid(eStr, i, data.encLen);
			i = i + data.encLen;
			data.isEncValid = (Len(data.encrypted) eq data.encLen);
			data.i = i - 1;

			data.iLen = Len(eStr);
			data.iValid = (data.i eq data.iLen);
			
			data.error = '';
			data.plaintext = '';
			try {
				data.plaintext = Decrypt(data.encrypted, data.theKey, Request.const_encryption_method, Request.const_encryption_encoding);
			} catch (Any e) {
				data.error = 'ERROR - cannot decrypt your encrypted data. ' & '[' & ezExplainError(e, false) & ']' & ', [const_encryption_method=#Request.const_encryption_method#]' & ', [const_encryption_encoding=#Request.const_encryption_encoding#]';
			}

			return data;
		}

		function ezRegisterNamedQueryFromAJAX(aName, qObj) {
			// This function needs to accept a name and a query both of which need to be placed into the array via a Struct.
			var aStruct = StructNew();

			aStruct.aName = aName;
			aStruct.qObj = qObj;
			
			return ezRegisterQueryFromAJAX(aStruct);
		}
		
	</cfscript>
</cfcomponent>
