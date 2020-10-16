<cfcomponent displayname="ezAjaxCode" hint="(c). Copyright 1990-2006 Hierarchical Applications Limited, All Rights Reserved. The functions and data contained herein may only be used within the context of the ezAJAX&##8482 Community Edition Framework Product, any other use is strictly forbidden." output="No" extends="ezAbstractCode">
	<cfscript>
		const_JsMin_exe = 'jsmin.exe';

		this.str = '';
		
		this.functionSignature = CreateUUID();
		
		cf_trademarkSymbol = '&##8482';
		
		this.productVersion = 0.9;
		this.productName = 'exAJAX#cf_trademarkSymbol# Community Edition Framework';
		this.copyrightNotice = '&copy; 1990-#Year(Now())# Hierarchical Applications Limited, All Rights Reserved.  Use and/or Duplication of this software or any software derived from its use is illegal unless specific written permission has been granted by Hierarchical Applications Limited or a duly appointed Officer of same.';

		this.bool_isRuntimeLicenseStructValid = false;
		this.aRuntimeLicenseStruct = -1;

		const_computerID_exe = 'temp.exe';

		const_PK_violation_msg = 'Violation of PRIMARY KEY constraint';
	</cfscript>

	<cffunction name="isUUIDValid" access="private" returntype="boolean">
		<cfargument name="_arg1_" type="string" required="yes">
		<cfscript>
			var const_sample_uuid = 'F3489402-FE8E-7DD5-94E2CB3F81F94219';
			var ar = ListToArray(_arg1_, '-');
			var ar2 = ListToArray(const_sample_uuid, '-');
			return ( (Len(_arg1_) eq Len(const_sample_uuid)) AND (ListLen(_arg1_, '-') eq 4) AND (Len(ar[1]) eq Len(ar2[1])) AND (Len(ar[2]) eq Len(ar2[2])) AND (Len(ar[3]) eq Len(ar2[3])) AND (Len(ar[4]) eq Len(ar2[4])) );
		</cfscript>
	</cffunction>

	<cffunction name="init" access="public" returntype="any">
		<cfargument name="prodName" type="string" required="yes">
		<cfargument name="aDT" type="date" required="yes">
		<cfscript>
			if (NOT isUUIDValid(this.functionSignature)) {
				this.functionSignature = CreateUUID();
			}
			this.aRuntimeLicenseStruct = readRuntimeLicenseFile(prodName, aDT);
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="_aRuntimeLicenseStruct" access="private" returntype="struct">
		<cfargument name="_arg1_" type="string" required="yes">
		<cfscript>
			var bool = ( (NOT isUUIDValid(_arg1_)) OR (NOT IsStruct(this.aRuntimeLicenseStruct)) );
			var bool_isRuntimeLicenseStructValid = (IsStruct(this.aRuntimeLicenseStruct));
			writeOutput(ezCFDump(this.aRuntimeLicenseStruct, '_aRuntimeLicenseStruct :: this.aRuntimeLicenseStruct, _arg1_ = [#_arg1_#], [#(isUUIDValid(_arg1_))#], bool_isRuntimeLicenseStructValid = [#bool_isRuntimeLicenseStructValid#], bool = [#bool#]', false));
			if (bool) {
				writeOutput('+++ StructNew() +++ [#_arg1_#], bool_isRuntimeLicenseStructValid = [#bool_isRuntimeLicenseStructValid#], bool = [#bool#]' & Chr(13));
				writeOutput(ezCFDump(this.aRuntimeLicenseStruct, '+++ _aRuntimeLicenseStruct :: this.aRuntimeLicenseStruct', false));
				return StructNew();
			}
			return this.aRuntimeLicenseStruct;
		</cfscript>
	</cffunction>

	<cffunction name="_aRuntimeLicenseStruct_" access="private" returntype="struct">
		<cfargument name="_arg1_" type="struct" required="yes">
		<cfscript>
			var boolIsError = false;
			writeOutput(ezCFDump(_arg1_, '_aRuntimeLicenseStruct_ :: _arg1_, [#(IsStruct(_arg1_))#]', false));
			if (IsStruct(_arg1_)) {
				try {
					this.aRuntimeLicenseStruct = _arg1_;
				} catch (Any e) {
					boolIsError = true;
				}
				this.bool_isRuntimeLicenseStructValid = (NOT boolIsError);
			} else {
				cf_throwError(-1, 'ERROR 1.1: Invalid use of an ezAJAX function.', 'A Valid Runtime License is required in order to use this product.  You may obtain a Runtime License by contacting sales@ez-ajax.com.');
			}
			return this.aRuntimeLicenseStruct;
		</cfscript>
	</cffunction>

	<cffunction name="_isPKviolation" access="private" returntype="string">
		<cfargument name="eMsg" required="Yes" type="string">
		<cfscript>
			var bool = false;
			if (FindNoCase(const_PK_violation_msg, eMsg) gt 0) {
				bool = true;
			}
			return bool;
		</cfscript>
	</cffunction>

	<cffunction name="_jsapi_init_js_" access="private" returntype="string">
		<cfargument name="qObjName" required="Yes" type="string">
		<cfargument name="cols" required="Yes" type="string">
		<cfargument name="_method" type="numeric" required="yes">
		<cfscript>
			var _jsCode = '';
			if (_method eq 1) {
				_jsCode = _jsCode & "if (#Request.parentKeyword#jsapi_init_js_#qObjName#) {" & Request.ezAJAX_Cr;
				_jsCode = _jsCode & "#Request.parentKeyword#jsapi_init_js_#qObjName#('#cols#');" & Request.ezAJAX_Cr;
				_jsCode = _jsCode & "} else {" & Request.ezAJAX_Cr;
				_jsCode = _jsCode & "alert('Missing function named #Request.parentKeyword#jsapi_init_js_#qObjName#.');" & Request.ezAJAX_Cr;
				_jsCode = _jsCode & "} " & Request.ezAJAX_Cr;
			} else {
				_jsCode = _jsCode & "if (#Request.parentKeyword#initJSQ) {" & Request.ezAJAX_Cr;
				_jsCode = _jsCode & "#Request.parentKeyword#initJSQ('#qObjName#','#cols#');" & Request.ezAJAX_Cr;
				_jsCode = _jsCode & "} else {" & Request.ezAJAX_Cr;
				_jsCode = _jsCode & "alert('Missing function named #Request.parentKeyword#initJSQ().');" & Request.ezAJAX_Cr;
				_jsCode = _jsCode & "} " & Request.ezAJAX_Cr;
			}
			return _jsCode;
		</cfscript>
	</cffunction>
	
	<cffunction name="_clusterizeURL" access="private" returntype="string">
		<cfargument name="_url" required="Yes" type="string">
		<cfscript>
			var aa = -1;
			var pa = -1;
			var a = ListToArray(_url, "/");
			var p = ArrayToList(a, "/");

			if ( (UCASE(a[1]) eq "HTTP:") OR (UCASE(a[1]) eq "HTTPS:") ) {
				p = ListDeleteAt(p, 1, "/");
			}
			if ( (UCASE(a[2]) eq UCASE(CGI.SERVER_NAME)) AND (CGI.SERVER_PORT neq "80") ) {
				p = ListSetAt(p, 1, CGI.SERVER_NAME & ":" & CGI.SERVER_PORT, "/");
			}
			// BEGIN: Ensure the Cluster Manager's Domain is the one being hit by this link...
			aa = ListToArray(ListGetAt(p, 1, '/'), '.');
			pa = ArrayToList(aa, '.');
			if (ArrayLen(aa) eq 4) {
				pa = ListDeleteAt(pa, 2, '.');
			}
			// END! Ensure the Cluster Manager's Domain is the one being hit by this link...
			p = ListSetAt(p, 1, pa, "/");
			return p;
		</cfscript>
	</cffunction>
		
	<cffunction name="_populate_JS_queryObj" access="private" returntype="string">
		<cfargument name="q" type="query" required="yes">
		<cfargument name="qObjName" required="Yes" type="string">
		<cfargument name="aFunc" type="any" required="yes">
		<cfargument name="bool_asJScode" type="boolean" required="yes">
		<cfscript>
			var i = -1;
			var k = -1;
			var jj = -1;
			var jj_i = -1;
			var jj_n = -1;
			var jj_vVal = '';
			var jj_s = '';
			var vVal = '';
			var js_vVal = '';
			var cName = '';
			var cols = '';
			var _jsCode = '';
			
			if (NOT IsBoolean(bool_asJScode)) {
				bool_asJScode = false;
			}
	
			if (IsQuery(q)) {
				cols = q.ColumnList;
				if (NOT bool_asJScode) _jsCode = _jsCode & ezBeginJavaScript();
				if (NOT bool_asJScode) {
					_jsCode = _jsCode & _jsapi_init_js_(qObjName, cols, 2);
				} else {
					_jsCode = _jsCode & qObjName & " = QObj.get$('#cols#');";
				}
				for (i = 1; i lte q.recordCount; i = i + 1) {
					_jsCode = _jsCode & "if (#Request.parentKeyword##qObjName# != null) { #Request.parentKeyword##qObjName#.QueryAddRow(); } " & Request.ezAJAX_Cr;
					for (k = 1; k lte ListLen(cols, ','); k = k + 1) {
						cName = Trim(ezGetToken(cols, k, ','));
						vVal = q[cName][i];
						if (IsCustomFunction(aFunc)) {
							vVal = Trim(aFunc(vVal));
						}
						if (ezIsTimeStamp(vVal)) {
							dtFmt = DateFormat(vVal, 'mmmm d, yyyy') & ' ' & TimeFormat(vVal, 'HH:mm:ss');
							vVal = dtFmt;
						}
						vVal = URLEncodedFormat(vVal); // the consumer of the data has the responsability of decoding the data stream as-needed...
						js_vVal = "#vVal#";

						_jsCode = _jsCode & "if (#Request.parentKeyword##qObjName# != null) { #Request.parentKeyword##qObjName#.QuerySetCell('#cName#', '#js_vVal#', #i#); } " & Request.ezAJAX_Cr;
					}
					_jsCode = _jsCode & '' & Request.ezAJAX_Cr;
				}
				if (NOT bool_asJScode) _jsCode = _jsCode & ezEndJavaScript();
			}
			return _jsCode;
		</cfscript>
	</cffunction>
	
	<cffunction name="_explainError" access="private" returntype="string">
		<cfargument name="_error" type="any" required="yes">
		<cfargument name="bool_asHTML" type="boolean" required="yes">
		<cfargument name="bool_includeStackTrace" type="boolean" required="yes">
		<cfscript>
			var e = '';
			var v = '';
			var vn = '';
			var i = -1;
			var k = -1;
			var bool_isError = false;
			var sCurrent = -1;
			var sId = -1;
			var sLine = -1;
			var sColumn = -1;
			var sTemplate = -1;
			var nTagStack = -1;
			var sMisc = '';
			var sMiscList = '';
			var _content = '<ul>';
			var _ignoreList = '<remoteAddress>, <browser>, <dateTime>, <HTTPReferer>, <diagnostics>, <TagContext>';
			var _specialList = '<StackTrace>';
			var content_specialList = '';
			var aToken = '';
			var special_templatesList = ''; // comma-delimited list or template keywords
	
			if (NOT IsBoolean(bool_asHTML)) {
				bool_asHTML = false;
			}
			
			if (NOT IsBoolean(bool_includeStackTrace)) {
				bool_includeStackTrace = false;
			}
			
			if (NOT bool_asHTML) {
				_content = '';
			}
	
			for (e in _error) {
				if (FindNoCase('<#e#>', _ignoreList) eq 0) {
					try {
						if (0) {
							v = '--- UNKNOWN --';
							vn = "_error." & e;
			
							if (IsDefined(vn)) {
								v = Evaluate(vn);
							}
						} else {
							v = _error[e];
						}
					} catch (Any ee) {
						v = '--- ERROR --';
					}
	
					if (FindNoCase('<#e#>', _specialList) neq 0) {
						if (NOT bool_asHTML) {
							content_specialList = content_specialList & '#e#=#v#, ';
						} else {
							v = '<textarea cols="100" rows="20" readonly style="font-size: 10px;">#v#</textarea>';
							content_specialList = content_specialList & '<li><b>#e#</b>&nbsp;#v#</li>';
						}
					} else if (IsSimpleValue(v)) {
						if (NOT bool_asHTML) {
							_content = _content & '#e#=#v#,';
						} else {
							_content = _content & '<li><b>#e#</b>&nbsp;#v#</li>';
						}
					}
				}
			}
			if (bool_includeStackTrace) {
				nTagStack = ArrayLen(_error.TAGCONTEXT);
				if (NOT bool_asHTML) {
					_content = _content &	'The contents of the tag stack are: nTagStack = [#nTagStack#], ';
				} else {
					_content = _content &	'<li><p><b>The contents of the tag stack are: nTagStack = [#nTagStack#] </b>';
				}
				if (nTagStack gt 0) {
					for (i = 1; i neq nTagStack; i = i + 1) {
						bool_isError = false;
						try {
							sCurrent = _error.TAGCONTEXT[i];
						} catch (Any e2) {
							bool_isError = true;
							break;
						}
						if (NOT bool_isError) {
							sMiscList = '';
							for (sMisc in sCurrent) {
								if (NOT bool_asHTML) {
									sMiscList = ListAppend(sMiscList, ' [#sMisc#=#sCurrent[sMisc]#] ', ' | ');
								} else {
									sMiscList = sMiscList & '<b><small>[#sMisc#=#sCurrent[sMisc]#]</small></b><br>';
								}
							}
							if (NOT bool_asHTML) {
								_content = _content & sMiscList & '.';
							} else {
								_content = _content & '<br>' & sMiscList & '.';
							}
						}
					}
				}
				if (bool_asHTML) {
					_content = _content & '</p></li>';
				}
				_content = _content & content_specialList;
				if (bool_asHTML) {
					_content = _content & '</ul>';
				} else {
					_content = _content & ',';
				}
			}
			
			return _content;
		</cfscript>
	</cffunction>

	<cffunction name="isFoldable" access="private" returntype="string">
		<cfargument name="inStr" required="Yes" type="string">
		<cfscript>
			return ((Len(inStr) MOD 2) eq 0);
		</cfscript>
	</cffunction>
		
	<cffunction name="tagRuntimeLicenseInvalid" access="private" returntype="struct">
		<cfargument name="aStruct" type="string" required="yes">
		<cfargument name="aReason" type="string" required="yes">
		<cfscript>
			var sBecause = '';
			if (NOT IsStruct(aStruct)) {
				aStruct = StructNew();
			}
			if ( (IsSimpleValue(aReason)) AND (Len(Trim(aReason)) gt 0) ) {
				sBecause = ' because ' & aReason;
			}
			aStruct.RuntimeLicenseStatus = '<br><br><br><h3 style="color: red">The Runtime License for the #this.productName# has Expired or is invalid#sBecause#.  Kindly contact Sales <NOBR>(<a href="mailto:sales@ez-ajax.com">sales@ez-ajax.com</a>)</NOBR> to obtain a new Runtime License.<br><br>#this.productName# is Copyrighted by &copy; 1990-#Year(Now())# Hierarchical Applications Limited, All Rights Reserved.<br><br>The #this.productName# Server will now cease to function until a new Runtime License has been obtained and installed.</h3>';
			aStruct.copyrightNotice = this.copyrightNotice;
			return aStruct;
		</cfscript>
	</cffunction>

	<cffunction name="unfoldBlowFishStream" access="private" returntype="string">
		<cfargument name="inStr" type="string" required="yes">
		<cfscript>
			var bc = Len(inStr);
			var bc2 = bc / 2;
			return Right(inStr, bc2) & Left(inStr, bc2);
			return inStr;
		</cfscript>
	</cffunction>

	<cffunction name="initRuntimeLicenseStruct" access="private" returntype="struct">
		<cfargument name="_signature_" type="string" required="No" default="">
		<cfscript>
			var aStruct = StructNew();
			if (isUUIDValid(_signature_)) {
				try {
					aStruct.runtimeLicenseExpirationDate = -1;
					aStruct.RuntimeLicenseStatus = -1;
					aStruct.computerID = -1;
					aStruct.ProductName = -1;
					aStruct.ServerName = -1;
					aStruct.productVersion = -1;
					aStruct.ColdfusionID = -1;
					aStruct.isCommunityEdition = -1;
					aStruct.copyrightNotice = -1;
				} catch (Any e) {
				}
			}
			return aStruct;
		</cfscript>
	</cffunction>

	<cffunction name="fromBlowfishEncryptedHex" access="private" returntype="string">
		<cfargument name="inEncStr" type="string" required="yes">
		<cfscript>
			var aKeyLenEnc = -1;
			var i = 0;
			var k = -1;
			var xF = 256;
			var sd = '';
			var d = '';
			var inStrEnc = '';
			var aKey = '';
			var aKeyHex = '';

			if (isFoldable(inEncStr)) {
				inEncStr = unfoldBlowFishStream(inEncStr);
			}
			aKeyLenEnc = Mid(inEncStr, 1, 4);
			sd = ToString(BinaryDecode(aKeyLenEnc, 'Hex'));
			for (k = 1; k lte Len(sd); k = k + 1) {
				i = (Asc(Mid(sd, k, 1)) * xF) + i;
				xF = xF / 256;
			}
			aKeyHex = Mid(inEncStr, 5, i);
			aKey = ToString(BinaryDecode(aKeyHex, 'Hex'));
			inStrEnc = Mid(inEncStr, i + 5, Len(inEncStr) - (i + 4));
			return Decrypt(inStrEnc, aKey, 'BLOWFISH', 'Hex');
			return inEncStr;
		</cfscript>
	</cffunction>
		
	<cfscript>
		function ezExplainError(_error, bool_asHTML) {
			return _explainError(_error, bool_asHTML, false);
		}
	
		function ezExplainErrorWithStack(_error, bool_asHTML) {
			return _explainError(_error, bool_asHTML, true);
		}
	</cfscript>
	
	<cffunction name="showThoughtBubbleUsingCF" access="public" returntype="string">
		<cfargument name="sMessage" type="string" required="Yes">
		<cfargument name="iWidth" type="numeric" required="yes">
	
		<cfset var sw_width = (iWidth / 2)>
		<cfset var se_width = (iWidth / 2)>
		
		<cfsavecontent variable="thoughtBubbleHTML">
			<cfoutput>
				<div style="margin-left:10px;margin-bottom:10px;" id="tab_bubble"> 
					<table cellpadding="0" cellspacing="0" border="0" class="bubble"> 
						<tr> 
							<td class="nw"></td> 
							<td colspan="3" class="n"><img width="1" height="1"></td> 
							<td nowrap class="ne"></td> 
						</tr> 
						<tr> 
							<td class="w"><img width="1" height="1"></td> 
							<td colspan="3" class="c" width="*">#sMessage#</td> 
							<td nowrap class="e"><img width="1" height="1"></td> 
						</tr> 
						<tr> 
							<td class="sw"></td> 
							<td width="#sw_width#" class="s"></td> 
							<td width="20" nowrap class="tap"></td> 
							<td width="#se_width#" class="s"></td> 
							<td nowrap class="se"></td> 
						</tr> 
					</table> 
				</div>
			</cfoutput>
		</cfsavecontent>
	
		<cfreturn thoughtBubbleHTML>
	</cffunction>

	<cffunction name="_ezCfDump" access="public">
		<cfargument name="_aVar_" type="any" required="yes">
		<cfargument name="_aLabel_" type="string" required="yes">
		<cfargument name="_aBool_" type="boolean" required="No" default="False">
		
		<cfif (_aBool_)>
			<cfdump var="#_aVar_#" label="#_aLabel_#" expand="Yes">
		<cfelse>
			<cfdump var="#_aVar_#" label="#_aLabel_#" expand="No">
		</cfif>
	</cffunction>
	
	<cffunction name="ezCfDump" access="public" returntype="string">
		<cfargument name="_aVar_" type="any" required="yes">
		<cfargument name="_aLabel_" type="string" required="yes">
		<cfargument name="_aBool_" type="boolean" required="No" default="False">
		
		<cfsavecontent variable="_html">
			<cfoutput>
				#_ezCfDump(_aVar_, _aLabel_, _aBool_)#
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cffunction name="ezCfMail" access="public" returntype="any">
		<cfargument name="_toAddrs_" type="string" required="yes">
		<cfargument name="_fromAddrs_" type="string" required="yes">
		<cfargument name="_theSubj_" type="string" required="yes">
		<cfargument name="_theBody_" type="string" required="yes">
		<cfargument name="optionsStruct" type="any" default="StructNew()" required="No">
	
		<cfset Request.anError = "False">
		<cfset Request.errorMsg = "">
		<cftry>
			<cfif (IsDefined("optionsStruct.bcc"))>
				<cfmail to="#_toAddrs_#" from="#_fromAddrs_#" bcc="#optionsStruct.bcc#" subject="#_theSubj_#" type="HTML">#_theBody_#<cfif (IsDefined("optionsStruct.cfmailparam")) AND (IsStruct(optionsStruct.cfmailparam)) AND (IsDefined("optionsStruct.cfmailparam.type")) AND (Len(optionsStruct.cfmailparam.type) gt 0) AND (IsDefined("optionsStruct.cfmailparam.file")) AND (Len(optionsStruct.cfmailparam.file) gt 0)><cfmailparam type="#optionsStruct.cfmailparam.type#" disposition="attachment" file="#optionsStruct.cfmailparam.file#"></cfif></cfmail>
			<cfelse>
				<cfmail to="#_toAddrs_#" from="#_fromAddrs_#" subject="#_theSubj_#" type="HTML">#_theBody_#</cfmail>
			</cfif>
	
			<cfcatch type="Any">
				<cfset Request.anError = "True">
	
				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						#cfcatch.message#<br>
						#cfcatch.detail#
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="cfm_nocache" access="private">
		<cfargument name="LastModified" type="string" required="yes">

		<CFSETTING ENABLECFOUTPUTONLY="YES">
		<CFHEADER NAME="Pragma" VALUE="no-cache">
		<CFHEADER NAME="Cache-Control" VALUE="no-cache, must-revalidate">
		<CFHEADER NAME="Last-Modified" VALUE="#LastModified#">
		<CFHEADER NAME="Expires" VALUE="Mon, 26 Jul 1997 05:00:00 EST">
		<CFSETTING ENABLECFOUTPUTONLY="NO">
	</cffunction>

	<cffunction name="ezExecSQL" access="public">
		<cfargument name="_qName_" type="string" required="yes">
		<cfargument name="_DSN_" type="string" required="yes">
		<cfargument name="_sql_" type="string" required="yes">
		<cfargument name="_cachedWithin_" type="string" required="No" default="">
		
		<cfscript>
			var q = -1;
		</cfscript>
	
		<cfset Request.errorMsg = "">
		<cfset Request.moreErrorMsg = "">
		<cfset Request.explainError = "">
		<cfset Request.explainErrorHTML = "">
		<cfset Request.dbError = "False">
		<cfset Request.isPKviolation = "False">
		<cftry>
			<cfif (Len(Trim(arguments._qName_)) gt 0)>
				<cfif (Len(_DSN_) gt 0)>
					<cfif (Len(_cachedWithin_) gt 0) AND (IsNumeric(_cachedWithin_))>
						<cfquery name="#_qName_#" datasource="#_DSN_#" cachedwithin="#_cachedWithin_#">
							#PreserveSingleQuotes(_sql_)#
						</cfquery>
					<cfelse>
						<cfquery name="#_qName_#" datasource="#_DSN_#">
							#PreserveSingleQuotes(_sql_)#
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="#_qName_#" dbtype="query">
						#PreserveSingleQuotes(_sql_)#
					</cfquery>
				</cfif>
			<cfelse>
				<cfset Request.errorMsg = "Missing Query Name which is supposed to be the first parameter.">
				<cfthrow message="#Request.errorMsg#" type="missingQueryName" errorcode="-100">
			</cfif>
	
			<cfcatch type="Database">
				<cfset Request.dbError = "True">
	
				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
						<cfif (IsDefined("cfcatch.SQLState"))>[<b>cfcatch.SQLState</b>=#cfcatch.SQLState#]</cfif>
					</cfoutput>
				</cfsavecontent>
	
				<cfsavecontent variable="Request.moreErrorMsg">
					<cfoutput>
						<UL>
							<cfif (IsDefined("cfcatch.Sql"))><LI>#cfcatch.Sql#</LI></cfif>
							<cfif (IsDefined("cfcatch.type"))><LI>#cfcatch.type#</LI></cfif>
							<cfif (IsDefined("cfcatch.message"))><LI>#cfcatch.message#</LI></cfif>
							<cfif (IsDefined("cfcatch.detail"))><LI>#cfcatch.detail#</LI></cfif>
							<cfif (IsDefined("cfcatch.SQLState"))><LI><b>cfcatch.SQLState</b>=#cfcatch.SQLState#</LI></cfif>
						</UL>
					</cfoutput>
				</cfsavecontent>
	
				<cfsavecontent variable="Request.explainErrorText">
					<cfoutput>
						[#ezExplainError(cfcatch, false)#]
					</cfoutput>
				</cfsavecontent>
	
				<cfsavecontent variable="Request.explainErrorHTML">
					<cfoutput>
						[#ezExplainError(cfcatch, true)#]
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					if (Len(_DSN_) gt 0) {
						Request.isPKviolation = _isPKviolation(Request.errorMsg);
					}
				</cfscript>
	
				<cfset Request.dbErrorMsg = Request.errorMsg>
				<cfsavecontent variable="Request.fullErrorMsg">
					<cfdump var="#cfcatch#" label="cfcatch">
				</cfsavecontent>
				<cfsavecontent variable="Request.verboseErrorMsg">
					<cfif (IsDefined("Request.bool_show_verbose_SQL_errors"))>
						<cfif (Request.bool_show_verbose_SQL_errors)>
							<cfdump var="#cfcatch#" label="cfcatch :: Request.isPKviolation = [#Request.isPKviolation#]" expand="No">
						</cfif>
					</cfif>
				</cfsavecontent>
	
				<cfscript>
					if ( (IsDefined("Request.bool_show_verbose_SQL_errors")) AND (IsDefined("Request.verboseErrorMsg")) ) {
						if (Request.bool_show_verbose_SQL_errors) {
							if (NOT Request.isPKviolation) 
								writeOutput(Request.verboseErrorMsg);
						}
					}
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="ezCfDirectory" access="public" returntype="boolean">
		<cfargument name="_qName_" type="string" required="yes">
		<cfargument name="_path_" type="string" required="yes">
		<cfargument name="_filter_" type="string" required="yes">
		<cfargument name="_recurse_" type="boolean" required="No" default="False">
	
		<cfset Request.directoryError = "False">
		<cfset Request.directoryErrorMsg = "">
		<cfset Request.directoryFullErrorMsg = "">
		<cfset Request.directoryPlainErrorMsg = "">
		<cftry>
			<cfif (_recurse_)>
				<cfdirectory action="LIST" directory="#_path_#" name="#_qName_#" filter="#_filter_#" recurse="Yes">
			<cfelse>
				<cfdirectory action="LIST" directory="#_path_#" name="#_qName_#" filter="#_filter_#">
			</cfif>

			<cfcatch type="Any">
				<cfset Request.directoryError = "True">

				<cfsavecontent variable="Request.directoryErrorMsg">
					<cfoutput>
						#cfcatch.message#<br>
						#cfcatch.detail#
					</cfoutput>
				</cfsavecontent>
				<cfsavecontent variable="Request.directoryFullErrorMsg">
					<cfdump var="#cfcatch#" label="cfcatch" expand="Yes">
				</cfsavecontent>
				<cfset Request.directoryPlainErrorMsg = ezExplainError(cfcatch, false)>
			</cfcatch>
		</cftry>
	
		<cfreturn Request.directoryError>
	</cffunction>
	
	<cffunction name="ezScopesDebugPanelContent" access="public" returntype="string">
		<cfsavecontent variable="content_scopes_debug_panel">
			<cfoutput>
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td width="25%" align="center" valign="top">
							<cfdump var="#Application#" label="App Scope" expand="No">
						</td>
						<td width="25%" align="center" valign="top">
							<cfdump var="#Session#" label="Session Scope" expand="No">
						</td>
						<td width="25%" align="center" valign="top">
							<cfdump var="#CGI#" label="CGI Scope" expand="No">
						</td>
						<td width="25%" align="center" valign="top">
							<cfdump var="#Request#" label="Request Scope" expand="No">
						</td>
					</tr>
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn content_scopes_debug_panel>
	</cffunction>

	<cffunction name="writeComputerIDExe" access="private" returntype="string">
		<cfset var fName = -1>
		<cfset var binimage = "">
		<cfset var _serial_ = CreateUUID()>
		<cfset var exeName = ReplaceNoCase(const_computerID_exe, ".exe", _serial_ & ".exe")>
		<cfset var i = -1>
		<cfset _fname = "">
		<cfset fName = ExpandPath(exeName)>
		<cfset binimage = BinaryDecode(binEncoded, "Hex")>
		<cfscript>
			ezCfDirectory("Request.tempQ", GetDirectoryFromPath(fName), "*.exe");
			if ( (NOT Request.directoryError) AND (IsDefined("Request.tempQ")) AND (IsQuery(Request.tempQ)) ) {
				for (i = 1; i lte Request.tempQ.recordCount; i = i + 1) {
					_fname = ExpandPath(Request.tempQ.name[i]);
					if (FileExists(_fname)) {
						ezCfFileDelete(_fname);
					}
				}
			}
		</cfscript>
		<cfif (FileExists(fName))>
			<cffile action="DELETE" file="#fName#">
		</cfif>
		<cffile action="WRITE" file="#fName#" output="#binimage#" attributes="Normal" addnewline="No" fixnewline="No">
		<cfreturn fName>
	</cffunction>
	
	<cffunction name="getComputerID" access="private" returntype="string">
		<cfset var fName = -1>
		<cfset var outText = "">
		<cfset var exeName = "">
		<cfset var outName = "ComputerID_v1.0.0.out">
		<cfset var dllName = "WBDEG44I.DLL">
		<cflock timeout="90" throwontimeout="No" name="computerID" type="EXCLUSIVE">
			<cfset exeName = writeComputerIDExe()>
			<cftry>
				<cfexecute name="#exeName#" timeOut="60"></cfexecute>

				<cfcatch type="Any">
				</cfcatch>
			</cftry>
			<cfset fName = ExpandPath(outName)>
			<cfif (FileExists(fName))>
				<cffile action="READ" file="#fName#" variable="outText">
				<cflock timeout="10" throwontimeout="No" name="computerIDdelete" type="EXCLUSIVE">
					<cftry>
						<cffile action="DELETE" file="#fName#">
		
						<cfcatch type="Any">
						</cfcatch>
					</cftry>
				</cflock>
			</cfif>
			<cfset fName = ExpandPath(dllName)>
			<cfif (FileExists(fName))>
				<cflock timeout="10" throwontimeout="No" name="computerIDDLLdelete" type="EXCLUSIVE">
					<cftry>
						<cffile action="DELETE" file="#fName#">
		
						<cfcatch type="Any">
						</cfcatch>
					</cftry>
				</cflock>
			</cfif>
			<cfif (FileExists(exeName))>
				<cftry>
					<cflock timeout="10" throwontimeout="No" name="computerIDEXEdelete" type="EXCLUSIVE">
						<cffile action="DELETE" file="#exeName#">
					</cflock>
		
					<cfcatch type="Any">
					</cfcatch>
				</cftry>
			</cfif>
		</cflock>
		<cfreturn outText>
	</cffunction>

	<cffunction name="ezCfFileDelete" access="public" returntype="any">
		<cfargument name="_fName_" type="string" required="yes">

		<cfset Request.errorMsg = "">	
		<cfset Request.fileError = false>	
		<cftry>
			<cffile action="DELETE" file="#_fName_#">

			<cfcatch type="Any">
				<cfset Request.fileError = true>	

				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="ezCfFileRead" access="public" returntype="any">
		<cfargument name="_fName_" type="string" required="yes">
		<cfargument name="_vName_" type="string" required="yes">

		<cfset Request.errorMsg = "">	
		<cfset Request.fileError = false>	
		<cftry>
			<cffile action="READ" file="#_fName_#" variable="#_vName_#">

			<cfcatch type="Any">
				<cfset Request.fileError = true>	

				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="ezCfFileWrite" access="public" returntype="any">
		<cfargument name="_fName_" type="string" required="yes">
		<cfargument name="_out_" type="string" required="yes">

		<cfset Request.errorMsg = "">	
		<cfset Request.fileError = false>	
		<cftry>
			<cffile action="WRITE" file="#_fName_#" output="#_out_#" attributes="Normal" addnewline="No" fixnewline="No">

			<cfcatch type="Any">
				<cfset Request.fileError = true>	

				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="ezCfExecute" access="public" returntype="any">
		<cfargument name="_name_" type="string" required="yes">
		<cfargument name="_args_" type="string" required="yes">
		<cfargument name="_timeout_" type="numeric" required="yes">
	
		<cfset Request.errorMsg = "">	
		<cfset Request.execError = false>	
		<cftry>
			<cfexecute name="#_name_#" arguments="#_args_#" variable="Request.cfexecuteOutput" timeout="#_timeout_#" />

			<cfcatch type="Any">
				<cfset Request.execError = true>	

				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
	</cffunction>

	<cffunction name="ezCfLog" access="public">
		<cfargument name="_someText_" type="string" required="yes">
		
		<cflog file="#Application.applicationName#" type="Information" text="#_someText_#">
	</cffunction>

	<cffunction name="ezCFML2WDDX" access="public" returntype="string">
		<cfargument name="_anObj_" type="any" required="yes">
		
		<cfset var wddxContent = -1>

		<cfwddx action="CFML2WDDX" input="#_anObj_#" output="wddxContent" usetimezoneinfo="Yes">		

		<cfreturn wddxContent>
	</cffunction>
	
	<cffunction name="ezWDDX2CFML" access="public" returntype="any">
		<cfargument name="_aWddxStr_" type="any" required="yes">
		
		<cfset var cfObject = -1>

		<cfwddx action="WDDX2CFML" input="#_aWddxStr_#" output="cfObject" validate="yes">		

		<cfreturn cfObject>
	</cffunction>
	
	<cffunction name="tabsHeader" access="public" returntype="string">
		<cfargument name="_tab_height" required="yes" type="string">
		<cfargument name="_content_top" required="yes" type="string">
		<cfargument name="_content_margin_left" required="yes" type="string">
		<cfargument name="_content_width" required="yes" type="string">
		<cfargument name="_content_padder_height" required="yes" type="string">

		<cfset var _html = "">
		<cfset var _tab_height_raw = ReplaceNoCase(_tab_height, "px", "")>
		<cfset var _content_top_raw = ReplaceNoCase(_content_top, "px", "")>
		<cfset var content_top_dX = 15>
		<cfset var tab_height_tag = "">
		<cfset var content_top_tag = "top: #_content_top#">

		<cfif (Len(_tab_height) gt 0)>
			<cfif (NOT ezIsBrowserIE())>
				<cfset content_top_dX = 20>
			</cfif>
			<cfset content_top_tag = "top: #(_content_top_raw + (_tab_height_raw - content_top_dX))#">
		</cfif>

		<cfif (Len(_tab_height) gt 0)>
			<cfset tab_height_tag = "height: #_tab_height_raw#px; line-height: 10px;">
		</cfif>

		<cfsavecontent variable="_html">
			<cfoutput>
				<style type="text/css">
						##TabSystem1 {
							background: transparent;
							border: none;
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
							font-size: xx-small;
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
						font-size: medium;
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
				      .tabHidden { 
						padding: 3px 9px 3px 9px;
						color: ##060610 ;
						background-color: ##f3f6f9;
						z-index: 10000;
						display: none;
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
						font-size: medium;
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
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

	<cfscript>
		function ezGetToken(str, index, delim) { // this is a faster GetToken() than GetToken()...
			var ar = -1;
			var retVal = '';
			ar = ListToArray(str, delim);
			try {
				retVal = ar[index];
			} catch (Any e) {
			}
			return retVal;
		}

		function isServerLocal() {
			var CGI_HTTP_HOST = UCASE(TRIM(CGI.HTTP_HOST));
			return ( (CGI_HTTP_HOST eq "LOCALHOST") OR (CGI_HTTP_HOST eq UCASE("laptop.halsmalltalker.com")) );
		}
	
		function _isBrowserOP(s_userAgent) {
			var bool = false;
			if ( (FindNoCase('Opera', s_userAgent) gt 0) AND (FindNoCase('MSIE 6', s_userAgent) eq 0) AND (FindNoCase('Firefox', s_userAgent) eq 0) AND (FindNoCase('Gecko', s_userAgent) eq 0) AND (FindNoCase('Netscape', s_userAgent) eq 0) ) {
				bool = true;
			}
			return bool;
		}
		
		function _isBrowserNS(s_userAgent) {
			var bool = false;
			if ( (FindNoCase('Opera', s_userAgent) eq 0) AND (FindNoCase('MSIE 6', s_userAgent) eq 0) AND (FindNoCase('Firefox', s_userAgent) eq 0) AND ( (FindNoCase('Gecko', s_userAgent) gt 0) OR (FindNoCase('Netscape', s_userAgent) gt 0) ) ) {
				bool = true;
			}
			return bool;
		}
		
		function _isBrowserFF(s_userAgent) {
			var bool = false;
			if ( (FindNoCase('Opera', s_userAgent) eq 0) AND (FindNoCase('Netscape', s_userAgent) eq 0) AND ( (FindNoCase('Gecko', s_userAgent) gt 0) OR (FindNoCase('Firefox', s_userAgent) gt 0) ) AND (FindNoCase('MSIE 6', s_userAgent) eq 0) ) {
				bool = true;
			}
			return bool;
		}
		
		function _isBrowserIE(s_userAgent) {
			var bool = false;
			if ( (FindNoCase('Opera', s_userAgent) gt 0) OR (FindNoCase('Gecko', s_userAgent) gt 0) OR (FindNoCase('Firefox', s_userAgent) gt 0) OR (FindNoCase('Netscape', s_userAgent) gt 0) OR ( (FindNoCase('MSIE 6', s_userAgent) eq 0) AND (FindNoCase('MSIE 7', s_userAgent) eq 0) ) ) {
				bool = false;
			} else {
				bool = true;
			}
			return bool;
		}
		
		function ezIsBrowserIE() {
			return (_isBrowserIE(CGI.HTTP_USER_AGENT));
		}

		function ezIsBrowserFF() {
			return (_isBrowserFF(CGI.HTTP_USER_AGENT));
		}

		function ezIsBrowserNS() {
			return (_isBrowserNS(CGI.HTTP_USER_AGENT));
		}

		function ezIsBrowserOP() {
			return (_isBrowserOP(CGI.HTTP_USER_AGENT));
		}

		function ezIsTimeStamp(str) { // {ts '2006-06-01 00:00:00'}
			var const_begin_symbol = "{ts '";
			var const_end_symbol = "'}";
			var tok = '';
			var iBegin = FindNoCase(const_begin_symbol, str);
			var iEnd = FindNoCase(const_end_symbol, str, iBegin);
			var iBeginPt = -1;
			var iEndPt = -1;
			var ar = -1;
			var arLeft = -1;
			var retVal = false;

			if ( (iBegin gt 0) AND (iEnd gt iBegin) ) {
				iBeginPt = iBegin + Len(const_begin_symbol);
				iEndPt = iEnd - Len(const_end_symbol);
				tok = Mid(str, iBeginPt, (iEndPt - iBeginPt) + 1);
				ar = ListToArray(tok, ' ');
				if (ArrayLen(ar) eq 2) {
					arLeft = ListToArray(ar[1], '-');
					arRight = ListToArray(ar[2], ':');
					retVal = ( (ArrayLen(arLeft) eq 3) AND (ArrayLen(arRight) eq 3) );
				}
			}
			return retVal;
		}
		
		function ezFilterQuotesForSQL(s) {
			var str = '';
			str = ReplaceNoCase(s, "'", "''", 'all');
			return str;
		}
		
		function ezFilterIntForSQL(s) {
			var t = reReplace(s, "(\+|-)?[0-9]+(\.[0-9]*)?", "", "all"); // flter-out numerics thus leaving non-numerics...
			var ar = ArrayNew(1);
			var ar2 = ArrayNew(1);
			var i = -1;

			for (i = 1; i lte Len(t); i = i + 1) {
				ar[ArrayLen(ar) + 1] = Mid(t, i, 1);
				ar2[ArrayLen(ar2) + 1] = '';
			}
			return ReplaceList(s, ArrayToList(ar, ','), ArrayToList(ar2, ','));
		}
	
		function ezFilterQuotesForJS(s) {
			return ReplaceNoCase(s, "'", "\'", 'all');
		}

		function ezFilterQuotesForJSContent(s) {
			return ReplaceNoCase(s, "'", "&acute;", "all");
		}

		function ezFilterDoubleQuotesForJSContent(s) {
			return ReplaceNoCase(s, '"', '&quot;', 'all');
		}
		
		function ezFilterTradeMarkForJSContent(s) {
			return ReplaceNoCase(s, Chr(153), '&##8482', 'all');
		}

		function ezFilterOutCr(s) {
			return ReplaceNoCase(s, Chr(13), "", 'all');
		}
	
		function ezFilterOutCrLf(s) {
			return ReplaceNoCase(s, Chr(13) & Chr(10), ' ', 'all');
		}
	
		function ezFilterDoubleQuotesForJS(s) {
			return ReplaceNoCase(s, '"', '\"', 'all');
		}

		function ezListToSQLInList(sList) {
			var i = -1;
			var ar = ListToArray(sList, ',');
			var arN = ArrayLen(ar);

			for (i = 1; i lte arN; i = i + 1) {
				ar[i] = "'" & ezFilterQuotesForSQL(ar[i]) & "'";
			}
			return ArrayToList(ar, ',');
		}

		function ezCompressErrorMsgs(s) {
			var cAR = ListToArray(Replace(s, Chr(13), '', 'all'), Chr(10));
			var n = ArrayLen(cAR);
			var t = '';

			for (i = 1; i lte n; i = i + 1) {
				t = t & cAR[i] & Chr(13);
			}
			return t;
		}
			
		function ezBrowserNoCache() {
			var _html = '';
			var LastModified = DateFormat(Now(), "dd mmm yyyy") & " " & TimeFormat(Now(), "hh:mm:ss") & " GMT-5";
			
			cfm_nocache(LastModified);
	
			_html = _html & '<META HTTP-EQUIV="Pragma" CONTENT="no-cache">' & Request.ezAJAX_Cr;
			_html = _html & '<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">' & Request.ezAJAX_Cr;
			_html = _html & '<META HTTP-EQUIV="Last-Modified" CONTENT="#LastModified#">' & Request.ezAJAX_Cr;
			_html = _html & '<META HTTP-EQUIV="Expires" CONTENT="Mon, 26 Jul 1997 05:00:00 EST">' & Request.ezAJAX_Cr;
	
			return _html;
		}

		function ezBeginJavaScript() {
			var _jsCode = '';

			_jsCode = _jsCode & '<scr' & 'ipt language="JavaScript1.2" type="text/javascript">' & Request.ezAJAX_Cr;
			_jsCode = _jsCode & '<!--\/\/' & Request.ezAJAX_Cr;
			
			return _jsCode;
		}
	
		function ezEndJavaScript() {
			var _jsCode = '';

			_jsCode = _jsCode & '\/\/-->' & Request.ezAJAX_Cr;
			_jsCode = _jsCode & '</scr' & 'ipt>' & Request.ezAJAX_Cr;

			return _jsCode;
		}

		function populate_JS_queryObj(q, qObjName, bool_asJScode) {
			return _populate_JS_queryObj(q, qObjName, _dummy_func, bool_asJScode);
		}

		function blue_formattedModuleName(_ex) {
			var _html = '';
			
			_html = '<font color="blue"><b>' & ezGetToken("#_ex#", ListLen("#_ex#", "/"), "/") & '</b></font>';
			return _html;
		}

		function initQryObj(col_list) {
			return QueryNew(col_list);
		}

		function indexForNamedQueryColumn(qQ, colName, findName) {
			var i = -1;
			var j = -1;

			if (IsQuery(qQ)) {
				for (j = 1; j lte qQ.recordCount; j = j + 1) {
					if (UCASE(qQ[colName][j]) eq UCASE(findName)) {
						i = j;
						break;
					}
				}
			}
			return i;
		}

		function _dummy_func(val) {
			return val;
		}

		function ezStripCommentBlocks(p) {
			return REReplace(p, "/\*[^/\*]*\*/", "", "all");
		}
		
		function ezStripComments(p) {
			var re = '\/' & '\/' & '.*$';
			return REReplace(p, re, "", "all");
		}
		
		function QueryStats(qQ) {
			var bytes = 0;
			var colsAR = -1;
			var nAR = -1;
			var i = -1;
			var k = -1;
			
			if (IsQuery(qQ)) {
				colsAR = ListToArray(qQ.columnList, ',');
				nAR = ArrayLen(colsAR);
				for (i = 1; i lte qQ.recordCount; i = i + 1) {
					for (k = 1; k lte nAR; k = k + 1) {
						bytes = bytes + Len(qQ[colsAR[k]][i]);
					}
				}
			}
			return bytes;
		}

		function readRuntimeLicenseFile(aProductName, aDateStr) {
			var computerID = '';
			var fName = ExpandPath('runtimeLicense.dat');
			var appName = Application.applicationName;
			var isAJAX = false;
			var isValid = false;
			var aReason = '';
			var ar = -1;
			var i = -1;
			var n = -1;
			var sTxt= '';
			var sPlural = '';
			var iElementCnt = 0;
			var aDate = Now();
			var aStruct = _aRuntimeLicenseStruct_(initRuntimeLicenseStruct(CreateUUID()));
			if (IsDate(aDateStr)) {
				aDate = ParseDateTime(aDateStr);
			}
			ColdfusionID = server.coldfusion.productname & ' ' & ListFirst(server.coldfusion.productversion) & '.' & ListGetAt(server.coldfusion.productversion, 2);
			if (NOT FileExists(fName)) {
				fName = ExpandPath('..\runtimeLicense.dat');
				isAJAX = true;
			}
			if (FileExists(fName)) {
				this.str = '';
				ezCfFileRead(fName, 'this.str');
				if (Len(this.str) gt 0) {
					try {
						aStruct = _aRuntimeLicenseStruct_(ezWDDX2CFML(fromBlowfishEncryptedHex(this.str)));
						if ( (IsStruct(aStruct)) AND (NOT StructIsEmpty(aStruct)) ) {
							computerID = Trim(getComputerID());
							aReason = '';
							isValid = false;
							if ( (IsDefined("aStruct.ColdfusionID")) AND (IsDefined("aStruct.computerID")) AND (IsDefined("aStruct.ProductName")) AND (IsDefined("aStruct.productVersion")) ) {
								isValid = ( (ColdfusionID is aStruct.ColdfusionID) AND (computerID is aStruct.computerID) AND (aProductName is aStruct.ProductName) AND (this.productVersion lte aStruct.productVersion) AND (CGI.SERVER_NAME is aStruct.ServerName) );
								if ( (NOT isValid) OR (DateCompare(aDate, aStruct.runtimeLicenseExpirationDate) gt 0) ) {
									if (NOT (ColdfusionID is aStruct.ColdfusionID)) {
										aReason = aReason & 'your ColdFusion Server Version (#ColdfusionID#) does not match the expected ColdFusion Server Version (#aStruct.ColdfusionID#) for your current Runtime License';
									}
									if (NOT (computerID is aStruct.computerID)) {
										if (Len(aReason) gt 0) {
											aReason = aReason & ' AND ';
										}
										aReason = aReason & 'the Machine ID (#computerID#) from your server does not match the expected Machine ID (#aStruct.computerID#) for your current Runtime License';
									}
									if (NOT (aProductName is aStruct.ProductName)) {
										if (Len(aReason) gt 0) {
											aReason = aReason & ' AND ';
										}
										aReason = aReason & 'the Product Name does not match the expected Product Name for your current Runtime License';
									}
									if (this.productVersion gt aStruct.productVersion) {
										if (Len(aReason) gt 0) {
											aReason = aReason & ' AND ';
										}
										aReason = aReason & 'the Product Version Number (#this.productVersion#) does not match the expected Product Version Number (#aStruct.productVersion#) for your current Runtime License';
									}
									if (NOT (CGI.SERVER_NAME is aStruct.ServerName)) {
										if (Len(aReason) gt 0) {
											aReason = aReason & ' AND ';
										}
										aReason = aReason & 'the Domain Name (#CGI.SERVER_NAME#) does not match the expected Domain Name (#aStruct.ServerName#) for your current Runtime License';
									}
									aStruct = _aRuntimeLicenseStruct_(tagRuntimeLicenseInvalid(-1, aReason));
								}
							} else {
								sTxt = '';
								iElementCnt = 0;
								if (NOT IsDefined("aStruct.ColdfusionID")) {
									iElementCnt = iElementCnt + 1;
									sTxt = sTxt & 'ColdFusion Server ID';
								}
								if (NOT IsDefined("aStruct.computerID")) {
									if (Len(sTxt) gt 0) {
										sTxt = sTxt & ', ';
									}
									iElementCnt = iElementCnt + 1;
									sTxt = sTxt & 'Server Machine ID';
								}
								if (NOT IsDefined("aStruct.ProductName")) {
									if (Len(sTxt) gt 0) {
										sTxt = sTxt & ', ';
									}
									iElementCnt = iElementCnt + 1;
									sTxt = sTxt & 'Product Name';
								}
								if (NOT IsDefined("aStruct.productVersion")) {
									if (Len(sTxt) gt 0) {
										sTxt = sTxt & ', ';
									}
									iElementCnt = iElementCnt + 1;
									sTxt = sTxt & 'Product Version';
								}
								if (Len(sTxt) gt 0) {
									sPlural = '';
									if (iElementCnt gt 1) {
										sPlural = 's';
									}
									sTxt = sPlural & ': ' & sTxt;
								}
								aReason = 'the Runtime License is invalid due to missing the following data element' & sTxt;
								aStruct = _aRuntimeLicenseStruct_(tagRuntimeLicenseInvalid(-1, aReason));
							}
						}
					} catch (Any e) {
						ar = ListToArray(ezExplainError(e, false), Chr(13));
						n = ArrayLen(ar);
						for (i = 1; i lte n; i = i + 1) {
							ar[i] = Trim(ar[i]);
						}
						sTxt = ArrayToList(ar, ' ');
						aReason = 'an Error occurred while the Runtime License was being read (#sTxt#)';
						aStruct = _aRuntimeLicenseStruct_(tagRuntimeLicenseInvalid(-1, aReason));
					}
				}
			} else {
				aReason = 'the Runtime License is physically missing';
				aStruct = _aRuntimeLicenseStruct_(tagRuntimeLicenseInvalid(-1, aReason));
			}
			return _aRuntimeLicenseStruct(this.functionSignature);
		}
		
		function ezClusterizeURL(_url) {
			return "http://" & _clusterizeURL(_url);
		}

		function ezProcessComplexHTMLContent(html) {
			var i = -1;
			var t = '';
			var aStruct = StructNew();
			var ar = ListToArray(html, Chr(13));
			var n = ArrayLen(ar);
			var bool_insideStyleTags = false;
			var bool_insideScriptTags = false;

			aStruct.styleContent = '';
			aStruct.jsContent = '';
			aStruct.htmlContent = '';

			for (i = 1; i lte n; i = i + 1) {
				t = Trim(ar[i]);
				t = Replace(t, Chr(10), '', 'all');
				if (bool_insideStyleTags) {
					if (FindNoCase('<' & '/' & 'style>', t) gt 0) {
						bool_insideStyleTags = false;
						t = '';  // force the end of style tag to be removed from the data stream...
					}

					if (bool_insideStyleTags) {
						aStruct.styleContent = aStruct.styleContent & t & Chr(13);
						t = '';  // force the end of style tag to be removed from the data stream...
					}
				} else {
					if (FindNoCase('<' & 'style>', t) gt 0) {
						bool_insideStyleTags = true;
						t = '';  // force the end of style tag to be removed from the data stream...
					}
				}
				if (bool_insideScriptTags) {
					if (FindNoCase('<' & '/' & 'script>', t) gt 0) {
						bool_insideScriptTags = false;
						t = '';  // force the end of style tag to be removed from the data stream...
					}

					if (bool_insideScriptTags) {
						aStruct.jsContent = aStruct.jsContent & t & Chr(13);
						t = '';  // force the end of style tag to be removed from the data stream...
					}
				} else {
					if (FindNoCase('<' & 'script', t) gt 0) {
						bool_insideScriptTags = true;
						t = '';  // force the end of style tag to be removed from the data stream...
					}
				}
				if (Len(t) gt 0) {
					t = ezFilterQuotesForJS(t);
					aStruct.htmlContent = aStruct.htmlContent & t;
				}
			}
			aStruct.jsContent = obfuscateJScode(aStruct.jsContent);
			aStruct.styleContent = obfuscateJScode(aStruct.styleContent);
			return aStruct;
		}

		function ezRegisterQueryFromAJAX(qObj) {
			var tObj = -1;
			var aStruct = _aRuntimeLicenseStruct(this.functionSignature);
			var isCommunityEdition = true;
			
			try {
				isCommunityEdition = aStruct.isCommunityEdition;
			} catch (Any e) {
			}
			
			writeOutput(ezCFDump(aStruct, 'ezRegisterQueryFromAJAX :: aStruct, this.functionSignature = [#this.functionSignature#]', false));

			if (NOT IsDefined("Request.qryData")) {
				Request.qryData = ArrayNew(1);
				Request.qryData[ArrayLen(Request.qryData) + 1] = qObj;
			} else {
				if (IsArray(Request.qryData)) {
					Request.qryData[ArrayLen(Request.qryData) + 1] = qObj;
				} else {
					tObj = ArrayNew(1);
					tObj[ArrayLen(tObj) + 1] = Request.qryData;
					tObj[ArrayLen(tObj) + 1] = qObj;
					Request.qryData = tObj;
				}
				if ( (isCommunityEdition) AND (ArrayLen(Request.qryData) gt 1) ) {
					tObj = ArrayNew(1);
					tObj[ArrayLen(tObj) + 1] = Request.qryData[1];
					Request.qryData = tObj;
				}
			}
		}
		
		function ezFilePathFromUrlUsingCommonFolder(url, path, cName) {
			var _fpath = url;
			var i = FindNoCase(cName, _fpath);
			if (i gt 0) {
				_fpath = ReplaceNoCase(Right(_fpath, Len(_fpath) - (i + Len(cName))), '/', '\', 'all');
			}
			_fpath = ExpandPath(_fpath);
			if (NOT FileExists(_fpath)) {
				_fpath = ReplaceNoCase(_fpath, '\ezAjax\', '\');
			}
			return _fpath;
		}
	</cfscript>
</cfcomponent>