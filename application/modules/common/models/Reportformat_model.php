<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

class Reportformat_model extends CI_Model {
 



    // Functionality : Function Get Data 
    // Parameters : Ajax and Function Parameter
    // Creator : 16/06/2021 Nattakit
    // LastUpdate: -
    // Return : Object Get Data 
    // Return Type : object
    public function FCNaMRFTCallDataTable($ptParam){

        $tRtfCode   = $ptParam['tRtfCode'];
        $tBchCode     = $ptParam['tBchCode'];

        $tSQL ="    SELECT
                        '' AS FTAgnCode,
                        RFT.FTRfsCode,
                        '' AS FTRfuCode,
                        RFT_L.FTRfsName AS FTRtpName,
                        RFT.FTRfsPath AS FTRptPath,
                        RFT.FTRfsRptFileName AS FTRptFileName,
                        RFT.FTRfsRptFileName,
                        '' AS FTRfuStaUsrDef
                    FROM
                        TRPSRptFormat RFT WITH(NOLOCK)
                    LEFT JOIN TRPSRptFormat_L RFT_L WITH(NOLOCK) ON RFT.FTRfsCode = RFT_L.FTRfsCode AND RFT_L.FNLngID = 1
                    WHERE RFT.FTRfsCode = '$tRtfCode'
                    UNION ALL
                    SELECT
                        RFU.FTAgnCode,
                        RFU.FTRfsCode,
                        RFU.FTRfuCode,
                        RFU_L.FTRfuName AS FTRtpName,
                        RFU.FTRfuPath AS FTRptPath,
                        RFU.FTRfuFileName AS FTRptFileName,
                        RFS.FTRfsRptFileName,
                        RFU.FTRfuStaUsrDef
                    FROM
                        TRPTRptFmtUsr RFU WITH(NOLOCK)
                    LEFT JOIN TRPTRptFmtUsr_L RFU_L WITH(NOLOCK) ON RFU.FTRfuCode =  RFU_L.FTRfuCode AND  RFU_L.FNLngID = 1
                    LEFT JOIN [TRPSRptFormat] RFS ON RFU.FTRfsCode = RFS.FTRfsCode 
                    WHERE RFU.FTAgnCode = (SELECT TOP 1 FTAgnCode FROM TCNMBranch WITH(NOLOCK) WHERE FTBchCode = '$tBchCode')
                    AND RFU.FTRfsCode = '$tRtfCode'
                    AND RFU.FTRfuStaUse = '1'
        ";

             $oQuery = $this->db->query($tSQL);
             $nNumrows = $oQuery->num_rows();
             if($nNumrows > 0){

                if($nNumrows==1){
                    $aStatus = array(
                        'rtCode'    => '1',
                        'raItems'   => $oQuery->result_array(),
                        'rtDesc'    => 'Exec Success.',
                    );
                }else{
                    $aStatus = array(
                        'rtCode'    => '2',
                        'raItems'   => $oQuery->result_array(),
                        'rtDesc'    => 'Exec Success.',
                    );
                }

            }else{
                $aStatus = array(
                    'rtCode'    => '905',
                    'rtDesc'    => 'Not Found Format.',
                );
            }
            return $aStatus;

    }
    
 

}