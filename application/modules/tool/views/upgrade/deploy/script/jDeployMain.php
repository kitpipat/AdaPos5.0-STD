<script type="text/javascript">
    var nLangEdits  = '<?php echo $this->session->userdata("tLangEdit");?>';

    $(document).ready(function(){

        $('#oliDPYTitle').unbind().click(function() {
            JSvDPYMain();
        });
        $('#obtDPYCallPageAdd').unbind().click(function() {
            JSvDPYCallPageAdd();
        });
        $('#obtDPYCallBackPage').unbind().click(function() {
            JSvDPYMain();
        });


        $('#obtDPYDocDateForm').unbind().click(function(){
            event.preventDefault();
            $('#oetDPYDocDateFrom').datepicker('show');
        });

        $('#obtDPYDocDateTo').unbind().click(function(){
            event.preventDefault();
            $('#oetDPYDocDateTo').datepicker('show');
        });
        $('.xCNDatePicker').datepicker({
            format: "yyyy-mm-dd",
            todayHighlight: true,
            enableOnReadonly: false,
            startDate :'1900-01-01',
            disableTouchKeyboard : true,
            autoclose: true
        });
    });
    $(".selectpicker").val("0").selectpicker("refresh");
    // Event Click On/Off Advance Search
    $('#oahDPYAdvanceSearch').unbind().click(function(){
        if($('#odvDPYAdvanceSearchContainer').hasClass('hidden')){
            $('#odvDPYAdvanceSearchContainer').removeClass('hidden').hide().slideDown(500);
        }else{
            $("#odvDPYAdvanceSearchContainer").slideUp(500,function() {
                $(this).addClass('hidden');
            });
        }
    });

    // ======================= Option Branch Advance Search =======================

    var tUsrLevel = "<?php echo $this->session->userdata("tSesUsrLevel"); ?>";
    var tBchCodeMulti = "<?php echo $this->session->userdata("tSesUsrBchCodeMulti"); ?>";
    var nCountBch = "<?php echo $this->session->userdata("nSesUsrBchCount"); ?>";
    var tWhere = "";

    if(nCountBch == 1){
        $('#obtBrowseASTBCH').attr('disabled', true);
    }

    if(tUsrLevel != "HQ"){
        tWhere = " AND TCNMBranch.FTBchCode IN ("+tBchCodeMulti+") ";
    }else{
        tWhere = "";
    }

    var oASTBrowseBch   = function(poReturnInput){
        var tInputReturnCode    = poReturnInput.tReturnInputCode;
        var tInputReturnName    = poReturnInput.tReturnInputName;
        var oOptionReturn       = {
            Title : ['company/branch/branch','tBCHTitle'],
            Table : {Master:'TCNMBranch',PK:'FTBchCode'},
            Join :{
                Table : ['TCNMBranch_L'],
                On : ['TCNMBranch_L.FTBchCode = TCNMBranch.FTBchCode AND TCNMBranch_L.FNLngID = '+nLangEdits,]
            },
            Where:{
                Condition : [tWhere]
            },
            GrideView:{
                ColumnPathLang : 'company/branch/branch',
                ColumnKeyLang : ['tBCHCode','tBCHName'],
                ColumnsSize : ['15%','75%'],
                WidthModal : 50,
                DataColumns : ['TCNMBranch.FTBchCode','TCNMBranch_L.FTBchName'],
                DataColumnsFormat : ['',''],
                Perpage : 10,
                OrderBy : ['TCNMBranch.FDCreateOn DESC'],
            },
            CallBack:{
            ReturnType	: 'S',
                Value		: [tInputReturnCode,"TCNMBranch.FTBchCode"],
                Text		: [tInputReturnName,"TCNMBranch_L.FTBchName"],
            },
        }
        return oOptionReturn;
    }

    // Branch From
    $('#obtDPYBrowseBchFrom').unbind().click(function(){
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxCheckPinMenuClose(); // Hidden Pin Menu
            window.oASTBrowseBchFromOption = oASTBrowseBch({
                'tReturnInputCode'  : 'oetDPYBchCodeFrom',
                'tReturnInputName'  : 'oetDPYBchNameFrom'
            });
            JCNxBrowseData('oASTBrowseBchFromOption');
        }else{
            JCNxShowMsgSessionExpired();
        }
    });

    // Branch To
    $('#obtDPYBrowseBchTo').unbind().click(function(){
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxCheckPinMenuClose(); // Hidden Pin Menu
            window.oASTBrowseBchToOption = oASTBrowseBch({
                'tReturnInputCode'  : 'oetDPYBchCodeTo',
                'tReturnInputName'  : 'oetDPYBchNameTo'
            });
            JCNxBrowseData('oASTBrowseBchToOption');
        }else{
            JCNxShowMsgSessionExpired();
        }
    });
    // ============================================================================

    $('#obtDPYSubmitFrmSearchAdv').unbind().click(function(){
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JCNxDPYDataTable();
        }else{
            JCNxShowMsgSessionExpired();
        }
    });

    // Functionality: ฟังก์ชั่นล้างค่า Input Advance Search
    // Parameters: Button Event Click
    // Creator: 06/06/2019 Wasin(Yoshi)
    // Last Update: -
    // Return: Clear Value In Input Advance Search
    // ReturnType: -
    function JSxDPYClearSearchData(){
       
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof nStaSession !== "undefined" && nStaSession == 1){

            var nCountBch = "<?=$this->session->userdata("nSesUsrBchCount"); ?>";
            if(nCountBch != 1){ //ถ้ามีมากกว่า 1 สาขาต้อง reset 
                $("#oetDPYBchCodeFrom").val("");
                $("#oetDPYBchNameFrom").val(""); 
                $("#oetDPYBchCodeTo").val("");
                $("#oetDPYBchNameTo").val("");
            }

            $("#oetSearchAll").val("");
            $("#oetDPYDocDateFrom").val("");
            $("#oetDPYDocDateTo").val("");
            $(".xCNDatePicker").datepicker("setDate", null);
            $(".selectpicker")
            .val("0")
            .selectpicker("refresh");
            JCNxDPYDataTable();
            // $('#ofmASTFromSerchAdv').find('input').val('');
            // $('#ofmASTFromSerchAdv').find('select').val(0)
        }else{
            JCNxShowMsgSessionExpired();
        }
    }

</script>