
IF NOT EXISTS(SELECT FTRptCode FROM TCNSRptSpc WHERE FTRptCode='SPC003001') BEGIN
INSERT INTO TCNSRptSpc (FTAgnCode,FTBchCode,FTMerCode,FTShpCode,FNRptGrpSeq,FTRptGrpCode,FNRptSeq,FTRptCode,FTRptRoute,FTRptFilterCol,FTRptStaActive,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
VALUES ('','','','','3','SPC003','1','SPC003001','rptPackageUsageInfo','1,3,4,88','1',NULL,'',NULL,'')
END 

IF NOT EXISTS(SELECT FTRptCode FROM TCNSRptSpc_L WHERE  FTRptCode='SPC003001') BEGIN
INSERT INTO TCNSRptSpc_L (FTRptCode,FNLngID,FTRptName,FTRptRmk)
VALUES ('SPC003001','1','รายงาน - ข้อมูลการใช้แพ็คเกจ',NULL)
END

IF NOT EXISTS(SELECT FTRptGrpCode FROM TCNSRptSpcGrp_L WHERE  FTRptGrpCode='SPC003') BEGIN
INSERT INTO TCNSRptSpcGrp_L (FTRptGrpCode,FNLngID,FTRptGrpName,FTRptGrpRmk)
VALUES ('SPC003','1','รายงานพิเศษ',NULL)
END 

IF NOT EXISTS(SELECT FTRptFltCode FROM TSysReportFilter WHERE  FTRptFltCode='88') BEGIN
INSERT INTO TSysReportFilter (FTRptFltCode,FTRptFltStaFrm,FTRptFltStaTo,FTRptGrpFlt)
VALUES ('88','1','1','G7')
END 

IF NOT EXISTS(SELECT FTRptFltCode FROM TSysReportFilter_L WHERE  FTRptFltCode='88') BEGIN
INSERT INTO TSysReportFilter_L (FTRptFltCode,FNLngID,FTRptFltName)
VALUES ('88','1','คูปอง')
INSERT INTO TSysReportFilter_L (FTRptFltCode,FNLngID,FTRptFltName)
VALUES ('88','2','Coupon')
END 