<script type="text/javascript">
    $(document).ready(function(){
        var nLangEdits  = '<?php echo $this->session->userdata("tLangEdit");?>';

        $('.selectpicker').selectpicker('refresh');
        
        $('.xCNDatePicker').datepicker({
            format: "yyyy-mm-dd",
            todayHighlight: true,
            enableOnReadonly: false,
            startDate :'1900-01-01',
            disableTouchKeyboard : true,
            autoclose: true
        });

        $('.xCNTimePicker').datetimepicker({format: 'HH:mm:ss'});


            // =============================== Check Box Auto GenCode ==============================
        $('#ocbDPYStaAutoGenCode').on('change', function (e) {
        if($('#ocbDPYStaAutoGenCode').is(':checked')){
            $("#oetDPYDocNo").val('');
            $("#oetDPYDocNo").attr("readonly", true);
            $('#oetDPYDocNo').closest(".form-group").css("cursor","not-allowed");
            $('#oetDPYDocNo').css("pointer-events","none");
            $("#oetDPYDocNo").attr("onfocus", "this.blur()");
            $('#ofmDPYFormAdd').removeClass('has-error');
            $('#ofmDPYFormAdd .form-group').closest('.form-group').removeClass("has-error");
            $('#ofmDPYFormAdd em').remove();
        }else{
            $('#oetDPYDocNo').closest(".form-group").css("cursor","");
            $('#oetDPYDocNo').css("pointer-events","");
            $('#oetDPYDocNo').attr('readonly',false);
            $("#oetDPYDocNo").removeAttr("onfocus");
        }
        });
        // =====================================================================================



      
        $("#oetDPYSearchPdtHTML").on("keyup", function() {
            var value = $(this).val().toLowerCase();
            $("#otbConditionDPYApp tr").filter(function() {
            $(this).toggle($(this).children().val().toLowerCase().indexOf(value) > -1)
            });
        });
      

    });



    $('#obtTabConditionDPYBch').unbind().click(function(){
    var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                $('#oetRddAgnCodeTo').val('');
                $('#oetRddAgnNameTo').val('');
                $('#oetRddBchCodeTo').val('');
                $('#oetRddBchNameTo').val('');
                $('#oetRddPosCodeTo').val('');
                $('#oetRddPosNameTo').val('');
                $('#oetRddShpCodeTo').val('');
                $('#oetRddShpNameTo').val('');
                $("#odvDPYCRModalBch").modal({backdrop: "static", keyboard: false});
                $("#odvDPYCRModalBch").modal({show: true});
        }else{
            JCNxShowMsgSessionExpired();
        }
    });


  /*
      * Functionality : Crete Array javascript
      * Parameters : 
      * Creator : 13/02/2020 nattakit(nale)
      * Last Modified : -
      * Return : -
      * Return Type : -
      */  

      function JSxCreateArray(length) {
        var arr = new Array(length || 0),
            i = length;
    
        if (arguments.length > 1) {
            var args = Array.prototype.slice.call(arguments, 1);
            while(i--) arr[length-1 - i] = JSxCreateArray.apply(this, args);
        }
    
        return arr;
    }


    $('#obtRddCreateBch').unbind().click(function(){
    var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxConsAppendRowAndCheckDuplicateDataBch();
        }else{
            JCNxShowMsgSessionExpired();
        }
    });



    function JSnDPYBchDuplicate(paData){


            let nLenIn = $('input[name^="ohdDPYBchCode["]').length
            let aEchDataIn = JSxCreateArray(nLenIn,4);
            //Include
            $('input[name^="ohdDPYAgnCode["]').each(function(index){
                let tAgnCode = $(this).val();
                aEchDataIn[index][0]=tAgnCode;
            });
            $('input[name^="ohdDPYBchCode["]').each(function(index){
                let tBchCode = $(this).val();
                aEchDataIn[index][1]=tBchCode;
            });
            $('input[name^="ohdDPYPosCode["]').each(function(index){
                let tPosCode = $(this).val();
                aEchDataIn[index][2]=tPosCode;
            });
            // $('input[name^="ohdDPYShpCode["]').each(function(index){
            //     let tShpCode = $(this).val();
            //     aEchDataIn[index][3]=tShpCode;
            // });


            // console.log("aEchDataIn",aEchDataIn);
            // console.log("aEchDataEx",aEchDataEx);

            let nAproveAppend = 0;
            for(i=0;i<aEchDataIn.length;i++){
                if(aEchDataIn[i][0]==paData.tRddAgnCodeTo && aEchDataIn[i][1]==paData.tRddBchCodeTo && aEchDataIn[i][2]==paData.tRddPosCodeTo){
                    nAproveAppend++;
                }
            }

            // console.log(nAproveAppend);
            return nAproveAppend;
    }


/*===== Begin Event Next Function Browse ========================================== */
// Functionality : 
// Parameter : Event Next Func Modal
// Create : 11/02/2020 Nattakit(Nale)
// Return : Set Element And value
// Return Type : -
function JSxConsAppendRowAndCheckDuplicateDataBch(){


        let nRddBchModalType = $('#ocmRddBchModalType').val();
        var tRddBchModalTypeText = $("#ocmRddBchModalType option:selected").html();
        let tRddAgnCodeTo      = $('#oetRddAgnCodeTo').val();
        let tRddAgnNameTo      = $('#oetRddAgnNameTo').val();
        let tRddBchCodeTo      = $('#oetRddBchCodeTo').val();
        let tRddBchNameTo      = $('#oetRddBchNameTo').val();
        let tRddPosCodeTo      = $('#oetRddPosCodeTo').val();
        let tRddPosNameTo      = $('#oetRddPosNameTo').val();
        // let tRddShpCodeTo      = $('#oetRddShpCodeTo').val();
        // let tRddShpNameTo      = $('#oetRddShpNameTo').val();
        // console.log(aData);
        let aDataApr = { 
                     tRddAgnCodeTo:tRddAgnCodeTo,
                     tRddAgnNameTo:tRddAgnNameTo,
                     tRddBchCodeTo:tRddBchCodeTo,
                     tRddBchNameTo:tRddBchNameTo,
                     tRddPosCodeTo:tRddPosCodeTo,
                     tRddPosNameTo:tRddPosNameTo,
                    //  tRddShpCodeTo:tRddShpCodeTo,
                    //  tRddShpNameTo:tRddShpNameTo,
                     }

      let nAproveSta = JSnDPYBchDuplicate(aDataApr);
      let nLenIn = $('input[name^="ohdDPYBchCode["]').length + 1;
     if(nAproveSta==0){
        $('#otrRemoveTrBch').remove();
      var tMarkUp =  '';
      var i = Date.now();
      tMarkUp +="<tr class='otrInclude' id='otrRddBchRowID"+i+"'>";
                tMarkUp +="<td align='center' class='otdColRowID_Bch' >"+nLenIn+"</td>";
                tMarkUp +="<td >"+tRddBchModalTypeText+"</td>";
                tMarkUp +="<td>";
                tMarkUp +="<input type='hidden' name='ohdDPYAgnCode["+i+"]' class='ohdDPYAgnCode' tRddAgnName='"+aDataApr.tRddAgnNameTo+"' value='"+aDataApr.tRddAgnCodeTo+"'>";
                tMarkUp +="<input type='hidden' name='ohdDPYBchCode["+i+"]' class='ohdDPYBchCode' tRddBchName='"+aDataApr.tRddBchNameTo+"' value='"+aDataApr.tRddBchCodeTo+"'>";
                tMarkUp +="<input type='hidden' name='ohdDPYPosCode["+i+"]' class='ohdDPYPosCode' tRddPosName='"+aDataApr.tRddPosNameTo+"' value='"+aDataApr.tRddPosCodeTo+"'>";
                //tMarkUp +="<input type='hidden' name='ohdDPYShpCode["+i+"]' class='ohdDPYShpCode' tRddShpName='"+aDataApr.tRddShpNameTo+"' value='"+aDataApr.tRddShpCodeTo+"'>";
                tMarkUp +="<input type='hidden' name='ohdRddBchModalType["+i+"]' class='ohdRddBchModalType' value='"+nRddBchModalType+"'>";
                tMarkUp +=aDataApr.tRddAgnNameTo+"</td>";
                tMarkUp +="<td>"+aDataApr.tRddBchNameTo+"</td>";
                tMarkUp +="<td>"+aDataApr.tRddPosNameTo+"</td>";
                tMarkUp +="<td align='center'><img onclick='JSxRddBchRemoveRow("+i+")' class='xCNIconTable xCNIconDel' src='<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>' ></td>";
                tMarkUp +="</tr>";

            $('#otbConditionDPYBch').append(tMarkUp);
            $('#odvDPYCRModalBch').modal('hide');
        }else{

         alert('Data Select Duplicate.');

        }

        JSxDPYHideRowWhnNotFound();
}

function JSxRddBchRemoveRow(ptCode){

    $('#otrRddBchRowID'+ptCode).remove();

    $('.otdColRowID_Bch').each(function(index){
    
     $(this).text(index+1);

    });
    JSxDPYHideRowWhnNotFound();

}

function JSxDPYHideRowWhnNotFound(ptCode){
    if($('.otrInclude').length==0){
        $('#otbItemNotFound').show();
    }else{
        $('#otbItemNotFound').hide();
    }
    
}


$('#obtCPHBrowseAgnTo').unbind().click(function(){
    var nStaSession = JCNxFuncChkSessionExpired();
    if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oRddAgencyOptionTo   = undefined;
        oRddAgencyOptionTo          = oRddAgencyOption({
            'tReturnInputCode'  : 'oetRddAgnCodeTo',
            'tReturnInputName'  : 'oetRddAgnNameTo',
    
        });
        JCNxBrowseData('oRddAgencyOptionTo');
    }else{
        JCNxShowMsgSessionExpired();
    }
});


$('#obtRddBrowseBchTo').unbind().click(function(){
    var nStaSession = JCNxFuncChkSessionExpired();
    if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oRddBranchOptionTo   = undefined;
        oRddBranchOptionTo          = oRddBranchOption({
            'tReturnInputCode'  : 'oetRddBchCodeTo',
            'tReturnInputName'  : 'oetRddBchNameTo',
            'tNextFuncName'     : 'JSxRddConsNextFuncBrowseBch',
            'aArgReturn'    : ['FTBchCode','FTBchName']
        });
        JCNxBrowseData('oRddBranchOptionTo');
    }else{
        JCNxShowMsgSessionExpired();
    }
});


$('#obtRddBrowseMerTo').unbind().click(function(){
    var nStaSession = JCNxFuncChkSessionExpired();
    if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oRddMerChantOptionTo = undefined;
        oRddMerChantOptionTo        = oRddMerChantOption({
            'tReturnInputCode'  : 'oetRddMerCodeTo',
            'tReturnInputName'  : 'oetRddMerNameTo',
            'tNextFuncName'     : 'JSxRddConsNextFuncBrowseMerChant',
            // 'aArgReturn'        : ['FTMerCode','FTMerName']
        });
        JCNxBrowseData('oRddMerChantOptionTo');
    }else{
        JCNxShowMsgSessionExpired();
    }
});


$('#obtRddBrowsePosTo').unbind().click(function(){
    var nStaSession = JCNxFuncChkSessionExpired();
    if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
        JSxCheckPinMenuClose(); // Hidden Pin Menu

        let tRddBranchForm  = $('#oetRddBchCodeTo').val();
        let tRddBranchTo    = $('#oetRddBchCodeTo').val();
        window.oRddPosOptionTo = undefined;
        oRddPosOptionTo        = oRddPosOption({
            'tReturnInputCode'  : 'oetRddPosCodeTo',
            'tReturnInputName'  : 'oetRddPosNameTo',
            'tRddBranchForm'    : tRddBranchForm,
            'tRddBranchTo'      : tRddBranchTo,
            'tNextFuncName'     : 'JSxRddConsNextFuncBrowsePos',
 
        });
        JCNxBrowseData('oRddPosOptionTo');
    }else{
        JCNxShowMsgSessionExpired();
    }
});



      
//เลือกสาขา
var oRddAgencyOption = function(poReturnInput) {
    var tInputReturnCode = poReturnInput.tReturnInputCode;
    var tInputReturnName = poReturnInput.tReturnInputName;
    var tBchCodeWhere = poReturnInput.tBchCodeWhere;

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
        BrowseLev: 0,
        NextFunc: {
            FuncName: 'JSxClearBrowseConditionAgn',
            ArgReturn: ['FTAgnCode']
        }
    }
    return oOptionReturn;
}

function JSxClearBrowseConditionAgn(ptData) {
    // aData = JSON.parse(ptData);
    if (ptData != '' || ptData != 'NULL') {

        $('#oetRddBchCodeTo').val('');
        $('#oetRddBchNameTo').val('');
        $('#oetRddPosCodeTo').val('');
        $('#oetRddPosNameTo').val('');
        $('#oetRddMerCodeTo').val('');
        $('#oetRddMerNameTo').val('');

    }
}



  /*===== Begin Browse Option ======================================================= */
  var oRddBranchOption = function(poRddReturnInputBch){
    let tRddNextFuncNameBch    = poRddReturnInputBch.tNextFuncName;
    let aRddArgReturnBch       = poRddReturnInputBch.aArgReturn;
    let tRddInputReturnCodeBch = poRddReturnInputBch.tReturnInputCode;
    let tRddInputReturnNameBch = poRddReturnInputBch.tReturnInputName;

    var tUsrLevel     = "<?php echo $this->session->userdata("tSesUsrLevel"); ?>";
    var tBchCodeMulti = "<?php echo $this->session->userdata("tSesUsrBchCodeMulti"); ?>";
    var nCountBch     = "<?php echo $this->session->userdata("nSesUsrBchCount"); ?>";
    var tMerCode = $('#oetRddMerCodeTo').val();
    var tWhere = "";

    if(nCountBch == 1){
        $('#obtRddBrowseBchTo').attr('disabled',true);
    }
    // if(tUsrLevel != "HQ"){
    //     tWhere += " AND TCNMBranch.FTBchCode IN ("+tBchCodeMulti+") ";
    // }else{
    //     tWhere += "";
    // }

   var tRddAgnCodeTo =  $('#oetRddAgnCodeTo').val();
   if(tRddAgnCodeTo!=''){
         tWhere += " AND TCNMBranch.FTAgnCode ='"+tRddAgnCodeTo+"' ";
   }
    // if(tMerCode!=''){
    //     tWhere += " AND TCNMBranch.FTMerCode = '"+tMerCode+"' ";
    // }

    let oRddOptionReturnBch    = {
        Title: ['company/branch/branch','tBCHTitle'],
        Table:{Master:'TCNMBranch',PK:'FTBchCode'},
        Join :{
            Table:	['TCNMBranch_L'],
            On:['TCNMBranch_L.FTBchCode = TCNMBranch.FTBchCode AND TCNMBranch_L.FNLngID = '+nLangEdits]
        },
        Where : {
                    Condition : [tWhere]
                },
        GrideView:{
            ColumnPathLang	: 'company/branch/branch',
            ColumnKeyLang	: ['tBCHCode','tBCHName'],
            ColumnsSize     : ['15%','75%'],
            WidthModal      : 50,
            DataColumns		: ['TCNMBranch.FTBchCode','TCNMBranch_L.FTBchName'],
            DataColumnsFormat : ['',''],
            Perpage			: 10,
            OrderBy			: ['TCNMBranch_L.FTBchCode ASC'],
        },
        CallBack:{
            ReturnType	: 'S',
            Value		: [tRddInputReturnCodeBch,"TCNMBranch.FTBchCode"],
            Text		: [tRddInputReturnNameBch,"TCNMBranch_L.FTBchName"]
        },
        NextFunc : {
            FuncName    : tRddNextFuncNameBch,
            ArgReturn   : aRddArgReturnBch
        },
        RouteAddNew: 'branch',
        BrowseLev: 0
    };
    return oRddOptionReturnBch;
};


// Browse Merchant Option
var oRddMerChantOption  = function(poReturnInputMer){
    let tMerInputReturnCode = poReturnInputMer.tReturnInputCode;
    let tMerInputReturnName = poReturnInputMer.tReturnInputName;
    let tMerNextFuncName    = poReturnInputMer.tNextFuncName;
    let aMerArgReturn       = poReturnInputMer.aArgReturn;
    let oMerOptionReturn    = {
        Title: ['company/merchant/merchant','tMerchantTitle'],
        Table: {Master:'TCNMMerchant',PK:'FTMerCode'},
        Join: {
            Table: ['TCNMMerchant_L'],
            On: ['TCNMMerchant.FTMerCode = TCNMMerchant_L.FTMerCode AND TCNMMerchant_L.FNLngID = '+nLangEdits]
        },
        GrideView: {
            ColumnPathLang	: 'company/merchant/merchant',
            ColumnKeyLang	: ['tMerCode','tMerName'],
            ColumnsSize     : ['15%','75%'],
            WidthModal      : 50,
            DataColumns		: ['TCNMMerchant.FTMerCode','TCNMMerchant_L.FTMerName'],
            DataColumnsFormat : ['',''],
            Perpage			: 5,
            OrderBy			: ['TCNMMerchant.FTMerCode ASC'],
        },
        CallBack: {
            ReturnType	: 'S',
            Value		: [tMerInputReturnCode,"TCNMMerchant.FTMerCode"],
            Text		: [tMerInputReturnName,"TCNMMerchant_L.FTMerName"],
        },
        NextFunc : {
            FuncName    : tMerNextFuncName,
            // ArgReturn   : aMerArgReturn
        },
        RouteAddNew: 'merchant',
        BrowseLev: 0,
    };
    return oMerOptionReturn;
}



// Browse Shop Option
var oRddPosOption = function(poReturnInputShp){
    let tShpNextFuncName        = poReturnInputShp.tNextFuncName;
    let aShpArgReturn           = poReturnInputShp.aArgReturn;
    let tShpInputReturnCode     = poReturnInputShp.tReturnInputCode;
    let tShpInputReturnName     = poReturnInputShp.tReturnInputName;
   
    let tShpRddBranchForm       = poReturnInputShp.tRddBranchForm;
    let tShpRddBranchTo         = poReturnInputShp.tRddBranchTo;
    let tShpWhereShop           = "";
    let tShpWhereShopAndBch     = "";

  
    if(tShpRddBranchTo!=''){
        var tConditionWhere = " AND TCNMPos.FTBchCode = '"+tShpRddBranchTo+"' ";
    }else{
        var tConditionWhere = "";
    }

    let oSMTSALBrowsePosOption          = {
                    Title       : ["pos/salemachine/salemachine","tPOSTitle"],
                    Table       : { Master:'TCNMPos', PK:'FTPosCode'},
                    Join    : {
                        Table   : ['TCNMPos_L'],
                        On      : [
                            'TCNMPos.FTPosCode = TCNMPos_L.FTPosCode AND TCNMPos.FTBchCode = TCNMPos_L.FTbchCode AND TCNMPos_L.FNLngID = '+nLangEdits
                        ]
                    },
                    Where   : {
                        Condition : [tConditionWhere]
                    },
                    GrideView   : {
                        ColumnPathLang  : 'pos/salemachine/salemachine',
                        ColumnKeyLang   : ['tPOSCode','tPOSRegNo'],
                        ColumnsSize     : ['10%','80%'],
                        WidthModal      : 50,
                        DataColumns     : ["TCNMPos.FTPosCode","TCNMPos_L.FTPosName"],
                        DataColumnsFormat : ['',''],
                        Perpage			: 10,
                        OrderBy         : ['TCNMPos.FTPosCode ASC'],
                    },
                    NextFunc:{
                        FuncName:'JSxDRGSetBrowsPos',
                        ArgReturn:['FTPosCode']
                    },
                    CallBack    : {
                        ReturnType	: 'S',
                        Value       : [tShpInputReturnCode,"TCNMPos.FTPosCode"],
                        Text        : [tShpInputReturnName,"TCNMPos_L.FTPosName"]
                    }
                };
    return oSMTSALBrowsePosOption;
};


 
/*===== Begin Event Next Function Browse ========================================== */
// Functionality : Next Function Branch And Check Data Shop And Clear Data
// Parameter : Event Next Func Modal
// Create : 30/09/2019 Wasin(Yoshi)
// update : 03/10/2019 Saharat(Golf)
// Return : Clear Velues Data
// Return Type : -
function JSxRddConsNextFuncBrowseBch(poDataNextFunc){
    console.log(poDataNextFunc);
    if( (typeof(poDataNextFunc) !== 'undefined' && poDataNextFunc != 'NULL')){
        $('#oetRddPosCodeTo').val('');
        $('#oetRddPosNameTo').val('');
        $('#obtRddBrowsePosTo').attr('disabled',false);
    }else{
        $('#obtRddBrowsePosTo').attr('disabled',true);
    }
}





// Functionality : Next Function Shop And Check Data Pos And Clear Data
// Parameter : Event Next Func Modal
// Create : 30/09/2019 Wasin(Yoshi)
// update : 03/10/2019 Sahart(Golf)
// Return : Clear Velues Data
// Return Type : -
function JSxRddConsNextFuncBrowsePos(poDataNextFunc){



}


 // Functionality : Next Function MerChant And Check Data 
// Parameter : Event Next Func Modal
// Create : 04/10/2019 Saharat(Golf)
// Return : Clear Velues Data
// Return Type : -
function  JSxRddConsNextFuncBrowseMerChant(poDataNextFunc){

    // if(typeof(poDataNextFunc) != 'undefined' && poDataNextFunc != "NULL"){
    //     let aDataNextFunc   = JSON.parse(poDataNextFunc);
    //     tMerCode      = aDataNextFunc[0];
    //     tMerName      = aDataNextFunc[1];
    // }


    // if((typeof(tMerCode) !== 'undefined' && tMerCode == "")){
    //    $('#oetRddMerCodeTo').val('');
    //    $('#oetRddMerNameTo').val('');  
    // }

    // ประกาศตัวแปร กลุ่มธุรกิจ
    var tRddMerCodeTo,tRddPdtNameTo
    tRddMerCodeTo   = $('#oetRddMerCodeTo').val();
    tRddMerNameTo   = $('#oetRddMerNameTo').val();

    // เช็คข้อมูลถ้ามีการ Browse จากกลุ่มธุรกิจ ให้ default ถึงกลุ่มธุรกิจ เป็นข้อมูลเดียวกัน 
    if( (typeof(tRddMerCodeTo) !== 'undefined' && tRddMerCodeTo == "")){
        $('#oetRddMerCodeTo').val(tMerCode);
        $('#oetRddMerNameTo').val(tMerName);
        $('#oetRddBchCodeTo').val('');
        $('#oetRddBchNameTo').val('');
        $('#oetRddShpCodeTo').val('');
        $('#oetRddShpNameTo').val('');
    }


}   




$('#obtDPYAddApp').unbind().click(function(){

            JSxDPYAppAddRow();
     
    });


function JSxDPYAppAddRow(){

    let nLenIn = $('input[name^="oetDPTAppCode["]').length + 1;
    var tMarkUp =  '';
      var i = Date.now();
                tMarkUp +="<tr class='otrDPYApp' id='otrDPYAppRowID"+i+"'>";
                tMarkUp +="<td align='center' class='otdColRowID_App' >"+nLenIn+"</td>";
                tMarkUp +="<td ><input type='text' name='oetDPTAppCode["+i+"]' class='oetDPTAppCode form-control' maxlength='50' ></td>";
                tMarkUp +="<td ><input type='text' name='oetDPTAppVersion["+i+"]' class='oetDPTAppVersion' maxlength='50' value=''></td>";
                tMarkUp +="<td ><input type='text' name='oetDPTAppPath["+i+"]' class='oetDPTAppPath' maxlength='100' value=''></td>";
                tMarkUp +="<td align='center'><img onclick='JSxDPYAppRemoveRow("+i+")' class='xCNIconTable xCNIconDel' src='<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>' ></td>";
                tMarkUp +="</tr>";

    $('#otbConditionDPYApp').append(tMarkUp);
    JSxDPYAppHideRowWhnNotFound();
}


function JSxDPYAppRemoveRow(ptCode){

    $('#otrDPYAppRowID'+ptCode).remove();

    $('.otdColRowID_App').each(function(index){

    $(this).text(index+1);

    });
    JSxDPYAppHideRowWhnNotFound();

}

function JSxDPYAppHideRowWhnNotFound(ptCode){

    if($('.otrDPYApp').length==0){
        $('#otbAppItemNotFound').show();
    }else{
        $('#otbAppItemNotFound').hide();
    }

}



$('#obtDPYSubmitFrom').unbind().click(function() {

    var nValidateDocDT = 0;

    $('input[name^="oetDPTAppCode["]').each(function(){
        if($(this).val()==''){
            nValidateDocDT++;
        }
    });

    $('input[name^="oetDPTAppVersion["]').each(function(){
        if($(this).val()==''){
            nValidateDocDT++;
        }
    });

    $('input[name^="oetDPTAppPath["]').each(function(){
        if($(this).val()==''){
            nValidateDocDT++;
        }
    });

    if($('#oetDPYDocNo').val()=='' && $('#ocbDPYStaAutoGenCode').prop('checked')==false){
        FSvCMNSetMsgWarningDialog('กรุณาระบุเลขที่เอกสาร');
        return;
    }

    if($('.otrDPYApp').length==0){
        FSvCMNSetMsgWarningDialog('กรุณาเพิ่มรายการอัพเกรดอย่างน้อย 1 รายการ');
        return;
    }

    if(nValidateDocDT>0){
        FSvCMNSetMsgWarningDialog('กรุณาระบุรายการอัพเกรดให้ครบถ้วน');
        return;
    }

    if($('#oetDPYDepName').val()==''){
        FSvCMNSetMsgWarningDialog('กรุณาระบุชื่อรอบการอัพเกรด');
        return;
    }

    if($('#oetDPYZipUrl').val()==''){
        FSvCMNSetMsgWarningDialog('กรุณาระบุลิงค์ดาวน์โหลดไฟล์อัพเกรด');
        return;
    }

    if($('.xTableDnDTCNTAppDepHDodvDPYShowDataTable').length==0){
        if(confirm('คุณยังไม่มีไฟลแนบสำหรับ Readme.txt ต้องการดำเนินการต่อหรือไม่')==false){
            return;
        }
       
    }

    JSxDPYEventAddFrm();
   
});


function JSxDPYEventAddFrm(){
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof nStaSession !== "undefined" && nStaSession == 1) {
        var tRouteEvent = $('#oetDPYRoute').val();
        $.ajax({
            type: "POST",
            url:  tRouteEvent,
            data: $("#ofmDPYFormAdd").serialize(),
            cache: false,
            timeout: 0,
            success: function(tResult) {
                    var aReturn = JSON.parse(tResult);
                    if (aReturn["nStaEvent"] == 1) {
                        var oDPYCallDataTableFile = {
                                ptElementID : 'odvDPYShowDataTable',
                                ptBchCode   : 'tool_deploy',
                                ptDocNo     : aReturn['tCodeReturn'],
                                ptDocKey    :'TCNTAppDepHD',
                            }
                            JCNxUPFInsertDataFile(oDPYCallDataTableFile);

                        JSvDPYCallPageEdit(aReturn['tCodeReturn']);
                    } else {
                        tMessageError = aReturn['tStaMessg'];
                        FSvCMNSetMsgWarningDialog(tMessageError);
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




function JSxDPYOpenImportForm(){
          // Create By : Napat(Jame) 2021/06/15
    // แก้ปัญหาโหลด template แคชไฟล์
    var dDate           = new Date();
    var nDay            = dDate.getDate();
    var nMonth          = dDate.getMonth();
    var nYear           = dDate.getFullYear();
    var nTime           = dDate.getTime();
    var tFormatVersion  = nYear.toString() + nMonth.toString() + nDay.toString() + nTime.toString();
    var tPathTemplate = $('#ohdBaseUrlUseInJS').val() + 'application/modules/common/assets/template/Deploy_Template.xlsx?v=' + tFormatVersion;

    //สั้งให้ pop-up โชว์
    $('#odvDPYModalImportFile').modal('show');
            //ถ้าเป็น Type : document
    $('#odvDPYModalImportFile .modal-dialog').css({
        'width' : '800px', 
        'top'   : '20%'
    });
    $('#odvDPYModalImportFile #oahDPYDowloadTemplate').attr("href",tPathTemplate);
    $("#odvDPYModalImportFile .modal-body").removeAttr("style");
    $('#odvDPYContentRenderHTMLImport').html('<div style="text-align: center; margin-top: 50px; margin-bottom: 50px;"><label>'+$('#ohdDPYImportExcel').val()+'</label></div>');

    // $('#oetDPYFileNameImport').val('');
}







    //Import File
function JSxDPYCheckFileImportFile(poElement, poEvent) {
    try {
        var oFile = $(poElement)[0].files[0];
        if(oFile == undefined){
            $("#oetDPYFileNameImport").val("");
        }else{
            $("#oetDPYFileNameImport").val(oFile.name);
        }
        
    } catch (err) {
        console.log("JSxPromotionStep1SetImportFile Error: ", err);
    }
}


//กดปุ่มยืนยัน
function JSxDPYImportFileExcel(){
    $('#ospDPYTextSummaryImport').text('');

    var tNameFile = $("#oetDPYFileNameImport").val();
    if(tNameFile == '' || tNameFile == null){
        //ไม่พบไฟล์
    }else{
    
            $('#odvDPYContentRenderHTMLImport').html('<div style="text-align: center; margin-top: 50px; margin-bottom: 50px;"><label>กำลังนำเข้าไฟล์...</label></div>');
        
        setTimeout(function(){
            JSxDPYWirteImportFile();
        }, 50);
    }
}

function JSxDPYWirteImportFile(evt) {
    var f = $('#oefDPYFileImportExcel')[0].files[0];
    if (f) {
        var r = new FileReader();
        r.onload = e => {
            var contents 	= processExcel(e.target.result);
            var aJSON 		= JSON.parse(contents);

        //ตรวจสอบชื่อชิทว่าถูกต้องไหม
        if(typeof(aJSON['HD']) == 'undefined'){
            FSvCMNSetMsgWarningDialog('รูปแบบเอกสารไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง');
            JSxDPYOpenImportForm();
            return;
        }

            var aDataHD     = aJSON['HD'];
            var aDataDT     = aJSON['DT'];
            // console.log(aDataDT);
            JSxDPYRenDerHDExcel(aDataHD);
            JSxDPYRenDerDTExcel(aDataDT);
            $('#odvDPYModalImportFile').modal('hide');
        }
        r.readAsBinaryString(f);
    } else {
        console.log("Failed to load file");
    }
}

function JSxDPYRenDerHDExcel(aDataHD){
        var tDocDate      = aDataHD[1][0];
        var tRealeaseName = aDataHD[1][1];
        var tUrlFileZip   = aDataHD[1][2];
        var tRemark       = aDataHD[1][3];
        var tStaForce     = aDataHD[1][4];
        var tActDate      = aDataHD[1][5];
        // if(tDocNo!='' && tDocNo!=null){
        //     $('#oetDPYDocNo').val(tDocNo);
        //     $('#oetDPYDocNo').closest(".form-group").css("cursor","");
        //     $('#oetDPYDocNo').css("pointer-events","");
        //     $('#oetDPYDocNo').attr('readonly',false);
        //     $("#oetDPYDocNo").removeAttr("onfocus");
        //     $('#ocbDPYStaAutoGenCode').prop('checked',false);
        // }else{
        //     $('#oetDPYDocNo').val('');
        //     $("#oetDPYDocNo").attr("readonly", true);
        //     $('#oetDPYDocNo').closest(".form-group").css("cursor","not-allowed");
        //     $('#oetDPYDocNo').css("pointer-events","none");
        //     $("#oetDPYDocNo").attr("onfocus", "this.blur()");
        //     $('#ofmDPYFormAdd').removeClass('has-error');
        //     $('#ofmDPYFormAdd .form-group').closest('.form-group').removeClass("has-error");
        //     $('#ofmDPYFormAdd em').remove(); 
        //     $('#ocbDPYStaAutoGenCode').prop('checked',true);
        // }

        if(tDocDate!='' && tDocDate!=null){
            var aDateTime = tDocDate.split(" ");
            var dDate = aDateTime[0];
            var tTime = aDateTime[1];
            $('#oetDPYDocDate').val(dDate);
            $('#oetDPYDocTime').val(tTime);
        }else{
            $('#oetDPYDocDate').val('<?=date('Y-m-d')?>');
            $('#oetDPYDocTime').val('<?=date('H:i:s')?>');
        }

        if(tStaForce=='Y'){
            $('#ocbXdhStaForce').prop('checked',true);
        }else{
            $('#ocbXdhStaForce').prop('checked',false);
        }

        if(tActDate!='' && tActDate!=null){
            var aDateTimeAct = tActDate.split(" ");
            var dDateAct = aDateTimeAct[0];
            var tTimeAct = aDateTimeAct[1];
            $('#oetDPYActDate').val(dDateAct);
            $('#oetDPYActTime').val(tTimeAct);
        }else{
            $('#oetDPYActDate').val('<?=date('Y-m-d')?>');
            $('#oetDPYActTime').val('<?=date('H:i:s')?>');
        }

        $('#oetDPYDepName').val(tRealeaseName);
        $('#oetDPYZipUrl').val(tUrlFileZip);
        $('#oetDPYRemark').val(tRemark);
}


function JSxDPYRenDerDTExcel(aDataDT){
    $('.otrDPYApp').remove();
    var tMarkUp =  '';
    var nCountRow = (aDataDT.length-1);
    let nLenIn = 1;
    for(var nI = 1;nI<=nCountRow;nI++){
        console.log(nI);
    // let nLenIn = $('input[name^="oetDPTAppCode["]').length + 1;
        var tAppCode    = aDataDT[nI][0];
        var tAppVersion = aDataDT[nI][1];
        var AppPath     = aDataDT[nI][2];
        var i = Date.now();
            tMarkUp +="<tr class='otrDPYApp' id='otrDPYAppRowID"+nI+"'>";
            tMarkUp +="<td align='center' class='otdColRowID_App' >"+nLenIn+"</td>";
            tMarkUp +="<td ><input type='text' name='oetDPTAppCode["+nI+"]' class='oetDPTAppCode form-control' maxlength='50' value='"+tAppCode+"' ></td>";
            tMarkUp +="<td ><input type='text' name='oetDPTAppVersion["+nI+"]' class='oetDPTAppVersion' maxlength='50' value='"+tAppVersion+"'></td>";
            tMarkUp +="<td ><input type='text' name='oetDPTAppPath["+nI+"]' class='oetDPTAppPath' maxlength='100' value='"+AppPath+"'></td>";
            tMarkUp +="<td align='center'><img onclick='JSxDPYAppRemoveRow("+nI+")' class='xCNIconTable xCNIconDel' src='<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>' ></td>";
            tMarkUp +="</tr>";
            nLenIn++;
    }
    // console.log(tMarkUp);
        $('#otbConditionDPYApp').append(tMarkUp);
        JSxDPYAppHideRowWhnNotFound();
}


    $('#obtDPYApprove').click(function(){
        JSnDPYApprove(false);
    });
   
    $('#obtDPYConfirmApprDoc').click(function(){
        JSnDPYApprove(true);
    });



    $('#obtDPYApproveDep').click(function(){
        JSnDPYApproveDep(false);
    });
   
    $('#obtDPYConfirmApprDocDep').click(function(){
        JSnDPYApproveDep(true);
    });




                // Event Click Browse Multi Branch
     $('#obtDEPYDocRef').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
                JSxCheckPinMenuClose(); // Hidden Pin Menu
       
                                // ********** Check Data Branch **********
                let tTextWhere      = '';


                window.oDPYBrowseUUIDOption   = undefined;
                oDPYBrowseUUIDOption          = {
                    Title   : ['tool/tool/tool','tUPGUUIDCoppyTitle'],
                    Table   : {Master:'TCNTAppDepHis',PK:'FTXdhDocNo'},
                    Join    : {
                        Table   : ['TCNTAppDepHD_L'],
                        On      : [
                            'TCNTAppDepHis.FTXdhDocNo = TCNTAppDepHD_L.FTXdhDocNo AND TCNTAppDepHD_L.FNLngID = '+nLangEdits
                        ]
                    },
                    Where :{
                        Condition : [tTextWhere]
                    },
                    GrideView:{
                        ColumnPathLang  	: 'tool/tool/tool',
                        ColumnKeyLang	    : ['tToolDocDate','tlogUPGRefUUID','tDPYReleaseName'],
                        ColumnsSize         : ['15%','20%','65%'],
                        WidthModal          : 50,
                        DataColumns		    : ['TCNTAppDepHis.FDCreateOn','TCNTAppDepHis.FTXdhDocNo','TCNTAppDepHD_L.FTXdhDepName'],
                        DistinctField       : [''],
                        DataColumnsFormat   : ['','',''],
                        Perpage			: 10,
                        OrderBy			    : ['TCNTAppDepHis.FDCreateOn DESC'],
                    },
                    NextFunc:{
                        FuncName:'JSxDPYCoppyDataDoc',
                        ArgReturn:['FTXdhDocNo']
                    },
                    CallBack:{
                        ReturnType	: 'S',
                        Value		: ['oetDPYDocRef','TCNTAppDepHis.FTXdhDocNo'],
                        Text		: ['oetDPYDocRef','TCNTAppDepHis.FTXdhDocNo']
                    },
           
                };
                JCNxBrowseData('oDPYBrowseUUIDOption');
            }else{
                JCNxShowMsgSessionExpired();
            }
        });


        function JSxDPYCoppyDataDoc(ptParam){
            var aParam = JSON.parse(ptParam);
            // console.log(aParam);
            if(ptParam!='NULL'){
                var tDocCoppy = aParam[0];
                // alert(tDocCoppy);
                JSxDPYGetDataDoc(tDocCoppy);
            }
        }

    function JSxDPYGetDataDoc(ptDocCoppy){
        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof nStaSession !== "undefined" && nStaSession == 1) {
            JCNxOpenLoading();
            $.ajax({
                type: "POST",
                url:  'augDPYCoppyDoc',
                data: {
                    ptXthDocNo:ptDocCoppy
                },
                cache: false,
                timeout: 0,
                success: function(tResult) {
                        var aReturn = JSON.parse(tResult);
                        if (aReturn["nStaEvent"] == 1) {
                            var aDataHD     = aReturn['aConfigView']['aDataDocHD']['raItems'];
                            var aDataDT     = aReturn['aConfigView']['aDataDocDT']['raItems'];
                            var aDataHDBch  = aReturn['aConfigView']['aDataDocHDBch']['raItems'];
                            
                            // console.log(aDataDT);
                            JSxDPYRenDerHDCoppy(aDataHD);
                            JSxDPYRenDerDTCoppy(aDataDT);
                            JSxDPYRenDerHDBchCoppy(aDataHDBch);
                            
                            JCNxCloseLoading();
                        } else {
                            tMessageError = aReturn['tStaMessg'];
                            FSvCMNSetMsgWarningDialog(tMessageError);
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




    function JSxDPYRenDerHDCoppy(aDataHD){
        var tDocDate      = aDataHD.FDXdhDocDate;
        var tRealeaseName = aDataHD.FTXdhDepName;
        var tUrlFileZip   = aDataHD.FTXdhZipUrl;
        var tRemark       = aDataHD.FTXdhDepRmk;
        var tStaForce     = aDataHD.FTXdhStaForce;
        var tActDate      = aDataHD.FDXdhActDate;


        if(tDocDate!='' && tDocDate!=null){
            var aDateTime = tDocDate.split(" ");
            var dDate = aDateTime[0];
            var tTime = aDateTime[1];
            $('#oetDPYDocDate').val(dDate);
            $('#oetDPYDocTime').val(tTime);
        }else{
            $('#oetDPYDocDate').val('<?=date('Y-m-d')?>');
            $('#oetDPYDocTime').val('<?=date('H:i:s')?>');
        }

        if(tStaForce=='Y'){
            $('#ocbXdhStaForce').prop('checked',true);
        }else{
            $('#ocbXdhStaForce').prop('checked',false);
        }

        if(tActDate!='' && tActDate!=null){
            var aDateTimeAct = tActDate.split(" ");
            var dDateAct = aDateTimeAct[0];
            var tTimeAct = aDateTimeAct[1];
            $('#oetDPYActDate').val(dDateAct);
            $('#oetDPYActTime').val(tTimeAct);
        }else{
            $('#oetDPYActDate').val('<?=date('Y-m-d')?>');
            $('#oetDPYActTime').val('<?=date('H:i:s')?>');
        }

        $('#oetDPYDepName').val(tRealeaseName);
        $('#oetDPYZipUrl').val(tUrlFileZip);
        $('#oetDPYRemark').val(tRemark);
}


function JSxDPYRenDerDTCoppy(aDataDT){
    console.log(aDataDT);
    $('.otrDPYApp').remove();
    var tMarkUp =  '';
    var nCountRow = aDataDT.length;
    let nLenIn = 1;
    for(var nI = 0;nI<nCountRow;nI++){
        console.log(nI);
        var tAppCode    = aDataDT[nI].FTAppCode;
        var tAppVersion = aDataDT[nI].FTAppVersion;
        var AppPath     = aDataDT[nI].FTXdhAppPath;
        var i = Date.now();
            tMarkUp +="<tr class='otrDPYApp' id='otrDPYAppRowID"+nI+"'>";
            tMarkUp +="<td align='center' class='otdColRowID_App' >"+nLenIn+"</td>";
            tMarkUp +="<td ><input type='text' name='oetDPTAppCode["+nI+"]' class='oetDPTAppCode form-control' maxlength='50' value='"+tAppCode+"' ></td>";
            tMarkUp +="<td ><input type='text' name='oetDPTAppVersion["+nI+"]' class='oetDPTAppVersion' maxlength='50' value='"+tAppVersion+"'></td>";
            tMarkUp +="<td ><input type='text' name='oetDPTAppPath["+nI+"]' class='oetDPTAppPath' maxlength='100' value='"+AppPath+"'></td>";
            tMarkUp +="<td align='center'><img onclick='JSxDPYAppRemoveRow("+nI+")' class='xCNIconTable xCNIconDel' src='<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>' ></td>";
            tMarkUp +="</tr>";
            nLenIn++;
    }
    // console.log(tMarkUp);
        $('#otbConditionDPYApp').append(tMarkUp);
        JSxDPYAppHideRowWhnNotFound();
}





function JSxDPYRenDerHDBchCoppy(aDataHDBch){
     $('.otrInclude').remove();
      var tMarkUp =  '';
      var nCountRow = aDataHDBch.length;
      let nLenIn = 1;
    for(var nI = 0;nI<nCountRow;nI++){

        if(aDataHDBch[nI].FTAgnName!=null){
            var tAgnName = aDataHDBch[nI].FTAgnName;
        }else{
            var tAgnName = '';
        }

        if(aDataHDBch[nI].FTBchName!=null){
            var tBchName = aDataHDBch[nI].FTBchName;
        }else{
            var tBchName = '';
        }


        if(aDataHDBch[nI].FTPosName!=null){
            var tPosName = aDataHDBch[nI].FTPosName;
        }else{
            var tPosName = '';
        }
        let aDataApr = { 
                     tRddAgnCodeTo:aDataHDBch[nI].FTXdhAgnTo,
                     tRddAgnNameTo:tAgnName,
                     tRddBchCodeTo:aDataHDBch[nI].FTXdhBchTo,
                     tRddBchNameTo:tBchName,
                     tRddPosCodeTo:aDataHDBch[nI].FTXdhPosTo,
                     tRddPosNameTo:tPosName,
                    //  tRddShpCodeTo:tRddShpCodeTo,
                    //  tRddShpNameTo:tRddShpNameTo,
                     }

                     if(aDataHDBch[nI].FTXdhStaType=='1'){
                         var tRddBchModalTypeText = 'ร่วมรายการ';
                     }else{
                        var tRddBchModalTypeText = 'ยกเว้น';
                     }
                     var nRddBchModalType = aDataHDBch[nI].FTXdhStaType;
      var i = Date.now();
      tMarkUp +="<tr class='otrInclude' id='otrRddBchRowID"+i+"'>";
                tMarkUp +="<td align='center' class='otdColRowID_Bch' >"+nLenIn+"</td>";
                tMarkUp +="<td >"+tRddBchModalTypeText+"</td>";
                tMarkUp +="<td>";
                tMarkUp +="<input type='hidden' name='ohdDPYAgnCode["+i+"]' class='ohdDPYAgnCode' tRddAgnName='"+aDataApr.tRddAgnNameTo+"' value='"+aDataApr.tRddAgnCodeTo+"'>";
                tMarkUp +="<input type='hidden' name='ohdDPYBchCode["+i+"]' class='ohdDPYBchCode' tRddBchName='"+aDataApr.tRddBchNameTo+"' value='"+aDataApr.tRddBchCodeTo+"'>";
                tMarkUp +="<input type='hidden' name='ohdDPYPosCode["+i+"]' class='ohdDPYPosCode' tRddPosName='"+aDataApr.tRddPosNameTo+"' value='"+aDataApr.tRddPosCodeTo+"'>";
                //tMarkUp +="<input type='hidden' name='ohdDPYShpCode["+i+"]' class='ohdDPYShpCode' tRddShpName='"+aDataApr.tRddShpNameTo+"' value='"+aDataApr.tRddShpCodeTo+"'>";
                tMarkUp +="<input type='hidden' name='ohdRddBchModalType["+i+"]' class='ohdRddBchModalType' value='"+nRddBchModalType+"'>";
                tMarkUp +=aDataApr.tRddAgnNameTo+"</td>";
                tMarkUp +="<td>"+aDataApr.tRddBchNameTo+"</td>";
                tMarkUp +="<td>"+aDataApr.tRddPosNameTo+"</td>";
                tMarkUp +="<td align='center'><img onclick='JSxRddBchRemoveRow("+i+")' class='xCNIconTable xCNIconDel' src='<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>' ></td>";
                tMarkUp +="</tr>";
                nLenIn++;
    }
    $('#otbConditionDPYBch').append(tMarkUp);
    JSxDPYHideRowWhnNotFound();
}
</script>