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

/*By IcePHP (27/09/2022)*/
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyExpiredType') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyExpiredType varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyStaCrdReuse') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyStaCrdReuse varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyTAStaReset') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyTAStaReset varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyTAAlwReturn') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyTAAlwReturn varchar(1)
END
GO




/****** Object:  Table [dbo].[TRPTSalDTTmp_Animate]    Script Date: 05/09/2022 18:36:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTSaleINFOTmp_Animate')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTSaleINFOTmp_Animate
GO
CREATE TABLE [dbo].[TRPTSaleINFOTmp_Animate](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,

	[FTBarCode] [varchar](25) NULL, --บาร์โคด
	[FTPdtCode] [varchar](25) NULL, --รหัสสินค้า
	[FTPdtName] [varchar](200) NULL, --ชื่อสินค้า
	[FTPdtNameOth] [varchar](200) NULL, --ชื่อสินค้าภาษาญี่ปุ่น
	[FTPtyName]  [varchar](100) NULL, --ประเภท	
	[FTPbnName]  [varchar](100) NULL, --ยี่ห้อ
	[FCPdtStkSetPrice] [numeric](18, 4) NULL, --ราคาขาย/ชิ้น
	[FCPdtStkQtyIn] [numeric](18, 4) NULL, --จำนวนรับเข้า
	[FCPdtStkQtySale] [numeric](18, 4) NULL, --จำนวนขาย
	[FCStkQtyBal]  [numeric](18, 4) NULL, --สต๊อกคงเหลือ
	
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTSaleINFOTmp_Animate] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO




/****** Object:  Table [dbo].[TRPTSaleByPtyTmp_Animate]    Script Date: 28/09/2022 13:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].TRPTSaleByPtyTmp_Animate')) --and OBJECTPROPERTY(id, U'IsView') = 1)
drop TABLE TRPTSaleByPtyTmp_Animate
GO
CREATE TABLE [dbo].[TRPTSaleByPtyTmp_Animate](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTUsrSession] [varchar](255) NULL,

	[FTPtyCode]  [varchar](5) NULL, --รหัสประเภท
	[FTPtyName]  [varchar](100) NULL, --ชื่อประเภท	
	[FCXsdCostAvg] [numeric](18, 4) NULL, --ทุนขายรวม
	[FCXsdSaleTotal] [numeric](18, 4) NULL, --ยอดขายรวม
	[FCStkCostBal] [numeric](18, 4) NULL, --มูลค่าทุนคงเหลือหน้าร้าน
	[FCSalAmtBal]  [numeric](18, 4) NULL, --มูลค่าขายคงเหลือหน้าร้าน
	
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FDTmpTxnDate] [datetime] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[FTRptRowSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRPTSaleByPtyTmp_Animate] ADD  DEFAULT (getdate()) FOR [FDTmpTxnDate]
GO




IF OBJECT_ID(N'TCNMPosSpcCat') IS NULL BEGIN
	CREATE TABLE [dbo].[TCNMPosSpcCat](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTShpCode] [varchar](5) NOT NULL,
		[FTPosCode] [varchar](5) NOT NULL,
		[FNCatSeq] [smallint] NOT NULL,
		[FTPdtCat1] [varchar](10) NULL,
		[FTPdtCat2] [varchar](10) NULL,
		[FTPdtCat3] [varchar](10) NULL,
		[FTPdtCat4] [varchar](10) NULL,
		[FTPdtCat5] [varchar](10) NULL,
		[FTPgpChain] [varchar](30) NULL,
		[FTPtyCode] [varchar](5) NULL,
		[FTPbnCode] [varchar](5) NULL,
		[FTPmoCode] [varchar](5) NULL,
		[FTTcgCode] [varchar](5) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TCNMPosSpcCat] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTShpCode] ASC,
		[FTPosCode] ASC,
		[FNCatSeq] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AdaPos5_MAS_Filegroups]
	) ON [AdaPos5_MAS_Filegroups]
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNTPdtPmtCG' AND COLUMN_NAME = 'FTSplCode') BEGIN
	ALTER TABLE TCNTPdtPmtCG ADD FTSplCode VARCHAR(20)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNTPdtPmtCG' AND COLUMN_NAME = 'FDPgtPntStart') BEGIN
	ALTER TABLE TCNTPdtPmtCG ADD FDPgtPntStart DATETIME
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNTPdtPmtCG' AND COLUMN_NAME = 'FDPgtPntExpired') BEGIN
	ALTER TABLE TCNTPdtPmtCG ADD FDPgtPntExpired DATETIME
END
GO


/*By IcePHP (27/09/2022)*/
IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyExpiredType') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyExpiredType varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyStaCrdReuse') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyStaCrdReuse varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyTAStaReset') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyTAStaReset varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyTAAlwReturn') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyTAAlwReturn varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMTaxAddress_L' AND COLUMN_NAME = 'FNAddSeqNo') BEGIN
	ALTER TABLE TCNMTaxAddress_L ADD FNAddSeqNo bigint
END
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFCTRptCrdTmp' AND COLUMN_NAME = 'FTCrdHolderID' AND CHARACTER_MAXIMUM_LENGTH = '30') BEGIN
	ALTER TABLE TFCTRptCrdTmp ALTER COLUMN FTCrdHolderID varchar(30)
END
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFCTRptCrdTmp' AND COLUMN_NAME = 'FTCrdCode' AND CHARACTER_MAXIMUM_LENGTH = '30') BEGIN
	ALTER TABLE TFCTRptCrdTmp ALTER COLUMN FTCrdCode varchar(30)
END
GO


IF OBJECT_ID(N'TPSTSalDTSN') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSTSalDTSN](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FNXsdSeqNo] [int] NOT NULL,
		[FTPdtSerial] [varchar](20) NOT NULL,
		[FTPdtBatchID] [varchar](20) NOT NULL,
		[FCXsdQty] [numeric](18, 4) NULL,
		[FTXsdStaRet] [varchar](1) NULL,
	 CONSTRAINT [PK_TPSTSalDTSN] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FNXsdSeqNo] ASC,
		[FTPdtSerial] ASC,
		[FTPdtBatchID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalDTSN', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalDTSN', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalDTSN', @level2type=N'COLUMN',@level2name=N'FNXsdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Serial(NO)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalDTSN', @level2type=N'COLUMN',@level2name=N'FTPdtSerial'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Batch/Lot' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalDTSN', @level2type=N'COLUMN',@level2name=N'FTPdtBatchID'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนชื้น' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalDTSN', @level2type=N'COLUMN',@level2name=N'FCXsdQty'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะการคืน 1:ยังไม่คืน 2:คืนแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalDTSN', @level2type=N'COLUMN',@level2name=N'FTXsdStaRet'
END
GO
IF OBJECT_ID(N'TPSTSalHDDocRef') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSTSalHDDocRef](
		[FTBchCode] [varchar](20) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTXshRefDocNo] [varchar](20) NOT NULL,
		[FTXshRefType] [varchar](1) NOT NULL,
		[FTXshRefKey] [varchar](10) NULL,
		[FDXshRefDocDate] [datetime] NULL,
	 CONSTRAINT [PK_TPSTSalHDDocRef] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FTXshRefDocNo] ASC,
		[FTXshRefType] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalHDDocRef', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทการอ้างอิงเอกสาร 1: อ้างอิงถึง(ภายใน),2:ถูกอ้างอิง(ภายใน),3: อ้างอิง ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'กรณีType เดียวกันมีรายการมากกว่า 1 กลุ่ม /กำหนด Key เองได้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefKey'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTSalHDDocRef', @level2type=N'COLUMN',@level2name=N'FDXshRefDocDate'
END
GO
IF OBJECT_ID(N'TPSTTaxHDDocRef') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSTTaxHDDocRef](
		[FTBchCode] [varchar](20) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTXshRefDocNo] [varchar](20) NOT NULL,
		[FTXshRefType] [varchar](1) NOT NULL,
		[FTXshRefKey] [varchar](10) NULL,
		[FDXshRefDocDate] [datetime] NULL,
	 CONSTRAINT [PK_TPSTTaxHDDocRef] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FTXshRefDocNo] ASC,
		[FTXshRefType] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทการอ้างอิงเอกสาร 1: อ้างอิงถึง(ภายใน),2:ถูกอ้างอิง(ภายใน),3: อ้างอิง ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'กรณีType เดียวกันมีรายการมากกว่า 1 กลุ่ม /กำหนด Key เองได้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefKey'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FDXshRefDocDate'
END
GO
IF OBJECT_ID(N'TPSTWhTaxAddress_L') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSTWhTaxAddress_L](
		[FTAddTaxNo] [varchar](20) NOT NULL,
		[FNLngID] [bigint] NOT NULL,
		[FNAddSeqNo] [bigint] IDENTITY(1,1) NOT NULL,
		[FTCstCode] [varchar](20) NULL,
		[FTAddName] [varchar](200) NULL,
		[FTAddRmk] [varchar](200) NULL,
		[FTAddCountry] [varchar](100) NULL,
		[FTAreCode] [varchar](5) NULL,
		[FTZneCode] [varchar](30) NULL,
		[FTAddVersion] [varchar](1) NULL,
		[FTAddV1No] [varchar](30) NULL,
		[FTAddV1Soi] [varchar](30) NULL,
		[FTAddV1Village] [varchar](70) NULL,
		[FTAddV1Road] [varchar](30) NULL,
		[FTAddV1SubDist] [varchar](30) NULL,
		[FTAddV1DstCode] [varchar](5) NULL,
		[FTAddV1PvnCode] [varchar](5) NULL,
		[FTAddV1PostCode] [varchar](5) NULL,
		[FTAddV2Desc1] [varchar](255) NULL,
		[FTAddV2Desc2] [varchar](255) NULL,
		[FTAddWebsite] [varchar](200) NULL,
		[FTAddLongitude] [varchar](50) NULL,
		[FTAddLatitude] [varchar](50) NULL,
		[FTAddStaBusiness] [varchar](1) NULL,
		[FTAddStaHQ] [varchar](1) NULL,
		[FTAddStaBchCode] [varchar](5) NULL,
		[FTAddTel] [varchar](50) NULL,
		[FTAddFax] [varchar](50) NULL,
		[FTAddRefNo] [varchar](20) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TPSTWhTaxAddress_L] PRIMARY KEY CLUSTERED 
	(
		[FTAddTaxNo] ASC,
		[FNLngID] ASC,
		[FNAddSeqNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขประจำตัวผู้เสียภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddTaxNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสภาษา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FNLngID'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(AUTONUMBER)ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FNAddSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสลูกค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTCstCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddRmk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เก็บข้อมูลประเทศ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddCountry'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสเขต/ภูมิภาค' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAreCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสโซน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTZneCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:ใช้งานแบบแยก 2:ใช้งานแบบรวม' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddVersion'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'บ้านเลขที่' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV1No'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ซอย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV1Soi'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมู่บ้าน/อาคาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV1Village'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ถนน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV1Road'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ตำบล/แขวง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV1SubDist'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสอำเภอ/เขต' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV1DstCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสจังหวัด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV1PvnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสไปรษณีย์' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV1PostCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ทีอยู่1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV2Desc1'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ทีอยู่2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddV2Desc2'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'website address (Url)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddWebsite'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ตำแหน่งบนแผนที่ แนวตั้ง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddLongitude'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ตำแหน่งบนแผนที่ แนวนอน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddLatitude'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทธุระกิจ 1: นิติบุคคล, 2:บุคคลธรรมดา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddStaBusiness'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานประกอบการ 1: สำนักงานใหญ่ 2:สาขา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddStaHQ'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddStaBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เบอร์โทรศัพฑ์' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddTel'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เบอร์โทรสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddFax'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส/ลำดับ อ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTAddRefNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxAddress_L', @level2type=N'COLUMN',@level2name=N'FTCreateBy'
END
GO
IF OBJECT_ID(N'TPSTWhTaxDT') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSTWhTaxDT](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FNXsdSeqNo] [int] NOT NULL,
		[FTPdtCode] [varchar](20) NULL,
		[FTXsdPdtName] [varchar](100) NULL,
		[FTXsdBarCode] [varchar](25) NULL,
		[FTPunCode] [varchar](5) NULL,
		[FTPunName] [varchar](50) NULL,
		[FCXsdFactor] [numeric](18, 4) NULL,
		[FCXsdQty] [numeric](18, 4) NULL,
		[FCXsdQtyAll] [numeric](18, 4) NULL,
		[FTXsdVatType] [varchar](1) NULL,
		[FTVatCode] [varchar](5) NULL,
		[FCXsdVatRate] [numeric](18, 4) NULL,
		[FTXsdSaleType] [varchar](1) NULL,
		[FCXsdSetPrice] [numeric](18, 4) NULL,
		[FTXsdWhType] [varchar](1) NULL,
		[FCXsdNet] [numeric](18, 4) NULL,
		[FCXsdVat] [numeric](18, 4) NULL,
		[FCXsdVatable] [numeric](18, 4) NULL,
		[FTXsdWhtCode] [varchar](5) NULL,
		[FCXsdWhtRate] [numeric](18, 4) NULL,
		[FCXsdWhtAmt] [numeric](18, 4) NULL,
		[FTXsdRmk] [varchar](200) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TPSTWhTaxDT] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FNXsdSeqNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FNXsdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTPdtCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTXsdPdtName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'บาร์โค้ด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTXsdBarCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสหน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTPunCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อหน่วยสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTPunName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราส่วนต่อหน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdFactor'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนชื้น ตาม หน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdQty'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนรวมหน่วยเล็กสุด (FCXpdQty*FCXpdFactor)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdQtyAll'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทภาษี 1:มีภาษี, 2:ไม่มีภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTXsdVatType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสภาษี ณ. ซื้อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTVatCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราภาษี ณ. ซื้อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdVatRate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ใช้ราคาขาย 1:บังคับ, 2:แก้ไข, 3:เครื่องชั่ง,4: นน.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTXsdSaleType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ราคาซื้อ ตาม หน่วย * อัตราแลกเปลี่ยน(HD.FCXphRteFac)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdSetPrice'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทการหักภาษี ณ ที่จ่าย อ้างอิงจาก TSysConfig ตาม AD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTXsdWhType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าสุทธิก่อนท้ายบิล' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdNet'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าภาษี IN: NetAfHD-((NetAfHD*100)/(100+VatRate)) ,EX: ((NetAfHD*(100+VatRate))/100)-NetAfHD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdVat'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าแยกภาษี (NetAfHD-FCXpdVat)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdVatable'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส ภาษี ณ. ที่จ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTXsdWhtCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราภาษี ณ. ที่จ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdWhtRate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าภาษี ณ. ที่จ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FCXsdWhtAmt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTXsdRmk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxDT', @level2type=N'COLUMN',@level2name=N'FTCreateBy'
END
GO
IF OBJECT_ID(N'TPSTWhTaxHD') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSTWhTaxHD](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FDXshDocDate] [datetime] NULL,
		[FTXshCshOrCrd] [varchar](1) NULL,
		[FTXshVATInOrEx] [varchar](1) NULL,
		[FTPosCode] [varchar](5) NULL,
		[FTShfCode] [varchar](20) NULL,
		[FTUsrCode] [varchar](20) NULL,
		[FTXshApvCode] [varchar](20) NULL,
		[FTCstCode] [varchar](20) NULL,
		[FTXshRefExt] [varchar](20) NULL,
		[FDXshRefExtDate] [datetime] NULL,
		[FTXshRefInt] [varchar](20) NULL,
		[FDXshRefIntDate] [datetime] NULL,
		[FNXshDocPrint] [int] NULL,
		[FTRteCode] [varchar](5) NULL,
		[FCXshTotal] [numeric](18, 4) NULL,
		[FCXshVat] [numeric](18, 4) NULL,
		[FCXshVatable] [numeric](18, 4) NULL,
		[FCXshWpTax] [numeric](18, 4) NULL,
		[FCXshGrand] [numeric](18, 4) NULL,
		[FTXshGndText] [varchar](200) NULL,
		[FTXshRmk] [varchar](200) NULL,
		[FTXshStaDoc] [varchar](1) NULL,
		[FTXshStaApv] [varchar](1) NULL,
		[FNXshStaDocAct] [int] NULL,
		[FNXshStaRef] [int] NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TPSTWhTaxHD] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร  Def : XYYPOS-1234567 Gen ตาม TCNTAuto' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่/เวลา เอกสาร dd/mm/yyyy H:mm:ss' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FDXshDocDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สด/เครดิต 1:สด 2:credit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshCshOrCrd'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ภาษีมูลค่าเพิ่ม 1:รวมใน, 2:แยกนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshVATInOrEx'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เครื่องจุดขาย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTPosCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รอบ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTShfCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'พนักงาน Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTUsrCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้อนุมัติ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshApvCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลูกค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTCstCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง เลขที่เอกสาร ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshRefExt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง วันที่เอกสาร ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FDXshRefExtDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง เลขที่เอกสาร ภายใน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshRefInt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง วันที่เอกสาร ภายใน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FDXshRefIntDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนครั้งที่พิมพ์' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FNXshDocPrint'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสกุลเงิน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTRteCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FCXshTotal'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FCXshVat'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดแยกภาษี (FCXshAmtV-FCXshVat)+FCXshAmtNV' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FCXshVatable'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ภาษีหัก ณ ที่จ่าย SUM(FCXsdWhtAmt)  /Key In' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FCXshWpTax'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม FCXshAmtV+FCXshAmtNV+FCXshRnd' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FCXshGrand'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ข้อความ ยอดรวมสุทธิ(FCXphGrand)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshGndText'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshRmk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ เอกสาร  1:สมบูรณ์, 2:ไม่สมบูรณ์, 3:ยกเลิก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshStaDoc'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTXshStaApv'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ เคลื่อนไหว 0:NonActive, 1:Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FNXshStaDocAct'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ อ้างอิง 0:ไม่เคยอ้างอิง, 1:อ้างอิงบางส่วน, 2:อ้างอิงหมดแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FNXshStaRef'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHD', @level2type=N'COLUMN',@level2name=N'FTCreateBy'
END
GO
IF OBJECT_ID(N'TPSTWhTaxHDCst') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSTWhTaxHDCst](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTXshCardID] [varchar](20) NULL,
		[FTXshCstTel] [varchar](20) NULL,
		[FTXshCstName] [varchar](200) NULL,
		[FTXshCardNo] [varchar](20) NULL,
		[FNXshCrTerm] [int] NULL,
		[FDXshDueDate] [datetime] NULL,
		[FDXshBillDue] [datetime] NULL,
		[FTXshCtrName] [varchar](100) NULL,
		[FDXshTnfDate] [datetime] NULL,
		[FTXshRefTnfID] [varchar](20) NULL,
		[FTXshAddrShip] [varchar](20) NULL,
		[FTXshAddrTax] [varchar](20) NULL,
	 CONSTRAINT [PK_TPSTWhTaxHDCst] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่บัตรประจำตัวประชาชน/Passport' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCardID'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เบอร์โทรศัพท์ลูกค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCstTel'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อนามสกุลลูกค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCstName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขบัตรสมาชิก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCardNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ระยะเครดิต' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FNXshCrTerm'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ครบกำหนด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FDXshDueDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่จะรับ/วางบิล' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FDXshBillDue'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อผู้ติดต่อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCtrName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ส่งของ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FDXshTnfDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่ ใบขนส่ง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTXshRefTnfID'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ที่อยู่ส่งของ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTXshAddrShip'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ที่อยู่ใบกำกับภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDCst', @level2type=N'COLUMN',@level2name=N'FTXshAddrTax'
END
GO
IF OBJECT_ID(N'TPSTWhTaxHDDocRef') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSTWhTaxHDDocRef](
		[FTBchCode] [varchar](20) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTXshRefDocNo] [varchar](20) NOT NULL,
		[FTXshRefType] [varchar](1) NOT NULL,
		[FTXshRefKey] [varchar](10) NULL,
		[FDXshRefDocDate] [datetime] NULL,
	 CONSTRAINT [PK_TPSTWhTaxHDDocRef] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FTXshRefDocNo] ASC,
		[FTXshRefType] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทการอ้างอิงเอกสาร 1: อ้างอิงถึง(ภายใน),2:ถูกอ้างอิง(ภายใน),3: อ้างอิง ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'กรณีType เดียวกันมีรายการมากกว่า 1 กลุ่ม /กำหนด Key เองได้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefKey'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTWhTaxHDDocRef', @level2type=N'COLUMN',@level2name=N'FDXshRefDocDate'
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvRefExt') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvRefExt VARCHAR(5)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvRefDoc') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvRefDoc VARCHAR(20)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvRefEdc') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvRefEdc VARCHAR(5)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FNRcvQtySlip') BEGIN
	ALTER TABLE TFNMRcv ADD FNRcvQtySlip bigint
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FNRcvQtyCopy') BEGIN
	ALTER TABLE TFNMRcv ADD FNRcvQtyCopy bigint
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FCRcvPayMin') BEGIN
	ALTER TABLE TFNMRcv ADD FCRcvPayMin decimal(18,4)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FCRcvPayMax') BEGIN
	ALTER TABLE TFNMRcv ADD FCRcvPayMax decimal(18,4)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaAlwDrawer') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaAlwDrawer VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaReason') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaReason VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaCshOrCrd') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaCshOrCrd VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaReqSign') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaReqSign VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaAlwAccPoint') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaAlwAccPoint VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvRefID') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvRefID VARCHAR(30)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMRcv' AND COLUMN_NAME = 'FTRcvStaShwSum') BEGIN
	ALTER TABLE TFNMRcv ADD FTRcvStaShwSum VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalDT' AND COLUMN_NAME = 'FTWahCode') BEGIN
	ALTER TABLE TPSTSalDT ADD FTWahCode VARCHAR(5)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalDTDis' AND COLUMN_NAME = 'FTXddRmk') BEGIN
	ALTER TABLE TPSTSalDTDis ADD FTXddRmk VARCHAR(200)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTTaxDTSN' AND COLUMN_NAME = 'FCXsdQty') BEGIN
	ALTER TABLE TPSTTaxDTSN ADD FCXsdQty DECIMAL(18,4)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTCouponHDTmp' AND COLUMN_NAME = 'FTCphRefInt') BEGIN
	ALTER TABLE TPSTCouponHDTmp ADD FTCphRefInt VARCHAR(20)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTCouponHDTmp' AND COLUMN_NAME = 'FTCphFmtPrefix') BEGIN
	ALTER TABLE TPSTCouponHDTmp ADD FTCphFmtPrefix VARCHAR(10)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTCouponHDTmp' AND COLUMN_NAME = 'FNCphFmtLen') BEGIN
	ALTER TABLE TPSTCouponHDTmp ADD FNCphFmtLen BIGINT
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHD' AND COLUMN_NAME = 'FTXshDisChgTxt') BEGIN
	ALTER TABLE TPSTSalHD ALTER COLUMN FTXshDisChgTxt VARCHAR(250)
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTTaxHD' AND COLUMN_NAME = 'FTXshDisChgTxt') BEGIN
	ALTER TABLE TPSTTaxHD ALTER COLUMN FTXshDisChgTxt VARCHAR(250)
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTTaxDTSN' AND COLUMN_NAME = 'FTPdtBatchID') BEGIN
	ALTER TABLE TPSTTaxDTSN ALTER COLUMN FTPdtBatchID VARCHAR(20) NOT NULL
END
GO
UPDATE TPSTTaxDTSN SET FTPdtBatchID = '' WHERE FTPdtBatchID IS NULL
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTTaxDTSN' AND COLUMN_NAME = 'FTPdtBatchID') BEGIN
    UPDATE TPSTTaxDTSN SET FTPdtBatchID = '' WHERE FTPdtBatchID IS NULL
    ALTER TABLE TPSTTaxDTSN ALTER COLUMN FTPdtBatchID VARCHAR(20) NOT NULL

    DECLARE @tConstraint VARCHAR(30) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TPSTTaxDTSN' and type_desc LIKE '%CONSTRAINT')
    DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TPSTTaxDTSN DROP CONSTRAINT '+@tConstraint
    EXECUTE sp_executesql @tSql
    ALTER TABLE TPSTTaxDTSN ADD PRIMARY KEY(FTBchCode,FTXshDocNo,FNXsdSeqNo,FTPdtSerial,FTPdtBatchID)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TSysEdc' AND COLUMN_NAME = 'FTSedFmt') BEGIN
	ALTER TABLE TSysEdc ADD FTSedFmt VARCHAR(100)
END
GO
IF OBJECT_ID(N'TCNSLogClient') IS NULL BEGIN
	CREATE TABLE [dbo].[TCNSLogClient](
		[FNLogCode] [bigint] NOT NULL,
		[FTAgnCode] [varchar](10) NULL,
		[FTBchCode] [varchar](30) NULL,
		[FTPosCode] [varchar](20) NULL,
		[FTShfCode] [varchar](50) NULL,
		[FTAppCode] [varchar](10) NULL,
		[FTMnuCodeRef] [varchar](30) NULL,
		[FTMnuName] [varchar](255) NULL,
		[FTPrcCodeRef] [varchar](255) NULL,
		[FTPrcName] [varchar](255) NULL,
		[FTLogType] [varchar](30) NULL,
		[FTLogLevel] [varchar](30) NULL,
		[FNLogRefCode] [bigint] NULL,
		[FTLogDescription] [varchar](255) NULL,
		[FDLogDate] [datetime] NULL,
		[FTLogStaSync] [varchar](1) NULL,
		[FTUsrCode] [varchar](20) NULL,
		[FTUsrApvCode] [varchar](20) NULL,
	 CONSTRAINT [PK_TCNSLogClient] PRIMARY KEY CLUSTERED 
	(
		[FNLogCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Log' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FNLogCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสตัวแทนขาย / แฟรนไซส์' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสจุดขาย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTPosCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสรอบการขาย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTShfCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Application' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTAppCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสอ้างอิงเมนู' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTMnuCodeRef'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื้อเมนู' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTMnuName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสอ้างอิงหน้าจอ/Function/Process' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTPrcCodeRef'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อหน้าจอ/ฟังก์ชั่น/Process' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTPrcName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภท Log ( Information,Error,Event,Warning)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTLogType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ระดับ Log  (Critical,High,Medium,Low)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTLogLevel'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสอ้างอิง Log เช่น 500,800,404' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FNLogRefCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รายละเอียด Log' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTLogDescription'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ Log' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FDLogDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ว่าง/NULL : ยังไม่ Sync , 1 : รอ Sync , 2 : Sync แล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTLogStaSync'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ใช้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTUsrCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้อนุมัติ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogClient', @level2type=N'COLUMN',@level2name=N'FTUsrApvCode'
END
GO
IF OBJECT_ID(N'TCNSLogPurge') IS NULL BEGIN
	CREATE TABLE [dbo].[TCNSLogPurge](
		[FNLogCode] [bigint] NOT NULL,
		[FTAgnCode] [varchar](10) NULL,
		[FTBchCode] [varchar](30) NULL,
		[FTPosCode] [varchar](20) NULL,
		[FTShfCode] [varchar](50) NULL,
		[FTAppCode] [varchar](30) NULL,
		[FTMnuCodeRef] [varchar](30) NULL,
		[FTMnuName] [varchar](255) NULL,
		[FTPrcCodeRef] [varchar](255) NULL,
		[FTPrcName] [varchar](255) NULL,
		[FTLogType] [varchar](30) NULL,
		[FTLogLevel] [varchar](30) NULL,
		[FNLogRefCode] [bigint] NULL,
		[FTLogDescription] [varchar](255) NULL,
		[FDLogDate] [datetime] NULL,
		[FTUsrCode] [varchar](20) NULL,
		[FTUsrApvCode] [varchar](20) NULL,
	 CONSTRAINT [PK_TCNSLogPurge] PRIMARY KEY CLUSTERED 
	(
		[FNLogCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Log' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FNLogCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสตัวแทนขาย / แฟรนไซส์' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสจุดขาย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTPosCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสรอบการขาย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTShfCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Application' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTAppCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสอ้างอิงเมนู' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTMnuCodeRef'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อเมนู' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTMnuName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสอ้างอิงหน้าจอ/Function/Process' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTPrcCodeRef'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อหน้าจอ/ฟังก์ชั่น/Process' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTPrcName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภท Log (Fix : Error)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTLogType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ระดับ Log  (Critical,High,Medium,Low)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTLogLevel'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสอ้างอิง Log เช่น 500,800,404' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FNLogRefCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รายละเอียด Log' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTLogDescription'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ Log' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FDLogDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ใช้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTUsrCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้อนุมัติ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNSLogPurge', @level2type=N'COLUMN',@level2name=N'FTUsrApvCode'
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHD' AND COLUMN_NAME = 'FTXshRefTax') BEGIN
	ALTER TABLE TPSTSalHD ADD FTXshRefTax VARCHAR(50)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHD' AND COLUMN_NAME = 'FTXshStaETax') BEGIN
	ALTER TABLE TPSTSalHD ADD FTXshStaETax VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHD' AND COLUMN_NAME = 'FTXshStaPrcDoc') BEGIN
	ALTER TABLE TPSTSalHD ADD FTXshStaPrcDoc VARCHAR(2)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHD' AND COLUMN_NAME = 'FTXshStaDelMQ') BEGIN
	ALTER TABLE TPSTSalHD ADD FTXshStaDelMQ VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHD' AND COLUMN_NAME = 'FTXshETaxStatus') BEGIN
	ALTER TABLE TPSTSalHD ADD FTXshETaxStatus VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHDCst' AND COLUMN_NAME = 'FTXshCourier') BEGIN
	ALTER TABLE TPSTSalHDCst ADD FTXshCourier VARCHAR(100)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHDCst' AND COLUMN_NAME = 'FTXshCourseID') BEGIN
	ALTER TABLE TPSTSalHDCst ADD FTXshCourseID VARCHAR(50)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHDCst' AND COLUMN_NAME = 'FTXshCstRef') BEGIN
	ALTER TABLE TPSTSalHDCst ADD FTXshCstRef VARCHAR(50)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPSTSalHDCst' AND COLUMN_NAME = 'FTXshCstEmail') BEGIN
	ALTER TABLE TPSTSalHDCst ADD FTXshCstEmail VARCHAR(100)
END
GO
IF OBJECT_ID(N'TPSMPdtSet') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSMPdtSet](
		[FTPdtCode] [varchar](20) NOT NULL,
		[FTPdtCodeSet] [varchar](20) NOT NULL,
		[FTPdtName] [varchar](100) NULL,
		[FTPunCode] [varchar](5) NULL,
		[FCPstQty] [numeric](18, 4) NULL,
		[FCPdtPrice] [numeric](18, 4) NULL,
	 CONSTRAINT [PK_TPSMPdtSet] PRIMARY KEY CLUSTERED 
	(
		[FTPdtCode] ASC,
		[FTPdtCodeSet] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสินค้าแม่' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSMPdtSet', @level2type=N'COLUMN',@level2name=N'FTPdtCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสินค้าลูกค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSMPdtSet', @level2type=N'COLUMN',@level2name=N'FTPdtCodeSet'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSMPdtSet', @level2type=N'COLUMN',@level2name=N'FTPdtName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสหน่วยสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSMPdtSet', @level2type=N'COLUMN',@level2name=N'FTPunCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนสินค้าต่อชุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSMPdtSet', @level2type=N'COLUMN',@level2name=N'FCPstQty'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ราคาสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSMPdtSet', @level2type=N'COLUMN',@level2name=N'FCPdtPrice'
END
GO
IF OBJECT_ID(N'TCNTPdtTbiDTFhn') IS NULL BEGIN
	CREATE TABLE [dbo].[TCNTPdtTbiDTFhn](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXthDocNo] [varchar](20) NOT NULL,
		[FNXtdSeqNo] [int] NOT NULL,
		[FTPdtCode] [varchar](20) NOT NULL,
		[FTFhnRefCode] [varchar](50) NOT NULL,
		[FCXtdQty] [numeric](18, 4) NULL,
	 CONSTRAINT [PK_TCNTPdtTbiDTFhn] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXthDocNo] ASC,
		[FNXtdSeqNo] ASC,
		[FTPdtCode] ASC,
		[FTFhnRefCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTbiDTFhn', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTbiDTFhn', @level2type=N'COLUMN',@level2name=N'FTXthDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTbiDTFhn', @level2type=N'COLUMN',@level2name=N'FNXtdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTbiDTFhn', @level2type=N'COLUMN',@level2name=N'FTPdtCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสควบคุมสต็อกสินค้า (SEASON+MODEL+COLOR+SIZE)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTbiDTFhn', @level2type=N'COLUMN',@level2name=N'FTFhnRefCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนชื้น ตาม หน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTbiDTFhn', @level2type=N'COLUMN',@level2name=N'FCXtdQty'
END
GO
IF OBJECT_ID(N'TCNTPdtTboDTFhn') IS NULL BEGIN
	CREATE TABLE [dbo].[TCNTPdtTboDTFhn](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXthDocNo] [varchar](20) NOT NULL,
		[FNXtdSeqNo] [int] NOT NULL,
		[FTPdtCode] [varchar](20) NOT NULL,
		[FTFhnRefCode] [varchar](50) NOT NULL,
		[FCXtdQty] [numeric](18, 4) NULL,
	 CONSTRAINT [PK_TCNTPdtTboDTFhn] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXthDocNo] ASC,
		[FNXtdSeqNo] ASC,
		[FTPdtCode] ASC,
		[FTFhnRefCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTboDTFhn', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTboDTFhn', @level2type=N'COLUMN',@level2name=N'FTXthDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTboDTFhn', @level2type=N'COLUMN',@level2name=N'FNXtdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTboDTFhn', @level2type=N'COLUMN',@level2name=N'FTPdtCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสควบคุมสต็อกสินค้า (SEASON+MODEL+COLOR+SIZE)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTboDTFhn', @level2type=N'COLUMN',@level2name=N'FTFhnRefCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนชื้น ตาม หน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNTPdtTboDTFhn', @level2type=N'COLUMN',@level2name=N'FCXtdQty'

END
GO
IF OBJECT_ID(N'TAPTPdDT') IS NULL BEGIN
	CREATE TABLE [dbo].[TAPTPdDT](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXphDocNo] [varchar](20) NOT NULL,
		[FNXpdSeqNo] [int] NOT NULL,
		[FTPdtCode] [varchar](20) NULL,
		[FTXpdPdtName] [varchar](100) NULL,
		[FTPunCode] [varchar](5) NULL,
		[FTPunName] [varchar](50) NULL,
		[FCXpdFactor] [numeric](18, 4) NULL,
		[FTXpdBarCode] [varchar](25) NULL,
		[FTSrnCode] [varchar](50) NULL,
		[FTXpdVatType] [varchar](1) NULL,
		[FTVatCode] [varchar](5) NULL,
		[FCXpdVatRate] [numeric](18, 4) NULL,
		[FTXpdSaleType] [varchar](1) NULL,
		[FCXpdSalePrice] [numeric](18, 4) NULL,
		[FCXpdQty] [numeric](18, 4) NULL,
		[FCXpdQtyAll] [numeric](18, 4) NULL,
		[FCXpdSetPrice] [numeric](18, 4) NULL,
		[FCXpdAmtB4DisChg] [numeric](18, 4) NULL,
		[FTXpdDisChgTxt] [varchar](50) NULL,
		[FCXpdDis] [numeric](18, 4) NULL,
		[FCXpdChg] [numeric](18, 4) NULL,
		[FCXpdNet] [numeric](18, 4) NULL,
		[FCXpdNetAfHD] [numeric](18, 4) NULL,
		[FCXpdVat] [numeric](18, 4) NULL,
		[FCXpdVatable] [numeric](18, 4) NULL,
		[FCXpdWhtAmt] [numeric](18, 4) NULL,
		[FTXpdWhtCode] [varchar](5) NULL,
		[FCXpdWhtRate] [numeric](18, 4) NULL,
		[FCXpdCostIn] [numeric](18, 4) NULL,
		[FCXpdCostEx] [numeric](18, 4) NULL,
		[FCXpdQtyLef] [numeric](18, 4) NULL,
		[FCXpdQtyRfn] [numeric](18, 4) NULL,
		[FTXpdStaPrcStk] [varchar](1) NULL,
		[FTXpdStaAlwDis] [varchar](1) NULL,
		[FNXpdPdtLevel] [int] NULL,
		[FTXpdPdtParent] [varchar](20) NULL,
		[FCXpdQtySet] [numeric](18, 4) NULL,
		[FTPdtStaSet] [varchar](1) NULL,
		[FTXpdRmk] [varchar](200) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TAPTPdDT] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXphDocNo] ASC,
		[FNXpdSeqNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AdaPos5_AP_Filegroups]
	) ON [AdaPos5_AP_Filegroups]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXphDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FNXpdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTPdtCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdPdtName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสหน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTPunCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อหน่วยสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTPunName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราส่วนต่อหน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdFactor'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'บาร์โค้ด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdBarCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส ซีเรียล' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTSrnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทภาษี 1:มีภาษี, 2:ไม่มีภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdVatType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสภาษี ณ. ซื้อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTVatCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราภาษี ณ. ซื้อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdVatRate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ใช้ราคาขาย 1:บังคับ, 2:แก้ไข, 3:เครื่องชั่ง,4: นน.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdSaleType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จากราคาซื้อ ตาม หน่วย * อัตราแลกเปลี่ยน(HD.FCXphRteFac)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdSalePrice'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนชื้น ตาม หน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdQty'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนรวมหน่วยเล็กสุด (FCXpdQty*FCXpdFactor)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdQtyAll'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ราคาซื้อ ตาม หน่วย * อัตราแลกเปลี่ยน(HD.FCXphRteFac)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdSetPrice'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่ารวมก่อนลด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdAmtB4DisChg'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ข้อความมูลค่าลดชาร์จ เช่น 5 หรือ 5%' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdDisChgTxt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่ารวมส่วนลด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdDis'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่ารวมส่วนชาร์จ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdChg'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าสุทธิก่อนท้ายบิล (FCXpdAmt-FCXpdDis+FCXpdChg)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdNet'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าสุทธิหลังท้ายบิล (Net-SUM(Disท้ายบิล))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdNetAfHD'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าภาษี IN: NetAfHD-((NetAfHD*100)/(100+VatRate)) ,EX: ((NetAfHD*(100+VatRate))/100)-NetAfHD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdVat'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าแยกภาษี (NetAfHD-FCXpdVat)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdVatable'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าภาษี ณ. ที่จ่าย (FCXpdVatable* FCXpdWhtRate%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdWhtAmt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส ภาษี ณ. ที่จ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdWhtCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราภาษี ณ. ที่จ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdWhtRate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ต้นทุนรวมใน (FCXpdVat+FCXpdVatable)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdCostIn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ต้นทุนแยกนอก (FCXpdVatable)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdCostEx'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนคงเหลือ ตามหน่วย (Default:FCXpdQty)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdQtyLef'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนคืนตามหน่วย (Default:0)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdQtyRfn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะตัดสต๊อก ว่าง:ยังไม่ทำ, 1:ทำแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdStaPrcStk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะอนุญาต ลด/ชาร์จ  1:อนุญาต , 2:ไม่อนุญาต' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdStaAlwDis'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ระดับสิน(ค้าชุด)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FNXpdPdtLevel'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสินค้าชุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdPdtParent'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนต่อชุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FCXpdQtySet'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ สินค้าชุด 1:ทั่วไป, 2:สินค้าประกอบ, 3:สินค้าชุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTPdtStaSet'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTXpdRmk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDT', @level2type=N'COLUMN',@level2name=N'FTCreateBy'

END
GO
IF OBJECT_ID(N'TAPTPdDTDis') IS NULL BEGIN
	CREATE TABLE [dbo].[TAPTPdDTDis](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXphDocNo] [varchar](20) NOT NULL,
		[FNXpdSeqNo] [int] NOT NULL,
		[FDXpdDateIns] [datetime] NOT NULL,
		[FNXpdStaDis] [int] NULL,
		[FTXpdDisChgTxt] [varchar](50) NULL,
		[FTXpdDisChgType] [varchar](10) NULL,
		[FCXpdNet] [numeric](18, 4) NULL,
		[FCXpdValue] [numeric](18, 4) NULL,
	 CONSTRAINT [PK_TAPTPdDTDis] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXphDocNo] ASC,
		[FNXpdSeqNo] ASC,
		[FDXpdDateIns] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AdaPos5_AP_Filegroups]
	) ON [AdaPos5_AP_Filegroups]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDTDis', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDTDis', @level2type=N'COLUMN',@level2name=N'FTXphDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDTDis', @level2type=N'COLUMN',@level2name=N'FNXpdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วัน/เวลาทำรายการ [dd/mm/yyyy H:mm:ss]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDTDis', @level2type=N'COLUMN',@level2name=N'FDXpdDateIns'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะส่วนลด 1: ลดรายการ ,2: ลดท้ายบิล' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDTDis', @level2type=N'COLUMN',@level2name=N'FNXpdStaDis'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ข้อความมูลค่าลดชาร์จ เช่น 5 หรือ 5%' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDTDis', @level2type=N'COLUMN',@level2name=N'FTXpdDisChgTxt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทลดชาร์จ 1:ลดบาท 2: ลด % 3: ชาร์จบาท 4: ชาร์จ %' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDTDis', @level2type=N'COLUMN',@level2name=N'FTXpdDisChgType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าสุทธิก่อนลดชาร์จ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDTDis', @level2type=N'COLUMN',@level2name=N'FCXpdNet'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดลด/ชาร์จ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdDTDis', @level2type=N'COLUMN',@level2name=N'FCXpdValue'
END
GO
IF OBJECT_ID(N'TAPTPdHD') IS NULL BEGIN
	CREATE TABLE [dbo].[TAPTPdHD](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXphDocNo] [varchar](20) NOT NULL,
		[FTShpCode] [varchar](5) NULL,
		[FNXphDocType] [int] NULL,
		[FDXphDocDate] [datetime] NULL,
		[FTXphCshOrCrd] [varchar](1) NULL,
		[FTXphVATInOrEx] [varchar](1) NULL,
		[FTDptCode] [varchar](5) NULL,
		[FTWahCode] [varchar](5) NULL,
		[FTUsrCode] [varchar](20) NULL,
		[FTXphApvCode] [varchar](20) NULL,
		[FTSplCode] [varchar](20) NULL,
		[FTXphRefExt] [varchar](20) NULL,
		[FDXphRefExtDate] [datetime] NULL,
		[FTXphRefInt] [varchar](20) NULL,
		[FDXphRefIntDate] [datetime] NULL,
		[FTXphRefAE] [varchar](20) NULL,
		[FNXphDocPrint] [int] NULL,
		[FTRteCode] [varchar](5) NULL,
		[FCXphRteFac] [numeric](18, 4) NULL,
		[FCXphTotal] [numeric](18, 4) NULL,
		[FCXphTotalNV] [numeric](18, 4) NULL,
		[FCXphTotalNoDis] [numeric](18, 4) NULL,
		[FCXphTotalB4DisChgV] [numeric](18, 4) NULL,
		[FCXphTotalB4DisChgNV] [numeric](18, 4) NULL,
		[FTXphDisChgTxt] [varchar](50) NULL,
		[FCXphDis] [numeric](18, 4) NULL,
		[FCXphChg] [numeric](18, 4) NULL,
		[FCXphTotalAfDisChgV] [numeric](18, 4) NULL,
		[FCXphTotalAfDisChgNV] [numeric](18, 4) NULL,
		[FCXphRefAEAmt] [numeric](18, 4) NULL,
		[FCXphAmtV] [numeric](18, 4) NULL,
		[FCXphAmtNV] [numeric](18, 4) NULL,
		[FCXphVat] [numeric](18, 4) NULL,
		[FCXphVatable] [numeric](18, 4) NULL,
		[FTXphWpCode] [varchar](5) NULL,
		[FCXphWpTax] [numeric](18, 4) NULL,
		[FCXphGrand] [numeric](18, 4) NULL,
		[FCXphRnd] [numeric](18, 4) NULL,
		[FTXphGndText] [varchar](200) NULL,
		[FCXphPaid] [numeric](18, 4) NULL,
		[FCXphLeft] [numeric](18, 4) NULL,
		[FTXphRmk] [varchar](200) NULL,
		[FTXphStaRefund] [varchar](1) NULL,
		[FTXphStaDoc] [varchar](1) NULL,
		[FTXphStaApv] [varchar](1) NULL,
		[FTXphStaDelMQ] [varchar](1) NULL,
		[FTXphStaPrcStk] [varchar](1) NULL,
		[FTXphStaPaid] [varchar](1) NULL,
		[FNXphStaDocAct] [int] NULL,
		[FNXphStaRef] [int] NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TAPTPdHD] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXphDocNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AdaPos5_AP_Filegroups]
	) ON [AdaPos5_AP_Filegroups]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร  Def : XYYPOS-1234567 Gen ตาม TCNTAuto' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ร้านค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTShpCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทเอกสาร ดูจาก ตาราง TSysDocType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FNXphDocType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่/เวลา เอกสาร dd/mm/yyyy H:mm:ss' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FDXphDocDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สด/เครดิต 1:สด 2:credit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphCshOrCrd'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ภาษีมูลค่าเพิ่ม 1:รวมใน, 2:แยกนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphVATInOrEx'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'แผนก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTDptCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'คลัง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTWahCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'พนักงาน Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTUsrCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้อนุมัติ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphApvCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้จำหน่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTSplCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง เลขที่เอกสาร ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphRefExt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง วันที่เอกสาร ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FDXphRefExtDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง เลขที่เอกสาร ภายใน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphRefInt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง วันที่เอกสาร ภายใน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FDXphRefIntDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างถึงเอกสาร มัดจำ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphRefAE'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนครั้งที่พิมพ์' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FNXphDocPrint'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสกุลเงิน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTRteCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราแลกเปลี่ยน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphRteFac'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphTotal'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมสินค้าไม่มีภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphTotalNV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมสินค้าห้ามลด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphTotalNoDis'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอมรวมสินค้าลดได้ และมีภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphTotalB4DisChgV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอมรวมสินค้าลดได้ และไม่มีภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphTotalB4DisChgNV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ข้อความมูลค่าลดชาร์จ เช่น 5 หรือ 5%' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphDisChgTxt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่ารวมส่วนลด SUM(HDis.FCXddDisVat+HDis.FCXddDisNoVat)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphDis'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่ารวมส่วนชาร์จ SUM(HDis.FCXddChgVat+HDis.FCXddChgNoVat)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphChg'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมหลังลด และมีภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphTotalAfDisChgV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมหลังลด และไม่มีภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphTotalAfDisChgNV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดมัดจำ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphRefAEAmt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมเฉพาะภาษี (FCXshTotal-FCXshTotalNV-(FCXshTotalB4DisChgV-FCXshTotalAfDisChgV))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphAmtV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมเฉพาะไม่มีภาษี (FCXshTotalNV-(FCXshTotalB4DisChgNV-FCXshTotalAfDisChgNV))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphAmtNV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphVat'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดแยกภาษี (FCXshAmtV-FCXshVat)+FCXshAmt์NV' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphVatable'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสอัตราภาษี ณ ที่จ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphWpCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ภาษีหัก ณ ที่จ่าย SUM(FCXpdWhtAmt)  /Key In' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphWpTax'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม FCXshAmtV+FCXshAmtNV+FCXshRnd' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphGrand'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดปัดเศษ (เมื่อชำระด้วยเงินสดเฉพาะขายปลีก)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphRnd'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ข้อความ ยอดรวมสุทธิ(FCXphGrand)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphGndText'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดจ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphPaid'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดค้าง Default: 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FCXphLeft'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphRmk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ การคืน 1:ไม่เคยคืน, 2:เคยคืน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphStaRefund'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ เอกสาร  1:สมบูรณ์, 2:ไม่สมบูรณ์, 3:ยกเลิก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphStaDoc'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphStaApv'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ ลบ MQ ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphStaDelMQ'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ ประมวลผลสต๊อก ว่าง หรือ Null:ยังไม่ทำ, 1:ทำแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphStaPrcStk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ รับ/จ่ายเงิน 1:ยังไม่จ่าย 2:บางส่วน, 3:ครบ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTXphStaPaid'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ เคลื่อนไหว 0:NonActive, 1:Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FNXphStaDocAct'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ อ้างอิง 0:ไม่เคยอ้างอิง, 1:อ้างอิงบางส่วน, 2:อ้างอิงหมดแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FNXphStaRef'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHD', @level2type=N'COLUMN',@level2name=N'FTCreateBy'
END
GO
IF OBJECT_ID(N'TAPTPdHDDis') IS NULL BEGIN
	CREATE TABLE [dbo].[TAPTPdHDDis](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXphDocNo] [varchar](20) NOT NULL,
		[FDXphDateIns] [datetime] NOT NULL,
		[FTXphDisChgTxt] [varchar](50) NULL,
		[FTXphDisChgType] [varchar](10) NULL,
		[FCXphTotalAfDisChg] [numeric](18, 4) NULL,
		[FCXphDisChg] [numeric](18, 4) NULL,
		[FCXphAmt] [numeric](18, 4) NULL,
	 CONSTRAINT [PK_TAPTPdHDDis] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXphDocNo] ASC,
		[FDXphDateIns] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [AdaPos5_AP_Filegroups]
	) ON [AdaPos5_AP_Filegroups]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHDDis', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHDDis', @level2type=N'COLUMN',@level2name=N'FTXphDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วัน/เวลาทำรายการ [dd/mm/yyyy H:mm:ss]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHDDis', @level2type=N'COLUMN',@level2name=N'FDXphDateIns'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ข้อความมูลค่าลดชาร์จ เช่น 5 หรือ 5%' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHDDis', @level2type=N'COLUMN',@level2name=N'FTXphDisChgTxt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทลดชาร์จ 1:ลดบาท 2: ลด % 3: ชาร์จบาท 4: ชาร์จ %' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHDDis', @level2type=N'COLUMN',@level2name=N'FTXphDisChgType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมหลังลด (FCXshTotalAfDisChgV+FCXshTotalAfDisChgNV)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHDDis', @level2type=N'COLUMN',@level2name=N'FCXphTotalAfDisChg'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดลด/ชาร์จ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHDDis', @level2type=N'COLUMN',@level2name=N'FCXphDisChg'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดลด/ชาร์จ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TAPTPdHDDis', @level2type=N'COLUMN',@level2name=N'FCXphAmt'

END
GO
IF OBJECT_ID(N'TFNTCrdTopUpFifo') IS NULL BEGIN
	CREATE TABLE [dbo].[TFNTCrdTopUpFifo](
		[FTCrdCode] [varchar](30) NOT NULL,
		[FDDateTime] [datetime] NOT NULL,
		[FCPmcAmtPay] [numeric](18, 4) NULL,
		[FCPmcAmtGet] [numeric](18, 4) NULL,
		[FCPmcAmtNot] [numeric](18, 4) NULL,
		[FCPmcNoRfnPay] [numeric](18, 4) NULL,
		[FCPmcNoRfnGet] [numeric](18, 4) NULL,
		[FCPmcAmtPayAvb] [numeric](18, 4) NULL,
		[FCPmcAmtGetAvb] [numeric](18, 4) NULL,
		[FCPmcAmtNotAvb] [numeric](18, 4) NULL,
		[FCPmcNoRfn] [numeric](18, 4) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TFNTCrdTopUpFifo] PRIMARY KEY CLUSTERED 
	(
		[FTCrdCode] ASC,
		[FDDateTime] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNTCrdShiftDT' AND COLUMN_NAME = 'FTPmhDocNo') BEGIN
	ALTER TABLE TFNTCrdShiftDT ADD FTPmhDocNo VARCHAR(20)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNTCrdTopUpPD' AND COLUMN_NAME = 'FNXpdQty') BEGIN
	ALTER TABLE TFNTCrdTopUpPD ADD FNXpdQty BIGINT
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMCstCredit' AND COLUMN_NAME = 'FCCstCrBuffer') BEGIN
	ALTER TABLE TCNMCstCredit ADD FCCstCrBuffer DECIMAL(18,4)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMCstCredit' AND COLUMN_NAME = 'FCCstCrBalExt') BEGIN
	ALTER TABLE TCNMCstCredit ADD FCCstCrBalExt DECIMAL(18,4)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyExpiredType') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyExpiredType VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyStaCrdReuse') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyStaCrdReuse VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyTAStaReset') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyTAStaReset VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNMCardType' AND COLUMN_NAME = 'FTCtyTAAlwReturn') BEGIN
	ALTER TABLE TFNMCardType ADD FTCtyTAAlwReturn VARCHAR(1)
END
GO
IF OBJECT_ID(N'TARTRcvDepositDT') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTRcvDepositDT](
		[FTBchCode] [varchar](20) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FNXsdSeqNo] [bigint] NOT NULL,
		[FTXsdName] [varchar](100) NULL,
		[FCXsdTotal] [numeric](18, 4) NULL,
		[FTXsdVatType] [varchar](1) NULL,
		[FTVatCode] [varchar](5) NULL,
		[FTVatRate] [float] NULL,
		[FCXsdVat] [numeric](18, 4) NULL,
		[FCXsdVatable] [numeric](18, 4) NULL,
		[FCXsdDeposit] [numeric](18, 4) NULL,
		[FTXsdRmk] [varchar](100) NULL,
	 CONSTRAINT [PK_TARTRcvDepositDT] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FNXsdSeqNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร  Def : XYYPOS-1234567 Gen ตาม TCNTAuto' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FNXsdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อรายการ เช่น ค่ามัดจำโช๊ค , SO20210000100001' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FTXsdName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'กรณีอ้างอิงเอกสาร คือ Grand  , กรณีไม่อ้างอิงคือยอดมัดจำปกติ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FCXsdTotal'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทภาษี 1:มีภาษี, 2:ไม่มีภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FTXsdVatType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสภาษี ณ. ซื้อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FTVatCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FTVatRate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าภาษี IN: FCXsdDeposit-((FCXsdDeposit*100)/(100+VatRate)) ,EX: ((FCXsdDeposit*(100+VatRate))/100)-FCXsdDeposit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FCXsdVat'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'มูลค่าแยกภาษี (FCXsdDeposit-FCXpdVat)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FCXsdVatable'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมเงินมัดจำ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FCXsdDeposit'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositDT', @level2type=N'COLUMN',@level2name=N'FTXsdRmk'

END
GO
IF OBJECT_ID(N'TARTRcvDepositHD') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTRcvDepositHD](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTShpCode] [varchar](5) NULL,
		[FNXshDocType] [int] NULL,
		[FDXshDocDate] [datetime] NULL,
		[FTXshCshOrCrd] [varchar](1) NULL,
		[FTXshVATInOrEx] [varchar](1) NULL,
		[FTDptCode] [varchar](5) NULL,
		[FTPosCode] [varchar](5) NULL,
		[FTShfCode] [varchar](20) NULL,
		[FNSdtSeqNo] [int] NULL,
		[FTUsrCode] [varchar](20) NULL,
		[FTSpnCode] [varchar](20) NULL,
		[FTXshApvCode] [varchar](20) NULL,
		[FTCstCode] [varchar](20) NULL,
		[FTXshDocVatFull] [varchar](20) NULL,
		[FTXshRefExt] [varchar](20) NULL,
		[FDXshRefExtDate] [datetime] NULL,
		[FTXshRefInt] [varchar](20) NULL,
		[FDXshRefIntDate] [datetime] NULL,
		[FNXshDocPrint] [int] NULL,
		[FTRteCode] [varchar](5) NULL,
		[FCXshRteFac] [numeric](18, 4) NULL,
		[FCXshTotal] [numeric](18, 4) NULL,
		[FCXshTotalNV] [numeric](18, 4) NULL,
		[FCXshTotalNoDis] [numeric](18, 4) NULL,
		[FCXshAmtV] [numeric](18, 4) NULL,
		[FCXshAmtNV] [numeric](18, 4) NULL,
		[FCXshVat] [numeric](18, 4) NULL,
		[FCXshVatable] [numeric](18, 4) NULL,
		[FCXshGrand] [numeric](18, 4) NULL,
		[FCXshRnd] [numeric](18, 4) NULL,
		[FTXshGndText] [varchar](200) NULL,
		[FCXshPaid] [numeric](18, 4) NULL,
		[FCXshLeft] [numeric](18, 4) NULL,
		[FTXshRmk] [varchar](200) NULL,
		[FTXshStaRefund] [varchar](1) NULL,
		[FTXshStaDoc] [varchar](1) NULL,
		[FTXshStaApv] [varchar](1) NULL,
		[FTXshStaPrcDoc] [varchar](255) NULL,
		[FTXshStaPaid] [varchar](1) NULL,
		[FNXshStaDocAct] [int] NULL,
		[FNXshStaRef] [int] NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TARTRcvDepositHD] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร  Def : XYYPOS-1234567 Gen ตาม TCNTAuto' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ร้านค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTShpCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทเอกสาร ดูจาก ตาราง TSysDocType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FNXshDocType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่/เวลา เอกสาร dd/mm/yyyy H:mm:ss' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FDXshDocDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สด/เครดิต 1:สด 2:credit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshCshOrCrd'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ภาษีมูลค่าเพิ่ม 1:รวมใน, 2:แยกนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshVATInOrEx'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'แผนก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTDptCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เครื่องจุดขาย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTPosCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รอบ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTShfCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับการ SignIn DT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FNSdtSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'พนักงาน Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTUsrCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'พนักงานขาย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTSpnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้อนุมัติ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshApvCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลูกค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTCstCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่ใบกำกับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshDocVatFull'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง เลขที่เอกสาร ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshRefExt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง วันที่เอกสาร ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FDXshRefExtDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง เลขที่เอกสาร ภายใน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshRefInt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อ้างอิง วันที่เอกสาร ภายใน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FDXshRefIntDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนครั้งที่พิมพ์' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FNXshDocPrint'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสกุลเงิน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTRteCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราแลกเปลี่ยน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshRteFac'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshTotal'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมสินค้าไม่มีภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshTotalNV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมสินค้าห้ามลด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshTotalNoDis'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมเฉพาะภาษี (FCXshTotal-FCXshTotalNV-(FCXshTotalB4DisChgV-FCXshTotalAfDisChgV))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshAmtV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมเฉพาะไม่มีภาษี (FCXshTotalNV-(FCXshTotalB4DisChgNV-FCXshTotalAfDisChgNV))' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshAmtNV'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshVat'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดแยกภาษี (FCXshAmtV-FCXshVat)+FCXshAmt์NV' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshVatable'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม FCXshAmtV+FCXshAmtNV+FCXshRnd' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshGrand'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดปัดเศษ (เมื่อชำระด้วยเงินสดเฉพาะขายปลีก)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshRnd'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ข้อความ ยอดรวมสุทธิ(FCXphGrand)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshGndText'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดจ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshPaid'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดค้าง Default: 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FCXshLeft'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshRmk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ การคืน 1:ไม่เคยคืน, 2:เคยคืน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshStaRefund'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ เอกสาร  1:สมบูรณ์, 2:ไม่สมบูรณ์, 3:ยกเลิก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshStaDoc'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshStaApv'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะอนุมัติ 1: อนุมัติแล้ว  ว่าง null ยังไม่อนุมัติ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshStaPrcDoc'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ รับ/จ่ายเงิน 1:ยังไม่จ่าย 2:บางส่วน, 3:ครบ ,4 :คืน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTXshStaPaid'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ เคลื่อนไหว 0:NonActive, 1:Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FNXshStaDocAct'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะ อ้างอิง 0:ไม่เคยอ้างอิง, 1:อ้างอิงบางส่วน, 2:อ้างอิงหมดแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FNXshStaRef'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHD', @level2type=N'COLUMN',@level2name=N'FTCreateBy'

END
GO
IF OBJECT_ID(N'TARTRcvDepositHDCst') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTRcvDepositHDCst](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTCstCode] [varchar](20) NULL,
		[FTXshCardID] [varchar](20) NULL,
		[FTXshCstName] [varchar](255) NULL,
		[FTXshCstTel] [varchar](255) NULL,
		[FTXshCardNo] [varchar](20) NULL,
		[FNXshCrTerm] [int] NULL,
		[FDXshDueDate] [datetime] NULL,
		[FDXshBillDue] [datetime] NULL,
		[FTXshCtrName] [varchar](100) NULL,
		[FDXshTnfDate] [datetime] NULL,
		[FTXshRefTnfID] [varchar](20) NULL,
		[FNXshAddrShip] [bigint] NULL,
		[FNXshAddrTax] [bigint] NULL,
	 CONSTRAINT [PK_TARTRcvDepositHDCst] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสลูกค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FTCstCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่บัตรประจำตัวประชาชน/Passport' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCardID'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อสมาชิก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCstName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เบอร์โทร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCstTel'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเลขบัตรสมาชิก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCardNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ระยะเครดิต' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FNXshCrTerm'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ครบกำหนด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FDXshDueDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่จะรับ/วางบิล' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FDXshBillDue'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อผู้ตืดต่อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCtrName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ส่งของ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FDXshTnfDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่ ใบขนส่ง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FTXshRefTnfID'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ที่อยู่ส่งของ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FNXshAddrShip'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ที่อยู่ใบกำกับภาษี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDCst', @level2type=N'COLUMN',@level2name=N'FNXshAddrTax'
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNTPdtStkCrd' AND COLUMN_NAME = 'FTStkSysType') BEGIN
	ALTER TABLE TCNTPdtStkCrd ADD FTStkSysType VARCHAR(1)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMPdtCostAvg' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	ALTER TABLE TCNMPdtCostAvg ADD FTAgnCode VARCHAR(10) NOT NULL DEFAULT('')
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMPdtCostAvg' AND COLUMN_NAME = 'FCPdtCostStd') BEGIN
	ALTER TABLE TCNMPdtCostAvg ADD FCPdtCostStd DECIMAL(18,4)
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMPdtCostAvg' AND COLUMN_NAME = 'FTAgnCode') BEGIN
    UPDATE TCNMPdtCostAvg SET FTAgnCode = '' WHERE FTAgnCode IS NULL
    ALTER TABLE TCNMPdtCostAvg ALTER COLUMN FTAgnCode VARCHAR(10) NOT NULL

    DECLARE @tConstraint VARCHAR(30) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TCNMPdtCostAvg' and type_desc LIKE '%CONSTRAINT')
    DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TCNMPdtCostAvg DROP CONSTRAINT '+@tConstraint
    EXECUTE sp_executesql @tSql
    ALTER TABLE TCNMPdtCostAvg ADD PRIMARY KEY(FTPdtCode,FTAgnCode)
END
GO
IF OBJECT_ID(N'TARTSpDT') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTSpDT](
		[FTAgnCode] [varchar](10) NOT NULL,
		[FTBchCode] [varchar](3) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FNXsdSeqNo] [bigint] NOT NULL,
		[FTXsdInvNo] [varchar](20) NOT NULL,
		[FNXsdInvType] [bigint] NULL,
		[FTXsdRefExt] [varchar](20) NULL,
		[FDXsdInvDate] [datetime] NULL,
		[FDXsdDueDate] [datetime] NULL,
		[FCXsdInvGrand] [numeric](18, 4) NULL,
		[FCXsdInvPaid] [numeric](18, 4) NULL,
		[FCXsdInvRem] [numeric](18, 4) NULL,
		[FCXsdInvPay] [numeric](18, 4) NULL,
		[FTXsdCtrCode] [varchar](20) NULL,
		[FTXsdStaInvB4] [varchar](1) NULL,
		[FTXsdStaInvNo] [varchar](1) NULL,
		[FNXsdLevel] [bigint] NULL,
		[FTXsdRmk] [varchar](200) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TARTSpDT] PRIMARY KEY CLUSTERED 
	(
		[FTAgnCode] ASC,
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FNXsdSeqNo] ASC,
		[FTXsdInvNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสบริษัทย่อย ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร XXYY-######' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FNXsdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่ใบรับ/วางบิล' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTXsdInvNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทเอกสาร 1:ใบขาย 2:ใบมัดจำ 3:ใบลดหนี้ 4:ใบเพิ่มหนี้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FNXsdInvType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)เลขที่ใบบิลอ้างอิง (D-Bill)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTXsdRefExt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ใบรับ/วางบิล (D-Bill)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FDXsdInvDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)วันที่ครบกำหนด (D-Bill)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FDXsdDueDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดเอกสาร (D-Inv-field)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FCXsdInvGrand'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดที่เคยชำระ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FCXsdInvPaid'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดคงเหลือ (ค้างชำระครั้งต่อไป)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FCXsdInvRem'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดจ่าย/รับชำระครั้งปัจจุบัน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FCXsdInvPay'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสลูกค้า/ผู้จำหน่าย (D-Bill)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTXsdCtrCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)สถานะ รับ/วางบิล 1:ไม่เคย,2:เคย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTXsdStaInvB4'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)สถานะ บิล 1:ใบบิล,2:ลดหนี้,3:เพิ่มหนี้,4:อื่นๆ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTXsdStaInvNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ระดับความลึก (Outline)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FNXsdLevel'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTXsdRmk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpDT', @level2type=N'COLUMN',@level2name=N'FTCreateBy'

END
GO
IF OBJECT_ID(N'TARTSpHD') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTSpHD](
		[FTAgnCode] [varchar](10) NOT NULL,
		[FTBchCode] [varchar](3) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FDXshDocDate] [datetime] NULL,
		[FTXshDocTime] [varchar](8) NULL,
		[FDXshDueDate] [datetime] NULL,
		[FTDptCode] [varchar](5) NULL,
		[FTUsrCode] [varchar](20) NULL,
		[FTSplCode] [varchar](20) NULL,
		[FTCstCode] [varchar](20) NULL,
		[FTPrdCode] [varchar](5) NULL,
		[FTXshApvCode] [varchar](20) NULL,
		[FTXshCtrName] [varchar](50) NULL,
		[FNXshDocPrint] [bigint] NULL,
		[FCXshTotal] [numeric](18, 4) NULL,
		[FCXshWht] [numeric](18, 4) NULL,
		[FCXshAfWht] [numeric](18, 4) NULL,
		[FCXshInterest] [numeric](18, 4) NULL,
		[FCXshDisc] [numeric](18, 4) NULL,
		[FCXshAfDisc] [numeric](18, 4) NULL,
		[FCXshAmt] [numeric](18, 4) NULL,
		[FCXshPay] [numeric](18, 4) NULL,
		[FCXshChgCredit] [numeric](18, 4) NULL,
		[FCXshGnd] [numeric](18, 4) NULL,
		[FTXshGndText] [varchar](200) NULL,
		[FCXshMnyCsh] [numeric](18, 4) NULL,
		[FCXshMnyChq] [numeric](18, 4) NULL,
		[FCXshMnyCrd] [numeric](18, 4) NULL,
		[FCXshMnyCtf] [numeric](18, 4) NULL,
		[FCXshMnyCpn] [numeric](18, 4) NULL,
		[FCXshMnyCls] [numeric](18, 4) NULL,
		[FCXshMnyCxx] [numeric](18, 4) NULL,
		[FTXshStaPaid] [varchar](1) NULL,
		[FTXshStaDoc] [varchar](1) NULL,
		[FTXshStaPrcDoc] [varchar](1) NULL,
		[FTXshRmk] [varchar](200) NULL,
		[FTXshCond] [varchar](100) NULL,
		[FNXshStaDocAct] [int] NULL,
		[FNXshStaRef] [int] NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TARTSpHD] PRIMARY KEY CLUSTERED 
	(
		[FTAgnCode] ASC,
		[FTBchCode] ASC,
		[FTXshDocNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสบริษัทย่อย ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร XXYY-######' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)วันที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FDXshDocDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เวลาที่เกิดเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshDocTime'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันนัดรับ/จ่ายเงิน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FDXshDueDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสแผนก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTDptCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสผู้บันทึก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTUsrCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสผู้จำหน่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTSplCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสลูกค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTCstCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสงวดบัญชี' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTPrdCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสผู้อนุมัติ (TSysUser)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshApvCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อผู้รับ/จ่ายเงิน (ชื่อควรเลือกจาก TCNTCTractor แต่พิมพ์ได้)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshCtrName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนครั้งในการพิมพ์เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FNXshDocPrint'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม ก่อนชำระ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshTotal'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอด หักภาษี ณ ที่จ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshWht'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมหลัง หักภาษี ณ ที่จ่าย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshAfWht'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอด ดอกเบี้ย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshInterest'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอด ส่วนลด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshDisc'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมหลัง หัก ส่วนลด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshAfDisc'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม ทั้งสิ้น (ชำระ - หักภาษี + ดอกเบี้ย - ส่วนลด)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshAmt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม ชำระ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshPay'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมชาร์จบัตรเครดิต' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshChgCredit'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวม จ่ายชำระจริง (ยอดรวม ทั้งสิ้น+ชาร์จบัตร)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshGnd'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนเงินเป็นตัวอักษร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshGndText'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมรับ/จ่าย เงินสด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshMnyCsh'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมรับ/จ่าย เช็ค' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshMnyChq'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมรับ/จ่าย บัตรเครดิต' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshMnyCrd'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมรับ/จ่าย โอนเงิน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshMnyCtf'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมรับ/จ่าย คูปอง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshMnyCpn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมรับ/จ่าย ยกหนี้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshMnyCls'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ยอดรวมรับ/จ่าย อื่นๆ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FCXshMnyCxx'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)สถานะ รับ/จ่ายเงิน 1:ยังไม่จ่าย 2:บางส่วน, 3:ครบ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshStaPaid'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)สถานะ เอกสาร  1:สมบูรณ์, 2:ไม่สมบูรณ์, 3:ยกเลิก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshStaDoc'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)สถานะ prc เอกสาร  ว่าง:ยังไม่ทำ, 1:ทำแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshStaPrcDoc'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshRmk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เงื่อนไขการวางบิล' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTXshCond'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)สถานะ เคลื่อนไหว 0:NonActive, 1:Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FNXshStaDocAct'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)สถานะ อ้างอิง 0:ไม่เคยอ้างอิง, 1:อ้างอิงบางส่วน, 2:อ้างอิงหมดแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FNXshStaRef'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHD', @level2type=N'COLUMN',@level2name=N'FTCreateBy'

END
GO
IF OBJECT_ID(N'TARTSpHDCst') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTSpHDCst](
		[FTAgnCode] [varchar](10) NOT NULL,
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTXshCardID] [varchar](20) NULL,
		[FTXshCardNo] [varchar](20) NULL,
		[FNXshCrTerm] [int] NULL,
		[FDXshDueDate] [datetime] NULL,
		[FDXshBillDue] [datetime] NULL,
		[FTXshCtrName] [varchar](100) NULL,
		[FDXshTnfDate] [datetime] NULL,
		[FTXshRefTnfID] [varchar](20) NULL,
		[FNXshAddrShip] [bigint] NULL,
		[FTXshAddrTax] [varchar](20) NULL,
	 CONSTRAINT [PK_TARTSpHDCst] PRIMARY KEY CLUSTERED 
	(
		[FTAgnCode] ASC,
		[FTBchCode] ASC,
		[FTXshDocNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสบริษัทย่อย ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่บัตรประจำตัวประชาชน/Passport' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCardID'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขบัตรสมาชิก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCardNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ระยะเครดิต' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FNXshCrTerm'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ครบกำหนด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FDXshDueDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่จะรับ/วางบิล' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FDXshBillDue'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อผู้ตืดต่อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FTXshCtrName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ส่งของ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FDXshTnfDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่ ใบขนส่ง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FTXshRefTnfID'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ที่อยู่ส่งของ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FNXshAddrShip'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ที่อยู่ออกใบกำกับ (เก็บเลขประจำผู้เสียภาษี FTAddTaxNo)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDCst', @level2type=N'COLUMN',@level2name=N'FTXshAddrTax'

END
GO
IF OBJECT_ID(N'TARTSpHDDocRef') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTSpHDDocRef](
		[FTAgnCode] [varchar](10) NOT NULL,
		[FTBchCode] [varchar](20) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTXshRefDocNo] [varchar](20) NOT NULL,
		[FTXshRefType] [varchar](1) NOT NULL,
		[FTXshRefKey] [varchar](10) NULL,
		[FDXshRefDocDate] [datetime] NULL,
	 CONSTRAINT [PK_TARTSpHDDocRef] PRIMARY KEY CLUSTERED 
	(
		[FTAgnCode] ASC,
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FTXshRefDocNo] ASC,
		[FTXshRefType] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสบริษัทย่อย ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDDocRef', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDDocRef', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทการอ้างอิงเอกสาร 1: อ้างอิงถึง(ภายใน),2:ถูกอ้างอิง(ภายใน),3: อ้างอิง ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'กรณีType เดียวกันมีรายการมากกว่า 1 กลุ่ม /กำหนด Key เองได้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefKey'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpHDDocRef', @level2type=N'COLUMN',@level2name=N'FDXshRefDocDate'

END
GO
IF OBJECT_ID(N'TARTSpRC') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTSpRC](
		[FTAgnCode] [varchar](10) NOT NULL,
		[FTXphDocNo] [varchar](20) NOT NULL,
		[FNXrcSeqNo] [bigint] NOT NULL,
		[FTXphDocType] [varchar](1) NULL,
		[FDXphDocDate] [datetime] NULL,
		[FTRcvCode] [varchar](5) NULL,
		[FTRcvName] [varchar](50) NULL,
		[FTXrcRefNo1] [varchar](100) NULL,
		[FTXrcRefNo2] [varchar](100) NULL,
		[FTBnkCode] [varchar](5) NULL,
		[FTBnkName] [varchar](100) NULL,
		[FTXrcBnkBch] [varchar](100) NULL,
		[FDXrcRefDate] [datetime] NULL,
		[FCXrcChgCreditPer] [numeric](18, 4) NULL,
		[FCXrcChgCreditAmt] [numeric](18, 4) NULL,
		[FCXrcFAmt] [numeric](18, 4) NULL,
		[FCXrcAmt] [numeric](18, 4) NULL,
		[FCXrcNet] [numeric](18, 4) NULL,
		[FCXrcChg] [numeric](18, 4) NULL,
		[FTXrcStaPrc] [varchar](1) NULL,
		[FTXrcRmk] [varchar](250) NULL,
		[FTRteCode] [varchar](5) NULL,
		[FCXrcRteAmt] [numeric](18, 4) NULL,
		[FCXrcRteFac] [numeric](18, 4) NULL,
		[FTXrcStaChg] [varchar](1) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TARTSpRC] PRIMARY KEY CLUSTERED 
	(
		[FTAgnCode] ASC,
		[FTXphDocNo] ASC,
		[FNXrcSeqNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสบริษัทย่อย ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร  XXYY-######' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTXphDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับการชำระเงินต่อ 1 เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FNXrcSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)ประเภทเอกสาร 1:ขาย(S), 9:คืน(R)  (D-H)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTXphDocType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)วันที่เอกสาร (D-H)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FDXphDocDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสประเภทการชำระเงิน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTRcvCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อประเภทชำระเงิน ณ บันทึก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTRcvName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่อ้างอิง1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTXrcRefNo1'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่อ้างอิง2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTXrcRefNo2'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสธนาคาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTBnkCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อธนาคาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTBnkName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อสาขา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTXrcBnkBch'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลงวันที่ เช็ค' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FDXrcRefDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชาร์จบัตรเครดิต (%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FCXrcChgCreditPer'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชาร์จบัตรเครดิต (มูลค่า)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FCXrcChgCreditAmt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จากจำนวนเงิน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FCXrcFAmt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนเงินที่ชำระ (เงินที่รับ:อาจจะรวมเงินทอน)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FCXrcAmt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนเงินที่ได้จริง (ไม่รวมเงินทอน)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FCXrcNet'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนเงินทอน (ถ้ามีทอนจะพบ ในตารางนี้ที่ลำดับสุดท้ายของบิลนั้นๆ)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FCXrcChg'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)สถานะ ประมวลผล ว่าง:ยังไม่ทำ, 1:ทำแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTXrcStaPrc'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'หมายเหตุ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTXrcRmk'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)รหัสสกุลเงิน' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTRteCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนเงินที่ชำระ (สกุลต่างประเทศ)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FCXrcRteAmt'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'อัตราแลกเปลี่ยนขณะชำระ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FCXrcRteFac'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'(INDEX)สถานะ เงินทอน 1:เงินทอน, 2:ตั้งยอดเครดิตสะสม' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTXrcStaChg'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSpRC', @level2type=N'COLUMN',@level2name=N'FTCreateBy'

END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqDT' AND COLUMN_NAME = 'FTXsdStaFollow') BEGIN
	ALTER TABLE TARTSqDT ADD FTXsdStaFollow VARCHAR(1)
END
GO
IF OBJECT_ID(N'TARTSqDTSet') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTSqDTSet](
		[FTAgnCode] [varchar](10) NOT NULL,
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FNXsdSeqNo] [int] NOT NULL,
		[FNPstSeqNo] [int] NOT NULL,
		[FTPdtCode] [varchar](20) NULL,
		[FTXsdPdtName] [varchar](100) NULL,
		[FTPunCode] [varchar](5) NULL,
		[FCXsdQtySet] [numeric](18, 4) NULL,
		[FCXsdSalePrice] [numeric](18, 4) NULL,
	 CONSTRAINT [PK_TARTSqDTSet] PRIMARY KEY CLUSTERED 
	(
		[FTAgnCode] ASC,
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FNXsdSeqNo] ASC,
		[FNPstSeqNo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสคู่ค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FNXsdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับรายการสินค้าชุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FNPstSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FTPdtCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ชื่อสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FTXsdPdtName'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสหน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FTPunCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนต่อชุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FCXsdQtySet'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จากราคาซื้อ ตาม หน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTSet', @level2type=N'COLUMN',@level2name=N'FCXsdSalePrice'

END
GO
IF OBJECT_ID(N'TARTSqHDDocRef') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTSqHDDocRef](
		[FTAgnCode] [varchar](10) NOT NULL,
		[FTBchCode] [varchar](20) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTXshRefDocNo] [varchar](20) NOT NULL,
		[FTXshRefType] [varchar](1) NOT NULL,
		[FTXshRefKey] [varchar](10) NULL,
		[FDXshRefDocDate] [datetime] NULL,
	 CONSTRAINT [PK_TARTSqHDDocRef] PRIMARY KEY CLUSTERED 
	(
		[FTAgnCode] ASC,
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FTXshRefDocNo] ASC,
		[FTXshRefType] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสคู่ค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqHDDocRef', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqHDDocRef', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทการอ้างอิงเอกสาร 1: อ้างอิงถึง(ภายใน),2:ถูกอ้างอิง(ภายใน),3: อ้างอิง ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'กรณีType เดียวกันมีรายการมากกว่า 1 กลุ่ม /กำหนด Key เองได้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefKey'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqHDDocRef', @level2type=N'COLUMN',@level2name=N'FDXshRefDocDate'
END
GO
IF OBJECT_ID(N'TARTSqDTFhn') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTSqDTFhn](
		[FTAgnCode] [varchar](10) NOT NULL,
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FNXsdSeqNo] [int] NOT NULL,
		[FTPdtCode] [varchar](20) NOT NULL,
		[FTFhnRefCode] [varchar](255) NOT NULL,
		[FCXsdQty] [numeric](18, 4) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TARTSqDTFhn] PRIMARY KEY CLUSTERED 
	(
		[FTAgnCode] ASC,
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FNXsdSeqNo] ASC,
		[FTPdtCode] ASC,
		[FTFhnRefCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสคู่ค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FTAgnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FNXsdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FTPdtCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสควบคุมสต็อกสินค้า (SEASON+MODEL+COLOR+SIZE)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FTFhnRefCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนชื้น ตาม หน่วย' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FCXsdQty'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTSqDTFhn', @level2type=N'COLUMN',@level2name=N'FTCreateBy'

END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqDT' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	ALTER TABLE TARTSqDT ADD FTAgnCode VARCHAR(10) NOT NULL DEFAULT('')
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqDT' AND COLUMN_NAME = 'FTAgnCode') BEGIN
    UPDATE TARTSqDT SET FTAgnCode = '' WHERE FTAgnCode IS NULL
    ALTER TABLE TARTSqDT ALTER COLUMN FTAgnCode VARCHAR(10) NOT NULL

    DECLARE @tConstraint VARCHAR(30) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TARTSqDT' and type_desc LIKE '%CONSTRAINT')
    DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TARTSqDT DROP CONSTRAINT '+@tConstraint
    EXECUTE sp_executesql @tSql
    ALTER TABLE TARTSqDT ADD PRIMARY KEY(FTAgnCode,FTBchCode,FTXshDocNo,FNXsdSeqNo)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqDTDis' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	ALTER TABLE TARTSqDTDis ADD FTAgnCode VARCHAR(10) NOT NULL DEFAULT('')
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqDTDis' AND COLUMN_NAME = 'FTAgnCode') BEGIN
    UPDATE TARTSqDTDis SET FTAgnCode = '' WHERE FTAgnCode IS NULL
    ALTER TABLE TARTSqDTDis ALTER COLUMN FTAgnCode VARCHAR(10) NOT NULL

    DECLARE @tConstraint VARCHAR(30) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TARTSqDTDis' and type_desc LIKE '%CONSTRAINT')
    DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TARTSqDTDis DROP CONSTRAINT '+@tConstraint
    EXECUTE sp_executesql @tSql
    ALTER TABLE TARTSqDTDis ADD PRIMARY KEY(FTAgnCode,FTBchCode,FTXshDocNo,FNXsdSeqNo,FDXddDateIns)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqDTFhn' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	ALTER TABLE TARTSqDTFhn ADD FTAgnCode VARCHAR(10) NOT NULL DEFAULT('')
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqDTFhn' AND COLUMN_NAME = 'FTAgnCode') BEGIN
    UPDATE TARTSqDTFhn SET FTAgnCode = '' WHERE FTAgnCode IS NULL
    ALTER TABLE TARTSqDTFhn ALTER COLUMN FTAgnCode VARCHAR(10) NOT NULL

    DECLARE @tConstraint VARCHAR(30) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TARTSqDTFhn' and type_desc LIKE '%CONSTRAINT')
    DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TARTSqDTFhn DROP CONSTRAINT '+@tConstraint
    EXECUTE sp_executesql @tSql
    ALTER TABLE TARTSqDTFhn ADD PRIMARY KEY(FTAgnCode,FTBchCode,FTXshDocNo,FNXsdSeqNo,FTPdtCode,FTFhnRefCode)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqHD' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	ALTER TABLE TARTSqHD ADD FTAgnCode VARCHAR(10) NOT NULL DEFAULT('')
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqHD' AND COLUMN_NAME = 'FTAgnCode') BEGIN
    UPDATE TARTSqHD SET FTAgnCode = '' WHERE FTAgnCode IS NULL
    ALTER TABLE TARTSqHD ALTER COLUMN FTAgnCode VARCHAR(10) NOT NULL

    DECLARE @tConstraint VARCHAR(30) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TARTSqHD' and type_desc LIKE '%CONSTRAINT')
    DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TARTSqHD DROP CONSTRAINT '+@tConstraint
    EXECUTE sp_executesql @tSql
    ALTER TABLE TARTSqHD ADD PRIMARY KEY(FTAgnCode,FTBchCode,FTXshDocNo)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqHDCst' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	ALTER TABLE TARTSqHDCst ADD FTAgnCode VARCHAR(10) NOT NULL DEFAULT('')
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqHDCst' AND COLUMN_NAME = 'FTAgnCode') BEGIN
    UPDATE TARTSqHDCst SET FTAgnCode = '' WHERE FTAgnCode IS NULL
    ALTER TABLE TARTSqHDCst ALTER COLUMN FTAgnCode VARCHAR(10) NOT NULL

    DECLARE @tConstraint VARCHAR(30) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TARTSqHDCst' and type_desc LIKE '%CONSTRAINT')
    DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TARTSqHDCst DROP CONSTRAINT '+@tConstraint
    EXECUTE sp_executesql @tSql
    ALTER TABLE TARTSqHDCst ADD PRIMARY KEY(FTAgnCode,FTBchCode,FTXshDocNo)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqHDDis' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	ALTER TABLE TARTSqHDDis ADD FTAgnCode VARCHAR(10) NOT NULL DEFAULT('')
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTSqHDDis' AND COLUMN_NAME = 'FTAgnCode') BEGIN
    UPDATE TARTSqHDDis SET FTAgnCode = '' WHERE FTAgnCode IS NULL
    ALTER TABLE TARTSqHDDis ALTER COLUMN FTAgnCode VARCHAR(10) NOT NULL

    DECLARE @tConstraint VARCHAR(30) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TARTSqHDDis' and type_desc LIKE '%CONSTRAINT')
    DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TARTSqHDDis DROP CONSTRAINT '+@tConstraint
    EXECUTE sp_executesql @tSql
    ALTER TABLE TARTSqHDDis ADD PRIMARY KEY(FTAgnCode,FTBchCode,FTXshDocNo,FDXhdDateIns)
END
GO
IF OBJECT_ID(N'TCNMPosSpcCat') IS NULL BEGIN
	CREATE TABLE [dbo].[TCNMPosSpcCat](
		[FTBchCode] [varchar](5) NOT NULL,
		[FTShpCode] [varchar](5) NOT NULL,
		[FTPosCode] [varchar](5) NOT NULL,
		[FNCatSeq] [bigint] NOT NULL,
		[FTPdtCat1] [varchar](10) NULL,
		[FTPdtCat2] [varchar](10) NULL,
		[FTPdtCat3] [varchar](10) NULL,
		[FTPdtCat4] [varchar](10) NULL,
		[FTPdtCat5] [varchar](10) NULL,
		[FTPgpChain] [varchar](30) NULL,
		[FTPtyCode] [varchar](5) NULL,
		[FTPbnCode] [varchar](5) NULL,
		[FTPmoCode] [varchar](5) NULL,
		[FTTcgCode] [varchar](5) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	 CONSTRAINT [PK_TCNMPosSpcCat] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTShpCode] ASC,
		[FTPosCode] ASC,
		[FNCatSeq] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสร้านค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTShpCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสเครื่อง POS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPosCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FNCatSeq'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Catagory' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPdtCat1'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Catagory' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPdtCat2'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Catagory' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPdtCat3'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Catagory' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPdtCat4'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Catagory' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPdtCat5'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสกลุ่มสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPgpChain'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทสินค้า' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPtyCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสยี่ห้อ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPbnCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสรุ่น' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTPmoCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสกลุ่มหน้าจอ Touch Screen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTTcgCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FDLastUpdOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้ปรับปรุงรายการล่าสุด' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTLastUpdBy'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FDCreateOn'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ผู้สร้างรายการ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TCNMPosSpcCat', @level2type=N'COLUMN',@level2name=N'FTCreateBy'

END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TPMTSalDT' AND COLUMN_NAME = 'FTPdtBatchID') BEGIN
	ALTER TABLE TPMTSalDT ADD FTPdtBatchID VARCHAR(20)
END
GO
IF OBJECT_ID(N'TPSTHoldDTSN') IS NULL BEGIN
	CREATE TABLE [dbo].[TPSTHoldDTSN](
		[FNHldNo] [bigint] NOT NULL,
		[FTBchCode] [varchar](5) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FNXsdSeqNo] [int] NOT NULL,
		[FTPdtSerial] [varchar](20) NOT NULL,
		[FTPdtBatchID] [varchar](20) NOT NULL,
		[FCXsdQty] [numeric](18, 4) NULL,
		[FTXsdStaRet] [varchar](1) NULL,
	 CONSTRAINT [PK_TPSTHoldDTSN] PRIMARY KEY CLUSTERED 
	(
		[FNHldNo] ASC,
		[FTXshDocNo] ASC,
		[FNXsdSeqNo] ASC,
		[FTPdtSerial] ASC,
		[FTPdtBatchID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับการ Hold Bill' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTHoldDTSN', @level2type=N'COLUMN',@level2name=N'FNHldNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สาขาสร้าง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTHoldDTSN', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTHoldDTSN', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ลำดับ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTHoldDTSN', @level2type=N'COLUMN',@level2name=N'FNXsdSeqNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Serial(NO)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTHoldDTSN', @level2type=N'COLUMN',@level2name=N'FTPdtSerial'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัส Batch/Lot' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTHoldDTSN', @level2type=N'COLUMN',@level2name=N'FTPdtBatchID'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'จำนวนชื้น' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTHoldDTSN', @level2type=N'COLUMN',@level2name=N'FCXsdQty'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'สถานะการคืน 1:ยังไม่คืน 2:คืนแล้ว' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TPSTHoldDTSN', @level2type=N'COLUMN',@level2name=N'FTXsdStaRet'

END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMTaxAddress_L' AND COLUMN_NAME = 'FTVatStaOffline') BEGIN
	ALTER TABLE TCNMTaxAddress_L ADD FTVatStaOffline VARCHAR(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMChannel' AND COLUMN_NAME = 'FTChnWahDO') BEGIN
	ALTER TABLE TCNMChannel ADD FTChnWahDO varchar(10)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMChannel' AND COLUMN_NAME = 'FTChnStaUsePL') BEGIN
	ALTER TABLE TCNMChannel ADD FTChnStaUsePL varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMChannel' AND COLUMN_NAME = 'FTChnStaUseDO') BEGIN
	ALTER TABLE TCNMChannel ADD FTChnStaUseDO varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMChannel' AND COLUMN_NAME = 'FTChnStaAlwSNPL') BEGIN
	ALTER TABLE TCNMChannel ADD FTChnStaAlwSNPL varchar(1)
END
GO

/****** Object:  Table [dbo].[TCNMChannelSpcWah]    Script Date: 7/9/2565 17:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMChannelSpcWah]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMChannelSpcWah](
	[FTAgnCode] [varchar](10) NULL,
	[FTBchCode] [varchar](5) NOT NULL,
	[FTWahCode] [varchar](5) NOT NULL,
	[FTChnCode] [varchar](5) NOT NULL,
	[FTChnStaDoc] [varchar](1) NULL,
 CONSTRAINT [PK_TCNMWaHouseChn] PRIMARY KEY CLUSTERED 
(
	[FTBchCode] ASC,
	[FTWahCode] ASC,
	[FTChnCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO


IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMWaHouse' AND COLUMN_NAME = 'FTWahStaAlwPLFrmTBO') BEGIN
	ALTER TABLE TCNMWaHouse ADD FTWahStaAlwPLFrmTBO varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMWaHouse' AND COLUMN_NAME = 'FTWahStaAlwPLFrmSale') BEGIN
	ALTER TABLE TCNMWaHouse ADD FTWahStaAlwPLFrmSale varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMWaHouse' AND COLUMN_NAME = 'FTWahStaAlwSNPL') BEGIN
	ALTER TABLE TCNMWaHouse ADD FTWahStaAlwSNPL varchar(1)
END
GO


IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTDocDTTmp' AND COLUMN_NAME = 'FTXtdPdtSetOrSN') BEGIN
	ALTER TABLE TCNTDocDTTmp ADD FTXtdPdtSetOrSN varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTDocDTTmp' AND COLUMN_NAME = 'FCXtdQtyOrd') BEGIN
	ALTER TABLE TCNTDocDTTmp ADD FCXtdQtyOrd numeric(18, 4)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TFNMCouponType' AND COLUMN_NAME = 'FTCptStaPartial') BEGIN
	ALTER TABLE TFNMCouponType ADD FTCptStaPartial varchar(1)
END
GO

/****** From DB:FitAuto Date 14/09/2022 By:Ice PHP ******/
ALTER TABLE TCNTDocDTTmp ALTER COLUMN FTXtdDisChgTxt VARCHAR (255) NULL;
ALTER TABLE TCNTDocDTTmp ALTER COLUMN FTPgpChain VARCHAR (255) NULL;

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTDocDTTmp' AND COLUMN_NAME = 'FTWahCode') BEGIN
	ALTER TABLE TCNTDocDTTmp ADD FTWahCode varchar(10)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTDocDTTmp' AND COLUMN_NAME = 'FTPdtSetOrSN') BEGIN
	ALTER TABLE TCNTDocDTTmp ADD FTPdtSetOrSN varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTDocDTTmp' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	ALTER TABLE TCNTDocDTTmp ADD FTAgnCode varchar(20)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTDocDTTmp' AND COLUMN_NAME = 'FTCstBchCode') BEGIN
	ALTER TABLE TCNTDocDTTmp ADD FTCstBchCode varchar(50)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTDocDTTmp' AND COLUMN_NAME = 'FTBchName') BEGIN
	ALTER TABLE TCNTDocDTTmp ADD FTBchName varchar(255)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPdtPackSize' AND COLUMN_NAME = 'FTPdtStaAlwPoSPL') BEGIN
	ALTER TABLE TCNMPdtPackSize ADD FTPdtStaAlwPoSPL varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTPdtPrice4PDT' AND COLUMN_NAME = 'FTPgdRmk') BEGIN
	ALTER TABLE TCNTPdtPrice4PDT ADD FTPgdRmk varchar(200)
END
GO
/****** End From DB:FitAuto Date 14/09/2022 By:Ice PHP ******/


/****** From DB:FitAuto Date 15/09/2022 By:Ice PHP ******/
ALTER TABLE TCNTPdtPmtDT ALTER COLUMN FTPmdSubRef VARCHAR (20) NULL;
ALTER TABLE TCNTPdtPmtDT_Bin ALTER COLUMN FTPmdSubRef VARCHAR (20) NULL;
ALTER TABLE TCNTPdtPmtDT_Tmp ALTER COLUMN FTPmdSubRef VARCHAR (20) NULL;
ALTER TABLE TCNTPdtStkCrd ALTER COLUMN FTStkDocNo VARCHAR (25) NULL;
ALTER TABLE TCNMWaHouse ALTER COLUMN FTWahStaType VARCHAR (2) NULL;

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTPdtPmtDT_Bin' AND COLUMN_NAME = 'FTXtdRmk') BEGIN
	ALTER TABLE TCNTPdtPmtDT_Bin ADD FTXtdRmk varchar(200)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTPdtPmtDT_Tmp' AND COLUMN_NAME = 'FTXtdRmk') BEGIN
	ALTER TABLE TCNTPdtPmtDT_Tmp ADD FTXtdRmk varchar(200)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMWaHouse' AND COLUMN_NAME = 'FTWahStaAlwPLFrmSO') BEGIN
	ALTER TABLE TCNMWaHouse ADD FTWahStaAlwPLFrmSO varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPdt' AND COLUMN_NAME = 'FTPdtStaAlwBook') BEGIN
	ALTER TABLE TCNMPdt ADD FTPdtStaAlwBook varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPdt' AND COLUMN_NAME = 'FCPdtCostType') BEGIN
	ALTER TABLE TCNMPdt ADD FCPdtCostType numeric(18, 4)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPdt' AND COLUMN_NAME = 'FCPdtDepAmtPer') BEGIN
	ALTER TABLE TCNMPdt ADD FCPdtDepAmtPer numeric(18, 4)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPdt' AND COLUMN_NAME = 'FTPdtStaLot') BEGIN
	ALTER TABLE TCNMPdt ADD FTPdtStaLot varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPdt' AND COLUMN_NAME = 'FCPdtCostLast') BEGIN
	ALTER TABLE TCNMPdt ADD FCPdtCostLast numeric(18, 4)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPdt' AND COLUMN_NAME = 'FTPdtStaAlwWHTax') BEGIN
	ALTER TABLE TCNMPdt ADD FTPdtStaAlwWHTax varchar(1)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPdtCostAvg' AND COLUMN_NAME = 'FTAgnCode') BEGIN
	ALTER TABLE TCNMPdtCostAvg ADD FTAgnCode varchar(10)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNMPdtCostAvg' AND COLUMN_NAME = 'FCPdtCostStd') BEGIN
	ALTER TABLE TCNMPdtCostAvg ADD FCPdtCostStd numeric(18, 4)
END
GO

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTImpMasTmp' AND COLUMN_NAME = 'FTPosIP') BEGIN
	ALTER TABLE TCNTImpMasTmp ADD FTPosIP varchar(20)
END
GO

/****** Object:  Table [dbo].[TCNTPdtPmtHDSeq]    Script Date: 15/9/2565 17:25:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPdtPmtHDSeq]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPdtPmtHDSeq](
	[FTBchCode] [varchar](5) NOT NULL,
	[FTPmhDocNo] [varchar](20) NOT NULL,
	[FTPmhDocRef] [varchar](20) NOT NULL,
	[FTPmhStaType] [varchar](1) NULL,
 CONSTRAINT [PK_TCNTPdtPmtHDSeq] PRIMARY KEY CLUSTERED 
(
	[FTBchCode] ASC,
	[FTPmhDocNo] ASC,
	[FTPmhDocRef] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TCNTPdtPmtHDSeq_Tmp]    Script Date: 15/9/2565 17:25:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPdtPmtHDSeq_Tmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPdtPmtHDSeq_Tmp](
	[FTBchCode] [varchar](5) NULL,
	[FTPmhDocNo] [varchar](20) NULL,
	[FTPmhDocRef] [varchar](20) NULL,
	[FTPmhStaType] [varchar](1) NULL,
	[FTSessionID] [varchar](255) NULL,
	[FDCreateOn] [datetime] NULL
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TCNTPdtPmtDTLot]    Script Date: 15/9/2565 17:43:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPdtPmtDTLot]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPdtPmtDTLot](
	[FTBchCode] [varchar](5) NOT NULL,
	[FTPmhDocNo] [varchar](20) NOT NULL,
	[FNPmdSeq] [bigint] NOT NULL,
	[FTPmdRefCode] [varchar](30) NOT NULL,
	[FTPmdLotNo] [varchar](20) NOT NULL,
 CONSTRAINT [PK_TCNTPdtPmtDTLot] PRIMARY KEY CLUSTERED 
(
	[FTBchCode] ASC,
	[FTPmhDocNo] ASC,
	[FNPmdSeq] ASC,
	[FTPmdRefCode] ASC,
	[FTPmdLotNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TCNTPdtPmtDTLot_Bin]    Script Date: 15/9/2565 17:43:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPdtPmtDTLot_Bin]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPdtPmtDTLot_Bin](
	[FTBchCode] [varchar](5) NULL,
	[FTPmhDocNo] [varchar](20) NULL,
	[FNPmdSeq] [bigint] NULL,
	[FTPmdRefCode] [varchar](30) NULL,
	[FTPmdLotNo] [varchar](20) NULL,
	[FTSessionID] [varchar](255) NULL,
	[FDCreateOn] [datetime] NULL
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TCNTPdtPmtDTLot_Tmp]    Script Date: 15/9/2565 17:43:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTPdtPmtDTLot_Tmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTPdtPmtDTLot_Tmp](
	[FTBchCode] [varchar](5) NULL,
	[FTPmhDocNo] [varchar](20) NULL,
	[FNPmdSeq] [bigint] NULL,
	[FTPmdRefCode] [varchar](30) NULL,
	[FTPmdLotNo] [varchar](20) NULL,
	[FTSessionID] [varchar](255) NULL,
	[FDCreateOn] [datetime] NULL
) ON [PRIMARY]
END
GO


/****** Object:  Table [dbo].[TCNMLot]    Script Date: 15/9/2565 18:11:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMLot]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMLot](
	[FTLotNo] [varchar](20) NOT NULL,
	[FTLotBatchNo] [varchar](125) NULL,
	[FTLotYear] [varchar](125) NULL,
	[FTAgnCode] [varchar](10) NULL,
	[FTLotStaUse] [varchar](1) NULL,
	[FTLotRemark] [varchar](100) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
 CONSTRAINT [PK_TCNMLot] PRIMARY KEY CLUSTERED 
(
	[FTLotNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TCNMPdtLot]    Script Date: 15/9/2565 18:13:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMPdtLot]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMPdtLot](
	[FTPbnCode] [varchar](5) NOT NULL,
	[FTPmoCode] [varchar](5) NOT NULL,
	[FTLotNo] [varchar](5) NOT NULL,
	[FCPdtCost] [numeric](18, 4) NULL,
	[FDPdtDateMFG] [datetime] NULL,
	[FDPdtDateEXP] [datetime] NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
	[FTPdtCode] [varchar](20) NULL,
 CONSTRAINT [PK_TCNMPdtLot] PRIMARY KEY CLUSTERED 
(
	[FTPbnCode] ASC,
	[FTPmoCode] ASC,
	[FTLotNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TCNMPdtSpcCtl]    Script Date: 16/9/2565 0:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMPdtSpcCtl]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMPdtSpcCtl](
	[FTPdtCode] [varchar](20) NOT NULL,
	[FTDctCode] [varchar](5) NOT NULL,
	[FTPscAlwCmp] [varchar](1) NULL,
	[FTPscAlwAD] [varchar](1) NULL,
	[FTPscAlwBch] [varchar](1) NULL,
	[FTPscAlwMer] [varchar](1) NULL,
	[FTPscAlwShp] [varchar](1) NULL,
	[FTPscAlwOwner] [varchar](1) NULL,
 CONSTRAINT [PK_TCNMPdtSpcCtl] PRIMARY KEY CLUSTERED 
(
	[FTPdtCode] ASC,
	[FTDctCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TCNSDocCtl_L]    Script Date: 16/9/2565 0:55:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNSDocCtl_L]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNSDocCtl_L](
	[FTDctCode] [varchar](5) NOT NULL,
	[FNLngID] [bigint] NOT NULL,
	[FTDctTable] [varchar](100) NOT NULL,
	[FTDctName] [varchar](150) NULL,
	[FTDctStaUse] [varchar](1) NULL,
 CONSTRAINT [PK_TCNSDocCtl_1] PRIMARY KEY CLUSTERED 
(
	[FTDctCode] ASC,
	[FNLngID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TCNMMsgHD_L]    Script Date: 16/9/2565 1:10:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNMMsgHD_L]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNMMsgHD_L](
	[FTMshCode] [varchar](5) NOT NULL,
	[FNLngID] [int] NOT NULL,
	[FTMshName] [varchar](100) NULL,
	[FTMshRmk] [varchar](255) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FDCreateOn] [datetime] NULL,
	[FTCreateBy] [varchar](20) NULL,
 CONSTRAINT [PK_TCNMMsgHD_L] PRIMARY KEY CLUSTERED 
(
	[FTMshCode] ASC,
	[FNLngID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO


/****** End From DB:FitAuto Date 15/09/2022 By:Ice PHP ******/

/****** From DB:KPC Date 19/09/2022 By:Ice PHP ******/
TRUNCATE TABLE TCNTPdtPmtHDCstLev_Tmp;
ALTER TABLE TCNTPdtPmtHDCstLev_Tmp ALTER COLUMN FTClvCode VARCHAR (20) NOT NULL;

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTPdtPmtHDCstLev_Tmp' AND COLUMN_NAME = 'FTClvName') BEGIN
	ALTER TABLE TCNTPdtPmtHDCstLev_Tmp ADD FTClvName varchar(50) NOT NULL
END
GO



/****** End From DB:KPC Date 19/09/2022 By:Ice PHP ******/


/****** From DB:Fit Auto Date 06/10/2022 By:Ice PHP ******/

IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TCNTPdtTwxHD' AND COLUMN_NAME = 'FTXthDocType') BEGIN
	ALTER TABLE TCNTPdtTwxHD ADD FTXthDocType varchar(1) NULL
END
GO

/****** End From DB:Fit Auto Date 06/10/2022 By:Ice PHP ******/




IF OBJECT_ID(N'TARTRcvDepositHDDocRef') IS NULL BEGIN
	CREATE TABLE [dbo].[TARTRcvDepositHDDocRef](
		[FTBchCode] [varchar](20) NOT NULL,
		[FTXshDocNo] [varchar](20) NOT NULL,
		[FTXshRefDocNo] [varchar](20) NOT NULL,
		[FTXshRefType] [varchar](1) NOT NULL,
		[FTXshRefKey] [varchar](10) NULL,
		[FDXshRefDocDate] [datetime] NULL,
	 CONSTRAINT [PK_TARTRcvDepositHDDocRef] PRIMARY KEY CLUSTERED 
	(
		[FTBchCode] ASC,
		[FTXshDocNo] ASC,
		[FTXshRefDocNo] ASC,
		[FTXshRefType] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'รหัสสาขา ที่สร้างเอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDDocRef', @level2type=N'COLUMN',@level2name=N'FTBchCode'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสาร' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'เลขที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefDocNo'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ประเภทการอ้างอิงเอกสาร 1: อ้างอิงถึง(ภายใน),2:ถูกอ้างอิง(ภายใน),3: อ้างอิง ภายนอก' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefType'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'กรณีType เดียวกันมีรายการมากกว่า 1 กลุ่ม /กำหนด Key เองได้' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDDocRef', @level2type=N'COLUMN',@level2name=N'FTXshRefKey'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'วันที่เอกสารอ้างอิง' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TARTRcvDepositHDDocRef', @level2type=N'COLUMN',@level2name=N'FDXshRefDocDate'
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTRcvDepositDT' AND COLUMN_NAME = 'FTPdtCode') BEGIN
	ALTER TABLE TARTRcvDepositDT ADD FTPdtCode VARCHAR(20)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTRcvDepositDT' AND COLUMN_NAME = 'FTPunCode') BEGIN
	ALTER TABLE TARTRcvDepositDT ADD FTPunCode VARCHAR(5)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTRcvDepositDT' AND COLUMN_NAME = 'FTPunName') BEGIN
	ALTER TABLE TARTRcvDepositDT ADD FTPunName VARCHAR(50)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTRcvDepositDT' AND COLUMN_NAME = 'FCXsdFactor') BEGIN
	ALTER TABLE TARTRcvDepositDT ADD FCXsdFactor DECIMAL(18,4)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTRcvDepositDT' AND COLUMN_NAME = 'FTXsdBarCode') BEGIN
	ALTER TABLE TARTRcvDepositDT ADD FTXsdBarCode VARCHAR(25)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTRcvDepositDT' AND COLUMN_NAME = 'FCXsdSalePrice') BEGIN
	ALTER TABLE TARTRcvDepositDT ADD FCXsdSalePrice DECIMAL(18,4)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTRcvDepositDT' AND COLUMN_NAME = 'FCXsdQty') BEGIN
	ALTER TABLE TARTRcvDepositDT ADD FCXsdQty DECIMAL(18,4)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTRcvDepositDT' AND COLUMN_NAME = 'FCXsdQtyAll') BEGIN
	ALTER TABLE TARTRcvDepositDT ADD FCXsdQtyAll DECIMAL(18,4)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TARTRcvDepositDT' AND COLUMN_NAME = 'FCXsdSetPrice') BEGIN
	ALTER TABLE TARTRcvDepositDT ADD FCXsdSetPrice DECIMAL(18,4)
END
GO




/****** Object:  Table [dbo].[TRPTPackageCpnHisTmp]    Script Date: 14/10/2565 10:10:50 ******/
DROP TABLE IF EXISTS [dbo].[TRPTPackageCpnHisTmp]
GO
/****** Object:  Table [dbo].[TRPTPackageCpnHisTmp]    Script Date: 14/10/2565 10:10:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRPTPackageCpnHisTmp](
	[FTCpnNo] [varchar](50) NULL,
	[FTCpnName] [varchar](255) NULL,
	[FTPosName] [varchar](255) NULL,
	[FTXshDocNo] [varchar](20) NULL,
	[FTXshDocType] [varchar](100) NULL,
	[FTUsrName] [varchar](150) NULL,
	[FDXshDocDate] [datetime] NULL,
	[FCXshCpnAmt] [numeric](18, 4) NULL,
	[FCXshCpnAmtTatal] [numeric](18, 4) NULL,
	[FCXshCpnQtyUse] [numeric](18, 4) NULL,
	[FCXshCpnQtyLeft] [numeric](18, 4) NULL,
	[FTUsrSessID] [varchar](150) NULL
) ON [PRIMARY]
GO



IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNTCouponHD' AND COLUMN_NAME = 'FTCphRefInt') BEGIN
 ALTER TABLE TFNTCouponHD ADD FTCphRefInt VARCHAR(20)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNTCouponHD' AND COLUMN_NAME = 'FTCphFmtPrefix') BEGIN
 ALTER TABLE TFNTCouponHD ADD FTCphFmtPrefix VARCHAR(10)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFNTCouponHD' AND COLUMN_NAME = 'FNCphFmtLen') BEGIN
 ALTER TABLE TFNTCouponHD ADD FNCphFmtLen BIGINT
END
GO


IF NOT EXISTS(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'TRGTCstBchLic' AND COLUMN_NAME = 'FTCbrRefPos') BEGIN
 ALTER TABLE [TRGTCstBchLic] ADD [FTCbrRefPos] varchar(5) COLLATE Thai_CI_AS NULL 
END
GO





/****** Object:  Table [dbo].[TCNTDocDTFhnTmp]    Script Date: 14/10/2565 10:10:50 ******/
DROP TABLE IF EXISTS [dbo].[TCNTDocDTFhnTmp]
GO
/****** Object:  Table [dbo].[TCNTDocDTFhnTmp]    Script Date: 14/10/2565 10:10:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TCNTDocDTFhnTmp] (
[FTBchCode] varchar(5) NOT NULL ,
[FTXshDocNo] varchar(20) NULL ,
[FNXsdSeqNo] bigint NULL ,
[FTXthDocKey] varchar(20) NULL ,
[FTPdtCode] varchar(20) NULL ,
[FTXtdPdtName] varchar(255) NULL ,
[FCXtdQty] numeric(18,4) NULL ,
[FTFhnRefCode] varchar(255) NULL ,
[FCAjdSaleB4AdjC1] numeric(18,4) NULL ,
[FDAjdDateTimeC1] datetime NULL ,
[FCAjdUnitQtyC1] numeric(18,4) NULL ,
[FCAjdQtyAllC1] numeric(18,4) NULL ,
[FCAjdSaleB4AdjC2] numeric(18,4) NULL ,
[FDAjdDateTimeC2] datetime NULL ,
[FCAjdUnitQtyC2] numeric(18,4) NULL ,
[FCAjdQtyAllC2] numeric(18,4) NULL ,
[FDAjdDateTime] datetime NULL ,
[FCAjdUnitQty] numeric(18,4) NULL ,
[FCAjdQtyAll] numeric(18,4) NULL ,
[FTSessionID] varchar(255) NULL ,
[FDCreateOn] datetime NULL ,
[FTCreateBy] varchar(20) NULL ,
[FTXtdBarCode] varchar(25) NULL ,
[FTAjdPlcCode] varchar(5) NULL 
)
GO


/****** Object:  Table [dbo].[TsysMasTmp]    Script Date: 14/10/2565 10:10:50 ******/
DROP TABLE IF EXISTS [dbo].[TsysMasTmp]
GO
/****** Object:  Table [dbo].[TsysMasTmp]    Script Date: 14/10/2565 10:10:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TsysMasTmp] (
[FTMttTableKey] varchar(255) NULL ,
[FTMttRefKey] varchar(255) NULL ,
[FTMttSessionID] varchar(255) NULL ,
[FTRefPdtCode] varchar(20) NULL ,
[FTPdtCode] varchar(20) NULL ,
[FTPdtName] varchar(100) NULL ,
[FTBarCode] varchar(25) NULL ,
[FTPunCode] varchar(5) NULL ,
[FTPunName] varchar(50) NULL ,
[FTPlcCode] varchar(5) NULL ,
[FTPlcName] varchar(100) NULL ,
[FTSplCode] varchar(20) NULL ,
[FTSplName] varchar(200) NULL ,
[FTSplStaAlwPO] varchar(1) NULL ,
[FTBarStaUse] varchar(1) NULL ,
[FTBarStaAlwSale] varchar(1) NULL ,
[FCPdtUnitFact] numeric(18,4) NULL ,
[FTPdtGrade] varchar(50) NULL ,
[FCPdtWeight] numeric(18,4) NULL ,
[FTClrCode] varchar(5) NULL ,
[FTClrName] varchar(50) NULL ,
[FTPszCode] varchar(5) NULL ,
[FTPszName] varchar(50) NULL ,
[FTPdtUnitDim] varchar(50) NULL ,
[FTPdtPkgDim] varchar(50) NULL ,
[FTPdtStaAlwPick] varchar(1) NULL ,
[FTPdtStaAlwPoHQ] varchar(1) NULL ,
[FTPdtStaAlwBuy] varchar(1) NULL ,
[FTPdtStaAlwSale] varchar(1) NULL ,
[FCPgdPriceRet] numeric(18,4) NULL ,
[FCPgdPriceWhs] numeric(18,4) NULL ,
[FCPgdPriceNet] numeric(18,4) NULL ,
[FDLastUpdOn] datetime NULL ,
[FDCreateOn] datetime NULL ,
[FTLastUpdBy] varchar(20) NULL ,
[FTCreateBy] varchar(20) NULL ,
[FTBchCode] varchar(5) NULL ,
[FTShpCode] varchar(5) NULL ,
[FDSgpStart] datetime NULL ,
[FCSgpPerSun] numeric(18,4) NULL ,
[FCSgpPerMon] numeric(18,4) NULL ,
[FCSgpPerTue] numeric(18,4) NULL ,
[FCSgpPerWed] numeric(18,4) NULL ,
[FCSgpPerThu] numeric(18,4) NULL ,
[FCSgpPerFri] numeric(18,4) NULL ,
[FCSgpPerSat] numeric(18,4) NULL ,
[FTMerCode] varchar(5) NULL ,
[FNLayNo] bigint NULL ,
[FNLayRow] bigint NULL ,
[FNLayCol] bigint NULL ,
[FTLayStaUse] varchar(1) NULL ,
[FTPosCode] varchar(5) NULL ,
[FTRakCode] varchar(5) NULL ,
[FTGhdApp] varchar(50) NULL ,
[FTAppName] varchar(50) NULL ,
[FTGdtName] varchar(200) NULL ,
[FTGhdCode] varchar(5) NULL ,
[FTSysCode] varchar(5) NULL ,
[FTGdtCallByName] varchar(100) NULL ,
[FNGdtFuncLevel] bigint NULL ,
[FTGdtStaUse] varchar(1) NULL ,
[FTWahCode] varchar(5) NULL ,
[FCSpwQtyMin] numeric(18,4) NULL ,
[FCSpwQtyMax] numeric(18,4) NULL ,
[FTSpwRmk] varchar(100) NULL ,
[FTStaEdit] varchar(2) NULL ,
[FTKbdScreen] varchar(50) NULL ,
[FTPdtStaAlwRet] varchar(1) NULL 
)
GO






DECLARE @tConstraint VARCHAR(30) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TCNMPdtCostAvg' and type_desc LIKE '%CONSTRAINT')
DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TCNMPdtCostAvg DROP CONSTRAINT '+@tConstraint
EXECUTE sp_executesql @tSql
ALTER TABLE TCNMPdtCostAvg ADD PRIMARY KEY(FTPdtCode)
ALTER TABLE TCNMPdtCostAvg ALTER COLUMN FTAgnCode VARCHAR (10);





IF (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFHTPdtStkBal' AND COLUMN_NAME = 'FTFhnRefCode') != 50 BEGIN
    UPDATE TFHTPdtStkBal SET FTFhnRefCode = '' WHERE FTFhnRefCode IS NULL
    ALTER TABLE TFHTPdtStkBal ALTER COLUMN FTFhnRefCode VARCHAR(50) NOT NULL

END
GO

IF (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFHTPdtStkCrd' AND COLUMN_NAME = 'FTFhnRefCode') != 50 BEGIN
    UPDATE TFHTPdtStkCrd SET FTFhnRefCode = '' WHERE FTFhnRefCode IS NULL
    ALTER TABLE TFHTPdtStkCrd ALTER COLUMN FTFhnRefCode VARCHAR(50) NOT NULL
END
GO


IF (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFHTPdtStkCrdBch' AND COLUMN_NAME = 'FTFhnRefCode') != 50 BEGIN
    UPDATE TFHTPdtStkCrdBch SET FTFhnRefCode = '' WHERE FTFhnRefCode IS NULL
    ALTER TABLE TFHTPdtStkCrdBch ALTER COLUMN FTFhnRefCode VARCHAR(50) NOT NULL
END
GO

IF (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFHTPdtStkCrdME' AND COLUMN_NAME = 'FTFhnRefCode') != 50 BEGIN
    UPDATE TFHTPdtStkCrdME SET FTFhnRefCode = '' WHERE FTFhnRefCode IS NULL
    ALTER TABLE TFHTPdtStkCrdME ALTER COLUMN FTFhnRefCode VARCHAR(50) NOT NULL
END
GO

IF (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TFHTPdtStkCrdMEBch' AND COLUMN_NAME = 'FTFhnRefCode') != 50 BEGIN
    UPDATE TFHTPdtStkCrdMEBch SET FTFhnRefCode = '' WHERE FTFhnRefCode IS NULL
    ALTER TABLE TFHTPdtStkCrdMEBch ALTER COLUMN FTFhnRefCode VARCHAR(50) NOT NULL
END
GO


IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMPdtBar' AND COLUMN_NAME = 'FTFhnRefCode') BEGIN
	ALTER TABLE TCNMPdtBar ADD FTFhnRefCode VARCHAR(50)
END
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMPdtBar' AND COLUMN_NAME = 'FNBarRefSeq') BEGIN
   
    ALTER TABLE TCNMPdtBar ADD FNBarRefSeq bigint NOT NULL DEFAULT 1 WITH VALUES;
 	UPDATE TCNMPdtBar SET FNBarRefSeq = 1 WHERE FNBarRefSeq IS NULL

    DECLARE @tConstraint VARCHAR(250) = (select TOP 1 OBJECT_NAME(OBJECT_ID) AS NameofConstraint FROM sys.objects where OBJECT_NAME(parent_object_id)='TCNMPdtBar' and type_desc LIKE '%CONSTRAINT')
    DECLARE @tSql NVARCHAR(250) = 'ALTER TABLE TCNMPdtBar DROP CONSTRAINT '+@tConstraint
    EXECUTE sp_executesql @tSql
    ALTER TABLE TCNMPdtBar ADD PRIMARY KEY(FTPdtCode,FTBarCode,FNBarRefSeq)
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNMCstBch') BEGIN
	CREATE TABLE [dbo].[TCNMCstBch](
		[FTCstCode] [varchar](20) NOT NULL,
		[FNCbrSeq] [bigint] NOT NULL,
		[FTCbrBchCode] [varchar](255) NOT NULL,
		[FTCbrBchName] [varchar](255) NOT NULL,
		[FTCbrRegNo] [varchar](30) NULL,
		[FTCbrSoldTo] [varchar](20) NULL,
		[FTCbrShipTo] [varchar](20) NULL,
		[FTCbrStatus] [varchar](30) NULL,
		[FDLastUpdOn] [datetime] NULL,
		[FTLastUpdBy] [varchar](20) NULL,
		[FDCreateOn] [datetime] NULL,
		[FTCreateBy] [varchar](20) NULL,
	CONSTRAINT [PK_TCNMCstBch] PRIMARY KEY CLUSTERED 
	(
		[FTCstCode] ASC,
		[FNCbrSeq] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END
GO


IF OBJECT_ID(N'TCNTAppDepHisTmp') IS NULL BEGIN
	CREATE TABLE [dbo].[TCNTAppDepHisTmp](
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
		[FTCreateBy] [varchar](20) NULL
	) ON [PRIMARY]
END
GO



DROP TABLE IF EXISTS [dbo].[TRPTIncomeNotReturnCardTmp]
GO
/****** Object:  Table [dbo].[TRPTIncomeNotReturnCardTmp]    Script Date: 27/10/2565 15:09:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRPTIncomeNotReturnCardTmp](
	[FTRptRowSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[FNRowPartID] [bigint] NULL,
	[FTBchCode] [varchar](5) NULL,
	[FTBchName] [varchar](255) NULL,
	[FTShpCode] [varchar](5) NULL,
	[FTShpName] [varchar](255) NULL,
	[FTPosCode] [varchar](5) NULL,
	[FTPosName] [varchar](255) NULL,
	[FTCrdCode] [varchar](20) NULL,
	[FCTxnCrdValue] [numeric](18, 4) NULL,
	[FTComName] [varchar](50) NULL,
	[FTRptCode] [varchar](50) NULL,
	[FTUsrSession] [varchar](255) NULL,
	[FCCrdClear] [numeric](18, 4) NULL,
	[FCCrdTopUpAuto] [numeric](18, 4) NULL,
	[FCCrdTxnPmt] [numeric](18, 4) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[TRPTSalByMerShpTmp]    Script Date: 31/10/2565 23:15:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRPTSalByMerShpTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TRPTSalByMerShpTmp](
	[FTMerCode] [varchar](30) NULL,
	[FTMerName] [varchar](200) NULL,
	[FTShpCode] [varchar](30) NULL,
	[FTShpName] [varchar](200) NULL,
	[FTPdtCode] [varchar](30) NULL,
	[FTPdtName] [varchar](250) NULL,
	[FTPunName] [varchar](100) NULL,
	[FTPXsdQty] [numeric](18, 4) NULL,
	[FCPXsdTotal] [numeric](18, 4) NULL,
	[FCPXsdDisChg] [numeric](18, 4) NULL,
	[FCPXsdAgvPri] [numeric](18, 4) NULL,
	[FCPXsdGrand] [numeric](18, 4) NULL,
	[FTUsrSession] [varchar](255) NULL
) ON [PRIMARY]
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TCNTPdtStkCrd' AND COLUMN_NAME = 'FTStkSysType') BEGIN
	ALTER TABLE TCNTPdtStkCrd ALTER COLUMN FTStkSysType VARCHAR(2)
END