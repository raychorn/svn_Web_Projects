<cfcomponent displayname="ezAbstractCode" hint="(c). Copyright 1990-2006 Hierarchical Applications Limited, All Rights Reserved. The functions and data contained herein may only be used within the context of the ezAJAX&##8482 Framework Product, any other use is strictly forbidden." output="No">

	<cffunction name="cf_throwError" access="private">
		<cfargument name="_errorcode_" type="numeric" required="yes">
		<cfargument name="_message_" type="string" required="yes">
		<cfargument name="_detail_" type="string" required="yes">
		<cfthrow errorcode="#_errorcode_#" message="#_message_#" detail="#_detail_#">
	</cffunction>

</cfcomponent>
