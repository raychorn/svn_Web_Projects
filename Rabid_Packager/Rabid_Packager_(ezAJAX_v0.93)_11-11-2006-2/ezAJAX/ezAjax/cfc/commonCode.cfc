<cfcomponent displayname="CommonCode" output="No" extends="ezAjaxCode">
	<cfscript>
		this.struct_CFtoJS_variables = StructNew();

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
		
	</cfscript>
</cfcomponent>
