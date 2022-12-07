<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );
class Forms_controller extends MX_Controller {

    public function __construct() {
        parent::__construct ();
        $this->load->model('other/forms/Forms_model');
        date_default_timezone_set("Asia/Bangkok");
    }

    public function index($nFrmBrowseType,$tFrmBrowseOption){
        $nMsgResp = array('title'=>"Forms");
        $isXHR = isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtoupper($_SERVER['HTTP_X_REQUESTED_WITH']) === 'XMLHTTPREQUEST';
        if(!$isXHR){
            $this->load->view ( 'common/wHeader', $nMsgResp);
            $this->load->view ( 'common/wTopBar', array ('nMsgResp'=>$nMsgResp));
            $this->load->view ( 'common/wMenu', array ('nMsgResp'=>$nMsgResp));
        }
        $vBtnSave = FCNaHBtnSaveActiveHTML('forms/0/0'); //Load Html ของปุ่ม Save ที่เก็บ Session ปัจจุบัน
        $aAlwEventForms	= FCNaHCheckAlwFunc('forms/0/0');
        $this->load->view ( 'other/forms/wForms', array (
            'nMsgResp'          =>$nMsgResp,
            'vBtnSave'          =>$vBtnSave,
            'nFrmBrowseType'    =>$nFrmBrowseType,
            'tFrmBrowseOption'  =>$tFrmBrowseOption,
            'aAlwEventForms'   =>$aAlwEventForms
        ));
    }

    //Functionality : Function Call Page Forms List
    //Parameters : Ajax jForms()
    //Creator : 25/05/2018 wasin
    //Last Modified : -
    //Return : String View
    //Return Type : View
    public function FSvCFRMListPage(){
        $aAlwEventForms	= FCNaHCheckAlwFunc('forms/0/0');
        $aNewData  		    = array( 'aAlwEventForms' => $aAlwEventForms);
        $this->load->view('other/forms/wFormsList',$aNewData);
    }

    //Functionality : Function Call DataTables Forms List
    //Parameters : Ajax jForms()
    //Creator : 25/05/2018 wasin
    //Last Modified : -
    //Return : String View
    //Return Type : View
    public function FSvCFRMDataList(){
        $nPage  = $this->input->post('nPageCurrent');
        $tSearchAll = $this->input->post('tSearchAll');
        if($nPage == '' || $nPage == null){$nPage = 1;}else{$nPage = $this->input->post('nPageCurrent');}
        if(!$tSearchAll){$tSearchAll='';}

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

        $tAPIReq    = "";
        $tMethodReq = "GET";
        $aResList   = $this->Forms_model->FSaMFRMList($tAPIReq,$tMethodReq,$aData);
        $aAlwEvent = FCNaHCheckAlwFunc('forms/0/0'); //Controle Event

        $aGenTable  = array(
            'aAlwEventForms' => $aAlwEvent,
            'aDataList'     => $aResList,
            'nPage'         => $nPage,
            'tSearchAll'    => $tSearchAll
        );
        $this->load->view('other/forms/wFormsDataTable',$aGenTable);
    }

    //Functionality : Function Call Add Page Forms
    //Parameters : Ajax jForms()
    //Creator : 28/05/2018 wasin
    //Last Modified : -
    //Return : String View
    //Return Type : View
    public function FSvCFRMAddPage(){
        $nLangResort    = $this->session->userdata("tLangID");
        $nLangEdit      = $this->session->userdata("tLangEdit");
        $aData  = array(
            'FNLngID'   => $nLangEdit,
        );


        $aDataAdd = array(
            'aResult'   => array('rtCode'=>'99'),
            'tSesAgnCode'   => $this->session->userdata("tSesUsrAgnCode"),
            'tSesAgnName'   => $this->session->userdata("tSesUsrAgnName"),
        );


        $this->load->view('other/forms/wFormsAdd',$aDataAdd);
    }

    //Functionality : Function Call Edit Page Forms
    //Parameters : Ajax jForms()
    //Creator : 28/05/2018 wasin
    //Last Modified : -
    //Return : String View
    //Return Type : View
    public function FSvCFRMEditPage(){
        $tFrmCode       = $this->input->post('tFrmCode');
        $nLangResort    = $this->session->userdata("tLangID");
        $nLangEdit      = $this->session->userdata("tLangEdit");
        $aData  = array(
            'FTRfuCode' => $tFrmCode,
            'FNLngID'   => $nLangEdit
        );


        $tAPIReq        = "";
        $tMethodReq     = "GET";
        $aFrmData       = $this->Forms_model->FSaMFRMSearchByID($tAPIReq,$tMethodReq,$aData);


        if($aFrmData['rtCode']=='1'){
            
        $tHostFile = $aFrmData['raItems']['rtRfuFileName'];
        $oResult = $this->FSaCFRMCallAPIGetFile($tHostFile);

        $tAgnCode = $aFrmData['raItems']['rtAgnCode'];
        $tRfuCode = $aFrmData['raItems']['rtRfuCode'];
        $tRfsPath = $aFrmData['raItems']['rtRfsPath'];
        $tRfsFileName = $aFrmData['raItems']['rtRfsFileName'];
        
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
        $aFrmData['raItems']['rtRfuFileName'] = $tPathFile;
        }

        $aDataEdit = array(
            'aResult'   => $aFrmData,
        );
        $this->load->view('other/forms/wFormsAdd',$aDataEdit);
    }

    //Functionality : Function Create Selected
    //Parameters : Function Parameter
    //Creator : 28/05/2018 wasin
    //Last Modified : -
    //Return : String View
    //Return Type : View
    public function FSaCFRMDropdown($ptRntID,$ptIDname,$poData){
        //Parameters : $ptRntID = ข้อมูลที่ใช้เช็คทำ Selected(EDIT)
        //$ptIDname = ชื่อ ID กับ Name
        //$poData = ข้อมูลที่ใช้ทำ Dropdown
        $tDropdown  = "<select required class='selection-2 selectpicker form-control' id='".$ptIDname."' name='".$ptIDname."' >";
        if($poData['rtCode']=='1'){
            foreach($poData['raItems'] AS $key=>$aValue){
                $selected = ($ptRntID!='' && $ptRntID == $aValue['rtRsgCode'])? 'selected':'';
                $tDropdown .= "<option value='".$aValue['rtRsgCode']."' ".$selected.">".$aValue['rtRsgName']."</option>";
            }
        }
        $tDropdown  .= "</select>";
        return $tDropdown;
    }

    //Functionality : Event Add Forms
    //Parameters : Ajax jForms()
    //Creator : 28/05/2018 wasin
    //Last Modified : -
    //Return : Status Add Event
    //Return Type : String
    public function FSaCFRMAddEvent(){
        try{

            $aDataMaster    = array(
                'tIsAutoGenCode'        => $this->input->post('ocbFormsAutoGenCode'),
                'FTRfuCode'             => $this->input->post('oetFrmCode'),
                'FTRfuName'             => $this->input->post('oetFrmName'),
                'FTRfsCode'             => $this->input->post('oetFrmRfsCode'),
                'FTRfuRemark'           => $this->input->post('oetFrmRemark'),
                'FTRfuPath'             => $this->input->post('oetFrmRfsPath'),
                'FTRfuFormType'         => '2',
                'FTRfuStaAlwEdit'       => (!empty($this->input->post('ocbRfuStaAlwEdit'))) ? 1 : 2,
                'FTRfuStaUsrDef'        => (!empty($this->input->post('ocbRfuStaUsrDef'))) ? 1 : 2,
                'FTRfuStaUse'           => (!empty($this->input->post('ocbRfuStaUse'))) ? 1 : 2,
                'FDLastUpdOn'           => date('Y-m-d H:i:s'),
                'FDCreateOn'            => date('Y-m-d H:i:s'),
                'FTLastUpdBy'           => $this->session->userdata('tSesUsername'),
                'FTCreateBy'            => $this->session->userdata('tSesUsername'),
                'FNLngID'               => $this->session->userdata("tLangEdit"),
                'FTAgnCode'             => $this->input->post('oetFrmAgnCode'),
            );
            
            if($aDataMaster['tIsAutoGenCode'] == '1'){ 
                $aStoreParam = array(
                    "tTblName"   => 'TRPTRptFmtUsr',                           
                    "tDocType"   => 0,                                          
                    "tBchCode"   => "",                                 
                    "tShpCode"   => "",                               
                    "tPosCode"   => "",                     
                    "dDocDate"   => date("Y-m-d")       
                );
                $aAutogen   				= FCNaHAUTGenDocNo($aStoreParam);
                $aDataMaster['FTRfuCode']   = $aAutogen[0]["FTXxhDocNo"];
            }
          
            $oCountDup  = $this->Forms_model->FSoMFRMCheckDuplicate($aDataMaster['FTRfuCode']);
            $nStaDup    = $oCountDup[0]->counts;
            if($nStaDup == 0){
                $this->db->trans_begin();


                $tFrmRfsPath = $this->input->post('oetFrmRfsPath');
                $aFile      = @$_FILES['oetFrmRtuFile'];
                if(!empty($aFile) && !empty($aFile['name'])){
                    $tUrlAddr   = $this->Forms_model->FCNaMFRMGetObjectUrl();
                    $tUrlApi    = $tUrlAddr.'/Upload/File';
                    $aAPIKey    = array(
                        'tKey'      => 'X-Api-Key',
                        'tValue'    => '12345678-1111-1111-1111-123456789410'
                    );
                    $tPath = $aFile['name'];
                    $tExt = pathinfo($tPath, PATHINFO_EXTENSION);
                    $tFileName = basename($tPath,".".$tExt);
    
                    $aParam     = array(
                        'ptContent'		=> new CURLFILE($aFile['tmp_name'],$aFile['type'],$aFile['name']),
                        'ptRef1'        => 'AdaPos5.0BigC-Donjai',
                        'ptRef2'        => $tFrmRfsPath.'/'.$aDataMaster['FTAgnCode'].'/'.$aDataMaster['FTRfuCode'],
                        'ptRefName'     => $tFileName
                    );
    
                    $oReuslt = FCNaHCallAPIBasic($tUrlApi,'POST',$aParam,$aAPIKey,'file');
                }else{
                    $oReuslt['rtCode']= '99';
                    $oReuslt['rtDesc']= 'ไม่พบข้อมูลไฟล์';
                }

                if($oReuslt['rtCode'] != "99" ){
                $aDataMaster['FTRfuFileName'] = $oReuslt['rtData'];
                // $aDataMaster['FTRfuPath'] = $oReuslt['rtData'];
                $aStaFrmMaster  = $this->Forms_model->FSaMFRMAddUpdateMaster($aDataMaster);
                $aStaFrmLang    = $this->Forms_model->FSaMFRMAddUpdateLang($aDataMaster);
                if($aDataMaster['FTRfuStaUsrDef']=='1'){
                $aUpdStaDefUsr  = $this->Forms_model->FSaMFRMAddUpdateStaDef($aDataMaster);
                }
                if($this->db->trans_status() === false){
                    $this->db->trans_rollback();
                    $aReturn = array(
                        'nStaEvent'    => '900',
                        'tStaMessg'    => "Unsucess Add Event"
                    );
                }else{
                    $this->db->trans_commit();
                    $aReturn = array(
                        'nStaCallBack'	=> $this->session->userdata('tBtnSaveStaActive'),
                        'tCodeReturn'	=> $aDataMaster['FTRfuCode'],
                        'nStaEvent'	    => '1',
                        'tStaMessg'		=> 'Success Add Event'
                    );
                }
            }else{
                $aReturn = array(
                    'nStaEvent'    => $oReuslt['rtCode'],
                    'tStaMessg'    => $oReuslt['rtDesc']
                );
            }

            }else{
                $aReturn = array(
                    'nStaEvent'    => '801',
                    'tStaMessg'    => "Data Code Duplicate"
                );
            }
            echo json_encode($aReturn);
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Event Edit Forms
    //Parameters : Ajax jForms()
    //Creator : 28/05/2018 wasin
    //Last Modified : -
    //Return : Status Add Event
    //Return Type : String
    public function FSaCFRMEditEvent(){
        try{

            $aDataMaster    = array(
                'FTRfuCode' => $this->input->post('oetFrmCode'),
                'FTRfuName' => $this->input->post('oetFrmName'),
                'FTRfsCode'   => $this->input->post('oetFrmRfsCode'),
                'FTRfuRemark'  => $this->input->post('oetFrmRemark'),
                'FTRfuFileName'  => $this->input->post('oetRfuFileName'),
                'FTRfuPath'  => $this->input->post('oetFrmRfsPath'),
                'FTRfuFormType' => '2',
                'FTRfuStaAlwEdit'       => (!empty($this->input->post('ocbRfuStaAlwEdit'))) ? 1 : 2,
                'FTRfuStaUsrDef'        => (!empty($this->input->post('ocbRfuStaUsrDef'))) ? 1 : 2,
                'FTRfuStaUse'           => (!empty($this->input->post('ocbRfuStaUse'))) ? 1 : 2,
                'FDLastUpdOn'   => date('Y-m-d H:i:s'),
                'FDCreateOn'    => date('Y-m-d H:i:s'),
                'FTLastUpdBy'   => $this->session->userdata('tSesUsername'),
                'FTCreateBy'    => $this->session->userdata('tSesUsername'),
                'FNLngID'       => $this->session->userdata("tLangEdit"),
                'FTAgnCode'     => $this->input->post('oetFrmAgnCode'),
            );
     
            $tFrmRfsPath = $this->input->post('oetFrmRfsPath');
            $aFile      = @$_FILES['oetFrmRtuFile'];
            if(!empty($aFile) && !empty($aFile['name'])){
                $tUrlAddr   = $this->Forms_model->FCNaMFRMGetObjectUrl();
                $tUrlApi    = $tUrlAddr.'/Upload/File';
                $aAPIKey    = array(
                    'tKey'      => 'X-Api-Key',
                    'tValue'    => '12345678-1111-1111-1111-123456789410'
                );
                $tPath = $aFile['name'];
                $tExt = pathinfo($tPath, PATHINFO_EXTENSION);
                $tFileName = basename($tPath,".".$tExt);

                $aParam     = array(
                    'ptContent'		=> new CURLFILE($aFile['tmp_name'],$aFile['type'],$aFile['name']),
                    'ptRef1'        => 'AdaPos5.0BigC-Donjai',
                    'ptRef2'        => $tFrmRfsPath.'/'.$aDataMaster['FTAgnCode'].'/'.$aDataMaster['FTRfuCode'],
                    'ptRefName'     => $tFileName
                );

                $oReuslt = FCNaHCallAPIBasic($tUrlApi,'POST',$aParam,$aAPIKey,'file');
                
            }else{
                $oReuslt['rtCode']= '99';
                $oReuslt['rtDesc']= 'ไม่พบข้อมูลไฟล์';
            }
         
            if($oReuslt['rtCode'] != "99" ){
                $aDataMaster['FTRfuFileName'] = $oReuslt['rtData'];
                // $aDataMaster['FTRfuPath'] = $oReuslt['rtData'];
            }

                $this->db->trans_begin();
 
                $aStaFrmMaster  = $this->Forms_model->FSaMFRMAddUpdateMaster($aDataMaster);
                $aStaFrmLang    = $this->Forms_model->FSaMFRMAddUpdateLang($aDataMaster);
                if($aDataMaster['FTRfuStaUsrDef']=='1'){
                    $aUpdStaDefUsr  = $this->Forms_model->FSaMFRMAddUpdateStaDef($aDataMaster);
                }

                if($this->db->trans_status() === false){
                    $this->db->trans_rollback();
                    $aReturn = array(
                        'nStaEvent'    => '900',
                        'tStaMessg'    => "Unsucess Edit Event"
                    );
                }else{
                    $this->db->trans_commit();
                    $aReturn = array(
                        'nStaCallBack'	=> $this->session->userdata('tBtnSaveStaActive'),
                        'tCodeReturn'	=> $aDataMaster['FTRfuCode'],
                        'nStaEvent'	    => '1',
                        'tStaMessg'		=> 'Success Add Event'
                    );
                }
       


            echo json_encode($aReturn);
        }catch(Exception $Error){
            echo $Error;
        }
        
    }

    //Functionality : Event Delete Forms
    //Parameters : Ajax jForms()
    //Creator : 28/05/2018 wasin
    //Last Modified : -
    //Return : Status Delete Event
    //Return Type : String
    public function FSaCFRMDeleteEvent(){
        $tIDCode = $this->input->post('tIDCode');


        $aDataMaster = array(
            'FTRfuCode' => $tIDCode
        );
        $tAPIReq        = 'API/Forms/Delete';
        $tMethodReq     = 'POST';
        $aResDel        = $this->Forms_model->FSnMFRMDel($tAPIReq,$tMethodReq,$aDataMaster);
        $nNumRowFrmLoc  = $this->Forms_model->FSnMLOCGetAllNumRow();

        if($nNumRowFrmLoc !== false){
            $aReturn    = array(
                'nStaEvent'     => $aResDel['rtCode'],
                'tStaMessg'     => $aResDel['rtDesc'],
                'nNumRowFrmLoc' => $nNumRowFrmLoc
            );
            echo json_encode($aReturn);
        }else{
            echo "database error";
        }
    }


    //Functionality : Event Delete Forms
    //Parameters : Ajax jForms()
    //Creator : 28/05/2018 wasin
    //Last Modified : -
    //Return : Status Delete Event
    //Return Type : String
    public function FSaCFRMStdGetUrlEditForm(){
        try{
            $ptRfsCode = $this->input->post('ptRfsCode');
            $tSQL = $this->FSaCFRMGetInfoTableForm($ptRfsCode);
            $tSQL .= " ORDER BY HD.FDCreateOn DESC";
            $aResult = $this->Forms_model->FSaMFRMStdGetUrlEditForm($tSQL);
            if($aResult['rtCode']=='1'){
                $tBchCode = $aResult['raItems']['rtBchCode'];
                $aResult['raItems']['rtAddressBranch'] =  FCNtGetAddressBranch($tBchCode);
            }
           
            echo json_encode($aResult);
        }catch(Exception $Error){
            echo $Error;
        }
    }

    //Functionality : Event Delete Forms
    //Parameters : Ajax jForms()
    //Creator : 28/05/2018 wasin
    //Last Modified : -
    //Return : Status Delete Event
    //Return Type : String
    public function FSaCFRMGetInfoTableForm($rtDataFtsCode){

            $aDataTableinfo = array(
                '00001' => 'SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXshDocNo AS rtDocNo,
                                HD.FTXshGndText AS FTXshGndText
                                FROM TPSTTaxHD HD WITH(NOLOCK)
                                WHERE HD.FNXshDocType = 4',
                '00002' => 'SELECT
                                TOP 1 HD.FTBchCode AS rtBchCode,
                                HD.FTXshDocNo AS rtDocNo,
                                HD.FTXshGndText AS FTXshGndText,
                                RSN_L.FTRsnName
                            FROM
                                TPSTTaxHD HD WITH (NOLOCK)
                            LEFT JOIN TCNMRsn_L RSN_L WITH (NOLOCK) ON HD.FTRsnCode = RSN_L.FTRsnName AND RSN_L.FNLngID = 1
                            WHERE
                                HD.FNXshDocType = 5',
                '00003' => 'SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXshDocNo AS rtDocNo
                                FROM TPSTSalHD HD WITH(NOLOCK)',
                '00004' => 'SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXphDocNo AS rtDocNo
                                FROM TCNTPdtAdjPriHD HD WITH(NOLOCK)',
                '00005' => 'SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTPmhDocNo AS rtDocNo
                                FROM TCNTPdtPmtHD HD WITH(NOLOCK)',
                '00006' => 'SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXchDocNo AS rtDocNo
                                FROM TCNTPdtAdjCostHD HD WITH(NOLOCK)',
                '00007' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTAjhDocNo AS rtDocNo
                                FROM TCNTPdtAdjStkHD HD WITH(NOLOCK)
                                WHERE HD.FTAjhDocType = '1' ",
                '00008' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTAjhDocNo AS rtDocNo
                                FROM TCNTPdtAdjStkHD HD WITH(NOLOCK)
                                WHERE HD.FTAjhDocType = '2' ",
                '00009' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTAjhDocNo AS rtDocNo
                                FROM TCNTPdtAdjStkHD HD WITH(NOLOCK)
                                WHERE HD.FTAjhDocType = '3' AND ISNULL(HD.FTAjhShopTo,'')!='' AND ISNULL(HD.FTAjhPosTo,'')!='' ",
                '00010' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTCvhDocNo AS rtDocNo
                                FROM TFNTCrdVoidHD HD WITH(NOLOCK)
                                WHERE HD.FTCvhDocType = '6' ",
                '00011' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTCihDocNo AS rtDocNo
                                FROM TFNTCrdImpHD HD WITH(NOLOCK)
                                WHERE HD.FTCihDocType = '7'",
                '00012' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXshDocNo AS rtDocNo
                                FROM TFNTCrdShiftHD HD WITH(NOLOCK)
                                WHERE HD.FNXshDocType = '1'",
                '00013' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXshDocNo AS rtDocNo
                                FROM TFNTCrdTopUpHD HD WITH(NOLOCK)
                                WHERE HD.FNXshDocType = '11'",
                '00014' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXshDocNo AS rtDocNo
                                FROM TFNTCrdShiftHD HD WITH(NOLOCK)
                                WHERE HD.FNXshDocType = '2'",
                '00015' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTCvhDocNo AS rtDocNo
                                FROM TFNTCrdVoidHD HD WITH(NOLOCK)
                                WHERE HD.FTCvhDocType = '5' ",
                '00016' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXshDocNo AS rtDocNo
                                FROM TFNTCrdTopUpHD HD WITH(NOLOCK)
                                WHERE HD.FNXshDocType = '3'",
                '00017' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTRdhDocNo AS rtDocNo
                                FROM TARTRedeemHD HD WITH(NOLOCK)
                                WHERE HD.FTRdhDocType = '1'",
                '00018' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTCphDocNo AS rtDocNo
                                FROM TFNTCouponHD HD WITH(NOLOCK) ",
                '00019' => "SELECT
                                TOP 1 HD.FTBchCode AS rtBchCode,
                                HD.FTBdhDocNo AS rtDocNo
                            FROM
                                TFNTBnkDplHD HD WITH (NOLOCK)",
                '00020' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TCNTPdtTbxHD HD WITH(NOLOCK) ",
                '00021' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXphDocNo AS rtDocNo
                                FROM TAPTPiHD HD WITH(NOLOCK) ",
                '00022' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXphDocNo AS rtDocNo
                                FROM TAPTPoHD HD WITH(NOLOCK) ",
                '00023' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TCNTPdtTwsHD HD WITH(NOLOCK)
                                WHERE HD.FTXthDocType= '1' ",
                '00024' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TVDTPdtTwxHD HD WITH(NOLOCK)
                                WHERE HD.FTXthDocType='1' ",
                '00025' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TCNTPdtTboHD HD WITH(NOLOCK) ",
                '00026' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TCNTPdtTbiHD HD WITH(NOLOCK)
                                WHERE HD.FNXthDocType = '5' ",
                '00027' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TCNTPdtTwiHD HD WITH(NOLOCK)
                                WHERE HD.FNXthDocType = '5' ",
                '00028' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TCNTPdtTwiHD HD WITH(NOLOCK)
                                WHERE HD.FNXthDocType = '1' ",
                '00029' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TVDTPdtTwxHD HD WITH(NOLOCK)
                                WHERE HD.FTXthDocType='2' ",
                '00030' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TCNTPdtTwoHD HD WITH (NOLOCK)
                                WHERE HD.FNXthDocType = 4",
                '00031' => "SELECT TOP 1 
                                HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                                FROM TCNTPdtTwoHD HD WITH (NOLOCK)
                                WHERE HD.FNXthDocType = 2",
                '00032' => "SELECT
                                TOP 1 HD.FTBchCode AS rtBchCode,
                                HD.FTPmhDocNo AS rtDocNo
                            FROM
                                TFNTCrdPmtHD HD WITH (NOLOCK)
                            WHERE
                                HD.FTPmhDocType = '2'",
                '00033' => "SELECT TOP 1 
                               HD.FTBchCode AS rtBchCode,
                               HD.FTAjhDocNo AS rtDocNo
                               FROM TCNTPdtAdjStkHD HD WITH(NOLOCK)
                               WHERE HD.FTAjhDocType = '3' ",
                '00034' => "SELECT
                                TOP 1 HD.FTBchCode AS rtBchCode,
                                HD.FTXshDocNo AS rtDocNo,
                                CONVERT(VARCHAR(10),HD.FDXshDocDate,121) AS FDXshDocDate,
	                            CONVERT(VARCHAR(10),HD.FDXshDocDate,108) AS FDXshDocTime
                            FROM
                                TARTSoHD HD WITH (NOLOCK) ",
                '00035' => "SELECT
                                TOP 1 HD.FTBchCode AS rtBchCode,
                                HD.FTXphDocNo AS rtDocNo,
                                HD.FTXphGndText AS rtGndText
                            FROM
                                TAPTPcHD HD WITH (NOLOCK) ",
                '00036' => "SELECT
                                TOP 1 HD.FTBchCode AS rtBchCode,
                                HD.FTXthDocNo AS rtDocNo
                            FROM
                                 TCNTPdtTwxHD HD WITH (NOLOCK) ",
                '00037' => "SELECT TOP 1 
                            HD.FTBchCode AS rtBchCode,
                            HD.FTXthDocNo AS rtDocNo
                            FROM TVDTPdtTwxHD HD WITH(NOLOCK)
                            WHERE HD.FTXthDocType='1' ",

            );

            return $aDataTableinfo[$rtDataFtsCode];

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
