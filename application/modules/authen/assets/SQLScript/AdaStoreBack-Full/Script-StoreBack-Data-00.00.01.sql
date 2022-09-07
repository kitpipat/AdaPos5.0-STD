--################## CREATE TABLE FOR SCRIPT ##################
	IF OBJECT_ID(N'TCNTUpgradeHisTmp') IS NULL BEGIN
		CREATE TABLE [dbo].[TCNTUpgradeHisTmp] (
					[FTUphVersion] varchar(10) NOT NULL ,
					[FDCreateOn] datetime NULL ,
					[FTUphRemark] varchar(MAX) NULL ,
					[FTCreateBy] varchar(50) NULL 
			);
			ALTER TABLE [dbo].[TCNTUpgradeHisTmp] ADD PRIMARY KEY ([FTUphVersion]);
		END
	GO
--#############################################################

--Version ไฟล์ กับ Version บรรทัดที่ 15 ต้องเท่ากันเสมอ !! 

IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.00.01') BEGIN

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.00.01', getdate() , 'สคริปตั้งต้น', 'Nattakit K.');
END
GO

IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.00.02') BEGIN

	INSERT INTO TSysSyncModule(FTAppCode,FNSynSeqNo) VALUES('PS',107);
	INSERT INTO TSysSyncModule(FTAppCode,FNSynSeqNo) VALUES('PS',108);
	INSERT INTO TSysSyncModule(FTAppCode,FNSynSeqNo) VALUES('PS',112);
	INSERT INTO TSysSyncModule(FTAppCode,FNSynSeqNo) VALUES('PS',113);
--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.00.02', getdate() , 'ของพี่เอ็ม', 'Nattakit K.');
END
GO

IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.00.03') BEGIN
INSERT INTO [TSysReportFilter] ([FTRptFltCode], [FTRptFltStaFrm], [FTRptFltStaTo], [FTRptGrpFlt]) VALUES ('63', '1', '0', 'G3');
INSERT INTO [TSysReportFilter] ([FTRptFltCode], [FTRptFltStaFrm], [FTRptFltStaTo], [FTRptGrpFlt]) VALUES ('64', '1', '1', 'G3');
INSERT INTO [TSysReportFilter] ([FTRptFltCode], [FTRptFltStaFrm], [FTRptFltStaTo], [FTRptGrpFlt]) VALUES ('65', '1', '1', 'G3');
INSERT INTO [TSysReportFilter_L] ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES ('63', '1', 'กลุ่มลูกค้า');
INSERT INTO [TSysReportFilter_L] ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES ('63', '2', 'Customers Group');
INSERT INTO [TSysReportFilter_L] ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES ('64', '1', 'ประเภทลูกค้า');
INSERT INTO [TSysReportFilter_L] ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES ('64', '2', 'Customers Type');
INSERT INTO [TSysReportFilter_L] ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES ('65', '1', 'ระดับลูกค้า');
INSERT INTO [TSysReportFilter_L] ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES ('65', '2', 'Customers Level');

INSERT INTO [TSysReport] ([FTRptCode], [FTGrpRptModCode], [FTGrpRptCode], [FTRptRoute], [FTRptStaUseFrm], [FTRptTblView], [FTRptFilterCol], [FTRptFileName], [FTRptStaShwBch], [FTRptStaShwYear], [FTRptSeqNo], [FTRptStaUse], [FTLicPdtCode]) VALUES ('006001005', '006', '006001', 'rptCustomer', NULL, NULL, '27,63,64,65', NULL, '1', '1', '5', '1', 'SB-RPT006001005');
INSERT INTO [TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) VALUES ('006001005', '1', 'รายงานลูกค้า', '');

INSERT INTO [TSysReportGrp] ([FTGrpRptCode], [FNGrpRptShwSeq], [FTGrpRptStaUse], [FTGrpRptModCode]) VALUES ('001003', '3', '1', '001');
INSERT INTO [TSysReportGrp_L] ([FTGrpRptCode], [FNLngID], [FTGrpRptName]) VALUES ('001003', '1', 'รายงานพิเศษ');

INSERT INTO [TSysReport] ([FTRptCode], [FTGrpRptModCode], [FTGrpRptCode], [FTRptRoute], [FTRptStaUseFrm], [FTRptTblView], [FTRptFilterCol], [FTRptFileName], [FTRptStaShwBch], [FTRptStaShwYear], [FTRptSeqNo], [FTRptStaUse], [FTLicPdtCode]) VALUES ('001003001', '001', '001003', 'rptSalByDT', NULL, NULL, '1,3,4,9,13,27,53,59,60,61,62', NULL, '1', '1', '1', '1', 'SB-RPT001003001');
INSERT INTO [TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) VALUES ('001003001', '1', 'รายงาน - ยอดขายตามรายการสินค้า', '');

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.00.03', getdate() , 'รายงานลูกค้า/รายงานยอดขายตามรายการ', 'Nattakit K.');
END
GO

IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.00.04') BEGIN

UPDATE TPSMFuncDT SET FTLicPdtCode = 'SF-PS048KB035',FTGdtStaUse = '1',FTGdtSysUse = '1' WHERE FTGhdCode = '048' AND FTGdtCallByName = 'C_KBDxSalePerson';
UPDATE TPSMFuncHD SET FDLastUpdOn = GETDATE(),FTLastUpdBy ='Junthon M.' WHERE FTGhdCode = '048';

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.00.04', getdate() , 'พี่เอ็มฝาก', 'Junthon M.');
END
GO



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.00.05') BEGIN

INSERT INTO [TSysReport] ([FTRptCode], [FTGrpRptModCode], [FTGrpRptCode], [FTRptRoute], [FTRptStaUseFrm], [FTRptTblView], [FTRptFilterCol], [FTRptFileName], [FTRptStaShwBch], [FTRptStaShwYear], [FTRptSeqNo], [FTRptStaUse], [FTLicPdtCode]) VALUES ('001003002', '001', '001003', 'rptRptInventoryPosFhn', NULL, NULL, '1,2,3,6,12', NULL, '1', '1', '2', '1', 'SB-RPT001003002');
INSERT INTO [TSysReport] ([FTRptCode], [FTGrpRptModCode], [FTGrpRptCode], [FTRptRoute], [FTRptStaUseFrm], [FTRptTblView], [FTRptFilterCol], [FTRptFileName], [FTRptStaShwBch], [FTRptStaShwYear], [FTRptSeqNo], [FTRptStaUse], [FTLicPdtCode]) VALUES ('001003003', '001', '001003', 'rtpMovePosVDFhn', NULL, NULL, '1,2,3,5,6,12,13,28,49', NULL, '1', '1', '3', '1', 'SB-RPT001003003');
INSERT INTO [TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) VALUES ('001003002', '1', 'รายงาน - สินค้าแฟชั่นคงคลังตามคลังสินค้า', '');
INSERT INTO [TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) VALUES ('001003003', '1', 'รายงาน - ความเคลื่อนไหวสินค้าแฟชั่น', '');

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.00.05', getdate() , 'รายงานพิเศษสินค้าแฟชั่น', 'Nattakit K.');
END
GO



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.00.06') BEGIN


	INSERT [dbo].[TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES (N'nVB_PrnClrSize', N'CN', N'PRINT', N'1', N'MPOS', N'1', N'1', N'1', N'0', N'', N'0', N'', CAST(N'2022-02-22T19:31:50.000' AS DateTime), N'00002', CAST(N'2022-02-21T00:00:00.000' AS DateTime), N'Junthon M.')


	INSERT [dbo].[TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES (N'nVB_PrnPdtName', N'CN', N'PRINT', N'1', N'MPOS', N'1', N'1', N'1', N'1', N'', N'1', N'', CAST(N'2022-02-22T19:31:50.000' AS DateTime), N'00002', NULL, NULL)
	INSERT [dbo].[TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES (N'nVB_PrnPdtName', N'CN', N'PRINT', N'2', N'MPOS', N'1', N'1', N'1', N'0', N'', N'0', N'', CAST(N'2022-02-22T19:31:50.000' AS DateTime), N'00002', NULL, NULL)


	INSERT [dbo].[TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES (N'nVB_PrnPdtQty', N'CN', N'PRINT', N'1', N'MPOS', N'1', N'1', N'1', N'1', N'', N'1', N'', CAST(N'2022-02-22T19:31:50.000' AS DateTime), N'00002', NULL, NULL)


	INSERT [dbo].[TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES (N'nVB_PrnSNPdt', N'CN', N'PRINT', N'1', N'MPOS', N'1', N'1', N'1', N'0', N'', N'0', N'', CAST(N'2022-02-22T19:31:50.000' AS DateTime), N'00002', CAST(N'2022-02-21T00:00:00.000' AS DateTime), N'Junthon M.')


	INSERT [dbo].[TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES (N'tPS_PrnPdtSeq', N'CN', N'PRINT', N'1', N'MPOS', N'1', N'0', N'0', N'1,2,3,4,5,6', N'', N'1,2,3,4,5,6', N'', CAST(N'2022-02-22T19:31:50.000' AS DateTime), N'00002', CAST(N'2022-02-21T00:00:00.000' AS DateTime), N'Junthon M.')


	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnClrSize', N'CN', N'PRINT', N'1', 1, N'����ʴ���,��� ���������ҧ���', N'0:����ʴ� 1:�ʴ�', N'')
	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnClrSize', N'CN', N'PRINT', N'1', 2, N'Showing the color and size in slip', N'0:Not show 1:Show', N'')


	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnPdtName', N'CN', N'PRINT', N'1', 1, N'�����Թ�������Ѻ��þ������������ҧ���', N'0:����ʴ� 1:�����Թ������ҧ��� 2:�����Թ��� 3:�����Թ����������', N'')
	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnPdtName', N'CN', N'PRINT', N'1', 2, N'Product name for print in slip', N'0:Not show 1:Short Name 2:FullName 3:Name Others', N'')
	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnPdtName', N'CN', N'PRINT', N'2', 1, N'�����Թ�������Ѻ��þ������������ҧ���', N'0 : �ʴ���÷Ѵ����  1 : ��鹺�÷Ѵ������������Ǫ���', N'')
	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnPdtName', N'CN', N'PRINT', N'2', 2, N'Product name for print in slip', N'0:Single Line 1:Start new line when name length more than line', N'')


	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnSNPdt', N'CN', N'PRINT', N'1', 1, N'����ʴ����� S/N ���������ҧ���', N'0:����ʴ� 1:�ʴ�', N'')
	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnSNPdt', N'CN', N'PRINT', N'1', 2, N'Showing the product S/N in slip', N'0:Not show 1:Show', N'')


	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnPdtQty', N'CN', N'PRINT', N'1', 1, N'����ʴ��ӹǹ�Թ������������ҧ���', N'0:����ʴ� 1:�ʴ� 2:��鹺�÷Ѵ����', N'')
	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'nVB_PrnPdtQty', N'CN', N'PRINT', N'1', 2, N'Showing the quantity of products in slip', N'0:Not show 1:Show 2:New Line', N'')


	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'tPS_PrnPdtSeq', N'CN', N'PRINT', N'1', 1, N'�ӴѺ��þ������¡���Թ������������ҧ���', N'1:�ӴѺ��¡�� 2:�����Թ������ͺ����� 3:�����Թ��� 4:����Т�Ҵ 5:���� S/N 6:�ӹǹ�Թ���,�Ҥ�', N'')
	INSERT [dbo].[TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES (N'tPS_PrnPdtSeq', N'CN', N'PRINT', N'1', 2, N'Sequence of printing list items in slip', N'1:Sequence 2: Product Code Or Barcode 3:Product Name 4:Color and Size 5:Product S/N 6:Quantity,Price', N'')


--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.00.06', getdate() , 'รายงานพิเศษสินค้าแฟชั่น', 'Nattakit K.');
END
GO





IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.07') BEGIN

INSERT INTO [TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('nVB_StaTopPdt', 'SB', 'nVB_StaTopPdt', '1', ' ', '', '', '0', '', '', '1', '', '2020-09-17 00:00:00.000', '', '2020-09-17 00:00:00.000', '');
UPDATE [TSysConfig] SET [FTSysCode]='nVB_BrwTopWeb', [FTSysApp]='SB', [FTSysKey]='nVB_BrwTopWeb', [FTSysSeq]='1', [FTGmnCode]=' ', [FTSysStaAlwEdit]='', [FTSysStaDataType]='', [FNSysMaxLength]='0', [FTSysStaDefValue]='', [FTSysStaDefRef]='', [FTSysStaUsrValue]='50', [FTSysStaUsrRef]='', [FDLastUpdOn]='2020-09-17 00:00:00.000', [FTLastUpdBy]='', [FDCreateOn]='2020-09-17 00:00:00.000', [FTCreateBy]='' WHERE ([FTSysCode]='nVB_BrwTopWeb') AND ([FTSysApp]='SB') AND ([FTSysKey]='nVB_BrwTopWeb') AND ([FTSysSeq]='1');
INSERT INTO [TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES ('nVB_StaTopPdt', 'SB', 'nVB_StaTopPdt', '1', '1', 'การแสดงจำนวนและการแบ่งหน้า - หลังบ้าน', 'กรณีค้นหา', '');
INSERT INTO [TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES ('nVB_StaTopPdt', 'SB', 'nVB_StaTopPdt', '1', '2', 'Number and Page show - StoreBack', 'In case of search', '');

UPDATE [TSysConfig] SET [FTSysCode]='nVB_BrwTopWeb', [FTSysApp]='SB', [FTSysKey]='nVB_BrwTopWeb', [FTSysSeq]='1', [FTGmnCode]=' ', [FTSysStaAlwEdit]='1', [FTSysStaDataType]='', [FNSysMaxLength]='0', [FTSysStaDefValue]='', [FTSysStaDefRef]='', [FTSysStaUsrValue]='50', [FTSysStaUsrRef]='', [FDLastUpdOn]='2020-09-17 00:00:00.000', [FTLastUpdBy]='', [FDCreateOn]='2020-09-17 00:00:00.000', [FTCreateBy]='' WHERE ([FTSysCode]='nVB_BrwTopWeb') AND ([FTSysApp]='SB') AND ([FTSysKey]='nVB_BrwTopWeb') AND ([FTSysSeq]='1');
UPDATE [TSysConfig] SET [FTSysCode]='nVB_StaTopPdt', [FTSysApp]='SB', [FTSysKey]='nVB_StaTopPdt', [FTSysSeq]='1', [FTGmnCode]=' ', [FTSysStaAlwEdit]='1', [FTSysStaDataType]='', [FNSysMaxLength]='0', [FTSysStaDefValue]='', [FTSysStaDefRef]='', [FTSysStaUsrValue]='1', [FTSysStaUsrRef]='', [FDLastUpdOn]='2020-09-17 00:00:00.000', [FTLastUpdBy]='', [FDCreateOn]='2020-09-17 00:00:00.000', [FTCreateBy]='' WHERE ([FTSysCode]='nVB_StaTopPdt') AND ([FTSysApp]='SB') AND ([FTSysKey]='nVB_StaTopPdt') AND ([FTSysSeq]='1');

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.07', getdate() , 'เพิ่มข้อมูล TSysConfig', 'Nattakit K.');
END
GO




IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.08') BEGIN

INSERT INTO [TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('SB_AlwBarDup', 'SB', 'SB_AlwBarDup', '1', '', '1', '0', '3', '', '', '0', '', '2022-03-08 17:10:01.000', '00002', '2020-09-17 00:00:00.000', '');
INSERT INTO [TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES ('SB_AlwBarDup', 'SB', 'SB_AlwBarDup', '1', '1', 'อนุญาตให้นำ Barcode เก่ามาใช้ในรหัสสินค้าใหม่ได้', '0:ไม่อนุญาต, 1:อนุญาต', '');
INSERT INTO [TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES ('SB_AlwBarDup', 'SB', 'SB_AlwBarDup', '1', '2', 'Alow BarCode Dupplicate', 'Add/Edit Product Bar', '');


--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.08', getdate() , 'เพิ่มข้อมูล TSysConfig', 'Nattakit K.');
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.09') BEGIN

UPDATE TCNSLimitHD SET FTLhdStaAlwSeq = '1'

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.09', getdate() , 'ปรับ Config ตาราง TCNSLimitHD', 'Nattakit K.');
END
GO