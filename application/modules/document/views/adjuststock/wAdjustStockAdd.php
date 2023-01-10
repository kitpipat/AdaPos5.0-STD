<?php
    if(isset($aDataDocHD) && $aDataDocHD['rtCode'] == "1"){ 
        $tASTRoute              = "dcmASTEventEdit";
        $nASTAutStaEdit         = 1;
        $tASTDocNo              = $aDataDocHD['raItems']['FTAjhDocNo'];
        $dASTDocDate            = $aDataDocHD['raItems']['FDAjhDocDate'];
        $dASTDocTime            = $aDataDocHD['raItems']['FDAjhDocTime'];
        $tASTCreateBy           = $aDataDocHD['raItems']['FTAjhUsrNameCreateBy'];
        $tASTStaDoc             = $aDataDocHD['raItems']['FTAjhStaDoc'];
        $tASTStaApv             = $aDataDocHD['raItems']['FTAjhStaApv'];
        $tASTApvCode            = $aDataDocHD['raItems']['FTAjhUsrCodeAppove'];
        $tASTStaPrcStk          = $aDataDocHD['raItems']['FTAjhStaPrcStk'];
        $tASTBchCode            = $aDataDocHD['raItems']['FTAjhBchCodeFilter'];
        $tASTBchName            = $aDataDocHD['raItems']['FTAjhBchNameFilter'];
        $tASTMerCode            = $aDataDocHD['raItems']['FTAjhMerCodeFilter'];
        $tASTMerName            = $aDataDocHD['raItems']['FTAjhMerNameFilter'];
        $tASTShpCode            = $aDataDocHD['raItems']['FTAjhShopCodeFilter'];
        $tASTShpName            = $aDataDocHD['raItems']['FTAjhShopNameFilter'];
        $tASTPosCode            = $aDataDocHD['raItems']['FTAjhPosCodeFilter'];
        $tASTPosName            = $aDataDocHD['raItems']['FTAjhPosNameFilter'];
        $tASTWahCode            = $aDataDocHD['raItems']['FTAjhWahCodeFilter'];
        $tASTWahName            = $aDataDocHD['raItems']['FTAjhWahNameFilter'];
        $tASTDptCode            = $aDataDocHD['raItems']['FTAjhDptCode'];
        $tASTDptName            = $aDataDocHD['raItems']['FTAjhDptName'];
        $tASTUsrCode            = $aDataDocHD['raItems']['FTAjhUsrCode'];
        $tASTUsrNameCreateBy    = $aDataDocHD['raItems']['FTAjhUsrName'];
        $tASTRsnCode            = $aDataDocHD['raItems']['FTAjhRsnCode'];
        $tASTRsnName            = $aDataDocHD['raItems']['FTAjhRsnName'];
        $tASTLangEdit           = $this->session->userdata("tLangEdit");
        $tUserShpType           = $aDataDocHD['raItems']['FTShpType'];
        $tASTAjhRmk             = $aDataDocHD['raItems']['FTAjhRmk'];
        $tASTUsrNameApv         = $aDataDocHD['raItems']['FTAjsUsrNameAppove'];
        $tASTStaDelMQ           = "";
        $tASTSesUsrBchCode      = $this->session->userdata("tSesUsrBchCode");
        $nASTStaDocAct          = $aDataDocHD['raItems']['FNAjhStaDocAct'];
    }else{
        $tASTRoute              = "dcmASTEventAdd";
        $nASTAutStaEdit         = 0;
        $tASTDocNo              = "";
        $dASTDocDate            = "";
        $dASTDocTime            = date('H:i');
        $tASTCreateBy           = $this->session->userdata('tSesUsrUsername');
        $tASTStaDoc             = "";
        $tASTStaApv             = "";
        $tASTApvCode            = "";
        $tASTStaPrcStk          = "";
        $tASTStaDelMQ           = "";
        $tASTSesUsrBchCode      = $this->session->userdata("tSesUsrBchCode");
        $tASTBchCode            = $this->session->userdata("tSesUsrBchCodeDefault");
        $tASTBchName            = $this->session->userdata("tSesUsrBchNameDefault");
        $tASTMerCode            = $this->session->userdata("tSesUsrMerCode");
        $tASTMerName            = $this->session->userdata("tSesUsrMerName");
        $tASTShpCode            = $this->session->userdata("tSesUsrShpCodeDefault");
        $tASTShpName            = $this->session->userdata("tSesUsrShpNameDefault");
        $tASTPosCode            = "";
        $tASTPosName            = "";
        $tASTWahCode            = $this->session->userdata("tSesUsrWahCode");
        $tASTWahName            = $this->session->userdata("tSesUsrWahName");
        $tASTDptCode            = $this->session->userdata("tSesUsrDptCode");
        $tASTDptName            = $this->session->userdata("tSesUsrDptName");
        $tASTUsrCode            = $this->session->userdata('tSesUsername');
        $tASTUsrNameCreateBy    = $this->session->userdata('tSesUsrUsername');
        $tASTUsrNameApv         = "";
        $tASTLangEdit           = $this->session->userdata("tLangEdit");
        $tUserShpType           = "";
        $nASTStaDocAct          = "99";
        $tASTRsnName            = "";
        $tASTRsnCode            = "";
        $tASTAjhRmk             = "";
    }

    $tASTUserType = $this->session->userdata("tSesUsrLevel");
?>
<form id="ofmASTFormAdd" class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data">
    <button style="display:none" type="submit" id="obtSubmitAST" onclick="JSxASTAddEditDocument()"></button>

    <!-- ============= Create By Witsarut 27/08/2019 ==================== -->
    <input type="hidden" id="ohdASTCompCode" name="ohdASTCompCode" value='<?=FCNtGetCompanyCode(); ?>'>
    <input type="hidden" id="ohdBaseUrl" name="ohdBaseUrl" value="<?php echo base_url(); ?>">
    <!-- ============= Create By Witsarut 27/08/2019 ==================== -->

    <input type="hidden" id="ohdASTRoute" name="ohdASTRoute" value="<?php echo $tASTRoute; ?>">
    <input type="hidden" id="ohdASTCheckClearValidate" name="ohdASTCheckClearValidate" value="0">
    <input type="hidden" id="ohdASTCheckSubmitByButton" name="ohdASTCheckSubmitByButton" value="0">
    <input type="hidden" id="ohdASTAutStaEdit" name="ohdASTAutStaEdit" value="<?php echo $nASTAutStaEdit; ?>">

    <input type="hidden" id="ohdASTStaApv" name="ohdASTStaApv" value="<?php echo $tASTStaApv; ?>">
    <input type="hidden" id="ohdASTStaDoc" name="ohdASTStaDoc" value="<?php echo $tASTStaDoc; ?>">
	<input type="hidden" id="ohdASTStaPrcStk" name="ohdASTStaPrcStk" value="<?php echo $tASTStaPrcStk; ?>">
	<input type="hidden" id="ohdASTStaDelMQ" name="ohdASTStaDelMQ" value="<?php echo $tASTStaDelMQ; ?>">
    <input type="hidden" id="ohdASTSesUsrBchCode" name="ohdASTSesUsrBchCode" value="<?php echo $tASTSesUsrBchCode; ?>">
    <input type="hidden" id="ohdASTBchCode" name="ohdASTBchCode" value="<?php echo $tASTBchCode; ?>">
    
    <input type="hidden" id="ohdASTDptCode" name="ohdASTDptCode" value="<?php echo $tASTDptCode;?>">
    <input type="hidden" id="ohdASTUsrCode" name="ohdASTUsrCode" value="<?php echo $tASTUsrCode?>">
    <input type="hidden" id="ohdASTApvCodeUsrLogin" name="ohdASTApvCodeUsrLogin" value="<?php echo $tASTUsrCode; ?>">
    <input type="hidden" id="ohdASTLangEdit" name="ohdASTLangEdit" value="<?php echo $tASTLangEdit; ?>">
    <input type="hidden" id="ohdASTOptAlwSavQty" name="ohdASTOptAlwSavQty" value="<?php echo $nOptDocSave?>">
    <input type="hidden" id="ohdASTOptScanSku" name="ohdASTOptScanSku" value="<?php echo $nOptScanSku?>">

    <div class="row">
        <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3">
            <!-- Panel รหัสเอกสารและสถานะเอกสาร -->
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div id="odvASTHeadStatusInfo" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?php echo language('document/adjuststock/adjuststock', 'tASTDocument'); ?></label>
                    <a class="xCNMenuplus" role="button" data-toggle="collapse"  href="#odvASTDataStatusInfo" aria-expanded="true">
                        <i class="fa fa-plus xCNPlus"></i>
                    </a>
                </div>
                <div id="odvASTDataStatusInfo" class="panel-collapse collapse in" role="tabpanel">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="form-group xCNHide" style="text-align: right;">
                                    <label class="xCNTitleFrom "><?php echo language('document/adjuststock/adjuststock', 'tASTApproved'); ?></label>
                                </div>
                                <input type="hidden" value="0" id="ohdCheckASTSubmitByButton" name="ohdCheckASTSubmitByButton"> 
                                <input type="hidden" value="0" id="ohdCheckASTClearValidate" name="ohdCheckASTClearValidate"> 
                                <label class="xCNLabelFrm"><span style = "color:red">*</span><?php echo language('document/adjuststock/adjuststock', 'tASTDocNo'); ?></label>
                                <?php if(empty($tASTDocNo)):?>
                                    <div class="form-group">
                                        <label class="fancy-checkbox">
                                            <input type="checkbox" id="ocbASTStaAutoGenCode" name="ocbASTStaAutoGenCode" maxlength="1" checked="true" value="1">
                                            <span class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTAutoGenCode'); ?></span>
                                        </label>
                                    </div>
                                <?php endif;?>
                                <!-- เลขรหัสเอกสาร -->
                                <div class="form-group" style="cursor:not-allowed">
                                    <input 
                                        type="text"
                                        class="form-control xWTooltipsBT xCNInputWithoutSpcNotThai xCNInputWithoutSingleQuote"
                                        id="oetASTDocNo"
                                        name="oetASTDocNo"
                                        maxlength="20"
                                        value="<?php echo $tASTDocNo;?>"
                                        data-validate-required="<?php echo language('document/adjuststock/adjuststock', 'tASTPlsEnterOrRunDocNo'); ?>"
                                        data-validate-duplicate="<?php echo language('document/adjuststock/adjuststock', 'tASTPlsDocNoDuplicate'); ?>"
                                        placeholder="<?php echo language('document/adjuststock/adjuststock','tASTDocNo');?>"
                                        style="pointer-events:none"
                                        readonly
                                    >
                                    <input type="hidden" id="ohdASTCheckDuplicateCode" name="ohdASTCheckDuplicateCode" value="2">
                                </div>
                                <!-- วันที่ในการออกเอกสาร -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock','tASTDocDate');?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNDatePicker xCNInputMaskDate"
                                            id="oetASTDocDate"
                                            name="oetASTDocDate"
                                            value="<?php echo $dASTDocDate;?>"
                                            data-validate-required="<?php echo language('document/adjuststock/adjuststock', 'tASTPlsEnterDocDate');?>"
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtASTDocDate" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                        </span>
                                    </div>
                                </div>
                                <!-- เวลาในการออกเอกสาร -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTDocTime');?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNTimePicker"
                                            id="oetASTDocTime"
                                            name="oetASTDocTime"
                                            value="<?php echo $dASTDocTime;?>"
                                            data-validate-required="<?php echo language('document/adjuststock/adjuststock', 'tASTPlsEnterDocTime');?>"
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtASTDocTime" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                        </span>
                                    </div>
                                </div>
                                <!-- ผู้สร้างเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock','tASTCreateBy'); ?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <input type="hidden" id="ohdASTCreateBy" name="ohdASTCreateBy" value="<?php echo $tASTCreateBy?>">
                                            <label><?php echo $tASTUsrNameCreateBy?></label>
                                        </div>
                                    </div>
                                </div>
                                <!-- สถานะเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock','tASTTBStaDoc'); ?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <label><?php echo language('document/adjuststock/adjuststock','tASTStaDoc'.$tASTStaDoc); ?></label>
                                        </div>
                                    </div>
                                </div>
                                <!-- สถานะอนุมัติเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock','tASTTBStaApv');?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <label><?php echo language('document/adjuststock/adjuststock','tASTStaApv'.$tASTStaApv);?></label>
                                        </div>
                                    </div>
                                </div>
                                <!-- สถานะประมวลผลเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock','tASTTBStaPrc');?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <label><?php echo language('document/adjuststock/adjuststock','tASTStaPrcStk'.$tASTStaPrcStk);?></label>
                                        </div>
                                    </div>
                                </div>
                                <?php if(isset($tASTDocNo) && !empty($tASTDocNo)):?>
                                    <!-- ผู้อนุมัติเอกสาร -->
                                    <div class="form-group" style="margin:0">
                                        <div class="row">
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                                <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTApvBy'); ?></label>
                                            </div>
                                            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                                <input type="hidden" id="ohdASTApvCode" name="ohdASTApvCode" maxlength="20" value="<?php echo $tASTApvCode?>">
                                                <label>
                                                    <?php echo (isset($tASTUsrNameApv) && !empty($tASTUsrNameApv)) ? $tASTUsrNameApv : "-"; ?>
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
                <div id="odvASTConditionDoc" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?php echo language('document/adjuststock/adjuststock','tASTConditionDoc');?></label>
                    <a class="xCNMenuplus" role="button" data-toggle="collapse" href="#odvASTDataConditionDoc" aria-expanded="true">
                        <i class="fa fa-plus xCNPlus"></i>
                    </a>
                </div>
                <div id="odvASTDataConditionDoc" class="panel-collapse collapse in" role="tabpanel">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <!-- Condition สาขา -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock','tASTBranch');?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNHide xCNInputWithoutSpcNotThai xCNInputWithoutSingleQuote"
                                            id="oetASTBchCode"
                                            name="oetASTBchCode"
                                            maxlength="5"
                                            value="<?php echo $tASTBchCode;?>"
                                        >
                                        <input
                                            type="text"
                                            class="form-control xWPointerEventNone"
                                            id="oetASTBchName"
                                            name="oetASTBchName"
                                            maxlength="100"
                                            placeholder="<?php echo language('document/adjuststock/adjuststock','tASTBranch');?>"
                                            value="<?php echo $tASTBchName;?>"
                                            readonly
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtBrowseASTBCH" type="button" class="btn xCNBtnBrowseAddOn " >
                                                <img src="<?php echo  base_url().'/application/modules/common/assets/images/icons/find-24.png'?>">
                                            </button>
                                        </span>
                                    </div>
                                </div>          
                                <!-- Condition กลุ่มร้านค้า -->
                                <div class="form-group <?= !FCNbGetIsShpEnabled() ? 'xCNHide' : ''; ?>">
                                    <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTMerchant'); ?></label>
                                    <div class="input-group">
                                        <?php
                                            // กลุ่มร้านค้า
                                            // if($tASTUserType == 'HQ'){
                                            //     $tASTDataInputMerCode   = '';
                                            //     $tASTDataInputMerName   = '';
                                            //     $tASTDataInputShpCode   = '';
                                            //     $tASTDataInputShpName   = '';
                                            //     $tASTDataInputWahCode   = '';
                                            //     $tASTDataInputWahName   = '';
                                            // }else{
                                                $tASTDataInputMerCode   = $tASTMerCode;
                                                $tASTDataInputMerName   = $tASTMerName;
                                         
                                                $tASTDataInputWahCode   = $tASTWahCode;
                                                $tASTDataInputWahName   = $tASTWahName;
                                            // }
                                            if($tASTRoute != "dcmASTEventEdit"){
                                                $tASTDataInputShpName = '';
                                                $tASTDataInputShpCode = '';
                                            }else{
                                                $tASTDataInputShpCode   = $tASTShpCode;
                                                $tASTDataInputShpName   = $tASTShpName;
                                            }
                                        ?>
                                        <input class="form-control xCNHide" id="oetASTMerCode" name="oetASTMerCode" maxlength="5" value="<?php echo $tASTDataInputMerCode;?>">
                                        <input
                                            type="text"
                                            class="form-control xWPointerEventNone"
                                            id="oetASTMerName"
                                            name="oetASTMerName"
                                            value="<?php echo $tASTDataInputMerName;?>"
                                            placeholder="<?=language('document/adjuststock/adjuststock', 'tASTMerchant'); ?>"
                                            readonly
                                        >
                                        <span class="xWConDisDocument input-group-btn">
                                            <button id="obtASTBrowseMer" type="button" class="xWConDisDocument btn xCNBtnBrowseAddOn">
                                                <img class="xCNIconFind">
                                            </button>
                                        </span>
                                    </div>
                                </div>

                                <!-- Condition ร้านค้า -->
                                <script>
                                    var tUsrLevel = '<?=$this->session->userdata('tSesUsrLevel')?>';
                                    if( tUsrLevel == "SHP" ){
                                        var tShpcount = '<?=$this->session->userdata("nSesUsrShpCount");?>';
                                        if(tShpcount < 2){
                                            $('#obtASTBrowseShp').attr('disabled',true);
                                        }
                                    }
                                </script>
                                <div class="form-group <?= !FCNbGetIsShpEnabled() ? 'xCNHide' : ''; ?>">
                                    <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTShop'); ?></label>
                                    <div class="input-group">
                                        <input class="form-control xCNHide" id="oetASTShopCode" name="oetASTShopCode" maxlength="5" value="<?php echo $tASTDataInputShpCode;?>">
                                        <input
                                            type="text"
                                            class="form-control xWPointerEventNone"
                                            id="oetASTShopName"
                                            name="oetASTShopName"
                                            value="<?php echo $tASTDataInputShpName;?>"
                                            placeholder="<?=language('document/adjuststock/adjuststock', 'tASTShop'); ?>"
                                            readonly
                                        >
                                        <span class="xWConDisDocument input-group-btn">
                                            <button id="obtASTBrowseShp" type="button" class="xWConDisDocument btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                                        </span>
                                    </div>
                                </div>
                                <!-- Condition เครื่องจุดขาย -->
                                <!-- ของเดิมเป็น  tASTPosName  เปลี่ยนเป็น tASTPosCode -->
                                <div class="form-group <?= !FCNbGetIsShpEnabled() ? 'xCNHide' : '' ?>">
                                    <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTPos'); ?></label>
                                    <div class="input-group">
                                        <input class="form-control xCNHide" id="oetASTPosType" value="<?php echo $tUserShpType;?>">
                                        <input class="form-control xCNHide" id="oetASTPosCode" name="oetASTPosCode" maxlength="5" value="<?php echo $tASTPosCode;?>">
                                        <input
                                            type="text"
                                            class="form-control xWPointerEventNone"
                                            id="oetASTPosName"
                                            name="oetASTPosName"
                                            value="<?php echo $tASTPosName;?>" 
                                            placeholder="<?=language('document/adjuststock/adjuststock', 'tASTPos'); ?>"
                                            readonly
                                        >                                   
                                        <span class="xWConDisDocument input-group-btn">
                                            <button id="obtASTBrowsePos" type="button" class="xWConDisDocument btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                                        </span>
                                    </div>
                                </div>
                                
                                <!-- <div class="form-group">
                                    <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTWarehouse'); ?></label>
                                    <div class="input-group">
                                        <input class="form-control xCNHide" id="oetASTWahCode" name="oetASTWahCode" maxlength="5" value="<?php echo $tASTDataInputWahCode;?>">
                                        <input
                                            type="text"
                                            class="form-control xWPointerEventNone"
                                            id="oetASTWahName"
                                            name="oetASTWahName"
                                            value="<?php //echo $tASTDataInputWahName;?>"
                                             data-validate-required="<?php echo language('document/adjuststock/adjuststock', 'tASTPlsEnterWahFrom'); ?>"
                                        >
                                        <span class="xWConditionSearchPdt input-group-btn">
                                            <button id="obtASTBrowseWah" type="button" class="xWConditionSearchPdt btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                                        </span>
                                    </div>
                                </div> -->

                                <!-- Condition เหตุผล -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><span style = "color:red">*</span><?php echo language('document/adjuststock/adjuststock', 'tASTReason'); ?></label>
                                    <div class="input-group">
                                        <input class="form-control xCNHide" id="oetASTRsnCode" name="oetASTRsnCode" maxlength="5" value="<?=$tASTRsnCode;?>">
                                        <input
                                            type="text"
                                            class="form-control xWPointerEventNone"
                                            id="oetASTRsnName"
                                            name="oetASTRsnName"
                                            value="<?php echo $tASTRsnName;?>"
                                            placeholder="<?=language('document/adjuststock/adjuststock', 'tASTReason'); ?>"
                                            readonly data-validate-required="<?php echo language('document/adjuststock/adjuststock', 'tASTPlsEnterReason'); ?>"
                                        >
                                        <span class="xWConditionSearchPdt input-group-btn">
                                            <button id="obtASTBrowseRsn" type="button" class="xWConditionSearchPdt btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                                        </span>
                                    </div>
                                </div>
                                <!-- Condition หมายเหตุ -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTRemark'); ?></label>
                                    <textarea class="form-control" id="otaASTRmk" name="otaASTRmk" rows="10" maxlength="200" style="resize:none;height:86px;"><?=$tASTAjhRmk;?></textarea>
                                </div>

                                  <!-- สถานะเคลื่อนไหว-->
                                  <div class="form-group">
                                    <label class="fancy-checkbox">
                                        <input type="checkbox" value="1" id="ocbASTStaDocAct" name="ocbASTStaDocAct" maxlength="1" <?php if ($nASTStaDocAct == 1 && $nASTStaDocAct != 0) {
                                            echo 'checked';
                                        } else if ($nASTStaDocAct == 99) {
                                            echo 'checked';
                                        }  ?>>
                                        <span>&nbsp;</span>
                                        <span class="xCNLabelFrm"><?= language('document/adjuststock/adjuststock', 'tASTStaDocAct'); ?></span>
                                    </label>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-sm-9 col-md-9 col-lg-9">
            <div class="row">
                <!-- ตารางรายการนับสินค้า -->
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="panel panel-default" style="margin-bottom:25px;position:relative;min-height:200px;">
                        <div class="panel-collapse collapse in" role="tabpanel" data-grpname="Condition">
                            <div class="panel-body">
                                <div class="row" style="margin-top: 10px;">
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                        <!-- Condition คลังสินค้า -->
                                        <div class="form-group">
                                            <label class="xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTWarehouse'); ?></label>
                                            <div class="input-group">
                                                <input name="oetASTWahName" id="oetASTWahName" class="form-control" value="<?php echo $tASTDataInputWahName;?>" type="text" readonly=""
                                                    data-validate="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBIPlsEnterWahTo') ?>" 
                                                    placeholder="<?= language('document/transferreceiptbranch/transferreceiptbranch', 'tTBITablePDTWah') ?>" 
                                                >
                                                <input name="oetASTWahCode" id="oetASTWahCode" value="<?php echo $tASTDataInputWahCode;?>" class="form-control xCNHide xCNClearValue" type="text">
                                                <span class="input-group-btn">
                                                    <button class="btn xCNBtnBrowseAddOn xCNApvOrCanCelDisabled" id="obtASTBrowseWah" type="button">
                                                        <img src="<?= base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                                                    </button>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input
                                                    type="text"
                                                    class="form-control"
                                                    maxlength="100"
                                                    id="oetASTSearchPdtHTML"
                                                    name="oetASTSearchPdtHTML"
                                                    onkeyup="JSvASTSearchPdtHTML()"
                                                    placeholder="<?php echo language('document/adjuststock/adjuststock', 'tASTSearchPdt');?>"
                                                >
                                                <input
                                                    style="display:none;"
                                                    type="text"
                                                    class="form-control"
                                                    maxlength="100"
                                                    id="oetASTScanPdtHTML"
                                                    name="oetASTScanPdtHTML"
                                                    onkeyup="Javascript:if(event.keyCode==13) JSvASTScanPdtHTML()"
                                                    placeholder="<?php echo language('document/adjuststock/adjuststock', 'tASTScanPdt');?>"
                                                    data-validate="<?php echo language('document/adjuststock/adjuststock','tASTScanPdtNotFound');?>"
                                                >
                                                <span class="input-group-btn">
                                                    <div id="odvASTSearchBtnGrp" class="xCNDropDrownGroup input-group-append">
                                                        <button id="obtASTMngPdtIconSearch" type="button" class="btn xCNBTNMngTable xCNBtnDocSchAndScan">
                                                            <img class="xCNIconSearch" style="width:20px;">
                                                        </button>
                                                        <button id="obtASTMngPdtIconScan" type="button" class="btn xCNBTNMngTable xCNBtnDocSchAndScan" style="display:none;">
                                                            <img class="xCNIconScanner" style="width:20px;">
                                                        </button>
                                                        <!-- <button type="button" class="btn xCNDocDrpDwn xCNBtnDocSchAndScan" data-toggle="dropdown">
                                                            <i class="fa fa-chevron-down f-s-14 t-plus-1" style="font-size: 12px;"></i>
                                                        </button>
                                                        <ul class="dropdown-menu" role="menu">
                                                            <li>
                                                                <a id="oliASTMngPdtSearch"><label><?php echo language('document/adjuststock/adjuststock', 'tASTSearchPdt'); ?></label></a>
                                                                <a id="oliASTMngPdtScan"><?php echo language('document/adjuststock/adjuststock', 'tASTScanPdt'); ?></a>
                                                            </li>
                                                        </ul> -->
                                                    </div>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3">
                                        <div class="form-group">
                                            <select class="form-control selectpicker disabled" disabled="disabled" id="ostASTApvSeqChk" name="ostASTApvSeqChk" maxlength="1">
                                                <option value="1"><?php echo language('document/adjuststock/adjuststock', 'tASTApvSeqChk1'); ?></option>
                                                <option value="2" ><?php echo language('document/adjuststock/adjuststock', 'tASTApvSeqChk2'); ?></option>
                                                <option value="3" selected><?php echo language('document/adjuststock/adjuststock', 'tASTApvSeqChk3'); ?></option>
                                                <option value="4"><?php echo language('document/adjuststock/adjuststock', 'tASTApvSeqChk4'); ?></option>
                                            </select>
                                        </div>
                                    </div> -->
                            

                                    <!-- <div  id="olbASTAdvTableLists" class="btn-group xCNDropDrownGroup">
                                        <div class="text-right">
                                            <button type="button" class="btn xCNBTNMngTable"><?php echo language('common/main/main','tModalAdvMngTable')?></button>
                                        </div> 
                                    </div> -->

                                    <!-- <div class="col-xs-12 col-sm-2 col-md-2 col-lg-2">
                                        <div id="odvASTMngAdvPdtDataTable" class="btn-group xCNDropDrownGroup right">
                                            <button type="button" class="btn xCNBTNMngTable" data-toggle="dropdown">
                                                <?php echo language('common/main/main','tCMNOption')?>
                                                <span class="caret"></span>
                                            </button>
                                            <ul class="dropdown-menu" role="menu">
                                                <li id="oliASTDelPdtDT" class="disabled">
                                                    <a data-toggle="modal" data-target="#odvASTModalDelPdtDTTemp"><?php echo language('common/main/main','tDelAll')?></a>
                                                </li>
                                            </ul>
                                        </div>    
                                    </div> -->

                                    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6 text-right">
                                        <div class="right">
                                            <div id="odvADJMngAdvTableList" class="btn-group xCNDropDrownGroup" >
                                                <button type="button" class="btn xCNBTNMngTable xCNImportBtn"  onclick="JSxAdjStkOpenImportForm()">
                                                    <?= language('common/main/main', 'tImport') ?>
                                                </button>
                                            </div>


                                            <div class="btn-group xCNDropDrownGroup">
                                                <button <?php if(!empty($tASTStaApv) || $tASTStaDoc == 3){ echo "disabled"; }?> type="button" class="btn xCNBTNMngTable xWASTDisabledOnApv" data-toggle="dropdown">
                                                    <?php echo language('common/main/main', 'tCMNOption') ?>
                                                    <span class="caret"></span>
                                                </button>
                                                <ul class="dropdown-menu" role="menu">
                                                    <li id="oliASTDelPdtDT" class="disabled">
                                                        <a data-toggle="modal" data-target="#odvASTModalDelPdtDTTemp"><?php echo language('common/main/main', 'tDelAll') ?></a>
                                                    </li>
                                                </ul>
                                            </div>


                                            <div class="btn-group">
                                                <button <?php if(!empty($tASTStaApv) || $tASTStaDoc == 3){ echo "disabled"; }?> id="obtAdjStkFilterDataCondition" type="button" class="btn btn-primary xWASTDisabledOnApv" style="font-size: 16px;">กรองข้อมูลตามเงื่อนไข</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3 text-right">
											<!--ค้นหาจากบาร์โค๊ด-->
											<div class="form-group">
												<input type="text" class="form-control xCNPdtEditInLine" id="oetASTInsertBarcode"  autocomplete="off" name="oetASTInsertBarcode" maxlength="50" value="" onkeypress="Javascript:if(event.keyCode==13) JSxSearchFromBarcode(event,this);"  placeholder="เพิ่มสินค้าด้วยบาร์โค้ด หรือ รหัสสินค้า" >
											</div>
								    </div>

                                    <!-- <div class="col-xs-12 col-sm-2 col-md-2 col-lg-2">
                                        <div class="form-group">
                                            <div style="position: absolute;right: -135px;top:-38px;">
                                                <button type="button" id="obtASTDocBrowsePdt" class="xCNBTNPrimeryPlus xCNDocBrowsePdt
                                                <?php
                                                    if($tASTRoute == "dcmASTEventAdd") {
                                                ?>
                                                    disabled
                                                <?php
                                                    }else{
                                                      if($tASTMerCode != ""){                       
                                                ?>
                                                    disabled
                                                <?php
                                                    }
                                                }
                                                ?>" onclick="JCNvAdjStkBrowsePdt()" type="button">+</button>
                                            </div>
                                        </div>
                                    </div> -->
                                </div>
                                <div class="row" id="odvASTPdtTablePanal"></div>
                                <input type="hidden" id="ohdConfirmIDDelete">
                            </div>
                        </div>
                    </div>
                </div>
            </div>    
        </div>
    </div>
</form>
<!-- ================================================================== View Modal Advance Table ================================================================== -->
    <div id="odvASTOrderAdvTblColumns" class="modal fade">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
                            <label class="xCNTextModalHeard" style="font-weight: bold; font-size: 20px;"><?php echo language('common/main/main', 'tModalAdvTable'); ?></label>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6 text-right">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal"><?php echo language('common/main/main', 'tModalAdvClose'); ?></button>
                    <button id="obtASTSaveAdvTableColums" type="button" class="btn btn-primary"><?php echo language('common/main/main', 'tModalAdvSave'); ?></button>
                </div>
            </div>
        </div>
    </div>
<!-- ============================================================================================================================================================== -->
<!-- ================================================================= View Modal Appove Document ================================================================= -->
    <div id="odvASTModalAppoveDoc" class="modal fade xCNModalApprove">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="xCNHeardModal modal-title" style="display:inline-block"><?php echo language('common/main/main','tApproveTheDocument'); ?></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p><?php echo language('common/main/main','tMainApproveStatus'); ?></p>
                        <ul>
                            <li><?php echo language('common/main/main','tMainApproveStatus1'); ?></li>
                            <li><?php echo language('common/main/main','tMainApproveStatus2'); ?></li>
                            <li><?php echo language('common/main/main','tMainApproveStatus3'); ?></li>
                            <li><?php echo language('common/main/main','tMainApproveStatus4'); ?></li>
                        </ul>
                    <p><?php echo language('common/main/main','tMainApproveStatus5'); ?></p>
                    <p><strong><?php echo language('common/main/main','tMainApproveStatus6'); ?></strong></p>
                </div>
                <div class="modal-footer">
                    <button  id="obtASTConfirmApprDoc" type="button" class="btn xCNBTNPrimery"><?php echo language('common/main/main', 'tModalConfirm'); ?></button>
                    <button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel'); ?></button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="odvASTPopupCancel">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header xCNModalHead">
                    <label class="xCNTextModalHeard"><?php echo language('document/adjuststock/adjuststock', 'tASTCanDoc'); ?></label>
                </div>
                <div class="modal-body">
                    <p id="obpMsgApv"><?php echo language('document/adjuststock/adjuststock', 'tASTDocRemoveCantEdit'); ?></p>
                    <p><strong><?php echo language('document/adjuststock/adjuststock', 'tASTCancel'); ?></strong></p>
                </div>
                <div class="modal-footer">
                    <button onclick="JSnASTCancelDoc(true)" type="button" class="btn xCNBTNPrimery">
                        <?php echo language('common/main/main', 'tModalConfirm'); ?>
                    </button>
                    <button type="button" class="btn xCNBTNDefult" data-dismiss="modal">
                        <?php echo language('common/main/main', 'tModalCancel'); ?>
                    </button>
                </div>
            </div>
        </div>
</div>



<div class="modal fade" id="odvAdjStkFilterDataCondition">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header xCNModalHead"><label class="xCNTextModalHeard"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubFilterTitle'); ?></label></div>
            <div class="modal-body" style="overflow-y: auto;">
                
                <form id="ofmASTFilterDataCondition">
                 <!-- Section Tab -->
                <div class="row" >
                                <ul class="nav nav-tabs" role="tablist">
                                    <li  class="active" >
                                        <a class="xCNMenuTab" role="tab" data-toggle="tab"   href="#odvASTFilterTitleProduct" aria-expanded="true"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTitleProduct'); ?></a>
                                    </li>
                                    <li  class="xWDisTab" >
                                        <a class="xCNMenuTab" role="tab" data-toggle="tab"   href="#odvASTFilterTitleSpl" aria-expanded="false"><?php echo language('document/adjuststocksub/adjuststocksub','tASTFilterTitleSpl')?></a>
                                    </li>
                                    <li  class="xWDisTab"  style="display:none;">
                                        <a class="xCNMenuTab" role="tab" data-toggle="tab"   href="#odvASTFilterTitleUserPI" aria-expanded="false"><?php echo language('document/adjuststocksub/adjuststocksub','tASTFilterTitleUserPI')?></a>
                                    </li>
                                    <li  class="xWDisTab" >
                                        <a class="xCNMenuTab" role="tab" data-toggle="tab"  href="#odvAdjStkSubWarehouse" aria-expanded="false"><?php echo language('document/adjuststocksub/adjuststocksub','tAdjStkSubWarehouse')?></a>
                                    </li>
                                    <li  class="xWDisTab" >
                                        <a class="xCNMenuTab" role="tab" data-toggle="tab"  href="#odvASTFilterTitlePdtGroup" aria-expanded="false"><?php echo language('document/adjuststocksub/adjuststocksub','tASTFilterTitlePdtGroup')?></a>
                                    </li>
                                    <li  class="xWDisTab" >
                                        <a class="xCNMenuTab" role="tab" data-toggle="tab"   href="#odvASTFilterTitleLocation" aria-expanded="false"><?php echo language('document/adjuststocksub/adjuststocksub','tASTFilterTitleLocation')?></a>
                                    </li>
                                    <li  class="xWDisTab" >
                                        <a class="xCNMenuTab" role="tab" data-toggle="tab"   href="#odvASTFilterTitlePdtStkCard" aria-expanded="false"><?php echo language('document/adjuststocksub/adjuststocksub','tASTFilterTitlePdtStkCard')?></a>
                                    </li>
                                    <li  class="xWDisTab" >
                                        <a class="xCNMenuTab" role="tab" data-toggle="tab"   href="#odvASTFilterTitlePdtExclude" aria-expanded="false"><?php echo language('document/adjuststock/adjuststock','tASTFillterExclude')?></a>
                                    </li>
                                </ul>
                </div>
                <!-- Close Section Tab -->
                <!-- Section Tab Content-->
                <div class="row">
                    <div class="tab-content">

                    <div id="odvASTFilterTitleProduct" class="tab-pane fade active in">

                            <div class="">
                                <!-- <label class="xCNTabConditionHeader xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTitleProduct'); ?></label> -->
                                <!-- Browse Pdt -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <!-- จากรหัสสินค้า -->
                                        <div class="form-group">
                                            <label class="xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubFilterCodeFrom'); ?></label>
                                            <div class="input-group">
                                                <input type="text" class="input100 xCNHide" id="oetASTFilterPdtCodeFrom" name="oetASTFilterPdtCodeFrom" value="">
                                                <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterPdtNameFrom" name="oetASTFilterPdtNameFrom" value="" readonly="">
                                                <span class="input-group-btn xWConditionSearchPdt">
                                                    <button id="obtASTBrowseFilterProductFrom" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                        <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                    </button>
                                                </span>
                                            </div>
                                        </div>
                                        <!-- จากรหัสสินค้า -->
                                    </div>
                                    <div class="col-md-6">
                                        <!-- ถึงรหัสสินค้า -->
                                        <div class="form-group">
                                            <label class="xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubFilterCodeTo'); ?></label>
                                            <div class="input-group">
                                                <input type="text" class="input100 xCNHide" id="oetASTFilterPdtCodeTo" name="oetASTFilterPdtCodeTo" value="">
                                                <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterPdtNameTo" name="oetASTFilterPdtNameTo" value="" readonly="">
                                                <span class="input-group-btn xWConditionSearchPdt">
                                                    <button id="obtASTBrowseFilterProductTo" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                        <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                    </button>
                                                </span>
                                            </div>
                                        </div>
                                        <!-- ถึงรหัสสินค้า -->
                                    </div>
                                </div>
                                <!-- Browse Pdt -->
                            </div>

                    </div>

                    <div id="odvASTFilterTitleSpl" class="tab-pane" role="tabpanel">

                            <div class="">
                                <!-- <label class="xCNTabConditionHeader xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTitleSpl'); ?></label> -->
                                <!-- Browse Supplier -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <!-- จากรหัส -->
                                        <div class="form-group">
                                            <label class="xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubFilterCodeFrom'); ?></label>
                                            <div class="input-group">
                                                <input type="text" class="input100 xCNHide" id="oetASTFilterSplCodeFrom" name="oetASTFilterSplCodeFrom" value="">
                                                <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterSplNameFrom" name="oetASTFilterSplNameFrom" value="" readonly="">
                                                <span class="input-group-btn xWConditionSearchPdt">
                                                    <button id="obtASTBrowseFilterSupplierFrom" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                        <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                    </button>
                                                </span>
                                            </div>
                                        </div>
                                        <!-- จากรหัส -->
                                    </div>
                                    <div class="col-md-6">
                                        <!-- ถึงรหัส -->
                                        <div class="form-group">
                                            <label class="xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubFilterCodeTo'); ?></label>
                                            <div class="input-group">
                                                <input type="text" class="input100 xCNHide" id="oetASTFilterSplCodeTo" name="oetASTFilterSplCodeTo" value="">
                                                <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterSplNameTo" name="oetASTFilterSplNameTo" value="" readonly="">
                                                <span class="input-group-btn xWConditionSearchPdt">
                                                    <button id="obtASTBrowseFilterSupplierTo" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                        <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                    </button>
                                                </span>
                                            </div>
                                        </div>
                                        <!-- ถึงรหัส -->
                                    </div>
                                </div>
                                <!-- Browse Supplier -->
                            </div>
                    </div>

                    <div id="odvASTFilterTitleUserPI" class="tab-pane" role="tabpanel">

                        <div class="" style="display:none;">
                            <!-- <label class="xCNTabConditionHeader xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTitleUserPI'); ?></label> -->
                            <!-- Browse User -->
                            <div class="row">
                                <div class="col-md-6">
                                    <!-- จากรหัส -->
                                    <div class="form-group">
                                        <label class="xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubFilterCodeFrom'); ?></label>
                                        <div class="input-group">
                                            <input type="text" class="input100 xCNHide" id="oetASTFilterUsrCodeFrom" name="oetASTFilterUsrCodeFrom" value="">
                                            <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterUsrNameFrom" name="oetASTFilterUsrNameFrom" value="" readonly="">
                                            <span class="input-group-btn xWConditionSearchPdt">
                                                <button id="obtASTBrowseFilterUserFrom" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                    <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                    <!-- จากรหัส -->
                                </div>
                                <div class="col-md-6">
                                    <!-- ถึงรหัส -->
                                    <div class="form-group">
                                        <label class="xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubFilterCodeTo'); ?></label>
                                        <div class="input-group">
                                            <input type="text" class="input100 xCNHide" id="oetASTFilterUsrCodeTo" name="oetASTFilterUsrCodeTo" value="">
                                            <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterUsrNameTo" name="oetASTFilterUsrNameTo" value="" readonly="">
                                            <span class="input-group-btn xWConditionSearchPdt">
                                                <button id="obtASTBrowseFilterUserTo" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                    <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                    <!-- ถึงรหัส -->
                                </div>
                            </div>
                            <!-- Browse User -->
                        </div>
                    </div>


                    <div id="odvAdjStkSubWarehouse" class="tab-pane" role="tabpanel">
                        <div class="">
                            <!-- <label class="xCNTabConditionHeader xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubWarehouse'); ?></label> -->
                            <!-- Browse Product Group -->
                            <div class="row">
                                <div class="col-md-6">
                                    <!-- จากรหัส -->
                                    <div class="form-group">
                                    <label class=" xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubWarehouse'); ?></label>
                                        <div class="input-group">
                                            <input type="text" class="input100 xCNHide" id="oetASTFilterWahCode" name="oetASTFilterWahCode" value="">
                                            <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterWahName" name="oetASTFilterWahName" value="" readonly="">
                                            <span class="input-group-btn xWConditionSearchPdt">
                                                <button id="obtASTBrowseFilterWahouse" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                    <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                    <!-- จากรหัส -->
                                </div>
                                <div class="col-md-6"></div>
                            </div>
                            <!-- Browse Product Group -->
                        </div>
                    </div>


                    <div id="odvASTFilterTitlePdtGroup" class="tab-pane" role="tabpanel">
                        <div class="">
                            <!-- <label class="xCNTabConditionHeader xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTitlePdtGroup'); ?></label> -->
                            <!-- Browse Product Group -->
                            <div class="row">
                                <div class="col-md-6">
                                    <!-- จากรหัส -->
                                    <div class="form-group">
                                    <label class=" xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTitlePdtGroup'); ?></label>
                                        <div class="input-group">
                                            <input type="text" class="input100 xCNHide" id="oetASTFilterPgpCode" name="oetASTFilterPgpCode" value="">
                                            <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterPgpName" name="oetASTFilterPgpName" value="" readonly="">
                                            <span class="input-group-btn xWConditionSearchPdt">
                                                <button id="obtASTBrowseFilterProductGroup" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                    <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                    <!-- จากรหัส -->
                                </div>
                                <div class="col-md-6"></div>
                            </div>
                            <!-- Browse Product Group -->
                        </div>
                    </div>

                    <!-- Browse Product Location Seq -->
                    <div id="odvASTFilterTitleLocation" class="tab-pane" role="tabpanel">
                        <div class="">
                            <!-- <label class="xCNTabConditionHeader xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTitleLocation'); ?></label> -->
                            <div class="row">

                                <div class="col-md-6">
                                    <!-- จากรหัส -->
                                    <div class="form-group">
                                    <label class=" xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTitleLocation'); ?></label>
                                        <div class="input-group">
                                            <input type="text" class="input100 xCNHide" id="oetASTFilterPlcCode" name="oetASTFilterPlcCode" value="">
                                            <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterPlcName" name="oetASTFilterPlcName" value="" readonly="">
                                            <span class="input-group-btn xWConditionSearchPdt">
                                                <button id="obtASTBrowseFilterProductLocation" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                    <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                    <!-- จากรหัส -->
                                </div>

                                <div class="col-md-12">
                                    <div class="form-group">
                                        <div class="form-check">
                                            <input name="ocbASTPdtLocChkSeq" class="form-check-input xWASTDisabledOnApv" type="checkbox" value="1" id="ocbASTPdtLocChkSeq">
                                            <label class="form-check-label" for="ocbASTPdtLocChkSeq"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTextPdtLocSeqOnly'); ?></label>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6"></div>
                            </div>
                        </div>
                    </div>
                    <!-- Browse Product Location Seq -->

                    <!-- Product StockCard -->
                    <div id="odvASTFilterTitlePdtStkCard" class="tab-pane" role="tabpanel">
                        <div class="">
                            <!-- <label class="xCNTabConditionHeader xCNLabelFrm"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTitlePdtStkCard'); ?></label> -->
                            <div class="row">
                                <div class="col-md-12">
                                
                                    <div class="form-group">
                                        <div class="form-check">
                                            <input name="ocbASTUsePdtStkCard" class="form-check-input xWASTDisabledOnApv" type="checkbox" id="ocbASTUsePdtStkCard">
                                            <label class="form-check-label" for="ocbASTUsePdtStkCard"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTextUsePdtStkCard'); ?></label>
                                        </div>
                                    </div>

                                    <div class="form-group" style="margin-left: 20px;margin-top: -10px;">
                                        <div class="custom-control custom-radio">
                                            <input type="radio" class="custom-control-input xWASTDisabledOnCheckUsePdtStkCard" id="orbASTPdtStkCard_1" name="orbASTPdtStkCard" value="1" disabled>
                                            <label class="custom-control-label" for="orbASTPdtStkCard_1"><?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTextPdtNotMove'); ?></label>
                                        </div>
                                        <div class="custom-control custom-radio">
                                            <input type="radio" class="custom-control-input xWASTDisabledOnCheckUsePdtStkCard" id="orbASTPdtStkCard_2" name="orbASTPdtStkCard" value="2" disabled>
                                            <label class="custom-control-label" for="orbASTPdtStkCard_2">
                                                <?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTextPrePdtMove'); ?> 
                                                <input class="form-control xWASTDisabledOnCheckUsePdtStkCard" type="number" id="onbASTPdtStkCardBack" name="onbASTPdtStkCardBack" min="1" style="width: 60px;display: inline;" disabled>
                                                <?php echo language('document/adjuststocksub/adjuststocksub', 'tASTFilterTextMonth'); ?>
                                            </label>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Product Exclude Adjust -->
                    <div id="odvASTFilterTitlePdtExclude" class="tab-pane" role="tabpanel">
                        <div class="">
                            <!-- <label class="xCNTabConditionHeader xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTFillterExclude'); ?></label> -->
                            <div class="row">

                            <div class="col-md-12">
                                    <div class="form-group">
                                            <input name="ocbASTUseExStock" class="form-check-input xWASTDisabledOnApv" type="checkbox" id="ocbASTUseExStock">
                                            <label class="form-check-label" for="ocbASTUseExStock"><?php echo language('document/adjuststock/adjuststock', 'tASTFillterExcludeStock'); ?></label>
                                    </div>
                            </div>


                            <div class="col-md-6">
                                    <div class="form-group">
                                    <label class=" xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTFillterExcludeStockDateFrm'); ?></label>
                                    <div class="input-group">
                                        <input type="text" class="form-control xCNDatePicker xCNInputMaskDate" id="oetASTFilterExDateFrm" name="oetASTFilterExDateFrm" value="<?=date('Y-m-d')?>" data-validate-required="กรุณากรอกวันที่เอกสาร" maxlength="10">
                                        <span class="input-group-btn">
                                            <button id="obtASTFilterExDateFrm" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                        </span>
                                    </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                    <label class=" xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTFillterExcludeStockDateTo'); ?></label>
                                        <div class="input-group">
                                            <input type="text" class="form-control xCNDatePicker xCNInputMaskDate" id="oetASTFilterExDateTo" name="oetASTFilterExDateTo" value="<?=date('Y-m-d')?>" data-validate-required="กรุณากรอกวันที่เอกสาร" maxlength="10">
                                            <span class="input-group-btn">
                                                <button id="obtASTFilterExDateTo" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                            </span>
                                        </div>
                                    </div>
                                </div>


                                <div class="col-md-6">
                                    <div class="form-group">
                                    <label class=" xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTFillterExcludeStockWah'); ?></label>
                                        <div class="input-group">
                                            <input type="text" class="input100 xCNHide" id="oetASTFilterExWahCode" name="oetASTFilterExWahCode" value="">
                                            <input class="form-control xWPointerEventNone" type="text" id="oetASTFilterExWahName" name="oetASTFilterExWahName" value="" readonly="">
                                            <span class="input-group-btn xWConditionSearchPdt">
                                                <button id="obtASTBrowseFilterExWahouse" type="button" class="btn xCNBtnBrowseAddOn xWConditionSearchPdt">
                                                    <img src="<?php echo base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                    <label class=" xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTFillterExcludeStockCon'); ?></label>
                                            <select class="form-control" name="ocmASTFilterExCon" id="ocmASTFilterExCon">
                                                <option value=""><?php echo language('document/adjuststock/adjuststock', 'tASTFillterExcludeStockAll'); ?></option>
                                                <option value=">" selected>></option>
                                                <option value="<"><</option>
                                                <option value="=">=</option>
                                                <option value="<>"><></option>
                                            </select>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                    <label class=" xCNLabelFrm"><?php echo language('document/adjuststock/adjuststock', 'tASTFillterExcludeStockStkBal'); ?></label>
                                    <input type="number" class="form-control " id="oetASTFilterExStkBal" name="oetASTFilterExStkBal" value="0">
                                    </div>
                                </div>


                            </div>
                        </div>
                    </div>
                    <!-- Product Exclude Adjust -->

                    
                    </div>
                    </div>
                    <!-- Close Section Tab Content-->
                </form>

            </div>
            <div class="modal-footer">
                <button id="obtAdjStkConfirmFilter" type="button" class="btn xCNBTNPrimery xWASTDisabledOnApv"><?php echo language('document/adjuststocksub/adjuststocksub', 'tAdjStkSubBtnFilterConfirm'); ?></button>
                <button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel'); ?></button>
            </div>
        </div>
    </div>
</div>

<!-- ======================================================================== Modal ไม่พบรหัสสินค้า ======================================================================== -->
<div id="odvTbxModalPDTNotFound" class="modal fade">
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

<div id="odvASTModalPDTMoreOne" class="modal fade"  role="dialog" data-backdrop="static" data-keyboard="false">
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

<!-- ============================================================================================================================================================== -->

<script src="<?php echo base_url('application/modules/common/assets/js/jquery.mask.js')?>"></script>
<script src="<?php echo base_url('application/modules/common/assets/src/jFormValidate.js')?>"></script>
<?php include('script/jAdjustStockAdd.php'); ?>
<script>
      function JSxNotFoundClose(){
        $('#oetASTInsertBarcode').focus();
    }

	//กดเลือกบาร์โค๊ด
	function  JSxSearchFromBarcode(e,elem){
        var tValue = $(elem).val();
        // if($('#oetPIFrmSplCode').val() != ""){
            JSxCheckPinMenuClose();
            if(tValue.length === 0){
            }else{
                $('#oetASTInsertBarcode').attr('readonly',true);
                JCNSearchBarcodePdt(tValue);
                $('#oetASTInsertBarcode').val('');
            }
        // }else{
        //     $('#odvPIModalPleseselectCustomer').modal('show');
        //     $('#oetASTInsertBarcode').val('');
        // }
        e.preventDefault();
    }

	//ค้นหาบาร์โค๊ด
	function JCNSearchBarcodePdt(ptTextScan){

        var tWhereCondition = " ";

        $.ajax({
            type : "POST",
            url : "BrowseDataPDTTableCallView",
            data :{
                Qualitysearch   : [],
                ReturnType  : "M",
                aPriceType  : ["Pricesell"],
                // aPriceType  : ['Price4Cst',tPISplCode],
                NextFunc    : "",
                SelectTier  : ["Barcode"],
                SPL: "",
                BCH: $("#oetASTBchCode").val(),
                MER: $('#oetASTMerCode').val(),
                SHP: $('#oetASTShopCode').val(),
                tWhere       : [tWhereCondition],
                tTextScan   : ptTextScan,
            },
            catch : false,
            timeout : 0,
            success : function (tResult){
				// localStorage.removeItem('TBX_LocalItemDataDelDtTemp');
                JCNxCloseLoading();
                $('#ohdTbxObjPdtFhnCallBack').val(tResult);
                var oText = JSON.parse(tResult);
                console.log('Event Scan',oText);
                if(oText == '800'){
                    $('#oetASTInsertBarcode').attr('readonly',false);
                    $('#odvTbxModalPDTNotFound').modal('show');
                    $('#oetASTInsertBarcode').val('');
                }else{
                    // พบสินค้ามีหลายบาร์โค้ด
                    if(oText.length > 1){
                        $('#odvASTModalPDTMoreOne').modal('show');
                        $('#odvASTModalPDTMoreOne .xCNTablePDTMoreOne tbody').html('');

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
                            $('#odvASTModalPDTMoreOne .xCNTablePDTMoreOne tbody').append(tHTML);
                        }

                        //เลือกสินค้า
                        $('.xCNColumnPDTMoreOne').off();

                        //ดับเบิ้ลคลิก
                        $('.xCNColumnPDTMoreOne').on('dblclick',function(e){
                            $('#odvASTModalPDTMoreOne').modal('hide');
                            var tJSON = decodeURIComponent(escape(window.atob($(this).attr('data-information'))));
                            // FSvTBXAddPdtIntoDocDTTempScan(tJSON); //Client
                            JSvASTInsertPdtToTemp(tJSON); //Server
                            // var oPIObjPdtFhnCallBack =  $('#ohdTbxObjPdtFhnCallBack').val();
                            var oJSONPdt = JSON.parse(tJSON);
                            var oOptionForFashion = {
                                    'bListItemAll'  : false,
                                    'tSpcControl'  : 1,
                                    'tNextFunc' : 'JSvASTEventAddPdtIntoDTFhnTemp'
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
                        // FSvTBXAddPdtIntoDocDTTempScan(aNewReturn); //Client
                        JSvASTInsertPdtToTemp(aNewReturn); //Server
               
                        var oOptionForFashion = {
                                'bListItemAll'  : false,
                                'tSpcControl'  : 1,
                                'tNextFunc' : 'JSvASTEventAddPdtIntoDTFhnTemp'
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
            $("#odvASTModalPDTMoreOne .xCNTablePDTMoreOne tbody .xCNActivePDT").each(function( index ) {
                var tJSON = decodeURIComponent(escape(window.atob($(this).attr('data-information'))));
                // FSvTBXAddPdtIntoDocDTTempScan(tJSON);
                JSvASTInsertPdtToTemp(tJSON);
   
                var oJSONPdt = JSON.parse(tJSON);
                var oOptionForFashion = {
                                    'bListItemAll'  : false,
                                    'tSpcControl'  : 1,
                                    'tNextFunc' : 'JSvASTEventAddPdtIntoDTFhnTemp'
                                }
             JSxCheckProductSerialandFashion(oJSONPdt,oOptionForFashion,'insert');
            });
        }else{
            $('#oetASTInsertBarcode').attr('readonly',false);
            $('#oetASTInsertBarcode').val('');
        }
    }


	
	//Function : เพิ่มสินค้าจาก ลง Table ฝั่ง Client
	//Create : 2018-08-28 Krit(Copter)
	function JSvASTInsertPdtToTemp(pjPdtData) {
			var nStaSession = JCNxFuncChkSessionExpired();
			if (typeof nStaSession !== "undefined" && nStaSession == 1) {
				pnXthVATInOrEx = 2;

				console.log(pjPdtData);

				JCNxOpenLoading();
				var ptXthDocNoSend = "";
				if ($("#ohdASTRoute").val() == "dcmASTEventEdit") {
				ptXthDocNoSend = $("#oetASTDocNo").val();
				}

				$('#oetASTInsertBarcode').attr('readonly',false);
            	$('#oetASTInsertBarcode').val('');

				$.ajax({
				type: "POST",
				url: "docASTInsertPdtToTmp",
				data: {
					ptBchCode        : $("#oetASTBchCode").val(),
					ptXthDocNo          : ptXthDocNoSend,
					pnXthVATInOrEx      : pnXthVATInOrEx,
					tPdtData            : pjPdtData,
					pnOptionAddPdt      : 1
				},
				cache: false,
				timeout: 0,
				success: function (oResult) {
					console.log(oResult);

					// var aResult = JSON.parse(oResult);
                    if(oResult['nStaEvent']==1){
                            if(oResult['tPDTSpc']=='GN'){
                                JSvASTLoadPdtDataTableHtml();
                            }
                        JCNxCloseLoading();
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