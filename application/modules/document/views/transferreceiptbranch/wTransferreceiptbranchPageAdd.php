<style>
    fieldset.scheduler-border {
        border      : 1px groove #ffffffa1 !important;
        padding     : 0 20px 20px 20px !important;
        margin      : 0 0 10px 0 !important;
    }

    legend.scheduler-border {
        text-align      : left !important;
        width           : auto;
        padding         : 0 5px;
        border-bottom   : none;
        font-weight     : bold;
    }
</style>

<?php
    $tSesUsrLevel   = $this->session->userdata('tSesUsrLevel');
    if(isset($aDataDocHD) && $aDataDocHD['rtCode'] == "1"){ 
        $tTBIRoute              = "docTBIEventEdit";
        // $tTBICompCode           = $tCmpCode;
        $nTBIAutStaEdit         = 1;
        $tTBIStaApv             = $aDataDocHD['raItems']['FTXthStaApv'];
        $tTBIStaDoc             = $aDataDocHD['raItems']['FTXthStaDoc'];
        $tTBIStaPrcStk          = $aDataDocHD['raItems']['FTXthStaPrcStk'];
        $nTBIStaDocAct          = $aDataDocHD['raItems']['FNXthStaDocAct'];
        $tTBIStaDelMQ           = $aDataDocHD['raItems']['FTXthStaDelMQ'];
        $tTBIBchCode            = $aDataDocHD['raItems']['FTBchCode'];
        $tTBIBchName            = $aDataDocHD['raItems']['FTBchName'];
        $tTBIDptCode            = $aDataDocHD['raItems']['FTDptCode'];
        $tTBIUsrCode            = $aDataDocHD['raItems']['FTXthApvCode'];
        $tTBIDocNo              = $aDataDocHD['raItems']['FTXthDocNo'];
        $dTBIDocDate            = date("Y-m-d",strtotime($aDataDocHD['raItems']['FDXthDocDate']));
        $dTBIDocTime            = date("H:i:s",strtotime($aDataDocHD['raItems']['FDXthDocDate']));
        $tTBICreateBy           = $aDataDocHD['raItems']['FTCreateBy'];
        $tTBIUsrNameCreateBy    = $aDataDocHD['raItems']['FTUsrName'];
        $tTBIApvCode            = $aDataDocHD['raItems']['FTXthApvCode'];
        $tTBIUsrNameApv         = $aDataDocHD['raItems']['FTUsrName'];
        $tTBIDocType            = $aDataDocHD['raItems']['FNXthDocType'];
        // $tTBIRsnType            = $aDataDocHD['raItems']['FTXthTypRefFrm'];
        $tTBIVATInOrEx          = $aDataDocHD['raItems']['FTXthVATInOrEx'];
        // $tTBIMerCode            = $aDataDocHD['raItems']['FTXthMerCode'];

        $tTBIBchCodeFrm         = $aDataDocHD['raItems']['FTBchCodeFrom'];
        $tTBIBchNameFrm         = $aDataDocHD['raItems']['FTBchNameFrom'];

        $tTBIBchCodeTo          = $aDataDocHD['raItems']['FTBchCodeTo'];
        $tTBIBchNameTo          = $aDataDocHD['raItems']['FTBchNameTo'];

        // $tTBIShopFrm            = $aDataDocHD['raItems']['FTXthShopFrm'];
        // $tTBIShopTo             = $aDataDocHD['raItems']['FTXthShopTo'];
        // $tTBIShopName           = $aDataDocHD['raItems']['FTShpName'];
        // $tTBIShopNameTo          = $aDataDocHD['raItems']['ShpNameTo'];
        // $tTBIWhFrm              = $aDataDocHD['raItems']['FTXthWhFrm'];
        // $tTBIWhTo               = $aDataDocHD['raItems']['FTXthWhTo'];
        // $tTBIWhName             = $aDataDocHD['raItems']['FTWahName'];

        $tTBIWhCodeTo           = $aDataDocHD['raItems']['FTWahCodeTo'];
        $tTBIWhNameTo           = $aDataDocHD['raItems']['FTWahNameTo'];

        // $tTBIPosFrm             = $aDataDocHD['raItems']['FTXthPosFrm'];
        // $tTBIPosTo              = $aDataDocHD['raItems']['FTXthPosTo'];
        $tTBISplCode            = $aDataDocHD['raItems']['FTSplCode'];
        $tTBISplName            = $aDataDocHD['raItems']['FTSplName'];
        $tTBIOther              = $aDataDocHD['raItems']['FTXthOther'];
        $tTBIRefExt             = $aDataDocHD['raItems']['FTXthRefExt'];
        $tTBIRefExtDate         = $aDataDocHD['raItems']['FDXthRefExtDate'];
        $tTBIRefInt             = $aDataDocHD['raItems']['FTXthRefInt'];
        $tTBIRefIntDate         = $aDataDocHD['raItems']['FDXthRefIntDate'];
        $tTBIDocPrint           = $aDataDocHD['raItems']['FNXthDocPrint'];
        $tTBIRmk                = $aDataDocHD['raItems']['FTXthRmk'];
        $tTBIRsnCode            = $aDataDocHD['raItems']['FTRsnCode'];
        $tTBIRsnName            = $aDataDocHD['raItems']['FTRsnName'];

        $tTBICtrName            = $aDataDocHD['raItems']['FTXthCtrName'];
        $dTBITnfDate            = $aDataDocHD['raItems']['FDXthTnfDate'];
        $tTBIRefTnfID           = $aDataDocHD['raItems']['FTXthRefTnfID'];
        $tTBIRefVehID           = $aDataDocHD['raItems']['FTXthRefVehID'];
        $tTBIQtyAndTypeUnit     = $aDataDocHD['raItems']['FTXthQtyAndTypeUnit'];
        $nTBIShipAdd            = $aDataDocHD['raItems']['FNXthShipAdd'];
        $tTBIViaCode            = $aDataDocHD['raItems']['FTViaCode'];
        $tTBIViaName            = $aDataDocHD['raItems']['FTViaName'];


        $thRsnType              = $aDataDocHD['raItems']['FTXthRsnType'];
        $nStaUploadFile         = 2;
    }else{
        $tTBIRoute              = "docTBIEventAdd";
        // $tTBICompCode           = $tCmpCode;
        $nTBIAutStaEdit         = 0;
        $tTBIStaApv             = "";
        $tTBIStaDoc             = "";
        $tTBIStaPrcStk          = "";
        $nTBIStaDocAct          = "";
        $tTBIStaDelMQ           = "";
        $tTBIBchCode            = $this->session->userdata('tSesUsrBchCodeDefault');
        $tTBIBchName            = $this->session->userdata('tSesUsrBchNameDefault');
        $tTBIDptCode            = $tDptCode;
        $tTBIUsrCode            = $this->session->userdata('tSesUsername');
        $tTBIDocNo              = "";
        $dTBIDocDate            = "";
        $dTBIDocTime            = date('H:i');
        $tTBICreateBy           = $this->session->userdata('tSesUsrUsername');
        $tTBIUsrNameCreateBy    = $this->session->userdata('tSesUsrUsername');
        $tTBIApvCode            = "";
        $tTBIUsrNameApv         = "";
        $tTBIDocType            = "";
        // $tTBIRsnType            = "";
        $tTBIVATInOrEx          = 1;
        // $tTBIMerCode            = "";

        $tTBIBchCodeFrm         = "";
        $tTBIBchNameFrm         = "";
        $tTBIBchCodeTo          = $this->session->userdata('tSesUsrBchCodeDefault');
        $tTBIBchNameTo          = $this->session->userdata('tSesUsrBchNameDefault');

        // $tTBIShopFrm            = "";
        // $tTBIShopTo             = "";
        // $tTBIShopName           = "";
        // $tTBIShopNameTo         = "";
        // $tTBIWhFrm              = "";
        // $tTBIWhTo               = "";
        // $tTBIWhName             = "";
        
        $tTBIWhCodeTo           = "";
        $tTBIWhNameTo           = "";
        // $tTBIPosFrm             = "";
        // $tTBIPosTo              = "";
        $tTBISplCode            = "";
        $tTBISplName            = "";
        $tTBIOther              = "";
        $tTBIRefExt             = "";
        $tTBIRefExtDate         = "";
        $tTBIRefInt             = "";
        $tTBIRefIntDate         = "";
        $tTBIDocPrint           = "0";
        $tTBIRmk                = "";
        $tTBIRsnCode            = "";
        $tTBIRsnName            = "";

        $tTBICtrName            = "";
        $dTBITnfDate            = "";
        $tTBIRefTnfID           = "";
        $tTBIRefVehID           = "";
        $tTBIQtyAndTypeUnit     = "";
        $nTBIShipAdd            = "";
        $tTBIViaCode            = "";
        $tTBIViaName            = "";
        $thRsnType              = "3";
        $nStaUploadFile         = 1;
    }

    $bIsApv         = empty($tTBIStaApv) ? false : true;
    $bIsCancel      = ($tTBIStaDoc == "3") ? true : false;
    $bIsApvOrCancel = ($bIsApv || $bIsCancel);
?>
<form id="ofmTransferreceiptFormAdd" class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data">
    <button style="display:none" type="submit" id="obtSubmitTransferreceipt" onclick="JSxTransferreceiptEventAddEdit('<?=$tTBIRoute?>')"></button>

    <input type="hidden" id="ohdBaseUrl"                name="ohdBaseUrl"                   value="<?=base_url();?>">
    <input type="hidden" id="ohdTBIRoute"               name="ohdTBIRoute"                  value="<?=$tTBIRoute;?>">
    <input type="hidden" id="ohdTBICheckClearValidate"  name="ohdTBICheckClearValidate"     value="0">
    <input type="hidden" id="ohdTBICheckSubmitByButton" name="ohdTBICheckSubmitByButton"    value="0">
    <input type="hidden" id="ohdTBIAutStaEdit"          name="ohdTBIAutStaEdit"             value="<?=$nTBIAutStaEdit;?>">
    <input type="hidden" id="ohdTBIStaApv"              name="ohdTBIStaApv"                 value="<?=$tTBIStaApv;?>">
    <input type="hidden" id="ohdTBIStaDoc"              name="ohdTBIStaDoc"                 value="<?=$tTBIStaDoc;?>">
    <input type="hidden" id="ohdTBIStaPrcStk"           name="ohdTBIStaPrcStk"              value="<?=$tTBIStaPrcStk;?>">
    <input type="hidden" id="ohdTBIStaDelMQ"            name="ohdTBIStaDelMQ"               value="<?=$tTBIStaDelMQ;?>">
    <input type="hidden" id="ohdTBISesUsrBchCode"       name="ohdTBISesUsrBchCode"          value="<?=$this->session->userdata("tSesUsrBchCode");?>">
    <!-- <input type="hidden" id="ohdTBIBchCode"             name="ohdTBIBchCode"                value="<?=$tTBIBchCode;?>"> -->
    <input type="hidden" id="ohdTBIDptCode"             name="ohdTBIDptCode"                value="<?=$tTBIDptCode;?>">
    <input type="hidden" id="ohdTBIUsrCode"             name="ohdTBIUsrCode"                value="<?=$tTBIUsrCode;?>">
    <input type="hidden" id="ohdTBIApvCodeUsrLogin"     name="ohdTBIApvCodeUsrLogin"        value="<?=$tTBIUsrCode;?>">
    <input type="hidden" id="ohdTBILangEdit"            name="ohdTBILangEdit"               value="<?=$this->session->userdata("tLangEdit");?>">
    <input type="hidden" id="ohdTBIFrmSplInfoVatInOrEx" name="ohdTBIFrmSplInfoVatInOrEx"    value="<?=$tTBIVATInOrEx?>">
    <input type="hidden" id="ohdTBIFrmDocType"          name="ohdTBIFrmDocType"             value="<?=$tTBIDocType?>">

    <!-- ข้อมูลสำหรับ Browse Product -->
    <input type="hidden" id="ohdTBIUsrLevel"            name="ohdTBIUsrLevel"               value="<?=$this->session->userdata("tSesUsrLevel");?>">
    <input type="hidden" id="ohdTBIShpCode"             name="ohdTBIShpCode"                value="<?=$this->session->userdata("tSesUsrShpCodeDefault");?>">
    <input type="hidden" id="ohdTBIMerCode"             name="ohdTBIMerCode"                value="<?=$this->session->userdata("tSesUsrMerCode");?>">
    
    <div class="row">
        <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3">
            <!-- Panel รหัสเอกสารและสถานะเอกสาร -->
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div id="odvHeadStatus" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIDocument'); ?></label>
                    <a class="xCNMenuplus" role="button" data-toggle="collapse" href="#odvTBIDataStatusInfo" aria-expanded="true">
                        <i class="fa fa-plus xCNPlus"></i>
                    </a>
                </div>
                <div id="odvTBIDataStatusInfo" class="panel-collapse collapse in" role="tabpanel">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="form-group xCNHide" style="text-align: right;">
                                    <label class="xCNTitleFrom "><?php echo language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIApproved'); ?></label>
                                </div>
                                <input type="hidden" value="0" id="ohdCheckTBISubmitByButton" name="ohdCheckTBISubmitByButton"> 
                                <input type="hidden" value="0" id="ohdCheckTBIClearValidate" name="ohdCheckTBIClearValidate"> 
                                <label class="xCNLabelFrm"><span style = "color:red">*</span><?php echo language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIDocNo'); ?></label>
                                <?php if(empty($tTBIDocNo)):?>
                                    <div class="form-group">
                                        <label class="fancy-checkbox">
                                            <input type="checkbox" id="ocbTBIStaAutoGenCode" name="ocbTBIStaAutoGenCode" maxlength="1" checked="true" value="1">
                                            <span><?=language('document/rentalproductpriceadjustmentlocker/rentalproductpriceadjustmentlocker', 'tTBIAutoGenCode'); ?></span>
                                        </label>
                                    </div>
                                <?php endif;?>

                                <!-- เลขรหัสเอกสาร -->
                                <div class="form-group" style="cursor:not-allowed">
                                    <input 
                                        type="text"
                                        class="form-control xWTooltipsBT xCNInputWithoutSpcNotThai xCNInputWithoutSingleQuote"
                                        id="oetTBIDocNo"
                                        name="oetTBIDocNo"
                                        maxlength="20"
                                        value="<?=$tTBIDocNo;?>"
                                        data-validate="<?=language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIPlsEnterOrRunDocNo'); ?>"
                                        data-validate-duplicate="<?=language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIPlsDocNoDuplicate'); ?>"
                                        placeholder="<?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIDocNo');?>"
                                        style="pointer-events:none"
                                        readonly
                                    >
                                    <input type="hidden" id="ohdTBICheckDuplicateCode" name="ohdTBICheckDuplicateCode" value="2">
                                </div>

                                <!-- วันที่ในการออกเอกสาร -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><span style="color:red">*</span><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIDocDate');?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNDatePicker xCNInputMaskDate"
                                            id="oetTBIDocDate"
                                            name="oetTBIDocDate"
                                            value="<?=$dTBIDocDate;?>"
                                            data-validate-required="<?=language('document/transferreceiptbranch/transferreceiptbranch', 'tASTPlsEnterDocDate');?>"
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtTBIDocDate" type="button" class="btn xCNBtnDateTime xCNApvOrCanCelDisabled"><img class="xCNIconCalendar"></button>
                                        </span>
                                    </div>
                                </div>

                                <!-- เวลาในการออกเอกสาร -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><span style="color:red">*</span><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIDocTime');?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNTimePicker"
                                            id="oetTBIDocTime"
                                            name="oetTBIDocTime"
                                            value="<?=$dTBIDocTime;?>"
                                            data-validate-required="<?=language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIPlsEnterDocTime');?>"
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtTBIDocTime" type="button" class="btn xCNBtnDateTime xCNApvOrCanCelDisabled"><img class="xCNIconCalendar"></button>
                                        </span>
                                    </div>
                                </div>
                                
                                <!-- ผู้สร้างเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBICreateBy'); ?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <input type="hidden" id="ohdTBICreateBy" name="ohdTBICreateBy" value="<?=$tTBICreateBy?>">
                                            <label><?=$tTBIUsrNameCreateBy?></label>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- สถานะเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBITBStaDoc');?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <label><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIStaDoc'.$tTBIStaDoc);?></label>
                                        </div>
                                    </div>
                                </div>

                                <!-- สถานะอนุมัติเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?=language('document/transfer_branch_out/transfer_branch_out', 'tTBStaApv');?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <label><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIStaApv'.$tTBIStaApv);?></label>
                                        </div>
                                    </div>
                                </div>

                                <!-- ผู้อนุมัติเอกสาร -->   
                                <?php if(isset($tTBIDocNo) && !empty($tTBIDocNo)):?>
                                    <div class="form-group" style="margin:0">
                                        <div class="row">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIApvBy'); ?></label>
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                                <input type="hidden" id="ohdTBIApvCode" name="ohdTBIApvCode" maxlength="20" value="<?=$tTBIApvCode?>">
                                                <label>
                                                    <?php echo (isset($tTBIUsrNameApv) && !empty($tTBIUsrNameApv))? $tTBIUsrNameApv : "-" ?>
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Panel เงื่อนไขเอกสาร -->
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIConditionDoc');?></label>
                    <a class="xCNMenuplus" role="button" data-toggle="collapse" href="#odvTBIDataConditionDoc" aria-expanded="true">
                        <i class="fa fa-plus xCNPlus"></i>
                    </a>
                </div>
                <div id="odvTBIDataConditionDoc" class="panel-collapse collapse in" role="tabpanel">
                    <div class="panel-body">
                        <div class="row">
                            <!--สาขา-->
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?= language('document/transfer_branch_out/transfer_branch_out', 'tTBBchCreate') ?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNHide xCNInputWithoutSpcNotThai xCNInputWithoutSingleQuote"
                                            id="oetTBIBchCode"
                                            name="oetTBIBchCode"
                                            maxlength="5"
                                            value="<?php echo @$tTBIBchCode?>"
                                        >
                                        <input
                                            type="text"
                                            class="form-control xWPointerEventNone"
                                            id="oetTBIBchName"
                                            name="oetTBIBchName"
                                            maxlength="50"
                                            placeholder="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBranch') ?>"
                                            value="<?php echo @$tTBIBchName?>"
                                            readonly
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtBrowseTBIBch" type="button" class="btn xCNBtnBrowseAddOn"
                                            <?php if($tTBIRoute == 'docTBIEventEdit'){
                                                        echo 'disabled';   
                                                        }
                                                    ?>
                                            >
                                                <img src="<?php echo  base_url().'/application/modules/common/assets/images/icons/find-24.png'?>">
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div> 
                            
                            <!--เงื่อนไขของประเภท รับโอน-->
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <fieldset class="scheduler-border">
                                            <legend class="scheduler-border"><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIOrigin');?></legend>
                                            
                                            <!--เงื่อนไขของประเภท รับโอน-->
                                            <div id="odvTBI_5" class="row" style="display:none;">
                                                <!--เลือก เอกสารอ้างอิง-->
                                                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                                    <div class="form-group">
                                                        <label class="xCNLabelFrm"><?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBrowsDocTBO') ?></label>
                                                        <div class="input-group">
                                                            <input name="oetTBIRefIntDoc" id="oetTBIRefIntDoc" class="form-control xCNClearValue" value="<?=$tTBIRefInt?>" type="text" readonly="" 
                                                                data-validate="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIPlsEnterRefIntFrom') ?>"
                                                                placeholder="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBrowsDocTBO') ?>" 
                                                            >
                                                            <span class="input-group-btn">
                                                                <button class="btn xCNBtnBrowseAddOn xCNApvOrCanCelDisabled" id="oetTBIDocReferBrows" type="button">
                                                                    <img src="<?= base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                                                                </button>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!--แสดง สาขาต้นทาง-->
                                                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

                                                    <div class="form-group">
                                                        <label class="xCNLabelFrm"><?php echo language('document/transfer_branch_out/transfer_branch_out', 'tTBBchCreate'); ?></label>
                                                            <input
                                                            type="text"
                                                            class="form-control xCNHide xCNInputWithoutSpcNotThai xCNInputWithoutSingleQuote"
                                                            id="oetTBIBchCodeFrom"
                                                            name="oetTBIBchCodeFrom"
                                                            maxlength="5"
                                                            value="<?php echo @$tTBIBchCodeFrm?>"
                                                        >
                                                        <input name="oetTBIBchNameFrom" id="oetTBIBchNameFrom" class="form-control xCNClearValue" value="<?=$tTBIBchNameFrm?>" type="text" readonly="" 
                                                                placeholder="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBranch') ?>" >
											        </div>
                                                </div>
                                            </div>

                                            <!--เงื่อนไขของประเภท รับเข้า-->
                                            <div id="odvTBI_1" class="row" style="display:none;">

                                                <!--ประเภทของการรับเข้า-->
                                                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                                    <div class="form-group">
                                                        <label class="xCNLabelFrm"><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIConditionIN');?></label>
                                                        <select class="selectpicker form-control" id="ocmSelectTransTypeIN" name="ocmSelectTransTypeIN">
                                                            <!-- <option value='0' selected><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIConditionTo');?></option> -->
                                                            <option value='3' <?php if($tTBISplName != null ){ echo "selected";} ?>><?=language('document/transferreceiptbranch/transferreceiptbranch','tINSPL');?></option>
                                                            <option value='4' <?php if($tTBIOther != null ){ echo "selected";} ?>><?=language('document/transferreceiptbranch/transferreceiptbranch','tINETC');?></option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <script>
                                                    $('#ocmSelectTransTypeIN').val(<?php echo $thRsnType ;?>).change();
                                                    $('#ocmSelectTransTypeIN').change(function() {
                                                        var tValue = $(this).val();
                                                        if(tValue == 3){
                                                            $('#odvINWhereSPL').css('display','block');
                                                            $('#odvINWhereETC').css('display','none');
                                                        }else if(tValue == 4){
                                                            $('#odvINWhereSPL').css('display','none');
                                                            $('#odvINWhereETC').css('display','block');
                                                        }
                                                    });
                                                </script>

                                                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                                    <div id="odvINWhereSPL" style="display:none;">

                                                        <!--เลือกผู้จำหน่าย - รับเข้า - เงือนไขผู้จำหน่าย-->
                                                        <div class="form-group">
                                                            <label class="xCNLabelFrm"><?= language('supplier/supplier/supplier', 'tSPLTitle'); ?></label>
                                                            <div class="input-group">
                                                                <input name="oetTBISplName" id="oetTBISplName" class="form-control xCNClearValue" value="<?=$tTBISplName?>" type="text" readonly=""
                                                                    data-validate="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIPlsEnterSplFrom'); ?>" 
                                                                    placeholder="<?= language('supplier/supplier/supplier', 'tSPLTitle') ?>">
                                                                <input name="oetTBISplCode" id="oetTBISplCode" value="<?=$tTBISplCode?>" class="form-control xCNHide xCNClearValue" type="text">
                                                                <span class="input-group-btn">
                                                                    <button class="btn xCNBtnBrowseAddOn xCNApvOrCanCelDisabled" id="obtTBIBrowseSpl" type="button">
                                                                        <img src="<?= base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                                                                    </button>
                                                                </span>
                                                            </div>
                                                        </div>

                                                    </div>

                                                    <div id="odvINWhereETC" style="display:none;">
                                                        <!--กรอกแหล่งอื่น - รับเข้า - เงือนไขแหล่งอื่น-->
                                                        <div class="form-group">
                                                            <label class="xCNLabelFrm"><?= language('document/transferreceiptbranch/transferreceiptbranch', 'tINETC'); ?></label>
                                                            <input type="text" class="form-control xCNClearValue" id="oetTBIINEtc" name="oetTBIINEtc" value="<?=$tTBIOther?>" maxlength="100"
                                                                data-validate="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIPlsEntertOtherFrom'); ?>"
                                                            >
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </fieldset>
                                    </div>

                                    <div class="col-lg-12">
                                        <fieldset class="scheduler-border">
                                            <legend class="scheduler-border"><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBITo');?></legend>
                                           <?php if($this->session->userdata('nSesUsrBchCount')==1){ ?>
                                            <div class="form-group">
                                                <label class="xCNLabelFrm"><?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBranch') ?></label>
                                                
                                                <input name="oetTBIBchCodeTo" id="oetTBIBchCodeTo" class="form-control xCNHide xFhnBchCodeShw" value="<?=$tTBIBchCodeTo;?>" type="text" readonly="" 
                                                       placeholder="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBranch') ?>" >
                                                <input name="oetTBIBchNameTo" id="oetTBIBchNameTo" class="form-control" value="<?=$tTBIBchNameTo?>" type="text" readonly="" >
                                            
                                            </div> 
                                           <?php }else{ ?>       
                                           <!-- แสดง สาขาปลายทาง -->
                                           <div class="form-group">
                                                 <label class="xCNLabelFrm"><?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBranch') ?></label>
												<div class="input-group">
													<input
														type="text"
														class="form-control xCNHide xCNInputWithoutSpcNotThai xCNInputWithoutSingleQuote xFhnBchCodeShw"
														id="oetTBIBchCodeTo"
														name="oetTBIBchCodeTo"
														maxlength="5"
														value="<?php echo @$tTBIBchCodeTo?>"
													>
													<input
														type="text"
														class="form-control xWPointerEventNone"
														id="oetTBIBchNameTo"
														name="oetTBIBchNameTo"
														maxlength="100"
														placeholder="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBranch') ?>"
														value="<?php echo @$tTBIBchNameTo?>"
														readonly
													>
													<span class="input-group-btn">
														<button id="obtBrowseTWOBCHTo" type="button" class="btn xCNBtnBrowseAddOn xCNApvOrCanCelDisabled">
															<img src="<?php echo  base_url().'/application/modules/common/assets/images/icons/find-24.png'?>">
														</button>
													</span>
												</div>
											</div>
                                           <?php } ?>
                                           <!-- <div class="form-group">
                                                <label class="xCNLabelFrm"><?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBranch') ?></label>
                                                <input name="oetTBIBchCodeTo" id="oetTBIBchCodeTo" class="form-control xCNHide" value="<?=$tTBIBchCodeTo;?>" type="text" readonly="" 
                                                       placeholder="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIBranch') ?>" >
                                                <input name="oetTBIBchNameTo" id="oetTBIBchNameTo" class="form-control" value="<?=$tTBIBchNameTo?>" type="text" readonly="" >
                                            </div> -->

                                            <!-- เลือก คลังสินค้าปลายทาง -->
                                            <div class="form-group">
                                                <label class="xCNLabelFrm"><?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIWarehouse') ?></label>
                                                <div class="input-group">
                                                    <input name="oetTBIWahNameTo" id="oetTBIWahNameTo" class="form-control" value="<?=$tTBIWhNameTo;?>" type="text" readonly=""
                                                        data-validate="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIPlsEnterWahTo') ?>" 
                                                        placeholder="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBITablePDTWah') ?>" 
                                                    >
                                                    <input name="oetTBIWahCodeTo" id="oetTBIWahCodeTo" value="<?=$tTBIWhCodeTo;?>" class="form-control xCNHide xCNClearValue xFhnWahCodeShw" type="text">
                                                    <span class="input-group-btn">
                                                        <button class="btn xCNBtnBrowseAddOn xCNApvOrCanCelDisabled" id="obtTBIBrowseWahTo" type="button">
                                                            <img src="<?= base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </fieldset>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Panel อ้างอิง -->
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIPanelRef');?></label>
                    <a class="xCNMenuplus collapsed" role="button" data-toggle="collapse" href="#odvTBIDataConditionREF" aria-expanded="true">
                        <i class="fa fa-plus xCNPlus"></i>
                    </a>
                </div>
                <div id="odvTBIDataConditionREF" class="xCNMenuPanelData panel-collapse collapse" role="tabpanel">
                    <div class="panel-body">
                        <!-- อ้างอิงเลขที่เอกสารภายนอก -->
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?=language('document/saleorder/saleorder','tSOLabelFrmRefExtDoc');?></label>
                            <input
                                type="text"
                                class="form-control xCNApvOrCanCelDisabled"
                                id="oetTBIRefExtDoc"
                                name="oetTBIRefExtDoc"
                                maxlength="20"
                                value="<?=$tTBIRefExt?>"
                            >
                        </div>
                        <!-- วันที่เอกสารภายนอก -->
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?=language('document/saleorder/saleorder','tSOLabelFrmRefExtDocDate');?></label>
                            <div class="input-group">
                                <input
                                    type="text"
                                    class="form-control xCNDatePicker xCNInputMaskDate xCNApvOrCanCelDisabled"
                                    id="oetTBIRefExtDocDate"
                                    name="oetTBIRefExtDocDate"
                                    placeholder="YYYY-MM-DD"
                                    value="<?=$tTBIRefExtDate?>"
                                >
                                <span class="input-group-btn">
                                    <button id="obtTBIBrowseRefExtDocDate" type="button" class="btn xCNBtnDateTime xCNApvOrCanCelDisabled"><img class="xCNIconCalendar"></button>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                
            <!-- Panel การขนส่ง -->
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?=language('document/transferwarehouseout/transferwarehouseout','tTWOPanelTransport');?></label>
                    <a class="xCNMenuplus collapsed" role="button" data-toggle="collapse" href="#odvTWODataConditionTransport" aria-expanded="true">
                        <i class="fa fa-plus xCNPlus"></i>
                    </a>
                </div>
                <div id="odvTWODataConditionTransport" class="xCNMenuPanelData panel-collapse collapse" role="tabpanel">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?=language('document/producttransferwahouse/producttransferwahouse', 'tTFWCtrName'); ?></label>
                                    <input type="text" class="form-control xCNInputWOthoutSpc xCNApvOrCanCelDisabled" maxlength="100" id="oetTBITransportCtrName" name="oetTBITransportCtrName" value="<?=$tTBICtrName;?>">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?=language('document/producttransferwahouse/producttransferwahouse', 'tTFWTnfDate'); ?></label>
                                    <div class="input-group">
                                        <input type="text" class="form-control xCNDatePicker xCNInputMaskDate xCNApvOrCanCelDisabled" id="oetTBITransportTnfDate" name="oetTBITransportTnfDate"  placeholder="YYYY-MM-DD" value="<?=$dTBITnfDate;?>">
                                        <span class="input-group-btn">
                                            <button id="obtTWOTnfDate" type="button" class="btn xCNBtnDateTime xCNApvOrCanCelDisabled">
                                                <img src="<?=base_url().'application/modules/common/assets/images/icons/icons8-Calendar-100.png'?>">
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?=language('document/producttransferwahouse/producttransferwahouse', 'tTFWRefTnfID'); ?></label>
                                    <input type="text" class="form-control xCNInputWOthoutSpc xCNApvOrCanCelDisabled" maxlength="20" id="oetTBITransportRefTnfID" name="oetTBITransportRefTnfID" value="<?=$tTBIRefTnfID;?>">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?=language('document/producttransferwahouse/producttransferwahouse', 'tTFWRefVehID'); ?></label>
                                    <input type="text" class="form-control xCNInputWOthoutSpc xCNApvOrCanCelDisabled" maxlength="50" id="oetTBITransportRefVehID" name="oetTBITransportRefVehID" value="<?=$tTBIRefVehID;?>">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?=language('document/producttransferwahouse/producttransferwahouse', 'tTFWQtyAndTypeUnit'); ?></label>
                                    <input type="text" class="form-control xCNInputWOthoutSpc xCNApvOrCanCelDisabled" maxlength="30" id="oetTBITransportQtyAndTypeUnit" name="oetTBITransportQtyAndTypeUnit" value="<?=$tTBIQtyAndTypeUnit;?>">
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?php echo language('document/topupVending/topupVending', 'tViaCode'); ?></label>
                                    <div class="input-group">
                                        <input class="form-control xWPointerEventNone" type="text" id="oetTBIUpVendingViaName" name="oetTBIUpVendingViaName" value="<?=$tTBIViaName;?>" readonly>
                                        <input 
                                        type="text" 
                                        class="input100 xCNHide xCNApvOrCanCelDisabled" 
                                        id="oetTBIUpVendingViaCode" 
                                        name="oetTBIUpVendingViaCode" 
                                        value="<?=$tTBIViaCode;?>">
                                        <span class="input-group-btn">
                                            <button id="obtSearchShipVia" type="button" class="btn xCNBtnBrowseAddOn xCNApvOrCanCelDisabled">
                                                <img src="<?php echo  base_url() . 'application/modules/common/assets/images/icons/find-24.png' ?>">
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                        <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                <input type="hidden" id="ohdTBIFrmShipAdd" name="ohdTBIFrmShipAdd" value="<?=$nTBIShipAdd;?>">
                                <button type="button" id="obtTBIFrmBrowseShipAdd" class="btn btn-primary xCNApvOrCanCelDisabled" style="width:100%;">
                                    +&nbsp;<?php echo language('document/transferwarehouseout/transferwarehouseout','tTWOLabelFrmSplInfoShipAddress');?>
                                </button>
                            </div>
                        
                        </div>
                    </div>
                </div>
            </div>

            <!-- Panel อื่นๆ -->
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?=language('document/transferreceiptbranch/transferreceiptbranch','tTBIPanelETC');?></label>
                    <a class="xCNMenuplus collapsed" role="button" data-toggle="collapse" href="#odvTBIDataConditionETC" aria-expanded="true">
                        <i class="fa fa-plus xCNPlus"></i>
                    </a>
                </div>
                <div id="odvTBIDataConditionETC" class="xCNMenuPanelData panel-collapse collapse" role="tabpanel">
                    <div class="panel-body">
                        <!--เลือกเหตุผล-->
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIReason'); ?></label>
                            <div class="input-group">
                                <input name="oetTBIReasonName" id="oetTBIReasonName" class="form-control" value="<?=$tTBIRsnName?>" type="text" readonly="" 
                                        placeholder="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIReason') ?>">
                                <input name="oetTBIReasonCode" id="oetTBIReasonCode" value="<?=$tTBIRsnCode?>" class="form-control xCNHide" type="text">
                                <span class="input-group-btn">
                                    <button class="btn xCNBtnBrowseAddOn xCNApvOrCanCelDisabled" id="obtBrowseTBIReason" type="button">
                                        <img src="<?= base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                                    </button>
                                </span>
                            </div>
                        </div>

                        <!-- หมายเหตุ -->
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?=language('document/purchaseinvoice/purchaseinvoice','tPILabelFrmInfoOthRemark');?></label>
                            <textarea
                                class="form-control xCNApvOrCanCelDisabled"
                                id="otaTBIFrmInfoOthRmk"
                                name="otaTBIFrmInfoOthRmk"
                                rows="10"
                                maxlength="200"
                                style="resize: none;height:86px;"
                            ><?php echo $tTBIRmk; ?></textarea>
                        </div>

                        <!-- จำนวนครั้งที่พิมพ์ -->
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?=language('document/purchaseinvoice/purchaseinvoice','tPILabelFrmInfoOthDocPrint');?></label>
                            <input
                                type="text"
                                class="form-control text-right"
                                id="ocmTBIFrmInfoOthDocPrint"
                                name="ocmTBIFrmInfoOthDocPrint"
                                value="<?=$tTBIDocPrint;?>"
                                readonly
                            >
                        </div>

                        <div class="form-group">
							<label class="xCNLabelFrm"><?php echo language('document/producttransferbranch/producttransferbranch', 'tTBOptionAddPdt'); ?></label>
							<select class="selectpicker form-control" id="ocmTBIptionAddPdt" name="ocmTBIptionAddPdt">
								<option value="1" selected><?php echo language('document/producttransferbranch/producttransferbranch', 'tTBOptionAddPdtAddNumPdt'); ?></option>
								<option value="2" ><?php echo language('document/producttransferbranch/producttransferbranch', 'tTBOptionAddPdtAddNewRow'); ?></option>
							</select>
						</div> 

                        <!-- สถานะเคลื่อนไหว-->
                        <div class="form-group">
                            <label class="fancy-checkbox">
                                <input class="xCNApvOrCanCelDisabled" type="checkbox" id="ocbTBIStaDocAct" name="ocbTBIStaDocAct" maxlength="1" value="1" <?php echo $nTBIStaDocAct == '' ? 'checked' : $nTBIStaDocAct == '1' ? 'checked' : '0'; ?>>
                                <span>&nbsp;</span>
                                <span class="xCNLabelFrm"><?=language('document/purchaseorder/purchaseorder', 'tTFWStaDocAct'); ?></span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

             <!-- Panel ไฟลแนบ -->
             <div class="panel panel-default" style="margin-bottom: 25px;">
                    <div id="odvSOReferenceDoc" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                        <label class="xCNTextDetail1"><?php echo language('document/saleorder/saleorder', 'ไฟล์แนบ'); ?></label>
                        <a class="xCNMenuplus collapsed" role="button" data-toggle="collapse" href="#odvSODataFile" aria-expanded="true">
                            <i class="fa fa-plus xCNPlus"></i>
                        </a>
                    </div>
                    <div id="odvSODataFile" class="xCNMenuPanelData panel-collapse collapse" role="tabpanel">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="odvDOShowDataTable">


                                </div>
                            </div>
                        </div>
                    </div>
                    <script>
                        var oSOCallDataTableFile = {
                            ptElementID : 'odvDOShowDataTable',
                            ptBchCode   : $('#oetTBIBchCode').val(),
                            ptDocNo     : $('#oetTBIDocNo').val(),
                            ptDocKey    : 'TCNTPdtTbiHD',
                            ptSessionID : '<?= $this->session->userdata("tSesSessionID") ?>',
                            pnEvent     : <?= $nStaUploadFile ?>,
                            ptCallBackFunct: 'JSxSoCallBackUploadFile',
                            ptStaApv        : $('#ohdTBIStaApv').val(),
                            ptStaDoc        : $('#ohdTBIStaDoc').val()
                        }
                        JCNxUPFCallDataTable(oSOCallDataTableFile);
                    </script>
                </div>

        </div>       

        <div class="col-xs-12 col-sm-9 col-md-9 col-lg-9">
            <div class="row">
                <!-- ตารางสินค้า -->
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="panel panel-default" style="margin-bottom:25px;position:relative;min-height:200px;">
                        <div class="panel-collapse collapse in" role="tabpanel" data-grpname="Condition">
                            <div class="panel-body">
                                <div>
                                    <!--ค้นหา-->
                                    <div class="row p-t-10">
                                        <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input
                                                        type="text"
                                                        class="form-control"
                                                        maxlength="100"
                                                        id="oetTBIFrmFilterPdtHTML"
                                                        name="oetTBIFrmFilterPdtHTML"
                                                        placeholder="<?php echo language('document/purchaseinvoice/purchaseinvoice','tPIFrmFilterTablePdt');?>"
                                                        onkeyup="javascript:if(event.keyCode==13) JSvTBIDOCFilterPdtInTableTemp()"
                                                    >
                                                    <input 
                                                        type="text"
                                                        class="form-control"
                                                        maxlength="100"
                                                        id="oetTBIFrmSearchAndAddPdtHTML"
                                                        name="oetTBIFrmSearchAndAddPdtHTML"
                                                        onkeyup="Javascript:if(event.keyCode==13) JSxTBIChkConditionSearchAndAddPdt()"
                                                        placeholder="<?=language('document/purchaseinvoice/purchaseinvoice','tPIFrmSearchAndAddPdt');?>"
                                                        style="display:none;"
                                                        data-validate="<?=language('document/purchaseinvoice/purchaseinvoice','tPIMsgValidScanNotFoundBarCode');?>"
                                                    >
                                                    <span class="input-group-btn">
                                                        <div id="odvTBISearchAndScanBtnGrp" class="xCNDropDrownGroup input-group-append">
                                                            <button id="obtTBIMngPdtIconSearch" type="button" class="btn xCNBTNMngTable xCNBtnDocSchAndScan" onclick="JSvTBIDOCFilterPdtInTableTemp()">
                                                                <img src="<?php echo  base_url('application/modules/common/assets/images/icons/search-24.png'); ?>" style="width:20px;">
                                                            </button>
                                                            <button id="obtTBIMngPdtIconScan" type="button" class="btn xCNBTNMngTable xCNBtnDocSchAndScan" style="display:none;" onclick="JSxTBIChkConditionSearchAndAddPdt()">
                                                                <img src="<?php echo  base_url('application/modules/common/assets/images/icons/search-24.png'); ?>" style="width:20px;">
                                                            </button>
                                                            <button type="button" class="btn xCNDocDrpDwn xCNBtnDocSchAndScan" data-toggle="dropdown" style="display:none;">
                                                                <i class="fa fa-chevron-down f-s-14 t-plus-1" style="font-size: 12px;"></i>
                                                            </button>
                                                            <ul class="dropdown-menu" role="menu">
                                                                <li>
                                                                    <a id="oliTBIMngPdtSearch"><label><?=language('document/purchaseinvoice/purchaseinvoice','tPIFrmFilterTablePdt'); ?></label></a>
                                                                    <a id="oliTBIMngPdtScan"><?=language('document/purchaseinvoice/purchaseinvoice','tPIFrmSearchAndAddPdt'); ?></a>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4 text-right">
                                            <!-- <div id="odvTBIMngAdvTableList" class="btn-group xCNDropDrownGroup">
                                                <button id="obtTBIAdvTablePdtDTTemp" type="button" class="btn xCNBTNMngTable <?php echo (!$bIsApvOrCancel)?'m-r-20':''; ?>"><?=language('common/main/main', 'tModalAdvTable') ?></button>
                                            </div> -->
                                            <?php //if(!$bIsApvOrCancel) { ?>
                                                <div id="odvTBIMngDelPdtInTableDT" class="btn-group xCNDropDrownGroup">
                                                    <button type="button" class="btn xCNBTNMngTable xWDropdown" data-toggle="dropdown">
                                                        <?=language('common/main/main','tCMNOption')?>
                                                        <span class="caret"></span>
                                                    </button>
                                                    <ul class="dropdown-menu" role="menu">
                                                        <li id="oliTBIBtnDeleteMulti" class="disabled">
                                                            <a data-toggle="modal" data-target="#odvTBIModalDelPdtInDTTempMultiple"><?=language('common/main/main','tDelAll')?></a>
                                                        </li>
                                                    </ul>
                                                </div>
                                            <?php //} ?>
                                        </div>
                                        <?php //if(!$bIsApvOrCancel) { ?>
                                            <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3 text-right">
                                            			<!--ค้นหาจากบาร์โค๊ด-->
                                                <div class="form-group">
                                                    <input type="text" class="form-control xCNPdtEditInLine" id="oetTbiInsertBarcode"  autocomplete="off" name="oetTbiInsertBarcode" maxlength="50" value="" onkeypress="Javascript:if(event.keyCode==13) JSxSearchFromBarcode(event,this);"  placeholder="เพิ่มสินค้าด้วยบาร์โค้ด หรือ รหัสสินค้า" >
                                                </div>
									    	</div>
                                            <div class="col-xs-12 col-sm-1 col-md-1 col-lg-1">
                                                <div class="form-group">
                                                    <div style="position: absolute;right: 15px;">
                                                        <button type="button" id="obtTBIDocBrowsePdt" class="xCNBTNPrimeryPlus xCNDocBrowsePdt">+</button>
                                                    </div>
                                                </div>
                                            </div>
                                        <?php //} ?>
                                    </div>
                                    
                                    <!--ตาราง-->
                                    <div class="row" id="odvTBIDataPdtTableDTTemp"></div>
                                    <!-- <?php// include('wTransferreceiptbranchEndOfBill.php');?> -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- จบตารางสินค้า -->
            </div>    
        </div>
    </div>

    <!-- View Modal Shipping Purchase Invoice -->
    <div id="odvTWOBrowseShipAdd" class="modal fade">
        <div class="modal-dialog" style="width: 800px;">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
                            <label class="xCNTextModalHeard" style="font-weight: bold; font-size: 20px;"><?php echo language('document/transferwarehouseout/transferwarehouseout','tTWOShipAddress'); ?></label>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6 text-right">
                            <button class="btn xCNBTNPrimery xCNBTNPrimery2Btn" onclick="JSnPIShipAddData()"><?php echo language('common/main/main', 'tModalConfirm')?></button>  
                            <button class="btn xCNBTNDefult xCNBTNDefult2Btn" data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel')?></button>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <div class="panel panel-default" style="margin-bottom:5px;">
                                <div class="panel-heading xCNPanelHeadColor" style="padding-top:5px!important;padding-bottom:5px!important;">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNTextDetail1"><?php echo language('document/transferwarehouseout/transferwarehouseout', 'tTWOShipAddInfo');?></label> 
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <a style="font-size:14px!important;color:#179bfd;">
                                                <i class="fa fa-pencil" id="oliPIEditShipAddress">&nbsp;<?php echo language('document/transferwarehouseout/transferwarehouseout','tTWOShipChange');?></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body xCNPDModlue">
                                    <input type="hidden" id="ohdTBIShipAddSeqNo" name="ohdTBIShipAddSeqNo" class="form-control">
                                    <?php $tTWOFormatAddressType = FCNaHAddressFormat('TCNMBranch'); //1 ที่อยู่ แบบแยก  ,2  แบบรวม ?>
                                    <?php if(!empty($tTWOFormatAddressType) && $tTWOFormatAddressType == '1'): ?>
                                        <div class="row p-b-5">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout', 'tTWOShipADDV1No');?></label> 
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label id="ospTWOShipAddAddV1No"><?php echo @$tTWOShipAddAddV1No;?></label> 
                                            </div>
                                        </div>
                                        <div class="row p-b-5">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout', 'tTWOShipADDV1Village');?></label> 
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label id="ospTWOShipAddV1Soi"><?php echo @$tTWOShipAddV1Soi;?></label>
                                            </div>
                                        </div>
                                        <div class="row p-b-5">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout', 'tTWOShipADDV1Soi'); ?></label> 
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label id="ospTWOShipAddV1Village"><?php echo @$tTWOShipAddV1Village;?></label>
                                            </div>
                                        </div>
                                        <div class="row p-b-5">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout', 'tTWOShipADDV1Road'); ?></label> 
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label id="ospTWOShipAddV1Road"><?php echo @$tTWOShipAddV1Road;?></label> 
                                            </div>
                                        </div>
                                        <div class="row p-b-5">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout', 'tTWOShipADDV1SubDist'); ?></label> 
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label id="ospTWOShipAddV1SubDist"><?php echo @$tTWOShipAddV1SubDist;?></label> 
                                            </div>
                                        </div>
                                        <div class="row p-b-5">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout', 'tTWOShipADDV1DstCode'); ?></label> 
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label id="ospTWOShipAddV1DstCode"><?php echo @$tTWOShipAddV1DstCode?></label> 
                                            </div>
                                        </div>
                                        <div class="row p-b-5">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout', 'tTWOShipADDV1PvnCode'); ?></label> 
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label id="ospTWOShipAddV1PvnCode"><?php echo @$tTWOShipAddV1PvnCode?></label> 
                                            </div>
                                        </div>
                                        <div class="row p-b-5">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout', 'tTWOShipADDV1PostCode'); ?></label> 
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label id="ospTWOShipAddV1PostCode"><?php echo @$tTWOShipAddV1PostCode;?></label> 
                                            </div>
                                        </div>
                                    <?php else:?>
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                                <div class="form-group">
                                                    <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout','tTWOShipADDV2Desc1')?></label><br>
                                                    <label id="ospTWOShipAddV2Desc1"><?php echo @$tTWOShipAddV2Desc1;?></label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                                <div class="form-group">
                                                    <label class="xCNLabelFrm"><?php echo language('document/transferwarehouseout/transferwarehouseout','tTWOShipADDV2Desc2')?></label><br>
                                                    <label id="ospTWOShipAddV2Desc2"><?php echo @$tTWOShipAddV2Desc2;?></label>
                                                </div>
                                            </div>
                                        </div>
                                    <?php endif;?>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- Modal Advance Table Product DT Temp -->
<div class="modal fade" id="odvTBIOrderAdvTblColumns" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <div class="row">
                    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
                        <label class="xCNTextModalHeard" style="font-weight: bold; font-size: 20px;"><?=language('common/main/main', 'tModalAdvTable'); ?></label>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6 text-right">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </div>
            </div>
            <div class="modal-body" id="odvTBIModalBodyAdvTable">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal"><?=language('common/main/main', 'tModalAdvClose'); ?></button>
                <button id="obtTBISaveAdvTableColums" type="button" class="btn btn-primary"><?=language('common/main/main', 'tModalAdvSave'); ?></button>
            </div>
        </div>
    </div>
</div>

<!-- View Modal Appove Document -->
<div id="odvTBIModalAppoveDoc" class="modal fade xCNModalApprove">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="xCNHeardModal modal-title" style="display:inline-block"><?=language('common/main/main','tApproveTheDocument'); ?></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p><?=language('common/main/main','tMainApproveStatus'); ?></p>
                    <ul>
                        <li><?=language('common/main/main','tMainApproveStatus1'); ?></li>
                        <li><?=language('common/main/main','tMainApproveStatus2'); ?></li>
                        <li><?=language('common/main/main','tMainApproveStatus3'); ?></li>
                        <li><?=language('common/main/main','tMainApproveStatus4'); ?></li>
                    </ul>
                <p><?=language('common/main/main','tMainApproveStatus5'); ?></p>
                <p><strong><?=language('common/main/main','tMainApproveStatus6'); ?></strong></p>
            </div>
            <div class="modal-footer">
                <button  id="obtTBIConfirmApprDoc" type="button" class="btn xCNBTNPrimery"><?=language('common/main/main', 'tModalConfirm'); ?></button>
                <button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?=language('common/main/main', 'tModalCancel'); ?></button>
            </div>
        </div>
    </div>
</div>

<!-- กรณีคลังสินค้าต้นทาง ปลายทางว่าง -->
<div class="modal fade" id="odvTBIModalWahIsEmpty">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header xCNModalHead">
				<label class="xCNTextModalHeard"><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tConditionISEmpty')?></label>
			</div>
			<div class="modal-body">
                <div class="row">
                    <div class="col-lg-12">
						<span id="ospWahIsEmpty"><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tWahDocumentISEmptyDetail')?></span>
                    </div>
                </div>
			</div>
			<div class="modal-footer">
				<button id="osmConfirm" type="button" class="btn xCNBTNPrimery" data-dismiss="modal">
					<?=language('common/main/main', 'tModalConfirm'); ?>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- กรณีไม่ได้เลือกประเภทเอกสาร -->
<div class="modal fade" id="odvTBIModalTypeIsEmpty">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header xCNModalHead">
				<label class="xCNTextModalHeard"><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tConditionISEmpty')?></label>
			</div>
			<div class="modal-body">
                <div class="row">
                    <div class="col-lg-12">
						<span id="ospTypeIsEmpty"><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tTypeDocumentISEmptyDetail')?></span>
                    </div>
                </div>
			</div>
			<div class="modal-footer">
				<button id="osmConfirm" type="button" class="btn xCNBTNPrimery" data-dismiss="modal">
					<?=language('common/main/main', 'tModalConfirm'); ?>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- ลบสินค้าแบบหลายตัว -->
<div id="odvTBIModalDelPdtInDTTempMultiple" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <label class="xCNTextModalHeard"><?=language('common/main/main','tModalDelete')?></label>
            </div>
            <div class="modal-body">
                <span id="ospTextConfirmDelMultiple" class="xCNTextModal" style="display: inline-block; word-break:break-all"></span>
                <input type="hidden" id="ohdConfirmTBIDocNoDelete"   name="ohdConfirmTBIDocNoDelete">
                <input type="hidden" id="ohdConfirmTBISeqNoDelete"   name="ohdConfirmTBISeqNoDelete">
                <input type="hidden" id="ohdConfirmTBIPdtCodeDelete" name="ohdConfirmTBIPdtCodeDelete">
                <input type="hidden" id="ohdConfirmTBIPunCodeDelete" name="ohdConfirmTBIPunCodeDelete">
                
            </div>
            <div class="modal-footer">
                <button id="osmConfirmDelMultiple" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button"><?=language('common/main/main', 'tModalConfirm')?></button>
                <button class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"  data-dismiss="modal"><?=language('common/main/main', 'tModalCancel')?></button>
            </div>
        </div>
    </div>
</div>     

<!-- ยกเลิกเอกสาร -->
<div class="modal fade" id="odvTBIPopupCancel">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header xCNModalHead">
				<label class="xCNTextModalHeard"><?=language('document/document/document','tDocDocumentCancel')?></label>
			</div>
			<div class="modal-body">
                <p id="obpMsgApv"><strong><?=language('common/main/main','tDocCancelAlert2')?></strong></p>
			</div>
			<div class="modal-footer">
                <button onclick="JSxTBITransferReceiptDocCancel(true)" type="button" class="btn xCNBTNPrimery">
                    <?=language('common/main/main', 'tModalConfirm'); ?>
				</button>
				<button type="button" class="btn xCNBTNDefult" data-dismiss="modal">
					<?=language('common/main/main', 'tModalCancel'); ?>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- ลบสินค้าแบบหลายตัว -->
<div id="odvTBIModalPDTCN" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <label class="xCNTextModalHeard"><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tImportPDT')?></label>
            </div>
            <div class="modal-body" id="odvPDTInCN"> 
                
            </div>
            <div class="modal-footer">
                <button id="osmConfirmPDTCN" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button" data-dismiss="modal"><?=language('common/main/main', 'tModalConfirm')?></button>
                <button class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button" data-dismiss="modal"><?=language('common/main/main', 'tModalCancel')?></button>
            </div>
        </div>
    </div>
</div>     

<!-- กรณีไม่มีสินค้าใน Tmp -->
<div id="odvTBIModalPleaseSelectPDT" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header xCNModalHead">
				<label class="xCNTextModalHeard"><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tConditionPDTEmpty')?></label>
			</div>
			<div class="modal-body">
                <div class="row">
                    <div class="col-lg-12">
						<span><?=language('document/transferreceiptbranch/transferreceiptbranch', 'tConditionPDTEmptyDetail')?></span>
                    </div>
                </div>
			</div>
			<div class="modal-footer">
				<button id="osmConfirm" type="button" class="btn xCNBTNPrimery" data-dismiss="modal">
					<?=language('common/main/main', 'tModalConfirm'); ?>
				</button>
			</div>
		</div>
	</div>
</div>  

<!-- ======================================================================== Modal ไม่พบรหัสสินค้า ======================================================================== -->
<div id="odvTbiModalPDTNotFound" class="modal fade">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="xCNHeardModal modal-title" style="display:inline-block"><?=language('common/main/main', 'tMessageAlert')?></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>ไม่พบข้อมูลสินค้า กรุณาลองใหม่อีกครั้ง</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn xCNBTNPrimery" data-dismiss="modal" onclick="JSxNotFoundClose();" >
                        <?php echo language('common/main/main', 'tModalConfirm'); ?>
                    </button>
                </div>
            </div>
        </div>
    </div>
<!-- ============================================================================================================================================================================= -->

<div id="odvTbiModalPDTMoreOne" class="modal fade">
        <div class="modal-dialog" role="document" style="width: 85%; margin: 1.75rem auto;">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
                            <label class="xCNTextModalHeard" style="font-weight: bold; font-size: 20px;">กรุณาเลือกสินค้า</label>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6 text-right">
                            <button class="btn xCNBTNPrimery xCNBTNPrimery2Btn" onclick="JCNxConfirmPDTMoreOne(1)" data-dismiss="modal">เลือก</button>
                            <button class="btn xCNBTNDefult xCNBTNDefult2Btn" onclick="JCNxConfirmPDTMoreOne(2)" data-dismiss="modal">ปิด</button>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <table class="table table-striped xCNTablePDTMoreOne">
                        <thead>
                            <tr>
                                <th class="xCNTextBold" style="text-align:center; width:120px;"><?=language('common/main/main', 'tModalcodePDT')?></th>
                                <th class="xCNTextBold" style="text-align:center; width:160px;"><?=language('common/main/main', 'tModalnamePDT')?></th>
                                <th class="xCNTextBold" style="text-align:center; width:120px;"><?=language('common/main/main', 'tModalPriceUnit')?></th>
                                <th class="xCNTextBold" style="text-align:center; width:160px;"><?=language('common/main/main', 'tModalbarcodePDT')?></th>
                            </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
<!-- ============================================================================================================================================================================= -->



<script src="<?=base_url('application/modules/common/assets/js/jquery.mask.js')?>"></script>
<script src="<?=base_url('application/modules/common/assets/src/jFormValidate.js')?>"></script>
<?php include('script/jTransferReceiptbranchAdd.php'); ?>

<script type="text/javascript">
    $(function(){
        var tValue = $('#ocmSelectTransTypeIN').val();
        if(tValue == 3){
            $('#odvINWhereSPL').css('display','block');
            $('#odvINWhereETC').css('display','none');
        }else if(tValue == 4){
            $('#odvINWhereSPL').css('display','none');
            $('#odvINWhereETC').css('display','block');
        }
    });
</script>
<script>
    function JSxNotFoundClose(){
        $('#oetTbiInsertBarcode').focus();
    }

	//กดเลือกบาร์โค๊ด
	function  JSxSearchFromBarcode(e,elem){
        var tValue = $(elem).val();
        // if($('#oetPIFrmSplCode').val() != ""){
            JSxCheckPinMenuClose();
            if(tValue.length === 0){
            }else{
                $('#oetTbiInsertBarcode').attr('readonly',true);
                JCNSearchBarcodePdt(tValue);
                $('#oetTbiInsertBarcode').val('');
            }
        // }else{
        //     $('#odvPIModalPleseselectCustomer').modal('show');
        //     $('#oetTbiInsertBarcode').val('');
        // }
        e.preventDefault();
    }

	//ค้นหาบาร์โค๊ด
	function JCNSearchBarcodePdt(ptTextScan){

        var tWhereCondition = "";

        $.ajax({
            type : "POST",
            url : "BrowseDataPDTTableCallView",
            data :{
                Qualitysearch   : [],
                ReturnType  : "M",
                aPriceType  : ["Cost","tCN_Cost","Company","1"],
                // aPriceType  : ['Price4Cst',tPISplCode],
                NextFunc    : "",
                SelectTier  : ["Barcode"],
                SPL         : $("#oetPIFrmSplCode").val(),
                BCH         : $("#oetPIFrmBchCode").val(),
                MCH         : $("#oetPIFrmMerCode").val(),
                SHP         : $("#oetPIFrmShpCode").val(),
                tInpSesSessionID : $('#ohdSesSessionID').val(),
                tInpSesUsrLevel  : $('#ohdSesUsrLevel').val(),
                tInpSesUsrBchCom : $('#ohdSesUsrBchCom').val(),
                tInpLangEdit     : $('#ohdPILangEdit').val(),
                Where       : [tWhereCondition],
                tTextScan   : ptTextScan,
            },
            catch : false,
            timeout : 0,
            success : function (tResult){
				// localStorage.removeItem('TBi_LocalItemDataDelDtTemp');
                JCNxCloseLoading();
                $('#ohdTbiObjPdtFhnCallBack').val(tResult);
                var oText = JSON.parse(tResult);
                console.log('Event Scan',oText);
                if(oText == '800'){
                    $('#oetTbiInsertBarcode').attr('readonly',false);
                    $('#odvTbiModalPDTNotFound').modal('show');
                    $('#oetTbiInsertBarcode').val('');
                }else{
                    // พบสินค้ามีหลายบาร์โค้ด
                    if(oText.length > 1){
                        $('#odvTbiModalPDTMoreOne').modal('show');
                        $('#odvTbiModalPDTMoreOne .xCNTablePDTMoreOne tbody').html('');

                        for(i=0; i<oText.length; i++){
                            var aNewReturn      = JSON.stringify(oText[i]);
                            var tTest = "["+aNewReturn+"]";
                            var oEncodePackData = window.btoa(unescape(encodeURIComponent(tTest)));
                            var tHTML = "<tr class='xCNColumnPDTMoreOne"+i+" xCNColumnPDTMoreOne' data-information='"+oEncodePackData+"' style='cursor: pointer;'>";
                                tHTML += "<td>"+oText[i].pnPdtCode+"</td>";
                                tHTML += "<td>"+oText[i].packData.PDTName+"</td>";
                                tHTML += "<td>"+oText[i].packData.PUNName+"</td>";
                                tHTML += "<td>"+oText[i].ptBarCode+"</td>";
                                tHTML += "</tr>";
                            $('#odvTbiModalPDTMoreOne .xCNTablePDTMoreOne tbody').append(tHTML);
                        }

                        //เลือกสินค้า
                        $('.xCNColumnPDTMoreOne').off();

                        //ดับเบิ้ลคลิก
                        $('.xCNColumnPDTMoreOne').on('dblclick',function(e){
                            $('#odvTbiModalPDTMoreOne').modal('hide');
                            var tJSON = decodeURIComponent(escape(window.atob($(this).attr('data-information'))));
                            FSvTBIAddPdtIntoDocDTTempScan(tJSON); //Client
                            FSvTBIPDTAddPdtIntoTableDT(tJSON); //Server
                            // var oPIObjPdtFhnCallBack =  $('#ohdTbiObjPdtFhnCallBack').val();
                            var oJSONPdt = JSON.parse(tJSON);
                            var oOptionForFashion = {
                                    'bListItemAll'  : false,
                                    'tSpcControl'  : 0,
                                    'tNextFunc' : 'FSvTBIPDTAddPdtIntoTableDT'
                                }
                                JSxCheckProductSerialandFashion(oJSONPdt,oOptionForFashion,'insert');

                        });

                        //คลิกได้เลย
                        $('.xCNColumnPDTMoreOne').on('click',function(e){
                            //เลือกสินค้าแบบตัวเดียว
                            $('.xCNColumnPDTMoreOne').removeClass('xCNActivePDT');
                            $('.xCNColumnPDTMoreOne').children().attr('style', 'background-color:transparent !important; color:#232C3D !important;');
                            // $('.xCNColumnPDTMoreOne').children(':last-child').css('text-align','right');
                            $(this).addClass('xCNActivePDT');
                            $(this).children().attr('style', 'background-color:#179bfd !important; color:#FFF !important;');
                            // $(this).children().last().css('text-align','right');
                        });

                    }else{
                        //มีตัวเดียว
                        var aNewReturn  = JSON.stringify(oText);
                        console.log('aNewReturn: '+aNewReturn);
                        FSvTBIAddPdtIntoDocDTTempScan(aNewReturn); //Client
                        FSvTBIPDTAddPdtIntoTableDT(aNewReturn); //Server
               
                        var oOptionForFashion = {
                                'bListItemAll'  : false,
                                'tSpcControl'  : 0,
                                'tNextFunc' : 'FSvTBIPDTAddPdtIntoTableDT'
                            }
                    JSxCheckProductSerialandFashion(oText,oOptionForFashion,'insert');
                    }
                }
            },
            error: function (jqXHR,textStatus,errorThrown){
                JCNSearchBarcodePdt(ptTextScan);
            }
        });
    }



    //เลือกสินค้า กรณีพบมากกว่าหนึ่งตัว
    function JCNxConfirmPDTMoreOne($ptType){
        if($ptType == 1){
            $("#odvTbiModalPDTMoreOne .xCNTablePDTMoreOne tbody .xCNActivePDT").each(function( index ) {
                var tJSON = decodeURIComponent(escape(window.atob($(this).attr('data-information'))));
                FSvTBIAddPdtIntoDocDTTempScan(tJSON);
                FSvTBIPDTAddPdtIntoTableDT(tJSON);
   
                var oJSONPdt = JSON.parse(tJSON);
                var oOptionForFashion = {
                                    'bListItemAll'  : false,
                                    'tSpcControl'  : 0,
                                    'tNextFunc' : 'FSvTBIPDTAddPdtIntoTableDT'
                                }
             JSxCheckProductSerialandFashion(oJSONPdt,oOptionForFashion,'insert');
            });
        }else{
            $('#oetTbiInsertBarcode').attr('readonly',false);
            $('#oetTbiInsertBarcode').val('');
        }
    }


	
	//Function : เพิ่มสินค้าจาก ลง Table ฝั่ง Client
	//Create : 2018-08-28 Krit(Copter)
	function FSvTBIPDTAddPdtIntoTableDT(pjPdtData) {
			var nStaSession = JCNxFuncChkSessionExpired();
			if (typeof nStaSession !== "undefined" && nStaSession == 1) {
				var pnXthVATInOrEx = $("#ohdTBIFrmSplInfoVatInOrEx").val();

				console.log(pjPdtData);

				// JCNxOpenLoading();
				var ptXthDocNoSend = "";
				if ($("#ohdTBIRoute").val() == "docTBIEventEdit") {
				ptXthDocNoSend = $("#oetTBIDocNo").val();
				}

				$('#oetTbiInsertBarcode').attr('readonly',false);
            	$('#oetTbiInsertBarcode').val('');

				$.ajax({
				type: "POST",
				url: "docTBIEventAddPdtIntoDTDocTemp",
				data: {
					tTBIBchCode        : $("#oetTBIBchCode").val(),
					tTBIDocNo          : ptXthDocNoSend,
					tTBIVATInOrEx      : pnXthVATInOrEx,
					aTBIPdtData        : pjPdtData,
					nTBIptionAddPdt   : $("#ocmTBIptionAddPdt").val(),
                    tType            : 'PDT'
				},
				cache: false,
				timeout: 0,
				success: function (oResult) {
					// console.log(oResult);
					// JSvTBLoadPdtDataTableHtml();
					var aResult = JSON.parse(oResult);
                    if(aResult['nStaEvent']==1){
                        // JCNxCloseLoading();
                    }

				},
				error: function (jqXHR, textStatus, errorThrown) {
					JCNxResponseError(jqXHR, textStatus, errorThrown);
				}
				});
			} else {
				JCNxShowMsgSessionExpired();
			}
	}





</script>