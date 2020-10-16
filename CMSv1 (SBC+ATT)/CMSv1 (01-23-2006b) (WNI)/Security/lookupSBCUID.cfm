<cfif (CGI.REMOTE_HOST eq _debugIP)>
	<cfsetting showdebugoutput="No">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>SBCUID Search Window</title>
</head>

<body>

<cfoutput>
	<cfset _aFName = "Tim">
	<cfset _aLName = "Fleming">
	<cfmodule
		name="getuserinfo2"
		outsbcuid="_user_sbcuid"
		inFirstName="_aFName"
		inLastName="_aLName"
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
	_user_sbcuid = [#_user_sbcuid#]<br>
	_user_phone = [#_user_phone#]<br>
</cfoutput>

</body>
</html>
