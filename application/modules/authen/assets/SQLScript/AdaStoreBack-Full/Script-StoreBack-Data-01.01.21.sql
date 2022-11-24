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




IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.06') BEGIN

UPDATE [TSysReport] SET [FTRptCode]='001002002', [FTGrpRptModCode]='001', [FTGrpRptCode]='001002', [FTRptRoute]='rtpMovePosVD', [FTRptStaUseFrm]='', [FTRptTblView]='', [FTRptFilterCol]='1,6,2,3,5,12,13,28,49,9,53', [FTRptFileName]='', [FTRptStaShwBch]='1', [FTRptStaShwYear]='1', [FTRptSeqNo]='2', [FTRptStaUse]='1', [FTLicPdtCode]='SB-RPT001002002' WHERE ([FTRptCode]='001002002');
UPDATE [TSysReport] SET [FTRptCode]='001001002', [FTGrpRptModCode]='001', [FTGrpRptCode]='001001', [FTRptRoute]='rptRptSaleByProduct', [FTRptStaUseFrm]='', [FTRptTblView]='', [FTRptFilterCol]='1,6,2,3,26,13,8,9,4,53', [FTRptFileName]='', [FTRptStaShwBch]='1', [FTRptStaShwYear]='1', [FTRptSeqNo]='2', [FTRptStaUse]='1', [FTLicPdtCode]='SB-RPT001001002' WHERE ([FTRptCode]='001001002');
INSERT INTO [TCNSRptSpc_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptRmk]) VALUES ('SPCANI001', '1', 'รายงาน-ภาษีขายประจำเดือน', NULL);
INSERT INTO [TCNSRptSpc] ([FTAgnCode], [FTBchCode], [FTMerCode], [FTShpCode], [FNRptGrpSeq], [FTRptGrpCode], [FNRptSeq], [FTRptCode], [FTRptRoute], [FTRptFilterCol], [FTRptStaActive], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES (NULL, NULL, NULL, NULL, '1', 'SPC001', '1', 'SPCANI001', 'rtpPssVatByMonth', '1,6,2,3,5,28', '1', NULL, NULL, NULL, NULL);

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.06', getdate() , 'ปรับ Config ตาราง TCNSLimitHD', 'Nattakit K.');
END
GO





IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.07') BEGIN

INSERT INTO TSysMenuList (FTGmnCode,FTMnuParent,FTMnuCode,FTLicPdtCode,FNMnuSeq,FTMnuCtlName,FNMnuLevel,FTMnuStaPosHpm,FTMnuStaPosFhn,FTMnuStaSmartHpm,FTMnuStaSmartFhn,FTMnuStaMoreHpm,FTMnuStaMoreFhn,FTMnuType,FTMnuStaAPIPos,FTMnuStaAPISmart,FTMnuStaUse,FTMnuPath,FTGmnModCode,FTMnuImgPath)
VALUES('RPT','RPT','RPT007','SB-GRPRPT007','8','rptReport/007/0/0','0','Y','Y','Y','Y','Y','Y','1','Y','Y','1','','RPT','')

INSERT INTO TSysMenuList_L (FTMnuCode,FNLngID,FTMnuName,FTMnuRmk)
VALUES ('RPT007','1','รายงานการซื้อ','NULL')

INSERT INTO TSysReport (FTRptCode,FTGrpRptModCode,FTGrpRptCode,FTRptRoute,FTRptStaUseFrm,FTRptTblView,FTRptFilterCol,FTRptFileName,FTRptStaShwBch,FTRptStaShwYear,FTRptSeqNo,FTRptStaUse,FTLicPdtCode)
VALUES ('007001001','007','007001','rptPurSplByPdt','NULL','NULL','1,2,4,8,9,13,49,50,53,54,56,57,63,64,65,66','NULL','1','1','1','1','SB-RPT007001001')
INSERT INTO TSysReport (FTRptCode,FTGrpRptModCode,FTGrpRptCode,FTRptRoute,FTRptStaUseFrm,FTRptTblView,FTRptFilterCol,FTRptFileName,FTRptStaShwBch,FTRptStaShwYear,FTRptSeqNo,FTRptStaUse,FTLicPdtCode)
VALUES ('007001002','007','007001','rptxPurByPdt','NULL','NULL','1,2,4,8,9,13,49,50,53,54,56,57,63,64,65,66','NULL','1','1','4','1','SB-RPT007001002')
INSERT INTO TSysReport (FTRptCode,FTGrpRptModCode,FTGrpRptCode,FTRptRoute,FTRptStaUseFrm,FTRptTblView,FTRptFilterCol,FTRptFileName,FTRptStaShwBch,FTRptStaShwYear,FTRptSeqNo,FTRptStaUse,FTLicPdtCode)
VALUES ('007001003','007','007001','rptPurVat','NULL','NULL','1,2,4,50','NULL','1','1','1','1','SB-RPT007001003')

INSERT INTO TSysReportGrp (FTGrpRptCode,FNGrpRptShwSeq,FTGrpRptStaUse,FTGrpRptModCode)
VALUES ('007001','1','1','007')

INSERT INTO TSysReportModule (FTGrpRptModCode,FNGrpRptModShwSeq,FTGrpRptModStaUse,FTGrpRptModRoute)
VALUES ('007','8','1','rptReport/007/0/0')

INSERT INTO TSysReport_L (FTRptCode,FNLngID,FTRptName,FTRptDes)
VALUES ('007001001','1','รายงาน - ยอดซื้อตามผู้จำหน่าย ตามสินค้า','NULL')
INSERT INTO TSysReport_L (FTRptCode,FNLngID,FTRptName,FTRptDes)
VALUES ('007001001','2','Report - Purchase Amount By Vendor By Product','NULL')
INSERT INTO TSysReport_L (FTRptCode,FNLngID,FTRptName,FTRptDes)
VALUES ('007001002','1','รายงาน - สรุปยอดซื้อตามสินค้า','')
INSERT INTO TSysReport_L (FTRptCode,FNLngID,FTRptName,FTRptDes)
VALUES ('007001002','2','Report - Purchase summary by item','')
INSERT INTO TSysReport_L (FTRptCode,FNLngID,FTRptName,FTRptDes)
VALUES ('007001003','1','รายงาน - ภาษีซื้อ','NULL')
INSERT INTO TSysReport_L (FTRptCode,FNLngID,FTRptName,FTRptDes)
VALUES ('007001003','2','Report - Pur Vat','NULL')

INSERT INTO TSysReportGrp_L (FTGrpRptCode,FNLngID,FTGrpRptName)
VALUES ('007001','1','รายงานการซื้อ')
INSERT INTO TSysReportGrp_L (FTGrpRptCode,FNLngID,FTGrpRptName)
VALUES ('007001','2','Report Buy')

INSERT INTO TSysReportModule_L (FTGrpRptModCode,FNGrpRptModName,FNLngID)
VALUES ('007','รายงานการซื้อ','1')
INSERT INTO TSysReportModule_L (FTGrpRptModCode,FNGrpRptModName,FNLngID)
VALUES ('007','รายงานการซื้อ','2')

INSERT INTO TSysReport ([FTRptCode], [FTGrpRptModCode], [FTGrpRptCode], [FTRptRoute], [FTRptStaUseFrm], [FTRptTblView], [FTRptFilterCol], [FTRptFileName], [FTRptStaShwBch], [FTRptStaShwYear], [FTRptSeqNo], [FTRptStaUse], [FTLicPdtCode]) VALUES ('009001013', '009', '009001', 'rptRptInventoryTranfer', NULL, NULL, '1,4,13,78,79', NULL, '1', '1', 13, '1', 'SB-RPT001002038')

INSERT INTO TSysReport_L ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) VALUES ('009001013', 1, 'รายงาน - โอนสินค้าระหว่างคลัง', NULL)

INSERT INTO TSysReportGrp ([FTGrpRptCode], [FNGrpRptShwSeq], [FTGrpRptStaUse], [FTGrpRptModCode]) VALUES ('009001', 1, '1', '009')

INSERT INTO TSysReportGrp_L ([FTGrpRptCode], [FNLngID], [FTGrpRptName]) VALUES ('009001', 1, 'รายงานคลังสินค้า')
INSERT INTO TSysReportGrp_L ([FTGrpRptCode], [FNLngID], [FTGrpRptName]) VALUES ('009001', 2, 'Report Wahouse')

INSERT INTO TSysReportModule ([FTGrpRptModCode], [FNGrpRptModShwSeq], [FTGrpRptModStaUse], [FTGrpRptModRoute]) VALUES ('009', 4, '1', 'rptReport/009/0/0')

INSERT INTO TSysReportModule_L ([FTGrpRptModCode], [FNGrpRptModName], [FNLngID]) VALUES ('009', 'รายงานคลังสินค้า', '1')
INSERT INTO TSysReportModule_L ([FTGrpRptModCode], [FNGrpRptModName], [FNLngID]) VALUES ('009', 'Wahouse', '2')

INSERT INTO TSysMenuList ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('RPT', 'RPT', 'RPT009', 'SB-GRPRPT009', 4, 'rptReport/009/0/0', 0, 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'RPT', '')

INSERT INTO TSysMenuList_L ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('RPT009', 1, 'รายงานคลังสินค้า', NULL)
INSERT INTO TSysMenuList_L ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('RPT009', 2, 'Report Wahouse', NULL)

INSERT INTO TSysReportFilter ([FTRptFltCode], [FTRptFltStaFrm], [FTRptFltStaTo], [FTRptGrpFlt]) VALUES (67, 1, 1, 'G9')
INSERT INTO TSysReportFilter ([FTRptFltCode], [FTRptFltStaFrm], [FTRptFltStaTo], [FTRptGrpFlt]) VALUES (68, 1, 1, 'G9')


INSERT INTO TSysReportFilter_L ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES (67, '1', 'กลุ่มผู้จำหน่าย')
INSERT INTO TSysReportFilter_L ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES (67, '2', 'Supplier Group')
INSERT INTO TSysReportFilter_L ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES (68, '1', 'ประเภทผู้จำหน่าย')
INSERT INTO TSysReportFilter_L ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES (68, '2', 'Supplier Type')

update TSysReport set FTRptFilterCol = '1,2,4,8,9,13,49,50,53,54,56,57,67,68,69,70' where FTRptCode IN ('007001001','007001002')
update TSysReportFilter set FTRptGrpFlt = 'G9' where FTRptFltCode = '50'

INSERT INTO TSysReportFilter ([FTRptFltCode], [FTRptFltStaFrm], [FTRptFltStaTo], [FTRptGrpFlt]) VALUES (69, 1, 0, 'G10')
INSERT INTO TSysReportFilter ([FTRptFltCode], [FTRptFltStaFrm], [FTRptFltStaTo], [FTRptGrpFlt]) VALUES (70, 1, 0, 'G4')

INSERT INTO TSysReportFilter_L ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES (69, '1', 'สถานะเอกสาร')
INSERT INTO TSysReportFilter_L ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES (69, '2', 'Doc Status')
INSERT INTO TSysReportFilter_L ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES (70, '1', 'สถานะ รับ/จ่ายเงิน')
INSERT INTO TSysReportFilter_L ([FTRptFltCode], [FNLngID], [FTRptFltName]) VALUES (70, '2', 'Status Get Money / Pay')


--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.07', getdate() , 'เพิ่มรายงานการซื้อและคลัง', 'Nattakit K.');
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.08') BEGIN

UPDATE TCNSRptSpc SET FTRptStaActive = 0 

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.08', getdate() , 'ปิดรายงานพิเศษ', 'Nattakit K.');
END
GO




IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.09') BEGIN

INSERT INTO [TSysReport] ([FTRptCode], [FTGrpRptModCode], [FTGrpRptCode], [FTRptRoute], [FTRptStaUseFrm], [FTRptTblView], [FTRptFilterCol], [FTRptFileName], [FTRptStaShwBch], [FTRptStaShwYear], [FTRptSeqNo], [FTRptStaUse], [FTLicPdtCode]) VALUES ('001001041', '001', '001001', 'rptSalTimePrdTmp', NULL, NULL, '1,2,3,4,26,13', NULL, '1', '1', '35', '1', 'SB-RPT001001041');
INSERT INTO [TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) VALUES ('001001041', '1', 'รายงาน - ยอดขายตามช่วงเวลา', NULL);
INSERT INTO [TSysReport_L] ([FTRptCode], [FNLngID], [FTRptName], [FTRptDes]) VALUES ('001001041', '2', 'Reports - Sales by period', '');

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.09', getdate() , 'เปิด รายงาน - ยอดขายตามช่วงเวลา', 'Nattakit K.');
END
GO

IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.10') BEGIN

IF NOT EXISTS(SELECT FTLblCode FROM TCNSLabelFmt WHERE FTLblCode = 'L016') BEGIN
	INSERT [dbo].[TCNSLabelFmt] ([FTLblCode], [FTLblRptNormal], [FTLblRptPmt], [FTLblStaUse], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy], [FNLblQtyPerPageNml], [FNLblQtyPerPagePmt], [FTLblVerGroup], [FTLblSizeWH]) 
	VALUES (N'L016', N'Frm_ALLPdtPriceTag3.2x2.5.mrt', N'', N'1', CAST(N'2022-08-16T00:00:00.000' AS DateTime), N'Junthon M.', CAST(N'2022-08-16T00:00:00.000' AS DateTime), N'Junthon M.', 3, NULL, N'STD', N'3.2 x 2.5 cm.')
END

IF NOT EXISTS(SELECT FTLblCode FROM TCNSLabelFmt_L WHERE FTLblCode = 'L016') BEGIN
	INSERT [dbo].[TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES (N'L016', 1, N'สติ๊กเกอร์บาร์โค้ด ขนาด 3.2*2.5 ซม', N'')
	INSERT [dbo].[TCNSLabelFmt_L] ([FTLblCode], [FNLngID], [FTLblName], [FTLblRmk]) VALUES (N'L016', 2, N'Ticket Price 3.2*2.5 CM', N'')
END

IF EXISTS(SELECT FTLblCode FROM TCNSLabelFmt_L WHERE FTLblCode = 'L010' AND FNLngID = 1) BEGIN
	UPDATE TCNSLabelFmt_L SET FTLblName = 'สติ๊กเกอร์บาร์โค้ด ขนาด 3.2*2.4 ซม' WHERE FTLblCode = 'L010' AND FNLngID = 1
END

INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.10', getdate() , 'เปิด รายงาน - ยอดขายตามช่วงเวลา', 'Nattakit K.')
END
GO

IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.11') BEGIN
UPDATE TSysConfig
SET FTSysStaAlwEdit = '2'
,FTSysStaUsrValue = '2'
,FDLastUpdOn = GETDATE()
,FTLastUpdBy = 'Admin'
WHERE FTSysCode = 'bPS_StaChkPosReg'
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.11', getdate() , 'ปิด config ตรวจสอบลงทะเบียนจุดขาย', 'Nattakit K.')
END
GO

IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.12') BEGIN

UPDATE TSysReport SET FTRptFilterCol = '1,4' WHERE FTRptCode='004001017'
UPDATE TSysReport SET FTRptFilterCol = '1,2,3,4,6,16,17' WHERE FTRptCode = '004001001'

INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.12', getdate() , 'ปรับฟิลเตอร์รายงาน 004001017', 'Nattakit K.')
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.13') BEGIN

IF NOT EXISTS(SELECT FTSysCode FROM TPSMFuncDT WHERE FTSysCode = 'KB030' AND FTGhdCode='031') BEGIN
INSERT INTO [TPSMFuncDT] ([FTGhdCode], [FTSysCode], [FTLicPdtCode], [FNGdtPage], [FNGdtDefSeq], [FNGdtUsrSeq], [FNGdtBtnSizeX], [FNGdtBtnSizeY], [FTGdtCallByName], [FTGdtStaUse], [FNGdtFuncLevel], [FTGdtSysUse]) 
VALUES ('031', 'KB030', 'SF-PS031KB030', '1', '21', '21', '1', '1', 'C_KBDxCreditSale', '1', '1', '1')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('031', 'KB030', '1', 'เงินเชื่อ')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('031', 'KB030', '2', 'Credit Sale')

END

IF NOT EXISTS(SELECT FTSysCode FROM TPSMFuncDT WHERE FTSysCode = 'KB030' AND FTGhdCode='064') BEGIN
INSERT INTO [TPSMFuncDT] ([FTGhdCode], [FTSysCode], [FTLicPdtCode], [FNGdtPage], [FNGdtDefSeq], [FNGdtUsrSeq], [FNGdtBtnSizeX], [FNGdtBtnSizeY], [FTGdtCallByName], [FTGdtStaUse], [FNGdtFuncLevel], [FTGdtSysUse]) 
VALUES ('064', 'KB030', 'SF-SB064KB030', '1', '9', '9', '0', '0', '', '1', '1', '1')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('064', 'KB030', '1', 'แต้มพิเศษ')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('064', 'KB030', '2', 'Special points')

END

IF NOT EXISTS(SELECT FTSysCode FROM TPSMFuncDT WHERE FTSysCode = 'KB058' AND FTGhdCode='090') BEGIN
INSERT INTO [TPSMFuncDT] ([FTGhdCode], [FTSysCode], [FTLicPdtCode], [FNGdtPage], [FNGdtDefSeq], [FNGdtUsrSeq], [FNGdtBtnSizeX], [FNGdtBtnSizeY], [FTGdtCallByName], [FTGdtStaUse], [FNGdtFuncLevel], [FTGdtSysUse]) 
VALUES ('090', 'KB058', 'KB058090', '1', '1', '1', '0', '0', 'C_KBCbAlwSalePriZero', '1', '1', '1')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('090', 'KB058', '1', 'อนุญาต ให้ขายสินค้าราคาศูนย์')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('090', 'KB058', '2', 'Allow to sale product zero price')

END

IF NOT EXISTS(SELECT FTSysCode FROM TPSMFuncDT WHERE FTSysCode = 'KB058' AND FTGhdCode='091') BEGIN
INSERT INTO [TPSMFuncDT] ([FTGhdCode], [FTSysCode], [FTLicPdtCode], [FNGdtPage], [FNGdtDefSeq], [FNGdtUsrSeq], [FNGdtBtnSizeX], [FNGdtBtnSizeY], [FTGdtCallByName], [FTGdtStaUse], [FNGdtFuncLevel], [FTGdtSysUse]) 
VALUES ('091', 'KB058', 'KB058090', '1', '1', '1', '0', '0', 'C_KBCbAlwSalePriZero', '1', '1', '1')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('091', 'KB058', '1', 'อนุญาต ให้ขายสินค้าราคาศูนย์')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('091', 'KB058', '2', 'Allow to sale product zero price')
END

IF NOT EXISTS(SELECT FTSysCode FROM TPSMFuncDT WHERE FTSysCode = 'KB101' AND FTGhdCode='088') BEGIN
INSERT INTO [TPSMFuncDT] ([FTGhdCode], [FTSysCode], [FTLicPdtCode], [FNGdtPage], [FNGdtDefSeq], [FNGdtUsrSeq], [FNGdtBtnSizeX], [FNGdtBtnSizeY], [FTGdtCallByName], [FTGdtStaUse], [FNGdtFuncLevel], [FTGdtSysUse]) 
VALUES ('088', 'KB101', '', '1', '0', '0', '0', '0', 'C_KBDxAlwEditWHT', '1', '1', '1')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('088', 'KB101', '1', 'อนุญาต แก้ไขยอดหักภาษี ณ ที่จ่าย')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('088', 'KB101', '2', 'Allow edit Withholding tax amount')
END

IF NOT EXISTS(SELECT FTSysCode FROM TPSMFuncDT WHERE FTSysCode = 'KB102' AND FTGhdCode='088') BEGIN
INSERT INTO [TPSMFuncDT] ([FTGhdCode], [FTSysCode], [FTLicPdtCode], [FNGdtPage], [FNGdtDefSeq], [FNGdtUsrSeq], [FNGdtBtnSizeX], [FNGdtBtnSizeY], [FTGdtCallByName], [FTGdtStaUse], [FNGdtFuncLevel], [FTGdtSysUse]) 
VALUES ('088', 'KB102', '', '1', '0', '0', '0', '0', 'C_KBDxAlwRetSalDiffDate', '1', '1', '1')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('088', 'KB102', '1', 'อนุญาต คืนบิลขายข้ามวัน')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('088', 'KB102', '2', 'Allow return sale different date')

END


IF NOT EXISTS(SELECT FTSysCode FROM TPSMFuncDT WHERE FTSysCode = 'KB103' AND FTGhdCode='088') BEGIN
INSERT INTO [TPSMFuncDT] ([FTGhdCode], [FTSysCode], [FTLicPdtCode], [FNGdtPage], [FNGdtDefSeq], [FNGdtUsrSeq], [FNGdtBtnSizeX], [FNGdtBtnSizeY], [FTGdtCallByName], [FTGdtStaUse], [FNGdtFuncLevel], [FTGdtSysUse]) 
VALUES ('088', 'KB103', '', '1', '0', '0', '0', '0', 'C_KBDxAlwSalOverCrd', '1', '1', '1')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('088', 'KB103', '1', 'อนุญาต ขายเกินวงเงินเครดิต')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('088', 'KB103', '2', 'Allow sale over credit')

END

IF NOT EXISTS(SELECT FTSysCode FROM TPSMFuncDT WHERE FTSysCode = 'KB104' AND FTGhdCode='088') BEGIN
INSERT INTO [TPSMFuncDT] ([FTGhdCode], [FTSysCode], [FTLicPdtCode], [FNGdtPage], [FNGdtDefSeq], [FNGdtUsrSeq], [FNGdtBtnSizeX], [FNGdtBtnSizeY], [FTGdtCallByName], [FTGdtStaUse], [FNGdtFuncLevel], [FTGdtSysUse]) 
VALUES ('088', 'KB104', '', '1', '0', '0', '0', '0', 'C_KBDxAlwResetDocPrint', '1', '1', '1')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('088', 'KB104', '1', 'อนุญาต ปรับการพิมพ์เอกสารเป็นต้นฉบับ')
INSERT INTO [TPSMFuncDT_L] ([FTGhdCode], [FTSysCode], [FNLngID], [FTGdtName]) VALUES ('088', 'KB104', '2', 'Allow Change doucument printing to master')
END

IF NOT EXISTS(SELECT FTGhdCode FROM TPSMFuncHD WHERE FTGhdCode='088') BEGIN
INSERT INTO [TPSMFuncHD] ([FTGhdCode], [FTGhdApp], [FTKbdScreen], [FTKbdGrpName], [FNGhdMaxPerPage], [FTGhdLayOut], [FNGhdMaxLayOutX], [FNGhdMaxLayOutY], [FTGhdStaAlwChg], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
VALUES ('088', 'PS', 'ROLE', 'ROLE', '0', 'ALL', '0', '0', '0', '2022-09-27 20:56:17.000', 'Jirayu S.', '2022-09-21 10:32:58.977', 'Jirayu S.')
END

IF NOT EXISTS(SELECT FTGhdCode FROM TPSMFuncHD WHERE FTGhdCode='090') BEGIN
INSERT INTO [TPSMFuncHD] ([FTGhdCode], [FTGhdApp], [FTKbdScreen], [FTKbdGrpName], [FNGhdMaxPerPage], [FTGhdLayOut], [FNGhdMaxLayOutX], [FNGhdMaxLayOutY], [FTGhdStaAlwChg], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
VALUES ('090', 'PS', 'SALE', 'ROLE', '0', 'ALL', '0', '0', '1', '2022-08-10 23:46:00.000', 'Junthon M.', '2022-08-10 23:46:00.000', 'Junthon M.')
END
IF NOT EXISTS(SELECT FTGhdCode FROM TPSMFuncHD WHERE FTGhdCode='091') BEGIN
INSERT INTO [TPSMFuncHD] ([FTGhdCode], [FTGhdApp], [FTKbdScreen], [FTKbdGrpName], [FNGhdMaxPerPage], [FTGhdLayOut], [FNGhdMaxLayOutX], [FNGhdMaxLayOutY], [FTGhdStaAlwChg], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
VALUES ('091', 'VS', 'SALE', 'ROLE', '0', 'ALL', '0', '0', '1', '2022-08-10 23:46:00.000', 'Junthon M.', '2022-08-10 23:46:00.000', 'Junthon M.')
END


	INSERT INTO [TCNTUsrFuncRpt] ([FTRolCode], [FTUfrType], [FTUfrGrpRef], [FTUfrRef], [FTGhdApp], [FTUfrStaAlw], [FTUfrStaFavorite], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES ('00002', '1', '088', 'KB102', 'PS', '1', '0', '2022-09-30 11:55:14.223', '00002', '2022-09-30 11:55:14.223', '00002')
	INSERT INTO [TCNTUsrFuncRpt] ([FTRolCode], [FTUfrType], [FTUfrGrpRef], [FTUfrRef], [FTGhdApp], [FTUfrStaAlw], [FTUfrStaFavorite], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES ('00002', '1', '088', 'KB103', 'PS', '1', '0', '2022-09-30 11:55:14.223', '00002', '2022-09-30 11:55:14.223', '00002')
	INSERT INTO [TCNTUsrFuncRpt] ([FTRolCode], [FTUfrType], [FTUfrGrpRef], [FTUfrRef], [FTGhdApp], [FTUfrStaAlw], [FTUfrStaFavorite], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES ('00002', '1', '090', 'KB058', 'PS', '1', '0', '2022-09-30 11:55:14.227', '00002', '2022-09-30 11:55:14.227', '00002')
	INSERT INTO [TCNTUsrFuncRpt] ([FTRolCode], [FTUfrType], [FTUfrGrpRef], [FTUfrRef], [FTGhdApp], [FTUfrStaAlw], [FTUfrStaFavorite], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
	VALUES ('00002', '1', '091', 'KB058', 'VS', '1', '0', '2022-09-30 11:55:14.263', '00002', '2022-09-30 11:55:14.263', '00002')

IF NOT EXISTS(SELECT FTSysCode FROM TSysConfig WHERE FTSysCode='bPS_AlwSalePriZero') BEGIN
INSERT INTO [TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) 
VALUES ('bPS_AlwSalePriZero', 'PS', 'POS', '1', 'MPOS', '1', '4', '1', '1', '', '1', '', '2022-08-11 01:03:23.000', '00011', '2022-08-09 00:00:00.000', 'Junthon M.')
INSERT INTO [TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk])
 VALUES ('bPS_AlwSalePriZero', 'PS', 'POS', '1', '1', 'อนุญาต ให้ขายสินค้าราคาศูนย์', '1 : อนุญาต, 0 : ไม่อนุญาต', '')
INSERT INTO [TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk])
 VALUES ('bPS_AlwSalePriZero', 'PS', 'POS', '1', '2', 'Allow to sale product zero price', '1 : Allow, 0 : Not  Allow', '')
END


INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.13', getdate() , 'ปรับฟิลเตอร์รายงาน 004001017', 'Nattakit K.')
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.14') BEGIN
	ALTER TABLE TFCTRptCrdTmp ALTER COLUMN FTDocCreateBy varchar(255)
	ALTER TABLE TFCTRptCrdTmp ALTER COLUMN FTUsrCreate varchar(255)
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.14', getdate() , 'ปรับคอลัม UsrName varchar(255)', 'Napat')
END
GO

IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.15') BEGIN
	UPDATE TSysReport SET FTRptFilterCol = '1,3,4,16,17' WHERE FTRptCode = '004001001'
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.15', getdate() , 'ปรับฟิวเตอร์รายงานข้อมูลการใช้บัตร', 'Ice')
END



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.16') BEGIN

	IF NOT EXISTS(SELECT FTShwTblDT, FTShwFedShw FROM TSysShwDT WHERE FTShwTblDT='TCNTPdtTwxDT' AND FTShwFedShw = 'FTXtdStaPrcStk') BEGIN
		INSERT INTO [TSysShwDT] ([FTShwTblDT], [FNShwSeq], [FTShwFedShw], [FTShwFedStaUsed], [FTShwFedSetByDef], [FTShwFedSetByUsr], [FNShwColWidth], [FTShwStaAlwEdit]) 
		VALUES ('TCNTPdtTwxDT', 15, 'FTXtdStaPrcStk', '1', '1', '1', '0', '0')
	END

	IF NOT EXISTS(SELECT FTShwTblDT, FTShwFedShw FROM TSysShwDT_L WHERE FTShwTblDT='TCNTPdtTwxDT' AND FTShwFedShw = 'FTXtdStaPrcStk') BEGIN
		INSERT INTO [TSysShwDT_L] ([FTShwTblDT], [FNShwSeq], [FTShwFedShw], [FNLngID], [FTShwNameDef], [FTShwNameUsr]) 
		VALUES ('TCNTPdtTwxDT', 15, 'FTXtdStaPrcStk', '1', 'สถานะสต็อค', 'สถานะสต็อค')
		
		INSERT INTO [TSysShwDT_L] ([FTShwTblDT], [FNShwSeq], [FTShwFedShw], [FNLngID], [FTShwNameDef], [FTShwNameUsr]) 
		VALUES ('TCNTPdtTwxDT', 15, 'FTXtdStaPrcStk', '2', 'Stock Status', 'Stock Status')
	END
--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.16', getdate() , 'เพิ่มข้อมูลตั้งต้นเอกสาร', 'Nattakit K.')
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.17') BEGIN
INSERT INTO  [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('ARS', 'ARS', 'ARS014', 'SB-ARARS014', '4', 'cstMngCredit/0/0', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'AD', '');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('ARS014', '1', 'จัดการวงเงินเครดิต', 'NULL');
INSERT INTO  [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('ARS014', '2', 'Change Customer Credit', 'NULL');
--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.17', getdate() , 'เพิ่ม จัดการวงเงินเครดิต', 'Nattakit K.')
END



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.18') BEGIN
UPDATE TSysRcvFmt 
SET FTFmtStaUsed = '2'
WHERE FTFmtCode = '005'
UPDATE TSysRcvFmt 
SET FTFmtStaUsed = '2'
WHERE FTFmtCode IN ('005','003','006','007','008','009','010','014','015','016','017','018','019','024','025','026','027','028')
--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.18', getdate() , 'Update TsysRcvFmt แก้เรื่อง เงินโอน', 'Zen')
END



IF NOT EXISTS(SELECT FTSysCode FROM TPSMFuncDT WHERE FTLicPdtCode = 'SF-VS059KB051') BEGIN
 INSERT [dbo].[TPSMFuncDT] ([FTGhdCode], [FTSysCode], [FTLicPdtCode], [FNGdtPage], [FNGdtDefSeq], [FNGdtUsrSeq], [FNGdtBtnSizeX], [FNGdtBtnSizeY], [FTGdtCallByName], [FTGdtStaUse], [FNGdtFuncLevel], [FTGdtSysUse]) VALUES (N'059', N'KB051', N'SF-VS059KB051', 1, 9, 9, 1, 1, N'C_KBDxStoreDebit', N'1', 1, N'1')
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.19') BEGIN

UPDATE TSysReport SET FTGrpRptModCode = '009',FTGrpRptCode='009001'  WHERE FTGrpRptCode = '001002'

UPDATE TSysReport SET FTGrpRptModCode = '009',FTGrpRptCode='009001'  WHERE FTRptCode IN( '001003002' , '001003003')
--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.19', getdate() , 'แก้ไขกลุ่มของรายงานคลังที่อยู่ในหมวดเมนูรายงานขาย', 'Nale')
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.20') BEGIN

INSERT INTO [TSysConfig] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FTGmnCode], [FTSysStaAlwEdit], [FTSysStaDataType], [FNSysMaxLength], [FTSysStaDefValue], [FTSysStaDefRef], [FTSysStaUsrValue], [FTSysStaUsrRef], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('tCN_AlwSeePdtCenter', 'CN', 'Company', '1', 'COMP', '0', '0', '0', NULL, NULL, '1', NULL, '2022-11-10 10:28:39.000', 'Nattakit', '2022-11-10 10:28:52.000', 'Nattakit');
INSERT INTO [TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES ('tCN_AlwSeePdtCenter', 'CN', 'Comppany', '1', '1', 'อนุญาตมองเห็นสินค้าส่วนกลาง', '1:อนุญาต , 2:ไม่อนุญาต', NULL);
INSERT INTO [TSysConfig_L] ([FTSysCode], [FTSysApp], [FTSysKey], [FTSysSeq], [FNLngID], [FTSysName], [FTSysDesc], [FTSysRmk]) VALUES ('tCN_AlwSeePdtCenter', 'CN', 'Comppany', '1', '2', 'Allowed to Product Center', '1 : Allow, 0 : Not  Allow', '');

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.20', getdate() , 'เพิ่ม OPTION Config KEY  tCN_AlwSeePdtCenter', 'Nale')
END
GO


IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.21') BEGIN
UPDATE [TSysReport] SET [FTRptCode]='009001013', [FTGrpRptModCode]='009', [FTGrpRptCode]='009001', [FTRptRoute]='rptRptInventoryTranfer', [FTRptStaUseFrm]=NULL, [FTRptTblView]=NULL, [FTRptFilterCol]='1,4,13,78,79,33,34,8,9,53', [FTRptFileName]=NULL, [FTRptStaShwBch]='1', [FTRptStaShwYear]='1', [FTRptSeqNo]='13', [FTRptStaUse]='1', [FTLicPdtCode]='SB-RPT001002038' WHERE ([FTRptCode]='009001013');

--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.21', getdate() , 'รายงานการโอนสินค้าระหว่างคลังเพิ่ม Filter ยี่ห้อประเภทกลุ่มของสินค้า', 'Nale')
END
GO



IF NOT EXISTS(SELECT FTUphVersion FROM TCNTUpgradeHisTmp WHERE FTUphVersion=  '01.01.22') BEGIN


INSERT INTO [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('SYS007', '1', 'รูปแบบฟอร์มพิเศษ', NULL);
INSERT INTO [TSysMenuList_L] ([FTMnuCode], [FNLngID], [FTMnuName], [FTMnuRmk]) VALUES ('SYS007', '2', 'Forms', '');
INSERT INTO [TSysMenuList] ([FTGmnCode], [FTMnuParent], [FTMnuCode], [FTLicPdtCode], [FNMnuSeq], [FTMnuCtlName], [FNMnuLevel], [FTMnuStaPosHpm], [FTMnuStaPosFhn], [FTMnuStaSmartHpm], [FTMnuStaSmartFhn], [FTMnuStaMoreHpm], [FTMnuStaMoreFhn], [FTMnuType], [FTMnuStaAPIPos], [FTMnuStaAPISmart], [FTMnuStaUse], [FTMnuPath], [FTGmnModCode], [FTMnuImgPath]) VALUES ('SYS', 'SYS', 'SYS007', 'SB-MASSYS008', '7', 'forms/0/0', '1', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '1', 'Y', 'Y', '1', '', 'MAS', '');

INSERT INTO [TCNTAuto] ([FTSatTblName], [FTSatFedCode], [FTSatStaDocType], [FTSatGroup], [FTGmnCode], [FTSatDocTypeName], [FTSatStaAlwChr], [FTSatStaAlwBch], [FTSatStaAlwPosShp], [FTSatStaAlwYear], [FTSatStaAlwMonth], [FTSatStaAlwDay], [FTSatStaAlwSep], [FTSatStaDefUsage], [FTSatDefChar], [FTSatDefBch], [FTSatDefPosShp], [FTSatDefYear], [FTSatDefMonth], [FTSatDefDay], [FTSatDefSep], [FTSatDefNum], [FTSatDefFmtAll], [FNSatMaxFedSize], [FNSatMinRunning], [FTSatUsrChar], [FTSatUsrBch], [FTSatUsrPosShp], [FTSatUsrYear], [FTSatUsrMonth], [FTSatUsrDay], [FTSatUsrSep], [FTSatUsrNum], [FTSatUsrFmtAll], [FTSatStaReset], [FTSatStaRunBch], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('TRPTRptFmtUsr', 'FTRfuCode', '0', '1', 'MSAL', '', '0', '0', '0', '0', '0', '0', '0', '0', '', '0', '0', '0', '0', '0', '0', '00001', '#####', '5', '5', '', '0', '0', '0', '0', '0', '0', '00001', '#####', '', '0', '2020-12-23 00:00:00.000', '', '2020-12-23 00:00:00.000', '');



INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00001', 'ฟอร์มใบกำกับภาษี', '1', '1', '1', NULL, 'Frm_PSInvoiceSale.mrt', 'formreport/TaxInvoice', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00002', 'ฟอร์มใบลดหนี้', '1', '1', '1', NULL, 'Frm_PSInvoiceRefund.mrt', 'formreport/TaxInvoice_refund', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00003', 'ฟอร์มใบอย่างย่อ', '1', '1', '1', NULL, 'Frm_PSInvoiceSale_ABB.mrt', 'formreport/InvoiceSaleABB', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00004', 'ฟอร์มใบปรับราคาขาย', '1', '1', '1', '', 'Frm_SQL_ALLMPdtBillAdjustPrice.mrt', 'formreport/Frm_SQL_ALLMPdtBillAdjustPrice', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00005', 'ฟอร์มโปรโมชั่น', '1', '1', '1', NULL, 'Frm_SQL_ALLMPmt.mrt', 'formreport/Frm_SQL_ALLMPmt', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00006', 'ฟอร์มใบปรับราคาทุน', '1', '1', '1', '', 'FRM_SQL_ALLMPdtBillAdjustCost.mrt', 'formreport/FRM_SQL_ALLMPdtBillAdjustCost', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00007', 'ฟอร์มใบตรวจนับย่อย', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillSubChkStk.mrt', 'formreport/Frm_SQL_ALLMPdtBillSubChkStk', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00008', 'ฟอร์มใบตรวจนับรวม', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillSumChkStk.mrt', 'formreport/Frm_SQL_ALLMPdtBillSumChkStk', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00009', 'ฟอร์มใบตรวจนับ-ตู้', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillChkStkVD.mrt', 'formreport/Frm_SQL_ALLMPdtBillChkStkVD', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00010', 'เปลี่ยนบัตรเงินสด', '1', '1', '1', NULL, 'Frm_SQL_FCCardChgCash.mrt', 'formreport/Frm_SQL_FCCardChgCash', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00011', 'สร้างบัตร', '1', '1', '1', NULL, 'Frm_SQL_FCCardNew.mrt', 'formreport/Frm_SQL_FCCardNew', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00012', 'เบิกบัตรเงินสด', '1', '1', '1', NULL, 'Frm_SQL_FCCardWithdrawCash.mrt', 'formreport/Frm_SQL_FCCardWithdrawCash', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00013', 'คืนเงินสด', '1', '1', '1', NULL, 'Frm_SQL_FCCardRefundCash.mrt', 'formreport/Frm_SQL_FCCardRefundCash', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00014', 'คืนบัตรเงินสด', '1', '1', '1', NULL, 'Frm_SQL_FCCardReturnCash.mrt', 'formreport/Frm_SQL_FCCardReturnCash', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00015', 'เปลี่ยนสถานะบัตร', '1', '1', '1', NULL, 'Frm_SQL_FCCardChgStaCashCrd.mrt', 'formreport/Frm_SQL_FCCardChgStaCashCrd', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00016', 'เติมเงิน', '1', '1', '1', NULL, 'Frm_SQL_FCCardTopUp.mrt', 'formreport/Frm_SQL_FCCardTopUp', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00017', 'เงื่อนไขการแลกแต้ม', '1', '1', '1', NULL, 'Frm_SQL_PSSRdPoint.mrt', 'formreport/Frm_SQL_PSSRdPoint', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00018', 'ฟอร์มกำหนดคูปอง', '1', '1', '1', NULL, 'Frm_SQL_FCCoupon.mrt', 'formreport/Frm_SQL_FCCoupon', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00019', 'ฟอร์มใบนำฝาก', '1', '1', '1', NULL, 'Frm_SQL_FCBnkDeposit.mrt', 'formreport/Frm_SQL_FCBnkDeposit', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00020', 'โอนสินค้าระหว่างสาขา', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillTnfBch.mrt', 'formreport/Frm_SQL_ALLMPdtBillTnfBch', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00021', 'ใบรับของใบซื้อ', '1', '1', '1', NULL, 'Frm_SQL_SMBillPi.mrt', 'formreport/Frm_SQL_SMBillPi', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00022', 'ฟอร์มใบสั่งซื้อ', '1', '1', '1', NULL, 'Frm_SQL_SMBillPO.mrt', 'formreport/Frm_SQL_SMBillPO', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00023', 'ใบเติมสินค้าแบบชุดVD', '1', '1', '1', NULL, 'Frm_SQL_SMBillRefillSet.mrt', 'formreport/Frm_SQL_SMBillRefillSet', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00024', 'ใบเติมสินค้า VD', '1', '1', '1', NULL, 'Frm_SQL_SMBillRefill.mrt', 'formreport/Frm_SQL_SMBillRefill', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00025', 'ใบจ่ายโอน - สาขา', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillTnfOutBch.mrt', 'formreport/Frm_SQL_ALLMPdtBillTnfOutBch', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00026', 'ใบรับโอน - สาขา', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillTnfInBch.mrt', 'formreport/Frm_SQL_ALLMPdtBillTnfInBch', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00027', 'ใบรับโอน - คลัง', '1', '1', '1', NULL, 'Frm_SQL_ALLBillGoodsRcv.mrt', 'formreport/Frm_SQL_ALLBillGoodsRcv', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00028', 'ใบรับเข้า - คลัง', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillTnfIn.mrt', 'formreport/Frm_SQL_ALLMPdtBillTnfIn', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00029', 'ใบนำสินค้าออก VD', '1', '1', '1', NULL, 'Frm_SQL_SMBillReFundVD.mrt', 'formreport/Frm_SQL_SMBillReFundVD', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00030', 'ใบจ่ายโอน - คลัง', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillTnfOutWah.mrt', 'formreport/Frm_SQL_ALLMPdtBillTnfOutWah', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00031', 'ใบเบิกออก - คลัง', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillTnfOut.mrt', 'formreport/Frm_SQL_ALLMPdtBillTnfOut', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00032', 'โปรโมชั่นบัตรเงินสด', '1', '1', '1', NULL, 'Frm_SQL_FCPmtCardCash.mrt', 'formreport/Frm_SQL_FCPmtCardCash', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00033', 'ฟอร์มตรวจนับสินค้า', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillChkStk.mrt', 'formreport/ALLMPdtBillChkStk', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00034', 'ฟอร์มใบสั่งขาย', '1', '1', '1', NULL, 'Frm_SQL_SMBillSO.mrt', 'formreport/SMBillSO', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00035', 'ฟอร์มใบลดหนี้', '1', '1', '1', NULL, 'Frm_SQL_SMBillPc.mrt', 'formreport/SMBillPc', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00036', 'โอนสินค้าระหว่างคลัง', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillTnf.mrt', 'formreport/ALLMPdtBillTnf', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');
INSERT INTO  [TRPSRptFormat] ([FTRfsCode], [FTRfsDocType], [FTRfsStaDefStd], [FTRfsFormType], [FTRfsStaAlwEdit], [FTRfsRefCode], [FTRfsRptFileName], [FTRfsPath], [FDLastUpdOn], [FTLastUpdBy], [FDCreateOn], [FTCreateBy]) VALUES ('00037', 'โอนสินค้าระหว่างคลังตู้', '1', '1', '1', NULL, 'Frm_SQL_ALLMPdtBillTnfVD.mrt', 'formreport/ALLMPdtBillTnfVD', '2022-05-10 13:59:25.000', 'Nattakit', '2022-05-10 13:59:25.000', 'Nattakit');





INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00001', '1', 'ฟอร์มใบกำกับภาษี', 'ฟอร์มใบกำกับภาษี');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00002', '1', 'ฟอร์มใบลดหนี้', 'ฟอร์มใบลดหนี้');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00003', '1', 'ฟอร์มใบอย่างย่อ', 'ฟอร์มใบอย่างย่อ');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00004', '1', 'ฟอร์มใบปรับราคาขาย', 'ฟอร์มใบปรับราคาขาย');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00005', '1', 'ฟอร์มใบโปรโมชั่น', 'ฟอร์มใบโปรโมชั่น');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00006', '1', 'ฟอร์มใบปรับราคาทุน', 'ฟอร์มใบปรับราคาทุน');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00007', '1', 'ฟอร์มใบตรวจนับย่อย', 'ฟอร์มใบตรวจนับย่อย');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00008', '1', 'ฟอร์มใบตรวจนับรวม', 'ฟอร์มใบตรวจนับรวม');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00009', '1', 'ฟอร์มใบตรวจนับ-ตู้', 'ฟอร์มใบตรวจนับ-ตู้');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00010', '1', 'ฟอร์มใบเปลี่ยนบัตรเงินสด', 'ฟอร์มใบเปลี่ยนบัตรเงินสด');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00011', '1', 'ฟอร์มใบสร้างบัตร', 'ฟอร์มใบสร้างบัตร');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00012', '1', 'ฟอร์มใบเบิกบัตรเงินสด', 'ฟอร์มใบเบิกบัตรเงินสด');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00013', '1', 'ฟอร์มใบคืนเงินสด', 'ฟอร์มใบคืนเงินสด');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00014', '1', 'ฟอร์มใบคืนบัตรเงินสด', 'ฟอร์มใบคืนบัตรเงินสด');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00015', '1', 'ฟอร์มใบเปลี่ยนสถานะบัตร', 'ฟอร์มใบเปลี่ยนสถานะบัตร');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00016', '1', 'ฟอร์มใบเติมเงิน', 'ฟอร์มใบเติมเงิน');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00017', '1', 'ฟอร์มใบเงื่อนไขการแลกแต้ม', 'ฟอร์มใบเงื่อนไขการแลกแต้ม');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00018', '1', 'ฟอร์มใบกำหนดคูปอง', 'ฟอร์มใบกำหนดคูปอง');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00019', '1', 'ฟอร์มใบนำฝาก', 'ฟอร์มใบนำฝาก');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00020', '1', 'ฟอร์มใบโอนสินค้าระหว่างสาขา', 'ฟอร์มใบโอนสินค้าระหว่างสาขา');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00021', '1', 'ฟอร์มใบรับของใบซื้อ', 'ฟอร์มใบรับของใบซื้อ');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00022', '1', 'ฟอร์มใบสั่งซื้อ', 'ฟอร์มใบสั่งซื้อ');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00023', '1', 'ฟอร์มใบเติมสินค้าแบบชุด - ตู้', 'ฟอร์มใบเติมสินค้าแบบชุด - ตู้');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00024', '1', 'ฟอร์มใบเติมสินค้า - ตู้', 'ฟอร์มใบเติมสินค้า - ตู้');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00025', '1', 'ฟอร์มใบจ่ายโอน - สาขา', 'ฟอร์มใบจ่ายโอน - สาขา');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00026', '1', 'ฟอร์มใบรับโอน - สาขา', 'ฟอร์มใบรับโอน - สาขา');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00027', '1', 'ฟอร์มใบรับโอน - คลัง', 'ฟอร์มใบรับโอน - คลัง');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00028', '1', 'ฟอร์มใบรับเข้า - คลัง', 'ฟอร์มใบรับเข้า - คลัง');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00029', '1', 'ฟอร์มใบนำสินค้าออก - ตู้', 'ฟอร์มใบนำสินค้าออก - ตู้');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00030', '1', 'ฟอร์มใบจ่ายโอน - คลัง', 'ฟอร์มใบจ่ายโอน - คลัง');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00031', '1', 'ฟอร์มใบเบิกออก - คลัง', 'ฟอร์มใบเบิกออก - คลัง');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00032', '1', 'ฟอร์มโปรโมชั่นบัตรเงินสด', 'ฟอร์มโปรโมชั่นบัตรเงินสด');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00033', '1', 'ฟอร์มใบตรวจนับสินค้า', 'ฟอร์มใบตรวจนับสินค้า');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00034', '1', 'ฟอร์มใบสั่งขาย', 'ฟอร์มใบสั่งขาย');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00035', '1', 'ฟอร์มใบลดหนี้', 'ฟอร์มใบลดหนี้');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00036', '1', 'โอนสินค้าระหว่างคลัง', 'โอนสินค้าระหว่างคลัง');
INSERT INTO   [TRPSRptFormat_L] ([FTRfsCode], [FNLngID], [FTRfsName], [FTRfsRemark]) VALUES ('00037', '1', 'โอนสินค้าระหว่างคลังตู้', 'โอนสินค้าระหว่างคลังตู้');
--ทุกครั้งที่รันสคริปใหม่
INSERT INTO [TCNTUpgradeHisTmp] ([FTUphVersion], [FDCreateOn], [FTUphRemark], [FTCreateBy]) VALUES ( '01.01.22', getdate() , 'ข้อมูลตั้งต้นสำหรับการกำหนดฟอม', 'Nale')
END
GO
