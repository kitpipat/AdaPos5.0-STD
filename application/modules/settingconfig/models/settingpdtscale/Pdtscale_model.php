<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Pdtscale_model extends CI_Model
{

    /**
     * Functionality : Search Server Printer By ID
     * Parameters : $paData
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : Data
     * Return Type : array
     */
    public function FSaMPDSSearchByID($paData)
    {
        $tPdsCode   = $paData['FTPdsCode'];
        $tAgnCode   = $paData['FTAgnCode'];
        
        $nLngID     = $paData['FNLngID'];
        $tSQL       = "SELECT
                                PDS.FTAgnCode,
                                AGN_L.FTAgnName,
                                PDS.FTPdsCode,
                                PDS.FTPdsMatchStr,
                                PDS.FNPdsLenBar,
                                PDS.FNPdsLenPdt,
                                PDS.FNPdsPdtStart,
                                PDS.FNPdsLenPri,
                                PDS.FNPdsPriStart,
                                PDS.FNPdsPriDec,
                                PDS.FNPdsLenWeight,
                                PDS.FNPdsWeightStart,
                                PDS.FNPdsWeightDec,
                                PDS.FTPdsStaChkDigit,
                                PDS.FTPdsStaUse,
                                PDS.FDLastUpdOn,
                                PDS.FTLastUpdBy,
                                PDS.FDCreateOn,
                                PDS.FTCreateBy
                       FROM TCNMPdtScale PDS WITH(NOLOCK)
                       LEFT JOIN TCNMAgency_L AGN_L WITH(NOLOCK) ON PDS.FTAgnCode = AGN_L.FTAgnCode AND AGN_L.FNLngID = $nLngID
                       WHERE ISNULL(PDS.FTPdsCode,'')!='' ";
        if ($tPdsCode != "") {
            $tSQL .= "AND PDS.FTPdsCode = '$tPdsCode'";
        }
        if ($tAgnCode != "") {
            $tSQL .= "AND PDS.FTAgnCode = '$tAgnCode'";
        }
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $oDetail = $oQuery->result();
            $aResult = array(
                'raItems'   => $oDetail[0],
                'rtCode'    => '1',
                'rtDesc'    => 'success',
            );
        } else {
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

    /**
     * Functionality : List Server Printer
     * Parameters : $ptAPIReq, $ptMethodReq is request type, $paData is data for select filter
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : data
     * Return Type : array
     */
    public function FSaMPDSList($paData)
    {
        // return null;
        $aRowLen    = FCNaHCallLenData($paData['nRow'], $paData['nPage']);
        $nLngID     = $paData['FNLngID'];

        $tSesAgnCode = $paData['tSesAgnCode'];
        $tSQL       = "SELECT c.* FROM(
                       SELECT  ROW_NUMBER() OVER(ORDER BY FDCreateOn DESC , FTPdsCode DESC) AS rtRowID,*
                       FROM
                       (
                            SELECT
                                PDS.FTAgnCode,
                                PDS.FTPdsCode,
                                PDS.FTPdsMatchStr,
                                PDS.FNPdsLenBar,
                                PDS.FNPdsLenPdt,
                                PDS.FNPdsPdtStart,
                                PDS.FNPdsLenPri,
                                PDS.FNPdsPriStart,
                                PDS.FNPdsPriDec,
                                PDS.FNPdsLenWeight,
                                PDS.FNPdsWeightStart,
                                PDS.FNPdsWeightDec,
                                PDS.FTPdsStaChkDigit,
                                PDS.FTPdsStaUse,
                                PDS.FDLastUpdOn,
                                PDS.FTLastUpdBy,
                                PDS.FDCreateOn,
                                PDS.FTCreateBy
                            FROM
                                TCNMPdtScale PDS WITH (NOLOCK)
                            WHERE ISNULL(PDS.FTPdsCode,'') != ''
                        ";

        $tSearchList = $paData['tSearchAll'];
        if ($tSearchList != '') {
            $tSQL .= " AND PDS.FTPdsCode COLLATE THAI_BIN LIKE '%$tSearchList%' ";
        }

        if($tSesAgnCode!=''){
            $tSQL .= " AND PDS.FTAgnCode ='$tSesAgnCode' ";
        }
        $tSQL .= ") Base) AS c WHERE c.rtRowID > $aRowLen[0] AND c.rtRowID <= $aRowLen[1]";

        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $oList = $oQuery->result();
            $aFoundRow = $this->FSnMPDSGetPageAll(/*$tWhereCode,*/$tSearchList, $nLngID, $tSesAgnCode);
            $nFoundRow = $aFoundRow[0]->counts;
            $nPageAll = ceil($nFoundRow / $paData['nRow']); //หา Page All จำนวน Rec หาร จำนวนต่อหน้า
            $aResult = array(
                'raItems'       => $oList,
                'rnAllRow'      => $nFoundRow,
                'rnCurrentPage' => $paData['nPage'],
                'rnAllPage'     => $nPageAll,
                'rtCode'        => '1',
                'rtDesc'        => 'success',
            );
        } else {
            //No Data
            $aResult = array(
                'rnAllRow' => 0,
                'rnCurrentPage' => $paData['nPage'],
                "rnAllPage" => 0,
                'rtCode' => '800',
                'rtDesc' => 'data not found',
            );
        }

        $jResult = json_encode($aResult);
        $aResult = json_decode($jResult, true);
        return $aResult;
    }

    /**
     * Functionality : All Page Of Server Printer
     * Parameters : $ptSearchList, $ptLngID
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : data
     * Return Type : array
     */
    public function FSnMPDSGetPageAll($ptSearchList, $ptLngID, $tSesAgnCode)
    {
        $tSQL = "SELECT COUNT (PDS.FTPdsCode) AS counts
                FROM [TCNMPdtScale] PDS
                WHERE ISNULL(PDS.FTPdsCode,'') != '' ";

        if ($ptSearchList != '') {
            $tSQL .= " AND (PDS.FTPdsCode LIKE '%$ptSearchList%')";

        }

        if($tSesAgnCode!=''){
            $tSQL .= " AND PDS.FTAgnCode ='$tSesAgnCode' ";
        }
        
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        } else {
            //No Data
            return false;
        }
    }


    /**
     * Functionality : Checkduplicate
     * Parameters : $ptSrvPriCode
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : data
     * Return Type : object is has result, boolean is no result
     */
    public function FSoMPDSCheckDuplicate($ptPrnSrvCode)
    {
        $tSQL = "SELECT COUNT(FTPdsCode) AS counts
                 FROM TCNMPdtScale
                 WHERE FTPdsCode = '$ptPrnSrvCode' ";
        $oQuery = $this->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            return $oQuery->result();
        } else {
            return false;
        }
    }

    /**
     * Functionality : Update Server Printer
     * Parameters : $paData is data for update
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : Status response
     * Return Type : array
     */
    public function FSaMPDSAddUpdateMaster($paData)
    {

        try {
            // Update Master
            $this->db->set('FDLastUpdOn', $paData['FDLastUpdOn']);
            $this->db->set('FTLastUpdBy', $paData['FTLastUpdBy']);
            $this->db->set('FNPdsLenBar', $paData['FNPdsLenBar']);
            $this->db->set('FNPdsLenPdt', $paData['FNPdsLenPdt']);
            $this->db->set('FTPdsMatchStr', $paData['FTPdsMatchStr']);
            $this->db->set('FNPdsPdtStart', $paData['FNPdsPdtStart']);
            $this->db->set('FNPdsLenPri', $paData['FNPdsLenPri']);
            $this->db->set('FNPdsPriDec', $paData['FNPdsPriDec']);
            $this->db->set('FNPdsPriStart', $paData['FNPdsPriStart']);
            $this->db->set('FNPdsLenWeight', $paData['FNPdsLenWeight']);
            $this->db->set('FNPdsWeightDec', $paData['FNPdsWeightDec']);
            $this->db->set('FNPdsWeightStart', $paData['FNPdsWeightStart']);
            $this->db->set('FTPdsStaChkDigit', $paData['FTPdsStaChkDigit']);
            $this->db->set('FTPdsStaUse', $paData['FTPdsStaUse']);
            $this->db->where('FTPdsCode', $paData['FTPdsCode']);
            $this->db->where('FTAgnCode', $paData['FTAgnCode']);
            $this->db->update('TCNMPdtScale');
         
            if ($this->db->affected_rows() > 0) {
                $aStatus = array(
                    'rtCode' => '1',
                    'rtDesc' => 'Update Master Success',
                );
            } else {
                // Add Master
                $this->db->insert('TCNMPdtScale', array(
                    'FTPdsCode'     => $paData['FTPdsCode'],
                    'FTAgnCode'     => $paData['FTAgnCode'],
                    'FNPdsLenBar'   => $paData['FNPdsLenBar'],
                    'FNPdsLenPdt'   => $paData['FNPdsLenPdt'],
                    'FTPdsMatchStr' => $paData['FTPdsMatchStr'],
                    'FNPdsPdtStart' => $paData['FNPdsPdtStart'],
                    'FNPdsLenPri'   => $paData['FNPdsLenPri'],
                    'FNPdsPriDec'   => $paData['FNPdsPriDec'],
                    'FNPdsPriStart' => $paData['FNPdsPriStart'],
                    'FNPdsLenWeight'  => $paData['FNPdsLenWeight'],
                    'FNPdsWeightDec'   => $paData['FNPdsWeightDec'],
                    'FNPdsWeightStart' => $paData['FNPdsWeightStart'],
                    'FDCreateOn'    => $paData['FDCreateOn'],
                    'FTCreateBy'    => $paData['FTCreateBy'],
                    'FDLastUpdOn'   => $paData['FDLastUpdOn'],
                    'FTLastUpdBy'   => $paData['FTLastUpdBy'],
                    'FTPdsStaUse'   => $paData['FTPdsStaUse'],
                    'FTPdsStaChkDigit'   => $paData['FTPdsStaChkDigit']
                ));
                if ($this->db->affected_rows() > 0) {
                    $aStatus = array(
                        'rtCode' => '1',
                        'rtDesc' => 'Add Master Success',
                    );
                } else {
                    $aStatus = array(
                        'rtCode' => '905',
                        'rtDesc' => 'Error Cannot Add/Edit Master.',
                    );
                }
            }
            return $aStatus;
        } catch (Exception $Error) {
            return $Error;
        }
    }


    /**
     * Functionality : Delete Server Printer
     * Parameters : $paData
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : Status response
     * Return Type : array
     */
    public function FSaMPDSDel($paData)
    {
        $this->db->where('FTPdsCode', $paData['FTPdsCode']);
        $this->db->where('FTAgnCode', $paData['FTAgnCode']);
        $this->db->delete('TCNMPdtScale');

        return $aStatus = array(
            'rtCode' => '1',
            'rtDesc' => 'success',
        );
    }
}
