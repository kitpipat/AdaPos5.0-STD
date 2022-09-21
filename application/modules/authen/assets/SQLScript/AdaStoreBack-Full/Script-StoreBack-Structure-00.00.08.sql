IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMChannel_L' AND COLUMN_NAME = 'FTPdtRmk') BEGIN
	EXEC sp_rename 'TCNMChannel_L.FTPdtRmk', 'FTChnRmk', 'COLUMN'
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMChannelTmp_L' AND COLUMN_NAME = 'FTPdtRmk') BEGIN
	EXEC sp_rename 'TCNMChannelTmp_L.FTPdtRmk', 'FTChnRmk', 'COLUMN'
END


IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TPSTSalDTFhn' AND COLUMN_NAME = 'FNXsfSeqNo') BEGIN
	ALTER TABLE TPSTSalDTFhn ADD FNXsfSeqNo int NOT NULL DEFAULT(1)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TPSTSalDTFhn' AND COLUMN_NAME = 'FTClrName') BEGIN
	ALTER TABLE TPSTSalDTFhn ADD FTClrName varchar(100)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TPSTSalDTFhn' AND COLUMN_NAME = 'FTPszName') BEGIN
	ALTER TABLE TPSTSalDTFhn ADD FTPszName varchar(100)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TPSTSalDTFhn' AND COLUMN_NAME = 'FTFabName') BEGIN
	ALTER TABLE TPSTSalDTFhn ADD FTFabName varchar(100)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TPSTSalDTFhn' AND COLUMN_NAME = 'FTSeaName') BEGIN
	ALTER TABLE TPSTSalDTFhn ADD FTSeaName varchar(100)
END
GO
IF EXISTS(SELECT name FROM sys.key_constraints WHERE name = 'PK_TPSTSalDTFhn') BEGIN
	ALTER TABLE TPSTSalDTFhn DROP CONSTRAINT PK_TPSTSalDTFhn
END
GO


/****** Object:  Table [dbo].[TCNTPdtIntDTFhn]    Script Date: 12/7/2564 19:16:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPdtIntDTFhn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPdtIntDTFhn](
	[FTBchCode] [varchar](5) NOT NULL,
	[FTXthDocNo] [varchar](20) NOT NULL,
	[FNXtdSeqNo] [int] NOT NULL,
	[FTPdtCode] [varchar](20) NOT NULL,
	[FTFhnRefCode] [varchar](50) NOT NULL,
	[FCXtdQty] [numeric](18, 4) NULL,
	[FCXtdQtyRcv] [numeric](18, 4) NULL,
	[FCXtdQtyAll] [numeric](18, 4) NULL,
	[FTXthWahTo] [varchar](255) NULL,
 CONSTRAINT [PK_TCNTPdtIntDTFhn] PRIMARY KEY CLUSTERED 
(
	[FTBchCode] ASC,
	[FTXthDocNo] ASC,
	[FNXtdSeqNo] ASC,
	[FTPdtCode] ASC,
	[FTFhnRefCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNTPdtIntDTFhnBch]    Script Date: 12/7/2564 19:16:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPdtIntDTFhnBch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPdtIntDTFhnBch](
	[FTBchCode] [varchar](5) NOT NULL,
	[FTXthDocNo] [varchar](20) NOT NULL,
	[FNXtdSeqNo] [int] NOT NULL,
	[FTPdtCode] [varchar](20) NOT NULL,
	[FTFhnRefCode] [varchar](255) NOT NULL,
	[FCXtdQty] [numeric](18, 4) NULL,
	[FCXtdQtyRcv] [numeric](18, 4) NULL,
	[FCXtdQtyAll] [numeric](18, 4) NULL,
	[FTXthBchTo] [varchar](5) NULL,
	[FTXthWahTo] [varchar](5) NULL,
 CONSTRAINT [PK_TCNTPdtIntDTFhnBch] PRIMARY KEY CLUSTERED 
(
	[FTBchCode] ASC,
	[FTXthDocNo] ASC,
	[FNXtdSeqNo] ASC,
	[FTPdtCode] ASC,
	[FTFhnRefCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNTPdtTbiDTFhn]    Script Date: 12/7/2564 19:16:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPdtTbiDTFhn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPdtTbiDTFhn](
	[FTBchCode] [varchar](5) NOT NULL,
	[FTXthDocNo] [varchar](20) NOT NULL,
	[FNXtdSeqNo] [int] NOT NULL,
	[FTPdtCode] [varchar](20) NOT NULL,
	[FTFhnRefCode] [varchar](255) NOT NULL,
	[FCXtdQty] [numeric](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[FTBchCode] ASC,
	[FTXthDocNo] ASC,
	[FNXtdSeqNo] ASC,
	[FTPdtCode] ASC,
	[FTFhnRefCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNTPdtTboDTFhn]    Script Date: 12/7/2564 19:16:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPdtTboDTFhn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPdtTboDTFhn](
	[FTBchCode] [varchar](5) NOT NULL,
	[FTXthDocNo] [varchar](20) NOT NULL,
	[FNXtdSeqNo] [int] NOT NULL,
	[FTPdtCode] [varchar](20) NOT NULL,
	[FTFhnRefCode] [varchar](255) NOT NULL,
	[FCXtdQty] [numeric](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[FTBchCode] ASC,
	[FTXthDocNo] ASC,
	[FNXtdSeqNo] ASC,
	[FTPdtCode] ASC,
	[FTFhnRefCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO



/****** Object:  Table [dbo].[TRPTCstSalMTDTmp]    Script Date: 14/7/2564 12:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTCstSalMTDTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TRPTCstSalMTDTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FNAppType] [int] NULL,
	[FTCgpCode] [varchar](5) NULL,
	[FTCstCode] [varchar](50) NULL,
	[FTCstName] [varchar](255) NULL,
	[FTCstCrdNo] [varchar](100) NULL,
	[FCTxnBuyTotal] [numeric](18, 4) NULL,
	[FCXshGrand] [numeric](18, 4) NULL,
	[FDXshLastDate] [datetime] NULL,
	[FTBchCode] [varchar](5) NULL,
	[FTBchName] [varchar](100) NULL,
	[FTCstTel] [varchar](20) NULL,
	[FDCstDob] [datetime] NULL,
	[FTChnCount] [numeric](18, 0) NULL,
	[FTCstSex] [varchar](50) NULL,
	[FCCstCrLimit] [numeric](18, 4) NULL,
	[FTClvName] [varchar](100) NULL,
	[FCTxnPntBillQty] [numeric](18, 4) NULL,
	[FCTxnPntQtyBal] [numeric](18, 4) NULL,
	[FTCstEmail] [varchar](100) NULL,
	[FDCstApply] [datetime] NULL,
	[FTCtyName] [varchar](100) NULL,
	[FTPplName] [varchar](100) NULL,
	[FCXshSumGrand] [numeric](18, 4) NULL,
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FDTmpTxnDate] [datetime] NULL,
	[FTCstAddress] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TRPTSpcSalByDTTmp]    Script Date: 14/7/2564 12:54:08 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTSpcSalByDTTmp]') AND type in (N'U'))
BEGIN
DROP TABLE TRPTSpcSalByDTTmp;
END
GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTSpcSalByDTTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TRPTSpcSalByDTTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FNAppType] [int] NULL,
	[FTPbnName] [varchar](255) NULL,
	[FDXshDocDate] [datetime] NULL,
	[FTCstName] [varchar](255) NULL,
	[FTCstTel] [varchar](255) NULL,
	[FTBchCode] [varchar](5) NULL,
	[FTBchName] [varchar](100) NULL,
	[FTXshDocNo] [varchar](20) NULL,
	[FNXsdSeqNo] [int] NULL,
	[FTUsrName] [varchar](255) NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTXsdPdtName] [varchar](100) NULL,
	[FTPgpChainName] [varchar](255) NULL,
	[FTPunCode] [varchar](5) NULL,
	[FTPunName] [varchar](50) NULL,
	[FTFhnRefCode] [varchar](50) NULL,
	[FTClrName] [varchar](100) NULL,
	[FTPszName] [varchar](100) NULL,
	[FTFhnGender] [varchar](100) NULL,
	[FTSeaName] [varchar](100) NULL,
	[FNXshAge] [varchar](100) NULL,
	[FTXshNation] [varchar](100) NULL,
	[FTDepName] [varchar](100) NULL,
	[FTCmlName] [varchar](100) NULL,
	[FTClsName] [varchar](100) NULL,
	[FCXsdFactor] [numeric](18, 4) NULL,
	[FTXsdBarCode] [varchar](25) NULL,
	[FTSrnCode] [varchar](50) NULL,
	[FTXsdVatType] [varchar](1) NULL,
	[FTVatCode] [varchar](5) NULL,
	[FCXsdVatRate] [numeric](18, 4) NULL,
	[FTXsdSaleType] [varchar](1) NULL,
	[FCXsdSalePrice] [numeric](18, 4) NULL,
	[FCXsdGrossSales] [numeric](18, 4) NULL,
	[FCXsdGrossSalesExVat] [numeric](18, 4) NULL,
	[FCXsdNetSales] [numeric](18, 4) NULL,
	[FCXsdNetSalesEx] [numeric](18, 4) NULL,
	[FTXddDisChgTxt] [varchar](100) NULL,
	[FCXsdQty] [numeric](18, 4) NULL,
	[FCXsdQtyAll] [numeric](18, 4) NULL,
	[FCXsdSetPrice] [numeric](18, 4) NULL,
	[FCXsdAmtB4DisChg] [numeric](18, 4) NULL,
	[FTXsdDisChgTxt] [varchar](50) NULL,
	[FCXsdDis] [numeric](18, 4) NULL,
	[FCXsdChg] [numeric](18, 4) NULL,
	[FCXsdNet] [numeric](18, 4) NULL,
	[FCXsdNetAfHD] [numeric](18, 4) NULL,
	[FCXsdVat] [numeric](18, 4) NULL,
	[FCXsdVatable] [numeric](18, 4) NULL,
	[FCXsdWhtAmt] [numeric](18, 4) NULL,
	[FTXsdWhtCode] [varchar](5) NULL,
	[FCXsdWhtRate] [numeric](18, 4) NULL,
	[FCXsdCostIn] [numeric](18, 4) NULL,
	[FCXsdCostEx] [numeric](18, 4) NULL,
	[FTXsdStaPdt] [varchar](1) NULL,
	[FCXsdQtyLef] [numeric](18, 4) NULL,
	[FCXsdQtyRfn] [numeric](18, 4) NULL,
	[FTXsdStaPrcStk] [varchar](1) NULL,
	[FTXsdStaAlwDis] [varchar](1) NULL,
	[FNXsdPdtLevel] [int] NULL,
	[FTXsdPdtParent] [varchar](20) NULL,
	[FCXsdQtySet] [numeric](18, 4) NULL,
	[FTPdtStaSet] [varchar](1) NULL,
	[FTXsdRmk] [varchar](200) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FDTmpTxnDate] [datetime] NULL,
	[FTChnName] [varchar](50) NULL,
	[FTCstCode] [varchar](50) NULL,
	[FNXshSex] [varchar](10) NULL,
	[FTXshRmk] [varchar](255) NULL,
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TCNMAdjPdtTmp]    Script Date: 14/7/2564 12:57:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMAdjPdtTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMAdjPdtTmp](
	[FNRowID] [bigint] NULL,
	[FTAgnCode] [varchar](10) NULL,
	[FTBchCode] [varchar](5) NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTPdtName] [varchar](150) NULL,
	[FTPunCode] [varchar](5) NULL,
	[FTPunName] [varchar](100) NULL,
	[FTBarCode] [varchar](25) NULL,
	[FTPgpChain] [varchar](30) NULL,
	[FTPgpName] [varchar](100) NULL,
	[FTPbnCode] [varchar](10) NULL,
	[FTPbnName] [varchar](100) NULL,
	[FTPmoCode] [varchar](10) NULL,
	[FTPmoName] [varchar](100) NULL,
	[FTPtyCode] [varchar](10) NULL,
	[FTPtyName] [varchar](100) NULL,
	[FTStaAlwSet] [varchar](1) NULL,
	[FTSessionID] [varchar](255) NULL,
	[FTBchName] [varchar](100) NULL,
	[FTFhnRefCode] [varchar](50) NULL,
	[FTSeaCode] [varchar](5) NULL,
	[FTSeaName] [varchar](100) NULL,
	[FTFabCode] [varchar](5) NULL,
	[FTFabName] [varchar](100) NULL,
	[FTClrCode] [varchar](100) NULL,
	[FTClrName] [varchar](100) NULL,
	[FTPszCode] [varchar](5) NULL,
	[FTPszName] [varchar](100) NULL,
	[FTDepCode] [varchar](10) NULL,
	[FTDepName] [varchar](100) NULL,
	[FTClsCode] [varchar](10) NULL,
	[FTClsName] [varchar](100) NULL,
	[FTSclCode] [varchar](10) NULL,
	[FTSclName] [varchar](100) NULL,
	[FTPgpCode] [varchar](10) NULL,
	[FTCmlCode] [varchar](10) NULL,
	[FTCmlName] [varchar](100) NULL,
	[FTFhnModNo] [varchar](30) NULL,
	[FTFhnGender] [varchar](30) NULL,
	[FCFhnCostStd] [numeric](18, 4) NULL,
	[FCFhnCostOth] [numeric](18, 4) NULL,
	[FDFhnStart] [datetime] NULL,
	[FCXsdSalePrice] [numeric](18, 4) NULL,
	[FTFhnPgpName] [varchar](100) NULL,
	[FNFhnSeq] [int] NULL
) ON [PRIMARY]
END
GO



/****** Object:  Table [dbo].[TRPTPdtStkBalFhnTmp]    Script Date: 16/7/2564 15:50:17 ******/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTPdtStkBalFhnTmp]') AND type in (N'U'))
BEGIN
DROP TABLE TRPTPdtStkBalFhnTmp;
END
GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTPdtStkBalFhnTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TRPTPdtStkBalFhnTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTBchCode] [varchar](5) NULL,
	[FTWahCode] [varchar](5) NULL,
	[FTWahName] [varchar](255) NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTPdtName] [varchar](255) NULL,
	[FTPgpChainName] [varchar](255) NULL,
	[FCPdtCostAVGEX] [numeric](18, 4) NULL,
	[FCPdtCostTotal] [numeric](18, 4) NULL,
	[FCStkQty] [numeric](18, 4) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FDTmpTxnDate] [datetime] NULL,
	[FTBchName] [varchar](100) NULL,
	[FTFhnRefCode] [varchar](50) NULL,
	[FTDepName] [varchar](100) NULL,
	[FTClsName] [varchar](100) NULL,
	[FTSeaName] [varchar](100) NULL,
	[FTPmoName] [varchar](100) NULL,
	[FTFabName] [varchar](100) NULL,
	[FTClrName] [varchar](100) NULL,
	[FTPszName] [varchar](100) NULL,
	[FTClrRmk] [varchar](50) NULL,
	[FTBarCode] [varchar](50) NULL,
	[FCPgdPriceRet] [numeric](18, 4) NULL,
	[FCXshNetSale] [numeric](18, 4) NULL,
	[FCXshDiffCost] [numeric](18, 4) NULL,
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TRPTPdtStkCrdFhnTmp]    Script Date: 16/7/2564 15:50:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTPdtStkCrdFhnTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TRPTPdtStkCrdFhnTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FNRowPartIDWah] [bigint] NULL,
	[FNRowPartIDBch] [bigint] NULL,
	[FNStkCrdID] [bigint] NULL,
	[FTBchCode] [varchar](5) NULL,
	[FTBchName] [varchar](100) NULL,
	[FDStkDate] [datetime] NULL,
	[FTStkDocNo] [varchar](20) NULL,
	[FTWahCode] [varchar](5) NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTStkType] [varchar](1) NULL,
	[FCStkQtyMonEnd] [numeric](18, 4) NULL,
	[FCStkQtyIn] [numeric](18, 4) NULL,
	[FCStkQtyOut] [numeric](18, 4) NULL,
	[FCStkQtySaleDN] [numeric](18, 4) NULL,
	[FCStkQtyCN] [numeric](18, 4) NULL,
	[FCStkQtyAdj] [numeric](18, 4) NULL,
	[FCStkSetPrice] [numeric](18, 4) NULL,
	[FCStkCostIn] [numeric](18, 4) NULL,
	[FCStkCostEx] [numeric](18, 4) NULL,
	[FTWahName] [varchar](255) NULL,
	[FTPdtName] [varchar](255) NULL,
	[FCStkQtyBal] [numeric](18, 4) NULL,
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FDTmpTxnDate] [datetime] NULL,
	[FTBarCode] [varchar](25) NULL,
	[FTFhnRefCode] [varchar](50) NULL,
	[FTDepName] [varchar](100) NULL,
	[FTClsName] [varchar](100) NULL,
	[FTSeaName] [varchar](100) NULL,
	[FTPmoName] [varchar](100) NULL,
	[FTFabName] [varchar](100) NULL,
	[FTClrName] [varchar](100) NULL,
	[FTPszName] [varchar](100) NULL,
	[FTClrRmk] [varchar](50) NULL,
) ON [PRIMARY]
END
GO




/****** Object:  View [dbo].[VCN_VatActive]    Script Date: 3/9/2564 21:14:28 ******/
DROP VIEW IF EXISTS [dbo].[VCN_VatActive]
GO
/****** Object:  View [dbo].[VCN_VatActive]    Script Date: 3/9/2564 21:14:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VCN_VatActive] AS 
SELECT V.* FROM (
SELECT 
ROW_NUMBER() OVER(PARTITION BY FTVatCode ORDER BY  FTVatCode ASC ,FDVatStart DESC) AS FNRowPart,
FTVatCode,
FCVatRate,
FDVatStart
FROM TCNMVatRate WHERE CONVERT(VARCHAR(19),GETDATE(),121) > FDVatStart  ) V
WHERE V.FNRowPart = 1 
GO




ALTER TABLE TRPTPSTaxHDTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPSTaxHDDateTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPdtPointWahTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPdtPointPdtTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPSSaleDailyTmp09 ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPSTaxDailyTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTSalTimePrdTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPSTaxHDDateFullTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPSTaxHDFullTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPSTaxMonthlyTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPSTTaxDateFullTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPTTSpcPSSaleDailyTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPTTSpcPSSaleMonthlyTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPTTSpcPSSaleWeeklyTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPTTSpcPSSaleWeeklyTmpAda062 ALTER COLUMN FTBchName VARCHAR (100) NULL;
ALTER TABLE TRPTPTTSpcPSVDSaleDailyTmp ALTER COLUMN FTBchName VARCHAR (100) NULL;







/****** Object:  Table [dbo].[TCNTAppDepDT]    Script Date: 18/2/2565 17:24:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTAppDepDT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTAppDepDT](
	[FTXdhDocNo] [varchar](10) NOT NULL,
	[FNXddSeq] [int] NOT NULL,
	[FTAppName] [varchar](50) NULL,
	[FTAppVersion] [varchar](50) NULL,
	[FTXdhAppPath] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[FTXdhDocNo] ASC,
	[FNXddSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNTAppDepHD]    Script Date: 18/2/2565 17:24:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTAppDepHD]') AND type in (N'U'))
BEGIN 
CREATE TABLE [dbo].[TCNTAppDepHD](
	[FTXdhDocNo] [varchar](10) NOT NULL,
	[FDXdhDocDate] [datetime] NULL,
 	[FDXdhActDate] [datetime] NULL,
	[FTXdhStaDoc] [varchar](1) NULL,
	[FTXdhStaDep] [varchar](1) NULL,
	[FTXdhStaPreDep] [varchar](1) NULL,
	[FTXdhUsrApv] [varchar](20) NULL,
	[FTXdhUsrApvPreDep] [varchar](20) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
	[FTXdhZipUrl] [text] NULL,
	[FTXdhJsonUrl] [text] NULL,
	[FTXdhStaForce] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[FTXdhDocNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNTAppDepHD_L]    Script Date: 18/2/2565 17:24:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTAppDepHD_L]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTAppDepHD_L](
	[FTXdhDocNo] [varchar](10) NOT NULL,
	[FNLngID] [int] NOT NULL,
	[FTXdhDepName] [varchar](100) NULL,
	[FTXdhDepRmk] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[FTXdhDocNo] ASC,
	[FNLngID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNTAppDepHDBch]    Script Date: 18/2/2565 17:24:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTAppDepHDBch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTAppDepHDBch](
	[FTXdhDocNo] [varchar](10) NOT NULL,
	[ID] [bigint] NOT NULL,
	[FTXdhAgnTo] [varchar](5) NOT NULL,
	[FTXdhBchTo] [varchar](5) NOT NULL,
	[FTXdhMerTo] [varchar](10) NOT NULL,
	[FTXdhShpTo] [varchar](5) NOT NULL,
	[FTXdhPosTo] [varchar](5) NOT NULL,
	[FTXdhStaType] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[FTXdhDocNo] ASC,
	[FTXdhAgnTo] ASC,
	[FTXdhBchTo] ASC,
	[FTXdhMerTo] ASC,
	[FTXdhShpTo] ASC,
	[FTXdhPosTo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNTAppDepHis]    Script Date: 18/2/2565 17:24:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTAppDepHis]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTAppDepHis](
	[FTAgnCode] [varchar](5) NOT NULL,
	[FTBchCode] [varchar](5) NOT NULL,
	[FTMerCode] [varchar](10) NOT NULL,
	[FTShpCode] [varchar](5) NOT NULL,
	[FTPosCode] [varchar](5) NOT NULL,
	[FTAppName] [varchar](50) NOT NULL,
	[FTXdhDocNo] [varchar](10) NOT NULL,
	[FDXdsDUpgrade] [datetime] NULL,
	[FTXdsStaPrc] [varchar](1) NULL,
	[FTXdsStaDoc] [varchar](1) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[FTAgnCode] ASC,
	[FTBchCode] ASC,
	[FTMerCode] ASC,
	[FTShpCode] ASC,
	[FTPosCode] ASC,
	[FTAppName] ASC,
	[FTXdhDocNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNTAppDepLog]    Script Date: 18/2/2565 17:24:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTAppDepLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTAppDepLog](
	[FTXdhDocNo] [varchar](10) NOT NULL,
	[FNXdlSeq] [int] NOT NULL,
	[FTAppName] [varchar](50) NULL,
	[FTXdlDesc] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[FTXdhDocNo] ASC,
	[FNXdlSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO




/****** Object:  Table [dbo].[[TRPTSalAnlsByBchTmp]]    Script Date: 14/7/2564 12:54:08 ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTImpMasTmp]') AND type in (N'U'))
BEGIN
DROP TABLE [TCNTImpMasTmp];
END
GO 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTImpMasTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTImpMasTmp](
		[FTTmpTableKey] varchar(50) NULL ,
		[FTSessionID] varchar(255) NULL ,
		[FNTmpSeq] int NULL ,
		[FTBchCode] varchar(5) NULL ,
		[FTBchName] varchar(100) NULL ,
		[FTAgnCode] varchar(10) NULL ,
		[FTPplCode] varchar(5) NULL ,
		[FTTmpStatus] varchar(1) NULL ,
		[FTTmpRemark] varchar(MAX) NULL ,
		[FDCreateOn] datetime NULL ,
		[FTUsrCode] varchar(20) NULL ,
		[FTUsrName] varchar(100) NULL ,
		[FTRolCode] varchar(5) NULL ,
		[FTMerCode] varchar(10) NULL ,
		[FTShpCode] varchar(5) NULL ,
		[FTDptCode] varchar(5) NULL ,
		[FTUsrTel] varchar(50) NULL ,
		[FTUsrEmail] varchar(50) NULL ,
		[FTPosCode] varchar(5) NULL ,
		[FTPosName] varchar(100) NULL ,
		[FTPosType] varchar(30) NULL ,
		[FTPosRegNo] varchar(20) NULL ,
		[FTTcgCode] varchar(5) NULL ,
		[FTTcgName] varchar(100) NULL ,
		[FTPbnCode] varchar(5) NULL ,
		[FTPbnName] varchar(100) NULL ,
		[FTPunCode] varchar(5) NULL ,
		[FTPunName] varchar(100) NULL ,
		[FTPdtCode] varchar(20) NULL ,
		[FTPdtName] varchar(100) NULL ,
		[FTPdtNameABB] varchar(50) NULL ,
		[FCPdtUnitFact] numeric(18,4) NULL ,
		[FTBarCode] varchar(25) NULL ,
		[FCPdtMin] numeric(18,4) NULL ,
		[FTPmhName] varchar(200) NULL ,
		[FDPmhDStart] datetime NULL ,
		[FDPmhDStop] datetime NULL ,
		[FDPmhTStart] datetime NULL ,
		[FDPmhTStop] datetime NULL ,
		[FTPmhStaLimitCst] varchar(1) NULL ,
		[FTPbyStaBuyCond] varchar(1) NULL ,
		[FTPmhStaGrpPriority] varchar(1) NULL ,
		[FTPmhStaGetPdt] varchar(1) NULL ,
		[FTPmhStaChkQuota] varchar(1) NULL ,
		[FTPmhStaGetPri] varchar(1) NULL ,
		[FTPmhStaChkCst] varchar(1) NULL ,
		[FTSpmMemAge] varchar(50) NULL ,
		[FTSpmStaLimitCst] varchar(1) NULL ,
		[FNSpmMemAgeLT] varchar(255) NULL ,
		[FTSpmMemDOB] varchar(50) NULL ,
		[FTSpmStaChkCstDOB] varchar(1) NULL ,
		[FNPmhCstDobPrev] bigint NULL ,
		[FNPmhCstDobNext] bigint NULL ,
		[FTPbyStaCalSum] varchar(1) NULL ,
		[FTPgtStaGetEffect] varchar(1) NULL ,
		[FTPmdStaType] varchar(1) NULL ,
		[FTPmdGrpName] varchar(50) NULL ,
		[FTPmdRefCode] varchar(20) NULL ,
		[FTPmdBarCode] varchar(25) NULL ,
		[FTPmdSubRef] varchar(5) NULL ,
		[FCPbyMinValue] numeric(18,4) NULL ,
		[FCPbyMaxValue] numeric(18,4) NULL ,
		[FCPbyMinSetPri] numeric(18,4) NULL ,
		[FTPgtStaGetType] varchar(1) NULL ,
		[FCPgtGetvalue] numeric(18,4) NULL ,
		[FCPgtGetQty] numeric(18,4) NULL ,
		[FTPgtStaCoupon] varchar(1) NULL ,
		[FTCphDocNo] varchar(20) NULL ,
		[FTPgtCpnText] varchar(50) NULL ,
		[FTPgtStaPoint] varchar(1) NULL ,
		[FTPgtStaPntCalType] varchar(1) NULL ,
		[FNPgtPntGet] bigint NULL ,
		[FNPgtPntBuy] bigint NULL ,
		[FCPbyPerAvgDis] numeric(18,4) NULL ,
		[FTPtyCode] varchar(5) NULL ,
		[FTPtyName] varchar(100) NULL ,
		[FTPmoCode] varchar(5) NULL ,
		[FTPmoName] varchar(50) NULL ,
		[FTPgpChain] varchar(30) NULL ,
		[FTPgpName] varchar(100) NULL ,
		[FTPdtStaVat] varchar(1) NULL ,
		[FTPdtBarDupType] varchar(1) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO
-- ----------------------------
-- Indexes structure for table TCNTImpMasTmp
-- ----------------------------
CREATE INDEX [IND_TCNTImpMasTmp_FTTmpTableKey] ON [dbo].[TCNTImpMasTmp]
([FTTmpTableKey] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FNTmpSeq] ON [dbo].[TCNTImpMasTmp]
([FNTmpSeq] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTBchCode] ON [dbo].[TCNTImpMasTmp]
([FTBchCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTBchName] ON [dbo].[TCNTImpMasTmp]
([FTBchName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTAgnCode] ON [dbo].[TCNTImpMasTmp]
([FTAgnCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPplCode] ON [dbo].[TCNTImpMasTmp]
([FTPplCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTTmpStatus] ON [dbo].[TCNTImpMasTmp]
([FTTmpStatus] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTUsrCode] ON [dbo].[TCNTImpMasTmp]
([FTUsrCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTUsrName] ON [dbo].[TCNTImpMasTmp]
([FTUsrName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTRolCode] ON [dbo].[TCNTImpMasTmp]
([FTRolCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTMerCode] ON [dbo].[TCNTImpMasTmp]
([FTMerCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTShpCode] ON [dbo].[TCNTImpMasTmp]
([FTShpCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTDptCode] ON [dbo].[TCNTImpMasTmp]
([FTDptCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPosCode] ON [dbo].[TCNTImpMasTmp]
([FTPosCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPosName] ON [dbo].[TCNTImpMasTmp]
([FTPosName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTTcgCode] ON [dbo].[TCNTImpMasTmp]
([FTTcgCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTTcgName] ON [dbo].[TCNTImpMasTmp]
([FTTcgName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPbnCode] ON [dbo].[TCNTImpMasTmp]
([FTPbnCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPbnName] ON [dbo].[TCNTImpMasTmp]
([FTPbnName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPunCode] ON [dbo].[TCNTImpMasTmp]
([FTPunCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPunName] ON [dbo].[TCNTImpMasTmp]
([FTPunName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPdtCode] ON [dbo].[TCNTImpMasTmp]
([FTPdtCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPdtName] ON [dbo].[TCNTImpMasTmp]
([FTPdtName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPdtNameABB] ON [dbo].[TCNTImpMasTmp]
([FTPdtNameABB] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTBarCode] ON [dbo].[TCNTImpMasTmp]
([FTBarCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmhName] ON [dbo].[TCNTImpMasTmp]
([FTPmhName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmhStaLimitCst] ON [dbo].[TCNTImpMasTmp]
([FTPmhStaLimitCst] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPbyStaBuyCond] ON [dbo].[TCNTImpMasTmp]
([FTPbyStaBuyCond] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmhStaGrpPriority] ON [dbo].[TCNTImpMasTmp]
([FTPmhStaGrpPriority] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmhStaGetPdt] ON [dbo].[TCNTImpMasTmp]
([FTPmhStaGetPdt] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmhStaChkQuota] ON [dbo].[TCNTImpMasTmp]
([FTPmhStaChkQuota] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmhStaGetPri] ON [dbo].[TCNTImpMasTmp]
([FTPmhStaGetPri] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmhStaChkCst] ON [dbo].[TCNTImpMasTmp]
([FTPmhStaChkCst] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTSpmStaLimitCst] ON [dbo].[TCNTImpMasTmp]
([FTSpmStaLimitCst] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTSpmStaChkCstDOB] ON [dbo].[TCNTImpMasTmp]
([FTSpmStaChkCstDOB] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPbyStaCalSum] ON [dbo].[TCNTImpMasTmp]
([FTPbyStaCalSum] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPgtStaGetEffect] ON [dbo].[TCNTImpMasTmp]
([FTPgtStaGetEffect] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmdStaType] ON [dbo].[TCNTImpMasTmp]
([FTPmdStaType] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmdGrpName] ON [dbo].[TCNTImpMasTmp]
([FTPmdGrpName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmdRefCode] ON [dbo].[TCNTImpMasTmp]
([FTPmdRefCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmdBarCode] ON [dbo].[TCNTImpMasTmp]
([FTPmdBarCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPgtStaGetType] ON [dbo].[TCNTImpMasTmp]
([FTPgtStaGetType] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPgtStaCoupon] ON [dbo].[TCNTImpMasTmp]
([FTPgtStaCoupon] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTCphDocNo] ON [dbo].[TCNTImpMasTmp]
([FTCphDocNo] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPgtStaPoint] ON [dbo].[TCNTImpMasTmp]
([FTPgtStaPoint] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPgtStaPntCalType] ON [dbo].[TCNTImpMasTmp]
([FTPgtStaPntCalType] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPtyCode] ON [dbo].[TCNTImpMasTmp]
([FTPtyCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPtyName] ON [dbo].[TCNTImpMasTmp]
([FTPtyName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmoCode] ON [dbo].[TCNTImpMasTmp]
([FTPmoCode] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPmoName] ON [dbo].[TCNTImpMasTmp]
([FTPmoName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPgpName] ON [dbo].[TCNTImpMasTmp]
([FTPgpName] ASC) 
GO
CREATE INDEX [IND_TCNTImpMasTmp_FTPdtStaVat] ON [dbo].[TCNTImpMasTmp]
([FTPdtStaVat] ASC) 
GO





/****** Object:  Table [dbo].[TCNMFleObj]    Script Date: 20/4/2565 12:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMFleObj]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMFleObj](
	[FNFleID] [int] IDENTITY(1,1) NOT NULL,
	[FTFleRefTable] [varchar](50) NULL,
	[FTFleRefID1] [varchar](50) NULL,
	[FTFleRefID2] [varchar](50) NULL,
	[FNFleSeq] [bigint] NULL,
	[FTFleType] [varchar](10) NULL,
	[FTFleObj] [varchar](255) NULL,
	[FTFleName] [varchar](255) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](50) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[FNFleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNMFleObjTmp]    Script Date: 20/4/2565 12:45:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMFleObjTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMFleObjTmp](
	[FTFleRefTable] [varchar](50) NULL,
	[FTFleRefID1] [varchar](50) NULL,
	[FTFleRefID2] [varchar](50) NULL,
	[FNFleSeq] [bigint] NULL,
	[FTFleType] [varchar](255) NULL,
	[FTFleObj] [varchar](255) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTSessionID] [varchar](255) NULL,
	[FTFleName] [varchar](100) NULL,
	[FTFleStaUpd] [varchar](1) NULL
) ON [PRIMARY]
END
GO


IF EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPghDocNo') BEGIN
	DROP INDEX IND_TCNTPdtPrice4PDT_FTPghDocNo ON TCNTPdtPrice4PDT
END
GO
IF EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPghDocType') BEGIN
	DROP INDEX IND_TCNTPdtPrice4PDT_FTPghDocType ON TCNTPdtPrice4PDT
END
GO
IF EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FDLastUpdOn') BEGIN
	DROP INDEX IND_TCNTPdtPrice4PDT_FDLastUpdOn ON TCNTPdtPrice4PDT
END
GO
IF EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FDPghDStart') BEGIN
	DROP INDEX IND_TCNTPdtPrice4PDT_FDPghDStart ON TCNTPdtPrice4PDT
END
GO
IF EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPdtCode') BEGIN
	DROP INDEX IND_TCNTPdtPrice4PDT_FTPdtCode ON TCNTPdtPrice4PDT
END
GO
IF EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPghStaAdj') BEGIN
	DROP INDEX IND_TCNTPdtPrice4PDT_FTPghStaAdj ON TCNTPdtPrice4PDT
END
GO
IF EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPghTStart') BEGIN
	DROP INDEX IND_TCNTPdtPrice4PDT_FTPghTStart ON TCNTPdtPrice4PDT
END
GO
IF EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPplCode') BEGIN
	DROP INDEX IND_TCNTPdtPrice4PDT_FTPplCode ON TCNTPdtPrice4PDT
END
GO
IF EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPunCode') BEGIN
	DROP INDEX IND_TCNTPdtPrice4PDT_FTPunCode ON TCNTPdtPrice4PDT
END
GO
ALTER TABLE TCNTPdtPrice4PDT ALTER COLUMN FTPghDocType VARCHAR(1) NOT NULL
GO
ALTER TABLE TCNTPdtPrice4PDT ALTER COLUMN FTPghDocNo VARCHAR(20) NOT NULL
GO		
IF EXISTS(SELECT name FROM sys.key_constraints WHERE name = 'PK_TCNTPdtPrice4PDT') BEGIN
	ALTER TABLE TCNTPdtPrice4PDT DROP CONSTRAINT PK_TCNTPdtPrice4PDT
END
GO
ALTER TABLE TCNTPdtPrice4PDT ADD CONSTRAINT PK_TCNTPdtPrice4PDT PRIMARY KEY (FTPdtCode,FTPunCode,FDPghDStart,FTPghTStart,FTPplCode,FTPghDocType,FTPghDocNo);
GO
IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPghDocNo') BEGIN
	CREATE NONCLUSTERED INDEX IND_TCNTPdtPrice4PDT_FTPghDocNo  ON TCNTPdtPrice4PDT (FTPghDocNo);  
END
GO
IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPghDocType') BEGIN
	CREATE NONCLUSTERED INDEX IND_TCNTPdtPrice4PDT_FTPghDocType ON TCNTPdtPrice4PDT (FTPghDocType)
END
GO
IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FDLastUpdOn') BEGIN
	CREATE NONCLUSTERED INDEX IND_TCNTPdtPrice4PDT_FDLastUpdOn ON TCNTPdtPrice4PDT (FDLastUpdOn)
END
GO
IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FDPghDStart') BEGIN
	CREATE NONCLUSTERED INDEX IND_TCNTPdtPrice4PDT_FDPghDStart ON TCNTPdtPrice4PDT (FDPghDStart)
END
GO
IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPdtCode') BEGIN
	CREATE NONCLUSTERED INDEX IND_TCNTPdtPrice4PDT_FTPdtCode ON TCNTPdtPrice4PDT (FTPdtCode)
END
GO
IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPghStaAdj') BEGIN
	CREATE NONCLUSTERED INDEX IND_TCNTPdtPrice4PDT_FTPghStaAdj ON TCNTPdtPrice4PDT (FTPghStaAdj)
END
GO
IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPghTStart') BEGIN
	CREATE NONCLUSTERED INDEX IND_TCNTPdtPrice4PDT_FTPghTStart ON TCNTPdtPrice4PDT (FTPghTStart)
END
GO
IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPplCode') BEGIN
	CREATE NONCLUSTERED INDEX IND_TCNTPdtPrice4PDT_FTPplCode ON TCNTPdtPrice4PDT (FTPplCode)
END
GO
IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = 'IND_TCNTPdtPrice4PDT_FTPunCode') BEGIN
	CREATE NONCLUSTERED INDEX IND_TCNTPdtPrice4PDT_FTPunCode ON TCNTPdtPrice4PDT (FTPunCode)
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMPrnLabel]') AND type in (N'U')) BEGIN
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPrnLabel' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	DROP TABLE TCNMPrnLabel;
	DROP TABLE TCNMPrnLabel_L;
END
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMPrnServer]') AND type in (N'U')) BEGIN
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPrnServer' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	DROP TABLE TCNMPrnServer;
	DROP TABLE TCNMPrnServer_L;
END
END
GO

/****** Object:  Table [dbo].[TCNMPrnLabel]    Script Date: 15/7/2565 12:08:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMPrnLabel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMPrnLabel](
	[FTAgnCode] [varchar](10) NOT NULL,
	[FTPlbCode] [varchar](10) NOT NULL,
	[FTLblCode] [varchar](10) NULL,
	[FTSppCode] [varchar](50) NULL,
	[FTPlbStaUse] [varchar](1) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
 CONSTRAINT [PK_TCNMPrnLabel] PRIMARY KEY CLUSTERED 
(
	[FTAgnCode] ASC,
	[FTPlbCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


/****** Object:  Table [dbo].[TCNMPrnLabel_L]    Script Date: 15/7/2565 12:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMPrnLabel_L]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMPrnLabel_L](
	[FTAgnCode] [varchar](10) NOT NULL,
	[FTPlbCode] [varchar](10) NOT NULL,
	[FNLngID] [bigint] NOT NULL,
	[FTPblName] [varchar](200) NULL,
	[FTPblRmk] [varchar](200) NULL,
 CONSTRAINT [PK_TCNMPrnLabel_L] PRIMARY KEY CLUSTERED 
(
	[FTAgnCode] ASC,
	[FTPlbCode] ASC,
	[FNLngID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNMPrnServer]    Script Date: 15/7/2565 12:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMPrnServer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMPrnServer](
	[FTAgnCode] [varchar](10) NOT NULL,
	[FTSrvCode] [varchar](10) NOT NULL,
	[FTSrvStaUse] [varchar](1) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
 CONSTRAINT [PK_TCNMPrnServer] PRIMARY KEY CLUSTERED 
(
	[FTAgnCode] ASC,
	[FTSrvCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNMPrnServer_L]    Script Date: 15/7/2565 12:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMPrnServer_L]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMPrnServer_L](
	[FTAgnCode] [varchar](10) NOT NULL,
	[FTSrvCode] [varchar](10) NOT NULL,
	[FNLngID] [bigint] NOT NULL,
	[FTSrvName] [varchar](200) NULL,
	[FTSrvRmk] [varchar](200) NULL,
 CONSTRAINT [PK_TCNMPrnServer_L] PRIMARY KEY CLUSTERED 
(
	[FTAgnCode] ASC,
	[FTSrvCode] ASC,
	[FNLngID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNSLabelFmt]    Script Date: 15/7/2565 12:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNSLabelFmt]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNSLabelFmt](
	[FTLblCode] [varchar](10) NOT NULL,
	[FTLblRptNormal] [varchar](100) NULL,
	[FTLblRptPmt] [varchar](100) NULL,
	[FTLblStaUse] [varchar](1) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
	[FNLblQtyPerPageNml] [bigint] NULL,
	[FNLblQtyPerPagePmt] [bigint] NULL,
	[FTLblVerGroup] [varchar](20) NULL,
	[FTLblSizeWH] [varchar](30) NULL,
 CONSTRAINT [PK_TCNSLabelFmt] PRIMARY KEY CLUSTERED 
(
	[FTLblCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNSLabelFmt' AND COLUMN_NAME = 'FNLblQtyPerPageNml') BEGIN
	ALTER TABLE TCNSLabelFmt ADD FNLblQtyPerPageNml [bigint]
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNSLabelFmt' AND COLUMN_NAME = 'FNLblQtyPerPagePmt') BEGIN
	ALTER TABLE TCNSLabelFmt ADD FNLblQtyPerPagePmt [bigint]
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNSLabelFmt' AND COLUMN_NAME = 'FTLblVerGroup') BEGIN
	ALTER TABLE TCNSLabelFmt ADD FTLblVerGroup [varchar](20)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNSLabelFmt' AND COLUMN_NAME = 'FTLblSizeWH') BEGIN
	ALTER TABLE TCNSLabelFmt ADD FTLblSizeWH [varchar](20)
END
GO
/****** Object:  Table [dbo].[TCNSLabelFmt_L]    Script Date: 15/7/2565 12:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNSLabelFmt_L]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNSLabelFmt_L](
	[FTLblCode] [varchar](10) NOT NULL,
	[FNLngID] [bigint] NOT NULL,
	[FTLblName] [varchar](200) NULL,
	[FTLblRmk] [varchar](200) NULL,
 CONSTRAINT [PK_TCNSLabelFmt_L] PRIMARY KEY CLUSTERED 
(
	[FTLblCode] ASC,
	[FNLngID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TCNTPrnLabelTmp]    Script Date: 15/7/2565 12:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPrnLabelTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPrnLabelTmp](
	[FTComName] [varchar](50) NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTPdtName] [varchar](100) NULL,
	[FTBarCode] [varchar](25) NULL,
	[FCPdtPrice] [numeric](18, 4) NULL,
	[FTPlcCode] [varchar](10) NULL,
	[FDPrnDate] [datetime] NULL,
	[FTPdtContentUnit] [varchar](100) NULL,
	[FTPlbCode] [varchar](255) NULL,
	[FNPlbQty] [bigint] NULL,
	[FTPdtTime] [varchar](20) NULL,
	[FTPdtMfg] [varchar](20) NULL,
	[FTPdtImporter] [varchar](100) NULL,
	[FTPdtRefNo] [varchar](30) NULL,
	[FTPdtValue] [varchar](100) NULL,
	[FTPbnDesc] [varchar](100) NULL,
	[FTPlbStaSelect] [varchar](255) NULL,
	[FTPdtNameOth] [varchar](100) NULL,
	[FTPlbSubDept] [varchar](100) NULL,
	[FTPlbRepleType] [varchar](2) NULL,
	[FTPlbPriStatus] [varchar](50) NULL,
	[FTPlbSellingUnit] [varchar](100) NULL,
	[FCPdtSetPrice] [numeric](18, 4) NULL,
	[FTPlbPhasing] [varchar](5) NULL,
	[FTPlbPriPerUnit] [varchar](100) NULL,
	[FTPlbCapFree] [varchar](25) NULL,
	[FTPlbPdtChain] [varchar](30) NULL,
	[FTPlbCapNamePmt] [varchar](200) NULL,
	[FTPlbPmtInterval] [varchar](50) NULL,
	[FCPlbPmtGetCond] [numeric](18, 4) NULL,
	[FCPlbPmtGetValue] [numeric](18, 4) NULL,
	[FDPlbPmtDStart] [datetime] NULL,
	[FDPlbPmtDStop] [datetime] NULL,
	[FTPlbPmtCode] [varchar](20) NULL,
	[FCPlbPmtBuyQty] [numeric](18, 4) NULL,
	[FTPlbClrName] [varchar](100) NULL,
	[FTPlbPszName] [varchar](100) NULL,
	[FTPlbType] [varchar](50) NULL,
	[FTPlbStaImport] [varchar](1) NULL,
	[FTPlbImpDesc] [varchar](255) NULL
) ON [AdaPos5_SKU_Filegroups]
END
GO
/****** Object:  Table [dbo].[TSysPortPrn]    Script Date: 15/7/2565 12:08:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TSysPortPrn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TSysPortPrn](
	[FTSppCode] [varchar](50) NOT NULL,
	[FTSppValue] [varchar](100) NULL,
	[FTSppRef] [varchar](100) NULL,
	[FTSppType] [varchar](3) NULL,
	[FTSppStaUse] [varchar](1) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
 CONSTRAINT [PK_TSysPortPrn] PRIMARY KEY CLUSTERED 
(
	[FTSppCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TSysPortPrn_L]    Script Date: 15/7/2565 12:08:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TSysPortPrn_L]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TSysPortPrn_L](
	[FTSppCode] [varchar](50) NOT NULL,
	[FNLngID] [bigint] NOT NULL,
	[FTSppName] [varchar](200) NULL,
 CONSTRAINT [PK_TSysPortPrn_L] PRIMARY KEY CLUSTERED 
(
	[FTSppCode] ASC,
	[FNLngID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO



IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvRefID') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvRefID varchar(30)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvRefEdc') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvRefEdc varchar(5)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvRefDoc') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvRefDoc varchar(20)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FNRcvQtySlip') BEGIN
	ALTER TABLE TFNMRcv ADD FNRcvQtySlip bigint NULL
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaCshOrCrd') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaCshOrCrd varchar(1)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaAlwAccPoint') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaAlwAccPoint varchar(1)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaAlwDrawer') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaAlwDrawer varchar(1)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaReason') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaReason varchar(1)
END
GO
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaShwSum') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaShwSum varchar(1)
END
GO





IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMPdtScale]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMPdtScale](
	[FTAgnCode] [varchar](10) NOT NULL,
	[FTPdsCode] [varchar](5) NOT NULL,
	[FTPdsMatchStr] [varchar](2) NULL,
	[FNPdsLenBar] [bigint] NULL,
	[FNPdsLenPdt] [bigint] NULL,
	[FNPdsPdtStart] [bigint] NULL,
	[FNPdsLenPri] [bigint] NULL,
	[FNPdsPriStart] [bigint] NULL,
	[FNPdsPriDec] [bigint] NULL,
	[FNPdsLenWeight] [bigint] NULL,
	[FNPdsWeightStart] [bigint] NULL,
	[FNPdsWeightDec] [bigint] NULL,
	[FTPdsStaChkDigit] [varchar](1) NULL,
	[FTPdsStaUse] [varchar](1) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
 CONSTRAINT [PK_TCNMPdtScale] PRIMARY KEY CLUSTERED 
(
	[FTAgnCode] ASC,
	[FTPdsCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO



/****** Object:  Table [dbo].[TCNTPrnLabelTmp]    Script Date: 5/8/2565 13:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPrnLabelTmp]') AND type in (N'U'))
	DROP TABLE [dbo].[TCNTPrnLabelTmp]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPrnLabelTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPrnLabelTmp](
	[FTComName] [varchar](50) NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTPdtName] [varchar](100) NULL,
	[FTBarCode] [varchar](25) NULL,
	[FTPlcCode] [varchar](10) NULL,
	[FDPrnDate] [datetime] NULL,
	[FTPdtContentUnit] [varchar](100) NULL,
	[FTPlbCode] [varchar](255) NULL,
	[FNPlbQty] [bigint] NULL,
	[FTPdtTime] [varchar](20) NULL,
	[FTPdtMfg] [varchar](20) NULL,
	[FTPdtImporter] [varchar](100) NULL,
	[FTPdtRefNo] [varchar](30) NULL,
	[FTPdtValue] [varchar](100) NULL,
	[FTPbnDesc] [varchar](100) NULL,
	[FTPdtNameOth] [varchar](100) NULL,
	[FTPlbSubDept] [varchar](100) NULL,
	[FTPlbRepleType] [varchar](2) NULL,
	[FTPlbPriStatus] [varchar](50) NULL,
	[FTPlbSellingUnit] [varchar](100) NULL,
	[FCPdtPrice] [float] NULL,
	[FCPdtOldPrice] [float] NULL,
	[FTPlbPhasing] [varchar](5) NULL,
	[FTPlbPriPerUnit] [varchar](100) NULL,
	[FTPlbCapFree] [varchar](25) NULL,
	[FTPlbPdtChain] [varchar](30) NULL,
	[FTPlbCapNamePmt] [varchar](200) NULL,
	[FTPlbPmtInterval] [varchar](50) NULL,
	[FCPlbPmtGetCond] [float] NULL,
	[FCPlbPmtGetValue] [float] NULL,
	[FDPlbPmtDStart] [datetime] NULL,
	[FDPlbPmtDStop] [datetime] NULL,
	[FTPlbPmtCode] [varchar](20) NULL,
	[FCPlbPmtBuyQty] [float] NULL,
	[FTPlbClrName] [varchar](100) NULL,
	[FTPlbPszName] [varchar](100) NULL,
	[FTPlbPriType] [varchar](1) NULL,
	[FTPlbStaImport] [varchar](1) NULL,
	[FTPlbImpDesc] [varchar](255) NULL,
	[FTPlbUrl] [varchar](255) NULL,
	[FTPlbStaSelect] [varchar](1) NULL
) ON [PRIMARY]
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPrnLabelHDTmp]') AND type in (N'U'))
	DROP TABLE [dbo].[TCNTPrnLabelHDTmp]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPrnLabelHDTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPrnLabelHDTmp](
	[FTComName] [varchar](50) NULL,
	[FTPlbPriType] [varchar](1) NULL,
	[FNPage] [int] NOT NULL,
	[FNSeq] [int] NOT NULL,
	[FTBarCode] [varchar](25) NULL,
	[FTPdtName] [varchar](100) NULL,
	[FTPdtContentUnit] [varchar](100) NULL,
	[FNPlbQty] [bigint] NULL,
	[FTPlbStaSelect] [varchar](1) NULL
) ON [PRIMARY]
END
GO






/****** Object:  Table [dbo].[TRPTSalDTTmp]    Script Date: 05/09/2022 18:36:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTSalDTTmp')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTSalDTTmp
GO
CREATE TABLE [dbo].[TRPTSalDTTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FNAppType] [int] NULL,
	[FTBchCode] [varchar](5) NULL,
	[FTBchName] [varchar](100) NULL,
	[FTXshDocNo] [varchar](20) NULL,
	[FNXsdSeqNo] [int] NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTXsdPdtName] [varchar](100) NULL,
	[FTPgpChainName] [varchar](255) NULL,
	[FTPunCode] [varchar](5) NULL,
	[FTPunName] [varchar](50) NULL,
	[FCXsdFactor] [numeric](18, 4) NULL,
	[FTXsdBarCode] [varchar](25) NULL,
	[FTSrnCode] [varchar](50) NULL,
	[FTXsdVatType] [varchar](1) NULL,
	[FTVatCode] [varchar](5) NULL,
	[FCXsdVatRate] [numeric](18, 4) NULL,
	[FTXsdSaleType] [varchar](1) NULL,
	[FCXsdSalePrice] [numeric](18, 4) NULL,
	[FCXsdQty] [numeric](18, 4) NULL,
	[FCXsdQtyAll] [numeric](18, 4) NULL,
	[FCXsdSetPrice] [numeric](18, 4) NULL,
	[FCXsdAmtB4DisChg] [numeric](18, 4) NULL,
	[FTXsdDisChgTxt] [varchar](50) NULL,
	[FCXsdDis] [numeric](18, 4) NULL,
	[FCXsdChg] [numeric](18, 4) NULL,
	[FCXsdNet] [numeric](18, 4) NULL,
	[FCXsdNetAfHD] [numeric](18, 4) NULL,
	[FCXsdVat] [numeric](18, 4) NULL,
	[FCXsdVatable] [numeric](18, 4) NULL,
	[FCXsdWhtAmt] [numeric](18, 4) NULL,
	[FTXsdWhtCode] [varchar](5) NULL,
	[FCXsdWhtRate] [numeric](18, 4) NULL,
	[FCXsdCostIn] [numeric](18, 4) NULL,
	[FCXsdCostEx] [numeric](18, 4) NULL,
	[FTXsdStaPdt] [varchar](1) NULL,
	[FCXsdQtyLef] [numeric](18, 4) NULL,
	[FCXsdQtyRfn] [numeric](18, 4) NULL,
	[FTXsdStaPrcStk] [varchar](1) NULL,
	[FTXsdStaAlwDis] [varchar](1) NULL,
	[FNXsdPdtLevel] [int] NULL,
	[FTXsdPdtParent] [varchar](20) NULL,
	[FCXsdQtySet] [numeric](18, 4) NULL,
	[FTPdtStaSet] [varchar](1) NULL,
	[FTXsdRmk] [varchar](200) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,
	[FTPbnCode] [varchar](5) NULL,
	[FTPbnName] [varchar](200) NULL,
	[FTPtyCode] [varchar](5) NULL,
	[FTPtyName] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTSalDTTmp] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO




/****** Object:  Table [dbo].[TRPTPSTaxMonthTmp_Animate]    Script Date: 11/09/2022 11:21:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTPSTaxMonthTmp_Animate')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTPSTaxMonthTmp_Animate
GO
CREATE TABLE [dbo].[TRPTPSTaxMonthTmp_Animate](
--CREATE TABLE [dbo].[TRPTPSTaxHDDateTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,

	[FNAppType] [int] NULL, -- 1 : Pos, 2 : Vending
	[FTBchCode] [varchar](5) NULL, -- สาขา
	--[FTBchName] [varchar](100) NULL,

	[FTXshDocLegth] [varchar](100) NULL, -- ใบกำกับภาษี (เลขที่)
	[FTXshDocDate] [varchar](30) NULL, -- ใบกำกับภาษี  (วันที่)

	[FTCstCode] [varchar](20) NULL, 
	[FTCstName] [varchar](255) NULL, --ผู้ซื้อสินค้า/ผู้รับบริการ
	[FTXshMonthTH] [varchar](30) NULL, -- รายงานภาษีขายประจำเดือน ไทย
	[FTXshMonthEN] [varchar](30) NULL, -- รายงานภาษีขายประจำเดือน Eng

	[FTXshAddrTax] [varchar](30) NULL, --เลขประจำตัวผู้เสียภาษี
	[FCXshAmtNV] [numeric](18, 4) NULL, -- Before Vat(0%)
	[FCXshVatable] [numeric](18, 4) NULL, --Before Vat
	[FCXshVat] [numeric](18, 4) NULL, --จำนวนเงินภาษี
	[FCXshGrandAmt] [numeric](18, 4) NULL, --จำนวนเงินรวม

	[FNSeqNo] [int] NULL,
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTPSTaxMonthTmp_Animate] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO


ALTER TABLE TCNMPdtBarTmp ALTER COLUMN FTFhnRefCode VARCHAR (50) NULL;



/****** Object:  Table [dbo].[TRPTPurVatTmp]    Script Date: 14/9/2565 13:39:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTPurVatTmp]') AND type in (N'U'))
DROP TABLE [dbo].[TRPTPurVatTmp]
GO
/****** Object:  Table [dbo].[TRPTPurSplByPdtTmp]    Script Date: 14/9/2565 13:39:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTPurSplByPdtTmp]') AND type in (N'U'))
DROP TABLE [dbo].[TRPTPurSplByPdtTmp]
GO
/****** Object:  Table [dbo].[TRPTPurByPdtTmp]    Script Date: 14/9/2565 13:39:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTPurByPdtTmp]') AND type in (N'U'))
DROP TABLE [dbo].[TRPTPurByPdtTmp]
GO
/****** Object:  Table [dbo].[TRPTPurByPdtTmp]    Script Date: 14/9/2565 13:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRPTPurByPdtTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FTUsrSession] [varchar](255) NOT NULL,
	[FTComName] [varchar](50) NOT NULL,
	[FTRptCode] [varchar](50) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTPdtName] [varchar](255) NULL,
	[FTPunName] [varchar](200) NULL,
	[FCXpdQty] [numeric](18, 4) NULL,
	[FCXpdDis] [numeric](18, 4) NULL,
	[FCXpdValue] [numeric](18, 4) NULL,
	[FCXpdVat] [numeric](18, 4) NULL,
	[FCXpdNetAmt] [numeric](18, 4) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TRPTPurSplByPdtTmp]    Script Date: 14/9/2565 13:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRPTPurSplByPdtTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FTUsrSession] [varchar](255) NOT NULL,
	[FTComName] [varchar](50) NOT NULL,
	[FTRptCode] [varchar](50) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTSplCode] [varchar](20) NULL,
	[FTSplName] [varchar](200) NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTPdtName] [varchar](255) NULL,
	[FTPunName] [varchar](200) NULL,
	[FCXpdQty] [numeric](18, 4) NULL,
	[FCXpdDis] [numeric](18, 4) NULL,
	[FCXpdValue] [numeric](18, 4) NULL,
	[FCXpdVat] [numeric](18, 4) NULL,
	[FCXpdNetAmt] [numeric](18, 4) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TRPTPurVatTmp]    Script Date: 14/9/2565 13:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRPTPurVatTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FNAppType] [int] NULL,
	[FTBchCode] [varchar](5) NULL,
	[FTBchName] [varchar](50) NULL,
	[FTAgnCode] [varchar](5) NULL,
	[FTAgnName] [varchar](200) NULL,
	[FTShpCode] [varchar](5) NULL,
	[FTXphDocNo] [varchar](20) NULL,
	[FDXphDocDate] [datetime] NULL,
	[FTXphDocRef] [varchar](20) NULL,
	[FTSplCode] [varchar](50) NULL,
	[FTSplBusiness] [varchar](1) NULL,
	[FTSplName] [varchar](255) NULL,
	[FTSplBchCode] [varchar](50) NULL,
	[FTSplTaxNo] [varchar](50) NULL,
	[FTCmpCode] [varchar](20) NULL,
	[FTCmpName] [varchar](255) NULL,
	[FCXphAmt] [numeric](18, 4) NULL,
	[FCXphAmtV] [numeric](18, 4) NULL,
	[FCXphAmtNV] [numeric](18, 4) NULL,
	[FCXphGrandTotal] [numeric](18, 4) NULL,
	[FCXphVat] [numeric](18, 4) NULL,
	[FTEstablishment] [varchar](100) NULL,
	[FDTmpTxnDate] [datetime] NULL,
	[FTXphRefExt] [varchar](20) NULL,
	[FDXphRefExtDate] [datetime] NULL,
	[FTComName] [varchar](100) NULL,
	[FTRptCode] [varchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[TRPTPdtHisTnfWahTmp]    Script Date: 14/9/2565 18:36:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTPdtHisTnfWahTmp]') AND type in (N'U'))
DROP TABLE [dbo].[TRPTPdtHisTnfWahTmp]
GO
/****** Object:  Table [dbo].[TRPTPdtHisTnfWahTmp]    Script Date: 14/9/2565 18:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRPTPdtHisTnfWahTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FTComName] [varchar](100) NULL,
	[FTRptCode] [varchar](100) NULL,
	[FTBchCode] [varchar](5) NULL,
	[FTBchName] [varchar](200) NULL,
	[FTXthDocNo] [varchar](20) NULL,
	[FDXthDocDate] [datetime] NULL,
	[FTXthWhFrm] [varchar](5) NULL,
	[FTWahNameFrm] [varchar](200) NULL,
	[FTXthWhTo] [varchar](5) NULL,
	[FTWahNameTo] [varchar](200) NULL,
	[FTXthApvCode] [varchar](5) NULL,
	[FTUsrName] [varchar](200) NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTXtdPdtName] [varchar](200) NULL,
	[FTPunName] [varchar](50) NULL,
	[FTXtdBarCode] [nchar](50) NULL,
	[FCXtdQty] [numeric](18, 4) NULL,
PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTSalDTTmp_Animate')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTSalDTTmp_Animate
GO
CREATE TABLE [dbo].[TRPTSalDTTmp_Animate](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,

	[FTBchCode] [varchar](5) NULL, --รหัสสาขา
	[FTBchName] [varchar](100) NULL, --ชื่อสาขา
	[FTXsdBarCode] [varchar](25) NULL, --บาร์โคด
	[FTPdtName] [varchar](100) NULL, --ชื่อสินค้า
	[FTPgpChainName] [varchar](255) NULL, --กลุ่มสินค้า
	[FTPbnName]  [varchar](100) NULL, --ยี่ห้อ
	[FCXsdQtyAll] [numeric](18, 4) NULL, --จำนวนขาย
	[FCStkQty]  [numeric](18, 4) NULL, --สต๊อกคงเหลือ
	[FCSdtNetSale] [numeric](18, 4) NULL, --ยอดขาย
	[FCPgdPriceRet] [numeric](18, 4) NULL, --ราคา/หน่วย
	[FCSdtNetAmt] [numeric](18, 4) NULL,--ยอดขายรวม

	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTSalDTTmp_Animate] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO


/****** Object:  Table [dbo].[TRPTPSByPeriodTmp]    Script Date: 11/01/2021 21:23:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--CREATE TABLE [dbo].[TTRPTPSByPeriodTmp](
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTPSByPeriodTmp')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTPSByPeriodTmp
GO

CREATE TABLE [dbo].[TRPTPSByPeriodTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FNAppType] [int] NULL,

	[FNTmeSeq] [int] NULL,
	[FTTmeTime] [varchar](11) NULL, --ช่วงเวลา
	[FCTmeSalQty] [decimal](18, 4) NULL, --จำนวนชิ้น
	[FCTmeSalQtyPercen] [decimal](18, 4) NULL, --% ต่อ จำนวนชิ้นที่ขายทั้งหมด
	[FCTmeSalBill] [decimal](18, 4) NULL, --จำนวนบิล 
	[FCTmeSalBillPercen] [decimal](18, 4) NULL, --% ต่อ จำนวนบิลที่ขายทั้งหมด
	[FCTmeSalAmt] [numeric](38, 4) NULL, -- ยอดขาย
	[FCTmeSalAmtPercen] [decimal](18, 4) NULL, -- % ต่อ ยอดที่ขายทั้งหมด
	[FCTmeDis] [numeric](18, 4) NULL, --ส่วนลด
	[FCTmeSalTotal] [numeric](18, 4) NULL, --ยอดขายรวม

	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
 CONSTRAINT [PK_TRPTPSTaxDailyTmp] PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) --ON [AdaPos5_RPT_Filegroups]
) --ON [AdaPos5_RPT_Filegroups]

GO



/****** Object:  Table [dbo].[TRPTPSTaxMonthTmp_Animate]    Script Date: 11/09/2022 11:21:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTPSTaxMonthTmp_Animate')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTPSTaxMonthTmp_Animate
GO
CREATE TABLE [dbo].[TRPTPSTaxMonthTmp_Animate](
--CREATE TABLE [dbo].[TRPTPSTaxHDDateTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,

	[FNAppType] [int] NULL, -- 1 : Pos, 2 : Vending
	[FTBchCode] [varchar](5) NULL, -- สาขา
	--[FTBchName] [varchar](100) NULL,

	[FTXshDocLegth] [varchar](100) NULL, -- ใบกำกับภาษี (เลขที่)
	[FTXshDocDate] [varchar](30) NULL, -- ใบกำกับภาษี  (วันที่)

	[FTCstCode] [varchar](20) NULL, 
	[FTCstName] [varchar](255) NULL, --ผู้ซื้อสินค้า/ผู้รับบริการ
	[FTXshMonthTH] [varchar](30) NULL, -- รายงานภาษีขายประจำเดือน ไทย
	[FTXshMonthEN] [varchar](30) NULL, -- รายงานภาษีขายประจำเดือน Eng

	[FTXshAddrTax] [varchar](30) NULL, --เลขประจำตัวผู้เสียภาษี
	[FCXshAmtNV] [numeric](18, 4) NULL, -- Before Vat(0%)
	[FCXshVatable] [numeric](18, 4) NULL, --Before Vat
	[FCXshVat] [numeric](18, 4) NULL, --จำนวนเงินภาษี
	[FCXshGrandAmt] [numeric](18, 4) NULL, --จำนวนเงินรวม
	[FNSeqNo] [Int] Not NULL, 

	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTPSTaxMonthTmp_Animate] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO

