<script type="text/javascript">
    $('.selection-2').selectpicker();

    $(document).ready(function() {
        if (JSbChnIsCreatePage()) {
            // Chn Code
            $("#oetChnCode").attr("disabled", true);
            $('#ocbSlipmessageAutoGenCode').change(function() {
                if ($('#ocbSlipmessageAutoGenCode').is(':checked')) {
                    $('#oetChnCode').val('');
                    $("#oetChnCode").attr("disabled", true);
                    $('#odvSlipmessageCodeForm').removeClass('has-error');
                    $('#odvSlipmessageCodeForm em').remove();
                } else {
                    $("#oetChnCode").attr("disabled", false);
                }
            });
            JSxChnVisibleComponent('#odvSlipmessageAutoGenCode', true);
        }

        if (JSbChnIsUpdatePage()) {
            // Sale Person Code
            $("#oetChnCode").attr("readonly", true);
            $('#odvSlipmessageAutoGenCode input').attr('disabled', true);
            JSxChnVisibleComponent('#odvSlipmessageAutoGenCode', false);
        }

        $('#oetChnCode').blur(function() {
            JSxCheckChnCodeDupInDB();
        });

    });

    //Functionality: Event Check Sale Person Duplicate
    //Parameters: Event Blur Input Sale Person Code
    //Creator: 25/03/2019 wasin (Yoshi)
    //Return: -
    //ReturnType: -
    function JSxCheckChnCodeDupInDB() {
        if (!$('#ocbSlipmessageAutoGenCode').is(':checked')) {
            $.ajax({
                type: "POST",
                url: "CheckInputGenCode",
                data: {
                    tTableName: "TCNMChannel",
                    tFieldName: "FTChnCode",
                    tCode: $("#oetChnCode").val()
                },
                async: false,
                cache: false,
                timeout: 0,
                success: function(tResult) {
                    var aResult = JSON.parse(tResult);
                    $("#ohdCheckDuplicateChnCode").val(aResult["rtCode"]);
                    JSxChnSetValidEventBlur();
                    $('#ofmAddChanel').submit();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });
        }
    }

    //Functionality: Set Validate Event Blur
    //Parameters: Validate Event Blur
    //Creator: 26/03/2019 wasin (Yoshi)
    //Return: -
    //ReturnType: -
    function JSxChnSetValidEventBlur() {
        $('#ofmAddChanel').validate().destroy();

        // Set Validate Dublicate Code
        $.validator.addMethod('dublicateCode', function(value, element) {
            if ($("#ohdCheckDuplicateChnCode").val() == 1) {
                return false;
            } else {
                return true;
            }
        }, '');

        // From Summit Validate
        $('#ofmAddChanel').validate({
            rules: {
                oetChnCode: {
                    "required": {
                        // ตรวจสอบเงื่อนไข validate
                        depends: function(oElement) {
                            if ($('#ocbSlipmessageAutoGenCode').is(':checked')) {
                                return false;
                            } else {
                                return true;
                            }
                        }
                    },
                    "dublicateCode": {}
                },
                oetChnTitle: {
                    "required": {}
                },
                // ocmRcnGroup:    {"required" :{}},
            },
            messages: {
                oetChnCode: {
                    "required": $('#oetChnCode').attr('data-validate-required'),
                    "dublicateCode": $('#oetChnCode').attr('data-validate-dublicateCode')
                },
                oetChnTitle: {
                    "required": $('#oetChnTitle').attr('data-validate-required'),
                }
                // ocmRcnGroup: {
                //     "required"      : $('#osmSelect').attr('data-validate-required'),
                // }
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
            submitHandler: function(form) {}
        });
    }

    // ระบบ
    $('#oimRcvSpcBrowseMrk').click(function() {
        JSxCheckPinMenuClose();
        JCNxBrowseData('oBrowseMrk');
    });

    //Set Lang Edit 
    var nLangEdits = <?php echo $this->session->userdata("tLangEdit")?>;
    // ระบบ
    var oBrowseMrk = {
        Title: ['payment/recivespc/recivespc', 'tBrowseAppTitle'],
        Table: {
            Master: 'TCNSMarket_L',
            PK: 'FTMrkCode'
        },
        Where:{
            Condition: [' AND TCNSMarket_L.FTMrkStaUse = 1 AND TCNSMarket_L.FNLngID = ' + nLangEdits]
        },
        GrideView: {
            ColumnPathLang: 'payment/recivespc/recivespc',
            ColumnKeyLang: ['tBrowseAppCode', 'tBrowseAppName'],
            ColumnsSize: ['15%', '75%'],
            DataColumns: ['TCNSMarket_L.FTMrkCode', 'TCNSMarket_L.FTMrkName'],
            DataColumnsFormat: ['', ''],
            WidthModal: 50,
            Perpage: 10,
            OrderBy: ['TCNSMarket_L.FTMrkCode ASC'],
        },
        CallBack: {
            ReturnType: 'S',
            Value: ["oetRcvSpcMrkCode", "TCNSMarket_L.FTMrkCode"],
            Text: ["oetRcvSpcMrkName", "TCNSMarket_L.FTMrkName"]
        },
        // NextFunc: {
        //     FuncName: 'JSxNextFuncRcvSpc',
        //     ArgReturn: ['FTAppCode']
        // },
    };



// Create By: Napat(Jame) 10/06/2022
function JSxCHNSpcEMarket(){
    $('#ofmAddChanel').validate().destroy();
    $('#ofmAddChanel').validate({
        rules: {
            oetChnCode: {
                "required": {
                    depends: function(oElement) {
                        if (ptRoute == "chanelEventAdd") {
                            if ($('#ocbSlipmessageAutoGenCode').is(':checked')) {
                                return false;
                            } else {
                                return true;
                            }
                        } else {
                            return true;
                        }
                    }
                },
                // "dublicateCode": {}
            },
            oetChnName: { "required": {} },
            oetChnAppName: { "required": {} },
            oetWahBchNameCreated: {
                "required": {
                    depends: function(oElement) {
                        if ( $('#oetChnUsrLoginLevel') != "HQ" && $('#oetChnUsrLoginLevel') != "AGN" ) {
                            return false;
                        } else {
                            return true;
                        }
                    }
                },
            },
            oetRcvSpcMrkName: { "required": {} },
            oetChnAppName: { "required": {} },
            oetChnAppName: { "required": {} },

            // oetWahBchNameCreated: { "required": {} },
            // oetChnAgnName: { "required": {} },
        },
        messages: {
            oetChnCode: {
                "required": $('#oetChnCode').attr('data-validate-required'),
                // "dublicateCode": $('#oetChnCode').attr('data-validate-dublicateCode')
            },

            oetChnName: {
                "required": $('#oetChnName').attr('data-validate-required'),
            },
            oetChnAppName: {
                "required": $('#oetChnAppName').attr('data-validate-required'),
            },
            oetWahBchNameCreated: {
                "required": $('#oetWahBchNameCreated').attr('data-validate-required'),
            },
            oetRcvSpcMrkName: {
                "required": $('#oetRcvSpcMrkName').attr('data-validate-required'),
            },
            // oetChnAgnName: {
            //     "required": $('#oetChnAgnName').attr('data-validate-required'),
            // }
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
            console.log('awd');
            
        },
    });
    $('#ofmAddChanel').submit();

}
</script>