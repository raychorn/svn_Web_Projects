<cfscript>
	cf_const_Objects_symbol = '[?Objects]';
	'cf_const_getCLASSES_symbol' = 'getCLASSES';
	'cf_const_chgAttrsForObject_symbol' = 'chgAttrsForObject';
	'cf_const_chgDataForObject_symbol' = 'chgDataForObject';
	'cf_const_getOBJECTS_symbol' = 'getOBJECTS';
	'cf_const_addClassDef_symbol' = 'addClassDef';
	'cf_const_dropClassDef_symbol' = 'dropClassDef';
	'cf_const_addObject_symbol' = 'addObject';
	'cf_const_dropObject_symbol' = 'dropObject';
	'cf_const_addAttribute_symbol' = 'addAttribute';
	'cf_const_dropAttribute_symbol' = 'dropAttribute';
	'cf_const_getAttributesForOBJECT_symbol' = 'getAttributesForOBJECT';
	'cf_const_getLinkedObjects_symbol' = 'getLinkedObjects';
	'cf_const_checkLinkedObjects_symbol' = 'checkLinkedObjects';
	
	Request.commonCode.registerCFtoJS_variable('cf_const_Objects_symbol', cf_const_Objects_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_getCLASSES_symbol', cf_const_getCLASSES_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_chgAttrsForObject_symbol', cf_const_chgAttrsForObject_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_chgDataForObject_symbol', cf_const_chgDataForObject_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_getOBJECTS_symbol', cf_const_getOBJECTS_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_addClassDef_symbol', cf_const_addClassDef_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_dropClassDef_symbol', cf_const_dropClassDef_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_addObject_symbol', cf_const_addObject_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_dropObject_symbol', cf_const_dropObject_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_addAttribute_symbol', cf_const_addAttribute_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_dropAttribute_symbol', cf_const_dropAttribute_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_getAttributesForOBJECT_symbol', cf_const_getAttributesForOBJECT_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_getLinkedObjects_symbol', cf_const_getLinkedObjects_symbol);
	Request.commonCode.registerCFtoJS_variable('cf_const_checkLinkedObjects_symbol', cf_const_checkLinkedObjects_symbol);
	
	Request.commonCode.emitCFtoJS_variables();
</cfscript>

<cfoutput>
	<script language="JavaScript1.2" type="text/javascript">
	<!--
		var global_dict = ezDictObj.get$();

		oAJAXEngine.timeout = 120;
		oAJAXEngine.hideFrameCallback = function () { /*ezAlert('oAJAXEngine.hideFrameCallback()');*/ };
		oAJAXEngine.showFrameCallback = function () { /*ezAlert('oAJAXEngine.showFrameCallback()');*/ };
		
		oAJAXEngine.createAJAXEngineCallback = function () { this.top = '400px'; /*ezAlert('oAJAXEngine.createAJAXEngineCallback()');*/ };
			
		oAJAXEngine.create();

		var bool_isServerProduction = ((window.location.href.toUpperCase().indexOf('.ez-ajax.com'.toUpperCase()) > -1) ? true : false);

		oAJAXEngine.isXmlHttpPreferred = ((bool_isServerProduction) ? true : false);

		function ezWindowOnLoadCallback() {
			initAJAXEngine(oAJAXEngine); // oAJAXEngine is the name of the default JavaScript variable that automatically contains a pointer to the default exAJAX<sup>(tm)</sup> Engine... You may create additional instances of the exAJAX<sup>(tm)</sup> Engine as desired however it is not necessary to create more than one instane for this object.
	//		ezAlert('ezWindowOnLoadCallback() - This is the exAJAX<sup>(tm)</sup> Community Framework callback that tells you that the exAJAX<sup>(tm)</sup> Engine has been initialized and is ready to process commands.');
		}

		function ezWindowOnUnloadCallback() {
	//		ezAlert('ezWindowOnUnloadCallback()');
		}
				
		function ezWindowOnReSizeCallback(_width, _height) {
	//		ezAlert('ezWindowOnReSizeCallback(' + _width + ', ' + _height + ')');
		}
	
		function ezWindowOnscrollCallback(top, left) {
			var bool_isDebugPanelRepositionable = false;
	//		ezAlert('ezWindowOnscrollCallback(' + top + ', ' + left + ')' + ', bool_isDebugPanelRepositionable = [' + bool_isDebugPanelRepositionable + ']');
			return bool_isDebugPanelRepositionable;
		}
		
	//  You may notice that when the following function is uncommented the simplerHandleSampleAJAXCommand function fails with an Error
	//  and this is to be expected since the following method disables the processing the ezAJAXEngine performs when handling the 'simpler'
	//  method. 
	//	ezAJAXEngine.receivePacketMethod = function() {
	//		ezAlert('ezAJAXEngine.receivePacketMethod() - User-Defined');
	//		return '';
	//	}

		function handleSampleAJAXCommand(qObj) {
			// Each AJAX Command Call-Back Function is pre-handled by an Abstract handler that performs all of the actions you will see below.
			// You, as the programmer, are left with the choice to use the coding pattern you see below which uses only the qObj argument OR
			// you may use the separate arguments of nRecs, qStats, argsDic and qData1 which were pulled from the qObj argument as separate
			// values.  See the simplerHandleSampleAJAXCommand() function below in this source file to see how the simpler method works as
			// compared with this slightly more complex method.  Both functions perform the same actions however the 
			// simplerHandleSampleAJAXCommand() function requires much less code and therefore is easier to use in keeping with the theme
			// of this product.
			var nRecs = -1;
			var oParms = -1;
			var argsDict = ezDictObj.get$();
			var aDict = -1;
			var html = '';

			function searchForArgRecs(_ri, _dict) {
				// This function is known as an interator.  You can use iterator functions to perform Query of Queries.
				// Each Record in the Query Object is passed to the Iterator function as shown above.
				// The _ri argument is the Record Index which is to say this is the Record Number or Row Index within the Query Object.
				// The _dict is an instance of a Dictionary Object that holds the whole Record for the Row Index from the Query Object.
				var n = _dict.getValueFor('NAME');
				var v = _dict.getValueFor('VAL');
				if (n.ezTrim().toUpperCase().indexOf('ARG') != -1) {
					argsDict.push(n.ezTrim(), v);
				}
			};

			function searchForStatusRecs(_ri, _dict) {
				if (aDict == -1) {
					aDict = ezDictObj.get$(_dict.asQueryString());
				}
			};
	ezAlert('handleSampleAJAXCommand :: qObj = [' + qObj + ']');
			var qStats = qObj.named('qDataNum');
			if (!!qStats) {
				nRecs = qStats.dataRec[1];
			}
			if (nRecs > 0) {
				var qData1 = qObj.named('qData1');
				if (!!qData1) {
					oParms = qObj.named('qParms');
					if (!!oParms) {
						oParms.iterateRecObjs(searchForArgRecs);
						qData1.iterateRecObjs(anyErrorRecords);

						if (!bool_isAnyErrorRecords) {
							argsDict.intoNamedArgs();

							qData1.iterateRecObjs(searchForStatusRecs);

							if (aDict != -1) {
								ezAlert('aDict = [' + aDict + ']');
							}
						} else {
							if (bool_isHTMLErrorRecords) {
								ezAlertHTMLError(s_explainError);
							} else {
								ezAlertError(s_explainError);
							}
						}
					}
				}
			}
			ezDictObj.remove$(argsDict.id);
		}

		function simplerHandleSampleAJAXCommand(qObj, nRecs, qStats, argsDict, qData1) {
			// Each AJAX Command Call-Back Function is pre-handled by an Abstract handler that performs all of the actions you will see below.
			// You, as the programmer, may use the separate arguments of nRecs, qStats, argsDic and qData1 which were pulled from the 
			// qObj argument as separate values.  See the handleSampleAJAXCommand() function above in this source file to see how the 
			// less-simple method works as compared with this simpler method.  Both functions perform the same actions however the 
			// handleSampleAJAXCommand() function requires much more code and therefore is not as easy to use.
			var aDict = -1;
			
			function searchForStatusRecs(_ri, _dict, _rowCntName) {
				if (aDict == -1) {
					aDict = ezDictObj.get$(_dict.asQueryString()); // This is the easy method for making a copy of a Dictionary Object instance.
				}
			};

			nRecs = ((nRecs != null) ? nRecs : -1);
			ezAlert('simplerHandleSampleAJAXCommand :: nRecs = [' + nRecs + ']');

			if (!!qStats) {
				ezAlert('simplerHandleSampleAJAXCommand :: qStats = [' + qStats + ']');

				if (!!argsDict) {
					ezAlert('simplerHandleSampleAJAXCommand :: argsDict = [' + argsDict + ']');

					if (!!qData1) {
						qData1[0].iterateRecObjs(searchForStatusRecs);
						ezAlert('simplerHandleSampleAJAXCommand :: qData1 = [' + qData1 + ']');
					} else {
						ezAlertError('Error - qData1 has an invalid value.');
					}
		
					ezDictObj.remove$(argsDict.id);
				} else {
					ezAlertError('Error - argsDict has an invalid value.');
				}
			} else {
				ezAlertError('Error - qStats has an invalid value.');
			}
		}
	// -->
	</script>
	
	<cfsavecontent variable="_code">
		<cfoutput>
			<cfscript>
				Request.commonCode.emitCFtoJS_variables();
			</cfscript>
		</cfoutput>
	</cfsavecontent>

<cfif 1>
	<table width="100%" border="1" cellpadding="-1" cellspacing="-1">
		<cfscript>
			if (err_ajaxCode) {
				writeOutput('<tr><td><font color="red"><b>#err_ajaxCodeMsgHtml#</b></font><br>');
				writeOutput(Request.commonCode.ezExplainErrorWithStack(e, false));
				writeOutput('</td></tr>');
			}
		</cfscript>
	<cfif 0>
		<tr>
			<td>
				<textarea readonly rows="20" cols="100" class="textClass">#_code#</textarea>
			</td>
		</tr>
	</cfif>
		<tr>
			<td>
				<button name="btn_getContents" id="btn_getContents" class="buttonMenuClass" onclick="this.disabled = true; oAJAXEngine.addNamedContext(js_const_Objects_symbol, ''); oAJAXEngine.doAJAX('performGetGeonosisClasses', 'displayClassesBrowser'); return false;">#cf_const_Objects_symbol#</button>
			</td>
		</tr>
	</table>

	<div id="div_contentHome" style="position: absolute; top: 50px; left: 0px; width: 990px;">
	</div>
<cfelse>
	<table width="100%" align="left" border="0">
		<tr>
			<td>
				<table width="100%" align="left" border="0">
					<tr>
						<td>
							<table width="100%" align="left" border="0">
								<tr>
									<td align="left" valign="middle">
										<button class="buttonMenuClass<cfif (Request.commonCode.ezIsBrowserFF() OR Request.commonCode.ezIsBrowserNS())>FF</cfif>" onclick="oAJAXEngine.doAJAX('sampleAJAXCommand', 'handleSampleAJAXCommand', 'parm1', 'parm1-value', 'parm2', 'parm2-value', 'parm3', 'parm3-value', 'parm4', 'parm4-value'); return false;">Click to Test the exAJAX#cf_trademarkSymbol# Community Framework</button>
									</td>
								</tr>
								<tr>
									<td align="left" valign="middle">
										<button class="buttonMenuClass<cfif (Request.commonCode.ezIsBrowserFF() OR Request.commonCode.ezIsBrowserNS())>FF</cfif>" onclick="oAJAXEngine.doAJAX('sampleAJAXCommand', 'simplerHandleSampleAJAXCommand', 'parm1', 'parm1-value', 'parm2', 'parm2-value', 'parm3', 'parm3-value', 'parm4', 'parm4-value'); return false;">Click to Test the exAJAX#cf_trademarkSymbol# Community Framework (simpler)</button>
									</td>
								</tr>
							</table>
						</td>
						<td align="left" valign="top">
							<p align="justify" style="font-size: 10px">When you press the button to the left the exAJAX#cf_trademarkSymbol# Community Framework will engage and process the AJAX Command stream and then return a Query Object from the ColdFusion AJAX Server.  You will see a pop-up window with the title of "DEBUG" that shows a typical debugging display for the Query Objects that are returned from the exAJAX#cf_trademarkSymbol# Community Framework.</p>
							<p align="justify" style="font-size: 10px">The exAJAX#cf_trademarkSymbol# Community Framework is limited by the number of ColdFusion Query Objects that can be returned from the AJAX Server.  You may purchase a Runtime License for the exAJAX#cf_trademarkSymbol# Community Framework to remove this and other limitations.  Upgrade to the exAJAX#cf_trademarkSymbol# Enterprise Framework to achieve greater performance than is possible using the exAJAX#cf_trademarkSymbol# Community Framework.</p>
							<p align="justify" style="font-size: 10px">The Trial version of the exAJAX#cf_trademarkSymbol# Community Framework will time-out and cease to function when your trial period ends however you may simply purchase a Runtime License from us to unlock the full functionality of the exAJAX#cf_trademarkSymbol# Community Framework.</p>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2"><p align="justify" style="font-size: 10px"><a href="#_urlCommunityEditionLicenseAgreement#" target="_blank">exAJAX#cf_trademarkSymbol# Community Edition License Agreement</a></p></td>
		</tr>
		<tr>
			<td align="center" colspan="2"><p align="justify" style="font-size: 10px"><a href="#_urlCommunityEditionProgrammersGuide#" target="_blank">exAJAX#cf_trademarkSymbol# Community Edition Programmer's Guide</a></p></td>
		</tr>
		<tr>
			<td align="center" colspan="2"><p align="justify" style="font-size: 10px"><a href="http://www.ez-ajax.com" target="_blank">Click HERE to purchase your Long-Term License for exAJAX#cf_trademarkSymbol# Community Edition</a></p></td>
		</tr>
	</table>
</cfif>	

</cfoutput>
