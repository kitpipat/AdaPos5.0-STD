<?php
defined('BASEPATH') or exit('No direct script access allowed');

class mTaxinvoicefc extends CI_Model{

    // public $tDocno     = '';
    //ข้อมูลใบกำกับภาษีอย่างย่อ แบบเลือก
    public function FSaMTXFGetListABB($paData){
        $aRowLen    = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
        $nLngID     = $paData['FNLngID'];
        $tSQL       = "SELECT c.* FROM(
                        SELECT  ROW_NUMBER() OVER(ORDER BY FDXshDocDate DESC) AS FNRowID,* FROM
                            (SELECT DISTINCT
                                TaxHD.FTXshDocNo,
                                FDXshDocDate,
                                TaxHD.FTBchCode,
                                FTPosCode,
                                TaxAdd.FTAddName AS FTAddName,
								FTXshStaDoc AS FTXshStaDoc
                               
                            FROM TPSTTaxHD TaxHD WITH (NOLOCK)
                            LEFT JOIN TPSTTaxHDCst HDCst WITH (NOLOCK) ON TaxHD.FTXshDocno = HDCst.FTXshDocno AND TaxHD.FTBchCode = HDCST.FTBchCode 
                            LEFT JOIN TCNMTaxAddress_L TaxAddr WITH (NOLOCK) ON HDCst.FTXshAddrTax = TaxAddr.FNAddSeqNo
                            INNER JOIN TPSTTaxHDAddress TaxAdd WITH ( NOLOCK ) ON TaxHD.FTXshDocno = TaxAdd.FTXshDocno
                            WHERE 1=1 AND ISNULL(FTXshDocVatFull,'') <> ''  ";

        // if($this->session->userdata("tSesUsrLevel") == 'BCH' || $this->session->userdata("tSesUsrLevel") == 'SHP'){
        //     $tBCH = $this->session->userdata("tSesUsrBchCom");
        //     $tSQL .= " AND  TaxHD.FTBchCode = '$tBCH' ";
        // }

        if ($this->session->userdata('tSesUsrLevel') != "HQ") { // ไม่ใช่ผู้ใช้ระดับ HQ ดูได้แค่สาขาที่ login
            $tBchCode = $this->session->userdata('tSesUsrBchCodeMulti');
            $tSQL .= "
                AND TaxHD.FTBchCode IN ($tBchCode)
            ";
        }

        //ค้นหาแบบพิเศษ
        @$tSearchList = $paData['tSearchAll'];
        $tSQL .= "  AND (
                        (TaxHD.FTXshDocNo LIKE '%$tSearchList%') 
                        OR (TaxHD.FDXshDocDate LIKE '%$tSearchList%') 
                        OR (TaxHD.FTPosCode LIKE '%$tSearchList%') 
                        OR (HDCst.FTXshCstName LIKE '%$tSearchList%') 
                        OR (CONVERT(CHAR(10),TaxHD.FDXshDocDate,120) = '$tSearchList')
                    )";
        
        
        $tSQL .= ") Base) AS c WHERE c.FNRowID > $aRowLen[0] AND c.FNRowID <= $aRowLen[1]";
        $oQuery = $this->db->query($tSQL);

        // echo $this->db->last_query();
        // die();

        if($oQuery->num_rows() > 0){
            $oList      = $oQuery->result();
            $aFoundRow  = $this->FSnMTXFGetListABBPageAll($paData);
            $nFoundRow  = $aFoundRow[0]->counts;
            $nPageAll   = ceil($nFoundRow/$paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า
            $aResult    = array(
                'raItems'       => $oList,
                'rnAllRow'      => $nFoundRow,
                'rnCurrentPage' => $paData['nPage'],
                'rnAllPage'     => $nPageAll,
                'rtCode'        => '1',
                'rtDesc'        => 'success'
            );
        }else{
            $aResult = array(
                'rnAllRow'      => 0,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage"     => 0,
                'rtCode'        => '800',
                'rtDesc'        => 'data not found'
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //จำนวนใบกำกับภาษีอย่างย่อ แบบเลือก
    public function FSnMTXFGetListABBPageAll($paData){

        $nLngID = $paData['FNLngID'];
        $tSQL   = " SELECT COUNT (TaxHD.FTXshDocNo) AS counts
                    FROM TPSTTaxHD TaxHD WITH (NOLOCK) 
                    LEFT JOIN TPSTTaxHDCst HDCst WITH (NOLOCK) ON TaxHD.FTXshDocno = HDCst.FTXshDocno AND TaxHD.FTBchCode = HDCst.FTBchCode 
                    LEFT JOIN TCNMTaxAddress_L TaxAddr WITH (NOLOCK) ON HDCst.FTXshAddrTax = TaxAddr.FNAddSeqNo
                    WHERE 1=1 AND ISNULL(FTXshDocVatFull,'') <> ''  ";

        // if($this->session->userdata("tSesUsrLevel") == 'BCH' || $this->session->userdata("tSesUsrLevel") == 'SHP'){
        //     $tBCH = $this->session->userdata("tSesUsrBchCom");
        //     $tSQL .= " AND  TaxHD.FTBchCode = '$tBCH' ";
        // }
        if ($this->session->userdata('tSesUsrLevel') != "HQ") { // ไม่ใช่ผู้ใช้ระดับ HQ ดูได้แค่สาขาที่ login
            $tBchCode = $this->session->userdata('tSesUsrBchCodeMulti');
            $tSQL .= "
                AND TaxHD.FTBchCode IN ($tBchCode)
            ";
        }
        //ค้นหาแบบพิเศษ
        @$tSearchList = $paData['tSearchAll'];
        $tSQL .= "  AND (
                        (TaxHD.FTXshDocNo LIKE '%$tSearchList%') 
                        OR (TaxHD.FDXshDocDate LIKE '%$tSearchList%') 
                        OR (TaxHD.FTPosCode LIKE '%$tSearchList%') 
                        OR (HDCst.FTXshCstName LIKE '%$tSearchList%') 
                        OR (CONVERT(CHAR(10),TaxHD.FDXshDocDate,120) = '$tSearchList')
                    )";

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //ข้อมูลใบกำกับภาษีอย่างย่อ แบบเลือก
    public function FSaMTXFListABB($paData){
        $aRowLen    = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
        $nLngID     = $paData['FNLngID'];
        $tSQL       = "SELECT c.* FROM(
                        SELECT  ROW_NUMBER() OVER(ORDER BY FTXshDocNo DESC) AS FNRowID,* FROM
                                (SELECT DISTINCT
                                    BCHL.FTBchName,
                                    TUHD.FTXshDocNo,
                                    TUHD.FNXshDocType,
                                    TUHD.FDXshDocDate,
                                    TUHD.FTPosCode,
                                    '' AS FTUsrName,
                                    POSL.FTPosName
                                    FROM
                                    TFNTCrdTopUpHD TUHD
                                    LEFT JOIN TCNMBranch_L BCHL WITH (NOLOCK) ON TUHD.FTBchCode = BCHL.FTBchCode AND BCHL.FNLngID = $nLngID
                                    LEFT JOIN TCNMPos_L POSL WITH (NOLOCK) ON TUHD.FTBchCode = POSL.FTBchCode AND TUHD.FTPosCode = POSL.FTPosCode AND POSL.FNLngID = $nLngID
                                    WHERE
                                    TUHD.FNXshDocType = 11
                                    AND ISNULL(TUHD.FTXshRefInt,'') =''
                                    AND ISNULL(TUHD.FTXshStaApv,'') ='1'
                                    ";

        //ค้นหาตามสาขา
        @$tBCH       = $paData['tBCH'];
        if($tBCH != '' || $tBCH != null){
            $tSQL .= "  AND (( TUHD.FTBchCode = '$tBCH')) ";
        }

        //ค้นหาแบบพิเศษ
        @$tFilter       = $paData['tFilter'];
        @$tSearchList   = trim($paData['tSearchABB']);
        switch ($tFilter) {
            case "2": //ทั้งหมด
                $tSQL .= "  AND (
                                (TUHD.FTXshDocNo LIKE '%$tSearchList%') 
                                OR (BCHL.FTBchCode LIKE '%$tSearchList%') 
                                OR (BCHL.FTBchName LIKE '%$tSearchList%') 
                                OR (TUHD.FTPosCode LIKE '%$tSearchList%') 
                                OR (CONVERT(CHAR(10),TUHD.FDXshDocDate,120) = '$tSearchList')
                            )";
                break;
            case "3": //เลขที่
                $tSQL .= "  AND ((TUHD.FTXshDocNo = '$tSearchList'))";
                break;
            default:
        }

        $tTextDateABB   = trim($paData['tTextDateABB']);
        $tSQL .= "  AND ( (CONVERT(CHAR(10),TUHD.FDXshDocDate,120) = '$tTextDateABB') )";

        $tSQL .= ") Base) AS c WHERE c.FNRowID > $aRowLen[0] AND c.FNRowID <= $aRowLen[1]";

        $oQuery = $this->db->query($tSQL);
        if($oQuery->num_rows() > 0){
            $oList      = $oQuery->result();
            $aFoundRow  = $this->FSnMTXFGetPageAll($paData);
            $nFoundRow  = $aFoundRow[0]->counts;
            $nPageAll   = ceil($nFoundRow/$paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า
            $aResult    = array(
                'raItems'       => $oList,
                'rnAllRow'      => $nFoundRow,
                'rnCurrentPage' => $paData['nPage'],
                'rnAllPage'     => $nPageAll,
                'rtCode'        => '1',
                'rtDesc'        => 'success',
                'tSQL'          => $tSQL
            );
        }else{
            $aResult = array(
                'rnAllRow'      => 0,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage"     => 0,
                'rtCode'        => '800',
                'rtDesc'        => 'data not found',
                'tSQL'          => $tSQL
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //จำนวนใบกำกับภาษีอย่างย่อ แบบเลือก
    public function FSnMTXFGetPageAll($paData){

        $nLngID = $paData['FNLngID'];
        $tSQL   = " SELECT COUNT (TUHD.FTXshDocNo) AS counts
                    FROM  TFNTCrdTopUpHD TUHD WITH (NOLOCK) 
                    LEFT JOIN TCNMBranch_L  BCHL WITH (NOLOCK) ON TUHD.FTBchCode = BCHL.FTBchCode AND BCHL.FNLngID = $nLngID 
                    WHERE  TUHD.FNXshDocType = 11
                     ";

        //ค้นหาตามสาขา
        @$tBCH       = $paData['tBCH'];
        if($tBCH != '' || $tBCH != null){
            $tSQL .= "  AND (( TUHD.FTBchCode = '$tBCH')) ";
        }

        //ค้นหาแบบพิเศษ
        @$tFilter       = $paData['tFilter'];
        @$tSearchList   = trim($paData['tSearchABB']);
        switch ($tFilter) {
            case "2": //ทั้งหมด
                $tSQL .= "  AND (
                                  (TUHD.FTXshDocNo LIKE '%$tSearchList%') 
                                OR (BCHL.FTBchCode LIKE '%$tSearchList%') 
                                OR (BCHL.FTBchName LIKE '%$tSearchList%') 
                                OR (TUHD.FTPosCode LIKE '%$tSearchList%') 
                                OR (CONVERT(CHAR(10),TUHD.FDXshDocDate,120) = '$tSearchList')
                            )";
                break;
            case "3": //เลขที่
                $tSQL .= "  AND (TUHD.FTXshDocNo = '$tSearchList')";
                break;
            default:
        }

        $tTextDateABB   = trim($paData['tTextDateABB']);
        $tSQL .= "  AND ( (CONVERT(CHAR(10),TUHD.FDXshDocDate,120) = '$tTextDateABB') )";

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //ค้นหารหัสใบกำกับภาษีอย่างย่อ แบบคีย์
    public function FSaMTXFCheckABBNumber($ptDocumentnumber,$tBCH){
        $nLngID = $this->session->userdata("tLangEdit");
        $tSQL   = "SELECT FTBchCode,FTXshDocNo FROM TFNTCrdTopUpHD TOPHD
                   WHERE 1=1 AND TOPHD.FTXshDocNo = '$ptDocumentnumber'  ";
        
        //ค้นหาตามสาขา
        @$tBCH       = $tBCH;
        if($tBCH != '' || $tBCH != null){
            $tSQL .= "  AND ( TOPHD.FTBchCode = '$tBCH') ";
        }

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //ข้อมูลการขาย DT
    // public function FSaMTXFGetDT($paData){
    //     $aRowLen            = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
    //     $tDocumentNumber    = $paData['tDocumentNumber'];
    //     $tBrowseBchCode    = $paData['tBrowseBchCode'];
    //     $tSQL       = "SELECT c.* FROM(
    //                     SELECT  ROW_NUMBER() OVER(ORDER BY FTXshDocNo DESC) AS FNRowID,* FROM
    //                         (SELECT DISTINCT
    //                                 CASE WHEN SALHD.FNXshDocType = 9 THEN DTDis.DISPMT *-(1) ELSE DTDis.DISPMT END DISPMT  ,
    //                                  TOPUPDT.FTCrdCode,TOPUPDT.FDCrdResetDate,SALHD.FDXshDocDate, 
    //                                 SALDT.FTBchCode , SALDT.FTXshDocNo , SALDT.FNXsdSeqNo , FTPdtCode , FTXsdPdtName ,
    //                                 FTPunCode , FTPunName , FCXsdFactor , FTXsdBarCode , FTSrnCode ,
    //                                 FTXsdVatType , FTVatCode , FTPplCode , FCXsdVatRate , FTXsdSaleType ,
    //                                 FCXsdSalePrice , 
    //                                 CASE WHEN SALHD.FNXshDocType = 9 THEN FCXsdQty *-(1) ELSE FCXsdQty END FCXsdQty ,
    //                                  FCXsdQtyAll , FCXsdSetPrice , FCXsdAmtB4DisChg ,
    //                                 FTXsdDisChgTxt ,
    //                                 CASE WHEN SALHD.FNXshDocType = 9 THEN FCXsdDis *-(1)  ELSE  FCXsdDis END FCXsdDis ,
    //                                 CASE WHEN SALHD.FNXshDocType = 9 THEN  FCXsdChg *-(1) ELSE FCXsdChg END FCXsdChg, 
    //                                 CASE WHEN SALHD.FNXshDocType = 9  THEN FCXsdNet *-(1) ELSE FCXsdNet END FCXsdNet  , 
    //                                   FCXsdNetAfHD ,
    //                                 FCXsdVat , FCXsdVatable , FCXsdWhtAmt , FTXsdWhtCode , FCXsdWhtRate ,
    //                                 FCXsdCostIn , FCXsdCostEx , FTXsdStaPdt , FCXsdQtyLef , FCXsdQtyRfn ,
    //                                 FTXsdStaPrcStk , FTXsdStaAlwDis , FNXsdPdtLevel , FTXsdPdtParent , FCXsdQtySet ,
    //                                 FTPdtStaSet , FTXsdRmk , SALDT.FDLastUpdOn , SALDT.FTLastUpdBy , SALDT.FDCreateOn , SALDT.FTCreateBy
    //                         FROM TPSTSalDT SALDT WITH (NOLOCK)
    //                         LEFT JOIN ( SELECT SUM(FCXddValue) as DISPMT , FNXsdSeqNo , FTBchCode ,FTXshDocNo FROM TPSTSalDTDis 
    //                                     WHERE  FTXddDisChgType IN ('1','2') 
                                        
    //                                     GROUP BY FNXsdSeqNo , FTBchCode ,FTXshDocNo
    //                                 ) DTDis ON DTDis.FNXsdSeqNo = SALDT.FNXsdSeqNo AND DTDis.FTBchCode = SALDT.FTBchCode AND  DTDis.FTXshDocNo = SALDT.FTXshDocNo
    //                         LEFT JOIN (
    //                                     SELECT DISTINCT FTBchCode , FTXshDocNo , MIN(FTXrcRefNo1) AS FTXrcRefNo1
    //                                     FROM 
    //                                     TPSTSalRC 
    //                                     LEFT JOIN  TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
    //                                     WHERE TFNMRcv.FTFmtCode = '011'
    //                                     GROUP BY FTBchCode,FTXshDocNo
    //                                     ) SRC  ON SRC.FTXshDocNo = SALDT.FTXshDocNo AND SRC.FTBchCode = SALDT.FTBchCode
    //                         LEFT JOIN (
    //                                     SELECT DISTINCT
    //                                         TFNTCrdTopUpDT.FTBchCode,
    //                                         TFNTCrdTopUpDT.FTCrdCode,
    //                                         TFNTCrdTopUpDT.FTXshDocNo,
    //                                         TFNMCard.FDCrdResetDate
    //                                     FROM
    //                                         TFNTCrdTopUpDT
    //                                     LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
    //                                    ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
    //                         LEFT JOIN TPSTSalHD SALHD WITH (NOLOCK) ON SALHD.FTBchCode = SALDT.FTBchCode AND SALHD.FTXshDocNo = SALDT.FTXshDocNo
    //                         WHERE 1=1 AND TOPUPDT.FTBchCode = '$tBrowseBchCode' AND TOPUPDT.FTXshDocNo = '$tDocumentNumber' AND ISNULL(SALHD.FTXshDocVatFull,'') = ''  AND SALHD.FDXshDocDate>TOPUPDT.FDCrdResetDate ";

    //     //ค้นหาแบบพิเศษ
    //     @$tSearchPDT   = $paData['tSearchPDT'];
    //     $tSQL .= "  AND ((SALDT.FTXshDocNo LIKE '%$tSearchPDT%') 
    //                     OR (SALDT.FTPdtCode LIKE '%$tSearchPDT%') 
    //                     OR (SALDT.FTXsdPdtName LIKE '%$tSearchPDT%') 
    //                     OR (SALDT.FTPunName LIKE '%$tSearchPDT%') 
    //                     OR (SALDT.FTXsdBarCode LIKE '%$tSearchPDT%') 
    //                     OR (SALDT.FCXsdQty LIKE '%$tSearchPDT%') 
    //                     OR (SALDT.FCXsdSetPrice LIKE '%$tSearchPDT%') 
    //                     OR (SALDT.FCXsdNetAfHD LIKE '%$tSearchPDT%') 
    //                     OR (SALDT.FTBchCode LIKE '%$tSearchPDT%')
    //                 )";

    //     $tSQL .= ") Base) AS c WHERE c.FNRowID > $aRowLen[0] AND c.FNRowID <= $aRowLen[1]";

    //     $oQuery = $this->db->query($tSQL);


    //     // echo $this->db->last_query();
    //     // die();
    //     if($oQuery->num_rows() > 0){
    //         $oList      = $oQuery->result();
    //         $aFoundRow  = $this->FSnMTXFGetDTPageAll($paData);
    //         $nFoundRow  = $aFoundRow[0]->counts;
    //         $nPageAll   = ceil($nFoundRow/$paData['nRow']);
    //         $aResult    = array(
    //             'raItems'       => $oList,
    //             'rnAllRow'      => $nFoundRow,
    //             'rnCurrentPage' => $paData['nPage'],
    //             'rnAllPage'     => $nPageAll,
    //             'rtCode'        => '1',
    //             'rtDesc'        => 'success'
    //         );
    //     }else{
    //         $aResult = array(
    //             'rnAllRow'      => 0,
    //             'rnCurrentPage' => $paData['nPage'],
    //             "rnAllPage"     => 0,
    //             'rtCode'        => '800',
    //             'rtDesc'        => 'data not found'
    //         );
    //     }
    //     $jResult = json_encode($aResult);
    //     $aResult = json_decode($jResult, true);
    //     return $aResult;
    // }

        //ข้อมูลการขาย DT Edit By IcePHP 20/09/2022
        public function FSaMTXFGetDT($paData){
            $aRowLen            = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
            $tDocumentNumber    = $paData['tDocumentNumber'];
            $tBrowseBchCode     = $paData['tBrowseBchCode'];
    
            $tSQLDocDate        = "SELECT FDXshDocDate FROM TFNTCrdTopUpHD
                                        WHERE FTXshDocNo = '" . $paData['tDocumentNumber'] ."'";
    
            $oQueryDocDate      = $this->db->query($tSQLDocDate);
            if($oQueryDocDate->num_rows() > 0){
                $oDocDate       = $oQueryDocDate->result();
            }
            $tDocDate           = $oDocDate[0]->FDXshDocDate;
    
            $tSQLCrdCode        = "SELECT FTCrdCode FROM TFNTCrdTopUpDT
                                    WHERE FTXshDocNo = '" . $paData['tDocumentNumber'] ."'";
    
            $oQueryCrdCode      = $this->db->query($tSQLCrdCode);
            if($oQueryCrdCode->num_rows() > 0){
                $oCrdCode       = $oQueryCrdCode->result();
            }
            // $tCrdCode           = $oCrdCode[0]->FTCrdCode;
            // print_r($oCrdCode);
    
            $tSQL       = " SELECT ROW_NUMBER() OVER(ORDER BY FTXshDocNo DESC) AS FNRowID, S.FTPdtCode , S.FTXsdPdtName, S.FTPunName, S.FCXsdQty, S.FCXsdAmtB4DisChg, S.FCXsdDis , S.FCXsdNet, 
                                S.FCXrcNet AS FCXrcNet , S.FTXshDocNo, S.FCXshTotal, S.FCXshVat, S.FCXshGrand 
                            FROM (
                                SELECT c.* FROM(
                                    SELECT  ROW_NUMBER() OVER(ORDER BY FTXshDocNo DESC) AS FNRowID,* FROM
                                    ( ";
    
            for($i = 0; $i < count($oCrdCode); $i++) {
                $tUnion = ($i == 0) ? '' : ' UNION ';
                $tSQL .= $tUnion."SELECT DT.FTPdtCode , DT.FTXsdPdtName, DT.FTPunName,
                                    CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdQty *-(1)  ELSE  DT.FCXsdQty END AS FCXsdQty ,
                                    CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdAmtB4DisChg *-(1)  ELSE  DT.FCXsdAmtB4DisChg END  AS FCXsdAmtB4DisChg ,
                                    CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdDis *-(1)  ELSE  DT.FCXsdDis END AS FCXsdDis ,
                                    CASE WHEN HD.FNXshDocType = 9 THEN DT.FCXsdNet *-(1)  ELSE  DT.FCXsdNet END AS FCXsdNet ,
                                    CASE WHEN HD.FNXshDocType = 9 THEN RC.FCXrcNet *-(1)  ELSE  RC.FCXrcNet END  AS FCXrcNet ,
                                    DT.FTXshDocNo,
                                    CASE WHEN HD.FNXshDocType = 9 THEN HD.FCXshTotal *-(1)  ELSE  HD.FCXshTotal END FCXshTotal ,
                                    CASE WHEN HD.FNXshDocType = 9 THEN HD.FCXshVat *-(1)  ELSE  HD.FCXshVat END FCXshVat ,
                                    CASE WHEN HD.FNXshDocType = 9 THEN HD.FCXshGrand *-(1)  ELSE  HD.FCXshGrand END FCXshGrand 
                            FROM TPSTSalDT DT 
                            INNER JOIN TPSTSalRC RC WITH(NOLOCK) ON DT.FTBchCode = RC.FTBchCode AND DT.FTXshDocNo = RC.FTXshDocNo
                            INNER JOIN TPSTSalHD HD WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
                            LEFT JOIN (
                                SELECT FTXshDocNo,FNXsdSeqNo , SUM(
                                    CASE WHEN FTXddDisChgType = '3' OR  FTXddDisChgType = '4' 
                                    THEN  FCXddValue * 1 ELSE FCXddValue * -1 END ) AS FCXsdDis   
                                FROM TPSTSalDTDis   WITH(NOLOCK)
                                GROUP BY FTXshDocNo,FNXsdSeqNo
                            ) DIS ON DT.FTXshDocNo = DIS.FTXshDocNo AND DT.FNXsdSeqNo = DIS.FNXsdSeqNo
                            WHERE HD.FTXshStaDoc = 1
                            AND   RC.FTXrcRefNo1 = '".$oCrdCode[$i]->FTCrdCode."' 
                            AND   HD.FDXshDocDate > ISNULL( (
                                SELECT CE.FDXshDocDate 
                                FROM (
                                    SELECT HD.FDXshDocDate, ROW_NUMBER() OVER(ORDER BY HD.FDXshDocDate DESC) AS FNTxnCESeq 
                                    FROM TFNTCrdTopUpHD  HD WITH(NOLOCK)
                                    INNER JOIN  TFNTCrdTopUpDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXshDocNo = DT.FTXshDocNo
                                    WHERE HD.FNXshDocType = 11 
                                    AND  DT.FTCrdCode = '".$oCrdCode[$i]->FTCrdCode."'  
                                    AND  HD.FDXshDocDate <=  '".$tDocDate."' 
                                ) CE
                            WHERE CE.FNTxnCESeq  = 2 ),'1999-01-01')
                            AND HD.FDXshDocDate <= '".$tDocDate."'";
            }
    
            //ค้นหาแบบพิเศษ
            @$tSearchPDT   = $paData['tSearchPDT'];
            $tSQL .= "  AND ((DT.FTXshDocNo LIKE '%$tSearchPDT%') 
                            OR (DT.FTPdtCode LIKE '%$tSearchPDT%') 
                            OR (DT.FTXsdPdtName LIKE '%$tSearchPDT%') 
                            OR (DT.FTPunName LIKE '%$tSearchPDT%') 
                            OR (DT.FTXsdBarCode LIKE '%$tSearchPDT%') 
                            OR (DT.FCXsdQty LIKE '%$tSearchPDT%') 
                            OR (DT.FCXsdSetPrice LIKE '%$tSearchPDT%') 
                            OR (DT.FCXsdNetAfHD LIKE '%$tSearchPDT%') 
                            OR (DT.FTBchCode LIKE '%$tSearchPDT%')
                        )";
    
            $tSQL .= ") Base) AS c WHERE c.FNRowID > $aRowLen[0] AND c.FNRowID <= $aRowLen[1]
                    ) S 
                ";
    
            $oQuery = $this->db->query($tSQL);
    
    
            // echo $this->db->last_query();
            // die();
            if($oQuery->num_rows() > 0){
                $oList      = $oQuery->result();
                $aFoundRow  = $this->FSnMTXFGetDTPageAll($paData);
                $nFoundRow  = $aFoundRow[0]->counts;
                $nPageAll   = ceil($nFoundRow/$paData['nRow']);
                $aResult    = array(
                    'raItems'       => $oList,
                    'rnAllRow'      => $nFoundRow,
                    'rnCurrentPage' => $paData['nPage'],
                    'rnAllPage'     => $nPageAll,
                    'rtCode'        => '1',
                    'rtDesc'        => 'success'
                );
            }else{
                $aResult = array(
                    'rnAllRow'      => 0,
                    'rnCurrentPage' => $paData['nPage'],
                    "rnAllPage"     => 0,
                    'rtCode'        => '800',
                    'rtDesc'        => 'data not found'
                );
            }
            $jResult = json_encode($aResult);
            $aResult = json_decode($jResult, true);
            return $aResult;
        }

    //หาจำนวนการขาย DT
    public function FSnMTXFGetDTPageAll($paData){
        $tDocumentNumber    = $paData['tDocumentNumber'];
        $tBrowseBchCode    = $paData['tBrowseBchCode'];
        $tSQL   = " SELECT COUNT (SALDT.FTXshDocNo) AS counts FROM TPSTSalDT SALDT WITH (NOLOCK)
        
                                LEFT JOIN (
                                        SELECT DISTINCT FTBchCode , FTXshDocNo , MIN(FTXrcRefNo1) AS  FTXrcRefNo1
                                        FROM 
                                        TPSTSalRC 
                                        LEFT JOIN  TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
                                        WHERE TFNMRcv.FTFmtCode = '011'
                                        GROUP BY FTBchCode,FTXshDocNo
                                        ) SRC  ON SRC.FTXshDocNo = SALDT.FTXshDocNo AND SRC.FTBchCode = SALDT.FTBchCode
                                      LEFT JOIN ( SELECT DISTINCT
                                            TFNTCrdTopUpDT.FTBchCode,
                                            TFNTCrdTopUpDT.FTCrdCode,
                                            TFNTCrdTopUpDT.FTXshDocNo,
                                            TFNMCard.FDCrdResetDate
                                        FROM
                                            TFNTCrdTopUpDT
                                        LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
                                       ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
                                 LEFT JOIN TPSTSalHD SALHD WITH (NOLOCK) ON SALHD.FTBchCode = SALDT.FTBchCode AND SALHD.FTXshDocNo = SALDT.FTXshDocNo
         WHERE 1=1 AND TOPUPDT.FTBchCode = '$tBrowseBchCode'  AND TOPUPDT.FTXshDocNo = '$tDocumentNumber'  AND ISNULL(SALHD.FTXshDocVatFull,'') = ''  AND SALHD.FDXshDocDate>TOPUPDT.FDCrdResetDate ";

        //ค้นหาแบบพิเศษ
        @$tSearchPDT   = $paData['tSearchPDT'];
        $tSQL   .= "  AND ((SALDT.FTXshDocNo LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTPdtCode LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTXsdPdtName LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTPunName LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTXsdBarCode LIKE '%$tSearchPDT%') 
                        OR (SALDT.FCXsdQty LIKE '%$tSearchPDT%') 
                        OR (SALDT.FCXsdSetPrice LIKE '%$tSearchPDT%') 
                        OR (SALDT.FCXsdNetAfHD LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTBchCode LIKE '%$tSearchPDT%')
                    )";

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //หาเลขเอกสารบิลขาย จากเอกสารใบคืน
    public function FSaMTXFGetDTFTXshDocNo($paData){
        $tSQLDocDate        = "SELECT FDXshDocDate FROM TFNTCrdTopUpHD
        WHERE FTXshDocNo = '" . $paData."'";

        $oQueryDocDate      = $this->db->query($tSQLDocDate);
        if($oQueryDocDate->num_rows() > 0){
            $oDocDate       = $oQueryDocDate->result();
        }
        $tDocDate           = $oDocDate[0]->FDXshDocDate;

        $tSQLCrdCode        = "SELECT FTCrdCode FROM TFNTCrdTopUpDT
                                WHERE FTXshDocNo = '" . $paData."'";

        $oQueryCrdCode      = $this->db->query($tSQLCrdCode);
        if($oQueryCrdCode->num_rows() > 0){
            $oCrdCode       = $oQueryCrdCode->result();
        }

        $tSQL = '';

        for($i = 0; $i < count($oCrdCode); $i++) {
            $tUnion = ($i == 0) ? '' : ' UNION ';
            $tSQL .= $tUnion."SELECT DISTINCT DT.FTXshDocNo
            FROM TPSTSalDT DT
            INNER JOIN TPSTSalRC RC WITH(NOLOCK) ON DT.FTBchCode = RC.FTBchCode AND DT.FTXshDocNo = RC.FTXshDocNo
            INNER JOIN TPSTSalHD HD WITH(NOLOCK) ON DT.FTBchCode = HD.FTBchCode AND DT.FTXshDocNo = HD.FTXshDocNo
            WHERE HD.FTXshStaDoc = 1
                    AND   RC.FTXrcRefNo1 = '".$oCrdCode[$i]->FTCrdCode."'  /*รหัสบัตรในเอกสาร checkout ที่จะขอใบกำกับภาษี*/
                    AND   HD.FDXshDocDate > ISNULL( (
            
                            SELECT CE.FDXshDocDate FROM (
            
                                    SELECT HD.FDXshDocDate, ROW_NUMBER() OVER(ORDER BY HD.FDXshDocDate DESC) AS FNTxnCESeq 
                                    FROM TFNTCrdTopUpHD  HD WITH(NOLOCK)
                                    INNER JOIN  TFNTCrdTopUpDT DT WITH(NOLOCK) ON HD.FTBchCode = DT.FTBchCode AND HD.FTXshDocNo = DT.FTXshDocNo
                                    WHERE HD.FNXshDocType = 11 
                                    AND  DT.FTCrdCode = '".$oCrdCode[$i]->FTCrdCode."'  
                                    AND  HD.FDXshDocDate <=  '".$tDocDate."' 
                            ) CE
                            WHERE CE.FNTxnCESeq  = 2 ),'1999-01-01')
                    AND HD.FDXshDocDate <= '".$tDocDate."'" ;
        }

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $aDocno = $oQuery->result();
            $tDocno     = '';
            for($i = 0; $i < count($aDocno); $i++) {
                $tDocno = ($i == 0) ? "'".$aDocno[$i]->FTXshDocNo."'" : $tDocno.= ",'".$aDocno[$i]->FTXshDocNo."'"  ;
            }
            // return $oQuery->result();
            return $tDocno;
        }else{
            return false;
        }
                
    }

    //ข้อมูลการขาย HD
    // public function FSaMTXFGetHD($paData){
    //     $tDocumentNumber    = $paData['tDocumentNumber'];
    //     $tBrowseBchCode    = $paData['tBrowseBchCode'];
    //     $cCmpVatRate = FCNaHVATGetActiveVatCompany()['value'];
    //     $tSQL               = "SELECT
    //                                 SALHD.FTBchCode,
    //                                 CASE WHEN SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshGrand,0) *-(1) ELSE  ISNULL(SALHD.FCXshGrand,0) END) < 0 THEN 5 WHEN SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshGrand,0) *-(1) ELSE  ISNULL(SALHD.FCXshGrand,0) END) > 0 THEN 4 ELSE 0 END FNXshDocType,
    //                                 TOPUPDT.FTXshDocNo,
    //                                 SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshTotal,0) *-(1) ELSE ISNULL(SALHD.FCXshTotal,0) END ) AS FCXshTotal,
    //                                 SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshDis,0) *-(1) ELSE ISNULL(SALHD.FCXshDis,0) END ) AS FCXshDis,
    //                                 SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshChg,0) *-(1) ELSE ISNULL(SALHD.FCXshChg,0) END ) AS FCXshChg,
    //                                 SUM(
    //                                     CASE WHEN SALHD.FNXshDocType = 9 THEN
    //                                         CASE WHEN SALHD.FTXshVATInOrEx = '1' THEN 
    //                                         ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate ) / (100 + $cCmpVatRate ) )  * -(1)
    //                                         ELSE
    //                                         ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate )  / 100 )  * -(1)
    //                                         END
    //                                     ELSE
    //                                     CASE WHEN SALHD.FTXshVATInOrEx = '1' THEN 
    //                                         ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate ) / (100 + $cCmpVatRate ) )  
    //                                         ELSE
    //                                         ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate )  / 100 )  
    //                                         END
    //                                     END
    //                                  ) FCXshVat,
    //                                 SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshGrand,0) *-(1) ELSE  ISNULL(SALHD.FCXshGrand,0) END) AS FCXshGrand
    //                                 FROM
    //                                     TPSTSalHD SALHD WITH (NOLOCK)
    //                                 LEFT JOIN ( SELECT DISTINCT FTBchCode , FTXshDocNo , MIN(FTXrcRefNo1) AS  FTXrcRefNo1
    //                                             FROM 
    //                                             TPSTSalRC 
    //                                             LEFT JOIN  TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
    //                                             WHERE TFNMRcv.FTFmtCode = '011'
    //                                             GROUP BY FTBchCode , FTXshDocNo
    //                                 ) SRC  ON SRC.FTXshDocNo = SALHD.FTXshDocNo AND SRC.FTBchCode = SALHD.FTBchCode
    //                                 LEFT JOIN ( SELECT DISTINCT
    //                                                 TFNTCrdTopUpDT.FTBchCode,
    //                                                 TFNTCrdTopUpDT.FTCrdCode,
    //                                                 TFNTCrdTopUpDT.FTXshDocNo,
    //                                                 TFNMCard.FDCrdResetDate
    //                                             FROM
    //                                                 TFNTCrdTopUpDT
    //                                              LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
    //                                 ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
    //                                 WHERE 1=1 AND  TOPUPDT.FTBchCode ='$tBrowseBchCode'	AND TOPUPDT.FTXshDocNo = '$tDocumentNumber'  AND ISNULL(FTXshDocVatFull,'') = '' AND SALHD.FDXshDocDate>TOPUPDT.FDCrdResetDate
    //                                 GROUP BY 
    //                                 SALHD.FTBchCode,
    //                                 TOPUPDT.FTXshDocNo ";
    //     $oQuery = $this->db->query($tSQL);

    //     // echo $this->db->last_query();
    //     // die();
    //     if($oQuery->num_rows() > 0){
    //         $oList      = $oQuery->result();
    //         $aResult    = array(
    //             'raItems'       => $oList,
    //             'rtCode'        => '1',
    //             'rtDesc'        => 'success'
    //         );
    //     }else{
    //         $aResult = array(
    //             'rtCode'        => '800',
    //             'rtDesc'        => 'data not found'
    //         );
    //     }
    //     $jResult = json_encode($aResult);
    //     $aResult = json_decode($jResult, true);
    //     return $aResult;
    // }

    public function FSaMTXFGetHD($paData){
        $tDocumentNumber    = $paData['tDocumentNumber'];
        $tBrowseBchCode     = $paData['tBrowseBchCode'];
        $cCmpVatRate        = FCNaHVATGetActiveVatCompany()['value'];

        $tDocno             = $this->FSaMTXFGetDTFTXshDocNo($tDocumentNumber);
        
        if($tDocno != '' && $tDocno != false) {
                       
        $tSQL               = "SELECT
                                    SALHD.FTBchCode,
                                    CASE WHEN SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshGrand,0) *-(1) ELSE  ISNULL(SALHD.FCXshGrand,0) END) < 0 THEN 5 WHEN SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshGrand,0) *-(1) ELSE  ISNULL(SALHD.FCXshGrand,0) END) > 0 THEN 4 ELSE 0 END FNXshDocType,
                                    SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshTotal,0) *-(1) ELSE ISNULL(SALHD.FCXshTotal,0) END ) AS FCXshTotal,
                                    SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshDis,0) *-(1) ELSE ISNULL(SALHD.FCXshDis,0) END ) AS FCXshDis,
                                    SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshChg,0) *-(1) ELSE ISNULL(SALHD.FCXshChg,0) END ) AS FCXshChg,
                                    SUM(
                                        CASE WHEN SALHD.FNXshDocType = 9 THEN
                                            CASE WHEN SALHD.FTXshVATInOrEx = '1' THEN 
                                            ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate ) / (100 + $cCmpVatRate ) )  * -(1)
                                            ELSE
                                            ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate )  / 100 )  * -(1)
                                            END
                                        ELSE
                                        CASE WHEN SALHD.FTXshVATInOrEx = '1' THEN 
                                            ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate ) / (100 + $cCmpVatRate ) )  
                                            ELSE
                                            ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate )  / 100 )  
                                            END
                                        END
                                        ) FCXshVat,
                                    SUM(CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshGrand,0) *-(1) ELSE  ISNULL(SALHD.FCXshGrand,0) END) AS FCXshGrand,
                                    ISNULL(SALHD.FTXshDocVatFull, '') AS FTXshDocVatFull
                                    FROM
                                        TPSTSalHD SALHD WITH (NOLOCK)
                                    WHERE 1=1 AND FTXshDocNo in ($tDocno) 
                                    GROUP BY SALHD.FTBchCode, SALHD.FTXshDocVatFull";
            $oQuery = $this->db->query($tSQL);
    
            // print_r($tSQL);
            // echo $this->db->last_query();
            // die();
            if($oQuery->num_rows() > 0){
                $oList      = $oQuery->result();
                $aResult    = array(
                    'raItems'       => $oList,
                    'rtCode'        => '1',
                    'rtDesc'        => 'success'
                );
            }else{
                $aResult = array(
                    'rtCode'        => '800',
                    'rtDesc'        => 'data not found'
                );
            }
        }else {
            $aResult = array(
                'rtCode'        => '800',
                'rtDesc'        => 'data not found'
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //หาที่อยู่ ที่ตาราง TCNMTaxAddress_L
    public function FSaMTXFFindAddress($ptCuscode){
        $nLngID = $this->session->userdata("tLangEdit");
        // $tSQL   = " SELECT ADDL.* , CSTL.FTCstName , CST.FTCstTaxNo FROM TCNMTaxAddress_L ADDL WITH (NOLOCK)
        //             LEFT JOIN TCNMCst_L CSTL ON CSTL.FTCstCode = ADDL.FTCstCode
        //             LEFT JOIN TCNMCst CST  ON CST.FTCstCode = ADDL.FTCstCode
        //             WHERE 1=1 AND ADDL.FTCstCode = '$ptCuscode'";
        $tSQL = "   SELECT 
                        ADDL.*, 
                        CSTL.FTCstName, 
                        CST.FTCstTaxNo,
                        PVN_L.FTPvnCode,
                        PVN_L.FTPvnName,
                        DST_L.FTDstCode,
                        DST_L.FTDstName,
                        SUD_L.FTSudCode,
                        SUD_L.FTSudName
                    FROM TCNMTaxAddress_L ADDL WITH(NOLOCK)
                    LEFT JOIN TCNMCst				CST WITH(NOLOCK) ON CST.FTCstCode = ADDL.FTCstCode
                    LEFT JOIN TCNMCst_L			   CSTL WITH(NOLOCK) ON CSTL.FTCstCode = ADDL.FTCstCode AND CSTL.FNLngID = $nLngID
                    LEFT JOIN TCNMProvince_L      PVN_L WITH(NOLOCK) ON ADDL.FTAddV1PvnCode = PVN_L.FTPvnCode AND PVN_L.FNLngID = $nLngID
                    LEFT JOIN TCNMDistrict_L      DST_L WITH(NOLOCK) ON ADDL.FTAddV1DstCode = DST_L.FTDstCode AND DST_L.FNLngID = $nLngID
                    LEFT JOIN TCNMSubDistrict_L   SUD_L WITH(NOLOCK) ON ADDL.FTAddV1SubDist = SUD_L.FTSudCode AND SUD_L.FNLngID = $nLngID
                    WHERE 1 = 1
                    AND ADDL.FTCstCode = '$ptCuscode' ";

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //หาที่อยู่ ที่ตาราง TCNMCstAddress_L
    public function FSaMTXFFindAddressCst($ptCutomerCode,$pnSeq){
        $tSQL   = " SELECT ADDL.*  , CSTL.FTCstName , CST.FTCstTaxNo AS FTAddTaxNo FROM TCNMCstAddress_L ADDL WITH (NOLOCK) 
                    LEFT JOIN TCNMCst_L CSTL ON CSTL.FTCstCode = ADDL.FTCstCode  
                    LEFT JOIN TCNMCst CST  ON CST.FTCstCode = ADDL.FTCstCode  
                    WHERE 1=1 AND ADDL.FTCstCode = '$ptCutomerCode' ";

        // if(isset($pnSeq)){
        //     $tSQL   .= "AND FNAddSeqNo = '$pnSeq' ";
        // }
        if($pnSeq != ''){
            $tSQL   .= "AND ADDL.FNAddSeqNo = '$pnSeq' ";
        }

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //ค้นหาเลขที่ประจำตัวผู้เสียภาษี แบบคีย์
    public function FSaMTXFCheckTaxno($ptTaxno , $pnSeq){
        $tSQL   = "SELECT * FROM  TCNMTaxAddress_L Tax WITH (NOLOCK) LEFT JOIN TCNMCst_L ON TCNMCst_L.FTCstCode = Tax.FTCstCode WHERE 1=1 AND Tax.FTAddTaxNo = '$ptTaxno' ";
        // if(isset($pnSeq)){
        //     $tSQL   .= "AND FNAddSeqNo = '$pnSeq' ";
        // }
        if($pnSeq != ''){
            $tSQL   .= "AND ADDL.FNAddSeqNo = '$pnSeq' ";
        }

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //ค้นหาเลขที่ประจำตัวผู้เสียภาษี แบบเลือก
    public function FSaMTXFListTaxno($paData){
        $aRowLen    = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
        $nLngID     = $paData['FNLngID'];
        $tSQL       = "SELECT c.* FROM(
                        SELECT  ROW_NUMBER() OVER(ORDER BY FTAddTaxNo DESC) AS FNRowID,* FROM
                            (SELECT DISTINCT
                                FTAddTaxNo , FNLngID , FNAddSeqNo , FTCstCode ,
                                FTAddName , FTAddRmk , FTAddCountry , FTAreCode ,
                                FTZneCode , FTAddVersion , FTAddV1No , FTAddV1Soi ,
                                FTAddV1Village , FTAddV1Road , FTAddV1SubDist , FTAddV1DstCode ,
                                FTAddV1PvnCode , FTAddV1PostCode , FTAddV2Desc1 , FTAddV2Desc2 ,
                                FTAddWebsite , FTAddLongitude , FTAddLatitude , FTAddStaBusiness ,
                                FTAddStaHQ , FTAddStaBchCode , FTAddTel , FTAddFax
                            FROM TCNMTaxAddress_L ADDL WITH (NOLOCK)
                            WHERE 1=1 AND FNLngID = '$nLngID' ";

        //ค้นหาแบบพิเศษ
        @$tSearchList  = trim($paData['tSearchTaxno']);
        if($tSearchList != '' || $tSearchList != null){
            $tSQL .= "  AND (
                (ADDL.FTAddTaxNo LIKE '%$tSearchList%') 
                OR (ADDL.FTCstCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddName LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1No LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1Soi LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1Village LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1Road LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1SubDist LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1DstCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1PvnCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1PostCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV2Desc1 LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV2Desc2 LIKE '%$tSearchList%') 
                OR (ADDL.FTAddStaBusiness LIKE '%$tSearchList%') 
                OR (ADDL.FTAddTel LIKE '%$tSearchList%') 
                OR (ADDL.FTAddFax LIKE '%$tSearchList%') 
            )";
        }
        
        $tSQL .= ") Base) AS c WHERE c.FNRowID > $aRowLen[0] AND c.FNRowID <= $aRowLen[1]";

        $oQuery = $this->db->query($tSQL);
        if($oQuery->num_rows() > 0){
            $oList      = $oQuery->result();
            $aFoundRow  = $this->FSnMTXFGetTaxnoPageAll($paData);
            $nFoundRow  = $aFoundRow[0]->counts;
            $nPageAll   = ceil($nFoundRow/$paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า
            $aResult    = array(
                'raItems'       => $oList,
                'rnAllRow'      => $nFoundRow,
                'rnCurrentPage' => $paData['nPage'],
                'rnAllPage'     => $nPageAll,
                'rtCode'        => '1',
                'rtDesc'        => 'success'
            );
        }else{
            $aResult = array(
                'rnAllRow'      => 0,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage"     => 0,
                'rtCode'        => '800',
                'rtDesc'        => 'data not found'
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //จำนวนเลขที่ประจำตัวผู้เสียภาษี แบบเลือก
    public function FSnMTXFGetTaxnoPageAll($paData){
        $nLngID     = $paData['FNLngID'];
        $tSQL       = " SELECT COUNT (ADDL.FTAddTaxNo) AS counts FROM TCNMTaxAddress_L ADDL WITH (NOLOCK) WHERE 1=1 AND FNLngID = '$nLngID' ";

        //ค้นหาแบบพิเศษ
        @$tSearchList  = trim($paData['tSearchTaxno']);
        if($tSearchList != '' || $tSearchList != null){
            $tSQL .= "  AND (
                (ADDL.FTAddTaxNo LIKE '%$tSearchList%') 
                OR (ADDL.FTCstCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddName LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1No LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1Soi LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1Village LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1Road LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1SubDist LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1DstCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1PvnCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1PostCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV2Desc1 LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV2Desc2 LIKE '%$tSearchList%') 
                OR (ADDL.FTAddStaBusiness LIKE '%$tSearchList%') 
                OR (ADDL.FTAddTel LIKE '%$tSearchList%') 
                OR (ADDL.FTAddFax LIKE '%$tSearchList%') 
            )";
        }

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //ค้นหาที่อยู่ของลูกค้า
    public function FSaMTXFListCustomerAddress($paData){
        $aRowLen        = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
        $nLngID         = $paData['FNLngID'];
        $tCustomerCode  = $paData['tCustomerCode'];
        $tSQL       = "SELECT c.* FROM(
                        SELECT  ROW_NUMBER() OVER(ORDER BY FTCstCode DESC) AS FNRowID,* FROM
                            (SELECT DISTINCT
                                ADDL.FTCstCode , FTAddGrpType , FNAddSeqNo ,
                                FTAddRefNo , FTAddName , FTAddRmk ,  FTAddCountry , FTAreCode ,
                                FTZneCode , FTAddVersion , FTAddV1No ,
                                FTAddV1Soi , FTAddV1Village , FTAddV1Road , FTAddV1SubDist ,
                                FTAddV1DstCode , FTAddV1PvnCode , FTAddV1PostCode , FTAddV2Desc1 , 
                                FTAddV2Desc2 , FTAddWebsite , FTAddLongitude , FTAddLatitude , CST.FTCstName
                            FROM TCNMCstAddress_L ADDL WITH (NOLOCK)
                            LEFT JOIN TCNMCst_L CST ON ADDL.FTCstCode = CST.FTCstCode
                            WHERE 1=1 AND ADDL.FNLngID = '$nLngID' AND CST.FNLngID = '$nLngID' ";

        if($tCustomerCode != ''){
            $tSQL       .= "AND ADDL.FTCstCode = '$tCustomerCode' ";
        }

        //ค้นหาแบบพิเศษ
        @$tSearchList  = trim($paData['tSearchAddress']);
        if($tSearchList != '' || $tSearchList != null){
            $tSQL .= "  AND (
                (CST.FTCstName LIKE '%$tSearchList%') 
                OR (ADDL.FTCstCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddGrpType LIKE '%$tSearchList%') 
                OR (ADDL.FTAddRefNo LIKE '%$tSearchList%') 
                OR (ADDL.FTAddName LIKE '%$tSearchList%') 
                OR (ADDL.FTAddRmk LIKE '%$tSearchList%') 
                OR (ADDL.FTAddCountry LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1SubDist LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1DstCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1PvnCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1PostCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV2Desc1 LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV2Desc2 LIKE '%$tSearchList%') 
            )";
        }
        
        $tSQL .= ") Base) AS c WHERE c.FNRowID > $aRowLen[0] AND c.FNRowID <= $aRowLen[1]";

        $oQuery = $this->db->query($tSQL);
        if($oQuery->num_rows() > 0){
            $oList      = $oQuery->result();
            $aFoundRow  = $this->FSnMTXFGetCustomerAddressPageAll($paData);
            $nFoundRow  = $aFoundRow[0]->counts;
            $nPageAll   = ceil($nFoundRow/$paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า
            $aResult    = array(
                'raItems'       => $oList,
                'rnAllRow'      => $nFoundRow,
                'rnCurrentPage' => $paData['nPage'],
                'rnAllPage'     => $nPageAll,
                'rtCode'        => '1',
                'rtDesc'        => 'success'
            );
        }else{
            $aResult = array(
                'rnAllRow'      => 0,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage"     => 0,
                'rtCode'        => '800',
                'rtDesc'        => 'data not found'
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //จำนวนที่อยู่ของลูกค้า
    public function FSnMTXFGetCustomerAddressPageAll($paData){
        $nLngID         = $paData['FNLngID'];
        $tCustomerCode  = $paData['tCustomerCode'];
        $tSQL       = " SELECT COUNT (ADDL.FTCstCode) AS counts FROM TCNMCstAddress_L ADDL 
                        LEFT JOIN TCNMCst_L CST ON ADDL.FTCstCode = CST.FTCstCode
                        WHERE 1=1 AND ADDL.FNLngID = '$nLngID' AND CST.FNLngID = '$nLngID' ";

        if($tCustomerCode != ''){
            $tSQL       .= "AND ADDL.FTCstCode = '$tCustomerCode' ";
        }

        //ค้นหาแบบพิเศษ
        @$tSearchList  = trim($paData['tSearchAddress']);
        if($tSearchList != '' || $tSearchList != null){
            $tSQL .= "  AND (
                (CST.FTCstName LIKE '%$tSearchList%') 
                OR (ADDL.FTCstCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddGrpType LIKE '%$tSearchList%') 
                OR (ADDL.FTAddRefNo LIKE '%$tSearchList%') 
                OR (ADDL.FTAddName LIKE '%$tSearchList%') 
                OR (ADDL.FTAddRmk LIKE '%$tSearchList%') 
                OR (ADDL.FTAddCountry LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1SubDist LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1DstCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1PvnCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV1PostCode LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV2Desc1 LIKE '%$tSearchList%') 
                OR (ADDL.FTAddV2Desc2 LIKE '%$tSearchList%') 
            )";
        }

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //////////////////////////////////// MOVE DATA ////////////////////////////////
    
    // TPSTSalHD -> TPSTTaxHD
    public function  FSaMTXFMoveSalHD_TaxHD($aPackData){
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tXshGndText        = $aPackData['tXshGndText'];
        $tCstCode           = $aPackData['tCstCode'];
        $tStaETax           = $aPackData['tStaETax'];
        $tTAXApvType        = $aPackData['tTAXApvType'];
        $tCurretTaxDocNo    = $aPackData['tCurretTaxDocNo'];

        // -- SUM (ISNULL(SALHD.FCXshVatable,0)) AS FCXshVatable, --  (FCXshAmtV + FCXshAmtNV - FCXshVat) = FCXshVatable
        // -- SUM (ISNULL(SALHD.FCXshVat,0)) AS FCXshVat,  --FCXshAmtV คำนวณให้ได้ FCXshVat

        $cCmpVatRate        = FCNaHVATGetActiveVatCompany()['value'];
        //เพิ่มเติม
        $dDateCurrent       = date('Y-m-d H:i:s');
        $tNameTask          = $this->session->userdata('tSesUsername');
        $dDocDateTime       = $aPackData['dDocDate'] .' '. $aPackData['dDocTime'];
        $tRemark            = $aPackData['tReason'];
        $tReason            = $aPackData['tReason'];

        $tDocno             = $this->FSaMTXFGetDTFTXshDocNo($tABB);
        $tSQL2              = '';

        if($tTAXApvType == '2' && $tTaxNumberFull != $tCurretTaxDocNo){
            $tSQL   = " INSERT INTO TPSTTaxHD (
                    FTBchCode,FTXshDocNo,FTShpCode,FNXshDocType,FDXshDocDate,
                    FTXshCshOrCrd,FTXshVATInOrEx,FTDptCode,FTWahCode,
                    FTPosCode,FTShfCode,FNSdtSeqNo,FTUsrCode,FTSpnCode,
                    FTXshApvCode,FTCstCode,FTXshDocVatFull,FTXshRefExt,
                    FDXshRefExtDate,FTXshRefInt,FDXshRefIntDate,FTXshRefAE,
                    FNXshDocPrint,FTRteCode,FCXshRteFac,FCXshTotal,FCXshTotalNV,FCXshTotalNoDis,
                    FCXshTotalB4DisChgV,FCXshTotalB4DisChgNV,FTXshDisChgTxt,FCXshDis,
                    FCXshChg,FCXshTotalAfDisChgV,FCXshTotalAfDisChgNV,FCXshRefAEAmt,
                    FCXshAmtV,FCXshAmtNV,FCXshVat,FCXshVatable,FTXshWpCode,FCXshWpTax,
                    FCXshGrand,FCXshRnd,FTXshGndText,FCXshPaid,FCXshLeft,FTXshRmk,
                    FTXshStaRefund,FTXshStaDoc,FTXshStaApv,FTXshStaPrcStk,
                    FTXshStaPaid,FNXshStaDocAct,FNXshStaRef,FDLastUpdOn,
                    FTLastUpdBy,FDCreateOn,FTCreateBy,FTXshStaETax,FTRsnCode
                    ) SELECT FTBchCode,'$tTaxNumberFull' AS FTXshDocNo,FTShpCode,FNXshDocType,'$dDocDateTime' AS FDXshDocDate,
                            FTXshCshOrCrd,FTXshVATInOrEx,FTDptCode,FTWahCode,
                            FTPosCode,FTShfCode,FNSdtSeqNo,FTUsrCode,FTSpnCode,
                            '$tNameTask' AS FTXshApvCode,FTCstCode,'$tTaxNumberFull' AS FTXshDocVatFull,FTXshRefExt,
                            FDXshRefExtDate,'$tCurretTaxDocNo' AS FTXshRefInt,FDXshRefIntDate,'$tCurretTaxDocNo' AS FTXshRefAE,
                            FNXshDocPrint,FTRteCode,FCXshRteFac,FCXshTotal,FCXshTotalNV,FCXshTotalNoDis,
                            FCXshTotalB4DisChgV,FCXshTotalB4DisChgNV,FTXshDisChgTxt,FCXshDis,
                            FCXshChg,FCXshTotalAfDisChgV,FCXshTotalAfDisChgNV,FCXshRefAEAmt,
                            FCXshAmtV,FCXshAmtNV,FCXshVat,FCXshVatable,FTXshWpCode,FCXshWpTax,
                            FCXshGrand,FCXshRnd,FTXshGndText,FCXshPaid,FCXshLeft,FTXshRmk,
                            FTXshStaRefund,FTXshStaDoc,FTXshStaApv,FTXshStaPrcStk,
                            FTXshStaPaid,FNXshStaDocAct,FNXshStaRef,'$dDateCurrent' AS FDLastUpdOn,
                            '$tNameTask' AS FTLastUpdBy,'$dDateCurrent' AS FDCreateOn,'$tNameTask' AS FTCreateBy,FTXshStaETax,FTRsnCode
                        FROM TPSTTaxHD 
                        WHERE FTXshDocNo = '$tCurretTaxDocNo'";

            $tSQL2  = "UPDATE TPSTTaxHD SET FTXshStaDoc = '5' , FDLastUpdOn = '$dDateCurrent' , FTLastUpdBy = '$tNameTask' 
                        WHERE FTXshDocNo = '$tCurretTaxDocNo'";
        }else{
        $tSQL       = " INSERT INTO TPSTTaxHD (
                        FTBchCode,FTXshDocNo,FTShpCode,FNXshDocType,FDXshDocDate,
                        FTXshCshOrCrd,FTXshVATInOrEx,FTDptCode,FTWahCode,
                        FTPosCode,FTShfCode,FNSdtSeqNo,FTUsrCode,FTSpnCode,
                        FTXshApvCode,FTCstCode,FTXshDocVatFull,FTXshRefExt,
                        FDXshRefExtDate,FTXshRefInt,FDXshRefIntDate,FTXshRefAE,
                        FNXshDocPrint,FTRteCode,FCXshRteFac,FCXshTotal,FCXshTotalNV,FCXshTotalNoDis,
                        FCXshTotalB4DisChgV,FCXshTotalB4DisChgNV,FTXshDisChgTxt,FCXshDis,
                        FCXshChg,FCXshTotalAfDisChgV,FCXshTotalAfDisChgNV,FCXshRefAEAmt,
                        FCXshAmtV,FCXshAmtNV,FCXshVat,FCXshVatable,FTXshWpCode,FCXshWpTax,
                        FCXshGrand,FCXshRnd,FTXshGndText,FCXshPaid,FCXshLeft,FTXshRmk,
                        FTXshStaRefund,FTXshStaDoc,FTXshStaApv,FTXshStaPrcStk,
                        FTXshStaPaid,FNXshStaDocAct,FNXshStaRef,FDLastUpdOn,
                        FTLastUpdBy,FDCreateOn,FTCreateBy,FTXshStaETax,FTRsnCode
                        )  SELECT '$tBrowseBchCode' AS FTBchCode,'$tTaxNumberFull' AS FTXshDocNo,'' AS FTShpCode,
                        CASE WHEN FCXshTotal<0 THEN 5 WHEN FCXshTotal > 0 THEN 4 ELSE 0 END AS FNXshDocType,
                        '$dDocDateTime' AS FDXshDocDate,'2' AS FTXshCshOrCrd,
                        (SELECT FTCmpRetInOrEx FROM TCNMComp WHERE FTCmpCode= '00001') AS FTXshVATInOrEx,
                        '' AS FTDptCode,'' AS FTWahCode,'' AS FTPosCode,'' AS FTShfCode,1 AS FNSdtSeqNo,
                        '$tNameTask' AS FTUsrCode,'' AS FTSpnCode,'$tNameTask' AS FTXshApvCode,'$tCstCode' AS FTCstCode,
                        '$tTaxNumberFull' AS FTXshDocVatFull,'$tABB' AS FTXshRefExt,GETDATE() AS FDXshRefExtDate,
                        '' AS FTXshRefInt,'' AS FDXshRefIntDate,'' AS FTXshRefAE,0 AS FNXshDocPrint,
                        (SELECT FTRteCode FROM TCNMComp WHERE FTCmpCode= '00001') AS FTRteCode,
                        1 AS FCXshRteFac,FCXshTotal,FCXshTotalNV,FCXshTotalNoDis,FCXshTotalB4DisChgV,
                        FCXshTotalB4DisChgNV,'' AS FTXshDisChgTxt,FCXshDis,FCXshChg,FCXshTotalAfDisChgV,
                        FCXshTotalAfDisChgNV,FCXshRefAEAmt,FCXshAmtV,FCXshAmtNV,FCXshVat,
                        FCXshVatable,'' AS FTXshWpCode,FCXshWpTax,FCXshGrand,FCXshRnd,'$tXshGndText' AS FTXshGndText,FCXshPaid,
                        FCXshLeft,'$tRemark' AS FTXshRmk,'' AS FTXshStaRefund,'1' AS FTXshStaDoc,'1' AS FTXshStaApv,
                        '1' AS FTXshStaPrcStk,'1' AS FTXshStaPaid,'1' AS FNXshStaDocAct,'' AS FNXshStaRef,
                        '$dDateCurrent' AS FDLastUpdOn,'$tNameTask' AS FTLastUpdBy,'$dDateCurrent' AS FDCreateOn,
                        '$tNameTask' AS FTCreateBy,'$tStaETax','$tReason'
                        FROM (
                        SELECT SALHD.FTBchCode,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshTotal,0) *-(1) ELSE ISNULL(SALHD.FCXshTotal,0) END) AS FCXshTotal,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshTotalNV,0) *-(1) ELSE ISNULL(SALHD.FCXshTotalNV,0) END) AS FCXshTotalNV,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshTotalNoDis,0) *-(1) ELSE ISNULL(SALHD.FCXshTotalNoDis,0) END) AS FCXshTotalNoDis,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshTotalB4DisChgV,0) *-(1) ELSE ISNULL(SALHD.FCXshTotalB4DisChgV,0) END) AS FCXshTotalB4DisChgV,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshTotalB4DisChgNV,0) *-(1) ELSE ISNULL(SALHD.FCXshTotalB4DisChgNV,0) END) AS FCXshTotalB4DisChgNV,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshTotalAfDisChgV,0) *-(1) ELSE ISNULL(SALHD.FCXshTotalAfDisChgV,0) END) AS FCXshTotalAfDisChgV,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshTotalAfDisChgNV,0) *-(1) ELSE ISNULL(SALHD.FCXshTotalAfDisChgNV,0) END) AS FCXshTotalAfDisChgNV,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshRefAEAmt,0) *-(1) ELSE ISNULL(SALHD.FCXshRefAEAmt,0) END) AS FCXshRefAEAmt,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshAmtV,0) *-(1) ELSE ISNULL(SALHD.FCXshAmtV,0) END) AS FCXshAmtV, 
                            SUM(
                                CASE WHEN SALHD.FNXshDocType = 9 THEN
                                    CASE WHEN SALHD.FTXshVATInOrEx = '1' THEN 
                                    ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate ) / (100 + $cCmpVatRate ) )  *-(1)
                                    ELSE
                                    ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate )  / 100 )  *-(1)
                                    END
                                ELSE
                                    CASE WHEN SALHD.FTXshVATInOrEx = '1' THEN 
                                    ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate ) / (100 + $cCmpVatRate ) ) 
                                    ELSE
                                    ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate )  / 100 ) 
                                    END
                                END
                            ) FCXshVat,
                            (   
                            
                                    ( SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshAmtV,0) *-(1) ELSE ISNULL(SALHD.FCXshAmtV,0) END ) - 
                                            (
                                                SUM(
                                                    CASE WHEN SALHD.FNXshDocType = 9 THEN
                                                        CASE WHEN SALHD.FTXshVATInOrEx = '1' THEN 
                                                        ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate ) / (100 + $cCmpVatRate ) )  *-(1)
                                                        ELSE
                                                        ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate )  / 100 )  *-(1)
                                                        END
                                                    ELSE
                                                        CASE WHEN SALHD.FTXshVATInOrEx = '1' THEN 
                                                        ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate ) / (100 + $cCmpVatRate ) ) 
                                                        ELSE
                                                        ( (ISNULL(SALHD.FCXshAmtV,0) * $cCmpVatRate )  / 100 ) 
                                                        END
                                                    END
                                                )
                                            )
                                    ) + SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshAmtNV,0) *-(1) ELSE ISNULL(SALHD.FCXshAmtNV,0) END ) 
                            
                                
                            ) AS FCXshVatable,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshAmtNV,0) *-(1) ELSE ISNULL(SALHD.FCXshAmtNV,0) END) AS FCXshAmtNV, 
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshWpTax,0) *-(1) ELSE ISNULL(SALHD.FCXshWpTax,0) END) AS FCXshWpTax,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshDis,0) *-(1) ELSE ISNULL(SALHD.FCXshDis,0) END) AS FCXshDis,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshChg,0) *-(1) ELSE ISNULL(SALHD.FCXshChg,0) END) AS FCXshChg,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshGrand,0) *-(1) ELSE ISNULL(SALHD.FCXshGrand,0) END) AS FCXshGrand,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshRnd,0) *-(1) ELSE ISNULL(SALHD.FCXshRnd,0) END) AS FCXshRnd,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshPaid,0) *-(1) ELSE ISNULL(SALHD.FCXshPaid,0) END) AS FCXshPaid,
                            SUM (CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(SALHD.FCXshLeft,0) *-(1) ELSE ISNULL(SALHD.FCXshLeft,0) END) AS FCXshLeft
                            FROM TPSTSalHD SALHD WITH (NOLOCK)
                            -- LEFT JOIN ( SELECT DISTINCT FTBchCode,FTXshDocNo,MIN(FTXrcRefNo1) AS FTXrcRefNo1  FROM TPSTSalRC
                            --             LEFT JOIN TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
                            --             WHERE TFNMRcv.FTFmtCode = '011'
                            --             GROUP BY FTBchCode,FTXshDocNo
                            -- ) SRC ON SRC.FTXshDocNo = SALHD.FTXshDocNo AND SRC.FTBchCode = SALHD.FTBchCode
                            -- LEFT JOIN (SELECT DISTINCT TFNTCrdTopUpDT.FTBchCode,TFNTCrdTopUpDT.FTCrdCode,TFNTCrdTopUpDT.FTXshDocNo,TFNMCard.FDCrdResetDate
                            --             FROM TFNTCrdTopUpDT
                            --             LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
                            -- ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
                            -- WHERE 1 = 1 AND TOPUPDT.FTXshDocNo = '$tABB' AND TOPUPDT.FTBchCode = '$tBrowseBchCode' AND ISNULL(FTXshDocVatFull, '') = '' 
                            -- AND SALHD.FDXshDocDate > TOPUPDT.FDCrdResetDate
                            WHERE SALHD.FTXshDocNo IN ($tDocno) AND ISNULL(FTXshDocVatFull, '') = '' 
                            GROUP BY SALHD.FTBchCode
                            ) AS SaleCard
                            ";
        }
        // exit;

        $this->db->query($tSQL);
        if($tSQL2 != '') {
            $this->db->query($tSQL2);
        }
    }

    // TPSTSalHDDis -> TPSTTaxHDDis
    public function FSaMTXFMoveSalHDDis_TaxHDDis($aPackData){
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tTAXApvType        = $aPackData['tTAXApvType'];
        $tCurretTaxDocNo    = $aPackData['tCurretTaxDocNo'];

        $tDocno             = $this->FSaMTXFGetDTFTXshDocNo($tABB);

        if($tTAXApvType == '2' && $tTaxNumberFull != $tCurretTaxDocNo){
            $tSQL   = " INSERT INTO TPSTTaxHDDis (
                            FTBchCode,FTXshDocNo,FDXhdDateIns,FTXhdDisChgTxt,FTXhdDisChgType,FCXhdTotalAfDisChg,FCXhdDisChg,FTXhdRefCode,FCXhdAmt
                        ) SELECT FTBchCode,'$tTaxNumberFull' AS FTXshDocNo,FDXhdDateIns,FTXhdDisChgTxt,FTXhdDisChgType,FCXhdTotalAfDisChg,FCXhdDisChg,FTXhdRefCode,FCXhdAmt
                        FROM TPSTTaxHDDis
                        WHERE FTXshDocNo = '$tCurretTaxDocNo'";
        }else {
            $tSQL   = " INSERT INTO TPSTTaxHDDis (
                        FTBchCode,FTXshDocNo,FDXhdDateIns,FTXhdDisChgTxt,FTXhdDisChgType,FCXhdTotalAfDisChg,FCXhdDisChg,FTXhdRefCode,FCXhdAmt
                    ) SELECT 
                    '$tBrowseBchCode' AS FTBchCode, '$tTaxNumberFull' AS FTXshDocNo,GETDATE() AS FDXhdDateIns, FTXhdDisChgTxt,CASE WHEN FCXhdAmt >0 THEN 3 ELSE 1 END AS FTXhdDisChgType, FCXhdTotalAfDisChg, FCXhdDisChg, FTXhdRefCode, ABS(FCXhdAmt) AS FCXhdAmt
                    FROM (
                        SELECT 
                           SUM (
                                CASE WHEN SALHD.FNXshDocType = 9 THEN 
                                    CASE WHEN HDDis.FTXhdDisChgType= 3 OR HDDis.FTXhdDisChgType= 4 THEN  ISNULL(HDDis.FCXhdAmt, 0) *- (1) ELSE ISNULL(HDDis.FCXhdAmt, 0) END
                                ELSE
                                    CASE WHEN HDDis.FTXhdDisChgType = 3 OR HDDis.FTXhdDisChgType= 4 THEN ISNULL(HDDis.FCXhdAmt, 0)  ELSE ISNULL(HDDis.FCXhdAmt, 0) *-(1) END
                                END
                            ) AS FTXhdDisChgTxt,
                            SUM(CAST(HDDis.FCXhdTotalAfDisChg AS float)) AS FCXhdTotalAfDisChg, 
                            SUM(CAST(HDDis.FCXhdDisChg AS float)) AS FCXhdDisChg,
                            '' AS FTXhdRefCode, 
                            SUM(
                                CASE WHEN SALHD.FNXshDocType = 9 THEN 
                                    CASE WHEN HDDis.FTXhdDisChgType= 3 OR HDDis.FTXhdDisChgType= 4 THEN  ISNULL(HDDis.FCXhdAmt, 0) *- (1) ELSE ISNULL(HDDis.FCXhdAmt, 0) END
                                ELSE
                                    CASE WHEN HDDis.FTXhdDisChgType = 3 OR HDDis.FTXhdDisChgType= 4 THEN ISNULL(HDDis.FCXhdAmt, 0)  ELSE ISNULL(HDDis.FCXhdAmt, 0) *-(1) END
                                END
                            ) AS FCXhdAmt
                        FROM TPSTSalHDDis HDDis 
                        LEFT JOIN TPSTSalHD SALHD WITH (NOLOCK) ON HDDis.FTBchCode = SALHD.FTBchCode AND HDDis.FTXshDocNo = SALHD.FTXshDocNo
                        WHERE SALHD.FTXshDocNo IN ($tDocno) AND ISNULL(FTXshDocVatFull, '') = '' 
                        GROUP BY HDDis.FTBchCode
                    ) AS SaleCard";
        }

        // $tSQL       = " INSERT INTO TPSTTaxHDDis (
        //                     FTBchCode,FTXshDocNo,FDXhdDateIns,FTXhdDisChgTxt,FTXhdDisChgType,FCXhdTotalAfDisChg,FCXhdDisChg,FTXhdRefCode,FCXhdAmt
        //                 ) SELECT 
        //                 '$tBrowseBchCode' AS FTBchCode, '$tTaxNumberFull' AS FTXshDocNo,GETDATE() AS FDXhdDateIns,HDDis.FTXhdDisChgTxt,HDDis.FTXhdDisChgType,HDDis.FCXhdTotalAfDisChg,HDDis.FCXhdDisChg,HDDis.FTXhdRefCode,
        //                 CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(HDDis.FCXhdAmt,0) *-(1) ELSE ISNULL(HDDis.FCXhdAmt,0) END FCXhdAmt
        //                 FROM TPSTSalHDDis HDDis
        //                 LEFT JOIN TPSTSalHD SALHD WITH (NOLOCK) ON HDDis.FTBchCode = SALHD.FTBchCode AND HDDis.FTXshDocNo = SALHD.FTXshDocNo
        //                 -- LEFT JOIN ( SELECT DISTINCT FTBchCode,FTXshDocNo,MIN(FTXrcRefNo1) AS FTXrcRefNo1 FROM TPSTSalRC
        //                 --             LEFT JOIN TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
        //                 --             WHERE TFNMRcv.FTFmtCode = '011'
        //                 --             GROUP BY FTBchCode,FTXshDocNo
        //                 -- ) SRC ON SRC.FTXshDocNo = SALHD.FTXshDocNo AND SRC.FTBchCode = SALHD.FTBchCode
        //                 -- LEFT JOIN (SELECT DISTINCT TFNTCrdTopUpDT.FTBchCode,TFNTCrdTopUpDT.FTCrdCode,TFNTCrdTopUpDT.FTXshDocNo,TFNMCard.FDCrdResetDate
        //                 --             FROM TFNTCrdTopUpDT
        //                 --             LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
        //                 -- ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
        //                 -- WHERE 1 = 1 AND TOPUPDT.FTXshDocNo = '$tABB' AND TOPUPDT.FTBchCode = '$tBrowseBchCode' AND ISNULL(FTXshDocVatFull, '') = '' 
        //                 -- AND SALHD.FDXshDocDate > TOPUPDT.FDCrdResetDate
        //                 WHERE SALHD.FTXshDocNo IN ($tDocno) AND ISNULL(FTXshDocVatFull, '') = '' 
        //                      ";
        $this->db->query($tSQL);
    }

    // TPSTSalDT -> TPSTTaxDT
    public function FSaMTXFMoveSalDT_TaxDT($aPackData){
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tTAXApvType        = $aPackData['tTAXApvType'];
        $tCurretTaxDocNo    = $aPackData['tCurretTaxDocNo'];

        $tDocno             = $this->FSaMTXFGetDTFTXshDocNo($tABB);

        if($tTAXApvType == '2' && $tTaxNumberFull != $tCurretTaxDocNo){
            $tSQL       = " INSERT INTO TPSTTaxDT (
                FTBchCode,FTXshDocNo,FNXsdSeqNo,FTPdtCode,FTXsdPdtName,
                FTPunCode,FTPunName,FTPplCode,FCXsdFactor,FTXsdBarCode,
                FTSrnCode,FTXsdVatType,FTVatCode,FCXsdVatRate,FTXsdSaleType,
                FCXsdSalePrice,FCXsdQty,FCXsdQtyAll,FCXsdSetPrice,FCXsdAmtB4DisChg,FTXsdDisChgTxt,
                FCXsdDis,FCXsdChg,FCXsdNet,FCXsdNetAfHD,
                FCXsdVat,FCXsdVatable,FCXsdWhtAmt,FTXsdWhtCode,
                FCXsdWhtRate,FCXsdCostIn,FCXsdCostEx,FTXsdStaPdt,
                FCXsdQtyLef,FCXsdQtyRfn,FTXsdStaPrcStk,FTXsdStaAlwDis,
                FNXsdPdtLevel,FTXsdPdtParent,FCXsdQtySet,FTPdtStaSet,
                FTXsdRmk,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy
            ) SELECT FTBchCode,'$tTaxNumberFull' AS FTXshDocNo,FNXsdSeqNo,FTPdtCode,FTXsdPdtName,
                    FTPunCode,FTPunName,FTPplCode,FCXsdFactor,FTXsdBarCode,
                    FTSrnCode,FTXsdVatType,FTVatCode,FCXsdVatRate,FTXsdSaleType,
                    FCXsdSalePrice,FCXsdQty,FCXsdQtyAll,FCXsdSetPrice,FCXsdAmtB4DisChg,FTXsdDisChgTxt,
                    FCXsdDis,FCXsdChg,FCXsdNet,FCXsdNetAfHD,
                    FCXsdVat,FCXsdVatable,FCXsdWhtAmt,FTXsdWhtCode,
                    FCXsdWhtRate,FCXsdCostIn,FCXsdCostEx,FTXsdStaPdt,
                    FCXsdQtyLef,FCXsdQtyRfn,FTXsdStaPrcStk,FTXsdStaAlwDis,
                    FNXsdPdtLevel,FTXsdPdtParent,FCXsdQtySet,FTPdtStaSet,
                    FTXsdRmk,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy
                FROM TPSTTaxDT
                WHERE FTXshDocNo = '$tCurretTaxDocNo'";
        }else {
            $tSQL       = " INSERT INTO TPSTTaxDT (
                                FTBchCode,FTXshDocNo,FNXsdSeqNo,FTPdtCode,FTXsdPdtName,
                                FTPunCode,FTPunName,FTPplCode,FCXsdFactor,FTXsdBarCode,
                                FTSrnCode,FTXsdVatType,FTVatCode,FCXsdVatRate,FTXsdSaleType,
                                FCXsdSalePrice,FCXsdQty,FCXsdQtyAll,FCXsdSetPrice,FCXsdAmtB4DisChg,FTXsdDisChgTxt,
                                FCXsdDis,FCXsdChg,FCXsdNet,FCXsdNetAfHD,
                                FCXsdVat,FCXsdVatable,FCXsdWhtAmt,FTXsdWhtCode,
                                FCXsdWhtRate,FCXsdCostIn,FCXsdCostEx,FTXsdStaPdt,
                                FCXsdQtyLef,FCXsdQtyRfn,FTXsdStaPrcStk,FTXsdStaAlwDis,
                                FNXsdPdtLevel,FTXsdPdtParent,FCXsdQtySet,FTPdtStaSet,
                                FTXsdRmk,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy
                            ) SELECT 
                                '$tBrowseBchCode' AS FTBchCode,'$tTaxNumberFull',ROW_NUMBER() OVER(ORDER BY SALDT.FTXshDocNo) AS FNXsdSeqNo,FTPdtCode,FTXsdPdtName,
                                FTPunCode,FTPunName,FTPplCode,FCXsdFactor,FTXsdBarCode,
                                FTSrnCode,FTXsdVatType,FTVatCode,FCXsdVatRate,FTXsdSaleType,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdSalePrice,0) *-(1) ELSE ISNULL(FCXsdSalePrice,0) END FCXsdSalePrice ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdQty,0) *-(1) ELSE ISNULL(FCXsdQty,0) END FCXsdQty ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdQtyAll,0) *-(1) ELSE ISNULL(FCXsdQtyAll,0) END FCXsdQtyAll ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdSetPrice,0) *-(1) ELSE ISNULL(FCXsdSetPrice,0) END FCXsdSetPrice ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdAmtB4DisChg,0) *-(1) ELSE ISNULL(FCXsdAmtB4DisChg,0) END FCXsdAmtB4DisChg ,
                                FTXsdDisChgTxt,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdDis,0) *-(1) ELSE ISNULL(FCXsdDis,0) END FCXsdDis ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdChg,0) *-(1) ELSE ISNULL(FCXsdChg,0) END FCXsdChg ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdNet,0) *-(1) ELSE ISNULL(FCXsdNet,0) END FCXsdNet ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdNetAfHD,0) *-(1) ELSE ISNULL(FCXsdNetAfHD,0) END FCXsdNetAfHD ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdVat,0) *-(1) ELSE ISNULL(FCXsdVat,0) END FCXsdVat ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdVatable,0) *-(1) ELSE ISNULL(FCXsdVatable,0) END FCXsdVatable ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdWhtAmt,0) *-(1) ELSE ISNULL(FCXsdWhtAmt,0) END FCXsdWhtAmt ,
                                FTXsdWhtCode,
                                FCXsdWhtRate,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdCostIn,0) *-(1) ELSE ISNULL(FCXsdCostIn,0) END FCXsdCostIn ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdCostEx,0) *-(1) ELSE ISNULL(FCXsdCostEx,0) END FCXsdCostEx ,
                                FTXsdStaPdt,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdQtyLef,0) *-(1) ELSE ISNULL(FCXsdQtyLef,0) END FCXsdQtyLef ,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdQtyRfn,0) *-(1) ELSE ISNULL(FCXsdQtyRfn,0) END FCXsdQtyRfn ,
                                FTXsdStaPrcStk,FTXsdStaAlwDis,
                                FNXsdPdtLevel,FTXsdPdtParent,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdQtySet,0) *-(1) ELSE ISNULL(FCXsdQtySet,0) END FCXsdQtySet ,
                                FTPdtStaSet,
                                FTXsdRmk,SALDT.FDLastUpdOn,SALDT.FTLastUpdBy,SALDT.FDCreateOn,SALDT.FTCreateBy 
                            FROM TPSTSalDT SALDT
                            LEFT JOIN TPSTSalHD SALHD WITH (NOLOCK) ON SALDT.FTBchCode = SALHD.FTBchCode AND SALDT.FTXshDocNo = SALHD.FTXshDocNo
                            -- LEFT JOIN ( SELECT DISTINCT FTBchCode,FTXshDocNo,MIN(FTXrcRefNo1) AS FTXrcRefNo1 FROM TPSTSalRC
                            --             LEFT JOIN TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
                            --             WHERE TFNMRcv.FTFmtCode = '011'
                            --             GROUP BY FTBchCode,FTXshDocNo
                            -- ) SRC ON SRC.FTXshDocNo = SALHD.FTXshDocNo AND SRC.FTBchCode = SALHD.FTBchCode
                            -- LEFT JOIN (SELECT DISTINCT TFNTCrdTopUpDT.FTBchCode,TFNTCrdTopUpDT.FTCrdCode,TFNTCrdTopUpDT.FTXshDocNo,TFNMCard.FDCrdResetDate
                            --             FROM TFNTCrdTopUpDT
                            --             LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
                            -- ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
                            -- WHERE 1 = 1 AND TOPUPDT.FTXshDocNo = '$tABB' AND TOPUPDT.FTBchCode = '$tBrowseBchCode' AND ISNULL(FTXshDocVatFull, '') = '' 
                            -- AND SALHD.FDXshDocDate > TOPUPDT.FDCrdResetDate
                            WHERE SALDT.FTXshDocNo IN ($tDocno) AND ISNULL(FTXshDocVatFull, '') = '' 
                            ";
        }
        $this->db->query($tSQL);
    }

    // TPSTSalDTDis -> TPSTTaxDTDis
    public function FSaMTXFMoveSalDTDis_TaxDTDis($aPackData){
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tTAXApvType        = $aPackData['tTAXApvType'];
        $tCurretTaxDocNo    = $aPackData['tCurretTaxDocNo'];
        
        $tDocno             = $this->FSaMTXFGetDTFTXshDocNo($tABB);

        if($tTAXApvType == '2' && $tTaxNumberFull != $tCurretTaxDocNo){
            $tSQL       = " INSERT INTO TPSTTaxDTDis (
                                FTBchCode,FTXshDocNo,FNXsdSeqNo,FDXddDateIns,FNXddStaDis,
                                FTXddDisChgTxt,FTXddDisChgType,FCXddNet,FCXddValue,FTXddRefCode
                            ) SELECT FTBchCode,'$tTaxNumberFull' AS FTXshDocNo,FNXsdSeqNo,FDXddDateIns,FNXddStaDis,
                                    FTXddDisChgTxt,FTXddDisChgType,FCXddNet,FCXddValue,FTXddRefCode
                                FROM TPSTTaxDTDis
                                WHERE FTXshDocNo = '$tCurretTaxDocNo'";
        }else{
            $tSQL       = " INSERT INTO TPSTTaxDTDis (
                                FTBchCode,FTXshDocNo,FNXsdSeqNo,FDXddDateIns,FNXddStaDis,
                                FTXddDisChgTxt,FTXddDisChgType,FCXddNet,FCXddValue,FTXddRefCode
                            ) SELECT 
                                '$tBrowseBchCode' AS FTBchCode,'$tTaxNumberFull',DENSE_RANK() OVER (ORDER BY DTDis.FTXshDocNo, DTDis.FNXsdSeqNo) AS FNXsdSeqNo,FDXddDateIns,FNXddStaDis,
                                FTXddDisChgTxt,FTXddDisChgType,FCXddNet,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(DTDis.FCXddValue,0) *-(1) ELSE ISNULL(DTDis.FCXddValue,0) END FCXddValue,
                                FTXddRefCode
                            FROM TPSTSalDTDis DTDis
                            LEFT JOIN TPSTSalHD SALHD WITH (NOLOCK) ON DTDis.FTBchCode = SALHD.FTBchCode AND DTDis.FTXshDocNo = SALHD.FTXshDocNo
                            -- LEFT JOIN ( SELECT DISTINCT FTBchCode,FTXshDocNo,MIN(FTXrcRefNo1) AS FTXrcRefNo1 FROM TPSTSalRC
                            --             LEFT JOIN TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
                            --             WHERE TFNMRcv.FTFmtCode = '011'
                            --             GROUP BY FTBchCode,FTXshDocNo
                            -- ) SRC ON SRC.FTXshDocNo = SALHD.FTXshDocNo AND SRC.FTBchCode = SALHD.FTBchCode
                            -- LEFT JOIN (SELECT DISTINCT TFNTCrdTopUpDT.FTBchCode,TFNTCrdTopUpDT.FTCrdCode,TFNTCrdTopUpDT.FTXshDocNo,TFNMCard.FDCrdResetDate
                            --             FROM TFNTCrdTopUpDT
                            --             LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
                            -- ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
                            -- WHERE 1 = 1 AND TOPUPDT.FTXshDocNo = '$tABB' AND TOPUPDT.FTBchCode = '$tBrowseBchCode' AND ISNULL(FTXshDocVatFull, '') = '' 
                            -- AND SALHD.FDXshDocDate > TOPUPDT.FDCrdResetDate
                            WHERE DTDis.FTXshDocNo IN ($tDocno) AND ISNULL(FTXshDocVatFull, '') = '' 
                            ";
        }
        $this->db->query($tSQL);
    }

    // TPSTSalHDCst -> TPSTTaxHDCst
    public function FSaMTXFMoveSalHDCst_TaxHDCst($aPackData){
        $tABB                   = $aPackData['tDocABB'];
        $tBrowseBchCode         = $aPackData['tBrowseBchCode'];
        $tTaxBchCode            = $aPackData['tTaxBchCode'];
        $tTaxNumberFull         = $aPackData['tTaxNumberFull'];
        $tTAXApvType            = $aPackData['tTAXApvType'];
        $tCurretTaxDocNo        = $aPackData['tCurretTaxDocNo'];

        //ถ้าไปเจอลูกค้า จะ move ลงตาราง Tax เลย
        // $tSQL       = "SELECT ISNULL(FTCstCode,'') AS FTCstCode FROM TPSTSalHD SAL WITH (NOLOCK)  WHERE FTXshDocNo = '$tABB'";
        // $oQuery     = $this->db->query($tSQL);
        // $aResult    = $oQuery->result();
        // $tCstCode   = $aResult[0]->FTCstCode;
        // if($tCstCode == '' || $tCstCode == null){

        $tCusCodeForm   = $aPackData['tCstCode'];
        $tCstName       = $aPackData['tCstName'];
        $tCstNameABB       = $aPackData['tCstNameABB'];

        if($tTAXApvType == '2' && $tTaxNumberFull != $tCurretTaxDocNo){
            if( $tCstName == '' ||  $tCstName == null){
                //ไม่มีการเลือกลูกค้า และ ไม่มีลูกค้าอยู่ใน ABB
                $tSQL       = " INSERT INTO TPSTTaxHDCst (
                                    FTBchCode,
                                    FTXshDocNo,
                                    FTXshCstName
                                ) SELECT 
                                    '$tBrowseBchCode' AS FTBchCode,
                                    '$tTaxNumberFull',
                                    'ลูกค้าทั่วไป' ";
            }else{
                //ในหน้าจอมีการเลือกลูกค้า
                $tSQL       = " INSERT INTO TPSTTaxHDCst (
                                    FTBchCode,
                                    FTXshDocNo,
                                    FTXshCstName
                                ) SELECT 
                                    '$tBrowseBchCode' AS FTBchCode,
                                    '$tTaxNumberFull',
                                    '$tCstNameABB' ";
            }
        }else {

            if( $tCusCodeForm == '' ||  $tCusCodeForm == null){
                //ไม่มีการเลือกลูกค้า และ ไม่มีลูกค้าอยู่ใน ABB
                $tSQL       = " INSERT INTO TPSTTaxHDCst (
                                    FTBchCode,
                                    FTXshDocNo,
                                    FTXshCstName
                                ) SELECT 
                                    '$tBrowseBchCode' AS FTBchCode,
                                    '$tTaxNumberFull',
                                    'ลูกค้าทั่วไป' ";
            }else{
                //ในหน้าจอมีการเลือกลูกค้า
                $tSQL       = " INSERT INTO TPSTTaxHDCst (
                                    FTBchCode,
                                    FTXshDocNo,
                                    FTXshCstName
                                ) SELECT 
                                    '$tBrowseBchCode' AS FTBchCode,
                                    '$tTaxNumberFull',
                                    '$tCstName' ";
            }
        }

        $this->db->query($tSQL);
        // }else{
        //     $tCstName   = $aPackData['tCstName'];
        //     $tSQL       = " INSERT INTO TPSTTaxHDCst (
        //                         FTBchCode,FTXshDocNo,FTXshCardID,FTXshCardNo,FNXshCrTerm,FDXshDueDate,
        //                         FDXshBillDue,FTXshCtrName,FDXshTnfDate,FTXshRefTnfID,FNXshAddrShip,FTXshAddrTax,
        //                         FTXshCstName,FTXshCstTel
        //                     ) SELECT 
        //                         FTBchCode,'$tTaxNumberFull',FTXshCardID,FTXshCardNo,FNXshCrTerm,FDXshDueDate,
        //                         FDXshBillDue,FTXshCtrName,FDXshTnfDate,FTXshRefTnfID,FNXshAddrShip,FTXshAddrTax,
        //                         '$tCstName',FTXshCstTel
        //                     FROM TPSTSalHDCst ";
        //     $this->db->query($tSQL);
        // }
    }

    // TPSTSalPD -> TPSTTaxPD
    public function FSaMTXFMoveSalPD_TaxPD($aPackData){
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tTAXApvType            = $aPackData['tTAXApvType'];
        $tCurretTaxDocNo        = $aPackData['tCurretTaxDocNo'];

        $tDocno             = $this->FSaMTXFGetDTFTXshDocNo($tABB);

        if($tTAXApvType == '2' && $tTaxNumberFull != $tCurretTaxDocNo){
            $tSQL       = " INSERT INTO TPSTTaxPD (
                                FTBchCode,FTXshDocNo,FTPmhDocNo,FNXsdSeqNo,
                                FTPmdGrpName,FTPdtCode,FTPunCode,FCXsdQty,FCXsdQtyAll,
                                FCXsdSetPrice,FCXsdNet,FCXpdGetQtyDiv,FTXpdGetType,FCXpdGetValue,
                                FCXpdDis,FCXpdPerDisAvg,FCXpdDisAvg,FCXpdPoint,FTXpdStaRcv,FTPplCode,
                                FTXpdCpnText,FTCpdBarCpn
                            ) SELECT FTBchCode,'$tTaxNumberFull' AS FTXshDocNo,FTPmhDocNo,FNXsdSeqNo,
                                    FTPmdGrpName,FTPdtCode,FTPunCode,FCXsdQty,FCXsdQtyAll,
                                    FCXsdSetPrice,FCXsdNet,FCXpdGetQtyDiv,FTXpdGetType,FCXpdGetValue,
                                    FCXpdDis,FCXpdPerDisAvg,FCXpdDisAvg,FCXpdPoint,FTXpdStaRcv,FTPplCode,
                                    FTXpdCpnText,FTCpdBarCpn
                                FROM TPSTTaxPD
                                WHERE FTXshDocNo = '$tCurretTaxDocNo'";
        }else{
            $tSQL       = " INSERT INTO TPSTTaxPD (
                                FTBchCode,FTXshDocNo,FTPmhDocNo,FNXsdSeqNo,
                                FTPmdGrpName,FTPdtCode,FTPunCode,FCXsdQty,FCXsdQtyAll,
                                FCXsdSetPrice,FCXsdNet,FCXpdGetQtyDiv,FTXpdGetType,FCXpdGetValue,
                                FCXpdDis,FCXpdPerDisAvg,FCXpdDisAvg,FCXpdPoint,FTXpdStaRcv,FTPplCode,
                                FTXpdCpnText,FTCpdBarCpn
                            ) SELECT 
                                '$tBrowseBchCode' AS FTBchCode,'$tTaxNumberFull',FTPmhDocNo,ROW_NUMBER() OVER(ORDER BY SalPD.FTXshDocNo) AS FNXsdSeqNo,
                                FTPmdGrpName,FTPdtCode,FTPunCode,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdQty,0) *-(1) ELSE ISNULL(FCXsdQty,0) END FCXsdQty,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdQtyAll,0) *-(1) ELSE ISNULL(FCXsdQtyAll,0) END FCXsdQtyAll,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdSetPrice,0) *-(1) ELSE ISNULL(FCXsdSetPrice,0) END FCXsdSetPrice,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXsdNet,0) *-(1) ELSE ISNULL(FCXsdNet,0) END FCXsdNet,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXpdGetQtyDiv,0) *-(1) ELSE ISNULL(FCXpdGetQtyDiv,0) END FCXpdGetQtyDiv,
                                FTXpdGetType,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXpdGetValue,0) *-(1) ELSE ISNULL(FCXpdGetValue,0) END FCXpdGetValue,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXpdDis,0) *-(1) ELSE ISNULL(FCXpdDis,0) END FCXpdDis,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXpdPerDisAvg,0) *-(1) ELSE ISNULL(FCXpdPerDisAvg,0) END FCXpdPerDisAvg,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXpdDisAvg,0) *-(1) ELSE ISNULL(FCXpdDisAvg,0) END FCXpdDisAvg,
                                CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXpdPoint,0) *-(1) ELSE ISNULL(FCXpdPoint,0) END FCXpdPoint,
                                FTXpdStaRcv,FTPplCode,
                                FTXpdCpnText,FTCpdBarCpn
                            FROM TPSTSalPD SalPD
                            LEFT JOIN TPSTSalHD SALHD WITH (NOLOCK) ON SalPD.FTBchCode = SALHD.FTBchCode AND SalPD.FTXshDocNo = SALHD.FTXshDocNo
                            -- LEFT JOIN ( SELECT DISTINCT FTBchCode,FTXshDocNo,MIN(FTXrcRefNo1) AS FTXrcRefNo1 FROM TPSTSalRC
                            --             LEFT JOIN TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
                            --             WHERE TFNMRcv.FTFmtCode = '011'
                            --             GROUP BY FTBchCode,FTXshDocNo
                            -- ) SRC ON SRC.FTXshDocNo = SALHD.FTXshDocNo AND SRC.FTBchCode = SALHD.FTBchCode
                            -- LEFT JOIN (SELECT DISTINCT TFNTCrdTopUpDT.FTBchCode,TFNTCrdTopUpDT.FTCrdCode,TFNTCrdTopUpDT.FTXshDocNo,TFNMCard.FDCrdResetDate
                            --             FROM TFNTCrdTopUpDT
                            --             LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
                            -- ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
                            -- WHERE 1 = 1 AND TOPUPDT.FTXshDocNo = '$tABB' AND TOPUPDT.FTBchCode = '$tBrowseBchCode' AND ISNULL(FTXshDocVatFull, '') = '' 
                            -- AND SALHD.FDXshDocDate > TOPUPDT.FDCrdResetDate
                            WHERE SalPD.FTXshDocNo IN ($tDocno) AND ISNULL(FTXshDocVatFull, '') = '' 
                            ";
        }
        $this->db->query($tSQL);
    }

    // TPSTSalRC -> TPSTTaxRC
    public function FSaMTXFMoveSalRC_TaxRC($aPackData){
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tTAXApvType            = $aPackData['tTAXApvType'];
        $tCurretTaxDocNo        = $aPackData['tCurretTaxDocNo'];

        //เพิ่มเติม
        $dDateCurrent       = date('Y-m-d H:i:s');
        $tNameTask          = $this->session->userdata('tSesUsername');
        $dDocDateTime       = $aPackData['dDocDate'] .' '. $aPackData['dDocTime'];
        $tRemark            = $aPackData['tReason'];

        $tDocno             = $this->FSaMTXFGetDTFTXshDocNo($tABB);

        if($tTAXApvType == '2' && $tTaxNumberFull != $tCurretTaxDocNo){
            $tSQL   = " INSERT INTO TPSTTaxRC (
                            FTBchCode,FTXshDocNo,FNXrcSeqNo,FTRcvCode,FTRcvName,
                            FTXrcRefNo1,FTXrcRefNo2,FDXrcRefDate,FTXrcRefDesc,FTBnkCode,
                            FTRteCode,FCXrcRteFac,FCXrcFrmLeftAmt,FCXrcUsrPayAmt,FCXrcDep,
                            FCXrcNet,FCXrcChg,FTXrcRmk,FTPhwCode,FTXrcRetDocRef,
                            FTXrcStaPayOffline,FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy
                        ) SELECT FTBchCode,'$tTaxNumberFull' AS FTXshDocNo,FNXrcSeqNo,FTRcvCode,FTRcvName,
                                FTXrcRefNo1,FTXrcRefNo2,FDXrcRefDate,FTXrcRefDesc,FTBnkCode,
                                FTRteCode,FCXrcRteFac,FCXrcFrmLeftAmt,FCXrcUsrPayAmt,FCXrcDep,
                                FCXrcNet,FCXrcChg,FTXrcRmk,FTPhwCode,FTXrcRetDocRef,
                                FTXrcStaPayOffline,'$dDateCurrent' AS FDLastUpdOn,'$tNameTask' AS FTLastUpdBy,FDCreateOn,FTCreateBy
                        FROM TPSTTaxRC
                        WHERE FTXshDocNo = '$tCurretTaxDocNo'";
        }else {
            $tSQL   = " INSERT INTO TPSTTaxRC (
                            FTBchCode,FTXshDocNo,FNXrcSeqNo,FTRcvCode,FTRcvName,
                            FTXrcRefNo1,FTXrcRefNo2,FDXrcRefDate,FTXrcRefDesc,FTBnkCode,
                            FTRteCode,FCXrcRteFac,FCXrcFrmLeftAmt,FCXrcUsrPayAmt,FCXrcDep,
                            FCXrcNet,FCXrcChg,FTXrcRmk,FTPhwCode,FTXrcRetDocRef,
                            FTXrcStaPayOffline, FDLastUpdOn,FTLastUpdBy,FDCreateOn,FTCreateBy
                        ) SELECT 
                            '$tBrowseBchCode' AS FTBchCode,'$tTaxNumberFull',ROW_NUMBER() OVER(ORDER BY SALRC.FTXshDocNo) AS FNXrcSeqNo,FTRcvCode,FTRcvName,
                            SALRC.FTXrcRefNo1,FTXrcRefNo2,FDXrcRefDate,FTXrcRefDesc,FTBnkCode,
                            SALRC.FTRteCode,FCXrcRteFac,
                            CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXrcFrmLeftAmt,0) *-(1) ELSE ISNULL(FCXrcFrmLeftAmt,0) END FCXrcFrmLeftAmt,
                            CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXrcUsrPayAmt,0) *-(1) ELSE ISNULL(FCXrcUsrPayAmt,0) END FCXrcUsrPayAmt,
                            CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXrcDep,0) *-(1) ELSE ISNULL(FCXrcDep,0) END FCXrcDep,
                            CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXrcNet,0) *-(1) ELSE ISNULL(FCXrcNet,0) END FCXrcNet,
                            CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXrcChg,0) *-(1) ELSE ISNULL(FCXrcChg,0) END FCXrcChg,
                            FTXrcRmk,FTPhwCode,FTXrcRetDocRef,
                            FTXrcStaPayOffline,SALRC.FDLastUpdOn,SALRC.FTLastUpdBy,'$dDateCurrent','$tNameTask'
                        FROM TPSTSalRC SALRC
                        LEFT JOIN TPSTSalHD SALHD WITH (NOLOCK) ON SALRC.FTBchCode = SALHD.FTBchCode AND SALRC.FTXshDocNo = SALHD.FTXshDocNo
                        -- LEFT JOIN ( SELECT DISTINCT FTBchCode,FTXshDocNo,MIN(FTXrcRefNo1) AS FTXrcRefNo1 FROM TPSTSalRC
                        --             LEFT JOIN TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
                        --             WHERE TFNMRcv.FTFmtCode = '011'
                        --             GROUP BY FTBchCode,FTXshDocNo
                        -- ) SRC ON SRC.FTXshDocNo = SALHD.FTXshDocNo AND SRC.FTBchCode = SALHD.FTBchCode
                        -- LEFT JOIN (SELECT DISTINCT TFNTCrdTopUpDT.FTBchCode,TFNTCrdTopUpDT.FTCrdCode,TFNTCrdTopUpDT.FTXshDocNo,TFNMCard.FDCrdResetDate
                        --             FROM TFNTCrdTopUpDT
                        --             LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
                        -- ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
                        -- WHERE 1 = 1 AND TOPUPDT.FTXshDocNo = '$tABB' AND TOPUPDT.FTBchCode = '$tBrowseBchCode'  AND ISNULL(FTXshDocVatFull, '') = '' 
                        -- AND SALHD.FDXshDocDate > TOPUPDT.FDCrdResetDate
                        WHERE SALHD.FTXshDocNo IN ($tDocno) AND ISNULL(FTXshDocVatFull, '') = '' 
                         ";
        }
        $this->db->query($tSQL);
    }

    // TPSTSalRD -> TPSTTaxRD 
    public function FSaMTXFMoveSalRD_TaxRD($aPackData){
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tTAXApvType            = $aPackData['tTAXApvType'];
        $tCurretTaxDocNo        = $aPackData['tCurretTaxDocNo'];
        
        $tDocno             = $this->FSaMTXFGetDTFTXshDocNo($tABB);

        if($tTAXApvType == '2' && $tTaxNumberFull != $tCurretTaxDocNo){
            $tSQL       = " INSERT INTO TPSTTaxRD (
                                FTBchCode,FTXshDocNo,FNXrdSeqNo,FTRdhDocType,FNXrdRefSeq,FTXrdRefCode,FCXrdPdtQty,FNXrdPntUse
                            ) SELECT FTBchCode,'$tTaxNumberFull' AS FTXshDocNo,FNXrdSeqNo,FTRdhDocType,FNXrdRefSeq,FTXrdRefCode,FCXrdPdtQty,FNXrdPntUse
                            FROM TPSTTaxRD
                            WHERE FTXshDocNo = '$tCurretTaxDocNo'";
        }else{

            $tSQL       = " INSERT INTO TPSTTaxRD (
                                FTBchCode,FTXshDocNo,FNXrdSeqNo,FTRdhDocType,FNXrdRefSeq,FTXrdRefCode,FCXrdPdtQty,FNXrdPntUse
                            ) SELECT 
                            '$tBrowseBchCode' AS FTBchCode,'$tTaxNumberFull',FNXrdSeqNo,FTRdhDocType,ROW_NUMBER() OVER(ORDER BY SALRD.FTXshDocNo) AS FNXrdRefSeq,FTXrdRefCode,
                            CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FCXrdPdtQty,0) *-(1) ELSE ISNULL(FCXrdPdtQty,0) END FCXrdPdtQty,
                            CASE WHEN SALHD.FNXshDocType = 9 THEN ISNULL(FNXrdPntUse,0) *-(1) ELSE ISNULL(FNXrdPntUse,0) END FNXrdPntUse
                            FROM TPSTSalRD SALRD
                            LEFT JOIN TPSTSalHD SALHD WITH (NOLOCK) ON SALRD.FTBchCode = SALHD.FTBchCode AND SALRD.FTXshDocNo = SALHD.FTXshDocNo
                            -- LEFT JOIN ( SELECT DISTINCT FTBchCode,FTXshDocNo,MIN(FTXrcRefNo1) AS FTXrcRefNo1 FROM TPSTSalRC
                            --             LEFT JOIN TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
                            --             WHERE TFNMRcv.FTFmtCode = '011'
                            --             GROUP BY FTBchCode,FTXshDocNo
                            -- ) SRC ON SRC.FTXshDocNo = SALHD.FTXshDocNo AND SRC.FTBchCode = SALHD.FTBchCode
                            -- LEFT JOIN (SELECT DISTINCT TFNTCrdTopUpDT.FTBchCode,TFNTCrdTopUpDT.FTCrdCode,TFNTCrdTopUpDT.FTXshDocNo,TFNMCard.FDCrdResetDate
                            --             FROM TFNTCrdTopUpDT
                            --             LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
                            -- ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
                            -- WHERE 1 = 1 AND TOPUPDT.FTXshDocNo = '$tABB' AND TOPUPDT.FTBchCode = '$tBrowseBchCode' AND ISNULL(FTXshDocVatFull, '') = '' 
                            -- AND SALHD.FDXshDocDate > TOPUPDT.FDCrdResetDate
                            WHERE SALHD.FTXshDocNo IN ($tDocno) AND ISNULL(FTXshDocVatFull, '') = '' 
                            ";
        }
        $this->db->query($tSQL);
    }

    //อัพเดท ว่าเอกสารนี้ถูกใช้งานเเล้ว
    public function FSaMTXFUpdateDocVatFull($aPackData){
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $dDocDate           = $aPackData['dDocDate'];
        $dDocTime           = $aPackData['dDocTime'];
        $dDateCurrent       = date('Y-m-d H:i:s');
        $tNameTask          = $this->session->userdata('tSesUsername');

        $tDocno             = $this->FSaMTXFGetDTFTXshDocNo($tABB);

        $tSQL       = " UPDATE TPSTSalHD SET FTXshDocVatFull = '$tTaxNumberFull' , FDLastUpdOn = '$dDateCurrent' , FTLastUpdBy = '$tNameTask' 
                        FROM TPSTSalHD SALHD
                        -- LEFT JOIN ( SELECT DISTINCT FTBchCode,FTXshDocNo,MIN(FTXrcRefNo1) AS FTXrcRefNo1 FROM TPSTSalRC
                        --             LEFT JOIN TFNMRcv ON TPSTSalRC.FTRcvCode = TFNMRcv.FTRcvCode
                        --             WHERE TFNMRcv.FTFmtCode = '011'
                        --             GROUP BY FTBchCode,FTXshDocNo
                        --             ) SRC ON SRC.FTXshDocNo = SALHD.FTXshDocNo AND SRC.FTBchCode = SALHD.FTBchCode
                        -- LEFT JOIN (SELECT DISTINCT TFNTCrdTopUpDT.FTBchCode,TFNTCrdTopUpDT.FTCrdCode,TFNTCrdTopUpDT.FTXshDocNo,TFNMCard.FDCrdResetDate
                        --             FROM TFNTCrdTopUpDT
                        --             LEFT JOIN TFNMCard ON TFNTCrdTopUpDT.FTCrdCode = TFNMCard.FTCrdCode
                        --             ) TOPUPDT ON TOPUPDT.FTCrdCode = SRC.FTXrcRefNo1
                        --             WHERE 1 = 1 AND TOPUPDT.FTXshDocNo = '$tABB' AND TOPUPDT.FTBchCode = '$tBrowseBchCode' AND ISNULL(SALHD.FTXshDocVatFull, '') = '' 
                        --             AND SALHD.FDXshDocDate > TOPUPDT.FDCrdResetDate 
                        WHERE SALHD.FTXshDocNo IN ($tDocno) AND ISNULL(FTXshDocVatFull, '') = '' 
                                    
                                    ";
        $this->db->query($tSQL);
        $tSQL       = " UPDATE TFNTCrdTopUpHD SET FTXshRefInt = '$tTaxNumberFull' , FDXshRefIntDate= '$dDateCurrent' , FDLastUpdOn = '$dDateCurrent' , FTLastUpdBy = '$tNameTask'  WHERE FTXshDocNo = '$tABB' AND FTBchCode = '$tBrowseBchCode'  ";
         $this->db->query($tSQL);

        $tSQL       = " UPDATE TPSTTaxHD SET 
                            FTXshDocVatFull = '$tTaxNumberFull' , 
                            FDLastUpdOn = '$dDateCurrent' , 
                            FTLastUpdBy = '$tNameTask' 
                        WHERE FTXshDocNo = '$tTaxNumberFull' AND FTBchCode = '$tBrowseBchCode' ";
        $this->db->query($tSQL);
    }

    //เพิ่มข้อมูลที่อยู่ใหม่
    public function FSaMTXFInsertTaxAddress($aPackData){
        // $nLngID             = $this->session->userdata("tLangEdit");
        // $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        // $FTAddTaxNo         = $aPackData['tTaxnumber'];
        // $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        // $FTCstCode          = $aPackData['tCstCode'];
        // $FTAddName          = $aPackData['tCstNameABB'];
        // $FTAddVersion       = 2;
        // $FTAddV2Desc1       = $aPackData['tAddress1'];
        // $FTAddV2Desc2       = $aPackData['tAddress2'];
        // $FTAddStaBusiness   = $aPackData['tTypeBusiness'];
        // $FTAddStaHQ         = $aPackData['tBusiness'];
        // $FTAddStaBchCode    = $aPackData['tBranch'];
        // $FTAddTel           = $aPackData['tTel'];
        // $FTAddFax           = $aPackData['tFax'];
        // $FNAddSeqNo         = $aPackData['tSeqAddress'];
        // $FDLastUpdOn        = date('Y-m-d H:i:s');
        // $FTLastUpdBy        = $this->session->userdata('tSesUsername');
        // $FDCreateOn         = date('Y-m-d H:i:s');
        // $FTCreateBy         = $this->session->userdata('tSesUsername');


        // //วิ่งเข้าไปเช็ค 3 Key ว่า ตรงไหม FTAddTaxNo / FNAddSeqNo / FTAddStaBchCode
        // $tSQL   = "SELECT * FROM  TCNMTaxAddress_L Tax WITH (NOLOCK) WHERE 1=1 
        //           AND ISNULL(Tax.FTAddTaxNo,'') = '$FTAddTaxNo'
        //           AND ISNULL(Tax.FNAddSeqNo,'') = '$FNAddSeqNo'
        //           AND ISNULL(Tax.FTAddStaBchCode,'') = '$FTAddStaBchCode' ";
        // $oQuery = $this->db->query($tSQL);
        // // echo $this->db->last_query();
        // // die();
        // if ($oQuery->num_rows() > 0) {
        //     $tStatusFound = 'Found'; //found -> update address
        // }else{
        //     $tStatusFound = 'NotFound'; //not found -> insert address
        // }

        // if($tStatusFound == 'Found'){
        //     //Update
        //     $tSQL       = " UPDATE TCNMTaxAddress_L SET 
        //                         FNLngID = '$nLngID',
        //                         FTCstCode = '$FTCstCode',
        //                         FTAddName = '$FTAddName', 
        //                         FTAddVersion = '$FTAddVersion',
        //                         FTAddV2Desc1 = '$FTAddV2Desc1', 
        //                         FTAddV2Desc2 = '$FTAddV2Desc2', 
        //                         FTAddStaBusiness = '$FTAddStaBusiness',
        //                         FTAddStaHQ = '$FTAddStaHQ', 
        //                         FTAddTel = '$FTAddTel',
        //                         FTAddFax = '$FTAddFax',
        //                         FDLastUpdOn = '$FDLastUpdOn', 
        //                         FTLastUpdBy = '$FTLastUpdBy'
        //                     WHERE 1=1 
        //                     AND FTAddTaxNo = '$FTAddTaxNo'
        //                     AND FNAddSeqNo = '$FNAddSeqNo'
        //                     AND FTAddStaBchCode = '$FTAddStaBchCode' ";
        //     $this->db->query($tSQL);
        //     $nSeqLast = $FNAddSeqNo;
        // }else{
        //     //Insert
        //     $tSQL       = "INSERT INTO TCNMTaxAddress_L (
        //                         FTAddTaxNo , FNLngID , 
        //                         FTCstCode , FTAddName , FTAddVersion ,
        //                         FTAddV2Desc1 , FTAddV2Desc2 , FTAddStaBusiness ,
        //                         FTAddStaHQ , FTAddStaBchCode , FTAddTel , FTAddFax ,
        //                         FDLastUpdOn , FTLastUpdBy , FDCreateOn , FTCreateBy 
        //                     )
        //                     VALUES (
        //                         '$FTAddTaxNo' , '$nLngID' , 
        //                         '$FTCstCode' , '$FTAddName' , '$FTAddVersion' ,
        //                         '$FTAddV2Desc1' , '$FTAddV2Desc2' , '$FTAddStaBusiness' ,
        //                         '$FTAddStaHQ' , '$FTAddStaBchCode' , '$FTAddTel' , '$FTAddFax' ,
        //                         '$FDLastUpdOn' , '$FTLastUpdBy' , '$FDCreateOn' , '$FTCreateBy' 
        //                     )";
        //                     $this->db->query($tSQL);

        //     //หาข้อมูลว่า SEQ ที่เพิ่มเข้าไปใช้อะไร
        //     $tSQL       = "SELECT TOP 1 FNAddSeqNo FROM TCNMTaxAddress_L WHERE FTAddTaxNo = '$FTAddTaxNo' ORDER BY FNAddSeqNo DESC";
        //     $oQuery     = $this->db->query($tSQL);
        //     $aResult    = $oQuery->result();
        //     $nSeqLast   = $aResult[0]->FNAddSeqNo;
        // }

        // //อัพเดทข้อมูล SEQ -> TPSTTaxHDCst
        // $tSQL       = "UPDATE TPSTTaxHDCst SET FTXshAddrTax = '$nSeqLast' WHERE FTXshDocNo = '$tTaxNumberFull' AND FTBchCode = '$tBrowseBchCode' ";
        // $this->db->query($tSQL);
        $nLngID             = $this->session->userdata("tLangEdit");
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tTaxBchCode        = $aPackData['tTaxBchCode'];
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $FTAddTaxNo         = $aPackData['tTaxnumber'];
        $FTCstCode          = $aPackData['tCstCode'];
        $FTAddName          = $aPackData['tCstNameABB'];
        // $FTAddVersion       = $aPackData['tAddVersion'];;
        $FTAddV2Desc1       = $aPackData['tAddress1'];
        $FTAddV2Desc2       = $aPackData['tAddress2'];
        $FTAddStaBusiness   = $aPackData['tTypeBusiness'];
        $FTAddStaHQ         = $aPackData['tBusiness'];
        $FTAddStaBchCode    = $aPackData['tBranch'];
        $FTAddTel           = $aPackData['tTel'];
        $FTAddFax           = $aPackData['tFax'];
        // $FNAddSeqNo         = $aPackData['tSeqAddress'];
        $FDLastUpdOn        = date('Y-m-d H:i:s');
        $FTLastUpdBy        = $this->session->userdata('tSesUsername');
        $FDCreateOn         = date('Y-m-d H:i:s');
        $FTCreateBy         = $this->session->userdata('tSesUsername');

        // $FTAddV1No          = $aPackData['tAddV1No'];
        // $FTAddV1Soi         = $aPackData['tAddV1Soi'];
        // $FTAddV1Village     = $aPackData['tAddV1Village'];
        // $FTAddV1Road        = $aPackData['tAddV1Road'];



        //วิ่งเข้าไปเช็ค 3 Key ว่า ตรงไหม FTAddTaxNo / FNAddSeqNo / FTAddStaBchCode
        $tSQL   = "SELECT Tax.FTAddTaxNo FROM  TCNMTaxAddress_L Tax WITH (NOLOCK) WHERE 1=1
                  AND Tax.FTAddTaxNo = '$FTAddTaxNo'
                  AND Tax.FNLngID = $nLngID ";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $tStatusFound = 'Found'; //found -> update address
        }else{
            $tStatusFound = 'NotFound'; //not found -> insert address
        }

        $aPackData = array(
            'FTCstCode'         => $FTCstCode,
            'FTAddName'         => $FTAddName,
            'FTAddVersion'      => '2',
            'FTAddStaBusiness'  => $FTAddStaBusiness,
            'FTAddTel'          => $FTAddTel,
            'FTAddFax'          => $FTAddFax,
            'FDLastUpdOn'       => $FDLastUpdOn,
            'FTLastUpdBy'       => $FTLastUpdBy,
            'FTAddStaBchCode'   => '',
            'FTAddStaHQ'        => '',
            'FTAddV2Desc1'      => $FTAddV2Desc1,
            'FTAddV2Desc2'      => $FTAddV2Desc2
        );

        // $this->db->set('FTCstCode',$FTCstCode);
        // $this->db->set('FTAddName',$FTAddName);
        // $this->db->set('FTAddVersion','2');

        // $this->db->set('FTAddStaBusiness',$FTAddStaBusiness);
        if( $FTAddStaBusiness == '1' ){
            $aPackData['FTAddStaBchCode']   = $FTAddStaBchCode;
            $aPackData['FTAddStaHQ']        = $FTAddStaHQ;
            // $this->db->set('FTAddStaBchCode',$FTAddStaBchCode);
            // $this->db->set('FTAddStaHQ',$FTAddStaHQ);
        }
        // else{
            // $this->db->set('FTAddStaBchCode','');
            // $this->db->set('FTAddStaHQ','');
        // }

        // $this->db->set('FTAddTel',$FTAddTel);
        // $this->db->set('FTAddFax',$FTAddFax);
        // $this->db->set('FDLastUpdOn',$FDLastUpdOn);
        // $this->db->set('FTLastUpdBy',$FTLastUpdBy);

        // if( $FTAddVersion == '1' ){
            // $this->db->set('FTAddV1No',$FTAddV1No);
            // $this->db->set('FTAddV1Soi',$FTAddV1Soi);
            // $this->db->set('FTAddV1Village',$FTAddV1Village);
            // $this->db->set('FTAddV1Road',$FTAddV1Road);
            // $this->db->set('FTAddV1SubDist',$FTAddV1SubDist);
            // $this->db->set('FTAddV1DstCode',$FTAddV1DstCode);
            // $this->db->set('FTAddV1PvnCode',$FTAddV1PvnCode);
            // $this->db->set('FTAddV1PostCode',$FTAddV1PostCode);
        // }else{
            // $this->db->set('FTAddV2Desc1',$FTAddV2Desc1);
            // $this->db->set('FTAddV2Desc2',$FTAddV2Desc2);
        // }

        if($tStatusFound == 'Found'){
            // // Update
            // if( $FTAddVersion == '1' ){
            //     $this->db->set('FTAddV2Desc1','');
            //     $this->db->set('FTAddV2Desc2','');
            // }else{
            //     $this->db->set('FTAddV1No','');
            //     $this->db->set('FTAddV1Soi','');
            //     $this->db->set('FTAddV1Village','');
            //     $this->db->set('FTAddV1Road','');
            //     $this->db->set('FTAddV1SubDist','');
            //     $this->db->set('FTAddV1DstCode','');
            //     $this->db->set('FTAddV1PvnCode','');
            //     $this->db->set('FTAddV1PostCode','');
            // }

            $this->db->where('FTAddTaxNo',$FTAddTaxNo);
            $this->db->where('FNLngID',$nLngID);
            $this->db->update('TCNMTaxAddress_L',$aPackData);
        }else{
            //Insert
            $aPackData['FNLngID']       = $nLngID;
            $aPackData['FTAddTaxNo']    = $FTAddTaxNo;
            $aPackData['FDCreateOn']    = $FDCreateOn;
            $aPackData['FTCreateBy']    = $FTCreateBy;

            // $this->db->set('FNLngID',$nLngID);
            // $this->db->set('FTAddTaxNo',$FTAddTaxNo);
            // $this->db->set('FDCreateOn',$FDCreateOn);
            // $this->db->set('FTCreateBy',$FTCreateBy);
            $this->db->insert('TCNMTaxAddress_L',$aPackData);

            //หาข้อมูลว่า SEQ ที่เพิ่มเข้าไปใช้อะไร
            // $tSQL       = "SELECT TOP 1 FNAddSeqNo FROM TCNMTaxAddress_L WHERE FTAddTaxNo = '$FTAddTaxNo' ORDER BY FNAddSeqNo DESC";
            // $oQuery     = $this->db->query($tSQL);
            // $aResult    = $oQuery->result();
            // $nSeqLast   = $aResult[0]->FNAddSeqNo;
        }

        // Insert Address
        unset($aPackData['FNLngID']);
        unset($aPackData['FTCstCode']);

        $aPackData['FTBchCode']  = $tBrowseBchCode;
        // $aPackData['FTBchCode']  = $tTaxBchCode;
        $aPackData['FTXshDocNo'] = $tTaxNumberFull;
        $aPackData['FTAddTaxNo'] = $FTAddTaxNo;
        $aPackData['FDCreateOn'] = $FDCreateOn;
        $aPackData['FTCreateBy'] = $FTCreateBy;
        // $this->db->set('FTBchCode',$tBrowseBchCode);
        // $this->db->set('FTXshDocNo',$tTaxNumberFull);
        $this->db->insert('TPSTTaxHDAddress',$aPackData);

        //อัพเดทข้อมูล SEQ -> TPSTTaxHDCst
        $tSQL       = "UPDATE TPSTTaxHDCst SET FTXshAddrTax = '$FTAddTaxNo' WHERE FTXshDocNo = '$tTaxNumberFull' ";
        $this->db->query($tSQL);
    }

    ///////////////////////////////////// PREVIEW /////////////////////////////////////

    //หาเอกสารที่ HD ถูกอนุมัติเเล้ว
    public function FSaMTXFGetHDTax($ptData){
        $tDocumentNumber    = $ptData['tDocumentNumber'];
        $tBrowseBchCode     = $ptData['tBrowseBchCode'];

        $tSQL   = "SELECT Tax.*  FROM  TPSTTaxHD Tax WITH (NOLOCK) 
                    WHERE 1=1 AND Tax.FTXshDocNo = '$tDocumentNumber' AND Tax.FTBchCode = '$tBrowseBchCode' ";
        $oQuery = $this->db->query($tSQL);
        if($oQuery->num_rows() > 0){
            $oList      = $oQuery->result();
            $aResult    = array(
                'raItems'       => $oList,
                'rtCode'        => '1',
                'rtDesc'        => 'success'
            );
        }else{
            $aResult = array(
                'rtCode'        => '800',
                'rtDesc'        => 'data not found'
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //หาเอกสารที่ DT ถูกอนุมัติเเล้ว
    public function FSaMTXFGetDTTax($ptDocument){
        $tSQL   = "SELECT * FROM  TPSTTaxDT Tax WITH (NOLOCK) WHERE 1=1 AND Tax.FTXshDocNo = '$ptDocument' ";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //หาเอกสารที่ ADDRESS ถูกอนุมัติเเล้ว
    public function FSaMTXFGetAddressTax($ptData){
        $tDocumentNumber    = $ptData['tDocumentNumber'];
        $tBrowseBchCode     = $ptData['tBrowseBchCode'];
        $nFNLngID           = $ptData['FNLngID'];
        // $tSQL   = "SELECT TaxAdd.* , HDCst.FTXshCstName FROM  TPSTTaxHDCst HDCst WITH (NOLOCK) 
        //            LEFT JOIN TCNMTaxAddress_L TaxAdd ON HDCst.FTXshAddrTax = TaxAdd.FNAddSeqNo
        //            WHERE 1=1 AND HDCst.FTXshDocNo = '$tDocumentNumber' AND HDCst.FTBchCode = '$tBrowseBchCode' ";
        $tSQL = "   SELECT 
                    PVN_L.FTPvnCode,
                    PVN_L.FTPvnName,
                    DST_L.FTDstCode,
                    DST_L.FTDstName,
                    SUD_L.FTSudCode,
                    SUD_L.FTSudName,
                    HDADR.FTAddTaxNo        AS FTXshAddrTax,
                    HDADR.FTAddTel          AS FTXshCstTel,
                    HDADR.FTAddFax          AS FTXshFax,
                    HDADR.FTAddV1PostCode   AS FTXshPostCode,
                    HDADR.FTAddV2Desc1      AS FTXshDesc1,
                    HDADR.FTAddV2Desc2      AS FTXshDesc2, 
                    HD.FTCstCode            AS FTXshCstCode,
                    CST_L.FTCstName         AS FTXshCstName,
                   -- HDADR.FTAddName,
                    HDCST.FTXshCstEmail,
                    HDADR.FTAddName,
                    HDADR.FTAddStaBusiness,
                    HDADR.FTAddStaHQ,
                    HDADR.FTAddStaBchCode
                FROM TPSTTaxHDAddress         HDADR WITH(NOLOCK)
                INNER JOIN TPSTTaxHD             HD WITH(NOLOCK) ON HDADR.FTBchCode = HD.FTBchCode AND HDADR.FTXshDocNo = HD.FTXshDocNo
                LEFT JOIN TPSTTaxHDCst        HDCST WITH(NOLOCK) ON HDADR.FTBchCode = HDCST.FTBchCode AND HDADR.FTXshDocNo = HDCST.FTXshDocNo
                LEFT JOIN TCNMProvince_L      PVN_L WITH(NOLOCK) ON HDADR.FTAddV1PvnCode = PVN_L.FTPvnCode AND PVN_L.FNLngID = $nFNLngID
                LEFT JOIN TCNMDistrict_L      DST_L WITH(NOLOCK) ON HDADR.FTAddV1DstCode = DST_L.FTDstCode AND DST_L.FNLngID = $nFNLngID
                LEFT JOIN TCNMSubDistrict_L   SUD_L WITH(NOLOCK) ON HDADR.FTAddV1SubDist = SUD_L.FTSudCode AND SUD_L.FNLngID = $nFNLngID
                LEFT JOIN TCNMCst_L      CST_L WITH(NOLOCK) ON HD.FTCstCode = CST_L.FTCstCode AND CST_L.FNLngID = $nFNLngID
                WHERE 1 = 1
                    AND HDADR.FTXshDocNo = '$tDocumentNumber'
                    AND HDADR.FTBchCode  = '$tBrowseBchCode' 
            ";
        // print_r($tSQL);
        $oQuery = $this->db->query($tSQL);

     
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //อนุญาติว่า ปริ้น from ได้กี่ใบ
    public function FSaMTXFGetConfig(){
        $tSQL   = "SELECT FTSysStaUsrValue , FTSysStaUsrRef FROM TSysConfig WHERE FTSysCode = 'nPS_PrnTax' AND FTSysKEY = 'Tax'";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }

    public function FSaMTXFUpdateWhenApprove($aWhere,$aSet,$ptType){
        $FTAddName          = $aSet['FTAddName'];
        $FTAddTel           = $aSet['FTAddTel'];
        $FTAddFax           = $aSet['FTAddFax'];
        $FTAddV2Desc1       = $aSet['FTAddV2Desc1'];
        $FTAddV2Desc2       = $aSet['FTAddV2Desc2'];
        $dDateCurrent       = date('Y-m-d H:i:s');
        $tNameTask          = $this->session->userdata('tSesUsername');
        $FNAddSeqNo         = $aWhere['FNAddSeqNo'];
        $tDocumentNo        = $aSet['tDocumentNo'];
        $tBrowseBchCode        = $aSet['tBrowseBchCode'];
        $nLngID             = $this->session->userdata("tLangEdit");


        if($ptType == 'UPDATEADDRESS'){
        //     // $tSQL   = " UPDATE TCNMTaxAddress_L 
        //     //         SET FTAddName = '$FTAddName' , 
        //     //             FTAddTel = '$FTAddTel' ,
        //     //             FTAddFax  = '$FTAddFax' ,
        //     //             FTAddV2Desc1 = '$FTAddV2Desc1',
        //     //             FTAddV2Desc2 = '$FTAddV2Desc2',
        //     //             FDLastUpdOn = '$dDateCurrent' , 
        //     //             FTLastUpdBy = '$tNameTask' 
        //     //         WHERE FNAddSeqNo = '$FNAddSeqNo' ";
        }else{

            $tNumberTax             = $aSet['tNumberTax'];
            $tNumberTaxNew          = $aSet['tNumberTaxNew'];
            $tTypeBusiness          = $aSet['tTypeBusiness'];
            $tBusiness              = $aSet['tBusiness'];
            $tBchCode               = $aSet['tBchCode'];
            $tCstCode               = $aSet['tCstCode'];
            $tCstName               = $aSet['tCstName'];

            $tSQLFind   = "SELECT TOP 1 FNAddSeqNo FROM TCNMTaxAddress_L WHERE FTAddTaxNo = '$tNumberTax' ";
            $oQuery     = $this->db->query($tSQLFind);
            if ($oQuery->num_rows() > 0) {
                $tFindAddress   = 1;
        //         $aResult        = $oQuery->result();
        //         $nSeqLast       = $aResult[0]->FNAddSeqNo;
            }else{
                $tFindAddress   = 0;
            }

            if($tFindAddress == 1){

                if($tCstCode == '' || $tCstCode == null){
                    $tSQL       = " UPDATE TPSTTaxHDCst SET FTXshAddrTax = '$tNumberTax' WHERE FTXshDocNo = '$tDocumentNo' AND FTBchCode='$tBrowseBchCode' ";
                }else{
                    $tSQL       = " UPDATE TPSTTaxHDCst SET FTXshAddrTax = '$tNumberTax' , FTXshCstName  = '$tCstName' WHERE FTXshDocNo = '$tDocumentNo' AND FTBchCode='$tBrowseBchCode' ";
                }

                $tSQLADD    = " UPDATE TCNMTaxAddress_L 
                                SET FTAddName = '$FTAddName' , 
                                    FTAddTel = '$FTAddTel' ,
                                    FTAddFax  = '$FTAddFax' ,
                                    FTAddV2Desc1 = '$FTAddV2Desc1',
                                    FTAddV2Desc2 = '$FTAddV2Desc2',
                                    FDLastUpdOn = '$dDateCurrent' , 
                                    FTAddStaHQ = '$tBusiness',
                                    FTAddStaBchCode = '$tBchCode',
                                    FTAddStaBusiness =  '$tTypeBusiness',
                                    FTLastUpdBy = '$tNameTask' 
                                WHERE FNAddSeqNo = '$tNumberTax' ";
                $this->db->query($tSQLADD);
            }else{  
                //Insert
                $tSQLIns = "INSERT INTO TCNMTaxAddress_L (
                    FTAddTaxNo , FNLngID ,
                    FTCstCode , FTAddName , FTAddVersion ,
                    FTAddV2Desc1 , FTAddV2Desc2 , FTAddStaBusiness ,
                    FTAddStaHQ , FTAddStaBchCode , FTAddTel , FTAddFax ,
                    FDLastUpdOn , FTLastUpdBy , FDCreateOn , FTCreateBy
                )
                VALUES (
                    '$tNumberTax' , '$nLngID' ,
                    '$tCstCode' , '$FTAddName' , '2' ,
                    '$FTAddV2Desc1' , '$FTAddV2Desc2' , '$tTypeBusiness' ,
                    '$tBusiness' , '$tBchCode' , '$FTAddTel' , '$FTAddFax' ,
                    '$dDateCurrent' , '$tNameTask' , '$dDateCurrent' , '$tNameTask'
                )";
                $this->db->query($tSQLIns);

                //หาข้อมูลว่า SEQ ที่เพิ่มเข้าไปใช้อะไร
                // $tSQL       = "SELECT TOP 1 FNAddSeqNo FROM TCNMTaxAddress_L WHERE FTAddTaxNo = '$tNumberTax' ORDER BY FNAddSeqNo DESC";
                // $oQuery     = $this->db->query($tSQL);
                // $aResult    = $oQuery->result();
                // $nSeqLast   = $aResult[0]->FNAddSeqNo;

                if($tCstCode == '' || $tCstCode == null){
                    $tSQL       = " UPDATE TPSTTaxHDCst SET FTXshAddrTax = '$tNumberTax' WHERE FTXshDocNo = '$tDocumentNo' AND FTBchCode='$tBrowseBchCode' ";
                }else{
                    $tSQL       = " UPDATE TPSTTaxHDCst SET FTXshAddrTax = '$tNumberTax' , FTXshCstName  = '$tCstName' WHERE FTXshDocNo = '$tDocumentNo' AND FTBchCode='$tBrowseBchCode' ";
                }
            }
        };
        $this->db->query($tSQL);

              // $FTAddName          = $aSet['FTAddName'];
        // $FTAddTel           = $aSet['FTAddTel'];
        // $FTAddFax           = $aSet['FTAddFax'];
        // $FTAddV2Desc1       = $aSet['FTAddV2Desc1'];
        // $FTAddV2Desc2       = $aSet['FTAddV2Desc2'];
        $dDateCurrent       = date('Y-m-d H:i:s');
        $tNameTask          = $this->session->userdata('tSesUsername');
        // $FNAddSeqNo         = $aWhere['FNAddSeqNo'];
        $tDocumentNo        = $aSet['tDocumentNo'];
        $tBrowseBchCode     = $aSet['tBrowseBchCode'];
        // $nLngID             = $this->session->userdata("tLangEdit");


        // if($ptType == 'UPDATEADDRESS'){
            // $tSQL   = " UPDATE TCNMTaxAddress_L
            //         SET FTAddName = '$FTAddName' ,
            //             FTAddTel = '$FTAddTel' ,
            //             FTAddFax  = '$FTAddFax' ,
            //             FTAddV2Desc1 = '$FTAddV2Desc1',
            //             FTAddV2Desc2 = '$FTAddV2Desc2',
            //             FDLastUpdOn = '$dDateCurrent' ,
            //             FTLastUpdBy = '$tNameTask'
            //         WHERE FNAddSeqNo = '$FNAddSeqNo' ";
        // }else{

            // $tNumberTax             = $aSet['tNumberTax'];
            // $tNumberTaxNew          = $aSet['tNumberTaxNew'];
            // $tTypeBusiness          = $aSet['tTypeBusiness'];
            // $tBusiness              = $aSet['tBusiness'];
            // $tBchCode               = $aSet['tBchCode'];
            // $tCstCode               = $aSet['tCstCode'];
            // $tCstName               = $aSet['tCstName'];

            // $tPvnCode               = $aSet['tPvnCode'];
            // $tDstCode               = $aSet['tDstCode'];
            // $tSubDistCode           = $aSet['tSubDistCode'];
            // $tPostCode              = $aSet['tPostCode'];
            // $tEmail                 = $aSet['tEmail'];

            // $tSQLFind   = "SELECT TOP 1 FTAddTaxNo FROM TCNMTaxAddress_L WITH(NOLOCK) WHERE FTAddTaxNo = '$tNumberTax' ";
            // $oQuery     = $this->db->query($tSQLFind);
            // if ($oQuery->num_rows() > 0) {
            //     $tFindAddress   = 1;
            //     // $aResult        = $oQuery->result();
            //     // $nSeqLast       = $aResult[0]->FNAddSeqNo;
            // }else{
            //     $tFindAddress   = 0;
            // }

            // Update HD Cst
            // if( $tCstCode == '' || $tCstCode == null ){
            //     $tSQL       = " UPDATE TPSTTaxHDCst SET FTXshAddrTax = '$tNumberTax', FTXshCstEmail = '$tEmail'  WHERE FTXshDocNo = '$tDocumentNo' AND FTBchCode = '$tBrowseBchCode' ";
            // }else{
            //     $tSQL       = " UPDATE TPSTTaxHDCst SET FTXshAddrTax = '$tNumberTax', FTXshCstEmail = '$tEmail', FTXshCstName  = '$tCstName' WHERE FTXshDocNo = '$tDocumentNo' AND FTBchCode = '$tBrowseBchCode' ";
            // }
            // $this->db->query($tSQL);

            // Update Remark, StaAct
            $tRemark    = $aSet['tRemark'];
            $nStaDocAct = $aSet['nStaDocAct'];
            $tSQLHD = " UPDATE TPSTTaxHD 
                        SET FTXshRmk        = '$tRemark',
                            FNXshStaDocAct  = '$nStaDocAct',
                            FDLastUpdOn     = '$dDateCurrent',
                            FTLastUpdBy     = '$tNameTask'
                        WHERE FTXshDocNo = '$tDocumentNo' 
                          AND FTBchCode  = '$tBrowseBchCode' 
                      ";
            $this->db->query($tSQLHD);

            // Update Transection Address Tax
            // $tSQLHDAddr = " UPDATE TPSTTaxHDAddress 
            //                 SET FTAddTaxNo          = '$tNumberTax',
            //                     FTAddName           = '$FTAddName',
            //                     FTAddTel            = '$FTAddTel',
            //                     FTAddFax            = '$FTAddFax',
            //                     FTAddV2Desc1        = '$FTAddV2Desc1',
            //                     FTAddV2Desc2        = '$FTAddV2Desc2',
            //                     FTAddStaHQ          = '$tBusiness',
            //                     FTAddStaBchCode     = '$tBchCode',
            //                     FTAddStaBusiness    = '$tTypeBusiness',

            //                     FTAddV1PvnCode      = '$tPvnCode',
            //                     FTAddV1DstCode      = '$tDstCode',
            //                     FTAddV1SubDist      = '$tSubDistCode',
            //                     FTAddV1PostCode     = '$tPostCode',

            //                     FDLastUpdOn         = '$dDateCurrent',
            //                     FTLastUpdBy         = '$tNameTask' 
            //                 WHERE FTXshDocNo = '$tDocumentNo' 
            //                   AND FTBchCode  = '$tBrowseBchCode'
            //               ";
            // $this->db->query($tSQLHDAddr);

            // if( $tFindAddress == 1 ){

            //     // Update Master Tax Address
            //     $tSQLADD    = " UPDATE TCNMTaxAddress_L
            //                     SET FTAddName = '$FTAddName' ,
            //                         FTAddTel = '$FTAddTel' ,
            //                         FTAddFax  = '$FTAddFax' ,
            //                         FTAddV2Desc1 = '$FTAddV2Desc1',
            //                         FTAddV2Desc2 = '$FTAddV2Desc2',
            //                         FTAddStaHQ = '$tBusiness',
            //                         FTAddStaBchCode = '$tBchCode',
            //                         FTAddStaBusiness =  '$tTypeBusiness',

            //                         FTAddV1PvnCode = '$tPvnCode',
            //                         FTAddV1DstCode = '$tDstCode',
            //                         FTAddV1SubDist = '$tSubDistCode',
            //                         FTAddV1PostCode = '$tPostCode',

            //                         FDLastUpdOn = '$dDateCurrent' ,
            //                         FTLastUpdBy = '$tNameTask'

            //                     WHERE FTAddTaxNo = '$tNumberTax' ";
            //     $this->db->query($tSQLADD);

            // }else{

            //     // Insert Master Tax Address
            //     $tSQLIns = "INSERT INTO TCNMTaxAddress_L (
            //                     FTAddTaxNo , FNLngID ,
            //                     FTCstCode , FTAddName , FTAddVersion ,
            //                     FTAddV2Desc1 , FTAddV2Desc2 , FTAddStaBusiness ,
            //                     FTAddStaHQ , FTAddStaBchCode , FTAddTel , FTAddFax ,
            //                     FTAddV1PvnCode, FTAddV1DstCode, FTAddV1SubDist, FTAddV1PostCode, 
            //                     FDLastUpdOn , FTLastUpdBy , FDCreateOn , FTCreateBy
            //                 ) VALUES (
            //                     '$tNumberTax' , '$nLngID' ,
            //                     '$tCstCode' , '$FTAddName' , '2' ,
            //                     '$FTAddV2Desc1' , '$FTAddV2Desc2' , '$tTypeBusiness' ,
            //                     '$tBusiness' , '$tBchCode' , '$FTAddTel' , '$FTAddFax' ,
            //                     '$tPvnCode', '$tDstCode', '$tSubDistCode', '$tPostCode', 
            //                     '$dDateCurrent' , '$tNameTask' , '$dDateCurrent' , '$tNameTask'
            //                 ) ";
            //     $this->db->query($tSQLIns);

            // }
        // }
        
    }

    //ข้อมูลการขาย DT
    public function FSaMTXFGetDTInTax($paData){
        $aRowLen            = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
        $tDocumentNumber    = $paData['tDocumentNumber'];
        $tBrowseBchCode     = $paData['tBrowseBchCode'];
        $tSQL       = "SELECT c.* FROM(
                        SELECT  ROW_NUMBER() OVER(ORDER BY FTXshDocNo DESC) AS FNRowID,* FROM
                            (SELECT DISTINCT
                                    DTDis.DISPMT , SALDT.FTBchCode , SALDT.FTXshDocNo , SALDT.FNXsdSeqNo , FTPdtCode , FTXsdPdtName ,
                                    FTPunCode , FTPunName , FCXsdFactor , FTXsdBarCode , FTSrnCode ,
                                    FTXsdVatType , FTVatCode , FTPplCode , FCXsdVatRate , FTXsdSaleType ,
                                    FCXsdSalePrice , FCXsdQty , FCXsdQtyAll , FCXsdSetPrice , FCXsdAmtB4DisChg ,
                                    FTXsdDisChgTxt , FCXsdDis , FCXsdChg , FCXsdNet , FCXsdNetAfHD ,
                                    FCXsdVat , FCXsdVatable , FCXsdWhtAmt , FTXsdWhtCode , FCXsdWhtRate ,
                                    FCXsdCostIn , FCXsdCostEx , FTXsdStaPdt , FCXsdQtyLef , FCXsdQtyRfn ,
                                    FTXsdStaPrcStk , FTXsdStaAlwDis , FNXsdPdtLevel , FTXsdPdtParent , FCXsdQtySet ,
                                    FTPdtStaSet , FTXsdRmk , FDLastUpdOn , FTLastUpdBy , FDCreateOn , FTCreateBy
                            FROM TPSTTaxDT SALDT WITH (NOLOCK)
                            LEFT JOIN ( SELECT SUM(FCXddValue) as DISPMT , FNXsdSeqNo FROM TPSTTaxDTDis 
                                        WHERE FNXddStaDis = 2 AND FTXddDisChgType IN ('1','2') AND ISNULL(FTXddRefCode,'') <> ''
                                        AND TPSTTaxDTDis.FTXshDocNo = '$tDocumentNumber'
                                        AND TPSTTaxDTDis.FTBchCode = '$tBrowseBchCode'
                                        GROUP BY FNXsdSeqNo
                                    ) DTDis ON DTDis.FNXsdSeqNo = SALDT.FNXsdSeqNo
                            WHERE 1=1 AND SALDT.FTXshDocNo = '$tDocumentNumber'  AND SALDT.FTBchCode = '$tBrowseBchCode'  ";

        //ค้นหาแบบพิเศษ
        @$tSearchPDT   = $paData['tSearchPDT'];
        $tSQL .= "  AND ((SALDT.FTXshDocNo LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTPdtCode LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTXsdPdtName LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTPunName LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTXsdBarCode LIKE '%$tSearchPDT%') 
                        OR (SALDT.FCXsdQty LIKE '%$tSearchPDT%') 
                        OR (SALDT.FCXsdSetPrice LIKE '%$tSearchPDT%') 
                        OR (SALDT.FCXsdNetAfHD LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTBchCode LIKE '%$tSearchPDT%')
                    )";

        $tSQL .= ") Base) AS c WHERE c.FNRowID > $aRowLen[0] AND c.FNRowID <= $aRowLen[1]";

        $oQuery = $this->db->query($tSQL);
        if($oQuery->num_rows() > 0){
            $oList      = $oQuery->result();
            $aFoundRow  = $this->FSnMTXFGetDTPageAllInTax($paData);
            $nFoundRow  = $aFoundRow[0]->counts;
            $nPageAll   = ceil($nFoundRow/$paData['nRow']);
            $aResult    = array(
                'raItems'       => $oList,
                'rnAllRow'      => $nFoundRow,
                'rnCurrentPage' => $paData['nPage'],
                'rnAllPage'     => $nPageAll,
                'rtCode'        => '1',
                'rtDesc'        => 'success'
            );
        }else{
            $aResult = array(
                'rnAllRow'      => 0,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage"     => 0,
                'rtCode'        => '800',
                'rtDesc'        => 'data not found'
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //หาจำนวนการขาย DT
    public function FSnMTXFGetDTPageAllInTax($paData){
        $tDocumentNumber    = $paData['tDocumentNumber'];
        $tBrowseBchCode    = $paData['tBrowseBchCode'];
        $tSQL   = " SELECT COUNT (SALDT.FTXshDocNo) AS counts FROM TPSTTaxDT SALDT WITH (NOLOCK) WHERE 1=1 AND FTXshDocNo = '$tDocumentNumber'  AND FTBchCode = '$tBrowseBchCode' ";

        //ค้นหาแบบพิเศษ
        @$tSearchPDT   = $paData['tSearchPDT'];
        $tSQL   .= "  AND ((SALDT.FTXshDocNo LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTPdtCode LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTXsdPdtName LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTPunName LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTXsdBarCode LIKE '%$tSearchPDT%') 
                        OR (SALDT.FCXsdQty LIKE '%$tSearchPDT%') 
                        OR (SALDT.FCXsdSetPrice LIKE '%$tSearchPDT%') 
                        OR (SALDT.FCXsdNetAfHD LIKE '%$tSearchPDT%') 
                        OR (SALDT.FTBchCode LIKE '%$tSearchPDT%')
                    )";

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            return false;
        }
    }


    // public function FSxMTXFFindABB($ptDocNoTopUp){
    

    //        $aResult = $this->db->where('FTXshDocNo',$ptDocNoTopUp)->select('FTCrdCode')->get('TFNTCrdTopUpDT')->result_array();


    //             $aDataWhereIn = $this->FSaMTFXMappingArray($aResult,'FTCrdCode');

    //             $Data = $this->db->where_in('FTXrcRefNo1',$aDataWhereIn)->select('FTXshDocNo')->get('TPSTSalRC')->result_array();
    //             print_r($Data);
    //        die();
    // }


    // public function FSaMTFXMappingArray($paData,$ptCalumName){
    //     $aDataArray = array();
    //         if(!empty($paData)){
    //             foreach($paData as $aData){
    //                   $aDataArray[] =   $aData[$ptCalumName];
    //             }
    //         }
    //     return $aDataArray;
    // }

    
    public function FSaMTFXGetDataUsr4Pos($ptUsrCode) {

        $tLang = $this->session->userdata("tLangID");

        $tSQL = "
            SELECT 
                AUT.FTUsrStaActive,
                AUT.FTUsrLogType,
                USR.* 
            FROM (
                SELECT 
                    FTUsrLogType,
                    FTUsrCode,
                    FTUsrStaActive
                FROM TCNMUsrLogin 
                WHERE FTUsrCode = '$ptUsrCode'
                AND CONVERT(VARCHAR(10),FDUsrPwdStart,121) <= CONVERT(VARCHAR(10),GETDATE(),121) 
                AND CONVERT(VARCHAR(10),FDUsrPwdExpired,121) >= CONVERT(VARCHAR(10),GETDATE(),121) 
                AND FTUsrStaActive IN ('1','3')
            ) AUT
            INNER JOIN (
                SELECT 
                    TCNMUser.FTUsrCode, 
                    TCNMUser_L.FTUsrName,
                    TCNMUser.FTDptCode, 
                    --TCNMUser.FTRolCode,
                    TCNMUsrDepart_L.FTDptName, 
                    TCNMImgPerson.FTImgObj
                FROM TCNMUser 
                LEFT JOIN TCNMUser_L ON TCNMUser.FTUsrCode = TCNMUser_L.FTUsrCode AND TCNMUser_L.FNLngID = $tLang 
                LEFT JOIN TCNMUsrDepart_L ON TCNMUsrDepart_L.FTDptCode = TCNMUser.FTDptCode AND TCNMUsrDepart_L.FNLngID = $tLang
                LEFT JOIN TCNMImgPerson ON TCNMUser.FTUsrCode = TCNMImgPerson.FTImgRefID AND TCNMImgPerson.FTImgTable = 'TCNMUser'
            ) USR ON AUT.FTUsrCode = USR.FTUsrCode
        ";


        $oQuery = $this->db->query($tSQL);
        $oList = $oQuery->result_array();
        return $oList;
    }

    //หาที่อยู่ของใบกำกับภาษีในสาขา
    public function FSaMTAXGetBchHD($aPackData){
        $tDocumentNumber = $aPackData['tDocumentNumber'];
        $tSQL            = "SELECT FTBchCode FROM  TPSTSalHD Tax WITH (NOLOCK) WHERE 1=1 AND Tax.FTXshDocNo = '$tDocumentNumber' ";
        $oQuery          = $this->db->query($tSQL);
        if($oQuery->num_rows() > 0){
            $oList      = $oQuery->result();
            $aResult    = array(
                'raItems'       => $oList,
                'rtCode'        => '1',
                'rtDesc'        => 'success'
            );
        }else{
            $aResult = array(
                'rtCode'        => '800',
                'rtDesc'        => 'data not found'
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }




    //ตรวจสอบเลข TaxNo ว่ามีการนำไปออกใบกำกับไปแล้วหรือยัง  if > 0 = มีแล้ว
    public function FSnMTXFCheckDuplicationOnTaxHD($ptXshDocNo,$ptBCHCode){

        if($ptXshDocNo!='false' && $ptXshDocNo!='end' && $ptXshDocNo!=''){
            $nRowsDoc = $this->db->where('FTXshDocNo',$ptXshDocNo)->where('FTBchCode',$ptBCHCode)->get('TPSTTaxHD')->num_rows();
        }else{
            $nRowsDoc = 1;
        }
            if($nRowsDoc> 0 ){
            return 1;
            }else{
            return 0;
            }
    }

    public function FSxMTXFUpdAddrCNFullTax($aPackData){
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tCurretTaxDocNo    = $aPackData['tCurretTaxDocNo'];
        $tOriginTaxDocNo    = $aPackData['tOriginTaxDocNo'];
        $dDocDateTime       = $aPackData['dDocDate'] .' '. $aPackData['dDocTime'];
        $bStaInsert         = false;

        // // เช็คว่าเป็นการยกเลิกครั้งที่ 1 หรือไม่ ?
        // $tSQL = " SELECT FTXshRefInt FROM TPSTTaxHD WITH(NOLOCK) WHERE FTXshDocNo = '$tCurretTaxDocNo' AND FTXshStaDoc = '1' ";
        // $oQuery = $this->db->query($tSQL);
        // if( $oQuery->num_rows() > 0 ){
        //     $tXshRefInt = $oQuery->row_array()['FTXshRefInt']; // ถ้าเป็นการยกเลิกครั้งที่ 1 ให้ดึงเลขที่ ABB Full Tax จาก RefInt ได้เลย
        //     $tSQLDocNoEdit = "      SELECT HD.FTXshDocNo
        //                             FROM TPSTTaxHD HD WITH(NOLOCK)
        //                             WHERE HD.FTXshStaDoc = '4'
        //                             /*AND HD.FTXshRefAE = '$tXshRefInt'*/
        //                             AND ( HD.FTXshRefAE = '$tXshRefInt' OR HD.FTXshRefInt = '$tXshRefInt' )
        //                             AND HD.FTBchCode = '$tBrowseBchCode' 
        //                      ";
        // }else{
        //     // ถ้าไม่ใช่การยกเลิกครั้งที่ 1 เอาเลขที่ใบลดหนี้ต้นฉบับ(FTXshRefAE) ไปหาเลขที่ใบ ABB Full Tax ที่แก้ไขล่าสุด
        //     $tSQLDocNoEdit = "      SELECT HD.FTXshDocNo
        //                             FROM TPSTTaxHD CN WITH(NOLOCK)
        //                             INNER JOIN TPSTTaxHD HD WITH(NOLOCK) ON /*HD.FTXshRefAE = CN.FTXshRefInt*/ ( HD.FTXshRefAE = CN.FTXshRefInt OR HD.FTXshRefInt = CN.FTXshRefInt ) AND HD.FTBchCode = CN.FTBchCode
        //                             WHERE HD.FTXshStaDoc = '4'
        //                             AND CN.FTXshDocNo = '$tOriginTaxDocNo'
        //                             AND CN.FTBchCode = '$tBrowseBchCode'
        //                      ";
        // }

        $tSQL = "   SELECT
                        CNTAX.FTXshRefExt,
                        CNABB.FTXshRefInt,
                        ABB.FTXshDocVatFull
                    FROM TPSTTaxHD			CNTAX WITH(NOLOCK)
                    INNER JOIN TPSTSalHD	CNABB WITH(NOLOCK) ON CNTAX.FTXshRefExt = CNABB.FTXshDocNo AND CNTAX.FTBchCode = CNABB.FTBchCode
                    INNER JOIN TPSTSalHD	  ABB WITH(NOLOCK) ON CNABB.FTXshRefInt = ABB.FTXshDocNo AND CNABB.FTBchCode = ABB.FTBchCode
                    WHERE CNTAX.FTXshDocNo = '$tCurretTaxDocNo'
                      AND CNTAX.FTBchCode  = '$tBrowseBchCode' 
                ";

        $oQuery = $this->db->query($tSQL);
        if( $oQuery->num_rows() > 0 ){
            $bStaInsert = true;
            $tXshDocNoFullTax = $oQuery->row_array()['FTXshDocVatFull'];
        }

        if( $bStaInsert ){

            $tUserCode = $this->session->userdata("tSesUserCode");
            $nFNLngID  = $this->session->userdata("tLangEdit");

            $this->db->where('FTBchCode',$tBrowseBchCode);
            $this->db->where('FTXshDocNo',$tTaxNumberFull);
            $this->db->delete('TPSTTaxHDAddress');

            $tSQL = "   INSERT INTO TPSTTaxHDAddress ( FTBchCode, FTXshDocNo, FTAddTaxNo, FTAddName, 
                        FTAddRmk, FTAddCountry, FTAreCode, FTZneCode, FTAddVersion, FTAddV1No, FTAddV1Soi, 
                        FTAddV1Village, FTAddV1Road, FTAddV1SubDist, FTAddV1DstCode, FTAddV1PvnCode, 
                        FTAddV1PostCode, FTAddV2Desc1, FTAddV2Desc2, FTAddWebsite, FTAddLongitude, FTAddLatitude, 
                        FTAddStaBusiness, FTAddStaHQ, FTAddStaBchCode, FTAddTel, FTAddFax, FTAddRefNo, FDLastUpdOn, 
                        FTLastUpdBy, FDCreateOn, FTCreateBy ) 

                        SELECT FTBchCode, '$tTaxNumberFull', FTAddTaxNo, FTAddName, 
                        FTAddRmk, FTAddCountry, FTAreCode, FTZneCode, FTAddVersion, FTAddV1No, FTAddV1Soi, 
                        FTAddV1Village, FTAddV1Road, FTAddV1SubDist, FTAddV1DstCode, FTAddV1PvnCode, 
                        FTAddV1PostCode, FTAddV2Desc1, FTAddV2Desc2, FTAddWebsite, FTAddLongitude, FTAddLatitude, 
                        FTAddStaBusiness, FTAddStaHQ, FTAddStaBchCode, FTAddTel, FTAddFax, FTAddRefNo, '$dDocDateTime', 
                        FTLastUpdBy, '$dDocDateTime', FTCreateBy 
                        FROM TPSTTaxHDAddress WITH(NOLOCK)
                        WHERE FTXshDocNo = '$tXshDocNoFullTax'
                          AND FTBchCode = '$tBrowseBchCode'
                    ";
            $this->db->query($tSQL);

            // เอาที่อยู่ล่าสุดของ abb-fulltax ไปอัพเดที่ master tax address
            $tSQL = "   UPDATE TADRL
                        SET TADRL.FTAddName         = FULLTAX.FTAddName,
                            TADRL.FTAddV1SubDist    = FULLTAX.FTAddV1SubDist,
                            TADRL.FTAddV1DstCode    = FULLTAX.FTAddV1DstCode,
                            TADRL.FTAddV1PvnCode    = FULLTAX.FTAddV1PvnCode,
                            TADRL.FTAddV1PostCode   = FULLTAX.FTAddV1PostCode,
                            TADRL.FTAddV2Desc1      = FULLTAX.FTAddV2Desc1,
                            TADRL.FTAddV2Desc2      = FULLTAX.FTAddV2Desc2,
                            TADRL.FDLastUpdOn       = '$dDocDateTime',
                            TADRL.FTLastUpdBy       = '$tUserCode'
                        FROM TCNMTaxAddress_L TADRL
                        INNER JOIN TPSTTaxHDAddress FULLTAX ON TADRL.FTAddTaxNo = FULLTAX.FTAddTaxNo
                        WHERE FULLTAX.FTBchCode  = '$tBrowseBchCode'
                          AND FULLTAX.FTXshDocNo = '$tXshDocNoFullTax' 
                          AND TADRL.FNLngID      = $nFNLngID ";
            $this->db->query($tSQL);

            // อัพเดทชื่อลูกค้า จากที่อยู่ล่าสุดของ abb-fulltax
            $tSQL = "   UPDATE CNCST
                        SET CNCST.FTXshCstName = FULLCST.FTXshCstName
                        FROM TPSTTaxHDCst CNCST
                        INNER JOIN TPSTTaxHDCst FULLCST ON FULLCST.FTXshDocNo = '$tXshDocNoFullTax' AND CNCST.FTBchCode = FULLCST.FTBchCode
                        WHERE CNCST.FTBchCode   = '$tBrowseBchCode'
                          AND CNCST.FTXshDocNo  = '$tTaxNumberFull' 
                    ";
            $this->db->query($tSQL);

        }
    }

    public function FSxMTXFUpdAddrABBFullTax($aPackData){
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $dDocDateTime       = $aPackData['dDocDate'] .' '. $aPackData['dDocTime'];
        $tUserCode          = $this->session->userdata("tSesUserCode");
        $nFNLngID           = $this->session->userdata("tLangEdit");

        // เอาที่อยู่ล่าสุดของ abb-fulltax ไปอัพเดที่ master tax address
        $tSQL = "   UPDATE TADRL
                    SET TADRL.FTAddName         = FULLTAX.FTAddName,
                        TADRL.FTAddV1SubDist    = FULLTAX.FTAddV1SubDist,
                        TADRL.FTAddV1DstCode    = FULLTAX.FTAddV1DstCode,
                        TADRL.FTAddV1PvnCode    = FULLTAX.FTAddV1PvnCode,
                        TADRL.FTAddV1PostCode   = FULLTAX.FTAddV1PostCode,
                        TADRL.FTAddV2Desc1      = FULLTAX.FTAddV2Desc1,
                        TADRL.FTAddV2Desc2      = FULLTAX.FTAddV2Desc2,
                        TADRL.FDLastUpdOn       = '$dDocDateTime',
                        TADRL.FTLastUpdBy       = '$tUserCode'
                    FROM TCNMTaxAddress_L TADRL
                    INNER JOIN TPSTTaxHDAddress FULLTAX ON TADRL.FTAddTaxNo = FULLTAX.FTAddTaxNo
                    WHERE FULLTAX.FTBchCode  = '$tBrowseBchCode'
                      AND FULLTAX.FTXshDocNo = '$tTaxNumberFull' 
                      AND TADRL.FNLngID      = $nFNLngID ";
        $this->db->query($tSQL);
    }

      // TPSTSalDTSN -> TPSTTaxDTSN
      public function FSaMTXFMoveSalDTSN_TaxDTSN($aPackData){
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tABB               = $aPackData['tDocABB'];
        $tBranch            = $aPackData['tBrowseBchCode'];

        $tSQL       = " INSERT INTO TPSTTaxDTSN ( FTBchCode,FTXshDocNo,FNXsdSeqNo,FTPdtSerial,FTXsdStaRet,FTPdtBatchID )
                        SELECT '$tBranch','$tTaxNumberFull',FNXsdSeqNo,FTPdtSerial,FTXsdStaRet,FTPdtBatchID
                        FROM TPSTSalDTSN WITH(NOLOCK) 
                        WHERE FTXshDocNo = '$tABB' AND FTBchCode = '$tBranch' ";
        $this->db->query($tSQL);
    }

    public function FSxMTXFUpdateReference($aPackData){
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tTaxNumberFull     = $aPackData['tTaxNumberFull'];
        $tCurretTaxDocNo    = $aPackData['tCurretTaxDocNo'];
        $tOriginTaxDocNo    = $aPackData['tOriginTaxDocNo'];
        $dDocDateTime       = $aPackData['dDocDate'] .' '. $aPackData['dDocTime'];


        if( $tOriginTaxDocNo == "" ){
            $tOriginTaxDocNo = $tCurretTaxDocNo;
        }

        // ปรับสถานะเอกสาร Full Tax ต้นฉบับ เป็น 5
        $this->db->set('FTXshStaDoc','5');
        $this->db->where('FTBchCode',$tBrowseBchCode);
        $this->db->where('FTXshDocNo',$tOriginTaxDocNo);
        $this->db->update('TPSTTaxHD');

        // ปรับสถานะเอกสารของ Full Tax ที่ยกเลิก
        if( $tCurretTaxDocNo != $tOriginTaxDocNo ){
            $this->db->set('FTXshStaDoc','3');
            // $this->db->where('FTXshDocNo',$tCurretTaxDocNo);
            $this->db->where('FTXshRefAE',$tOriginTaxDocNo);
            $this->db->update('TPSTTaxHD');
        }
        
        // อัพเดท Reference
        $this->db->set('FTXshStaDoc','4');
        $this->db->set('FTXshRefAE',$tOriginTaxDocNo);  // อ้างอิงเอกสาร Full Tax ต้นฉบับ
        $this->db->set('FTXshRefInt',$tCurretTaxDocNo); // อ้างอิงเอกสาร Full Tax ที่ยกเลิก
        $this->db->set('FDXshRefIntDate',$dDocDateTime);
        $this->db->where('FTXshDocNo',$tTaxNumberFull);
        $this->db->update('TPSTTaxHD');
    }

    // Create By : Napat(Jame) 16/09/2021
    // อัพเดทกรณีอนุมัติส่ง iNet ไม่สำเร็จ และ User เข้ามาแก้ไขข้อมูล Address
    public function FSxMTXFUpdAddrAndCst($paDataHDAddress,$paDataHDCst,$paWhereCondition){

        // Update HD Address
        $this->db->where($paWhereCondition);
        $this->db->update('TPSTTaxHDAddress',$paDataHDAddress);

        // Update HD Cst
        $this->db->where($paWhereCondition);
        $this->db->update('TPSTTaxHDCst',$paDataHDCst);

    }

    // Create By : Napat(Jame) 16/09/2021
    // เช็คสถานะส่งไป iNet ของ ABB ถ้าไม่สมบูรณ์ ให้ส่งใหม่อีกครั้ง
    public function FSbMTXFChkStaABBETaxApv($paWhereABB){
        $tSQL = "   SELECT HD.FTXshETaxStatus FROM TPSTSalHD HD WITH(NOLOCK) 
                    WHERE HD.FTXshDocNo = '".$paWhereABB['FTXshDocNo']."'
                      AND HD.FTBchCode = '".$paWhereABB['FTBchCode']."'
                      AND ISNULL(HD.FTXshETaxStatus,'3') = '3'
                ";
        $oQuery = $this->db->query($tSQL);
        // echo $this->db->last_query();
        if( $oQuery->num_rows() > 0 ){
            $bReturn = true;
        }else{
            $bReturn = false;
        }
        return $bReturn;
    }




}