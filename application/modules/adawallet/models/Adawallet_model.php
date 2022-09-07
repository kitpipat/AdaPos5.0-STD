<?php defined('BASEPATH') or exit('No direct script access allowed');
date_default_timezone_set('Asia/Bangkok');

class Adawallet_model extends CI_Model {

    public function FSxMADWRcvSpc() {

        $tsql = "SELECT CFG.*
                FROM (
                    SELECT CASE WHEN ISNULL(FTSysStaUsrValue,'') <> '' 
                        THEN FTSysStaUsrValue
                        ELSE FTSysStaDefValue END AS FTRcvCode
                    FROM  TSysConfig WITH(NOLOCK) 
                    WHERE FTSysCode = 'tPS_VirtualRcvDef'
                    AND FTSysApp = 'CN'
                    AND FTSysKey = 'VirtualPosRcvDef'
                    AND FTSysSeq = '1'
                ) RCV
                INNER JOIN TFNMRcvSpcConfig CFG WITH(NOLOCK)  ON RCV.FTRcvCode = CFG.FTRcvCode
                ORDER BY CFG.FNSysSeq";
        
        $aQuery = $this->db->query($tsql);

        if($aQuery->num_rows() > 0){
            $aResult = $aQuery->result();

        }
        else {
            $aResult = array(
                'rtCode' => '800',
                'rtDesc' => 'data not found',
            );
        }

		return $aResult;
    }

    public function FSnMMADWDecimal() {
        $tsql = "SELECT 
                CASE WHEN ISNULL(FTSysStaUsrValue,'') <> '' THEN FTSysStaUsrValue
                ELSE  FTSysStaDefValue END AS FNShowDecimal
                FROM TSysConfig WITH(NOLOCK) WHERE FTSysCode = 'ADecPntShw' AND FTSysApp = 'CN'";

        $aQuery = $this->db->query($tsql);

        if($aQuery->num_rows() > 0) {
            $aResult = $aQuery->result();
        }else {
            $aResult = array(
                'rtCode' => '800',
                'rtDesc' => 'data not found',
            );
        }

		return $aResult;
    }

}