<cfcomponent displayname="ajaxFunctions" output="Yes" extends="ajaxCode">
	<cffunction name="doAJAXFunction" access="public" returntype="Any">
		<cfscript>
			beginAJAX();
		</cfscript>

		<cfsavecontent variable="html_theForm">
			<cfoutput>
				<form id="form_enkrip">
					<TEXTAREA class="textClass" rows="8" name="kodeawal" id="kodeawal" cols="70" wrap="virtual"></TEXTAREA> 
					<TEXTAREA class="textClass" readonly rows="8" name="hasil" id="hasil" cols="70" wrap="virtual"></TEXTAREA>
					<br><span class="textClass">Key:&nbsp;</span><input type="text" class="textClass" name="parameter" value="2" size="30" maxlength="50"> 
					<br><span class="textClass">Input Length:&nbsp;</span><input type="text" class="textClass" id="form_enkrip_input_length" size="11" />
					<br><span class="textClass">Diff Length:&nbsp;</span><input type="text" class="textClass" name="form_enkrip_diff_length" size="11" />
					<br><span class="textClass">Enkrip Length:&nbsp;</span><input type="text" class="textClass" name="form_enkrip_enkrip_length" size="11" />
				</form>
			</cfoutput>
		</cfsavecontent>
		
		<!--- This is where you may code your ColdFusion code that processes the AJAX Function --->
		<cfscript>
			switch (Request.qryStruct.cfm) {
				case 'performTest':
					// Your code goes here to perform SQL Query or other processing
					qObj = QueryNew('id, myCol1, myCol2');
					QueryAddRow(qObj, 1);
					QuerySetCell(qObj, 'id', qObj.recordCount, qObj.recordCount);
					QuerySetCell(qObj, 'myCol1', 'This is my data element ##1', qObj.recordCount);
					QuerySetCell(qObj, 'myCol2', 'This is my data element ##2', qObj.recordCount);
					registerQueryFromAJAX(qObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
		
					registerQueryFromAJAX(Request.qryObj); // this function is used to tell the AJAX system what Query(s) you wish to communicate back to JavaScript - you can register as many Query Objects as you wish... he CF Var named Request.qryData is used to hold an array of Query Objects...
				break;
			}
		</cfscript>
		<cfdump var="#Request.qryStruct#" label="Request.qryStruct" expand="No">
		<!--- the name of the cfm page is stored in the following variable: Request.qryObj.NAME["cfm"] --->
	
		<cfscript>
			endAJAX();
		</cfscript>
	</cffunction>

</cfcomponent>
