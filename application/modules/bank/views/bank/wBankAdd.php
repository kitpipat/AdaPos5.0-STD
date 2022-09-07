<?php
    if(isset($nStaAddOrEdit) && $nStaAddOrEdit == 1){
        $tRoute     = "bankEventEdit"; 
        $tBnkCode   = $aBnkData['raItems']['rtBnkCode'];
        $tBnkName   = $aBnkData['raItems']['rtBnkName'];
        $tBnkRmk    = $aBnkData['raItems']['rtBnkRmk'];

        $tUsrAgnCode        = $aBnkData['raItems']['rtAgnCode'];
        $tUsrAgnName        = $aBnkData['raItems']['rtAgnName'];
    }else{
        $tRoute     = "bankEventAdd";
        $tBnkCode   = "";
        $tBnkName   = "";
        $tBnkRmk    = "";

        $tUsrAgnCode = $this->session->userdata("tSesUsrAgnCode");
        $tUsrAgnName = $this->session->userdata("tSesUsrAgnName");
    }
?>

<form class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data" id="ofmAddBnk">
    <button type="submit" id="obtSubmitBnk" onclick="JSxSetStatusClickBnkSubmit('<?= $tRoute?>')"></button>
    <input type="hidden" id="ohdBnkRoute" value="<?php echo $tRoute; ?>">
    <div class="panel-body" style="padding-top:20px !important;">
        <div class="row">
            <div class="col-md-4">
                <?php echo FCNtHGetContentUploadImage(@$tImgObjAll, 'Bank');?>
            </div>
            <div class="col-xs-12 col-md-5 col-lg-5"> <!-- เปลี่ยน Col Class -->
                <!-- รหัส -->
                <div class="form-group" id="odvBnkCodeForm">
                    <label class="xCNLabelFrm"><span style="color:red">*</span><?= language('bank/bank/bank','tBNKTBCode')?></label> <!-- เปลี่ยนชื่อ Class -->
                    <input type="hidden" class="form-control" maxlength="5" id="oetBnkCodeOld" name="oetBnkCodeOld"  value="<?php echo $tBnkCode ?>">
                    <input type="text" class="form-control" maxlength="5" id="oetBnkCode" name="oetBnkCode"
                        placeholder="<?= language('bank/bank/bank','tBNKTBCode')?>"
                        value="<?=$tBnkCode;?>" 
                        data-validate-required="<?php echo language('bank/bank/bank','tBNKValidCode')?>"
                    >
                </div>

                <!-- Agency -->
                <div class="<?php if( !FCNbGetIsAgnEnabled()) : echo 'xCNHide';  endif;?>">
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?php echo language('common/main/main','tAgency')?></label>
                        <div class="input-group">
                            <input type="text" class="form-control xCNHide" id="oetBNKUsrAgnCode"
                                name="oetBNKUsrAgnCode" value="<?=@$tUsrAgnCode?>">
                            <input type="text" class="form-control xWPointerEventNone" id="oetBNKUsrAgnName"
                                name="oetBNKUsrAgnName"
                                placeholder="<?php echo language('common/main/main','tAgency')?>"
                                value="<?=@$tUsrAgnName?>" readonly>
                            <span class="input-group-btn">
                                <button id="obtBNKUsrBrowseAgency" type="button" class="btn xCNBtnBrowseAddOn">
                                    <img
                                        src="<?php echo  base_url().'/application/modules/common/assets/images/icons/find-24.png'?>">
                                </button>
                            </span>
                        </div>
                    </div>
                </div>
                <!-- end Agency -->

                <!-- ชื่อ -->
                <div class="form-group">
                    <label class="xCNLabelFrm"><span style="color:red">*</span><?= language('bank/bank/bank','tBNKTBName')?></label> <!-- เปลี่ยนชื่อ Class -->
                    <input type="text" class="form-control" maxlength="100" id="oetBnkName" name="oetBnkName"
                        placeholder="<?= language('bank/bank/bank','tBNKTBName')?>"
                        value="<?=$tBnkName;?>" 
                        data-validate-required="<?php echo language('bank/bank/bank','tBNKValidName')?>"
                    >
                </div>
                <!-- หมายเหตุ -->
                <div class="form-group">
                    <label class="xCNLabelFrm"><?= language('bank/bank/bank','tBNKRemark')?></label> <!-- เปลี่ยนชื่อ Class -->
                    <textarea class="form-control" maxlength="100" rows="5" id="otaBnkRmk" name="otaBnkRmk"><?=$tBnkRmk?></textarea>
                </div>
            </div>
        </div>
    </div>
</form>
<script src="<?= base_url('application/modules/common/assets/js/jquery.mask.js')?>"></script>
<script src="<?= base_url('application/modules/common/assets/src/jFormValidate.js')?>"></script>
<script>

$(document).ready(function () {
    var tStaUsrLevel    = '<?php  echo $this->session->userdata("tSesUsrLevel"); ?>';

    if(tStaUsrLevel == 'BCH' || tStaUsrLevel == 'SHP'){
        $('#obtBNKUsrBrowseAgency').attr("disabled", true);
        // $('#oimBrowseBranch').attr("disabled", true);
    }else{
        $('#obtBNKUsrBrowseAgency').attr("disabled", false);
    }
});


$('#obtBNKUsrBrowseAgency').on('click',function(){
    var nStaSession  = JCNxFuncChkSessionExpired();
    if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
        JSxCheckPinMenuClose();
        window.oUsrAgnOption       = undefined;
        oUsrAgnOption              = oUsrBrowseAgency({
            'tReturnInputCode'          : 'oetBNKUsrAgnCode',
            'tReturnInputName'          : 'oetBNKUsrAgnName',
            'aArgReturn'                : ['FTAgnCode','FTAgnName']
        });
        JCNxBrowseData('oUsrAgnOption');
    }else{
        JCNxShowMsgSessionExpired();
    }
});

// Browse AD
// Option Browse Merchant
var nLangEdits = "<?php echo $this->session->userdata("tLangEdit")?>";
var oUsrBrowseAgency = function(poReturnInputAgency){
    
    let tInputReturnAgnCode   = poReturnInputAgency.tReturnInputCode;
    let tInputReturnAgnName   = poReturnInputAgency.tReturnInputName;
    let tAgencyNextFunc       = poReturnInputAgency.tNextFuncName;
    let aAgencyArgReturn      = poReturnInputAgency.aArgReturn;

    // let tJoinBranch = " LEFT JOIN ( SELECT FTMerCode FROM TCNMBranch GROUP BY FTMerCode ) B ON TCNMMerchant.FTMerCode = B.FTMerCode ";
    // let tJoinShop   = " LEFT JOIN ( SELECT FTMerCode FROM TCNMShop GROUP BY FTMerCode ) S ON TCNMMerchant.FTMerCode = S.FTMerCode ";

    let oAgencyOptionReturn = {
        Title : ['authen/user/user','tBrowseAgnTitle'],
        Table :{Master:'TCNMAgency',PK:'FTAgnCode'},
        Join :{
            Table:	['TCNMAgency_L'],
            On:[' TCNMAgency.FTAgnCode = TCNMAgency_L.FTAgnCode AND TCNMAgency_L.FNLngID = ' + nLangEdits] //+ tJoinBranch + tJoinShop
        },
        // Where :{
        //     Condition : [" AND ( ISNULL(B.FTMerCode,'') != '' OR ISNULL(S.FTMerCode,'') != '') "]
        // },
        GrideView:{
            ColumnPathLang	: 'authen/user/user',
            ColumnKeyLang	: ['tBrowseAgnCode','tBrowseAgnName'],
            ColumnsSize     : ['10%','75%'],
            DataColumns	    : ['TCNMAgency.FTAgnCode','TCNMAgency_L.FTAgnName'],
            DataColumnsFormat : ['',''],
            WidthModal      : 50,
            Perpage			: 10,
            OrderBy			: ['TCNMAgency.FDCreateOn DESC'],
        },
        CallBack:{
            ReturnType	: 'S',
            Value		: [tInputReturnAgnCode,"TCNMAgency.FTAgnCode"],
            Text		: [tInputReturnAgnName,"TCNMAgency_L.FTAgnName"]
        },
        //DebugSQL: true,
    };
    return oAgencyOptionReturn;
}
</script>