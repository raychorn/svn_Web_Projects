function getWaferAnalysisPrototypeURL() {
	var _waferAnalysisServer = ((window.location.hostname.toLowerCase().indexOf('.ez-ajax.com') == -1) ? 'laptop.halsmalltalker.com' : 'rabid.contentopia.net');
	var _urlWaferAnalysis = 'http://' + _waferAnalysisServer + '/blog/samples/semiconductors/wafer-analysis/index.cfm';
	var cf_CodeDemoWaferAnalysis = "javascript:window.open('" + _urlWaferAnalysis + "','samples1','width=' + ezClientWidth() + ',height=' + ezClientHeight() + ',resizeable=yes,scrollbars=1')";
	return cf_CodeDemoWaferAnalysis;
}

stm_bm(["menu5854",700,"/app/js/resources/","blank.gif",0,"","",0,0,250,0,1000,1,0,0,"","",0,0,1,2,"default","hand","/app/js/resources/"],this);
stm_bp("p0",[0,4,0,0,0,8,0,0,100,"",-2,"",-2,50,0,0,"#999999","transparent","icons.gif",3,1,1,"#CCCCCC"]);
stm_ai("p0i0",[1," Home","","",-1,-1,0,window.location.protocol + '//' + window.location.hostname,"_self","","","","",0,0,0,"","",0,0,0,0,2,"#FFFFF7",1,"#DCEDFF",1,"","",3,3,0,0,"#CCCCCC","#000000","#000000","#000000","8pt Verdana","8pt Verdana",0,0],75,80);
stm_aix("p0i1","p0i0",[0,"Information","","",-1,-1,0,""],75,80);
stm_bpx("p1","p0",[1,4,0,0,0,3,25,0,100,"",-2,"",-2,50,2,3,"#999999","#FFFFFF","060508line.gif"]);
stm_aix("p1i0","p0i0",[0,"What\'s New","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_whatsNew_menu_symbol);whatsNewText();","_self","","","060508icon1.gif","060508icon1.gif",25,20,0,"","",0,0,0,0,1,"#FFFFF7",1,"#E5EAEF",0,"","",3,3,0,0,"#FFFFF7"],126,0);
stm_aix("p1i3","p1i0",[0,"JSON Support","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_JSONSupport_menu_symbol);jsonSupportText();"],126,0);
stm_aix("p1i1","p1i0",[0,"Product Info","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_whatsIs_menu_symbol);whatsIsText();"],126,0);
stm_aix("p1i2","p1i0",[0,"Installation","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_Installation_menu_symbol);installationText();"],126,0);
stm_ep();
stm_aix("p0i2","p0i1",[0," Samples","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_DocsAndGuides_menu_symbol);sampleAppsText();"],75,80);
stm_bpx("p2","p1",[1,4,0,0,0,3,25,0,100,"",-2,"",-2,50,2,3,"#999999","transparent"]);
stm_aix("p2i2","p1i1",[0,"Sample Apps (using the Dojo Toolkit, etc.)","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_SampleApps_menu_symbol);sampleAppsText();","_self","","","060508icon2.gif","060508icon2.gif"],126,0);
stm_aix("p2i3","p1i1",[0,"Demos, Tutorials & Product Info              ","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_DemosTutorials_menu_symbol);downloadsText();","_self","","","060508icon2.gif","060508icon2.gif"],126,0);
stm_aix("p2i0","p1i0",[0,"Semiconductor Wafer Analysis Prototype  ","","",-1,-1,0,getWaferAnalysisPrototypeURL(),"_self","","","060508icon2.gif","060508icon2.gif"],126,0);
stm_aix("p2i1","p1i1",[0,"Yahoo Search V2 API Sample using JSON","","",-1,-1,0,"javascript:yahooSearchV2Text();","_self","","","060508icon2.gif","060508icon2.gif"],126,0);
stm_aix("p2i4","p1i1",[0,"Sample Web 2.0 API using JSON            ","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_SampleWeb20API_menu_symbol);sampleWeb20APIText();","_self","","","060508icon2.gif","060508icon2.gif"],126,0);
stm_ep();
stm_aix("p0i3","p0i1",[0,"  Features","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_Features_menu_symbol);featuresText();"],75,80);
stm_aix("p0i4","p0i1",[0,"  Downloads"],75,80);
stm_bpx("p3","p2",[]);
stm_aix("p3i0","p1i0",[0,"Docs & Guides","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_DocsAndGuides_menu_symbol);downloadsDocsText();","_self","","","060508icon4.gif","060508icon4.gif"],126,0);
stm_aix("p3i1","p3i0",[0,"  Downloads","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_Downloads_menu_symbol);downloadsText();"],126,0);
stm_ep();
stm_aix("p0i5","p0i1",[0,"Runtime\r\nLicenses","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_RuntimeLicenses_menu_symbol);runtimeLicensesText();"],0,80);
stm_aix("p0i6","p0i1",[0,"Support"],75,80);
stm_bpx("p4","p2",[]);
stm_aix("p4i0","p1i0",[0,"Support Forum","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_SupportForum_menu_symbol);supportForumText();","_self","","","060508icon5.gif","060508icon5.gif"],126,0);
stm_aix("p4i1","p4i0",[0,"Contact Us","","",-1,-1,0,"javascript:handleOnClickSsmItemsByName(const_ContactUs_menu_symbol);contactUsText();"],126,0);
stm_ep();
stm_em();
