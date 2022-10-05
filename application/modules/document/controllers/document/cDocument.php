<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );
class cDocument extends MX_Controller {

    public function __construct() {

        parent::__construct ();
        $this->load->helper('url');

    }

    //Function : Get Image Product
    public function FMvCDOCGetPdtImg(){

        $tPdtCode = $this->input->post('tPdtCode');

        $aDataSearch = array(
            'tPdtCode' => $this->input->post('tPdtCode'),
        );

        $aPdtImgList =  FCNxHDOCGetPdtImg($aDataSearch);
        
        $aData = array(
            'aPdtImgList'  =>  $aPdtImgList,
        );

        $this->load->view('document/document/wDocumentPdtImgList',$aData);

    }

     //Function : อัพเดทรหัสสาขา DT กรณีเปลี่ยนสาขา
    public function FMvCDOCCNUpdBchEntChg(){
        try{

          $tDocBchCode =  $this->input->post('rtDocBchCode');
          $tDocNo      =  $this->input->post('rtDocNo');
          $tDocKey     =  $this->input->post('rtDocKey');
          $tSessionID  =  $this->session->userdata('tSesSessionID');


          $this->db->set('FTBchCode',$tDocBchCode)
          ->where('FTXthDocNo',$tDocNo)
          ->where('FTXthDocKey',$tDocKey)
          ->where('FTSessionID',$tSessionID)
          ->update('TCNTDocDTTmp');

          $this->db->set('FTBchCode',$tDocBchCode)
          ->where('FTXshDocNo',$tDocNo)
          ->where('FTXthDocKey',$tDocKey)
          ->where('FTSessionID',$tSessionID)
          ->update('TCNTDocDTFhnTmp');

          $this->db->set('FTBchCode',$tDocBchCode)
          ->where('FTXthDocNo',$tDocNo)
          ->where('FTSessionID',$tSessionID)
          ->update('TCNTDocDTDisTmp');

          $this->db->set('FTBchCode',$tDocBchCode)
          ->where('FTXthDocNo',$tDocNo)
          ->where('FTSessionID',$tSessionID)
          ->update('TCNTDocHDDisTmp');

          $aReturnData = array(
            'nStaEvent' => '1',
            'tStaMessg' => 'Success'
          );
        } catch (Exception $Error) {
            $aReturnData = array(
                'nStaEvent' => '500',
                'tStaMessg' => $Error->getMessage()
            );
        }
        echo json_encode($aReturnData);
    }


}