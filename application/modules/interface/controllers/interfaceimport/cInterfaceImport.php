<?php
defined('BASEPATH') or exit('No direct script access allowed');

require_once(APPPATH . 'libraries/rabbitmq/vendor/autoload.php');
require_once(APPPATH . 'config/rabbitmq.php');

use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Message\AMQPMessage;

class cInterfaceimport extends MX_Controller
{


    public function __construct()
    {
        parent::__construct();
        $this->load->model('interface/interfaceimport/mInterfaceImport');
    }

    public function index($nBrowseType, $tBrowseOption)
    {

        $aData['nBrowseType']                   = $nBrowseType;
        $aData['tBrowseOption']                 = $tBrowseOption;
        $aData['aAlwEventInterfaceImport']      = FCNaHCheckAlwFunc('interfaceimport/0/0'); //Controle Event
        $aData['vBtnSave']                      = FCNaHBtnSaveActiveHTML('interfaceimport/0/0'); //Load Html ของปุ่ม Save ที่เก็บ Session ปัจจุบัน
        $tLangEdit                              = $this->session->userdata("tLangEdit");

        $aData['aDataMasterImport'] = $this->mInterfaceImport->FSaMINMGetHD($tLangEdit);


        // $this->mInterfaceImport->FSaMINMGetDataConfig($tLangEdit);

        // echo '<pre>';
        // print_r($aData['aDataMasterImport']);
        // echo '</pre>';

        $tUserCode = $this->session->userdata('tSesUserCode');

        $aParams = [
            'prefixQueueName' => 'LK_RPTransferResponseSAP',
            'ptUsrCode' => $tUserCode
        ];

        $this->FSxCINMRabbitMQDeleteQName($aParams);
        $this->FSxCINMRabbitMQDeclareQName($aParams);

        $aDataInterfaceCon = $this->mInterfaceImport->FSaMINMGetDataInterfaceConfig();

        $aConnect = array(
            'tLK_SAPDBSever' => $aDataInterfaceCon[0]['FTCfgStaUsrValue'],
            'tLK_SAPDBName'  => $aDataInterfaceCon[1]['FTCfgStaUsrValue'],
            'tLK_SAPDBPort'  => $aDataInterfaceCon[2]['FTCfgStaUsrValue'],
            'tLK_SAPDBUsr'   => $aDataInterfaceCon[3]['FTCfgStaUsrValue'],
            'tLK_SAPDBPwd'   => $aDataInterfaceCon[4]['FTCfgStaUsrValue'],
        );
        $aData['aConnect'] = $aConnect;
        $this->load->view('interface/interfaceimport/wInterfaceImport', $aData);
    }


    public function FSxCINMCallRabitMQ()
    {
        $tLangEdit  = $this->session->userdata("tLangEdit");
        $tTypeEvent = $this->input->post('ptTypeEvent');

        $aResult = $this->mInterfaceImport->FSaMINMGetDataConfig($tLangEdit);
        $aConnect = array(
            'tHost'      => $aResult[0]['FTCfgStaUsrValue'],
            'tVHost'     => $aResult[2]['FTCfgStaUsrValue'],
            'tPort'      => $aResult[3]['FTCfgStaUsrValue'],
            'tUser'      => $aResult[4]['FTCfgStaUsrValue'],
            'tPassword'  => $aResult[5]['FTCfgStaUsrValue'],
            'aQueuName'  => array(
                0 => $aResult[6]['FTCfgStaUsrValue'],
                1 => $aResult[7]['FTCfgStaUsrValue'],
                2 => $aResult[8]['FTCfgStaUsrValue'],
            ) 
        );

        if ($tTypeEvent == 'getpassword') {

            echo json_encode($aConnect);
        } else {
            $tPassword      = $this->input->post('tPassword');
            $aINMImport = $this->input->post('ocmINMImport');

            $aConnStr = array(
                'ptSAPDBServer' => $this->input->post('oetInterfaceImporttLK_SAPDBSever'),
                'ptSAPDBName'  => $this->input->post('oetInterfaceImporttLK_SAPDBName'),
                'ptSAPDBPort'  => $this->input->post('oetInterfaceImporttLK_SAPDBPort'),
                'ptSAPDBUsr'   => $this->input->post('oetInterfaceImporttLK_SAPDBUsr'),
                'ptSAPDBPwd'   => $this->input->post('tPasswordCond')
            );

    
            if(!empty($aINMImport)){
                    foreach($aINMImport as $nGrpSeq => $nValue){

                        $aMQParams = [
                            "queueName" => $aConnect['aQueuName'][$nGrpSeq],
                            "exchangname" => "",
                            "params" => [
                                "ptFunction"    => 'IMPT',
                                "ptSource"      => "HQ.AdaStoreBack",
                                "ptDest"        => "BQ Process",
                                "ptFilter"      => $this->session->userdata('tSesUsrAgnCode'),
                                "ptConnStr"     => $aConnStr,
                                "ptData" => [
                                    "ptDateFrm"     => "",
                                    "ptDateTo"      => ""
                                ]
                            ]
                        ];
                
                        $this->FCNxCallRabbitMQMaster($aMQParams, false, $tPassword);
                    }
            }


            exit;
        }
    }

    function FSxCINMRabbitMQDeclareQName($paParams)
    {

        $tPrefixQueueName = $paParams['prefixQueueName'];
        $tQueueName = $tPrefixQueueName;

        $oConnection = new AMQPStreamConnection(HOST, PORT, USER, PASS, VHOST);
        $oChannel = $oConnection->channel();
        $oChannel->queue_declare($tQueueName, false, true, false, false);
        $oChannel->close();
        $oConnection->close();
        return 1;
        /** Success */
    }


    function FSxCINMRabbitMQDeleteQName($paParams)
    {

        $tPrefixQueueName = $paParams['prefixQueueName'];
        $tQueueName = $tPrefixQueueName;
        // $oConnection = new AMQPStreamConnection('172.16.30.28', '5672', 'admin', '1234', 'Pandora_PPT1');
        $oConnection = new AMQPStreamConnection(HOST, PORT, USER, PASS, VHOST);
        $oChannel = $oConnection->channel();
        $oChannel->queue_delete($tQueueName);
        $oChannel->close();
        $oConnection->close();
        return 1;
        /** Success */
    }


    function FCNxCallRabbitMQMaster($paParams, $pbStaUse = true, $ptPasswordMQ)
    {

        $tLangEdit  = $this->session->userdata("tLangEdit");
        $aVal       = $this->mInterfaceImport->FSaMINMGetDataConfig($tLangEdit);
        $tHost      = $aVal[0]['FTCfgStaUsrValue'];
        $tVHost     = $aVal[2]['FTCfgStaUsrValue'];
        $tPort      = $aVal[3]['FTCfgStaUsrValue'];
        $tUser      = $aVal[4]['FTCfgStaUsrValue'];
        $tPassword  = $ptPasswordMQ;
 
        $tQueueName = $paParams['queueName'];
        
        $aParams    = $paParams['params'];
        if ($pbStaUse == true) {
            // $aParams['ptConnStr']   = DB_CONNECT;
        }
        $tExchange              = EXCHANGE; // This use default exchange
  

        $oConnection = new AMQPStreamConnection($tHost, $tPort, $tUser, $ptPasswordMQ, $tVHost);

        $oChannel = $oConnection->channel();
        $oChannel->queue_declare($tQueueName, false, true, false, false);
        $oMessage = new AMQPMessage(json_encode($aParams));
        $oChannel->basic_publish($oMessage, "", $tQueueName);

        $oChannel->close();
        $oConnection->close();

        return 1;
        /** Success */
    }



}
