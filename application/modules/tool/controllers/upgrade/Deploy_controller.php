<?php 
defined('BASEPATH') or exit('No direct script access allowed');
use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Message\AMQPMessage;
class Deploy_controller extends MX_Controller {

    /**
     * ภาษาที่เกี่ยวข้อง
     * @var array
    */
    public $aTextLang   = [];

    public function __construct() {
        $this->load->model('tool/upgrade/Deploy_model');
        parent::__construct();
    }

        // Functionality: Index DashBoard
    // Parameters: Ajax and Function Parameter
    // Creator: 14/01/2020 wasin(Yoshi)
    // Return: None
    // ReturnType: none
    public function index(){

        $this->load->view('tool/upgrade/deploy/wDeploy');
    }
    
    // Functionality : ฟังก์ชั่น ดึงข้อมูลจากฐานข้อมูล เมื่อแรกเข้าสู่หน้า
    // Parameters : Ajax and Function Parameter
    // Creator : 14/01/2019 wasin
    // Return : String View
    // Return Type : View
    public function FSvCDPYMainPage(){
    
        $aDataConfigView    =  [
            'nOptDecimalShow'   => FCNxHGetOptionDecimalShow(),
            'nOptDecimalSave'   => FCNxHGetOptionDecimalSave(),
            'aTextLang'         => $this->aTextLang,
        ];

        $this->load->view('tool/upgrade/deploy/wDeployMain',$aDataConfigView);
    }



    public function FSvCDPYDataTable(){
        try{
            $aAdvanceSearch     = $this->input->post('oAdvanceSearch');
            $nPage              = $this->input->post('nPageCurrent');

            // Controle Event
            $aAlwEvent          = FCNaHCheckAlwFunc('dcmAST/0/0');

            // Get Option Show Decimal
            $nOptDecimalShow    = FCNxHGetOptionDecimalShow();

            // Page Current 
            if($nPage == '' || $nPage == null){$nPage = 1;}else{$nPage = $this->input->post('nPageCurrent');}

            // Lang ภาษา
            $nLangEdit          = $this->session->userdata("tLangEdit");

            // Data Conditon Get Data Document
            $aDataCondition  = array(
                'FNLngID'           => $nLangEdit,
                'nPage'             => $nPage,
                'nRow'              => 10,
                'aAdvanceSearch'    => $aAdvanceSearch
            );

            $aDataList  = $this->Deploy_model->FSaMDPYDataTable($aDataCondition);

            $aConfigView    = array(
                'nPage'             => $nPage,
                'nOptDecimalShow'   => $nOptDecimalShow,
                'aAlwEvent'         => $aAlwEvent,
                'aDataList'         => $aDataList,
            );

            $tASTViewDataTable = $this->load->view('tool/upgrade/deploy/wDeployDataTable',$aConfigView,true);
            $aReturnData = array(
                'tViewDataTable'    => $tASTViewDataTable,
                'nStaEvent'         => '1',
                'tStaMessg'         => 'Success'
            );
        }catch(Exception $Error){
            $aReturnData    = array(
                'nStaEvent' => '500',
                'tStaMessg' => $Error->getMessage()
            );
        }
        echo json_encode($aReturnData);
    }



    // Functionality : Function Call Page Add Adjust Stock
    // Parameters : Ajax and Function Parameter
    // Creator : 07/06/2019 wasin (Yoshi)
    // Return : Object View Page Add
    // ReturnType : object
    public function FSvCDPYPageAdd(){
        try{
            // Clear Product List IN Doc Temp
            $aConfigView = array(
                'aDataDocHD'        => array('rtCode'=>'99'),
                'aDataDocDT'        => array('rtCode'=>'99'),
                'aDataDocHDBch'     => array('rtCode'=>'99'),
            );
            $tDPYViewPageAdd    = $this->load->view('tool/upgrade/deploy/wDeployAdd',$aConfigView,true);
            $aReturnData        = array(
                'tDPYViewPageAdd'   => $tDPYViewPageAdd,
                'tUsrLevel'         => $this->session->userdata("tSesUsrLevel"),
                'nStaEvent'         => '1',
                'tStaMessg'         => 'Success'
            );
        }catch(Exception $Error){
            $aReturnData = array(
                'nStaEvent' => '500',
                'tStaMessg' => $Error->getMessage()
            );
        }
        echo json_encode($aReturnData);
    }

    // Functionality : ฟังก์ชั่น MQ Request Sale Data
    // Parameters : Ajax and Function Parameter
    // Creator : 20/04/2020 Nale
    // Return : String View
    // Return Type : View
    public function FSvCRPNCallMQPrc(){
        try{

            $tRpRnDocUUID = $this->input->post('tRpRnDocUUID');
            if($tRpRnDocUUID!=''){
                $aReults = $this->Repairrunningbill_model->FSaMRPNUpdateUUIDToGTRegen($tRpRnDocUUID);

                if($aReults['rtCode']=='1'){

                    $tRpRnDocUUID = $this->input->post('tRpRnDocUUID');
                    $aMQParams = [
                        "queueName" => "Tool_RunningBillServer",
                        "params"    => [
                            "ptUUID"  => $tRpRnDocUUID
                        ]
                    ];
                    $this->FSxCDPYRabbitMQRequest($aMQParams);

                    $aReturn = array(
                        'nStaEvent'    => '1',
                        'tStaMessg'    => 'ok'
                    );
                }else{
                    $aReturn = array(
                        'nStaEvent'    => '99',
                        'tStaMessg'    => 'Try to try again.'
                    );
                }
            }else{
                $aReturn = array(
                    'nStaEvent'    => '99',
                    'tStaMessg'    => 'UUID Not Found'
                );
            }

            echo json_encode($aReturn);
        }catch(Exception $Error){
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => $Error->getMessage()
            );
            echo json_encode($aReturn);
            return;
        }

    }



    public function FSxCDPYRabbitMQRequest($paParams){

    $tQueueName = $paParams['queueName'];
    $aParams = $paParams['params'];
    // $aParams['ptConnStr'] = DB_CONNECT;
    $aParams['ptConnStr'] = 'Data Source='.DATABASE_IP.';Initial Catalog='.BASE_DATABASE.';User ID='.DATABASE_USERNAME.';Password='.DATABASE_PASSWORD.';Connection Timeout=30;Connection Lifetime=0;Min Pool Size=30;Max Pool Size=100;Pooling=true;';
    $tExchange = '';

    $oConnection = new AMQPStreamConnection(MQ_Sale_HOST, MQ_Sale_PORT, MQ_Sale_USER, MQ_Sale_PASS, MQ_Sale_VHOST);
    $oChannel = $oConnection->channel();
    $oChannel->queue_declare($tQueueName, false, true, false, false);
    $oMessage = new AMQPMessage(json_encode($aParams));
    $oChannel->basic_publish($oMessage, "", $tQueueName);
    $oChannel->close();
    $oConnection->close();
        return 1; /** Success */
    }



    function FSxCDPYRabbitMQDeclareQName($paParams){

        // $tPrefixQueueName = $paParams['prefixQueueName'];
        // $tQueueName = $tPrefixQueueName;
        
        // $oConnection = new AMQPStreamConnection(HOST, PORT, USER, PASS, VHOST);
        // $oChannel = $oConnection->channel();
        // $oChannel->queue_declare($tQueueName, false, true, false, false);
        // $oChannel->close();
        // $oConnection->close();

        $tQueueName = $paParams['prefixQueueName'];
        $aParams = $paParams['params'];
        $aParams['ptConnStr'] = DB_CONNECT;
        $tExchange = $paParams['exchangeName'];
        
        $oConnection = new AMQPStreamConnection(MQ_Sale_HOST, MQ_Sale_PORT, MQ_Sale_USER, MQ_Sale_PASS, MQ_Sale_VHOST);
        $oChannel = $oConnection->channel();
        $oChannel->queue_declare($tQueueName, false, true, false, false);
        $oChannel->exchange_declare($tExchange, 'fanout', false, false, false);
        $oChannel->queue_bind($tQueueName, $tExchange);
        // $oMessage = new AMQPMessage(json_encode($aParams));
        // $oChannel->basic_publish($oMessage, $tExchange);

        // echo "[x] Sent $tQueueName Success";

        $oChannel->close();
        $oConnection->close();

        return 1; /** Success */
    }


    function FSxCINMRabbitMQDeleteQName($paParams) {

        $tPrefixQueueName = $paParams['prefixQueueName'];
        $tQueueName = $tPrefixQueueName;
        // $oConnection = new AMQPStreamConnection('172.16.30.28', '5672', 'admin', '1234', 'Pandora_PPT1');
        $oConnection = new AMQPStreamConnection(MQ_Sale_HOST, MQ_Sale_PORT, MQ_Sale_USER, MQ_Sale_PASS, MQ_Sale_VHOST);
        $oChannel = $oConnection->channel();
        $oChannel->queue_delete($tQueueName);
        $oChannel->close();
        $oConnection->close();
        return 1; /** Success */
    
        
    }

    // Functionality : Function Call Page Add Adjust Stock
    // Parameters : Ajax and Function Parameter
    // Creator : 07/06/2019 wasin (Yoshi)
    // Return : Object View Page Add
    // ReturnType : object
    public function FSvCDPYEventAdd(){
        try{

      
            $ocbDPYStaAutoGenCode = $this->input->post('ocbDPYStaAutoGenCode');
            $tDPYDocNo = $this->input->post('oetDPYDocNo');
            $dDPYDocDate = $this->input->post('oetDPYDocDate')." ".$this->input->post('oetDPYDocTime');
            $dDPYActDate = $this->input->post('oetDPYActDate')." ".$this->input->post('oetDPYActTime');

            $aDPTAppCode = $this->input->post('oetDPTAppCode');
            $aDPTAppVersion = $this->input->post('oetDPTAppVersion');
            $aDPTAppPath = $this->input->post('oetDPTAppPath');

            $aRddBchModalType = $this->input->post('ohdRddBchModalType');
            $aDPYAgnCode = $this->input->post('ohdDPYAgnCode');
            $aDPYBchCode = $this->input->post('ohdDPYBchCode');
            $aDPYPosCode = $this->input->post('ohdDPYPosCode');

            $tDPYDepName = $this->input->post('oetDPYDepName');
            $tDPYZipUrl = $this->input->post('oetDPYZipUrl');
            $tDPYJsonUrl = $this->input->post('oetDPYJsonUrl');
            $tDPYRemark = $this->input->post('oetDPYRemark');

            $tXdhStaForce = $this->input->post('ocbXdhStaForce');
   
            
            $nLangEdit      = $this->session->userdata("tLangEdit");

            $tUserLogin     = $this->session->userdata('tSesUsername');
            $dDateTime   = date('Y-m-d H:i:s');
            $aDataDepHD = array(
                'FTXdhDocNo' => $tDPYDocNo,
                'FDXdhDocDate' => $dDPYDocDate,
                'FDXdhActDate' => $dDPYActDate,
                'FTXdhDepName' => $tDPYDepName,
                'FTXdhDepRmk' => $tDPYRemark,
                'FTXdhStaDoc' => '1',
                'FTXdhStaDep' => '',
                'FTXdhStaPreDep' => '2',
                'FTXdhUsrApv' => '',
                'FTXdhUsrApvPreDep' => '',
                'FTXdhZipUrl' => $tDPYZipUrl,
                'FTXdhJsonUrl' => $tDPYJsonUrl,
                'FTXdhStaForce' => $tXdhStaForce,
                'FDLastUpdOn' => $dDateTime,
                'FTLastUpdBy' => $tUserLogin,
                'FDCreateOn' => $dDateTime,
                'FTCreateBy' => $tUserLogin,
                'FNLngID' => $nLangEdit
            );

            if($ocbDPYStaAutoGenCode==1){
                $dDateNow =  date('Y-m-d');
                $dDate = new DateTime($dDateNow);
                $tWeek = $dDate->format("W");
                $aDataDepHD['FTXdhDocNo'] =  date('yM').$tWeek.rand(100,999);
            }


            $aDataConditionBch = array(
                'aRddBchModalType' => $aRddBchModalType,
                'aDPYAgnCode' => $aDPYAgnCode,
                'aDPYBchCode' => $aDPYBchCode,
                'aDPYPosCode' => $aDPYPosCode,
            );

            $aDataDT = array(
                'aDPTAppCode' => $aDPTAppCode,
                'aDPTAppVersion' => $aDPTAppVersion,
                'aDPTAppPath' => $aDPTAppPath,
            );
            // 22Feb06129
            // echo '<pre>';
            //         print_r($aDataDepHD);
            // echo '</pre>';
            // die();
            $this->db->trans_begin();
            $aResult = $this->Deploy_model->FSaMDPYAdd($aDataDepHD);
            if($aResult['rtCode']=='1'){
                $this->Deploy_model->FSaMRDPYAddUpdateDT($aDataDT,$aDataDepHD);
                $this->Deploy_model->FSaMRDPYAddUpdateConditionBch($aDataConditionBch,$aDataDepHD);
            if($this->db->trans_status() === FALSE){
                $this->db->trans_rollback();
                $aReturn = array(
                    'nStaEvent'     => '900',
                    'tStaMessg'     => "Unsuccess Add"
                );
            }else{
                $this->db->trans_commit();
                $aReturn = array(
                    'tCodeReturn'   => $aDataDepHD['FTXdhDocNo'],
                    'nStaEvent'     => '1',
                    'tStaMessg'     => 'Success Add'
                );
            }
        }else{
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'     => $aResult['rtCode'],
                'tStaMessg'     =>  $aResult['rtDesc']
            ); 
        }
            echo json_encode($aReturn);

        }catch(Exception $Error){
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => $Error->getMessage()
            );
            echo json_encode($aReturn);
        }

    }


 



    // Functionality : Function Call Page Add Adjust Stock
    // Parameters : Ajax and Function Parameter
    // Creator : 07/06/2019 wasin (Yoshi)
    // Return : Object View Page Add
    // ReturnType : object
    public function FSvCDPYPageEdit(){
        try{

            $ptXthDocNo = $this->input->post('ptXthDocNo');
            // Clear Product List IN Doc Temp

            // echo $ptXthDocNo;
            // die();

            $aDataDocHD    = $this->Deploy_model->FSaMDPYGetHD($ptXthDocNo);
            $aDataDocDT    = $this->Deploy_model->FSaMDPYGetDT($ptXthDocNo);
            $aDataDocHDBch = $this->Deploy_model->FSaMDPYGetHDBch($ptXthDocNo);
            $aConfigView = array(
                'aDataDocHD'        => $aDataDocHD,
                'aDataDocDT'        => $aDataDocDT,
                'aDataDocHDBch'     => $aDataDocHDBch,
            );
            $tDPYViewPageAdd    = $this->load->view('tool/upgrade/deploy/wDeployAdd',$aConfigView,true);
            $aReturnData        = array(
                'tDPYViewPageAdd'   => $tDPYViewPageAdd,
                'tUsrLevel'         => $this->session->userdata("tSesUsrLevel"),
                'nStaEvent'         => '1',
                'tStaMessg'         => 'Success'
            );
        }catch(Exception $Error){
            $aReturnData = array(
                'nStaEvent' => '500',
                'tStaMessg' => $Error->getMessage()
            );
        }
        echo json_encode($aReturnData);
    }



    
    // Functionality : Function Call Page Add Adjust Stock
    // Parameters : Ajax and Function Parameter
    // Creator : 07/06/2019 wasin (Yoshi)
    // Return : Object View Page Add
    // ReturnType : object
    public function FSvCDPYEventEdit(){
        try{

      
            $ocbDPYStaAutoGenCode = $this->input->post('ocbDPYStaAutoGenCode');
            $tDPYDocNo = $this->input->post('oetDPYDocNo');
            $dDPYDocDate = $this->input->post('oetDPYDocDate')." ".$this->input->post('oetDPYDocTime');
            $dDPYActDate = $this->input->post('oetDPYActDate')." ".$this->input->post('oetDPYActTime');

            $aDPTAppCode = $this->input->post('oetDPTAppCode');
            $aDPTAppVersion = $this->input->post('oetDPTAppVersion');
            $aDPTAppPath = $this->input->post('oetDPTAppPath');

            $aRddBchModalType = $this->input->post('ohdRddBchModalType');
            $aDPYAgnCode = $this->input->post('ohdDPYAgnCode');
            $aDPYBchCode = $this->input->post('ohdDPYBchCode');
            $aDPYPosCode = $this->input->post('ohdDPYPosCode');

            $tDPYDepName = $this->input->post('oetDPYDepName');
            $tDPYZipUrl = $this->input->post('oetDPYZipUrl');
            $tDPYJsonUrl = $this->input->post('oetDPYJsonUrl');
            $tDPYRemark = $this->input->post('oetDPYRemark');
            $tXdhStaForce = $this->input->post('ocbXdhStaForce');

            $nLangEdit      = $this->session->userdata("tLangEdit");

            $tUserLogin     = $this->session->userdata('tSesUsername');
            $dDateTime   = date('Y-m-d H:i:s');
            $aDataDepHD = array(
                'FTXdhDocNo' => $tDPYDocNo,
                'FDXdhDocDate' => $dDPYDocDate,
                'FDXdhActDate' => $dDPYActDate,
                'FTXdhDepName' => $tDPYDepName,
                'FTXdhDepRmk' => $tDPYRemark,
                'FTXdhStaDoc' => '1',
                'FTXdhStaDep' => '2',
                'FTXdhStaPreDep' => '2',
                'FTXdhUsrApv' => '',
                'FTXdhUsrApvPreDep' => '',
                'FTXdhZipUrl' => $tDPYZipUrl,
                'FTXdhJsonUrl' => $tDPYJsonUrl,
                'FTXdhStaForce' => $tXdhStaForce,
                'FDLastUpdOn' => $dDateTime,
                'FTLastUpdBy' => $tUserLogin,
                'FDCreateOn' => $dDateTime,
                'FTCreateBy' => $tUserLogin,
                'FNLngID' => $nLangEdit
            );

            $aDataConditionBch = array(
                'aRddBchModalType' => $aRddBchModalType,
                'aDPYAgnCode' => $aDPYAgnCode,
                'aDPYBchCode' => $aDPYBchCode,
                'aDPYPosCode' => $aDPYPosCode,
            );

            $aDataDT = array(
                'aDPTAppCode' => $aDPTAppCode,
                'aDPTAppVersion' => $aDPTAppVersion,
                'aDPTAppPath' => $aDPTAppPath,
            );
            // 22Feb06129
            // echo '<pre>';
            //         print_r($aDataDepHD);
            // echo '</pre>';
            // die();
            $this->db->trans_begin();
            $aResult = $this->Deploy_model->FSaMDPYUpdate($aDataDepHD);
            $this->Deploy_model->FSaMRDPYAddUpdateDT($aDataDT,$aDataDepHD);
            $this->Deploy_model->FSaMRDPYAddUpdateConditionBch($aDataConditionBch,$aDataDepHD);

            if($this->db->trans_status() === FALSE){
                $this->db->trans_rollback();
                $aReturn = array(
                    'nStaEvent'     => '900',
                    'tStaMessg'     => "Unsuccess Add"
                );
            }else{
                $this->db->trans_commit();
                $aReturn = array(
                    'tCodeReturn'   => $aDataDepHD['FTXdhDocNo'],
                    'nStaEvent'     => '1',
                    'tStaMessg'     => 'Success Add'
                );
            }
            echo json_encode($aReturn);

        }catch(Exception $Error){
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => $Error->getMessage()
            );
            echo json_encode($aReturn);
        }

    }



    // Functionality: Function Delete Document Adjust Stock
    // Parameters: Ajax and Function Parameter
    // Creator: 07/06/2019 wasin (Yoshi)
    // Return: Object View Data Table
    // ReturnType: object
    public function FSvCDPYEventDelete(){
        try{    
            $tDPYDocNo  = $this->input->post('tDPYDocNo');
            $aDataMaster = array(
                'tDPYDocNo'     => $tDPYDocNo
            );
            $aResDelDoc = $this->Deploy_model->FSnMDPYDelDocument($aDataMaster);
            if($aResDelDoc['rtCode'] == '1'){
                $aDataStaReturn  = array(
                    'nStaEvent' => '1',
                    'tStaMessg' => 'Success'
                );
            }else{
                $aDataStaReturn  = array(
                    'nStaEvent' => $aResDelDoc['rtCode'],
                    'tStaMessg' => $aResDelDoc['rtDesc']
                );
            }
        }catch(Exception $Error){
            $aDataStaReturn = array(
                'nStaEvent' => '500',
                'tStaMessg' => $Error->getMessage()
            );
        }
        echo json_encode($aDataStaReturn);
    }



    //Function : Cancel ApproveDoc
    //Parameters : Cancel ApproveDoc
    //Creator : 28/06/2019 Witsarut(BEll)
    //Return : Array 
    //Return Type : Array
    public function FSvCDPYCancel(){
    
        $tXthDocNo =  $this->input->post('tXthDocNo');
        
        $aDataUpdate    =  array(
            'FTXdhDocNo'  => $tXthDocNo,
        );

            $aStaApv = $this->Deploy_model->FSVMDPYCancel($aDataUpdate);

            if($aStaApv['rtCode'] == 1 ){
                $aApv = array(
                    'nSta'  => 1,
                    'tMsg'  => "Cancel done",
                );
            }else{
                $aApv = array(
                    'nSta' => 2,
                    'tMsg' => "Not Cancel",
                );
            }
            echo json_encode($aApv);
    }

    // Function : Approve Doc
    // LastUpdate: 30/07/2019 Wasin(Yoshi)
    // LastUpdate: 29/07/2020 Napat(Jame)
    // Last Update: 18/08/2020 Napat(Jame) อัพเดท FCAjdWahB4Adj ก่อนอนุมัติ
    public function FSvCDPYApprove(){
        try{
      
            $tXthDocNo          = $this->input->post('tXthDocNo');
            // $tXthStaApv = $this->input->Post('tXthStaApv');


                if($tXthDocNo != ''){
             
                    $aDataDocHD    = $this->Deploy_model->FSaMDPYGetHD($tXthDocNo);
                    $aDataDocDT    = $this->Deploy_model->FSaMDPYGetDT($tXthDocNo);
                    $aDataDocHDBch = $this->Deploy_model->FSaMDPYGetHDBch($tXthDocNo);
                    $aDataDocOjbFle = $this->Deploy_model->FSaMDPYGetOjbFle($tXthDocNo);
                    $aJsonObject = array(
                        'aDataDocHD'        => $aDataDocHD,
                        'aDataDocDT'        => $aDataDocDT,
                        'aDataDocHDBch'     => $aDataDocHDBch,
                        'aDataDocOjbFle'    => $aDataDocOjbFle,
                    );
                    $tFilePath = 'application\modules\tool\assets\jsontemp\/'.$tXthDocNo.'.json';
                    $tFileName = $tXthDocNo.'.json';
                    $tFileType = 'json';

                    $fp = fopen($tFilePath, 'w');
                    fwrite($fp, json_encode($aJsonObject));
                    fclose($fp);
                    // $aFiles      = $this->FSaCUPFSetFormatFileData('application\modules\tool\assets\jsontemp\/'.$tXthDocNo.'.json');

                 
                    // echo realpath($tFilePath);
                    // die();
                    $tUrlAddr   = $this->Deploy_model->FCNaMDPYGetObjectUrl();
                    $tUrlApi    = $tUrlAddr.'/Upload/File';
                    $aAPIKey    = array(
                        'tKey'      => 'X-Api-Key',
                        'tValue'    => '12345678-1111-1111-1111-123456789410'
                    );
        
                    $aParam     = array(
                        'ptContent'		=> new CURLFILE(realpath($tFilePath),$tFileType,$tFileName),
                        'ptRef1'        => 'tool_deploy',
                        'ptRef2'        => $tXthDocNo,
                        'ptRefName'     => $tXthDocNo
                    );
    
                    $oReuslt = FCNaHCallAPIBasic($tUrlApi,'POST',$aParam,$aAPIKey,'file');
                    // echo '<pre>';
                    //     print_r($oReuslt);
                    // echo '</pre>';
                    // die();

                    if($oReuslt['rtCode'] != "99" ){
                        unlink($tFilePath);
                        $aDataUpdate = array(
                            'FTXdhDocNo'         => $tXthDocNo,
                            'FTXdhJsonUrl'       => $oReuslt['rtData'],
                            'FTXdhUsrApvPreDep'  => $this->session->userdata('tSesUsername')
                        );
                       $aDPYStaApv = $this->Deploy_model->FSvMDPYApprove($aDataUpdate);
                       $aReturn = array(
                        'nStaEvent'    => $oReuslt['rtCode'],
                        'tStaMessg'    => $oReuslt['rtDesc']
                       );
                     }else{
                        $aReturn = array(
                            'nStaEvent'    => $oReuslt['rtCode'],
                            'tStaMessg'    => $oReuslt['rtDesc']
                        );
                     }

                }else{
                    $aReturn = array(
                        'nStaEvent'    => '99',
                        'tStaMessg'    => 'Not Approve'
                    );
                }
      
            echo json_encode($aReturn);
            
        }catch(\ErrorException $err){

            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => language('common/main/main', 'tApproveFail')
            );
            echo json_encode($aReturn);
            return;
        }
    }



    // Function : Approve Doc
    // LastUpdate: 30/07/2019 Wasin(Yoshi)
    // LastUpdate: 29/07/2020 Napat(Jame)
    // Last Update: 18/08/2020 Napat(Jame) อัพเดท FCAjdWahB4Adj ก่อนอนุมัติ
    public function FSvCDPYApproveDep(){
        try{
      
            $tXdhDocNo          = $this->input->post('tXthDocNo');
            if($tXdhDocNo!=''){
                $aDataUpdate = array(
                    'FTXdhDocNo'   => $tXdhDocNo,
                    'FTXdhUsrApv'  => $this->session->userdata('tSesUsername')
                );
               $aDPYStaApv = $this->Deploy_model->FSvMDPYApproveDeploy($aDataUpdate);
                if($aDPYStaApv['rtCode']=='1'){

                    $aMQParams = [
                        "queueName" => "Tool_AutoDeploy",
                        "params"    => [
                            "ptXdhDocNo"  => $tXdhDocNo
                        ]
                    ];
                    $this->FSxCDPYRabbitMQRequest($aMQParams);

                    $aReturn = array(
                        'nStaEvent'    => '1',
                        'tStaMessg'    => 'ok'
                    );
                }else{
                    $aReturn = array(
                        'nStaEvent'    => '99',
                        'tStaMessg'    => 'Try to try again.'
                    );
                }
            }else{
                $aReturn = array(
                    'nStaEvent'    => '99',
                    'tStaMessg'    => 'UUID Not Found'
                );
            }

            echo json_encode($aReturn);
        }catch(Exception $Error){
            $this->db->trans_rollback();
            $aReturn = array(
                'nStaEvent'    => '900',
                'tStaMessg'    => language('tool/upgrade/tool', 'tToolMassageError')
            );
            echo json_encode($aReturn);
            return;
        }
    }






    // Functionality : Function Call Page Add Adjust Stock
    // Parameters : Ajax and Function Parameter
    // Creator : 07/06/2019 wasin (Yoshi)
    // Return : Object View Page Add
    // ReturnType : object
    public function FSvCDPYCoppyDoc(){
        try{

            $ptXthDocNo = $this->input->post('ptXthDocNo');
            // Clear Product List IN Doc Temp

            // echo $ptXthDocNo;
            // die();

            $aDataDocHD    = $this->Deploy_model->FSaMDPYGetHD($ptXthDocNo);
            $aDataDocDT    = $this->Deploy_model->FSaMDPYGetDT($ptXthDocNo);
            $aDataDocHDBch = $this->Deploy_model->FSaMDPYGetHDBch($ptXthDocNo);
            $aConfigView = array(
                'aDataDocHD'        => $aDataDocHD,
                'aDataDocDT'        => $aDataDocDT,
                'aDataDocHDBch'     => $aDataDocHDBch,
            );
            // $tDPYViewPageAdd    = $this->load->view('tool/upgrade/deploy/wDeployAdd',$aConfigView,true);
            $aReturnData        = array(
                'aConfigView'   => $aConfigView,
                'tUsrLevel'         => $this->session->userdata("tSesUsrLevel"),
                'nStaEvent'         => '1',
                'tStaMessg'         => 'Success'
            );
        }catch(Exception $Error){
            $aReturnData = array(
                'nStaEvent' => '500',
                'tStaMessg' => $Error->getMessage()
            );
        }
        echo json_encode($aReturnData);
    }

}