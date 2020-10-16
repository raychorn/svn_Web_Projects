<cfcomponent displayname="ajaxCode" output="Yes" extends="commonCode">
	<cfscript>
		function registerQueryFromAJAX(qObj) {
			var tObj = -1;

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
					Request.qryData = qObj;
				}
			}
		}
	</cfscript>
</cfcomponent>
