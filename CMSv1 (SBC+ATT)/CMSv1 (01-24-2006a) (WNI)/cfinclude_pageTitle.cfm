<cfset _titleText = "">
<cfif currentPage eq homePage_symbol>
<cfelseif currentPage eq aboutPage_symbol>
	<cfset _titleText = "About">
<cfelseif currentPage eq faqPage_symbol>
	<cfset _titleText = "Frequently Asked Questions">
<cfelseif currentPage eq methodPage_symbol>
	<cfset _titleText = "PM Methodology">
<cfelseif currentPage eq expressProgramsProcPage_symbol>
	<cfset _titleText = "EXPRESS Process for Programs">
<cfelseif currentPage eq programMgtProcPage_symbol>
	<cfset _titleText = "Program Management Procedure">
<cfelseif currentPage eq pmRoleDefinitionPage_symbol>
	<cfset _titleText = "Project Management Role Definitions">
<cfelseif currentPage eq professionalDevelopmentPage_symbol>
	<cfset _titleText = "Professional Development">
<cfelseif currentPage eq pmHiringProcedurePage_symbol>
	<cfset _titleText = "Project Management Hiring Procedure">
<cfelseif currentPage eq pmControlsPage_symbol>
	<cfset _titleText = "Project Management Controls">
<cfelseif currentPage eq sapxRPMPage_symbol>
	<cfset _titleText = "SAP xRPM Program">
</cfif>

<cfif (IsDefined("GetCurrentContent")) AND (GetCurrentContent.recordCount gt 0) AND (IsDefined("GetCurrentContent.PageTitle"))>
	<cfset _titleText = commonCode.PageTitle( GetCurrentContent, _titleText)>
<cfelseif (IsDefined("GetEditableContent")) AND (GetEditableContent.recordCount gt 0) AND (IsDefined("GetEditableContent.PageTitle"))>
	<cfset _titleText = commonCode.PageTitle( GetEditableContent, _titleText)>
</cfif>

<cfset Request._title = "">
<cfif Len(_titleText) gt 0>
	<cfset Request._title = Request._title & " - #_titleText#">
</cfif>
