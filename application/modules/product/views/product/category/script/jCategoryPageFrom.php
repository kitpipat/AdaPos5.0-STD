<script>

if($('#oetCgyPdtCode').val()==''){
    $('#odvCgyPdtName').text($('#oetPdtName').val());
    $('#oetCgyPdtCode').val($('#oetPdtCode').val());
}

$('#obtPdtCategoryBack').unbind().click(function(){
    $('a[data-target="#odvPdtContentInfo1"]').click();
    $('#obtCallBackProductList').removeClass('xCNHide');
});

//Functionality : เปลี่ยนหน้า pagenation
//Parameters : Event Click Pagenation
//Creator : 13/09/2018 wasin
//Return : View
//Return Type : View
function JSvFhnPdtClickPage(ptPage) {
    var nPageCurrent = '';
    switch (ptPage) {
        case 'next': //กดปุ่ม Next
            $('.xWBtnNext').addClass('disabled');
            nPageOld = $('.xWPageFhnPdt .active').text(); // Get เลขก่อนหน้า
            nPageNew = parseInt(nPageOld, 10) + 1; // +1 จำนวน

            nPageCurrent = nPageNew
            break;
        case 'previous': //กดปุ่ม Previous
            nPageOld = $('.xWPageFhnPdt .active').text(); // Get เลขก่อนหน้า
            nPageNew = parseInt(nPageOld, 10) - 1; // -1 จำนวน
            nPageCurrent = nPageNew
            break;
        default:
            nPageCurrent = ptPage
    }
    JCNxOpenLoading();
    JSvFhnPdtClrPszLoadDataTable(nPageCurrent);
}

// Click Browse Product Depart
$('#obFhnPdtDepartBrows').click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        window.oFhnPdtDepartBrowsOption = oCatProductBrows({
            'tReturnInputCode'  : 'oetCgyPdtDepartCode',
            'tReturnInputName'  : 'oetCgyPdtDepartName',
            'nCatLevel'         : 1,
            'tCatParent'        : ''
            // 'tNextFuncName': ''
        });
        JCNxBrowseData('oFhnPdtDepartBrowsOption');
    } else {
        JCNxShowMsgSessionExpired();
    }
});




// Click Browse Product Class
$('#obFhnPdtClassBrows').click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        window.oFhnPdtClassBrowsOption = oCatProductBrows({
            'tReturnInputCode'  : 'oetCgyPdtClassCode',
            'tReturnInputName'  : 'oetCgyPdtClassName',
            'nCatLevel'         : 2,
            'tCatParent'        : 'oetCgyPdtDepartCode'
            // 'tNextFuncName': ''
        });
        JCNxBrowseData('oFhnPdtClassBrowsOption');
    } else {
        JCNxShowMsgSessionExpired();
    }
});





// Click Browse Product Sub Class
$('#obFhnPdtSubClassBrows').click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        window.oFhnPdtSubClassBrowsOption = oCatProductBrows({
            'tReturnInputCode'  : 'oetCgyPdtSubClassCode',
            'tReturnInputName'  : 'oetCgyPdtSubClassName',
            'nCatLevel'         : 3,
            'tCatParent'        : 'oetCgyPdtClassCode'
            // 'tNextFuncName': ''
        });
        JCNxBrowseData('oFhnPdtSubClassBrowsOption');
    } else {
        JCNxShowMsgSessionExpired();
    }
});






// Click Browse Product Sub Class
$('#obFhnPdtGroupBrows').click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        window.oFhnPdtGroupBrowsOption = oCatProductBrows({
            'tReturnInputCode'  : 'oetCgyPdtGroupCode',
            'tReturnInputName'  : 'oetCgyPdtGroupName',
            'nCatLevel'         : 4,
            'tCatParent'        : 'oetCgyPdtSubClassCode'
            // 'tNextFuncName': ''
        });
        JCNxBrowseData('oFhnPdtGroupBrowsOption');
    } else {
        JCNxShowMsgSessionExpired();
    }
});







// Click Browse Product Sub Class
$('#obFhnPdtComLinesBrows').click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        window.oFhnPdtComLinesBrowsOption = oCatProductBrows({
            'tReturnInputCode'  : 'oetCgyPdtComLinesCode',
            'tReturnInputName'  : 'oetCgyPdtComLinesName',
            'nCatLevel'         : 5,
            'tCatParent'        : 'oetCgyPdtGroupCode'
            // 'tNextFuncName': ''
        });
        JCNxBrowseData('oFhnPdtComLinesBrowsOption');
    } else {
        JCNxShowMsgSessionExpired();
    }
});


// Option Browse Category
// Create By : Napat(Jame) 01/07/2021
var oCatProductBrows = function(poReturnInput) {
    var tInputReturnCode    = poReturnInput.tReturnInputCode;
    var tInputReturnName    = poReturnInput.tReturnInputName;
    var nCatLevel           = poReturnInput.nCatLevel;
    var tCatParent          = $('#'+poReturnInput.tCatParent).val();
    var tSesUsrAgnCode      = '<?=$this->session->userdata("tSesUsrAgnCode")?>';
    var tLabelCode = '';
    var tLabelName = '';
    var tLabelTitle = '';

    switch(nCatLevel){
        case 2:
            tLabelTitle = 'tFhnPdtClass';
            tLabelCode = 'tFhnPdtClassCode';
            tLabelName = 'tFhnPdtClassName';
        break;
        case 3:
            tLabelTitle = 'tFhnPdtSubClass';
            tLabelCode = 'tFhnPdtSubClassCode';
            tLabelName = 'tFhnPdtSubClassName';
        break;
        case 4:
            tLabelTitle = 'tFhnPdtGroup';
            tLabelCode = 'tFhnPdtGroupCode';
            tLabelName = 'tFhnPdtGroupName';
        break;
        case 5:
            tLabelTitle = 'tFhnPdtComLines';
            tLabelCode = 'tFhnPdtComLinesCode';
            tLabelName = 'tFhnPdtComLinesName';
        break;
        default:
            tLabelTitle = 'tFhnPdtDepart';
            tLabelCode  = 'tFhnPdtDepartCode';
            tLabelName  = 'tFhnPdtDepartName';
    }

    var tConditionWhere = '';
    if( tSesUsrAgnCode != '' ){
        tConditionWhere +=" AND ( TCNMPdtCatInfo.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TCNMPdtCatInfo.FTAgnCode,'') = '' )   ";
    }

    tConditionWhere += " AND TCNMPdtCatInfo.FNCatLevel = "+nCatLevel+" ";
    tConditionWhere += " AND TCNMPdtCatInfo.FTCatStaUse = '1' ";


    var oOptionReturn = {
        Title: ['product/product/product', tLabelTitle],
        Table: {
            Master: 'TCNMPdtCatInfo',
            PK: 'FTCatCode'
        },
        Join: {
            Table: ['TCNMPdtCatInfo_L'],
            On: [
                'TCNMPdtCatInfo.FTCatCode = TCNMPdtCatInfo_L.FTCatCode AND TCNMPdtCatInfo.FNCatLevel = TCNMPdtCatInfo_L.FNCatLevel AND TCNMPdtCatInfo_L.FNLngID = ' + nLangEdits,
            ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/product/product',
            ColumnKeyLang: [tLabelCode, tLabelName],
            ColumnsSize: ['20%', '80%'],
            DataColumns: ['TCNMPdtCatInfo.FTCatCode', 'TCNMPdtCatInfo_L.FTCatName'],
            DataColumnsFormat: ['', ''],
            // DisabledColumns: [2],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TCNMPdtCatInfo.FDCreateOn'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMPdtCatInfo.FTCatCode"],
            Text: [tInputReturnName, "TCNMPdtCatInfo_L.FTCatName"],
        },
        // NextFunc: {
        //     FuncName: 'JSxCatCheckBrowseLevel',
        //     ArgReturn: ['FTCatCode', 'FTCatName']
        // },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}



$('document').ready(function(){
    // JSxCatCheckBrowseLevel();

    var tPdtForSystem   = $('#ocmPdtForSystem').val();
    var tLangCatPdtMod  = "";
    if( tPdtForSystem != '5' ){
        tLangCatPdtMod = '<?= language('product/product/product', 'tCatPdtMod') ?>';
    }else{
        tLangCatPdtMod = '<span style="color:red">*</span> <?= language('product/product/product', 'tFhnPdtMod') ?>';
    }
    $('#olbCatPdtMod').html(tLangCatPdtMod);
});


// Click Browse Product Sub Class
$('#obtPdtCategorySave').click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {


        var aStaModel = JSaCheckModelNoPdtCgy();

        if(aStaModel['rtCode']=='1'){
                var tMsg = "<?=language('product/product/product', 'tFhnPdtValidateModelNoDup')?> ";
                FSvCMNSetMsgWarningDialog(tMsg);
                return false;
            }

        if($('#oetCgyPdtModelNo').val()==''){
                var tMsg = "<?=language('product/product/product', 'tFhnPdtValidateRepleace')?> ";
                FSvCMNSetMsgWarningDialog(tMsg);
                $('#oetCgyPdtModelNo').val($('#oetPdtCode').val());
                // return false;
            }

        JSnPdtCgyAddEdit();

    } else {
        JCNxShowMsgSessionExpired();
    }
});


// Add Edit From TFHMPdtCgy
function JSnPdtCgyAddEdit(){

JCNxOpenLoading();
$.ajax({
    type: "POST",
    url: 'pdtCategoryAddEditEvent',
    data: $('#ofmAddEditProductCategory').serialize(),
    cache: false,
    timeout: 0,
    success: function(tResult) {
        let aReturn = JSON.parse(tResult);
        if (aReturn['nStaEvent'] == 1) {
            JSxPdtCategoryCallPageForm();
        }
        JCNxCloseLoading();
    },
    error: function(jqXHR, textStatus, errorThrown) {
        JCNxResponseError(jqXHR, textStatus, errorThrown);
    }
});

}






function JSaCheckModelNoPdtCgy(){
    var aReultData = [];
    $.ajax({
        type: "POST",
        url: 'pdtCategoryCheckModelNo',
        data: {tFhnPdtModelNo:$('#oetCgyPdtModelNo').val() , tPdtCode:$('#oetPdtCode').val()},
        async: false,
        timeout: 0,
        success: function(tResult) {
            let aReturn = JSON.parse(tResult);
            aReultData = aReturn;
        },
        error: function(jqXHR, textStatus, errorThrown) {
            JCNxResponseError(jqXHR, textStatus, errorThrown);
        }
    });
     return aReultData;

}

</script>
