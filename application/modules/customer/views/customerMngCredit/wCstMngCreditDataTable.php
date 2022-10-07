<style type="text/css">
    .xWImgCustomer{width: 50px;}
</style>

<div class="row">
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
        <div class="table-responsive">
            <table class="table table-striped" id="otbMCRDataCreditList">
                <thead>
                    <tr class="xCNCenter">
                        <?php if($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaDelete'] == 1) : ?>
                            <th nowrap class="xCNTextBold text-center" style="width:5%;">
                                <label class="fancy-checkbox">
                                    <input type="checkbox" class="ocmCENCheckDeleteAll" id="ocmCENCheckDeleteAll" >
                                    <span class="ospListItem">&nbsp;</span>
                                </label>
                            </th>
                        <?php endif; ?>
                        <th class="xCNTextBold text-center" style="width:10%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBCstCode')?></th>
                        <th class="xCNTextBold text-center" style="width:20%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBCstName')?></th>
                        <th class="xCNTextBold text-center" style="width:10%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBCstCrTerm')?></th>
                        <th class="xCNTextBold text-center" style="width:10%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBCstCrBuffer1').' % '.language('customer/customermngcredit/customermngcredit','tMCRTBCstCrBuffer2')?></th>
                        <th class="xCNTextBold text-center" style="width:10%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBCstAmtBuffer')?></th>
                        <th class="xCNTextBold text-center" style="width:10%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBCstCrBalExt')?></th>
                        <th class="xCNTextBold text-center" style="width:10%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBCstCrLeft')?></th>
                        <th class="xCNTextBold text-center" style="width:10%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBCstCrBalLeft')?></th>
                        <th class="xCNTextBold text-center" style="width:5%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBCstStaApv')?></th>
                        <th class="xCNTextBold text-center" style="width:5%;"><?= language('customer/customermngcredit/customermngcredit','tMCRTBEdit')?></th>
                    </tr>
                </thead>
                <tbody id="odvMCRList">
                    <?php 
                        // echo "<pre>";
                        // print_r($aDataList['raItems']);
                        // echo "</pre>";
                    ?>
                    <?php if($aDataList['rtCode'] == 1 ):?>
                        <?php foreach($aDataList['raItems'] as $nKey => $aValue): ?>
                                <?php 
                                    $tMCRCalBufferVal   = (floatval($aValue['FCCstCrLimit']) * floatval($aValue['FCCstCrBuffer']) ) / 100;
                                ?>
                                <tr class="text-center xCNTextDetail2 otrCstMngCredit" id="otrCstMngCredit<?=$nKey?>" 
                                    data-code="<?=$aValue['FTCstCode']?>"
                                    data-name="<?=$aValue['FTCstName']?>"
                                >
                                    <?php if($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaDelete'] == 1) : ?>
                                        <td class="text-center">
                                            <label class="fancy-checkbox ">
                                                <input id="ocbListItem<?=$nKey?>" type="checkbox" class="ocbListItem" name="ocbListItem[]">
                                                <span class="">&nbsp;</span>
                                            </label>
                                        </td>
                                    <?php endif;?>
                                    <td class="text-left otdCstCode"><?=$aValue['FTCstCode'];?></td>
                                    <td class="text-left"><?=(!empty($aValue['FTCstName']))? $aValue['FTCstName'] : language('customer/customermngcredit/customermngcredit','tMCRNotFoundCstName');?></td>
                                    <td class="text-right">
                                        <input 
                                            type="text" 
                                            class="form-control xCNInputNumericWithDecimal xCNInputMaskCurrency text-right xCNCalBuff" 
                                            maxlength="10"
                                            id="oetCstCrLimit<?=$aValue['FTCstCode'];?>"
                                            name="oetCstCrLimit<?=$aValue['FTCstCode'];?>"
                                            value="<?=number_format($aValue['FCCstCrLimit'],2);?>"
                                        >
                                    </td>
                                    <td class="text-right">
                                        <input
                                            type="text"
                                            class="form-control xCNInputNumericWithDecimal text-right xCNCalBuff"
                                            maxlength="10"
                                            id="oetCstCrBuffer<?=$aValue['FTCstCode'];?>"
                                            name="oetCstCrBuffer<?=$aValue['FTCstCode'];?>"
                                            value="<?=number_format($aValue['FCCstCrBuffer'],0);?>"
                                        >
                                    </td>
                                    <td class="text-right">
                                        <input
                                            type="text"
                                            class="form-control text-right" 
                                            maxlength="10"
                                            id="oetCstCalBufferVal<?=$aValue['FTCstCode'];?>"
                                            name="oetCstCalBufferVal<?=$aValue['FTCstCode'];?>"
                                            value="<?=number_format($aValue['FCCstCrAmtBuffer'],2);?>"
                                            readonly
                                        >
                                    </td>
                                    <td class="text-right">
                                        <input
                                            type="text"
                                            class="form-control xCNInputNumericWithDecimal xCNInputMaskCurrency text-right"
                                            maxlength="10"
                                            id="oetCstCrBalExt<?=$aValue['FTCstCode'];?>"
                                            name="oetCstCrBalExt<?=$aValue['FTCstCode'];?>"
                                            value="<?=number_format($aValue['FCCstCrBalExt'],2);?>"
                                        >
                                    </td>
                                    <td class="text-right">
                                        <input
                                            type="text"
                                            class="form-control xCNInputNumericWithDecimal xCNInputMaskCurrency text-right"
                                            maxlength="10"
                                            id="oetCstCrLeft<?=$aValue['FTCstCode'];?>"
                                            name="oetCstCrLeft<?=$aValue['FTCstCode'];?>"
                                            value="<?=number_format($aValue['FCCstCrLeft'],2);?>"
                                            readonly
                                        >
                                    </td>
                                    <td class="text-right">
                                        <input
                                            type="text"
                                            class="form-control xCNInputNumericWithDecimal xCNInputMaskCurrency text-right"
                                            maxlength="10"
                                            id="oetCstCrLeftBal<?=$aValue['FTCstCode'];?>"
                                            name="oetCstCrLeftBal<?=$aValue['FTCstCode'];?>"
                                            value="<?=number_format($aValue['FCCstCrBalLeft'],2);?>"
                                            readonly
                                        >
                                    </td>
                                    <td class="text-center">
                                        <label class="fancy-checkbox">
                                            <?php 
                                                if($aValue['FTCstStaApv'] == 1){ 
                                                    // อนุญาติ
                                                    $tStaApvChk = "checked";
                                                }else{
                                                    // ไม่อนุญาติ
                                                    $tStaApvChk = "";
                                                }
                                            ?>
                                            <input 
                                                type="checkbox" 
                                                class="ocmCstCrStaApv<?=$aValue['FTCstCode'];?>"
                                                id="ocmCstCrStaApv<?=$aValue['FTCstCode'];?>"
                                                name="ocmCstCrStaApv<?=$aValue['FTCstCode'];?>"
                                                <?=@$tStaApvChk;?>
                                            >
                                            <span class="ospListItem">&nbsp;</span>
                                        </label>
                                    </td>
                                    <td>
                                        <img class="xCNIconTable xCNIconSave" onclick="JSxMCREventSaveDataCredit(this)">
                                    </td>
                                </tr>
                        <?php endforeach; ?>
                    <?php else:?>
                        <tr><td class='text-center xCNTextDetail2' colspan='10'><?= language('common/main/main','tCMNNotFoundData')?> </td></tr>
                    <?php endif;?>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <?php $nShowRecord  = get_cookie('nShowRecordInPageList'); ?>
        <p><?= language('customer/customermngcredit/customermngcredit','tMCRShowTheLastItems')?> <?=$nShowRecord?> <?= language('customer/customermngcredit/customermngcredit','tMCRShowList')?></p>
    </div>
</div>
<script src="<?php echo base_url('application/modules/common/assets/js/jquery.mask.js')?>"></script>
<script src="<?php echo base_url('application/modules/common/assets/src/jFormValidate.js')?>"></script>
<script type="text/javascript">
    var nDecimalShow    = parseInt('<?=@$nOptDecimalShow;?>');
    $(document).ready(function (){
        
        // Event Calcurate Buffer Customer Credit
        $('#otbMCRDataCreditList .xCNCalBuff').change(function(){
            JSxMCREventCalcBuffer(this);
        });

        // Event Clikc List Check Box Cut Of Customer Credit
        $('.ocbListItem').click(function(){
            var nCode   = $(this).parents('.otrCstMngCredit').data('code'); // Code 
            var tName   = $(this).parents('.otrCstMngCredit').data('name'); // Name
            $(this).prop('checked', true);
            var LocalItemData   = localStorage.getItem("LocalItemData");
            var obj = [];
            if(LocalItemData){
                obj = JSON.parse(LocalItemData);
            }
            var aArrayConvert   = [JSON.parse(localStorage.getItem("LocalItemData"))];
            if(aArrayConvert == '' || aArrayConvert == null){
                obj.push({"nCode": nCode, "tName": tName });
                localStorage.setItem("LocalItemData",JSON.stringify(obj));
                JSxPaseCodeCutOffInInputHidden();
            }else{
                var aReturnRepeat   = findObjectByKey(aArrayConvert[0],'nCode',nCode);
                if(aReturnRepeat == 'None' ){
                    //ยังไม่ถูกเลือก
                    obj.push({"nCode": nCode, "tName": tName });
                    localStorage.setItem("LocalItemData",JSON.stringify(obj));
                    JSxPaseCodeCutOffInInputHidden();
                }else if(aReturnRepeat == 'Dupilcate'){	
                    //เคยเลือกไว้แล้ว
                    localStorage.removeItem("LocalItemData");
                    $(this).prop('checked', false);
                    var nLength = aArrayConvert[0].length;
                    for($i=0; $i<nLength; $i++){
                        if(aArrayConvert[0][$i].nCode == nCode){
                            delete aArrayConvert[0][$i];
                        }
                    }
                    var aNewarraydata = [];
                    for($i=0; $i<nLength; $i++){
                        if(aArrayConvert[0][$i] != undefined){
                            aNewarraydata.push(aArrayConvert[0][$i]);
                        }
                    }
                    localStorage.setItem("LocalItemData",JSON.stringify(aNewarraydata));
                    JSxPaseCodeCutOffInInputHidden();
                }
            }
            JSxShowBtnCutoffCstCr();
        });

    });
    
    // Function : Event Calurate Buffer Seq
    // Date Manage : 15/07/2022 Wasin
    function JSxMCREventCalcBuffer(evn){
        let tCstCode            = $(evn).parents('.otrCstMngCredit').data('code');
        let tCstCrLimit         = parseFloat($('#oetCstCrLimit'+tCstCode).val().replace(/,/g, ''));
        let tCstCrBuffer        = parseFloat($('#oetCstCrBuffer'+tCstCode).val().replace(/,/g, ''));
        let tCstCalBufferVal    = (tCstCrLimit * tCstCrBuffer) / 100 ;
        $('#oetCstCalBufferVal'+tCstCode).val(tCstCalBufferVal);
        let tObjBufferName  = 'oetCstCalBufferVal'+tCstCode;
        JCNdValidatelength8Decimal(tObjBufferName,'FC',10,2);
    }

    // Function : Save Data Customer Credit
    // Date Manage : 15/07/2022 Wasin
    function JSxMCREventSaveDataCredit(evn){
        let tCstCode        = $(evn).parents('.otrCstMngCredit').data('code');
        let tCstCrLimit     = parseFloat($('#oetCstCrLimit'+tCstCode).val().replace(/,/g, ''));
        let tCstCrBuffer    = parseFloat($('#oetCstCrBuffer'+tCstCode).val().replace(/,/g, ''));
        let tCstCrBalExt    = parseFloat($('#oetCstCrBalExt'+tCstCode).val().replace(/,/g, ''));
        let tCstCrStaApvChk = $('#ocmCstCrStaApv'+tCstCode).is(":checked")? 1 : 2;
        JCNxOpenLoading()
        $.ajax({
            type : "POST",
            url  : "cstMngCreditEventUpdInline",
            data : {
                'ptCstCode'         : tCstCode,
                'ptCstCrLimit'      : tCstCrLimit,
                'ptCstCrBuffer'     : tCstCrBuffer,
                'ptCstCrBalExt'     : tCstCrBalExt,
                'ptCstCrStaApvChk'  : tCstCrStaApvChk
            },
            async   : false,
            cache   : false,
            timeout : 0,
            success: function(tResult){
                JSvMCRCallPageDataTable();
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    }




    // Function : Event Show Button Cut Off Customer Credit
    // Date Manage : 15/07/2022 Wasin
    function JSxShowBtnCutoffCstCr(){
        let aArrayConvert   = [JSON.parse(localStorage.getItem("LocalItemData"))];
        if(aArrayConvert[0] == null || aArrayConvert[0] == '') {
            $('#obtMCRBtnCutOffCstCr').hide();
        }else{
            let nNumOfArr   = aArrayConvert[0].length;
            if (nNumOfArr > 0) {
                $('#obtMCRBtnCutOffCstCr').fadeIn(300);
            } else {
                $('#obtMCRBtnCutOffCstCr').fadeOut(300);
            }
        }
    }

    // Function : Chack Dupilcate Data
    // Date Manage : 15/07/2022 Wasin
    function findObjectByKey(array, key, value) {
        for (var i = 0; i < array.length; i++) {
            if (array[i][key] === value) {
                return 'Dupilcate';
            }
        }
        return 'None';
    }

    // Function : Pase Code In Input Hidden Cut off
    // Date Manage : 15/07/2022 Wasin
    function JSxPaseCodeCutOffInInputHidden(){
        var aArrayConvert   = [JSON.parse(localStorage.getItem("LocalItemData"))];
        if (aArrayConvert[0] == null || aArrayConvert[0] == '') {} else {
            var tTextCode   = '';
            for ($i = 0; $i < aArrayConvert[0].length; $i++) {
                tTextCode += aArrayConvert[0][$i].nCode;
                tTextCode += ' , ';
            }
            $('#oetMCRDataCutOffCsrCr').val(tTextCode);
        }
    }

    // Function : Event Send Cut Off Customer Credit
    // Date Manage : 15/07/2022 Wasin
    function JSvMCREventCutOffCredit(){
        let nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            JCNxOpenLoading();
            var aData               = $('#oetMCRDataCutOffCsrCr').val();
            var aTexts              = aData.substring(0, aData.length - 2);
            var aDataSplit          = aTexts.split(" , ");
            var aDataSplitlength    = aDataSplit.length;
            var aNewIdDelete        = [];
            for ($i = 0; $i < aDataSplitlength; $i++) {
                aNewIdDelete.push(aDataSplit[$i]);
            }
            if(aDataSplitlength > 0) {
                localStorage.StaDeleteArray = '1';
                $.ajax({
                    type: "POST",
                    url: "cstMngCreditEventCutOffCstCr",
                    data: { 'tIDCode': aNewIdDelete },
                    success: function(tResult) {
                        let aDataReturn = JSON.parse(tResult);
                        if(aDataReturn['nStaEvent'] == '1'){
                            FSvCMNSetMsgSucessDialog('ปรับวงเงินเครดิตคงเหลือเรียบร้อยแล้ว');
                        }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        JCNxResponseError(jqXHR, textStatus, errorThrown);
                    }
                });
            } else {
                localStorage.StaDeleteArray = '0';
                return false;
            }
        }else{
            JCNxShowMsgSessionExpired();
        }
    }





</script>