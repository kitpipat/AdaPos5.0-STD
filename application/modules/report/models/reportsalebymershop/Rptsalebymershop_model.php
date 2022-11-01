<?php defined('BASEPATH') or exit('No direct script access allowed');

class Rptsalebymershop_model extends CI_Model
{


    //Functionality: Delete Temp Report
    //Parameters:  Function Parameter
    //Creator: 16/08/2019 Saharat(Golf)
    //Last Modified :
    //Return : Call Store Proce
    //Return Type: Array
    public function FSnMExecStoreReport($paDataFilter)
    {   
        // สาขา
        $tBchCodeSelect = ($paDataFilter['bBchStaSelectAll']) ? '' : $paDataFilter['tBchCodeSelect'];
        // ร้านค้า
        $tShpCodeSelect = ($paDataFilter['bShpStaSelectAll']) ? '' : $paDataFilter['tShpCodeSelect'];
        // กลุ่มธุรกิจ
        $tMerCodeSelect = ($paDataFilter['bMerStaSelectAll']) ? '' : $paDataFilter['tMerCodeSelect'];

        $tCallStore = "{ CALL SP_RPTxSalByMerShp(?,?,?,?,?,?,?,?,?) }";
        $aDataStore = array(
            // 'ptAgnCode'             => $paDataFilter['tAgnCode'],
            'ptUsrSession'           => $paDataFilter['tUserSession'],
            'ptLangID'               => $paDataFilter['nLangID'],
            'ptBchCode'              => $tBchCodeSelect,
            'ptMerCode'              => $tMerCodeSelect,
            'ptShpCode'              => $tShpCodeSelect,
            'ptDateF'                => $paDataFilter['tDocDateFrom'],
            'ptDateT'                => $paDataFilter['tDocDateTo'],
            'ptPdtCodeF'             => $paDataFilter['tPdtCodeFrom'],
            'ptPdtCodeT'             => $paDataFilter['tPdtCodeTo'],
        );
    
        // print_r($aDataStore);exit;
        $oQuery = $this->db->query($tCallStore, $aDataStore);
        // echo '<pre>';
        // print_r($this->db->last_query());
        // echo '</pre>';
        // die();
        if ($oQuery !== FALSE) {
            unset($oQuery);
            return 1;
        } else {
            unset($oQuery);
            return 0;
        }
    }

    // Functionality: Get Data Report
    // Parameters:  Function Parameter
    // Creator: 10/07/2019 Saharat(Golf)
    // Last Modified : 19/11/2019 wasin(Yoshi)
    // Return : Get Data Rpt Temp
    // Return Type: Array
    public function FSaMGetDataReport($paDataWhere)
    {

        $nPage          = $paDataWhere['nPage'];
        // Call Data Pagination 
        $aPagination    = $this->FMaMRPTPagination($paDataWhere);
        $nRowIDStart    = $aPagination["nRowIDStart"];
        $nRowIDEnd      = $aPagination["nRowIDEnd"];
        $nTotalPage     = $aPagination["nTotalPage"];
        $tComName       = $paDataWhere['tCompName'];
        $tRptCode       = $paDataWhere['tRptCode'];
        $tSession       = $paDataWhere['tUsrSessionID'];
        // $tSession       = 'SESS289M284756';


        //Set Priority
        // $this->FMxMRPTSetPriorityGroup($tComName, $tRptCode, $tSession);
        // $this->FMxMRPTAjdStkBal($tComName, $tRptCode, $tSession);

        // Check ว่าเป็นหน้าสุดท้ายหรือไม่ ถ้าเป็นหน้าสุดท้ายให้ไป Sum footer ข้อมูลมา
        if ($nPage == $nTotalPage) {
            $tJoinFoooter   =   "   SELECT 
                                            FTUsrSession_Footer,
                                            SUM(SUB.FCPXsdQty)                      AS FCPXsdQty_Footer,
                                            SUM(SUB.FCPTotal)                       AS FCPTotal_Footer,
                                            SUM(SUB.FCPDisChg)                      AS FCPDisChg_Footer,
                                            AVG(SUB.FCPAgvPri * SUB.FCPXsdQty)      AS FCPAgvPri_Footer,
                                            SUM(SUB.FCPGrand)                       AS FCPGrand_Footer
                                        FROM (
                                                SELECT  
                                                    FTMerCode, FTShpCode,
                                                    FTUsrSession	   AS FTUsrSession_Footer,
                                                    CONVERT(FLOAT,FTPXsdQty)  AS FCPXsdQty,
                                                    CONVERT(FLOAT,CAST(FCPXsdTotal  AS FLOAT))  AS FCPTotal,
                                                    CONVERT(FLOAT,CAST(FCPXsdDisChg AS FLOAT))  AS FCPDisChg,
                                                    CONVERT(FLOAT,CAST(FCPXsdAgvPri AS FLOAT))  AS FCPAgvPri,
                                                    CONVERT(FLOAT,CAST(FCPXsdGrand  AS FLOAT))  AS FCPGrand
                                                FROM TRPTSalByMerShpTmp WITH(NOLOCK)
                                                WHERE 1=1
                                                AND FTUsrSession    = '$tSession'
                                        ) SUB
                                        GROUP BY FTUsrSession_Footer
                                        ) T ON L.FTUsrSession = T.FTUsrSession_Footer
            ";
        } else {
            // ถ้าไม่ใช่ให้ Select 0 เพื่อให้ Join ได้แต่จะไม่มีการ Sum
            $tJoinFoooter  =   "   SELECT
                                        '$tSession' AS FTUsrSession_Footer,
                                        '0'           AS FCPXsdQty_Footer,
                                        '0'           AS FCPTotal_Footer,
                                        '0'           AS FCPDisChg_Footer,
                                        '0'           AS FCPAgvPri_Footer,
                                        '0'           AS FCPGrand_Footer,
                                    ) T ON  L.FTUsrSession = T.FTUsrSession_Footer
            ";
        }

        $tSQL   = " SELECT
                        L.*,
                        T.*
                    FROM (
                        SELECT DISTINCT
                        ROW_NUMBER() OVER(ORDER BY DATA.FTMerCode ASC) AS RowID,
                        ROW_NUMBER() OVER(PARTITION BY FTMerCode ORDER BY DATA.FTMerCode ASC) AS FNRowPartMer,
                        ROW_NUMBER() OVER(PARTITION BY FTShpCode ORDER BY DATA.FTShpCode ASC) AS FNRowPartShp,
                            DATA.*
                        FROM TRPTSalByMerShpTmp DATA WITH(NOLOCK)
                        WHERE 1=1
                        AND DATA.FTUsrSession	    = '$tSession'
                    ) L
                    LEFT JOIN (
                        " . $tJoinFoooter . "
        ";
        // WHERE เงื่อนไข Page
        $tSQL   .=  "   WHERE L.RowID > $nRowIDStart AND L.RowID <= $nRowIDEnd ";
        // สั่ง Order by ตามข้อมูลหลัก
        $tSQL   .=  "   ORDER BY L.FTMerCode";

        // echo '<pre>';
        // print_r($tSQL);
        // echo '</pre>';
        // exit();
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $aData  = $oQuery->result_array();
        } else {
            $aData  = NULL;
        }
        $aErrorList =   array(
            "nErrInvalidPage"   =>  ""
        );
        $aResult = array(
            "aPagination"   =>  $aPagination,
            "aRptData"      =>  $aData,
            "aError"        =>  $aErrorList,
            "tSQL"          =>  $tSQL
        );
        
        // echo '<pre>'.print_r($aData).'</pre>';
        unset($oQuery);
        unset($aData);
        return  $aResult;
    }

    public function FMaMRPTPagination($paDataWhere)
    {

        $tComName       = $paDataWhere['tCompName'];
        $tRptCode       = $paDataWhere['tRptCode'];
        $tUsrSession    = $paDataWhere['tUsrSessionID'];
        // $tUsrSession    = 'SESS289M284756';
        $tSQL           =   "   SELECT
                                    COUNT(Pdt.FTPdtCode) AS rnCountPage
                                FROM TRPTSalByMerShpTmp Pdt WITH(NOLOCK)
                                WHERE 1=1
                                AND FTUsrSession    = '$tUsrSession'
                            ";
                            
        $oQuery         = $this->db->query($tSQL);
        $nRptAllRecord  = $oQuery->row_array()['rnCountPage'];

        $nPage          = $paDataWhere['nPage'];
        $nPerPage       = $paDataWhere['nPerPage'];
        $nPrevPage      = $nPage - 1;
        $nNextPage      = $nPage + 1;
        $nRowIDStart    = (($nPerPage * $nPage) - $nPerPage); //RowId Start
        if ($nRptAllRecord <= $nPerPage) {
            $nTotalPage = 1;
        } else if (($nRptAllRecord % $nPerPage) == 0) {
            $nTotalPage = ($nRptAllRecord / $nPerPage);
        } else {
            $nTotalPage = ($nRptAllRecord / $nPerPage) + 1;
            $nTotalPage = (int) $nTotalPage;
        }

        // get rowid end
        $nRowIDEnd = $nPerPage * $nPage;
        if ($nRowIDEnd > $nRptAllRecord) {
            $nRowIDEnd = $nRptAllRecord;
        }
     
        $aRptMemberDet = array(
            "nTotalRecord"  =>  $nRptAllRecord,
            "nTotalPage"    =>  $nTotalPage,
            "nDisplayPage"  =>  $paDataWhere['nPage'],
            "nRowIDStart"   =>  $nRowIDStart,
            "nRowIDEnd"     =>  $nRowIDEnd,
            "nPrevPage"     =>  $nPrevPage,
            "nNextPage"     =>  $nNextPage
        );
        unset($oQuery);
        return $aRptMemberDet;
    }

    // Functionality: Count Data Report All
    // Parameters: Function Parameter
    // Creator: 21/08/2019 Saharat(Golf)
    // Last Modified: -
    // Return: Data Report All
    // ReturnType: Array
    public function FSnMCountDataReportAll($paDataWhere)
    {
        $tUserSession   = $paDataWhere['tUserSession'];
        $tCompName      = $paDataWhere['tCompName'];
        $tRptCode       = $paDataWhere['tRptCode'];

        $tSQL = "   
            SELECT 
                DTTMP.FTPdtCode
            FROM TRPTSalByMerShpTmp AS DTTMP WITH(NOLOCK)
            WHERE FTUsrSession = '$tUserSession'
        ";

        $oQuery = $this->db->query($tSQL);
        return $oQuery->num_rows();
    }
}
