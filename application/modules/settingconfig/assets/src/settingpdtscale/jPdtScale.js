var nStaPDSBrowseType = $('#oetPDSStaBrowse').val();
var tCallPDSBackOption = $('#oetPDSCallBackOption').val();
/*============================= Begin Auto Run ===============================*/

$('document').ready(function() {
    localStorage.removeItem('LocalItemData');
    JSxCheckPinMenuClose(); /*Check เปิดปิด Menu ตาม Pin*/
    JSxPDSNavDefult();
    if (nStaPDSBrowseType != 1) {
        JSvPDSCallPageList();
    } else {
        JSvPDSCallPageAdd();
    }
});

/*============================= End Auto Run =================================*/


/*============================= Begin Form Validate ==========================*/

/**
 * Functionality : (event) Add/Edit PDS
 * Parameters : ptRoute is route to add Customer Group data.
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : -
 * Return Type : -
 */
function JSnPDSEventAddEdit(ptRoute) {

    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        $('#ofmAddPDS').validate().destroy();
        $.validator.addMethod('dublicateCode', function(value, element) {
            if (ptRoute == "settingpdtscaleEventAdd") {
                if ($("#ohdCheckDuplicatePDSCode").val() == 1) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return true;
            }
        }, '');
        $('#ofmAddPDS').validate({
            rules: {
                oetPDSCode: {
                    "required": {
                        depends: function(oElement) {
                            if (ptRoute == "settingpdtscaleEventAdd") {
                                if ($('#ocbPDSAutoGenCode').is(':checked')) {
                                    return false;
                                } else {
                                    return true;
                                }
                            } else {
                                return true;
                            }
                        }
                    },
                    "dublicateCode": {}
                },
                oetPDSName: { "required": {} },
                oetLableFormatName: { "required": {} },
                // oetPortPrnName: { "required": {} }

            },
            messages: {
                oetPDSCode: {
                    "required": $('#oetPDSCode').attr('data-validate-required'),
                    "dublicateCode": $('#oetPDSCode').attr('data-validate-dublicateCode')
                },
                oetPDSName: {
                    "required": $('#oetPDSName').attr('data-validate-required'),
                },
                oetLableFormatName: {
                    "required": $('#oetLableFormatName').attr('data-validate-required'),
                },
                // oetPortPrnName: {
                //     "required": $('#oetPortPrnName').attr('data-validate-required'),
                // },
            },
            errorElement: "em",
            errorPlacement: function(error, element) {
                error.addClass("help-block");
                if (element.prop("type") === "checkbox") {
                    error.appendTo(element.parent("label"));
                } else {
                    var tCheck = $(element.closest('.form-group')).find('.help-block').length;
                    if (tCheck == 0) {
                        error.appendTo(element.closest('.form-group')).trigger('change');
                    }
                }
            },
            highlight: function(element, errorClass, validClass) {
                $(element).closest('.form-group').addClass("has-error").removeClass("has-success");
            },
            unhighlight: function(element, errorClass, validClass) {
                $(element).closest('.form-group').addClass("has-success").removeClass("has-error");
            },

            submitHandler: function(form) {
                if($('#ohdPDSBarResult').val()==0){
                            $.ajax({
                                type: "POST",
                                url: ptRoute,
                                data: $('#ofmAddPDS').serialize(),
                                cache: false,
                                timeout: 0,
                                success: function(tResult) {
                                    if (nStaPDSBrowseType != 1) {
                                        var aReturn = JSON.parse(tResult);
                                        if (aReturn['nStaEvent'] == 1) {
                                            if (aReturn['nStaCallBack'] == '1' || aReturn['nStaCallBack'] == null) {
                                                JSvPDSCallPageEdit(aReturn['tCodeReturn'])
                                            } else if (aReturn['nStaCallBack'] == '2') {
                                                JSvPDSCallPageAdd();
                                            } else if (aReturn['nStaCallBack'] == '3') {
                                                JSvPDSCallPageList();
                                            }
                                        } else {
                                            alert(aReturn['tStaMessg']);
                                        }
                                    } else {
                                        JCNxCloseLoading();
                                        JCNxBrowseData(tCallPDSBackOption);
                                    }
                                },
                                error: function(jqXHR, textStatus, errorThrown) {
                                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                                }
                            });
                }else{
                    var tValidatefale = $('#obtSubmitPDS').data('validatefale');
                    FSvCMNSetMsgErrorDialog(tValidatefale);
                }
            },

        });
    }
}




function JSxPDSAddUpdateInTable(ptRoute) {
    $.ajax({
        type: "POST",
        url: ptRoute,
        data: $('#ofmAddPDS').serialize(),
        cache: false,
        timeout: 0,
        success: function(tResult) {
            if (nStaPDSBrowseType != 1) {
                var aReturn = JSON.parse(tResult);
                if (aReturn['nStaEvent'] == 1) {
                    if (aReturn['nStaCallBack'] == '1' || aReturn['nStaCallBack'] == null) {
                        JSvPDSCallPageEdit(aReturn['tCodeReturn'],aReturn['tCodeReturn2'])
                    } else if (aReturn['nStaCallBack'] == '2') {
                        JSvPDSCallPageAdd();
                    } else if (aReturn['nStaCallBack'] == '3') {
                        JSvPDSCallPageList();
                    }
                } else {
                    alert(aReturn['tStaMessg']);
                }
            } else {
                JCNxCloseLoading();
                JCNxBrowseData(tCallPDSBackOption);
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            JCNxResponseError(jqXHR, textStatus, errorThrown);
        }
    });
}


/*============================= End Form Validate ============================*/

/**
 * Functionality : Function Clear Defult Button PDS
 * Parameters : -
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : -
 * Return Type : -
 */
function JSxPDSNavDefult() {
    try {
        if (nStaPDSBrowseType != 1 || nStaPDSBrowseType == undefined) {
            $('.obtChoose').hide();
            $('#oliPDSTitleAdd').hide();
            $('#oliPDSTitleEdit').hide();
            $('#odvPDSMainMenu #odvBtnAddEdit').hide();
            $('#odvPDSMainMenu #odvBtnPDSInfo').show();
        } else {
            $('#odvModalBody #odvPDSMainMenu').removeClass('main-menu');
            $('#odvModalBody #oliPDSNavBrowse').css('padding', '2px');
            $('#odvModalBody #odvPDSBtnGroup').css('padding', '0');
            $('#odvModalBody .xCNPDSBrowseLine').css('padding', '0px 0px');
            $('#odvModalBody .xCNPDSBrowseLine').css('border-bottom', '1px solid #e3e3e3');
        }
    } catch (err) {
        console.log('JSxPDSNavDefult Error: ', err);
    }
}

/**
 * Functionality : Function Show Event Error
 * Parameters : Error Ajax Function
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : Modal Status Error
 * Return Type : view
 */
function JCNxResponseError(jqXHR, textStatus, errorThrown) {
    try {
        JCNxCloseLoading();
        var tHtmlError = $(jqXHR.responseText);
        var tMsgError = "<h3 style='font-size:20px;color:red'>";
        tMsgError += "<i class='fa fa-exclamation-triangle'></i>";
        tMsgError += " Error<hr></h3>";
        switch (jqXHR.status) {
            case 404:
                tMsgError += tHtmlError.find('p:nth-child(2)').text();
                break;
            case 500:
                tMsgError += tHtmlError.find('p:nth-child(3)').text();
                break;

            default:
                tMsgError += 'something had error. please contact admin';
                break;
        }
        $("body").append(tModal);
        $('#modal-customs').attr("style", 'width: 450px; margin: 1.75rem auto;top:20%;');
        $('#myModal').modal({ show: true });
        $('#odvModalBody').html(tMsgError);
    } catch (err) {
        console.log('JCNxResponseError Error: ', err);
    }
}

/**
 * Functionality : Call PDS Page list
 * Parameters : {params}
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : view
 * Return Type : view
 */
function JSvPDSCallPageList() {
    try {
        localStorage.tStaPageNow = 'JSvCallPagePDSList';
        $('#oetSearchAll').val('');
        $.ajax({
            type: "POST",
            url: "settingpdtscaleList",
            cache: false,
            timeout: 0,
            success: function(tResult) {
                $('#odvContentPagePDS').html(tResult);
                JSvPDSDataTable();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    } catch (err) {
        console.log('JSvCallPagePDS Error: ', err);
    }
}

/**
 * Functionality : Call Recive Data List
 * Parameters : Ajax Success Event
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : view
 * Return Type : view
 */
function JSvPDSDataTable(pnPage) {
    try {
        var tSearchAll = $('#oetSearchAll').val();
        var nPageCurrent = pnPage;
        if (nPageCurrent == undefined || nPageCurrent == '') {
            nPageCurrent = '1';
        }
        JCNxOpenLoading();
        $.ajax({
            type: "POST",
            url: "settingpdtscaleDataTable",
            data: {
                tSearchAll: tSearchAll,
                nPageCurrent: nPageCurrent
            },
            cache: false,
            Timeout: 5000,
            success: function(tResult) {
                if (tResult != "") {
                    $('#ostDataPDS').html(tResult);
                }
                JSxPDSNavDefult();
                JCNxLayoutControll();
                JStCMMGetPanalLangHTML('TCNMUsrDepart_L'); //โหลดภาษาใหม่
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    } catch (err) {
        console.log('JSvPDSDataTable Error: ', err);
    }
}

/**
 * Functionality : Call PDS Page Add
 * Parameters : {params}
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : view
 * Return Type : view
 */
function JSvPDSCallPageAdd() {
    try {
        JCNxOpenLoading();
        // JStCMMGetPanalLangSystemHTML('', '');
        $.ajax({
            type: "POST",
            url: "settingpdtscalePageAdd",
            cache: false,
            timeout: 0,
            success: function(tResult) {
                if (nStaPDSBrowseType == 1) {
                    $('#odvModalBodyBrowse .panel-body').css('padding-top', '0');
                    $('#odvModalBodyBrowse').html(tResult);
                } else {
                    $('#odvPDSMainMenu #oliPDSTitleEdit').hide();
                    $('#odvPDSMainMenu #odvBtnPDSInfo').hide();
                    $('#odvPDSMainMenu #oliPDSTitleAdd').show();
                    $('#odvPDSMainMenu #odvBtnAddEdit').show();
                    $('#odvContentPagePDS').html(tResult);
                }
                JCNxLayoutControll();
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    } catch (err) {
        console.log('JSvPDSCallPageAdd Error: ', err);
    }
}

/**
 * Functionality : Call PDS Page Edit
 * Parameters : {params}
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : view
 * Return Type : view
 */
function JSvPDSCallPageEdit(ptPDSCode,ptAgnCode) {
    try {
        JCNxOpenLoading();
        // JStCMMGetPanalLangSystemHTML('JSvPDSCallPageEdit', ptPDSCode);

        $.ajax({
            type: "POST",
            url: "settingpdtscalePageEdit",
            data: { tPDSCode: ptPDSCode , tAgnCode:ptAgnCode },
            cache: false,
            timeout: 0,
            success: function(tResult) {
                if (tResult != '') {
                    $('#oliPDSTitleAdd').hide();
                    $('#oliPDSTitleEdit').show();
                    $('#odvBtnPDSInfo').hide();
                    $('#odvBtnAddEdit').show();
                    $('#odvContentPagePDS').html(tResult);
                    $('#oetPDSCode').addClass('xCNDisable');
                    $('.xCNDisable').attr('readonly', true);
                }
                JCNxLayoutControll();
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    } catch (err) {
        console.log('JSvPDSCallPageEdit Error: ', err);
    }
}

/**
 * Functionality : Generate Code PDS
 * Parameters : {params}
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : data
 * Return Type : string
 */
function JStGeneratePDSCode() {
    try {
        var tTableName = 'TCNMPrnServer';
        $.ajax({
            type: "POST",
            url: "generateCode",
            data: { tTableName: tTableName },
            cache: false,
            timeout: 0,
            success: function(tResult) {
                var tData = $.parseJSON(tResult);
                if (tData.rtCode == '1') {
                    $('#oetPDSCode').val(tData.rtCgpCode);
                    $('#oetPDSCode').addClass('xCNDisable');
                    $('.xCNDisable').attr('readonly', true);
                    //----------Hidden ปุ่ม Gen
                    $('.xCNiConGen').attr('disabled', true);
                } else {
                    $('#oetPDSCode').val(tData.rtDesc);
                }
                $('#oetPDSName').focus();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    } catch (err) {
        console.log('JStGeneratePDSCode Error: ', err);
    }
}

/**
 * Functionality : Check PDS Code In DB
 * Parameters : {params}
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : status, message
 * Return Type : string
 */
function JStCheckPDSCode() {
    try {
        var tCode = $('#oetPDSCode').val();
        var tTableName = 'TCNMPrnServer';
        var tFieldName = 'FTSrvCode';
        if (tCode != '') {
            $.ajax({
                type: "POST",
                url: "CheckInputGenCode",
                data: {
                    tTableName: tTableName,
                    tFieldName: tFieldName,
                    tCode: tCode
                },
                cache: false,
                success: function(tResult) {
                    var tData = $.parseJSON(tResult);
                    $('.btn-default').attr('disabled', true);
                    if (tData.rtCode == '1') { //มี Code นี้ในระบบแล้ว จะส่งไปหน้า Edit
                        alert('มี id นี้แล้วในระบบ');
                        JSvPDSCallPageEdit(tCode);
                    } else {
                        alert('ไม่พบระบบจะ Gen ใหม่');
                        JStGeneratePDSCode();
                    }
                    $('.wrap-input100').removeClass('alert-validate');
                    $('.btn-default').attr('disabled', false);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });
        }
    } catch (err) {
        console.log('JStCheckPDSCode Error: ', err);
    }
}

/**
 * Functionality : Set data on select multiple, use in table list main page
 * Parameters : -
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : -
 * Return Type : -
 */
function JSxPDSSetDataBeforeDelMulti() { // Action start after delete all button click.
    try {
        var oChecked = $('#odvPDSList td input:checked');
        var tValue = '';
        $(oChecked).each(function(pnIndex) {
            tValue += '';
        });
        var tConfirm = $('#ohdDeleteChooseconfirm').val();
        $('#ospConfirmDelete').text(tConfirm + tValue);
    } catch (err) {
        console.log('JSxPDSSetDataBeforeDelMulti Error: ', err);
    }
}

/**
 * Functionality : Delete one select
 * Parameters : poElement is Itself element, poEvent is Itself event
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : -
 * Return Type : -
 */
function JSaPDSDelete(poElement = null, poEvent = null) {
    try {
        var nCheckedCount = $('#odvPDSList td input:checked').length;

        var tValue = $(poElement).parents('tr.otrPDS').find('td.otdPDSCode').text();
        var tValueName = $(poElement).parents('tr.otrPDS').find('td.otdPDSName').text();
        var tValue2 = $(poElement).parents('tr.otrPDS').find('td.otdPDSCode').data('agncode');
        var tConfirm = $('#ohdDeleteconfirm').val();
        var tConfirmYN = $('#ohdDeleteconfirmYN').val();
        $('#ospConfirmDelete').text(tConfirm + ' ' + tValue + ' (' + tValueName + ')' + tConfirmYN);
        $('#ospCode').val(tValue);
        $('#ospCode2').val(tValue2);
        if (nCheckedCount <= 1) {
            $('#odvModalDelPDS').modal('show');
        }
    } catch (err) {
        console.log('JSaPDSDelete Error: ', err);
    }
}

/**
 * Functionality : Confirm delete
 * Parameters : -
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : -
 * Return Type : -
 */
function JSnPDSDelChoose() {
    try {
        JCNxOpenLoading();

        var nCheckedCount = $('#odvPDSList td input:checked').length;
        if (nCheckedCount > 1) { // For mutiple delete

            var oChecked = $('#odvPDSList td input:checked');
            var aPDSCode = [];
            var aAgnCode = [];
            $(oChecked).each(function(pnIndex) {
                aPDSCode[pnIndex] = $(this).parents('tr.otrPDS').find('td.otdPDSCode').text();
                aAgnCode[pnIndex] = $(this).parents('tr.otrPDS').find('td.otdPDSCode').data('agncode');
            });

            $.ajax({
                type: "POST",
                url: "settingpdtscaleDeleteMulti",
                data: { tPDSCode: JSON.stringify(aPDSCode), tAgnCode:JSON.stringify(aAgnCode)},
                success: function(tResult) {
                    $('#odvModalDelPDS').modal('hide');
                    JSvPDSDataTable();
                    JSxPDSNavDefult();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });

        } else { // For single delete

            var tPDSCode = $('#ospCode').val();
            var tAgnCode = $('#ospCode2').val();
            // alert("=="+tPDSCode);
            $.ajax({
                type: "POST",
                url: "settingpdtscaleDelete",
                data: { tPDSCode: tPDSCode , tAgnCode : tAgnCode},
                success: function(tResult) {
                    $('#odvModalDelPDS').modal('hide');
                    JSvPDSDataTable();
                    JSxPDSNavDefult();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });


        }
        JCNxCloseLoading();
    } catch (err) {
        console.log('JSnPDSDelChoose Error: ', err);
    }
}

/**
 * Functionality : Pagenation changed
 * Parameters : -
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : view
 * Return Type : view
 */
function JSvPDSClickPage(ptPage) {
    try {
        var nPageCurrent = '';
        var nPageNew;
        switch (ptPage) {
            case 'next': //กดปุ่ม Next
                $('.xWBtnNext').addClass('disabled');
                nPageOld = $('.xWPagePDS .active').text(); // Get เลขก่อนหน้า
                nPageNew = parseInt(nPageOld, 10) + 1; // +1 จำนวน
                nPageCurrent = nPageNew;
                break;
            case 'previous': //กดปุ่ม Previous
                nPageOld = $('.xWPagePDS .active').text(); // Get เลขก่อนหน้า
                nPageNew = parseInt(nPageOld, 10) - 1; // -1 จำนวน
                nPageCurrent = nPageNew;
                break;
            default:
                nPageCurrent = ptPage;
        }
        JSvPDSDataTable(nPageCurrent);
    } catch (err) {
        console.log('JSvPDSClickPage Error: ', err);
    }
}



/**
 * Functionality : Is update page.
 * Parameters : -
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : Status true is update page
 * Return Type : Boolean
 */
function JCNPDSIsUpdatePage() {
    try {
        const tPDSCode = $('#oetPDSCode').data('is-created');
        var bStatus = false;
        if (tPDSCode != "") { // No have data
            bStatus = true;
        }
        return bStatus;
    } catch (err) {
        console.log('JCNPDSIsUpdatePage Error: ', err);
    }
}

/**
 * Functionality : Show or hide delete all button
 * Show on multiple selections, Hide on one or none selection 
 * Use in table list main page
 * Parameters : poElement is Itself element, poEvent is Itself event
 * Creator : 20/12/2021 Worakorn
 * Last Modified : -
 * Return : -
 * Return Type : -
 */
function JSxPDSVisibledDelAllBtn(poElement = null, poEvent = null) { // Action start after change check box value.
    try {
        var nCheckedCount = $('#odvPDSList td input:checked').length;
        if (nCheckedCount > 1) {
            $('#oliBtnDeleteAll').removeClass("disabled");
        } else {
            $('#oliBtnDeleteAll').addClass("disabled");
        }
    } catch (err) {
        console.log('JSxPDSVisibledDelAllBtn Error: ', err);
    }
}

// Functionality: Function Check Is Create Page
// Parameters: Event Documet Redy
// Creator: 20/12/2021 Worakorn
// Return: object Status Delete
// ReturnType: boolean
function JSbPDSIsCreatePage() {
    try {
        const tPDSCode = $('#oetPDSCode').data('is-created');
        var bStatus = false;
        if (tPDSCode == "") { // No have data
            bStatus = true;
        }
        return bStatus;
    } catch (err) {
        console.log('JSbPDSIsCreatePage Error: ', err);
    }
}

// Functionality: Function Check Is Update Page
// Parameters: Event Documet Redy
// Creator: 20/12/2021 Worakorn
// Return: object Status Delete
// ReturnType: boolean
function JSbPDSIsUpdatePage() {
    try {
        const tPDSCode = $('#oetPDSCode').data('is-created');
        var bStatus = false;
        if (!tPDSCode == "") { // Have data
            bStatus = true;
        }
        return bStatus;
    } catch (err) {
        console.log('JSbVoucherIsUpdatePage Error: ', err);
    }
}

// Functionality : Show or Hide Component
// Parameters : ptComponent is element on document(id or class or...),pbVisible is visible
// Creator : 20/12/2021 Worakorn
// Return : -
// Return Type : -
function JSxPDSVisibleComponent(ptComponent, pbVisible, ptEffect) {
    try {
        if (pbVisible == false) {
            $(ptComponent).addClass('hidden');
        }
        if (pbVisible == true) {
            // $(ptComponent).removeClass('hidden');
            $(ptComponent).removeClass('hidden fadeIn animated').addClass('fadeIn animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $(this).removeClass('hidden fadeIn animated');
            });
        }
    } catch (err) {
        console.log('JSxVoucherVisibleComponent Error: ', err);
    }
}