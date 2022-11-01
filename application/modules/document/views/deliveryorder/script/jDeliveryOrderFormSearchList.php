<script type="text/javascript">
    var nLangEdits  = <?php echo $this->session->userdata("tLangEdit"); ?>;

    $(document).ready(function(){
        $('.selectpicker').selectpicker();

        $('.xCNDatePicker').datepicker({
            format: 'yyyy-mm-dd',
            enableOnReadonly: false,
            disableTouchKeyboard : true,
            autoclose: true
        });

        // Doc Date From
        $('#obtDOAdvSearchDocDateForm').unbind().click(function(){
            $('#oetDOAdvSearcDocDateFrom').datepicker('show');
        });

        // Doc Date To
        $('#obtDOAdvSearchDocDateTo').unbind().click(function(){
            $('#oetDOAdvSearcDocDateTo').datepicker('show');
        });
        
    });

    var tUsrLevel 	  	= "<?=$this->session->userdata("tSesUsrLevel"); ?>";
	var tBchCodeMulti 	= "<?=$this->session->userdata("tSesUsrBchCodeMulti"); ?>";
	var nCountBch 		= "<?=$this->session->userdata("nSesUsrBchCount"); ?>";
    var nLangEdits      = "<?=$this->session->userdata("tLangEdit")?>";
	var tWhere 			= "";

    if(nCountBch == 1){
		$('#obtDOAdvSearchBrowseBchFrom').attr('disabled',true);
		$('#obtDOAdvSearchBrowseBchTo').attr('disabled',true);
	}
	if(tUsrLevel != "HQ"){
		tWhere = " AND TCNMBranch.FTBchCode IN ("+tBchCodeMulti+") ";
	}else{
		tWhere = "";
	}


    // Advance search Display control
    $('#obtDOAdvanceSearch').unbind().click(function(){
        if($('#odvDOAdvanceSearchContainer').hasClass('hidden')){
            $('#odvDOAdvanceSearchContainer').removeClass('hidden').hide().slideDown(500);
        }else{
            $("#odvDOAdvanceSearchContainer").slideUp(500,function() {
                $(this).addClass('hidden');
            });
        }
    });

    // Option Branch
    var oDOBrowseBranch = function(poReturnInput){
        var tInputReturnCode    = poReturnInput.tReturnInputCode;
        var tInputReturnName    = poReturnInput.tReturnInputName;
        var oOptionReturn       = {
            Title : ['company/branch/branch','tBCHTitle'],
            Table : {Master:'TCNMBranch',PK:'FTBchCode'},
            Join :{
                Table : ['TCNMBranch_L'],
                On : ['TCNMBranch_L.FTBchCode = TCNMBranch.FTBchCode AND TCNMBranch_L.FNLngID = '+nLangEdits,]
            },
            Where   : {
                Condition : [tWhere]
            },
            GrideView:{
                ColumnPathLang      : 'company/branch/branch',
                ColumnKeyLang       : ['tBCHCode','tBCHName'],
                ColumnsSize         : ['15%','75%'],
                WidthModal          : 50,
                DataColumns         : ['TCNMBranch.FTBchCode','TCNMBranch_L.FTBchName'],
                DataColumnsFormat   : ['',''],
                Perpage             : 20,
                OrderBy             : ['TCNMBranch_L.FTBchName ASC'],
            },
            CallBack:{
                ReturnType	: 'S',
                Value		: [tInputReturnCode,"TCNMBranch.FTBchCode"],
                Text		: [tInputReturnName,"TCNMBranch_L.FTBchName"],
            },
        }
        return oOptionReturn;
    };

    // Event Browse Branch From
    $('#obtDOAdvSearchBrowseBchFrom').unbind().click(function(){
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxCheckPinMenuClose();
            window.oDOBrowseBranchFromOption  = oDOBrowseBranch({
                'tReturnInputCode'  : 'oetDOAdvSearchBchCodeFrom',
                'tReturnInputName'  : 'oetDOAdvSearchBchNameFrom'
            });
            JCNxBrowseData('oDOBrowseBranchFromOption');
        }else{
            JCNxShowMsgSessionExpired();
        }
    });

    // Event Browse Branch To
    $('#obtDOAdvSearchBrowseBchTo').unbind().click(function(){
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxCheckPinMenuClose();
            window.oDOBrowseBranchToOption  = oDOBrowseBranch({
                'tReturnInputCode'  : 'oetDOAdvSearchBchCodeTo',
                'tReturnInputName'  : 'oetDOAdvSearchBchNameTo'
            });
            JCNxBrowseData('oDOBrowseBranchToOption');
        }else{
            JCNxShowMsgSessionExpired();
        }
    });
    
    $('#obtDOSearchReset').unbind().click(function(){
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxDOClearAdvSearchData();
        }else{
            JCNxShowMsgSessionExpired();
        }
    });


    // Option Browse ตัวแทนขาย / แฟรนไชส์
    var oBrowseAgency   = function(poDataFnc) {
        var tReturnCode     = poDataFnc.tReturnCode;
        var tReturnName     = poDataFnc.tReturnName;
        var oOptionReturn	= {
            Title 	: ['ticket/agency/agency', 'tAggTitle'],
			Table	: {
                Master  : 'TCNMAgency',
                PK      : 'FTAgnCode'
            },
			Join	: {
                Table: ['TCNMAgency_L'],
                On: [
                    'TCNMAgency_L.FTAgnCode = TCNMAgency.FTAgnCode AND TCNMAgency_L.FNLngID = ' + nLangEdits
                ]
            },
			GrideView: {
                ColumnPathLang		: 'ticket/agency/agency',
                ColumnKeyLang		: ['tAggCode', 'tAggName'],
                ColumnsSize			: ['15%', '75%'],
                WidthModal			: 50,
                DataColumns			: ['TCNMAgency.FTAgnCode', 'TCNMAgency_L.FTAgnName'],
                DataColumnsFormat	: ['', ''],
                Perpage				: 5,
                OrderBy				: ['TCNMAgency.FDCreateOn'],
                SourceOrder			: "DESC"
            },
			CallBack	: {
                ReturnType	: 'S',
                Value       : [tReturnCode, "TCNMAgency.FTAgnCode"],
                Text        : [tReturnName, "TCNMAgency_L.FTAgnName"],
            },
        };
        return oOptionReturn;
    }

    // Event Browse ตัวแทนขาย / แฟรนไชส์
    $('#obtDOAdvSearchBrowseAgn').unbind().click(function() {
        let nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            JSxCheckPinMenuClose(); // Hidden Pin Menu
			window.oBrowseAgencyOption  = undefined;
            oBrowseAgencyOption = oBrowseAgency({
				'tReturnCode' 		: 'oetDOAdvSearchAgnCode',
				'tReturnName' 		: 'oetDOAdvSearchAgnName'
			});
			JCNxBrowseData('oBrowseAgencyOption');
        } else {
            JCNxShowMsgSessionExpired();
        }
    });


    // Option Browse ผู้จำหน่าย
    var oBrowseSupplier	= function(poDataFnc) {
        var tInputReturnCode	= poDataFnc.tReturnInputCode;
        var tInputReturnName	= poDataFnc.tReturnInputName;
		var oOptionReturn		= {
			Title	: ['supplier/supplier/supplier', 'tSPLTitle'],
			Table	: {Master:'TCNMSpl', PK:'FTSplCode'},
			Join	: {
                Table   : ['TCNMSpl_L', 'TCNMSplCredit'],
                On      : [
                    'TCNMSpl_L.FTSplCode    = TCNMSpl.FTSplCode AND TCNMSpl_L.FNLngID = '+nLangEdits,
                    'TCNMSpl_L.FTSplCode    = TCNMSplCredit.FTSplCode'
                ]
            },
			Where	: {
                Condition   : ["AND TCNMSpl.FTSplStaActive = '1' "]
            },
			GrideView	: {
                ColumnPathLang		: 'supplier/supplier/supplier',
                ColumnKeyLang		: ['tSPLTBCode', 'tSPLTBName'],
                ColumnsSize			: ['15%', '75%'],
                WidthModal			: 50,
                DataColumns			: ['TCNMSpl.FTSplCode', 'TCNMSpl_L.FTSplName', 'TCNMSplCredit.FNSplCrTerm', 'TCNMSplCredit.FCSplCrLimit', 'TCNMSpl.FTSplStaVATInOrEx', 'TCNMSplCredit.FTSplTspPaid'],
                DataColumnsFormat	: ['',''],
                DisabledColumns		: [2, 3, 4, 5],
                Perpage				: 10,
                OrderBy				: ['TCNMSpl_L.FTSplName ASC']
            },
			CallBack    : {
                ReturnType: 'S',
                Value   : [tInputReturnCode,"TCNMSpl.FTSplCode"],
                Text    : [tInputReturnName,"TCNMSpl_L.FTSplName"]
            },
            RouteAddNew : 'supplier',
		};
		return oOptionReturn;
    }

    // Event Browse ผู้จำหน่าย
    $('#obtDOAdvSearchBrowseSpl').unbind().click(function() {
		var nStaSession	= JCNxFuncChkSessionExpired();
		if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
			JSxCheckPinMenuClose(); // Hidden Pin Menu
			window.oBrowseSupplierOption = undefined;
			oBrowseSupplierOption = oBrowseSupplier({
				'tReturnInputCode'	: 'oetDOAdvSearchSplCode',
                'tReturnInputName'	: 'oetDOAdvSearchSplName',
			});
			JCNxBrowseData('oBrowseSupplierOption');
		} else {
			JCNxShowMsgSessionExpired();
		}
	});

    // ล้างค่า Input ทั้งหมดใน Advance Search
    function JSxDOClearAdvSearchData(){
        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof nStaSession !== "undefined" && nStaSession == 1){
            var tFilterAgnCode  = '';
            var tFilterAgnName  = '';
            let tChkAgnCodeAD   = '<?=$this->session->userdata("tSesUsrAgnCode")?>';
            if(tChkAgnCodeAD != ""){
                tFilterAgnCode	= $('#oetDOAdvSearchAgnCode').val();
                tFilterAgnName	= $('#oetDOAdvSearchAgnName').val();
            }

            $('#ofmDOFromSerchAdv').find('input').val('');
            $('#ofmDOFromSerchAdv').find('select').val(0).selectpicker("refresh");

            // Set Agn Code Default
            $('#oetDOAdvSearchAgnCode').val(tFilterAgnCode);
            $('#oetDOAdvSearchAgnName').val(tFilterAgnName);

            JSvDOCallPageDataTable();
        }else{
            JCNxShowMsgSessionExpired();
        }
    }

    // ====================================================  From Search Data Page  ====================================================
        $('#oetDOSearchAllDocument').keyup(function(event){
            var nCodeKey    = event.which;
            if(nCodeKey == 13){
                event.preventDefault();
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSvDOCallPageDataTable();
                }else{
                    JCNxShowMsgSessionExpired();
                }
            }
        });
        
        $('#obtDOSerchAllDocument').unbind().click(function(){
            var nStaSession = JCNxFuncChkSessionExpired();
            if(typeof nStaSession !== "undefined" && nStaSession == 1){
                JSvDOCallPageDataTable();
            }else{
                JCNxShowMsgSessionExpired();
            }
        });

        $("#obtDOAdvSearchSubmitForm").unbind().click(function(){
            var nStaSession = JCNxFuncChkSessionExpired();
            if(typeof nStaSession !== "undefined" && nStaSession == 1){
                JSvDOCallPageDataTable();
            }else{
                JCNxShowMsgSessionExpired();
            }
        });

    // =================================================================================================================================================

</script>