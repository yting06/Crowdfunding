USE [master]
GO
/****** Object:  Database [FDB03]    Script Date: 10/5/2023 7:11:26 PM ******/
CREATE DATABASE [FDB03]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DB3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQL2023\MSSQL\DATA\DB3.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DB3_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQL2023\MSSQL\DATA\DB3_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [FDB03] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FDB03].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FDB03] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FDB03] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FDB03] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FDB03] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FDB03] SET ARITHABORT OFF 
GO
ALTER DATABASE [FDB03] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FDB03] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FDB03] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FDB03] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FDB03] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FDB03] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FDB03] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FDB03] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FDB03] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FDB03] SET  DISABLE_BROKER 
GO
ALTER DATABASE [FDB03] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FDB03] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FDB03] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FDB03] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FDB03] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FDB03] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FDB03] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FDB03] SET RECOVERY FULL 
GO
ALTER DATABASE [FDB03] SET  MULTI_USER 
GO
ALTER DATABASE [FDB03] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FDB03] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FDB03] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FDB03] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FDB03] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FDB03] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'FDB03', N'ON'
GO
ALTER DATABASE [FDB03] SET QUERY_STORE = ON
GO
ALTER DATABASE [FDB03] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [FDB03]
GO
/****** Object:  User [sa5]    Script Date: 10/5/2023 7:11:26 PM ******/
CREATE USER [sa5] FOR LOGIN [sa5] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [sa5]
GO
/****** Object:  UserDefinedFunction [dbo].[SplitIds]    Script Date: 10/5/2023 7:11:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitIds](@IdsString NVARCHAR(MAX))
RETURNS @IdTable TABLE (Id INT)
AS
BEGIN
    DECLARE @Id INT;
    DECLARE @Pos INT;

    WHILE LEN(@IdsString) > 0
    BEGIN
        SET @Pos = CHARINDEX(',', @IdsString);

        IF @Pos = 0
            SET @Pos = LEN(@IdsString) + 1;

        SET @Id = CAST(SUBSTRING(@IdsString, 1, @Pos - 1) AS INT);
        INSERT INTO @IdTable (Id) VALUES (@Id);

        SET @IdsString = SUBSTRING(@IdsString, @Pos + 1, LEN(@IdsString) - @Pos);
    END
    RETURN;
END;
GO
/****** Object:  Table [dbo].[AboutUs]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AboutUs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nchar](10) NOT NULL,
	[Contents] [text] NOT NULL,
	[Image] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AboutUs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[DisplayOrder] [int] NOT NULL,
	[Type] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Message] [nvarchar](1000) NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[OrderId] [int] NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Account] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[UnifiedBusinessNo] [nvarchar](50) NOT NULL,
	[ResponsiblePerson] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](250) NOT NULL,
	[Status] [bit] NOT NULL,
	[Introduce] [nvarchar](1000) NULL,
	[Image] [nvarchar](350) NULL,
	[CreatedTime] [datetime] NOT NULL,
	[ApplyTime] [datetime] NULL,
	[UpdateTime] [datetime] NOT NULL,
	[ConfirmCode] [nvarchar](250) NULL,
	[IsConfirmed] [bit] NULL,
 CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Configurations]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Configurations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Value] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[TypeId] [int] NOT NULL,
 CONSTRAINT [PK_SiteSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FAQs]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAQs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Question] [text] NOT NULL,
	[Answer] [text] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_FAQs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Follows]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Follows](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
 CONSTRAINT [PK_Follows_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Functions]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Functions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[KeyValue] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](250) NOT NULL,
	[ParentPageId] [int] NOT NULL,
 CONSTRAINT [PK_Components] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ManagerRoleRel]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ManagerRoleRel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ManagerId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_ManagerRoleRel] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Managers]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Managers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Account] [nvarchar](250) NOT NULL,
	[Password] [nvarchar](250) NOT NULL,
	[Email] [nvarchar](250) NOT NULL,
	[FirstName] [nvarchar](550) NOT NULL,
	[LastName] [nvarchar](550) NOT NULL,
	[Birthday] [datetime] NULL,
	[Enabled] [bit] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
	[ConfirmCode] [nvarchar](150) NULL,
	[IsConfirmed] [bit] NULL,
 CONSTRAINT [PK_Managers_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ManagersAuths]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ManagersAuths](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Account] [nvarchar](250) NOT NULL,
	[Json] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ManagersAuths] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Members]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Members](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Account] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](250) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](250) NOT NULL,
	[Birthday] [date] NULL,
	[Introduce] [nvarchar](1000) NULL,
	[CreatTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
	[Image] [nvarchar](450) NULL,
	[ConfirmCode] [nvarchar](250) NULL,
	[IsConfirmed] [bit] NULL,
 CONSTRAINT [PK_Members] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[News]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
	[CreatTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
	[ProjectId] [int] NOT NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Qty] [int] NOT NULL,
 CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[No] [nvarchar](100) NOT NULL,
	[MemberId] [int] NOT NULL,
	[OrderTime] [datetime] NOT NULL,
	[Total] [int] NOT NULL,
	[PaymentIStatusId] [int] NOT NULL,
	[PaymentId] [int] NOT NULL,
	[RecipientId] [int] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pages]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[DefaultVisible] [bit] NOT NULL,
	[ParentId] [int] NULL,
	[KeyValue] [nvarchar](150) NULL,
 CONSTRAINT [PK_Resources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrivacyPolicies]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrivacyPolicies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [text] NOT NULL,
	[Contents] [text] NOT NULL,
	[TypeId] [int] NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Agreements] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Detail] [nvarchar](1000) NOT NULL,
	[Qty] [int] NOT NULL,
	[Price] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Image] [nvarchar](550) NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Projects]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Projects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Image] [nvarchar](1000) NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
	[Goal] [int] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[ShippingDays] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[StatusId] [int] NULL,
	[UpdateTime] [datetime] NOT NULL,
	[ApplyTime] [datetime] NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recipients]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Recipients](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[PhoneNumber] [nvarchar](50) NOT NULL,
	[PostalCode] [nchar](10) NOT NULL,
	[Address] [nvarchar](100) NOT NULL,
	[MemberId] [int] NOT NULL,
 CONSTRAINT [PK_Recipients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Records]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Records](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TotelOrders] [int] NOT NULL,
	[TotelProjects] [int] NOT NULL,
	[TotelCompleteProjects] [int] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Records] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleFunctionRel]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleFunctionRel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[FunctionId] [int] NOT NULL,
 CONSTRAINT [PK_CompPermissionRel] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolePageRel]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolePageRel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[PageId] [int] NOT NULL,
 CONSTRAINT [PK_PermissionsResourceRel] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Type] [nvarchar](150) NOT NULL,
	[ReadOnly] [bit] NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeamProjectRels]    Script Date: 10/5/2023 7:11:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeamProjectRels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_TeamMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AboutUs] ON 

INSERT [dbo].[AboutUs] ([Id], [Title], [Contents], [Image], [CreatedDate], [UpdatedDate]) VALUES (3, N'關於我們      ', N'<h3>
    讓美好的事物發生
</h3>
<p>
    　　木木是一個群眾集資平台。刊登各式各樣的創意計畫，歡迎每一位喜歡夢想、喜歡美好事物的人們。
</p>
<h3>
    對於支持者們來說
</h3>
<p>
    　　每個計畫都會由發起者準備不同金額的贊助回饋。你可以透過贊助這些最新、最快、最與眾不同的商品或美好體驗、支持他們的夢想實現。<br>
    　　計畫成功後，你就能依照贊助的金額得到你所預購的驚喜回饋，同時也讓一件美好的事物發生在你我的生活中！<br>
    　　計畫如果失敗了，支持的金額將會退回到你的帳戶（不包含虛擬帳號轉帳交易手續費）。
</p>
<h3>
    對於想發起計畫的人來說
</h3>
<p>
    　　在「嘖嘖」上實現夢想的第一步就是確定你的計畫目標。你想做什麼計畫？實現它需要多少資金？<br>
    　　如果在募資期限內達到目標，你就能從支持者那裡獲得資金實現夢想！<br>
    　　透過給予支持者獨特的回饋來吸引更多的募資。從單純地向支持者致謝，到預購的產品、預售的門票，甚至是限量商品、會員優惠等等各種獨家的獎勵，我們鼓勵你發揮創意，提出吸引人的回饋來募集資金。
</p>', N'1', CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[AboutUs] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (1, N'社會', N'專案類型', 1, N'ProjectTypes')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (2, N'影音', N'專案類型', 2, N'ProjectTypes')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (3, N'出版', N'專案類型', 3, N'ProjectTypes')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (4, N'娛樂', N'專案類型', 4, N'ProjectTypes')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (5, N'生活', N'專案類型', 5, N'ProjectTypes')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (6, N'設計', N'專案類型', 6, N'ProjectTypes')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (7, N'科技', N'專案類型', 7, N'ProjectTypes')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (8, N'休閒', N'專案類型', 8, N'ProjectTypes')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (9, N'信用卡付款', N'付款狀態', 1, N'Payments')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (10, N'ATM轉帳', N'付款狀態', 2, N'Payments')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (11, N'超商繳款', N'付款狀態', 3, N'Payments')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (12, N'付款成功', N'付款狀態', 1, N'PaymentStatus')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (13, N'待付款', N'付款狀態', 2, N'PaymentStatus')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (14, N'集資中', N'專案狀態', 1, N'ProjectStatus')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (16, N'成功', N'專案狀態', 2, N'ProjectStatus')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (17, N'未達標', N'專案狀態', 3, N'ProjectStatus')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (18, N'發起計畫', N'常見問題類型', 1, N'FAQs')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (19, N'贊助計畫', N'常見問題類型', 2, N'FAQs')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (20, N'其他', N'常見問題類型', 3, N'FAQs')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (21, N'審核中', N'專案狀態', 4, N'ProjectStatus')
INSERT [dbo].[Categories] ([Id], [Name], [Description], [DisplayOrder], [Type]) VALUES (23, N'退件', N'專案狀態', 5, N'ProjectStatus')
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Companies] ON 

INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (1, N'Allen', N'allen@gmail.com', N'艾倫郭股份有限公司', N'0935123459', N'36573804', N'Allen Kuo', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 1, N'C#  ASP.NET MVC 線上教學', N'38C.jpg', CAST(N'2023-10-05T14:06:28.833' AS DateTime), CAST(N'2022-07-03T09:00:00.000' AS DateTime), CAST(N'2023-10-05T14:06:28.833' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (2, N'paperpaper', N'paperpaper@gmail.com', N'一起玩紙股份有限公司', N'0919536363', N'96606435', N'peter Li', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 1, N'嗨！我們是紙紙 paperpaper團隊，我們透過紙為載體，打造出多款受到大家喜愛的紙類藝術品，期待作品能持續療癒大家的每一天。', N'41C.jpg', CAST(N'2022-07-03T09:00:00.000' AS DateTime), CAST(N'2022-07-07T00:00:00.000' AS DateTime), CAST(N'2023-07-10T13:10:25.000' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (3, N'yoyoflower', N'yoyoflower@gmail.com', N'悠花文化股份有限公司', N'0914213436', N'12932035', N'Sala Su', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD
', 1, N'植物就像音樂一樣，可以用最溫柔的方式，安撫著我們的情緒，所以我們想把花帶入大家的生活，用最簡單的方式，讓大家因為有花而感到幸福。
', N'10C.jpg', CAST(N'2022-07-10T18:11:43.000' AS DateTime), CAST(N'2022-07-18T11:11:00.000' AS DateTime), CAST(N'2023-01-28T18:11:43.000' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (4, N'pets.world', N'pets.world@gmail.com', N'寵物世界有限公司', N'0933256436', N'35965241', N'毛先生', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 1, N'寵物世界是一群來自台灣各地有同樣理念的夥伴組成的團體，我們希望每隻流浪的毛孩們在生命到了盡頭時，不再像垃圾一樣被丟棄。
我們關注毛孩、浪浪議題，期盼有天，浪浪能不再流浪；更希望有天，世界不再有浪浪。', N'93C.jpg', CAST(N'2022-08-11T14:12:23.000' AS DateTime), CAST(N'2022-08-15T15:16:33.000' AS DateTime), CAST(N'2023-07-03T13:17:54.000' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (5, N'dep465', N'dep465@eden.org.tw', N'財團法人伊甸社會福利基金會', N'0222307715', N'05200169', N'王小姐', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 1, N'秉持「服務弱勢、見證基督、推動雙福、領人歸主」的理念，提供身心障礙朋友各項社會福利服務，並傳達基督救贖的訊息，落實福利與福音並重的使命。 從為身障者發聲爭取權益，到進入非營利事業管理模式，進而跨入國際，伊甸目前在全國超過130個服務據點，每年服務6萬個以上身心障礙及弱勢家庭。', N'91C.jpg', CAST(N'2022-08-12T04:16:42.000' AS DateTime), CAST(N'2022-08-17T04:16:42.000' AS DateTime), CAST(N'2023-05-16T03:11:41.000' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (6, N'syaxworld', N'syaxworld@gmail.com', N'平行世界有限公司', N'0932346432', N'58364231', N'Ray', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 1, N'「平行世界拍攝計劃暨攝影展」，以不存在於現實，但卻存在於另一時空的「平行人生」概念出發，計劃拍攝白色恐怖受難者和受難者家屬，並與受難者共同討論，以「如果沒有白色恐怖，現在自身可能的樣貌」為拍攝主題。', N'57C.jpg', CAST(N'2022-08-26T14:13:42.000' AS DateTime), CAST(N'2022-09-01T14:13:45.000' AS DateTime), CAST(N'2023-02-13T17:13:31.000' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (7, N'cinidi', N'cinidi@cloudybay.com.tw', N'灣灣資訊有限公司', N'0273645782', N'83647832', N'Tim', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 1, N'App遊戲設計', N'09C.jpg', CAST(N'2022-10-14T16:14:45.000' AS DateTime), CAST(N'2022-10-18T09:13:34.000' AS DateTime), CAST(N'2023-04-12T23:12:23.000' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (8, N'miaowuwu.market', N'miaowuwu.market@gmail.com', N'喵嗚嗚市集', N'0912743536', N'24637294', N'Elly', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 1, N'這是全國室內最大的貓咪主題市集，於2020年開始定期舉辦，建構一個能夠將人和貓咪的緣分串接的平台。
我們願意成為承載人和貓咪緣分相連的橋樑，打造貓奴與潛貓奴的育成基地。期待我們的努力能幫助愛貓的你和你的天選之貓早日相遇！', N'80C.jpg', CAST(N'2022-11-15T15:17:43.000' AS DateTime), CAST(N'2022-11-30T03:14:12.000' AS DateTime), CAST(N'2023-05-12T19:15:43.000' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (9, N'select', N'select@gmail.com', N'選擇居家', N'0437982342', N'32526711', N'Fiona', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 1, N'選擇只想給家人最好的，由裡到外，從歐洲進口頂級小牛皮再到C型建築鋼骨結構。十年不壞，消費者才愛的家居。 我們將選擇交給您，責任交給我們，承載您與家人不間斷的回憶。', N'08C.jpg', CAST(N'2022-12-18T20:34:52.000' AS DateTime), CAST(N'2022-12-24T13:45:37.000' AS DateTime), CAST(N'2022-12-26T14:36:38.000' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (10, N'peanut', N'peanut@gmail.com', N'花生股份有限公司', N'034785145', N'11284702', N'White', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 0, N'今天又發生什麼事?', N'11C.jpg', CAST(N'2023-01-24T12:43:22.000' AS DateTime), CAST(N'2023-02-10T13:23:54.000' AS DateTime), CAST(N'2023-02-10T13:23:54.000' AS DateTime), NULL, 1)
INSERT [dbo].[Companies] ([Id], [Account], [Email], [Name], [Phone], [UnifiedBusinessNo], [ResponsiblePerson], [Password], [Status], [Introduce], [Image], [CreatedTime], [ApplyTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (11, N'uiu', N'uiu@gmail.com', N'悠呼股份有限公司', N'023457891', N'12459056', N'Una', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', 0, N'匆忙的社會每天都好累，悠呼致力於研發讓大家隨時都能更舒服、放鬆休息的小物~', N'12C.jpg', CAST(N'2023-02-12T15:44:52.000' AS DateTime), NULL, CAST(N'2023-02-12T15:44:52.000' AS DateTime), N'01c06c29d2d9475abd5735edae87f687', 0)
SET IDENTITY_INSERT [dbo].[Companies] OFF
GO
SET IDENTITY_INSERT [dbo].[FAQs] ON 

INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (1, N'集資的時間有限制嗎？', N'平台上發起最短的計劃為一天；最長的計劃為五個月。我們通常建議集資計畫在 35-45 天是最理想的。計畫時間過短或太長，都對計劃集資幫助不大。', 1, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-25T15:55:36.507' AS DateTime), 18)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (2, N'發起計畫需要付錢嗎？', N'發起計劃不需支付任何費用，只有集資成功的專案需付平台手續費及金流費用。專案成功後，平台將收取您計劃最後集資總金額的 2.5%* 金流基本服務費及 5.5% 手續費。平台收取手續費將用於網站維護及資安保護等，確保平台能長久經營，幫助更多的創作人。

*依不同的付款方式可能會有不同的金流費用比例，詳見提案契約。', 2, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 18)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (3, N' 我發起的計畫集資成功了，我該怎麼聯絡贊助人？', N'計畫成功結束後，提案人的可以在計畫頁面工具箱中找到「贊助人列表」，其中包含所有贊助人的聯絡資料和贊助細節。', 3, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 18)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (4, N'我可以在嘖嘖上發起公益計劃嗎？', N'可以發起公益計劃，但需符合《公益勸募條例》規範，包括第 5 條對於發起計劃身份之確認，並需具有該年度的公益勸募許可文號，此外，您的計劃中若有純捐款，需提供贊助者可抵稅之捐款收據。

《公益勸募條例》第 5 條，本條例所稱勸募團體如下：
一、公立學校
二、行政法人
三、公益性社團法人
四、財團法人

若無法判斷欲發起計劃是否受《公益勸募條例》規範，可聯繫衛福部公益勸募相關法令釋疑專線：02-8590-6651', 4, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 18)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (5, N'我有提供回饋品給贊助者，是否就不受《公益勸募條例》規範，即不需勸募字號也可以上架公益計劃？', N'不是的，根據《公益勸募條例》規範，只要文案中宣稱集資金額將使「不特定多數人」受惠，即屬「公益」範疇，不論是否有提供回饋品，均需符合規範。提醒您，若經判定為違法之公益勸募計劃，主管機關有權要求計劃將勸募所得財物返還捐贈人。', 5, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 18)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (6, N'我想要提案，但是我的內容還沒有準備好，可以先和您們討論嗎？', N'在提案後至正式上線前，您都可以繼續修改計畫內容，所以不用擔心資料還沒準備完善就提案，之後有的是時間修改！但請注意還是必須提供足夠的計畫內容以供嘖嘖專案部評估。', 6, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 18)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (7, N'為什麼計畫要經過審核？審核什麼部分？', N'「群眾集資」即意味著將計劃交到贊助人眼前，由他們決定計劃是否成功，木木作為媒介平台，不介入專案計劃及執行，但為了維護產業生態的健康，您發起計劃後，將經過以下四個階段的審核：

請留意，審核通過不代表任何法律或道德上的背書，您仍需為您發起的專案負擔所有責任。

（1）提案後：我們會初步評估計劃應是合理且合法的，包括但不限於：
- 合法性檢查：計劃應確保未違反法律在地及國際法規。
- 計劃合理性：提案應包括說明計劃執行方式及如何使用集資資金、計劃的時間表，這有助幫助贊助人確認計劃是具體的，且有可能成功實踐。
- 相關文件：我們會希望您出示計劃中的必要的合法文件，如檢驗證明、專利證明、報價單等。

（2）初審後：身份及金流確認，包括但不限於：
- 身份驗證：無論是以自然人或法人發起專案，均需提供不同的文件，以確認是合法存在的實體。

（3）上架後：提案上架後，我們仍會持續確保計劃的合法性和品質，包括但不限於：
- 保護專利及智慧產財權：發起專案後，若存在侵權或盜用他人設計之風險，必要時，我們會要求提案者提供進一步的權利證明文件。
- 緊急應對：若計劃集資過程中衍生高度消費爭議，我們會在謹慎評估後暫停或下架計劃，以保護贊助者和合法提案者的權益。

（4）執行後：實踐及貫徹專案的能力，有無和贊助者溝通的誠意，包括但不限於：
- 溝通和透明度：提案者應定期向贊助者提供計劃進展報告，確保計劃透明度和溝通，並及時解決問題。
- 風險管理：提案者應對執行中的風險，例如生產延遲或預算超支，並找到解決方案。
- 計劃成果：若您的曾有計劃在交付集資金額後執行失敗，未能成功交付回饋品的記錄，會降低您下一次計劃的審核機率。', 7, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 18)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (8, N'贊助計畫以後什麼時候才會收到回饋？', N'每一個計畫回饋的選項不一樣，在回饋選項說明下方都會標示預計送出日期，但因為選項的預計送出日期都是估計，所以不一定會準確。請密切注意提案人的更新、動態來確定時間。如果有疑惑請使用計畫頁面上的聯絡提案人功能來和提案者確認。', 1, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 19)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (9, N'我想要贊助計畫，可以透過哪些方式呢？', N'信用卡付款、ATM轉帳、超商繳款', 2, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 19)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (10, N'我還沒有收到贊助回饋，怎麼辦？', N'在您贊助的計畫成功後，建議您密切留意「專案更新」了解計劃執行進度。若有疑問，可使用計畫頁面上的聯絡提案人功能來和提案者確認。也可直接透過專案頁面展示的提案團隊客服聯絡方式，到提案計畫粉絲專頁、網站、e-mail 或電話等資訊等向提案者詢問。如未能獲得提案團隊的回覆，請來信 告知狀況，我們將聯繫提案團隊儘速處理。', 3, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 19)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (11, N'請問處理爭議的流程是什麼？', N'(1) 確認是您自身下單的贊助 / 預購，或是遭到他人盜刷
- 若遭到他人盜刷，請發現盜刷後立即向發卡銀行通報。

(2) 贊助的回饋已經超過預計寄送時間
- 首先請至贊助記錄頁面查看您的贊助預計送出日期。
- 如已逾回饋預計送出日期，請至該專案頁面查看「專案更新」是否有回饋品項寄送相關資訊。
- 若以上資訊仍無法讓您確認出貨日期，或出貨日期明顯已過，您可以透過各專案內容中的「客服聯絡方式」與提案團隊直接聯繫。
- 與提案團隊聯繫時，請附贊助編號及收件資訊，以利讓提案團隊確認資訊、縮短處理時間，以便盡快為您提供協助。
- 如未能獲得提案團隊的回覆，請來信告知狀況，我們將聯繫提案團隊儘速處理。

(3) 提案團隊未如預期更新進度
- 請透過各專案內容中的「客服聯絡方式」與提案團隊就更新進度事宜直接聯繫。
- 與提案團隊聯繫時，請附贊助編號，以利提案團隊確認資訊、縮短處理時間，以便盡快為您提供協助

(4) 回饋品項不如預期
- 在台灣目前群眾集資平台的贊助行為仍適用於《消保法》第 19 條通訊交易範疇，提案團隊須提供贊助者 7 天鑑賞期，且不得要求贊助者承擔退貨運費或其他營運成本。
- 請透過各專案內容中的「客服聯絡方式」與提案團隊就回饋品狀況直接聯繫。
- 與提案團隊聯繫時，請附贊助編號和實品圖片，並充份敘述與預期不符之處。以利提案團隊確認資訊、縮短處理時間、以利盡快為您提供協助。
- 若提案團隊未及時回覆或擱置您的退款請求，請來信告知，我們將協助聯繫提案團隊儘速處理。', 4, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 19)
INSERT [dbo].[FAQs] ([Id], [Question], [Answer], [DisplayOrder], [CreatedDate], [UpdatedDate], [CategoryId]) VALUES (12, N' 您們有在接受合作提案嗎？要跟誰聯絡？', N'我們一直都很希望能參與鼓勵創意人的合作，舉凡講座、座談會、創意市集、表演、聚會活動；都很有興趣參與。請寄信到信箱 。如果您是想和木木上面的計畫提案人合作，請使用計畫頁面上的聯絡提案人功能來連絡提案人。', 1, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-09-28T15:15:07.287' AS DateTime), 20)
SET IDENTITY_INSERT [dbo].[FAQs] OFF
GO
SET IDENTITY_INSERT [dbo].[Functions] ON 

INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (2, N'審核', N'PReviewer', N'專案管理員
', 3)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (3, N'新增', N'WebListAdd', N'網站 - 目錄清單
', 4)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (4, N'刪除', N'4', N'網站 - 目錄清單
', 4)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (5, N'修改', N'5', N'網站 - 目錄清單
', 4)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (6, N'新增', N'6', N'網站 - 常見問題
', 5)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (7, N'刪除', N'88', N'網站 - 常見問題
', 5)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (8, N'修改', N'7', N'網站 - 常見問題
', 5)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (13, N'新增角色', N'45', N'權限管理 
', 9)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (14, N'刪除角色', N'56', N'權限管理 
', 9)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (15, N'修改角色', N'78', N'權限管理 
', 9)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (16, N'新增用戶權限', N'33', N'權限管理 
', 9)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (17, N'刪除用戶權限', N'35', N'權限管理 
', 9)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (18, N'修改用戶權限', N'36', N'權限管理 
', 9)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (19, N'新增使用者', N'38', N'使用者管理
', 10)
INSERT [dbo].[Functions] ([Id], [Name], [KeyValue], [Description], [ParentPageId]) VALUES (20, N'使用者停權', N'50', N'使用者管理
', 10)
SET IDENTITY_INSERT [dbo].[Functions] OFF
GO
SET IDENTITY_INSERT [dbo].[ManagerRoleRel] ON 

INSERT [dbo].[ManagerRoleRel] ([Id], [ManagerId], [RoleId]) VALUES (1, 1, 3)
INSERT [dbo].[ManagerRoleRel] ([Id], [ManagerId], [RoleId]) VALUES (3, 4, 3)
INSERT [dbo].[ManagerRoleRel] ([Id], [ManagerId], [RoleId]) VALUES (5, 4, 14)
INSERT [dbo].[ManagerRoleRel] ([Id], [ManagerId], [RoleId]) VALUES (7, 2, 5)
SET IDENTITY_INSERT [dbo].[ManagerRoleRel] OFF
GO
SET IDENTITY_INSERT [dbo].[Managers] ON 

INSERT [dbo].[Managers] ([Id], [Account], [Password], [Email], [FirstName], [LastName], [Birthday], [Enabled], [CreatedTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (1, N'Test', N'152E9299D76FC30F968CED8CB9041B87472DF4D9D1C1D9A5E2C4C57E542723FE', N'test@gmail.com', N'行伸', N'王', CAST(N'1990-01-01T00:00:00.000' AS DateTime), 1, CAST(N'2023-09-22T10:37:12.217' AS DateTime), CAST(N'2023-10-04T17:16:42.713' AS DateTime), N'e130e96880984cfc8725e8a4ec812b27', 1)
INSERT [dbo].[Managers] ([Id], [Account], [Password], [Email], [FirstName], [LastName], [Birthday], [Enabled], [CreatedTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (2, N't01', N'152E9299D76FC30F968CED8CB9041B87472DF4D9D1C1D9A5E2C4C57E542723FE', N't01@gmail.com', N'君雅', N'林', CAST(N'1999-05-24T00:00:00.000' AS DateTime), 0, CAST(N'2023-09-22T10:37:12.217' AS DateTime), CAST(N'2023-09-25T15:54:44.937' AS DateTime), N'', 1)
INSERT [dbo].[Managers] ([Id], [Account], [Password], [Email], [FirstName], [LastName], [Birthday], [Enabled], [CreatedTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (3, N't02', N'B266318E7F5598A96FC742D19D056E986991E9E72C9C2ADBC8A9829559BB9116', N't02@gmail.com', N'正啟', N'陳', CAST(N'2000-07-16T00:00:00.000' AS DateTime), 0, CAST(N'2023-09-22T10:37:12.217' AS DateTime), CAST(N'2023-09-22T10:37:12.217' AS DateTime), N'ca0c43d4c89c41b98c079bef36f41567', NULL)
INSERT [dbo].[Managers] ([Id], [Account], [Password], [Email], [FirstName], [LastName], [Birthday], [Enabled], [CreatedTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (4, N't03', N'B266318E7F5598A96FC742D19D056E986991E9E72C9C2ADBC8A9829559BB9116', N't03@gmail.com', N'丹伯', N'黃', CAST(N'1988-12-16T00:00:00.000' AS DateTime), 0, CAST(N'2023-09-22T10:37:12.217' AS DateTime), CAST(N'2023-09-22T10:37:12.217' AS DateTime), N'3cedccb4d31e436399316aa6b26a874b', NULL)
INSERT [dbo].[Managers] ([Id], [Account], [Password], [Email], [FirstName], [LastName], [Birthday], [Enabled], [CreatedTime], [UpdateTime], [ConfirmCode], [IsConfirmed]) VALUES (5, N't04', N'B266318E7F5598A96FC742D19D056E986991E9E72C9C2ADBC8A9829559BB9116', N't04@gmail.com', N'佳怡', N'張', CAST(N'2000-04-10T00:00:00.000' AS DateTime), 0, CAST(N'2023-09-22T10:37:12.217' AS DateTime), CAST(N'2023-10-02T00:13:14.943' AS DateTime), N'6fb08617463c4bf19ee073c6030245c0', NULL)
SET IDENTITY_INSERT [dbo].[Managers] OFF
GO
SET IDENTITY_INSERT [dbo].[Members] ON 

INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (1, N'Allen', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'Allen Kuo', N'allen@gmail.com', NULL, NULL, CAST(N'2023-09-25T14:11:28.170' AS DateTime), CAST(N'2023-09-25T14:11:28.170' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (2, N'Joyce', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'Joyce  Lee', N'joyce@gmail.com', NULL, NULL, CAST(N'2023-09-25T15:47:54.213' AS DateTime), CAST(N'2023-09-25T15:47:54.213' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (3, N'Apple', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'Apple  Li', N'apple@gmail.com', NULL, NULL, CAST(N'2023-09-25T15:48:58.870' AS DateTime), CAST(N'2023-09-25T15:48:58.870' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (4, N'ABC', N'F1095E0C87F128165D2B4AF264C175C5F41CB946EA78FA217C9851B9D60E7660', N'ABC aa', N'abc@gmail.com', NULL, NULL, CAST(N'2023-09-25T16:24:50.903' AS DateTime), CAST(N'2023-09-25T16:24:50.903' AS DateTime), NULL, N'beff3273123743a5806c12616f054494', 0)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (5, N'lulu', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'LuLu', N'lulu@yahoo.com', NULL, NULL, CAST(N'2023-09-26T13:29:36.597' AS DateTime), CAST(N'2023-09-26T13:29:36.597' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (6, N'Bambi', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'Bambi BB', N'bambi@gmail.com', NULL, NULL, CAST(N'2023-09-26T14:22:55.413' AS DateTime), CAST(N'2023-09-26T14:22:55.413' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (7, N'Abby', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'Abby Kc', N'abby@gmail.com', NULL, NULL, CAST(N'2023-09-26T14:24:10.250' AS DateTime), CAST(N'2023-09-26T14:24:10.250' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (8, N'Gada', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'Gada', N'gada@gmail.com', NULL, NULL, CAST(N'2023-09-26T14:25:09.527' AS DateTime), CAST(N'2023-09-26T14:25:09.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (9, N'Linda', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'Linda', N'linda@gmail.com', NULL, NULL, CAST(N'2023-09-26T14:25:32.157' AS DateTime), CAST(N'2023-09-26T14:25:32.157' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (10, N'Cindy', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'Cindy MM', N'cindy@gmail.com', NULL, NULL, CAST(N'2023-09-26T14:26:15.867' AS DateTime), CAST(N'2023-09-26T14:26:15.867' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (11, N'Rody', N'79FEC16E57AEBFABB2CE0DB947DB5B2936E9DD81A7EC44BE917C8107E848D6DD', N'Rody Su', N'rody@gmail.com', NULL, NULL, CAST(N'2023-09-26T14:27:19.640' AS DateTime), CAST(N'2023-09-26T14:27:19.640' AS DateTime), NULL, N'01c06c29d2d9475abd5735edae87f687', 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (12, N'aaa', N'F21C8DA4A6B8A08572ED24035A3DB14242CE46ED87D7FB7F72982BCE04674DC7', N'aaa', N'a@a', NULL, NULL, CAST(N'2023-10-05T17:13:46.867' AS DateTime), CAST(N'2023-10-05T17:13:46.867' AS DateTime), NULL, N'd0037c03bbc146bfa7edec2cae36c86b', NULL)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (13, N'b', N'834CED64CDAFBC1EC3D4761BE37D45C604DB43336CBA71E8C3480F92CABAE87A', N'b', N'b@b', NULL, NULL, CAST(N'2023-10-05T17:15:08.923' AS DateTime), CAST(N'2023-10-05T17:15:08.923' AS DateTime), NULL, N'453f4188f93248ebb0d1b44502875819', NULL)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (14, N'c', N'87D5C397C884B9741666FA210DE6D80EFE3566F7E32D50525270AECBC1E8E400', N'c', N'c@C', NULL, NULL, CAST(N'2023-10-05T17:16:19.277' AS DateTime), CAST(N'2023-10-05T17:16:19.277' AS DateTime), NULL, N'77c6f9fd337443c0802d0b6ee9fa31d8', NULL)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (15, N'1', N'C8BEAC423D56C5EEE167DAD23303CE24140884CC6481B63CDDDE8ABCFBF4C961', N'1', N'1@1', NULL, NULL, CAST(N'2023-10-05T17:29:14.453' AS DateTime), CAST(N'2023-10-05T17:29:14.453' AS DateTime), NULL, N'cb5b8ac72ae041b58a59e73ac36e4096', NULL)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (16, N'd', N'76782126344BA251F18EDE87DD615FA12D94DE202227144D79CCA38E4E0E07A5', N'd', N'd@d', NULL, NULL, CAST(N'2023-10-05T17:31:21.560' AS DateTime), CAST(N'2023-10-05T17:31:21.560' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (17, N'f', N'9530AE3600774BCBC7A748ACD334F4AFFF2415DF4033B7B29BEB48D3716A48B9', N'f', N'f@f', NULL, NULL, CAST(N'2023-10-05T17:39:22.660' AS DateTime), CAST(N'2023-10-05T17:39:22.660' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Members] ([Id], [Account], [Password], [Name], [Email], [Birthday], [Introduce], [CreatTime], [UpdateTime], [Image], [ConfirmCode], [IsConfirmed]) VALUES (18, N'aa', N'E74E56444798A6E881737B4F0A75553C8D758F79B993896EC74465F58490FAEF', N'aa', N'aa@aa', CAST(N'2023-10-20' AS Date), N'sssss', CAST(N'2023-10-05T17:40:46.310' AS DateTime), CAST(N'2023-10-05T17:40:46.310' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Members] OFF
GO
SET IDENTITY_INSERT [dbo].[News] ON 

INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (1, N'[2023.09]C# Asp.Net線上課程', N'2023-09-01課程即將再次上線~', CAST(N'2023-08-27T17:13:39.000' AS DateTime), CAST(N'2023-08-27T17:13:39.000' AS DateTime), 1)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (2, N'[2023.09]C#基礎線上課程', N'2023-09-01課程即將再次上線~', CAST(N'2023-08-27T17:19:39.000' AS DateTime), CAST(N'2023-08-27T17:19:39.000' AS DateTime), 2)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (3, N'2024 植物日記，即將開始預購~', N'2024植物月歷大受好評~2024植物日記繼續陪伴您!2023/10/03上線預購~', CAST(N'2023-09-30T13:13:59.000' AS DateTime), CAST(N'2023-09-30T13:13:59.000' AS DateTime), 3)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (4, N'全新企劃「身心障礙者x小型作業所 自立計畫」', N'2023/8/26上線，您的小小支持，可以讓身障朋友持續在小作所學習成長，擁有一個自立生活的機會，不用害怕被歧視、被侷限，他們將有無限可能！', CAST(N'2023-08-23T17:24:24.000' AS DateTime), CAST(N'2023-08-23T17:24:24.000' AS DateTime), 5)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (5, N'2024「平行世界拍攝計劃暨攝影展」', N'2023展覽計畫因經費不足，延期至明年我們將給大家帶來更好的作品，2023/10/01 希望大家支持計畫!期待明年能降雨大家相見~', CAST(N'2023-09-20T16:23:35.000' AS DateTime), CAST(N'2023-09-20T16:23:35.000' AS DateTime), 6)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (6, N'全新遊戲上線:《口袋香菇》多種香菇任你養殖', N'繼《口袋貓咪》再推出養成系手遊，10/3開始募資，歡迎揪伴支持我們的創作!!!', CAST(N'2023-09-22T15:52:14.000' AS DateTime), CAST(N'2023-09-22T15:52:14.000' AS DateTime), 7)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (7, N'【2024臺北喵嗚季】來了!', N'有了汪汪也不能忘記可愛的喵喵，2023-10-05 準時開啟計畫!快來一起當貓奴吧!', CAST(N'2023-09-22T14:52:14.000' AS DateTime), CAST(N'2023-09-22T14:52:14.000' AS DateTime), 8)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (8, N'全新企劃「舞蹈演出x公益計畫」', N'2023/10/01上線，今年與各種舞蹈團體合作演出，您的投資除了必須演出必須支出，都將投入公益計畫中。', CAST(N'2023-09-23T16:23:35.000' AS DateTime), CAST(N'2023-09-23T16:23:35.000' AS DateTime), 10)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (9, N'[2023.09]C#基礎線上課程', N'沒學習過基礎的同學們，同時有開放基礎課程歡迎選購!', CAST(N'2023-10-01T13:33:39.000' AS DateTime), CAST(N'2023-10-01T13:33:39.000' AS DateTime), 11)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (10, N'[2023.09]C# Asp.Net線上課程', N'想學習進階課程的同學們，同時有Asp.Net的課程能簡單架設出屬於自己的網站!', CAST(N'2023-10-01T13:33:39.000' AS DateTime), CAST(N'2023-10-01T13:33:39.000' AS DateTime), 12)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (11, N'[2023.09]C#基礎線上課程、 Asp.Net線上課程', N'2023-09-01開授課程1.C#基礎 2.C# Asp.Net!', CAST(N'2023-10-01T13:50:39.000' AS DateTime), CAST(N'2023-10-01T13:50:39.000' AS DateTime), 16)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (12, N'寵物世界APP集資，快來幫助浪浪們!', N'2023/09/22開始集資新項目，我們希望每隻流浪的毛孩們在生命到了盡頭時，不再像垃圾一樣被丟棄，而能好好走完最後一哩路。
我們提供以下三項服務：浪浪送行、毛孩領養、毛孩協尋
未來希望透過APP能更立即、快速的幫助到浪浪、毛孩
APP主要有四大功能：通報、領養、討論、物資招募
通報是本次APP架設的重點，其中包含兩項：〈火化通報〉及〈走失通報〉
集資的費用主要花在APP的設計、架設及維護，若有其他餘額我們將會在火化及領養浪浪的相關基礎醫療上給予補助。', CAST(N'2023-10-01T14:50:39.000' AS DateTime), CAST(N'2023-10-01T14:50:39.000' AS DateTime), 14)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (13, N'21 st PRIDE T', N'2023/09/11已開始集資，在這個世界上，每一個生命都有其獨特的價值，每個人都有權利獲得尊重、平等，無論是誰，都應該享有自由展現自我的權利。我們將這個信念融入一件T恤，更是一個象徵，一種宣言，關於生命平權和性別平權的宣言。', CAST(N'2023-10-30T13:53:39.000' AS DateTime), CAST(N'2023-10-01T15:10:39.000' AS DateTime), 15)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (15, N'《口袋貓咪》多種貓咪任你養', N'募資即將在10/19 00:00結束，多種貓咪療癒你每一刻，快來加入我們的行列吧!!!', CAST(N'2023-10-03T09:10:10.000' AS DateTime), CAST(N'2023-10-03T09:10:10.000' AS DateTime), 21)
INSERT [dbo].[News] ([Id], [Name], [Description], [CreatTime], [UpdateTime], [ProjectId]) VALUES (16, N'【2024臺北汪汪季】全國最大狗狗主題市集', N'募資即將在10/21 00:00結束，喜歡汪汪的朋友們不要忘記了~', CAST(N'2023-10-05T09:10:10.000' AS DateTime), CAST(N'2023-10-05T09:10:10.000' AS DateTime), 22)
SET IDENTITY_INSERT [dbo].[News] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderItems] ON 

INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (1, 1, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (2, 2, 1, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (3, 3, 1, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (4, 4, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (5, 5, 2, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (6, 6, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (7, 7, 3, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (8, 8, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (9, 9, 4, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (10, 10, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (11, 11, 5, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (12, 12, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (13, 13, 6, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (14, 14, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (15, 15, 7, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (16, 16, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (17, 17, 8, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (18, 18, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (19, 19, 9, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (20, 20, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (21, 21, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (22, 22, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (23, 23, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (24, 24, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (25, 25, 10, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (26, 26, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (27, 27, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (28, 28, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (29, 29, 11, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (30, 30, 12, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (31, 31, 12, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (32, 32, 12, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (33, 33, 13, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (34, 34, 13, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (35, 35, 13, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (36, 36, 14, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (37, 37, 14, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (38, 38, 15, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (39, 39, 15, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (40, 40, 16, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (41, 41, 16, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (42, 42, 16, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (43, 43, 16, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (44, 44, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (45, 45, 17, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (46, 46, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (47, 47, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (48, 48, 18, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (49, 49, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (50, 50, 19, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (51, 51, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (52, 52, 20, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (53, 53, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (54, 54, 21, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (55, 55, 22, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (56, 56, 23, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (57, 57, 24, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (58, 58, 25, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (59, 59, 26, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (60, 60, 27, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (61, 61, 28, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (62, 62, 28, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (63, 63, 28, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (64, 64, 29, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (65, 65, 29, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (66, 66, 30, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (67, 67, 30, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (68, 68, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (69, 69, 31, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (70, 70, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (71, 71, 32, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (72, 72, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (73, 73, 33, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (74, 74, 37, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (75, 75, 37, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (76, 76, 38, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (77, 77, 38, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (78, 78, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (79, 79, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (80, 80, 39, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (81, 81, 40, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (82, 82, 43, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (83, 83, 44, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (84, 84, 41, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (85, 85, 51, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (86, 86, 52, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (87, 87, 53, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (88, 88, 54, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (89, 89, 55, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (90, 90, 56, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (91, 91, 57, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (92, 92, 58, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (93, 93, 59, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (94, 94, 60, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (95, 95, 61, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (96, 96, 59, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (97, 97, 60, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (98, 98, 61, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (99, 99, 66, 1)
GO
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (100, 100, 67, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (101, 101, 59, 1)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Qty]) VALUES (102, 102, 52, 1)
SET IDENTITY_INSERT [dbo].[OrderItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (1, N'20230926001', 1, CAST(N'2023-09-26T15:00:00.000' AS DateTime), 300, 12, 9, 4)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (2, N'20230926002', 2, CAST(N'2023-09-26T15:10:00.000' AS DateTime), 5500, 12, 10, 5)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (3, N'20230926003', 3, CAST(N'2023-09-26T15:20:00.000' AS DateTime), 5500, 12, 11, 6)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (4, N'20230926004', 5, CAST(N'2023-09-26T15:30:00.000' AS DateTime), 6000, 12, 9, 7)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (5, N'20230926005', 6, CAST(N'2023-09-26T15:40:00.000' AS DateTime), 6000, 12, 10, 8)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (6, N'20230926006', 7, CAST(N'2023-09-26T16:05:00.000' AS DateTime), 6000, 12, 11, 9)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (7, N'20230926007', 8, CAST(N'2023-09-26T17:00:00.000' AS DateTime), 6000, 12, 9, 10)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (8, N'20230926008', 9, CAST(N'2023-09-26T18:00:00.000' AS DateTime), 5500, 12, 10, 11)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (9, N'20230926009', 10, CAST(N'2023-09-26T19:00:00.000' AS DateTime), 5500, 12, 11, 12)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (10, N'20230926010', 11, CAST(N'2023-09-26T19:20:00.000' AS DateTime), 6000, 12, 9, 13)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (11, N'20230927001', 1, CAST(N'2023-09-27T09:00:00.000' AS DateTime), 6000, 12, 10, 14)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (12, N'20230927002', 2, CAST(N'2023-09-27T10:00:00.000' AS DateTime), 6000, 12, 11, 15)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (13, N'20230927003', 3, CAST(N'2023-09-27T11:00:00.000' AS DateTime), 6000, 12, 9, 16)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (14, N'20230927004', 5, CAST(N'2023-09-27T12:00:00.000' AS DateTime), 300, 12, 10, 17)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (15, N'20230927005', 6, CAST(N'2023-09-27T13:00:00.000' AS DateTime), 300, 12, 11, 18)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (16, N'20230927006', 7, CAST(N'2023-09-27T14:00:00.000' AS DateTime), 540, 12, 9, 19)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (17, N'20230927007', 8, CAST(N'2023-09-27T15:00:00.000' AS DateTime), 540, 12, 10, 20)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (18, N'20230927008', 9, CAST(N'2023-09-27T16:00:00.000' AS DateTime), 1275, 12, 11, 21)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (19, N'20230927009', 10, CAST(N'2023-09-27T17:00:00.000' AS DateTime), 1275, 12, 9, 22)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (20, N'20230927010', 11, CAST(N'2023-09-27T18:00:00.000' AS DateTime), 100, 12, 10, 23)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (21, N'20230928001', 1, CAST(N'2023-09-28T10:00:00.000' AS DateTime), 100, 12, 11, 24)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (22, N'20230928002', 2, CAST(N'2023-09-28T11:00:00.000' AS DateTime), 100, 12, 9, 25)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (23, N'20230928003', 3, CAST(N'2023-09-28T12:00:00.000' AS DateTime), 100, 12, 10, 26)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (24, N'20230928004', 5, CAST(N'2023-09-28T13:00:00.000' AS DateTime), 100, 12, 11, 27)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (25, N'20230928005', 6, CAST(N'2023-09-28T14:00:00.000' AS DateTime), 100, 12, 9, 28)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (26, N'20230928006', 7, CAST(N'2023-09-28T15:00:00.000' AS DateTime), 250, 12, 10, 29)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (27, N'20230928007', 8, CAST(N'2023-09-28T16:00:00.000' AS DateTime), 250, 12, 11, 30)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (28, N'20230928008', 9, CAST(N'2023-09-28T17:00:00.000' AS DateTime), 250, 12, 9, 31)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (29, N'20230928009', 10, CAST(N'2023-09-28T18:00:00.000' AS DateTime), 250, 12, 10, 32)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (30, N'20230928010', 11, CAST(N'2023-09-28T19:00:00.000' AS DateTime), 600, 12, 11, 33)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (31, N'20230929001', 7, CAST(N'2023-09-29T10:00:00.000' AS DateTime), 600, 12, 9, 34)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (32, N'20230929002', 1, CAST(N'2023-09-29T11:00:00.000' AS DateTime), 600, 12, 10, 35)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (33, N'20230929003', 6, CAST(N'2023-09-29T12:00:00.000' AS DateTime), 100, 12, 11, 36)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (34, N'20230929004', 2, CAST(N'2023-09-29T13:00:00.000' AS DateTime), 100, 12, 9, 37)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (35, N'20230929005', 9, CAST(N'2023-09-29T14:00:00.000' AS DateTime), 100, 12, 10, 38)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (36, N'20230929006', 1, CAST(N'2023-09-29T15:00:00.000' AS DateTime), 500, 12, 11, 39)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (37, N'20230929007', 6, CAST(N'2023-09-29T16:00:00.000' AS DateTime), 500, 12, 9, 40)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (38, N'20230929008', 7, CAST(N'2023-09-29T17:00:00.000' AS DateTime), 250, 12, 10, 41)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (39, N'20230929009', 8, CAST(N'2023-09-29T18:00:00.000' AS DateTime), 250, 12, 11, 42)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (40, N'20230929010', 1, CAST(N'2023-09-29T19:00:00.000' AS DateTime), 1500, 12, 9, 43)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (41, N'20230930001', 3, CAST(N'2023-09-30T10:00:00.000' AS DateTime), 1500, 12, 10, 44)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (42, N'20230930002', 5, CAST(N'2023-09-30T11:00:00.000' AS DateTime), 1500, 12, 11, 45)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (43, N'20230930003', 1, CAST(N'2023-09-30T12:00:00.000' AS DateTime), 1500, 12, 9, 46)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (44, N'20230930004', 2, CAST(N'2023-09-30T13:00:00.000' AS DateTime), 200, 13, 10, 47)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (45, N'20230930005', 5, CAST(N'2023-09-30T14:00:00.000' AS DateTime), 200, 12, 11, 48)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (46, N'20230930006', 2, CAST(N'2023-09-30T15:00:00.000' AS DateTime), 1500, 12, 9, 49)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (47, N'20230930007', 9, CAST(N'2023-09-30T16:00:00.000' AS DateTime), 1500, 12, 10, 50)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (48, N'20230930008', 10, CAST(N'2023-09-30T17:00:00.000' AS DateTime), 1500, 12, 11, 51)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (49, N'20230930009', 11, CAST(N'2023-09-30T18:00:00.000' AS DateTime), 350, 12, 9, 52)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (50, N'20230930010', 8, CAST(N'2023-09-30T19:00:00.000' AS DateTime), 350, 12, 10, 53)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (51, N'20231001001', 1, CAST(N'2023-10-01T10:00:00.000' AS DateTime), 850, 12, 11, 54)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (52, N'20231001002', 1, CAST(N'2023-10-01T11:00:00.000' AS DateTime), 850, 12, 9, 55)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (53, N'20231001003', 2, CAST(N'2023-10-01T12:00:00.000' AS DateTime), 200, 12, 10, 56)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (54, N'20231001004', 3, CAST(N'2023-10-01T13:00:00.000' AS DateTime), 200, 12, 11, 57)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (55, N'20231001005', 5, CAST(N'2023-10-01T14:00:00.000' AS DateTime), 10000, 12, 9, 58)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (56, N'20231001006', 1, CAST(N'2023-10-01T15:00:00.000' AS DateTime), 10000, 12, 10, 59)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (57, N'20231001007', 2, CAST(N'2023-10-01T16:00:00.000' AS DateTime), 10000, 12, 11, 60)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (58, N'20231001008', 1, CAST(N'2023-10-01T17:00:00.000' AS DateTime), 500, 12, 9, 61)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (59, N'20231001009', 1, CAST(N'2023-10-01T18:00:00.000' AS DateTime), 1800, 12, 10, 62)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (60, N'20231001010', 2, CAST(N'2023-10-01T19:00:00.000' AS DateTime), 6600, 12, 11, 63)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (61, N'20231002001', 9, CAST(N'2023-10-02T10:00:00.000' AS DateTime), 5500, 12, 9, 64)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (62, N'20231002002', 10, CAST(N'2023-10-02T11:00:00.000' AS DateTime), 5500, 12, 10, 65)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (63, N'20231002003', 11, CAST(N'2023-10-02T12:00:00.000' AS DateTime), 5500, 12, 11, 66)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (64, N'20231002004', 6, CAST(N'2023-10-02T13:00:00.000' AS DateTime), 6000, 12, 9, 67)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (65, N'20231002005', 7, CAST(N'2023-10-02T14:00:00.000' AS DateTime), 6000, 12, 10, 68)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (66, N'20231002006', 6, CAST(N'2023-10-02T15:00:00.000' AS DateTime), 6000, 12, 11, 18)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (67, N'20231002007', 3, CAST(N'2023-10-02T16:00:00.000' AS DateTime), 6000, 12, 9, 44)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (68, N'20231002008', 5, CAST(N'2023-10-02T17:00:00.000' AS DateTime), 5500, 12, 10, 45)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (69, N'20231002009', 9, CAST(N'2023-10-02T18:00:00.000' AS DateTime), 5500, 12, 11, 31)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (70, N'20231002010', 2, CAST(N'2023-10-02T19:00:00.000' AS DateTime), 6000, 12, 9, 47)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (71, N'20231003001', 5, CAST(N'2023-10-03T10:00:00.000' AS DateTime), 6000, 12, 10, 48)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (72, N'20231003002', 2, CAST(N'2023-10-03T11:00:00.000' AS DateTime), 6000, 12, 11, 49)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (73, N'20231003003', 9, CAST(N'2023-10-03T12:00:00.000' AS DateTime), 6000, 12, 9, 50)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (74, N'20231003004', 10, CAST(N'2023-10-03T13:00:00.000' AS DateTime), 300, 12, 10, 51)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (75, N'20231003005', 11, CAST(N'2023-10-03T14:00:00.000' AS DateTime), 300, 12, 11, 52)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (76, N'20231003006', 8, CAST(N'2023-10-03T15:00:00.000' AS DateTime), 300, 12, 9, 53)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (77, N'20231003007', 11, CAST(N'2023-10-03T16:00:00.000' AS DateTime), 300, 12, 10, 23)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (78, N'20231003008', 2, CAST(N'2023-10-03T17:00:00.000' AS DateTime), 500, 12, 11, 37)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (79, N'20231003009', 9, CAST(N'2023-10-03T18:00:00.000' AS DateTime), 500, 12, 10, 38)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (80, N'20231003010', 1, CAST(N'2023-10-03T19:00:00.000' AS DateTime), 500, 13, 9, 39)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (81, N'20231004001', 8, CAST(N'2023-10-04T10:00:00.000' AS DateTime), 500, 12, 11, 30)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (82, N'20231004002', 9, CAST(N'2023-10-04T11:00:00.000' AS DateTime), 5000, 12, 9, 31)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (83, N'20231004003', 10, CAST(N'2023-10-04T12:00:00.000' AS DateTime), 5000, 12, 10, 32)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (84, N'20231004004', 11, CAST(N'2023-10-04T13:00:00.000' AS DateTime), 1000, 12, 11, 33)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (85, N'20231004005', 7, CAST(N'2023-10-04T14:00:00.000' AS DateTime), 250, 12, 9, 34)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (86, N'20231004006', 1, CAST(N'2023-10-04T15:00:00.000' AS DateTime), 500, 12, 10, 35)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (87, N'20231004007', 6, CAST(N'2023-10-04T16:00:00.000' AS DateTime), 300, 12, 11, 36)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (88, N'20231004008', 2, CAST(N'2023-10-04T17:00:00.000' AS DateTime), 540, 12, 9, 37)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (89, N'20231004009', 9, CAST(N'2023-10-04T18:00:00.000' AS DateTime), 1275, 12, 10, 38)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (90, N'20231004010', 1, CAST(N'2023-10-04T19:00:00.000' AS DateTime), 1500, 12, 11, 39)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (91, N'20231005001', 6, CAST(N'2023-10-05T10:00:00.000' AS DateTime), 800, 12, 9, 40)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (92, N'20231005002', 7, CAST(N'2023-10-05T11:00:00.000' AS DateTime), 200, 12, 10, 41)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (93, N'20231005003', 8, CAST(N'2023-10-05T12:00:00.000' AS DateTime), 200, 12, 11, 42)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (94, N'20231005004', 1, CAST(N'2023-10-05T13:00:00.000' AS DateTime), 350, 12, 9, 43)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (95, N'20231005005', 3, CAST(N'2023-10-05T14:00:00.000' AS DateTime), 850, 12, 10, 44)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (96, N'20231005006', 5, CAST(N'2023-10-05T15:00:00.000' AS DateTime), 200, 12, 11, 45)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (97, N'20231005007', 1, CAST(N'2023-10-05T16:00:00.000' AS DateTime), 350, 12, 9, 46)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (98, N'20231005008', 2, CAST(N'2023-10-05T17:00:00.000' AS DateTime), 850, 12, 10, 47)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (99, N'20231005009', 5, CAST(N'2023-10-05T18:00:00.000' AS DateTime), 250, 12, 11, 48)
GO
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (100, N'20231005010', 7, CAST(N'2023-10-05T19:00:00.000' AS DateTime), 500, 12, 9, 9)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (101, N'20231005871', 18, CAST(N'2023-10-05T18:13:59.037' AS DateTime), 0, 12, 9, 69)
INSERT [dbo].[Orders] ([Id], [No], [MemberId], [OrderTime], [Total], [PaymentIStatusId], [PaymentId], [RecipientId]) VALUES (102, N'20231005571', 18, CAST(N'2023-10-05T18:20:49.527' AS DateTime), 500, 12, 9, 70)
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[Pages] ON 

INSERT [dbo].[Pages] ([Id], [Name], [DefaultVisible], [ParentId], [KeyValue]) VALUES (3, N'專案管理
', 0, NULL, N'ProjectManager')
INSERT [dbo].[Pages] ([Id], [Name], [DefaultVisible], [ParentId], [KeyValue]) VALUES (4, N'目錄清單
', 0, NULL, N'Web_Category')
INSERT [dbo].[Pages] ([Id], [Name], [DefaultVisible], [ParentId], [KeyValue]) VALUES (5, N'常見問題
', 0, NULL, N'Web_FAQ')
INSERT [dbo].[Pages] ([Id], [Name], [DefaultVisible], [ParentId], [KeyValue]) VALUES (9, N'權限管理 
', 0, NULL, N'Permission')
INSERT [dbo].[Pages] ([Id], [Name], [DefaultVisible], [ParentId], [KeyValue]) VALUES (10, N'用戶管理
', 0, NULL, N'UserManager')
SET IDENTITY_INSERT [dbo].[Pages] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (1, N'C# Asp.Net初級課程(上)零基礎教學', 150, 5500, 1, N'56C.jpg', CAST(N'2023-07-25T17:38:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (2, N'C# Asp.Net初級課程(中)存取資料庫相關技術及常用技巧', 100, 6000, 1, N'51C.jpg', CAST(N'2023-07-25T17:48:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (3, N'C#Asp.Net初級課程(下)實做線上購物商城', 100, 6000, 1, N'55C.jpg', CAST(N'2023-07-25T17:58:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (4, N'C# 入門課程', 500, 5500, 2, N'53C.jpg', CAST(N'2023-07-25T18:08:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (5, N'C# 物件導向程式設計', 300, 6000, 2, N'54C.jpg', CAST(N'2023-07-25T18:18:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (6, N'C# 存取資料庫', 100, 6000, 2, N'52C.jpg', CAST(N'2023-07-25T18:28:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (7, N'植物日曆1本', 100, 300, 3, N'01C.jpg', CAST(N'2023-07-26T17:38:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (8, N'植物日歷2本', 50, 540, 3, N'01C.jpg', CAST(N'2023-07-26T17:38:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (9, N'植物日歷5本', 50, 1275, 3, N'01C.jpg', CAST(N'2023-07-26T17:58:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (10, N'立體摺紙星星裝飾2組', 10, 450, 4, N'40C.jpg', CAST(N'2023-07-28T17:38:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (11, N'立體摺紙星星裝飾5組', 10, 2000, 4, N'40C.jpg', CAST(N'2023-07-28T17:44:43.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (12, N'專輯一張', 100, 600, 5, N'50C.jpg', CAST(N'2023-08-01T14:27:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (13, N'愛心捐款', 100, 100, 5, N'87C.jpg', CAST(N'2023-08-01T14:57:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (14, N'早鳥優惠票', 100, 250, 6, N'96C.jpg', CAST(N'2023-08-03T14:27:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (15, N'早鳥雙人套票', 100, 500, 6, N'97C.jpg', CAST(N'2023-08-03T14:39:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (16, N'沐沐限定貓咪5隻+大禮包(零食5包、逗貓棒1隻、限定布景組合)', 50, 1500, 7, N'82C.jpg', CAST(N'2023-08-05T14:27:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (17, N'沐沐限定貓咪3隻+小禮包(零食3包、逗貓棒1隻)', 50, 800, 7, N'82C.jpg', CAST(N'2023-08-05T14:33:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (18, N'沐沐限定貓咪1隻', 100, 200, 7, N'82C.jpg', CAST(N'2023-08-05T14:45:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (19, N'早鳥雙人套票', 50, 350, 8, N'84C.jpg', CAST(N'2023-08-09T14:27:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (20, N'早鳥團體票五張', 10, 850, 8, N'84C.jpg', CAST(N'2023-08-09T14:39:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (21, N'早鳥限定票', 100, 200, 8, N'84C.jpg', CAST(N'2023-08-09T14:47:32.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (22, N'灰沙發', 10, 10000, 9, N'58C.jpg', CAST(N'2023-08-10T08:32:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (23, N'綠沙發', 10, 10000, 9, N'B06.jpg', CAST(N'2023-08-10T08:52:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (24, N'橘沙發', 10, 10000, 9, N'B07.jpg', CAST(N'2023-08-10T09:32:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (25, N'挺就業:感謝有您，給予身心障礙者勇往職前的力量！', 200, 500, 10, N'90C.jpg', CAST(N'2023-08-15T09:32:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (26, N'挺自立:支持3天小作所服務，讓愛得以延續', 100, 1800, 10, N'90C.jpg', CAST(N'2023-08-15T09:42:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (27, N'挺到底:支持2周小作所服務，讓愛得以延續', 60, 6600, 10, N'90C.jpg', CAST(N'2023-08-15T09:52:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (28, N'C# Asp.Net初級課程(上)零基礎教學', 150, 5500, 11, N'56C.jpg', CAST(N'2023-08-16T09:32:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (29, N'C# Asp.Net初級課程(中)存取資料庫相關技術及常用技巧', 100, 6000, 11, N'51C.jpg', CAST(N'2023-08-16T09:43:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (30, N'C#Asp.Net初級課程(下)實做線上購物商城', 100, 6000, 11, N'55C.jpg', CAST(N'2023-08-16T09:56:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (31, N'C# 入門課程', 500, 5500, 12, N'53C.jpg', CAST(N'2023-08-16T10:12:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (32, N'C# 物件導向程式設計', 300, 6000, 12, N'54C.jpg', CAST(N'2023-08-16T10:22:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (33, N'C# 存取資料庫', 100, 6000, 12, N'52C.jpg', CAST(N'2023-08-16T10:32:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (34, N'玫瑰保濕、金盞花舒緩、薰衣草放鬆香皂單入(請記得在備註欄填寫款式，未填隨機出貨)', 30, 500, 13, N'07C.jpg', CAST(N'2023-08-17T10:32:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (35, N'玫瑰保濕、金盞花舒緩、薰衣草放鬆香皂1組3入小禮盒', 30, 1500, 13, N'07C.jpg', CAST(N'2023-08-17T10:39:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (36, N'玫瑰保濕、金盞花舒緩、薰衣草放鬆香皂2組6入小禮盒', 30, 3000, 13, N'07C.jpg', CAST(N'2023-08-17T10:47:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (37, N'白T-Shirt 1件', 100, 300, 14, N'48C.jpg', CAST(N'2023-08-18T10:32:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (38, N'灰T-Shirt 1件', 100, 300, 14, N'49C.jpg', CAST(N'2023-08-18T10:52:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (39, N'T-Shirt包色各1件', 100, 500, 14, N'43C.jpg', CAST(N'2023-08-18T11:24:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (40, N'電子感謝函一封', 500, 500, 15, N'92C.jpg', CAST(N'2023-08-21T11:24:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (41, N'電子感謝函一封+環保袋一個', 500, 1000, 15, N'92C.jpg', CAST(N'2023-08-21T11:44:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (42, N'電子感謝函一封+環保餐具一組', 500, 2000, 15, N'92C.jpg', CAST(N'2023-08-21T12:04:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (43, N'白色鍵盤', 500, 5000, 16, N'B20.jpg', CAST(N'2023-08-24T12:04:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (44, N'黑色鍵盤', 500, 5000, 16, N'B18.jpg', CAST(N'2023-08-24T12:24:55.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (45, N'C# Asp.Net初級課程(上)零基礎教學', 150, 5500, 17, N'56C.jpg', CAST(N'2023-09-07T13:03:39.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (46, N'C# Asp.Net初級課程(中)存取資料庫相關技術及常用技巧', 100, 6000, 17, N'51C.jpg', CAST(N'2023-09-07T13:08:39.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (47, N'C#Asp.Net初級課程(下)實做線上購物商城', 100, 6000, 17, N'55C.jpg', CAST(N'2023-09-07T13:13:39.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (48, N'C# 入門課程', 500, 5500, 18, N'53C.jpg', CAST(N'2023-09-08T17:02:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (49, N'C# 物件導向程式設計', 300, 6000, 18, N'54C.jpg', CAST(N'2023-09-08T17:10:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (50, N'C# 存取資料庫', 100, 6000, 18, N'52C.jpg', CAST(N'2023-09-08T17:19:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (51, N'早鳥優惠票', 100, 250, 19, N'98C.jpg', CAST(N'2023-09-10T17:19:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (52, N'早鳥雙人套票', 100, 500, 19, N'99C.jpg', CAST(N'2023-09-10T17:26:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (53, N'植物日曆1本', 100, 300, 20, N'03C.jpeg', CAST(N'2023-09-11T17:26:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (54, N'植物日歷2本', 50, 540, 20, N'03C.jpeg', CAST(N'2023-09-11T17:29:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (55, N'植物日歷5本', 50, 1275, 20, N'03C.jpeg', CAST(N'2023-09-11T17:34:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (56, N'沐沐限定香菇5個+大禮包(加速培養土5包、容器3種、布景組合)', 50, 1500, 21, N'77C.jpg', CAST(N'2023-09-06T17:26:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (57, N'沐沐限定香菇3個+大禮包(加速培養土3包、容器1種)', 50, 800, 21, N'77C.jpg', CAST(N'2023-09-06T18:26:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (58, N'沐沐限定香菇1個', 100, 200, 21, N'77C.jpg', CAST(N'2023-09-06T19:26:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (59, N'早鳥限定票', 100, 200, 22, N'79C.jpg', CAST(N'2023-09-10T19:26:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (60, N'早鳥雙人套票', 50, 350, 22, N'79C.jpg', CAST(N'2023-09-10T19:45:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (61, N'早鳥團體票五張', 10, 850, 22, N'79C.jpg', CAST(N'2023-09-10T19:58:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (62, N'粉短夾1個', 100, 1000, 23, N'B29.jpg', CAST(N'2023-09-10T15:28:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (63, N'綠短夾1個', 100, 1000, 23, N'B30.jpg', CAST(N'2023-09-10T15:58:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (64, N'褐短夾1個', 100, 1000, 23, N'B31.jpg', CAST(N'2023-09-10T14:58:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (65, N'電子感謝函一封', 1000, 100, 24, N'86C.jpg', CAST(N'2023-09-09T14:18:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (66, N'早鳥優惠票', 100, 250, 24, N'100C.jpg', CAST(N'2023-09-09T14:29:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (67, N'早鳥雙人套票', 100, 500, 24, N'101C.jpg', CAST(N'2023-09-09T14:33:19.000' AS DateTime))
INSERT [dbo].[Products] ([Id], [Detail], [Qty], [Price], [ProjectId], [Image], [UpdateTime]) VALUES (71, N'5', 5, 5, 60, N'vnwanvlp.ktm.jpg', CAST(N'2023-10-05T19:04:46.570' AS DateTime))
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[Projects] ON 

INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (1, 7, 1, N'[2023.08]C# Asp.Net線上課程', N'73C.jpg', N'這是一門針對已經學過 C# 但完全不曾開發網站應用程式的人準備的 ASP.NET MVC 入門課程，會先教一些簡單的 HTML、CSS、JavaScript、Database 基本知識，大約可以開發簡單的網站功能。
課程不會從 C# 基礎語法開始教，課程的出發點是針對想學習發 ASP.NET MVC 網站應用程式的人；如果您需要學習最基礎的C#語法，建議先買我的 C# 零基礎入門課程。', 50000, CAST(N'2023-08-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 15, 1, 17, CAST(N'2023-08-27T17:13:39.000' AS DateTime), CAST(N'2023-07-28T17:38:43.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (2, 7, 1, N'[2023.08]C#基礎線上課程', N'59C.jpg', N'你是否想學習編程，但害怕太難嗎？或者你已經知道其他編程語言，但要快速學習C#語言？
這課程將用簡明，易懂方式來學習C#，複雜的概念被分解成簡單的步驟，以確保您即使未編碼過，仍可以掌握。
課程使用精選題及實例讓你廣泛接觸C#，但學習C#的最好方法是親手執行代碼，提供的課程講義中有大量習題可以自行做課後練習，遇到問題歡迎聯繫我，給予回覆算是課後服務之一。
', 30000, CAST(N'2023-08-01T00:00:00.000' AS DateTime), CAST(N'2023-09-01T00:00:00.000' AS DateTime), 15, 1, 16, CAST(N'2023-08-27T17:19:39.000' AS DateTime), CAST(N'2023-07-28T17:43:43.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (3, 3, 3, N'2024 植物月歷', N'01C.jpg', N'每月一種手繪植物插畫，認識一種植物，
每月一句心靈小語，得到一些生活的思考與啟發，
用不張揚的簡約設計融入你的生活，我們把每一天過好，就能過好這一生。質感黑翻頁月曆!', 3000, CAST(N'2023-08-05T00:00:00.000' AS DateTime), CAST(N'2023-10-05T00:00:00.000' AS DateTime), 30, 1, 16, CAST(N'2023-09-30T13:13:59.000' AS DateTime), CAST(N'2023-07-29T17:13:59.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (4, 6, 2, N'2023立體摺紙星星裝飾', N'40C.jpg', N'動手裝飾空間的各個角落，讓星星陪著你度過美好的一天天。
DIY摺紙作品，附上星星、10組材料及操作手冊，加上自己的創意做出獨一無二的星星~
(星星每組3顆大的2顆小的且顏色隨機)', 5000, CAST(N'2023-08-10T00:00:00.000' AS DateTime), CAST(N'2023-10-10T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-08-01T17:28:45.000' AS DateTime), CAST(N'2023-08-04T17:28:45.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (5, 1, 5, N'《唱自己的歌》圓夢計畫', N'47C.jpg', N'給孩子一個舞台，成就夢想！
你用甚麼樣的方式來表達自己的故事、情感，以及對生命的感動？有一群孩子將自己的夢想透過歌聲來傳遞，希望能得到更多的了解與關注，對這群來自偏鄉的孩童來說，音樂是一種自信，更是一種富足，計畫透過導入才藝師資、補助才藝學習經費，讓偏鄉地區的孩子們有學習多元才藝的機會。
今年更發行迷你專輯，收錄來自各地偏鄉地區孩子的創作與歌聲。
伊甸不放棄每個孩子勇往追求夢想的機會，邀您支持。', 3000, CAST(N'2023-08-15T00:00:00.000' AS DateTime), CAST(N'2023-10-15T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-08-23T17:24:24.000' AS DateTime), CAST(N'2023-08-07T16:23:35.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (6, 2, 6, N'2023「平行世界拍攝計劃暨攝影展」', N'57C.jpg', N'「平行世界拍攝計劃暨攝影展」，希望借由影像拍攝，創作一系列「想像的平凡人生樣貌」，並借由視覺與意義上的矛盾衝突，呈現受難者無法擁有的生命樣貌，讓觀者感受更多的衝擊與啟發。
白色恐怖政治受難者是台灣威權時期的重要見證者，但隨著時間流逝，受難前輩們逐漸凋零逝去，原本擁有遠大夢想的年輕人們，就這樣遭受人生中的巨變，生命就此轉了彎，倘若沒有「白色恐怖」，他們的生命將會如何呢？又將以怎樣的姿態去追求人生？
展覽日期｜2023.11.01- 2023.11.30
開展時間｜09：00 - 17：00
展覽地點｜國家人權博物館景美紀念園區禮堂（地址：新北市新店區復興路131號）', 10000, CAST(N'2023-08-16T00:00:00.000' AS DateTime), CAST(N'2023-09-30T00:00:00.000' AS DateTime), 15, 1, 17, CAST(N'2023-09-20T16:23:35.000' AS DateTime), CAST(N'2023-08-08T16:23:35.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (7, 4, 7, N'《口袋貓咪》多種貓咪任你養', N'75C.jpg', N'可愛療癒的貓奴手遊，除了讓你收集多種貓咪之外，還可以瞭解貓咪相關知識。現已上線一個小版本，我們想要豐富遊戲內容，讓大家更認識貓咪。期待你加入鏟屎官行列！
回饋為虛擬商品，一個遊戲帳號限使用一組序號
，遊戲序號預計最晚2023/12/25發送。', 10000, CAST(N'2023-08-19T00:00:00.000' AS DateTime), CAST(N'2023-10-19T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-09-22T15:52:14.000' AS DateTime), CAST(N'2023-08-13T15:52:14.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (8, 8, 8, N'【2024臺北汪汪季】全國最大狗狗主題市集', N'80C.jpg', N'【2024臺北汪汪季】來了!!!
這是一場結合文創、動保、公益、產業發展、地方創生等多元面向，以市集、講座、策展等方式呈現的大型狗狗主題活動，以歡樂互動的趣味亮點增加觀展的參與度。預計11/15~20在南港展覽館與大家見面。', 2000, CAST(N'2023-08-22T00:00:00.000' AS DateTime), CAST(N'2023-10-22T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-09-22T14:52:14.000' AS DateTime), CAST(N'2023-08-18T15:52:14.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (9, 5, 9, N'支撐全家人幸福的沙發', N'02C.jpg', N'擇你所愛，愛你所擇。我們選擇一款體貼全家人的沙發，凝聚一家人的感情，並運用不同進口材質的布料，打造一個十年不壞消費者才愛的沙發。
為了保障彼此，計畫還在建構中，募資結束才會開始客製大家的沙發，大型家具需久候請見諒。', 20000, CAST(N'2023-08-24T00:00:00.000' AS DateTime), CAST(N'2023-10-24T00:00:00.000' AS DateTime), 90, 1, 14, CAST(N'2023-08-12T21:14:56.000' AS DateTime), CAST(N'2023-08-19T14:42:54.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (10, 1, 5, N'身心障礙者x小型作業所 自立計畫', N'90C.jpg', N'您的小小支持，可以讓身障朋友持續在小作所學習成長，擁有一個自立生活的機會，不用害怕被歧視、被侷限，他們將有無限可能！', 10000, CAST(N'2023-08-26T00:00:00.000' AS DateTime), CAST(N'2023-10-26T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-09-23T16:23:35.000' AS DateTime), CAST(N'2023-08-21T17:24:24.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (11, 7, 1, N'[2023.09]C# Asp.Net線上課程', N'74C.jpg', N'這是一門針對已經學過 C# 但完全不曾開發網站應用程式的人準備的 ASP.NET MVC 入門課程，會先教一些簡單的 HTML、CSS、JavaScript、Database 基本知識，大約可以開發簡單的網站功能。
課程不會從 C# 基礎語法開始教，課程的出發點是針對想學習發 ASP.NET MVC 網站應用程式的人；如果您需要學習最基礎的C#語法，建議先買我的 C# 零基礎入門課程。', 40000, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-11-01T00:00:00.000' AS DateTime), 15, 1, 16, CAST(N'2023-10-01T13:33:39.000' AS DateTime), CAST(N'2023-08-25T17:13:39.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (12, 7, 1, N'[2023.09]C#基礎線上課程', N'68C.jpg', N'你是否想學習編程，但害怕太難嗎？或者你已經知道其他編程語言，但要快速學習C#語言？
這課程將用簡明，易懂方式來學習C#，複雜的概念被分解成簡單的步驟，以確保您即使未編碼過，仍可以掌握。
課程使用精選題及實例讓你廣泛接觸C#，但學習C#的最好方法是親手執行代碼，提供的課程講義中有大量習題可以自行做課後練習，遇到問題歡迎聯繫我，給予回覆算是課後服務之一。
', 40000, CAST(N'2023-09-01T00:00:00.000' AS DateTime), CAST(N'2023-11-01T00:00:00.000' AS DateTime), 15, 1, 17, CAST(N'2023-10-01T13:33:39.000' AS DateTime), CAST(N'2023-08-25T17:38:43.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (13, 5, 3, N'植物手工皂', N'07C.jpg', N'延續讓植物貼近大家生活的想法，與香水公司合作推出植物香氛皂，從內而外的全方位照顧，讓你每天都有好心情，精選3種植物香，分別為玫瑰保濕、金盞花舒緩、薰衣草放鬆，將分別帶給大家不一樣的感受。', 10000, CAST(N'2023-09-11T00:00:00.000' AS DateTime), CAST(N'2023-11-11T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-08-21T15:23:24.000' AS DateTime), CAST(N'2023-08-27T13:43:05.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (14, 1, 4, N'21 st PRIDE T', N'43C.jpg', N'在這個世界上，每一個生命都有其獨特的價值，每個人都有權利獲得尊重、平等，無論是誰，都應該享有自由展現自我的權利。我們將這個信念融入一件T恤，更是一個象徵，一種宣言，關於生命平權和性別平權的宣言。', 10000, CAST(N'2023-09-11T00:00:00.000' AS DateTime), CAST(N'2023-11-11T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-10-01T14:50:39.000' AS DateTime), CAST(N'2023-08-28T15:33:00.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (15, 1, 4, N'寵物世界APP集資', N'14C.jpg', N'我們希望每隻流浪的毛孩們在生命到了盡頭時，不再像垃圾一樣被丟棄，而能好好走完最後一哩路。
我們提供以下三項服務：浪浪送行、毛孩領養、毛孩協尋
未來希望透過APP能更立即、快速的幫助到浪浪、毛孩
APP主要有四大功能：通報、領養、討論、物資招募
通報是本次APP架設的重點，其中包含兩項：〈火化通報〉及〈走失通報〉
集資的費用主要花在APP的設計、架設及維護，若有其他餘額我們將會在火化及領養浪浪的相關基礎醫療上給予補助。', 10000, CAST(N'2023-09-15T00:00:00.000' AS DateTime), CAST(N'2023-11-15T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-10-01T15:10:39.000' AS DateTime), CAST(N'2023-09-03T10:42:43.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (16, 5, 1, N'鍵盤', N'04C.jpg', N'與大廠LL合作推出2種自訂義鍵盤，歡迎選購。', 7777, CAST(N'2023-09-22T00:00:00.000' AS DateTime), CAST(N'2023-11-22T00:00:00.000' AS DateTime), 15, 1, 14, CAST(N'2023-10-01T13:50:39.000' AS DateTime), CAST(N'2023-09-09T17:23:39.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (17, 4, 1, N'[2023.10]C# Asp.Net線上課程', N'72C.jpg', N'這是一門針對已經學過 C# 但完全不曾開發網站應用程式的人準備的 ASP.NET MVC 入門課程，會先教一些簡單的 HTML、CSS、JavaScript、Database 基本知識，大約可以開發簡單的網站功能。
課程不會從 C# 基礎語法開始教，課程的出發點是針對想學習發 ASP.NET MVC 網站應用程式的人；如果您需要學習最基礎的C#語法，建議先買我的 C# 零基礎入門課程。', 55000, CAST(N'2023-10-01T00:00:00.000' AS DateTime), CAST(N'2023-11-01T00:00:00.000' AS DateTime), 15, 0, 23, CAST(N'2023-09-07T13:13:39.000' AS DateTime), CAST(N'2023-09-11T17:13:39.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (18, 7, 1, N'[2023.10]C#基礎線上課程', N'70C.jpg', N'你是否想學習編程，但害怕太難嗎？或者你已經知道其他編程語言，但要快速學習C#語言？
這課程將用簡明，易懂方式來學習C#，複雜的概念被分解成簡單的步驟，以確保您即使未編碼過，仍可以掌握。
課程使用精選題及實例讓你廣泛接觸C#，但學習C#的最好方法是親手執行代碼，提供的課程講義中有大量習題可以自行做課後練習，遇到問題歡迎聯繫我，給予回覆算是課後服務之一。
', 50000, CAST(N'2023-10-01T00:00:00.000' AS DateTime), CAST(N'2023-11-01T00:00:00.000' AS DateTime), 15, 0, 21, CAST(N'2023-09-08T17:19:19.000' AS DateTime), CAST(N'2023-09-11T17:38:43.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (19, 2, 6, N'2024「平行世界拍攝計劃暨攝影展」', N'57C.jpg', N'繼續探索再次開啟「平行世界拍攝計劃暨攝影展」，希望借由影像拍攝，創作一系列「想像的平凡人生樣貌」，並借由視覺與意義上的矛盾衝突，呈現受難者無法擁有的生命樣貌，讓觀者感受更多的衝擊與啟發。
白色恐怖政治受難者是台灣威權時期的重要見證者，但隨著時間流逝，受難前輩們逐漸凋零逝去，原本擁有遠大夢想的年輕人們，就這樣遭受人生中的巨變，生命就此轉了彎，倘若沒有「白色恐怖」，他們的生命將會如何呢？又將以怎樣的姿態去追求人生？
展覽日期｜2024.06.01- 2024.08.30
開展時間｜09：00 - 17：00
展覽地點｜國家人權博物館景美紀念園區 禮堂（地址：新北市新店區復興路131號）', 5000, CAST(N'2023-10-01T00:00:00.000' AS DateTime), CAST(N'2024-02-01T00:00:00.000' AS DateTime), 15, 1, 14, CAST(N'2023-09-10T14:14:24.000' AS DateTime), CAST(N'2023-09-17T16:23:35.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (20, 3, 3, N'2024 植物日記', N'03C.jpeg', N'
每天一種手繪植物插畫，認識一種植物，
每天一句心靈小語，得到一些生活的思考與啟發，
用不張揚的簡約設計融入你的生活，我們把每一天過好，就能過好這一生。365天都陪在你身邊!', 10000, CAST(N'2023-10-03T00:00:00.000' AS DateTime), CAST(N'2023-11-01T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-09-06T17:19:49.000' AS DateTime), CAST(N'2023-09-18T17:13:59.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (21, 4, 7, N'《口袋香菇》多種香菇任你養殖', N'78C.jpg', N'可愛療癒的香菇手遊，除了讓你收集多種香菇之外，還可以瞭解香菇相關知識。現已上線一個小版本，我們想要豐富遊戲內容，讓大家更認識香菇。期待你加入養殖香菇行列！
回饋為虛擬商品，一個遊戲帳號限使用一組序號
，遊戲序號預計最晚2023/12/25發送。', 8888, CAST(N'2023-10-03T00:00:00.000' AS DateTime), CAST(N'2023-11-23T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-10-03T09:10:10.000' AS DateTime), CAST(N'2023-09-13T15:52:14.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (22, 8, 8, N'【2024臺北喵嗚季】全國最大室內貓咪主題市集+綠藝概念展', N'94C.jpg', N'隨著大環境的變化起伏了這麼長的時間，人們和貓咪都需要撫慰心靈讓身心舒暢，所以…#
【2023臺北喵嗚季】來了!!!
這是一場結合文創、動保、公益、產業發展、地方創生等多元面向，以市集、講座、策展等方式呈現的大型貓咪主題活動，以歡樂互動的趣味亮點增加觀展的參與度，讓觀展者能以輕鬆悠閒的心情，進入貓咪的主題世界。預計12/15~20在南港展覽館與大家見面。', 10000, CAST(N'2023-10-05T00:00:00.000' AS DateTime), CAST(N'2023-11-05T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-10-05T09:10:10.000' AS DateTime), CAST(N'2023-09-19T15:52:14.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (23, 5, 9, N'短夾', N'06C.jpg', N'擇你所愛，愛你所擇。我們運用不同進口材質打造各式短夾，做出十年不壞消費者才愛的錢包。
為了保障彼此，計畫還在建構中，募資結束才會開始客製大家的短夾，手工製作需久候請見諒。', 20000, CAST(N'2023-10-04T00:00:00.000' AS DateTime), CAST(N'2023-11-05T00:00:00.000' AS DateTime), 90, 1, 14, CAST(N'2023-09-02T21:14:56.000' AS DateTime), CAST(N'2023-09-17T14:42:54.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (24, 1, 5, N'舞蹈演出x公益計畫', N'13C.jpeg', N'給孩子一個舞台，成就夢想！
你用甚麼樣的方式來表達自己的故事、情感，以及對生命的感動？有一群孩子將自己的夢想透過舞蹈來傳遞，希望能得到更多的了解與關注，計畫透過導入才藝師資、補助才藝學習經費，讓偏鄉地區的孩子們有學習多元才藝的機會。
與知名舞蹈團體合作公演，您的投資除了必須演出必須支出，都將投入公益計畫中。
伊甸不放棄每個孩子勇往追求夢想的機會，邀您支持。', 6666, CAST(N'2023-10-01T00:00:00.000' AS DateTime), CAST(N'2024-01-21T00:00:00.000' AS DateTime), 30, 1, 14, CAST(N'2023-09-05T14:14:24.000' AS DateTime), CAST(N'2023-09-16T16:23:35.000' AS DateTime))
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (25, 5, 1, N'螢幕', N'05C.jpg', N'與大廠LL合作推出2種自訂義螢幕，歡迎選購。', 10000, CAST(N'2023-11-05T00:00:00.000' AS DateTime), CAST(N'2024-03-27T12:00:00.000' AS DateTime), 15, 0, NULL, CAST(N'2023-10-05T14:14:24.000' AS DateTime), NULL)
INSERT [dbo].[Projects] ([Id], [CategoryId], [CompanyId], [Name], [Image], [Description], [Goal], [StartTime], [EndTime], [ShippingDays], [Enabled], [StatusId], [UpdateTime], [ApplyTime]) VALUES (60, 2, 1, N'2', N'ot52kgbz.aie.jpg', N'2', 1, CAST(N'2023-10-06T00:00:00.000' AS DateTime), CAST(N'2023-10-31T00:00:00.000' AS DateTime), 1, 0, 21, CAST(N'2023-10-05T19:04:20.317' AS DateTime), CAST(N'2023-10-05T19:11:05.327' AS DateTime))
SET IDENTITY_INSERT [dbo].[Projects] OFF
GO
SET IDENTITY_INSERT [dbo].[Recipients] ON 

INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (4, N'Allen Kuo', N'0960072498', N'338       ', N'桃園市蘆竹區南工路28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (5, N'李怡君', N'0956662041', N'265       ', N'宜蘭縣羅東鎮四育路29號', 2)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (6, N'林美禾', N'0919538343', N'412       ', N'臺中市大里區垂統街15號', 3)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (7, N'蔡雅惠', N'0926542967', N'500       ', N'嘉義市西區健康七街4號', 5)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (8, N'高俊賢', N'0988248393', N'973       ', N'花蓮縣吉安鄉南華八街22號', 6)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (9, N'黃雅雯', N'0916441528', N'717       ', N'臺南市仁德區裕忠三街18號', 7)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (10, N'吳星泰', N'0961439636', N'630       ', N'雲林縣斗南鎮文昌路6號', 8)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (11, N'張苡星', N'0922274466', N'825       ', N'高雄市橋頭區塩南路18號', 9)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (12, N'芮欣怡', N'0930573483', N'411       ', N'臺中市太平區光興路6號', 10)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (13, N'蘇月迪', N'0912687940', N'827       ', N'高雄市彌陀區漁港一街13號', 11)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (14, N'吳怡芳', N'0938368713', N'806       ', N'高雄市前鎮區鄭和路15號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (15, N'林國海', N'0935405720', N'608       ', N'嘉義縣水上鄉民治街23號', 2)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (16, N'徐嘉君', N'0972934604', N'714       ', N'臺南市玉井區豐里34號', 3)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (17, N'童志豪', N'0934421606', N'300       ', N'新竹市北區仁化街13號', 5)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (18, N'吳美倩', N'0911874253', N'269       ', N'宜蘭縣冬山鄉境安二路34號', 6)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (19, N'虞如娥', N'0939733283', N'553       ', N'南投縣水里鄉七賢一街2號', 7)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (20, N'鄭一樂', N'0923516679', N'920       ', N'屏東縣潮州鎮西市路14號', 8)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (21, N'袁文宏', N'0923862854', N'227       ', N'新北市雙溪區双澳11號', 9)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (22, N'黃宜欣', N'0963410220', N'523       ', N'彰化縣埤頭鄉斗苑東路23號', 10)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (23, N'楊淑娟', N'0911787131', N'722       ', N'臺南市佳里區四安街22號', 11)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (24, N'邱俊蘋', N'0913408916', N'320       ', N'桃園市中壢區光華街28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (25, N'許雅盈', N'0955062420', N'100       ', N'臺北市中正區臨沂街21號', 2)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (26, N'林依倩', N'0933791044', N'632       ', N'雲林縣虎尾鎮虎興北路8號', 3)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (27, N'趙品璇', N'0970745184', N'890       ', N'金門縣金沙鎮第一富康農莊24號', 5)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (28, N'傅芳儀', N'0972870256', N'885       ', N'澎湖縣湖西鄉港子尾3號', 6)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (29, N'林鈺倩', N'0953546660', N'220       ', N'新北市板橋區僑中一街26號', 7)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (30, N'蔡誠綸', N'0927182017', N'961       ', N'臺東縣成功鎮麒麟路10號', 8)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (31, N'方婉婷', N'0938279692', N'350       ', N'苗栗縣竹南鎮新生路2號', 9)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (32, N'林怡霖', N'0934776510', N'238       ', N'新北市樹林區保順街19號', 10)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (33, N'陳書瑋', N'0939294246', N'111       ', N'臺北市士林區力行街12號', 11)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (34, N'黃淑孝', N'0987356792', N'220       ', N'新北市板橋區僑中一街26號', 7)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (35, N'劉長珍', N'0917514765', N'338       ', N'桃園市蘆竹區南工路28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (36, N'王麗妏', N'0970794116', N'269       ', N'宜蘭縣冬山鄉境安二路34號', 6)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (37, N'楊素琳', N'0917896821', N'265       ', N'宜蘭縣羅東鎮四育路29號', 2)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (38, N'楊舒法', N'0924796521', N'227       ', N'新北市雙溪區双澳11號', 9)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (39, N'黃枝嘉', N'0955070369', N'338       ', N'桃園市蘆竹區南工路28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (40, N'吳博仁', N'0986964934', N'973       ', N'花蓮縣吉安鄉南華八街22號', 6)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (41, N'陳慶群', N'0988858277', N'717       ', N'臺南市仁德區裕忠三街18號', 7)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (42, N'謝文光', N'0935954316', N'630       ', N'雲林縣斗南鎮文昌路6號', 8)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (43, N'陳家慧', N'0924857970', N'338       ', N'桃園市蘆竹區南工路28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (44, N'潘欣怡', N'0918316825', N'412       ', N'臺中市大里區垂統街15號', 3)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (45, N'賴雯宜', N'0933635090', N'500       ', N'嘉義市西區健康七街4號', 5)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (46, N'翁易尹', N'0924031942', N'320       ', N'桃園市中壢區光華街28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (47, N'鄧祥凡', N'0989920060', N'100       ', N'臺北市中正區臨沂街21號', 2)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (48, N'林依苓', N'0919270901', N'300       ', N'新竹市北區仁化街13號', 5)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (49, N'梁凱婷', N'0963257041', N'265       ', N'宜蘭縣羅東鎮四育路29號', 2)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (50, N'溫韋廷', N'0960779055', N'227       ', N'新北市雙溪區双澳11號', 9)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (51, N'賴志鴻', N'0970094244', N'523       ', N'彰化縣埤頭鄉斗苑東路23號', 10)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (52, N'陳睿霞', N'0939007818', N'722       ', N'臺南市佳里區四安街22號', 11)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (53, N'陳貞儀', N'0960185366', N'961       ', N'臺東縣成功鎮麒麟路10號', 8)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (54, N'陳昇名', N'0918740350', N'338       ', N'桃園市蘆竹區南工路28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (55, N'賴怡潔', N'0915887512', N'806       ', N'高雄市前鎮區鄭和路15號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (56, N'吳文傑', N'0925632950', N'608       ', N'嘉義縣水上鄉民治街23號', 2)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (57, N'林柏任', N'0989853901', N'714       ', N'臺南市玉井區豐里34號', 3)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (58, N'鄭姿君', N'0927676775', N'300       ', N'新竹市北區仁化街13號', 5)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (59, N'魏朝定', N'0926868239', N'320       ', N'桃園市中壢區光華街28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (60, N'王嘉盈', N'0924544191', N'100       ', N'臺北市中正區臨沂街21號', 2)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (61, N'翁俊宏', N'0931067648', N'338       ', N'桃園市蘆竹區南工路28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (62, N'牛愛霖', N'0988370391', N'320       ', N'桃園市中壢區光華街28號', 1)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (63, N'陳韻娥', N'0923864362', N'100       ', N'臺北市中正區臨沂街21號', 2)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (64, N'林志萍', N'0919129845', N'350       ', N'苗栗縣竹南鎮新生路2號', 9)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (65, N'梁靜樺', N'0928940110', N'238       ', N'新北市樹林區保順街19號', 10)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (66, N'許彥宇', N'0931044515', N'111       ', N'臺北市士林區力行街12號', 11)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (67, N'洪志瑋', N'0970741669', N'885       ', N'澎湖縣湖西鄉港子尾3號', 6)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (68, N'陳昭劭', N'0932121013', N'220       ', N'新北市板橋區僑中一街26號', 7)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (69, N'人', N'人', N'人         ', N'人', 18)
INSERT [dbo].[Recipients] ([Id], [Name], [PhoneNumber], [PostalCode], [Address], [MemberId]) VALUES (70, N'3', N'3', N'3         ', N'3', 18)
SET IDENTITY_INSERT [dbo].[Recipients] OFF
GO
SET IDENTITY_INSERT [dbo].[RoleFunctionRel] ON 

INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (1, 9, 2)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (3, 7, 14)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (4, 7, 15)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (5, 7, 16)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (6, 7, 17)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (7, 7, 18)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (8, 5, 19)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (9, 5, 20)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (10, 4, 4)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (11, 4, 5)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (20, 4, 3)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (22, 3, 2)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (23, 3, 3)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (24, 3, 4)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (25, 3, 5)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (33, 3, 13)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (34, 3, 14)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (35, 3, 15)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (36, 3, 16)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (37, 3, 17)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (38, 3, 18)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (39, 3, 19)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (41, 7, 13)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (42, 3, 20)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (43, 4, 6)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (44, 3, 6)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (47, 13, 19)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (48, 13, 20)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (49, 13, 3)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (50, 13, 4)
INSERT [dbo].[RoleFunctionRel] ([Id], [RoleId], [FunctionId]) VALUES (51, 13, 5)
SET IDENTITY_INSERT [dbo].[RoleFunctionRel] OFF
GO
SET IDENTITY_INSERT [dbo].[RolePageRel] ON 

INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (16, 7, 9)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (18, 9, 3)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (20, 3, 3)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (23, 3, 9)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (24, 3, 10)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (27, 5, 10)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (30, 14, 3)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (32, 3, 4)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (33, 3, 5)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (34, 4, 4)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (35, 4, 5)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (36, 13, 4)
INSERT [dbo].[RolePageRel] ([Id], [RoleId], [PageId]) VALUES (37, 13, 9)
SET IDENTITY_INSERT [dbo].[RolePageRel] OFF
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([Id], [Name], [Type], [ReadOnly]) VALUES (3, N'系統管理員
', N'WebOrg', 1)
INSERT [dbo].[Roles] ([Id], [Name], [Type], [ReadOnly]) VALUES (4, N'網站內容編輯員
', N'WebOrg', 1)
INSERT [dbo].[Roles] ([Id], [Name], [Type], [ReadOnly]) VALUES (5, N'用戶管理員
', N'WebOrg', 1)
INSERT [dbo].[Roles] ([Id], [Name], [Type], [ReadOnly]) VALUES (7, N'權限控制管理員
', N'WebOrg', 1)
INSERT [dbo].[Roles] ([Id], [Name], [Type], [ReadOnly]) VALUES (9, N'專案管理員
', N'WebOrg', 1)
INSERT [dbo].[Roles] ([Id], [Name], [Type], [ReadOnly]) VALUES (13, N'測試三', N'WebOrg', 0)
INSERT [dbo].[Roles] ([Id], [Name], [Type], [ReadOnly]) VALUES (14, N'測試67', N'WebOrg', 0)
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Companies]    Script Date: 10/5/2023 7:11:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Companies] ON [dbo].[Companies]
(
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Companies_1]    Script Date: 10/5/2023 7:11:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Companies_1] ON [dbo].[Companies]
(
	[UnifiedBusinessNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Functions]    Script Date: 10/5/2023 7:11:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Functions] ON [dbo].[Functions]
(
	[KeyValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Managers]    Script Date: 10/5/2023 7:11:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Managers] ON [dbo].[Managers]
(
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Managers_1]    Script Date: 10/5/2023 7:11:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Managers_1] ON [dbo].[Managers]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Members]    Script Date: 10/5/2023 7:11:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Members] ON [dbo].[Members]
(
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Members_1]    Script Date: 10/5/2023 7:11:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Members_1] ON [dbo].[Members]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Orders]    Script Date: 10/5/2023 7:11:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Orders] ON [dbo].[Orders]
(
	[No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Pages]    Script Date: 10/5/2023 7:11:27 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Pages] ON [dbo].[Pages]
(
	[KeyValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AboutUs] ADD  CONSTRAINT [DF_AboutUs_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[AboutUs] ADD  CONSTRAINT [DF_AboutUs_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_CreateTime]  DEFAULT (getdate()) FOR [CreateTime]
GO
ALTER TABLE [dbo].[Companies] ADD  CONSTRAINT [DF_Companies_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[Companies] ADD  CONSTRAINT [DF_Companies_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Companies] ADD  CONSTRAINT [DF_Companies_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[Companies] ADD  CONSTRAINT [DF_Companies_IsComfirmed]  DEFAULT ((0)) FOR [IsConfirmed]
GO
ALTER TABLE [dbo].[FAQs] ADD  CONSTRAINT [DF_FAQs_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[FAQs] ADD  CONSTRAINT [DF_FAQs_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Managers] ADD  CONSTRAINT [DF_Managers_Enabled]  DEFAULT ((1)) FOR [Enabled]
GO
ALTER TABLE [dbo].[Managers] ADD  CONSTRAINT [DF_Managers_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Managers] ADD  CONSTRAINT [DF_Managers_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[Managers] ADD  CONSTRAINT [DF_Managers_IsConfirmed]  DEFAULT ((0)) FOR [IsConfirmed]
GO
ALTER TABLE [dbo].[Members] ADD  CONSTRAINT [DF_Members_CreatTime]  DEFAULT (getdate()) FOR [CreatTime]
GO
ALTER TABLE [dbo].[Members] ADD  CONSTRAINT [DF_Members_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[Members] ADD  CONSTRAINT [DF_Members_IsComfirmed]  DEFAULT ((0)) FOR [IsConfirmed]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_CreatTime]  DEFAULT (getdate()) FOR [CreatTime]
GO
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[PrivacyPolicies] ADD  CONSTRAINT [DF_PrivacyPolicies_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PrivacyPolicies] ADD  CONSTRAINT [DF_PrivacyPolicies_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[Projects] ADD  CONSTRAINT [DF_Projects_Status]  DEFAULT ((0)) FOR [Enabled]
GO
ALTER TABLE [dbo].[Projects] ADD  CONSTRAINT [DF_Projects_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[Records] ADD  CONSTRAINT [DF_Records_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Orders]
GO
ALTER TABLE [dbo].[Configurations]  WITH CHECK ADD  CONSTRAINT [FK_Configurations_Categories1] FOREIGN KEY([TypeId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Configurations] CHECK CONSTRAINT [FK_Configurations_Categories1]
GO
ALTER TABLE [dbo].[FAQs]  WITH CHECK ADD  CONSTRAINT [FK_FAQs_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[FAQs] CHECK CONSTRAINT [FK_FAQs_Categories]
GO
ALTER TABLE [dbo].[Follows]  WITH CHECK ADD  CONSTRAINT [FK_Follows_Members] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[Follows] CHECK CONSTRAINT [FK_Follows_Members]
GO
ALTER TABLE [dbo].[Follows]  WITH CHECK ADD  CONSTRAINT [FK_Follows_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[Follows] CHECK CONSTRAINT [FK_Follows_Projects]
GO
ALTER TABLE [dbo].[Functions]  WITH CHECK ADD  CONSTRAINT [FK_Components_Pages] FOREIGN KEY([ParentPageId])
REFERENCES [dbo].[Pages] ([Id])
GO
ALTER TABLE [dbo].[Functions] CHECK CONSTRAINT [FK_Components_Pages]
GO
ALTER TABLE [dbo].[ManagerRoleRel]  WITH CHECK ADD  CONSTRAINT [FK_ManagerRoleRel_Managers] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[Managers] ([Id])
GO
ALTER TABLE [dbo].[ManagerRoleRel] CHECK CONSTRAINT [FK_ManagerRoleRel_Managers]
GO
ALTER TABLE [dbo].[ManagerRoleRel]  WITH CHECK ADD  CONSTRAINT [FK_ManagerRoleRel_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[ManagerRoleRel] CHECK CONSTRAINT [FK_ManagerRoleRel_Roles]
GO
ALTER TABLE [dbo].[ManagersAuths]  WITH CHECK ADD  CONSTRAINT [FK_ManagersAuths_Managers] FOREIGN KEY([Account])
REFERENCES [dbo].[Managers] ([Account])
GO
ALTER TABLE [dbo].[ManagersAuths] CHECK CONSTRAINT [FK_ManagersAuths_Managers]
GO
ALTER TABLE [dbo].[News]  WITH CHECK ADD  CONSTRAINT [FK_News_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[News] CHECK CONSTRAINT [FK_News_Projects]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Products]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Categories] FOREIGN KEY([PaymentIStatusId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Categories]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Categories1] FOREIGN KEY([PaymentId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Categories1]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Members] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Members]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Recipients] FOREIGN KEY([RecipientId])
REFERENCES [dbo].[Recipients] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Recipients]
GO
ALTER TABLE [dbo].[PrivacyPolicies]  WITH CHECK ADD  CONSTRAINT [FK_Agreements_Categories] FOREIGN KEY([TypeId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[PrivacyPolicies] CHECK CONSTRAINT [FK_Agreements_Categories]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Projects]
GO
ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Projects] CHECK CONSTRAINT [FK_Projects_Categories]
GO
ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_Categories1] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Projects] CHECK CONSTRAINT [FK_Projects_Categories1]
GO
ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_Companies] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Companies] ([Id])
GO
ALTER TABLE [dbo].[Projects] CHECK CONSTRAINT [FK_Projects_Companies]
GO
ALTER TABLE [dbo].[Recipients]  WITH CHECK ADD  CONSTRAINT [FK_Recipients_Members] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[Recipients] CHECK CONSTRAINT [FK_Recipients_Members]
GO
ALTER TABLE [dbo].[RoleFunctionRel]  WITH CHECK ADD  CONSTRAINT [FK_CompPermissionsRel_Components] FOREIGN KEY([FunctionId])
REFERENCES [dbo].[Functions] ([Id])
GO
ALTER TABLE [dbo].[RoleFunctionRel] CHECK CONSTRAINT [FK_CompPermissionsRel_Components]
GO
ALTER TABLE [dbo].[RoleFunctionRel]  WITH CHECK ADD  CONSTRAINT [FK_RoleComponentRel_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[RoleFunctionRel] CHECK CONSTRAINT [FK_RoleComponentRel_Roles]
GO
ALTER TABLE [dbo].[RolePageRel]  WITH CHECK ADD  CONSTRAINT [FK_PermissionsResourceRel_Resources] FOREIGN KEY([PageId])
REFERENCES [dbo].[Pages] ([Id])
GO
ALTER TABLE [dbo].[RolePageRel] CHECK CONSTRAINT [FK_PermissionsResourceRel_Resources]
GO
ALTER TABLE [dbo].[RolePageRel]  WITH CHECK ADD  CONSTRAINT [FK_RolePageRel_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[RolePageRel] CHECK CONSTRAINT [FK_RolePageRel_Roles]
GO
ALTER TABLE [dbo].[TeamProjectRels]  WITH CHECK ADD  CONSTRAINT [FK_TeamProjectRels_Members] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[TeamProjectRels] CHECK CONSTRAINT [FK_TeamProjectRels_Members]
GO
ALTER TABLE [dbo].[TeamProjectRels]  WITH CHECK ADD  CONSTRAINT [FK_TeamProjectRels_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
GO
ALTER TABLE [dbo].[TeamProjectRels] CHECK CONSTRAINT [FK_TeamProjectRels_Projects]
GO
ALTER TABLE [dbo].[TeamProjectRels]  WITH CHECK ADD  CONSTRAINT [FK_TeamProjectRels_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[TeamProjectRels] CHECK CONSTRAINT [FK_TeamProjectRels_Roles]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRolesData]    Script Date: 10/5/2023 7:11:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 建立新的 Stored Procedure
CREATE PROCEDURE [dbo].[DeleteRolesData] (
    @IdsToDelete NVARCHAR(MAX)
) 
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM RolePageRel WHERE RolePageRel.RoleId IN (SELECT Id FROM SplitIds(@IdsToDelete));
	DELETE FROM RoleFunctionRel WHERE RoleFunctionRel.RoleId IN (SELECT Id FROM SplitIds(@IdsToDelete));
	DELETE FROM ManagersAuths WHERE ManagersAuths.Account IN (SELECT Managers.Account FROM Managers INNER JOIN ManagerRoleRel ON ManagerRoleRel.ManagerId =  Managers.Id AND ManagerRoleRel.RoleId IN (SELECT Id FROM SplitIds(@IdsToDelete)));
	DELETE FROM ManagerRoleRel WHERE ManagerRoleRel.RoleId IN (SELECT Id FROM SplitIds(@IdsToDelete));
	DELETE FROM Roles WHERE Roles.Id IN (SELECT Id FROM SplitIds(@IdsToDelete));
	SET NOCOUNT OFF;   
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateRoleFuncsRel]    Script Date: 10/5/2023 7:11:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 建立新的 Stored Procedure
CREATE PROCEDURE [dbo].[UpdateRoleFuncsRel] (
    @RoleId INT,
    @IdsToDelete NVARCHAR(MAX)
) 
AS
BEGIN
	SET NOCOUNT ON;
	
	
	IF @IdsToDelete IS NOT NULL AND LEN(@IdsToDelete) > 0
	BEGIN
		DELETE FROM ManagersAuths WHERE  ManagersAuths.Account IN (SELECT Managers.Account FROM Managers INNER JOIN ManagerRoleRel ON ManagerRoleRel.ManagerId = Managers.Id  WHERE ManagerRoleRel.RoleId = @RoleId);
		DELETE FROM RoleFunctionRel WHERE  RoleFunctionRel.FunctionId IN (SELECT Id FROM SplitIds(@IdsToDelete));
	END

	SET NOCOUNT OFF;   
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateRolePageRel]    Script Date: 10/5/2023 7:11:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 建立新的 Stored Procedure
CREATE PROCEDURE [dbo].[UpdateRolePageRel](
    @RoleId INT,
    @IdsToDelete NVARCHAR(MAX)
) 
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @IdsToDelete IS NOT NULL AND LEN(@IdsToDelete) > 0
	BEGIN
		DELETE FROM ManagersAuths WHERE  ManagersAuths.Account IN (SELECT Managers.Account FROM Managers INNER JOIN ManagerRoleRel ON ManagerRoleRel.ManagerId = Managers.Id  WHERE ManagerRoleRel.RoleId = @RoleId);
		DELETE FROM RolePageRel WHERE  RolePageRel.PageId IN (SELECT Id FROM SplitIds(@IdsToDelete));
	END

	SET NOCOUNT OFF;   
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateUserRoleRel]    Script Date: 10/5/2023 7:11:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 建立新的 Stored Procedure
CREATE PROCEDURE [dbo].[UpdateUserRoleRel] (
    @UserId INT,
    @IdsToDelete NVARCHAR(MAX)
) 
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM ManagersAuths WHERE  ManagersAuths.Account IN (SELECT Managers.Account FROM Managers WHERE Managers.Id = @UserId);
	IF @IdsToDelete IS NOT NULL AND LEN(@IdsToDelete) > 0
	BEGIN
		DELETE FROM ManagerRoleRel WHERE ManagerRoleRel.ManagerId = @UserId AND ManagerRoleRel.RoleId IN (SELECT Id FROM SplitIds(@IdsToDelete));
	END


	SET NOCOUNT OFF;   
END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'標題' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AboutUs', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'內容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AboutUs', @level2type=N'COLUMN',@level2name=N'Contents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'圖片' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AboutUs', @level2type=N'COLUMN',@level2name=N'Image'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'建立時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AboutUs', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'最後更新時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AboutUs', @level2type=N'COLUMN',@level2name=N'UpdatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'關於我們' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AboutUs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Categories', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Categories', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'顯示順序' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Categories', @level2type=N'COLUMN',@level2name=N'DisplayOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'該類別所屬類型，Ex. 該類別屬於權限 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Categories', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'類別表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Categories'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'留言內容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Comments', @level2type=N'COLUMN',@level2name=N'Message'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'留言時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Comments', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'專案留言板資料' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Comments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'帳號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'Account'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'電子信箱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'公司名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'公司電話' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'Phone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'統一編號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'UnifiedBusinessNo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'代表人姓名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'ResponsiblePerson'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'密碼' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'公司審核狀態' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'建立公司帳號的時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'CreatedTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'公司申請時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies', @level2type=N'COLUMN',@level2name=N'ApplyTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'公司註冊資料' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Companies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Configurations', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'參數值' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Configurations', @level2type=N'COLUMN',@level2name=N'Value'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Configurations', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'類型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Configurations', @level2type=N'COLUMN',@level2name=N'TypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'網站參數表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Configurations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'問題' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAQs', @level2type=N'COLUMN',@level2name=N'Question'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'回答' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAQs', @level2type=N'COLUMN',@level2name=N'Answer'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'顯示順序' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAQs', @level2type=N'COLUMN',@level2name=N'DisplayOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'建立時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAQs', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAQs', @level2type=N'COLUMN',@level2name=N'UpdatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'分類Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAQs', @level2type=N'COLUMN',@level2name=N'CategoryId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'常見問題表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAQs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'會員追蹤紀錄' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Follows'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Functions', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'元件Key，可找出畫面中對應的元件' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Functions', @level2type=N'COLUMN',@level2name=N'KeyValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Functions', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'元件所屬的頁面' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Functions', @level2type=N'COLUMN',@level2name=N'ParentPageId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'元件表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Functions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'網站會員編碼' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'會員帳號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Account'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'會員密碼' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'會員名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'會員電子信箱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'會員生日' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Birthday'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'會員自我介紹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Introduce'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'會員資料' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'最新消息標題' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'最新消息內容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'建立時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'CreatTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News', @level2type=N'COLUMN',@level2name=N'UpdateTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'專案最新消息資料' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'News'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrderItems', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'關連到訂單Orders' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrderItems', @level2type=N'COLUMN',@level2name=N'OrderId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'關聯到商品組合Products' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrderItems', @level2type=N'COLUMN',@level2name=N'ProductId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'訂單明細(贊助紀錄明細)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrderItems'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'訂單編號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'No'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'關聯會員資料Members' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'MemberId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'訂單時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Orders', @level2type=N'COLUMN',@level2name=N'OrderTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'訂單(贊助紀錄)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Orders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'頁面名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Pages', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'預設是否呈現' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Pages', @level2type=N'COLUMN',@level2name=N'DefaultVisible'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'所屬的頁面' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Pages', @level2type=N'COLUMN',@level2name=N'ParentId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'頁面表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Pages'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'標題' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PrivacyPolicies', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'內容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PrivacyPolicies', @level2type=N'COLUMN',@level2name=N'Contents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'隱私權類型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PrivacyPolicies', @level2type=N'COLUMN',@level2name=N'TypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'生效日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PrivacyPolicies', @level2type=N'COLUMN',@level2name=N'EffectiveDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'建立日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PrivacyPolicies', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'最後更新日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PrivacyPolicies', @level2type=N'COLUMN',@level2name=N'UpdatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'隱私權表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PrivacyPolicies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品組合細項(如某商品組合內容物有1支筆2把尺)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'Detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'數量' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'Qty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'價格' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'Price'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品組合' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'關聯到Category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'CategoryId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'專案名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'圖片' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'Image'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'專案內容' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'目標金額' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'Goal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'開始募資時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'StartTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'結束募資時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'EndTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'預計出貨天數' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'ShippingDays'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'審查狀態(關聯到Category)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects', @level2type=N'COLUMN',@level2name=N'Enabled'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'專案' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Projects'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'收件人姓名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipients', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'收件人聯絡電話' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipients', @level2type=N'COLUMN',@level2name=N'PhoneNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'郵遞區號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipients', @level2type=N'COLUMN',@level2name=N'PostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'地址' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipients', @level2type=N'COLUMN',@level2name=N'Address'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'收件人資料' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipients'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'贊助次數統計(所有成功訂單量)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Records', @level2type=N'COLUMN',@level2name=N'TotelOrders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'發布專案統計(成功+發布中+失敗專案)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Records', @level2type=N'COLUMN',@level2name=N'TotelProjects'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'成功專案統計' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Records', @level2type=N'COLUMN',@level2name=N'TotelCompleteProjects'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'紀錄更新時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Records', @level2type=N'COLUMN',@level2name=N'UpdateTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'網站記錄' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Records'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'權限與元件關聯表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RoleFunctionRel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'權限Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RolePageRel', @level2type=N'COLUMN',@level2name=N'RoleId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'頁面Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RolePageRel', @level2type=N'COLUMN',@level2name=N'PageId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'頁面與權限關聯表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RolePageRel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'角色名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Roles', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'角色表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Roles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TeamProjectRels', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'關聯會員Members' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TeamProjectRels', @level2type=N'COLUMN',@level2name=N'MemberId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'關聯到角色Roles' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TeamProjectRels', @level2type=N'COLUMN',@level2name=N'RoleId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'團隊成員關聯' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TeamProjectRels'
GO
USE [master]
GO
ALTER DATABASE [FDB03] SET  READ_WRITE 
GO
