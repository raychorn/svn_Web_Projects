<cfparam name="bool_canDebugHappen" type="boolean" default="false">

<cfif (bool_canDebugHappen)>
	<cfdump var="#Request.qryStruct#" label="Request.qryStruct" expand="No">

	<table width="100%" cellpadding="-1" cellspacing="-1">
		<tr>
			<td>
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td>
							<cfdump var="#Application#" label="App Scope" expand="No">
						</td>
						<td>
							<cfdump var="#Session#" label="Session Scope" expand="No">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</cfif>

<cfscript>
	___jsName___ = 'qObj';
	if (IsDefined("Request.qryStruct.___jsName___")) {
		___jsName___ = Request.qryStruct.___jsName___;
	}
</cfscript>

<cfsavecontent variable="_jsInitCode">
	<cfoutput>
		if (!!#___jsName___#) {
		} else {
			var #___jsName___# = -1;
		}
		#___jsName___# = ezAJAXObj.get$();
		_#___jsName___# = new Object();
	</cfoutput>
</cfsavecontent>

<cfscript>
	_bool_isCommunityEditionFlag = ( (IsDefined("aRuntimeLicenseStruct.ISCOMMUNITYEDITION")) AND (aRuntimeLicenseStruct.ISCOMMUNITYEDITION) );
</cfscript>
<cfif (_bool_isCommunityEditionFlag)>
	<cfscript>
		_qryObj = QueryNew(Request.qryObj.columnList);
		bool_isOkayToUseRecs = false;
		arCols = ListToArray(Request.qryObj.columnList, ',');
		nCols = ArrayLen(arCols);
		for (i = 1; i lte Request.qryObj.recordCount; i = i + 1) {
			if (NOT bool_isOkayToUseRecs) {
				bool_isOkayToUseRecs = (Request.qryObj.NAME[i] is 'argCnt');
			}
			if (bool_isOkayToUseRecs) {
				QueryAddRow(_qryObj, 1);
				for (j = 1; j lte nCols; j = j + 1) {
					QuerySetCell(_qryObj, arCols[j], Request.qryObj[arCols[j]][i], _qryObj.recordCount);
				}
			}
		}
		Request.qryObj = _qryObj;
	</cfscript>
</cfif>
<cfscript>
	_qryObj = QueryNew(Request.qryObj.columnList);
	arCols = ListToArray(Request.qryObj.columnList, ',');
	nCols = ArrayLen(arCols);
	QueryAddRow(_qryObj, 1);
	QuerySetCell(_qryObj, 'NAME', 'isCommunityEdition', _qryObj.recordCount);
	QuerySetCell(_qryObj, 'VAL', _bool_isCommunityEditionFlag, _qryObj.recordCount);
	for (i = 1; i lte Request.qryObj.recordCount; i = i + 1) {
		QueryAddRow(_qryObj, 1);
		for (j = 1; j lte nCols; j = j + 1) {
			QuerySetCell(_qryObj, arCols[j], Request.qryObj[arCols[j]][i], _qryObj.recordCount);
		}
	}
	Request.qryObj = _qryObj;
</cfscript>

<cfsavecontent variable="_jsCode_">
	<cfoutput>
		#Request.commonCode.populate_JS_queryObj(Request.qryObj, '_#___jsName___#.qParms', true)#
		if (#___jsName___# != null) #___jsName___#.init();
		<cfif (IsDefined("Request.qryData"))>
			<cfif (IsArray(Request.qryData))>
				<cfset n = ArrayLen(Request.qryData)>

				<cfscript>
					qStats = QueryNew('num'); 
					QueryAddRow(qStats, 1); 
					QuerySetCell(qStats, 'num', n, qStats.recordCount); 
				</cfscript>

				#Request.commonCode.populate_JS_queryObj(qStats, '_#___jsName___#.qStats', true)#
				#___jsName___#.push('qDataNum', _#___jsName___#.qStats); 
				<cfloop index="_i" from="1" to="#n#">
					<cfscript>
						_qName = '';
						try {
							_qName = Request.qryData[_i]['aName'];
						} catch (Any e) {
						}
						if (Len(_qName) gt 0) {
							writeOutput(Request.commonCode.populate_JS_queryObj(Request.qryData[_i]['qObj'], '_#___jsName___#.#_qName#', true));
							writeOutput("#___jsName___#.push('#_qName#', _#___jsName___#.#_qName#);");
						} else {
							writeOutput(Request.commonCode.populate_JS_queryObj(Request.qryData[_i], '_#___jsName___#.qData#_i#', true));
							writeOutput("#___jsName___#.push('qData#_i#', _#___jsName___#.qData#_i#);");
						}
					</cfscript>
				</cfloop>
			</cfif>
		</cfif>
		#___jsName___#.push('qParms', _#___jsName___#.qParms); 
		_#___jsName___# = null; 
	</cfoutput>
</cfsavecontent>

<cfscript>
	_jsFinaleCode = '';
	if (NOT IsDefined("Request.qryStruct.ezCallBack")) {
		Request.qryStruct.ezCallBack = 'ezAlert(\"No callback was specified...\")';
	}
	if (UCASE(Request.qryStruct.ezCallBack) neq 'UNDEFINED') {
		_jsFinaleCode = "ezAJAXEngine.receivePacket(eval(ezAJAXEngine.js_global_varName), " & Request.qryStruct.ezCallBack & ")";
		openParen_i = Find('(', _jsFinaleCode);
		closeParen_i = Find(')', _jsFinaleCode, openParen_i);
		if ( (openParen_i eq 0) AND (closeParen_i eq 0) ) {
			_jsFinaleCode = _jsFinaleCode & '()';
		}
		if (Find(';', _jsFinaleCode) eq 0) {
			_jsFinaleCode = _jsFinaleCode & ';';
		}
	}
</cfscript>

<cfif (bool_using_xmlHttpRequest)>
	<cfoutput>
		/* BOF CFAJAX */
		#_jsInitCode#
		#ReplaceList(_jsCode_, Chr(13) & "," & Chr(10) & ",parent.", ",,")#
		#_jsFinaleCode#
		/* EOF CFAJAX */
	</cfoutput>
<cfelse>
	<!--- BEGIN: create a JavaScript object to store the query object --->
	<cfscript>
		_jsCode = _jsCode_;
		_jsCode = _jsInitCode & _jsCode & _jsFinaleCode;
		_jsCode = ReplaceList(_jsCode, Chr(13) & "," & Chr(10) & ",parent.", ",,");
		if (bool_canDebugHappen) writeOutput('JS Code: (#_jsInitCode#) (length=#Len(_jsCode)#) <textarea cols="100" readonly rows="10" style="font-size: 10px; font-family: courier;">[#_jsCode#]</textarea><br>');
	</cfscript>
	<!--- END! create a JavaScript object to store the query object --->

	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			#Request.parentKeyword#server_response_queue = [];
			
			#Request.parentKeyword#server_response_queue.push("#_jsCode#");
	
			// this passes the packet back to the client
			if (#Request.parentKeyword#oAJAXEngine) {
				#Request.parentKeyword#oAJAXEngine.receivePacket(#Request.parentKeyword#server_response_queue);
			}
		//-->
		</script>
	</cfoutput>

	</body>
	</html>
</cfif>
 