<?php
    //Decimal Save
    // $tDecSave = FCNxHGetOptionDecimalSave();
    if(isset($nStaAddOrEdit) && $nStaAddOrEdit == 1){
        $tRoute             = "cardtypeEventEdit";
        $tCtyCode           = $aCtyData['raItems']['rtCtyCode'];
        $tCtyName           = $aCtyData['raItems']['rtCtyName'];

        $tCtyStatusPay      = $aCtyData['raItems']['rtCtyStaPay'];
        $tCtyPaylimit       = number_format($aCtyData['raItems']['rtCtyCreditLimit'],$nOptDecimalShow);

        $tCtyDeposit        = number_format($aCtyData['raItems']['rtCtyDeposit'],$nOptDecimalShow );
        $tCtyTopupAuto      = number_format($aCtyData['raItems']['rtCtyTopupAuto'],$nOptDecimalShow );
        $tCtyExpiredType    = $aCtyData['raItems']['rtCtyExpiredType'];
        $tCtyExpirePeriod   = $aCtyData['raItems']['rtCtyExpirePeriod'];
        $tCstStaActiveCheck = $aCtyData['raItems']['rtCtyStaAlwRet'];
        $tCtyRmk            = $aCtyData['raItems']['rtCtyRmk'];

        $tCtyStaType        = $aCtyData['raItems']['rtCtyStaShif'];

        $tUsrAgnCode        = $aCtyData['raItems']['rtAgnCode'];
        $tUsrAgnName        = $aCtyData['raItems']['rtAgnName'];

        $tCtyTExpiredType   = $aCtyData['raItems']['rtCtyTExpiredType'];
        $tCtyStaCrdReuse    = $aCtyData['raItems']['rtCtyStaCrdReuse'];
        $tCtyTAStaReset     = $aCtyData['raItems']['rtCtyTAStaReset'];
        $tCtyTAAlwReturn    = $aCtyData['raItems']['rtCtyTAAlwReturn'];
    }else{
        $tRoute              = "cardtypeEventAdd"; 
        $tCtyCode            = "";
        $tCtyName            = "";
        $tCtyDeposit         = number_format(0,$nOptDecimalShow);
        $tCtyTopupAuto       = number_format(0,$nOptDecimalShow);
        $tCtyPaylimit        = number_format(0,$nOptDecimalShow);
        $tCtyExpiredType     = "";
        $tCtyExpirePeriod    = 1;
        $tCstStaActiveCheck  = "";
        $tCtyRmk             = "";
        $tCtyStaType         = 2;
        $tCtyStatusPay       = 1;
        $tUsrAgnCode         = $this->session->userdata("tSesUsrAgnCode");
        $tUsrAgnName         = $this->session->userdata("tSesUsrAgnName");

        $tCtyTExpiredType   = 1;
        $tCtyStaCrdReuse    = 1;
        $tCtyTAStaReset     = 2;
        $tCtyTAAlwReturn    = 2;
    }
?>
<form class="contact100-form validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data" id="ofmAddCardType">
    <button style="display:none" type="submit" id="obtSubmitCardType" onclick="JSoAddEditCardType('<?php echo $tRoute?>')"></button>
    <div class=""><!-- เพิ่มมาใหม่ --> 
        <div class="panel-body" style="padding-top:20px !important;"> <!-- เพิ่มมาใหม่ -->
        <!-- รหัสประเภทบัตร -->
            <div class="row">
                <div class="col-xs-12 col-md-5 col-lg-5">
                    <label class="xCNLabelFrm"><span style="color:red">*</span><?php echo language('payment/cardtype/cardtype','tCTYFrmCtyCode')?></label> 
                    <div class="form-group" id="odvCardtypeAutoGenCode">
                        <div class="validate-input">
                            <label class="fancy-checkbox">
                                <input type="checkbox" id="ocbCardtypeAutoGenCode" name="ocbCardtypeAutoGenCode" checked="true" value="1">
                                <span> <?php echo language('common/main/main', 'tGenerateAuto'); ?></span>
                            </label>
                        </div>
                    </div>

                    <div class="form-group" id="odvCardtypeCodeForm">
                            <input type="hidden" id="ohdCheckDuplicateCtyCode" name="ohdCheckDuplicateCtyCode" value="1">
                            <div class="validate-input">
                                <input 
                                    type="text"
                                    class="form-control xCNInputWithoutSpcNotThai"
                                    maxlength="50"
                                    id="oetCtyCode"
                                    name="oetCtyCode"
                                    placeholder="<?php echo language('payment/cardtype/cardtype','tCTYFrmCtyCode')?>"
                                    value="<?php echo $tCtyCode?>"
                                    data-is-created="<?php echo $tCtyCode; ?>"
                                    data-validate-required = "<?php echo language('payment/cardtype/cardtype','tCTYValidCode')?>"
                                    data-validate-dublicateCode ="<?php echo language('payment/cardtype/cardtype','tCTYValidCodeDup');?>"
                                >
                            </div>
                        </div>

                        <!-- Agency -->
                        <div class="<?php if( !FCNbGetIsAgnEnabled()) : echo 'xCNHide';  endif;?>">
                            <div class="form-group">
                                <label class="xCNLabelFrm"><?php echo language('common/main/main','tAgency')?></label>
                                <div class="input-group">
                                    <input type="text" class="form-control xCNHide" id="oetCTYUsrAgnCode"
                                        name="oetCTYUsrAgnCode" value="<?=@$tUsrAgnCode?>">
                                    <input type="text" class="form-control xWPointerEventNone" id="oetCTYUsrAgnName"
                                        name="oetCTYUsrAgnName"
                                        placeholder="<?php echo language('common/main/main','tAgency')?>"
                                        value="<?=@$tUsrAgnName?>" readonly>
                                    <span class="input-group-btn">
                                        <button id="obtCTYUsrBrowseAgency" type="button" class="btn xCNBtnBrowseAddOn">
                                            <img
                                                src="<?php echo  base_url().'/application/modules/common/assets/images/icons/find-24.png'?>">
                                        </button>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <!-- end Agency -->

                        <!-- ชื่อประเภทบัตร -->
                        <div class="form-group">
                            <div class="validate-input">
                                <label class="xCNLabelFrm"><span style="color:red">*</span><?php echo language('payment/cardtype/cardtype','tCTYFrmCtyName')?></label> 
                                <input 
                                    type="text"
                                    class="form-control"
                                    id="oetCtyName"
                                    name="oetCtyName"
                                    maxlength= "100" 
                                    value="<?php echo $tCtyName;?>"
                                    data-validate-required = "<?php echo language('payment/cardtype/cardtype','tCTYValidName')?>"
                                >
                            </div>
                        </div>

                    <!-- ค่ามัดจำบัตร -->
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('payment/cardtype/cardtype','tCTYDeposit')?></label> <!-- เปลี่ยนชื่อ Class -->
                        <input type="text" class="form-control xCNInputNumericWithDecimal text-right" id="oetCtyDeposit" name="oetCtyDeposit" value="<?php echo $tCtyDeposit;?>" 
                        data-validate="<?php echo language('payment/cardtype/cardtype','tCTYValidDeposit')?>"> <!-- เปลี่ยนชื่อ Class เพิ่ม DataValidate --> <!-- onclick="JCNdValidateComma('oetCtyDeposit',3,'FC');" onfocusout="JCNdValidatelength8Decimal('oetCtyDeposit','FC',3,'<?php echo $nOptDecimalShow?>')" -->
                    </div>
                    <!-- ยอดเติมเงินอัติโนมัติ -->
    		        <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('payment/cardtype/cardtype','tCTYTopupAuto')?></label> <!-- เปลี่ยนชื่อ Class -->
                        <input type="text" class="form-control xCNInputNumericWithDecimal text-right" id="oetCtyTopupAuto" name="oetCtyTopupAuto" value="<?php echo $tCtyTopupAuto;?>" 
                        data-validate="<?php echo language('payment/cardtype/cardtype','tCTYValidTopupAuto')?>" onkeyup="JStCtyDisbledChkboxTopupAuto()"> <!-- เปลี่ยนชื่อ Class เพิ่ม DataValidate --> <!-- onclick="JCNdValidateComma('oetCtyTopupAuto',3,'FC');" onfocusout="JCNdValidatelength8Decimal('oetCtyTopupAuto','FC',3,'<?php echo $nOptDecimalShow?>')" -->
                    </div>

                    <!-- ประเภทหมดอายุ(1=ตามรอบปฏิทิน/2=ตามรอบเวลา) -->
                    <div class="form-group">
                        <label class="xCNLabelFrm"><span style="color:red">*</span><?php echo language('payment/cardtype/cardtype','tCTYTExpiredType')?></label>
                        <select  required  class="selectpicker form-control" id="ocmCtyTExpireType" name="ocmCtyTExpireType" data-live-search="true" data-validate="<?php echo language('payment/cardtype/cardtype','tCTYValidExpirePeriod')?>">
                            <option value='1' <?php echo  (isset($tCtyTExpiredType) && !empty($tCtyTExpiredType) && $tCtyTExpiredType == '1')? "selected":""?>>
                                <?php echo language('payment/cardtype/cardtype','tCTYFrmCldCycle')?>
                            </option>
                            <option value='2' <?php echo  (isset($tCtyTExpiredType) && !empty($tCtyTExpiredType) && $tCtyTExpiredType == '2')? "selected":""?>>
                                <?php echo language('payment/cardtype/cardtype','tCTYFrmTmeCycle')?>
                            </option>
                        </select>
                    </div>

                    <!-- ประเภทหมดอายุ(1=ชั่วโมง/2=วัน/3=เดือน/4=ปี) -->
                    <div class="form-group">
                        <label class="xCNLabelFrm"><span style="color:red">*</span><?php echo language('payment/cardtype/cardtype','tCTYExpiredType')?></label>
                        <select  required  class="selectpicker form-control" id="ocmCtyExpireType" name="ocmCtyExpireType" data-live-search="true" data-validate="<?php echo language('payment/cardtype/cardtype','tCTYValidExpireType')?>">
                            <option value='2' <?php echo  (isset($tCtyExpiredType) && !empty($tCtyExpiredType) && $tCtyExpiredType == '2')? "selected":""?>>
                                <?php echo language('payment/cardtype/cardtype','tCTYFrmDay')?>
                            </option>
                            <option value='1' <?php echo  (isset($tCtyExpiredType) && !empty($tCtyExpiredType) && $tCtyExpiredType == '1')? "selected":""?>>
                                <?php echo language('payment/cardtype/cardtype','tCTYFrmHour')?>
                            </option>
                            <option value='3' <?php echo  (isset($tCtyExpiredType) && !empty($tCtyExpiredType) && $tCtyExpiredType == '3')? "selected":""?>>
                                <?php echo language('payment/cardtype/cardtype','tCTYFrmMonth')?>
                            </option>
                            <option value='4' <?php echo  (isset($tCtyExpiredType) && !empty($tCtyExpiredType) && $tCtyExpiredType == '4')? "selected":""?>>
                                <?php echo language('payment/cardtype/cardtype','tCTYFrmYear')?>
                            </option>
                        </select>
                    </div> 
                    <!-- อายุบัตร -->
                    <div class="form-group">
                        <label class="xCNLabelFrm" id="tCTYExpire"><?php echo language('payment/cardtype/cardtype','tCTYExpireHour')?></label> <!-- เปลี่ยนชื่อ Class -->
                        <input type="text" class="form-control xCNInputNumericWithoutDecimal text-right" maxlength= "4" id="oetCtyExpirePeriod" name="oetCtyExpirePeriod" value="<?php echo $tCtyExpirePeriod?>" 
                        data-validate="<?php echo language('payment/cardtype/cardtype','tCTYValidExpirePeriod')?>">
                    </div>
                    
                    <?php 
                        $tDisable = '';
                        if($tCtyStatusPay == '2'){
                            $tDisable = "disabled";
                        }
                    ?>
                    <!-- ประเภทรูปแบบบัตร -->
                    <div class="form-group"> 
                        <input type="hidden" class="form-control" id="ohdCtyStaType" name="ohdCtyStaType" value='<?php echo $tCtyStaType ?>'> 
                        <label class="xCNLabelFrm"><?php echo language('payment/cardtype/cardtype', 'tCTYFrmCrdStaType');?></label>
                        <select class="selectpicker form-control xCNSelectBox" id="ocmCtyStaType" name="ocmCtyStaType" <?php echo $tDisable ?>>
                            <option value='2' <?php echo ($tCtyStaType == 2)? 'selected':''?>><?php echo language('payment/cardtype/cardtype','tCTYFrmCrdStaTypeDefault')?></option>
                            <option value='1' <?php echo ($tCtyStaType == 1)? 'selected':''?>><?php echo language('payment/cardtype/cardtype','tCTYFrmCrdStaTypeNormal')?></option>
                        </select>
                    </div>

                    <!-- ประเภทการนำไปใช้ -->
                    <div class="form-group"> 
                        <input type="hidden" class="form-control" id="ohdCtyStaCrdReuse" name="ohdCtyStaCrdReuse" value='<?php echo $tCtyStaCrdReuse ?>'> 
                        <label class="xCNLabelFrm"><?php echo language('payment/cardtype/cardtype', 'tCTYFrmCrdStaReuse');?></label>
                        <select class="selectpicker form-control xCNSelectBox" id="ocmCtyStaCrdReuse" name="ocmCtyStaCrdReuse" <?php echo $tDisable ?>>
                            <option value='1' <?php echo ($tCtyStaCrdReuse == 1)? 'selected':''?>><?php echo language('payment/cardtype/cardtype','tCTYFrmCrdStaReuseTypeDefault')?></option>
                            <option value='2' <?php echo ($tCtyStaCrdReuse == 2)? 'selected':''?>><?php echo language('payment/cardtype/cardtype','tCTYFrmCrdStaReuseTypeOneTime')?></option>
                        </select>
                    </div>

                    <!-- สถานะการชำระ เพิ่มมาใหม่ -->
                    <div class="form-group">
                        <label class="xCNLabelFrm"><span style="color:red">*</span><?php echo language('payment/cardtype/cardtype','tCTYStaPay')?></label>
                        <select  required  class="selectpicker form-control" id="ocmCtyStatusPay" name="ocmCtyStatusPay">
                            <option value='1' <?php echo  (isset($tCtyStatusPay) && !empty($tCtyStatusPay) && $tCtyStatusPay == '1')? "selected":""?>>
                                <?php echo language('payment/cardtype/cardtype','tCTYTopupfirst')?>
                            </option>
                            <option value='2' <?php echo  (isset($tCtyStatusPay) && !empty($tCtyStatusPay) && $tCtyStatusPay == '2')? "selected":""?>>
                                <?php echo language('payment/cardtype/cardtype','tCTYPayLater')?>
                            </option>
                        </select>
                    </div>

                    <!-- วงเงืน เพิ่มมาใหม่ -->
                    <div class="form-group">
                        <label class="xCNLabelFrm" id="tCTYPaylimit"><?php echo language('payment/cardtype/cardtype','tCTYPaylimit')?></label> <!-- เปลี่ยนชื่อ Class -->
                        <input type="text" class="form-control xCNInputNumericWithDecimal text-right" id="oetCtyPaylimit" name="oetCtyPaylimit"  onclick="JCNdValidateComma('oetCtyPaylimit',10,'FC');" onfocusout="JCNdValidatelength8Decimal('oetCtyPaylimit','FC',10,'<?php echo $nOptDecimalShow?>')" value="<?php echo $tCtyPaylimit;?>"
                        data-validate="<?php echo language('payment/cardtype/cardtype','tCTYValidPaylimit')?>"> <!-- เปลี่ยนชื่อ Class เพิ่ม DataValidate -->
                    </div>
                  
                    <!-- อนุญาตคืน -->
                    <div class="form-group">
			            <div class="">
                            <label class="fancy-checkbox">
                                <input type="checkbox"  name="ocbCtyStaAlwRet" <?php 
                                    if($tRoute == "cardtypeEventAdd"){
                                        echo "checked";
                                    }else{
                                        echo ($tCstStaActiveCheck == '1') ? "checked" : ''; 
                                    } ?> value="1">
                                <span> <?php echo language('payment/cardtype/cardtype','TCTYStaAlwRet'); ?></span>
                            </label>
                        </div>
                    </div>

                    <!-- ล้างข้อมูลก่อนเติม -->
                    <div class="form-group">
			            <div class="">
                            <label class="fancy-checkbox">
                                <input type="checkbox"  id="ocbCtyTAStaReset" name="ocbCtyTAStaReset" <?php 
                                    if($tRoute == "cardtypeEventAdd"){
                                        // echo "checked";
                                    }else{
                                        echo ($tCtyTAStaReset == '1') ? "checked" : ''; 
                                    } ?> value="1" disabled="disabled">
                                <span> <?php echo language('payment/cardtype/cardtype','tCTYFrmTAStaReset'); ?></span>
                            </label>
                        </div>
                    </div>

                    <!-- อนุญาตคืน เงินเติมอัตโนมัติ -->
                    <div class="form-group">
			            <div class="">
                            <label class="fancy-checkbox">
                                <input type="checkbox" id="ocbCtyTAAlwReturn" name="ocbCtyTAAlwReturn" <?php 
                                    if($tRoute == "cardtypeEventAdd"){
                                        // echo "checked";
                                    }else{
                                        echo ($tCtyTAAlwReturn == '1') ? "checked" : ''; 
                                    } ?> value="1" disabled="disabled">
                                <span> <?php echo language('payment/cardtype/cardtype','tCTYFrmTAAlwReturn'); ?></span>
                            </label>
                        </div>
                    </div>

                    <!-- หมายเหตุ -->
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('payment/cardtype/cardtype','tCTYFrmCtyRmk')?></label> <!-- เปลี่ยนชื่อ Class -->
                        <textarea class="form-control" maxlength="100" rows="4" id="otaCtyRmk" name="otaCtyRmk"><?php echo $tCtyRmk?></textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<?php include 'script/jCardtypeAdd.php';?>
<script src="<?php echo base_url(); ?>application/modules/common/assets/js/jquery.mask.js"></script>
<script src="<?php echo base_url(); ?>application/modules/common/assets/src/jFormValidate.js"></script>

<script>

    $('.xCNSelectBox').selectpicker();

    $('#ocmCtyExpireType').change(function() {
        $('#ocmCtyExpireType-error').hide();
    });

    $('#ocmCtyTExpireType').change(function() {
        $('#ocmCtyTExpireType-error').hide();
    });

    $('#obtGenCodeCardType').click(function(){
        JStGenerateCardTypeCode();
    });

    $('#ocmCtyExpireType').selectpicker();

    $('#ocmCtyTExpireType').selectpicker();
    
    $('#ocmCtyExpireType').change(function(){
        var nStaExpireType = $(this).val();
        //console.log(nStaExpireType);

        switch(nStaExpireType.toString()){
            case '1':
                $('#tCTYExpire').text('<?php echo language('payment/cardtype/cardtype','tCTYExpireHour');?>');
                break;
            case '2':
                $('#tCTYExpire').text('<?php echo language('payment/cardtype/cardtype','tCTYExpireDays');?>');
                break;
            case '3':
                $('#tCTYExpire').text('<?php echo language('payment/cardtype/cardtype','tCTYExpireMonth');?>');
                break;
            case '4':
                $('#tCTYExpire').text('<?php echo language('payment/cardtype/cardtype','tCTYExpireYear');?>');
                break;
            default :
                $('#tCTYExpire').text('<?php echo language('payment/cardtype/cardtype','tCTYExpireHour');?>');
            }
        });

    // **************************************************************************
        // Create By Witsarut 25/10/2019
        $('#ocmCtyStatusPay').selectpicker();

        // ถ้า สถานะการชำระ  เติมเงินก่อน ตรง input วงเงินจะปิด
        // ถ้า สถานะการชำระ  จ่ายทีหลัง ตรง input วงเงินจะเปิด
        $(document).ready(function(){
            var tRoute = "<?php echo $tRoute;?>";
            if(tRoute  == 'cardtypeEventEdit'){
               var nStatusPay = $('#ocmCtyStatusPay').val();
               var tTopupAuto = $("#oetCtyTopupAuto").val()
               if(nStatusPay == "1"){
                 $('#oetCtyPaylimit').attr('readonly','readonly');
               }

               if(tTopupAuto != '' && tTopupAuto > 0) {
                    $("#ocbCtyTAStaReset").attr("disabled",false);
                    $("#ocbCtyTAAlwReturn").attr("disabled",false);
               }
            }else{
                $('#oetCtyPaylimit').attr('readonly','readonly');
            }
        });


        $('#ocmCtyStatusPay').change(function(){
            var nStatusPay = $(this).val();
            if(nStatusPay == "1"){
                $('#oetCtyPaylimit').val('0.00');
                $('#oetCtyPaylimit').attr('readonly','readonly');
            }else{
                $('#oetCtyPaylimit').removeAttr('readonly');
            }
        });

        // ล้างค่า TExpiredType
        $('#ocmCtyTExpireType').change(function(){
            var nStatustExpired = $(this).val();
            // console.log(nStatustExpired);
            switch (nStatustExpired){
                case '1' :
                    // $("#ocmCtyExpireType option[value='2']").attr('selected', 'selected');
                    $('#oetCtyExpirePeriod').val('');
                break;
                case '2' :
                    // $("#ocmCtyExpireType option[value='2']").attr('selected', 'selected');
                    $('#oetCtyExpirePeriod').val('');
                break;
                default : 
                    // $("#ocmCtyExpireType option[value='2']").attr('selected', 'selected');
                    $('#oetCtyExpirePeriod').val('');
            }
        });

        // ล้างค่า ExpiredType
        $('#ocmCtyExpireType').change(function(){
            var nStatusExpired = $(this).val();
            switch (nStatusExpired){
                case '1' :
                    $('#oetCtyExpirePeriod').val('');
                break;
                case '2' :
                    $('#oetCtyExpirePeriod').val('');
                break;
                case '3' :
                    $('#oetCtyExpirePeriod').val('');
                break;
                case '4' :
                    $('#oetCtyExpirePeriod').val('');
                break;
                default : 
                    $('#oetCtyExpirePeriod').val('');
            }
        });

    // **************************************************************************

    $('#ocmCtyStaType').change(function(){
            var nStatusPay = $(this).val();
                $("#ohdCtyStaType").val(nStatusPay);
    });

    $('#ocmCtyStatusPay').change(function(){
        var nStatusPay = $(this).val();
        if(nStatusPay == '2'){
            $("#ocmCtyStaType").val(1);
            $("#ohdCtyStaType").val(1);
            $("#ocmCtyStaType").val(1).change();
            $("#ocmCtyStaType").attr("disabled",true);
            $("#ocmCtyStaType").selectpicker('refresh')
        }else{
            $("#ocmCtyStaType").val(2);
            $("#ohdCtyStaType").val(2);
            $("#ocmCtyStaType").val(2).change();
            $("#ocmCtyStaType").attr("disabled",false);
            $("#ocmCtyStaType").selectpicker('refresh')
        }
    });

    function JStCtyDisbledChkboxTopupAuto(){
        var tTopupAuto = $("#oetCtyTopupAuto").val()
        if(tTopupAuto == '' || tTopupAuto <= 0.00){
            // console.log('0',tTopupAuto);
            $("#ocbCtyTAStaReset").attr("disabled",true);
            $("#ocbCtyTAAlwReturn").attr("disabled",true);
            $("#ocbCtyTAStaReset").attr("checked", false);
            $("#ocbCtyTAAlwReturn").attr("checked", false);
        }else{
            // console.log('1',tTopupAuto);
            $("#ocbCtyTAStaReset").attr("disabled",false);
            $("#ocbCtyTAAlwReturn").attr("disabled",false);
        }
        
    }

        

</script>