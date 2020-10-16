<cfcomponent displayname="ezAbstractCode" hint="(c). Copyright 1990-2006 Hierarchical Applications Limited, All Rights Reserved." output="No">
	<cfscript>
		aRuntimeLicenseStruct = -1;
	</cfscript>

	<cffunction name="_aRuntimeLicenseStruct" access="public" returntype="struct">
		<cfargument name="_arg1_" type="string" required="yes">
		<cfscript>
			if ( (IsValid('UUID', _arg1_)) AND (NOT IsStruct(aRuntimeLicenseStruct)) ) {
				return StructNew();
			}
			return aRuntimeLicenseStruct;
		</cfscript>
	</cffunction>

	<cffunction name="_aRuntimeLicenseStruct_" access="private" returntype="struct">
		<cfargument name="_arg1_" type="struct" required="yes">
		<cfscript>
			if (IsStruct(_arg1_)) {
				aRuntimeLicenseStruct = _arg1_;
			} else {
				cf_throwError(-1, 'ERROR 1.1: Invalid use of Private function.', 'A Valid Runtime License is required in order to use this product.  You may obtain a Runtime License by contacting sales@ez-ajax.com.');
			}
			return aRuntimeLicenseStruct;
		</cfscript>
	</cffunction>

	<cffunction name="cf_throwError" access="private">
		<cfargument name="_errorcode_" type="numeric" required="yes">
		<cfargument name="_message_" type="string" required="yes">
		<cfargument name="_detail_" type="string" required="yes">
		<cfthrow errorcode="#_errorcode_#" message="#_message_#" detail="#_detail_#">
	</cffunction>

</cfcomponent>
