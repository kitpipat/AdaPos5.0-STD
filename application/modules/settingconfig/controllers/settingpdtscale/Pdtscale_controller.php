<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Pdtscale_controller extends MX_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->load->model('settingconfig/settingpdtscale/Pdtscale_model');
        date_default_timezone_set("Asia/Bangkok");
    }

    /**
     * Functionality : Main page for Server Printer
     * Parameters : $nCPDSBrowseType, $tCPDSBrowseOption
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : -
     * Return Type : -
     */
    public function index($nCPDSBrowseType, $tCPDSBrowseOption)
    {
        $aDataConfigView    = [
            'nCPDSBrowseType'     => $nCPDSBrowseType,
            'tCPDSBrowseOption'   => $tCPDSBrowseOption,
            'aAlwEvent'             => FCNaHCheckAlwFunc('settingpdtscale/0/0'),
            'vBtnSave'              => FCNaHBtnSaveActiveHTML('settingpdtscale/0/0'),
            'nOptDecimalShow'       => FCNxHGetOptionDecimalShow(),
            'nOptDecimalSave'       => FCNxHGetOptionDecimalSave()
        ];
        $this->load->view('settingconfig/settingpdtscale/wPdtScale', $aDataConfigView);
    }

    /**
     * Functionality : Function Call Server Printer Page List
     * Parameters : Ajax and Function Parameter
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : String View
     * Return Type : View
     */
    public function FSvCPDSListPage()
    {
        $aDataConfigView    = [
            'aAlwEvent'             => FCNaHCheckAlwFunc('settingpdtscale/0/0')
        ];
        $this->load->view('settingconfig/settingpdtscale/wPdtScaleList', $aDataConfigView);
    }

    /**
     * Functionality : Function Call DataTables Server Printer
     * Parameters : Ajax and Function Parameter
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : String View
     * Return Type : View
     */
    public function FSvCPDSDataTable()
    {
        $nPage      = $this->input->post('nPageCurrent');
        $tSearchAll = $this->input->post('tSearchAll');
        if ($nPage == '' || $nPage == null) {
            $nPage = 1;
        } else {
            $nPage = $this->input->post('nPageCurrent');
        }
        if (!$tSearchAll) {
            $tSearchAll = '';
        }
        //Lang ภาษา
        $nLangResort    = $this->session->userdata("tLangID");
        $nLangEdit      = $this->session->userdata("tLangEdit");


        $aData  = array(
            'nPage'         => $nPage,
            'nRow'          => 10,
            'FNLngID'       => $nLangEdit,
            'tSearchAll'    => $tSearchAll,
            'tSesAgnCode'   => $this->session->userdata("tSesUsrAgnCode"),
        );


        $aResList = $this->Pdtscale_model->FSaMPDSList($aData);

        $aGenTable = array(
            'aDataList' => $aResList,
            'nPage' => $nPage,
            'tSearchAll' => $tSearchAll
        );
        $this->load->view('settingconfig/settingpdtscale/wPdtScaleDataTable', $aGenTable);
    }

    /**
     * Functionality : Function CallPage Server Printer Add
     * Parameters : Ajax and Function Parameter
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : String View
     * Return Type : View
     */
    public function FSvCPDSAddPage()
    {

        $nLangResort    = $this->session->userdata("tLangID");
        $nLangEdit      = $this->session->userdata("tLangEdit");


        $aData  = array(
            'FNLngID'   => $nLangEdit,

        );
        $tAPIReq        = "";
        $tMethodReq     = "GET";
        $aDataAdd = array(
            'aResult'   => array(
                'rtCode' => '99',
                'tSesAgnCode'   => $this->session->userdata("tSesUsrAgnCode"),
                'tSesAgnName'   => $this->session->userdata("tSesUsrAgnName")
            )
        );

        $this->load->view('settingconfig/settingpdtscale/wPdtScaleAdd', $aDataAdd);
    }

    /**
     * Functionality : Function CallPage Server Printer Edit
     * Parameters : Ajax and Function Parameter
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : String View
     * Return Type : View
     */
    public function FSvCPDSEditPage()
    {

        $tPDSCode       = $this->input->post('tPDSCode');
        $tAgnCode       = $this->input->post('tAgnCode');
        $nLangResort    = $this->session->userdata("tLangID");
        $nLangEdit      = $this->session->userdata("tLangEdit");


        $aData  = array(
            'FTPdsCode' => $tPDSCode,
            'FTAgnCode' => $tAgnCode,
            'FNLngID'   => $nLangEdit
        );


        $aCPDSData       = $this->Pdtscale_model->FSaMPDSSearchByID($aData);


        $aDataEdit      = array('aResult' => $aCPDSData);
        $this->load->view('settingconfig/settingpdtscale/wPdtScaleAdd', $aDataEdit);
    }

    /**
     * Functionality : Event Add Server Printer
     * Parameters : Ajax and Function Parameter
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : Status Add Event
     * Return Type : String
     */
    public function FSaCPDSAddEvent()
    {
        try {
            $aDataMaster = array(
                'tIsAutoGenCode' => $this->input->post('ocbPDSAutoGenCode'),
                'FTPdsCode'   => $this->input->post('oetPDSCode'),
                'FTAgnCode'   => $this->input->post('oetPDSAgnCode'),
                'FNPdsLenBar'   => $this->input->post('oetPDSLenBar'),
                'FNPdsLenPdt'   => $this->input->post('oetPDSLenPdt'),
                'FTPdsMatchStr'   => $this->input->post('oetPDSMatchStr'),
                'FNPdsPdtStart'   => $this->input->post('oetPDSPdtStart'),
                'FNPdsLenPri'   => $this->input->post('oetPDSLenPri'),
                'FNPdsPriDec'   => $this->input->post('oetPDSPriDec'),
                'FNPdsPriStart'   => $this->input->post('oetPDSPriStart'),
                'FNPdsLenWeight'   => $this->input->post('oetPDSLenWeight'),
                'FNPdsWeightDec'   => $this->input->post('oetPDSWeightDec'),
                'FNPdsWeightStart'   => $this->input->post('oetPDSWeightStart'),
                'FTPdsStaUse'       => (!empty($this->input->post('ocbPDSStatusUse'))) ? 1 : 2,
                'FTPdsStaChkDigit'       => (!empty($this->input->post('ocbPdsStaChkDigit'))) ? 1 : 2,
                'FTLastUpdBy'    => $this->session->userdata('tSesUsername'),
                'FDLastUpdOn'    => date('Y-m-d H:i:s'),
                'FTCreateBy'     => $this->session->userdata('tSesUsername'),
                'FDCreateOn'     => date('Y-m-d H:i:s'),

                // 'FTAgnCode'  => $this->input->post('oetCstAgnCode')
            );

            if ($aDataMaster['tIsAutoGenCode'] == '1') { // Check Auto Gen Server Printer Code?
                // Auto Gen Server Printer Code
                $aStoreParam = array(
                    "tTblName"    => 'TCNMPdtScale',
                    "tDocType"    => 0,
                    "tBchCode"    => "",
                    "tShpCode"    => "",
                    "tPosCode"    => "",
                    "dDocDate"    => date("Y-m-d")
                );
                $aAutogen   = FCNaHAUTGenDocNo($aStoreParam);
                $aDataMaster['FTPdsCode']   = $aAutogen[0]["FTXxhDocNo"];
            }

            $oCountDup  = $this->Pdtscale_model->FSoMPDSCheckDuplicate($aDataMaster['FTPdsCode']);
            $nStaDup    = $oCountDup[0]->counts;
            if ($nStaDup == 0) {
                $this->db->trans_begin();
                $aStaCPDSMaster  = $this->Pdtscale_model->FSaMPDSAddUpdateMaster($aDataMaster);
                if ($this->db->trans_status() === false) {
                    $this->db->trans_rollback();
                    $aReturn = array(
                        'nStaEvent'    => '900',
                        'tStaMessg'    => "Unsucess Add Event"
                    );
                } else {
                    $this->db->trans_commit();
                    $aReturn = array(
                        'nStaCallBack'    => 1,
                        'tCodeReturn'    => $aDataMaster['FTPdsCode'],
                        'tCodeReturn2'    => $aDataMaster['FTAgnCode'],
                        'nStaEvent'        => '1',
                        'tStaMessg'        => 'Success Add Event'
                    );
                }
            } else {
                $aReturn = array(
                    'nStaEvent'    => '801',
                    'tStaMessg'    => "Data Code Duplicate"
                );
            }
            echo json_encode($aReturn);
        } catch (Exception $Error) {
            echo $Error;
        }
    }

    /**
     * Functionality : Event Edit Server Printer
     * Parameters : Ajax and Function Parameter
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : Status Add Event
     * Return Type : String
     */
    public function FSaCPDSEditEvent()
    {
        try {
            $aDataMaster = array(
                'FTAgnCode'   => $this->input->post('oetPDSAgnCode'),
                'FTPdsCode'   => $this->input->post('oetPDSCode'),
                'FNPdsLenBar'   => $this->input->post('oetPDSLenBar'),
                'FNPdsLenPdt'   => $this->input->post('oetPDSLenPdt'),
                'FTPdsMatchStr'   => $this->input->post('oetPDSMatchStr'),
                'FNPdsPdtStart'   => $this->input->post('oetPDSPdtStart'),
                'FNPdsLenPri'   => $this->input->post('oetPDSLenPri'),
                'FNPdsPriDec'   => $this->input->post('oetPDSPriDec'),
                'FNPdsPriStart'   => $this->input->post('oetPDSPriStart'),
                'FNPdsLenWeight'   => $this->input->post('oetPDSLenWeight'),
                'FNPdsWeightDec'   => $this->input->post('oetPDSWeightDec'),
                'FNPdsWeightStart'   => $this->input->post('oetPDSWeightStart'),
                'FTPdsStaUse'       => (!empty($this->input->post('ocbPDSStatusUse'))) ? 1 : 2,
                'FTPdsStaChkDigit'       => (!empty($this->input->post('ocbPdsStaChkDigit'))) ? 1 : 2,
                'FTLastUpdBy'   => $this->session->userdata('tSesUsername'),
                'FDLastUpdOn'   => date('Y-m-d H:i:s'),
                'FTCreateBy'    => $this->session->userdata('tSesUsername'),
                'FDCreateOn'    => date('Y-m-d H:i:s'),
                'FNLngID'       => $this->session->userdata("tLangEdit"),
            );
       
            $this->db->trans_begin();
            $aStaCPDSMaster  = $this->Pdtscale_model->FSaMPDSAddUpdateMaster($aDataMaster);

            if ($this->db->trans_status() === FALSE) {
                $this->db->trans_rollback();
                $aReturn = array(
                    'nStaEvent'    => '900',
                    'tStaMessg'    => "Unsucess Add Event"
                );
            } else {
                $this->db->trans_commit();
                $aReturn = array(
                    'nStaCallBack'    => 1,
                    'tCodeReturn'    => $aDataMaster['FTPdsCode'],
                    'tCodeReturn2'    => $aDataMaster['FTAgnCode'],
                    'nStaEvent'        => '1',
                    'tStaMessg'        => 'Success Add Event'
                );
            }
            echo json_encode($aReturn);
        } catch (Exception $Error) {
            echo $Error;
        }
    }

    /**
     * Functionality : Event Delete Server Printer
     * Parameters : Ajax and Function Parameter
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : Status Delete Event
     * Return Type : String
     */
    public function FSaCPDSDeleteEvent()
    {
        $tPDSCode = $this->input->post('tPDSCode');
        $tAgnCode = $this->input->post('tAgnCode');
        $aDataMaster = array(
            'FTPdsCode' => $tPDSCode,
            'FTAgnCode' => $tAgnCode
        );

        $aResDel = $this->Pdtscale_model->FSaMPDSDel($aDataMaster);
        $aReturn = array(
            'nStaEvent' => $aResDel['rtCode'],
            'tStaMessg' => $aResDel['rtDesc']
        );
        echo json_encode($aReturn);
    }

    /**
     * Functionality : Vatrate unique check
     * Parameters : $tSelect "CPDScode"
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : Check status true or false
     * Return Type : String 
     */
    public function FStCPDSUniqueValidate($tSelect = '')
    {

        if ($this->input->is_ajax_request()) { // Request check
            if ($tSelect == 'CPDSCode') {

                $tCPDSCode = $this->input->post('tCPDSCode');
                $oCustomerGroup = $this->Pdtscale_model->FSoMCPDSCheckDuplicate($tCPDSCode);

                $tStatus = 'false';
                if ($oCustomerGroup[0]->counts > 0) { // If have record
                    $tStatus = 'true';
                }
                echo $tStatus;

                return;
            }
            echo 'Param not match.';
        } else {
            echo 'Method Not Allowed';
        }
    }

    //Functionality : Function Event Multi Delete
    //Parameters : Ajax Function Delete Server Printer
    //Creator : 14/06/2018 wasin
    //Last Modified : -
    //Return : Status Event Delete And Status Call Back Event
    //Return Type : object
    public function FSoCPDSDeleteMulti()
    {
        $tPDSCode = $this->input->post('tPDSCode');
        $tAgnCode = $this->input->post('tAgnCode');
        $aPDSCode = json_decode($tPDSCode);
        $aAgnCode = json_decode($tAgnCode);
        foreach ($aPDSCode as $nKey => $oPDSCode) {
            $aCPDS = ['FTPdsCode' => $oPDSCode , 'FTAgnCode' => $aAgnCode[$nKey] ];
            $this->Pdtscale_model->FSaMPDSDel($aCPDS);
        }
        echo json_encode($aCPDSCode);
    }

    /**
     * Functionality : Delete vat rate
     * Parameters : -
     * Creator : 20/12/2021 Worakorn
     * Last Modified : -
     * Return : Vat code
     * Return Type : Object
     */
    public function FSoCPDSDelete()
    {
        $tPDSCode = $this->input->post('tPDSCode');
        $tAgnCode = $this->input->post('tAgnCode');
        $aDataMaster = array(
            'FTPdsCode' => $tPDSCode,
            'FTAgnCode' => $tAgnCode
        );
        $aResDel = $this->Pdtscale_model->FSaMPDSDel($aDataMaster);
        $aReturn = array(
            'nStaEvent' => $aResDel['rtCode'],
            'tStaMessg' => $aResDel['rtDesc']
        );
        echo json_encode($aReturn);
    }
}
