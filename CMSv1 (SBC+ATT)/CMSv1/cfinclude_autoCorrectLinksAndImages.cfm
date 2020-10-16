<cfoutput>
	<cfif (Len(Trim(_onloadMethod)) eq 0)>
		<cfscript>
			function linkContext(_href) {
				var CGI_SCRIPT_NAME = '';
				var _endTok = GetFileFromPath(_href);
				if (Len(Trim(_endTok)) gt 0) {
					_href = ReplaceNoCase(_href, _endTok, '');
					CGI_SCRIPT_NAME = ReplaceNoCase(CGI.SCRIPT_NAME, _endTok, '');
				}
				return CGI_SCRIPT_NAME;
			}
			
			_context_ = linkContext(CGI.SCRIPT_NAME);
			_context = "'#_context_#'";
			_images_context = "'#_images_folder#'";
		</cfscript>
	
		<cfoutput>
			<script language="JavaScript1.2" type="text/javascript">
			<!--
				_autoCorrect_context = '#_context_#';
				_autoCorrect_images_context = '#_images_folder#';
			-->
			</script>
		</cfoutput>

		<cfset js_isServerLocal = "false">
		<cfif (CommonCode.isServerLocal())>
			<cfset js_isServerLocal = "true">
		</cfif>
		#CommonCode.register_onload_function("_autoCorrectLinksAndImages(#_context#, #_images_context#, null, #js_isServerLocal#);")#
	
	</cfif>
</cfoutput>
