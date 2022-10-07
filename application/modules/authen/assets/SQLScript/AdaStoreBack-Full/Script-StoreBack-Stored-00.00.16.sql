


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
														SET @tSQLMaster += ' AND PDLSPC.FTBchCode IN ('+@tSesBchCodeMulti+') '
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






/****** Object:  StoredProcedure [dbo].[SP_RPTxStockMovent1002002]    Script Date: 06/09/2022 13:30:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxStockMovent1002002]') AND type in (N'P', N'PC'))
	DROP PROCEDURE SP_RPTxStockMovent1002002
GO
CREATE PROCEDURE SP_RPTxStockMovent1002002 
	--ALTER PROCEDURE [dbo].[SP_RPTxStockMovent1002002]
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

	 -- RQ2208-021 เพื่ม Condition ยี่ห้อสินค้า และประเภทสินค้า
	 @ptPtyF Varchar(5), --ประเภทสินค้า
	 @ptPtyT Varchar(5),
	 @ptPbnF Varchar(5), --ยี่ห้อสินค้า
	 @ptPbnT Varchar(5),
 
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

	 DECLARE @tPtyF Varchar(5)
	 DECLARE @tPtyT Varchar(5)
	 DECLARE @tPbnF Varchar(5)
	 DECLARE @tPbnT Varchar(5)

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
	 
	 --22-09-06 RQ2208-021 NUI
	 SET @tPtyF = @ptPtyF
	 SET @tPtyT = @ptPtyT
	 SET @tPbnF = @ptPbnF
	 SET @tPbnT = @ptPbnT
	 
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
	 --22-09-06 RQ2208-021 NUI
	 IF @tPtyF = null
	 BEGIN
	  SET @tPtyF = ''
	 END 
	 IF @tPtyT = null OR @tPtyT =''
	 BEGIN
	  SET @tPtyT = @tPtyF
	 END 

	 IF @tPbnF = null
	 BEGIN
	  SET @tPbnF = ''
	 END 
	 IF @tPbnT = null OR @tPbnT =''
	 BEGIN
	  SET @tPbnT = @tPbnF
	 END 
	 -----------------

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
	--22-09-06 RQ2208-021 NUI
	IF (@tPtyF <> '' AND @tPtyT <> '')
	BEGIN
		SET @tSqlIns +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPtyF + ''' AND ''' + @tPtyT + ''''
	END

	IF (@tPbnF <> '' AND @tPbnT <> '')
	BEGIN
		SET @tSqlIns +=' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
	END

	IF (@tMonth <> '' )
	BEGIN
		SET @tSqlIns +=' AND CONVERT(varchar(2),MONTH(FDStkDate)) BETWEEN ''' + @tMonth + ''' AND ''' + @tMonth + ''''
	END

	IF (@tYear <> '' )
	BEGIN
		SET @tSqlIns +=' AND CONVERT(varchar(4),YEAR(FDStkDate)) BETWEEN ''' + @tYear + ''' AND ''' + @tYear + ''''
	END

	IF (@tPdtStaActive <> '' )
	BEGIN
		SET @tSqlIns +=' AND Pdt.FTPdtStaActive = ''' + @tPdtStaActive + ''' '
	END
  
	 DELETE FROM TRPTPdtStkCrdTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
	 -- Stk
	 SET @tSql = ' INSERT INTO TRPTPdtStkCrdTmp '
	 SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTBchCode,FTBchName, FDStkDate, FTStkDocNo, FTWahCode,FTWahName, FTPdtCode,FTPdtName,'
	 SET @tSql +=' FCStkQtyMonEnd,FCStkQtyIn,FCStkQtyOut,FCStkQtySaleDN,FCStkQtyCN,FCStkQtyAdj'
	 SET @tSql +=' )' 
		 SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,' 
		 SET @tSql +=' STK.FTBchCode,FTBchName, FDStkDate, FTStkDocNo, Stk.FTWahCode,Wah_L.FTWahName, Stk.FTPdtCode,Pdt_L.FTPdtName,' --FTStkType, 
		 SET @tSql +=' CASE WHEN FTStkType = ''0'' THEN FCStkQty ELSE 0 END AS FCStkQtyMonEnd,'
		 SET @tSql +=' CASE WHEN FTStkType = ''1'' THEN FCStkQty ELSE 0 END AS FCStkQtyIn,'
		 SET @tSql +=' CASE WHEN FTStkType = ''2'' THEN FCStkQty ELSE 0 END AS FCStkQtyOut,'
		 SET @tSql +=' CASE WHEN FTStkType = ''3'' THEN FCStkQty ELSE 0 END AS FCStkQtySaleDN,'
		 SET @tSql +=' CASE WHEN FTStkType = ''4'' THEN FCStkQty ELSE 0 END AS FCStkQtyCN,'
		 SET @tSql +=' CASE WHEN FTStkType = ''5'' THEN FCStkQty ELSE 0 END AS FCStkQtyAdj'
		 SET @tSql +=' FROM   TCNTPdtStkCrd Stk WITH(NOLOCK) LEFT JOIN' 
		 SET @tSql +=' TCNMWaHouse_L Wah_L WITH(NOLOCK) ON Stk.FTWahCode = Wah_L.FTWahCode AND Stk.FTBchCode = Wah_L.FTBchCode AND Wah_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN' 
		 SET @tSql +=' TCNMPdt_L Pdt_L WITH(NOLOCK) ON Stk.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH(NOLOCK) ON Stk.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode '    
	 SET @tSql +=  @tSqlIns
	 EXECUTE(@tSql)
	 ----STKBch
	 SET @tSql = ' INSERT INTO TRPTPdtStkCrdTmp '
	 SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTBchCode,FTBchName, FDStkDate, FTStkDocNo, FTWahCode,FTWahName, FTPdtCode,FTPdtName,'
	 SET @tSql +=' FCStkQtyMonEnd,FCStkQtyIn,FCStkQtyOut,FCStkQtySaleDN,FCStkQtyCN,FCStkQtyAdj'
	 SET @tSql +=' )' 
		 SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,' 
		 SET @tSql +=' STK.FTBchCode,FTBchName, FDStkDate, FTStkDocNo, Stk.FTWahCode,Wah_L.FTWahName, Stk.FTPdtCode,Pdt_L.FTPdtName,' --FTStkType, 
		 SET @tSql +=' CASE WHEN FTStkType = ''0'' THEN FCStkQty ELSE 0 END AS FCStkQtyMonEnd,'
		 SET @tSql +=' CASE WHEN FTStkType = ''1'' THEN FCStkQty ELSE 0 END AS FCStkQtyIn,'
		 SET @tSql +=' CASE WHEN FTStkType = ''2'' THEN FCStkQty ELSE 0 END AS FCStkQtyOut,'
		 SET @tSql +=' CASE WHEN FTStkType = ''3'' THEN FCStkQty ELSE 0 END AS FCStkQtySaleDN,'
		 SET @tSql +=' CASE WHEN FTStkType = ''4'' THEN FCStkQty ELSE 0 END AS FCStkQtyCN,'
		 SET @tSql +=' CASE WHEN FTStkType = ''5'' THEN FCStkQty ELSE 0 END AS FCStkQtyAdj'
		 SET @tSql +=' FROM   TCNTPdtStkCrdBch Stk WITH(NOLOCK) LEFT JOIN' 
		 SET @tSql +=' TCNMWaHouse_L Wah_L WITH(NOLOCK) ON Stk.FTWahCode = Wah_L.FTWahCode AND Stk.FTBchCode = Wah_L.FTBchCode AND Wah_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN' 
		 SET @tSql +=' TCNMPdt_L Pdt_L WITH(NOLOCK) ON Stk.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH(NOLOCK) ON Stk.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode '
    
	 SET @tSql +=  @tSqlIns 
	 EXECUTE(@tSql)
	 ----STKME
	 SET @tSql = ' INSERT INTO TRPTPdtStkCrdTmp '
	 SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTBchCode,FTBchName, FDStkDate, FTStkDocNo, FTWahCode,FTWahName, FTPdtCode,FTPdtName,'
	 SET @tSql +=' FCStkQtyMonEnd,FCStkQtyIn,FCStkQtyOut,FCStkQtySaleDN,FCStkQtyCN,FCStkQtyAdj'
	 SET @tSql +=' )' 
		 SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,' 
		 SET @tSql +=' STK.FTBchCode,FTBchName, FDStkDate, FTStkDocNo, Stk.FTWahCode,Wah_L.FTWahName, Stk.FTPdtCode,Pdt_L.FTPdtName,' --FTStkType, 
		 SET @tSql +=' CASE WHEN FTStkType = ''0'' THEN FCStkQty ELSE 0 END AS FCStkQtyMonEnd,'
		 SET @tSql +=' CASE WHEN FTStkType = ''1'' THEN FCStkQty ELSE 0 END AS FCStkQtyIn,'
		 SET @tSql +=' CASE WHEN FTStkType = ''2'' THEN FCStkQty ELSE 0 END AS FCStkQtyOut,'
		 SET @tSql +=' CASE WHEN FTStkType = ''3'' THEN FCStkQty ELSE 0 END AS FCStkQtySaleDN,'
		 SET @tSql +=' CASE WHEN FTStkType = ''4'' THEN FCStkQty ELSE 0 END AS FCStkQtyCN,'
		 SET @tSql +=' CASE WHEN FTStkType = ''5'' THEN FCStkQty ELSE 0 END AS FCStkQtyAdj'
		 SET @tSql +=' FROM   TCNTPdtStkCrdMe Stk WITH(NOLOCK) LEFT JOIN' 
		 SET @tSql +=' TCNMWaHouse_L Wah_L WITH(NOLOCK) ON Stk.FTWahCode = Wah_L.FTWahCode AND Stk.FTBchCode = Wah_L.FTBchCode AND Wah_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN' 
		 SET @tSql +=' TCNMPdt_L Pdt_L WITH(NOLOCK) ON Stk.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH(NOLOCK) ON Stk.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON Stk.FTPdtCode = Pdt.FTPdtCode '
      
	 SET @tSql +=  @tSqlIns

	 EXECUTE(@tSql)
	 --RETURN SELECT * FROM TRPTPdtStkCrdTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
 
END TRY
BEGIN CATCH 
 SET @FNResult= -1
 PRINT @tSql
END CATCH 

GO




/****** Object:  StoredProcedure [dbo].[SP_RPTxDailySaleByPdt1001002]    Script Date: 05/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxDailySaleByPdt1001002]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxDailySaleByPdt1001002
GO
CREATE PROCEDURE SP_RPTxDailySaleByPdt1001002 
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

	SET @tSql1 =   ' WHERE 1=1 AND FTXshStaDoc = ''1'' AND DT.FTXsdStaPdt <> ''4'''

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
		SET @tSql1 +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
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

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTSalDTTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  = ' INSERT INTO TRPTSalDTTmp '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FNAppType,FTBchCode,FTBchName,FTPdtCode,FTXsdPdtName,FTPgpChainName,FTPunName,FCXsdQty,FCXsdSetPrice,FCXsdAmtB4DisChg,FCXsdDis,FCXsdVat,FCXsdNet,FCXsdNetAfHD,'
	SET @tSql +=' FTPbnCode,FTPbnName,FTPtyCode,FTPtyName'
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' 1 AS FNAppType,FTBchCode,FTBchName,FTPdtCode,FTPdtName,FTPgpChainName,FTPunName,'
	SET @tSql +=' SUM(FCXsdQty) AS FCXsdQty,'
	--SET @tSql +=' SUM(FCXsdQty*FCXsdSetPrice)/SUM(FCXsdQty) AS FCXsdSetPrice,'
	--SET @tSql +=' AVG(FCXsdSetPrice) AS FCXsdSetPrice,'
	SET @tSql +=' SUM(FCXsdNetAfHD)/SUM(FCXsdQty) AS FCXsdSetPrice,'
	
	SET @tSql +=' SUM(FCXsdAmtB4DisChg) AS FCXsdAmtB4DisChg,'

	--SET @tSql +=' SUM(FCXsdQty*FCXsdSetPrice) AS FCXsdAmtB4DisChg, '
	SET @tSql +=' SUM(FCXsdDis) AS FCXsdDis ,'
	SET @tSql +=' SUM(FCXsdVat) AS FCXsdVat,'
	SET @tSql +=' SUM(FCXsdNet) AS FCXsdNet,'
	SET @tSql +=' SUM(FCXsdNetAfHD) AS FCXsdNetAfHD,'
	SET @tSql +=' ISNULL(FTPbnCode,'''') AS FTPbnCode,ISNULL(FTPbnName,'''') AS FTPbnName,ISNULL(FTPtyCode,'''') AS FTPtyCode,ISNULL(FTPtyName,'''') AS FTPtyName'
	SET @tSql +=' FROM'
		SET @tSql +=' (SELECT DT.FTXshDocNo,HD.FDXshDocDate,HD.FTBchCode,Bch_L.FTBchName,DT.FTPdtCode,Pdt_L.FTPdtName,Chan_L.FTPgpChainName,ISNULL(Pun_L.FTPunName,'''') AS FTPunName,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT.FCXsdQty,0) ELSE ISNULL(DT.FCXsdQty,0)*-1 END FCXsdQty,'
		SET @tSql +=' ISNULL(DT.FCXsdSetPrice,0) AS FCXsdSetPrice,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT. FCXsdAmtB4DisChg,0) ELSE (ISNULL(DT. FCXsdAmtB4DisChg,0))*-1 END AS FCXsdAmtB4DisChg,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DTDis.FCXddValue, 0) ELSE (ISNULL(DTDis.FCXddValue, 0))*-1 END FCXsdDis,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT.FCXsdVat,0) ELSE ISNULL(DT.FCXsdVat,0)*-1 END FCXsdVat,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT.FCXsdNet,0) ELSE ISNULL(DT.FCXsdNet,0)*-1 END FCXsdNet,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT.FCXsdNetAfHD,0) ELSE ISNULL(DT.FCXsdNetAfHD,0)*-1 END FCXsdNetAfHD,'

		SET @tSql +=' Pdt.FTPbnCode,PbnL.FTPbnName,Pdt.FTPtyCode,PtyL.FTPtyName'

		SET @tSql +=' FROM TPSTSalDT DT INNER JOIN TPSTSalHD HD ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo LEFT JOIN'
		SET @tSql +=' ('
			SET @tSql +=' SELECT FTBchCode,FTXshDocNo,FNXsdSeqNo,'
			SET @tSql +=' SUM (CASE WHEN FTXddDisChgType = 3 OR FTXddDisChgType = 4 THEN ISNULL(FCXddValue, 0) ELSE ISNULL(FCXddValue, 0)*-1 END) AS FCXddValue'
			SET @tSql +=' FROM TPSTSalDTDis GROUP BY FTBchCode,FTXshDocNo,FNXsdSeqNo'
		SET @tSql +=' ) AS DTDis ON DT.FTBchCode = DTDis.FTBchCode AND DT.FTXshDocNo = DTDis.FTXshDocNo AND DT.FNXsdSeqNo = DTDis.FNXsdSeqNo LEFT JOIN'
		SET @tSql +=' TCNMPdt Pdt WITH (NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode LEFT JOIN'
		SET @tSql +=' TCNMPdt_L Pdt_L WITH (NOLOCK) ON DT.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN'
		SET @tSql +=' TCNMPdtUnit_L Pun_L WITH (NOLOCK) ON DT.FTPunCode = Pun_L.FTPunCode AND  Pun_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN'
		SET @tSql +=' TCNMPdtGrp_L Chan_L WITH (NOLOCK) ON Pdt.FTPgpChain = Chan_L.FTPgpChain AND Chan_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH (NOLOCK) ON  HD.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSql +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode ' 
		SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH (NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH (NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		--PRINT @tSql1
		SET @tSql += @tSql1			
		SET @tSql +=' ) SalePdt'
	SET @tSql +=' GROUP BY FTBchCode,FTBchName,FTPdtCode,FTPdtName,FTPgpChainName,FTPunName,ISNULL(FTPbnCode,'''') ,ISNULL(FTPbnName,'''') ,ISNULL(FTPtyCode,'''') ,ISNULL(FTPtyName,'''') ' 
	SET @tSql +=' HAVING SUM (FCXsdQty)<>0'
	--PRINT @tSql
	EXECUTE(@tSql)

	--INSERT VD
  	SET @tSql  = ' INSERT INTO TRPTSalDTTmp '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FNAppType,FTBchCode,FTBchName,FTPdtCode,FTXsdPdtName,FTPgpChainName,FTPunName,FCXsdQty,FCXsdSetPrice,FCXsdAmtB4DisChg,FCXsdDis,FCXsdVat,FCXsdNet,FCXsdNetAfHD,'
	SET @tSql +=' FTPbnCode,FTPbnName,FTPtyCode,FTPtyName'
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' 2 AS FNAppType,FTBchCode,FTBchName,FTPdtCode,FTPdtName,FTPgpChainName,FTPunName,'
	SET @tSql +=' SUM(FCXsdQty) AS FCXsdQty,'
	--SET @tSql +=' SUM(FCXsdQty*FCXsdSetPrice)/SUM(FCXsdQty) AS FCXsdSetPrice,'
	--SET @tSql +=' AVG(FCXsdSetPrice) AS FCXsdSetPrice,'
	SET @tSql +=' SUM(FCXsdNetAfHD)/SUM(FCXsdQty) AS FCXsdSetPrice,'
	SET @tSql +=' SUM(FCXsdAmtB4DisChg) AS FCXsdAmtB4DisChg,'

	--SET @tSql +=' SUM(FCXsdQty*FCXsdSetPrice) AS FCXsdAmtB4DisChg, '
	SET @tSql +=' SUM(FCXsdDis) AS FCXsdDis ,'
	SET @tSql +=' SUM(FCXsdVat) AS FCXsdVat,'
	SET @tSql +=' SUM(FCXsdNet) AS FCXsdNet,'
	SET @tSql +=' SUM(FCXsdNetAfHD) AS FCXsdNetAfHD,'
	SET @tSql +=' ISNULL(FTPbnCode,'''') AS FTPbnCode,ISNULL(FTPbnName,'''') AS FTPbnName,ISNULL(FTPtyCode,'''') AS FTPtyCode,ISNULL(FTPtyName,'''') AS FTPtyName'
	SET @tSql +=' FROM'
		SET @tSql +=' (SELECT DT.FTXshDocNo,HD.FDXshDocDate,HD.FTBchCode,Bch_L.FTBchName,DT.FTPdtCode,Pdt_L.FTPdtName,Chan_L.FTPgpChainName,ISNULL(Pun_L.FTPunName,'''') AS FTPunName,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT.FCXsdQty,0) ELSE ISNULL(DT.FCXsdQty,0)*-1 END FCXsdQty,'
		SET @tSql +=' ISNULL(DT.FCXsdSetPrice,0) AS FCXsdSetPrice,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT. FCXsdAmtB4DisChg,0) ELSE (ISNULL(DT. FCXsdAmtB4DisChg,0))*-1 END AS FCXsdAmtB4DisChg,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT.FCXsdChg,0)- ISNULL(DT.FCXsdDis,0) ELSE (ISNULL(DT.FCXsdChg,0)- ISNULL(DT.FCXsdDis,0))*-1 END FCXsdDis,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT.FCXsdVat,0) ELSE ISNULL(DT.FCXsdVat,0)*-1 END FCXsdVat,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT.FCXsdNet,0) ELSE ISNULL(DT.FCXsdNet,0)*-1 END FCXsdNet,'
		SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN  ISNULL(DT.FCXsdNetAfHD,0) ELSE ISNULL(DT.FCXsdNetAfHD,0)*-1 END FCXsdNetAfHD,'

		SET @tSql +=' Pdt.FTPbnCode,PbnL.FTPbnName,Pdt.FTPtyCode,PtyL.FTPtyName'
		SET @tSql +=' FROM TVDTSalDT DT INNER JOIN TVDTSalHD HD ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo LEFT JOIN'
		SET @tSql +=' TCNMPdt Pdt WITH (NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode LEFT JOIN'
		SET @tSql +=' TCNMPdt_L Pdt_L WITH (NOLOCK) ON DT.FTPdtCode = Pdt_L.FTPdtCode AND Pdt_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN'
		SET @tSql +=' TCNMPdtUnit_L Pun_L WITH (NOLOCK) ON DT.FTPunCode = Pun_L.FTPunCode AND  Pun_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT JOIN'
		SET @tSql +=' TCNMPdtGrp_L Chan_L WITH (NOLOCK) ON Pdt.FTPgpChain = Chan_L.FTPgpChain AND Chan_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSql +=' LEFT JOIN TCNMBranch_L Bch_L WITH (NOLOCK) ON  HD.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSql +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode ' 
		SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH (NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH (NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		--PRINT @tSql1
		SET @tSql += @tSql1			
		SET @tSql +=' ) SalePdt'
	SET @tSql +=' GROUP BY FTBchCode,FTBchName,FTPdtCode,FTPdtName,FTPgpChainName,FTPunName,ISNULL(FTPbnCode,'''') ,ISNULL(FTPbnName,'''') ,ISNULL(FTPtyCode,'''') ,ISNULL(FTPtyName,'''') ' 
	SET @tSql +=' HAVING SUM (FCXsdQty)<>0'
	--PRINT @tSql
--SELECT  @tSql AS SQLTE
	EXECUTE(@tSql)

	--RETURN SELECT * FROM TRPTSalDTTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	

GO






/****** Object:  StoredProcedure [dbo].[SP_RPTxPSSVatByMonth_Animate]    Script Date: 11/09/2022 10:26:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPSSVatByMonth_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPSSVatByMonth_Animate
GO
CREATE PROCEDURE SP_RPTxPSSVatByMonth_Animate 
--ALTER PROCEDURE [dbo].[SP_RPTxPSSVatByDate1001007] 
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



	@ptMonth Varchar(2),
	@ptYear Varchar(4),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 12/09/2022
-- Temp name  TRPTPSTaxMonthTmp_Animate
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
-- @ptBchL สาขา เชือก
	--DECLARE @tPosCodeF Varchar(30)
	--DECLARE @tPosCodeT Varchar(30)
-- @@ptMonth เดือน
-- @@ptYear ปี
-- @FNResult

--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlDrop VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSqlSale VARCHAR(8000)
	DECLARE @tTblName Varchar(255)
	DECLARE @tSqlS Varchar(255)
	DECLARE @tSqlR Varchar(255)
	DECLARE @tSql2 VARCHAR(255)

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


	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--SET @tBchF = @ptBchF
	--SET @tBchT = @ptBchT

	--SET @tPosCodeF  = @ptPosCodeF 
	--SET @tPosCodeT = @ptPosCodeT 

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

	--SET @tDocDateF = @ptDocDateF
	--SET @tDocDateT = @ptDocDateT

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


	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	SET @tSql2 =   ' WHERE FTXshStaDoc = ''1'''
	SET @tSqlS =   ' WHERE FTXshStaDoc = ''1'' AND ISNULL(FTXshDocVatFull,'''') <> '''''
	SET @tSqlR =   ' WHERE FTXshStaDoc = ''1'' AND FNXshDocType = ''9'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSqlR +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSql2 +=' AND HDL.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSqlR +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSql2 +=' AND HDL.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSqlR +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSql2 +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSqlR += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSql2 += ' AND HDL.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSqlR +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql2 +=' AND HDL.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlR +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql2 +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlR +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql2 +=' AND HDL.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSqlR += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSql2 += ' AND HDL.FTPosCode IN (' + @ptPosL + ')'
		END		
	END

	IF (@ptMonth <> '' )
	BEGIN
		SET @tSql2 +=' AND FORMAT( HDL.FDXshDocDate, ''MM'', ''en-US'' ) = ''' + @ptMonth +''''
		SET @tSqlS +=' AND FORMAT( HD.FDXshDocDate, ''MM'', ''en-US'' ) = ''' + @ptMonth +''''
		--SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	IF (@ptYear <> '' )
	BEGIN
		SET @tSql2 +=' AND FORMAT( HDL.FDXshDocDate, ''yyyy'', ''en-US'' ) = ''' + @ptYear +''''
		SET @tSqlS +=' AND FORMAT( HD.FDXshDocDate, ''yyyy'', ''en-US'' ) = ''' + @ptYear +''''
		--SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTPSTaxMonthTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp

	--SET @tTblName = 'TRPTPSTaxTmp'+ @nComName + ''

	----if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].''+@tTblName''')) 
	--SET @tSqlDrop = ' if exists (select * from dbo.sysobjects where name = '''+@tTblName+ ''')'--id = object_id(N'[dbo].''+@tTblName'''))' 
	--SET @tSqlDrop += ' DROP TABLE '+ @tTblName + ''
	----PRINT @tSqlDrop
	--EXECUTE(@tSqlDrop)

	--PRINT @tTblName 

	SET @tSqlSale  =' INSERT INTO TRPTPSTaxMonthTmp_Animate '
	SET @tSqlSale +=' ('
	SET @tSqlSale +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSqlSale +=' FNAppType,FTBchCode,FTXshDocDate,FTXshDocLegth,FTCstName,FTXshAddrTax,'
	SET @tSqlSale +=' FCXshAmtNV,FCXshVatable,FCXshVat,FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	-----------
	SET @tSqlSale +=' )'
 	SET @tSqlSale +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSqlSale +=' ''1'' AS FNAppType,'
	SET @tSqlSale +=' HDL.FTBchCode,FTXshDocDate,CASE WHEN HDL.FTXshDocVatFull = '''' THEN FTXshDocLegth ELSE HDFull.FTXshDocVat END AS FTXshDocLegth ,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN ISNULL(HDFull.FTXshCstName,'''') ELSE ISNULL(HDl.FTXshCstName,'''') END AS FTXshCstName,ISNULL(HDFull.FTXshAddrTax,'''') AS FTXshAddrTax,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshAmtNV ELSE HDL.FCXshAmtNV END AS FCXshAmtNV,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshVatable ELSE HDL.FCXshVatable END AS FCXshVatable,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshVat ELSE HDL.FCXshVat END AS FCXshVat,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshGrandAmt ELSE HDL.FCXshGrandAmt END AS FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	SET @tSqlSale +=' FROM('
		SET @tSqlSale +=' SELECT HDL.FTBchCode,FORMAT( FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'' )  AS FTXshDocDate,'
		SET @tSqlSale +=' MIN(HDL.FTXshDocNo) + ''-'' + Max(HDL.FTXshDocNo) AS FTXshDocLegth,Max(HDL.FDXshDocDate) AS FDXshDocDateSort,'
		SET @tSqlSale +=' ISNULL(HDL.FTXshDocVatFull,'''') AS FTXshDocVatFull,' 
		SET @tSqlSale +=' CASE WHEN ISNULL(HDL.FTXshDocVatFull,'''') = '''' THEN ''1'' ELSE ''2'' END AS FTXshGenTax' --'2'
		SET @tSqlSale +=' ,ISNULL(HDCst.FTXshCstName,'''')  AS FTXshCstName,'
		SET @tSqlSale +=' SUM(ISNULL(FCXshAmtNV,0)) AS FCXshAmtNV,SUM(ISNULL(FCXshVatable,0)) AS FCXshVatable,SUM(ISNULL(FCXshVat,0)) AS FCXshVat,'
		SET @tSqlSale +=' SUM(ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)) AS FCXshGrandAmt,'
		SET @tSqlSale +=' FORMAT( FDXshDocDate, ''MMMM yyyy'', ''Th'' )  AS FTXshMonthTH,FORMAT( FDXshDocDate, ''MMMM yyyy'', ''en-US'' )  AS FTXshMonthEN'
		--PRINT @tSqlSale
		SET @tSqlSale +=' FROM TPSTSalHD HDL WITH(NOLOCK)'
		SET @tSqlSale +=' LEFT JOIN TPSTSalHDCst HDCst WITH(NOLOCK) ON HDL.FTBchCode = HDCst.FTBchCode AND HDL.FTXshDocNo = HDCst.FTXshDocNo'
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HDL.FTBchCode = Shp.FTBchCode AND HDL.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSql2
		SET @tSqlSale +=' GROUP BY HDL.FTBchCode,FORMAT( FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'' ),ISNULL(HDL.FTXshDocVatFull,''''),FNXshDocType,ISNULL(HDCst.FTXshCstName,''''), FORMAT( FDXshDocDate, ''MMMM yyyy'', ''Th'' ) ,FORMAT( FDXshDocDate, ''MMMM yyyy'', ''en-US'' )'
		SET @tSqlSale +=' ) AS HDL'
		SET @tSqlSale +=' LEFT JOIN' 
		SET @tSqlSale +=' ('
		  SET @tSqlSale +=' SELECT HD.FTBchCode,FTXshDocVatFull,FTXshDocVatFull + ''('' + HD.FTXshDocNo + '')'' AS FTXshDocVat,FTXshCstName,FTXshAddrTax,'
		  SET @tSqlSale +=' ISNULL(FCXshAmtNV,0) AS FCXshAmtNV,ISNULL(FCXshVatable,0) AS FCXshVatable,'
		  SET @tSqlSale +=' ISNULL(FCXshVat,0) AS FCXshVat,'
		  SET @tSqlSale +=' ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) AS FCXshGrandAmt'
		  SET @tSqlSale +=' FROM TPSTSalHD HD WITH(NOLOCK)'
		  SET @tSqlSale +=' LEFT JOIN TPSTTaxHDCst HDCst WITH(NOLOCK) ON HD.FTXshDocVatFull = HDCst.FTXshDocNo'
		  SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		  SET @tSqlSale += @tSqlS --' WHERE ISNULL(FTXshDocVatFull,'''') <> '''''
		SET @tSqlSale +=' ) AS HDFull ON HDL.FTBchCode = HDFull.FTBchCode AND HDL.FTXshDocVatFull = HDFull.FTXshDocVatFull'
	SET @tSqlSale +=' ORDER BY HDL.FDXshDocDateSort' --FTXshDocDate

	--PRINT @tSqlSale
	EXECUTE(@tSqlSale)

SET @tSqlSale  =' INSERT INTO TRPTPSTaxMonthTmp_Animate '
	SET @tSqlSale +=' ('
	SET @tSqlSale +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSqlSale +=' FNAppType,FTBchCode,FTXshDocDate,FTXshDocLegth,FTCstName,FTXshAddrTax,'
	SET @tSqlSale +=' FCXshAmtNV,FCXshVatable,FCXshVat,FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	-----------
	SET @tSqlSale +=' )'
 	SET @tSqlSale +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSqlSale +=' ''1'' AS FNAppType,'
	SET @tSqlSale +=' HDL.FTBchCode,FTXshDocDate,CASE WHEN HDL.FTXshDocVatFull = '''' THEN FTXshDocLegth ELSE HDFull.FTXshDocVat END AS FTXshDocLegth ,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN ISNULL(HDFull.FTXshCstName,'''') ELSE ISNULL(HDl.FTXshCstName,'''') END AS FTXshCstName,ISNULL(HDFull.FTXshAddrTax,'''') AS FTXshAddrTax,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshAmtNV ELSE HDL.FCXshAmtNV END AS FCXshAmtNV,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshVatable ELSE HDL.FCXshVatable END AS FCXshVatable,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshVat ELSE HDL.FCXshVat END AS FCXshVat,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshGrandAmt ELSE HDL.FCXshGrandAmt END AS FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	SET @tSqlSale +=' FROM('
		SET @tSqlSale +=' SELECT HDL.FTBchCode,FORMAT( FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'' )  AS FTXshDocDate,'
		SET @tSqlSale +=' MIN(HDL.FTXshDocNo) + ''-'' + Max(HDL.FTXshDocNo) AS FTXshDocLegth,Max(HDL.FDXshDocDate) AS FDXshDocDateSort,'
		SET @tSqlSale +=' ISNULL(HDL.FTXshDocVatFull,'''') AS FTXshDocVatFull,' 
		SET @tSqlSale +=' CASE WHEN ISNULL(HDL.FTXshDocVatFull,'''') = '''' THEN ''1'' ELSE ''2'' END AS FTXshGenTax' --'2'
		SET @tSqlSale +=' ,ISNULL(HDCst.FTXshCstName,'''')  AS FTXshCstName,'
		SET @tSqlSale +=' SUM(ISNULL(FCXshAmtNV,0)) AS FCXshAmtNV,SUM(ISNULL(FCXshVatable,0)) AS FCXshVatable,SUM(ISNULL(FCXshVat,0)) AS FCXshVat,'
		SET @tSqlSale +=' SUM(ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)) AS FCXshGrandAmt,'
		SET @tSqlSale +=' FORMAT( FDXshDocDate, ''MMMM yyyy'', ''Th'' )  AS FTXshMonthTH,FORMAT( FDXshDocDate, ''MMMM yyyy'', ''en-US'' )  AS FTXshMonthEN'
		--PRINT @tSqlSale
		SET @tSqlSale +=' FROM TVDTSalHD HDL WITH(NOLOCK)'
		SET @tSqlSale +=' LEFT JOIN TVDTSalHDCst HDCst WITH(NOLOCK) ON HDL.FTBchCode = HDCst.FTBchCode AND HDL.FTXshDocNo = HDCst.FTXshDocNo'
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HDL.FTBchCode = Shp.FTBchCode AND HDL.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSql2
		SET @tSqlSale +=' GROUP BY HDL.FTBchCode,FORMAT( FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'' ),ISNULL(HDL.FTXshDocVatFull,''''),FNXshDocType,ISNULL(HDCst.FTXshCstName,''''), FORMAT( FDXshDocDate, ''MMMM yyyy'', ''Th'' ) ,FORMAT( FDXshDocDate, ''MMMM yyyy'', ''en-US'' )'
		SET @tSqlSale +=' ) AS HDL'
		SET @tSqlSale +=' LEFT JOIN' 
		SET @tSqlSale +=' ('
		  SET @tSqlSale +=' SELECT HD.FTBchCode,FTXshDocVatFull,FTXshDocVatFull + ''('' + HD.FTXshDocNo + '')'' AS FTXshDocVat,FTXshCstName,FTXshAddrTax,'
		  SET @tSqlSale +=' ISNULL(FCXshAmtNV,0) AS FCXshAmtNV,ISNULL(FCXshVatable,0) AS FCXshVatable,'
		  SET @tSqlSale +=' ISNULL(FCXshVat,0) AS FCXshVat,'
		  SET @tSqlSale +=' ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) AS FCXshGrandAmt'
		  SET @tSqlSale +=' FROM TVDTSalHD HD WITH(NOLOCK)'
		  SET @tSqlSale +=' LEFT JOIN TVDTTaxHDCst HDCst WITH(NOLOCK) ON HD.FTXshDocVatFull = HDCst.FTXshDocNo'
		  SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		  SET @tSqlSale += @tSqlS --' WHERE ISNULL(FTXshDocVatFull,'''') <> '''''
		SET @tSqlSale +=' ) AS HDFull ON HDL.FTBchCode = HDFull.FTBchCode AND HDL.FTXshDocVatFull = HDFull.FTXshDocVatFull'
	SET @tSqlSale +=' ORDER BY HDL.FDXshDocDateSort' --FTXshDocDate
	EXECUTE(@tSqlSale)
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO





/****** Object:  StoredProcedure [dbo].[SP_RPTxPdtHisTnfWah]    Script Date: 14/9/2565 18:32:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPdtHisTnfWah]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPdtHisTnfWah
GO

CREATE PROCEDURE [dbo].[SP_RPTxPdtHisTnfWah]
        @pnLngID int , 
        @pnComName Varchar(100),
        @ptRptCode Varchar(100),
        @ptUsrSession Varchar(255),
        @pnFilterType int, --1 BETWEEN 2 IN
        @ptAgnCode VARCHAR(20),
        --สาขา
        @ptBchL Varchar(8000),
        --คลัง
        @ptWahF Varchar(20),
        @ptWahT Varchar(20),
        --@ptWahL Varchar(8000),
        --สินค้า
        @ptPdtF Varchar(20),
        @ptPdtT Varchar(20),
        --วันที่โออนออก FDLastUpdOn
        @ptDocDateF Varchar(10), 
        @ptDocDateT Varchar(10), 
        @FNResult INT OUTPUT 
    AS

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
        IF @tWahF = null
        BEGIN
            SET @tWahF = ''
        END 
        IF @tWahT = null OR @tWahT =''
        BEGIN
            SET @tWahT = @tWahF
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
        IF (@ptWahF <> '' )
        BEGIN
            SET @tSql1 +=' AND TFW.FTXthWhFrm = ''' + @ptWahF + ''' '
        END

            IF (@ptWahT <> '')
        BEGIN
                SET @tSql1 +=' AND TFW.FTXthWhTo = ''' + @ptWahT + ''' '
        END

        IF (@tPdtF <> '' AND @tPdtT <> '')
        BEGIN
            SET @tSql1 +=' AND TFWDT.FTPdtCode BETWEEN ''' + @tPdtF + ''' AND ''' + @tPdtT + ''''
        END

        IF (@ptDocDateF <> '' AND @ptDocDateT <> '')
        BEGIN
            SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXthDocDate,121) BETWEEN ''' + @ptDocDateF + ''' AND ''' + @ptDocDateT + ''''
        END

    DELETE FROM TRPTPdtHisTnfWahTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''
    SET @tSql = ' INSERT INTO TRPTPdtHisTnfWahTmp'
    SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
    SET @tSql+='	FTBchCode, FTBchName, FTXthDocNo, FDXthDocDate, FTXthWhFrm,  FTWahNameFrm, FTXthWhTo,FTWahNameTo,  ';
    SET @tSql+='	 FTXthApvCode,  FTUsrName,FTPdtCode,FTXtdPdtName,  FTPunName,FTXtdBarCode,FCXtdQty ';
    SET @tSql +=' )'
    SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'       
    SET @tSql+='	FTBchCode, FTBchName, FTXthDocNo, FDXthDocDate, FTXthWhFrm,  FTWahNameFrm, FTXthWhTo,FTWahNameTo,  ';
    SET @tSql+='	 FTXthApvCode,  FTUsrName,FTPdtCode,FTXtdPdtName,  FTPunName,FTXtdBarCode,FCXtdQty ';
    SET @tSql +=' FROM'
    SET @tSql +=' ('			
    SET @tSql+='	SELECT TFW.FTBchCode, BCHL.FTBchName,  TFW.FTXthDocNo, TFW.FDXthDocDate, TFW.FTXthWhFrm,  WahLF.FTWahName AS FTWahNameFrm, TFW.FTXthWhTo, WahLT.FTWahName AS FTWahNameTo,  ';
    SET @tSql+='	  TFW.FTXthApvCode,  USRLAPV.FTUsrName,TFWDT.FTPdtCode, TFWDT.FTXtdPdtName,  TFWDT.FTPunName, TFWDT.FTXtdBarCode,TFWDT.FCXtdQty ';
    SET @tSql+='	  FROM [TCNTPdtTwxHD] TFW WITH(NOLOCK) ';
    SET @tSql+='	  LEFT JOIN TCNTPdtTwxDT TFWDT WITH(NOLOCK) ON TFW.FTXthDocNo = TFWDT.FTXthDocNo ';
    SET @tSql+='	 LEFT JOIN TCNMBranch_L BCHL WITH(NOLOCK) ON TFW.FTBchCode = BCHL.FTBchCode
                                                    AND BCHL.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + '''';
    SET @tSql+='	 LEFT JOIN TCNMUser_L USRL WITH(NOLOCK) ON TFW.FTCreateBy = USRL.FTUsrCode
                                                AND USRL.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + '''';
    SET @tSql+='	   LEFT JOIN TCNMUser_L USRLAPV WITH(NOLOCK) ON TFW.FTXthApvCode = USRLAPV.FTUsrCode
                                                    AND USRLAPV.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + '''';
    SET @tSql+='	   LEFT JOIN TCNMWahouse_L WahLT WITH(NOLOCK) ON TFW.FTBchCode = WahLT.FTBchCode
                                                    AND TFW.FTXthWhTo = WahLT.FTWahCode
                                                    AND WahLT.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + '''';
    SET @tSql+='	   LEFT JOIN TCNMWahouse_L WahLF WITH(NOLOCK) ON TFW.FTBchCode = WahLF.FTBchCode
                                                    AND TFW.FTXthWhFrm = WahLF.FTWahCode
                                                    AND WahLF.FNLngID = ''' + CAST(@nLngID AS VARCHAR(10)) + '''';
            SET @tSql += @tSql1
            SET @tSql +=' ) TnfWah'
        EXECUTE(@tSql)
    END TRY
    BEGIN CATCH 
        SET @FNResult= -1
    END CATCH	

IF OBJECT_ID(N'TRPTPdtHisTnfWahTmp') IS NULL BEGIN
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
    CONSTRAINT [PK__TRPTPdtH__F671FB6B5A86F19A] PRIMARY KEY CLUSTERED 
    (
        [FTRptRowSeq] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
END
GO






/****** Object:  StoredProcedure [dbo].[SP_RPTxPurByPdt]    Script Date: 14/9/2565 13:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPurByPdt]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPurByPdt
GO
CREATE PROCEDURE [dbo].[SP_RPTxPurByPdt]
--ALTER PROCEDURE [dbo].[SP_RPTxSalDailyByCashierTmp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

--Agency
	@ptAgnL Varchar(8000), --Agency Condition IN
	  
--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN

--Shop
	@ptShpL Varchar(8000), 

--Purchase
	@ptStaApv Varchar(1),--FTXphStaApv สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว
	@ptStaPaid Varchar(1),-- FTXphStaPaid สถานะ รับ/จ่ายเงิน 1:ยังไม่จ่าย 2:บางส่วน, 3:ครบ

--Supplier
	@ptSplF Varchar(20), @ptSplT Varchar(20),-- FTSplCode รหัสผู้จำหน่าย
	@ptSgpF Varchar(5),@ptSgpT Varchar(5),-- FTSgpCode กลุ่มผู้จำหน่าย
	@ptStyF Varchar(5),@ptStyT Varchar(5),--FTStyCode ประเภทผู้จำหน่าย
	
--Pdt
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

	@ptDocDateF Varchar(10), @ptDocDateT Varchar(10), 
	
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
	DECLARE @tSql1 VARCHAR(8000)

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

	SET @ptDocDateF = CONVERT(VARCHAR(10),@ptDocDateF,121)
	SET @ptDocDateT = CONVERT(VARCHAR(10),@ptDocDateT,121)

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

	IF @ptShpL = null
	BEGIN
		SET @ptShpL = ''
	END

	--Purchase
	IF @ptStaApv = NULL --FTXphStaApv สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว
	BEGIN
		SET @ptStaApv = ''
	END

	IF @ptStaPaid = NULL --FTXphStaPaid สถานะ รับ/จ่ายเงิน 1:ยังไม่จ่าย 2:บางส่วน, 3:ครบ
	BEGIN
		SET @ptStaPaid = ''
	END

	IF @ptSplF =NULL -- FTSplCode รหัสผู้จำหน่าย
	BEGIN
		SET @ptSplF = ''
	END
	IF @ptSplT =null OR @ptSplT = ''
	BEGIN
		SET @ptSplT = @ptSplF
	END 

	IF @ptSgpF =NULL -- FTSgpCode กลุ่มผู้จำหน่าย
	BEGIN
		SET @ptSgpF = ''
	END
	IF @ptSgpT =null OR @ptSgpT = ''
	BEGIN
		SET @ptSgpT = @ptSgpF
	END 

	IF @ptStyF =NULL --FTStyCode ประเภทผู้จำหน่าย
	BEGIN
		SET @ptStyF = ''
	END
	IF @ptStyT =null OR @ptStyT = ''
	BEGIN
		SET @ptStyT = @ptStyF
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

	IF @ptDocDateF = null
	BEGIN 
		SET @ptDocDateF = ''
	END

	IF @ptDocDateT = null OR @ptDocDateT =''
	BEGIN 
		SET @ptDocDateT = @ptDocDateF
	END
	
		
	SET @tSql1 =   ' WHERE 1=1 '
	--Center
	IF (@ptAgnL <> '' )
	BEGIN
		SET @tSql1 +=' AND Spl.FTAgnCode IN (' + @ptAgnL + ')' --Agency
	END


	IF (@ptBchL <> '' )
	BEGIN
		SET @tSql1 +=' AND HD.FTBchCode IN (' + @ptBchL + ')' --Branch
	END


	IF (@ptShpL <> '' )
	BEGIN
		SET @tSql1 +=' AND HD.FTShpCode IN (' + @ptShpL + ')' --Shop
	END
	
	--Purchase
	IF (@ptStaApv<> '') --FTXphStaApv สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว
	BEGIN
		SET @tSql1 +=' AND HD.FTXphStaApv = ''' + @ptStaApv + '''' 
	END

	IF (@ptStaPaid<> '') -- FTXphStaPaid สถานะ รับ/จ่ายเงิน 1:ยังไม่จ่าย 2:บางส่วน, 3:ครบ
	BEGIN
		SET @tSql1 +=' AND HD.FTXphStaPaid = ''' + @ptStaPaid + '''' 
	END

	--Supplier
	IF (@ptSplF<> '') -- FTSplCode รหัสผู้จำหน่าย
	BEGIN
		SET @tSql1 +=' AND HD.FTSplCode BETWEEN ''' + @ptSplF + ''' AND ''' + @ptSplT + '''' 
	END

	IF (@ptSgpF<> '') -- FTSgpCode กลุ่มผู้จำหน่าย
	BEGIN
		SET @tSql1 +=' AND Spl.FTSgpCode BETWEEN ''' + @ptSgpF + ''' AND ''' + @ptSgpT + '''' 
	END

	IF (@ptSgpF<> '') -- FTStyCode ประเภทผู้จำหน่าย
	BEGIN
		SET @tSql1 +=' AND Spl.FTStyCode BETWEEN ''' + @ptSgpF + ''' AND ''' + @ptSgpT + '''' 
	END

	--Product
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
	IF (@ptDocDateF <> '' AND @ptDocDateT <> '')
	BEGIN
    	SET @tSql1 +=' AND CONVERT(VARCHAR(10),HD.FDXphDocDate,121) BETWEEN ''' + @ptDocDateF + ''' AND ''' + @ptDocDateT + ''''
	
	END
	--PRINT '99999'
	DELETE FROM TRPTPurByPdtTmp  WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--Åº¢éÍÁÙÅ Temp ¢Í§à¤Ã×èÍ§·Õè¨ÐºÑ¹·Ö¡¢ÍÁÙÅÅ§ Temp

	SET @tSql = 'INSERT INTO TRPTPurByPdtTmp'
	--PRINT @tSql
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FTPdtCode,FTPdtName,FTPunName,FCXpdQty,FCXpdDis,FCXpdValue,FCXpdVat ,FCXpdNetAmt'
	SET @tSql +=' )'
	--PRINT @tSql
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' FTPdtCode,FTPdtName,FTPunName,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdQty ELSE FCXpdQty*-1 END) AS FCXpdQty,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdDis ELSE FCXpdDis*-1 END) AS FCXpdDis,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdValue ELSE FCXpdValue*-1 END) AS FCXpdValue,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdVat ELSE FCXpdVat*-1 END) AS FCXpdVat ,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdNetAmt ELSE FCXpdNetAmt*-1 END) AS FCXpdNetAmt'
	SET @tSql +=' FROM'
		--Purchase
		SET @tSql +=' (SELECT ''1'' AS FNXpdPurType, HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,ISNULL(PdtL.FTPdtName,'''') AS FTPdtName,DT.FTPunCode,ISNULL(PunL.FTPunName,'''') AS FTPunName,'
		 SET @tSql +=' SUM(DT.FCXpdQty) AS FCXpdQty,SUM(ISNULL(Dis.FCXpdDis,0)) AS FCXpdDis,'
		 SET @tSql +=' SUM(CASE' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0)) - ISNULL(DT.FCXpdVat,0)'
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0))'
			 SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdValue,'
 		 SET @tSql +=' SUM(ISNULL(DT.FCXpdVat,0)) AS FCXpdVat,'
		 SET @tSql +=' SUM(CASE' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD)' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD + ISNULL(DT.FCXpdVat,0))'
			 SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdNetAmt'
 		 SET @tSql +=' FROM TAPTPiDT DT WITH(NOLOCK)' 
		 SET @tSql +=' INNER JOIN TAPTPiHD HD WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode	AND DT.FTXphDocNo = HD.FTXphDocNo'	
		 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON  DT.FTPdtCode = Pdt.FTPdtCode'	
		 SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON  DT.FTPdtCode = PdtL.FTPdtCode	AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMPdtUnit_L PunL WITH(NOLOCK) ON  DT.FTPunCode = PunL.FTPunCode	AND PunL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMSpl Spl WITH(NOLOCK) ON HD.FTSplCode = Spl.FTSplCode'
		 SET @tSql +=' LEFT JOIN TCNMSpl_L SplL WITH(NOLOCK) ON HD.FTSplCode = SplL.FTSplCode	AND SplL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 --LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode'
		 SET @tSql +=' LEFT JOIN' 
	 			SET @tSql +=' ('
					SET @tSql +=' SELECT FTBchCode,FTXphDocNo,FNXpdSeqNo,' 
					SET @tSql +=' SUM(CASE' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''1'',''2'') THEN FCXpdValue *-1' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''3'',''4'') THEN FCXpdValue'
					SET @tSql +=' END) AS FCXpdDis'
					SET @tSql +=' FROM TAPTPiDTDis'
					SET @tSql +=' GROUP BY FTBchCode,FTXphDocNo,FNXpdSeqNo' 
				SET @tSql +=' ) Dis ON DT.FTBchCode = Dis.FTBchCode	 AND DT.FTXphDocNo	= Dis.FTXphDocNo	AND DT.FNXpdSeqNo	= Dis.FNXpdSeqNo'	
				SET @tSql += @tSql1
				--WHERE  DT.FTPdtCode = '01875'
		 SET @tSql +=' GROUP BY HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,PdtL.FTPdtName,DT.FTPunCode,PunL.FTPunName'

		 SET @tSql +=' UNION ALL'
		--CreditNote
		 SET @tSql +=' SELECT ''2'' AS FNXpdPurType, HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,ISNULL(PdtL.FTPdtName,'''') AS FTPdtName,DT.FTPunCode,ISNULL(PunL.FTPunName,'''') AS FTPunName,'
		 SET @tSql +=' SUM(DT.FCXpdQty) AS FCXpdQty,SUM(ISNULL(Dis.FCXpdDis,0)) AS FCXpdDis,'
		 SET @tSql +=' SUM(CASE' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0)) - ISNULL(DT.FCXpdVat,0)'
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0))'
			 SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdValue,'
		 SET @tSql +=' SUM(ISNULL(DT.FCXpdVat,0)) AS FCXpdVat,'
		 SET @tSql +=' SUM(CASE'
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD)' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD + ISNULL(DT.FCXpdVat,0))'
			 SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdNetAmt'

		 SET @tSql +=' FROM TAPTPcDT DT WITH(NOLOCK)' 
		 SET @tSql +=' INNER JOIN TAPTPcHD HD WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode	AND DT.FTXphDocNo = HD.FTXphDocNo'	
		 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON  DT.FTPdtCode = Pdt.FTPdtCode'	
		 SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON  DT.FTPdtCode = PdtL.FTPdtCode	AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMPdtUnit_L PunL WITH(NOLOCK) ON  DT.FTPunCode = PunL.FTPunCode	AND PunL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMSpl Spl WITH(NOLOCK) ON HD.FTSplCode = Spl.FTSplCode'	
		 SET @tSql +=' LEFT JOIN TCNMSpl_L SplL WITH(NOLOCK) ON HD.FTSplCode = SplL.FTSplCode	AND SplL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 --LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode
		 SET @tSql +=' LEFT JOIN' 
				SET @tSql +=' ('
					SET @tSql +=' SELECT FTBchCode,FTXphDocNo,FNXpdSeqNo,' 
					SET @tSql +=' SUM(CASE' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''1'',''2'') THEN FCXpdValue *-1' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''3'',''4'') THEN FCXpdValue'
					SET @tSql +=' END) AS FCXpdDis'
					SET @tSql +=' FROM TAPTPcDTDis'
					SET @tSql +=' GROUP BY FTBchCode,FTXphDocNo,FNXpdSeqNo' 
				SET @tSql +=' ) Dis ON DT.FTBchCode = Dis.FTBchCode	 AND DT.FTXphDocNo = Dis.FTXphDocNo	AND DT.FNXpdSeqNo = Dis.FNXpdSeqNo'	
				SET @tSql += @tSql1
				--WHERE  DT.FTPdtCode = '01875'
		 SET @tSql +=' GROUP BY HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,PdtL.FTPdtName,DT.FTPunCode,PunL.FTPunName'
		SET @tSql +=' ) Pur'
		--WHERE FTPdtCode = '00145'
	SET @tSql +=' GROUP BY Pur.FTPdtCode,FTPdtName,FTPunName'	
	PRINT @tSql
	EXECUTE(@tSql)
	--'''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	--RETURN SELECT * FROM TRPTSalDailyByCashierTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
END TRY

BEGIN CATCH 
	SET @FNResult= -1
	--PRINT @tSql
END CATCH	
GO



DROP PROCEDURE IF EXISTS [dbo].[SP_RPTxPurSplByPdt] 
GO
/****** Object:  StoredProcedure [dbo].[SP_RPTxPurSplByPdt]    Script Date: 14/9/2565 13:35:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPurSplByPdt]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPurSplByPdt
GO
CREATE PROCEDURE [dbo].[SP_RPTxPurSplByPdt]
--ALTER PROCEDURE [dbo].[SP_RPTxSalDailyByCashierTmp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

--Agency
	@ptAgnL Varchar(8000), --Agency Condition IN
	  
--สาขา
	@ptBchL Varchar(8000), --สาขา Condition IN

--Shop
	@ptShpL Varchar(8000), 

--Purchase
	@ptStaApv Varchar(1),--FTXphStaApv สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว
	                     --การส่งค่า 0 : ไม่ Condition 1 : ยังไม่อนุมัติ 2 : อนุมัติแล้ว 
	@ptStaPaid Varchar(1),-- FTXphStaPaid สถานะ รับ/จ่ายเงิน 1:ยังไม่จ่าย 2:บางส่วน, 3:ครบ

--Supplier
	@ptSplF Varchar(20), @ptSplT Varchar(20),-- FTSplCode รหัสผู้จำหน่าย
	@ptSgpF Varchar(5),@ptSgpT Varchar(5),-- FTSgpCode กลุ่มผู้จำหน่าย
	@ptStyF Varchar(5),@ptStyT Varchar(5),--FTStyCode ประเภทผู้จำหน่าย
	
--Pdt
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

	@ptDocDateF Varchar(10), @ptDocDateT Varchar(10), 
	
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
	DECLARE @tSql1 VARCHAR(8000)

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

	SET @ptDocDateF = CONVERT(VARCHAR(10),@ptDocDateF,121)
	SET @ptDocDateT = CONVERT(VARCHAR(10),@ptDocDateT,121)

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

	IF @ptShpL = null
	BEGIN
		SET @ptShpL = ''
	END

	--Purchase
	IF @ptStaApv = NULL --FTXphStaApv สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว
	BEGIN
		SET @ptStaApv = '0'
	END

	IF @ptStaApv = '' --FTXphStaApv สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว
	BEGIN
		SET @ptStaApv = '0'
	END

	IF @ptStaPaid = NULL --FTXphStaPaid สถานะ รับ/จ่ายเงิน 1:ยังไม่จ่าย 2:บางส่วน, 3:ครบ
	BEGIN
		SET @ptStaPaid = ''
	END

	IF @ptSplF =NULL -- FTSplCode รหัสผู้จำหน่าย
	BEGIN
		SET @ptSplF = ''
	END
	IF @ptSplT =null OR @ptSplT = ''
	BEGIN
		SET @ptSplT = @ptSplF
	END 

	IF @ptSgpF =NULL -- FTSgpCode กลุ่มผู้จำหน่าย
	BEGIN
		SET @ptSgpF = ''
	END
	IF @ptSgpT =null OR @ptSgpT = ''
	BEGIN
		SET @ptSgpT = @ptSgpF
	END 

	IF @ptStyF =NULL --FTStyCode ประเภทผู้จำหน่าย
	BEGIN
		SET @ptStyF = ''
	END
	IF @ptStyT =null OR @ptStyT = ''
	BEGIN
		SET @ptStyT = @ptStyF
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

	IF @ptDocDateF = null
	BEGIN 
		SET @ptDocDateF = ''
	END

	IF @ptDocDateT = null OR @ptDocDateT =''
	BEGIN 
		SET @ptDocDateT = @ptDocDateF
	END
	
		
	SET @tSql1 =   ' WHERE 1=1 '
	--Center
	IF (@ptAgnL <> '' )
	BEGIN
		SET @tSql1 +=' AND Bch.FTAgnCode IN (' + @ptAgnL + ')' --Agency
	END


	IF (@ptBchL <> '' )
	BEGIN
		SET @tSql1 +=' AND HD.FTBchCode IN (' + @ptBchL + ')' --Branch
	END


	IF (@ptShpL <> '' )
	BEGIN
		SET @tSql1 +=' AND HD.FTShpCode IN (' + @ptShpL + ')' --Shop
	END
	
	--Purchase
	IF (@ptStaApv <> '0' ) --การส่งค่า 0 : ไม่ Condition 1 : ยังไม่อนุมัติ 2 : อนุมัติแล้ว  FTXphStaApv สถานะ อนุมัติ เอกสาร ว่าง:ยังไม่ทำ, 1:อนุมัติแล้ว
	BEGIN
		SET @tSql1 +=' AND CASE WHEN FTXphStaApv = ''1'' THEN ''2'' ELSE ''1'' END  = ''' + @ptStaApv + '''' 
	END

	IF (@ptStaPaid<> '') -- FTXphStaPaid สถานะ รับ/จ่ายเงิน 1:ยังไม่จ่าย 2:บางส่วน, 3:ครบ
	BEGIN
		SET @tSql1 +=' AND HD.FTXphStaPaid = ''' + @ptStaPaid + '''' 
	END

	--Supplier
	IF (@ptSplF<> '') -- FTSplCode รหัสผู้จำหน่าย
	BEGIN
		SET @tSql1 +=' AND HD.FTSplCode BETWEEN ''' + @ptSplF + ''' AND ''' + @ptSplT + '''' 
	END

	IF (@ptSgpF<> '') -- FTSgpCode กลุ่มผู้จำหน่าย
	BEGIN
		SET @tSql1 +=' AND Spl.FTSgpCode BETWEEN ''' + @ptSgpF + ''' AND ''' + @ptSgpT + '''' 
	END

	IF (@ptSgpF<> '') -- FTStyCode ประเภทผู้จำหน่าย
	BEGIN
		SET @tSql1 +=' AND Spl.FTStyCode BETWEEN ''' + @ptSgpF + ''' AND ''' + @ptSgpT + '''' 
	END

	--Product
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
	IF (@ptDocDateF <> '' AND @ptDocDateT <> '')
	BEGIN
    	SET @tSql1 +=' AND CONVERT(VARCHAR(10),HD.FDXphDocDate,121) BETWEEN ''' + @ptDocDateF + ''' AND ''' + @ptDocDateT + ''''
	
	END
	--PRINT '99999'
	DELETE FROM TRPTPurSplByPdtTmp  WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--Åº¢éÍÁÙÅ Temp ¢Í§à¤Ã×èÍ§·Õè¨ÐºÑ¹·Ö¡¢ÍÁÙÅÅ§ Temp

	SET @tSql = 'INSERT INTO TRPTPurSplByPdtTmp'
	--PRINT @tSql
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FTSplCode,FTSplName,FTPdtCode,FTPdtName,FTPunName,FCXpdQty,FCXpdDis,FCXpdValue,FCXpdVat ,FCXpdNetAmt'
	SET @tSql +=' )'
	--PRINT @tSql
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' FTSplCode,FTSplName,FTPdtCode,FTPdtName,FTPunName,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdQty ELSE FCXpdQty*-1 END) AS FCXpdQty,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdDis ELSE FCXpdDis*-1 END) AS FCXpdDis,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdValue ELSE FCXpdValue*-1 END) AS FCXpdValue,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdVat ELSE FCXpdVat*-1 END) AS FCXpdVat ,'
	SET @tSql +=' SUM(CASE WHEN FNXpdPurType = ''1'' THEN FCXpdNetAmt ELSE FCXpdNetAmt*-1 END) AS FCXpdNetAmt'
	SET @tSql +=' FROM'
		--Purchase
		SET @tSql +=' (SELECT ''1'' AS FNXpdPurType, HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,ISNULL(PdtL.FTPdtName,'''') AS FTPdtName,DT.FTPunCode,ISNULL(PunL.FTPunName,'''') AS FTPunName,'
		 SET @tSql +=' SUM(DT.FCXpdQty) AS FCXpdQty,SUM(ISNULL(Dis.FCXpdDis,0)) AS FCXpdDis,'
		 SET @tSql +=' SUM(CASE' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0)) - ISNULL(DT.FCXpdVat,0)'
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0))'
			 SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdValue,'
 		 SET @tSql +=' SUM(ISNULL(DT.FCXpdVat,0)) AS FCXpdVat,'
		 SET @tSql +=' SUM(CASE' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD)' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD + ISNULL(DT.FCXpdVat,0))'
			 SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdNetAmt'
 		 SET @tSql +=' FROM TAPTPiDT DT WITH(NOLOCK)' 
		 SET @tSql +=' INNER JOIN TAPTPiHD HD WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode	AND DT.FTXphDocNo = HD.FTXphDocNo'	
		 SET @tSql +=' LEFT JOIN TCNMBranch Bch WITH(NOLOCK) ON HD.FTBchCode = Bch.FTBchCode'
		 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON  DT.FTPdtCode = Pdt.FTPdtCode'	
		 SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON  DT.FTPdtCode = PdtL.FTPdtCode	AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMPdtUnit_L PunL WITH(NOLOCK) ON  DT.FTPunCode = PunL.FTPunCode	AND PunL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMSpl Spl WITH(NOLOCK) ON HD.FTSplCode = Spl.FTSplCode'
		 SET @tSql +=' LEFT JOIN TCNMSpl_L SplL WITH(NOLOCK) ON HD.FTSplCode = SplL.FTSplCode	AND SplL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 --LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode'
		 SET @tSql +=' LEFT JOIN' 
	 			SET @tSql +=' ('
					SET @tSql +=' SELECT FTBchCode,FTXphDocNo,FNXpdSeqNo,' 
					SET @tSql +=' SUM(CASE' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''1'',''2'') THEN FCXpdValue *-1' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''3'',''4'') THEN FCXpdValue'
					SET @tSql +=' END) AS FCXpdDis'
					SET @tSql +=' FROM TAPTPiDTDis'
					SET @tSql +=' GROUP BY FTBchCode,FTXphDocNo,FNXpdSeqNo' 
				SET @tSql +=' ) Dis ON DT.FTBchCode = Dis.FTBchCode	 AND DT.FTXphDocNo	= Dis.FTXphDocNo	AND DT.FNXpdSeqNo	= Dis.FNXpdSeqNo'	
				SET @tSql += @tSql1
				--WHERE  DT.FTPdtCode = '01875'
		 SET @tSql +=' GROUP BY HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,PdtL.FTPdtName,DT.FTPunCode,PunL.FTPunName'

		 SET @tSql +=' UNION ALL'
		--CreditNote
		 SET @tSql +=' SELECT ''2'' AS FNXpdPurType, HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,ISNULL(PdtL.FTPdtName,'''') AS FTPdtName,DT.FTPunCode,ISNULL(PunL.FTPunName,'''') AS FTPunName,'
		 SET @tSql +=' SUM(DT.FCXpdQty) AS FCXpdQty,SUM(ISNULL(Dis.FCXpdDis,0)) AS FCXpdDis,'
		 SET @tSql +=' SUM(CASE' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0)) - ISNULL(DT.FCXpdVat,0)'
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0))'
			 SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdValue,'
		 SET @tSql +=' SUM(ISNULL(DT.FCXpdVat,0)) AS FCXpdVat,'
		 SET @tSql +=' SUM(CASE'
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD)' 
			 SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD + ISNULL(DT.FCXpdVat,0))'
			 SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdNetAmt'

		 SET @tSql +=' FROM TAPTPcDT DT WITH(NOLOCK)' 
		 SET @tSql +=' INNER JOIN TAPTPcHD HD WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode	AND DT.FTXphDocNo = HD.FTXphDocNo'	
		 SET @tSql +=' LEFT JOIN TCNMBranch Bch WITH(NOLOCK) ON HD.FTBchCode = Bch.FTBchCode'
		 SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON  DT.FTPdtCode = Pdt.FTPdtCode'	
		 SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON  DT.FTPdtCode = PdtL.FTPdtCode	AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMPdtUnit_L PunL WITH(NOLOCK) ON  DT.FTPunCode = PunL.FTPunCode	AND PunL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 SET @tSql +=' LEFT JOIN TCNMSpl Spl WITH(NOLOCK) ON HD.FTSplCode = Spl.FTSplCode'	
		 SET @tSql +=' LEFT JOIN TCNMSpl_L SplL WITH(NOLOCK) ON HD.FTSplCode = SplL.FTSplCode	AND SplL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		 --LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode
		 SET @tSql +=' LEFT JOIN' 
				SET @tSql +=' ('
					SET @tSql +=' SELECT FTBchCode,FTXphDocNo,FNXpdSeqNo,' 
					SET @tSql +=' SUM(CASE' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''1'',''2'') THEN FCXpdValue *-1' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''3'',''4'') THEN FCXpdValue'
					SET @tSql +=' END) AS FCXpdDis'
					SET @tSql +=' FROM TAPTPcDTDis'
					SET @tSql +=' GROUP BY FTBchCode,FTXphDocNo,FNXpdSeqNo' 
				SET @tSql +=' ) Dis ON DT.FTBchCode = Dis.FTBchCode	 AND DT.FTXphDocNo = Dis.FTXphDocNo	AND DT.FNXpdSeqNo = Dis.FNXpdSeqNo'	
				SET @tSql += @tSql1
				--WHERE  DT.FTPdtCode = '01875'
		 SET @tSql +=' GROUP BY HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,PdtL.FTPdtName,DT.FTPunCode,PunL.FTPunName'

		SET @tSql +=' UNION ALL'	
		--Debit Note	
		SET @tSql +=' SELECT ''1'' AS FNXpdPurType, HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,ISNULL(PdtL.FTPdtName,'''') AS FTPdtName,DT.FTPunCode,ISNULL(PunL.FTPunName,'''') AS FTPunName,'
			SET @tSql +=' SUM(DT.FCXpdQty) AS FCXpdQty,SUM(ISNULL(Dis.FCXpdDis,0)) AS FCXpdDis,'
			SET @tSql +=' SUM(CASE' 
				SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0)) - ISNULL(DT.FCXpdVat,0)'
				SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD -ISNULL(Dis.FCXpdDis,0))'
				SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdValue,'
 			SET @tSql +=' SUM(ISNULL(DT.FCXpdVat,0)) AS FCXpdVat,'
			SET @tSql +=' SUM(CASE' 
				SET @tSql +=' WHEN FTXphVATInOrEx = ''1'' THEN (DT.FCXpdNetAfHD)' 
				SET @tSql +=' WHEN FTXphVATInOrEx = ''2'' THEN (DT.FCXpdNetAfHD + ISNULL(DT.FCXpdVat,0))'
				SET @tSql +=' END'
			SET @tSql +=' ) AS FCXpdNetAmt'
 			SET @tSql +=' FROM TAPTPdDT DT WITH(NOLOCK)' 
			SET @tSql +=' INNER JOIN TAPTPdHD HD WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode	AND DT.FTXphDocNo = HD.FTXphDocNo'	
			SET @tSql +=' LEFT JOIN TCNMBranch Bch WITH(NOLOCK) ON HD.FTBchCode = Bch.FTBchCode'
			SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON  DT.FTPdtCode = Pdt.FTPdtCode'	
			SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON  DT.FTPdtCode = PdtL.FTPdtCode	AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			SET @tSql +=' LEFT JOIN TCNMPdtUnit_L PunL WITH(NOLOCK) ON  DT.FTPunCode = PunL.FTPunCode	AND PunL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			SET @tSql +=' LEFT JOIN TCNMSpl Spl WITH(NOLOCK) ON HD.FTSplCode = Spl.FTSplCode'
			SET @tSql +=' LEFT JOIN TCNMSpl_L SplL WITH(NOLOCK) ON HD.FTSplCode = SplL.FTSplCode	AND SplL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			--LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode'
			SET @tSql +=' LEFT JOIN' 
	 			SET @tSql +=' ('
					SET @tSql +=' SELECT FTBchCode,FTXphDocNo,FNXpdSeqNo,' 
					SET @tSql +=' SUM(CASE' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''1'',''2'') THEN FCXpdValue *-1' 
						SET @tSql +=' WHEN FTXpdDisChgType IN (''3'',''4'') THEN FCXpdValue'
					SET @tSql +=' END) AS FCXpdDis'
					SET @tSql +=' FROM TAPTPdDTDis'
					SET @tSql +=' GROUP BY FTBchCode,FTXphDocNo,FNXpdSeqNo' 
				SET @tSql +=' ) Dis ON DT.FTBchCode = Dis.FTBchCode	 AND DT.FTXphDocNo	= Dis.FTXphDocNo	AND DT.FNXpdSeqNo	= Dis.FNXpdSeqNo'	
				SET @tSql += @tSql1
				--WHERE  DT.FTPdtCode = '01875'
	SET @tSql +=' GROUP BY HD.FTSplCode,SplL.FTSplName,DT.FTPdtCode,PdtL.FTPdtName,DT.FTPunCode,PunL.FTPunName'	
	SET @tSql +=' ) Pur'
	--WHERE FTPdtCode = '00145'
	SET @tSql +=' GROUP BY FTSplCode,FTSplName,Pur.FTPdtCode,FTPdtName,FTPunName'
	--PRINT @tSql
	EXECUTE(@tSql)
	--'''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	--RETURN SELECT * FROM TRPTSalDailyByCashierTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
END TRY

BEGIN CATCH 
	SET @FNResult= -1
	--PRINT @tSql
END CATCH	
GO



/****** Object:  StoredProcedure [dbo].[SP_RPTxPurVat]    Script Date: 14/9/2565 13:31:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPurVat]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPurVat
GO
CREATE PROCEDURE [dbo].[SP_RPTxPurVat] 
--ALTER PROCEDURE [dbo].[SP_RPTxSalDailyByCashierTmp]
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptCode Varchar(100),
	@ptUsrSession Varchar(255),
	@pnFilterType int, --1 BETWEEN 2 IN

	--Agency
	@ptAgnL Varchar(8000), --กรณี Condition IN
	--สาขา

	@ptBchL Varchar(8000), --กรณี Condition IN

	--Shop Code
	@ptShpL Varchar(8000), --กรณี Condition IN
	--เครื่องจุดขาย

	--Supplier
	@ptSplF Varchar(20), @ptSplT Varchar(20),-- FTSplCode รหัสผู้จำหน่าย

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),

	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 10/07/2019
-- Temp name  TRPTSalRCTmp

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


	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า
	
	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

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

	IF @ptAgnL =null
	BEGIN
		SET @ptAgnL = ''
	END


	IF @ptShpL =null
	BEGIN
		SET @ptShpL = ''
	END


	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	IF @ptSplF =NULL -- FTSplCode รหัสผู้จำหน่าย
	BEGIN
		SET @ptSplF = ''
	END
	IF @ptSplT =null OR @ptSplT = ''
	BEGIN
		SET @ptSplT = @ptSplF
	END 

	SET @tSql1 = ' '

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSql1 +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptAgnL <> '' )
		BEGIN
			SET @tSql1 +=' AND Bch.FTAgnCode IN (' + @ptAgnL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
		END
	
	END
	--Supplier
	IF (@ptSplF<> '') -- FTSplCode รหัสผู้จำหน่าย
	BEGIN
		SET @tSql1 +=' AND HD.FTSplCode BETWEEN ''' + @ptSplF + ''' AND ''' + @ptSplT + '''' 
	END


	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXphDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTPurVatTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 
 	SET @tSql  = ' INSERT INTO TRPTPurVatTmp'
	SET @tSql +=' ('
	SET @tSql +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FTAgnCode,FTAgnName,FTBchCode,FTBchName,FDXphdocDate,FTXphDocNo,FTXphDocRef,FTSplCode,FTSplName,FTSplTaxNo,'
	SET @tSql +=' FCXphAmt,FCXphVat,FCXphAmtNV,FCXphGrandTotal,'
	--*NUI 2019-11-14
	SET @tSql +=' FNAppType,FTSplBchCode,FTSplBusiness,FTEstablishment'
	SET @tSql +=' ,FTXphRefExt,FDXphRefExtDate'
	-------------
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSql +=' FTAgnCode,FTAgnName ,SalVat.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXphDocDate,121) AS FDXphdocDate,FTXphDocNo,'
	 --FTPosCode,
	SET @tSql +=' FTXphRefInt,FTSplCode,FTSplName,FTSplTaxNo,FCXphValue,FCXphVat,FCXphAmtNV,FCXphGrand,'
	--*NUI 2019-11-14
	SET @tSql +=' FNAppType,'
	 --FTPosRegNo,
	SET @tSql +=' FTSplBchCode,FTSplBusiness,FTEstablishment' --สถานประกอบการ
	SET @tSql +=' ,FTXphRefExt,FDXphRefExtDate'
	SET @tSql +=' FROM'	
		SET @tSql +=' (SELECT Bch.FTAgnCode,Agnl.FTAgnName ,HD.FTBchCode,CONVERT(VARCHAR(10),FDXphDocDate,121) AS FDXphdocDate,'
		--HD.FTPosCode,
		SET @tSql +=' HD.FTXphDocNo,ISNULL(FTXphRefExt,'''') FTXphRefInt,HD.FTSplCode,Spl_L.FTSplName ,SplAddr.FTAddTaxNo AS FTSplTaxNo,'
		 --NUI10-04-2020
		SET @tSql +=' ISNULL(FCXphVatable,0)-ISNULL(FCXphAmtNV,0)  AS FCXphValue,'
		SET @tSql +=' ISNULL(FCXphVat,0) AS FCXphVat,'
		SET @tSql +=' ISNULL(FCXphAmtNV,0)AS FCXphAmtNV,'
		 --NUI10-04-2020
		SET @tSql +=' ISNULL(FCXphGrand,0)-ISNULL(FCXphRnd,0) AS FCXphGrand,'
		 --*NUI 2019-11-14
		SET @tSql +=' 1 AS FNAppType,'
			 --POS.FTPosRegNo,
		SET @tSql +=' ISNULL(FTSplBchCode,'''') AS FTSplBchCode,ISNULL(FTSplBusiness,''2'') AS FTSplBusiness,' -- ประเภทกิจการ 1:นิติบุคคล, 2:บุคคลธรรมดา
		SET @tSql +=' CASE WHEN ISNULL(FTSplBusiness,''2'') <> ''1'' THEN '''' ELSE CASE WHEN ISNULL(FTSplStaBchOrHQ,''1'') = ''1'' THEN ''Head Office'' ELSE ''Branch''  END + CASE WHEN FTSplBchCode <> '''' THEN '' / '' + FTSplBchCode ELSE '''' END   END AS FTEstablishment'
		SET @tSql +=' ,FTXphRefExt,FDXphRefExtDate'
		SET @tSql +=' FROM TAPTPiHD HD'
		SET @tSql +=' LEFT JOIN TAPTPiHDSpl HDSpl WITH (NOLOCK) ON HD.FTBchCode = HDSpl.FTBchCode AND HD.FTXphDocNo = HDSpl.FTXphDocNo'
		SET @tSql +=' LEFT JOIN TCNMSplAddress_L SplAddr  WITH (NOLOCK) ON HD.FTSplCode = SplAddr.FTSplCode AND SplAddr.FNLngID =    '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
		SET @tSql +=' LEFT JOIN TCNMBranch Bch WITH (NOLOCK) ON  HD.FTBchCode= Bch.FTBchCode'
		 	SET @tSql +=' LEFT JOIN TCNMSpl Spl ON HD.FTSplCode = Spl.FTSplCode AND FTAddGrpType = ''1'''
			SET @tSql +=' LEFT JOIN TCNMAgency_L Agnl ON Bch.FTAgnCode = AgnL.FTAgnCode AND AgnL.FNLngID =   '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
			SET @tSql +=' LEFT JOIN TCNMSpl_L Spl_L ON HD.FTSplCode = Spl_L.FTSplCode AND Spl_L.FNLngID =    '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '  
			SET @tSql +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode'
			SET @tSql +=' WHERE 1=1 AND FTXphStaDoc = ''1'''			  			
		 SET @tSql += @tSql1	
					
		SET @tSql +=' UNION ALL'
		SET @tSql +=' SELECT Bch.FTAgnCode,Agnl.FTAgnName ,HD.FTBchCode,CONVERT(VARCHAR(10),FDXphDocDate,121) AS FDXphdocDate,'
		--HD.FTPosCode,
		SET @tSql +=' HD.FTXphDocNo,ISNULL(FTXphRefExt,'''') FTXphRefInt,HD.FTSplCode,Spl_L.FTSplName ,SplAddr.FTAddTaxNo AS FTSplTaxNo,'
		 --NUI10-04-2020
		SET @tSql +=' (ISNULL(FCXphVatable,0)-ISNULL(FCXphAmtNV,0))*-1  AS FCXphValue,'
		SET @tSql +=' ISNULL(FCXphVat,0)*-1 AS FCXphVat,'
		SET @tSql +=' ISNULL(FCXphAmtNV,0)*-1 AS FCXphAmtNV,'
		 --NUI10-04-2020
		SET @tSql +=' (ISNULL(FCXphGrand,0)-ISNULL(FCXphRnd,0))*-1 AS FCXphGrand,'
		 --*NUI 2019-11-14
		SET @tSql +=' 1 AS FNAppType,'
			 --POS.FTPosRegNo,
		SET @tSql +=' ISNULL(FTSplBchCode,'''') AS FTSplBchCode,ISNULL(FTSplBusiness,''2'') AS FTSplBusiness,' -- ประเภทกิจการ 1:นิติบุคคล, 2:บุคคลธรรมดา
		SET @tSql +=' CASE WHEN ISNULL(FTSplBusiness,''2'') <> ''1'' THEN '''' ELSE CASE WHEN ISNULL(FTSplStaBchOrHQ,''1'') = ''1'' THEN ''Head Office'' ELSE ''Branch''  END + CASE WHEN FTSplBchCode <> '''' THEN '' / '' + FTSplBchCode ELSE '''' END   END AS FTEstablishment'
		SET @tSql +=' ,FTXphRefExt,FDXphRefExtDate'
		SET @tSql +=' FROM TAPTPcHD HD' 
		SET @tSql +=' LEFT JOIN TAPTPiHDSpl HDSpl WITH (NOLOCK) ON HD.FTBchCode = HDSpl.FTBchCode AND HD.FTXphDocNo = HDSpl.FTXphDocNo'
		SET @tSql +=' LEFT JOIN TCNMSplAddress_L SplAddr  WITH (NOLOCK) ON HD.FTSplCode = SplAddr.FTSplCode AND SplAddr.FNLngID =    '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
		SET @tSql +=' LEFT JOIN TCNMBranch Bch WITH (NOLOCK) ON  HD.FTBchCode= Bch.FTBchCode'
		 	SET @tSql +=' LEFT JOIN TCNMSpl Spl ON HD.FTSplCode = Spl.FTSplCode AND FTAddGrpType = ''1'''
			SET @tSql +=' LEFT JOIN TCNMAgency_L Agnl ON Bch.FTAgnCode = AgnL.FTAgnCode AND AgnL.FNLngID =   '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' ' 
			SET @tSql +=' LEFT JOIN TCNMSpl_L Spl_L ON HD.FTSplCode = Spl_L.FTSplCode AND Spl_L.FNLngID =    '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '  
			SET @tSql +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode'
			SET @tSql +=' WHERE 1=1 AND FTXphStaDoc = ''1'''			  			
		 SET @tSql += @tSql1
	 SET @tSql +=' ) SalVat LEFT JOIN'     
	 SET @tSql +=' TCNMBranch_L Bch_L ON SalVat.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '     
	--SET @tSql +=' TCNMBranch_L Bch_L ON SalVat.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '	 
	
	--PRINT @tSql
	EXECUTE(@tSql)

	RETURN SELECT * FROM TRPTPSTaxHDFullTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH
GO





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPSSVatByMonth_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPSSVatByMonth_Animate
GO
CREATE PROCEDURE [dbo].[SP_RPTxPSSVatByMonth_Animate] 
--ALTER PROCEDURE [dbo].[SP_RPTxPSSVatByDate1001007] 
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



	@ptMonth Varchar(2),
	@ptYear Varchar(4),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 12/09/2022
-- Temp name  TRPTPSTaxMonthTmp_Animate
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
-- @ptBchL สาขา เชือก
	--DECLARE @tPosCodeF Varchar(30)
	--DECLARE @tPosCodeT Varchar(30)
-- @@ptMonth เดือน
-- @@ptYear ปี
-- @FNResult

--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlDrop VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSqlSale VARCHAR(8000)
	DECLARE @tTblName Varchar(255)
	DECLARE @tSqlS Varchar(255)
	DECLARE @tSqlR Varchar(255)
	DECLARE @tSql2 VARCHAR(255)

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


	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--SET @tBchF = @ptBchF
	--SET @tBchT = @ptBchT

	--SET @tPosCodeF  = @ptPosCodeF 
	--SET @tPosCodeT = @ptPosCodeT 

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

	--SET @tDocDateF = @ptDocDateF
	--SET @tDocDateT = @ptDocDateT

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


	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	SET @tSql2 =   ' WHERE FTXshStaDoc = ''1'''
	SET @tSqlS =   ' WHERE FTXshStaDoc = ''1'' AND ISNULL(FTXshDocVatFull,'''') <> '''''
	SET @tSqlR =   ' WHERE FTXshStaDoc = ''1'' AND FNXshDocType = ''9'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSqlR +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSql2 +=' AND HDL.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSqlR +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSql2 +=' AND HDL.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSqlR +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSql2 +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSqlR += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSql2 += ' AND HDL.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSqlR +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql2 +=' AND HDL.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlR +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql2 +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlR +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql2 +=' AND HDL.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSqlR += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSql2 += ' AND HDL.FTPosCode IN (' + @ptPosL + ')'
		END		
	END

	IF (@ptMonth <> '' )
	BEGIN
		SET @tSql2 +=' AND FORMAT( HDL.FDXshDocDate, ''MM'', ''en-US'' ) = ''' + @ptMonth +''''
		SET @tSqlS +=' AND FORMAT( HD.FDXshDocDate, ''MM'', ''en-US'' ) = ''' + @ptMonth +''''
		--SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	IF (@ptYear <> '' )
	BEGIN
		SET @tSql2 +=' AND FORMAT( HDL.FDXshDocDate, ''yyyy'', ''en-US'' ) = ''' + @ptYear +''''
		SET @tSqlS +=' AND FORMAT( HD.FDXshDocDate, ''yyyy'', ''en-US'' ) = ''' + @ptYear +''''
		--SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTPSTaxMonthTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp

	--SET @tTblName = 'TRPTPSTaxTmp'+ @nComName + ''

	----if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].''+@tTblName''')) 
	--SET @tSqlDrop = ' if exists (select * from dbo.sysobjects where name = '''+@tTblName+ ''')'--id = object_id(N'[dbo].''+@tTblName'''))' 
	--SET @tSqlDrop += ' DROP TABLE '+ @tTblName + ''
	----PRINT @tSqlDrop
	--EXECUTE(@tSqlDrop)

	--PRINT @tTblName 
	SET @tSqlSale  =' INSERT INTO TRPTPSTaxMonthTmp_Animate '
	SET @tSqlSale +=' ('
	SET @tSqlSale +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSqlSale +=' FNAppType,FTBchCode,FTXshDocDate,FTXshDocLegth,FTCstName,FTXshAddrTax,'
	SET @tSqlSale +=' FCXshAmtNV,FCXshVatable,FCXshVat,FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	-----------
	SET @tSqlSale +=' )'
 	SET @tSqlSale +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSqlSale +=' ''1'' AS FNAppType,'
	SET @tSqlSale +=' HDL.FTBchCode,FTXshDocDate,CASE WHEN HDL.FTXshDocVatFull = '''' THEN FTXshDocLegth ELSE HDFull.FTXshDocVat END AS FTXshDocLegth ,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN ISNULL(HDFull.FTXshCstName,'''') ELSE ISNULL(HDl.FTXshCstName,'''') END AS FTXshCstName,ISNULL(HDFull.FTXshAddrTax,'''') AS FTXshAddrTax,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshAmtNV ELSE HDL.FCXshAmtNV END AS FCXshAmtNV,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshVatable ELSE HDL.FCXshVatable END AS FCXshVatable,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshVat ELSE HDL.FCXshVat END AS FCXshVat,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshGrandAmt ELSE HDL.FCXshGrandAmt END AS FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	SET @tSqlSale +=' FROM('
		SET @tSqlSale +=' SELECT HDL.FTBchCode,FORMAT( FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'' )  AS FTXshDocDate,'
		SET @tSqlSale +=' MIN(HDL.FTXshDocNo) + ''-'' + Max(HDL.FTXshDocNo) AS FTXshDocLegth,Max(HDL.FDXshDocDate) AS FDXshDocDateSort,'
		SET @tSqlSale +=' ISNULL(HDL.FTXshDocVatFull,'''') AS FTXshDocVatFull,' 
		SET @tSqlSale +=' CASE WHEN ISNULL(HDL.FTXshDocVatFull,'''') = '''' THEN ''1'' ELSE ''2'' END AS FTXshGenTax' --'2'
		SET @tSqlSale +=' ,ISNULL(HDCst.FTXshCstName,'''')  AS FTXshCstName,'
		SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0) *-1 END ) AS FCXshAmtNV,'
		SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0))*-1 END) AS FCXshVatable,'
		SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END) AS FCXshVat,'
		SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END) AS FCXshGrandAmt,'
		SET @tSqlSale +=' FORMAT( FDXshDocDate, ''MMMM yyyy'', ''Th'' )  AS FTXshMonthTH,FORMAT( FDXshDocDate, ''MMMM yyyy'', ''en-US'' )  AS FTXshMonthEN'
		--PRINT @tSqlSale
		SET @tSqlSale +=' FROM TPSTSalHD HDL WITH(NOLOCK)'
		SET @tSqlSale +=' LEFT JOIN TPSTSalHDCst HDCst WITH(NOLOCK) ON HDL.FTBchCode = HDCst.FTBchCode AND HDL.FTXshDocNo = HDCst.FTXshDocNo'
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HDL.FTBchCode = Shp.FTBchCode AND HDL.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSql2
		SET @tSqlSale +=' GROUP BY HDL.FTBchCode,FORMAT( FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'' ),ISNULL(HDL.FTXshDocVatFull,''''),FNXshDocType,ISNULL(HDCst.FTXshCstName,''''), FORMAT( FDXshDocDate, ''MMMM yyyy'', ''Th'' ) ,FORMAT( FDXshDocDate, ''MMMM yyyy'', ''en-US'' )'
		SET @tSqlSale +=' ) AS HDL'
		SET @tSqlSale +=' LEFT JOIN' 
		SET @tSqlSale +=' ('
		  SET @tSqlSale +=' SELECT HD.FTBchCode,FTXshDocVatFull,FTXshDocVatFull + ''('' + HD.FTXshDocNo + '')'' AS FTXshDocVat,FTXshCstName,FTXshAddrTax,'
		  SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0)*-1 END AS FCXshAmtNV,'
		  SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0))*-1 END AS FCXshVatable,'
		  SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0) END AS FCXshVat,'
		  SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END AS FCXshGrandAmt'
		  SET @tSqlSale +=' FROM TPSTSalHD HD WITH(NOLOCK)'
		  SET @tSqlSale +=' LEFT JOIN TPSTTaxHDCst HDCst WITH(NOLOCK) ON HD.FTXshDocVatFull = HDCst.FTXshDocNo'
		  SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		  SET @tSqlSale += @tSqlS --' WHERE ISNULL(FTXshDocVatFull,'''') <> '''''
		SET @tSqlSale +=' ) AS HDFull ON HDL.FTBchCode = HDFull.FTBchCode AND HDL.FTXshDocVatFull = HDFull.FTXshDocVatFull'
	SET @tSqlSale +=' ORDER BY HDL.FDXshDocDateSort' --FTXshDocDate

	--PRINT @tSqlSale
	EXECUTE(@tSqlSale)

SET @tSqlSale  =' INSERT INTO TRPTPSTaxMonthTmp_Animate '
	SET @tSqlSale +=' ('
	SET @tSqlSale +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSqlSale +=' FNAppType,FTBchCode,FTXshDocDate,FTXshDocLegth,FTCstName,FTXshAddrTax,'
	SET @tSqlSale +=' FCXshAmtNV,FCXshVatable,FCXshVat,FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	-----------
	SET @tSqlSale +=' )'
 	SET @tSqlSale +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSqlSale +=' ''1'' AS FNAppType,'
	SET @tSqlSale +=' HDL.FTBchCode,FTXshDocDate,CASE WHEN HDL.FTXshDocVatFull = '''' THEN FTXshDocLegth ELSE HDFull.FTXshDocVat END AS FTXshDocLegth ,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN ISNULL(HDFull.FTXshCstName,'''') ELSE ISNULL(HDl.FTXshCstName,'''') END AS FTXshCstName,ISNULL(HDFull.FTXshAddrTax,'''') AS FTXshAddrTax,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshAmtNV ELSE HDL.FCXshAmtNV END AS FCXshAmtNV,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshVatable ELSE HDL.FCXshVatable END AS FCXshVatable,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshVat ELSE HDL.FCXshVat END AS FCXshVat,'
	SET @tSqlSale +=' CASE WHEN FTXshGenTax = ''2'' THEN HDFull.FCXshGrandAmt ELSE HDL.FCXshGrandAmt END AS FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	SET @tSqlSale +=' FROM('
		SET @tSqlSale +=' SELECT HDL.FTBchCode,FORMAT( FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'' )  AS FTXshDocDate,'
		SET @tSqlSale +=' MIN(HDL.FTXshDocNo) + ''-'' + Max(HDL.FTXshDocNo) AS FTXshDocLegth,Max(HDL.FDXshDocDate) AS FDXshDocDateSort,'
		SET @tSqlSale +=' ISNULL(HDL.FTXshDocVatFull,'''') AS FTXshDocVatFull,' 
		SET @tSqlSale +=' CASE WHEN ISNULL(HDL.FTXshDocVatFull,'''') = '''' THEN ''1'' ELSE ''2'' END AS FTXshGenTax' --'2'
		SET @tSqlSale +=' ,ISNULL(HDCst.FTXshCstName,'''')  AS FTXshCstName,'
		--
		SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0) *-1 END ) AS FCXshAmtNV,'
		SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0))*-1 END) AS FCXshVatable,'
		SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END) AS FCXshVat,'
		SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END) AS FCXshGrandAmt,'

		SET @tSqlSale +=' FORMAT( FDXshDocDate, ''MMMM yyyy'', ''Th'' )  AS FTXshMonthTH,FORMAT( FDXshDocDate, ''MMMM yyyy'', ''en-US'' )  AS FTXshMonthEN'
		--PRINT @tSqlSale
		SET @tSqlSale +=' FROM TVDTSalHD HDL WITH(NOLOCK)'
		SET @tSqlSale +=' LEFT JOIN TVDTSalHDCst HDCst WITH(NOLOCK) ON HDL.FTBchCode = HDCst.FTBchCode AND HDL.FTXshDocNo = HDCst.FTXshDocNo'
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HDL.FTBchCode = Shp.FTBchCode AND HDL.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSql2
		SET @tSqlSale +=' GROUP BY HDL.FTBchCode,FORMAT( FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'' ),ISNULL(HDL.FTXshDocVatFull,''''),FNXshDocType,ISNULL(HDCst.FTXshCstName,''''), FORMAT( FDXshDocDate, ''MMMM yyyy'', ''Th'' ) ,FORMAT( FDXshDocDate, ''MMMM yyyy'', ''en-US'' )'
		SET @tSqlSale +=' ) AS HDL'
		SET @tSqlSale +=' LEFT JOIN' 
		SET @tSqlSale +=' ('
		  SET @tSqlSale +=' SELECT HD.FTBchCode,FTXshDocVatFull,FTXshDocVatFull + ''('' + HD.FTXshDocNo + '')'' AS FTXshDocVat,FTXshCstName,FTXshAddrTax,'
		  SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0)*-1 END AS FCXshAmtNV,'
		  SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0))*-1 END AS FCXshVatable,'
		  SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0) END AS FCXshVat,'
		  SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END AS FCXshGrandAmt'
		  SET @tSqlSale +=' FROM TVDTSalHD HD WITH(NOLOCK)'
		  SET @tSqlSale +=' LEFT JOIN TVDTTaxHDCst HDCst WITH(NOLOCK) ON HD.FTXshDocVatFull = HDCst.FTXshDocNo'
		  SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		  SET @tSqlSale += @tSqlS --' WHERE ISNULL(FTXshDocVatFull,'''') <> '''''
		SET @tSqlSale +=' ) AS HDFull ON HDL.FTBchCode = HDFull.FTBchCode AND HDL.FTXshDocVatFull = HDFull.FTXshDocVatFull'
	SET @tSqlSale +=' ORDER BY HDL.FDXshDocDateSort' --FTXshDocDate
	EXECUTE(@tSqlSale)
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO





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
	SET @tSql1 =   ' WHERE FTXshStaDoc = ''1'' AND DT.FTXsdStaPdt <> ''4'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND DT.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			IF @tSqlLast = ''
			BEGIN
				SET @tSqlLast = ' Pdt.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			END
			ELSE
			BEGIN
				SET @tSqlLast = ' AND Pdt.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			END

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
			IF @tSqlLast = ''
			BEGIN
				SET @tSql1 +=' AND DT.FTBchCode IN (' + @ptBchL + ')'
				SET @tSqlLast = ' Bla.FTBchCode IN (' + @ptBchL + ')'
			END
			ELSE
			BEGIN
				SET @tSql1 +=' AND DT.FTBchCode IN (' + @ptBchL + ')'
				SET @tSqlLast += ' Bla Pdt.FTBchCode IN (' + @ptBchL + ')'
			END
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
	SET @tSqlPdt = ''
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
	SET @tSql +=' FTBchCode,FTBchName,ISNULL(FTXsdBarCode,'''') AS FTXsdBarCode,FTPdtName ,FTPgpChainName,FTPbnName,'
	SET @tSql +=' SUM(ISNULL(FCXsdQtyAll,0)) AS FCXsdQtyAll,' --จำนวนขาย
	SET @tSql +=' ISNULL(FCStkQty,0) AS FCStkQty,' --สต๊อกคงเหลือ
	SET @tSql +=' SUM(FCSdtNetSale) AS FCSdtNetSale,' --ยอดขาย
	SET @tSql +=' ISNULL(FCPgdPriceRet,0) AS FCPgdPriceRet,' --ราคา/หน่วย
	SET @tSql +=' SUM(ISNULL(FCSdtNetAmt,0)) AS FCSdtNetAmt' --ยอดขายรวม
	--PRINT  @tSql
	SET @tSql +=' FROM'
		SET @tSql +=' (SELECT Bla.FTBchCode,FTBchName,Bla.FTPdtCode,Sal.FTXsdBarCode,FTPdtName,ISNULL(FTPgpChainName,'''') AS FTPgpChainName,ISNULL(FTPbnName,'''') AS FTPbnName,Sal.FTXshDocNo,ISNULL(Sal.FDXshDocDate, ''1900-01-01'') AS FDXshDocDate,Sal.FCXsdQtyAll,Bla.FCStkQty,'
		SET @tSql +=' ISNULL(FCXsdDisPmt,0) AS FCXsdDisPmt,ISNULL(FCXsdDTDis,0) AS FCXsdDTDis,ISNULL(FCXsdHDDis,0) AS FCXsdHDDis,'
		SET @tSql +=' ISNULL(FCXsdNet,0) - ISNULL(FCXsdDTDis,0) AS FCSdtNetSale,'
		SET @tSql +=' ISNULL(FCPgdPriceRet,0) AS FCPgdPriceRet,'
		SET @tSql +=' ISNULL(FCXsdNet,0) - (ISNULL(FCXsdDTDis,0)+ISNULL(FCXsdDisPmt,0)+ISNULL(FCXsdHDDis,0)) AS FCSdtNetAmt'
		SET @tSql +=' FROM'
			SET @tSql +=' (SELECT StkBal.FTBchCode,BchL.FTBchName ,StkBal.FTPdtCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,SUM(ISNULL(StkBal.FCStkQty,0)) AS FCStkQty,PForPdt.FCPgdPriceRet'
			 SET @tSql +=' FROM  TCNTPdtStkBal StkBal WITH (NOLOCK)'
			 SET @tSql +=' INNER JOIN' 
			 SET @tSql +=' TCNMPdt Pdt WITH (NOLOCK)  ON Pdt.FTPdtCode = StkBal.FTPdtCode'
			 SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK)  ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK)  ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdtGrp_L PgpL WITH(NOLOCK)  ON Pdt.FTPgpChain = PgpL.FTPgpChain AND PgpL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK)  ON StkBal.FTPdtCode = Ppz.FTPdtCode' --AND PdtBar.FTPunCode = Ppz.FTPunCode
			 SET @tSql +=' LEFT JOIN TCNMBranch_L BchL WITH(NOLOCK)  ON StkBal.FTBchCode = BchL.FTBchCode AND BchL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN'
			 --PRINT  @tSql
			 SET @tSql +=' ('
				SET @tSql +=' SELECT SUBSTRING(FTPghDocNo,3,5) AS FTBchCode,FTPdtCode,FTPunCode,MAX(FDPghDStop) AS FDPghDStop,AVG(FCPgdPriceRet) AS FCPgdPriceRet' 
				SET @tSql +=' FROM TCNTPdtPrice4PDT' 
				SET @tSql +=' GROUP BY SUBSTRING(FTPghDocNo,3,5) ,FTPdtCode,FTPunCode'
			 SET @tSql +=' ) PForPdt ON StkBal.FTBchCode = PForPdt.FTBchCode AND StkBal.FTPdtCode = PForPdt.FTPdtCode'
			 SET @tSql +=' WHERE Ppz.FCPdtUnitFact =1'
			 --PRINT  @tSql
			 --PRINT @tSqlPdt
			 SET @tSql += @tSqlPdt
			 --PRINT @tSql 
			 --Where 1 สินค้าเท่านั้น
			 SET @tSql +=' GROUP BY StkBal.FTBchCode,BchL.FTBchName,StkBal.FTPdtCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,PForPdt.FCPgdPriceRet'
			SET @tSql +=' ) Bla'
			SET @tSql +=' LEFT JOIN'
			SET @tSql +=' (SELECT  DT.FTBchCode, DT.FTXshDocNo,  FDXshDocDate, DT.FTPdtCode, FTXsdBarCode,' 
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdQtyAll ELSE (FCXsdQtyAll) * - 1 END AS FCXsdQtyAll,'
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdNet ELSE (FCXsdNet) * - 1 END AS FCXsdNet,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDisPmt,0) ELSE  ISNULL(FCXsdDisPmt,0)*-1 END  AS FCXsdDisPmt,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDTDis,0) ELSE ISNULL(FCXsdDTDis,0)*-1 END  AS FCXsdDTDis,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdHDDis,0) ELSE ISNULL(FCXsdHDDis,0)*-1 END AS FCXsdHDDis'
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
			SET @tSql += ' WHERE ' + @tSqlLast
		SET @tSql +=' ) Pdt'
	SET @tSql +=' GROUP BY FTBchCode,FTBchName,FTXsdBarCode,FTPdtName ,FTPgpChainName,FTPbnName,ISNULL(FCStkQty,0),ISNULL(FCPgdPriceRet,0)'
	

	--SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH (NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	PRINT @tSql
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
	SET @tSql +=' FTBchCode,FTBchName,ISNULL(FTXsdBarCode,'''') AS FTXsdBarCode,FTPdtName ,FTPgpChainName,FTPbnName,'
	SET @tSql +=' SUM(ISNULL(FCXsdQtyAll,0)) AS FCXsdQtyAll,' --จำนวนขาย
	SET @tSql +=' ISNULL(FCStkQty,0) AS FCStkQty,' --สต๊อกคงเหลือ
	SET @tSql +=' SUM(FCSdtNetSale) AS FCSdtNetSale,' --ยอดขาย
	SET @tSql +=' ISNULL(FCPgdPriceRet,0) AS FCPgdPriceRet,' --ราคา/หน่วย
	SET @tSql +=' SUM(ISNULL(FCSdtNetAmt,0)) AS FCSdtNetAmt' --ยอดขายรวม
	--PRINT  @tSql
	SET @tSql +=' FROM'
		SET @tSql +=' (SELECT Bla.FTBchCode,FTBchName,Bla.FTPdtCode,Bla.FTBarCode AS FTXsdBarCode,FTPdtName,ISNULL(FTPgpChainName,'''') AS FTPgpChainName,ISNULL(FTPbnName,'''') AS FTPbnName,Sal.FTXshDocNo,ISNULL(Sal.FDXshDocDate, ''1900-01-01'') AS FDXshDocDate,Sal.FCXsdQtyAll,Bla.FCStkQty,'
		SET @tSql +=' ISNULL(FCXsdDisPmt,0) AS FCXsdDisPmt,ISNULL(FCXsdDTDis,0) AS FCXsdDTDis,ISNULL(FCXsdHDDis,0) AS FCXsdHDDis,'
		SET @tSql +=' ISNULL(FCXsdNet,0) - ISNULL(FCXsdDTDis,0) AS FCSdtNetSale,'
		SET @tSql +=' ISNULL(FCPgdPriceRet,0) AS FCPgdPriceRet,'
		SET @tSql +=' ISNULL(FCXsdNet,0) - (ISNULL(FCXsdDTDis,0)+ISNULL(FCXsdDisPmt,0)+ISNULL(FCXsdHDDis,0)) AS FCSdtNetAmt'
		SET @tSql +=' FROM'
			SET @tSql +=' (SELECT StkBal.FTBchCode,BchL.FTBchName ,StkBal.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,SUM(ISNULL(StkBal.FCStkQty,0)) AS FCStkQty,PForPdt.FCPgdPriceRet'
			 SET @tSql +=' FROM  TCNTPdtStkBal StkBal WITH (NOLOCK)'
			 SET @tSql +=' INNER JOIN' 
			 SET @tSql +=' TCNMPdt Pdt WITH (NOLOCK)  ON Pdt.FTPdtCode = StkBal.FTPdtCode'
			 SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK)  ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK)  ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdtGrp_L PgpL WITH(NOLOCK)  ON Pdt.FTPgpChain = PgpL.FTPgpChain AND PgpL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK)  ON StkBal.FTPdtCode = Ppz.FTPdtCode AND FCPdtUnitFact = 1' --AND PdtBar.FTPunCode = Ppz.FTPunCode
			 --เพิ่ม BarCode
			 SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH (NOLOCK) ON Ppz.FTPdtCode = PdtBar.FTPdtCode AND Ppz.FTPunCode = PdtBar.FTPunCode'
			 SET @tSql +=' LEFT JOIN TCNMBranch_L BchL WITH(NOLOCK)  ON StkBal.FTBchCode = BchL.FTBchCode AND BchL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
			 SET @tSql +=' LEFT JOIN'
			 --PRINT  @tSql
			 SET @tSql +=' ('
				SET @tSql +=' SELECT SUBSTRING(FTPghDocNo,3,5) AS FTBchCode,FTPdtCode,FTPunCode,MAX(FDPghDStop) AS FDPghDStop,AVG(FCPgdPriceRet) AS FCPgdPriceRet' 
				SET @tSql +=' FROM TCNTPdtPrice4PDT' 
				SET @tSql +=' GROUP BY SUBSTRING(FTPghDocNo,3,5) ,FTPdtCode,FTPunCode'
			 SET @tSql +=' ) PForPdt ON StkBal.FTBchCode = PForPdt.FTBchCode AND StkBal.FTPdtCode = PForPdt.FTPdtCode'
			 SET @tSql +=' WHERE Ppz.FCPdtUnitFact =1'
			 
			 --PRINT @tSqlPdt
--			 PRINT  @tSql
			 SET @tSql += @tSqlPdt
			 --PRINT @tSql 
			 --Where 1 สินค้าเท่านั้น
			 SET @tSql +=' GROUP BY StkBal.FTBchCode,BchL.FTBchName,StkBal.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,PForPdt.FCPgdPriceRet'
			SET @tSql +=' ) Bla'
			--SET @tSql += @tSqlLast
			SET @tSql +=' LEFT JOIN'
			SET @tSql +=' (SELECT  DT.FTBchCode, DT.FTXshDocNo,  FDXshDocDate, DT.FTPdtCode, FTXsdBarCode,' 
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdQtyAll ELSE (FCXsdQtyAll) * - 1 END AS FCXsdQtyAll,'
			 SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN FCXsdNet ELSE (FCXsdNet) * - 1 END AS FCXsdNet,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDisPmt,0) ELSE  ISNULL(FCXsdDisPmt,0)*-1 END  AS FCXsdDisPmt,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdDTDis,0) ELSE ISNULL(FCXsdDTDis,0)*-1 END  AS FCXsdDTDis,'
			 SET @tSql +=' CASE WHEN FNXshDocType = 1 THEN ISNULL(FCXsdHDDis,0) ELSE ISNULL(FCXsdHDDis,0)*-1 END AS FCXsdHDDis'
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


/****** Object:  StoredProcedure [dbo].[SP_RPTxPSSVatByMonth_Animate]    Script Date: 11/09/2022 10:26:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPSSVatByMonth_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPSSVatByMonth_Animate
GO
CREATE PROCEDURE SP_RPTxPSSVatByMonth_Animate 
--ALTER PROCEDURE [dbo].[SP_RPTxPSSVatByDate1001007] 
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



	@ptMonth Varchar(2),
	@ptYear Varchar(4),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 12/09/2022
-- Last Version 03.00.00 
-- Temp name  TRPTPSTaxMonthTmp_Animate
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
-- @ptBchL สาขา เชือก
	--DECLARE @tPosCodeF Varchar(30)
	--DECLARE @tPosCodeT Varchar(30)
-- @@ptMonth เดือน
-- @@ptYear ปี
-- @FNResult

--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptCode Varchar(100)
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tSql VARCHAR(8000)
	DECLARE @tSqlDrop VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSqlSale VARCHAR(8000)
	DECLARE @tTblName Varchar(255)
	DECLARE @tSqlS Varchar(255)
	DECLARE @tSqlR Varchar(255)
	DECLARE @tSql2 VARCHAR(255)

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


	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--SET @tBchF = @ptBchF
	--SET @tBchT = @ptBchT

	--SET @tPosCodeF  = @ptPosCodeF 
	--SET @tPosCodeT = @ptPosCodeT 

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

	--SET @tDocDateF = @ptDocDateF
	--SET @tDocDateT = @ptDocDateT

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


	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	SET @tSql2 =   ' WHERE FTXshStaDoc = ''1''AND ISNULL(FTXshDocVatFull,'''') = ''''' --เพิ่ม Where เฉพาะเอกสารที่ไม่มีการ GenVat
	SET @tSqlS =   ' WHERE FTXshStaDoc = ''1'' AND ISNULL(FTXshDocVatFull,'''') <> '''''
	SET @tSqlR =   ' WHERE FTXshStaDoc = ''1'' AND FNXshDocType = ''9'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSqlR +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSql2 +=' AND HDL.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSqlR +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSql2 +=' AND HDL.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSqlR +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSql2 +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSqlR += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSql2 += ' AND HDL.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSqlR +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql2 +=' AND HDL.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlR +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql2 +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlR +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql2 +=' AND HDL.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSqlR += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSql2 += ' AND HDL.FTPosCode IN (' + @ptPosL + ')'
		END		
	END

	IF (@ptMonth <> '' )
	BEGIN
		SET @tSql2 +=' AND FORMAT( HDL.FDXshDocDate, ''MM'', ''en-US'' ) = ''' + @ptMonth +''''
		SET @tSqlS +=' AND FORMAT( HD.FDXshDocDate, ''MM'', ''en-US'' ) = ''' + @ptMonth +''''
		--SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	IF (@ptYear <> '' )
	BEGIN
		SET @tSql2 +=' AND FORMAT( HDL.FDXshDocDate, ''yyyy'', ''en-US'' ) = ''' + @ptYear +''''
		SET @tSqlS +=' AND FORMAT( HD.FDXshDocDate, ''yyyy'', ''en-US'' ) = ''' + @ptYear +''''
		--SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTPSTaxMonthTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp

	--SET @tTblName = 'TRPTPSTaxTmp'+ @nComName + ''

	----if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].''+@tTblName''')) 
	--SET @tSqlDrop = ' if exists (select * from dbo.sysobjects where name = '''+@tTblName+ ''')'--id = object_id(N'[dbo].''+@tTblName'''))' 
	--SET @tSqlDrop += ' DROP TABLE '+ @tTblName + ''
	----PRINT @tSqlDrop
	--EXECUTE(@tSqlDrop)

	--PRINT @tTblName 

	SET @tSqlSale  =' INSERT INTO TRPTPSTaxMonthTmp_Animate '
	SET @tSqlSale +=' ('
	SET @tSqlSale +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSqlSale +=' FNSeqNo,FNAppType,FTBchCode,FTXshDocDate,FTXshDocLegth,FTCstName,FTXshAddrTax,'
	SET @tSqlSale +=' FCXshAmtNV,FCXshVatable,FCXshVat,FCXshGrandAmt,'
	SET @tSqlSale +=' FTXshMonthTH,FTXshMonthEN'
	-----------
	SET @tSqlSale +=' )'
 	SET @tSqlSale +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSqlSale +=' ROW_NUMBER() OVER(ORDER BY FTXshDocDate, FTPosCode) AS rnDesc,' 
	SET @tSqlSale +=' FNAppType,FTBchCode, FTXshDocDate,FTXshDocLegth,FTXshCstName, FTXshAddrTax, FCXshAmtNV,FCXshGrandAmt-FCXshVat-FCXshAmtNV AS FCXshVatable, FCXshVat,FCXshGrandAmt, FTXshMonthTH, FTXshMonthEN'
	SET @tSqlSale +=' FROM('
			--SET @tSqlSale +=' SELECT OW_NUMBER() OVER (ORDER BY FTXshDocDate ,FTPosCode ) as rnDesc,'
			SET @tSqlSale +=' SELECT ''1'' AS FNAppType,FTBchCode,FTPosCode, FTXshDocDate,FTXshDocLegth,FTXshCstName, FTXshAddrTax,' 
			SET @tSqlSale +=' CAST(FCXshAmtNV AS DECIMAL(18,2)) AS FCXshAmtNV, CAST(FCXshVatable AS DECIMAL(18,2)) AS FCXshVatable, CAST(FCXshVat AS DECIMAL(18,2)) AS FCXshVat,CAST(FCXshGrandAmt AS DECIMAL(18,2)) AS FCXshGrandAmt,'
			--FCXshAmtNV, FCXshVatable, FCXshVat,FCXshGrandAmt, 
			SET @tSqlSale +=' FTXshMonthTH, FTXshMonthEN,FDXshDocDateSort'
			SET @tSqlSale +=' FROM'
				SET @tSqlSale +=' ('		
				SET @tSqlSale +=' SELECT HDL.FTBchCode,FTPosCode, FORMAT(FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'') AS FTXshDocDate, MIN(HDL.FTXshDocNo) + ''-'' + MAX(HDL.FTXshDocNo) AS FTXshDocLegth,'
						SET @tSqlSale +=' ISNULL(HDL.FTXshDocVatFull, '''') AS FTXshDocVatFull,'
						SET @tSqlSale +=' CASE WHEN ISNULL(HDL.FTXshDocVatFull, '''') = '''' THEN ''1'' ELSE ''2'' END AS FTXshGenTax, '''' AS FTXshCstName, '''' AS FTXshAddrTax,'
						SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV, 0) ELSE ISNULL(FCXshAmtNV, 0) * -1 END) AS FCXshAmtNV,'
						SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0)) * -1 END) AS FCXshVatable,'
						SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshVat, 0) ELSE ISNULL(FCXshVat, 0) * -1 END) AS FCXshVat,' 
						SET @tSqlSale +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0)) * -1 END) AS FCXshGrandAmt,'
						SET @tSqlSale +=' FORMAT(FDXshDocDate, ''MMMM yyyy'', ''Th'') AS FTXshMonthTH,  FORMAT(FDXshDocDate, ''MMMM yyyy'', ''en-US'') AS FTXshMonthEN,'
						SET @tSqlSale +=' Max(HDL.FDXshDocDate) AS FDXshDocDateSort'
				SET @tSqlSale +=' FROM TPSTSalHD HDL WITH(NOLOCK)'
					SET @tSqlSale +=' LEFT JOIN TPSTSalHDCst HDCst WITH(NOLOCK) ON HDL.FTBchCode = HDCst.FTBchCode AND HDL.FTXshDocNo = HDCst.FTXshDocNo'
					SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH(NOLOCK) ON HDL.FTBchCode = Shp.FTBchCode AND HDL.FTShpCode = Shp.FTShpCode'
					SET @tSqlSale += @tSql2
				SET @tSqlSale +=' GROUP BY HDL.FTBchCode,  FORMAT(FDXshDocDate, ''dd/MMM/yyyy'', ''en-US''),FTPosCode,  ISNULL(HDL.FTXshDocVatFull, ''''),   FORMAT(FDXshDocDate, ''MMMM yyyy'', ''Th''),  FORMAT(FDXshDocDate, ''MMMM yyyy'', ''en-US'')'
				SET @tSqlSale +=' UNION'
				SET @tSqlSale +=' SELECT HD.FTBchCode,HD.FTPosCode, '
						SET @tSqlSale +=' FORMAT(FDXshDocDate, ''dd/MMM/yyyy'', ''en-US'') AS FTXshDocDate,FTXshDocVatFull + ''('' + HD.FTXshDocNo + '')'' AS FTXshDocLegth, FTXshDocVatFull,'
						SET @tSqlSale +=' CASE WHEN ISNULL(FTXshDocVatFull, '''') = '''' THEN ''1'' ELSE ''2'' END AS FTXshGenTax, '
						SET @tSqlSale +=' FTXshCstName, FTXshAddrTax,'
						SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV, 0) ELSE ISNULL(FCXshAmtNV, 0) * -1 END AS FCXshAmtNV,'
						SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) - ISNULL(FCXshAmtNV, 0) - ISNULL(FCXshVat, 0)) * -1 END AS FCXshVatable,'
						SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshVat, 0) ELSE ISNULL(FCXshVat, 0) END AS FCXshVat,'
						SET @tSqlSale +=' CASE WHEN FNXshDocType = ''1'' THEN ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0) ELSE(ISNULL(FCXshGrand, 0) - ISNULL(FCXshRnd, 0)) * -1 END AS FCXshGrandAmt,'
						SET @tSqlSale +=' FORMAT(FDXshDocDate, ''MMMM yyyy'', ''Th'') AS FTXshMonthTH,  FORMAT(FDXshDocDate, ''MMMM yyyy'', ''en-US'') AS FTXshMonthEN,'
						SET @tSqlSale +=' HD.FDXshDocDate AS FDXshDocDateSort'
				SET @tSqlSale +=' FROM TPSTSalHD HD WITH(NOLOCK)'
					SET @tSqlSale +=' LEFT JOIN TPSTTaxHDCst HDCst WITH(NOLOCK) ON HD.FTXshDocVatFull = HDCst.FTXshDocNo'
					SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH(NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode'
					SET @tSqlSale += @tSqlS
					--SET @tSqlSale +=' ORDER BY FORMAT(FDXshDocDate, ''dd/MMM/yyyy'', ''en-US''),FTPosCode,ISNULL(FTXshDocVatFull, '''')'
			SET @tSqlSale +=' ) Sale'
			--SET @tSqlSale +=' ORDER BY FDXshDocDateSort'
		SET @tSqlSale +=' ) Sale2'
	PRINT @tSqlSale
	EXECUTE(@tSqlSale)
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
	SET @tSql +=' FTBchCode,FTBchName,ISNULL(FTXsdBarCode,'''') AS FTXsdBarCode,FTPdtName ,FTPgpChainName,FTPbnName,'
	SET @tSql +=' SUM(ISNULL(FCXsdQtyAll,0)) AS FCXsdQtyAll,' --จำนวนขาย
	SET @tSql +=' ISNULL(FCStkQty,0) AS FCStkQty,' --สต๊อกคงเหลือ
	SET @tSql +=' SUM(FCSdtNetSale) AS FCSdtNetSale,' --ยอดขาย
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
			SET @tSql +=' (SELECT StkBal.FTBchCode,BchL.FTBchName ,StkBal.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,SUM(ISNULL(StkBal.FCStkQty,0)) AS FCStkQty,'
			SET @tSql +=' PForPdt.FCPgdPriceRet'
			 SET @tSql +=' FROM  TCNTPdtStkBal StkBal WITH (NOLOCK)'
			 SET @tSql +=' INNER JOIN' 
			 SET @tSql +=' TCNMPdt Pdt WITH (NOLOCK)  ON Pdt.FTPdtCode = StkBal.FTPdtCode'
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
				SET @tSql +=' SELECT SUBSTRING(FTPghDocNo,3,5) AS FTBchCode,FTPdtCode,FTPunCode,MAX(FDPghDStop) AS FDPghDStop,AVG(FCPgdPriceRet) AS FCPgdPriceRet' 
				SET @tSql +=' FROM TCNTPdtPrice4PDT' 
				SET @tSql +=' GROUP BY SUBSTRING(FTPghDocNo,3,5) ,FTPdtCode,FTPunCode'
			 SET @tSql +=' ) PForPdt ON StkBal.FTBchCode = PForPdt.FTBchCode AND StkBal.FTPdtCode = PForPdt.FTPdtCode'
			 SET @tSql +=' WHERE Ppz.FCPdtUnitFact =1'
			 
			 --PRINT @tSqlPdt
--			 PRINT  @tSql
			 SET @tSql += @tSqlPdt
			 --PRINT @tSql 
			 --Where 1 สินค้าเท่านั้น
			 SET @tSql +=' GROUP BY StkBal.FTBchCode,BchL.FTBchName,StkBal.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,PForPdt.FCPgdPriceRet'
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
	PRINT @tSql
	EXECUTE(@tSql)

	--INSERT VD


	--RETURN SELECT * FROM TRPTSalDTTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO


















/****** Object:  StoredProcedure [dbo].[SP_RPTxPSSVat1001006]    Script Date: 05/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPSSVat1001006]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPSSVat1001006
GO
CREATE PROCEDURE [dbo].[SP_RPTxPSSVat1001006]
	--ALTER PROCEDURE [dbo].[SP_RPTxPSSVat1001006] 
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
		----เครื่องจุดขาย
		--@ptPosCodeF Varchar(20),
		--@ptPosCodeT Varchar(20),

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
		--DECLARE @tPosCodeF Varchar(30)
		--DECLARE @tPosCodeT Varchar(30)
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

		--DECLARE @tBchF Varchar(5)
		--DECLARE @tBchT Varchar(5)

		--DECLARE @tPosCodeF Varchar(20)
		--DECLARE @tPosCodeT Varchar(20)

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

		DECLARE @tDocDateF Varchar(10)
		DECLARE @tDocDateT Varchar(10)
		
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

		IF @tDocDateF = null
		BEGIN 
			SET @tDocDateF = ''
		END

		IF @tDocDateT = null OR @tDocDateT =''
		BEGIN 
			SET @tDocDateT = @tDocDateF
		END

		SET @tSql1 = ' '
		SET @tSql3 = ' '
		IF @pnFilterType = '1'
		BEGIN
			IF (@tBchF <> '' AND @tBchT <> '')
			BEGIN
				SET @tSql1 +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
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
				SET @tSql1 +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
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

		IF (@tDocDateF <> '' AND @tDocDateT <> '')
		BEGIN
			SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		END

		DELETE FROM TRPTPSTaxHDTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
	
		SET @tSql  = ' INSERT INTO TRPTPSTaxHDTmp '
		SET @tSql +=' ('
		SET @tSql +=' FTComName,FTRptCode,FTUsrSession,'
		SET @tSql +=' FTBchCode,FTBchName,FDXshdocDate,FTXshDocNo,FTPosCode,FTXshDocRef,FTCstCode,FTCstName,FTCstTaxNo,FCXshAmt,FCXshVat,FCXshAmtNV,FCXshGrandTotal,'
		--*NUI 2019-11-14
		SET @tSql +=' FNAppType,FTPosRegNo,FTCstBchCode,FTCstBusiness,FTEstablishment,FTXshTaxID'
		-------------
		SET @tSql +=' )'
		SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
		SET @tSql +=' SalVat.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,FTXshDocNo,FTPosCode,FTXshRefInt,FTCstCode,FTCstName,FTCstTaxNo,FCXshValue,FCXshVat,FCXshAmtNV,FCXshGrand,'
		--*NUI 2019-11-14
		SET @tSql +=' FNAppType,FTPosRegNo,FTCstBchCode,FTCstBusiness,FTEstablishment,FTCstTaxNo AS FTXshTaxID'
		SET @tSql +=' FROM'	
				SET @tSql +=' (SELECT HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,HD.FTPosCode,FTXshDocNo,ISNULL(FTXshRefInt,'''') FTXshRefInt,HD.FTCstCode,Cst_L.FTCstName,Cst.FTCstTaxNo,'
				--NUI10-04-2020
				SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshVatable,0) ELSE (ISNULL(FCXshVatable,0))*-1 END AS FCXshValue,'
				SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END AS FCXshVat,'
				SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0)*-1 END AS FCXshAmtNV,'
				--NUI10-04-2020
				SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END AS FCXshGrand,'
				--*NUI 2019-11-14
				SET @tSql +=' 1 AS FNAppType,POS.FTPosRegNo,Cst.FTCstBchCode,Cst.FTCstBusiness,'
				SET @tSql +=' CASE WHEN ISNULL(Cst.FTCstBusiness,'''') <> ''1'' THEN '''' ELSE CASE WHEN FTCstBchHQ = ''2'' THEN ''2''  ELSE ''1'' END  END AS FTEstablishment'
				SET @tSql +=' FROM TPSTSalHD HD LEFT JOIN'
						SET @tSql +=' TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode LEFT JOIN'
						SET @tSql +=' TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode LEFT JOIN'
						SET @tSql +=' TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
						SET @tSql +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
						SET @tSql +=' WHERE 1=1 AND FTXshStaDoc = ''1'''			  			
				SET @tSql += @tSql1			
				SET @tSql +=' ) SalVat LEFT JOIN '    
		SET @tSql +=' TCNMBranch_L Bch_L ON SalVat.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
			
		SET @tsql3 += ' UNION'

		SET @tSql3 +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
		SET @tSql3 +=' SalVat.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,FTXshDocNo,FTPosCode,FTXshRefInt,FTCstCode,FTCstName,FTCstTaxNo,FCXshValue,FCXshVat,FCXshAmtNV,FCXshGrand,'
		--*NUI 2019-11-14
		SET @tSql3 +=' FNAppType,FTPosRegNo,FTCstBchCode,FTCstBusiness,FTEstablishment,FTCstTaxNo AS FTXshTaxID'
		SET @tSql3 +=' FROM'	
				SET @tSql3 +=' (SELECT HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,HD.FTPosCode,HD.FTXshDocNo,ISNULL(FTXshRefInt,'''') FTXshRefInt,HD.FTCstCode,Cst_L.FTCstName,Cst.FTCstTaxNo,'
				--NUI10-04-2020
				--SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshVatable,0) ELSE ISNULL(FCXshVatable,0)*-1 END AS FCXshValue,'
				SET @tSql3 +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshVatable,0) ELSE (ISNULL(FCXshVatable,0))*-1 END AS FCXshValue,'
				SET @tSql3 +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END AS FCXshVat,'
				SET @tSql3 +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0)*-1 END AS FCXshAmtNV,'
				--NUI10-04-2020
				--SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshGrand,0) ELSE ISNULL(FCXshGrand,0)*-1 END AS FCXshGrand,'
				--SET @tSql +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END AS FCXshGrand,'
				SET @tSql3 +=' CASE WHEN HD.FNXshDocType = 1 THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0))*-1 END AS FCXshGrand,'
				--*NUI 2019-11-14
				SET @tSql3 +=' 2 AS FNAppType,POS.FTPosRegNo,Cst.FTCstBchCode,Cst.FTCstBusiness,'
				SET @tSql3 +=' CASE WHEN ISNULL(Cst.FTCstBusiness,'''') <> ''1'' THEN '''' ELSE CASE WHEN FTCstBchHQ = ''2'' THEN ''2''  ELSE ''1'' END  END AS FTEstablishment'
				SET @tSql3 +=' FROM TVDTSalHD HD' 
				--NUI 2020-01-06
				SET @tSql3 +=' INNER JOIN TVDTSalRC RC WITH(NOLOCK) ON HD.FTBchCode = RC.FTBchCode AND HD.FTXshDocNo = RC.FTXshDocNo'
				SET @tSql3 +=' LEFT JOIN TFNMRcv Rcv WITH(NOLOCK) ON  RC.FTRcvCode = Rcv.FTRcvCode'			
				------------
						SET @tSql3 +=' LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode LEFT JOIN'
						SET @tSql3 +=' TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode LEFT JOIN'
						SET @tSql3 +=' TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
						SET @tSql3 +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
						SET @tSql3 +=' WHERE 1=1 AND FTXshStaDoc = ''1'' AND Rcv.FTFmtCode <> ''004'''
				SET @tSql3 +=  @tSql1
				SET @tSql3 +=' ) SalVat LEFT JOIN '    
		SET @tSql3 +=' TCNMBranch_L Bch_L ON SalVat.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''					 

		--PRINT @tSql
		EXECUTE(@tSql + @tSql3)

		RETURN SELECT * FROM TRPTPSTaxHDTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
		
	END TRY

	BEGIN CATCH 
		SET @FNResult= -1
	END CATCH	

	--SELECT * FROM TRPTPSTaxHDTmp
GO






/****** Object:  StoredProcedure [dbo].[SP_RPTxPSSVatByDate1001007]    Script Date: 05/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPSSVatByDate1001007]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPSSVatByDate1001007
GO
CREATE PROCEDURE [dbo].[SP_RPTxPSSVatByDate1001007] 
--ALTER PROCEDURE [dbo].[SP_RPTxPSSVatByDate1001007] 
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
	----เครื่องจุดขาย
	--@ptPosCodeF Varchar(20),
	--@ptPosCodeT Varchar(20),

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
	--DECLARE @tPosCodeF Varchar(30)
	--DECLARE @tPosCodeT Varchar(30)
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
	DECLARE @tSqlDrop VARCHAR(8000)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSqlSale VARCHAR(8000)
	DECLARE @tTblName Varchar(255)
	DECLARE @tSqlS Varchar(255)
	DECLARE @tSqlR Varchar(255)
	DECLARE @tSql2 VARCHAR(255)

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

	--DECLARE @tPosCodeF Varchar(20)
	--DECLARE @tPosCodeT Varchar(20)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า
	--DECLARE @tCstF Varchar(20)
	--DECLARE @tCstT Varchar(20)


	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'PSSVat1001006'
	--SET @ptUsrSession = '001'
	--SET @tBchF = '001'
	--SET @tBchT = '001'

	--SET @tDocDateF = '2019-07-01'
	--SET @tDocDateT = '2019-07-10'


	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'DailySaleByInv1001001'
	--SET @ptUsrSession = '001'
	--SET @tBchF = ''
	--SET @tBchT = ''

	--SET @tDocDateF = ''
	--SET @tDocDateT = ''

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--SET @tBchF = @ptBchF
	--SET @tBchT = @ptBchT

	--SET @tPosCodeF  = @ptPosCodeF 
	--SET @tPosCodeT = @ptPosCodeT 

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

	--IF @tBchF = null
	--BEGIN
	--	SET @tBchF = ''
	--END
	--IF @tBchT = null OR @tBchT = ''
	--BEGIN
	--	SET @tBchT = @tBchF
	--END

	--IF @tPosCodeF = null
	--BEGIN
	--	SET @tPosCodeF = ''
	--END

	--IF @tPosCodeT = null OR @tPosCodeT = ''
	--BEGIN
	--	SET @tPosCodeT = @tPosCodeF
	--END



	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	SET @tSql2 =   ' WHERE 1=1 AND FTXshStaDoc = ''1'''
	SET @tSqlS =   ' WHERE 1=1 AND FTXshStaDoc = ''1'' AND FNXshDocType = ''1'''
	SET @tSqlR =   ' WHERE 1=1 AND FTXshStaDoc = ''1'' AND FNXshDocType = ''9'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSqlR +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSql2 +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSqlR +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSql2 +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSqlR +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSql2 +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSqlR += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSql2 += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSqlR +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql2 +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlR +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql2 +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlR +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql2 +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSqlR += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSql2 += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
		END		
	END

	--IF (@tBchF <> '' AND @tBchT <> '')
	--BEGIN

	--	SET @tSqlS +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--	SET @tSqlR +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--	SET @tSql2 +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--END

	--IF (@tPosCodeF <> '' AND @tPosCodeT <> '')
	--	BEGIN
	--		SET @tSql2 += ' AND HD.FTPosCode BETWEEN '''+@tPosCodeF+''' AND '''+@tPosCodeT+''''
	--		SET @tSqlS += ' AND HD.FTPosCode BETWEEN '''+@tPosCodeF+''' AND '''+@tPosCodeT+''''
	--		SET @tSqlR += ' AND HD.FTPosCode BETWEEN '''+@tPosCodeF+''' AND '''+@tPosCodeT+''''
	--	END		

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSql2 +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSqlS +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTPSTaxHDDateTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp

	--SET @tTblName = 'TRPTPSTaxTmp'+ @nComName + ''

	----if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].''+@tTblName''')) 
	--SET @tSqlDrop = ' if exists (select * from dbo.sysobjects where name = '''+@tTblName+ ''')'--id = object_id(N'[dbo].''+@tTblName'''))' 
	--SET @tSqlDrop += ' DROP TABLE '+ @tTblName + ''
	----PRINT @tSqlDrop
	--EXECUTE(@tSqlDrop)

	--PRINT @tTblName 

	SET @tSqlSale  = ' INSERT INTO TRPTPSTaxHDDateTmp '
	SET @tSqlSale +=' ('
	SET @tSqlSale +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSqlSale +=' FTBchCode,FTBchName,FDXshdocDate,FTPosCode,FTXshDocNoSale,FTXshDocNoRefun,FCXshAmt,FCXshVat,FCXshAmtNV,FCXshGrandTotal,'
	--*NUI 2019-11-14
	SET @tSqlSale +=' FNAppType,FTPosRegNo'
	-----------
	SET @tSqlSale +=' )'
 	SET @tSqlSale +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSqlSale +=' vAT.FTBchCode,Vat.FTBchName,Vat.FDXshdocDate,Vat.FTPosCode,ISNULL(FTXshDocNoSale,'''') AS FTXshDocNoSale,ISNULL(FTXshDocNoRefun,'''') AS FTXshDocNoRefun,FCXshValue,FCXshVat,FCXshAmtNV,FCXshGrand, FNAppType,FTPosRegNo'
	--SET @tSqlSale +=' INTO  '+ @tTblName + ''
	SET @tSqlSale +=' FROM('
 	 SET @tSqlSale +=' SELECT HD.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,HD.FTPosCode,'
	 --SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0))*-1 END) AS FCXshValue, '
	 --SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshVatable,0)-ISNULL(FCXshAmtNV,0) ELSE (ISNULL(FCXshVatable,0)-ISNULL(FCXshAmtNV,0))*-1 END) AS FCXshValue, '
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshVatable,0) ELSE (ISNULL(FCXshVatable,0))*-1 END) AS FCXshValue, '
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END) AS FCXshVat,'
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0)*-1 END) AS FCXshAmtNV,' 
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END) AS FCXshGrand,' 
 	 SET @tSqlSale +=' 1 AS FNAppType,POS.FTPosRegNo'--,Cst.FTCstBchCode,Cst.FTCstBusiness 
	 SET @tSqlSale +=' FROM TPSTSalHD HD LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode' 
	  SET @tSqlSale +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode  LEFT JOIN' 
	 SET @tSqlSale +=' TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''	 
	 SET @tSqlSale +=' LEFT JOIN TCNMBranch_L Bch_L ON HD.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	 SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
	 SET @tSqlSale += @tSql2	
	 SET @tSqlSale +=' GROUP BY HD.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXshDocDate,121),HD.FTPosCode,POS.FTPosRegNo'
	SET @tSqlSale +=' ) Vat LEFT JOIN'
		SET @tSqlSale +=' (SELECT HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,HD.FTPosCode,'
		SET @tSqlSale +=' MIN(FTXshDocNo) + ''-'' + MAX(FTXshDocNo) AS FTXshDocNoSale'
		SET @tSqlSale +=' FROM TPSTSalHD HD LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode' 
		 SET @tSqlSale +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode  LEFT JOIN' 
		SET @tSqlSale +=' TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSqlS
		SET @tSqlSale +=' GROUP BY HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121),HD.FTPosCode) Sale ON Vat.FTBchCode = Sale.FTBchCode AND Vat.FDXshdocDate = Sale.FDXshdocDate AND Vat.FTPosCode = Sale.FTPosCode '
		SET @tSqlSale +=' LEFT JOIN'
		SET @tSqlSale +=' (SELECT HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,HD.FTPosCode,'
		SET @tSqlSale +=' MIN(FTXshDocNo) + ''-'' + MAX(FTXshDocNo) AS FTXshDocNoRefun'
		SET @tSqlSale +=' FROM TPSTSalHD HD LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode' 
		 SET @tSqlSale +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode  LEFT JOIN' 
		SET @tSqlSale +=' TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSqlR
		SET @tSqlSale +=' GROUP BY HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121),HD.FTPosCode) Ret ON Vat.FTBchCode = Ret.FTBchCode AND Vat.FDXshdocDate = Ret.FDXshdocDate AND Vat.FTPosCode = Ret.FTPosCode'	
	--PRINT @tSqlSale
	EXECUTE(@tSqlSale)

	--Vending
	SET @tSqlSale  = ' INSERT INTO TRPTPSTaxHDDateTmp '
	SET @tSqlSale +=' ('
	SET @tSqlSale +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSqlSale +=' FTBchCode,FTBchName,FDXshdocDate,FTPosCode,FTXshDocNoSale,FTXshDocNoRefun,FCXshAmt,FCXshVat,FCXshAmtNV,FCXshGrandTotal,'
	--*NUI 2019-11-14
	SET @tSqlSale +=' FNAppType,FTPosRegNo'
	-----------
	SET @tSqlSale +=' )'
 	SET @tSqlSale +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSqlSale +=' vAT.FTBchCode,Vat.FTBchName,Vat.FDXshdocDate,Vat.FTPosCode,ISNULL(FTXshDocNoSale,'''') AS FTXshDocNoSale,ISNULL(FTXshDocNoRefun,'''') AS FTXshDocNoRefun,FCXshValue,FCXshVat,FCXshAmtNV,FCXshGrand, FNAppType,FTPosRegNo'
	--SET @tSqlSale +=' INTO  '+ @tTblName + ''
	SET @tSqlSale +=' FROM('
 	 SET @tSqlSale +=' SELECT HD.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,HD.FTPosCode,'
	 --SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0))*-1 END) AS FCXshValue, '
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshVatable,0) ELSE (ISNULL(FCXshVatable,0))*-1 END) AS FCXshValue, '
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END) AS FCXshVat,'
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0)*-1 END) AS FCXshAmtNV,' 
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END) AS FCXshGrand,' 
 	 SET @tSqlSale +=' 2 AS FNAppType,POS.FTPosRegNo'--,Cst.FTCstBchCode,Cst.FTCstBusiness 
	 SET @tSqlSale +=' FROM TVDTSalHD HD LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode' 
	  SET @tSqlSale +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode ' 
	--NUI 2020-01-07
	SET @tSqlSale +=' INNER JOIN TVDTSalRC RC WITH(NOLOCK) ON HD.FTBchCode = RC.FTBchCode AND HD.FTXshDocNo = RC.FTXshDocNo'
	SET @tSqlSale +=' LEFT JOIN TFNMRcv Rcv WITH(NOLOCK) ON  RC.FTRcvCode = Rcv.FTRcvCode'			
	------------
	 SET @tSqlSale +=' LEFT JOIN TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''	 
	 SET @tSqlSale +=' LEFT JOIN TCNMBranch_L Bch_L ON HD.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	 SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
	 SET @tSqlSale += @tSql2	
	 SET @tSqlSale += ' AND Rcv.FTFmtCode <> ''004'''
	 SET @tSqlSale +=' GROUP BY HD.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXshDocDate,121),HD.FTPosCode,POS.FTPosRegNo'
	SET @tSqlSale +=' ) Vat LEFT JOIN'
		SET @tSqlSale +=' (SELECT HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,HD.FTPosCode,'
		SET @tSqlSale +=' MIN(HD.FTXshDocNo) + ''-'' + MAX(HD.FTXshDocNo) AS FTXshDocNoSale'
		SET @tSqlSale +=' FROM TVDTSalHD HD LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode' 
		 SET @tSqlSale +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode ' 
		--NUI 2020-01-07
		SET @tSqlSale +=' INNER JOIN TVDTSalRC RC WITH(NOLOCK) ON HD.FTBchCode = RC.FTBchCode AND HD.FTXshDocNo = RC.FTXshDocNo'
		SET @tSqlSale +=' LEFT JOIN TFNMRcv Rcv WITH(NOLOCK) ON  RC.FTRcvCode = Rcv.FTRcvCode'			
		------------
	    SET @tSqlSale +=' LEFT JOIN TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSqlS
		SET @tSqlSale += ' AND Rcv.FTFmtCode <> ''004'''
		SET @tSqlSale +=' GROUP BY HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121),HD.FTPosCode) Sale ON Vat.FTBchCode = Sale.FTBchCode AND Vat.FDXshdocDate = Sale.FDXshdocDate AND Vat.FTPosCode = Sale.FTPosCode '
		SET @tSqlSale +=' LEFT JOIN'
		SET @tSqlSale +=' (SELECT HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,HD.FTPosCode,'
		SET @tSqlSale +=' MIN(HD.FTXshDocNo) + ''-'' + MAX(HD.FTXshDocNo) AS FTXshDocNoRefun'
		SET @tSqlSale +=' FROM TVDTSalHD HD LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode' 
		 SET @tSqlSale +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode ' 
		--NUI 2020-01-07
		SET @tSqlSale +=' INNER JOIN TVDTSalRC RC WITH(NOLOCK) ON HD.FTBchCode = RC.FTBchCode AND HD.FTXshDocNo = RC.FTXshDocNo'
		SET @tSqlSale +=' LEFT JOIN TFNMRcv Rcv WITH(NOLOCK) ON  RC.FTRcvCode = Rcv.FTRcvCode'			
		------------
		 SET @tSqlSale +=' LEFT JOIN TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSqlR
		SET @tSqlSale += ' AND Rcv.FTFmtCode <> ''004'''
		SET @tSqlSale +=' GROUP BY HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121),HD.FTPosCode) Ret ON Vat.FTBchCode = Ret.FTBchCode AND Vat.FDXshdocDate = Ret.FDXshdocDate AND Vat.FTPosCode = Ret.FTPosCode'	
	--PRINT @tSqlSale
	EXECUTE(@tSqlSale)

	RETURN SELECT * FROM TRPTPSTaxHDDateTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession 

	--SET @tSqlDrop += 'DROP TABLE '+ @tTblName + ''
	----PRINT @tSqlDrop
	--EXECUTE(@tSqlDrop)
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPSSVatByDateFull]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPSSVatByDateFull
GO
CREATE PROCEDURE [dbo].[SP_RPTxPSSVatByDateFull] 
--ALTER PROCEDURE [dbo].[SP_RPTxPSSVatByDate1001007] 
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
	----เครื่องจุดขาย
	--@ptPosCodeF Varchar(20),
	--@ptPosCodeT Varchar(20),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Last Update 04/06/2020 แก้ไขเรื่อง บันทึกรายงานไม่ต้องแยกเครื่องจุดขาย
-- Create 10/07/2019
-- Temp name  TRPTSalRCTmp
-- @pnLngID ภาษา
-- @ptRptCdoe ชื่อรายงาน
-- @ptUsrSession UsrSession
-- @ptBchF จากรหัสสาขา
-- @ptBchT ถึงรหัสสาขา
	--DECLARE @tPosCodeF Varchar(30)
	--DECLARE @tPosCodeT Varchar(30)
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
	DECLARE @tSqlDrop VARCHAR(8000)
	DECLARE @tSql1 VARCHAR(8000)
	DECLARE @tSqlSale VARCHAR(8000)
	DECLARE @tTblName Varchar(255)
	DECLARE @tSqlS Varchar(255)
	DECLARE @tSqlR Varchar(255)
	DECLARE @tSql2 VARCHAR(255)

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

	--DECLARE @tPosCodeF Varchar(20)
	--DECLARE @tPosCodeT Varchar(20)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า
	--DECLARE @tCstF Varchar(20)
	--DECLARE @tCstT Varchar(20)


	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'PSSVat1001006'
	--SET @ptUsrSession = '001'
	--SET @tBchF = '001'
	--SET @tBchT = '001'

	--SET @tDocDateF = '2019-07-01'
	--SET @tDocDateT = '2019-07-10'


	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'DailySaleByInv1001001'
	--SET @ptUsrSession = '001'
	--SET @tBchF = ''
	--SET @tBchT = ''

	--SET @tDocDateF = ''
	--SET @tDocDateT = ''

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tUsrSession = @ptUsrSession
	SET @tRptCode = @ptRptCode

	--SET @tBchF = @ptBchF
	--SET @tBchT = @ptBchT

	--SET @tPosCodeF  = @ptPosCodeF 
	--SET @tPosCodeT = @ptPosCodeT 

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

	--IF @tBchF = null
	--BEGIN
	--	SET @tBchF = ''
	--END
	--IF @tBchT = null OR @tBchT = ''
	--BEGIN
	--	SET @tBchT = @tBchF
	--END

	--IF @tPosCodeF = null
	--BEGIN
	--	SET @tPosCodeF = ''
	--END

	--IF @tPosCodeT = null OR @tPosCodeT = ''
	--BEGIN
	--	SET @tPosCodeT = @tPosCodeF
	--END



	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	SET @tSql2 =   ' WHERE 1=1 AND FTXshStaDoc = ''1'''
	SET @tSqlS =   ' WHERE 1=1 AND FTXshStaDoc = ''1'' AND FNXshDocType = ''4'''
	SET @tSqlR =   ' WHERE 1=1 AND FTXshStaDoc = ''1'' AND FNXshDocType = ''5'''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSqlR +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
			SET @tSql2 +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSqlR +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
			SET @tSql2 +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSqlR +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
			SET @tSql2 +=' AND HD.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tPosF <> '' AND @tPosT <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSqlR += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
			SET @tSql2 += ' AND HD.FTPosCode BETWEEN ''' + @tPosF + ''' AND ''' + @tPosT + ''''
		END		
	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN
			SET @tSqlS +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSqlR +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql2 +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSqlS +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlR +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql2 +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSqlS +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlR +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql2 +=' AND HD.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosL <> '')
		BEGIN
			SET @tSqlS += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSqlR += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
			SET @tSql2 += ' AND HD.FTPosCode IN (' + @ptPosL + ')'
		END		
	END

	--IF (@tBchF <> '' AND @tBchT <> '')
	--BEGIN

	--	SET @tSqlS +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--	SET @tSqlR +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--	SET @tSql2 +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--END

	--IF (@tPosCodeF <> '' AND @tPosCodeT <> '')
	--	BEGIN
	--		SET @tSql2 += ' AND HD.FTPosCode BETWEEN '''+@tPosCodeF+''' AND '''+@tPosCodeT+''''
	--		SET @tSqlS += ' AND HD.FTPosCode BETWEEN '''+@tPosCodeF+''' AND '''+@tPosCodeT+''''
	--		SET @tSqlR += ' AND HD.FTPosCode BETWEEN '''+@tPosCodeF+''' AND '''+@tPosCodeT+''''
	--	END		

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSql2 +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSqlS +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSqlR +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTPSTTaxDateFullTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp

	--SET @tTblName = 'TRPTPSTaxTmp'+ @nComName + ''

	----if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].''+@tTblName''')) 
	--SET @tSqlDrop = ' if exists (select * from dbo.sysobjects where name = '''+@tTblName+ ''')'--id = object_id(N'[dbo].''+@tTblName'''))' 
	--SET @tSqlDrop += ' DROP TABLE '+ @tTblName + ''
	----PRINT @tSqlDrop
	--EXECUTE(@tSqlDrop)

	--PRINT @tTblName 

	SET @tSqlSale  = ' INSERT INTO TRPTPSTTaxDateFullTmp '
	SET @tSqlSale +=' ('
	SET @tSqlSale +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSqlSale +=' FTBchCode,FTBchName,FDXshdocDate,FTPosCode,FTXshDocNoSale,FTXshDocNoRefun,FCXshAmt,FCXshVat,FCXshAmtNV,FCXshGrandTotal,'
	--*NUI 2019-11-14
	SET @tSqlSale +=' FNAppType,FTPosRegNo'
	-----------
	SET @tSqlSale +=' )'
 	SET @tSqlSale +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSqlSale +=' vAT.FTBchCode,Vat.FTBchName,Vat.FDXshdocDate,'''' AS FTPosCode,ISNULL(FTXshDocNoSale,'''') AS FTXshDocNoSale,ISNULL(FTXshDocNoRefun,'''') AS FTXshDocNoRefun,FCXshValue,FCXshVat,FCXshAmtNV,FCXshGrand, FNAppType,'''' AS FTPosRegNo'
	--SET @tSqlSale +=' INTO  '+ @tTblName + ''
	SET @tSqlSale +=' FROM('
 	 SET @tSqlSale +=' SELECT HD.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,'--HD.FTPosCode,'
	 --SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''1'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshAmtNV,0)-ISNULL(FCXshVat,0))*-1 END) AS FCXshValue, '
	 --SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''4'' THEN ISNULL(FCXshVatable,0)-ISNULL(FCXshAmtNV,0) ELSE (ISNULL(FCXshVatable,0)-ISNULL(FCXshAmtNV,0))*-1 END) AS FCXshValue, '
		SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''4'' THEN ISNULL(FCXshVatable,0) ELSE (ISNULL(FCXshVatable,0))*-1 END) AS FCXshValue, '
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''4'' THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END) AS FCXshVat,'
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''4'' THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0)*-1 END) AS FCXshAmtNV,' 
	 SET @tSqlSale +=' SUM(CASE WHEN HD.FNXshDocType = ''4'' THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END) AS FCXshGrand,' 
 	 SET @tSqlSale +=' 1 AS FNAppType'--POS.FTPosRegNo'--,Cst.FTCstBchCode,Cst.FTCstBusiness 
	 SET @tSqlSale +=' FROM TPSTTaxHD HD LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode' 
	 SET @tSqlSale +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode  LEFT JOIN' 
	 SET @tSqlSale +=' TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''	 
	 SET @tSqlSale +=' LEFT JOIN TCNMBranch_L Bch_L ON HD.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	 SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
	 SET @tSqlSale += @tSql2	
	 SET @tSqlSale +=' GROUP BY HD.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXshDocDate,121)'--,HD.FTPosCode,'--POS.FTPosRegNo'
	SET @tSqlSale +=' ) Vat LEFT JOIN'
		SET @tSqlSale +=' (SELECT HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,'--HD.FTPosCode,'
		SET @tSqlSale +=' MIN(FTXshDocNo) + ''-'' + MAX(FTXshDocNo) AS FTXshDocNoSale'
		SET @tSqlSale +=' FROM TPSTTaxHD HD LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode' 
		SET @tSqlSale +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode  LEFT JOIN' 
		SET @tSqlSale +=' TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSqlS
		SET @tSqlSale +=' GROUP BY HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121)) Sale ON Vat.FTBchCode = Sale.FTBchCode AND Vat.FDXshdocDate = Sale.FDXshdocDate'-- AND Vat.FTPosCode = Sale.FTPosCode '
		SET @tSqlSale +=' LEFT JOIN'
		SET @tSqlSale +=' (SELECT HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,'--HD.FTPosCode,'
		SET @tSqlSale +=' MIN(FTXshDocNo) + ''-'' + MAX(FTXshDocNo) AS FTXshDocNoRefun'
		SET @tSqlSale +=' FROM TPSTTaxHD HD LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode' 
		SET @tSqlSale +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode  LEFT JOIN' 
		SET @tSqlSale +=' TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
		SET @tSqlSale +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
		SET @tSqlSale += @tSqlR
		SET @tSqlSale +=' GROUP BY HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121)) Ret ON Vat.FTBchCode = Ret.FTBchCode AND Vat.FDXshdocDate = Ret.FDXshdocDate'-- AND Vat.FTPosCode = Ret.FTPosCode'	
	--PRINT @tSqlSale
	EXECUTE(@tSqlSale)


	RETURN SELECT * FROM TRPTPSTTaxDateFullTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession 

	--SET @tSqlDrop += 'DROP TABLE '+ @tTblName + ''
	----PRINT @tSqlDrop
	--EXECUTE(@tSqlDrop)
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxPSSVatFull]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxPSSVatFull
GO
CREATE PROCEDURE [dbo].[SP_RPTxPSSVatFull] 

--ALTER PROCEDURE [dbo].[SP_RPTxPSSVatFull] 
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
	--DECLARE @tPosCodeF Varchar(30)
	--DECLARE @tPosCodeT Varchar(30)
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

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)
	--ลูกค้า
	
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


	--IF @tBchF = null
	--BEGIN
	--	SET @tBchF = ''
	--END
	--IF @tBchT = null OR @tBchT = ''
	--BEGIN
	--	SET @tBchT = @tBchF
	--END

	--IF @tPosCodeF = null
	--BEGIN
	--	SET @tPosCodeF = ''
	--END

	--IF @tPosCodeT = null OR @tPosCodeT = ''
	--BEGIN
	--	SET @tPosCodeT = @tPosCodeF
	--END

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

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END

	--SET @tSqlSal =  ' WHERE 1=1 AND FTXshStaDoc = ''1'''
	--SET @tSqlVD =   ' WHERE 1=1 AND FTXshStaDoc = ''1'' AND Rcv.FTFmtCode <> ''004'''


	--IF (@tBchF <> '' AND @tBchT <> '')
	--BEGIN
	--	SET @tSql1 +=' AND FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
	--END

	--IF (@tPosCodeF <> '' AND @tPosCodeT <> '')
	--	BEGIN
	--		SET @tSql1 += ' AND HD.FTPosCode BETWEEN '''+@tPosCodeF+''' AND '''+@tPosCodeT+''''
	--	END		

	SET @tSql1 = ' '
	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND HD.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
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
			SET @tSql1 +=' AND HD.FTBchCode IN (' + @ptBchL + ')'
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

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSql1 +=' AND CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTPSTaxHDFullTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 
 	SET @tSql  = ' INSERT INTO TRPTPSTaxHDFullTmp '
	SET @tSql +=' ('
	SET @tSql +=' FTComName,FTRptCode,FTUsrSession,'
	SET @tSql +=' FTBchCode,FTBchName,FDXshdocDate,FTXshDocNo,FTPosCode,FTXshDocRef,FTCstCode,FTCstName,FTCstTaxNo,FCXshAmt,FCXshVat,FCXshAmtNV,FCXshGrandTotal,'
	--*NUI 2019-11-14
	SET @tSql +=' FNAppType,FTPosRegNo,FTCstBchCode,FTCstBusiness,FTEstablishment'
	-------------
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'	
	SET @tSql +=' SalVat.FTBchCode,FTBchName,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,FTXshDocNo,FTPosCode,FTXshRefInt,FTCstCode,FTCstName,FTCstTaxNo,FCXshValue,FCXshVat,FCXshAmtNV,FCXshGrand,'
	--*NUI 2019-11-14
	SET @tSql +=' FNAppType,FTPosRegNo,FTCstBchCode,FTCstBusiness,FTEstablishment'
	SET @tSql +=' FROM'	
			SET @tSql +=' (SELECT HD.FTBchCode,CONVERT(VARCHAR(10),FDXshDocDate,121) AS FDXshdocDate,HD.FTPosCode,HD.FTXshDocNo,ISNULL(FTXshRefExt,'''') FTXshRefInt,HD.FTCstCode,TaxAddr.FTAddName AS FTCstName ,TaxAddr.FTAddTaxNo AS FTCstTaxNo,'
			--NUI10-04-2020
			--SET @tSql +=' CASE WHEN HD.FNXshDocType = 4 THEN ISNULL(FCXshVatable,0)-ISNULL(FCXshAmtNV,0) ELSE (ISNULL(FCXshVatable,0)-ISNULL(FCXshAmtNV,0))*-1 END AS FCXshValue,'
			SET @tSql +=' CASE WHEN HD.FNXshDocType = 4 THEN ISNULL(FCXshVatable,0) ELSE (ISNULL(FCXshVatable,0))*-1 END AS FCXshValue,'
			SET @tSql +=' CASE WHEN HD.FNXshDocType = 4 THEN ISNULL(FCXshVat,0) ELSE ISNULL(FCXshVat,0)*-1 END AS FCXshVat,'
			SET @tSql +=' CASE WHEN HD.FNXshDocType = 4 THEN ISNULL(FCXshAmtNV,0) ELSE ISNULL(FCXshAmtNV,0)*-1 END AS FCXshAmtNV,'
			--NUI10-04-2020
			SET @tSql +=' CASE WHEN HD.FNXshDocType = 4 THEN ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0) ELSE (ISNULL(FCXshGrand,0)-ISNULL(FCXshRnd,0))*-1 END AS FCXshGrand,'
			--*NUI 2019-11-14
			SET @tSql +=' 1 AS FNAppType,POS.FTPosRegNo,FTAddStaBchCode AS FTCstBchCode,FTAddStaBusiness AS FTCstBusiness,'
			SET @tSql +=' CASE WHEN ISNULL(TaxAddr.FTAddStaBusiness,'''') <> ''1'' THEN '''' ELSE CASE WHEN FTAddStaHQ = ''1'' THEN ''Head Office  '' ELSE ''Branch / ''  END + CASE WHEN FTAddStaBchCode <> '''' THEN '' / '' + FTAddStaBchCode ELSE '''' END   END AS FTEstablishment'
			SET @tSql +=' FROM TPSTTaxHD HD '
			SET @tSql +=' LEFT JOIN TPSTTaxHDCst HDCst WITH (NOLOCK) ON HD.FTBchCode = HDCst.FTBchCode AND HD.FTXshDocNo = HDCst.FTXshDocNo'
			SET @tSql +=' LEFT JOIN  TPSTTaxHDAddress TaxAddr WITH (NOLOCK) ON HD.FTXshDocNo = TaxAddr.FTXshDocNo'
		 			  SET @tSql +=' LEFT JOIN TCNMCst Cst ON HD.FTCstCode = Cst.FTCstCode '
					  SET @tSql +=' LEFT JOIN TCNMPOS POS ON HD.FTPosCode = Pos.FTPosCode AND HD.FTBchCode = Pos.FTBchCode '
					  SET @tSql +=' LEFT JOIN TCNMCst_L Cst_L ON HD.FTCstCode = Cst_L.FTCstCode AND Cst_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '
					  SET @tSql +=' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON HD.FTBchCode = Shp.FTBchCode AND HD.FTShpCode = Shp.FTShpCode '
					  SET @tSql +=' WHERE 1=1 AND FTXshStaDoc = ''1'''			  			
			SET @tSql += @tSql1			
			SET @tSql +=' ) SalVat LEFT JOIN '    
	SET @tSql +=' TCNMBranch_L Bch_L ON SalVat.FTBchCode = Bch_L.FTBchCode AND Bch_L.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''' '	 
	
	--PRINT @tSql
	EXECUTE(@tSql)

	RETURN SELECT * FROM TRPTPSTaxHDFullTmp WHERE FTComName = ''+ @nComName + '' AND FTRptCode = ''+ @tRptCode +'' AND FTUsrSession = '' + @tUsrSession + ''
	
END TRY

BEGIN CATCH 
	SET @FNResult= -1
END CATCH	
GO




/****** Object:  StoredProcedure [dbo].[SP_RPTxDailySaleINFO_Animate]    Script Date: 05/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxDailySaleINFO_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxDailySaleINFO_Animate
GO
CREATE PROCEDURE SP_RPTxDailySaleINFO_Animate 
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
	--ตัวแทนขาย
	@ptAgnL Varchar(8000), --กรณี Condition IN
	--@ptPosF Varchar(20),
	--@ptPosT Varchar(20),

	@ptPdtCodeF Varchar(20),
	@ptPdtCodeT Varchar(20),
	@ptPdtChanF Varchar(30),
	@ptPdtChanT Varchar(30),
	@ptPdtTypeF Varchar(5),
	@ptPdtTypeT Varchar(5),

	--NUI 22-09-05 RQ2208-020
	@ptPbnF Varchar(5),
	@ptPbnT Varchar(5),

	@ptDateF Varchar(10),
	@ptDateT Varchar(10),
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

-- @ptDateF จากวันที่
-- @ptDateT ถึงวันที่
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
	--SET @tPosF  = @ptPosF 
	--SET @tPosT  = @ptPosT

	SET @tPdtCodeF  = @ptPdtCodeF 
	SET @tPdtCodeT = @ptPdtCodeT
	SET @tPdtChanF = @ptPdtChanF
	SET @tPdtChanT = @ptPdtChanT 
	SET @tPdtTypeF = @ptPdtTypeF
	SET @tPdtTypeT = @ptPdtTypeT

	SET @tPbnF = @ptPbnF
	SET @tPbnT = @ptPbnT


	SET @tDocDateF = @ptDateF
	SET @tDocDateT = @ptDateT
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

	IF @ptAgnL =null
	BEGIN
		SET @ptAgnL = ''
	END

	--IF @tPosF = null
	--BEGIN
	--	SET @tPosF = ''
	--END
	--IF @tPosT = null OR @tPosT = ''
	--BEGIN
	--	SET @tPosT = @tPosF
	--END

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
	SET @tSql1 = ' WHERE 1=1'
	SET @tSqlPdt = ' WHERE 1=1'

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND Stk.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END


	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN		
			SET @tSql1 +=' AND (Stk.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql1 +=' OR ISNULL(Stk.FTBchCode,'''') = '''') '
			--SET @tSqlPdt +=' AND StkBal.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptAgnL <> '')
		BEGIN
			SET @tSql1 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
		END		
	END
	IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		SET @tSql1 +=' AND PdtM.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	END

	IF (@tPdtChanF <> '' AND @tPdtChanT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		SET @tSql1 +=' AND PdtM.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		SET @tSql1 += ' AND PdtM.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tPbnF <> '' AND @tPbnT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		SET @tSql1 += ' AND PdtM.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		--PRINT @tSqlLast
		--SET @tSql1 +=' AND (CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSql1 += ' AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,''' + @tDocDateF + '''), ''yyyy-MM-01'') AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) <= ''' + @tDocDateT + ''''
	END

	DELETE FROM TRPTSaleINFOTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  =' INSERT INTO TRPTSaleINFOTmp_Animate '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTPtyName,FTPbnName,FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,FCPdtStkSetPrice,FCPdtStkQtySale,FCPdtStkQtyIn,FCStkQtyBal'
	 SET @tSql +=' '
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' FTPtyName,FTPbnName,FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,ISNULL(FCPdtStkSetPrice,0) AS FCPdtStkSetPrice,ISNULL(FCPdtStkQtySale,0) AS FCPdtStkQtySale,'
	SET @tSql +=' ISNULL(FCPdtStkQtyIn,0) AS FCPdtStkQtyIn,ISNULL(FCStkQtyMthEnd,0)+ISNULL(FCPdtStkQtyIn,0)-ISNULL(FCPdtStkQtySale,0) AS FCStkQtyBal'
	SET @tSql +=' FROM('
			SET @tSql +=' SELECT FTPtyName,FTPbnName,STK.FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,StkSetPrice.FCPdtStkSetPrice,'
			SET @tSql +=' SUM(CASE FTStkType'
			SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk.FCStkQty,0)'  --ขาย
			SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk.FCStkQty,0)*-1' --คืน
			SET @tSql +=' END) AS FCPdtStkQtySale,'
			SET @tSql +=' SUM(CASE FTStkType'
			SET @tSql +=' WHEN ''1'' THEN ISNULL(Stk.FCStkQty,0)' --เข้า
			SET @tSql +=' WHEN ''2'' THEN ISNULL(Stk.FCStkQty,0)*-1' --ออก
			SET @tSql +=' WHEN ''5'' THEN ISNULL(Stk.FCStkQty,0)' -- ปรับจำนวน + : เข้า , - : ออก
			SET @tSql +=' END) AS FCPdtStkQtyIn,SUM(ISNULL(MthEnd.FCStkQtyMthEnd,0))  + SUM(ISNULL(MthEnd1.FCStkQtyMthEnd,0)) AS FCStkQtyMthEnd'

			SET @tSql +=' FROM TCNTPdtStkCrd Stk WITH (NOLOCK)'
			SET @tSql +=' LEFT JOIN TCNMPdt PdtM WITH(NOLOCK) ON Stk.FTPdtCode = PdtM.FTPdtCode'
			SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON PdtM.FTPdtCode =  SpcBch.FTPdtCode'
			SET @tSql +=' LEFT JOIN'
			SET @tSql +=' (SELECT Stk.FTBchCode,FTWahCode,Stk.FTPdtCode,'
			 SET @tSql +=' CASE WHEN' 
					SET @tSql +=' SUM(CASE FTStkType'
					SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk.FCStkQty,0)'  --ขาย
					SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk.FCStkQty,0)*-1' --คืน
					SET @tSql +=' END) = 0 THEN 0' 				
   			 SET @tSql +=' ELSE'			 
					SET @tSql +=' (SUM(CASE FTStkType'
			 			 SET @tSql +=' WHEN ''3'' THEN (ISNULL(Stk.FCStkQty,0)*ISNULL(FCStkSetPrice,0))'  --ขาย
						 SET @tSql +=' WHEN ''4'' THEN (ISNULL(Stk.FCStkQty,0)*ISNULL(FCStkSetPrice,0))*-1' --คืน
						 SET @tSql +=' END) /' 
					 SET @tSql +=' SUM(CASE FTStkType'
						 SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk.FCStkQty,0)'  --ขาย
						 SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk.FCStkQty,0)*-1' --คืน
						SET @tSql +=' END))' 
			 SET @tSql +=' END AS FCPdtStkSetPrice'
			 SET @tSql +=' FROM TCNTPdtStkCrd Stk WITH (NOLOCK)'	
			 SET @tSql +=' LEFT JOIN TCNMPdt PdtM WITH(NOLOCK) ON Stk.FTPdtCode = PdtM.FTPdtCode'
			 SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON PdtM.FTPdtCode =  SpcBch.FTPdtCode'
			 SET @tSql +=' WHERE FTStkType IN (''3'',''4'') AND ISNULL(FCStkSetPrice,0) <> 0'
			 SET @tSql +=' GROUP BY Stk.FTBchCode,FTWahCode,Stk.FTPdtCode'
			 SET @tSql +=' ) StkSetPrice ON STK.FTBchCode = StkSetPrice.FTBchCode AND STK.FTPdtCode = StkSetPrice.FTPdtCode AND STK.FTWahCode = StkSetPrice.FTWahCode'
			 SET @tSql +=' LEFT JOIN'
					SET @tSql +=' ('--Pdt
						SET @tSql +=' SELECT Pdt.FTPdtCode,PdtL.FTPdtName,ISNULL(PdtL.FTPdtNameOth,'''') AS FTPdtNameOth,PdtBar.FTBarCode,ISNULL(PtyL.FTPtyName,'''') AS FTPtyName,ISNULL(PbnL.FTPbnName,'''') AS FTPbnName'
						SET @tSql +=' FROM TCNMPdt Pdt WITH(NOLOCK)'
						SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPbnCode = PtyL.FTPtyCode AND PtyL.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK) ON Pdt.FTPdtCode = Ppz.FTPdtCode AND FCPdtUnitFact = 1'
						SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK) ON Ppz.FTPdtCode = PdtBar.FTPdtCode AND Ppz.FTPunCode = PdtBar.FTPunCode'
						SET @tSql += @tSqlPdt
					SET @tSql +=' ) Pdt ON Stk.FTpdtCode = Pdt.FTPdtCode'
			SET @tSql +=' LEFT JOIN' 
					SET @tSql +=' ('--TCNTPdtStkCrdME
						SET @tSql +=' SELECT FDStkDate,StkME.FTBchCode,StkME.FTPdtCode,FCStkQty AS  FCStkQtyMthEnd,FORMAT(FDStkDate, ''yyyy-MM'') AS FTStkMonthYer'
						SET @tSql +=' FROM TCNTPdtStkCrdME StkME WITH(NOLOCK)'
						SET @tSql +=' WHERE FORMAT(FDStkDate, ''yyyy-MM'') = FORMAT(CONVERT(DATETIME,2022-07-25), ''yyyy-MM'')'
					SET @tSql +=' ) MthEnd ON Stk.FTBchCode = MthEnd.FTBchCode AND Stk.FTPdtCode = MthEnd.FTPdtCode AND FORMAT(Stk.FDStkDate, ''yyyy-MM'') = FORMAT(MthEnd.FDStkDate, ''yyyy-MM'')'
					  SET @tSql +=' LEFT JOIN'
					SET @tSql +=' ('--	TCNTPdtStkCrd ยอดยกมา เพื่อรวม กับ Qty ใน TCNTPdtStkCrdME						
						SET @tSql +=' SELECT FTBchCode,FTPdtCode,FORMAT(FDStkDate, ''yyyy-MM'') AS FTStkMonthYer,'
						SET @tSql +=' SUM(CASE FTStkType'
						SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk1.FCStkQty,0)*-1'  --ขาย
						SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk1.FCStkQty,0)' --คืน
						SET @tSql +=' WHEN ''1'' THEN ISNULL(Stk1.FCStkQty,0)' --เข้า
						SET @tSql +=' WHEN ''2'' THEN ISNULL(Stk1.FCStkQty,0)*-1' --ออก
						SET @tSql +=' WHEN ''5'' THEN ISNULL(Stk1.FCStkQty,0)' -- ปรับจำนวน + : เข้า , - : ออก
						SET @tSql +=' END) AS  FCStkQtyMthEnd'
						SET @tSql +=' FROM TCNTPdtStkCrd  Stk1 WITH(NOLOCK)'
						SET @tSql +=' WHERE CONVERT(VARCHAR(10),Stk1.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,''' + @ptDateF+ '''), ''yyyy-MM-01'') AND CONVERT(VARCHAR(10),Stk1.FDStkDate,121) < '''+ @ptDateF+''''--@ptDateF
						SET @tSql +=' GROUP BY FTBchCode,FTPdtCode,FORMAT(FDStkDate, ''yyyy-MM'')'
					SET @tSql +=' ) MthEnd1 ON STK.FTBchCode = MthEnd1.FTBchCode AND STK.FTPdtCode = MthEnd1.FTPdtCode AND FORMAT(STK.FDStkDate, ''yyyy-MM'') = MthEnd1.FTStkMonthYer'
			--
			 --WHERE CONVERT(VARCHAR(10),Stk.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,@ptDateF), 'yyyy-MM-01') AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) <= @ptDateT
			SET @tSql +=@tSql1
			SET @tSql +=' GROUP BY FTPtyName,FTPbnName,STK.FTPdtCode,Pdt.FTPdtName,Pdt.FTPdtNameOth,Pdt.FTBarCode,StkSetPrice.FCPdtStkSetPrice'--,ISNULL(MthEnd.FCStkQtyMthEnd,0)  + ISNULL(MthEnd1.FCStkQtyMthEnd,0) 
			SET @tSql +=' ) SalData'

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





/****** Object:  StoredProcedure [dbo].[SP_RPTxDailySaleINFO_Animate]    Script Date: 05/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxDailySaleINFO_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxDailySaleINFO_Animate
GO
CREATE PROCEDURE SP_RPTxDailySaleINFO_Animate 
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
	--ตัวแทนขาย
	@ptAgnL Varchar(8000), --กรณี Condition IN
	--@ptPosF Varchar(20),
	--@ptPosT Varchar(20),

	@ptPdtCodeF Varchar(20),
	@ptPdtCodeT Varchar(20),
	@ptPdtChanF Varchar(30),
	@ptPdtChanT Varchar(30),
	@ptPdtTypeF Varchar(5),
	@ptPdtTypeT Varchar(5),

	--NUI 22-09-05 RQ2208-020
	@ptPbnF Varchar(5),
	@ptPbnT Varchar(5),

	@ptDateF Varchar(10),
	@ptDateT Varchar(10),
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

-- @ptDateF จากวันที่
-- @ptDateT ถึงวันที่
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
	DECLARE @tSql2 VARCHAR(8000)
	DECLARE @tSql3 VARCHAR(8000)
	DECLARE @tSqlME VARCHAR(8000)
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
	--SET @tPosF  = @ptPosF 
	--SET @tPosT  = @ptPosT

	SET @tPdtCodeF  = @ptPdtCodeF 
	SET @tPdtCodeT = @ptPdtCodeT
	SET @tPdtChanF = @ptPdtChanF
	SET @tPdtChanT = @ptPdtChanT 
	SET @tPdtTypeF = @ptPdtTypeF
	SET @tPdtTypeT = @ptPdtTypeT

	SET @tPbnF = @ptPbnF
	SET @tPbnT = @ptPbnT


	SET @tDocDateF = @ptDateF
	SET @tDocDateT = @ptDateT
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

	IF @ptAgnL =null
	BEGIN
		SET @ptAgnL = ''
	END

	--IF @tPosF = null
	--BEGIN
	--	SET @tPosF = ''
	--END
	--IF @tPosT = null OR @tPosT = ''
	--BEGIN
	--	SET @tPosT = @tPosF
	--END

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
	SET @tSql1 = ' WHERE 1=1'
	SET @tSqlPdt = ' WHERE 1=1'
	SET @tSql2 = ''
	SET @tSqlME = ''
	SET @tSql3 = ''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND Stk.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END


	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN		
			SET @tSql1 +=' AND (Stk.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql1 +=' OR ISNULL(Stk.FTBchCode,'''') = '''') '
			SET @tSql3 +=' AND (Stk.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql3 +=' OR ISNULL(Stk.FTBchCode,'''') = '''') '
			SET @tSql2 +=' AND (Stk1.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql2 +=' OR ISNULL(Stk1.FTBchCode,'''') = '''') '
			SET @tSqlME +=' AND (StkME.FTBchCode IN (' + @ptBchL + ')'
			SET @tSqlME +=' OR ISNULL(StkME.FTBchCode,'''') = '''') '

			--SET @tSqlPdt +=' AND StkBal.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql3 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql2 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlME +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql3 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql2 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlME +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptAgnL <> '')
		BEGIN
			SET @tSql1 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
			SET @tSql3 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
			SET @tSql2 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
			SET @tSqlME += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
		END		
	END
	IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		SET @tSql1 +=' AND PdtM.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		SET @tSql3 +=' AND PdtM.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		SET @tSql2 +=' AND PdtM.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		SET @tSqlMe +=' AND PdtM.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	END

	IF (@tPdtChanF <> '' AND @tPdtChanT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		SET @tSql1 +=' AND PdtM.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		SET @tSql3 +=' AND PdtM.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		SET @tSql2 +=' AND PdtM.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		SET @tSqlME +=' AND PdtM.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		SET @tSql1 += ' AND PdtM.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		SET @tSql3 += ' AND PdtM.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		SET @tSql2 += ' AND PdtM.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		SET @tSqlME += ' AND PdtM.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tPbnF <> '' AND @tPbnT <> '')
	BEGIN
		SET @tSqlPdt +=' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		SET @tSql1 += ' AND PdtM.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		SET @tSql3 += ' AND PdtM.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		SET @tSql2 += ' AND PdtM.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		SET @tSqlME += ' AND PdtM.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		--PRINT @tSqlLast
		--SET @tSql1 +=' AND (CONVERT(VARCHAR(10),FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSql1 += ' AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,''' + @tDocDateF + '''), ''yyyy-MM-01'') AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) <= ''' + @tDocDateT + ''''
	END
	
	DELETE FROM TRPTSaleINFOTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  =' INSERT INTO TRPTSaleINFOTmp_Animate '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTPtyName,FTPbnName,FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,FCPdtStkSetPrice,FCPdtStkQtySale,FCPdtStkQtyIn,FCStkQtyBal'
	 SET @tSql +=' '
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' FTPtyName,FTPbnName,FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,ISNULL(FCPdtStkSetPrice,0) AS FCPdtStkSetPrice,ISNULL(FCPdtStkQtySale,0) AS FCPdtStkQtySale,'
	SET @tSql +=' ISNULL(FCPdtStkQtyIn,0) AS FCPdtStkQtyIn,ISNULL(FCStkQtyMthEnd,0)+ISNULL(FCPdtStkQtyIn,0)-ISNULL(FCPdtStkQtySale,0) AS FCStkQtyBal'
	SET @tSql +=' FROM('
			SET @tSql +=' SELECT FTPtyName,FTPbnName,STK.FTPdtCode,FTPdtName,FTPdtNameOth,FTBarCode,StkSetPrice.FCPdtStkSetPrice,'
			SET @tSql +=' SUM(CASE FTStkType'
			SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk.FCStkQty,0)'  --ขาย
			SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk.FCStkQty,0)*-1' --คืน
			SET @tSql +=' END) AS FCPdtStkQtySale,'
			SET @tSql +=' SUM(CASE FTStkType'
			SET @tSql +=' WHEN ''1'' THEN ISNULL(Stk.FCStkQty,0)' --เข้า
			SET @tSql +=' WHEN ''2'' THEN ISNULL(Stk.FCStkQty,0)*-1' --ออก
			SET @tSql +=' WHEN ''5'' THEN ISNULL(Stk.FCStkQty,0)' -- ปรับจำนวน + : เข้า , - : ออก
			SET @tSql +=' END) AS FCPdtStkQtyIn,SUM(ISNULL(MthEnd.FCStkQtyMthEnd,0))  + SUM(ISNULL(MthEnd1.FCStkQtyMthEnd,0)) AS FCStkQtyMthEnd'

			SET @tSql +=' FROM TCNTPdtStkCrd Stk WITH (NOLOCK)'
			SET @tSql +=' LEFT JOIN TCNMPdt PdtM WITH(NOLOCK) ON Stk.FTPdtCode = PdtM.FTPdtCode'
			SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON PdtM.FTPdtCode =  SpcBch.FTPdtCode'
			SET @tSql +=' LEFT JOIN'
			SET @tSql +=' (SELECT Stk.FTPdtCode,'
			 SET @tSql +=' CASE WHEN' 
					SET @tSql +=' SUM(CASE FTStkType'
					SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk.FCStkQty,0)'  --ขาย
					SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk.FCStkQty,0)*-1' --คืน
					SET @tSql +=' END) = 0 THEN 0' 				
   			 SET @tSql +=' ELSE'			 
					SET @tSql +=' (SUM(CASE FTStkType'
			 			 SET @tSql +=' WHEN ''3'' THEN (ISNULL(Stk.FCStkQty,0)*ISNULL(FCStkSetPrice,0))'  --ขาย
						 SET @tSql +=' WHEN ''4'' THEN (ISNULL(Stk.FCStkQty,0)*ISNULL(FCStkSetPrice,0))*-1' --คืน
						 SET @tSql +=' END) /' 
					 SET @tSql +=' SUM(CASE FTStkType'
						 SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk.FCStkQty,0)'  --ขาย
						 SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk.FCStkQty,0)*-1' --คืน
						SET @tSql +=' END))' 
			 SET @tSql +=' END AS FCPdtStkSetPrice'
			 SET @tSql +=' FROM TCNTPdtStkCrd Stk WITH (NOLOCK)'	
			 SET @tSql +=' LEFT JOIN TCNMPdt PdtM WITH(NOLOCK) ON Stk.FTPdtCode = PdtM.FTPdtCode'
			 SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON PdtM.FTPdtCode =  SpcBch.FTPdtCode'
			 SET @tSql +=' WHERE FTStkType IN (''3'',''4'') AND ISNULL(FCStkSetPrice,0) <> 0'
			 SET @tSql += @tSql3
			 SET @tSql +=' GROUP BY Stk.FTPdtCode'
			 SET @tSql +=' ) StkSetPrice ON STK.FTPdtCode = StkSetPrice.FTPdtCode '
			 SET @tSql +=' LEFT JOIN'
					SET @tSql +=' ('--Pdt
						SET @tSql +=' SELECT Pdt.FTPdtCode,PdtL.FTPdtName,ISNULL(PdtL.FTPdtNameOth,'''') AS FTPdtNameOth,PdtBar.FTBarCode,ISNULL(PtyL.FTPtyName,'''') AS FTPtyName,ISNULL(PbnL.FTPbnName,'''') AS FTPbnName'
						SET @tSql +=' FROM TCNMPdt Pdt WITH(NOLOCK)'
						SET @tSql +=' LEFT JOIN TCNMPdt_L PdtL WITH(NOLOCK) ON Pdt.FTPdtCode = PdtL.FTPdtCode AND PdtL.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						SET @tSql +=' LEFT JOIN TCNMPdtBrand_L PbnL WITH(NOLOCK) ON Pdt.FTPbnCode = PbnL.FTPbnCode AND PbnL.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID =  '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
						SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH(NOLOCK) ON Pdt.FTPdtCode = Ppz.FTPdtCode AND FCPdtUnitFact = 1'
						SET @tSql +=' LEFT JOIN TCNMPdtBar PdtBar WITH(NOLOCK) ON Ppz.FTPdtCode = PdtBar.FTPdtCode AND Ppz.FTPunCode = PdtBar.FTPunCode'
						SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON Pdt.FTPdtCode =  SpcBch.FTPdtCode'
						SET @tSql += @tSqlPdt
					SET @tSql +=' ) Pdt ON Stk.FTpdtCode = Pdt.FTPdtCode'
			SET @tSql +=' LEFT JOIN' 
					SET @tSql +=' ('--TCNTPdtStkCrdME
						SET @tSql +=' SELECT FDStkDate,StkME.FTBchCode,StkME.FTPdtCode,FCStkQty AS  FCStkQtyMthEnd,FORMAT(FDStkDate, ''yyyy-MM'') AS FTStkMonthYer'
						SET @tSql +=' FROM TCNTPdtStkCrdME StkME WITH(NOLOCK)'
						SET @tSql +=' LEFT JOIN TCNMPdt PdtM WITH(NOLOCK) ON StkME.FTPdtCode = PdtM.FTPdtCode'
						SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON PdtM.FTPdtCode =  SpcBch.FTPdtCode'
						SET @tSql +=' WHERE FORMAT(FDStkDate, ''yyyy-MM'') = FORMAT(CONVERT(DATETIME,''' + @ptDateF+ '''), ''yyyy-MM'')'
						--PRINT @tSqlME
						SET @tSql += @tSqlME
					SET @tSql +=' ) MthEnd ON Stk.FTBchCode = MthEnd.FTBchCode AND Stk.FTPdtCode = MthEnd.FTPdtCode AND FORMAT(Stk.FDStkDate, ''yyyy-MM'') = FORMAT(MthEnd.FDStkDate, ''yyyy-MM'')'
					  SET @tSql +=' LEFT JOIN'
					SET @tSql +=' ('--	TCNTPdtStkCrd ยอดยกมา เพื่อรวม กับ Qty ใน TCNTPdtStkCrdME						
						SET @tSql +=' SELECT Stk1.FTBchCode,Stk1.FTPdtCode,FORMAT(FDStkDate, ''yyyy-MM'') AS FTStkMonthYer,'
						SET @tSql +=' SUM(CASE FTStkType'
						SET @tSql +=' WHEN ''3'' THEN ISNULL(Stk1.FCStkQty,0)*-1'  --ขาย
						SET @tSql +=' WHEN ''4'' THEN ISNULL(Stk1.FCStkQty,0)' --คืน
						SET @tSql +=' WHEN ''1'' THEN ISNULL(Stk1.FCStkQty,0)' --เข้า
						SET @tSql +=' WHEN ''2'' THEN ISNULL(Stk1.FCStkQty,0)*-1' --ออก
						SET @tSql +=' WHEN ''5'' THEN ISNULL(Stk1.FCStkQty,0)' -- ปรับจำนวน + : เข้า , - : ออก
						SET @tSql +=' END) AS  FCStkQtyMthEnd'
						SET @tSql +=' FROM TCNTPdtStkCrd  Stk1 WITH(NOLOCK)'
						SET @tSql +=' LEFT JOIN TCNMPdt PdtM WITH(NOLOCK) ON Stk1.FTPdtCode = PdtM.FTPdtCode'
						SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON PdtM.FTPdtCode =  SpcBch.FTPdtCode'
						SET @tSql +=' WHERE CONVERT(VARCHAR(10),Stk1.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,''' + @ptDateF+ '''), ''yyyy-MM-01'') AND CONVERT(VARCHAR(10),Stk1.FDStkDate,121) < '''+ @ptDateF+''''--@ptDateF
						SET @tSql += @tSql2
						SET @tSql +=' GROUP BY Stk1.FTBchCode,Stk1.FTPdtCode,FORMAT(FDStkDate, ''yyyy-MM'')'
					SET @tSql +=' ) MthEnd1 ON STK.FTBchCode = MthEnd1.FTBchCode AND STK.FTPdtCode = MthEnd1.FTPdtCode AND FORMAT(STK.FDStkDate, ''yyyy-MM'') = MthEnd1.FTStkMonthYer'
			--
			 --WHERE CONVERT(VARCHAR(10),Stk.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,@ptDateF), 'yyyy-MM-01') AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) <= @ptDateT
			SET @tSql +=@tSql1
			SET @tSql +=' GROUP BY FTPtyName,FTPbnName,STK.FTPdtCode,Pdt.FTPdtName,Pdt.FTPdtNameOth,Pdt.FTBarCode,StkSetPrice.FCPdtStkSetPrice'--,ISNULL(MthEnd.FCStkQtyMthEnd,0)  + ISNULL(MthEnd1.FCStkQtyMthEnd,0) 
			SET @tSql +=' ) SalData'

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


/****** Object:  StoredProcedure [dbo].[SP_RPTxSaleByPty_Animate]    Script Date: 28/09/2022 18:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RPTxSaleByPty_Animate]') AND type in (N'P', N'PC'))
DROP PROCEDURE SP_RPTxSaleByPty_Animate
GO
CREATE PROCEDURE SP_RPTxSaleByPty_Animate 
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
	--ตัวแทนขาย
	@ptAgnL Varchar(8000), --กรณี Condition IN
	--@ptPosF Varchar(20),
	--@ptPosT Varchar(20),

	@ptPdtCodeF Varchar(20),
	@ptPdtCodeT Varchar(20),
	@ptPdtChanF Varchar(30),
	@ptPdtChanT Varchar(30),
	@ptPdtTypeF Varchar(5),
	@ptPdtTypeT Varchar(5),

	--NUI 22-09-05 RQ2208-020
	@ptPbnF Varchar(5),
	@ptPbnT Varchar(5),

	@ptDateF Varchar(10),
	@ptDateT Varchar(10),
	----ลูกค้า
	--@ptCstF Varchar(20),
	--@ptCstT Varchar(20),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 28/09/2022
-- V.01.00.00
-- Temp name  SP_RPTxSaleByPty_Animate
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

-- @ptDateF จากวันที่
-- @ptDateT ถึงวันที่
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
	DECLARE @tSql2 VARCHAR(8000)
	DECLARE @tSql3 VARCHAR(8000)
	DECLARE @tSqlME VARCHAR(8000)
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
	--SET @tPosF  = @ptPosF 
	--SET @tPosT  = @ptPosT

	SET @tPdtCodeF  = @ptPdtCodeF 
	SET @tPdtCodeT = @ptPdtCodeT
	SET @tPdtChanF = @ptPdtChanF
	SET @tPdtChanT = @ptPdtChanT 
	SET @tPdtTypeF = @ptPdtTypeF
	SET @tPdtTypeT = @ptPdtTypeT

	SET @tPbnF = @ptPbnF
	SET @tPbnT = @ptPbnT


	SET @tDocDateF = @ptDateF
	SET @tDocDateT = @ptDateT
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

	IF @ptAgnL =null
	BEGIN
		SET @ptAgnL = ''
	END

	--IF @tPosF = null
	--BEGIN
	--	SET @tPosF = ''
	--END
	--IF @tPosT = null OR @tPosT = ''
	--BEGIN
	--	SET @tPosT = @tPosF
	--END

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
	SET @tSql1 = ''
	SET @tSqlPdt = ' WHERE 1=1'
	SET @tSql2 = ''
	SET @tSqlME = ''
	SET @tSql3 = ''

	IF @pnFilterType = '1'
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND DT.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END


	END

	IF @pnFilterType = '2'
	BEGIN
		IF (@ptBchL <> '' )
		BEGIN		
			SET @tSql1 +=' AND (DT.FTBchCode IN (' + @ptBchL + ')'
			SET @tSql1 +=' OR ISNULL(DT.FTBchCode,'''') = '''') '
			--SET @tSql3 +=' AND (Stk.FTBchCode IN (' + @ptBchL + ')'
			--SET @tSql3 +=' OR ISNULL(Stk.FTBchCode,'''') = '''') '
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql3 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
			SET @tSql2 +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
			SET @tSqlME +=' AND SpcBch.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql3 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
			SET @tSql2 +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
			SET @tSqlME +=' AND SpcBch.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptAgnL <> '')
		BEGIN
			SET @tSql1 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
			SET @tSql3 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
			SET @tSql2 += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
			SET @tSqlME += ' AND SpcBch.FTAgnCode IN (' + @ptAgnL + ')'
		END		
	END
	IF (@tPdtCodeF <> '' AND @tPdtCodeT <> '')
	BEGIN
		SET @tSql1 +=' AND Pdt.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
		--SET @tSql3 +=' AND PdtM.FTPdtCode BETWEEN ''' + @tPdtCodeF + ''' AND ''' + @tPdtCodeT + ''''
	END

	IF (@tPdtChanF <> '' AND @tPdtChanT <> '')
	BEGIN

		SET @tSql1 +=' AND Pdt.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
		--SET @tSql3 +=' AND PdtM.FTPgpChain BETWEEN ''' + @tPdtChanF + ''' AND ''' + @tPdtChanT + ''''
	END

	IF (@tPdtTypeF <> '' AND @tPdtTypeT <> '')
	BEGIN		
		SET @tSql1 += ' AND Pdt.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
		--SET @tSql3 += ' AND PdtM.FTPtyCode BETWEEN ''' + @tPdtTypeF + ''' AND ''' + @tPdtTypeT + ''''
	END

	IF (@tPbnF <> '' AND @tPbnT <> '')
	BEGIN
		SET @tSql1 += ' AND Pdt.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
		--SET @tSql3 += ' AND PdtM.FTPbnCode BETWEEN ''' + @tPbnF + ''' AND ''' + @tPbnT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		--PRINT @tSqlLast
		SET @tSql1 +=' AND CONVERT(VARCHAR(10),HD.FDXshDocDate,121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		--SET @tSql1 += ' AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) >= FORMAT(CONVERT(DATETIME,''' + @tDocDateF + '''), ''yyyy-MM-01'') AND CONVERT(VARCHAR(10),Stk.FDStkDate,121) <= ''' + @tDocDateT + ''''
	END
	
	DELETE FROM TRPTSaleByPtyTmp_Animate WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptCode = '' + @tRptCode + '' AND FTUsrSession = '' + @tUsrSession + ''--ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 --Sale
  	SET @tSql  =' INSERT INTO TRPTSaleByPtyTmp_Animate '
	SET @tSql +=' (FTComName,FTRptCode,FTUsrSession,'
	 SET @tSql +=' FTPtyCode,FTPtyName,FCXsdCostAvg,FCXsdSaleTotal,FCStkCostBal,FCSalAmtBal'
	 SET @tSql +=' '
	SET @tSql +=' )'
	SET @tSql +=' SELECT '''+ @nComName + ''' AS FTComName,'''+ @tRptCode +''' AS FTRptCode, '''+ @tUsrSession +''' AS FTUsrSession,'
	SET @tSql +=' ISNULL(SalePty.FTPtyCode,'''') AS FTPtyCode,ISNULL(PtyL.FTPtyName,'''') AS FTPtyName,SUM(FCXsdCostAvg)/SUM(FCXsdQtyAll) AS FCXsdCostAvg,'
	SET @tSql +=' SUM(FCXsdSaleTotal) AS FCXsdSaleTotal,SUM(FCStkCostBal) AS FCStkCostBal,SUM(FCSalAmtBal) AS FCSalAmtBal'
	SET @tSql +=' FROM('
		SET @tSql +=' SELECT Cost1.FTBchCode,Cost1.FTPtyCode,(FCXsdCostTotal) AS FCXsdCostAvg,FCXsdQtyAll,Sale.FCXsdSaleTotal,Sale.FCStkQty AS FCStkQtyBal,(FCXsdCostTotal/FCXsdQtyAll) * Sale.FCStkQty AS FCStkCostBal,ISNULL(Sale.FCSalAmtBal,0) AS FCSalAmtBal'
		SET @tSql +=' FROM('
				SET @tSql +=' SELECT  DT.FTBchCode,Pdt.FTPtyCode,'
				SET @tSql +=' SUM((CASE WHEN FNXshDocType = ''1'' THEN FCXsdQtyAll ELSE FCXsdQtyAll*-1 END)) AS FCXsdQtyAll,'
				SET @tSql +=' SUM((CASE WHEN FNXshDocType = ''1'' THEN FCXsdQtyAll ELSE FCXsdQtyAll*-1 END)* FCXsdCostIN) AS FCXsdCostTotal'
				SET @tSql +=' FROM TPSTSalDT DT WITH (NOLOCK) INNER JOIN TPSTSalHD  HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo'
				SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode'
				SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID ='''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
				SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode'
				SET @tSql +=' WHERE FCXsdCostIN <> 0'
				-- Condition
				SET @tSql += @tSql1
				SET @tSql +=' GROUP BY DT.FTBchCode,Pdt.FTPtyCode'
			SET @tSql +=' ) Cost1'
			SET @tSql +=' LEFT JOIN'
				SET @tSql +=' (SELECT  DT.FTBchCode,Pdt.FTPtyCode,'--DT.FTPdtCode,
				SET @tSql +=' SUM(CASE WHEN FNXshDocType = ''1'' THEN FCXsdNetAfHD ELSE FCXsdNetAfHD*-1 END) AS FCXsdSaleTotal,'
				SET @tSql +=' SUM(ISNULL(StkBal.FCStkQty,0)) AS FCStkQty,'
				SET @tSql +=' SUM(ISNULL(StkBal.FCStkQty,0)*ISNULL(FCPgdPriceRet,0))  AS FCSalAmtBal'
				SET @tSql +=' FROM TPSTSalDT DT WITH (NOLOCK) INNER JOIN TPSTSalHD  HD WITH (NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo'
				SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON DT.FTPdtCode = Pdt.FTPdtCode'
				SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON Pdt.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
				SET @tSql +=' LEFT JOIN TCNMPdtSpcBch SpcBch  WITH(NOLOCK)  ON DT.FTPdtCode =  SpcBch.FTPdtCode'
				SET @tSql +=' LEFT JOIN'
					SET @tSql +=' (SELECT StkBal.FTBchCode,StkBal.FTPdtCode,FTPtyCode,'
						SET @tSql +=' SUM(ISNULL(FCStkQty,0)) AS FCStkQty'			    
						SET @tSql +=' FROM TCNTPdtStkBal StkBal WITH(NOLOCK)' 
						SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON StkBal.FTPdtCode = Pdt.FTPdtCode'
						SET @tSql +=' GROUP BY FTBchCode,StkBal.FTPdtCode,FTPtyCode'
					SET @tSql +=' ) StkBal ON DT.FTBchCode = StkBal.FTBchCode AND DT.FTPdtCode = StkBal.FTPdtCode'
				SET @tSql +=' LEFT JOIN'
					SET @tSql +=' (SELECT SUBSTRING(P4Pdt.FTPghDocNo,3,5) AS FTBchCode,P4Pdt.FTPdtCode,Pdt.FTPtyCode,MAX(P4Pdt.FDPghDStop) AS FDPghDStop,AVG(P4Pdt.FCPgdPriceRet) AS FCPgdPriceRet'
					  SET @tSql +=' FROM TCNTPdtPrice4PDT P4Pdt WITH(NOLOCK)'
					  SET @tSql +=' LEFT JOIN TCNMPdt Pdt WITH(NOLOCK) ON P4Pdt.FTPdtCode = Pdt.FTPdtCode'
					  SET @tSql +=' LEFT JOIN TCNMPdtPackSize Pzs WITH(NOLOCK) ON P4Pdt.FTPdtCode = Pzs.FTPdtCode'
					  SET @tSql +=' WHERE Pzs.FCPdtUnitFact = 1'
					  SET @tSql +=' GROUP BY SUBSTRING(FTPghDocNo,3,5) ,P4Pdt.FTPdtCode,Pdt.FTPtyCode'
					SET @tSql +=' ) P4Pdt ON DT.FTBchCode = P4Pdt.FTBchCode AND DT.FTPdtCode = P4Pdt.FTPdtCode'
				--WHERE FCXsdCostIN <> 0
				SET @tSql +=@tSql1
				SET @tSql +=' GROUP BY DT.FTBchCode,Pdt.FTPtyCode'--,DT.FTPdtCode
				SET @tSql +=' ) Sale ON Cost1.FTBchCode = Sale.FTBchCode AND Cost1.FTPtyCode = Sale.FTPtyCode'
	SET @tSql +=' )SalePty'
	SET @tSql +=' LEFT JOIN TCNMPdtType_L PtyL WITH(NOLOCK) ON SalePty.FTPtyCode = PtyL.FTPtyCode AND PtyL.FNLngID = '''  + CAST(@nLngID  AS VARCHAR(10)) + ''''
	SET @tSql +=' GROUP BY ISNULL(SalePty.FTPtyCode,''''),PtyL.FTPtyName'

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
/******************************************** Stored Procedure ******************************/


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'SP_CNoBrowseProduct')
AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
 DROP PROCEDURE dbo.SP_CNoBrowseProduct
END
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
/*---------------------------------------------------------------------
Document History
Date			User		Remark
1.03/10/2022	Nale		เพิ่มฟิลเตอร์ค้นหาตามยี่ห้อสินค้า  
----------------------------------------------------------------------*/
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
														SET @tSQLMaster += ' AND PDLSPC.FTBchCode IN ('+@tSesBchCodeMulti+') '
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
	SET @tSql +=' FTBchCode,FTBchName,ISNULL(FTXsdBarCode,'''') AS FTXsdBarCode,FTPdtName ,FTPgpChainName,FTPbnName,'
	SET @tSql +=' SUM(ISNULL(FCXsdQtyAll,0)) AS FCXsdQtyAll,' --จำนวนขาย
	SET @tSql +=' ISNULL(FCStkQty,0) AS FCStkQty,' --สต๊อกคงเหลือ
	SET @tSql +=' SUM(FCSdtNetSale) AS FCSdtNetSale,' --ยอดขาย
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
			SET @tSql +=' (SELECT StkBal.FTBchCode,BchL.FTBchName ,StkBal.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,SUM(ISNULL(StkBal.FCStkQty,0)) AS FCStkQty,'
			SET @tSql +=' PForPdt.FCPgdPriceRet'
			 SET @tSql +=' FROM  TCNTPdtStkBal StkBal WITH (NOLOCK)'
			 SET @tSql +=' INNER JOIN' 
			 SET @tSql +=' TCNMPdt Pdt WITH (NOLOCK)  ON Pdt.FTPdtCode = StkBal.FTPdtCode'
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
				SET @tSql +=' SELECT SUBSTRING(FTPghDocNo,3,5) AS FTBchCode,PForPdt.FTPdtCode,PForPdt.FTPunCode,MAX(FDPghDStop) AS FDPghDStop,AVG(FCPgdPriceRet) AS FCPgdPriceRet' 
				SET @tSql +=' FROM TCNTPdtPrice4PDT PForPdt WITH (NOLOCK)'
				SET @tSql +=' LEFT JOIN TCNMPdtPackSize Ppz WITH (NOLOCK) ON PForPdt.FTPdtCode = Ppz.FTPdtCode AND PForPdt.FTPunCode = Ppz.FTPunCode'
				SET @tSql +=' WHERE ISNULL(FTPplCode,'''') = '''' AND ISNULL(FCPdtUnitFact,1) =1'
				SET @tSql +=' GROUP BY SUBSTRING(FTPghDocNo,3,5) ,PForPdt.FTPdtCode,PForPdt.FTPunCode'
			 SET @tSql +=' ) PForPdt ON StkBal.FTBchCode = PForPdt.FTBchCode AND StkBal.FTPdtCode = PForPdt.FTPdtCode'
			 SET @tSql +=' WHERE ISNULL(Ppz.FCPdtUnitFact,1) =1'
			 
			 --PRINT @tSqlPdt
--			 PRINT  @tSql
			 SET @tSql += @tSqlPdt
			 --PRINT @tSql 
			 --Where 1 สินค้าเท่านั้น
			 SET @tSql +=' GROUP BY StkBal.FTBchCode,BchL.FTBchName,StkBal.FTPdtCode,PdtBar.FTBarCode,PdtL.FTPdtName,PgpL.FTPgpChainName,PbnL.FTPbnName,PForPdt.FCPgdPriceRet'
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

/****** Object:  StoredProcedure [dbo].[SP_RPTxUseCard1]    Script Date: 6/10/2565 17:10:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_RPTxUseCard1] 
	@pnLngID int , 
	@pnComName Varchar(100),
	@ptRptName Varchar(100),
	--NUI23-12-2020
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
	@ptPosCodeL Varchar(8000), --กรณี Condition IN
	@ptPosCodeF Varchar(20),
	@ptPosCodeT Varchar(20),

	@ptCrdF Varchar(30),
	@ptCrdT Varchar(30),

	@ptCrdTypeF Varchar(30),
	@ptCrdTypeT Varchar(30),

	@ptDocDateF Varchar(10),
	@ptDocDateT Varchar(10),
	@FNResult INT OUTPUT 
AS
--------------------------------------
-- Watcharakorn 
-- Create 06/06/2019
-- Edit 22/12/2020
-- Last Update : Napat(Jame) 20/09/2022 เพิ่ม left join TPSTSalHD เพื่อดึง usercode การขาย
-- Last Update : Napat(Jame) 07/10/2022 ดึงชื่อผู้ดำเนินการ	 กรณีทำ process จาก AdaTask ไม่ต้อง join USR_L

-- @pnLngID ภาษา
-- @tRptName ชื่อรายงาน
-- @tRptName ชื่อรายงาน
-- @pnCrdF จากบัตร 
-- @pnCrdT ถึงหมายเลขบัตร
-- @ptDocDateF จากวันที่
-- @ptDocDateT ถึงวันที่
-- @FNResult
--------------------------------------
BEGIN TRY

	DECLARE @nLngID int 
	DECLARE @nComName Varchar(100)
	DECLARE @tRptName Varchar(100)
	DECLARE @tSql VARCHAR(Max)
	DECLARE @tSqlIns VARCHAR(Max)
	DECLARE @tSql1 nVARCHAR(Max)
	DECLARE @tSql2 VARCHAR(Max)
	--23-12-2020
	DECLARE @tUsrSession Varchar(255)
	DECLARE @tBchF Varchar(5)
	DECLARE @tBchT Varchar(5)

	--Merchant
	DECLARE @tMerF Varchar(10)
	DECLARE @tMerT Varchar(10)
	--Shop Code
	DECLARE @tShpF Varchar(10)
	DECLARE @tShpT Varchar(10)

	DECLARE @tPosCodeF Varchar(20)
	DECLARE @tPosCodeT Varchar(20)

	DECLARE @tCrdF Varchar(30)
	DECLARE @tCrdT Varchar(30)

	DECLARE @tCrdTypeF Varchar(30)
	DECLARE @tCrdTypeT Varchar(30)

	DECLARE @tDocDateF Varchar(10)
	DECLARE @tDocDateT Varchar(10)

	--SET @nLngID = 1
	--SET @nComName = 'Ada062'
	--SET @tRptName = 'UseCard1'
	--SET @tCrdF = '2019030500'
	--SET @tCrdT = '2019030600'
	--SET @tDocDateF = ''
	--SET @tDocDateT = ''

	SET @nLngID = @pnLngID
	SET @nComName = @pnComName
	SET @tRptName = @ptRptName
	--23-12-2020
	SET @tUsrSession = @ptUsrSession
	SET @tBchF = @ptBchF
	SET @tBchT = @ptBchT

	--Merchant
	SET @tMerF =@ptMerF
	SET @tMerT =@ptMerT
	--Shop Code
	SET @tShpF = @ptShpF
	SET @tShpT = @ptShpT

	SET @tPosCodeF  = @ptPosCodeF 
	SET @tPosCodeT = @ptPosCodeT 
	-----------23-12-2020

	SET @tCrdF = @ptCrdF
	SET @tCrdT = @ptCrdT

	SET @tCrdTypeF = @ptCrdTypeF
	SET @tCrdTypeT = @ptCrdTypeT

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
	--Branch
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
	-------

	---Merchant
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
	----------------
	
	--SHOP
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
	------------------

	--Pos
	IF @ptPosCodeL = null
	BEGIN
		SET @ptPosCodeL = ''
	END
	IF @tPosCodeF = null
	BEGIN
		SET @tPosCodeF = ''
	END

	IF @tPosCodeT = null OR @tPosCodeT = ''
	BEGIN
		SET @tPosCodeT = @tPosCodeF
	END
	-----------------------------------

	IF @tCrdF = null
	BEGIN
		SET @tCrdF = ''
	END 

	IF @tCrdT = null OR @tCrdT =''
	BEGIN
		SET @tCrdT = @tCrdF
	END 

	/* ประเภทบัตร */
	IF @tCrdTypeF = null
	BEGIN
		SET @tCrdTypeF = ''
	END 

	IF @tCrdTypeT = null OR @tCrdTypeT =''
	BEGIN
		SET @tCrdTypeT = @tCrdTypeF
	END 

	IF @tDocDateF = null
	BEGIN 
		SET @tDocDateF = ''
	END

	IF @tDocDateT = null OR @tDocDateT =''
	BEGIN 
		SET @tDocDateT = @tDocDateF
	END


	SET @tSql1 = ' WHERE 1=1 '
	
	--23-12-2020
	IF @pnFilterType = '1' --1 Between , 2 In
	BEGIN
		IF (@tBchF <> '' AND @tBchT <> '')
		BEGIN
			SET @tSql1 +=' AND Demo.FTBchCode BETWEEN ''' + @tBchF + ''' AND ''' + @tBchT + ''''
		END

		IF (@tMerF <> '' AND @tMerT <> '')
		BEGIN
			SET @tSql1 +=' AND Shp.FTMerCode BETWEEN ''' + @tMerF + ''' AND ''' + @tMerT + ''''
		END

		IF (@tShpF <> '' AND @tShpT <> '')
		BEGIN
			SET @tSql1 +=' AND Demo.FTShpCode BETWEEN ''' + @tShpF + ''' AND ''' + @tShpT + ''''
		END

		IF (@tPosCodeF <> '' AND @tPosCodeT <> '')
		BEGIN
			SET @tSql1 += ' AND FTTxnPosCode BETWEEN '''+@tPosCodeF+''' AND '''+@tPosCodeT+''''
		END		
	END

	IF @pnFilterType = '2' --1 Between , 2 In
	BEGIN
		IF (@ptBchL <> '')
		BEGIN
			SET @tSql1 +=' AND Demo.FTBchCode IN (' + @ptBchL + ')'
		END

		IF (@ptMerL <> '' )
		BEGIN
			SET @tSql1 +=' AND Shp.FTMerCode IN (' + @ptMerL + ')'
		END

		IF (@ptShpL <> '')
		BEGIN
			SET @tSql1 +=' AND Demo.FTShpCode IN (' + @ptShpL + ')'
		END

		IF (@ptPosCodeL <>'')
		BEGIN
			SET @tSql1 += ' AND FTTxnPosCode IN ('+@ptPosCodeL+ ')'
		END		
	END

	IF (@tCrdF <> '' AND @tCrdT <> '')
	BEGIN
		SET @tSql1 +=' AND FTCrdCode BETWEEN ''' + @tCrdF + ''' AND ''' + @tCrdT + ''''
	END

	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSql1 +=' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
		SET @tSql2 = ' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END
		
		--print @tSql1
		--DECLARE @nComName Varchar(100)
		--SET @nComName = 'Ada062'
	DELETE FROM TFCTRptCrdTmp WITH (ROWLOCK) WHERE FTComName =  '' + @nComName + ''  AND FTRptName = '' + @tRptName + '' --ลบข้อมูล Temp ของเครื่องที่จะบันทึกขอมูลลง Temp
 
	 --SELECT        A.FTBchCode, A.FTTxnDocNoRef, A.FTShpCode, A.FTShpName, A.FTTxnPosCode, A.FTDptName, A.FTPosType, A.FNTxnID, A.FNTxnIDRef, A.FTTxnDocType, A.FTTxnStaOffLine, A.FTCrdCode, A.FTCtyName, 
	 --                        A.FTCtyCode, A.FTCrdHolderID, A.FTCrdStaActive, A.FDTxnDocDate, A.FDCrdExpireDate, A.FTBchCodeRef, A.FCTxnValue, A.FCTxnCrdValue, A.FCTxnCrdAftTrans, A.FTCrdName, A.FCCrdBalance, A.CardExpValue, 
	 --                        A.FTTxnDocTypeName, A.FNLngID, A.FNDplLngID, A.FNCtyLngID, A.FNShpLngID, A.FTUsrCreate, A.FTDocLastUpdBy, 
	 --                        CASE WHEN A.FTTxnDocType = 3 THEN A.FTTxnPosCode WHEN A.FTTxnDocType = 4 THEN A.FTTxnPosCode WHEN A.FTTxnDocType = 5 THEN A.FTTxnPosCode ELSE USRL.FTUsrName END AS FTDocCreateBy,
	 --                         ISNULL(USRL.FNLngID, 1) AS FNUsrLngID
    --DROP TABLE #TFCTRptCrdTemp
    SELECT * INTO #TFCTRptCrdTemp FROM TFCTRptCrdTmp WHERE FTComName = '' + @nComName + ''  AND FTRptName = '' + @tRptName + ''
	TRUNCATE TABLE #TFCTRptCrdTemp
	--SELECT * FROM #TFCTRptCrdTmp

	SET @tSql ='INSERT INTO #TFCTRptCrdTemp WITH (ROWLOCK) ' --เพิ่มข้อมูลใหม่ที่ Contion ลง Temp
	SET @tSql +=' ('
	SET @tSql +=' FTComName,FTRptName,FTTxndocType, FTCrdCode, FTCrdName, FTShpCode, FTShpName, '
	SET @tSql +=' FTTxnPosCode, FTPosType, FTTxnDocRefNo, FTTxnDocNoRef, FTTxnDocTypeName,FNTxnID,FNTxnIDRef, '
	SET @tSql +=' FTDocCreateBy, FDTxnDocDate, FCCrdBalance, FNLngID, FCTxnValue, FTCtyCode, FTCtyName'
	SET @tSql +=' ) '--SELECT * FROM #TFCTRptCrdTmp WITH (NOLOCK)'
	SET @tSql += ' SELECT '''+ @nComName + '''  AS FTComName, '''+ @tRptName +'''AS FTRptName,'
	SET @tSql += ' A.FTTxnDocType,A.FTCrdCode, A.FTCrdName,A.FTShpCode,A.FTShpName,A.FTTxnPosCode,A.FTPosType,'''' AS FTTxnDocRefNo, A.FTTxnDocNoRef,A.FTTxnDocTypeName,'
	SET @tSql += ' A.FNTxnID,A.FNTxnIDRef,'
	
	--SET @tSql += ' CASE WHEN A.FTTxnDocType = 3 THEN A.FTTxnPosCode WHEN A.FTTxnDocType = 4 THEN A.FTTxnPosCode WHEN A.FTTxnDocType = 5 THEN A.FTTxnPosCode ELSE USRL.FTUsrName END AS FTDocCreateBy,'
	SET @tSql += ' ISNULL(USRL.FTUsrName,A.FTUsrCreate) AS FTDocCreateBy, '
	
	SET @tSql += ' A.FDTxnDocDate,'
	SET @tSql += ' A.FCCrdBalance,''' +  CAST(@nLngID  AS VARCHAR(10)) + ''' AS FNLngID, A.FCTxnValue, A.FTCtyCode, A.FTCtyName '
	--SET @tSql += ' FROM (SELECT  CRDHIS.FTTxnDocNoRef, CRDHIS.FTShpCode, CRDHIS.FTShpName, CRDHIS.FTTxnPosCode,  CRDHIS.FTPosType, '
	SET @tSql += ' FROM (SELECT DISTINCT CRDHIS.FTTxnDocNoRef, CRDHIS.FTShpCode, CRDHIS.FTShpName, CRDHIS.FTTxnPosCode,  CRDHIS.FTPosType, '	--*Em 63-12-29
	SET @tSql += ' CRDHIS.FTTxnDocType, CRDHIS.FTCrdCode,    CRDHIS.FTCrdStaActive, CRDHIS.FDTxnDocDate, '
	SET @tSql += ' CRDHIS.FDCrdExpireDate,  CRDHIS.FCTxnValue,  CRDHIS.FTCrdName, CRDHIS.FCCrdBalance, '
	SET @tSql += ' CRDHIS.FTTxnDocTypeName ,'
	SET @tSql += ' CRDHIS.FNTxnID,CRDHIS.FNTxnIDRef,'
	SET @tSql += ' ISNULL(TOPUP.FTCreateBy, '''') + ISNULL(VOID.FTCreateBy, '''') + ISNULL(IMP.FTCreateBy, '''') + ISNULL(SHIFT.FTCreateBy, '''') + ISNULL(SALE.FTCreateBy,'''') AS FTUsrCreate'
	SET @tSql += ' ,CRDHIS.FTCtyCode,CRDHIS.FTCtyName '
	SET @tSql += ' FROM  (SELECT  C.FTBchCode, ISNULL(C.FTTxnDocNoRef, ''N/A'') AS FTTxnDocNoRef, C.FTShpCode, SHPL.FTShpName, C.FTTxnPosCode,  '
	SET @tSql += ' CASE WHEN POS.FTPosType = 1 THEN ''จุดขาย/ร้านค้า;Pos/Store'' WHEN POS.FTPosType = 2 THEN ''จุดเติมเงิน;Topup'' WHEN POS.FTPosType = 3 THEN ''จุดตรวจสอบมูลค่า;Check Point'' ELSE ''ระบบหลังบ้าน;Back Office'''
	SET @tSql += ' END AS FTPosType,  C.FTTxnDocType,  C.FTCrdCode,  '
	SET @tSql += ' CRD.FTCrdStaActive, C.FNTxnID,C.FNTxnIDRef,'
	SET @tSql += ' CONVERT(VARCHAR(19), C.FDTxnDocDate, 121) AS FDTxnDocDate, ISNULL(CONVERT(VARCHAR(19), CRD.FDCrdExpireDate, 121), ''N/A'') AS FDCrdExpireDate, '
	SET @tSql += '  ISNULL(C.FCTxnValue, 0) AS FCTxnValue, ISNULL(C.FCTxnCrdValue, 0) AS FCTxnCrdValue,  ISNULL(CRDL.FTCrdName, ''N/A'') AS FTCrdName, ISNULL(CrdBal.FCCrdValue, 0) AS FCCrdBalance, '

	SET @tSql += ' CASE WHEN C.FTTxnDocType = 1 THEN ''เติมเงิน;Topup'' WHEN C.FTTxnDocType = ''2'' THEN ''ยกเลิกเติมเงิน;Cancel Topup'' WHEN C.FTTxnDocType = ''3'' THEN ''ตัดจ่าย/ขาย;Sale'' WHEN C.FTTxnDocType'
	SET @tSql += ' = ''4'' THEN ''ยกเลิกตัดจ่าย;Cancel Sale'' WHEN C.FTTxnDocType = ''5'' THEN ''แลกคืน;Pay Back'' WHEN C.FTTxnDocType = ''6'' THEN ''เบิกบัตร;Card Requisition'' WHEN C.FTTxnDocType = ''7'' THEN ''คืนบัตร;Card Return'''
	SET @tSql += ' WHEN C.FTTxnDocType = ''8'' THEN ''โอนเงินออก'' WHEN C.FTTxnDocType = ''9'' THEN ''โอนเงินเข้า'' WHEN C.FTTxnDocType = ''10'' THEN ''ล้างบัตร;Clear Card'' WHEN C.FTTxnDocType = ''11'' THEN ''ปรับสถานะ;Card Change Status'''
	SET @tSql += ' WHEN C.FTTxnDocType = ''12'' THEN ''บัตรใหม่;New Card'' ELSE ''ไม่ระบุ;Unknown'' END AS FTTxnDocTypeName'
	SET @tSql += ' ,CRD.FTCtyCode,CTYL.FTCtyName '
	SET @tSql += ' FROM'
	SET @tSql += ' (SELECT Demo.FTBchCode, FTTxnDocNoRef,  FTTxnDocType,  FTCrdCode, FDTxnDocDate,  FCTxnValue, FCTxnCrdValue, Demo.FTShpCode, '
	SET @tSql += ' FTTxnPosCode,FNTxnID,FNTxnIDRef '
	SET @tSql += ' FROM  dbo.TFNTCrdHis Demo WITH (NOLOCK) '
	SET @tSql += ' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON Demo.FTShpCode = Shp.FTShpCode' 
	SET @tSql += @tSql1

	SET @tSql += ' UNION ALL '
	SET @tSql += ' SELECT Demo.FTBchCode, FTTxnDocNoRef,  FTTxnDocType,  FTCrdCode, FDTxnDocDate, FCTxnValue, FCTxnCrdValue, Demo.FTShpCode, '
	SET @tSql += ' FTTxnPosCode,FNTxnID,FNTxnIDRef '
	SET @tSql += ' FROM  dbo.TFNTCrdHisBch Demo WITH (NOLOCK) '
	SET @tSql += ' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON Demo.FTShpCode = Shp.FTShpCode' 
	SET @tSql += @tSql1

	SET @tSql += ' UNION ALL '
	SET @tSql += ' SELECT Demo.FTBchCode, FTTxnDocNoRef,   FTTxnDocType,  FTCrdCode, FDTxnDocDate,  FCTxnValue, FCTxnCrdValue, Demo.FTShpCode, '
	SET @tSql += ' FTTxnPosCode ,FNTxnID,FNTxnIDRef '
	SET @tSql += ' FROM  dbo.TFNTCrdTopUp Demo WITH (NOLOCK) '
	SET @tSql += ' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON Demo.FTShpCode = Shp.FTShpCode' 
	SET @tSql += @tSql1
	SET @tSql += ' AND Demo.FTTxnDocType <> ''5'' ' --*Napat(Jame) 20-09-65 เอาข้อมูล Type 5 จาก TFNTCrdSale แทน
                                                              
	SET @tSql += ' UNION ALL'
	SET @tSql += ' SELECT Demo.FTBchCode, FTTxnDocNoRef,   FTTxnDocType,  FTCrdCode, FDTxnDocDate,  FCTxnValue, FCTxnCrdValue, Demo.FTShpCode, '
	SET @tSql += ' FTTxnPosCode,FNTxnID,FNTxnIDRef  '
	SET @tSql += ' FROM dbo.TFNTCrdSale Demo WITH (NOLOCK) '
	SET @tSql += ' LEFT JOIN TCNMShop Shp WITH (NOLOCK) ON Demo.FTShpCode = Shp.FTShpCode' 
	SET @tSql += @tSql1

	SET @tSql += ' ) AS C LEFT OUTER JOIN'
	SET @tSql += ' dbo.TFNMCard AS CRD WITH (NOLOCK) ON C.FTCrdCode = CRD.FTCrdCode LEFT OUTER JOIN'
	--NUI 2020-12-22
			SET @tSql += ' (SELECT FTCrdCode,'
			SET @tSql += ' SUM(CASE  FTCrdTxnCode' 
			SET @tSql += ' WHEN ''001'' THEN FCCrdValue'
			SET @tSql += ' WHEN ''002'' THEN FCCrdValue'
			SET @tSql += ' WHEN ''006'' THEN FCCrdValue*-1'
			SET @tSql += ' END) AS FCCrdValue'
			SET @tSql += ' FROM TFNMCardBal WITH(NOLOCK) WHERE FTCrdTxnCode IN (''001'',''002'',''006'') '
			SET @tSql += ' GROUP BY FTCrdCode) CrdBal ON  C.FTCrdCode = CrdBal.FTCrdCode'
	SET @tSql += ' LEFT JOIN dbo.TFNMCard_L AS CRDL WITH (NOLOCK) ON CRD.FTCrdCode = CRDL.FTCrdCode AND CRDL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql += ' LEFT JOIN dbo.TFNMCardType_L AS CTYL WITH (NOLOCK) ON CRD.FTCtyCode = CTYL.FTCtyCode AND CTYL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' '
	SET @tSql += ' LEFT OUTER JOIN dbo.TCNMPos AS POS WITH (NOLOCK) ON C.FTTxnPosCode = POS.FTPosCode AND C.FTBchCode = POS.FTBchCode LEFT OUTER JOIN'
	--SET @tSql += ' dbo.TFNMCardType_L AS CTL WITH (NOLOCK) ON CRD.FTCtyCode = CTL.FTCtyCode LEFT OUTER JOIN'
	SET @tSql += ' dbo.TCNMUsrDepart_L AS DPL WITH (NOLOCK) ON CRD.FTDptCode = DPL.FTDptCode AND DPL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT OUTER JOIN'
	SET @tSql += ' dbo.TCNMShop_L AS SHPL WITH (NOLOCK) ON C.FTShpCode = SHPL.FTShpCode AND C.FTBchCode = SHPL.FTBchCode AND SHPL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''' LEFT OUTER JOIN'
	SET @tSql += ' (SELECT CONVERT(VARCHAR(19), FDCrdExpireDate, 121) AS FDCrdExpireDate'
	SET @tSql += ' FROM dbo.TFNMCard WITH (NOLOCK)'
	SET @tSql += ' GROUP BY FDCrdExpireDate) AS CEXP ON CONVERT(VARCHAR(10), C.FDTxnDocDate, 121) = CONVERT(VARCHAR(10), CEXP.FDCrdExpireDate, 121) '
	
	--@tCrdTypeT = @tCrdTypeF
	IF (@tCrdTypeT <> '' AND @tCrdTypeF <> '')
	BEGIN
		SET @tSql += ' WHERE CRD.FTCtyCode BETWEEN ''' + @tCrdTypeF + ''' AND ''' + @tCrdTypeT + ''' '
	END

	SET @tSql += ' ) AS CRDHIS LEFT OUTER JOIN '
	SET @tSql += ' dbo.TFNTCrdTopUpHD AS TOPUP WITH (NOLOCK) ON CRDHIS.FTTxnDocNoRef = TOPUP.FTXshDocNo LEFT OUTER JOIN'
	SET @tSql += ' dbo.TFNTCrdVoidHD AS VOID WITH (NOLOCK) ON CRDHIS.FTTxnDocNoRef = VOID.FTCvhDocNo LEFT OUTER JOIN'
	SET @tSql += ' dbo.TFNTCrdImpHD AS IMP WITH (NOLOCK) ON CRDHIS.FTTxnDocNoRef = IMP.FTCihDocNo LEFT OUTER JOIN'
	SET @tSql += ' dbo.TFNTCrdShiftHD AS SHIFT WITH (NOLOCK) ON CRDHIS.FTTxnDocNoRef = SHIFT.FTXshDocNo'
	SET @tSql += ' LEFT OUTER JOIN dbo.TPSTSalHD AS SALE WITH (NOLOCK) ON CRDHIS.FTTxnDocNoRef = SALE.FTXshDocNo'
	SET @tSql += ') AS A LEFT OUTER JOIN'
	SET @tSql += ' dbo.TCNMUser_L AS USRL WITH (NOLOCK) ON A.FTUsrCreate = USRL.FTUsrCode AND USRL.FNLngID = ''' + CAST(@nLngID  AS VARCHAR(10)) + ''''
	--SET @tSql += ' IN TO TFCTRptCrdTmp1'
	--PRINT @tSql
	execute(@tSql)

	SET @tSqlIns = 'INSERT INTO TFCTRptCrdTmp ('
	SET @tSqlIns +=' FTComName,FTRptName,FTTxndocType, FTCrdCode, FTCrdName, FTShpCode, FTShpName,'
	SET @tSqlIns +=' FTTxnPosCode, FTPosType, FTTxnDocRefNo, FTTxnDocNoRef, FTTxnDocTypeName,'
	SET @tSqlIns +=' FTDocCreateBy, FDTxnDocDate, FCCrdBalance, FNLngID, FCTxnValue, FTCtyCode, FTCtyName'
	SET @tSqlIns +=' )'
	SET @tSqlIns +=' SELECT'
	SET @tSqlIns +=' FTComName,FTRptName,FTTxndocType, FTCrdCode, FTCrdName, FTShpCode, FTShpName,'
	SET @tSqlIns +=' FTTxnPosCode, FTPosType, FTDocRef AS FTTxnDocRefNo, FTTxnDocNoRef, FTTxnDocTypeName,'
	SET @tSqlIns +=' FTDocCreateBy, FDTxnDocDate, FCCrdBalance, FNLngID, FCTxnValue, FTCtyCode, FTCtyName'
	SET @tSqlIns +=' FROM #TFCTRptCrdTemp'
	SET @tSqlIns +=' LEFT JOIN ('
	SET @tSqlIns +=' SELECT R1.FNTxnIDRef , R2.FTTxnDocNoRef AS FTDocRef FROM ('
	SET @tSqlIns +=' SELECT FNTxnIDRef FROM TFNTCrdHis WHERE ISNULL(FNTxnIDRef,'''') <> '''''
	--SET @tSqlIns += @tSql2
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FNTxnIDRef FROM TFNTCrdHisBch WHERE ISNULL(FNTxnIDRef,'''') <> '''''
	--SET @tSqlIns += @tSql2
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FNTxnIDRef FROM TFNTCrdTopUp WHERE ISNULL(FNTxnIDRef,'''' ) <> '''''
	--SET @tSqlIns += @tSql2
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FNTxnIDRef FROM TFNTCrdSale WHERE ISNULL(FNTxnIDRef,'''') <> '''''
--	SET @tSqlIns += @tSql2
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' ) R1'
	SET @tSqlIns +=' INNER JOIN ('
	SET @tSqlIns +=' SELECT FTTxnDocNoRef,FNTxnID FROM TFNTCrdHis'
	SET @tSqlIns +=' WHERE 1 = 1'
--	SET @tSqlIns += @tSql2
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FTTxnDocNoRef,FNTxnID FROM TFNTCrdHisBch'
	SET @tSqlIns +=' WHERE 1 = 1'
	--SET @tSqlIns += @tSql2
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	/*SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FTTxnDocNoRef,FNTxnID FROM TFNTCrdTopUp'
	SET @tSqlIns +=' WHERE 1 = 1'
	--SET @tSqlIns += @tSql2
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END*/

	SET @tSqlIns +=' UNION ALL'
	SET @tSqlIns +=' SELECT FTTxnDocNoRef,FNTxnID FROM TFNTCrdSale'
	SET @tSqlIns +=' WHERE 1 = 1'
--	SET @tSqlIns += @tSql2
	IF (@tDocDateF <> '' AND @tDocDateT <> '')
	BEGIN
		SET @tSqlIns += ' AND CONVERT(VARCHAR(10), FDTxnDocDate, 121) BETWEEN ''' + @tDocDateF + ''' AND ''' + @tDocDateT + ''''
	END

	SET @tSqlIns +=' ) R2 ON R1.FNTxnIDRef = R2.FNTxnID  ) REF ON REF.FNTxnIDRef = #TFCTRptCrdTemp.FNTxnIDRef'
 	--PRINT @tSqlIns
	--RETURN
	execute(@tSqlIns)
	
-- 	PRINT @tSql
	DROP TABLE #TFCTRptCrdTemp
--	--SELECT * FROM #TFCTRptCrdTmp
	RETURN SELECT * FROM TFCTRptCrdTmp WHERE FTComName = ''+ @nComName + '' AND FTRptName = ''+ @tRptName +''
--	----EXECUTE @tSqlIns
	
END TRY

BEGIN CATCH 
 SET @FNResult= -1
END CATCH