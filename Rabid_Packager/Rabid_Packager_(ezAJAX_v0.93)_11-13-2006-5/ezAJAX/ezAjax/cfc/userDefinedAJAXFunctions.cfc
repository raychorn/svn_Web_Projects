<cfcomponent displayname="userDefinedAJAXFunctions" output="No" extends="geonosisSupport">

	<cfscript>
		cf_trademarkSymbol = '&##8482';
	</cfscript>

	<cfparam name="Request.cfcPrefix" type="string" default="*** Unknown ***">

	<cffunction name="serverCommandCFCTemplate" output="No" access="private" returntype="string">
		<cfargument name="_cfcName" required="Yes" type="string">
		
		<cfset var _content = "">
		<cfif (Len(_cfcName) gt 0)>
			<cfscript>
				_content = _content & '<cfcomponent displayname="#_cfcName#" output="No" extends="userDefinedAJAXFunctions">' & Chr(13);
				_content = _content & RepeatString(Chr(9), 1) & '<cfscript>' & Chr(13);
				_content = _content & RepeatString(Chr(9), 2) & 'function _userDefinedAJAXFunctions(qryStruct) {' & Chr(13);
				_content = _content & RepeatString(Chr(9), 3) & 'try {' & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & 'switch (qryStruct.ezCFM) {' & Chr(13);
				_content = _content & RepeatString(Chr(9), 5) & "case '#_cfcName#':" & Chr(13);
				_content = _content & RepeatString(Chr(9), 5) & 'break;' & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & '}' & Chr(13);
				_content = _content & RepeatString(Chr(9), 3) & '} catch (Any e) {' & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & "qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation, isHTML');" & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & 'QueryAddRow(qObj, 1);' & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & "QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);" & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & "QuerySetCell(qObj, 'errorMsg', '<font color=" & '"' & "red" & '"' & "><b>Something dreadful just happened... :: Reason: " & '"' & "#ezExplainError(e, false)#" & '"' & " [#Request.cfcPrefix#]</b></font>', qObj.recordCount);" & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & "QuerySetCell(qObj, 'moreErrorMsg', '', qObj.recordCount);" & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & "QuerySetCell(qObj, 'explainError', '', qObj.recordCount);" & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & "QuerySetCell(qObj, 'isPKviolation', '', qObj.recordCount);" & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & "QuerySetCell(qObj, 'isHTML', 1, qObj.recordCount);" & Chr(13);
				_content = _content & RepeatString(Chr(9), 4) & 'ezRegisterQueryFromAJAX(qObj); // this function is used to tell the ezAJAX(tm) system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...' & Chr(13);
				_content = _content & RepeatString(Chr(9), 3) & '}' & Chr(13);
				_content = _content & RepeatString(Chr(9), 2) & '}' & Chr(13);
				_content = _content & RepeatString(Chr(9), 1) & '<' & '/' & 'cfscript>' & Chr(13);
				_content = _content & '<' & '/' & 'cfcomponent>' & Chr(13);
			</cfscript>
		</cfif>
		
		<cfreturn _content>
	</cffunction>
	
	<cfscript>
		function userDefinedAJAXFunctions(qryStruct) {
			var errMsg = '';
			var ar = -1;
			var n = -1;
			var _ar = -1;
			var _n = -1;
			var i = -1;
			var cfcContent = '';
			var cfcName = '';
			var errStruct = StructNew();
			
			bool_isServerCommandCFCError = false;
			try {
				ezWebRootPrefix = Request.qryStruct['ezWebRootPrefix'];
			} catch (Any e) {
				bool_isServerCommandCFCError = true;
			}
			
			if (NOT bool_isServerCommandCFCError) {
				try {
					cfcObj = CreateObject("component", qryStruct.ezCFM);
					cfcObj._userDefinedAJAXFunctions(qryStruct);
					bool_isServerCommandCFCError = true;
				} catch (Any e) {
					errMsg = ezExplainError(e, false);
					ar = ListToArray(errMsg, ',');
					n = ArrayLen(ar);
					for (i = 1; i lte n; i = i + 1) {
						_ar = ListToArray(ar[i], '=');
						_n = ArrayLen(_ar);
						if (_n eq 2) {
							errStruct[_ar[1]] = _ar[2];
						}
					}
					if ( (FindNoCase('Could not find the ColdFusion Component ', errStruct['Message']) gt 0) AND (Len(errStruct['missingFileName']) gt 0) ) {
						cfcContent = serverCommandCFCTemplate(errStruct['missingFileName']);
						cfcName = ExpandPath('cfc/' & errStruct['missingFileName'] & '.cfc');
						ezCfFileWrite(cfcName, cfcContent);
						if (Request.fileError) {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation, isHTML');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', '<font color="red"><b>Attempted to make a CFC (#errStruct['missingFileName']#) for an unknown Server Command but something went horribly wrong... :: Reason: "#Request.errorMsg#"</b></font>', qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', '', qObj.recordCount);
							QuerySetCell(qObj, 'explainError', '', qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', '', qObj.recordCount);
							QuerySetCell(qObj, 'isHTML', 1, qObj.recordCount);
							ezRegisterQueryFromAJAX(qObj); // this function is used to tell the ezAJAX(tm) system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						} else {
							qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation, isHTML');
							QueryAddRow(qObj, 1);
							QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
							QuerySetCell(qObj, 'errorMsg', '<font color="blue"><b>Successfully made a CFC (#errStruct['missingFileName']#.cfc) for an unknown Server Command... :: Feel free to edit the contents of the file named "#cfcName#".</b></font>', qObj.recordCount);
							QuerySetCell(qObj, 'moreErrorMsg', '', qObj.recordCount);
							QuerySetCell(qObj, 'explainError', '', qObj.recordCount);
							QuerySetCell(qObj, 'isPKviolation', '', qObj.recordCount);
							QuerySetCell(qObj, 'isHTML', 1, qObj.recordCount);
							ezRegisterQueryFromAJAX(qObj); // this function is used to tell the ezAJAX(tm) system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
						}
					} else {
						qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation, isHTML');
						QueryAddRow(qObj, 1);
						QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
						QuerySetCell(qObj, 'errorMsg', '<font color="red"><b>Something dreadful just happened... :: Reason: "#errMsg#" [#Request.cfcPrefix#]</b></font>', qObj.recordCount);
						QuerySetCell(qObj, 'moreErrorMsg', '', qObj.recordCount);
						QuerySetCell(qObj, 'explainError', '', qObj.recordCount);
						QuerySetCell(qObj, 'isPKviolation', '', qObj.recordCount);
						QuerySetCell(qObj, 'isHTML', 1, qObj.recordCount);
						ezRegisterQueryFromAJAX(qObj); // this function is used to tell the ezAJAX(tm) system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
					}
				}
			}
		}
	</cfscript>
</cfcomponent>
