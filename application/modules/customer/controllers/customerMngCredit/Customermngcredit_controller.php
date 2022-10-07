<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

class Customermngcredit_controller extends MX_Controller {

    public function __construct(){
        parent::__construct ();
        $this->load->model('customer/customerMngCredit/Customermngcredit_model');
        date_default_timezone_set("Asia/Bangkok");
    }

    public function index($nMcrBrowseType, $tMcrBrowseOption){
        $aData['nBrowseType']   = $nMcrBrowseType;
        $aData['tBrowseOption'] = $tMcrBrowseOption;
		$aData['aAlwEvent']     = FCNaHCheckAlwFunc('cstMngCredit/0/0');        // Controle Event
        $aData['vBtnSave']      = FCNaHBtnSaveActiveHTML('cstMngCredit/0/0');   // Load Html ของปุ่ม Save ที่เก็บ Session ปัจจุบัน
        $this->load->view ('customer/customerMngCredit/wCstMngCredit',$aData);
    }

    public function FSvCMCRListPage(){
        $aData['aAlwEvent'] = FCNaHCheckAlwFunc('cstMngCredit/0/0');
        $this->load->view('customer/customerMngCredit/wCstMngCreditList',$aData);    
    }

    //Functionality : Call Page Data List
    //Parameters : Ajax jReason()
    //Creator : 28/05/2021 wasin
    //Return : String View
    //Return Type : View
    public function FSvCMCRDataList(){
        $nPage      = $this->input->post('nPageCurrent');
        $tSearchAll = $this->input->post('tSearchAll');        
        if($nPage == '' || $nPage == null){$nPage = 1;}else{$nPage = $this->input->post('nPageCurrent');}
        if(!$tSearchAll){$tSearchAll='';}
        //Lang ภาษา
	    $nLangEdit  = $this->session->userdata("tLangEdit");
        $aData  = array(
            'nPage'         => $nPage,
            'nRow'          => 10,
            'FNLngID'       => $nLangEdit,
            'tSearchAll'    => $tSearchAll,
            'tSesAgnCode'   => $this->session->userdata("tSesUsrAgnCode"),
        );
        $aMCRList   = $this->Customermngcredit_model->FSaMMCRDataList($aData);
        $aAlwEvent  = FCNaHCheckAlwFunc('cstMngCredit/0/0');
        $aGenTable  = array(
            'aAlwEvent'         => $aAlwEvent,
            'aDataList'         => $aMCRList,
            'nPage'             => $nPage,
            'tSearchAll'        => $tSearchAll,
            'nOptDecimalShow'   => get_cookie('tOptDecimalShow')
        );
        $this->load->view('customer/customerMngCredit/wCstMngCreditDataTable',$aGenTable);
    }

    // Functionality : Call Page Edit Customer Credit
    // Parameters : Ajax jReason()
    // Creator : 28/05/2021 wasin
    // Return : String View
    // Return Type : View
    public function FSvCMCREditPage(){
        $aData  = [
            'FTCstCode' => $this->input->post('tCstCode'),
            'FNLngID'   => $this->session->userdata("tLangEdit")
        ];
        $aDataCst   = $this->Customermngcredit_model->FSaMMCRGetDataCustomerByID($aData);
        $this->load->view('customer/customerMngCredit/wCstMngCreditFrom',array(
            'aDataCst'  => $aDataCst,
            'nOptDecimalShow'   => get_cookie('tOptDecimalShow')
        ));
    }

    // Functionality : Even Update Customer Credit
    // Parameters : Ajax jReason()
    // Creator : 28/05/2021 wasin
    // Return : String Json
    // Return Type : Json
    public function FSaCMCRAddOrUpdEvent(){
        $aDataSend      = $this->input->post();
        $aDataMaster    = [
            'FTCstCode'     => $aDataSend['oetMCRCstCode'],
            'FCCstCrLimit'  => floatval(str_replace(',','',$aDataSend['oetMCRCstCrLimit'])),
            'FCCstCrBuffer' => floatval(str_replace(',','',$aDataSend['oetMCRCstCrBuffer'])),
            'FCCstCrBalExt' => floatval(str_replace(',','',$aDataSend['oetMCRCstCrBalExt'])),
        ];
        $this->db->trans_begin();
        // Check Type Update Or Insert 
        if($aDataSend['ohdMCRStaChkCR'] == '1'){
            // Update Customer Credit
            $this->Customermngcredit_model->FSaMMCRUpdCstCredit($aDataMaster);
        }else{
            // Insert Customer Credit
            $this->Customermngcredit_model->FSaMMCRInsCstCredit($aDataMaster);
        }

        if ($this->db->trans_status() === FALSE) {
            $this->db->trans_rollback();
            $aReturn    = array(
                'nStaEvent' => '900',
                'tStaMessg' => "Error Unsucess Add / Update Customer Credit.",
            );
        }else{
            $this->db->trans_commit();
            $aData  = array('ptCstCode'=>$aDataSend['oetMCRCstCode']);
            // Send MQ Process Customer Credit
            $aMQParams  = [
                "queueName"     => "CN_QTask",
                "tVhostType"    => "P",
                "params"        => [
                    "ptFunction"    => "CLEARCREDIT",
                    "ptSource"      => "AdaStoreBack",
                    "ptDest"        => "MQReceivePrc",
                    "ptFilter"      => "",
                    "ptData"        => json_encode($aData)
                ]
            ];
            FCNxCallRabbitMQ($aMQParams);
            $aReturn    = array(
                'nStaCallBack'  => $this->session->userdata('tBtnSaveStaActive'),
                'tCodeReturn'   => $aDataMaster['FTCstCode'],
                'nStaEvent'     => '1',
                'tStaMessg'     => 'Success Add / Update Customer Credit.',
            );
        }
        echo json_encode($aReturn);
    }

    // Functionality : Event Update Data Inline
    // Parameters : Ajax jReason()
    // Creator : 15/07/2022 wasin
    // Return : String Json
    // Return Type : Json
    public function FSaCMCREventUpdInline(){
        $aDataSend      = $this->input->post();
        $aDataMaster    = [
            'FTCstCode'     => $aDataSend['ptCstCode'],
            'FCCstCrLimit'  => floatval(str_replace(',','',$aDataSend['ptCstCrLimit'])),
            'FCCstCrBuffer' => floatval(str_replace(',','',$aDataSend['ptCstCrBuffer'])),
            'FCCstCrBalExt' => floatval(str_replace(',','',$aDataSend['ptCstCrBalExt'])),
            'FTCstStaApv'   => $aDataSend['ptCstCrStaApvChk'],
        ];
        $aDataStaEvent  = $this->Customermngcredit_model->FSaMMCREventAddOrUpdCstCredit($aDataMaster);
        $aDataReturn    = array_merge($aDataSend,$aDataStaEvent);
        echo json_encode($aDataReturn);
    }

    // Functionality : Event Cut Off Customer Credit
    // Parameters : Ajax jReason()
    // Creator : 24/07/2021 wasin
    // Return : String Json
    // Return Type : Json
    public function FsaCMCREventCutOffCstCr(){
        $aDataSend      = $this->input->post('tIDCode');
        $nCountData     = count($aDataSend);
        $nCheckStaLoop  = 0;
        if($nCountData > 0){
            // Loop Send MQ Process Customer Credit
            foreach($aDataSend AS $nKey => $tValue){
                // Data Send MQ
                $aData      = array('ptCstCode'=>$tValue);
                $aMQParams  = [
                    "queueName"     => "CN_QTask",
                    "tVhostType"    => "P",
                    "params"        => [
                        "ptFunction"    => "CLEARCREDIT",
                        "ptSource"      => "AdaStoreBack",
                        "ptDest"        => "MQReceivePrc",
                        "ptFilter"      => "",
                        "ptData"        => json_encode($aData)
                    ]
                ];
                FCNxCallRabbitMQ($aMQParams);
                $nCheckStaLoop++;
            }
            if($nCheckStaLoop == $nCountData){
                $aReturn    = [
                    'nStaEvent' => '1',
                    'tStaMessg' => 'Success Send MQ Customer Credit.',
                ];
            }else{
                $aReturn    = [
                    'nStaEvent' => '800',
                    'tStaMessg' => 'Error Send MQ Customer Credit.',
                ];
            }
            echo json_encode($aReturn);
        }
    }














}