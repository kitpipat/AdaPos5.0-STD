<?php 
defined('BASEPATH') or exit('No direct script access allowed');

class Upgrade_model extends CI_Model {

    //Functionality : list Branch
    //Parameters : function parameters
    //Creator : 09/03/2018 Krit(Copter)
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSaMUPGDataTable($paData) {

        $aRowLen = FCNaHCallLenData($paData['nRow'], $paData['nPage']);
        $nLngID = $this->session->userdata('tLangEdit');

        $tUPGBchCode = $this->input->post('oetUPGBchCode');
        $tUPGPosCode = $this->input->post('oetUPGPosCode');
        $tUPGDataForm = $this->input->post('oetUPGDataForm');
        $tUPGDataTo = $this->input->post('oetUPGDataTo');
        $tUPGUUIDFrm = $this->input->post('oetUPGUUIDFrm');
        $tUPGUUIDTo = $this->input->post('oetUPGUUIDTo');
        $tUPGDocNoOld = $this->input->post('oetUPGDocNoOld');
        $tUPGBillType = $this->input->post('oetUPGBillType');
        $tWhere = "";

        // User BCH Level
		if ($this->session->userdata('tSesUsrLevel') == "BCH") { // ผู้ใช้ระดับ BCH ดูได้แค่สาขาที่มีสิทธิ์
			$tBchCodeMulti = $this->session->userdata('tSesUsrBchCodeMulti');
			$tWhere .= " AND HIS.FTBchCode IN($tBchCodeMulti)";
        }


        if(!empty($tUPGBchCode)){
            $tWhere .= " AND HIS.FTBchCode='$tUPGBchCode' "; 
        }

        if(!empty($tUPGPosCode)){
            $tWhere .= " AND HIS.FTPosCode='$tUPGPosCode' "; 
        }
        if(empty($tUPGUUIDFrm) && empty($tUPGUUIDTo) && empty($tUPGDocNoOld)){
            if(!empty($tUPGDataForm) && !empty($tUPGDataTo)){
                $tWhere .= "  AND CONVERT (DATE, HIS.FDCreateOn, 103) BETWEEN '$tUPGDataForm' AND '$tUPGDataTo' "; 
            }
        }
        
        if(!empty($tUPGUUIDFrm)){
            $tWhere .= " AND HIS.FTXdhDocNo='$tUPGUUIDFrm' "; 
        }

        if(!empty($tUPGUUIDTo)){
            $tWhere .= " AND HIS.FTXdhDocNo<='$tUPGUUIDTo' "; 
        }

        if(!empty($tUPGDocNoOld)){
            $tWhere .= " AND HIS.FTLogOldDocNo='$tUPGDocNoOld' "; 
        }

        if ($tUPGBillType != '') {
            if($tUPGBillType==0){
            $tWhere  .= " AND (ISNULL(HIS.FTXdsStaPrc,'') = '' OR ISNULL(HIS.FTXdsStaPrc,'') = 0 ) ";
            }else{
            $tWhere  .= " AND HIS.FTXdsStaPrc = $tUPGBillType";
            }
        }else{
            $tWhere   .= '';
        }

        $tSQL   =   "   SELECT c.* FROM(
                            SELECT  ROW_NUMBER() OVER(ORDER BY FTXdhDocNo) AS rtRowID,* FROM (
                                SELECT
                                    HIS.FTAgnCode,
                                    AGN_L.FTAgnName,
                                    HIS.FTBchCode,
                                    HIS.FTMerCode,
                                    HIS.FTShpCode,
                                    HIS.FTPosCode,
                                    HIS.FTAppName AS AppCode,
                                    HIS.FTXdhDocNo,
                                    HD_L.FTXdhDepName,
                                    HIS.FDXdsDUpgrade,
                                    HIS.FTXdsStaPrc,
                                    HIS.FTXdsStaDoc,
                                    (
                                        SELECT TOP 1 FTXdhDocNo 
                                        FROM TCNTAppDepHis 
                                        WHERE FTXdsStaPrc = '1'  
                                        AND FTXdsStaDoc = '1'
                                        AND FTBchCode = HIS.FTBchCode
                                        AND FTPosCode = HIS.FTPosCode
                                        AND FDCreateOn < HIS.FDCreateOn
                                        ORDER BY FDXdsDUpgrade DESC
                                    ) AS FTXdhDocNoOld,
                                    (
                                        SELECT
                                            TOP 1 HD_L1.FTXdhDepName
                                        FROM
                                            TCNTAppDepHis
                                        LEFT OUTER JOIN TCNTAppDepHD_L HD_L1 WITH (NOLOCK) ON TCNTAppDepHis.FTXdhDocNo = HD_L1.FTXdhDocNo AND  HD_L1.FNLngID = $nLngID
                                        WHERE
                                            FTXdsStaPrc = '1'
                                        AND FTXdsStaDoc = '1'
                                        AND FTBchCode = HIS.FTBchCode
                                        AND FTPosCode = HIS.FTPosCode
                                        AND FDCreateOn < HIS.FDCreateOn
                                        ORDER BY
                                            FDXdsDUpgrade DESC
                                    ) AS FTXdhDepNameOld
                                FROM
                                    TCNTAppDepHis HIS WITH(NOLOCK)
                                LEFT OUTER JOIN TCNMAgency_L AGN_L WITH(NOLOCK) ON HIS.FTAgnCode = AGN_L.FTAgnCode AND AGN_L.FNLngID = $nLngID
                                LEFT OUTER JOIN TCNTAppDepHD_L HD_L WITH (NOLOCK) ON HIS.FTXdhDocNo = HD_L.FTXdhDocNo AND  HD_L.FNLngID = $nLngID
                                WHERE HIS.FTXdhDocNo IS NOT NULL
                                $tWhere

        ";


        $tSQL .= ") Base) AS c WHERE c.rtRowID > $aRowLen[0] AND c.rtRowID <= $aRowLen[1]";
        
        $oQuery = $this->db->query($tSQL);
        // echo $this->db->last_query();
        // die();

        if ($oQuery->num_rows() > 0) {

            $aList = $oQuery->result();
            $aFoundRow = $this->JSnMUPGBCHGetPageAll($tWhere);
            $nFoundRow = $aFoundRow[0]->counts;
            $nPageAll = ceil($nFoundRow / $paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า 

            $aResult = array(
                'raItems' => $aList,
                'rnAllRow' => $nFoundRow,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage" => $nPageAll,
                'rtCode' => '1',
                'rtDesc' => 'success',
            );
            $jResult = json_encode($aResult);
            $aResult = json_decode($jResult, true);
        } else {
            //No Data
            $aResult = array(
                'rnAllRow' => 0,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage" => 0,
                'rtCode' => '800',
                'rtDesc' => 'data not found',
            );
            $jResult = json_encode($aResult);
            $aResult = json_decode($jResult, true);
        }
        return $aResult;
    }

    //Functionality : All Page Of Branch
    //Parameters : function parameters
    //Creator : 09/03/2018 Krit(Copter)
    //Last Modified : -
    //Return : data
    //Return Type : Array
    function JSnMUPGBCHGetPageAll($ptWhere) {
        $nLngID = $this->session->userdata('tLangEdit');
        $tSQL = "SELECT  COUNT(*) AS counts
                        FROM TCNTAppDepHis HIS WITH(NOLOCK)
                        WHERE HIS.FTXdhDocNo IS NOT NULL
                    $ptWhere
                    ";
                    
	

        $oQuery = $this->db->query($tSQL);

        if ($oQuery->num_rows() > 0) {

            return $oQuery->result();
        } else {
            //No Data
            return false;
        }
    }



}