<?php defined('BASEPATH') or exit('No direct script access allowed');
require_once(APPPATH . 'libraries/rabbitmq/vendor/autoload.php');
require_once(APPPATH . 'config/rabbitmq.php');

use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Message\AMQPMessage;
// date_default_timezone_set('Asia/Bangkok');

class Adawallet_controller extends MX_Controller 
{
     /**
     * System Language
     * @var int
     */
    public $nLngID;
    public $tPaymentAPI      = 'https://dev.ada-soft.com:44340/AdaPayment/AdaQR/v1/ada_genqr';
    public $tPublicAPI       = '';
    public $tKeyAPI          = ''; //Key ของ API บน 94
    public $tValueAPI        = ''; //Value ของ API บน 94
    // public $tLineOA          = '@677trvja';
    public $tLineOA          = '@212nzotl';

    public function __construct()
    {
        parent::__construct();
        
         //session set lang
        $CI = &get_instance();
        if ($CI->input->get('lang') and ($CI->input->get('lang') == 'th' || $CI->input->get('lang') == 'en')) {
            $CI->session->set_userdata('language', $CI->input->get('lang'));
            $this->session->set_userdata("lang", $CI->input->get('lang'));
        }

        $this->load->helper('date');
        $this->load->model('Adawallet_model');
        date_default_timezone_set('Asia/Bangkok');

        $aAPI = $this->Adawallet_model->FSaMADWAPI();
        $this->tPublicAPI   = $aAPI['rtAPI'][0]->FTUrlAddress;
        $this->tKeyAPI      = $aAPI['rtSysStaUsr'][0]->FTSysStaUsrRef;
        $this->tValueAPI    = $aAPI['rtSysStaUsr'][0]->FTSysStaUsrValue;
        
    }


    /**
        *Functionality : Function Call Register Page 
        *Parameters : Ajax and Function Parameter
        *Creator : 16/08/2022 (IcePHP)
        *Return : View
        *Return Type : View
    */
    public function index() {
        $this->load->view('adawallet/wHeader.php');
        $this->load->view('adawallet/wRegister.php');
    }

    /**
        *Functionality : Event get queue mq
        *Parameters : Queue name
        *Creator : 17/08/2022 (IcePHP)
        *Return : otp data 
        *Return Type : String
    */
    function FCNxRabbitMQGetLastQueueOTP($paData){
        try{
            $massgeBack = '';
            $nProgress='';
            do{
                $tQname     = $paData['tQname'];
                $connection = new AMQPStreamConnection(MQ_CRD_HOST, MQ_CRD_PORT, MQ_CRD_USER, MQ_CRD_PASS, MQ_CRD_VHOST,false,'AMQPLAIN', null, 'en_US', 30, 30);
                $oChannel    = $connection->channel();
                $oChannel->queue_declare($tQname, false, true, false, false);
                $message    = $oChannel->basic_get($tQname);
                if(!empty($message)){
                    if(!empty($message->body)){
                        $oChannel->basic_ack($message->delivery_info['delivery_tag']);
                        $nProgress  = $message->body;
                        $massgeBack = $message->body;
                    }else{
                        $nProgress = 'end';
                    }
                }else{
                    $nProgress = 'false';
                }
                $oChannel->close();
                $connection->close();
            }while($nProgress!='false');
            return $massgeBack;
        }catch(Exception $Error){
            return $Error;
        }
    }


    /**
        *Functionality : Event Register then check balance (Call API)
        *Parameters : Ajax Event
        *Creator : 16/08/2022 (IcePHP)
        *Return : Data Check balance 
        *Return Type : String
    */
    public function FSaCADWRegister() {

        $dformat        = "%Y-%m-%d";
        $this->nLngID   = FCNaHGetLangEdit();

        $tUrlCheckRegis     = $this->tPublicAPI.'/Card/Register';
        $tUrlCheckBalance   = $this->tPublicAPI.'/Card/CardSpotCheck';

        $aAPIKey    = array(
            'tKey'      => $this->tKeyAPI,
            'tValue'    => $this->tValueAPI
        );

        $adata      = array (
            'ptCstLineID'   => $_POST['ptCstLineID'],
            'ptCstTel'      => $_POST['ptCstTel'],
            'ptOAID'        => $this->tLineOA,
            'ptBchCode'     => '00001'
        );

        $aResultRegis  = FCNaHCallAPIBasic($tUrlCheckRegis,'POST',$adata,$aAPIKey);

        $adatacheck     = array (
            'ptCrdCode'     => '',
            'ptCstLineID'   => $_POST['ptCstLineID'],
            'ptOAID'        => $this->tLineOA,
            'ptDocDate'     => @mdate($dformat) , 
            'pnTop'         => '1',
            'pnLngID'       => $this->nLngID,
        );

        if($aResultRegis['rtCode'] == "1"){
            $aResultCheckInfo = FCNaHCallAPIBasic($tUrlCheckBalance,'POST',$adatacheck,$aAPIKey);
        }

        echo json_encode($aResultCheckInfo);
    }


    /** 
        *Functionality : Function Call Check balance Page 
        *Parameters : Ajax and Function Parameter
        *Creator : 16/08/2022 (IcePHP)
        *Return : View
        *Return Type : View
    */
    public function FSaCADWShowBalance() {
        $this->load->view('adawallet/wHeader.php');
        $this->load->view('adawallet/wCheckBalance.php');
    }
    
    
    /** 
     *Functionality : Event Check balance (Call API)
     *Parameters : Ajax Event
     *Creator : 16/08/2022 (IcePHP)
     *Return : Data Check balance 
     *Return Type : String
     */
    public function FSaCADWCheckBalance() {
        
        $dformat            = "%Y-%m-%d";
        $this->nLngID       = FCNaHGetLangEdit();
        $tUrlCheckBalance   = $this->tPublicAPI.'/Card/CardSpotCheck';
        $nDecimal           = $this->Adawallet_model->FSaMADWDecimal();

        $aAPIKey    = array(
            'tKey'      => $this->tKeyAPI,
            'tValue'    => $this->tValueAPI
        );

        $adatacheck = array (
            'ptCrdCode'     => '',
            'ptCstLineID'   => $_POST['ptCstLineID'],
            'ptOAID'        => $this->tLineOA,
            'ptDocDate'     => @mdate($dformat) , 
            'pnTop'         => '1',
            'pnLngID'       => $this->nLngID,
        );

        $aResultCheckInfo   = FCNaHCallAPIBasic($tUrlCheckBalance,'POST',$adatacheck,$aAPIKey);
        $aResultCheckInfo['pnDecimal']  = $nDecimal;
        echo json_encode($aResultCheckInfo);
        
    }


    /**
        *Functionality : Event Gen Qrcode for Topup (Call API)
        *Parameters : Ajax Event
        *Creator : 16/08/2022 (IcePHP)
        *Return : Base64 QrCode and invoice date
        *Return Type : String
    */
    public function FSaCADWGenQR() {
        $aQuery         = $this->Adawallet_model->FSaMADWRcvSpc();
        $dformat        = "YmdHis";
        $tUrlGenQRCode  = $this->tPaymentAPI;

        $tQRMode        = '';
        $tBillerID      = '';
        $tMerchantID    = '';
        $tMerchantRef   = '';
        $tPrefix        = '';
        $tSuffix        = '';

        for($pnIndex = 0; $pnIndex < count($aQuery); $pnIndex++) {
            switch ($aQuery[$pnIndex]->FTSysKey) {
                case "Tag" :
                    $tQRMode        = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break;
                case "BillerID" :
                    $tBillerID      = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break;
                case "MerchantID" :
                    $tMerchantID    = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break; 
                case "MerchantRef" :
                    $tMerchantRef   = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break; 
                case "Prefix" :
                    $tPrefix        = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break; 
                case "Suffix" : 
                    $tSuffix        = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break; 
                default:
                    break;
            }
        }

        $adata      = array (
            'QRMode'        => $tQRMode,
            'PromptPayID'   => $tBillerID,
            'REF2'          => $_POST['pnREF2'],
            'QR_Width'      => '200',
            'QR_Height'     => '200',
            'Resp_Lang'     => 'THA',
            'MerchantID'    => $tMerchantID,
            'MerchantRef'   => $tMerchantRef,
            'InvoiceID'     => $_POST['ptInvoiceID'],
            'InvoiceDate'   => date($dformat),
            'InvoiceAmt'    => $_POST['ptAmount'],
            'TerminalID'    => '00001',
            'BranchID'      => '00001',
            'StoreID'       => '00001',
            'Prefix'        => $tPrefix,
            'Suffix'        => $tSuffix
        );

        $aResultQRCode  = FCNaHCallAPIBasic($tUrlGenQRCode,'POST',$adata);
        $aResultQRCode['ptInvoiceDate'] = $adata['InvoiceDate'];
        echo json_encode($aResultQRCode);
    }


    /**
        *Functionality : Event Top up (Call API)
        *Parameters : Ajax Event
        *Creator : 16/08/2022 (IcePHP)
        *Return : Status Topup 
        *Return Type : String
    */
    public function FSaCADWTopup(){
        $aQuery         = $this->Adawallet_model->FSaMADWRcvSpc();
        $tUrlTopup      = $this->tPublicAPI.'/Card/CardTopup';

        $tMerchantID    = '';
        $tMerchantRef   = '';
        $tPrefix        = '';
        $tURL           = '';
        $tTimeout       = '';
        $tTimeQuery     = '';
        $tSuffix        = '';

        print_r($aQuery);

        for($pnIndex = 0; $pnIndex < count($aQuery); $pnIndex++) {
            switch ($aQuery[$pnIndex]->FTSysKey) {
                case "URL" :
                    $tURL           = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break;
                case "MerchantID" :
                    $tMerchantID    = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break; 
                case "MerchantRef" :
                    $tMerchantRef   = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break; 
                case "Prefix" :
                    $tPrefix        = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break; 
                case "Suffix" : 
                    $tSuffix        = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break;
                case "Timeout" :
                    $tTimeout       = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break; 
                case "TimeQuery" :
                    $tTimeQuery     = $aQuery[$pnIndex]->FTSysStaUsrValue;
                    break; 
                default:
                    break;
            }
        }

        $aAPIKey    = array(
            'tKey'      => $this->tKeyAPI,
            'tValue'    => $this->tValueAPI
        );

        $adata      = array(
            'ptCstLineID'       => $_POST['ptCstLineID'],
            'ptOAID'            => $this->tLineOA,
            'ptAmount'          => $_POST['ptAmount'],
            'ptPosCode'         => '00001',
            'ptBchCode'         => '00001',
            'ptInvoiceID'       => $_POST['ptInvoiceID'],
            'ptInvoiceDate'     => $_POST['ptInvoiceDate'],
            'ptMerchantID'      => $tMerchantID,
            'ptMerchantRef'     => $tMerchantRef,
            'ptPrefix'          => $tPrefix,
            'ptSuffix'          => $tSuffix,
            'ptLanguage'        => 'THA',
            'ptURL'             => $tURL,
            'pnTimeout'         => $tTimeout,
            'pnTimeQuery'       => $tTimeQuery,
        );

        $aResultTopup  = FCNaHCallAPIBasic($tUrlTopup,'POST',$adata,$aAPIKey);
        $aResultTopup['ptAmount'] = $adata['ptAmount'];
        $aResultTopup['ptInvoiceID'] = $adata['ptInvoiceID'];
        echo json_encode($aResultTopup);
        
    }


    /**
        *Functionality : Function Call Payment Page 
        *Parameters : Ajax and Function Parameter
        *Creator : 16/08/2022 (IcePHP)
        *Return : View
        *Return Type : View
    */
    public function FSaCADWPayment() {
        $this->load->view('adawallet/wHeader.php');
        $this->load->view('adawallet/wPayment.php');
    }


    /**
        *Functionality : Event Request OTP (Call API and get last quere in MQ)
        *Parameters : Ajax Event
        *Creator : 16/08/2022 (IcePHP)
        *Return : OTP and OTPExp 
        *Return Type : String   
    */
    public function FSaCADWRequestOTP() {
        $dformat        = "Y-m-d H:i:s";
        $tDate          = date($dformat);

        $tUrlRequest    = $this->tPublicAPI.'/Card/GenOTP';
        $aOTP           = '';

        $aAPIKey    = array(
            'tKey'      => $this->tKeyAPI,
            'tValue'    => $this->tValueAPI
        );

        $adata      = array (
            'ptCrdCode'     => $_POST['ptCrdCode'],
            'ptCstLineID'   => $_POST['ptCstLineID'],
            'ptOAID'        => $this->tLineOA,
            'ptAgnCode'     => $_POST['ptAgnCode'],
            'ptRefDate'     =>  $tDate
        );

        $aResultInfo  = FCNaHCallAPIBasic($tUrlRequest,'POST',$adata,$aAPIKey);
        
        if($aResultInfo['rtCode'] == "1"){

            $aParamQ['tQname'] = 'RESOTP_'.$_POST['ptCrdCode'].$_POST['ptAgnCode'];
            sleep(3);
            $aOTP     = $this->FCNxRabbitMQGetLastQueueOTP($aParamQ);

        }
       
        if($aOTP == ""){
            $adataReturn    = array (
                'ptStatus'  => "Fail_null"
            );
        }else {
            $aOTPencode = json_decode(json_decode($aOTP)->ptData);
            $tRefDate = $aOTPencode->paoItem[0]->ptRefDate;

            if($tRefDate != $tDate) {
                $adataReturn    = array (
                    'ptStatus'     => "Fail_Dateref"
                );
            }else {
                $adataReturn    = array (
                    'ptStatus'      => "Success",
                    'ptCrdCode'     => $aOTPencode->paoItem[0]->ptCrdCode,
                    'ptCstLineID'   => $aOTPencode->paoItem[0]->ptCstLineID,
                    'ptOAID'        => $aOTPencode->paoItem[0]->ptOAID,
                    'ptAgnCode'     => $aOTPencode->paoItem[0]->ptAgnCode,
                    'ptRefDate'     => $aOTPencode->paoItem[0]->ptRefDate,
                    'ptOTP'         => $aOTPencode->paoItem[0]->ptOTP,
                    'ptOTPExipred'  => $aOTPencode->paoItem[0]->ptOTPExipred

                );
            }
        }
        echo json_encode($adataReturn);
    }


    /**
        *Functionality : Function Call Refund Page 
        *Parameters : Ajax and Function Parameter
        *Creator : 16/08/2022 (IcePHP)
        *Return : View
        *Return Type : View
    */
    public function FSaCADWRefund() {
        $this->load->view('adawallet/wHeader.php');
        $this->load->view('adawallet/wRefund.php');
    }

 
    /**
        *Functionality : Event Refund (Call API)
        *Parameters : Ajax Event
        *Creator : 16/08/2022 (IcePHP)
        *Return : Status Refund 
        *Return Type : String 
    */
    public function FSaCADWEventRefund() {

        $tUrlCheckBalance   = $this->tPublicAPI.'/Card/ReturnTopup';
        $nDecimal           = $this->Adawallet_model->FSaMADWDecimal();
        

        $aAPIKey    = array(
            'tKey'      => $this->tKeyAPI,
            'tValue'    => $this->tValueAPI
        );

        $adata     = array (
            'ptCstLineID'       => $_POST['ptCstLineID'],
            'ptOAID'            => $this->tLineOA,
            'ptAmount'          => $_POST['ptAmount'],
            'ptPosCode'         => '00001',
            'ptBchCode'         => '00001',
            'ptInvoiceID'       => $_POST['ptInvoiceID'],
            'ptBankCode'        => $_POST['ptBankCode'] ,
            'ptBankAccount'     => $_POST['ptBankAccount'] 
        );

        $aResultRefund  = FCNaHCallAPIBasic($tUrlCheckBalance,'POST',$adata,$aAPIKey);
        $aResultRefund['pnDecimal'] = $nDecimal;
        echo json_encode($aResultRefund);

    }

}