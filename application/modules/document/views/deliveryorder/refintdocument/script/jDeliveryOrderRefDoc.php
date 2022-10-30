<script>
$(document).ready(function(){

    $('.selectpicker').selectpicker('refresh');

    $('.xCNDatePicker').datepicker({
            format: "yyyy-mm-dd",
            todayHighlight: true,
            enableOnReadonly: false,
            disableTouchKeyboard : true,
            autoclose: true
    });

    $('#obtDOBrowseBchRefIntDoc').click(function(){ 
        $('#odvDOModalRefIntDoc').modal('hide');
        var nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                window.oDOBrowseRefBranchOption  = undefined;
                oDOBrowseRefBranchOption         = oBranchRefOption({
                    'tReturnInputCode'  : 'oetDORefIntBchCode',
                    'tReturnInputName'  : 'oetDORefIntBchName',
                    'tNextFuncName'     : 'JSxDORefIntNextFunctBrowsBranch',
                    'tAgnCode'          : $('#oetDOAgnCode').val(),
                    'aArgReturn'        : ['FTBchCode','FTBchName','FTWahCode','FTWahName'],
                });
                JCNxBrowseData('oDOBrowseRefBranchOption');
            }else{
                JCNxShowMsgSessionExpired();
            }

    });

    // ตัวแปร Option Browse Modal สาขา
    var oBranchRefOption = function(poDataFnc){
            var tInputReturnCode    = poDataFnc.tReturnInputCode;
            var tInputReturnName    = poDataFnc.tReturnInputName;
            var tNextFuncName       = poDataFnc.tNextFuncName;
            var aArgReturn          = poDataFnc.aArgReturn;
            var tAgnCode            = poDataFnc.tAgnCode;
            
            tUsrLevel = "<?=$this->session->userdata('tSesUsrLevel')?>";
            tBchMulti = "<?=$this->session->userdata("tSesUsrBchCodeMulti"); ?>";
            tSQLWhere = "";
            if(tUsrLevel != "HQ"){
                tSQLWhere = " AND TCNMBranch.FTBchCode IN ("+tBchMulti+") ";
            }

            if(tAgnCode!=''){
                tSQLWhere = " AND TCNMBranch.FTAgnCode ='"+tAgnCode+"' ";
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
                    DisabledColumns     : [2,3],
                    WidthModal          : 30,
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


    $('#obtDOBrowseRefExtDocDateFrm').unbind().click(function(){
        $('#oetDORefIntDocDateFrm').datepicker('show');
    });


    $('#obtDOBrowseRefExtDocDateTo').unbind().click(function(){
        $('#oetDORefIntDocDateTo').datepicker('show');
    });

    JSxRefIntDocHDDataTable();
});


$('#odvDOModalRefIntDoc').on('hidden.bs.modal', function () {
    $('#wrapper').css('overflow','auto');
    $('#odvDOModalRefIntDoc').css('overflow','auto');
 
});

$('#odvDOModalRefIntDoc').on('show.bs.modal', function () {
    $('#wrapper').css('overflow','hidden');
    $('#odvDOModalRefIntDoc').css('overflow','auto');
});

function JSxDORefIntNextFunctBrowsBranch(ptData){
    JSxCheckPinMenuClose();
    $('#odvDOModalRefIntDoc').modal("show");
}

$('#obtRefIntDocFilter').on('click',function(){
    JSxRefIntDocHDDataTable();
});

//เรียกตารางเลขที่เอกสารอ้างอิง
function JSxRefIntDocHDDataTable(pnPage){
    if(pnPage == '' || pnPage == null){
            var pnNewPage = 1;
        }else{
            var pnNewPage = pnPage;
        }
        var nPageCurrent = pnNewPage;
        var tDORefIntBchCode  = $('#oetDORefIntBchCode').val();
        var tDORefIntDocNo  = $('#oetDORefIntDocNo').val();
        var tDORefIntDocDateFrm  = $('#oetDORefIntDocDateFrm').val();
        var tDORefIntDocDateTo  = $('#oetDORefIntDocDateTo').val();
        var tDORefIntStaDoc  = $('#oetDORefIntStaDoc').val();
        var tDODocType  = $('#ohdDocType').val();
        var tDOSplCode  = $('#oetDOFrmSplCode').val();
        var tNotinRef = $('#oetDORefNotin').val();
        // JCNxOpenLoading();
        $.ajax({
            type: "POST",
            url: "docDOCallRefIntDocDataTable",
            data: {
                'tDORefIntBchCode'     : tDORefIntBchCode,
                'tDORefIntDocNo'       : tDORefIntDocNo,
                'tDORefIntDocDateFrm'  : tDORefIntDocDateFrm,
                'tDORefIntDocDateTo'   : tDORefIntDocDateTo,
                'tDORefIntStaDoc'      : tDORefIntStaDoc,
                'nDORefIntPageCurrent' : nPageCurrent,
                'tDODocType'           : tDODocType,
                'tDOSplCode'           : tDOSplCode,
                'tNotinRef'           : tNotinRef
            },
            cache: false,
            Timeout: 0,
            success: function (oResult){
                 $('#odvRefIntDocHDDataTable').html(oResult);
                 JCNxCloseLoading();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                // JSxRefIntDocHDDataTable(pnPage)
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });

}


</script>