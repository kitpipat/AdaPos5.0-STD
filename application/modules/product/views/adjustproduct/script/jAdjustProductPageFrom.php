<script>
$(function(){
    $('.selectpicker').selectpicker();
    JSxAPJSetOptionsTable();
    localStorage.removeItem("LocalItemData");
    localStorage.removeItem("Ada.ProductListCenter");
    // JSxAPJFilterDataToTemp();
});

    var tBaseURL = '<?php echo base_url(); ?>';
    var nLangEdits = '<?php echo $this->session->userdata("tLangEdit") ?>';

function JSxAPJSetOptionsTable(){

      let tTable = $('#ocmAJPSelectTable').val();
      $('#ocmAJPSelectField option').remove();
      $('#ocmAJPSelectField').append(JStAJPGetOptionFieldHtml(tTable)).selectpicker('refresh');
      $('#ocmAJPSelectField').val($('#ocmAJPSelectField option').first().val()).selectpicker('refresh');
      
      let tField = $('#ocmAJPSelectField').val();
      $('#ocmAJPSelectValue option').remove();
      $('#ocmAJPSelectValue').append(JStAJPGetOptionValueHtml(tField)).selectpicker('refresh');
      $('#ocmAJPSelectValue').val($('#ocmAJPSelectValue option').first().val()).selectpicker('refresh');

      if(tTable=='TFHMPdtColorSize'){
            $('.xFashionHide').show();
      }else{
            $('.xFashionHide').hide();
      }
      JSxAPJFilterDataToTemp();
}

function JSxAPJSetOptionsField(){
    let tField = $('#ocmAJPSelectField').val();
      $('#ocmAJPSelectValue option').remove();
      $('#ocmAJPSelectValue').append(JStAJPGetOptionValueHtml(tField)).selectpicker('refresh');
      $('#ocmAJPSelectValue').val($('#ocmAJPSelectValue option').first().val()).selectpicker('refresh');
}



$('#ocmAJPSelectTable').on('change',function(){
    JSxAPJSetOptionsTable();
});

$('#ocmAJPSelectField').on('change',function(){
    JSxAPJSetOptionsField();
});

$('#obtMainAdjustProductFilter').on('click',function(){
    JSxAPJFilterDataToTemp();
});

$('#obtMainAlertConfirmUpdate').click(function(){
    $('#ospAJPCoutTotalSelecet').text($('#ohdAJPCountSelectRow').val());
    $('#odvAJPModalConfirmUpdate').modal('show');
});


$('#obtMainSaveAdjustProduct').click(function(){
    var nStaSession = JCNxFuncChkSessionExpired();
    JCNxOpenLoading();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        $.ajax({
            type: "POST",
            url: "adjustProductEventUpdate",
            data : {
                tAJPSelectTable : $('#ocmAJPSelectTable').val(),
                tAJPSelectField : $('#ocmAJPSelectField').val(),
                tAJPSelectValue : $('#ocmAJPSelectValue').val(),
            },
            cache: false,
            timeout: 0,
            success: function(oResult) {
                var aResult = JSON.parse(oResult);
                if(aResult['rtCode']=='1'){
                    FSvCMNSetMsgSucessDialog(aResult['rtDesc']);
                }else{
                    FSvCMNSetMsgWarningDialog(aResult['rtDesc']);
                }
                $('#odvAJPModalConfirmUpdate').modal('hide');
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
});

function JSxAPJUpdateStaAlw(paData){
    var nStaSession = JCNxFuncChkSessionExpired();
    JCNxOpenLoading();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        $.ajax({
            type: "POST",
            url: "adjustProductEventEditRowIDInTemp",
            data: paData,
            cache: false,
            timeout: 0,
            success: function(oResult) {
                JCNxCloseLoading();
                var aResult = JSON.parse(oResult);
                if(aResult['rtCode']=='1'){
                    $('#ohdAJPCountSelectRow').val(aResult['rnCountRow']);
                    $('#ohdCheckedRowCout').val(aResult['rnCountRow']);
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
}

function JSxAPJFilterDataToTemp(){
    var nStaSession = JCNxFuncChkSessionExpired();
    JCNxOpenLoading();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        $.ajax({
            type: "POST",
            url: "adjustProductDumpDataToTemp",
            data: $('#ofmAdjustProduct').serialize(),
            cache: false,
            timeout: 0,
            success: function(oResult) {
                var aResult = JSON.parse(oResult);
                // if(aResult['rtCode']=='1'){
                    JSxAPJCallDataTable();
                // }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
}


function JSxAPJCallDataTable(pnPage){
    var nStaSession = JCNxFuncChkSessionExpired();
    JCNxOpenLoading();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    var nPageCurrent = pnPage;
    if(typeof(nPageCurrent) == undefined || nPageCurrent == "") {
        nPageCurrent = "1";
    }
        $.ajax({
            type: "POST",
            url: "adjustProductDataTable",
            data: {
                nPageCurrent    : nPageCurrent,
                ocmAJPSelectTable : $('#ocmAJPSelectTable').val(),
                ocmAJPSelectField : $('#ocmAJPSelectField').val(),
                ocmAJPSelectValue : $('#ocmAJPSelectValue').val(),
                nPagePDTAll: $('#nPagePDTAll').val()
            },
            cache: false,
            timeout: 0,
            success: function(tView) {
                $('#odvAJPDataTable').html(tView);
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
}


// Functionality : เปลี่ยนหน้า pagenation
// Parameters : Event Click Pagenation
// Creator : 25/02/2019 wasin(Yoshi)
// Return : View
// Return Type : View
function JSvAPJClickPage(ptPage, pnEndPage) {
    var nPageCurrent = '';
    switch (ptPage) {
        case 'Fisrt': //กดหน้าแรก
            nPageCurrent = 1;
            break;
        case 'next': //กดปุ่ม Next
            $('.xWBtnNext').addClass('disabled');
            nPageOld = $('.xWPageAPJ .active').text(); // Get เลขก่อนหน้า
            nPageNew = parseInt(nPageOld, 10) + 1; // +1 จำนวน
            nPageCurrent = nPageNew
            break;
        case 'previous': //กดปุ่ม Previous
            nPageOld = $('.xWPageAPJ .active').text(); // Get เลขก่อนหน้า
            nPageNew = parseInt(nPageOld, 10) - 1; // -1 จำนวน
            nPageCurrent = nPageNew
            break;
        case 'Last': //กดหน้าสุดท้าย
            nPageCurrent = pnEndPage;
            break;
        default:
            nPageCurrent = ptPage
    }
    JCNxOpenLoading();
    JSxAPJCallDataTable(nPageCurrent);
}
function JStAJPGetOptionFieldHtml(ptTable){
    let tHTML = "";
    switch(ptTable) {
        case 'TCNMPdt':
            tHTML +='<option value="FTPdtPoint"><?= language('product/product/product','tAdjPdtStaPoint')?></option>';
            tHTML +='<option value="FTPdtStaAlwDis"><?= language('product/product/product','tAdjPdtStaDis')?></option>';
            tHTML +='<option value="FTPdtStaVat"><?= language('product/product/product','tAdjPdtStaVat')?></option>';
            tHTML +='<option value="FTPdtStaActive"><?= language('product/product/product','tAdjPdtStaAvtive')?></option>';
        break;
        case 'TCNMPdtPackSize':
            tHTML +='<option value="FTPdtStaAlwPick"><?= language('product/product/product','tAdjPdtStaPO')?></option>';
            tHTML +='<option value="FTPdtStaAlwPoHQ"><?= language('product/product/product','tAdjPdtStaAlwHQ')?></option>';
            tHTML +='<option value="FTPdtStaAlwBuy"><?= language('product/product/product','tAdjPdtStaAlwPO')?></option>';
            tHTML +='<option value="FTPdtStaAlwSale"><?= language('product/product/product','tAdjPdtStaAlwSale')?></option>';
        break;
        case 'TCNMPdtBar':
            tHTML +='<option class="xOption TCNMPdtBar" value="FTBarStaUse"><?= language('product/product/product','tAdjPdtStaAlwUse')?></option>';
            tHTML +='<option class="xOption TCNMPdtBar" value="FTBarStaAlwSale"><?= language('product/product/product','tAdjPdtStaAlwSale')?></option>';
        break;
        case 'TFHMPdtColorSize':
            tHTML +='<option value="FTFhnStaActive"><?= language('product/product/product','tAdjPdtStaAlwUse')?></option>';
        break;
    }

    return tHTML;
}

function JStAJPGetOptionValueHtml(ptField){
    let tHTML = "";
            tHTML +='<option value=""><?= language('product/product/product','tAdjPdtNull')?></option>';
    switch(ptField) {
        case 'FTPdtPoint':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaPoint1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaPoint2')?></option>';
        break;
        case 'FTPdtStaAlwDis':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaAlw1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaAlw2')?></option>';
        break;
        case 'FTPdtStaVat':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaHave1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaHave2')?></option>';
        break;
        case 'FTPdtStaActive':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaEnable1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaEnable2')?></option>';
        break;
        case 'FTPdtStaAlwPick':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaAlw1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaAlw2')?></option>';
        break;
        case 'FTPdtStaAlwPoHQ':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaAlw1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaAlw2')?></option>';
        break;
        case 'FTPdtStaAlwBuy':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaAlw1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaAlw2')?></option>';
        break;
        case 'FTPdtStaAlwSale':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaAlw1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaAlw2')?></option>';
        break;
        case 'FTBarStaUse':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaAlwUse1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaAlwUse2')?></option>';
        break;
        case 'FTBarStaAlwSale':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaAlw1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaAlw2')?></option>';
        break;
        case 'FTFhnStaActive':
            tHTML +='<option value="1"><?= language('product/product/product','tAdjPdtStaAlwUse1')?></option>';
            tHTML +='<option value="2"><?= language('product/product/product','tAdjPdtStaAlwUse2')?></option>';
        break;
    }

    return tHTML;
}


function JSxClearConditionAll() {
        <?php if($this->session->userdata('tSesUsrAgnCode')==''){  ?>
            $('#oetAJPAgnCode').val('');
            $('#oetAJPAgnName').val('');
        <?php } ?>
        <?php if(FCNbUsrIsAgnLevel()){  ?>
            $('#oetAJPBchCode').val('');
            $('#oetAJPBchName').val('');
        <?php } ?>
            $('#oetAJPPdtCodeFrom').val('');
            $('#oetAJPPdtNameFrom').val('');

            $('#oetAJPPdtCodeTo').val('');
            $('#oetAJPPdtNameTo').val('');

            $('#oetAJPPdtCodeTo').val('');
            $('#oetAJPPdtNameTo').val('');

            $('#oetAJPPgpCode').val('');
            $('#oetAJPPgpName').val('');

            $('#oetAJPPbnCode').val('');
            $('#oetAJPPbnName').val('');

            $('#oetAJPPmoCode').val('');
            $('#oetAJPPmoName').val('');

            $('#oetAJPPtyCode').val('');
            $('#oetAJPPtyName').val('');

            $('#oetFhnPdtDepartCode').val('');
            $('#oetFhnPdtDepartName').val('');

            $('#oetFhnPdtClassCode').val('');
            $('#oetFhnPdtClassName').val('');

            $('#oetFhnPdtSubClassCode').val('');
            $('#oetFhnPdtSubClassName').val('');

            $('#oetFhnPdtGroupCode').val('');
            $('#oetFhnPdtGroupName').val('');

            $('#oetFhnPdtComLinesCode').val('');
            $('#oetFhnPdtComLinesName').val('');

            $('#oetFhnPdtSeasonCode').val('');
            $('#oetFhnPdtSeasonName').val('');

            $('#oetFhnPdtFabricCode').val('');
            $('#oetFhnPdtFabricName').val('');

            $('#oetFhnPdtSizeCode').val('');
            $('#oetFhnPdtSizeName').val('');

            $('#oetFhnPdtColorCode').val('');
            $('#oetFhnPdtColorName').val('');

            $('#ocmAJPStaAlwPoHQ').val('').selectpicker('refresh');

            localStorage.removeItem("LocalItemData");
            localStorage.removeItem("Ada.ProductListCenter");
    }


$('#obtAJPBrowsPdtFrom').click(function(){
    JSxAPJBrowsePdt('from');
});

$('#obtAJPBrowsPdtTo').click(function(){
    JSxAPJBrowsePdt('to');
});


/*
function : Function Browse Pdt
Parameters : Error Ajax Function 
Creator : 22/05/2019 Piya(Tiger)
Return : Modal Status Error
Return Type : view
*/
function JSxAPJBrowsePdt(ptType) {
    $('#odvModalDOCPDT').modal({backdrop: 'static', keyboard: false});
    if(ptType == 'from'){
        tNextFunc = 'JSxAPJBrowsePdtFrom';
    }else{
        tNextFunc = 'JSxAPJBrowsePdtTo';
    }
    if(localStorage.getItem("Ada.ProductListCenter") === null){
        localStorage.setItem("Ada.ProductListCenter",true);
        var dTime               = new Date();
        var dTimelocalStorage   = dTime.getTime();

        $.ajax({
            type: "POST",
            url: "BrowseDataPDT",
            data: {
                'Qualitysearch'   : ['SUP','NAMEPDT','CODEPDT','FromToBCH','FromToSHP','FromToPGP','FromToPTY'],
                'PriceType'       : ['Pricesell'],
                'SelectTier'      : ['PDT'],//PDT, Barcode
                // 'Elementreturn'   : ['oetASTFilterPdtCodeFrom','oetASTFilterPdtNameFrom'],
                'ShowCountRecord' : 10,
                'NextFunc'        : tNextFunc,
                'ReturnType'      : 'S', //S = Single M = Multi
                'SPL'             : ['',''],
                'BCH'             : [$('#oetAJPBchCode').val(),''],//Code, Name
                'SHP'             : ['',''],
                'TimeLocalstorage': dTimelocalStorage
            },
            cache: false,
            timeout: 0,
            success: function(tResult){
                // $('#odvModalDOCPDT').modal({backdrop: 'static', keyboard: false})  
                $('#odvModalDOCPDT').modal({ show: true });

                //remove localstorage
                localStorage.removeItem("LocalItemDataPDT");
                $('#odvModalsectionBodyPDT').html(tResult);
            },
            error: function(data) {
                console.log(data);
            }
        });
    }else{
        $('#odhEleNameNextFunc').val(tNextFunc);
        $('#odvModalDOCPDT').modal({ show: true });
    }
}

function JSxAPJBrowsePdtFrom(poPdtData){
    var aDataPdt = JSON.parse(poPdtData);
    var tPdtCode = aDataPdt[0]['packData']['PDTCode'];
    var tPdtName = aDataPdt[0]['packData']['PDTName'];

    $('#oetAJPPdtCodeFrom').val(tPdtCode);
    $('#oetAJPPdtNameFrom').val(tPdtName);

    if($('#oetAJPPdtCodeTo').val() == ''){
        $('#oetAJPPdtCodeTo').val(tPdtCode);
        $('#oetAJPPdtNameTo').val(tPdtName);
    }
    
}

function JSxAPJBrowsePdtTo(poPdtData){
    var aDataPdt = JSON.parse(poPdtData);
    var tPdtCode = aDataPdt[0]['packData']['PDTCode'];
    var tPdtName = aDataPdt[0]['packData']['PDTName'];

    $('#oetAJPPdtCodeTo').val(tPdtCode);
    $('#oetAJPPdtNameTo').val(tPdtName);

    if($('#oetAJPPdtCodeFrom').val() == ''){
        $('#oetAJPPdtCodeFrom').val(tPdtCode);
        $('#oetAJPPdtNameFrom').val(tPdtName);
    }
}


    // Click Browse Agency
    $('#obtAJPBrowsAgn').click(function(e) {
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            JSxCheckPinMenuClose();
            window.oPdtBrowseAgencyOption = oPdtBrowseAgency({
                'tReturnInputCode': 'oetAJPAgnCode',
                'tReturnInputName': 'oetAJPAgnName'
            });
            JCNxBrowseData('oPdtBrowseAgencyOption');
        } else {
            JCNxShowMsgSessionExpired();
        }
    });


    // Click Browse Branch
    $('#obtAJPBrowsBch').click(function(e) {
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            JSxCheckPinMenuClose();
            window.oPdtBrowseBranchOption = oPdtBrowseBranch({
                'tReturnInputCode': 'oetAJPBchCode',
                'tReturnInputName': 'oetAJPBchName',
                'tAgnCodeWhere': $('#oetAJPAgnCode').val(),
            });
            JCNxBrowseData('oPdtBrowseBranchOption');
        } else {
            JCNxShowMsgSessionExpired();
        }
    });

    // Click Browse Product Group
    $('#obtAJPBrowsPgp').click(function(e) {
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            // Create By Witsarut 04/10/2019
            JSxCheckPinMenuClose();
            // Create By Witsarut 04/10/2019
            window.oPdtBrowsePdtGrpOption = oPdtBrowsePdtGrp({
                'tReturnInputCode': 'oetAJPPgpCode',
                'tReturnInputName': 'oetAJPPgpName',
                'tAgnCodeWhere': $('#oetAJPAgnCode').val()
            });
            JCNxBrowseData('oPdtBrowsePdtGrpOption');
        } else {
            JCNxShowMsgSessionExpired();
        }
    });


   // Click Browse Product Type
   $('#obtAJPBrowsPty').click(function(e) {
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            // Create By Witsarut 04/10/2019
            JSxCheckPinMenuClose();
            // Create By Witsarut 04/10/2019
            window.oPdtBrowsePdtTypeOption = oPdtBrowsePdtType({
                'tReturnInputCode': 'oetAJPPtyCode',
                'tReturnInputName': 'oetAJPPtyName',
                'tAgnCodeWhere': $('#oetAJPAgnCode').val()
            });
            JCNxBrowseData('oPdtBrowsePdtTypeOption');
        } else {
            JCNxShowMsgSessionExpired();
        }
    });

    // Click Browse Product Brand
    $('#obtAJPBrowsPbn').click(function(e) {
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            // Create By Witsarut 04/10/2019
            JSxCheckPinMenuClose();
            // Create By Witsarut 04/10/2019
            window.oPdtBrowsePdtBrandOption = oPdtBrowsePdtBrand({
                'tReturnInputCode': 'oetAJPPbnCode',
                'tReturnInputName': 'oetAJPPbnName',
                'tAgnCodeWhere': $('#oetAJPAgnCode').val()
            });
            JCNxBrowseData('oPdtBrowsePdtBrandOption');
        } else {
            JCNxShowMsgSessionExpired();
        }
    });

    // Click Browse Product Model
    $('#obtAJPBrowsPmo').click(function(e) {
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            // Create By Witsarut 04/10/2019
            JSxCheckPinMenuClose();
            // Create By Witsarut 04/10/2019
            window.oPdtBrowsePdtModelOption = oPdtBrowsePdtModel({
                'tReturnInputCode': 'oetAJPPmoCode',
                'tReturnInputName': 'oetAJPPmoName',
                'tAgnCodeWhere': $('#oetAJPAgnCode').val()
            });
            JCNxBrowseData('oPdtBrowsePdtModelOption');
        } else {
            JCNxShowMsgSessionExpired();
        }
    });



    //เลือกสาขา
    var oPdtBrowseAgency = function(poReturnInput) {
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
            BrowseLev: nStaPdtBrowseType,
            NextFunc: {
                FuncName: 'JSxClearBrowseConditionAgn',
                ArgReturn: ['FTAgnCode']
            },
            BrowseLev : 1
        }
        return oOptionReturn;
    }




    function JSxClearBrowseConditionAgn(ptData) {
        // aData = JSON.parse(ptData);
        if (ptData != '' || ptData != 'NULL') {

            $('#oetAJPBchCode').val('');
            $('#oetAJPBchName').val('');

            $('#oetAJPPdtCodeFrom').val('');
            $('#oetAJPPdtNameFrom').val('');

            $('#oetAJPPdtCodeTo').val('');
            $('#oetAJPPdtNameTo').val('');

            $('#oetAJPPdtCodeTo').val('');
            $('#oetAJPPdtNameTo').val('');

            $('#oetAJPPgpCode').val('');
            $('#oetAJPPgpName').val('');

            $('#oetAJPPbnCode').val('');
            $('#oetAJPPbnName').val('');

            $('#oetAJPPmoCode').val('');
            $('#oetAJPPmoName').val('');

            $('#oetAJPPtyCode').val('');
            $('#oetAJPPtyName').val('');

            localStorage.removeItem("LocalItemData");
            localStorage.removeItem("Ada.ProductListCenter");
        }
    }


    function JSxClearBrowseConditionBCH(ptData){
    // aData = JSON.parse(ptData);
    if (ptData != '' || ptData != 'NULL') {


        $('#oetAJPPdtCodeFrom').val('');
        $('#oetAJPPdtNameFrom').val('');

        $('#oetAJPPdtCodeTo').val('');
        $('#oetAJPPdtNameTo').val('');

        localStorage.removeItem("LocalItemData");
        localStorage.removeItem("Ada.ProductListCenter");

        }
    }
    //เลือกสาขา
    var oPdtBrowseBranch = function(poReturnInput) {
        var tInputReturnCode = poReturnInput.tReturnInputCode;
        var tInputReturnName = poReturnInput.tReturnInputName;
        var tAgnCodeWhere = poReturnInput.tAgnCodeWhere;

        var nCountBCH = '<?= $this->session->userdata('nSesUsrBchCount') ?>';
        // alert(nCountBCH);
        if (nCountBCH != '0') {
            //ถ้าสาขามากกว่า 1
            tBCH = "<?= $this->session->userdata('tSesUsrBchCodeMulti'); ?>";
            tWhereBCH = " AND TCNMBranch.FTBchCode IN ( " + tBCH + " ) ";
        } else {
            tWhereBCH = '';
        }

        if (tAgnCodeWhere == '' || tAgnCodeWhere == null) {
            tWhereAgn = '';
        } else {
            tWhereAgn = " AND TCNMBranch.FTAgnCode = '" + tAgnCodeWhere + "'";
        }


        var oOptionReturn = {
            Title: ['company/branch/branch', 'tBCHTitle'],
            Table: {
                Master: 'TCNMBranch',
                PK: 'FTBchCode'
            },
            Join: {
                Table: ['TCNMBranch_L', 'TCNMAgency_L'],
                On: [
                    'TCNMBranch_L.FTBchCode = TCNMBranch.FTBchCode AND TCNMBranch_L.FNLngID = ' + nLangEdits,
                    'TCNMAgency_L.FTAgnCode = TCNMBranch.FTAgnCode AND TCNMAgency_L.FNLngID = ' + nLangEdits,
                ]
            },
            Where: {
                Condition: [tWhereBCH + tWhereAgn]
                // Condition: [tWhereAgn]
            },
            GrideView: {
                ColumnPathLang: 'company/branch/branch',
                ColumnKeyLang: ['tBCHCode', 'tBCHName'],
                ColumnsSize: ['15%', '75%'],
                DataColumns: ['TCNMBranch.FTBchCode', 'TCNMBranch_L.FTBchName', 'TCNMAgency_L.FTAgnName', 'TCNMBranch.FTAgnCode'],
                DataColumnsFormat: ['', '', '', ''],
                DisabledColumns: [2, 3],
                WidthModal: 50,
                Perpage: 10,
                OrderBy: ['TCNMBranch.FDCreateOn DESC'],
            },
            CallBack: {
                ReturnType: 'S',
                Value: [tInputReturnCode, "TCNMBranch.FTBchCode"],
                Text: [tInputReturnName, "TCNMBranch_L.FTBchName"],
            },
            RouteAddNew: 'branch',
            BrowseLev: nStaPdtBrowseType,
            NextFunc: {
                FuncName: 'JSxClearBrowseConditionBCH',
                ArgReturn: ['FTAgnName', 'FTAgnCode']
            },
            BrowseLev : 1
        }
        return oOptionReturn;
    }

    // Option Browse Product Group
    var oPdtBrowsePdtGrp = function(poReturnInput) {
        var tInputReturnCode = poReturnInput.tReturnInputCode;
        var tInputReturnName = poReturnInput.tReturnInputName;
        var tAgnCodeWhere = poReturnInput.tAgnCodeWhere;

        if (tAgnCodeWhere == '' || tAgnCodeWhere == null) {
            tWhereAgn = '';
        } else {
            tWhereAgn = " AND TCNMPdtGrp.FTAgnCode = '" + tAgnCodeWhere + "'";
        }

        var oOptionReturn = {
            Title: ['product/pdtgroup/pdtgroup', 'tPGPTitle'],
            Table: {
                Master: 'TCNMPdtGrp',
                PK: 'FTPgpChain'
            },
            Join: {
                Table: ['TCNMPdtGrp_L'],
                On: ['TCNMPdtGrp.FTPgpChain = TCNMPdtGrp_L.FTPgpChain AND TCNMPdtGrp_L.FNLngID = ' + nLangEdits]
            },
            Where: {
                Condition: [tWhereAgn]
            },
            GrideView: {
                ColumnPathLang: 'product/pdtgroup/pdtgroup',
                ColumnKeyLang: ['tPGPCode', 'tPGPChainCode', 'tPGPName', 'tPGPChain'],
                ColumnsSize: ['10%', '15%', '40%', '35%'],
                DataColumns: ['TCNMPdtGrp.FTPgpCode', 'TCNMPdtGrp.FTPgpChain', 'TCNMPdtGrp_L.FTPgpName', 'TCNMPdtGrp_L.FTPgpChainName'],
                DataColumnsFormat: ['', '', '', ''],
                WidthModal: 50,
                Perpage: 10,
                OrderBy: ['TCNMPdtGrp.FDCreateOn DESC'],
                // SourceOrder: "ASC"
            },
            CallBack: {
                ReturnType: 'S',
                Value: [tInputReturnCode, "TCNMPdtGrp.FTPgpChain"],
                Text: [tInputReturnName, "TCNMPdtGrp_L.FTPgpChainName"],
            },
            // RouteAddNew : 'pdtgroup',
            BrowseLev : 1
        }
        return oOptionReturn;
    }




    // Option Browse Product Type
    var oPdtBrowsePdtType = function(poReturnInput) {
        var tInputReturnCode = poReturnInput.tReturnInputCode;
        var tInputReturnName = poReturnInput.tReturnInputName;
        var tAgnCodeWhere = poReturnInput.tAgnCodeWhere;

        if (tAgnCodeWhere == '' || tAgnCodeWhere == null) {
            tWhereAgn = '';
        } else {
            tWhereAgn = " AND TCNMPdtType.FTAgnCode = '" + tAgnCodeWhere + "'";
        }
        var oOptionReturn = {
            Title: ['product/pdttype/pdttype', 'tPTYTitle'],
            Table: {
                Master: 'TCNMPdtType',
                PK: 'FTPtyCode'
            },
            Join: {
                Table: ['TCNMPdtType_L'],
                On: ['TCNMPdtType_L.FTPtyCode = TCNMPdtType.FTPtyCode AND TCNMPdtType_L.FNLngID = ' + nLangEdits]
            },
            Where: {
                Condition: [tWhereAgn]
            },
            GrideView: {
                ColumnPathLang: 'product/pdttype/pdttype',
                ColumnKeyLang: ['tPTYCode', 'tPTYName'],
                ColumnsSize: ['10%', '90%'],
                DataColumns: ['TCNMPdtType.FTPtyCode', 'TCNMPdtType_L.FTPtyName'],
                DataColumnsFormat: ['', ''],
                WidthModal: 50,
                Perpage: 5,
                OrderBy: ['TCNMPdtType.FTPtyCode'],
                // SourceOrder: "DESC"
            },
            CallBack: {
                ReturnType: 'S',
                Value: [tInputReturnCode, "TCNMPdtType.FTPtyCode"],
                Text: [tInputReturnName, "TCNMPdtType_L.FTPtyName"],
            },
            // RouteAddNew: 'pdttype',
            BrowseLev: 1
        }
        return oOptionReturn;
    }


    
    // Option Browse Product Brand
    var oPdtBrowsePdtBrand = function(poReturnInput) {
        var tInputReturnCode = poReturnInput.tReturnInputCode;
        var tInputReturnName = poReturnInput.tReturnInputName;
        var tAgnCodeWhere = poReturnInput.tAgnCodeWhere;

        if (tAgnCodeWhere == '' || tAgnCodeWhere == null) {
            tWhereAgn = '';
        } else {
            tWhereAgn = " AND TCNMPdtBrand.FTAgnCode = '" + tAgnCodeWhere + "'";
        }

        var oOptionReturn = {
            Title: ['product/pdtbrand/pdtbrand', 'tPBNTitle'],
            Table: {
                Master: 'TCNMPdtBrand',
                PK: 'FTPbnCode'
            },
            Join: {
                Table: ['TCNMPdtBrand_L'],
                On: ['TCNMPdtBrand_L.FTPbnCode = TCNMPdtBrand.FTPbnCode AND TCNMPdtBrand_L.FNLngID = ' + nLangEdits]
            },
            Where: {
                Condition: [tWhereAgn]
            },
            GrideView: {
                ColumnPathLang: 'product/pdtbrand/pdtbrand',
                ColumnKeyLang: ['tPBNCode', 'tPBNName'],
                ColumnsSize: ['10%', '90%'],
                DataColumns: ['TCNMPdtBrand.FTPbnCode', 'TCNMPdtBrand_L.FTPbnName'],
                DataColumnsFormat: ['', ''],
                WidthModal: 50,
                Perpage: 10,
                OrderBy: ['TCNMPdtBrand.FDCreateOn DESC'],
                // SourceOrder: "DESC"
            },
            CallBack: {
                ReturnType: 'S',
                Value: [tInputReturnCode, "TCNMPdtBrand.FTPbnCode"],
                Text: [tInputReturnName, "TCNMPdtBrand_L.FTPbnName"],
            },
            // RouteAddNew : 'pdtbrand',
            BrowseLev : 1
        }
        return oOptionReturn;
    }

    // Option Browse Product Model
    var oPdtBrowsePdtModel = function(poReturnInput) {
        var tInputReturnCode = poReturnInput.tReturnInputCode;
        var tInputReturnName = poReturnInput.tReturnInputName;
        var tAgnCodeWhere = poReturnInput.tAgnCodeWhere;

        if (tAgnCodeWhere == '' || tAgnCodeWhere == null) {
            tWhereAgn = '';
        } else {
            tWhereAgn = " AND TCNMPdtModel.FTAgnCode = '" + tAgnCodeWhere + "'";
        }

        var oOptionReturn = {
            Title: ['product/pdtmodel/pdtmodel', 'tPMOTitle'],
            Table: {
                Master: 'TCNMPdtModel',
                PK: 'FTPmoCode'
            },
            Join: {
                Table: ['TCNMPdtModel_L'],
                On: ['TCNMPdtModel_L.FTPmoCode = TCNMPdtModel.FTPmoCode AND TCNMPdtModel_L.FNLngID = ' + nLangEdits]
            },
            Where: {
                Condition: [tWhereAgn]
            },
            GrideView: {
                ColumnPathLang: 'product/pdtmodel/pdtmodel',
                ColumnKeyLang: ['tPMOCode', 'tPMOName'],
                ColumnsSize: ['10%', '90%'],
                DataColumns: ['TCNMPdtModel.FTPmoCode', 'TCNMPdtModel_L.FTPmoName'],
                DataColumnsFormat: ['', ''],
                WidthModal: 50,
                Perpage: 10,
                OrderBy: ['TCNMPdtModel.FDCreateOn DESC'],
                // SourceOrder: "DESC"
            },
            CallBack: {
                ReturnType: 'S',
                Value: [tInputReturnCode, "TCNMPdtModel.FTPmoCode"],
                Text: [tInputReturnName, "TCNMPdtModel_L.FTPmoName"],
            },
            // RouteAddNew: 'pdtmodel',
            BrowseLev: 1
        }
        return oOptionReturn;
    }



// Click Browse Product Depart
$('#obFhnPdtDepartBrows').click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    window.oFhnPdtDepartBrowsOption = oFhnPdtDepartBrows({
        'tReturnInputCode': 'oetFhnPdtDepartCode',
        'tReturnInputName': 'oetFhnPdtDepartName'
        // 'tNextFuncName': ''
    });
    JCNxBrowseData('oFhnPdtDepartBrowsOption');
} else {
    JCNxShowMsgSessionExpired();
}
});


// Option Add Browse Product Depart
var oFhnPdtDepartBrows = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tSesUsrAgnCode = '<?=$this->session->userdata("tSesUsrAgnCode")?>';

    var tConditionWhere = '';
        if(tSesUsrAgnCode!=''){
            tConditionWhere +=" AND ( TFHMPdtF1Depart.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TFHMPdtF1Depart.FTAgnCode,'') = '' )   ";
        }

    var oOptionReturn = {
        Title: ['product/product/product', 'tFhnPdtDepart'],
        Table: {
            Master: 'TFHMPdtF1Depart',
            PK: 'FTDepCode'
        },
        Join: {
                Table: ['TFHMPdtF1Depart_L'],
                On: [
                    'TFHMPdtF1Depart.FTDepCode = TFHMPdtF1Depart_L.FTDepCode AND TFHMPdtF1Depart_L.FNLngID = ' + nLangEdits,
                ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/product/product',
            ColumnKeyLang: ['tFhnPdtDepartCode', 'tFhnPdtDepartName'],
            ColumnsSize: ['20%', '80%'],
            DataColumns: ['TFHMPdtF1Depart.FTDepCode', 'TFHMPdtF1Depart_L.FTDepName'],
            DataColumnsFormat: ['', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TFHMPdtF1Depart.FTDepCode'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TFHMPdtF1Depart.FTDepCode"],
            Text: [tInputReturnName, "TFHMPdtF1Depart_L.FTDepName"],
        },
        // NextFunc: {
        //     FuncName: tNextFuncName,
        //     ArgReturn: ['FTEvnCode', 'FTEvnName']
        // },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}



// Click Browse Product Class
$('#obFhnPdtClassBrows').click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    window.oFhnPdtClassBrowsOption = oFhnPdtClassBrows({
        'tReturnInputCode': 'oetFhnPdtClassCode',
        'tReturnInputName': 'oetFhnPdtClassName'
        // 'tNextFuncName': ''
    });
    JCNxBrowseData('oFhnPdtClassBrowsOption');
} else {
    JCNxShowMsgSessionExpired();
}
});


// Option Add Browse Product Class
var oFhnPdtClassBrows = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tSesUsrAgnCode = '<?=$this->session->userdata("tSesUsrAgnCode")?>';

    var tConditionWhere = '';
        if(tSesUsrAgnCode!=''){
            tConditionWhere +=" AND ( TFHMPdtF2Class.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TFHMPdtF2Class.FTAgnCode,'') = '' )  ";
        }

    var oOptionReturn = {
        Title: ['product/product/product', 'tFhnPdtClass'],
        Table: {
            Master: 'TFHMPdtF2Class',
            PK: 'FTClsCode'
        },
        Join: {
                Table: ['TFHMPdtF2Class_L'],
                On: [
                    'TFHMPdtF2Class.FTClsCode = TFHMPdtF2Class_L.FTClsCode AND TFHMPdtF2Class_L.FNLngID = ' + nLangEdits,
                ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/product/product',
            ColumnKeyLang: ['tFhnPdtClassCode', 'tFhnPdtClassName'],
            ColumnsSize: ['20%', '80%'],
            DataColumns: ['TFHMPdtF2Class.FTClsCode', 'TFHMPdtF2Class_L.FTClsName'],
            DataColumnsFormat: ['', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TFHMPdtF2Class.FTClsCode'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TFHMPdtF2Class.FTClsCode"],
            Text: [tInputReturnName, "TFHMPdtF2Class_L.FTClsName"],
        },
        // NextFunc: {
        //     FuncName: tNextFuncName,
        //     ArgReturn: ['FTEvnCode', 'FTEvnName']
        // },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}




// Click Browse Product Sub Class
$('#obFhnPdtSubClassBrows').click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    window.oFhnPdtSubClassBrowsOption = oFhnPdtSubClassBrows({
        'tReturnInputCode': 'oetFhnPdtSubClassCode',
        'tReturnInputName': 'oetFhnPdtSubClassName'
        // 'tNextFuncName': ''
    });
    JCNxBrowseData('oFhnPdtSubClassBrowsOption');
} else {
    JCNxShowMsgSessionExpired();
}
});


// Option Add Browse Product Sub Class
var oFhnPdtSubClassBrows = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tSesUsrAgnCode = '<?=$this->session->userdata("tSesUsrAgnCode")?>';

    var tConditionWhere = '';
        if(tSesUsrAgnCode!=''){
            tConditionWhere +=" AND ( TFHMPdtF3SubClass.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TFHMPdtF3SubClass.FTAgnCode,'') = '' ) ";
        }

    var oOptionReturn = {
        Title: ['product/product/product', 'tFhnPdtSubClass'],
        Table: {
            Master: 'TFHMPdtF3SubClass',
            PK: 'FTSclCode'
        },
        Join: {
                Table: ['TFHMPdtF3SubClass_L'],
                On: [
                    'TFHMPdtF3SubClass.FTSclCode = TFHMPdtF3SubClass_L.FTSclCode AND TFHMPdtF3SubClass_L.FNLngID = ' + nLangEdits,
                ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/product/product',
            ColumnKeyLang: ['tFhnPdtSubClassCode', 'tFhnPdtSubClassName'],
            ColumnsSize: ['20%', '80%'],
            DataColumns: ['TFHMPdtF3SubClass.FTSclCode', 'TFHMPdtF3SubClass_L.FTSclName'],
            DataColumnsFormat: ['', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TFHMPdtF3SubClass.FTSclCode'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TFHMPdtF3SubClass.FTSclCode"],
            Text: [tInputReturnName, "TFHMPdtF3SubClass_L.FTSclName"],
        },
        // NextFunc: {
        //     FuncName: tNextFuncName,
        //     ArgReturn: ['FTEvnCode', 'FTEvnName']
        // },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}






// Click Browse Product Sub Class
$('#obFhnPdtGroupBrows').click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    window.oFhnPdtGroupBrowsOption = oFhnPdtGroupBrows({
        'tReturnInputCode': 'oetFhnPdtGroupCode',
        'tReturnInputName': 'oetFhnPdtGroupName'
        // 'tNextFuncName': ''
    });
    JCNxBrowseData('oFhnPdtGroupBrowsOption');
} else {
    JCNxShowMsgSessionExpired();
}
});


// Option Add Browse Product Sub Class
var oFhnPdtGroupBrows = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tSesUsrAgnCode = '<?=$this->session->userdata("tSesUsrAgnCode")?>';

    var tConditionWhere = '';
        if(tSesUsrAgnCode!=''){
            tConditionWhere +=" AND ( TFHMPdtF4Group.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TFHMPdtF4Group.FTAgnCode,'') = '' ) ";
        }

    var oOptionReturn = {
        Title: ['product/product/product', 'tFhnPdtGroup'],
        Table: {
            Master: 'TFHMPdtF4Group',
            PK: 'FTPgpCode'
        },
        Join: {
                Table: ['TFHMPdtF4Group_L'],
                On: [
                    'TFHMPdtF4Group.FTPgpCode = TFHMPdtF4Group_L.FTPgpCode AND TFHMPdtF4Group_L.FNLngID = ' + nLangEdits,
                ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/product/product',
            ColumnKeyLang: ['tFhnPdtGroupCode', 'tFhnPdtGroupName'],
            ColumnsSize: ['20%', '80%'],
            DataColumns: ['TFHMPdtF4Group.FTPgpCode', 'TFHMPdtF4Group_L.FTPgpName'],
            DataColumnsFormat: ['', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TFHMPdtF4Group.FTPgpCode'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TFHMPdtF4Group.FTPgpCode"],
            Text: [tInputReturnName, "TFHMPdtF4Group_L.FTPgpName"],
        },
        // NextFunc: {
        //     FuncName: tNextFuncName,
        //     ArgReturn: ['FTEvnCode', 'FTEvnName']
        // },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}






// Click Browse Product Sub Class
$('#obFhnPdtComLinesBrows').click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    window.oFhnPdtComLinesBrowsOption = oFhnPdtComLinesBrows({
        'tReturnInputCode': 'oetFhnPdtComLinesCode',
        'tReturnInputName': 'oetFhnPdtComLinesName'
        // 'tNextFuncName': ''
    });
    JCNxBrowseData('oFhnPdtComLinesBrowsOption');
} else {
    JCNxShowMsgSessionExpired();
}
});


// Option Add Browse Product Sub Class
var oFhnPdtComLinesBrows = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tSesUsrAgnCode = '<?=$this->session->userdata("tSesUsrAgnCode")?>';

    var tConditionWhere = '';
        if(tSesUsrAgnCode!=''){
            tConditionWhere +=" AND ( TFHMPdtF5ComLines.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TFHMPdtF5ComLines.FTAgnCode,'') = '' ) ";
        }

    var oOptionReturn = {
        Title: ['product/product/product', 'tFhnPdtComLines'],
        Table: {
            Master: 'TFHMPdtF5ComLines',
            PK: 'FTCmlCode'
        },
        Join: {
                Table: ['TFHMPdtF5ComLines_L'],
                On: [
                    'TFHMPdtF5ComLines.FTCmlCode = TFHMPdtF5ComLines_L.FTCmlCode AND TFHMPdtF5ComLines_L.FNLngID = ' + nLangEdits,
                ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/product/product',
            ColumnKeyLang: ['tFhnPdtComLinesCode', 'tFhnPdtComLinesName'],
            ColumnsSize: ['20%', '80%'],
            DataColumns: ['TFHMPdtF5ComLines.FTCmlCode', 'TFHMPdtF5ComLines_L.FTCmlName'],
            DataColumnsFormat: ['', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TFHMPdtF5ComLines.FTCmlCode'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TFHMPdtF5ComLines.FTCmlCode"],
            Text: [tInputReturnName, "TFHMPdtF5ComLines_L.FTCmlName"],
        },
        // NextFunc: {
        //     FuncName: tNextFuncName,
        //     ArgReturn: ['FTEvnCode', 'FTEvnName']
        // },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}




// Click Browse Product Sub Class
$('#obFhnPdtSeasonBrows').unbind().click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    window.oFhnPdtSeasonBrowsOption = oFhnPdtSeasonBrows({
        'tReturnInputCode': 'oetFhnPdtSeasonCode',
        'tReturnInputName': 'oetFhnPdtSeasonName',
        'tNextFuncName': 'JSxFhnSrtRefCodeGenerate'
    });
    JCNxBrowseData('oFhnPdtSeasonBrowsOption');
} else {
    JCNxShowMsgSessionExpired();
}
});


// Option Add Browse Product Sub Class
var oFhnPdtSeasonBrows = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tSesUsrAgnCode = '<?=$this->session->userdata("tSesUsrAgnCode")?>';
    var tNextFuncName = poReturnInput.tNextFuncName;
    var tConditionWhere = '';
        if(tSesUsrAgnCode!=''){
            tConditionWhere +=" AND ( TFHMPdtSeason.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TFHMPdtSeason.FTAgnCode,'') = '' ) ";
        }

    var oOptionReturn = {
        Title: ['product/product/product', 'tFhnPdtDataTableSeason'],
        Table: {
            Master: 'TFHMPdtSeason',
            PK: 'FTSeaCode'
        },
        Join: {
                Table: ['TFHMPdtSeason_L'],
                On: [
                    'TFHMPdtSeason.FTSeaCode = TFHMPdtSeason_L.FTSeaCode AND TFHMPdtSeason.FTSeaChain = TFHMPdtSeason_L.FTSeaChain AND TFHMPdtSeason_L.FNLngID = ' + nLangEdits,
                ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/product/product',
            ColumnKeyLang: ['tFhnPdtDataTableSeasonCode', 'tFhnPdtDataTableSeasonName'],
            ColumnsSize: ['20%', '80%'],
            DataColumns: ['TFHMPdtSeason.FTSeaCode', 'TFHMPdtSeason_L.FTSeaName'],
            DataColumnsFormat: ['', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TFHMPdtSeason.FTSeaCode'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TFHMPdtSeason.FTSeaCode"],
            Text: [tInputReturnName, "TFHMPdtSeason_L.FTSeaName"],
        },
        NextFunc: {
            FuncName: tNextFuncName
        },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}



// Click Browse Product Sub Class
$('#obFhnPdtFabricBrows').unbind().click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    window.oFhnPdtFabricBrowsOption = oFhnPdtFabricBrows({
        'tReturnInputCode': 'oetFhnPdtFabricCode',
        'tReturnInputName': 'oetFhnPdtFabricName',
        'tNextFuncName': 'JSxFhnSrtRefCodeGenerate'
    });
    JCNxBrowseData('oFhnPdtFabricBrowsOption');
} else {
    JCNxShowMsgSessionExpired();
}
});


// Option Add Browse Product Sub Class
var oFhnPdtFabricBrows = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tSesUsrAgnCode = '<?=$this->session->userdata("tSesUsrAgnCode")?>';
    var tNextFuncName = poReturnInput.tNextFuncName;
    var tConditionWhere = '';
        if(tSesUsrAgnCode!=''){
            tConditionWhere +=" AND  ( TFHMPdtFabric.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TFHMPdtFabric.FTAgnCode,'') = '' ) ";
        }

    var oOptionReturn = {
        Title: ['product/product/product', 'tFhnPdtDataTableFabric'],
        Table: {
            Master: 'TFHMPdtFabric',
            PK: 'FTFabCode'
        },
        Join: {
                Table: ['TFHMPdtFabric_L'],
                On: [
                    'TFHMPdtFabric.FTFabCode = TFHMPdtFabric_L.FTFabCode AND TFHMPdtFabric_L.FNLngID = ' + nLangEdits,
                ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/product/product',
            ColumnKeyLang: ['tFhnPdtDataTableFabricCode', 'tFhnPdtDataTableFabricName'],
            ColumnsSize: ['20%', '80%'],
            DataColumns: ['TFHMPdtFabric.FTFabCode', 'TFHMPdtFabric_L.FTFabName'],
            DataColumnsFormat: ['', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TFHMPdtFabric.FTFabCode'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TFHMPdtFabric.FTFabCode"],
            Text: [tInputReturnName, "TFHMPdtFabric_L.FTFabName"],
        },
        NextFunc: {
            FuncName: tNextFuncName
        },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}




// Click Browse Product Sub Class
$('#obFhnPdtColorBrows').unbind().click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    window.oFhnPdtColorBrowsOption = oFhnPdtColorBrows({
        'tReturnInputCode': 'oetFhnPdtColorCode',
        'tReturnInputName': 'oetFhnPdtColorName',
        'tNextFuncName': 'JSxFhnSrtRefCodeGenerate'
    });
    JCNxBrowseData('oFhnPdtColorBrowsOption');
} else {
    JCNxShowMsgSessionExpired();
}
});


// Option Add Browse Product Sub Class
var oFhnPdtColorBrows = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tSesUsrAgnCode = '<?=$this->session->userdata("tSesUsrAgnCode")?>';
    var tNextFuncName = poReturnInput.tNextFuncName;
    var tConditionWhere = '';
        if(tSesUsrAgnCode!=''){
            tConditionWhere +=" AND  ( TCNMPdtColor.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TCNMPdtColor.FTAgnCode,'') = '' )";
        }

    var oOptionReturn = {
        Title: ['product/product/product', 'tFhnPdtDataTableColor'],
        Table: {
            Master: 'TCNMPdtColor',
            PK: 'FTClrCode'
        },
        Join: {
                Table: ['TCNMPdtColor_L'],
                On: [
                    'TCNMPdtColor.FTClrCode = TCNMPdtColor_L.FTClrCode AND TCNMPdtColor_L.FNLngID = ' + nLangEdits,
                ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/pdtcolor/pdtcolor',
            ColumnKeyLang: ['tCLRFrmClrCode', 'tCLRFrmClrName', 'tCLRFrmClrRmk'],
            ColumnsSize: ['20%', '60%','20%'],
            DataColumns: ['TCNMPdtColor.FTClrCode', 'TCNMPdtColor_L.FTClrName', 'TCNMPdtColor_L.FTClrRmk'],
            DataColumnsFormat: ['', '', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TCNMPdtColor.FTClrCode'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMPdtColor.FTClrCode"],
            Text: [tInputReturnName, "TCNMPdtColor_L.FTClrName"],
        },
        NextFunc: {
            FuncName: tNextFuncName
        },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}



// Click Browse Product Sub Class
$('#obFhnPdtSizeBrows').unbind().click(function() {
var nStaSession = JCNxFuncChkSessionExpired();
if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    window.oFhnPdtSizeBrowsOption = oFhnPdtSizeBrows({
        'tReturnInputCode': 'oetFhnPdtSizeCode',
        'tReturnInputName': 'oetFhnPdtSizeName',
        'tNextFuncName': 'JSxFhnSrtRefCodeGenerate'
    });
    JCNxBrowseData('oFhnPdtSizeBrowsOption');
} else {
    JCNxShowMsgSessionExpired();
}
});


// Option Add Browse Product Sub Class
var oFhnPdtSizeBrows = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tSesUsrAgnCode = '<?=$this->session->userdata("tSesUsrAgnCode")?>';
    var tNextFuncName = poReturnInput.tNextFuncName;
    var tConditionWhere = '';
        if(tSesUsrAgnCode!=''){
            tConditionWhere +=" AND  ( TCNMPdtSize.FTAgnCode = '"+tSesUsrAgnCode+"' OR ISNULL(TCNMPdtSize.FTAgnCode,'') = '' ) ";
        }

    var oOptionReturn = {
        Title: ['product/product/product', 'tFhnPdtDataTableSize'],
        Table: {
            Master: 'TCNMPdtSize',
            PK: 'FTPszCode'
        },
        Join: {
                Table: ['TCNMPdtSize_L'],
                On: [
                    'TCNMPdtSize.FTPszCode = TCNMPdtSize_L.FTPszCode AND TCNMPdtSize_L.FNLngID = ' + nLangEdits,
                ]
        },
        Where: {
            Condition: [tConditionWhere]
        },
        GrideView: {
            ColumnPathLang: 'product/product/product',
            ColumnKeyLang: ['tFhnPdtDataTableSizeCode', 'tFhnPdtDataTableSizeName'],
            ColumnsSize: ['20%', '80%'],
            DataColumns: ['TCNMPdtSize.FTPszCode', 'TCNMPdtSize_L.FTPszName'],
            DataColumnsFormat: ['', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TCNMPdtSize.FTPszCode'],
            SourceOrder: "DESC"
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMPdtSize.FTPszCode"],
            Text: [tInputReturnName, "TCNMPdtSize_L.FTPszName"],
        },
        NextFunc: {
            FuncName: tNextFuncName,
        },
        // RouteAddNew: 'productNoSaleEvent',
        BrowseLev: 1
    }
    return oOptionReturn;
}
</script>