<?php
if ($aResult['rtCode'] == "1") {
    
    $tPdsCode           = $aResult['raItems']['FTPdsCode'];
    $tPdsAgnCode          = $aResult['raItems']['FTAgnCode'];
    $tPdsAgnName          = $aResult['raItems']['FTAgnName'];
    $tPdsMatchStr      = $aResult['raItems']['FTPdsMatchStr'];
    $nPdsLenBar        = $aResult['raItems']['FNPdsLenBar'];
    $nPdsLenPdt        = $aResult['raItems']['FNPdsLenPdt'];
    $nPdsPdtStart      = $aResult['raItems']['FNPdsPdtStart'];
    $nPdsLenPri        = $aResult['raItems']['FNPdsLenPri'];
    $nPdsPriStart      = $aResult['raItems']['FNPdsPriStart'];
    $nPdsPriDec        = $aResult['raItems']['FNPdsPriDec'];
    $nPdsLenWeight     = $aResult['raItems']['FNPdsLenWeight'];
    $nPdsWeightStart   = $aResult['raItems']['FNPdsWeightStart'];
    $nPdsWeightDec     = $aResult['raItems']['FNPdsWeightDec'];
    $tPdsStaChkDigit   = $aResult['raItems']['FTPdsStaChkDigit'];
    $tPdsStaUse        = $aResult['raItems']['FTPdsStaUse'];

    $tRoute         = "settingpdtscaleEventEdit";

  

} else {
    $tPdsCode          = '';
    $tPdsAgnCode       = $this->session->userdata("tSesUsrAgnCode");
    $tPdsAgnName       = $this->session->userdata("tSesUsrAgnName");
    $tPdsMatchStr      = '';
    $nPdsLenBar        = 0;
    $nPdsLenPdt        = 0;
    $nPdsPdtStart      = 1;
    $nPdsLenPri        = 0;
    $nPdsPriStart      = 0;
    $nPdsPriDec        = 0;
    $nPdsLenWeight     = 0;
    $nPdsWeightStart   = 0;
    $nPdsWeightDec     = 0;
    $tPdsStaChkDigit   = 1;
    $tPdsStaUse        = 1;
    $tRoute         = "settingpdtscaleEventAdd";

}
?>
<!-- <form class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data" autocorrect="off" autocapitalize="off" autocomplete="off" id="ofmAddPDS"> -->
<form id="ofmAddPDS" class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data">

<button style="display:none" type="submit" id="obtSubmitPDS" onclick="JSnPDSEventAddEdit('<?= $tRoute ?>')" data-validatefale='<?php echo language('product/settingpdtscale/settingpdtscale','tPDSValidateFalse')?>'></button>

        <div class="row">
        
            <div class="col-md-6">
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div id="odvSOHeadStatusInfo" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?php echo language('product/settingpdtscale/settingpdtscale','tPDSPanelSetting'); ?></label>
                </div>
                <div class="panel-body">
                <div class="form-group">
                    <label class="xCNLabelFrm"><span class="text-danger">*</span><?php echo language('product/settingpdtscale/settingpdtscale','tPDSTBCode')?></label>
                    <div id="odvPDSAutoGenCode" class="form-group">
                        <div class="validate-input">
                            <label class="fancy-checkbox">
                                <input type="checkbox" id="ocbPDSAutoGenCode" name="ocbPDSAutoGenCode" checked="true" value="1">
                                <span> <?php echo language('common/main/main', 'tGenerateAuto'); ?></span>
                            </label>
                        </div>
                    </div>

                    <div id="odvPDSCodeForm" class="form-group">
                        <input type="hidden" id="ohdCheckDuplicatePDSCode" name="ohdCheckDuplicatePDSCode" value="1">
                        <input type="hidden" id="ohdPDSCode" name="ohdPDSCode" value="<?= $tPdsCode; ?>">

                        <div class="validate-input">
                            <input type="text" class="form-control xCNGenarateCodeTextInputValidate" 
                            maxlength="5" 
                            id="oetPDSCode" 
                            name="oetPDSCode" 
                            value="<?= $tPdsCode; ?>" 
                            data-is-created="<?= $tPdsCode; ?>" 
                            placeholder="<?php echo language('product/settingpdtscale/settingpdtscale','tPDSTBCode')?>" 
                            data-validate-required="<?php echo language('product/settingpdtscale/settingpdtscale','tPDSValidSPCode')?>" 
                            data-validate-dublicateCode="<?php echo language('product/settingpdtscale/settingpdtscale','tPDSVldCodeDuplicate')?>">
                        </div>
                    </div>
                </div>



                <?php
                if ($tRoute ==  "settingpdtscaleEventAdd") {
                    // $tCstAgnCode   = $tSesAgnCode;
                    // $tCstAgnName   = $tSesAgnName;
                    $tDisabled     = '';
                    $tNameElmIDAgn = 'oimPDSBrowseAgn';
                } else {
                    // $tCstAgnCode    = $tCstAgnCode;
                    // $tCstAgnName    = $tCstAgnName;
                    $tDisabled      = 'disabled';
                    $tNameElmIDAgn  = 'oimPDSBrowseAgn';
                }
                ?>

         
                <!-- เพิ่ม AD Browser -->
                <div class="form-group  <?php if (!FCNbGetIsAgnEnabled()) : echo 'xCNHide';
                    endif; ?>">
                    <label class="xCNLabelFrm"><?php echo language('product/pdtgroup/pdtgroup', 'tPGPAgency') ?></label>
                    <div class="input-group"><input type="text" class="form-control xCNHide" id="oetPDSAgnCode" name="oetPDSAgnCode" maxlength="10" value="<?= @$tPdsAgnCode; ?>">
                        <input type="text" class="form-control xWPointerEventNone" id="oetPDSAgnName" name="oetPDSAgnName" maxlength="100" placeholder="<?php echo language('interface/connectionsetting/connectionsetting', 'tTBAgency') ?>" value="<?= @$tPdsAgnName; ?>" readonly>
                        <span class="input-group-btn">
                            <button id="<?= @$tNameElmIDAgn; ?>" type="button" class="btn xCNBtnBrowseAddOn" <?= @$tDisabled ?>>
                                <img src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                            </button>
                        </span>
                    </div>
                </div> 

                <div class="row">
                    <div class="col-md-8">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSLength') ?></label>
                    
                            <input type="number" class="form-control text-right xPDSCheckValidate" id="oetPDSLenBar" name="oetPDSLenBar" value="<?=$nPdsLenBar?>" onkeydown="if(event.key==='.'){event.preventDefault();}"  oninput="event.target.value = event.target.value.replace(/[^0-9]*/g,'');">
                                
                            
                        </div> 
                    </div>
                    <div class="col-md-4" style="margin-top: 28px;">
                    <label class="fancy-checkbox">
                            <input type="checkbox" id="ocbPdsStaChkDigit" class="xPDSCheckValidate" name="ocbPdsStaChkDigit" <?php  if($tPdsStaChkDigit=='1'){ echo 'checked="true"';  } ?>  value="1">
                            <span> <?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCheckDigit'); ?></span>
                    </label>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-8">

                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCLenPdt') ?></label>
                            <input type="number" class="form-control text-right xPDSCheckValidate" id="oetPDSLenPdt" name="oetPDSLenPdt" value="<?=$nPdsLenPdt?>" onkeydown="if(event.key==='.'){event.preventDefault();}"  oninput="event.target.value = event.target.value.replace(/[^0-9]*/g,'');">
                        </div> 
                    </div>

                    <div class="col-md-4" style="margin-top: 28px;">
                        <label class="fancy-checkbox">
                        <input type="checkbox" id="ocbPDSCheckMathStr" class="xPDSCheckValidate" name="ocbPDSCheckMathStr" <?php  if($nPdsPdtStart=='1'){ echo 'checked="true"';  } ?>  value="1">
                            <span> <?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCheckDigitSum'); ?></span>
                        </label>
                    </div>
                </div>




                <div class="row">


                    <!-- ตัวเริ่มต้น -->
                    <div class="col-md-8">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCMathStr') ?></label>
                            <input type="text" class="form-control xPDSCheckValidate" id="oetPDSMatchStr" name="oetPDSMatchStr"   maxlength="2"  value="<?=$tPdsMatchStr?>" >
                        </div> 
                    </div>

                    <!-- ตำแหน่ง -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCLoc') ?></label>
                            <input type="number" class="form-control text-right" id="oetPDSPdtStart" name="oetPDSPdtStart" value="<?=$nPdsPdtStart?>" readonly="true">
                        </div> 
                    </div>

                </div>


                <div class="row">

                    <!-- ความยาวราคา -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCLenPri') ?></label>
                            <input type="number" class="form-control text-right xPDSCheckValidate" id="oetPDSLenPri" name="oetPDSLenPri" value="<?=$nPdsLenPri?>" onkeydown="if(event.key==='.'){event.preventDefault();}"  oninput="event.target.value = event.target.value.replace(/[^0-9]*/g,'');" >
                        </div> 
                    </div>

                    <!-- ทศนิยม -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCDec') ?></label>
                            <input type="number" class="form-control text-right xPDSCheckValidate" id="oetPDSPriDec" name="oetPDSPriDec" value="<?=$nPdsPriDec?>" onkeydown="if(event.key==='.'){event.preventDefault();}"  oninput="event.target.value = event.target.value.replace(/[^0-9]*/g,'');">
                        </div> 
                    </div>

                    <!-- ตำแหน่ง -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCLoc') ?></label>
                            <input type="number" class="form-control text-right xPDSCheckValidate" id="oetPDSPriStart" name="oetPDSPriStart" value="<?=$nPdsPriStart?>" readonly="true">
                        </div> 
                    </div>

                </div>


                <div class="row">

                    <!-- ความยาวน้ำหนัก -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCLenWeigth') ?></label>
                            <input type="number" class="form-control text-right xPDSCheckValidate" id="oetPDSLenWeight" name="oetPDSLenWeight" value="<?=$nPdsLenWeight?>" onkeydown="if(event.key==='.'){event.preventDefault();}"  oninput="event.target.value = event.target.value.replace(/[^0-9]*/g,'');">
                        </div> 
                    </div>

                    <!-- ทศนิยม -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCDec') ?></label>
                            <input type="number" class="form-control text-right xPDSCheckValidate" id="oetPDSWeightDec" name="oetPDSWeightDec" value="<?=$nPdsWeightDec?>" onkeydown="if(event.key==='.'){event.preventDefault();}"  oninput="event.target.value = event.target.value.replace(/[^0-9]*/g,'');">
                        </div> 
                    </div>

                    <!-- ตำแหน่ง -->
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCLoc') ?></label>
                            <input type="number" class="form-control text-right xPDSCheckValidate" id="oetPDSWeightStart" name="oetPDSWeightStart" value="<?=$nPdsWeightStart?>" readonly="true">
                        </div> 
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-3">     
                        <div class="form-group">
                            <label class="fancy-checkbox">
                                <?php
                                if (isset($tPdsStaUse) && $tPdsStaUse == 1) {
                                    $tChecked   = 'checked';
                                } else {
                                    $tChecked   = '';
                                }
                                ?>
                                <input type="checkbox" id="ocbPDSStatusUse" name="ocbPDSStatusUse" value="1" <?php echo $tChecked; ?>>
                                <span> <?php echo language('common/main/main', 'tStaUse'); ?></span>
                            </label>
                        </div>
                    </div>

                        <div class="col-md-9" align="right">   
                            <div class="form-group" id="odvOnCheckValidateError" style="display:none">
                            <label class="" style="color:#f26334" id=""><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSValidateFalse') ?></label>
                            </div> 
                        </div>

                </div>

                </div>
            </div>
        </div>

            <div class="col-md-6">
            <div class="panel panel-default" style="margin-bottom: 25px;">
                <div id="odvSOHeadStatusInfo" class="panel-heading xCNPanelHeadColor" role="tab" style="padding-top:10px;padding-bottom:10px;">
                    <label class="xCNTextDetail1"><?php echo language('product/settingpdtscale/settingpdtscale','tPDSPanelExample'); ?></label>
                </div>
                <div class="panel-body">

                   <div class="form-group">
                        <input type="hidden" class="form-control" id="ohdPDSBarResult" name="ohdPDSBarResult" value="1" >
                    </div> 
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSLengthExample') ?></label>
                        <input type="text" class="form-control xCNPdtScanDigits" id="oetPDSBarResult" name="oetPDSBarResult" value="" >
                    </div> 
                    <div class="form-group" id="odvOnCheckDigits" style="display:none">
                        <label class="xCNLabelFrm" id="oetPDSBarResultText"></label>  <label class="" style="color:#f26334" id="oetPDSBarResultCheckDigit"></label> <label class="" style="color:#f26334" id=""><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSYourCheckDigit') ?></label>
                    </div> 
                    
                                <hr>

                    <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSCMathStr') ?></label> : <label class="xCNLabelFrm" id="olbPDSCMathStr"></label>
                    </div> 
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSPdtCode') ?></label> : <label class="xCNLabelFrm" id="olbPDSPdtCode"></label>
                    </div> 
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSPdtPri') ?></label> : <label class="xCNLabelFrm" id="olbPDSPdtPri"></label>
                    </div> 
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSPdtWeight') ?></label> : <label class="xCNLabelFrm" id="olbPDSPdtWeight"></label>
                    </div> 
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSPdtCheckDigit') ?></label> : <label class="xCNLabelFrm" id="olbPDSPdtCheckDigit"></label>
                    </div> 
            </div>

            </div>
            </div>
        </div>


</form>

<?php include "script/jPdtScaleAdd.php"; ?>
<script src="<?= base_url('application/modules/common/assets/js/jquery.mask.js') ?>"></script>
<script src="<?= base_url('application/modules/common/assets/src/jFormValidate.js') ?>"></script>

<script type="text/javascript">
 

 $('#oetPDSLenPdt').on('keyup',function(){
        var nPdtLen =  $(this).val();
   
        if(nPdtLen==0){
            $(this).val('');
        }
 });


 $('#oetPDSLenPri').on('keyup',function(){
        var nPriLen =  $(this).val();
     
        if(nPriLen==0){
            $(this).val('');
        }
 });

    if (JCNPDSIsUpdatePage()) {
        $("#odvPDSAutoGenCode").hide();
        JSxPDSAsssigLocation();
    }



    $('.xPDSCheckValidate').on('click keyup',function(e){
        JSxPDSAsssigLocation();
    });

    $('#oetPDSBarResult').on('keyup',function(e){
        JSxPDSSplitBarCode($(this).val());
    });
    

    function JSxPDSAsssigLocation(){
     
     var tPDSLenBar = $('#oetPDSLenBar').val();

     if(tPDSLenBar!=0 && tPDSLenBar!=''){

        if($('#ocbPdsStaChkDigit').is(':checked')==true){
        var nPDSStaChkDigit = 1;
        $('#oetPDSBarResult').attr('maxlength',parseInt(tPDSLenBar)-1);
        }else{
        var nPDSStaChkDigit = 2;
        $('#oetPDSBarResult').attr('maxlength',parseInt(tPDSLenBar));
        }

        if($('#ocbPDSCheckMathStr').is(':checked')==true){
        var nPDSCheckMathStr = 1;
        }else{
        var nPDSCheckMathStr = 2;
        }
        
        var nPDSLenPdt = $('#oetPDSLenPdt').val();
        var tPDSMatchStr = $('#oetPDSMatchStr').val();
        if(nPDSCheckMathStr==1){
          var nPDSPdtStart = 1
        }else{
          var nPDSPdtStart = parseInt(tPDSMatchStr.length)+1;
        }
        $('#oetPDSPdtStart').val(nPDSPdtStart);
        var nPDSPdtStart = $('#oetPDSPdtStart').val();


        
        var nPDSLenPri = $('#oetPDSLenPri').val();
        var nPDSPriDec = $('#oetPDSPriDec').val();
        if((nPDSPdtStart!=0 && nPDSPdtStart!='') && (nPDSLenPdt!=0 && nPDSLenPdt!='')){
            var nPDSPriStart = parseInt(nPDSPdtStart)+parseInt(nPDSLenPdt);
        }else{
            var nPDSPriStart = 0;
        }
        $('#oetPDSPriStart').val(nPDSPriStart);
        var nPDSPriStart = $('#oetPDSPriStart').val();

        var nPDSLenWeight = $('#oetPDSLenWeight').val();
        var nPDSWeightDec = $('#oetPDSWeightDec').val();
        if((nPDSPriStart!=0 && nPDSPriStart!='') && (nPDSLenPri!=0 && nPDSLenPri!='')){
            var nPDSWeightStart = parseInt(nPDSPriStart)+parseInt(nPDSLenPri);
        }else{
            var nPDSWeightStart = 0;
        }
        $('#oetPDSWeightStart').val(nPDSWeightStart);
        var nPDSWeightStart = $('#oetPDSWeightStart').val();

        var oDataForRender = {
                tPDSLenBar:tPDSLenBar,
                nPDSStaChkDigit:nPDSStaChkDigit,
                nPDSCheckMathStr:nPDSCheckMathStr,
                nPDSLenPdt:nPDSLenPdt,
                tPDSMatchStr:tPDSMatchStr,
                nPDSPdtStart:nPDSPdtStart,
                nPDSLenPri:nPDSLenPri,
                nPDSPriDec:nPDSPriDec,
                nPDSPriStart:nPDSPriStart,
                nPDSLenWeight:nPDSLenWeight,
                nPDSWeightDec:nPDSWeightDec,
                nPDSWeightStart:nPDSWeightStart
        }

        JSxPDSValidateLength(oDataForRender);
        
    }

    }


    function JSxPDSValidateLength(poData){
        
        if(poData.nPDSStaChkDigit==1){
            var tPDSLenBarMax = parseInt(poData.tPDSLenBar)-1;
        }else{
            var tPDSLenBarMax = parseInt(poData.tPDSLenBar);
        }

        var nSumLenNewKey =  parseInt(poData.nPDSLenPdt)+parseInt(poData.nPDSLenPri)+parseInt(poData.nPDSLenWeight);

        if(poData.nPDSCheckMathStr==2){
            nSumLenNewKey = nSumLenNewKey + parseInt(poData.tPDSMatchStr.length)
        }
        // console.log(nSumLenNewKey);
        // console.log(tPDSLenBarMax);
        if(nSumLenNewKey==tPDSLenBarMax){
            $('#ohdPDSBarResult').val(0);
        }else{
            $('#ohdPDSBarResult').val(1);
        }

       var nPDSBarResult =  $('#ohdPDSBarResult').val();
        if(nPDSBarResult==0 && poData.tPDSMatchStr!=''){
            JSxPDSRenderResultBarCode(poData);
            $('#odvOnCheckValidateError').hide();
        }else{
            $('#oetPDSBarResult').val('');
            $('#odvOnCheckDigits').hide();
            $('#oetPDSBarResultText').text('');
            $('#oetPDSBarResultCheckDigit').text('');
            $('#olbPDSCMathStr').text('');
            $('#olbPDSPdtCode').text('');
            $('#olbPDSPdtPri').text('');
            $('#olbPDSPdtWeight').text('');
            $('#oetPDSBarResultText').text('');
            $('#olbPDSPdtCheckDigit').text('');
            $('#oetPDSBarResultCheckDigit').text('');
            $('#odvOnCheckValidateError').show();

        }
    }

    function JSxPDSRenderResultBarCode(poData){
        var tPdtBarResult = '';
        if(poData.nPDSCheckMathStr==1){
            tPdtBarResult +=poData.tPDSMatchStr;
            var nPDSLenPdt = poData.nPDSLenPdt-parseInt(poData.tPDSMatchStr.length);
        }else{
            tPdtBarResult +=poData.tPDSMatchStr;
            var nPDSLenPdt = poData.nPDSLenPdt;
        }

        for(i=1;i<=nPDSLenPdt;i++){
                tPdtBarResult +=i;
        }
 

        for(i=1;i<=poData.nPDSLenPri;i++){
            tPdtBarResult +=i;
        }

        for(i=1;i<=poData.nPDSLenWeight;i++){
            tPdtBarResult +=i;
        }


        $('#oetPDSBarResult').val(tPdtBarResult);

        if(poData.nPDSStaChkDigit==1){
            var nDigist = JSnPDSCheckdigit(tPdtBarResult);
            // console.log(nDigist);
            $('#odvOnCheckDigits').show();
            $('#oetPDSBarResultText').text(tPdtBarResult);
            $('#oetPDSBarResultCheckDigit').text(nDigist);
        }else{
            $('#odvOnCheckDigits').hide();
            $('#oetPDSBarResultText').text('');
            $('#oetPDSBarResultCheckDigit').text('');
        }

        JSxPDSSplitBarCode(tPdtBarResult);
    }

    function JSnPDSCheckdigit(ptInput) {
        let aInput = ptInput.split('').reverse();

        let nTotal = 0;
        let nI = 1;
        aInput.forEach(nNumber => {
            if(JSbPDSIsNum(nNumber)==true){
                nNumber = parseInt(nNumber);
            }else{
                nNumber = 0;
            }
            if (nI % 2 === 0) {
                nTotal = nTotal + nNumber;
            }
            else
            {
                nTotal = nTotal + (nNumber * 3);
            }
            nI++;
        });

        return (Math.ceil(nTotal / 10) * 10) - nTotal;
    }




    function JSbPDSIsNum(pVal){
        return !isNaN(pVal)
    }


    function JSxPDSSplitBarCode(ptValueBar){
        
        var tPDSLenBar = $('#oetPDSLenBar').val();

        if($('#ocbPdsStaChkDigit').is(':checked')==true){
        var nPDSStaChkDigit = 1;
        }else{
        var nPDSStaChkDigit = 2;
        }

        if($('#ocbPDSCheckMathStr').is(':checked')==true){
        var nPDSCheckMathStr = 1;
        }else{
        var nPDSCheckMathStr = 2;
        }
        
        var nPDSLenPdt = $('#oetPDSLenPdt').val();
        var tPDSMatchStr = $('#oetPDSMatchStr').val();
        var nPDSPdtStart = $('#oetPDSPdtStart').val();
        
        var nPDSLenPri = $('#oetPDSLenPri').val();
        var nPDSPriDec = parseInt($('#oetPDSPriDec').val());
        var nPDSPriStart = $('#oetPDSPriStart').val();

        var nPDSLenWeight = $('#oetPDSLenWeight').val();
        var nPDSWeightDec = $('#oetPDSWeightDec').val();
        var nPDSWeightStart = $('#oetPDSWeightStart').val();

        
       var tMatchStr = ptValueBar.substr(0, tPDSMatchStr.length);

       if(nPDSCheckMathStr==1){
        var tPdsPdtCode = ptValueBar.substr(0, nPDSLenPdt);
       }else{
        var tPdsPdtCode = ptValueBar.substr(parseInt(nPDSPdtStart)-1, nPDSLenPdt);
       }
       var nPDSPdtPri = ptValueBar.substr(parseInt(nPDSPriStart)-1, nPDSLenPri);
       var nPDSPdtWeight = ptValueBar.substr(parseInt(nPDSWeightStart)-1, nPDSLenWeight);

       if(nPDSStaChkDigit==1){
        var nDigist = JSnPDSCheckdigit(ptValueBar);
       }else{
        var nDigist = '';
       }

       if(nPDSPriDec!=0 && nPDSPriDec != ''){
       var nValue1 = (parseInt(nPDSLenPri)-parseInt(nPDSPriDec));
       var nPDSPdtPriNew = nPDSPdtPri.substr(0,nValue1)+'.'+nPDSPdtPri.substr(nValue1,parseInt(nPDSPriDec));
       }else{
        var nPDSPdtPriNew = nPDSPdtPri;
       }

       if(nPDSWeightDec!=0 && nPDSWeightDec != ''){
       var nValue1 = (parseInt(nPDSLenWeight)-parseInt(nPDSWeightDec));
       var nPDSPdtWeightNew = nPDSPdtWeight.substr(0,nValue1)+'.'+nPDSPdtWeight.substr(nValue1,parseInt(nPDSWeightDec));
       }else{
        var nPDSPdtWeightNew = nPDSPdtWeight;
       }

        $('#olbPDSCMathStr').text(tMatchStr);
        $('#olbPDSPdtCode').text(tPdsPdtCode);
        $('#olbPDSPdtPri').text(nPDSPdtPriNew);
        $('#olbPDSPdtWeight').text(nPDSPdtWeightNew);
        $('#oetPDSBarResultText').text(ptValueBar);
        $('#olbPDSPdtCheckDigit').text(nDigist);
        $('#oetPDSBarResultCheckDigit').text(nDigist);
    }




    //BrowseAgn 
    $('#oimPDSBrowseAgn').click(function(e) {
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            JSxCheckPinMenuClose();
            window.oPdtBrowseAgencyOption = oBrowsePDSAgn({
                'tReturnInputCode': 'oetPDSAgnCode',
                'tReturnInputName': 'oetPDSAgnName',
            });
            JCNxBrowseData('oPdtBrowseAgencyOption');
        } else {
            JCNxShowMsgSessionExpired();
        }
    });

    var nLangEdits = <?php echo $this->session->userdata("tLangEdit") ?>;

    //Option Agn
    var oBrowsePDSAgn = function(poReturnInput) {
        var tInputReturnCode = poReturnInput.tReturnInputCode;
        var tInputReturnName = poReturnInput.tReturnInputName;

        var oOptionReturn = {
            Title: ['ticket/agency/agency', 'tAggTitle'],
            Table: {
                Master: 'TCNMAgency',
                PK: 'FTAgnCode'
            },
            Join: {
                Table: ['TCNMAgency_L'],
                On: ['TCNMAgency_L.FTAgnCode = TCNMAgency.FTAgnCode AND TCNMAgency_L.FNLngID = ' + nLangEdits]
            },
            GrideView: {
                ColumnPathLang: 'ticket/agency/agency',
                ColumnKeyLang: ['tAggCode', 'tAggName'],
                ColumnsSize: ['15%', '85%'],
                WidthModal: 50,
                DataColumns: ['TCNMAgency.FTAgnCode', 'TCNMAgency_L.FTAgnName'],
                DataColumnsFormat: ['', ''],
                Perpage: 10,
                OrderBy: ['TCNMAgency.FDCreateOn DESC'],
            },
            CallBack: {
                ReturnType: 'S',
                Value: [tInputReturnCode, "TCNMAgency.FTAgnCode"],
                Text: [tInputReturnName, "TCNMAgency_L.FTAgnName"],
            },
            RouteAddNew: 'agency',
            BrowseLev: 1,
        }
        return oOptionReturn;
    }

    var tStaUsrLevel = '<?php echo $this->session->userdata("tSesUsrLevel"); ?>';


    if (tStaUsrLevel == 'BCH' || tStaUsrLevel == 'SHP') {
        $('#oimPDSBrowseAgn').attr("disabled", true);
    }

</script>