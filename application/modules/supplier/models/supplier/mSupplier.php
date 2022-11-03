<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

class mSupplier extends CI_Model {

    //Functionality : list Data Supplier
    //Parameters : function parameters
    //Creator :  22/10/2018 Phisan
    //Return : data
    //Return Type : Array
    public function FSaMSPLList($paData){
        try{
            $aRowLen        = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
            $nLngID         = $paData['FNLngID'];
            $tSearchList    = $paData['tSearchAll'];

            $tSQLHeader     = " SELECT c.* FROM( SELECT  ROW_NUMBER() OVER(ORDER BY FDCreateOn DESC , rtSplCode DESC) AS rtRowID,* FROM ( ";
            $tSQL           = "     SELECT DISTINCT
                                        SPL.FTSplCode AS rtSplCode,
                                        SPL_L.FTSplName AS rtSplName,
                                        SPL.FTSplTel AS rtSplTel,
                                        SPL.FTSplEmail AS rtSplEmail,
                                        SPL.FDCreateOn,
                                        Img.FTImgObj
                                    FROM TCNMSpl SPL WITH(NOLOCK)
                                    LEFT JOIN TCNMSpl_L SPL_L WITH(NOLOCK) ON SPL.FTSplCode = SPL_L.FTSplCode AND SPL_L.FNLngID = $nLngID
                                    LEFT JOIN TCNMImgObj Img WITH(NOLOCK) ON Img.FTImgRefID = SPL.FTSplCode AND Img.FTImgTable = 'TCNMSpl'

                                    WHERE 1=1 ";
            if(isset($tSearchList) && !empty($tSearchList)){
                $tSQL .= " AND (SPL.FTSplCode  COLLATE THAI_BIN LIKE '%$tSearchList%'";
                $tSQL .= " OR SPL_L.FTSplName  COLLATE THAI_BIN LIKE '%$tSearchList%'";
                $tSQL .= " OR SPL.FTSplTel     COLLATE THAI_BIN LIKE '%$tSearchList%'";
                $tSQL .= " OR SPL.FTSplEmail   COLLATE THAI_BIN LIKE '%$tSearchList%')";
            }

            $tAgnCode = $this->session->userdata("tSesUsrAgnCode");
            if($tAgnCode != ""){
                $tSQL .= " AND ( SPL.FTAgnCode = '$tAgnCode' OR ISNULL(SPL.FTAgnCode,'') = '' ) ";
            }

            $tSQL   .= " ORDER BY SPL.FDCreateOn DESC";

            $tSQLFooter = " ) Base) AS c WHERE c.rtRowID > $aRowLen[0] AND c.rtRowID <= $aRowLen[1] ";

            $tSQLMain = $tSQLHeader.$tSQL.$tSQLFooter;
            $tSQLSub  = $tSQL;

            $oQuery = $this->db->query($tSQL);
            if( $oQuery->num_rows() > 0 ){
                $oQuerySub  = $this->db->query($tSQLSub);
                $aList      = $oQuery->result_array();
                $nFoundRow  = $oQuerySub->num_rows();
                // $oFoundRow = $this->FSoMSPLGetPageAll($tSearchList,$nLngID);
                // $nFoundRow = $oFoundRow[0]->counts;
                $nPageAll   = ceil($nFoundRow/$paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า
                $aResult    = array(
                    'raItems'       => $aList,
                    'rnAllRow'      => $nFoundRow,
                    'rnCurrentPage' => $paData['nPage'],
                    'rnAllPage'     => $nPageAll,
                    'rtCode'        => '1',
                    'rtDesc'        => 'success',
                );
            }else{
                //No Data
                $aResult = array(
                    'rnAllRow'      => 0,
                    'rnCurrentPage' => $paData['nPage'],
                    "rnAllPage"     => 0,
                    'rtCode'        => '800',
                    'rtDesc'        => 'data not found',
                );
            }
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : All Page Of Supplier
    //Parameters : function parameters
    //Creator :  22/10/2018 Phisan
    //Return : object Count All Product Type
    //Return Type : Object
    // public function FSoMSPLGetPageAll($ptSearchList,$pnLngID){
    //     try{
    //         $tSQL = "SELECT COUNT (SPL.FTSplCode) AS counts
    //                  FROM TCNMSpl SPL
    //                  LEFT JOIN TCNMSpl_L SPL_L ON SPL.FTSplCode = SPL_L.FTSplCode AND SPL_L.FNLngID = $pnLngID
    //                  WHERE 1=1 ";
    //         if(isset($ptSearchList) && !empty($ptSearchList)){
    //             $tSQL .= " AND (SPL.FTSplCode  COLLATE THAI_BIN LIKE '%$ptSearchList%'";
    //             $tSQL .= " OR SPL_L.FTSplName  COLLATE THAI_BIN LIKE '%$ptSearchList%'";
    //             $tSQL .= " OR SPL.FTSplTel     COLLATE THAI_BIN LIKE '%$ptSearchList%'";
    //             $tSQL .= " OR SPL.FTSplEmail   COLLATE THAI_BIN LIKE '%$ptSearchList%')";
    //         }

    //         $tAgnCode = $this->session->userdata("tSesUsrAgnCode");
    //         if($tAgnCode != ""){
    //             $tSQL .= "AND SPL.FTAgnCode = '$tAgnCode' ";
    //         }

    //         $oQuery = $this->db->query($tSQL);
    //         if ($oQuery->num_rows() > 0) {
    //             return $oQuery->result();
    //         }else{
    //             return false;
    //         }
    //     }catch(Exception $Error){
    //         echo $Error;
    //     }
    // }

    //Functionality : Get Data Supplier By ID
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan
    //Return : data
    //Return Type : Array
    public function FSaMSPLGetDataByID($paData){
        try{
            $tSplCode   = $paData['FTSplCode'];
            $nLngID     = $paData['FNLngID'];
            $tSQL       = " SELECT
                                SPL.FTSplCode           AS rtSplCode,
                                SPL_L.FTSplName         AS rtSplName,
                                SPL.FTSplTel            AS rtSplTel,
                                SPL.FTSplEmail          AS rtSplEmail,
                                SPL.FTSplFax            AS rtSplFax,
                                SPL.FTSplSex            AS rtSplSex,
                                SPL.FDSplDob            AS rtSplDob,
                                SPL.FTSgpCode           AS rtSgpCode,
                                Grp_L.FTSgpName         AS rtSgpName,
                                SPL.FTStyCode           AS rtStyCode,
                                Type_L.FTStyName        AS rtStyName,
                                SPL.FTSlvCode           AS rtSlvCode,
                                Lev_L.FTSlvName         AS rtSlvName,
                                SPL.FTVatCode           AS rtVatCode,
                                SPL.FTFmtCodeExp        AS rtFmtCodeExp,
                                Fmt_L.FTRfsName         AS rtFTRfsName,
                                SPL.FTSplStaVATInOrEx   AS rtSplStaVATInOrEx,
                                SPL.FTSplDiscBillRet    AS rtSplDiscBillRet,
                                SPL.FTSplDiscBillWhs    AS rtSplDiscBillWhs,
                                SPL.FTSplDiscBillNet    AS rtSplDiscBillNet,
                                SPL.FTSplBusiness       AS rtSplBusiness,
                                SPL.FTSplStaBchOrHQ     AS rtSplStaBchOrHQ,
                                SPL.FTSplStaLocal       AS rtSplStaLocal,
                                SPL.FTSplBchCode        AS rtSplBchCode,
                                SPL.FTSplStaActive      AS rtSplStaActive,
                                SPL.FTUsrCode           AS rtUsrCode,
                                Usr_L.FTUsrName         AS rtUsrName,
                                SPL_L.FTSplCode         AS rtSplCode,
                                SPL_L.FNLngID           AS rtLngID,
                                SPL_L.FTSplPayRmk       AS rtSplPayRmk,
                                SPL_L.FTSplBillRmk      AS rtSplBillRmk,
                                SPL_L.FTSplViaRmk       AS rtSplViaRmk,
                                SPL_L.FTSplRmk          AS rtSplRmk,
                                Crd.FDSplApply          AS rtSplApply,
                                Crd.FTSplRefExCrdNo     AS rtSplRefExCrdNo,
                                Crd.FDSplCrdIssue       AS rtSplCrdIssue,
                                Crd.FDSplCrdExpire      AS rtSplCrdExpire,
                                Cred.FNSplCrTerm        AS rtSplCrTerm,
                                Cred.FCSplCrLimit       AS rtSplCrLimit,
                                Cred.FTSplDayCta        AS rtSplDayCta,
                                Cred.FDSplLastCta       AS rtSplLastCta,
                                Cred.FDSplLastPay       AS rtSplLastPay,
                                Cred.FNSplLimitRow      AS rtSplLimitRow,
                                Cred.FCSplLeadTime      AS rtSplLeadTime,
                                Cred.FTViaCode          AS rtViaCode,
                                Ship_L.FTViaName        AS rtViaName,
                                Cred.FTSplTspPaid       AS rtSplTspPaid,
                                Img.FTImgObj            AS rtImgObj,
                                AGN_L.FTAgnCode         AS FTAgnCode,
                                AGN_L.FTAgnName         AS FTAgnName
                            FROM TCNMSpl SPL WITH(NOLOCK)
                            LEFT JOIN TCNMAgency_L      AGN_L   WITH(NOLOCK) ON SPL.FTAgnCode       = AGN_L.FTAgnCode   AND AGN_L.FNLngID   = $nLngID
                            LEFT JOIN TCNMSpl_L         SPL_L   WITH(NOLOCK) ON SPL.FTSplCode       = SPL_L.FTSplCode   AND SPL_L.FNLngID   = $nLngID
                            LEFT JOIN TCNMSplGrp_L      Grp_L   WITH(NOLOCK) ON SPL.FTSgpCode       = Grp_L.FTSgpCode   AND Grp_L.FNLngID   = $nLngID
                            LEFT JOIN TCNMSplType_L     Type_L  WITH(NOLOCK) ON SPL.FTStyCode       = Type_L.FTStyCode  AND Type_L.FNLngID  = $nLngID
                            LEFT JOIN TCNMSplLev_L      Lev_L   WITH(NOLOCK) ON SPL.FTSlvCode       = Lev_L.FTSlvCode   AND Lev_L.FNLngID   = $nLngID 
                            LEFT JOIN TCNMSplCredit     Cred    WITH(NOLOCK) ON SPL.FTSplCode       = Cred.FTSplCode
                            LEFT JOIN TCNMShipVia_L     Ship_L  WITH(NOLOCK) ON Cred.FTViaCode      = Ship_L.FTViaCode  AND Ship_L.FNLngID  = $nLngID 
                            LEFT JOIN TCNMSplCard       Crd     WITH(NOLOCK) ON SPL.FTSplCode       = Crd.FTSplCode 
                            LEFT JOIN TCNMImgObj        Img     WITH(NOLOCK) ON Img.FTImgRefID      = SPL.FTSplCode     AND Img.FNImgSeq    = '1' AND Img.FTImgTable = 'TCNMSpl' AND Img.FTImgKey = 'main' AND Img.FNImgSeq = 1
                            LEFT JOIN TRPSRptFormat     Fmt                  ON SPL.FTFmtCodeExp    =  Fmt.FTRfsCode   
                            LEFT JOIN TRPSRptFormat_L   Fmt_L                ON Fmt_L.FTRfsCode     =  Fmt .FTRfsCode   AND Fmt_L.FNLngID   = $nLngID
                            LEFT JOIN TCNMUser          Usr                  ON SPL.FTUsrCode       =  Usr.FTUsrCode   
                            LEFT JOIN TCNMUser_L        Usr_L                ON Usr_L.FTUsrCode     =  Usr.FTUsrCode    AND Usr_L.FNLngID   = $nLngID
                            WHERE 1=1 AND SPL.FTSplCode = '$tSplCode' ";
            $oQuery = $this->db->query($tSQL);
            if ($oQuery->num_rows() > 0){
                $aDetail = $oQuery->row_array();
                $aResult = array(
                    'raItems'   => $aDetail,
                    'rtCode'    => '1',
                    'rtDesc'    => 'success',
                );
            }else{
                $aResult = array(
                    'rtCode' => '800',
                    'rtDesc' => 'Data not found.',
                );
            }
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }
    }


    //Functionality : Checkduplicate Suppliers
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan
    //Return : data
    //Return Type : Array
    public function  FSnMSPLCheckDuplicate($ptSplCode){
        try{
            $tSQL = "SELECT COUNT(SPL.FTSplCode) AS counts
                 FROM TCNMSpl SPL 
                 WHERE SPL.FTSplCode = '$ptSplCode' ";
            $oQuery = $this->db->query($tSQL);
            if($oQuery->num_rows() > 0){
                return $oQuery->row_array();
            }else{
                return FALSE;
            }
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Add Table Supplier
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan
    //Return : Array Stutus Add/Update
    //Return Type : Array
    public function FSaMSPLAddMaster($paData){
        try{
            //Add Supplier Main Table
            $this->db->insert('TCNMSpl',$paData);
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Add Supplier Success.',
                );
            }else{
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Error Cannot Add/Edit Supplier.',
                );
            }
            
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Update Table Supplier
    //Parameters : function parameters
    //Creator : 09/11/2018 Phisan
    //Return : Array Stutus Add/Update
    //Return Type : Array
    public function FSaMSPLUpdateMaster($paData){
        try{
            $this->db->where('FTSplCode', $paData['FTSplCode']);
            $this->db->update('TCNMSpl',$paData);
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Update Supplier Success.',
                );
            }else{
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Error Cannot Edit Supplier.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }
    //Functionality : Update Table DT
    //Parameters : function parameters
    //Creator : 09/11/2018 Phisan
    //Return : Array Stutus Add/Update
    //Return Type : Array
    public function FSaMSPLUpdateDT($paData,$ptNanmeTable){
        try{
            $this->db->where('FTSplCode', $paData['FTSplCode']);
            $this->db->update($ptNanmeTable,$paData);
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Update Detail Success.',
                );
            }else{
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Error Cannot Edit Detail.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Add DT Supplier
    //Parameters : function parameters
    //Creator : 09/11/2018 Phisan
    //Return : Array Stutus Add/Update
    //Return Type : Array
    public function FSaMSPLAddDT($paData,$tTableName){
        try{
            //Add Supplier Main Table
            $this->db->insert($tTableName,$paData);
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Add Detail Success.',
                );
            }else{
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Error Cannot Add Detail.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Update Supplier Lang
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan
    //Return : Array Stutus Add Update
    //Return Type : array
    public function FSaMSPLAddLang($paData){
        try{
            
            $this->db->insert('TCNMSpl_L', $paData);
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Add Supplier Lang Success.',
                );
            }else{
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Error Cannot Add/Edit Supplier Lang.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Delete Supplier
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan
    //Return : Status Delete
    //Return Type : array
    public function FSnMSPLDel($paData){
        try{
            $this->db->trans_begin();
            $this->db->where_in('FTSplCode', $paData['FTSplCode']);
            $this->db->delete('TCNMSpl');

            $this->db->where_in('FTSplCode', $paData['FTSplCode']);
            $this->db->delete('TCNMSpl_L');

            $this->db->where_in('FTSplCode', $paData['FTSplCode']);
            $this->db->delete('TCNMPdtSpl');

            $this->db->where_in('FTSplCode', $paData['FTSplCode']);
            $this->db->delete('TCNMSplAddress_L');

            $this->db->where_in('FTSplCode', $paData['FTSplCode']);
            $this->db->delete('TCNMSplCard');

            $this->db->where_in('FTSplCode', $paData['FTSplCode']);
            $this->db->delete('TCNMSplContact_L');
            
            $this->db->where_in('FTSplCode', $paData['FTSplCode']);
            $this->db->delete('TCNMSplCredit');

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

    //Functionality : list Data Supplier
    //Parameters : function parameters
    //Creator :  22/10/2018 Phisan
    //Return : data
    //Return Type : Array
    public function FSaMSPLAddType(){
        try{
            $tSQL           = "SELECT FTSysStaDefValue, FTSysStaUsrValue  
                               FROM TSysConfig
                               WHERE FTSysCode ='tCN_AddressType' AND FTSysKey = 'TCNMSpl' ";
            $oQuery = $this->db->query($tSQL);
            if($oQuery->num_rows() > 0){
                $aList = $oQuery->result_array();
                $aResult = array(
                    'raItems'       => $aList,
                    'rtCode'        => '1',
                    'rtDesc'        => 'success',
                );
            }else{
                //No Data
                $aResult = array(
                    'rtCode' => '800',
                    'rtDesc' => 'data not found',
                );
            }
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Add Table SupplierAddress
    //Parameters : function parameters
    //Creator : 21/06/2019 Sarun
    //Return : Array Stutus Add
    //Return Type : Array
    public function FSaMSPLAddAddress($paData){
        try{
            //Add Supplier Main Table
            $this->db->insert('TCNMSplAddress_L',$paData);
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Add Supplier Success.',
                );
            }else{
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Error Cannot Add/Edit Supplier.',
                );
            }
            
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Add Table SupplierContact
    //Parameters : function parameters
    //Creator : 26/06/2019 Sarun
    //Return : Array Stutus Add
    //Return Type : Array
    public function FSaMSPLAddContact($paData){
        try{
            //Add Supplier Main Table
            $this->db->insert('TCNMSplContact_L',$paData);
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Add Supplier Success.',
                );
            }else{
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Error Cannot Add/Edit Supplier.',
                );
            }
            
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Get Data Supplier By ID
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan
    //Return : data
    //Return Type : Array
    public function FSaMSPLGetDataAddress($paData){
        try{
            // $tSplCode   = $paData['FTSplCode'];
            $tSplCode   = $paData;
            $tSQL       = " SELECT * FROM TCNMSplAddress_L
                            WHERE FTSplCode = '$tSplCode' ORDER BY FNAddSeqNO";
            $oQuery = $this->db->query($tSQL);
            if ($oQuery->num_rows() > 0){
                $aDetail = $oQuery->result_array();
                $aResult = array(
                    'raItems'   => $aDetail,
                    'rtCode'    => '1',
                    'rtDesc'    => 'success',
                );
            }else{
                $aResult = array(
                    'rtCode' => '800',
                    'rtDesc' => 'Data not found.',
                );
            }
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Get Data Supplier Contact By ID
    //Parameters : SplCode
    //Creator : 26/06/2019 Sarun
    //Return : data
    //Return Type : Array
    public function FSaMSPLGetDataContact($paData){
        try{
            // $tSplCode   = $paData['FTSplCode'];
            $tSplCode   = $paData;
            $tSQL       = " SELECT * FROM TCNMSplContact_L
                            WHERE FTSplCode = '$tSplCode' ORDER BY FNCtrSeq";
            $oQuery = $this->db->query($tSQL);
            if ($oQuery->num_rows() > 0){
                $aDetail = $oQuery->result_array();
                $aResult = array(
                    'raItems'   => $aDetail,
                    'rtCode'    => '1',
                    'rtDesc'    => 'success',
                );
            }else{
                $aResult = array(
                    'rtCode' => '800',
                    'rtDesc' => 'Data not found.',
                );
            }
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }
    }


    public function FSaMSPLGetAddressDataByID($paData){
        try{
            $tSplCode   = $paData['FTSplCode'];
            $nSeqNo   = $paData['FNSeqNo'];
            // $nLngID     = $paData['FNLngID'];
            $tSQL       = " SELECT * FROM TCNMSplAddress_L
                            WHERE FTSplCode = '$tSplCode' AND FNAddSeqNo = '$nSeqNo'";                
            $oQuery = $this->db->query($tSQL);
            if ($oQuery->num_rows() > 0){
                $aDetail = $oQuery->row_array();
                $aResult = array(
                    'raItems'   => $aDetail,
                    'rtCode'    => '1',
                    'rtDesc'    => 'success',
                );
            }else{
                $aResult = array(
                    'rtCode' => '800',
                    'rtDesc' => 'Data not found.',
                );
            }
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    public function FSaMSPLGetContactDataByID($paData){
        try{
            $tSplCode   = $paData['FTSplCode'];
            $nSeqNo   = $paData['FNCtrSeq'];
            // $nLngID     = $paData['FNLngID'];
            $tSQL       = " SELECT * FROM TCNMSplContact_L
                            WHERE FTSplCode = '$tSplCode' AND FNCtrSeq = '$nSeqNo'";                
            $oQuery = $this->db->query($tSQL);
            if ($oQuery->num_rows() > 0){
                $aDetail = $oQuery->row_array();
                $aResult = array(
                    'raItems'   => $aDetail,
                    'rtCode'    => '1',
                    'rtDesc'    => 'success',
                );
            }else{
                $aResult = array(
                    'rtCode' => '800',
                    'rtDesc' => 'Data not found.',
                );
            }
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }
    }


    public function FSaMSPLUpdateAddress($paData){
        try{
            // $code=$paData['FTAddName'];
            $tSql   = "UPDATE TCNMSplAddress_L 
                    SET FTAddName   = '".$paData['FTAddName']."',
                    FTAddRefNo      = '".$paData['FTAddRefNo']."',
                    FTAddGrpType    = '".$paData['FTAddGrpType']."',
                    FTAddTaxNo      = '".$paData['FTAddTaxNo']."',
                    FTAddV2Desc1    = '".$paData['FTAddV2Desc1']."',
                    FTAddV2Desc2    = '".$paData['FTAddV2Desc2']."',
                    FTAddWebsite    = '".$paData['FTAddWebsite']."',
                    FTAddRmk        = '".$paData['FTAddRmk']."',
                    FTAddLongitude  = '".$paData['FTAddLongitude']."',
                    FTAddLatitude   = '".$paData['FTAddLatitude']."',
                    -- จบฟอร์มสั้น
                    FTLastUpdBy     = '".$paData['FTLastUpdBy']."',
                    FDLastUpdOn     = '".$paData['FDLastUpdOn']."',

                    FTAddV1No       = '".$paData['FTAddV1No']."',
                    FTAddV1Soi      = '".$paData['FTAddV1Soi']."',
                    FTAddV1Village  = '".$paData['FTAddV1Village']."',
                    FTAddV1Road     = '".$paData['FTAddV1Road']."',
                    FTAddV1SubDist  = '".$paData['FTAddV1SubDist']."',
                    FTAddV1DstCode  = '".$paData['FTAddV1DstCode']."',
                    FTAddV1PvnCode  = '".$paData['FTAddV1PvnCode']."',
                    FTAddV1PostCode = '".$paData['FTAddV1PostCode']."',
                    FTAddCountry    = '".$paData['FTAddCountry']."'
                    WHERE FTSplCode =  '".$paData['FTSplCode']."' AND FNAddSeqNo =  '".$paData['ohdSeqNo']."' ";
            $oQuery = $this->db->query($tSql);
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Update Supplier Success.',
                );
            }else{
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Error Cannot Edit Supplier.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    public function FSaMSPLUpdateContact($paData){
        try{
            // $code=$paData['FTAddName'];
            $tSql   = "UPDATE TCNMSplContact_L 
                    SET FTCtrName   = '".$paData['FTCtrName']."',
                    FTCtrEmail      = '".$paData['FTCtrEmail']."',
                    FTCtrTel        = '".$paData['FTCtrTel']."',
                    FTCtrFax        = '".$paData['FTCtrFax']."',
                    FTCtrRmk        = '".$paData['FTCtrRmk']."',
                    FTLastUpdBy     = '".$paData['FTLastUpdBy']."',
                    FDLastUpdOn     = '".$paData['FDLastUpdOn']."'

                    WHERE FTSplCode =  '".$paData['FTSplCode']."' AND FNCtrSeq =  '".$paData['ohdSeqNo']."' ";
            $oQuery = $this->db->query($tSql);
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Update Supplier Success.',
                );
            }else{
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Error Cannot Edit Supplier.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    public function FSnMSPLAddressDel($paData){
        try{
            // $this->db->trans_begin();
            $nAddSeqNo = $paData['FNAddSeqNo'];
            // $this->db->where_in('FNAddSeqNo', $paData['FNAddSeqNo']);
            // $this->db->delete('TCNMSplAddress_L');
            $tSql ="DELETE FROM TCNMSplAddress_L WHERE FNAddSeqNo = '$nAddSeqNo'";
            $oQuery = $this->db->query($tSql);
            // echo $tSql; exit();
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Delete Success.',
                );
            }else{
                $this->db->trans_rollback();
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Delete Unsuccess.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    public function FSnMSPLContactDel($paData){
        try{
            // $this->db->trans_begin();
            $nAddSeqNo = $paData['FNCtrSeq'];
            // $this->db->where_in('FNAddSeqNo', $paData['FNAddSeqNo']);
            // $this->db->delete('TCNMSplAddress_L');
            $tSql ="DELETE FROM TCNMSplContact_L WHERE FNCtrSeq = '$nAddSeqNo'";
            $oQuery = $this->db->query($tSql);
            // echo $tSql; exit();
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Delete Success.',
                );
            }else{
                $this->db->trans_rollback();
                $aStatus = array(
                    'rtCode' => '905',
                    'rtDesc' => 'Delete Unsuccess.',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    function FSnMSPLGetAddressData($ptData){
    

        // $ci = &get_instance();
        // $ci->load->database();
        
        $nAddSeqNo  = $ptData['FNSeqNo'];
        $nLngID     = $ptData['FNLangID'];
        
    
        $tSQL ="SELECT  TOP 1 FTAddV1SubDist,
                        FTAddV1DstCode,
                        DSTL.FTDstName,
                        SUBDSTL.FTSudName,
                        SplAddL.FTAddV1PvnCode,
                        PVNL.FTPvnName
                FROM TCNMSplAddress_L SplAddL
                LEFT JOIN TCNMProvince_L PVNL ON SplAddL.FTAddV1PvnCode = PVNL.FTPvnCode AND PVNL.FNLngID = $nLngID
                LEFT JOIN TCNMDistrict_L DSTL ON SplAddL.FTAddV1DstCode = DSTL.FTDstCode AND DSTL.FNLngID = $nLngID
                LEFT JOIN TCNMSubDistrict_L SUBDSTL ON SplAddL.FTAddV1SubDist = SUBDSTL.FTSudCode AND SUBDSTL.FNLngID = $nLngID
                
                WHERE SplAddL.FNAddSeqNo = '$nAddSeqNo'
                -- AND SplAddL.FNLngID = '$nLngID'
                ";
                
    
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
        
            return $oQuery->result_array();
        
        } else {
            //No Data
            return false;
        }
    
    }

    //Functionality : list Data Supplier
    //Parameters : function parameters
    //Creator :  22/10/2018 Phisan ยกมาจาก BigC By IcePHP [21/10/2022]
    //Return : data
    //Return Type : Array
    public function FSaMSPLGetDataBranch($paData){
        try{
            $aRowLen        = FCNaHCallLenData($paData['nRow'],$paData['nPage']);
            $nLngID         = $paData['FNLngID'];
            $tSearchList    = $paData['tSearchAll'];
            $tSPLBranchSplCode       = $paData['tSPLBranchSplCode'];
            $tSPLBranchBchCode       = $paData['tSPLBranchBchCode'];

            $tSQLHeader     = " SELECT c.* FROM( SELECT  ROW_NUMBER() OVER(ORDER BY FTSplCode DESC , FTBchCode DESC) AS rtRowID,* FROM ( ";
            $tSQL           = "   SELECT
                                        SPLBCH.FTSplCode,
                                        SPL_L.FTSplName,
                                        SPLBCH.FTBchCode,
                                        BCH_L.FTBchName,
                                        SPLBCH.FCSbhLeadTime,
                                        SPLBCH.FTSbhOrdDay,
                                        SPLBCH.FTSbhStaAlwOrdSun,
                                        SPLBCH.FTSbhStaAlwOrdMon,
                                        SPLBCH.FTSbhStaAlwOrdTue,
                                        SPLBCH.FTSbhStaAlwOrdWed,
                                        SPLBCH.FTSbhStaAlwOrdThu,
                                        SPLBCH.FTSbhStaAlwOrdFri,
                                        SPLBCH.FTSbhStaAlwOrdSat,
                                        SPLBCH.FTSbhStaDefault
                                    FROM
                                        TCNMSplBch SPLBCH WITH(NOLOCK)
                                    LEFT JOIN TCNMBranch_L BCH_L  WITH(NOLOCK) ON SPLBCH.FTBchCode = BCH_L.FTBchCode AND BCH_L.FNLngID = $nLngID
                                    LEFT JOIN TCNMSpl_L SPL_L WITH(NOLOCK )  ON SPLBCH.FTSplCode = SPL_L.FTSplCode AND SPL_L.FNLngID = $nLngID

                                    WHERE ISNULL(SPLBCH.FTSplCode,'')!= '' ";
            if(isset($tSearchList) && !empty($tSearchList)){
                $tSQL .= " AND (SPLBCH.FTSplCode  COLLATE THAI_BIN LIKE '%$tSearchList%'";
                $tSQL .= " OR SPL_L.FTSplName  COLLATE THAI_BIN LIKE '%$tSearchList%'";
                $tSQL .= " OR SPLBCH.FTBchCode     COLLATE THAI_BIN LIKE '%$tSearchList%'";
                $tSQL .= " OR BCH_L.FTBchName   COLLATE THAI_BIN LIKE '%$tSearchList%')";
            }

            if($tSPLBranchBchCode != ""){
                $tSQL .= " AND ( SPLBCH.FTBchCode = '$tSPLBranchBchCode'  ) ";
            }

            if($tSPLBranchSplCode != ""){
                $tSQL .= " AND ( SPLBCH.FTSplCode = '$tSPLBranchSplCode'  ) ";
            }

            $tSQLFooter = " ) Base) AS c WHERE c.rtRowID > $aRowLen[0] AND c.rtRowID <= $aRowLen[1] ";

            $tSQLMain = $tSQLHeader.$tSQL.$tSQLFooter;
            $tSQLSub  = $tSQL;

            $oQuery = $this->db->query($tSQLMain);
            if( $oQuery->num_rows() > 0 ){
                $oQuerySub  = $this->db->query($tSQLSub);
                $aList      = $oQuery->result_array();
                $nFoundRow  = $oQuerySub->num_rows();
                // $oFoundRow = $this->FSoMSPLGetPageAll($tSearchList,$nLngID);
                // $nFoundRow = $oFoundRow[0]->counts;
                $nPageAll   = ceil($nFoundRow/$paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า
                $aResult    = array(
                    'raItems'       => $aList,
                    'rnAllRow'      => $nFoundRow,
                    'rnCurrentPage' => $paData['nPage'],
                    'rnAllPage'     => $nPageAll,
                    'rtCode'        => '1',
                    'rtDesc'        => 'success',
                );
            }else{
                //No Data
                $aResult = array(
                    'rnAllRow'      => 0,
                    'rnCurrentPage' => $paData['nPage'],
                    "rnAllPage"     => 0,
                    'rtCode'        => '800',
                    'rtDesc'        => 'data not found',
                );
            }
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Function Add/Update Master
    //Parameters : function parameters
    //Creator : 10/05/2018 wasin ยกมาจาก BigC By IcePHP [21/10/2022]
    //Last Modified : 11/06/2018 wasin
    //Return : Status Add/Update Master
    //Return Type : array
    public function FSaMSPLAddUpdateBranch($paData){
        try{
            //Update Master
            $this->db->set('FCSbhLeadTime' , $paData['FCSbhLeadTime']);
            $this->db->set('FTSbhOrdDay' , $paData['FTSbhOrdDay']);
            $this->db->set('FTSbhStaAlwOrdSun' , $paData['FTSbhStaAlwOrdSun']);
            $this->db->set('FTSbhStaAlwOrdMon', $paData['FTSbhStaAlwOrdMon']);
            $this->db->set('FTSbhStaAlwOrdTue', $paData['FTSbhStaAlwOrdTue']);
            $this->db->set('FTSbhStaAlwOrdWed', $paData['FTSbhStaAlwOrdWed']);
            $this->db->set('FTSbhStaAlwOrdThu', $paData['FTSbhStaAlwOrdThu']);
            $this->db->set('FTSbhStaAlwOrdFri', $paData['FTSbhStaAlwOrdFri']);
            $this->db->set('FTSbhStaAlwOrdSat', $paData['FTSbhStaAlwOrdSat']);
            $this->db->set('FTSbhStaDefault', $paData['FTSbhStaDefault']);
            $this->db->where('FTSplCode', $paData['FTSplCode']);
            $this->db->where('FTBchCode', $paData['FTBchCode']);
            $this->db->update('TCNMSplBch');
            if($this->db->affected_rows() > 0){
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Update Master Success',
                );
            }else{
                //Add Master
                $this->db->insert('TCNMSplBch',array(
                    'FTSplCode'     => $paData['FTSplCode'],
                    'FTBchCode'     => $paData['FTBchCode'],

                    'FCSbhLeadTime'   => $paData['FCSbhLeadTime'],
                    'FTSbhOrdDay'     => $paData['FTSbhOrdDay'],

                    'FTSbhStaAlwOrdSun'     => $paData['FTSbhStaAlwOrdSun'],
                    'FTSbhStaAlwOrdMon'     => $paData['FTSbhStaAlwOrdMon'],
                    'FTSbhStaAlwOrdTue'     => $paData['FTSbhStaAlwOrdTue'],
                    'FTSbhStaAlwOrdWed'     => $paData['FTSbhStaAlwOrdWed'],
                    'FTSbhStaAlwOrdThu'     => $paData['FTSbhStaAlwOrdThu'],
                    'FTSbhStaAlwOrdFri'     => $paData['FTSbhStaAlwOrdFri'],
                    'FTSbhStaDefault'       => $paData['FTSbhStaDefault'],
              
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


    //Functionality : Checkduplicate Suppliers
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan ยกมาจาก BigC By IcePHP [21/10/2022]
    //Return : data
    //Return Type : Array
    public function  FSoMSPLBranchCheckDuplicate($paData){
        try{
    
            $tSqlCode = $paData['FTSplCode'];
            $tBchCode = $paData['FTBchCode'];
            $tSQL = "SELECT COUNT(SBH.FTSplCode) AS counts
                 FROM TCNMSplBch SBH 
                 WHERE SBH.FTSplCode = '$tSqlCode' AND SBH.FTBchCode = '$tBchCode' ";
            $oQuery = $this->db->query($tSQL);
            if($oQuery->num_rows() > 0){
                return $oQuery->row_array();
            }else{
                return FALSE;
            }
        }catch(Exception $Error){
            echo $Error;
        }
    }



    //Functionality : Checkduplicate Suppliers
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan ยกมาจาก BigC By IcePHP [21/10/2022]
    //Return : data
    //Return Type : Array
    public function  FSoMSPLBranchCodeCheckStaDefault($paData){
        try{
    
            $tBchCode = $paData['FTBchCode'];
            $tSQL = "SELECT COUNT(SBH.FTSplCode) AS counts
                 FROM TCNMSplBch SBH 
                 WHERE  SBH.FTBchCode = '$tBchCode' ";
            $oQuery = $this->db->query($tSQL);
            if($oQuery->num_rows() > 0){
                return $oQuery->row_array();
            }else{
                return 0;
            }
        }catch(Exception $Error){
            echo $Error;
        }
    }


    //Functionality : Get Data Supplier By ID
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan ยกมาจาก BigC By IcePHP [21/10/2022]
    //Return : data
    //Return Type : Array
    public function FSaMSPLGetBranchDataByID($paData){
        try{
            $tSplCode   = $paData['FTSplCode'];
            $tBchCode   = $paData['FTBchCode'];
            $nLngID     = $paData['nLangEdit'];
            $tSQL           = "   SELECT
                                    SPLBCH.FTSplCode,
                                    SPL_L.FTSplName,
                                    SPLBCH.FTBchCode,
                                    BCH_L.FTBchName,
                                    SPLBCH.FCSbhLeadTime,
                                    SPLBCH.FTSbhOrdDay,
                                    SPLBCH.FTSbhStaAlwOrdSun,
                                    SPLBCH.FTSbhStaAlwOrdMon,
                                    SPLBCH.FTSbhStaAlwOrdTue,
                                    SPLBCH.FTSbhStaAlwOrdWed,
                                    SPLBCH.FTSbhStaAlwOrdThu,
                                    SPLBCH.FTSbhStaAlwOrdFri,
                                    SPLBCH.FTSbhStaAlwOrdSat,
                                    SPLBCH.FTSbhStaDefault
                                FROM
                                    TCNMSplBch SPLBCH WITH(NOLOCK)
                                LEFT JOIN TCNMBranch_L BCH_L  WITH(NOLOCK) ON SPLBCH.FTBchCode = BCH_L.FTBchCode AND BCH_L.FNLngID = $nLngID
                                LEFT JOIN TCNMSpl_L SPL_L WITH(NOLOCK )  ON SPLBCH.FTSplCode = SPL_L.FTSplCode AND SPL_L.FNLngID = $nLngID
                                WHERE ISNULL(SPLBCH.FTSplCode,'')= '$tSplCode' AND ISNULL(SPLBCH.FTBchCode,'')= '$tBchCode' ";

            $oQuery = $this->db->query($tSQL);
            if ($oQuery->num_rows() > 0){
                $aDetail = $oQuery->row_array();
                $aResult = array(
                    'raItems'   => $aDetail,
                    'rtCode'    => '1',
                    'rtDesc'    => 'success',
                );
            }else{
                $aResult = array(
                    'rtCode' => '800',
                    'rtDesc' => 'Data not found.',
                );
            }
            return $aResult;
        }catch(Exception $Error){
            echo $Error;
        }
    }


    
    //Functionality : Delete Supplier
    //Parameters : function parameters
    //Creator : 22/10/2018 Phisan ยกมาจาก BigC By IcePHP [21/10/2022]
    //Return : Status Delete
    //Return Type : array
    public function FSnMSPLBranchDel($paData){
        try{
            $this->db->trans_begin();
            $this->db->where_in('FTSplCode', $paData['FTSplCode']);
            $this->db->where_in('FTBchCode', $paData['FTBchCode']);
            $this->db->delete('TCNMSplBch');

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