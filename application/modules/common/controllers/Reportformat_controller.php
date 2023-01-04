<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

class Reportformat_controller extends MX_Controller {


    public function __construct(){
        parent::__construct ();
        $this->load->model('common/Reportformat_model');
    }


    // Functionality : Function Data Table
    // Parameters : Ajax and Function Parameter
    // Creator : 16/06/2021 Nattakit
    // LastUpdate: -
    // Return : Object Data Table
    // Return Type : object
    public function FCNaCRFTCallDataTable(){
        
        $tRtfCode    =  $this->input->post('tRtfCode');
        $tBchCode      =  $this->input->post('tBchCode');
        $tIframeNameID      =  $this->input->post('tIframeNameID');
        
        $aDataConfigView = array(
            'tRtfCode'   => $tRtfCode,
            'tBchCode'     => $tBchCode,
            'tIframeNameID' => $tIframeNameID,
        );


        $aResult = $this->Reportformat_model->FCNaMRFTCallDataTable($aDataConfigView); //ดึงข้อมูลไฟลจาก Temp
    
        if($aResult['rtCode']=='1' || $aResult['rtCode']=='2'){
            
            if(!empty($aResult['raItems'])){
                foreach($aResult['raItems'] AS $nK => $aData){

                if($aData['FTAgnCode']!=''){
                        $tHostFile = $aData['FTRptFileName'];
                        $oResult = $this->FSaCFRMCallAPIGetFile($tHostFile);
                
                        $tAgnCode = $aData['FTAgnCode'];
                        $tRfuCode = $aData['FTRfuCode'];
                        $tRfsPath = $aData['FTRptPath'];
                        $tRfsFileName = $aData['FTRfsRptFileName'];
                        
                        $tDirectoryPath = "$tRfsPath/reports/$tAgnCode";
                        if (!is_dir($tDirectoryPath)) {
                            mkdir($tDirectoryPath);
                        }
                
                        $tFile_name= $tDirectoryPath."/".$tRfsFileName."_".$tRfuCode.".mrt";
                        $oHandle = fopen($tFile_name, 'w');
                        rewind($oHandle);
                        fwrite($oHandle, $oResult);
                        fclose($oHandle);
                        $tPathFile = base_url().$tFile_name;
                        $aResult['raItems'][$nK]['FTRptFileName'] = $tPathFile;
                }
                
                }
            }

            }


        if($aResult['rtCode']=='2' || $tIframeNameID =='oifPrint'){
            $aDataConfigView['aItems'] = $aResult;
            $tHTMLDataTable = $this->load->view('common/wReportFormatDataTable',$aDataConfigView,true);
            $aResult['tHTMLDataTable'] = $tHTMLDataTable;
        }

        echo  json_encode($aResult);

    }

    //Functionality : Event Delete Forms
    //Parameters : Ajax jForms()
    //Creator : 28/05/2018 wasin
    //Last Modified : -
    //Return : Status Delete Event
    //Return Type : String
    public function FSaCFRMCallAPIGetFile($tHostFile){
        try { 
                // $tHostFile = $aFrmData['raItems']['rtRfuFileName'];
                $oCh = curl_init();
                curl_setopt($oCh, CURLOPT_URL, $tHostFile);
                curl_setopt($oCh, CURLOPT_VERBOSE, 1);
                curl_setopt($oCh, CURLOPT_RETURNTRANSFER, 1);
                curl_setopt($oCh, CURLOPT_AUTOREFERER, false);
                curl_setopt($oCh, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
                curl_setopt($oCh, CURLOPT_HEADER, 0);
                curl_setopt($oCh, CURLOPT_SSL_VERIFYPEER, false);
                $oResult = curl_exec($oCh);
                curl_close($oCh);
                return $oResult;
        } catch (Exception $e) {
            return array('error' => $e);
        }
    }

}