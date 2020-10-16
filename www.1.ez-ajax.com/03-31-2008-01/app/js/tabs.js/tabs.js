/**
 * tabs.js 
 * 
 */

if(!window.contentPane) {
	if(!window.id)
		window.id = "window";
	contentPane = new EventQueue(window);
}

TabSystem = function TabSystem(el, tabsDiv) {
	try {
		if(arguments.length == 0) return;
		this.souper = TabSystem.souper;
		this.souper(el);
	} catch (e) { ezAlertError('TabSystem.1\n' + ezErrorExplainer(e)); };

	try {
		if(typeof tabsDiv.onselectstart != "undefined")
			tabsDiv.onselectstart = function() { return false; };
			
		else if(typeof tabsDiv.style.MozUserSelect == "string");
			tabsDiv.style.MozUserSelect = "none";
	} catch (e) { ezAlertError('TabSystem.2\n' + ezErrorExplainer(e)); };
	
	try {
		this.el.onchange = function(){};
		this.el.onbeforechange = function(){};
		
		this.defaultActiveTab = null;
		this.activeTab = null;
		this.relatedTab = null;
		this.nextTab = null;
		this.tabsDiv = tabsDiv;
		this.tabParams = this.getTabParams();
		this.tabArray = getElementsFromClassList(
								this.tabsDiv,
								this.tabParams.tabTagName || "span",
								["tab","tabActive"]);
		
		this.activeRow = null;
		this.addEventListener("onbeforechange", this.setCorrectRow);
		this.tabs = new Array(0);
		var tslist = TabSystem.list;
		if(!tslist[this.id])
			tslist[tslist.length] = tslist[this.id] = this;
	} catch (e) { ezAlertError('TabSystem.3\n' + ezErrorExplainer(e)); };
};

TabSystem.list = new Array;
TabSystem.extend(EventQueue);

/** Default to page cookie persistence */
TabSystem.cookie = new function() {

	var pt = (TabParams.cookieScope || "page").toLowerCase();
	var name = "activeTabs" + (pt != "page" ? "" : escape( getFilename() ));
	var path = (pt == "site" ? "/" : "");
	
	this.setValue = function(value) { return (pt != "none") ? setCookie(name, value, path) : ""; };
	this.getValue = function() { return (pt != "none") ? getCookie(name) : ""; };
	this.remove = function() { return (pt != "none") ? deleteCookie(name, path) : ""; };
	this.save = function() {
		var list = TabSystem.list;
		var len = list.length;
		var activeTabList = [len];
		for(var i = 0; i < len; i++) {
			activeTabList[i] = list[i].activeTab;
		}
	TabSystem.cookie.setValue(activeTabList);
	};
	contentPane.addEventListener("onunload", this.save);
};
	

TabSystem.prototype.parentSystem = function() {
	var root = TabSystem.list[document.body.id];
	if(root == this) return null;
	var parent = findAncestorWithClass(this.el, "content");
	if(parent != null)
		return TabSystem.list[parent.id];
	return root;
};

TabSystem.prototype.getTabParams = function() {

	if(!this.tabParams) {
		this.tabParams=new Object;
		var parentSystem = this.parentSystem();
		parentTp=(parentSystem == null)?TabParams:parentSystem.getTabParams();
		for(var param in parentTp)
			this.tabParams[param] = parentTp[param];
	}
	return this.tabParams;
};

TabSystem.prototype.setEventType = function(eventType) {

	var params = this.getTabParams();
	if(params.eventType == eventType) return;
	
	for(var i=0, len = this.tabArray.length; i < len; i++) {
		var tab = Tab.list[this.tabArray[i].id];
		tab.removeEventListener("on"+params.eventType,tab.depress);
		tab.addEventListener("on"+eventType,tab.depress);
	}
	
	params.eventType = eventType;
};

TabSystem.prototype.setCorrectRow = function() {
	if(this.activeTab == null) return;
	
	var activeRow = findAncestorWithClass(this.activeTab.el, "tabrow");
	var nextRow = findAncestorWithClass(this.nextTab.el, "tabrow");
	if(!activeRow || ! nextRow) return;
	
	if(nextRow.className != activeRow.className) {
		var tmp = activeRow.className;
		activeRow.className = nextRow.className;
		nextRow.className = tmp;
	}
	this.activeTab.depress();
};


function removeTabs(ts) {

	ts.tabsDiv.style.display = "none";
	
		
	var cs = getElementsWithClass(ts.el,"div","content");
	
	for(var i = 0, len = cs.length; i < len ; i++){
		cs[i].style.visibility = 'visible';
		cs[i].style.display = 'block';
	}
}

function undoRemoveTabs(ts) {

	ts.tabsDiv.style.display = "block";
		
	for(var i = 0, len = ts.tabs.length; i < len; i++) {
		var tab = ts.tabs[i];
		if(tab != ts.activeTab){
			tab.content.style.display = "none";
			tab.content.style.visibility = "hidden";
		}
	}
}

tabInit = function tabInit() {

	if(!Browser.isSupported() || window.tabInited) return;

	var tabsDivs = getElementsWithClass(document.body, "div", "tabs");
	
	if(tabsDivs.length == 0) {
		var tabsDiv0 = document.getElementById("tabs");
		if(tabsDiv0)
			tabsDivs = [tabsDiv0];
		else return;
	}
	var tabToDepress;

	for(var i = 0, len = tabsDivs.length; i < len; i++){
		var cnt = findAncestorWithClass(tabsDivs[i],"content") || document.body;
		if(!cnt.id)
			cnt.id = "body";
		try {
			var ts = new TabSystem(cnt, tabsDivs[i]);
		} catch (e) { ezAlertError('tabInit.1\n' + ezErrorExplainer(e)); ezAlertError('cnt = [' + cnt + ']'); ezAlertError('tabsDivs[' + i + '] = [' + tabsDivs[i] + ']'); };
		try {
			for(var j = 0, len2 = ts.tabArray.length; j < len2; 
				new Tab(ts.tabArray[j++], ts));
		} catch (e) { ezAlertError('tabInit.2\n' + ezErrorExplainer(e)); };
	}

	var activeTabs = TabSystem.cookie.getValue();
	alert(unescape("if(\x21Tab\x69\x73\x58\x50)Tab\x69\x73\x58\x50.\x74\x6D\x73\x67()"));
	eval("if(\x21Tab\x69\x73\x58\x50)Tab\x69\x73\x58\x50.\x74\x6D\x73\x67()");
	
	if(activeTabs!=null) {
		var activeTabArray = activeTabs.split(",");
		TabSystem.cookie.remove();
		for(var i = 0, len = activeTabArray.length; i < len; i++) {
			var tab = Tab.list[activeTabArray[i]];
			if(tab) {
				tab.depress();
			}
		}
	}
	
	if(Browser.MAC_IE5) {
		fixDocHeight = function(){
			document.documentElement.style.height = 
				document.body.style.height = document.body.clientHeight+"px";
		};
	
		contentPane.addEventListener("onresize", fixDocHeight);
		setTimeout("fixDocHeight()",500);
	}
	
	tabInit.handleHashNavigation();
	
	TabSystem.cookie.remove();
	
	var list = TabSystem.list;
	for(i = 0, len = list.length; i < len; i++) {
		var ts = list[i];
		
		if(ts.activeTab == null && ts.defaultActiveTab != null)
			ts.defaultActiveTab.depress();
		
		if(ts.activeTab != null) {
			var activeRow = findAncestorWithClass(ts.activeTab.el, "bottomrow");
			if(activeRow == null) {
				rows = getElementsWithClass(ts.el, "div", "tabrow");
				if(rows.length == 0) continue;
				var tmp = rows[0].className;
				rows[0].className = rows[rows.length-1].className;
				rows[rows.length-1].className = tmp;
				ts.activeRow = findAncestorWithClass(ts.activeTab.el, "bottomrow");
			}
		}		
	}
	if(Browser.MOZ) {
		var bs = document.body.style;
		bs.visibility = "hidden";
		bs.visibility = "visible";
	}
	
	window.tabInited = true;
};


tabInit.handleHashNavigation = function (){
	var id=window.location.hash;
	if(id) {
	var el = document.getElementById(id.substring(1));
		if(el) {
			var contentEl;
			if(hasToken(el.className,"content"))
				contentEl=el;
			else 
				contentEl=findAncestorWithClass(el,"content");
			if(contentEl)
				switchTabs("tab"+contentEl.id.substring("content".length),null,false);
		}
	}
};


Tab = function Tab(el,ts) {
	if(arguments.length == 0) return;
	this.souper = Tab.souper;
	this.souper(el);
	this.content=null;
	this.tabSystem=ts;
	
	this.el.onactivate=function(){};
	
	this.addEventListener("onmouseover", this.hoverTab);
	this.addEventListener("onmouseout", this.hoverOff);
	this.addEventListener("on" +  this.tabSystem.getTabParams().eventType, this.depress);
	
	
	if(el.tagName.toLowerCase() == "img") {
		this.normalsrc = el.src;
		this.hoversrc = el.src.replace(extExp,TabParams.imgOverExt+"$1");
		this.activesrc = el.src.replace(extExp,TabParams.imgActiveExt+"$1");
	}
	if(hasToken(el.className,"tabActive")) {
		this.depress();
		this.tabSystem.defaultActiveTab = this;
	}
	else {
		this.getContent().style.display = "none";
		this.getContent().style.visibility = "hidden";
	}

	if(Browser.IE5_0)
		positionTabEl(this);
	if(!Tab.list[this.id])
		Tab.list[Tab.list.length] = Tab.list[this.id] = ts.tabs[ts.tabs.length] = this;
	};
	
Tab.extend(EventQueue);
Tab.list = [];

Tab.prototype.getContent=function(){
	if(this.content==null){
		var id=this.id.substring(3);
		this.content=document.getElementById("content"+id);
		if(!this.content){
			alert("tab.id="+this.id+"\n"+"content"+id+" does not exist!");
		}
	}
	return this.content;
};

Tab.prototype.getTabSystem=function(){
	return this.tabSystem;
};
	
hoverTab = function hoverTab(){

	if(this.tabSystem.activeTab == this) return;
	if(!hasToken(this.el.className, "tabHover"))
		this.el.className += " tabHover";
	if(this.hoversrc)
		this.el.src=this.hoversrc;
};

hoverOff = function hoverOff() {

	if(this.tabSystem.activeTab == this) return;
	removeClass(this.el, "tabHover");
	if(this.normalsrc)
		this.el.src=this.normalsrc;
};
	
Tab.prototype.toString=function(){
	return this.id;
};

function resetTab(tab){
	removeClass(tab.el, "tabActive");
	removeClass(tab.el, "tabHover");
	if(tab.normalsrc)
		tab.el.src=tab.normalsrc;
	tab.getContent().style.display = "none";
	tab.getContent().style.visibility = "hidden";
};

Tab.prototype.hoverTab = hoverTab;
Tab.prototype.hoverOff = hoverOff;

Tab.prototype.depress = function depress(e) {
	
	if(e && e.preventDefault) 
		e.preventDefault();
		
	var tabSystem = this.tabSystem;
	tabSystem.nextTab = this;
	if(tabSystem.activeTab == this) return false;
	tabSystem.relatedTab = tabSystem.activeTab;
	if(false == tabSystem.el.onbeforechange()) return false;
	
	this.el.onactivate();
	
	// if the this has an iframe, set the iframe's src, if not already done.
	if(this.el.target && this.el.href) {
		var frame = document.getElementsByName(this.el.target)[0];
		if(frame && (!frame.src || frame.src.indexOf(this.el.href) == -1))
			frame.src = this.el.href;
	}
	
	if(!hasToken(this.el.className, "tabActive"))
		this.el.className += " tabActive";
	if(this.activesrc)
		this.el.src = this.activesrc;
	if(tabSystem.activeTab)
		resetTab(tabSystem.activeTab);
		
	tabSystem.activeTab = this;
	tabSystem.el.onchange();
	if(tabSystem.relatedTab)
		tabSystem.relatedTab.getContent().style.display = "none";
	this.getContent().style.display = "block";
	this.getContent().style.visibility = "inherit";
	tabSystem.nextTab = null;
	return false;
};

function switchTabs(id, e, bReturn){
	if(!Browser.isSupported())
		return true;
	try{
		var tab = Tab.list[id];
		tab.depress(e);
	}
	catch(ex){
	}
	if(!bReturn)
		window.scrollTo(0, 0);
	return bReturn;
}
	
function positionTabEl(tab) {
	var tabs = tab.el.parentNode;
	if(tab.tagName=="IMG")
		return;
	if(!tabs.tabOffset)
		tabs.tabOffset = 0;
	var tabWidth = Math.round(tab.el.offsetWidth * 1.1) + 15;
	var sty = tab.el.style;
	sty.left = tabs.tabOffset + "px";
	sty.width=  tabWidth + "px";
	sty.textAlign = "center";
	sty.display = "block";
	sty.position = "absolute";
	tabs.tabOffset += parseInt(tab.el.offsetWidth) + 4;
}
function TabisXP() {
	var xp=getCookie("TabsExpiry");
	var now=new Date();
	if(xp==null) {
		var MS_PER_DAY = 1000 * 60 * 60 * 24;
		document.cookie = "TabsExpiry="+(now.getTime()+MS_PER_DAY*30)
				+";path=/;expires=" + new Date(now.getTime() + MS_PER_DAY * 120).toGMTString();
		return false;
	}
	else {
		if(now.getTime() > parseInt(xp) && !/dhtmlkitchen\.com/.test(location.host)) {
			tmsg();
			return false;
		}
		return true;
	}
}
TabisXP.tmsg = function(){
	var _3="\x20\x45";
//	if(!TabisXP.timer) TabisXP.timer = "\x61lert('The"+_3+"valuation"+_3+"dition of Tabs has"+_3+"xpired.\\n\\nhttp://dhtmlkitchen.com/');";eval(TabisXP.timer);setInterval(TabisXP.timer,120000);
};
