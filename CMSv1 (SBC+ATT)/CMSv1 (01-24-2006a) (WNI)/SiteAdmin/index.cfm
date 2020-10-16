<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="app_name" type="string" default="">
<cfparam name="site_name" type="string" default="">
<cfparam name="site_path" type="string" default="">
<cfparam name="mailto" type="string" default="">
<cfparam name="dsn" type="string" default="">
<cfparam name="dsn_username" type="string" default="">
<cfparam name="dsn_password" type="string" default="">

<cfparam name="_loadJSCode_js" default="../components/_js/loadJSCode_.js" type="string">
<cfparam name="_disable_right_click_script_III_js" default="../components/_js/disable-right-click-script-III_.js" type="string">
<cfparam name="_MathAndStringExtend_js" default="../components/js/MathAndStringExtend.js" type="string">

<cfparam name="_support_js" default="../components/js/support.js" type="string">
<cfparam name="_utility_js" default="../components/js/utility.js" type="string">

<cfscript>
	_sqlCode = "EXEC sp_columns @table_name = 'Site_Config';";
	Request.qq = CommonCode.safelyExecSQL(product_dsn_username, product_dsn_password, product_dsn, _sqlCode, CreateTimeSpan(0, 0, 0, 0));

	_sqlCode2 = "SELECT COLUMN_NAME, IS_NULLABLE, LENGTH, TABLE_NAME, TABLE_OWNER, TABLE_QUALIFIER, TYPE_NAME FROM Request.qq WHERE (LOWER(COLUMN_NAME) <> 'id')";
	Request.qq_metrics = CommonCode.safelyExecQofQ('GetTableMetrics', _sqlCode2);
	
	if (IsDefined("Request.qq_metrics.COLUMN_NAME")) {
		for (i = 1; i lte Request.qq_metrics.recordCount; i = i + 1) {
			aColName = Request.qq_metrics.COLUMN_NAME[i];
			aSQLvarName = '_sqlCode_' & aColName;
			SetVariable(aSQLvarName, "SELECT COLUMN_NAME, IS_NULLABLE, LENGTH, TABLE_NAME, TABLE_OWNER, TABLE_QUALIFIER, TYPE_NAME FROM Request.qq WHERE (LOWER(COLUMN_NAME) = '#LCase(aColName)#')");
			SetVariable('Request.qq_' & aColName, CommonCode.safelyExecQofQ('GetColumnMetrics', Evaluate(aSQLvarName)));
		}
	}
</cfscript>

<cfif 0>
	<cfdump var="#Request.qq#" label="#_sqlCode#" expand="no">
</cfif>

<cfif 0>
	<cfdump var="#Request.qq_metrics#" label="#_sqlCode2#">
</cfif>

<cfif 0>
	<cfif (IsDefined("Request.qq_metrics.COLUMN_NAME"))>
		<cfloop query="Request.qq_metrics" startrow="1" endrow="#Request.qq_metrics.recordCount#">
			<cfdump var="#Evaluate('Request.qq_' & Request.qq_metrics.COLUMN_NAME)#" label="#Evaluate('_sqlCode_' & Request.qq_metrics.COLUMN_NAME)#">
		</cfloop>
	</cfif>
</cfif>

<cfoutput>
	<html>
	<head>
		#commonCode.metaTags("#product_version# - Site Admin", Request.product_metaTags_args)#

		<script language="JScript.Encode" src="#_loadJSCode_js#"></script>

		<script language="JavaScript1.2" src="#_MathAndStringExtend_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_support_js#" type="text/javascript"></script>
		<script language="JavaScript1.2" src="#_utility_js#" type="text/javascript"></script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			var _cache_form_element_isnullable = [];
			var _stack_form_element_colname = [];
			var _submit_button_id = 'SubmitButton';
		-->
		</script>

		<cfif (IsDefined("Request.qq_metrics.COLUMN_NAME"))>
			<cfloop query="Request.qq_metrics" startrow="1" endrow="#Request.qq_metrics.recordCount#">
				<cfset aQQ = Evaluate('Request.qq_' & Request.qq_metrics.COLUMN_NAME)>

				<script language="JavaScript1.2" type="text/javascript">
				<!--
					_stack_form_element_colname.push('#Request.qq_metrics.COLUMN_NAME#');
					_cache_form_element_isnullable['#Request.qq_metrics.COLUMN_NAME#'] = (('#Request.qq_metrics.IS_NULLABLE#'.toUpperCase() == 'NO') ? false : true);
				-->
				</script>
			</cfloop>
		</cfif>
		
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function handleNullableCols() {
				var i = -1;
				var cnt = 0;

				for (i = 0; i < _stack_form_element_colname.length; i++) {
					if (_cache_form_element_isnullable[_stack_form_element_colname[i]] == false) {
						var oObj = getGUIObjectInstanceById(_stack_form_element_colname[i]);
						if (isObjValidHTMLValueHolder(oObj)) {
							if (oObj.value.trim().length == 0) {
								cnt++;
								oObj.style.backgroundColor = '#_error_color#';
							} else {
								oObj.style.backgroundColor = '';
							}
						}
					}
				}
				var btnObj = getGUIObjectInstanceById(_submit_button_id);
				if (btnObj != null) {
					btnObj.disabled = (cnt > 0);
				}
			}
		-->
		</script>
	</head>
	
	<body>

	<cfset js_handle_nullable = ' onFocus="handleNullableCols(); return false;" onblur="handleNullableCols(); return false;"'>

	<form action="#CGI.SCRIPT_NAME#" method="post" name="site_gui" id="site_gui">
		<table width="50%" cellpadding="-1" cellspacing="-1">
			<tr>
				<td>
					App Name:
				</td>
				<td>
					<input type="text" name="app_name" id="app_name" value="#app_name#" size="30" maxlength="#Request.qq_app_name.LENGTH#" #js_handle_nullable#>
				</td>
			</tr>
			<tr>
				<td>
					Site Name:
				</td>
				<td>
					<input type="text" name="site_name" id="site_name" value="#site_name#" size="#Min(30, Request.qq_site_name.LENGTH)#" maxlength="#Request.qq_site_name.LENGTH#" #js_handle_nullable#>
				</td>
			</tr>
			<tr>
				<td>
					Site Path:
				</td>
				<td>
					<input type="text" name="site_path" id="site_path" value="#site_path#" size="#Min(30, Request.qq_site_path.LENGTH)#" maxlength="#Request.qq_site_path.LENGTH#" #js_handle_nullable#>
				</td>
			</tr>
			<tr>
				<td>
					Mail To:
				</td>
				<td>
					<input type="text" name="mailto" id="mailto" value="#mailto#" size="#Min(30, Request.qq_mailto.LENGTH)#" maxlength="#Request.qq_mailto.LENGTH#" #js_handle_nullable#>
				</td>
			</tr>
			<tr>
				<td>
					DSN:
				</td>
				<td>
					<input type="text" name="dsn" id="dsn" value="#dsn#" size="#Min(30, Request.qq_dsn.LENGTH)#" maxlength="#Request.qq_dsn.LENGTH#" #js_handle_nullable#>
				</td>
			</tr>
			<tr>
				<td>
					DSN UserName:
				</td>
				<td>
					<input type="text" name="dsn_username" id="dsn_username" value="#dsn_username#" size="#Min(30, Request.qq_dsn_username.LENGTH)#" maxlength="#Request.qq_dsn_username.LENGTH#" #js_handle_nullable#>
				</td>
			</tr>
			<tr>
				<td>
					DSN Password:
				</td>
				<td>
					<input type="text" name="dsn_password" id="dsn_password" value="#dsn_password#" size="#Min(30, Request.qq_dsn_password.LENGTH)#" maxlength="#Request.qq_dsn_password.LENGTH#" #js_handle_nullable#>
				</td>
			</tr>
			<tr>
				<td>
					<input type="submit" name="SubmitButton" id="SubmitButton" value="[Submit]" #js_handle_nullable#>
				</td>
				<td>
				</td>
			</tr>
		</table>	
	</form>
	
	</body>
	</html>

</cfoutput>
