<?php defined('BASEPATH') or exit('No direct script access allowed');

class Rptdailysaleinfoanime_model extends CI_Model
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

        $tCallStore = "{ CALL SP_RPTxDailySaleINFO_Animate(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) }";
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
            'ptAgnCode'         => $paDataFilter['tAgnCode'],
            'ptPdtCodeF'        => $paDataFilter['tPdtCodeFrom'],
            'ptPdtCodeT'        => $paDataFilter['tPdtCodeTo'],
            'ptPdtChanF'        => $paDataFilter['tPdtGrpCodeFrom'],
            'ptPdtChanT'        => $paDataFilter['tPdtGrpCodeTo'],
            'ptPdtTypeF'        => $paDataFilter['tPdtTypeCodeFrom'],
            'ptPdtTypeT'        => $paDataFilter['tPdtTypeCodeTo'],
            'ptPbnCodeF'        => $paDataFilter['tPbnCodeFrom'],
            'ptPbnCodeT'        => $paDataFilter['tPbnCodeTo'],
            'ptDocDateF'        => $paDataFilter['tDocDateFrom'],
            'ptDocDateT'        => $paDataFilter['tDocDateTo'],
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
                                        CONVERT(FLOAT,SUM(FCPdtStkSetPrice))              AS FCPdtStkSetPrice_Footer,
                                        CONVERT(FLOAT,SUM(FCPdtStkQtyIn))                  AS FCPdtStkQtyIn_Footer,
                                        CONVERT(FLOAT,SUM(FCPdtStkQtySale))                 AS FCPdtStkQtySale_Footer,
                                        CONVERT(FLOAT,SUM(FCStkQtyBal))                 AS FCStkQtyBal_Footer
                                    FROM TRPTSaleINFOTmp_Animate WITH(NOLOCK)
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
                                        '0'           AS FCPdtStkSetPrice_Footer,
                                        '0'           AS FCPdtStkQtyIn_Footer,
                                        '0'           AS FCPdtStkQtySale_Footer,
                                        '0'           AS FCStkQtyBal_Footer
                                    ) T ON  L.FTUsrSession = T.FTUsrSession_Footer
            ";
        }

        $tSQL   = " SELECT
                        L.*,
                        T.*
                    FROM (
                        SELECT DISTINCT
                        ROW_NUMBER() OVER(ORDER BY DATA.FTPtyName ASC,DATA.FTPbnName ASC,DATA.FTPdtCode ASC,DATA.FTBarCode ASC, DATA.FTRptRowSeq ASC) AS RowID,
                            DATA.*
                        FROM TRPTSaleINFOTmp_Animate DATA WITH(NOLOCK)
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
        $tSQL   .=  "   ORDER BY L.FTPtyName,L.FTPbnName ,L.FTPdtCode,L.FTBarCode,L.FTRptRowSeq,L.FNRowPartID";

    
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
                                FROM TRPTSaleINFOTmp_Animate STK WITH(NOLOCK)
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
                        FROM TRPTSaleINFOTmp_Animate DATAUPD
                        RIGHT JOIN (
                            SELECT 
                                ROW_NUMBER() OVER(PARTITION BY FTPtyName,FTPbnName,FTPdtCode ORDER BY FTPtyName ASC,FTPbnName ASC,FTPdtCode ASC,FTBarCode ASC,FTRptRowSeq ASC) AS PartIDPdt,
                                FTRptRowSeq,
                                FTPtyName,
                                FTPbnName,
                                FTPdtCode,
                                FTComName,
                                FTRptCode,
                                FTUsrSession
                            FROM TRPTSaleINFOTmp_Animate WITH(NOLOCK)
                            WHERE 1=1
                            AND FTComName       = '$ptComName'
                            AND FTRptCode       = '$ptRptCode'
                            AND FTUsrSession    = '$ptUsrSession'
                        ) DATASLT ON 1=1
                        AND DATASLT.FTRptRowSeq     = DATAUPD.FTRptRowSeq
                        AND DATASLT.FTPtyName       = DATAUPD.FTPtyName
                        AND DATASLT.FTPbnName       = DATAUPD.FTPbnName
                        AND DATASLT.FTPdtCode       = DATAUPD.FTPdtCode
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
            FROM TRPTSaleINFOTmp_Animate AS DTTMP WITH(NOLOCK)
            WHERE FTUsrSession = '$tUserSession'
            AND FTComName = '$tCompName'
            AND FTRptCode = '$tRptCode'
        ";

        $oQuery = $this->db->query($tSQL);
        return $oQuery->num_rows();
    }
}
