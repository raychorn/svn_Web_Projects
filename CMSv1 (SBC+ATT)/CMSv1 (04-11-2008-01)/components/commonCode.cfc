<cfcomponent displayname="commonCode" output="no">

	<cfscript>
		function list_iterator(_list, delim, func, item_method) {
			var i = -1;
			var anItem = '';
	
			for (i = 1; i lte ListLen(_list, delim); i = i + 1) {
				if (IsCustomFunction(func)) {
					anItem = GetToken(_list, i, delim);
					if (anItem eq '.') {
						anItem = '';
					}
					func(anItem, item_method, -1);
				}
			}
		}

		function scriptPrefix(scriptName) {
			var urlPrefix = '';

			urlPrefix = ReplaceNoCase(scriptName, GetToken(scriptName, ListLen(scriptName, '/'), '/'), '');
			if (Right(urlPrefix, 1) neq '/') {
				urlPrefix = urlPrefix & '/';
			}
			return urlPrefix;
		}

		function fullyQualifiedURLprefix(prefix) {
			return "http://" & CGI.SERVER_NAME & ":" & CGI.SERVER_PORT & prefix;
		}
		
		function iframe(p_url) {
			writeOutput('<iframe src="#p_url#" width="100%" height="100%" frameborder="0"></iframe>');
		}
		
		function blendURLParms(parmsA, parmsB) {
			var _parms = parmsB;
			if ( (FindNoCase("?", parmsA) gt 0) AND (FindNoCase("?", parmsB) gt 0) ) {
				_parms = ReplaceNoCase(parmsB, "?", "&");
			}
			return parmsA & _parms;
		}
	</cfscript>

	<cffunction name="tabsHeader" access="public" returntype="string">
		<cfargument name="_windowLoadedMethodName" required="yes" type="string">
		<cfargument name="_srcPath" required="yes" type="string">
		<cfargument name="_tab_height" required="yes" type="string">
		<cfargument name="_content_top" required="yes" type="string">
		<cfargument name="_content_margin_left" required="yes" type="string">
		<cfargument name="_content_width" required="yes" type="string">
		<cfargument name="_content_padder_height" required="yes" type="string">
		<cfargument name="_visible_tabs_begin" required="yes" type="string">
		<cfargument name="_visible_tabs_end" required="yes" type="string">

		<cfset _tab_height_raw = ReplaceNoCase(_tab_height, "px", "")>
		<cfset _content_top_raw = ReplaceNoCase(_content_top, "px", "")>

		<cfset content_top_tag = "top: #_content_top#">
		<cfif (Len(_tab_height) gt 0)>
			<cfset content_top_tag = "top: #(_content_top_raw + (_tab_height_raw - 15))#">
		</cfif>

		<cfset tab_height_tag = "">
		<cfif (Len(_tab_height) gt 0)>
			<cfset tab_height_tag = "height: #_tab_height_raw#px; line-height: 10px;">
		</cfif>

		<cfsavecontent variable="_html">
			<cfoutput>
				<style type="text/css">
					    body{
					   	    margin: 0;
					   	    /* Opera uses padding for body */
					   	    padding: 0;
					   	    background-color:##e3e6e9;
					   	    height: 100%;
					    }
				
				
						##TabSystem1 {
							background: transparent;
							border: none;
							position: absolute;
							top: 0;
							left: 0;
							margin: 0 0 0 50px;
							padding: 0;
						}
				
						/*--------------------LEGEND -----------------------+
						|                                                   |
						| .content   -- the content div, also the className |
						|               for tabSystem divs                  |
						| .tabs      -- the div that holds all tabs         |
						| .tab       -- an inactive tab                     |
						| .tabActive -- an active tab                       |
						| .tabHover  -- an inactive tab onMouseOver         |
						|___________________________________________________*/
						
				     .content {
				         position: relative;
				         
				         /* use margin-left instead of margin.
				          * mac IE messes up the child nodes with 
				          * position relative. Position gets set to absolute via javascript 
				          * in Mac IE, but if javascript is off, the page will 
				          * look like the demo in the link below.
				          *
				          * For details on this bug, 
				          * please see: http://climbtothestars.org/coding/ie5macbug/
				          *
				          */
				          
				         margin-left: #_content_margin_left#;
						 #content_top_tag#;
				         font-family: Trebuchet MS, Arial, sans-serif;
				         padding: 8px 12px 12px 12px;
				         border: 1px solid ##666;
				         width: #_content_width#;
				         border-top: 1px solid ##999;
				         border-left: 1px solid ##666;
				         z-index: 500;
				         background-color: ##f3f6f9;
				     }
				          
				     
				     .content .padder{
						height: #Evaluate(ReplaceNoCase(_content_padder_height, "px", ""))#px;
				     }
				     
				      div.tabs {
				         font-size: 14px;
				         line-height: 15px;
				
				         position: absolute;
				         top: #(Evaluate(ReplaceNoCase(_content_top, "px", "")) - 15)#px;
				         left: #(Evaluate(ReplaceNoCase(_content_margin_left, "px", "")) + 12)#px;
				         white-space: nowrap;
				         font-family: Verdana, Arial, sans-serif;
				         cursor: default !important;
				         font-weight: 700 !important;
				         white-space:nowrap;
				         z-index: 10000;
				        /* -Moz-User-Select: none;*/
				      }
				     .tab {
				         border: 1px solid ##347;
				         padding: 2px 9px 1px 9px;
				         background-color: ##bcd;
				         color: ##303036;
						 #tab_height_tag#
				         z-index: 100;
				         border-bottom-width: 0;
				         text-decoration: none;
				      }
				      .tabHover {
				         border: 1px solid ##347;
				         background-color: ##46596f;
				         padding: 2px 9px 1px 9px;
				         color:##fff;
				         z-index: 1200;
				         border-bottom-width: 0;
				      }
				      .tabActive { 
				         padding: 3px 9px 3px 9px;
				         color: ##060610 ;
				         background-color: ##f3f6f9;
				         z-index: 10000;
				      }
				      
				      ##viewsrc{
				        width: 130px;
				        border: 1px solid ##003;
				        margin: 8px;
				        background-color: ##f3f6fc;
				        position: absolute;
				        top: 12px;
				        left: 12px;
				      }
				     
					##controls {
						position: absolute;
						top: 380px;
						left: 120px;
						width: 550px;
						height: 250px;
						padding: 10px;
						background: ##f3f6f9;
						font-family: arial, sans-serif;
						line-height: 20px;
						font-size: 16px;
					}
					
					##controls a {
						color: ##113;
						font-family: "Courier New", courier, monospace;
					}
					##controls a:hover {
						background-color: ##fff;
						color: ##c00;
					}
				</style>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
				/** TabParams
				 * eventType		- What action activates a tab? "click" | "mouseover" 
				 *                       | "mousedown" | "mouseup" .
				 *
				 * tabTagName	    - "span" | "img" | "*" -- span or img speeds up initialization.
				 *                    use "*" if your have both span and img tabs.
				 * imgOverExt	    - A file name suffix before the extension .
				 *                    if src="calendar.gif" is the normal file and you want it to 
				 *                    be "calendaro.gif" on mouseover, then imgOverExt is "o".
				 *
				 * imgActiveExt	    - A file name suffix before the extension .
				 *                    if src="calendaro.gif" is the normal file and you want it to 
				 *                    be "calendaro.gif" on mouseover, then imgOverExt is "o".
				 *
				 * cookieScope		- "page" | "site" | "none" 
				 *                     -- "page" 
				 *                         page scope (default) saves multiple tab states for different 
				 *                         tabsystems on your site. 
				 *                         Page scope is useful when you want to save the state of
				 *                         different tabsystems on your site. Page scope uses multiple 
				 *                         cookies.
				 *
				 *                    -- "site"
				 *                        site scope saves the state for tabSystems that
				 *                        may be used on multiple pages (such as with included files.
				 *                        This is most useful for using the same tabSystem(s) on 
				 *                        different pages, as with a server side include file. Site scope 
				 *                        uses only 1 cookie.
				 *
				 *                    -- "none"
				 *                        No cookie will be used.
				 */
				 	TabParams = {
						eventType       : "click",
						tabTagName      : "a",
						imgOverExt      : "",
						imgActiveExt    : "",
						cookieScope		: "page"
					};
	
					_vis_tabs_begin = eval(#_visible_tabs_begin#);
					_vis_tabs_end = eval(#_visible_tabs_end#);
	
					_num_vis_tabs_max = (_vis_tabs_end - _vis_tabs_begin) + 1;
					
					_const__tab = "tab";
					_const_cell_tab = "cell_" + _const__tab;
					
					_const_releaseLogSubReport = "_releaseLogSubReport";
					_const_comments_symbol = "_comments_";
					
					_const_releaseLogSubReportRow = "td_releaseLogReportDetail.";
					
					_const_content = "content_areaAboveReports";
					_const__content = "content";
					
					_const_content_loading = "content_loading";
	
					_const_hiliteDiv_id = "xxxxxYYYYYzzzzz";
					_const_hilite_style = "BORDER-RIGHT:black 1px solid;BORDER-TOP:black 1px solid;BORDER-LEFT:black 1px solid;BORDER-BOTTOM:black 1px solid;background-color: White;";
	
					_const_hiliteDiv_begin = "<span id=" + _const_hiliteDiv_id + " style=\"" + _const_hilite_style + "\">";
					_const_hiliteDiv_end = "</span>";
	
					_const_begin_hilite = _const_hiliteDiv_begin + "<font size=\"-1\" color=\"##FF0000\"><B><U><I>";
					_const_end_hilite = "</I></U></B></font>" + _const_hiliteDiv_end;
	
					_const_tr_tag_begin = "<TR";
					_const_id_param_begin = "id=";
					_const_style_param_begin = "style=";
					
					_allow_RefreshVCRControls = true;
					_allow_AutoTabsAdjustment = false;
	
					_deferred_performSearchFor = "";
					
					stack_FocusOnTabWithAnchorText = [];
					stack_performFunctionsOnTabChanged = [];
	
					register_fontSizeAdjustments_function(handle_fontSizeAdjustments_forTabs);
	
					function setFontAdjustmentStateForTabNum(_num, chgsize) {
						if (cache_performed_fontSizeAdjustments_forTab[_num] == null) {
							var fs = -1;
							if (chgsize != null) {
								fs = myTextSize(chgsize);
							} else {
								fs = myTextSize();
							}
							cache_performed_fontSizeAdjustments_forTab[_num] = fs;
						}
					}
	
					function setFontAdjustmentStateForActiveTab(chgsize) {
						var _num = activeTabNum();
						return setFontAdjustmentStateForTabNum(_num, chgsize);
					}
	
					function tabChanged() {
						var _obj = getGUIObjectInstanceById("cell_" + this.activeTab.id);
						var _num = activeTabNumFrom(this);
					
						clearOnTabChangedRegistrations(false);
						registerFunctionsOnTabChanged(_num);
						
						setFontAdjustmentStateForTabNum(_num);
					
						return( _tabChanged(_num));
					}
	
					function #Replace(_windowLoadedMethodName, Chr(34), "", "all")# {
						tabInit();
	
						var ts = TabSystem.list["TabSystem1"];
						
						if (ts != null) {
							ts.addEventListener("onchange", tabChanged);
		
							refreshTabs(ts);
							
							var obj = getGUIObjectInstanceById(_const_content_loading);
							if (obj != null) {
								obj.style.display = const_none_style;
							}
		
							RefreshVCRControls();
							
							if (_deferred_performSearchFor.length > 0) {
								PerformTabSearch(_deferred_performSearchFor);
								_deferred_performSearchFor = "";
							} else {
								if (stack_FocusOnTabWithAnchorText.length > 0) {
									_allow_RefreshVCRControls = false; 
									FocusOnTabWithAnchorText(stack_FocusOnTabWithAnchorText.pop()); 
									RefreshVCRControls(); 
									_allow_RefreshVCRControls = true;
								}
							}
						}
					}
					
				-->
				</script>
				
				<script language="JavaScript1.2" src="#_srcPath#readable/cookie.js" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_srcPath#utils.js" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_srcPath#tabs.js" type="text/javascript"></script>
				<script language="JavaScript1.2" src="#_srcPath#readable/tabs.js" type="text/javascript"></script>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="div_loadingContent" access="public" returntype="string">
		<cfargument name="_info_" type="string" default="Data" required="yes">

		<cfsavecontent variable="_html">
			<cfoutput>
				<div id="content_loading" class="content" style="display: inline;">
					<table width="100%" height="200px" cellpadding="-1" cellspacing="-1">
						<tr valign="middle">
							<td align="center">
								<h3 align="center"><b><font face="Arial,''Arial Narrow'',''Arial MT Condensed Light'',sans-serif" color="##0000FF">Loading #_info_# from Database...<br><br>Please Wait... Briefly.</font></b></h3>
							</td>
						</tr>
					</table>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn _html>
	</cffunction>

	<cffunction name="const_sbc_domain_symbol" access="public" returntype="string">
		<cfset cont_sbc = ".sbc.">

		<cfreturn cont_sbc>
	</cffunction>

	<cffunction name="isDomainSBC" access="public" returntype="boolean">
		<cfreturn (FindNoCase(const_sbc_domain_symbol(), CGI.HTTP_HOST) gt 0)>
	</cffunction>

	<cffunction name="getuserinfo2" access="public" returntype="array">
		<cfargument name="_userid" required="yes" type="string">

		<cfset an_array = ArrayNew( 1)>
		<cfif (isDomainSBC())>
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
		</cfif>
		<cfset bool = ArrayAppend( an_array, "#_userid#")>

		<cfif (NOT IsDefined("_aFName"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aFName)>
		</cfif>

		<cfif (NOT IsDefined("_aLName"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aLName)>
		</cfif>

		<cfif (NOT IsDefined("_user_phone"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _user_phone)>
		</cfif>

		<cfif (NOT IsDefined("_aStreetAddr1"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aStreetAddr1)>
		</cfif>
		
		<cfif (NOT IsDefined("_aStreetAddr2"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aStreetAddr2)>
		</cfif>
		
		<cfif (NOT IsDefined("_aState"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aState)>
		</cfif>

		<cfif (NOT IsDefined("_aEmail"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aEmail)>
		</cfif>

		<cfif (NOT IsDefined("_aTitle"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aTitle)>
		</cfif>

		<cfif (NOT IsDefined("_aSuperSBCUID"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aSuperSBCUID)>
		</cfif>

		<cfif (NOT IsDefined("_aSuperFirstName"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aSuperFirstName)>
		</cfif>

		<cfif (NOT IsDefined("_aSuperLastName"))>
			<cfset bool = ArrayAppend( an_array, "")>
		<cfelse>
			<cfset bool = ArrayAppend( an_array, _aSuperLastName)>
		</cfif>
		
		<cfreturn an_array>
	</cffunction>

	<cffunction name="default_array" access="public" returntype="array">
		<cfscript>
			an_array = ArrayNew( 1);
			ArraySet(an_array, 1, 11, '(Web Phone Offline)');
			an_array[1] = '';
			an_array[2] = '';
			an_array[3] = '';
		</cfscript>

		<cfreturn an_array>
	</cffunction>

	<cffunction name="safely_getuserinfo2" access="public" returntype="array">
		<cfargument name="_userid" required="yes" type="string">

		<cfscript>
			an_array = default_array();
			if (isDomainSBC()) {
				try {
					an_array = getuserinfo2( _userid);
				} catch(Any e) {
				}
			}
		</cfscript>

		<cfreturn an_array>
	</cffunction>

	<cffunction name="isSBCUIDvalid" access="public" returntype="string">
		<cfargument name="_userid" required="yes" type="string">

		<cfscript>
			an_array = ArrayNew( 1);
			_user_phone = '';
			_user_name = '';
			isValid = '';
			
			an_array = safely_getuserinfo2( _userid);
			_user_phone = an_array[4];
			_user_name = an_array[2] & ' ' & an_array[2];

			isValid = false;
			if (FindNoCase("Not in Phone", _user_name) eq 0) {
				isValid = true;
			}
		</cfscript>

		<cfreturn isValid>
	</cffunction>
	
	<cffunction name="releaseConfirmationForm" access="public" returntype="string">
		<cfargument name="function" required="yes" type="string">
		<cfargument name="_relNum" required="yes" type="string">
		<cfargument name="_rid" required="yes" type="string">
		<cfargument name="_acceptActions" required="yes" type="string">
		<cfargument name="_cancelActions" required="yes" type="string">
		<cfargument name="_cancelButton_symbol" required="yes" type="string">
		<cfargument name="_paternToReplace" required="yes" type="string">
		<cfargument name="_productionArchiveDevelopAction_symbol" required="yes" type="string">
		<cfargument name="_initialDevelopAction_symbol" required="yes" type="string">
		<cfargument name="_purgeThisArchivesAction_symbol" required="yes" type="string">
		<cfargument name="_productionReleaseStageAction_symbol" required="yes" type="string">
		<cfargument name="_revertStagingReleaseAction_symbol" required="yes" type="string">

		<cfset _promptText0 = "Release">
		<cfif (function eq _productionArchiveDevelopAction_symbol) OR (function eq _initialDevelopAction_symbol)>
			<cfset _promptText0 = "Make Draft from">
		<cfelseif (function eq _purgeThisArchivesAction_symbol)>
			<cfset _promptText0 = "Perform Purge on">
		<cfelseif (function eq _productionReleaseStageAction_symbol)>
			<cfset _promptText0 = "Perform Production Release on">
		<cfelseif (function eq _revertStagingReleaseAction_symbol)>
			<cfset _promptText0 = "Revert to Draft from">
		</cfif>
		<cfset _promptText1 = "">
		<cfif (_relNum gt 0)>
			<cfif (function eq _productionArchiveDevelopAction_symbol) OR (function eq _initialDevelopAction_symbol) OR (function eq _purgeThisArchivesAction_symbol) OR (function eq _productionReleaseStageAction_symbol) OR (function eq _revertStagingReleaseAction_symbol)>
				<cfset _promptText1 = " ###_relNum#">
			<cfelse>
				<cfset _promptText1 = " ###_relNum# to Staging">
			</cfif>
		<cfelse>
			<cfset _promptText0 = "#_promptText0# Initial Release">
		</cfif>

		<cfset _yesFunction = "#function#|Yes">
		<cfset _promptText = "#_promptText1#">
		<cfif (function eq _productionArchiveDevelopAction_symbol) OR (function eq _initialDevelopAction_symbol)>
			<cfset _promptText = "#_promptText0# Release#_promptText1#">
		<cfelseif (function eq _purgeThisArchivesAction_symbol)>
			<cfset _promptText = "#_promptText0##_promptText1#">
		<cfelseif (function eq _productionReleaseStageAction_symbol) OR (function eq _revertStagingReleaseAction_symbol)>
			<cfset _promptText = "#_promptText0##_promptText1#">
		</cfif>
		<cfif (function eq _productionArchiveDevelopAction_symbol) OR (function eq _initialDevelopAction_symbol) OR (function eq _productionReleaseStageAction_symbol) OR (function eq _revertStagingReleaseAction_symbol)>
			<cfset _yesPrompt = "#_promptText#.">
		<cfelse>
			<cfset _yesPrompt = "Release #_promptText#.">
		</cfif>

		<cfset _acceptActions = Replace(_acceptActions, _paternToReplace, _yesFunction)>

		<cfset _button_style_symbol = 'style="font-size: 10px; color: black;"'>
		
		<cfset _extra_button_actions = "var obj = getGUIObjectInstanceById('confirmation_yes_button#_relNum#'); var obj2 = getGUIObjectInstanceById('confirmation_cancel_button#_relNum#'); if ( (obj != null) && (obj2 != null) ) { return suppress_button_double_click2(this, obj2, null); }">

		<cfset _html = '
			<table width="60%" align="right" border="1" bordercolor="red">
				<tr>
					<td>
						<table width="100%" bgcolor="##FF8080">
							<tr>
								<td width="20%" valign="middle" align="center">
									<h5><b>Confirmation Dialog</b></h5>
								</td>
								<td width="*" valign="top">
									<p align="justify">
										<small>This is a Confirmation Dialog that requires the user to either "Confirm" the desired action or "Cancel" the action.</small>
									</p>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%">
							<form id="" onSubmit="return checkandsubmit(null);">
								<tr align="right" valign="top">
									<td>
										<input type="button" id="confirmation_yes_button#_relNum#" value="#_yesPrompt#" #_button_style_symbol# title="Click this button to Confirm the operation in-progress." onClick="#_cancelActions#; #_acceptActions#; #_extra_button_actions# return false;">
									</td>
								</tr>
								<tr align="right" valign="top">
									<td>
										<input type="button" id="confirmation_cancel_button#_relNum#" value="#_cancelButton_symbol#" #_button_style_symbol# title="Click this button to Cancel the operation in-progress." onClick="#_cancelActions#; return false;" ondblclick="return false;">
									</td>
								</tr>
							</form>
						</table>
					</td>
				</tr>
			</table>
		'>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="asciiChart" access="public" returntype="string">

		<cfscript>
			var _i = 1;
			var _html = '';
			
			for (_i = 128; _i lte 255; _i = _i + 1) {
				_html = _html & '(#_i# [#Chr(_i)#]) ';
			}
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="isAlphaNumeric" access="public" returntype="boolean">
		<cfargument name="_ch" required="yes" type="string">

		<cfset alpha_letters = "abcdefghijklmnopqrstuvwxyz">
		<cfset numeric_letters = "0123456789">
		<cfset acceptable_letters = alpha_letters & UCASE(alpha_letters) & numeric_letters>

		<cfset _bool = "True">
		<cfif (Find(Left(_ch, 1), acceptable_letters) eq 0)>
			<cfset _bool = "False">
		</cfif>
		
		<cfreturn _bool>
	</cffunction>

	<cffunction name="_correctHref" access="private" returntype="string" output="No">
		<cfargument name="_url" required="yes" type="string">
		<cfargument name="_currentPage_symbol" required="yes" type="string">

		<cfscript>
			_href = '';
			_endTok = '';
			_curPage = '';
			CGI_SCRIPT_NAME = '';
			new_url = _url;
			
			_url = ReplaceNoCase(_url, '"', '', 'all');
			_curPage = getCurrentPageFromURL( _url, _currentPage_symbol);
			
			if (Len(Trim(_curPage)) gt 0) {
				_href = GetToken(_url, 1, "?");
				_endTok = GetFileFromPath(_href);
				if (Len(Trim(_endTok)) gt 0) {
					_href = ReplaceNoCase(_href, _endTok, '');
					CGI_SCRIPT_NAME = ReplaceNoCase(CGI.SCRIPT_NAME, _endTok, '');
				}
				new_url = ListAppend(CGI_SCRIPT_NAME, _endTok, '/');
				new_url = ReplaceNoCase(new_url, '//', '/');
				new_url = '#new_url##_currentPage_symbol##_curPage#';
			}
		</cfscript>

		<cfreturn new_url>
	</cffunction>

	<cffunction name="correctHref" access="private" returntype="string" output="No">
		<cfargument name="_url" required="yes" type="string">
		<cfargument name="_currentPage_symbol" required="yes" type="string">
		<cfargument name="t_struct" type="struct" required="yes">
		<cfargument name="const_target_symbol" required="yes" type="string">
		<cfargument name="const_target_blank_symbol" required="yes" type="string">
		<cfargument name="const_target_top_symbol" required="yes" type="string">

		<cfscript>
			_href = _correctHref(_url, _currentPage_symbol);
			new_url = _url;
			
			_curPage = getCurrentPageFromURL( _href, _currentPage_symbol);
			
			if (Len(Trim(_curPage)) gt 0) {
				new_url = '"#_href#"';

				StructInsert(t_struct, UCASE(const_target_symbol), const_target_top_symbol, true);
			} else {
				StructInsert(t_struct, UCASE(const_target_symbol), const_target_blank_symbol, true);
			}
		</cfscript>

		<cfreturn new_url>
	</cffunction>

	<cffunction name="isCurrentPageOnList" access="private" returntype="boolean">
		<cfargument name="_url" required="yes" type="string">
		<cfargument name="_currentPage_symbol" required="yes" type="string">
		<cfargument name="_list" required="yes" type="string">

		<cfscript>
			_bool = false;

			_url = ReplaceNoCase(_url, '"', '', 'all');
			_curPage = getCurrentPageFromURL( _url, _currentPage_symbol);
			
			if (Len(Trim(_curPage)) gt 0) {
				if (FindNoCase("'", _list) gt 0) {
					_curPage = "'" & _curPage & "'";
				}
				if (FindNoCase(_curPage, _list) gt 0) {
					_bool = true;
				}
			}
		</cfscript>
		
		<cfreturn _bool>
	</cffunction>
	
	<cffunction name="correctImgSource" access="private" returntype="string">
		<cfargument name="_url" required="yes" type="string">
		<cfargument name="_images_folder" required="yes" type="string">

		<cfscript>
			new_url = _url;
			_btp = '';
			_btf = '';
			_bp = '';
			_tp = '';
			_tpe = -1;
			_bn = '';
			_path = _url;
			
			_path = Replace(_path, '"', '', 'all');
			_path = Replace(_path, '/', '\', 'all');

			_btp = GetBaseTemplatePath();
			_btf = GetFileFromPath(_btp);
			_bp = Replace(_btp, _btf, '', 'one');
			_tp = _bp & _path;
			_tpe = FileExists(_tp);

			if (NOT _tpe) {
				_bn = GetFileFromPath(_path);
				_path = _images_folder & _bn;
			}
			new_url = '"' & _path & '"';
		</cfscript>
		
		<cfreturn new_url>
	</cffunction>

	<cffunction name="AnalyzeTag" access="private" returntype="struct" output="Yes">
		<cfargument name="_input" required="yes" type="string">
		<cfargument name="_debugMode" type="boolean" default="False" required="yes">
		<cfargument name="const_tagname_symbol" required="yes" type="string">
		<cfargument name="const_tag_contents_symbol" required="yes" type="string">
		<cfargument name="_html_tag_postamble_symbol" required="yes" type="string">
		<cfargument name="_isHref" type="boolean" default="False" required="yes">

		<cfscript>
			i = -1;						// steps through _input
			ch = -1;					// holds one char at a time
			aQuote = '';				// holds a " while inside a pair of ""
			pName = '';					// parm name
			pValue = '';				// parm value
			t_struct = StructNew();		// holds key value pairs for each parm name/value
			tagContents = '';			// that which is enclosed by the tag being edited...
			aTabClose = '';				// holds a > while inside a pair of ><
			processTagName = false;
			
			isTagName = true;			// tag name is always first

			const_equals_symbol = '=';
			const_quote_symbol = '"';

			const_close_symbol = '>';
			const_open_symbol = '<';

			Cr = Chr(13);
			
			if (_debugMode) WriteOutput('<textarea cols="100" rows="10" readonly wrap="soft" style="font-size: 12px;">_input = (' & _input & ')#Cr#');
			for (i = 1; i lte Len(_input); i = i + 1) {
				ch = Mid(_input, i, 1);
				if (_debugMode) WriteOutput('ch = [#ch#]#Cr#');
				if ( (Len(aTabClose) eq 0) AND (ch eq const_close_symbol) ) {
					aTabClose = ch;
					tagContents = '';
				}
				if ( (Len(aQuote) eq 0) AND (ch eq const_quote_symbol) ) {
					aQuote = ch;
				} else if ( (Len(aQuote) neq 0) AND (ch eq const_quote_symbol) ) {
					aQuote = '';
				}
				if (_debugMode) WriteOutput('(0) [_isHref=#_isHref#] Len(aTabClose) = (' & Len(aTabClose) & ')' & ' Len(aQuote) = (' & Len(aQuote) & ')' & ' Len(Trim(ch)) = (' & Len(Trim(ch)) & ')' & '#Cr#');
				if (Len(aTabClose) eq 0) {
					processTagName = false;
					if (_isHref) {
						if ( (Len(aQuote) eq 0) AND (Len(Trim(ch)) eq 0) ) {
							processTagName = true;
						}
					} else {
						if ( (Len(aQuote) eq 0) AND (Len(Trim(ch)) eq 0) ) {
							processTagName = true;
						}
					}
					if (_debugMode) WriteOutput('(2) processTagName = [#processTagName#]#Cr#');
					if (processTagName) {
						// whitespace - delimits name/value pairs only if there is a name and a value
						// whitespace does not delimit while inside a set of ""
						if (_debugMode) WriteOutput('(1) isTagName = (' & isTagName & ')' & '#Cr#');
						if (isTagName) {
							StructInsert(t_struct, const_tagname_symbol, UCASE(pName), true);
							if (_debugMode) WriteOutput('(2) pName = (' & const_tagname_symbol & ')' & ' pValue = (' & pName & ')' & '#Cr#');
							pName = '';
							pValue = '';
							isTagName = false;
						} else {
							if ( (Len(Trim(pName)) gt 0) AND (Len(Trim(pValue)) gt 0) ) {
								StructInsert(t_struct, UCASE(pName), pValue, true);
								if (_debugMode) WriteOutput('(2) pName = (' & pName & ')' & ' pValue = (' & pValue & ')' & '#Cr#');
								pName = '';
								pValue = '';
							}
						}
					} else {
						if ( (Len(pName) gt 0) AND (Mid(pName, Len(pName), 1) eq const_equals_symbol) ) {
							pValue = pValue & ch;
						} else {
							pName = pName & ch;
						}
					}
				} else {
					tagContents = tagContents & ch;
				}
			}
			if ( (Len(aTabClose) neq 0) AND (Len(tagContents) gt 0) ) {
				tagContents = ReplaceNoCase(tagContents, const_close_symbol, '');
				tagContents = ReplaceNoCase(tagContents, _html_tag_postamble_symbol, '');
				StructInsert(t_struct, UCASE(const_tag_contents_symbol), tagContents, true);
			} else {
				StructInsert(t_struct, UCASE(const_tag_contents_symbol), ' ', true);
			}
			if (_debugMode) WriteOutput('</textarea>');
		</cfscript>
		
		<cfreturn t_struct>
	</cffunction>

	<cffunction name="correctHTMLtags" access="public" returntype="string" output="Yes">
		<cfargument name="_someHTML" required="yes" type="string">
		<cfargument name="_images_folder" required="yes" type="string">
		<cfargument name="_html_tag_preamble_symbol" required="yes" type="string">
		<cfargument name="_html_tag_postamble_symbol" required="yes" type="string">
		<cfargument name="_html_tag_edit_symbol" required="yes" type="string">
		<cfargument name="_theURLPrefix_symbol" required="yes" type="string">
		<cfargument name="_ContentPageList" type="string">
		<cfargument name="_debugMode" type="boolean" default="False">

		<cfscript>
			i = -1;			// used to step through the input buffer
			theHTML = '';	// the output buffer
			_theHTML = '';	// the output buffer
			iBegin = 1;
			iEnd = -1;
			dTag = 0;
			sTag = '';
			sTagName = '';
			sTagContents = '';
			_url = '';
			iSrc = '';
			an_array = '';
			newTag = '';
			sValue = '';
			iHref = '';
			ss = '';
			isCheckingPageList = false;
			okayToRenderHTML = true;
			
			const_begin_tag_symbol = '<';
			const_end_tag_symbol = '>';
			const_tagname_symbol = 'tag_name';
			const_src_symbol = 'src=';
			const_href_symbol = 'href=';
			const_tag_contents_symbol = 'tag_contents';
			const_target_symbol = 'target=';
			const_target_blank_symbol = '_blank';
			const_target_top_symbol = '_top';

			Cr = Chr(13);
			
			_currentPage_symbol = '?currentPage=';

//			_debugMode = false;

			if ( (IsDefined("_ContentPageList")) AND (Len(Trim(_ContentPageList)) gt 0) ) {
				isCheckingPageList = true;
			} else {
				_ContentPageList = '';
			}

			if (Len(_images_folder) eq 0) {
				dTag = 0;
//				_debugMode = true;
			} else {
			}
			
			theHTML = _someHTML;
			return theHTML; // this is here for now to disable this function to see if JavaScript can handle this easier...
			
			for (iBegin = 1; iBegin lt Len(theHTML); iBegin = iBegin + 1) {
				iBegin = FindNoCase(_html_tag_preamble_symbol, theHTML, iBegin);
				if (iBegin gt 0) {
					iEnd = FindNoCase(_html_tag_postamble_symbol, theHTML, iBegin + 1);
					if (iEnd eq 0) {
						iEnd = Len(theHTML);
					} else {
						iEnd = iEnd + Len(_html_tag_postamble_symbol);
					}
					sTag = Mid(theHTML, iBegin, (iEnd - iBegin) + dTag);
					t_struct = AnalyzeTag(sTag, _debugMode, const_tagname_symbol, const_tag_contents_symbol, _html_tag_postamble_symbol, (Len(_images_folder) eq 0));
					sTagName = StructFind(t_struct, UCASE(const_tagname_symbol));
					if (Len(sTagName) gt 0) {
						StructDelete(t_struct, UCASE(const_tagname_symbol));
						sTagContents = StructFind(t_struct, UCASE(const_tag_contents_symbol));
						if (Len(sTagContents) gt 0) {
							StructDelete(t_struct, UCASE(const_tag_contents_symbol));
						}
						if (Len(_images_folder) gt 0) {
							_url = StructFind(t_struct, UCASE(const_src_symbol));
							iSrc = correctImgSource( _url, _images_folder);
							StructInsert(t_struct, UCASE(const_src_symbol), iSrc, true);

							// make the complete tag using the parms from the previous analysis and the edits...
							an_array = StructKeyArray(t_struct);
							newTag = sTagName & ' ';
							for (i = 1; i lte ArrayLen( an_array); i = i + 1) {
								newTag = newTag & ' ';
								sValue = StructFind(t_struct, an_array[i]);
								if ( (FindNoCase('=', an_array[i]) gt 0) AND (Len(Trim(sValue)) gt 0) ) {
									newTag = newTag & an_array[i] & sValue & ' ';
								}
							}
							newTag = Trim(newTag) & '>';
							if ((iBegin - 1) gte 1) {
								iBegin = iBegin - 1;
							}
							_theHTML = Mid(theHTML, 1, iBegin);
							_theHTML = _theHTML & newTag;
							if ((iEnd + 0) lte Len(_theHTML)) {
								iEnd = iEnd + 0;
							}
							_theHTML = _theHTML & Mid(theHTML, iEnd, (Len(theHTML) - iEnd) + 1);
							theHTML = _theHTML;
							iBegin = iEnd;
						} else {
							// handle the anchor tag...
							try {
								_url = StructFind(t_struct, UCASE(const_href_symbol));
							} catch(Any e) {
								_url = '';
							}
							iHref = correctHref( _url, _currentPage_symbol, t_struct, const_target_symbol, const_target_blank_symbol, const_target_top_symbol);
							if ( (isCheckingPageList) AND (NOT isCurrentPageOnList(iHref, _currentPage_symbol, _ContentPageList)) ) {
								okayToRenderHTML = false;
							}
							StructInsert(t_struct, UCASE(const_href_symbol), iHref, true);

							// make the complete tag using the parms from the previous analysis and the edits...
							an_array = StructKeyArray(t_struct);
							newTag = sTagName & ' ';
							for (i = 1; i lte ArrayLen( an_array); i = i + 1) {
								newTag = newTag & ' ';
								sValue = StructFind(t_struct, an_array[i]);
								if ( (FindNoCase('=', an_array[i]) gt 0) AND (Len(Trim(sValue)) gt 0) ) {
									newTag = newTag & an_array[i] & sValue & ' ';
								}
							}
							sTagContents = ReplaceNoCase(sTagContents, _html_tag_postamble_symbol, '');
							newTag = Trim(newTag) & '>' & sTagContents & _html_tag_postamble_symbol;
			if (_debugMode) WriteOutput('<textarea cols="100" rows="5" readonly wrap="soft" style="font-size: 12px;">');
			if (_debugMode) WriteOutput('(newTag) [#newTag#]#Cr#');
			if (_debugMode) WriteOutput('</textarea>');
							if ((iBegin - 1) gte 1) {
								iBegin = iBegin - 1;
							}
							_theHTML = Mid(theHTML, 1, iBegin);
							_theHTML = _theHTML & newTag;
							if ((iEnd + 0) lte Len(_theHTML)) {
								iEnd = iEnd + 0;
							}
							_theHTML = _theHTML & Mid(theHTML, iEnd, (Len(theHTML) - iEnd) + 1);
							theHTML = _theHTML;
							iBegin = iEnd;
						}
					}
				} else {
					break;
				}
			}
			if (_debugMode) WriteOutput('<textarea cols="100" rows="5" readonly wrap="soft" style="font-size: 12px;">');
			if (_debugMode) WriteOutput('(OUTPUT) [' & theHTML & ']' & '#Cr#');
			if (_debugMode) WriteOutput('</textarea>');
			
			if (NOT okayToRenderHTML) {
				theHTML = '';
			}
		</cfscript>

		<cfreturn theHTML>
	</cffunction>

	<cffunction name="processRecordList" access="public" returntype="string">
		<cfargument name="_list" required="yes" type="string">

		<cfset _aList = "">
		<cfloop index="_anItem" list="#_list#" delimiters=",">
			<cfset _name = GetToken(GetToken(_anItem, 2, "="), 1, "|")>
			<cfset _uid = GetToken(GetToken(_anItem, 2, "="), 2, "|")>
			<cfset _sid = GetToken(_anItem, 2, "=")>
			<cfif (ListLen(_sid, "|") eq 2)>
				<cfset _sid = GetToken(_sid, 2, "|")>
			</cfif>

			<cfset _ipos = ListContainsNoCase(_aList, "#_name#=", ",")>
			<cfif(_ipos eq 0)>
				<cfset _aList = ListAppend(_aList, "#_name#=#_uid#", ",")>
			<cfelse>
				<cfset _uidList = GetToken(ListGetAt(_aList, _ipos, ","), 2, "=")>
				<cfif (ListFindNoCase(_uidList, _uid, "|") eq 0)>
					<cfset _uidList = ListAppend(_uidList, _uid, "|")>
				</cfif>
				<cfset _aList = ListSetAt(_aList, _ipos, "#_name#=#_uidList#", ",")>
			</cfif>
		</cfloop>

		<cfscript>
			_aList = ListSort(_aList, "text", "asc", ",");
		</cfscript>
		
		<cfreturn _aList>
	</cffunction>

	<cffunction name="makeListIntoSQLList" access="public" returntype="string">
		<cfargument name="_list" required="yes" type="string">

		<cfset _sqlList = "">
		<cfloop index="_anItem" list="#_list#" delimiters=",">
			<cfset _anItem = Replace(_anItem, "'", "''", "all")>
			<cfset _sqlList = ListAppend(_sqlList, "'#_anItem#'", ",")>
		</cfloop>
		
		<cfreturn _sqlList>
	</cffunction>

	<cffunction name="getNameUsingSkipOverTags" access="public" returntype="string">
		<cfargument name="_fn" type="numeric" required="yes">
		<cfargument name="_str" required="yes" type="string">
		<cfargument name="_isPhoneNumber" type="boolean" required="yes">
		<cfargument name="_webphone_searchfor_openTag_symbol" required="yes" type="string">
		<cfargument name="_webphone_searchfor_closeTag_symbol" required="yes" type="string">
		<cfargument name="_webphone_searchfor_openEscape_symbol" required="yes" type="string">
		<cfargument name="_webphone_searchfor_closeEscape_symbol" required="yes" type="string">

		<cfset _aName = "">
		<cfset _tagsFound = "">
		<cfset _tagsBody = "">
		<cfloop index="_k" from="#_fn#" to="#Len(_str)#">
			<cfset _ch = Mid(_str, _k, 1)>
			<cfif (_ch eq _webphone_searchfor_openTag_symbol) OR (_ch eq _webphone_searchfor_closeTag_symbol) OR (_ch eq _webphone_searchfor_openEscape_symbol) OR (_ch eq _webphone_searchfor_closeEscape_symbol)>
				<cfif (Len(_aName) gt 0)>
					<cfbreak>
				</cfif>
				<cfset _tagsFound = "#_tagsFound##_ch#">
			<cfelseif (Len(_tagsFound) eq 0)>
				<cfif (NOT _isPhoneNumber) AND (NOT isAlphaNumeric(_ch))>
					<cfif (Len(_aName) gt 0)>
						<cfbreak>
					</cfif>
				</cfif>
				<cfset _aName = "#_aName##_ch#">
			<cfelse>
				<cfset _tagsBody = "#_tagsBody##_ch#">
			</cfif>
			<cfif (Len(_tagsFound) eq 2)>
				<cfset _tagsFound = "">
				<cfset _tagsBody = "">
			</cfif>
		</cfloop>
		
		<cfreturn _aName>
	</cffunction>

	<cffunction name="metaTags" access="public" returntype="string">
		<cfargument name="_title" required="yes" default="" type="string">
		<cfargument name="p_args" type="string" default="">  <!--- comma delimited list name=content,... --->

		<cfscript>
			theTags = "";
		</cfscript>
		
		<cfsavecontent variable="theTags">
			<cfoutput>
				<title>#Request._title#</title>
				<META http-equiv=Content-Type content="text/html; charset=utf-8">
				<cfloop index="_item" list="#p_args#" delimiters=",">
					<cfif (ListLen(_item, "=") eq 2)>
						<META content="#URLDecode(GetToken(_item, 2, "="))#" name="#GetToken(_item, 1, "=")#">
					</cfif>
				</cfloop>
				<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
				<META HTTP-EQUIV="expires" CONTENT="0">
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn theTags>
	</cffunction>

	<cffunction name="dbError" access="public" returntype="string">
		<cfargument name="_cfcatch" type="any" required="yes">

		<cfscript>
			_dbErrorMsg = "";
	
			_dbErrorMsg = _dbErrorMsg &	"<h3><font color=""red"">You've Thrown a #_cfcatch.type# <b>Error</b></font></h3>" & 
						"<p><font color=""red"">#_cfcatch.message#</font></p>" &
						"<p><font color=""red"">Caught an exception, type = #_CFCATCH.TYPE#</font></p>" &
						"";
			if (IsDefined("_cfcatch.detail")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.detail=[<font color=""red"">#_cfcatch.detail#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.NativeErrorCode")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.NativeErrorCode=[<font color=""red"">#_cfcatch.NativeErrorCode#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.SQLState")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.SQLState=[<font color=""red"">#_cfcatch.SQLState#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.Sql")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.Sql=[<font color=""red"">#_cfcatch.Sql#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.queryError")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.queryError=[<font color=""red"">#_cfcatch.queryError#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.where")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.where=[<font color=""red"">#_cfcatch.where#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.ErrNumber")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.ErrNumber=[<font color=""red"">#_cfcatch.ErrNumber#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.MissingFileName")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.MissingFileName=[<font color=""red"">#_cfcatch.MissingFileName#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.LockName")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.LockName=[<font color=""red"">#_cfcatch.LockName#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.LockOperation")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.LockOperation=[<font color=""red"">#_cfcatch.LockOperation#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.ErrorCode")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.ErrorCode=[<font color=""red"">#_cfcatch.ErrorCode#</font>]</p>"; 
			}
			if (IsDefined("_cfcatch.ExtendedInfo")) {
				_dbErrorMsg = _dbErrorMsg &	"<p>cfcatch.ExtendedInfo=[<font color=""red"">#_cfcatch.ExtendedInfo#</font>]</p>"; 
			}
			_dbErrorMsg = _dbErrorMsg &	"<p><font color=""red"">The contents of the tag stack are:</font></p>"; 
			try {
				for (i = 1; i neq ArrayLen(_CFCATCH.TAGCONTEXT); i = i + 1) {
					sCurrent = _CFCATCH.TAGCONTEXT[i];
					sId = sCurrent["ID"];
					sLine = sCurrent["LINE"];
					sColumn = sCurrent["COLUMN"];
					sTemplate = sCurrent["TEMPLATE"];
					_dbErrorMsg =	_dbErrorMsg &	"<br>#i# #sId#" &  "(#sLine#,#sColumn#)" & "#sTemplate#" & 
									"";
				}
			} catch (Any e) {
			}
		</cfscript>

		<cfreturn _dbErrorMsg>
	</cffunction>

	<cffunction name="makeDHTMLLink" access="public" returntype="string">
		<cfargument name="_aLink" required="yes" type="string">
		<cfargument name="_id" required="yes" type="string">
		<cfargument name="_style" required="yes" type="string">

		<cfset _id_symbol = "id=">
		<cfset _style_symbol = "style=">

		<cfset theLink = _aLink>
		<cfif (FindNoCase(theLink, _id_symbol) eq 0)>
			<cfset theLink = Replace(theLink, '>', ' #_id_symbol#"#_id#">')>
		</cfif>
		<cfif (FindNoCase(theLink, _style_symbol) eq 0)>
			<cfset theLink = Replace(theLink, '>', ' #_style_symbol#"#_style#">')>
		</cfif>
		
		<cfreturn theLink>
	</cffunction>

	<cffunction name="makeHTMLEditorLink2" access="public" returntype="string">
		<cfargument name="_id_" type="string" default="" required="yes">
		<cfargument name="_title_" type="string" default="" required="yes">
		<cfargument name="_bool_" type="boolean" default="False" required="yes">
		<cfargument name="_functionSymbol" required="yes" default="" type="string">
		<cfargument name="_functionArgs" required="yes" default="" type="string">
		<cfargument name="_anchorTitle" required="yes" default="" type="string">
		<cfargument name="_anchorTarget" required="no" default="myCMSv1" type="string">

		<cfscript>
			theLink = "";
	
			scriptName = CGI.SCRIPT_NAME;
			if (_bool_) {
				last_scriptName = GetToken(scriptName, ListLen( scriptName, "/"), "/");
				scriptName = Replace(scriptName, last_scriptName, "htmlArea_editor.cfm");
			}
			_tooltips = '';
			if (Len(Trim(_id_)) gt 0) {
				_tooltips = setup_tooltip_handlers(_id_);
			}
			_title_ = Replace(_title_, '"', '""', 'all');
			theLink = '<a #_tooltips# title="#_title_#" href="#scriptName#?function=#URLEncodedFormat(_functionSymbol)##_functionArgs#" target="#_anchorTarget#">#_anchorTitle#</a>';
		</cfscript>
		
		<cfreturn theLink>
	</cffunction>

	<cffunction name="makeHTMLEditorLink" access="public" returntype="string">
		<cfargument name="_functionSymbol" required="yes" default="" type="string">
		<cfargument name="_functionArgs" required="yes" default="" type="string">
		<cfargument name="_anchorTitle" required="yes" default="" type="string">
		<cfargument name="_anchorTarget" required="no" default="myCMSv1" type="string">

		<cfscript>
			theLink = "";
	
			scriptName = CGI.SCRIPT_NAME;
			last_scriptName = GetToken(scriptName, ListLen( scriptName, "/"), "/");
			scriptName = Replace(scriptName, last_scriptName, "htmlArea_editor.cfm");
			theLink = '<a href="' & scriptName & '?function=' & URLEncodedFormat(_functionSymbol) & _functionArgs & '" target="' & _anchorTarget & '">' & _anchorTitle & '</a>';
		</cfscript>
		
		<cfreturn theLink>
	</cffunction>

	<cffunction name="makeContentEditorLink" access="public" returntype="string">
		<cfargument name="isDisabled" type="boolean" required="yes">
		<cfargument name="p_adminMethod" required="yes" type="string">
		<cfargument name="p_adminMethod_nopopups" required="yes" type="string">
		<cfargument name="p_bool" type="boolean" required="yes">
		<cfargument name="p_editor_title" required="yes" type="string">
		<cfargument name="p_action_symbol" required="yes" type="string">
		<cfargument name="p_urlParms" required="yes" type="string">
		<cfargument name="p_editor_prompt_symbol" required="yes" type="string">

		<cfif p_adminMethod eq p_adminMethod_nopopups>
			<cfset _editor = makeHTMLEditorLink2( "", p_editor_title, p_bool, p_action_symbol, p_urlParms, p_editor_prompt_symbol)>
		<cfelse>
			<cfset _editor = makePopupLink( p_action_symbol, p_urlParms, p_editor_prompt_symbol)>
		</cfif>
		<cfif (NOT isDisabled)>
			<cfset _newPage_editor = '<font size="1">#_editor#</font>'>
		<cfelse>
			<cfset _newPage_editor = '<font size="1" color="silver"><i>#p_editor_prompt_symbol#</i></font>'>
		</cfif>

		<cfreturn _newPage_editor>
	</cffunction>

	<cffunction name="makeMenuInUseContactUserLink" access="public" returntype="string">
		<cfargument name="p_sbcuid" required="yes" type="string">
		<cfargument name="p_color" type="string" default="">

		<cfset _colored_value = p_sbcuid>
		<cfif (Len(Trim(p_color)) gt 0)>
			<cfset _colored_value = '<font color="#p_color#">#p_sbcuid#</font>'>
		</cfif>
		<cfset p_emailLink = '<a href="mailto:#p_sbcuid#?subject=Menu Editor Access&body=Can you please unlock the Menu editor by saving your changes ?">#_colored_value#</a>'>
		
		<cfreturn p_emailLink>
	</cffunction>

	<cffunction name="makeSiteUrl" access="public" returntype="string">
		<cfargument name="_functionSymbol" required="yes" default="" type="string">
		<cfargument name="_functionArgs" required="yes" default="" type="string">

		<cfscript>
			aSiteUrl = "";
	
			scriptName = CGI.SCRIPT_NAME;
			aSiteUrl =	scriptName & "?function=" & URLEncodedFormat(_functionSymbol) & _functionArgs;
		</cfscript>
		
		<cfreturn aSiteUrl>
	</cffunction>

	<cffunction name="makeSubmitLink" access="public" returntype="string">
		<cfargument name="_functionSymbol" required="yes" default="" type="string">
		<cfargument name="_functionArgs" required="yes" default="" type="string">
		<cfargument name="_anchorTitle" required="yes" default="" type="string">
		<cfargument name="_anchorTarget" required="no" default="myCMSv1" type="string">

		<cfscript>
			theLink = "";
	
			scriptName = CGI.SCRIPT_NAME;
			theLink =	"<a href=""" & scriptName & "?submit=" & URLEncodedFormat(_functionSymbol) & _functionArgs & """ target=""" & _anchorTarget & """>" & _anchorTitle & "</a>" &
						"";
		</cfscript>
		
		<cfreturn theLink>
	</cffunction>

	<cffunction name="makeLink" access="public" returntype="string">
		<cfargument name="_functionSymbol" required="yes" default="" type="string">
		<cfargument name="_functionArgs" required="yes" default="" type="string">
		<cfargument name="_anchorTitle" required="yes" default="" type="string">
		<cfargument name="_anchorTarget" required="no" default="myCMSv1" type="string">

		<cfscript>
			theLink = "";
	
			scriptName = CGI.SCRIPT_NAME;
			theLink =	"<a href=""" & scriptName & "?function=" & URLEncodedFormat(_functionSymbol) & _functionArgs & """ target=""" & _anchorTarget & """>" & _anchorTitle & "</a>" &
						"";
		</cfscript>
		
		<cfreturn theLink>
	</cffunction>

	<cffunction name="makePopupLink" access="public" returntype="string">
		<cfargument name="_functionSymbol" required="yes" default="" type="string">
		<cfargument name="_functionArgs" required="yes" default="" type="string">
		<cfargument name="_anchorTitle" required="yes" default="" type="string">
		<cfargument name="_anchorTarget" required="no" default="myCMSv1" type="string">

		<cfscript>
			theLink = "";

			poundChar = "##";
			doubleQuoteChar = '"';
			scriptName = CGI.SCRIPT_NAME;
			_url = "'" & scriptName & "?function=" & URLEncodedFormat(_functionSymbol) & _functionArgs & "'";
			_left = (1024 - 800) / 2;
			_top = (768 - 600) / 2;
			_onClick = " onClick=""myRef = window.open(''+#_url#+'','myWindow','left=#_left#,top=#_top#,width=800,height=600,toolbar=1,location=0,resizable=0,status=1,menuBar=1,scrollBar=1');myRef.focus()""";
			theLink =	"<a href=" & doubleQuoteChar & poundChar & doubleQuoteChar & _onClick & ">" & _anchorTitle & "</a>" &
						"";
		</cfscript>
		
		<cfreturn theLink>
	</cffunction>

	<cffunction name="makePopupStagingLink" access="public" returntype="string">
		<cfargument name="_functionSymbol" required="yes" default="" type="string">
		<cfargument name="_functionArgs" required="yes" default="" type="string">
		<cfargument name="_anchorTitle" required="yes" default="" type="string">
		<cfargument name="_anchorTarget" required="no" default="myCMSv1" type="string">

		<cfscript>
			scriptName = ReplaceNoCase(CGI.SCRIPT_NAME, '/admin/', '/admin/staging/');
			_url = scriptName & "?" & _functionSymbol & "=" & URLEncodedFormat(_functionArgs);
			theLink =	'<a href="#_url#" title="' & _anchorTitle & '" target="_blank">[Staging]</a>';
		</cfscript>
		<!--- BEGIN: This function is only called when there is a Staging Release and there is NO Draft Release - there can be NO Draft when there is a Staging Release --->
		<cflocation url="#_url#" addtoken="No">
		<!--- END! This function is only called when there is a Staging Release and there is NO Draft Release - there can be NO Draft when there is a Staging Release --->
		
		<cfreturn theLink>
	</cffunction>

	<cffunction name="PageTitle" access="public" returntype="string">
		<cfargument name="aQuery" required="yes" type="query">
		<cfargument name="_titleText" required="yes" type="string">

		<cfif (IsDefined("aQuery")) AND (aQuery.recordCount gt 0) AND (IsDefined("aQuery.PageTitle"))>
			<cfloop query="aQuery" startrow="1" endrow="#aQuery.recordCount#">
				<cfif (Len(aQuery.PageTitle) gt 0) AND (Len(aQuery.pageId) gt 0)>
					<cfset _titleText = aQuery.PageTitle>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn _titleText>
	</cffunction>

	<cffunction name="divUpdates" access="public" returntype="string">
		<cfargument name="_float" type="string" default="">

		<cfset _div_style = ''>
		<cfif (Len(_float) gt 0)>
			<cfset _div_style = ' style="float:#_float#"'>
		</cfif>
		
		<cfset _someHTML = '
			<div id="updates"#_div_style#>
		'>
		<cfdirectory 
		   directory="#GetDirectoryFromPath(GetTemplatePath())#" 
		   name="myDirectory" 
		   sort="name ASC, size DESC">
		<cfloop query="myDirectory">
			<cfif FindNoCase(UCASE(myDirectory.name), UCASE(CGI.SCRIPT_NAME)) gt 0>
				<cfset myDateLastModified = ParseDateTime(myDirectory.dateLastModified)>
				<cfset myFormattedDateTime = "">
				<cfset myFormattedDate1 = DateFormat(myDateLastModified, "dd mmmm-yyyy")>
				<cfset myFormattedDateTime = "#myFormattedDateTime##myFormattedDate1#">
				<cfset myFormattedDate2 = TimeFormat(myDateLastModified, "hh:mm")>
				<cfset myFormattedDateTime = "#myFormattedDateTime#&nbsp;#myFormattedDate2#">
				<cfset myFormattedDate3 = LCASE(TimeFormat(myDateLastModified, "tt"))>
				<cfset myFormattedDateTime = "#myFormattedDateTime#&nbsp;#myFormattedDate3#">
				<cfset myFormattedDate4 = UCASE(Right(TimeFormat(myDateLastModified, "long"), 3))>
				<cfset myFormattedDateTime = "#myFormattedDateTime#&nbsp;#myFormattedDate4#">
				<cfbreak>
			</cfif>
		</cfloop>
		<cfset _someHTML = '#_someHTML#
				<p>
				<font size="1"><small><NOBR>Last Updated: #myFormattedDateTime#</NOBR></small></font>
				</p>
			</div>
		'>
		<cfset _someHTML = ''>
		
		<cfreturn _someHTML>
	</cffunction>

	<cffunction name="divUpdates2" access="public" returntype="string">
		<cfargument name="_date_" type="date" required="yes">
		<cfargument name="_float" type="string" default="">

		<cfset _div_style = ''>
		<cfif (Len(_float) gt 0)>
			<cfset _div_style = ' style="float:#_float#"'>
		</cfif>
		
		<cfset myDateLastModified = _date_>
		<cfset myFormattedDateTime = "">
		<cfset myFormattedDate1 = DateFormat(myDateLastModified, "dd mmmm-yyyy")>
		<cfset myFormattedDateTime = "#myFormattedDateTime##myFormattedDate1#">
		<cfset myFormattedDate2 = TimeFormat(myDateLastModified, "hh:mm")>
		<cfset myFormattedDateTime = "#myFormattedDateTime#&nbsp;#myFormattedDate2#">
		<cfset myFormattedDate3 = LCASE(TimeFormat(myDateLastModified, "tt"))>
		<cfset myFormattedDateTime = "#myFormattedDateTime#&nbsp;#myFormattedDate3#">
		<cfset myFormattedDate4 = UCASE(Right(TimeFormat(myDateLastModified, "long"), 3))>
		<cfset myFormattedDateTime = "#myFormattedDateTime#&nbsp;#myFormattedDate4#">

		<cfset _someHTML = '
			<div id="updates"#_div_style#>
				<p>
				<font size="1"><small><NOBR>Last Updated: #myFormattedDateTime#</NOBR></small></font>
				</p>
			</div>
		'>
		<cfset _someHTML = ''>
		
		<cfreturn _someHTML>
	</cffunction>

	<cffunction name="reportTableRowColor" access="public" returntype="string">
		<cfargument name="_rowId" required="yes" type="string">

		<cfset _theColor = "##99FFCC">
		<cfif (_rowId MOD 2) eq 0>
			<cfset _theColor = "##FFFFCC">
		</cfif>
		
		<cfreturn Trim(_theColor)>
	</cffunction>

	<cffunction name="serverTimeZone" access="public" returntype="string">
		<cfargument name="_currentTime" type="date" required="yes">

		<cfset _timeZone = UCASE(Right(TimeFormat(_currentTime, "long"), 3))>

		<cfreturn _timeZone>
	</cffunction>

	<cffunction name="formattedDateTimeTZ" access="public" returntype="string">
		<cfargument name="_currentTime" type="date" required="yes">

		<cfset _thisDate = DateFormat(_currentTime, "mm/dd/yyyy")>
		<cfset _timeZone = serverTimeZone(_currentTime)>
		<cfset _thisTime = LCASE(TimeFormat(_currentTime, "hh:mm tt"))>

		<cfset _formattedString = "#_thisDate# #_thisTime# #_timeZone#">
		
		<cfreturn _formattedString>
	</cffunction>

	<cffunction name="getCurrentPageFromURL" access="public" returntype="string">
		<cfargument name="_theUrl" type="string" required="yes">
		<cfargument name="currentPage_symbol" type="string" required="yes">

		<cfset _curPage = "">
		<cfif (FindNoCase(currentPage_symbol, _theUrl) gt 0)>
			<cfset _curPage = GetToken(GetToken(_theUrl, 2, "?"), 2, "=")>
		</cfif>
		
		<cfreturn _curPage>
	</cffunction>

	<cffunction name="getStagingURLpattern" access="public" returntype="string">
		<cfset s = "/admin/staging/">
		<cfreturn s>
	</cffunction>

	<cffunction name="get_htmlArea_editor_pattern" access="public" returntype="string">
		<cfset s = "htmlArea_editor.cfm">
		<cfreturn s>
	</cffunction>

	<cffunction name="is_htmlArea_editor" access="public" returntype="boolean">
		<cfset bool = (FindNoCase(get_htmlArea_editor_pattern(), CGI.SCRIPT_NAME) gt 0)>
		<cfreturn bool>
	</cffunction>

	<cffunction name="isStagingView" access="public" returntype="boolean">
		<cfset bool = (FindNoCase(getStagingURLpattern(), CGI.SCRIPT_NAME) gt 0)>
		<cfreturn bool>
	</cffunction>

	<cffunction name="isServerLocal" access="public" returntype="boolean">
		<cfset bool = (UCASE(TRIM(CGI.HTTP_HOST)) eq "LOCALHOST")>
		<cfreturn bool>
	</cffunction>

	<cffunction name="makeProperURLPrefix" access="public" returntype="string">
		<cfargument name="p_url" required="yes" default="" type="string">
		
		<cfscript>
			if (Right(p_url, 1) neq '/') {
				p_url = p_url & '/';
			}
		</cfscript>

		<cfreturn p_url>
	</cffunction>

	<cffunction name="getURLprefixBasedOn" access="public" returntype="string">
		<cfargument name="p_base" required="yes" default="" type="string">
		<cfargument name="p_subsysName" required="yes" default="" type="string">

		<cfscript>
			var i = -1;
			var s_prefix = '';
			
			p_subsysName = Trim(p_subsysName);
			if (Mid(p_subsysName, Len(p_subsysName), 1) neq '/') {
				p_subsysName = p_subsysName & '/';
			}
			i = FindNoCase(p_subsysName, p_base);
			if (i gt 0) {
				s_prefix = Mid(p_base, 1, i - 1);
			}
		</cfscript>
		
		<cfreturn s_prefix>
	</cffunction>

	<cffunction name="sql_getStagingRelease_rid" access="public" returntype="string">
		<cfargument name="_standaloneMode" type="boolean" required="yes">
		<cfargument name="tableName_ReleaseManagement" type="string" required="yes">

		<cfset _SQL_statement = "">
		<cfif (_standaloneMode)>
			<cfset _SQL_statement = "#_SQL_statement#
				DECLARE @prid as int;
				DECLARE @pdate as datetime;
			">
		</cfif>

		<cfset _SQL_statement = "#_SQL_statement#
			SELECT @prid = (SELECT TOP 1 id FROM #tableName_ReleaseManagement# WHERE ( (devDateTime IS NULL) AND (prodDateTime IS NULL) AND (archDateTime IS NULL) AND (stageDateTime IS NOT NULL) ) ORDER BY stageDateTime DESC);
			SELECT @pdate = (SELECT TOP 1 stageDateTime FROM #tableName_ReleaseManagement# WHERE (id = @prid) ORDER BY stageDateTime DESC);
		">

		<cfreturn _SQL_statement>
	</cffunction>

	<cffunction name="sql_getCurrentRelease_rid" access="public" returntype="string">
		<cfargument name="_adminMode" type="numeric" required="yes">
		<cfargument name="tableName_ReleaseManagement" type="string" required="yes">

		<cfif (isStagingView())>
			<cfset _SQL_statement = sql_getStagingRelease_rid("True", tableName_ReleaseManagement)>
		<cfelseif (_adminMode eq 0)>
			<cfset _SQL_statement = "
				DECLARE @prid as int;
				SELECT @prid = (SELECT TOP 1 id FROM #tableName_ReleaseManagement# WHERE ( (devDateTime IS NULL) AND (prodDateTime IS NOT NULL) AND (archDateTime IS NULL) AND (stageDateTime IS NULL) ));

				DECLARE @pdate as datetime;
				SELECT @pdate = (SELECT TOP 1 prodDateTime FROM #tableName_ReleaseManagement# WHERE (id = @prid) ORDER BY prodDateTime DESC);
			">
		<cfelse>
			<cfset _SQL_statement = "
				DECLARE @prid as int;
				SELECT @prid = (SELECT TOP 1 id FROM #tableName_ReleaseManagement# WHERE ( (devDateTime IS NOT NULL) AND (prodDateTime IS NULL) AND (archDateTime IS NULL) AND (stageDateTime IS NULL) ));

				DECLARE @pdate as datetime;
				SELECT @pdate = (SELECT TOP 1 devDateTime FROM #tableName_ReleaseManagement# WHERE (id = @prid) ORDER BY devDateTime DESC);
			">
		</cfif>
		
		<cfreturn _SQL_statement>
	</cffunction>

	<cffunction name="sql_saveMenuColor" access="public" returntype="string">
		<cfargument name="_initMode" type="boolean" required="yes">
		<cfargument name="_pageName" type="string" required="yes">
		<cfargument name="_datum" type="string" required="yes">
		<cfargument name="_userid" type="string" required="yes">
		<cfargument name="tableName_DynamicPageManagement" type="string" required="yes">
		<cfargument name="tableName_DynamicHTMLpad" type="string" required="yes">
		<cfargument name="tableName_ReleaseActivityLog" type="string" required="yes">

		<cfset _timeString = formattedDateTimeTZ(Now())>

		<cfset _SQL_statement = "">

		<cfif (_initMode)>
			<cfset _SQL_statement = "#_SQL_statement#
				DECLARE @menuColorId as int;
				DECLARE @menuColorPgId as int;
			">
		</cfif>
		
		<cfset _SQL_statement = "#_SQL_statement#
			SELECT @menuColorId = (SELECT TOP 1 id FROM #tableName_DynamicPageManagement# WHERE (pageName = '#_pageName#') AND (rid = @prid));
			
			IF @menuColorId IS NULL
			BEGIN
				SELECT @menuColorPgId = (SELECT TOP 1 pageId FROM #tableName_DynamicPageManagement# WHERE (rid = @prid) ORDER BY pageId DESC);
				SELECT @menuColorPgId = @menuColorPgId + 1;
				INSERT INTO #tableName_DynamicPageManagement# (pageId, pageName, PageTitle, versionDateTime, rid)
					VALUES (@menuColorPgId, '#_pageName#', '#_pageName#', NULL, @prid);
				INSERT INTO #tableName_DynamicHTMLpad# (pageId, html, rid) VALUES (@menuColorPgId, '#_datum#', @prid);
				INSERT INTO #tableName_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #_userid#: Inserted New Menu Color to (#_datum#) on #_timeString#');
			END
			ELSE
			BEGIN
				SELECT @menuColorPgId = (SELECT TOP 1 pageId FROM #tableName_DynamicPageManagement# WHERE (id = @menuColorId) AND (rid = @prid));
				UPDATE #tableName_DynamicHTMLpad# SET html = '#_datum#' WHERE (pageId = @menuColorPgId) AND (rid = @prid);
				INSERT INTO #tableName_ReleaseActivityLog# (rid, dateTime, comments) VALUES (@prid,GETDATE(),'SBCUID #_userid#: Updated Menu Color to (#_datum#) on #_timeString#');
			END;
		">
		
		<cfreturn _SQL_statement>
	</cffunction>

	<cffunction name="sql_saveSiteMenu" access="public" returntype="string" output="No">
		<cfargument name="menuContent" type="string" required="yes">
		<cfargument name="tableName_DynamicPageManagement" type="string" required="yes">
		<cfargument name="tableName_DynamicHTMLmenu" type="string" required="yes">

		<cfset _menuContent = Replace(menuContent, "'", "''", "all")>
		<cfset _SQL_statement = "
			DECLARE @pid int;
			SELECT @pid = (SELECT TOP 1 pageId FROM #tableName_DynamicPageManagement# WHERE (pageName = 'menuPage') AND (rid = @prid));
			IF @pid IS NOT NULL
			BEGIN
				UPDATE #tableName_DynamicHTMLmenu# SET html = '#_menuContent#' WHERE ( (pageId = @pid) AND (rid = @prid) );
			END;
			IF @pid IS NULL
			BEGIN
				DECLARE @pgid int;
				SELECT @pgid = (SELECT TOP 1 pageId FROM #tableName_DynamicPageManagement# WHERE (rid = @prid) ORDER BY pageId DESC);
				INSERT INTO #tableName_DynamicPageManagement# (pageId, pageName, PageTitle, versionDateTime, rid) VALUES (@pgid,'menuPage','[menuPage]',GetDate(),@prid);
				SELECT @pid = (SELECT TOP 1 pageId FROM #tableName_DynamicPageManagement# WHERE (pageName = 'menuPage') AND (rid = @prid));
				INSERT INTO #tableName_DynamicHTMLmenu# (pageId, html, rid) VALUES (@pid,'#_menuContent#',@prid);
			END;
		">
		
		<cfreturn _SQL_statement>
	</cffunction>

	<cffunction name="sql_saveReleaseComments" access="public" returntype="string">
		<cfargument name="_comments_" type="string" required="yes">
		<cfargument name="tbl_ReleaseManagementComments" type="string" required="yes">
		<cfargument name="tbl_ReleaseActivityLog" type="string" required="yes">
		<cfargument name="_rid_" type="string" required="yes">
		<cfargument name="_userid_" type="string" required="yes">
		<cfargument name="_formattedString_" type="string" required="yes">

		<cfset _formattedString_ = Replace(_formattedString_, "'", "''", "all")>

		<cfset _SQL_statement = "
			INSERT INTO #tbl_ReleaseManagementComments# (rid, aDateTime, comments) VALUES (#_rid_#,GETDATE(),'SBCUID #_userid_# : #_comments_#');
			
			INSERT INTO #tbl_ReleaseActivityLog# (rid, dateTime, comments) VALUES (#_rid_#,GETDATE(),'SBCUID #_userid_#: Added comment(s) #_formattedString_#');
		">

		<cfreturn _SQL_statement>
	</cffunction>

	<cffunction name="DebugString" access="public" returntype="string" output="Yes">
		<cfargument name="_s_" type="string" required="yes">

		<cfloop index="_i" from="1" to="#Len(Trim(_s_))#">
			(#Asc(Mid(_s_, _i, 1))#)&nbsp;
		</cfloop>
		
		<cfreturn "">
	</cffunction>

	<cffunction name="correctSiteMenuLinks" access="public" returntype="string" output="No">
		<cfargument name="_menuContent" type="string" required="yes">
		<cfargument name="_currentPage_symbol" type="string" required="yes">

		<cfloop index="_i" from="1" to="#ListLen(_menuContent, ",")#">
			<cfset _item = ListGetAt(_menuContent, _i, ",")>
			<cfset _url = GetToken(_item, 1, "|")>
			<cfset _new_url = _correctHref(_url, _currentPage_symbol)>
			<cfset _item = ListSetAt(_item, 1, _new_url, "|")>
			<cfset _menuContent = ListSetAt(_menuContent, _i, _item, ",")>
		</cfloop>
		
		<cfreturn _menuContent>
	</cffunction>

	<cffunction name="makeUserPageEditorLink2" access="public" returntype="string">
		<cfargument name="_id_" type="string" default="" required="yes">
		<cfargument name="_title_" type="string" default="" required="yes">
		<cfargument name="_editorAction_symbol" type="string" required="yes">
		<cfargument name="pageName" type="string" required="yes">
		<cfargument name="_pageName" type="string" required="yes">
		<cfargument name="currentPage" type="string" required="yes">
		<cfargument name="_adminMethod" type="string" required="yes">
		<cfargument name="_adminMethod_nopopups" type="string" required="yes">
		<cfargument name="urlParms" type="string" required="yes">

		<cfset _htmlEditorUserPageAction_symbol = "#_editorAction_symbol#">
		<cfif (Len(pageName) gt 0)>
			<cfset _htmlEditorUserPageAction_symbol = "#_htmlEditorUserPageAction_symbol#|#pageName#">
		</cfif>
		<cfset _urlParms = "&pageName=#URLEncodedFormat(_pageName)#&currentPage=#URLEncodedFormat(currentPage)##urlParms#">
		<cfif _adminMethod eq _adminMethod_nopopups>
			<cfset _editor = makeHTMLEditorLink2( _id_, _title_, "True", _htmlEditorUserPageAction_symbol, _urlParms, _editorAction_symbol)>
		<cfelse>
			<cfset _editor = makePopupLink( _htmlEditorUserPageAction_symbol, _urlParms, _editorAction_symbol)>
		</cfif>
		<cfset _userPage_editor = '<font size="1">#_editor#</font>'>
		
		<cfreturn _userPage_editor>
	</cffunction>

	<cffunction name="makeUserPageEditorLink" access="public" returntype="string">
		<cfargument name="_editorAction_symbol" type="string" required="yes">
		<cfargument name="pageName" type="string" required="yes">
		<cfargument name="_pageName" type="string" required="yes">
		<cfargument name="currentPage" type="string" required="yes">
		<cfargument name="_adminMethod" type="string" required="yes">
		<cfargument name="_adminMethod_nopopups" type="string" required="yes">
		<cfargument name="urlParms" type="string" required="yes">

		<cfset _htmlEditorUserPageAction_symbol = "#_editorAction_symbol#">
		<cfif (Len(pageName) gt 0)>
			<cfset _htmlEditorUserPageAction_symbol = "#_htmlEditorUserPageAction_symbol#|#pageName#">
		</cfif>
		<cfset _urlParms = "&pageName=#URLEncodedFormat(_pageName)#&currentPage=#URLEncodedFormat(currentPage)##urlParms#">
		<cfif _adminMethod eq _adminMethod_nopopups>
			<cfset _editor = makeHTMLEditorLink( _htmlEditorUserPageAction_symbol, _urlParms, _editorAction_symbol)>
		<cfelse>
			<cfset _editor = makePopupLink( _htmlEditorUserPageAction_symbol, _urlParms, _editorAction_symbol)>
		</cfif>
		<cfset _userPage_editor = '<font size="1">#_editor#</font>'>
		
		<cfreturn _userPage_editor>
	</cffunction>

	<cffunction name="makeColoredMessageBlock" access="public" returntype="string">
		<cfargument name="_color" type="string" required="yes">
		<cfargument name="_cols" type="string" required="yes">
		<cfargument name="_id" type="string" required="yes">
		<cfargument name="_text" type="string" required="yes">
		<cfargument name="_bool_" type="boolean" default="True">

		<cfsavecontent variable="_html">
			<cfoutput>
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td align="center">
							<font size="2" color="#_color#"><b>#_text#</b></font>
						</td>
					</tr>
				<cfif (_bool_)>
					<tr>
						<td align="center">
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td align="left">
										<font size="1"><b>These Page Names are already in-use.</b></font>
									</td>
								</tr>
								<tr>
									<td align="left">
										<textarea cols="#_cols#" rows="6" id="#_id#" readonly style="font-size: 10px;"></textarea>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</cfif>
				</table>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="makePageNameErrorMessageBlock" access="public" returntype="string">
		<cfargument name="_cols" type="string" required="yes">
		<cfargument name="_id" type="string" required="yes">
		<cfargument name="_text" type="string" required="yes">
		<cfargument name="_bool_" type="boolean" default="True">

		<cfreturn makeColoredMessageBlock("##ff0000", _cols, _id, _text, _bool_)>
	</cffunction>

	<cffunction name="makeAdvisoryMessageBlock" access="public" returntype="string">
		<cfargument name="_cols" type="string" required="yes">
		<cfargument name="_id" type="string" required="yes">
		<cfargument name="_text" type="string" required="yes">
		<cfargument name="_bool_" type="boolean" default="True">

		<cfreturn makeColoredMessageBlock("blue", _cols, _id, _text, _bool_)>
	</cffunction>

	<cffunction name="getVerboseReleaseStatus" access="public" returntype="string">
		<cfargument name="aStatus" type="string" default="" required="yes">

		<cfscript>
			_theStatus = "";
			if (UCase(aStatus) eq "D") {
				_theStatus = "Draft";
			} else if (UCase(aStatus) eq "P") {
				_theStatus = "Production";
			} else if (UCase(aStatus) eq "A") {
				_theStatus = "Archive";
			} else if (UCase(aStatus) eq "S") {
				_theStatus = "Staging";
			}
		</cfscript>
		
		<cfreturn _theStatus>
	</cffunction>

	<cffunction name="getReleaseStatus" access="public" returntype="string">
		<cfargument name="aDevDate" type="string" default="" required="yes">
		<cfargument name="aProdDate" type="string" default="" required="yes">
		<cfargument name="aArchDate" type="string" default="" required="yes">
		<cfargument name="aStageDate" type="string" default="" required="yes">

		<cfscript>
			_theStatus = "";
			if (Len(aDevDate) gt 0) {
				_theStatus = "D";
			} else if (Len(aProdDate) gt 0) {
				_theStatus = "P";
			} else if (Len(aArchDate) gt 0) {
				_theStatus = "A";
			} else if (Len(aStageDate) gt 0) {
				_theStatus = "S";
			}
		</cfscript>
		
		<cfreturn _theStatus>
	</cffunction>

	<cffunction name="filterListDelims" access="public" returntype="string">
		<cfargument name="aString" type="string" required="yes">

		<!--- BEGIN: These chars are used for lists and the like and CANNOT be allowed inside pageName objects --->
		<cfset _aString = Replace(aString, ",", "", "all")>
		<cfset _aString = Replace(_aString, "|", "", "all")>
		<cfset _aString = Replace(_aString, "@", "", "all")>
		<cfset _aString = Replace(_aString, "=", "", "all")>
		<cfset _aString = Replace(_aString, "+", "", "all")>
		<cfset _aString = Replace(_aString, "##", "", "all")>
		<cfset _aString = Replace(_aString, "'", "", "all")>
		<!--- END! These chars are used for lists and the like and CANNOT be allowed inside pageName objects --->
		
		<cfreturn _aString>
	</cffunction>

	<cffunction name="mungePageTitleIntoPageName" access="public" returntype="string">
		<cfargument name="pName" required="yes" type="string">

		<!--- BEGIN: This code MUST match the JavaScript used to determine if the page title results in a non-unique pageName --->
		<cfscript>
			_theName = "";
			
			for (i = 1; i lte Len(pName); i = i + 1) {
				ch = Mid(pName, i, 1);
				if ( (ch gte "0") AND (ch lte "z") ) {
					_theName = _theName & ch;
				} else {
					_theName = _theName & "_";
				}
			}
		</cfscript>
		<!--- END! This code MUST match the JavaScript used to determine if the page title results in a non-unique pageName --->
		
		<cfreturn Trim(filterListDelims(_theName))>
	</cffunction>

	<cffunction name="getUnlinkables" access="public" returntype="string">
		<cfargument name="menuContent" type="string" required="yes">
		<cfargument name="baseline_pages_not_linkable" type="string" required="yes">
		<cfargument name="menuSubMenuURL_symbol" type="string" required="yes">
		<cfargument name="menuSubMenuEndsURL_symbol" type="string" required="yes">
		<cfargument name="currentPage_symbol" type="string" required="yes">

		<cfset _notLinkables = baseline_pages_not_linkable>
		<cfloop index="_anItem" list="#menuContent#" delimiters=",">
			<cfif ListLen(_anItem, "|") gt 0>
				<cfset _url = GetToken(_anItem, 1, "|")>
				<cfset _target = GetToken(_anItem, 2, "|")>
				<cfset _prompt = GetToken(_anItem, 3, "|")>
				<cfif (_url neq menuSubMenuURL_symbol) AND (_url neq menuSubMenuEndsURL_symbol)>
					<cfset _curPage = "">
					<cfif (FindNoCase(currentPage_symbol, _url) gt 0)>
						<cfset _curPage = GetToken(GetToken(_url, 2, "?"), 2, "=")>
						<cfset _curPage = Replace(_curPage, "'", "''", "all")>
					</cfif>
					<cfif Len(_curPage) gt 0>
						<cfset _notLinkables = ListAppend(_notLinkables, "'#_curPage#'", ",")>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn _notLinkables>
	</cffunction>

	<cffunction name="makeMenuItemControlPanel" access="public" returntype="string">
		<cfargument name="menuLink" type="string" required="yes">
		<cfargument name="menuType" type="string" required="yes">
		<cfargument name="_editorMenuAddAction_symbol" type="string" required="yes">
		<cfargument name="_addLink" type="string" required="yes">
		<cfargument name="_editorMenuDropAction_symbol" type="string" required="yes">
		<cfargument name="_dropLink" type="string" required="yes">
		<cfargument name="_editorMenuEditAction_symbol" type="string" required="yes">
		<cfargument name="_editLink" type="string" required="yes">
		<cfargument name="_editorMenuAddSubMenuAction_symbol" type="string" required="yes">
		<cfargument name="_editorMenuAddSubMenuContainerAction_symbol" type="string" required="yes">
		<cfargument name="_containerLink" type="string" required="yes">
		<cfargument name="_belowOrInside_symbol" type="string" required="yes">
		<cfargument name="_itemOrSubMenu_symbol" type="string" required="yes">
		<cfargument name="_itemCount" type="numeric" required="yes">
		<cfargument name="_itemCountMax" type="numeric" required="yes">
		<cfargument name="_reorganizeMenuUpImage_symbol" type="string" required="yes">
		<cfargument name="_reorganizeMenuDnImage_symbol" type="string" required="yes">
		<cfargument name="_moveUpLink" type="string" required="yes">
		<cfargument name="_moveDnLink" type="string" required="yes">

		<cfset _useJS = "False">
		<cfif 1>
			<!--- BEGIN: Normal mode for now is to use CF --->
			<cfset _useJS = "True">
			<!--- END! Normal mode for now is to use CF --->
		</cfif>
		
		<cfset _theLink = ''>
		
		<cfset _theLink = '#_theLink#<table cellpadding="-1" cellspacing="-1"><tr>'>
		<cfset _theLink = '#_theLink#<td>'>
		<cfset _a_style = 'style="border: thin outset Silver; width: 16px; text-align: center; vertical-align: bottom;"'>
		<cfset _theLink = '#_theLink#<table cellpadding="-1" cellspacing="-1">'>
		<cfset _theLink = '#_theLink#<tr>'>
		<cfset _theLink = '#_theLink#<td>'>
		<cfset _theLink = '#_theLink#<a href="#_addLink#" title="Menu Item Add - Add a Menu Item #_belowOrInside_symbol# this #_itemOrSubMenu_symbol#." #_a_style#=""><font size="1" style="font-size: 9px;">#Mid(_editorMenuAddAction_symbol, 2, 1)#</font></a>'>
		<cfset _theLink = '#_theLink#</td>'>
		<cfset _theLink = '#_theLink#<td>'>
		<cfset _theLink = '#_theLink#<a href="#_editLink#" title="#menuType# Edit - Edit this #_itemOrSubMenu_symbol#." #_a_style#><font size="1" style="font-size: 9px;">#Mid(_editorMenuEditAction_symbol, 2, 1)#</font></a>'>
		<cfset _theLink = '#_theLink#</td>'>
		<cfset _theLink = '#_theLink#<td>'>
		<cfif (_itemCount gt 1)>
			<cfif _useJS>
				<cfset jsCode = "moveMenuItemUp(#_itemCount#); return false;">
				<cfset _theLink = '#_theLink#<a href="" title="Move this #_itemOrSubMenu_symbol# up one position." #_a_style# onclick="#jsCode#"><img src="#_reorganizeMenuUpImage_symbol#" border="0"></a>'>
			<cfelse>
				<cfset _theLink = '#_theLink#<a href="#_moveUpLink#" title="Move this #_itemOrSubMenu_symbol# up one position." #_a_style#><img src="#_reorganizeMenuUpImage_symbol#" border="0"></a>'>
			</cfif>
		<cfelse>
			<cfset _theLink = '#_theLink#&nbsp;'>
		</cfif>
		<cfset _theLink = '#_theLink#</td>'>
		<cfset _theLink = '#_theLink#</tr>'>
		<cfset _theLink = '#_theLink#<tr>'>
		<cfset _theLink = '#_theLink#<td>'>
		<cfset _theLink = '#_theLink#<a href="#_dropLink#" title="#menuType# Delete - Delete this #_itemOrSubMenu_symbol#." #_a_style#><font size="1" style="font-size: 9px;">#Mid(_editorMenuDropAction_symbol, 2, 1)#</font></a>'>
		<cfset _theLink = '#_theLink#</td>'>
		<cfset _theLink = '#_theLink#<td>'>
		<cfset _theLink = '#_theLink#<a href="#_containerLink#" title="SubMenu Item Add - Add a SubMenu #_belowOrInside_symbol# this #_itemOrSubMenu_symbol#." #_a_style#><font size="1" style="font-size: 9px;">#Mid(_editorMenuAddSubMenuContainerAction_symbol, 2, 1)#</font></a>'>
		<cfset _theLink = '#_theLink#</td>'>
		<cfset _theLink = '#_theLink#<td>'>
		<cfif (_itemCountMax gt 1) AND (_itemCount neq _itemCountMax)>
			<cfif _useJS>
				<cfset jsCode = "moveMenuItemDn(#_itemCount#); return false;">
				<cfset _theLink = '#_theLink#<a href="" title="Move this #_itemOrSubMenu_symbol# down one position." #_a_style# onclick="#jsCode#"><img src="#_reorganizeMenuDnImage_symbol#" border="0"></a>'>
			<cfelse>
				<cfset _theLink = '#_theLink#<a href="#_moveDnLink#" title="Move this #_itemOrSubMenu_symbol# down one position." #_a_style#><img src="#_reorganizeMenuDnImage_symbol#" border="0"></a>'>
			</cfif>
		<cfelse>
			<cfset _theLink = '#_theLink#&nbsp;'>
		</cfif>
		<cfset _theLink = '#_theLink#</td>'>
		<cfset _theLink = '#_theLink#</tr>'>
		<cfset _theLink = '#_theLink#</table>'>
		<cfset _theLink = '#_theLink#</td>'>
		<cfset _theLink = '#_theLink#<td>'>
		<cfset _theLink = '#_theLink#<font size="1" style="font-size: 9px;">'>
		<cfset _theLink = '#_theLink##menuLink#'>
		<cfset _theLink = '#_theLink#</font>'>
		<cfset _theLink = '#_theLink#</td>'>
		<cfset _theLink = '#_theLink#</tr>'>
		<cfset _theLink = '#_theLink#</table>'>
		
		<cfreturn _theLink>
	</cffunction>
	
	<cffunction name="makeCascadingMenu" access="public" returntype="string">
		<cfargument name="_menuList" type="string" required="yes">
		<cfargument name="_editableFlag" type="boolean" default="false" required="yes">
		<cfargument name="_newPagesFlag" type="boolean" default="false" required="yes">
		<cfargument name="_editorItemUrl" type="string" default="" required="yes">
		<cfargument name="_editorMenuUrl" type="string" default="" required="yes">

		<cfargument name="menuSubMenuURL_symbol" type="string" required="yes">
		<cfargument name="menuSubMenuEndsURL_symbol" type="string" required="yes">

		<cfargument name="_currentPage_symbol" type="string" required="yes">

		<cfargument name="_editorMenuAddAction_symbol" type="string" required="yes">
		<cfargument name="_editorMenuDropAction_symbol" type="string" required="yes">
		<cfargument name="_editorMenuEditAction_symbol" type="string" required="yes">
		<cfargument name="_editorMenuAddSubMenuAction_symbol" type="string" required="yes">
		<cfargument name="_editorMenuAddSubMenuContainerAction_symbol" type="string" required="yes">
		
		<cfargument name="_menuTableEditorAction_symbol" type="string" required="yes">

		<cfargument name="_menuSubMenuURL_symbol" type="string" required="yes">
		
		<cfargument name="_urlParms" type="string" required="yes">

		<cfargument name="_reorganizeMenuUpAction_symbol" type="string" required="yes">
		<cfargument name="_reorganizeMenuUpImage_symbol" type="string" required="yes">
		<cfargument name="_reorganizeMenuDnAction_symbol" type="string" required="yes">
		<cfargument name="_reorganizeMenuDnImage_symbol" type="string" required="yes">
		<cfargument name="_reorganizeSubMenuUpAction_symbol" type="string" required="yes">
		<cfargument name="_reorganizeSubMenuDnAction_symbol" type="string" required="yes">

		<cfset Cr = Chr(13)>

		<cfset _below_symbol = "below">
		<cfset _inside_symbol = "inside">

		<cfset _item_symbol = "menu item">
		<cfset _submenu_symbol = "submenu item">
		
		<cfset _theMenu = "">
		
		<cfif 0>
			<cfset _editableFlag = "False">
		</cfif>

		<cfset _theMenu = '#_theMenu#<ul id="nav" class="cascadingMenu">'>
		<cfif (_editableFlag OR _newPagesFlag)>
			<cfif (ListLen(_editorItemUrl, "|") gt 1)>
				<cfloop index="_anItem" list="#_editorItemUrl#" delimiters="|">
					<cfset _theMenu = '#_theMenu#<li>#_anItem#</li>'>
				</cfloop>
			<cfelseif (Len(_editorItemUrl) gt 0)>
				<cfset _theMenu = '#_theMenu#<li>#_editorItemUrl#</li>'>
			</cfif>
		</cfif>
		<cfset _itemCount = 1>
		<cfset _itemCountMax = ListLen(_menuList, ",")>
		<cfloop index="_anItem" list="#_menuList#" delimiters=",">
			<cfset _url = Trim(GetToken(_anItem, 1, "|"))>
			<cfset _target = Trim(GetToken(_anItem, 2, "|"))>
			<cfset _prompt = Trim(GetToken(_anItem, 3, "|"))>

			<cfif Len(_prompt) eq 0>
				<cfset _prompt = ".">
			</cfif>

			<cfset _eof = "false">
			<cfif _itemCount eq _itemCountMax>
				<cfset _eof = "true">
			</cfif>

			<cfif (Len(_prompt) gt 0)> <!--- (Len(_url) gt 0) AND  --->
				<cfset _lastOne = "">
				<cfif _eof> <!---  AND (NOT _editableFlag) --->
					<cfset _lastOne = ' class="lastone"'>
				</cfif>

				<cfset _urlParms3 = "&_itemIndex=#_itemCount#&_itemIndexMax=#_itemCountMax#&_redir=x">
				<cfset _urlParms2a = "&_prompt=#URLEncodedFormat(_prompt)#&_target=#URLEncodedFormat(_target)#&_url=#URLEncodedFormat(_url)#">
				<cfset _urlParms2e = "&_prompt=&_target=&_url=">
				<cfset _urlParms2c = "&_prompt=&_target=&_url=#URLEncodedFormat(_menuSubMenuURL_symbol)#">

				<!--- BEGIN: Determine if this is an open/close submenu action --->
				<cfif (_url eq Trim(menuSubMenuURL_symbol))>
					<cfset _menuLink = '<a href="#_url#"'>
					<cfset _menuLink = '#_menuLink#>#_prompt#</a>'>
					<cfset _theLink = _menuLink>
					<cfif _editableFlag>
						<cfset _object = "submenu container">
						<cfset _objectParms = "&_object=#URLEncodedFormat(_object)#">
						<cfset _editorURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_editorMenuEditAction_symbol#", "#_urlParms##_urlParms2a##_urlParms3##_objectParms#")>
						<cfset _additorURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_editorMenuAddAction_symbol#", "#_urlParms##_urlParms2e##_urlParms3##_objectParms#")>
						<cfset _dropperURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_editorMenuDropAction_symbol#", "#_urlParms##_urlParms2e##_urlParms3##_objectParms#")>
						<cfset _addSubMenuURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_editorMenuAddSubMenuAction_symbol#", "#_urlParms##_urlParms2c##_urlParms3##_objectParms#")>
						<cfset _moveSubMenuUpURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_reorganizeSubMenuUpAction_symbol#", "#_urlParms##_urlParms2c##_urlParms3##_objectParms#")>
						<cfset _moveSubMenuDnURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_reorganizeSubMenuDnAction_symbol#", "#_urlParms##_urlParms2c##_urlParms3##_objectParms#")>
						<cfset _theLink = makeMenuItemControlPanel( _menuLink, "SubMenu Item", _editorMenuAddAction_symbol, _additorURL, _editorMenuDropAction_symbol, _dropperURL, _editorMenuEditAction_symbol, _editorURL, _editorMenuAddSubMenuAction_symbol, _editorMenuAddSubMenuContainerAction_symbol, _addSubMenuURL, _inside_symbol, _submenu_symbol, _itemCount, _itemCountMax, _reorganizeMenuUpImage_symbol, _reorganizeMenuDnImage_symbol, _moveSubMenuUpURL, _moveSubMenuDnURL)>
					</cfif>
					<cfset _theLink = '#_theLink#<ul>'>
					<cfset _theMenu = '#_theMenu#<li#_lastOne#>#_theLink#'>
				<cfelseif (_url eq Trim(menuSubMenuEndsURL_symbol))>
					<cfset _theLink = '</ul>#Cr#</li>#Cr#'>
					<cfset _theMenu = '#_theMenu##_theLink#'>
				<cfelse>
					<cfif 0>
						<cfset _docIcon = "&para;&nbsp;">
					<cfelseif 0>
						<cfset _docIcon = '<img src="../images/folderclosed.gif" alt="Link to an External Document" width="9" height="8" border="0">&nbsp;'>
					<cfelseif 0>
						<cfset _docIcon = '<img src="../images/note.gif" alt="Link to an External Document" width="9" height="11" border="0">&nbsp;'>
					</cfif>
					<cfset _curPage = getCurrentPageFromURL( _url, _currentPage_symbol)>
					<cfif Len(_curPage) gt 0>
						<cfset _docIcon = "">
						<cfset baseURL = _url>
						<cfset parmsURL = "">
						<cfif ListLen(_url, "?") eq 2>
							<cfset baseURL = "#CGI.SCRIPT_NAME#?">
							<cfset parmsURL = GetToken(_url, 2, "?")>
							<cfset parmsL = GetToken(parmsURL, 1, "=")>
							<cfset parmsR = GetToken(parmsURL, 2, "=")>
							<cfset parmsR = Replace(parmsR, "'", "''", "all")>
							<cfset parmsURL = "#parmsL#=#URLEncodedFormat(parmsR)##Request.next_splashscreen_inhibitor#">
						</cfif>
						<cfset _url = "#baseURL##parmsURL#">
					<cfelse>
						<!--- BEGIN: Determine if this is a Panagons link or another external link --->
						<cfif (FindNoCase("http://panagons", _url) gt 0)>
							<cfset _docIcon = '<img src="../images/note.gif" alt="Link to an Panagons Document" width="10" border="0">&nbsp;'>
						<cfelse>
							<cfset _docIcon = '<img src="../images/folderclosed.gif" alt="Link to an External Document" width="10" border="0">&nbsp;'>
						</cfif>
						<!--- END! Determine if this is a Panagons link or another external link --->
					</cfif>
					<cfset _menuLink = '<a href="#_url#"'>
					<cfif Len(_target) gt 0>
						<cfset _menuLink = '#_menuLink# target="#_target#"'>
					</cfif>
					<cfset _menuLink = '#_menuLink#>#_docIcon##_prompt#</a>'>
					<cfset _theLink = _menuLink>
					<cfif _editableFlag>
						<cfset _object = "menuitem">
						<cfset _objectParms = "&_object=#URLEncodedFormat(_object)#">
						<cfset _editorURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_editorMenuEditAction_symbol#", "#_urlParms##_urlParms2a##_urlParms3##_objectParms#")>
						<cfset _additorURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_editorMenuAddAction_symbol#", "#_urlParms##_urlParms2e##_urlParms3##_objectParms#")>
						<cfset _dropperURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_editorMenuDropAction_symbol#", "#_urlParms##_urlParms2e##_urlParms3##_objectParms#")>
						<cfset _addSubMenuURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_editorMenuAddSubMenuAction_symbol#", "#_urlParms##_urlParms2c##_urlParms3##_objectParms#")>
						<cfset _moveMenuItemUpURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_reorganizeMenuUpAction_symbol#", "#_urlParms##_urlParms2c##_urlParms3##_objectParms#")>
						<cfset _moveMenuItemDnURL = makeSiteUrl( "#_menuTableEditorAction_symbol#@#_reorganizeMenuDnAction_symbol#", "#_urlParms##_urlParms2c##_urlParms3##_objectParms#")>
						<cfset _theLink = makeMenuItemControlPanel( _menuLink, "Menu Item", _editorMenuAddAction_symbol, _additorURL, _editorMenuDropAction_symbol, _dropperURL, _editorMenuEditAction_symbol, _editorURL, _editorMenuAddSubMenuAction_symbol, _editorMenuAddSubMenuContainerAction_symbol, _addSubMenuURL, _below_symbol, _item_symbol, _itemCount, _itemCountMax, _reorganizeMenuUpImage_symbol, _reorganizeMenuDnImage_symbol, _moveMenuItemUpURL, _moveMenuItemDnURL)>
					</cfif>
					<cfset _theMenu = '#_theMenu#<li#_lastOne#>#_theLink#</li>#Cr#'>
				</cfif>
				<!--- END! Determine if this is an open/close submenu action --->
			</cfif>
			<cfset _itemCount = IncrementValue(_itemCount)>
		</cfloop>
		<cfset _theMenu = '#_theMenu#</ul>#Cr#'>
		
		<cfreturn _theMenu>
	</cffunction>

	<cffunction name="execQofQ" access="public" returntype="string">
		<cfargument name="_qnum_" required="yes" type="string">

		<cfif (_qnum_ eq 1)>
			<CFQUERY dbtype="query" name="GetReleaseData">
				SELECT DISTINCT id, releaseNumber, uid, devDateTime, prodDateTime, archDateTime, stageDateTime, dateTime
				FROM GetReleaseData0
			</cfquery>
		<cfelseif (_qnum_ eq 2)>
			<CFQUERY dbtype="query" name="GetLatestStagedRelease">
				SELECT DISTINCT id, releaseNumber, uid, devDateTime, prodDateTime, archDateTime, stageDateTime
				FROM GetReleaseData0
				WHERE (stageDateTime IS NOT NULL)
				ORDER BY stageDateTime DESC
			</cfquery>
		</cfif>
		
		<cfreturn "True">
	</cffunction>

	<cffunction name="_execQofQ" access="public" returntype="query">
		<cfargument name="_qryName" required="yes" type="string">
		<cfargument name="_SQL_" required="yes" type="string">

		<CFQUERY dbtype="query" name="#_qryName#">
			#PreserveSingleQuotes(_SQL_)#
		</cfquery>

		<cfreturn Evaluate(_qryName)>
	</cffunction>

	<cffunction name="safelyExecQofQ" access="public" returntype="query" output="No">
		<cfargument name="_qryName" required="yes" type="string">
		<cfargument name="_SQL_" required="yes" type="string">
		<cfargument name="_Q_" type="query">
		<cfargument name="_Qname_" type="string" default="">

		<cfscript>
			i = -1;
			if (Len(Trim(_Qname_)) gt 0) {
				SetVariable(_Qname_, _Q_); // make sure the query variable exists within the scope of this .cfc - this was a hack but it seemed to work at the cost of an extra variable - should have used the Request scope...
			}
			try {
				q = _execQofQ(_qryName, _SQL_);
			} catch(Database e) {
				q = QueryNew('status');
				i = QueryAddRow(q);
				i = QuerySetCell(q, "status", -(Evaluate(e.NativeErrorCode)));
			}
		</cfscript>
		
		<cfreturn q>
	</cffunction>

	<cffunction name="execSQL" access="public" returntype="query">
		<cfargument name="_DSNUser" required="yes" type="string">
		<cfargument name="_DSNPassword" required="yes" type="string">
		<cfargument name="_DSNSource" required="yes" type="string">
		<cfargument name="_SQL_" required="yes" type="string">
		<cfargument name="_cachedwithin_" type="string">

		<cfif ( (IsDefined("_cachedwithin_")) AND (Len(Trim(_cachedwithin_)) gt 0) )>
			<CFQUERY username='#_DSNUser#' password='#_DSNPassword#' name="tempQUERY" datasource="#_DSNSource#" cachedwithin="#_cachedwithin_#">
				#PreserveSingleQuotes(_SQL_)#
			</cfquery>
		<cfelse>
			<CFQUERY username='#_DSNUser#' password='#_DSNPassword#' name="tempQUERY" datasource="#_DSNSource#">
				#PreserveSingleQuotes(_SQL_)#
			</cfquery>
		</cfif>
		
		<cfset q = QueryNew("none")>
		<cfif (IsDefined("tempQUERY"))>
			<cfset _q = Evaluate("tempQUERY")>
			<cfif (IsQuery(_q))>
				<cfset q = _q>
			</cfif>
		</cfif>
		<cfreturn q>
	</cffunction>

	<cffunction name="safelyExecSQL" access="public" returntype="query" output="No">
		<cfargument name="_DSNUser" required="yes" type="string">
		<cfargument name="_DSNPassword" required="yes" type="string">
		<cfargument name="_DSNSource" required="yes" type="string">
		<cfargument name="_SQL_" required="yes" type="string">
		<cfargument name="_cachedwithin_" type="string">

		<cfscript>
			i = -1;
			cr = '<br>';
			err1 = 'Violation of PRIMARY KEY';
			err2 = 'Cannot insert';
			err3 = 'duplicate key';

			try {
				if ( (IsDefined("_cachedwithin_")) AND (Len(Trim(_cachedwithin_)) gt 0) ) {
					q = execSQL(_DSNUser, _DSNPassword, _DSNSource, _SQL_, _cachedwithin_);
				} else {
					q = execSQL(_DSNUser, _DSNPassword, _DSNSource, _SQL_);
				}
				if ( (NOT IsDefined("q")) OR (NOT IsQuery(q)) ) {
					q = QueryNew('status');
					i = QueryAddRow(q);
				} else if (q.recordCount gt 0) {
					if (ListFindNoCase(q.columnList, 'status', ',') eq 0) {
						anArray = ArrayNew(1);
						anArray[1] = 0;
						QueryAddColumn(q, 'status', anArray);
					} else {
						QuerySetCell(q, "status", 0);
					}
				}
			} catch(Database e) {
				q = QueryNew('status, reason');
				i = QueryAddRow(q);
				_status = -1;
				if (IsDefined("e.queryError")) {
					if ( (FindNoCase(err1, e.queryError) gt 0) AND (FindNoCase(err2, e.queryError) gt 0) AND (FindNoCase(err3, e.queryError) gt 0) ) {
						if (IsDefined("e.NativeErrorCode")) {
							_status = -(Evaluate(e.NativeErrorCode));
						}
					}
				}
				QuerySetCell(q, "status", _status);
				QuerySetCell(q, "reason", dbError(e));
			}
		</cfscript>
		
		<cfreturn q>
	</cffunction>

	<cffunction name="sqlVerifyDbSpace" access="public" returntype="string">
		<cfargument name="_DSNUser" required="yes" type="string">
		<cfargument name="_DSNPassword" required="yes" type="string">
		<cfargument name="_DSNSource" required="yes" type="string">
		<cfargument name="_maxDbSize_mb_" type="string" default="100">

		<cfscript>
			const_KB_symbol = " KB";
			const_MB_symbol = " MB";
			const_GB_symbol = " GB";
			const_data_symbol = "data";
			
			err_VerifyDbParms = false;
			try {
				VerifyDbParms = sqlVerifyDbParms(_DSNUser, _DSNPassword, _DSNSource);
			} catch(Database e) {
				err_VerifyDbParms = true;
			}
			
			_maxDbSize_mb = _maxDbSize_mb_;       // assume the Db can be this size maximum (100 MB)...
			_actualSize_percent = 100; // assume the Db is full in case there is an error...
		</cfscript>
		
		<cfif ( (err_VerifyDbParms eq false) AND (IsDefined("VerifyDbParms")) AND (IsDefined("VerifyDbParms.size")) AND (IsDefined("VerifyDbParms.usage")) )>
			<cfset _sizeTotal = 0>
			<cfloop query="VerifyDbParms" startrow="1" endrow="#VerifyDbParms.recordCount#">
				<cfif (FindNoCase(const_data_symbol, VerifyDbParms.usage) gt 0)>
					<cfset _units = 1>
					<cfif (FindNoCase(const_KB_symbol, VerifyDbParms.size) gt 0)>
						<cfset _units = 1000>
					<cfelseif (FindNoCase(const_MB_symbol, VerifyDbParms.size) gt 0)>
						<cfset _units = 1>
					<cfelseif (FindNoCase(const_GB_symbol, VerifyDbParms.size) gt 0)>
						<cfset _units = 0.001>
					</cfif>
					<cfset _sizeTotal = _sizeTotal + (Int(GetToken(VerifyDbParms.size, 1, " ")) / _units)>
				</cfif>
			</cfloop>
			<cfset _actualSize_percent = (_sizeTotal / _maxDbSize_mb) * 100.0>  <!--- Ceiling() --->
		</cfif>
		
		<cfreturn DecimalFormat(_actualSize_percent)>
	</cffunction>

	<cffunction name="sqlVerifyDbParms" access="public" returntype="query">
		<cfargument name="_DSNUser" required="yes" type="string">
		<cfargument name="_DSNPassword" required="yes" type="string">
		<cfargument name="_DSNSource" required="yes" type="string">

		<!--- BEGIN: Query the System Tables --->
		<CFQUERY username='#_DSNUser#' password='#_DSNPassword#' name="VerifyDbParms" datasource="#_DSNSource#">
			EXEC sp_helpfile
		</cfquery>
		<!--- END! Query the System Tables --->
		
		<cfreturn VerifyDbParms>
	</cffunction>

	<cffunction name="sqlVerifyUserSecurity" access="public" returntype="query">
		<cfargument name="s_AUTH_USER" required="yes" type="string">
		<cfargument name="s_subsysName" required="yes" type="string">
		<cfargument name="_DSNUser" required="yes" type="string">
		<cfargument name="_DSNPassword" required="yes" type="string">
		<cfargument name="_DSNSource" required="yes" type="string">
		<cfargument name="t_UserSecurity" required="yes" type="string">
		<cfargument name="t_SubsystemList" required="yes" type="string">
		<cfargument name="t_SubsystemSecurity" required="yes" type="string">

		<!--- BEGIN: Query the Security Tables --->
		<CFQUERY username='#_DSNUser#' password='#_DSNPassword#' name="VerifyUserSecurity" datasource="#_DSNSource#" cachedwithin="#CreateTimeSpan(0, 0, 0, 10)#">
			DECLARE @theUserId as varchar(8000);
			SELECT @theUserId = (SELECT TOP 1 userid FROM #t_UserSecurity# WHERE (userid = '#s_AUTH_USER#'));
			
			DECLARE @_count as int;
			SELECT @_count = (
				SELECT count(#t_UserSecurity#.userid) as recCount
				FROM #t_SubsystemList# INNER JOIN
				    #t_SubsystemSecurity# ON 
				    #t_SubsystemList#.id = #t_SubsystemSecurity#.sid INNER JOIN
				    #t_UserSecurity# ON 
				    #t_SubsystemSecurity#.uid = #t_UserSecurity#.id
				WHERE (UPPER(#t_SubsystemList#.subsystem_name) = UPPER('#s_subsysName#'))
			);
			
			IF @_count = 0
				SELECT NULL as sid, NULL as uid, @theUserId as userid, NULL as user_name, NULL as user_phone
			ELSE
				SELECT #t_SubsystemSecurity#.sid, #t_SubsystemSecurity#.uid, 
				    #t_UserSecurity#.userid, #t_UserSecurity#.user_name, 
				    #t_UserSecurity#.user_phone
				FROM #t_SubsystemList# INNER JOIN
				    #t_SubsystemSecurity# ON 
				    #t_SubsystemList#.id = #t_SubsystemSecurity#.sid INNER JOIN
				    #t_UserSecurity# ON 
				    #t_SubsystemSecurity#.uid = #t_UserSecurity#.id
				WHERE (UPPER(#t_SubsystemList#.subsystem_name) = UPPER('#s_subsysName#'))
		</cfquery>
		<!--- END! Query the Security Tables --->
		
		<cfreturn VerifyUserSecurity>
	</cffunction>

	<cffunction name="announcementScrollerMarquee" access="public" returntype="string">
		<cfargument name="_images_folder" required="yes" type="string">
		<cfargument name="_height" required="yes" type="string">
		<cfargument name="_width" required="yes" type="string">
		<cfargument name="_scrollerHeadlines" required="yes" type="string">
		<cfargument name="_scrollerContent" required="yes" type="string">

		<cfset CR = CHR(13)>
		<cfset TAB = CHR(9)>
		<cfset LF = CHR(10)>

		<cfset _state = "_OPEN">
		
		<cfset _sh = ReplaceList(_scrollerHeadlines, "#CR#,#LF#,#TAB#", ",,")>
		<cfset _sc = ReplaceList(_scrollerContent, "#CR#,#LF#,#TAB#", ",,")>
		
		<cfset _sh = "'#_sh#'">
		<cfset _sc = "'#_sc#'">

		<cfset _corner_width = 0>

		<cfset _top_left_src = '<img src="#_images_folder#t_AnnouncementBox_Top_left.gif">'>
		<cfset _top_center_src = '<img src="#_images_folder#t_AnnouncementBox_Top_center.gif">'>
		<cfset _top_right_src = '<img src="#_images_folder#t_AnnouncementBox_Top_right.gif">'>

		<cfset _bottom_left_src = '<img src="#_images_folder#t_AnnouncementBox_Bottom_left.gif">'>
		<cfset _bottom_right_src = '<img src="#_images_folder#t_AnnouncementBox_Bottom_right.gif">'>

		<cfset _top_left_src = "&nbsp;">
		<cfset _top_right_src = "&nbsp;">

		<cfset _bottom_left_src = "&nbsp;">
		<cfset _bottom_right_src = "&nbsp;">

		<cfsavecontent variable="_html">
			<cfoutput>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					var ms_original_height = -1;
					var ms_headlines = #_sh#;
					var ms_content = #_sc#;
				-->
				</script>
	
				<table border="0" cellspacing="-1" cellpadding="1" align="center">
					<tr>
						<td align="CENTER">
							<table border="0" cellspacing="-1" cellpadding="-1">
								<tr>
									<td>
										<small><b>Announcements</b></small>
									</td>
									<td width="10px">
										&nbsp;
									</td>
									<td>
										<img #setup_tooltip_handlers("img_AnnouncementBox_Bottom_right")# src="#_images_folder#t_AnnouncementBox_Bottom_right#_state#.gif" title="Click this button to open or close the Marquee Announcements to see the full text for each Announcement or to see just the Headlines when closed." onclick="performScrollerOpenClose(); return false;" onmouseover="this.style.cursor=const_cursor_hand;" onmouseout="this.style.cursor=const_cursor_default;">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="center" style="background-color: white;">
	
							<table border="1" cellspacing="-1" cellpadding="1" align="center">
								<tr>
									<td>
										<div id="sepg_section_marquee_scroller">
											<marquee truespeed id="marquee_scroller" height="#_height#" width="#_width#" direction="up" scrolldelay="50" scrollamount="1" onmouseover="this.stop()" onmouseout="this.start()" style="font-family:Verdana;font-size:10px">
												#_scrollerHeadlines#
											</marquee>
										</div>
									</td>
								</tr>
							</table>
						
						</td>
					</tr>
				</table>
			</cfoutput>
		</cfsavecontent>
			
		<cfreturn _html>
	</cffunction>

	<cffunction name="wysiwygEditor_pane" access="public" returntype="string">
		<cfargument name="_pane_name" required="yes" type="string">

		<cfsavecontent variable="_html">
			<cfoutput>
				<div id="wysiwygEditor_previewpane_#_pane_name#" style="display: none;">
				</div>
				<div id="wysiwygEditor_pane_#_pane_name#" style="display: none;">
					<textarea name="#_pane_name#Content" id="#_pane_name#Content" style="width:500px; height:40px">
					</textarea>
		
					<script language="javascript1.2">
					var config = new Object();    // create new config object
					
					config.width = "500px";
					config.height = "40px";
					config.bodyStyle = "background-color: white; font-family: Verdana; font-size: x-small;";
					config.debug = 0;
					
					// NOTE:  You can remove any of these blocks and use the default config!
					
					config.toolbar = [
					    ["fontname"],
					    ["fontsize"],
					    ["linebreak"],
					    ["bold","italic","underline","separator"],
						["strikethrough","subscript","superscript","separator"],
					    ["justifyleft","justifycenter","justifyright","separator"],
					    ["OrderedList","UnOrderedList","Outdent","Indent","separator"],
					    ["forecolor","backcolor","separator"],
					    ["HorizontalRule","Createlink","InsertImage","htmlmode","separator"],
					    ["popupeditor"]
					];
					
					config.fontnames = {
					    "Arial":           "arial, helvetica, sans-serif",
					    "Courier New":     "courier new, courier, mono",
					    "Georgia":         "Georgia, Times New Roman, Times, Serif",
					    "Tahoma":          "Tahoma, Arial, Helvetica, sans-serif",
					    "Times New Roman": "times new roman, times, serif",
					    "Verdana":         "Verdana, Arial, Helvetica, sans-serif",
					    "impact":          "impact",
					    "WingDings":       "WingDings"
					};
					config.fontsizes = {
					    "1 (8 pt)":  "1",
					    "2 (10 pt)": "2",
					    "3 (12 pt)": "3",
					    "4 (14 pt)": "4",
					    "5 (18 pt)": "5",
					    "6 (24 pt)": "6",
					    "7 (36 pt)": "7"
					  };
					
					config.fontstyles = [   // make sure classNames are defined in the page the content is being display as well in or they wont work!
					];
					
					editor_generate("#_pane_name#Content",config);
					</script>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn _html>
	</cffunction>

	<cffunction name="wysiwygDate_pane" access="public" returntype="string">
		<cfargument name="_pane_name" required="yes" type="string">
		<cfargument name="_textarea_style_symbol" required="yes" type="string">

		<cfsavecontent variable="_html">
			<cfoutput>
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td align="left" valign="top">
							<input type="text" name="#_pane_name#Container" id="#_pane_name#Container" title="Click the ... button to open the Calendar Editor for the #_pane_name#." size="16" maxlength="24" readonly #_textarea_style_symbol#>
						</td>
						<td align="left" valign="top">
							<input type="button" id="#_pane_name#_openeditor_button" title="Open the Calendar Editor for the #_pane_name#." value="..." onclick="openWYSIWYG_htmlEditor(''#_pane_name#''); return false;">
							<div id="wysiwygEditor_previewpane_#_pane_name#" style="display: none;">
							</div>
						</td>
					</tr>
					<tr>
						<td align="left" valign="top" colspan="2">
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td valign="top">
										<div id="wysiwygEditor_pane_#_pane_name#" style="display: none; font-size: 9px;">
										</div>
									</td>
									<td valign="top">
										<table width="300px" cellpadding="-1" cellspacing="-1">
											<tr>
												<td bgcolor="##FFFFBB" valign="top">
													<div id="wysiwygEditorInvalid_pane_#_pane_name#" style="display: none;">
														<h6 align="justify"><font color="##ff0000">End Date is invalid, the most common reason for this is that the end date falls on or before the beginning date. Please adjust your ending date to correct this problem.</font></h6>
													</div>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
				
				showFlatCalendar("#_pane_name#");
				-->
				</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn _html>
	</cffunction>

	<cffunction name="marqueeBrowser_pane" access="public" returntype="string">
		<cfargument name="_qry_" type="query" required="yes">

		<cfscript>
			_html = '';
			js_html = '';
			_style = '';
			_recsPerPage = 5; // DO NOT CHANGE THIS OR BAD EVIL THINGS MAY HAPPEN...
			_startrow = 1;
			_endrow = -1;
			_s = '';
			_sn = '';
			_guiId = '';
			js_guiId = '';
			_recid = -1;
			_fmt = '';
			t_fmt = 'mm-dd-yyyy HH:mm';
			_bgColor = '##FFFFBB';
			_ii = 1;
			_pages = 1;
			_iTerm = '';
			js_iTerm = '';
			_Cr_ = Chr(13) & Chr(10);
			_Cr = _Cr_;
			_guiId_ = 'marqueeBrowser_panel';  // DO NOT CHANGE THIS OR BAD EVIL THINGS MAY HAPPEN...
			
			_useJavaScript_variables = true;

			const_inline_style = 'inline';
			const_none_style = 'none';
		</cfscript>

		<cfset _numRecs = _qry_.recordCount>
		<cfset _numMarqeePages = Int(_numRecs / _recsPerPage)>
		<cfif ((_numRecs MOD _recsPerPage) gt 0)>
			<cfset _numMarqeePages = IncrementValue(_numMarqeePages)>
		</cfif>
		<cfif (_numMarqeePages eq 0)>
			<cfset _numMarqeePages = 1>
		</cfif>
		<cfset _endrow = (_startrow + Min(_numRecs, _recsPerPage)) - 1>
		<cfloop index="_i" from="1" to="#_numMarqeePages#">
			<cfscript>
				if ( (_startrow lte _qry_.recordCount) OR (_qry_.recordCount eq 0) ) {
					_style = 'display: ';
					if (_i eq 1) {
						_style = _style & const_inline_style;
					} else {
						_style = _style & const_none_style; // make this 'none' later on to hide all but the first panel...
					}
					_style = _style & ';';
					_html = _html & '<div id="marqueeBrowser_panel' & '#_i#' & '" style="' & _style & '">' & _Cr_;

//					_html = _html & '[#_i#] [#_numMarqeePages#] [#_numRecs#] [#_recsPerPage#] [#(_numRecs MOD _recsPerPage)#]<br>' & _Cr;

					_html = _html & '<table width="100%" border="1" cellpadding="-1" cellspacing="-1">' & _Cr;

					_html = _html & '<tr bgcolor="silver">' & _Cr;
					_html = _html & '<td colspan="6">' & _Cr;

					if (1) {
						_html = _html & '<table width="100%" border="1" cellpadding="-1" cellspacing="-1">' & _Cr;
						_html = _html & '<tr>' & _Cr;
	
						_sn = '_begin_button';
						_s = "'#_sn#'";
	
						_iTerm = '#_i#';
						js_iTerm = "'#_iTerm#'";
						
						_guiId = _guiId_ & '#_i#' & _sn;
						js_guiId = "'#_guiId#'";

						_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#_i#, #_s#); return false;"';
						
						_html = _html & '<td width="5%" align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
						_html = _html & '<input type="button" id="#_guiId#" value="[|<]" style="font-size: 12px;" title="Navigate to the First Page" onclick="performClickedMarqueeBeginButton(#_i#, #_s#, #_i#); return false;">' & _Cr;
						_html = _html & '</td>' & _Cr;
	
						js_html = js_html & 'registerGUIid(#js_guiId#, #_i#);' & _Cr_;
	
						_sn = '_fprev_button';
						_s = "'#_sn#'";
	
						_guiId = _guiId_ & '#_i#' & _sn;
						js_guiId = "'#_guiId#'";
	
						_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#_i#, #_s#); return false;"';
						
						_html = _html & '<td width="5%" align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
						_html = _html & '<input type="button" id="#_guiId#" value="[<<]" style="font-size: 12px;" title="Navigate Left Two Pages (if applicable)" onclick="performClickedMarqueeFastPrevButton(#_i#, #_s#, #_i#); return false;">' & _Cr;
						_html = _html & '</td>' & _Cr;
	
						js_html = js_html & 'registerGUIid(#js_guiId#, #_i#);' & _Cr_;
	
						_sn = '_prev_button';
						_s = "'#_sn#'";
	
						_guiId = _guiId_ & '#_i#' & _sn;
						js_guiId = "'#_guiId#'";
	
						_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#_i#, #_s#); return false;"';
						
						_html = _html & '<td width="5%" align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
						_html = _html & '<input type="button" id="#_guiId#" value="[<]" style="font-size: 12px;" title="Navigate Left One Page (if applicable)" onclick="performClickedMarqueePrevButton(#_i#, #_s#, #_i#); return false;">' & _Cr;
						_html = _html & '</td>' & _Cr;
	
						js_html = js_html & 'registerGUIid(#js_guiId#, #_i#);' & _Cr_;
	
						_sn = '_status_pane';
						_guiId = _guiId_ & '#_i#' & _sn;
	
						_html = _html & '<td width="5%" align="center" id="#_guiId#">' & _Cr;
						_html = _html & '';
						_html = _html & '</td>' & _Cr;
	
						_sn = '_next_button';
						_s = "'#_sn#'";
	
						_guiId = _guiId_ & '#_i#' & _sn;
						js_guiId = "'#_guiId#'";
	
						_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#_i#, #_s#); return false;"';
						
						_html = _html & '<td width="5%" align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
						_html = _html & '<input type="button" id="#_guiId#" value="[>]" style="font-size: 12px;" title="Navigate Right One Page (if applicable)" onclick="performClickedMarqueeNextButton(#_i#, #_s#, #_i#); return false;">' & _Cr;
						_html = _html & '</td>' & _Cr;
	
						js_html = js_html & 'registerGUIid(#js_guiId#, #_i#);' & _Cr_;
		
						_sn = '_fnext_button';
						_s = "'#_sn#'";
	
						_guiId = _guiId_ & '#_i#' & _sn;
						js_guiId = "'#_guiId#'";
	
						_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#_i#, #_s#); return false;"';
						
						_html = _html & '<td width="5%" align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
						_html = _html & '<input type="button" id="#_guiId#" value="[>>]" style="font-size: 12px;" title="Navigate Right Two Pages (if applicable)" onclick="performClickedMarqueeFastNextButton(#_i#, #_s#, #_i#); return false;">' & _Cr;
						_html = _html & '</td>' & _Cr;
	
						js_html = js_html & 'registerGUIid(#js_guiId#, #_i#);' & _Cr_;
		
						_sn = '_end_button';
						_s = "'#_sn#'";
	
						_guiId = _guiId_ & '#_i#' & _sn;
						js_guiId = "'#_guiId#'";
	
						_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#_i#, #_s#); return false;"';
						
						_html = _html & '<td width="5%" align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
						_html = _html & '<input type="button" id="#_guiId#" value="[>|]" style="font-size: 12px;" title="Navigate to the Last Page" onclick="performClickedMarqueeEndButton(#_i#, #_s#, #_i#); return false;">' & _Cr;
						_html = _html & '</td>' & _Cr;
	
						js_html = js_html & 'registerGUIid(#js_guiId#, #_i#);' & _Cr_;
		
						_html = _html & '</tr>' & _Cr;
						_html = _html & '</table>' & _Cr_;
					}

					_html = _html & '</td>' & _Cr;
					_html = _html & '</tr>' & _Cr;
	
					_html = _html & '<tr bgcolor="silver">' & _Cr;

					_sn = '_add_button';
					_s = "'#_sn#'";
	
					_guiId = _guiId_ & '#_i#' & _sn;
					js_guiId = "'#_guiId#'";
	
					_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
					_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#_i#, #_s#); return false;"';
					
					_html = _html & '<td width="5%" align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
					_html = _html & '<input type="button" id="#_guiId#" value="[+]" style="font-size: 12px;" title="Click to Open the form that allows a record to be ADDed to the database." onclick="performClickedMarqueeAddButton(#_i#, #_s#, #_i#); return false;">' & _Cr;
					_html = _html & '</td>' & _Cr;
	
					js_html = js_html & 'registerGUIid(#js_guiId#, #_i#);' & _Cr_;
	
					_html = _html & '<td width="15%" align="center">' & _Cr;
					_html = _html & '<small><b>Headline</b></small>' & _Cr;
					_html = _html & '</td>' & _Cr;
	
					_html = _html & '<td width="40%" align="center">' & _Cr;
					_html = _html & '<small><b>Article</b></small>' & _Cr;
					_html = _html & '</td>' & _Cr;
	
					_html = _html & '<td width="20%" align="center">' & _Cr;
					_html = _html & '<small><b>Begin Date</b><br>(#t_fmt#)</small>' & _Cr;
					_html = _html & '</td>' & _Cr;
	
					_html = _html & '<td width="20%" align="center">' & _Cr;
					_html = _html & '<small><b>End Date</b><br>(#t_fmt#)</small>' & _Cr;
					_html = _html & '</td>' & _Cr;
	
					_s = "'_close_button'";
	
					_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
					_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#_i#, #_s#); return false;"';
					
					_html = _html & '<td width="5%" align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
					_html = _html & '<input type="button" id="marqueeBrowser_panel' & '#_i#' & '_close_button" value="[x]" title="Click to close this data browser." style="font-size: 10px;" onclick="closeMarqueeBrowserAction(); return false;">' & _Cr;
					_html = _html & '</td>' & _Cr;
	
					_html = _html & '</tr>' & _Cr;
				}
			</cfscript>

			<cfloop query="_qry_" startrow="#_startrow#" endrow="#_endrow#">
				<cfscript>
					_html = _html & '<tr bgcolor="#_bgColor#">' & _Cr;

					_html = _html & '<td width="5%" align="center">' & _Cr_;

					if (1) {
						_html = _html & '<table width="100%" cellpadding="-1" cellspacing="-1">' & _Cr;
						_html = _html & '<tr bgcolor="silver">' & _Cr;
	
						_sn = '_edit_button';
						_s = "'#_sn#'";
	
						_iTerm = '#_i#.#_ii#';
						js_iTerm = "'#_iTerm#'";
						
						_guiId = _guiId_ & _iTerm & _sn;
						js_guiId = "'#_guiId#'";
						
						_recid = _qry_.id;
	
						_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						
						_html = _html & '<td align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
						_html = _html & '<input type="button" id="#_guiId#" value="[*]" style="font-size: 12px;" title="Click to Open the form that allows a record to be EDITed in the database." onclick="performClickedMarqueeEditButton(#_ii#, #js_iTerm#, #_s#, #_recid#, #_i#); return false;">' & _Cr;
						_html = _html & '</td>' & _Cr;
						_html = _html & '</tr>' & _Cr;
						_html = _html & '<tr bgcolor="silver">' & _Cr;
	
						js_html = js_html & 'registerGUIid(#js_guiId#, #_i#);' & _Cr_;
	
						_sn = '_remove_button';
						_s = "'#_sn#'";
	
						_guiId = _guiId_ & _iTerm & _sn;
						js_guiId = "'#_guiId#'";
	
						_onMouseOver = ' onmouseover="handleMouseOver_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						_onMouseOut = ' onmouseout="handleMouseOut_marqueeBrowser_panel(#js_iTerm#, #_s#); return false;"';
						
						_html = _html & '<td align="center"#_onMouseOver##_onMouseOut#>' & _Cr;
						_html = _html & '<input type="button" id="#_guiId#" value="[-]" style="font-size: 12px;" title="Click to Open the form that allows a record to be DELETEd from the database." onclick="performClickedMarqueeRemoveButton(#_ii#, #js_iTerm#, #_s#, #_recid#, #_i#); return false;">' & _Cr;
						_html = _html & '</td>' & _Cr;
						_html = _html & '</tr>' & _Cr;
						_html = _html & '</table>' & _Cr_;
					}

					_html = _html & '</td>' & _Cr;

					js_html = js_html & 'registerGUIid(#js_guiId#, #_i#);' & _Cr_;

					_html = _html & '<td align="left" bgcolor="#_bgColor#">' & _Cr;
					_data = URLEncodedFormat(_qry_.headline);
					if (NOT _useJavaScript_variables) {
						_html = _html & '<input type="hidden" id="marqueeBrowser_panel#_ii#_headline_data" value="#_data#">' & _Cr;
					} else {
						js_data = "'#_data#'";
						js_html = js_html & 'marqueeBrowser_panel#_ii#_headline_data = #js_data#;' & _Cr_;
					}
					_html = _html & _qry_.headline;
					if (Len(Trim(_qry_.headline)) eq 0) {
						_html = _html & '&nbsp;' & _Cr;
					}
					_html = _html & '</td>' & _Cr;

					_html = _html & '<td align="left" bgcolor="#_bgColor#">' & _Cr;
					_data = URLEncodedFormat(_qry_.article_text);
					if (NOT _useJavaScript_variables) {
						_html = _html & '<input type="hidden" id="marqueeBrowser_panel#_ii#_article_data" value="#_data#">' & _Cr;
					} else {
						js_data = "'#_data#'";
						js_html = js_html & 'marqueeBrowser_panel#_ii#_article_data = #js_data#;' & _Cr_;
					}
					_html = _html & _qry_.article_text;
					if (Len(Trim(_qry_.article_text)) eq 0) {
						_html = _html & '&nbsp;' & _Cr;
					}
					_html = _html & '</td>' & _Cr;

					_fmt = DateFormat(_qry_.begin_dt, GetToken(t_fmt, 1, " ")) & ' ' & TimeFormat(_qry_.begin_dt, GetToken(t_fmt, 2, " "));

					_html = _html & '<td align="center" bgcolor="#_bgColor#">' & _Cr;
					_data = URLEncodedFormat(_fmt);
					if (NOT _useJavaScript_variables) {
						_html = _html & '<input type="hidden" id="marqueeBrowser_panel#_ii#_begin_dt_data" value="#_data#">' & _Cr;
					} else {
						js_data = "'#_data#'";
						js_html = js_html & 'marqueeBrowser_panel#_ii#_begin_dt_data = #js_data#;' & _Cr_;
					}
					if (Len(Trim(_qry_.begin_dt)) eq 0) {
						_html = _html & '&nbsp;' & _Cr;
					} else {
						_html = _html & '<font size="1"><small>' & _fmt & '</small></font>' & _Cr;
					}
					_html = _html & '</td>' & _Cr;

					_fmt = DateFormat(_qry_.end_dt, GetToken(t_fmt, 1, " ")) & ' ' & TimeFormat(_qry_.end_dt, GetToken(t_fmt, 2, " "));

					_html = _html & '<td align="center" colspan="2" bgcolor="#_bgColor#">' & _Cr;
					_data = URLEncodedFormat(_fmt);
					if (NOT _useJavaScript_variables) {
						_html = _html & '<input type="hidden" id="marqueeBrowser_panel#_ii#_end_dt_data" value="#_data#">' & _Cr;
					} else {
						js_data = "'#_data#'";
						js_html = js_html & 'marqueeBrowser_panel#_ii#_end_dt_data = #js_data#;' & _Cr_;
					}
					if (Len(Trim(_qry_.end_dt)) eq 0) {
						_html = _html & '&nbsp;' & _Cr;
					} else {
						_html = _html & '<font size="1"><small>' & _fmt & '</small></font>' & _Cr;
					}
					_html = _html & '</td>' & _Cr;

					_html = _html & '</tr>' & _Cr_;

					_ii = _ii + 1;
				</cfscript>
			</cfloop>

			<cfscript>
				_html = _html & '</table>' & _Cr_;
				_html = _html & '</div>' & _Cr_;
				
				_startrow = _startrow + _recsPerPage;
				_endrow = _endrow + _recsPerPage;

				if (_startrow lte _qry_.recordCount) {
					_pages = _pages + 1;
				}
			</cfscript>
		</cfloop>

		<cfscript>
			_js_html = js_html;
			js_html = '<script language="JavaScript1.2" type="text/javascript">' & _Cr_;
			js_html = js_html & '<!--' & _Cr_;
			js_html = js_html & _js_html;
			js_html = js_html & 'max_visible_page_of_headlines = #_pages#;' & _Cr_;
			js_html = js_html & 'refreshMarqueeVCRButtons();' & _Cr_;
			js_html = js_html & 'closeMarqueeBrowserAction();' & _Cr_;
			js_html = js_html & '-->' & _Cr_;
			js_html = js_html & '</script>' & _Cr_;
			_html = _html & js_html;
		</cfscript>

		<cfreturn _html>
	</cffunction>
	
	<cffunction name="_marquee_list" access="public" returntype="string">
		<cfargument name="_qry_" type="query" required="yes">
		<cfargument name="_field_" type="string" required="yes">
		<cfargument name="_images_folder" type="string" required="yes">
		<cfargument name="_img_tag_preamble_symbol" type="string" required="yes">
		<cfargument name="_img_tag_postamble_symbol" type="string" required="yes">
		<cfargument name="_img_tag_src_symbol" type="string" required="yes">
		<cfargument name="_theURLPrefix_symbol" type="string" required="yes">
		<cfargument name="_anchor_tag_preamble_symbol" type="string" required="yes">
		<cfargument name="_anchor_tag_postamble_symbol" type="string" required="yes">
		<cfargument name="_anchor_tag_href_symbol" type="string" required="yes">
		<cfargument name="_ContentPageList" type="string" required="yes">

		<cfscript>
			_html = '';
			v = '';
			begin_dt = '';
			end_dt = '';
			_numRecs = 0;
		</cfscript>

		<cfscript>
			_html = _html & '<UL>';
		</cfscript>

		<cfif (IsDefined("_qry_"))>
			<cfloop query="_qry_" startrow="1" endrow="#_qry_.recordCount#">
				<cfscript>
					// WHERE ( (begin_dt IS NULL) AND (end_dt IS NULL) ) 
					//			OR ( (begin_dt IS NULL) AND (end_dt >= <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_DATE">) ) 
					//			OR ( (begin_dt <= <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_DATE">) AND (end_dt IS NULL) ) 
					//			OR ( (begin_dt <= <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_DATE">) AND (end_dt >= <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_DATE">) )

					if ( ( (Len(Trim(_qry_.begin_dt)) eq 0) AND (Len(Trim(_qry_.end_dt)) eq 0) ) OR ( (Len(Trim(_qry_.begin_dt)) eq 0) AND (DateCompare(_qry_.end_dt, Now()) gte 0) ) OR ( (DateCompare(_qry_.begin_dt, Now()) lte 0) AND (Len(Trim(_qry_.end_dt)) eq 0) ) OR ( (DateCompare(_qry_.begin_dt, Now()) lte 0) AND (DateCompare(_qry_.end_dt, Now()) gte 0) ) ) {
						v = '';
						try {
							v = Evaluate("_qry_.#_field_#");
						} catch(Any e) {
						}
						v = correctHTMLtags( v, _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol);
						v = correctHTMLtags( v, "", _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _theURLPrefix_symbol, _ContentPageList);
						if (Len(Trim(v)) gt 0) {
							_html = _html & '<LI>' & v & '</LI>';
							_numRecs = _numRecs + 1;
						}
					}
				</cfscript>
			</cfloop>
			
			<cfif (_numRecs eq 0)>
				<cfscript>
					_html = _html & '<LI>-- No Data --</LI>';
				</cfscript>
			</cfif>
		<cfelse>
			<cfscript>
				_html = _html & '<LI>-- No Data --</LI>';
			</cfscript>
		</cfif>

		<cfscript>
			_html = _html & '</UL>';
		</cfscript>
		
		<cfreturn _html>
	</cffunction>
	
	<cffunction name="marqueeArticle_list" access="public" returntype="string">
		<cfargument name="_qry_" type="query" required="yes">
		<cfargument name="_images_folder" type="string" required="yes">
		<cfargument name="_img_tag_preamble_symbol" type="string" required="yes">
		<cfargument name="_img_tag_postamble_symbol" type="string" required="yes">
		<cfargument name="_img_tag_src_symbol" type="string" required="yes">
		<cfargument name="_theURLPrefix_symbol" type="string" required="yes">
		<cfargument name="_anchor_tag_preamble_symbol" type="string" required="yes">
		<cfargument name="_anchor_tag_postamble_symbol" type="string" required="yes">
		<cfargument name="_anchor_tag_href_symbol" type="string" required="yes">
		<cfargument name="_ContentPageList" type="string" required="yes">

		<cfscript>
			_html = _marquee_list(_qry_, "article_text", _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol, _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _ContentPageList);
		</cfscript>
		
		<cfreturn _html>
	</cffunction>
	
	<cffunction name="marqueeHeadlines_list" access="public" returntype="string">
		<cfargument name="_qry_" type="query" required="yes">
		<cfargument name="_images_folder" type="string" required="yes">
		<cfargument name="_img_tag_preamble_symbol" type="string" required="yes">
		<cfargument name="_img_tag_postamble_symbol" type="string" required="yes">
		<cfargument name="_img_tag_src_symbol" type="string" required="yes">
		<cfargument name="_theURLPrefix_symbol" type="string" required="yes">
		<cfargument name="_anchor_tag_preamble_symbol" type="string" required="yes">
		<cfargument name="_anchor_tag_postamble_symbol" type="string" required="yes">
		<cfargument name="_anchor_tag_href_symbol" type="string" required="yes">
		<cfargument name="_ContentPageList" type="string" required="yes">

		<cfscript>
			_html = _marquee_list(_qry_, "headline", _images_folder, _img_tag_preamble_symbol, _img_tag_postamble_symbol, _img_tag_src_symbol, _theURLPrefix_symbol, _anchor_tag_preamble_symbol, _anchor_tag_postamble_symbol, _anchor_tag_href_symbol, _ContentPageList);
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="osStyleRadioButtonCaption" access="public" returntype="string">
		<cfargument name="_bool_" type="boolean" default="False" required="yes">
		<cfargument name="_title_" type="string" required="yes">
		<cfargument name="_widget_id_" type="string" required="yes">
		<cfargument name="_caption_" type="string" required="yes">
		<cfargument name="_js_function_" type="string" default="">

		<cfscript>
			if (Len(Trim(_widget_id_)) gt 0) {
				_id_ = "'#_widget_id_#'";
				_id2_ = "#_widget_id_#_href";
			} else {
				_guid = Replace(CreateUUID(), "-", "_", "all");
				_id_ = "'#_guid#'";
				_id2_ = "#_guid#_href";
			}
			_ct_ = "'checkbox'";
			_ct_2 = "'radio'";
			if ( (Len(_js_function_) gt 0) AND (FindNoCase(";", _js_function_) eq 0) ) {
				_js_function_ = _js_function_ & ";";
			} else if (Len(_js_function_) eq 0) {
				_js_function_ = "if (sObj.disabled == false) { sObj.focus(); }";
			}
			_tooltips_ = 'id="#_id2_#"';
			if ( (Len(Trim(_widget_id_)) gt 0) AND (_bool_) ) {
				_tooltips_ = setup_tooltip_handlers(_widget_id_ & "_anchor");
			}
			_html = '<a href="" #_tooltips_# title="#_title_#" onclick="var sObj = document.getElementById(#_id_#); if (sObj != null) { if ( ( (sObj.type.trim().toLowerCase() == #_ct_#) || (sObj.type.trim().toLowerCase() == #_ct_2#) ) && (sObj.disabled == false) ) { sObj.checked = ((sObj.checked == true) ? false : true); } #_js_function_# } return false;">#_caption_#</a>&nbsp;';
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="osStyleRadioButtonCaption2" access="public" returntype="string">
		<cfargument name="_bool_" type="boolean" default="False" required="yes">
		<cfargument name="_title_" type="string" required="yes">
		<cfargument name="_widget_id_" type="string" required="yes">
		<cfargument name="_parked_id_" type="string" required="yes">
		<cfargument name="_caption_" type="string" required="yes">
		<cfargument name="_js_function_" type="string" default="">

		<cfscript>
			if (Len(Trim(_widget_id_)) gt 0) {
				_id_ = "'#_widget_id_#'";
				_id2_ = "#_widget_id_#_href";
			} else {
				_guid = Replace(CreateUUID(), "-", "_", "all");
				_id_ = "'#_guid#'";
				_id2_ = "#_guid#_href";
			}
			_ct_ = "'checkbox'";
			_ct_2 = "'radio'";
			if ( (Len(_js_function_) gt 0) AND (FindNoCase(";", _js_function_) eq 0) ) {
				_js_function_ = _js_function_ & ";";
			} else if (Len(_js_function_) eq 0) {
				_js_function_ = "if (sObj.disabled == false) { sObj.focus(); }";
			}
			_tooltips_ = 'id="#_id2_#"';
			if ( (Len(Trim(_widget_id_)) gt 0) AND (_bool_) ) {
				_tooltips_ = setup_tooltip_handlers2(_widget_id_ & "_anchor", _parked_id_);
			}
			_html = '<a href="" #_tooltips_# title="#_title_#" onclick="var sObj = document.getElementById(#_id_#); if (sObj != null) { if ( ( (sObj.type.trim().toLowerCase() == #_ct_#) || (sObj.type.trim().toLowerCase() == #_ct_2#) ) && (sObj.disabled == false) ) { sObj.checked = ((sObj.checked == true) ? false : true); } #_js_function_# } return false;">#_caption_#</a>';
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="cache_sbcuid_objects" access="public" returntype="string">
		<cfargument name="cache" type="query" required="yes">
		<cfargument name="_key_" type="string" required="yes">
		<cfargument name="_data_" type="string" default="">

		<cfif (Len(Trim(_data_)) eq 0)>
			<cfif (cache.recordCount gt 0)>
				<CFQUERY dbtype="query" name="qrySBCUIDcache">
					SELECT sbcuid, name, phone
					FROM cache
					WHERE (sbcuid = '#_key_#')
				</cfquery>
			</cfif>
	
			<cfscript>
				_val = '';
				if (isDomainSBC()) {
					if ( (IsDefined("qrySBCUIDcache")) AND (qrySBCUIDcache.recordCount gt 0) ) {
						_val = qrySBCUIDcache.name & '@' & qrySBCUIDcache.phone;
					}
				} else {
					_val = '@Web Phone Offline';
				}
			</cfscript>
		<cfelse>
			<cfscript>
				_val = '';
				QueryAddRow(cache, 1);
				rc = cache.recordCount;
				QuerySetCell(cache, "sbcuid", _key_, rc);
				QuerySetCell(cache, "name", GetToken(_data_, 1, "@"), rc);
				QuerySetCell(cache, "phone", GetToken(_data_, 2, "@"), rc);
			</cfscript>
		</cfif>
		
		<cfreturn _val>
	</cffunction>

	<cffunction name="isValidFormattingChar" access="public" returntype="string">
		<cfargument name="_ch_" type="string" required="yes">

		<cfscript>
			allowedChars = 'AN';

			_bool = (FindNoCase(_ch_, allowedChars) gt 0);
		</cfscript>
		
		<cfreturn _bool>
	</cffunction>

	<cffunction name="formatBoiledDown" access="public" returntype="string">
		<cfargument name="_fmt_" type="string" required="yes">

		<cfscript>
			ch = '';
			_fmtB = '';
			i = 1;
			for ( ; i lte Len(_fmt_); i = i + 1) {
				ch = Mid(_fmt_, i, 1);
				if (isValidFormattingChar(ch)) {
					_fmtB = _fmtB & ch;
				}
			}
		</cfscript>
		
		<cfreturn _fmtB>
	</cffunction>

	<cffunction name="formattedPhoneNumber" access="public" returntype="string">
		<cfargument name="_phoneNumber_" type="string" required="yes">
		<cfargument name="_format_" type="string">

		<cfscript>
			ch = '';
			_ch = '';
			_fmtB = '';
			j = 1;
			i = 1;
			_fmtO = _phoneNumber_;
			_fmt_ = '(NNN) NNN-NNNN';
			if ( (IsDefined("_format_")) AND (Len(Trim(_format_)) gt 0) ) {
				_fmt_ = _format_;
			}
			_fmtB = formatBoiledDown(_fmt_);
			if (Len(_phoneNumber_) eq Len(_fmtB)) {
				_fmtO = '';
				j = 1;
				for (i = 1 ; i lte Len(_fmt_); i = i + 1) {
					ch = Mid(_fmt_, i, 1);
					if (isValidFormattingChar(ch)) {
						_ch = Mid(_phoneNumber_, j, 1);
						_fmtO = _fmtO & _ch;
						j = j + 1;
					} else {
						_fmtO = _fmtO & ch;
					}
				}
			}
		</cfscript>

		
		<cfreturn _fmtO>
	</cffunction>

	<cffunction name="register_onload_function" access="public" returntype="string">
		<cfargument name="_onload_" type="string" required="yes">

		<cfscript>
			_html = '';
			_Cr = Chr(13);
			_all = 'all';
			_tick = "'";
			_tick2 = '"';
			_js_parm = "'#Replace(_onload_, _tick, _tick2, _all)#'";

			_html = _html & '<script language="JavaScript1.2" type="text/javascript">' & _Cr;
			_html = _html & '<!--' & _Cr;
			_html = _html & "try {" & _Cr;
			_html = _html & "	register_onload_function(#_js_parm#);" & _Cr;
			_html = _html & "} catch(e) {" & _Cr;
			_html = _html & "} finally {" & _Cr;
			_html = _html & "}" & _Cr;
			_html = _html & '-->' & _Cr;
			_html = _html & '</script>' & _Cr;
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="setup_tooltip_handlers" access="public" returntype="string">
		<cfargument name="_id_" type="string" required="yes">
		<cfargument name="_bool_" type="boolean" default="True">

		<cfscript>
			_html = '';
			
			_js_id = "'#_id_#'";
			_js_empty = "''";

			_html = _html & 'id="' & _id_ & '"';

			if (_bool_) {
				_html = _html & ' onmouseover="handle_ToolTip_MouseOver(event, #_js_id#, #_js_empty#); return false;" onmouseout="handle_ToolTip_MouseOut(event, #_js_id#); return false;"';
			}
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="setup_tooltip_handlers2" access="public" returntype="string">
		<cfargument name="_id_" type="string" required="yes">
		<cfargument name="_parked_id_" type="string" required="yes">
		<cfargument name="_bool_" type="boolean" default="True">

		<cfscript>
			_html = '';
			
			_js_id = "'#_id_#'";
			
			_js_parked_id_ = "'#_parked_id_#'";

			_html = _html & 'id="#_id_#"';

			if (_bool_) {
				_html = _html & ' onmouseover="handle_ToolTip_MouseOver(event, #_js_id#, #_js_parked_id_#); return false;" onmouseout="handle_ToolTip_MouseOut(event, #_js_id#); return false;"';
			}
		</cfscript>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="layoutAbstractSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" required="yes">
		<cfargument name="_default_" type="string" default="">

		<cfscript>
			// INPUT: #_codes_#
			// OUTPUT: #_default_#

			var _debugMode = false;
			var Cr = Chr(13);

			var const_height_symbol = 'height';
			
			var tagName = '';
			var _tagType = '';
			
			_s = Replace(_codes_, '{', '');
			_s = Replace(_s, '}', '');
			
			_width = '';
			_spec = '';
			
			for (i = 1; i lte ListLen(_s, ','); i = i + 1) {
				_item = GetToken(_s, i, ',');
				if (_debugMode) _spec = _spec & '#Cr# 1. i = #i#, _item = [#_item#], _s = [#_s#]';
				if (ListLen(_item, '=') eq 2) {
					_varName = GetToken(_item, 1, '=');
					_value = GetToken(_item, 2, '=');
					if (_debugMode) _spec = _spec & '#Cr# 2. _varName = [#_varName#], _value = [#_value#]';
					if (Len(Trim(_spec)) gt 0) {
						_spec = _spec & ' ';
					}
					_ii = Find('(', _value);
					_ij = Len(_value) - Find(')', Reverse(_value), _ii + 1);
					if (_debugMode) _spec = _spec & '#Cr# 3. _ii = #_ii#, _ij = #_ij# ';
					if ( (_ii gt 0) AND (_ij gt _ii) ) {
						_value0 = Mid(_value, _ii, (_ij - _ii) + 2);
						_value1 = Mid(_value, _ij + 2, (Len(_value) - _ij));
						try {
							_value = Evaluate(_value0) & _value1;
						} catch(Any e) {
						}
						if (_debugMode) _spec = _spec & '#Cr# 4. _varName = [#_varName#], _value = [#_value#], _value0 = [#_value0#], _value1 = [#_value1#]';
					}
					if (Len(Trim(_varName)) gt 0) {
						if (_isSpec_) {
							_spec = _spec & '#_varName#="#_value#"';
						} else {
							if (UCASE(_varName) neq UCASE(const_height_symbol)) {
								_spec = _spec & '#_varName#="#_value#"';
							}
						}
					} else if (_isSpec_) {
						_tagType = ReplaceList(_value, '[,]', '(,)');
						_spec = _spec & '<b>#_tagType#</b>';
					} else if (NOT _isSpec_) {
						_tagType = ReplaceList(_value, '[,]', ',');
						// _spec = _spec & '<i>#tagName#, #_tagType#</i>';
						_spec = _spec & '~layout_#_tagType#.cfm~';
					}
				} else {
					tagName = _item;
				}
			}

			if ( (_isSpec_) AND (Len(Trim(_spec)) gt 0) ) {
				_spec = _spec & ' ';
			}
			_spec = _spec & _default_;
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutSiteSpecTag" access="public" returntype="string">
		<cfargument name="_parms_" type="string" default="">

		<cfscript>
			_parms = '';
			if (Len(Trim(_parms_)) gt 0) {
				_parms = ',' & _parms_;
			}
			_spec = '{Site#_parms#}';
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutSiteSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_widthSpec_" type="string" required="yes">
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			var _i = -1;
			var _bool = false;
			var _codes = '';
			var _parm = '';
			var const_width_taglet = 'width=';
			var const_site_taglet = 'Site';
			// INPUT: {Site,width=990px}
			// OUTPUT: width="#_layout_spec_width#px" border="1" cellpadding="-1" cellspacing="-1"

			_border = '0';
			if (_isSpec_) {
				_border = '1';
			}

			_codes_ = Replace(_codes_, '{', '');
			_codes_ = Replace(_codes_, '}', '');

			for (_i = 1; _i lte ListLen(_codes_, ','); _i = _i + 1) {
				_parm = GetToken(_codes_, _i, ',');
				if (FindNoCase(const_site_taglet, _parm) eq 0) {
					if (FindNoCase(const_width_taglet, _parm) gt 0) {
						_bool = true;
						if (_isSpec_) {
							_parm = const_width_taglet & '400px';
						}
					}
					_codes = _codes & _parm;
				}
			}
			if (NOT _bool) {
				_codes = _codes & Replace(_widthSpec_, '"', '', 'all') & '';
			}
			
			_spec = layoutAbstractSpecFull(false, _codes, ' border="#_border#" cellpadding="-1" cellspacing="-1"');
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutAbstractSpecTag" access="public" returntype="string">
		<cfargument name="_tagName_" type="string" required="yes">
		<cfargument name="_parms_" type="string" default="">

		<cfscript>
			var _parms = '';
			if (Len(Trim(_parms_)) gt 0) {
				_parms = ',' & _parms_;
			}
			_spec = '{#_tagName_##_parms#}';
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutHeaderSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {Header,width=100%}
			// OUTPUT: bgcolor="##00ffff"

			var _decoration = 'bgcolor="##00ffff"';
			if (NOT _isSpec_) {
				_decoration = '';
			}
			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, _decoration);
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutMarqueeSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {Marquee,width=60%,height=40px}
			// OUTPUT: bgcolor="##FFB0B0"

			var _decoration = 'bgcolor="##FFB0B0"';
			if (NOT _isSpec_) {
				_decoration = '';
			}
			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, _decoration);
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutCellSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {Cell,width=100%}
			// OUTPUT: 

			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, '');
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutTableSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {Table,width=100%}
			// OUTPUT: height="100%" cellpadding="-1" cellspacing="-1"

			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, ' cellpadding="-1" cellspacing="-1"'); // height="100%" 
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutMenuSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {Menu,width=162px}
			// OUTPUT: align="left" valign="top" bgcolor="##FFB3FF"

			var _decoration = ' bgcolor="##FFB3FF"';
			if (NOT _isSpec_) {
				_decoration = ' ';
			} else {
				_decoration = _decoration & ' height="100%" align="left" valign="top"';
			}
			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, ' #_decoration#');
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutMenuBarSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {MenuBar,width=100%,height=20px}
			// OUTPUT: align="left" valign="top" bgcolor="##C0C0C0"

			var _decoration = ' bgcolor="##C0C0C0"';
			if (NOT _isSpec_) {
				_decoration = ' ';
			} else {
				_decoration = _decoration & ' height="100%" align="left" valign="top"';
			}
			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, ' #_decoration#');
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutQuickLinksSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {QuickLinks,width=100%,height=20px}
			// OUTPUT: align="left" valign="top" bgcolor="##FFBC9B"

			var _decoration = ' bgcolor="##FFBC9B"';
			if (NOT _isSpec_) {
				_decoration = ' ';
			} else {
				_decoration = _decoration & ' height="100%" align="left" valign="top"';
			}
			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, ' #_decoration#');
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutContentSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {Content,width=(Site_width - (Menu_width + RightSide_width))px}
			// OUTPUT: align="left" valign="top" bgcolor="##93C9FF"

			var _decoration = ' bgcolor="##93C9FF"';
			if (NOT _isSpec_) {
				_decoration = ' ';
			} else {
				_decoration = _decoration & ' height="100%" align="left" valign="top"';
			}
			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, ' #_decoration#');
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutRightSideSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {RightSide,width=190px}
			// OUTPUT: align="left" valign="top" bgcolor="##8DC7C7"

			var _decoration = ' bgcolor="##8DC7C7"';
			if (NOT _isSpec_) {
				_decoration = ' ';
			} else {
				_decoration = _decoration & ' height="100%" align="left" valign="top"';
			}
			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, ' #_decoration#');
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutPixSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {Pix,width=190px}
			// OUTPUT: align="left" valign="top" bgcolor="##FFFFB0"

			var _decoration = ' bgcolor="##FFFFB0"';
			if (NOT _isSpec_) {
				_decoration = ' ';
			} else {
				_decoration = _decoration & ' height="100%" align="left" valign="top"';
			}
			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, ' #_decoration#');
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="layoutFooterSpecFull" access="public" returntype="string">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_codes_" type="string" default="">

		<cfscript>
			// INPUT: {Footer,width=100%}
			// OUTPUT: bgcolor="##00FF00"

			var _decoration = ' bgcolor="##00FF00"';
			if (NOT _isSpec_) {
				_decoration = ' ';
			} else {
				_decoration = _decoration & ' height="100%"';
			}
			_spec = layoutAbstractSpecFull(_isSpec_, _codes_, ' #_decoration#');
			
		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="makeSiteLayoutSpecFromCodes" access="public" returntype="string" output="No">
		<cfargument name="_codes_" type="string" required="yes">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_widthSpec_" type="string" default="width=400px">

		<cfscript>
			var Cr = Chr(13);
			var _i = -1;
			var _j = -1;
			var _close_taglet = '}';
			var _the_taglet = '';

			var _spec = _codes_;
			
			_taglet0 = layoutSiteSpecTag();
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_widthSpec_ = Trim(_widthSpec_) & '';
				_spec = Replace(_spec, _the_taglet, layoutSiteSpecFull(_isSpec_, _widthSpec_, _the_taglet));
			}
			
			_taglet0 = layoutAbstractSpecTag('Header');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutHeaderSpecFull(_isSpec_, _the_taglet));
			}

			_taglet0 = layoutAbstractSpecTag('Header_Label');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutAbstractSpecFull(_isSpec_, _the_taglet, ''));
			}

			_taglet0 = layoutAbstractSpecTag('Marquee');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutMarqueeSpecFull(_isSpec_, _the_taglet));
			}

			_taglet0 = layoutAbstractSpecTag('Marquee_Label');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutAbstractSpecFull(_isSpec_, _the_taglet, ''));
			}

			_taglet0 = layoutAbstractSpecTag('Menu,');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutMenuSpecFull(_isSpec_, _the_taglet));
			}

			_taglet0 = layoutAbstractSpecTag('Menu_Label');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutAbstractSpecFull(_isSpec_, _the_taglet, ''));
			}

			_taglet0 = layoutAbstractSpecTag('MenuBar');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutMenuBarSpecFull(_isSpec_, _the_taglet));
			}

			_taglet0 = layoutAbstractSpecTag('MenuBar_Label');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutAbstractSpecFull(_isSpec_, _the_taglet, ''));
			}

			_taglet0 = layoutAbstractSpecTag('QuickLinks');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutQuickLinksSpecFull(_isSpec_, _the_taglet));
			}

			_taglet0 = layoutAbstractSpecTag('QuickLinks_Label');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutAbstractSpecFull(_isSpec_, _the_taglet, ''));
			}

			_taglet0 = layoutAbstractSpecTag('Content');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutContentSpecFull(_isSpec_, _the_taglet));
			}

			_taglet0 = layoutAbstractSpecTag('Content_Label');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutAbstractSpecFull(_isSpec_, _the_taglet, ''));
			}

			_taglet0 = layoutAbstractSpecTag('RightSide');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutRightSideSpecFull(_isSpec_, _the_taglet));
			}

			_taglet0 = layoutAbstractSpecTag('RightSide_Label');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutAbstractSpecFull(_isSpec_, _the_taglet, ''));
			}
			
			_taglet0 = layoutAbstractSpecTag('Pix');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutPixSpecFull(_isSpec_, _the_taglet));
			}

			_taglet0 = layoutAbstractSpecTag('Pix_Label');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutAbstractSpecFull(_isSpec_, _the_taglet, ''));
			}

			_taglet0 = layoutAbstractSpecTag('Footer');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutFooterSpecFull(_isSpec_, _the_taglet));
			}

			_taglet0 = layoutAbstractSpecTag('Footer_Label');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _spec);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _spec, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
				_spec = Replace(_spec, _the_taglet, layoutAbstractSpecFull(_isSpec_, _the_taglet, ''));
			}

			_i = 1; // begin the loop...
			while (_i gt 0) {
				_taglet0 = layoutAbstractSpecTag('Cell');
				_taglet1 = Replace(_taglet0, _close_taglet, '');
				_i = FindNoCase(_taglet1, _spec);
				if (_i gt 0) {
					_j = FindNoCase(_close_taglet, _spec, _i);
					// _i is the position of the beginning of the taglet
					// _j is the position of the ending of the taglet
					_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
					_spec = Replace(_spec, _the_taglet, layoutCellSpecFull(_isSpec_, _the_taglet));
				}
			}

			_i = 1; // begin the loop...
			while (_i gt 0) {
				_taglet0 = layoutAbstractSpecTag('Table');
				_taglet1 = Replace(_taglet0, _close_taglet, '');
				_i = FindNoCase(_taglet1, _spec);
				if (_i gt 0) {
					_j = FindNoCase(_close_taglet, _spec, _i);
					// _i is the position of the beginning of the taglet
					// _j is the position of the ending of the taglet
					_the_taglet = Mid(_spec, _i, (_j - _i) + 1);
					_spec = Replace(_spec, _the_taglet, layoutTableSpecFull(_isSpec_, _the_taglet));
				}
			}

		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="getMarqueeWidthSpecFromLayoutCodes" access="public" returntype="string" output="No">
		<cfargument name="_codes_" type="string" required="yes">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_widthSpec_" type="string" default="width=400px">

		<cfscript>
			var Cr = Chr(13);
			var _i = -1;
			var _j = -1;
			var _close_taglet = '}';
			var _the_taglet = '';
			var _s = '';
			var _t = '';
			var _width_taglet = 'width';

			var _spec = '';
			var _pattern = '';
			var _pat1 = 'px';
			var _pat2 = '%';
			
			_taglet0 = layoutAbstractSpecTag('Marquee');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _codes_);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _codes_, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_codes_, _i, (_j - _i) + 1);

				_s = Replace(_the_taglet, '{', '');
				_s = Replace(_s, '}', '');
				
				for (_j = 1; _j lt ListLen(_s, ','); _j = _j + 1) {
					_t = GetToken(_s, _j, ',');
					if ( (ListLen(_t, '=') eq 2) AND (UCASE(GetToken(_t, 1, '=')) eq UCASE(_width_taglet)) ) {
						_spec = GetToken(_t, 2, '=');
						if (FindOneOf('(,)', _spec) gt 0) {
							_pattern = '';
							if (FindNoCase(_pat1, _spec) gt 0) {
								_pattern = _pat1;
							} else if (FindNoCase(_pat2, _spec) gt 0) {
								_pattern = _pat2;
							}
							_spec = Evaluate(ReplaceNoCase(_spec, _pattern, '')) & _pattern;
						}
						break;
					}
				}
			}

		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="getSiteWidthSpecFromLayoutCodes" access="public" returntype="string" output="No">
		<cfargument name="_codes_" type="string" required="yes">
		<cfargument name="_isSpec_" type="boolean" required="yes"> <!--- if True then the result is the decorated table for viewing pleasure otherwise this is run-time --->
		<cfargument name="_widthSpec_" type="string" default="width=400px">

		<cfscript>
			var Cr = Chr(13);
			var _i = -1;
			var _j = -1;
			var _close_taglet = '}';
			var _the_taglet = '';
			var _s = '';
			var _t = '';
			var _width_taglet = 'width';

			var _spec = '';
			var _pattern = '';
			var _pat1 = 'px';
			var _pat2 = '%';
			
			_taglet0 = layoutAbstractSpecTag('Site');
			_taglet1 = Replace(_taglet0, _close_taglet, '');
			_i = FindNoCase(_taglet1, _codes_);
			if (_i gt 0) {
				_j = FindNoCase(_close_taglet, _codes_, _i);
				// _i is the position of the beginning of the taglet
				// _j is the position of the ending of the taglet
				_the_taglet = Mid(_codes_, _i, (_j - _i) + 1);

				_s = Replace(_the_taglet, '{', '');
				_s = Replace(_s, '}', '');
				
				for (_j = 1; _j lt ListLen(_s, ','); _j = _j + 1) {
					_t = GetToken(_s, _j, ',');
					if ( (ListLen(_t, '=') eq 2) AND (UCASE(GetToken(_t, 1, '=')) eq UCASE(_width_taglet)) ) {
						_spec = GetToken(_t, 2, '=');
						if (FindOneOf('(,)', _spec) gt 0) {
							_pattern = '';
							if (FindNoCase(_pat1, _spec) gt 0) {
								_pattern = _pat1;
							} else if (FindNoCase(_pat2, _spec) gt 0) {
								_pattern = _pat2;
							}
							_spec = Evaluate(ReplaceNoCase(_spec, _pattern, '')) & _pattern;
						}
						break;
					}
				}
				if (Len(Trim(_spec)) eq 0) {
					if (ListLen(_widthSpec_, '=') eq 2) {
						_spec = GetToken(_widthSpec_, 2, '=');
					}
				}
			}

		</cfscript>
		
		<cfreturn _spec>
	</cffunction>

	<cffunction name="imagesUploaderDialog" access="public" returntype="string">
		<cfargument name="_textarea_style_symbol" type="string" required="yes">
		<cfargument name="_uploadImageAction_symbol" type="string" required="yes">
		<cfargument name="_cancelButton_symbol" type="string" required="yes">

		<cfset _tooltips_ = setup_tooltip_handlers("button_submitImageUpload")>
		<cfset _tooltips2_ = setup_tooltip_handlers("_fileName")>
		<cfset _tooltips3_ = setup_tooltip_handlers("cancelPopUp")>
		<cfsavecontent variable="_html">
			<cfoutput>
				<div id="div_imagesUploaderDialog" style="display: none; position: absolute;">
					<table width="500px" height="100px" border="1" bgcolor="##FFFFBF" bordercolor="black">
						<tr>
							<td>
								<div id="div_imagesUploaderDialog_form" style="display: none;">
									<table width="100%" height="100%" cellpadding="-1" cellspacing="-1">
										<tr bgcolor="##B3D9FF">
											<td height="25px" align="center">
												<b>Upload Images to the Images Folder</b>
												<p align="justify"><b>Disclaimer:</b>&nbsp;Image files uploaded using this feature may or may not be necessarily accessible using the URL that is provided at the conclusion of this process.  It is recommended that users use the Standard SCM procedures for migrating static content, such as image files, to the Production web server.</p>
											</td>
											<td height="25px" align="left">
												<div id="div_imagesUploaderDialog_err"></div>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<form action="#CGI.SCRIPT_NAME#" method="post" enctype="multipart/form-data">
													<input type="hidden" name="#Request.varname_splashscreen_inhibitor#" value="#Request.varval_splashscreen_inhibitor#">
													<table width="100%" height="100%" cellpadding="-1" cellspacing="-1">
														<tr>
															<td colspan="2">
																<input type="file" name="_fileName" #_tooltips2_# size="70" #_textarea_style_symbol# accept="image/gif,image/jpeg,image/jpg" title="Click the Browse button to select the file you wish to upload to the server. Files uploaded in this manner cannot be deleted at a later time.  Duplicate files will overwrite files that pre-exist this upload operation." onclick="return clearImagesUploaderError();" ondblclick="return true;">
																<input name="function" type="hidden" value="#_uploadImageAction_symbol#">
															</td>
														</tr>
														<tr>
															<td width="50%" align="center">
																<input type="button" name="submitButton" #_tooltips_# #_textarea_style_symbol# value="#_uploadImageAction_symbol#" title="Click this button to upload the image." onclick="return closeImagesUploaderAction(this.form);" ondblclick="return false;">
															</td>
															<td width="50%" align="center">
																<input type="button" name="cancelButton" #_tooltips3_# title="Click this button to Cancel this operation." value="#_cancelButton_symbol#" #_textarea_style_symbol# onClick="return closeImagesUploaderAction(this.form, true);" ondblclick="return false;">
															</td>
														</tr>
													</table>
												</form>
											</td>
										</tr>
									</table>
								</div>
								<div id="div_imagesUploaderDialog_msg" style="display: none;">
								</div>
							</td>
						</tr>
					</table>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn _html>
	</cffunction>


<CFSCRIPT>
	function safely_cfdirectory(p_action, p_path) {
		var retVal = -1;
		
		try {
			_cfdirectory( p_action, p_path);
			retVal = 1;
		} catch(Any e) {
			retVal = -1;
		}
		return retVal;
	}
</CFSCRIPT>

	<cffunction name="_cfdirectory" access="private" returntype="string">
		<cfargument name="p_action" type="string" required="yes">
		<cfargument name="p_path" type="string" required="yes">

		<cfdirectory action="#p_action#" directory="#p_path#">

	</cffunction>

	<cffunction name="explainUploadOperaton" access="public" returntype="string" output="No">
		<cfargument name="_cffile" type="struct" required="yes">
		<cfargument name="_admin_symbol" type="string" required="yes">
		<cfargument name="_images_prime_symbol" type="string" required="yes">

		<cfscript>
			var _msg = '';
			var _cgi_script_name = CGI.SCRIPT_NAME;
			var _successBool = false;
			
			if ( (IsDefined("_cffile.fileWasSaved")) AND (_cffile.fileWasSaved) ) {
				_successBool = true;
			}
			
			_cgi_script_name = ListDeleteAt(_cgi_script_name, ListLen(_cgi_script_name, '/'), '/');
			if (UCASE(TRIM(GetToken(_cgi_script_name, ListLen(_cgi_script_name, '/'), '/'))) eq UCASE(TRIM(_admin_symbol))) {
				_cgi_script_name = ListDeleteAt(_cgi_script_name, ListLen(_cgi_script_name, '/'), '/');
			}
			_cgi_script_name = ListAppend(_cgi_script_name, _images_prime_symbol, '/');
			
			_msg = _msg & '<p align="justify">File <b>' & _cffile.serverFile & '</b> was ';
			if (NOT _successBool) {
				_msg = _msg & '<font color="red"><u><b>NOT</b></u></font>';
			}
			_msg = _msg & ' successfully saved.</p>';  //  on the server named <b>#CGI.SERVER_NAME#</b>
//			_msg = _msg & '<p align="justify">This site may be hosted on a multi-server server-farm which means the file just uploaded <u>may not</u> be replicated across all the servers in the server-farm however you may be able to reference this image file using the following URL:</p><br>';
			_msg = _msg & '<p align="justify">You may reference this image file using the following URL:</p><br>';
			_msg = _msg & '<center><b>http://#CGI.SERVER_NAME##_cgi_script_name#/#_cffile.serverFile#</b></center><br>';
			_msg = _msg & '<p align="justify">This URL will work properly when highlighted and copied to the windows clipboard and pasted into the image dialog box when creating images using the WYSIWYG HTML Editor.</p><br>';
//			_msg = _msg & '<p align="justify">Be advised that the URL provided above may cease to work in the event the multi-server server-farm is reallocated or the physical server this file was uploaded to is renamed or modified in some unforeseen manner.</p><br>';
//			_msg = _msg & '<p align="justify">It is strongly recommended that the standard SCM procedures be used when uploading static image files to the server farm as this is the only sure way to ensure all files uploaded are replicated across all servers.</p><br>';
		</cfscript>
		
		<cfif 0>
			<cfif (IsDefined("_cffile.attemptedServerFile"))>
				_cffile.attemptedServerFile = [#_cffile.attemptedServerFile#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.clientDirectory"))>
				_cffile.clientDirectory = [#_cffile.clientDirectory#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.clientFile"))>
				_cffile.clientFile = [#_cffile.clientFile#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.clientFileExt"))>
				_cffile.clientFileExt = [#_cffile.clientFileExt#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.clientFileName"))>
				_cffile.clientFileName = [#_cffile.clientFileName#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.contentSubType"))>
				_cffile.contentSubType = [#_cffile.contentSubType#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.contentType"))>
				_cffile.contentType = [#_cffile.contentType#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.dateLastAccessed"))>
				_cffile.dateLastAccessed = [#_cffile.dateLastAccessed#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.fileExisted"))>
				_cffile.fileExisted = [#_cffile.fileExisted#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.fileSize"))>
				_cffile.fileSize = [#_cffile.fileSize#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.fileWasAppended"))>
				_cffile.fileWasAppended = [#_cffile.fileWasAppended#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.fileWasOverwritten"))>
				_cffile.fileWasOverwritten = [#_cffile.fileWasOverwritten#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.fileWasRenamed"))>
				_cffile.fileWasRenamed = [#_cffile.fileWasRenamed#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.fileWasSaved"))>
				_cffile.fileWasSaved = [#_cffile.fileWasSaved#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.oldFileSize"))>
				_cffile.oldFileSize = [#_cffile.oldFileSize#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.serverDirectory"))>
				_cffile.serverDirectory = [#_cffile.serverDirectory#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.serverFile"))>
				_cffile.serverFile = [#_cffile.serverFile#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.serverFileExt"))>
				_cffile.serverFileExt = [#_cffile.serverFileExt#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.serverFileName"))>
				_cffile.serverFileName = [#_cffile.serverFileName#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.timeCreated"))>
				_cffile.timeCreated = [#_cffile.timeCreated#]<br>
			</cfif>
	
			<cfif (IsDefined("_cffile.timeLastModified"))>
				_cffile.timeLastModified = [#_cffile.timeLastModified#]<br>
			</cfif>
		</cfif>

		<cfreturn _msg>
	</cffunction>

	<cffunction name="sql_SiteSearchQuery" access="public" returntype="string">
		<cfargument name="p_tblName" type="string" required="yes">
		<cfargument name="p_baseSQL" type="string" required="yes">

		<cfset _sqlCode = "#p_baseSQL#
			SELECT pageId, html
			FROM #p_tblName#
			WHERE (rid = @prid);
		">
		
		<cfreturn _sqlCode>
	</cffunction>

	<cffunction name="stripHTML" access="public" returntype="string">
		<cfargument name="p_html" type="string" required="yes">

		<cfset _html = REReplace(p_html, "<[^>]*>", "", "all")>
		<cfset _html = REReplace(_html, "&[^;]*;", "", "all")>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="showQueryResultsInTable" access="public" returntype="string">
		<cfargument name="_qry_" type="query" required="yes">

		<cfsavecontent variable="_html">
			<cfoutput>
				recordCount = [#_qry_.recordCount#]
				<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
				<cfloop index="_i" list="#_qry_.columnList#" delimiters=",">
					<tr>
						<td bgcolor="silver" class="normalBoldClass">#_i#</td>
			
						<cfloop query="_qry_" startrow="1" endrow="#_qry_.recordCount#">
							<td class="normalClass">
								<cfset _val = Evaluate("_qry_.#_i#")>
								<cfif (Len(Trim(_val)) gt 0)>
									#_val#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</cfloop>
					</tr>
				</cfloop>
				</table>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="debugQueryInTable" access="public" returntype="string" output="yes">
		<cfargument name="q" type="query" required="yes">
		<cfargument name="qName" type="string" required="yes">
		<cfargument name="isHorz" type="boolean" default="False">

		(#qName#) q.recordCount = [#q.recordCount#]<br>
		<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
			<cfif (isHorz)>
				<cfloop index="_i" list="#q.columnList#" delimiters=",">
					<tr>
						<td bgcolor="silver" class="normalBoldClass">#LCase(_i)#</td>
						<cfloop query="q" startrow="1" endrow="#q.recordCount#">
							<td class="normalClass">
								<cfset _val = Evaluate("q.#_i#")>
								<cfif (Len(Trim(_val)) gt 0)>
									#_val#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</cfloop>
					</tr>
				</cfloop>
			<cfelse>
				<tr>
					<cfloop index="_i" list="#q.columnList#" delimiters=",">
						<td bgcolor="silver" class="normalBoldClass">#LCase(_i)#</td>
					</cfloop>
				</tr>
				<cfloop query="q" startrow="1" endrow="#q.recordCount#">
					<tr>
						<cfloop index="_i" list="#q.columnList#" delimiters=",">
							<td class="normalClass">
								<cfset _val = Evaluate("q.#_i#")>
								<cfif (IsSimpleValue(_val))>
									<cfif (Len(Trim(_val)) gt 0)>
										#_val#
									<cfelse>
										&nbsp;
									</cfif>
								<cfelse>
									<small><i>(Too Complex !)</i></small>
								</cfif>
							</td>
						</cfloop>
					</tr>
				</cfloop>
			</cfif>
		</table>
		
	</cffunction>

	<cffunction name="cf_abort" access="public">
		<cfargument name="p_msg" type="string" default="UNKNOWN REASON FOR ABORT.">

		<cfabort showerror="#p_msg#">
	</cffunction>

	<cffunction name="cf_location" access="public">
		<cfargument name="p_url" type="string" required="yes">
		<cfargument name="p_addtoken" type="boolean" default="False">

		<cflocation url="#p_url#" addtoken="#p_addtoken#">
	</cffunction>
	
	<cffunction name="docHeaderBegin" access="public">
		<cfsavecontent variable="_htmlContent">
			<!DOCTYPE HTML PUBliC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
			<html>
			<head>
				<cfoutput>#metaTags("#Request._site_name##Request._title##Request._adminTitle#", Request.product_metaTags_args)#</cfoutput>
		</cfsavecontent>
		
		<cfreturn _htmlContent>
	</cffunction>

	<cffunction name="docHeaderEnd" access="public">
		<cfsavecontent variable="_htmlContent">
			</head>
		</cfsavecontent>
		
		<cfreturn _htmlContent>
	</cffunction>
</cfcomponent>
