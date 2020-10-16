/****** Object:  Database pmprofessionalism    Script Date: 3/17/2005 8:56:19 AM ******/

/****** Object:  Table [dbo].[ContentList2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ContentList2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ContentList2]
GO

/****** Object:  Table [dbo].[ContentSecurity2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ContentSecurity2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ContentSecurity2]
GO

/****** Object:  Table [dbo].[DynamicHTMLContent2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLContent2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLContent2]
GO

/****** Object:  Table [dbo].[DynamicHTMLfooter2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLfooter2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLfooter2]
GO

/****** Object:  Table [dbo].[DynamicHTMLmenu2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLmenu2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLmenu2]
GO

/****** Object:  Table [dbo].[DynamicHTMLpad2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLpad2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLpad2]
GO

/****** Object:  Table [dbo].[DynamicHTMLright_side2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLright_side2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLright_side2]
GO

/****** Object:  Table [dbo].[DynamicHTMLsepg_links2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLsepg_links2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLsepg_links2]
GO

/****** Object:  Table [dbo].[DynamicHTMLsepg_section2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLsepg_section2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicHTMLsepg_section2]
GO

/****** Object:  Table [dbo].[DynamicLayoutSpecification2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicLayoutSpecification2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicLayoutSpecification2]
GO

/****** Object:  Table [dbo].[DynamicPageManagement2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicPageManagement2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicPageManagement2]
GO

/****** Object:  Table [dbo].[DynamicSiteManagement2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicSiteManagement2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DynamicSiteManagement2]
GO

/****** Object:  Table [dbo].[LayoutManagement2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LayoutManagement2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LayoutManagement2]
GO

/****** Object:  Table [dbo].[MarqueeScrollerData2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MarqueeScrollerData2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MarqueeScrollerData2]
GO

/****** Object:  Table [dbo].[MenuEditorAccess2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MenuEditorAccess2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MenuEditorAccess2]
GO

/****** Object:  Table [dbo].[ReleaseActivityLog2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseActivityLog2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ReleaseActivityLog2]
GO

/****** Object:  Table [dbo].[ReleaseManagement2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseManagement2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ReleaseManagement2]
GO

/****** Object:  Table [dbo].[ReleaseManagementComments2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseManagementComments2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ReleaseManagementComments2]
GO

/****** Object:  Table [dbo].[SubsystemList2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SubsystemList2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SubsystemList2]
GO

/****** Object:  Table [dbo].[SubsystemSecurity2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SubsystemSecurity2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SubsystemSecurity2]
GO

/****** Object:  Table [dbo].[UserSecurity2]    Script Date: 3/17/2005 8:56:19 AM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserSecurity2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[UserSecurity2]
GO

/****** Object:  Table [dbo].[ContentList2]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ContentList2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ContentList2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[ContentSecurity2]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ContentSecurity2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ContentSecurity2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pid] [int] NOT NULL ,
	[uid] [int] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLContent2]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLContent2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLContent2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLfooter2]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLfooter2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLfooter2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLmenu2]    Script Date: 3/17/2005 8:56:21 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLmenu2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLmenu2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLpad2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLpad2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLpad2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLright_side2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLright_side2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLright_side2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLsepg_links2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLsepg_links2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLsepg_links2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicHTMLsepg_section2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicHTMLsepg_section2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicHTMLsepg_section2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[html] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicLayoutSpecification2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicLayoutSpecification2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicLayoutSpecification2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[layout_vc] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicPageManagement2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicPageManagement2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicPageManagement2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pageId] [int] NOT NULL ,
	[pageName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[PageTitle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[versionDateTime] [datetime] NULL ,
	[rid] [int] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[DynamicSiteManagement2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DynamicSiteManagement2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[DynamicSiteManagement2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[site_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[LayoutManagement2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LayoutManagement2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[LayoutManagement2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[layout_name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[layout_spec] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[MarqueeScrollerData2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MarqueeScrollerData2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[MarqueeScrollerData2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[headline] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[article_text] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[begin_dt] [datetime] NULL ,
	[end_dt] [datetime] NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[MenuEditorAccess2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MenuEditorAccess2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[MenuEditorAccess2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[uid] [int] NOT NULL ,
	[d_locked] [datetime] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[ReleaseActivityLog2]    Script Date: 3/17/2005 8:56:22 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseActivityLog2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ReleaseActivityLog2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[rid] [int] NOT NULL ,
	[dateTime] [datetime] NOT NULL ,
	[comments] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[ReleaseManagement2]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseManagement2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ReleaseManagement2] (
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

/****** Object:  Table [dbo].[ReleaseManagementComments2]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReleaseManagementComments2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[ReleaseManagementComments2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[rid] [int] NOT NULL ,
	[aDateTime] [datetime] NOT NULL ,
	[comments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[SubsystemList2]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SubsystemList2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[SubsystemList2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[subsystem_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[SubsystemSecurity2]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SubsystemSecurity2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[SubsystemSecurity2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[sid] [int] NOT NULL ,
	[uid] [int] NOT NULL 
) ON [PRIMARY]
END

GO

/****** Object:  Table [dbo].[UserSecurity2]    Script Date: 3/17/2005 8:56:23 AM ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserSecurity2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[UserSecurity2] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[userid] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[user_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[user_phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
END

GO

ALTER TABLE [dbo].[ContentList2] WITH NOCHECK ADD 
	CONSTRAINT [PK_ContentList22] PRIMARY KEY  CLUSTERED 
	(
		[pageName]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DynamicSiteManagement2] WITH NOCHECK ADD 
	CONSTRAINT [PK_DynamicSiteManagement2] PRIMARY KEY  CLUSTERED 
	(
		[site_name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[SubsystemList2] WITH NOCHECK ADD 
	CONSTRAINT [PK_SubsystemList2] PRIMARY KEY  CLUSTERED 
	(
		[subsystem_name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[UserSecurity2] WITH NOCHECK ADD 
	CONSTRAINT [PK_UserSecurity2] PRIMARY KEY  CLUSTERED 
	(
		[userid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LayoutManagement2] ADD 
	CONSTRAINT [PK_LayoutManagement2] PRIMARY KEY  NONCLUSTERED 
	(
		[layout_name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ReleaseManagement2] ADD 
	CONSTRAINT [PK_ReleaseManagement2] PRIMARY KEY  NONCLUSTERED 
	(
		[releaseNumber]
	)  ON [PRIMARY] 
GO

