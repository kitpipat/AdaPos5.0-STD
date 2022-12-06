
<?php

defined('BASEPATH') or exit('No direct script access allowed');

class Rptdepositdailybypos_model extends CI_Model {

    // Functionality: Call Stored Procedure
    // Parameters:  Function Parameter
    // Creator: 19/12/2019 Witsarut(Bell)
    // Last Modified : -
    // Return : Status Return Call Stored Procedure
    // Return Type: Array
    public function FSnMExecStoreReport($paDataFilter){
        $nLangID        = $paDataFilter['nLangID'];
        $tComName       = $paDataFilter['tCompName'];
        $tRptCode       = $paDataFilter['tRptCode'];
        $tUserSession   = $paDataFilter['tUserSession'];
        $tFilterType    = $paDataFilter['nFilterType'];

        // สาขา
        $tBchCodeSelect = $paDataFilter['tBchCodeFrom']; 
        // เครื่องจุดขาย
        $tPosCodeSelect = $paDataFilter['tRptPosCodeFrom'];

        $tCallStore = "{CALL TRPTSalReconcile(?,?,?,?,?)}";
        $aDataStore = array(
            'ptUsrSession'  => $tUserSession,
            'pLangID'       => 1,

            //สาขา
            'ptBchL'        => $tBchCodeSelect,
           
             //pos   
            'ptPosCodeL'    => $tPosCodeSelect,

            //date
            'ptDocDateF'    => $paDataFilter['tDocDateFrom'],
        );

        $oQuery = $this->db->query($tCallStore, $aDataStore);
        // echo $this->db->last_query();
        // exit;
        // $oQuery = '';
        if ($oQuery !== FALSE) {
            unset($oQuery);
            return 1;
        } else {
            unset($oQuery);
            return 0;
        }
    }

    // Functionality: Get Data Report In Table Temp
    // Parameters:  Function Parameter
    // Creator: 23/12/2019 Witsarut (Bell)
    // Last Modified : -
    // Return : Array Data report
    // Return Type: Array
    public function FSaMGetDataReport($paDataWhere){

        $aPagination    = $this->FMaMRPTPagination($paDataWhere);
        $nRowIDStart    = $aPagination["nRowIDStart"];
        $nRowIDEnd      = $aPagination["nRowIDEnd"];
        $tUsrSession    = $paDataWhere['tUsrSessionID'];


        $tSQL = "SELECT
                    L.*,
                    T.*,
                    BCHL.FTBchName AS rtBchName,
                    POSL.FTPosName AS rtPosName
                FROM
                    (
                    SELECT DISTINCT
                        ROW_NUMBER ( ) OVER ( ORDER BY DATA.FTBchCode ASC ) AS RowID,
                        ROW_NUMBER ( ) OVER ( PARTITION BY FTBchCode ORDER BY DATA.FTBchCode ASC ) AS FNRowPartMer,
                        ROW_NUMBER ( ) OVER ( PARTITION BY FTPosCode ORDER BY DATA.FTPosCode ASC ) AS FNRowPartShp,
                        DATA.* 
                    FROM
                        TRPTSalReconcileTmp DATA WITH ( NOLOCK ) 
                    WHERE
                        1 = 1 
                        AND DATA.FTUsrSession = '$tUsrSession' 
                    ) L
                    LEFT JOIN (
                    SELECT DISTINCT
                        FTPosCode,
                        FDXshDocDate,
                        COUNT(FDXshDocDate) AS rtDateCount,
                        SUM ( SUB.FCPXsdGrand ) AS FCPXsdQty_Footer,
                        SUM ( SUB.FCPXshRefGrand ) AS FCPRefGrand_Footer,
                        SUM ( SUB.FCPXshTotal ) AS FCPTotal_Footer,
                        SUM ( SUB.FNTotalBillSale ) AS FNTotalBillSale_Footer,
		                SUM ( SUB.FNTotalBillRet ) AS FNTotalBillRet_Footer
                    FROM
                        (
                        SELECT DISTINCT
                            FTBchCode,
                            FTPosCode,
                            FDXshDocDate,
                            FTUsrSession AS FTUsrSession_Footer,
                            CONVERT ( FLOAT, FCXshGrand ) AS FCPXsdGrand,
                            CONVERT ( FLOAT, CAST ( FCXshRetGrand AS FLOAT ) ) AS FCPXshRefGrand,
                            CONVERT ( FLOAT, CAST ( FCXshTotal AS FLOAT ) ) AS FCPXshTotal,
                            CONVERT ( INT, FNXshBillSale ) AS FNTotalBillSale,
			                CONVERT ( INT, FNXshBillRet ) AS FNTotalBillRet
                        FROM
                            TRPTSalReconcileTmp WITH ( NOLOCK ) 
                        WHERE
                            1 = 1 
                            AND FTUsrSession = '$tUsrSession' 
                        ) SUB 
                    GROUP BY
                        FTPosCode , FDXshDocDate
                    ) T ON L.FTPosCode = T.FTPosCode AND L.FDXshDocDate = T.FDXshDocDate
                    LEFT JOIN TCNMBranch_L BCHL WITH(NOLOCK) ON BCHL.FTBchCode = L.FTBchCode
                    LEFT JOIN TCNMPos_L POSL WITH(NOLOCK) ON POSL.FTPosCode = L.FTPosCode AND POSL.FTBchCode = L.FTBchCode";
        $tSQL .= " WHERE L.RowID > $nRowIDStart AND L.RowID <= $nRowIDEnd ";
        $tSQL .= " ORDER BY L.FTBchCode , L.FTPosCode , L.FDXshDocDate";
        $oQuery = $this->db->query($tSQL);

        if ($oQuery->num_rows() > 0){
            $aData = $oQuery->result_array();
        
        }else{
            $aData = NULL;
        }

        $aErrorList = [
            "nErrInvalidPage" => ""
        ];

        $aResualt= [
            "aPagination"   => $aPagination,
            "aRptData"      => $aData,
            "aError"        => $aErrorList
        ];
        unset($oQuery); 
        unset($aData);
        return $aResualt;
    }

    // Functionality: Get Data Page Co
    // Parameters:  Function Parameter
    // Creator: 23/12/2019 Witsarut(Bell)
    // Last Modified : -
    // Return : Array Data Page Nation
    // Return Type: Array
    public function FMaMRPTPagination($paDataWhere){

        $tComName       = $paDataWhere['tCompName'];
        $tRptCode       = $paDataWhere['tRptCode'];
        $tUsrSession    = $paDataWhere['tUsrSessionID'];

        $tSQL = "   
                SELECT
                    SRCTMP.FTXshDocType
                FROM TRPTSalReconcileTmp SRCTMP WITH(NOLOCK)
                WHERE SRCTMP.FTUsrSession = '$tUsrSession'";

        $oQuery         = $this->db->query($tSQL);
        $nRptAllRecord  = $oQuery->num_rows();
        $nPage          = $paDataWhere['nPage'];
        $nPerPage       = $paDataWhere['nPerPage'];
        $nPrevPage      = $nPage-1;
        $nNextPage      = $nPage+1;

        $nRowIDStart = (($nPerPage*$nPage)-$nPerPage); 
        if($nRptAllRecord<=$nPerPage){
            $nTotalPage = 1;
        }else if(($nRptAllRecord % $nPerPage)==0){
            $nTotalPage = ($nRptAllRecord/$nPerPage) ;
        }else{
            $nTotalPage = ($nRptAllRecord/$nPerPage)+1;
            $nTotalPage = (int)$nTotalPage;
        }

        $nRowIDEnd = $nPerPage * $nPage;
        if($nRowIDEnd > $nRptAllRecord){
            $nRowIDEnd = $nRptAllRecord;
        }

        $aRptMemberDet = array(
            "nTotalRecord"  => $nRptAllRecord,
            "nTotalPage"    => $nTotalPage,
            "nDisplayPage"  => $paDataWhere['nPage'],
            "nRowIDStart"   => $nRowIDStart,
            "nRowIDEnd"     => $nRowIDEnd,
            "nPrevPage"     => $nPrevPage,
            "nNextPage"     => $nNextPage,
            "nPerPage"      => $nPerPage
        );
        unset($oQuery);
        return $aRptMemberDet;
    }


    // Functionality: Count Data Report All
    // Parameters: Function Parameter
    // Creator: 11/04/2019 Saharat(Golf)
    // Last Modified: -
    // Return: Data Report All
    // ReturnType: Array
    public function FSnMCountRowInTemp($paDataWhere) {
       
        $tUserSession   = $paDataWhere['tUsrSessionID'];

        $tSQL = "   SELECT 
                             COUNT(TSRTMP.FTXshDocType) AS rnCountPage
                         FROM TRPTSalReconcileTmp AS TSRTMP WITH(NOLOCK)
                         WHERE 1 = 1
                         AND FTUsrSession    = '$tUserSession'";

        $oQuery = $this->db->query($tSQL);
        $nRptAllRecord = $oQuery->row_array()['rnCountPage'];
        unset($oQuery);
        return $nRptAllRecord;
    }
   
}


