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


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.10') BEGIN

INSERT INTO  [TCNTAuto] ([FTSatTblName], [FTSatFedCode], [FTSatStaDocType], [FTSatGroup], [FTGmnCode], [FTSatDocTypeName], [FTSatStaAlwChr], [FTSatStaAlwBch], [FTSatStaAlwPosShp], [FTSatStaAlwYear], [FTSatStaAlwMonth], [FTSatStaAlwDay], [FTSatStaAlwSep], [FTSatStaDefUsage], [FTSatDefChar], [FTSatDefBch], [FTSatDefPosShp], [FTSatDefYear], [FTSatDefMonth], [FTSatDefDay], [FTSatDefSep], [FTSatDefNum], [FTSatDefFmtAll], [FNSatMaxFedSize], [FNSatMinRunning], [FTSatUsrChar], [FTSatUsrBch], [FTSatUsrPosShp], [FTSatUsrYear], [FTSatUsrMonth], [FTSatUsrDay], [FTSatUsrSep], [FTSatUsrNum], [FTSatUsrFmtAll], [FTSatStaReset], [FTSatStaRunBch], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('TCNMPrnServer', 'FTSrvCode', '0', '1', 'MPDT', '', '0', '0', '0', '0', '0', '0', '0', '0', '', '0', '0', '0', '0', '0', '0', '00001', '#####', '10', '5', '', '0', '0', '0', '0', '0', '0', '00001', '#####', '', '0', '2021-12-20 00:00:00.000', '', '2021-12-20 00:00:00.000', '');
INSERT INTO  [TCNTAuto_L] ([FTSatTblName], [FTSatFedCode], [FTSatStaDocType], [FNLngID], [FTSatTblDesc], [FTSatRmk]) VALUES ('TCNMPrnServer', 'FTSrvCode', '0', '1', 'ปริ้นเตอร์เซิฟเวอร์', '');
INSERT INTO  [TCNTAuto] ([FTSatTblName], [FTSatFedCode], [FTSatStaDocType], [FTSatGroup], [FTGmnCode], [FTSatDocTypeName], [FTSatStaAlwChr], [FTSatStaAlwBch], [FTSatStaAlwPosShp], [FTSatStaAlwYear], [FTSatStaAlwMonth], [FTSatStaAlwDay], [FTSatStaAlwSep], [FTSatStaDefUsage], [FTSatDefChar], [FTSatDefBch], [FTSatDefPosShp], [FTSatDefYear], [FTSatDefMonth], [FTSatDefDay], [FTSatDefSep], [FTSatDefNum], [FTSatDefFmtAll], [FNSatMaxFedSize], [FNSatMinRunning], [FTSatUsrChar], [FTSatUsrBch], [FTSatUsrPosShp], [FTSatUsrYear], [FTSatUsrMonth], [FTSatUsrDay], [FTSatUsrSep], [FTSatUsrNum], [FTSatUsrFmtAll], [FTSatStaReset], [FTSatStaRunBch], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('TCNMPrnLabel', 'FTPlbCode', '0', '1', 'MPDT', '', '0', '0', '0', '0', '0', '0', '0', '0', '', '0', '0', '0', '0', '0', '0', '00001', '#####', '10', '5', '', '0', '0', '0', '0', '0', '0', '00001', '#####', '', '0', '2021-12-20 00:00:00.000', '', '2021-12-20 00:00:00.000', '');
INSERT INTO  [TCNTAuto_L] ([FTSatTblName], [FTSatFedCode], [FTSatStaDocType], [FNLngID], [FTSatTblDesc], [FTSatRmk]) VALUES ('TCNMPrnLabel', 'FTPlbCode', '0', '1', 'รูปแบบการพิมพ์', '');

INSERT INTO  [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('L001', 'Frm_ALLPdtPriceTag3.8x5.0-KPC.mrt', '', '1', '2022-02-10 00:00:00.000', 'Junthon M.', '2021-12-18 00:00:00.000', 'Junthon M.');
INSERT INTO  [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('L002', 'Frm_ALLPdtPriceTag6.5x10.0-KPC.mrt', '', '1', '2022-02-10 00:00:00.000', 'Junthon M.', '2021-12-18 00:00:00.000', 'Junthon M.');
INSERT INTO  [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('L003', 'Frm_ALLPdtOCPBLabel3.2X2.5-KPC.mrt', '', '1', '2021-12-18 00:00:00.000', 'Junthon M.', '2021-12-18 00:00:00.000', 'Junthon M.');
INSERT INTO  [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('L004', 'Frm_ALLPdtPriceTag4.8x7.2-KPC.mrt', '', '1', '2022-02-10 00:00:00.000', 'Junthon M.', '2022-01-28 00:00:00.000', 'Junthon M.');
INSERT INTO  [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('L005', 'Frm_ALLPdtPriceTag2.5X3.2-KPC.mrt', '', '1', '2022-01-28 00:00:00.000', 'Junthon M.', '2022-01-28 00:00:00.000', 'Junthon M.');
INSERT INTO  [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('L006', 'Frm_ALLPdtPriceTag2.5X3.2-KPC.mrt', '', '1', '2022-01-28 00:00:00.000', 'Junthon M.', '2022-01-28 00:00:00.000', 'Junthon M.');
INSERT INTO  [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('L007', 'Frm_ALLPdtPriceTag3.5X5.0-KPC.mrt', '', '1', '2022-04-22 00:00:00.000', 'Junthon M.', '2022-04-22 00:00:00.000', 'Junthon M.');
INSERT INTO  [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L001', '1', 'ป้ายราคาที่ใส่ Shelf Strip', '');
INSERT INTO  [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L002', '1', 'ป้ายราคาที่ใส่ A7 Signage', '');
INSERT INTO  [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L003', '1', 'สติ๊กเกอร์ สคบ.', '');
INSERT INTO  [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L004', '1', 'ป้ายราคา A8 (4.8 X 7.2 CM)', '');
INSERT INTO  [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L005', '1', 'สติ๊กเกอร์บาร์โค้ด (2.5 X 3.2 CM)', '');
INSERT INTO  [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L006', '1', 'สติ๊กเกอร์บาร์โค้ด (2.5 X 3.2 CM) NOT FOR SALE/NO REFUND', '');
INSERT INTO  [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L007', '1', 'ป้ายราคา A9 (3.5 X 5.0 CM)', '');


--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.10', getdate() , 'เพิ่ม Auto Master ปริ้นเซิฟเวอร์', 'Nattakit K.');
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.11') BEGIN
INSERT INTO  [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('TOL', 'TOL', 'TOL001', 'SB-ADTOL001', '10', 'ServerPrinter/0/0', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'AD', '');
INSERT INTO  [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('TOL', 'TOL', 'TOL002', 'SB-ADTOL002', '11', 'LablePrinter/0/0', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'AD', '');
INSERT INTO  [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('TOL', 'TOL', 'TOL003', 'SB-ADTOL003', '12', 'PrintBarCode/0/0', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'AD', '');
INSERT INTO  [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('TOL', 'TOL', 'TOL004', 'SB-ADTOL004', '13', 'toolConfigSlip', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '0', '', 'AD', '');
INSERT INTO  [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('TOL', 'TOL', 'TOL005', 'SB-ADTOL005', '14', 'toolLogHistory', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '0', '', 'AD', '');
INSERT INTO  [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('TOL', 'TOL', 'TOL006', 'SB-ADTOL006', '15', 'tool', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'AD', '');
INSERT INTO  [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('TOL', 'TOL', 'TOL007', 'SB-ADTOL007', '16', 'logDRG', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'AD', '');
INSERT INTO  [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('TOL', 'TOL', 'TOL008', 'SB-ADTOL008', '17', 'augAuto', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'AD', '');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL001', '1', 'ปริ้นเตอร์เซิร์ฟเวอร์', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL002', '1', 'รูปแบบการพิมพ์', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL003', '1', 'พิมพ์ป้ายราคา', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL004', '1', 'ตั้งค่าใบเสร็จ', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL005', '1', 'ตรวจสอบ Log จุดขาย', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL001', '2', 'Printer Server', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL002', '2', 'Print Format', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL003', '2', 'Print Label', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL004', '2', 'Config Slip', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL005', '2', 'Log Pos', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL006', '1', 'ซ่อมบิลขายไม่ตัดสต๊อก', NULL);
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL007', '1', 'ประวัติเปลี่ยนแปลงเลขที่บิล', '');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL008', '1', 'อัพเกรดหน้าร้านอัตโนมัติ', '');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL006', '2', 'Repair Bill Not Process Stock', '');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL007', '2', 'History Chahge Number Bill', '');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('TOL008', '2', 'Update StoreFront Auto', '');

INSERT INTO   [TSysMenuGrp] ([FTGmnCode], [FNGmnShwSeq], [FTGmnStaUse], [FTGmnModCode]) VALUES ('TOL', '1', '1', 'AD');
INSERT INTO   [TSysMenuGrp_L] ([FTGmnCode], [FNLngID], [FTGmnName], [FTGmnSystem]) VALUES ('TOL', '1', 'เครื่องมือ', 'AD');
INSERT INTO   [TSysMenuGrpModule] ([FTGmnModCode], [FNGmnModShwSeq], [FTGmnModStaUse], [FTGmmModPathIcon], [FTGmmModColorBtn]) VALUES ('AD', '11', '1', '/application/modules/common/assets/images/iconsmenu/tool-box.png', '');
INSERT INTO   [TSysMenuGrpModule_L] ([FTGmnModCode], [FTGmnModName], [FNLngID]) VALUES ('AD', 'เครื่องมือ', '1');
INSERT INTO   [TSysMenuGrpModule_L] ([FTGmnModCode], [FTGmnModName], [FNLngID]) VALUES ('AD', 'Tools', '2');

INSERT INTO [TSysMenuAlbAct] ([FTMnuCode], [FTAutStaRead], [FTAutStaAdd], [FTAutStaEdit], [FTAutStaDelete], [FTAutStaCancel], [FTAutStaAppv], [FTAutStaPrint], [FTAutStaPrintMore]) VALUES ('TOL001', '1', '1', '1', '1', '0', '0', '0', '0');
INSERT INTO [TSysMenuAlbAct] ([FTMnuCode], [FTAutStaRead], [FTAutStaAdd], [FTAutStaEdit], [FTAutStaDelete], [FTAutStaCancel], [FTAutStaAppv], [FTAutStaPrint], [FTAutStaPrintMore]) VALUES ('TOL002', '1', '1', '1', '1', '0', '0', '0', '0');
INSERT INTO [TSysMenuAlbAct] ([FTMnuCode], [FTAutStaRead], [FTAutStaAdd], [FTAutStaEdit], [FTAutStaDelete], [FTAutStaCancel], [FTAutStaAppv], [FTAutStaPrint], [FTAutStaPrintMore]) VALUES ('TOL003', '1', '1', '1', '1', '0', '0', '0', '0');
INSERT INTO [TSysMenuAlbAct] ([FTMnuCode], [FTAutStaRead], [FTAutStaAdd], [FTAutStaEdit], [FTAutStaDelete], [FTAutStaCancel], [FTAutStaAppv], [FTAutStaPrint], [FTAutStaPrintMore]) VALUES ('TOL004', '1', '1', '1', '1', '0', '0', '0', '0');
INSERT INTO [TSysMenuAlbAct] ([FTMnuCode], [FTAutStaRead], [FTAutStaAdd], [FTAutStaEdit], [FTAutStaDelete], [FTAutStaCancel], [FTAutStaAppv], [FTAutStaPrint], [FTAutStaPrintMore]) VALUES ('TOL005', '1', '1', '1', '1', '0', '0', '0', '0');
INSERT INTO [TSysMenuAlbAct] ([FTMnuCode], [FTAutStaRead], [FTAutStaAdd], [FTAutStaEdit], [FTAutStaDelete], [FTAutStaCancel], [FTAutStaAppv], [FTAutStaPrint], [FTAutStaPrintMore]) VALUES ('TOL006', '1', '1', '1', '1', '0', '0', '0', '0');
INSERT INTO [TSysMenuAlbAct] ([FTMnuCode], [FTAutStaRead], [FTAutStaAdd], [FTAutStaEdit], [FTAutStaDelete], [FTAutStaCancel], [FTAutStaAppv], [FTAutStaPrint], [FTAutStaPrintMore]) VALUES ('TOL007', '1', '1', '1', '1', '0', '0', '0', '0');
INSERT INTO [TSysMenuAlbAct] ([FTMnuCode], [FTAutStaRead], [FTAutStaAdd], [FTAutStaEdit], [FTAutStaDelete], [FTAutStaCancel], [FTAutStaAppv], [FTAutStaPrint], [FTAutStaPrintMore]) VALUES ('TOL008', '1', '1', '1', '1', '0', '0', '0', '0');

UPDATE TOP(1) [TSysMenuAlbAct] SET [FTMnuCode]='FNT001', [FTAutStaRead]='1', [FTAutStaAdd]='1', [FTAutStaEdit]='1', [FTAutStaDelete]='1', [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1' WHERE ([FTMnuCode]='FNT001');
UPDATE TOP(1) [TSysMenuAlbAct] SET [FTMnuCode]='FNT002', [FTAutStaRead]='1', [FTAutStaAdd]='1', [FTAutStaEdit]='1', [FTAutStaDelete]='1', [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1' WHERE ([FTMnuCode]='FNT002');
UPDATE TOP(1) [TSysMenuAlbAct] SET [FTMnuCode]='FNT003', [FTAutStaRead]='1', [FTAutStaAdd]='1', [FTAutStaEdit]='1', [FTAutStaDelete]='1', [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1' WHERE ([FTMnuCode]='FNT003');
UPDATE TOP(1) [TSysMenuAlbAct] SET [FTMnuCode]='FNT004', [FTAutStaRead]='1', [FTAutStaAdd]='1', [FTAutStaEdit]='1', [FTAutStaDelete]='1', [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1' WHERE ([FTMnuCode]='FNT004');


--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.11', getdate() , 'เพิ่ม Lic เครื่องมือ', 'Nattakit K.');
END
GO



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.12') BEGIN

INSERT INTO [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('SET', 'SET', 'SET006', 'SB-STSET006', '8', 'settingpdtscale/0/0', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'ST', '');
INSERT INTO [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('SET006', '1', 'ตั้งค่าบาร์โค้ดเครื่องชั่ง', '');
INSERT INTO [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('SET006', '2', 'Setting scale barcodes', '');
INSERT INTO [TSysMenuAlbAct] ([FTMnuCode], [FTAutStaRead], [FTAutStaAdd], [FTAutStaEdit], [FTAutStaDelete], [FTAutStaCancel], [FTAutStaAppv], [FTAutStaPrint], [FTAutStaPrintMore]) VALUES ('SET006', '1', '1', '1', '1', '0', '0', '0', '0');
INSERT INTO [TCNTAuto] ([FTSatTblName], [FTSatFedCode], [FTSatStaDocType], [FTSatGroup], [FTGmnCode], [FTSatDocTypeName], [FTSatStaAlwChr], [FTSatStaAlwBch], [FTSatStaAlwPosShp], [FTSatStaAlwYear], [FTSatStaAlwMonth], [FTSatStaAlwDay], [FTSatStaAlwSep], [FTSatStaDefUsage], [FTSatDefChar], [FTSatDefBch], [FTSatDefPosShp], [FTSatDefYear], [FTSatDefMonth], [FTSatDefDay], [FTSatDefSep], [FTSatDefNum], [FTSatDefFmtAll], [FNSatMaxFedSize], [FNSatMinRunning], [FTSatUsrChar], [FTSatUsrBch], [FTSatUsrPosShp], [FTSatUsrYear], [FTSatUsrMonth], [FTSatUsrDay], [FTSatUsrSep], [FTSatUsrNum], [FTSatUsrFmtAll], [FTSatStaReset], [FTSatStaRunBch], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('TCNMPdtScale', 'FTPdsCode', '0', '1', 'MPDT', '', '0', '0', '0', '0', '0', '0', '0', '0', '', '0', '0', '0', '0', '0', '0', '00001', '#####', '10', '5', '', '0', '0', '0', '0', '0', '0', '00001', '#####', '', '0', '2021-12-20 00:00:00.000', '', '2021-12-20 00:00:00.000', '');

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.12', getdate() , 'เพิ่ม เมนูตั้งค่าเครื่องชั่ง', 'Nattakit K.');
END
GO



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.13') BEGIN

TRUNCATE TABLE TCNSLabelFmt ; 
TRUNCATE TABLE TCNSLabelFmt_L ; 
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L001', 'Frm_ALLPdtPriceTag3.8x5.0-KPC.mrt', '', '2', '2022-02-10 00:00:00.000', 'Junthon M.', '2021-12-18 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L002', 'Frm_ALLPdtPriceTag6.5x10.0-KPC.mrt', '', '2', '2022-02-10 00:00:00.000', 'Junthon M.', '2021-12-18 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L003', 'Frm_ALLPdtOCPBLabel3.2X2.5-KPC.mrt', '', '2', '2021-12-18 00:00:00.000', 'Junthon M.', '2021-12-18 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L004', 'Frm_ALLPdtPriceTag4.8x7.2-KPC.mrt', '', '2', '2022-02-10 00:00:00.000', 'Junthon M.', '2022-01-28 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L005', 'Frm_ALLPdtPriceTag2.5X3.2-KPC.mrt', '', '2', '2022-01-28 00:00:00.000', 'Junthon M.', '2022-01-28 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L006', 'Frm_ALLPdtPriceTag2.5X3.2-KPC.mrt', '', '2', '2022-01-28 00:00:00.000', 'Junthon M.', '2022-01-28 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L007', 'Frm_ALLPdtPriceTag3.5X5.0-KPC.mrt', 'Frm_ALLPdtPriceTagPmt3.5X5.0-KPC.mrt', '2', '2022-04-22 00:00:00.000', 'Junthon M.', '2022-04-22 00:00:00.000', 'Junthon M.', '12', '32', 'KPC', '5 x 3.5 cm.');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L008', 'Frm_ALLPdtPriceTag10x3.8cm.mrt', 'Frm_ALLPdtPriceTagPmt10x3.8cm.mrt', '1', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '14', '14', 'STD', '10 x 3,8 cm.');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L009', 'Frm_ALLPdtPriceTag5x3.8cm.mrt', 'Frm_ALLPdtPriceTagPmt5x3.8cm.mrt', '1', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '28', '28', 'STD', '5 x 3.8 cm.');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L010', 'Frm_ALLPdtPriceTag3.2x2.4.mrt', '', '1', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '42', '0', 'STD', '3.2 x 2.4 cm.');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L011', '', 'Frm_ALLPdtPriceTagPmt200x285mm.mrt', '2', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '0', '1', 'STD', '200 x 95 mm');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L012', '', 'Frm_ALLPdtPriceTagPmt200x142mm.mrt', '2', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '0', '2', 'STD', '200 x 142 mm');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L013', '', 'Frm_ALLPdtPriceTagPmt100x142mm.mrt', '2', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '0', '4', 'STD', '100 x 142 mm');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L014', '', 'Frm_ALLPdtPriceTagPmt200x95mm.mrt', '2', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '0', '3', 'STD', '200 x 142 mm');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L015', 'Frm_ALLPdtPriceTag5x3.5cm-KPC.mrt', 'Frm_ALLPdtPriceTagPmt5x3.5cm-KPC.mrt', '2', '2022-04-22 00:00:00.000', 'Junthon M.', '2022-04-22 00:00:00.000', 'Junthon M.', '12', '32', 'KPC', '5 x 3.5 cm.');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L001', '1', 'ป้ายราคาที่ใส่ Shelf Strip', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L002', '1', 'ป้ายราคาที่ใส่ A7 Signage', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L003', '1', 'สติ๊กเกอร์ สคบ.', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L004', '1', 'ป้ายราคา A8 (4.8 X 7.2 CM)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L005', '1', 'สติ๊กเกอร์บาร์โค้ด (2.5 X 3.2 CM)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L006', '1', 'สติ๊กเกอร์บาร์โค้ด (2.5 X 3.2 CM) NOT FOR SALE/NO REFUND', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L007', '1', 'ป้ายราคา A9 (3.5 X 5.0 CM)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L008', '1', 'ป้ายราคา ขนาด 10*3.8 ซม. (ราคาปกติและราคาโปรโมชั่น)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L008', '2', 'Price label (Normal & Promotion) 10*3.8 cm.', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L009', '1', 'ป้ายราคา ขนาด 5*3.8 ซม. (ราคาปกติและราคาโปรโมชั่น)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L009', '2', 'Price label (Normal & Promotion) 5*3.8 cm.', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L010', '1', 'ป้ายราคา ขนาด 3.2*2.4 ซม', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L010', '2', 'Ticket Price 3.2*2.4 CM', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L011', '1', 'ป้ายราคา ขนาด A4', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L011', '2', 'Price Card (A4)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L012', '1', 'ป้ายราคา ขนาด A5', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L012', '2', 'Price Card (A5)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L013', '1', 'ป้ายราคา ขนาด A6', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L013', '2', 'Price Card (A6)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L014', '1', 'ป้ายราคา ขนาด 1/3 A4', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L014', '2', 'Price Card (1/3 A4)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L015', '1', 'ป้ายราคา ขนาด 5*3.5 ซม. (ราคาปกติและราคาโปรโมชั่น)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L015', '2', 'Price label (Normal & Promotion) 5*3.5 cm.', '');

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.13', getdate() , 'เพิ่มข้อมูลฟอมบาร์ปริ้นใหม่', 'Nattakit K.');
END
GO



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.14') BEGIN


INSERT INTO [TSysMenuGrp] ([FTGmnCode], [FNGmnShwSeq], [FTGmnStaUse], [FTGmnModCode]) VALUES ('TOOL', '15', '1', 'MAS');
INSERT INTO [TSysMenuGrp_L] ([FTGmnCode], [FNLngID], [FTGmnName], [FTGmnSystem]) VALUES ('TOOL', '1', 'ข้อมูลเครื่องมือ', 'MAS');
INSERT INTO [TSysMenuGrp_L] ([FTGmnCode], [FNLngID], [FTGmnName], [FTGmnSystem]) VALUES ('TOOL', '2', 'System Tools', 'MAS');
UPDATE [TSysMenuList] SET [FTGmnCode]='TOOL', [FTMnuParent]='TOOL', [FTMnuCode]='TOL001', [FTLicPdtCode]='SB-ADTOL001', [FNMnuSeq]='1', [FTMnuCtlName]='ServerPrinter/0/0', [FNMnuLevel]='1', [FTMnuStaPosHpm]='Y', [FTMnuStaPosFhn]='Y', [FTMnuStaSmartHpm]='Y', [FTMnuStaSmartFhn]='Y', [FTMnuStaMoreHpm]='Y', [FTMnuStaMoreFhn]='Y', [FTMnuType]='1', [FTMnuStaAPIPos]='Y', [FTMnuStaAPISmart]='Y', [FTMnuStaUse]='1', [FTMnuPath]='', [FTGmnModCode]='MAS', [FTMnuImgPath]='' WHERE ([FTMnuCode]='TOL001');
UPDATE [TSysMenuList] SET [FTGmnCode]='TOOL', [FTMnuParent]='TOOL', [FTMnuCode]='TOL002', [FTLicPdtCode]='SB-ADTOL002', [FNMnuSeq]='2', [FTMnuCtlName]='LablePrinter/0/0', [FNMnuLevel]='1', [FTMnuStaPosHpm]='Y', [FTMnuStaPosFhn]='Y', [FTMnuStaSmartHpm]='Y', [FTMnuStaSmartFhn]='Y', [FTMnuStaMoreHpm]='Y', [FTMnuStaMoreFhn]='Y', [FTMnuType]='1', [FTMnuStaAPIPos]='Y', [FTMnuStaAPISmart]='Y', [FTMnuStaUse]='1', [FTMnuPath]='', [FTGmnModCode]='MAS', [FTMnuImgPath]='' WHERE ([FTMnuCode]='TOL002');
UPDATE [TSysMenuList] SET [FTGmnCode]='SKU', [FTMnuParent]='SKU', [FTMnuCode]='TOL003', [FTLicPdtCode]='SB-ADTOL003', [FNMnuSeq]='6', [FTMnuCtlName]='PrintBarCode/0/0', [FNMnuLevel]='1', [FTMnuStaPosHpm]='Y', [FTMnuStaPosFhn]='Y', [FTMnuStaSmartHpm]='Y', [FTMnuStaSmartFhn]='Y', [FTMnuStaMoreHpm]='Y', [FTMnuStaMoreFhn]='Y', [FTMnuType]='1', [FTMnuStaAPIPos]='Y', [FTMnuStaAPISmart]='Y', [FTMnuStaUse]='1', [FTMnuPath]='', [FTGmnModCode]='SKU', [FTMnuImgPath]='' WHERE  ([FTMnuCode]='TOL003');
UPDATE [TSysMenuList] SET [FTGmnCode]='SPS', [FTMnuParent]='SPS', [FTMnuCode]='SET006', [FTLicPdtCode]='SB-STSET006', [FNMnuSeq]='7', [FTMnuCtlName]='settingpdtscale/0/0', [FNMnuLevel]='1', [FTMnuStaPosHpm]='Y', [FTMnuStaPosFhn]='Y', [FTMnuStaSmartHpm]='Y', [FTMnuStaSmartFhn]='Y', [FTMnuStaMoreHpm]='Y', [FTMnuStaMoreFhn]='Y', [FTMnuType]='1', [FTMnuStaAPIPos]='Y', [FTMnuStaAPISmart]='Y', [FTMnuStaUse]='1', [FTMnuPath]='', [FTGmnModCode]='MAS', [FTMnuImgPath]='' WHERE ([FTMnuCode]='SET006');
--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.14', getdate() , 'ปรับเมนูใหม่', 'Nattakit K.');
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.15') BEGIN

TRUNCATE TABLE TCNSLabelFmt ; 
TRUNCATE TABLE TCNSLabelFmt_L ; 
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L001', 'Frm_ALLPdtPriceTag3.8x5.0-KPC.mrt', '', '2', '2022-02-10 00:00:00.000', 'Junthon M.', '2021-12-18 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L002', 'Frm_ALLPdtPriceTag6.5x10.0-KPC.mrt', '', '2', '2022-02-10 00:00:00.000', 'Junthon M.', '2021-12-18 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L003', 'Frm_ALLPdtOCPBLabel3.2X2.5-KPC.mrt', '', '2', '2021-12-18 00:00:00.000', 'Junthon M.', '2021-12-18 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L004', 'Frm_ALLPdtPriceTag4.8x7.2-KPC.mrt', '', '2', '2022-02-10 00:00:00.000', 'Junthon M.', '2022-01-28 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L005', 'Frm_ALLPdtPriceTag2.5X3.2-KPC.mrt', '', '2', '2022-01-28 00:00:00.000', 'Junthon M.', '2022-01-28 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L006', 'Frm_ALLPdtPriceTag2.5X3.2-KPC.mrt', '', '2', '2022-01-28 00:00:00.000', 'Junthon M.', '2022-01-28 00:00:00.000', 'Junthon M.', '0', '0', 'KPC', '');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L007', 'Frm_ALLPdtPriceTag3.5X5.0-KPC.mrt', 'Frm_ALLPdtPriceTagPmt3.5X5.0-KPC.mrt', '2', '2022-04-22 00:00:00.000', 'Junthon M.', '2022-04-22 00:00:00.000', 'Junthon M.', '12', '32', 'KPC', '5 x 3.5 cm.');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L008', 'Frm_ALLPdtPriceTag10x3.8cm.mrt', 'Frm_ALLPdtPriceTagPmt10x3.8cm.mrt', '1', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '14', '14', 'STD', '10 x 3,8 cm.');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L009', 'Frm_ALLPdtPriceTag5x3.8cm.mrt', 'Frm_ALLPdtPriceTagPmt5x3.8cm.mrt', '1', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '28', '28', 'STD', '5 x 3.8 cm.');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L010', 'Frm_ALLPdtPriceTag3.2x2.4.mrt', '', '1', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '42', '0', 'STD', '3.2 x 2.4 cm.');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L011', '', 'Frm_ALLPdtPriceTagPmt200x285mm.mrt', '2', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '0', '1', 'STD', '200 x 95 mm');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L012', '', 'Frm_ALLPdtPriceTagPmt200x142mm.mrt', '2', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '0', '2', 'STD', '200 x 142 mm');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L013', '', 'Frm_ALLPdtPriceTagPmt100x142mm.mrt', '2', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '0', '4', 'STD', '100 x 142 mm');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L014', '', 'Frm_ALLPdtPriceTagPmt200x95mm.mrt', '2', '2022-07-28 00:00:00.000', 'Junthon M.', '2022-07-28 00:00:00.000', 'Junthon M.', '0', '3', 'STD', '200 x 142 mm');
INSERT INTO [TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) VALUES ('L015', 'Frm_ALLPdtPriceTag5x3.5cm-KPC.mrt', 'Frm_ALLPdtPriceTagPmt5x3.5cm-KPC.mrt', '2', '2022-04-22 00:00:00.000', 'Junthon M.', '2022-04-22 00:00:00.000', 'Junthon M.', '12', '32', 'KPC', '5 x 3.5 cm.');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L001', '1', 'ป้ายราคาที่ใส่ Shelf Strip', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L002', '1', 'ป้ายราคาที่ใส่ A7 Signage', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L003', '1', 'สติ๊กเกอร์ สคบ.', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L004', '1', 'ป้ายราคา A8 (4.8 X 7.2 CM)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L005', '1', 'สติ๊กเกอร์บาร์โค้ด (2.5 X 3.2 CM)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L006', '1', 'สติ๊กเกอร์บาร์โค้ด (2.5 X 3.2 CM) NOT FOR SALE/NO REFUND', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L007', '1', 'ป้ายราคา A9 (3.5 X 5.0 CM)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L008', '1', 'ป้ายราคา ขนาด 10*3.8 ซม. (ราคาปกติและราคาโปรโมชั่น)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L008', '2', 'Price label (Normal & Promotion) 10*3.8 cm.', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L009', '1', 'ป้ายราคา ขนาด 5*3.8 ซม. (ราคาปกติและราคาโปรโมชั่น)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L009', '2', 'Price label (Normal & Promotion) 5*3.8 cm.', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L010', '1', 'ป้ายราคา ขนาด 3.2*2.4 ซม', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L010', '2', 'Ticket Price 3.2*2.4 CM', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L011', '1', 'ป้ายราคา ขนาด A4', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L011', '2', 'Price Card (A4)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L012', '1', 'ป้ายราคา ขนาด A5', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L012', '2', 'Price Card (A5)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L013', '1', 'ป้ายราคา ขนาด A6', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L013', '2', 'Price Card (A6)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L014', '1', 'ป้ายราคา ขนาด 1/3 A4', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L014', '2', 'Price Card (1/3 A4)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L015', '1', 'ป้ายราคา ขนาด 5*3.5 ซม. (ราคาปกติและราคาโปรโมชั่น)', '');
INSERT INTO [TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES ('L015', '2', 'Price label (Normal & Promotion) 5*3.5 cm.', '');

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.15', getdate() , 'เพิ่มข้อมูลฟอมบาร์ปริ้นใหม่', 'Nattakit K.');
END
GO



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.16') BEGIN


UPDATE [TSysMenuAlbAct] SET [FTMnuCode]='SKU003', [FTAutStaRead]='1', [FTAutStaAdd]='1', [FTAutStaEdit]='1', [FTAutStaDelete]='1', [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1' WHERE ([FTMnuCode]='SKU003');
UPDATE [TSysMenuAlbAct] SET [FTMnuCode]='SKU004', [FTAutStaRead]='1', [FTAutStaAdd]='1', [FTAutStaEdit]='1', [FTAutStaDelete]='1', [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1' WHERE ([FTMnuCode]='SKU004');
UPDATE [TSysMenuAlbAct] SET [FTMnuCode]='SKU007', [FTAutStaRead]='1', [FTAutStaAdd]='1', [FTAutStaEdit]='1', [FTAutStaDelete]='1', [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1' WHERE ([FTMnuCode]='SKU007');

UPDATE TCNTUsrMenu SET  [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1'  WHERE [FTMnuCode]='SKU003'
UPDATE TCNTUsrMenu SET  [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1'  WHERE [FTMnuCode]='SKU004'
UPDATE TCNTUsrMenu SET  [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1'  WHERE [FTMnuCode]='SKU007'
--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.16', getdate() , 'อัพเดทสิทธของเอกสารให้กำหนดได้', 'Nattakit K.');
END
GO



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.17') BEGIN

UPDATE [TSysMenuAlbAct] SET [FTMnuCode]='AP0004', [FTAutStaRead]='1', [FTAutStaAdd]='1', [FTAutStaEdit]='1', [FTAutStaDelete]='1', [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1' WHERE ([FTMnuCode]='AP0004');
UPDATE TCNTUsrMenu SET  [FTAutStaCancel]='1', [FTAutStaAppv]='1', [FTAutStaPrint]='1', [FTAutStaPrintMore]='1'  WHERE [FTMnuCode]='AP0004';
--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.17', getdate() , 'อัพเดทสิทธของเอกสารให้กำหนดได้', 'Nattakit K.');
END
GO



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '00.01.18') BEGIN
INSERT INTO [TSysReport] ([FTRptCode], [FTGrpRptModCode], [FTGrpRptCode], [FTRptRoute], [FTRptStaUseFrm], [FTRptTblView], [FTRptFilterCol], [FTRptFileName], [FTRptStaShwBch], [FTRptStaShwYear], [FTRptSeqNo], [FTRptStaUse], [FTLicPdtCode]) VALUES ('004001012', '004', '004001', 'rptCrdCheckPrepaid', '', '', '1,4,16', '', '1', '1', '12', '1', 'SB-RPT004001012');
INSERT INTO [TSysReport] ([FTRptCode], [FTGrpRptModCode], [FTGrpRptCode], [FTRptRoute], [FTRptStaUseFrm], [FTRptTblView], [FTRptFilterCol], [FTRptFileName], [FTRptStaShwBch], [FTRptStaShwYear], [FTRptSeqNo], [FTRptStaUse], [FTLicPdtCode]) VALUES ('004001014', '004', '004001', 'rptCrdTopUp', '', '', '1,6,2,3,4,16,18,19', '', '1', '1', '14', '1', 'SB-RPT004001014');
INSERT INTO [TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) VALUES ('004001014', '1', 'รายงาน - การเติมเงิน', NULL);
INSERT INTO [TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) VALUES ('004001014', '2', 'Report - Topup', '');

UPDATE TSysReport  SET FTRptStaUse = '1' WHERE FTGrpRptModCode='004' AND FTGrpRptCode = '004001'
UPDATE TOP(1) [TSysReport] SET [FTRptCode]='004001014', [FTGrpRptModCode]='004', [FTGrpRptCode]='004001', [FTRptRoute]='rptCrdTopUp', [FTRptStaUseFrm]='', [FTRptTblView]='', [FTRptFilterCol]='1,6,2,3,4,16,19', [FTRptFileName]='', [FTRptStaShwBch]='1', [FTRptStaShwYear]='1', [FTRptSeqNo]='14', [FTRptStaUse]='1', [FTLicPdtCode]='SB-RPT004001014' WHERE ([FTRptCode]='004001014');
UPDATE TOP(1) [TSysReport] SET [FTRptCode]='004001012', [FTGrpRptModCode]='004', [FTGrpRptCode]='004001', [FTRptRoute]='rptCrdCheckPrepaid', [FTRptStaUseFrm]='', [FTRptTblView]='', [FTRptFilterCol]='1,4,16', [FTRptFileName]='', [FTRptStaShwBch]='1', [FTRptStaShwYear]='1', [FTRptSeqNo]='12', [FTRptStaUse]='0', [FTLicPdtCode]='SB-RPT004001012' WHERE ([FTRptCode]='004001012');


--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '00.01.18', getdate() , 'update report card', 'Nattakit K.');
END
GO



IF NOT EXISTS(SELECT FTSppCode FROM TSysPortPrn WHERE FTSppCode='SPP_R210') BEGIN	 
	INSERT INTO TSysPortPrn (FTSppCode,FTSppValue,FTSppRef,FTSppType,FTSppStaUse,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
	VALUES('SPP_R210','0','2','PRN','1','2020-10-01','','2020-10-01','')	 
END
GO  
IF NOT EXISTS(SELECT FTSppCode FROM TSysPortPrn_L WHERE FTSppCode='SPP_R210') BEGIN	
	INSERT INTO TSysPortPrn_L (FTSppCode,FNLngID,FTSppName) VALUES('SPP_R210',1,'เครื่องพิมพ์ Bixolon SPP R210')
	INSERT INTO TSysPortPrn_L (FTSppCode,FNLngID,FTSppName) VALUES('SPP_R210',2,'Bixolon SPP_R210')
END
GO
IF NOT EXISTS(SELECT * FROM TSysSyncModule WHERE FTAppCode = 'FC' AND FNSynSeqNo = 111) BEGIN
	INSERT INTO TSysSyncModule(FTAppCode,FNSynSeqNo) VALUES('FC',111)
END