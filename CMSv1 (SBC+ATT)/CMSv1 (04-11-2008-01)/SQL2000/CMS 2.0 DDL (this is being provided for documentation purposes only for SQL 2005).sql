USE [sqldevsl5]
GO
/****** Object:  Table [dbo].[ContentList]    Script Date: 04/12/2008 10:02:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContentList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ContentList] PRIMARY KEY CLUSTERED 
(
	[pageName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContentSecurity]    Script Date: 04/12/2008 10:02:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentSecurity](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pid] [int] NOT NULL,
	[uid] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLContent]    Script Date: 04/12/2008 10:02:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLContent](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLfooter]    Script Date: 04/12/2008 10:02:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLfooter](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLmenu]    Script Date: 04/12/2008 10:02:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLmenu](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLpad]    Script Date: 04/12/2008 10:02:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLpad](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLright_side]    Script Date: 04/12/2008 10:02:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLright_side](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLsepg_links]    Script Date: 04/12/2008 10:03:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLsepg_links](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLsepg_section]    Script Date: 04/12/2008 10:03:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLsepg_section](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicLayoutSpecification]    Script Date: 04/12/2008 10:03:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DynamicLayoutSpecification](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[layout_vc] [varchar](8000) NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DynamicPageManagement]    Script Date: 04/12/2008 10:03:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DynamicPageManagement](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[pageName] [varchar](50) NOT NULL,
	[PageTitle] [varchar](50) NOT NULL,
	[versionDateTime] [datetime] NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DynamicSiteManagement]    Script Date: 04/12/2008 10:03:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DynamicSiteManagement](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[site_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_DynamicSiteManagement] PRIMARY KEY CLUSTERED 
(
	[site_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LayoutManagement]    Script Date: 04/12/2008 10:03:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LayoutManagement](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[layout_name] [varchar](128) NOT NULL,
	[layout_spec] [varchar](8000) NOT NULL,
 CONSTRAINT [PK_LayoutManagement] PRIMARY KEY NONCLUSTERED 
(
	[layout_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MarqueeScrollerData]    Script Date: 04/12/2008 10:03:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MarqueeScrollerData](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[headline] [varchar](8000) NOT NULL,
	[article_text] [varchar](8000) NOT NULL,
	[begin_dt] [datetime] NULL,
	[end_dt] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MenuEditorAccess]    Script Date: 04/12/2008 10:03:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuEditorAccess](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NOT NULL,
	[d_locked] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReleaseActivityLog]    Script Date: 04/12/2008 10:03:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReleaseActivityLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[rid] [int] NOT NULL,
	[dateTime] [datetime] NOT NULL,
	[comments] [varchar](255) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReleaseManagement]    Script Date: 04/12/2008 10:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReleaseManagement](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[releaseNumber] [int] NOT NULL,
	[uid] [int] NULL,
	[layout_id] [int] NULL,
	[devDateTime] [datetime] NULL,
	[stageDateTime] [datetime] NULL,
	[prodDateTime] [datetime] NULL,
	[archDateTime] [datetime] NULL,
	[comments] [text] NULL,
 CONSTRAINT [PK_ReleaseManagement] PRIMARY KEY NONCLUSTERED 
(
	[releaseNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReleaseManagementComments]    Script Date: 04/12/2008 10:04:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReleaseManagementComments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[rid] [int] NOT NULL,
	[aDateTime] [datetime] NOT NULL,
	[comments] [text] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubsystemList]    Script Date: 04/12/2008 10:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubsystemList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[subsystem_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SubsystemList] PRIMARY KEY CLUSTERED 
(
	[subsystem_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SubsystemSecurity]    Script Date: 04/12/2008 10:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubsystemSecurity](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sid] [int] NOT NULL,
	[uid] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSecurity]    Script Date: 04/12/2008 10:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserSecurity](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [varchar](50) NOT NULL,
	[user_name] [varchar](50) NOT NULL,
	[user_phone] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserSecurity] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContentList2]    Script Date: 04/12/2008 10:02:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContentList2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ContentList22] PRIMARY KEY CLUSTERED 
(
	[pageName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContentSecurity2]    Script Date: 04/12/2008 10:02:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContentSecurity2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pid] [int] NOT NULL,
	[uid] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLContent2]    Script Date: 04/12/2008 10:02:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLContent2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLfooter2]    Script Date: 04/12/2008 10:02:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLfooter2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLmenu2]    Script Date: 04/12/2008 10:02:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLmenu2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLpad2]    Script Date: 04/12/2008 10:02:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLpad2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLright_side2]    Script Date: 04/12/2008 10:03:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLright_side2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLsepg_links2]    Script Date: 04/12/2008 10:03:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLsepg_links2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicHTMLsepg_section2]    Script Date: 04/12/2008 10:03:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicHTMLsepg_section2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[html] [text] NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicLayoutSpecification2]    Script Date: 04/12/2008 10:03:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DynamicLayoutSpecification2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[layout_vc] [varchar](8000) NOT NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DynamicPageManagement2]    Script Date: 04/12/2008 10:03:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DynamicPageManagement2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pageId] [int] NOT NULL,
	[pageName] [varchar](50) NOT NULL,
	[PageTitle] [varchar](50) NOT NULL,
	[versionDateTime] [datetime] NULL,
	[rid] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DynamicSiteManagement2]    Script Date: 04/12/2008 10:03:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DynamicSiteManagement2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[site_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_DynamicSiteManagement2] PRIMARY KEY CLUSTERED 
(
	[site_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LayoutManagement2]    Script Date: 04/12/2008 10:03:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LayoutManagement2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[layout_name] [varchar](128) NOT NULL,
	[layout_spec] [varchar](8000) NOT NULL,
 CONSTRAINT [PK_LayoutManagement2] PRIMARY KEY NONCLUSTERED 
(
	[layout_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MarqueeScrollerData2]    Script Date: 04/12/2008 10:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MarqueeScrollerData2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[headline] [varchar](8000) NOT NULL,
	[article_text] [varchar](8000) NOT NULL,
	[begin_dt] [datetime] NULL,
	[end_dt] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MenuEditorAccess2]    Script Date: 04/12/2008 10:03:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuEditorAccess2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NOT NULL,
	[d_locked] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReleaseActivityLog2]    Script Date: 04/12/2008 10:03:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReleaseActivityLog2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[rid] [int] NOT NULL,
	[dateTime] [datetime] NOT NULL,
	[comments] [varchar](255) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReleaseManagement2]    Script Date: 04/12/2008 10:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReleaseManagement2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[releaseNumber] [int] NOT NULL,
	[uid] [int] NULL,
	[layout_id] [int] NULL,
	[devDateTime] [datetime] NULL,
	[stageDateTime] [datetime] NULL,
	[prodDateTime] [datetime] NULL,
	[archDateTime] [datetime] NULL,
	[comments] [text] NULL,
 CONSTRAINT [PK_ReleaseManagement2] PRIMARY KEY NONCLUSTERED 
(
	[releaseNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReleaseManagementComments2]    Script Date: 04/12/2008 10:04:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReleaseManagementComments2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[rid] [int] NOT NULL,
	[aDateTime] [datetime] NOT NULL,
	[comments] [text] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubsystemList2]    Script Date: 04/12/2008 10:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubsystemList2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[subsystem_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SubsystemList2] PRIMARY KEY CLUSTERED 
(
	[subsystem_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SubsystemSecurity2]    Script Date: 04/12/2008 10:04:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubsystemSecurity2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sid] [int] NOT NULL,
	[uid] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSecurity2]    Script Date: 04/12/2008 10:04:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserSecurity2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [varchar](50) NOT NULL,
	[user_name] [varchar](50) NOT NULL,
	[user_phone] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserSecurity2] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
