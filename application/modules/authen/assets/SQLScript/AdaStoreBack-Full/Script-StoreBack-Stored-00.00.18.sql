


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





IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_CNoBrowseProduct')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].SP_CNoBrowseProduct
GO
CREATE PROCEDURE [dbo].[SP_CNoBrowseProduct]
	--ผู้ใช้และสิท
	@ptUsrCode VARCHAR(10),
	@ptUsrLevel VARCHAR(10),
	@ptSesAgnCode VARCHAR(10),
	@ptSesBchCodeMulti VARCHAR(100),
	@ptSesShopCodeMulti VARCHAR(100),
	@ptSesMerCode VARCHAR(20),

	--กำหนดการแสดงข้อมูล
	@pnRow INT,
	@pnPage INT,
	@pnMaxTopPage INT,
	--ค้นหาตามประเภท
	@ptFilterBy VARCHAR(80),
	@ptSearch VARCHAR(1000),

	--OPTION PDT
	@ptWhere VARCHAR(8000),
	@ptNotInPdtType VARCHAR(8000),
	@ptPdtCodeIgnorParam VARCHAR(30),
	@ptPDTMoveon VARCHAR(1),
	@ptPlcCodeConParam VARCHAR(10),
	@ptDISTYPE VARCHAR(1),
	@ptPagename VARCHAR(10),
	@ptNotinItemString VARCHAR(8000),
	@ptSqlCode VARCHAR(20),
	
	--Price And Cost
	@ptPriceType VARCHAR(30),
	@ptPplCode VARCHAR(30),
	
	@pnLngID INT
AS
BEGIN

DECLARE @tSQL VARCHAR(MAX)
DECLARE @tSQLMaster VARCHAR(MAX)

DECLARE @tUsrCode VARCHAR(10)
DECLARE @tUsrLevel VARCHAR(10)
DECLARE @tSesAgnCode VARCHAR(10)
DECLARE @tSesBchCodeMulti VARCHAR(100)
DECLARE @tSesShopCodeMulti VARCHAR(100)
DECLARE @tSesMerCode VARCHAR(20)

DECLARE @nRow INT
DECLARE @nPage INT
DECLARE @nMaxTopPage INT

DECLARE @tFilterBy VARCHAR(80)
DECLARE @tSearch VARCHAR(80)

	--OPTION PDT
DECLARE	@tWhere VARCHAR(8000)
DECLARE	@tNotInPdtType VARCHAR(8000)
DECLARE	@tPdtCodeIgnorParam VARCHAR(30)
DECLARE	@tPDTMoveon VARCHAR(1)
DECLARE	@tPlcCodeConParam VARCHAR(10)
DECLARE	@tDISTYPE VARCHAR(1)
DECLARE	@tPagename VARCHAR(10)
DECLARE	@tNotinItemString VARCHAR(8000)
DECLARE	@tSqlCode VARCHAR(10)

	--Price And Cost
DECLARE	@tPriceType VARCHAR(10)
DECLARE	@tPplCode VARCHAR(10)

DECLARE @nLngID INT

---///2021-09-10 -Nattakit K. :: สร้างสโตร
SET @tUsrCode = @ptUsrCode
SET @tUsrLevel = @ptUsrLevel
SET @tSesAgnCode = @ptSesAgnCode
SET @tSesBchCodeMulti = @ptSesBchCodeMulti
SET @tSesShopCodeMulti = @ptSesShopCodeMulti
SET @tSesMerCode = @ptSesMerCode

SET @nRow = @pnRow
SET @nPage = @pnPage
SET @nMaxTopPage = @pnMaxTopPage

SET @tFilterBy = @ptFilterBy
SET @tSearch = @ptSearch

SET @tWhere = @ptWhere
SET @tNotInPdtType = @ptNotInPdtType
SET @tPdtCodeIgnorParam = @ptPdtCodeIgnorParam
SET @tPDTMoveon = @ptPDTMoveon
SET @tPlcCodeConParam = @ptPlcCodeConParam
SET @tDISTYPE = @ptDISTYPE
SET @tPagename = @ptPagename
SET @tNotinItemString = @ptNotinItemString
SET @tSqlCode = @ptSqlCode

SET @tPriceType = @ptPriceType
SET @tPplCode = @ptPplCode

SET @nLngID = @pnLngID




----//----------------------Data Master And Filter-------------//
								SET @tSQLMaster = ' SELECT Base.*, '

						IF @nPage = 1 BEGIN
								SET @tSQLMaster += ' COUNT(*) OVER() AS rtCountData '
						END ELSE BEGIN
								SET @tSQLMaster += ' 0 AS rtCountData '
						END

								SET @tSQLMaster += ' FROM ( '
								SET @tSQLMaster += ' SELECT '

						IF @nMaxTopPage > 0 BEGIN
								SET @tSQLMaster += ' TOP ' + CAST(@nMaxTopPage  AS VARCHAR(10)) + ' '
						END

					      --SET @tSQLMaster += ' ROW_NUMBER () OVER (ORDER BY Products.FDCreateOn DESC) AS FNRowID,'
								SET @tSQLMaster += ' Products.FTPdtForSystem, '
                SET @tSQLMaster += ' Products.FTPdtCode,PDT_IMG.FTImgObj,'

						IF @ptUsrLevel != 'HQ'  BEGIN
								SET @tSQLMaster += ' PDLSPC.FTAgnCode,PDLSPC.FTBchCode,PDLSPC.FTShpCode,PDLSPC.FTMerCode, '
						END ELSE BEGIN
								SET @tSQLMaster += ' '''' AS FTAgnCode,'''' AS FTBchCode,'''' AS  FTShpCode,'''' AS FTMerCode, '
						END 

								SET @tSQLMaster += ' Products.FTPtyCode,'
								SET @tSQLMaster += ' Products.FTPgpChain,'
								SET @tSQLMaster += ' Products.FTPdtStaVatBuy,Products.FTPdtStaVat,Products.FTVatCode,Products.FTPdtStaActive, Products.FTPdtSetOrSN, Products.FTPdtStaAlwDis,Products.FTPdtType,Products.FCPdtCostStd,'
								SET @tSQLMaster += ' PDTSPL.FTSplCode,PDTSPL.FTUsrCode AS FTBuyer,PBAR.FTBarCode,PPCZ.FTPunCode,PPCZ.FCPdtUnitFact,'
								SET @tSQLMaster += ' Products.FTCreateBy,'
								SET @tSQLMaster += ' Products.FDCreateOn'
                SET @tSQLMaster += ' FROM'
                SET @tSQLMaster += ' TCNMPdt Products WITH (NOLOCK)'

						IF @ptUsrLevel != 'HQ'  BEGIN
                SET @tSQLMaster += ' LEFT JOIN TCNMPdtSpcBch PDLSPC WITH (NOLOCK) ON Products.FTPdtCode = PDLSPC.FTPdtCode'
						END

								SET @tSQLMaster += ' INNER JOIN TCNMPdtPackSize PPCZ WITH (NOLOCK) ON Products.FTPdtCode = PPCZ.FTPdtCode LEFT JOIN TCNMPdtBar PBAR WITH (NOLOCK)  ON Products.FTPdtCode = PBAR.FTPdtCode  AND PPCZ.FTPunCode = PBAR.FTPunCode' --//หาบาร์โค้ด
								SET @tSQLMaster += ' LEFT JOIN TCNMPdtSpl PDTSPL WITH (NOLOCK) ON PBAR.FTPdtCode = PDTSPL.FTPdtCode AND PBAR.FTBarCode = PDTSPL.FTBarCode '--//ผู้จำหน่าย
								SET @tSQLMaster += ' LEFT JOIN TCNMImgPdt AS PDT_IMG WITH(NOLOCK) ON Products.FTPdtCode = PDT_IMG.FTImgRefID AND PDT_IMG.FTImgTable = ''TCNMPdt'' AND PDT_IMG.FNImgSeq = 1 '					
			---//--------การจอยตาราง------///
							IF @tFilterBy = 'FTPdtCode' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' '--//รหัสสินค้า
							END

							IF @tFilterBy = 'FTPdtName' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' LEFT JOIN TCNMPdt_L PDTL WITH (NOLOCK)       ON Products.FTPdtCode = PDTL.FTPdtCode  AND PDTL.FNLngID   = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '--//หาชื่อสินค้า
							END

							/*IF @tFilterBy = 'PDTANDBarcode' OR @tFilterBy = 'FTPlcCode' OR @tSqlCode != '' BEGIN
								SET @tSQLMaster += ' LEFT JOIN TCNMPdtPackSize PPCZ WITH (NOLOCK) ON PDT.FTPdtCode = PPCZ.FTPdtCode LEFT JOIN TCNMPdtBar PBAR WITH (NOLOCK)      ON PDT.FTPdtCode = PBAR.FTPdtCode  AND PPCZ.FTPunCode = PBAR.FTPunCode' --//หาบาร์โค้ด
							END

							IF @tFilterBy = 'FTBarCode' BEGIN
								SET @tSQLMaster += ' LEFT JOIN TCNMPdtPackSize PPCZ WITH (NOLOCK) ON PDT.FTPdtCode = PPCZ.FTPdtCode LEFT JOIN TCNMPdtBar PBAR WITH (NOLOCK)      ON PDT.FTPdtCode = PBAR.FTPdtCode  AND PPCZ.FTPunCode = PBAR.FTPunCode' --//หาบาร์โค้ด
							END*/

							IF @tFilterBy = 'FTPunCode' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' LEFT JOIN TCNMPdtUnit_L PUNL WITH (NOLOCK)   ON PPCZ.FTPunCode = PUNL.FTPunCode AND PUNL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' ' --//หาหน่วย
							END								

							IF @tFilterBy = 'FTPgpChain' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' LEFT JOIN TCNMPdtGrp_L PGL WITH (NOLOCK)     ON PGL.FTPgpChain = Products.FTPgpChain AND PGL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '--//หากลุ่มสินค้า
							END							

							IF @tFilterBy = 'FTPtyCode' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' LEFT JOIN TCNMPdtType_L PTL WITH (NOLOCK)    ON Products.FTPtyCode = PTL.FTPtyCode   AND PTL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '--//หาประเภทสินค้า
							END	

							IF @tFilterBy = 'FTBuyer' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' '--//ผู้จัดซื้อ
							END

						 /* IF @tSqlCode != '' BEGIN------//----------------ผู้จำหน่าย-------------------
								SET @tSQLMaster += ' LEFT JOIN TCNMPdtSpl PDTSPL WITH (NOLOCK) ON PBAR.FTPdtCode = PDTSPL.FTPdtCode AND PBAR.FTBarCode = PDTSPL.FTBarCode '--//ผู้จำหน่าย
							END*/
								---//--------การจอยตาราง------///


							SET @tSQLMaster += ' WHERE ISNULL(Products.FTPdtCode,'''') != '''' '


								---//--------การค้นหา------///
							IF @tFilterBy = 'FTPdtCode' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' AND ( Products.FTPdtCode = ''' + @tSearch + ''' )'--//รหัสสินค้า
							END

							IF @tFilterBy = 'FTPdtName' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' AND ( UPPER(PDTL.FTPdtName)  COLLATE THAI_BIN    LIKE UPPER(''%' + @tSearch + '%'') ) '--//หาชื่อสินค้า
							END

							IF @tFilterBy = 'FTBarCode' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' AND ( PBAR.FTBarCode = ''' + @tSearch + ''' )' --//หาบาร์โค้ด
							END

							IF @tFilterBy = 'PDTANDBarcode' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' AND ( PBAR.FTPdtCode =''' + @tSearch + '''  OR  PBAR.FTBarCode =''' + @tSearch + ''' )' --//หาบาร์โค้ด
							END

							IF @tFilterBy = 'FTPunCode' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' AND ( PUNL.FTPunName  COLLATE THAI_BIN    LIKE ''%' + @tSearch + '%'' OR PUNL.FTPunCode COLLATE THAI_BIN LIKE ''%' + @tSearch + '%'' )' --//หาหน่วย
							END								

							IF @tFilterBy = 'FTPgpChain' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' AND ( PGL.FTPgpName   COLLATE THAI_BIN    LIKE ''%' + @tSearch + '%'' OR PGL.FTPgpChainName COLLATE THAI_BIN LIKE ''%' + @tSearch + '%'' ) '--//หากลุ่มสินค้า
							END							

							IF @tFilterBy = 'FTPtyCode' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' AND ( PTL.FTPtyName   COLLATE THAI_BIN    LIKE ''%' + @tSearch + '%'' ) '--//หาประเภทสินค้า
							END	

							IF @tFilterBy = 'FTBuyer' AND @tSearch <> '' BEGIN
								SET @tSQLMaster += ' '--//ผู้จัดซื้อ
							END
								---//--------การค้นหา------///

								---//--------การมองเห็นสินค้าตามผู้ใช้------///

						IF @tUsrLevel != 'HQ' BEGIN
										--//---------------------- การมองเห็นเฉพาะสินค้าตามระดับผู้ใช้--------------------------//
									SET @tSQLMaster += ' AND ( ('
									SET @tSQLMaster += ' PDLSPC.FTAgnCode = '''+@tSesAgnCode+''' '
			
												IF @tSesMerCode != '' AND @tSesMerCode != '' BEGIN 
														SET @tSQLMaster += ' AND PDLSPC.FTMerCode = '''+@tSesMerCode+''' '
												END

												IF (SELECT ISNULL(FTBchCode,'') FROM TCNTUsrGroup WHERE FTUsrCode= @tUsrCode)<>'' BEGIN
														SET @tSQLMaster += ' AND PDLSPC.FTBchCode IN ('+@tSesBchCodeMulti+') OR ISNULL(PDLSPC.FTBchCode,'''') = '''' '
												END
															
												IF @tSesShopCodeMulti != '' BEGIN 
														SET @tSQLMaster += ' AND PDLSPC.FTShpCode IN ('+@tSesShopCodeMulti+') '
												END

									SET @tSQLMaster += ' )'
									-- |-------------------------------------------------------------------------------------------| 

									--//---------------------- การมองเห็นสินค้าระดับสาขา (สำหรับผู้ใช้ระดับร้านค้า)--------------------------//
										IF @tSesShopCodeMulti != '' BEGIN 

												SET @tSQLMaster += ' OR ('--//กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่อยู่ใน Bch แต่ไม่ผูก Shp
												SET @tSQLMaster += ' PDLSPC.FTAgnCode = '''+@tSesAgnCode+''' '
												SET @tSQLMaster += ' AND PDLSPC.FTMerCode = '''+@tSesMerCode+''' '
												SET @tSQLMaster += ' AND PDLSPC.FTBchCode IN ('+@tSesBchCodeMulti+') '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
												SET @tSQLMaster += ' )'

												SET @tSQLMaster += ' OR (' --//กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่อยู่ใน Bch แต่ไม่ผูก Shp และไม่ผูก Mer
												SET @tSQLMaster += ' PDLSPC.FTAgnCode = '''+@tSesAgnCode+''' '
												SET @tSQLMaster += ' AND PDLSPC.FTMerCode = '''' '
												SET @tSQLMaster += ' AND PDLSPC.FTBchCode IN ('+@tSesBchCodeMulti+') '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
												SET @tSQLMaster += ' )'

												SET @tSQLMaster += ' OR (' --//กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่ไม่ผูก Bch และ ไม่ผูก Shp
												SET @tSQLMaster += ' PDLSPC.FTAgnCode = '''+@tSesAgnCode+''' '
												SET @tSQLMaster += ' AND PDLSPC.FTMerCode = '''+@tSesMerCode+''' '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') = '''' '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
												SET @tSQLMaster += ' )'

												SET @tSQLMaster += ' OR (' --//กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่ไม่ผูก Mer และสินค้าผูก Bch / Shp
												SET @tSQLMaster += ' PDLSPC.FTAgnCode = '''+@tSesAgnCode+''' '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''' '
												SET @tSQLMaster += ' AND PDLSPC.FTBchCode IN ('+@tSesBchCodeMulti+') '
												SET @tSQLMaster += ' AND PDLSPC.FTShpCode IN ('+@tSesShopCodeMulti+') '
												SET @tSQLMaster += ' )'

										END
								
									-- |-------------------------------------------------------------------------------------------| 
									-- //---------------------- การมองเห็นสินค้าระดับส่วนกลางหรือสินค้าที่ไม่ได้ผูกกับอะไรเลย--------------------------//
												SET @tSQLMaster += ' OR ('

												SET @tSQLMaster += ' PDLSPC.FTAgnCode = '''+@tSesAgnCode+''' '

												IF @tSesMerCode != '' AND @tSesMerCode != '' BEGIN --//กรณีผู้ใช้ผูก Mer จะต้องเห็นสินค้าที่ไม่ได้ผูก Mer ด้วย
														SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''' '
												END

												IF (SELECT ISNULL(FTBchCode,'') FROM TCNTUsrGroup WHERE FTUsrCode= @tUsrCode)<>'' BEGIN --//กรณีผู้ใช้ผูก Bch จะต้องเห็นสินค้าที่ไม่ได้ผูก Bch ด้วย
														SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''')  = '''' '
												END

												IF @tSesShopCodeMulti != '' BEGIN 
														SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
												END

												SET @tSQLMaster += ' )'
									-- |-------------------------------------------------------------------------------------------| 


								-- //---------------------- การมองเห็นสินค้าระดับส่วนกลางหรือสินค้าที่ไม่ได้ผูกกับอะไรเลย--------------------------//
												SET @tSQLMaster += ' OR ('
												--SET @tSQLMaster += ' Products.FTPtyCode != ''00005'' '
												SET @tSQLMaster += ' ISNULL(PDLSPC.FTAgnCode,'''') = '''' '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''' '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') = '''' '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
												SET @tSQLMaster += ' ))'
								-- |-------------------------------------------------------------------------------------------| 

						END

								---//--------การมองเห็นสินค้าตามผู้ใช้------///


							-----//----Option-----//------

							IF @tWhere != '' BEGIN
								SET @tSQLMaster += @tWhere
							END
							
							IF @tNotInPdtType != '' BEGIN-----//------------- ไม่แสดงสินค้าตาม ประเภทสินค้า -------------------
								SET @tSQLMaster += ' AND ISNULL(Products.FTPDtCode,'''') NOT IN ('+@tNotInPdtType+') '
							END

							IF @tPdtCodeIgnorParam != '' BEGIN----//-------------สินค้าที่ไม่ใช่ตัวข้อมูลหลักในการจัดสินค้าชุด-------------------
								SET @tSQLMaster += ' AND ISNULL(Products.FTPDtCode,'''') != '''+@tPdtCodeIgnorParam+''' '
							END

							IF @tPDTMoveon != '' BEGIN------//---------สินค้าเคลื่อนไหว---------
								SET @tSQLMaster += ' AND  Products.FTPdtStaActive = '''+@tPDTMoveon+''' '
							END

							IF @tPlcCodeConParam != '' AND @tFilterBy = 'FTPlcCode' BEGIN---/ที่เก็บ-  //กรณีที่เข้าไปหา plc code เเล้วไม่เจอ PDT เลย ต้องให้มันค้นหา โดย KEYWORD : EMPTY
									IF  @tPlcCodeConParam != 'EMPTY' BEGIN
											SET @tSQLMaster += ' AND  PBAR.FTBarCode = '''+@tPlcCodeConParam+''' '
									END
									ELSE BEGIN
											SET @tSQLMaster += ' AND  PPCZ.FTPdtCode = ''EMPTY'' AND PPCZ.FTPunCode = ''EMPTY'' '
									END
							END

							IF @ptDISTYPE != '' BEGIN------//----------------อนุญาตลด----------------
								SET @tSQLMaster += ' AND  Products.FTPdtStaAlwDis = '''+@ptDISTYPE+''' '
							END

							IF @tPagename = 'PI' BEGIN------//-----------------เงื่อนไขพิเศษ ตามหน้า-------------
								SET @tSQLMaster += ' AND  Products.FTPdtSetOrSN != ''4'' '
							END

							IF @tNotinItemString  != '' BEGIN-------//-----------------ไม่เอาสินค้าอะไรบ้าง NOT IN-----------
								SET @tSQLMaster += @tNotinItemString
							END

							IF @tSqlCode != '' BEGIN------//----------------ผู้จำหน่าย-------------------
								SET @tSQLMaster += ' AND  ( PDTSPL.FTSplCode = '''+@tSqlCode+'''  OR ISNULL(PDTSPL.FTSplCode,'''') = '''' ) '
							END
							-----//----Option-----//------
								
							SET @tSQLMaster += ' ) Base '

							IF @nRow != ''  BEGIN------------เงื่อนไขพิเศษ แบ่งหน้า----
								SET @tSQLMaster += ' ORDER BY Base.FDCreateOn DESC '
								SET @tSQLMaster += ' OFFSET '+CAST(((@nPage-1)*@nRow) AS VARCHAR(10))+' ROWS FETCH NEXT '+CAST(@nRow AS VARCHAR(10))+' ROWS ONLY'
							END


----//----------------------Data Master And Filter-------------//			



----//----------------------Query Builder-------------//

								SET @tSQL = '  SELECT PDT.rtCountData ,PDT.FTAgnCode,PDT.FTBchCode AS FTPdtSpcBch,PDT.FTShpCode,PDT.FTMerCode,PDT.FTImgObj,';
								SET @tSQL += ' PDT.FTPdtCode,PDT_L.FTPdtName,PDT.FTPdtForSystem,PDT.FTPdtStaVatBuy,PDT.FTPdtStaVat,PDT.FTVatCode,ISNULL(VAT.FCVatRate, 0) AS FCVatRate, '
								SET @tSQL += ' PDT.FTPdtStaActive,PDT.FTPdtSetOrSN,PDT.FTPgpChain,PDT.FTPtyCode,ISNULL(PDT_AGE.FCPdtCookTime,0) AS FCPdtCookTime,ISNULL(PDT_AGE.FCPdtCookHeat,0) AS FCPdtCookHeat, '
								SET @tSQL += ' PDT.FTPunCode,PDT_UNL.FTPunName,PDT.FCPdtUnitFact, PDT.FTSplCode,PDT.FTBuyer,PDT.FTBarCode,PDT.FTPdtStaAlwDis,PDT.FTPdtType,PDT.FCPdtCostStd'

								IF @tPriceType = 'Pricesell' OR @tPriceType = '' BEGIN------///ถ้าเป็นราคาขาย---
									SET @tSQL += '  ,0 AS FCPgdPriceNet,0 AS FCPgdPriceRet,0 AS FCPgdPriceWhs'
								END

								IF @tPriceType = 'Price4Cst' BEGIN------// //ถ้าเป็นราคาทุน-----
									SET @tSQL += '  ,0 AS FCPgdPriceNet,0 AS FCPgdPriceWhs,'
									SET @tSQL += '  CASE'
									SET @tSQL += '  WHEN ISNULL(PCUS.FCPgdPriceRet,0) <> 0 THEN PCUS.FCPgdPriceRet'
									SET @tSQL += '  WHEN ISNULL(PBCH.FCPgdPriceRet,0) <> 0 THEN PBCH.FCPgdPriceRet'
									SET @tSQL += '  WHEN ISNULL(PEMPTY.FCPgdPriceRet,0) <> 0 THEN PEMPTY.FCPgdPriceRet'
									SET @tSQL += '  ELSE 0'
									SET @tSQL += '  END AS FCPgdPriceRet'
								END

								IF @tPriceType = 'Cost' BEGIN------//-----
									SET @tSQL += '  ,ISNULL(VPC.FCPdtCostStd,0)       AS FCPdtCostStd    , ISNULL(FCPdtCostAVGIN,0)     AS FCPdtCostAVGIN,'
									SET @tSQL += '  ISNULL(VPC.FCPdtCostAVGEx,0)     AS FCPdtCostAVGEx  , ISNULL(FCPdtCostLast,0)      AS FCPdtCostLast,'
									SET @tSQL += '  ISNULL(VPC.FCPdtCostFIFOIN,0)    AS FCPdtCostFIFOIN , ISNULL(FCPdtCostFIFOEx,0)    AS FCPdtCostFIFOEx'
								END

							  SET @tSQL += ' FROM ('
				
								SET @tSQL +=  @tSQLMaster
		
								SET @tSQL += ' ) PDT ';
		            SET @tSQL += ' LEFT JOIN TCNMPdt_L AS PDT_L WITH(NOLOCK) ON PDT.FTPdtCode = PDT_L.FTPdtCode AND PDT_L.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
								SET @tSQL += ' LEFT JOIN TCNMPdtUnit_L AS PDT_UNL WITH(NOLOCK) ON PDT.FTPunCode = PDT_UNL.FTPunCode  AND PDT_UNL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''''
								--SET @tSQL += ' LEFT OUTER JOIN TCNMImgPdt AS PDT_IMG WITH(NOLOCK) ON PDT.FTPdtCode = PDT_IMG.FTImgRefID AND PDT_IMG.FTImgTable = ''TCNMPdt'' AND PDT_IMG.FNImgSeq = 1 '
								SET @tSQL += ' LEFT OUTER JOIN TCNMPdtAge AS PDT_AGE WITH(NOLOCK) ON PDT.FTPdtCode = PDT_AGE.FTPdtCode '
								SET @tSQL += ' LEFT OUTER JOIN VCN_VatActive AS VAT WITH(NOLOCK) ON PDT.FTVatCode = VAT.FTVatCode '


								IF @tPriceType = 'Pricesell' OR @tPriceType = ''  BEGIN------//-----
									SET @tSQL += '  '
								END


								IF @tPriceType = 'Price4Cst' BEGIN
														--//----ราคาของ customer
								            SET @tSQL += '  LEFT JOIN ( '
                            SET @tSQL += ' SELECT * FROM ('
                            SET @tSQL += ' SELECT '
														SET @tSQL += ' ROW_NUMBER () OVER ( PARTITION BY FTPdtCode , FTPunCode ORDER BY FDPghDStart,FTPghTStart DESC) AS FNRowPart,'
														SET @tSQL += ' FTPdtCode , '
														SET @tSQL += ' FTPunCode , '
														SET @tSQL += ' FCPgdPriceRet '
														SET @tSQL += ' FROM TCNTPdtPrice4PDT WHERE  '
                            SET @tSQL += ' FDPghDStart <= CONVERT (VARCHAR(10), GETDATE(), 121)'
                            SET @tSQL += ' AND FDPghDStop >= CONVERT (VARCHAR(10), GETDATE(), 121)'
                            SET @tSQL += ' AND FTPghTStart <= CONVERT(time,GETDATE())'
														SET @tSQL += ' AND FTPghTStop >= CONVERT(time,GETDATE())'
                            SET @tSQL += ' AND FTPplCode = '''+@tPplCode+''' '
                            SET @tSQL += ' ) AS PCUS '
                            SET @tSQL += ' WHERE PCUS.FNRowPart = 1 '
														SET @tSQL += ' ) PCUS ON PDT.FTPdtCode = PCUS.FTPdtCode AND PDT.FTPunCode = PCUS.FTPunCode' 

													--// --ราคาของสาขา
														SET @tSQL += ' LEFT JOIN ('
                            SET @tSQL += ' SELECT * FROM ('
                            SET @tSQL += ' SELECT '
														SET @tSQL += ' ROW_NUMBER () OVER ( PARTITION BY FTPdtCode , FTPunCode ORDER BY FDPghDStart,FTPghTStart DESC) AS FNRowPart,'
														SET @tSQL += ' FTPdtCode , '
														SET @tSQL += ' FTPunCode , '
														SET @tSQL += ' FCPgdPriceRet '
														SET @tSQL += ' FROM TCNTPdtPrice4PDT WHERE  '
                            SET @tSQL += ' FDPghDStart <= CONVERT (VARCHAR(10), GETDATE(), 121)'
                            SET @tSQL += ' AND FDPghDStop >= CONVERT (VARCHAR(10), GETDATE(), 121)'
                            SET @tSQL += ' AND FTPghTStart <= CONVERT(time,GETDATE())'
														SET @tSQL += ' AND FTPghTStop >= CONVERT(time,GETDATE())'
                            SET @tSQL += ' AND FTPplCode = (SELECT FTPplCode FROM TCNMBranch WHERE FTPplCode != '''' AND FTBchCode = (SELECT TOP 1 FTBchCode FROM TCNMBranch WHERE FTAgnCode = '''+@tSesAgnCode+''' ))'
                            SET @tSQL += ') AS PCUS '
                            SET @tSQL += ' WHERE PCUS.FNRowPart = 1 '
														SET @tSQL += ' ) PBCH ON PDT.FTPdtCode = PBCH.FTPdtCode AND PDT.FTPunCode = PBCH.FTPunCode '


												--// --ราคาที่ไม่กำหนด PPL
														SET @tSQL += ' LEFT JOIN ('
                            SET @tSQL += ' SELECT * FROM ('
                            SET @tSQL += ' SELECT '
														SET @tSQL += ' ROW_NUMBER () OVER ( PARTITION BY FTPdtCode , FTPunCode ORDER BY FDPghDStart,FTPghTStart DESC) AS FNRowPart,'
														SET @tSQL += ' FTPdtCode , '
														SET @tSQL += ' FTPunCode , '
														SET @tSQL += ' FCPgdPriceRet '
														SET @tSQL += 'FROM TCNTPdtPrice4PDT WHERE  '
                            SET @tSQL += ' FDPghDStart <= CONVERT (VARCHAR(10), GETDATE(), 121)'
                            SET @tSQL += 'AND FDPghDStop >= CONVERT (VARCHAR(10), GETDATE(), 121)'
                            SET @tSQL += ' AND FTPghTStart <= CONVERT(time,GETDATE())'
														SET @tSQL += ' AND FTPghTStop >= CONVERT(time,GETDATE())'
                            SET @tSQL += ' AND ISNULL(FTPplCode,'''') = '''' '
                            SET @tSQL += ' ) AS PCUS '
                            SET @tSQL += ' WHERE PCUS.FNRowPart = 1 '
														SET @tSQL += ' ) PEMPTY ON PDT.FTPdtCode = PEMPTY.FTPdtCode AND PDT.FTPunCode = PEMPTY.FTPunCode'

								END

								IF @tPriceType = 'Cost' BEGIN------//-----
														SET @tSQL += '  LEFT JOIN VCN_ProductCost VPC WITH(NOLOCK) ON VPC.FTPdtCode = PDT.FTPdtCode'
								END
----//----------------------Query Builder-------------//
--select @tSQL

 EXECUTE(@tSQL)
--PRINT @tSQL
--RETURN @tSQL
	--select @tSQL
		 SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage; 
END
GO




IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxSalByPdtSet')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].SP_RPTxSalByPdtSet
GO
CREATE PROCEDURE [dbo].[SP_RPTxSalByPdtSet]
--ALTER PROCEDURE [dbo].[SP_RPTxMnyShotOverTmp_Moshi]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN
	
--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

--ร้านค้า
	@ptShpL Varchar(8000), --ร้านค้า Condition IN
	@ptShpF Varchar(5),
	@ptShpT Varchar(5),

--จุดขาย
	@ptPosL Varchar(8000), --จุดขาย Condition IN
	@ptPosF Varchar(5),
	@ptPosT Varchar(5),

--เลขที่เอกสาร
	@ptDocNoL Varchar(8000),


	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),
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

	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	--Pos Code
	DECLARE @tPosF Varchar(5)
	DECLARE @tPosT Varchar(5)

	--Cst Code
	DECLARE @tCstCodeF Varchar(30)
	DECLARE @tCstCodeT Varchar(30)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)


	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT
	--Branch
	SET @tPosF  = @ptPosF
	SET @tPosT  = @ptPosT

	

	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult= 0

	SET @tDocDateF = CONVERT(VARCHAR(10),@tDocDateF,121)
	SET @tDocDateT = CONVERT(VARCHAR(10),@tDocDateT,121)



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


	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

		
	SET @tSql1 =   ' '

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
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
			SET @tSql1 +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTShpCode IN (' + @ptShpL + ')'
		END	

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
		END		

	 IF (@ptDocNoL <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTXshDocNo IN (' + @ptDocNoL + ')'
		END		


	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
    	SET @tSql1 +=' AND CONVERT(VARCHAR(10),HD.FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END


	DELETE FROM TRPTSalByPdtSetTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''
 

  SET @tSql = ' INSERT INTO TRPTSalByPdtSetTmp'
	SET @tSql +=' (FTUsrSession,FTComName,FTRptCode,'
	SET @tSql +=' FTBchName,FTXshDocNo,FTBchCode,FNXsdSeqNo,FTPdtCode,FTPdtCodeSet,FTPdtStaSet,FTPgpChainName,FTXsdPdtName,FCXsdQty,FTPunName,FCXsdNet,FCXddValue,FCXsdNetAfHD '
	SET @tSql +=' )'

	SET @tSql +=' SELECT '''+ @tUsrSession +''' AS FTUsrSession ,'''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode , S.* FROM ('


	SET @tSql +=' SELECT BCH.FTBchName, A.* FROM ('
	--SET @tSql +=' SELECT DT.FTXshDocNo, DT.FTBchCode, DT.FNXsdSeqNo, DT.FTPdtCode, '''' AS  FTPdtCodeSet,FTPdtStaSet AS FTPdtStaSet , PDTGRP.FTPgpChainName,DT.FTXsdPdtName, DT.FCXsdQty,DT.FTPunName, DT.FCXsdNet,ISNULL(DTD.FCXddValue,0) AS FCXddValue,DT.FCXsdNetAfHD'
	SET @tSql +=' SELECT '''' AS FTXshDocNo,DT.FTBchCode,'''' AS FNXsdSeqNo,DT.FTPdtCode,'''' AS FTPdtCodeSet,FTPdtStaSet AS FTPdtStaSet,PDTGRP.FTPgpChainName,DT.FTXsdPdtName,SUM (CASE WHEN HD.FNXshDocType = ''1'' THEN DT.FCXsdQty ELSE DT.FCXsdQty*-1 END) AS FCXsdQty,DT.FTPunName,SUM (CASE WHEN HD.FNXshDocType = ''1'' THEN DT.FCXsdNet ELSE DT.FCXsdNet*-1 END) AS FCXsdNet,SUM (CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(DTD.FCXddValue, 0) ELSE ISNULL(DTD.FCXddValue, 0)*-1 END) AS FCXddValue,SUM (CASE WHEN HD.FNXshDocType = ''1'' THEN DT.FCXsdNetAfHD ELSE DT.FCXsdNetAfHD*-1 END) AS FCXsdNetAfHD'
	SET @tSql +=' FROM TPSTSalDT DT WITH(NOLOCK) LEFT JOIN TPSTSalHD HD WITH(NOLOCK) ON DT.FTXshDocNo = HD.FTXshDocNo AND DT.FTBchCode = HD.FTBchCode'
  SET @tSql +=' LEFT JOIN TCNMPdt PDT WITH (NOLOCK) ON DT.FTPdtCode = PDT.FTPdtCode '
  SET @tSql +=' LEFT JOIN TCNMPdtGrp_L PDTGRP WITH (NOLOCK) ON PDT.FTPgpChain = PDTGRP.FTPgpChain AND PDTGRP.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql +=' LEFT JOIN (SELECT DTS.FTXshDocNo,DTS.FTBchCode,DTS.FNXsdSeqNo,'
	SET @tSql +=' SUM(CASE DTS.FNXddStaDis WHEN 1 THEN DTS.FCXddValue WHEN 2 THEN DTS.FCXddValue WHEN 3 THEN DTS.FCXddValue * -1 WHEN 4 THEN DTS.FCXddValue * -1 ELSE 0 END) AS FCXddValue'
	SET @tSql +=' FROM TPSTSalDTDis DTS WITH(NOLOCK) LEFT JOIN TPSTSalHD HD WITH(NOLOCK) ON HD.FTXshDocNo = DTS.FTXshDocNo AND HD.FTBchCode = DTS.FTBchCode'
	SET @tSql +=' WHERE HD.FTXshStaDoc = 1'
	SET @tSql += @tSql1
	SET @tSql +=' GROUP BY  DTS.FTXshDocNo,DTS.FTBchCode,DTS.FNXsdSeqNo) DTD ON DT.FTXshDocNo = DTD.FTXshDocNo AND DT.FTBchCode = DTD.FTBchCode AND DT.FNXsdSeqNo = DTD.FNXsdSeqNo'
	SET @tSql +=' WHERE HD.FTXshStaDoc = 1 AND ISNULL(PDT.FTPdtType,'''') <> ''6''  AND ISNULL(DT.FTXsdStaPdt, '''') <> ''4'' '
	SET @tSql += @tSql1
	SET @tSql +=' GROUP BY  DT.FTBchCode , DT.FTPdtCode , DT.FTPdtStaSet , PDTGRP.FTPgpChainName , DT.FTXsdPdtName , DT.FTPunName'
  SET @tSql +=' UNION ALL '
  --SET @tSql +=' SELECT '''' AS FTXshDocNo,DTS.FTBchCode,'''' AS FNXsdSeqNo, DT.FTPdtCode, DTS.FTPdtCode AS FTPdtCodeSet,''4'',PDTGRP.FTPgpChainName, DTS.FTXsdPdtName,DTS.FCXsdQtySet,DT.FTPunName,DTS.FCXsdSalePrice, 0 AS FCXddValue,DTS.FCXsdSalePrice '
  SET @tSql +=' SELECT '''' AS FTXshDocNo,DTS.FTBchCode,'''' AS FNXsdSeqNo,DT.FTPdtCode,DTS.FTPdtCode AS FTPdtCodeSet,''4'',PDTGRP.FTPgpChainName,DTS.FTXsdPdtName,SUM (CASE WHEN HD.FNXshDocType = ''1'' THEN (DTS.FCXsdQtySet*DT.FCXsdQty) ELSE (DTS.FCXsdQtySet*DT.FCXsdQty)*-1 END) AS FCXsdQty,DT.FTPunName,SUM(DTS.FCXsdSalePrice) AS FCXsdSalePrice,0 AS FCXddValue,SUM(DTS.FCXsdSalePrice) AS FCXsdSalePrice'
	SET @tSql +=' FROM TPSTSalDTSet DTS WITH(NOLOCK) '
  SET @tSql +=' LEFT JOIN TPSTSalDT DT WITH(NOLOCK) ON DT.FTXshDocNo = DTS.FTXshDocNo AND DT.FTBchCode = DTS.FTBchCode AND DT.FNXsdSeqNo = DTS.FNXsdSeqNo '
  SET @tSql +=' LEFT JOIN TPSTSalHD HD WITH(NOLOCK) ON DTS.FTXshDocNo = HD.FTXshDocNo AND DTS.FTBchCode = HD.FTBchCode '
  SET @tSql +=' LEFT JOIN TCNMPdt PDT WITH (NOLOCK) ON DTS.FTPdtCode = PDT.FTPdtCode '
  SET @tSql +=' LEFT JOIN TCNMPdtGrp_L PDTGRP WITH (NOLOCK) ON PDT.FTPgpChain = PDTGRP.FTPgpChain AND PDTGRP.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
  SET @tSql +=' WHERE HD.FTXshStaDoc = 1  AND ISNULL(PDT.FTPdtType,'''') <> ''6'' AND ISNULL(DT.FTXsdStaPdt, '''') <> ''4'' '
	SET @tSql += @tSql1
	SET @tSql += ' GROUP BY DTS.FTBchCode , DT.FTPdtCode,DTS.FTPdtCode,PDTGRP.FTPgpChainName,DTS.FTXsdPdtName,DT.FTPunName'
  SET @tSql +=' ) A LEFT JOIN TCNMBranch_L BCH ON A.FTBchCode = BCH.FTBchCode AND BCH.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '


	SET @tSql +=' ) S'
  SET @tSql += ' ORDER BY s.FTBchCode,s.FTXshDocNo,s.FTPdtCode,s.FTPdtCodeSet'
	--PRINT @tSql

	EXECUTE(@tSql)
	--RETURN SELECT * FROM TRPTCancelBillByDateTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
END TRY

BEGIN CATCH 
	SET @FNResult= -1

END CATCH		
GO


IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxPricePrc')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_DOCxPricePrc
GO
CREATE PROCEDURE [dbo].STP_DOCxPricePrc
 @ptBchCode varchar(5)
,@ptDocNo varchar(30)
,@ptWho varchar(100) ,@FNResult INT OUTPUT AS
DECLARE @tHQCode varchar(5)
DECLARE @tBchTo varchar(5)	--2.--
DECLARE @tZneTo varchar(30)	--2.--
DECLARE @tAggCode  varchar(5)	--2.--
DECLARE @tPplCode  varchar(5)	--2.--
DECLARE @TTmpPrcPri TABLE 
   ( 
   --FTAggCode  varchar(5), /*Arm 63-06-08 Comment Code */
   --FTPghZneTo varchar(30), /*Arm 63-06-08 Comment Code */
   --FTPghBchTo varchar(5), /*Arm 63-06-08 Comment Code */
   FTPghDocNo varchar(20), 
   FTPplCode varchar(20), 
   FTPdtCode varchar(20),
   FTPunCode varchar(5),
   FDPghDStart datetime,
   FTPghTStart varchar(10),
   FDPghDStop datetime,
   FTPghTStop varchar(10),
   FTPghDocType varchar(1),
   FTPghStaAdj varchar(1),
   FCPgdPriceRet numeric(18, 4),
   --FCPgdPriceWhs numeric(18, 4), /*Arm 63-06-08 Comment Code */
   --FCPgdPriceNet numeric(18, 4), /*Arm 63-06-08 Comment Code */
   FTPdtBchCode varchar(5)
   ) 
DECLARE @tStaPrc varchar(1)		-- 6. --
/*---------------------------------------------------------------------
Document History
version		Date			User	Remark
02.01.00	23/03/2020		Em		create  
02.02.00	08/06/2020		Arm     แก้ไข ยกเลิกฟิวด์
04.01.00	08/10/2020		Em		แก้ไขกรณีข้อมูลซ้ำกัน
05.01.00	11/05/2021		Em		แก้ไขเรื่อง Group ตาม PplCode ด้วย
21.07.01	08/10/2021		Em		ปรับ PK Price4PDT
21.07.02	11/04/2022		Zen		ปรับ DELETE ออก
----------------------------------------------------------------------*/
BEGIN TRY
	--SET @tHQCode = ISNULL((SELECT TOP 1 FTBchCode FROM TCNMBranch with(nolock) WHERE ISNULL(FTBchStaHQ,'') = '1' ),'')

	/*Arm 63-06-08 Comment Code */
	--SELECT TOP 1 @tAggCode = ISNULL(FTAggCode,'') ,@tZneTo = ISNULL(FTXphZneTo,''),@tBchTo = ISNULL(FTXphBchTo,'') 
	--,@tPplCode = ISNULL(FTPplCode,'') 
	--,@tStaPrc = ISNULL(FTXphStaPrcDoc,'')	-- 6. --
	--FROM TCNTPdtAdjPriHD with(nolock) WHERE FTXphDocNo = @ptDocNo	--4.--
	
	/*Arm 63-06-08 Edit Code */
	SELECT TOP 1 @tPplCode = ISNULL(FTPplCode,'') 
	,@tStaPrc = ISNULL(FTXphStaPrcDoc,'')	-- 6. --
	FROM TCNTPdtAdjPriHD with(nolock) WHERE FTXphDocNo = @ptDocNo	--4.--
	/*Arm 63-06-08 End Edit Code */
	 
	 --select 4/0

	IF @tStaPrc <> '1'	-- 6. --
	BEGIN
		--INSERT INTO @TTmpPrcPri(FTAggCode, FTPghZneTo, FTPghBchTo, FTPplCode, FTPdtCode, FTPunCode, FDPghDStart, FTPghTStart, /*Arm 63-06-08 Comment Code */
		--FDPghDStop, FTPghTStop, FTPghDocNo, FTPghDocType, FTPghStaAdj, FCPgdPriceRet, FCPgdPriceWhs, FCPgdPriceNet, FTPdtBchCode) /*Arm 63-06-08 Comment Code */
		INSERT INTO @TTmpPrcPri(FTPplCode, FTPdtCode, FTPunCode, FDPghDStart, FTPghTStart,
		FDPghDStop, FTPghTStop, FTPghDocNo, FTPghDocType, FTPghStaAdj, FCPgdPriceRet, FTPdtBchCode)
		-- SELECT DISTINCT ISNULL(HD.FTAggCode,'') AS FTAggCode, ISNULL(HD.FTXphZneTo,'') AS FTPghZneTo, ISNULL(HD.FTXphBchTo,'') AS FTPghBchTo, ISNULL(HD.FTPplCode,'') AS FTPplCode, /*Arm 63-06-08 Comment Code */
		SELECT DISTINCT ISNULL(HD.FTPplCode,'') AS FTPplCode, 
				DT.FTPdtCode, DT.FTPunCode, HD.FDXphDStart, HD.FTXphTStart,
				HD.FDXphDStop, HD.FTXphTStop , HD.FTXphDocNo, HD.FTXphDocType, HD.FTXphStaAdj, 
				--DT.FCXpdPriceRet, DT.FCXpdPriceWhs, DT.FCXpdPriceNet, DT.FTXpdBchTo		--2.-- /*Arm 63-06-08 Comment Code */
				DT.FCXpdPriceRet, DT.FTXpdBchTo		--2.--
		FROM TCNTPdtAdjPriDT DT with(nolock)		--4.--
		INNER JOIN TCNTPdtAdjPriHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXphDocNo = HD.FTXphDocNo	--4.--
		WHERE HD.FTXphDocNo = @ptDocNo	-- 7. --

		-- 04.01.00 --
		-- 21.07.02 --
		--DELETE TMP
		--FROM @TTmpPrcPri TMP
		--INNER JOIN TCNTPdtPrice4PDT PDT with(nolock) ON TMP.FTPdtCode = PDT.FTPdtCode AND TMP.FTPunCode = PDT.FTPunCode
		--		AND TMP.FDPghDStart = PDT.FDPghDStart AND TMP.FTPghTStart = PDT.FTPghTStart
		--		AND TMP.FTPplCode = PDT.FTPplCode	-- 05.01.00 --
		--		AND TMP.FTPghDocType = PDT.FTPghDocType	-- 21.07.01 --
		--		AND TMP.FTPghDocNo <= PDT.FTPghDocNo

		--DELETE PDT
		--FROM TCNTPdtPrice4PDT PDT
		--INNER JOIN @TTmpPrcPri TMP ON TMP.FTPdtCode = PDT.FTPdtCode AND TMP.FTPunCode = PDT.FTPunCode
		--		AND TMP.FDPghDStart = PDT.FDPghDStart AND TMP.FTPghTStart = PDT.FTPghTStart
		--		AND TMP.FTPplCode = PDT.FTPplCode	-- 05.01.00 --
		--		AND TMP.FTPghDocType = PDT.FTPghDocType	-- 21.07.01 --
		--		AND TMP.FTPghDocNo >= PDT.FTPghDocNo
		-- 21.07.02 --
		-- 04.01.00 --

		INSERT INTO TCNTPdtPrice4PDT
			(FTPdtCode, FTPunCode, FDPghDStart, FTPghTStart,FDPghDStop, FTPghTStop, 
			FTPghDocNo, FTPghDocType, FTPghStaAdj, FCPgdPriceRet, --FCPgdPriceWhs, FCPgdPriceNet, /*Arm 63-06-08 Comment Code */
			FTPplCode,
			FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy)	-- 5.--
		SELECT FTPdtCode, FTPunCode, FDPghDStart, FTPghTStart,FDPghDStop, FTPghTStop, 
			FTPghDocNo, FTPghDocType, FTPghStaAdj, FCPgdPriceRet, --FCPgdPriceWhs, FCPgdPriceNet,
			FTPplCode,
			GETDATE(),@ptWho,GETDATE(),@ptWho	-- 5. --
		FROM @TTmpPrcPri

	END	-- 6. --
	SET @FNResult= 0
END TRY
BEGIN CATCH
    --EXEC STP_MSGxWriteTSysPrcLog @ptComName,@ptWho,@ptDocNo ,@tDate ,@tTime
    SET @FNResult= -1
	select ERROR_MESSAGE()
END CATCH
GO








IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxUseCard2')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPTxUseCard2] 
GO
CREATE PROCEDURE [dbo].[SP_RPTxUseCard2] 
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptName Varchar(100),

	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--กลุ่มธุรกิจ
	@ptMerL Varchar(8000), --กลุ่มธุรกิจ Condition IN
	@ptMerF Varchar(5),
	@ptMerT Varchar(5),

	--ร้านค้า
	@ptShpL Varchar(8000), --ร้านค้า Condition IN
	@ptShpF Varchar(5),
	@ptShpT Varchar(5),

	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptCrdF Varchar(30),
	@ptCrdT Varchar(30),
	@ptUserIdF Varchar(30),
	@ptUserIdT Varchar(30),
	@ptCrdActF Varchar(1), --สถานะบัตร
	@ptCrdActT Varchar(1),
	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 19/06/2019
-- @pnLngID ภาษา
-- @ptRptName ชื่อรายงาน
-- @ptRptName ชื่อรายงาน
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
-- @pnCrdF จากบัตร 
-- @pnCrdT ถึงหมายเลขบัตร
-- @ptUserIdF จากรหัสพนักงาน,
-- @ptUserIdT ถึงรหัสพนักงาน,
 --@ptCrdActF Varchar(5), --ประเภทบัตร
 --@ptCrdActT Varchar(5),
-- @ptDocDateF จากวันที่
-- @ptDocDateT ถึงวันที่
-- @FNResult
--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptName Varchar(100)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSqlIns1 VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSql2 VARCHAR(8000)

	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)
	DECLARE @tCrdF Varchar(30)
	DECLARE @tCrdT Varchar(30)
	DECLARE @tUserIdF Varchar(30)
	DECLARE @tUserIdT Varchar(30)
	--FTCtyCode
	DECLARE @tCrdActF Varchar(1) --ประเภทบัตร
	DECLARE @tCrdActT Varchar(1)
	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)

	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'UseCard2'
	--SET @tBchF = '00032'
	--SET @tBchT = '00034'
	--SET @tCrdF = '2019030500'
	--SET @tCrdT = '2019030600'
	--SET @tUserIdF = '2019030551'
	--SET @tUserIdT = '2019030800'
	--SET @tCrdActF = '1'
	--SET @tCrdActT = '3'
	--SET @tDocDateF = '2019-01-01'
	--SET @tDocDateT = '2019-06-30'

	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'UseCard2'
	--SET @tBchF = ''
	--SET @tBchT = ''
	--SET @tCrdF = ''
	--SET @tCrdT = ''
	--SET @tUserIdF = ''
	--SET @tUserIdT = ''
	--SET @tCrdActF = ''
	--SET @tCrdActT = ''
	--SET @tDocDateF = ''
	--SET @tDocDateT = ''

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tRptName = @ptRptName
	SET @tBchF = @ptBchF
	SET @tBchT = @ptBchT
	SET @tCrdF = @ptCrdF
	SET @tCrdT = @ptCrdT
	SET @tUserIdF =  @ptUserIdF
	SET @tUserIdT =  @ptUserIdT
	SET @tCrdActF = @ptCrdActF
	SET @tCrdActT = @ptCrdActT
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
		IF @tBchF = null
		BEGIN
			SET @tBchF = ''
		END
		IF @tBchT = null OR @tBchT = ''
		BEGIN
			SET @tBchT = @tBchF
		END

		IF @tCrdF = null
		BEGIN
			SET @tCrdF = ''
		END 

		IF @tDocDateF = null
		BEGIN 
			SET @tDocDateF = ''
		END

		IF @tCrdT = null OR @tCrdT =''
		BEGIN
			SET @tCrdT = @tCrdF
		END 

		IF @tDocDateT = null OR @tDocDateT =''
		BEGIN 
			SET @tDocDateT = @tDocDateF
		END

		if @tCrdActF = null 
		BEGIN
			SET @tCrdActF = ''
		END
		IF @tCrdActT = null or @tCrdActF = ''
		BEGIN 
			SET @tCrdActT = @tCrdActF
		END 

		IF @tUserIdF = null
		BEGIN
			SET @tUserIdF = ''
		END

		IF @tUserIdT = null OR @tUserIdT = ''
		BEGIN
			SET @tUserIdT = @tUserIdF
		END

		SET @tSql1 = ' WHERE 1=1 '

		IF @pnFilterType = '1'
		BEGIN
			IF (@ptBchF <> '' AND @ptBchT <> '')
			BEGIN
				SET @tSql1 +=' AND CT.FTBchCode BETWEEN ''' + @ptBchF + ''' AND ''' + @ptBchT + ''''
			END

			IF (@ptMerF <> '' AND @ptMerT <> '')
			BEGIN
				SET @tSql1 +=' AND SHP.FTMerCode BETWEEN ''' + @ptMerF + ''' AND ''' + @ptMerT + ''''
			END

			IF (@ptShpF <> '' AND @ptShpT <> '')
			BEGIN
				SET @tSql1 +=' AND CT.FTShpCode BETWEEN ''' + @ptShpF + ''' AND ''' + @ptShpT + ''''
			END

			IF (@ptPosF <> '' AND @ptPosT <> '')
			BEGIN
				SET @tSql1 +=' AND CT.FTTxnPosCode BETWEEN ''' + @ptPosF + ''' AND ''' + @ptPosT + ''''
			END

		END

		IF @pnFilterType = '2'
		BEGIN
			IF (@ptBchL <> '' )
			BEGIN
				SET @tSql1 +=' AND CT.FTBchCode IN (' + @ptBchL + ')'
			END

			IF (@ptMerL <> '')
			BEGIN
				SET @tSql1 += ' AND SHP.FTMerCode IN (' + @ptMerL + ')'
			END	

			IF (@ptShpL <> '')
			BEGIN
				SET @tSql1 += ' AND CT.FTShpCode IN (' + @ptShpL + ')'
			END	

			IF (@ptPosL <> '')
			BEGIN
				SET @tSql1 += ' AND CT.FTTxnPosCode IN (' + @ptPosL + ')'
			END	
		
		END
		
		IF (@tCrdF <> '' AND @tCrdT <> '')
		BEGIN
			SET @tSql1 +=' AND FTCrdCode BETWEEN ''' + @tCrdF + ''' AND ''' + @tCrdT + ''''
		END

		IF (@tDocDateF <> '' AND @tDocDateT <> '')
		BEGIN
			SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		END
		
		--print @tSql1
		--DECLARE @nComName Varchar(100)
		--SET @nComName = 'Ada062'
	DELETE FROM TFCTRptCrdTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptName = '' + @tRptName + '' AND FTUsrSession = '' + @ptUsrSession + '' --ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 
	 --SELECT        A.FTBchCode, A.FTTxnDocNoRef, A.FTShpCode, A.FTShpName, A.FTTxnPosCode, A.FTDptName, A.FTPosType, A.FNTxnID, A.FNTxnIDRef, A.FTTxnDocType, A.FTTxnStaOffLine, A.FTCrdCode, A.FTCtyName, 
	 --                        A.FTCtyCode, A.FTCrdHolderID, A.FTCrdStaActive, A.FDTxnDocDate, A.FDCrdExpireDate, A.FTBchCodeRef, A.FCTxnValue, A.FCTxnCrdValue, A.FCTxnCrdAftTrans, A.FTCrdName, A.FCCrdBalance, A.CardExpValue, 
	 --                        A.FTTxnDocTypeName, A.FNLngID, A.FNDplLngID, A.FNCtyLngID, A.FNShpLngID, A.FTUsrCreate, A.FTDocLastUpdBy, 
	 --                        CASE WHEN A.FTTxnDocType = 3 THEN A.FTTxnPosCode WHEN A.FTTxnDocType = 4 THEN A.FTTxnPosCode WHEN A.FTTxnDocType = 5 THEN A.FTTxnPosCode ELSE USRL.FTUsrName END AS FTDocCreateBy,
	 --                         ISNULL(USRL.FNLngID, 1) AS FNUsrLngID
    --DROP TABLE #TFCTRptCrdTemp
    SELECT * INTO #TFCTRptCrdTemp FROM TFCTRptCrdTmp WHERE FTComName = '' + @nComName + ''  AND FTRptName = '' + @tRptName + '' AND FTUsrSession = '' + @ptUsrSession + ''
	TRUNCATE TABLE #TFCTRptCrdTemp
	--SELECT * FROM #TFCTRptCrdTmp

	SET @tSql ='INSERT INTO #TFCTRptCrdTemp WITH(ROWLOCK)' --เพิ่มข้อมูลใหม่ที่ Contion ลง Temp
	SET @tSql +=' ('
	SET @tSql +='FTUsrSession,FTComName,FTRptName,'
	SET @tSql +='FTTxndocType,FTCrdCode,FTCrdName,FTCtyName,FTCrdHolderID,FTShpCode,FTShpName,FTCrdStaActive,FTDptName,FCTxnCrdAftTrans,'
	SET @tSql += 'FTBchCode,FTBchName,'
	SET @tSql +='FTTxnPosCode,FTPosType,FTTxnDocRefNo,FTTxnDocNoRef,FTTxnDocTypeName,FNTxnID,FNTxnIDRef,'
--	SET @tSql +='FTDocCreateBy,'
	SET @tSql +='FDTxnDocDate,FCCrdBalance,FNLngID,FCTxnValue'
	SET @tSql +=') '--SELECT * FROM #TFCTRptCrdTmp WITH(NOLOCK)'
	--SET @tSql += 'SELECT '''+ @ptUsrSession + ''' AS FTUsrSession, '''+ @nComName + ''' AS FTComName, '''+ @tRptName +''' AS FTRptName,'
	SET @tSql += 'SELECT DISTINCT '''+ @ptUsrSession + ''' AS FTUsrSession, '''+ @nComName + ''' AS FTComName, '''+ @tRptName +''' AS FTRptName,'	--*Em 63-12-29
	SET @tSql += 'A.FTTxnDocType,A.FTCrdCode,A.FTCrdName,A.FTCtyName,A.FTCrdHolderID,A.FTShpCode,A.FTShpName,A.FTCrdStaActive,A.FTDptName,A.FCTxnCrdAftTrans,'
	SET @tSql += 'A.FTBchCode,A.FTBchName,'
	SET @tSql += 'A.FTTxnPosCode,A.FTPosType,'''' AS FTTxnDocRefNo,A.FTTxnDocNoRef,A.FTTxnDocTypeName,A.FNTxnID,A.FNTxnIDRef,'

	SET @tSql += 'A.FDTxnDocDate,A.FCCrdBalance,''' +  CAST(@nLngID AS VARCHAR(10)) + ''' AS FNLngID, A.FCTxnValue'
	SET @tSql += ' FROM'
		SET @tSql += '('
		 --SET @tSql += 'SELECT CRDHIS.FTTxnDocNoRef,CRDHIS.FTShpCode,CRDHIS.FTShpName,CRDHIS.FTTxnPosCode, CRDHIS.FTPosType,'
		 SET @tSql += 'SELECT DISTINCT CRDHIS.FTTxnDocNoRef,CRDHIS.FTShpCode,CRDHIS.FTShpName,CRDHIS.FTTxnPosCode, CRDHIS.FTPosType,'	--*Em 63-12-29
		 SET @tSql += 'CRDHIS.FTTxnDocType,CRDHIS.FTCrdCode,CRDHIS.FTCrdStaActive,CRDHIS.FDTxnDocDate,'
		 SET @tSql += 'CRDHIS.FDCrdExpireDate,CRDHIS.FCTxnValue,CRDHIS.FTCrdName,CRDHIS.FCCrdBalance,'
		 SET @tSql += 'CRDHIS.FTTxnDocTypeName,'
		 SET @tSql += 'CRDHIS.FNTxnID,CRDHIS.FNTxnIDRef,'
		 SET @tSql += 'ISNULL(TOPUP.FTCreateBy,'''') + ISNULL(VOID.FTCreateBy,'''') + ISNULL(IMP.FTCreateBy,'''') + ISNULL(SHIFT.FTCreateBy,'''') AS FTUsrCreate,'
		 SET @tSql += 'CRDHIS.FTCtyName,CRDHIS.FTCrdHolderID,CRDHIS.FTDptName,CRDHIS.FCTxnCrdAftTrans,ISNULL(CRDHIS.FTBchCode,'''') AS FTBchCode,ISNULL(CRDHIS.FTBchName,'''') AS FTBchName'
		 SET @tSql += ' FROM'
			SET @tSql += '('
			 SET @tSql += 'SELECT CTL.FTCtyName,CRD.FTCrdHolderID,ISNULL(DPL.FTDptName,'''') AS FTDptName,C.FTBchCode,Bch_L.FTBchName,'
			 SET @tSql += 'CASE C.FTTxnDocType' 
				SET @tSql += ' WHEN ''1'' THEN ISNULL(C.FCTxnCrdValue, 0)+ISNULL(C.FCTxnValue, 0)' 
				SET @tSql += ' WHEN ''2'' THEN ISNULL(C.FCTxnCrdValue, 0)-ISNULL(C.FCTxnValue, 0)' 
				SET @tSql += ' WHEN ''3'' THEN ISNULL(C.FCTxnCrdValue, 0)-ISNULL(C.FCTxnValue, 0)' 
				SET @tSql += ' WHEN ''4'' THEN ISNULL(C.FCTxnCrdValue, 0)+ISNULL(C.FCTxnValue, 0)' 
				SET @tSql += ' WHEN ''5'' THEN ISNULL(C.FCTxnCrdValue, 0)-ISNULL(C.FCTxnValue, 0)' 
				SET @tSql += ' ELSE C.FCTxnCrdValue' 
			 SET @tSql += ' END AS FCTxnCrdAftTrans,'
			 SET @tSql += 'ISNULL(C.FTTxnDocNoRef,'''') AS FTTxnDocNoRef,C.FTShpCode,SHPL.FTShpName,C.FTTxnPosCode,'
		     SET @tSql += 'CASE POS.FTPosType'
				SET @tSql += ' WHEN ''1'' THEN ''จุดขาย/ร้านค้า;Pos/Store''' 
				SET @tSql += ' WHEN ''2'' THEN ''จุดเติมเงิน;Topup'''
				SET @tSql += ' WHEN ''3'' THEN ''จุดตรวจสอบมูลค่า;Check Point'''
				SET @tSql += ' ELSE ''ระบบหลังบ้าน;Back Office'''
			 SET @tSql += ' END AS FTPosType,C.FTTxnDocType,C.FTCrdCode,CRD.FTCrdStaActive,C.FNTxnID,C.FNTxnIDRef,'
			 SET @tSql += ' CONVERT(VARCHAR(19),C.FDTxnDocDate,121) AS FDTxnDocDate,ISNULL(CONVERT(VARCHAR(19),CRD.FDCrdExpireDate,121),'''') AS FDCrdExpireDate,'
	         SET @tSql += ' ISNULL(C.FCTxnValue,0) AS FCTxnValue,ISNULL(C.FCTxnCrdValue,0) AS FCTxnCrdValue,ISNULL(CRDL.FTCrdName,'''') AS FTCrdName,ISNULL(BAL.FCCrdValue,0) AS FCCrdBalance,'
			 SET @tSql += ' CASE C.FTTxnDocType' 
				SET @tSql += ' WHEN ''1'' THEN ''เติมเงิน;Topup'''
				SET @tSql += ' WHEN ''2'' THEN ''ยกเลิกเติมเงิน;Cancel Topup'''
				SET @tSql += ' WHEN ''3'' THEN ''ตัดจ่าย/ขาย;Sale'''
				SET @tSql += ' WHEN ''4'' THEN ''ยกเลิกตัดจ่าย;Cancel Sale'''
				SET @tSql += ' WHEN ''5'' THEN ''แลกคืน;Pay Back'''
				SET @tSql += ' WHEN ''6'' THEN ''เบิกบัตร;Card Requisition'''
				SET @tSql += ' WHEN ''7'' THEN ''คืนบัตร;Card Return'''
				SET @tSql += ' WHEN ''8'' THEN ''โอนเงินออก'''
				SET @tSql += ' WHEN ''9'' THEN ''โอนเงินเข้า'''
				SET @tSql += ' WHEN ''10'' THEN ''ล้างบัตร;Clear Card'''
				SET @tSql += ' WHEN ''11'' THEN ''ปรับสถานะ;Card Change Status'''
				SET @tSql += ' WHEN ''12'' THEN ''บัตรใหม่;New Card'''
				SET @tSql += ' ELSE ''ไม่ระบุ;Unknown'''
			 SET @tSql += ' END AS FTTxnDocTypeName'
			 SET @tSql += ' FROM'
				SET @tSql += '('
				 SET @tSql += 'SELECT CT.FTBchCode,FTTxnDocNoRef,FTTxnDocType,FTCrdCode,FDTxnDocDate,FCTxnValue,FCTxnCrdValue,CT.FTShpCode,FTTxnPosCode,FNTxnID,FNTxnIDRef'
				 SET @tSql += ' FROM TFNTCrdHis AS CT WITH(NOLOCK)'
         SET @tSql += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
				 SET @tSql += @tSql1
				
				SET @tSql += ' UNION ALL'
				SET @tSql += ' SELECT CT.FTBchCode,FTTxnDocNoRef,FTTxnDocType,FTCrdCode,FDTxnDocDate,FCTxnValue,FCTxnCrdValue,CT.FTShpCode,'
				SET @tSql2 = 'FTTxnPosCode,FNTxnID,FNTxnIDRef'
				SET @tSql2 += ' FROM TFNTCrdHisBch AS CT WITH(NOLOCK)'
        SET @tSql2 += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
				SET @tSql2 += @tSql1

				SET @tSql2 += ' UNION ALL'
				SET @tSql2 += ' SELECT CT.FTBchCode,FTTxnDocNoRef,FTTxnDocType,FTCrdCode,FDTxnDocDate,FCTxnValue,FCTxnCrdValue,CT.FTShpCode,'
				SET @tSql2 += 'FTTxnPosCode,FNTxnID,FNTxnIDRef'
				SET @tSql2 += ' FROM TFNTCrdTopUp AS CT WITH(NOLOCK)'
        SET @tSql2 += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
				SET @tSql2 += @tSql1
                                                              
				SET @tSql2 += ' UNION ALL'
				SET @tSql2 += ' SELECT CT.FTBchCode,FTTxnDocNoRef,FTTxnDocType,FTCrdCode,FDTxnDocDate,FCTxnValue,FCTxnCrdValue,CT.FTShpCode,'
				SET @tSql2 += 'FTTxnPosCode,FNTxnID,FNTxnIDRef'
				SET @tSql2 += ' FROM TFNTCrdSale AS CT WITH(NOLOCK)'
        SET @tSql2 += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
				SET @tSql2 += @tSql1

				SET @tSql2 += ' ) AS C LEFT OUTER JOIN'
				SET @tSql2 += ' TFNMCard AS CRD WITH(NOLOCK) ON C.FTCrdCode = CRD.FTCrdCode LEFT OUTER JOIN'
				SET @tSql2 += ' TFNMCard_L AS CRDL WITH(NOLOCK) ON CRD.FTCrdCode = CRDL.FTCrdCode AND CRDL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT OUTER JOIN'
				--SET @tSql2 += ' TCNMPos AS POS WITH(NOLOCK) ON C.FTTxnPosCode = POS.FTPosCode LEFT OUTER JOIN'
				SET @tSql2 += ' TCNMPos AS POS WITH(NOLOCK) ON C.FTTxnPosCode = POS.FTPosCode AND C.FTBchCode = POS.FTBchCode LEFT OUTER JOIN'	--*Em 63-12-29
				SET @tSql2 += ' TFNMCardType_L AS CTL WITH(NOLOCK) ON CRD.FTCtyCode = CTL.FTCtyCode AND CTL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT OUTER JOIN'
				SET @tSql2 += ' TCNMUsrDepart_L AS DPL WITH(NOLOCK) ON CRD.FTDptCode = DPL.FTDptCode AND DPL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT OUTER JOIN'
				SET @tSql2 += ' TCNMShop_L AS SHPL WITH(NOLOCK) ON C.FTShpCode = SHPL.FTShpCode AND C.FTBchCode = SHPL.FTBchCode AND SHPL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT OUTER JOIN'
				SET @tSql2 += ' TCNMBranch_L AS Bch_L WITH(NOLOCK) ON C.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
				SET @tSql2 += ' LEFT OUTER JOIN ( SELECT  FTCrdCode ,SUM(CASE WHEN FTCrdTxnCode = ''001'' THEN FCCrdValue END) + SUM(CASE WHEN FTCrdTxnCode = ''002'' THEN FCCrdValue END) - SUM(CASE WHEN FTCrdTxnCode = ''006'' THEN FCCrdValue END)  AS FCCrdValue 	FROM TFNMCardBal GROUP BY FTCrdCode	) AS BAL ON CRD.FTCrdCode = BAL.FTCrdCode '
				SET @tSql2 += ' LEFT OUTER JOIN'
				SET @tSql2 += ' (SELECT CONVERT(VARCHAR(19), FDCrdExpireDate,121) AS FDCrdExpireDate'
				SET @tSql2 += ' FROM TFNMCard WITH(NOLOCK)'
				SET @tSql2 += ' GROUP BY FDCrdExpireDate'
				SET @tSql2 += ' ) AS CEXP ON CONVERT(VARCHAR(10), C.FDTxnDocDate,121) = CONVERT(VARCHAR(10), CEXP.FDCrdExpireDate,121)'
			SET @tSql2 += ' ) AS CRDHIS LEFT OUTER JOIN'
			SET @tSql2 += ' TFNTCrdTopUpHD AS TOPUP WITH(NOLOCK) ON CRDHIS.FTTxnDocNoRef = TOPUP.FTXshDocNo LEFT OUTER JOIN'
			SET @tSql2 += ' TFNTCrdVoidHD AS VOID WITH(NOLOCK) ON CRDHIS.FTTxnDocNoRef = VOID.FTCvhDocNo LEFT OUTER JOIN'
			SET @tSql2 += ' TFNTCrdImpHD AS IMP WITH(NOLOCK) ON CRDHIS.FTTxnDocNoRef = IMP.FTCihDocNo LEFT OUTER JOIN'
			SET @tSql2 += ' TFNTCrdShiftHD AS SHIFT WITH(NOLOCK) ON CRDHIS.FTTxnDocNoRef = SHIFT.FTXshDocNo) AS A '--LEFT OUTER JOIN'
			
			--SET @tSql += ' TCNMUser_L AS USRL WITH(NOLOCK) ON A.FTUsrCreate = USRL.FTUsrCode'
			SET @tSql2 += ' WHERE 1=1 '
		--PRINT @tSql
		--PRINT @tSql2
			--SET @tSql += @tSql1

			--IF (@tBchF <> '' AND @tBchT <> '')
			--BEGIN
			--	SET @tSql +=' AND FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			--END

			--IF (@tCrdF <> '' AND @tCrdT <> '')
			--BEGIN
			--	SET @tSql +=' AND FTCrdCode BETWEEN ''' + @tCrdF + ''' AND ''' + @tCrdT + ''''
			--END

			--IF (@tDocDateF <> '' AND @tDocDateT <> '')
			--BEGIN
			--	SET @tSql +=' AND CONVERT(VARCHAR(10),FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			--END
	SET @tSqlIns1 = ''
			IF @tUserIdF <> '' AND @tUserIdT <> ''
			BEGIN
				SET @tSqlIns1 += ' AND FTCrdHolderID BETWEEN ''' + @tUserIdF + ''' AND ''' + @tUserIdT +''''
			END

			IF @tCrdActF <> '' AND @tCrdActT <> ''
			BEGIN
				SET  @tSqlIns1 += ' AND FTCrdStaActive BETWEEN '''+ @tCrdActF +''' AND '''+ @tCrdActT +''''
			END  

		IF @pnFilterType = '1'
		BEGIN
			IF (@ptBchF <> '' AND @ptBchT <> '')
			BEGIN
				SET @tSqlIns1 +=' AND CT.FTBchCode BETWEEN ''' + @ptBchF + ''' AND ''' + @ptBchT + ''''
			END

			IF (@ptMerF <> '' AND @ptMerT <> '')
			BEGIN
				SET @tSqlIns1 +=' AND SHP.FTMerCode BETWEEN ''' + @ptMerF + ''' AND ''' + @ptMerT + ''''
			END

			IF (@ptShpF <> '' AND @ptShpT <> '')
			BEGIN
				SET @tSqlIns1 +=' AND CT.FTShpCode BETWEEN ''' + @ptShpF + ''' AND ''' + @ptShpT + ''''
			END

			IF (@ptPosF <> '' AND @ptPosT <> '')
			BEGIN
				SET @tSqlIns1 +=' AND CT.FTTxnPosCode BETWEEN ''' + @ptPosF + ''' AND ''' + @ptPosT + ''''
			END

		END

		IF @pnFilterType = '2'
		BEGIN
			IF (@ptBchL <> '' )
			BEGIN
				SET @tSqlIns1 +=' AND CT.FTBchCode IN (' + @ptBchL + ')'
			END

			IF (@ptMerL <> '')
			BEGIN
				SET @tSqlIns1 += ' AND SHP.FTMerCode IN (' + @ptMerL + ')'
			END	

			IF (@ptShpL <> '')
			BEGIN
				SET @tSqlIns1 += ' AND CT.FTShpCode IN (' + @ptShpL + ')'
			END	

			IF (@ptPosL <> '')
			BEGIN
				SET @tSqlIns1 += ' AND CT.FTTxnPosCode IN (' + @ptPosL + ')'
			END	
		
		END


	--SET @tSql += ' IN TO TFCTRptCrdTmp1'
	SET @tSqlIns = 'INSERT INTO TFCTRptCrdTmp ('
	SET @tSqlIns +='FTUsrSession,FTComName,FTRptName,'
	SET @tSqlIns +='FTTxndocType,FTCrdCode,FTCrdName,FTCtyName,FTCrdHolderID,FTShpCode,FTShpName,FTCrdStaActive,FTDptName,FCTxnCrdAftTrans,'
	SET @tSqlIns += 'FTBchCode,FTBchName,'
	SET @tSqlIns +='FTTxnPosCode,FTPosType,FTTxnDocRefNo,FTTxnDocNoRef,FTTxnDocTypeName,FNTxnID,#TFCTRptCrdTemp.FNTxnIDRef,'
	SET @tSqlIns +='FTDocCreateBy,'
	SET @tSqlIns +='FDTxnDocDate,FCCrdBalance,FNLngID,FCTxnValue'
	SET @tSqlIns +=')'
	--SET @tSqlIns +=' SELECT '
	SET @tSqlIns +=' SELECT DISTINCT ' --*Em 63-12-29
	SET @tSqlIns +=' FTUsrSession,FTComName,FTRptName,'
	SET @tSqlIns +=' FTTxndocType,FTCrdCode,FTCrdName,FTCtyName,FTCrdHolderID,FTShpCode,FTShpName,FTCrdStaActive,FTDptName,FCTxnCrdAftTrans,'
	SET @tSqlIns += 'FTBchCode,FTBchName,'
	SET @tSqlIns +=' FTTxnPosCode,FTPosType,FTTxnDocRefNo,FTTxnDocNoRef,FTTxnDocTypeName,FNTxnID,#TFCTRptCrdTemp.FNTxnIDRef,'
	SET @tSqlIns += ' CASE FTTxnDocType' 
		SET @tSqlIns += ' WHEN ''3'' THEN FTTxnPosCode' 
		SET @tSqlIns += ' WHEN ''4'' THEN FTTxnPosCode' 
		SET @tSqlIns += ' WHEN ''5'' THEN FTTxnPosCode' 
		SET @tSqlIns += ' ELSE USRL.FTUsrName'
		SET @tSqlIns += ' END AS FTDocCreateBy,'

	SET @tSqlIns +='FDTxnDocDate,FCCrdBalance,#TFCTRptCrdTemp.FNLngID, FCTxnValue'
	SET @tSqlIns +=' FROM #TFCTRptCrdTemp LEFT JOIN'
	SET @tSqlIns += ' TCNMUser_L AS USRL WITH(NOLOCK) ON #TFCTRptCrdTemp.FTUsrCreate = USRL.FTUsrCode'
	SET @tSqlIns +=' LEFT JOIN ('
	SET @tSqlIns +=' SELECT R1.FNTxnIDRef, R2.FTTxnDocNoRef AS FTDocRef FROM ('
	SET @tSqlIns +=' SELECT FNTxnIDRef FROM TFNTCrdHis CT LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode WHERE ISNULL(FNTxnIDRef,'''') <> '''''
	--SET @tSqlIns += @tSql2
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FNTxnIDRef FROM TFNTCrdHisBch CT LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode WHERE ISNULL(FNTxnIDRef,'''') <> '''''
   --SET @tSqlIns += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
	  SET @tSqlIns += @tSqlIns1

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FNTxnIDRef FROM TFNTCrdTopUp CT LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode WHERE ISNULL(FNTxnIDRef,'''' ) <> '''''
   --SET @tSqlIns += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
	SET @tSqlIns += @tSqlIns1
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FNTxnIDRef FROM TFNTCrdSale CT LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode WHERE ISNULL(FNTxnIDRef,'''') <> '''''
   --SET @tSqlIns += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
   SET @tSqlIns += @tSqlIns1
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=') R1'
	SET @tSqlIns +=' INNER JOIN ('
	SET @tSqlIns +=' SELECT FTTxnDocNoRef,FNTxnID FROM TFNTCrdHis CT'
   SET @tSqlIns += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
	SET @tSqlIns +=' WHERE 1=1'
  SET @tSqlIns += @tSqlIns1
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FTTxnDocNoRef,FNTxnID FROM TFNTCrdHisBch CT'
   SET @tSqlIns += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
	--SET @tSqlIns +=' WHERE 1=1'
	SET @tSqlIns += @tSqlIns1
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FTTxnDocNoRef,FNTxnID FROM TFNTCrdTopUp CT'
   SET @tSqlIns += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
	SET @tSqlIns +=' WHERE 1=1'
	SET @tSqlIns += @tSqlIns1
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FTTxnDocNoRef,FNTxnID FROM TFNTCrdSale CT'
  SET @tSqlIns += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
	SET @tSqlIns +=' WHERE 1=1'
	SET @tSqlIns += @tSqlIns1
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10),FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=')R2 ON R1.FNTxnIDRef = R2.FNTxnID) REF ON REF.FNTxnIDRef = #TFCTRptCrdTemp.FNTxnIDRef'
	--PRINT @tSqlIns
	--SELECT @tSql+@tSql2
	EXECUTE(@tSql+@tSql2)

	--SELECT @tSqlIns
	EXECUTE(@tSqlIns)
	
	--DROP TABLE #TFCTRptCrdTemp
--	--SELECT * FROM #TFCTRptCrdTmp
	RETURN SELECT DISTINCT * FROM TFCTRptCrdTmp WHERE FTComName = ''+ @nComName + '' AND FTRptName = ''+ @tRptName +'' AND FTUsrSession = '' + @ptUsrSession + ''
--	----EXECUTE @tSqlIns
	
END TRY

BEGIN CATCH 
 SET @FNResult= -1
END CATCH
GO


/****** From DB:FitAuto Date 15/09/2022 By:Ice PHP ******/

-- EXEC sp_rename 'SP_CNoBrowseProduct', 'SP_CNoBrowseProduct_Old'

/****** Object:  StoredProcedure [dbo].[SP_CNoBrowseProduct]    Script Date: 19/9/2565 1:37:45 ******/
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CNoBrowseProduct]') AND type in (N'P', N'PC'))
-- BEGIN
-- EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_CNoBrowseProduct] AS' 
-- END
-- GO
-- ALTER PROCEDURE [dbo].[SP_CNoBrowseProduct]
-- 	--ผู้ใช้และสิท
-- 	@ptUsrCode VARCHAR(10),
-- 	@ptUsrLevel VARCHAR(10),
-- 	@ptSesAgnCode VARCHAR(10),
-- 	@ptSesBchCodeMulti VARCHAR(100),
-- 	@ptSesShopCodeMulti VARCHAR(100),
-- 	@ptSesMerCode VARCHAR(20),
-- 	@ptWahCode VARCHAR(5),

-- 	--กำหนดการแสดงข้อมูล
-- 	@pnRow INT,
-- 	@pnPage INT,
-- 	@pnMaxTopPage INT,
-- 	--ค้นหาตามประเภท
-- 	@ptFilterBy VARCHAR(80),
-- 	@ptSearch VARCHAR(1000),

-- 	--OPTION PDT
-- 	@ptWhere VARCHAR(8000),
-- 	@ptNotInPdtType VARCHAR(8000),
-- 	@ptPdtCodeIgnorParam VARCHAR(30),
-- 	@ptPDTMoveon VARCHAR(1),
-- 	@ptPlcCodeConParam VARCHAR(10),
-- 	@ptDISTYPE VARCHAR(1),
-- 	@ptPagename VARCHAR(10),
-- 	@ptNotinItemString VARCHAR(8000),
-- 	@ptSqlCode VARCHAR(20),
	
-- 	--Price And Cost
-- 	@ptPriceType VARCHAR(30),
-- 	@ptPplCode VARCHAR(30),
-- 	@ptPdtSpcCtl VARCHAR(100),
	
-- 	@pnLngID INT
-- AS
-- BEGIN

--     DECLARE @tSQL VARCHAR(MAX)
--     DECLARE @tSQLMaster VARCHAR(MAX)
--     DECLARE @tUsrCode VARCHAR(10)
--     DECLARE @tUsrLevel VARCHAR(10)
--     DECLARE @tSesAgnCode VARCHAR(10)
--     DECLARE @tSesBchCodeMulti VARCHAR(100)
--     DECLARE @tSesShopCodeMulti VARCHAR(100)
--     DECLARE @tSesMerCode VARCHAR(20)
--     DECLARE @tWahCode VARCHAR(5)
--     DECLARE @nRow INT
--     DECLARE @nPage INT
--     DECLARE @nMaxTopPage INT
--     DECLARE @tFilterBy VARCHAR(80)
--     DECLARE @tSearch VARCHAR(80)
--     DECLARE	@tWhere VARCHAR(8000)
--     DECLARE	@tNotInPdtType VARCHAR(8000)
--     DECLARE	@tPdtCodeIgnorParam VARCHAR(30)
--     DECLARE	@tPDTMoveon VARCHAR(1)
--     DECLARE	@tPlcCodeConParam VARCHAR(10)
--     DECLARE	@tDISTYPE VARCHAR(1)
--     DECLARE	@tPagename VARCHAR(10)
--     DECLARE	@tNotinItemString VARCHAR(8000)
--     DECLARE	@tSqlCode VARCHAR(10)
--     DECLARE	@tPriceType VARCHAR(10)
--     DECLARE	@tPplCode VARCHAR(10)
-- 	DECLARE	@tPdtSpcCtl VARCHAR(100)

--     DECLARE @nLngID INT
--     SET @tUsrCode = @ptUsrCode
--     SET @tUsrLevel = @ptUsrLevel
--     SET @tSesAgnCode = @ptSesAgnCode
--     SET @tSesBchCodeMulti = @ptSesBchCodeMulti
--     SET @tSesShopCodeMulti = @ptSesShopCodeMulti
--     SET @tSesMerCode = @ptSesMerCode
--     SET @tWahCode = @ptWahCode

--     SET @nRow = @pnRow
--     SET @nPage = @pnPage
--     SET @nMaxTopPage = @pnMaxTopPage

--     SET @tFilterBy = @ptFilterBy
--     SET @tSearch = @ptSearch

--     SET @tWhere = @ptWhere
--     SET @tNotInPdtType = @ptNotInPdtType
--     SET @tPdtCodeIgnorParam = @ptPdtCodeIgnorParam
--     SET @tPDTMoveon = @ptPDTMoveon
--     SET @tPlcCodeConParam = @ptPlcCodeConParam
--     SET @tDISTYPE = @ptDISTYPE
--     SET @tPagename = @ptPagename
--     SET @tNotinItemString = @ptNotinItemString
--     SET @tSqlCode = @ptSqlCode

--     SET @tPriceType = @ptPriceType
--     SET @tPplCode = @ptPplCode
-- 	SET @tPdtSpcCtl = @ptPdtSpcCtl
--     SET @nLngID = @pnLngID

--     SET @tSQLMaster = ' SELECT Base.*, '

--     IF @nPage = 1 BEGIN
--             SET @tSQLMaster += ' COUNT(*) OVER() AS rtCountData '
--     END ELSE BEGIN
--             SET @tSQLMaster += ' 0 AS rtCountData '
--     END

--     SET @tSQLMaster += ' FROM ( '
--     SET @tSQLMaster += ' SELECT DISTINCT'

--     IF @nMaxTopPage > 0 BEGIN
--         SET @tSQLMaster += ' TOP ' + CAST(@nMaxTopPage  AS VARCHAR(10)) + ' '
--     END

--         --SET @tSQLMaster += ' ROW_NUMBER () OVER (ORDER BY Products.FDCreateOn DESC) AS FNRowID,'
--     SET @tSQLMaster += ' Products.FTPdtForSystem, '
--     SET @tSQLMaster += ' Products.FTPdtCode,PDT_IMG.FTImgObj,'

--     IF @ptUsrLevel != 'HQ'  BEGIN
--             SET @tSQLMaster += ' PDLSPC.FTAgnCode,PDLSPC.FTBchCode,PDLSPC.FTShpCode,PDLSPC.FTMerCode, '
--     END ELSE BEGIN
--             SET @tSQLMaster += ' '''' AS FTAgnCode,'''' AS FTBchCode,'''' AS  FTShpCode,'''' AS FTMerCode, '
--     END 

--     SET @tSQLMaster += ' Products.FTPdtStaLot,'
--     SET @tSQLMaster += ' Products.FTPtyCode,'
-- 	SET @tSQLMaster += ' Products.FTPbnCode,'
--     SET @tSQLMaster += ' Products.FTPgpChain,'
--     SET @tSQLMaster += ' Products.FTPdtStaVatBuy,Products.FTPdtStaVat,Products.FTVatCode,Products.FTPdtStaActive, Products.FTPdtSetOrSN, Products.FTPdtStaAlwDis,Products.FTPdtType,Products.FCPdtCostStd,'
--     SET @tSQLMaster += ' PDTSPL.FTSplCode,PDTSPL.FTUsrCode AS FTBuyer,PBAR.FTBarCode,PPCZ.FTPunCode,PPCZ.FCPdtUnitFact,'
--     SET @tSQLMaster += ' Products.FTCreateBy,'
--     SET @tSQLMaster += ' Products.FDCreateOn'
--     SET @tSQLMaster += ' FROM'
--     SET @tSQLMaster += ' TCNMPdt Products WITH (NOLOCK)'

--     IF @tPagename = 'Promotion' BEGIN------//-----------------เงื่อนไขพิเศษ ตามหน้า-------------
-- 				SET @tSQLMaster += ''
--         --SET @tSQLMaster += ' LEFT JOIN TCNMPdtLot PDTLOT WITH (NOLOCK) ON Products.FTPdtCode = PDTLOT.FTPdtCode '
--     END
    
--     IF @ptUsrLevel != 'HQ'  BEGIN
--         SET @tSQLMaster += ' LEFT JOIN TCNMPdtSpcBch PDLSPC WITH (NOLOCK) ON Products.FTPdtCode = PDLSPC.FTPdtCode'
--     END

--     SET @tSQLMaster += ' INNER JOIN TCNMPdtPackSize PPCZ WITH (NOLOCK) ON Products.FTPdtCode = PPCZ.FTPdtCode LEFT JOIN TCNMPdtBar PBAR WITH (NOLOCK)  ON Products.FTPdtCode = PBAR.FTPdtCode  AND PPCZ.FTPunCode = PBAR.FTPunCode' --//หาบาร์โค้ด
--     SET @tSQLMaster += ' LEFT JOIN TCNMPdtSpl PDTSPL WITH (NOLOCK) ON PBAR.FTPdtCode = PDTSPL.FTPdtCode AND PBAR.FTBarCode = PDTSPL.FTBarCode '--//ผู้จำหน่าย
--     SET @tSQLMaster += ' LEFT JOIN TCNMImgPdt AS PDT_IMG WITH(NOLOCK) ON Products.FTPdtCode = PDT_IMG.FTImgRefID AND PDT_IMG.FTImgTable = ''TCNMPdt'' AND PDT_IMG.FNImgSeq = 1 '					
    
--     ---//--------การจอยตาราง------///
--     IF @tFilterBy = 'FTPdtCode' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' '--//รหัสสินค้า
--     END

--     IF @tFilterBy = 'TCNTPdtStkBal' BEGIN
--         SET @tSQLMaster += ' LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON Products.FTPdtCode = STK.FTPdtCode AND STK.FTBchCode IN ('+@tSesBchCodeMulti+') AND STK.FTWahCode = '''+@tWahCode+''' '
--     END		

--     --IF @tFilterBy = 'FTPdtName' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' LEFT JOIN TCNMPdt_L PDTL WITH (NOLOCK)       ON Products.FTPdtCode = PDTL.FTPdtCode  AND PDTL.FNLngID   = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '--//หาชื่อสินค้า
--     --END

--     /*IF @tFilterBy = 'PDTANDBarcode' OR @tFilterBy = 'FTPlcCode' OR @tSqlCode != '' BEGIN
--         SET @tSQLMaster += ' LEFT JOIN TCNMPdtPackSize PPCZ WITH (NOLOCK) ON PDT.FTPdtCode = PPCZ.FTPdtCode LEFT JOIN TCNMPdtBar PBAR WITH (NOLOCK)      ON PDT.FTPdtCode = PBAR.FTPdtCode  AND PPCZ.FTPunCode = PBAR.FTPunCode' --//หาบาร์โค้ด
--     END

--     IF @tFilterBy = 'FTBarCode' BEGIN
--         SET @tSQLMaster += ' LEFT JOIN TCNMPdtPackSize PPCZ WITH (NOLOCK) ON PDT.FTPdtCode = PPCZ.FTPdtCode LEFT JOIN TCNMPdtBar PBAR WITH (NOLOCK)      ON PDT.FTPdtCode = PBAR.FTPdtCode  AND PPCZ.FTPunCode = PBAR.FTPunCode' --//หาบาร์โค้ด
--     END*/

--     IF @tFilterBy = 'FTPunCode' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' LEFT JOIN TCNMPdtUnit_L PUNL WITH (NOLOCK)   ON PPCZ.FTPunCode = PUNL.FTPunCode AND PUNL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' ' --//หาหน่วย
--     END								

--     IF @tFilterBy = 'FTPgpChain' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' LEFT JOIN TCNMPdtGrp_L PGL WITH (NOLOCK)     ON PGL.FTPgpChain = Products.FTPgpChain AND PGL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '--//หากลุ่มสินค้า
--     END							

--     IF @tFilterBy = 'FTPtyCode' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' LEFT JOIN TCNMPdtType_L PTL WITH (NOLOCK)    ON Products.FTPtyCode = PTL.FTPtyCode   AND PTL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '--//หาประเภทสินค้า
--     END	

--     IF @tFilterBy = 'FTBuyer' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' '--//ผู้จัดซื้อ
--     END


-- 	IF @tFilterBy = 'FTPbnCode' AND @tSearch <> '' BEGIN
-- 		SET @tSQLMaster += ' LEFT JOIN TCNMPdtBrand_L PBNL WITH (NOLOCK)    ON Products.FTPbnCode = PBNL.FTPbnCode   AND PBNL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '--//หาประเภทสินค้า
-- 	END	

--     /* IF @tSqlCode != '' BEGIN------//----------------ผู้จำหน่าย-------------------
--         SET @tSQLMaster += ' LEFT JOIN TCNMPdtSpl PDTSPL WITH (NOLOCK) ON PBAR.FTPdtCode = PDTSPL.FTPdtCode AND PBAR.FTBarCode = PDTSPL.FTBarCode '--//ผู้จำหน่าย
--     END*/

--     ---//--------การจอยตาราง------///

--     SET @tSQLMaster += ' LEFT JOIN TCNMPdtCategory CATINFO WITH (NOLOCK) ON Products.FTPdtCode = CATINFO.FTPdtCode '

-- 	IF @tPdtSpcCtl <> '' BEGIN
-- 		SET @tSQLMaster += ' LEFT JOIN TCNSDocCtl_L DCT WITH(NOLOCK) ON DCT.FTDctTable = '''+ @tPdtSpcCtl +''' AND	DCT.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
-- 		SET @tSQLMaster += ' LEFT JOIN TCNMPdtSpcCtl PSC WITH(NOLOCK) ON Products.FTPdtCode = PSC.FTPdtCode AND DCT.FTDctCode = PSC.FTDctCode '
-- 	END

--     SET @tSQLMaster += ' WHERE ISNULL(Products.FTPdtCode,'''') != '''' '

-- 	IF @tPdtSpcCtl <> '' BEGIN
-- 		IF @tUsrLevel = 'HQ' BEGIN
-- 			SET @tSQLMaster += ' AND (PSC.FTPscAlwCmp = ''1'' OR PSC.FTPdtCode IS NULL OR (PSC.FTPscAlwOwner = ''1'' AND Products.FTCreateBy = '''+@tUsrCode+''')) '
-- 		END
-- 		IF @tUsrLevel = 'AD' BEGIN
-- 			SET @tSQLMaster += ' AND (PSC.FTPscAlwAD = ''1'' OR PSC.FTPdtCode IS NULL OR (PSC.FTPscAlwOwner = ''1'' AND Products.FTCreateBy = '''+@tUsrCode+''')) '
-- 		END
-- 		IF @tUsrLevel = 'BCH' BEGIN
-- 			SET @tSQLMaster += ' AND (PSC.FTPscAlwBch = ''1'' OR PSC.FTPdtCode IS NULL OR (PSC.FTPscAlwOwner = ''1'' AND Products.FTCreateBy = '''+@tUsrCode+''')) '
-- 		END
-- 		IF @tUsrLevel = 'MER' BEGIN
-- 			SET @tSQLMaster += ' AND (PSC.FTPscAlwMer = ''1'' OR PSC.FTPdtCode IS NULL OR (PSC.FTPscAlwOwner = ''1'' AND Products.FTCreateBy = '''+@tUsrCode+''')) '
-- 		END
-- 		IF @tUsrLevel = 'SHP' BEGIN
-- 			SET @tSQLMaster += ' AND (PSC.FTPscAlwShp = ''1'' OR PSC.FTPdtCode IS NULL OR (PSC.FTPscAlwOwner = ''1'' AND Products.FTCreateBy = '''+@tUsrCode+''')) '
-- 		END
-- 	END

--     ---//--------การค้นหา------///
--     IF @tFilterBy = 'FTPdtCode' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' AND ( Products.FTPdtCode  COLLATE THAI_BIN    LIKE ''%' + @tSearch + '%'' )'--//รหัสสินค้า
--     END

--     IF @tFilterBy = 'FTPdtName' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' AND ( UPPER(PDTL.FTPdtName)  COLLATE THAI_BIN    LIKE UPPER(''%' + @tSearch + '%'') ) '--//หาชื่อสินค้า
--     END

--     IF @tFilterBy = 'FTBarCode' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' AND ( PBAR.FTBarCode  COLLATE THAI_BIN    LIKE ''%' + @tSearch + '%'' )' --//หาบาร์โค้ด
--     END

--     IF @tFilterBy = 'PDTANDBarcode' AND @tSearch <> '' BEGIN
-- 				SET @tSQLMaster += ''
--         --SET @tSQLMaster += ' AND ( PBAR.FTPdtCode =''' + @tSearch + '''  OR  PBAR.FTBarCode =''' + @tSearch + ''' )' --//หาบาร์โค้ด
--     END

--     IF @tFilterBy = 'FTPunCode' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' AND ( PUNL.FTPunName  COLLATE THAI_BIN    LIKE ''%' + @tSearch + '%'' OR PUNL.FTPunCode COLLATE THAI_BIN LIKE ''%' + @tSearch + '%'' )' --//หาหน่วย
--     END								

--     IF @tFilterBy = 'FTPgpChain' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' AND ( PGL.FTPgpName   COLLATE THAI_BIN    LIKE ''%' + @tSearch + '%'' OR PGL.FTPgpChainName COLLATE THAI_BIN LIKE ''%' + @tSearch + '%'' ) '--//หากลุ่มสินค้า
--     END							

--     IF @tFilterBy = 'FTPtyCode' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' AND ( PTL.FTPtyName   COLLATE THAI_BIN    LIKE ''%' + @tSearch + '%'' ) '--//หาประเภทสินค้า
--     END	

--     IF @tFilterBy = 'FTBuyer' AND @tSearch <> '' BEGIN
--         SET @tSQLMaster += ' '--//ผู้จัดซื้อ
--     END

-- 	IF @tFilterBy = 'FTPbnCode' AND @tSearch <> '' BEGIN
-- 			SET @tSQLMaster += ' AND ( PBNL.FTPbnCode = ''' + @tSearch + ''' OR PBNL.FTPbnName COLLATE THAI_BIN LIKE ''%' + @tSearch + '%'' )' --//ยี่ห้อ
-- 	END	

--     IF @tPagename = 'Promotion' BEGIN------//-----------------เงื่อนไขพิเศษ ตามหน้า-------------
-- 				SET @tSQLMaster += ''
--         --SET @tSQLMaster += ' AND (Products.FTPdtStaLot = ''2'' OR Products.FTPdtStaLot = ''1'' AND Products.FTPdtStaLot = ''1'' AND ISNULL(PDTLOT.FTLotNo,'''') <> '''' ) '
--     END
--     ---//--------การค้นหา------///

--     ---//--------การมองเห็นสินค้าตามผู้ใช้------///
--     IF @tUsrLevel != 'HQ' BEGIN
--         --//---------------------- การมองเห็นเฉพาะสินค้าตามระดับผู้ใช้--------------------------//
--         SET @tSQLMaster += ' AND ( ('
--         SET @tSQLMaster += ' ISNULL(PDLSPC.FTAgnCode,'''') = '''+@tSesAgnCode+''' '

--                     IF @tSesMerCode != '' AND @tSesMerCode != '' BEGIN 
--                             SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''+@tSesMerCode+''' '
--                     END

--                     IF (SELECT ISNULL(FTBchCode,'') FROM TCNTUsrGroup WHERE FTUsrCode = @tUsrCode )<>'' BEGIN
--                             IF (@tSesBchCodeMulti <> '') BEGIN
--                                 SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') IN ('+@tSesBchCodeMulti+') '
--                             END ELSE BEGIN
--                                 SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') = '''' '
--                             END
--                     END
                                
--                     IF @tSesShopCodeMulti != '' BEGIN 
--                             SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') IN ('+@tSesShopCodeMulti+') '
--                     END

--         SET @tSQLMaster += ' )'
--         -- |-------------------------------------------------------------------------------------------| 

--         --//---------------------- การมองเห็นสินค้าระดับสาขา (สำหรับผู้ใช้ระดับร้านค้า)--------------------------//
--     IF @tSesShopCodeMulti != '' BEGIN 
--         SET @tSQLMaster += ' OR ('--//กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่อยู่ใน Bch แต่ไม่ผูก Shp
--         SET @tSQLMaster += ' ISNULL(PDLSPC.FTAgnCode,'''') = '''+@tSesAgnCode+''' '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''+@tSesMerCode+''' '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') IN ('+@tSesBchCodeMulti+') '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
--         SET @tSQLMaster += ' )'

--         SET @tSQLMaster += ' OR (' --//กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่อยู่ใน Bch แต่ไม่ผูก Shp และไม่ผูก Mer
--         SET @tSQLMaster += ' ISNULL(PDLSPC.FTAgnCode,'''') = '''+@tSesAgnCode+''' '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''' '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') IN ('+@tSesBchCodeMulti+') '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
--         SET @tSQLMaster += ' )'

--         SET @tSQLMaster += ' OR (' --//กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่ไม่ผูก Bch และ ไม่ผูก Shp
--         SET @tSQLMaster += ' ISNULL(PDLSPC.FTAgnCode,'''') = '''+@tSesAgnCode+''' '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''+@tSesMerCode+''' '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') = '''' '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
--         SET @tSQLMaster += ' )'

--         SET @tSQLMaster += ' OR (' --//กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่ไม่ผูก Mer และสินค้าผูก Bch / Shp
--         SET @tSQLMaster += ' ISNULL(PDLSPC.FTAgnCode,'''') = '''+@tSesAgnCode+''' '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''' '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') IN ('+@tSesBchCodeMulti+') '
--         SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') IN ('+@tSesShopCodeMulti+') '
--         SET @tSQLMaster += ' )'
--     END
--     -- |-------------------------------------------------------------------------------------------| 

--     -- //---------------------- การมองเห็นสินค้าระดับส่วนกลางหรือสินค้าที่ไม่ได้ผูกกับอะไรเลย--------------------------//
--     SET @tSQLMaster += ' OR ('

--     SET @tSQLMaster += ' ISNULL(PDLSPC.FTAgnCode,'''') = '''+@tSesAgnCode+''' '

--     IF @tSesMerCode != '' AND @tSesMerCode != '' BEGIN --//กรณีผู้ใช้ผูก Mer จะต้องเห็นสินค้าที่ไม่ได้ผูก Mer ด้วย
--             SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''' '
--     END

--     IF (SELECT ISNULL(FTBchCode,'') FROM TCNTUsrGroup WHERE FTUsrCode= @tUsrCode)<>'' BEGIN --//กรณีผู้ใช้ผูก Bch จะต้องเห็นสินค้าที่ไม่ได้ผูก Bch ด้วย
--             SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''')  = '''' '
--     END

--     IF @tSesShopCodeMulti != '' BEGIN 
--             SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
--     END

--     SET @tSQLMaster += ' )'
--     -- |-------------------------------------------------------------------------------------------| 

--     -- //---------------------- การมองเห็นสินค้าระดับส่วนกลางหรือสินค้าที่ไม่ได้ผูกกับอะไรเลย--------------------------//
--     SET @tSQLMaster += ' OR ('
--     SET @tSQLMaster += ' ISNULL(PDLSPC.FTAgnCode,'''') = '''' '
--     SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''' '
--     SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') = '''' '
--     SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
--     SET @tSQLMaster += ' ))'
--     -- |-------------------------------------------------------------------------------------------| 

--     END
--     ---//--------การมองเห็นสินค้าตามผู้ใช้------///


--     -----//----Option-----//------

--     IF @tWhere != '' BEGIN
--         SET @tSQLMaster += @tWhere
--     END
    
--     IF @tNotInPdtType != '' BEGIN-----//------------- ไม่แสดงสินค้าตาม ประเภทสินค้า -------------------
--         SET @tSQLMaster += ' AND ISNULL(Products.FTPDtCode,'''') NOT IN ('+@tNotInPdtType+') '
--     END

--     IF @tPdtCodeIgnorParam != '' BEGIN----//-------------สินค้าที่ไม่ใช่ตัวข้อมูลหลักในการจัดสินค้าชุด-------------------
--         SET @tSQLMaster += ' AND ISNULL(Products.FTPDtCode,'''') != '''+@tPdtCodeIgnorParam+''' '
--     END

--     IF @tPDTMoveon != '' BEGIN------//---------สินค้าเคลื่อนไหว---------
--         SET @tSQLMaster += ' AND  Products.FTPdtStaActive = '''+@tPDTMoveon+''' '
--     END

--     IF @tPlcCodeConParam != '' AND @tFilterBy = 'FTPlcCode' BEGIN---/ที่เก็บ-  //กรณีที่เข้าไปหา plc code เเล้วไม่เจอ PDT เลย ต้องให้มันค้นหา โดย KEYWORD : EMPTY
--             IF  @tPlcCodeConParam != 'EMPTY' BEGIN
--                     SET @tSQLMaster += ' AND  PBAR.FTBarCode = '''+@tPlcCodeConParam+''' '
--             END
--             ELSE BEGIN
--                     SET @tSQLMaster += ' AND  PPCZ.FTPdtCode = ''EMPTY'' AND PPCZ.FTPunCode = ''EMPTY'' '
--             END
--     END

--     IF @ptDISTYPE != '' BEGIN------//----------------อนุญาตลด----------------
--         SET @tSQLMaster += ' AND  Products.FTPdtStaAlwDis = '''+@ptDISTYPE+''' '
--     END

--     IF @tPagename = 'PI' BEGIN------//-----------------เงื่อนไขพิเศษ ตามหน้า-------------
--         SET @tSQLMaster += ' AND  Products.FTPdtSetOrSN != ''4'' '
--     END

--     IF @tNotinItemString  != '' BEGIN-------//-----------------ไม่เอาสินค้าอะไรบ้าง NOT IN-----------
--         SET @tSQLMaster += @tNotinItemString
--     END

--     IF @tSqlCode != '' BEGIN------//----------------ผู้จำหน่าย-------------------
--         SET @tSQLMaster += ' AND  ( PDTSPL.FTSplCode = '''+@tSqlCode+'''  OR ISNULL(PDTSPL.FTSplCode,'''') = '''' ) '
--     END
--     -----//----Option-----//------
        


--     SET @tSQLMaster += ' ) Base '

--     IF @nRow != ''  BEGIN------------เงื่อนไขพิเศษ แบ่งหน้า----
--         SET @tSQLMaster += ' ORDER BY Base.FDCreateOn DESC '
--         SET @tSQLMaster += ' OFFSET '+CAST(((@nPage-1)*@nRow) AS VARCHAR(10))+' ROWS FETCH NEXT '+CAST(@nRow AS VARCHAR(10))+' ROWS ONLY'
--     END
--     ----//----------------------Data Master And Filter-------------//			

--     ----//----------------------Query Builder-------------//

--     SET @tSQL = '  SELECT PDT.rtCountData ,PDT.FTAgnCode,PDT.FTBchCode AS FTPdtSpcBch,PDT.FTShpCode,PDT.FTMerCode,PDT.FTImgObj,';
--     SET @tSQL += ' PDT.FTPdtCode,PDT_L.FTPdtName,PDT.FTPdtForSystem,PDT.FTPdtStaVatBuy,PDT.FTPdtStaVat,PDT.FTVatCode,ISNULL(VAT.FCVatRate, 0) AS FCVatRate, '
--     SET @tSQL += ' PDT.FTPdtStaActive,PDT.FTPdtSetOrSN,PDT.FTPgpChain,PDT.FTPtyCode,ISNULL(PDT_AGE.FCPdtCookTime,0) AS FCPdtCookTime,ISNULL(PDT_AGE.FCPdtCookHeat,0) AS FCPdtCookHeat, '
--     SET @tSQL += ' PDT.FTPunCode,PDT_UNL.FTPunName,PDT.FCPdtUnitFact, PDT.FTSplCode,PDT.FTBuyer,PDT.FTBarCode,PDT.FTPdtStaAlwDis,PDT.FTPdtType,PDT.FCPdtCostStd,PDT.FTPdtStaLot'

--     IF @tPriceType = 'Pricesell' OR @tPriceType = '' BEGIN------///ถ้าเป็นราคาขาย---
--         SET @tSQL += '  ,0 AS FCPgdPriceNet,VPA.FCPgdPriceRet AS FCPgdPriceRet,0 AS FCPgdPriceWhs'
--     END

--     IF @tPriceType = 'Price4Cst' BEGIN------// //ถ้าเป็นราคาทุน-----
--         SET @tSQL += '  ,0 AS FCPgdPriceNet,0 AS FCPgdPriceWhs,'
--         SET @tSQL += '  CASE'
--         SET @tSQL += '  WHEN ISNULL(PCUS.FCPgdPriceRet,0) <> 0 THEN PCUS.FCPgdPriceRet'
--         SET @tSQL += '  WHEN ISNULL(PBCH.FCPgdPriceRet,0) <> 0 THEN PBCH.FCPgdPriceRet'
--         --SET @tSQL += '  WHEN ISNULL(PEMPTY.FCPgdPriceRet,0) <> 0 THEN PEMPTY.FCPgdPriceRet'
--         SET @tSQL += '  ELSE 0'
--         SET @tSQL += '  END AS FCPgdPriceRet'
--     END

--     IF @tPriceType = 'Cost' BEGIN------//-----
--         SET @tSQL += '  ,ISNULL(VPC.FCPdtCostStd,0)       AS FCPdtCostStd    , ISNULL(FCPdtCostAVGIN,0)     AS FCPdtCostAVGIN,'
--         SET @tSQL += '  ISNULL(VPC.FCPdtCostAVGEx,0)     AS FCPdtCostAVGEx  , ISNULL(FCPdtCostLast,0)      AS FCPdtCostLast,'
--         SET @tSQL += '  ISNULL(VPC.FCPdtCostFIFOIN,0)    AS FCPdtCostFIFOIN , ISNULL(FCPdtCostFIFOEx,0)    AS FCPdtCostFIFOEx'
--     END

--     SET @tSQL += ' FROM ('
--     SET @tSQL +=  @tSQLMaster
--     SET @tSQL += ' ) PDT ';
--     SET @tSQL += ' LEFT JOIN TCNMPdt_L AS PDT_L WITH(NOLOCK) ON PDT.FTPdtCode = PDT_L.FTPdtCode AND PDT_L.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
--     SET @tSQL += ' LEFT JOIN TCNMPdtUnit_L AS PDT_UNL WITH(NOLOCK) ON PDT.FTPunCode = PDT_UNL.FTPunCode  AND PDT_UNL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''''
--     --SET @tSQL += ' LEFT OUTER JOIN TCNMImgPdt AS PDT_IMG WITH(NOLOCK) ON PDT.FTPdtCode = PDT_IMG.FTImgRefID AND PDT_IMG.FTImgTable = ''TCNMPdt'' AND PDT_IMG.FNImgSeq = 1 '
--     SET @tSQL += ' LEFT OUTER JOIN TCNMPdtAge AS PDT_AGE WITH(NOLOCK) ON PDT.FTPdtCode = PDT_AGE.FTPdtCode '
--     SET @tSQL += ' LEFT OUTER JOIN VCN_VatActive AS VAT WITH(NOLOCK) ON PDT.FTVatCode = VAT.FTVatCode '

--     IF @tPriceType = 'Pricesell' OR @tPriceType = ''  BEGIN------//-----
--         --SET @tSQL += '  '
--         SET @tSQL += '  LEFT JOIN VCN_Price4PdtActive VPA WITH(NOLOCK) ON VPA.FTPdtCode = PDT.FTPdtCode AND VPA.FTPunCode = PDT_UNL.FTPunCode'
--     END

--     IF @tPriceType = 'Price4Cst' BEGIN

-- 			--//----ราคาของ customer
--       SET @tSQL += 'LEFT JOIN ( '
-- 			SET @tSQL += 'SELECT '
-- 			SET @tSQL += '	BP.FNRowPart,BP.FTPdtCode,BP.FTPunCode,BP.FDPghDStart,BP.FCPgdPriceNet,BP.FCPgdPriceWhs, '
-- 			SET @tSQL += '	CASE '
-- 			SET @tSQL += '		WHEN ADJ.FTPghStaAdj = ''2'' AND ADJ.FTPdtCode IS NOT NULL THEN ';
-- 			SET @tSQL += ' 			CONVERT (NUMERIC (18, 4),(BP.FCPgdPriceRet - (BP.FCPgdPriceRet * (ADJ.FCPgdPriceRet * 0.01)))) '
-- 			SET @tSQL += '		WHEN ADJ.FTPghStaAdj = ''3'' AND ADJ.FTPdtCode IS NOT NULL THEN '
-- 			SET @tSQL += ' 			CONVERT(NUMERIC(18,4), BP.FCPgdPriceRet - ADJ.FCPgdPriceRet) '
-- 			SET @tSQL += '		WHEN ADJ.FTPghStaAdj = ''4'' AND ADJ.FTPdtCode IS NOT NULL THEN '
-- 			SET @tSQL += ' 			CONVERT(NUMERIC(18,4), ((BP.FCPgdPriceRet * (ADJ.FCPgdPriceRet*0.01)) + BP.FCPgdPriceRet)) '
-- 			SET @tSQL += '		WHEN ADJ.FTPghStaAdj = ''5'' AND ADJ.FTPdtCode IS NOT NULL THEN '
-- 			SET @tSQL += ' 			CONVERT(NUMERIC(18,4), BP.FCPgdPriceRet + ADJ.FCPgdPriceRet) '
-- 			SET @tSQL += '	ELSE BP.FCPgdPriceRet '
-- 			SET @tSQL += '	END AS FCPgdPriceRet '
-- 			SET @tSQL += 'FROM ( '
-- 			SET @tSQL += '	SELECT '
-- 			SET @tSQL += '		ROW_NUMBER() OVER (PARTITION BY FTPdtCode,FTPunCode ORDER BY FTPplCode DESC, FTPghDocType DESC , FDPghDStart DESC) AS FNRowPart, '
-- 			SET @tSQL += '		CONVERT(VARCHAR(16), FDPghDStart, 121) AS FDPghDStart, '
-- 			SET @tSQL += '		FTPdtCode,FTPunCode,0 AS FCPgdPriceNet,FCPgdPriceRet,0 AS FCPgdPriceWhs,FTPplCode '
-- 			SET @tSQL += '   FROM TCNTPdtPrice4PDT WITH(NOLOCK) '
-- 			SET @tSQL += '   WHERE FDPghDStart <= CONVERT(VARCHAR(10), GETDATE(), 121) AND FTPghStaAdj = ''1'' '
-- 				IF @tPplCode = '' 
-- 					BEGIN SET @tSQL += '   AND ISNULL(FTPplCode,'''') = '''' ' END 
-- 				ELSE
-- 					BEGIN SET @tSQL += '   AND (FTPplCode = '''+@tPplCode+''' OR ISNULL(FTPplCode,'''') = '''')  ' END
-- 			SET @tSQL += ') BP '
-- 			SET @tSQL += 'LEFT JOIN ( '
-- 			SET @tSQL += '	SELECT '
-- 			SET @tSQL += '		ROW_NUMBER() OVER (PARTITION BY FTPdtCode,FTPunCode ORDER BY FTPplCode DESC, FTPghDocType DESC , FDPghDStart DESC) AS FNRowPart, '
-- 			SET @tSQL += '		CONVERT(VARCHAR(16), FDPghDStart, 121) AS FDPghDStart, '
-- 			SET @tSQL += '		FTPdtCode,FTPunCode,0 AS FCPgdPriceNet,FCPgdPriceRet,0 AS FCPgdPriceWhs,FTPghStaAdj,FTPplCode '
-- 			SET @tSQL += '   FROM TCNTPdtPrice4PDT WITH(NOLOCK) '
-- 			SET @tSQL += '   WHERE FDPghDStart <= CONVERT(VARCHAR(10), GETDATE(), 121) AND FTPghStaAdj <> ''1'' '
-- 				IF @tPplCode = '' 
-- 					BEGIN SET @tSQL += ' AND ISNULL(FTPplCode,'''') = '''' ' END 
-- 				ELSE 
-- 					BEGIN SET @tSQL += ' AND (FTPplCode = '''+@tPplCode+''' OR ISNULL(FTPplCode,'''') = '''') ' END
-- 			SET @tSQL += ' ) ADJ ON BP.FTPdtCode = ADJ.FTPdtCode AND BP.FTPunCode = ADJ.FTPunCode '
-- 			SET @tSQL += ' WHERE BP.FNRowPart = 1 '
-- 			SET @tSQL += ' AND (ADJ.FTPdtCode IS NULL OR ADJ.FNRowPart = 1) '
-- 			SET @tSQL += ' ) PCUS ON PDT.FTPdtCode = PCUS.FTPdtCode AND PDT.FTPunCode = PCUS.FTPunCode ' 
		
-- 			--// --ราคาของสาขา
-- 			SET @tSQL += ' LEFT JOIN ('
-- 			SET @tSQL += ' SELECT * FROM ('
-- 			SET @tSQL += ' SELECT '
-- 			SET @tSQL += ' ROW_NUMBER () OVER ( PARTITION BY FTPdtCode,FTPunCode ORDER BY FTPghDocType DESC , FDPghDStart DESC ) AS FNRowPart,'
-- 			SET @tSQL += ' FTPdtCode , '
-- 			SET @tSQL += ' FTPunCode , '
-- 			SET @tSQL += ' FCPgdPriceRet '
-- 			SET @tSQL += ' FROM TCNTPdtPrice4PDT WHERE  '
-- 			SET @tSQL += ' FDPghDStart <= CONVERT (VARCHAR(10), GETDATE(), 121)'
-- 			SET @tSQL += ' AND FDPghDStop >= CONVERT (VARCHAR(10), GETDATE(), 121)'
-- 			SET @tSQL += ' AND FTPghTStart <= CONVERT(time,GETDATE())'
-- 			SET @tSQL += ' AND FTPghTStop >= CONVERT(time,GETDATE())'
-- 			SET @tSQL += ' AND (FTPghDocType <> 3 AND FTPghDocType <> 4) '
-- 			SET @tSQL += ' AND ISNULL(FTPplCode,'''') = '''' OR FTPplCode = (SELECT FTPplCode FROM TCNMBranch WHERE FTPplCode != '''' AND FTBchCode = (SELECT TOP 1 FTBchCode FROM TCNMBranch WHERE FTAgnCode = '''+@tSesAgnCode+''' ))'
-- 			SET @tSQL += ') AS PCUS '
-- 			SET @tSQL += ' WHERE PCUS.FNRowPart = 1 '
-- 			SET @tSQL += ' ) PBCH ON PDT.FTPdtCode = PBCH.FTPdtCode AND PDT.FTPunCode = PBCH.FTPunCode '
--     END

--     IF @tPriceType = 'Cost' BEGIN
--         SET @tSQL += '  LEFT JOIN VCN_ProductCost VPC WITH(NOLOCK) ON VPC.FTPdtCode = PDT.FTPdtCode'
--     END
		
-- 		--SELECT @tSQL
--  EXECUTE(@tSQL)
-- --PRINT @tSQL
-- --RETURN @tSQL
-- 	--select @tSQL
-- 		 SELECT   
--         ERROR_NUMBER() AS ErrorNumber  
--         ,ERROR_SEVERITY() AS ErrorSeverity  
--         ,ERROR_STATE() AS ErrorState  
--         ,ERROR_LINE () AS ErrorLine  
--         ,ERROR_PROCEDURE() AS ErrorProcedure  
--         ,ERROR_MESSAGE() AS ErrorMessage; 
-- END
-- GO 


/****** End From DB:FitAuto Date 15/09/2022 By:Ice PHP ******/


IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxDailySaleByInvByPdt1001002')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_RPTxDailySaleByInvByPdt1001002] 
GO
CREATE PROCEDURE [dbo].[SP_RPTxDailySaleByInvByPdt1001002]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),

	@pnFilterType int, --1 BETWEEN 2 IN
	--สาขา
	@ptBchL Varchar(8000), --กรณี Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),
	--Merchant
	@ptMerL Varchar(8000), --กรณี Condition IN
	@ptMerF Varchar(10),
	@ptMerT Varchar(10),
	--Shop Code
	@ptShpL Varchar(8000), --กรณี Condition IN
	@ptShpF Varchar(10),
	@ptShpT Varchar(10),
	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	--@ptBchF Varchar(5),
	--@ptBchT Varchar(5),
	--@ptShpF Varchar(30),
	--@ptShpT Varchar(30),

	----ลูกค้า
	@ptCstF Varchar(20),
	@ptCstT Varchar(20),

	--@ptPdtCodeF Varchar(20),
	--@ptPdtCodeT Varchar(20),
	--@ptPdtChanF Varchar(30),
	--@ptPdtChanT Varchar(30),
	--@ptPdtTypeF Varchar(5),
	--@ptPdtTypeT Varchar(5),

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
	DECLARE @tSqlDrop VARCHAR(8000)
	DECLARE @tTblName Varchar(255)

	DECLARE @tSqlHD Varchar(8000)
	DECLARE @tSqlRC Varchar(8000)

	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)
	--Merchant
	DECLARE @tMerF Varchar(10)
	DECLARE @tMerT Varchar(10)
	--Shop Code
	DECLARE @tShpF Varchar(10)
	DECLARE @tShpT Varchar(10)
	--Pos Code
	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)
	--DECLARE @tBchF Varchar(5)
	--DECLARE @tBchT Varchar(5)
	--DECLARE @tShpF Varchar(30)
	--DECLARE @tShpT Varchar(30)

	--ลูกค้า
	DECLARE @tCstF Varchar(20)
	DECLARE @tCstT Varchar(20)

	--DECLARE @tPdtCodeF Varchar(20)
	--DECLARE @tPdtCodeT Varchar(20)
	--DECLARE @tPdtChanF Varchar(30)
	--DECLARE @tPdtChanT Varchar(30)
	--DECLARE @tPdtTypeF Varchar(5)
	--DECLARE @tPdtTypeT Varchar(5)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)



	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'SaleByInvByPdt1001002'
	--SET @ptUsrSession = '001'
	--SET @tBchF = '001'
	--SET @tBchT = '001'
	--SET @tShpF = '00001'
	--SET @tShpT = '00001'

	--SET @ptPdtCodeF  =''
	--SET @ptPdtCodeT =''
	--SET @ptPdtChanF =''
	--SET @ptPdtChanT =''
	--SET @ptPdtTypeF =''
	--SET @ptPdtTypeT =''

	--SET @tDocDateF = '2019-07-01'
	--SET @tDocDateT = '2019-07-10'


	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'DailySaleByInv1001001'
	--SET @ptUsrSession = '001'
	--SET @tBchF = ''
	--SET @tBchT = ''
	--SET @tShpF = ''
	--SET @tShpT = ''

	--SET @ptPdtCodeF  =''
	--SET @ptPdtCodeT =''
	--SET @ptPdtChanF =''
	--SET @ptPdtChanT =''
	--SET @ptPdtTypeF =''
	--SET @ptPdtTypeT =''

	--SET @tDocDateF = ''
	--SET @tDocDateT = ''

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--SET @tBchF = @ptBchF
	--SET @tBchT = @ptBchT
	--SET @tShpF = @ptShpF
	--SET @tShpT = @ptShpT
	--สาขา
	SET @tBchF = @ptBchF
	SET @tBchT = @ptBchT
	--ร้านค้า
	SET @tShpF = @ptShpF
	SET @tShpT = @ptShpT
	--เครื่องจุดขาย
	SET @tPosF = @ptPosF
	SET @tPosT = @ptPosT
	--กลุ่มธุรกิจ
	SET @tMerF = @ptMerF
	SET @tMerT = @ptMerT

	SET @tCstF = @ptCstF
	SET @tCstT = @ptCstT


	--SET @tPdtCodeF  = @ptPdtCodeF 
	--SET @tPdtCodeT = @ptPdtCodeT
	--SET @tPdtChanF = @ptPdtChanF
	--SET @tPdtChanT = @ptPdtChanT 
	--SET @tPdtTypeF = @ptPdtTypeF
	--SET @tPdtTypeT = @ptPdtTypeT

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

	IF @ptMerL =null
	BEGIN
		SET @ptMerL = ''
	END

	IF @tMerF =null
	BEGIN
		SET @tMerF = ''
	END
	IF @tMerT =null OR @tMerT = ''
	BEGIN
		SET @tMerT = @tMerF
	END 

	IF @ptShpL =null
	BEGIN
		SET @ptShpL = ''
	END

	IF @tShpF =null
	BEGIN
		SET @tShpF = ''
	END
	IF @tShpT =null OR @tShpT = ''
	BEGIN
		SET @tShpT = @tShpF
	END

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END

	IF @tCstF = null
	BEGIN
		SET @tCstF = ''
	END 
	IF @tCstT = null OR @tCstT =''
	BEGIN
		SET @tCstT = @tCstF
	END 
	--IF @tPdtCodeF = null
	--BEGIN
	--	SET @tPdtCodeF = ''
	--END 
	--IF @tPdtCodeT = null OR @tPdtCodeT =''
	--BEGIN
	--	SET @tPdtCodeT = @tPdtCodeF
	--END 

	--IF @tPdtChanF = null
	--BEGIN
	--	SET @tPdtChanF = ''
	--END 
	--IF @tPdtChanT = null OR @tPdtChanT =''
	--BEGIN
	--	SET @tPdtChanT = @tPdtChanF
	--END 

	--IF @tPdtTypeF = null
	--BEGIN
	--	SET @tPdtTypeF = ''
	--END 
	--IF @tPdtTypeT = null OR @tPdtTypeT =''
	--BEGIN
	--	SET @tPdtTypeT = @tPdtTypeF
	--END 

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END
	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END
	--NUI 13-01-2020 edit for cut pay cash coupon from rc
	--SET @tSql1 =   ' WHERE 1=1 AND FTXshStaDoc = ''1'''
	--SET @tSqlHD =   ' WHERE 1=1 AND FTXshStaDoc = ''1'''
	--SET @tSqlRC =   ' WHERE 1=1 AND FTXshStaDoc = ''1'''
	SET @tSql1 =   ' '
	SET @tSqlHD =   ' '
	SET @tSqlRC =   ' '

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSqlHD +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSql1 +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSqlRC +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSqlHD +=' AND SHP.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSql1 +=' AND SHP.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSqlRC +=' AND SHP.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSqlHD +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSql1 +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSqlRC +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSqlHD += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSql1 += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSqlRC += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSqlHD +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql1 +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSqlRC +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSqlHD +=' AND SHP.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql1 +=' AND SHP.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlRC +=' AND SHP.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSqlHD +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql1 +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlRC +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSqlHD += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSql1 += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSqlRC += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
		END		
	END
	--IF (@tBchF <> '' AND @tBchT <> '')
	--BEGIN
	--	SET @tSqlHD +=' AND FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--	SET @tSqlRC +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--	SET @tSql1 +=' AND DT.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--END
		
	--IF (@tShpF <> '' AND @tShpT <> '')
	--BEGIN
	--	SET @tSql1 +=' AND FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
	--	SET @tSqlHD +=' AND FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
	--	SET @tSqlRC +=' AND FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
	--END

	IF (@tCstF <> '' AND @tCstT <> '')
	BEGIN
		SET @tSql1 +=' AND FTCstCode BETWEEN ''' + @tCstF + ''' AND ''' + @tCstT + ''''
		SET @tSqlHD +=' AND HD.FTCstCode BETWEEN ''' + @tCstF + ''' AND ''' + @tCstT + ''''
		SET @tSqlRC +=' AND HD.FTCstCode BETWEEN ''' + @tCstF + ''' AND ''' + @tCstT + ''''
	END

	--IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	--BEGIN
	--	SET @tSql1 +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	--END

	--IF (@tPdtChanF <> '' AND @tPdtChanT <> '')
	--BEGIN
	--	SET @tSql1 +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
	--END

	--IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	--BEGIN
	--	SET @tSql1 +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	--END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSqlHD +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSqlRC +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTSalPdtBillTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp

	--SET @tTblName = 'TRPTSalPdtBillTmp'+ @nComName + ''
	--PRINT @tTblName
	----if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].''+@tTblName''')) 
	--SET @tSqlDrop = ' if exists (select * from dbo.sysobjects where name = '''+@tTblName+ ''')'--id = object_id(N'[dbo].''+@tTblName'''))' 
	--SET @tSqlDrop += ' DROP TABLE '+ @tTblName + ''
	--EXECUTE(@tSqlDrop)
	----PRINT @tSqlDrop
	-- HD Sale
	SET @tSqlIns = ' INSERT INTO TRPTSalPdtBillTmp'
	SET @tSqlIns += ' (FTComName,FTRptCode,FTUsrSession,FNAppType,FNType,FNXshDocType,FDXshDocDate,FTXshDocNo,FTXshRefInt,FTCstCode,FTCstName,FCXshVatable,FCXshVat,FCXshDis,FCXshTotalAfDis,FCXshRnd,FCXshGrand,'	
	SET @tSqlIns += ' FTPdtCode,FTPdtName, FTPunName,FCXsdQty,FCXsdSetPrice, FCXsdAmt,   FCXsdDis,  FCXsdNet,'
    SET @tSqlIns += ' FTRcvName, FTXrcRefNo1, FDXrcRefDate, FTBnkName, FCXrcNet,FTBchCode,FTBchName)'	
	--SET @tSqlIns += ' INTO  '+ @tTblName + ''		
	--SET @tSqlIns += ' FROM('
	SET @tSqlIns += ' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSqlIns += ' 1 AS FNAppType,1 AS FNType,HD.FNXshDocType,CONVERT(VARCHAR(19),FDXshDocDate,120) AS FDXshDocDate, HD.FTXshDocNo,FTXshRefInt,HD.FTCstCode,FTCstName,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshVatable,0) ELSE ISNULL(FCXshVatable,0)*-1 END AS FCXshVatable,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END AS FCXshVat,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshChg,0)- ISNULL(FCXshDis,0) ELSE (ISNULL(FCXshChg,0)- ISNULL(FCXshDis,0))*-1 END  AS FCXshDis,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshTotal,0)+(ISNULL(FCXshChg,0)- ISNULL(FCXshDis,0)) ELSE (ISNULL(FCXshTotal,0)+(ISNULL(FCXshChg,0)- ISNULL(FCXshDis,0)))*-1 END AS FCXshTotalAfDis,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshRnd,0) ELSE ISNULL(FCXshRnd,0)*-1 END AS FCXshRnd, '
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshGrand,0) ELSE ISNULL(FCXshGrand,0)*-1 END AS FCXshGrand,'
	SET @tSqlIns += ' '''' AS FTPdtCode,'''' AS FTPdtName,'''' AS FTPunName,0 AS FCXsdQty,0 AS FCXsdSetPrice,0 AS FCXsdAmt, 0 AS FCXsdDis, 0 AS FCXsdNet,'
	SET @tSqlIns += ' '''' AS FTRcvName,'''' AS FTXrcRefNo1,NULL AS FDXrcRefDate,'''' AS FTBnkName,0 AS FCXrcNet, '
	SET @tSqlIns += ' HD.FTBchCode,BchL.FTBchName'
	SET @tSqlIns += ' FROM TPSTSalHD HD'
	SET @tSqlIns += ' LEFT JOIN TCNMBranch_L BchL WITH (NOLOCK) ON HD.FTBchCode = BchL.FTBchCode  AND BchL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
	SET @tSqlIns += ' LEFT JOIN TCNMCst_L Cst_L WITH (NOLOCK) ON HD.FTCstCode = Cst_L.FTCstCode  AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
	SET @tSqlIns += ' LEFT JOIN TCNMShop SHP WITH (NOLOCK) ON HD.FTShpCode = SHP.FTShpCode AND HD.FTBchCode = SHP.FTBchCode '
	--NUI 13-01-2020 edit for cut pay cash coupon from rc
	SET @tSqlIns += ' WHERE 1=1 AND FTXshStaDoc = ''1'''
	SET @tSqlIns +=   @tSqlHD
	--HD Vending
	SET @tSqlIns += 'UNION ALL'

    SET @tSqlIns += ' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSqlIns += ' 2 AS FNAppType,1 AS FNType,HD.FNXshDocType,CONVERT(VARCHAR(19),FDXshDocDate,120) AS FDXshDocDate, HD.FTXshDocNo,FTXshRefInt,HD.FTCstCode,FTCstName,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshVatable,0) ELSE ISNULL(FCXshVatable,0)*-1 END AS FCXshVatable,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END AS FCXshVat,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshChg,0)- ISNULL(FCXshDis,0) ELSE (ISNULL(FCXshChg,0)- ISNULL(FCXshDis,0))*-1 END  AS FCXshDis,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshTotal,0)+(ISNULL(FCXshChg,0)- ISNULL(FCXshDis,0)) ELSE (ISNULL(FCXshTotal,0)+(ISNULL(FCXshChg,0)- ISNULL(FCXshDis,0)))*-1 END AS FCXshTotalAfDis,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshRnd,0) ELSE ISNULL(FCXshRnd,0)*-1 END AS FCXshRnd, '
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXshGrand,0) ELSE ISNULL(FCXshGrand,0)*-1 END AS FCXshGrand,'
	SET @tSqlIns += ' '''' AS FTPdtCode,'''' AS FTPdtName,'''' AS FTPunName,0 AS FCXsdQty,0 AS FCXsdSetPrice,0 AS FCXsdAmt, 0 AS FCXsdDis, 0 AS FCXsdNet,'
	SET @tSqlIns += ' '''' AS FTRcvName,'''' AS FTXrcRefNo1,NULL AS FDXrcRefDate,'''' AS FTBnkName,0 AS FCXrcNet,'
	SET @tSqlIns += ' HD.FTBchCode,BchL.FTBchName'
	SET @tSqlIns += ' FROM TVDTSalHD HD'
	--NUI 13-01-2020 edit for cut pay cash coupon from rc
	SET @tSqlIns +=' INNER JOIN TVDTSalRC RC WITH(NOLOCK) ON HD.FTBchCode = RC.FTBchCode AND HD.FTXshDocNo = RC.FTXshDocNo'
	SET @tSqlIns +=' LEFT JOIN TFNMRcv Rcv WITH(NOLOCK) ON  RC.FTRcvCode = Rcv.FTRcvCode'			
	------------
	SET @tSqlIns += ' LEFT JOIN TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode  AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
	SET @tSqlIns += ' LEFT JOIN TCNMBranch_L BchL WITH (NOLOCK) ON HD.FTBchCode = BchL.FTBchCode  AND BchL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
	SET @tSqlIns += ' LEFT JOIN TCNMShop SHP WITH (NOLOCK) ON HD.FTShpCode = SHP.FTShpCode AND HD.FTBchCode = SHP.FTBchCode '
	--NUI 13-01-2020 edit for cut pay cash coupon from rc
	SET @tSqlIns += ' WHERE 1=1 AND FTXshStaDoc = ''1''   AND Rcv.FTFmtCode <> ''004'''
	SET @tSqlIns +=  @tSqlHD

	--SET @tSqlIns += @tSql1
	--PRINT @tSqlIns
	EXECUTE(@tSqlIns)

	--SET @tSqlIns += ' UNION ALL'
	----DT SALE
	SET @tSqlIns = ' INSERT INTO TRPTSalPdtBillTmp'
	SET @tSqlIns += ' (FTComName,FTRptCode,FTUsrSession,FNAppType,FNType,FNXshDocType,FDXshDocDate,FTXshDocNo,FTXshRefInt,FTCstCode,FTCstName,FCXshVatable,FCXshVat,FCXshDis,FCXshTotalAfDis,FCXshRnd,FCXshGrand,'	
	SET @tSqlIns += ' FTPdtCode,FTPdtName, FTPunName,FCXsdQty,FCXsdSetPrice, FCXsdAmt,   FCXsdDis,  FCXsdNet,'
    SET @tSqlIns += ' FTRcvName, FTXrcRefNo1, FDXrcRefDate, FTBnkName, FCXrcNet,FTBchCode,FTBchName)'	
	SET @tSqlIns += ' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSqlIns += ' 1 AS FNAppType,2 AS FNType,HD.FNXshDocType,CONVERT(VARCHAR(19),HD.FDXshDocDate,120) AS FDXshDocDate, HD.FTXshDocNo,'''' AS FTXshRefInt,HD.FTCstCode,'''' AS FTCstName,'
	SET @tSqlIns += ' 0 AS FCXshVatable,0 AS FCXshVat,0 AS FCXshDis, 0 AS FCXshTotalAfDis,0 AS FCXshRnd,0 AS FCXshGrand,'
	SET @tSqlIns += ' DT.FTPdtCode,Pdt_L.FTPdtName,Pun_L.FTPunName,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXsdQty,0) ELSE ISNULL(FCXsdQty,0)*-1 END AS FCXsdQty,'
	SET @tSqlIns += ' ISNULL(FCXsdSetPrice,0) AS FCXsdSetPrice,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXsdSetPrice,0)*ISNULL(FCXsdQty,0) ELSE (ISNULL(FCXsdSetPrice,0)*ISNULL(FCXsdQty,0))*-1 END AS FCXsdAmt,'
	--SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXddDTDis,0)+ISNULL(FCXddDTDisPmt,0) ELSE (ISNULL(FCXddDTDis,0)+ISNULL(FCXddDTDisPmt,0))*-1 END As FCXsdDis,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN CASE WHEN DT.FTXsdStaPdt = ''4'' THEN	(	ISNULL(FCXddDTDis, 0) + ISNULL(FCXddDTDisPmt, 0)	) *0	ELSE 	ISNULL(FCXddDTDis, 0) + ISNULL(FCXddDTDisPmt, 0)		END ELSE CASE WHEN DT.FTXsdStaPdt = ''4'' THEN (	ISNULL(FCXddDTDis, 0) + ISNULL(FCXddDTDisPmt, 0)	) *0	ELSE (ISNULL(FCXddDTDis, 0) + ISNULL(FCXddDTDisPmt, 0) 	) *- 1	END END AS FCXsdDis, '
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXsdNet,0)+ISNULL(FCXddDTDisPmt,0) ELSE (ISNULL(FCXsdNet,0)+ISNULL(FCXddDTDisPmt,0))*-1 END AS FCXsdNet,'
	SET @tSqlIns += ' '''' AS FTRcvName,'''' AS FTXrcRefNo1,NULL AS FDXrcRefDate,'''' AS FTBnkName,0 AS FCXrcNet,'
	SET @tSqlIns += ' '''' AS FTBchCode,'''' AS FTBchName'
	SET @tSqlIns += ' FROM TPSTSalHD HD INNER JOIN TPSTSalDT DT ON HD.FTBchCode = DT.FTBchCode AND HD.FTXshDocNo = DT.FTXshDocNo'
	SET @tSqlIns += ' LEFT JOIN TCNMPdt Pdt ON DT.FTPdtCode = Pdt.FTPdtCode '
	SET @tSqlIns += ' LEFT JOIN TCNMPdt_L Pdt_L ON DT.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''' 
	SET @tSqlIns += ' LEFT JOIN TCNMPdtUnit_L Pun_L ON DT.FTPunCode = Pun_L.FTPunCode AND Pun_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''' 
	SET @tSqlIns += ' LEFT JOIN TCNMShop SHP WITH (NOLOCK) ON HD.FTShpCode = SHP.FTShpCode AND HD.FTBchCode = SHP.FTBchCode '

	SET @tSqlIns += ' LEFT JOIN' 
		SET @tSqlIns += ' ('
			SET @tSqlIns += ' SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
			SET @tSqlIns += ' CASE FTXddDisChgType' 
				SET @tSqlIns += ' WHEN ''1'' THEN FCXddValue*-1'
				SET @tSqlIns += ' WHEN ''2'' THEN FCXddValue*-1'
				SET @tSqlIns += ' WHEN ''3'' THEN FCXddValue'
				SET @tSqlIns += ' WHEN ''4'' THEN FCXddValue'
				SET @tSqlIns += ' END'
			 SET @tSqlIns += ' AS FCXddDTDis'
			SET @tSqlIns += ' FROM TPSTSalDTDis'
			SET @tSqlIns += ' WHERE FNXddStaDis IN (1)'
		SET @tSqlIns += ' ) DTDis ON DT.FTBchCode = DTDis.FTBchCode AND DT.FTXshDocNo = DTDis.FTXshDocNo AND DT.FNXsdSeqNo = DTDis.FNXsdSeqNo'

	SET @tSqlIns += ' LEFT JOIN'
		SET @tSqlIns += ' ('
			 SET @tSqlIns += ' SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
			 SET @tSqlIns += ' CASE FTXddDisChgType'
				 SET @tSqlIns += ' WHEN ''1'' THEN ISNULL(FCXddValue,0)*-1'
				 SET @tSqlIns += ' WHEN ''2'' THEN ISNULL(FCXddValue,0)*-1'
				 SET @tSqlIns += ' WHEN ''3'' THEN ISNULL(FCXddValue,0)'
				 SET @tSqlIns += ' WHEN ''4'' THEN ISNULL(FCXddValue,0)'
				 SET @tSqlIns += ' END'
			  SET @tSqlIns += ' AS FCXddDTDisPmt'
			 SET @tSqlIns += ' FROM TPSTSalDTDis'
			 SET @tSqlIns += ' WHERE FNXddStaDis IN (0)'
		 SET @tSqlIns += ' ) DTDisPmt ON DT.FTBchCode = DTDisPmt.FTBchCode AND DT.FTXshDocNo = DTDisPmt.FTXshDocNo AND DT.FNXsdSeqNo = DTDisPmt.FNXsdSeqNo'
	--NUI 13-01-2020 edit for cut pay cash coupon from rc
	SET @tSqlIns += ' WHERE 1=1 AND FTXshStaDoc = ''1'''
	SET @tSqlIns += @tSql1
	PRINT @tSqlIns
	EXECUTE(@tSqlIns)
	--DT Vending
	--SET @tSqlIns += 'UNION ALL'
	----DT SALE
	SET @tSqlIns = ' INSERT INTO TRPTSalPdtBillTmp'
	SET @tSqlIns += ' (FTComName,FTRptCode,FTUsrSession,FNAppType,FNType,FNXshDocType,FDXshDocDate,FTXshDocNo,FTXshRefInt,FTCstCode,FTCstName,FCXshVatable,FCXshVat,FCXshDis,FCXshTotalAfDis,FCXshRnd,FCXshGrand,'	
	SET @tSqlIns += ' FTPdtCode,FTPdtName, FTPunName,FCXsdQty,FCXsdSetPrice, FCXsdAmt,   FCXsdDis,  FCXsdNet,'
    SET @tSqlIns += ' FTRcvName, FTXrcRefNo1, FDXrcRefDate, FTBnkName, FCXrcNet,FTBchCode,FTBchName)'	
	SET @tSqlIns += ' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSqlIns += ' 2 AS FNAppType,2 AS FNType,HD.FNXshDocType,CONVERT(VARCHAR(19),HD.FDXshDocDate,120) AS FDXshDocDate, HD.FTXshDocNo,'''' AS FTXshRefInt,HD.FTCstCode,'''' AS FTCstName,'
	SET @tSqlIns += ' 0 AS FCXshVatable,0 AS FCXshVat,0 AS FCXshDis, 0 AS FCXshTotalAfDis,0 AS FCXshRnd,0 AS FCXshGrand,'
	SET @tSqlIns += ' DT.FTPdtCode,Pdt_L.FTPdtName,Pun_L.FTPunName,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXsdQty,0) ELSE ISNULL(FCXsdQty,0)*-1 END AS FCXsdQty,'
	SET @tSqlIns += ' ISNULL(FCXsdSetPrice,0) AS FCXsdSetPrice,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXsdSetPrice,0)*ISNULL(FCXsdQty,0) ELSE (ISNULL(FCXsdSetPrice,0)*ISNULL(FCXsdQty,0))*-1 END AS FCXsdAmt,'
	--SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXddDTDis,0)+ISNULL(FCXddDTDisPmt,0) ELSE (ISNULL(FCXddDTDis,0)+ISNULL(FCXddDTDisPmt,0))*-1 END As FCXsdDis,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN CASE WHEN DT.FTXsdStaPdt = ''4'' THEN	(	ISNULL(FCXddDTDis, 0) + ISNULL(FCXddDTDisPmt, 0)	) *0	ELSE 	ISNULL(FCXddDTDis, 0) + ISNULL(FCXddDTDisPmt, 0)		END ELSE CASE WHEN DT.FTXsdStaPdt = ''4'' THEN (	ISNULL(FCXddDTDis, 0) + ISNULL(FCXddDTDisPmt, 0)	) *0	ELSE (ISNULL(FCXddDTDis, 0) + ISNULL(FCXddDTDisPmt, 0) 	) *- 1	END END AS FCXsdDis, '
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXsdNet,0)+ISNULL(FCXddDTDisPmt,0) ELSE (ISNULL(FCXsdNet,0)+ISNULL(FCXddDTDisPmt,0))*-1 END AS FCXsdNet,'

	SET @tSqlIns += ' '''' AS FTRcvName,'''' AS FTXrcRefNo1,NULL AS FDXrcRefDate,'''' AS FTBnkName,0 AS FCXrcNet,'
	SET @tSqlIns += ' '''' AS FTBchCode,'''' ASFTBchName'
	SET @tSqlIns += ' FROM TVDTSalHD HD INNER JOIN TVDTSalDT DT ON HD.FTBchCode = DT.FTBchCode AND HD.FTXshDocNo = DT.FTXshDocNo'
	--NUI 2020-01-13
	SET @tSqlIns +=' INNER JOIN TVDTSalRC RC WITH(NOLOCK) ON HD.FTBchCode = RC.FTBchCode AND HD.FTXshDocNo = RC.FTXshDocNo'
	SET @tSqlIns +=' LEFT JOIN TFNMRcv Rcv WITH(NOLOCK) ON  RC.FTRcvCode = Rcv.FTRcvCode'			
	------------
	SET @tSqlIns += ' INNER JOIN TCNMPdt Pdt ON DT.FTPdtCode = Pdt.FTPdtCode '
	SET @tSqlIns += ' LEFT JOIN TCNMPdt_L Pdt_L ON DT.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''' 
	SET @tSqlIns += ' LEFT JOIN TCNMPdtUnit_L Pun_L ON DT.FTPunCode = Pun_L.FTPunCode AND Pun_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''' 
	SET @tSqlIns += ' LEFT JOIN TCNMShop SHP WITH (NOLOCK) ON HD.FTShpCode = SHP.FTShpCode AND HD.FTBchCode = SHP.FTBchCode '

	SET @tSqlIns += ' LEFT JOIN' 
		SET @tSqlIns += ' ('
			SET @tSqlIns += ' SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
			SET @tSqlIns += ' CASE FTXddDisChgType' 
				SET @tSqlIns += ' WHEN ''1'' THEN FCXddValue*-1'
				SET @tSqlIns += ' WHEN ''2'' THEN FCXddValue*-1'
				SET @tSqlIns += ' WHEN ''3'' THEN FCXddValue'
				SET @tSqlIns += ' WHEN ''4'' THEN FCXddValue'
				SET @tSqlIns += ' END'
			 SET @tSqlIns += ' AS FCXddDTDis'
			SET @tSqlIns += ' FROM TPSTSalDTDis'
			SET @tSqlIns += ' WHERE FNXddStaDis IN (1)'
		SET @tSqlIns += ' ) DTDis ON DT.FTBchCode = DTDis.FTBchCode AND DT.FTXshDocNo = DTDis.FTXshDocNo AND DT.FNXsdSeqNo = DTDis.FNXsdSeqNo'

	SET @tSqlIns += ' LEFT JOIN'
		SET @tSqlIns += ' ('
			 SET @tSqlIns += ' SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
			 SET @tSqlIns += ' CASE FTXddDisChgType'
				 SET @tSqlIns += ' WHEN ''1'' THEN ISNULL(FCXddValue,0)*-1'
				 SET @tSqlIns += ' WHEN ''2'' THEN ISNULL(FCXddValue,0)*-1'
				 SET @tSqlIns += ' WHEN ''3'' THEN ISNULL(FCXddValue,0)'
				 SET @tSqlIns += ' WHEN ''4'' THEN ISNULL(FCXddValue,0)'
				 SET @tSqlIns += ' END'
			  SET @tSqlIns += ' AS FCXddDTDisPmt'
			 SET @tSqlIns += ' FROM TPSTSalDTDis'
			 SET @tSqlIns += ' WHERE FNXddStaDis IN (0)'
		 SET @tSqlIns += ' ) DTDisPmt ON DT.FTBchCode = DTDisPmt.FTBchCode AND DT.FTXshDocNo = DTDisPmt.FTXshDocNo AND DT.FNXsdSeqNo = DTDisPmt.FNXsdSeqNo'
	--NUI 13-01-2020 edit for cut pay cash coupon from rc
	SET @tSqlIns += ' WHERE 1=1 AND FTXshStaDoc = ''1''  AND Rcv.FTFmtCode <> ''004'''
	SET @tSqlIns += @tSql1

	--PRINT @tSqlIns
	EXECUTE(@tSqlIns)
	--SET @tSqlIns += ' UNION ALL'
	----RC
	SET @tSqlIns = ' INSERT INTO TRPTSalPdtBillTmp'
	SET @tSqlIns += ' (FTComName,FTRptCode,FTUsrSession,FNAppType,FNType,FNXshDocType,FDXshDocDate,FTXshDocNo,FTXshRefInt,FTCstCode,FTCstName,FCXshVatable,FCXshVat,FCXshDis,FCXshTotalAfDis,FCXshRnd,FCXshGrand,'	
	SET @tSqlIns += ' FTPdtCode,FTPdtName, FTPunName,FCXsdQty,FCXsdSetPrice, FCXsdAmt,   FCXsdDis,  FCXsdNet,'
    SET @tSqlIns += ' FTRcvName, FTXrcRefNo1, FDXrcRefDate, FTBnkName, FCXrcNet ,FTBchCode,FTBchName)'
	SET @tSqlIns += ' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSqlIns += ' 1 AS FNAppType,3 AS FNType,HD.FNXshDocType,CONVERT(VARCHAR(19),HD.FDXshDocDate,120) AS FDXshDocDate, HD.FTXshDocNo,'''' AS FTXshRefInt,HD.FTCstCode,'''' AS FTCstName,'
	SET @tSqlIns += ' 0 AS FCXshVatable,0 AS FCXshVat,0 AS FCXshDis, 0 AS FCXshTotalAfDis,0 AS FCXshRnd,0 AS FCXshGrand,'
	SET @tSqlIns += ' '''' AS FTPdtCode,'''' AS FTPdtName,'''' AS FTPunName,0 AS FCXsdQty,0 AS FCXsdSetPrice,0 AS FCXsdAmt, 0 AS FCXsdDis, 0 AS FCXsdNet,'
	SET @tSqlIns += ' Rcv_L.FTRcvName,ISNULL(FTXrcRefNo1,'''') AS FTXrcRefNo1, CONVERT(VARCHAR(10),FDXrcRefDate,121) AS FDXrcRefDate,ISNULL(Bnk_L.FTBnkName,'''') AS FTBnkName,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXrcNet,0) ELSE ISNULL(FCXrcNet,0)*-1 END AS FCXrcNet,'
	SET @tSqlIns += ' '''' AS FTBchCode, '''' AS FTBchName'
	SET @tSqlIns += ' FROM TPSTSalHD HD INNER JOIN TPSTSalRC RC ON HD.FTBchCode = RC.FTBchCode AND HD.FTXshDocNo = RC.FTXshDocNo'
	SET @tSqlIns += ' LEFT JOIN TFNMRcv_L Rcv_L ON RC.FTRcvCode = Rcv_L.FTRcvCode AND Rcv_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''' 
	SET @tSqlIns += ' LEFT JOIN TFNMBank_L Bnk_L ON RC.FTBnkCode = Bnk_L.FTBnkCode AND Bnk_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''' 
	SET @tSqlIns += ' LEFT JOIN TCNMShop SHP WITH (NOLOCK) ON HD.FTShpCode = SHP.FTShpCode AND HD.FTBchCode = SHP.FTBchCode '
	--NUI 13-01-2020 edit for cut pay cash coupon from rc
	SET @tSqlIns += ' WHERE 1=1 AND FTXshStaDoc = ''1'''
	SET @tSqlIns +=   @tSqlRC

	--RC Vanding
	SET @tSqlIns += 'UNION ALL'
	SET @tSqlIns += ' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSqlIns += ' 2 AS FNAppType,3 AS FNType,HD.FNXshDocType,CONVERT(VARCHAR(19),HD.FDXshDocDate,120) AS FDXshDocDate, HD.FTXshDocNo,'''' AS FTXshRefInt,HD.FTCstCode,'''' AS FTCstName,'
	SET @tSqlIns += ' 0 AS FCXshVatable,0 AS FCXshVat,0 AS FCXshDis, 0 AS FCXshTotalAfDis,0 AS FCXshRnd,0 AS FCXshGrand,'
	SET @tSqlIns += ' '''' AS FTPdtCode,'''' AS FTPdtName,'''' AS FTPunName,0 AS FCXsdQty,0 AS FCXsdSetPrice,0 AS FCXsdAmt, 0 AS FCXsdDis, 0 AS FCXsdNet,'
	SET @tSqlIns += ' Rcv_L.FTRcvName,ISNULL(FTXrcRefNo1,'''') AS FTXrcRefNo1, CONVERT(VARCHAR(10),FDXrcRefDate,121) AS FDXrcRefDate,ISNULL(Bnk_L.FTBnkName,'''') AS FTBnkName,'
	SET @tSqlIns += ' CASE WHEN HD.FNXshDocType = ''1'' THEN  ISNULL(FCXrcNet,0) ELSE ISNULL(FCXrcNet,0)*-1 END AS FCXrcNet,'
	SET @tSqlIns += ' '''' AS FTBchCode,'''' AS FTBchName'

	SET @tSqlIns += ' FROM TVDTSalHD HD INNER JOIN TVDTSalRC RC ON HD.FTBchCode = RC.FTBchCode AND HD.FTXshDocNo = RC.FTXshDocNo'
	SET @tSqlIns += ' LEFT JOIN TFNMRcv Rcv WITH(NOLOCK) ON  RC.FTRcvCode = Rcv.FTRcvCode'		
	SET @tSqlIns += ' LEFT JOIN TFNMRcv_L Rcv_L ON RC.FTRcvCode = Rcv_L.FTRcvCode AND Rcv_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''' 
	SET @tSqlIns += ' LEFT JOIN TFNMBank_L Bnk_L ON RC.FTBnkCode = Bnk_L.FTBnkCode AND Bnk_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + '''' 
	SET @tSqlIns += ' LEFT JOIN TCNMShop SHP WITH (NOLOCK) ON HD.FTShpCode = SHP.FTShpCode AND HD.FTBchCode = SHP.FTBchCode '
	--NUI 13-01-2020 edit for cut pay cash coupon from rc
	SET @tSqlIns += ' WHERE 1=1 AND FTXshStaDoc = ''1'' AND Rcv.FTFmtCode <> ''004''' 
	SET @tSqlIns +=  @tSqlRC

	--PRINT @tSqlIns
	EXECUTE(@tSqlIns)

	RETURN SELECT * FROM TRPTSalPdtBillTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + '' ORDER BY FTXshDocNo,FDXshDocDate--,FNType--,FNAppType,FNType--,FDXshDocDate,FTXshDocNo
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
	--PRINT @tSqlIns
END CATCH	
GO





/****** Object:  StoredProcedure [dbo].[SP_RPTxDailySaleByPdt_Animate]    Script Date: 05/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxDailySaleByPdt_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxDailySaleByPdt_Animate
GO
CREATE PROCEDURE SP_RPTxDailySaleByPdt_Animate 
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
	--Merchant
	@ptMerL Varchar(8000), --กรณี Condition IN
	@ptMerF Varchar(10),
	@ptMerT Varchar(10),
	--Shop Code
	@ptShpL Varchar(8000), --กรณี Condition IN
	@ptShpF Varchar(10),
	@ptShpT Varchar(10),
	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptPdtCodeF Varchar(20),
	@ptPdtCodeT Varchar(20),
	@ptPdtChanF Varchar(30),
	@ptPdtChanT Varchar(30),
	@ptPdtTypeF Varchar(5),
	@ptPdtTypeT Varchar(5),

	--NUI 22-09-05 RQ2208-020
	@ptPbnF Varchar(5),
	@ptPbnT Varchar(5),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 16/09/2022
-- V.04.00.00
-- Temp name  TRPTSalDTTmp_Animate
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
	DECLARE @tSqlLast VARCHAR(8000)
	DECLARE @tSql1 VARCHAR(8000)
	DECLARE @tSqlPdt VARCHAR(8000)

	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)
	--Merchant
	DECLARE @tMerF Varchar(10)
	DECLARE @tMerT Varchar(10)
	--Shop Code
	DECLARE @tShpF Varchar(10)
	DECLARE @tShpT Varchar(10)
	--Pos Code
	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tPdtCodeF Varchar(20)
	DECLARE @tPdtCodeT Varchar(20)
	DECLARE @tPdtChanF Varchar(30)
	DECLARE @tPdtChanT Varchar(30)
	DECLARE @tPdtTypeF Varchar(5)
	DECLARE @tPdtTypeT Varchar(5)

	DECLARE @tPbnF Varchar(5)
	DECLARE @tPbnT Varchar(5)

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
	--Merchant
	SET @tMerF  = @ptMerF
	SET @tMerT  = @ptMerT
	--Shop
	SET @tShpF  = @ptShpF
	SET @tShpT  = @ptShpT
	--Pos
	SET @tPosF  = @ptPosF 
	SET @tPosT  = @ptPosT

	SET @tPdtCodeF  = @ptPdtCodeF 
	SET @tPdtCodeT = @ptPdtCodeT
	SET @tPdtChanF = @ptPdtChanF
	SET @tPdtChanT = @ptPdtChanT 
	SET @tPdtTypeF = @ptPdtTypeF
	SET @tPdtTypeT = @ptPdtTypeT

	SET @tPbnF = @ptPbnF
	SET @tPbnT = @ptPbnT


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

	IF @ptMerL =null
	BEGIN
		SET @ptMerL = ''
	END

	IF @tMerF =null
	BEGIN
		SET @tMerF = ''
	END
	IF @tMerT =null OR @tMerT = ''
	BEGIN
		SET @tMerT = @tMerF
	END 

	IF @ptShpL =null
	BEGIN
		SET @ptShpL = ''
	END

	IF @tShpF =null
	BEGIN
		SET @tShpF = ''
	END
	IF @tShpT =null OR @tShpT = ''
	BEGIN
		SET @tShpT = @tShpF
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

	IF @tPdtChanF = null
	BEGIN
		SET @tPdtChanF = ''
	END 
	IF @tPdtChanT = null OR @tPdtChanT =''
	BEGIN
		SET @tPdtChanT = @tPdtChanF
	END 

	IF @tPdtTypeF = null
	BEGIN
		SET @tPdtTypeF = ''
	END 
	IF @tPdtTypeT = null OR @tPdtTypeT =''
	BEGIN
		SET @tPdtTypeT = @tPdtTypeF
	END 

	IF @tPbnF = null
	BEGIN
		SET @tPbnF = ''
	END 
	IF @tPbnT = null OR @tPbnT =''
	BEGIN
		SET @tPbnT = @tPbnF
	END 

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END
	SET @tSqlLast = ''
	SET @tSql1 = ''
	SET @tSqlPdt = ''
	SET @tSql1 =   ' WHERE FTXshStaDoc = ''1'' AND DT.FTXsdStaPdt <> ''4'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND DT.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSql1 +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
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
			SET @tSqlPdt +=' AND StkBal.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSql1 +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
		END		
	END
	IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		SET @tSql1 +=' AND DT.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	END

	IF (@tPdtChanF <> '' AND @tPdtChanT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		SET @tSql1 +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		SET @tSql1 += ' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tPbnF <> '' AND @tPbnT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		SET @tSql1 += ' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		--PRINT @tSqlLast
		IF @tSqlLast = ''
		BEGIN
			SET @tSql1 +=' AND (CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			SET @tSql1 +=' OR CONVERT(VARCHAR(10),FDXshDocDate,121) = ''1900-01-01'')'
			SET @tSqlLast =' CONVERT(VARCHAR(10),Sal.FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			SET @tSqlLast += ' OR ISNULL(Sal.FDXshDocDate,''1900-01-01'') = ''1900-01-01'''
	   END
	   ELSE
	   BEGIN
			SET @tSql1 +=' AND (CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			SET @tSql1 +=' OR CONVERT(VARCHAR(10),FDXshDocDate,121) = ''1900-01-01'')'
			SET @tSqlLast +=' AND (CONVERT(VARCHAR(10),Sal.FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			SET @tSqlLast += ' OR ISNULL(Sal.FDXshDocDate,''1900-01-01'') = ''1900-01-01'')'
	   END
	END

	DELETE FROM TRPTSalDTTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  =' INSERT INTO TRPTSalDTTmp_Animate '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTBchCode,FTBchName,FTXsdBarCode,FTPdtName,FTPgpChainName,FTPbnName,'
	 SET @tSql +=' FCXsdQtyAll,FCStkQty,FCSdtNetSale,FCPgdPriceRet,FCSdtNetAmt'
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' ISNULL(FTBchCode,'''') AS FTBchCode,ISNULL(FTBchName,'''') AS FTBchName,ISNULL(FTXsdBarCode,'''') AS FTXsdBarCode,ISNULL(FTPdtName,'''') AS FTPdtName ,ISNULL(FTPgpChainName,'''') AS FTPgpChainName,ISNULL(FTPbnName,'''') AS FTPbnName,'
	SET @tSql +=' SUM(ISNULL(FCXsdQtyAll,0)) AS FCXsdQtyAll,' --จำนวนขาย
	SET @tSql +=' ISNULL(FCStkQty,0) AS FCStkQty,' --สต๊อกคงเหลือ
	SET @tSql +=' SUM(ISNULL(FCSdtNetSale,0)) AS FCSdtNetSale,' --ยอดขาย
	SET @tSql +=' ISNULL(FCPgdPriceRet,0) AS FCPgdPriceRet,' --ราคา/หน่วย
	SET @tSql +=' SUM(ISNULL(FCSdtNetAmt,0)) AS FCSdtNetAmt' --ยอดขายรวม
	--PRINT  @tSql
	SET @tSql +=' FROM'
		SET @tSql +=' (SELECT Bla.FTBchCode,FTBchName,Bla.FTPdtCode,Bla.FTBarCode AS FTXsdBarCode,FTPdtName,ISNULL(FTPgpChainName,'''') AS FTPgpChainName,ISNULL(FTPbnName,'''') AS FTPbnName,'
		SET @tSql +=' Sal.FTXshDocNo,ISNULL(Sal.FDXshDocDate, ''1900-01-01'') AS FDXshDocDate,ISNULL(Sal.FCXsdQtyAll,0) AS FCXsdQtyAll,Bla.FCStkQty,'
		SET @tSql +=' ISNULL(FCXsdDisPmt,0) AS FCXsdDisPmt,ISNULL(FCXsdDTDis,0) AS FCXsdDTDis,ISNULL(FCXsdHDDis,0) AS FCXsdHDDis,'
		--SET @tSql +=' ISNULL(FCXsdNet,0) - ISNULL(FCXsdDTDis,0) AS FCSdtNetSale,'
		SET @tSql +=' ISNULL(Sal.FCXsdQtyAll,0) * ISNULL(FCPgdPriceRet,0) AS FCSdtNetSale,'
		SET @tSql +=' ISNULL(FCPgdPriceRet,0) AS FCPgdPriceRet,'
		--SET @tSql +=' ISNULL(FCXsdNet,0) - (ISNULL(FCXsdDTDis,0)+ISNULL(FCXsdDisPmt,0)+ISNULL(FCXsdHDDis,0)) AS FCSdtNetAmt'
		SET @tSql +=' ISNULL(Sal.FCXsdNetAfHD,0) AS FCSdtNetAmt'
		
		SET @tSql +=' FROM'
			SET @tSql +=' (SELECT StkBal.FTBchCode,BchL.FTBchName ,Pdt.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,SUM(ISNULL(StkBal.FCStkQty,0)) AS FCStkQty,'
			SET @tSql +=' PForPdt.FCPgdPriceRet'
			SET @tSql +=' FROM  TCNMPdt Pdt WITH (NOLOCK)'
			 --SET @tSql +=' FROM  TCNTPdtStkBal StkBal WITH (NOLOCK)'
			 SET @tSql +=' LEFT JOIN' 
			 --SET @tSql +=' TCNMPdt Pdt WITH (NOLOCK)  ON Pdt.FTPdtCode = StkBal.FTPdtCode'
			 SET @tSql +=' TCNTPdtStkBal StkBal WITH (NOLOCK) ON Pdt.FTPdtCode = StkBal.FTPdtCode'
			 SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK)  ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK)  ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdtGrp_L PgpL WITH(NOLOCK)  ON Pdt.FTPgpChain = PgpL.FTPgpChain AND PgpL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK)  ON StkBal.FTPdtCode = Ppz.FTPdtCode' --AND PdtBar.FTPunCode = Ppz.FTPunCode
			 --เพิ่ม BarCode
			 SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH (NOLOCK) ON Ppz.FTPdtCode = PdtBar.FTPdtCode AND Ppz.FTPunCode = PdtBar.FTPunCode'
			 SET @tSql +=' LEFT JOIN TCNMBranch_L BchL WITH(NOLOCK)  ON StkBal.FTBchCode = BchL.FTBchCode AND BchL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN'
			 --PRINT  @tSql
			 SET @tSql +=' ('
				SET @tSql +=' SELECT PForPdt.FTPdtCode,PForPdt.FTPunCode,MAX(FDPghDStop) AS FDPghDStop,AVG(FCPgdPriceRet) AS FCPgdPriceRet' 
				SET @tSql +=' FROM TCNTPdtPrice4PDT PForPdt WITH (NOLOCK)'
				SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH (NOLOCK) ON PForPdt.FTPdtCode = Ppz.FTPdtCode AND PForPdt.FTPunCode = Ppz.FTPunCode'
				SET @tSql +=' WHERE ISNULL(FTPplCode,'''') = '''' AND ISNULL(FCPdtUnitFact,0) =1'
				SET @tSql +=' GROUP BY PForPdt.FTPdtCode,PForPdt.FTPunCode'
			 SET @tSql +=' ) PForPdt ON  StkBal.FTPdtCode = PForPdt.FTPdtCode'
			 SET @tSql +=' WHERE (ISNULL(Ppz.FCPdtUnitFact,0) =1 OR ISNULL(Ppz.FCPdtUnitFact,0) = 0)'
		 
			 SET @tSql += @tSqlPdt
			 --Where 1 สินค้าเท่านั้น
			 SET @tSql +=' GROUP BY StkBal.FTBchCode,BchL.FTBchName,Pdt.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,PForPdt.FCPgdPriceRet'
			SET @tSql +=' ) Bla'
			--SET @tSql += @tSqlLast
			SET @tSql +=' LEFT JOIN'
			SET @tSql +=' (SELECT  DT.FTBchCode, DT.FTXshDocNo,  FDXshDocDate, DT.FTPdtCode, FTXsdBarCode,' 
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdQtyAll ELSE (FCXsdQtyAll) * - 1 END AS FCXsdQtyAll,'
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdNet ELSE (FCXsdNet) * - 1 END AS FCXsdNet,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDisPmt,0) ELSE  ISNULL(FCXsdDisPmt,0)*-1 END  AS FCXsdDisPmt,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDTDis,0) ELSE ISNULL(FCXsdDTDis,0)*-1 END  AS FCXsdDTDis,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdHDDis,0) ELSE ISNULL(FCXsdHDDis,0)*-1 END AS FCXsdHDDis,'
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdNetAfHD ELSE (FCXsdNetAfHD) * - 1 END AS FCXsdNetAfHD'
			  SET @tSql +=' FROM  TPSTSalDT DT WITH (NOLOCK)' 
	 				SET @tSql +=' LEFT JOIN TPSTSalHD HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo'
					SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH (NOLOCK)  ON Pdt.FTPdtCode = DT.FTPdtCode'
					SET @tSql +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode ' 
					SET @tSql +=' LEFT JOIN' 
					SET @tSql +=' (SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
					 SET @tSql +=' CASE FTXddDisChgType' 
					   SET @tSql +=' WHEN ''1'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''2'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''3'' THEN FCXddValue'
					   SET @tSql +=' WHEN ''4'' THEN FCXddValue'
					 SET @tSql +=' END AS FCXsdDisPmt'
					 SET @tSql +=' FROM TPSTSalDTDis DTDis  WITH (NOLOCK)'
					 SET @tSql +=' WHERE FNXddStaDis = 0'
					SET @tSql +=' ) DisPmt ON DT.FTBchCode = DisPmt.FTBchCode AND DT.FTXshDocNo = DisPmt.FTXshDocNo AND DT.FNXsdSeqNo = DisPmt.FNXsdSeqNo'

					SET @tSql +=' LEFT JOIN' 
					SET @tSql +=' (SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
					 SET @tSql +=' CASE FTXddDisChgType' 
					   SET @tSql +=' WHEN ''1'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''2'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''3'' THEN FCXddValue'
					   SET @tSql +=' WHEN ''4'' THEN FCXddValue'
					 SET @tSql +=' END AS FCXsdDTDis'
					 SET @tSql +=' FROM TPSTSalDTDis DTDis  WITH (NOLOCK)'
					 SET @tSql +=' WHERE FNXddStaDis = 1'
					SET @tSql +=' ) DTDis ON DT.FTBchCode = DTDis.FTBchCode AND DT.FTXshDocNo = DTDis.FTXshDocNo AND DT.FNXsdSeqNo = DTDis.FNXsdSeqNo'

					SET @tSql +=' LEFT JOIN' 
					SET @tSql +=' (SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
					 SET @tSql +=' CASE FTXddDisChgType' 
					   SET @tSql +=' WHEN ''1'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''2'' THEN FCXddValue *-1'
					   SET @tSql +=' WHEN ''3'' THEN FCXddValue'
					   SET @tSql +=' WHEN ''4'' THEN FCXddValue'
					 SET @tSql +=' END AS FCXsdHDDis'
					 SET @tSql +=' FROM TPSTSalDTDis DTDis  WITH (NOLOCK)'					 
					 SET @tSql +=' WHERE FNXddStaDis = 2'
					SET @tSql +=' ) HDDis ON DT.FTBchCode = HDDis.FTBchCode AND DT.FTXshDocNo = HDDis.FTXshDocNo AND DT.FNXsdSeqNo = HDDis.FNXsdSeqNo'
			  --SET @tSql +=' WHERE (FTXsdStaPdt <> ''4'')'
			  SET @tSql += @tSql1
			  -- Where Sale
			SET @tSql +=' ) Sal ON Bla.FTBchCode = Sal.FTBchCode AND Bla.FTPdtCode = Sal.FTPdtCode'
			--SET @tSql += ' WHERE ' + @tSqlLast
		SET @tSql +=' ) Pdt'
	SET @tSql +=' GROUP BY FTBchCode,FTBchName,FTXsdBarCode,FTPdtName ,FTPgpChainName,FTPbnName,ISNULL(FCStkQty,0),ISNULL(FCPgdPriceRet,0)'
	

	--SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH (NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	--PRINT @tSql
	EXECUTE(@tSql)

	--INSERT VD


	--RETURN SELECT * FROM TRPTSalDTTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO




/****** Object:  StoredProcedure [dbo].[SP_RPTxDailySaleByPdt_Animate]    Script Date: 05/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPackageCpnHisTmp]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPackageCpnHisTmp
GO
CREATE PROCEDURE [dbo].[SP_RPTxPackageCpnHisTmp]
	-- Add the parameters for the stored procedure here
	@tAgnCode VARCHAR(30),
	@tSessionID VARCHAR(150),
	@tLangID VARCHAR(1),
	@tBchCode VARCHAR(MAX),
	@tPosCode VARCHAR(20),
	@tDocDateF VARCHAR(10),
	@tDocDateT VARCHAR(10),
	@tCpnF VARCHAR(30),
	@tCpnT VARCHAR(30)

AS
BEGIN TRY

DELETE FROM TRPTPackageCpnHisTmp WHERE FTUsrSessID = @tSessionID

DECLARE @tSQL VARCHAR(MAX)
SET @tSQL = ''


DECLARE @tSQLFilter VARCHAR(MAX)
SET @tSQLFilter = ''

IF(@tBchCode <> '')
  BEGIN
     SET @tSQLFilter += ' AND HD.FTBchCode IN('+@tBchCode+') '
  END

IF(@tPosCode <> '')
  BEGIN
    SET @tSQLFilter += ' AND HD.FTPosCode = ''' + @tPosCode + ''' '
  END

IF(@tDocDateF <> '' AND @tDocDateT <> '')
  BEGIN
    SET @tSQLFilter += ' AND CONVERT(VARCHAR(10),HD.FDXshDocDate,121) BETWEEN '''+ @tDocDateF + ''' AND '''+ @tDocDateT +''' '
  END

IF(@tCpnF <> '' AND @tCpnT <> '')
  BEGIN
    SET @tSQLFilter += ' AND HIS.FTCpdBarCpn BETWEEN '''+@tCpnF+''' AND '''+@tCpnT+''' '
  END

        SET @tSQL += ' INSERT INTO TRPTPackageCpnHisTmp '
		SET @tSQL += ' SELECT '
		SET @tSQL += ' HIS.FTCpdBarCpn, '
		SET @tSQL += ' CPNL.FTCpnName, '
		SET @tSQL += ' POS.FTPosName, '
		SET @tSQL += ' HD.FTXshDocNo, '
		SET @tSQL += ' ''ตัดจ่าย/ขาย'' AS FTXshDocTypeName, '
		SET @tSQL += ' USR.FTUsrName, '
		SET @tSQL += ' HD.FDXshDocDate, '
		SET @tSQL += ' DIS.FCXhdAmt, '
		SET @tSQL += ' SumUsed.FCXhdAmt AS SAmount, '
		SET @tSQL += ' CPNUsed.FNCpdQtyUsed, '
		SET @tSQL += ' CPDT.FNCpdAlwMaxUse - CPNUsed.FNCpdQtyUsed AS FNCpdQtyLeft , '
		SET @tSQL += '''' + @tSessionID + ''''
	   
		SET @tSQL += ' FROM TPSTSalHD HD '
		SET @tSQL += ' INNER JOIN TFNTCouponDTHis HIS ON HD.FTXshDocNo = HIS.FTCpbFrmSalRef AND HIS.FTCpbStaBook = ''1'' '
		SET @tSQL += ' INNER JOIN TPSTSalHDDis DIS ON HD.FTBchCode = DIS.FTBchCode AND HD.FTXshDocNo = DIS.FTXshDocNo '
		SET @tSQL += ' AND HIS.FTCpdBarCpn = DIS.FTXhdRefCode AND DIS.FTXhdDisChgType = ''5'' '
		SET @tSQL += ' LEFT JOIN TFNTCouponHD_L CPNL ON HIS.FTCphDocNo = CPNL.FTCphDocNo AND CPNL.FNLngID =  ' + @tLangID
		SET @tSQL += ' LEFT JOIN TFNTCouponDT CPDT ON HIS.FTCphDocNo = CPDT.FTCphDocNo AND HIS.FTCpdBarCpn = CPDT.FTCpdBarCpn '
		SET @tSQL += ' LEFT JOIN TCNMPos_L POS ON HD.FTBchCode = POS.FTBchCode AND HD.FTPosCode = POS.FTPosCode AND POS.FNLngID =  ' + @tLangID
		SET @tSQL += ' LEFT JOIN TCNMUser_L USR ON  HD.FTUsrCode = USR.FTUsrCode AND POS.FNLngID =  ' + @tLangID
		SET @tSQL += ' INNER JOIN  ( '
		SET @tSQL += ' SELECT FTCphDocNo,FTCpdBarCpn, COUNT(FTCpdBarCpn) AS FNCpdQtyUsed '
		SET @tSQL += ' FROM TFNTCouponDTHis '
		SET @tSQL += ' WHERE FTCpbStaBook = ''1'' '
		SET @tSQL += ' GROUP BY FTCphDocNo,FTCpdBarCpn '
		SET @tSQL += ' ) CPNUsed '
		SET @tSQL += ' ON  HIS.FTCphDocNo = CPNUsed.FTCphDocNo AND HIS.FTCpdBarCpn = CPNUsed.FTCpdBarCpn '

		SET @tSQL += ' INNER JOIN ( '
		SET @tSQL += ' SELECT H.FTCphDocNo,H.FTCpdBarCpn,SUM(D.FCXhdAmt) AS FCXhdAmt '
		SET @tSQL += ' FROM TFNTCouponDTHis H '
		SET @tSQL += ' INNER JOIN TPSTSalHDDis D ON H.FTCpbFrmSalRef = D.FTXshDocNo AND H.FTCpdBarCpn = D.FTXhdRefCode AND D.FTXhdDisChgType = ''5'' '
		SET @tSQL += ' WHERE H.FTCpbStaBook = ''1'' '
		SET @tSQL += ' GROUP BY H.FTCphDocNo,H.FTCpdBarCpn '
		SET @tSQL += ' ) SumUsed ON HIS.FTCphDocNo = SumUsed.FTCphDocNo AND HIS.FTCpdBarCpn = SumUsed.FTCpdBarCpn '

		SET @tSQL += ' WHERE HD.FTXshStaDoc = ''1'' '
		SET @tSQL += @tSQLFilter


		--PRINT(@tSQL)
		EXEC(@tSQL)

   return 1
END TRY

BEGIN CATCH
   return -1
END CATCH
GO

IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxTopUp')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[SP_RPTxTopUp]
GO

CREATE PROCEDURE [dbo].[SP_RPTxTopUp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptName Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

  --สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),


  --กลุ่มธุรกิจ
	@ptMerL Varchar(8000), --กลุ่มธุรกิจ Condition IN
	@ptMerF Varchar(5),
	@ptMerT Varchar(5),

  --ร้านค้า
	@ptShpL Varchar(8000), --ร้านค้า Condition IN
	@ptShpF Varchar(5),
	@ptShpT Varchar(5),


	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),


	@ptCrdF Varchar(30),
	@ptCrdT Varchar(30),
	@ptUserIdF Varchar(30),
	@ptUserIdT Varchar(30),
	@ptCrdActF Varchar(1), --ʶҹкѵÍ
	@ptCrdActT Varchar(1),
	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 19/06/2019
-- Last Update : Napat(Jame) 17/10/2022 ไม่เอา checkout type 5
-- @pnLngID À҉ҍ
-- @tRptName ªר̓҂§ҹ
-- @tRptName ªר̓҂§ҹ
-- @pnCrdF ¨ҡºѵà
-- @pnCrdT ¶֧ˁ҂ŢºѵÍ
-- @ptUserIdF ¨ҡËъ¾¹ѡ§ҹ,
-- @ptUserIdT ¶֧Ëъ¾¹ѡ§ҹ,
 --@ptCrdActF Varchar(5), --»Ð7ºѵÍ
 --@ptCrdActT Varchar(5),
-- @ptDocDateF ¨ҡǑ¹·ը
-- @ptDocDateT ¶֧Ǒ¹·ը
-- @FNResult
--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptName Varchar(100)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSql2 VARCHAR(8000)
	DECLARE @tCrdF Varchar(30)
	DECLARE @tCrdT Varchar(30)
	DECLARE @tUserIdF Varchar(30)
	DECLARE @tUserIdT Varchar(30)
	DECLARE @tCrdActF Varchar(1) --»Ð7ºѵÍ
	DECLARE @tCrdActT Varchar(1)
	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)

	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'TopUp'
	--SET @tCrdF = '2019030500'
	--SET @tCrdT = '2019030600'
	--SET @tUserIdF = '2019030551'
	--SET @tUserIdT = '2019030800'
	--SET @tCrdActF = '1'
	--SET @tCrdActT = '3'
	--SET @tDocDateF = '2019-01-01'
	--SET @tDocDateT = '2019-06-30'

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tRptName = @ptRptName
	SET @tCrdF = @ptCrdF
	SET @tCrdT = @ptCrdT
	SET @tUserIdF =  @ptUserIdF
	SET @tUserIdT =  @ptUserIdT
	SET @tCrdActF = @ptCrdActF
	SET @tCrdActT = @ptCrdActT
	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult= 0
	SET @tDocDateF = CONVERT(VARCHAR(10),@tDocDateF,121)
	SET @tDocDateT = CONVERT(VARCHAR(10),@tDocDateT,121)

	IF @nLngID = null
	BEGIN
		SET @nLngID = 1
	END	
	--Set ¤蒣˩ Paraleter ¡óՠT ໧¹¤蒇蒧˃׍ null
	IF @tCrdF = null
	BEGIN
		SET @tCrdF = ''
	END 

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tCrdT = null OR @tCrdT =''
	BEGIN
		SET @tCrdT = @tCrdF
	END 

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	if @tCrdActF = null 
	BEGIN
		SET @tCrdActF = ''
	END
	IF @tCrdActT = null or @tCrdActF = ''
	BEGIN 
		SET @tCrdActT = @tCrdActF
	END 

	IF @tUserIdF = null
	BEGIN
		SET @tUserIdF = ''
	END

	IF @tUserIdT = null OR @tUserIdT = ''
	BEGIN
		SET @tUserIdT = @tUserIdF
	END

SET @tSql1 = ''

	IF @pnFilterType = '1'
	BEGIN
		IF (@ptBchF <> '' AND @ptBchT <> '')
		BEGIN
			SET @tSql1 +=' AND CT.FTBchCode BETWEEN ''' + @ptBchF + ''' AND ''' + @ptBchT + ''''
		END

		IF (@ptMerF <> '' AND @ptMerT <> '')
		BEGIN
			SET @tSql1 +=' AND SHP.FTMerCode BETWEEN ''' + @ptMerF + ''' AND ''' + @ptMerT + ''''
		END

		IF (@ptShpF <> '' AND @ptShpT <> '')
		BEGIN
			SET @tSql1 +=' AND CT.FTShpCode BETWEEN ''' + @ptShpF + ''' AND ''' + @ptShpT + ''''
		END

		IF (@ptPosF <> '' AND @ptPosT <> '')
		BEGIN
			SET @tSql1 +=' AND CT.FTTxnPosCode BETWEEN ''' + @ptPosF + ''' AND ''' + @ptPosT + ''''
		END

	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSql1 +=' AND CT.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '')
		BEGIN
			SET @tSql1 += ' AND SHP.FTMerCode IN (' + @ptMerL + ')'
		END	

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 += ' AND CT.FTPosCode IN (' + @ptShpL + ')'
		END	

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND CT.FTTxnPosCode IN (' + @ptPosL + ')'
		END	
		--IF (@ptPosL <> '')
		--BEGIN
		--	SET @tSql1 += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
		--END		
	END


	DELETE FROM TFCTRptCrdTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptName = '' + @tRptName + '' --ź¢鍁م Temp ¢ͧःרͧ·ը¨кѹ·֡¢́مŧ Temp
	SET @tSQL = 'INSERT INTO TFCTRptCrdTmp' 
	SET @tSQL +='('
	SET @tSQL +='FTComName,FTRptName,FTTxnPosCode,FDTxnDocDate,FTTxnDocType,FTTxnDocNoRef,FTCrdCode,FDCrdExpireDate,FTCdtRmk,FTCrdName,'
	SET @tSQL +='FTCrdStaActive,FTCrdHolderID,FTUsrName,FCTxnCrdValue,FCTxnValue,FCTxnValAftTrans,FTCtyName,FTDptName'
	SET @tSQL +=')'
	SET @tSQL +=' SELECT '''+ @nComName + '''  AS FTComName, '''+ @tRptName +'''AS FTRptName,'
	SET @tSQL +='FTTxnPosCode,FDTxnDocDate,FTTxnDocType,FTTxnDocNoRef,FTCrdCode,FDCrdExpireDate,FTCdtRmk,FTCrdName,'
	SET @tSQL +='FTCrdStaActive,FTCrdHolderID,FTUsrName,FCTxnCrdValue,FCTxnValue,FCTxnValAftTrans,FTCtyName,FTDptName'
	SET @tSQL +=' FROM'
		SET @tSQL +=' ('
		 SET @tSQL +=' SELECT A.FTTxnPosCode,A.FDTxnDocDate,A.FTTxnDocType,A.FTTxnDocNoRef,A.FTCrdCode,CRDX.FDCrdExpireDate,A.FTCdtRmk,CRDL.FTCrdName,'
		 SET @tSQL +=' CTYL.FTCtyName,DPL.FTDptName,CRD.FTCrdStaActive, CRD.FTCrdHolderID,USRL.FTUsrName,A.FCTxnCrdValue,A.FCTxnValue,'
		 --SET @tSQL +=' A.FCTxnCrdValue + A.FCTxnValue AS FCTxnValAftTrans'
		 SET @tSQL +=' CASE
						WHEN A.FTTxnDocType IN (''1'',''4'',''9'') THEN A.FCTxnCrdValue + A.FCTxnValue 
						WHEN A.FTTxnDocType IN (''2'',''3'',''5'',''8'',''10'') THEN A.FCTxnCrdValue - A.FCTxnValue
						ELSE 0
					  END AS FCTxnValAftTrans '
		 SET @tSQL +=' FROM'
			SET @tSQL +=' ('
 			-- SET @tSQL +=' SELECT ISNULL(CT.FTTxnPosCode, ''N/A'') AS FTTxnPosCode, CT.FDTxnDocDate, CT.FTCrdCode, CT.FCTxnValue, '''' AS FTCdtRmk, CT.FTTxnDocType, CT.FTTxnDocNoRef, CT.FCTxnCrdValue'
			 --SET @tSQL +=' FROM dbo.TFNTCrdHis AS CT WITH (NOLOCK) '
    --   SET @tSQL += ' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
			 --SET @tSQL += ' WHERE 1=1'
    --   SET @tSQL += @tSql1
			 --IF (@tCrdF <> '' AND @tCrdT <> '')
			 --BEGIN
			 --	SET @tSQL +=' AND FTCrdCode BETWEEN ''' + @tCrdF + ''' AND ''' + @tCrdT + ''''
			 --END
 
 			-- IF (@tDocDateF <> '' AND @tDocDateT <> '')
 			-- BEGIN
			 --	SET @tSQL +=' AND CONVERT(VARCHAR(10),FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			 --END

			 /* Napat(Jame) 17/10/2022 ไม่เอา checkout type 5 จาก TFNTCrdSale */
			 --SET @tSQL +=' SELECT 
				--				CT.FTTxnPosCode, 
				--				CT.FDTxnDocDate, 
				--				CT.FTCrdCode, 
				--				CT.FCTxnValue, 
				--				'''' AS FTCdtRmk, 
				--				CT.FTTxnDocType, 
				--				CT.FTTxnDocNoRef, 
				--				CT.FCTxnCrdValue,
				--				CTHD.FTCreateBy
				--		   FROM TFNTCrdSale CT WITH(NOLOCK)
				--		   LEFT JOIN TFNTCrdTopUpHD CTHD WITH(NOLOCK) ON CT.FTTxnDocNoRef = CTHD.FTXshDocNo 
				--		   WHERE 1=1 AND ISNULL(CTHD.FTCreateBy,'''') <> '''' '
			 --SET @tSQL += @tSql1
			 --IF (@tCrdF <> '' AND @tCrdT <> '')
			 --BEGIN
				-- SET @tSQL +=' AND CT.FTCrdCode BETWEEN ''' + @tCrdF + ''' AND ''' + @tCrdT + ''''
			 --END

			 --IF (@tDocDateF <> '' AND @tDocDateT <> '')
			 --BEGIN
				-- SET @tSQL +=' AND CONVERT(VARCHAR(10),CT.FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			 --END
			 --SET @tSQL +=' UNION ALL'

			 SET @tSQL +=' SELECT CT.FTTxnPosCode,CT.FDTxnDocDate,CT.FTCrdCode,CT.FCTxnValue,'''' AS FTCdtRmk, CT.FTTxnDocType,' 
			 SET @tSQL +=' CT.FTTxnDocNoRef, CT.FCTxnCrdValue,'
			 SET @tSQL +=' CASE
							WHEN ISNULL(CTHD.FTCreateBy,'''') <> '''' THEN CTHD.FTCreateBy
							WHEN ISNULL(CSHD.FTCreateBy,'''') <> '''' THEN CSHD.FTCreateBy
						   END AS FTCreateBy '
			 SET @tSQL +=' FROM TFNTCrdTopUp CT WITH (NOLOCK) '
			 SET @tSQL +=' LEFT JOIN TFNTCrdTopUpHD CTHD WITH(NOLOCK) ON CT.FTTxnDocNoRef = CTHD.FTXshDocNo '
			 SET @tSQL +=' LEFT JOIN TFNTCrdShiftHD CSHD WITH(NOLOCK) ON CT.FTTxnDocNoRef = CSHD.FTXshDocNo '
			 SET @tSQL +=' LEFT JOIN TCNMShop AS SHP WITH (NOLOCK) ON CT.FTShpCode = SHP.FTShpCode AND CT.FTBchCode = SHP.FTBchCode'
			 /* Napat(Jame) 17/10/2022 ไม่เอา checkout type 5 */
			 SET @tSQL +=' WHERE CT.FTTxnDocType <> ''5'' AND ( ISNULL(CTHD.FTCreateBy,'''') <> '''' OR ISNULL(CSHD.FTCreateBy,'''') <> '''' )'
			 SET @tSQL += @tSql1
			 IF (@tCrdF <> '' AND @tCrdT <> '')
			 BEGIN
				 SET @tSQL +=' AND CT.FTCrdCode BETWEEN ''' + @tCrdF + ''' AND ''' + @tCrdT + ''''
			 END

			 IF (@tDocDateF <> '' AND @tDocDateT <> '')
			 BEGIN
				 SET @tSQL +=' AND CONVERT(VARCHAR(10),CT.FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
			 END

			SET @tSQL +=' ) AS A LEFT OUTER JOIN'
		 SET @tSQL +=' dbo.TFNTCrdTopUpHD AS TOPHD WITH (NOLOCK) ON A.FTTxnDocNoRef = TOPHD.FTXshDocNo LEFT OUTER JOIN'
		 SET @tSQL +=' dbo.TFNMCard AS CRD WITH (NOLOCK) ON A.FTCrdCode = CRD.FTCrdCode LEFT OUTER JOIN'
		 SET @tSQL +=' dbo.TFNMCard_L AS CRDL WITH (NOLOCK) ON CRD.FTCrdCode = CRDL.FTCrdCode AND CRDL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT OUTER JOIN'
		 SET @tSQL +=' dbo.TFNMCardType_L AS CTYL WITH (NOLOCK) ON CRD.FTCtyCode = CTYL.FTCtyCode AND CTYL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT OUTER JOIN'
		 SET @tSQL +=' dbo.TCNMUsrDepart_L AS DPL WITH (NOLOCK) ON CRD.FTDptCode = DPL.FTDptCode AND DPL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		 SET @tSQL +=' LEFT OUTER JOIN dbo.TCNMUser_L AS USRL WITH (NOLOCK) ON A.FTCreateBy = USRL.FTUsrCode  AND USRL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
		 SET @tSQL +=' LEFT OUTER JOIN ' 
		 SET @tSQL +=' dbo.TFNMCard AS CRDX WITH (NOLOCK) ON A.FTCrdCode = CRDX.FTCrdCode'
		 SET @tSQL +=' WHERE (A.FTTxnDocType IN (''1'',''3'',''4'',''5''))'
		SET @tSQL +=' ) TopUp'
		SET @tSql += ' WHERE 1=1'
		IF (@tCrdF <> '' AND @tCrdT <> '')
		BEGIN
			SET @tSQL +=' AND FTCrdCode BETWEEN ''' + @tCrdF + ''' AND ''' + @tCrdT + ''''
		END

		IF (@tDocDateF <> '' AND @tDocDateT <> '')
		BEGIN
			SET @tSQL +=' AND CONVERT(VARCHAR(10),FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		END
		IF @tUserIdF <> '' AND @tUserIdT <> ''
		BEGIN
			SET @tSQL += ' AND FTCrdHolderID BETWEEN ''' + @tUserIdF + ''' AND ''' + @tUserIdT +''''
		END

		IF @tCrdActF <> '' AND @tCrdActT <> ''
		BEGIN
			SET  @tSQL += ' AND FTCrdStaActive BETWEEN '''+ @tCrdActF +''' AND '''+ @tCrdActT +''''
		END  
	--PRINT @tSQL
	execute(@tSQL)
	
	RETURN SELECT * FROM TFCTRptCrdTmp WHERE FTComName = ''+ @nComName + '' AND FTRptName = ''+ @tRptName +''
	
END TRY

BEGIN CATCH 
 SET @FNResult= -1
END CATCH
GO