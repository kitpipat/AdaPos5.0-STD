<?php defined('BASEPATH') or exit('No direct script access allowed');

class Rptpackageusageinfo_model extends CI_Model
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
      
        // ประเภทเครื่องจุดขาย
        $tPosCodeSelect = ($paDataFilter['bPosStaSelectAll']) ? '' : FCNtAddSingleQuote($paDataFilter['tPosCodeSelect']);

        $tCallStore = "{ CALL SP_RPTxPackageCpnHisTmp(?,?,?,?,?,?,?,?,?) }";
        $aDataStore = array(
            'ptAgnCode'              => $paDataFilter['tAgnCode'],
            'ptUsrSessionID'         => $paDataFilter['tUserSession'],
            'pnLngID'                => $paDataFilter['nLangID'],
            'ptBchCode'              => $tBchCodeSelect,
            'ptPosCode'              => $tPosCodeSelect,
            'ptDocDateF'             => $paDataFilter['tDocDateFrom'],
            'ptDocDateT'             => $paDataFilter['tDocDateTo'],
            'ptCpnF'                 => $paDataFilter['tCouponCodeFrom'],
            'ptCpnT'                 => $paDataFilter['tCouponCodeTo'],
        );
    
        // echo '<pre>';
        // print_r($aDataStore);
        // echo '</pre>';
        // die();
        $oQuery = $this->db->query($tCallStore, $aDataStore);
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
        // $this->FMxMRPTAjdStkBal($tComName, $tRptCode, $tSession);

        // Check ว่าเป็นหน้าสุดท้ายหรือไม่ ถ้าเป็นหน้าสุดท้ายให้ไป Sum footer ข้อมูลมา
        if ($nPage == $nTotalPage) {
            $tJoinFoooter   =   "   SELECT 
                                            FTUsrSession_Footer,
                                            SUM(SUB.FCCpnAmtAmt) AS FCCpnAmtAmt_Footer
                                        FROM (
                                                SELECT  
                                                        FTCpnNo,
                                                        FTUsrSessID	        AS FTUsrSession_Footer,
                                                        CONVERT(FLOAT,FCXshCpnAmt)  AS FCCpnAmtAmt,
                                                        CONVERT(FLOAT,CAST(FCXshCpnAmtTatal AS FLOAT))  AS FCCpnAmtTatal,
                                                        CONVERT(FLOAT,CAST(FCXshCpnQtyUse AS FLOAT))  AS FCCpnQtyUse,
                                                        CONVERT(FLOAT,CAST(FCXshCpnQtyLeft as FLOAT))  AS FCCpnQtyLeft
                                                FROM TRPTPackageCpnHisTmp WITH(NOLOCK)
                                                WHERE 1=1
                                                AND FTUsrSessID    = '$tSession'
                                        ) SUB
                                        GROUP BY FTUsrSession_Footer
                                        ) T ON L.FTUsrSessID = T.FTUsrSession_Footer
            ";
        } else {
            // ถ้าไม่ใช่ให้ Select 0 เพื่อให้ Join ได้แต่จะไม่มีการ Sum
            $tJoinFoooter  =   "   SELECT
                                        '$tSession' AS FTUsrSession_Footer,
                                        '0'           AS FCCpnAmtAmt_Footer
                                    ) T ON  L.FTUsrSessID = T.FTUsrSession_Footer
            ";
        }

        $tSQL   = " SELECT
                        L.*,
                        T.*,
                        K.*,
                        Y.*
                    FROM (
                        SELECT DISTINCT
                        ROW_NUMBER() OVER(ORDER BY DATA.FTCpnNo ASC,DATA.FDXshDocDate ASC) AS RowID,
                        ROW_NUMBER() OVER(PARTITION BY FTCpnNo ORDER BY DATA.FTCpnNo ASC,DATA.FDXshDocDate ASC) AS FNRowPartCpn,
                            DATA.*
                        FROM TRPTPackageCpnHisTmp DATA WITH(NOLOCK)
                        WHERE 1=1
                        AND DATA.FTUsrSessID	    = '$tSession'
                    ) L
                    LEFT JOIN (
                        SELECT 
							F.FTCpnNo,
							F.FTUsrSession_Footer2,
							SUM(F.FCCpnAmtTatal) AS FCCpnAmtTatalGroupByCpn,
							SUM(F.FCCpnQtyUse) AS FCCpnQtyUseGroupByCpn,
							SUM(F.FCCpnQtyLeft) AS FCCpnQtyLeftGroupByCpn
							FROM (
							SELECT  
											FTCpnNo,
											FTUsrSessID	        AS FTUsrSession_Footer2,
											CONVERT(FLOAT,CAST(FCXshCpnAmtTatal AS FLOAT))  AS FCCpnAmtTatal,
											CONVERT(FLOAT,CAST(FCXshCpnQtyUse AS FLOAT))  AS FCCpnQtyUse,
											CONVERT(FLOAT,CAST(FCXshCpnQtyLeft as FLOAT))  AS FCCpnQtyLeft
							FROM TRPTPackageCpnHisTmp WITH(NOLOCK)
							WHERE 1=1
							AND FTUsrSessID    = '$tSession'
							GROUP BY FTCpnNo,FCXshCpnAmtTatal,FCXshCpnQtyUse,FCXshCpnQtyLeft,FTUsrSessID
							) F
							GROUP BY  F.FTCpnNo,F.FTUsrSession_Footer2
                    ) K ON  L.FTUsrSessID = K.FTUsrSession_Footer2 AND L.FTCpnNo=K.FTCpnNo
                    LEFT JOIN (
                        SELECT 
							F.FTUsrSession_Footer3,
							SUM(F.FCCpnAmtTatal) AS FCCpnAmtTatal_Footer,
							SUM(F.FCCpnQtyUse) AS FCCpnQtyUse_Footer,
							SUM(F.FCCpnQtyLeft) AS FCCpnQtyLeft_Footer
							FROM (
							SELECT  
											FTCpnNo,
											FTUsrSessID	        AS FTUsrSession_Footer3,
											CONVERT(FLOAT,CAST(FCXshCpnAmtTatal AS FLOAT))  AS FCCpnAmtTatal,
											CONVERT(FLOAT,CAST(FCXshCpnQtyUse AS FLOAT))  AS FCCpnQtyUse,
											CONVERT(FLOAT,CAST(FCXshCpnQtyLeft as FLOAT))  AS FCCpnQtyLeft
							FROM TRPTPackageCpnHisTmp WITH(NOLOCK)
							WHERE 1=1
							AND FTUsrSessID    = '$tSession'
							GROUP BY FTCpnNo,FCXshCpnAmtTatal,FCXshCpnQtyUse,FCXshCpnQtyLeft,FTUsrSessID
							) F
							GROUP BY F.FTUsrSession_Footer3
                    ) Y ON  L.FTUsrSessID = Y.FTUsrSession_Footer3 

                    LEFT JOIN (
                        " . $tJoinFoooter . "
        ";
        // WHERE เงื่อนไข Page
        $tSQL   .=  "   WHERE L.RowID > $nRowIDStart AND L.RowID <= $nRowIDEnd ";
        // สั่ง Order by ตามข้อมูลหลัก
        $tSQL   .=  "   ORDER BY L.FTCpnNo";

        // echo '<pre>'.print_r($tSQL).'</pre>';
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
        $aResualt = array(
            "aPagination"   =>  $aPagination,
            "aRptData"      =>  $aData,
            "aError"        =>  $aErrorList,
            "tSQL"          =>  $tSQL
        );
        unset($oQuery);
        unset($aData);
        return  $aResualt;
    }


    // Functionality: Count Data Report All
    // Parameters: Function Parameter
    // Creator: 22/04/2019 Wasin(Yoshi)
    // Last Modified: -
    // Return: Data Report All
    // ReturnType: Array    
    public function FSaMCountDataReportAll($paDataWhere)
    {
        $tUserCode  = $paDataWhere['tUserCode'];
        $tCompName  = $paDataWhere['tCompName'];
        $tRptCode   = $paDataWhere['tRptCode'];
        $tUserSession  = $paDataWhere['tUserSession'];
        $tSQL       = " SELECT 
                            FTRcvName  AS rtRcvName,
                            FTXshDocNo AS rtRcvDocNo,
                            FDCreateOn AS rtRcvCreateOn,
                            FCXrcNet   AS rtRcvrcNet 
                    FROM TRPTVDSalRCTmp  
                    WHERE 1 = 1 AND 
                    FTUsrSession = '$tUserSession' 
                    AND FTComName = '$tCompName' 
                    AND FTRptCode = '$tRptCode'";
        $oQuery     = $this->db->query($tSQL);
        $nCountData = $oQuery->num_rows();
        unset($oQuery);
        return $nCountData;
    }

    public function FMaMRPTPagination($paDataWhere)
    {

        $tComName       = $paDataWhere['tCompName'];
        $tRptCode       = $paDataWhere['tRptCode'];
        $tUsrSession    = $paDataWhere['tUsrSessionID'];
        $tSQL           =   "   SELECT
                                    COUNT(Cpn.FTCpnNo) AS rnCountPage
                                FROM TRPTPackageCpnHisTmp Cpn WITH(NOLOCK)
                                WHERE 1=1
                                AND FTUsrSessID    = '$tUsrSession'
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

    // public function FMxMRPTSetPriorityGroup($ptComName, $ptRptCode, $ptUsrSession)
    // {
    //     $tSQLUPD   = "  UPDATE DATAUPD
    //                     SET
    //                         DATAUPD.FNRowPartID     = DATASLT.PartIDPdt
    //                     FROM TRPTPdtStkCrdSumTmp DATAUPD
    //                     RIGHT JOIN (
    //                         SELECT 
    //                             ROW_NUMBER() OVER(PARTITION BY FTPdtCode ORDER BY FTPdtCode ASC,FTPdtCode ASC,FTRptRowSeq ASC) AS PartIDPdt,
    //                             FTRptRowSeq,
    //                             FTPdtCode,
    //                             FTComName,
    //                             FTRptCode,
    //                             FTUsrSession
    //                         FROM TRPTPdtStkCrdSumTmp WITH(NOLOCK)
    //                         WHERE 1=1
    //                         AND FTComName       = '$ptComName'
    //                         AND FTRptCode       = '$ptRptCode'
    //                         AND FTUsrSession    = '$ptUsrSession'
    //                     ) DATASLT ON 1=1
    //                     AND DATASLT.FTRptRowSeq     = DATAUPD.FTRptRowSeq
    //                     AND DATASLT.FTPdtCode       = DATAUPD.FTPdtCode
    //                     AND DATASLT.FTComName       = DATAUPD.FTComName
    //                     AND DATASLT.FTRptCode       = DATAUPD.FTRptCode
    //                     AND DATASLT.FTUsrSession	= DATAUPD.FTUsrSession
    //     ";
    //     $this->db->query($tSQLUPD);
    // }

    //set AjdStkBal
    // private function FMxMRPTAjdStkBal($ptComName, $ptRptCode, $ptUsrSession)
    // {
    //     // --Adjust stock balance in temp  
    //     $tSQL   = " UPDATE STK
    //                     SET STK.FCStkQtyBal =  STKAJB.FCStkBal
    //                 FROM TRPTPdtStkCrdSumTmp STK 
    //                 -- join this statement with main state key must refer by : FTWahCode,FTPdtCode,FTStkDocNo
    //                 LEFT JOIN (
    //                     SELECT STKB.* , 
    //                         --calculate running total partition by warehouse by products (use this column for show balance)
    //                         SUM(STKB.FCStkSumTrans) OVER ( PARTITION  BY STKB.FTPdtCode ORDER BY STKB.FTRptRowSeq) AS FCStkBal
    //                     FROM (
    //                         SELECT
    //                             FTRptRowSeq,FTPdtCode,
    //                             --get row number for order by sequence because sub query can not use order by
    //                             ROW_NUMBER() OVER(PARTITION by FTPdtCode ORDER BY FTPdtCode) AS FNStkRowGroupNo,
    //                             -- calculate stock (all transactions) 
    //                             SUM(FCStkQtyMonEnd + FCStkQtyIn - FCStkQtyOut + FCStkQtyAdj - (FCStkQtySaleDN - FCStkQtyCN) ) AS FCStkSumTrans
    //                         FROM TRPTPdtStkCrdSumTmp
    //                         WHERE 1 = 1
    //                         AND FTComName       = '$ptComName' 
    //                         AND FTRptCode       = '$ptRptCode'
    //                         AND FTUsrSession    = '$ptUsrSession'
    //                         --gropping data 
    //                         GROUP BY FTRptRowSeq,FTPdtCode
    //                 ) STKB ) STKAJB ON STK.FTPdtCode = STKAJB.FTPdtCode  ";

    //     $this->db->query($tSQL);
    // }

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
                DTTMP.FTCpnNo
            FROM TRPTPackageCpnHisTmp AS DTTMP WITH(NOLOCK)
            WHERE FTUsrSession = '$tUserSession'
        ";

        $oQuery = $this->db->query($tSQL);
        return $oQuery->num_rows();
    }
}
