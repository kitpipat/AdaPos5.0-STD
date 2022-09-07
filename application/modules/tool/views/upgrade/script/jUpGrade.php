<script>


$("document").ready(function(){
    localStorage.removeItem("LocalItemData");
    JSxCheckPinMenuClose();
        // Event Click Navigater Title (คลิก Title ของเอกสาร)
        $('#oliSMTSALTitle').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
                // $('#oetSMTSALDateDataTo').val($(this).attr('datenow'));
                JSvUPGMain();
            }else{
                JCNxShowMsgSessionExpired();
            }
        });

        JCNxOpenLoading();
        JSvUPGMain();
  

    

});


// Function: Call Main Page DashBoard
// Parameters: Document Ready Or Parameter Event
// Creator: 14/01/2020 Wasin(Yoshi)
// Return: View Page Main
// ReturnType: View
function JSvUPGMain(){
    JCNxOpenLoading();
    $.ajax({
        type: "POST",
        url: "augAutoMainPage",
        cache: false,
        data: {
            // 'ptDateDataForm'    : tDateDataForm,
            // 'ptDateDataTo'      : tDateDataTo
        },
        timeout: 0,
        success: function (tResult){
            $("#odvUPGAutoConent").html(tResult);
            $('.tab-pane').removeClass('active');
            $('.tab-pane').removeClass('in');
            $('#odvUPGAutoConent').addClass('active');
            $('#odvUPGAutoConent').addClass('in');
       //     JCNxSMTCallSaleDataTable();
            // JCNxSMTCallApiDataTable();
    
            // JCNxCloseLoading();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            JCNxResponseError(jqXHR, textStatus, errorThrown);
        }
    });
}




// Function: Confirm Filter DashBoard
// Parameters: Document Ready Or Parameter Event
// Creator: 06/02/2020 Wasin(Yoshi)
// Return: View Page Main
// ReturnType: View
function JCNxUPGDataTable(nPageCurrent){
    const tDateDataForm   = $('#oetSMTSALDateDataForm').val();
    const tDateDataTo   = $('#oetSMTSALDateDataTo').val();
    const tDSHSALSort   = $('#oetDSHSALSort').val();
    const tDSHSALFild   = $('#oetDSHSALFild').val();
    const tATLDocStaPrcStk   = $('#ocmATLDocStaPrcStk').val();
    var tAllBillNotPrcStock = '';
    if($('#ocbAllBillNotPrcStock').prop('checked')==true){
     tAllBillNotPrcStock   = 'all';
    }else{
     tAllBillNotPrcStock   = 'no';
    }
    if(nPageCurrent=='' || nPageCurrent == undefined || nPageCurrent == 'NaN' ){
        nPageCurrent = 1;
    }
    $.ajax({
        type: "POST",
        url: "augAutoDataTable",
        data: $('#ofmUPGAuto').serialize()+"&nPageCurrent="+nPageCurrent,
        cache: false,
        timeout: 0,
        success : function(paDataReturn){
           
            $('#odvPanelUPGData').html(paDataReturn);
          var tSesUsrBchCode =  $('#odhSesUsrBchCode').val();
            // JSxSMTControlTableData();
            // JSxSMTCallMQRequestSaleData(tSesUsrBchCode,'','',10);
            JCNxCloseLoading();
        },
        error : function (jqXHR, textStatus, errorThrown) {
            JCNxResponseError(jqXHR,textStatus,errorThrown);
        }
    });
}






    //Functionality : เปลี่ยนหน้า pagenation
    //Parameters : Event Click Pagenation
    //Creator : 06/10/2020 Worakorn
    //Return : View
    //Return Type : View
    function JSvUPGClickPage(ptPage) {
        var nPageCurrent = '';
        switch (ptPage) {
            case 'next': //กดปุ่ม Next
                $('.xWBtnNext').addClass('disabled');
                nPageOld = $('.xWPageUPG .active').text(); // Get เลขก่อนหน้า
                nPageNew = parseInt(nPageOld, 10) + 1; // +1 จำนวน
                nPageCurrent = nPageNew
                break;
            case 'previous': //กดปุ่ม Previous
                nPageOld = $('.xWPageUPG .active').text(); // Get เลขก่อนหน้า
                nPageNew = parseInt(nPageOld, 10) - 1; // -1 จำนวน
                nPageCurrent = nPageNew
                break;
            default:
                nPageCurrent = ptPage
        }

        const ptFSort = '';
        JCNxUPGDataTable(nPageCurrent);
    }



// Function: Call Main Page DashBoard
// Parameters: Document Ready Or Parameter Event
// Creator: 14/01/2020 Wasin(Yoshi)
// Return: View Page Main
// ReturnType: View
function JSvDPYMain(){
    JCNxOpenLoading();
    $.ajax({
        type: "POST",
        url: "augDPYMainPage",
        cache: false,
        data: {
            // 'ptDateDataForm'    : tDateDataForm,
            // 'ptDateDataTo'      : tDateDataTo
        },
        timeout: 0,
        success: function (tResult){
            $("#odvDPYConent").html(tResult);
            $('.tab-pane').removeClass('active');
            $('.tab-pane').removeClass('in');
            $('#odvDPYConent').addClass('active');
            $('#odvDPYConent').addClass('in');
            JCNxDPYDataTable();
            // JCNxSMTCallApiDataTable();
    
            // JCNxCloseLoading();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            JCNxResponseError(jqXHR, textStatus, errorThrown);
        }
    });
}




// Function: Confirm Filter DashBoard
// Parameters: Document Ready Or Parameter Event
// Creator: 06/02/2020 Wasin(Yoshi)
// Return: View Page Main
// ReturnType: View
function JCNxDPYDataTable(pnPage){
    JCNxOpenLoading();
    var oAdvanceSearch = JSoDPYGetAdvanceSearchData();
    var nPageCurrent = pnPage;
    if (nPageCurrent == undefined || nPageCurrent == "") {
        nPageCurrent = "1";
    }
    $.ajax({
        type: "POST",
        url: "augDPYDataTable",
        data: {
            oAdvanceSearch: oAdvanceSearch,
            nPageCurrent: nPageCurrent,
        },
        cache: false,
        timeout: 0,
        success: function(oResult) {
            var aReturnData = JSON.parse(oResult);
            if (aReturnData['nStaEvent'] == '1') {
                JSxDPYNavDefult();
                $('#ostContentDeployTable').html(aReturnData['tViewDataTable']);
            } else {
                var tMessageError = aReturnData['tStaMessg'];
                FSvCMNSetMsgErrorDialog(tMessageError);
            }
            JCNxLayoutControll();
            JCNxCloseLoading();
        },
        error: function(jqXHR, textStatus, errorThrown) {
            JCNxResponseError(jqXHR, textStatus, errorThrown);
        }
    });
}






    //Functionality : เปลี่ยนหน้า pagenation
    //Parameters : Event Click Pagenation
    //Creator : 06/10/2020 Worakorn
    //Return : View
    //Return Type : View
    function JSvDPYClickPage(ptPage) {
        var nPageCurrent = '';
        switch (ptPage) {
            case 'next': //กดปุ่ม Next
                $('.xWBtnNext').addClass('disabled');
                nPageOld = $('.xWPageDPYPdt .active').text(); // Get เลขก่อนหน้า
                nPageNew = parseInt(nPageOld, 10) + 1; // +1 จำนวน
                nPageCurrent = nPageNew
                break;
            case 'previous': //กดปุ่ม Previous
                nPageOld = $('.xWPageDPYPdt .active').text(); // Get เลขก่อนหน้า
                nPageNew = parseInt(nPageOld, 10) - 1; // -1 จำนวน
                nPageCurrent = nPageNew
                break;
            default:
                nPageCurrent = ptPage
        }

        const ptFSort = '';
        JCNxDPYDataTable(nPageCurrent);
    }



// Function: Set Defult Nav Menu 
// Parameters: Document Ready And Button Event Click
// Creator: 06/06/2019 Wasin(Yoshi)
// LastUpdate:
// Return: Set Default Nav Menu Adjust Stock
// ReturnType: -
function JSxDPYNavDefult() {

        $('.xCNChoose').hide();
        $('#oliDPYTitleAdd').hide();
        $('#oliDPYTitleEdit').hide();
        $('#oliDPYTitleDetail').hide();
        $('#odvBtnAddEdit').hide();

        $('#odvBtnASTInfo').show();

}

// Function: Get Data Advanced Search
// Parameters: Function Call Page
// Creator: 02/05/2019 Wasin(Yoshi)
// LastUpdate: -
// Return: object Data Advanced Search
// ReturnType: object
function JSoDPYGetAdvanceSearchData() {
    var oAdvanceSearchData = {
        tSearchAll: $("#oetSearchAll").val(),
 
        tSearchDocDateFrom: $("#oetDPYDocDateFrom").val(),
        tSearchDocDateTo: $("#oetDPYDocDateTo").val(),
        tSearchStaPreDep: $("#ocmDPYStaPreDep").val(),
        tSearchStaDep: $("#ocmDPYStaDep").val()
    };
    return oAdvanceSearchData;
}




// Functionality : Call Page Adjust Stock Add Page
// Parameters : Event Click Buttom
// Creator : 07/06/2019 Wasin(Yoshi)
// Return : View
// Return Type : View
function JSvDPYCallPageAdd() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof nStaSession !== "undefined" && nStaSession == 1) {
        JCNxOpenLoading();
        $.ajax({
            type: "POST",
            url: "augDPYPageAdd",
            cache: false,
            timeout: 0,
            success: function(oResult) {
                var aReturnData = JSON.parse(oResult);
                if (aReturnData['nStaEvent'] == '1') {
          
                        $('#oliDPYTitleEdit').hide();
                        $("#obtDPYApprove").hide();
                        $("#obtDPYCancel").hide();
                        $('#odvBtnDPYInfo').hide();
                        $('#obtDPYPrint').hide();
                        $('#oliDPYTitleAdd').show();
                        $('#odvBtnAddEdit').show();
                        $('#obtDPYCallPageAdd').hide();
                        // ================== Create By Witsarut 28/08/2019 ==================
                        $(".xCNBTNPrimery2Btn").show();
                        // $(".xWBtnGrpSaveRight").show();
                        // ================== Create By Witsarut 28/08/2019 ==================
                        $('#odvContentPageDPY').html(aReturnData['tDPYViewPageAdd']);
                    
                        JCNxCloseLoading()
                    JCNxDPYControlObjAndBtn();
                    // JSvDPYLoadPdtDataTableHtml(1);

                    // $("#oetDPYDocNo,#oetDPYDocDate,#oetDPYDocTime").blur(function() {
                    //     JSxDPYSetStatusClickSubmit(0);
                    //     JSxValidateFormAddDPY();
                    //     $('#ofmDPYFormAdd').submit();
                    // });



                } else {
                    var tMessageError = aReturnData['tStaMessg'];
                    FSvCMNSetMsgErrorDialog(tMessageError);
                }

                JCNxLayoutControll();
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


//Function : Control Object And Button ปิด เปิด
function JCNxDPYControlObjAndBtn() {
    //Check สถานะอนุมัติ
    ohdXthStaDep = $("#oetXdhStaDep").val();
    ohdXthStaPreDep = $("#oetXdhStaPreDep").val();

    //Set Default
    //Btn Cancel
    $("#obtDPYCancel").attr("disabled", false);
    //Btn Apv
    $("#obtDPYApprove").attr("disabled", false);
    $("#obtDPYPrint").attr("disabled", false);
    $(".form-control").attr("disabled", false);
    $(".ocbListItem").attr("disabled", false);
    // $(".xCNBtnBrowseAddOn").attr("disabled", false);
    $(".xCNBtnDateTime").attr("disabled", false);
    $(".xCNDocBrowsePdt")
        .attr("disabled", false)
        .removeClass("xCNBrowsePdtdisabled");
    $(".xCNDocDrpDwn").show();
    $("#oetDPYSearchPdtHTML").attr("disabled", false);
    $(".xWBtnGrpSaveLeft").attr("disabled", false);
    $(".xWBtnGrpSaveRight").attr("disabled", false);
    $("#oliBtnEditShipAdd").show();
    $("#oliBtnEditTaxAdd").show();
    $("#obtDPYApprove").hide();
    $("#obtDPYApproveDep").hide();
    $("#obtDPYCancel").hide();
    if (ohdXthStaPreDep == 2) {
        //Btn Apv
        $("#obtDPYApprove").show();
        $("#obtDPYPrint").attr("disabled", false);

        // ========== Edit By Witsarut 27/08/2019 ==================
        $("#obtDPYCancel").show();
        $(".xWBtnGrpSaveLeft").hide();
        $(".xWBtnGrpSaveRight").hide();
        // ========== Edit By Witsarut 27/08/2019 ==================

        //Control input ปิด
        // $(".form-control").attr("disabled", true);
        // $(".ocbListItem").attr("disabled", true);
        // $(".xCNBtnBrowseAddOn").attr("disabled", true);
        // $(".xCNBtnDateTime").attr("disabled", true);
        $(".xCNDocBrowsePdt")
            .attr("disabled", true)
            .addClass("xCNBrowsePdtdisabled");
        $(".xCNDocDrpDwn").hide();
        $("#oetDPYSearchPdtHTML").attr("disabled", false);
        $("#oliBtnEditShipAdd").hide();
        $("#oliBtnEditTaxAdd").hide();
        $('#ocbDPYStaDocAct').attr("disabled", true)
    }

    //Check สถานะเอกสาร
    if ((ohdXthStaPreDep == 1 && ohdXthStaDep == 2) || (ohdXthStaPreDep==3) || (ohdXthStaPreDep == 1 && ohdXthStaDep == 1)) {
        //Btn Cancel
        $("#obtDPYCancel").hide();
        //Btn Apv
        $("#obtDPYApprove").hide();
        // ========== Edit By Witsarut 27/08/2019 ==================
        $("#obtDPYPrint").hide();
        // ========== Edit By Witsarut 27/08/2019 ==================
        //Control input ปิด
        $("input").attr("readonly", true);
        $('.xCNIconDel').remove();
        $('#obtDPYImpExcel').attr("disabled", true);
        $('#obtDEPYDocRef').attr("disabled", true);
        $('#obtDPYAddApp').attr("disabled", true);
        $('#obtTabConditionDPYBch').attr("disabled", true);
        // $(".form-control").attr("disabled", true);
        $(".ocbListItem").attr("disabled", true);
        $(".xCNBtnBrowseAddOn").attr("disabled", true);
        $(".xCNBtnDateTime").attr("disabled", true);
        $(".xCNDocBrowsePdt")
            .attr("disabled", true)
            .addClass("xCNBrowsePdtdisabled");
        $(".xCNDocDrpDwn").hide();
        $("#oetDPYSearchPdtHTML").attr("disabled", false);
        $(".xWBtnGrpSaveLeft").hide();
        // ========== Edit By Witsarut 27/08/2019 ==================
        $(".xWBtnGrpSaveRight").hide();
        $("#oliBtnEditShipAdd").hide();
        // ========== Edit By Witsarut 27/08/2019 ==================
        $("#oliBtnEditTaxAdd").hide();
        $('#ocbDPYStaDocAct').attr("disabled", true)
        $('#oetDPYRemark').attr("readonly", false);
        $('#oetDPYRemark').attr("disabled", false);
    }

    if (ohdXthStaPreDep == 1 && ohdXthStaDep == 2) {

        $("#obtDPYApproveDep").show();
    }
}



function JSvDPYCallPageEdit(ptXthDocNo) {
    JCNxOpenLoading();
    // JStCMMGetPanalLangSystemHTML("JSvDPYCallPageEdit", ptXthDocNo);
    $.ajax({
        type: "POST",
        url: "augDPYPageEdit",
        data: { ptXthDocNo: ptXthDocNo },
        cache: false,
        timeout: 0,
        success: function(oResult) {
            var aReturnData = JSON.parse(oResult);
            if (aReturnData != "") {
                $("#oliDPYTitleAdd").hide();
                $("#oliDPYTitleEdit").show();
                $("#odvBtnDPYInfo").hide();
                $("#odvBtnAddEdit").show();
                $('#obtDPYCallPageAdd').hide();
                $("#odvContentPageDPY").html(aReturnData['tDPYViewPageAdd']);
                // $("#oetDPYDocNo").addClass("xCNDisable");
                $(".xCNDisable").attr("readonly", true);
                $(".xCNiConGen").hide();
                // $("#obtDPYApprove").show();
                // $("#obtDPYPrint").show();
                // $("#obtDPYCancel").show();
                // ================== Create By Witsarut 28/08/2019 ==================
                $(".xWBtnGrpSaveLeft").show();
                $(".xWBtnGrpSaveRight").show();
                // ================== Create By Witsarut 28/08/2019 ==================
            }

            //Control Event Button
            if ($("#ohdDPYAutStaEdit").val() == 0) {
                $(".xCNUplodeImage").hide();
                $(".xCNIconBrowse").show();
                $(".xCNEditRowBtn").show();
                $("select").prop("disabled", false);
                $("input").attr("disabled", false);
            } else {
                $(".xCNUplodeImage").show();
                $(".xCNIconBrowse").show();
                $(".xCNEditRowBtn").show();
                $("select").prop("disabled", false);
                $("input").attr("disabled", false);
            }
            //Control Event Button

            //Function Load Table Pdt ของ TFW
            // JSvDPYLoadPdtDataTableHtml(1);

            //Put Data
            // ohdXthCshOrCrd = $("#ohdXthCshOrCrd").val();
            // $("#ostXthCshOrCrd option[value='" + ohdXthCshOrCrd + "']")
            //   .attr("selected", true)
            //   .trigger("change");

            // Control Object And Button ปิด เปิด
            JCNxDPYControlObjAndBtn();
            JCNxLayoutControll();
            JCNxCloseLoading();
            $(".xWConditionSearchPdt.disabled").attr("disabled", "disabled");
        },
        error: function(jqXHR, textStatus, errorThrown) {
            JCNxResponseError(jqXHR, textStatus, errorThrown);
        }
    });
}


// Function: Event Single Delete Document Single
// Parameters: Event Click Button Delete Document Single
// Creator: 07/06/2019 Wasin(Yoshi)
// LastUpdate: -
// Return: object Data Status Delete
// ReturnType: object
function JSoDPYDelDocSingle(ptCurrentPage, ptDPYDocNo) {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof nStaSession !== "undefined" && nStaSession == 1) {
        $('#odvDPYModalDelDocSingle #ospTextConfirmDelSingle').html($('#oetTextComfirmDeleteSingle').val() + ptDPYDocNo);
        $('#odvDPYModalDelDocSingle').modal('show');
        $('#odvDPYModalDelDocSingle #osmDPYConfirmPdtDTTemp ').unbind().click(function() {
            JCNxOpenLoading();
            $.ajax({
                type: "POST",
                url: "augDPYEventDelete",
                data: { 'tDPYDocNo': ptDPYDocNo },
                cache: false,
                timeout: 0,
                success: function(oResult) {
                    var aReturnData = JSON.parse(oResult);
                    if (aReturnData['nStaEvent'] == '1') {
                        $('#odvDPYModalDelDocSingle').modal('hide');
                        $('#odvDPYModalDelDocSingle #ospTextConfirmDelSingle').html($('#oetTextComfirmDeleteSingle').val());
                        $('.modal-backdrop').remove();
                        setTimeout(function() {
                            JCNxDPYDataTable(ptCurrentPage);
                        }, 500);
                    } else {
                        JCNxCloseLoading();
                        FSvCMNSetMsgErrorDialog(aReturnData['tStaMessg']);
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
}

// Function: Event Mutiple Delete Doc Mutiple
// Parameters: Function Call Page
// Creator: 07/06/2019 Wasin(Yoshi)
// LDPYUpdate: -
// Return: object Data Sta Delete
// ReturnType: object
function JSoDPYDelDocMultiple() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        var aDataDelMultiple = $('#odvDPYModalDelDocMultiple #ohdConfirmIDDelMultiple').val();
        var aTextsDelMultiple = aDataDelMultiple.substring(0, aDataDelMultiple.length - 2);
        var aDataSplit = aTextsDelMultiple.split(" , ");
        var nDataSplitlength = aDataSplit.length;
        var aNewIdDelete = [];

        for ($i = 0; $i < nDataSplitlength; $i++) {
            aNewIdDelete.push(aDataSplit[$i]);
        }
        if (nDataSplitlength > 1) {
            JCNxOpenLoading();
            localStorage.StaDeleteArray = '1';
            $.ajax({
                type: "POST",
                url: "augDPYEventDelete",
                data: { 'tDPYDocNo': aNewIdDelete },
                cache: false,
                timeout: 0,
                success: function(oResult) {
                    var aReturnData = JSON.parse(oResult);
                    if (aReturnData['nStaEvent'] == '1') {
                        setTimeout(function() {
                            $('#odvDPYModalDelDocMultiple').modal('hide');
                            $('#odvDPYModalDelDocMultiple #ospTextConfirmDelMultiple').empty();
                            $('#odvDPYModalDelDocMultiple #ohdConfirmIDDelMultiple').val('');
                            $('.modal-backdrop').remove();
                            localStorage.removeItem('LocalItemData');
                            JCNxDPYDataTable();
                        }, 1000);
                    } else {
                        JCNxCloseLoading();
                        FSvCMNSetMsgErrorDialog(aReturnData['tStaMessg']);
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });
        }
    } else {
        JCNxShowMsgSessionExpired();
    }
}

//Functionality: Function Chack And Show Button Delete All
//Parameters: LocalStorage Data
//Creator: 07/06/2019 Wasin(Yoshi)
//Return: Show Button Delete All
//Return Type: -
function JSxDPYShowButtonChoose() {
    var aArrayConvert = [JSON.parse(localStorage.getItem("LocalItemData"))];
    if (aArrayConvert[0] == null || aArrayConvert[0] == "") {
        $("#oliBtnDeleteAll").addClass("disabled");
    } else {
        nNumOfArr = aArrayConvert[0].length;
        if (nNumOfArr > 1) {
            $("#oliBtnDeleteAll").removeClass("disabled");
        } else {
            $("#oliBtnDeleteAll").addClass("disabled");
        }
    }
}

//Functionality: Insert Text In Modal Delete
//Parameters: LocalStorage Data
//Creator: 01/07/2017 "Witsarut"
//Return: -
//Return Type: -
function JSxDPYTextInModal() {
    var aArrayConvert = [JSON.parse(localStorage.getItem("LocalItemData"))];
    if (aArrayConvert[0] == null || aArrayConvert[0] == "") {} else {
        var tTextCode = "";
        for ($i = 0; $i < aArrayConvert[0].length; $i++) {
            tTextCode += aArrayConvert[0][$i].nCode;
            tTextCode += " , ";
        }


        //Disabled ปุ่ม Delete
        if (aArrayConvert[0].length > 1) {
            $(".xCNIconDel").addClass("xCNDisabled");
        } else {
            $(".xCNIconDel").removeClass("xCNDisabled");
        }
        $("#ospTextConfirmDelMultiple").text("ท่านต้องการลบข้อมูลทั้งหมดหรือไม่ ?");
        $("#ohdConfirmIDDelete").val(tTextCode);
        $("#ohdConfirmIDDelMultiple").val(tTextCode);
    }
}


//Functionality: Function Chack Value LocalStorage
//Parameters: Event Select List Branch
//Creator: 07/06/2019 Wasin(Yoshi)
//Return: Duplicate/none
//Return Type: string
function JStDPYFindObjectByKey(array, key, value) {
    for (var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return "Dupilcate";
        }
    }
    return "None";
}



//Functionality : Action for approve
//Parameters : pbIsConfirm
//Creator : 11/04/2019 Witsarut(Bell)
//Last Modified : -
//Return : -
//Return Type : -
function JSnDPYApprove(pbIsConfirm) {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof nStaSession !== "undefined" && nStaSession == 1) {
        try {
            if (pbIsConfirm) {
                $('#odvDPYModalAppoveDoc').modal("hide");

                var tXthDocNo = $("#oetDPYDocNo").val();
                $.ajax({
                    type: "POST",
                    url: "augDPYApprove",
                    data: {
                        tXthDocNo: tXthDocNo,
                    },
                    cache: false,
                    timeout: 0,
                    success: function(tResult) {
                        var aReturn = JSON.parse(tResult);
                            if (aReturn["nStaEvent"] != '99') {
                                JSvDPYCallPageEdit(tXthDocNo);
                            }else{
                                FSvCMNSetMsgErrorDialog(aReturn['tStaMessg']);
                            }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        JCNxResponseError(jqXHR, textStatus, errorThrown);
                    }
                });
            } else {
                //console.log("StaApvDoc Call Modal");
                $('#odvDPYModalAppoveDoc').modal("show");
            }
        } catch (err) {
            console.log("JSnTFWApprove Error: ", err);
        }
    } else {
        JCNxShowMsgSessionExpired();
    }
}




// Functionality : Action for approve
// Parameters : pbIsConfirm
// Creator : 11/04/2019 Witsarut(Bell)
// Last Modified : -
// Return : -
// Return Type : -
function JSnDPYCancelDoc(pbIsConfirm) {

tXthDocNo = $("#oetDPYDocNo").val();

if (pbIsConfirm) {
    $.ajax({
        type: "POST",
        url: "augDPYCancel",
        data: {
            tXthDocNo: tXthDocNo
        },
        cache: false,
        timeout: 5000,
        success: function(tResult) {
            $("#odvDPYPopupCancel").modal("hide");

                var aReturn = JSON.parse(tResult);
         if (aReturn["nSta"] == 1) {
            JSvDPYCallPageEdit(tXthDocNo);
                            

            } else {
                JCNxCloseLoading();
                tMsgBody = aReturn.tMsg;
                FSvCMNSetMsgWarningDialog(tMsgBody);
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            JCNxResponseError(jqXHR, textStatus, errorThrown);
        }
    });
} else {
    //Check Status Approve for Control Msg In Modal
    nStaApv = $("#ohdDPYStaApv").val();
    if (nStaApv == 1) {
        $("#obpMsgApv").show();
    } else {
        $("#obpMsgApv").hide();
    }
    $("#odvDPYPopupCancel").modal("show");

}
}





//Functionality : Action for approve
//Parameters : pbIsConfirm
//Creator : 11/04/2019 Witsarut(Bell)
//Last Modified : -
//Return : -
//Return Type : -
function JSnDPYApproveDep(pbIsConfirm) {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof nStaSession !== "undefined" && nStaSession == 1) {
        try {
            if (pbIsConfirm) {
                $('#odvDPYModalAppoveDocDep').modal("hide");

                var tXthDocNo = $("#oetDPYDocNo").val();
                $.ajax({
                    type: "POST",
                    url: "augDPYApproveDep",
                    data: {
                        tXthDocNo: tXthDocNo,
                    },
                    cache: false,
                    timeout: 0,
                    success: function(tResult) {
                        var aReturn = JSON.parse(tResult);
                            if (aReturn["nStaEvent"] != '99') {
                                JSvDPYCallPageEdit(tXthDocNo);
                            }else{
                                FSvCMNSetMsgErrorDialog(aReturn['tStaMessg']);
                            }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        JCNxResponseError(jqXHR, textStatus, errorThrown);
                    }
                });
            } else {
                //console.log("StaApvDoc Call Modal");
                $('#odvDPYModalAppoveDocDep').modal("show");
            }
        } catch (err) {
            console.log("JSnTFWApprove Error: ", err);
        }
    } else {
        JCNxShowMsgSessionExpired();
    }
}



</script>