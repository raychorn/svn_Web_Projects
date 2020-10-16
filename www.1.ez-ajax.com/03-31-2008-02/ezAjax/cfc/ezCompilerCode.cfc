<cfcomponent displayname="ezCompilerCode" hint="(c). Copyright 1990-2006 Hierarchical Applications Limited, All Rights Reserved. The functions and data contained herein may only be used within the context of the ezAJAX&##8482 Framework Product, any other use is strictly forbidden." output="No" extends="geonosisSupport">
	<cfscript>
		const_HEX = "0123456789ABCDEF";
	</cfscript>

	<cffunction name="asHex" access="private" returntype="string">
		<cfargument name="ch" required="Yes" type="string">
		<cfscript>
		    var c = BitAnd(ch, 255);
			return Mid(const_HEX, BitAnd(BitSHRN(c, 4), 15) + 1, 1) & Mid(const_HEX, BitAnd(c, 15) + 1, 1);
		</cfscript>
	</cffunction>

	<cffunction name="decipher_func" access="private" returntype="string">
		<cfset var js_decipher_func = "">
		<cfsavecontent variable="js_decipher_func">
			<cfoutput>
				function d$(enc, p){ 
					var teks=''; 
					var ar = enc[0]; 
					var p_i=0;
					for (var i=0;i<ar.length;i+=2){ 
						teks+=String.fromCharCode(ar.substr(i,2).fromHex()^p.charAt(p_i)); 
						p_i++; 
						if (p_i >= p.length) { 
							p_i = 0; 
						}; 
					}
					return teks.URLDecode();
				};
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn js_decipher_func>
	</cffunction>

	<cffunction name="enkrip2" access="private" returntype="struct">
		<cfargument name="_jsCode" required="Yes" type="string">
		<cfscript>
			var kode1 = "";
			var kode2 = ArrayNew(1);
			var dop = "^";
			var key_i = 0;
			var ch = -1;
			var key = -1;
			var panjang = -1;
			var ticMark = "'";
			var ticMark2 = ticMark & ticMark;
			var aStruct = StructNew();
	
			aStruct.plaintext = _jsCode;
			if (IsDefined("aStruct.plaintext")) {
				kode1 = URLEncodedFormat(aStruct.plaintext);
				key_i = 1;
				ch = -1;
				if (NOT IsDefined("aStruct.parameter")) {
					aStruct.parameter = Replace(ezFilterIntForSQL(CreateUUID()), '-', '', 'all');
				}
				key = aStruct.parameter;
				if (NOT IsDefined("aStruct.metode")) {
					aStruct.const_metode_xor = 'xor';
					aStruct.metode = aStruct.const_metode_xor;
				}
				panjang = Len(kode1);
				for (i = 1; i lte panjang; i = i + 1)  {
					ch = BitXor(Asc(Mid(kode1, i, 1)), Mid(aStruct.parameter, key_i, 1));
					kode2[ArrayLen(kode2) + 1] = asHex(Int(ch));
					key_i = key_i + 1;
					if (key_i gt Len(key)) {
						key_i = 1;
					}
				}

				aStruct.ciphertext = 'var e$=[' & ticMark & ArrayToList(kode2, '') & ticMark & '];';
		
				aStruct.decipherFunc = jsMinifier(decipher_func());
				aStruct.decipher = 'var x$ = d$(e$,' & ticMark &  aStruct.parameter & ticMark & ');';
				aStruct.decipherNow = "try { eval(x$) } catch(e) { isSiteHavingProblems++; } finally { }; ";
	
				aStruct.input_length = Len(aStruct.plaintext);
				aStruct.enkrip_length = Len(aStruct.ciphertext);
				aStruct.diff_length = Len(aStruct.ciphertext) - Len(aStruct.plaintext);
			} else {
				aStruct.errorMsg = 'ERROR: Missing Variable known as aStruct.plaintext in function known as enkrip2().';
			}
			return aStruct;
		</cfscript>
	</cffunction>

	<cfscript>
		function obfuscateJSCode(jsIn) {
			var jsContentsOut = '';
			try {
				jsContentsOut = enkrip2(jsMinifier(jsIn));
			} catch (Any e) {
				ezCfLog('101. obfuscateJSCode() :: ERROR [#ezExplainErrorWithStack(e, false)#]');
			}
			jsContentsOut = standardCopyrightNotice() & jsContentsOut.ciphertext & ' ' & jsContentsOut.decipher & ' ' & jsContentsOut.decipherNow;
			return jsContentsOut;
		}

		function cleanUpJSCodeObfuscator(str) {
			var iPos = FindNoCase('function ', str);
			if (iPos gt 0) {
				str = Right(str, Len(str) - iPos + 1);
			}
			return str;
		}

		function readAndObfuscateJSCode(_jsName, useEnkrip2) {
			var _code = '';
			var countLOC = 0;
			var fileLOC = 0;
			var countAR = 0;
			var tStamp = Now();
			var _iName = ExpandPath('ezCompilerStats.ini');
			var jsName = ExpandPath(_jsName);
			if (NOT IsBoolean(useEnkrip2)) {
				useEnkrip2 = false;
			}
			Request.jsContentsIn = '';
			ezCfFileRead(jsName, 'Request.jsContentsIn');
			if ( (NOT Request.fileError) AND (FindNoCase('.dat', _jsName) eq 0) ) {
				try {
					if (FileExists(_iName)) {
						countLOC = GetProfileString(_iName, '@COUNT', 'LOC');
						tStamp = GetProfileString(_iName, '@COUNT', '@DATETIME');
						if (Len(tStamp) eq 0) {
							countLOC = 0;
						} else {
							secs = Abs(DateDiff('s', tStamp, Now()));
							if (secs gt 600) {
								countLOC = 0;
							}
						}
					}
					fileLOC = ListLen(Request.jsContentsIn, Chr(13));
					countLOC = countLOC + fileLOC;
					SetProfileString(_iName, '@COUNT', 'LOC', countLOC);
					SetProfileString(_iName, jsName, 'LOC', fileLOC);
					SetProfileString(_iName, '@COUNT', '@DATETIME', tStamp);
	//				SetProfileString(_iName, '@COUNT', 'DEBUG-SECS' & ', ' & jsName, secs);
	//				SetProfileString(_iName, '@COUNT', 'DEBUG-tStamp' & ', ' & jsName, tStamp);
				} catch (Any e) {
				}
				if (useEnkrip2) {
					Request.jsContentsOut = enkrip2(jsMinifier(Request.jsContentsIn));
					_code = Request.jsContentsOut.decipher & ' ' & Request.jsContentsOut.decipherNow;
					if (IsDefined("Request.jsCodeObfuscationDecoderAR")) {
						Request.jsCodeObfuscationDecoderAR[ArrayLen(Request.jsCodeObfuscationDecoderAR) + 1] = _code;
					}
					Request.jsContentsOut = standardCopyrightNotice() & Request.jsContentsOut.ciphertext;
				} else {
					Request.jsContentsOut = jsMinifier(Request.jsContentsIn);
					_code = '';
					if (IsDefined("Request.jsCodeObfuscationDecoderAR")) {
						Request.jsCodeObfuscationDecoderAR[ArrayLen(Request.jsCodeObfuscationDecoderAR) + 1] = _code;
					}
					Request.jsContentsOut = standardCopyrightNotice() & Request.jsContentsOut; // cleanUpJSCodeObfuscator();
				}
				return Request.jsContentsOut;
			}
			return Request.jsContentsIn;
		}
	</cfscript>
	
	<cffunction name="_obfuscateJSCode" access="private" returntype="string">
		<cfargument name="jsIn" required="Yes" type="string">
		<cfscript>
			return standardCopyrightNotice() & jsMinifier(jsIn);
		</cfscript>
	</cffunction>
		
</cfcomponent>
