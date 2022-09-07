IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TCNTDocDTTmp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TCNTDocDTTmp](
	[FTBchCode] [varchar](5) NOT NULL,
	[FTXthDocNo] [varchar](20) NULL,
	[FNXtdSeqNo] [bigint] NULL,
	[FTXthDocKey] [varchar](20) NULL,
	[FTPdtCode] [varchar](20) NULL,
	[FTXtdPdtName] [varchar](255) NULL,
	[FTPunCode] [varchar](5) NULL,
	[FTPunName] [varchar](50) NULL,
	[FCXtdFactor] [numeric](18, 4) NULL,
	[FTXtdBarCode] [varchar](25) NULL,
	[FTXtdVatType] [varchar](1) NULL,
	[FTVatCode] [varchar](5) NULL,
	[FCXtdVatRate] [numeric](18, 4) NULL,
	[FCXtdQty] [numeric](18, 4) NULL,
	[FCXtdQtyAll] [numeric](18, 4) NULL,
	[FCXtdSetPrice] [numeric](18, 4) NULL,
	[FCXtdAmt] [numeric](18, 4) NULL,
	[FCXtdVat] [numeric](18, 4) NULL,
	[FCXtdVatable] [numeric](18, 4) NULL,
	[FCXtdNet] [numeric](18, 4) NULL,
	[FCXtdCostIn] [numeric](18, 4) NULL,
	[FCXtdCostEx] [numeric](18, 4) NULL,
	[FTXtdStaPrcStk] [varchar](1) NULL,
	[FNXtdPdtLevel] [bigint] NULL,
	[FTXtdPdtParent] [varchar](20) NULL,
	[FCXtdQtySet] [numeric](18, 4) NULL,
	[FTXtdPdtStaSet] [varchar](1) NULL,
	[FTXtdRmk] [varchar](200) NULL,
	[FTXtdBchRef] [varchar](5) NULL,
	[FTXtdDocNoRef] [varchar](20) NULL,
	[FCXtdPriceRet] [numeric](18, 4) NULL,
	[FCXtdPriceWhs] [numeric](18, 4) NULL,
	[FCXtdPriceNet] [numeric](18, 4) NULL,
	[FTXtdShpTo] [varchar](5) NULL,
	[FTXtdBchTo] [varchar](5) NULL,
	[FTSrnCode] [varchar](50) NULL,
	[FTXtdSaleType] [varchar](1) NULL,
	[FCXtdSalePrice] [numeric](18, 4) NULL,
	[FCXtdAmtB4DisChg] [numeric](18, 4) NULL,
	[FTXtdDisChgTxt] [varchar](20) NULL,
	[FCXtdDis] [numeric](18, 4) NULL,
	[FCXtdChg] [numeric](18, 4) NULL,
	[FCXtdNetAfHD] [numeric](18, 4) NULL,
	[FCXtdWhtAmt] [numeric](18, 4) NULL,
	[FTXtdWhtCode] [varchar](5) NULL,
	[FCXtdWhtRate] [numeric](18, 4) NULL,
	[FCXtdQtyLef] [numeric](18, 4) NULL,
	[FCXtdQtyRfn] [numeric](18, 4) NULL,
	[FTXtdStaAlwDis] [varchar](1) NULL,
	[FTPdtName] [varchar](50) NULL,
	[FCPdtUnitFact] [numeric](18, 4) NULL,
	[FTPgpChain] [varchar](50) NULL,
	[FNAjdLayRow] [numeric](18, 2) NULL,
	[FNAjdLayCol] [numeric](18, 2) NULL,
	[FCAjdWahB4Adj] [numeric](18, 4) NULL,
	[FCAjdSaleB4AdjC1] [numeric](18, 4) NULL,
	[FDAjdDateTimeC1] [datetime] NULL,
	[FCAjdUnitQtyC1] [numeric](18, 4) NULL,
	[FCAjdQtyAllC1] [numeric](18, 4) NULL,
	[FCAjdSaleB4AdjC2] [numeric](18, 4) NULL,
	[FDAjdDateTimeC2] [datetime] NULL,
	[FCAjdUnitQtyC2] [numeric](18, 4) NULL,
	[FCAjdQtyAllC2] [numeric](18, 4) NULL,
	[FCAjdUnitQty] [numeric](18, 4) NULL,
	[FDAjdDateTime] [datetime] NULL,
	[FCAjdQtyAll] [numeric](18, 4) NULL,
	[FCAjdQtyAllDiff] [numeric](18, 4) NULL,
	[FTAjdPlcCode] [varchar](5) NULL,
	[FTSessionID] [varchar](255) NULL,
	[FDLastUpdOn] [datetime] NULL,
	[FDCreateOn] [datetime] NULL,
	[FTLastUpdBy] [varchar](20) NULL,
	[FTCreateBy] [varchar](20) NULL,
	[FNLayRowForTWXVD] [bigint] NULL,
	[FNLayColForTWXVD] [bigint] NULL,
	[FCLayColQtyMaxForTWXVD] [numeric](18, 4) NULL,
	[FCStkQty] [numeric](18, 4) NULL,
	[FCMaxTransferForTWXVD] [numeric](18, 4) NULL,
	[FCUserInPutTransferForTWXVD] [numeric](18, 4) NULL,
	[FTMerCodeForADJPL] [varchar](5) NULL,
	[FTShpCodeForADJPL] [varchar](5) NULL,
	[FTPzeCodeForADJPL] [varchar](5) NULL,
	[FTRthCodeForADJPL] [varchar](5) NULL,
	[FTSizNameForADJPL] [varchar](40) NULL,
	[FTBchCodeForADJPL] [varchar](5) NULL,
	[FNLayRowForADJSTKVD] [bigint] NULL,
	[FNLayColForADJSTKVD] [bigint] NULL,
	[FCLayColQtyMaxForADJSTKVD] [numeric](18, 4) NULL,
	[FCUserInPutForADJSTKVD] [numeric](18, 4) NULL,
	[FCDateTimeInputForADJSTKVD] [datetime] NULL,
	[FNCabSeqForTWXVD] [int] NULL,
	[FTCabNameForTWXVD] [varchar](255) NULL,
	[FTXthWhFrmForTWXVD] [varchar](5) NULL,
	[FTXthWhToForTWXVD] [varchar](5) NULL,
	[FTBddTypeForDeposit] [varchar](255) NULL,
	[FTBddRefNoForDeposit] [varchar](20) NULL,
	[FDBddRefDateForDeposit] [datetime] NULL,
	[FCBddRefAmtForDeposit] [numeric](18, 4) NULL,
	[FTBddRefBnkNameForDeposit] [varchar](255) NULL,
	[FTTmpStatus] [varchar](1) NULL,
	[FTTmpRemark] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END