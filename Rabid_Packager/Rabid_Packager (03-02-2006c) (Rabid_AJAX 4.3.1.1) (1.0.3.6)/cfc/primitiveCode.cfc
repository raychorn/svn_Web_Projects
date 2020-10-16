<cfcomponent displayname="primitiveCode" output="No">
	<cfinclude template="../includes/cfinclude_cflog.cfm">
	<cfinclude template="../includes/cfinclude_cfdump.cfm">
	
	<cfscript>
		const_PK_violation_msg = 'Violation of PRIMARY KEY constraint';
	
		function _isPKviolation(eMsg) {
			var bool = false;
			if (FindNoCase(const_PK_violation_msg, eMsg) gt 0) {
				bool = true;
			}
			return bool;
		}
	</cfscript>
	
	<cffunction name="cfm_nocache" access="public" returntype="string">
		<cfargument name="LastModified" type="string" required="yes">

		<CFSETTING ENABLECFOUTPUTONLY="YES">
		<CFHEADER NAME="Pragma" VALUE="no-cache">
		<CFHEADER NAME="Cache-Control" VALUE="no-cache, must-revalidate">
		<CFHEADER NAME="Last-Modified" VALUE="#LastModified#">
		<CFHEADER NAME="Expires" VALUE="Mon, 26 Jul 1997 05:00:00 EST">
		<CFSETTING ENABLECFOUTPUTONLY="NO">
		
		<cfreturn "True">
	</cffunction>

	<cffunction name="cf_location" access="public" returntype="any">
		<cfargument name="_url_" type="string" required="yes">
	
		<cflocation url="#_url_#" addtoken="No">
	
	</cffunction>

	<cffunction name="cf_execute" access="public" returntype="any">
		<cfargument name="_name_" type="string" required="yes">
		<cfargument name="_args_" type="string" required="yes">
		<cfargument name="_timeout_" type="numeric" required="yes">
	
		<cfset Request.errorMsg = "">	
		<cfset Request.execError = false>	
		<cftry>
			<cfexecute name="#_name_#" arguments="#_args_#" variable="Request.cfexecuteOutput" timeout="#_timeout_#" />

			<cfcatch type="Any">
				<cfset Request.execError = true>	

				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="cf_file_write" access="public" returntype="any">
		<cfargument name="_fName_" type="string" required="yes">
		<cfargument name="_out_" type="string" required="yes">

		<cfset Request.errorMsg = "">	
		<cfset Request.fileError = false>	
		<cftry>
			<cffile action="WRITE" file="#_fName_#" output="#_out_#" attributes="Normal" addnewline="No" fixnewline="No">

			<cfcatch type="Any">
				<cfset Request.fileError = true>	

				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="cf_file_read" access="public" returntype="any">
		<cfargument name="_fName_" type="string" required="yes">
		<cfargument name="_vName_" type="string" required="yes">

		<cfset Request.errorMsg = "">	
		<cfset Request.fileError = false>	
		<cftry>
			<cffile action="READ" file="#_fName_#" variable="#_vName_#">

			<cfcatch type="Any">
				<cfset Request.fileError = true>	

				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="cf_file_delete" access="public" returntype="any">
		<cfargument name="_fName_" type="string" required="yes">

		<cfset Request.errorMsg = "">	
		<cfset Request.fileError = false>	
		<cftry>
			<cffile action="DELETE" file="#_fName_#">

			<cfcatch type="Any">
				<cfset Request.fileError = true>	

				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="safely_execSQL" access="public">
		<cfargument name="_qName_" type="string" required="yes">
		<cfargument name="_DSN_" type="string" required="yes">
		<cfargument name="_sql_" type="string" required="yes">
		<cfargument name="_cachedWithin_" type="string" default="">
		
		<cfscript>
			var q = -1;
		</cfscript>
	
		<cfset Request.errorMsg = "">
		<cfset Request.moreErrorMsg = "">
		<cfset Request.explainError = "">
		<cfset Request.explainErrorHTML = "">
		<cfset Request.dbError = "False">
		<cfset Request.isPKviolation = "False">
		<cftry>
			<cfif (Len(Trim(arguments._qName_)) gt 0)>
				<cfif (Len(_DSN_) gt 0)>
					<cfif (Len(_cachedWithin_) gt 0) AND (IsNumeric(_cachedWithin_))>
						<cfquery name="#_qName_#" datasource="#_DSN_#" cachedwithin="#_cachedWithin_#">
							#PreserveSingleQuotes(_sql_)#
						</cfquery>
					<cfelse>
						<cfquery name="#_qName_#" datasource="#_DSN_#">
							#PreserveSingleQuotes(_sql_)#
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="#_qName_#" dbtype="query">
						#PreserveSingleQuotes(_sql_)#
					</cfquery>
				</cfif>
			<cfelse>
				<cfset Request.errorMsg = "Missing Query Name which is supposed to be the first parameter.">
				<cfthrow message="#Request.errorMsg#" type="missingQueryName" errorcode="-100">
			</cfif>
	
			<cfcatch type="Database">
				<cfset Request.dbError = "True">
	
				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
						<cfif (IsDefined("cfcatch.SQLState"))>[<b>cfcatch.SQLState</b>=#cfcatch.SQLState#]</cfif>
					</cfoutput>
				</cfsavecontent>
	
				<cfsavecontent variable="Request.moreErrorMsg">
					<cfoutput>
						<UL>
							<cfif (IsDefined("cfcatch.Sql"))><LI>#cfcatch.Sql#</LI></cfif>
							<cfif (IsDefined("cfcatch.type"))><LI>#cfcatch.type#</LI></cfif>
							<cfif (IsDefined("cfcatch.message"))><LI>#cfcatch.message#</LI></cfif>
							<cfif (IsDefined("cfcatch.detail"))><LI>#cfcatch.detail#</LI></cfif>
							<cfif (IsDefined("cfcatch.SQLState"))><LI>#cfcatch.SQLState#</LI></cfif>
						</UL>
					</cfoutput>
				</cfsavecontent>
	
				<cfsavecontent variable="Request.explainErrorText">
					<cfoutput>
						[#explainError(cfcatch, false)#]
					</cfoutput>
				</cfsavecontent>
	
				<cfsavecontent variable="Request.explainErrorHTML">
					<cfoutput>
						[#explainError(cfcatch, true)#]
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					if (Len(_DSN_) gt 0) {
						Request.isPKviolation = _isPKviolation(Request.errorMsg);
					}
				</cfscript>
	
				<cfset Request.dbErrorMsg = Request.errorMsg>
				<cfsavecontent variable="Request.fullErrorMsg">
					<cfdump var="#cfcatch#" label="cfcatch">
				</cfsavecontent>
				<cfsavecontent variable="Request.verboseErrorMsg">
					<cfif (IsDefined("Request.bool_show_verbose_SQL_errors"))>
						<cfif (Request.bool_show_verbose_SQL_errors)>
							<cfdump var="#cfcatch#" label="cfcatch :: Request.isPKviolation = [#Request.isPKviolation#]" expand="No">
						</cfif>
					</cfif>
				</cfsavecontent>
	
				<cfscript>
					if ( (IsDefined("Request.bool_show_verbose_SQL_errors")) AND (IsDefined("Request.verboseErrorMsg")) ) {
						if (Request.bool_show_verbose_SQL_errors) {
							if (NOT Request.isPKviolation) 
								writeOutput(Request.verboseErrorMsg);
						}
					}
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="safely_cfmail" access="public" returntype="any">
		<cfargument name="_toAddrs_" type="string" required="yes">
		<cfargument name="_fromAddrs_" type="string" required="yes">
		<cfargument name="_theSubj_" type="string" required="yes">
		<cfargument name="_theBody_" type="string" required="yes">
	
		<cfset Request.anError = "False">
		<cfset Request.errorMsg = "">
		<cftry>
			<cfmail to="#_toAddrs_#" from="#_fromAddrs_#" subject="#_theSubj_#" type="HTML">#_theBody_#</cfmail>
	
			<cfcatch type="Any">
				<cfset Request.anError = "True">
	
				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						#cfcatch.message#<br>
						#cfcatch.detail#
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="cf_wddx_WDDX2CFML" access="public" returntype="any">
		<cfargument name="_input_item_" type="string" required="yes">

		<cfwddx action="WDDX2CFML" input="#_input_item_#" output="Request._CMD_">
	</cffunction>

	<cffunction name="cf_directory" access="public" returntype="boolean">
		<cfargument name="_qName_" type="string" required="yes">
		<cfargument name="_path_" type="string" required="yes">
		<cfargument name="_filter_" type="string" required="yes">
		<cfargument name="_recurse_" type="boolean" default="False">
	
		<cfset Request.directoryError = "False">
		<cfset Request.directoryErrorMsg = "">
		<cfset Request.directoryFullErrorMsg = "">
		<cftry>
			<cfif (_recurse_)>
				<cfdirectory action="LIST" directory="#_path_#" name="#_qName_#" filter="#_filter_#" recurse="Yes">
			<cfelse>
				<cfdirectory action="LIST" directory="#_path_#" name="#_qName_#" filter="#_filter_#">
			</cfif>

			<cfcatch type="Any">
				<cfset Request.directoryError = "True">

				<cfsavecontent variable="Request.directoryErrorMsg">
					<cfoutput>
						#cfcatch.message#<br>
						#cfcatch.detail#
					</cfoutput>
				</cfsavecontent>
				<cfsavecontent variable="Request.directoryFullErrorMsg">
					<cfdump var="#cfcatch#" label="cfcatch" expand="Yes">
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
		<cfreturn Request.directoryError>
	</cffunction>
	
</cfcomponent>
