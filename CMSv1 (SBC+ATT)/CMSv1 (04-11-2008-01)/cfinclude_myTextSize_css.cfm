<cfif (_ReleaseMode eq 1) OR (CommonCode.is_htmlArea_editor())>
	<cfset _left = "350px">
	<cfset _top = "0px">
	<cfif (_ReleaseMode eq 1)>
		<cfset _left = "750px">
		<cfset _top = "5px">
	<cfelseif (CommonCode.is_htmlArea_editor())>
		<cfset _left = "750px">
		<cfset _top = "5px">
	</cfif>
	<style type="text/css">		<!--
	div#myTextSize {
		text-align: center;
		position: absolute;
		margin-bottom: 10px;
		left: <cfoutput>#_left#</cfoutput>;
		top: <cfoutput>#_top#</cfoutput>;
	}
	div#myTextSize a {
		padding:1px 1px 2px 1px;
		font-size:80%;
		color:#fefefe;
		background:#660033;
		cursor:pointer;
	}
	-->
	</style>
</cfif>
