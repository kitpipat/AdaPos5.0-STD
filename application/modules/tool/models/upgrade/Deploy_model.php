<?php 
defined('BASEPATH') or exit('No direct script access allowed');

class Deploy_model extends CI_Model {

    //Functionality : list Branch
    //Parameters : function parameters
    //Creator : 09/02/2022 Nattakit
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSaMDPYDataTable($paDataCondition) {
        $aDataUserInfo      = $this->session->userdata("tSesUsrInfo");
        $aRowLen            = FCNaHCallLenData($paDataCondition['nRow'], $paDataCondition['nPage']);
        $nLngID             = $paDataCondition['FNLngID'];
        $aAdvanceSearch     = $paDataCondition['aAdvanceSearch'];
        @$tSearchList        = $aAdvanceSearch['tSearchAll'];

        // Advance Search

        $tSearchDocDateFrom = $aAdvanceSearch['tSearchDocDateFrom'];
        $tSearchDocDateTo   = $aAdvanceSearch['tSearchDocDateTo'];
        $tSearchStaPreDep      = $aAdvanceSearch['tSearchStaPreDep'];
        // $tSearchStaApprove  = $aAdvanceSearch['tSearchStaApprove'];
        $tSearchStaDep   = $aAdvanceSearch['tSearchStaDep'];

        $tUsrBchCode        = $this->session->userdata("tSesUsrBchCodeMulti");

        /** ค้นหารหัสเอกสาร,ชือสาขา,วันที่เอกสาร */
        $tWhereSearchAll    = "";
        if (@$tSearchList != '') {
            $tWhereSearchAll = " AND ((HD.FTXdhDocNo LIKE '%$tSearchList%') OR (HD_L.FTXdhDepName LIKE '%$tSearchList%') OR (CONVERT(CHAR(10),HD.FDXdhDocDate,103) LIKE '%$tSearchList%'))";
        }


        /** ค้นหาจากวันที่ - ถึงวันที่ */
        $tSearchDocDateFrom = $aAdvanceSearch['tSearchDocDateFrom'];
        $tSearchDocDateTo   = $aAdvanceSearch['tSearchDocDateTo'];
        $tWhereDateFrmTo    = "";
        if (!empty($tSearchDocDateFrom) && !empty($tSearchDocDateTo)) {
            $tWhereDateFrmTo = " AND ((HD.FDXdhDocDate BETWEEN CONVERT(datetime,'$tSearchDocDateFrom 00:00:00') AND CONVERT(datetime,'$tSearchDocDateTo 23:59:59')) OR (HD.FDXdhDocDate BETWEEN CONVERT(datetime,'$tSearchDocDateTo 23:00:00') AND CONVERT(datetime,'$tSearchDocDateFrom 00:00:00')))";
        }



        $tSearchStaPreDep = $aAdvanceSearch['tSearchStaPreDep'];
        $tWhereStaDoc   = "";
        if (!empty($tSearchStaPreDep) && ($tSearchStaPreDep != "0")) {
                $tWhereStaDoc .= " AND HD.FTXdhStaPreDep = '$tSearchStaPreDep'";
        }

        $tSearchStaDep = $aAdvanceSearch['tSearchStaDep'];

        if (!empty($tSearchStaDep) && ($tSearchStaDep != "0")) {
                $tWhereStaDoc .= " AND HD.FTXdhStaDep = '$tSearchStaDep'";
        }


 

        $tSQL   = " SELECT c.* 
                            FROM( SELECT ROW_NUMBER() OVER(ORDER BY FDCreateOn DESC, FTXdhDocNo DESC) AS FNRowID,* 
                                FROM (         
                                    SELECT
                                        HD.FTXdhDocNo,
                                        HD_L.FTXdhDepName,
                                        CONVERT (CHAR (10),	HD.FDXdhDocDate,	103) AS FDXdhDocDate,
                                        HD.FTXdhStaDoc,
                                        HD.FTXdhStaDep,
                                        HD.FTXdhStaPreDep,
                                        HD.FTXdhUsrApv,
                                        USRAPV.FTUsrName AS USRAPVName,
                                        HD.FTXdhUsrApvPreDep,
                                        USRPRE.FTUsrName AS USRPREName,
                                        HD.FDLastUpdOn,
                                        HD.FTLastUpdBy,
                                        HD.FDCreateOn,
                                        HD.FTCreateBy,
                                        USRCRD.FTUsrName AS USRCRDName
                                    FROM
                                        TCNTAppDepHD HD WITH(NOLOCK)
                                    LEFT OUTER JOIN TCNTAppDepHD_L HD_L WITH(NOLOCK) ON HD.FTXdhDocNo = HD_L.FTXdhDocNo AND HD_L.FNLngID = $nLngID
                                    LEFT OUTER JOIN TCNMUser_L USRAPV  WITH(NOLOCK) ON HD.FTXdhUsrApv = USRAPV.FTUsrCode AND USRAPV.FNLngID = $nLngID 
                                    LEFT OUTER JOIN TCNMUser_L USRPRE  WITH(NOLOCK) ON HD.FTXdhUsrApvPreDep = USRPRE.FTUsrCode AND USRPRE.FNLngID = $nLngID 
                                    LEFT OUTER JOIN TCNMUser_L USRCRD  WITH(NOLOCK) ON HD.FTCreateBy = USRCRD.FTUsrCode AND USRCRD.FNLngID = $nLngID 
                                    WHERE HD.FTXdhDocNo IS NOT NULL
                                    $tWhereSearchAll
                                    $tWhereDateFrmTo
                                    $tWhereStaDoc
                            ) Base) AS c WHERE c.FNRowID > $aRowLen[0] AND c.FNRowID <= $aRowLen[1]
        ";

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $aDataList  = $oQuery->result_array();
            $aFoundRow  = $this->JSnMDPYGetPageAll($paDataCondition);
            $nFoundRow  = ($aFoundRow['rtCode'] == '1') ? $aFoundRow['rtCountData'] : 0;
            $nPageAll   = ceil($nFoundRow / $paDataCondition['nRow']);
            $aResult = array(
                'raItems'       => $aDataList,
                'rnAllRow'      => $nFoundRow,
                'rnCurrentPage' => $paDataCondition['nPage'],
                'rnAllPage'     => $nPageAll,
                'rtCode'        => '1',
                'rtDesc'        => 'success',
            );
        } else {
            $aResult = array(
                'rnAllRow'      => 0,
                'rnCurrentPage' => $paDataCondition['nPage'],
                "rnAllPage"     => 0,
                'rtCode'        => '800',
                'rtDesc'        => 'data not found',
            );
        }
        unset($oQuery);
        unset($oDataList);
        unset($aFoundRow);
        unset($nFoundRow);
        unset($nPageAll);
        return $aResult;
    }

    //Functionality : All Page Of Branch
    //Parameters : function parameters
    //Creator : 09/02/2022 Nattakit
    //Last Modified : -
    //Return : data
    //Return Type : Array
    function JSnMDPYGetPageAll($paDataCondition) {
        $aDataUserInfo      = $this->session->userdata("tSesUsrInfo");

        $nLngID             = $paDataCondition['FNLngID'];
        $aAdvanceSearch     = $paDataCondition['aAdvanceSearch'];
        @$tSearchList        = $aAdvanceSearch['tSearchAll'];

        // Advance Search

        $tSearchDocDateFrom = $aAdvanceSearch['tSearchDocDateFrom'];
        $tSearchDocDateTo   = $aAdvanceSearch['tSearchDocDateTo'];
        $tSearchStaPreDep      = $aAdvanceSearch['tSearchStaPreDep'];
        $tSearchStaDep   = $aAdvanceSearch['tSearchStaDep'];

        $tUsrBchCode        = $this->session->userdata("tSesUsrBchCodeMulti");

        /** ค้นหารหัสเอกสาร,ชือสาขา,วันที่เอกสาร */
        $tWhereSearchAll    = "";
        if (@$tSearchList != '') {
            $tWhereSearchAll = " AND ((HD.FTXdhDocNo LIKE '%$tSearchList%') OR (HD_L.FTXdhDepName LIKE '%$tSearchList%') OR (CONVERT(CHAR(10),HD.FDXdhDocDate,103) LIKE '%$tSearchList%'))";
        }

  
        /** ค้นหาจากวันที่ - ถึงวันที่ */
        $tSearchDocDateFrom = $aAdvanceSearch['tSearchDocDateFrom'];
        $tSearchDocDateTo   = $aAdvanceSearch['tSearchDocDateTo'];
        $tWhereDateFrmTo    = "";
        if (!empty($tSearchDocDateFrom) && !empty($tSearchDocDateTo)) {
            $tWhereDateFrmTo = " AND ((HD.FDXdhDocDate BETWEEN CONVERT(datetime,'$tSearchDocDateFrom 00:00:00') AND CONVERT(datetime,'$tSearchDocDateTo 23:59:59')) OR (HD.FDXdhDocDate BETWEEN CONVERT(datetime,'$tSearchDocDateTo 23:00:00') AND CONVERT(datetime,'$tSearchDocDateFrom 00:00:00')))";
        }


        $tSearchStaPreDep = $aAdvanceSearch['tSearchStaPreDep'];
        $tWhereStaDoc   = "";
        if (!empty($tSearchStaPreDep) && ($tSearchStaPreDep != "0")) {
                $tWhereStaDoc .= " AND HD.FTXdhStaPreDep = '$tSearchStaPreDep'";
        }

        $tSearchStaDep = $aAdvanceSearch['tSearchStaDep'];
        if (!empty($tSearchStaDep) && ($tSearchStaDep != "0")) {
                $tWhereStaDoc .= " AND HD.FTXdhStaDep = '$tSearchStaDep'";
        }

        $tSQL   = " SELECT
                        COUNT (HD.FTXdhDocNo) AS counts
                        FROM
                            TCNTAppDepHD HD WITH(NOLOCK)
                        LEFT OUTER JOIN TCNTAppDepHD_L HD_L WITH(NOLOCK) ON HD.FTXdhDocNo = HD_L.FTXdhDocNo AND HD_L.FNLngID = $nLngID
                    WHERE HD.FTXdhDocNo IS NOT NULL
                    $tWhereSearchAll
                    $tWhereDateFrmTo
                    $tWhereStaDoc
                  ";

        $oQuery = $this->db->query($tSQL);

        if ($oQuery->num_rows() > 0) {
            $aDetail        = $oQuery->row_array();
            $aDataReturn    =  array(
                'rtCountData'   => $aDetail['counts'],
                'rtCode'        => '1',
                'rtDesc'        => 'success',
            );
        } else {
            $aDataReturn    =  array(
                'rtCode'        => '800',
                'rtDesc'        => 'Data Not Found',
            );
        }

        unset($oQuery);
        unset($aDetail);
        return $aDataReturn;
    }


 
    
	//Functionality : Add Warehouse
	//Parameters : function parameters
	//Creator : 15/05/2018 Krit(Copter)
	//Last Modified : -
	//Return : response
	//Return Type : Array
	public function FSaMDPYAdd($paData)
	{
		$tStaDup = $this->FSnMDPYCheckduplicate($paData['FTXdhDocNo']); //ส่งค่าไปหา duplicate
		$nStaDup = $tStaDup[0]->counts;

		if ($nStaDup == 0) {
            
			$this->db->insert('TCNTAppDepHD', array(
				'FTXdhDocNo' 			=> $paData['FTXdhDocNo'],
				'FDXdhDocDate' 			=> $paData['FDXdhDocDate'],
                'FDXdhActDate' 			=> $paData['FDXdhActDate'],
				'FTXdhStaDoc' 			=> $paData['FTXdhStaDoc'],
				'FTXdhStaDep' 			=> $paData['FTXdhStaDep'],
				'FTXdhStaPreDep' 		=> $paData['FTXdhStaPreDep'],
				'FTXdhUsrApv' 		=> $paData['FTXdhUsrApv'],
				'FTXdhUsrApvPreDep'		=> $paData['FTXdhUsrApvPreDep'],
                'FTXdhZipUrl'           => $paData['FTXdhZipUrl'],
                'FTXdhJsonUrl'           => $paData['FTXdhJsonUrl'],
                'FTXdhStaForce'           => $paData['FTXdhStaForce'],
				'FDCreateOn'			=> $paData['FDCreateOn'],
				'FTCreateBy' 			=> $paData['FTCreateBy'],
				'FDLastUpdOn'			=> $paData['FDLastUpdOn'],
				'FTLastUpdBy'			=> $paData['FTLastUpdBy'],
			));

			if ($this->db->affected_rows() > 0) {
				$nID = $this->db->insert_id();

				$StaAddLang = $this->FSnMDPYAddLang($paData); // Add Language

				if ($StaAddLang != '1') {
					//Ploblem
					$aStatus = array(
						'rtCode' => '905',
						'rtDesc' => 'cannot insert database.',
					);
					$jStatus = json_encode($aStatus);
					$aStatus = json_decode($jStatus, true);
				} else {
					//Success
					$aStatus = array(
						'rtCode' => '1',
						'rtDesc' => 'success',
					);
					$jStatus = json_encode($aStatus);
					$aStatus = json_decode($jStatus, true);
				}
			} else {
				$aStatus = array(
					'rtCode' => '905',
					'rtDesc' => 'cannot insert database.',
				);
			}
		} else {
			//Duplicate
			$aStatus = array(
				'rtCode' => '801',
				'rtDesc' => 'data is duplicate.',
			);
			$jStatus = json_encode($aStatus);
			$aStatus = json_decode($jStatus, true);
		}

		return $aStatus;
	}

	//Functionality : Add Lang Branch
	//Parameters : function parameters
	//Creator : 09/02/2022 Nattakit
	//Last Modified : -
	//Return : response
	//Return Type : num
	public function FSnMDPYAddLang($paData)
	{
		$this->db->insert('TCNTAppDepHD_L', array(
			'FTXdhDocNo'	=> $paData['FTXdhDocNo'],
			'FNLngID'	=> $paData['FNLngID'],
			'FTXdhDepName'	=> $paData['FTXdhDepName'],
			'FTXdhDepRmk'	=> $paData['FTXdhDepRmk'],
		));

		if ($this->db->affected_rows() > 0) {
			return 1;
		} else {
			return 0;
		}
	}

	//Functionality : Checkduplicate
	//Parameters : function parameters
	//Creator : 09/02/2022 Nattakit
	//Last Modified : -
	//Return : data
	//Return Type : Array
	public function FSnMDPYCheckduplicate($ptCode)
	{
		$tSQL = "SELECT COUNT(FTXdhDocNo)AS counts
		FROM TCNTAppDepHD
		WHERE FTXdhDocNo = '$ptCode' 
		";

		$oQuery = $this->db->query($tSQL);
		if ($oQuery->num_rows() > 0) {
			return $oQuery->result();
		} else {
			return false;
		}
	}

	
	//Functionality : Update Branch
	//Parameters : function parameters
	//Creator : 09/02/2022 Nattakit
	//Last Modified : -
	//Return : response
	//Return Type : Array
	public function FSaMDPYUpdate($paData)
	{
        
			$this->db->where('FTXdhDocNo', $paData['FTXdhDocNo']);
			$this->db->update('TCNTAppDepHD', array(
				'FDXdhDocDate' 			=> $paData['FDXdhDocDate'],
                'FDXdhActDate' 			=> $paData['FDXdhActDate'],
                'FTXdhZipUrl'           => $paData['FTXdhZipUrl'],
                'FTXdhJsonUrl'          => $paData['FTXdhJsonUrl'],
                'FTXdhStaForce'          => $paData['FTXdhStaForce'],
				'FDLastUpdOn'			=> $paData['FDLastUpdOn'],
				'FTLastUpdBy'			=> $paData['FTLastUpdBy'],
			));

			if ($this->db->affected_rows() > 0) {

                $StaAddLang = $this->FSnMDPYUpdateLang($paData);
                if ($StaAddLang != 1) {
                    $aStatus = array(
                        'rtCode' => '905',
                        'rtDesc' => 'cannot update database.',
                    );
                } else {
                    $aStatus = array(
                        'rtCode' => '1',
                        'rtDesc' => 'success',
                    );
                }
		
			} else {
				//Ploblem
				$aStatus = array(
					'rtCode' => '905',
					'rtDesc' => 'cannot update database.',
				);
			}

		$jStatus = json_encode($aStatus);
		$aStatus = json_decode($jStatus, true);
		return $aStatus;
	}

	//Functionality : Update Lang Branch
	//Parameters : function parameters
	//Creator : 09/02/2022 Nattakit
	//Last Modified : -
	//Return : response
	//Return Type : num
	public function FSnMDPYUpdateLang($paData)
	{

		$this->db->set('FTXdhDepName', $paData['FTXdhDepName']);
		$this->db->set('FTXdhDepRmk', $paData['FTXdhDepRmk']);
		$this->db->where('FTXdhDocNo', $paData['FTXdhDocNo']);
        $this->db->where('FNLngID', $paData['FNLngID']);
		$this->db->update('TCNTAppDepHD_L');

		if ($this->db->affected_rows() > 0) {
			return 1;
		} else {

            $this->db->insert('TCNTAppDepHD_L', array(
                'FTXdhDocNo'	=> $paData['FTXdhDocNo'],
                'FNLngID'	    => $paData['FNLngID'],
                'FTXdhDepName'	=> $paData['FTXdhDepName'],
                'FTXdhDepRmk'	=> $paData['FTXdhDepRmk'],
            ));
    

			return 0;
		}
	}


    //Functionality : Function Insert TFNTCouponHDBch
    //Parameters : function parameters
    //Creator : 09/02/2022 Nale
    //Last Modified : -
    //Return : Status Add
    //Return Type : array
    public function FSaMRDPYAddUpdateConditionBch($paDataBch,$apDataHD){
        try{

            $tSQLDelete = "DELETE FROM TCNTAppDepHDBch WHERE  TCNTAppDepHDBch.FTXdhDocNo = '".$apDataHD['FTXdhDocNo']."' ";
            $oQuery = $this->db->query($tSQLDelete);

            if(isset($paDataBch['aRddBchModalType']) && !empty($paDataBch['aRddBchModalType'])){
                // Loop Add/Update 
                foreach($paDataBch['aRddBchModalType'] AS $nKey => $aValue){
                    $tAgnCode    = $paDataBch['aDPYAgnCode'][$nKey];
                    $tBchCode    = $paDataBch['aDPYBchCode'][$nKey];
                    $tPosCode    = $paDataBch['aDPYPosCode'][$nKey];
                    $tDPYStaType = $aValue;
                    $tSQLInsert = "";
                    $tSQLInsert = " INSERT INTO TCNTAppDepHDBch ( ID,FTXdhDocNo,FTXdhAgnTo,FTXdhBchTo,FTXdhMerTo,FTXdhShpTo,FTXdhPosTo,FTXdhStaType ) VALUES (
                                        '',
                                        '".$apDataHD['FTXdhDocNo']."',
                                        '".$tAgnCode."',
                                        '".$tBchCode."',
                                        '',
                                        '',
                                        '".$tPosCode."',
                                        '$tDPYStaType'
                                    )";
                    $oQuery = $this->db->query($tSQLInsert);
                }
            }
            $aReturn = array(
                'nStaEvent'    => '001',
                'tStaMessg'    => 'success'
            );
        }catch(Exception $Error){
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => $Error->getMessage()
            );
        }
      return $aReturn;
    }

    //Functionality : Function Insert TFNTCouponHDBch
    //Parameters : function parameters
    //Creator : 09/02/2022 Nale
    //Last Modified : -
    //Return : Status Add
    //Return Type : array
    public function FSaMRDPYAddUpdateDT($paDataBch,$apDataHD){
        try{

            $tSQLDelete = "DELETE FROM TCNTAppDepDT WHERE  TCNTAppDepDT.FTXdhDocNo = '".$apDataHD['FTXdhDocNo']."' ";
            $oQuery = $this->db->query($tSQLDelete);

            if(isset($paDataBch['aDPTAppCode']) && !empty($paDataBch['aDPTAppCode'])){
                // Loop Add/Update 
                    $nXddSeq = 1;
                foreach($paDataBch['aDPTAppCode'] AS $nKey => $aValue){
                    $tDPTAppCode    = $aValue;
                    $tDPTAppVersion = $paDataBch['aDPTAppVersion'][$nKey];
                    $tDPTAppPath       = $paDataBch['aDPTAppPath'][$nKey];
                  
                    $tSQLInsert = "";
                    $tSQLInsert = " INSERT INTO TCNTAppDepDT ( FTXdhDocNo,FNXddSeq,FTAppName,FTAppVersion,FTXdhAppPath ) VALUES (
                                        '".$apDataHD['FTXdhDocNo']."',
                                        '".$nXddSeq."',
                                        '".$tDPTAppCode."',
                                        '".$tDPTAppVersion."',
                                        '".$tDPTAppPath."'
                                    )";
                    $oQuery = $this->db->query($tSQLInsert);
                    $nXddSeq++;
                }
            }
            $aReturn = array(
                'nStaEvent'    => '001',
                'tStaMessg'    => 'success'
            );
        }catch(Exception $Error){
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => $Error->getMessage()
            );
        }
      return $aReturn;
    }


    //Functionality : Search AdjStkSub By ID
    //Parameters : function parameters
    //Creator : 27/06/2019 Witsarut(Bell)
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSaMDPYGetHD($ptXthDocNo)
    {

        $tXthDocNo  = $ptXthDocNo;
        $nLngID     = $this->session->userdata("tLangEdit");

        $tSQL = " SELECT
                    HD.FTXdhDocNo,
                    HD_L.FTXdhDepName,
                    HD_L.FTXdhDepRmk,
                    HD.FDXdhDocDate,
                    HD.FDXdhActDate,
                    HD.FTXdhStaDoc,
                    HD.FTXdhStaDep,
                    HD.FTXdhStaPreDep,
                    HD.FTXdhUsrApv,
                    USRAPV.FTUsrName AS FTXdhUsrApvName,
                    HD.FTXdhUsrApvPreDep,
                    USRPRE.FTUsrName AS FTXdhUsrPreApvName,
                    HD.FDLastUpdOn,
                    HD.FTLastUpdBy,
                    HD.FDCreateOn,
                    HD.FTCreateBy,
                    USRCRD.FTUsrName AS FTCreateByName ,
                    HD.FTXdhZipUrl,
                    HD.FTXdhJsonUrl,
                    HD.FTXdhStaForce
                FROM
                    TCNTAppDepHD HD WITH(NOLOCK)
                LEFT OUTER JOIN TCNTAppDepHD_L HD_L WITH(NOLOCK) ON HD.FTXdhDocNo = HD_L.FTXdhDocNo AND HD_L.FNLngID = $nLngID 
                LEFT OUTER JOIN TCNMUser_L USRAPV  WITH(NOLOCK) ON HD.FTXdhUsrApv = USRAPV.FTUsrCode AND USRAPV.FNLngID = $nLngID 
                LEFT OUTER JOIN TCNMUser_L USRCRD  WITH(NOLOCK) ON HD.FTCreateBy = USRCRD.FTUsrCode AND USRCRD.FNLngID = $nLngID 
                LEFT OUTER JOIN TCNMUser_L USRPRE  WITH(NOLOCK) ON HD.FTXdhUsrApvPreDep = USRPRE.FTUsrCode AND USRPRE.FNLngID = $nLngID 
                WHERE HD.FTXdhDocNo = '$tXthDocNo'";
     

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $oDetail = $oQuery->result();

            $aResult = array(
                'raItems'   => $oDetail[0],
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        } else {
            // Not Found
            $aResult = array(
                'rtCode' => '800',
                'rtDesc' => 'data not found.',
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //Functionality : Search AdjStkSub By ID
    //Parameters : function parameters
    //Creator : 27/06/2019 Witsarut(Bell)
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSaMDPYGetDT($ptXthDocNo)
    {
        $tXthDocNo  = $ptXthDocNo;
        $nLngID     = $this->session->userdata("tLangEdit");

        $tSQL = " SELECT
                        DT.FTXdhDocNo,
                        DT.FNXddSeq,
                        DT.FTAppName AS FTAppCode,
                        DT.FTAppVersion,
                        DT.FTXdhAppPath
                    FROM
                        TCNTAppDepDT DT WITH (NOLOCK)
                    WHERE DT.FTXdhDocNo = '$tXthDocNo'
                    Order BY DT.FNXddSeq ASC
                    ";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $oDetail = $oQuery->result();

            $aResult = array(
                'raItems'   => $oDetail,
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        } else {
            // Not Found
            $aResult = array(
                'rtCode' => '800',
                'rtDesc' => 'data not found.',
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //Functionality : Search AdjStkSub By ID
    //Parameters : function parameters
    //Creator : 27/06/2019 Witsarut(Bell)
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSaMDPYGetHDBch($ptXthDocNo)
    {
        $tXthDocNo  = $ptXthDocNo;
        $nLngID     = $this->session->userdata("tLangEdit");

        $tSQL = "SELECT
                        HDBCH.FTXdhDocNo,
                        HDBCH.ID,
                        HDBCH.FTXdhAgnTo,
                        AGNL.FTAgnName,
                        HDBCH.FTXdhBchTo,
                        BCHL.FTBchName,
                        HDBCH.FTXdhMerTo,
                        HDBCH.FTXdhShpTo,
                        HDBCH.FTXdhPosTo,
                        POSL.FTPosName,
                        HDBCH.FTXdhStaType
                    FROM
                        TCNTAppDepHDBch HDBCH WITH (NOLOCK)
                    LEFT OUTER JOIN TCNMAgency_L AGNL WITH (NOLOCK) ON HDBCH.FTXdhAgnTo = AGNL.FTAgnCode AND AGNL.FNLngID = $nLngID
                    LEFT OUTER JOIN TCNMBranch_L BCHL WITH (NOLOCK) ON HDBCH.FTXdhBchTo = BCHL.FTBchCode AND BCHL.FNLngID = $nLngID
                    LEFT OUTER JOIN TCNMPos_L POSL WITH (NOLOCK) ON HDBCH.FTXdhPosTo = POSL.FTPosCode AND HDBCH.FTXdhBchTo = POSL.FTBchCode AND POSL.FNLngID = $nLngID
                    WHERE HDBCH.FTXdhDocNo = '$tXthDocNo'
                    ";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $oDetail = $oQuery->result();

            $aResult = array(
                'raItems'   => $oDetail,
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        } else {
            // Not Found
            $aResult = array(
                'rtCode' => '800',
                'rtDesc' => 'data not found.',
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    //Functionality : Search AdjStkSub By ID
    //Parameters : function parameters
    //Creator : 27/06/2019 Witsarut(Bell)
    //Last Modified : -
    //Return : data
    //Return Type : Array
    public function FSaMDPYGetOjbFle($ptXthDocNo)
    {
        $tXthDocNo  = $ptXthDocNo;
        $nLngID     = $this->session->userdata("tLangEdit");

        $tSQL = "SELECT
                    OJB.FNFleID,
                    OJB.FTFleRefTable,
                    OJB.FTFleRefID1,
                    OJB.FTFleRefID2,
                    OJB.FNFleSeq,
                    OJB.FTFleType,
                    OJB.FTFleObj,
                    OJB.FTFleName,
                    OJB.FDLastUpdOn,
                    OJB.FTLastUpdBy,
                    OJB.FDCreateOn,
                    OJB.FTCreateBy
                FROM
                    TCNMFleObj OJB WITH (NOLOCK)
                WHERE
                    OJB.FTFleRefTable = 'TCNTAppDepHD'
                AND OJB.FTFleRefID1 = '$tXthDocNo'
                AND OJB.FTFleRefID2 = 'tool_deploy'
                    ";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $oDetail = $oQuery->result();

            $aResult = array(
                'raItems'   => $oDetail,
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        } else {
            // Not Found
            $aResult = array(
                'rtCode' => '800',
                'rtDesc' => 'data not found.',
            );
        }
        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }
    
   // Functionality : Delete HD/DT Document Adjust Stock
    // Parameters : function parameters
    // Creator : 07/06/2019 Wasin(Yoshi)
    // Last Modified : -
    // Return : Array Status Delete
    // Return Type : array
    public function FSnMDPYDelDocument($paDataDoc)
    {
        $tDPYDocNo  = $paDataDoc['tDPYDocNo'];

        $this->db->trans_begin();

        // Document HD 
        $this->db->where_in('FTXdhDocNo', $tDPYDocNo);
        $this->db->delete('TCNTAppDepHD');

        // Document DT
        $this->db->where_in('FTXdhDocNo', $tDPYDocNo);
        $this->db->delete('TCNTAppDepDT');

        // Document Temp
        $this->db->where_in('FTXdhDocNo', $tDPYDocNo);
        $this->db->delete('TCNTAppDepHD_L');

        // Document Temp
        $this->db->where_in('FTXdhDocNo', $tDPYDocNo);
        $this->db->delete('TCNTAppDepHDBch');


        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            $aStaDeleteDoc  = array(
                'rtCode'    => '905',
                'rtDesc'    => 'Cannot Delete Item.',
            );
        } else {
            $this->db->trans_commit();
            $aStaDeleteDoc  = array(
                'rtCode'    => '1',
                'rtDesc'    => 'Delete Complete.',
            );
        }
        return $aStaDeleteDoc;
    }



    //Functionality : Function Cancel Doc
    //Parameters : function parameters
    //Creator : 29/06/2019 Witsarut(Bell)
    //Last Modified : -
    //Return : Status Cancel
    //Return Type : array
    public function FSVMDPYCancel($paDataUpdate)
    {
        try {
            $dLastUpdOn = date('Y-m-d H:i:s');
            $tLastUpdBy = $this->session->userdata('tSesUsername');
            $this->db->set('FDLastUpdOn', $dLastUpdOn);
            $this->db->set('FTLastUpdBy', $tLastUpdBy);

            $this->db->set('FTXdhStaPreDep', 3);
            $this->db->set('FTXdhStaDep', 3);
            $this->db->where('FTXdhDocNo', $paDataUpdate['FTXdhDocNo']);

            $this->db->update('TCNTAppDepHD');
            if ($this->db->affected_rows() > 0) {
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'OK',
                );
            } else {
                $aStatus = array(
                    'rtCode' => '903',
                    'rtDesc' => 'Not Approve',
                );
            }

            return $aStatus;
        } catch (Exception $Error) {
            return $Error;
        }
    }


    //Functionality : Function Approve Doc
    //Parameters : function parameters
    //Creator : 29/06/2019 Witsarut(Bell)
    //Last Modified : 30/07/2019 Wasin(Yoshi)
    //Return : Status Approve
    //Return Type : array
    public function FSvMDPYApprove($paDataUpdate)
    {
        try {
            $dLastUpdOn = date('Y-m-d H:i:s');
            $tLastUpdBy = $this->session->userdata('tSesUsername');
            $this->db->set('FDLastUpdOn', $dLastUpdOn);
            $this->db->set('FTLastUpdBy', $tLastUpdBy);

            $this->db->set('FTXdhStaPreDep', 1);
            $this->db->set('FTXdhStaDep', 2);
            $this->db->set('FTXdhJsonUrl', $paDataUpdate['FTXdhJsonUrl']);
            $this->db->set('FTXdhUsrApvPreDep', $paDataUpdate['FTXdhUsrApvPreDep']);
            $this->db->where('FTXdhDocNo', $paDataUpdate['FTXdhDocNo']);

            $this->db->update('TCNTAppDepHD');
            if ($this->db->affected_rows() > 0) {
                $aStatus = array(
                    'rtCode'  => '1',
                    'rtDesc'  => 'OK',
                );
            } else {
                $aStatus = array(
                    'rtCode'  => '903',
                    'rtDesc'  => 'Not Approve',
                );
            }
            return $aStatus;
        } catch (Exception $Error) {
            return $Error;
        }
    }


    // Functionality : Function Get Data Url Api 
    // Parameters : Ajax and Function Parameter
    // Creator : 16/06/2021 Nattakit
    // LastUpdate: -
    // Return : Object Get Data Url Api 
    // Return Type : object
    public function FCNaMDPYGetObjectUrl(){

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


    //Functionality : Function Approve Doc
    //Parameters : function parameters
    //Creator : 29/06/2019 Witsarut(Bell)
    //Last Modified : 30/07/2019 Wasin(Yoshi)
    //Return : Status Approve
    //Return Type : array
    public function FSvMDPYApproveDeploy($paDataUpdate)
    {
        try {
            $dLastUpdOn = date('Y-m-d H:i:s');
            $tLastUpdBy = $this->session->userdata('tSesUsername');
            $this->db->set('FDLastUpdOn', $dLastUpdOn);
            $this->db->set('FTLastUpdBy', $tLastUpdBy);

            $this->db->set('FTXdhStaDep', 1);
            $this->db->set('FTXdhUsrApv', $paDataUpdate['FTXdhUsrApv']);
            $this->db->where('FTXdhDocNo', $paDataUpdate['FTXdhDocNo']);

            $this->db->update('TCNTAppDepHD');
            if ($this->db->affected_rows() > 0) {
                $aStatus = array(
                    'rtCode'  => '1',
                    'rtDesc'  => 'OK',
                );
            } else {
                $aStatus = array(
                    'rtCode'  => '903',
                    'rtDesc'  => 'Not Approve',
                );
            }
            return $aStatus;
        } catch (Exception $Error) {
            return $Error;
        }
    }


}