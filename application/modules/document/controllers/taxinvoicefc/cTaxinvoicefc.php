<?php
defined('BASEPATH') or exit('No direct script access allowed');
use PhpAmqpLib\Connection\AMQPStreamConnection;

class cTaxinvoicefc extends MX_Controller
{

    public function __construct(){
        parent::__construct();
        $this->load->model('document/taxInvoicefc/mTaxinvoicefc');
    }

    public function index($nBrowseType, $tBrowseOption){
        $aData['nBrowseType']       = $nBrowseType;
        $aData['tBrowseOption']     = $tBrowseOption;
        $aData['aAlwEvent']         = FCNaHCheckAlwFunc('dcmTXFC/0/0');
        $aData['aAlwConfigForm']    = $this->mTaxinvoicefc->FSaMTXFGetConfig();
        $this->load->view('document/taxInvoicefc/wTaxInvoicefc', $aData);
    }

    //Load List
    public function FSvCTXFLoadList(){
        $this->load->view('document/taxInvoicefc/wTaxInvoicefcSearchList');
    }

    //Load Datatable
    public function FSvCTXFLoadListDatatable(){
        $nPage          = $this->input->post('nPage');
        $tSearchAll     = $this->input->post('tSearchAll');

        $aDataSearch = array(
            'nPage'                 => $nPage,
            'nRow'                  => 10,
            'tSearchAll'            => $tSearchAll,
            'FNLngID'               => $this->session->userdata("tLangEdit")
        );

        $aABB       = $this->mTaxinvoicefc->FSaMTXFGetListABB($aDataSearch);

   
        $aDataHTML  = array(
            'nPage' => $this->input->post("nPage"),
            'aABB'  => $aABB
        );

        $this->load->view('document/taxInvoicefc/wTaxInvoicefcListDatatable', $aDataHTML);
    }

    //Load Page Add
    public function FSvCTXFLoadPageAdd(){
        $tDocument          = $this->input->post('tDocument');
        $tDocumentBchCode          = $this->input->post('tDocumentBchCode');
        if($tDocument == '' || $tDocument == null){
            $tTypePage       = 'Insert';
            $tDocumentNumber = '';
            $tDocumentBchCode        = '';
        }else{
            $tTypePage       = 'Preview';
            $tDocumentNumber = $tDocument;
            $tDocumentBchCode  = $tDocumentBchCode;
        }

        $nCmpRetInOrEx = $this->db->where('FTCmpCode','00001')->select('FTCmpRetInOrEx')->get('TCNMComp')->row_array()['FTCmpRetInOrEx'];

        $aReturnData = array(
            'tTypePage'         => $tTypePage,
            'tDocumentNumber'   => $tDocumentNumber,
            'nCmpRetInOrEx'     => $nCmpRetInOrEx,
            'tDocumentBchCode'  => $tDocumentBchCode,
        );

        $tViewPageAdd       = $this->load->view('document/taxInvoicefc/wTaxInvoicefcPageAdd',$aReturnData);
        return $tViewPageAdd;
    }

    //Load Datatable
    public function FSvCTXFLoadDatatable(){
        $tDocumentNumber    = $this->input->post('tDocumentNumber');
        $tBrowseBchCode    = $this->input->post('tBrowseBchCode');
        $tSearchPDT         = $this->input->post('tSearchPDT');
        $nPage              = $this->input->post('nPage');

        $aWhere = array(
            'tDocumentNumber' => $tDocumentNumber,
            'tBrowseBchCode' => $tBrowseBchCode,
            'tSearchPDT'      => $tSearchPDT,
            'nRow'            => 10,
            'nPage'           => $nPage
        );

        if($tDocumentNumber == '' || $tDocumentNumber == null){
            $aGetDT     = array(
                            'rnAllRow'      => 0,
                            'rnCurrentPage' => 1,
                            "rnAllPage"     => 0,
                            'rtCode'        => '800',
                            'rtDesc'        => 'data not found'
                        );
            $aGetHD     = array(
                            'rtCode'        => '800',
                            'rtDesc'        => 'data not found'
                        );
        }else{
            $aGetDT     = $this->mTaxinvoicefc->FSaMTXFGetDT($aWhere); 
            $aGetHD     = $this->mTaxinvoicefc->FSaMTXFGetHD($aWhere);
        }
       

        // $aGetDT     = $this->mTaxinvoicefc->FSaMTXFGetDT($aWhere);
        // $aGetHD     = $this->mTaxinvoicefc->FSaMTXFGetHD($aWhere);

        $aPackData  = array(
            'nPage'         => $nPage,
            'aGetDT'        => $aGetDT,
            'aGetHD'        => $aGetHD,
            'tTypePage'     => 'Insert'
        );
        $aReturnData = array(
            'tContentPDT'         => $this->load->view('document/taxInvoicefc/wTaxInvoicefcDatatable',$aPackData, true),
            'tContentSumFooter'   => $this->load->view('document/taxInvoicefc/wTaxInvoicefcSumFooter',$aPackData, true),
            'aDetailHD'           => $aGetHD
        );
        echo json_encode($aReturnData);
    }

    //Load Datatable ABB ????????????????????????
    public function FSvCTXFLoadDatatableABB(){
        $tFilter        = $this->input->post('tFilter');
        $tSearchABB     = $this->input->post('tSearchABB');
        $tTextDateABB   = $this->input->post('tTextDateABB');
        $nPage          = $this->input->post('nPage');
        $nLangEdit      = $this->session->userdata("tLangEdit");
        $tBCH           = $this->input->post('tBCH');

        $aPackData = array(
            'tFilter'       => $tFilter,
            'tSearchABB'    => $tSearchABB,
            'tTextDateABB'  => $tTextDateABB,
            'nPage'         => $nPage,
            'nRow'          => 10,
            'FNLngID'       => $nLangEdit,
            'tBCH'          => $tBCH
        );

        $aGetABB    = $this->mTaxinvoicefc->FSaMTXFListABB($aPackData);
        $aDataView  = array(
            'nPage'         => $nPage,
            'aDataList'     => $aGetABB
        );

        $tTableABBHtml  = $this->load->view('document/taxInvoicefc/SelectABB/wSelectABBfc', $aDataView, true);
        $aReturnData    = array(
            'tTableABBHtml'   => $tTableABBHtml
        );
        echo json_encode($aReturnData);
    }

    //?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    public function FSaCTXFCheckABBNumber(){
        $tDocumentNumber    = $this->input->post('DocumentNumber');
        $tBCH               = $this->input->post('tBCH');
        $aGetABB            = $this->mTaxinvoicefc->FSaMTXFCheckABBNumber($tDocumentNumber,$tBCH);
        if(empty($aGetABB)){
            $aReturn = array(
                'tStatus'   => 'not found'
            );
        }else{
            $aReturn = array(
                'tStatus'   => 'found',
                'tCuscode'  => '',
                'tCusname'  => ''
            );
        }
        echo json_encode($aReturn);
    }

    //?????????????????????????????????
    public function FSaCTXFLoadAddress(){
        $tDocumentNumber    = $this->input->post('tDocumentNumber');
        $tCustomer          = $this->input->post('tCustomer');

        //??????????????????????????????????????????????????? TCNMTaxAddress_L ????????????????????????????????????????????????
        if($tCustomer != '' ||  $tCustomer != null){
            $aAddress  = $this->mTaxinvoicefc->FSaMTXFFindAddress($tCustomer);
            if(empty($aAddress)){
                //?????????????????????????????????????????????????????????????????? TCNMCstAddress_L
                $aAddressHDCst   = $this->mTaxinvoicefc->FSaMTXFFindAddressCst($tCustomer,null);
                if(empty($aAddressHDCst)){
                    //??????????????????
                    $aReturn    = array(
                        'tStatus' => 'null'
                    );
                }else{
                    //?????????????????????????????? TCNMCstAddress_L
                    $aReturn    = array(
                        'tStatus'   => 'passCst',
                        'aList'     => $aAddressHDCst
                    );
                }
            }else{
                //?????????????????????????????? TCNMTaxAddress_L
                $aReturn = array(
                    'tStatus'   => 'passABB',
                    'aList'     => $aAddress
                );
            }
        }else{
            //??????????????????
            $aReturn    = array(
                'tStatus' => 'null'
            );
        }

        echo json_encode($aReturn);
    }

    //??????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    public function FSaCTXFLoadCustomerAddress(){
        $tDocumentNumber    = $this->input->post('tDocumentNumber');
        $tCustomer          = $this->input->post('tCustomer');
        $tSeqno             = $this->input->post('tSeqno');
        $aAddressHDCst      = $this->mTaxinvoicefc->FSaMTXFFindAddressCst($tCustomer,$tSeqno);
        if(empty($aAddressHDCst)){
            //??????????????????
            $aReturn    = array(
                'tStatus' => 'null'
            );
        }else{
            //?????????????????????????????? TCNMCstAddress_L
            $aReturn    = array(
                'tStatus'   => 'passCst',
                'aList'     => $aAddressHDCst
            );
        }
        echo json_encode($aReturn);
    }

    //?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    public function FSaCTXFCheckTaxno(){
        $tTaxno     = $this->input->post('tTaxno');
        $nSeq       = $this->input->post('nSeq');

        $aGetTaxno  = $this->mTaxinvoicefc->FSaMTXFCheckTaxno($tTaxno,$nSeq);
        if(empty($aGetTaxno)){
            $aReturn = array(
                'tStatus'   => 'not found'
            );
        }else{
            $aReturn = array(
                'tStatus'   => 'found',
                'aAddress'  => $aGetTaxno
            );
        }
        echo json_encode($aReturn);
    }

    //???????????????????????????????????????????????????????????????????????????????????????
    public function FSvCTXFLoadDatatableTaxno(){
        $tSearchTaxno   = $this->input->post('tSearchTaxno');
        $nPage          = $this->input->post('nPage');
        $nLangEdit      = $this->session->userdata("tLangEdit");

        $aPackData = array(
            'tSearchTaxno'  => $tSearchTaxno,
            'nPage'         => $nPage,
            'nRow'          => 10,
            'FNLngID'       => $nLangEdit
        );

        $aGetTaxno    = $this->mTaxinvoicefc->FSaMTXFListTaxno($aPackData);
        $aDataView  = array(
            'nPage'         => $nPage,
            'aDataList'     => $aGetTaxno
        );

        $tTableTaxnoHtml  = $this->load->view('document/taxInvoicefc/SelectTaxno/wSelectTaxnofc', $aDataView, true);
        $aReturnData    = array(
            'tTableTaxnoHtml'   => $tTableTaxnoHtml
        );
        echo json_encode($aReturnData);
    }

    //??????????????????????????????????????????????????????????????????????????????????????????????????????????????????
    public function FSvCTXFLoadDatatableCustomerAddress(){
        $tSearchAddress     = $this->input->post('tSearchAddress');
        $tCustomerCode      = $this->input->post('tCustomerCode');
        $nPage              = $this->input->post('nPage');
        $nLangEdit          = $this->session->userdata("tLangEdit");

        $aPackData = array(
            'tSearchAddress'    => $tSearchAddress,
            'nPage'             => $nPage,
            'nRow'              => 10,
            'FNLngID'           => $nLangEdit,
            'tCustomerCode'     => $tCustomerCode
        );

        $aGetCustomer    = $this->mTaxinvoicefc->FSaMTXFListCustomerAddress($aPackData);
        $aDataView  = array(
            'nPage'         => $nPage,
            'aDataList'     => $aGetCustomer
        );

        $tTableCustomerAddressHtml  = $this->load->view('document/taxInvoicefc/SelectCustomerAddress/wSelectCustomerAddressfc', $aDataView, true);
        $aReturnData    = array(
            'tTableCustomerAddressHtml'   => $tTableCustomerAddressHtml
        );
        echo json_encode($aReturnData);
    }

    //?????????????????????
    public function FSaCTXFApprove(){
        $aPackData          = $this->input->post('aPackData');
        $tType              = $this->input->post('tType');
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tInputBchCode      = $aPackData['tInputBchCode'];
        $tStaETax           = $aPackData['tStaETax'];
        $tTAXApvType        = $aPackData['tTAXApvType'];
        $aWhere = array(
            'tDocumentNumber' => $tABB ,
            'tBrowseBchCode' => $tBrowseBchCode
        );
        
        $aGetBCHABB = $this->mTaxinvoicefc->FSaMTXFGetHD($aWhere);
        // print_r($aGetBCHABB);
        //???????????????????????????????????????????????????????????????????????? ?????????MQ ????????????
        if( (isset($aGetBCHABB['raItems'][0]['FTXshDocVatFull']) && $aGetBCHABB['raItems'][0]['FTXshDocVatFull'] == '') || $tTAXApvType == '2' ) {
        // if (isset($aGetBCHABB['raItems'])) {
          if($tType == 'MQ'){

              $tDocType = ($aGetBCHABB['raItems'][0]['FNXshDocType']==0 ? 'R' : 'S');
              $tUserCode      = $this->session->userdata("tSesUserCode");
            //   $tCheckMQ['tQname']  = 'CN_QRetGenTaxNo_'.$aGetBCHABB['raItems'][0]['FTBchCode'].'_'.$tDocType;
              $tCheckMQ['tQname']  = 'CN_QRetGenTaxNo_'.$tInputBchCode.'_'.$tDocType;
              $tCheckQueue =  FCNxRabbitMQCheckQueueMassage($tCheckMQ);
              if($tCheckQueue=='false'){
              $aMQParams  = [
                  "queueName" => "CN_QReqGenTaxNo",
                  "params" => [
                      "ptBchCode"         => $tInputBchCode,
                      "pnSaleType"        => $aGetBCHABB['raItems'][0]['FNXshDocType'],
                      "ptDocNo"           => $tABB,
                      "ptUser"            => $this->session->userdata("tSesUserCode")
                  ]
              ];

              FCNxCallRabbitMQ($aMQParams);
              }
              $tDoctype  = ($aGetBCHABB['raItems'][0]['FNXshDocType']==0? 'R' : 'S');
              $aReturnData    = array(
                  'tBCHDoc'   => $tInputBchCode,
                  'tDoctype' => $tDoctype,
              );
              echo json_encode($aReturnData);
            }
        //   }else{
        //       //Move ???????????????????????????????????? ????????????????????? Tax + update ?????????????????????????????????????????????
        //       $aPackData      = array(
        //           'tTaxNumberFull' => $aPackData['tTaxNumberFull'],
        //           'tBrowseBchCode' => $aPackData['tBrowseBchCode'],
        //           'dDocDate'       => $aPackData['dDocDate'],
        //           'dDocTime'       => $aPackData['dDocTime'],
        //           'tDocABB'        => $aPackData['tDocABB'],
        //           'tCstNameABB'    => $aPackData['tCstNameABB'],
        //           'tCstCode'       => $aPackData['tCstCode'],
        //           'tCstName'       => $aPackData['tCstName'],
        //           'tTaxnumber'     => $aPackData['tTaxnumber'],
        //           'tTypeBusiness'  => $aPackData['tTypeBusiness'],
        //           'tBusiness'      => $aPackData['tBusiness'],
        //           'tBranch'        => $aPackData['tBranch'],
        //           'tTel'           => $aPackData['tTel'],
        //           'tFax'           => $aPackData['tFax'],
        //           'tAddress1'      => $aPackData['tAddress1'],
        //           'tAddress2'      => $aPackData['tAddress2'],
        //           'tReason'        => $aPackData['tReason'],
        //           'tSeqAddress'    => $aPackData['tSeqAddress'],
        //           'tTaxBchCode'    => $aGetBCHABB['raItems'][0]['FTBchCode'],
        //           'tXshGndText'   => FCNtNumberToTextBaht($aGetBCHABB['raItems'][0]['FCXshGrand'])
        //       );

        //       /////////////////////////////////// -- MOVE -- ///////////////////////////////////

        //       $this->db->trans_begin();

        //       // TPSTSalHD -> TPSTTaxHD
        //       $this->mTaxinvoicefc->FSaMTXFMoveSalHD_TaxHD($aPackData);

        //       // TPSTSalHDDis -> TPSTTaxHDDis
        //       $this->mTaxinvoicefc->FSaMTXFMoveSalHDDis_TaxHDDis($aPackData);

        //       // TPSTSalDT -> TPSTTaxDT
        //       $this->mTaxinvoicefc->FSaMTXFMoveSalDT_TaxDT($aPackData);

        //       // TPSTSalDTDis -> TPSTTaxDTDis
        //       $this->mTaxinvoicefc->FSaMTXFMoveSalDTDis_TaxDTDis($aPackData);

        //       // TPSTSalHDCst -> TPSTTaxHDCst
        //       $this->mTaxinvoicefc->FSaMTXFMoveSalHDCst_TaxHDCst($aPackData);

        //       // TPSTSalPD -> TPSTTaxPD
        //       $this->mTaxinvoicefc->FSaMTXFMoveSalPD_TaxPD($aPackData);

        //       // TPSTSalRC -> TPSTTaxRC
        //       $this->mTaxinvoicefc->FSaMTXFMoveSalRC_TaxRC($aPackData);

        //       // TPSTSalRD -> TPSTTaxRD
        //       $this->mTaxinvoicefc->FSaMTXFMoveSalRD_TaxRD($aPackData);

        //       ///////////////////////////// -- INSERT UPDATE -- /////////////////////////////

        //       //Update FTXshDocVatFull  + ??????????????????????????????????????????????????????????????????????????????
        //       $this->mTaxinvoicefc->FSaMTXFUpdateDocVatFull($aPackData);

        //       //Insert ??????????????????????????????????????????
        //       $this->mTaxinvoicefc->FSaMTXFInsertTaxAddress($aPackData);

        //       if($this->db->trans_status() === FALSE){
        //           $this->db->trans_rollback();
        //           $tStatus    = 500;
        //           $tStaMessg  = 'Not Success';
        //       }else{
        //           $this->db->trans_commit();
        //           $tStatus    = 1;
        //           $tStaMessg  = 'Success';
        //       }

        //       //Delete ??????????????????????????????????????????????????????????????????
        //       $tUserCode      = $this->session->userdata("tSesUserCode");
        //       $tQueueName     = 'CN_QRetGenTaxNo_'.$aPackData['tDocABB'].'_'.$tUserCode;
        //     //   $oConnection    = new AMQPStreamConnection(HOST, PORT, USER, PASS, VHOST);
        //     //   $oChannel       = $oConnection->channel();
        //     //   $oChannel->queue_delete($tQueueName);
        //     //   $oChannel->close();
        //     //   $oConnection->close();
        //       // echo $tQueueName;

        //       $aDataReturn    = array(
        //           'nStaEvent'     => $tStatus,
        //           'tStaMessg'     => $tStaMessg,
        //           'tQueueName'    => $tQueueName
        //       );

        //       echo json_encode($aDataReturn);
        //   }
        }else {
          $tStatus    = 550;
          $tStaMessg  = 'Not Success';
          $aDataReturn    = array(
              'nStaEvent'     => $tStatus,
              'tStaMessg'     => $tStaMessg
          );
          echo json_encode($aDataReturn);
        }

    }



    
    //????????????????????????????????? GetMassage ?????????????????? Stomp ??????????????????????????????????????? TPSTTaxNo ??????????????????
    public function FSxCTXFCallTaxNoLastDoc(){

        $aPackData          = $this->input->post('aPackData');
        $tABB               = $aPackData['tDocABB'];
        $tBrowseBchCode     = $aPackData['tBrowseBchCode'];
        $tInputBchCode     = $aPackData['tInputBchCode'];

        $aWhere = array(
            'tDocumentNumber' => $tABB,
            'tBrowseBchCode'  => $tBrowseBchCode
        );
        $aGetBCHABB = $this->mTaxinvoicefc->FSaMTXFGetHD($aWhere);
        
        // $tBchCode         = $aGetBCHABB['raItems'][0]['FTBchCode'];
        // $nSaleType        = $aGetBCHABB['raItems'][0]['FNXshDocType'];

        // if($nSaleType == 9){
        //     $nDocType = 5;
        // }else{
        //     $nDocType = 4;
        // }

        // $aParamData  = array(
        //     'tBchCode' => $tBchCode ,
        //     'nDocType' => $nDocType,
        //     'tDocABB'  => $aPackData['tDocABB']
        // );
        $tUserCode          = $this->session->userdata("tSesUserCode");
        $tDocType           = ($aGetBCHABB['raItems'][0]['FNXshDocType']==9 ? 'R' : 'S');
        // $aParamQ['tQname']  = 'CN_QRetGenTaxNo_'.$aGetBCHABB['raItems'][0]['FTBchCode'].'_'.$tDocType;
        $aParamQ['tQname']  = 'CN_QRetGenTaxNo_'.$tInputBchCode.'_'.$tDocType;
        $tTaxJsonString     = FCNxRabbitMQGetMassage($aParamQ);

        // echo "<pre>";
        
        // $tTaxNumberFull = $this->mTaxinvoicefc->FSaMTAXCallTaxNoLastDoc($aParamData);
        // $nResult    = $this->mTaxinvoicefc->FSnMTAXCheckDuplicationOnTaxHD($tTaxNumberFull);
        //????????????????????????????????? Tax ???????????????????????? ?????????????????????????????????????????????????????????????????????
        if( $tTaxJsonString != 'false' ){
            $aTaxJsonString =  json_decode($tTaxJsonString);
            // echo "<pre>";
            
            $tTaxNumberFull = $aTaxJsonString->rtDocNo;

            $tBCHCode       = $aGetBCHABB['raItems'][0]['FTBchCode'];
            $nResult        = $this->mTaxinvoicefc->FSnMTXFCheckDuplicationOnTaxHD($tTaxNumberFull,$tBCHCode);
            // echo $nResult;

            if( $nResult == 0 ){
                //Move ???????????????????????????????????? ????????????????????? Tax + update ?????????????????????????????????????????????
                $aPackData['tTaxNumberFull'] = $tTaxNumberFull;
                $aPackData['tXshGndText'] = FCNtNumberToTextBaht($aGetBCHABB['raItems'][0]['FCXshGrand']);
                $aPackData['tReason']     ='';
                $aPackData['tTaxBchCode']  = $aGetBCHABB['raItems'][0]['FTBchCode'];
                // $aPackData      = array(
                //     'tTaxNumberFull' => $tTaxNumberFull,
                //     'dDocDate'       => $aPackData['dDocDate'],
                //     'dDocTime'       => $aPackData['dDocTime'],
                //     'tDocABB'        => $aPackData['tDocABB'],
                //     'tCstNameABB'    => $aPackData['tCstNameABB'],
                //     'tCstCode'       => $aPackData['tCstCode'],
                //     'tCstName'       => $aPackData['tCstName'],
                //     'tTaxnumber'     => $aPackData['tTaxnumber'],
                //     'tTypeBusiness'  => $aPackData['tTypeBusiness'],
                //     'tBusiness'      => $aPackData['tBusiness'],
                //     'tBranch'        => $aPackData['tBranch'],
                //     'tTel'           => $aPackData['tTel'],
                //     'tFax'           => $aPackData['tFax'],
                //     'tAddress1'      => $aPackData['tAddress1'],
                //     'tAddress2'      => $aPackData['tAddress2'],
                //     'tReason'        => $aPackData['tReason'],
                //     'tSeqAddress'    => $aPackData['tSeqAddress'],
                //     'tStaETax'       => $aPackData['tStaETax'],
                //     'tPosCode'       => $aPackData['tPosCode']
                // );

                /////////////////////////////////// -- MOVE -- ///////////////////////////////////
                
                $this->db->trans_begin();

                     // TPSTSalHD -> TPSTTaxHD
                     $this->mTaxinvoicefc->FSaMTXFMoveSalHD_TaxHD($aPackData);

                     // TPSTSalHDDis -> TPSTTaxHDDis ?????????????????????????????????????????????
                     $this->mTaxinvoicefc->FSaMTXFMoveSalHDDis_TaxHDDis($aPackData);
       
                     // TPSTSalDT -> TPSTTaxDT
                     $this->mTaxinvoicefc->FSaMTXFMoveSalDT_TaxDT($aPackData);
                     
                    // TPSTSalDTSN -> TPSTTaxDTSN
                    $this->mTaxinvoicefc->FSaMTXFMoveSalDTSN_TaxDTSN($aPackData);

                     // TPSTSalDTDis -> TPSTTaxDTDis ?????????????????????????????????????????????
                     $this->mTaxinvoicefc->FSaMTXFMoveSalDTDis_TaxDTDis($aPackData);
       
                     // TPSTSalHDCst -> TPSTTaxHDCst
                     $this->mTaxinvoicefc->FSaMTXFMoveSalHDCst_TaxHDCst($aPackData);
       
                     // TPSTSalPD -> TPSTTaxPD ?????????????????????????????????????????????
                     $this->mTaxinvoicefc->FSaMTXFMoveSalPD_TaxPD($aPackData);
       
                     // TPSTSalRC -> TPSTTaxRC
                     $this->mTaxinvoicefc->FSaMTXFMoveSalRC_TaxRC($aPackData);
       
                     // TPSTSalRD -> TPSTTaxRD ?????????????????????????????????????????????
                     $this->mTaxinvoicefc->FSaMTXFMoveSalRD_TaxRD($aPackData);

                     

       
                     ///////////////////////////// -- INSERT UPDATE -- /////////////////////////////

                    //Update FTXshDocVatFull  + ??????????????????????????????????????????????????????????????????????????????
                    $this->mTaxinvoicefc->FSaMTXFUpdateDocVatFull($aPackData);

                    //Insert ??????????????????????????????????????????
                    $this->mTaxinvoicefc->FSaMTXFInsertTaxAddress($aPackData);

                    if( $aPackData['tTAXApvType'] == '2' ){ // ????????????????????????????????????????????????
                        
                        switch($tDocType){
                            case 'R': // CN-FullTax
                                $this->mTaxinvoicefc->FSxMTXFUpdAddrCNFullTax($aPackData);
                                break;
                            case 'S':
                                $this->mTaxinvoicefc->FSxMTXFUpdAddrABBFullTax($aPackData);
                                break;
                        }

                        //Update RefInt + RefAE
                        $this->mTaxinvoicefc->FSxMTXFUpdateReference($aPackData);

                    }


                // TPSTTaxHDCst ????????????????????????????????????????????????????????????????????????????????????
                // $this->mTaxinvoicefc->FSaMTAXUpdAddrTaxHDCst($aPackData);


                if($this->db->trans_status() === FALSE){
                    $this->db->trans_rollback();
                    $tStatus    = 500;
                    $tStaMessg  = 'Not Success';
                }else{
                    $this->db->trans_commit();
                    $tStatus    = 1;
                    $tStaMessg  = 'Success';
                }

                //Delete ??????????????????????????????????????????????????????????????????
                // $tUserCode      = $this->session->userdata("tSesUserCode");
                // $tQueueName     = 'CN_QRetGenTaxNo_'.$aGetBCHABB['raItems'][0]['FTBchCode'].'_'.$tDocType;
                $tQueueName     = 'CN_QRetGenTaxNo_'.$tInputBchCode.'_'.$tDocType;
                // $oConnection    = new AMQPStreamConnection(HOST, PORT, USER, PASS, VHOST);
                // $oChannel       = $oConnection->channel();
                // $oChannel->queue_delete($tQueueName);
                // $oChannel->close();
                // $oConnection->close();
                // echo $tQueueName;

                $tStaETax = $aPackData['tStaETax'];
                if( $tStaETax == '1' ){
                    $aPackDataMQ = array(
                        'tAbbDocNo' => $aPackData['tDocABB'],
                        'tTaxDocNo' => $aPackData['tTaxNumberFull'],
                        // 'tBchCode'  => $aPackData['tBrowseBchCode'],
                        'tBchCode'  => $tInputBchCode,
                        'tPosCode'  => $aPackData['tPosCode'],
                        'tDocType'  => $aGetBCHABB['raItems'][0]['FNXshDocType']
                    );
                    $aRabbitMQ = $this->FSaCTXFEventSendMQETax($aPackDataMQ);

                    if( $aRabbitMQ['nStaEvent'] != '1' ){
                        echo json_encode($aRabbitMQ);
                        return;
                    }
                }

                $aDataReturn    = array(
                    'nStaEvent'     => $tStatus,
                    'tStaMessg'     => $tStaMessg,
                    'tQueueName'    => $tQueueName,
                    'tTaxNumberFull' => $tTaxNumberFull
                );

                echo json_encode($aDataReturn);
            }else{

                $tUserCode      = $this->session->userdata("tSesUserCode");
                $tDocType = ($aGetBCHABB['raItems'][0]['FNXshDocType']==9 ? 'R' : 'S');
                // $tCheckMQ['tQname']     = 'CN_QRetGenTaxNo_'.$aGetBCHABB['raItems'][0]['FTBchCode'].'_'.$tDocType;
                $tCheckMQ['tQname']     = 'CN_QRetGenTaxNo_'.$tInputBchCode.'_'.$tDocType;
                $tCheckQueue =  FCNxRabbitMQCheckQueueMassage($tCheckMQ);

                if($tCheckQueue=='false'){
                    $aMQParams  = [
                        "queueName" => "CN_QReqGenTaxNo",
                        "params" => [
                            "ptBchCode"         => $tInputBchCode,
                            "pnSaleType"        => $aGetBCHABB['raItems'][0]['FNXshDocType'],
                            "ptDocNo"           => $tABB,
                            "ptUser"            => ''
                        ]
                    ];
                }

                $aDataReturn    = array(
                    'nStaEvent'     => '800',
                    'tStaMessg'     => '?????????????????????????????????????????????????????????????????????????????????????????????',
                    'tBCHDoc'      => $tInputBchCode
                );
                echo json_encode($aDataReturn);
            }
        }else{
            $aDataReturn    = array(
                'nStaEvent'     => '800',
                'tStaMessg'     => '?????????????????????????????????????????????????????????????????????????????????????????????',
                'tBCHDoc'       => $tInputBchCode
            );
            echo json_encode($aDataReturn);
        }
    }
    
    //?????????????????????????????? HD + Address
    public function FSvCTXFLoadDatatableTax(){
        $tDocumentNumber    = $this->input->post('tDocumentNumber');
        $tBrowseBchCode    = $this->input->post('tBrowseBchCode');
        $aWhere = array(
            'tDocumentNumber' => $tDocumentNumber,
            'tBrowseBchCode'  => $tBrowseBchCode,
            'FNLngID'         => $this->session->userdata("tLangEdit")
        );

        // $aGetDT     = $this->mTaxinvoicefc->FSaMTXFGetDT($aWhere);
        $aGetHD     = $this->mTaxinvoicefc->FSaMTXFGetHDTax($aWhere);
        $aAddress   = $this->mTaxinvoicefc->FSaMTXFGetAddressTax($aWhere);
        $aGetHD['raItems'][0]['FDXshDocDate'] = date_format(date_create($aGetHD['raItems'][0]['FDXshDocDate']),'Y-m-d H:i:s');
        $aPackData  = array(
            // 'aGetDT'        => $aGetDT,
            'aGetHD'        => $aGetHD,
            'aAddress'      => $aAddress
        );
        
        $aReturnData = array(
            'tContentSumFooter'   => $this->load->view('document/taxInvoicefc/wTaxInvoicefcSumFooter',$aPackData, true),
            'aDetailHD'           => $aGetHD,
            'aDetailAddress'      => $aAddress
        );
        echo json_encode($aReturnData);
    }

    //?????????????????????????????? DT
    public function FSvCTXFLoadDatatableDTTax(){
        $tDocumentNumber    = $this->input->post('tDocumentNumber');
        $tBrowseBchCode     = $this->input->post('tBrowseBchCode');
        $tSearchPDT         = $this->input->post('tSearchPDT');
        $nPage              = $this->input->post('nPage');

        $aWhere = array(
            'tDocumentNumber' => $tDocumentNumber,
            'tBrowseBchCode' => $tBrowseBchCode,
            'tSearchPDT'      => $tSearchPDT,
            'nRow'            => 10,
            'nPage'           => $nPage
        );

        $aGetDT     = $this->mTaxinvoicefc->FSaMTXFGetDTInTax($aWhere);
        $aPackData  = array(
            'nPage'         => $nPage,
            'aGetDT'        => $aGetDT,
            'tTypePage'     => 'Preview'
        );
        $aReturnData = array(
            'tContentPDT'         => $this->load->view('document/taxInvoicefc/wTaxInvoicefcDatatable',$aPackData, true),
        );
        echo json_encode($aReturnData);
    }

    //Update ???????????????????????????????????????????????????????????? ???????????????????????????????????????????????????????????????????????????
    public function FSxCTXFUpdateWhenApprove(){
        $tDocumentNo    = $this->input->post('tDocumentNo');
        $tBrowseBchCode    = $this->input->post('tBrowseBchCode');
        $tCusNameABB    = $this->input->post('tCusNameABB');
        $tTel           = $this->input->post('tTel');
        $tFax           = $this->input->post('tFax');
        $tAddress1      = $this->input->post('tAddress1');
        $tAddress2      = $this->input->post('tAddress2');
        $tSeq           = $this->input->post('tSeq');
        $tSeqNew        = $this->input->post('tSeqNew');
        $tNumberTax     = $this->input->post('tNumberTax');
        $tNumberTaxNew  = $this->input->post('tNumberTaxNew');
        $tBchCode       = $this->input->post('tBchCode');
        $tCstCode       = $this->input->post('tCstCode');
        $tCstName       = $this->input->post('tCstName');
        $tReason       = $this->input->post('tReason');
        $tReason       = $this->input->post('tReason');
        
        if(!empty($this->input->post('nStaDocAct'))){
            $nStaDocAct = $this->input->post('nStaDocAct');
        }else{
            $nStaDocAct = 1;
        }

        $aSet  = array(
            'FTAddName'     => $tCusNameABB,
            'FTAddTel'      => $tTel,
            'FTAddFax'      => $tFax,
            'FTAddV2Desc1'  => $tAddress1,
            'FTAddV2Desc2'  => $tAddress2,
            'tNumberTax'    => $tNumberTax,
            'tNumberTaxNew' => $tNumberTaxNew,
            'tDocumentNo'   => $tDocumentNo,
            'tBrowseBchCode'   => $tBrowseBchCode,
            'tTypeBusiness' => $this->input->post('tTypeBusiness'),
            'tBusiness'     => $this->input->post('tBusiness'),
            'tBchCode'      => $tBchCode,
            'tCstCode'      => $tCstCode,
            'tCstName'      => $tCstName,
            'tRemark'      => $tReason,
            'nStaDocAct'   => $nStaDocAct
        );

        $aWhere  = array(
            'FNAddSeqNo' => $tSeq
        );

        //????????????????????????????????????????????????????????????
        // $this->mTaxinvoicefc->FSaMTXFUpdateWhenApprove($aWhere,$aSet,'UPDATEADDRESS');

        //???????????????????????????????????????????????????????????????????????????????????????????????????????????????
        // echo $tSeqNew . '-' . $tSeq . '///' . $tNumberTaxNew . '-' . $tNumberTax;

        // if($tSeqNew != $tSeq || $tNumberTaxNew != $tNumberTax ){
            $this->mTaxinvoicefc->FSaMTXFUpdateWhenApprove($aWhere,$aSet,'UPDATEHDCST');
        // }

    }

    //??????????????????????????????????????????????????? ??????????????????
    public function FSxCTXFFindABB(){
            $tDocumentTopUp = $this->input->post('tDocumentTopUp');

            $this->mTaxinvoicefc->FSxMTXFFindABB($tDocumentTopUp);


    }


    public function FSvCTXFCallTaxInvoice($ptUsrCode , $nLngID ){
        try{

        if(isset($nLngID) && !empty($nLngID)){
            $this->session->set_userdata("tLangID", $nLngID);
        }else{
            $this->session->set_userdata("tLangID", 1);
        }

        $aDataUsr = $this->mTaxinvoicefc->FSaMTFXGetDataUsr4Pos($ptUsrCode);

        if(!empty($aDataUsr)){
                $this->load->model('favorite/favorite/mFavorites');
                $this->load->model('common/mNotification');

                $nMsgResp   = array('title' => "Home");
                $this->load->view ('common/wHeader',$nMsgResp);

                $this->JSxCCMSetSession4Pos($ptUsrCode);


                $this->load->view('common/wAutoloadViewTaxInvoice', $nMsgResp);
                $this->load->view('common/wFooter',array('nMsgResp' => $nMsgResp));
            }else{

                echo 'Not Found User';
            }

        }catch(Exception $Error){
             echo 'Error Parameter';
        }

    }


    private function JSxCCMSetSession4Pos($ptUsrCode){

                   $this->load->model('authen/login/mLogin');

                    $aDataUsr = $this->mTaxinvoicefc->FSaMTFXGetDataUsr4Pos($ptUsrCode);

                    // Create By : Napat(Jame) 12/05/2020
					$aDataUsrGroup = $this->mLogin->FSaMLOGGetDataUserLoginGroup($aDataUsr[0]['FTUsrCode']);
					$aDataUsrRole  = $this->mLogin->FSaMLOGGetUserRole($aDataUsr[0]['FTUsrCode']);
					if(empty($aDataUsrGroup[0]['FTMerCode']) && empty($aDataUsrGroup[0]['FTBchCode']) && empty($aDataUsrGroup[0]['FTShpCode'])){
						$aDataComp 			= $this->mLogin->FSaMLOGGetBch();

						$tUsrAgnCodeDefult  = '';
						$tUsrAgnNameDefult  = '';

						$tUsrMerCodeDefult  = '';
						$tUsrMerNameDefult  = '';

						$tUsrBchCodeDefult  = $aDataComp[0]['FTBchCode'];
						$tUsrBchNameDefult  = $aDataComp[0]['FTBchName'];
						$tUsrBchCodeMulti	= "'".$aDataComp[0]['FTBchCode']."'";
						$tUsrBchNameMulti	= "'".$aDataComp[0]['FTBchName']."'";
						$nUsrBchCount		= 0;

						$tUsrShpCodeDefult  = '';
						$tUsrShpNameDefult  = '';
						$tUsrShpCodeMulti 	= '';
						$tUsrShpNameMulti 	= '';
						$nUsrShpCount		= 0;

						$tUsrWahCodeDefult  = $aDataComp[0]['FTWahCode'];
						$tUsrWahNameDefult  = $aDataComp[0]['FTWahName'];
					}else{
						$tUsrAgnCodeDefult  = $aDataUsrGroup[0]['FTAgnCode'];
						$tUsrAgnNameDefult  = $aDataUsrGroup[0]['FTAgnName'];

						$tUsrMerCodeDefult  = $aDataUsrGroup[0]['FTMerCode'];
						$tUsrMerNameDefult  = $aDataUsrGroup[0]['FTMerName'];

						$tUsrBchCodeDefult  = $aDataUsrGroup[0]['FTBchCode'];
						$tUsrBchNameDefult  = $aDataUsrGroup[0]['FTBchName'];
						$tUsrBchCodeMulti 	= $this->mLogin->FStMLOGMakeArrayToString($aDataUsrGroup,'FTBchCode','value');
						$tUsrBchNameMulti 	= $this->mLogin->FStMLOGMakeArrayToString($aDataUsrGroup,'FTBchName','value');
						$nUsrBchCount		= $this->mLogin->FStMLOGMakeArrayToString($aDataUsrGroup,'FTBchCode','counts');

						$tUsrShpCodeDefult  = $aDataUsrGroup[0]['FTShpCode'];
						$tUsrShpNameDefult  = $aDataUsrGroup[0]['FTShpName'];
						$tUsrShpCodeMulti 	= $this->mLogin->FStMLOGMakeArrayToString($aDataUsrGroup,'FTShpCode','value');
						$tUsrShpNameMulti 	= $this->mLogin->FStMLOGMakeArrayToString($aDataUsrGroup,'FTShpName','value');
						$nUsrShpCount		= $this->mLogin->FStMLOGMakeArrayToString($aDataUsrGroup,'FTShpCode','counts');

						$tUsrWahCodeDefult  = $aDataUsrGroup[0]['FTWahCode'];
						$tUsrWahNameDefult  = $aDataUsrGroup[0]['FTWahName'];
					}
					$tUsrRoleMulti = $this->mLogin->FStMLOGMakeArrayToString($aDataUsrRole,'FTRolCode','value');
					$nUsrRoleLevel  = $this->mLogin->FSaMLOGGetUserRoleLevel($tUsrRoleMulti);


					// User Role
					$this->session->set_userdata("tSesUsrRoleCodeMulti", $tUsrRoleMulti);
					$this->session->set_userdata("nSesUsrRoleLevel", $nUsrRoleLevel);

					// Agency
					$this->session->set_userdata("tSesUsrAgnCode", $tUsrAgnCodeDefult);
					$this->session->set_userdata("tSesUsrAgnName", $tUsrAgnNameDefult);

					// Merchant
					$this->session->set_userdata("tSesUsrMerCode", $tUsrMerCodeDefult);
					$this->session->set_userdata("tSesUsrMerName", $tUsrMerNameDefult);

					// Branch
					$this->session->set_userdata("tSesUsrBchCodeDefault", $tUsrBchCodeDefult);
					$this->session->set_userdata("tSesUsrBchNameDefault", $tUsrBchNameDefult);
					$this->session->set_userdata("tSesUsrBchCodeMulti", $tUsrBchCodeMulti);
					$this->session->set_userdata("tSesUsrBchNameMulti", $tUsrBchNameMulti);
					$this->session->set_userdata("nSesUsrBchCount", $nUsrBchCount);

					// Shop
					$this->session->set_userdata("tSesUsrShpCodeDefault", $tUsrShpCodeDefult);
					$this->session->set_userdata("tSesUsrShpNameDefault", $tUsrShpNameDefult);
					$this->session->set_userdata("tSesUsrShpCodeMulti", $tUsrShpCodeMulti);
					$this->session->set_userdata("tSesUsrShpNameMulti", $tUsrShpNameMulti);
					$this->session->set_userdata("nSesUsrShpCount", $nUsrShpCount);

					// WaHouse
					$this->session->set_userdata("tSesUsrWahCode", $tUsrWahCodeDefult);
					$this->session->set_userdata("tSesUsrWahName", $tUsrWahNameDefult);

					$this->session->set_userdata('bSesLogIn',TRUE);
					$this->session->set_userdata("tSesUserCode", $aDataUsr[0]['FTUsrCode']);
					$this->session->set_userdata("tSesUsername", $aDataUsr[0]['FTUsrCode']);
					$this->session->set_userdata("tSesUsrDptName", $aDataUsr[0]['FTDptName']);
					$this->session->set_userdata("tSesUsrDptCode", $aDataUsr[0]['FTDptCode']);

					// Name User
					$this->session->set_userdata("tSesUsrUsername", $aDataUsr[0]['FTUsrName']);


					// New sessionID for document
					$this->session->set_userdata("tSesUsrImagePerson", $aDataUsr[0]['FTImgObj']);

					$this->session->set_userdata("tSesUsrInfo", $aDataUsr[0]);
					$this->session->set_userdata("tSesUsrGroup", $aDataUsrGroup);

					$tDateNow = date('Y-m-d H:i:s');
					$tSessionID = $aDataUsr[0]['FTUsrCode'].date('YmdHis', strtotime($tDateNow));
					$this->session->set_userdata("tSesSessionID", $tSessionID);
					$this->session->set_userdata("tSesSessionDate", $tDateNow);

					$nLangEdit = $this->session->userdata("tLangEdit");
					if($nLangEdit == ''){
						$this->session->set_userdata( "tLangEdit", $this->session->userdata("tLangID") );
					}

					// User level
					if(empty($aDataUsrGroup[0]['FTBchCode']) && empty($aDataUsrGroup[0]['FTShpCode'])){ // HQ level
						$this->session->set_userdata("tSesUsrLevel", "HQ");
					}
					if(!empty($aDataUsrGroup[0]['FTBchCode']) && empty($aDataUsrGroup[0]['FTShpCode'])){ // BCH level
						$this->session->set_userdata("tSesUsrLevel", "BCH");
					}
					if(!empty($aDataUsrGroup[0]['FTBchCode']) && !empty($aDataUsrGroup[0]['FTShpCode'])){ // SHP level
						$this->session->set_userdata("tSesUsrLevel", "SHP");
					}
					if(!empty($aDataUsrGroup[0]['FTBchCode']) && !empty($aDataUsrGroup[0]['FTMerCode'])){ // MER & SHP level
						$this->session->set_userdata("tSesUsrLevel", "SHP");
					}



					//??????????????? session ????????????????????? ???????????????????????????????????? ?????????????????? gencode ?????????????????????
					$this->session->set_userdata("tSesUsrBchCode", '99999');
					$this->session->set_userdata("tSesUsrShpCode", '88888');


    }

    //???????????????????????????????????????????????????????????????????????????????????????
    public function FSxCTAXCheckBranchInComp(){
        // $aPackData  = array(
        //     'tDocumentNumber' => $this->input->post('tDocCode')
        // );
        // $aGetHD      = $this->mTaxinvoicefc->FSaMTAXGetBchHD($aPackData);        
        // if($aGetHD['rtCode'] == 800){
        //     $tBCHCode = '';
        // }else{
        //     $tBCHCode = $aGetHD['raItems'][0]['FTBchCode'];
        // }
        $tDocBch = $this->input->post('tDocBch');
        $aReturnData = array(
            'tBCH'   => FCNtGetAddressBranch($tDocBch)
        );
        echo json_encode($aReturnData);
    }


     // Create By: Napat(Jame) 04/08/2021
    // Last Update : Napat(Jame) 16/09/2021
    public function FSaCTXFEventApvETax(){
        $tABBDocNo          = $this->input->post('ptABBDocNo');
        $tTaxDocNo          = $this->input->post('ptTaxDocNo');
        $tPosCode           = $this->input->post('ptPosCode');
        $tBchCode           = $this->input->post('ptBchCode');
        $tDocType           = $this->input->post('ptDocType');
        $aDataHDAddress     = $this->input->post('paDataHDAddress');
        $aDataHDCst         = $this->input->post('paDataHDCst');

        // Where Condition
        $aWhereCondition = array(
            'FTBchCode'     => $tBchCode,
            'FTXshDocNo'    => $tTaxDocNo
        );

        // Update Address
        $this->mTaxinvoicefc->FSxMTXFUpdAddrAndCst($aDataHDAddress,$aDataHDCst,$aWhereCondition);

        $aPackDataMQ = array(
            'tAbbDocNo' => $tABBDocNo,
            'tTaxDocNo' => $tTaxDocNo,
            'tBchCode'  => $tBchCode,
            'tPosCode'  => $tPosCode,
            'tDocType'  => $tDocType
        );
        $aRabbitMQ = $this->FSaCTXFEventSendMQETax($aPackDataMQ);
        echo json_encode($aRabbitMQ);

    }

    // Create By: Napat(Jame) 16/09/2021
    // ????????? MQ ETax
    public function FSaCTXFEventSendMQETax($paPackDataMQ){

        $tABBDocNo          = $paPackDataMQ['tAbbDocNo'];
        $tTaxDocNo          = $paPackDataMQ['tTaxDocNo'];
        $tPosCode           = $paPackDataMQ['tPosCode'];
        $tBchCode           = $paPackDataMQ['tBchCode'];
        $tDocType           = $paPackDataMQ['tDocType'];

        // Convert Document Type
        if( $tDocType == '1' || $tDocType == '4' ){        // ??????????????????????????? 1,4
            $tABBDocType        = "1"; // ABB
            $tFullTaxDocType    = "2"; // FullTax
        }else{                                              // ??????????????????????????? 5,9
            $tABBDocType        = "3"; // CN
            $tFullTaxDocType    = "4"; // CN-FullTax
        }

        // Where Condition ABB
        $aWhereABB = array(
            'FTBchCode'     => $tBchCode,
            'FTXshDocNo'    => $tABBDocNo
        );
        $bChkStaABB = $this->mTaxinvoicefc->FSbMTXFChkStaABBETaxApv($aWhereABB);

        // ????????? ABB ????????? iNet ??????????????????????????? ????????????????????????????????????
        if( $bChkStaABB ){
            // Send MQ ABB
            $aMQParams = [
                "queueName" => "EX_TxnSaleETax",
                "params" => [
                    "ptFunction"    => "SaleRef",
                    "ptSource"      => "AdaStoreBack",
                    "ptDest"        => "MQAdaLink",
                    "ptData"        => json_encode([
                        "ptProvider"    => "1",
                        "ptUserCode"    => $this->session->userdata("tSesUserCode"), // User Login
                        "ptBchCode"     => $tBchCode,
                        "ptPosCode"     => $tPosCode,
                        "ptDocType"     => $tABBDocType,
                        "ptDocNo"       => $tABBDocNo,
                        "ptRefDocType"  => "",
                        "ptDocRef"      => ""
                    ])
                ]
            ];
            FCNaRabbitMQInterface($aMQParams);
        }

        // Send MQ FULL TAX
        $aMQParamsFullTax = [
            "queueName" => "EX_TxnSaleETax",
            "params" => [
                "ptFunction"    => "SaleRef",
                "ptSource"      => "AdaStoreBack",
                "ptDest"        => "MQAdaLink",
                "ptData"        => json_encode([
                    "ptProvider"    => "1",
                    "ptUserCode"    => $this->session->userdata("tSesUserCode"), // User Login
                    "ptBchCode"     => $tBchCode,
                    "ptPosCode"     => $tPosCode,
                    "ptDocType"     => $tFullTaxDocType,
                    "ptDocNo"       => $tTaxDocNo,
                    "ptRefDocType"  => "",
                    "ptDocRef"      => ""
                ])
            ]
        ];
        return FCNaRabbitMQInterface($aMQParamsFullTax);
    }
    


}
