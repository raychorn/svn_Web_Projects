<cfcomponent displayname="ezLicenserCode" hint="(c). Copyright 1990-2006 Hierarchical Applications Limited, All Rights Reserved. The functions and data contained herein may only be used within the context of the ezAJAX&##8482 Framework Product, any other use is strictly forbidden." output="No" extends="ezCompilerCode">

	<cfinclude template="../misc2.cfm">

	<cfscript>
		function writeRuntimeLicenseForEndDate(aDate, aProductName, aServerName, isCommunityEdition) {
			var aStruct = StructNew();
			var _wddxData = '';
			var _wddxDataStream = '';
			if (NOT IsValid( 'date', aDate)) {
				aDate = DateAdd('d', 30, Now());
			}
			if (NOT IsValid( 'string', aProductName)) {
				aProductName = 'Unknown Product';
			}
			if (NOT IsValid( 'string', aServerName)) {
				aServerName = CGI.SERVER_NAME;
			}
			if (NOT IsValid( 'boolean', isCommunityEdition)) {
				isCommunityEdition = true;
			}
			aStruct.runtimeLicenseExpirationDate = aDate;
			aStruct.RuntimeLicenseStatus = '';
			aStruct.OS = Server.OS.Name & '|' & Server.OS.Version & '|' & Server.OS.BuildNumber & '|' & Server.OS.arch;
			try {
				aStruct.computerID = Trim(getComputerID());
			} catch (Any e) {
				aStruct.computerID = Trim(Server.ColdFusion.SerialNumber);
			}
			aStruct.ProductName = aProductName;
			aStruct.ServerName = aServerName;
			aStruct.productVersion = this.productVersion;
			aStruct.ColdfusionID = server.coldfusion.productname & ' ' & ListFirst(server.coldfusion.productversion) & '.' & ListGetAt(server.coldfusion.productversion, 2);
			aStruct.isCommunityEdition = isCommunityEdition;
			aStruct.copyrightNotice = '&copy; 1990-#Year(Now())# Hierarchical Applications Limited, All Rights Reserved.  Use of or duplication of this software or any software derived from its use is illegal unless specific written permission has been granted by Hierarchical Applications Limited or a duly appointed Officer of this corporation.';
			_wddxData = ezCFML2WDDX(aStruct);
			_wddxDataStream = asBlowfishEncryptedHex(_wddxData);

			ezCfFileWrite(ExpandPath('runtimeLicense.dat'), _wddxDataStream);
		}
	</cfscript>
</cfcomponent>
