<?php
defined('BASEPATH') or exit('No direct script access allowed');

class mBrowserPDTCallView extends CI_Model
{

    //#################################################### PDT VIEW HQ #################################################### 

    //PDT - สำหรับ VIEW HQ + ข้อมูล
    public function FSaMGetProductHQ($ptFilter, $ptLeftJoinPrice, $paData, $pnTotalResult)
    {
        try {
            $tBchSession        = $this->session->userdata("tSesUsrBchCodeMulti");
            $tShpSession        = $this->session->userdata("tSesUsrShpCodeMulti");
            $tMerSession        = $this->session->userdata("tSesUsrMerCode");
            $aRowLen            = FCNaHCallLenData($paData['nRow'], $paData['nPage']);
            $nLngID             = $this->session->userdata("tLangEdit");

            if ($paData['aPriceType'][0] == 'Pricesell') {
                //ถ้าเป็นราคาขาย
                $tSelectFiledPrice  = "0 AS FCPgdPriceNet, ";
                $tSelectFiledPrice .= "0 AS FCPgdPriceRet, ";
                $tSelectFiledPrice .= "0 AS FCPgdPriceWhs ";
            } else if ($paData['aPriceType'][0] == 'Price4Cst') {
                $tSelectFiledPrice = '  0 AS FCPgdPriceNet ,
                                        0 AS FCPgdPriceWhs ,
                                        
                                        CASE 
                                            WHEN ISNULL(PCUS.FCPgdPriceRet,0) <> 0 THEN PCUS.FCPgdPriceRet
                                            WHEN ISNULL(PBCH.FCPgdPriceRet,0) <> 0 THEN PBCH.FCPgdPriceRet
                                            WHEN ISNULL(PEMPTY.FCPgdPriceRet,0) <> 0 THEN PEMPTY.FCPgdPriceRet
                                            ELSE 0 
                                        END AS FCPgdPriceRet ';
            } else if ($paData['aPriceType'][0] == 'Cost') {
                //ถ้าเป็นราคาทุน
                $tSelectFiledPrice  = "ISNULL(FCPdtCostStd,0)       AS FCPdtCostStd    , ISNULL(FCPdtCostAVGIN,0)     AS FCPdtCostAVGIN , ";
                $tSelectFiledPrice .= "ISNULL(FCPdtCostAVGEx,0)     AS FCPdtCostAVGEx  , ISNULL(FCPdtCostLast,0)      AS FCPdtCostLast, ";
                $tSelectFiledPrice .= "ISNULL(FCPdtCostFIFOIN,0)    AS FCPdtCostFIFOIN , ISNULL(FCPdtCostFIFOEx,0)    AS FCPdtCostFIFOEx ";
            }

            //ไม่ได้ส่งผู้จำหน่ายมา
            if ($paData['tSPL'] == '' || $paData['tSPL'] == null) {
                $tSqlSPL        = " ROW_NUMBER() OVER (PARTITION BY ProductM.FTPdtCode ORDER BY ProductM.FTPdtCode) AS FNPdtPartition , ";
                $tSqlWHERESPL   = '';
            } else {
                $tSqlSPL        = '';
                $tSqlWHERESPL   = '';
            }

            //Call View Sql
            $tSQL       = "SELECT c.* FROM ( ";
            $tSQL      .= "SELECT";
            $tSQL      .= " ROW_NUMBER() OVER(ORDER BY Products.FTPdtCode ASC) AS FNRowID , Products.* FROM (";
            $tSQL      .= "SELECT";
            $tSQL      .= "$tSqlSPL";
            $tSQL      .= " ProductM.*, " . $tSelectFiledPrice . " FROM ( ";
            $tSQL      .= " SELECT * FROM (";
            $tSQL      .= " SELECT *  , ROW_NUMBER() OVER(ORDER BY FTPdtCode ASC) AS ROWSUB from VCN_ProductsHQ WHERE FNLngIDPdt = '$nLngID' ";
            $tSQL      .= str_replace('Products.', '', $ptFilter);
                                               
            //สินค้าแฟชั่นเอาไว้ทดสอบ
            // $tSQL      .= " AND FTPdtCode IN ('01832','01817','01808','01778','00113','01811') ";

            $tSQL      .= " ) MAINPDT WHERE 1=1 ";
            $tSQL      .= " ) AS ProductM";
            $tSQL      .= $ptLeftJoinPrice . " WHERE ProductM.ROWSUB > $aRowLen[0] and ProductM.ROWSUB <= $aRowLen[1] ";
            $tSQL      .= " ) AS Products WHERE 1=1 ";
            $tSQL      .= $tSqlWHERESPL;
            $tSQL      .= " ) AS c ";
            $tSQL      .= " WHERE 1=1 ";

            $oQuery = $this->db->query($tSQL);
            if ($oQuery->num_rows() > 0) {
                $aList      = $oQuery->result_array();
                if ($paData['nPage'] == 1) {
                    //ถ้าเป็น page 1 ต้องวิ่งไปหาทั้งหมด
                    if ($paData['tFindOnlyPDT'] == 'normal') {
                        $oFoundRow  = $this->FSnMSPRGetPageAllByPDTHQ($tSQL, $ptFilter, 'SOME');
                    } else {
                        $oFoundRow  = 1;
                    }
                    $nFoundRow  = $oFoundRow;
                    if ($oFoundRow > 5000) {
                        $nPDTAll  = $this->FSnMSPRGetPageAllByPDTHQ($tSQL, $ptFilter, 'ALL');
                    } else {
                        $nPDTAll = 0;
                    }
                } else {
                    //ถ้า page 2 3 4 5 6 7 8 9 เราอยู่เเล้ว ว่ามัน total_page เท่าไหร่
                    $nFoundRow = $pnTotalResult;
                    $nPDTAll  = 0;
                }

                $nPageAll   = ceil($nFoundRow / $paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า
                $aResult    = array(
                    'raItems'       => $aList,
                    'rnAllRow'      => $nFoundRow,
                    'rnCurrentPage' => $paData['nPage'],
                    'rnAllPage'     => $nPageAll,
                    'rtCode'        => '1',
                    'rtDesc'        => 'success',
                    'sql'           => $tSQL,
                    'nPDTAll'       => $nPDTAll,
                    'nRow'          => $paData['nRow']
                );
            } else {
                $aResult    = array(
                    'rnAllRow'      => 0,
                    'rnCurrentPage' => $paData['nPage'],
                    "rnAllPage"     => 0,
                    'rtCode'        => '800',
                    'rtDesc'        => 'data not found',
                    'sql'           => $tSQL,
                    'nPDTAll'       => 0,
                    'nRow'          => $paData['nRow']
                );
            }
            return $aResult;
        } catch (Exception $Error) {
            echo $Error;
        }
    }

    //Count PDT - สำหรับ VIEW HQ + จำนวนเเถว
    public function FSnMSPRGetPageAllByPDTHQ($tSQL, $ptFilter, $ptType)
    {
        $nLngID     = $this->session->userdata("tLangEdit");

        //เก็บข้อมูลลง  Cookie
        $nCheckPage  =  $this->input->cookie("PDTCookie_" . $this->session->userdata("tSesUserCode"), true);
        $tCookieVal = json_decode($nCheckPage);

        if (!empty($nCheckPage)) {
            $nMaxTopPage = $tCookieVal->nMaxPage;
        } else {
            $nMaxTopPage = '';
        }

        if ($nMaxTopPage == '' || null) {
            $nMaxTopPage = '5000';
        }

        $nMaxTopPage   = str_replace(',', '', $nMaxTopPage);

        if ($ptType == 'SOME') {
            $tSQL       = "SELECT TOP $nMaxTopPage FTPDTCode FROM ";
        } else if ($ptType == 'ALL') {
            $tSQL       = "SELECT FTPDTCode FROM ";
        }
        // $tSQL       .= " ( ";
        // $tSQL       .= "SELECT Products.* FROM VCN_ProductsHQ as Products WHERE FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID'";
        // $tSQL       .= " ) AS Products WHERE 1=1 ";
        // $tSQL       .= $ptFilter;   

        $tSQL       .= "( 
                            SELECT  TCNMPdt.FTPdtCode , TCNMPdt.FTPdtStaActive , TCNMPdt_L.FTPdtName , TCNMPdtBar.FTBarCode , TCNMPdt.FTPtyCode , 
                                    TCNMPDTSpl.FTSplCode,TCNMPdt.FTPdtStaAlwDis,TCNMPdtSpcBch.FTAgnCode, TCNMPdt.FTPdtType, TCNMPdt.FTPdtSetOrSN
                            FROM TCNMPdt
                            LEFT JOIN TCNMPdtSpcBch ON TCNMPdt.FTPdtCode = TCNMPdtSpcBch.FTPdtCode
                            LEFT JOIN TCNMPdtPackSize ON TCNMPdt.FTPdtCode = TCNMPdtPackSize.FTPdtCode
                            LEFT JOIN TCNMPdtBar ON TCNMPdtBar.FTPdtCode = TCNMPdtPackSize.FTPdtCode AND TCNMPdtBar.FTPunCode = TCNMPdtPackSize.FTPunCode
                            LEFT JOIN TCNMPDTSpl ON TCNMPdt.FTPdtCode = TCNMPDTSpl.FTPdtCode AND TCNMPdtBar.FTBarCode = TCNMPDTSpl.FTBarCode
                            INNER JOIN TCNMPdtUnit_L ON TCNMPdtUnit_L.FTPunCode = TCNMPdtPackSize.FTPunCode AND TCNMPdtUnit_L.FNLngID = '$nLngID'
                            INNER JOIN TCNMPdt_L ON TCNMPdt.FTPdtCode = TCNMPdt_L.FTPdtCode AND TCNMPdt_L.FNLngID = '$nLngID'
                        ) AS Products WHERE 1=1 ";
        $tSQL       .= $ptFilter;

        $oQuery     = $this->db->query($tSQL);
        if ($oQuery->num_rows() >= $nMaxTopPage) {
            $nRow = $nMaxTopPage;
        } else if ($oQuery->num_rows() < $nMaxTopPage) {
            $nRow = $oQuery->num_rows();
        } else {
            $nRow = 0;
        }
        return $nRow;
    }

    //#################################################### END PDT VIEW HQ ################################################



    //#################################################### PDT VIEW BCH ###################################################

    //PDT - สำหรับ VIEW BCH + ข้อมูล
    public function FSaMGetProductBCH($ptFilter, $ptLeftJoinPrice, $paData, $pnTotalResult , $aDataParamExe)
    {
        try {
            $tSesUserCode = $this->session->userdata('tSesUserCode');
            $tSesUsrAgnCode     = $this->session->userdata('tSesUsrAgnCode');
            $tBchSession        = $this->session->userdata("tSesUsrBchCodeMulti");
            $tShpSession        = $this->session->userdata("tSesUsrShpCodeMulti");
            $tMerSession        = $this->session->userdata("tSesUsrMerCode");
            $aRowLen            = FCNaHCallLenData($paData['nRow'], $paData['nPage']);
            $nLngID             = $this->session->userdata("tLangEdit");
            $aDataUsrGrp        = $this->db->where('FTUsrCode',$tSesUserCode)->get('TCNTUsrGroup')->row_array();
            $tDefaultBchCode    = $aDataUsrGrp['FTBchCode'];
    
            $tSQL = '';

            $tSesUserCode       = $this->session->userdata('tSesUserCode');
            $tSesUsrAgnCode     = $this->session->userdata('tSesUsrAgnCode');
            $tSesUsrShpCodeMulti        = $this->session->userdata("tSesUsrShpCodeMulti");
            $tSesUsrBchCodeMulti        = $this->session->userdata("tSesUsrBchCodeMulti");
            
            $tShpSession        = $this->session->userdata("tSesUsrShpCodeMulti");
            $tMerSession        = $this->session->userdata("tSesUsrMerCode");
            $tSesUsrLevel       = $this->session->userdata('tSesUsrLevel');
            // $tSesUsrBchCodeMulti = ($tSesUsrBchCodeMulti) ? '' : FCNtAddSingleQuote($tSesUsrBchCodeMulti); 
            // $tSesUsrShpCodeMulti = ($tSesUsrShpCodeMulti) ? '' : FCNtAddSingleQuote($tSesUsrShpCodeMulti); 

            if ($paData['tBCH'] == '') {
                $tBCH   = $tSesUsrBchCodeMulti;
            } else {
                $tBCH   = "'" . str_replace(",", "','", $paData['tBCH']) . "'";
            }


            if ($paData['tSHP'] == '') {
                $tSHP   = $tSesUsrShpCodeMulti;
            } else {
                $tSHP   = $paData['tSHP'];
            }

            if ($paData['tMER'] == '') {
                $tMER   = $tMerSession;
            } else {
                $tMER   = $paData['tMER'];
            }
     
                    if($paData['nStaTopPdt']==2){
                        $nCheckPage  =  $this->input->cookie("PDTCookie_" . $this->session->userdata("tSesUserCode"), true);
                        $tCookieVal = json_decode($nCheckPage);
                        if (!empty($nCheckPage)) {
                            $nMaxTopPage = str_replace(',','',$tCookieVal->nMaxPage);
                        } else {
                            $nMaxTopPage = '';
                        }
                    }else{
                        $nMaxTopPage = $paData['nBrwTopWebCookie'];
                    }
                            
                                    $tCallStore = "{CALL SP_CNoBrowseProduct(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
                                    $aDataStore = array(
                                        'ptUsrCode'           => $tSesUserCode,
                                        'ptUsrLevel'          => $tSesUsrLevel,
                                        'tSesUsrAgnCode'      => $tSesUsrAgnCode,
                                        'ptSesBchCodeMulti'   => $tBCH,
                                        'ptSesShopCodeMulti'  => $tSHP,
                                        'ptSesMerCode'        => $tMER,
                                        'pnRow'               => $paData['nRow'],
                                        'pnPage'              => $paData['nPage'],
                                        'pnMaxTopPage'        => $nMaxTopPage,
                                        'ptFilterBy'          => $aDataParamExe['ptFilterBy'],
                                        'ptSearch'            => $aDataParamExe['ptSearch'],
                                        'ptWhere'             => $aDataParamExe['ptWhere'],
                                        'ptNotInPdtType'      => $aDataParamExe['ptNotInPdtType'],
                                        'ptPdtCodeIgnorParam' => $aDataParamExe['ptPdtCodeIgnorParam'],
                                        'ptPDTMoveon'         => $aDataParamExe['ptPDTMoveon'],
                                        'ptPlcCodeConParam'   => $aDataParamExe['ptPlcCodeConParam'],
                                        'ptDISTYPE'           => $aDataParamExe['ptDISTYPE'],
                                        'ptPagename'          => $aDataParamExe['ptPagename'],
                                        'ptNotinItemString'   => $aDataParamExe['ptNotinItemString'],
                                        'ptSqlCode'           => $aDataParamExe['ptSqlCode'],
                                        'ptPriceType'         => $aDataParamExe['ptPriceType'],
                                        'ptPplCode'           => $aDataParamExe['ptPplCode'],
                                        'FNResult'            => $nLngID
                                    );
                                    // print_r($aDataStore);
                                    // exit;
                            
                                    $oQuery = $this->db->query($tCallStore, $aDataStore);


            // echo $this->db->last_query();
            // die();
            
            if ($oQuery->num_rows() > 0) {
                $aList      = $oQuery->result_array();

                // print_r($aList);die();
                if ($paData['nPage'] == 1) {
                    //ถ้าเป็น page 1 ต้องวิ่งไปหาทั้งหมด
                    if ($paData['tFindOnlyPDT'] == 'normal') {
                        $oFoundRow  = $aList[0]['rtCountData'];
                    } else {
                        $oFoundRow  = 1;
                    }
                    $nFoundRow  = $oFoundRow;
                    if ($oFoundRow > 5000) {
                        $nPDTAll  = $aList[0]['rtCountData'];
                    } else {
                        $nPDTAll  = 0;
                    }
                } else {
                    //ถ้า page 2 3 4 5 6 7 8 9 เราอยู่เเล้ว ว่ามัน total_page เท่าไหร่
                    $nFoundRow = $pnTotalResult;
                    $nPDTAll   = 0;
                }

                $nPageAll   = ceil($nFoundRow / $paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า

                $aResult    = array(
                    'raItems'       => $aList,
                    'rnAllRow'      => $nFoundRow,
                    'rnCurrentPage' => $paData['nPage'],
                    'rnAllPage'     => $nPageAll,
                    'rtCode'        => '1',
                    'rtDesc'        => 'success',
                    'sql'           => $tSQL,
                    'nTotalResult'  => $nFoundRow,
                    'nPDTAll'       => $nPDTAll,
                    'nRow'          => $paData['nRow']
                );
            } else {
                //No Data
                $aResult    = array(
                    'rnAllRow'      => 0,
                    'rnCurrentPage' => $paData['nPage'],
                    "rnAllPage"     => 0,
                    'rtCode'        => '800',
                    'rtDesc'        => 'data not found',
                    'sql'           => $tSQL,
                    'nPDTAll'       => 0,
                    'nRow'          => $paData['nRow']
                );
            }
            return $aResult;
        } catch (Exception $Error) {
            echo $Error;
        }
    }

    public function FSaMinsertPdtToTmp($paData,$paDataQuery){
        $tSOSesSessionID = $this->session->userdata('tSesSessionID');

        $tSQL   = " SELECT *
                        FROM TCNTDocDTTmp DOCTMP
                        WHERE 1 = 1 ";
        $tSQL   .= " AND DOCTMP.FTXthDocNo  = '' ";
        $tSQL   .= " AND DOCTMP.FTXthDocKey = 'TARTRcvDepositHD' ";
        $tSQL   .= " AND DOCTMP.FTSessionID = '$tSOSesSessionID' ";

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
           return false;
        }else{
            foreach($paDataQuery AS $paDataQuery){
                $aDataAdd = array(
                    'FTBchCode'  => $paData['tBCH'],
                    'FNXtdSeqNo' => '1',
                    'FTXthDockey' => 'TARTRcvDepositHD',
                    'FTXthDocNo'  => '',
                    'FTPdtCode'  => $paDataQuery['FTPdtCode'],
                    'FTXtdPdtName'  => $paDataQuery['FTPdtName'],
                    'FTPunCode'  => $paDataQuery['FTPunCode'],
                    'FTPunName'  => $paDataQuery['FTPunName'],
                    'FCXtdFactor'  => $paDataQuery['FCPdtUnitFact'],
                    'FTXtdBarCode'  => $paDataQuery['FTBarCode'],
                    'FTXtdVatType'  => $paDataQuery['FTPdtStaVat'],
                    'FTVatCode'  => $paDataQuery['FTVatCode'],
                    'FCXtdVatRate'  => $paDataQuery['FCVatRate'],
                    'FTSessionID'  => $tSOSesSessionID,
                    'FDLastUpdOn'  => date('Y-m-d h:i:s'),
                    'FDCreateOn'  => date('Y-m-d h:i:s'),
                    'FTLastUpdBy'  =>  $this->session->userdata('tSesUsername'),
                    'FTCreateBy'  =>  $this->session->userdata('tSesUsername'),
                    'FTTmpStatus'  => '2',
                );
                $this->db->insert('TCNTDocDTTmp',$aDataAdd);
            }
        }
    }

    /* public function FSaMGetProductBCH($ptFilter, $ptLeftJoinPrice, $paData, $pnTotalResult , $aDataParamExe)
    {
        try {
            $tSesUserCode = $this->session->userdata('tSesUserCode');
            $tSesUsrAgnCode     = $this->session->userdata('tSesUsrAgnCode');
            $tBchSession        = $this->session->userdata("tSesUsrBchCodeMulti");
            $tShpSession        = $this->session->userdata("tSesUsrShpCodeMulti");
            $tMerSession        = $this->session->userdata("tSesUsrMerCode");
            $aRowLen            = FCNaHCallLenData($paData['nRow'], $paData['nPage']);
            $nLngID             = $this->session->userdata("tLangEdit");
            $aDataUsrGrp        = $this->db->where('FTUsrCode',$tSesUserCode)->get('TCNTUsrGroup')->row_array();
            $tDefaultBchCode    = $aDataUsrGrp['FTBchCode'];
    
            $tSQL = '';

            $tSesUserCode       = $this->session->userdata('tSesUserCode');
            $tSesUsrAgnCode     = $this->session->userdata('tSesUsrAgnCode');
            $tSesUsrShpCodeMulti        = $this->session->userdata("tSesUsrShpCodeMulti");
            $tSesUsrBchCodeMulti        = $this->session->userdata("tSesUsrBchCodeMulti");
            
            $tShpSession        = $this->session->userdata("tSesUsrShpCodeMulti");
            $tMerSession        = $this->session->userdata("tSesUsrMerCode");
            $tSesUsrLevel       = $this->session->userdata('tSesUsrLevel');
            // $tSesUsrBchCodeMulti = ($tSesUsrBchCodeMulti) ? '' : FCNtAddSingleQuote($tSesUsrBchCodeMulti); 
            // $tSesUsrShpCodeMulti = ($tSesUsrShpCodeMulti) ? '' : FCNtAddSingleQuote($tSesUsrShpCodeMulti); 

            if ($paData['tBCH'] == '') {
                $tBCH   = $tSesUsrBchCodeMulti;
            } else {
                $tBCH   = "'" . str_replace(",", "','", $paData['tBCH']) . "'";
            }


            if ($paData['tSHP'] == '') {
                $tSHP   = $tSesUsrShpCodeMulti;
            } else {
                $tSHP   = $paData['tSHP'];
            }

            if ($paData['tMER'] == '') {
                $tMER   = $tMerSession;
            } else {
                $tMER   = $paData['tMER'];
            }
     
                    if($paData['nStaTopPdt']==2){
                        $nCheckPage  =  $this->input->cookie("PDTCookie_" . $this->session->userdata("tSesUserCode"), true);
                        $tCookieVal = json_decode($nCheckPage);
                        if (!empty($nCheckPage)) {
                            $nMaxTopPage = str_replace(',','',$tCookieVal->nMaxPage);
                        } else {
                            $nMaxTopPage = '';
                        }
                    }else{
                        $nMaxTopPage = $paData['nBrwTopWebCookie'];
                    }
                            
                                    $tCallStore = "{CALL SP_CNoBrowseProduct(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
                                    $aDataStore = array(
                                        'ptUsrCode'           => $tSesUserCode,
                                        'ptUsrLevel'          => $tSesUsrLevel,
                                        'tSesUsrAgnCode'      => $tSesUsrAgnCode,
                                        'ptSesBchCodeMulti'   => $tBCH,
                                        'ptSesShopCodeMulti'  => $tSHP,
                                        'ptSesMerCode'        => $tMER,
                                        'pnRow'               => $paData['nRow'],
                                        'pnPage'              => $paData['nPage'],
                                        'pnMaxTopPage'        => $nMaxTopPage,
                                        'ptFilterBy'          => $aDataParamExe['ptFilterBy'],
                                        'ptSearch'            => $aDataParamExe['ptSearch'],
                                        'ptWhere'             => $aDataParamExe['ptWhere'],
                                        'ptNotInPdtType'      => $aDataParamExe['ptNotInPdtType'],
                                        'ptPdtCodeIgnorParam' => $aDataParamExe['ptPdtCodeIgnorParam'],
                                        'ptPDTMoveon'         => $aDataParamExe['ptPDTMoveon'],
                                        'ptPlcCodeConParam'   => $aDataParamExe['ptPlcCodeConParam'],
                                        'ptDISTYPE'           => $aDataParamExe['ptDISTYPE'],
                                        'ptPagename'          => $aDataParamExe['ptPagename'],
                                        'ptNotinItemString'   => $aDataParamExe['ptNotinItemString'],
                                        'ptSqlCode'           => $aDataParamExe['ptSqlCode'],
                                        'ptPriceType'         => $aDataParamExe['ptPriceType'],
                                        'ptPplCode'           => $aDataParamExe['ptPplCode'],
                                        'FNResult'            => $nLngID
                                    );
                                    // print_r($aDataStore);
                                    // exit;
                            
                                    $oQuery = $this->db->query($tCallStore, $aDataStore);


            // echo $this->db->last_query();
            // die();
            
            if ($oQuery->num_rows() > 0) {
                $aList      = $oQuery->result_array();

                // print_r($aList);die();
                if ($paData['nPage'] == 1) {
                    //ถ้าเป็น page 1 ต้องวิ่งไปหาทั้งหมด
                    if ($paData['tFindOnlyPDT'] == 'normal') {
                        $oFoundRow  = $aList[0]['rtCountData'];
                    } else {
                        $oFoundRow  = 1;
                    }
                    $nFoundRow  = $oFoundRow;
                    if ($oFoundRow > 5000) {
                        $nPDTAll  = $aList[0]['rtCountData'];
                    } else {
                        $nPDTAll  = 0;
                    }
                } else {
                    //ถ้า page 2 3 4 5 6 7 8 9 เราอยู่เเล้ว ว่ามัน total_page เท่าไหร่
                    $nFoundRow = $pnTotalResult;
                    $nPDTAll   = 0;
                }

                $nPageAll   = ceil($nFoundRow / $paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า

                $aResult    = array(
                    'raItems'       => $aList,
                    'rnAllRow'      => $nFoundRow,
                    'rnCurrentPage' => $paData['nPage'],
                    'rnAllPage'     => $nPageAll,
                    'rtCode'        => '1',
                    'rtDesc'        => 'success',
                    'sql'           => $tSQL,
                    'nTotalResult'  => $nFoundRow,
                    'nPDTAll'       => $nPDTAll,
                    'nRow'          => $paData['nRow']
                );
            } else {
                //No Data
                $aResult    = array(
                    'rnAllRow'      => 0,
                    'rnCurrentPage' => $paData['nPage'],
                    "rnAllPage"     => 0,
                    'rtCode'        => '800',
                    'rtDesc'        => 'data not found',
                    'sql'           => $tSQL,
                    'nPDTAll'       => 0,
                    'nRow'          => $paData['nRow']
                );
            }
            return $aResult;
        } catch (Exception $Error) {
            echo $Error;
        }
    } */
    //Count PDT - สำหรับ VIEW BCH + จำนวนเเถว
    public function FSnMSPRGetPageAllByPDT($tSQL, $ptBCH, $ptFilter, $ptAGN, $ptType)
    {

        $tSesUserCode = $this->session->userdata('tSesUserCode');
        $tMerSession        = $this->session->userdata("tSesUsrMerCode");
        $tShpSession        = $this->session->userdata("tSesUsrShpCodeMulti");
        $nLngID             = $this->session->userdata("tLangEdit");
        $aDataUsrGrp        = $this->db->where('FTUsrCode',$tSesUserCode)->get('TCNTUsrGroup')->row_array();
        $tDefaultBchCode    = $aDataUsrGrp['FTBchCode'];

        $nLngID     = $this->session->userdata("tLangEdit");

        // ********************************************************************************************
        // เก็บข้อมูลลง  Cookie 
        $nCheckPage  =  $this->input->cookie("PDTCookie_" . $this->session->userdata("tSesUserCode"), true);
        $tCookieVal = json_decode($nCheckPage);

        if (!empty($nCheckPage)) {
            $nMaxTopPage = $tCookieVal->nMaxPage;
        } else {
            $nMaxTopPage = '';
        }

        if ($nMaxTopPage == '' || null) {
            $nMaxTopPage = '5000';
        }

        $nMaxTopPage   = str_replace(',', '', $nMaxTopPage);

        $tSQL       = "SELECT FTPDTCode FROM ";
        $tSQL       .= " ( ";
        $tSQL       .= "SELECT DISTINCT TCNMPdt.FTPdtCode , FTAgnCode , TCNMPdt.FTPdtStaActive , TCNMPdt_L.FTPdtName , TCNMPdtBar.FTBarCode , TCNMPdt.FTPtyCode , 
                               TCNMPDTSpl.FTSplCode,TCNMPdt.FTPdtStaAlwDis, TCNMPdt.FTPdtType, TCNMPdt.FTPdtSetOrSN , TCNMPdtSpcBch.FTMerCode
                        FROM TCNMPdt
                        LEFT JOIN TCNMPdtSpcBch ON TCNMPdt.FTPdtCode = TCNMPdtSpcBch.FTPdtCode
                        LEFT JOIN TCNMPdtPackSize ON TCNMPdt.FTPdtCode = TCNMPdtPackSize.FTPdtCode
                        LEFT JOIN TCNMPdtBar ON TCNMPdtBar.FTPdtCode = TCNMPdtPackSize.FTPdtCode AND TCNMPdtBar.FTPunCode = TCNMPdtPackSize.FTPunCode
                        LEFT JOIN TCNMPDTSpl ON TCNMPdt.FTPdtCode = TCNMPDTSpl.FTPdtCode AND TCNMPdtBar.FTBarCode = TCNMPDTSpl.FTBarCode
                        INNER JOIN TCNMPdtUnit_L ON TCNMPdtUnit_L.FTPunCode = TCNMPdtPackSize.FTPunCode AND TCNMPdtUnit_L.FNLngID = '$nLngID'
                        INNER JOIN TCNMPdt_L ON TCNMPdt.FTPdtCode = TCNMPdt_L.FTPdtCode AND TCNMPdt_L.FNLngID = '$nLngID' ";


        $tSQL       .= " WHERE  1=1 ";
        
        // $tSQL       .= " OR ( ISNULL(TCNMPdtSpcBch.FTBchCode,'') IN($ptBCH)   ";

        // //เพิ่ม สินค้าที่อยู่ ใน AGN
        // if ($ptAGN != 'null') {
        //     if ($ptAGN != '') {
        //         $tSQL       .= "  OR ( ISNULL(TCNMPdtSpcBch.FTBchCode,'')='' AND ISNULL(TCNMPdtSpcBch.FTShpCode,'')='' AND ISNULL(TCNMPdtSpcBch.FTAgnCode,'') IN ($ptAGN) ) ";
        //     }
        // }

        if(!empty($ptAGN)){
            $tSQL       .= " AND (ISNULL(TCNMPdtSpcBch.FTAgnCode, '') = '$ptAGN' OR ISNULL(TCNMPdtSpcBch.FTPdtCode,'')='')"; //สินค้าที่ไม่มีเฉพาะดีลเลอร์ใดเลย
        }
        
        // $tSQL       .= " ) ";

        //---------------------- การมองเห็นเฉพาะสินค้าตามระดับผู้ใช้--------------------------//
            $tSQL       .= " OR ( ";
            $tSQL       .= "     ISNULL(TCNMPdtSpcBch.FTAgnCode, '') = '$ptAGN' ";
        if(!empty($tMerSession)){ //กรณีผู้ใช้ผูก Mer จะเห็นสินค้าภายใต้ Mer
            $tSQL       .= " AND ISNULL(TCNMPdtSpcBch.FTMerCode, '') = '$tMerSession' ";
        }
        if(!empty($tDefaultBchCode)){ //กรณีผู้ใช้ผูก Bch จะเห็นสินค้าภายใต้ Bch
            $tSQL       .= " AND ISNULL(TCNMPdtSpcBch.FTBchCode, '') IN ($ptBCH) ";
        }
        if(!empty($tShpSession)){ //กรณีผู้ใช้ผูก Shp จะเห็นสินค้าภายใต้ Shp
            $tSQL       .= " AND ISNULL(TCNMPdtSpcBch.FTShpCode, '') IN ($tShpSession) ";
        }

            $tSQL       .= " ) ";

        //---------------------- การมองเห็นสินค้าระดับตัวแทนขาย--------------------------//
            $tSQL       .= " OR ( ";
            $tSQL       .= "     ISNULL(TCNMPdtSpcBch.FTAgnCode, '') = '$ptAGN' ";
        if(!empty($tMerSession)){ //กรณีผู้ใช้ผูก Mer จะเห็นสินค้าที่ไม่ผูก Mer
            $tSQL       .= " AND ISNULL(TCNMPdtSpcBch.FTMerCode, '') = '' ";
        }
        if(!empty($tDefaultBchCode)){ //กรณีผู้ใช้ผูก Bch จะเห็นสินค้าภายใต้ Bch
            $tSQL       .= " AND ISNULL(TCNMPdtSpcBch.FTBchCode, '') = '' ";
        }
        if(!empty($tShpSession)){ //กรณีผู้ใช้ผูก Shp จะเห็นสินค้าภายใต้ Shp
            $tSQL       .= " AND ISNULL(TCNMPdtSpcBch.FTShpCode, '') = '' ";
        }
            $tSQL       .= " ) ";

        //---------------------- การมองเห็นสินค้าระดับสาขา (สำหรับผู้ใช้ระดับร้านค้า)--------------------------//
        if(!empty($tShpSession)){  
            $tSQL .= " OR ("; //กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่อยู่ใน Bch แต่ไม่ผูก Shp
            $tSQL .= "     ISNULL(TCNMPdtSpcBch.FTAgnCode,'') = '$ptAGN'";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTMerCode,'') = '$tMerSession'";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTBchCode,'') IN ($ptBCH) ";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTShpCode,'') = ''"   ;
            $tSQL .= " ) ";

            $tSQL .= " OR ("; //กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่อยู่ใน Bch แต่ไม่ผูก Shp และไม่ผูก Mer
            $tSQL .= "     ISNULL(TCNMPdtSpcBch.FTAgnCode,'') = '$ptAGN'";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTMerCode,'') = ''";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTBchCode,'') IN ($ptBCH) ";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTShpCode,'') = ''"   ;
            $tSQL .= " ) ";

            $tSQL .= " OR ("; //กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่ไม่ผูก Bch และ ไม่ผูก Shp
            $tSQL .= "     ISNULL(TCNMPdtSpcBch.FTAgnCode,'') = '$ptAGN'";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTMerCode,'') = '$tMerSession'";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTBchCode,'') = ''";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTShpCode,'') = ''"   ;
            $tSQL .= " ) ";

            $tSQL .= " OR ("; //กรณีผู้ใช้ผูก Shp จะต้องเห็นสินค้าที่ไม่ผูก Mer และสินค้าผูก Bch / Shp
            $tSQL .= "     ISNULL(TCNMPdtSpcBch.FTAgnCode,'') = '$ptAGN'";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTMerCode,'') = ''";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTBchCode,'') IN ($ptBCH) ";
            $tSQL .= " AND ISNULL(TCNMPdtSpcBch.FTShpCode,'') IN ($tShpSession) "   ;
            $tSQL .= " ) ";
        }



        $tSQL       .= " ) AS Products WHERE 1=1 ";
        $tSQL       .= $ptFilter;

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() >= $nMaxTopPage) {
            $nRow = $nMaxTopPage;
        } else if ($oQuery->num_rows() < $nMaxTopPage) {
            $nRow = $oQuery->num_rows();
        } else {
            $nRow = 0;
        }
        return $nRow;
    }

    //#################################################### END PDT VIEW BCH ################################################




    //#################################################### PDT VIEW SHP #################################################### 

    //PDT - สำหรับ VIEW SHOP + ข้อมูล
    public function FSaMGetProductSHP($ptFilter, $ptLeftJoinPrice, $paData, $pnTotalResult)
    {
        try {
            $tBCH               = $paData['tBCH'];
            $tShpSession        = $paData['tSHP'];
            $tMerSession        = '';
            $aRowLen            = FCNaHCallLenData($paData['nRow'], $paData['nPage']);
            $nLngID             = $this->session->userdata("tLangEdit");

            if ($paData['aPriceType'][0] == 'Pricesell') {
                //ถ้าเป็นราคาขาย
                $tSelectFiledPrice  = "0 AS FCPgdPriceNet, ";
                $tSelectFiledPrice .= "0 AS FCPgdPriceRet, ";
                $tSelectFiledPrice .= "0 AS FCPgdPriceWhs ";
            } else if ($paData['aPriceType'][0] == 'Price4Cst') {
                $tSelectFiledPrice = '  0 AS FCPgdPriceNet ,
                                        0 AS FCPgdPriceWhs ,
                                        CASE 
                                            WHEN ISNULL(PCUS.FCPgdPriceRet,0) <> 0 THEN PCUS.FCPgdPriceRet
                                            WHEN ISNULL(PBCH.FCPgdPriceRet,0) <> 0 THEN PBCH.FCPgdPriceRet
                                            WHEN ISNULL(PEMPTY.FCPgdPriceRet,0) <> 0 THEN PEMPTY.FCPgdPriceRet
                                            ELSE 0 
                                        END AS FCPgdPriceRet ';
            } else if ($paData['aPriceType'][0] == 'Cost') {
                //ถ้าเป็นราคาทุน
                $tSelectFiledPrice  = "ISNULL(FCPdtCostStd,0)       AS FCPdtCostStd    , ISNULL(FCPdtCostAVGIN,0)     AS FCPdtCostAVGIN , ";
                $tSelectFiledPrice .= "ISNULL(FCPdtCostAVGEx,0)     AS FCPdtCostAVGEx  , ISNULL(FCPdtCostLast,0)      AS FCPdtCostLast, ";
                $tSelectFiledPrice .= "ISNULL(FCPdtCostFIFOIN,0)    AS FCPdtCostFIFOIN , ISNULL(FCPdtCostFIFOEx,0)    AS FCPdtCostFIFOEx ";
            }

            $tSQL       = "SELECT c.* FROM ( ";
            $tSQL      .= "SELECT ROW_NUMBER() OVER(ORDER BY Products.FTPdtCode ASC) AS FNRowID , Products.* FROM (";
            $tSQL      .= "SELECT ProductM.*, " . $tSelectFiledPrice . " FROM ( ";
            $tSQL      .= "SELECT * FROM VCN_ProductShop ";

            if ($paData['tSHP'] != '' && $paData['tMER'] != '') {
                //มี SHP มี MER
                $tSHP       = $paData['tSHP'];
                $tMER       = $paData['tMER'];
                $tSQL      .= " WHERE FTMerCode = '$tMER' AND FTShpCode = '' AND FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID' ";
            } else if ($paData['tSHP'] != '' && $paData['tMER'] == '') {
                //มี SHP ไม่มี MER
                $tSHP       = $paData['tSHP'];

                //หา MER 
                $aFindMer   = $this->FSaFindMerCodeBySHP($tSHP, $tBCH);
                $tMER       = '';
                for ($i = 0; $i < FCNnHSizeOf($aFindMer); $i++) {
                    $tMER   = $aFindMer[0]['FTMerCode'];
                }
                $tSQL      .= " WHERE FTMerCode = '$tMER' AND FTShpCode = '' AND FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID' ";
            } else if ($paData['tSHP'] == '' && $paData['tMER'] != '') {
                //ไม่มี SHP มี MER
                $tSHP       = '';
                $tMER       = $paData['tMER'];
                $tSQL      .= " WHERE FTMerCode = '$tMER' AND FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID'  ";
            } else {
                //ไม่มี SHP ไม่มี MER
                $tSHP       = $tShpSession;
                $tMER       = $tMerSession;
                $tSQL      .= " WHERE FTShpCode = '$tSHP' AND FTMerCode = '$tMER' AND FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID' ";
            }

            $tSQL      .= " UNION SELECT * 
            FROM VCN_ProductShop
            WHERE FTShpCode = '$tSHP'
            AND FTPdtSpcBCH = '$tBCH'
            AND FNLngIDPdt = '$nLngID'
            AND FNLngIDUnit = '$nLngID' 
            ) AS ProductM ";

            $tSQL      .= $ptLeftJoinPrice;
            $tSQL      .= " ) AS Products WHERE 1=1 ";
            $tSQL      .= $ptFilter;
            $tSQL      .= " ) AS c ";
            $tSQL      .= " WHERE 1=1 ";
            $tSQL      .= "AND c.FNRowID > $aRowLen[0] AND c.FNRowID <= $aRowLen[1]";

            $oQuery = $this->db->query($tSQL);

            // echo $this->db->last_query();
            // die();
            if ($oQuery->num_rows() > 0) {
                $aList      = $oQuery->result_array();

                if ($paData['nPage'] == 1) {
                    //ถ้าเป็น page 1 ต้องวิ่งไปหาทั้งหมด
                    if ($paData['tFindOnlyPDT'] == 'normal') {
                        $oFoundRow  = $this->FSnMSPRGetPageAllBySHP($tSQL, $ptFilter, $tSHP, $tMER, $tBCH, $nLngID, 'SOME');
                    } else {
                        $oFoundRow  = 1;
                    }
                    $nFoundRow  = $oFoundRow;
                    if ($oFoundRow > 5000) {
                        $nPDTAll  = $this->FSnMSPRGetPageAllBySHP($tSQL, $ptFilter, $tSHP, $tMER, $tBCH, $nLngID, 'ALL');
                    } else {
                        $nPDTAll  = 0;
                    }
                } else {
                    //ถ้า page 2 3 4 5 6 7 8 9 เราอยู่เเล้ว ว่ามัน total_page เท่าไหร่
                    $nFoundRow = $pnTotalResult;
                    $nPDTAll   = 0;
                }


                $nPageAll   = ceil($nFoundRow / $paData['nRow']);
                $aResult    = array(
                    'raItems'       => $aList,
                    'rnAllRow'      => $nFoundRow,
                    'rnCurrentPage' => $paData['nPage'],
                    'rnAllPage'     => $nPageAll,
                    'rtCode'        => '1',
                    'rtDesc'        => 'success',
                    'sql'           => $tSQL,
                    'nPDTAll'       => $nPDTAll,
                    'nRow'          => $paData['nRow']
                );
            } else {
                //No Data
                $aResult    = array(
                    'rnAllRow'      => 0,
                    'rnCurrentPage' => $paData['nPage'],
                    "rnAllPage"     => 0,
                    'rtCode'        => '800',
                    'rtDesc'        => 'data not found',
                    'sql'           => $tSQL,
                    'nPDTAll'       => 0,
                    'nRow'          => $paData['nRow']
                );
            }
            return $aResult;
        } catch (Exception $Error) {
            echo $Error;
        }
    }

    //Count PDT - สำหรับ VIEW SHOP + จำนวนเเถว
    public function FSnMSPRGetPageAllBySHP($tSQL, $ptFilter, $tSHP, $tMER, $tBCH, $nLngID, $ptType){

        // ******************************************************************************************************************

        // Create By Witsarut 02/07/2020  เก็บข้อมูลลง  Cookie
        $nCheckPage  =  $this->input->cookie("PDTCookie_" . $this->session->userdata("tSesUserCode"), true);
        $tCookieVal = json_decode($nCheckPage);

        if (!empty($nCheckPage)) {
            $nMaxTopPage = $tCookieVal->nMaxPage;
        } else {
            $nMaxTopPage = '';
        }

        if ($nMaxTopPage == '' || null) {
            $nMaxTopPage = '5000';
        }

        $nMaxTopPage   = str_replace(',', '', $nMaxTopPage);
        // ******************************************************************************************************************

        if ($ptType == 'SOME') {
            $tSQL       = "SELECT * FROM ( SELECT TOP $nMaxTopPage * FROM VCN_ProductShop as Products WHERE 1=1 ";
        } else if ($ptType == 'ALL') {
            $tSQL       = "SELECT * FROM ( SELECT * FROM VCN_ProductShop as Products WHERE 1=1  ";
        }

        if ($tSHP != '' && $tMER != '') {
            //มี SHP มี MER
            $tSHP       = $tSHP;
            $tMER       = $tMER;
            //$tSQL      .= " AND (FTMerCode = '$tMER' OR FTShpCode = '$tSHP') AND FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID' ";
            $tSQL      .= " AND  FTMerCode = '$tMER' AND FTShpCode = '' AND FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID' ";
        } else if ($tSHP != '' && $tMER == '') {
            //มี SHP ไม่มี MER
            $tSHP       = $tSHP;
            $tMER       = $tMER;
            $tSQL      .= " AND FTShpCode = '$tSHP' AND FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID' ";
        } else if ($tSHP == '' && $tMER != '') {
            //ไม่มี SHP มี MER
            $tSHP       = $tSHP;
            $tMER       = $tMER;
            $tSQL      .= " AND FTMerCode = '$tMER' AND FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID'  ";
        } else {
            //ไม่มี SHP ไม่มี MER
            $tSHP       = $this->session->userdata("tSesUsrShpCode");
            $tMER       = $this->session->userdata("tSesUsrMerCode");
            $tSQL      .= " AND FTShpCode = '$tSHP' AND FTMerCode = '$tMER' AND FNLngIDPdt = '$nLngID' AND FNLngIDUnit = '$nLngID' ";
        }

        $tSQL      .= " UNION SELECT * 
        FROM VCN_ProductShop
        WHERE FTShpCode = '$tSHP'
        AND FTPdtSpcBCH = '$tBCH'
        AND FNLngIDPdt = '$nLngID'
        AND FNLngIDUnit = '$nLngID' 
        ) AS Products WHERE 1=1 ";

        $tSQL .= $ptFilter;

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() >= $nMaxTopPage) {
            $nRow = $nMaxTopPage;
        } else if ($oQuery->num_rows() < $nMaxTopPage) {
            $nRow = $oQuery->num_rows();
        } else {
            $nRow = 0;
        }
        return $nRow;
    }

    //#################################################### END PDT VIEW SHP #################################################


    //Get หาต้นทุนใช้แบบไหน
    public function FSnMGetTypePrice($tSyscode, $tSyskey, $tSysseq)
    {
        $tSQL = "SELECT FTSysStaDefValue,FTSysStaUsrValue
            FROM  TSysConfig 
            WHERE 
                FTSysCode = '$tSyscode' AND 
                FTSysKey = '$tSyskey' AND 
                FTSysSeq = '$tSysseq'
            ";

        $oQuery = $this->db->query($tSQL);

        if ($oQuery->num_rows() > 0) {
            $oRes  = $oQuery->result();
            if ($oRes[0]->FTSysStaUsrValue != '') {
                $tDataSavDec = $oRes[0]->FTSysStaUsrValue;
            } else {
                $tDataSavDec = $oRes[0]->FTSysStaDefValue;
            }
        } else {
            //Decimal Default = 2 
            $tDataSavDec = 2;
        }
        return $tDataSavDec;
    }

    //Get vat จาก company กรณีที่ไม่มี supplier ส่งมา
    public function FSaMGetWhsInorExIncompany()
    {
        $tSQL           = "SELECT TOP 1 FTCmpRetInOrEx FROM TCNMComp";
        $oQuery         = $this->db->query($tSQL);
        $oList          = $oQuery->result_array();
        return $oList;
    }

    //Get vat จาก sup
    public function FSaMGetWhsInorExInSupplier($pnCode)
    {
        $tSQL           = "SELECT FTSplStaVATInOrEx FROM TCNMSpl WHERE FTSplCode = '$pnCode'";
        $oQuery         = $this->db->query($tSQL);
        $oList          = $oQuery->result_array();
        return $oList;
    }

    //////////// ระดับบาร์โค้ด //////////////

    //get Barcode - COST
    public function FSnMGetBarcodeCOST($paData, $aNotinItem)
    {
        $FNLngID        = $paData['FNLngID'];
        $FTPdtCode      = $paData['FTPdtCode'];
        $FTPunCode      = $paData['FTPunCode'];
        $nLngID         = $this->session->userdata("tLangEdit");
        $tVatInorEx     = $paData['tVatInorEx'];
        $tFTSplCode     = $paData['FTSplCode'];

        if ($tFTSplCode == '' || $tFTSplCode == null) {
            $tSQL_BarSPL    = "ROW_NUMBER() OVER (PARTITION BY BAR.FTBarCode ORDER BY BAR.FTBarCode) AS FNPdtPartition ,";
            $tSQL_SPL       = " AND A.FNPdtPartition = 1";
        } else {
            $tSQL_BarSPL    = "ROW_NUMBER() OVER (PARTITION BY BAR.FTBarCode ORDER BY BAR.FTBarCode) AS FNPdtPartition ,";
            $tSQL_SPL       = " AND A.FNPdtPartition = 1 AND FTSplCode = '$tFTSplCode' ";
        }

        $tSQL =  "SELECT A.* FROM ( ";
        $tSQL .= "SELECT BAR.* , ";
        $tSQL .= "$tSQL_BarSPL";
        $tSQL .= "      FCPdtCostStd , 
                        FCPdtCostAVGIN ,
                        FCPdtCostAVGEX ,
                        FCPdtCostLast ,
                        FCPdtCostFIFOIN ,
                        FCPdtCostFIFOEX ,
                        FTPdtStaVatBuy ,
                        FTPdtStaVat ,
                        FTPdtStaActive ,
                        FTPdtSetOrSN ,
                        FTPgpChain ,
                        FTPtyCode ,
                        FCPdtCookTime ,
                        FCPdtCookHeat ,
                        FNLngIDPdt ,
                        FNLngIDUnit , 
                        FTPunName ,
                        FCPdtUnitFact ,
                        FTPdtSpcBch ,
                        FTMerCode ,
                        FTShpCode ,
                        FTMgpCode ,
                        FTBuyer  FROM( ";
        $tSQL .=  "SELECT * FROM VCN_ProductBar BAR WHERE ";
        $tSQL .= "BAR.FTPdtCode = '$FTPdtCode' AND ";
        $tSQL .= "BAR.FTPunCode = '$FTPunCode' ";
        $tSQL .= ") AS BAR ";
        $tSQL .= "LEFT JOIN VCN_ProductCost PRI ON BAR.FTPdtCode = PRI.FTPdtCode ";
        $tSQL .= "LEFT JOIN VCN_ProductsHQ PDT ON  BAR.FTPdtCode = PDT.FTPdtCode AND BAR.FTPunCode = PDT.FTPunCode ";
        $tSQL .= "WHERE BAR.FNLngPdtBar = '$nLngID'";
        $tSQL .= "AND PDT.FNLngIDPdt = '$nLngID'";
        $tSQL .= "AND PDT.FNLngIDUnit = '$nLngID' ) A WHERE 1=1 ";

        $tSQL .= $tSQL_SPL;

        //ไม่เอาสินค้าอะไรบ้าง
        if ($aNotinItem != '' || $aNotinItem != null) {
            $tNotinItem     = '';
            $aNewNotinItem  = explode(',', $aNotinItem);

            for ($i = 0; $i < FCNnHSizeOf($aNewNotinItem); $i++) {
                $aNewPDT  = explode(':::', $aNewNotinItem[$i]);
                $tNotinItem .=  "'" . $aNewPDT[1] . "'" . ',';
                if ($i == FCNnHSizeOf($aNewNotinItem) - 1) {
                    $tNotinItem = substr($tNotinItem, 0, -1);
                }
            }
            $tSQL .= "AND (A.FTBarCode NOT IN ($tNotinItem))";
        }

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result_array();
        } else {
            return false;
        }
    }

    //get Barcode - Price Sell
    public function FSnMGetBarcodePriceSELL($paData, $aNotinItem)
    {
        $FNLngID        = $paData['FNLngID'];
        $FTPdtCode      = $paData['FTPdtCode'];
        $FTPunCode      = $paData['FTPunCode'];
        $nLngID         = $this->session->userdata("tLangEdit");
        $tFTSplCode     = $paData['FTSplCode'];

        if ($tFTSplCode == '' || $tFTSplCode == null) {
            $tSQL_BarSPL    = "ROW_NUMBER() OVER (PARTITION BY BAR.FTBarCode ORDER BY BAR.FTBarCode) AS FNPdtPartition ,";
            $tSQL_SPL       = " AND A.FNPdtPartition = 1";
        } else {
            $tSQL_BarSPL    = "ROW_NUMBER() OVER (PARTITION BY BAR.FTBarCode ORDER BY BAR.FTBarCode) AS FNPdtPartition ,";
            $tSQL_SPL       = " AND A.FNPdtPartition = 1 AND FTSplCode = '$tFTSplCode' ";
        }

        $tSQL =  "SELECT A.* FROM ( ";
        $tSQL .= "SELECT BAR.* , ";
        $tSQL .= "$tSQL_BarSPL";
        $tSQL .= "      FNRowPart ,
                        FDPghDStart , 
                        FCPgdPriceNet , 
                        FCPgdPriceRet ,
                        FCPgdPriceWhs ,
                        FTPdtStaVatBuy , 
                        FTPdtStaVat , 
                        FTPdtStaActive , 
                        FTPdtSetOrSN ,
                        FTPgpChain , 
                        FTPtyCode , 
                        FCPdtCookTime ,
                        FCPdtCookHeat , 
                        FNLngIDPdt , 
                        FNLngIDUnit , 
                        FTPunName , 
                        FCPdtUnitFact ,
                        FTPdtSpcBch , 
                        FTMerCode , 
                        FTShpCode ,
                        FTMgpCode , 
                        FTBuyer  FROM( ";
        $tSQL .=  "SELECT * FROM VCN_ProductBar BAR WHERE ";
        $tSQL .= "BAR.FTPdtCode = '$FTPdtCode' AND ";
        $tSQL .= "BAR.FTPunCode = '$FTPunCode' ) AS BAR ";
        $tSQL .= "LEFT JOIN VCN_Price4PdtActive PRI ON BAR.FTPdtCode = PRI.FTPdtCode ";
        $tSQL .= "AND BAR.FTPunCode = PRI.FTPunCode ";
        $tSQL .= "INNER JOIN VCN_ProductsHQ PDT ";
        $tSQL .= "ON BAR.FTPdtCode = PDT.FTPdtCode AND BAR.FTPunCode = PDT.FTPunCode ";
        $tSQL .= "WHERE BAR.FNLngPdtBar = '$nLngID' AND PDT.FNLngIDUnit = '$nLngID' AND PDT.FNLngIDPdt = '$nLngID'  ) A WHERE 1=1 ";

        $tSQL .= $tSQL_SPL;
        //ไม่เอาสินค้าอะไรบ้าง
        if ($aNotinItem != '' || $aNotinItem != null) {
            $tNotinItem     = '';
            $aNewNotinItem  = explode(',', $aNotinItem);

            for ($i = 0; $i < FCNnHSizeOf($aNewNotinItem); $i++) {
                $aNewPDT  = explode(':::', $aNewNotinItem[$i]);
                if ($FTPdtCode == $aNewPDT[0]) {
                    $tNotinItem .=  "'" . $aNewPDT[1] . "'" . ',';
                }

                if ($i == FCNnHSizeOf($aNewNotinItem) - 1) {
                    $tNotinItem = substr($tNotinItem, 0, -1);
                }
            }
            if ($tNotinItem == '') {
                $tSQL .= " ";
            } else {
                $tSQL .= " AND (A.FTBarCode NOT IN ($tNotinItem)) ORDER BY A.FTBarCode ASC ";
            }
        }

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result_array();
        } else {
            return false;
        }
    }

    //หาว่า BARCODE หรือ PLC นี้อยู่ใน PDT อะไร
    public function FSnMFindPDTByBarcode($tTextSearch, $tTypeSearch)
    {
        $nLngID  = $this->session->userdata("tLangEdit");
        $tSQL    = "SELECT FTPdtCode , FTPunCode , FTBarCode FROM VCN_ProductBar WHERE 1=1";

        if ($tTypeSearch == 'FINDBARCODE') {
            $tSQL    .=  " AND FTBarCode = '$tTextSearch' ";
        } else if ($tTypeSearch == 'FINDPLCCODE') {
            $tSQL    .=  " AND FTPlcName LIKE '%$tTextSearch%' ";
        }

        $tSQL    .= "AND FNLngPdtBar = '$nLngID' ";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result_array();
        } else {
            return false;
        }
    }

    //หาว่า shop นี้ Mercode อะไร
    public function FSaFindMerCodeBySHP($tSHP, $tBCH)
    {
        $tSQL    = "SELECT FTShpCode , FTMerCode FROM TCNMShop WHERE ";
        $tSQL    .= "FTShpCode = '$tSHP' AND FTBchCode = '$tBCH' ";
        $tSQL    .= "ORDER BY FTMerCode ASC ";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result_array();
        } else {
            return false;
        }
    }

    //หาว่าสาขา นี้ Mercode อะไร
    public function FSaFindMerCodeByBCH($tBCH)
    {
        $tSQL    = "SELECT DISTINCT FTMerCode FROM TCNMShop WHERE ";
        $tSQL    .= "FTBchCode = '$tBCH' ";
        $tSQL    .= "ORDER BY FTMerCode ASC ";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result_array();
        } else {
            return false;
        }
    }

    ///////////////////////////////////////////// สินค้าแฟชั่น + สินค้าซีเรียล /////////////////////////////////////////////

    //เช็คก่อนว่าสินค้า แฟชั่นที่ส่งมานั้นมีรายละเอียดครบถ้วนจริงไหม
    public function FSaMCheckDetailInPDTColorSize($aResult){
        $aItemCheck_have    = [];
        $tItemCheck_remove  = '';
        for($i=0; $i<count($aResult); $i++){
            $tPDTCode   = $aResult[$i]->PDTCode;
            $tPUNCode   = $aResult[$i]->PUNCode;
            $tBarcode   = $aResult[$i]->Barcode;
            $tWhereBar = "";
            if($tBarcode!=''){
                $tWhereBar .= " AND PDTBAR.FTBarCode = '$tBarcode' "; 
            }
            
            // $tSQL       = "SELECT FTPdtCode FROM TFHMPdtColorSize WITH(NOLOCK)  WHERE FTPdtCode = '$tPDTCode' ";
            $tSQL  ="SELECT
                        PDTCLR.FTPdtCode
                    FROM
                        TFHMPdtColorSize PDTCLR WITH(NOLOCK)
                    LEFT JOIN TCNMPdtBar PDTBAR WITH(NOLOCK) ON PDTCLR.FTPdtCode = PDTBAR.FTPdtCode AND PDTCLR.FNFhnSeq = PDTBAR.FNBarRefSeq AND PDTCLR.FTFhnRefCode = PDTBAR.FTFhnRefCode
                    WHERE 1=1
                    AND PDTCLR.FTFhnStaActive = '1'
                    AND	PDTCLR.FTPdtCode = '$tPDTCode'
                    $tWhereBar
                    GROUP BY PDTCLR.FTPdtCode";
            $oQuery = $this->db->query($tSQL);
            if ($oQuery->num_rows() > 0) {
                array_push($aItemCheck_have,['PDTCode' => $tPDTCode ,'PUNCode'=>$tPUNCode , 'Barcode'=>$tBarcode ]);
            }else{
                $tItemCheck_remove .= $tPDTCode . ',';
            }
        }
        
        $aItemCheckreturn = array(
            'aItemCheck_have'   => $aItemCheck_have,
            'aItemCheck_remove' => $tItemCheck_remove
        );
        return json_encode($aItemCheckreturn);
    }

    //หาว่าสินค้าแฟชั่นตัวนี้ มีรายละเอียดที่เกี่ยวข้องคืออะไร
    public function FSaMGetDetailPDTFashion($paPDTDetail){

        $tPdtCode = $paPDTDetail['tPdtCode'];
        $tPUNCode = $paPDTDetail['tPUNCode'];
        $tBarcode = $paPDTDetail['tBarcode'];

        if($paPDTDetail['tStkBalBchCode']!=''){
            $tStkBalBchCode = $paPDTDetail['tStkBalBchCode'];
        }else{
            $tStkBalBchCode = $this->session->userdata('tSesUsrBchCodeDefault');
        }

        if($paPDTDetail['tStkBalWahCode']!=''){
            $tStkBalWahCode = $paPDTDetail['tStkBalWahCode'];
        }else{
            $tStkBalWahCode = '00001';
        }

        $tWhereBar = "";
        if($tBarcode!=''){
            $tWhereBar .= " AND PDTBAR.FTBarCode ='$tBarcode' "; 
        }

        $nLngID  = $this->session->userdata("tLangEdit");
         $tSQL    = "SELECT K.*,ISNULL(F.FCStfBal,0) AS FCStfBal  FROM (
                        SELECT A.* , COUNT(B.FTFhnRefCode) AS nCountRefCode ,'$tPdtCode' AS RetPdtCode , '$tPUNCode' AS RetPunCode , '$tBarcode' AS RetBarCode , 1 AS RenDTSeq FROM (
                        SELECT 
                            TFHMPdtColorSize.FTPdtCode ,
                            TFHMPdtColorSize.FTFhnRefCode ,
                            TFHMPdtColorSize.FNFhnSeq ,
                            TFHMPdtSeason_L.FTSeaName,
                            TFHMPdtFabric_L.FTFabName,
                            TCNMPdtColor_L.FTClrName,
                            TCNMPdtSize_L.FTPszName,
                            TCNMPDT_L.FTPdtName,
                            '' AS FCXtdQty
                        FROM 
                            TFHMPdtColorSize  WITH (NOLOCK)
                        LEFT JOIN TFHMPdtSeason_L  WITH (NOLOCK) ON TFHMPdtColorSize.FTSeaCode = TFHMPdtSeason_L.FTSeaCode AND TFHMPdtSeason_L.FNLngID = $nLngID
                        LEFT JOIN TFHMPdtFabric_L  WITH (NOLOCK) ON TFHMPdtColorSize.FTFabCode = TFHMPdtFabric_L.FTFabCode AND TFHMPdtFabric_L.FNLngID = $nLngID
                        LEFT JOIN TCNMPdtColor_L  WITH (NOLOCK)  ON TFHMPdtColorSize.FTClrCode = TCNMPdtColor_L.FTClrCode AND TCNMPdtColor_L.FNLngID = $nLngID 
                        LEFT JOIN TCNMPdtSize_L  WITH (NOLOCK)   ON TFHMPdtColorSize.FTPszCode = TCNMPdtSize_L.FTPszCode AND TCNMPdtSize_L.FNLngID = $nLngID
                        LEFT JOIN TCNMPDT_L    WITH (NOLOCK)     ON TFHMPdtColorSize.FTPdtCode = TCNMPDT_L.FTPdtCode AND TCNMPDT_L.FNLngID = $nLngID
                        LEFT JOIN TCNMPdtBar PDTBAR WITH (NOLOCK) ON TFHMPdtColorSize.FTPdtCode = PDTBAR.FTPdtCode AND TFHMPdtColorSize.FNFhnSeq = PDTBAR.FNBarRefSeq AND TFHMPdtColorSize.FTFhnRefCode = PDTBAR.FTFhnRefCode AND TFHMPdtColorSize.FTFhnStaActive=1
                        WHERE TFHMPdtColorSize.FTPdtCode = '$tPdtCode' $tWhereBar
                    ) AS A 
                    LEFT JOIN TFHMPdtColorSize B ON A.FTPdtCode = B.FTPdtCode AND A.FTFhnRefCode = B.FTFhnRefCode 
                    GROUP BY A.FTPdtCode , A.FTFhnRefCode , A.FTSeaName , A.FTFabName , A.FTClrName , A.FTPszName , A.FTPdtName , A.FNFhnSeq , A.FCXtdQty
                    ) K 
                    LEFT JOIN TFHTPdtStkBal F ON K.FTPdtCode = F.FTPdtCode AND K.FTFhnRefCode = F.FTFhnRefCode AND F.FTBchCode = '$tStkBalBchCode' AND  F.FTWahCode = '$tStkBalWahCode'
                    ORDER BY K.FTFhnRefCode";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result_array();
        } else {
            return false;
        }
    }

    //หาว่าสินค้าแฟชั่นตัวนี้ ใน temp มีจำนวน QTY ที่เคยกรอกเป็นเท่าไหร่บ่้าง
    public function FSaMGetDetailPDTSingleFashion($paPDTDetail,$aDataInDocumentTemp){
        $tPdtCode = $paPDTDetail['tPdtCode'];
        $tPUNCode = $paPDTDetail['tPUNCode'];
        $tBarcode = $paPDTDetail['tBarcode'];
        $nLngID             = $this->session->userdata("tLangEdit");
        $tDocumentnumber    = $aDataInDocumentTemp['tDocumentnumber'];
        $tDocumentbranch    = $aDataInDocumentTemp['tDocumentbranch'];
        $tDocumentDockey   = $aDataInDocumentTemp['tDocumentDockey'];
        $nDTSeq            = $aDataInDocumentTemp['nDTSeq'];
        $tDocumentPLcCode    = $aDataInDocumentTemp['tDocumentPLcCode'];
        $tDocumentsession   = $aDataInDocumentTemp['tDocumentsession'];
        $tSpcControl   = $aDataInDocumentTemp['oOptionForFashion']['tSpcControl'];

        if($paPDTDetail['tStkBalBchCode']!=''){
            $tStkBalBchCode = $paPDTDetail['tStkBalBchCode'];
        }else{
            $tStkBalBchCode = $this->session->userdata('tSesUsrBchCodeDefault');
        }

        if($paPDTDetail['tStkBalWahCode']!=''){
            $tStkBalWahCode = $paPDTDetail['tStkBalWahCode'];
        }else{
            $tStkBalWahCode = '00001';
        }
        
        $tWherePlcCode = '';
        if($tSpcControl<>0){ //กรณีเรียกในเอกสารตรวจนับ
            $tWherePlcCode.=" AND ISNULL(D.FTAjdPlcCode,'') = '$tDocumentPLcCode' ";
        }

        $tWhereBar = "";
        if($tBarcode!=''){
            $tWhereBar .= " AND PDTBAR.FTBarCode ='$tBarcode' "; 
        }

        $tSQL    = "SELECT  C.* , 
                            '$tPdtCode' AS RetPdtCode , '$tPUNCode' AS RetPunCode , '$tBarcode' AS RetBarCode, $nDTSeq AS RenDTSeq,
                            D.FCXtdQty , 
                            D.FDAjdDateTimeC1 ,     
                            D.FCAjdUnitQtyC1 , 
                            D.FDAjdDateTimeC2 , 
                            D.FCAjdUnitQtyC2 , 
                            D.FDAjdDateTime , 
                            D.FCAjdUnitQty ,
                            ISNULL(F.FCStfBal, 0) AS FCStfBal
                        FROM (

                            SELECT A.* , COUNT(B.FTFhnRefCode) AS nCountRefCode FROM (
                                SELECT 
                                    TFHMPdtColorSize.FTPdtCode ,
                                    TFHMPdtColorSize.FTFhnRefCode ,
                                    TFHMPdtColorSize.FNFhnSeq ,
                                    TFHMPdtSeason_L.FTSeaName,
                                    TFHMPdtFabric_L.FTFabName,
                                    TCNMPdtColor_L.FTClrName,
                                    TCNMPdtSize_L.FTPszName,
                                    TCNMPDT_L.FTPdtName
                                FROM 
                                    TFHMPdtColorSize WITH (NOLOCK)
                                LEFT JOIN TFHMPdtSeason_L WITH (NOLOCK)  ON TFHMPdtColorSize.FTSeaCode = TFHMPdtSeason_L.FTSeaCode AND TFHMPdtSeason_L.FNLngID = $nLngID
                                LEFT JOIN TFHMPdtFabric_L WITH (NOLOCK)  ON TFHMPdtColorSize.FTFabCode = TFHMPdtFabric_L.FTFabCode AND TFHMPdtFabric_L.FNLngID = $nLngID
                                LEFT JOIN TCNMPdtColor_L WITH (NOLOCK)   ON TFHMPdtColorSize.FTClrCode = TCNMPdtColor_L.FTClrCode AND TCNMPdtColor_L.FNLngID = $nLngID 
                                LEFT JOIN TCNMPdtSize_L WITH (NOLOCK)    ON TFHMPdtColorSize.FTPszCode = TCNMPdtSize_L.FTPszCode AND TCNMPdtSize_L.FNLngID = $nLngID
                                LEFT JOIN TCNMPDT_L   WITH (NOLOCK)      ON TFHMPdtColorSize.FTPdtCode = TCNMPDT_L.FTPdtCode AND TCNMPDT_L.FNLngID = $nLngID
                                LEFT JOIN TCNMPdtBar PDTBAR WITH (NOLOCK) ON TFHMPdtColorSize.FTPdtCode = PDTBAR.FTPdtCode AND TFHMPdtColorSize.FNFhnSeq = PDTBAR.FNBarRefSeq AND TFHMPdtColorSize.FTFhnRefCode = PDTBAR.FTFhnRefCode  AND TFHMPdtColorSize.FTFhnStaActive=1
                                WHERE TFHMPdtColorSize.FTPdtCode = '$tPdtCode'  $tWhereBar
                            ) AS A 
                            LEFT JOIN TFHMPdtColorSize B ON A.FTPdtCode = B.FTPdtCode AND A.FTFhnRefCode = B.FTFhnRefCode 
                            GROUP BY A.FTPdtCode , A.FTFhnRefCode , A.FTSeaName , A.FTFabName , A.FTClrName , A.FTPszName , A.FTPdtName , A.FNFhnSeq

                    ) AS C LEFT JOIN TCNTDocDTFhnTmp D ON C.FTPdtCode = D.FTPdtCode AND C.FTFhnRefCode = D.FTFhnRefCode
                    AND D.FTBchCode = '$tDocumentbranch'
                    AND D.FTXshDocNo = '$tDocumentnumber' 
                    AND D.FTSessionID = '$tDocumentsession'
                    AND D.FTXthDocKey = '$tDocumentDockey'
                    AND D.FNXsdSeqNo  = '$nDTSeq'
                    $tWherePlcCode
                    LEFT JOIN TFHTPdtStkBal F ON C.FTPdtCode = F.FTPdtCode AND C.FTFhnRefCode = F.FTFhnRefCode AND F.FTBchCode = '$tStkBalBchCode' AND  F.FTWahCode = '$tStkBalWahCode'
                    ORDER BY C.FTFhnRefCode ";

        $oQuery = $this->db->query($tSQL);
       
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result_array();
        } else {
            return false;
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
