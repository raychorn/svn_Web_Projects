/****** Object:  Database pmprofessionalism    Script Date: 3/17/2005 8:56:19 AM ******/

/****** Object:  Table [dbo].[ContentList]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ContentList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ContentList]
GO

/****** Object:  Table [dbo].[ContentSecurity]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ContentSecurity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ContentSecurity]
GO

/****** Object:  Table [dbo].[DynamicHTMLContent]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLContent]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLContent]
GO

/****** Object:  Table [dbo].[DynamicHTMLfooter]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLfooter]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLfooter]
GO

/****** Object:  Table [dbo].[DynamicHTMLmenu]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLmenu]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLmenu]
GO

/****** Object:  Table [dbo].[DynamicHTMLpad]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLpad]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLpad]
GO

/****** Object:  Table [dbo].[DynamicHTMLright_side]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLright_side]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLright_side]
GO

/****** Object:  Table [dbo].[DynamicHTMLsepg_links]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLsepg_links]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLsepg_links]
GO

/****** Object:  Table [dbo].[DynamicHTMLsepg_section]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLsepg_section]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLsepg_section]
GO

/****** Object:  Table [dbo].[DynamicLayoutSpecification]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicLayoutSpecification]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicLayoutSpecification]
GO

/****** Object:  Table [dbo].[DynamicPageManagement]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicPageManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicPageManagement]
GO

/****** Object:  Table [dbo].[DynamicSiteManagement]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicSiteManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicSiteManagement]
GO

/****** Object:  Table [dbo].[LayoutManagement]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LayoutManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LayoutManagement]
GO

/****** Object:  Table [dbo].[MarqueeScrollerData]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MarqueeScrollerData]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MarqueeScrollerData]
GO

/****** Object:  Table [dbo].[MenuEditorAccess]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MenuEditorAccess]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MenuEditorAccess]
GO

/****** Object:  Table [dbo].[ReleaseActivityLog]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseActivityLog]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ReleaseActivityLog]
GO

/****** Object:  Table [dbo].[ReleaseManagement]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ReleaseManagement]
GO

/****** Object:  Table [dbo].[ReleaseManagementComments]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseManagementComments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ReleaseManagementComments]
GO

/****** Object:  Table [dbo].[SubsystemList]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SubsystemList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SubsystemList]
GO

/****** Object:  Table [dbo].[SubsystemSecurity]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SubsystemSecurity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SubsystemSecurity]
GO

/****** Object:  Table [dbo].[UserSecurity]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserSecurity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[UserSecurity]
GO

/****** Object:  Table [dbo].[ContentList]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ContentList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ContentList] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[ContentSecurity]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ContentSecurity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ContentSecurity] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pid] [int] NOT NULL ,
	[uid] [int] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLContent]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLContent]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLContent] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLfooter]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLfooter]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLfooter] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLmenu]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLmenu]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLmenu] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLpad]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLpad]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLpad] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLright_side]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLright_side]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLright_side] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLsepg_links]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLsepg_links]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLsepg_links] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLsepg_section]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLsepg_section]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLsepg_section] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicLayoutSpecification]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicLayoutSpecification]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicLayoutSpecification] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[layout_vc] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicPageManagement]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicPageManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicPageManagement] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[pageName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PageTitle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[versionDateTime] [datetime] NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicSiteManagement]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicSiteManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicSiteManagement] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[site_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[LayoutManagement]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LayoutManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[LayoutManagement] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[layout_name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[layout_spec] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[MarqueeScrollerData]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MarqueeScrollerData]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[MarqueeScrollerData] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[headline] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[article_text] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[begin_dt] [datetime] NULL ,
	[end_dt] [datetime] NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[MenuEditorAccess]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MenuEditorAccess]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[MenuEditorAccess] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[uid] [int] NOT NULL ,
	[d_locked] [datetime] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[ReleaseActivityLog]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseActivityLog]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ReleaseActivityLog] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[rid] [int] NOT NULL ,
	[dateTime] [datetime] NOT NULL ,
	[comments] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[ReleaseManagement]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseManagement]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ReleaseManagement] (
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

GO

/****** Object:  Table [dbo].[ReleaseManagementComments]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseManagementComments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ReleaseManagementComments] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[rid] [int] NOT NULL ,
	[aDateTime] [datetime] NOT NULL ,
	[comments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[SubsystemList]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SubsystemList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[SubsystemList] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[subsystem_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[SubsystemSecurity]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SubsystemSecurity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[SubsystemSecurity] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[sid] [int] NOT NULL ,
	[uid] [int] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[UserSecurity]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserSecurity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[UserSecurity] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[userid] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[user_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[user_phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

ALTER TABLE [dbo].[ContentList] WITH NOCHECK ADD 
	CONSTRAINT [PK_ContentList] PRIMARY KEY  CLUSTERED 
	(
		[pageName]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DynamicSiteManagement] WITH NOCHECK ADD 
	CONSTRAINT [PK_DynamicSiteManagement] PRIMARY KEY  CLUSTERED 
	(
		[site_name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SubsystemList] WITH NOCHECK ADD 
	CONSTRAINT [PK_SubsystemList] PRIMARY KEY  CLUSTERED 
	(
		[subsystem_name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[UserSecurity] WITH NOCHECK ADD 
	CONSTRAINT [PK_UserSecurity] PRIMARY KEY  CLUSTERED 
	(
		[userid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LayoutManagement] ADD 
	CONSTRAINT [PK_LayoutManagement] PRIMARY KEY  NONCLUSTERED 
	(
		[layout_name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ReleaseManagement] ADD 
	CONSTRAINT [PK_ReleaseManagement] PRIMARY KEY  NONCLUSTERED 
	(
		[releaseNumber]
	)  ON [PRIMARY] 
GO

