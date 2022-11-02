--------Script รายงาน - สรุปยอดมัดจำ/เงินเชื่อ ตามจุดขาย ------------

IF NOT EXISTS(SELECT 1 FROM dbo.TCNTUsrFuncRpt WITH(NOLOCK)
			WHERE FTUfrRef = '001003004')
BEGIN
		INSERT INTO [dbo].[TCNTUsrFuncRpt] ([FTRolCode], [FTUfrType], [FTUfrGrpRef], [FTUfrRef], [FTGhdApp], [FTUfrStaAlw], [FTUfrStaFavorite], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
		VALUES ('00002', '2', '001003', '001003004', NULL, '1', '0', NULL, NULL, '2022-10-24 20:44:53.000', '00002');
END
GO

-- เพิ่มรายงาน รายงาน - สรุปยอดมัดจำ/เงินเชื่อ ตามจุดขาย
IF NOT EXISTS(SELECT 1 FROM dbo.TSysReport WITH(NOLOCK)
			WHERE FTRptCode = '001003004')
BEGIN
		INSERT INTO [dbo].[TSysReport] ([FTRptCode], [FTGrpRptModCode], [FTGrpRptCode], [FTRptRoute], [FTRptStaUseFrm], [FTRptTblView], [FTRptFilterCol], [FTRptFileName], [FTRptStaShwBch], [FTRptStaShwYear], [FTRptSeqNo], [FTRptStaUse], [FTLicPdtCode]) 
		VALUES ('001003004', '001', '001003', 'rptDepositDailyByPos', NULL, NULL, '71,72,52', NULL, '1', '1', 4, '1', 'SB-RPT001003004');
END
GO

-- เพิ่มภาษา lang 1
IF NOT EXISTS(SELECT 1 FROM dbo.TSysReport_L WITH(NOLOCK)
			WHERE FTRptCode = '001003004'
				AND FNLngID = 1)
BEGIN
		INSERT INTO [dbo].[TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) 
		VALUES ('001003004', 1, 'รายงาน - สรุปยอดมัดจำ/เงินเชื่อ ตามจุดขาย', NULL);
END
GO
-- เพิ่มภาษา lang 2
IF NOT EXISTS(SELECT 1 FROM dbo.TSysReport_L WITH(NOLOCK)
			WHERE FTRptCode = '001003004'
				AND FNLngID = 2)
BEGIN
		INSERT INTO [dbo].[TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) 
		VALUES ('001003004', 2, 'Report - Summary of deposit/credit by point of sale', NULL);
END
GO

-- เพิ่ม filter สาขา
IF NOT EXISTS(SELECT 1 FROM dbo.TSysReportFilter WITH(NOLOCK)
			WHERE FTRptFltCode = '71')
BEGIN
		INSERT INTO [dbo].[TSysReportFilter] ([FTRptFltCode], [FTRptFltStaFrm], [FTRptFltStaTo], [FTRptGrpFlt]) 
		VALUES (71, 1, 0, NULL);
END
GO

-- เพิ่ม filter เครื่องจุดขาย
IF NOT EXISTS(SELECT 1 FROM dbo.TSysReportFilter WITH(NOLOCK)
			WHERE FTRptFltCode = '72')
BEGIN
		INSERT INTO [dbo].[TSysReportFilter] ([FTRptFltCode], [FTRptFltStaFrm], [FTRptFltStaTo], [FTRptGrpFlt]) 
		VALUES (72, 1, 0, NULL);
END
GO

--------------------------------------------------------------