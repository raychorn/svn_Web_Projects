<cfset _images_folder = "../images/">

<cfset _adminModeBackgroundImage = 'background="#_images_folder#sql2000-transparent-background.gif"'>

<cfset _loadJSCode_js = "../components/_js/loadJSCode_.js">
<cfset _disable_right_click_script_III_js = "../components/_js/disable-right-click-script-III_.js">
<cfset _MathAndStringExtend_js = "../components/js/MathAndStringExtend.js">

<cfset _layout_css = "#siteCSS_base_fileName_symbol#">
<cfset _min_width_js = "../components/js/min_width.js">
<cfset _drop_down_js = "../components/js/drop_down.js">
<cfset _utility_js = "../components/js/utility.js">
<cfset _layout_editor_core_js = "../components/js/layout_editor_core.js">
<cfset _layout_core_js = "../components/js/layout_core.js">
<cfset _mytextsize_js = "../components/my-textsize.js/my-textsize.js">
<cfset _support_js = "../components/js/support.js">
<cfset _tabs_support_js = "../components/js/tabs_support.js">
<cfset _tabs_security_js = "../components/js/tabs_security.js">
<cfset _tabs_release_js = "../components/js/tabs_release.js">
<cfset _tabs_layout_js = "../components/js/tabs_layout.js">
<cfset _tabs_sql2000_js = "../components/js/tabs_sql2000.js">
<cfset _index_header_cfm = "index_header.cfm">
<cfset _index_menu_cfm = "index_menu.cfm">
<cfset _index_rightmenu_cfm = "index_rightmenu.cfm">
<cfset _index_main_cfm = "index_main.cfm">
<cfset _index_footer_cfm = "index_footer.cfm">
<cfset _index_layout_cfm = "index_layout.cfm">
<cfset _index_quicklinks_cfm = "index_quicklinks.cfm">
<cfset Request._adminTitle = " [SQL2000 Overlay] ">

<cfset _menuBar_extraSpaces = 70>

<cfset _num_tabs_max = 7>

<cfset _SQL_statement = "">

<cfset _dbOwner = "dbo">

<cfset is_processDone = "true">
<cfset is_processError = "false">

<cfparam name="_sql2000_wizard_i" type="numeric" default="1">

<cfparam name="subsite_name" type="string" default="">

<cfparam name="_sql2000_wizard_dsn" type="string" default="">
<cfparam name="_sql2000_wizard_dsn_username" type="string" default="">
<cfparam name="_sql2000_wizard_dsn_password" type="string" default="">
<cfparam name="_sql2000_wizard_table_prefix" type="string" default="">

<cfset create_sub_site_tables_button_symbol = "[Create Sub-Site Database Tables]">

<cfset Request.currently_managing_sites_count = 0>

<cfscript>
	function SQL2000WizardCreateTable(oVarName, username, password, dsn, aSQL_statement) {
		var q = -1;
		
		q = CommonCode.safelyExecSQL(username, password, dsn, aSQL_statement, CreateTimeSpan(0, 0, 0, 0));

		if ( (IsDefined("q")) AND (IsQuery(q)) ) {
			if ( (IsDefined("q.status")) AND (IsDefined("q.reason")) ) {
				if ( (q.status eq -1) AND (Len(Trim(q.reason)) gt 0) ) {
					CommonCode.cf_abort(RepeatString('<br>', 20) & '<b>' & q.reason & '</b>');
				}
			}

			try {
				SetVariable(oVarName, q);
			} catch(Any e) {
			}
		}
	}

	function list_display_item(_anItem, _item_method) {
		var i = -1;
		var s_url = '';
		var s_item = '';
		var s_subsysNames = '.,' & Request.cont_subsysNames;
		
		if (Len(Trim(_anItem)) gt 0) {
			Request.currently_managing_sites_count = Request.currently_managing_sites_count + 1;
		}

		for (i = 1; i lte ListLen(s_subsysNames, ','); i = i + 1) {
			s_item = GetToken(s_subsysNames, i, ',');
			if (s_item eq '.') {
				s_item = '';
			}
			if (Len(s_item) eq 0) {
				s_url = Request._prefixName & '?site=' & _anItem;
			} else {
				s_url = Request._prefixName & s_item & '/' & '?site=' & _anItem;
			}
			if (_item_method eq 1) {
				writeOutput('<LI>');
			} else {
				writeOutput('<tr>');
				if (Len(Trim(_anItem)) gt 0) {
					writeOutput('<td width="5%" align="left">');
					if (Len(s_item) eq 0) {
						writeOutput('<b>#Request._num_done#.</b>');
					} else {
						writeOutput('&nbsp;');
					}
					writeOutput('</td>');
				}
				writeOutput('<td width="15%" align="left">');
			}
			if (Len(s_item) eq 0) {
				writeOutput('<font color="##0000ff"><b>' & _anItem & '</b></font>');
			} else {
				writeOutput('&nbsp;');
			}
			writeOutput('</td>');
			if (_item_method gt 1) {
				writeOutput('<td width="*" align="left">');
			}
			writeOutput('(');
			if (Len(s_item) eq 0) {
				writeOutput('The base URL to access ');
				if (Len(Trim(_anItem)) gt 0) {
					writeOutput('this sub-site ');
				} else {
					writeOutput('the Primary Site ');
				}
				writeOutput('is:&nbsp;');
				if (Len(Trim(_anItem)) gt 0) {
					writeOutput('&nbsp;&nbsp;&nbsp;&nbsp;');
				}
			} else {
				writeOutput('The base URL to access this subsystem is:&nbsp;');
				if (Len(Trim(_anItem)) eq 0) {
					writeOutput('&nbsp;');
				}
			}
			writeOutput('<font color="##0000ff"><b>#s_url#</b></font>)');
			if (_item_method gt 1) {
				writeOutput('</td>');
			}
			if (_item_method eq 1) {
				writeOutput('</LI>');
			} else {
				writeOutput('</td>');
				writeOutput('</tr>');
			}
		}

		Request._num_done = Request._num_done + 1;
	}
</cfscript>

<cfinclude template="../#_index_cfm_fileName#">
