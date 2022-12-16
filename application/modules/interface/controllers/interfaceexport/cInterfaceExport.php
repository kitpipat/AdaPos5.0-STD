<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );


require_once(APPPATH.'libraries/rabbitmq/vendor/autoload.php');
require_once(APPPATH.'config/rabbitmq.php');

use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Message\AMQPMessage;

class cInterfaceExport extends MX_Controller {

    public function __construct(){
        parent::__construct ();
        $this->load->model('interface/interfaceexport/mInterfaceExport');
        // $this->load->model('interface/interfaceimport/mInterfaceImport');
    }

    public function index($nBrowseType,$tBrowseOption){

        $tUserCode = $this->session->userdata('tSesUserCode');
        $tLangEdit = $this->session->userdata("tLangEdit");
        $aParams = [
            'prefixQueueName' => 'LK_RPTransferResponseSAP',
            'ptUsrCode' => $tUserCode
        ];
        $this->FSxCIFXRabbitMQDeleteQName($aParams);
        $this->FSxCIFXRabbitMQDeclareQName($aParams);

        $aDataConfigUI[0]='2';
        $aDataConfigUI[1]='2';
        $aDataConfigUI[2]='1';
        $aDataConfigUI[3]='1';
        $aDataConfigUI[4]='2';

        
        $aDataInterfaceCon = $this->mInterfaceExport->FSaMIFXGetDataInterfaceConfig();

        $aConnect = array(
            'tLK_SAPDBSever' => $aDataInterfaceCon[0]['FTCfgStaUsrValue'],
            'tLK_SAPDBName'  => $aDataInterfaceCon[1]['FTCfgStaUsrValue'],
            'tLK_SAPDBPort'  => $aDataInterfaceCon[2]['FTCfgStaUsrValue'],
            'tLK_SAPDBUsr'   => $aDataInterfaceCon[3]['FTCfgStaUsrValue'],
            'tLK_SAPDBPwd'   => $aDataInterfaceCon[4]['FTCfgStaUsrValue'],
        );


        $aPackData = array(
            'nBrowseType'                   => $nBrowseType,
            'tBrowseOption'                 => $tBrowseOption,
            'aAlwEventInterfaceExport'      => FCNaHCheckAlwFunc('interfaceexport/0/0'), //Controle Event
            'vBtnSave'                      => FCNaHBtnSaveActiveHTML('interfaceexport/0/0'), //Load Html ของปุ่ม Save ที่เก็บ Session ปัจจุบัน
            'aDataMasterImport'             => $this->mInterfaceExport->FSaMIFXGetHD($tLangEdit),
            'aDataConfigUI'                 => $aDataConfigUI,
            'aConnect'                      => $aConnect,
        );
        $this->load->view('interface/interfaceexport/wInterfaceExport',$aPackData);

    }

    public function FSxCIFXRabbitMQDeclareQName($paParams){

        $tPrefixQueueName = $paParams['prefixQueueName'];
        $tQueueName = $tPrefixQueueName;
        
        $oConnection = new AMQPStreamConnection(HOST, PORT, USER, PASS, VHOST);
        $oChannel = $oConnection->channel();
        $oChannel->queue_declare($tQueueName, false, true, false, false);
        $oChannel->close();
        $oConnection->close();
        return 1; /** Success */
    }

    public function FSxCIFXRabbitMQDeleteQName($paParams) {

        $tPrefixQueueName = $paParams['prefixQueueName'];
        $tQueueName = $tPrefixQueueName;
        // $oConnection = new AMQPStreamConnection('172.16.30.28', '5672', 'admin', '1234', 'Pandora_PPT1');
        $oConnection = new AMQPStreamConnection(HOST, PORT, USER, PASS, VHOST);
        $oChannel = $oConnection->channel();
        $oChannel->queue_delete($tQueueName);
        $oChannel->close();
        $oConnection->close();
        return 1; /** Success */
    }

    public function FSxCIFXCallRabitMQ(){
        $tTypeEvent = $this->input->post('ptTypeEvent');
            if(!empty($this->input->post('ocbAlwDupFlag'))){
                $nAlwDupFlag = 1;
            }else{
                $nAlwDupFlag = 2;
            }

            $aResult = $this->mInterfaceExport->FSaMINMGetDataConfig();
            
            if($aResult['rtCode'] != 1){
                $aConnect = array(
                    'tHost'      => '',
                    'tPort'      => '',
                    'tPassword'  => '',
                    'tUser'      => '',
                    'tVHost'     => '',
                    
                );
            }else{
                $aConnect = array(
                    'tHost'      => $aResult['tLK_NotiHost']['FTCfgStaUsrValue'],
                    'tPort'      => $aResult['tLK_NotiPort']['FTCfgStaUsrValue'],
                    'tPassword'  => $aResult['tLK_NotiPwd']['FTCfgStaUsrValue'],
                    'tUser'      => $aResult['tLK_NotiUsr']['FTCfgStaUsrValue'],
                    'tVHost'     => $aResult['tLK_NotiVHost']['FTCfgStaUsrValue'],
                    'tQueuName'  => array(
                        1 => $aResult['tLK_NotiQueueSalABB']['FTCfgStaUsrValue'],
                    )
                );
            }

                if($tTypeEvent == 'getpassword'){
                    echo json_encode($aConnect);
                }else{

                    $aIFXExport     = $this->input->post('ocmIFXExport');
                    $tPassword      = $this->input->post('tPassword');
                    $aConnStr = array(
                        'ptSAPDBServer' => $this->input->post('oetInterfaceExporttLK_SAPDBSever'),
                        'ptSAPDBName'  => $this->input->post('oetInterfaceExporttLK_SAPDBName'),
                        'ptSAPDBPort'  => $this->input->post('oetInterfaceExporttLK_SAPDBPort'),
                        'ptSAPDBUsr'   => $this->input->post('oetInterfaceExporttLK_SAPDBUsr'),
                        'ptSAPDBPwd'   => $this->input->post('tPasswordCond')
                    );

                    if(!empty($aIFXExport)){

                        $aBchCodeSale      = $this->input->post('oetIFXBchCodeSale');
                        $aITFXDateFromSale = $this->input->post('oetITFXDateFromSale');
                        $aITFXDateToSale   = $this->input->post('oetITFXDateFromSale');
                        $aITFXXshDocNoFrom = $this->input->post('oetITFXXshDocNoFrom');
                        $aITFXXshDocNoTo   = $this->input->post('oetITFXXshDocNoTo');
                        foreach($aIFXExport as $nKey => $nValue){

                            $aPackData = array(
                                // Sale
                                'tBchCodeSale'          => $aBchCodeSale[$nKey],
                                'dDateFromSale'         => $aITFXDateFromSale[$nKey],
                                'dDateToSale'           => $aITFXDateToSale[$nKey],
                                'tDocNoFrom'            => @$aITFXXshDocNoFrom[$nKey],
                                'tDocNoTo'              => @$aITFXXshDocNoTo[$nKey],
                                'tQueueName'            => $aConnect['tQueuName'][$nKey],
                                'tPasswordMQ'           => $tPassword,
                                'nAlwDupFlag'           => $nAlwDupFlag,
                                'aConnStr'              => ''
                            );
                            // echo '<pre>';
                            //     print_r($aPackData);
                            // echo '</pre>';
                            // die();
                             $this->FSaCIFXGetFormatParam($nValue,$aPackData);
                            
                        }

                    }
                    return;


                      


                }

    }

    public function FCNxCallRabbitMQSale($paParams,$pbStaUse = true,$ptPasswordMQ) {
        echo '3';

        $aVal = $this->mInterfaceExport->FSaMINMGetDataConfig();
        $tHost      = $aVal['tLK_NotiHost']['FTCfgStaUsrValue'];
        $tPort      = $aVal['tLK_NotiPort']['FTCfgStaUsrValue'];
        $tUser      = $aVal['tLK_NotiUsr']['FTCfgStaUsrValue'];
        $tVHost     = $aVal['tLK_NotiVHost']['FTCfgStaUsrValue'];
        $tPassword = $ptPasswordMQ;


        $tQueueName             = $paParams['queueName'];
        $aParams                = $paParams['params'];
        if($pbStaUse == true){
            // $aParams['ptConnStr']   = DB_CONNECT;
        }
        $tExchange              = EXCHANGE; // This use default exchange

        
        $oConnection = new AMQPStreamConnection($tHost, $tPort,  $tUser, $ptPasswordMQ, $tVHost);
        $oChannel = $oConnection->channel();
        $oChannel->queue_declare($tQueueName, false, true, false, false);
        $oMessage = new AMQPMessage(json_encode($aParams));
        $oChannel->basic_publish($oMessage, "", $tQueueName);

        $oChannel->close();
        $oConnection->close();
        return 1; /** Success */
    }

    public function FSaCIFXGetFormatParam($pnFormat,$paPackData){

        if(!empty($paPackData['dDateFromSale'])){
            $aDateFromSale = explode("-", $paPackData['dDateFromSale']);
            $paPackData['dDateFromSale'] = $aDateFromSale[0].'-'.$aDateFromSale[1].'-'.$aDateFromSale[2];
        }


        if(!empty($paPackData['dDateToSale'])){
            $aDateToSale = explode("-", $paPackData['dDateToSale']);
            $paPackData['dDateToSale'] = $aDateToSale[0].'-'.$aDateToSale[1].'-'.$aDateToSale[2];
        }


        if(!empty($paPackData['dDateFromFinance'])){
            $aDateFromFinance = explode("-", $paPackData['dDateFromFinance']);
            $paPackData['dDateFromFinance'] = $aDateFromFinance[0].'-'.$aDateFromFinance[1].'-'.$aDateFromFinance[2];
        }
       

        if(!empty($paPackData['dDateToFinance'])){
            $aDateToFinance = explode("-", $paPackData['dDateToFinance']);
            $paPackData['dDateToFinance'] = $aDateToFinance[0].'-'.$aDateToFinance[1].'-'.$aDateToFinance[2];
        }


        //ถ้าไม่เลือกเลขที่เอกสารมา จะต้องส่งไปหาแบบช่วง วันที่ ทั้งหมด
        if(($paPackData['tDocNoFrom'] == '' || $paPackData['tDocNoFrom'] == null) && ($paPackData['tDocNoTo'] == '' || $paPackData['tDocNoTo'] == null)){
            $aMQParams = [
                "queueName"     => $paPackData['tQueueName'],
                "exchangname"   => "",
                "params"        => [
                    "ptFunction"    =>  "SalePos",//ชื่อ Function
                    "ptSource"      =>  "AdaStoreBack", //ต้นทาง
                    "ptDest"        =>  "MQAdaLink",  //ปลายทาง
                    "ptData"        =>  json_encode([
                        "ptFilter"      => $paPackData['tBchCodeSale'],
                        "ptDateFrm"     => $paPackData['dDateFromSale'],
                        "ptDateTo"      => $paPackData['dDateToSale'],
                        "ptDocNoFrm"    => '',
                        "ptDocNoTo"     => '',
                        "ptWaHouse"     => '',
                        "ptPosCode"     => '',
                        "ptRound"       => '1',
                        "ptManaul"      => $paPackData['nAlwDupFlag'],
                        "pnDocType"     => '1'
                    ]),
                    "ptConnStr"     => $paPackData['aConnStr'],
                ]
            ];
            $this->FCNxCallRabbitMQSale($aMQParams,false,$paPackData['tPasswordMQ']);
        }else if(($paPackData['tDocNoFrom'] != '' || $paPackData['tDocNoFrom'] != null) && ($paPackData['tDocNoTo'] != '' || $paPackData['tDocNoTo'] != null)){
            //เลือก เอกสาร และเสือกวันที่มา
                $aMQParams= [
                    "queueName"     => $paPackData['tQueueName'],
                    "exchangname"   => "",
                    "params"        => [
                        "ptFunction"    =>  "SalePos",//ชื่อ Function
                        "ptSource"      =>  "AdaStoreBack", //ต้นทาง
                        "ptDest"        =>  "MQAdaLink",  //ปลายทาง
                        "ptData"        =>  json_encode([
                            "ptFilter"      => $paPackData['tBchCodeSale'],
                            "ptDateFrm"     => $paPackData['dDateFromSale'],
                            "ptDateTo"      => $paPackData['dDateToSale'],
                            "ptDocNoFrm"    => $paPackData['tDocNoFrom'],
                            "ptDocNoTo"     => $paPackData['tDocNoTo'],
                            "ptWaHouse"     => '',
                            "ptPosCode"     => '',
                            "ptRound"       => '1',
                            "ptManaul"      => $paPackData['nAlwDupFlag'],
                            "pnDocType"     => '1'
                        ]),
                        "ptConnStr"     => $paPackData['aConnStr'],
                    ]
                ];
                $this->FCNxCallRabbitMQSale($aMQParams,false,$paPackData['tPasswordMQ']);
            
        }
        else{
            //ถ้าไม่เลือกวันที่มา จะต้อส่งไปหาแบบช่วง เลขที่เอกสาร
            $aGetDataDocNo = $this->mInterfaceExport->FSaMINMGetDataDocNo($paPackData['tDocNoFrom'],$paPackData['tDocNoTo']);
            foreach($aGetDataDocNo as $aValue){
                $aMQParams[1] = [
                    "queueName"     => $paPackData['tQueueName'],
                    "exchangname"   => "",
                    "params"        => [
                        "ptFunction"    =>  "SalePos",//ชื่อ Function
                        "ptSource"      =>  "AdaStoreBack", //ต้นทาง
                        "ptDest"        =>  "MQAdaLink",  //ปลายทาง
                        "ptData"        =>  json_encode([
                            "ptFilter"      => $paPackData['tBchCodeSale'],
                            "ptDateFrm"     => $paPackData['dDateFromSale'],
                            "ptDateTo"      => $paPackData['dDateToSale'],
                            "ptDocNoFrm"    => $aValue['FTXshDocNo'],
                            "ptDocNoTo"     => $aValue['FTXshDocNo'],
                            "ptWaHouse"     => '',
                            "ptPosCode"     => '',
                            "ptRound"       => '1',
                            "ptManaul"      => $paPackData['nAlwDupFlag'],
                            "pnDocType"     => '1'
                        ]),
                        "ptConnStr"     => $paPackData['aConnStr'],
                    ]
                ];
                $this->FCNxCallRabbitMQSale($aMQParams,false,$paPackData['tPasswordMQ']);
            }
        }
    }


//ส่งคิวตามรายการบิล เฉพาะการติ๊กว่า ส่งไม่สำเร็จ
 public function FSxCINFCallPreapairExport($ptPasswordMQ){
     $aDocNoPrepair= $this->mInterfaceExport->FSaMINMGetLogHisError();
     
        if(!empty($aDocNoPrepair)){
            foreach($aDocNoPrepair as $aValue){
                $aMQParams = [
                    "queueName"     => "LK_QSale2Vender",
                    "exchangname"   => "",
                    "params"        => [
                        "ptFunction"    =>  "SalePos",//ชื่อ Function
                        "ptSource"      =>  "AdaStoreBack", //ต้นทาง
                        "ptDest"        =>  "MQAdaLink",  //ปลายทาง
                        "ptData"        =>  json_encode([
                            "ptFilter"      => $aValue['FTBchCode'],
                            "ptDateFrm"     => '',
                            "ptDateTo"      => '',
                            "ptDocNoFrm"    => $aValue['FTLogTaskRef'],
                            "ptDocNoTo"     => $aValue['FTLogTaskRef'],
                            "ptWaHouse"     => '',
                            "ptPosCode"     => '',
                            "ptRound"       => '1'
                        ])
                    ]
                ];

        
                $this->FCNxCallRabbitMQSale($aMQParams,false,$ptPasswordMQ);
            }
        }

 }


    public function FSnCIFXFillterBill(){

            $aDataParam = [
                'tFXBchCodeSale' => $this->input->post('oetIFXBchCodeSale'),
                'tFXDateFromSale' => $this->input->post('oetITFXDateFromSale'),
                'tFXDateToSale' => $this->input->post('oetITFXDateFromSale'),
                'nSeq' => $this->input->post('nSeq'),
            ];
            $this->mInterfaceExport->FSxMIFXFillterBill($aDataParam);
           return 1;

    }

}    
?>

