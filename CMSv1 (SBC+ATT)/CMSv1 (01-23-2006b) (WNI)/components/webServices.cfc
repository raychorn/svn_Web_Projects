<cfcomponent displayname="webServices" output="no">

	<cffunction name="getuserinfo2" access="remote" returntype="query">
		<cfargument name="_userid" required="yes" type="string">

		<cfset q = QueryNew('sbcuid, outFirstName, outLastName, outPhoneNumber, outStreetAddr1, outStreetAddr2, outState, outEmail, outTitle, outSuperSBCUID, outSuperFirstName, outSuperLastName')>

		<cfmodule
			name="getuserinfo2"
			sbcuid="#_userid#"
			outFirstName="_aFName"
			outLastName="_aLName"
			outPhoneNumber="_user_phone"
			outStreetAddr1="_aStreetAddr1"
			outStreetAddr2="_aStreetAddr2"
			outState="_aState"
			outEmail="_aEmail"
			outTitle="_aTitle"
			outSuperSBCUID="_aSuperSBCUID"
			outSuperFirstName="_aSuperFirstName"
			outSuperLastName="_aSuperLastName"
		>
		
		<cfscript>
			if (IsQuery(q)) {
				QueryAddRow(q, 1);
				QuerySetCell(q, 'sbcuid', _userid, q.recordCount);

				if (IsDefined("_aFName")) {
					QuerySetCell(q, 'outFirstName', _aFName, q.recordCount);
				}

				if (IsDefined("_aLName")) {
					QuerySetCell(q, 'outLastName', _aLName, q.recordCount);
				}

				if (IsDefined("_user_phone")) {
					QuerySetCell(q, 'outPhoneNumber', _user_phone, q.recordCount);
				}

				if (IsDefined("_aStreetAddr1")) {
					QuerySetCell(q, 'outStreetAddr1', _aStreetAddr1, q.recordCount);
				}

				if (IsDefined("_aStreetAddr2")) {
					QuerySetCell(q, 'outStreetAddr2', _aStreetAddr2, q.recordCount);
				}

				if (IsDefined("_aState")) {
					QuerySetCell(q, 'outState', _aState, q.recordCount);
				}

				if (IsDefined("_aEmail")) {
					QuerySetCell(q, 'outEmail', _aEmail, q.recordCount);
				}

				if (IsDefined("_aTitle")) {
					QuerySetCell(q, 'outTitle', _aTitle, q.recordCount);
				}

				if (IsDefined("_aSuperSBCUID")) {
					QuerySetCell(q, 'outSuperSBCUID', _aSuperSBCUID, q.recordCount);
				}

				if (IsDefined("outSuperFirstName")) {
					QuerySetCell(q, 'outSuperSBCUID', _aSuperFirstName, q.recordCount);
				}

				if (IsDefined("_aSuperLastName")) {
					QuerySetCell(q, 'outSuperLastName', _aSuperLastName, q.recordCount);
				}
			}
		</cfscript>

		<cfreturn q>
	</cffunction>

</cfcomponent>
