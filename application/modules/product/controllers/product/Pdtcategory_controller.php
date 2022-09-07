<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

class Pdtcategory_controller extends MX_Controller {

    public function __construct() {
        parent::__construct ();
        date_default_timezone_set("Asia/Bangkok");
        $this->load->model('company/branch/mBranch');
        $this->load->model('product/product/Pdtcategory_model');
    }

    //Functionality : Function Call Page Main
	//Parameters : From Ajax File PdtFashion
	//Creator : 27/04/2021 Nattakit
	//Last Modified : -
	//Return : String View
	//Return Type : View
    public function FSvCCGYPageFrom(){

        // Get PdtCode
        $tPdtCode = $this->input->post('tPdtCode');

        $nLangResort        = $this->session->userdata("tLangID");
        $nLangEdit          = $this->session->userdata("tLangEdit");

        //CheckID
        $aData = array(
            'FTPdtCode' => $this->input->post('tPdtCode'),
            'FNLngID'   => $nLangEdit
        );
        // CheckIDPdtCode
        $aMasterPdt  =  $this->Pdtcategory_model->FSaMCGYFGetMaster($aData);

        $aGetDataPdtCode    = array(
            'tPdtCode'       => $tPdtCode,
        );

        $aDataAdd  = array(
            'aMasterPdt'           => $aMasterPdt,
            'aGetDataPdtCode'    => $aGetDataPdtCode,
        );

        $this->load->view('product/product/category/wCategoryPageFrom',$aDataAdd);
    }

    
    //Functionality : Function Add PdtFashion
    //Parameters : From Ajax File PdtFashion
    //Creator : 27/04/2021 Nattakit
    //Last Modified : -
    //Return : Status Add Event
    //Return Type : array
    public function FSaCCGYAddEditEvent(){
        try{
    
            $nLangEdit      = $this->session->userdata("tLangEdit");
       
    

            $aDataMaster  = array(
                'FTPdtCode'             => $this->input->post('oetCgyPdtCode'),
                'FTDepCode'             => $this->input->post('oetCgyPdtDepartCode'),
                'FTClsCode'             => $this->input->post('oetCgyPdtClassCode'),
                'FTSclCode'             => $this->input->post('oetCgyPdtSubClassCode'),
                'FTPgpCode'           => $this->input->post('oetCgyPdtGroupCode'),
                'FTCmlCode'           => $this->input->post('oetCgyPdtComLinesCode'),
                'FTFhnModNo'            => $this->input->post('oetCgyPdtModelNo'),
                'FTFhnGender'           => $this->input->post('ocmCgyPdtGender'),
                'FDLastUpdOn'           => date('Y-m-d H:i:s'),
                'FTLastUpdBy'           => $this->session->userdata('tSesUsername'),
                'FDCreateOn'            => date('Y-m-d H:i:s'),
                'FTCreateBy'            => $this->session->userdata('tSesUsername'),
            );

            $this->db->trans_begin();
            
            $aResult = $this->Pdtcategory_model->FSaMCGYAddUpdateMaster($aDataMaster);

            if($this->db->trans_status() === false){
                $this->db->trans_rollback();
                $aReturn = array(
                    'nStaEvent'    => '900',
                    'tStaMessg'    => "Unsucess Success Add Data"
                );
            }else{
                $this->db->trans_commit();
                $aReturn = array(
                    'nStaCallBack'	=> $this->session->userdata('tBtnSaveStaActive'),
                    'nStaEvent'	    => '1',
                    'tStaMessg'		=> 'Success Add Data',
                );
            }
            echo json_encode($aReturn);
        }catch(Exception $Error){
            echo $Error;
        }
    }



    //Functionality : Function Add PdtFashion
    //Parameters : From Ajax File PdtFashion
    //Creator : 27/04/2021 Nattakit
    //Last Modified : -
    //Return : Status Add Event
    //Return Type : array
    public function FSvCCGYCheckModelNo(){

        $tPdtCode =  $this->input->post('tPdtCode');
        $tFhnPdtModelNo =  $this->input->post('tFhnPdtModelNo');
        $aResult = $this->Pdtcategory_model->FSvMCGYCheckModelNo($tFhnPdtModelNo,$tPdtCode);
        echo json_encode($aResult);
    }

}