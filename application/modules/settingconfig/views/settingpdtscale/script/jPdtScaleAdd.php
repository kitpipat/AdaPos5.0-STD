<script type="text/javascript">
    $(document).ready(function() {

        if (JSbPDSIsCreatePage()) {
            //Server Printer Code
            $("#oetPDSCode").attr("disabled", true);
            $('#ocbPDSAutoGenCode').change(function() {
                if ($('#ocbPDSAutoGenCode').is(':checked')) {
                    $('#oetPDSCode').val('');
                    $("#oetPDSCode").attr("disabled", true);
                    $('#odvPDSCodeForm').removeClass('has-error');
                    $('#odvPDSCodeForm em').remove();
                } else {
                    $("#oetPDSCode").attr("disabled", false);
                }
            });
            JSxPDSVisibleComponent('#odvPDSAutoGenCode', true);
        }

        if (JSbPDSIsUpdatePage()) {

            // Server Printer  Code
            $("#oetPDSCode").attr("readonly", true);
            $('#odvPDSAutoGenCode input').attr('disabled', true);
            JSxPDSVisibleComponent('#odvPDSAutoGenCode', false);
        }
    });

    // $('#oetPDSCode').blur(function(){
    //     JSxCheckDepartmentCodeDupInDB();
    // });

    //Functionality : Event Check Server Printer 
    //Parameters : Event Blur Input Server Printer  Code
    //Creator : 21/12/2021 Worakorn
    //Return : -
    //Return Type : -
    function JSxCheckPDSCodeDupInDB(ptRoute) {
        if (!$('#ocbPDSAutoGenCode').is(':checked')) {
            // alert($("#oetPDSCode").val())
            $.ajax({
                type: "POST",
                url: "CheckInputGenCode",
                data: {
                    tTableName: "TCNMPrnServer",
                    tFieldName: "FTSrvCode",
                    tCode: $("#oetPDSCode").val()
                },
                cache: false,
                timeout: 0,
                success: function(tResult) {
                    var aResult = JSON.parse(tResult);
                    $("#ohdCheckDuplicatePDSCode").val(aResult["rtCode"]);
                    // $('#ofmAddPDS').validate().destroy();
                    // Set Validate Server Printer  Code
                    $.validator.addMethod('dublicateCode', function(value, element) {
                        if ($("#ohdCheckDuplicatePDSCode").val() == 1) {
                            return false;
                        } else {
                            return true;
                        }
                    }, '');

                    // From Summit Validate
                    $('#ofmAddPDS').validate({

                        rules: {
                            oetPDSCode: {
                                "required": {
                                    // ตรวจสอบเงื่อนไข validate
                                    depends: function(oElement) {
                                        if ($('#ocbPDSAutoGenCode').is(':checked')) {
                                            return false;
                                        } else {
                                            return true;
                                        }
                                    }
                                },
                                "dublicateCode": {}
                            },
                            oetPDSName: {
                                "required": {}
                            },
                        },
                        messages: {
                            oetPDSCode: {
                                "required": $('#oetPDSCode').attr('data-validate-required'),
                                "dublicateCode": $('#oetPDSCode').attr('data-validate-dublicateCode')
                            },
                            oetPDSName: {
                                "required": $('#oetPDSName').attr('data-validate-required'),
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
                            $(element).closest('.form-group').addClass("has-success").removeClass("has-error");
                        },
                        submitHandler: function(form) {
                            alert('submitHandler');
                            JSxPDSAddUpdateInTable(ptRoute);
                        }
                    });

                    // Submit From
                    $('#ofmAddPDS').submit();

                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });
        }
    }



    
$('#oetPDSCode').blur(function(){
    JSxChecPDSCodeDupInDB();
});

//Functionality : Event Check GroupSupplier
//Parameters : Event Blur Input Voucher Code
//Creator : 29/05/2019 saharat (Golf)
//Return : -
//Return Type : -
function JSxChecPDSCodeDupInDB(){
    if(!$('#ocbPDSAutoGenCode').is(':checked')){
        $.ajax({
            type: "POST",
            url: "CheckInputGenCode",
            data: { 
                tTableName: "TCNMPdtScale",
                tFieldName: "FTPdsCode",
                tCode: $("#oetPDSCode").val()
            },
            cache: false,
            timeout: 0,
            success: function(tResult){
                var aResult = JSON.parse(tResult);
                $("#ohdCheckDuplicatePDSCode").val(aResult["rtCode"]);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    }    
}
</script>