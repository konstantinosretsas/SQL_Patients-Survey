USE [master]
GO
/****** Object:  Database [SQL_Patients Survey]    Script Date: 01/12/2023 15:05:40 ******/
CREATE DATABASE [SQL_Patients Survey]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SQL_Patients Survey', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SQL_Patients Survey.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SQL_Patients Survey_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SQL_Patients Survey_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [SQL_Patients Survey] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SQL_Patients Survey].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SQL_Patients Survey] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET ARITHABORT OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SQL_Patients Survey] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SQL_Patients Survey] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SQL_Patients Survey] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SQL_Patients Survey] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SQL_Patients Survey] SET  MULTI_USER 
GO
ALTER DATABASE [SQL_Patients Survey] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SQL_Patients Survey] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SQL_Patients Survey] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SQL_Patients Survey] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SQL_Patients Survey] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SQL_Patients Survey] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [SQL_Patients Survey] SET QUERY_STORE = ON
GO
ALTER DATABASE [SQL_Patients Survey] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [SQL_Patients Survey]
GO
/****** Object:  Table [dbo].[measures]    Script Date: 01/12/2023 15:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[measures](
	[Measure_ID] [nvarchar](15) NOT NULL,
	[Measure] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_measures] PRIMARY KEY CLUSTERED 
(
	[Measure_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[national_results]    Script Date: 01/12/2023 15:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[national_results](
	[Release_Period] [varchar](7) NOT NULL,
	[Measure_ID] [nvarchar](15) NOT NULL,
	[Bottom_box_Percentage] [tinyint] NOT NULL,
	[Middle_box_Percentage] [tinyint] NOT NULL,
	[Top_box_Percentage] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Query_12_temp1]    Script Date: 01/12/2023 15:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Query_12_temp1](
	[Measure_ID] [nvarchar](15) NOT NULL,
	[Middle_box_Answer] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Query_17_temp]    Script Date: 01/12/2023 15:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Query_17_temp](
	[Release_Period] [varchar](7) NOT NULL,
	[Measure_ID] [nvarchar](15) NOT NULL,
	[RANK] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[questions]    Script Date: 01/12/2023 15:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[questions](
	[Question_Num] [int] NOT NULL,
	[Measure_ID] [nvarchar](15) NOT NULL,
	[Question] [nvarchar](200) NOT NULL,
	[Bottom_box_Answer] [nvarchar](50) NOT NULL,
	[Middle_box_Answer] [nvarchar](50) NULL,
	[Top_box_Answer] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reports]    Script Date: 01/12/2023 15:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reports](
	[Release_Period] [varchar](7) NOT NULL,
	[Start_Date] [date] NOT NULL,
	[End_Date] [date] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[responses]    Script Date: 01/12/2023 15:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[responses](
	[Release_Period] [varchar](7) NOT NULL,
	[State] [varchar](2) NOT NULL,
	[Facility_ID] [nvarchar](15) NOT NULL,
	[Completed_Surveys] [nvarchar](50) NOT NULL,
	[Response_Rates] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[state_results]    Script Date: 01/12/2023 15:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[state_results](
	[Release_Period] [varchar](7) NOT NULL,
	[State] [varchar](2) NOT NULL,
	[Measure_ID] [nvarchar](15) NOT NULL,
	[Bottom_box_Percentage] [int] NOT NULL,
	[Middle_box_Percentage] [int] NOT NULL,
	[Top_box_Percentage] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[states]    Script Date: 01/12/2023 15:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[states](
	[State] [varchar](2) NOT NULL,
	[State_Name] [nvarchar](50) NOT NULL,
	[Region] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_states] PRIMARY KEY CLUSTERED 
(
	[State] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [SQL_Patients Survey] SET  READ_WRITE 
GO
