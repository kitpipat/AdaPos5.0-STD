<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

class Forms_model extends CI_Model {
    //Functionality : Search Reason By ID
    //Parameters : function parameters
    //Creator : 08/05/2018 Wasin
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSaMFRMSearchByID($ptAPIReq,$ptMethodReq,$paData){
        $tRsnCode   = $paData['FTRfuCode'];
        $nLngID     = $paData['FNLngID'];
        
        $tSQL = "SELECT
                        RFU.FTRfuCode   AS rtRfuCode,
                        RFUL.FTRfuName  AS rtRfuName, 
                        RFU.FTRfuFileName AS rtRfuFileName, 
                        RFS.FTRfsRptFileName AS rtRfsFileName, 
                        RFU.FTRfuPath AS rtRfuPath,
                        RFUL.FTRfuRemark   AS rtRfuRemark,
                        RFU.FTRfsCode   AS rtRfsCode,
                        RFS.FTRfsPath AS rtRfsPath,
                        RFSL.FTRfsName   AS rtRfsName,
                        RFU.FTAgnCode   AS rtAgnCode,
                        AGNL.FTAgnName  AS rtAgnName,
                        RFU.FTRfuStaAlwEdit AS rtRfuStaAlwEdit,
                        RFU.FTRfuStaUsrDef AS rtRfuStaUsrDef,
                        RFU.FTRfuStaUse AS rtRfuStaUse
                    FROM [TRPTRptFmtUsr] RFU
                    LEFT JOIN [TRPTRptFmtUsr_L] RFUL ON RFU.FTRfuCode = RFUL.FTRfuCode AND RFUL.FNLngID = $nLngID
                    LEFT JOIN [TCNMAgency_L] AGNL ON RFU.FTAgnCode  =  AGNL.FTAgnCode AND AGNL.FNLngID = $nLngID
                    LEFT JOIN [TRPSRptFormat] RFS ON RFU.FTRfsCode = RFS.FTRfsCode 
                    LEFT JOIN [TRPSRptFormat_L] RFSL ON RFU.FTRfsCode = RFSL.FTRfsCode AND RFSL.FNLngID = $nLngID
                    WHERE ISNULL(RFU.FTRfuCode,'')!= ''
                    AND  RFU.FTRfuCode = '$tRsnCode' ";
        
        $oQuery = $this->db->query($tSQL);


        if ($oQuery->num_rows() > 0){
            $oDetail = $oQuery->result();
            $aResult = array(
                'raItems'   => $oDetail[0],
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        }else{
            //Not Found
            $aResult = array(
                'rtCode' => '800',
                'rtDesc' => 'data not found.',
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }
    
    //Functionality : list Reason
    //Parameters : function parameters
    //Creator :  08/05/2018 Wasin
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSaMFRMList($ptAPIReq,$ptMethodReq,$paData){

        $aRowLen = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
        
        $nLngID = $paData['FNLngID'];

        $tSesAgnCode = $paData['tSesAgnCode'];
        
        $tSQL = "SELECT c.* FROM(
                    SELECT  ROW_NUMBER() OVER(ORDER BY rtFDCreateOn DESC, rtRfuCode DESC) AS rtRowID,* FROM
                        (SELECT DISTINCT
                            RFU.FTRfuCode   AS rtRfuCode,
                            RFUL.FTRfuName  AS rtRfuName,
                            RFU.FDCreateOn  AS rtFDCreateOn,
                            RFU.FTAgnCode   AS rtAgnCode,
                            AGNL.FTAgnName  AS rtAgnName
                         FROM [TRPTRptFmtUsr] RFU
                         LEFT JOIN [TRPTRptFmtUsr_L] RFUL ON RFU.FTRfuCode = RFUL.FTRfuCode AND RFUL.FNLngID = $nLngID
                         LEFT JOIN [TCNMAgency_L] AGNL ON RFU.FTAgnCode  =  AGNL.FTAgnCode AND AGNL.FNLngID = $nLngID
                         WHERE ISNULL(RFU.FTRfuCode,'')!= '' ";

        if($tSesAgnCode != ''){
            $tSQL .= "AND RFU.FTAgnCode = '$tSesAgnCode' ";
        }
        
        $tSearchList = $paData['tSearchAll'];
        if ($tSearchList != ''){
            $tSQL .= " AND (RFU.FTRfuCode COLLATE THAI_BIN LIKE '%$tSearchList%'";
            $tSQL .= " OR RFUL.FTRfuName COLLATE THAI_BIN LIKE '%$tSearchList%')";
        }
        
        $tSQL .= ") Base) AS c WHERE c.rtRowID > $aRowLen[0] AND c.rtRowID <= $aRowLen[1]";
        
        $oQuery = $this->db->query($tSQL);

        if ($oQuery->num_rows() > 0) {
            $oList = $oQuery->result();
            $aFoundRow = $this->FSnMFRMGetPageAll($tSearchList,$nLngID, $tSesAgnCode);
            $nFoundRow = $aFoundRow[0]->counts;
            $nPageAll = ceil($nFoundRow/$paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า
            $aResult = array(
                'raItems' => $oList,
                'rnAllRow' => $nFoundRow,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage"=> $nPageAll, 
                'rtCode' => '1',
                'rtDesc' => 'success',
            );
            $jResult = json_encode($aResult);
            $aResult = json_decode($jResult, true);
        }else{
            //No Data
            $aResult = array(
                'rnAllRow' => 0,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage"=> 0,
                'rtCode' => '800',
                'rtDesc' => 'data not found',
            );
            $jResult = json_encode($aResult);
            $aResult = json_decode($jResult, true);
        }
        
        return $aResult;
    }

    //Functionality : All Page Of Reason
    //Parameters : function parameters
    //Creator :  08/05/2018 Wasin
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSnMFRMGetPageAll($ptSearchList,$ptLngID ,$ptSesAgnCode){
        
        $tSQL = "SELECT COUNT (RFU.FTRfuCode) AS counts

                 FROM TRPTRptFmtUsr RFU
                 LEFT JOIN [TRPTRptFmtUsr_L] RFUL ON RFU.FTRfuCode = RFUL.FTRfuCode AND RFUL.FNLngID = $ptLngID
                 LEFT JOIN [TCNMAgency_L] AGNL ON RFU.FTAgnCode  =  AGNL.FTAgnCode AND AGNL.FNLngID = $ptLngID
                 WHERE ISNULL(RFU.FTRfuCode,'')!= '' ";
                 
        if($ptSesAgnCode != ''){
            $tSQL  .= " AND RFU.FTAgnCode = '$ptSesAgnCode' ";
        }
                 
        if($ptSearchList != ''){
            $tSQL .= " AND (RFU.FTRfuCode LIKE '%$ptSearchList%'";
            $tSQL .= " OR RFUL.FTRfuName LIKE '%$ptSearchList%')";
        }
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        }else{
            //No Data
            return false;
        }
    }


    
    //Functionality : Checkduplicate
    //Parameters : function parameters
    //Creator : 10/05/2018 wasin
    //Last Modified : -
    //Return : Data Count Duplicate
    //Return Type : Object
    public function FSoMFRMCheckDuplicate($ptRsnCode){
        $tSQL   = "SELECT COUNT(FTRfuCode)AS counts
                   FROM TRPTRptFmtUsr
                   WHERE FTRfuCode = '$ptRsnCode' ";
        $oQuery = $this->db->query($tSQL);
        if($oQuery->num_rows() > 0){
            return $oQuery->result();
        }else{
            return false;
        }
    }

    //Functionality : Function Add/Update Master
    //Parameters : function parameters
    //Creator : 10/05/2018 wasin
    //Last Modified : 11/06/2018 wasin
    //Return : Status Add/Update Master
    //Return Type : array
    public function FSaMFRMAddUpdateMaster($paData){
        try{
            //Update Master
            $this->db->set('FDLastUpdOn' , $paData['FDLastUpdOn']);
            $this->db->set('FTLastUpdBy' , $paData['FTLastUpdBy']);
            $this->db->set('FTRfsCode', $paData['FTRfsCode']);
            $this->db->set('FTRfuFileName', $paData['FTRfuFileName']);
            $this->db->set('FTRfuPath', $paData['FTRfuPath']);
            $this->db->set('FTRfuStaAlwEdit', $paData['FTRfuStaAlwEdit']);
            $this->db->set('FTRfuStaUsrDef', $paData['FTRfuStaUsrDef']);
            $this->db->set('FTRfuStaUse', $paData['FTRfuStaUse']);
            // $this->db->set('FTAgnCode', $paData['FTAgnCode']);
            $this->db->where('FTRfuCode', $paData['FTRfuCode']);
            $this->db->update('TRPTRptFmtUsr');
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Update Master Success',
                );
            }else{
                //Add Master
                $this->db->insert('TRPTRptFmtUsr',array(
                    'FTRfuCode'     => $paData['FTRfuCode'],
                    'FTAgnCode'     => $paData['FTAgnCode'],
                    'FTRfsCode'     => $paData['FTRfsCode'],
                    'FTRfuFormType' => $paData['FTRfuFormType'],
                    'FTRfuFileName' => $paData['FTRfuFileName'],
                    'FTRfuPath'     => $paData['FTRfuPath'],


                    'FTRfuStaAlwEdit' => $paData['FTRfuStaAlwEdit'],
                    'FTRfuStaUsrDef'   => $paData['FTRfuStaUsrDef'],
                    'FTRfuStaUse'     => $paData['FTRfuStaUse'],
                    //เวลาบันทึกล่าสุด
                    'FTLastUpdBy'   => $paData['FTLastUpdBy'],
                    'FDLastUpdOn'   => $paData['FDLastUpdOn'],

                    //เวลาบันทึกครั้งแรก
                    'FDCreateOn'    => $paData['FDCreateOn'],
                    'FTCreateBy'    => $paData['FTCreateBy'],
              
                ));
                if($this->db->affected_rows() > 0 ){
                    $aStatus = array(
                        'rtCode' => '1',
                        'rtDesc' => 'Add Master Success',
                    );
                }else{
                    $aStatus = array(
                        'rtCode' => '905',
                        'rtDesc' => 'Error Cannot Add/Edit Master.',
                    );
                }
            }
            return $aStatus;
        }catch(Exception $Error){
            return $Error;
        }
    }

    //Functionality : Functio Add/Update Lang
    //Parameters : function parameters
    //Creator :  10/05/2018 Wasin
    //Last Modified : 11/06/2018 wasin
    //Return : Status Add Update Lang
    //Return Type : Array
    public function FSaMFRMAddUpdateLang($paData){
        try{
            //Update Lang
            $this->db->set('FTRfuName', $paData['FTRfuName']);
            $this->db->set('FTRfuRemark', $paData['FTRfuRemark']);
            $this->db->where('FNLngID', $paData['FNLngID']);
            $this->db->where('FTRfuCode', $paData['FTRfuCode']);
            $this->db->update('TRPTRptFmtUsr_L');
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Update Lang Success.',
                );
            }else{
                //Add Lang
                $this->db->insert('TRPTRptFmtUsr_L',array(
                    'FTRfuCode'     => $paData['FTRfuCode'],
                    'FNLngID'       => $paData['FNLngID'],
                    'FTRfuName'     => $paData['FTRfuName'],
                    'FTRfuRemark'      => $paData['FTRfuRemark']
                ));
                if($this->db->affected_rows() > 0){
                    $aStatus = array(
                        'rtCode' => '1',
                        'rtDesc' => 'Add Lang Success',
                    );
                }else{
                    $aStatus = array(
                        'rtCode' => '905',
                        'rtDesc' => 'Error Cannot Add/Edit Lang.',
                    );
                }
            }
            return $aStatus;
        }catch(Exception $Error){
            return $Error;
        }
    }

    //Functionality : Delete Reason
    //Parameters : function parameters
    //Creator : 10/05/2018 wasin
    //Return : response
    //Return Type : array
    public function FSnMFRMDel($ptAPIReq,$ptMethodReq,$paData){

        try{
            $this->db->where_in('FTRfuCode', $paData['FTRfuCode']);
            $this->db->delete('TRPTRptFmtUsr');

            $this->db->where_in('FTRfuCode', $paData['FTRfuCode']);
            $this->db->delete('TRPTRptFmtUsr_L');

            if($this->db->trans_status() === FALSE){
                $this->db->trans_rollback();
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Delete Unsuccess.',
                );
            }else{
                $this->db->trans_commit();
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Delete Success.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }



  
    //Functionality : get all row data from pdt location
    //Parameters : -
    //Creator : 1/04/2019 Pap
    //Return : array result from db
    //Return Type : array

    public function FSnMLOCGetAllNumRow(){
        $tSQL = "SELECT COUNT(*) AS FNAllNumRow FROM TRPTRptFmtUsr";
        $oQuery = $this->db->query($tSQL);
        if($oQuery->num_rows() > 0){
            $aResult = $oQuery->row_array()["FNAllNumRow"];
        }else{
            $aResult = false;
        }
        return $aResult;
    }



    // Functionality : Function Get Data Url Api 
    // Parameters : Ajax and Function Parameter
    // Creator : 16/06/2021 Nattakit
    // LastUpdate: -
    // Return : Object Get Data Url Api 
    // Return Type : object
    public function FCNaMFRMGetObjectUrl(){

        $tSQL       = "SELECT TOP 1 FTUrlAddress FROM TCNTUrlObject WITH(NOLOCK) WHERE FTUrlKey = 'FILE' AND FTUrlTable = 'TCNMComp' AND FTUrlRefID = 'CENTER' ORDER BY FNUrlSeq ASC";
		$oQuery     = $this->db->query($tSQL);
		if($oQuery->num_rows() > 0){
			$oList      = $oQuery->result_array();
			$tUrlAddr   = $oList[0]['FTUrlAddress'];
		}else{
			$aReturn = array(
				'nStaEvent'    => 900,
				'tStaMessg'    => 'เกิดข้อผิดพลาด ไม่พบ API ในการเชื่อมต่อ'
			);
			return $aReturn;
		}

        return $tUrlAddr;

    }


    public function FSaMFRMStdGetUrlEditForm($ptSQL){
        
        $oQuery = $this->db->query($ptSQL);

        if ($oQuery->num_rows() > 0){
            $oDetail = $oQuery->row_array();
            $aResult = array(
                'raItems'   => $oDetail,
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        }else{
            //Not Found
            $aResult = array(
                'rtCode' => '800',
                'rtDesc' => 'data not found.',
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    // Functionality : Function Get Data Url Api 
    // Parameters : Ajax and Function Parameter
    // Creator : 16/06/2021 Nattakit
    // LastUpdate: -
    // Return : Object Get Data Url Api 
    // Return Type : object
    public function FSaMFRMAddUpdateStaDef($paData){
        try{
            $tAgnCode = $paData['FTAgnCode'];
            $tRfuCode = $paData['FTRfuCode'];
            $tRfsCode = $paData['FTRfsCode'];
            $this->db->set('FTRfuStaUsrDef', '2');
            $this->db->where('FTRfsCode', $paData['FTRfsCode']);
            $this->db->where('FTAgnCode', $paData['FTAgnCode']);
            $this->db->where('FTRfuCode!=', $paData['FTRfuCode']);
            $this->db->update('TRPTRptFmtUsr');

            if($this->db->trans_status() === FALSE){
                $this->db->trans_rollback();
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Delete Unsuccess.',
                );
            }else{
                $this->db->trans_commit();
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Delete Success.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }

    }

}