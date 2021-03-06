USE [master]
GO
/****** Object:  Database [INSINSTANCE]    Script Date: 11/12/2014 6:43:54 AM ******/
CREATE DATABASE [INSINSTANCE]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'INSINSTANCE', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.INSINSTANCE\MSSQL\DATA\INSINSTANCE.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'INSINSTANCE_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.INSINSTANCE\MSSQL\DATA\INSINSTANCE_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [INSINSTANCE] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [INSINSTANCE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [INSINSTANCE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [INSINSTANCE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [INSINSTANCE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [INSINSTANCE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [INSINSTANCE] SET ARITHABORT OFF 
GO
ALTER DATABASE [INSINSTANCE] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [INSINSTANCE] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [INSINSTANCE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [INSINSTANCE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [INSINSTANCE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [INSINSTANCE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [INSINSTANCE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [INSINSTANCE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [INSINSTANCE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [INSINSTANCE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [INSINSTANCE] SET  DISABLE_BROKER 
GO
ALTER DATABASE [INSINSTANCE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [INSINSTANCE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [INSINSTANCE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [INSINSTANCE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [INSINSTANCE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [INSINSTANCE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [INSINSTANCE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [INSINSTANCE] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [INSINSTANCE] SET  MULTI_USER 
GO
ALTER DATABASE [INSINSTANCE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [INSINSTANCE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [INSINSTANCE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [INSINSTANCE] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [INSINSTANCE]
GO
/****** Object:  ApplicationRole [INS]    Script Date: 11/12/2014 6:43:55 AM ******/
/* To avoid disclosure of passwords, the password is generated in script. */
declare @idx as int
declare @randomPwd as nvarchar(64)
declare @rnd as float
select @idx = 0
select @randomPwd = N''
select @rnd = rand((@@CPU_BUSY % 100) + ((@@IDLE % 100) * 100) + 
       (DATEPART(ss, GETDATE()) * 10000) + ((cast(DATEPART(ms, GETDATE()) as int) % 100) * 1000000))
while @idx < 64
begin
   select @randomPwd = @randomPwd + char((cast((@rnd * 83) as int) + 43))
   select @idx = @idx + 1
select @rnd = rand()
end
declare @statement nvarchar(4000)
select @statement = N'CREATE APPLICATION ROLE [INS] WITH DEFAULT_SCHEMA = [dbo], ' + N'PASSWORD = N' + QUOTENAME(@randomPwd,'''')
EXEC dbo.sp_executesql @statement

GO
/****** Object:  User [admin]    Script Date: 11/12/2014 6:43:55 AM ******/
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Schema [ins]    Script Date: 11/12/2014 6:43:55 AM ******/
CREATE SCHEMA [ins]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Contact](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[ContactValue] [varchar](50) NULL,
	[ContactTypeID] [int] NULL,
	[UserID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContactType]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContactType](
	[ContactTypeID] [int] NOT NULL,
	[ContactTypeName] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventType]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventType](
	[EventTypeID] [int] IDENTITY(1,1) NOT NULL,
	[EventTypeName] [varchar](40) NULL,
	[EventTypeParentID] [int] NULL,
	[Tag] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[EventTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventUTD]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventUTD](
	[EventID] [int] NOT NULL,
	[EventTitle] [varchar](50) NULL,
	[EventURL] [varchar](60) NULL,
	[Category] [varchar](20) NULL,
	[TimeDuration] [varchar](20) NULL,
	[StartTime] [varchar](10) NULL,
	[EventDescription] [varchar](700) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Notification]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notification](
	[NotificationID] [int] IDENTITY(1,1) NOT NULL,
	[UserPreferenceID] [int] NULL,
	[NotificationTypeID] [int] NULL,
	[ContactID] [int] NULL,
	[UnitCount] [int] NULL,
	[TimeOfNewsLetter] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[NotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NotificationType]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NotificationType](
	[NotificationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[NotificationTypeName] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[NotificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Student]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Student](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](30) NOT NULL,
	[UserPassword] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NULL,
	[FirstName] [varchar](50) NOT NULL,
	[registeredEmailAddress] [varchar](50) NOT NULL,
	[IsVerified] [bit] NOT NULL,
	[VerificationCode] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserPreference]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserPreference](
	[UserPreferenceID] [int] IDENTITY(1,1) NOT NULL,
	[UserPreferenceName] [varchar](40) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserPreferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserPreferenceEventTypes]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPreferenceEventTypes](
	[UserPreferenceID] [int] NOT NULL,
	[EventTypeID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserPreferenceID] ASC,
	[EventTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserPreferenceGroups]    Script Date: 11/12/2014 6:43:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPreferenceGroups](
	[UserPreferenceGroupID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[UserPreferenceID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserPreferenceGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Contact] ON 

INSERT [dbo].[Contact] ([ContactID], [ContactValue], [ContactTypeID], [UserID]) VALUES (1, N'sak120230@utdallas.edu', 1, 17)
INSERT [dbo].[Contact] ([ContactID], [ContactValue], [ContactTypeID], [UserID]) VALUES (2, N'saquib.khan@utdallas.edu', 1, 18)
SET IDENTITY_INSERT [dbo].[Contact] OFF
INSERT [dbo].[ContactType] ([ContactTypeID], [ContactTypeName]) VALUES (1, N'Email')
INSERT [dbo].[ContactType] ([ContactTypeID], [ContactTypeName]) VALUES (2, N'Phone')
SET IDENTITY_INSERT [dbo].[EventType] ON 

INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (1, N'Academic', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (2, N'ADMINISTRATION', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (3, N'CARRER', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (4, N'CLUBS', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (5, N'CULTURAL', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (6, N'FOOD', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (7, N'GENERAL', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (8, N'ISSO', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (9, N'MEET', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (10, N'MUSIC', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (11, N'ORGANISATIONS', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (12, N'RADIO', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (13, N'RELIGIOUS EVENTS', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (14, N'SEMINAR', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (15, N'STUDENT ASSOCIATIONS', NULL, NULL)
INSERT [dbo].[EventType] ([EventTypeID], [EventTypeName], [EventTypeParentID], [Tag]) VALUES (16, N'WORKSHOP', NULL, NULL)
SET IDENTITY_INSERT [dbo].[EventType] OFF
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404011, N'Radio UTD - Music Lecture', N'http://www.utdallas.edu/calendar/event.php?id=1220404011', N'CULTURAL', N'5:30 p.m.-7 p.m.', N'5:30 p.m.', N'Part of Radio UTD''s fall music lecture series')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404011, N'Radio UTD - Music Lecture', N'http://www.utdallas.edu/calendar/event.php?id=1220404011', N'RADIO', N'5:30 p.m.-7 p.m.', N'5:30 p.m.', N'Part of Radio UTD''s fall music lecture series')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404011, N'Radio UTD - Music Lecture', N'http://www.utdallas.edu/calendar/event.php?id=1220404011', N'SEMINAR', N'5:30 p.m.-7 p.m.', N'5:30 p.m.', N'Part of Radio UTD''s fall music lecture series')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404011, N'Radio UTD - Music Lecture', N'http://www.utdallas.edu/calendar/event.php?id=1220404011', N'MUSIC', N'5:30 p.m.-7 p.m.', N'5:30 p.m.', N'Part of Radio UTD''s fall music lecture series')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220402361, N'Unicef at UTD - UNICEF General Meetings', N'http://www.utdallas.edu/calendar/event.php?id=1220402361', N'MEET', N'6 p.m.-7 p.m.', N'6 p.m.', N'General Meetings for the UNICEF Organization at UTD.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220402361, N'Unicef at UTD - UNICEF General Meetings', N'http://www.utdallas.edu/calendar/event.php?id=1220402361', N'ORGANISATIONS', N'6 p.m.-7 p.m.', N'6 p.m.', N'General Meetings for the UNICEF Organization at UTD.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404381, N'Rotaract Club - General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220404381', N'CLUBS', N'7 p.m.-8 p.m.', N'7 p.m.', N'General meetings for members will be held every other wednesday')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404381, N'Rotaract Club - General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220404381', N'MEET', N'7 p.m.-8 p.m.', N'7 p.m.', N'General meetings for members will be held every other wednesday')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404381, N'Rotaract Club - General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220404381', N'ORGANISATIONS', N'7 p.m.-8 p.m.', N'7 p.m.', N'General meetings for members will be held every other wednesday')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413082, N'Alpha Epsilon Delta (AED) - AED Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220413082', N'STUDENT ASSOCIATIONS', N'7 p.m.-9 p.m.', N'7 p.m.', N'A monthly general meeting to inform members of events currently going on in the club.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413082, N'Alpha Epsilon Delta (AED) - AED Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220413082', N'MEET', N'7 p.m.-9 p.m.', N'7 p.m.', N'A monthly general meeting to inform members of events currently going on in the club.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220412948, N'Alpha Omega - Midweek', N'http://www.utdallas.edu/calendar/event.php?id=1220412948', N'STUDENT ASSOCIATIONS', N'7 p.m.-9 p.m.', N'7 p.m.', N'Bible Study')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220412948, N'Alpha Omega - Midweek', N'http://www.utdallas.edu/calendar/event.php?id=1220412948', N'RELIGIOUS EVENTS', N'7 p.m.-9 p.m.', N'7 p.m.', N'Bible Study')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413005, N'Wesley at UT Dallas - Wesley at UTD Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220413005', N'MEET', N'7 p.m.-9 p.m.', N'7 p.m.', N'Weekly meeting for fellowship')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413566, N'Epic Movement - EPIC Large Group', N'http://www.utdallas.edu/calendar/event.php?id=1220413566', N'RELIGIOUS EVENTS', N'7 p.m.-9:30 p.m.', N'7 p.m.', N'Investigating culture and how it interacts with faith. Exploring the Gospel to see what God and Christ have to say about everyday topics')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220399991, N'Golden Key - Golden Key Officer Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220399991', N'MEET', N'7:15 p.m.-9:15 p.m.', N'7:15 p.m.', N'This is an officer meeting where we discuss upcoming events and topics.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220399991, N'Golden Key - Golden Key Officer Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220399991', N'ORGANISATIONS', N'7:15 p.m.-9:15 p.m.', N'7:15 p.m.', N'This is an officer meeting where we discuss upcoming events and topics.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220410681, N'ANIM3 - A3 General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220410681', N'CLUBS', N'7:30 p.m.-9:30 p.m.', N'7:30 p.m.', N'UTD''s Premier Anime Club''s Weekly General Meetings')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220410681, N'ANIM3 - A3 General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220410681', N'MEET', N'7:30 p.m.-9:30 p.m.', N'7:30 p.m.', N'UTD''s Premier Anime Club''s Weekly General Meetings')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220414192, N'New Student Programs - OTM Recruitment', N'http://www.utdallas.edu/calendar/event.php?id=1220414192', N'GENERAL', N'7:45 p.m.-9 p.m.', N'7:45 p.m.', NULL)
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220414213, N'College Democrats - General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220414213', N'MEET', N'8 p.m.-10 p.m.', N'8 p.m.', N'We will hold general meetings to talk about Texas and its politics.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413049, N'Alpha Kappa Alpha Sorority, Inc. - Pillow Talk', N'http://www.utdallas.edu/calendar/event.php?id=1220413049', N'STUDENT ASSOCIATIONS', N'9 p.m.-11 p.m.', N'9 p.m.', N'At this event, we will talk about issues in the community in an open free environment.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413049, N'Alpha Kappa Alpha Sorority, Inc. - Pillow Talk', N'http://www.utdallas.edu/calendar/event.php?id=1220413049', N'MEET', N'9 p.m.-11 p.m.', N'9 p.m.', N'At this event, we will talk about issues in the community in an open free environment.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404861, N'OPT Workshop for F-1 Students', N'http://www.utdallas.edu/calendar/event.php?id=1220404861', N'WORKSHOP', N'2:30 p.m.-3:45 p.m.', N'2:30 p.m.', N'Learn about the OPT application process, employment and travel considerations, and reporting requirements.  For application information visit the ISSO Optional Practical Training webpage.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404861, N'OPT Workshop for F-1 Students', N'http://www.utdallas.edu/calendar/event.php?id=1220404861', N'CARRER', N'2:30 p.m.-3:45 p.m.', N'2:30 p.m.', N'Learn about the OPT application process, employment and travel considerations, and reporting requirements.  For application information visit the ISSO Optional Practical Training webpage.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404861, N'OPT Workshop for F-1 Students', N'http://www.utdallas.edu/calendar/event.php?id=1220404861', N'ISSO', N'2:30 p.m.-3:45 p.m.', N'2:30 p.m.', N'Learn about the OPT application process, employment and travel considerations, and reporting requirements.  For application information visit the ISSO Optional Practical Training webpage.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413672, N' English Conversation Hour: Idioms & Charades', N'http://www.utdallas.edu/calendar/event.php?id=1220413672', N'CARRER', N'4 p.m.-5 p.m.', N'4 p.m.', N'Learn and practice English in a fun, informal setting. Led by the International Peer Advocates, the sessions will include conversation, games, and written activities that will improve your English skills and your knowledge of American culture. Intercultural Programs welcomes you to come to one or all of the sessions! No registration is required.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413099, N' Career Center - Graduate School Expo', N'http://www.utdallas.edu/calendar/event.php?id=1220413099', N'Academic', N'4 p.m.-6 p.m.', N'4 p.m.', N'Interested in pursuing graduate or professional school? This is an opportunity for UT Dallas students and alumni to speak with graduate university representatives about admission, scholarships, financial assistance, and degree programs.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413611, N'Spanish Club - Spanish club meetings', N'http://www.utdallas.edu/calendar/event.php?id=1220413611', N'MEET', N'5 p.m.-6 p.m.', N'5 p.m.', N'Meetings with games, activities, and culture of spanish speaking countrues.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220396401, N'Transfer Thirsty Thursday', N'http://www.utdallas.edu/calendar/event.php?id=1220396401', N'GENERAL', N'5 p.m.-7 p.m.', N'5 p.m.', NULL)
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413833, N'UTD DECA - DECA Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220413833', N'MEET', N'5:30 p.m.-6:30 p.m.', N'5:30 p.m.', N'General DECA Meeting')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220406501, N'Alpha Epsilon Delta (AED) - AED General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220406501', N'STUDENT ASSOCIATIONS', N'5:30 p.m.-7 p.m.', N'5:30 p.m.', N'This meeting will be an introduction to the organization. it will provide information for prospective and returning members.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220406501, N'Alpha Epsilon Delta (AED) - AED General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220406501', N'MEET', N'5:30 p.m.-7 p.m.', N'5:30 p.m.', N'This meeting will be an introduction to the organization. it will provide information for prospective and returning members.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220414339, N'Comet Cat Coalition - Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220414339', N'STUDENT ASSOCIATIONS', N'6 p.m.-7 p.m.', N'6 p.m.', N'CCC general meeting')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220414339, N'Comet Cat Coalition - Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220414339', N'MEET', N'6 p.m.-7 p.m.', N'6 p.m.', N'CCC general meeting')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220402371, N'Unicef at UTD - UNICEF General Meetings', N'http://www.utdallas.edu/calendar/event.php?id=1220402371', N'MEET', N'6 p.m.-7 p.m.', N'6 p.m.', N'General Meetings for the UNICEF Organization at UTD.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220402371, N'Unicef at UTD - UNICEF General Meetings', N'http://www.utdallas.edu/calendar/event.php?id=1220402371', N'ORGANISATIONS', N'6 p.m.-7 p.m.', N'6 p.m.', N'General Meetings for the UNICEF Organization at UTD.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220414445, N'Kappa Alpha Theta - Theta Study Daze', N'http://www.utdallas.edu/calendar/event.php?id=1220414445', N'STUDENT ASSOCIATIONS', N'7 p.m.-9 p.m.', N'7 p.m.', N'Study hall for Kappa Alpha Theta sorority')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220402341, N'Unicef at UTD - UNICEF General Meetings', N'http://www.utdallas.edu/calendar/event.php?id=1220402341', N'MEET', N'6 p.m.-7 p.m.', N'6 p.m.', N'General Meetings for the UNICEF Organization at UTD.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220402341, N'Unicef at UTD - UNICEF General Meetings', N'http://www.utdallas.edu/calendar/event.php?id=1220402341', N'ORGANISATIONS', N'6 p.m.-7 p.m.', N'6 p.m.', N'General Meetings for the UNICEF Organization at UTD.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220399931, N'Golden Key - General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220399931', N'MEET', N'6:30 p.m.-8:30 p.m.', N'6:30 p.m.', N'This is a meeting for Members of Golden Key. Some meetings will be more social in nature, while others might be more informative')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220399931, N'Golden Key - General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220399931', N'ORGANISATIONS', N'6:30 p.m.-8:30 p.m.', N'6:30 p.m.', N'This is a meeting for Members of Golden Key. Some meetings will be more social in nature, while others might be more informative')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413525, N'Corporate Challenge 2014: Billiards', N'http://www.utdallas.edu/calendar/event.php?id=1220413525', N'ADMINISTRATION', N'6:30 p.m.-9:30 p.m.', N'6:30 p.m.', N'"Eight Ball" is the name of the game and top shooters representing every company will compete. (6 players - 2 men, 2 women, 1 mixed team)')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404371, N'Rotaract Club - General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220404371', N'MEET', N'7 p.m.-8 p.m.', N'7 p.m.', N'General meetings for members will be held every other wednesday')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220404371, N'Rotaract Club - General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220404371', N'ORGANISATIONS', N'7 p.m.-8 p.m.', N'7 p.m.', N'General meetings for members will be held every other wednesday')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220412946, N'Alpha Omega - Midweek', N'http://www.utdallas.edu/calendar/event.php?id=1220412946', N'STUDENT ASSOCIATIONS', N'7 p.m.-9 p.m.', N'7 p.m.', N'Bible Study')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220412946, N'Alpha Omega - Midweek', N'http://www.utdallas.edu/calendar/event.php?id=1220412946', N'RELIGIOUS EVENTS', N'7 p.m.-9 p.m.', N'7 p.m.', N'Bible Study')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413260, N'Career Center - CPT Information Session', N'http://www.utdallas.edu/calendar/event.php?id=1220413260', N'WORKSHOP', N'2 p.m.-3:30 p.m.', N'2 p.m.', N'Required for all international students except ECS majors.  Learn about the UT Dallas Internship program including the registration process, eligibility requirements, and finding appropriate opportunities.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220396881, N'Rainbow Guard - General Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220396881', N'MEET', N'5 p.m.-6:30 p.m.', N'5 p.m.', N'Meeting to discuss future group plans')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220398691, N'Atheists, Skeptics, and Humanists - Weekly Meeting', N'http://www.utdallas.edu/calendar/event.php?id=1220398691', N'MEET', N'6 p.m.-7 p.m.', N'6 p.m.', N'ASH Weekly Meeting ')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413036, N'Delta Sigma Theta Sorority, Inc. - $13 Prom', N'http://www.utdallas.edu/calendar/event.php?id=1220413036', N'GENERAL', N'6 p.m.-11:45 p.m.', N'6 p.m.', NULL)
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220413527, N'Corporate Challenge 2014: Billiards', N'http://www.utdallas.edu/calendar/event.php?id=1220413527', N'ADMINISTRATION', N'6:30 p.m.-9:30 p.m.', N'6:30 p.m.', N'"Eight Ball" is the name of the game and top shooters representing every company will compete. (6 players - 2 men, 2 women, 1 mixed team)')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220405861, N'Newman Catholic Ministry - Mass on Campus', N'http://www.utdallas.edu/calendar/event.php?id=1220405861', N'FOOD', N'7 p.m.-9 p.m.', N'7 p.m.', N'Come celebrate First Friday Mass with Newman Catholic Ministry. Confession will be provided before Mass. Food and social time will follow Mass.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220405861, N'Newman Catholic Ministry - Mass on Campus', N'http://www.utdallas.edu/calendar/event.php?id=1220405861', N'RELIGIOUS EVENTS', N'7 p.m.-9 p.m.', N'7 p.m.', N'Come celebrate First Friday Mass with Newman Catholic Ministry. Confession will be provided before Mass. Food and social time will follow Mass.')
INSERT [dbo].[EventUTD] ([EventID], [EventTitle], [EventURL], [Category], [TimeDuration], [StartTime], [EventDescription]) VALUES (1220384351, N'Family Day', N'http://www.utdallas.edu/calendar/event.php?id=1220384351', N'GENERAL', N'10 a.m.-4 p.m.', N'10 a.m.', NULL)
SET IDENTITY_INSERT [dbo].[Notification] ON 

INSERT [dbo].[Notification] ([NotificationID], [UserPreferenceID], [NotificationTypeID], [ContactID], [UnitCount], [TimeOfNewsLetter]) VALUES (23, 7, 1, 1, 15, NULL)
INSERT [dbo].[Notification] ([NotificationID], [UserPreferenceID], [NotificationTypeID], [ContactID], [UnitCount], [TimeOfNewsLetter]) VALUES (24, 7, 2, 1, 2, NULL)
INSERT [dbo].[Notification] ([NotificationID], [UserPreferenceID], [NotificationTypeID], [ContactID], [UnitCount], [TimeOfNewsLetter]) VALUES (25, 7, 3, 1, 1, NULL)
SET IDENTITY_INSERT [dbo].[Notification] OFF
SET IDENTITY_INSERT [dbo].[NotificationType] ON 

INSERT [dbo].[NotificationType] ([NotificationTypeID], [NotificationTypeName]) VALUES (1, N'Minutes')
INSERT [dbo].[NotificationType] ([NotificationTypeID], [NotificationTypeName]) VALUES (2, N'Hours')
INSERT [dbo].[NotificationType] ([NotificationTypeID], [NotificationTypeName]) VALUES (3, N'Days')
INSERT [dbo].[NotificationType] ([NotificationTypeID], [NotificationTypeName]) VALUES (4, N'Weeks')
SET IDENTITY_INSERT [dbo].[NotificationType] OFF
SET IDENTITY_INSERT [dbo].[Student] ON 

INSERT [dbo].[Student] ([UserID], [UserName], [UserPassword], [LastName], [FirstName], [registeredEmailAddress], [IsVerified], [VerificationCode]) VALUES (17, N'sak120230', N'A3CB738850FA39BE667C4D6428D72AEE854B2CC7', N'Khan', N'saquib', N'sak120230@utdallas.edu', 1, 2789)
INSERT [dbo].[Student] ([UserID], [UserName], [UserPassword], [LastName], [FirstName], [registeredEmailAddress], [IsVerified], [VerificationCode]) VALUES (18, N'saquib.khan', N'A3CB738850FA39BE667C4D6428D72AEE854B2CC7', N'Khan', N'Saquib', N'saquib.khan@utdallas.edu', 1, 6375)
SET IDENTITY_INSERT [dbo].[Student] OFF
SET IDENTITY_INSERT [dbo].[UserPreference] ON 

INSERT [dbo].[UserPreference] ([UserPreferenceID], [UserPreferenceName]) VALUES (7, N'First Preference')
SET IDENTITY_INSERT [dbo].[UserPreference] OFF
INSERT [dbo].[UserPreferenceEventTypes] ([UserPreferenceID], [EventTypeID]) VALUES (7, 1)
INSERT [dbo].[UserPreferenceEventTypes] ([UserPreferenceID], [EventTypeID]) VALUES (7, 2)
INSERT [dbo].[UserPreferenceEventTypes] ([UserPreferenceID], [EventTypeID]) VALUES (7, 8)
INSERT [dbo].[UserPreferenceEventTypes] ([UserPreferenceID], [EventTypeID]) VALUES (7, 9)
INSERT [dbo].[UserPreferenceEventTypes] ([UserPreferenceID], [EventTypeID]) VALUES (7, 10)
INSERT [dbo].[UserPreferenceEventTypes] ([UserPreferenceID], [EventTypeID]) VALUES (7, 11)
INSERT [dbo].[UserPreferenceEventTypes] ([UserPreferenceID], [EventTypeID]) VALUES (7, 16)
SET IDENTITY_INSERT [dbo].[UserPreferenceGroups] ON 

INSERT [dbo].[UserPreferenceGroups] ([UserPreferenceGroupID], [UserID], [UserPreferenceID]) VALUES (1, 17, 7)
SET IDENTITY_INSERT [dbo].[UserPreferenceGroups] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Student__8096FBAD24E2C0AF]    Script Date: 11/12/2014 6:43:55 AM ******/
ALTER TABLE [dbo].[Student] ADD UNIQUE NONCLUSTERED 
(
	[registeredEmailAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Student__C9F28456F095FAEE]    Script Date: 11/12/2014 6:43:55 AM ******/
ALTER TABLE [dbo].[Student] ADD UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UserNameIndex]    Script Date: 11/12/2014 6:43:55 AM ******/
CREATE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[Student]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UserPasswordIndex]    Script Date: 11/12/2014 6:43:55 AM ******/
CREATE NONCLUSTERED INDEX [UserPasswordIndex] ON [dbo].[Student]
(
	[UserPassword] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD FOREIGN KEY([ContactTypeID])
REFERENCES [dbo].[ContactType] ([ContactTypeID])
GO
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Student] ([UserID])
GO
ALTER TABLE [dbo].[EventType]  WITH CHECK ADD FOREIGN KEY([EventTypeParentID])
REFERENCES [dbo].[EventType] ([EventTypeID])
GO
ALTER TABLE [dbo].[Notification]  WITH CHECK ADD FOREIGN KEY([ContactID])
REFERENCES [dbo].[Contact] ([ContactID])
GO
ALTER TABLE [dbo].[Notification]  WITH CHECK ADD FOREIGN KEY([NotificationTypeID])
REFERENCES [dbo].[NotificationType] ([NotificationTypeID])
GO
ALTER TABLE [dbo].[Notification]  WITH CHECK ADD FOREIGN KEY([UserPreferenceID])
REFERENCES [dbo].[UserPreference] ([UserPreferenceID])
GO
ALTER TABLE [dbo].[UserPreferenceEventTypes]  WITH CHECK ADD FOREIGN KEY([EventTypeID])
REFERENCES [dbo].[EventType] ([EventTypeID])
GO
ALTER TABLE [dbo].[UserPreferenceEventTypes]  WITH CHECK ADD FOREIGN KEY([UserPreferenceID])
REFERENCES [dbo].[UserPreference] ([UserPreferenceID])
GO
ALTER TABLE [dbo].[UserPreferenceGroups]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Student] ([UserID])
GO
ALTER TABLE [dbo].[UserPreferenceGroups]  WITH CHECK ADD FOREIGN KEY([UserPreferenceID])
REFERENCES [dbo].[UserPreference] ([UserPreferenceID])
GO
USE [master]
GO
ALTER DATABASE [INSINSTANCE] SET  READ_WRITE 
GO
