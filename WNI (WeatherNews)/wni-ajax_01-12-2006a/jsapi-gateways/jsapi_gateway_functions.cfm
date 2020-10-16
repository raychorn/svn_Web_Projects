<!--- BEGIN: This block of code sets-up the Request.qryObj which is a ColdFusion Query Object that holds the parms from the AJAX call --->
<!--- Request.qryStruct also contains the variables that were passed-in from the caller... --->
<cfinclude template="cfinclude_jsapi_gateway_abstractions.cfm">
<!--- END! This block of code sets-up the Request.qryObj which is a ColdFusion Query Object that holds the parms from the AJAX call --->

<!--- This is where you may code your ColdFusion code that processes the AJAX Function --->
<cfscript>
	switch (Request.qryStruct.cfm) {
		case 'dropTopLevelMenuName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qDropTopLevelMenuName', Request.INTRANET_DS, "DELETE FROM AvnMenu WHERE (id = '#Request.commonCode.filterIntForSQL(Request.qryStruct.arg1)#'); SELECT id, menuName FROM AvnMenu ORDER BY menuName");
	
				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qDropTopLevelMenuName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: dropTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'addTopLevelMenuName':
			if (Request.qryStruct.argCnt gt 0) {
				Request.commonCode.safely_execSQL('Request.qAddTopLevelMenuName', Request.INTRANET_DS, "INSERT INTO AvnMenu (menuName) VALUES ('#Request.commonCode.filterQuotesForSQL(Request.qryStruct.arg1)#'); SELECT id, menuName FROM AvnMenu ORDER BY menuName");
	
				if (NOT Request.dbError) {
					Request.commonCode.registerQueryFromAJAX(Request.qAddTopLevelMenuName);
				} else {
					qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
					QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
					QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
					Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				}
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', 'WARNING: (#CGI.SCRIPT_NAME#) :: addTopLevelMenuName - Missing arguments.', qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;

		case 'getTopLevelMenuNames':
			QueryAddRow(Request.qryObj, 1);
			QuerySetCell(Request.qryObj, 'NAME', 'Rcvd', Request.qryObj.recordCount);
			QuerySetCell(Request.qryObj, 'VAL', 'getTopLevelMenuNames', Request.qryObj.recordCount);

			// Your code goes here to perform SQL Query or other processing
		//	qObj = QueryNew('id, myCol1, myCol2');
		//	QueryAddRow(qObj, 1);
		//	QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
		//	QuerySetCell(qObj, 'myCol1', 'This is my data element ##1', qObj.recordCount);
		//	QuerySetCell(qObj, 'myCol2', 'This is my data element ##2', qObj.recordCount);
		//	Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...

			Request.commonCode.safely_execSQL('Request.qGetTopLevelMenuNames', Request.INTRANET_DS, "SELECT id, menuName FROM AvnMenu ORDER BY menuName");
			
			if (NOT Request.dbError) {
				Request.commonCode.registerQueryFromAJAX(Request.qGetTopLevelMenuNames); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			} else {
				qObj = QueryNew('id, errorMsg, moreErrorMsg, explainError, isPKviolation');
				QueryAddRow(qObj, 1);
				QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
				QuerySetCell(qObj, 'errorMsg', Request.errorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'moreErrorMsg', Request.moreErrorMsg, qObj.recordCount);
				QuerySetCell(qObj, 'explainError', Request.explainError, qObj.recordCount);
				QuerySetCell(qObj, 'isPKviolation', Request.isPKviolation, qObj.recordCount);
				Request.commonCode.registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
			}
		break;
	}
</cfscript>
<cfdump var="#Request.qryStruct#" label="Request.qryStruct" expand="No">
<!--- the name of the cfm page is stored in the following variable: Request.qryObj.NAME["cfm"] --->

<!--- BEGIN: This block of code passes the Request.qryObj which is a ColdFusion Query Object back to the AJAX caller via a JavaScript object called qObj --->
<cfinclude template="cfinclude_jsapi_gateway_abstractions_finale.cfm">
<!--- END! This block of code passes the Request.qryObj which is a ColdFusion Query Object back to the AJAX caller via a JavaScript object called qObj --->
