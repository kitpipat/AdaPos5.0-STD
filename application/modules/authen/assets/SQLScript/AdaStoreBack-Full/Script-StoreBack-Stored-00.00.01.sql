    IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxSellThru]') AND type in (N'P', N'PC'))
    DROP PROCEDURE SP_RPTxSellThru
    GO
	
	CREATE PROCEDURE SP_RPTxSellThru
--ALTER PROCEDURE SP_RPTxSellThru
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

--Agency
	@ptAgnL Varchar(8000), --Agency Condition IN
	--@ptPosF Varchar(10), @ptPosT Varchar(10),
	  
--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	--@ptBchF Varchar(5),	@ptBchT Varchar(5),

--Merchant
	@ptMerL Varchar(8000), --เจ้าของธุรกิจ Condition IN
	--@ptUsrF Varchar(10), @ptUsrT Varchar(10),

--Shop
	@ptShpL Varchar(8000), 
	--@ptShpF Varchar(5),@ptShpT Varchar(5),

--FTFhnRefCode -- รหัสควบคุมสต็อกสินค้า Def :  (SEASON+MODEL+COLOR+SIZE)
	@ptRefF Varchar(30),@ptRefT Varchar(30),
	 
--รหัสสินค้า --FTPdtCode --รหัสสินค้า
	@ptPdtF Varchar(20),@ptPdtT Varchar(20),

--รหัสฤดูกาล
	@ptSeaF Varchar(20),@ptSeaT Varchar(20),

--รหัสเนื้อผ้า
	@ptFabF Varchar(20),@ptFabT Varchar(20),

--รหัสสี
	@ptClrF Varchar(20),@ptClrT Varchar(20),

--รหัสไซต์
	@ptPszF Varchar(20),@ptPszT Varchar(20),

--ต้องการแสดงรายงานถึงวันที่ รายจะแสดงจากวันที่ 1 ถึง @ptDocDateT ของเดือนนั้น 
--Condition วันเดียวพอ
	@ptDocDateT Varchar(10), 

	@FNResult INT OUTPUT 

----กลุ่มสินค้า --FTPgpChain 
--	@ptPgpF Varchar(30),@ptPgpT Varchar(30),

----FTPtyCode --ประเภทสินค้า
--	@ptPtyF Varchar(5),@ptPtyT Varchar(5),
	
----FTPbnCode --ยี่ห้อ
--	@ptPbnF Varchar(5),	@ptPbnT Varchar(5),

--	@ptSaleType	 Varchar(1),--FTPdtType  --ใช้ราคาขาย 1:บังคับ, 2:แก้ไข, 3:เครื่องชั่ง, 4:น้ำหนัก 6:สินค้ารายการซ่อม
--	@ptPdtActive Varchar(1),--FTPdtStaActive --สถานะ เคลื่อนไหว 1:ใช่, 2:ไม่ใช่
--	@PdtStaVat Varchar(1),--FTPdtStaVat --สถานะภาษีขาย 1:มี 2:ไม่มี

	
--FTPdtCode --รหัสสินค้า
--FTPgpChain --กลุ่มสินค้า
--FTPtyCode --ประเภทสินค้า
--FTPbnCode --ยี่ห้อ
--FTPmoCode --รุ่น
--FTPdtSaleType  --ใช้ราคาขาย 1:บังคับ, 2:แก้ไข, 3:เครื่องชั่ง, 4:น้ำหนัก 6:สินค้ารายการซ่อม
--FTPdtStaActive --สถานะ เคลื่อนไหว 1:ใช่, 2:ไม่ใช่
--FTPdtStaVat --สถานะภาษีขาย 1:มี 2:ไม่มี

	
AS
--------------------------------------
-- Watcharakorn 
-- Create 13/05/2021
--รายงานสินค้า
-- Temp name  SP_RPTxPdtEntry

--------------------------------------
BEGIN TRY	
	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSql1 VARCHAR(8000)
	DECLARE @tSql2 VARCHAR(8000)
	DECLARE @tSql3 VARCHAR(8000)
	DECLARE @tSql4 VARCHAR(8000)
	DECLARE @tSqlHD VARCHAR(8000)

	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)
	--Cashier
	DECLARE @tUsrF Varchar(10)
	DECLARE @tUsrT Varchar(10)
	--Pos Code
	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)

	DECLARE @tAtDate VARCHAR(10)
	DECLARE @tAtDateME VARCHAR(10)

	SET @tAtDate = @ptDocDateT
	SET @tAtDateME = LEFT(@tAtDate,8) + '01'

	SET @tAtDate = CONVERT(VARCHAR(10),@tAtDate,121)
	SET @tAtDateME = CONVERT(VARCHAR(10),@tAtDateME,121)

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	
	SET @FNResult= 0



	IF @nLngID = null
	BEGIN
		SET @nLngID = 1
	END	

	IF @ptBchL = null
	BEGIN
		SET @ptBchL = ''
	END

	IF @tBchF = null
	BEGIN
		SET @tBchF = ''
	END
	IF @tBchT = null OR @tBchT = ''
	BEGIN
		SET @tBchT = @tBchF
	END

	IF @ptShpL = null
	BEGIN
		SET @ptShpL = ''
	END

	

	IF @ptPdtF =null
	BEGIN
		SET @ptPdtF = ''
	END
	IF @ptPdtT =null OR @ptPdtT = ''
	BEGIN
		SET @ptPdtT = @ptPdtF
	END 


	IF @ptRefF =null
	BEGIN
		SET @ptRefF = ''
	END
	IF @ptRefF =null OR @ptRefT = ''
	BEGIN
		SET @ptRefT = @ptRefF
	END


	IF @tDocDateT = null
	BEGIN 
		SET @tDocDateT = ''
	END

	--IF @tDocDateT = null OR @tDocDateT =''
	--BEGIN 
	--	SET @tDocDateT = @tDocDateF
	--END
	
		
	SET @tSql1 =  ' '--- ' WHERE 1=1 '
	SET @tSql3 =  ' '
	SET @tSql4 =  ' '
	IF (@ptAgnL <> '' )
	BEGIN
		SET @tSql1 +=' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
	END
	--PRINT @tSql1

	IF (@ptBchL <> '' )
	BEGIN
		SET @tSql1 +=' AND Stk.FTBchCode IN (' + @ptBchL + ')'
		SET @tSql3 +=' AND StkMS.FTBchCode IN (' + @ptBchL + ')'
		SET @tSql4 +=' AND StkM.FTBchCode IN (' + @ptBchL + ')'
	END

	IF (@ptMerL <> '' )
	BEGIN
		SET @tSql1 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
	END


	IF (@ptShpL <> '' )
	BEGIN
		SET @tSql1 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
	END

	IF (@ptPdtF<> '')
	BEGIN
		SET @tSql1 +=' AND Stk.FTPdtCode BETWEEN ''' + @ptPdtF + ''' AND ''' + @ptPdtT + ''''
		SET @tSql3 +=' AND StkMS.FTPdtCode BETWEEN ''' + @ptPdtF + ''' AND ''' + @ptPdtT + ''''
		SET @tSql4 +=' AND StkM.FTPdtCode BETWEEN ''' + @ptPdtF + ''' AND ''' + @ptPdtT + ''''
	END

	IF (@ptRefF<> '')
	BEGIN
		SET @tSql1 +=' AND Stk.FTFhnRefCode BETWEEN ''' + @ptRefF + ''' AND ''' + @ptRefT + ''''
		SET @tSql3 +=' AND StkMS.FTFhnRefCode BETWEEN ''' + @ptRefF + ''' AND ''' + @ptRefT + ''''
		SET @tSql4 +=' AND StkM.FTFhnRefCode BETWEEN ''' + @ptRefF + ''' AND ''' + @ptRefT + ''''
	END

	SET @tSql2 = ''

	IF (@ptSeaF<> '')
	BEGIN
		SET @tSql2 +=' AND Clr.FTSeaCode BETWEEN ''' + @ptSeaF + ''' AND ''' + @ptSeaT + ''''
	END

	IF (@ptFabF<> '')
	BEGIN
		SET @tSql2 +=' AND Clr.FTFabCode BETWEEN ''' + @ptFabF + ''' AND ''' + @ptFabT + ''''
	END

	IF (@ptClrF<> '')
	BEGIN
		SET @tSql2 +=' AND Clr.FTClrCode BETWEEN ''' + @ptClrF + ''' AND ''' + @ptClrT + ''''
	END

	IF (@ptPszF<> '')
	BEGIN
		SET @tSql2 +=' AND Clr.FTPszCode BETWEEN ''' + @ptPszF + ''' AND ''' + @ptPszT + ''''
	END
	


	DELETE FROM TRPTSellThruTmp  WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--Åº¢éÍÁÙÅ Temp ¢Í§à¤Ã×èÍ§·Õè¨ÐºÑ¹·Ö¡¢ÍÁÙÅÅ§ Temp

	SET @tSql = 'INSERT INTO TRPTSellThruTmp'
	--PRINT @tSql
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTFhnRefCode,FTPdtCode ,FTBarCode, FTPdtName , FTClrCode,FTClrName, FTPbnCode,FTPbnName, FTDepCode,FTDepName,'
	 SET @tSql +=' FTClsCode,FTClsName, FTSclCode,FTSclName, FTPgpCode,FTPgpName, FTCmlCode,FTCmlName,'
 	 SET @tSql +=' FCPgdPriceRet,FDFhnStart,FTFhnModNo,FTFabCode,FTFabName,FTFhnGender,FTPmoCode,FTPmoName,'
	 SET @tSql +=' FTSeaCode,FTSeaName, FTPunCode,FTPunName, FTPszCode,FTPszName, FTClrRmk,FCFhnCostStd ,FCFhnCostOth,'
	 SET @tSql +=' FCStfQtyEnd,FCStfQtyIN,FCStfInRet, FCStfQtyEndIn,FCStfEndInRet , FCStfQtySale,FCStfGrossSales,FCStfNetSale,'
	 SET @tSql +=' FCStfOnHandQty,	FCStfOnHandRetValue,FCStfPfmPeriod, FCStfPfmOverAll'
	SET @tSql +=' )'
			 SET @tSql +=' SELECT DISTINCT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
			  SET @tSql +=' Stk.FTFhnRefCode,Stk.FTPdtCode ,ISNULL(PdtBar.FTBarCode,'''') AS FTBarCode, PdtL.FTPdtName AS FTPdtName ,'
			  SET @tSql +=' ISNULL(Clr.FTClrCode,'''') AS FTClrCode,ISNULL(Clr.FTClrName,'''') AS FTClrName,'
 			  SET @tSql +=' ISNULL(Pdt.FTPbnCode,'''') AS FTPbnCode,ISNULL(PbnL.FTPbnName,'''') AS FTPbnName,'
			  SET @tSql +=' ISNULL(PdtFhn.FTDepCode,'''') AS FTDepCode,ISNULL(DepL.FTDepName,'''') AS FTDepName,'
			  SET @tSql +=' ISNULL(PdtFhn.FTClsCode,'''') AS FTClsCode,ISNULL(ClsL.FTClsName,'''') AS FTClsName,'
			  SET @tSql +=' ISNULL(PdtFhn.FTSclCode,'''') AS FTSclCode,ISNULL(SclL.FTSclName,'''') AS FTSclName,'
			  SET @tSql +=' ISNULL(PdtFhn.FTPgpCode,'''') AS FTPgpCode,ISNULL(PgpL.FTPgpName,'''') AS FTPgpName,'
			  SET @tSql +=' ISNULL(PdtFhn.FTCmlCode,'''') AS FTCmlCode,ISNULL(CmlL.FTCmlName,'''') AS FTCmlName,'
			  SET @tSql +=' ISNULL(P4PDT.FCPgdPriceRet,0) AS FCPgdPriceRet,Clr.FDFhnStart,ISNULL(PdtFhn.FTFhnModNo,'''') AS FTFhnModNo,ISNULL(Clr.FTFabCode,'''') AS FTFabCode,ISNULL(Clr.FTFabName,'''') AS FTFabName,'
			  SET @tSql +=' ISNULL(PdtFhn.FTFhnGender,'''') AS FTFhnGender,ISNULL(Pdt.FTPmoCode,'''') AS FTPmoCode,ISNULL(PmoL.FTPmoName,'''') AS FTPmoName,'
			  SET @tSql +=' ISNULL(Clr.FTSeaCode,'''') AS FTSeaCode,ISNULL(Clr.FTSeaName,'''')AS FTSeaName,'
			  SET @tSql +=' ISNULL(PdtBar.FTPunCode,'''') AS FTPunCode,ISNULL(PunL.FTPunName,'''') AS FTPunName,'
			  SET @tSql +=' ISNULL(Clr.FTPszCode,'''') AS FTPszCode,ISNULL(Clr.FTPszName,'''') AS FTPszName,'
			  SET @tSql +=' ISNULL(Clr.FTClrRmk,'''') AS FTClrRmk,ISNULL(Clr.FCFhnCostStd,0) AS FCFhnCostStd ,ISNULL(Clr.FCFhnCostOth,0) AS FCFhnCostOth,'
			  SET @tSql +=' ISNULL(MEnd.FCStfQty,0) AS FCStfQtyEnd,'
			  SET @tSql +=' ISNULL(QtySale.FCStfQtyIN,0) AS FCStfQtyIN,'
			  SET @tSql +=' (ISNULL(P4PDT.FCPgdPriceRet,0)*ISNULL(QtySale.FCStfQtyIN,0)) AS FCStfInRet,'
			  SET @tSql +=' ISNULL(MEnd.FCStfQty,0)+ISNULL(QtySale.FCStfQtyIN,0) AS FCStfQtyEndIn,'
			  SET @tSql +=' (ISNULL(P4PDT.FCPgdPriceRet,0) * (ISNULL(MEnd.FCStfQty,0)+ISNULL(QtySale.FCStfQtyIN,0))) AS FCStfEndInRet ,'
			  SET @tSql +=' ISNULL(QtySale.FCStfQtySale,0) AS FCStfQtySale,'
			  SET @tSql +=' (ISNULL(P4PDT.FCPgdPriceRet,0)*ISNULL(QtySale.FCStfQtySale,0)) AS FCStfGrossSales,'
			  SET @tSql +=' ISNULL(FCStfNetSale,0) AS FCStfNetSale,'
			  SET @tSql +=' (ISNULL(MEnd.FCStfQty,0)+ISNULL(QtySale.FCStfQtyIN,0)) -ISNULL(QtySale.FCStfQtySale,0) - ISNULL(QtySale.FCStfQtyOUT,0) AS FCStfOnHandQty,'
			  SET @tSql +=' CASE WHEN ((ISNULL(MEnd.FCStfQty, 0) + ISNULL(QtySale.FCStfQtyIN, 0)) - ISNULL(QtySale.FCStfQtySale, 0)-ISNULL(QtySale.FCStfQtyOUT,0)) < 0 THEN 0 ELSE ((ISNULL(MEnd.FCStfQty, 0) + ISNULL(QtySale.FCStfQtyIN, 0)) - ISNULL(QtySale.FCStfQtySale, 0)-ISNULL(QtySale.FCStfQtyOUT,0))  END *(ISNULL(P4PDT.FCPgdPriceRet,0)) AS FCStfOnHandRetValue,'
			  SET @tSql +=' CASE WHEN ISNULL(QtySale.FCStfQtyIN,0) = 0 THEN 0 ELSE (ISNULL(QtySale.FCStfQtySale,0)/ISNULL(QtySale.FCStfQtyIN,0))*100 END AS FCStfPfmPeriod,'
			  SET @tSql +=' CASE WHEN (ISNULL(QtySale.FCStfQtyIN,0)+ISNULL(MEnd.FCStfQty,0)) = 0 THEN 0 ELSE (ISNULL(QtySale.FCStfQtySale,0)/(ISNULL(QtySale.FCStfQtyIN,0)+ISNULL(MEnd.FCStfQty,0)))*100 END AS FCStfPfmOverAll'
			  SET @tSql +=' FROM TFHTPdtStkCrd Stk WITH(NOLOCK)'
			  SET @tSql +=' INNER JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode'
			  SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON Pdt.FTPdtCode =  SpcBch.FTPdtCode'
			  SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK) ON Stk.FTPdtCode = PdtBar.FTPdtCode	AND Stk.FTFhnRefCode = PdtBar.FTFhnRefCode'
			  SET @tSql +=' LEFT JOIN TCNMPdtUnit_L PunL  WITH(NOLOCK) ON PdtBar.FTPunCode = PunL.FTPunCode	AND PunL.FNLngID	='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			  SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL  WITH(NOLOCK) ON Stk.FTPdtCode = PdtL.FTPdtCode	AND PdtL.FNLngID	='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			  SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			  SET @tSql +=' INNER JOIN TFHMPdtFhn PdtFhn WITH(NOLOCK) ON Stk.FTPdtCode = PdtFhn.FTPdtCode'
			  SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L DepL  WITH(NOLOCK) ON PdtFhn.FTDepCode	= DepL.FTDepCode AND Depl.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			  SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L ClsL  WITH(NOLOCK) ON PdtFhn.FTClsCode	= ClsL.FTClsCode AND ClsL.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			  SET @tSql +=' LEFT JOIN TFHMPdtF3SubClass_L SclL WITH(NOLOCK) ON PdtFhn.FTSclCode	= SclL.FTSclCode AND SclL.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			  SET @tSql +=' LEFT JOIN TFHMPdtF4Group_L PgpL WITH(NOLOCK) ON PdtFhn.FTPgpCode = PgpL.FTPgpCode AND PgpL.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			  SET @tSql +=' LEFT JOIN TFHMPdtF5ComLines_L CmlL WITH(NOLOCK) ON PdtFhn.FTCmlCode = CmlL.FTCmlCode AND CmlL.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			  SET @tSql +=' LEFT JOIN TCNMPdtModel_L PmoL WITH(NOLOCK) ON Pdt.FTPmoCode = PmoL.FTPmoCode AND PmoL.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			  SET @tSql +=' LEFT JOIN TCNTPdtPrice4PDT P4PDT WITH(NOLOCK)  ON PdtBar.FTPdtCode = P4PDT.FTPdtCode  AND PdtBar.FTPunCode = P4PDT.FTPunCode AND'
			  SET @tSql +=' ( CONVERT(VARCHAR(10),P4PDT.FDPghDStart,121) <='''+ @tAtDate+ ''' AND  CONVERT(VARCHAR(10),P4PDT.FDPghDStop,121) >= ''' + @tAtDate+ ''')' --AND 

			  SET @tSql +=' LEFT JOIN' 
					   SET @tSql +=' (SELECT DISTINCT ClrHfn.FTPdtCode,ClrHfn.FTFhnRefCode,PdtBar.FTBarCode,ClrHfn.FTClrCode ,Clr.FTClrName,ClrHfn.FDFhnStart,ClrHfn.FTFabCode,FabL.FTFabName,'
					    SET @tSql +=' ClrHfn.FTSeaCode,SeaL.FTSeaName,ClrHfn.FTPszCode,PszL.FTPszName,Clr.FTClrRmk,ClrHfn.FCFhnCostStd ,ClrHfn.FCFhnCostOth'
						  SET @tSql +=' FROM '
						  SET @tSql +='( SELECT DISTINCT'
							SET @tSql +=' Clr.FTPdtCode,Clr.FTFhnRefCode,MAX(Clr.FNFhnSeq) AS FNFhnSeq'
              SET @tSql +=' FROM TFHMPdtColorSize Clr'
							SET @tSql +=' WHERE 1=1'
							SET @tSql += @tSql2
							SET @tSql += ' GROUP BY Clr.FTPdtCode,Clr.FTFhnRefCode ) ClrMas'
             SET @tSql +=' INNER JOIN TFHMPdtColorSize ClrHfn WITH (NOLOCK) ON ClrMas.FTPdtCode = ClrHfn.FTPdtCode AND ClrMas.FTFhnRefCode = ClrHfn.FTFhnRefCode AND ClrMas.FNFhnSeq = ClrHfn.FNFhnSeq'
						 SET @tSql +=' INNER JOIN TFHTPdtStkCrd Stk WITH(NOLOCK) ON ClrHfn.FTPdtCode = Stk.FTPdtCode'
						 SET @tSql +=' AND ClrHfn.FTFhnRefCode = Stk.FTFhnRefCode'
						 SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK) ON ClrHfn.FTPdtCode = PdtBar.FTPdtCode	AND ClrHfn.FTFhnRefCode = PdtBar.FTFhnRefCode	AND ClrHfn.FNFhnSeq	 = PdtBar.FNBarRefSeq'	
						 SET @tSql +=' LEFT JOIN TCNMPdtColor_L Clr WITH(NOLOCK) ON ClrHfn.FTClrCode	= 	Clr.FTClrCode	 AND Clr.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						 SET @tSql +=' LEFT JOIN TFHMPdtFabric_L FabL  WITH (NOLOCK) ON ClrHfn.FTFabCode = FabL.FTFabCode	AND FabL.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						 SET @tSql +=' LEFT JOIN TFHMPdtSeason_L SeaL  WITH (NOLOCK) ON ClrHfn.FTSeaCode = SeaL.FTSeaCode	AND SeaL.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						 SET @tSql +=' LEFT JOIN TCNMPdtSize_L PszL  WITH (NOLOCK) ON ClrHfn.FTPszCode = PszL.FTPszCode	AND PszL.FNLngID	 ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
					   SET @tSql +=' ) Clr ON Stk.FTPdtCode = Clr.FTPdtCode AND Stk.FTFhnRefCode	 = Clr.FTFhnRefCode	AND PdtBar.FTBarCode =  Clr.FTBarCode'	

			  SET @tSql +=' LEFT JOIN'
				 SET @tSql +=' ('
					 SET @tSql +=' SELECT StkM.FTFhnRefCode,StkM.FTPdtCode,FTBarCode,'
					 SET @tSql +=' SUM(ISNULL(StkM.FCStfQty,0)) AS FCStfQty'
					 SET @tSql +=' FROM TFHTPdtStkCrdME StkM WITH(NOLOCK)'
					 SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK) ON StkM.FTPdtCode = PdtBar.FTPdtCode	AND StkM.FTFhnRefCode = PdtBar.FTFhnRefCode'	
					 SET @tSql +=' WHERE CONVERT(VARCHAR(10),FDStfDate,121) = ''' + @tAtDateME +''''
					 SET @tSql += @tSql4
					 SET @tSql +=' GROUP BY StkM.FTFhnRefCode,StkM.FTPdtCode,FTBarCode'
					 --PRINT @tSql
				 SET @tSql +=' ) MEnd ON Stk.FTPdtCode = MEnd.FTPdtCode AND Stk.FTFhnRefCode	 = MEnd.FTFhnRefCode	AND PdtBar.FTBarCode =  MEnd.FTBarCode'	
				 
			  SET @tSqlHD =' INNER JOIN'
				 SET @tSqlHD +=' ('
					 SET @tSqlHD +=' SELECT StkMS.FTFhnRefCode,StkMS.FTPdtCode,FTBarCode,'
					 SET @tSqlHD +=' SUM(ISNULL(CASE WHEN StkMS.FTStfType =''1'' THEN StkMS.FCStfQty ELSE 0 END ,0)) AS FCStfQtyIN,'
					 SET @tSqlHD +=' SUM(ISNULL(CASE WHEN StkMS.FTStfType =''2'' THEN StkMS.FCStfQty ELSE 0 END ,0)) AS FCStfQtyOUT,'
					 SET @tSqlHD +=' SUM(ISNULL(CASE' 
								 SET @tSqlHD +=' WHEN StkMS.FTStfType =''3'' THEN ISNULL(StkMS.FCStfQty,0)' 
								 SET @tSqlHD +=' WHEN StkMS.FTStfType =''4'' THEN ISNULL(StkMS.FCStfQty,0)*-1'  
						 SET @tSqlHD +=' END ,0)) AS FCStfQtySale,'
					 SET @tSqlHD +=' SUM(ISNULL(CASE' 
								 SET @tSqlHD +=' WHEN StkMS.FTStfType =''3'' THEN ISNULL(StkMS.FCStfQty,0)*ISNULL(StkMS.FCStfSetPrice,0)'
								 SET @tSqlHD +=' WHEN StkMS.FTStfType =''4'' THEN (ISNULL(StkMS.FCStfQty,0)*ISNULL(StkMS.FCStfSetPrice,0))*-1'  
						 SET @tSqlHD +=' END ,0)) AS FCStfNetSale'
					 SET @tSqlHD +=' FROM TFHTPdtStkCrd StkMS WITH(NOLOCK)'
					 SET @tSqlHD +=' LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK) ON StkMS.FTPdtCode = PdtBar.FTPdtCode	AND StkMS.FTFhnRefCode = PdtBar.FTFhnRefCode'	
					 SET @tSqlHD +=' WHERE CONVERT(VARCHAR(10),FDStfDate,121) BETWEEN ''' + @tAtDateME + ''' AND ''' + @tAtDate + ''''
					 SET @tSqlHD +=' AND StkMS.FTStfType IN (''1'',''2'',''3'',''4'')'
					 SET @tSqlHD +=' AND NOT EXISTS (SELECT DT.FTBchCode,DT.FTXthDocNo,FTPdtCode,FTFhnRefCode FROM TCNTPdtTwxDTFhn DT' 
					 SET @tSqlHD +=' INNER JOIN TCNTPdtTwxHD HD ON DT.FTBchCode = HD.FTBchCode	 AND DT.FTXthDocNo = HD.FTXthDocNo'	
					 SET @tSqlHD +=' WHERE CONVERT(VARCHAR(10),FDXthDocDate,121) BETWEEN ''' + @tAtDateME + ''' AND ''' + @tAtDate + ''''
					 SET @tSqlHD +=' AND StkMS.FTBchCode = HD.FTBchCode AND  StkMS.FTStfDocNo	= HD.FTXthDocNo'	 
					 SET @tSqlHD +=' )'
					 SET @tSqlHD += @tSql3
					 SET @tSqlHD +=' GROUP BY StkMS.FTFhnRefCode,StkMS.FTPdtCode,FTBarCode'
					 --PRINT @tSql3
				 SET @tSqlHD +=' ) QtySale ON Stk.FTPdtCode = QtySale.FTPdtCode AND Stk.FTFhnRefCode = QtySale.FTFhnRefCode	AND PdtBar.FTBarCode =  QtySale.FTBarCode'	
			  --SET @tSql +=' WHERE CONVERT(VARCHAR(10),FDStfDate,121) = ''' + @tAtDateME + ''''
			  SET @tSqlHD +=' WHERE CONVERT(VARCHAR(10),FDStfDate,121) BETWEEN ''' + @tAtDateME + ''' AND ''' + @tAtDate + ''''
			  SET @tSqlHD += @tSql1
				SET @tSqlHD += @tSql2

	
	--PRINT @tSql+@tSqlHD
 --SELECT @tSql , @tSqlHD
	
	EXECUTE(@tSql+@tSqlHD)

END TRY

BEGIN CATCH 
	SET @FNResult= -1
	--PRINT @tSql
END CATCH	
GO



IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxAdjustStockPrc')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxAdjustStockPrc
GO
CREATE PROCEDURE [dbo].STP_DOCxAdjustStockPrc
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tWahType varchar(1) -- 4. --
DECLARE @tAdjSeqChk varchar(1) -- 4.--
DECLARE @tStaPrcStkTo varchar(1)	-- 04.04.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	13/06/2019		Em		create  
00.02.00	03/07/2019		Em		แก้ไขความกว้างฟิลด์ FTBchCode จาก 3 เป็น 5
00.03.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร
00.04.00	22/07/2019		Em		เพิ่มการปรับสต๊อก Vending
00.05.00	31/07/2019		Em		ปรับปรุงแก้ไข
00.06.00	01/08/2019		Em		เพิ่มการตรวจนับสินค้าทั่วไป
03.01.00	27/03/2020		Em		ปรับปรุงแก้ไข
03.02.00	28/03/2020		Em		แก้ไขให้ sum ยอดสต๊อกตามสินค้า
03.03.00	30/03/2020		Em		แก้ไขการ Sum ยอดขายที่ยังไม่ประมวลผล stk ตามสินค้าตามหน่วย
03.04.00	30/03/2020		Em		แก้ไขให้อัพเดท bal ตามจำนวนที่นับได้ + จำนวนที่ขายค้างอยู่ 
04.01.00	20/07/2020		Em		แก้ไขการใช้ฟิลด์ QtyAll
04.02.00	18/08/2020		Em		แก้ไขการใช้ฟิลด์ที่ใช้ตรวจสอบคลัง Vending
04.03.00	27/08/2020		Em		เพิ่มให้ insert ข้อมูลลงตาราง TVDTPdtStkBal
04.04.00	20/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.05.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
04.06.00	16/11/2020		Em		เพิ่มการตรวจสอบสถานะการตัดสต๊อก
04.07.00	16/11/2020		Em		เพิ่มการตรวจสอบรายการ void และการคืน
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
----------------------------------------------------------------------*/
BEGIN TRY
	--SET @tStaPrc = (SELECT TOP 1 ISNULL(FTAjhStaPrcStk,'') AS FTAjhStaPrcStk FROM TCNTPdtAdjStkHD WITH(NOLOCK) WHERE FTBchCode = @ptBchCode AND FTAjhDocNo = @ptDocNo )		-- 3. --
	
	-- 4. --
	SELECT TOP 1 @tWahType = ISNULL(WAH.FTWahStaType,''),
	 @tAdjSeqChk = ISNULL(HD.FTAjhApvSeqChk,'1'),
	 @tStaPrc = ISNULL(FTAjhStaPrcStk,'')
	FROM TCNTPdtAdjStkHD HD WITH(NOLOCK) 
	INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTAjhWhTo = WAH.FTWahCode 
	WHERE HD.FTBchCode = @ptBchCode AND HD.FTAjhDocNo = @ptDocNo 
	-- 4. --
	
	IF @tStaPrc <> '1'		-- 3. --
	BEGIN
		
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		-- 04.04.00 --
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtAdjStkHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTAjhWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTAjhDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			IF @tWahType = '6'	-- 4. --
				BEGIN
					--Update sale before adjust
					UPDATE TCNTPdtAdjStkDT WITH(ROWLOCK)
					SET FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
					--,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
					,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))	-- 04.02.00 --
					FROM TCNTPdtAdjStkDT DT
					--LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, VD.FNLayRow, VD.FNLayCol, SUM(DT.FCXsdQtyAll) AS FCXsdQty
					LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, VD.FNLayRow, VD.FNLayCol, SUM(CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdQtyAll *(-1) ELSE DT.FCXsdQtyAll END) AS FCXsdQty	 -- 04.07.00 --
						FROM TVDTSalHD HD WITH(NOLOCK)
						INNER JOIN TVDTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
						INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
						INNER JOIN TVDTSalDTVD VD WITH(NOLOCK) ON DT.FTBchCode = VD.FTBchCode AND DT.FTXshDocNo = VD.FTXshDocNo AND DT.FNXsdSeqNo = VD.FNXsdSeqNo
						INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.06.00 --
						WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
						AND DT.FTXsdStaPdt <> '4' -- 04.07.00 --
						GROUP BY HD.FDXshDocDate, DT.FTPdtCode, VD.FNLayRow, VD.FNLayCol) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FNAjdLayRow = SAL.FNLayRow AND DT.FNAjdLayCol = SAL.FNLayCol AND DT.FDAjdDateTime > SAL.FDXshDocDate
					--WHERE DT.FDAjdDateTime > SAL.FDXshDocDate
					WHERE DT.FTBchCode = @ptBchCode AND DT.FTAjhDocNo = @ptDocNo -- 5. --

					--insert data to Temp
					INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
					SELECT @ptDocNo AS FTComName,HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
					,'5' AS FTStkType
					,DT.FTPdtCode AS FTPdtCode
					--, SUM(((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
					, SUM(((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate	-- 04.02.00 --
					, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
					, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
					, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
					FROM TCNTPdtAdjStkDT DT with(nolock)
					INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
					WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
					AND HD.FTAjhDocType = '3'
					AND ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
					GROUP BY HD.FTBchCode,HD.FTAjhWhTo,HD.FTAjhDocNo,HD.FTAjhDocType,DT.FTPdtCode,HD.FDAjhDocDate

					--insert data to stock card
					INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
					SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
					GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
					FROM @TTmpPrcStk
					WHERE FTComName = @ptDocNo

					--update qty to stock balance
					UPDATE TCNTPdtStkBal with(rowlock) 
					SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho
					FROM TCNTPdtStkBal BAL
					INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
					WHERE TMP.FTComName=@ptDocNo 
					AND ISNULL(TMP.FCStkQty,0)<>0

					--insert to Stock balance
					INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					--SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
					--FROM @TTmpPrcStk TMP
					--LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
					--WHERE ISNULL(BAL.FTPdtCode,'') = ''
					-- 04.03.00 --
					SELECT DT.FTBchCode,HD.FTAjhWhTo,DT.FTPdtCode,SUM(((ISNULL(DT.FCAjdUnitQtyC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
					FROM TCNTPdtAdjStkHD HD with(nolock)
					INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
					LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON DT.FTBchCode = BAL.FTBchCode AND HD.FTAjhWhTo = BAL.FTWahCode AND DT.FTPdtCode = BAL.FTPdtCode
					WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
					AND ISNULL(BAL.FTPdtCode,'') = ''
					GROUP BY DT.FTBchCode,HD.FTAjhWhTo,DT.FTPdtCode
					-- 04.03.00 --

					UPDATE TVDTPdtStkBal WITH(ROWLOCK)
					--SET FCStkQty= BAL.FCStkQty + ((ISNULL(DT.FCAjdUnitQty,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
					SET FCStkQty= BAL.FCStkQty + ((ISNULL(DT.FCAjdUnitQtyC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))	-- 04.02.00 --
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho
					FROM TVDTPdtStkBal BAL
					--INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON BAL.FTPdtCode = DT.FTPdtCode AND BAL.FNLayRow = DT.FNAjdLayRow AND BAL.FNLayCol = DT.FNAjdLayCol
					--INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo AND BAL.FTWahCode = HD.FTAjhWhTo
					INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON BAL.FTWahCode = HD.FTAjhWhTo -- 5. --
					INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo AND BAL.FTPdtCode = DT.FTPdtCode AND BAL.FNLayRow = DT.FNAjdLayRow AND BAL.FNLayCol = DT.FNAjdLayCol -- 5. --
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
					WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
					AND HD.FTAjhDocType = '3'
					--AND ((ISNULL(DT.FCAjdUnitQty,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
					AND ((ISNULL(DT.FCAjdUnitQtyC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0	-- 04.02.00 --

					-- 04.03.00 --
					--insert to Stock balance
					INSERT INTO TVDTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FNCabSeq,FNLayRow,FNLayCol,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT DT.FTBchCode,HD.FTAjhWhTo,DT.FNCabSeq,DT.FNAjdLayRow,DT.FNAjdLayCol, DT.FTPdtCode,((ISNULL(DT.FCAjdUnitQtyC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) AS FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
					FROM TCNTPdtAdjStkHD HD with(nolock)
					INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
					LEFT JOIN TVDTPdtStkBal BAL with(NOLOCK) ON DT.FTBchCode = BAL.FTBchCode AND HD.FTAjhWhTo = BAL.FTWahCode AND DT.FTPdtCode = BAL.FTPdtCode AND BAL.FNLayRow = DT.FNAjdLayRow AND BAL.FNLayCol = DT.FNAjdLayCol
					WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
					AND ISNULL(BAL.FTPdtCode,'') = ''
					-- 04.03.00 --
				
					--Cost
					UPDATE TCNMPdtCostAvg with(rowlock)
					SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
					,FCPdtQtyBal = STK.FCStkQty
					,FDLastUpdOn = GETDATE()
					FROM TCNMPdtCostAvg COST
					INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
					INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
				END
			ELSE
				BEGIN
					IF @tAdjSeqChk = '1'
						BEGIN
							-- 03.04.00 --
							UPDATE TCNTPdtAdjStkDT
							SET FCAjdWahB4Adj = (CASE WHEN ISNULL(TMP.FTPdtCode,'') = '' THEN 0 ELSE FCAjdWahB4Adj END)
							FROM TCNTPdtAdjStkDT DT 
							LEFT JOIN (SELECT FTPdtCode,MIN(FCPdtUnitFact) AS FCPdtUnitFact
										FROM TCNTPdtAdjStkDT WITH(NOLOCK)
										WHERE FTBchCode=@ptBchCode AND FTAjhDocNo =@ptDocNo
										GROUP BY FTPdtCode
										) TMP ON TMP.FTPdtCode = DT.FTPdtCode AND TMP.FCPdtUnitFact = DT.FCPdtUnitFact
							WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
							-- 03.04.00 --

							--Update sale before adjust
							UPDATE TCNTPdtAdjStkDT WITH(ROWLOCK)
							SET FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
							,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
							FROM TCNTPdtAdjStkDT DT
							--LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
							--	FROM TPSTSalHD HD WITH(NOLOCK)
							--	INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
							--	WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
							--	GROUP BY HD.FDXshDocDate, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FDAjdDateTime > SAL.FDXshDocDate
							-- 03.01.00 --
							--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
							--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty -- 03.03.00 --
							LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdQtyAll*(-1) ELSE DT.FCXsdQtyAll END) AS FCXsdQty -- 04.07.00 --
								FROM TPSTSalHD HD WITH(NOLOCK)
								--INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
								INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'	-- 04.07.00 --
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.06.00 --
								INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2' -- 04.06.00 --
								WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
								AND HD.FTBchCode = @ptBchCode
								--GROUP BY HD.FTBchCode, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode
								GROUP BY HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode	-- 03.03.00 --
							-- 03.01.00 --
							--WHERE DT.FDAjdDateTime > SAL.FDXshDocDate
							WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo	-- 5. --

							--insert data to Temp
							INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
							SELECT @ptDocNo AS FTComName,HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
							,'5' AS FTStkType
							,DT.FTPdtCode AS FTPdtCode
							--, ((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) AS FCStkQty
							, SUM(((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty	-- 03.02.00 --
							,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
							, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
							, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
							, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
							FROM TCNTPdtAdjStkDT DT with(nolock)
							INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
							INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
							WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
							AND HD.FTAjhDocType IN ('2','3')
							AND ((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
							GROUP BY HD.FTBchCode,HD.FTAjhDocNo,DT.FTPdtCode,HD.FTAjhWhTo,FDAjhDocDate	-- 03.02.00 --

							--insert data to stock card
							INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
							SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
							GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
							FROM @TTmpPrcStk
							WHERE FTComName = @ptDocNo

							--update qty to stock balance
							--UPDATE TCNTPdtStkBal with(rowlock) 
							----SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
							--SET FCStkQty= TMP.FCStkQty	-- 03.03.00 --
							--,FDLastUpdOn = GETDATE()
							--,FTLastUpdBy = @ptWho
							--FROM TCNTPdtStkBal BAL
							--INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
							--WHERE TMP.FTComName=@ptDocNo 
							--AND ISNULL(TMP.FCStkQty,0)<>0
							-- 03.04.00 --
							UPDATE TCNTPdtStkBal with(rowlock) 
							SET FCStkQty= TMP.FCStkQty
							,FDLastUpdOn = GETDATE()
							,FTLastUpdBy = @ptWho
							FROM TCNTPdtStkBal BAL
							--INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAll+DT.FCAjdSaleB4AdjC1) AS FCStkQty 
							INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAllC1+DT.FCAjdSaleB4AdjC1) AS FCStkQty -- 04.01.00 --
									FROM TCNTPdtAdjStkDT DT with(nolock)
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) on HD.FTBchCode = DT.FTBchCode AND HD.FTAjhDocNo = DT.FTAjhDocNo
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
									WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
									GROUP BY HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode
									) TMP ON TMP.FTAjhBchTo = BAL.FTBchCode AND TMP.FTAjhWhTo = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
							-- 03.04.00 --

							--insert to Stock balance
							INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
							SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
							FROM @TTmpPrcStk TMP
							LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
							WHERE ISNULL(BAL.FTPdtCode,'') = ''

							-- 06.01.00 --
							IF EXISTS(SELECT FTPdtCode FROM TCNTPdtAdjStkDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTAjhDocNo = @ptDocNo) BEGIN
								-- update qty Diff
								UPDATE TCNTPdtAdjStkDTFhn
								SET FCAjdQtyAllDiff = (((ISNULL(DTF.FCAjdQtyC1,0) * DT.FCPdtUnitFact) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DTF.FCAjdWahB4Adj,0))
								,FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
								FROM TCNTPdtAdjStkDTFhn DTF with(nolock)
								INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
								INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'
								LEFT JOIN (SELECT HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN (DTF.FCXsdQty*DT.FCXsdFactor) * (-1) ELSE (DTF.FCXsdQty*DT.FCXsdFactor) END) AS FCXsdQty
											FROM TPSTSalHD HD WITH(NOLOCK)
											INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'
											INNER JOIN TPSTSalDTFhn DTF WITH(NOLOCK) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXshDocNo = DTF.FTXshDocNo AND DT.FNXsdSeqNo = DTF.FNXsdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
											INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'
											INNER JOIN TCNMWahouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'
											WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
											AND HD.FTBchCode = @ptBchCode
											GROUP BY HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode AND HD.FTBchCode = SAL.FTBchCode AND HD.FTAjhWhTo = SAL.FTWahCode
								WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
								AND HD.FTAjhDocType IN ('2','3')

								--insert data to Temp
								INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
								SELECT HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
								,'5' AS FTStkType
								,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
								,SUM(ISNULL(DTF.FCAjdQtyAllDiff,0)) AS FCStkQty
								,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
								, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
								FROM TCNTPdtAdjStkDT DT with(nolock)
								INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
								INNER JOIN TCNTPdtAdjStkDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
								WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
								AND HD.FTAjhDocType IN ('2','3')
								AND ISNULL(DTF.FCAjdQtyAllDiff,0) <> 0
								GROUP BY HD.FTBchCode,HD.FTAjhDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTAjhWhTo,FDAjhDocDate

								IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
									--Update Out
									UPDATE TFHTPdtStkBal WITH(ROWLOCK)
									SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
									,FDLastUpdOn = GETDATE()
									,FTLastUpdBy = @ptWho	
									FROM TFHTPdtStkBal STK
									INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

									--Create stk balance
									INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
									SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
									GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
									FROM @TTmpPrcStkFhn TMP
									LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
									WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

									--insert stk card
									INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
									SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
									FROM @TTmpPrcStkFhn
								END
							END
							-- 06.01.00 --

							--Cost
							UPDATE TCNMPdtCostAvg with(rowlock)
							SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
							,FCPdtQtyBal = STK.FCStkQty
							,FDLastUpdOn = GETDATE()
							FROM TCNMPdtCostAvg COST
							INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
							INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
						END
					ELSE
						IF @tAdjSeqChk = '2'
							BEGIN
								-- 03.04.00 --
								UPDATE TCNTPdtAdjStkDT
								SET FCAjdWahB4Adj = (CASE WHEN ISNULL(TMP.FTPdtCode,'') = '' THEN 0 ELSE FCAjdWahB4Adj END)
								FROM TCNTPdtAdjStkDT DT 
								LEFT JOIN (SELECT FTPdtCode,MIN(FCPdtUnitFact) AS FCPdtUnitFact
											FROM TCNTPdtAdjStkDT WITH(NOLOCK)
											WHERE FTBchCode=@ptBchCode AND FTAjhDocNo =@ptDocNo
											GROUP BY FTPdtCode
											) TMP ON TMP.FTPdtCode = DT.FTPdtCode AND TMP.FCPdtUnitFact = DT.FCPdtUnitFact
								WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
								-- 03.04.00 --

								--Update sale before adjust
								UPDATE TCNTPdtAdjStkDT WITH(ROWLOCK)
								SET FCAjdSaleB4AdjC2 = ISNULL(SAL.FCXsdQty,0)
								,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAllC2,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
								FROM TCNTPdtAdjStkDT DT
								--LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
								--	FROM TPSTSalHD HD WITH(NOLOCK)
								--	INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
								--	WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
								--	GROUP BY HD.FDXshDocDate, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FDAjdDateTime > SAL.FDXshDocDate
								-- 03.01.00 --
								--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
								--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty -- 03.03.00 --
								LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdQtyAll * (-1) ELSE DT.FCXsdQtyAll END) AS FCXsdQty -- 04.07.00 --
									FROM TPSTSalHD HD WITH(NOLOCK)
									--INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
									INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'	-- 04.07.00 --
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'	-- 04.06.00 --
									INNER JOIN TCNMWahouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.06.00 --
									WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
									AND HD.FTBchCode = @ptBchCode
									--GROUP BY HD.FTBchCode, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode
									GROUP BY HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode	-- 03.03.00 --
								-- 03.01.00 --
								--WHERE DT.FDAjdDateTime > SAL.FDXshDocDate
								WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo	-- 5. --

								--insert data to Temp
								INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
								SELECT @ptDocNo AS FTComName,HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
								,'5' AS FTStkType
								,DT.FTPdtCode AS FTPdtCode
								--, ((ISNULL(DT.FCAjdQtyAllC2,0) + ISNULL(DT.FCAjdSaleB4AdjC2,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
								, SUM(((ISNULL(DT.FCAjdQtyAllC2,0) + ISNULL(DT.FCAjdSaleB4AdjC2,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate	-- 03.02.00 --
								, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
								FROM TCNTPdtAdjStkDT DT with(nolock)
								INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
								WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
								AND HD.FTAjhDocType IN ('2','3')
								AND ((ISNULL(DT.FCAjdQtyAllC2,0) + ISNULL(DT.FCAjdSaleB4AdjC2,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
								GROUP BY HD.FTBchCode ,HD.FTAjhDocNo,DT.FTPdtCode,HD.FTAjhWhTo,HD.FDAjhDocDate	-- 03.02.00 --

								--insert data to stock card
								INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
								SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
								GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
								FROM @TTmpPrcStk
								WHERE FTComName = @ptDocNo

								--update qty to stock balance
								--UPDATE TCNTPdtStkBal with(rowlock) 
								----SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
								--SET FCStkQty= TMP.FCStkQty	-- 03.03.00 --
								--,FDLastUpdOn = GETDATE()
								--,FTLastUpdBy = @ptWho
								--FROM TCNTPdtStkBal BAL
								--INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
								--WHERE TMP.FTComName=@ptDocNo 
								--AND ISNULL(TMP.FCStkQty,0)<>0

								-- 03.04.00 --
								UPDATE TCNTPdtStkBal with(rowlock) 
								SET FCStkQty= TMP.FCStkQty
								,FDLastUpdOn = GETDATE()
								,FTLastUpdBy = @ptWho
								FROM TCNTPdtStkBal BAL
								--INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAll+DT.FCAjdSaleB4AdjC2) AS FCStkQty 
								INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAllC2+DT.FCAjdSaleB4AdjC2) AS FCStkQty	-- 04.01.00 --
										FROM TCNTPdtAdjStkDT DT with(nolock)
										INNER JOIN TCNTPdtAdjStkHD HD with(nolock) on HD.FTBchCode = DT.FTBchCode AND HD.FTAjhDocNo = DT.FTAjhDocNo
										INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
										WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
										GROUP BY HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode
										) TMP ON TMP.FTAjhBchTo = BAL.FTBchCode AND TMP.FTAjhWhTo = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
								-- 03.04.00 --

								--insert to Stock balance
								INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
								SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
								FROM @TTmpPrcStk TMP
								LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
								WHERE ISNULL(BAL.FTPdtCode,'') = ''

								-- 06.01.00 --
								IF EXISTS(SELECT FTPdtCode FROM TCNTPdtAdjStkDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTAjhDocNo = @ptDocNo) BEGIN
									-- update qty Diff
									UPDATE TCNTPdtAdjStkDTFhn
									SET FCAjdQtyAllDiff = (((ISNULL(DTF.FCAjdQtyC2,0) * DT.FCPdtUnitFact) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DTF.FCAjdWahB4Adj,0))
									,FCAjdSaleB4AdjC2 = ISNULL(SAL.FCXsdQty,0)
									FROM TCNTPdtAdjStkDTFhn DTF with(nolock)
									INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'
									LEFT JOIN (SELECT HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN (DTF.FCXsdQty*DT.FCXsdFactor) * (-1) ELSE (DTF.FCXsdQty*DT.FCXsdFactor) END) AS FCXsdQty
												FROM TPSTSalHD HD WITH(NOLOCK)
												INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'
												INNER JOIN TPSTSalDTFhn DTF WITH(NOLOCK) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXshDocNo = DTF.FTXshDocNo AND DT.FNXsdSeqNo = DTF.FNXsdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
												INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'
												INNER JOIN TCNMWahouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'
												WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
												AND HD.FTBchCode = @ptBchCode
												GROUP BY HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode AND HD.FTBchCode = SAL.FTBchCode AND HD.FTAjhWhTo = SAL.FTWahCode
									WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
									AND HD.FTAjhDocType IN ('2','3')

									--insert data to Temp
									INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
									SELECT HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
									,'5' AS FTStkType
									,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
									,SUM(ISNULL(DTF.FCAjdQtyAllDiff,0)) AS FCStkQty
									,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
									, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
									, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
									, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
									FROM TCNTPdtAdjStkDT DT with(nolock)
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
									INNER JOIN TCNTPdtAdjStkDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
									WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
									AND HD.FTAjhDocType IN ('2','3')
									AND ISNULL(DTF.FCAjdQtyAllDiff,0) <> 0
									GROUP BY HD.FTBchCode,HD.FTAjhDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTAjhWhTo,FDAjhDocDate

									IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
										--Update Out
										UPDATE TFHTPdtStkBal WITH(ROWLOCK)
										SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
										,FDLastUpdOn = GETDATE()
										,FTLastUpdBy = @ptWho	
										FROM TFHTPdtStkBal STK
										INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

										--Create stk balance
										INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
										SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
										GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
										FROM @TTmpPrcStkFhn TMP
										LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
										WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

										--insert stk card
										INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
										SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
										FROM @TTmpPrcStkFhn
									END
								END
								-- 06.01.00 --

								--Cost
								UPDATE TCNMPdtCostAvg with(rowlock)
								SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
								,FCPdtQtyBal = STK.FCStkQty
								,FDLastUpdOn = GETDATE()
								FROM TCNMPdtCostAvg COST
								INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
								INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
							END
						ELSE
							BEGIN
								-- 03.04.00 --
								UPDATE TCNTPdtAdjStkDT
								SET FCAjdWahB4Adj = (CASE WHEN ISNULL(TMP.FTPdtCode,'') = '' THEN 0 ELSE FCAjdWahB4Adj END)
								FROM TCNTPdtAdjStkDT DT 
								LEFT JOIN (SELECT FTPdtCode,MIN(FCPdtUnitFact) AS FCPdtUnitFact
											FROM TCNTPdtAdjStkDT WITH(NOLOCK)
											WHERE FTBchCode=@ptBchCode AND FTAjhDocNo =@ptDocNo
											GROUP BY FTPdtCode
											) TMP ON TMP.FTPdtCode = DT.FTPdtCode AND TMP.FCPdtUnitFact = DT.FCPdtUnitFact
								WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
								-- 03.04.00 --

								--Update sale before adjust
								UPDATE TCNTPdtAdjStkDT WITH(ROWLOCK)
								SET FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
								,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
								FROM TCNTPdtAdjStkDT DT
								--LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
								--	FROM TPSTSalHD HD WITH(NOLOCK)
								--	INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
								--	WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
								--	GROUP BY HD.FDXshDocDate, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FDAjdDateTime > SAL.FDXshDocDate
								-- 03.01.00 --
								--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
								--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty -- 03.03.00 --
								LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdQtyAll * (-1) ELSE DT.FCXsdQtyAll END) AS FCXsdQty -- 04.07.00 --
									FROM TPSTSalHD HD WITH(NOLOCK)
									--INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
									INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'	-- 04.07.00 --
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'	-- 04.06.00 --
									INNER JOIN TCNMWaHouse WAH WITH(NOLOcK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.06.00 --
									WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
									AND HD.FTBchCode = @ptBchCode
									--GROUP BY HD.FTBchCode, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode
									GROUP BY HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode	-- 03.03.00 --
								-- 03.01.00 --
								--WHERE DT.FDAjdDateTime > SAL.FDXshDocDate
								WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo	-- 5. --

								--insert data to Temp
								INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
								SELECT @ptDocNo AS FTComName,HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
								,'5' AS FTStkType
								,DT.FTPdtCode AS FTPdtCode
								--, ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
								, SUM(((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate		-- 03.02.00 --
								, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
								FROM TCNTPdtAdjStkDT DT with(nolock)
								INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
								WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
								AND HD.FTAjhDocType IN ('2','3')
								AND ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
								GROUP BY HD.FTBchCode ,HD.FTAjhDocNo,DT.FTPdtCode,HD.FTAjhWhTo,HD.FDAjhDocDate	-- 03.02.00 --

								--insert data to stock card
								INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
								SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
								GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
								FROM @TTmpPrcStk
								WHERE FTComName = @ptDocNo

								--update qty to stock balance
								--UPDATE TCNTPdtStkBal with(rowlock) 
								----SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
								--SET FCStkQty= TMP.FCStkQty	-- 03.03.00 --
								--,FDLastUpdOn = GETDATE()
								--,FTLastUpdBy = @ptWho
								--FROM TCNTPdtStkBal BAL
								--INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
								--WHERE TMP.FTComName=@ptDocNo 
								--AND ISNULL(TMP.FCStkQty,0)<>0

								-- 03.04.00 --
								UPDATE TCNTPdtStkBal with(rowlock) 
								SET FCStkQty= TMP.FCStkQty
								,FDLastUpdOn = GETDATE()
								,FTLastUpdBy = @ptWho
								FROM TCNTPdtStkBal BAL
								INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAll+DT.FCAjdSaleB4AdjC1) AS FCStkQty 
										FROM TCNTPdtAdjStkDT DT with(nolock)
										INNER JOIN TCNTPdtAdjStkHD HD with(nolock) on HD.FTBchCode = DT.FTBchCode AND HD.FTAjhDocNo = DT.FTAjhDocNo
										INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
										WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
										GROUP BY HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode
										) TMP ON TMP.FTAjhBchTo = BAL.FTBchCode AND TMP.FTAjhWhTo = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
								-- 03.04.00 --

								--insert to Stock balance
								INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
								SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
								FROM @TTmpPrcStk TMP
								LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
								WHERE ISNULL(BAL.FTPdtCode,'') = ''

								-- 06.01.00 --
								IF EXISTS(SELECT FTPdtCode FROM TCNTPdtAdjStkDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTAjhDocNo = @ptDocNo) BEGIN
									-- update qty Diff
									UPDATE TCNTPdtAdjStkDTFhn
									SET FCAjdQtyAllDiff = (((ISNULL(DTF.FCAjdQtyAll,0) * DT.FCPdtUnitFact) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DTF.FCAjdWahB4Adj,0))
									,FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
									FROM TCNTPdtAdjStkDTFhn DTF with(nolock)
									INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'
									LEFT JOIN (SELECT HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN (DTF.FCXsdQty*DT.FCXsdFactor) * (-1) ELSE (DTF.FCXsdQty*DT.FCXsdFactor) END) AS FCXsdQty
												FROM TPSTSalHD HD WITH(NOLOCK)
												INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'
												INNER JOIN TPSTSalDTFhn DTF WITH(NOLOCK) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXshDocNo = DTF.FTXshDocNo AND DT.FNXsdSeqNo = DTF.FNXsdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
												INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'
												INNER JOIN TCNMWahouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'
												WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
												AND HD.FTBchCode = @ptBchCode
												GROUP BY HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode AND HD.FTBchCode = SAL.FTBchCode AND HD.FTAjhWhTo = SAL.FTWahCode
									WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
									AND HD.FTAjhDocType IN ('2','3')

									--insert data to Temp
									INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
									SELECT HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
									,'5' AS FTStkType
									,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
									,SUM(ISNULL(DTF.FCAjdQtyAllDiff,0)) AS FCStkQty
									,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
									, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
									, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
									, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
									FROM TCNTPdtAdjStkDT DT with(nolock)
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
									INNER JOIN TCNTPdtAdjStkDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
									WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
									AND HD.FTAjhDocType IN ('2','3')
									AND ISNULL(DTF.FCAjdQtyAllDiff,0) <> 0
									GROUP BY HD.FTBchCode,HD.FTAjhDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTAjhWhTo,FDAjhDocDate

									IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
										--Update Out
										UPDATE TFHTPdtStkBal WITH(ROWLOCK)
										SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
										,FDLastUpdOn = GETDATE()
										,FTLastUpdBy = @ptWho	
										FROM TFHTPdtStkBal STK
										INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

										--Create stk balance
										INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
										SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
										GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
										FROM @TTmpPrcStkFhn TMP
										LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
										WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

										--insert stk card
										INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
										SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
										FROM @TTmpPrcStkFhn
									END
								END
								-- 06.01.00 --

								--Cost
								UPDATE TCNMPdtCostAvg with(rowlock)
								SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
								,FCPdtQtyBal = STK.FCStkQty
								,FDLastUpdOn = GETDATE()
								FROM TCNMPdtCostAvg COST
								INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
								INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
							END
				END
		END

	END	-- 3. --
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxBchPdtTnf')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxBchPdtTnf
GO
CREATE PROCEDURE [dbo].STP_DOCxBchPdtTnf
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --	
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	24/03/2020		Em		create  
00.02.00	26/03/2020		Em		แก้ไขข้อมูลลงตามสาขาต้นทางปลายทาง
00.03.00	09/04/2020		Em		แก้ไขปรับปรุง
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
----------------------------------------------------------------------*/
SET @tTrans = 'PrcBchTnf'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') AS FTXthStaPrcStk FROM TCNTPdtTbxHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)	

	IF @tStaPrc <> '1'	
	BEGIN
		-- 05.01.00 --
		DELETE STK WITH(ROWLOCK)
		FROM TCNTPdtStkCrd STK
		INNER JOIN TCNTPdtTbxHD HD WITH(NOLOCK) ON HD.FTXthDocNo = STK.FTStkDocNo AND (HD.FTXthBchFrm = STK.FTBchCode OR HD.FTXthBchTo = STK.FTBchCode) 
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE STK WITH(ROWLOCK)
		FROM TFHTPdtStkCrd STK
		INNER JOIN TCNTPdtTbxHD HD WITH(NOLOCK) ON HD.FTXthDocNo = STK.FTStfDocNo AND (HD.FTXthBchFrm = STK.FTBchCode OR HD.FTXthBchTo = STK.FTBchCode) 
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		-- 06.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTbxHD HD WITH(NOLOCK) ON HD.FTXthBchFrm = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTbxHD HD WITH(NOLOCK) ON HD.FTXthBchTo = WAH.FTBchCode AND HD.FTXthWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)
		
		IF @tStaPrcStkFrm = '2'
		BEGIN
			--Create stk balance
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
			SELECT DISTINCT HD.FTXthBchFrm,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,	-- 00.02.00 --
			GETDATE() AS FDLastUpd,@ptWho,	
			GETDATE() AS FDCreateOn,@ptWho	
			FROM TCNTPdtTbxHD HD WITH(NOLOCK)		
			INNER JOIN TCNTPdtTbxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --		
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchFrm = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''

			--Update Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Tfb.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho	
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll	-- 00.03.00 --
				FROM TCNTPdtTbxHD HD WITH(NOLOCK)
				INNER JOIN TCNTPdtTbxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
				GROUP BY HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Tfb  ON Tfb.FTXthBchFrm = STK.FTBchCode AND Tfb.FTXthWhFrm = STK.FTWahCode AND Tfb.FTPdtCode = STK.FTPdtCode	-- 00.03.00 --

			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 00.02.00 --
			,'2' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTbxDT DT with(nolock)
			INNER JOIN TCNTPdtTbxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 00.02.00 --

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTbxDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 00.02.00 --
				,'2' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode, DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTbxDT DT with(nolock)
				INNER JOIN TCNTPdtTbxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTbxDTFhn DTF WITH(NOLOCK) ON HD.FTBchCode = DTF.FTBchCode AND HD.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate	-- 00.02.00 --

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,(TMP.FCStfQty *(-1)) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END

		IF @tStaPrcStkTo = '2'
		BEGIN
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
			SELECT DISTINCT HD.FTXthBchTo,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,	-- 00.02.00 --
			GETDATE() AS FDLastUpdOn,@ptWho,	
			GETDATE() AS FDCreateOn,@ptWho		
			FROM TCNTPdtTbxHD HD WITH(NOLOCK)		
			INNER JOIN TCNTPdtTbxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo	
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchTo = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''
			GROUP BY HD.FTXthBchTo,HD.FTXthWhTo,DT.FTPdtCode	-- 00.02.00 --

			--Update In
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(Tfb.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho	
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll	-- 00.03.00 --
					FROM TCNTPdtTbxHD HD WITH(NOLOCK)		
					INNER JOIN TCNTPdtTbxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo	
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
					WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
					GROUP BY HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode) Tfb  ON Tfb.FTXthBchTo = STK.FTBchCode AND Tfb.FTXthWhTo = STK.FTWahCode AND Tfb.FTPdtCode = STK.FTPdtCode	-- 00.03.00 --

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchTo,HD.FTXthDocNo AS FTStkDocNo	-- 00.02.00 --
			,'1' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTbxDT DT with(nolock)
			INNER JOIN TCNTPdtTbxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTXthBchTo,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 00.02.00 --

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTbxDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				DELETE FROM @TTmpPrcStkFhn

				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTXthBchTo,HD.FTXthDocNo AS FTStkDocNo	-- 00.02.00 --
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode, DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTbxDT DT with(nolock)
				INNER JOIN TCNTPdtTbxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTbxDTFhn DTF WITH(NOLOCK) ON HD.FTBchCode = DTF.FTBchCode AND HD.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTXthBchTo,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate	-- 00.02.00 --

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		--insert to stock card
		INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
		SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
		GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM @TTmpPrcStk

		--Cost
		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
		,FCPdtQtyBal = STK.FCStkQty
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '1'
		INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode

		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*COST.FCPdtCostEx)
		,FCPdtQtyBal = STK.FCStkQty
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '2'
		INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode
		
	END	
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
	SELECT ERROR_MESSAGE()
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxBchPdtTnfIn')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxBchPdtTnfIn
GO
CREATE PROCEDURE [dbo].STP_DOCxBchPdtTnfIn
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
03.01.00	25/03/2020		Em		create  
03.02.00	26/03/2020		Em		เพิ่มการตรวจสอบ DocType
03.03.00	27/03/2020		Em		แก้ไขขนาดฟิลด์ BchCode จาก 3 เป็น 5
03.04.00	13/04/2020		Em		แก้ไขปรับปรุง
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	01/07/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
----------------------------------------------------------------------*/
SET @tTrans = 'PrcBchIn'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTbiHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)

	IF @tStaPrc <> '1'
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTbiHD HD WITH(NOLOCK) ON HD.FTXthBchTo = WAH.FTBchCode AND HD.FTXthWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			--Create stk balance	
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)		
			SELECT DISTINCT HD.FTXthBchTo,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,	-- 03.01.00 --
			GETDATE() AS FDLastUpdOn,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTbiHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTbiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo -- 03.01.00 --
			AND ISNULL(STK.FTPdtCode,'') = ''	

			--Update balance In
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(Tbi.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Tbi.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll -- 03.01.00 --
				FROM TCNTPdtTbiHD HD WITH(NOLOCK)
				INNER JOIN TCNTPdtTbiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo	-- 03.01.00 --
				GROUP BY HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode) Tbi  ON Tbi.FTXthBchTo = STK.FTBchCode AND Tbi.FTXthWhTo = STK.FTWahCode AND Tbi.FTPdtCode = STK.FTPdtCode -- 03.01.00 --

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchTo,HD.FTXthDocNo AS FTStkDocNo	-- 03.01.00 --
			,'1' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
			FROM TCNTPdtTbiDT DT with(nolock)
			INNER JOIN TCNTPdtTbiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate,HD.FTXthBchTo

			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTbiDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
				FROM TCNTPdtTbiDT DT with(nolock)
				INNER JOIN TCNTPdtTbiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTbiDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
				AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
				GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END
			
		UPDATE TCNTPdtIntDTBch WITH(ROWLOCK)
		SET FCXtdQtyRcv = ISNULL(FCXtdQtyRcv,0) + ISNULL(DTi.FCXtdQtyAll,0)
		,FTXtdRvtRef = HDi.FTXthDocNo 
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TCNTPdtIntDTBch DT
		INNER JOIN TCNTPdtTbiHD HDi WITH(NOLOCK) ON HDi.FTXthRefInt = DT.FTXthDocNo AND HDi.FTXthBchTo = DT.FTXthBchTo AND HDi.FTXthWhTo = DT.FTXthWahTo
		INNER JOIN TCNTPdtTbiDT DTi WITH(NOLOCK) ON HDi.FTXthDocNo = DTi.FTXthDocNo AND DTi.FTPdtCode = DT.FTPdtCode
		--WHERE HDi.FTXthBchTo = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo  -- 03.01.00 --
		--AND ISNULL(DTi.FTXtdDocNoRef,'') = ''
		AND HDi.FNXthDocType = 5  -- 2. --

		UPDATE TCNTPdtTboHD WITH(ROWLOCK)
		SET FTXthRefInt = @ptDocNo
		FROM TCNTPdtTboHD HDo
		INNER JOIN TCNTPdtTbiHD HDi WITH(NOLOCK) ON HDo.FTXthDocNo = HDi.FTXthRefInt
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo

	END 
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxBchPdtTnfOut')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxBchPdtTnfOut
GO
CREATE PROCEDURE [dbo].STP_DOCxBchPdtTnfOut
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5),  -- 2. --
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
03.01.00	25/03/2020		Em		create  
03.02.00	27/03/2020		Em		แก้ไขขนาดฟิลด์สาขาจาก 3 เป็น 5
03.03.00	13/04/2020		Em		แก้ไขปรับปรุง
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	01/07/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
----------------------------------------------------------------------*/
SET @tTrans = 'PrcBchOut'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTboHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)

	IF @tStaPrc <> '1'	-- 6. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTXthBchFrm = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkFrm = '2'
		BEGIN
			--Create stk balance
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)	
			SELECT DISTINCT HD.FTXthBchFrm,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,	-- 03.03.00 --
			GETDATE() AS FDLastUpd,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTboHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTboDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchFrm = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode	-- 03.03.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''

			--Update balance Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Two.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Two.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll	-- 03.03.00 --
			FROM TCNTPdtTboHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTboDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Two  ON Two.FTXthBchFrm = STK.FTBchCode AND Two.FTXthWhFrm = STK.FTWahCode AND Two.FTPdtCode = STK.FTPdtCode	-- 03.03.00 --

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 03.03.00 --
			,'2' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
			FROM TCNTPdtTboDT DT with(nolock)
			INNER JOIN TCNTPdtTboHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 03.03.00 --

			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTboDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'2' AS FTStkType	-- 03.02.00 --
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
				FROM TCNTPdtTboDT DT with(nolock)
				INNER JOIN TCNTPdtTboHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTboDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty*(-1) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		--Delete old data
		DELETE FROM TCNTPdtIntDTBch WHERE  FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo

		--Insert new data
		INSERT INTO TCNTPdtIntDTBch(FTBchCode, FTXthDocNo, FNXtdSeqNo, FNXthDocType, FTXthBchTo, FTXthWahTo, 
			FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, FCXtdQtyRcv, FCXtdQtyAll,		
			FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
		SELECT HD.FTBchCode, HD.FTXthDocNo, FNXtdSeqNo, '2', HD.FTXthBchTo, FTXthWhTo, 
			FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, 0 AS FCXtdQtyRcv, FCXtdQtyAll,		
			GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM TCNTPdtTboDT DT WITH(NOLOCK)
		INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo 
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		
	END	 
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxPurchaseInvPrc')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxPurchaseInvPrc
GO
CREATE PROCEDURE [dbo].STP_DOCxPurchaseInvPrc
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tDate varchar(10)
DECLARE @tTime varchar(8)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5),	-- 3. -- 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,2), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,2),
   FCStkCostIn decimal(18,2),
   FCStkCostEx decimal(18,2)
   ) 
DECLARE @tStaPrc varchar(1)		-- 2. --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
DECLARE @tTrans varchar(20)
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	12/06/2018		Em		create 
00.02.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร 
00.03.00	24/07/2019		Em		แก้ไขขนาดฟิลด์ Branch จาก 3 เป็น 5
00.04.00	30/07/2019		Em		เพิ่ม Insert StkBal และปรับต้นทุน
00.05.00	31/07/2019		Em		แก้ไขการปรับต้นทุน
04.01.00	20/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
05.02.00	30/03/2021		Em		แก้ไขให้ตรวจสอบจำนวนที่เป็น 0
06.01.00	20/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
----------------------------------------------------------------------*/
SET @tTrans = 'PrcStk'
BEGIN TRY
	BEGIN TRANSACTION @tTrans
	SET @tDate = CONVERT(VARCHAR(10),GETDATE(),121)
	SET @tTime = CONVERT(VARCHAR(8),GETDATE(),108)
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXphStaPrcStk,'') AS FTXphStaPrcStk FROM TAPTPiHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXphDocNo = @ptDocNo)	-- 2. --

	IF @tStaPrc <> '1'	-- 2. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TAPTPiHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTWahCode = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXphDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXphDocNo AS FTStkDocNo
			,'1' AS FTStkType
			,DT.FTPdtCode AS FTPdtStkCode
			, SUM(FCXpdQtyAll) AS FCStkQty,HD.FTWahCode AS FTWahCode,HD.FDXphDocDate AS FDStkDate
			, ROUND(SUM(DT.FCXpdNet)/SUM(FCXpdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXpdCostIn)/SUM(FCXpdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXpdCostEx)/SUM(FCXpdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TAPTPiDT DT with(nolock)
			INNER JOIN TAPTPiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXphDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXphDocNo,HD.FNXphDocType,DT.FTPdtCode,HD.FDXphDocDate

			--insert data to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk

			--update qty to stock balance
			UPDATE TCNTPdtStkBal with(rowlock) 
			SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho
			FROM TCNTPdtStkBal BAL
			INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
			AND ISNULL(TMP.FCStkQty,0) <> 0

			-- 4. --
			--insert to Stock balance
			INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
			SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
			FROM @TTmpPrcStk TMP
			LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
			WHERE ISNULL(BAL.FTPdtCode,'') = ''
			-- 4. --

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TAPTPiDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXphDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXphDocNo AS FTStkDocNo
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXpdQty * DT.FCXpdFactor) AS FCStkQty,HD.FTWahCode AS FTWahCode,HD.FDXphDocDate AS FDStkDate
				, ROUND(SUM(DT.FCXpdSetPrice)/SUM(DT.FCXpdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXpdCostIn)/SUM(DT.FCXpdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXpdCostEx)/SUM(DT.FCXpdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TAPTPiDT DT with(nolock)
				INNER JOIN TAPTPiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo
				INNER JOIN TAPTPiDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXphDocNo = DTF.FTXphDocNo AND DT.FNXpdSeqNo = DTF.FNXpdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXphDocNo =@ptDocNo
				AND ISNULL(DT.FTXpdStaPrcStk,'') = ''	-- 02.01.00 --
				AND ISNULL(HD.FTWahCode,'') <> ''	-- 02.01.00 --
				GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXphDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXphDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --

			-- 4. --
			--Cost
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*TMP.FCStkCostEx)
			--,FCPdtCostEx = ROUND((ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*TMP.FCStkCostEx)) / STK.FCStkQty,2)
			,FCPdtCostEx = (CASE WHEN ISNULL(STK.FCStkQty,0) = 0 THEN FCPdtCostEx ELSE ROUND((ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*TMP.FCStkCostEx)) / STK.FCStkQty,4) END) -- 05.02.00 -- -- 06.02.00 --
			,FCPdtCostLast = TMP.FCStkCostEx
			,FCPdtQtyBal = STK.FCStkQty
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			--INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode
			-- 5. --
			INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
		
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostIn = ROUND(ISNULL(FCPdtCostEx,0) + (ISNULL(FCPdtCostEx,0) * VAT.FCVatRate/100),4)	-- 06.02.00 --
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			INNER JOIN TCNMPdt PDT with(nolock) ON COST.FTPdtCode = PDT.FTPdtCode
			INNER JOIN (
				SELECT FTVatCode,MAX(FDVatStart) AS FDVatStart 
				FROM TCNMVatRate with(nolock) 
				WHERE CONVERT(VARCHAR(10),FDVatStart,121) < CONVERT(VARCHAR(10),GETDATE(),121) 
				GROUP BY FTVatCode) VATT ON PDT.FTVatCode = VATT.FTVatCode
			INNER JOIN TCNMVatRate VAT with(nolock) ON VATT.FTVatCode = VAT.FTVatCode AND VATT.FDVatStart = VAT.FDVatStart
			-- 5. --

			INSERT INTO TCNMPdtCostAvg(FTPdtCode,FCPdtCostEx,FCPdtCostIn,FCPdtCostLast,FCPdtCostAmt,FCPdtQtyBal,FDLastUpdOn)
			SELECT TMP.FTPdtCode,FCStkCostEx,FCStkCostIn,FCStkCostEx,(FCStkQty*FCStkCostEx) AS FCStkCostAmt,FCStkQty,GETDATE()
			FROM @TTmpPrcStk TMP
			LEFT JOIN TCNMPdtCostAvg COST with(nolock) ON TMP.FTPdtCode = COST.FTPdtCode
			WHERE ISNULL(COST.FTPdtCode,'') = ''
			-- 4. --
		END
		
		-- 5. --
		UPDATE TCNMPdtSpl with(rowlock)
		SET FCSplLastPrice = DT.FCXpdSetPrice
		FROM TCNMPdtSpl SPL
		INNER JOIN TAPTPiHD HD with(nolock) ON SPL.FTSplCode = HD.FTSplCode
		INNER JOIN TAPTPiDT DT with(nolock) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXphDocNo = DT.FTXphDocNo AND SPL.FTPdtCode = DT.FTPdtCode AND SPL.FTBarCode = DT.FTXpdBarCode
		WHERE HD.FTBchCode=@ptBchCode AND HD.FTXphDocNo =@ptDocNo
		-- 5. --
	END		-- 2. --
	
	COMMIT TRANSACTION @tTrans
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    ROLLBACK TRANSACTION @tTrans
	SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxWahPdtTnf')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxWahPdtTnf
GO
CREATE PROCEDURE [dbo].STP_DOCxWahPdtTnf
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5), --4--
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)		-- 3. --
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Versin		Date			User	Remark
00.01.00	28/03/2019		Em		create  
00.02.00	13/06/2019		Em		แก้ไขชื่อตาราง
00.03.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร
00.04.00	22/07/2019		Em		แก้ไขขนาดฟิลด์ BchCode จาก 3 เป็น 5
00.05.00	30/07/2019		Em		เพิ่มอัพเดทต้นทุน
00.06.00	31/07/2019		Em		แก้ไขปรับปรุง
00.07.00	20/09/2019		Em		แก้ไขปรับปรุง
04.01.00	19/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
----------------------------------------------------------------------*/
SET @tTrans = 'PrcWahTnf'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') AS FTXthStaPrcStk FROM TCNTPdtTwxHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)	-- 3. --

	IF @tStaPrc <> '1'	-- 3. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTwxHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTwxHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTXthWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkFrm = '2'
		BEGIN
			--Create stk balance
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
			SELECT DISTINCT HD.FTBchCode,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,
			GETDATE() AS FDLastUpd,@ptWho,	-- 7. --
			GETDATE() AS FDCreateOn,@ptWho	-- 7. --
			FROM TCNTPdtTwxHD HD WITH(NOLOCK)		--4.--
			INNER JOIN TCNTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo		--4.-
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''
			
			--Update Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Tfw.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho	-- 7. --
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll
			FROM TCNTPdtTwxHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			GROUP BY HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Tfw  ON Tfw.FTBchCode = STK.FTBchCode AND Tfw.FTXthWhFrm = STK.FTWahCode AND Tfw.FTPdtCode = STK.FTPdtCode

			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
			,'2' AS FTStkType
			,FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTwxDT DT with(nolock)
			INNER JOIN TCNTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTwxDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'2' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTwxDT DT with(nolock)
				INNER JOIN TCNTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTwxDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty*(-1) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END

		IF @tStaPrcStkTo = '2'
		BEGIN
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
			SELECT DISTINCT HD.FTBchCode,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,	-- 7. --
			GETDATE() AS FDLastUpdOn,@ptWho,	-- 7. --
			GETDATE() AS FDCreateOn,@ptWho		-- 7. --
			FROM TCNTPdtTwxHD HD WITH(NOLOCK)		--4.--
			INNER JOIN TCNTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo		--4.--
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''
			GROUP BY HD.FTBchCode,HD.FTXthWhTo,DT.FTPdtCode	-- 7. --

			--Update In
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(Tfw.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho	-- 7. --
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll
					FROM TCNTPdtTwxHD HD WITH(NOLOCK)		--4.--
					INNER JOIN TCNTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo	--4.--
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
					WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
					GROUP BY HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode) Tfw  ON Tfw.FTBchCode = STK.FTBchCode AND Tfw.FTXthWhTo = STK.FTWahCode AND Tfw.FTPdtCode = STK.FTPdtCode

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
			,'1' AS FTStkType
			,FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTwxDT DT with(nolock)
			INNER JOIN TCNTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTwxDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				DELETE FROM @TTmpPrcStkFhn

				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTwxDT DT with(nolock)
				INNER JOIN TCNTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTwxDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		--insert to stock card
		INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
		SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
		GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM @TTmpPrcStk

		-- 5. --
		--Cost
		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
		,FCPdtQtyBal = STK.FCStkQty
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '1'
		INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode

		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*COST.FCPdtCostEx)
		,FCPdtQtyBal = STK.FCStkQty
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '2'
		INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode
		-- 5. --
	END	-- 3. --
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxWahPdtTnfIn')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxWahPdtTnfIn
GO
CREATE PROCEDURE [dbo].STP_DOCxWahPdtTnfIn
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)		-- 5. --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	12/02/2019		Em		create  
00.02.00	28/03/2019		Em		เพิ่มการ Update stock balance
00.03.00	23/04/2019		Em		เพิ่มการอัพเดท Stock Vending และแก้ไขการอ้างอิงเอกสาร
00.04.00	17/06/2019		Em		แก้ไขเอาฟิลด์ StkCode และ Insert StkCard
00.05.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร
02.01.00	03/03/2020		Em		ปรับตามโครงสร้างใหม่
03.01.00	13/03/2020		Em		แก้ไขให้อัพเดทเลขที่อ้างอิง
04.01.00	20/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
----------------------------------------------------------------------*/
SET @tTrans = 'PrcWahIn'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	--SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTwiHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)	-- 5. --
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTwiHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)  -- 02.01.00 --

	IF @tStaPrc <> '1'	-- 5. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTwiHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTXthWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)		--4.--
			SELECT DISTINCT HD.FTBchCode,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,		--4.--
			GETDATE() AS FDLastUpdOn,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTwiHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''		--4.--
			AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
			AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --

			--Update balance In
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(Twi.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Twi.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll		--4.--
			FROM TCNTPdtTwiHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
			AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
			GROUP BY HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode) Twi  ON Twi.FTBchCode = STK.FTBchCode AND Twi.FTXthWhTo = STK.FTWahCode AND Twi.FTPdtCode = STK.FTPdtCode		--4.--

			--3.--
			UPDATE TVDTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(DTV.FCXtdQty,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = DT.FTLastUpdBy
			FROM TVDTPdtStkBal STK
			INNER JOIN TCNTPdtTwiDTVD DTV WITH(NOLOCK) ON STK.FTBchCode = DTV.FTBchCode AND STK.FNLayRow = DTV.FNLayRow AND STK.FNLayCol = DTV.FNLayCol
			INNER JOIN TCNTPdtTwiDT DT WITH(NOLOCK) ON DTV.FTBchCode = DT.FTBchCode AND DTV.FTXthDocNo = DT.FTXthDocNo AND DTV.FNXtdSeqNo = DT.FNXtdSeqNo
			INNER JOIN TCNTPdtTwiHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo AND ISNULL(HD.FTXthWhTo,'') = STK.FTWahCode  -- 02.01.00 --
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE DT.FTBchCode = @ptBchCode AND DT.FTXthDocNo = @ptDocNo
			AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
			AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
			--3.--

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
			,'1' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTwiDT DT with(nolock)
			INNER JOIN TCNTPdtTwiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
			AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
			GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate

			--4.--
			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk
			--4.--

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTwiDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTwiDT DT with(nolock)
				INNER JOIN TCNTPdtTwiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTwiDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
				AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
				GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END

		UPDATE TCNTPdtIntDT WITH(ROWLOCK)
		SET FCXtdQtyRcv = ISNULL(FCXtdQtyRcv,0) + ISNULL(DTi.FCXtdQtyAll,0)
		,FTXtdRvtRef = @ptDocNo	-- 03.01.00 --
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TCNTPdtIntDT DT
		INNER JOIN TCNTPdtTwiHD HDi WITH(NOLOCK) ON HDi.FTXthRefInt = DT.FTXthDocNo
		INNER JOIN TCNTPdtTwiDT DTi WITH(NOLOCK) ON HDi.FTXthDocNo = DTi.FTXthDocNo AND DTi.FTPdtCode = DT.FTPdtCode
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo
		AND ISNULL(DTi.FTXtdDocNoRef,'') = ''


		--3.--
		UPDATE TCNTPdtTwoHD WITH(ROWLOCK)
		SET FTXthRefInt = @ptDocNo
		FROM TCNTPdtTwoHD HDo
		INNER JOIN TCNTPdtTwiHD HDi WITH(NOLOCK) ON HDo.FTXthDocNo = HDi.FTXthRefInt
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo
		--3.--

		UPDATE TCNTPdtIntDT WITH(ROWLOCK)
		SET FCXtdQtyRcv = ISNULL(FCXtdQtyRcv,0) + ISNULL(DTi.FCXtdQtyAll,0)
		,FTXtdRvtRef = @ptDocNo	-- 03.01.00 --
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TCNTPdtIntDT DT
		INNER JOIN TCNTPdtTwiDT DTi WITH(NOLOCK) ON DT.FTBchCode = DTi.FTXtdBchRef AND DT.FTXthDocNo = DTi.FTXtdDocNoRef AND DT.FTPdtCode = DT.FTPdtCode
		WHERE DTi.FTBchCode = @ptBchCode AND DTi.FTXthDocNo = @ptDocNo
		AND ISNULL(DTi.FTXtdDocNoRef,'') <> ''

	END -- 5. --
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxWahPdtTnfOut')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxWahPdtTnfOut
GO
CREATE PROCEDURE [dbo].STP_DOCxWahPdtTnfOut
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)		-- 6. --
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	08/02/2019		Em		create  
00.02.00	23/04/2019		Em		เพิ่มการอัพเดท Stock Vending
00.05.00	17/06/2019		Em		แก้ไขเอาฟิลด์ StkCode และ Insert StkCard
00.06.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร
03.01.00	26/03/2020		Em		เพิ่มฟิลด์ FNXthDocType ใน IntDT
03.02.00	27/03/2020		Em		แก้ไข Type ลง stkcard
04.01.00	19/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
----------------------------------------------------------------------*/
SET @tTrans = 'PrcWahOut'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTwoHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)	-- 6. --

	IF @tStaPrc <> '1'	-- 6. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		--Delete old data
		DELETE FROM TCNTPdtIntDT WHERE  FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo
		
		--Insert new data
		INSERT INTO TCNTPdtIntDT(FTBchCode, FTXthDocNo, FNXthDocType, FNXtdSeqNo, FTXthWahTo, FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, FCXtdQtyRcv, FCXtdQtyAll,	-- 03.02.00 --
			FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
		SELECT HD.FTBchCode, HD.FTXthDocNo, 2, FNXtdSeqNo, HD.FTXthWhTo , FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, 0 AS FCXtdQtyRcv, FCXtdQtyAll,	-- 03.02.00 --
			GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM TCNTPdtTwoDT DT WITH(NOLOCK)
		INNER JOIN TCNTPdtTwoHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTwoHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkFrm = '2'
		BEGIN
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)		--5.--
			SELECT DISTINCT HD.FTBchCode,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,		--5.--
			GETDATE() AS FDLastUpd,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTwoHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwoDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode		--5.--
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''		--5.--

			--Update balance Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Two.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Two.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll
			FROM TCNTPdtTwoHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwoDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			GROUP BY HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Two  ON Two.FTBchCode = STK.FTBchCode AND Two.FTXthWhFrm = STK.FTWahCode AND Two.FTPdtCode = STK.FTPdtCode

			--2.--
			--Update stock balance vending
			UPDATE TVDTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(DTV.FCXtdQty,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = DT.FTLastUpdBy
			FROM TVDTPdtStkBal STK
			INNER JOIN  TCNTPdtTwoDTVD DTV WITH(NOLOCK) ON STK.FTBchCode = DTV.FTBchCode AND STK.FNLayRow = DTV.FNLayRow AND STK.FNLayCol = DTV.FNLayCol
			INNER JOIN TCNTPdtTwoDT DT WITH(NOLOCK) ON STK.FTBchCode = DT.FTBchCode AND STK.FTPdtCode = DT.FTPdtCode AND DTV.FNXtdSeqNo = DT.FNXtdSeqNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE DT.FTBchCode = @ptBchCode AND DT.FTXthDocNo = @ptDocNo
			--2.--
		
			--5.--
			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
			--,'1' AS FTStkType
			,'2' AS FTStkType	-- 03.02.00 --
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTwoDT DT with(nolock)
			INNER JOIN TCNTPdtTwoHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate
		
			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk
			--5.--

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTwoDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'2' AS FTStkType	-- 03.02.00 --
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTwoDT DT with(nolock)
				INNER JOIN TCNTPdtTwoHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTwoDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty*(-1) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		
	END	 -- 6. --
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH

GO


IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxBchPdtTnfIn')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxBchPdtTnfIn
GO
CREATE PROCEDURE [dbo].STP_DOCxBchPdtTnfIn
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
03.01.00	25/03/2020		Em		create  
03.02.00	26/03/2020		Em		เพิ่มการตรวจสอบ DocType
03.03.00	27/03/2020		Em		แก้ไขขนาดฟิลด์ BchCode จาก 3 เป็น 5
03.04.00	13/04/2020		Em		แก้ไขปรับปรุง
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	01/07/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	05/07/2021		Em		เพิ่มการอัพเดท IntDTFhn
----------------------------------------------------------------------*/
SET @tTrans = 'PrcBchIn'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTbiHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)

	IF @tStaPrc <> '1'
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo

		DELETE TFHTPdtStkCrd WITH(ROWLOCK)	-- 06.02.00 --
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo -- 06.02.00 --
		-- 05.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTbiHD HD WITH(NOLOCK) ON HD.FTXthBchTo = WAH.FTBchCode AND HD.FTXthWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			--Create stk balance	
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)		
			SELECT DISTINCT HD.FTXthBchTo,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,	-- 03.01.00 --
			GETDATE() AS FDLastUpdOn,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTbiHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTbiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchTo = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo -- 03.01.00 --
			AND ISNULL(STK.FTPdtCode,'') = ''	

			--Update balance In
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(Tbi.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Tbi.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll -- 03.01.00 --
				FROM TCNTPdtTbiHD HD WITH(NOLOCK)
				INNER JOIN TCNTPdtTbiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo	-- 03.01.00 --
				GROUP BY HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode) Tbi  ON Tbi.FTXthBchTo = STK.FTBchCode AND Tbi.FTXthWhTo = STK.FTWahCode AND Tbi.FTPdtCode = STK.FTPdtCode -- 03.01.00 --

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchTo,HD.FTXthDocNo AS FTStkDocNo	-- 03.01.00 --
			,'1' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
			FROM TCNTPdtTbiDT DT with(nolock)
			INNER JOIN TCNTPdtTbiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate,HD.FTXthBchTo

			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTbiDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTXthBchTo,HD.FTXthDocNo AS FTStkDocNo
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
				FROM TCNTPdtTbiDT DT with(nolock)
				INNER JOIN TCNTPdtTbiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTbiDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
				AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
				GROUP BY HD.FTXthBchTo,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END

				-- 06.02.00 --
				UPDATE TCNTPdtIntDTFhnBch WITH(ROWLOCK)
				SET FCXtdQtyRcv = ISNULL(FCXtdQtyRcv,0) + ISNULL(DTF.FCXtdQty,0)
				FROM TCNTPdtIntDTFhnBch DT
				INNER JOIN TCNTPdtTbiHD HDi WITH(NOLOCK) ON HDi.FTXthRefInt = DT.FTXthDocNo AND HDi.FTXthBchTo = DT.FTXthBchTo AND HDi.FTXthWhTo = DT.FTXthWahTo
				INNER JOIN TCNTPdtTbiDT DTi WITH(NOLOCK) ON HDi.FTXthDocNo = DTi.FTXthDocNo AND DTi.FTPdtCode = DT.FTPdtCode
				INNER JOIN TCNTPdtTbiDTFhn DTF with(nolock) ON DTi.FTBchCode = DTF.FTBchCode AND DTi.FTXthDocNo = DTF.FTXthDocNo AND DTi.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode AND DT.FTFhnRefCode = DTF.FTFhnRefCode
				WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo  -- 03.01.00 --
				AND HDi.FNXthDocType = 5  -- 2. --
				-- 06.02.00 --
			END
			-- 06.01.00 --
		END
			
		UPDATE TCNTPdtIntDTBch WITH(ROWLOCK)
		SET FCXtdQtyRcv = ISNULL(FCXtdQtyRcv,0) + ISNULL(DTi.FCXtdQtyAll,0)
		,FTXtdRvtRef = HDi.FTXthDocNo 
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TCNTPdtIntDTBch DT
		INNER JOIN TCNTPdtTbiHD HDi WITH(NOLOCK) ON HDi.FTXthRefInt = DT.FTXthDocNo AND HDi.FTXthBchTo = DT.FTXthBchTo AND HDi.FTXthWhTo = DT.FTXthWahTo
		INNER JOIN TCNTPdtTbiDT DTi WITH(NOLOCK) ON HDi.FTXthDocNo = DTi.FTXthDocNo AND DTi.FTPdtCode = DT.FTPdtCode
		--WHERE HDi.FTXthBchTo = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo  -- 03.01.00 --
		--AND ISNULL(DTi.FTXtdDocNoRef,'') = ''
		AND HDi.FNXthDocType = 5  -- 2. --

		UPDATE TCNTPdtTboHD WITH(ROWLOCK)
		SET FTXthRefInt = @ptDocNo
		FROM TCNTPdtTboHD HDo
		INNER JOIN TCNTPdtTbiHD HDi WITH(NOLOCK) ON HDo.FTXthDocNo = HDi.FTXthRefInt
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo

	END 
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxBchPdtTnfOut')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxBchPdtTnfOut
GO
CREATE PROCEDURE [dbo].STP_DOCxBchPdtTnfOut
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5),  -- 2. --
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
03.01.00	25/03/2020		Em		create  
03.02.00	27/03/2020		Em		แก้ไขขนาดฟิลด์สาขาจาก 3 เป็น 5
03.03.00	13/04/2020		Em		แก้ไขปรับปรุง
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	01/07/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	05/07/2021		Em		เพิ่มรายการ IntDTFhn
----------------------------------------------------------------------*/
SET @tTrans = 'PrcBchOut'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTboHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)

	IF @tStaPrc <> '1'	-- 6. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo

		DELETE TFHTPdtStkCrd WITH(ROWLOCK)	-- 06.02.00 --
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo -- 06.02.00 --
		-- 05.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTXthBchFrm = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkFrm = '2'
		BEGIN
			--Create stk balance
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)	
			SELECT DISTINCT HD.FTXthBchFrm,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,	-- 03.03.00 --
			GETDATE() AS FDLastUpd,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTboHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTboDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchFrm = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode	-- 03.03.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''

			--Update balance Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Two.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Two.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll	-- 03.03.00 --
			FROM TCNTPdtTboHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTboDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Two  ON Two.FTXthBchFrm = STK.FTBchCode AND Two.FTXthWhFrm = STK.FTWahCode AND Two.FTPdtCode = STK.FTPdtCode	-- 03.03.00 --

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 03.03.00 --
			,'2' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
			FROM TCNTPdtTboDT DT with(nolock)
			INNER JOIN TCNTPdtTboHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 03.03.00 --

			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTboDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'2' AS FTStkType	-- 03.02.00 --
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
				FROM TCNTPdtTboDT DT with(nolock)
				INNER JOIN TCNTPdtTboHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTboDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty*(-1) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END

				-- 06.02.00 --
				--Delete old data
				DELETE FROM TCNTPdtIntDTFhnBch WHERE  FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo

				--Insert new data
				INSERT INTO TCNTPdtIntDTFhnBch(FTBchCode, FTXthDocNo, FNXtdSeqNo, FTXthBchTo, FTXthWahTo, 
					FTPdtCode, FTFhnRefCode, FCXtdQty, FCXtdQtyRcv, FCXtdQtyAll)
				SELECT HD.FTBchCode, HD.FTXthDocNo, DTF.FNXtdSeqNo, HD.FTXthBchTo, FTXthWhTo, 
					DTF.FTPdtCode, DTF.FTFhnRefCode, DTF.FCXtdQty, 0 AS FCXtdQtyRcv, (DTF.FCXtdQty * DT.FCXtdFactor) AS FCXtdQtyAll
				FROM TCNTPdtTboDT DT WITH(NOLOCK)
				INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo 
				INNER JOIN TCNTPdtTboDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
				-- 06.02.00 --
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		--Delete old data
		DELETE FROM TCNTPdtIntDTBch WHERE  FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo

		--Insert new data
		INSERT INTO TCNTPdtIntDTBch(FTBchCode, FTXthDocNo, FNXtdSeqNo, FNXthDocType, FTXthBchTo, FTXthWahTo, 
			FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, FCXtdQtyRcv, FCXtdQtyAll,		
			FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
		SELECT HD.FTBchCode, HD.FTXthDocNo, FNXtdSeqNo, '2', HD.FTXthBchTo, FTXthWhTo, 
			FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, 0 AS FCXtdQtyRcv, FCXtdQtyAll,		
			GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM TCNTPdtTboDT DT WITH(NOLOCK)
		INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo 
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		
	END	 
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH

GO




IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxBchPdtTnfOut')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxBchPdtTnfOut
GO
CREATE PROCEDURE [dbo].STP_DOCxBchPdtTnfOut
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5),  -- 2. --
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
03.01.00	25/03/2020		Em		create  
03.02.00	27/03/2020		Em		แก้ไขขนาดฟิลด์สาขาจาก 3 เป็น 5
03.03.00	13/04/2020		Em		แก้ไขปรับปรุง
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	01/07/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	05/07/2021		Em		เพิ่มรายการ IntDTFhn
06.03.00	05/07/2021		Em		แก้ไขลงรหัสสาขาใน StkCrd ไม่ถูกต้อง
----------------------------------------------------------------------*/
SET @tTrans = 'PrcBchOut'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTboHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)

	IF @tStaPrc <> '1'	-- 6. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo

		DELETE TFHTPdtStkCrd WITH(ROWLOCK)	-- 06.02.00 --
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo -- 06.02.00 --
		-- 05.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTXthBchFrm = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkFrm = '2'
		BEGIN
			--Create stk balance
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)	
			SELECT DISTINCT HD.FTXthBchFrm,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,	-- 03.03.00 --
			GETDATE() AS FDLastUpd,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTboHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTboDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchFrm = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode	-- 03.03.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''

			--Update balance Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Two.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Two.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll	-- 03.03.00 --
			FROM TCNTPdtTboHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTboDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Two  ON Two.FTXthBchFrm = STK.FTBchCode AND Two.FTXthWhFrm = STK.FTWahCode AND Two.FTPdtCode = STK.FTPdtCode	-- 03.03.00 --

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 03.03.00 --
			,'2' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
			FROM TCNTPdtTboDT DT with(nolock)
			INNER JOIN TCNTPdtTboHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 03.03.00 --

			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTboDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				--SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 06.03.00 --
				,'2' AS FTStkType	-- 03.02.00 --
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdSetPrice)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
				FROM TCNTPdtTboDT DT with(nolock)
				INNER JOIN TCNTPdtTboHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTboDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				--GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate
				GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate	-- 06.03.00 --

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty*(-1) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END

				-- 06.02.00 --
				--Delete old data
				DELETE FROM TCNTPdtIntDTFhnBch WHERE  FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo

				--Insert new data
				INSERT INTO TCNTPdtIntDTFhnBch(FTBchCode, FTXthDocNo, FNXtdSeqNo, FTXthBchTo, FTXthWahTo, 
					FTPdtCode, FTFhnRefCode, FCXtdQty, FCXtdQtyRcv, FCXtdQtyAll)
				SELECT HD.FTBchCode, HD.FTXthDocNo, DTF.FNXtdSeqNo, HD.FTXthBchTo, FTXthWhTo, 
					DTF.FTPdtCode, DTF.FTFhnRefCode, DTF.FCXtdQty, 0 AS FCXtdQtyRcv, (DTF.FCXtdQty * DT.FCXtdFactor) AS FCXtdQtyAll
				FROM TCNTPdtTboDT DT WITH(NOLOCK)
				INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo 
				INNER JOIN TCNTPdtTboDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
				-- 06.02.00 --
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		--Delete old data
		DELETE FROM TCNTPdtIntDTBch WHERE  FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo

		--Insert new data
		INSERT INTO TCNTPdtIntDTBch(FTBchCode, FTXthDocNo, FNXtdSeqNo, FNXthDocType, FTXthBchTo, FTXthWahTo, 
			FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, FCXtdQtyRcv, FCXtdQtyAll,		
			FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
		SELECT HD.FTBchCode, HD.FTXthDocNo, FNXtdSeqNo, '2', HD.FTXthBchTo, FTXthWhTo, 
			FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, 0 AS FCXtdQtyRcv, FCXtdQtyAll,		
			GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM TCNTPdtTboDT DT WITH(NOLOCK)
		INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo 
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		
	END	 
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH

GO


/****** Object:  StoredProcedure [dbo].[SP_RPTxCstSalMTD]    Script Date: 14/7/2564 13:01:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxCstSalMTD]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxCstSalMTD
GO
CREATE PROCEDURE [dbo].[SP_RPTxCstSalMTD]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--ตัวแทนขาย
	@ptAgnL Varchar(8000), --ตัวแทนขาย Condition IN

	--ลูกค้า
	@ptCstCodeF Varchar(30),
	@ptCstCodeT Varchar(30),

	--กลุ่มลูกค้า
	@ptCgpCode Varchar(30),


	--รประเภทูกค้า
	@ptCtyCodeF Varchar(30),
	@ptCtyCodeT Varchar(30),

	--ระดับลูกค้า
	@ptClvCodeF Varchar(30),
	@ptClvCodeT Varchar(30),

	@FNResult INT OUTPUT 
AS
--------------------------------------

BEGIN TRY
	DECLARE @nLngID int
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSql1 VARCHAR(8000)
	DECLARE @tSqlSal VARCHAR(8000)
	DECLARE @tSqlRed VARCHAR(8000)

  --AgnCode
	DECLARE @tAgnL Varchar(8000)
	--Cst Code
	DECLARE @tCstCodeF Varchar(30)
	DECLARE @tCstCodeT Varchar(30)
	--Cst Code
	DECLARE @tCgpCode Varchar(30)

	--Cst Code
	DECLARE @tCtyCodeF Varchar(30)
	DECLARE @tCtyCodeT Varchar(30)
	--Cst Code
	DECLARE @tClvCodeF Varchar(30)
	DECLARE @tClvCodeT Varchar(30)

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Agency
	SET @tAgnL  = @ptAgnL

	--Cst
	SET @tCstCodeF  = @ptCstCodeF
	SET @tCstCodeT  = @ptCstCodeT

	SET @tCgpCode = @ptCgpCode

	SET @tClvCodeF = @ptClvCodeF
	SET @tClvCodeT = @ptClvCodeT

	SET @tCtyCodeF = @ptCtyCodeF
	SET @tCtyCodeT = @ptCtyCodeT

	SET @FNResult= 0


	IF @nLngID = null
	BEGIN
		SET @nLngID = 1
	END	



	SET @tSql1 =   ' WHERE 1=1'


	IF @pnFilterType = '1'
	BEGIN
		IF (@tAgnL <> '' AND @tAgnL <> '')
		BEGIN
			SET @tSql1 +=' AND CST.FTAgnCode BETWEEN ''' + @tAgnL + ''' AND ''' + @tAgnL + ''''
		END
	END

	IF @pnFilterType = '2'
	BEGIN

		IF (@tCgpCode <> '' ) BEGIN
			SET	@tSql1 +=' AND CST.FTCgpCode= '''+ @tCgpCode + '''  '
	  END
		ELSE  BEGIN
			IF (@tAgnL <> '' ) BEGIN
				SET @tSql1 +=' AND CST.FTAgnCode =''' + @tAgnL + ''' ';
			END
		END
		--IF (@tAgnL <> '' )
		--BEGIN
			--SET @tSql1 +=' AND ( CST.FTAgnCode =''' + @tAgnL + ''' '
					--IF (@tCgpCode <> '' ) BEGIN
						--SET @tSql1 +=' OR CST.FTCgpCode= '''+ @tCgpCode + ''' '
					--END
			--SET @tSql1 +=' )'

		--END

	END




	IF (@tCstCodeF <> '' AND @tCstCodeT <> '')
	BEGIN
		SET @tSql1 += ' AND CST.FTCstCode BETWEEN ''' + @tCstCodeF + ''' AND ''' + @tCstCodeT + ''''
   
	END


	IF (@tClvCodeF <> '' AND @tClvCodeT <> '')
	BEGIN
		SET @tSql1 += ' AND CST.FTClvCode BETWEEN ''' + @tClvCodeF + ''' AND ''' + @tClvCodeT + ''''
	END

	IF (@tCtyCodeF <> '' AND @tCtyCodeT <> '')
	BEGIN
		SET @tSql1 += ' AND CST.FTCtyCode BETWEEN ''' + @tCtyCodeF + ''' AND ''' + @tCtyCodeT + ''''
	END

	DELETE FROM TRPTCstSalMTDTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''

	SET @tSql = ' INSERT INTO TRPTCstSalMTDTmp'
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FTCgpCode,FTCstCode,FTCstName,FTCstCrdNo,FCTxnBuyTotal,FCXshGrand,FDXshLastDate,FTBchCode,FTBchName,FTCstTel,FDCstDob,FTChnCount,FTCstSex,FCCstCrLimit,FTClvName,FCTxnPntBillQty,FCTxnPntQtyBal,FTCstEmail,FDCstApply,FTCtyName,FTPplName,FCXshSumGrand,FTCstAddress '
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' CST.FTCgpCode,CST.FTCstCode,CSTL.FTCstName,CSTCRD.FTCstCrdNo,ISNULL(AMTATV.FCTxnBuyTotal, 0) AS FCTxnBuyTotal,ISNULL(LSTBIL.FCXshGrand, 0) AS FCXshGrand,'
  SET @tSql +=' LSTBIL.FDXshDocDate AS FDXshLastDate,BCHL.FTBchCode,BCHL.FTBchName,CST.FTCstTel,CONVERT(VARCHAR(10),CST.FDCstDob,121) AS FDCstDob,	(SELECT count(*) as FTChnCount FROM(SELECT HD.FTCstCode,HD.FTChnCode FROM TPSTSalHD HD WHERE HD.FTCstCode = CST.FTCstCode GROUP BY HD.FTCstCode,HD.FTChnCode) CHN) AS FTChnCount,CST.FTCstSex,'
	SET @tSql +=' ISNULL(CREDIT.FCCstCrLimit, 0) AS FCCstCrLimit,CLV.FTClvName AS FTClvName,0 AS FCTxnPntBillQty,ISNULL(PNTATV.FCTxnPntQty, 0) AS FCTxnPntQtyBal,'
	SET @tSql +=' CST.FTCstEmail,CONVERT (VARCHAR (10),CSTCRD.FDCstApply,121) AS FDCstApply,CSTTYPE.FTCtyName,PPL.FTPplName AS FTPplName,0 AS FCXshSumGrand,CstAdd.FTCstAddress'
	SET @tSql +=' FROM TCNMCst CST WITH (NOLOCK)'
	SET @tSql +=' LEFT JOIN TCNMCst_L CSTL WITH (NOLOCK) ON CST.FTCstCode = CSTL.FTCstCode '
	SET @tSql +=' LEFT JOIN TCNMCstCard CSTCRD WITH (NOLOCK) ON CST.FTCstCode = CSTCRD.FTCstCode '
	SET @tSql +=' LEFT JOIN TCNMCstType_L CSTTYPE WITH (NOLOCK) ON CST.FTCtyCode = CSTTYPE.FTCtyCode AND CSTTYPE.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql +=' LEFT JOIN TCNMPdtPriList_L PPL WITH (NOLOCK) ON CST.FTPplCodeRet = PPL.FTPplCode AND PPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql +=' LEFT JOIN TCNMCstCredit CREDIT WITH (NOLOCK) ON CST.FTCstCode = CREDIT.FTCstCode'
	SET @tSql +=' LEFT JOIN TCNTMemAmtActive AMTATV WITH (NOLOCK) ON CST.FTCgpCode = AMTATV.FTCgpCode AND CST.FTCstCode = AMTATV.FTMemCode'
	SET @tSql +=' LEFT JOIN TCNTMemPntActive PNTATV WITH (NOLOCK) ON CST.FTCgpCode = PNTATV.FTCgpCode AND CST.FTCstCode = PNTATV.FTMemCode'
	SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (PARTITION BY Sal.FTCstCode ORDER BY Sal.FTCstCode, Sal.FDXshDocDate DESC) AS FNRowID,'
	SET @tSql +=' Sal.FTCstCode,Sal.FTBchCode,Sal.FDXshDocDate,FCXshGrand FROM'
	SET @tSql +=' (	SELECT HD.FDXshDocDate,HD.FTCstCode,HD.FTBchCode,'
	SET @tSql +=' SUM (CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(HD.FCXshGrand, 0) ELSE ISNULL(HD.FCXshGrand, 0) *- 1 END ) AS FCXshGrand'
	SET @tSql +=' FROM TPSTSalHD HD WITH (NOLOCK) GROUP BY HD.FTCstCode,HD.FTBchCode,HD.FDXshDocDate ) Sal'
	SET @tSql +=' ) LSTBIL ON CST.FTCstCode = LSTBIL.FTCstCode AND LSTBIL.FNRowID = 1'
	SET @tSql +='  LEFT JOIN TCNMBranch_L BCHL WITH (NOLOCK) ON LSTBIL.FTBchCode = BCHL.FTBchCode AND BCHL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN TCNMCstLev_L CLV WITH (NOLOCK) ON CST.FTClvCode = CLV.FTClvCode AND CLV.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (PARTITION BY ADL.FTCstCode ORDER BY ADL.FTCstCode, ADL.FNAddSeqNo ASC) AS FNRowID , ADL.FTCstCode,ADL.FNLngID, CASE WHEN ADL.FTAddVersion = ''1'' THEN CONCAT ( ADL.FTAddV1No+'' '' , ADL.FTAddV1Soi+'' '', ADL.FTAddV1Village+'' '', ADL.FTAddV1Road+'' '', SDTCL.FTSudName+'' '' , DTCL.FTDstName+'' '', ProL.FTPvnName+'' '' ,ADL.FTAddV1PostCode ) ELSE CONCAT ( ADL.FTAddV2Desc1+'' '', ADL.FTAddV2Desc2) END  AS FTCstAddress FROM TCNMCstAddress_L ADL  WITH (NOLOCK)'
 	SET @tSql +=' LEFT JOIN  TCNMSubDistrict_L SDTCL WITH (NOLOCK) ON ADL.FTAddV1SubDist = SDTCL.FTSudCode AND SDTCL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN  TCNMDistrict_L DTCL WITH (NOLOCK) ON ADL.FTAddV1DstCode = DTCL.FTDstCode AND DTCL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN TCNMProvince_L ProL WITH (NoLock) ON ADL.FTAddV1PvnCode = ProL.FTPvnCode AND ProL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' WHERE  ADL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ) CstAdd ON CST.FTCstCode = CstAdd.FTCstCode AND CstAdd.FNRowID = 1'
 SET @tSql += @tSql1
  PRINT @tSql
	
	EXECUTE(@tSql)
END TRY

BEGIN CATCH 
SELECT ERROR_MESSAGE () AS ErrorMessage
	--SET @FNResult= -1

END CATCH			



GO
/****** Object:  StoredProcedure [dbo].[SP_RPTxSpcSalByDT]    Script Date: 14/7/2564 13:01:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxSpcSalByDT]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxSpcSalByDT
GO
CREATE PROCEDURE [dbo].[SP_RPTxSpcSalByDT] 
--ALTER PROCEDURE [dbo].[SP_RPTxDailySaleByPdt1001002] 
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--สาขา
	@ptBchL Varchar(8000), --กรณี Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptPdtCodeF Varchar(20),
	@ptPdtCodeT Varchar(20),
	@ptPdtPbnF Varchar(30),
	@ptPdtPbnT Varchar(30),
	@ptPdtTypeF Varchar(5),
	@ptPdtTypeT Varchar(5),

	@ptCstCodeF Varchar(50),
	@ptCstCodeT Varchar(50),

--รหัสฤดูกาล
	@ptSeaF Varchar(20),@ptSeaT Varchar(20),

--รหัสเนื้อผ้า
	@ptFabF Varchar(20),@ptFabT Varchar(20),

--รหัสสี
	@ptClrF Varchar(20),@ptClrT Varchar(20),

--รหัสไซต์
	@ptPszF Varchar(20),@ptPszT Varchar(20),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 10/07/2019
-- Temp name  TRPTSalRCTmp
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
-- @ptShpF จากร้านค้า
-- @ptShpT ถึงร้านค้า
-- @ptPdtCodeF จากสินค้า
-- @ptPdtCodeT ถึงสินค้า
-- @ptPdtChanF จากกลุ่มสินค้า
-- @ptPdtChanT ถึงกลุ่มสินค้า
-- @ptPdtTypeF จากประเภทสินค้า
-- @ptPdtTypeT ถึงประเภท

-- @ptDocDateF จากวันที่
-- @ptDocDateT ถึงวันที่
-- @FNResult


--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSql2 VARCHAR(8000)
	DECLARE @tSql3 VARCHAR(8000)
	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tPdtCodeF Varchar(20)
	DECLARE @tPdtCodeT Varchar(20)
	DECLARE @tPdtPbnF Varchar(30)
	DECLARE @tPdtPbnT Varchar(30)
	DECLARE @tPdtTypeF Varchar(5)
	DECLARE @tPdtTypeT Varchar(5)

	DECLARE @tCstCodeF Varchar(50)
	DECLARE @tCstCodeT Varchar(50)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า
	--DECLARE @tCstF Varchar(20)
	--DECLARE @tCstT Varchar(20)


	
	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT

	--Pos
	SET @tPosF  = @ptPosF 
	SET @tPosT  = @ptPosT

	SET @tPdtCodeF  = @ptPdtCodeF 
	SET @tPdtCodeT = @ptPdtCodeT
	SET @tPdtPbnF  = @ptPdtPbnF
	SET @tPdtPbnT  = @ptPdtPbnT 
	SET @tPdtTypeF = @ptPdtTypeF
	SET @tPdtTypeT = @ptPdtTypeT

	SET @tCstCodeF = @ptCstCodeF
	SET @tCstCodeT = @ptCstCodeT

	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult= 0

	SET @tDocDateF = CONVERT(VARCHAR(10),@tDocDateF,121)
	SET @tDocDateT = CONVERT(VARCHAR(10),@tDocDateT,121)

	IF @nLngID = null
	BEGIN
		SET @nLngID = 1
	END	
	--Set ค่าให้ Paraleter กรณี T เป็นค่าว่างหรือ null


	IF @ptBchL = null
	BEGIN
		SET @ptBchL = ''
	END

	IF @tBchF = null
	BEGIN
		SET @tBchF = ''
	END
	IF @tBchT = null OR @tBchT = ''
	BEGIN
		SET @tBchT = @tBchF
	END


	IF @ptPosL =null
	BEGIN
		SET @ptPosL = ''
	END

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END

	IF @tPdtCodeF = null
	BEGIN
		SET @tPdtCodeF = ''
	END 
	IF @tPdtCodeT = null OR @tPdtCodeT =''
	BEGIN
		SET @tPdtCodeT = @tPdtCodeF
	END 


	IF @tPdtTypeF = null
	BEGIN
		SET @tPdtTypeF = ''
	END 
	IF @tPdtTypeT = null OR @tPdtTypeT =''
	BEGIN
		SET @tPdtTypeT = @tPdtTypeF
	END 

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	SET @tSql1 =   ' WHERE 1=1 AND EXISTS (SELECT FTBchCode,FTXshDocNo FROM TPSTSalRC WHERE DT.FTBchCode = FTBchCode AND DT.FTXshDocNo = FTXshDocNo) AND FTXshStaDoc = ''1'' AND DT.FTXsdStaPdt <> ''4'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND DT.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSql1 +=' AND DT.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
		END		
	END

	IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	END

	IF (@tPdtPbnF <> '' AND @tPdtPbnT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPbnCode BETWEEN ''' + @tPdtPbnF + ''' AND ''' + @tPdtPbnT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tCstCodeF <> '' AND @tCstCodeT <> '')
	BEGIN
		SET @tSql1 +=' AND HD.FTCstCode BETWEEN ''' + @tCstCodeF + ''' AND ''' + @tCstCodeT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END


	SET @tSql3 = ''

	IF (@ptSeaF<> '')
	BEGIN
		SET @tSql3 +=' AND Clr.FTSeaCode BETWEEN ''' + @ptSeaF + ''' AND ''' + @ptSeaT + ''''
	END

	IF (@ptFabF<> '')
	BEGIN
		SET @tSql3 +=' AND Clr.FTFabCode BETWEEN ''' + @ptFabF + ''' AND ''' + @ptFabT + ''''
	END

	IF (@ptClrF<> '')
	BEGIN
		SET @tSql3 +=' AND Clr.FTClrCode BETWEEN ''' + @ptClrF + ''' AND ''' + @ptClrT + ''''
	END

	IF (@ptPszF<> '')
	BEGIN
		SET @tSql3 +=' AND Clr.FTPszCode BETWEEN ''' + @ptPszF + ''' AND ''' + @ptPszT + ''''
	END


	DELETE FROM TRPTSpcSalByDTTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  = ' INSERT INTO TRPTSpcSalByDTTmp '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FTPbnName,FDXshDocDate,FTXshDocNo,FTCstName,FTCstTel,FTBchCode,FTBchName,FTUsrName,FCXsdQty,FTPdtCode,FTXsdPdtName,FTPunName,FTFhnRefCode,FTClrName,FTPszName,FTFhnGender,FTSeaName,FTChnName,FNXshAge,FTXshNation,FTDepName,FTCmlName,FTClsName,FCXsdSetPrice,FCXsdGrossSales,FCXsdGrossSalesExVat,FCXsdNetSales,FCXsdNetSalesEx,FTXddDisChgTxt,FCXsdAmtB4DisChg,FCXsdDis,FCXsdVat,FCXsdNet,FCXsdNetAfHD,FTCstCode,FNXshSex,FTXshRmk'
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' PBN_L.FTPbnName,HD.FDXshDocDate,DT.FTXshDocNo,CST_L.FTCstName,CST.FTCstTel,HD.FTBchCode,Bch_L.FTBchName,SALM.FTUsrName,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(DTFhn.FCXsdQty, 0) ELSE ISNULL(DTFhn.FCXsdQty, 0) *- 1 END FCXsdQty,'
	SET @tSql +=' DT.FTPdtCode,DT.FTXsdPdtName,ISNULL(Pun_L.FTPunName, '''') AS FTPunName,'
  SET @tSql +=' DTFhn.FTFhnRefCode,DTFhn.FTClrName,DTFhn.FTPszName,CASE WHEN HDTAG.FNXshSex=1 THEN ''MEN'' WHEN HDTAG.FNXshSex=2 THEN ''WOMEN'' WHEN HDTAG.FNXshSex=3 THEN ''UNISEX'' ELSE '''' END AS FTFhnGender,'
	SET @tSql +=' DTFhn.FTSeaName,CHN.FTChnName,HDTAG.FNXshAge,HDTAG.FTXshNation,DEPL.FTDepName,CMLL.FTCmlName,CLSL.FTClsName,'
  SET @tSql +=' ISNULL(DT.FCXsdSetPrice, 0) AS FCXsdSetPrice,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(DT.FCXsdSetPrice, 0) * ISNULL(DTFhn.FCXsdQty, 0)  ELSE (ISNULL(DT.FCXsdSetPrice, 0) * ISNULL(DTFhn.FCXsdQty, 0))  *- 1 END AS FCXsdGrossSales,'
  SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN CASE WHEN HD.FTXshVATInOrEx = ''1'' THEN ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) - (CASE WHEN DT.FTXsdVatType = ''1'' THEN (ISNULL(((DT.FCXsdAmtB4DisChg / DT.FCXsdQty) * DTFhn.FCXsdQty),0)  * DT.FCXsdVatRate)/(100+DT.FCXsdVatRate) ELSE 0 END) ELSE ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) END ELSE (CASE WHEN HD.FTXshVATInOrEx = ''1'' THEN ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) - (CASE WHEN DT.FTXsdVatType = ''1'' THEN (ISNULL(((DT.FCXsdAmtB4DisChg / DT.FCXsdQty) * DTFhn.FCXsdQty),0)  * DT.FCXsdVatRate)/(100+DT.FCXsdVatRate) ELSE 0 END) ELSE ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) END) * - 1 END AS FCXsdGrossSalesExVat,'
  SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 END FCXsdNetSales,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) - ISNULL(((DT.FCXsdVat/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE (ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) - ISNULL(((DT.FCXsdVat/DT.FCXsdQty)*DTFhn.FCXsdQty), 0)) *- 1 END FCXsdNetSalesEx,'
	SET @tSql +=' ISNULL(DTDis.FTXddDisChgTxt,'''') AS FTXddDisChgTxt,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE (ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0)) *- 1 END AS FCXsdAmtB4DisChg,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DTDis.FCXddValue/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 ELSE (ISNULL(((DTDis.FCXddValue/DT.FCXsdQty)*DTFhn.FCXsdQty), 0)) END FCXsdDis,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdVat/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE ISNULL(((DT.FCXsdVat/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 END FCXsdVat,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdNet/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE ISNULL(((DT.FCXsdNet/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 END FCXsdNet,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 END FCXsdNetAfHD,'
  SET @tSql +=' HD.FTCstCode,CASE WHEN HDTAG.FNXshSex = ''1'' THEN ''MEN'' WHEN HDTAG.FNXshSex = ''2'' THEN ''WOMEN'' ELSE  ''-'' END FNXshSex,HD.FTXshRmk '
	SET @tSql +=' FROM TPSTSalDT DT WITH (NOLOCK)'
	SET @tSql +=' LEFT JOIN TFHMPdtFhn PDTFHN WITH (NOLOCK) ON DT.FTPdtCode = PDTFHN.FTPdtCode'
	SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L DEPL WITH (NOLOCK) ON PDTFHN.FTDepCode = DEPL.FTDepCode AND DEPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN TFHMPdtF5ComLines_L CMLL WITH (NOLOCK) ON PDTFHN.FTCmlCode = CMLL.FTCmlCode AND CMLL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L CLSL WITH (NOLOCK) ON PDTFHN.FTClsCode = CLSL.FTClsCode AND CLSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN TPSTSalHDTag HDTAG WITH (NOLOCK) ON DT.FTBchCode = HDTAG.FTBchCode AND DT.FTXshDocNo = HDTAG.FTXshDocNo '
	SET @tSql +=' LEFT JOIN TPSTSalDTFhn DTFhn WITH (NOLOCK) ON DT.FTBchCode = DTFhn.FTBchCode AND DT.FTXshDocNo = DTFhn.FTXshDocNo AND DT.FNXsdSeqNo = DTFhn.FNXsdSeqNo  AND DTFhn.FNXsfSeqNo = 1 '
	
  SET @tSql2 ='  LEFT JOIN (SELECT DISTINCT ClrHfn.FTPdtCode,ClrHfn.FTFhnRefCode,ClrHfn.FTClrCode ,ClrHfn.FDFhnStart,ClrHfn.FTFabCode, ClrHfn.FTSeaCode,ClrHfn.FTPszCode,ClrHfn.FCFhnCostStd ,ClrHfn.FCFhnCostOth FROM'
  SET @tSql2 +='(SELECT DISTINCT Clr.FTPdtCode,Clr.FTFhnRefCode,MAX(Clr.FNFhnSeq) AS FNFhnSeq FROM TFHMPdtColorSize Clr WHERE 1=1 '
  SET @tSql2 += @tSql3
  SET @tSql2 +=' GROUP BY Clr.FTPdtCode,Clr.FTFhnRefCode ) ClrMas'
  SET @tSql2 +=' INNER JOIN TFHMPdtColorSize ClrHfn WITH (NOLOCK) ON ClrMas.FTPdtCode = ClrHfn.FTPdtCode AND ClrMas.FTFhnRefCode = ClrHfn.FTFhnRefCode AND ClrMas.FNFhnSeq = ClrHfn.FNFhnSeq) Clr  ON DTFhn.FTPdtCode =  Clr.FTPdtCode AND DTFhn.FTFhnRefCode = Clr.FTFhnRefCode'

  SET @tSql2 +=' INNER JOIN TPSTSalHD HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo' 
  SET @tSql2 +=' LEFT JOIN TCNMChannel_L CHN WITH (NOLOCK) ON HD.FTChnCode = CHN.FTChnCode AND CHN.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''	'
  SET @tSql2 +=' LEFT JOIN (SELECT A.FTBchCode,A.FTXshDocNo,A.FNXsdSeqNo, STUFF((SELECT '', '' + B.FTXddDisChgTxt FROM TPSTSalDTDis B WHERE ISNULL(B.FTBchCode, '''') = ISNULL(A.FTBchCode, '''') AND  ISNULL(B.FTXshDocNo, '''') = ISNULL(A.FTXshDocNo, '''') AND  ISNULL(B.FNXsdSeqNo, '''') = ISNULL(A.FNXsdSeqNo, '''') ORDER BY B.FTBchCode ,B.FTXshDocNo,B.FNXsdSeqNo FOR XML PATH('''')), 1, 2, '''' ) AS FTXddDisChgTxt, SUM (CASE WHEN FTXddDisChgType = 3 OR FTXddDisChgType = 4 THEN ISNULL(A.FCXddValue, 0) ELSE ISNULL(A.FCXddValue, 0) *- 1 END) AS FCXddValue FROM TPSTSalDTDis A WITH (NOLOCK) GROUP BY A.FTBchCode,A.FTXshDocNo,A.FNXsdSeqNo ) AS DTDis ON DT.FTBchCode = DTDis.FTBchCode AND DT.FTXshDocNo = DTDis.FTXshDocNo AND DT.FNXsdSeqNo = DTDis.FNXsdSeqNo'
	SET @tSql2 +=' LEFT JOIN TCNMPdt Pdt WITH (NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode'
	SET @tSql2 +=' LEFT JOIN TCNMPdt_L Pdt_L WITH (NOLOCK) ON DT.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMPdtUnit_L Pun_L WITH (NOLOCK) ON DT.FTPunCode = Pun_L.FTPunCode AND Pun_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMBranch_L Bch_L WITH (NOLOCK) ON HD.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMCst CST WITH (NOLOCK) ON HD.FTCstCode = CST.FTCstCode'
	SET @tSql2 +=' LEFT JOIN TCNMCst_L CST_L WITH (NOLOCK) ON CST.FTCstCode = CST_L.FTCstCode AND CST_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMPdtBrand_L PBN_L WITH (NOLOCK) ON Pdt.FTPbnCode = PBN_L.FTPbnCode AND PBN_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMUser_L SALM WITH (NOLOCK) ON HD.FTUsrCode = SALM.FTUsrCode AND SALM.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 += @tSql1	
	SET @tSql2 += @tSql3		

  --SELECT @tSql+@tSql2
	EXECUTE(@tSql+@tSql2)

	RETURN SELECT * FROM TRPTSpcSalByDTTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	

GO





/****** Object:  StoredProcedure [dbo].[SP_RPTxSpcSalByDT]    Script Date: 14/7/2564 13:01:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxSpcStockBalFhn]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxSpcStockBalFhn
GO

CREATE PROCEDURE [dbo].[SP_RPTxSpcStockBalFhn] 
    @pnLngID int , 
	@ptComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),

	@pnFilterType int, --1 BETWEEN 2 IN
	--สาขา
	@ptBchL Varchar(8000), --กรณี Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--@ptBchF VARCHAR(100),
	--@ptBchT VARCHAR(100),
	@ptWahCodeF VARCHAR(100),
	@ptWahCodeT VARCHAR(100),

	@FTResult VARCHAR(8000) OUTPUT

AS
BEGIN TRY

      DECLARE @tSQL VARCHAR(8000)
	  DECLARE @tSQL_Filter VARCHAR(8000)

	  DECLARE @nLngID int
	  DECLARE @tComName VARCHAR(100)
	  DECLARE @tRptCode VARCHAR(100)
	  DECLARE @tUsrSession VARCHAR(255)

	  --Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	  --DECLARE @tBchF VARCHAR(100)
	  --DECLARE @tBchT VARCHAR(100)
	  DECLARE @tWahCodeF VARCHAR(100)
	  DECLARE @tWahCodeT VARCHAR(100)

	  SET @tComName = @ptComName
	  SET @tRptCode = @ptRptCode
	  SET @tUsrSession = @ptUsrSession
	  SET @nLngID = @pnLngID

	  --Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT

	  --SET @tBchF = @ptBchF
	  --SET @tBchT = @ptBchT
	  SET @tWahCodeF = @ptWahCodeF
	  SET @tWahCodeT = @ptWahCodeT

	  SET @tSQL_Filter = ' WHERE 1 = 1 AND PDT1.FTPdtStaActive = 1  '

	  IF(@nLngID = '' OR @nLngID = NULL)
	     BEGIN
		      SET @nLngID = 1
		 END
	   ELSE IF(@nLngID <> '')
	     BEGIN
		     SET @nLngID = @pnLngID
		 END

	  IF @ptBchL = null
	BEGIN
		SET @ptBchL = ''
	END

	IF @tBchF = null
	BEGIN
		SET @tBchF = ''
	END
	IF @tBchT = null OR @tBchT = ''
	BEGIN
		SET @tBchT = @tBchF
	END

	  --IF(@tBchF = '' OR @tBchF = NULL)
			-- BEGIN
			--	  SET @tBchF = ''
			-- END
	  -- ELSE IF(@tBchF <> '')
			-- BEGIN
			--	 SET @tBchF = @tBchF
			-- END

	  -- IF(@tBchT = '' OR @tBchT = NULL)
			-- BEGIN
			--	  SET @tBchT = ''
			-- END
	  -- ELSE IF(@tBchT <> '')
			-- BEGIN
			--	 SET @tBchT = @tBchT
			-- END
	   
	  -- IF(@tBchF <> '' AND @tBchT <> '')
			-- BEGIN 
			--	  SET @tSQL_Filter += ' AND STK.FTBchCode BETWEEN ''' + @tBchF +''' AND ''' + @tBchT + ''' ' 
			-- END
	  -- ELSE IF(@tBchF = '' AND @tBchT = '')
	  --       BEGIN 
			--      SET @tSQL_Filter += ''
			-- END

		IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSQL_Filter +=' AND STK.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END	
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSQL_Filter +=' AND STK.FTBchCode IN (' + @ptBchL + ')'
		END	
	END

	   --คลังสินค้า
	   IF(@tWahCodeF = '' OR @tWahCodeF = NULL)
			 BEGIN
				  SET @tWahCodeF = ''
			 END
	   ELSE IF(@tWahCodeF <> '')
			 BEGIN
				 SET @tWahCodeF = @tWahCodeF
			 END

		 --ถึงคลัง
	   IF(@tWahCodeT = '' OR @tWahCodeT = NULL)
			 BEGIN
				  SET @tWahCodeT = ''
			 END
	   ELSE IF(@tWahCodeT <> '')
			 BEGIN
				 SET @tWahCodeT = @tWahCodeT
			 END

	   IF(@tWahCodeF <> '' AND @tWahCodeT <> '')
			  BEGIN 
				  SET @tSQL_Filter += ' AND STK.FTWahCode BETWEEN '''+@tWahCodeF+''' AND '''+@tWahCodeT+''' ' 
			  END
	   ELSE IF(@tWahCodeF = '' AND @tWahCodeT = '')
	         BEGIN 
			      SET @tSQL_Filter += ''
			 END
	 
	   
	   --DELETE FROM TRPTPdtStkBalFhnTmp WITH (ROWLOCK) WHERE FTComName =  '' + @tComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''	  
	   DELETE FROM TRPTPdtStkBalFhnTmp  WHERE FTComName =  '' + @tComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''

	  SET @tSQL  = ' INSERT INTO TRPTPdtStkBalFhnTmp (FTComName,FTRptCode,FTUsrSession,FTWahCode,FTWahName,FTPdtCode,FTPdtName,FCStkQty,'	  
	  SET @tSQL += ' FTPgpChainName,FCPdtCostAVGEX,FCPdtCostTotal,FTBchCode,FTBchName,FTFhnRefCode,FTDepName,FTClsName,FTSeaName,FTPmoName)'
	  SET @tSQL += ' SELECT '''+ @tComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	  SET @tSQL +=  ' WAH.FTWAHCODE,WAH.FTWahName,PDT.FTPdtCode,PDT.FTPdtName,STK.FCStfBal,Grp_L.FTPgpChainName,ISNULL(AvgCost.FCPdtCostAVGEX,0) AS FCPdtCostAVGEX,ISNULL(AvgCost.FCPdtCostAVGEX,0)* ISNULL(STK.FCStfBal,0) AS FCPdtCostTotal ,
					 BCHL.FTBchCode,BCHL.FTBchName,STK.FTFhnRefCode,PDTDPL.FTDepName,PDTClSL.FTClsName,PdtSea_L.FTSeaName,PMOL.FTPmoName
					 FROM TFHTPDTSTKBAL STK WITH (NOLOCK)
					 LEFT JOIN VCN_ProductCost AvgCost WITH (NOLOCK) ON STK.FTPdtCode = AvgCost.FTPdtCode  
					 LEFT JOIN TCNMPdt PDT1 WITH (NOLOCK) ON  STK.FTPdtCode = PDT1.FTPdtCode
					 LEFT JOIN TCNMPDT_L PDT WITH (NOLOCK) ON  STK.FTPDTCODE = PDT.FTPDTCODE AND PDT.FNLNGID = ''' + CAST(@nLngID  AS VARCHAR(10)) + '''
					 LEFT JOIN TCNMWAHOUSE_L  WAH WITH (NOLOCK) ON STK.FTWAHCODE = WAH.FTWAHCODE AND STK.FTBchCode = WAH.FTBchCode AND WAH.FNLNGID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' 
					 LEFT JOIN TCNMBranch_L BCHL WITH (NOLOCK) ON STK.FTBchCode = BCHL.FTBchCode AND BCHL.FNLNGID = ''' + CAST(@nLngID  AS VARCHAR(10)) + '''
					 LEFT JOIN TCNMPdtGrp_L Grp_L WITH (NOLOCK) ON Pdt1.FTPgpChain  =  Grp_L.FTPgpChain AND WAH.FNLNGID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSql +=' LEFT JOIN TCNMPdtModel_L PMOL WITH (NOLOCK)  ON PDT1.FTPmoCode = PMOL.FTPmoCode AND PMOL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		SET @tSql +=' LEFT JOIN TFHMPdtFhn FHN WITH (NOLOCK) ON STK.FTPdtCode = FHN.FTPdtCode '  
		SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L PDTDPL WITH(NOLOCK) ON FHN.FTDepCode = PDTDPL.FTDepCode AND PDTDPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
		SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L PDTClSL WITH(NOLOCK) ON FHN.FTClsCode = PDTClSL.FTClsCode AND PDTClSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition by PCS.FTPdtCode,PCS.FTFhnRefCode ORDER BY PCS.FTPdtCode,PCS.FTFhnRefCode,PCS.FNFhnSeq DESC) AS FNRowID,PCS.FTPdtCode,PCS.FTFhnRefCode,PBAR.FTBarCode,PCS.FTSeaCode FROM  TFHMPdtColorSize PCS WITH (NOLOCK) '
		SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition BY BA.FTPdtCode,BA.FTFhnRefCode,BA.FNBarRefSeq ORDER BY BA.FNBarRefSeq DESC) AS FNRowID, BA.FTPdtCode,BA.FTBarCode,BA.FNBarRefSeq,BA.FTFhnRefCode,BA.FTPunCode FROM TCNMPdtBar BA WITH (NOLOCK) WHERE BA.FTBarStaUse = 1'
		SET @tSql +=' ) PBAR ON PCS.FTPdtCode = PBAR.FTPdtCode AND PCS.FTFhnRefCode = PBAR.FTFhnRefCode AND PCS.FNFhnSeq = PBAR.FNBarRefSeq AND PBAR.FNRowID = 1'
		SET @tSql +=' ) FhnBar ON Stk.FTPdtCode = FhnBar.FTPdtCode AND Stk.FTFhnRefCode = FhnBar.FTFhnRefCode AND  FhnBar.FNRowID=1'
		SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason PdtSea WITH(NOLOCK) ON FhnBar.FTSeaCode = PdtSea.FTSeaCode '
		SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason_L PdtSea_L WITH(NOLOCK) ON PdtSea.FTSeaCode = PdtSea_L.FTSeaCode AND PdtSea.FTSeaChain = PdtSea_L.FTSeaChain AND PdtSea_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		SET @tSQL += @tSQL_Filter		

	 --PRINT @tSQL
	  EXECUTE(@tSQL)

	 SET @FTResult = CONVERT(VARCHAR(8000),@tSQL)

	 RETURN @FTResult

END TRY
BEGIN CATCH
     return -1
	 PRINT @tSQL
END CATCH





GO

/****** Object:  StoredProcedure [dbo].[SP_RPTxSpcSalByDT]    Script Date: 14/7/2564 13:01:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxSpcStockMoventFhn]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxSpcStockMoventFhn
GO

CREATE PROCEDURE [dbo].[SP_RPTxSpcStockMoventFhn]
 @pnLngID int , 
 @pnComName Varchar(100),
 @ptRptCode Varchar(100),
 @ptUsrSession Varchar(255),
 @pnFilterType int, --1 BETWEEN 2 IN
 --สาขา
 @ptBchL Varchar(8000), --กรณี Condition IN
 @ptBchF Varchar(5),
 @ptBchT Varchar(5),
 @ptPdtF Varchar(20),
 @ptPdtT Varchar(20),
 @ptWahF Varchar(5),
 @ptWahT Varchar(5), 
 @ptMonth Varchar(2) , 
 @ptYear Varchar(4),
 @ptPdtStaActive Varchar(2), -- 1 เคลื่อนไหว , 2 ไม่เคลื่อนไหว
 
 @FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 14/08/2019
-- Temp name  TRPTVDPdtStkBalTmp
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @@ptBchF จากสาขา
-- @@ptBchT ถึงสาขา
-- @ptPdtF จากสินค้า
-- @ptPdtT ถึงสินค้า
-- @ptWahF จากคลัง
-- @ptWahT ถึงคลัง
-- @ptDocDateF จากวันที่
-- @ptDocDateT ถึงวันที่
-- @FNResult
--------------------------------------
BEGIN TRY 
 DECLARE @nLngID int 
 DECLARE @nComName Varchar(100)
 DECLARE @tRptCode Varchar(100)
 DECLARE @tUsrSession Varchar(255)
 DECLARE @tSql VARCHAR(8000)
 DECLARE @tSqlIns VARCHAR(8000)
 DECLARE @tSql1 VARCHAR(Max)
 DECLARE @tSql0 VARCHAR(8000)
 DECLARE @tBchF Varchar(5)
 DECLARE @tBchT Varchar(5)
 DECLARE @tPdtF Varchar(20)
 DECLARE @tPdtT Varchar(20)
 DECLARE @tWahF Varchar(5)
 DECLARE @tWahT Varchar(5)
 DECLARE @tMonth Varchar(2) 
 DECLARE @tYear Varchar(4)
 DECLARE @tPdtStaActive Varchar(2)
 SET @nLngID = @pnLngID
 SET @nComName = @pnComName
 SET @tUsrSession = @ptUsrSession
 SET @tRptCode = @ptRptCode
 SET @tBchF = @ptBchF
 SET @tBchT = @ptBchT
 SET @tPdtF = @ptPdtF
 SET @tPdtT = @ptPdtT
 SET @tWahF = @ptWahF
 SET @tWahT = @ptWahT
 SET @tMonth = @ptMonth
 SET @tYear = @ptYear
 SET @tPdtStaActive = @ptPdtStaActive
 SET @FNResult= 0
 IF @nLngID = null
 BEGIN
  SET @nLngID = 1
 END 
 --Set ค่าให้ Paraleter กรณี T เป็นค่าว่างหรือ null
 IF @tBchF = null
 BEGIN
  SET @tBchF = ''
 END
 IF @tBchT = null OR @tBchT = ''
 BEGIN
  SET @tBchT = @tBchF
 END
 IF @tPdtF = null
 BEGIN
  SET @tPdtF = ''
 END 
 IF @tPdtT = null OR @tPdtT =''
 BEGIN
  SET @tPdtT = @tPdtF
 END 
 IF @tWahF = null
 BEGIN
  SET @tWahF = ''
 END 
 IF @tWahT = null OR @tWahT =''
 BEGIN
  SET @tWahT = @tWahF
 END 
 IF @tMonth = null
 BEGIN 
  SET @tMonth = ''
 END
 IF @tYear = null
 BEGIN 
  SET @tYear = ''
 END
  
 SET @tSqlIns =   ' WHERE 1=1 '
 IF @pnFilterType = '1'
 BEGIN
  IF (@tBchF <> '' AND @tBchT <> '')
  BEGIN
   SET @tSqlIns +=' AND Stk.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
  END 
 END
 IF @pnFilterType = '2'
 BEGIN
  IF (@ptBchL <> '' )
  BEGIN
   SET @tSqlIns +=' AND Stk.FTBchCode IN (' + @ptBchL + ')'
  END 
 END
  
 IF (@tWahF <> '' AND @tWahT <> '')
 BEGIN
  SET @tSqlIns +=' AND Stk.FTWahCode BETWEEN ''' + @tWahF + ''' AND ''' + @tWahT + ''''
 END
 IF (@tPdtF <> '' AND @tPdtT <> '')
 BEGIN
  SET @tSqlIns +=' AND Stk.FTPdtCode BETWEEN ''' + @tPdtF + ''' AND ''' + @tPdtT + ''''
 END
 IF (@tMonth <> '' )
 BEGIN
  SET @tSqlIns +=' AND CONVERT(varchar(2),MONTH(FDStfDate)) BETWEEN ''' + @tMonth + ''' AND ''' + @tMonth + ''''
 END
 IF (@tYear <> '' )
 BEGIN
  SET @tSqlIns +=' AND CONVERT(varchar(4),YEAR(FDStfDate)) BETWEEN ''' + @tYear + ''' AND ''' + @tYear + ''''
 END
 IF (@tPdtStaActive <> '' )
 BEGIN
  SET @tSqlIns +=' AND Pdt.FTPdtStaActive = ''' + @tPdtStaActive + ''' '
 END
  
 DELETE FROM TRPTPdtStkCrdFhnTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 -- Stk
  SET @tSql = ' INSERT INTO TRPTPdtStkCrdFhnTmp '
 SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
 SET @tSql +=' FTBchCode,FTBchName, FDStkDate, FTStkDocNo, FTWahCode,FTWahName, FTPdtCode,FTPdtName,'
 SET @tSql +=' FCStkQtyMonEnd,FCStkQtyIn,FCStkQtyOut,FCStkQtySaleDN,FCStkQtyCN,FCStkQtyAdj,FTBarCode,FTFhnRefCode,FTDepName,FTClsName,FTSeaName,FTPmoName'
 SET @tSql +=' )' 
 SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,' 
 SET @tSql +=' STK.FTBchCode,FTBchName, FDStfDate, FTStfDocNo, Stk.FTWahCode,Wah_L.FTWahName, Stk.FTPdtCode,Pdt_L.FTPdtName,' --FTStkType, 
 SET @tSql +=' CASE WHEN FTStfType = ''0'' THEN FCStfQty ELSE 0 END AS FCStkQtyMonEnd,'
 SET @tSql +=' CASE WHEN FTStfType = ''1'' THEN FCStfQty ELSE 0 END AS FCStkQtyIn,'
 SET @tSql +=' CASE WHEN FTStfType = ''2'' THEN FCStfQty ELSE 0 END AS FCStkQtyOut,'
 SET @tSql +=' CASE WHEN FTStfType = ''3'' THEN FCStfQty ELSE 0 END AS FCStkQtySaleDN,'
 SET @tSql +=' CASE WHEN FTStfType = ''4'' THEN FCStfQty ELSE 0 END AS FCStkQtyCN,'
 SET @tSql +=' CASE WHEN FTStfType = ''5'' THEN FCStfQty ELSE 0 END AS FCStkQtyAdj,'
 SET @tSql +=' FhnBar.FTBarCode,FhnBar.FTFhnRefCode,PDTDPL.FTDepName,PDTClSL.FTClsName,PdtSea_L.FTSeaName,PMOL.FTPmoName'
 SET @tSql +=' FROM   TFHTPdtStkCrd Stk WITH(NOLOCK) LEFT JOIN' 
 SET @tSql +=' TCNMWaHouse_L Wah_L WITH(NOLOCK) ON Stk.FTWahCode = Wah_L.FTWahCode AND Stk.FTBchCode = Wah_L.FTBchCode AND Wah_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN' 
 SET @tSql +=' TCNMPdt_L Pdt_L WITH(NOLOCK) ON Stk.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH(NOLOCK) ON Stk.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode '
 SET @tSql +=' LEFT JOIN TCNMPdtModel_L PMOL WITH (NOLOCK)  ON Pdt.FTPmoCode = PMOL.FTPmoCode AND PMOL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN TFHMPdtFhn FHN WITH (NOLOCK) ON Stk.FTPdtCode = FHN.FTPdtCode '  
 SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L PDTDPL WITH(NOLOCK) ON FHN.FTDepCode = PDTDPL.FTDepCode AND PDTDPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
 SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L PDTClSL WITH(NOLOCK) ON FHN.FTClsCode = PDTClSL.FTClsCode AND PDTClSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition by PCS.FTPdtCode,PCS.FTFhnRefCode ORDER BY PCS.FTPdtCode,PCS.FTFhnRefCode,PCS.FNFhnSeq DESC) AS FNRowID,PCS.FTPdtCode,PCS.FTFhnRefCode,PBAR.FTBarCode,PCS.FTSeaCode FROM  TFHMPdtColorSize PCS WITH (NOLOCK) '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition BY BA.FTPdtCode,BA.FTFhnRefCode,BA.FNBarRefSeq ORDER BY BA.FNBarRefSeq DESC) AS FNRowID, BA.FTPdtCode,BA.FTBarCode,BA.FNBarRefSeq,BA.FTFhnRefCode,BA.FTPunCode FROM TCNMPdtBar BA WITH (NOLOCK) WHERE BA.FTBarStaUse = 1'
 SET @tSql +=' ) PBAR ON PCS.FTPdtCode = PBAR.FTPdtCode AND PCS.FTFhnRefCode = PBAR.FTFhnRefCode AND PCS.FNFhnSeq = PBAR.FNBarRefSeq AND PBAR.FNRowID = 1'
 SET @tSql +=' ) FhnBar ON Stk.FTPdtCode = FhnBar.FTPdtCode AND Stk.FTFhnRefCode = FhnBar.FTFhnRefCode AND  FhnBar.FNRowID=1'
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason PdtSea WITH(NOLOCK) ON FhnBar.FTSeaCode = PdtSea.FTSeaCode '
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason_L PdtSea_L WITH(NOLOCK) ON PdtSea.FTSeaCode = PdtSea_L.FTSeaCode AND PdtSea.FTSeaChain = PdtSea_L.FTSeaChain AND PdtSea_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
     --SELECT  @tSql 
    SET @tSql +=  @tSqlIns
 EXECUTE(@tSql)
 ----STKBch
 SET @tSql = ' INSERT INTO TRPTPdtStkCrdFhnTmp '
 SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
 SET @tSql +=' FTBchCode,FTBchName, FDStkDate, FTStkDocNo, FTWahCode,FTWahName, FTPdtCode,FTPdtName,'
 SET @tSql +=' FCStkQtyMonEnd,FCStkQtyIn,FCStkQtyOut,FCStkQtySaleDN,FCStkQtyCN,FCStkQtyAdj,FTBarCode,FTFhnRefCode,FTDepName,FTClsName,FTSeaName,FTPmoName'
 SET @tSql +=' )' 
 SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,' 
 SET @tSql +=' STK.FTBchCode,FTBchName, FDStfDate, FTStfDocNo, Stk.FTWahCode,Wah_L.FTWahName, Stk.FTPdtCode,Pdt_L.FTPdtName,' --FTStkType, 
 SET @tSql +=' CASE WHEN FTStfType = ''0'' THEN FCStfQty ELSE 0 END AS FCStkQtyMonEnd,'
 SET @tSql +=' CASE WHEN FTStfType = ''1'' THEN FCStfQty ELSE 0 END AS FCStkQtyIn,'
 SET @tSql +=' CASE WHEN FTStfType = ''2'' THEN FCStfQty ELSE 0 END AS FCStkQtyOut,'
 SET @tSql +=' CASE WHEN FTStfType = ''3'' THEN FCStfQty ELSE 0 END AS FCStkQtySaleDN,'
 SET @tSql +=' CASE WHEN FTStfType = ''4'' THEN FCStfQty ELSE 0 END AS FCStkQtyCN,'
 SET @tSql +=' CASE WHEN FTStfType = ''5'' THEN FCStfQty ELSE 0 END AS FCStkQtyAdj,'
 SET @tSql +=' FhnBar.FTBarCode,FhnBar.FTFhnRefCode,PDTDPL.FTDepName,PDTClSL.FTClsName,PdtSea_L.FTSeaName,PMOL.FTPmoName'
 SET @tSql +=' FROM   TFHTPdtStkCrdBch Stk WITH(NOLOCK) LEFT JOIN' 
 SET @tSql +=' TCNMWaHouse_L Wah_L WITH(NOLOCK) ON Stk.FTWahCode = Wah_L.FTWahCode AND Stk.FTBchCode = Wah_L.FTBchCode AND Wah_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN' 
 SET @tSql +=' TCNMPdt_L Pdt_L WITH(NOLOCK) ON Stk.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH(NOLOCK) ON Stk.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode '
 SET @tSql +=' LEFT JOIN TCNMPdtModel_L PMOL WITH (NOLOCK)  ON Pdt.FTPmoCode = PMOL.FTPmoCode AND PMOL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN TFHMPdtFhn FHN WITH (NOLOCK) ON Stk.FTPdtCode = FHN.FTPdtCode '  
 SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L PDTDPL WITH(NOLOCK) ON FHN.FTDepCode = PDTDPL.FTDepCode AND PDTDPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
 SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L PDTClSL WITH(NOLOCK) ON FHN.FTClsCode = PDTClSL.FTClsCode AND PDTClSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition by PCS.FTPdtCode,PCS.FTFhnRefCode ORDER BY PCS.FTPdtCode,PCS.FTFhnRefCode,PCS.FNFhnSeq DESC) AS FNRowID,PCS.FTPdtCode,PCS.FTFhnRefCode,PBAR.FTBarCode,PCS.FTSeaCode FROM  TFHMPdtColorSize PCS WITH (NOLOCK) '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition BY BA.FTPdtCode,BA.FTFhnRefCode,BA.FNBarRefSeq ORDER BY BA.FNBarRefSeq DESC) AS FNRowID, BA.FTPdtCode,BA.FTBarCode,BA.FNBarRefSeq,BA.FTFhnRefCode,BA.FTPunCode FROM TCNMPdtBar BA WITH (NOLOCK) WHERE BA.FTBarStaUse = 1'
 SET @tSql +=' ) PBAR ON PCS.FTPdtCode = PBAR.FTPdtCode AND PCS.FTFhnRefCode = PBAR.FTFhnRefCode AND PCS.FNFhnSeq = PBAR.FNBarRefSeq AND PBAR.FNRowID = 1'
 SET @tSql +=' ) FhnBar ON Stk.FTPdtCode = FhnBar.FTPdtCode AND Stk.FTFhnRefCode = FhnBar.FTFhnRefCode AND  FhnBar.FNRowID=1'
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason PdtSea WITH(NOLOCK) ON FhnBar.FTSeaCode = PdtSea.FTSeaCode '
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason_L PdtSea_L WITH(NOLOCK) ON PdtSea.FTSeaCode = PdtSea_L.FTSeaCode AND PdtSea.FTSeaChain = PdtSea_L.FTSeaChain AND PdtSea_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=  @tSqlIns 
 --SELECT  @tSql 
 EXECUTE(@tSql)
 ----STKME
 SET @tSql = ' INSERT INTO TRPTPdtStkCrdFhnTmp '
 SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
 SET @tSql +=' FTBchCode,FTBchName, FDStkDate, FTStkDocNo, FTWahCode,FTWahName, FTPdtCode,FTPdtName,'
 SET @tSql +=' FCStkQtyMonEnd,FCStkQtyIn,FCStkQtyOut,FCStkQtySaleDN,FCStkQtyCN,FCStkQtyAdj,FTBarCode,FTFhnRefCode,FTDepName,FTClsName,FTSeaName,FTPmoName'
 SET @tSql +=' )' 
 SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,' 
 SET @tSql +=' STK.FTBchCode,FTBchName,FDStfDate,FTStfDocNo,Stk.FTWahCode,Wah_L.FTWahName,Stk.FTPdtCode,Pdt_L.FTPdtName,' --FTStkType, 
 SET @tSql +=' CASE WHEN FTStfType = ''0'' THEN FCStfQty ELSE 0 END AS FCStkQtyMonEnd,'
 SET @tSql +=' CASE WHEN FTStfType = ''1'' THEN FCStfQty ELSE 0 END AS FCStkQtyIn,'
 SET @tSql +=' CASE WHEN FTStfType = ''2'' THEN FCStfQty ELSE 0 END AS FCStkQtyOut,'
 SET @tSql +=' CASE WHEN FTStfType = ''3'' THEN FCStfQty ELSE 0 END AS FCStkQtySaleDN,'
 SET @tSql +=' CASE WHEN FTStfType = ''4'' THEN FCStfQty ELSE 0 END AS FCStkQtyCN,'
 SET @tSql +=' CASE WHEN FTStfType = ''5'' THEN FCStfQty ELSE 0 END AS FCStkQtyAdj,'
 SET @tSql +=' FhnBar.FTBarCode,FhnBar.FTFhnRefCode,PDTDPL.FTDepName,PDTClSL.FTClsName,PdtSea_L.FTSeaName,PMOL.FTPmoName' 
 SET @tSql +=' FROM   TFHTPdtStkCrdMe Stk WITH(NOLOCK) LEFT JOIN' 
 SET @tSql +=' TCNMWaHouse_L Wah_L WITH(NOLOCK) ON Stk.FTWahCode = Wah_L.FTWahCode AND Stk.FTBchCode = Wah_L.FTBchCode AND Wah_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN' 
 SET @tSql +=' TCNMPdt_L Pdt_L WITH(NOLOCK) ON Stk.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH(NOLOCK) ON Stk.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode '
 SET @tSql +=' LEFT JOIN TCNMPdtModel_L PMOL WITH (NOLOCK)  ON Pdt.FTPmoCode = PMOL.FTPmoCode AND PMOL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN TFHMPdtFhn FHN WITH (NOLOCK) ON Stk.FTPdtCode = FHN.FTPdtCode '  
 SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L PDTDPL WITH(NOLOCK) ON FHN.FTDepCode = PDTDPL.FTDepCode AND PDTDPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
 SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L PDTClSL WITH(NOLOCK) ON FHN.FTClsCode = PDTClSL.FTClsCode AND PDTClSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition by PCS.FTPdtCode,PCS.FTFhnRefCode ORDER BY PCS.FTPdtCode,PCS.FTFhnRefCode,PCS.FNFhnSeq DESC) AS FNRowID,PCS.FTPdtCode,PCS.FTFhnRefCode,PBAR.FTBarCode,PCS.FTSeaCode FROM  TFHMPdtColorSize PCS WITH (NOLOCK) '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition BY BA.FTPdtCode,BA.FTFhnRefCode,BA.FNBarRefSeq ORDER BY BA.FNBarRefSeq DESC) AS FNRowID, BA.FTPdtCode,BA.FTBarCode,BA.FNBarRefSeq,BA.FTFhnRefCode,BA.FTPunCode FROM TCNMPdtBar BA WITH (NOLOCK) WHERE BA.FTBarStaUse = 1'
 SET @tSql +=' ) PBAR ON PCS.FTPdtCode = PBAR.FTPdtCode AND PCS.FTFhnRefCode = PBAR.FTFhnRefCode AND PCS.FNFhnSeq = PBAR.FNBarRefSeq AND PBAR.FNRowID = 1'
 SET @tSql +=' ) FhnBar ON Stk.FTPdtCode = FhnBar.FTPdtCode AND Stk.FTFhnRefCode = FhnBar.FTFhnRefCode AND  FhnBar.FNRowID=1'
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason PdtSea WITH(NOLOCK) ON FhnBar.FTSeaCode = PdtSea.FTSeaCode '
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason_L PdtSea_L WITH(NOLOCK) ON PdtSea.FTSeaCode = PdtSea_L.FTSeaCode AND PdtSea.FTSeaChain = PdtSea_L.FTSeaChain AND PdtSea_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
    SET @tSql +=  @tSqlIns

 --SELECT  @tSql 
 EXECUTE(@tSql)
 RETURN SELECT * FROM TRPTPdtStkCrdFhnTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
 
END TRY
BEGIN CATCH 
 SET @FNResult= -1
 PRINT @tSql
END CATCH 

GO





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[SP_RPTxSpcStockBalFhn]    Script Date: 14/7/2564 13:01:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxSpcStockBalFhn]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxSpcStockBalFhn
GO
CREATE PROCEDURE [dbo].[SP_RPTxSpcStockBalFhn] 
    @pnLngID int , 
	@ptComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),

	@pnFilterType int, --1 BETWEEN 2 IN
	--สาขา
	@ptBchL Varchar(8000), --กรณี Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--@ptBchF VARCHAR(100),
	--@ptBchT VARCHAR(100),
	@ptWahCodeF VARCHAR(100),
	@ptWahCodeT VARCHAR(100),

	@FTResult VARCHAR(8000) OUTPUT

AS
BEGIN TRY

      DECLARE @tSQL VARCHAR(8000)
	  DECLARE @tSQL_Filter VARCHAR(8000)

	  DECLARE @nLngID int
	  DECLARE @tComName VARCHAR(100)
	  DECLARE @tRptCode VARCHAR(100)
	  DECLARE @tUsrSession VARCHAR(255)

	  --Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	  --DECLARE @tBchF VARCHAR(100)
	  --DECLARE @tBchT VARCHAR(100)
	  DECLARE @tWahCodeF VARCHAR(100)
	  DECLARE @tWahCodeT VARCHAR(100)

	  SET @tComName = @ptComName
	  SET @tRptCode = @ptRptCode
	  SET @tUsrSession = @ptUsrSession
	  SET @nLngID = @pnLngID

	  --Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT

	  --SET @tBchF = @ptBchF
	  --SET @tBchT = @ptBchT
	  SET @tWahCodeF = @ptWahCodeF
	  SET @tWahCodeT = @ptWahCodeT

	  SET @tSQL_Filter = ' WHERE 1 = 1 AND PDT1.FTPdtStaActive = 1  '

	  IF(@nLngID = '' OR @nLngID = NULL)
	     BEGIN
		      SET @nLngID = 1
		 END
	   ELSE IF(@nLngID <> '')
	     BEGIN
		     SET @nLngID = @pnLngID
		 END

	  IF @ptBchL = null
	BEGIN
		SET @ptBchL = ''
	END

	IF @tBchF = null
	BEGIN
		SET @tBchF = ''
	END
	IF @tBchT = null OR @tBchT = ''
	BEGIN
		SET @tBchT = @tBchF
	END

	  --IF(@tBchF = '' OR @tBchF = NULL)
			-- BEGIN
			--	  SET @tBchF = ''
			-- END
	  -- ELSE IF(@tBchF <> '')
			-- BEGIN
			--	 SET @tBchF = @tBchF
			-- END

	  -- IF(@tBchT = '' OR @tBchT = NULL)
			-- BEGIN
			--	  SET @tBchT = ''
			-- END
	  -- ELSE IF(@tBchT <> '')
			-- BEGIN
			--	 SET @tBchT = @tBchT
			-- END
	   
	  -- IF(@tBchF <> '' AND @tBchT <> '')
			-- BEGIN 
			--	  SET @tSQL_Filter += ' AND STK.FTBchCode BETWEEN ''' + @tBchF +''' AND ''' + @tBchT + ''' ' 
			-- END
	  -- ELSE IF(@tBchF = '' AND @tBchT = '')
	  --       BEGIN 
			--      SET @tSQL_Filter += ''
			-- END

		IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSQL_Filter +=' AND STK.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END	
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSQL_Filter +=' AND STK.FTBchCode IN (' + @ptBchL + ')'
		END	
	END

	   --คลังสินค้า
	   IF(@tWahCodeF = '' OR @tWahCodeF = NULL)
			 BEGIN
				  SET @tWahCodeF = ''
			 END
	   ELSE IF(@tWahCodeF <> '')
			 BEGIN
				 SET @tWahCodeF = @tWahCodeF
			 END

		 --ถึงคลัง
	   IF(@tWahCodeT = '' OR @tWahCodeT = NULL)
			 BEGIN
				  SET @tWahCodeT = ''
			 END
	   ELSE IF(@tWahCodeT <> '')
			 BEGIN
				 SET @tWahCodeT = @tWahCodeT
			 END

	   IF(@tWahCodeF <> '' AND @tWahCodeT <> '')
			  BEGIN 
				  SET @tSQL_Filter += ' AND STK.FTWahCode BETWEEN '''+@tWahCodeF+''' AND '''+@tWahCodeT+''' ' 
			  END
	   ELSE IF(@tWahCodeF = '' AND @tWahCodeT = '')
	         BEGIN 
			      SET @tSQL_Filter += ''
			 END
	 
	   
	   --DELETE FROM TRPTPdtStkBalFhnTmp WITH (ROWLOCK) WHERE FTComName =  '' + @tComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''	  
	   DELETE FROM TRPTPdtStkBalFhnTmp  WHERE FTComName =  '' + @tComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''

	  SET @tSQL  = ' INSERT INTO TRPTPdtStkBalFhnTmp (FTComName,FTRptCode,FTUsrSession,FTWahCode,FTWahName,FTPdtCode,FTPdtName,FCStkQty,'	  
	  SET @tSQL += ' FTPgpChainName,FCPdtCostAVGEX,FCPdtCostTotal,FTBchCode,FTBchName,FTFhnRefCode,FTDepName,FTClsName,FTSeaName,FTPmoName,FTFabName,FTClrName,FTClrRmk,FTPszName,FTBarCode,FCPgdPriceRet,FCXshNetSale,FCXshDiffCost)'
		SET @tSQL += ' SELECT '''+ @tComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	  SET @tSQL +=  ' WAH.FTWAHCODE,WAH.FTWahName,PDT.FTPdtCode,PDT.FTPdtName,STK.FCStfBal,Grp_L.FTPgpChainName,ISNULL(AvgCost.FCPdtCostAVGEX,0) AS FCPdtCostAVGEX,ISNULL(AvgCost.FCPdtCostAVGEX,0)* ISNULL(STK.FCStfBal,0) AS FCPdtCostTotal ,'
	  SET @tSQL +=  ' BCHL.FTBchCode,BCHL.FTBchName,STK.FTFhnRefCode,PDTDPL.FTDepName,PDTClSL.FTClsName,PdtSea_L.FTSeaName,PMOL.FTPmoName,PdtFab_L.FTFabName,PdtColor_L.FTClrName,PdtColor_L.FTClrRmk,PdtSize_L.FTPszName,FhnBar.FTBarCode,ISNULL(P4PDT.FCPgdPriceRet,0) AS FCPgdPriceRet,(ISNULL(P4PDT.FCPgdPriceRet,0) * ISNULL(STK.FCStfBal,0) ) AS FCXshNetSale,(ISNULL(P4PDT.FCPgdPriceRet,0) * ISNULL(STK.FCStfBal,0) ) - (ISNULL(AvgCost.FCPdtCostAVGEX, 0) * ISNULL(STK.FCStfBal, 0)) AS FCXshDiffCost'
		SET @tSQL +=  ' FROM TFHTPDTSTKBAL STK WITH (NOLOCK)'
		SET @tSQL +=  ' LEFT JOIN VCN_ProductCost AvgCost WITH (NOLOCK) ON STK.FTPdtCode = AvgCost.FTPdtCode '
		SET @tSQL +=  ' LEFT JOIN TCNMPdt PDT1 WITH (NOLOCK) ON  STK.FTPdtCode = PDT1.FTPdtCode'
		SET @tSQL +=  ' LEFT JOIN TCNMPDT_L PDT WITH (NOLOCK) ON  STK.FTPDTCODE = PDT.FTPDTCODE AND PDT.FNLNGID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		SET @tSQL +=  ' LEFT JOIN TCNMWAHOUSE_L  WAH WITH (NOLOCK) ON STK.FTWAHCODE = WAH.FTWAHCODE AND STK.FTBchCode = WAH.FTBchCode AND WAH.FNLNGID = ''' + CAST(@nLngID  AS VARCHAR(10)) + '''  '
		SET @tSQL +=  ' LEFT JOIN TCNMBranch_L BCHL WITH (NOLOCK) ON STK.FTBchCode = BCHL.FTBchCode AND BCHL.FNLNGID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		SET @tSQL +=  ' LEFT JOIN TCNMPdtGrp_L Grp_L WITH (NOLOCK) ON Pdt1.FTPgpChain  =  Grp_L.FTPgpChain AND WAH.FNLNGID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		SET @tSql +=' LEFT JOIN TCNMPdtModel_L PMOL WITH (NOLOCK)  ON PDT1.FTPmoCode = PMOL.FTPmoCode AND PMOL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		SET @tSql +=' LEFT JOIN TFHMPdtFhn FHN WITH (NOLOCK) ON STK.FTPdtCode = FHN.FTPdtCode '  
		SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L PDTDPL WITH(NOLOCK) ON FHN.FTDepCode = PDTDPL.FTDepCode AND PDTDPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
		SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L PDTClSL WITH(NOLOCK) ON FHN.FTClsCode = PDTClSL.FTClsCode AND PDTClSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition by PCS.FTPdtCode,PCS.FTFhnRefCode ORDER BY PCS.FTPdtCode,PCS.FTFhnRefCode,PCS.FNFhnSeq DESC) AS FNRowID,PCS.FTPdtCode,PCS.FTFhnRefCode,PBAR.FTBarCode,PCS.FTSeaCode,PCS.FTFabCode,PCS.FTClrCode,PCS.FTPszCode,PBAR.FTPunCode FROM  TFHMPdtColorSize PCS WITH (NOLOCK) '
		SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition BY BA.FTPdtCode,BA.FTFhnRefCode,BA.FNBarRefSeq ORDER BY BA.FNBarRefSeq DESC) AS FNRowID, BA.FTPdtCode,BA.FTBarCode,BA.FNBarRefSeq,BA.FTFhnRefCode,BA.FTPunCode FROM TCNMPdtBar BA WITH (NOLOCK) WHERE BA.FTBarStaUse = 1'
		SET @tSql +=' ) PBAR ON PCS.FTPdtCode = PBAR.FTPdtCode AND PCS.FTFhnRefCode = PBAR.FTFhnRefCode AND PCS.FNFhnSeq = PBAR.FNBarRefSeq AND PBAR.FNRowID = 1'
		SET @tSql +=' ) FhnBar ON Stk.FTPdtCode = FhnBar.FTPdtCode AND Stk.FTFhnRefCode = FhnBar.FTFhnRefCode AND  FhnBar.FNRowID=1'
		SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason PdtSea WITH(NOLOCK) ON FhnBar.FTSeaCode = PdtSea.FTSeaCode '
		SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason_L PdtSea_L WITH(NOLOCK) ON PdtSea.FTSeaCode = PdtSea_L.FTSeaCode AND PdtSea.FTSeaChain = PdtSea_L.FTSeaChain AND PdtSea_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	  SET @tSql +=' LEFT OUTER JOIN TFHMPdtFabric_L PdtFab_L WITH(NOLOCK) ON FhnBar.FTFabCode = PdtFab_L.FTFabCode AND PdtFab_L.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	  SET @tSql +=' LEFT OUTER JOIN TCNMPdtColor_L PdtColor_L WITH(NOLOCK) ON FhnBar.FTClrCode = PdtColor_L.FTClrCode AND PdtColor_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	  SET @tSql +=' LEFT OUTER JOIN TCNMPdtSize_L PdtSize_L WITH(NOLOCK) ON FhnBar.FTPszCode = PdtSize_L.FTPszCode AND PdtSize_L.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + '''  '   
    SET @tSql +=' LEFT OUTER JOIN VCN_Price4PdtActive P4PDT WITH (NOLOCK) ON FhnBar.FTPdtCode = P4PDT.FTPdtCode AND FhnBar.FTPunCode = P4PDT.FTPunCode '
SET @tSQL += @tSQL_Filter		

	  PRINT @tSQL
	  EXECUTE(@tSQL)

	 SET @FTResult = CONVERT(VARCHAR(8000),@tSQL)

	 RETURN @FTResult

END TRY
BEGIN CATCH
     return -1
	 PRINT @tSQL
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[SP_RPTxSpcStockMoventFhn]    Script Date: 19/7/2564 10:27:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[SP_RPTxSpcStockMoventFhn]    Script Date: 14/7/2564 13:01:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxSpcStockMoventFhn]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxSpcStockMoventFhn
GO
CREATE PROCEDURE [dbo].[SP_RPTxSpcStockMoventFhn]
 @pnLngID int , 
 @pnComName Varchar(100),
 @ptRptCode Varchar(100),
 @ptUsrSession Varchar(255),
 @pnFilterType int, --1 BETWEEN 2 IN
 --สาขา
 @ptBchL Varchar(8000), --กรณี Condition IN
 @ptBchF Varchar(5),
 @ptBchT Varchar(5),
 @ptPdtF Varchar(20),
 @ptPdtT Varchar(20),
 @ptWahF Varchar(5),
 @ptWahT Varchar(5), 
 @ptMonth Varchar(2) , 
 @ptYear Varchar(4),
 @ptPdtStaActive Varchar(2), -- 1 เคลื่อนไหว , 2 ไม่เคลื่อนไหว
 
 @FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 14/08/2019
-- Temp name  TRPTVDPdtStkBalTmp
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @@ptBchF จากสาขา
-- @@ptBchT ถึงสาขา
-- @ptPdtF จากสินค้า
-- @ptPdtT ถึงสินค้า
-- @ptWahF จากคลัง
-- @ptWahT ถึงคลัง
-- @ptDocDateF จากวันที่
-- @ptDocDateT ถึงวันที่
-- @FNResult
--------------------------------------
BEGIN TRY 
 DECLARE @nLngID int 
 DECLARE @nComName Varchar(100)
 DECLARE @tRptCode Varchar(100)
 DECLARE @tUsrSession Varchar(255)
 DECLARE @tSql VARCHAR(8000)
 DECLARE @tSqlIns VARCHAR(8000)
 DECLARE @tSql1 VARCHAR(Max)
 DECLARE @tSql0 VARCHAR(8000)
 DECLARE @tBchF Varchar(5)
 DECLARE @tBchT Varchar(5)
 DECLARE @tPdtF Varchar(20)
 DECLARE @tPdtT Varchar(20)
 DECLARE @tWahF Varchar(5)
 DECLARE @tWahT Varchar(5)
 DECLARE @tMonth Varchar(2) 
 DECLARE @tYear Varchar(4)
 DECLARE @tPdtStaActive Varchar(2)
 SET @nLngID = @pnLngID
 SET @nComName = @pnComName
 SET @tUsrSession = @ptUsrSession
 SET @tRptCode = @ptRptCode
 SET @tBchF = @ptBchF
 SET @tBchT = @ptBchT
 SET @tPdtF = @ptPdtF
 SET @tPdtT = @ptPdtT
 SET @tWahF = @ptWahF
 SET @tWahT = @ptWahT
 SET @tMonth = @ptMonth
 SET @tYear = @ptYear
 SET @tPdtStaActive = @ptPdtStaActive
 SET @FNResult= 0
 IF @nLngID = null
 BEGIN
  SET @nLngID = 1
 END 
 --Set ค่าให้ Paraleter กรณี T เป็นค่าว่างหรือ null
 IF @tBchF = null
 BEGIN
  SET @tBchF = ''
 END
 IF @tBchT = null OR @tBchT = ''
 BEGIN
  SET @tBchT = @tBchF
 END
 IF @tPdtF = null
 BEGIN
  SET @tPdtF = ''
 END 
 IF @tPdtT = null OR @tPdtT =''
 BEGIN
  SET @tPdtT = @tPdtF
 END 
 IF @tWahF = null
 BEGIN
  SET @tWahF = ''
 END 
 IF @tWahT = null OR @tWahT =''
 BEGIN
  SET @tWahT = @tWahF
 END 
 IF @tMonth = null
 BEGIN 
  SET @tMonth = ''
 END
 IF @tYear = null
 BEGIN 
  SET @tYear = ''
 END
  
 SET @tSqlIns =   ' WHERE 1=1 '
 IF @pnFilterType = '1'
 BEGIN
  IF (@tBchF <> '' AND @tBchT <> '')
  BEGIN
   SET @tSqlIns +=' AND Stk.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
  END 
 END
 IF @pnFilterType = '2'
 BEGIN
  IF (@ptBchL <> '' )
  BEGIN
   SET @tSqlIns +=' AND Stk.FTBchCode IN (' + @ptBchL + ')'
  END 
 END
  
 IF (@tWahF <> '' AND @tWahT <> '')
 BEGIN
  SET @tSqlIns +=' AND Stk.FTWahCode BETWEEN ''' + @tWahF + ''' AND ''' + @tWahT + ''''
 END
 IF (@tPdtF <> '' AND @tPdtT <> '')
 BEGIN
  SET @tSqlIns +=' AND Stk.FTPdtCode BETWEEN ''' + @tPdtF + ''' AND ''' + @tPdtT + ''''
 END
 IF (@tMonth <> '' )
 BEGIN
  SET @tSqlIns +=' AND CONVERT(varchar(2),MONTH(FDStfDate)) BETWEEN ''' + @tMonth + ''' AND ''' + @tMonth + ''''
 END
 IF (@tYear <> '' )
 BEGIN
  SET @tSqlIns +=' AND CONVERT(varchar(4),YEAR(FDStfDate)) BETWEEN ''' + @tYear + ''' AND ''' + @tYear + ''''
 END
 IF (@tPdtStaActive <> '' )
 BEGIN
  SET @tSqlIns +=' AND Pdt.FTPdtStaActive = ''' + @tPdtStaActive + ''' '
 END
  
 DELETE FROM TRPTPdtStkCrdFhnTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 -- Stk
  SET @tSql = ' INSERT INTO TRPTPdtStkCrdFhnTmp '
 SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
 SET @tSql +=' FTBchCode,FTBchName, FDStkDate, FTStkDocNo, FTWahCode,FTWahName, FTPdtCode,FTPdtName,'
 SET @tSql +=' FCStkQtyMonEnd,FCStkQtyIn,FCStkQtyOut,FCStkQtySaleDN,FCStkQtyCN,FCStkQtyAdj,FTBarCode,FTFhnRefCode,FTDepName,FTClsName,FTSeaName,FTPmoName,FTFabName,FTClrName,FTClrRmk,FTPszName'
 SET @tSql +=' )' 
 SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,' 
 SET @tSql +=' STK.FTBchCode,FTBchName, FDStfDate, FTStfDocNo, Stk.FTWahCode,Wah_L.FTWahName, Stk.FTPdtCode,Pdt_L.FTPdtName,' --FTStkType, 
 SET @tSql +=' CASE WHEN FTStfType = ''0'' THEN FCStfQty ELSE 0 END AS FCStkQtyMonEnd,'
 SET @tSql +=' CASE WHEN FTStfType = ''1'' THEN FCStfQty ELSE 0 END AS FCStkQtyIn,'
 SET @tSql +=' CASE WHEN FTStfType = ''2'' THEN FCStfQty ELSE 0 END AS FCStkQtyOut,'
 SET @tSql +=' CASE WHEN FTStfType = ''3'' THEN FCStfQty ELSE 0 END AS FCStkQtySaleDN,'
 SET @tSql +=' CASE WHEN FTStfType = ''4'' THEN FCStfQty ELSE 0 END AS FCStkQtyCN,'
 SET @tSql +=' CASE WHEN FTStfType = ''5'' THEN FCStfQty ELSE 0 END AS FCStkQtyAdj,'
 SET @tSql +=' FhnBar.FTBarCode,FhnBar.FTFhnRefCode,PDTDPL.FTDepName,PDTClSL.FTClsName,PdtSea_L.FTSeaName,PMOL.FTPmoName,PdtFab_L.FTFabName,PdtColor_L.FTClrName,PdtColor_L.FTClrRmk,PdtSize_L.FTPszName'
 SET @tSql +=' FROM   TFHTPdtStkCrd Stk WITH(NOLOCK) LEFT JOIN' 
 SET @tSql +=' TCNMWaHouse_L Wah_L WITH(NOLOCK) ON Stk.FTWahCode = Wah_L.FTWahCode AND Stk.FTBchCode = Wah_L.FTBchCode AND Wah_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN' 
 SET @tSql +=' TCNMPdt_L Pdt_L WITH(NOLOCK) ON Stk.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH(NOLOCK) ON Stk.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode '
 SET @tSql +=' LEFT JOIN TCNMPdtModel_L PMOL WITH (NOLOCK)  ON Pdt.FTPmoCode = PMOL.FTPmoCode AND PMOL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN TFHMPdtFhn FHN WITH (NOLOCK) ON Stk.FTPdtCode = FHN.FTPdtCode '  
 SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L PDTDPL WITH(NOLOCK) ON FHN.FTDepCode = PDTDPL.FTDepCode AND PDTDPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
 SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L PDTClSL WITH(NOLOCK) ON FHN.FTClsCode = PDTClSL.FTClsCode AND PDTClSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition by PCS.FTPdtCode,PCS.FTFhnRefCode ORDER BY PCS.FTPdtCode,PCS.FTFhnRefCode,PCS.FNFhnSeq DESC) AS FNRowID,PCS.FTPdtCode,PCS.FTFhnRefCode,PBAR.FTBarCode,PCS.FTSeaCode,PCS.FTFabCode,PCS.FTClrCode,PCS.FTPszCode FROM  TFHMPdtColorSize PCS WITH (NOLOCK) '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition BY BA.FTPdtCode,BA.FTFhnRefCode,BA.FNBarRefSeq ORDER BY BA.FNBarRefSeq DESC) AS FNRowID, BA.FTPdtCode,BA.FTBarCode,BA.FNBarRefSeq,BA.FTFhnRefCode,BA.FTPunCode FROM TCNMPdtBar BA WITH (NOLOCK) WHERE BA.FTBarStaUse = 1'
 SET @tSql +=' ) PBAR ON PCS.FTPdtCode = PBAR.FTPdtCode AND PCS.FTFhnRefCode = PBAR.FTFhnRefCode AND PCS.FNFhnSeq = PBAR.FNBarRefSeq AND PBAR.FNRowID = 1'
 SET @tSql +=' ) FhnBar ON Stk.FTPdtCode = FhnBar.FTPdtCode AND Stk.FTFhnRefCode = FhnBar.FTFhnRefCode AND  FhnBar.FNRowID=1'
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason PdtSea WITH(NOLOCK) ON FhnBar.FTSeaCode = PdtSea.FTSeaCode '
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason_L PdtSea_L WITH(NOLOCK) ON PdtSea.FTSeaCode = PdtSea_L.FTSeaCode AND PdtSea.FTSeaChain = PdtSea_L.FTSeaChain AND PdtSea_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtFabric_L PdtFab_L WITH(NOLOCK) ON FhnBar.FTFabCode = PdtFab_L.FTFabCode AND PdtFab_L.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT OUTER JOIN TCNMPdtColor_L PdtColor_L WITH(NOLOCK) ON FhnBar.FTClrCode = PdtColor_L.FTClrCode AND PdtColor_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT OUTER JOIN TCNMPdtSize_L PdtSize_L WITH(NOLOCK) ON FhnBar.FTPszCode = PdtSize_L.FTPszCode AND PdtSize_L.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + '''  '    
--SELECT  @tSql 
    SET @tSql +=  @tSqlIns
 EXECUTE(@tSql)
 ----STKBch
 SET @tSql = ' INSERT INTO TRPTPdtStkCrdFhnTmp '
 SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
 SET @tSql +=' FTBchCode,FTBchName, FDStkDate, FTStkDocNo, FTWahCode,FTWahName, FTPdtCode,FTPdtName,'
 SET @tSql +=' FCStkQtyMonEnd,FCStkQtyIn,FCStkQtyOut,FCStkQtySaleDN,FCStkQtyCN,FCStkQtyAdj,FTBarCode,FTFhnRefCode,FTDepName,FTClsName,FTSeaName,FTPmoName,FTFabName,FTClrName,FTClrRmk,FTPszName'
 SET @tSql +=' )' 
 SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,' 
 SET @tSql +=' STK.FTBchCode,FTBchName, FDStfDate, FTStfDocNo, Stk.FTWahCode,Wah_L.FTWahName, Stk.FTPdtCode,Pdt_L.FTPdtName,' --FTStkType, 
 SET @tSql +=' CASE WHEN FTStfType = ''0'' THEN FCStfQty ELSE 0 END AS FCStkQtyMonEnd,'
 SET @tSql +=' CASE WHEN FTStfType = ''1'' THEN FCStfQty ELSE 0 END AS FCStkQtyIn,'
 SET @tSql +=' CASE WHEN FTStfType = ''2'' THEN FCStfQty ELSE 0 END AS FCStkQtyOut,'
 SET @tSql +=' CASE WHEN FTStfType = ''3'' THEN FCStfQty ELSE 0 END AS FCStkQtySaleDN,'
 SET @tSql +=' CASE WHEN FTStfType = ''4'' THEN FCStfQty ELSE 0 END AS FCStkQtyCN,'
 SET @tSql +=' CASE WHEN FTStfType = ''5'' THEN FCStfQty ELSE 0 END AS FCStkQtyAdj,'
 SET @tSql +=' FhnBar.FTBarCode,FhnBar.FTFhnRefCode,PDTDPL.FTDepName,PDTClSL.FTClsName,PdtSea_L.FTSeaName,PMOL.FTPmoName,PdtFab_L.FTFabName,PdtColor_L.FTClrName,PdtColor_L.FTClrRmk,PdtSize_L.FTPszName'
 SET @tSql +=' FROM   TFHTPdtStkCrdBch Stk WITH(NOLOCK) LEFT JOIN' 
 SET @tSql +=' TCNMWaHouse_L Wah_L WITH(NOLOCK) ON Stk.FTWahCode = Wah_L.FTWahCode AND Stk.FTBchCode = Wah_L.FTBchCode AND Wah_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN' 
 SET @tSql +=' TCNMPdt_L Pdt_L WITH(NOLOCK) ON Stk.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH(NOLOCK) ON Stk.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode '
 SET @tSql +=' LEFT JOIN TCNMPdtModel_L PMOL WITH (NOLOCK)  ON Pdt.FTPmoCode = PMOL.FTPmoCode AND PMOL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN TFHMPdtFhn FHN WITH (NOLOCK) ON Stk.FTPdtCode = FHN.FTPdtCode '  
 SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L PDTDPL WITH(NOLOCK) ON FHN.FTDepCode = PDTDPL.FTDepCode AND PDTDPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
 SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L PDTClSL WITH(NOLOCK) ON FHN.FTClsCode = PDTClSL.FTClsCode AND PDTClSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition by PCS.FTPdtCode,PCS.FTFhnRefCode ORDER BY PCS.FTPdtCode,PCS.FTFhnRefCode,PCS.FNFhnSeq DESC) AS FNRowID,PCS.FTPdtCode,PCS.FTFhnRefCode,PBAR.FTBarCode,PCS.FTSeaCode,PCS.FTFabCode,PCS.FTClrCode,PCS.FTPszCode FROM  TFHMPdtColorSize PCS WITH (NOLOCK) '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition BY BA.FTPdtCode,BA.FTFhnRefCode,BA.FNBarRefSeq ORDER BY BA.FNBarRefSeq DESC) AS FNRowID, BA.FTPdtCode,BA.FTBarCode,BA.FNBarRefSeq,BA.FTFhnRefCode,BA.FTPunCode FROM TCNMPdtBar BA WITH (NOLOCK) WHERE BA.FTBarStaUse = 1'
 SET @tSql +=' ) PBAR ON PCS.FTPdtCode = PBAR.FTPdtCode AND PCS.FTFhnRefCode = PBAR.FTFhnRefCode AND PCS.FNFhnSeq = PBAR.FNBarRefSeq AND PBAR.FNRowID = 1'
 SET @tSql +=' ) FhnBar ON Stk.FTPdtCode = FhnBar.FTPdtCode AND Stk.FTFhnRefCode = FhnBar.FTFhnRefCode AND  FhnBar.FNRowID=1'
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason PdtSea WITH(NOLOCK) ON FhnBar.FTSeaCode = PdtSea.FTSeaCode '
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason_L PdtSea_L WITH(NOLOCK) ON PdtSea.FTSeaCode = PdtSea_L.FTSeaCode AND PdtSea.FTSeaChain = PdtSea_L.FTSeaChain AND PdtSea_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtFabric_L PdtFab_L WITH(NOLOCK) ON FhnBar.FTFabCode = PdtFab_L.FTFabCode AND PdtFab_L.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT OUTER JOIN TCNMPdtColor_L PdtColor_L WITH(NOLOCK) ON FhnBar.FTClrCode = PdtColor_L.FTClrCode AND PdtColor_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT OUTER JOIN TCNMPdtSize_L PdtSize_L WITH(NOLOCK) ON FhnBar.FTPszCode = PdtSize_L.FTPszCode AND PdtSize_L.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + '''  '   
 SET @tSql +=  @tSqlIns 
 --SELECT  @tSql 
 EXECUTE(@tSql)
 ----STKME
 SET @tSql = ' INSERT INTO TRPTPdtStkCrdFhnTmp '
 SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
 SET @tSql +=' FTBchCode,FTBchName, FDStkDate, FTStkDocNo, FTWahCode,FTWahName, FTPdtCode,FTPdtName,'
 SET @tSql +=' FCStkQtyMonEnd,FCStkQtyIn,FCStkQtyOut,FCStkQtySaleDN,FCStkQtyCN,FCStkQtyAdj,FTBarCode,FTFhnRefCode,FTDepName,FTClsName,FTSeaName,FTPmoName,FTFabName,FTClrName,FTClrRmk,FTPszName'
 SET @tSql +=' )' 
 SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,' 
 SET @tSql +=' STK.FTBchCode,FTBchName,FDStfDate,FTStfDocNo,Stk.FTWahCode,Wah_L.FTWahName,Stk.FTPdtCode,Pdt_L.FTPdtName,' --FTStkType, 
 SET @tSql +=' CASE WHEN FTStfType = ''0'' THEN FCStfQty ELSE 0 END AS FCStkQtyMonEnd,'
 SET @tSql +=' CASE WHEN FTStfType = ''1'' THEN FCStfQty ELSE 0 END AS FCStkQtyIn,'
 SET @tSql +=' CASE WHEN FTStfType = ''2'' THEN FCStfQty ELSE 0 END AS FCStkQtyOut,'
 SET @tSql +=' CASE WHEN FTStfType = ''3'' THEN FCStfQty ELSE 0 END AS FCStkQtySaleDN,'
 SET @tSql +=' CASE WHEN FTStfType = ''4'' THEN FCStfQty ELSE 0 END AS FCStkQtyCN,'
 SET @tSql +=' CASE WHEN FTStfType = ''5'' THEN FCStfQty ELSE 0 END AS FCStkQtyAdj,'
 SET @tSql +=' FhnBar.FTBarCode,FhnBar.FTFhnRefCode,PDTDPL.FTDepName,PDTClSL.FTClsName,PdtSea_L.FTSeaName,PMOL.FTPmoName,PdtFab_L.FTFabName,PdtColor_L.FTClrName,PdtColor_L.FTClrRmk,PdtSize_L.FTPszName' 
 SET @tSql +=' FROM   TFHTPdtStkCrdMe Stk WITH(NOLOCK) LEFT JOIN' 
 SET @tSql +=' TCNMWaHouse_L Wah_L WITH(NOLOCK) ON Stk.FTWahCode = Wah_L.FTWahCode AND Stk.FTBchCode = Wah_L.FTBchCode AND Wah_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN' 
 SET @tSql +=' TCNMPdt_L Pdt_L WITH(NOLOCK) ON Stk.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH(NOLOCK) ON Stk.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode '
 SET @tSql +=' LEFT JOIN TCNMPdtModel_L PMOL WITH (NOLOCK)  ON Pdt.FTPmoCode = PMOL.FTPmoCode AND PMOL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN TFHMPdtFhn FHN WITH (NOLOCK) ON Stk.FTPdtCode = FHN.FTPdtCode '  
 SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L PDTDPL WITH(NOLOCK) ON FHN.FTDepCode = PDTDPL.FTDepCode AND PDTDPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
 SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L PDTClSL WITH(NOLOCK) ON FHN.FTClsCode = PDTClSL.FTClsCode AND PDTClSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition by PCS.FTPdtCode,PCS.FTFhnRefCode ORDER BY PCS.FTPdtCode,PCS.FTFhnRefCode,PCS.FNFhnSeq DESC) AS FNRowID,PCS.FTPdtCode,PCS.FTFhnRefCode,PBAR.FTBarCode,PCS.FTSeaCode,PCS.FTFabCode,PCS.FTClrCode,PCS.FTPszCode FROM  TFHMPdtColorSize PCS WITH (NOLOCK) '
 SET @tSql +=' LEFT JOIN (SELECT ROW_NUMBER () OVER (Partition BY BA.FTPdtCode,BA.FTFhnRefCode,BA.FNBarRefSeq ORDER BY BA.FNBarRefSeq DESC) AS FNRowID, BA.FTPdtCode,BA.FTBarCode,BA.FNBarRefSeq,BA.FTFhnRefCode,BA.FTPunCode FROM TCNMPdtBar BA WITH (NOLOCK) WHERE BA.FTBarStaUse = 1'
 SET @tSql +=' ) PBAR ON PCS.FTPdtCode = PBAR.FTPdtCode AND PCS.FTFhnRefCode = PBAR.FTFhnRefCode AND PCS.FNFhnSeq = PBAR.FNBarRefSeq AND PBAR.FNRowID = 1'
 SET @tSql +=' ) FhnBar ON Stk.FTPdtCode = FhnBar.FTPdtCode AND Stk.FTFhnRefCode = FhnBar.FTFhnRefCode AND  FhnBar.FNRowID=1'
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason PdtSea WITH(NOLOCK) ON FhnBar.FTSeaCode = PdtSea.FTSeaCode '
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtSeason_L PdtSea_L WITH(NOLOCK) ON PdtSea.FTSeaCode = PdtSea_L.FTSeaCode AND PdtSea.FTSeaChain = PdtSea_L.FTSeaChain AND PdtSea_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT OUTER JOIN TFHMPdtFabric_L PdtFab_L WITH(NOLOCK) ON FhnBar.FTFabCode = PdtFab_L.FTFabCode AND PdtFab_L.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT OUTER JOIN TCNMPdtColor_L PdtColor_L WITH(NOLOCK) ON FhnBar.FTClrCode = PdtColor_L.FTClrCode AND PdtColor_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
 SET @tSql +=' LEFT OUTER JOIN TCNMPdtSize_L PdtSize_L WITH(NOLOCK) ON FhnBar.FTPszCode = PdtSize_L.FTPszCode AND PdtSize_L.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + '''  '   
 SET @tSql +=  @tSqlIns

 --SELECT  @tSql 
 EXECUTE(@tSql)
 RETURN SELECT * FROM TRPTPdtStkCrdFhnTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
 
END TRY
BEGIN CATCH 
 SET @FNResult= -1
 PRINT @tSql
END CATCH 

GO



IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCxStkReMonthEndByDoc')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_PRCxStkReMonthEndByDoc
GO
CREATE PROCEDURE [dbo].STP_PRCxStkReMonthEndByDoc
 @ptBchCode VARCHAR(5)
,@ptTblHD VARCHAR(30)
,@ptDocNo VARCHAR(30)
,@pdDate Datetime
,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,2), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,2),
   FCStkCostIn decimal(18,2),
   FCStkCostEx decimal(18,2)
   ) 
DECLARE @TTmpPdt TABLE
   ( 
   FTBchCode varchar(5), 
   FTPdtCode varchar(20), 
   FTWahCode varchar(5)
   ) 
DECLARE @dStkDate Datetime
DECLARE @tSql VARCHAR(MAX)
DECLARE @tSqlFhn VARCHAR(MAX)
-- 06.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	
DECLARE @TTmpPdtFhn TABLE
   ( 
   FTBchCode varchar(5), 
   FTPdtCode varchar(20),
   FTFhnRefCode varchar(50), 
   FTWahCode varchar(5)
   ) 
-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version			Date			User	Remark
05.01.00		04/03/2021		Em		create  
06.01.00		20/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00		02/08/2021		Em		เพิ่มใบรับโอนสาขา,ใบจ่ายโอนสาขา
----------------------------------------------------------------------*/
SET @tTrans = 'StkReME'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  
	
	SET @tSql = CASE @ptTblHD
		WHEN 'TAPTPiHD' THEN --เจ่าหนี้	ใบรับของ ใบซื้อ
			'SELECT HD.FTBchCode,DT.FTPdtCode,HD.FTWahCode 
			FROM TAPTPiHD HD with(nolock)
			INNER JOIN TAPTPiDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXphDocNo = '''+ @ptDocNo +''''
		WHEN 'TAPTPcHD' THEN--เจ่าหนี้	ใบลดหนี้ มีสินค้า
			'SELECT HD.FTBchCode,DT.FTPdtCode,HD.FTWahCode 
			FROM TAPTPcHD HD with(nolock)
			INNER JOIN TAPTPcDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXphDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTwxHD' THEN --คลัง	ใบโอนสินค้าระหว่างคลัง
			'SELECT HD.FTBchCode,DT.FTPdtCode,HD.FTXthWhFrm AS FTWahCode
			FROM TCNTPdtTwxHD HD with(nolock)
			INNER JOIN TCNTPdtTwxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +'''
			UNION
			SELECT HD.FTBchCode,DT.FTPdtCode,HD.FTXthWhTo AS FTWahCode
			FROM TCNTPdtTwxHD HD with(nolock)
			INNER JOIN TCNTPdtTwxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TVDTPdtTwxHD' THEN
			'SELECT HD.FTBchCode,DT.FTPdtCode,DT.FTXthWhFrm AS FTWahCode
			FROM TVDTPdtTwxHD HD with(nolock)
			INNER JOIN TVDTPdtTwxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +'''
			UNION
			SELECT HD.FTBchCode,DT.FTPdtCode,DT.FTXthWhTo AS FTWahCode
			FROM TVDTPdtTwxHD HD with(nolock)
			INNER JOIN TVDTPdtTwxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTwoHD' THEN--คลัง	ใบจ่ายโอน-Intran
			'SELECT HD.FTBchCode,DT.FTPdtCode,HD.FTXthWhFrm AS FTWahCode
			FROM TCNTPdtTwoHD HD with(nolock)
			INNER JOIN TCNTPdtTwoDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTwiHD' THEN--คลัง	ใบรับโอน-Intran
			'SELECT HD.FTBchCode,DT.FTPdtCode,HD.FTXthWhTo AS FTWahCode
			FROM TCNTPdtTwiHD HD with(nolock)
			INNER JOIN TCNTPdtTwiDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtAdjStkHD' THEN--คลัง	ใบตรวจนับสต๊อก
			'SELECT HD.FTAjhBchTo AS FTBchCode,DT.FTPdtCode,HD.FTAjhWhTo AS FTWahCode
			FROM TCNTPdtAdjStkHD HD with(nolock)
			INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTAjhDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTbxHD' THEN--สาขา	ใบโอนสินค้าระหว่่างสาขา
			'SELECT HD.FTXthBchTo AS FTBchCode,DT.FTPdtCode,HD.FTXthWhTo AS FTWahCode
			FROM TCNTPdtTbxHD HD with(nolock)
			INNER JOIN TCNTPdtTbxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +'''
			UNION
			SELECT HD.FTXthBchFrm AS FTBchCode,DT.FTPdtCode,HD.FTXthWhFrm AS FTWahCode
			FROM TCNTPdtTbxHD HD with(nolock)
			INNER JOIN TCNTPdtTbxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTboHD' THEN--สาขา	ใบจ่ายโอน-Intran
			'SELECT HD.FTXthBchFrm AS FTBchCode,DT.FTPdtCode,HD.FTXthWhFrm AS FTWahCode
			FROM TCNTPdtTboHD HD with(nolock)
			INNER JOIN TCNTPdtTboDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTbiHD' THEN--สาขา	ใบรับโอน-Intran
			'SELECT HD.FTXthBchTo AS FTBchCode,DT.FTPdtCode,HD.FTXthWhTo AS FTWahCode
			FROM TCNTPdtTbiHD HD with(nolock)
			INNER JOIN TCNTPdtTbiDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TPSTSalHD' THEN --ขาย,คืน
			'SELECT HD.FTBchCode,DT.FTPdtCode,HD.FTWahCode 
			FROM TPSTSalHD HD with(nolock)
			INNER JOIN TPSTSalDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXshDocNo = '''+ @ptDocNo +''''
		WHEN 'TVDTSalHD' THEN
			'SELECT DISTINCT HD.FTBchCode,DT.FTPdtCode,HD.FTWahCode 
			FROM TVDTSalHD HD with(nolock)
			INNER JOIN TVDTSalDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXshDocNo = '''+ @ptDocNo +''''
	END

	IF @tSql <> '' BEGIN
		INSERT INTO @TTmpPdt
		EXEC sp_sqlexec @tSql
	END

	--ลบรายการคลังที่ไม่ตัดสต๊อก
	DELETE @TTmpPdt
	FROM @TTmpPdt PDT
	INNER JOIN TCNMWaHouse WAH ON WAH.FTBchCode = PDT.FTBchCode AND WAH.FTWahCode = PDT.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') <> '2'

	IF EXISTS(SELECT * FROM @TTmpPdt) BEGIN
		SET @dStkDate = CONVERT(Datetime, CONVERT(VARCHAR(8),@pdDate,121) + '01')

		--Delete Old data
		IF EXISTS(SELECT STK.FTBchCode FROM TCNTPdtStkCrdME STK with(nolock)
		INNER JOIN @TTmpPdt PDT ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode
		WHERE CONVERT(VARCHAR(6),FDStkDate,112) = CONVERT(VARCHAR(6),@dStkDate,112)) BEGIN
			DELETE TCNTPdtStkCrdME WITH(ROWLOCK)
			FROM TCNTPdtStkCrdME STK
			INNER JOIN @TTmpPdt PDT ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode
			WHERE CONVERT(VARCHAR(6),FDStkDate,112) = CONVERT(VARCHAR(6),@dStkDate,112)
		END

		INSERT INTO @TTmpPrcStk(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
		SELECT DISTINCT PDT.FTBchCode AS FTBchCode, @dStkDate AS FDStkDate, 'ME' + CONVERT(VARCHAR(6),@pdDate,112) AS FTStkDocNo ,	-- 04.01.00 --
		STK.FTWahCode AS FTWahCode,PDT.FTPdtCode,0 AS FTStkType,
			ISNULL(STK.FCStkQty,0)+ ISNULL(SCE.FCStkQty,0) AS FCStkQty,	-- 4. --
		0 AS FCStkSetPrice,
		0 AS FCStkCostIn,
		0 AS FCStkCostEx
		FROM (SELECT DISTINCT STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode 
				FROM TCNTPdtStkCrd STK WITH(NOLOCK)
				INNER JOIN @TTmpPdt PDT ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode
				WHERE CONVERT(VARCHAR(6),FDStkDate,112) <= CONVERT(VARCHAR(6),@pdDate,112)) PDT
		LEFT JOIN (SELECT STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode ,
						ISNULL(SUM(CASE FTStkType WHEN 0 THEN FCStkQty
							WHEN 1 THEN FCStkQty
							WHEN 2 THEN FCStkQty * (-1)
							WHEN 3 THEN FCStkQty * (-1)
							WHEN 4 THEN FCStkQty
							WHEN 5 THEN FCStkQty END
						),0)  AS FCStkQty
					FROM TCNTPdtStkCrd STK WITH(NOLOCK)
					INNER JOIN @TTmpPdt PDT ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode
					WHERE CONVERT(VARCHAR(6),FDStkDate,112) = CONVERT(VARCHAR(6),DATEADD(Month,-1,@pdDate),112)
					GROUP BY STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode) STK ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode
		LEFT JOIN TCNTPdtStkCrdME SCE WITH(NOLOCK) ON SCE.FTPdtCode = PDT.FTPdtCode AND SCE.FTBchCode = PDT.FTBchCode AND SCE.FTWahCode = PDT.FTWahCode
			AND CONVERT(VARCHAR(6),SCE.FDStkDate,112) = CONVERT(VARCHAR(6),DATEADD(Month,-1,@pdDate),112)

		IF EXISTS(SELECT * FROM @TTmpPrcStk) BEGIN
			--update cost
			UPDATE @TTmpPrcStk
			SET FCStkCostIn = STK.FCStkCostIn
			,FCStkCostEx = STK.FCStkCostEx
			FROM @TTmpPrcStk TMP
			INNER JOIN TCNTPdtStkCrd STK WITH(NOLOCK) ON TMP.FTBchCode = STK.FTBchCode AND TMP.FTWahCode = STK.FTWahCode AND TMP.FTPdtCode = STK.FTPdtCode
			INNER JOIN (SELECT STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode,MAX(STK.FDCreateOn) AS FDCreateOn
						FROM TCNTPdtStkCrd STK WITH(NOLOCK)
						INNER JOIN @TTmpPdt PDT ON STK.FTBchCode = PDT.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode
						WHERE CONVERT(VARCHAR(6),STK.FDStkDate,112) = CONVERT(VARCHAR(6),DATEADD(Month,-1,@pdDate),112)
						GROUP BY STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode
						) STK2 ON STK2.FTBchCode = STK.FTBchCode AND STK2.FTWahCode = STK.FTWahCode AND STK2.FTPdtCode = STK.FTPdtCode AND STK2.FDCreateOn = STK.FDCreateOn

		
			--Insert Data to stkcrdME
			INSERT INTO TCNTPdtStkCrdME(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn,'System' AS FTCreateBy
			FROM @TTmpPrcStk
		END
	END
	
	-- 06.01.00 --
	SET @tSqlFhn = CASE @ptTblHD
		WHEN 'TAPTPiHD' THEN --เจ่าหนี้	ใบรับของ ใบซื้อ
			'SELECT HD.FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTWahCode 
			FROM TAPTPiHD HD with(nolock)
			INNER JOIN TAPTPiDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo 
			INNER JOIN TAPTPiDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXphDocNo = HD.FTXphDocNo AND DT.FNXpdSeqNo = DTF.FNXpdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXphDocNo = '''+ @ptDocNo +''''
		--WHEN 'TAPTPcHD' THEN--เจ่าหนี้	ใบลดหนี้ มีสินค้า
		--	'SELECT HD.FTBchCode,DT.FTPdtCode,HD.FTWahCode 
		--	FROM TAPTPcHD HD with(nolock)
		--	INNER JOIN TAPTPcDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo 
		--	INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
		--	WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXphDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTwxHD' THEN --คลัง	ใบโอนสินค้าระหว่างคลัง
			'SELECT HD.FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTXthWhFrm AS FTWahCode
			FROM TCNTPdtTwxHD HD with(nolock)
			INNER JOIN TCNTPdtTwxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNTPdtTwxDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXthDocNo = HD.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +'''
			UNION
			SELECT HD.FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTXthWhTo AS FTWahCode
			FROM TCNTPdtTwxHD HD with(nolock)
			INNER JOIN TCNTPdtTwxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNTPdtTwxDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXthDocNo = HD.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		--WHEN 'TVDTPdtTwxHD' THEN
		--	'SELECT HD.FTBchCode,DT.FTPdtCode,DT.FTXthWhFrm AS FTWahCode
		--	FROM TVDTPdtTwxHD HD with(nolock)
		--	INNER JOIN TVDTPdtTwxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
		--	INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
		--	WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +'''
		--	UNION
		--	SELECT HD.FTBchCode,DT.FTPdtCode,DT.FTXthWhTo AS FTWahCode
		--	FROM TVDTPdtTwxHD HD with(nolock)
		--	INNER JOIN TVDTPdtTwxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
		--	INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
		--	WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTwoHD' THEN--คลัง	ใบจ่ายโอน-Intran
			'SELECT HD.FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTXthWhFrm AS FTWahCode
			FROM TCNTPdtTwoHD HD with(nolock)
			INNER JOIN TCNTPdtTwoDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNTPdtTwoDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXthDocNo = HD.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTwiHD' THEN--คลัง	ใบรับโอน-Intran
			'SELECT HD.FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTXthWhTo AS FTWahCode
			FROM TCNTPdtTwiHD HD with(nolock)
			INNER JOIN TCNTPdtTwiDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNTPdtTwiDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXthDocNo = HD.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtAdjStkHD' THEN--คลัง	ใบตรวจนับสต๊อก
			'SELECT HD.FTAjhBchTo AS FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTAjhWhTo AS FTWahCode
			FROM TCNTPdtAdjStkHD HD with(nolock)
			INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo 
			INNER JOIN TCNTPdtAdjStkDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTAjhDocNo = HD.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTAjhDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTbxHD' THEN--สาขา	ใบโอนสินค้าระหว่่างสาขา
			'SELECT HD.FTXthBchTo AS FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTXthWhTo AS FTWahCode
			FROM TCNTPdtTbxHD HD with(nolock)
			INNER JOIN TCNTPdtTbxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNTPdtTbxDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXthDocNo = HD.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +'''
			UNION
			SELECT HD.FTXthBchFrm AS FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTXthWhFrm AS FTWahCode
			FROM TCNTPdtTbxHD HD with(nolock)
			INNER JOIN TCNTPdtTbxDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNTPdtTbxDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXthDocNo = HD.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTboHD' THEN--สาขา	ใบจ่ายโอน-Intran		-- 06.02.00 --
			'SELECT HD.FTXthBchFrm AS FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTXthWhFrm AS FTWahCode
			FROM TCNTPdtTboHD HD with(nolock)
			INNER JOIN TCNTPdtTboDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNTPdtTboDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXthDocNo = HD.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TCNTPdtTbiHD' THEN--สาขา	ใบรับโอน-Intran	-- 06.02.00 --
			'SELECT HD.FTXthBchTo AS FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTXthWhTo AS FTWahCode
			FROM TCNTPdtTbiHD HD with(nolock)
			INNER JOIN TCNTPdtTbiDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo 
			INNER JOIN TCNTPdtTbiDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXthDocNo = HD.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXthDocNo = '''+ @ptDocNo +''''
		WHEN 'TPSTSalHD' THEN --ขาย,คืน
			'SELECT HD.FTBchCode,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTWahCode 
			FROM TPSTSalHD HD with(nolock)
			INNER JOIN TPSTSalDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
			INNER JOIN TPSTSalDTFhn DTF with(nolock) ON DTF.FTBchCode = HD.FTBchCode AND DTF.FTXshDocNo = HD.FTXshDocNo AND DT.FNXsdSeqNo = DTF.FNXsdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
			WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXshDocNo = '''+ @ptDocNo +'''
			AND ISNULL(DT.FTXsdStaPdt,'')NOT IN(''4'',''5'')'
		--WHEN 'TVDTSalHD' THEN
		--	'SELECT DISTINCT HD.FTBchCode,DT.FTPdtCode,HD.FTWahCode 
		--	FROM TVDTSalHD HD with(nolock)
		--	INNER JOIN TVDTSalDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
		--	INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = ''1'' AND PDT.FTPdtStaActive = ''1''
		--	WHERE HD.FTBchCode = ''' + @ptBchCode + ''' AND HD.FTXshDocNo = '''+ @ptDocNo +''''
	END
	
	IF @tSqlFhn <> '' BEGIN
		INSERT INTO @TTmpPdtFhn
		EXEC sp_sqlexec @tSqlFhn
	END

	--ลบรายการคลังที่ไม่ตัดสต๊อก
	DELETE @TTmpPdtFhn
	FROM @TTmpPdtFhn PDT
	INNER JOIN TCNMWaHouse WAH ON WAH.FTBchCode = PDT.FTBchCode AND WAH.FTWahCode = PDT.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') <> '2'

	IF EXISTS(SELECT * FROM @TTmpPdtFhn) BEGIN
		SET @dStkDate = CONVERT(Datetime, CONVERT(VARCHAR(8),@pdDate,121) + '01')

		--Delete Old data
		IF EXISTS(SELECT STK.FTBchCode FROM TFHTPdtStkCrdME STK with(nolock)
		INNER JOIN @TTmpPdtFhn PDT ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode
		WHERE CONVERT(VARCHAR(6),FDStfDate,112) = CONVERT(VARCHAR(6),@dStkDate,112)) BEGIN
			DELETE TFHTPdtStkCrdME WITH(ROWLOCK)
			FROM TFHTPdtStkCrdME STK
			INNER JOIN @TTmpPdtFhn PDT ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode AND PDT.FTFhnRefCode = STK.FTFhnRefCode
			WHERE CONVERT(VARCHAR(6),FDStfDate,112) = CONVERT(VARCHAR(6),@dStkDate,112)
		END

		INSERT INTO @TTmpPrcStkFhn(FTBchCode,FDStfDate,FTStfDocNo,FTWahCode,FTPdtCode,FTFhnRefCode,FTStfType,FCStfQty,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
		SELECT DISTINCT PDT.FTBchCode AS FTBchCode, @dStkDate AS FDStkDate, 'ME' + CONVERT(VARCHAR(6),@pdDate,112) AS FTStkDocNo ,	-- 04.01.00 --
		STK.FTWahCode AS FTWahCode,PDT.FTPdtCode,PDT.FTFhnRefCode,0 AS FTStkType,
			ISNULL(STK.FCStkQty,0)+ ISNULL(SCE.FCStfQty,0) AS FCStkQty,	-- 4. --
		0 AS FCStkSetPrice,
		0 AS FCStkCostIn,
		0 AS FCStkCostEx
		FROM (SELECT DISTINCT STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode,STK.FTFhnRefCode 
				FROM TFHTPdtStkCrd STK WITH(NOLOCK)
				INNER JOIN @TTmpPdtFhn PDT ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode AND PDT.FTFhnRefCode = STK.FTFhnRefCode
				WHERE CONVERT(VARCHAR(6),FDStfDate,112) <= CONVERT(VARCHAR(6),@pdDate,112)) PDT
		LEFT JOIN (SELECT STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode,STK.FTFhnRefCode,
						ISNULL(SUM(CASE FTStfType WHEN 0 THEN FCStfQty
							WHEN 1 THEN FCStfQty
							WHEN 2 THEN FCStfQty * (-1)
							WHEN 3 THEN FCStfQty * (-1)
							WHEN 4 THEN FCStfQty
							WHEN 5 THEN FCStfQty END
						),0)  AS FCStkQty
					FROM TFHTPdtStkCrd STK WITH(NOLOCK)
					INNER JOIN @TTmpPdtFhn PDT ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode AND PDT.FTFhnRefCode = STK.FTFhnRefCode
					WHERE CONVERT(VARCHAR(6),FDStfDate,112) = CONVERT(VARCHAR(6),DATEADD(Month,-1,@pdDate),112)
					GROUP BY STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode,STK.FTFhnRefCode) STK ON PDT.FTBchCode = STK.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode AND PDT.FTFhnRefCode = STK.FTFhnRefCode
		LEFT JOIN TFHTPdtStkCrdME SCE WITH(NOLOCK) ON SCE.FTPdtCode = PDT.FTPdtCode AND SCE.FTFhnRefCode = PDT.FTFhnRefCode AND SCE.FTBchCode = PDT.FTBchCode AND SCE.FTWahCode = PDT.FTWahCode
			AND CONVERT(VARCHAR(6),SCE.FDStfDate,112) = CONVERT(VARCHAR(6),DATEADD(Month,-1,@pdDate),112)

		IF EXISTS(SELECT * FROM @TTmpPrcStkFhn) BEGIN
			--update cost
			UPDATE @TTmpPrcStkFhn
			SET FCStfCostIn = STK.FCStfCostIn
			,FCStfCostEx = STK.FCStfCostEx
			FROM @TTmpPrcStkFhn TMP
			INNER JOIN TFHTPdtStkCrd STK WITH(NOLOCK) ON TMP.FTBchCode = STK.FTBchCode AND TMP.FTWahCode = STK.FTWahCode AND TMP.FTPdtCode = STK.FTPdtCode AND TMP.FTFhnRefCode = STK.FTFhnRefCode
			INNER JOIN (SELECT STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode,STK.FTFhnRefCode,MAX(STK.FDCreateOn) AS FDCreateOn
						FROM TFHTPdtStkCrd STK WITH(NOLOCK)
						INNER JOIN @TTmpPdtFhn PDT ON STK.FTBchCode = PDT.FTBchCode AND PDT.FTWahCode = STK.FTWahCode AND PDT.FTPdtCode = STK.FTPdtCode AND PDT.FTFhnRefCode = STK.FTFhnRefCode
						WHERE CONVERT(VARCHAR(6),STK.FDStfDate,112) = CONVERT(VARCHAR(6),DATEADD(Month,-1,@pdDate),112)
						GROUP BY STK.FTBchCode,STK.FTWahCode,STK.FTPdtCode,STK.FTFhnRefCode
						) STK2 ON STK2.FTBchCode = STK.FTBchCode AND STK2.FTWahCode = STK.FTWahCode AND STK2.FTPdtCode = STK.FTPdtCode AND STK2.FTFhnRefCode = STK.FTFhnRefCode AND STK2.FDCreateOn = STK.FDCreateOn

			--Insert Data to stkcrdME
			INSERT INTO TFHTPdtStkCrdME(FTBchCode,FDStfDate,FTStfDocNo,FTWahCode,FTPdtCode,FTFhnRefCode,FTStfType,FCStfQty,FCStfSetPrice,FCStfCostIn,FCStfCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStfDate,FTStfDocNo,FTWahCode,FTPdtCode,FTFhnRefCode,FTStfType,FCStfQty,FCStfSetPrice,FCStfCostIn,FCStfCostEx,
			GETDATE() AS FDCreateOn,'System' AS FTCreateBy
			FROM @TTmpPrcStkFhn
		END
	END
	-- 06.01.00 --
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH
GO






IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxSpcSalByDT')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].SP_RPTxSpcSalByDT
GO
CREATE PROCEDURE [dbo].[SP_RPTxSpcSalByDT] 
--ALTER PROCEDURE [dbo].[SP_RPTxDailySaleByPdt1001002] 
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--สาขา
	@ptBchL Varchar(8000), --กรณี Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptPdtCodeF Varchar(20),
	@ptPdtCodeT Varchar(20),
	@ptPdtPbnF Varchar(30),
	@ptPdtPbnT Varchar(30),
	@ptPdtTypeF Varchar(5),
	@ptPdtTypeT Varchar(5),

	@ptCstCodeF Varchar(50),
	@ptCstCodeT Varchar(50),

--รหัสฤดูกาล
	@ptSeaF Varchar(20),@ptSeaT Varchar(20),

--รหัสเนื้อผ้า
	@ptFabF Varchar(20),@ptFabT Varchar(20),

--รหัสสี
	@ptClrF Varchar(20),@ptClrT Varchar(20),

--รหัสไซต์
	@ptPszF Varchar(20),@ptPszT Varchar(20),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 10/07/2019
-- Temp name  TRPTSalRCTmp
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
-- @ptShpF จากร้านค้า
-- @ptShpT ถึงร้านค้า
-- @ptPdtCodeF จากสินค้า
-- @ptPdtCodeT ถึงสินค้า
-- @ptPdtChanF จากกลุ่มสินค้า
-- @ptPdtChanT ถึงกลุ่มสินค้า
-- @ptPdtTypeF จากประเภทสินค้า
-- @ptPdtTypeT ถึงประเภท

-- @ptDocDateF จากวันที่
-- @ptDocDateT ถึงวันที่
-- @FNResult


--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSql2 VARCHAR(8000)
	DECLARE @tSql3 VARCHAR(8000)
	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tPdtCodeF Varchar(20)
	DECLARE @tPdtCodeT Varchar(20)
	DECLARE @tPdtPbnF Varchar(30)
	DECLARE @tPdtPbnT Varchar(30)
	DECLARE @tPdtTypeF Varchar(5)
	DECLARE @tPdtTypeT Varchar(5)

	DECLARE @tCstCodeF Varchar(50)
	DECLARE @tCstCodeT Varchar(50)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า
	--DECLARE @tCstF Varchar(20)
	--DECLARE @tCstT Varchar(20)


	
	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT

	--Pos
	SET @tPosF  = @ptPosF 
	SET @tPosT  = @ptPosT

	SET @tPdtCodeF  = @ptPdtCodeF 
	SET @tPdtCodeT = @ptPdtCodeT
	SET @tPdtPbnF  = @ptPdtPbnF
	SET @tPdtPbnT  = @ptPdtPbnT 
	SET @tPdtTypeF = @ptPdtTypeF
	SET @tPdtTypeT = @ptPdtTypeT

	SET @tCstCodeF = @ptCstCodeF
	SET @tCstCodeT = @ptCstCodeT

	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult= 0

	SET @tDocDateF = CONVERT(VARCHAR(10),@tDocDateF,121)
	SET @tDocDateT = CONVERT(VARCHAR(10),@tDocDateT,121)

	IF @nLngID = null
	BEGIN
		SET @nLngID = 1
	END	
	--Set ค่าให้ Paraleter กรณี T เป็นค่าว่างหรือ null


	IF @ptBchL = null
	BEGIN
		SET @ptBchL = ''
	END

	IF @tBchF = null
	BEGIN
		SET @tBchF = ''
	END
	IF @tBchT = null OR @tBchT = ''
	BEGIN
		SET @tBchT = @tBchF
	END


	IF @ptPosL =null
	BEGIN
		SET @ptPosL = ''
	END

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END

	IF @tPdtCodeF = null
	BEGIN
		SET @tPdtCodeF = ''
	END 
	IF @tPdtCodeT = null OR @tPdtCodeT =''
	BEGIN
		SET @tPdtCodeT = @tPdtCodeF
	END 


	IF @tPdtTypeF = null
	BEGIN
		SET @tPdtTypeF = ''
	END 
	IF @tPdtTypeT = null OR @tPdtTypeT =''
	BEGIN
		SET @tPdtTypeT = @tPdtTypeF
	END 

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	SET @tSql1 =   ' WHERE 1=1 AND EXISTS (SELECT FTBchCode,FTXshDocNo FROM TPSTSalRC WHERE DT.FTBchCode = FTBchCode AND DT.FTXshDocNo = FTXshDocNo) AND FTXshStaDoc = ''1'' AND DT.FTXsdStaPdt <> ''4'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND DT.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSql1 +=' AND DT.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
		END		
	END

	IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	END

	IF (@tPdtPbnF <> '' AND @tPdtPbnT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPbnCode BETWEEN ''' + @tPdtPbnF + ''' AND ''' + @tPdtPbnT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tCstCodeF <> '' AND @tCstCodeT <> '')
	BEGIN
		SET @tSql1 +=' AND HD.FTCstCode BETWEEN ''' + @tCstCodeF + ''' AND ''' + @tCstCodeT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END


	SET @tSql3 = ''

	IF (@ptSeaF<> '')
	BEGIN
		SET @tSql3 +=' AND Clr.FTSeaCode BETWEEN ''' + @ptSeaF + ''' AND ''' + @ptSeaT + ''''
	END

	IF (@ptFabF<> '')
	BEGIN
		SET @tSql3 +=' AND Clr.FTFabCode BETWEEN ''' + @ptFabF + ''' AND ''' + @ptFabT + ''''
	END

	IF (@ptClrF<> '')
	BEGIN
		SET @tSql3 +=' AND Clr.FTClrCode BETWEEN ''' + @ptClrF + ''' AND ''' + @ptClrT + ''''
	END

	IF (@ptPszF<> '')
	BEGIN
		SET @tSql3 +=' AND Clr.FTPszCode BETWEEN ''' + @ptPszF + ''' AND ''' + @ptPszT + ''''
	END


	DELETE FROM TRPTSpcSalByDTTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  = ' INSERT INTO TRPTSpcSalByDTTmp '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FTPbnName,FDXshDocDate,FTXshDocNo,FTCstName,FTCstTel,FTBchCode,FTBchName,FTUsrName,FCXsdQty,FTPdtCode,FTXsdPdtName,FTPunName,FTFhnRefCode,FTClrName,FTPszName,FTFhnGender,FTSeaName,FTChnName,FNXshAge,FTXshNation,FTDepName,FTCmlName,FTClsName,FCXsdSetPrice,FCXsdGrossSales,FCXsdGrossSalesExVat,FCXsdNetSales,FCXsdNetSalesEx,FTXddDisChgTxt,FCXsdAmtB4DisChg,FCXsdDis,FCXsdVat,FCXsdNet,FCXsdNetAfHD,FTCstCode,FNXshSex,FTXshRmk'
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' PBN_L.FTPbnName,HD.FDXshDocDate,DT.FTXshDocNo,CST_L.FTCstName,CST.FTCstTel,HD.FTBchCode,Bch_L.FTBchName,SALM.FTUsrName,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(DTFhn.FCXsdQty, 0) ELSE ISNULL(DTFhn.FCXsdQty, 0) *- 1 END FCXsdQty,'
	SET @tSql +=' DT.FTPdtCode,DT.FTXsdPdtName,ISNULL(Pun_L.FTPunName, '''') AS FTPunName,'
  SET @tSql +=' DTFhn.FTFhnRefCode,DTFhn.FTClrName,DTFhn.FTPszName,CASE WHEN PDTFHN.FTFhnGender=1 THEN ''MEN'' WHEN PDTFHN.FTFhnGender=2 THEN ''WOMEN'' WHEN PDTFHN.FTFhnGender=3 THEN ''UNISEX'' ELSE '''' END AS FTFhnGender,'
	SET @tSql +=' DTFhn.FTSeaName,CHN.FTChnName,HDTAG.FNXshAge,NAT.FTNatName,DEPL.FTDepName,CMLL.FTCmlName,CLSL.FTClsName,'
  SET @tSql +=' ISNULL(DT.FCXsdSetPrice, 0) AS FCXsdSetPrice,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(DT.FCXsdSetPrice, 0) * ISNULL(DTFhn.FCXsdQty, 0)  ELSE (ISNULL(DT.FCXsdSetPrice, 0) * ISNULL(DTFhn.FCXsdQty, 0))  *- 1 END AS FCXsdGrossSales,'
  SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN CASE WHEN HD.FTXshVATInOrEx = ''1'' THEN ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) - (CASE WHEN DT.FTXsdVatType = ''1'' THEN (ISNULL(((DT.FCXsdAmtB4DisChg / DT.FCXsdQty) * DTFhn.FCXsdQty),0)  * DT.FCXsdVatRate)/(100+DT.FCXsdVatRate) ELSE 0 END) ELSE ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) END ELSE (CASE WHEN HD.FTXshVATInOrEx = ''1'' THEN ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) - (CASE WHEN DT.FTXsdVatType = ''1'' THEN (ISNULL(((DT.FCXsdAmtB4DisChg / DT.FCXsdQty) * DTFhn.FCXsdQty),0)  * DT.FCXsdVatRate)/(100+DT.FCXsdVatRate) ELSE 0 END) ELSE ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) END) * - 1 END AS FCXsdGrossSalesExVat,'
  SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 END FCXsdNetSales,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) - ISNULL(((DT.FCXsdVat/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE (ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) - ISNULL(((DT.FCXsdVat/DT.FCXsdQty)*DTFhn.FCXsdQty), 0)) *- 1 END FCXsdNetSalesEx,'
	SET @tSql +=' ISNULL(DTDis.FTXddDisChgTxt,'''') AS FTXddDisChgTxt,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE (ISNULL(((DT.FCXsdAmtB4DisChg/DT.FCXsdQty)*DTFhn.FCXsdQty), 0)) *- 1 END AS FCXsdAmtB4DisChg,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DTDis.FCXddValue/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 ELSE (ISNULL(((DTDis.FCXddValue/DT.FCXsdQty)*DTFhn.FCXsdQty), 0)) END FCXsdDis,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdVat/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE ISNULL(((DT.FCXsdVat/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 END FCXsdVat,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdNet/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE ISNULL(((DT.FCXsdNet/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 END FCXsdNet,'
	SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) ELSE ISNULL(((DT.FCXsdNetAfHD/DT.FCXsdQty)*DTFhn.FCXsdQty), 0) *- 1 END FCXsdNetAfHD,'
  SET @tSql +=' HD.FTCstCode,CASE WHEN HDTAG.FNXshSex = ''1'' THEN ''MEN'' WHEN HDTAG.FNXshSex = ''2'' THEN ''WOMEN'' ELSE  ''-'' END FNXshSex,HD.FTXshRmk '
	SET @tSql +=' FROM TPSTSalDT DT WITH (NOLOCK)'
	SET @tSql +=' LEFT JOIN TFHMPdtFhn PDTFHN WITH (NOLOCK) ON DT.FTPdtCode = PDTFHN.FTPdtCode'
	SET @tSql +=' LEFT JOIN TFHMPdtF1Depart_L DEPL WITH (NOLOCK) ON PDTFHN.FTDepCode = DEPL.FTDepCode AND DEPL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN TFHMPdtF5ComLines_L CMLL WITH (NOLOCK) ON PDTFHN.FTCmlCode = CMLL.FTCmlCode AND CMLL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN TFHMPdtF2Class_L CLSL WITH (NOLOCK) ON PDTFHN.FTClsCode = CLSL.FTClsCode AND CLSL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN TPSTSalHDTag HDTAG WITH (NOLOCK) ON DT.FTBchCode = HDTAG.FTBchCode AND DT.FTXshDocNo = HDTAG.FTXshDocNo '
	SET @tSql +=' LEFT JOIN TPSTSalDTFhn DTFhn WITH (NOLOCK) ON DT.FTBchCode = DTFhn.FTBchCode AND DT.FTXshDocNo = DTFhn.FTXshDocNo AND DT.FNXsdSeqNo = DTFhn.FNXsdSeqNo  AND DTFhn.FNXsfSeqNo = 1 '
	
  SET @tSql2 ='  LEFT JOIN (SELECT DISTINCT ClrHfn.FTPdtCode,ClrHfn.FTFhnRefCode,ClrHfn.FTClrCode ,ClrHfn.FDFhnStart,ClrHfn.FTFabCode, ClrHfn.FTSeaCode,ClrHfn.FTPszCode,ClrHfn.FCFhnCostStd ,ClrHfn.FCFhnCostOth FROM'
  SET @tSql2 +='(SELECT DISTINCT Clr.FTPdtCode,Clr.FTFhnRefCode,MAX(Clr.FNFhnSeq) AS FNFhnSeq FROM TFHMPdtColorSize Clr WHERE 1=1 '
  SET @tSql2 += @tSql3
  SET @tSql2 +=' GROUP BY Clr.FTPdtCode,Clr.FTFhnRefCode ) ClrMas'
  SET @tSql2 +=' INNER JOIN TFHMPdtColorSize ClrHfn WITH (NOLOCK) ON ClrMas.FTPdtCode = ClrHfn.FTPdtCode AND ClrMas.FTFhnRefCode = ClrHfn.FTFhnRefCode AND ClrMas.FNFhnSeq = ClrHfn.FNFhnSeq) Clr  ON DTFhn.FTPdtCode =  Clr.FTPdtCode AND DTFhn.FTFhnRefCode = Clr.FTFhnRefCode'

  SET @tSql2 +=' INNER JOIN TPSTSalHD HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo' 
  SET @tSql2 +=' LEFT JOIN TCNMChannel_L CHN WITH (NOLOCK) ON HD.FTChnCode = CHN.FTChnCode AND CHN.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''	'
  SET @tSql2 +=' LEFT JOIN (SELECT A.FTBchCode,A.FTXshDocNo,A.FNXsdSeqNo, STUFF((SELECT '', '' + B.FTXddDisChgTxt FROM TPSTSalDTDis B WHERE ISNULL(B.FTBchCode, '''') = ISNULL(A.FTBchCode, '''') AND  ISNULL(B.FTXshDocNo, '''') = ISNULL(A.FTXshDocNo, '''') AND  ISNULL(B.FNXsdSeqNo, '''') = ISNULL(A.FNXsdSeqNo, '''') ORDER BY B.FTBchCode ,B.FTXshDocNo,B.FNXsdSeqNo FOR XML PATH('''')), 1, 2, '''' ) AS FTXddDisChgTxt, SUM (CASE WHEN FTXddDisChgType = 3 OR FTXddDisChgType = 4 THEN ISNULL(A.FCXddValue, 0) ELSE ISNULL(A.FCXddValue, 0) *- 1 END) AS FCXddValue FROM TPSTSalDTDis A WITH (NOLOCK) GROUP BY A.FTBchCode,A.FTXshDocNo,A.FNXsdSeqNo ) AS DTDis ON DT.FTBchCode = DTDis.FTBchCode AND DT.FTXshDocNo = DTDis.FTXshDocNo AND DT.FNXsdSeqNo = DTDis.FNXsdSeqNo'
	SET @tSql2 +=' LEFT JOIN TCNMPdt Pdt WITH (NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode'
	SET @tSql2 +=' LEFT JOIN TCNMPdt_L Pdt_L WITH (NOLOCK) ON DT.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMPdtUnit_L Pun_L WITH (NOLOCK) ON DT.FTPunCode = Pun_L.FTPunCode AND Pun_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMBranch_L Bch_L WITH (NOLOCK) ON HD.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMCst CST WITH (NOLOCK) ON HD.FTCstCode = CST.FTCstCode'
	SET @tSql2 +=' LEFT JOIN TCNMCst_L CST_L WITH (NOLOCK) ON CST.FTCstCode = CST_L.FTCstCode AND CST_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMPdtBrand_L PBN_L WITH (NOLOCK) ON Pdt.FTPbnCode = PBN_L.FTPbnCode AND PBN_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN TCNMUser_L SALM WITH (NOLOCK) ON HD.FTUsrCode = SALM.FTUsrCode AND SALM.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 +=' LEFT JOIN  TCNMNation_L NAT WITH (NOLOCK) ON HDTAG.FTXshNation = NAT.FTNatCode AND NAT.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql2 += @tSql1	
	SET @tSql2 += @tSql3		

  --SELECT @tSql+@tSql2
	EXECUTE(@tSql+@tSql2)

	RETURN SELECT * FROM TRPTSpcSalByDTTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	

GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxAdjustStockPrc')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxAdjustStockPrc
GO
CREATE PROCEDURE [dbo].STP_DOCxAdjustStockPrc
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tWahType varchar(1) -- 4. --
DECLARE @tAdjSeqChk varchar(1) -- 4.--
DECLARE @tStaPrcStkTo varchar(1)	-- 04.04.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	13/06/2019		Em		create  
00.02.00	03/07/2019		Em		แก้ไขความกว้างฟิลด์ FTBchCode จาก 3 เป็น 5
00.03.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร
00.04.00	22/07/2019		Em		เพิ่มการปรับสต๊อก Vending
00.05.00	31/07/2019		Em		ปรับปรุงแก้ไข
00.06.00	01/08/2019		Em		เพิ่มการตรวจนับสินค้าทั่วไป
03.01.00	27/03/2020		Em		ปรับปรุงแก้ไข
03.02.00	28/03/2020		Em		แก้ไขให้ sum ยอดสต๊อกตามสินค้า
03.03.00	30/03/2020		Em		แก้ไขการ Sum ยอดขายที่ยังไม่ประมวลผล stk ตามสินค้าตามหน่วย
03.04.00	30/03/2020		Em		แก้ไขให้อัพเดท bal ตามจำนวนที่นับได้ + จำนวนที่ขายค้างอยู่ 
04.01.00	20/07/2020		Em		แก้ไขการใช้ฟิลด์ QtyAll
04.02.00	18/08/2020		Em		แก้ไขการใช้ฟิลด์ที่ใช้ตรวจสอบคลัง Vending
04.03.00	27/08/2020		Em		เพิ่มให้ insert ข้อมูลลงตาราง TVDTPdtStkBal
04.04.00	20/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.05.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
04.06.00	16/11/2020		Em		เพิ่มการตรวจสอบสถานะการตัดสต๊อก
04.07.00	16/11/2020		Em		เพิ่มการตรวจสอบรายการ void และการคืน
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
06.03.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
BEGIN TRY
	--SET @tStaPrc = (SELECT TOP 1 ISNULL(FTAjhStaPrcStk,'') AS FTAjhStaPrcStk FROM TCNTPdtAdjStkHD WITH(NOLOCK) WHERE FTBchCode = @ptBchCode AND FTAjhDocNo = @ptDocNo )		-- 3. --
	
	-- 4. --
	SELECT TOP 1 @tWahType = ISNULL(WAH.FTWahStaType,''),
	 @tAdjSeqChk = ISNULL(HD.FTAjhApvSeqChk,'1'),
	 @tStaPrc = ISNULL(FTAjhStaPrcStk,'')
	FROM TCNTPdtAdjStkHD HD WITH(NOLOCK) 
	INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTAjhWhTo = WAH.FTWahCode 
	WHERE HD.FTBchCode = @ptBchCode AND HD.FTAjhDocNo = @ptDocNo 
	-- 4. --
	
	IF @tStaPrc <> '1'		-- 3. --
	BEGIN
		
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		-- 04.04.00 --
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtAdjStkHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTAjhWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTAjhDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			IF @tWahType = '6'	-- 4. --
				BEGIN
					--Update sale before adjust
					UPDATE TCNTPdtAdjStkDT WITH(ROWLOCK)
					SET FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
					--,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
					,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))	-- 04.02.00 --
					FROM TCNTPdtAdjStkDT DT
					--LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, VD.FNLayRow, VD.FNLayCol, SUM(DT.FCXsdQtyAll) AS FCXsdQty
					LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, VD.FNLayRow, VD.FNLayCol, SUM(CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdQtyAll *(-1) ELSE DT.FCXsdQtyAll END) AS FCXsdQty	 -- 04.07.00 --
						FROM TVDTSalHD HD WITH(NOLOCK)
						INNER JOIN TVDTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
						INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
						INNER JOIN TVDTSalDTVD VD WITH(NOLOCK) ON DT.FTBchCode = VD.FTBchCode AND DT.FTXshDocNo = VD.FTXshDocNo AND DT.FNXsdSeqNo = VD.FNXsdSeqNo
						INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.06.00 --
						WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
						AND DT.FTXsdStaPdt <> '4' -- 04.07.00 --
						GROUP BY HD.FDXshDocDate, DT.FTPdtCode, VD.FNLayRow, VD.FNLayCol) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FNAjdLayRow = SAL.FNLayRow AND DT.FNAjdLayCol = SAL.FNLayCol AND DT.FDAjdDateTime > SAL.FDXshDocDate
					--WHERE DT.FDAjdDateTime > SAL.FDXshDocDate
					WHERE DT.FTBchCode = @ptBchCode AND DT.FTAjhDocNo = @ptDocNo -- 5. --

					--insert data to Temp
					INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
					SELECT @ptDocNo AS FTComName,HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
					,'5' AS FTStkType
					,DT.FTPdtCode AS FTPdtCode
					--, SUM(((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
					, SUM(((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate	-- 04.02.00 --
					, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
					, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
					, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
					FROM TCNTPdtAdjStkDT DT with(nolock)
					INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
					WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
					AND HD.FTAjhDocType = '3'
					AND ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
					GROUP BY HD.FTBchCode,HD.FTAjhWhTo,HD.FTAjhDocNo,HD.FTAjhDocType,DT.FTPdtCode,HD.FDAjhDocDate

					--insert data to stock card
					INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
					SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
					GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
					FROM @TTmpPrcStk
					WHERE FTComName = @ptDocNo

					--update qty to stock balance
					UPDATE TCNTPdtStkBal with(rowlock) 
					SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho
					FROM TCNTPdtStkBal BAL
					INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
					WHERE TMP.FTComName=@ptDocNo 
					AND ISNULL(TMP.FCStkQty,0)<>0

					--insert to Stock balance
					INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					--SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
					--FROM @TTmpPrcStk TMP
					--LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
					--WHERE ISNULL(BAL.FTPdtCode,'') = ''
					-- 04.03.00 --
					SELECT DT.FTBchCode,HD.FTAjhWhTo,DT.FTPdtCode,SUM(((ISNULL(DT.FCAjdUnitQtyC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
					FROM TCNTPdtAdjStkHD HD with(nolock)
					INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
					LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON DT.FTBchCode = BAL.FTBchCode AND HD.FTAjhWhTo = BAL.FTWahCode AND DT.FTPdtCode = BAL.FTPdtCode
					WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
					AND ISNULL(BAL.FTPdtCode,'') = ''
					GROUP BY DT.FTBchCode,HD.FTAjhWhTo,DT.FTPdtCode
					-- 04.03.00 --

					UPDATE TVDTPdtStkBal WITH(ROWLOCK)
					--SET FCStkQty= BAL.FCStkQty + ((ISNULL(DT.FCAjdUnitQty,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
					SET FCStkQty= BAL.FCStkQty + ((ISNULL(DT.FCAjdUnitQtyC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))	-- 04.02.00 --
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho
					FROM TVDTPdtStkBal BAL
					--INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON BAL.FTPdtCode = DT.FTPdtCode AND BAL.FNLayRow = DT.FNAjdLayRow AND BAL.FNLayCol = DT.FNAjdLayCol
					--INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo AND BAL.FTWahCode = HD.FTAjhWhTo
					INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON BAL.FTWahCode = HD.FTAjhWhTo -- 5. --
					INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo AND BAL.FTPdtCode = DT.FTPdtCode AND BAL.FNLayRow = DT.FNAjdLayRow AND BAL.FNLayCol = DT.FNAjdLayCol -- 5. --
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
					WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
					AND HD.FTAjhDocType = '3'
					--AND ((ISNULL(DT.FCAjdUnitQty,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
					AND ((ISNULL(DT.FCAjdUnitQtyC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0	-- 04.02.00 --

					-- 04.03.00 --
					--insert to Stock balance
					INSERT INTO TVDTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FNCabSeq,FNLayRow,FNLayCol,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT DT.FTBchCode,HD.FTAjhWhTo,DT.FNCabSeq,DT.FNAjdLayRow,DT.FNAjdLayCol, DT.FTPdtCode,((ISNULL(DT.FCAjdUnitQtyC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) AS FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
					FROM TCNTPdtAdjStkHD HD with(nolock)
					INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
					LEFT JOIN TVDTPdtStkBal BAL with(NOLOCK) ON DT.FTBchCode = BAL.FTBchCode AND HD.FTAjhWhTo = BAL.FTWahCode AND DT.FTPdtCode = BAL.FTPdtCode AND BAL.FNLayRow = DT.FNAjdLayRow AND BAL.FNLayCol = DT.FNAjdLayCol
					WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
					AND ISNULL(BAL.FTPdtCode,'') = ''
					-- 04.03.00 --
				
					--Cost
					UPDATE TCNMPdtCostAvg with(rowlock)
					SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
					--,FCPdtQtyBal = STK.FCStkQty
					,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	-- 06.03.00 --
					,FDLastUpdOn = GETDATE()
					FROM TCNMPdtCostAvg COST
					INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
					--INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
				END
			ELSE
				BEGIN
					IF @tAdjSeqChk = '1'
						BEGIN
							-- 03.04.00 --
							UPDATE TCNTPdtAdjStkDT
							SET FCAjdWahB4Adj = (CASE WHEN ISNULL(TMP.FTPdtCode,'') = '' THEN 0 ELSE FCAjdWahB4Adj END)
							FROM TCNTPdtAdjStkDT DT 
							LEFT JOIN (SELECT FTPdtCode,MIN(FCPdtUnitFact) AS FCPdtUnitFact
										FROM TCNTPdtAdjStkDT WITH(NOLOCK)
										WHERE FTBchCode=@ptBchCode AND FTAjhDocNo =@ptDocNo
										GROUP BY FTPdtCode
										) TMP ON TMP.FTPdtCode = DT.FTPdtCode AND TMP.FCPdtUnitFact = DT.FCPdtUnitFact
							WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
							-- 03.04.00 --

							--Update sale before adjust
							UPDATE TCNTPdtAdjStkDT WITH(ROWLOCK)
							SET FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
							,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
							FROM TCNTPdtAdjStkDT DT
							--LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
							--	FROM TPSTSalHD HD WITH(NOLOCK)
							--	INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
							--	WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
							--	GROUP BY HD.FDXshDocDate, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FDAjdDateTime > SAL.FDXshDocDate
							-- 03.01.00 --
							--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
							--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty -- 03.03.00 --
							LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdQtyAll*(-1) ELSE DT.FCXsdQtyAll END) AS FCXsdQty -- 04.07.00 --
								FROM TPSTSalHD HD WITH(NOLOCK)
								--INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
								INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'	-- 04.07.00 --
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.06.00 --
								INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2' -- 04.06.00 --
								WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
								AND HD.FTBchCode = @ptBchCode
								--GROUP BY HD.FTBchCode, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode
								GROUP BY HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode	-- 03.03.00 --
							-- 03.01.00 --
							--WHERE DT.FDAjdDateTime > SAL.FDXshDocDate
							WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo	-- 5. --

							--insert data to Temp
							INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
							SELECT @ptDocNo AS FTComName,HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
							,'5' AS FTStkType
							,DT.FTPdtCode AS FTPdtCode
							--, ((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) AS FCStkQty
							, SUM(((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty	-- 03.02.00 --
							,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
							, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
							, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
							, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
							FROM TCNTPdtAdjStkDT DT with(nolock)
							INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
							INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
							WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
							AND HD.FTAjhDocType IN ('2','3')
							AND ((ISNULL(DT.FCAjdQtyAllC1,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
							GROUP BY HD.FTBchCode,HD.FTAjhDocNo,DT.FTPdtCode,HD.FTAjhWhTo,FDAjhDocDate	-- 03.02.00 --

							--insert data to stock card
							INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
							SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
							GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
							FROM @TTmpPrcStk
							WHERE FTComName = @ptDocNo

							--update qty to stock balance
							--UPDATE TCNTPdtStkBal with(rowlock) 
							----SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
							--SET FCStkQty= TMP.FCStkQty	-- 03.03.00 --
							--,FDLastUpdOn = GETDATE()
							--,FTLastUpdBy = @ptWho
							--FROM TCNTPdtStkBal BAL
							--INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
							--WHERE TMP.FTComName=@ptDocNo 
							--AND ISNULL(TMP.FCStkQty,0)<>0
							-- 03.04.00 --
							UPDATE TCNTPdtStkBal with(rowlock) 
							SET FCStkQty= TMP.FCStkQty
							,FDLastUpdOn = GETDATE()
							,FTLastUpdBy = @ptWho
							FROM TCNTPdtStkBal BAL
							--INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAll+DT.FCAjdSaleB4AdjC1) AS FCStkQty 
							INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAllC1+DT.FCAjdSaleB4AdjC1) AS FCStkQty -- 04.01.00 --
									FROM TCNTPdtAdjStkDT DT with(nolock)
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) on HD.FTBchCode = DT.FTBchCode AND HD.FTAjhDocNo = DT.FTAjhDocNo
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
									WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
									GROUP BY HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode
									) TMP ON TMP.FTAjhBchTo = BAL.FTBchCode AND TMP.FTAjhWhTo = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
							-- 03.04.00 --

							--insert to Stock balance
							INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
							SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
							FROM @TTmpPrcStk TMP
							LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
							WHERE ISNULL(BAL.FTPdtCode,'') = ''

							-- 06.01.00 --
							IF EXISTS(SELECT FTPdtCode FROM TCNTPdtAdjStkDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTAjhDocNo = @ptDocNo) BEGIN
								-- update qty Diff
								UPDATE TCNTPdtAdjStkDTFhn
								SET FCAjdQtyAllDiff = (((ISNULL(DTF.FCAjdQtyC1,0) * DT.FCPdtUnitFact) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DTF.FCAjdWahB4Adj,0))
								,FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
								FROM TCNTPdtAdjStkDTFhn DTF with(nolock)
								INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
								INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'
								LEFT JOIN (SELECT HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN (DTF.FCXsdQty*DT.FCXsdFactor) * (-1) ELSE (DTF.FCXsdQty*DT.FCXsdFactor) END) AS FCXsdQty
											FROM TPSTSalHD HD WITH(NOLOCK)
											INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'
											INNER JOIN TPSTSalDTFhn DTF WITH(NOLOCK) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXshDocNo = DTF.FTXshDocNo AND DT.FNXsdSeqNo = DTF.FNXsdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
											INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'
											INNER JOIN TCNMWahouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'
											WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
											AND HD.FTBchCode = @ptBchCode
											GROUP BY HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode AND HD.FTBchCode = SAL.FTBchCode AND HD.FTAjhWhTo = SAL.FTWahCode
								WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
								AND HD.FTAjhDocType IN ('2','3')

								--insert data to Temp
								INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
								SELECT HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
								,'5' AS FTStkType
								,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
								,SUM(ISNULL(DTF.FCAjdQtyAllDiff,0)) AS FCStkQty
								,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
								, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
								FROM TCNTPdtAdjStkDT DT with(nolock)
								INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
								INNER JOIN TCNTPdtAdjStkDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
								WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
								AND HD.FTAjhDocType IN ('2','3')
								AND ISNULL(DTF.FCAjdQtyAllDiff,0) <> 0
								GROUP BY HD.FTBchCode,HD.FTAjhDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTAjhWhTo,FDAjhDocDate

								IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
									--Update Out
									UPDATE TFHTPdtStkBal WITH(ROWLOCK)
									SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
									,FDLastUpdOn = GETDATE()
									,FTLastUpdBy = @ptWho	
									FROM TFHTPdtStkBal STK
									INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

									--Create stk balance
									INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
									SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
									GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
									FROM @TTmpPrcStkFhn TMP
									LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
									WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

									--insert stk card
									INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
									SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
									FROM @TTmpPrcStkFhn
								END
							END
							-- 06.01.00 --

							--Cost
							UPDATE TCNMPdtCostAvg with(rowlock)
							SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
							--,FCPdtQtyBal = STK.FCStkQty
							,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	-- 06.03.00 --
							,FDLastUpdOn = GETDATE()
							FROM TCNMPdtCostAvg COST
							INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
							--INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
						END
					ELSE
						IF @tAdjSeqChk = '2'
							BEGIN
								-- 03.04.00 --
								UPDATE TCNTPdtAdjStkDT
								SET FCAjdWahB4Adj = (CASE WHEN ISNULL(TMP.FTPdtCode,'') = '' THEN 0 ELSE FCAjdWahB4Adj END)
								FROM TCNTPdtAdjStkDT DT 
								LEFT JOIN (SELECT FTPdtCode,MIN(FCPdtUnitFact) AS FCPdtUnitFact
											FROM TCNTPdtAdjStkDT WITH(NOLOCK)
											WHERE FTBchCode=@ptBchCode AND FTAjhDocNo =@ptDocNo
											GROUP BY FTPdtCode
											) TMP ON TMP.FTPdtCode = DT.FTPdtCode AND TMP.FCPdtUnitFact = DT.FCPdtUnitFact
								WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
								-- 03.04.00 --

								--Update sale before adjust
								UPDATE TCNTPdtAdjStkDT WITH(ROWLOCK)
								SET FCAjdSaleB4AdjC2 = ISNULL(SAL.FCXsdQty,0)
								,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAllC2,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
								FROM TCNTPdtAdjStkDT DT
								--LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
								--	FROM TPSTSalHD HD WITH(NOLOCK)
								--	INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
								--	WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
								--	GROUP BY HD.FDXshDocDate, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FDAjdDateTime > SAL.FDXshDocDate
								-- 03.01.00 --
								--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
								--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty -- 03.03.00 --
								LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdQtyAll * (-1) ELSE DT.FCXsdQtyAll END) AS FCXsdQty -- 04.07.00 --
									FROM TPSTSalHD HD WITH(NOLOCK)
									--INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
									INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'	-- 04.07.00 --
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'	-- 04.06.00 --
									INNER JOIN TCNMWahouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.06.00 --
									WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
									AND HD.FTBchCode = @ptBchCode
									--GROUP BY HD.FTBchCode, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode
									GROUP BY HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode	-- 03.03.00 --
								-- 03.01.00 --
								--WHERE DT.FDAjdDateTime > SAL.FDXshDocDate
								WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo	-- 5. --

								--insert data to Temp
								INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
								SELECT @ptDocNo AS FTComName,HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
								,'5' AS FTStkType
								,DT.FTPdtCode AS FTPdtCode
								--, ((ISNULL(DT.FCAjdQtyAllC2,0) + ISNULL(DT.FCAjdSaleB4AdjC2,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
								, SUM(((ISNULL(DT.FCAjdQtyAllC2,0) + ISNULL(DT.FCAjdSaleB4AdjC2,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate	-- 03.02.00 --
								, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
								FROM TCNTPdtAdjStkDT DT with(nolock)
								INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
								WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
								AND HD.FTAjhDocType IN ('2','3')
								AND ((ISNULL(DT.FCAjdQtyAllC2,0) + ISNULL(DT.FCAjdSaleB4AdjC2,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
								GROUP BY HD.FTBchCode ,HD.FTAjhDocNo,DT.FTPdtCode,HD.FTAjhWhTo,HD.FDAjhDocDate	-- 03.02.00 --

								--insert data to stock card
								INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
								SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
								GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
								FROM @TTmpPrcStk
								WHERE FTComName = @ptDocNo

								--update qty to stock balance
								--UPDATE TCNTPdtStkBal with(rowlock) 
								----SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
								--SET FCStkQty= TMP.FCStkQty	-- 03.03.00 --
								--,FDLastUpdOn = GETDATE()
								--,FTLastUpdBy = @ptWho
								--FROM TCNTPdtStkBal BAL
								--INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
								--WHERE TMP.FTComName=@ptDocNo 
								--AND ISNULL(TMP.FCStkQty,0)<>0

								-- 03.04.00 --
								UPDATE TCNTPdtStkBal with(rowlock) 
								SET FCStkQty= TMP.FCStkQty
								,FDLastUpdOn = GETDATE()
								,FTLastUpdBy = @ptWho
								FROM TCNTPdtStkBal BAL
								--INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAll+DT.FCAjdSaleB4AdjC2) AS FCStkQty 
								INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAllC2+DT.FCAjdSaleB4AdjC2) AS FCStkQty	-- 04.01.00 --
										FROM TCNTPdtAdjStkDT DT with(nolock)
										INNER JOIN TCNTPdtAdjStkHD HD with(nolock) on HD.FTBchCode = DT.FTBchCode AND HD.FTAjhDocNo = DT.FTAjhDocNo
										INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
										WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
										GROUP BY HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode
										) TMP ON TMP.FTAjhBchTo = BAL.FTBchCode AND TMP.FTAjhWhTo = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
								-- 03.04.00 --

								--insert to Stock balance
								INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
								SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
								FROM @TTmpPrcStk TMP
								LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
								WHERE ISNULL(BAL.FTPdtCode,'') = ''

								-- 06.01.00 --
								IF EXISTS(SELECT FTPdtCode FROM TCNTPdtAdjStkDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTAjhDocNo = @ptDocNo) BEGIN
									-- update qty Diff
									UPDATE TCNTPdtAdjStkDTFhn
									SET FCAjdQtyAllDiff = (((ISNULL(DTF.FCAjdQtyC2,0) * DT.FCPdtUnitFact) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DTF.FCAjdWahB4Adj,0))
									,FCAjdSaleB4AdjC2 = ISNULL(SAL.FCXsdQty,0)
									FROM TCNTPdtAdjStkDTFhn DTF with(nolock)
									INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'
									LEFT JOIN (SELECT HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN (DTF.FCXsdQty*DT.FCXsdFactor) * (-1) ELSE (DTF.FCXsdQty*DT.FCXsdFactor) END) AS FCXsdQty
												FROM TPSTSalHD HD WITH(NOLOCK)
												INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'
												INNER JOIN TPSTSalDTFhn DTF WITH(NOLOCK) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXshDocNo = DTF.FTXshDocNo AND DT.FNXsdSeqNo = DTF.FNXsdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
												INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'
												INNER JOIN TCNMWahouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'
												WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
												AND HD.FTBchCode = @ptBchCode
												GROUP BY HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode AND HD.FTBchCode = SAL.FTBchCode AND HD.FTAjhWhTo = SAL.FTWahCode
									WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
									AND HD.FTAjhDocType IN ('2','3')

									--insert data to Temp
									INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
									SELECT HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
									,'5' AS FTStkType
									,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
									,SUM(ISNULL(DTF.FCAjdQtyAllDiff,0)) AS FCStkQty
									,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
									, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
									, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
									, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
									FROM TCNTPdtAdjStkDT DT with(nolock)
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
									INNER JOIN TCNTPdtAdjStkDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
									WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
									AND HD.FTAjhDocType IN ('2','3')
									AND ISNULL(DTF.FCAjdQtyAllDiff,0) <> 0
									GROUP BY HD.FTBchCode,HD.FTAjhDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTAjhWhTo,FDAjhDocDate

									IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
										--Update Out
										UPDATE TFHTPdtStkBal WITH(ROWLOCK)
										SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
										,FDLastUpdOn = GETDATE()
										,FTLastUpdBy = @ptWho	
										FROM TFHTPdtStkBal STK
										INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

										--Create stk balance
										INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
										SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
										GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
										FROM @TTmpPrcStkFhn TMP
										LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
										WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

										--insert stk card
										INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
										SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
										FROM @TTmpPrcStkFhn
									END
								END
								-- 06.01.00 --

								--Cost
								UPDATE TCNMPdtCostAvg with(rowlock)
								SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
								--,FCPdtQtyBal = STK.FCStkQty
								,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	-- 06.03.00 --
								,FDLastUpdOn = GETDATE()
								FROM TCNMPdtCostAvg COST
								INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
								--INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
							END
						ELSE
							BEGIN
								-- 03.04.00 --
								UPDATE TCNTPdtAdjStkDT
								SET FCAjdWahB4Adj = (CASE WHEN ISNULL(TMP.FTPdtCode,'') = '' THEN 0 ELSE FCAjdWahB4Adj END)
								FROM TCNTPdtAdjStkDT DT 
								LEFT JOIN (SELECT FTPdtCode,MIN(FCPdtUnitFact) AS FCPdtUnitFact
											FROM TCNTPdtAdjStkDT WITH(NOLOCK)
											WHERE FTBchCode=@ptBchCode AND FTAjhDocNo =@ptDocNo
											GROUP BY FTPdtCode
											) TMP ON TMP.FTPdtCode = DT.FTPdtCode AND TMP.FCPdtUnitFact = DT.FCPdtUnitFact
								WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
								-- 03.04.00 --

								--Update sale before adjust
								UPDATE TCNTPdtAdjStkDT WITH(ROWLOCK)
								SET FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
								,FCAjdQtyAllDiff = ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DT.FCAjdWahB4Adj,0))
								FROM TCNTPdtAdjStkDT DT
								--LEFT JOIN (SELECT HD.FDXshDocDate, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
								--	FROM TPSTSalHD HD WITH(NOLOCK)
								--	INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
								--	WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
								--	GROUP BY HD.FDXshDocDate, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FDAjdDateTime > SAL.FDXshDocDate
								-- 03.01.00 --
								--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty
								--LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(DT.FCXsdQtyAll) AS FCXsdQty -- 03.03.00 --
								LEFT JOIN (SELECT HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdQtyAll * (-1) ELSE DT.FCXsdQtyAll END) AS FCXsdQty -- 04.07.00 --
									FROM TPSTSalHD HD WITH(NOLOCK)
									--INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo 
									INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'	-- 04.07.00 --
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'	-- 04.06.00 --
									INNER JOIN TCNMWaHouse WAH WITH(NOLOcK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.06.00 --
									WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
									AND HD.FTBchCode = @ptBchCode
									--GROUP BY HD.FTBchCode, DT.FTPdtCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode
									GROUP BY HD.FTBchCode, DT.FTPdtCode, DT.FTPunCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode	-- 03.03.00 --
								-- 03.01.00 --
								--WHERE DT.FDAjdDateTime > SAL.FDXshDocDate
								WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo	-- 5. --

								--insert data to Temp
								INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
								SELECT @ptDocNo AS FTComName,HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
								,'5' AS FTStkType
								,DT.FTPdtCode AS FTPdtCode
								--, ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
								, SUM(((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0))) AS FCStkQty,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate		-- 03.02.00 --
								, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
								, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
								FROM TCNTPdtAdjStkDT DT with(nolock)
								INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
								INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
								WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
								AND HD.FTAjhDocType IN ('2','3')
								AND ((ISNULL(DT.FCAjdQtyAll,0) + ISNULL(DT.FCAjdSaleB4AdjC1,0)) - ISNULL(DT.FCAjdWahB4Adj,0)) <> 0
								GROUP BY HD.FTBchCode ,HD.FTAjhDocNo,DT.FTPdtCode,HD.FTAjhWhTo,HD.FDAjhDocDate	-- 03.02.00 --

								--insert data to stock card
								INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
								SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
								GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
								FROM @TTmpPrcStk
								WHERE FTComName = @ptDocNo

								--update qty to stock balance
								--UPDATE TCNTPdtStkBal with(rowlock) 
								----SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
								--SET FCStkQty= TMP.FCStkQty	-- 03.03.00 --
								--,FDLastUpdOn = GETDATE()
								--,FTLastUpdBy = @ptWho
								--FROM TCNTPdtStkBal BAL
								--INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
								--WHERE TMP.FTComName=@ptDocNo 
								--AND ISNULL(TMP.FCStkQty,0)<>0

								-- 03.04.00 --
								UPDATE TCNTPdtStkBal with(rowlock) 
								SET FCStkQty= TMP.FCStkQty
								,FDLastUpdOn = GETDATE()
								,FTLastUpdBy = @ptWho
								FROM TCNTPdtStkBal BAL
								INNER JOIN (SELECT HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode,SUM(DT.FCAjdQtyAll+DT.FCAjdSaleB4AdjC1) AS FCStkQty 
										FROM TCNTPdtAdjStkDT DT with(nolock)
										INNER JOIN TCNTPdtAdjStkHD HD with(nolock) on HD.FTBchCode = DT.FTBchCode AND HD.FTAjhDocNo = DT.FTAjhDocNo
										INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
										WHERE DT.FTBchCode=@ptBchCode AND DT.FTAjhDocNo =@ptDocNo
										GROUP BY HD.FTAjhBchTo,HD.FTAjhWhTo,DT.FTPdtCode
										) TMP ON TMP.FTAjhBchTo = BAL.FTBchCode AND TMP.FTAjhWhTo = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
								-- 03.04.00 --

								--insert to Stock balance
								INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
								SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
								FROM @TTmpPrcStk TMP
								LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
								WHERE ISNULL(BAL.FTPdtCode,'') = ''

								-- 06.01.00 --
								IF EXISTS(SELECT FTPdtCode FROM TCNTPdtAdjStkDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTAjhDocNo = @ptDocNo) BEGIN
									-- update qty Diff
									UPDATE TCNTPdtAdjStkDTFhn
									SET FCAjdQtyAllDiff = (((ISNULL(DTF.FCAjdQtyAll,0) * DT.FCPdtUnitFact) + ISNULL(SAL.FCXsdQty,0)) - ISNULL(DTF.FCAjdWahB4Adj,0))
									,FCAjdSaleB4AdjC1 = ISNULL(SAL.FCXsdQty,0)
									FROM TCNTPdtAdjStkDTFhn DTF with(nolock)
									INNER JOIN TCNTPdtAdjStkDT DT with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'
									LEFT JOIN (SELECT HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode, SUM(CASE WHEN HD.FNXshDocType = 9 THEN (DTF.FCXsdQty*DT.FCXsdFactor) * (-1) ELSE (DTF.FCXsdQty*DT.FCXsdFactor) END) AS FCXsdQty
												FROM TPSTSalHD HD WITH(NOLOCK)
												INNER JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTXsdStaPdt <> '4'
												INNER JOIN TPSTSalDTFhn DTF WITH(NOLOCK) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXshDocNo = DTF.FTXshDocNo AND DT.FNXsdSeqNo = DTF.FNXsdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
												INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND ISNULL(PDT.FTPdtStkControl,'') = '1'
												INNER JOIN TCNMWahouse WAH WITH(NOLOCK) ON WAH.FTBchCode = HD.FTBchCode AND WAH.FTWahCode = HD.FTWahCode AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'
												WHERE ISNULL(HD.FTXshStaPrcStk,'') = ''
												AND HD.FTBchCode = @ptBchCode
												GROUP BY HD.FTBchCode, HD.FTWahCode, DT.FTPdtCode, DT.FTPunCode, DTF.FTFhnRefCode) SAL ON DT.FTPdtCode = SAL.FTPdtCode AND DT.FTPunCode = SAL.FTPunCode AND HD.FTBchCode = SAL.FTBchCode AND HD.FTAjhWhTo = SAL.FTWahCode
									WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
									AND HD.FTAjhDocType IN ('2','3')

									--insert data to Temp
									INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
									SELECT HD.FTBchCode,HD.FTAjhDocNo AS FTStkDocNo
									,'5' AS FTStkType
									,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
									,SUM(ISNULL(DTF.FCAjdQtyAllDiff,0)) AS FCStkQty
									,HD.FTAjhWhTo AS FTWahCode,HD.FDAjhDocDate AS FDStkDate
									, ROUND(0,4) AS FCStkSetPrice	-- 06.02.00 --
									, ROUND(0,4) AS FCStkCostIn	-- 06.02.00 --
									, ROUND(0,4) AS FCStkCostEx	-- 06.02.00 --
									FROM TCNTPdtAdjStkDT DT with(nolock)
									INNER JOIN TCNTPdtAdjStkHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTAjhDocNo = HD.FTAjhDocNo
									INNER JOIN TCNTPdtAdjStkDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTAjhDocNo = DTF.FTAjhDocNo AND DT.FNAjdSeqNo = DTF.FNAjdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
									INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.05.00 --
									WHERE HD.FTBchCode=@ptBchCode AND HD.FTAjhDocNo =@ptDocNo
									AND HD.FTAjhDocType IN ('2','3')
									AND ISNULL(DTF.FCAjdQtyAllDiff,0) <> 0
									GROUP BY HD.FTBchCode,HD.FTAjhDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FTAjhWhTo,FDAjhDocDate

									IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
										--Update Out
										UPDATE TFHTPdtStkBal WITH(ROWLOCK)
										SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
										,FDLastUpdOn = GETDATE()
										,FTLastUpdBy = @ptWho	
										FROM TFHTPdtStkBal STK
										INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

										--Create stk balance
										INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
										SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
										GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
										FROM @TTmpPrcStkFhn TMP
										LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
										WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

										--insert stk card
										INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
										SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
										FROM @TTmpPrcStkFhn
									END
								END
								-- 06.01.00 --

								--Cost
								UPDATE TCNMPdtCostAvg with(rowlock)
								SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
								--,FCPdtQtyBal = STK.FCStkQty
								,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	-- 06.03.00 --
								,FDLastUpdOn = GETDATE()
								FROM TCNMPdtCostAvg COST
								INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
								--INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
							END
				END
		END

	END	-- 3. --
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxBchPdtTnf')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxBchPdtTnf
GO
CREATE PROCEDURE [dbo].STP_DOCxBchPdtTnf
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --	
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	24/03/2020		Em		create  
00.02.00	26/03/2020		Em		แก้ไขข้อมูลลงตามสาขาต้นทางปลายทาง
00.03.00	09/04/2020		Em		แก้ไขปรับปรุง
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
06.03.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcBchTnf'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') AS FTXthStaPrcStk FROM TCNTPdtTbxHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)	

	IF @tStaPrc <> '1'	
	BEGIN
		-- 05.01.00 --
		DELETE STK WITH(ROWLOCK)
		FROM TCNTPdtStkCrd STK
		INNER JOIN TCNTPdtTbxHD HD WITH(NOLOCK) ON HD.FTXthDocNo = STK.FTStkDocNo AND (HD.FTXthBchFrm = STK.FTBchCode OR HD.FTXthBchTo = STK.FTBchCode) 
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE STK WITH(ROWLOCK)
		FROM TFHTPdtStkCrd STK
		INNER JOIN TCNTPdtTbxHD HD WITH(NOLOCK) ON HD.FTXthDocNo = STK.FTStfDocNo AND (HD.FTXthBchFrm = STK.FTBchCode OR HD.FTXthBchTo = STK.FTBchCode) 
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		-- 06.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTbxHD HD WITH(NOLOCK) ON HD.FTXthBchFrm = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTbxHD HD WITH(NOLOCK) ON HD.FTXthBchTo = WAH.FTBchCode AND HD.FTXthWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)
		
		IF @tStaPrcStkFrm = '2'
		BEGIN
			--Create stk balance
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
			SELECT DISTINCT HD.FTXthBchFrm,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,	-- 00.02.00 --
			GETDATE() AS FDLastUpd,@ptWho,	
			GETDATE() AS FDCreateOn,@ptWho	
			FROM TCNTPdtTbxHD HD WITH(NOLOCK)		
			INNER JOIN TCNTPdtTbxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --		
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchFrm = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''

			--Update Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Tfb.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho	
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll	-- 00.03.00 --
				FROM TCNTPdtTbxHD HD WITH(NOLOCK)
				INNER JOIN TCNTPdtTbxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
				GROUP BY HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Tfb  ON Tfb.FTXthBchFrm = STK.FTBchCode AND Tfb.FTXthWhFrm = STK.FTWahCode AND Tfb.FTPdtCode = STK.FTPdtCode	-- 00.03.00 --

			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 00.02.00 --
			,'2' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTbxDT DT with(nolock)
			INNER JOIN TCNTPdtTbxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 00.02.00 --

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTbxDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 00.02.00 --
				,'2' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode, DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTbxDT DT with(nolock)
				INNER JOIN TCNTPdtTbxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTbxDTFhn DTF WITH(NOLOCK) ON HD.FTBchCode = DTF.FTBchCode AND HD.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate	-- 00.02.00 --

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,(TMP.FCStfQty *(-1)) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END

		IF @tStaPrcStkTo = '2'
		BEGIN
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
			SELECT DISTINCT HD.FTXthBchTo,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,	-- 00.02.00 --
			GETDATE() AS FDLastUpdOn,@ptWho,	
			GETDATE() AS FDCreateOn,@ptWho		
			FROM TCNTPdtTbxHD HD WITH(NOLOCK)		
			INNER JOIN TCNTPdtTbxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo	
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchTo = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''
			GROUP BY HD.FTXthBchTo,HD.FTXthWhTo,DT.FTPdtCode	-- 00.02.00 --

			--Update In
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(Tfb.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho	
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll	-- 00.03.00 --
					FROM TCNTPdtTbxHD HD WITH(NOLOCK)		
					INNER JOIN TCNTPdtTbxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo	
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
					WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
					GROUP BY HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode) Tfb  ON Tfb.FTXthBchTo = STK.FTBchCode AND Tfb.FTXthWhTo = STK.FTWahCode AND Tfb.FTPdtCode = STK.FTPdtCode	-- 00.03.00 --

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchTo,HD.FTXthDocNo AS FTStkDocNo	-- 00.02.00 --
			,'1' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTbxDT DT with(nolock)
			INNER JOIN TCNTPdtTbxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTXthBchTo,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 00.02.00 --

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTbxDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				DELETE FROM @TTmpPrcStkFhn

				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTXthBchTo,HD.FTXthDocNo AS FTStkDocNo	-- 00.02.00 --
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode, DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTbxDT DT with(nolock)
				INNER JOIN TCNTPdtTbxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTbxDTFhn DTF WITH(NOLOCK) ON HD.FTBchCode = DTF.FTBchCode AND HD.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTXthBchTo,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate	-- 00.02.00 --

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		--insert to stock card
		INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
		SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
		GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM @TTmpPrcStk

		--Cost
		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
		--,FCPdtQtyBal = STK.FCStkQty
		,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	-- 06.03.00 --
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '1'
		--INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode

		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*COST.FCPdtCostEx)
		--,FCPdtQtyBal = STK.FCStkQty
		,FCPdtQtyBal = FCPdtQtyBal - TMP.FCStkQty	-- 06.03.00 --
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '2'
		--INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode
		
	END	
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
	SELECT ERROR_MESSAGE()
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxBchPdtTnfIn')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxBchPdtTnfIn
GO
CREATE PROCEDURE [dbo].STP_DOCxBchPdtTnfIn
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
03.01.00	25/03/2020		Em		create  
03.02.00	26/03/2020		Em		เพิ่มการตรวจสอบ DocType
03.03.00	27/03/2020		Em		แก้ไขขนาดฟิลด์ BchCode จาก 3 เป็น 5
03.04.00	13/04/2020		Em		แก้ไขปรับปรุง
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	01/07/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	05/07/2021		Em		เพิ่มการอัพเดท IntDTFhn
06.03.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcBchIn'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTbiHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)

	IF @tStaPrc <> '1'
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo

		DELETE TFHTPdtStkCrd WITH(ROWLOCK)	-- 06.02.00 --
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo -- 06.02.00 --
		-- 05.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTbiHD HD WITH(NOLOCK) ON HD.FTXthBchTo = WAH.FTBchCode AND HD.FTXthWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			--Create stk balance	
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)		
			SELECT DISTINCT HD.FTXthBchTo,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,	-- 03.01.00 --
			GETDATE() AS FDLastUpdOn,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTbiHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTbiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchTo = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo -- 03.01.00 --
			AND ISNULL(STK.FTPdtCode,'') = ''	

			--Update balance In
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(Tbi.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Tbi.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll -- 03.01.00 --
				FROM TCNTPdtTbiHD HD WITH(NOLOCK)
				INNER JOIN TCNTPdtTbiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo	-- 03.01.00 --
				GROUP BY HD.FTXthBchTo,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode) Tbi  ON Tbi.FTXthBchTo = STK.FTBchCode AND Tbi.FTXthWhTo = STK.FTWahCode AND Tbi.FTPdtCode = STK.FTPdtCode -- 03.01.00 --

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchTo,HD.FTXthDocNo AS FTStkDocNo	-- 03.01.00 --
			,'1' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
			FROM TCNTPdtTbiDT DT with(nolock)
			INNER JOIN TCNTPdtTbiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate,HD.FTXthBchTo

			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTbiDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTXthBchTo,HD.FTXthDocNo AS FTStkDocNo
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
				FROM TCNTPdtTbiDT DT with(nolock)
				INNER JOIN TCNTPdtTbiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTbiDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
				AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
				GROUP BY HD.FTXthBchTo,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END

				-- 06.02.00 --
				UPDATE TCNTPdtIntDTFhnBch WITH(ROWLOCK)
				SET FCXtdQtyRcv = ISNULL(FCXtdQtyRcv,0) + ISNULL(DTF.FCXtdQty,0)
				FROM TCNTPdtIntDTFhnBch DT
				INNER JOIN TCNTPdtTbiHD HDi WITH(NOLOCK) ON HDi.FTXthRefInt = DT.FTXthDocNo AND HDi.FTXthBchTo = DT.FTXthBchTo AND HDi.FTXthWhTo = DT.FTXthWahTo
				INNER JOIN TCNTPdtTbiDT DTi WITH(NOLOCK) ON HDi.FTXthDocNo = DTi.FTXthDocNo AND DTi.FTPdtCode = DT.FTPdtCode
				INNER JOIN TCNTPdtTbiDTFhn DTF with(nolock) ON DTi.FTBchCode = DTF.FTBchCode AND DTi.FTXthDocNo = DTF.FTXthDocNo AND DTi.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode AND DT.FTFhnRefCode = DTF.FTFhnRefCode
				WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo  -- 03.01.00 --
				AND HDi.FNXthDocType = 5  -- 2. --
				-- 06.02.00 --
			END
			-- 06.01.00 --
		END
			
		UPDATE TCNTPdtIntDTBch WITH(ROWLOCK)
		SET FCXtdQtyRcv = ISNULL(FCXtdQtyRcv,0) + ISNULL(DTi.FCXtdQtyAll,0)
		,FTXtdRvtRef = HDi.FTXthDocNo 
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TCNTPdtIntDTBch DT
		INNER JOIN TCNTPdtTbiHD HDi WITH(NOLOCK) ON HDi.FTXthRefInt = DT.FTXthDocNo AND HDi.FTXthBchTo = DT.FTXthBchTo AND HDi.FTXthWhTo = DT.FTXthWahTo
		INNER JOIN TCNTPdtTbiDT DTi WITH(NOLOCK) ON HDi.FTXthDocNo = DTi.FTXthDocNo AND DTi.FTPdtCode = DT.FTPdtCode
		--WHERE HDi.FTXthBchTo = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo  -- 03.01.00 --
		--AND ISNULL(DTi.FTXtdDocNoRef,'') = ''
		AND HDi.FNXthDocType = 5  -- 2. --

		UPDATE TCNTPdtTboHD WITH(ROWLOCK)
		SET FTXthRefInt = @ptDocNo
		FROM TCNTPdtTboHD HDo
		INNER JOIN TCNTPdtTbiHD HDi WITH(NOLOCK) ON HDo.FTXthDocNo = HDi.FTXthRefInt
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo

		-- 06.03.00 --
		--Cost
		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
		,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '1'
		-- 06.03.00 --

	END 
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxBchPdtTnfOut')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxBchPdtTnfOut
GO
CREATE PROCEDURE [dbo].STP_DOCxBchPdtTnfOut
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5),  -- 2. --
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
03.01.00	25/03/2020		Em		create  
03.02.00	27/03/2020		Em		แก้ไขขนาดฟิลด์สาขาจาก 3 เป็น 5
03.03.00	13/04/2020		Em		แก้ไขปรับปรุง
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	01/07/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	05/07/2021		Em		เพิ่มรายการ IntDTFhn
06.03.00	05/07/2021		Em		แก้ไขลงรหัสสาขาใน StkCrd ไม่ถูกต้อง
06.04.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcBchOut'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTboHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)

	IF @tStaPrc <> '1'	-- 6. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo

		DELETE TFHTPdtStkCrd WITH(ROWLOCK)	-- 06.02.00 --
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo -- 06.02.00 --
		-- 05.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTXthBchFrm = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkFrm = '2'
		BEGIN
			--Create stk balance
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)	
			SELECT DISTINCT HD.FTXthBchFrm,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,	-- 03.03.00 --
			GETDATE() AS FDLastUpd,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTboHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTboDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTXthBchFrm = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode	-- 03.03.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''

			--Update balance Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Two.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Two.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll	-- 03.03.00 --
			FROM TCNTPdtTboHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTboDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Two  ON Two.FTXthBchFrm = STK.FTBchCode AND Two.FTXthWhFrm = STK.FTWahCode AND Two.FTPdtCode = STK.FTPdtCode	-- 03.03.00 --

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 03.03.00 --
			,'2' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
			FROM TCNTPdtTboDT DT with(nolock)
			INNER JOIN TCNTPdtTboHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 03.03.00 --

			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTboDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				--SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				SELECT HD.FTXthBchFrm,HD.FTXthDocNo AS FTStkDocNo	-- 06.03.00 --
				,'2' AS FTStkType	-- 03.02.00 --
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx
				FROM TCNTPdtTboDT DT with(nolock)
				INNER JOIN TCNTPdtTboHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTboDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				--GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate
				GROUP BY HD.FTXthBchFrm,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate	-- 06.03.00 --

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty*(-1) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END

				-- 06.02.00 --
				--Delete old data
				DELETE FROM TCNTPdtIntDTFhnBch WHERE  FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo

				--Insert new data
				INSERT INTO TCNTPdtIntDTFhnBch(FTBchCode, FTXthDocNo, FNXtdSeqNo, FTXthBchTo, FTXthWahTo, 
					FTPdtCode, FTFhnRefCode, FCXtdQty, FCXtdQtyRcv, FCXtdQtyAll)
				SELECT HD.FTBchCode, HD.FTXthDocNo, DTF.FNXtdSeqNo, HD.FTXthBchTo, FTXthWhTo, 
					DTF.FTPdtCode, DTF.FTFhnRefCode, DTF.FCXtdQty, 0 AS FCXtdQtyRcv, (DTF.FCXtdQty * DT.FCXtdFactor) AS FCXtdQtyAll
				FROM TCNTPdtTboDT DT WITH(NOLOCK)
				INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo 
				INNER JOIN TCNTPdtTboDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
				-- 06.02.00 --
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		--Delete old data
		DELETE FROM TCNTPdtIntDTBch WHERE  FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo

		--Insert new data
		INSERT INTO TCNTPdtIntDTBch(FTBchCode, FTXthDocNo, FNXtdSeqNo, FNXthDocType, FTXthBchTo, FTXthWahTo, 
			FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, FCXtdQtyRcv, FCXtdQtyAll,		
			FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
		SELECT HD.FTBchCode, HD.FTXthDocNo, FNXtdSeqNo, '2', HD.FTXthBchTo, FTXthWhTo, 
			FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, 0 AS FCXtdQtyRcv, FCXtdQtyAll,		
			GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM TCNTPdtTboDT DT WITH(NOLOCK)
		INNER JOIN TCNTPdtTboHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo 
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo

		-- 06.04.00 --
		--Cost
		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*COST.FCPdtCostEx)
		,FCPdtQtyBal = FCPdtQtyBal - TMP.FCStkQty	
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
		-- 06.04.00 --
		
	END	 
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxPdtAdjCost')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxPdtAdjCost
GO
CREATE PROCEDURE [dbo].STP_DOCxPdtAdjCost
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @TTmpPrcCost TABLE 
   ( 
   FTBchCode varchar(5), 
   FTPdtCode varchar(20), 
   FCPdtQty decimal(18,4), 
   FCPdtCostIn decimal(18,4),
   FCPdtCostEx decimal(18,4),
   FCPdtCostAmt decimal(18,4),
   FCPdtVat decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)
DECLARE @nDec int
DECLARE @tAgnCode varchar(5)
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
05.01.00	23/02/2021		Em		create  
06.01.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
BEGIN TRY
	
	SELECT TOP 1 @tAgnCode = FTAgnCode FROM TCNMBranch WITH(NOLOCK) WHERE FTBchCode = @ptBchCode

	SELECT TOP 1 @nDec = CAST(ISNULL(ISNULL(SPC.FTCfgStaUsrValue,CFG.FTSysStaUsrValue),0) AS int)
	FROM TSysConfig CFG
	LEFT JOIN TCNTConfigSpc SPC ON SPC.FTSysCode = CFG.FTSysCode AND SPC.FTSysApp = CFG.FTSysApp AND SPC.FTSysKey = CFG.FTSysKey 
			AND SPC.FTSysSeq = CFG.FTSysSeq AND SPC.FTAgnCode = @tAgnCode
	WHERE CFG.FTSysCode = 'ADecPntSav' 

	SELECT TOP 1 @tStaPrc = ISNULL(FTXchStaPrcDoc,'')
	FROM TCNTPdtAdjCostHD HD WITH(NOLOCK) 
	WHERE HD.FTBchCode = @ptBchCode AND HD.FTXchDocNo = @ptDocNo 
	
	IF @tStaPrc <> '1'
	BEGIN
		INSERT INTO @TTmpPrcCost(FTBchCode,FTPdtCode,FCPdtCostEx,FCPdtCostIn,FCPdtQty,FCPdtVat,FCPdtCostAmt)
		SELECT FTBchCode,FTPdtCode,FCXcdCostNew,0,0,0,0
		FROM TCNTPdtAdjCostDT
		WHERE FTBchCode = @ptBchCode AND FTXchDocNo = @ptDocNo 

		-- Get Qty
		UPDATE @TTmpPrcCost
		SET FCPdtQty = ISNULL(BAL.FCStkQty,0)
		FROM @TTmpPrcCost TMP
		--INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty 
		--			FROM TCNTPdtStkBal WITH(NOLOCK) 
		--			WHERE FTBchCode = @ptBchCode
		--			GROUP BY FTBchCode,FTPdtCode) BAL ON BAL.FTPdtCode = TMP.FTPdtCode
		INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty 
					FROM TCNTPdtStkBal WITH(NOLOCK) 
					GROUP BY FTPdtCode) BAL ON BAL.FTPdtCode = TMP.FTPdtCode	-- 06.01.00 --

		-- Get Vat
		UPDATE @TTmpPrcCost
		SET FCPdtVat = ISNULL((SELECT TOP 1 FCVatRate FROM TCNMVatRate WITH(NOLOCK) WHERE FTVatCode = PDT.FTVatCode AND FDVatStart < GETDATE() ORDER BY FDVatStart DESC),0)
		FROM @TTmpPrcCost TMP
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = TMP.FTPdtCode

		-- คำนวณ CostIn และ CostAmt
		UPDATE @TTmpPrcCost
		SET FCPdtCostIn = ROUND(FCPdtCostEx + ((FCPdtCostEx * FCPdtVat)/100),@nDec)
		, FCPdtCostAmt = ROUND(CASE WHEN FCPdtQty < 0 THEN 0 ELSE FCPdtCostEx * FCPdtQty END,@nDec) 

		-- update รายการที่มีแล้ว
		UPDATE TCNMPdtCostAvg
		SET FCPdtCostEx = TMP.FCPdtCostEx
		, FCPdtCostIn = TMP.FCPdtCostIn
		, FCPdtCostAmt = TMP.FCPdtCostAmt
		, FCPdtQtyBal = TMP.FCPdtQty
		, FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcCost TMP ON TMP.FTPdtCode = COST.FTPdtCode

		-- insert รายการที่ยังไม่มี
		INSERT INTO TCNMPdtCostAvg(FTPdtCode,FCPdtCostEx,FCPdtCostIn,FCPdtQtyBal,FCPdtCostAmt,FCPdtCostLast,FDLastUpdOn)
		SELECT TMP.FTPdtCode,TMP.FCPdtCostEx,TMP.FCPdtCostIn,TMP.FCPdtQty,TMP.FCPdtCostAmt,0,GETDATE()
		FROM @TTmpPrcCost TMP
		LEFT JOIN TCNMPdtCostAvg COST WITH(NOLOCK) ON COST.FTPdtCode = TMP.FTPdtCode
		WHERE COST.FTPdtCode IS NULL

	END	
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxPrcStkPdtSet')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxPrcStkPdtSet
GO
CREATE PROCEDURE [dbo].STP_DOCxPrcStkPdtSet
 @ptDocNo VARCHAR(20)
,@pdStkDate DATETIME
,@ptPdtCode VARCHAR(20)
,@pcQty DECIMAL(18,4)
,@ptStkType VARCHAR(1)	-- 1:รับเข้า 2:เบิกออก 3:ขาย 4:คืน 5:ปรับสต๊อก
,@ptBchCode VARCHAR(5)
,@ptWahCode VARCHAR(5)
,@ptWho VARCHAR(50)
,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @tStaPrcStkTo varchar(1)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FTPdtParent varchar(20),
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
05.01.00	29/10/2020		Em		create  
06.01.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcStkSet'
BEGIN TRY
	BEGIN TRANSACTION @tTrans 

	SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						WHERE WAH.FTBchCode = @ptBchCode AND WAH.FTWahCode = @ptWahCode)
	IF (@tStaPrcStkTo = '2')
	BEGIN
		--insert data to Temp
		INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FTPdtParent,FCStkCostIn,FCStkCostEx)
		SELECT @ptBchCode,@ptDocNo,@ptStkType,PS.FTPdtCodeSet,
			(PS.FCPstQty * PS.FCXsdFactor * @pcQty),@ptWahCode,@pdStkDate,
			0 AS FCStkSetPrice,@ptPdtCode,
			0 AS FCStkCostIn,0 AS FCStkCostEx
		FROM TCNTPdtSet PS WITH(NOLOCK)
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = PS.FTPdtCodeSet AND PDT.FTPdtStkControl = '1'
		WHERE PS.FTPdtCode = @ptPdtCode

		INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
		SELECT DISTINCT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,0 AS FCStkQty,
		GETDATE() AS FDLastUpdOn,@ptWho,
		GETDATE() AS FDCreateOn,@ptWho
		FROM @TTmpPrcStk TMP
		LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON TMP.FTBchCode = STK.FTBchCode AND TMP.FTWahCode = STK.FTWahCode AND TMP.FTPdtCode = STK.FTPdtCode
		WHERE ISNULL(STK.FTPdtCode,'') = ''	

		IF(@ptStkType = '1' OR @ptStkType = '4' OR @ptStkType = '5')
		BEGIN
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = STK.FCStkQty + ISNULL(TMP.FCStkQty,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho
			FROM TCNTPdtStkBal STK
			INNER JOIN @TTmpPrcStk TMP ON TMP.FTBchCode = STK.FTBchCode AND TMP.FTWahCode = STK.FTWahCode AND TMP.FTPdtCode = STK.FTPdtCode	

			-- 06.01.00 --
			--Cost
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
			,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			-- 06.01.00 --
		END

		IF(@ptStkType = '2' OR @ptStkType = '3')
		BEGIN
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = STK.FCStkQty - ISNULL(TMP.FCStkQty,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho
			FROM TCNTPdtStkBal STK
			INNER JOIN @TTmpPrcStk TMP ON TMP.FTBchCode = STK.FTBchCode AND TMP.FTWahCode = STK.FTWahCode AND TMP.FTPdtCode = STK.FTPdtCode	

			-- 06.01.00 --
			--Cost
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*COST.FCPdtCostEx)
			,FCPdtQtyBal = FCPdtQtyBal - TMP.FCStkQty	
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			-- 06.01.00 --
		END

		--insert to stock card
		INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FTPdtParent,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
		SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FTPdtParent,FCStkCostIn,FCStkCostEx,
		GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM @TTmpPrcStk

	END
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans
    SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxPurchaseCNPrc')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxPurchaseCNPrc
GO
CREATE PROCEDURE [dbo].STP_DOCxPurchaseCNPrc
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tDate varchar(10)
DECLARE @tTime varchar(8)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5),	-- 3. --
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)		-- 2. --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	17/06/2018		Em		create  
00.02.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร
00.03.00	24/07/2019		Em		แก้ไขขนาดฟิลด์ Branch จาก 3 เป็น 5
00.04.00	30/07/2019		Em		เพิ่ม Insert StkBal และคำนวณต้นทุน
00.05.00	31/07/2019		Em		แก้ไขการปรับสต๊อก
04.01.00	20/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
05.02.00	30/03/2021		Em		แก้ไขให้ตรวจสอบจำนวนที่เป็น 0
06.01.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
BEGIN TRY
	SET @tDate = CONVERT(VARCHAR(10),GETDATE(),121)
	SET @tTime = CONVERT(VARCHAR(8),GETDATE(),108)
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXphStaPrcStk,'') AS FTXphStaPrcStk FROM TAPTPcHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXphDocNo = @ptDocNo)	-- 2. --

	IF @tStaPrc <> '1'	-- 2. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TAPTPcHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTWahCode = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXphDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT @ptDocNo AS FTComName,HD.FTBchCode,HD.FTXphDocNo AS FTStkDocNo
			,'2' AS FTStkType
			,DT.FTPdtCode AS FTPdtStkCode
			, SUM(FCXpdQtyAll) AS FCStkQty,HD.FTWahCode AS FTWahCode,HD.FDXphDocDate AS FDStkDate
			, ROUND(SUM(DT.FCXpdNet)/SUM(FCXpdQtyAll),4) AS FCStkSetPrice
			, ROUND(SUM(DT.FCXpdCostIn)/SUM(FCXpdQtyAll),4) AS FCStkCostIn
			, ROUND(SUM(DT.FCXpdCostEx)/SUM(FCXpdQtyAll),4) AS FCStkCostEx
			FROM TAPTPcDT DT with(nolock)
			INNER JOIN TAPTPcHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXphDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXphDocNo,HD.FNXphDocType,DT.FTPdtCode,HD.FDXphDocDate

			--insert data to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk
			WHERE FTComName = @ptDocNo

			--update qty to stock balance
			UPDATE TCNTPdtStkBal with(rowlock) 
			--SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
			SET FCStkQty= BAL.FCStkQty - TMP.FCStkQty	-- 5. --
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho
			FROM TCNTPdtStkBal BAL 
			INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
			WHERE TMP.FTComName=@ptDocNo 
			AND ISNULL(TMP.FCStkQty,0)<>0

			-- 4. --
			--insert to Stock balance
			INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
			SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty*(-1),GETDATE(),@ptWho,GETDATE(),@ptWho
			FROM @TTmpPrcStk TMP
			LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
			WHERE ISNULL(BAL.FTPdtCode,'') = ''
			-- 4. --

			-- 4. --
			--Cost
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*TMP.FCStkCostEx)
			--,FCPdtCostEx = ROUND((ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*TMP.FCStkCostEx)) / STK.FCStkQty,2)
			--,FCPdtCostEx = (CASE WHEN ISNULL(STK.FCStkQty,0) = 0 THEN FCPdtCostEx ELSE ROUND((ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*TMP.FCStkCostEx)) / STK.FCStkQty,2) END) -- 05.02.00 --
			,FCPdtCostEx = (CASE WHEN (FCPdtQtyBal - ISNULL(TMP.FCStkQty,0)) = 0 THEN FCPdtCostEx ELSE ROUND(((ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*TMP.FCStkCostEx))/(FCPdtQtyBal - ISNULL(TMP.FCStkQty,0))),4) END) -- 06.01.00 --
			,FCPdtCostLast = TMP.FCStkCostEx
			--,FCPdtQtyBal = STK.FCStkQty
			,FCPdtQtyBal = FCPdtQtyBal - TMP.FCStkQty	-- 06.01.00 --
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			--INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode
			-- 5. --
			--INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
		
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostIn = ROUND(ISNULL(FCPdtCostEx,0) + (ISNULL(FCPdtCostEx,0) * VAT.FCVatRate/100),4) 
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			INNER JOIN TCNMPdt PDT with(nolock) ON COST.FTPdtCode = PDT.FTPdtCode
			INNER JOIN (
				SELECT FTVatCode,MAX(FDVatStart) AS FDVatStart 
				FROM TCNMVatRate with(nolock) 
				WHERE CONVERT(VARCHAR(10),FDVatStart,121) < CONVERT(VARCHAR(10),GETDATE(),121) 
				GROUP BY FTVatCode) VATT ON PDT.FTVatCode = VATT.FTVatCode
			INNER JOIN TCNMVatRate VAT with(nolock) ON VATT.FTVatCode = VAT.FTVatCode AND VATT.FDVatStart = VAT.FDVatStart
			-- 5. --
		END

	END	-- 2. --
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxPurchaseInvPrc')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxPurchaseInvPrc
GO
CREATE PROCEDURE [dbo].STP_DOCxPurchaseInvPrc
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tDate varchar(10)
DECLARE @tTime varchar(8)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5),	-- 3. -- 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,2), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,2),
   FCStkCostIn decimal(18,2),
   FCStkCostEx decimal(18,2)
   ) 
DECLARE @tStaPrc varchar(1)		-- 2. --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
DECLARE @tTrans varchar(20)
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	12/06/2018		Em		create 
00.02.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร 
00.03.00	24/07/2019		Em		แก้ไขขนาดฟิลด์ Branch จาก 3 เป็น 5
00.04.00	30/07/2019		Em		เพิ่ม Insert StkBal และปรับต้นทุน
00.05.00	31/07/2019		Em		แก้ไขการปรับต้นทุน
04.01.00	20/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
05.02.00	30/03/2021		Em		แก้ไขให้ตรวจสอบจำนวนที่เป็น 0
06.01.00	20/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
06.03.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcStk'
BEGIN TRY
	BEGIN TRANSACTION @tTrans
	SET @tDate = CONVERT(VARCHAR(10),GETDATE(),121)
	SET @tTime = CONVERT(VARCHAR(8),GETDATE(),108)
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXphStaPrcStk,'') AS FTXphStaPrcStk FROM TAPTPiHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXphDocNo = @ptDocNo)	-- 2. --

	IF @tStaPrc <> '1'	-- 2. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TAPTPiHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTWahCode = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXphDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXphDocNo AS FTStkDocNo
			,'1' AS FTStkType
			,DT.FTPdtCode AS FTPdtStkCode
			, SUM(FCXpdQtyAll) AS FCStkQty,HD.FTWahCode AS FTWahCode,HD.FDXphDocDate AS FDStkDate
			, ROUND(SUM(DT.FCXpdNet)/SUM(FCXpdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXpdCostIn)/SUM(FCXpdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXpdCostEx)/SUM(FCXpdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TAPTPiDT DT with(nolock)
			INNER JOIN TAPTPiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXphDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXphDocNo,HD.FNXphDocType,DT.FTPdtCode,HD.FDXphDocDate

			--insert data to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk

			--update qty to stock balance
			UPDATE TCNTPdtStkBal with(rowlock) 
			SET FCStkQty= BAL.FCStkQty + TMP.FCStkQty
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho
			FROM TCNTPdtStkBal BAL
			INNER JOIN @TTmpPrcStk TMP ON BAL.FTPdtCode =TMP.FTPdtCode AND BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode
			AND ISNULL(TMP.FCStkQty,0) <> 0

			-- 4. --
			--insert to Stock balance
			INSERT INTO TCNTPdtStkBal with(rowlock)(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
			SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty,GETDATE(),@ptWho,GETDATE(),@ptWho
			FROM @TTmpPrcStk TMP
			LEFT JOIN TCNTPdtStkBal BAL with(NOLOCK) ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTWahCode = BAL.FTWahCode AND TMP.FTPdtCode = BAL.FTPdtCode
			WHERE ISNULL(BAL.FTPdtCode,'') = ''
			-- 4. --

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TAPTPiDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXphDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXphDocNo AS FTStkDocNo
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXpdQty * DT.FCXpdFactor) AS FCStkQty,HD.FTWahCode AS FTWahCode,HD.FDXphDocDate AS FDStkDate
				, ROUND(SUM(DT.FCXpdNet)/SUM(DT.FCXpdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXpdCostIn)/SUM(DT.FCXpdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXpdCostEx)/SUM(DT.FCXpdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TAPTPiDT DT with(nolock)
				INNER JOIN TAPTPiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo
				INNER JOIN TAPTPiDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXphDocNo = DTF.FTXphDocNo AND DT.FNXpdSeqNo = DTF.FNXpdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXphDocNo =@ptDocNo
				AND ISNULL(DT.FTXpdStaPrcStk,'') = ''	-- 02.01.00 --
				AND ISNULL(HD.FTWahCode,'') <> ''	-- 02.01.00 --
				GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXphDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXphDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --

			-- 4. --
			--Cost
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*TMP.FCStkCostEx)
			--,FCPdtCostEx = ROUND((ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*TMP.FCStkCostEx)) / STK.FCStkQty,2)
			--,FCPdtCostEx = (CASE WHEN ISNULL(STK.FCStkQty,0) = 0 THEN FCPdtCostEx ELSE ROUND((ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*TMP.FCStkCostEx)) / STK.FCStkQty,4) END) -- 05.02.00 -- -- 06.02.00 --
			,FCPdtCostEx = (CASE WHEN (FCPdtQtyBal + ISNULL(TMP.FCStkQty,0)) = 0 THEN FCPdtCostEx ELSE ROUND(((ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*TMP.FCStkCostEx)) / (FCPdtQtyBal + ISNULL(TMP.FCStkQty,0))),4) END) -- 06.03.00 --
			,FCPdtCostLast = TMP.FCStkCostEx
			--,FCPdtQtyBal = STK.FCStkQty
			,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty-- 06.03.00 --
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			--INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode
			-- 5. --
			--INNER JOIN (SELECT FTPdtCode,SUM(FCStkQty) AS FCStkQty FROM TCNTPdtStkBal with(nolock) WHERE FTBchCode = @ptBchCode GROUP BY FTPdtCode) STK ON COST.FTPdtCode = STK.FTPdtCode
		
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostIn = ROUND(ISNULL(FCPdtCostEx,0) + (ISNULL(FCPdtCostEx,0) * VAT.FCVatRate/100),4)	-- 06.02.00 --
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			INNER JOIN TCNMPdt PDT with(nolock) ON COST.FTPdtCode = PDT.FTPdtCode
			INNER JOIN (
				SELECT FTVatCode,MAX(FDVatStart) AS FDVatStart 
				FROM TCNMVatRate with(nolock) 
				WHERE CONVERT(VARCHAR(10),FDVatStart,121) < CONVERT(VARCHAR(10),GETDATE(),121) 
				GROUP BY FTVatCode) VATT ON PDT.FTVatCode = VATT.FTVatCode
			INNER JOIN TCNMVatRate VAT with(nolock) ON VATT.FTVatCode = VAT.FTVatCode AND VATT.FDVatStart = VAT.FDVatStart
			-- 5. --

			INSERT INTO TCNMPdtCostAvg(FTPdtCode,FCPdtCostEx,FCPdtCostIn,FCPdtCostLast,FCPdtCostAmt,FCPdtQtyBal,FDLastUpdOn)
			SELECT TMP.FTPdtCode,FCStkCostEx,FCStkCostIn,FCStkCostEx,(FCStkQty*FCStkCostEx) AS FCStkCostAmt,FCStkQty,GETDATE()
			FROM @TTmpPrcStk TMP
			LEFT JOIN TCNMPdtCostAvg COST with(nolock) ON TMP.FTPdtCode = COST.FTPdtCode
			WHERE ISNULL(COST.FTPdtCode,'') = ''
			-- 4. --
		END
		
		-- 5. --
		UPDATE TCNMPdtSpl with(rowlock)
		SET FCSplLastPrice = DT.FCXpdSetPrice
		FROM TCNMPdtSpl SPL
		INNER JOIN TAPTPiHD HD with(nolock) ON SPL.FTSplCode = HD.FTSplCode
		INNER JOIN TAPTPiDT DT with(nolock) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXphDocNo = DT.FTXphDocNo AND SPL.FTPdtCode = DT.FTPdtCode AND SPL.FTBarCode = DT.FTXpdBarCode
		WHERE HD.FTBchCode=@ptBchCode AND HD.FTXphDocNo =@ptDocNo
		-- 5. --
	END		-- 2. --
	
	COMMIT TRANSACTION @tTrans
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    ROLLBACK TRANSACTION @tTrans
	SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxRefundPrcStk')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxRefundPrcStk
GO
CREATE PROCEDURE [dbo].STP_DOCxRefundPrcStk
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tDate varchar(10)
DECLARE @tTime varchar(8)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5),	
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCXsdSetPrice decimal(18,4),
   FCXsdCostIn decimal(18,4),
   FCXsdCostEx decimal(18,4)
   ) 
DECLARE @tTrans varchar(20)
DECLARE @tStaPrc varchar(1)
DECLARE @tBchTo varchar(5)
DECLARE @tWahTo varchar(5)
DECLARE @tDocRef varchar(30)
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
04.01.00	19/10/2020		Em		Create
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
06.01.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcStk'
BEGIN TRY
	BEGIN TRANSACTION @tTrans
	SET @tDate = CONVERT(VARCHAR(10),GETDATE(),121)
	SET @tTime = CONVERT(VARCHAR(8),GETDATE(),108)
	SELECT TOP 1 @tStaPrc = ISNULL(FTXshStaPrcStk,''),@tDocRef = ISNULL(FTXshRefInt,'') 
	FROM TPSTSalHD with(nolock) 
	WHERE FTBchCode = @ptBchCode AND FTXshDocNo = @ptDocNo

	
	IF @tStaPrc <> '1'	-- 4. --
	BEGIN
		IF ISNULL(@tDocRef,'') = '' BEGIN
			SELECT @tBchTo = ISNULL(FTBchCode,''),@tWahTo = ISNULL(FTWahCode,'')
			FROM TPSTSalHD with(nolock) 
			WHERE FTBchCode = @ptBchCode AND FTXshDocNo = @ptDocNo
		END
		ELSE
		BEGIN
			SELECT @tBchTo = ISNULL(FTBchCode,''),@tWahTo = ISNULL(FTWahCode,'')
			FROM TPSTSalHD with(nolock) 
			WHERE FTXshDocNo = @tDocRef
		END

		SET @tStaPrc = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						WHERE WAH.FTBchCode = @tBchTo AND WAH.FTWahCode = @tWahTo)

		IF @tStaPrc = '2'
		BEGIN
			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCXsdSetPrice,FCXsdCostIn,FCXsdCostEx)		--3.--
			SELECT @tBchTo AS FTBchCode,HD.FTXshDocNo AS FTStkDocNo
			, '4' AS FTStkType
			,DT.FTPdtCode		--3.--
			, SUM(DT.FCXsdQtyAll) AS FCStkQty,@tWahTo AS FTWahCode,HD.FDXshDocDate AS FDStkDate
			, DT.FCXsdSetPrice
			,ROUND(DT.FCXsdCostIn/SUM(DT.FCXsdQtyAll),4) AS FCXsdCostIn
			,ROUND(DT.FCXsdCostEx/SUM(DT.FCXsdQtyAll),4) AS FCXsdCostEx
			FROM TPSTSalDT DT with(nolock)
			INNER JOIN TPSTSalHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --	
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXshDocNo =@ptDocNo
			AND ISNULL(FTXsdStaPdt,'')NOT IN('4','5')
			GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXshDocNo,HD.FNXshDocType,DT.FTPdtCode,HD.FDXshDocDate,DT.FCXsdSetPrice,DT.FCXsdCostIn,DT.FCXsdCostEx		--3.--

			--update Stk balance
			UPDATE TCNTPdtStkBal with(rowlock)
			SET FCStkQty = ISNULL(STK.FCStkQty,0) + TMP.FCStkQty
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho
			FROM TCNTPdtStkBal STK
			INNER JOIN @TTmpPrcStk TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode		--3.--

			-- 6. --
			INSERT INTO TCNTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
			SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FCStkQty AS FCStkQty,
			GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
			FROM @TTmpPrcStk TMP
			LEFT JOIN TCNTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode
			WHERE ISNULL(BAL.FTPdtCode,'') = ''
			-- 6. --

			--insert stk card
			INSERT INTO TCNTPdtStkCrd( FTBchCode, FDStkDate, FTStkDocNo, FTWahCode, FTPdtCode, FTStkType, FCStkQty, FCStkSetPrice, FCStkCostIn, FCStkCostEx, FDCreateOn, FTCreateBy)		--3.--
			SELECT  FTBchCode, FDStkDate, FTStkDocNo, FTWahCode, FTPdtCode, FTStkType, FCStkQty, FCXsdSetPrice, FCXsdCostIn, FCXsdCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
			FROM @TTmpPrcStk

			-- 06.01.00 --
			--Cost
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*FCPdtCostEx)
			,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			-- 06.01.00 --
		END
	END -- 4. --
	COMMIT TRANSACTION @tTrans
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
	ROLLBACK TRANSACTION @tTrans
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxSalePrcStk')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxSalePrcStk
GO
CREATE PROCEDURE [dbo].STP_DOCxSalePrcStk
 @ptBchCode varchar(5)	-- 5. --
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tDate varchar(10)
DECLARE @tTime varchar(8)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4),
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCXsdSetPrice decimal(18,4),
   FCXsdCostIn decimal(18,4),
   FCXsdCostEx decimal(18,4)
   ) 
DECLARE @tTrans varchar(20)
DECLARE @tStaPrc varchar(1)		-- 4. --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	22/02/2019		Em		create  
00.02.00	22/04/2019		Em		แก้ไขในส่วนของการตัดสต๊อก Vending
00.03.00	17/06/2019		Em		เอาฟิลด์ StkCode ออก
00.04.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร 
00.05.00	25/07/2019		Em		ปรับขนาดฟิลด์ Branch จาก 3 เป็น 5 และเอา Process Vending ออก
00.06.00	19/09/2019		Em		เพิ่มการ Insert ลงตาราง StkBal กรณีที่ยังไม่มีรายการอัพเดท
04.01.00	19/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	14/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	30/04/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcStk'
BEGIN TRY
	BEGIN TRANSACTION @tTrans
	SET @tDate = CONVERT(VARCHAR(10),GETDATE(),121)
	SET @tTime = CONVERT(VARCHAR(8),GETDATE(),108)
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXshStaPrcStk,'') FROM TPSTSalHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXshDocNo = @ptDocNo)	-- 4. --

	IF @tStaPrc <> '1'	-- 4. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		-- 04.01.00 --
		SET @tStaPrc = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TPSTSalHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTWahCode = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXshDocNo = @ptDocNo)

		IF @tStaPrc = '2'
		-- 04.01.00 --
		BEGIN
			--insert data to Temp
			--INSERT INTO @TTmpPrcStk (FTComName,FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FTPdtStkCode,FCStkQty,FTWahCode,FDStkDate,FCXsdSetPrice,FCXsdCostIn,FCXsdCostEx)
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCXsdSetPrice,FCXsdCostIn,FCXsdCostEx)		--3.--
			SELECT HD.FTBchCode,HD.FTXshDocNo AS FTStkDocNo
			,CASE WHEN HD.FNXshDocType='1'THEN '3' ELSE '4' END AS FTStkType
			--,FTPdtCode,FTXsdStkCode AS FTPdtStkCode
			,DT.FTPdtCode		--3.--
			, SUM(DT.FCXsdQtyAll) AS FCStkQty,FTWahCode AS FTWahCode,HD.FDXshDocDate AS FDStkDate
			,ROUND(SUM(DT.FCXsdNet)/SUM(DT.FCXsdQtyAll),4) AS FCXsdSetPrice
			,ROUND(SUM(DT.FCXsdCostIn)/SUM(DT.FCXsdQtyAll),4) AS FCXsdCostIn
			,ROUND(SUM(DT.FCXsdCostEx)/SUM(DT.FCXsdQtyAll),4) AS FCXsdCostEx
			FROM TPSTSalDT DT with(nolock)
			INNER JOIN TPSTSalHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXshDocNo =@ptDocNo
			AND ISNULL(FTXsdStaPdt,'')NOT IN('4','5')
			--GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXshDocNo,HD.FNXshDocType,DT.FTPdtCode,DT.FTXsdStkCode,HD.FDXshDocDate,DT.FCXsdSetPrice,DT.FCXsdCostIn,DT.FCXsdCostEx
			GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXshDocNo,HD.FNXshDocType,DT.FTPdtCode,HD.FDXshDocDate		--3.--

			--update Stk balance
			UPDATE TCNTPdtStkBal with(rowlock)
			SET FCStkQty = ISNULL(STK.FCStkQty,0) + (CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho
			FROM TCNTPdtStkBal STK
			--INNER JOIN @TTmpPrcStk TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtStkCode = TMP.FTPdtStkCode
			INNER JOIN @TTmpPrcStk TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode		--3.--

			-- 6. --
			INSERT INTO TCNTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
			SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,(CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END) AS FCStkQty,
			GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
			FROM @TTmpPrcStk TMP
			LEFT JOIN TCNTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode
			WHERE ISNULL(BAL.FTPdtCode,'') = ''
			-- 6. --

			--insert stk card
			--INSERT INTO TCNTPdtStkCrd( FTBchCode, FDStkDate, FTStkDocNo, FTWahCode, FTPdtStkCode, FTStkType, FCStkQty, FCStkSetPrice, FCStkCostIn, FCStkCostEx, FDCreateOn, FTCreateBy)
			--SELECT  FTBchCode, FDStkDate, FTStkDocNo, FTWahCode, FTPdtStkCode, FTStkType, FCStkQty, FCXsdSetPrice, FCXsdCostIn, FCXsdCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy
			INSERT INTO TCNTPdtStkCrd( FTBchCode, FDStkDate, FTStkDocNo, FTWahCode, FTPdtCode, FTStkType, FCStkQty, FCStkSetPrice, FCStkCostIn, FCStkCostEx, FDCreateOn, FTCreateBy)		--3.--
			SELECT  FTBchCode, FDStkDate, FTStkDocNo, FTWahCode, FTPdtCode, FTStkType, FCStkQty, FCXsdSetPrice, FCXsdCostIn, FCXsdCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
			FROM @TTmpPrcStk

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TPSTSalDTFhn WHERE FTBchCode = @ptBchCode AND FTXshDocNo = @ptDocNo) BEGIN
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)		--3.--
				SELECT HD.FTBchCode,HD.FTXshDocNo AS FTStkDocNo
				,CASE WHEN HD.FNXshDocType='1'THEN '3' ELSE '4' END AS FTStkType
				,DT.FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXsdQty * DT.FCXsdFactor) AS FCStkQty,FTWahCode AS FTWahCode,HD.FDXshDocDate AS FDStkDate
				,ROUND(SUM(DT.FCXsdNet)/SUM(DTF.FCXsdQty * DT.FCXsdFactor),4) AS FCXsdSetPrice
				,ROUND(SUM(DT.FCXsdCostIn)/SUM(DTF.FCXsdQty * DT.FCXsdFactor),4) AS FCXsdCostIn
				,ROUND(SUM(DT.FCXsdCostEx)/SUM(DTF.FCXsdQty * DT.FCXsdFactor),4) AS FCXsdCostEx
				FROM TPSTSalDT DT with(nolock)
				INNER JOIN TPSTSalDTFhn DTF with(nolock) ON DTF.FTBchCode = DT.FTBchCode AND DTF.FTXshDocNo = DT.FTXshDocNo AND DTF.FNXsdSeqNo = DT.FNXsdSeqNo
				INNER JOIN TPSTSalHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXshDocNo =@ptDocNo
				AND ISNULL(FTXsdStaPdt,'')NOT IN('4','5')
				GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXshDocNo,HD.FNXshDocType,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXshDocDate		--3.--

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--update Stk balance
					UPDATE TFHTPdtStkBal with(rowlock)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + (CASE WHEN TMP.FTStfType = '4' THEN TMP.FCStfQty ELSE TMP.FCStfQty *(-1) END)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode	

					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,(CASE WHEN TMP.FTStfType = '4' THEN TMP.FCStfQty ELSE TMP.FCStfQty *(-1) END) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --

			-- 06.02.00 --
			--Cost
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + ((CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END)*FCPdtCostEx)
			,FCPdtQtyBal = FCPdtQtyBal + (CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END)
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			-- 06.02.00 --
		END
	END -- 4. --
	COMMIT TRANSACTION @tTrans
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
	ROLLBACK TRANSACTION @tTrans
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxSaleVDPrcStk')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxSaleVDPrcStk
GO
CREATE PROCEDURE [dbo].STP_DOCxSaleVDPrcStk
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tDate varchar(10)
DECLARE @tTime varchar(8)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty float, 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCXsdSetPrice decimal(18,4),
   FCXsdCostIn decimal(18,4),
   FCXsdCostEx decimal(18,4)
   ) 
DECLARE @tTrans varchar(20)
DECLARE @tStaPrc varchar(1)
DECLARE @tPosName varchar(50)		-- 3. --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
/*---------------------------------------------------------------------
Document History
  Version	Date			User	Remark
00.01.00	25/07/2019		Em		create  
00.02.00	19/08/2019		Em		หารายการถึงจุดที่ต้องเติมสินค้า
00.03.00	20/08/2019		Em		หาชื่อเครื่อง POS
00.04.00	20/09/2019		Em		ปรับปรุงแก้ไข
02.01.00	28/01/2020		Em		ปรับโครงสร้างตารางใหม่
02.02.00	18/02/2020		Em		เปลี่ยนการตรวจสอบจาก PdtSpcBch เป็น PdtSpcWah
04.01.00	21/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	03/12/2020		Em		ถ้าไม่มีรายการให้เพิ่มรายการใน StkBal
05.02.00	14/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcStk'
BEGIN TRY
	BEGIN TRANSACTION @tTrans
	SET @tDate = CONVERT(VARCHAR(10),GETDATE(),121)
	SET @tTime = CONVERT(VARCHAR(8),GETDATE(),108)
	SET @tStaPrc = ISNULL((SELECT TOP 1 ISNULL(FTXshStaPrcStk,'') AS FTXshStaPrcStk FROM TVDTSalHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXshDocNo = @ptDocNo),'')
	SET @tPosName = ISNULL((SELECT TOP 1 FTPosRegNo FROM TCNMPos POS WITH(NOLOCK) 
					INNER JOIN TVDTSalHD SAL WITH(NOLOCK) ON SAL.FTPosCode = POS.FTPosCode AND SAL.FTBchCode = @ptBchCode AND SAL.FTXshDocNo = @ptDocNo),'')

	IF @tStaPrc <> '1'	-- 4. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		IF EXISTS(SELECT TOP 1 FTXshDocNo FROM TVDTSalDTVD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXshDocNo = @ptDocNo) BEGIN
			-- 04.04.00 --
			SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
							INNER JOIN TVDTSalHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTWahCode = WAH.FTWahCode
							WHERE HD.FTBchCode = @ptBchCode AND HD.FTXshDocNo = @ptDocNo)

			IF @tStaPrcStkTo = '2'
			BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCXsdSetPrice,FCXsdCostIn,FCXsdCostEx)
				SELECT HD.FTBchCode,HD.FTXshDocNo AS FTStkDocNo
				,CASE WHEN HD.FNXshDocType='1'THEN '3' ELSE '4' END AS FTStkType
				,DT.FTPdtCode
				, SUM(DT.FCXsdQtyAll) AS FCStkQty,HD.FTWahCode AS FTWahCode,HD.FDXshDocDate AS FDStkDate
				--, SUM(DT.FCXsdQtyAll) AS FCStkQty,VD.FTWahCode AS FTWahCode,HD.FDXshDocDate AS FDStkDate		-- 5. --
				,ROUND(SUM(DT.FCXsdNet)/SUM(DT.FCXsdQtyAll),4) AS FCXsdSetPrice
				,ROUND(SUM(DT.FCXsdCostIn)/SUM(DT.FCXsdQtyAll),4) AS FCXsdCostIn
				,ROUND(SUM(DT.FCXsdCostEx)/SUM(DT.FCXsdQtyAll),4) AS FCXsdCostEx
				FROM TVDTSalDT DT with(nolock)
				INNER JOIN TVDTSalHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
				--INNER JOIN TVDTSalDTVD VD with(nolock) ON DT.FTBchCode = VD.FTBchCode AND DT.FNXsdSeqNo = VD.FNXsdSeqNo AND ISNULL(VD.FTXsvStaPayItem,'2') = '1'
				INNER JOIN TVDTSalDTVD VD with(nolock) ON DT.FTBchCode = VD.FTBchCode AND DT.FTXshDocNo = VD.FTXshDocNo AND DT.FNXsdSeqNo = VD.FNXsdSeqNo AND ISNULL(VD.FTXsvStaPayItem,'2') = '1'	-- 4. --
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXshDocNo = @ptDocNo
				AND ISNULL(FTXsdStaPdt,'')NOT IN('4','5')
				GROUP BY HD.FTBchCode,HD.FTXshDocNo,HD.FNXshDocType,DT.FTPdtCode,HD.FTWahCode,HD.FDXshDocDate
				--GROUP BY HD.FTBchCode,HD.FTXshDocNo,HD.FNXshDocType,DT.FTPdtCode,VD.FTWahCode,HD.FDXshDocDate, DT.FCXsdSetPrice,DT.FCXsdCostIn,DT.FCXsdCostEx	-- 5. --

				-- 05.01.00 --
				INSERT INTO TCNTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
				SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,0 AS FCStkQty
						,GETDATE(),@ptWho,GETDATE(),@ptWho
				FROM @TTmpPrcStk TMP
				LEFT JOIN TCNTPdtStkBal STK ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode
				WHERE ISNULL(STK.FTPdtCode,'') = ''	
				-- 05.01.00 --

				--update Stk balance
				UPDATE TCNTPdtStkBal with(rowlock)
				SET FCStkQty = ISNULL(STK.FCStkQty,0) + (CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END)
				,FDLastUpdOn = GETDATE()
				,FTLastUpdBy = @ptWho
				FROM TCNTPdtStkBal STK
				INNER JOIN @TTmpPrcStk TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode	

				--insert stk card
				INSERT INTO TCNTPdtStkCrd( FTBchCode, FDStkDate, FTStkDocNo, FTWahCode, FTPdtCode, FTStkType, FCStkQty, FCStkSetPrice, FCStkCostIn, FCStkCostEx, FDCreateOn, FTCreateBy)
				SELECT  FTBchCode, FDStkDate, FTStkDocNo, FTWahCode, FTPdtCode, FTStkType, FCStkQty, FCXsdSetPrice, FCXsdCostIn, FCXsdCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy
				FROM @TTmpPrcStk

				--update stk balance vending
				-- 05.01.00 --
				INSERT INTO TVDTPdtStkBal(FTBchCode,FTWahCode,FNCabSeq,FNLayRow,FNLayCol,FTPdtCode,FCStkQty,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
				SELECT TMP.FTBchCode,TMP.FTWahCode, VDT.FNCabSeq,VDT.FNLayRow,VDT.FNLayCol,TMP.FTPdtCode,0 AS FCStkQty
						,GETDATE(),@ptWho,GETDATE(),@ptWho
				FROM @TTmpPrcStk TMP
				INNER JOIN TVDTSalDTVD VDT with(nolock) ON TMP.FTBchCode = VDT.FTBchCode AND TMP.FTStkDocNo = VDT.FTXshDocNo AND TMP.FTPdtCode = VDT.FTPdtCode
						AND ISNULL(VDT.FTXsvStaPayItem,'2') = '1'
				LEFT JOIN TVDTPdtStkBal STK ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode
						AND STK.FNLayRow = VDT.FNLayRow AND STK.FNLayCol = VDT.FNLayCol 
				WHERE ISNULL(STK.FTPdtCode,'') = ''	
				-- 05.01.00 --

				UPDATE TVDTPdtStkBal with(rowlock)
				SET FCStkQty = ISNULL(STK.FCStkQty,0) + (CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END)
				,FDLastUpdOn = GETDATE()
				,FTLastUpdBy = @ptWho
				FROM TVDTPdtStkBal STK
				INNER JOIN @TTmpPrcStk TMP  ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode		--3.--
				INNER JOIN TVDTSalDTVD VDT with(nolock) ON TMP.FTBchCode = VDT.FTBchCode AND TMP.FTStkDocNo = VDT.FTXshDocNo AND TMP.FTPdtCode = VDT.FTPdtCode
						AND STK.FNLayRow = VDT.FNLayRow AND STK.FNLayCol = VDT.FNLayCol AND ISNULL(VDT.FTXsvStaPayItem,'2') = '1'

				-- 2. --
				SELECT @tPosName AS FTPosName,BAL.FTPdtCode,BAL.FNLayRow,BAL.FNLayCol,BAL.FCStkQty	-- 3.--
				FROM TVDTPdtStkBal BAL WITH(NOLOCK)
				INNER JOIN
					(SELECT BAL.FTBchCode,BAL.FTWahCode,BAL.FTPdtCode
					--FROM TCNMPdtSpcBch PDT WITH(NOLOCK)
					FROM TCNMPdtSpcWah PDT WITH(NOLOCK)		-- 6. --
					INNER JOIN (SELECT FTBchCode,FTWahCode,FTPdtCode,SUM(FCStkQty)  AS FCStkQty
						FROM TVDTPdtStkBal WITH(NOLOCK)
						GROUP BY FTBchCode,FTWahCode,FTPdtCode) BAL ON PDT.FTPdtCode = BAL.FTPdtCode
					INNER JOIN @TTmpPrcStk TMP ON TMP.FTBchCode = BAL.FTBchCode AND TMP.FTPdtCode = BAL.FTPdtCode
					--WHERE BAL.FCStkQty < ISNULL(PDT.FCPdtMin,0)) STK ON BAL.FTBchCode = STK.FTBchCode AND BAL.FTWahCode = STK.FTWahCode AND BAL.FTPdtCode = STK.FTPdtCode
					WHERE BAL.FCStkQty < ISNULL(PDT.FCSpwQtyMin,0)) STK ON BAL.FTBchCode = STK.FTBchCode AND BAL.FTWahCode = STK.FTWahCode AND BAL.FTPdtCode = STK.FTPdtCode		-- 6. --
			
				-- 2. --

				-- 06.02.00 --
				--Cost
				UPDATE TCNMPdtCostAvg with(rowlock)
				SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + ((CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END)*FCPdtCostEx)
				,FCPdtQtyBal = FCPdtQtyBal + (CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END)
				,FDLastUpdOn = GETDATE()
				FROM TCNMPdtCostAvg COST
				INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
				-- 06.02.00 --
			END

		END
	END
	COMMIT TRANSACTION @tTrans
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
	ROLLBACK TRANSACTION @tTrans
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxWahPdtTnf')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxWahPdtTnf
GO
CREATE PROCEDURE [dbo].STP_DOCxWahPdtTnf
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5), --4--
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)		-- 3. --
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Versin		Date			User	Remark
00.01.00	28/03/2019		Em		create  
00.02.00	13/06/2019		Em		แก้ไขชื่อตาราง
00.03.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร
00.04.00	22/07/2019		Em		แก้ไขขนาดฟิลด์ BchCode จาก 3 เป็น 5
00.05.00	30/07/2019		Em		เพิ่มอัพเดทต้นทุน
00.06.00	31/07/2019		Em		แก้ไขปรับปรุง
00.07.00	20/09/2019		Em		แก้ไขปรับปรุง
04.01.00	19/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
06.03.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcWahTnf'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') AS FTXthStaPrcStk FROM TCNTPdtTwxHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)	-- 3. --

	IF @tStaPrc <> '1'	-- 3. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTwxHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTwxHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTXthWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkFrm = '2'
		BEGIN
			--Create stk balance
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
			SELECT DISTINCT HD.FTBchCode,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,
			GETDATE() AS FDLastUpd,@ptWho,	-- 7. --
			GETDATE() AS FDCreateOn,@ptWho	-- 7. --
			FROM TCNTPdtTwxHD HD WITH(NOLOCK)		--4.--
			INNER JOIN TCNTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo		--4.-
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''
			
			--Update Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Tfw.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho	-- 7. --
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll
			FROM TCNTPdtTwxHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			GROUP BY HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Tfw  ON Tfw.FTBchCode = STK.FTBchCode AND Tfw.FTXthWhFrm = STK.FTWahCode AND Tfw.FTPdtCode = STK.FTPdtCode

			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
			,'2' AS FTStkType
			,FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTwxDT DT with(nolock)
			INNER JOIN TCNTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTwxDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'2' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdNet)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTwxDT DT with(nolock)
				INNER JOIN TCNTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTwxDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty*(-1) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END

		IF @tStaPrcStkTo = '2'
		BEGIN
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
			SELECT DISTINCT HD.FTBchCode,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,	-- 7. --
			GETDATE() AS FDLastUpdOn,@ptWho,	-- 7. --
			GETDATE() AS FDCreateOn,@ptWho		-- 7. --
			FROM TCNTPdtTwxHD HD WITH(NOLOCK)		--4.--
			INNER JOIN TCNTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo		--4.--
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''
			GROUP BY HD.FTBchCode,HD.FTXthWhTo,DT.FTPdtCode	-- 7. --

			--Update In
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(Tfw.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = @ptWho	-- 7. --
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll
					FROM TCNTPdtTwxHD HD WITH(NOLOCK)		--4.--
					INNER JOIN TCNTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo	--4.--
					INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
					WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
					GROUP BY HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode) Tfw  ON Tfw.FTBchCode = STK.FTBchCode AND Tfw.FTXthWhTo = STK.FTWahCode AND Tfw.FTPdtCode = STK.FTPdtCode

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
			,'1' AS FTStkType
			,FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTwxDT DT with(nolock)
			INNER JOIN TCNTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTwxDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				DELETE FROM @TTmpPrcStkFhn

				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdNet)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTwxDT DT with(nolock)
				INNER JOIN TCNTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTwxDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		--insert to stock card
		INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
		SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
		GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM @TTmpPrcStk

		-- 5. --
		--Cost
		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
		--,FCPdtQtyBal = STK.FCStkQty
		,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	-- 06.03.00 --
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '1'
		--INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode

		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*COST.FCPdtCostEx)
		--,FCPdtQtyBal = STK.FCStkQty
		,FCPdtQtyBal = FCPdtQtyBal - TMP.FCStkQty	-- 06.03.00 --
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '2'
		--INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode
		-- 5. --
	END	-- 3. --
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxWahPdtTnfIn')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxWahPdtTnfIn
GO
CREATE PROCEDURE [dbo].STP_DOCxWahPdtTnfIn
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)		-- 5. --
DECLARE @tStaPrcStkTo varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	12/02/2019		Em		create  
00.02.00	28/03/2019		Em		เพิ่มการ Update stock balance
00.03.00	23/04/2019		Em		เพิ่มการอัพเดท Stock Vending และแก้ไขการอ้างอิงเอกสาร
00.04.00	17/06/2019		Em		แก้ไขเอาฟิลด์ StkCode และ Insert StkCard
00.05.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร
02.01.00	03/03/2020		Em		ปรับตามโครงสร้างใหม่
03.01.00	13/03/2020		Em		แก้ไขให้อัพเดทเลขที่อ้างอิง
04.01.00	20/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
06.03.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcWahIn'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	--SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTwiHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)	-- 5. --
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTwiHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)  -- 02.01.00 --

	IF @tStaPrc <> '1'	-- 5. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		SET @tStaPrcStkTo = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTwiHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTXthWhTo = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkTo = '2'
		BEGIN
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)		--4.--
			SELECT DISTINCT HD.FTBchCode,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,		--4.--
			GETDATE() AS FDLastUpdOn,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTwiHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''		--4.--
			AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
			AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --

			--Update balance In
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(Twi.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Twi.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll		--4.--
			FROM TCNTPdtTwiHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwiDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
			AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
			GROUP BY HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhTo, DT.FTPdtCode) Twi  ON Twi.FTBchCode = STK.FTBchCode AND Twi.FTXthWhTo = STK.FTWahCode AND Twi.FTPdtCode = STK.FTPdtCode		--4.--

			--3.--
			UPDATE TVDTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty + ISNULL(DTV.FCXtdQty,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = DT.FTLastUpdBy
			FROM TVDTPdtStkBal STK
			INNER JOIN TCNTPdtTwiDTVD DTV WITH(NOLOCK) ON STK.FTBchCode = DTV.FTBchCode AND STK.FNLayRow = DTV.FNLayRow AND STK.FNLayCol = DTV.FNLayCol
			INNER JOIN TCNTPdtTwiDT DT WITH(NOLOCK) ON DTV.FTBchCode = DT.FTBchCode AND DTV.FTXthDocNo = DT.FTXthDocNo AND DTV.FNXtdSeqNo = DT.FNXtdSeqNo
			INNER JOIN TCNTPdtTwiHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo AND ISNULL(HD.FTXthWhTo,'') = STK.FTWahCode  -- 02.01.00 --
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE DT.FTBchCode = @ptBchCode AND DT.FTXthDocNo = @ptDocNo
			AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
			AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
			--3.--

			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
			,'1' AS FTStkType
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTwiDT DT with(nolock)
			INNER JOIN TCNTPdtTwiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
			AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
			GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate

			--4.--
			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk
			--4.--

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTwiDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'1' AS FTStkType
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdNet)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTwiDT DT with(nolock)
				INNER JOIN TCNTPdtTwiHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTwiDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				AND ISNULL(DT.FTXtdStaPrcStk,'') = ''	-- 02.01.00 --
				AND ISNULL(HD.FTXthWhTo,'') <> ''	-- 02.01.00 --
				GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) + ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END

		UPDATE TCNTPdtIntDT WITH(ROWLOCK)
		SET FCXtdQtyRcv = ISNULL(FCXtdQtyRcv,0) + ISNULL(DTi.FCXtdQtyAll,0)
		,FTXtdRvtRef = @ptDocNo	-- 03.01.00 --
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TCNTPdtIntDT DT
		INNER JOIN TCNTPdtTwiHD HDi WITH(NOLOCK) ON HDi.FTXthRefInt = DT.FTXthDocNo
		INNER JOIN TCNTPdtTwiDT DTi WITH(NOLOCK) ON HDi.FTXthDocNo = DTi.FTXthDocNo AND DTi.FTPdtCode = DT.FTPdtCode
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo
		AND ISNULL(DTi.FTXtdDocNoRef,'') = ''


		--3.--
		UPDATE TCNTPdtTwoHD WITH(ROWLOCK)
		SET FTXthRefInt = @ptDocNo
		FROM TCNTPdtTwoHD HDo
		INNER JOIN TCNTPdtTwiHD HDi WITH(NOLOCK) ON HDo.FTXthDocNo = HDi.FTXthRefInt
		WHERE HDi.FTBchCode = @ptBchCode AND HDi.FTXthDocNo = @ptDocNo
		--3.--

		UPDATE TCNTPdtIntDT WITH(ROWLOCK)
		SET FCXtdQtyRcv = ISNULL(FCXtdQtyRcv,0) + ISNULL(DTi.FCXtdQtyAll,0)
		,FTXtdRvtRef = @ptDocNo	-- 03.01.00 --
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TCNTPdtIntDT DT
		INNER JOIN TCNTPdtTwiDT DTi WITH(NOLOCK) ON DT.FTBchCode = DTi.FTXtdBchRef AND DT.FTXthDocNo = DTi.FTXtdDocNoRef AND DT.FTPdtCode = DT.FTPdtCode
		WHERE DTi.FTBchCode = @ptBchCode AND DTi.FTXthDocNo = @ptDocNo
		AND ISNULL(DTi.FTXtdDocNoRef,'') <> ''

		-- 06.03.00 --
		--Cost
		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
		,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '1'
		-- 06.03.00 --
	END -- 5. --
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxWahPdtTnfOut')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxWahPdtTnfOut
GO
CREATE PROCEDURE [dbo].STP_DOCxWahPdtTnfOut
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTComName varchar(50), 
   FTBchCode varchar(5), 
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime ,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)		-- 6. --
DECLARE @tStaPrcStkFrm varchar(1)	-- 04.01.00 --
DECLARE @TTmpPrcStkFhn TABLE 
   ( 
   FTBchCode varchar(5),		-- 5. --
   FTStfDocNo varchar(20), 
   FTStfType varchar(1), 
   FTPdtCode varchar(20), 
   FTFhnRefCode varchar(30),
   FCStfQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStfDate Datetime ,
   FCStfSetPrice decimal(18,4),
   FCStfCostIn decimal(18,4),
   FCStfCostEx decimal(18,4)
   ) 	-- 06.01.00 --
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	08/02/2019		Em		create  
00.02.00	23/04/2019		Em		เพิ่มการอัพเดท Stock Vending
00.05.00	17/06/2019		Em		แก้ไขเอาฟิลด์ StkCode และ Insert StkCard
00.06.00	05/07/2019		Em		เพิ่มการตรวจสอบสถานะการประมวลผลเอกสาร
03.01.00	26/03/2020		Em		เพิ่มฟิลด์ FNXthDocType ใน IntDT
03.02.00	27/03/2020		Em		แก้ไข Type ลง stkcard
04.01.00	19/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	04/05/2021		Em		แก้ไขให้รองรับสินค้าแฟชั่น
06.02.00	01/07/2021		Em		แก้ไข Rounding ให้เป็น 4 หลัก
06.03.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcWahOut'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  

	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') FROM TCNTPdtTwoHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)	-- 6. --

	IF @tStaPrc <> '1'	-- 6. --
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		-- 06.01.00 --
		DELETE TFHTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStfDocNo = @ptDocNo
		-- 06.01.00 --

		--Delete old data
		DELETE FROM TCNTPdtIntDT WHERE  FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo
		
		--Insert new data
		INSERT INTO TCNTPdtIntDT(FTBchCode, FTXthDocNo, FNXthDocType, FNXtdSeqNo, FTXthWahTo, FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, FCXtdQtyRcv, FCXtdQtyAll,	-- 03.02.00 --
			FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
		SELECT HD.FTBchCode, HD.FTXthDocNo, 2, FNXtdSeqNo, HD.FTXthWhTo , FTPdtCode, FTXtdPdtName, FTPunCode, FTPunName, FCXtdFactor, FTXtdBarCode, FCXtdQty, 0 AS FCXtdQtyRcv, FCXtdQtyAll,	-- 03.02.00 --
			GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM TCNTPdtTwoDT DT WITH(NOLOCK)
		INNER JOIN TCNTPdtTwoHD HD WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo

		-- 04.01.00 --
		SET @tStaPrcStkFrm = (SELECT TOP 1 ISNULL(WAH.FTWahStaPrcStk,'') FROM TCNMWaHouse WAH WITH(NOLOCK)
						INNER JOIN TCNTPdtTwoHD HD WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND HD.FTXthWhFrm = WAH.FTWahCode
						WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo)

		IF @tStaPrcStkFrm = '2'
		BEGIN
			INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)		--5.--
			SELECT DISTINCT HD.FTBchCode,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,		--5.--
			GETDATE() AS FDLastUpd,HD.FTLastUpdBy,
			GETDATE() AS FDCreateOn,HD.FTCreateBy
			FROM TCNTPdtTwoHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwoDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode		--5.--
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			AND ISNULL(STK.FTPdtCode,'') = ''		--5.--

			--Update balance Out
			UPDATE TCNTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(Two.FCXtdQtyAll,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = Two.FTLastUpdBy
			FROM TCNTPdtStkBal STK
			INNER JOIN (SELECT HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQtyAll) AS FCXtdQtyAll
			FROM TCNTPdtTwoHD HD WITH(NOLOCK)
			INNER JOIN TCNTPdtTwoDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
			GROUP BY HD.FTBchCode,HD.FTLastUpdBy,HD.FTXthWhFrm, DT.FTPdtCode) Two  ON Two.FTBchCode = STK.FTBchCode AND Two.FTXthWhFrm = STK.FTWahCode AND Two.FTPdtCode = STK.FTPdtCode

			--2.--
			--Update stock balance vending
			UPDATE TVDTPdtStkBal WITH(ROWLOCK)
			SET FCStkQty = FCStkQty - ISNULL(DTV.FCXtdQty,0)
			,FDLastUpdOn = GETDATE()
			,FTLastUpdBy = DT.FTLastUpdBy
			FROM TVDTPdtStkBal STK
			INNER JOIN  TCNTPdtTwoDTVD DTV WITH(NOLOCK) ON STK.FTBchCode = DTV.FTBchCode AND STK.FNLayRow = DTV.FNLayRow AND STK.FNLayCol = DTV.FNLayCol
			INNER JOIN TCNTPdtTwoDT DT WITH(NOLOCK) ON STK.FTBchCode = DT.FTBchCode AND STK.FTPdtCode = DT.FTPdtCode AND DTV.FNXtdSeqNo = DT.FNXtdSeqNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE DT.FTBchCode = @ptBchCode AND DT.FTXthDocNo = @ptDocNo
			--2.--
		
			--5.--
			--insert data to Temp
			INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
			SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
			--,'1' AS FTStkType
			,'2' AS FTStkType	-- 03.02.00 --
			,DT.FTPdtCode AS FTPdtCode
			, SUM(FCXtdQtyAll) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
			, ROUND(SUM(FCXtdNet)/SUM(FCXtdQtyAll),4) AS FCStkSetPrice	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostIn)/SUM(FCXtdQtyAll),4) AS FCStkCostIn	-- 06.02.00 --
			, ROUND(SUM(DT.FCXtdCostEx)/SUM(FCXtdQtyAll),4) AS FCStkCostEx	-- 06.02.00 --
			FROM TCNTPdtTwoDT DT with(nolock)
			INNER JOIN TCNTPdtTwoHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
			GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate
		
			--insert to stock card
			INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
			SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
			GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
			FROM @TTmpPrcStk
			--5.--

			-- 06.01.00 --
			IF EXISTS(SELECT FTPdtCode FROM TCNTPdtTwoDTFhn with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo) BEGIN
				--insert data to Temp
				INSERT INTO @TTmpPrcStkFhn (FTBchCode,FTStfDocNo,FTStfType,FTPdtCode,FTFhnRefCode,FCStfQty,FTWahCode,FDStfDate,FCStfSetPrice,FCStfCostIn,FCStfCostEx)
				SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
				,'2' AS FTStkType	-- 03.02.00 --
				,DT.FTPdtCode AS FTPdtCode,DTF.FTFhnRefCode
				, SUM(DTF.FCXtdQty * DT.FCXtdFactor) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
				, ROUND(SUM(FCXtdNet)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkSetPrice	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostIn)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkCostIn	-- 06.02.00 --
				, ROUND(SUM(DT.FCXtdCostEx)/SUM(DTF.FCXtdQty * DT.FCXtdFactor),4) AS FCStkCostEx	-- 06.02.00 --
				FROM TCNTPdtTwoDT DT with(nolock)
				INNER JOIN TCNTPdtTwoHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
				INNER JOIN TCNTPdtTwoDTFhn DTF with(nolock) ON DT.FTBchCode = DTF.FTBchCode AND DT.FTXthDocNo = DTF.FTXthDocNo AND DT.FNXtdSeqNo = DTF.FNXtdSeqNo AND DT.FTPdtCode = DTF.FTPdtCode
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
				GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXthDocDate

				IF EXISTS(SELECT FTPdtCode FROM @TTmpPrcStkFhn) BEGIN
					--Update Out
					UPDATE TFHTPdtStkBal WITH(ROWLOCK)
					SET FCStfBal = ISNULL(STK.FCStfBal,0) - ISNULL(TMP.FCStfQty,0)
					,FDLastUpdOn = GETDATE()
					,FTLastUpdBy = @ptWho	
					FROM TFHTPdtStkBal STK
					INNER JOIN @TTmpPrcStkFhn TMP ON STK.FTBchCode = TMP.FTBchCode AND STK.FTWahCode = TMP.FTWahCode AND STK.FTPdtCode = TMP.FTPdtCode AND STK.FTFhnRefCode = TMP.FTFhnRefCode

					--Create stk balance
					INSERT INTO TFHTPdtStkBal(FTBchCode,FTWahCode,FTPdtCode,FTFhnRefCode,FCStfBal,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)
					SELECT TMP.FTBchCode,TMP.FTWahCode,TMP.FTPdtCode,TMP.FTFhnRefCode,TMP.FCStfQty*(-1) AS FCStkQty,
					GETDATE() AS FDLastUpdOn, @ptWho AS FTLastUpdBy, GETDATE() AS FDCreateOn, @ptWho FTCreateBy
					FROM @TTmpPrcStkFhn TMP
					LEFT JOIN TFHTPdtStkBal BAL WITH(NOLOCK) ON BAL.FTBchCode = TMP.FTBchCode AND BAL.FTWahCode = TMP.FTWahCode AND BAL.FTPdtCode = TMP.FTPdtCode AND BAL.FTFhnRefCode = TMP.FTFhnRefCode
					WHERE ISNULL(BAL.FTFhnRefCode,'') = ''

					--insert stk card
					INSERT INTO TFHTPdtStkCrd( FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, FDCreateOn, FTCreateBy)		--3.--
					SELECT  FTBchCode, FDStfDate, FTStfDocNo, FTWahCode, FTPdtCode, FTFhnRefCode, FTStfType, FCStfQty, FCStfSetPrice, FCStfCostIn, FCStfCostEx, GETDATE() AS FDCreateOn,@ptWho AS FTCreateBy		--3.--
					FROM @TTmpPrcStkFhn
				END
			END
			-- 06.01.00 --
		END
		-- 04.01.00 --

		-- 06.03.00 --
		--Cost
		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*COST.FCPdtCostEx)
		,FCPdtQtyBal = FCPdtQtyBal - TMP.FCStkQty	
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
		-- 06.03.00 --
	END	 -- 6. --
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxWahPdtTnfVD')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxWahPdtTnfVD
GO
CREATE PROCEDURE [dbo].STP_DOCxWahPdtTnfVD
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tTrans VARCHAR(20)
DECLARE @TTmpPrcStk TABLE 
   ( 
   FTBchCode varchar(5),
   FTStkDocNo varchar(20), 
   FTStkType varchar(1), 
   FTPdtCode varchar(20), 
   FCStkQty decimal(18,4), 
   FTWahCode varchar(5), 
   FDStkDate Datetime,
   FCStkSetPrice decimal(18,4),
   FCStkCostIn decimal(18,4),
   FCStkCostEx decimal(18,4)
   ) 
DECLARE @tStaPrc varchar(1)	
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
00.01.00	22/07/2019		Em		create  
00.02.00	30/07/2019		Em		เพิ่มอัพเดทต้นทุน
00.03.00	25/10/2019		Em		เพิ่มการตรวจสอบรายการสินค้าที่ไม่มีใน Layout
00.04.00	04/11/2019		Em		เพิ่มการตรวจสอบรายการสินค้าที่ไม่มี PdtCode
02.00.00	05/02/2020		Em		เปลี่ยนไปใช้ WahCode ที่ DT
02.01.00	06/02/2020		Em		เพิ่มฟิลด์ FNCabSeq
02.02.00	10/03/2020		Em		แก้ไขกรณี Insert Qty เป็น 0
02.03.00	07/08/2020		Em		แก้ไขให้ sum Qty
02.04.00	28/08/2020		Em		เพิ่มเงื่อนไขการ join 
02.05.00	10/09/2020		Em		แก้ไขเงื่อนไขการ join คลังสินค้า
04.01.00	20/10/2020		Em		เพิ่มการตรวจสอบคลังตัดสต๊อก
04.02.00	26/10/2020		Em		เพิ่มการตรวจสอบสถานะควบคุมสต๊อก
05.01.00	12/03/2021		Em		ป้องกันการ Process ซ้ำ
06.01.00	08/08/2021		Em		แก้ไข Process ต้นทุน
----------------------------------------------------------------------*/
SET @tTrans = 'PrcWahTnfVD'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  
	SET @tStaPrc = (SELECT TOP 1 ISNULL(FTXthStaPrcStk,'') AS FTXthStaPrcStk FROM TVDTPdtTwxHD with(nolock) WHERE FTBchCode = @ptBchCode AND FTXthDocNo = @ptDocNo)

	IF @tStaPrc <> '1'
	BEGIN
		-- 05.01.00 --
		DELETE TCNTPdtStkCrd WITH(ROWLOCK)
		WHERE FTBchCode = @ptBchCode AND FTStkDocNo = @ptDocNo
		-- 05.01.00 --

		--Update Stock In
		UPDATE TCNTPdtStkBal WITH(ROWLOCK)
		SET FCStkQty = FCStkQty + ISNULL(Twx.FCXtdQtyAll,0)
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TCNTPdtStkBal STK
		--INNER JOIN (SELECT HD.FTBchCode,HD.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQty) AS FCXtdQtyAll
		INNER JOIN (SELECT HD.FTBchCode,DT.FTXthWhTo, DT.FTPdtCode ,SUM(DT.FCXtdQty) AS FCXtdQtyAll	-- 5. --
				FROM TVDTPdtTwxHD HD WITH(NOLOCK)
				INNER JOIN TVDTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
				INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = DT.FTBchCode AND WAH.FTWahCode = DT.FTXthWhTo AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
				--GROUP BY HD.FTBchCode, HD.FTXthWhTo, DT.FTPdtCode) Twx  ON Twx.FTBchCode = STK.FTBchCode AND Twx.FTXthWhTo = STK.FTWahCode AND Twx.FTPdtCode = STK.FTPdtCode
				GROUP BY HD.FTBchCode, DT.FTXthWhTo, DT.FTPdtCode) Twx  ON Twx.FTBchCode = STK.FTBchCode AND Twx.FTXthWhTo = STK.FTWahCode AND Twx.FTPdtCode = STK.FTPdtCode	-- 5. --

		--Update Stock In Vending
		UPDATE TVDTPdtStkBal WITH(ROWLOCK)
		SET FCStkQty = FCStkQty + ISNULL(Twx.FCXtdQtyAll,0)
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TVDTPdtStkBal STK
		--INNER JOIN (SELECT HD.FTBchCode, HD.FTXthWhTo, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode, SUM(DT.FCXtdQty) AS FCXtdQtyAll
		INNER JOIN (SELECT HD.FTBchCode, DT.FTXthWhTo, DT.FNCabSeq, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode, SUM(DT.FCXtdQty) AS FCXtdQtyAll	-- 5. --	-- 6. --
				FROM TVDTPdtTwxHD HD WITH(NOLOCK)
				INNER JOIN TVDTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
				--INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTXthWhTo = WAH.FTWahCode AND WAH.FTWahStaType = '6'
				--INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON DT.FTXthWhTo = WAH.FTWahCode AND WAH.FTWahStaType = '6'	-- 5. --
				INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND DT.FTXthWhTo = WAH.FTWahCode AND WAH.FTWahStaType = '6'	-- 9. --
						AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
				--GROUP BY HD.FTBchCode, HD.FTXthWhTo, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode) Twx  ON Twx.FTBchCode = STK.FTBchCode AND Twx.FTXthWhTo = STK.FTWahCode 
				GROUP BY HD.FTBchCode, DT.FTXthWhTo, DT.FNCabSeq, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode) Twx  ON Twx.FTBchCode = STK.FTBchCode AND Twx.FTXthWhTo = STK.FTWahCode	-- 5. --	-- 6. --
				AND Twx.FTPdtCode = STK.FTPdtCode AND Twx.FNLayRow = STK.FNLayRow AND Twx.FNLayCol = STK.FNLayCol
				AND Twx.FNCabSeq = STK.FNCabSeq	-- 6. --

		--Update Stock Out
		UPDATE TCNTPdtStkBal WITH(ROWLOCK)
		SET FCStkQty = FCStkQty - ISNULL(Twx.FCXtdQtyAll,0)
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TCNTPdtStkBal STK
		--INNER JOIN (SELECT HD.FTBchCode, HD.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQty) AS FCXtdQtyAll
		INNER JOIN (SELECT HD.FTBchCode, DT.FTXthWhFrm, DT.FTPdtCode ,SUM(DT.FCXtdQty) AS FCXtdQtyAll	-- 5. --
		FROM TVDTPdtTwxHD HD WITH(NOLOCK)
		INNER JOIN TVDTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
		INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = DT.FTBchCode AND WAH.FTWahCode = DT.FTXthWhFrm AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		--GROUP BY HD.FTBchCode, HD.FTXthWhFrm, DT.FTPdtCode) Twx  ON Twx.FTBchCode = STK.FTBchCode AND Twx.FTXthWhFrm = STK.FTWahCode AND Twx.FTPdtCode = STK.FTPdtCode
		GROUP BY HD.FTBchCode, DT.FTXthWhFrm, DT.FTPdtCode) Twx  ON Twx.FTBchCode = STK.FTBchCode AND Twx.FTXthWhFrm = STK.FTWahCode AND Twx.FTPdtCode = STK.FTPdtCode	-- 5. --

		--Update Stock Out
		UPDATE TVDTPdtStkBal WITH(ROWLOCK)
		SET FCStkQty = FCStkQty - ISNULL(Twx.FCXtdQtyAll,0)
		,FDLastUpdOn = GETDATE()
		,FTLastUpdBy = @ptWho
		FROM TVDTPdtStkBal STK
		--INNER JOIN (SELECT HD.FTBchCode, HD.FTXthWhFrm, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode ,SUM(DT.FCXtdQty) AS FCXtdQtyAll
		INNER JOIN (SELECT HD.FTBchCode, DT.FTXthWhFrm, DT.FNCabSeq, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode ,SUM(DT.FCXtdQty) AS FCXtdQtyAll	-- 6. --
		FROM TVDTPdtTwxHD HD WITH(NOLOCK)
		INNER JOIN TVDTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
		--INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTXthWhFrm = WAH.FTWahCode AND WAH.FTWahStaType = '6'
		--INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON DT.FTXthWhFrm = WAH.FTWahCode AND WAH.FTWahStaType = '6'	-- 5. --
		--INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND DT.FTXthWhTo = WAH.FTWahCode AND WAH.FTWahStaType = '6'	-- 9. --
		INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND DT.FTXthWhFrm = WAH.FTWahCode AND WAH.FTWahStaType = '6'	-- 10. --
				AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		--GROUP BY HD.FTBchCode, HD.FTXthWhFrm, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode) Twx  ON Twx.FTBchCode = STK.FTBchCode AND Twx.FTXthWhFrm = STK.FTWahCode 
		GROUP BY HD.FTBchCode, DT.FTXthWhFrm, DT.FNCabSeq, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode) Twx  ON Twx.FTBchCode = STK.FTBchCode AND Twx.FTXthWhFrm = STK.FTWahCode	-- 5. --	-- 6. --
		AND Twx.FTPdtCode = STK.FTPdtCode AND Twx.FNLayRow = STK.FNLayRow AND Twx.FNLayCol = STK.FNLayCol
		AND Twx.FNCabSeq = STK.FNCabSeq	-- 6. --

		--Create stk balance
		INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
		--SELECT DISTINCT HD.FTBchCode,HD.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,
		--SELECT DISTINCT HD.FTBchCode,DT.FTXthWhFrm,DT.FTPdtCode,0 AS FCStkQty,	-- 5. --
		--SELECT DISTINCT HD.FTBchCode,DT.FTXthWhFrm,DT.FTPdtCode,ISNULL(DT.FCXtdQty,0) AS FCStkQty,
		SELECT HD.FTBchCode,DT.FTXthWhFrm,DT.FTPdtCode,SUM(ISNULL(DT.FCXtdQty,0)) AS FCStkQty,		-- 8. --
		GETDATE() AS FDLastUpd,HD.FTLastUpdBy,
		GETDATE() AS FDCreateOn,HD.FTCreateBy
		FROM TVDTPdtTwxHD HD WITH(NOLOCK)
		INNER JOIN TVDTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
		INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = DT.FTBchCode AND WAH.FTWahCode = DT.FTXthWhFrm AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
		--LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
		LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND DT.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode		-- 5. --
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		AND ISNULL(STK.FTPdtCode,'') = '' AND ISNULL(DT.FTPdtCode,'') <> ''	AND ISNULL(STK.FTPdtCode,'') = '' -- 3. --  -- 4. --
		GROUP BY HD.FTBchCode,DT.FTXthWhFrm,DT.FTPdtCode,HD.FTLastUpdBy,HD.FTCreateBy	-- 8. --

		INSERT INTO TCNTPdtStkBal(FTBchCode, FTWahCode, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)
		--SELECT DISTINCT HD.FTBchCode,HD.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,
		--SELECT DISTINCT HD.FTBchCode,DT.FTXthWhTo,DT.FTPdtCode,0 AS FCStkQty,	-- 5. --
		--SELECT DISTINCT HD.FTBchCode,DT.FTXthWhTo,DT.FTPdtCode,ISNULL(DT.FCXtdQty,0) AS FCStkQty,	-- 7. --
		SELECT HD.FTBchCode,DT.FTXthWhTo,DT.FTPdtCode,SUM(ISNULL(DT.FCXtdQty,0)) AS FCStkQty,	-- 8. --
		GETDATE() AS FDLastUpdOn,HD.FTLastUpdBy,
		GETDATE() AS FDCreateOn,HD.FTCreateBy
		FROM TVDTPdtTwxHD HD WITH(NOLOCK)
		INNER JOIN TVDTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
		INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = DT.FTBchCode AND WAH.FTWahCode = DT.FTXthWhTo AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
		--LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
		LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND DT.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode		-- 5. --
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		AND ISNULL(STK.FTPdtCode,'') = '' AND ISNULL(DT.FTPdtCode,'') <> ''	AND ISNULL(STK.FTPdtCode,'') = '' 	-- 3. --  -- 4. --
		GROUP BY HD.FTBchCode,DT.FTXthWhTo,DT.FTPdtCode,HD.FTLastUpdBy,HD.FTCreateBy	-- 8. --

		--Create stk balance Vending
		INSERT INTO TVDTPdtStkBal(FTBchCode, FTWahCode, FNCabSeq, FNLayRow, FNLayCol, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)	-- 6. --
		--SELECT DISTINCT HD.FTBchCode,HD.FTXthWhFrm, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode,0 AS FCStkQty,
		--SELECT DISTINCT HD.FTBchCode,DT.FTXthWhFrm, DT.FNCabSeq, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode,0 AS FCStkQty,		-- 5. --	-- 6. --
		SELECT DISTINCT HD.FTBchCode,DT.FTXthWhFrm, DT.FNCabSeq, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode,ISNULL(DT.FCXtdQty,0) AS FCStkQty,	-- 7. --
		GETDATE() AS FDLastUpd,HD.FTLastUpdBy,
		GETDATE() AS FDCreateOn,HD.FTCreateBy
		FROM TVDTPdtTwxHD HD WITH(NOLOCK)
		INNER JOIN TVDTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
		--INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTXthWhFrm = WAH.FTWahCode AND WAH.FTWahStaType = '6'
		--LEFT JOIN TVDTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
		--INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON DT.FTXthWhFrm = WAH.FTWahCode AND WAH.FTWahStaType = '6'		-- 5. --
		INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND DT.FTXthWhFrm = WAH.FTWahCode AND WAH.FTWahStaType = '6'	-- 9. --
				AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
		LEFT JOIN TVDTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND DT.FTXthWhFrm = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode		-- 5. --
			AND DT.FNLayRow = STK.FNLayRow AND DT.FNLayCol = STK.FNLayCol
			AND DT.FNCabSeq = STK.FNCabSeq	-- 6. --
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		AND ISNULL(STK.FTPdtCode,'') = '' AND ISNULL(DT.FTPdtCode,'') <> ''	AND ISNULL(STK.FTPdtCode,'') = '' 	-- 3. --  -- 4. --

		INSERT INTO TVDTPdtStkBal(FTBchCode, FTWahCode, FNCabSeq, FNLayRow, FNLayCol, FTPdtCode, FCStkQty, FDLastUpdOn, FTLastUpdBy, FDCreateOn, FTCreateBy)	-- 6. --
		--SELECT DISTINCT HD.FTBchCode,HD.FTXthWhTo, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode,0 AS FCStkQty,
		--SELECT DISTINCT HD.FTBchCode,DT.FTXthWhTo, DT.FNCabSeq, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode,0 AS FCStkQty,		-- 5. --	-- 6. --
		SELECT DISTINCT HD.FTBchCode,DT.FTXthWhTo, DT.FNCabSeq, DT.FNLayRow, DT.FNLayCol, DT.FTPdtCode,ISNULL(DT.FCXtdQty,0) AS FCStkQty,	-- 7. --
		GETDATE() AS FDLastUpdOn,HD.FTLastUpdBy,
		GETDATE() AS FDCreateOn,HD.FTCreateBy
		FROM TVDTPdtTwxHD HD WITH(NOLOCK)
		INNER JOIN TVDTPdtTwxDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXthDocNo = DT.FTXthDocNo
		--INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTXthWhTo = WAH.FTWahCode AND WAH.FTWahStaType = '6'
		--LEFT JOIN TVDTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND HD.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode
		--INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON DT.FTXthWhTo = WAH.FTWahCode AND WAH.FTWahStaType = '6'		-- 5. --
		INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON HD.FTBchCode = WAH.FTBchCode AND DT.FTXthWhTo = WAH.FTWahCode AND WAH.FTWahStaType = '6'	-- 9. --
				AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
		LEFT JOIN TVDTPdtStkBal STK WITH(NOLOCK) ON HD.FTBchCode = STK.FTBchCode AND DT.FTXthWhTo = STK.FTWahCode AND DT.FTPdtCode = STK.FTPdtCode	-- 5. --
			AND DT.FNLayRow = STK.FNLayRow AND DT.FNLayCol = STK.FNLayCol
			AND DT.FNCabSeq = STK.FNCabSeq	-- 6. --
		WHERE HD.FTBchCode = @ptBchCode AND HD.FTXthDocNo = @ptDocNo
		AND ISNULL(STK.FTPdtCode,'') = '' AND ISNULL(DT.FTPdtCode,'') <> ''	AND ISNULL(STK.FTPdtCode,'') = '' 	-- 3. --  -- 4. --
		
		--insert data to Temp
		INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
		SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
		,'1' AS FTStkType
		, DT.FTPdtCode AS FTPdtCode
		--, SUM(FCXtdQty) AS FCStkQty,HD.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate
		, SUM(FCXtdQty) AS FCStkQty,DT.FTXthWhTo AS FTWahCode,HD.FDXthDocDate AS FDStkDate		-- 5. --
		, ROUND(0,4) AS FCStkSetPrice
		, ROUND(0,4) AS FCStkCostIn
		, ROUND(0,4) AS FCStkCostEx
		FROM TVDTPdtTwxDT DT with(nolock)
		INNER JOIN TVDTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
		INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = DT.FTBchCode AND WAH.FTWahCode = DT.FTXthWhTo AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
		WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
		--GROUP BY HD.FTBchCode,HD.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate
		GROUP BY HD.FTBchCode,DT.FTXthWhTo,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 5. --


		INSERT INTO @TTmpPrcStk (FTBchCode,FTStkDocNo,FTStkType,FTPdtCode,FCStkQty,FTWahCode,FDStkDate,FCStkSetPrice,FCStkCostIn,FCStkCostEx)
		SELECT HD.FTBchCode,HD.FTXthDocNo AS FTStkDocNo
		,'2' AS FTStkType
		,DT.FTPdtCode AS FTPdtCode
		--, SUM(FCXtdQty) AS FCStkQty,HD.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate
		, SUM(FCXtdQty) AS FCStkQty,DT.FTXthWhFrm AS FTWahCode,HD.FDXthDocDate AS FDStkDate		-- 5. --
		, ROUND(0,4) AS FCStkSetPrice
		, ROUND(0,4) AS FCStkCostIn
		, ROUND(0,4) AS FCStkCostEx
		FROM TVDTPdtTwxDT DT with(nolock)
		INNER JOIN TVDTPdtTwxHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXthDocNo = HD.FTXthDocNo
		INNER JOIN TCNMWaHouse WAH WITH(NOLOCK) ON WAH.FTBchCode = DT.FTBchCode AND WAH.FTWahCode = DT.FTXthWhFrm AND ISNULL(WAH.FTWahStaPrcStk,'') = '2'	-- 04.01.00 --
		INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
		WHERE HD.FTBchCode=@ptBchCode AND HD.FTXthDocNo =@ptDocNo
		--GROUP BY HD.FTBchCode,HD.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate
		GROUP BY HD.FTBchCode,DT.FTXthWhFrm,HD.FTXthDocNo,DT.FTPdtCode,HD.FDXthDocDate	-- 5. --

		--insert to stock card
		INSERT INTO TCNTPdtStkCrd with(rowlock)(FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,FDCreateOn,FTCreateBy)
		SELECT FTBchCode,FDStkDate,FTStkDocNo,FTWahCode,FTPdtCode,FTStkType,FCStkQty,FCStkSetPrice,FCStkCostIn,FCStkCostEx,
		GETDATE() AS FDCreateOn, @ptWho AS FTCreateBy
		FROM @TTmpPrcStk

		-- 2. --
		--Cost
		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + (TMP.FCStkQty*COST.FCPdtCostEx)
		--,FCPdtQtyBal = STK.FCStkQty
		,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	-- 06.01.00  --
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '1'
		--INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode

		UPDATE TCNMPdtCostAvg with(rowlock)
		SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) - (TMP.FCStkQty*COST.FCPdtCostEx)
		--,FCPdtQtyBal = STK.FCStkQty
		,FCPdtQtyBal = FCPdtQtyBal - TMP.FCStkQty	-- 06.01.00  --
		,FDLastUpdOn = GETDATE()
		FROM TCNMPdtCostAvg COST
		INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode AND TMP.FTStkType = '2'
		--INNER JOIN TCNTPdtStkBal STK with(nolock) ON COST.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode = @ptBchCode
		-- 2. --
	END	
	COMMIT TRANSACTION @tTrans  
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
END CATCH
GO









IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxPunEntry')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].SP_RPTxPunEntry
GO
CREATE PROCEDURE [dbo].[SP_RPTxPunEntry]
--ALTER PROCEDURE [dbo].[SP_RPTxSalDailyByCashierTmp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

--Agency
	@ptAgnL Varchar(8000), --Agency Condition IN
	--@ptPosF Varchar(10), @ptPosT Varchar(10),
	  
--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	--@ptBchF Varchar(5),	@ptBchT Varchar(5),

--รหัสหน่วยสินค้า --FTPunCode
	@ptPunF Varchar(5),@ptPunT Varchar(5),


	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 14/05/2021
--รายงานหน่วยสินค้า
-- Temp name  SP_RPTxPunEntry

--------------------------------------
BEGIN TRY	
	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSql1 VARCHAR(Max)
	DECLARE @tSqlHD VARCHAR(Max)
	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	
	SET @FNResult= 0

	IF @nLngID = null
	BEGIN
		SET @nLngID = 1
	END	

	IF @ptAgnL = null
	BEGIN
		SET @ptAgnL = ''
	END
	
	IF @ptBchL = null
	BEGIN
		SET @ptBchL = ''
	END


	IF @ptPunF =null
	BEGIN
		SET @ptPunF = ''
	END
	IF @ptPunT =null OR @ptPunT = ''
	BEGIN
		SET @ptPunF = @ptPunT
	END 
		
	SET @tSql1 =   ' WHERE 1=1 '

	IF (@ptAgnL <> '' )
	BEGIN
		SET @tSql1 +=' AND Pun.FTAgnCode IN (' + @ptAgnL + ')'
	END


	IF (@ptBchL <> '' )
	BEGIN
		SET @tSql1 +=' AND Agn.FTBchCode IN (' + @ptBchL + ')'
	END

	IF (@ptPunF<> '')
	BEGIN
		SET @tSql1 +=' AND Pun.FTPunCode BETWEEN ''' + @ptPunF + ''' AND ''' + @ptPunT + ''''
	END

	SET @tSql1 +=' OR ISNULL(Pun.FTAgnCode,'''') = '''' '

	DELETE FROM TRPTPunEntryTmp  WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--Åº¢éÍÁÙÅ Temp ¢Í§à¤Ã×èÍ§·Õè¨ÐºÑ¹·Ö¡¢ÍÁÙÅÅ§ Temp

	SET @tSql = 'INSERT INTO TRPTPunEntryTmp'
	--PRINT @tSql
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FTPunCode,FTPunName,FTAgnCode,FTAgnName,FTBchCode,FTBchName'
	SET @tSql +=' )'
	--PRINT @tSql
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' Pun.FTPunCode,PunL.FTPunName,Pun.FTAgnCode, AgnL.FTAgnName,Agn.FTBchCode, BchL.FTBchName'
	SET @tSql +=' FROM TCNMPdtUnit Pun WITH (NOLOCK)'
	SET @tSql +=' LEFT JOIN TCNMAgency Agn WITH (NOLOCK) ON Pun.FTAgnCode = Agn.FTAgnCode'	
	SET @tSql +=' LEFT JOIN TCNMBranch_L BchL WITH (NOLOCK) ON Agn.FTBchCode	= BchL.FTBchCode	AND BchL.FNLngID	= '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql +=' LEFT JOIN TCNMPdtUnit_L PunL WITH (NOLOCK) ON Pun.FTPunCode = PunL.FTPunCode	AND PunL.FNLngID	 = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql +=' LEFT JOIN TCNMAgency_L AgnL	WITH (NOLOCK) ON Pun.FTAgnCode	= AgnL.FTAgnCode	AND AgnL.FNLngID	= '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql += @tSql1
	--PRINT @tSql
	
	EXECUTE(@tSql)
	--RETURN SELECT * FROM TRPTSalDailyByCashierTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
END TRY

BEGIN CATCH 
	SET @FNResult= -1
	--PRINT @tSql
END CATCH	
GO