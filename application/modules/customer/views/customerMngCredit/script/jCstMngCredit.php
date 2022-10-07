<script type="text/javascript">
    var nStaMCRBrowseType   = $('#oetMCRStaBrowse').val();
    var tCallMCRBackOption  = $('#oetMCRCallBackOption').val();

    $('document').ready(function(){
        localStorage.removeItem('LocalItemData');
        JSxCheckPinMenuClose(); /*Check เปิดปิด Menu ตาม Pin*/
        JSxMCRNavDefult();
        if (nStaMCRBrowseType != 1) {
            JSvMCRCallPageList();
        } else {
            JSvMCRCallPageAdd();
        }
    });
    
    function JSxMCRNavDefult() {
        if (nStaMCRBrowseType != 1 || nStaMCRBrowseType == undefined) {
            $('.xCNMCRVBrowse').hide();
            $('.xCNMCRVMaster').show();
            $('#oliMCRTitleAdd').hide();
            $('#oliMCRTitleEdit').hide();
            $('#odvBtnAddEdit').hide();
            $('.obtChoose').hide();
            $('#odvBtnMCRInfo').show();
            $('#obtMCRBtnCutOffCstCr').hide();
        } else {
            $('#odvModalBody .xCNMCRVMaster').hide();
            $('#odvModalBody .xCNMCRVBrowse').show();
            $('#odvModalBody #odvMCRMainMenu').removeClass('main-menu');
            $('#odvModalBody #oliMCRNavBrowse').css('padding', '2px');
            $('#odvModalBody #odvMCRBtnGroup').css('padding', '0');
            $('#odvModalBody .xCNMCRBrowseLine').css('padding', '0px 0px');
            $('#odvModalBody .xCNMCRBrowseLine').css('border-bottom', '1px solid #e3e3e3');
        }
    }

    // Function : Function Show Event Error
    // Parameters : Error Ajax Function 
    // Creator : 17/06/2022 Wasin
    // Return : Modal Status Error
    // Return Type  : view
    function JCNxResponseError(jqXHR, textStatus, errorThrown) {
        JCNxCloseLoading();
        let tHtmlError   = $(jqXHR.responseText);
        let tMsgError    = "<h3 style='font-size:20px;color:red'>";
        tMsgError       += "<i class='fa fa-exclamation-triangle'></i>";
        tMsgError       += " Error<hr></h3>";
        switch (jqXHR.status) {
            case 404:
                tMsgError   += tHtmlError.find('p:nth-child(2)').text();
                break;
            case 500:
                tMsgError   += tHtmlError.find('p:nth-child(3)').text();
                break;
            default:
                tMsgError   += 'something had error. please contact admin';
                break;
        }
        $("body").append(tModal);
        $('#modal-customs').attr("style", 'width: 450px; margin: 1.75rem auto;top:20%;');
        $('#myModal').modal({ show: true });
        $('#odvModalBody').html(tMsgError);
    }


    // Function : Function Call Page List Customer Credit
    // Parameters : Error Ajax Function 
    // Creator : 17/06/2022 Wasin
    // Return : View Table List
    // Return Type  : view
    function JSvMCRCallPageList() {
        localStorage.tStaPageNow    = 'JSvCallPageMCRList';
        $.ajax({
            type : "GET",
            url : "cstMngCreditList",
            data : {},
            cache : false,
            timeout : 5000,
            success: function(tResult) {
                $('#odvContentPageMCR').html(tResult);
                JSxMCRNavDefult();
                JSvMCRCallPageDataTable();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    }

    // function : Call Customer Credit Data List
    // Parameters : Ajax Success Event 
    // Creator:	17/06/2022 wasin
    // Return : View Data List
    // Return Type : View
    function JSvMCRCallPageDataTable(pnPage){
        let tSearchAll      = $('#oetSearchAll').val();
        let nPageCurrent    = pnPage;
        if (nPageCurrent == undefined || nPageCurrent == '') {
            nPageCurrent    = '1';
        }
        JCNxOpenLoading();
        $.ajax({
            type : "POST",
            url : "cstMngCreditDataTable",
            data : {
                tSearchAll : tSearchAll,
                nPageCurrent: nPageCurrent,
            },
            cache   : false,
            Timeout : 0,
            success: function(tResult) {
                if (tResult != "") {
                    $('#odvContentMCRData').html(tResult);
                }
                JSxMCRNavDefult();
                JCNxLayoutControll();
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    }

    // function : Call Customer Credit Page
    // Parameters : Ajax Success Event
    // Creator:	17/06/2022 wasin
    // Return : View Page Edit
    // Return Type : View
    function JSvMCRCallPageEdit(tCstCode){
        let nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            JCNxOpenLoading();
            $.ajax({
                type    : "POST",
                url     : "cstMngCreditPageEdit",
                data    : {tCstCode: tCstCode,},
                cache   : false,
                Timeout : 0,
                success: function(tResult) {
                    if(tResult != "") {
                        $('#oliMCRTitleAdd').hide();
                        $('#odvBtnMCRInfo').hide();
                        $('#oliMCRTitleEdit').show();
                        $('#odvBtnAddEdit').show();
                        $('#odvContentPageMCR').html(tResult);
                    }
                    JCNxLayoutControll();
                    JCNxCloseLoading();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });
        }else{
            JCNxShowMsgSessionExpired();
        }
    }

    // function : Event Add / Update Function 
    // Parameters : Ajax Success Event
    // Creator:	17/06/2022 wasin
    // Return : View Page Edit
    // Return Type : View
    function JSxMCRAddEditForm(){
        let nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            $('#ofmMCRAddForm').validate({
                rules : {
                    oetMCRCstCode   : { "required": {} },
                },
                messages: {
                    oetMCRCstCode: {
                        "required": $('#oetMCRCstCode').attr('data-validate-required'),
                    },
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
                    $.ajax({
                        type    : "POST",
                        url     : "cstMngCreditEventAddOrUpd",
                        data    : $('#ofmMCRAddForm').serialize(),
                        async   : false,
                        cache   : false,
                        timeout : 0,
                        success: function(tResult) {
                            var aReturn = JSON.parse(tResult);
                            if (aReturn['nStaEvent'] == 1) {
                                if (aReturn['nStaCallBack'] == '1' || aReturn['nStaCallBack'] == null) {
                                    JSvMCRCallPageEdit(aReturn['tCodeReturn']);
                                } else if (aReturn['nStaCallBack'] == '2') {
                                    JSvMCRCallPageEdit(aReturn['tCodeReturn']);
                                } else if (aReturn['nStaCallBack'] == '3') {
                                    JSvMCRCallPageList();
                                }
                            } else {
                                JCNxCloseLoading();
                                FSvCMNSetMsgErrorDialog(aReturn['tStaMessg']);
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            JCNxResponseError(jqXHR, textStatus, errorThrown);
                        }
                    });
                }
            });          
        }else{
            JCNxShowMsgSessionExpired();
        }
    }






</script>