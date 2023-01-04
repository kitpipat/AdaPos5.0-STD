var nStaFrmBrowseType = $('#oetFrmStaBrowse').val();
var tCallFrmBackOption = $('#oetFrmCallBackOption').val();

$('ducument').ready(function() {
    localStorage.removeItem('LocalItemData');
    JSxCheckPinMenuClose(); /*Check เปิดปิด Menu ตาม Pin*/
    JSxFrmNavDefult();
    if (nStaFrmBrowseType != 1) {
        JSvCallPageFormsList();
    } else {
        JSvCallPageFormsAdd();
    }
});

///function : Function Clear Defult Button Forms
//Parameters : -
//Creator : 08/05/2018 wasin
//Update:   28/05/2018 wasin
//Return : -
//Return Type : -
function JSxFrmNavDefult() {
    // Menu Bar เข้ามาจาก หน้า Master หรือ Browse
    if (nStaFrmBrowseType != 1) { // เข้ามาจาก  Master
        $('.obtChoose').hide();
        $('#oliFrmTitleAdd').hide();
        $('#oliFrmTitleEdit').hide();
        $('#odvBtnFrmAddEdit').hide();
        $('#odvBtnFrmInfo').show();
    } else { // เข้ามาจาก Browse Modal
        $('#odvModalBody #odvFrmMainMenu').removeClass('main-menu');
        $('#odvModalBody #oliFrmNavBrowse').css('padding', '2px');
        $('#odvModalBody #odvFrmBtnGroup').css('padding', '0');
        $('#odvModalBody .xCNFrmBrowseLine').css('padding', '0px 0px');
        $('#odvModalBody .xCNFrmBrowseLine').css('border-bottom', '1px solid #e3e3e3');
    }
}

///function : Call Forms Page list  
//Parameters : - 
//Creator:	08/05/2018 wasin
//Update:   28/05/2018 wasin
//Return : View
//Return Type : View
function JSvCallPageFormsList(pnPage) {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        localStorage.tStaPageNow = 'JSvCallPageFormsList';
        $('#oetSearchAll').val('');
        $.ajax({
            type: "POST",
            url: "formsList",
            cache: false,
            timeout: 0,
            success: function(tResult) {
                $('#odvContentPageForms').html(tResult);
                JSvFormsDataTable(pnPage);
            },
            error: function(data) {
                console.log(data);
            }
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
}

///function : Call Forms Data List
//Parameters : Ajax Success Event 
//Creator:	28/05/2018 wasin
//Update:   
//Return : View
//Return Type : View
function JSvFormsDataTable(pnPage) {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        var tSearchAll = $('#oetSearchAll').val();
        var nPageCurrent = pnPage;
        if (nPageCurrent == undefined || nPageCurrent == '') {
            nPageCurrent = '1';
        }
        JCNxOpenLoading();
        $.ajax({
            type: "POST",
            url: "formsDataTable",
            data: {
                tSearchAll: tSearchAll,
                nPageCurrent: nPageCurrent,
            },
            cache: false,
            Timeout: 0,
            success: function(tResult) {
                if (tResult != "") {
                    $('#ostDataReasion').html(tResult);
                }
                JSxFrmNavDefult();
                JCNxLayoutControll();
                // JStCMMGetPanalLangHTML('TCNMFrm_L'); //โหลดภาษาใหม่
                JCNxCloseLoading();
            },
            error: function(data) {
                console.log(data);
            }
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
}

//Functionality : Call Forms Page Add  
//Parameters : -
//Creator : 09/05/2018 wasin
//Update: 28/05/2018 wasin(yoshi)
//Return : View
//Return Type : View
function JSvCallPageFormsAdd() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JCNxOpenLoading();
        JStCMMGetPanalLangSystemHTML('', '');
        $.ajax({
            type: "POST",
            url: "formsPageAdd",
            cache: false,
            timeout: 0,
            success: function(tResult) {
                if (nStaFrmBrowseType == 1) {
                    $('#odvModalBodyBrowse').html(tResult);
                    $('#odvModalBodyBrowse .panel-body').css('padding-top', '0');
                } else {
                    $('.xCNFrmVBrowse').hide();
                    $('.xCNFrmVMaster').show();
                    $('#oliFrmTitleEdit').hide();
                    $('#oliFrmTitleAdd').show();
                    $('#odvBtnFrmInfo').hide();
                    $('#odvBtnFrmAddEdit').show();
                }
                $('#odvContentPageForms').html(tResult);
                JCNxLayoutControll();
                JCNxCloseLoading();
            },
            error: function(data) {
                console.log(data);
            }
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
}

//Functionality : Call Forms Page Edit  
//Parameters : -
//Creator: 09/05/2018 wasin(yoshi)
//Update: 28/05/2018 wasin(yoshi)
//Return : View
//Return Type : View
function JSvCallPageFormsEdit(ptFrmCode) {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JCNxOpenLoading();
        JStCMMGetPanalLangSystemHTML('JSvCallPageFormsEdit', ptFrmCode);
        $.ajax({
            type: "POST",
            url: "formsPageEdit",
            data: { tFrmCode: ptFrmCode },
            cache: false,
            timeout: 0,
            success: function(tResult) {
                if (tResult != "") {
                    $('#oliFrmTitleAdd').hide();
                    $('#oliFrmTitleEdit').show();
                    $('#odvBtnFrmInfo').hide();
                    $('#odvBtnFrmAddEdit').show();
                    $('#odvContentPageForms').html(tResult);
                    $('#oetFrmCode').addClass('xCNDisable');
                    $('.xCNDisable').attr('readonly', true);
                    $('.xCNiConGen').attr('disabled', true);
                }
                JCNxLayoutControll();
                JCNxCloseLoading();
            },
            error: function(data) {
                console.log(data);
            }
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
}

//Functionality: Set Status Click Validate
//Parameters: -
//Creator: 25/03/2019 wasin(Yoshi)
//Return: -
//ReturnType: -
function JSxFrmSetStatusClickSubmit() {
    $("#ohdCheckFrmClearValidate").val("1");
}

//Functionality : (event) Add/Edit Forms
//Parameters : form
//Creator : 09/05/2018 wasin
//Return : object Status Event And Event Call Back
//Return Type : object
function JSnAddEditForms(ptRoute) {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        $('#ofmAddForms').validate().destroy();

        $.validator.addMethod('dublicateCode', function(value, element) {
            if (ptRoute == "formsEventAdd") {
                if ($("#ohdCheckDuplicateFrmCode").val() == 1) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return true;
            }
        }, '');


        $('#ofmAddForms').validate({
            rules: {
                oetFrmCode: {
                    "required": {
                        depends: function(oElement) {
                            if (ptRoute == "formsEventAdd") {
                                if ($('#ocbFormsAutoGenCode').is(':checked')) {
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
                oetFrmName: { "required": {} },
                oetFrmAgnName: { "required": {} },
                oetFrmRfsName: { "required": {} },
            },
            messages: {
                oetFrmCode: {
                    "required": $('#oetFrmCode').attr('data-validate-required'),
                    "dublicateCode": $('#oetFrmCode').attr('data-validate-dublicateCode')
                },
                oetFrmAgnName: {
                    "required": $('#oetFrmAgnName').attr('data-validate-required'),
                },
                oetFrmName: {
                    "required": $('#oetFrmName').attr('data-validate-required'),
                },
                oetFrmRfsName: {
                    "required": $('#oetFrmRfsName').attr('data-validate-required'),
                }
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
                var nStaCheckValid = $(element).parents('.form-group').find('.help-block').length
                if (nStaCheckValid != 0) {
                    $(element).closest('.form-group').addClass("has-success").removeClass("has-error");
                }
            },
            submitHandler: function(form) {
                JCNxOpenLoading();
                var oFormdata = new FormData($('#ofmAddForms')[0]);
                $.ajax({
                    type: "POST",
                    url: ptRoute,
                    data: oFormdata,
                    async: false,
                    cache: false,
                    processData: false,
                    contentType: false,
                    timeout: 0,
                    success: function(tResult) {
                        if (nStaFrmBrowseType != 1) {
                            var aReturn = JSON.parse(tResult);
                            if (aReturn['nStaEvent'] == 1) {
                                if (aReturn['nStaCallBack'] == '1' || aReturn['nStaCallBack'] == null) {
                                    JSvCallPageFormsEdit(aReturn['tCodeReturn']);
                                } else if (aReturn['nStaCallBack'] == '2') {
                                    JSvCallPageFormsAdd();
                                } else if (aReturn['nStaCallBack'] == '3') {
                                    JSvCallPageFormsList();
                                }
                            } else {
                                FSvCMNSetMsgWarningDialog(aReturn['tStaMessg']);
                                JCNxCloseLoading();
                            }
                        } else {
                            JCNxCloseLoading();
                            JCNxBrowseData(tCallFrmBackOption);
                        }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        JCNxResponseError(jqXHR, textStatus, errorThrown);
                    }
                });
            }
        });
    } else {
        JCNxShowMsgSessionExpired();
    }
}

//Functionality: เปลี่ยนหน้า pagenation
//Parameters: -
//Creator: 09/05/2018 wasin
//Update: 28/05/2018 wasin
//Return: View
//Return Type: View
function JSvClickPage(ptPage) {
    var nPageCurrent = '';
    var nPageNew;
    switch (ptPage) {
        case 'next': //กดปุ่ม Next
            $('.xWBtnNext').addClass('disabled');
            nPageOld = $('.xWPageFormsGrp .active').text(); // Get เลขก่อนหน้า
            nPageNew = parseInt(nPageOld, 10) + 1; // +1 จำนวน
            nPageCurrent = nPageNew;
            break;
        case 'previous': //กดปุ่ม Previous
            nPageOld = $('.xWPageFormsGrp .active').text(); // Get เลขก่อนหน้า
            nPageNew = parseInt(nPageOld, 10) - 1; // -1 จำนวน
            nPageCurrent = nPageNew;
            break;
        default:
            nPageCurrent = ptPage;
    }
    JSvFormsDataTable(nPageCurrent);
}

//Functionality: (event) Delete
//Parameters: Button Event [tIDCode รหัสเหตุผล]
//Creator: 10/05/2018 wasin
//Update: 27/08/2019 Saharata(Golf)
//Return: Event Delete Forms List
//Return Type: -
function JSnFormsDel(pnCurrentPage, ptDelName, ptIDCode, ptYesOnNo) {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        var aData = $('#ohdConfirmIDDelete').val();
        var aTexts = aData.substring(0, aData.length - 2);
        var aDataSplit = aTexts.split(" , ");
        var aDataSplitlength = aDataSplit.length;
        var aNewIdDelete = [];
        if (aDataSplitlength == '1') {
            $('#odvModalDelForms').modal('show');
            // $('#ospConfirmDelete').html($('#oetTextComfirmDeleteSingle').val() + tIDCode);
            $('#ospConfirmDelete').html($('#oetTextComfirmDeleteSingle').val() + ptIDCode + ' ( ' + ptDelName + ' ) ' + ptYesOnNo);
            $('#osmConfirm').on('click', function(evt) {
                if (localStorage.StaDeleteArray != '1') {
                    $.ajax({
                        type: "POST",
                        url: "formsEventDelete",
                        data: { 'tIDCode': ptIDCode },
                        cache: false,
                        success: function(tResult) {
                            var aReturn = JSON.parse(tResult);
                            if (aReturn['nStaEvent'] == 1) {
                                $('#odvModalDelForms').modal('hide');
                                $('#ospConfirmDelete').text($('#oetTextComfirmDeleteSingle').val());
                                $('#ohdConfirmIDDelete').val('');
                                localStorage.removeItem('LocalItemData');
                                $('.modal-backdrop').remove();
                                setTimeout(function() {
                                    if (aReturn["nNumRowFrmLoc"] != 0) {
                                        if (aReturn["nNumRowFrmLoc"] > 10) {
                                            nNumPage = Math.ceil(aReturn["nNumRowFrmLoc"] / 10);
                                            if (pnCurrentPage <= nNumPage) {
                                                JSvCallPageFormsList(pnCurrentPage);
                                            } else {
                                                JSvCallPageFormsList(nNumPage);
                                            }
                                        } else {
                                            JSvCallPageFormsList(1);
                                        }
                                    } else {
                                        JSvCallPageFormsList(1);
                                    }
                                    // JSvBntDataTable(pnPage);
                                    // JSvFormsDataTable(tCurrentPage);
                                }, 500);
                            } else {
                                FSvCMNSetMsgWarningDialog(aReturn['tStaMessg']);
                                //alert(aReturn['tStaMessg']);
                            }
                            JSxFrmNavDefult();
                        },
                        error: function(data) {
                            console.log(data);
                        }
                    });
                }
            });
        }
    } else {
        JCNxShowMsgSessionExpired();
    }
}

//Functionality : (event) Delete All
//Parameters : Button Event 
//Creator : 10/05/2018 wasin
//Update: 28/05/2018 wasin
//Return : Event Delete All Select List
//Return Type : -
function JSnFormsDelChoose(ptCurrentPage) {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JCNxOpenLoading();
        var aData = $('#ohdConfirmIDDelete').val();
        var aTexts = aData.substring(0, aData.length - 2);
        var aDataSplit = aTexts.split(" , ");
        var aDataSplitlength = aDataSplit.length;
        var aNewIdDelete = [];

        for ($i = 0; $i < aDataSplitlength; $i++) {
            aNewIdDelete.push(aDataSplit[$i]);
        }

        if (aDataSplitlength > 1) {
            localStorage.StaDeleteArray = '1';
            $.ajax({
                type: "POST",
                url: "formsEventDelete",
                data: { 'tIDCode': aNewIdDelete },
                success: function(tResult) {
                    var aReturn = JSON.parse(tResult);
                    if (aReturn['nStaEvent'] == '1') {
                        setTimeout(function() {
                            $('#odvModalDelForms').modal('hide');
                            JSvFormsDataTable(ptCurrentPage);
                            $('#ospConfirmDelete').empty();
                            $('#ohdConfirmIDDelete').val();
                            localStorage.removeItem('LocalItemData');
                            $('.modal-backdrop').remove();
                            if (aReturn["nNumRowFrmLoc"] != 0) {
                                if (aReturn["nNumRowFrmLoc"] > 10) {
                                    nNumPage = Math.ceil(aReturn["nNumRowFrmLoc"] / 10);
                                    if (ptCurrentPage <= nNumPage) {
                                        JSvCallPageFormsList(ptCurrentPage);
                                    } else {
                                        JSvCallPageFormsList(nNumPage);
                                    }
                                } else {
                                    JSvCallPageFormsList(1);
                                }
                            } else {
                                JSvCallPageFormsList(1);
                            }
                            // JSvBntDataTable(pnPage);
                            // JSvFormsDataTable(tCurrentPage);
                        }, 1000);
                    } else {
                        alert(aReturn['tStaMessg']);
                    }
                    JSxFrmNavDefult();
                },
                error: function(data) {
                    console.log(data);
                }
            });
        } else {
            localStorage.StaDeleteArray = '0';
            return false;
        }
    } else {
        JCNxShowMsgSessionExpired();
    }
}

//Functionality: Function Show Button Delete All
//Parameters:   Event Parameter
//Creator:  28/05/2018 wasin
//Return: Event Button Delete All
//Return Type: -
function JSxShowButtonChoose() {
    var aArrayConvert = [JSON.parse(localStorage.getItem("LocalItemData"))];
    if (aArrayConvert[0] == null || aArrayConvert[0] == '') {
        $('.obtChoose').hide();
    } else {
        nNumOfArr = aArrayConvert[0].length;
        if (nNumOfArr > 1) {
            $('.obtChoose').fadeIn(300);
        } else {
            $('.obtChoose').fadeOut(300);
        }
    }
}

//Functionality: Function Insert Text Delete
//Parameters: Event Parameter
//Creator: 28/05/2018 wasin
//Return: Event Insert Text
//Return Type: -
function JSxTextinModal() {
    var aArrayConvert = [JSON.parse(localStorage.getItem("LocalItemData"))];

    if (aArrayConvert[0] == null || aArrayConvert[0] == '') {} else {
        var tText = '';
        var tTextCode = '';
        for ($i = 0; $i < aArrayConvert[0].length; $i++) {
            tText += aArrayConvert[0][$i].tName + '(' + aArrayConvert[0][$i].nCode + ') ';
            tText += ' , ';

            tTextCode += aArrayConvert[0][$i].nCode;
            tTextCode += ' , ';
        }
        var tTexts = tText.substring(0, tText.length - 2);
        $('#ospConfirmDelete').text($('#oetTextComfirmDeleteSingle').val() + tTexts);
        $('#ohdConfirmIDDelete').val(tTextCode);
    }
}

//Functionality: Function Chack Dupilcate Data
//Parameters: Event Select List Forms
//Creator: 28/05/2018 wasin
//Return: Duplicate/none
//Return Type: string
function findObjectByKey(array, key, value) {
    for (var i = 0; i < array.length; i++) {
        if (array[i][key] === value) {
            return 'Dupilcate';
        }
    }
    return 'None';
}

//Choose Checkbox
function JSxFormsVisibledDelAllBtn(poElement, poEvent) { // Action start after change check box value.
    try {
        var nCheckedCount = $('#odvRGPList td input:checked').length;
        if (nCheckedCount > 1) {
            $('#oliBtnDeleteAll').removeClass("disabled");
        } else {
            $('#oliBtnDeleteAll').addClass("disabled");
        }
        if (nCheckedCount > 1) {
            $('.xCNIconDel').addClass('xCNDisabled');
        } else {
            $('.xCNIconDel').removeClass('xCNDisabled');
        }
    } catch (err) {
        //console.log('JSxDepartmentVisibledDelAllBtn Error: ', err);
    }
}


//Functionality: Insert Text In Modal Delete
//Parameters: LocalStorage Data
//Creator: 11/10/2018 wasin
//Return: -
//Return Type: -
function JSxPaseCodeDelInModal() {
    var aArrayConvert = [JSON.parse(localStorage.getItem("LocalItemData"))];
    if (aArrayConvert[0] == null || aArrayConvert[0] == '') {} else {
        var tTextCode = '';
        for ($i = 0; $i < aArrayConvert[0].length; $i++) {
            tTextCode += aArrayConvert[0][$i].nCode;
            tTextCode += ' , ';
        }
        $('#ospConfirmDelete').text($('#oetTextComfirmDeleteMulti').val());
        $('#ohdConfirmIDDelete').val(tTextCode);
    }
}


// Functionality: Function Check Is Create Page
// Parameters: Event Documet Redy
// Creator: 22/03/2019 wasin(Yoshi)
// Return: object Status Delete
// ReturnType: boolean
function JSbFormsIsCreatePage() {
    try {
        const tFrmCode = $('#oetFrmCode').data('is-created');
        var bStatus = false;
        if (tFrmCode == "") { // No have data
            bStatus = true;
        }
        return bStatus;
    } catch (err) {
        console.log('JSbFormsIsCreatePage Error: ', err);
    }
}

// Functionality: Function Check Is Update Page
// Parameters: Event Documet Redy
// Creator: 22/03/2019 wasin(Yoshi)
// Return: object Status Delete
// ReturnType: boolean
function JSbFormsIsUpdatePage() {
    try {
        const tFrmCode = $('#oetFrmCode').data('is-created');
        var bStatus = false;
        if (!tFrmCode == "") { // Have data
            bStatus = true;
        }
        return bStatus;
    } catch (err) {
        console.log('JSbFormsIsUpdatePage Error: ', err);
    }
}

// Functionality : Show or Hide Component
// Parameters : ptComponent is element on document(id or class or...),pbVisible is visible
// Creator : 22/03/2019 Wasin (Yoshi)
// Return : -
// Return Type : -
function JSxFormsVisibleComponent(ptComponent, pbVisible, ptEffect) {
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
        console.log('JSxFormsVisibleComponent Error: ', err);
    }
}

// Functionality: Function Check Is Create Page
// Parameters: Event Documet Redy
// Creator: 22/03/2019 wasin(Yoshi)
// Return: object Status Delete
// ReturnType: boolean
function JSbFormsIsCreatePage() {
    try {
        const tFrmCode = $('#oetFrmCode').data('is-created');
        var bStatus = false;
        if (tFrmCode == "") { // No have data
            bStatus = true;
        }
        return bStatus;
    } catch (err) {
        console.log('JSbFormsIsCreatePage Error: ', err);
    }
}

// Functionality: Function Check Is Update Page
// Parameters: Event Documet Redy
// Creator: 22/03/2019 wasin(Yoshi)
// Return: object Status Delete
// ReturnType: boolean
function JSbFormsIsUpdatePage() {
    try {
        const tFrmCode = $('#oetFrmCode').data('is-created');
        var bStatus = false;
        if (!tFrmCode == "") { // Have data
            bStatus = true;
        }
        return bStatus;
    } catch (err) {
        console.log('JSbFormsIsUpdatePage Error: ', err);
    }
}

// Functionality : Show or Hide Component
// Parameters : ptComponent is element on document(id or class or...),pbVisible is visible
// Creator : 22/03/2019 Wasin (Yoshi)
// Return : -
// Return Type : -
function JSxFormsVisibleComponent(ptComponent, pbVisible, ptEffect) {
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
        console.log('JSxFormsVisibleComponent Error: ', err);
    }
}