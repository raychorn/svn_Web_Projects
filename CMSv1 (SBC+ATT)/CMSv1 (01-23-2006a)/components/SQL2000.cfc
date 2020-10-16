<cfcomponent extends="commonCode" displayname="SQL2000">

	<cfscript>
		_requiredTablesList = 'ContentList,ContentSecurity,DynamicHTMLContent,DynamicHTMLfooter,DynamicHTMLmenu,DynamicHTMLpad,DynamicHTMLright_side,DynamicHTMLsepg_links,DynamicHTMLsepg_section,DynamicLayoutSpecification,DynamicPageManagement,DynamicSiteManagement,LayoutManagement,MarqueeScrollerData,MenuEditorAccess,ReleaseActivityLog,ReleaseManagement,ReleaseManagementComments,SubsystemList,SubsystemSecurity,UserSecurity';

		function requiredTablesList() {
			return _requiredTablesList;
		}
		
		function requiredPrefixedTablesList(p_prefix) {
			var i = -1;
			var _item = '';
			var new_list = '';
			var old_list = '';
			
			old_list = requiredTablesList();
			for (i = 1; i lte ListLen(old_list, ','); i = i + 1) {
				_item = GetToken(old_list, i, ',');
				new_list = new_list & p_prefix & _item;
				if (i lt ListLen(old_list, ',')) {
					new_list = new_list & ',';
				}
			}
			return new_list;
		}
		
		function makeTablePrefixCorrect(p_prefix) {
			var s = '';
			var i = -1;
			var _ch = '';
			
			p_prefix = Trim(p_prefix);
			for (i = 1; i lte Len(p_prefix); i = i + 1) {
				_ch = Mid(p_prefix, i, 1);
				if (isAlphaNumeric(_ch)) {
					s = s & _ch;
				}
			}
			return UCASE(s);
		}

		function enumerateDbTables(cc, _dsn_username, _dsn_password, _dsn) {
			var _SQL_statement = '';
			var q = -1;

			_SQL_statement = "exec sp_tables @table_type = " & '"' & "'TABLE'" & '"';
			q = cc.safelyExecSQL(_dsn_username, _dsn_password, _dsn, _SQL_statement, CreateTimeSpan(0, 0, 0, 0));
			return q;
		}

		function verifyRequiredTables(q, _list) {
			var i = -1;
			var lst = _list;
			var vName = '';
			var vVal = '';
			var vOwnerName = '';
			var vOwnerVal = '';
			var j = -1;
			var _sites = '';
			var _sub_sites = '';
			var _prefix = '';
			var q_verify = -1;
	
			q_verify = QueryNew('sites, sub_sites, lst');
			QueryAddRow(q_verify, 1);

			if ( (IsQuery(q_verify)) AND (IsQuery(q)) AND (IsDefined("q.recordCount")) ) {
				if (q.recordCount gt 0) {
					for (i = 1; i lte q.recordCount; i = i + 1) {
						vName = "q.#Request.const_TABLE_NAME_symbol#[#i#]";
						vVal = '';
						try {
							vVal = Trim(Evaluate(vName));
						} catch (Any e) {
						}
						vOwnerName = "q.#Request.const_TABLE_OWNER_symbol#[#i#]";
						vOwnerVal = '';
						try {
							vOwnerVal = LCase(Trim(Evaluate(vOwnerName)));
						} catch (Any e) {
						}
						if ( (Len(vVal) gt 0) AND (vOwnerVal eq LCase(Request.const_TABLE_OWNER_DBO_symbol)) ) {
							j = ListFindNoCase(lst, vVal, ',');
	
							if (j gt 0) {
								lst = ListDeleteAt(lst, j, ',');
							}
							if (ListLen(vVal, '_') eq 2) {
								_prefix = GetToken(vVal, 1, '_');
								if ( (ListFindNoCase(_sub_sites, _prefix, ',') eq 0) AND (ListFindNoCase(Request.special_tables_list, vVal, ',') eq 0) ) {
									_sub_sites = ListAppend(_sub_sites, _prefix, ',');
								}
							}
						}
					}
				}
			}
			j = ListFindNoCase(lst, 'DynamicSiteManagement', ',');
			if (j gt 0) {
				lst = ListDeleteAt(lst, j, ',');
			}
			if (Len(Trim(lst)) eq 0) {
				_sites = ListAppend(_sites, 'Primary Site Tables', ',');
			}
			QuerySetCell(q_verify, 'sites', _sites, q_verify.recordCount);
			QuerySetCell(q_verify, 'sub_sites', _sub_sites, q_verify.recordCount);
			return q_verify;
		}
	</cfscript>

	<cffunction name="ddl_ContentList" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#ContentList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#ContentList] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pageName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_ContentSecurity" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#ContentSecurity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#ContentSecurity] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pid] [int] NOT NULL ,
				[uid] [int] NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicHTMLContent" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicHTMLContent]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicHTMLContent] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pageId] [int] NOT NULL ,
				[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[rid] [int] NOT NULL 
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicHTMLfooter" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicHTMLfooter]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicHTMLfooter] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pageId] [int] NOT NULL ,
				[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[rid] [int] NOT NULL 
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicHTMLmenu" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicHTMLmenu]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicHTMLmenu] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pageId] [int] NOT NULL ,
				[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[rid] [int] NOT NULL 
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicHTMLpad" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicHTMLpad]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicHTMLpad] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pageId] [int] NOT NULL ,
				[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[rid] [int] NOT NULL 
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicHTMLright_side" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicHTMLright_side]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicHTMLright_side] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pageId] [int] NOT NULL ,
				[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[rid] [int] NOT NULL 
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicHTMLsepg_links" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicHTMLsepg_links]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicHTMLsepg_links] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pageId] [int] NOT NULL ,
				[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[rid] [int] NOT NULL 
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicHTMLsepg_section" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicHTMLsepg_section]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicHTMLsepg_section] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pageId] [int] NOT NULL ,
				[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[rid] [int] NOT NULL 
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicLayoutSpecification" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicLayoutSpecification]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicLayoutSpecification] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[layout_vc] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[rid] [int] NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicPageManagement" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicPageManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicPageManagement] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[pageId] [int] NOT NULL ,
				[pageName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[PageTitle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[versionDateTime] [datetime] NULL ,
				[rid] [int] NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_DynamicSiteManagement" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#DynamicSiteManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#DynamicSiteManagement] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[site_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_LayoutManagement" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#LayoutManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#LayoutManagement] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[layout_name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[layout_spec] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_MarqueeScrollerData" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#MarqueeScrollerData]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#MarqueeScrollerData] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[headline] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[article_text] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[begin_dt] [datetime] NULL ,
				[end_dt] [datetime] NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_MenuEditorAccess" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#MenuEditorAccess]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#MenuEditorAccess] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[uid] [int] NOT NULL ,
				[d_locked] [datetime] NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_ReleaseActivityLog" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#ReleaseActivityLog]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#ReleaseActivityLog] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[rid] [int] NOT NULL ,
				[dateTime] [datetime] NOT NULL ,
				[comments] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_ReleaseManagement" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#ReleaseManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#ReleaseManagement] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[releaseNumber] [int] NOT NULL ,
				[uid] [int] NULL ,
				[layout_id] [int] NULL ,
				[devDateTime] [datetime] NULL ,
				[stageDateTime] [datetime] NULL ,
				[prodDateTime] [datetime] NULL ,
				[archDateTime] [datetime] NULL ,
				[comments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_ReleaseManagementComments" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#ReleaseManagementComments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#ReleaseManagementComments] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[rid] [int] NOT NULL ,
				[aDateTime] [datetime] NOT NULL ,
				[comments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_SubsystemList" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#SubsystemList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#SubsystemList] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[subsystem_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_SubsystemSecurity" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#SubsystemSecurity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#SubsystemSecurity] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[sid] [int] NOT NULL ,
				[uid] [int] NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_UserSecurity" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			if not exists (select * from dbo.sysobjects where id = object_id(N'[#p_owner#].[#p_prefix#UserSecurity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 BEGIN
			CREATE TABLE [#p_owner#].[#p_prefix#UserSecurity] (
				[id] [int] IDENTITY (1, 1) NOT NULL ,
				[userid] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[user_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
				[user_phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
			) ON [PRIMARY]
			END
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_Constraints_ContentList" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			ALTER TABLE [#p_owner#].[#p_prefix#ContentList] WITH NOCHECK ADD 
				CONSTRAINT [PK_#p_prefix#ContentList] PRIMARY KEY  CLUSTERED 
				(
					[pageName]
				)  ON [PRIMARY] 
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_Constraints_DynamicSiteManagement" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			ALTER TABLE [#p_owner#].[#p_prefix#DynamicSiteManagement] WITH NOCHECK ADD 
				CONSTRAINT [PK_#p_prefix#DynamicSiteManagement] PRIMARY KEY  CLUSTERED 
				(
					[site_name]
				)  ON [PRIMARY] 
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_Constraints_SubsystemList" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			ALTER TABLE [#p_owner#].[#p_prefix#SubsystemList] WITH NOCHECK ADD 
				CONSTRAINT [PK_#p_prefix#SubsystemList] PRIMARY KEY  CLUSTERED 
				(
					[subsystem_name]
				)  ON [PRIMARY] 
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_Constraints_UserSecurity" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			ALTER TABLE [#p_owner#].[#p_prefix#UserSecurity] WITH NOCHECK ADD 
				CONSTRAINT [PK_#p_prefix#UserSecurity] PRIMARY KEY  CLUSTERED 
				(
					[userid]
				)  ON [PRIMARY] 
		">
		
		<cfreturn _ddlCode>
	</cffunction>

	<cffunction name="ddl_Constraints_ReleaseManagement" access="public" returntype="string">
		<cfargument name="p_owner" type="string" default="dbo">
		<cfargument name="p_prefix" type="string" default="">

		<cfset _ddlCode = "
			ALTER TABLE [#p_owner#].[#p_prefix#ReleaseManagement] ADD 
				CONSTRAINT [PK_#p_prefix#ReleaseManagement] PRIMARY KEY  NONCLUSTERED 
				(
					[releaseNumber]
				)  ON [PRIMARY] 
		">
		
		<cfreturn _ddlCode>
	</cffunction>

</cfcomponent>
