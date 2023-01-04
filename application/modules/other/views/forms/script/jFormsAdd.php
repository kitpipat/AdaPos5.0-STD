<script type="text/javascript">
    $('.selection-2').selectpicker();

    $('#ocmRcnGroup').change(function() {
        $('#ocmRcnGroup-error').hide();
    });

    $(document).ready(function () {
        if(JSbFormsIsCreatePage()){
            // Forms Code
            $("#oetFrmCode").attr("disabled", true);
            $('#ocbFormsAutoGenCode').change(function(){
                if($('#ocbFormsAutoGenCode').is(':checked')) {
                    $('#oetFrmCode').val('');
                    $("#oetFrmCode").attr("disabled", true);
                    $('#odvFormsCodeForm').removeClass('has-error');
                    $('#odvFormsCodeForm em').remove();
                }else{
                    $("#oetFrmCode").attr("disabled", false);
                }
            });
            JSxFormsVisibleComponent('#odvFormsAutoGenCode', true);
        }

        if(JSbFormsIsUpdatePage()){
            // Sale Person Code
            $("#oetFrmCode").attr("readonly", true);
            $('#odvFormsAutoGenCode input').attr('disabled', true);
            JSxFormsVisibleComponent('#odvFormsAutoGenCode', false);    
        }

        $('#oetFrmCode').blur(function(){
            JSxCheckFormsCodeDupInDB();
        });
        if($('#oetFrmRfsCode').val()!=''){
            FSxFRMGetUrlEditForm($('#oetFrmRfsCode').val());
        }
    });

    //Functionality: Event Check Sale Person Duplicate
    //Parameters: Event Blur Input Sale Person Code
    //Creator: 25/03/2019 wasin (Yoshi)
    //Return: -
    //ReturnType: -
    function JSxCheckFormsCodeDupInDB(){
        if(!$('#ocbFormsAutoGenCode').is(':checked')){
            $.ajax({
                type: "POST",
                url: "CheckInputGenCode",
                data: { 
                    tTableName: "TRPTRptFmtUsr",
                    tFieldName: "FTRfuCode",
                    tCode: $("#oetFrmCode").val()
                },
                async : false,
                cache: false,
                timeout: 0,
                success: function(tResult){
                    var aResult = JSON.parse(tResult);
                    $("#ohdCheckDuplicateRsnCode").val(aResult["rtCode"]);
                    JSxFormsSetValidEventBlur();
                    $('#ofmAddForms').submit();
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
    function JSxFormsSetValidEventBlur(){
        $('#ofmAddForms').validate().destroy();

        // Set Validate Dublicate Code
        $.validator.addMethod('dublicateCode', function(value, element) {
            if($("#ohdCheckDuplicateRsnCode").val() == 1){
                return false;
            }else{
                return true;
            }
        },'');

        // From Summit Validate
        $('#ofmAddForms').validate({
            rules: {
                oetFrmCode : {
                    "required" :{
                        // ตรวจสอบเงื่อนไข validate
                        depends: function(oElement) {
                            if($('#ocbFormsAutoGenCode').is(':checked')){
                                return false;
                            }else{
                                return true;
                            }
                        }
                    },
                    "dublicateCode" :{}
                },
                oetFrmName:     {"required" :{}},
                ocmRcnGroup:    {"required" :{}},
            },
            messages: {
                oetFrmCode : {
                    "required"      : $('#oetFrmCode').attr('data-validate-required'),
                    "dublicateCode" : $('#oetFrmCode').attr('data-validate-dublicateCode')
                },
                oetFrmName : {
                    "required"      : $('#oetFrmName').attr('data-validate-required'),
                },
                ocmRcnGroup: {
                    "required"      : $('#osmSelect').attr('data-validate-required'),
                }
            },
            errorElement: "em",
            errorPlacement: function (error, element ) {
                error.addClass( "help-block" );
                if ( element.prop( "type" ) === "checkbox" ) {
                    error.appendTo( element.parent( "label" ) );
                } else {
                    var tCheck = $(element.closest('.form-group')).find('.help-block').length;
                    if(tCheck == 0){
                        error.appendTo(element.closest('.form-group')).trigger('change');
                    }
                }
            },
            highlight: function ( element, errorClass, validClass ) {
                $( element ).closest('.form-group').addClass( "has-error" ).removeClass( "has-success" );
            },
            unhighlight: function(element, errorClass, validClass) {
                var nStaCheckValid  = $(element).parents('.form-group').find('.help-block').length
                if(nStaCheckValid != 0){
                    $(element).closest('.form-group').addClass( "has-success" ).removeClass( "has-error" );
                }
            },
            submitHandler: function(form){}
        });
    }

    //BrowseAgn 
    $('#oimBrowseAgn').click(function(e){
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxCheckPinMenuClose();
            window.oPdtBrowseAgencyOption = oBrowseAgn({
                'tReturnInputCode'  : 'oetFrmAgnCode',
                'tReturnInputName'  : 'oetFrmAgnName',
            });
            JCNxBrowseData('oPdtBrowseAgencyOption');
        }else{
            JCNxShowMsgSessionExpired(); 
        }
    });

    //BrowseFormat 
    $('#obtFrmBrowseFormat').click(function(e){
        e.preventDefault();
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxCheckPinMenuClose();
            window.oPdtBrowseFormatOption = oBrowseRfs({
                'tReturnInputCode'  : 'oetFrmRfsCode',
                'tReturnInputName'  : 'oetFrmRfsName',
            });
            JCNxBrowseData('oPdtBrowseFormatOption');
        }else{
            JCNxShowMsgSessionExpired(); 
        }
    });

    
    var nLangEdits  = <?php echo $this->session->userdata("tLangEdit")?>;

    //Option Agn
    var oBrowseAgn = function(poReturnInput){
        var tInputReturnCode    = poReturnInput.tReturnInputCode;
        var tInputReturnName    = poReturnInput.tReturnInputName;


        var oOptionReturn   = {
            Title : ['ticket/agency/agency', 'tAggTitle'],
            Table:{Master:'TCNMAgency', PK:'FTAgnCode'},
            Join :{
            Table: ['TCNMAgency_L'],
                On: ['TCNMAgency_L.FTAgnCode = TCNMAgency.FTAgnCode AND TCNMAgency_L.FNLngID = '+nLangEdits]
            },
            GrideView:{
                ColumnPathLang	: 'ticket/agency/agency',
                ColumnKeyLang	: ['tAggCode', 'tAggName'],
                ColumnsSize     : ['15%', '85%'],
                WidthModal      : 50,
                DataColumns		: ['TCNMAgency.FTAgnCode', 'TCNMAgency_L.FTAgnName'],
                DataColumnsFormat : ['', ''],
                Perpage			: 10,
                OrderBy			: ['TCNMAgency.FDCreateOn DESC'],
            },
            CallBack:{
                ReturnType  : 'S',
                Value		: [tInputReturnCode,"TCNMAgency.FTAgnCode"],
                Text		: [tInputReturnName,"TCNMAgency_L.FTAgnName"],
            },
            RouteAddNew : 'agency',
            BrowseLev : 1,
        }
        return oOptionReturn;
    }


    
    //Option Agn
    var oBrowseRfs = function(poReturnInput){
        var tInputReturnCode    = poReturnInput.tReturnInputCode;
        var tInputReturnName    = poReturnInput.tReturnInputName;


        var oOptionReturn   = {
            Title : ['other/forms/forms', 'tFRMDocument'],
            Table:{Master:'TRPSRptFormat', PK:'FTRfsCode'},
            Join :{
            Table: ['TRPSRptFormat_L'],
                On: ['TRPSRptFormat_L.FTRfsCode = TRPSRptFormat.FTRfsCode AND TRPSRptFormat_L.FNLngID = '+nLangEdits]
            },
            GrideView:{
                ColumnPathLang	: 'other/forms/forms',
                ColumnKeyLang	: ['tFRMDocumentCode', 'tFRMDocumentName'],
                ColumnsSize     : ['15%', '85%'],
                WidthModal      : 50,
                DataColumns		: ['TRPSRptFormat.FTRfsCode', 'TRPSRptFormat_L.FTRfsName','TRPSRptFormat.FTRfsPath','TRPSRptFormat.FTRfsRptFileName'],
                DataColumnsFormat : ['', ''],
                DisabledColumns   : [2,3],
                Perpage			: 10,
                OrderBy			: ['TRPSRptFormat.FTRfsCode ASC'],
            },
            CallBack:{
                ReturnType  : 'S',
                Value		: [tInputReturnCode,"TRPSRptFormat.FTRfsCode"],
                Text		: [tInputReturnName,"TRPSRptFormat_L.FTRfsName"],
            },
            NextFunc: {
                    FuncName    : 'FSxFRMAfterBrowseRfs',
                    ArgReturn   : ['FTRfsCode', 'FTRfsName','FTRfsPath','FTRfsRptFileName']
                },
        }
        return oOptionReturn;
    }



    var tStaUsrLevel    = '<?php  echo $this->session->userdata("tSesUsrLevel"); ?>';

    if(tStaUsrLevel == 'BCH' || tStaUsrLevel == 'SHP'){
        $('#oimBrowseAgn').attr("disabled", true);
    }



/**
 * Functionality : Action for ad media input file changed.
 * Parameters : poElement is Itself element, poEvent is Itself event
 * Creator : 13/09/2018 piya
 * Last Modified : -
 * Return : -
 * Return Type : -
 */
function JSxFRMChangedFile(poElement, poEvent) {
    var tFilename = poElement.files[0].name;
    var tExtension = tFilename.split('.').pop();
    if(tExtension=='mrt'){
    $(poElement).parents('.xWAdvItem').find('.xWAdvFtuFile').val(poElement.files[0].name);
    $(poElement).parents('.xWAdvItem').addClass('change-file');
    $(poElement).removeAttr('data-media-id');
    }else{
        FSvCMNSetMsgWarningDialog('<?= language('other/forms/forms','tFRMValidateTypeFile')?>');
    }
}


/**
 * Functionality : Action for ad media input file changed.
 * Parameters : poElement is Itself element, poEvent is Itself event
 * Creator : 13/09/2018 piya
 * Last Modified : -
 * Return : -
 * Return Type : -
 */
function FSxFRMAfterBrowseRfs(oParam){
    JCNxOpenLoading();
    var aResult = JSON.parse(oParam);
    console.log(aResult);
    var tRfsCode = aResult[0];
    var tFrmRfsPath = aResult[2];
    var tFrmRfsFileName = aResult[3];
    $('#oetFrmRfsPath').val(tFrmRfsPath);
    $('#oetRfsFileName').val(tFrmRfsFileName);
    FSxFRMGetUrlEditForm(tRfsCode);
}

/**
 * Functionality : Action for ad media input file changed.
 * Parameters : poElement is Itself element, poEvent is Itself event
 * Creator : 13/09/2018 piya
 * Last Modified : -
 * Return : -
 * Return Type : -
 */
function FSxFRMGetUrlEditForm(ptRfsCode){
    $.ajax({
                type: "POST",
                url: "formsStdGetUrlEdit",
                data: { 
                    ptRfsCode: ptRfsCode
                },
                async : false,
                cache: false,
                timeout: 0,
                success: function(tResult){
                    var aResult = JSON.parse(tResult);
                    // console.log(aResult);
                    if(aResult['rtCode']=='1'){
                        var tFrmAgnCode = $('#oetFrmAgnCode').val();
                        var tFrmRfsPath = $('#oetFrmRfsPath').val();
                        var tBchCode = aResult['raItems']['rtBchCode'];
                        var tDocNo = aResult['raItems']['rtDocNo'];
                        var tDocDate = aResult['raItems']['FDXshDocDate'];
                        var tDocTime = aResult['raItems']['FDXshDocTime'];
                     
                        var tAddressBranch = aResult['raItems']['rtAddressBranch'];
                        var tRfsFileName = $('#oetRfsFileName').val();
                        var tRfuFileName = $('#oetRfuFileName').val();
                        var dGetDate = new Date(); 
                        var nGetTime = dGetDate.getTime(); 

                        if(ptRfsCode=='00034'){//เฉพาะเอกสารใบสั่งขายส่งวันที่เวลา
                                var aInfor = [
                                    {"Lang"         : '<?=FCNaHGetLangEdit(); ?>'}, // Lang ID
                                    {"ComCode"      : '<?=FCNtGetCompanyCode(); ?>'}, // Company Code
                                    {"BranchCode"   : tAddressBranch }, // สาขาที่ออกเอกสาร
                                    {"DocCode"      : tDocNo  }, // เลขที่เอกสาร
                                    {"DocBchCode"   : tBchCode },
                                    {"tDocDate"     : tDocDate },
                                    {"tDocTime"     : tDocTime }
                                ];

                        }else if(ptRfsCode=='00002'){
                            var aInfor = [
                                    {"Lang"         : '<?=FCNaHGetLangEdit(); ?>'}, // Lang ID
                                    {"ComCode"      : '<?=FCNtGetCompanyCode(); ?>'}, // Company Code
                                    {"BranchCode"   : tAddressBranch }, // สาขาที่ออกเอกสาร
                                    {"DocCode"      : tDocNo  }, // เลขที่เอกสาร
                                    {"DocBchCode"   : tBchCode },
                                    {"tRsnName"     : aResult['raItems']['FTRsnName']}
                                ];  
                        }else{
                            var aInfor = [
                                    {"Lang"         : '<?=FCNaHGetLangEdit(); ?>'}, // Lang ID
                                    {"ComCode"      : '<?=FCNtGetCompanyCode(); ?>'}, // Company Code
                                    {"BranchCode"   : tAddressBranch }, // สาขาที่ออกเอกสาร
                                    {"DocCode"      : tDocNo  }, // เลขที่เอกสาร
                                    {"DocBchCode"   : tBchCode }
                                ];  
                        }

                    
                                // console.log(aInfor);
                                //  window.open($("#ohdBaseUrl").val()+tFrmRfsPath+"?infor="+JCNtEnCodeUrlParameter(aInfor), '_blank');
                                if(ptRfsCode!='00001' && ptRfsCode!='00002'  && ptRfsCode!='00003' && ptRfsCode!='00022'  && ptRfsCode!='00035'){
                                    var tSTDUrlEdit = $('#ohdBaseURL').val()+tFrmRfsPath+'?v='+nGetTime+"&infor="+JCNtEnCodeUrlParameter(aInfor)+'&StaEdit=1&Agncode=&Filename='+tRfsFileName;
                                    var tSPCUrlEdit = $('#ohdBaseURL').val()+tFrmRfsPath+'?v='+nGetTime+"&infor="+JCNtEnCodeUrlParameter(aInfor)+'&StaEdit=1&Agncode='+tFrmAgnCode+'&Filename='+tRfuFileName;
                                }else{
                                    var tXshGndText = aResult['raItems']['FTXshGndText'];
                                    var tSTDUrlEdit = $('#ohdBaseURL').val()+tFrmRfsPath+'?v='+nGetTime+'&Agncode=&Filename='+tRfsFileName+'&StaPrint=0&infor='+JCNtEnCodeUrlParameter(aInfor)+'&Grand='+tXshGndText+'&PrintCopy=0&PrintOriginal=0&StaEdit=1&PrintByPage=ALL';
                                    var tSPCUrlEdit = $('#ohdBaseURL').val()+tFrmRfsPath+'?v='+nGetTime+'&Agncode='+tFrmAgnCode+'&Filename='+tRfuFileName+'&StaPrint=0&infor='+JCNtEnCodeUrlParameter(aInfor)+'&Grand='+tXshGndText+'&PrintCopy=0&PrintOriginal=0&StaEdit=1&PrintByPage=ALL';
                                }
                               $('#obtEditStimuFormStd').data('url',tSTDUrlEdit);
                               $('#obtEditStimuFormSpc').data('url',tSPCUrlEdit);
                               $('#obtEditStimuFormStd').prop('disabled',false);
                            //    $('#obtEditStimuFormSpc').prop('disabled',false);
                               JCNxCloseLoading();
                    }else{
                        FSvCMNSetMsgWarningDialog(aResult['rtDesc']);
                        JCNxCloseLoading();
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });
}

$('#obtEditStimuFormStd').on('click',function(){
    var tUrl = $(this).data('url');
    window.open(tUrl, '_blank');
});

$('#obtEditStimuFormSpc').on('click',function(){
    var tUrl = $(this).data('url');
    window.open(tUrl, '_blank');
})
</script>