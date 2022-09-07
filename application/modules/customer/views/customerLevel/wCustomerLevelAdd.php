<?php
if($aResult['rtCode'] == "1"){
    $tCstLevCode       = $aResult['raItems']['rtCstLevCode'];
    $tCstLevName       = $aResult['raItems']['rtCstLevName'];
    $tCstLevRmk        = $aResult['raItems']['rtCstLevRmk'];
    $tRoute         = "customerLevelEventEdit";
    $tCstLevAlwPnt     = $aResult['raItems']['rtCClvAlwPnt'];
    $tCstLevCalAmt     = $aResult['raItems']['rtCClvCalAmt'];
    $tCstLevCalPnt     = $aResult['raItems']['rtCClvCalPnt'];
    $tCstLevClvCode    = $aResult['raItems']['rtCClvCode'];
    $tCstLevPplName    = $aResult['raItems']['rtPplName'];
    $tCstLevAgnCode   = $aResult['raItems']['rtAgnCode'];
    $tCstLevAgnName   = $aResult['raItems']['rtAgnName'];
}else{
    $tCstLevCode       = "";
    $tCstLevName       = "";
    $tCstLevRmk        = "";
    $tRoute         = "customerLevelEventAdd";
    $tCstLevAlwPnt     = "2";
    $tCstLevCalAmt     = "";
    $tCstLevCalPnt     = "";
    $tCstLevClvCode    = "";
    $tCstLevClvCode    = "";
    $tCstLevPplName    = "" ;
    $tCstLevAgnCode   = $aResult['tSesAgnCode'];
    $tCstLevAgnName   = $aResult['tSesAgnName'];
}
?>
<form class="contact100-form validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data" autocorrect="off" autocapitalize="off" autocomplete="off" id="ofmAddCstLev">
    <button style="display:none" type="submit" id="obtSubmitCstLev" onclick="JSnAddEditCstLev('<?= $tRoute?>')"></button>
    <div class="panel-body" style="padding-top:20px !important;">
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                <label class="xCNLabelFrm"><span class="text-danger">*</span> <?php echo language('customer/customerLevel/customerLevel','tCstLevCode'); ?><?= language('customer/customerLevel/customerLevel','tCstLevTitle')?></label>
                <div id="odvCstLevAutoGenCode" class="form-group">
                <div class="validate-input">
                <label class="fancy-checkbox">
                    <input type="checkbox" id="ocbCustomerLevelAutoGenCode" name="ocbCustomerLevelAutoGenCode" checked="true" value="1">
                    <span> <?php echo language('common/main/main', 'tGenerateAuto'); ?></span>
                </label>
            </div>
        </div>
            <div id="odvCstLevCodeForm" class="form-group">
                <input type="hidden" id="ohdCheckDuplicateCstLevCode" name="ohdCheckDuplicateCstLevCode" value="1">  
                        <div class="validate-input">
                        <input 
                        type="text" 
                        class="form-control xCNGenarateCodeTextInputValidate" 
                        maxlength="5" 
                        id="oetCstLevCode" 
                        name="oetCstLevCode"
                        data-is-created="<?php echo $tCstLevCode;?>"
                        placeholder="<?php echo language('customer/customerLevel/customerLevel','tCstLevTBCode'); ?>"
                        value="<?= $tCstLevCode; ?>" 
                        data-validate-required = "<?= language('customer/customerLevel/customerLevel','tCstLevValidCode')?>"
                        data-validate-dublicateCode = "<?= language('customer/customerLevel/customerLevel','tCstLevValidCheckCode')?>"
                    >
                </div>
            </div>
        </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">

            <?php
                if ($tRoute ==  "pdtgroupEventAdd") {
                    $tCstLevAgnCode   = $tSesAgnCode;
                    $tCstLevAgnCode   = $tSesAgnName;
                    $tDisabled     = '';
                    $tNameElmIDAgn = 'oimBrowseAgn';
                } else {
                    $tCstLevAgnCode    = $tCstLevAgnCode;
                    $tCstLevAgnCode    = $tCstLevAgnCode;
                    $tDisabled      = '';
                    $tNameElmIDAgn  = 'oimBrowseAgn';
                }
                ?>


                <!-- เพิ่ม AD Browser -->
                <div class="form-group  <?php if (!FCNbGetIsAgnEnabled()) : echo 'xCNHide';
                                        endif; ?>">
                    <label class="xCNLabelFrm"><?php echo language('product/pdtgroup/pdtgroup', 'tPGPAgency') ?></label>
                    <div class="input-group"><input type="text" class="form-control xCNHide" id="oetCstLevAgnCode" name="oetCstLevAgnCode" maxlength="5" value="<?= @$tCstLevAgnCode; ?>">
                        <input type="text" class="form-control xWPointerEventNone" id="oetCstLevAgnName" name="oetCstLevAgnName" maxlength="100" placeholder="<?php echo language('interface/connectionsetting/connectionsetting', 'tTBAgency') ?>" value="<?= @$tCstLevAgnName; ?>" readonly>
                        <span class="input-group-btn">
                            <button id="<?= @$tNameElmIDAgn; ?>" type="button" class="btn xCNBtnBrowseAddOn <?= @$tDisabled ?>">
                                <img src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                            </button>
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="validate-input" data-validate="Please Insert Name">
                        <label class="xCNLabelFrm"><span class="text-danger">*</span> <?= language('customer/customerLevel/customerLevel','tCstLevName')?><?= language('customer/customerLevel/customerLevel','tCstLevCustomer')?></label>
                        <input type="text" class="input100" maxlength="100" id="oetCstLevName" name="oetCstLevName" value="<?= $tCstLevName ?>"
                        data-validate-required = "<?= language('customer/customerLevel/customerLevel','tCstLevvalidateName')?>">
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="xCNLabelFrm"><?php echo language('product/product/product','tCstLevRtePntQty');?></label>
                    <input type="text" class="form-control text-right xCNInputNumericWithDecimal" id="oetCstLevCalAmt" class="form-control" maxlength="100"  name="oetCstLevCalAmt" disabled value="<?php echo $tCstLevCalAmt;?>">
                </div>

                <div class="form-group">
                    <label class="xCNLabelFrm"><?php echo language('product/product/product','tCstLevRtePntAmt');?></label>
                    <input type="text" class="form-control text-right xCNInputNumericWithDecimal" id="tCstLevCalPnt" class="form-control" maxlength="100"  name="tCstLevCalPnt" disabled value="<?php echo $tCstLevCalPnt;?>">
                </div>

                <div class="form-group" >
                    <label class="xCNLabelFrm"><?php echo language('customer/customer/customer','tCSTPplRet');?></label>
                    <div class="input-group">
                        <input type="text" class="form-control xCNHide" id="oetCstPplRetCode" name="oetCstPplRetCode" value="<?php echo @$tCstLevClvCode;?>">
                        <input type="text" class="form-control xWPointerEventNone" id="oetCstPplRetName" name="oetCstPplRetName" placeholder="<?php echo language('customer/customer/customer','tCSTPplRet');?>" value="<?php echo @$tCstLevPplName;?>" readonly>
                       
                        <span class="input-group-btn">
                            <button id="oimCstBrowsePpl" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="validate-input">
                                <label class="xCNLabelFrm"><?= language('customer/customerLevel/customerLevel','tCstLevNote')?></label>
                                <textarea maxlength="100" rows="4" id="otaCstLevRemark" name="otaCstLevRemark"><?= $tCstLevRmk ?></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="fancy-checkbox">
                        <input type="checkbox" id="ocbCustomerLevelAppr" name="ocbCustomerLevelAppr"   <?php if ($tCstLevAlwPnt=="1") {  echo 'checked'; } ?> disabled>
                        <span> <?= language('customer/customerLevel/customerLevel','tCstLevAlw')?></span>
                
                    </label>
                </div>

            </div>
        </div>
    </div>
</form>
<script src="<?php echo base_url('application/modules/common/assets/js/jquery.mask.js');?>"></script>
<script src="<?php echo base_url('application/modules/common/assets/src/jFormValidate.js');?>"></script>
<?php include "script/jCustomerLevelAdd.php";?>
<script type="text/javascript">
    $('.xWTooltipsBT').tooltip({'placement': 'bottom'});
    $('[data-toggle="tooltip"]').tooltip({'placement': 'top'});

    $('#oimCstLevBrowseProvince').click(function(){
        JCNxBrowseData('oPvnOption');
    });

    if(JCNCstLevIsUpdatePage()){
        $("#obtGenCodeCstLev").attr("disabled", true);
    }

     //BrowseAgn 
     $('#oimBrowseAgn').click(function(e) {
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            JSxCheckPinMenuClose();
            window.oPdtBrowseAgencyOption = oBrowseAgn({
                'tReturnInputCode': 'oetCstLevAgnCode',
                'tReturnInputName': 'oetCstLevAgnName',
            });
            JCNxBrowseData('oPdtBrowseAgencyOption');
        } else {
            JCNxShowMsgSessionExpired();
        }
    });

    var nLangEdits = <?php echo $this->session->userdata("tLangEdit") ?>;

    //Option Agn
    var oBrowseAgn = function(poReturnInput) {
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
        // $('#oimBrowseAgn').attr("disabled", true);

    }


    $('#oimCstBrowsePpl').click(function(){
      // Create By Witsarut 04/10/2019
        JSxCheckPinMenuClose();
      // Create By Witsarut 04/10/2019
      oOptionReturnPpl = oCstBrowsePpl();
      JCNxBrowseData('oOptionReturnPpl');
    });
    var oCstBrowsePpl = function(){
    	var tCondition = '';
    	var tStaUsrLevel = '<?= $this->session->userdata("tSesUsrLevel"); ?>';
    	var tAgnCode  = '<?= $this->session->userdata("tSesUsrAgnCode") ?>';
        var nLangEdits = <?=$this->session->userdata("tLangEdit")?>;
    	var oCstBrowsePplReturn = {
    		Title : ['product/pdtpricelist/pdtpricelist', 'tPPLTitle'],
    		Table:{Master:'TCNMPdtPriList', PK:'FTPplCode'},
    		Join :{
    			Table: ['TCNMPdtPriList_L'],
    			On: ['TCNMPdtPriList_L.FTPplCode = TCNMPdtPriList.FTPplCode AND TCNMPdtPriList_L.FNLngID = '+nLangEdits]
    		},
    		Where :{
    			Condition : [tCondition],
    		},
    		GrideView:{
    			ColumnPathLang	: 'product/pdtpricelist/pdtpricelist',
    			ColumnKeyLang	: ['tPPLTBCode', 'tPPLTBName'],
    			ColumnsSize     : ['15%', '85%'],
    			WidthModal      : 50,
    			DataColumns		: ['TCNMPdtPriList.FTPplCode', 'TCNMPdtPriList_L.FTPplName'],
    			DataColumnsFormat : ['', ''],
    			Perpage			: 10,
    			OrderBy			: ['TCNMPdtPriList.FDCreateOn DESC'],
    		},
    		CallBack:{
    			ReturnType	: 'S',
    			Value		: ["oetCstPplRetCode", "TCNMPdtPriList.FTPplCode"],
    			Text		: ["oetCstPplRetName", "TCNMPdtPriList.FTPplName"]
    		},
    		RouteAddNew : 'pdtpricegroup'
    		//BrowseLev : nStaCstBrowseType
    	}
    	return oCstBrowsePplReturn;
    }
</script>
