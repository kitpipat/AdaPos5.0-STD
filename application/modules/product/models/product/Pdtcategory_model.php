<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

class Pdtcategory_model extends CI_Model {


     //Functionality : check Data Userlogin
    //Parameters : function parameters
    //Creator : 27/04/2021 Nattakit
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSaMCGYFGetMaster($paData){
        try{
           
            $tPdtCode     = $paData['FTPdtCode'];
            $nLngID       = $paData['FNLngID'];

            $tSQL   = "SELECT
                            CAT.FTPdtCode,
                            PDTL.FTPdtName,
                            CATL1.FTCatCode         AS FTDepCode,
                            CATL1.FTCatName         AS FTDepName,
                            CATL2.FTCatCode         AS FTClsCode,
                            CATL2.FTCatName         AS FTClsName,
                            CATL3.FTCatCode         AS FTSclCode,
                            CATL3.FTCatName         AS FTSclName,
                            CATL4.FTCatCode         AS FTPgpCode,
                            CATL4.FTCatName         AS FTPgpName,
                            CATL5.FTCatCode         AS FTCmlCode,
                            CATL5.FTCatName         AS FTCmlName,
                            CAT.FTPdtModNo          AS FTFhnModNo,
                            CAT.FTPdtGender         AS FTFhnGender
                        FROM TCNMPdtCategory CAT WITH(NOLOCK)
                        INNER JOIN TCNMPdt_L        PDTL   WITH(NOLOCK) ON CAT.FTPdtCode = PDTL.FTPdtCode AND PDTL.FNLngID = $nLngID
                        LEFT OUTER JOIN TCNMPdtCatInfo_L CATL1  WITH(NOLOCK) ON CATL1.FTCatCode = CAT.FTPdtCat1 AND CATL1.FNCatLevel = 1 AND CATL1.FNLngID = $nLngID
                        LEFT OUTER JOIN TCNMPdtCatInfo_L CATL2  WITH(NOLOCK) ON CATL2.FTCatCode = CAT.FTPdtCat2 AND CATL2.FNCatLevel = 2 AND CATL2.FNLngID = $nLngID
                        LEFT OUTER JOIN TCNMPdtCatInfo_L CATL3  WITH(NOLOCK) ON CATL3.FTCatCode = CAT.FTPdtCat3 AND CATL3.FNCatLevel = 3 AND CATL3.FNLngID = $nLngID
                        LEFT OUTER JOIN TCNMPdtCatInfo_L CATL4  WITH(NOLOCK) ON CATL4.FTCatCode = CAT.FTPdtCat4 AND CATL4.FNCatLevel = 4 AND CATL4.FNLngID = $nLngID
                        LEFT OUTER JOIN TCNMPdtCatInfo_L CATL5  WITH(NOLOCK) ON CATL5.FTCatCode = CAT.FTPdtCat5 AND CATL5.FNCatLevel = 5 AND CATL5.FNLngID = $nLngID

                        /*LEFT OUTER JOIN TFHMPdtF1Depart_L PDTDPL WITH(NOLOCK) ON PdtFhn.FTDepCode = PDTDPL.FTDepCode AND PDTL.FNLngID = $nLngID
                        LEFT OUTER JOIN TFHMPdtF2Class_L PDTClSL WITH(NOLOCK) ON PdtFhn.FTClsCode = PDTClSL.FTClsCode AND PDTClSL.FNLngID = $nLngID
                        LEFT OUTER JOIN TFHMPdtF3SubClass_L PDTSClSL WITH(NOLOCK) ON PdtFhn.FTSclCode = PDTSClSL.FTSclCode AND PDTSClSL.FNLngID = $nLngID
                        LEFT OUTER JOIN TFHMPdtF4Group_L PDTGRPL WITH(NOLOCK) ON PdtFhn.FTPgpCode = PDTGRPL.FTPgpCode AND PDTGRPL.FNLngID = $nLngID
                        LEFT OUTER JOIN TFHMPdtF5ComLines_L PDTCML WITH(NOLOCK) ON PdtFhn.FTCmlCode = PDTCML.FTCmlCode AND PDTCML.FNLngID = $nLngID*/
    
                        WHERE 1=1 AND CAT.FTPdtCode = '$tPdtCode'";    
            $oQuery = $this->db->query($tSQL);

            if ($oQuery->num_rows() > 0){
                $oDetail    = $oQuery->result();
                $aResult= array(
                    'raItems'   => $oDetail[0],
                    'rtCode'    => '1',
                    'rtDesc'    => 'success',
                );
            }else{
                //if data not found
                $aResult    = array(
                    'rtCode'    => '800',
                    'rtDesc'    => 'data not found',
                );
            }    
            $jResult = json_encode($aResult);
            $aResult = json_decode($jResult, true);
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }

    }


    //Functionality : Add PdtFashion
    //Parameters : function parameters
    //Creator : 27/04/2021 Nattakit
    //Return : Array Stutus Add Update
    //Return Type : Array
    public function FSaMCGYAddUpdateMaster($paData){
        try{

            //ต้องไปอัพเดท วันที่ + เวลา ที่ตาราง TCNMPdt ว่ามีการเปลี่ยนแปลงด้วย
            $this->db->set('FDLastUpdOn',$paData['FDLastUpdOn']);
            $this->db->set('FTLastUpdBy',$paData['FTLastUpdBy']);
            $this->db->update('TCNMPdt');

            //Update Master
            $this->db->set('FTPdtCat1'        ,$paData['FTDepCode']);
            $this->db->set('FTPdtCat2'        ,$paData['FTClsCode']);
            $this->db->set('FTPdtCat3'        ,$paData['FTSclCode']);
            $this->db->set('FTPdtCat4'       ,$paData['FTPgpCode']);
            $this->db->set('FTPdtCat5'       ,$paData['FTCmlCode']);
            $this->db->set('FTPdtModNo'       ,$paData['FTFhnModNo']);
            $this->db->set('FTPdtGender'      ,$paData['FTFhnGender']);
            // $this->db->set('FTLastUpdBy'      ,$paData['FTLastUpdBy']);
            // $this->db->set('FDLastUpdOn'      ,$paData['FDLastUpdOn']);
            $this->db->where('FTPdtCode'      ,$paData['FTPdtCode']);
            $this->db->update('TCNMPdtCategory');
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Update Success',
                );
            }else{
                $aResult = array(
                    'FTPdtCode'             => $paData['FTPdtCode'],
                    'FTPdtCat1'             => $paData['FTDepCode'], 
                    'FTPdtCat2'             => $paData['FTClsCode'],
                    'FTPdtCat3'             => $paData['FTSclCode'],
                    'FTPdtCat4'            => $paData['FTPgpCode'],
                    'FTPdtCat5'            => $paData['FTCmlCode'],
                    'FTPdtModNo'            => $paData['FTFhnModNo'],
                    'FTPdtGender'           => $paData['FTFhnGender'],
                    // 'FDLastUpdOn'           => $paData['FDLastUpdOn'],
                    // 'FTLastUpdBy'           => $paData['FTLastUpdBy'],
                    // 'FDCreateOn'            => $paData['FDCreateOn'],
                    // 'FTCreateBy'            => $paData['FTCreateBy'],
                );

                // Add Data Master
                $this->db->insert('TCNMPdtCategory',$aResult);

                if($this->db->affected_rows() > 0){
                    $aStatus   = array(
                        'reCode'    => '1',
                        'rtDesc'    => 'Add Master Success',
                    );
                }else{
                    $aStatus = array(
                        'rtCode'    => '905',
                        'rtDesc'    => 'Error Cannot Add MAster',
                    );
                }

            }
            $jStatus = json_encode($aStatus);
            $aStatus = json_decode($jStatus, true);
            return $aStatus;
        }catch(Exception $Error){
            return $Error;
        }
    }



    //Functionality : Function Add PdtFashion
    //Parameters : From Ajax File PdtFashion
    //Creator : 27/04/2021 Nattakit
    //Last Modified : -
    //Return : Status Add Event
    //Return Type : array
    public function FSvMCGYCheckModelNo($tFhnPdtModelNo,$tPdtCode){
        try{
    
            $oQuery =  $this->db->where('FTPdtModNo',$tFhnPdtModelNo)->where('FTPdtCode !=',$tPdtCode)->get('TCNMPdtCategory');
            if ($oQuery->num_rows() > 0) {
                $aResult    =  array(
                    'rtCode'    => '1',
                    'rtDesc'    => 'Data ModelNo Duplicate'
                );
            } else {
                $aResult =  array(
                    'rtCode'    => '800',
                    'rtDesc'    => 'data not found'
                );
            }
            return $aResult;
        }catch(Exception $Error){
            return $Error;
        } 
    }

}