<?php
    // echo '<pre>';
    // print_r($aDataSplCt);
    // exit;
    if(isset($nStaAddOrEdit) && $nStaAddOrEdit == 1){

        $tSplCode               = $aSplBranchData['raItems']['FTSplCode'];
        $tSplName               = $aSplBranchData['raItems']['FTSplName'];
        $tBchCode               = $aSplBranchData['raItems']['FTBchCode'];
        $tBchName               = $aSplBranchData['raItems']['FTBchName'];
        $cSbhLeadTime           = $aSplBranchData['raItems']['FCSbhLeadTime'];
        $tSbhOrdDay             = $aSplBranchData['raItems']['FTSbhOrdDay'];
        $tSbhStaAlwOrdSun       = $aSplBranchData['raItems']['FTSbhStaAlwOrdSun'];
        $tSbhStaAlwOrdMon       = $aSplBranchData['raItems']['FTSbhStaAlwOrdMon'];
        $tSbhStaAlwOrdTue       = $aSplBranchData['raItems']['FTSbhStaAlwOrdTue'];
        $tSbhStaAlwOrdWed       = $aSplBranchData['raItems']['FTSbhStaAlwOrdWed'];
        $tSbhStaAlwOrdThu       = $aSplBranchData['raItems']['FTSbhStaAlwOrdThu'];
        $tSbhStaAlwOrdFri       = $aSplBranchData['raItems']['FTSbhStaAlwOrdFri'];
        $tSbhStaAlwOrdSat       = $aSplBranchData['raItems']['FTSbhStaAlwOrdSat'];
        $tSbhStaDefault         = $aSplBranchData['raItems']['FTSbhStaDefault'];

   
        $tRoute                 = 'supplierEventEditBranch';
        $tBtnDisabled           = 'disabled';
    }else{

        $tSplCode               = '';
        $tSplName               = '';
        $tBchCode               = '';
        $tBchName               = '';
        $cSbhLeadTime           = 1;
        $tSbhOrdDay             = '';
        $tSbhStaAlwOrdSun       = '2';
        $tSbhStaAlwOrdMon       = '2';
        $tSbhStaAlwOrdTue       = '2';
        $tSbhStaAlwOrdWed       = '2';
        $tSbhStaAlwOrdThu       = '2';
        $tSbhStaAlwOrdFri       = '2';
        $tSbhStaAlwOrdSat       = '2';
        $tSbhStaDefault         = '2';

        $tRoute                 = 'supplierEventAddBranch';
        $tBtnDisabled           = '';
    }

?>
<style>
    
</style>
<form class="contact100-form validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data" id="ofmSplBranch">
<input type="text" class="form-control xCNHide" id="oetSBHtRoute" name="oetSBHtRoute" value="<?=$tRoute;?>">
    <div class="col-lg-12">
  
        <div class="row">
            <div class="col-lg-10">
                <div class="row">
                    <div class="col-lg-6  col-md-6 col-xs-12">

                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('supplier/supplier/supplier','tSPLBranchSplName')?></label>
                            <div class="input-group">
                                <input type="text" class="form-control xCNHide" id="oetSBHSplCode" name="oetSBHSplCode" value="<?=$tSplCode;?>">
                                <input type="text" class="form-control xWPointerEventNone" id="oetSBHSplName" name="oetSBHSplName" placeholder="<?php echo language('supplier/supplier/supplier','tSPLBranchSplName')?>" value="<?=$tSplName;?>" readonly>
                                <span class="input-group-btn">
                                    <button id="obtSBHBrowseSPL" type="button" class="btn xCNBtnBrowseAddOn" <?=$tBtnDisabled?>>
                                        <img src="<?= base_url().'/application/modules/common/assets/images/icons/find-24.png'?>">
                                    </button>
                                </span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('supplier/supplier/supplier','tSPLBranchBchName')?></label>
                            <div class="input-group">
                                <input type="text" class="form-control xCNHide" id="oetSBHBchCode" name="oetSBHBchCode" value="<?=$tBchCode;?>">
                                <input type="text" class="form-control xWPointerEventNone" id="oetSBHBchName" name="oetSBHBchName" placeholder="<?php echo language('supplier/supplier/supplier','tSPLBranchBchName')?>" value="<?=$tBchName;?>" readonly>
                                <span class="input-group-btn">
                                    <button id="obtSBHBrowseBCH" type="button" class="btn xCNBtnBrowseAddOn" <?=$tBtnDisabled?>>
                                        <img src="<?= base_url().'/application/modules/common/assets/images/icons/find-24.png'?>">
                                    </button>
                                </span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('supplier/supplier/supplier','tSbhLeadTime')?></label>
                             <input type="text" class="form-control text-right xCNInputNumericWithoutDecimal" maxlength="3" id="oetSBHSbhLeadTime" name="oetSBHSbhLeadTime" placeholder="0.00" value="<?=str_replace(",","",number_format($cSbhLeadTime,FCNxHGetOptionDecimalShow()));?>" max="100" min="1" data-validate="ส่วนลดท้ายบิล Online">
                        </div>

                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('supplier/supplier/supplier','tSbhOrdDay')?> <?php echo language('supplier/supplier/supplier','tSbhOrdDayEx')?></label>
                             <input type="text" class="form-control"  id="oetSBHSSbhOrdDay" name="oetSBHSSbhOrdDay" placeholder="<?php echo language('supplier/supplier/supplier','tSbhOrdDay')?> <?php echo language('supplier/supplier/supplier','tSbhOrdDayEx')?>" value="<?=$tSbhOrdDay;?>" >
                        </div>

                        <div class="form-group xCNHide">
                            <label class="xCNLabelFrm">&nbsp;</label>
                                <label class="fancy-checkbox">
                                    <input type="checkbox" id="ocbSbhStaDefault" name="ocbSbhStaDefault"   value="1" <?php if($tSbhStaDefault=='1'){ echo 'checked'; } ?>>
                                    <span>&nbsp;<?php echo language('supplier/supplier/supplier','tSbhStaDefault')?></span>
                                </label>
                            </div>

                    </div>

                    <div class="col-lg-6  col-md-6 col-xs-12" style="padding-left: 100px;">

                            <div class="form-group">
                                <label class="xCNLabelFrm">&nbsp;</label>
                                <label class="fancy-checkbox">
                                    <input class="xSbnStaAlwOrdInt" type="checkbox" id="ocbSbhStaAlwOrdSun" name="ocbSbhStaAlwOrdSun"  value="1" <?php if($tSbhStaAlwOrdSun=='1'){ echo 'checked'; } ?>>
                                    <span class="xSbnStaAlwOrdSpn">&nbsp;<?php echo language('supplier/supplier/supplier','tSbhStaAlwOrdSun')?></span>
                                </label>
                                
                                <label class="fancy-checkbox">
                                    <input class="xSbnStaAlwOrdInt" type="checkbox" id="ocbSbhStaAlwOrdMon" name="ocbSbhStaAlwOrdMon"  value="1" <?php if($tSbhStaAlwOrdMon=='1'){ echo 'checked'; } ?> >
                                    <span class="xSbnStaAlwOrdSpn">&nbsp;<?php echo language('supplier/supplier/supplier','tSbhStaAlwOrdMon')?></span>
                                </label>
                                
                                <label class="fancy-checkbox">
                                    <input class="xSbnStaAlwOrdInt" type="checkbox" id="ocbSbhStaAlwOrdTue" name="ocbSbhStaAlwOrdTue"  value="1" <?php if($tSbhStaAlwOrdTue=='1'){ echo 'checked'; } ?> >
                                    <span class="xSbnStaAlwOrdSpn">&nbsp;<?php echo language('supplier/supplier/supplier','tSbhStaAlwOrdTue')?></span>
                                </label>
                                
                                <label class="fancy-checkbox">
                                    <input class="xSbnStaAlwOrdInt" type="checkbox" id="ocbSbhStaAlwOrdWed" name="ocbSbhStaAlwOrdWed"  value="1" <?php if($tSbhStaAlwOrdWed=='1'){ echo 'checked'; } ?> >
                                    <span class="xSbnStaAlwOrdSpn">&nbsp;<?php echo language('supplier/supplier/supplier','tSbhStaAlwOrdWed')?></span>
                                </label>
                                
                                <label class="fancy-checkbox">
                                    <input class="xSbnStaAlwOrdInt" type="checkbox" id="ocbSbhStaAlwOrdThu" name="ocbSbhStaAlwOrdThu"   value="1" <?php if($tSbhStaAlwOrdThu=='1'){ echo 'checked'; } ?>>
                                    <span class="xSbnStaAlwOrdSpn">&nbsp;<?php echo language('supplier/supplier/supplier','tSbhStaAlwOrdThu')?></span>
                                </label>
                                
                                <label class="fancy-checkbox">
                                    <input class="xSbnStaAlwOrdInt" type="checkbox" id="ocbSbhStaAlwOrdFri" name="ocbSbhStaAlwOrdFri"   value="1" <?php if($tSbhStaAlwOrdFri=='1'){ echo 'checked'; } ?>>
                                    <span class="xSbnStaAlwOrdSpn">&nbsp;<?php echo language('supplier/supplier/supplier','tSbhStaAlwOrdFri')?></span>
                                </label>
                                
                                <label class="fancy-checkbox">
                                    <input class="xSbnStaAlwOrdInt" type="checkbox" id="ocbSbhStaAlwOrdSat" name="ocbSbhStaAlwOrdSat"   value="1" <?php if($tSbhStaAlwOrdSat=='1'){ echo 'checked'; } ?>>
                                    <span class="xSbnStaAlwOrdSpn">&nbsp;<?php echo language('supplier/supplier/supplier','tSbhStaAlwOrdSat')?></span>
                                </label>
                            </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
            

<script type="text/javascript">

    var nLangEdits      = <?php echo $this->session->userdata("tLangEdit");?>;
    // var nStaAddOrEdit   = <?php echo $nStaAddOrEdit;?>;
    $(document).ready(function(){
        var tSPLBranchSplCode = $('#oetSPLBranchSplCode').val();
        var tSPLBranchSplName = $('#oetSPLBranchSplName').val();
        if(tSPLBranchSplCode!=''){
            $('#oetSBHSplCode').val(tSPLBranchSplCode);
            $('#oetSBHSplName').val(tSPLBranchSplName);
            $('#obtSBHBrowseSPL').prop('disabled',true);
        }
        var tSPLBranchBchCode = $('#oetSPLBranchBchCode').val();
        var tSPLBranchBchName = $('#oetSPLBranchBchName').val();
        if(tSPLBranchBchCode!=''){
            $('#oetSBHBchCode').val(tSPLBranchBchCode);
            $('#oetSBHBchName').val(tSPLBranchBchName);
            $('#obtSBHBrowseBCH').prop('disabled',true);
        }


        $('#oetSBHSSbhOrdDay').on('change',function(){

            if($('#oetSBHSSbhOrdDay').val()!=''){
                $('.xSbnStaAlwOrdInt').prop('disabled',true);
                $('.xSbnStaAlwOrdSpn').addClass('xCNDisabled');
            }else{
                $('.xSbnStaAlwOrdInt').prop('disabled',false);
                $('.xSbnStaAlwOrdSpn').removeClass('xCNDisabled');
            }
            $('.xSbnStaAlwOrdInt').prop('checked',false);

        });

         $('.xSbnStaAlwOrdInt').on('change',function(){

            if($('.xSbnStaAlwOrdInt:checked').length>0){
                $('#oetSBHSSbhOrdDay').prop('disabled',true);
            }else{
                $('#oetSBHSSbhOrdDay').prop('disabled',false);
            }
            $('#oetSBHSSbhOrdDay').val();
        });

        if($('#oetSBHSSbhOrdDay').val()!=''){
                $('.xSbnStaAlwOrdInt').prop('disabled',true);
                $('.xSbnStaAlwOrdSpn').addClass('xCNDisabled');
        }
        if($('.xSbnStaAlwOrdInt:checked').length>0){
            $('#oetSBHSSbhOrdDay').prop('disabled',true);
        }

    });




    // Event Browse Supplier
    $('#obtSBHBrowseSPL').unbind().click(function(){
    // var nStaSession = JCNxFuncChkSessionExpired();
    var nStaSession = 1;
    if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
        JSxCheckPinMenuClose();
        window.oSBHBrowseSplOption   = undefined;
        oSBHBrowseSplOption          = oSBHSplOption({
            'tParamsAgnCode'    : '<?=$this->session->userdata("tSesUsrAgnCode")?>',
            'tReturnInputCode'  : 'oetSBHSplCode',
            'tReturnInputName'  : 'oetSBHSplName',
            'tNextFuncName'     : '',
            'aArgReturn'        : ['FNSplCrTerm', 'FCSplCrLimit', 'FTSplStaVATInOrEx', 'FTSplTspPaid', 'FTSplCode', 'FTSplName', 'FTVatCode', 'FCVatRate']
        });
        JCNxBrowseData('oSBHBrowseSplOption');
    }else{
        JCNxShowMsgSessionExpired();
    }
    });


        // ตัวแปร Option Browse Modal ตัวแทนจำหน่าย
        var oSBHSplOption      = function(poDataFnc){
        var tInputReturnCode    = poDataFnc.tReturnInputCode;
        var tInputReturnName    = poDataFnc.tReturnInputName;
        var tNextFuncName       = poDataFnc.tNextFuncName;
        var aArgReturn          = poDataFnc.aArgReturn;
        var tParamsAgnCode      = poDataFnc.tParamsAgnCode;
        
        if( tParamsAgnCode != "" ){
            tWhereAgency = " AND ( TCNMSpl.FTAgnCode = '"+tParamsAgnCode+"' OR ISNULL(TCNMSpl.FTAgnCode,'') = '' ) ";
        }else{
            tWhereAgency = "";
        }

        var oOptionReturn       = {
            Title: ['supplier/supplier/supplier', 'tSPLTitle'],
            Table: {Master:'TCNMSpl', PK:'FTSplCode'},
            Join: {
                Table: ['TCNMSpl_L', 'TCNMSplCredit', 'VCN_VatActive'],
                On: [
                    'TCNMSpl_L.FTSplCode = TCNMSpl.FTSplCode AND TCNMSpl_L.FNLngID = '+nLangEdits,
                    'TCNMSpl_L.FTSplCode = TCNMSplCredit.FTSplCode',
                    'TCNMSpl.FTVatCode = VCN_VatActive.FTVatCode'
                ]
            },
            Where:{
                Condition : ["AND TCNMSpl.FTSplStaActive = '1' " + tWhereAgency]
            },
            GrideView:{
                ColumnPathLang: 'supplier/supplier/supplier',
                ColumnKeyLang: ['tSPLTBCode', 'tSPLTBName'],
                ColumnsSize: ['15%', '75%'],
                WidthModal: 50,
                DataColumns: ['TCNMSpl.FTSplCode', 'TCNMSpl_L.FTSplName', 'TCNMSplCredit.FNSplCrTerm', 'TCNMSplCredit.FCSplCrLimit', 'TCNMSpl.FTSplStaVATInOrEx', 'TCNMSplCredit.FTSplTspPaid','VCN_VatActive.FTVatCode','VCN_VatActive.FCVatRate'],
                DataColumnsFormat: ['',''],
                DisabledColumns: [2, 3, 4, 5 , 6 , 7],
                Perpage: 5,
                OrderBy: ['TCNMSpl_L.FTSplName ASC']
            },
            CallBack:{
                ReturnType: 'S',
                Value   : [tInputReturnCode,"TCNMSpl.FTSplCode"],
                Text    : [tInputReturnName,"TCNMSpl_L.FTSplName"]
            },
            RouteAddNew: 'supplier',
            BrowseLev: 1
        };
        return oOptionReturn;
    }



    $('#obtSBHBrowseBCH').click(function(){ 
    // JCNxBrowseData('oBrowse_BCH'); 

    var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxCheckPinMenuClose();
            window.oSBHBrowseBranchOption  = undefined;
            oSBHBrowseBranchOption         = oSBHBranchOption({
                'tReturnInputCode'  : 'oetSBHBchCode',
                'tReturnInputName'  : 'oetSBHBchName',
                'tNextFuncName'     : '',
                'aArgReturn'        : ['FTBchCode','FTBchName','FTWahCode','FTWahName'],
            });
            JCNxBrowseData('oSBHBrowseBranchOption');
        }else{
            JCNxShowMsgSessionExpired();
        }

    });


      // ========================================== Brows Option Conditon ===========================================
    // ตัวแปร Option Browse Modal สาขา
    var oSBHBranchOption = function(poDataFnc){
        var tInputReturnCode    = poDataFnc.tReturnInputCode;
        var tInputReturnName    = poDataFnc.tReturnInputName;
        var tNextFuncName       = poDataFnc.tNextFuncName;
        var aArgReturn          = poDataFnc.aArgReturn;

        tUsrLevel = "<?=$this->session->userdata('tSesUsrLevel')?>";
        tBchMulti = "<?=$this->session->userdata("tSesUsrBchCodeMulti"); ?>";
        tSQLWhere = "";
        if(tUsrLevel != "HQ"){
            tSQLWhere = " AND TCNMBranch.FTBchCode IN ("+tBchMulti+") ";
        }
        
        // ตัวแปร ออฟชั่นในการ Return
        var oOptionReturn       = {
            Title: ['authen/user/user', 'tBrowseBCHTitle'],
            Table: {
                Master  : 'TCNMBranch',
                PK      : 'FTBchCode'
            },
            Join: {
                Table   : ['TCNMBranch_L','TCNMWaHouse_L'],
                On      : ['TCNMBranch_L.FTBchCode = TCNMBranch.FTBchCode AND TCNMBranch_L.FNLngID = ' + nLangEdits,
                            'TCNMBranch.FTWahCode = TCNMWaHouse_L.FTWahCode AND TCNMBranch.FTBchCode = TCNMWaHouse_L.FTBchCode AND TCNMWaHouse_L.FNLngID ='+nLangEdits,]
            },
            Where : {
                Condition : [tSQLWhere]
            },
            GrideView: {
                ColumnPathLang      : 'authen/user/user',
                ColumnKeyLang       : ['tBrowseBCHCode', 'tBrowseBCHName'],
                ColumnsSize         : ['10%', '75%'],
                DataColumns         : ['TCNMBranch.FTBchCode', 'TCNMBranch_L.FTBchName','TCNMWaHouse_L.FTWahCode','TCNMWaHouse_L.FTWahName'],
                DataColumnsFormat   : ['', ''],
                DisabledColumns   : [2,3],
                WidthModal          : 50,
                Perpage             : 10,
                OrderBy             : ['TCNMBranch.FTBchCode'],
                SourceOrder         : "ASC"
            },
            CallBack: {
                ReturnType  : 'S',
                Value       : [tInputReturnCode, "TCNMBranch.FTBchCode"],
                Text        : [tInputReturnName, "TCNMBranch_L.FTBchName"]
            },
            NextFunc: {
                FuncName    : tNextFuncName,
                ArgReturn   : aArgReturn
            },
            RouteAddNew: 'branch',
            BrowseLev: 1
        };
        return oOptionReturn;
    }


        
</script>
