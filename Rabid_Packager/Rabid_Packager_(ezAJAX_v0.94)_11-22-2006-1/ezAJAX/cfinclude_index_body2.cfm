<cfinclude template="cfinclude_constants.cfm">
<cfscript>
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
	//		ezAlert('ezAJAXEngine.receivePacketMethod fired !');
			return false; // return an empty string here to cause the less simple method to be used...
		}

		var stack_current_span_inEdit = [];
		
		var stack_addClass_inEdit = [];
		var stack_addObject_inEdit = [];
		var	stack_addAttribute_inEdit = [];
		
		var cache_input_associations = [];
		
		var objectsMetaDataStack = [];
		var objectAttributesMetaDataStack = [];
		var objectClassDefinitionsMetDataStack = [];

		function displayClassesBrowser(qObj, argsDict) {
			var i = -1;
			var qData = -1;
			var nRecs = -1;
			var oParms = -1;
			var oGeonosis = -1;
			var _contextName = js_const_Objects_symbol;
			var _html = '';
			var width_of_class_panel = 200;
			var aDict = ezDictObj.get$();
			

			function searchForSomeRecs(_ri, _dict) {
	//			ezAlert('searchForSomeRecs :: ' + '_ri = [' + _ri + ']' + ', _dict = [' + _dict + ']');
				var _HTMLCONTENT = _dict.getValueFor('HTMLCONTENT');
				if (!!_HTMLCONTENT) {
					aDict.push('HTMLCONTENT', _HTMLCONTENT);
				}
			};
			
			function populateForSomeClasses(_ri, _dict) {
	//			ezAlert('populateForSomeClasses :: ' + '_ri = [' + _ri + ']' + ', _dict = [' + _dict + ']');
				var _CLASSNAME = _dict.getValueFor('CLASSNAME');
				var _OBJECTCLASSID = _dict.getValueFor('OBJECTCLASSID');
				var anObj = _$('selection_classBrowser');
				if ( (!!_CLASSNAME) && (!!_OBJECTCLASSID) && (!!anObj) ) {
					var opt = new Option(_CLASSNAME, _OBJECTCLASSID);
					try { anObj.add(opt,null); } catch (e) { anObj.add(opt); };
					var n = anObj.options.length;
					anObj.size = ((n > 20) ? 20 : n);
					anObj.selectedIndex = -1;
				}
			};

	//		ezAlert('displayClassesBrowser :: qObj = [' + qObj + ']');
					
			global_dict.init(); // clear-out the parms from the previous AJAX call otherwise they just build-up and that's not so helpful...
		
			var qStats = qObj.named('qDataNum');
	//		ezAlert('qStats = [' + qStats + ']');
			if (!!qStats) {
				nRecs = qStats.dataRec[1];
			}
	//		ezAlert('+++ nRecs = [' + nRecs + ']');
			if (nRecs > 0) {
				var bcAR = [];
	//			ezAlert('argsDict = [' + argsDict + ']');
				if (!!argsDict) {
					var bc = argsDict.getValueFor('breadCrumbs');
					if (!!bc) {
						if (typeof bc == const_object_symbol) {
							bc = bc[0];
						}
						bc = ((!!bc) ? bc.ezURLDecode() : '').ezURLDecode();
						if (bc.length > 0) {
							bcAR = bc.split(',');
						}
					}
				}
		
	//			ezAlert('qObj = [' + qObj + ']');
		
				qData = qObj.named('qData1');
	//			ezAlert('qData = [' + qData + ']');
				qData.iterateRecObjs(anyErrorRecords);
				if (!bool_isAnyErrorRecords) {
					var qSchema = qObj.named('qMetaDataForObjectClassDefs');
					if (!!qSchema) {
						objectClassDefinitionsMetDataStack.push(qSchema);
					}
		
					stack_addClass_inEdit = []; // initialize this or bad evil things will happen...
					
					var cObj = _$('div_contentHome');
	//				ezAlert('cObj = [' + cObj + ']');
					if (!!cObj) {
						cObj.style.width = ezClientWidth();
						cObj.style.height = ezClientHeight();
			
						var qContent = qObj.named('qContent');
						try { qContent.iterateRecObjs(searchForSomeRecs); } catch (e) { ezAlert('211.1 ' + ezErrorExplainer(e)); };
						try { aDict.intoNamedArgs(); } catch (e) { ezAlert('211.2 ' + ezErrorExplainer(e)); };
						var someContent = aDict.getValueFor('HTMLCONTENT');
	//					ezAlert('aDict = [' + aDict + ']');
						someContent = ((typeof someContent) == const_string_symbol ? someContent : '');
						cObj.innerHTML = someContent;

						var divObj = _$('div_classesBrowser');
						if (!!divObj) {
							var qData1 = qObj.named('qData1');
							divObj.innerHTML = '<select id="selection_classBrowser" onchange="oAJAXEngine.doAJAX(\'performGetGeonosisObjects\', \'handle_ezAJAXCallBack\', \'CLASSNAME\', this.options[this.selectedIndex].text.toString().ezURLEncode(), \'hasMetaData\', \'false\'.ezURLEncode());" class="textClass" style="width: 400px;"></select>';
							try { qData1.iterateRecObjs(populateForSomeClasses); } catch (e) { ezAlert('211.3 ' + ezErrorExplainer(e)); };
						}
					}
				}
			}
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
	//		ezAlert('handle_ezAJAXCallBack :: qObj.names = [' + qObj.names + ']');
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
							try {
								displayClassesBrowser(qObj, argsDict);
							} catch (e) { ezAlert('111.1 (' + _ezCFM + ') realQueryObjectNames = [' + realQueryObjectNames + ']\n' + ezErrorExplainer(e)); };
	//						ezAlert('(' + _ezCFM + ') realQueryObjectNames = [' + realQueryObjectNames + ']');
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

	<table id="table_masterTable" width="100%" border="1" cellpadding="-1" cellspacing="-1" style="display: inline;">
		<cfscript>
			if (err_ajaxCode) {
				writeOutput('<tr><td><font color="red"><b>#err_ajaxCodeMsgHtml#</b></font><br>');
				writeOutput(Request.commonCode.ezExplainErrorWithStack(e, false));
				writeOutput('</td></tr>');
			}
		</cfscript>
		<tr>
			<td>
				<button name="btn_getContents" id="btn_getContents" class="buttonMenuClass" onclick="this.disabled = true; var oO = _$('table_masterTable'); if (!!oO) { oO.style.display = const_none_style; }; oAJAXEngine.doAJAX('performGetGeonosisClasses', 'handle_ezAJAXCallBack'); return false;" style="cursor:hand; cursor:pointer;"><table cellpadding="1" cellspacing="1"><tr><td><small>Get Classes</small></td><td><img src="images/Geonosis/32x32/small-icons.gif" title="#cf_const_Objects_symbol# - Get Objects" border="0"></td></tr></table></button>
			</td>
		</tr>
	</table>

	<div id="div_contentHome" style="position: absolute; top: 50px; left: 0px; width: 990px;">
	</div>

</cfoutput>
