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
		
		ezAJAXEngine.receivePacketMethod = function() {
			return ''; // return an empty string here to cause the less simple method to be used...
		}

		function handle_ezAJAXCallBack(qObj) {
			var nRecs = -1;
			var oParms = -1;
			var argsDict = ezDictObj.get$();
			var aDict = -1;
			var html = '';
			var i = -1;

			function searchForArgRecs(_ri, _dict) {
				var n = _dict.getValueFor('NAME');
				var v = _dict.getValueFor('VAL');
				if ( (!!n) && (!!v) ) {
					argsDict.push(n.ezTrim(), v);
				}
			};

			function searchForStatusRecs(_ri, _dict) {
				if (aDict == -1) {
					aDict = ezDictObj.get$(_dict.asQueryString());
				}
			};
			ezAlert('handle_ezAJAXCallBack :: qObj.names = [' + qObj.names + ']');
	//		ezAlert('qObj = [' + qObj + ']');
			var qStats = qObj.named('qDataNum');
			if (!!qStats) {
				nRecs = qStats.dataRec[1];
			}
			if (nRecs > 0) {
				oParms = qObj.named('qParms');
				if (!!oParms) {
					oParms.iterateRecObjs(searchForArgRecs);
					try { argsDict.intoNamedArgs(); } catch (e) {};
				}

				var aName = -1;
				var realQueryObjectNames = [];
				var qData1 = -1;
				for (i = 0; i < qObj.names.length; i++) {
					aName = qObj.names[i];
					qData1 = qObj.named(aName);
					if (!!qData1) {
						qData1.iterateRecObjs(anyErrorRecords);
						if ( (aName != 'qDataNum') && (aName != 'qParms') ) {
							realQueryObjectNames.push(aName);
						}
					}
				}
				if (!bool_isAnyErrorRecords) {
					var _ezCFM = argsDict.getValueFor('ezCFM');
					switch (_ezCFM) {
						case 'performGetGeonosisClasses':
							ezAlert('(' + _ezCFM + ') realQueryObjectNames = [' + realQueryObjectNames + ']');
						break;
						
						default:
							ezAlert('(UNDEFINED) _ezCFM = [' + _ezCFM + ']');
						break;
					}
				} else {
					if (bool_isHTMLErrorRecords) {
						ezAlertHTMLError(s_explainError);
					} else {
						ezAlertError(s_explainError);
					}
				}
			}
			ezDictObj.remove$(argsDict.id);
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
				<button name="btn_getContents" id="btn_getContents" class="buttonMenuClass" onclick="this.disabled = true; oAJAXEngine.doAJAX('performGetGeonosisClasses', 'handle_ezAJAXCallBack'); return false;">#cf_const_Objects_symbol#</button>
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
