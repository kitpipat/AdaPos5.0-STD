<?php
  if($aDataDocHD['rtCode']=='1'){
    // print_r($aDataDocHD);
    $tXdhDocNo     =   $aDataDocHD['raItems']['FTXdhDocNo'];
    $tXdhDocDate   =   date('Y-m-d',strtotime($aDataDocHD['raItems']['FDXdhDocDate']));
    $tXdhDocTime   =   date('H:i:s',strtotime($aDataDocHD['raItems']['FDXdhDocDate']));
    $tXdhActDate   =   date('Y-m-d',strtotime($aDataDocHD['raItems']['FDXdhActDate']));
    $tXdhActTime   =   date('H:i:s',strtotime($aDataDocHD['raItems']['FDXdhActDate']));
    $tXdhDepName   =   $aDataDocHD['raItems']['FTXdhDepName'];
    $tXdhDepRmk    =   $aDataDocHD['raItems']['FTXdhDepRmk'];
    $tXdhStaDoc    =   $aDataDocHD['raItems']['FTXdhStaDoc'];
    $tXdhStaDep    =   $aDataDocHD['raItems']['FTXdhStaDep'];
    $tXdhStaPreDep =   $aDataDocHD['raItems']['FTXdhStaPreDep'];
    $tXdhUsrApv    =   $aDataDocHD['raItems']['FTXdhUsrApvName'];
    $tXdhUsrPreApv   =   $aDataDocHD['raItems']['FTXdhUsrPreApvName'];
    $tXdhUsrApvPreDep  =   $aDataDocHD['raItems']['FTXdhUsrApvPreDep'];
    $tXdhZipUrl    =   $aDataDocHD['raItems']['FTXdhZipUrl'];
    $tXdhJsonUrl   =   $aDataDocHD['raItems']['FTXdhJsonUrl'];
    $tCreateBy     =   $aDataDocHD['raItems']['FTCreateByName'];
    $nXdhStaForce  =   $aDataDocHD['raItems']['FTXdhStaForce'];
    $tDPYRoute     = 'augDPYEventEdit';
    $nStaUploadFile         = 2;
  }else{
    $tXdhDocNo     =   '';
    $tXdhDocDate   =   date('Y-m-d');
    $tXdhDocTime   =   date('H:i:s');
    $tXdhActDate   =   date('Y-m-d');
    $tXdhActTime   =   date('H:i:s');
    $tXdhDepName   =   '';
    $tXdhDepRmk    =   '';
    $tXdhStaDoc    =   '';
    $tXdhStaDep    =   '';
    $tXdhStaPreDep =   '';
    $tXdhUsrApv    =   '';
    $tXdhUsrPreApv =   '';
    $tXdhUsrApvPreDep  =  '';
    $tXdhZipUrl    =   '';
    $tXdhJsonUrl   =   '';
    $tCreateBy     =   '';
    $nXdhStaForce  =   '';
    $tDPYRoute     = 'augDPYEventAdd';
    $nStaUploadFile         = 1;
  }
?>
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 panel-heading">
<form id="ofmDPYFormAdd" class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data">
    <input  type="hidden"  name="oetDPYRoute" id="oetDPYRoute" value="<?=$tDPYRoute?>">
    <input  type="hidden"  name="oetXdhStaDep" id="oetXdhStaDep" value="<?=$tXdhStaDep?>">
    <input  type="hidden"  name="oetXdhStaPreDep" id="oetXdhStaPreDep" value="<?=$tXdhStaPreDep?>">
    
    <div class="row">
        <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3">
            <!-- Panel รหัสเอกสารและสถานะเอกสาร -->
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div id="odvDPYHeadStatusInfo" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?php echo language('tool/tool/tool', 'tDPYDocument'); ?></label>
                    <a class="xCNMenuplus" role="button" data-toggle="collapse"  href="#odvDPYDatDPYatusInfo" aria-expanded="true">
                        <i class="fa fa-plus xCNPlus"></i>
                    </a>
                </div>
                <div id="odvDPYDatDPYatusInfo" class="panel-collapse collapse in" role="tabpanel">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="form-group xCNHide" style="text-align: right;">
                                    <label class="xCNTitleFrom "><?php echo language('tool/tool/tool', 'tDPYApproved'); ?></label>
                                </div>
                                <input type="hidden" value="0" id="ohdCheckDPYSubmitByButton" name="ohdCheckDPYSubmitByButton"> 
                                <input type="hidden" value="0" id="ohdCheckDPYClearValidate" name="ohdCheckDPYClearValidate"> 
                                <label class="xCNLabelFrm"><span style = "color:red;display:none">*</span><?php echo language('tool/tool/tool', 'tDPYDocNo'); ?></label>
                                <?php if(empty($tXdhDocNo)):?>
                                     <div class="form-group" style="display:none">
                                        <label class="fancy-checkbox">
                                            <input type="checkbox" id="ocbDPYStaAutoGenCode" name="ocbDPYStaAutoGenCode" maxlength="1" checked="true" value="1">
                                            <span class="xCNLabelFrm"><?php echo language('tool/tool/tool', 'tDPYAutoGenCode'); ?></span>
                                        </label>
                                    </div> 
                                <?php endif;?>  
                                <!-- เลขรหัสเอกสาร -->
                                <div class="form-group" style="cursor:not-allowed">
                                    <input 
                                        type="text"
                                        class="form-control xWTooltipsBT xCNInputWithoutSpcNotThai xCNInputWithoutSingleQuote"
                                        id="oetDPYDocNo"
                                        name="oetDPYDocNo"
                                        maxlength="10"
                                        value="<?=$tXdhDocNo?>"
                                        data-validate-required="<?php echo language('tool/tool/tool', 'tDPYPlsEnterOrRunDocNo'); ?>"
                                        data-validate-duplicate="<?php echo language('tool/tool/tool', 'tDPYPlsDocNoDuplicate'); ?>"
                                        placeholder="<?php echo language('tool/tool/tool','tDPYDocNo');?>"
                                        style="pointer-events:none"
                                        readonly
                                    >
                                    <input type="hidden" id="ohdDPYCheckDuplicateCode" name="ohdDPYCheckDuplicateCode" value="2">
                                </div>
                                <!-- วันที่ในการออกเอกสาร -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?php echo language('tool/tool/tool','tDPYDocDate');?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNDatePicker xCNInputMaskDate"
                                            id="oetDPYDocDate"
                                            name="oetDPYDocDate"
                                            value="<?=$tXdhDocDate?>"
                                            data-validate-required="<?php echo language('tool/tool/tool', 'tDPYPlsEnterDocDate');?>"
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtDPYDocDate" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                        </span>
                                    </div>
                                </div>
                                <!-- เวลาในการออกเอกสาร -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?php echo language('tool/tool/tool', 'tDPYDocTime');?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNTimePicker"
                                            id="oetDPYDocTime"
                                            name="oetDPYDocTime"
                                            value="<?=$tXdhDocTime?>"
                                            data-validate-required="<?php echo language('tool/tool/tool', 'tDPYPlsEnterDocTime');?>"
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtDPYDocTime" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                        </span>
                                    </div>
                                </div>
                                <!-- ผู้สร้างเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('tool/tool/tool','tDPYCreateBy'); ?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <input type="hidden" id="ohdDPYCreateBy" name="ohdDPYCreateBy" value="<?=$tCreateBy?>">
                                            <label><?=$tCreateBy?></label>
                                        </div>
                                    </div>
                                </div>
                                <!-- สถานะเอกสาร -->
                                 <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('tool/tool/tool','tDPYTBStaDoc'); ?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <label><?php echo language('tool/tool/tool','tDPYStaDoc'.$tXdhStaDoc); ?></label>
                                        </div>
                                    </div>
                                </div> 
                                <!-- สถานะอนุมัติเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('tool/tool/tool','tDPYStaPreDepTitle');?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <label><?php echo language('tool/tool/tool','tDPYStaPreDep'.$tXdhStaPreDep);?></label>
                                        </div>
                                    </div>
                                </div>
                                <!-- สถานะประมวลผลเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('tool/tool/tool','tDPYStaDepTitle');?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <label><?php echo language('tool/tool/tool','tDPYStaDep'.$tXdhStaDep);?></label>
                                        </div>
                                    </div>
                                </div>

                                    <!-- ผู้เตรียมอนุมัติเอกสาร -->
                                    <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('tool/tool/tool', 'tDPYPreApvBy'); ?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <input type="hidden" id="ohdDPYApvCode" name="ohdDPYApvCode" maxlength="20" value="">
                                            <label>
                                                <?=$tXdhUsrPreApv?>
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- ผู้อนุมัติเอกสาร -->
                                <div class="form-group" style="margin:0">
                                    <div class="row">
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                                            <label class="xCNLabelFrm"><?php echo language('tool/tool/tool', 'tDPYApvBy'); ?></label>
                                        </div>
                                        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                                            <input type="hidden" id="ohdDPYApvCode" name="ohdDPYApvCode" maxlength="20" value="">
                                            <label>
                                                <?=$tXdhUsrApv?>
                                            </label>
                                        </div>
                                    </div>
                                </div>


                            </div>
                        </div>
                    </div>
                </div>
            </div>
         

             <!-- Panel เงื่อนไขเอกสาร -->
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div id="odvDPYHeadStatusInfo" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?php echo language('tool/tool/tool', 'tDPYConditionDoc'); ?></label>
                    <a class="xCNMenuplus" role="button" data-toggle="collapse"  href="#odvDPYDatDPYatusInfo2" aria-expanded="true">
                        <i class="fa fa-plus xCNPlus"></i>
                    </a>
                </div>
                <div id="odvDPYDatDPYatusInfo2" class="panel-collapse collapse in" role="tabpanel">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

                            <!-- วันที่ในการออกเอกสาร -->
                            <div class="form-group">
                                <label class="xCNLabelFrm"><?php echo language('tool/tool/tool','tDPYActDate');?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNDatePicker xCNInputMaskDate"
                                            id="oetDPYActDate"
                                            name="oetDPYActDate"
                                            value="<?=$tXdhActDate?>"
                                            data-validate-required="<?php echo language('tool/tool/tool', 'tDPYPlsEnterDocDate');?>"
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtDPYActDate" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                        </span>
                                    </div>
                                </div>
                                <!-- เวลาในการออกเอกสาร -->
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?php echo language('tool/tool/tool', 'tDPYActTime');?></label>
                                    <div class="input-group">
                                        <input
                                            type="text"
                                            class="form-control xCNTimePicker"
                                            id="oetDPYActTime"
                                            name="oetDPYActTime"
                                            value="<?=$tXdhActTime?>"
                                            data-validate-required="<?php echo language('tool/tool/tool', 'tDPYPlsEnterDocTime');?>"
                                        >
                                        <span class="input-group-btn">
                                            <button id="obtDPYActTime" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                        </span>
                                    </div>
                                </div>

                                <div class="form-group" >
                                <label class="xCNLabelFrm"><span style = "color:red;">*</span><?php echo language('tool/tool/tool','tDPYReleaseName');?></label>
                                    <input 
                                        type="text"
                                        class="form-control xWTooltipsBT  xCNInputWithoutSingleQuote"
                                        id="oetDPYDepName"
                                        name="oetDPYDepName"
                                        maxlength="100"
                                        value="<?=$tXdhDepName?>"
                                        placeholder="<?php echo language('tool/tool/tool','tDPYReleaseName');?>"
                                    >
                                </div>

                                <div class="form-group" >
                                <label class="xCNLabelFrm"><span style = "color:red;">*</span><?php echo language('tool/tool/tool','tDPYZipUrl');?></label><label style="color:red">(*<?php echo language('tool/tool/tool','tDPYDescription');?>)</label>
                                    <input 
                                        type="text"
                                        class="form-control xWTooltipsBT  xCNInputWithoutSingleQuote"
                                        id="oetDPYZipUrl"
                                        name="oetDPYZipUrl"
                                        maxlength="200"
                                        value="<?=$tXdhZipUrl?>"
                                        placeholder="<?php echo language('tool/tool/tool','tDPYZipUrl');?>"
                                    >
                                </div>

                                <!-- <div class="form-group" >
                                <label class="xCNLabelFrm"><?php echo language('tool/tool/tool','tDPYJsonUrl');?></label>
                                    <input 
                                        type="text"
                                        class="form-control xWTooltipsBT  xCNInputWithoutSingleQuote"
                                        id="oetDPYJsonUrl"
                                        name="oetDPYJsonUrl"
                                        maxlength="200"
                                        value="<?=$tXdhJsonUrl?>"
                                        placeholder="<?php echo language('tool/tool/tool','tDPYJsonUrl');?>"
                                    >
                                </div> -->

                                <div class="form-group" >
                                <label class="xCNLabelFrm"><?php echo language('tool/tool/tool','tDPYRrmk');?></label>
                                    <textarea 
                                        type="text"
                                        class="form-control xWTooltipsBT  xCNInputWithoutSingleQuote"
                                        id="oetDPYRemark"
                                        name="oetDPYRemark"
                                        maxlength="255"
                                        placeholder="<?php echo language('tool/tool/tool','tDPYRrmk');?>"
                                    ><?=$tXdhDepRmk?></textarea>
                                </div>

                                <div class="form-group">
                                    <label class="fancy-checkbox">
                                        <input type="checkbox" class="ocbListItem" id="ocbXdhStaForce" name="ocbXdhStaForce" maxlength="1" value="1" <?=  $nXdhStaForce == '1' ? 'checked' : '0'; ?>>
                                        <span class="xCNLabelFrm"><?= language('tool/tool/tool', 'tDPYStaForce'); ?></span>
                                    </label>
                                </div>

                            </div>
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
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="odvDPYShowDataTable">


                            </div>
                        </div>
                    </div>
                </div>
                <script>


                    var oDPYCallDataTableFile = {
                        ptElementID     : 'odvDPYShowDataTable',
                        ptBchCode       : 'tool_deploy',
                        ptDocNo         : $('#oetDPYDocNo').val(),
                        ptDocKey        : 'TCNTAppDepHD',
                        ptSessionID     : '<?= $this->session->userdata("tSesSessionID") ?>',
                        pnEvent         : <?= $nStaUploadFile ?>,
                        ptCallBackFunct : '',
                        ptStaApv        : $('#oetXdhStaPreDep').val(),
                        ptStaDoc        : $('#oetXdhStaPreDep').val()
                    }
                    JCNxUPFCallDataTable(oDPYCallDataTableFile);
                </script>
            </div>
       


        </div>
        <div class="col-xs-12 col-sm-9 col-md-9 col-lg-9">
            <div class="row">
                <!-- ตารางรายการนับสินค้า -->
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" >
                    <div class="panel panel-default" style="margin-bottom:25px;position:relative;min-height:200px;">
                        <div id="odvDPYConditionDoc" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                            <label class="xCNTextDetail1"><?php echo language('tool/tool/tool','tDPYDTTitle');?></label>
                            <!-- <a class="xCNMenuplus" role="button" data-toggle="collapse" href="#odvDPYDataConditionDoc" aria-expanded="true">
                                <i class="fa fa-plus xCNPlus"></i>
                            </a> -->
                        </div>
    

                        <div class="panel-collapse collapse in" role="tabpanel" data-grpname="Condition">
                            <div class="panel-body">
                            
                                <div class="row" style="margin-top: 20px;">
                                    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                        <div class="form-group">
                                            <div id="odvPIMngAdvTableList" class="btn-group xCNDropDrownGroup" >
                                                <button type="button" class="btn xCNBTNMngTable xCNImportBtn" id="obtDPYImpExcel" onclick="JSxDPYOpenImportForm()">
                                                    <?= language('common/main/main', 'tImport') ?>
                                                </button>
                                            </div>
                                            <div id="odvCoppy" class="btn-group xCNDropDrownGroup" >
                                                <button type="button" class="btn xCNBTNMngTable xCNImportBtn" id="obtDEPYDocRef" >
                                                    <?= language('tool/tool/tool', 'tUPGUUIDCoppy') ?>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                            

                                    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                        <div class="right">

                                            <!-- <div class="btn-group xCNDropDrownGroup">
                                                <button  type="button" class="btn xCNBTNMngTable xWDPYDisabledOnApv" data-toggle="dropdown">
                                                    <?php echo language('common/main/main', 'tCMNOption') ?>
                                                    <span class="caret"></span>
                                                </button>
                                                <ul class="dropdown-menu" role="menu">
                                                    <li id="oliDPYDelPdtDT" class="disabled">
                                                        <a data-toggle="modal" data-target="#odvDPYModalDelPdtDTTemp"><?php echo language('common/main/main', 'tDelAll') ?></a>
                                                    </li>
                                                </ul>
                                            </div> -->
                                            <div class="btn-group">
                                                <button  id="obtDPYAddApp"  class="xCNBTNPrimeryPlus hideCRNameColum"   type="button">+</button>
                                            </div>
                                        </div>
                                    </div>

                          
                                </div>
                                <div class="" id="odvDPYPdtTablePanal">

                                        <table  class="table xWPdtTableFont" id="otbDataDocDT" style="margin-top: 25px;">
                                                <thead>
                                                    <tr class="xCNCenter">
                                                        <th nowrap class="xCNTextBold" style="width:5%;"  ><?php echo language('tool/tool/tool','tDPYSpcNo')?></th>
                                                        <th nowrap class="xCNTextBold" style="width:20%;"><?php echo language('tool/tool/tool','tDPYDTApp')?></th>
                                                        <th nowrap class="xCNTextBold" style="width:20%;"><?php echo language('tool/tool/tool','tDPYDTVer')?></th>
                                                        <th nowrap class="xCNTextBold" style="width:50%;"><?php echo language('tool/tool/tool','tDPYDTPath')?></th>
                                                        <th nowrap class="xCNTextBold" style="width:5%;"><?php echo language('tool/tool/tool','tDPYSpcDel')?></th>
                                                    </tr>
                                                </thead>
                                                <tbody id="otbConditionDPYApp">

                                                    <tr id="otbAppItemNotFound" style="display:none">
                                                        <td colspan="5" align="center"><?php echo language('tool/tool/tool','tDPYSpcNotFound')?></td>
                                                    </tr>
                                                    <?php 
                                                        if($aDataDocDT['rtCode']=='1'){
                                                            foreach($aDataDocDT['raItems'] as $nKey => $aData){
                                                                $nDPYSeq = $aData['FNXddSeq'];
                                                    ?>
                                                        <tr class='otrDPYApp' id='otrDPYAppRowID<?=$nDPYSeq?>'>
                                                        <td align='center' class='otdColRowID_App' ><?=$nDPYSeq?></td>
                                                        <td ><input type='text' name='oetDPTAppCode[<?=$nDPYSeq?>]' class='oetDPTAppCode'   maxlength="50" value='<?=$aData['FTAppCode']?>'></td>
                                                        <td ><input type='text' name='oetDPTAppVersion[<?=$nDPYSeq?>]' class='oetDPTAppVersion'  maxlength="50" value='<?=$aData['FTAppVersion']?>'></td>
                                                        <td ><input type='text' name='oetDPTAppPath[<?=$nDPYSeq?>]' class='oetDPTAppPath'  maxlength="100" value='<?=$aData['FTXdhAppPath']?>'></td>
                                                        <td align='center'><img onclick='JSxDPYAppRemoveRow(<?=$nDPYSeq?>)' class='xCNIconTable xCNIconDel' src='<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>' ></td>
                                                    </tr>
                                                    <?php } 
                                                            }else{ ?>
                                                    <tr class='otrDPYApp' id='otrDPYAppRowID1'>
                                                        <td align='center' class='otdColRowID_App' >1</td>
                                                        <td ><input type='text' name='oetDPTAppCode[1]' class='oetDPTAppCode' maxlength="50" value=''></td>
                                                        <td ><input type='text' name='oetDPTAppVersion[1]' class='oetDPTAppVersion'  maxlength="50" value=''></td>
                                                        <td ><input type='text' name='oetDPTAppPath[1]' class='oetDPTAppPath'  maxlength="100" value=''></td>
                                                        <td align='center'><img onclick='JSxDPYAppRemoveRow(1)' class='xCNIconTable xCNIconDel' src='<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>' ></td>
                                                    </tr>
                                                    <?php } ?>

                                                </tbody>
                                            </table>

                                </div>
                                <input type="hidden" id="ohdConfirmIDDelete">
                            </div>
                        </div>
                    </div>
                </div>
            </div>    
                   <!-- Panel เงื่อนไขเอกสาร -->
                   <div class="panel panel-default" style="margin-bottom: 25px;">
                        <div id="odvDPYConditionDoc" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                            <label class="xCNTextDetail1"><?php echo language('tool/tool/tool','tDPYConditionDocPos');?></label>
                            <!-- <a class="xCNMenuplus" role="button" data-toggle="collapse" href="#odvDPYDataConditionDoc" aria-expanded="true">
                                <i class="fa fa-plus xCNPlus"></i>
                            </a> -->
                        </div>
    
                        <div id="odvDPYCRBch" class=" panel-collapse collapse in" role="tabpanel">
                                <div class="panel-body">
                                            <div class="row">
                                                <div class="col-md-12">

                                                            
                                                        <div class="row" style="margin-top: 20px;"> 
                                                             <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                                                    <button id="obtTabConditionDPYBch"  class="xCNBTNPrimeryPlus hideCRNameColum" type="button">+</button>
                                                            </div>
                                                        </div>
                                                                <div class="table-responsive">   
                                                    
                                                                <table  class="table xWPdtTableFont" style="margin-top: 25px;">
                                                                    <thead>
                                                                       <tr class="xCNCenter">
                                                                            <th nowrap class="xCNTextBold" style="width:5%;"  ><?php echo language('tool/tool/tool','tDPYSpcNo')?></th>
                                                                            <th nowrap class="xCNTextBold" style="width:10%;"><?php echo language('tool/tool/tool','tDPYSpcType')?></th>
                                                                            <th nowrap class="xCNTextBold" style="width:20%;"><?php echo language('tool/tool/tool','tDPYSpcAgnName')?></th>
                                                                            <th nowrap class="xCNTextBold" style="width:20%;"><?php echo language('tool/tool/tool','tDPYSpcBchName')?></th>
                                                                            <th nowrap class="xCNTextBold" style="width:20%;"><?php echo language('tool/tool/tool','tDPYSpcPosName')?></th>
                                                                            <th nowrap class="xCNTextBold" style="width:5%;"><?php echo language('tool/tool/tool','tDPYSpcDel')?></th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody id="otbConditionDPYBch">
                                                                    <?php 
                                                                        if($aDataDocHDBch['rtCode']=='1'){
                                                                            foreach($aDataDocHDBch['raItems'] as $nKey => $aData){
                                                                                $nDPYSeq = $nKey+1;
                                                                            ?>
                                                                        <tr id="otbItemNotFound" style="display:none">
                                                                            <td colspan="6" align="center"><?php echo language('tool/tool/tool','tDPYSpcNotFound')?></td>
                                                                        </tr>
                                                                            <tr class='otrInclude' id='otrRddBchRowID<?=$nDPYSeq?>'>
                                                                                    <td align='center' class='otdColRowID_Bch' ><?=$nDPYSeq?></td>
                                                                                    <td ><?php echo language('tool/tool/tool','tDPYStaType'.$aData['FTXdhStaType'])?></td>
                                                                                    <td>
                                                                                    <input type='hidden' name='ohdDPYAgnCode[<?=$nDPYSeq?>]' class='ohdDPYAgnCode' tRddAgnName='<?=$aData['FTAgnName']?>' value='<?=$aData['FTXdhAgnTo']?>'>
                                                                                    <input type='hidden' name='ohdDPYBchCode[<?=$nDPYSeq?>]' class='ohdDPYBchCode' tRddBchName='<?=$aData['FTBchName']?>' value='<?=$aData['FTXdhBchTo']?>'>
                                                                                    <input type='hidden' name='ohdDPYPosCode[<?=$nDPYSeq?>]' class='ohdDPYPosCode' tRddPosName='<?=$aData['FTPosName']?>' value='<?=$aData['FTXdhPosTo']?>'>
                                                                                
                                                                                    <input type='hidden' name='ohdRddBchModalType[<?=$nDPYSeq?>]' class='ohdRddBchModalType' value='<?=$aData['FTXdhStaType']?>'>
                                                                                    <?=$aData['FTAgnName']?></td>
                                                                                    <td><?=$aData['FTBchName']?></td>
                                                                                    <td><?=$aData['FTPosName']?></td>
                                                                                    <td align='center'><img onclick='JSxRddBchRemoveRow(<?=$nDPYSeq?>)' class='xCNIconTable xCNIconDel' src='<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>' ></td>
                                                                            </tr>
                                                                            <?php } 
                                                                        }else{ ?>
                                                                        <tr id="otbItemNotFound" >
                                                                            <td colspan="6" align="center"><?php echo language('tool/tool/tool','tDPYSpcNotFound')?></td>
                                                                        </tr>
                                                                        <?php } ?>
                                                                    </tbody>
                                                                </table>

                                                            </div>
                                                    </div>
                                            </div>
                                </div>

                        </div>
                    </div>
        </div>
    </div>
</form>
</div>
<!-- ============================================================================================================================================================== -->


<div  class="modal fade" id="odvDPYCRModalBch" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
    <div class="modal-header">
                <h5 class="xCNHeardModal modal-title" style="display:inline-block"><?=language('document/conditionredeem/conditionredeem','tRdhCreateGroupCrBch')?></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
      <div class="modal-body">
  
        <div class='row'>


           <div class='col-lg-12'>
                        <div class='form-group'>
                            <label class="xCNLabelFrm"><?=language('document/couponsetup/couponsetup','tCPHAgency')?></label>
                            <div class='input-group'>
                                <input type='text' class='form-control xCNHide xWCPHAllInput' id='oetRddAgnCodeTo' name='oetRddAgnCodeTo' value="<?=$this->session->userdata('tSesUsrAgnCode')?>" maxlength='5'>
                                <input type='text' class='form-control xWPointerEventNone xWCPHAllInput' id='oetRddAgnNameTo' name='oetRddAgnNameTo'  value="<?=$this->session->userdata('tSesUsrAgnName')?>" readonly>
                                <span class='input-group-btn'>
                                    <button id='obtCPHBrowseAgnTo' type='button' class='btn xCNBtnBrowseAddOn' <?php    if($this->session->userdata('tSesUsrLevel')!='HQ'){ echo 'disabled'; } ?>><img class='xCNIconFind'></button>
                                </span>
                            </div>
                        </div>
                    </div>


                <div class='col-lg-12'>
                        <div class='form-group'>
                            <label class="xCNLabelFrm"><?=language('company/branch/branch','tBCHTitle')?></label>
                            <div class='input-group'>
                                <input type='text' class='form-control xCNHide xWRddAllInput' id='oetRddBchCodeTo' name='oetRddBchCodeTo' maxlength='5'>
                                <input type='text' class='form-control xWPointerEventNone xWRddAllInput' id='oetRddBchNameTo' name='oetRddBchNameTo' readonly>
                                <span class='input-group-btn'>
                                    <button id='obtRddBrowseBchTo' type='button' class='btn xCNBtnBrowseAddOn'><img class='xCNIconFind'></button>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- <div class='col-lg-12' >
                        <div class='form-group'>
                        <label class="xCNLabelFrm"><?=language('company/merchant/merchant','tMerchantTitle')?></label>
                            <div class='input-group'>
                                <input type='text' class='form-control xCNHide xWRddAllInput' id='oetRddMerCodeTo' name='oetRddMerCodeTo' maxlength='5'>
                                <input type='text' class='form-control xWPointerEventNone xWRddAllInput' id='oetRddMerNameTo' name='oetRddMerNameTo' readonly>
                                <span class='input-group-btn'>
                                    <button id='obtRddBrowseMerTo' type='button' class='btn xCNBtnBrowseAddOn'><img class='xCNIconFind'></button>
                                </span>
                            </div>
                        </div>
                    </div> -->

                <div class='col-lg-12' >
                    <div class='form-group'>
                    <label class="xCNLabelFrm"><?=language('pos/salemachine/salemachine','tPOSTitle')?></label>
                        <div class='input-group'>
                            <input type='text' class='form-control xCNHide xWRddAllInput' id='oetRddPosCodeTo' name='oetRddPosCodeTo' maxlength='5'>
                            <input type='text' class='form-control xWPointerEventNone xWRddAllInput' id='oetRddPosNameTo' name='oetRddPosNameTo' readonly>
                            <span class='input-group-btn'>
                                <button id='obtRddBrowsePosTo' type='button' class='btn xCNBtnBrowseAddOn' disabled><img class='xCNIconFind'></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class='col-lg-12'>
                        <div class='form-group'>
                        <label class="xCNLabelFrm"><?php echo language('document/conditionredeem/conditionredeem','tRdhGroupConditionRedeemGroupType')?></label>
                      
                                        <select class="form-control" name="ocmRddBchModalType" id="ocmRddBchModalType">
                                        <option value="1"><?php echo language('document/conditionredeem/conditionredeem','tRdhGroupConditionRedeemTypeInclude')?></optoion>
                                        <option value="2"><?php echo language('document/conditionredeem/conditionredeem','tRdhGroupConditionRedeemTypeExclude')?></optoion>
                                        </select>
                           
                        </div>
                    </div>

            </div>
    
      </div>
      <div class="modal-footer">
        <button type="button"  class="btn xCNBTNPrimery" id="obtRddCreateBch" ><?=language('common/main/main','เพิ่ม')?></button>
        <button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?=language('common/main/main','ปิด')?></button>
      </div>
    </div>
  </div>
</div>




<!-- Modal เวลากด Import File -->
<div class="modal fade" id="odvDPYModalImportFile" data-toggle="modal" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" style="overflow: hidden auto; z-index: 7000; display: none;">
    <div class="modal-dialog" role="document" style="width: 450px; margin: 1.75rem auto;top:20%;">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <div class="row">
                    <div class="col-xs-12 col-md-6">
                        <label class="xCNTextModalHeard" style="font-weight: bold; font-size: 20px;"><?=language('common/main/main', 'tTitleTempalateImport');?> </label>
                    </div>
                </div>
            </div>
            <div class="modal-body">
                <input type="hidden" id="ohdDPYImportExcel" name="ohdImportExcel" value="<?=language('common/main/main', 'tPleseImportFile');?>" >
                <div id="odvDPYContentFileImport">
                    <div class="form-group">
                        <div class="input-group">
            
                            
                            <input type="text" class="form-control" id="oetDPYFileNameImport" name="oetDPYFileNameImport" placeholder="<?=language('common/main/main', 'tSelectedImport');?>  " readonly="">
                            <input type="file" class="form-control" style="visibility: hidden; position: absolute;" id="oefDPYFileImportExcel" name="oefDPYFileImportExcel" onchange="JSxDPYCheckFileImportFile(this, event)" 
                            accept=".csv,application/vnd.ms-excel,.xlt,application/vnd.ms-excel,.xla,application/vnd.ms-excel,.xlsx,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,.xltx,application/vnd.openxmlformats-officedocument.spreadsheetml.template,.xlsm,application/vnd.ms-excel.sheet.macroEnabled.12,.xltm,application/vnd.ms-excel.template.macroEnabled.12,.xlam,application/vnd.ms-excel.addin.macroEnabled.12,.xlsb,application/vnd.ms-excel.sheet.binary.macroEnabled.12">
                            <span class="input-group-btn">
                                <button type="button" class="btn btn-primary" style="border-radius: 0px 5px 5px 0px;" onclick="$('#oefDPYFileImportExcel').click()">
                                 <?=language('common/main/main', 'tSelectedImport');?>                                                            
                                </button>
                                <button class="btn xCNBTNPrimery xCNBTNPrimery2Btn" style="border-radius: 0px !important; margin-left: 30px; width: 100px;" id="obtDPYIMPConfirmUpload" onclick="JSxDPYImportFileExcel()"><?php echo language('common/main/main', 'tCMNOK') ?></button>  
                            </span>
                        </div>
                    </div>
                    <div id="odvDPYMngTableList" class="btn-group xCNDropDrownGroup">
                        <a id="oahDPYDowloadTemplate" href="<?=base_url('application/modules/common/assets/template/Branch_Template.xlsx')?>">
                            <u><?=language('common/main/main', 'tDowloadTemplate');?></u>
                        </a>
                    </div>
                </div>
                <div id="odvDPYContentRenderHTMLImport"></div>
            </div>
            <div class="modal-footer">
                <div class="row">
                    <div class="col-lg-6">
                        <span id="ospDPYTextSummaryImport" style="text-align: left; display: block; font-weight: bold;"></span>
                    </div>
                    <div class="col-lg-6">
                        <button class="btn xCNBTNPrimery xCNBTNPrimery2Btn" id="obtDPYIMPUpdateAgain" style="display:none;"><?php echo language('common/main/main', 'tImportAgain') ?></button>
                        <button class="btn xCNBTNPrimery xCNBTNPrimery2Btn" id="obtDPYIMPConfirm" style="display:none;"><?php echo language('common/main/main', 'tImportConfirm') ?></button>
                        <button class="btn xCNBTNDefult xCNBTNDefult2Btn" id="obtDPYIMPCancel" data-dismiss="modal"><?php echo language('common/main/main', 'tCancel') ?></button> 
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<!-- ================================================================= View Modal Appove Document ================================================================= -->
<div id="odvDPYModalAppoveDoc" class="modal fade xCNModalApprove">
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
                    <button  id="obtDPYConfirmApprDoc" type="button" class="btn xCNBTNPrimery"><?php echo language('common/main/main', 'tModalConfirm'); ?></button>
                    <button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel'); ?></button>
                </div>
            </div>
        </div>
</div>



<!-- ================================================================= View Modal Appove Document ================================================================= -->
<div id="odvDPYModalAppoveDocDep" class="modal fade xCNModalApprove">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="xCNHeardModal modal-title" style="display:inline-block"><?php echo language('tool/tool/tool','tCMNApproveDepTitle'); ?></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p><strong><?php echo language('tool/tool/tool','tCMNApproveDepDesc'); ?></strong></p>
                </div>
                <div class="modal-footer">
                    <button  id="obtDPYConfirmApprDocDep" type="button" class="btn xCNBTNPrimery"><?php echo language('common/main/main', 'tModalConfirm'); ?></button>
                    <button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel'); ?></button>
                </div>
            </div>
        </div>
</div>



    <div class="modal fade" id="odvDPYPopupCancel">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header xCNModalHead">
                    <label class="xCNTextModalHeard"><?php echo language('tool/tool/tool', 'tDPYCanDoc'); ?></label>
                </div>
                <div class="modal-body">
                    <p id="obpMsgApv"><?php echo language('tool/tool/tool', 'tDPYDocRemoveCantEdit'); ?></p>
                    <p><strong><?php echo language('tool/tool/tool', 'tDPYCancel'); ?></strong></p>
                </div>
                <div class="modal-footer">
                    <button onclick="JSnDPYCancelDoc(true)" type="button" class="btn xCNBTNPrimery">
                        <?php echo language('common/main/main', 'tModalConfirm'); ?>
                    </button>
                    <button type="button" class="btn xCNBTNDefult" data-dismiss="modal">
                        <?php echo language('common/main/main', 'tModalCancel'); ?>
                    </button>
                </div>
            </div>
        </div>
</div>

<script src="<?php echo base_url('application/modules/common/assets/js/jquery.mask.js')?>"></script>
<script src="<?php echo base_url('application/modules/common/assets/src/jFormValidate.js')?>"></script>
<?php include('script/jDeployAdd.php'); ?>
