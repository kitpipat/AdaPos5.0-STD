<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

class Customermngcredit_model extends CI_Model {

    // Functionality : list Data Customer Credit List
    // Parameters    : function parameters
    // Creator       :  17/06/2022 Wasin
    // Return        : data
    // Return Type   : Array
    public function FSaMMCRDataList($paData){
        $nLngID         = $paData['FNLngID'];
        $tSesAgnCode    = $paData['tSesAgnCode'];
        // Get Config And Check Config Time Exprie AdaBackOffice Producer
        $aConfigParamsOnline    = [
            "tSysCode"  => "tPS_CstType",
            "tSysApp"   => "CN",
            "tSysKey"   => "POS",
            "tSysSeq"   => "2",
            "tGmnCode"  => "MPOS"
        ];
        $aConfigCstType = FCNaGetSysConfig($aConfigParamsOnline);
        $tSQL           = "
            SELECT 
                CSTCR.*,
                (CSTCR.FCCstCrBalExt - CSTCR.FCCstCrAmtBuffer - CSTCR.FCCstCrLeft) AS FCCstCrBalLeft
            FROM (
                SELECT TOP ". get_cookie('nShowRecordInPageList')."
                    CST.FTCstCode,
                    CSTL.FTCstName,
                    CRD.FTCstStaApv,    
                    ISNULL(CRD.FCCstCrLimit,0.0)    AS FCCstCrLimit,
                    ISNULL(CRD.FCCstCrBuffer,0.0) 	AS FCCstCrBuffer,
                    ((ISNULL(CRD.FCCstCrLimit,0.0) * ISNULL(CRD.FCCstCrBuffer, 0.0))/100)   AS FCCstCrAmtBuffer,
                    ISNULL(FCCstCrBalExt,0)         AS FCCstCrBalExt,
                    ISNULL(HDSAL.FCXshLeft,0)       AS FCCstCrLeft,
                    CST.FDCreateOn
                FROM TCNMCst CST WITH(NOLOCK)
                LEFT JOIN TCNMCst_L CSTL WITH(NOLOCK) ON CST.FTCstCode = CSTL.FTCstCode AND CSTL.FNLngID = ".$this->db->escape($nLngID)."
                LEFT JOIN TCNMCstCredit CRD WITH(NOLOCK) ON CST.FTCstCode = CRD.FTCstCode
                LEFT JOIN (
                    SELECT HD.FTCstCode,SUM(HD.FCXshLeft) AS FCXshLeft
                    FROM TPSTSalHD HD WITH(NOLOCK)
                    WHERE ISNULL(HD.FTCstCode,'') <> '' AND HD.FCXshLeft > 0
                    GROUP BY HD.FTCstCode
                ) HDSAL ON CST.FTCstCode = HDSAL.FTCstCode
                WHERE CST.FDCreateOn <> ''
        ";

        if(!empty($aConfigCstType) && $aConfigCstType['rtCode'] == '1'){
            $tSysUsrValue   = $aConfigCstType['raItems']['FTSysStaUsrValue'];
            $tSQL .= "AND CST.FTClvCode = ".$this->db->escape($tSysUsrValue)."";
        }

        $tSearchList    = $paData['tSearchAll'];
        if(isset($tSearchList) && !empty($tSearchList)){
            $tSQL   .= " AND (CST.FTCstCode COLLATE THAI_BIN LIKE '%".$this->db->escape_like_str($tSearchList)."%'";
            $tSQL   .= " OR CSTL.FTCstName COLLATE THAI_BIN  LIKE '%".$this->db->escape_like_str($tSearchList)."%')";
        }

        //ค้นหาตัวแทนขายของตัวเอง
        $tAgnCode   = $this->session->userdata("tSesUsrAgnCode");
        if($tAgnCode != ""){
            $tSQL   .= " AND ( ISNULL(CST.FTAgnCode,'')='' OR CST.FTAgnCode = '$tAgnCode' ";
        }

        $tSQL   .= " ) CSTCR ORDER BY CSTCR.FDCreateOn DESC";

        // echo "<pre>";
        // print_r($tSQL);
        // echo "</pre>";

        $oQuery  = $this->db->query($tSQL);
        if($oQuery->num_rows() > 0){
            $aList      = $oQuery->result_array();
            $aResult    = array(
                'raItems'   => $aList,
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        }else{
            //No Data
            $aResult    = array(
                'rtCode'    => '800',
                'rtDesc'    => 'data not found',
            );
        }
        unset($nLngID,$tSesAgnCode,$tSQL,$tSearchList,$tAgnCode,$oQuery,$aList);
        return $aResult;
    }

    // Functionality : Data Customer Info By ID
    // Parameters    : function parameters
    // Creator       : 17/06/2022 Wasin
    // Return        : data
    // Return Type   : Array
    public function FSaMMCRGetDataCustomerByID($paData){
        $tCstCode   = $paData['FTCstCode'];
        $nLngID     = $paData['FNLngID'];
        $tSQL       = "
            SELECT
                CST.FTCstCode               AS rtCstCode,
                CST.FTCstCardID             AS rtCstCardID,
                CST.FDCstDob                AS rtCstDob,
                CST.FTCstSex                AS rtCstSex,
                CST.FTCstBusiness           AS rtCstBusiness,
                CST.FTCstTaxNo              AS rtCstTaxNo,
                CST.FTCstStaActive          AS rtCstStaActive,
                CST.FTCstEmail              AS rtCstEmail,
                CST.FTCstTel                AS rtCstTel,
                CSTL.FTCstName              AS rtCstName,
                CSTL.FTCstRmk               AS rtCstRmk,
                CST.FTCgpCode               AS rtCstCgpCode,
                CSTGL.FTCgpName             AS rtCstCgpName,
                CST.FTCtyCode               AS rtCstCtyCode,
                CSTTL.FTCtyName             AS rtCstCtyName,
                CST.FTClvCode               AS rtCstClvCode,
                CSTLevL.FTClvName           AS rtCstClvName,
                CST.FTOcpCode               AS rtCstOcpCode,
                CSTOL.FTOcpName             AS rtCstOcpName,
                CST.FTPmgCode               AS rtCstPmgCode,
                PDTPmtGL.FTPmgName          AS rtCstPmgName,
                CST.FTCstDiscRet            AS rtCstDiscRet,
                CST.FTCstDiscWhs            AS rtCstDiscWhs,
                CST.FTCstBchHQ              AS rtCstBchHQ,
                CST.FTCstBchCode            AS rtCstBchCode,
                BCHL.FTBchName              AS rtCstBchName,
                CST.FTCstStaAlwPosCalSo     AS rtCstStaAlwPosCalSo,
                IMGP.FTImgObj               AS rtImgObj,
                AGN_L.FTAgnCode             AS FTAgnCode,
                AGN_L.FTAgnName             AS FTAgnName
            FROM [TCNMCst] CST WITH(NOLOCK)
            LEFT JOIN [TCNMAgency_L] AGN_L WITH(NOLOCK) ON CST.FTAgnCode = AGN_L.FTAgnCode AND AGN_L.FNLngID = ".$this->db->escape($nLngID)."
            LEFT JOIN [TCNMCst_L]  CSTL WITH(NOLOCK) ON CST.FTCstCode = CSTL.FTCstCode AND CSTL.FNLngID = ".$this->db->escape($nLngID)."
            LEFT JOIN [TCNMCstGrp_L] CSTGL WITH(NOLOCK) ON CSTGL.FTCgpCode = CST.FTCgpCode AND CSTGL.FNLngID = ".$this->db->escape($nLngID)."
            LEFT JOIN [TCNMCstType_L] CSTTL WITH(NOLOCK) ON CSTTL.FTCtyCode = CST.FTCtyCode AND CSTTL.FNLngID = ".$this->db->escape($nLngID)."
            LEFT JOIN [TCNMCstLev_L] CSTLevL WITH(NOLOCK) ON CSTLevL.FTClvCode = CST.FTClvCode AND CSTLevL.FNLngID = ".$this->db->escape($nLngID)."
            LEFT JOIN [TCNMCstOcp_L] CSTOL WITH(NOLOCK) ON CSTOL.FTOcpCode = CST.FTOcpCode AND CSTOL.FNLngID = ".$this->db->escape($nLngID)."
            LEFT JOIN [TCNMPdtPmtGrp_L] PDTPmtGL WITH(NOLOCK) ON PDTPmtGL.FTPmgCode = CST.FTPmgCode AND PDTPmtGL.FNLngID = ".$this->db->escape($nLngID)."
            LEFT JOIN [TCNMBranch_L]  BCHL WITH(NOLOCK) ON CST.FTCstBchCode = BCHL.FTBchCode AND BCHL.FNLngID = ".$this->db->escape($nLngID)."
            LEFT JOIN [TCNMImgPerson] IMGP WITH(NOLOCK) ON IMGP.FTImgRefID = CST.FTCstCode AND IMGP.FNImgSeq = 1
            WHERE CST.FDCreateOn <> ''
        ";
        if($tCstCode!= ""){
            $tSQL   .= "AND CST.FTCstCode = ".$this->db->escape($tCstCode)."";
        }
        $oQuery = $this->db->query($tSQL);

        // Customer Credit
        $tCreditSQL =   "
            SELECT DISTINCT
                CRD.FNCstCrTerm         AS rtCstCrTerm,
                CRD.FCCstCrLimit        AS rtCstCrLimit,
                CRD.FTCstStaAlwOrdMon   AS rtCstStaAlwOrdMon,
                CRD.FTCstStaAlwOrdTue   AS rtCstStaAlwOrdTue,
                CRD.FTCstStaAlwOrdWed   AS rtCstStaAlwOrdWed,
                CRD.FTCstStaAlwOrdThu   AS rtCstStaAlwOrdThu,
                CRD.FTCstStaAlwOrdFri   AS rtCstStaAlwOrdFri,
                CRD.FTCstStaAlwOrdSat   AS rtCstStaAlwOrdSat,
                CRD.FTCstStaAlwOrdSun   AS rtCstStaAlwOrdSun,
                CRD.FTCstPayRmk         AS rtCstPayRmk,
                CRD.FTCstBillRmk        AS rtCstBillRmk,
                CRD.FTCstViaRmk         AS rtCstViaRmk,
                CRD.FNCstViaTime        AS rtCstViaTime,
                CRD.FTViaCode           AS rtViaCode,
                CRD.FTCstTspPaid        AS rtCstTspPaid,
                CRD.FTCstStaApv         AS rtCstStaApv,
                CRD.FCCstCrBuffer       AS rtCstCrBuffer,
                CRD.FCCstCrBalExt       AS rtCstCrBalExt,
                VIAL.FTViaName          AS rtViaName
            FROM [TCNMCstCredit] CRD WITH(NOLOCK)
            LEFT JOIN [TCNMShipVia_L] VIAL WITH(NOLOCK) ON VIAL.FTViaCode = CRD.FTViaCode AND VIAL.FNLngID = ".$this->db->escape($nLngID)."
            WHERE CRD.FTCstCode = ".$this->db->escape($tCstCode)."
        ";
        $oCreditQuery   = $this->db->query($tCreditSQL);

        if ($oQuery->num_rows() > 0){
            $aDetail        = $oQuery->row_array();
            $aCreditDetail  = $oCreditQuery->row_array();
            $aResult        = array(
                'raItems'   => @$aDetail,
                'raCredit'  => @$aCreditDetail,
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        }else{
            //Not Found
            $aResult = array(
                'rtCode'    => '800',
                'rtDesc'    => 'data not found.',
            );
        }
        return $aResult;
    }


    // Functionality : Add Or Update Customer Credit Card
    // Parameters    : function parameters
    // Creator       : 15/07/2022 Wasin
    // Return        : data
    // Return Type   : Array
    public function FSaMMCREventAddOrUpdCstCredit($paData){
        $this->db->trans_begin();
        $tSQLChkCCR = "
            SELECT CSTCR.FTCstCode,COUNT(CSTCR.FTCstCode) AS rtCNCountCst
            FROM TCNMCstCredit CSTCR WITH(NOLOCK)
            WHERE CSTCR.FTCstCode   = ".$this->db->escape($paData['FTCstCode'])."
            GROUP BY CSTCR.FTCstCode 
        ";
        $oQuery     = $this->db->query($tSQLChkCCR);
        $nStaData   = $oQuery->row_array()['rtCNCountCst'];
        if(isset($nStaData) && !empty($nStaData) && $nStaData > 0){
            // Update Customer Credit
            $this->db->set('FCCstCrLimit',$paData['FCCstCrLimit']);
            $this->db->set('FCCstCrBuffer',$paData['FCCstCrBuffer']);
            $this->db->set('FCCstCrBalExt',$paData['FCCstCrBalExt']);
            $this->db->set('FTCstStaApv',$paData['FTCstStaApv']);
            $this->db->where('FTCstCode',$paData['FTCstCode']);
            $this->db->update('TCNMCstCredit');
        }else{
            // Insert Customer Credit
            $this->db->insert('TCNMCstCredit',$paData);
        }

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            $aResult    = array(
                'rtCode'    => '800',
                'rtDesc'    => 'data not found.',
            );
        }else{
            $this->db->trans_commit();
            $aResult    = array(
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        }
        return $aResult;
    }




   











}