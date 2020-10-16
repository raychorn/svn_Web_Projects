<cfsavecontent variable="_jsInitCode">
	<cfoutput>
		if (!!qObj) {
		} else {
			var qObj = -1;
		}
		qObj = AJAXObj.getInstance();
		_qObj = new Object();
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="_jsCode_">
	<cfoutput>
		#Request.commonCode.populate_JS_queryObj(Request.qryObj, '_qObj.qParms', true)#
		qObj.init();
		<cfif (IsDefined("Request.qryData"))>
			<cfif (IsArray(Request.qryData))>
				<cfset n = ArrayLen(Request.qryData)>

				<cfscript>
					qStats = QueryNew('num');
					QueryAddRow(qStats, 1);
					QuerySetCell(qStats, 'num', n, qStats.recordCount);
				</cfscript>

				#Request.commonCode.populate_JS_queryObj(qStats, '_qObj.qStats', true)#
				qObj.push('qDataNum', _qObj.qStats);
				<cfloop index="_i" from="1" to="#n#">
					#Request.commonCode.populate_JS_queryObj(Request.qryData[_i], '_qObj.qData#_i#', true)#
					qObj.push('qData#_i#', _qObj.qData#_i#);
				</cfloop>
			</cfif>
		</cfif>
		qObj.push('qParms', _qObj.qParms);
		_qObj = null;
	</cfoutput>
</cfsavecontent>

<cfscript>
	_jsFinaleCode = '';
	if (UCASE(Request.qryStruct.callBack) neq 'UNDEFINED') {
		_jsFinaleCode = Request.qryStruct.callBack;
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
		writeOutput('JS Code: (#_jsInitCode#) <textarea cols="100" readonly rows="10" style="font-size: 10px; font-family: courier;">[#_jsCode#]</textarea><br>');
	</cfscript>
	<!--- END! create a JavaScript object to store the query object --->

	<cfoutput>
		<script language="JavaScript1.2" type="text/javascript">
		<!--//
			#Request.parentKeyword#server_response_queue = [];
			
			#Request.parentKeyword#server_response_queue.push("#_jsCode#");
	
			// this passes the packet back to the client
			if (#Request.parentKeyword#oGateway) {
				#Request.parentKeyword#oGateway.receivePacket(#Request.parentKeyword#server_response_queue);
			}
		//-->
		</script>
	</cfoutput>

	</body>
	</html>
</cfif>
 