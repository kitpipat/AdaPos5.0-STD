<?php defined('BASEPATH') or exit('No direct script access allowed');

class Rptpssvatbymonth_model extends CI_Model
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
        $tBchCodeSelect = ($paDataFilter['bBchStaSelectAll']) ? '' : FCNtAddSingleQuote($paDataFilter['tBchCodeSelect']);
        // ร้านค้า
        $tShpCodeSelect = ($paDataFilter['bShpStaSelectAll']) ? '' : FCNtAddSingleQuote($paDataFilter['tShpCodeSelect']);
        // กลุ่มธุรกิจ
        $tMerCodeSelect = ($paDataFilter['bMerStaSelectAll']) ? '' : FCNtAddSingleQuote($paDataFilter['tMerCodeSelect']);
        // ประเภทเครื่องจุดขาย
        $tPosCodeSelect = ($paDataFilter['bPosStaSelectAll']) ? '' : FCNtAddSingleQuote($paDataFilter['tPosCodeSelect']);

        $tCallStore = "{ CALL SP_RPTxPSSVatByMonth_Animate(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) }";
        $aDataStore = array(
            'pnLngID'           => $paDataFilter['nLangID'],
            'pnComName'         => $paDataFilter['tCompName'],
            'ptRptCode'         => $paDataFilter['tRptCode'],
            'ptUsrSession'      => $paDataFilter['tUserSession'],
            'pnFilterType'      => $paDataFilter['tTypeSelect'],
            'ptBchL'            => $tBchCodeSelect,
            'ptBchF'            => $paDataFilter['tBchCodeFrom'],
            'ptBchT'            => $paDataFilter['tBchCodeTo'],
            'ptMerL'            => $tMerCodeSelect,
            'ptMerF'            => $paDataFilter['tMerCodeFrom'],
            'ptMerT'            => $paDataFilter['tMerCodeTo'],
            'ptShpL'            => $tShpCodeSelect,
            'ptShpF'            => $paDataFilter['tShpCodeFrom'],
            'ptShpT'            => $paDataFilter['tShpCodeTo'],
            'ptPosL'            => $tPosCodeSelect,
            'ptPosF'            => $paDataFilter['tPosCodeFrom'],
            'ptPosT'            => $paDataFilter['tPosCodeTo'],
            'ptMonth'           => $paDataFilter['tMonth'],
            'ptYear'            => $paDataFilter['tYear'],
            'FNResult'          => 0,
        );

        $oQuery = $this->db->query($tCallStore, $aDataStore);

        // echo $this->db->last_query();
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

        //Set Priority
        // $this->FMxMRPTSetPriorityGroup($tComName, $tRptCode, $tSession);
    

        // Check ว่าเป็นหน้าสุดท้ายหรือไม่ ถ้าเป็นหน้าสุดท้ายให้ไป Sum footer ข้อมูลมา
        if ($nPage == $nTotalPage) {
            $tJoinFoooter   =   "   SELECT
                                        FTUsrSession                                    AS FTUsrSession_Footer,
                                        CONVERT(FLOAT,SUM(FCXshAmtNV))              AS FCXshAmtNV_Footer,
                                        CONVERT(FLOAT,SUM(FCXshVatable))                  AS FCXshVatable_Footer,
                                        CONVERT(FLOAT,SUM(FCXshVat))                 AS FCXshVat_Footer,
                                        CONVERT(FLOAT,SUM(FCXshGrandAmt))                 AS FCXshGrandAmt_Footer
                                    FROM TRPTPSTaxMonthTmp_Animate WITH(NOLOCK)
                                    WHERE 1=1
                                    AND FTComName       = '$tComName'
                                    AND FTRptCode       = '$tRptCode'
                                    AND FTUsrSession    = '$tSession'
                                    GROUP BY FTUsrSession
                                    ) T ON L.FTUsrSession = T.FTUsrSession_Footer
            ";
        } else {
            // ถ้าไม่ใช่ให้ Select 0 เพื่อให้ Join ได้แต่จะไม่มีการ Sum
            $tJoinFoooter  =   "   SELECT
                                        '$tSession' AS FTUsrSession_Footer,
                                        '0'           AS FCXshAmtNV_Footer,
                                        '0'           AS FCXshVatable_Footer,
                                        '0'           AS FCXshVat_Footer,
                                        '0'           AS FCXshGrandAmt_Footer
                                    ) T ON  L.FTUsrSession = T.FTUsrSession_Footer
            ";
        }

        $tSQL   = " SELECT
                        L.*,
                        T.*
                    FROM (
                        SELECT DISTINCT
                        ROW_NUMBER() OVER(ORDER BY DATA.FTBchCode ASC,DATA.FTCstCode ASC,DATA.FTXshMonthTH ASC,DATA.FTXshDocDate ASC, DATA.FTRptRowSeq ASC) AS RowID,
                            DATA.*
                        FROM TRPTPSTaxMonthTmp_Animate DATA WITH(NOLOCK)
                        WHERE 1=1
                        AND DATA.FTComName		= '$tComName'
                        AND DATA.FTRptCode		= '$tRptCode'
                        AND DATA.FTUsrSession	    = '$tSession'
                    ) L
                    LEFT JOIN (
                        " . $tJoinFoooter . "
        ";
        // WHERE เงื่อนไข Page
        $tSQL   .=  "   WHERE L.RowID > $nRowIDStart AND L.RowID <= $nRowIDEnd ";
        // สั่ง Order by ตามข้อมูลหลัก
        $tSQL   .=  "   ORDER BY L.FTBchCode,L.FTCstCode ,L.FTXshMonthTH,L.FTXshDocDate,L.FTRptRowSeq,L.FNRowPartID";

    
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $aData  = $oQuery->result_array();
        } else {
            $aData  = NULL;
        }
        $aErrorList =   array(
            "nErrInvalidPage"   =>  ""
        );
        $aResualt = array(
            "aPagination"   =>  $aPagination,
            "aRptData"      =>  $aData,
            "aError"        =>  $aErrorList
        );
        unset($oQuery);
        unset($aData);
        return  $aResualt;
    }


    public function FMaMRPTPagination($paDataWhere)
    {

        $tComName       = $paDataWhere['tCompName'];
        $tRptCode       = $paDataWhere['tRptCode'];
        $tUsrSession    = $paDataWhere['tUsrSessionID'];
        $tSQL           =   "   SELECT
                                    COUNT(*) AS rnCountPage
                                FROM TRPTPSTaxMonthTmp_Animate STK WITH(NOLOCK)
                                WHERE 1=1
                                AND STK.FTComName    = '$tComName'
                                AND STK.FTRptCode    = '$tRptCode'
                                AND STK.FTUsrSession = '$tUsrSession'
                                
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

    public function FMxMRPTSetPriorityGroup($ptComName, $ptRptCode, $ptUsrSession)
    {
        $tSQLUPD   = "  UPDATE DATAUPD
                        SET
                            DATAUPD.FNRowPartID     = DATASLT.PartIDPdt
                        FROM TRPTPSTaxMonthTmp_Animate DATAUPD
                        RIGHT JOIN (
                            SELECT 
                                ROW_NUMBER() OVER(PARTITION BY FTBchCode,FTCstCode,FTXshMonthTH ORDER BY FTBchCode ASC,FTCstCode ASC,FTXshMonthTH ASC,FTXshDocDate ASC,FTRptRowSeq ASC) AS PartIDPdt,
                                FTRptRowSeq,
                                FTBchCode,
                                FTCstCode,
                                FTXshMonthTH,
                                FTComName,
                                FTRptCode,
                                FTUsrSession
                            FROM TRPTPSTaxMonthTmp_Animate WITH(NOLOCK)
                            WHERE 1=1
                            AND FTComName       = '$ptComName'
                            AND FTRptCode       = '$ptRptCode'
                            AND FTUsrSession    = '$ptUsrSession'
                        ) DATASLT ON 1=1
                        AND DATASLT.FTRptRowSeq     = DATAUPD.FTRptRowSeq
                        AND DATASLT.FTBchCode       = DATAUPD.FTBchCode
                        AND DATASLT.FTCstCode       = DATAUPD.FTCstCode
                        AND DATASLT.FTXshMonthTH       = DATAUPD.FTXshMonthTH
                        AND DATASLT.FTComName       = DATAUPD.FTComName
                        AND DATASLT.FTRptCode       = DATAUPD.FTRptCode
                        AND DATASLT.FTUsrSession	= DATAUPD.FTUsrSession
        ";
        $this->db->query($tSQLUPD);
    }


    // Functionality: Count Data Report All
    // Parameters: Function Parameter
    // Creator: 21/08/2019 Saharat(Golf)
    // Last Modified: -
    // Return: Data Report All
    // ReturnType: Array
    public function FSnMCountDataReportAll($paDataWhere)
    {
        $tUserSession = $paDataWhere['tUserSession'];
        $tCompName = $paDataWhere['tCompName'];
        $tRptCode = $paDataWhere['tRptCode'];

        $tSQL = "   
            SELECT 
                DTTMP.FTRptCode
            FROM TRPTPSTaxMonthTmp_Animate AS DTTMP WITH(NOLOCK)
            WHERE FTUsrSession = '$tUserSession'
            AND FTComName = '$tCompName'
            AND FTRptCode = '$tRptCode'
        ";

        $oQuery = $this->db->query($tSQL);
        return $oQuery->num_rows();
    }
}
