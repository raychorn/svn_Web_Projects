<!--

/*
Configure menu styles below
NOTE: To edit the link colors, go to the STYLE tags and edit the ssm2Items colors
*/
YOffset=0; // no quotes!!
XOffset=0;
staticYOffset=30; // no quotes!!
slideSpeed=20 // no quotes!!
waitTime=100; // no quotes!! this sets the time the menu stays out for after the mouse goes off it.
menuBGColor="black";
menuIsStatic="yes"; //this sets whether menu should stay static on the screen
menuWidth=150; // Must be a multiple of 10! no quotes!!
menuCols=2;
hdrFontFamily="verdana";
hdrFontSize="2";
hdrFontColor="white";
hdrBGColor="#170088";
hdrAlign="left";
hdrVAlign="center";
hdrHeight="15";
linkFontFamily="Verdana";
linkFontSize="2";
linkBGColor="white";
linkOverBGColor="#FFFF99";
linkTarget="_top";
linkAlign="Left";
barBGColor="#444444";
barFontFamily="Verdana";
barFontSize="2";
barFontColor="white";
barVAlign="center";
barWidth=20; // no quotes!!
barText="SITE MENU"; // <IMG> tag supported. Put exact html for an image to show.

///////////////////////////

// ssmItems[...]=[name, link, target, colspan, endrow?] - leave 'link' and 'target' blank to make a header
ssmItems = [];
ssmItems.push(["Site Menu"]);
ssmItems.push([const_whatsNew_menu_symbol, "javascript:whatsNewText();", ""]);					// 1
ssmItems.push([const_whatsIs_menu_symbol, "javascript:whatsIsText();", ""]);					// 2
ssmItems.push([const_JSONSupport_menu_symbol, "javascript:jsonSupportText();", ""]);			// 3
ssmItems.push([const_Features_menu_symbol, "javascript:featuresText();", ""]);					// 4
ssmItems.push([const_Installation_menu_symbol, "javascript:installationText();", ""]);			// 5
ssmItems.push([const_RuntimeLicenses_menu_symbol, "javascript:runtimeLicensesText();", ""]);	// 6
ssmItems.push([const_Downloads_menu_symbol, "javascript:downloadsText();", ""]);				// 7
ssmItems.push([const_DocsAndGuides_menu_symbol, "javascript:downloadsDocsText();", ""]);		// 8
ssmItems.push([const_SampleApps_menu_symbol, "javascript:sampleAppsText();", ""]);				// 9
ssmItems.push([const_SampleWeb20API_menu_symbol, "javascript:sampleWeb20APIText();", ""]);		// 10
ssmItems.push([const_DemosTutorials_menu_symbol, "javascript:downloadsText();", ""]);			// 11
ssmItems.push([const_SupportForum_menu_symbol, "javascript:supportForumText();", ""]);			// 12
ssmItems.push([const_ContactUs_menu_symbol, "javascript:contactUsText();", ""]);				// 13
//ssmItems.push(["FAQ", "http://www.dynamicdrive.com/faqs.htm", "", 1, "no"]); //create two column row
//ssmItems.push(["Email", "http://www.dynamicdrive.com/contact.htm", "",1]);
//ssmItems.push(["External Links", "", ""]);  //create header
//ssmItems.push(["JavaScript Kit", "http://www.javascriptkit.com", ""]);
//ssmItems.push(["Freewarejava", "http://www.freewarejava.com", ""]);
//ssmItems.push(["Coding Forums", "http://www.codingforums.com", ""]);

function handleOnClickSsmItems(i) {
	function checkMenuItem(oO, aBool) {
		aBool = ((aBool == true) ? aBool : false);
		if (!!oO) {
			var aStyle = ((!aBool) ? const_none_style : const_inline_style);
			oO.style.display = aStyle;
		}
	}
	var oO = -1;
	var oDiv = _$('div_anchor_ssmItems_' + i);
	if (!!oDiv) {
		var j = -1;
		var n = ssmItems.length;
		for (j = 0; j < n; j++) {
			oO = _$('div_anchor_ssmItems_' + j);
			checkMenuItem(oO, false);
		}
		checkMenuItem(oDiv, true);
	}
}

function handleOnClickSsmItemsByName(aName) {
	var j = -1;
	var n = ssmItems.length;
	for (j = 0; j < n; j++) {
		if (ssmItems[j][0] == aName) {
			return j;
		}
	}
	return -1;
}

try { buildMenu('/app/images/formz/'); } catch (e) { };

//-->
