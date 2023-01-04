


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
														SET @tSQLMaster += ' AND PDLSPC.FTBchCode IN ('+@tSesBchCodeMulti+')  '
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



IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_SETnResetExpired')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_SETnResetExpired
GO
CREATE PROCEDURE [dbo].[STP_SETnResetExpired] 
	@ptBchCode VARCHAR(5) NUll,
	@ptCrdCode VARCHAR(20)  NUll,
	@ptPosCode VARCHAR(5)  NUll,
	@pcCrdValue NUMERIC(18,4) NULL,
	@ptDocNoRef VARCHAR(20) NUll
   ,@FNResult INT OUT 
AS
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
05.01.00	19/11/2020		Em		create  
05.02.00	17/10/2022		Zen		Update Fifo
----------------------------------------------------------------------*/
DECLARE @tTrans varchar(20)
SET @tTrans = 'CardChkOut'  
BEGIN TRY  
	BEGIN TRANSACTION @tTrans

	INSERT INTO TFNTCrdTopUp WITH(ROWLOCK)
	(
		FTBchCode,FTTxnDocType,FTCrdCode
		,FDTxnDocDate,FCTxnValue,FTTxnStaPrc
		,FTTxnPosCode,FCTxnCrdValue,FTTxnDocNoRef
	)
	VALUES
	(
		@ptBchCode ,'10',@ptCrdCode 
		,GETDATE(),@pcCrdValue,'1'
		,@ptPosCode,@pcCrdValue,@ptDocNoRef
	)

	-- Update Master Card
	UPDATE TFNMCardBal WITH (ROWLOCK) SET
	FCCrdValue= 0
	WHERE FTCrdCode=@ptCrdCode

	DELETE TFNTCrdTopUpFifo WHERE FTCrdCode = @ptCrdCode

    COMMIT TRANSACTION @tTrans 
END TRY 
BEGIN CATCH 
	ROLLBACK TRANSACTION @tTrans 
	SELECT ERROR_MESSAGE()
END CATCH

GO



IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCxAutoDeployCreate')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_PRCxAutoDeployCreate
GO
CREATE PROCEDURE [dbo].[STP_PRCxAutoDeployCreate]
 @ptXdhDocNo VARCHAR(10)
,@pnResult INT OUTPUT
,@ptMessage VARCHAR(255) OUTPUT 
AS
DECLARE @tTrans VARCHAR(10)

/*---------------------------------------------------------------------
Document History
Version			Date			User	Remark
05.01.00		10/02/2022		Zen		Create
05.02.00		25/02/2022		Zen		แก้เรื่องเงื่อนไข
----------------------------------------------------------------------*/

SET @tTrans = 'AutoDeploy'
BEGIN TRY
	BEGIN TRANSACTION @tTrans  
	TRUNCATE TABLE TCNTAppDepHisTmp
	--DECLARE @ptXdhDocNos VARCHAR(20)
	--SET @ptXdhDocNos = '22Feb07531'
	--INSERT INTO TCNTAppDepHis
	INSERT INTO TCNTAppDepHisTmp
	SELECT Bch.FTAgnCode,Bch.FTBchCode,'' AS FTMerCode,'' AS FTShopCode,Pos.FTPosCode,'' AS FTAppCode,
	   AppHD.FTXdhDocNo,
	   NULL AS FDXdsDUpgrade,NULL AS FTXdsStaPrc,NULL AS FTXdsStaDoc,
	   GETDATE(),'MQProcessTool',GETDATE(),'MQProcessTool'
	FROM TCNTAppDepHD AppHD WITH(NOLOCK) ,TCNMBranch Bch WITH(NOLOCK) 
	INNER JOIN TCNMPos Pos WITH(NOLOCK)  ON Pos.FTBchCode = Bch.FTBchCode 
	WHERE AppHD.FTXdhDocNo = @ptXdhDocNo
	AND AppHD.FTXdhStaDoc = 1 
	AND AppHD.FTXdhStaDep = 1 
	AND AppHD.FTXdhStaPreDep = 1

	DELETE HisTmp
	FROM TCNTAppDepHisTmp HisTmp 
	INNER JOIN TCNTAppDepHDBch HDBch 
	ON HisTmp.FTXdhDocNo = HDBch.FTXdhDocNo
	AND HisTmp.FTAgnCode = HDBch.FTXdhAgnTo
	AND HisTmp.FTBchCode = HDBch.FTXdhBchTo
	AND HisTmp.FTPosCode = HDBch.FTXdhPosTo
	AND HDBch.FTXdhStaType = '2'

	IF EXISTS (SELECT FTXdhDocNo FROM TCNTAppDepHDBch WHERE FTXdhDocNo = @ptXdhDocNo AND FTXdhStaType = '1') 
	BEGIN
	    INSERT INTO TCNTAppDepHis
		SELECT HisTmp.* FROM TCNTAppDepHisTmp HisTmp
		INNER JOIN TCNTAppDepHDBch HDBch 
		ON HisTmp.FTXdhDocNo =  HDBch.FTXdhDocNo
		AND ((ISNULL(HisTmp.FTAgnCode,'') = ISNULL(HDBch.FTXdhAgnTo,'')) OR (ISNULL(HDBch.FTXdhAgnTo,'') = ''))
		AND ((ISNULL(HisTmp.FTBchCode,'') = ISNULL(HDBch.FTXdhBchTo,'')) OR (ISNULL(HDBch.FTXdhBchTo,'') = ''))
		AND ((ISNULL(HisTmp.FTPosCode,'') = ISNULL(HDBch.FTXdhPosTo,'')) OR (ISNULL(HDBch.FTXdhPosTo,'') = ''))	
		AND HDBch.FTXdhStaType = '1'
	END
	ELSE
	BEGIN
		INSERT INTO TCNTAppDepHis
		SELECT HisTmp.* FROM TCNTAppDepHisTmp HisTmp
	END
	

	COMMIT TRANSACTION @tTrans  
	SET @pnResult= 1
	SET @ptMessage = 'Success'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans  
    SET @pnResult= -1
	SET @ptMessage = (SELECT 'Error : ' + ISNULL(ERROR_MESSAGE(),''))
END CATCH
GO



/******************************************** Upgrade Table **************************************************/
/******************************************** Upgrade Table **************************************************/





/******************************************** Upgrade Data **************************************************/
/******************************************** Upgrade Data **************************************************/




/******************************************** Upgrade Stored Procedure **************************************************/
IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCnTopupList')and OBJECTPROPERTY(id, N'IsProcedure') = 1) BEGIN
	DROP PROCEDURE [dbo].STP_PRCnTopupList
END
GO
CREATE PROCEDURE [dbo].[STP_PRCnTopupList] 
	@ptBchCode VARCHAR(5) NUll,
	@ptCrdCode VARCHAR(20) NUll,
	@pcTxnValue  NUMERIC(18,4) NULL,
	@pcTxnValuePmt  NUMERIC(18,4) NULL,
	@pcTxnConditionPmt NUMERIC(18,4) NULL, 
	@pcTxnNoRfn NUMERIC(18,4) NULL, -- 05.02.00 --
	@ptTxnPosCode VARCHAR(5) NUll,
	@pcCrdValue NUMERIC(18,4) NULL,
	@ptShpCode  VARCHAR(5) NUll,
	@ptUsrCode VARCHAR(20) NUll,
	@ptDocNoRef VARCHAR(30) NUll,
	@ptDocPmtRef VARCHAR(30) NULL
AS
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
05.01.00	10/11/2020		Em		create 
05.02.00	14/12/2020		Net		เพิ่ม Para ยอดห้ามคืน  
05.03.00    04/01/2020		Zen		เพิ่ม Parameter ยอดเติมเงินที่ได้เงื่อนไข
05.04.00    01/10/2022		Net		เพิ่ม Insert ยอดห้ามคืน CrdTopUpFifo
----------------------------------------------------------------------*/
DECLARE @tTrans varchar(20)
DECLARE @nCount int
SET @tTrans = 'Topup'
BEGIN TRY
	BEGIN TRANSACTION @tTrans
	INSERT INTO TFNTCrdTopUp WITH(ROWLOCK) 
    ( 
		FTBchCode,FTTxnDocType,FTCrdCode 
		,FDTxnDocDate,FCTxnValue 
		,FTTxnStaPrc,FTTxnPosCode,FCTxnCrdValue,FCTxnPmt
		,FTShpCode ,FTTxnDocNoRef ,FTUsrCode
		,FCTxnNoRfn -- 05.02.00 --
    ) 
    VALUES 
    ( 
		@ptBchCode,'1',@ptCrdCode 
		,GETDATE(),@pcTxnValue 
		,'1',@ptTxnPosCode,@pcCrdValue,ISNULL(@pcTxnValuePmt,0)
		,@ptShpCode,@ptDocNoRef,@ptUsrCode     
		,@pcTxnNoRfn -- 05.02.00 --
    ) 

	IF NOT EXISTS(SELECT FTCrdCode FROM TFNMCardBal WITH(NOLOCK) WHERE FTCrdCode = @ptCrdCode)
	BEGIN
		INSERT INTO TFNMCardBal(FTCrdCode,FTCrdTxnCode,FCCrdValue,FDLastUpdOn)
		SELECT @ptCrdCode,FTCrdTxnCode,0,GETDATE() FROM TFNSCrdBalType
	END 
    -- Update Master Card
    UPDATE TFNMCard WITH (ROWLOCK) 
	SET FDCrdResetDate = GETDATE() 
		,FDLastUpdOn = GETDATE()  
    WHERE FTCrdCode=@ptCrdCode

	UPDATE TFNMCardBal
	SET FCCrdValue = (ISNULL(FCCrdValue,0) + @pcTxnValue)
	WHERE FTCrdCode = @ptCrdCode 
	AND FTCrdTxnCode = '001'

	UPDATE TFNMCardBal
	SET FCCrdValue = ISNULL(CTP.FCCtyDeposit,0)
	FROM TFNMCardBal BAL
	INNER JOIN TFNMCard CRD WITH(NOLOCK) ON CRD.FTCrdCode = BAL.FTCrdCode
	INNER JOIN TFNMCardType CTP WITH(NOLOCK) ON CTP.FTCtyCode = CRD.FTCtyCode
	WHERE BAL.FTCrdCode = @ptCrdCode 
	AND BAL.FTCrdTxnCode = '003'

	IF ISNULL(@pcTxnValuePmt,0) > 0
	BEGIN
		UPDATE TFNMCardBal
		SET FCCrdValue = (ISNULL(FCCrdValue,0) + ISNULL(@pcTxnValuePmt,0))
		WHERE FTCrdCode = @ptCrdCode 
		AND FTCrdTxnCode = '002'

		INSERT INTO TFNTCrdTopUpFifo WITH(ROWLOCK) 
		(
			FTCrdCode ,FDDateTime ,FCPmcAmtPay,
			FCPmcAmtGet ,FCPmcAmtNot ,
			FCPmcNoRfnPay,FCPmcNoRfnGet,
			FCPmcAmtPayAvb ,FCPmcAmtGetAvb ,FCPmcAmtNotAvb,
			FDLastUpdOn ,FTLastUpdBy,FDCreateOn ,FTCreateBy
		)
		 SELECT @ptCrdCode,GETDATE(),@pcTxnConditionPmt,
		 @pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 CASE WHEN PmtHD.FTPmhStaAlwRetMnyPay = '2' THEN @pcTxnConditionPmt ELSE 0 END,
		 CASE WHEN PmtHD.FTPmhStaAlwRetMnyGet = '2' THEN @pcTxnValuePmt ELSE 0 END,
		 @pcTxnConditionPmt,@pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 GETDATE(),@ptUsrCode,GETDATE(),@ptUsrCode
		 FROM TFNTCrdPmtHD PmtHD
		 WHERE FTPmhDocNo = @ptDocPmtRef
		
	END
	ELSE
	BEGIN
		INSERT INTO TFNTCrdTopUpFifo WITH(ROWLOCK) 
		(
			FTCrdCode ,FDDateTime ,FCPmcAmtPay,
			FCPmcAmtGet ,FCPmcAmtNot ,
			FCPmcNoRfnPay,FCPmcNoRfnGet,
			FCPmcAmtPayAvb ,FCPmcAmtGetAvb ,FCPmcAmtNotAvb,
			FDLastUpdOn ,FTLastUpdBy,FDCreateOn ,FTCreateBy
		)VALUES (
		 @ptCrdCode,GETDATE(),@pcTxnConditionPmt,
		 @pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 --0,
		 @pcTxnNoRfn, -- 05.04.00 --
		 0,
		 @pcTxnConditionPmt,@pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 GETDATE(),@ptUsrCode,GETDATE(),@ptUsrCode )
	END

	 -- 05.02.00 --
	IF ISNULL(@pcTxnNoRfn,0) > 0
	BEGIN
		UPDATE TFNMCardBal
		SET FCCrdValue = (ISNULL(FCCrdValue,0) + ISNULL(@pcTxnNoRfn,0))
		WHERE FTCrdCode = @ptCrdCode 
		AND FTCrdTxnCode = '005'
	END
	 -- 05.02.00 --
    
	
	COMMIT TRANSACTION @tTrans 

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans 
END CATCH
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCnResetCardExpired') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE dbo.STP_PRCnResetCardExpired
GO
CREATE PROCEDURE [dbo].[STP_PRCnResetCardExpired]
    @ptCrdCode VARCHAR(30) NULL
	, @FNResult INT OUTPUT AS
/*---------------------------------------------------------------------
Document History
Date			User		Remark
1.28/09/2022	Net			Create  
----------------------------------------------------------------------*/
BEGIN TRY
    
    
    UPDATE CRD
    SET FDCrdExpireDate = 
        CASE WHEN ISNULL(FNCtyExpirePeriod, 0) = 0 THEN '9999-12-31'
            ELSE CASE WHEN ISNULL(FTCtyExpiredType, '') = '2' --ตามรอบเวลา
                THEN CASE ISNULL(FNCtyExpiredType, 2)
                        WHEN 1 THEN DATEADD(HOUR, ISNULL(FNCtyExpirePeriod, 1), GETDATE())
                        WHEN 2 THEN DATEADD(DAY, ISNULL(FNCtyExpirePeriod, 1), GETDATE())
                        WHEN 3 THEN DATEADD(MONTH, ISNULL(FNCtyExpirePeriod, 1), GETDATE())
                        WHEN 4 THEN DATEADD(YEAR, ISNULL(FNCtyExpirePeriod, 1), GETDATE())
                        ELSE DATEADD(DAY, ISNULL(FNCtyExpirePeriod, 1), GETDATE())
                        END
                ELSE CASE ISNULL(FNCtyExpiredType, 2) -- ตามรอบปฏิทิน
                        WHEN 1 THEN CONVERT(VARCHAR(14), DATEADD(HOUR, ISNULL(FNCtyExpirePeriod, 1)-1, GETDATE()), 121) + '59:59'
                        WHEN 2 THEN CONVERT(VARCHAR(10), DATEADD(DAY, ISNULL(FNCtyExpirePeriod, 1)-1, GETDATE()), 121) + ' 23:59:59'
                        WHEN 3 THEN CONVERT(VARCHAR(10), EOMONTH(DATEADD(MONTH, ISNULL(FNCtyExpirePeriod, 1)-1, GETDATE())), 121) + ' 23:59:59'
                        WHEN 4 THEN CONVERT(VARCHAR(4), DATEADD(YEAR, ISNULL(FNCtyExpirePeriod, 1)-1, GETDATE()), 121) + '-12-31 23:59:59'
                        ELSE CONVERT(VARCHAR(10), DATEADD(DAY, ISNULL(FNCtyExpirePeriod, 1)-1, GETDATE()), 121) + ' 23:59:59'
                        END
            END
        END
    FROM TFNMCard CRD WITH(NOLOCK) 
    INNER JOIN TFNMCardType CTY WITH(NOLOCK) ON 
        CRD.FTCtyCode = CTY.FTCtyCode 
    WHERE CRD.FTCrdStaActive = '1'
        AND CRD.FTCrdCode = @ptCrdCode

    SELECT ''
	SET @FNResult= 0
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE()
	SET @FNResult= -1
END CATCH
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_GEToCardInfoReturn')
AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
 DROP PROCEDURE dbo.STP_GEToCardInfoReturn
END
GO

CREATE PROCEDURE [dbo].[STP_GEToCardInfoReturn] 
 @ptCrdCode VARCHAR(30) NULL,
 @pnLngID INT NULL
AS
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
05.01.00	30/09/2022		Net     Create
----------------------------------------------------------------------*/
BEGIN TRY
		SELECT 			
		M.FTCrdCode 
		,L.FTCrdName
		,TFNMCardType_L.FTCtyName
		,M.FDCrdExpireDate AS FDCrdExpireDate
		,M.FDCrdResetDate AS FDCrdResetDate
		,ISNULL(T.FCCtyTopUpAuto,0.00) AS FCCtyTopUpAuto
		,T.FNCtyExpiredType
		,T.FNCtyExpirePeriod
		,ISNULL(L.FNLngID,1) AS FNLngID
		,M.FTCrdStaShift
		,M.FTCrdHolderID
		,M.FTCrdStaActive
		,T.FCCtyDeposit
		,ISNULL(T.FTCtyStaAlwRet,0) AS FTCtyStaAlwRet	
		,[dbo].[F_GETnCardAmount](@ptCrdCode) AS FCCardAmt --มูลค่าที่ใช้ได้
		,[dbo].[F_GETnCardTotal](@ptCrdCode) AS FCCardTotal --ยอดคงเหลือ	
		,T.FTCtyStaPay
		,T.FTCtyStaShift	 
		,T.FTCtyCode
		,ISNULL(T.FCCtyCreditLimit,0) AS FCCtyCreditLimit		-- 05.03.00 --
		,ISNULL([dbo].[F_GETnCardCheckout](@ptCrdCode),0) As FCCrdCheckout -- 05.04.00 --
        ,ISNULL(M.FTAgnCode,'') AS FTAgnCode -- 05.07.00 --
		FROM TFNMCard M WITH (NOLOCK)
		LEFT JOIN TFNMCard_L L WITH (NOLOCK) ON M.FTCrdCode = L.FTCrdCode 
		AND L.FNLngID = @pnLngID  -- 05.05.00 --
		LEFT JOIN TFNMCardType  T WITH (NOLOCK) ON M.FTCtyCode= T.FTCtyCode
		LEFT JOIN TFNMCardType_L WITH (NOLOCK) ON T.FTCtyCode= TFNMCardType_L.FTCtyCode  AND L.FNLngID = TFNMCardType_L.FNLngID
		WHERE M.FTCrdCode=@ptCrdCode

		IF NOT EXISTS(SELECT FTCrdCode FROM TFNMCardBal WITH(NOLOCK) WHERE FTCrdCode = @ptCrdCode)
		BEGIN
			INSERT INTO TFNMCardBal(FTCrdCode,FTCrdTxnCode,FCCrdValue,FDLastUpdOn)
			SELECT @ptCrdCode,FTCrdTxnCode,0,GETDATE() FROM TFNSCrdBalType
		END 

		SELECT ROW_NUMBER() OVER (ORDER BY BAL.FTCrdTxnCode) AS FNTxnSeq,CBT.FTCrdName,BAL.FCCrdValue,BAL.FTCrdTxnCode
		FROM TFNMCardBal BAL WITH(NOLOCK)
		LEFT JOIN TFNSCrdBalType_L CBT WITH(NOLOCK) ON CBT.FTCrdTxnCode = BAL.FTCrdTxnCode AND CBT.FNLngID = @pnLngID
		WHERE BAL.FTCrdCode = @ptCrdCode

END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_GEToCardInfo')
AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
 DROP PROCEDURE dbo.STP_GEToCardInfo
END
GO

CREATE PROCEDURE [dbo].[STP_GEToCardInfo] 
 @ptCrdCode VARCHAR(30) NULL,
 @pnLngID INT NULL
AS
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
05.01.00	11/11/2020		Em		create 
05.03.00	14/12/2020		Em		เพิ่ม GET FCCtyCreditLimit
05.04.00	10/03/2021		Zen		เพิ่ม Get Checkout
05.05.00	02/04/2021		Zen		ย้าน Where ภาษา จาก Where หลักเป็น Where ใน Left Join
05.06.00	09/04/2021		Zen		เพิ่ม FTCrdStaActive เช็คการเคลื่อนไหวบัตรกดเงินสด
05.07.00	15/08/2021		Net		เพิ่ม FTAgnCode รองรับบัตรตามตัวแทนขาย
----------------------------------------------------------------------*/
BEGIN TRY
		SELECT 			
		M.FTCrdCode 
		,L.FTCrdName
		,TFNMCardType_L.FTCtyName
		,M.FDCrdExpireDate AS FDCrdExpireDate
		,M.FDCrdResetDate AS FDCrdResetDate
		,ISNULL(T.FCCtyTopUpAuto,0.00) AS FCCtyTopUpAuto
		,T.FNCtyExpiredType
		,T.FNCtyExpirePeriod
		,ISNULL(L.FNLngID,1) AS FNLngID
		,M.FTCrdStaShift
		,M.FTCrdHolderID
		,M.FTCrdStaActive
		,T.FCCtyDeposit
		,ISNULL(T.FTCtyStaAlwRet,0) AS FTCtyStaAlwRet	
		,[dbo].[F_GETnCardAmount](@ptCrdCode) AS FCCardAmt --มูลค่าที่ใช้ได้
		,[dbo].[F_GETnCardTotal](@ptCrdCode) AS FCCardTotal --ยอดคงเหลือ	
		,T.FTCtyStaPay
		,T.FTCtyStaShift	 
		,T.FTCtyCode
		,ISNULL(T.FCCtyCreditLimit,0) AS FCCtyCreditLimit		-- 05.03.00 --
		,ISNULL([dbo].[F_GETnCardCheckout](@ptCrdCode),0) As FCCrdCheckout -- 05.04.00 --
        ,ISNULL(M.FTAgnCode,'') AS FTAgnCode -- 05.07.00 --
		FROM TFNMCard M WITH (NOLOCK)
		LEFT JOIN TFNMCard_L L WITH (NOLOCK) ON M.FTCrdCode = L.FTCrdCode 
		AND L.FNLngID = @pnLngID  -- 05.05.00 --
		LEFT JOIN TFNMCardType  T WITH (NOLOCK) ON M.FTCtyCode= T.FTCtyCode
		LEFT JOIN TFNMCardType_L WITH (NOLOCK) ON T.FTCtyCode= TFNMCardType_L.FTCtyCode  AND L.FNLngID = TFNMCardType_L.FNLngID
		WHERE M.FTCrdCode=@ptCrdCode AND M.FTCrdStaActive = '1'

		IF NOT EXISTS(SELECT FTCrdCode FROM TFNMCardBal WITH(NOLOCK) WHERE FTCrdCode = @ptCrdCode)
		BEGIN
			INSERT INTO TFNMCardBal(FTCrdCode,FTCrdTxnCode,FCCrdValue,FDLastUpdOn)
			SELECT @ptCrdCode,FTCrdTxnCode,0,GETDATE() FROM TFNSCrdBalType
		END 

		SELECT ROW_NUMBER() OVER (ORDER BY BAL.FTCrdTxnCode) AS FNTxnSeq,CBT.FTCrdName,BAL.FCCrdValue,BAL.FTCrdTxnCode
		FROM TFNMCardBal BAL WITH(NOLOCK)
		LEFT JOIN TFNSCrdBalType_L CBT WITH(NOLOCK) ON CBT.FTCrdTxnCode = BAL.FTCrdTxnCode AND CBT.FNLngID = @pnLngID
		WHERE BAL.FTCrdCode = @ptCrdCode

END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCoCancelCrdNoReuse') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE dbo.STP_PRCoCancelCrdNoReuse
GO
CREATE PROCEDURE [dbo].[STP_PRCoCancelCrdNoReuse]
	@pnBackDay INT
	, @FNResult INT OUTPUT AS
/*---------------------------------------------------------------------
Document History
Date			User		Remark
1.28/09/2022	Net			Create  
----------------------------------------------------------------------*/
BEGIN TRY
    
    DECLARE @dDate DATE
    SET @dDate = DATEADD(DAY ,@pnBackDay * -1, GETDATE())

    UPDATE CRD
    SET FTCrdStaActive = '3'
    --SELECT *
    FROM TFNMCard CRD WITH(NOLOCK)
    INNER JOIN TFNMCardType CTY WITH(NOLOCK) ON
        CRD.FTCtyCode = CTY.FTCtyCode
    INNER JOIN TFNTCrdSale SAL WITH(NOLOCK) ON
        CRD.FTCrdCode = SAL.FTCrdCode 
        --AND SAL.FTTxnDocType NOT IN ('5','7','10')
    WHERE CRD.FTCrdStaActive = '1' AND CRD.FTCrdStaShift = '2'
        AND ISNULL(CTY.FTCtyStaCrdReuse, '') = '2'
        AND CONVERT(DATE,SAL.FDTxnDocDate) >= @dDate
        AND CRD.FDCrdExpireDate < GETDATE()

    SELECT ''
	SET @FNResult= 0
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE()
	SET @FNResult= -1
END CATCH
GO
/******************************************** Stored Procedure **************************************************/



IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxIncomeNotReturnCardTmp')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].SP_RPTxIncomeNotReturnCardTmp
GO
/****** Object:  StoredProcedure [dbo].[SP_RPTxIncomeNotReturnCardTmp]    Script Date: 5/10/2565 17:17:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[SP_RPTxIncomeNotReturnCardTmp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--Shop Code
	@ptShpL Varchar(8000), --กรณี Condition IN
	@ptShpF Varchar(10),
	@ptShpT Varchar(10),

    --Mer Code
	@ptMerL Varchar(8000), --กรณี Condition IN
	@ptMerF Varchar(10),
	@ptMerT Varchar(10),

	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),

	@FNResult INT OUTPUT

AS 

BEGIN TRY	

	-- Last Update : Napat(Jame) 05/10/2022 ตรวจสอบบัตรหมดอายุ FDCrdExpireDate

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	
	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	--Shop Code
	DECLARE @tShpF Varchar(10)
	DECLARE @tShpT Varchar(10)

	--Mer Code
	DECLARE @tMerF Varchar(10)
	DECLARE @tMerT Varchar(10)

	--Pos Code
	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT

	--Shop
	SET @tShpF  = @ptShpF
	SET @tShpT  = @ptShpT

		--Mer
	SET @tMerF  = @ptShpF
	SET @tMerT  = @ptShpT

	--Pos
	SET @tPosF  = @ptPosF 
	SET @tPosT  = @ptPosT

	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult  = 0

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

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	SET @tSql1 = ' WHERE CRD.FTCrdStaShift = ''2'' AND TOPUP.FDTxnDocDate >= DO.FDXshDocDate '

	IF @pnFilterType = '1'
		BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END	
	END

	IF @pnFilterType = '2'
	BEGIN	
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptMerL <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode IN (' + @ptPosL + ')'
		END	
	END

	--IF (@tDocDateF <> '' AND @tDocDateT <> '')
	--BEGIN
    --	SET @tSql1 +=' AND CONVERT(VARCHAR(10),TOPUP.FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	--END

	SET @tSql1 += ' AND CONVERT(VARCHAR(10), CRD.FDCrdExpireDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''

	DELETE FROM TRPTIncomeNotReturnCardTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''

	SET @tSql  = ' INSERT INTO TRPTIncomeNotReturnCardTmp (FTComName,FTRptCode,FTUsrSession, FTBchCode,FTBchName,FTCrdCode,FCTxnCrdValue) '
	SET @tSql += ' SELECT B.FTComName,B.FTRptCode,B.FTUsrSession,B.FTBchCode,B.FTBchName,B.FTCrdCode,B.FCTxnCrdAmt '
	SET @tSql += ' FROM (
						SELECT '''+ @nComName + ''' AS FTComName,
							   '''+ @tRptCode +''' AS FTRptCode,
							   '''+ @tUsrSession +''' AS FTUsrSession,
							   A.FTBchCode,
							   A.FTBchName,
							   A.FTCrdCode,
							   SUM(A.FCTxnCrdAmt) AS FCTxnCrdAmt
						FROM ( 
							SELECT 
								  ISNULL(TOPUP.FTBchCode, '''') AS FTBchCode,
								  ISNULL(BCH.FTBchName, '''') AS FTBchName,
								  ISNULL(TOPUP.FTShpCode, '''') AS FTShpCode,
								  ISNULL(SHP.FTShpName, '''') AS FTShpName,
								  ISNULL(TOPUP.FTTxnPosCode, '''') AS FTTxnPosCode,
								  ISNULL(Pos.FTPosName, ''ระบบหลังบ้าน'') AS FTPosName,
								  CRD.FTCrdCode,
								  TOPUP.FTTxnDocNoRef,
								  TOPUP.FTTxnDocType,
								  CASE TOPUP.FTTxnDocType
									WHEN ''1'' THEN ISNULL(TOPUP.FCTxnValue, 0) * 1
									WHEN ''2'' THEN ISNULL(TOPUP.FCTxnValue, 0) * -1
									WHEN ''3'' THEN ISNULL(TOPUP.FCTxnValue, 0) * -1
									WHEN ''4'' THEN ISNULL(TOPUP.FCTxnValue, 0) * 1
									WHEN ''5'' THEN ISNULL(TOPUP.FCTxnValue, 0) * -1
									WHEN ''8'' THEN ISNULL(TOPUP.FCTxnValue, 0) * -1
									WHEN ''9'' THEN ISNULL(TOPUP.FCTxnValue, 0) * 1
									ELSE TOPUP.FCTxnCrdValue
								  END AS FCTxnCrdAmt,
								  DO.FDXshDocDate
						   FROM TFNMCard CRD
						   INNER JOIN (
								SELECT D.FTCrdCode,D.FDXshDocDate FROM (
									SELECT 
										SHD.FDXshDocDate,SDT.FTCrdCode,
										ROW_NUMBER() OVER(PARTITION BY SDT.FTCrdCode ORDER BY SHD.FDXshDocDate DESC) AS FNDateSeq
									FROM TFNTCrdShiftHD SHD WITH(NOLOCK)
									INNER JOIN TFNTCrdShiftDT SDT WITH(NOLOCK) ON SHD.FTXshDocNo = SDT.FTXshDocNo
									WHERE SHD.FNXshDocType = 1
								) D
								WHERE D.FNDateSeq = 1
						   ) DO ON DO.FTCrdCode = CRD.FTCrdCode
						   LEFT JOIN (
								SELECT FTBchCode,FTShpCode,FTTxnPosCode,FTTxnDocNoRef,FTTxnDocType,FTCrdCode,FDTxnDocDate,FCTxnValue,FCTxnCrdValue FROM TFNTCrdTopUp
								WHERE FTTxnDocType != ''5''
								UNION ALL
								SELECT FTBchCode,FTShpCode,FTTxnPosCode,FTTxnDocNoRef,FTTxnDocType,FTCrdCode,FDTxnDocDate,FCTxnValue,FCTxnCrdValue FROM TFNTCrdSale
						   ) TOPUP ON TOPUP.FTCrdCode = CRD.FTCrdCode
						   LEFT JOIN TCNMShop SH ON TOPUP.FTShpCode = SH.FTShpCode
						   LEFT JOIN TCNMBranch_L BCH ON TOPUP.FTBchCode = BCH.FTBchCode AND BCH.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + '''
						   LEFT JOIN TCNMShop_L SHP ON TOPUP.FTBchCode = SHP.FTBchCode AND TOPUP.FTShpCode = SHP.FTShpCode AND SHP.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + '''
						   LEFT JOIN TCNMPos_L POS ON TOPUP.FTBchCode = POS.FTBchCode AND TOPUP.FTTxnPosCode = POS.FTPosCode AND POS.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql += @tSql1
	SET @tSql += '		) A
						GROUP BY A.FTBchCode,A.FTBchName,A.FTCrdCode
					) B
					WHERE B.FCTxnCrdAmt > 0 '

	--SET @tSql = ' INSERT INTO TRPTIncomeNotReturnCardTmp'
	--SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	--SET @tSql +=' FTBchCode,FTBchName,FTShpCode,FTShpName,FTPosCode,FTPosName,FTCrdCode,FCTxnCrdValue)'
	--SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	--SET @tSql +=' A.FTBchCode, A.FTBchName, A.FTShpCode, A.FTShpName, A.FTTxnPosCode, A.FTPosName, A.FTCrdCode, SUM(A.FCTxnCrdAmt) AS FCTxnCrdAmt '
	--SET @tSql +=' FROM ( SELECT '
	--SET @tSql +=' ISNULL(TOPUP.FTBchCode, '''') AS FTBchCode, ISNULL(BCH.FTBchName, '''') AS FTBchName, ISNULL(TOPUP.FTShpCode, '''') AS FTShpCode, '
	--SET @tSql +=' ISNULL(SHP.FTShpName, '''') AS FTShpName, ISNULL(TOPUP.FTTxnPosCode, '''') AS FTTxnPosCode, ISNULL(Pos.FTPosName, ''ระบบหลังบ้าน'') AS FTPosName, ' 
	--SET @tSql +=' CRD.FTCrdCode, ISNULL(BAL.FCCrdValue,0) AS FCTxnCrdAmt '
	--SET @tSql +=' FROM TFNMCard CRD'
	--SET @tSql +=' LEFT JOIN TFNTCrdTopUp TOPUP ON TOPUP.FTCrdCode = CRD.FTCrdCode'
	--SET @tSql +=' LEFT JOIN TCNMShop SH ON TOPUP.FTShpCode = SH.FTShpCode'
	--SET @tSql +=' LEFT JOIN TCNMBranch_L BCH ON TOPUP.FTBchCode = BCH.FTBchCode AND BCH.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	--SET @tSql +=' LEFT JOIN TCNMShop_L SHP ON TOPUP.FTBchCode =  SHP.FTBchCode AND  TOPUP.FTShpCode = SHP.FTShpCode AND SHP.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	--SET @tSql +=' LEFT JOIN TCNMPos_L POS ON TOPUP.FTBchCode =  POS.FTBchCode AND  TOPUP.FTTxnPosCode = POS.FTPosCode AND POS.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	--SET @tSql +=' LEFT OUTER JOIN (
	--				SELECT
	--					FTCrdCode,
	--					SUM (CASE WHEN FTCrdTxnCode = ''001'' THEN FCCrdValue END) + SUM (CASE WHEN FTCrdTxnCode = ''002'' THEN FCCrdValue END) - SUM (CASE WHEN FTCrdTxnCode = ''006'' THEN FCCrdValue END ) AS FCCrdValue
	--				FROM
	--					TFNMCardBal
	--				GROUP BY
	--					FTCrdCode
	--			) AS BAL ON CRD.FTCrdCode = BAL.FTCrdCode '
	--SET @tSql += @tSql1
	--SET @tSql +=') A '
	--SET @tSql +='GROUP BY A.FTBchCode, A.FTBchName, A.FTShpCode, A.FTShpName, A.FTTxnPosCode, A.FTPosName, A.FTCrdCode '

	--PRINT @tSql
	EXECUTE(@tSql)

END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO


IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_DOCxSalePrcStk')and 
OBJECTPROPERTY(id, N'IsProcedure') = 1) BEGIN
	DROP PROCEDURE [dbo].STP_DOCxSalePrcStk
END
GO
CREATE PROCEDURE [dbo].[STP_DOCxSalePrcStk]
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
21.06.01	24/10/2021		Em		แก้ไข Process ต้นทุน และ Stock
06.03.00	21/10/2022		Zen		แก้เรื่องโครงสร้าง FTWahCode
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
			, SUM(DT.FCXsdQtyAll) AS FCStkQty,ISNULL(DT.FTWahCode,HD.FTWahCode) AS FTWahCode,HD.FDXshDocDate AS FDStkDate
			,ROUND(SUM(DT.FCXsdNet)/SUM(DT.FCXsdQtyAll),4) AS FCXsdSetPrice
			,ROUND(SUM(DT.FCXsdCostIn)/SUM(DT.FCXsdQtyAll),4) AS FCXsdCostIn
			,ROUND(SUM(DT.FCXsdCostEx)/SUM(DT.FCXsdQtyAll),4) AS FCXsdCostEx
			FROM TPSTSalDT DT with(nolock)
			INNER JOIN TPSTSalHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
			INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
			WHERE HD.FTBchCode=@ptBchCode AND HD.FTXshDocNo =@ptDocNo
			AND ISNULL(FTXsdStaPdt,'')NOT IN('4','5')
			--GROUP BY HD.FTBchCode,HD.FTWahCode,HD.FTXshDocNo,HD.FNXshDocType,DT.FTPdtCode,DT.FTXsdStkCode,HD.FDXshDocDate,DT.FCXsdSetPrice,DT.FCXsdCostIn,DT.FCXsdCostEx
			GROUP BY HD.FTBchCode,ISNULL(DT.FTWahCode,HD.FTWahCode),HD.FTXshDocNo,HD.FNXshDocType,DT.FTPdtCode,HD.FDXshDocDate		--3.--

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
				, SUM(DTF.FCXsdQty * DT.FCXsdFactor) AS FCStkQty,ISNULL(DT.FTWahCode,HD.FTWahCode) AS FTWahCode,HD.FDXshDocDate AS FDStkDate
				,ROUND(SUM(DT.FCXsdNet)/SUM(DTF.FCXsdQty * DT.FCXsdFactor),4) AS FCXsdSetPrice
				,ROUND(SUM(DT.FCXsdCostIn)/SUM(DTF.FCXsdQty * DT.FCXsdFactor),4) AS FCXsdCostIn
				,ROUND(SUM(DT.FCXsdCostEx)/SUM(DTF.FCXsdQty * DT.FCXsdFactor),4) AS FCXsdCostEx
				FROM TPSTSalDT DT with(nolock)
				INNER JOIN TPSTSalDTFhn DTF with(nolock) ON DTF.FTBchCode = DT.FTBchCode AND DTF.FTXshDocNo = DT.FTXshDocNo AND DTF.FNXsdSeqNo = DT.FNXsdSeqNo
				INNER JOIN TPSTSalHD HD with(nolock) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
				INNER JOIN TCNMPdt PDT WITH(NOLOCK) ON PDT.FTPdtCode = DT.FTPdtCode AND PDT.FTPdtStkControl = '1'	-- 04.02.00 --
				WHERE HD.FTBchCode=@ptBchCode AND HD.FTXshDocNo =@ptDocNo
				AND ISNULL(FTXsdStaPdt,'')NOT IN('4','5')
				GROUP BY HD.FTBchCode,ISNULL(DT.FTWahCode,HD.FTWahCode),HD.FTXshDocNo,HD.FNXshDocType,DT.FTPdtCode,DTF.FTFhnRefCode,HD.FDXshDocDate		--3.--

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

			---- 06.02.00 --
			----Cost
			--UPDATE TCNMPdtCostAvg with(rowlock)
			--SET FCPdtCostAmt = ISNULL(FCPdtCostAmt,0) + ((CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END)*FCPdtCostEx)
			--,FCPdtQtyBal = FCPdtQtyBal + (CASE WHEN TMP.FTStkType = '4' THEN TMP.FCStkQty ELSE TMP.FCStkQty *(-1) END)
			--,FDLastUpdOn = GETDATE()
			--FROM TCNMPdtCostAvg COST
			--INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			---- 06.02.00 --

			-- 21.06.01 --
			--Cost
			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostAmt = ROUND((CASE WHEN (FCPdtQtyBal + TMP.FCStkQty) <= 0 THEN 0 ELSE FCPdtCostEx * (FCPdtQtyBal + TMP.FCStkQty) END),4)	-- 21.06.01 --
			,FCPdtQtyBal = FCPdtQtyBal + TMP.FCStkQty	
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			WHERE TMP.FTStkType = '4'

			UPDATE TCNMPdtCostAvg with(rowlock)
			SET FCPdtCostAmt = ROUND((CASE WHEN (FCPdtQtyBal - TMP.FCStkQty) <= 0 THEN 0 ELSE FCPdtCostEx * (FCPdtQtyBal - TMP.FCStkQty) END),4)	-- 21.06.01 --
			,FCPdtQtyBal = FCPdtQtyBal - TMP.FCStkQty	
			,FDLastUpdOn = GETDATE()
			FROM TCNMPdtCostAvg COST
			INNER JOIN @TTmpPrcStk TMP ON COST.FTPdtCode = TMP.FTPdtCode
			WHERE TMP.FTStkType = '3'
			-- 21.06.01 --
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


IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCnTopupList')and 
OBJECTPROPERTY(id, N'IsProcedure') = 1) BEGIN
	DROP PROCEDURE [dbo].STP_PRCnTopupList
END
GO
CREATE PROCEDURE [dbo].[STP_PRCnTopupList] 
	@ptBchCode VARCHAR(5) NUll,
	@ptCrdCode VARCHAR(20) NUll,
	@pcTxnValue  NUMERIC(18,4) NULL,
	@pcTxnValuePmt  NUMERIC(18,4) NULL,
	@pcTxnConditionPmt NUMERIC(18,4) NULL, 
	@pcTxnNoRfn NUMERIC(18,4) NULL, -- 05.02.00 --
	@ptTxnPosCode VARCHAR(5) NUll,
	@pcCrdValue NUMERIC(18,4) NULL,
	@ptShpCode  VARCHAR(5) NUll,
	@ptUsrCode VARCHAR(20) NUll,
	@ptDocNoRef VARCHAR(30) NUll,
	@ptDocPmtRef VARCHAR(30) NULL
AS
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
05.01.00	10/11/2020		Em		create 
05.02.00	14/12/2020		Net		เพิ่ม Para ยอดห้ามคืน  
05.03.00    04/01/2020		Zen		เพิ่ม Parameter ยอดเติมเงินที่ได้เงื่อนไข
05.04.00    01/10/2022		Net		เพิ่ม Insert ยอดห้ามคืน CrdTopUpFifo
05.05.00	21/10/2022		Zen		แก้เรื่องเคลีย TFNTCrdTopUp ก่อน ทำการ Insert
----------------------------------------------------------------------*/
DECLARE @tTrans varchar(20)
DECLARE @nCount int
SET @tTrans = 'Topup'
BEGIN TRY
	BEGIN TRANSACTION @tTrans

	DELETE TFNTCrdTopUp WHERE FTBchCode = @ptBchCode AND FTTxnDocNoRef = @ptDocNoRef
	AND FTCrdCode = @ptCrdCode AND FTTxnDocType = '1'

	INSERT INTO TFNTCrdTopUp WITH(ROWLOCK) 
    ( 
		FTBchCode,FTTxnDocType,FTCrdCode 
		,FDTxnDocDate,FCTxnValue 
		,FTTxnStaPrc,FTTxnPosCode,FCTxnCrdValue,FCTxnPmt
		,FTShpCode ,FTTxnDocNoRef ,FTUsrCode
		,FCTxnNoRfn -- 05.02.00 --
    ) 
    VALUES 
    ( 
		@ptBchCode,'1',@ptCrdCode 
		,GETDATE(),@pcTxnValue 
		,'1',@ptTxnPosCode,@pcCrdValue,ISNULL(@pcTxnValuePmt,0)
		,@ptShpCode,@ptDocNoRef,@ptUsrCode     
		,@pcTxnNoRfn -- 05.02.00 --
    ) 

	IF NOT EXISTS(SELECT FTCrdCode FROM TFNMCardBal WITH(NOLOCK) WHERE FTCrdCode = @ptCrdCode)
	BEGIN
		INSERT INTO TFNMCardBal(FTCrdCode,FTCrdTxnCode,FCCrdValue,FDLastUpdOn)
		SELECT @ptCrdCode,FTCrdTxnCode,0,GETDATE() FROM TFNSCrdBalType
	END 
    -- Update Master Card
    UPDATE TFNMCard WITH (ROWLOCK) 
	SET FDCrdResetDate = GETDATE() 
		,FDLastUpdOn = GETDATE()  
    WHERE FTCrdCode=@ptCrdCode

	UPDATE TFNMCardBal
	SET FCCrdValue = (ISNULL(FCCrdValue,0) + @pcTxnValue)
	WHERE FTCrdCode = @ptCrdCode 
	AND FTCrdTxnCode = '001'

	UPDATE TFNMCardBal
	SET FCCrdValue = ISNULL(CTP.FCCtyDeposit,0)
	FROM TFNMCardBal BAL
	INNER JOIN TFNMCard CRD WITH(NOLOCK) ON CRD.FTCrdCode = BAL.FTCrdCode
	INNER JOIN TFNMCardType CTP WITH(NOLOCK) ON CTP.FTCtyCode = CRD.FTCtyCode
	WHERE BAL.FTCrdCode = @ptCrdCode 
	AND BAL.FTCrdTxnCode = '003'

	IF ISNULL(@pcTxnValuePmt,0) > 0
	BEGIN
		UPDATE TFNMCardBal
		SET FCCrdValue = (ISNULL(FCCrdValue,0) + ISNULL(@pcTxnValuePmt,0))
		WHERE FTCrdCode = @ptCrdCode 
		AND FTCrdTxnCode = '002'

		INSERT INTO TFNTCrdTopUpFifo WITH(ROWLOCK) 
		(
			FTCrdCode ,FDDateTime ,FCPmcAmtPay,
			FCPmcAmtGet ,FCPmcAmtNot ,
			FCPmcNoRfnPay,FCPmcNoRfnGet,
			FCPmcAmtPayAvb ,FCPmcAmtGetAvb ,FCPmcAmtNotAvb,
			FDLastUpdOn ,FTLastUpdBy,FDCreateOn ,FTCreateBy
		)
		 SELECT @ptCrdCode,GETDATE(),@pcTxnConditionPmt,
		 @pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 @pcTxnConditionPmt,
		 @pcTxnValuePmt,
		 @pcTxnConditionPmt,@pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 GETDATE(),@ptUsrCode,GETDATE(),@ptUsrCode
		 FROM TFNTCrdPmtHD PmtHD
		 WHERE FTPmhDocNo = @ptDocPmtRef
		--SELECT * FROM TFNTCrdPmtHD
	END
	ELSE
	BEGIN
		INSERT INTO TFNTCrdTopUpFifo WITH(ROWLOCK) 
		(
			FTCrdCode ,FDDateTime ,FCPmcAmtPay,
			FCPmcAmtGet ,FCPmcAmtNot ,
			FCPmcNoRfnPay,FCPmcNoRfnGet,
			FCPmcAmtPayAvb ,FCPmcAmtGetAvb ,FCPmcAmtNotAvb,
			FDLastUpdOn ,FTLastUpdBy,FDCreateOn ,FTCreateBy
		)VALUES (
		 @ptCrdCode,GETDATE(),@pcTxnConditionPmt,
		 @pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 --0,
		 @pcTxnNoRfn, -- 05.04.00 --
		 0,
		 @pcTxnConditionPmt,@pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 GETDATE(),@ptUsrCode,GETDATE(),@ptUsrCode )
	END

	 -- 05.02.00 --
	IF ISNULL(@pcTxnNoRfn,0) > 0
	BEGIN
		UPDATE TFNMCardBal
		SET FCCrdValue = (ISNULL(FCCrdValue,0) + ISNULL(@pcTxnNoRfn,0))
		WHERE FTCrdCode = @ptCrdCode 
		AND FTCrdTxnCode = '005'
	END
	 -- 05.02.00 --
    
	
	COMMIT TRANSACTION @tTrans 

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans 
END CATCH
GO






IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxIncomeNotReturnCardTmp')and 
OBJECTPROPERTY(id, N'IsProcedure') = 1) BEGIN
	DROP PROCEDURE [dbo].SP_RPTxIncomeNotReturnCardTmp
END
GO
CREATE PROCEDURE [dbo].[SP_RPTxIncomeNotReturnCardTmp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--Shop Code
	@ptShpL Varchar(8000), --กรณี Condition IN
	@ptShpF Varchar(10),
	@ptShpT Varchar(10),

    --Mer Code
	@ptMerL Varchar(8000), --กรณี Condition IN
	@ptMerF Varchar(10),
	@ptMerT Varchar(10),

	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),

	@FNResult INT OUTPUT

AS 

BEGIN TRY	

	-- Last Update : Napat(Jame) 05/10/2022 ตรวจสอบบัตรหมดอายุ FDCrdExpireDate

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	
	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	--Shop Code
	DECLARE @tShpF Varchar(10)
	DECLARE @tShpT Varchar(10)

	--Mer Code
	DECLARE @tMerF Varchar(10)
	DECLARE @tMerT Varchar(10)

	--Pos Code
	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT

	--Shop
	SET @tShpF  = @ptShpF
	SET @tShpT  = @ptShpT

		--Mer
	SET @tMerF  = @ptShpF
	SET @tMerT  = @ptShpT

	--Pos
	SET @tPosF  = @ptPosF 
	SET @tPosT  = @ptPosT

	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult  = 0

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

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	--SET @tSql1 = ' WHERE CRD.FTCrdStaShift = ''2'' AND TOPUP.FDTxnDocDate >= DO.FDXshDocDate '
	SET @tSql1 = '  '

	IF @pnFilterType = '1'
		BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

	--	IF (@tMerF <> '' AND @tMerT <> '')
	--	BEGIN
			--SET @tSql1 +=' AND TOPUP.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
	--	END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END	
	END

	IF @pnFilterType = '2'
	BEGIN	
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode IN (' + @ptShpL + ')'
		END

	--	IF (@ptMerL <> '')
		--BEGIN
		--	SET @tSql1 +=' AND TOPUP.FTMerCode IN (' + @ptMerL + ')'
	--	END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode IN (' + @ptPosL + ')'
		END	
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
    SET @tSql1 +=' AND CONVERT(VARCHAR(10),TOPUP.FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	--SET @tSql1 += ' AND CONVERT(VARCHAR(10), TOPUP.FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''

	DELETE FROM TRPTIncomeNotReturnCardTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''


SET @tSql  = ' INSERT INTO TRPTIncomeNotReturnCardTmp (FTComName,FTRptCode,FTUsrSession, FTBchCode,FTBchName,FTCrdCode,FCTxnCrdValue,FCCrdClear,FCCrdTopUpAuto,FCCrdTxnPmt) '
SET @tSql += ' SELECT '''+ @nComName + ''' AS FTComName, '''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
SET @tSql += ' B.FTBchCode,BCH.FTBchName,B.FTCrdCode,'
SET @tSql += ' CASE WHEN(B.CrdClear-B.CrdTopUpAuto-B.CrdTxnPmt)>0 THEN  B.CrdClear-B.CrdTopUpAuto-B.CrdTxnPmt ELSE 0 END AS FCCrdInCome,'
SET @tSql += ' B.CrdClear,B.CrdTopUpAuto,B.CrdTxnPmt'
SET @tSql += ' FROM 	('
SET @tSql += ' SELECT '
SET @tSql += ' A.FTBchCode,A.FTCrdCode,'
SET @tSql += ' SUM(CASE WHEN A.FTTxnDocType = ''10'' THEN  ISNULL(A.FCTxnValue,0) ELSE 0 END) AS CrdClear,'
SET @tSql += ' SUM(CASE WHEN A.FTTxnDocType = ''1'' AND A.StaCrdAuto = ''1'' THEN  ISNULL(A.FCTxnValue,0)  ELSE 0 END) AS CrdTopUpAuto,'
SET @tSql += ' SUM(CASE WHEN A.FTTxnDocType = ''1'' THEN  ISNULL(A.FCTxnPmt,0)  ELSE 0 END) AS CrdTxnPmt'
SET @tSql += ' FROM ('
SET @tSql += ' SELECT TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,TOPUP.FDTxnDocDate,TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,TOPUP.FCTxnPmt,'
SET @tSql += ' CASE WHEN ISNULL(HD.FTXshRmk,'''') = ''Auto Topup'' THEN ''1'' ELSE ''2'' END AS StaCrdAuto '
SET @tSql += ' FROM TFNTCrdTopUp TOPUP WITH(NOLOCK) '
SET @tSql += ' LEFT JOIN TFNTCrdTopUpHD HD WITH(NOLOCK) ON HD.FTBchCode = TOPUP.FTBchCode AND HD.FTXshDocNo = TOPUP.FTTxnDocNoRef '
SET @tSql += ' WHERE FTTxnDocType != ''5'' '
SET @tSql += @tSql1
SET @tSql += ' UNION ALL '
SET @tSql += ' SELECT TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,TOPUP.FDTxnDocDate,TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,0 AS FCTxnPmt,''2'' AS StaCrdAuto '
SET @tSql += ' FROM TFNTCrdSale TOPUP WITH(NOLOCK) WHERE ISNULL(TOPUP.FTCrdCode,'''') !='''' '
SET @tSql += @tSql1
SET @tSql += ' ) A'
SET @tSql += ' GROUP BY A.FTBchCode,A.FTCrdCode'
SET @tSql += ' ) B'
SET @tSql += ' LEFT JOIN TCNMBranch_L BCH WITH(NOLOCK) ON B.FTBchCode = BCH.FTBchCode AND BCH.FNLngID = ''1'' WHERE (ISNULL(B.CrdClear,0) -ISNULL(B.CrdTopUpAuto,0)-ISNULL(B.CrdTxnPmt,0)) > 0  '


	--PRINT @tSql
	EXECUTE(@tSql)

END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'SP_RPTxSalByMerShp'
        AND type = 'P'
      )
	BEGIN
	    DROP PROCEDURE [dbo].[SP_RPTxSalByMerShp]
	END
     

/****** Object:  StoredProcedure [dbo].[SP_RPTxSalByMerShp]    Script Date: 31/10/2022 22:52:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_RPTxSalByMerShp]
   @tUseSession varchar(255),
   @tLangID varchar(1),
   @tBchCode varchar(4000),
   @tMerCode varchar(30),
   @tShpCode varchar(4000),
   @tDateF varchar(30),
   @tDateT varchar(30),
   @tPdtCodeF varchar(30),
   @tPdtCodeT varchar(30)
AS
BEGIN TRY
   --SELECT * FROM TRPTSalByMerShpTmp
   DECLARE @tSQL VARCHAR(MAX)
   SET @tSQL = ''

   DECLARE @tSQLFilter VARCHAR(MAX)
   SET @tSQLFilter = ''

   IF (@tBchCode <> '' OR @tBchCode <> NULL)
		BEGIN
			SET @tSQLFilter += ' AND HD.FTBchCode IN(' + @tBchCode + ' ) '
		END	

   IF (@tMerCode <> '' OR @tMerCode <> NULL)
		BEGIN
			SET @tSQLFilter += ' AND SHP.FTMerCode =''' + @tMerCode + ''' '
		END	

   IF (@tShpCode <> '' OR @tShpCode <> NULL)
		BEGIN
			SET @tSQLFilter += ' AND HD.FTShpCode IN(' + @tShpCode + ')'
		END	
   
   IF ((@tDateF <> '' OR @tDateF <> NULL) AND (@tDateT <> '' OR @tDateT <> NULL) )
		BEGIN
			SET @tSQLFilter += ' AND CONVERT(VARCHAR(10),HD.FDXshDocDate,121) BETWEEN  ''' + @tDateF + '''AND '''+ @tDateT + ''' '
		END	

   IF ((@tPdtCodeF <> '' OR @tPdtCodeF <> NULL) AND (@tPdtCodeT <> '' OR @tPdtCodeT <> NULL) )
		BEGIN
			SET @tSQLFilter += ' AND DT.FTPdtCode BETWEEN  ''' + @tPdtCodeF + ''' AND ''' +  @tPdtCodeT + ''''
		END	

   DELETE FROM TRPTSalByMerShpTmp WHERE FTUsrSession = '' +@tUseSession+ ''

   SET @tSQL += ' INSERT INTO TRPTSalByMerShpTmp ' 
   SET @tSQL += ' SELECT '
		SET @tSQL += ' S.FTMerCode '
		SET @tSQL += ' ,MER.FTMerName '
		SET @tSQL += ' ,S.FTShpCode '
		SET @tSQL += ' ,SHP.FTShpName '
		SET @tSQL += ' ,S.FTPdtCode '
		SET @tSQL += ' ,S.FTXsdPdtName '
		SET @tSQL += ' ,S.FTPunName '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN S.FCXsdQtyAll ELSE S.FCXsdQtyAll * -1 END ) AS FCXsdQtyAll '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN ISNULL(S.FCXsdAmtB4DisChg,0) ELSE ISNULL(S.FCXsdAmtB4DisChg,0) * -1 END ) AS FCXsdTotal '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN ISNULL(S.FCXddValue,0) ELSE ISNULL(S.FCXddValue,0) * -1 END ) AS FCXsdTotalDisChg '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN S.FCXsdNetAfHD ELSE S.FCXsdNetAfHD * -1 END ) /  '
		SET @tSQL += '  SUM(CASE WHEN S.FNXshDocType = 1 THEN S.FCXsdQtyAll ELSE S.FCXsdQtyAll * -1 END ) AS FCXsdPriAvg '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN S.FCXsdNetAfHD ELSE S.FCXsdNetAfHD * -1 END ) AS FCXsdNetAfHD '
		SET @tSQL += ' , ' + ''''+@tUseSession+''''

		SET @tSQL += '  FROM ( '
				SET @tSQL += ' SELECT  '
				SET @tSQL += '  HD.FTXshDocNo '
				SET @tSQL += ' ,HD.FNXshDocType '
				SET @tSQL += ' ,HD.FTBchCode '
				SET @tSQL += ' ,SHP.FTMerCode '
				SET @tSQL += ' ,SHP.FTShpCode '
				SET @tSQL += ' ,DT.FTPdtCode '
				SET @tSQL += ' ,DT.FTXsdPdtName '
				SET @tSQL += ' ,DT.FCXsdQtyAll '
				SET @tSQL += ' ,DT.FTPunName '
				SET @tSQL += ' ,DT.FCXsdAmtB4DisChg '
				SET @tSQL += ' ,DIS.FCXddValue '
				SET @tSQL += ' ,DT.FCXsdNetAfHD '
				SET @tSQL += ' FROM TPSTSalDT DT '
				SET @tSQL += ' LEFT JOIN TPSTSalHD HD  ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo '
				SET @tSQL += ' LEFT JOIN TCNMShop SHP ON  HD.FTShpCode = SHP.FTShpCode '
				SET @tSQL += ' LEFT JOIN ( '

				SET @tSQL += ' SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo, '
				SET @tSQL += ' SUM(CASE WHEN FTXddDisChgType = ''3''  OR FTXddDisChgType = ''4'' THEN FCXddValue * -1 ELSE FCXddValue END) AS FCXddValue  '
				SET @tSQL += ' FROM TPSTSalDTDis '
				SET @tSQL += ' GROUP BY FTBchCode,FTXshDocNo,FNXsdSeqNo '

				SET @tSQL += ' ) DIS ON DT.FTBchCode = DIS.FTBchCode AND DT.FTXshDocNo = DIS.FTXshDocNo AND DT.FNXsdSeqNo = DIS.FNXsdSeqNo  '
				SET @tSQL += ' WHERE DT.FTXsdStaPdt <> ''4'' '

				SET @tSQL += @tSQLFilter

				--Filter
				--AND HD.FTBchCode IN('00001','00002')
				--AND HD.FTShpCode ='00001'
				--AND SHP.FTMerCode ='00001'
				--AND DT.FTPdtCode BETWEEN  '00002' AND '00003'
				--AND CONVERT(VARCHAR(10),HD.FDXshDocDate,121) BETWEEN  '2022-01-01' AND '2022-01-01'
		SET @tSQL += ' ) S  '
		SET @tSQL += ' LEFT JOIN TCNMPdtSpcBch PSB ON S.FTPdtCode = PSB.FTPdtCode '
		SET @tSQL += ' LEFT JOIN TCNMMerchant_L MER ON PSB.FTMerCode = MER.FTMerCode AND MER.FNLngID =  ' + @tLangID
		SET @tSQL += ' LEFT JOIN TCNMShop_L SHP ON  S.FTShpCode = SHP.FTShpCode AND SHP.FNLngID =   ' + @tLangID

		SET @tSQL += ' GROUP BY S.FTMerCode,MER.FTMerName,S.FTShpCode,SHP.FTShpName,S.FTPdtCode,S.FTXsdPdtName,S.FTPunName  '

		--PRINT(@tSQL)
		execute(@tSQL)

   return 1

END TRY
BEGIN CATCH
	return -1
END CATCH
GO



IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_CNtAUTAutoDocNo')and 
OBJECTPROPERTY(id, N'IsProcedure') = 1) BEGIN
	DROP PROCEDURE [dbo].SP_CNtAUTAutoDocNo
END
GO
CREATE PROCEDURE [dbo].[SP_CNtAUTAutoDocNo]
-- =============================================
-- Author:		Kitpipat Kaewkieo
-- Create date: 28/04/2020
-- Description:	สร้างรหัสเอกสารอัตโนมัติ
--Version 1 / 28/04/2020
--Version 2 / 13/05/2020 รองรับ Master
--Version 3 / 30/04/2021 รันเลขตาม AGN
--Version 4 / 04/05/2021 
--Version 5 / 16/06/2021 Napat(Jame) ตัวแปร @tRunningNo ปรับจาก VARCHAR(10) เป็น VARCHAR(255)
--Version 6 / 07/03/2022 Junthon M.
--Version 7 / 01/11/2022 Nattakit K. แก้ไขกรณ๊มีการปรับ ฟอแมท แล้วสร้างไม่ได้เพราะไป WHERE FTBchCode ในตารางที่ไม่มี
		@ptTblName VARCHAR(30),
		@ptDocType VARCHAR(10),
		@ptBchCode VARCHAR(5),
		@ptShpCode VARCHAR(5),
		@ptPosCode VARCHAR(5),
		@pdDocDate DATETIME,
		@ptResult VARCHAR(30) OUTPUT
	AS
	BEGIN TRY
		--Def Setting
		DECLARE @tDefChar VARCHAR(5)
		DECLARE @tDefBch VARCHAR(1)
		DECLARE @tDefPosShp VARCHAR(1)
		DECLARE @tDefYear VARCHAR(1)
		DECLARE @tDefMonth VARCHAR(1)
		DECLARE @tDefDay VARCHAR(1)
		DECLARE @tDefSep VARCHAR(1)
		DECLARE @nMinRunning VARCHAR(1)
		DECLARE @tDefNum VARCHAR(50)
		DECLARE @nDefStaReset VARCHAR(1)
		DECLARE @tDefFmtAll VARCHAR(50)
		
		--User Setting
		DECLARE @tUsrFmtAll VARCHAR(100)

		--Kitpipat 06/05/2021
		DECLARE @tAhnLastFmt VARCHAR(255)

		DECLARE @tUsrStaReset VARCHAR(100)
		DECLARE @tUsrFmtReset VARCHAR(100)
		DECLARE @nUsrNumSize INT
		DECLARE @tSatUsrNum VARCHAR(20)
		DECLARE @tUsrFmtPst VARCHAR(100)
		DECLARE @tUsrChar VARCHAR(50)
		DECLARE @tUsrStaAlwSep VARCHAR(1)
		
		--ตัวแปรกลาง
		DECLARE @tFedCode VARCHAR(100) 
		DECLARE @nStaResBch INT
		DECLARE @nStaResDay INT
		DECLARE @nStaResMonth INT
		DECLARE @nStaResYear INT

		DECLARE @tSQLMaxDoc NVARCHAR(MAX)
				SET @tSQLMaxDoc = ''

		DECLARE @tSQLFindTXN NVARCHAR(MAX)
				SET @tSQLFindTXN = ''

		DECLARE @tParamMaxDoc NVARCHAR(MAX)
				SET @tParamMaxDoc = ''
		
		DECLARE @tFilterBch NVARCHAR(200)
				SET @tFilterBch = ''

		DECLARE @tMaxBchCode VARCHAR(20)
		DECLARE @tLastNo VARCHAR(20)
		DECLARE @nLastRunningNo INT
		DECLARE @tLastDay VARCHAR(10)
		DECLARE @tLastMonth VARCHAR(10)
		DECLARE @tLastYear VARCHAR(10)
		DECLARE @tRunningNo VARCHAR(255)
		DECLARE @tAutoFrm VARCHAR(100)
		DECLARE @tNextDocNo VARCHAR(100)
		DECLARE @tStartNum VARCHAR(50)
		DECLARE @nRunningSize INT
		DECLARE @tFTBchCode VARCHAR(50) --13/05/2020 

		--การหาวัน-เดือน-ปีที่ต้องการ Gen Code
		DECLARE @tSaleYear VARCHAR(10)
		DECLARE @tSaleMonth VARCHAR(10)
		DECLARE @tSaleDate VARCHAR(10)
						SET @tSaleYear = SUBSTRING(CONVERT(VARCHAR(10),@pdDocDate,121),1,4)
						SET @tSaleMonth = SUBSTRING(CONVERT(VARCHAR(10),@pdDocDate,121),6,2)
						SET @tSaleDate = SUBSTRING(CONVERT(VARCHAR(10),@pdDocDate,121),9,2)

		--ตรวจสอบว่ามีการสร้างฟิวด์ FTAhnLastFmt หรือยัง? ถ้ายังให้สร้างฟิวด์
		--Kitpipat 06/05/2021
		IF NOT EXISTS (
				SELECT * FROM INFORMATION_SCHEMA.COLUMNS
				WHERE    TABLE_NAME = 'TCNTAutoHisTxn' AND COLUMN_NAME = 'FTAhnLastFmt')
			BEGIN
				ALTER TABLE TCNTAutoHisTxn
				ADD FTAhnLastFmt VARCHAR(255) NULL
		END

		--ตรวจสอบว่ามีการสร้างฟิวด์ FTAhnLastRunning หรือยัง? ถ้ายังให้สร้างฟิวด์
		--Kitpipat 07/05/2021
		IF NOT EXISTS (
				SELECT * FROM INFORMATION_SCHEMA.COLUMNS
				WHERE    TABLE_NAME = 'TCNTAutoHisTxn' AND COLUMN_NAME = 'FNAhnLastRunning')
			BEGIN
				ALTER TABLE TCNTAutoHisTxn
				ADD FNAhnLastRunning INT 
		END
			
	--หาว่า สาขาที่ส่งมานั้น มี AGN คืออะไร
		DECLARE @tAGNCode VARCHAR(100)
		SELECT  @tAGNCode = ISNULL(BCH.FTAgnCode,'') FROM TCNMBranch BCH WHERE BCH.FTBchCode = ''+@ptBchCode+''

	--หาว่า  AGN ที่ได้ มีการเซตในตาราง TCNTAutoHisTxn ไหม ถ้ามีก็ให้ใช้ AGN นั้น ถ้าไม่มีก็ปล่อยให้เป็น null
		DECLARE @tAGNInTxn VARCHAR(100)
		SELECT  @tAGNInTxn = ISNULL(INTXN.FTAgnCode,'') FROM TCNTAutoHisTxn INTXN WHERE INTXN.FTAgnCode = ''+@tAGNCode+'' 
							AND INTXN.FTAhmTblName = ''+@ptTblName+''
							AND INTXN.FTSatStaDocType = ''+@ptDocType+'' 

		IF(@tAGNInTxn <> '') --มีค่า
			BEGIN
				SET @tAGNCode = @tAGNInTxn
				END
		ELSE	
			BEGIN
				SET @tAGNCode = ''
				END

		SELECT @tDefChar = ISNULL(AUT.FTSatDefChar,'') 
			,@tDefBch = ISNULL(AUT.FTSatDefBch,0) 
			,@tDefPosShp = ISNULL(AUT.FTSatDefPosShp,0) 
			,@tDefYear = ISNULL(AUT.FTSatDefYear,0)
			,@tDefMonth = ISNULL(AUT.FTSatDefMonth,0)
			,@tDefDay = ISNULL(AUT.FTSatDefDay,0)
			,@tDefSep = ISNULL(AUT.FTSatDefSep,0)
			,@nDefStaReset = ISNULL(FTSatStaReset,0) 
			,@tFedCode = AUT.FTSatFedCode 
			,@nMinRunning = ISNULL(AUT.FNSatMinRunning,0) 
			,@tDefNum = ISNULL(FTSatDefNum,1)
			,@tUsrFmtAll = ISNULL(TXN.FTAhmFmtAll,'') 
			,@tAhnLastFmt = ISNULL(TXN.FTAhnLastFmt,'')
			,@tUsrStaReset = ISNULL(TXN.FTAhmStaReset,0) 
			,@tUsrFmtReset = ISNULL(TXN.FTAhmFmtReset,'') 
			,@nUsrNumSize = ISNULL(TXN.FNAhmNumSize,5) 
			,@tSatUsrNum = TXN.FTSatUsrNum
			,@nLastRunningNo = TXN.FNAhnLastRunning
			,@tUsrFmtPst = TXN.FTAhmFmtPst 
			,@tUsrChar = TXN.FTAhmFmtChar 
			,@tUsrStaAlwSep = ISNULL(TXN.FTSatStaAlwSep,0) 
			,@tDefFmtAll = ISNULL(AUT.FTSatDefFmtAll,0)
				FROM TCNTAuto AUT
				LEFT JOIN TCNTAutoHisTxn TXN ON AUT.FTSatTblName = TXN.FTAhmTblName 
				AND AUT.FTSatFedCode = TXN.FTAhmFedCode 
				AND AUT.FTSatStaDocType = TXN.FTSatStaDocType 
				AND TXN.FTAgnCode = ''+@tAGNCode+'' 
				WHERE AUT.FTSatTblName = ''+@ptTblName+''
				AND AUT.FTSatStaDocType = ''+@ptDocType+'' 

		--PRINT (@tUsrFmtAll)

		------------------------------------------------------------------------------------------------------------------------------------------
		--หาเลข auto running ล่าสุด
		IF(@tUsrFmtAll <> '')
		BEGIN
				SET @nUsrNumSize = @nUsrNumSize
				IF(CHARINDEX('BCH', @tUsrFmtReset) <> 0)
				BEGIN
					SET @tFilterBch += ' AND FTBchCode='''+@ptBchCode+''''
					SET @tFTBchCode = 'FTBchCode' 
				END
				ELSE
				BEGIN
				--	SET @tFilterBch += ' AND FTBchCode='''+@ptBchCode+''''
				--	SET @tFTBchCode = 'FTBchCode' 
				SET @tFilterBch+= '' --01/11/2022  แก้ไขกรณ๊มีการปรับ ฟอแมท แล้วสร้างไม่ได้เพราะไป WHERE FTBchCode ในตารางที่ไม่มี
				SET @tFTBchCode = ''''''
				END
		END
		ELSE
		BEGIN
			SET @nUsrNumSize = LEN(@tDefNum)
			IF(@nDefStaReset = 4)
				BEGIN
					SET @tFilterBch+= ' AND FTBchCode='''+@ptBchCode+''''
					SET @tFTBchCode = 'FTBchCode' 
				END
			ELSE
				BEGIN
				SET @tFilterBch+= ''
				SET @tFTBchCode = ''''''
				END
		END
		
		--Loop หา Format Supawat 08/09/2020
		DECLARE @nPosition_CHECK	INT
		DECLARE @nLen_CHECK				INT
		DECLARE @nNum							INT
		DECLARE @tFrmType_CHECK		VARCHAR(8000)
		DECLARE @tUsrFmtPst_CHECK	VARCHAR(100)
		DECLARE @tCheckFormat			VARCHAR(800)
		SET		  @tCheckFormat			= ''

		IF(@tUsrFmtAll <> '')
		-- มีการเซตในตาราง TXN จัดรูปแบบเอง
			BEGIN
				--PRINT ('HAVE FMT')
				SET	@nNum								= 1
				SET @tUsrFmtPst_CHECK		= @tUsrFmtPst + ','
				SET @nPosition_CHECK		= 0
				SET @nLen_CHECK					= 0

				WHILE CHARINDEX(',', @tUsrFmtPst_CHECK, @nPosition_CHECK + 1 ) > 0
					BEGIN
						SET @nLen_CHECK		= CHARINDEX(',', @tUsrFmtPst_CHECK, @nPosition_CHECK + 1 ) - @nPosition_CHECK
						SET @tFrmType_CHECK	= SUBSTRING(@tUsrFmtPst_CHECK, @nPosition_CHECK, @nLen_CHECK)
			
						IF(@tFrmType_CHECK = 'CHA')
							BEGIN
								SET @tCheckFormat = @tCheckFormat + @tUsrChar
							END

						ELSE IF(@tFrmType_CHECK = 'BCH')
							BEGIN
								--SET @tCheckFormat = @tCheckFormat + '[0-9][0-9][0-9][0-9][0-9]'
								SET @tCheckFormat = @tCheckFormat + @ptBchCode	--*Em 65-03-07 AdaBigC
							END

						ELSE IF(@tFrmType_CHECK = 'PSH')
							BEGIN
								--SET @tCheckFormat = @tCheckFormat + '[0-9][0-9][0-9][0-9][0-9]'
								SET @tCheckFormat = @tCheckFormat + @ptPosCode	--*Em 65-03-07 AdaBigC
							END
						
						ELSE IF(@tFrmType_CHECK = 'YYYY')
							BEGIN
								--SET @tCheckFormat = @tCheckFormat + '[0-9][0-9][0-9][0-9]'
								SET @tCheckFormat = @tCheckFormat + CONVERT(VARCHAR(4),@pdDocDate,121)	--*Em 65-03-07 AdaBigC
							END

						ELSE IF(@tFrmType_CHECK = 'YY')
							BEGIN
								--SET @tCheckFormat = @tCheckFormat + '[0-9][0-9]'
								SET @tCheckFormat = @tCheckFormat + SUBSTRING(CONVERT(VARCHAR(4),@pdDocDate,121),3,4)	--*Em 65-03-07 AdaBigC
							END

						ELSE IF(@tFrmType_CHECK = 'MM')
							BEGIN
								--SET @tCheckFormat = @tCheckFormat + '[0-9][0-9]'
								SET @tCheckFormat = @tCheckFormat + SUBSTRING(CONVERT(VARCHAR(4),@pdDocDate,121),6,2)	--*Em 65-03-07 AdaBigC
							END

						ELSE IF(@tFrmType_CHECK = 'DD')
							BEGIN
								--SET @tCheckFormat = @tCheckFormat + '[0-9][0-9]'
								SET @tCheckFormat = @tCheckFormat + SUBSTRING(CONVERT(VARCHAR(4),@pdDocDate,121),9,2)	--*Em 65-03-07 AdaBigC
							END
						--Loop ใหม่อีกรอบ
						SET @nPosition_CHECK = CHARINDEX(',', @tUsrFmtPst_CHECK, @nPosition_CHECK + @nLen_CHECK) + 1
				END

				IF(@tUsrStaAlwSep = 1)
				BEGIN
					SET @tCheckFormat = @tCheckFormat + '[-]'
				END

				--#####
				WHILE (@nNum <= @nUsrNumSize)
					BEGIN
						SET @tCheckFormat	+= '[0-9]'
						SET @nNum			 = @nNum + 1
					END
			END
		ELSE
			BEGIN
				--PRINT ('NO FMT')
				SET		@nNum = 1
					BEGIN
						--ต้องเอา Format ใน Default มาหา

						--รูปแบบของ รหัสขึ้นต้น
						IF(@tDefChar <> '' OR @tDefChar <> null OR @tDefChar <> 0)
							SET @tCheckFormat += @tDefChar
						ELSE
							SET @tCheckFormat += ''
						
						--รูปแบบของ สาขา
						IF(@tDefBch <> 0)
							--SET @tCheckFormat += '[0-9][0-9][0-9][0-9][0-9]'
							SET @tCheckFormat += @ptBchCode	--*Em 65-03-07  AdaBigC
						ELSE
							SET @tCheckFormat += ''

						--รูปแบบของ จุดขาย
						IF(@tDefPosShp <> 0)
							IF(@ptPosCode <> '')
								--SET @tCheckFormat += '[0-9][0-9][0-9][0-9][0-9]'
								SET @tCheckFormat += @ptPosCode	--*Em 65-03-07  AdaBigC
							ELSE
								SET @tCheckFormat += ''
						ELSE
							SET @tCheckFormat += ''

						--รูปแบบของ ปี
						IF(@tDefYear <> 0)
							IF(@tDefYear = 1)
								--SET @tCheckFormat += '[0-9][0-9]'
								SET @tCheckFormat += SUBSTRING(CONVERT(VARCHAR(4),@pdDocDate,121),3,4)	--*Em 65-03-07 AdaBigC
							ELSE
								--SET @tCheckFormat += '[0-9][0-9][0-9][0-9]'
								SET @tCheckFormat += CONVERT(VARCHAR(4),@pdDocDate,121)	--*Em 65-03-07 AdaBigC
						ELSE
							SET @tCheckFormat += ''

						--รูปแบบของ เดือน
						IF(@tDefMonth <> 0)
							--SET @tCheckFormat += '[0-9][0-9]'
							SET @tCheckFormat += SUBSTRING(CONVERT(VARCHAR(4),@pdDocDate,121),6,2)	--*Em 65-03-07 AdaBigC
						ELSE
							SET @tCheckFormat += ''

						--รูปแบบของ วัน
						IF(@tDefDay <> 0)
							--SET @tCheckFormat += '[0-9][0-9]'
							SET @tCheckFormat += SUBSTRING(CONVERT(VARCHAR(4),@pdDocDate,121),9,2)	--*Em 65-03-07 AdaBigC
						ELSE
							SET @tCheckFormat += ''

						--รูปแบบของ คั่นกลาง
						IF(@tDefSep <> 0)
							SET @tCheckFormat += '[-]'
						ELSE
							SET @tCheckFormat += ''

						--#####
						WHILE (@nNum <= @nUsrNumSize)
						BEGIN
							SET @tCheckFormat += '[0-9]'
							SET @nNum = @nNum + 1
						END
					END
		END

		SET @tSQLMaxDoc += ' SELECT TOP 1 @tMaxBchCodeOUT = '+@tFTBchCode --13/05/2020
		SET @tSQLMaxDoc += ' ,@tLastNoOUT = RIGHT('+@tFedCode+','+CAST(@nUsrNumSize AS VARCHAR(10))+')'
		SET @tSQLMaxDoc += ' ,@tLastDayOUT = SUBSTRING(CONVERT(VARCHAR(10),FDCreateOn,121),9,2)'
		SET @tSQLMaxDoc += ' ,@tLastMonthOUT = SUBSTRING(CONVERT(VARCHAR(10),FDCreateOn,121),6,2)'
		SET @tSQLMaxDoc += ' ,@tLastYearOUT = SUBSTRING(CONVERT(VARCHAR(10),FDCreateOn,121),1,4)'
		SET @tSQLMaxDoc += ' FROM '+@ptTblName
		SET @tSQLMaxDoc += ' WHERE '
		SET @tSQLMaxDoc += ' '+@tFedCode+' = '
		SET @tSQLMaxDoc += ' ( SELECT TOP 1 '+@tFedCode+' FROM '+@ptTblName+' WHERE '+@tFedCode+' LIKE '''+@tCheckFormat+'''  '
		SET @tSQLMaxDoc += ' AND 1=1 ' + @tFilterBch

		IF(@tFilterBch <> '')
			BEGIN
				SET @tSQLMaxDoc += @tFilterBch
			END
		
	SET @tSQLMaxDoc += ' ORDER BY SUBSTRING (CONVERT (VARCHAR(10), FDCreateOn, 121),1,4) DESC , RIGHT('+@tFedCode+','+CAST(@nUsrNumSize AS VARCHAR(10))+') DESC )'
		SET @tSQLMaxDoc += @tFilterBch

	--PRINT @tSQLMaxDoc;
		--RETURN;

		SET @tParamMaxDoc+= N' @tMaxBchCodeOUT VARCHAR(20) OUTPUT '
		SET @tParamMaxDoc+= N',@tLastNoOUT VARCHAR(20) OUTPUT '
		SET @tParamMaxDoc+= N',@tLastDayOUT VARCHAR(10) OUTPUT '
		SET @tParamMaxDoc+= N',@tLastMonthOUT VARCHAR(10) OUTPUT '
		SET @tParamMaxDoc+= N',@tLastYearOUT VARCHAR(10) OUTPUT '

		EXECUTE sp_executesql @tSQLMaxDoc,
								@tParamMaxDoc,
								@tMaxBchCodeOUT = @tMaxBchCode OUTPUT,
								@tLastNoOUT = @tLastNo OUTPUT,
								@tLastDayOUT = @tLastDay OUTPUT,
								@tLastMonthOUT = @tLastMonth OUTPUT,
								@tLastYearOUT = @tLastYear OUTPUT

		------------------------------------------------------------------------------------------------------------------------------------------

		--ตรวจสอบว่ามีการกำหนดการตั้งค่าโดยผู้ใช้หรือไม่
		IF(@tUsrFmtAll <> '')
			BEGIN

				SET @tLastNo = @nLastRunningNo

				--ตรวจสอบการ reset number
				IF(@tUsrStaReset <> 0)
					BEGIN

						--มีการตั้งค่าให้ reset number
						SET @nStaResBch  = CHARINDEX('BCH', @tUsrFmtReset)
						SET @nStaResYear  = CHARINDEX('YYYY', @tUsrFmtReset)
						SET @nStaResMonth  = CHARINDEX('MM', @tUsrFmtReset)
						SET @nStaResDay  = CHARINDEX('DD', @tUsrFmtReset)

					END
				ELSE
					BEGIN
					--ไม่มีการ reset number ใช้แบบ run ต่อเนื่อง
						SET @nStaResBch  = 0
						SET @nStaResYear  = 0
						SET @nStaResMonth  = 0
						SET @nStaResDay  = 0

					END

				--จัด Format ตามที่ผู้ใช้ตั้งค่า
				DECLARE @nPosition INT
				DECLARE @nLen INT
				DECLARE @tFrmType varchar(8000)
				SET @tUsrFmtPst = @tUsrFmtPst + ','
				SET @nPosition = 0
				SET @nLen = 0
				SET @tAutoFrm = ''

				WHILE CHARINDEX(',', @tUsrFmtPst, @nPosition+1) > 0
					BEGIN
						SET @nLen = CHARINDEX(',', @tUsrFmtPst, @nPosition+1) - @nPosition
						SET @tFrmType = SUBSTRING(@tUsrFmtPst, @nPosition, @nLen)

						IF(@tFrmType = 'CHA')
							BEGIN
								SET @tAutoFrm = @tAutoFrm + @tUsrChar
							END
						ELSE IF(@tFrmType = 'BCH')
							BEGIN
								SET @tAutoFrm = @tAutoFrm + @ptBchCode
							END

						ELSE IF(@tFrmType = 'PSH')
							BEGIN
								SET @tAutoFrm = @tAutoFrm + @ptShpCode+@ptPosCode
							END
						
						ELSE IF(@tFrmType = 'YYYY')
							BEGIN
								SET @tAutoFrm = @tAutoFrm + CONVERT(VARCHAR(4),@pdDocDate,121)
							END

						ELSE IF(@tFrmType = 'YY')
							BEGIN
								SET @tAutoFrm = @tAutoFrm + SUBSTRING(CONVERT(VARCHAR(4),@pdDocDate,121),3,4)
							END

						ELSE IF(@tFrmType = 'MM')
							BEGIN
								SET @tAutoFrm = @tAutoFrm + SUBSTRING(CONVERT(VARCHAR(10),@pdDocDate,121),6,2)
							END

						ELSE IF(@tFrmType = 'DD')
							BEGIN
								SET @tAutoFrm = @tAutoFrm + SUBSTRING(CONVERT(VARCHAR(10),@pdDocDate,121),9,2)
							END
						
						SET @nPosition = CHARINDEX(',', @tUsrFmtPst, @nPosition+@nLen) + 1

				END

				IF(@tUsrStaAlwSep <> 0)
				BEGIN
					SET @tAutoFrm = @tAutoFrm + '-'
				END
				--จบการจัด Format

				--Set Start Number
				SET @tStartNum = @tSatUsrNum
				--SET Running Size Number
				SET @nRunningSize = @nUsrNumSize
			END
		ELSE
			BEGIN
			--ใช้ค่า Def จากระบบ
			--ตรวจสอบการ reset รหัส
			IF(@nDefStaReset = 1) BEGIN SET @nStaResYear = @nDefStaReset  END ELSE BEGIN SET @nStaResYear = '0'  END
			IF(@nDefStaReset = 2) BEGIN SET @nStaResMonth = @nDefStaReset END ELSE BEGIN SET @nStaResMonth = '0' END
			IF(@nDefStaReset = 3) BEGIN SET @nStaResDay = @nDefStaReset   END ELSE BEGIN SET @nStaResDay = '0'   END
			IF(@nDefStaReset = 4) BEGIN SET @nStaResBch = @nDefStaReset   END ELSE BEGIN SET @nStaResBch = '0'   END

			IF(@tLastNo <> '') BEGIN SET @tLastNo = @tLastNo END ELSE BEGIN SET @tLastNo = 0 END
			SET @nRunningSize = LEN(@tDefNum)
			--SET @tStartNum = CONCAT(REPLICATE('0',@nRunningSize-LEN(1)),1) 
			SET @tStartNum = @tDefNum
			SET @tAutoFrm = ''
			IF(@tDefChar <> '')  BEGIN SET @tAutoFrm+= @tDefChar  END
			IF(@tDefBch <> 0)    BEGIN SET @tAutoFrm+= @ptBchCode END
			IF(@tDefPosShp <> 0) BEGIN SET @tAutoFrm+= @ptPosCode END
			IF(@tDefYear <> 0)  
				BEGIN 
						IF(@tDefYear = 'YYYY')
						BEGIN
						SET @tSaleYear = @tSaleYear
								SET @tLastYear = @tLastYear
						END
						ELSE
						BEGIN
							SET @tSaleYear = SUBSTRING(@tSaleYear,3,2)
							SET @tLastYear = SUBSTRING(@tLastYear,3,2)
						END     
						SET @tAutoFrm+=  @tSaleYear 
				END
				IF(@tDefMonth <> 0)  BEGIN SET @tAutoFrm+= @tSaleMonth END
				IF(@tDefDay <> 0)    BEGIN SET @tAutoFrm+= @tSaleDate  END
				IF(@tDefSep <> 0)    BEGIN SET @tAutoFrm+= '-'  END

			END
		
		-----------------------------------------------------------------------------------------------------------------------------
		--Check IF Change New Format Reset Running
		IF (@tUsrFmtAll <> @tAhnLastFmt)
			BEGIN

					SET @tRunningNo = @tSatUsrNum
					SET @tRunningNo = CONCAT(REPLICATE('0',@nRunningSize-LEN(@tRunningNo)),@tRunningNo)
					SET @tNextDocNo = @tAutoFrm+@tRunningNo 

					SELECT @tNextDocNo AS FTXxhDocNo

					DECLARE @tSQLUpdateLastFMT VARCHAR(MAX)
					SET @tSQLUpdateLastFMT = ' UPDATE TCNTAutoHisTxn SET FTAhnLastFmt = FTAhmFmtAll '
					SET @tSQLUpdateLastFMT += ' , FNAhnLastRunning = '''+@tRunningNo+'''  '
					SET @tSQLUpdateLastFMT += ' WHERE FTAhmTblName = '''+@ptTblName+'''  '
					SET @tSQLUpdateLastFMT += ' AND FTSatStaDocType = '''+@ptDocType+''' '
					SET @tSQLUpdateLastFMT += ' AND FTAgnCode = '''+@tAGNCode+''' '
					EXECUTE(@tSQLUpdateLastFMT)
			END
		ELSE
			BEGIN
					--ตรวจสอบการ reset เลขที่เอกสารตามสาขา 
					IF(@nStaResBch <> 0 )
						BEGIN
						
							--IF(@tMaxBchCode <> '')
							--	BEGIN 
									SET @tRunningNo = @tLastNo + 1
									SET @tRunningNo = CONCAT(REPLICATE('0',@nRunningSize-LEN(@tRunningNo)),@tRunningNo)
									SET @tNextDocNo = @tAutoFrm+@tRunningNo 
						
							--	END
							--ELSE
							--	BEGIN
							--		SET @tRunningNo = @tStartNum
							--		SET @tNextDocNo = @tAutoFrm+@tRunningNo
							--	END
						END
					------------------------------------------------------------------------------------------------------------------------------
					--ตรวจสอบการ reset เลขที่เอกสารตามปี
					ELSE IF(@nStaResYear <> 0)
						BEGIN
							--PRINT('Reset ตามปี')
							--PRINT('Last Year:'+@tLastYear+'tSaleYear:'+@tSaleYear)
								IF(@tLastYear <> '')
								BEGIN
									SET @tLastYear = @tLastYear
									END
								ELSE
								BEGIN
									SET @tLastYear = '1900'
									END
					
							IF(@tLastYear <> @tSaleYear)
								BEGIN
									SET @tRunningNo = @tStartNum
									SET @tNextDocNo = @tAutoFrm+@tRunningNo
									END
								ELSE
								BEGIN
									SET @tRunningNo = @tLastNo + 1
										SET @tRunningNo = CONCAT(REPLICATE('0',@nRunningSize-LEN(@tRunningNo)),@tRunningNo)
										SET @tNextDocNo = @tAutoFrm+@tRunningNo
								END
						END

					------------------------------------------------------------------------------------------------------------------------------
					--ตรวจสอบการ reset เลขที่เอกสารตามเดือน
					ELSE IF(@nStaResMonth <> 0)
						BEGIN
								IF(@tLastMonth <> '')
								BEGIN
										SET @tLastMonth = @tLastMonth
								END
								ELSE
								BEGIN
										SET @tLastMonth = '00'
								END
							IF(@tLastMonth <> @tSaleMonth)
								BEGIN
									SET @tRunningNo = @tStartNum
									SET @tNextDocNo = @tAutoFrm+@tRunningNo
								END
							ELSE
								BEGIN
									SET @tRunningNo = @tLastNo + 1
									SET @tRunningNo = CONCAT(REPLICATE('0',@nRunningSize-LEN(@tRunningNo)),@tRunningNo)
									SET @tNextDocNo = @tAutoFrm+@tRunningNo
								END
						END
					------------------------------------------------------------------------------------------------------------------------------
					--ตรวจสอบการ reset เลขที่เอกสารตามวัน
					ELSE IF(@nStaResDay <> 0)
						BEGIN
							IF(@tLastDay <> '')
								BEGIN
									SET @tLastDay = @tLastDay
								END
							ELSE
								BEGIN
									SET @tLastDay = '00'
								END
							IF(@tLastDay <> @tSaleDate)
								BEGIN
									SET @tRunningNo = @tStartNum
									SET @tNextDocNo = @tAutoFrm+@tRunningNo
								END
							ELSE
								BEGIN
									SET @tRunningNo = @tLastNo + 1
									SET @tRunningNo = CONCAT(REPLICATE('0',@nRunningSize-LEN(@tRunningNo)),@tRunningNo)
									SET @tNextDocNo = @tAutoFrm+@tRunningNo
								END
						END
					------------------------------------------------------------------------------------------------------------------------------
					--ใช้การ Run แบบต่อเนื่อง
					ELSE
						BEGIN
							IF(@tLastNo <> '')
								BEGIN
								SET @tRunningNo = @tLastNo + 1
								END
							ELSE
								BEGIN
								SET @tRunningNo = @tStartNum
								END

							SET @tRunningNo = CONCAT(REPLICATE('0',@nRunningSize-LEN(@tRunningNo)),@tRunningNo)

							SET @tNextDocNo = @tAutoFrm+@tRunningNo
						END
					------------------------------------------------------------------------------------------------------------------------------
					--Kitpipat 07/05/2021
					IF(@tUsrFmtAll <> '')
					BEGIN
							
							
							DECLARE @tPreviousRuningNo VARCHAR(255)
							DECLARE @tPreviousDocNo VARCHAR(255)

							SET @tPreviousRuningNo = CONCAT(REPLICATE('0',@nRunningSize-LEN(@tRunningNo - 1)),@tRunningNo -1 )
							SET @tPreviousDocNo = @tAutoFrm+@tPreviousRuningNo



							DECLARE @tSQLLastDoc NVARCHAR(MAX)
							SET @tSQLLastDoc = ''

							DECLARE @tParamLastDoc NVARCHAR(MAX)
							SET @tParamLastDoc = ''

							DECLARE @tStaDocUse VARCHAR(30)
							DECLARE @tStaDocUseOUT VARCHAR(30)

							SET @tSQLLastDoc += ' SELECT TOP 1 @tStaDocUseOUT = '+@tFedCode 
							SET @tSQLLastDoc += ' FROM '+ @ptTblName
							SET @tSQLLastDoc += ' WHERE  '+ @tFedCode + ' = ''' + @tPreviousDocNo+''' '

						
							SET @tParamLastDoc += N' @tStaDocUseOUT VARCHAR(30) OUTPUT '

							EXECUTE sp_executesql @tSQLLastDoc,@tParamLastDoc,@tStaDocUseOUT = @tStaDocUse OUTPUT

						--ถ้ามีการใช้เลขที่เอกสารนี้ไปแล้วให้ไปใช้เลขที่เอกสารถัดไป
						IF(@tStaDocUse <> '')
							BEGIN
									
									DECLARE @tSQLGetMaxDoc NVARCHAR(MAX)
									SET @tSQLGetMaxDoc = ''

									DECLARE @tParamLastRunning NVARCHAR(MAX)
									SET @tParamLastRunning = ''

									DECLARE @tLastRunning VARCHAR(30)
									DECLARE @tLastRunningOUT VARCHAR(30)

									DECLARE @nUsrNumSizeFmt VARCHAR(30)
									--PRINT(@tAutoFrm)
									SET @nUsrNumSizeFmt = LEN(@tAutoFrm)

									SET @tSQLGetMaxDoc += ' SELECT  @tLastRunningOUT = MAX (RIGHT('+@tFedCode+','+CAST(@nUsrNumSize AS VARCHAR(10))+'))'
									SET @tSQLGetMaxDoc += ' FROM '+ @ptTblName
									SET @tSQLGetMaxDoc += ' WHERE  LEFT('+@tFedCode+','+CAST(@nUsrNumSizeFmt AS VARCHAR(30))+') = ''' + @tAutoFrm + ''' '
									SET @tSQLGetMaxDoc += @tFilterBch

									SET @tParamLastRunning += N' @tLastRunningOUT VARCHAR(30) OUTPUT '

									EXECUTE sp_executesql @tSQLGetMaxDoc,@tParamLastRunning,@tLastRunningOUT = @tLastRunning OUTPUT

									--PRINT(@tLastRunning)

									SET @tRunningNo = CONCAT(REPLICATE('0',@nRunningSize-LEN(@tLastRunning + 1)),@tLastRunning + 1 )

									SET @tNextDocNo = @tAutoFrm+@tRunningNo

									SELECT @tNextDocNo AS FTXxhDocNo
								

									SET @tRunningNo = CONVERT(INT , @tLastRunning + 1)
									
									DECLARE @tSQLUpdateLastRunning VARCHAR(MAX)
									SET @tSQLUpdateLastRunning =  ' UPDATE TCNTAutoHisTxn SET  '
									SET @tSQLUpdateLastRunning += ' FNAhnLastRunning = '''+@tRunningNo+'''  '
									SET @tSQLUpdateLastRunning += ' WHERE FTAhmTblName = '''+@ptTblName+'''  '
									SET @tSQLUpdateLastRunning += ' AND FTSatStaDocType = '''+@ptDocType+''' '
									SET @tSQLUpdateLastRunning += ' AND FTAgnCode = '''+@tAGNCode+''' '

									--PRINT (@tSQLUpdateLastRunning)
									EXECUTE(@tSQLUpdateLastRunning)

							END
						ELSE
							BEGIN
								--ถ้ายังไม่มีการใช้เลขที่เอกสารนี้ไปแล้วให้ใช้เลขที่เดิม
								SELECT @tPreviousDocNo AS FTXxhDocNo
								
							END


						END
					ELSE
					BEGIN
						SELECT @tNextDocNo AS FTXxhDocNo
					END

					
			END
	-------------------------------------------------------------------------------------------------------------------------------------------		     
	END TRY
	BEGIN CATCH
		return -1
	END CATCH
GO







IF EXISTS(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxSalByMerShp')and 
OBJECTPROPERTY(id, N'IsProcedure') = 1) BEGIN
	DROP PROCEDURE [dbo].SP_RPTxSalByMerShp
END
GO
CREATE PROCEDURE [dbo].[SP_RPTxSalByMerShp]
   @tUseSession varchar(255),
   @tLangID varchar(1),
   @tBchCode varchar(4000),
   @tMerCode varchar(30),
   @tShpCode varchar(4000),
   @tDateF varchar(30),
   @tDateT varchar(30),
   @tPdtCodeF varchar(30),
   @tPdtCodeT varchar(30)
AS
BEGIN TRY
   --SELECT * FROM TRPTSalByMerShpTmp
   DECLARE @tSQL VARCHAR(MAX)
   SET @tSQL = ''

   DECLARE @tSQLFilter VARCHAR(MAX)
   SET @tSQLFilter = ''

   IF (@tBchCode <> '' OR @tBchCode <> NULL)
		BEGIN
			SET @tSQLFilter += ' AND HD.FTBchCode IN(' + @tBchCode + ' ) '
		END	

 --  IF (@tMerCode <> '' OR @tMerCode <> NULL)
--		BEGIN
--			SET @tSQLFilter += ' AND SHP.FTMerCode =''' + @tMerCode + ''' '
--		END	

   IF (@tShpCode <> '' OR @tShpCode <> NULL)
		BEGIN
			SET @tSQLFilter += ' AND HD.FTShpCode IN(' + @tShpCode + ')'
		END	
   
   IF ((@tDateF <> '' OR @tDateF <> NULL) AND (@tDateT <> '' OR @tDateT <> NULL) )
		BEGIN
			SET @tSQLFilter += ' AND CONVERT(VARCHAR(10),HD.FDXshDocDate,121) BETWEEN  ''' + @tDateF + '''AND '''+ @tDateT + ''' '
		END	

   IF ((@tPdtCodeF <> '' OR @tPdtCodeF <> NULL) AND (@tPdtCodeT <> '' OR @tPdtCodeT <> NULL) )
		BEGIN
			SET @tSQLFilter += ' AND DT.FTPdtCode BETWEEN  ''' + @tPdtCodeF + ''' AND ''' +  @tPdtCodeT + ''''
		END	

	DECLARE @tSQLFilter2 VARCHAR(MAX)
	  SET @tSQLFilter2 = ''

	IF (@tMerCode <> '' OR @tMerCode <> NULL)
	 BEGIN
   SET @tSQLFilter2 += ' WHERE MER.FTMerCode =''' + @tMerCode + ''' '
	END


   DELETE FROM TRPTSalByMerShpTmp WHERE FTUsrSession = '' +@tUseSession+ ''

   SET @tSQL += ' INSERT INTO TRPTSalByMerShpTmp ' 
   SET @tSQL += ' SELECT '
		SET @tSQL += ' MER.FTMerCode '
		SET @tSQL += ' ,MER.FTMerName '
		SET @tSQL += ' ,S.FTShpCode '
		SET @tSQL += ' ,SHP.FTShpName '
		SET @tSQL += ' ,S.FTPdtCode '
		SET @tSQL += ' ,S.FTXsdPdtName '
		SET @tSQL += ' ,S.FTPunName '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN S.FCXsdQtyAll ELSE S.FCXsdQtyAll * -1 END ) AS FCXsdQtyAll '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN ISNULL(S.FCXsdAmtB4DisChg,0) ELSE ISNULL(S.FCXsdAmtB4DisChg,0) * -1 END ) AS FCXsdTotal '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN ISNULL(S.FCXddValue,0) ELSE ISNULL(S.FCXddValue,0) * -1 END ) AS FCXsdTotalDisChg '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN S.FCXsdNetAfHD ELSE S.FCXsdNetAfHD * -1 END ) /  '
		SET @tSQL += '  SUM(CASE WHEN S.FNXshDocType = 1 THEN S.FCXsdQtyAll ELSE S.FCXsdQtyAll * -1 END ) AS FCXsdPriAvg '
		SET @tSQL += ' ,SUM(CASE WHEN S.FNXshDocType = 1 THEN S.FCXsdNetAfHD ELSE S.FCXsdNetAfHD * -1 END ) AS FCXsdNetAfHD '
		SET @tSQL += ' , ' + ''''+@tUseSession+''''

		SET @tSQL += '  FROM ( '
				SET @tSQL += ' SELECT  '
				SET @tSQL += '  HD.FTXshDocNo '
				SET @tSQL += ' ,HD.FNXshDocType '
				SET @tSQL += ' ,HD.FTBchCode '
				SET @tSQL += ' ,SHP.FTMerCode '
				SET @tSQL += ' ,SHP.FTShpCode '
				SET @tSQL += ' ,DT.FTPdtCode '
				SET @tSQL += ' ,DT.FTXsdPdtName '
				SET @tSQL += ' ,DT.FCXsdQtyAll '
				SET @tSQL += ' ,DT.FTPunName '
				SET @tSQL += ' ,DT.FCXsdAmtB4DisChg '
				SET @tSQL += ' ,DIS.FCXddValue '
				SET @tSQL += ' ,DT.FCXsdNetAfHD '
				SET @tSQL += ' FROM TPSTSalDT DT '
				SET @tSQL += ' LEFT JOIN TPSTSalHD HD  ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo '
				SET @tSQL += ' LEFT JOIN TCNMShop SHP ON  HD.FTShpCode = SHP.FTShpCode '
				SET @tSQL += ' LEFT JOIN ( '

				SET @tSQL += ' SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo, '
				SET @tSQL += ' SUM(CASE WHEN FTXddDisChgType = ''3''  OR FTXddDisChgType = ''4'' THEN FCXddValue * -1 ELSE FCXddValue END) AS FCXddValue  '
				SET @tSQL += ' FROM TPSTSalDTDis '
				SET @tSQL += ' GROUP BY FTBchCode,FTXshDocNo,FNXsdSeqNo '

				SET @tSQL += ' ) DIS ON DT.FTBchCode = DIS.FTBchCode AND DT.FTXshDocNo = DIS.FTXshDocNo AND DT.FNXsdSeqNo = DIS.FNXsdSeqNo  '
				SET @tSQL += ' WHERE DT.FTXsdStaPdt <> ''4'' '

				SET @tSQL += @tSQLFilter

				--Filter
				--AND HD.FTBchCode IN('00001','00002')
				--AND HD.FTShpCode ='00001'
				--AND SHP.FTMerCode ='00001'
				--AND DT.FTPdtCode BETWEEN  '00002' AND '00003'
				--AND CONVERT(VARCHAR(10),HD.FDXshDocDate,121) BETWEEN  '2022-01-01' AND '2022-01-01'
		SET @tSQL += ' ) S  '
		SET @tSQL += ' LEFT JOIN TCNMPdtSpcBch PSB ON S.FTPdtCode = PSB.FTPdtCode '
		SET @tSQL += ' LEFT JOIN TCNMMerchant_L MER ON PSB.FTMerCode = MER.FTMerCode AND MER.FNLngID =  ' + @tLangID
		SET @tSQL += ' LEFT JOIN TCNMShop_L SHP ON  S.FTShpCode = SHP.FTShpCode AND SHP.FNLngID =   ' + @tLangID
		SET @tSQL += @tSQLFilter2
		SET @tSQL += ' GROUP BY MER.FTMerCode,MER.FTMerName,S.FTShpCode,SHP.FTShpName,S.FTPdtCode,S.FTXsdPdtName,S.FTPunName HAVING SUM (CASE WHEN S.FNXshDocType = 1 THEN S.FCXsdQtyAll ELSE S.FCXsdQtyAll * - 1 END)> 0 '

		--PRINT(@tSQL)
		execute(@tSQL)

   return 1

END TRY
BEGIN CATCH
	return -1
END CATCH
GO






IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCoCancelCrdNoReuse')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_PRCoCancelCrdNoReuse
GO
CREATE PROCEDURE [dbo].[STP_PRCoCancelCrdNoReuse]
	@pnBackDay INT
	, @FNResult INT OUTPUT AS
/*---------------------------------------------------------------------
Document History
Date			User		Remark
1.28/09/2022	Net			Create  
2.02/11/2022	Zen			เพิ่มเรื่อง ล้างบัตร
----------------------------------------------------------------------*/
DECLARE @tTrans varchar(20)
DECLARE @FTCrdCode varchar(30)
DECLARE @FTBchCode varchar(30)
DECLARE @Total decimal(18,4)
SET @tTrans = 'CancelReUse'
BEGIN TRY
    BEGIN TRANSACTION @tTrans

	DECLARE @dDate DATE
    SET @dDate = DATEADD(DAY ,@pnBackDay * -1, GETDATE())

	--ดึงข้อมูล
	DECLARE cursorCard CURSOR FOR
	SELECT distinct CRD.FTCrdCode,[dbo].[F_GETnCardTotal](CRD.FTCrdCode) Total,
	--(SELECT TOP 1 FTBchCode FROM TCNMBranch WHERE FTAgnCode = CRD.FTAgnCode) AS FTBchCode
	SAL.FTBchCode
	FROM TFNMCard CRD WITH(NOLOCK)
		INNER JOIN TFNMCardType CTY WITH(NOLOCK) ON
			CRD.FTCtyCode = CTY.FTCtyCode
		INNER JOIN TFNTCrdSale SAL WITH(NOLOCK) ON
			CRD.FTCrdCode = SAL.FTCrdCode 
			--AND SAL.FTTxnDocType NOT IN ('5','7','10')
		WHERE CRD.FTCrdStaActive = '1' AND CRD.FTCrdStaShift = '2'
			AND ISNULL(CTY.FTCtyStaCrdReuse, '') = '2'
			AND CONVERT(DATE,SAL.FDTxnDocDate) >= @dDate
			AND CRD.FDCrdExpireDate < GETDATE()

		-- เปิดการใช้งาน Cursor
		OPEN cursorCard 
		FETCH NEXT FROM cursorCard 
		INTO @FTCrdCode, @Total,@FTBchCode;

		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 

		DECLARE	@return_value int,
			@FNResultS int

		EXEC	@return_value = [dbo].[STP_SETnResetExpired]
				@ptBchCode = @FTBchCode,
				@ptCrdCode = @FTCrdCode,
				@ptPosCode = N'',
				@pcCrdValue = @Total,
				@ptDocNoRef = N'',
				@FNResult = @FNResultS OUTPUT

		FETCH NEXT FROM cursorCard 
			INTO @FTCrdCode, @Total,@FTBchCode;
		END

	CLOSE cursorCard; 
	DEALLOCATE cursorCard;
		
    UPDATE CRD
    SET FTCrdStaActive = '3'
    --SELECT *
    FROM TFNMCard CRD WITH(NOLOCK)
    INNER JOIN TFNMCardType CTY WITH(NOLOCK) ON
        CRD.FTCtyCode = CTY.FTCtyCode
    INNER JOIN TFNTCrdSale SAL WITH(NOLOCK) ON
        CRD.FTCrdCode = SAL.FTCrdCode 
        --AND SAL.FTTxnDocType NOT IN ('5','7','10')
    WHERE CRD.FTCrdStaActive = '1' AND CRD.FTCrdStaShift = '2'
        AND ISNULL(CTY.FTCtyStaCrdReuse, '') = '2'
        AND CONVERT(DATE,SAL.FDTxnDocDate) >= @dDate
        AND CRD.FDCrdExpireDate < GETDATE()
		
		COMMIT TRANSACTION @tTrans 
    SELECT ''
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans 
    SELECT ERROR_MESSAGE()
	SET @FNResult= -1
END CATCH
GO



IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCnTopupList')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_PRCnTopupList
GO
CREATE PROCEDURE [dbo].[STP_PRCnTopupList] 
	@ptBchCode VARCHAR(5) NUll,
	@ptCrdCode VARCHAR(20) NUll,
	@pcTxnValue  NUMERIC(18,4) NULL,
	@pcTxnValuePmt  NUMERIC(18,4) NULL,
	@pcTxnConditionPmt NUMERIC(18,4) NULL, 
	@pcTxnNoRfn NUMERIC(18,4) NULL, -- 05.02.00 --
	@ptTxnPosCode VARCHAR(5) NUll,
	@pcCrdValue NUMERIC(18,4) NULL,
	@ptShpCode  VARCHAR(5) NUll,
	@ptUsrCode VARCHAR(20) NUll,
	@ptDocNoRef VARCHAR(30) NUll,
	@ptDocPmtRef VARCHAR(30) NULL
AS
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
05.01.00	10/11/2020		Em		create 
05.02.00	14/12/2020		Net		เพิ่ม Para ยอดห้ามคืน  
05.03.00    04/01/2020		Zen		เพิ่ม Parameter ยอดเติมเงินที่ได้เงื่อนไข
05.04.00    01/10/2022		Net		เพิ่ม Insert ยอดห้ามคืน CrdTopUpFifo
05.05.00	21/10/2022		Zen		แก้เรื่องเคลีย TFNTCrdTopUp ก่อน ทำการ Insert
05.06.00	02/11/2022		Zen		ปรับให้ไม่มีการเคลีย แต่เป็นการเช็คข้อมูลก่อน Insert
----------------------------------------------------------------------*/
DECLARE @tTrans varchar(20)
DECLARE @nCount int
SET @tTrans = 'Topup'
BEGIN TRY
	BEGIN TRANSACTION @tTrans

	--DELETE TFNTCrdTopUp WHERE FTBchCode = @ptBchCode AND FTTxnDocNoRef = @ptDocNoRef
	--AND FTCrdCode = @ptCrdCode AND FTTxnDocType = '1'
	--05.06.00--
	IF NOT EXISTS (SELECT FTCrdCode FROM TFNTCrdTopUp WHERE FTTxnDocNoRef = @ptDocNoRef AND FTCrdCode = @ptCrdCode AND FTTxnDocType = '1')
	BEGIN
		INSERT INTO TFNTCrdTopUp WITH(ROWLOCK) 
		( 
			FTBchCode,FTTxnDocType,FTCrdCode 
			,FDTxnDocDate,FCTxnValue 
			,FTTxnStaPrc,FTTxnPosCode,FCTxnCrdValue,FCTxnPmt
			,FTShpCode ,FTTxnDocNoRef ,FTUsrCode
			,FCTxnNoRfn -- 05.02.00 --
		) 
		VALUES 
		( 
			@ptBchCode,'1',@ptCrdCode 
			,GETDATE(),@pcTxnValue 
			,'1',@ptTxnPosCode,@pcCrdValue,ISNULL(@pcTxnValuePmt,0)
			,@ptShpCode,@ptDocNoRef,@ptUsrCode     
			,@pcTxnNoRfn -- 05.02.00 --
		) 
	END	

	IF NOT EXISTS(SELECT FTCrdCode FROM TFNMCardBal WITH(NOLOCK) WHERE FTCrdCode = @ptCrdCode)
	BEGIN
		INSERT INTO TFNMCardBal(FTCrdCode,FTCrdTxnCode,FCCrdValue,FDLastUpdOn)
		SELECT @ptCrdCode,FTCrdTxnCode,0,GETDATE() FROM TFNSCrdBalType
	END 
    -- Update Master Card
    UPDATE TFNMCard WITH (ROWLOCK) 
	SET FDCrdResetDate = GETDATE() 
		,FDLastUpdOn = GETDATE()  
    WHERE FTCrdCode=@ptCrdCode

	UPDATE TFNMCardBal
	SET FCCrdValue = (ISNULL(FCCrdValue,0) + @pcTxnValue)
	WHERE FTCrdCode = @ptCrdCode 
	AND FTCrdTxnCode = '001'

	UPDATE TFNMCardBal
	SET FCCrdValue = ISNULL(CTP.FCCtyDeposit,0)
	FROM TFNMCardBal BAL
	INNER JOIN TFNMCard CRD WITH(NOLOCK) ON CRD.FTCrdCode = BAL.FTCrdCode
	INNER JOIN TFNMCardType CTP WITH(NOLOCK) ON CTP.FTCtyCode = CRD.FTCtyCode
	WHERE BAL.FTCrdCode = @ptCrdCode 
	AND BAL.FTCrdTxnCode = '003'

	IF ISNULL(@pcTxnValuePmt,0) > 0
	BEGIN
		UPDATE TFNMCardBal
		SET FCCrdValue = (ISNULL(FCCrdValue,0) + ISNULL(@pcTxnValuePmt,0))
		WHERE FTCrdCode = @ptCrdCode 
		AND FTCrdTxnCode = '002'

		INSERT INTO TFNTCrdTopUpFifo WITH(ROWLOCK) 
		(
			FTCrdCode ,FDDateTime ,FCPmcAmtPay,
			FCPmcAmtGet ,FCPmcAmtNot ,
			FCPmcNoRfnPay,FCPmcNoRfnGet,
			FCPmcAmtPayAvb ,FCPmcAmtGetAvb ,FCPmcAmtNotAvb,
			FDLastUpdOn ,FTLastUpdBy,FDCreateOn ,FTCreateBy
		)
		 SELECT @ptCrdCode,GETDATE(),@pcTxnConditionPmt,
		 @pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 @pcTxnConditionPmt,
		 @pcTxnValuePmt,
		 @pcTxnConditionPmt,@pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 GETDATE(),@ptUsrCode,GETDATE(),@ptUsrCode
		 FROM TFNTCrdPmtHD PmtHD
		 WHERE FTPmhDocNo = @ptDocPmtRef
		--SELECT * FROM TFNTCrdPmtHD
	END
	ELSE
	BEGIN
		INSERT INTO TFNTCrdTopUpFifo WITH(ROWLOCK) 
		(
			FTCrdCode ,FDDateTime ,FCPmcAmtPay,
			FCPmcAmtGet ,FCPmcAmtNot ,
			FCPmcNoRfnPay,FCPmcNoRfnGet,
			FCPmcAmtPayAvb ,FCPmcAmtGetAvb ,FCPmcAmtNotAvb,
			FDLastUpdOn ,FTLastUpdBy,FDCreateOn ,FTCreateBy
		)VALUES (
		 @ptCrdCode,GETDATE(),@pcTxnConditionPmt,
		 @pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 --0,
		 @pcTxnNoRfn, -- 05.04.00 --
		 0,
		 @pcTxnConditionPmt,@pcTxnValuePmt,(@pcTxnValue - @pcTxnConditionPmt),
		 GETDATE(),@ptUsrCode,GETDATE(),@ptUsrCode )
	END

	 -- 05.02.00 --
	IF ISNULL(@pcTxnNoRfn,0) > 0
	BEGIN
		UPDATE TFNMCardBal
		SET FCCrdValue = (ISNULL(FCCrdValue,0) + ISNULL(@pcTxnNoRfn,0))
		WHERE FTCrdCode = @ptCrdCode 
		AND FTCrdTxnCode = '005'
	END
	 -- 05.02.00 --
    
	
	COMMIT TRANSACTION @tTrans 

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans 
END CATCH
GO




IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCoCancelCrdNoReuse')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_PRCoCancelCrdNoReuse
GO
CREATE PROCEDURE [dbo].[STP_PRCoCancelCrdNoReuse]
	@pnBackDay INT
	, @FNResult INT OUTPUT AS
/*---------------------------------------------------------------------
Document History
Date			User		Remark
1.28/09/2022	Net			Create  
2.02/11/2022	Zen			เพิ่มเรื่อง ล้างบัตร
3.02/11/2022	Zen			แก้เรื่อง เงื่อนไขการเคลียบัตร
----------------------------------------------------------------------*/
DECLARE @tTrans varchar(20)
DECLARE @FTCrdCode varchar(30)
DECLARE @FTBchCode varchar(30)
DECLARE @Total decimal(18,4)
SET @tTrans = 'CancelReUse'
BEGIN TRY
    BEGIN TRANSACTION @tTrans

	DECLARE @dDate DATE
    SET @dDate = DATEADD(DAY ,@pnBackDay * -1, GETDATE())

	--ดึงข้อมูล
	DECLARE cursorCard CURSOR FOR
	SELECT distinct CRD.FTCrdCode,[dbo].[F_GETnCardTotal](CRD.FTCrdCode) Total,
	(SELECT TOP 1 FTBchCode FROM TCNMBranch WHERE FTAgnCode = CRD.FTAgnCode) AS FTBchCode
	--SAL.FTBchCode
	FROM TFNMCard CRD WITH(NOLOCK)
		INNER JOIN TFNMCardType CTY WITH(NOLOCK) ON
			CRD.FTCtyCode = CTY.FTCtyCode
		--INNER JOIN TFNTCrdSale SAL WITH(NOLOCK) ON
		--	CRD.FTCrdCode = SAL.FTCrdCode 
			--AND SAL.FTTxnDocType NOT IN ('5','7','10')
		WHERE CRD.FTCrdStaActive = '1' AND CRD.FTCrdStaShift = '2'
			AND ISNULL(CTY.FTCtyStaCrdReuse, '') IN ('2')
			--AND CONVERT(DATE,SAL.FDTxnDocDate) >= @dDate
			AND CRD.FDCrdExpireDate < GETDATE()

		-- เปิดการใช้งาน Cursor
		OPEN cursorCard 
		FETCH NEXT FROM cursorCard 
		INTO @FTCrdCode, @Total,@FTBchCode;

		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 

		IF @Total > 0
		BEGIN
			DECLARE	@return_value int,
					@FNResultS int

				EXEC	@return_value = [dbo].[STP_SETnResetExpired]
						@ptBchCode = @FTBchCode,
						@ptCrdCode = @FTCrdCode,
						@ptPosCode = N'',
						@pcCrdValue = @Total,
						@ptDocNoRef = N'',
						@FNResult = @FNResultS OUTPUT

				FETCH NEXT FROM cursorCard 
					INTO @FTCrdCode, @Total,@FTBchCode;
				END
		END
		

	CLOSE cursorCard; 
	DEALLOCATE cursorCard;
		
    -- 
    UPDATE CRD
    SET FTCrdStaActive = '3'
    --SELECT *
    FROM TFNMCard CRD WITH(NOLOCK)
    INNER JOIN TFNMCardType CTY WITH(NOLOCK) ON
        CRD.FTCtyCode = CTY.FTCtyCode
    INNER JOIN TFNTCrdSale SAL WITH(NOLOCK) ON
        CRD.FTCrdCode = SAL.FTCrdCode 
        --AND SAL.FTTxnDocType NOT IN ('5','7','10')
    WHERE CRD.FTCrdStaActive = '1' AND CRD.FTCrdStaShift = '2'
        AND ISNULL(CTY.FTCtyStaCrdReuse, '') = '2'
        AND CONVERT(DATE,SAL.FDTxnDocDate) >= @dDate
        AND CRD.FDCrdExpireDate < GETDATE()
		
		COMMIT TRANSACTION @tTrans 
    SELECT ''
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans 
    SELECT ERROR_MESSAGE()
	SET @FNResult= -1
END CATCH
GO





IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxIncomeNotReturnCardTmp')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].SP_RPTxIncomeNotReturnCardTmp
GO
CREATE PROCEDURE [dbo].[SP_RPTxIncomeNotReturnCardTmp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--Shop Code
	@ptShpL Varchar(8000), --กรณี Condition IN
	@ptShpF Varchar(10),
	@ptShpT Varchar(10),

    --Mer Code
	@ptMerL Varchar(8000), --กรณี Condition IN
	@ptMerF Varchar(10),
	@ptMerT Varchar(10),

	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),

	@FNResult INT OUTPUT

AS 

BEGIN TRY	

	-- Last Update : Napat(Jame) 05/10/2022 ตรวจสอบบัตรหมดอายุ FDCrdExpireDate

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql nVARCHAR(Max)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	
	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	--Shop Code
	DECLARE @tShpF Varchar(10)
	DECLARE @tShpT Varchar(10)

	--Mer Code
	DECLARE @tMerF Varchar(10)
	DECLARE @tMerT Varchar(10)

	--Pos Code
	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT

	--Shop
	SET @tShpF  = @ptShpF
	SET @tShpT  = @ptShpT

		--Mer
	SET @tMerF  = @ptShpF
	SET @tMerT  = @ptShpT

	--Pos
	SET @tPosF  = @ptPosF 
	SET @tPosT  = @ptPosT

	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult  = 0

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

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	--SET @tSql1 = ' WHERE CRD.FTCrdStaShift = ''2'' AND TOPUP.FDTxnDocDate >= DO.FDXshDocDate '
	SET @tSql1 = '  '

	IF @pnFilterType = '1'
		BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

	--	IF (@tMerF <> '' AND @tMerT <> '')
	--	BEGIN
			--SET @tSql1 +=' AND TOPUP.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
	--	END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END	
	END

	IF @pnFilterType = '2'
	BEGIN	
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode IN (' + @ptShpL + ')'
		END

	--	IF (@ptMerL <> '')
		--BEGIN
		--	SET @tSql1 +=' AND TOPUP.FTMerCode IN (' + @ptMerL + ')'
	--	END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode IN (' + @ptPosL + ')'
		END	
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
    SET @tSql1 +=' AND CONVERT(VARCHAR(10),TOPUP.FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	--SET @tSql1 += ' AND CONVERT(VARCHAR(10), TOPUP.FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''

	DELETE FROM TRPTIncomeNotReturnCardTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''


SET @tSql  = ' INSERT INTO TRPTIncomeNotReturnCardTmp (FTComName,FTRptCode,FTUsrSession, FTBchCode,FTBchName,FTCrdCode,FCTxnCrdValue,FCCrdClear,FCCrdTopUpAuto,FCCrdTxnPmt) '

SET @tSql += ' SELECT K.* FROM ('
SET @tSql += ' SELECT '''+ @nComName + ''' AS FTComName, '''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
SET @tSql += ' B.FTBchCode,BCH.FTBchName,B.FTCrdCode,'
--SET @tSql += ' CASE WHEN(B.CrdClear-B.CrdTopUpAuto-B.CrdTxnPmt)>0 THEN  B.CrdClear-B.CrdTopUpAuto-B.CrdTxnPmt ELSE 0 END AS FCCrdInCome,'
SET @tSql += ' CASE WHEN B.CrdTxnSale<B.CrdTopUpAuto THEN '
SET @tSql += ' B.CrdTopUpManual'
SET @tSql += ' WHEN B.CrdTxnSale>B.CrdTopUpAuto THEN '
SET @tSql += ' CASE WHEN (B.CrdClear  - B.CrdTxnPmt) > 0 THEN B.CrdClear - B.CrdTxnPmt ELSE 0 END'
SET @tSql += ' ELSE '
SET @tSql += ' CASE WHEN (	B.CrdClear - B.CrdTopUpAuto - B.CrdTxnPmt) > 0 THEN B.CrdClear - B.CrdTopUpAuto - B.CrdTxnPmt ELSE 0 END'
SET @tSql += ' END AS FCCrdInCome,'
SET @tSql += ' B.CrdClear,B.CrdTopUpAuto,B.CrdTxnPmt'
SET @tSql += ' FROM 	('



	SET @tSql += ' SELECT	M.FTBchCode,M.FTCrdCode,M.FDTxnDocDate,M.CrdClear,'
	SET @tSql += ' CASE WHEN L.FCTxnCrdBalAfTxn IS NOT NULL THEN L.FCTxnCrdBalAfTxn ELSE M.CrdTopUpAuto END AS CrdTopUpAuto,'
	SET @tSql += ' M.CrdTxnPmt,M.CrdTxnSale,M.CrdTopUpManual'
	SET @tSql += ' FROM ('
		SET @tSql += ' SELECT'
			SET @tSql += ' CONVERT(VARCHAR(10),A.FDTxnDocDate,120) AS FDTxnDocDate,'
			SET @tSql += ' A.FTBchCode,A.FTCrdCode,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''10'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0	END) AS CrdClear,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''1'' AND A.StaCrdAuto = ''1'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0 END) AS CrdTopUpAuto,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''1'' THEN ISNULL(A.FCTxnPmt, 0) ELSE 0 END) AS CrdTxnPmt,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''3'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0	END) AS CrdTxnSale,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''1'' AND A.StaCrdAuto=''2'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0 END) AS CrdTopUpManual'
		SET @tSql += ' FROM ('
				SET @tSql += ' SELECT'
					SET @tSql += ' TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,'
					SET @tSql += ' TOPUP.FDTxnDocDate,TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,TOPUP.FCTxnPmt,'
					SET @tSql += ' CASE	WHEN ISNULL(HD.FTXshRmk, '''') = ''Auto Topup'' THEN ''1'' ELSE ''2'' END AS StaCrdAuto'
				SET @tSql += ' FROM TFNTCrdTopUp TOPUP WITH (NOLOCK)'
				SET @tSql += ' LEFT JOIN TFNTCrdTopUpHD HD WITH (NOLOCK) ON HD.FTBchCode = TOPUP.FTBchCode AND HD.FTXshDocNo = TOPUP.FTTxnDocNoRef'
				SET @tSql += ' WHERE FTTxnDocType != ''5'' '
				SET @tSql += @tSql1
				SET @tSql += ' UNION ALL'
					SET @tSql += ' SELECT'
						SET @tSql += ' TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,'
						SET @tSql += ' TOPUP.FDTxnDocDate,TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,0 AS FCTxnPmt,''2'' AS StaCrdAuto'
					SET @tSql += ' FROM TFNTCrdSale TOPUP WITH (NOLOCK)'
					SET @tSql += ' WHERE	ISNULL(TOPUP.FTCrdCode, '''') != '''' '

					SET @tSql += @tSql1

			SET @tSql += ' ) A GROUP BY CONVERT(VARCHAR(10),A.FDTxnDocDate,120),A.FTBchCode,A.FTCrdCode ) M'
		SET @tSql += ' LEFT JOIN ('
		/* OPEN SUB */
				
		SET @tSql += ' SELECT C.* FROM ('
		SET @tSql += ' SELECT T.*,'
			SET @tSql += 'ROW_NUMBER() OVER (PARTITION BY CONVERT(VARCHAR(10),T.FDTxnDocDate,120),T.FTBchCode,T.FTCrdCode ORDER BY T.FCTxnCrdBalAfTxn ASC , T.FDTxnDocDate ASC) AS TopUpValueAuto'
			 SET @tSql += ' FROM ('
			SET @tSql += ' SELECT '
					SET @tSql += ' TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,'
					SET @tSql += ' CONVERT(VARCHAR(10),TOPUP.FDTxnDocDate,121) AS FDTxnDocDate,	TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,'
					SET @tSql += 'CASE WHEN TOPUP.FTTxnDocType =''1'' THEN  TOPUP.FCTxnCrdValue + TOPUP.FCTxnValue WHEN TOPUP.FTTxnDocType =''3'' THEN TOPUP.FCTxnCrdValue - TOPUP.FCTxnValue WHEN TOPUP.FTTxnDocType =''10'' THEN  TOPUP.FCTxnCrdValue - TOPUP.FCTxnValue END AS FCTxnCrdBalAfTxn,'
					SET @tSql += ' TOPUP.FCTxnPmt'
				SET @tSql += ' FROM TFNTCrdTopUp TOPUP WITH (NOLOCK)'
				SET @tSql += ' WHERE	FTTxnDocType != ''5'' ' 

				SET @tSql += @tSql1

				SET @tSql += ' UNION ALL'
					SET @tSql += ' SELECT'
						SET @tSql += ' TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,'
						SET @tSql += ' CONVERT(VARCHAR(10),TOPUP.FDTxnDocDate,121) AS FDTxnDocDate,TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,'
						SET @tSql += ' CASE WHEN TOPUP.FTTxnDocType =''1'' THEN  TOPUP.FCTxnCrdValue + TOPUP.FCTxnValue WHEN TOPUP.FTTxnDocType =''3'' THEN TOPUP.FCTxnCrdValue - TOPUP.FCTxnValue WHEN TOPUP.FTTxnDocType =''10'' THEN  TOPUP.FCTxnCrdValue - TOPUP.FCTxnValue END AS FCTxnCrdBalAfTxn,'
						SET @tSql += ' 0 AS FCTxnPmt'
						
					SET @tSql += ' FROM TFNTCrdSale TOPUP WITH (NOLOCK)'
					SET @tSql += ' WHERE ISNULL(TOPUP.FTCrdCode, '''') != '''' '

						SET @tSql += @tSql1


					SET @tSql += ' ) T	'

				SET @tSql += ' WHERE T.FTTxnDocType = ''3'' AND T.FCTxnCrdBalAfTxn = 0 ) C WHERE C.TopUpValueAuto = 1 '
					
		/* Close SUB */
		SET @tSql += ' ) L ON M.FTBchCode = L.FTBchCode AND M.FTCrdCode = L.FTCrdCode AND M.FDTxnDocDate = L.FDTxnDocDate '




SET @tSql += ' ) B'
SET @tSql += ' LEFT JOIN TCNMBranch_L BCH WITH(NOLOCK) ON B.FTBchCode = BCH.FTBchCode AND BCH.FNLngID = ''1''  '
SET @tSql += ') K '
SET @tSql += ' WHERE K.FCCrdInCome > 0 '
	--SELECT @tSql
	EXECUTE(@tSql)

END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO



IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_PRCoCancelCrdNoReuse')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_PRCoCancelCrdNoReuse
GO
CREATE PROCEDURE [dbo].[STP_PRCoCancelCrdNoReuse]
	@pnBackDay INT
	, @FNResult INT OUTPUT AS
/*---------------------------------------------------------------------
Document History
Date			User		Remark
1.28/09/2022	Net			Create  
2.02/11/2022	Zen			เพิ่มเรื่อง ล้างบัตร
3.02/11/2022	Zen			แก้เรื่อง เงื่อนไขการเคลียบัตร
4.04/11/2022	Zen			แก้ Process การล้างบัตร และ Reuse ใหม่
----------------------------------------------------------------------*/
DECLARE @tTrans varchar(20)
DECLARE @FTCrdCode varchar(30)
DECLARE @FTBchCode varchar(30)
DECLARE @Total decimal(18,4)
DECLARE @UsrCode varchar(30)
SET @tTrans = 'CancelReUse'
BEGIN TRY
    BEGIN TRANSACTION @tTrans

	DECLARE @dDate DATE
    SET @dDate = DATEADD(DAY ,@pnBackDay * -1, GETDATE())
	
	BEGIN	
	--ล้างบัตร และบัตรยังไม่ทำการคืน มีการตัดจ่าย
	DECLARE cursorCase1 CURSOR FOR
	SELECT distinct CRD.FTCrdCode,[dbo].[F_GETnCardTotal](CRD.FTCrdCode) Total,
	(SELECT TOP 1 FTBchCode FROM TCNMBranch WHERE FTAgnCode = CRD.FTAgnCode) AS FTBchCode
	--SAL.FTBchCode
	FROM TFNMCard CRD WITH(NOLOCK)
		INNER JOIN TFNMCardType CTY WITH(NOLOCK) ON
			CRD.FTCtyCode = CTY.FTCtyCode
		INNER JOIN TFNTCrdSale SAL WITH(NOLOCK) ON
			CRD.FTCrdCode = SAL.FTCrdCode 
			--AND SAL.FTTxnDocType NOT IN ('5','7','10')
		WHERE CRD.FTCrdStaActive = '1' AND CRD.FTCrdStaShift = '2'
			AND ISNULL(CTY.FTCtyStaCrdReuse, '') = '2'
			AND CONVERT(DATE,SAL.FDTxnDocDate) >= @dDate
			AND CRD.FDCrdExpireDate < GETDATE()

		-- เปิดการใช้งาน Cursor
		OPEN cursorCase1 
		FETCH NEXT FROM cursorCase1 
		INTO @FTCrdCode, @Total,@FTBchCode;

		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 

			IF @Total > 0
			BEGIN
				--SELECT * FROM TFNTCrdTopUp
				INSERT INTO TFNTCrdTopUp WITH(ROWLOCK)
				(
					FTBchCode,FTTxnDocType,FTCrdCode
					,FDTxnDocDate,FCTxnValue,FTTxnStaPrc
					,FTTxnPosCode,FCTxnCrdValue,FTTxnDocNoRef,FTUsrCode
				)
				VALUES
				(
					@FTBchCode ,'10',@FTCrdCode 
					,CONVERT(VARCHAR(10),@dDate,120) + ' 23:59:59',@Total,'1'
					,'',@Total,'','MQWalletPrc'
				)

				-- Update Master Card
				UPDATE TFNMCardBal WITH (ROWLOCK) SET
				FCCrdValue= 0
				WHERE FTCrdCode=@FTCrdCode

				DELETE TFNTCrdTopUpFifo WHERE FTCrdCode = @FTCrdCode
			
				UPDATE CRD
				SET FTCrdStaActive = '3'
				FROM TFNMCard CRD WITH(NOLOCK)
				WHERE FTCrdCode = @FTCrdCode

				
			END ELSE
			BEGIN
				UPDATE CRD
				SET FTCrdStaActive = '3'
				FROM TFNMCard CRD WITH(NOLOCK)
				WHERE FTCrdCode = @FTCrdCode
			END
			FETCH NEXT FROM cursorCase1 
			INTO @FTCrdCode, @Total,@FTBchCode;
		END
		

	CLOSE cursorCase1; 
	DEALLOCATE cursorCase1;
	END

	BEGIN	
	--* ล้างบัตร และบัตรยังไม่ทำการคืน และตัดจ่าย
	DECLARE cursorCase2 CURSOR FOR
	SELECT distinct CRD.FTCrdCode,[dbo].[F_GETnCardTotal](CRD.FTCrdCode) Total,
	(SELECT TOP 1 FTBchCode FROM TCNMBranch WHERE FTAgnCode = CRD.FTAgnCode) AS FTBchCode
	
	FROM TFNMCard CRD WITH(NOLOCK)
		INNER JOIN TFNMCardType CTY WITH(NOLOCK) ON
			CRD.FTCtyCode = CTY.FTCtyCode		
			--AND SAL.FTTxnDocType NOT IN ('5','7','10')
		WHERE CRD.FTCrdStaActive = '1' AND CRD.FTCrdStaShift = '2'
			AND ISNULL(CTY.FTCtyStaCrdReuse, '') = '2'
			AND CRD.FDCrdExpireDate < GETDATE()

		-- เปิดการใช้งาน Cursor
		OPEN cursorCase2 
		FETCH NEXT FROM cursorCase2 
		INTO @FTCrdCode, @Total,@FTBchCode;

		WHILE (@@FETCH_STATUS = 0) 
		BEGIN 

		IF @Total > 0
		BEGIN
			--กรณีบัตรหมดอายุ ยอดเงินมากกว่า 0 ถูกเบิก ไม่เอามาคืน 			
			IF (SELECT COUNT(FTCrdCode) 
			FROM TFNTCrdTopUp WITH(NOLOCK) 
			WHERE FTCrdCode = @FTCrdCode
			AND CONVERT(DATE,FDTxnDocDate) = CONVERT(DATE,@dDate)
			AND FTTxnDocType = 1) = 1
			BEGIN
				--กรณี เบิกบัตรไม่เอาไปคืน มียอดเงินอยู่ จะถูกเคลียข้อมูล
				--ถ้าเติมเงิน Auto ให้ Delete				
				DELETE TopUp
				FROM TFNTCrdTopUp TopUp WITH (ROWLOCK) 			
				WHERE TopUp.FTCrdCode = @FTCrdCode 
				AND TopUp.FTUsrCode = 'MQWalletPrc'
				AND CONVERT(DATE,TopUp.FDTxnDocDate) = CONVERT(DATE,@dDate)
				AND TopUp.FTTxnDocType = 1

				UPDATE TFNMCard 
				SET FTCrdStaShift = '1'
				WHERE FTCrdCode = @FTCrdCode

			END ELSE
			BEGIN
				--กรณี เบิกบัตรไม่เอาไปคืน เพราะลูกค้า เติมเงิน ไม่มีการใช้จ่าย ไม่ Checkout
				--บัตรจะทำการล้างบัตร 
				INSERT INTO TFNTCrdTopUp WITH(ROWLOCK)
				(
					FTBchCode,FTTxnDocType,FTCrdCode
					,FDTxnDocDate,FCTxnValue,FTTxnStaPrc
					,FTTxnPosCode,FCTxnCrdValue,FTTxnDocNoRef,FTUsrCode
				)
				VALUES
				(
					@FTBchCode ,'10',@FTCrdCode 
					,CONVERT(VARCHAR(10),@dDate,120) + ' 23:59:59',@Total,'1'
					,'',@Total,'','MQWalletPrc'
				)
			END
			-- Update Master Card
			UPDATE TFNMCardBal WITH (ROWLOCK) SET
			FCCrdValue= 0
			WHERE FTCrdCode=@FTCrdCode

			DELETE TFNTCrdTopUpFifo WITH (ROWLOCK) WHERE FTCrdCode = @FTCrdCode
			
			-- บัตรจะถูกยกเลิก
			UPDATE CRD
			SET FTCrdStaActive = '3'--,FTCrdStaShift = '1'
			FROM TFNMCard CRD WITH(NOLOCK)
			WHERE FTCrdCode = @FTCrdCode

			
			END
			ELSE
			BEGIN
				--กรณีบัตรหมดอายุ ยอดเงินเป็น 0 ถูกเบิก ไม่เอามาคืน 
				--บัตรจะถูกยกเลิก
				UPDATE CRD
				SET FTCrdStaActive = '3'--,FTCrdStaShift = '1'
				FROM TFNMCard CRD WITH(NOLOCK)
				WHERE FTCrdCode = @FTCrdCode
			END

			FETCH NEXT FROM cursorCase2 
			INTO @FTCrdCode, @Total,@FTBchCode;
		END
		

	CLOSE cursorCase2; 
	DEALLOCATE cursorCase2;
    END
	-- 
    --UPDATE CRD
    --SET FTCrdStaActive = '3'
    ----SELECT *
    --FROM TFNMCard CRD WITH(NOLOCK)
    --INNER JOIN TFNMCardType CTY WITH(NOLOCK) ON
    --    CRD.FTCtyCode = CTY.FTCtyCode
    --INNER JOIN TFNTCrdSale SAL WITH(NOLOCK) ON
    --    CRD.FTCrdCode = SAL.FTCrdCode 
    --    --AND SAL.FTTxnDocType NOT IN ('5','7','10')
    --WHERE CRD.FTCrdStaActive = '1' AND CRD.FTCrdStaShift = '2'
    --    AND ISNULL(CTY.FTCtyStaCrdReuse, '') = '2'
    --    AND CONVERT(DATE,SAL.FDTxnDocDate) >= @dDate
    --    AND CRD.FDCrdExpireDate < GETDATE()
		
		COMMIT TRANSACTION @tTrans 
    SELECT ''
	SET @FNResult= 0
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION @tTrans 
    SELECT ERROR_MESSAGE()
	SET @FNResult= -1
END CATCH
GO




IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'STP_GEToCrdHistory')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].STP_GEToCrdHistory
GO
CREATE PROCEDURE [dbo].[STP_GEToCrdHistory] 
	@pnTop INT NULL,
	@ptBchCode  VARCHAR(5) NULL,
	@ptCrdCode  VARCHAR(20) NULL,
	@ptTxnDocDate VARCHAR(10) NULL,
	@pnLngID INT NULL
AS
/*---------------------------------------------------------------------
Document History
Version		Date			User	Remark
05.01.00	11/11/2020		Em		create  
05.02.00	14/12/2020		Em		เพิ่ม FCTxnNoRfn
05.03.00	04/11/2022		Zen		ปรับ Process ตอนแสดงข้อมูล
----------------------------------------------------------------------*/
DECLARE @tSql NVARCHAR(MAX)
BEGIN
	SET @tSql = 'SELECT TOP(' + CAST(@pnTop AS VARCHAR) + ') FDTxnDocDate,FTTxnDocType,ISNULL(TTL.FTTxnName,'''') AS FTTxnName,ISNULL(FTShpName,'''') AS FTShpName,FTTxnPosCode,FCTxnCrdValue,FCTxnValue,FCTxnPmt,ISNULL(USR.FTUsrName,'''') AS FTUsrName' + CHAR(10)
	SET @tSql += ',FCTxnNoRfn'+ CHAR(10)	-- 05.02.00 --
	SET @tSql += 'FROM ' + CHAR(10)
	SET @tSql += '	(SELECT FTBchCode,FDTxnDocDate,FTTxnDocType,FTShpCode,FTTxnPosCode,FCTxnCrdValue,FCTxnValue,ISNULL(FCTxnPmt,0) AS FCTxnPmt,FTUsrCode ' + CHAR(10)
	SET @tSql += '	,ISNULL(FCTxnNoRfn,0) AS FCTxnNoRfn'+ CHAR(10)	-- 05.02.00 --
	SET @tSql += '	FROM TFNTCrdTopUp WITH(NOLOCK) ' + CHAR(10)
	SET @tSql += '	WHERE FTBchCode = '''+ @ptBchCode + ''' AND FTCrdCode = ''' + @ptCrdCode + '''' + CHAR(10)
	SET @tSql += '	UNION' + CHAR(10)
	SET @tSql += '	SELECT FTBchCode,FDTxnDocDate,FTTxnDocType,FTShpCode,FTTxnPosCode,FCTxnCrdValue,FCTxnValue ,0 AS FCTxnPmt,FTUsrCode' + CHAR(10)
	SET @tSql += '	,0 AS FCTxnNoRfn'+ CHAR(10)	-- 05.02.00 --
	SET @tSql += '	FROM TFNTCrdSale WITH(NOLOCK)' + CHAR(10)
	--SET @tSql += '	WHERE FTBchCode = ''' + @ptBchCode + ''' AND FTCrdCode = ''' + @ptCrdCode + '''' + CHAR(10)-- 05.03.00
	SET @tSql += '	WHERE FTTxnDocType != 5 AND FTBchCode = ''' + @ptBchCode + ''' AND FTCrdCode = ''' + @ptCrdCode + '''' + CHAR(10)
	SET @tSql += '	UNION' + CHAR(10)
	SET @tSql += '	SELECT FTBchCode,FDTxnDocDate,FTTxnDocType,FTShpCode,FTTxnPosCode,FCTxnCrdValue,FCTxnValue ,ISNULL(FCTxnPmt,0) AS FCTxnPmt,FTUsrCode' + CHAR(10)
	SET @tSql += '	,ISNULL(FCTxnNoRfn,0) AS FCTxnNoRfn'+ CHAR(10)	-- 05.02.00 --
	SET @tSql += '	FROM TFNTCrdHis WITH(NOLOCK)' + CHAR(10)
	SET @tSql += '	WHERE FTBchCode = ''' + @ptBchCode + ''' AND FTCrdCode = ''' + @ptCrdCode + ''') CRD' + CHAR(10)
	SET @tSql += 'INNER JOIN TFNSTxnType_L TTL WITH(NOLOCK) ON TTL.FTTxnType = CRD.FTTxnDocType AND TTL.FNLngID = ' +  CAST(@pnLngID AS VARCHAR) + CHAR(10)
	SET @tSql += 'LEFT JOIN TCNMShop_L SHP WITH(NOLOCK) ON SHP.FTBchCode = CRD.FTBchCode AND SHP.FTShpCode = CRD.FTShpCode AND SHP.FNLngID = ' +  CAST(@pnLngID AS VARCHAR) + CHAR(10)
	SET @tSql += 'LEFT JOIN TCNMUser_L USR WITH(NOLOCK) ON USR.FTUsrCode = CRD.FTUsrCode AND USR.FNLngID = '+ CAST(@pnLngID AS VARCHAR) + CHAR(10)
	
	IF ISNULL(@ptTxnDocDate,'') <> '' BEGIN
		SET @tSql += 'WHERE CONVERT(VARCHAR(10), CRD.FDTxnDocDate, 121) = ''' + @ptTxnDocDate + '''' + CHAR(10)
	END

	SET @tSql += 'ORDER BY FDTxnDocDate DESC' + CHAR(10)

	EXECUTE sp_executesql @tSql
	Print  @tSql
END
GO



IF EXISTS
(SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_RPTxIncomeNotReturnCardTmp')and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].SP_RPTxIncomeNotReturnCardTmp
GO
CREATE PROCEDURE [dbo].[SP_RPTxIncomeNotReturnCardTmp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--Shop Code
	@ptShpL Varchar(8000), --กรณี Condition IN
	@ptShpF Varchar(10),
	@ptShpT Varchar(10),

    --Mer Code
	@ptMerL Varchar(8000), --กรณี Condition IN
	@ptMerF Varchar(10),
	@ptMerT Varchar(10),

	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),

	@FNResult INT OUTPUT

AS 

BEGIN TRY	

	-- Last Update : Napat(Jame) 05/10/2022 ตรวจสอบบัตรหมดอายุ FDCrdExpireDate

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql nVARCHAR(Max)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	
	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	--Shop Code
	DECLARE @tShpF Varchar(10)
	DECLARE @tShpT Varchar(10)

	--Mer Code
	DECLARE @tMerF Varchar(10)
	DECLARE @tMerT Varchar(10)

	--Pos Code
	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT

	--Shop
	SET @tShpF  = @ptShpF
	SET @tShpT  = @ptShpT

		--Mer
	SET @tMerF  = @ptShpF
	SET @tMerT  = @ptShpT

	--Pos
	SET @tPosF  = @ptPosF 
	SET @tPosT  = @ptPosT

	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult  = 0

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

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	--SET @tSql1 = ' WHERE CRD.FTCrdStaShift = ''2'' AND TOPUP.FDTxnDocDate >= DO.FDXshDocDate '
	SET @tSql1 = '  '

	IF @pnFilterType = '1'
		BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

	--	IF (@tMerF <> '' AND @tMerT <> '')
	--	BEGIN
			--SET @tSql1 +=' AND TOPUP.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
	--	END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END	
	END

	IF @pnFilterType = '2'
	BEGIN	
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode IN (' + @ptShpL + ')'
		END

	--	IF (@ptMerL <> '')
		--BEGIN
		--	SET @tSql1 +=' AND TOPUP.FTMerCode IN (' + @ptMerL + ')'
	--	END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode IN (' + @ptPosL + ')'
		END	
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
    SET @tSql1 +=' AND CONVERT(VARCHAR(10),TOPUP.FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	--SET @tSql1 += ' AND CONVERT(VARCHAR(10), TOPUP.FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''

	DELETE FROM TRPTIncomeNotReturnCardTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''


SET @tSql  = ' INSERT INTO TRPTIncomeNotReturnCardTmp (FTComName,FTRptCode,FTUsrSession, FTBchCode,FTBchName,FTCrdCode,FCTxnCrdValue,FCCrdClear,FCCrdTopUpAuto,FCCrdTxnPmt) '

SET @tSql += ' SELECT K.* FROM ('
SET @tSql += ' SELECT '''+ @nComName + ''' AS FTComName, '''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
SET @tSql += ' B.FTBchCode,BCH.FTBchName,B.FTCrdCode,'
SET @tSql += ' CASE WHEN B.CrdTxnSale<B.CrdTopUpAuto THEN B.CrdTopUpManual ELSE  CASE WHEN (B.CrdClear  - B.CrdTxnPmt) > 0 THEN B.CrdClear - B.CrdTxnPmt ELSE 0 END END AS FCCrdInCome,'

SET @tSql += ' B.CrdClear,B.CrdTopUpAuto,B.CrdTxnPmt'
SET @tSql += ' FROM 	('




	SET @tSql += ' SELECT	M.FTBchCode,M.FTCrdCode,M.FDTxnDocDate,M.CrdClear,'
	SET @tSql += ' M.CrdTopUpAuto,'
	SET @tSql += ' M.CrdTxnPmt,M.CrdTxnSale,M.CrdTopUpManual'
	SET @tSql += ' FROM ('
		SET @tSql += ' SELECT'
			SET @tSql += ' CONVERT(VARCHAR(10),A.FDTxnDocDate,120) AS FDTxnDocDate,'
			SET @tSql += ' A.FTBchCode,A.FTCrdCode,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''10'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0	END) AS CrdClear,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''1'' AND A.StaCrdAuto = ''1'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0 END) AS CrdTopUpAuto,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''1'' THEN ISNULL(A.FCTxnPmt, 0) ELSE 0 END) AS CrdTxnPmt,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''3'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0	END) AS CrdTxnSale,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''1'' AND A.StaCrdAuto=''2'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0 END) AS CrdTopUpManual'
		SET @tSql += ' FROM ('
				SET @tSql += ' SELECT'
					SET @tSql += ' TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,'
					SET @tSql += ' TOPUP.FDTxnDocDate,TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,TOPUP.FCTxnPmt,'
					SET @tSql += ' CASE	WHEN ISNULL(HD.FTXshRmk, '''') = ''Auto Topup'' THEN ''1'' ELSE ''2'' END AS StaCrdAuto'
				SET @tSql += ' FROM TFNTCrdTopUp TOPUP WITH (NOLOCK)'
				SET @tSql += ' LEFT JOIN TFNTCrdTopUpHD HD WITH (NOLOCK) ON HD.FTBchCode = TOPUP.FTBchCode AND HD.FTXshDocNo = TOPUP.FTTxnDocNoRef'
				SET @tSql += ' WHERE FTTxnDocType != ''5'' '
				SET @tSql += @tSql1
				SET @tSql += ' UNION ALL'
					SET @tSql += ' SELECT'
						SET @tSql += ' TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,'
						SET @tSql += ' TOPUP.FDTxnDocDate,TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,0 AS FCTxnPmt,''2'' AS StaCrdAuto'
					SET @tSql += ' FROM TFNTCrdSale TOPUP WITH (NOLOCK)'
					SET @tSql += ' WHERE	ISNULL(TOPUP.FTCrdCode, '''') != '''' '

					SET @tSql += @tSql1

			SET @tSql += ' ) A GROUP BY CONVERT(VARCHAR(10),A.FDTxnDocDate,120),A.FTBchCode,A.FTCrdCode ) M'


SET @tSql += ' ) B'
SET @tSql += ' LEFT JOIN TCNMBranch_L BCH WITH(NOLOCK) ON B.FTBchCode = BCH.FTBchCode AND BCH.FNLngID = ''1''  '
SET @tSql += ') K '
SET @tSql += ' WHERE K.FCCrdInCome > 0 '
	--SELECT @tSql
	EXECUTE(@tSql)

END TRY

BEGIN CATCH 
	SET @FNResult= -1
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
								SET @tSQLMaster += ' Products.FTPbnCode,'
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

						 IF @tFilterBy = 'FTPbnCode' AND @tSearch <> '' BEGIN
						   	SET @tSQLMaster += ' LEFT JOIN TCNMPdtBrand_L PBNL WITH (NOLOCK)    ON Products.FTPbnCode = PBNL.FTPbnCode   AND PBNL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '--//หาประเภทสินค้า
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


							IF @tFilterBy = 'FTPbnCode' AND @tSearch <> '' BEGIN
									SET @tSQLMaster += ' AND ( PBNL.FTPbnCode = ''' + @tSearch + ''' OR PBNL.FTPbnName COLLATE THAI_BIN LIKE ''%' + @tSearch + '%'' )' --//ยี่ห้อ
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

							IF (SELECT FTSysStaUsrValue FROM TSysConfig WHERE FTSysCode = 'tCN_AlwSeePdtCenter')<>'2' BEGIN
								-- //---------------------- การมองเห็นสินค้าระดับส่วนกลางหรือสินค้าที่ไม่ได้ผูกกับอะไรเลย--------------------------//
												SET @tSQLMaster += ' OR ('
												--SET @tSQLMaster += ' Products.FTPtyCode != ''00005'' '
												SET @tSQLMaster += ' ISNULL(PDLSPC.FTAgnCode,'''') = '''' '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTMerCode,'''') = '''' '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTBchCode,'''') = '''' '
												SET @tSQLMaster += ' AND ISNULL(PDLSPC.FTShpCode,'''') = '''' '
												SET @tSQLMaster += ' )'
								-- |-------------------------------------------------------------------------------------------| 
							END
													SET @tSQLMaster += ' )'
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


/****** Object:  StoredProcedure [dbo].[SP_RPTxPdtHisTnfWah]    Script Date: 11/11/2022 18:20:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPdtHisTnfWah]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPdtHisTnfWah
GO
CREATE PROCEDURE SP_RPTxPdtHisTnfWah 
--ALTER PROCEDURE [dbo].[SP_RPTxPdtHisTnfWah]
        @pnLngID int , 
        @pnComName Varchar(100),
        @ptRptCode Varchar(100),
        @ptUsrSession Varchar(255),
        @pnFilterType int, --1 BETWEEN 2 IN
        @ptAgnCode VARCHAR(20),
        --สาขา
        @ptBchL Varchar(8000),

        --คลังต้นทาง SOURCE
        @ptWahSF Varchar(20), 
        @ptWahST Varchar(20),

        --คลังปลายทาง Destination
        @ptWahDF Varchar(20), 
        @ptWahDT Varchar(20),

        --@ptWahL Varchar(8000),
        --สินค้า
        @ptPdtF Varchar(20),
        @ptPdtT Varchar(20),

		--14/11/2022
		--กลุ่มสินค้า
		@ptPdtChanF Varchar(30),
		@ptPdtChanT Varchar(30),
		--ประเภทสินค้า
		@ptPdtTypeF Varchar(5),
		@ptPdtTypeT Varchar(5),

		--NUI 22-09-05 RQ2208-020
		--ยี่ห้อ
		@ptPbnF Varchar(5),
		@ptPbnT Varchar(5),

        --วันที่โออนออก FDLastUpdOn
        @ptDocDateF Varchar(10), 
        @ptDocDateT Varchar(10), 
        @FNResult INT OUTPUT 
    AS
	--------------------------------------
-- Modify By Watcharakorn 
-- V 02.00.00
-- V 01.00.00
-- Create ไม่ได้ระบุ
-- Modify 14/11/2022
-- Temp name  TRPTPdtHisTnfWahTmp
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
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
        DECLARE @tSql1 VARCHAR(8000)

        DECLARE @tBchF Varchar(5)
        DECLARE @tBchT Varchar(5)
        DECLARE @tWahF Varchar(5)
        DECLARE @tWahT Varchar(5)
        DECLARE @tPdtF Varchar(20)
        DECLARE @tPdtT Varchar(20)
		DECLARE @tPdtChanF Varchar(30)
		DECLARE @tPdtChanT Varchar(30)
		DECLARE @tPdtTypeF Varchar(5)
		DECLARE @tPdtTypeT Varchar(5)

		DECLARE @tPbnF Varchar(5)
		DECLARE @tPbnT Varchar(5)

		SET @tPdtChanF = @ptPdtChanF
		SET @tPdtChanT = @ptPdtChanT 
		SET @tPdtTypeF = @ptPdtTypeF
		SET @tPdtTypeT = @ptPdtTypeT

		SET @tPbnF = @ptPbnF
		SET @tPbnT = @ptPbnT

        SET @nLngID = @pnLngID
        SET @nComName = @pnComName
        SET @tUsrSession = @ptUsrSession
        SET @tRptCode = @ptRptCode

        --SET @tBchF = @ptBchF
        --SET @tBchT = @ptBchT
        --SET @tWahF = @ptWahF
        --SET @tWahT = @ptWahT


        SET @tPdtF = @ptPdtF
        SET @tPdtT = @ptPdtT

        SET @ptDocDateF = CONVERT(VARCHAR(10),@ptDocDateF,121)
        SET @ptDocDateT = CONVERT(VARCHAR(10),@ptDocDateT,121)

        SET @FNResult= 0


        IF @nLngID = null
        BEGIN
            SET @nLngID = 1
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

        IF @tBchF = null
        BEGIN
            SET @tBchF = ''
        END
        IF @tBchT = null OR @tBchT = ''
        BEGIN
            SET @tBchT = @tBchF
        END

        --Branch
        IF @ptBchL = null
        BEGIN
            SET @ptBchL = ''
        END

        ------------------
        IF @ptWahSF = null
        BEGIN
            SET @ptWahSF = ''
        END 
        IF @ptWahST = null OR @ptWahST =''
        BEGIN
            SET @ptWahST = @ptWahSF
        END 

        IF @ptWahDF = null
        BEGIN
            SET @ptWahDF = ''
        END 
        IF @ptWahDT = null OR @ptWahDT =''
        BEGIN
            SET @ptWahDT = @ptWahDF
        END 


        IF @tPdtF = null
        BEGIN
            SET @tPdtF = ''
        END 
        IF @tPdtT = null OR @tPdtT =''
        BEGIN
            SET @tPdtT = @tPdtF
        END 


        SET @tSql1 =   ' '
        --SET @tSql1 +=' WHERE 1=1 AND TFW.FNXthStaDocAct = 1 '
        SET @tSql1 +=' WHERE 1=1 AND TFW.FTXthStaDoc = 1 AND TFW.FTXthStaApv = 1 '
        IF @pnFilterType = '2'
        BEGIN
            IF (@ptBchL <> '' )
            BEGIN
                SET @tSql1 +=' AND TFW.FTBchCode IN (' + @ptBchL + ')'
            END	

        END

        --IF (@ptWahL <> '')
        --BEGIN
        --	SET @tSql1 +=' AND HD.FTXthWhFrm IN (' + @ptWahL + ')'
        --END

        IF (@ptWahSF <> '' )
        BEGIN
            SET @tSql1 +=' AND TFW.FTXthWhFrm BETWEEN ''' + @ptWahSF + '''  AND ''' + @ptWahST + ''''
        END

		IF (@ptWahDF <> '' )
		BEGIN
            SET @tSql1 +=' AND TFW.FTXthWhTo BETWEEN ''' + @ptWahDF + '''  AND ''' + @ptWahDT + ''''
        END
        --    F (@ptWahT <> '')
        --BEGIN
        --        SET @tSql1 +=' AND TFW.FTXthWhTo = ''' + @ptWahT + ''' '
        --END

        IF (@tPdtF <> '' AND @tPdtT <> '')
        BEGIN
            SET @tSql1 +=' AND TFWDT.FTPdtCode BETWEEN ''' + @tPdtF + ''' AND ''' + @tPdtT + ''''
        END


	IF (@tPdtChanF <> '' AND @tPdtChanT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tPbnF <> '' AND @tPbnT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
	END


        IF (@ptDocDateF <> '' AND @ptDocDateT <> '')
        BEGIN
            SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXthDocDate,121) BETWEEN ''' + @ptDocDateF + ''' AND ''' + @ptDocDateT + ''''
        END

    DELETE FROM TRPTPdtHisTnfWahTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''
    SET @tSql = ' INSERT INTO TRPTPdtHisTnfWahTmp'
    SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
    SET @tSql+=' FTBchCode, FTBchName, FTXthDocNo, FDXthDocDate, FTXthWhFrm,  FTWahNameFrm, FTXthWhTo,FTWahNameTo,  '
    SET @tSql+=' FTXthApvCode,  FTUsrName,FTPdtCode,FTXtdPdtName,  FTPunName,FTXtdBarCode,FCXtdQty,FTPbnCode,FTPbnName '
    SET @tSql +=' )'
    SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'       
    SET @tSql+=' FTBchCode, FTBchName, FTXthDocNo, FDXthDocDate, FTXthWhFrm,  FTWahNameFrm, FTXthWhTo,FTWahNameTo,'
    SET @tSql+=' FTXthApvCode,  FTUsrName,FTPdtCode,FTXtdPdtName,  FTPunName,FTXtdBarCode,FCXtdQty,FTPbnCode,FTPbnName '
    SET @tSql +=' FROM'
    SET @tSql +=' ('			
    SET @tSql+=' SELECT TFW.FTBchCode, BCHL.FTBchName,  TFW.FTXthDocNo, TFW.FDXthDocDate, TFW.FTXthWhFrm,  WahLF.FTWahName AS FTWahNameFrm, TFW.FTXthWhTo, WahLT.FTWahName AS FTWahNameTo,'
    SET @tSql+=' TFW.FTXthApvCode,  USRLAPV.FTUsrName,TFWDT.FTPdtCode, TFWDT.FTXtdPdtName,  TFWDT.FTPunName, TFWDT.FTXtdBarCode,TFWDT.FCXtdQty, '
	SET @tSql+=' Pdt.FTPbnCode,PbnL.FTPbnName'
    SET @tSql+=' FROM TCNTPdtTwxHD TFW WITH(NOLOCK) '
    SET @tSql+=' LEFT JOIN TCNTPdtTwxDT TFWDT WITH(NOLOCK) ON TFW.FTXthDocNo = TFWDT.FTXthDocNo'
	SET @tSql+=' LEFT JOIN TCNMPdt Pdt WITH (NOLOCK) ON TFWDT.FTPdtCode = Pdt.FTPdtCode '
    SET @tSql+=' LEFT JOIN TCNMBranch_L BCHL WITH(NOLOCK) ON TFW.FTBchCode = BCHL.FTBchCode
                                                    AND BCHL.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + ''''
    SET @tSql+=' LEFT JOIN TCNMUser_L USRL WITH(NOLOCK) ON TFW.FTCreateBy = USRL.FTUsrCode
                                                AND USRL.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + ''''
    SET @tSql+=' LEFT JOIN TCNMUser_L USRLAPV WITH(NOLOCK) ON TFW.FTXthApvCode = USRLAPV.FTUsrCode
                                                    AND USRLAPV.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + ''''
    SET @tSql+=' LEFT JOIN TCNMWahouse_L WahLT WITH(NOLOCK) ON TFW.FTBchCode = WahLT.FTBchCode
                                                    AND TFW.FTXthWhTo = WahLT.FTWahCode
                                                    AND WahLT.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + ''''
    SET @tSql+=' LEFT JOIN TCNMWahouse_L WahLF WITH(NOLOCK) ON TFW.FTBchCode = WahLF.FTBchCode
                                                    AND TFW.FTXthWhFrm = WahLF.FTWahCode
                                                    AND WahLF.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + ''''
	SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH (NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
    SET @tSql += @tSql1
    SET @tSql +=' ) TnfWah'
	--PRINT (@tSql)
    EXECUTE(@tSql)
    END TRY
    BEGIN CATCH 
        SET @FNResult= -1
    END CATCH	
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPackageCpnHisTmp]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPackageCpnHisTmp
GO
CREATE  PROCEDURE [dbo].[SP_RPTxPackageCpnHisTmp]
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
		--SET @tSQL += ' INNER JOIN TPSTSalHDDis DIS ON HD.FTBchCode = DIS.FTBchCode AND HD.FTXshDocNo = DIS.FTXshDocNo '
		SET @tSQL += ' INNER JOIN ('
		SET @tSQL += ' SELECT DIS.FTBchCode,DIS.FTXshDocNo,DIS.FTXhdRefCode,DIS.FTXhdDisChgType,SUM(DIS.FCXhdAmt) AS FCXhdAmt FROM TPSTSalHDDis DIS GROUP BY DIS.FTBchCode,DIS.FTXshDocNo,DIS.FTXhdRefCode,DIS.FTXhdDisChgType'
		SET @tSQL += ' ) DIS ON HD.FTBchCode = DIS.FTBchCode AND HD.FTXshDocNo = DIS.FTXshDocNo AND HIS.FTCpdBarCpn = DIS.FTXhdRefCode AND DIS.FTXhdDisChgType = ''5'' '
		--SET @tSQL += ' AND HIS.FTCpdBarCpn = DIS.FTXhdRefCode AND DIS.FTXhdDisChgType = ''5'' '
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
		--SET @tSQL += ' INNER JOIN TPSTSalHDDis D ON H.FTCpbFrmSalRef = D.FTXshDocNo AND H.FTCpdBarCpn = D.FTXhdRefCode AND D.FTXhdDisChgType = ''5'' '
		SET @tSQL += ' INNER JOIN ('
		SET @tSQL += ' SELECT DIS.FTBchCode,DIS.FTXshDocNo,DIS.FTXhdRefCode,DIS.FTXhdDisChgType,SUM(DIS.FCXhdAmt) AS FCXhdAmt FROM TPSTSalHDDis DIS GROUP BY DIS.FTBchCode,DIS.FTXshDocNo,DIS.FTXhdRefCode,DIS.FTXhdDisChgType'
		SET @tSQL += ' ) D ON H.FTBchCode = D.FTBchCode AND H.FTCpbFrmSalRef = D.FTXshDocNo AND H.FTCpdBarCpn = D.FTXhdRefCode AND D.FTXhdDisChgType = ''5'' '
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


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxIncomeNotReturnCardTmp]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxIncomeNotReturnCardTmp
GO
CREATE PROCEDURE [dbo].[SP_RPTxIncomeNotReturnCardTmp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN
	@ptBchF Varchar(5),
	@ptBchT Varchar(5),

	--Shop Code
	@ptShpL Varchar(8000), --กรณี Condition IN
	@ptShpF Varchar(10),
	@ptShpT Varchar(10),

    --Mer Code
	@ptMerL Varchar(8000), --กรณี Condition IN
	@ptMerF Varchar(10),
	@ptMerT Varchar(10),

	--เครื่องจุดขาย
	@ptPosL Varchar(8000), --กรณี Condition IN
	@ptPosF Varchar(20),
	@ptPosT Varchar(20),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),

	@FNResult INT OUTPUT

AS 

BEGIN TRY	

	-- Last Update : Napat(Jame) 05/10/2022 ตรวจสอบบัตรหมดอายุ FDCrdExpireDate

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql nVARCHAR(Max)
	DECLARE @tSqlIns VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	
	--Branch Code
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	--Shop Code
	DECLARE @tShpF Varchar(10)
	DECLARE @tShpT Varchar(10)

	--Mer Code
	DECLARE @tMerF Varchar(10)
	DECLARE @tMerT Varchar(10)

	--Pos Code
	DECLARE @tPosF Varchar(20)
	DECLARE @tPosT Varchar(20)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	SET @tBchF  = @ptBchF
	SET @tBchT  = @ptBchT

	--Shop
	SET @tShpF  = @ptShpF
	SET @tShpT  = @ptShpT

		--Mer
	SET @tMerF  = @ptShpF
	SET @tMerT  = @ptShpT

	--Pos
	SET @tPosF  = @ptPosF 
	SET @tPosT  = @ptPosT

	SET @tDocDateF = @ptDocDateF
	SET @tDocDateT = @ptDocDateT
	SET @FNResult  = 0

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

	IF @tPosF = null
	BEGIN
		SET @tPosF = ''
	END
	IF @tPosT = null OR @tPosT = ''
	BEGIN
		SET @tPosT = @tPosF
	END

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	--SET @tSql1 = ' WHERE CRD.FTCrdStaShift = ''2'' AND TOPUP.FDTxnDocDate >= DO.FDXshDocDate '
	SET @tSql1 = '  '

	IF @pnFilterType = '1'
		BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

	--	IF (@tMerF <> '' AND @tMerT <> '')
	--	BEGIN
			--SET @tSql1 +=' AND TOPUP.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
	--	END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END	
	END

	IF @pnFilterType = '2'
	BEGIN	
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND TOPUP.FTShpCode IN (' + @ptShpL + ')'
		END

	--	IF (@ptMerL <> '')
		--BEGIN
		--	SET @tSql1 +=' AND TOPUP.FTMerCode IN (' + @ptMerL + ')'
	--	END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSql1 += ' AND TOPUP.FTTxnPosCode IN (' + @ptPosL + ')'
		END	
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
    SET @tSql1 +=' AND CONVERT(VARCHAR(10),TOPUP.FDTxnDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	--SET @tSql1 += ' AND CONVERT(VARCHAR(10), TOPUP.FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''

	DELETE FROM TRPTIncomeNotReturnCardTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''


SET @tSql  = ' INSERT INTO TRPTIncomeNotReturnCardTmp (FTComName,FTRptCode,FTUsrSession, FTBchCode,FTBchName,FTCrdCode,FCTxnCrdValue,FCCrdClear,FCCrdTopUpAuto,FCCrdTxnPmt) '

SET @tSql += ' SELECT K.* FROM ('
SET @tSql += ' SELECT '''+ @nComName + ''' AS FTComName, '''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
SET @tSql += ' B.FTBchCode,BCH.FTBchName,B.FTCrdCode,'
SET @tSql += ' CASE WHEN B.CrdTxnSale<B.CrdTopUpAuto THEN B.CrdTopUpManual ELSE  CASE WHEN (B.CrdClear  - B.CrdTxnPmt) > 0 THEN B.CrdClear - B.CrdTxnPmt ELSE 0 END END AS FCCrdInCome,'

SET @tSql += ' B.CrdClear,B.CrdTopUpAuto,B.CrdTxnPmt'
SET @tSql += ' FROM 	('




	SET @tSql += ' SELECT	M.FTBchCode,M.FTCrdCode,M.FDTxnDocDate,M.CrdClear,'
	SET @tSql += ' M.CrdTopUpAuto,'
	SET @tSql += ' M.CrdTxnPmt,M.CrdTxnSale,M.CrdTopUpManual'
	SET @tSql += ' FROM ('
		SET @tSql += ' SELECT'
			SET @tSql += ' CONVERT(VARCHAR(10),A.FDTxnDocDate,120) AS FDTxnDocDate,'
			SET @tSql += ' A.FTBchCode,A.FTCrdCode,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''10'' AND A.StaCrdAuto = ''2'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0	END) AS CrdClear,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''1'' AND A.StaCrdAuto = ''1'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0 END) AS CrdTopUpAuto,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''1'' THEN ISNULL(A.FCTxnPmt, 0) ELSE 0 END) AS CrdTxnPmt,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''3'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0	END) AS CrdTxnSale,'
			SET @tSql += ' SUM (CASE WHEN A.FTTxnDocType = ''1'' AND A.StaCrdAuto=''2'' THEN ISNULL(A.FCTxnValue, 0) ELSE 0 END) AS CrdTopUpManual'
		SET @tSql += ' FROM ('
				SET @tSql += ' SELECT'
					SET @tSql += ' TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,'
					SET @tSql += ' TOPUP.FDTxnDocDate,TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,TOPUP.FCTxnPmt,'
					SET @tSql += ' CASE	WHEN ISNULL(HD.FTXshRmk, '''') = ''Auto Topup'' THEN ''1'' ELSE ''2'' END AS StaCrdAuto'
				SET @tSql += ' FROM TFNTCrdTopUp TOPUP WITH (NOLOCK)'
				SET @tSql += ' LEFT JOIN TFNTCrdTopUpHD HD WITH (NOLOCK) ON HD.FTBchCode = TOPUP.FTBchCode AND HD.FTXshDocNo = TOPUP.FTTxnDocNoRef'
				SET @tSql += ' WHERE FTTxnDocType != ''5'' '
				SET @tSql += @tSql1
				SET @tSql += ' UNION ALL'
					SET @tSql += ' SELECT'
						SET @tSql += ' TOPUP.FTBchCode,TOPUP.FTShpCode,TOPUP.FTTxnPosCode,TOPUP.FTTxnDocNoRef,TOPUP.FTTxnDocType,TOPUP.FTCrdCode,'
						SET @tSql += ' TOPUP.FDTxnDocDate,TOPUP.FCTxnValue,TOPUP.FCTxnCrdValue,0 AS FCTxnPmt,''2'' AS StaCrdAuto'
					SET @tSql += ' FROM TFNTCrdSale TOPUP WITH (NOLOCK)'
					SET @tSql += ' WHERE	ISNULL(TOPUP.FTCrdCode, '''') != '''' '

					SET @tSql += @tSql1

			SET @tSql += ' ) A GROUP BY CONVERT(VARCHAR(10),A.FDTxnDocDate,120),A.FTBchCode,A.FTCrdCode ) M'


SET @tSql += ' ) B'
SET @tSql += ' LEFT JOIN TCNMBranch_L BCH WITH(NOLOCK) ON B.FTBchCode = BCH.FTBchCode AND BCH.FNLngID = ''1''  '
SET @tSql += ') K '
SET @tSql += ' WHERE K.FCCrdInCome > 0 '
	--SELECT @tSql
	EXECUTE(@tSql)

END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPdtEntry]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPdtEntry
GO
CREATE PROCEDURE [dbo].[SP_RPTxPdtEntry]
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

--Merchant
	@ptMerL Varchar(8000), --เจ้าของธุรกิจ Condition IN
	--@ptUsrF Varchar(10), @ptUsrT Varchar(10),

--Shop
	@ptShpL Varchar(8000), 
	--@ptShpF Varchar(5),@ptShpT Varchar(5),

--รหัสสินค้า --FTPdtCode --รหัสสินค้า
	@ptPdtF Varchar(20),@ptPdtT Varchar(20),

--กลุ่มสินค้า --FTPgpChain 
	@ptPgpF Varchar(30),@ptPgpT Varchar(30),

--FTPtyCode --ประเภทสินค้า
	@ptPtyF Varchar(5),@ptPtyT Varchar(5),
	
--FTPbnCode --ยี่ห้อ
	@ptPbnF Varchar(5),	@ptPbnT Varchar(5),

--FTPmoCode --รุ่น
	@ptPmoF Varchar(5),	@ptPmoT Varchar(5),

	@ptSaleType	 Varchar(1),--FTPdtType  --ใช้ราคาขาย 1:บังคับ, 2:แก้ไข, 3:เครื่องชั่ง, 4:น้ำหนัก 6:สินค้ารายการซ่อม
	@ptPdtActive Varchar(1),--FTPdtStaActive --สถานะ เคลื่อนไหว 1:ใช่, 2:ไม่ใช่
	@PdtStaVat Varchar(1),--FTPdtStaVat --สถานะภาษีขาย 1:มี 2:ไม่มี

--FTPdtCode --รหัสสินค้า
--FTPgpChain --กลุ่มสินค้า
--FTPtyCode --ประเภทสินค้า
--FTPbnCode --ยี่ห้อ
--FTPmoCode --รุ่น
--FTPdtSaleType  --ใช้ราคาขาย 1:บังคับ, 2:แก้ไข, 3:เครื่องชั่ง, 4:น้ำหนัก 6:สินค้ารายการซ่อม
--FTPdtStaActive --สถานะ เคลื่อนไหว 1:ใช่, 2:ไม่ใช่
--FTPdtStaVat --สถานะภาษีขาย 1:มี 2:ไม่มี

	@FNResult INT OUTPUT 
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
	DECLARE @tSql1 VARCHAR(Max)
	DECLARE @tSqlHD VARCHAR(Max)

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

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--Branch
	
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


	IF @ptPgpF =null
	BEGIN
		SET @ptPgpT = ''
	END
	IF @ptPgpT =null OR @ptPgpT = ''
	BEGIN
		SET @ptPgpT = @ptPgpF
	END

	IF @ptPtyF =null
	BEGIN
		SET @ptPtyT = ''
	END
	IF @ptPtyT =null OR @ptPtyT = ''
	BEGIN
		SET @ptPtyT = @ptPtyF
	END

	IF @ptPmoF =null
	BEGIN
		SET @ptPmoT = ''
	END
	IF @ptPmoT =null OR @ptPmoT = ''
	BEGIN
		SET @ptPmoT = @ptPmoF
	END

	IF @ptSaleType = NULL
	BEGIN
		SET @ptSaleType = ''
	END

	IF @ptPdtActive = NULL
	BEGIN
		SET @ptPdtActive = ''
	END

	IF @PdtStaVat = NULL
	BEGIN
		SET @PdtStaVat = ''
	END

	--IF @tDocDateF = null
	--BEGIN 
	--	SET @tDocDateF = ''
	--END

	--IF @tDocDateT = null OR @tDocDateT =''
	--BEGIN 
	--	SET @tDocDateT = @tDocDateF
	--END
	
		
	SET @tSql1 =   ' WHERE 1=1 '

	IF (@ptAgnL <> '' )
	BEGIN
		SET @tSql1 +=' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
	END


	IF (@ptBchL <> '' )
	BEGIN
		SET @tSql1 +=' AND ( SpcBch.FTBchCode IN (' + @ptBchL + ') '
	  SET @tSql1 +=' OR ISNULL(SpcBch.FTBchCode,'''') = '''') '
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
		SET @tSql1 +=' AND PDT.FTPdtCode BETWEEN ''' + @ptPdtF + ''' AND ''' + @ptPdtT + ''''
	END

	IF (@ptPgpF<> '')
	BEGIN
		SET @tSql1 +=' AND PDT.FTPgpChain BETWEEN ''' + @ptPgpF + ''' AND ''' + @ptPgpT + ''''
	END

	IF (@ptPtyF<> '')
	BEGIN
		SET @tSql1 +=' AND PDT.FTPtyCode BETWEEN ''' + @ptPtyF + ''' AND ''' + @ptPtyT + ''''
	END

	IF (@ptPbnF<> '')
	BEGIN
		SET @tSql1 +=' AND PDT.FTPbnCode BETWEEN ''' + @ptPbnF + ''' AND ''' + @ptPbnT + ''''
	END

	IF (@ptPmoF<> '')
	BEGIN
		SET @tSql1 +=' AND PDT.FTPmoCode BETWEEN ''' + @ptPmoF + ''' AND ''' + @ptPmoT + ''''
	END

	IF (@ptSaleType<> '')
	BEGIN
		SET @tSql1 +=' AND PDT.FTPdtSaleType = ''' + @ptSaleType + ''''
	END

	IF (@ptPdtActive<> '')
	BEGIN
		SET @tSql1 +=' AND PDT.FTPdtStaActive = ''' + @ptPdtActive + ''''
	END

	IF (@PdtStaVat<> '')
	BEGIN
		SET @tSql1 +=' AND PDT.FTPdtStaVat = ''' + @PdtStaVat + ''''
	END
	--IF (@tDocDateF <> '' AND @tDocDateT <> '')
	--BEGIN
 --   	SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	--	SET @tSqlHD +=' AND CONVERT(VARCHAR(10),HD.FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	--END
	--PRINT '99999'
	DELETE FROM TRPTPdtEntryTmp  WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--Åº¢éÍÁÙÅ Temp ¢Í§à¤Ã×èÍ§·Õè¨ÐºÑ¹·Ö¡¢ÍÁÙÅÅ§ Temp

	SET @tSql = 'INSERT INTO TRPTPdtEntryTmp'
	--PRINT @tSql
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FTPdtCode,FTPdtName,FTBarCode,FTPunCode,FTPunName,FTPgpChain,FTPgpChainName, FTPtyCode,FTPtyName,FTPdtSaleType,'
	SET @tSql +=' FCPdtUnitFact,FCPdtPriceRET,FCPdtCostInPerUnit,FCPdtCostInTotal,FCPgdPriceRetTotal,FTPplCode,FTPplName'
	SET @tSql +=' )'
	--PRINT @tSql
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' Pdt.FTPdtCode,PdtL.FTPdtName,PdtBar.FTBarCode,PdtBar.FTPunCode,PunL.FTPunName,Pdt.FTPgpChain,PgpL.FTPgpChainName, Pdt.FTPtyCode,PtyL.FTPtyName,'
	SET @tSql +=' FTPdtSaleType,' --ใช้ราคาขาย 1:บังคับ, 2:แก้ไข, 3:เครื่องชั่ง, 4:น้ำหนัก 6:สินค้ารายการซ่อม
	SET @tSql +=' ISNULL(Ppz.FCPdtUnitFact,0) AS FCPdtUnitFact,'
	SET @tSql +=' ISNULL(P4PDT.FCPgdPriceRet,0) AS FCPgdPriceRet,'
	SET @tSql +=' (ISNULL(CostAvg.FCPdtCostIn,0)*ISNULL(Ppz.FCPdtUnitFact,0)) AS FCPdtCostInPerUnit,'
	SET @tSql +=' (ISNULL(Ppz.FCPdtUnitFact,0)*(ISNULL(CostAvg.FCPdtCostIn,0)*ISNULL(Ppz.FCPdtUnitFact,0))) AS FCPdtCostInTotal,'
	SET @tSql +=' (ISNULL(Ppz.FCPdtUnitFact,0)*ISNULL(P4PDT.FCPgdPriceRet,0)) AS FCPgdPriceRetTotal,P4PDT.FTPplCode,PPL.FTPplName'
	SET @tSql +=' FROM TCNMPdt Pdt WITH(NOLOCK)' 
	--PRINT @tSql
	SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK)  ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	--PRINT @tSql
	SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK)  ON Pdt.FTPdtCode = PdtBar.FTPdtCode'
	SET @tSql +=' LEFT JOIN TCNMPdtGrp_L PgpL WITH(NOLOCK)  ON Pdt.FTPgpChain = PgpL.FTPgpChain AND PgpL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK)  ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql +=' LEFT JOIN TCNMPdtUnit_L PunL WITH(NOLOCK)  ON PdtBar.FTPunCode = PunL.FTPunCode AND PunL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK)  ON PdtBar.FTPdtCode = Ppz.FTPdtCode AND PdtBar.FTPunCode = Ppz.FTPunCode'
	SET @tSql +=' LEFT JOIN TCNTPdtPrice4PDT P4PDT WITH(NOLOCK)  ON PdtBar.FTPdtCode = P4PDT.FTPdtCode  AND PdtBar.FTPunCode = P4PDT.FTPunCode AND (P4PDT.FDPghDStart <= GETDATE() AND P4PDT.FDPghDStop >=GETDATE()) AND P4PDT.FTPghTStart <= CONVERT(VARCHAR(5),GETDATE(),8) AND P4PDT.FTPghTStop >= CONVERT(VARCHAR(5),GETDATE(),8)'
	SET @tSql +=' LEFT JOIN TCNMPdtCostAvg CostAvg WITH(NOLOCK)  ON  PdtBar.FTPdtCode = CostAvg.FTPdtCode'
	SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON Pdt.FTPdtCode =  SpcBch.FTPdtCode'
	SET @tSql +=' LEFT JOIN TCNMPdtPriList_L PPL WITH (NOLOCK) ON P4PDT.FTPplCode = PPL.FTPplCode  AND PPL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
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