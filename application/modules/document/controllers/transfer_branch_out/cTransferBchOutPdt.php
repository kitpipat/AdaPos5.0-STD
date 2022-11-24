<?php
defined('BASEPATH') or exit('No direct script access allowed');

class cTransferBchOutPdt extends MX_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model('document/transfer_branch_out/mTransferBchOutPdt');
        $this->load->model('document/transfer_branch_out/mTransferBchOut');
    }

    /**
     * Functionality : Get Pdt in Temp
     * Parameters : -
     * Creator : 04/02/2020 piya
     * Last Modified : -
     * Return : Status
     * Return Type : Array
     */
    public function FSxCTransferBchOutGetPdtInTmp()
    {
        $tSearchAll = $this->input->post('tSearchAll');
        $tIsApvOrCancel = $this->input->post('tIsApvOrCancel');
        $nPage = $this->input->post('nPageCurrent');
        $aAlwEvent = FCNaHCheckAlwFunc('deposit/0/0');
        $nOptDecimalShow = FCNxHGetOptionDecimalShow();
        $tUserSessionID = $this->session->userdata("tSesSessionID");
        $tDocNo = $this->input->post('tDocNo');
        $tDocKey = 'TCNTPdtTboHD';

        if ($nPage == '' || $nPage == null) {
            $nPage = 1;
        } else {
            $nPage = $this->input->post('nPageCurrent');
        }
        $nLangEdit = $this->session->userdata("tLangEdit");

        $aColumnShow = FCNaDCLGetColumnShow('TCNTPdtTboDT');
        $aCompanyInfo  = FCNaGetCompanyForDocument();
        // Calcurate Document DT Temp
        $aCalcDTParams = [
            'tDataDocEvnCall'   => '',
            'tDataVatInOrEx'    => $aCompanyInfo['tCmpRetInOrEx'],
            'tDataDocNo'        => $tDocNo,
            'tDataDocKey'       => $tDocKey,
            'tDataSeqNo'        => ''
        ];
        FCNbHCallCalcDocDTTemp($aCalcDTParams);

        $aEndOfBillParams = [
            'tSplVatType' => $aCompanyInfo['tCmpRetInOrEx'],
            'tDocNo' => $tDocNo,
            'tDocKey' => $tDocKey,
            'nLngID' => FCNaHGetLangEdit(),
            'tSesSessionID' => $this->session->userdata('tSesSessionID'),
            'tBchCode' => $this->session->userdata('tSesUsrLevel') == 'HQ' ? FCNtGetBchInComp() : $this->session->userdata('tSesUsrBchCode')
        ];
        $aEndOfBill['aEndOfBillVat'] = FCNaDOCEndOfBillCalVat($aEndOfBillParams);
        $aEndOfBill['aEndOfBillCal'] = FCNaDOCEndOfBillCal($aEndOfBillParams);
        $aEndOfBill['tTextBath'] = FCNtNumberToTextBaht($aEndOfBill['aEndOfBillCal']['cCalFCXphGrand']);

        $aGetPdtInTmpParams  = array(
            'FNLngID' => $nLangEdit,
            'nPage' => $nPage,
            'nRow' => 900000,
            'tSearchAll' => $tSearchAll,
            'tUserSessionID' => $tUserSessionID,
            'tDocKey' => $tDocKey
        );
        $aResList = $this->mTransferBchOutPdt->FSaMGetPdtInTmp($aGetPdtInTmpParams);

        $aGenTable = array(
            'aAlwEvent' => $aAlwEvent,
            'aDataList' => $aResList,
            'bIsApvOrCancel' => ($tIsApvOrCancel=="1")?true:false,
            'aColumnShow' => $aColumnShow,
            'nPage' => $nPage,
            'nOptDecimalShow' => $nOptDecimalShow
        );
        $tHtml = $this->load->view('document/transfer_branch_out/advance_table/wTransferBchOutPdtDatatable', $aGenTable, true);

        $aResponse = [
            'aEndOfBill' => $aEndOfBill,
            'html' => $tHtml
        ];

        $this->output->set_status_header(200)->set_content_type('application/json')->set_output(json_encode($aResponse));
    }

    /**
     * Functionality : Insert Pdt to Temp
     * Parameters : -
     * Creator : 04/02/2020 piya
     * Last Modified : -
     * Return : Status
     * Return Type : Array
     */
    public function FSaCTransferBchOutInsertPdtToTmp()
    {
        $tDocNo             = $this->input->post('ptXthDocNo');
        $tDocKey            = 'TCNTPdtTboHD';
        $nLngID             = $this->session->userdata("tLangID");
        $tUserSessionID     = $this->session->userdata('tSesSessionID');
        $tUserLevel         = $this->session->userdata('tSesUsrLevel');
        $tBchCode           = $this->input->post('ptBchCode');

        $tTransferBchOutOptionAddPdt = $this->input->post('pnTBOptionAddPdt');
        $tIsByScanBarCode = $this->input->post('tIsByScanBarCode');
        $tBarCodeByScan = $this->input->post('tBarCodeByScan');
        $tPdtData = $this->input->post('tPdtData');
        $aPdtData = json_decode($tPdtData);

        $this->db->trans_begin();

        if ($tIsByScanBarCode != '1') { // ทำงานเมื่อไม่ใช่การแสกนบาร์โค้ดมา

            // ทำทีรายการ ตามรายการสินค้าที่เพิ่มเข้ามา
            foreach ($aPdtData as $nKey => $oItem) {
                $oPackData = $oItem->packData;

                $tPdtCode = $oPackData->PDTCode;
                $tBarCode = $oPackData->Barcode;
                $tPunCode = $oPackData->PUNCode;
                $cPrice = $oPackData->Price;

                $aGetMaxSeqDTTempParams = array(
                    'tDocNo' => $tDocNo,
                    'tDocKey' => $tDocKey,
                    'tUserSessionID' => $tUserSessionID
                );
                $nMaxSeqNo = $this->mTransferBchOutPdt->FSnMGetMaxSeqDTTemp($aGetMaxSeqDTTempParams);

                $aDataPdtParams = array(
                    'tDocNo' => $tDocNo,
                    'tBchCode' => $tBchCode, // จากสาขาที่ทำรายการ
                    'tPdtCode' => $tPdtCode, // จาก Browse Pdt
                    'tPunCode' => $tPunCode, // จาก Browse Pdt
                    'tBarCode' => $tBarCode, // จาก Browse Pdt
                    'pcPrice' => str_replace(',', '', $cPrice), // ราคาสินค้าจาก Browse Pdt
                    'nMaxSeqNo' => $nMaxSeqNo + 1, // จำนวนล่าสุด Seq
                    // 'nCounts' => $nCounts,
                    'nLngID' => $nLngID, // รหัสภาษาที่ login
                    'tUserSessionID' => $tUserSessionID,
                    'tDocKey' => $tDocKey,
                    'tOptionAddPdt' => $tTransferBchOutOptionAddPdt
                );

                $aDataPdtMaster = $this->mTransferBchOutPdt->FSaMGetDataPdt($aDataPdtParams); // Data Master Pdt ข้อมูลรายการสินค้าที่เพิ่มเข้ามา

                if ($aDataPdtMaster['rtCode'] == '1') {
                    $this->mTransferBchOutPdt->FSaMInsertPDTToTemp($aDataPdtMaster, $aDataPdtParams); // นำรายการสินค้าเข้า DT Temp
                }
            }
        }

        // นำเข้ารายการสินค้าจากการแสกนบาร์โค้ด
        if ($tIsByScanBarCode == '1') {
            $aGetPunCodeByBarCodeParams = [
                'tBarCode' => $tBarCodeByScan,
                'tSplCode' => $tSplCode
            ];
            $aPdtData = $this->mTransferBchOutPdt->FSaMCreditNoteGetPunCodeByBarCode($aGetPunCodeByBarCodeParams);

            if ($aPdtData['rtCode'] == '1') {

                $aDataWhere = array(
                    'tDocNo'    => $tDocNo,
                    'tDocKey'   => 'TAPTPcHD',
                );
                $nMaxSeqNo = $this->mTransferBchOutPdt->FSaMCreditNoteGetMaxSeqDTTemp($aDataWhere);

                $aPdtItems = $aPdtData['raItem'];
                // Loop
                $aDataPdtParams = array(
                    'tDocNo' => $tDocNo,
                    'tSplCode' => $tSplCode,
                    'tBchCode' => $tBchCode,   // จากสาขาที่ทำรายการ
                    'tPdtCode' => $aPdtItems['FTPdtCode'],  // จาก Browse Pdt
                    'tPunCode' => $aPdtItems['FTPunCode'],  // จาก Browse Pdt
                    'tBarCode' => $aPdtItems['FTBarCode'],  // จาก Browse Pdt
                    'pcPrice' => $aPdtItems['cCost'],
                    'nMaxSeqNo' => $nMaxSeqNo + 1, // จำนวนล่าสุด Seq
                    // 'nCounts' => $nCounts,
                    'nLngID' => $this->session->userdata("tLangID"), // รหัสภาษาที่ login
                    'tSessionID' => $this->session->userdata('tSesSessionID'),
                    'tDocKey' => 'TAPTPcHD',
                    'nCreditNoteOptionAddPdt' => $nCreditNoteOptionAddPdt
                );

                $aDataPdtMaster = $this->mTransferBchOutPdt->FSaMCreditNoteGetDataPdt($aDataPdtParams); // Data Master Pdt ข้อมูลรายการสินค้าที่เพิ่มเข้ามา
                if ($aDataPdtMaster['rtCode'] == '1') {
                    $nStaInsPdtToTmp = $this->mTransferBchOutPdt->FSaMCreditNoteInsertPDTToTemp($aDataPdtMaster, $aDataPdtParams); // นำรายการสินค้าเข้า DT Temp
                }
                // Loop
            } else {
                $aStatus = array(
                    'rtCode' => '800',
                    'rtDesc' => 'Data not found.',
                );
                $this->output->set_status_header(200)->set_content_type('application/json')->set_output(json_encode($aStatus));
            }
        }

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => "Unsucess InsertPdtToTmp"
            );
        } else {
            $this->db->trans_commit();
            $aReturn = array(
                'nStaEvent'    => '1',
                'tStaMessg' => 'Success InsertPdtToTmp'
            );
        }

        $this->output->set_content_type('application/json')->set_output(json_encode($aReturn));
    }

    /**
     * Functionality : Update Pdt in Temp
     * Parameters : -
     * Creator : 04/02/2020 piya
     * Last Modified : -
     * Return : -
     * Return Type : -
     */
    public function FSxCTransferBchOutUpdatePdtInTmp()
    {
        // $tFieldName = $this->input->post('tFieldName');
        // $tValue = $this->input->post('tValue');
        // $nSeqNo = $this->input->post('nSeqNo');
        // $tDocNo = $this->input->post('tDocNo');
        // $tDocKey = 'TCNTPdtTboHD';
        // $tBchCode = $this->input->post('tBchCode');
        // $tUserSessionID = $this->session->userdata("tSesSessionID");
        // $tUserLoginCode = $this->session->userdata("tSesUsername");

        // $this->db->trans_begin();

        // $aUpdatePdtInTmpBySeqParams = [
        //     'tFieldName' => $tFieldName,
        //     'tValue' => $tValue,
        //     'tUserSessionID' => $tUserSessionID,
        //     'tDocNo' => $tDocNo,
        //     'tDocKey' => $tDocKey,
        //     'nSeqNo' => $nSeqNo,
        // ];
        // $this->mTransferBchOutPdt->FSbUpdatePdtInTmpBySeq($aUpdatePdtInTmpBySeqParams);

        // if ($this->db->trans_status() === FALSE) {
        //     $this->db->trans_rollback();
        //     $aReturn = array(
        //         'nStaEvent'    => '900',
        //         'tStaMessg'    => "Unsucess UpdatePdtInTmp"
        //     );
        // } else {
        //     $this->db->trans_commit();
        //     $aReturn = array(
        //         'nStaEvent'    => '1',
        //         'tStaMessg' => 'Success UpdatePdtInTmp'
        //     );
        // }

        // $this->output->set_content_type('application/json')->set_output(json_encode($aReturn));
        try {
            $tBchCode         = $this->input->post('tBchCode');
            $tDocNo           = $this->input->post('tDocNo');
            $tVATInOrEx       = $this->input->post('tVATInOrEx');
            $nSeqNo           = $this->input->post('nSeqNo');
            $nIsDelDTDis      = $this->input->post('nStaDelDis');
            $tSessionID       = $this->session->userdata('tSesSessionID');

            $aDataWhere = array(
                'tBchCode'    => $tBchCode,
                'tDocNo'      => $tDocNo,
                'nSeqNo'      => $nSeqNo,
                'tSessionID'  => $this->session->userdata('tSesSessionID'),
                'tDocKey'       => 'TCNTPdtTboHD',
                'nStaDis'     =>  $nIsDelDTDis 
            );
            $aDataUpdateDT = array(
                // 'tPIFieldName'  => $tPIFieldName,
                // 'tPIValue'      => $tPIValue,
                'FCXtdQty'      => $this->input->post('nQty'),
                'FCXtdSetPrice' => $this->input->post('cPrice'),
                'FCXtdNet'      => $this->input->post('cNet')
            );

            $this->db->trans_begin();

            $this->mTransferBchOutPdt->FSbUpdatePdtInTmpBySeq($aDataUpdateDT, $aDataWhere);

            if ($this->db->trans_status() === FALSE) {
                $this->db->trans_rollback();
                $aReturnData = array(
                    'nStaEvent' => '500',
                    'tStaMessg' => "Error Update Inline Into Document DT Temp."
                );
            } else {
                $this->db->trans_commit();
                $aReturnData = array(
                    'nStaEvent' => '1',
                    'tStaMessg' => "Update Inline Into Document DT Temp."
                );
            }
        } catch (Exception $Error) {
            $aReturnData = array(
                'nStaEvent' => '500',
                'tStaMessg' => $Error->getMessage()
            );
        }
        echo json_encode($aReturnData);
    }

    /**
     * Functionality : Delete Pdt in Temp
     * Parameters : -
     * Creator : 04/02/2020 piya
     * Last Modified : -
     * Return : -
     * Return Type : -
     */
    public function FSxCTransferBchOutDeletePdtInTmp()
    {
        $tDocNo = $this->input->post('tDocNo');
        $nSeqNo = $this->input->post('nSeqNo');
        $tUserSessionID = $this->session->userdata("tSesSessionID");

        $this->db->trans_begin();

        $aDeleteInTmpBySeqParams = [
            'tUserSessionID' => $tUserSessionID,
            'tDocNo' => $tDocNo,
            'tDocKey' => 'TCNTPdtTboHD',
            'nSeqNo' => $nSeqNo,
        ];
        $this->mTransferBchOutPdt->FSbDeletePdtInTmpBySeq($aDeleteInTmpBySeqParams);

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => "Unsucess DeletePdtInTmp"
            );
        } else {
            $this->db->trans_commit();
            $aReturn = array(
                'nStaEvent'    => '1',
                'tStaMessg' => 'Success DeletePdtInTmp'
            );
        }

        $this->output->set_content_type('application/json')->set_output(json_encode($aReturn));
    }

    /**
     * Functionality : Delete More Pdt in Temp
     * Parameters : -
     * Creator : 04/02/2020 piya
     * Last Modified : Napat(Jame) 31/07/2020
     * Return : -
     * Return Type : -
     */
    public function FSxCTransferBchOutDeleteMorePdtInTmp()
    {
        // $tSeqNo = $this->input->post('paSeqNo');
        $tUserSessionID = $this->session->userdata("tSesSessionID");

        $this->db->trans_begin();
        
        $aDeleteInTmpBySeqParams = [
            'tUserSessionID' => $tUserSessionID,
            'tDocNo' => $this->input->post('tDocNo'),
            'tDocKey' => 'TCNTPdtTboHD',
            'aSeqNo' => $this->input->post('paSeqNo'),
        ];
        $this->mTransferBchOutPdt->FSbDeleteMorePdtInTmpBySeq($aDeleteInTmpBySeqParams);

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => "Unsucess DeleteMorePdtInTmp"
            );
        } else {
            $this->db->trans_commit();
            $aReturn = array(
                'nStaEvent'    => '1',
                'tStaMessg' => 'Success DeleteMorePdtInTmp'
            );
        }

        $this->output->set_content_type('application/json')->set_output(json_encode($aReturn));
    }

    /**
     * Functionality : Clear Pdt in Temp
     * Parameters : -
     * Creator : 04/02/2020 piya
     * Last Modified : -
     * Return : -
     * Return Type : -
     */
    public function FSxCTransferBchOutClearPdtInTmp()
    {
        $tUserSessionID = $this->session->userdata("tSesSessionID");

        $aClearPdtInTmpParams = [
            'tUserSessionID' => $tUserSessionID
        ];
        $this->mTransferBchOutPdt->FSbClearPdtInTmp($aClearPdtInTmpParams);
    }

    /**
     * Functionality : Get Pdt Column List
     * Parameters : -
     * Creator : 04/02/2020 piya
     * Last Modified : -
     * Return : -
     * Return Type : -
     */
    public function FStCTransferBchOutGetPdtColumnList()
    {

        $aAvailableColumn = FCNaDCLAvailableColumn('TCNTPdtTboDT');
        $aData['aAvailableColumn'] = $aAvailableColumn;
        $this->load->view('document/transfer_branch_out/advance_table/wTransferBchOutPdtColList', $aData);
    }

    /**
     * Functionality : Update Pdt Column
     * Parameters : -
     * Creator : 04/02/2020 piya
     * Last Modified : -
     * Return : -
     * Return Type : -
     */
    public function FStCTransferBchOutUpdatePdtColumn()
    {

        $aColShowSet = $this->input->post('aColShowSet');
        $aColShowAllList = $this->input->post('aColShowAllList');
        $aColumnLabelName = $this->input->post('aColumnLabelName');
        $nStaSetDef = $this->input->post('nStaSetDef');

        $this->db->trans_begin();

        FCNaDCLSetShowCol('TCNTPdtTboDT', '', '');

        if ($nStaSetDef == 1) {
            FCNaDCLSetDefShowCol('TCNTPdtTboDT');
        } else {
            for ($i = 0; $i < FCNnHSizeOf($aColShowSet); $i++) {

                FCNaDCLSetShowCol('TCNTPdtTboDT', 1, $aColShowSet[$i]);
            }
        }

        // Reset Seq
        FCNaDCLUpdateSeq('TCNTPdtTboDT', '', '', '');
        $q = 1;
        for ($n = 0; $n < FCNnHSizeOf($aColShowAllList); $n++) {
            FCNaDCLUpdateSeq('TCNTPdtTboDT', $aColShowAllList[$n], $q, $aColumnLabelName[$n]);
            $q++;
        }

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => "Unsucess UpdatePdtColumn"
            );
        } else {
            $this->db->trans_commit();
            $aReturn = array(
                'nStaEvent'    => '1',
                'tStaMessg' => 'Success UpdatePdtColumn'
            );
        }

        $this->output->set_content_type('application/json')->set_output(json_encode($aReturn));
    }



    


    //เพิ่มสินค้าลงตาราง Tmp
    public function FSoCTBOEventAddPdtIntoDTFhnTemp(){
        try {
            $aCompanyInfo  = FCNaGetCompanyForDocument();
            
            $tTWOUserLevel       = $this->session->userdata('tSesUsrLevel');
            $tTBODocNo           = $this->input->post('tTBODocNo');
            $tTBOBCHCode         = $this->input->post('tTBOBCH');
            $tTBOPdtDataFhn      = $this->input->post('tTBOPdtDataFhn');
            $aTBXPdtData         = JSON_decode($tTBOPdtDataFhn);
            $tTBOVATInOrEx       = $aCompanyInfo['tCmpRetInOrEx'];
            $tTypeInsPDT         = $this->input->post('tTBOType');
            $nEvent         = $this->input->post('nEvent');
            $tOptionAddPdt    = $this->input->post('tOptionAddPdt');

            $aDataWhere = array(
                'tBchCode'  => $tTBOBCHCode,
                'tDocNo'    => $tTBODocNo,
                'tDocKey'   => 'TCNTPdtTboHD',
            );
            $this->db->trans_begin();
            if($aTBXPdtData->tType=='confirm'){
                // $aDataWhere['tPdtCode'] = $aTBXPdtData->aResult[0]->tPDTCode;
                // FCNxClearDTFhnTmp($aDataWhere);
                // ทำทีรายการ ตามรายการสินค้าที่เพิ่มเข้ามา
                $nPdtParentQty = 0;
                for ($nI = 0; $nI < FCNnHSizeOf($aTBXPdtData->aResult); $nI++) {

                    $aItem          = $aTBXPdtData->aResult[$nI];
                    $tTBOPdtCode    = $aItem->tPDTCode;
                    $tTBOtRefCode   = $aItem->tRefCode;
                    $tTBOtBarCode   = $aItem->tBarCode;
                    $tTBOtPunCode   = $aItem->tPunCode;
                    $nTBXnQty       = $aItem->nQty;

                    $nPdtParentQty  = $nPdtParentQty + $nTBXnQty;

                    $aDataWhere['tPdtCode'] = $tTBOPdtCode;
                    $aDataWhere['tBarCode'] = $tTBOtBarCode;
                    $aDataWhere['tPunCode'] = $tTBOtPunCode;
                    
                    
                    if($nEvent==1){
                        $nTBXSeqNo = FCNnGetMaxSeqDTFhnTmp($aDataWhere);
                    }else{
                        $nDTSeq         = $aItem->nDTSeq;
                        $nTBXSeqNo      =  $nDTSeq;
                    }

                    $aDataPdtParams = array(
                        'tDocNo'            => $tTBODocNo,
                        'tBchCode'          => $tTBOBCHCode,
                        'tPdtCode'          => $tTBOPdtCode,
                        'tRefCode'          => $tTBOtRefCode,
                        'nMaxSeqNo'         => $nTBXSeqNo,
                        'nQty'              => $nTBXnQty,
                        'tOptionAddPdt'     => $tOptionAddPdt,
                        'nLngID'            => $this->session->userdata("tLangID"),
                        'tSessionID'        => $this->session->userdata('tSesSessionID'),
                        'tDocKey'           => 'TCNTPdtTboHD',
                    );
                    // นำรายการสินค้าเข้า DT Temp
                    if($nEvent==1){
                    $nStaInsPdtToTmp    = FCNaInsertPDTFhnToTemp($aDataPdtParams);
                    }else{
                    $nStaInsPdtToTmp    = FCNaUpdatePDTFhnToTemp($aDataPdtParams);    
                    }

                }

                $aDataUpdateQtyParent = array(
                    'tDocNo'        => $tTBODocNo,
                    'nXtdSeq'       => $nTBXSeqNo,
                    'tSessionID'    => $this->session->userdata('tSesSessionID'),
                    'tDocKey'       => 'TCNTPdtTboHD',
                    'tValue'        => $nPdtParentQty
                );
                FCNaUpdateInlineDTTmp($aDataUpdateQtyParent);
            }else{
                $tTBOPdtCode = $aTBXPdtData->aResult->tPDTCode;
                $aDataPdtParams = array(
                    'tDocNo'            => $tTBODocNo,
                    'tBchCode'          => $tTBOBCHCode,
                    'tPdtCode'          => $tTBOPdtCode,
                    'tSessionID'        => $this->session->userdata('tSesSessionID'),
                    'tDocKey'           => 'TCNTPdtTboHD',
                );
                $nStaInsPdtToTmp    = FCNxDeletePDTInTmp($aDataPdtParams);
            }

            if ($this->db->trans_status() === FALSE) {
                $this->db->trans_rollback();
                $aReturnData = array(
                    'nStaEvent' => '500',
                    'tStaMessg' => 'Error Insert Product Error Please Contact Admin.'
                );
            } else {
                $this->db->trans_commit();
                // Calcurate Document DT Temp Array Parameter
                $aCalcDTParams = [
                    'tDataDocEvnCall'   => '1',
                    'tDataVatInOrEx'    => $tTBOVATInOrEx,
                    'tDataDocNo'        => $tTBODocNo,
                    'tDataDocKey'       => 'TCNTPdtTboHD',
                    'tDataSeqNo'        => ''
                ];
                $tStaCalcuRate = FCNbHCallCalcDocDTTemp($aCalcDTParams);
                if ($tStaCalcuRate === TRUE) {
    
                    $aReturnData = array(
                        'nStaEvent' => '1',
                        'tStaMessg' => 'Success Add Product Into Document DT Temp.'
                    );
                } else {
                    $aReturnData = array(
                        'nStaEvent' => '500',
                        'tStaMessg' => 'Error Calcurate Document DT Temp Please Contact Admin.'
                    );
                }
            }
        } catch (Exception $Error) {
            $aReturnData = array(
                'nStaEvent' => '500',
                'tStaMessg' => $Error->getMessage()
            );
        }
        echo json_encode($aReturnData);
    }



}
