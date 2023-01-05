<script type="text/javascript">
    var nLangEdits = '<?php echo $this->session->userdata("tLangEdit"); ?>';
    var tStaUsrLevel = '<?php echo $this->session->userdata("tSesUsrLevel"); ?>';

    $(document).ready(function() {

    });

    $('.xCNDatePicker').selectpicker();
    $('.selectpicker').selectpicker();
    $('#ocmSearchProductType').on('change',function(){
        $('#oetMmtPdtNameSelect').val('');
        switch ($('#ocmSearchProductType').val()) {
            case '1':
                $('#oetMmtPdtNameSelect').attr('placeholder','รหัสสินค้า');
                break;
            case '2':
                $('#oetMmtPdtNameSelect').attr('placeholder','ชื่อสินค้า');
                break;
            case '3':
                $('#oetMmtPdtNameSelect').attr('placeholder','บาร์โค้ด');
                break;
            case '4':
                $('#oetMmtPdtNameSelect').attr('placeholder','กลุ่มสินค้า');
                break; 
            case '5':
                $('#oetMmtPdtNameSelect').attr('placeholder','ประเภทสินค้า');
                break; 
            case '6':
                $('#oetMmtPdtNameSelect').attr('placeholder','ยี่ห้อ');
                break; 
            default:
                break;
        }
    });
    // Click Button Date
    $('#obtMmtBrowseDateStart').unbind().click(function() {
        $('#oetMmtDateStart').datepicker('show');
    });

    $('#obtMmtBrowseDateTo').unbind().click(function() {
        $('#oetMmtDateTo').datepicker('show');
    });


    // Event Date Picker
    $('.xCNDatePicker').datepicker({
        format: 'yyyy-mm-dd',
        autoclose: true,
        todayHighlight: true
    });

    // =========================================== Event Browse Multi Branch ===========================================
    $('#obtMmtMultiBrowseBranch').unbind().click(function() {
        //เปิดปุ่ม
        // $('#obtMmtMultiBrowseBranch').attr("disabled", true);

        // เซตค่าว่าง ร้านค่า
        $('#oetMmtShpStaSelectAll').val('');
        $('#oetMmtShpCodeSelect').val('');
        $('#oetMmtShpNameSelect').val('');

        // เซตค่าว่าง คลังสินค้า
        $('#oetMmtWahStaSelectAll').val('');
        $('#oetMmtWahCodeSelect').val('');
        $('#oetMmtWahNameSelect').val('');

        //เซตค่าว่าง สินค้า
        $('#oetMmtPdtStaSelectAll').val('');
        $('#oetMmtPdtCodeSelect').val('');
        $('#oetMmtPdtNameSelect').val('');

        // $('#obtMmtMultiBrowseShop').attr('disabled',true);
        // $('#obtMmtMultiBrowseWaHouse').attr('disabled',true);
        // $('#obtMmtMultiBrowseProduct').attr('disabled',true);




        var nStaSession = JCNxFuncChkSessionExpired();
        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {

            var tUsrLevel = "<?php echo $this->session->userdata("tSesUsrLevel"); ?>";
            var tBchCodeMulti = "<?php echo $this->session->userdata("tSesUsrBchCodeMulti"); ?>";
            var nCountBch = "<?php echo $this->session->userdata("nSesUsrBchCount"); ?>";
            let tWhere = "";

            if (tUsrLevel != "HQ") {
                tWhere = " AND TCNMBranch.FTBchCode IN (" + tBchCodeMulti + ") ";
            } else {
                tWhere = "";
            }

            JSxCheckPinMenuClose(); // Hidden Pin Menu
            window.oBranchBrowseMultiOption = undefined;
            oBranchBrowseMultiOption = {
                Title: ['company/branch/branch', 'tBCHTitle'],
                Table: {
                    Master: 'TCNMBranch',
                    PK: 'FTBchCode'
                },
                Join: {
                    Table: ['TCNMBranch_L'],
                    On: ['TCNMBranch_L.FTBchCode = TCNMBranch.FTBchCode AND TCNMBranch_L.FNLngID = ' + nLangEdits]
                },
                Where: {
                    Condition: [tWhere]
                },
                GrideView: {
                    ColumnPathLang: 'company/branch/branch',
                    ColumnKeyLang: ['tBCHCode', 'tBCHName'],
                    ColumnsSize: ['15%', '75%'],
                    WidthModal: 50,
                    DataColumns: ['TCNMBranch.FTBchCode', 'TCNMBranch_L.FTBchName'],
                    DataColumnsFormat: ['', ''],
                    OrderBy: ['TCNMBranch.FDCreateOn DESC'],
                    Perpage: 10,
                },
                CallBack: {
                    // StausAll    : ['oetMmtBchStaSelectAll'],
                    ReturnType: 'S',
                    Value: ['oetMmtBchCodeSelect', 'TCNMBranch.FTBchCode'],
                    Text: ['oetMmtBchNameSelect', 'TCNMBranch_L.FTBchName']
                },
                NextFunc: {
                    FuncName: "JSvMevementBntBch",
                    ArgReturn: ['FTBchCode', 'FTBchName']
                },
            };
            // JCNxBrowseMultiSelect('oBranchBrowseMultiOption');
            JCNxBrowseData('oBranchBrowseMultiOption');
            // $('#obtMmtMultiBrowseBranch').attr("disabled", false);
        } else {
            JCNxShowMsgSessionExpired();
        }
    });
    //เปิดปุ่ม
    function JSvMevementBntBch(PtDataBch) {
        if (PtDataBch == 'NULL') {
            $('#obtMmtMultiBrowseShop').attr('disabled', true);
            $('#obtMmtMultiBrowseWaHouse').attr('disabled', true);
            $('#obtMmtMultiBrowseProduct').attr('disabled', true);
        } else {
            $('#obtMmtMultiBrowseShop').removeAttr('disabled');
            $('#obtMmtMultiBrowseWaHouse').removeAttr('disabled');
            $('#obtMmtMultiBrowseProduct').removeAttr('disabled');
        }
        return;
        // $('#obtMmtMultiBrowseBranch').attr("disabled", false);
    }
    // =========================================== Event Browse Multi Branch ===========================================

    // ============================================ Event Browse Multi Shop ============================================
    $('#obtMmtMultiBrowseShop').unbind().click(function() {
        //ปิดปุ่ม
        // $('#obtMmtMultiBrowseShop').attr("disabled", true);

        // เซตค่าว่าง คลังสินค้า
        $('#oetMmtWahStaSelectAll').val('');
        $('#oetMmtWahCodeSelect').val('');
        $('#oetMmtWahNameSelect').val('');

        //เซตค่าว่าง สินค้า
        $('#oetMmtPdtStaSelectAll').val('');
        $('#oetMmtPdtCodeSelect').val('');
        $('#oetMmtPdtNameSelect').val('');

        var nStaSession = JCNxFuncChkSessionExpired();
        let tBchcode = $('#oetMmtBchCodeSelect').val();

        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            JSxCheckPinMenuClose(); // Hidden Pin Menu
            window.oShopBrowseMultiOption = undefined;
            tShpWhereBch = "";
            tBchcode = tBchcode.replace(/,/g, "','");
            tShpWhereBch = "AND TCNMShop.FTBchCode IN ('" + tBchcode + "') ";
            oShopBrowseMultiOption = {
                Title: ['company/shop/shop', 'tSHPTitle'],
                Table: {
                    Master: 'TCNMShop',
                    PK: 'FTShpCode'
                },
                Join: {
                    Table: ['TCNMShop_L', 'TCNMBranch_L'],
                    On: [
                        'TCNMShop.FTBchCode = TCNMShop_L.FTBchCode      AND TCNMShop.FTShpCode = TCNMShop_L.FTShpCode AND TCNMShop_L.FNLngID = ' + nLangEdits,
                        'TCNMShop.FTBchCode = TCNMBranch_L.FTBchCode    AND TCNMBranch_L.FNLngID = ' + nLangEdits
                    ]
                },
                Where: {
                    Condition: [tShpWhereBch]
                },
                GrideView: {
                    ColumnPathLang: 'company/shop/shop',
                    ColumnKeyLang: ['tSHPTBBranch', 'tSHPTBCode', 'tSHPTBName'],
                    ColumnsSize: ['15%', '15%', '75%'],
                    WidthModal: 50,
                    DataColumns: ['TCNMBranch_L.FTBchName', 'TCNMShop.FTShpCode', 'TCNMShop_L.FTShpName'],
                    DataColumnsFormat: ['', '', ''],
                    OrderBy: ['TCNMShop.FDCreateOn DESC'],
                    Perpage: 10,
                },
                CallBack: {
                    StausAll: ['oetMmtShpStaSelectAll'],
                    Value: ['oetMmtShpCodeSelect', "TCNMShop.FTShpCode"],
                    Text: ['oetMmtShpNameSelect', "TCNMShop_L.FTShpName"]
                },
                // NextFunc    : {
                // FuncName    : "JSvMevementBntShp",
                // ArgReturn   : ['FTBchCode','FTShpCode']
                // },
                // DebugSQL : true
            };
            JCNxBrowseMultiSelect('oShopBrowseMultiOption');
            $('#obtMmtMultiBrowseShop').attr("disabled", false);
        } else {
            JCNxShowMsgSessionExpired();
        }
    });

    //เปิดปุ่ม
    // function JSvMevementBntShp(PtDataShp){
    //     console.log('JSvMevementBntShp');
    //     console.log(PtDataShp);
    //     $('#obtMmtMultiBrowseShop').attr("disabled", false);
    // }
    // ============================================ END Event Browse Multi Shop ============================================

    // =========================================== Event Browse Multi WaHouse ===========================================
    $('#obtMmtMultiBrowseWaHouse').unbind().click(function() {
        //ปิดปุ่ม
        //เซตค่าว่าง สินค้า
        $('#oetMmtPdtStaSelectAll').val('');
        $('#oetMmtPdtCodeSelect').val('');
        $('#oetMmtPdtNameSelect').val('');
        var nStaSession = JCNxFuncChkSessionExpired();
        let tBchcode = $('#oetMmtBchCodeSelect').val();
        let tShpcode = $('#oetMmtShpCodeSelect').val();
        let tTable = "TCNMWaHouse";

        if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
            JSxCheckPinMenuClose(); // Hidden Pin Menu
            window.oWaHouseBrowseMultiOption = undefined;
            tWahWherWah = "";
            tWahWherWah = "AND TCNMWaHouse.FTBchCode = '" + $('#oetMmtBchCodeSelect').val() + "' ";
            var tOrderBy = tTable + ".FDCreateOn DESC";
            oWaHouseBrowseMultiOption = {
                Title: ['company/warehouse/warehouse', 'tWAHSubTitle'],
                Table: {
                    Master: tTable,
                    PK: 'FTWahCode'
                },
                Join: {
                    Table: ['TCNMWaHouse_L'],
                    On: ['TCNMWaHouse_L.FTWahCode = "' + tTable + '".FTWahCode AND "' + tTable + '".FTBchCode = TCNMWaHouse_L.FTBchCode AND TCNMWaHouse_L.FNLngID = ' + nLangEdits]
                },
                Where: {
                    Condition: [tWahWherWah]
                },
                GrideView: {
                    ColumnPathLang: 'company/warehouse/warehouse',
                    ColumnKeyLang: ['tWahCode', 'tWahName'],
                    ColumnsSize: ['15%', '75%'],
                    WidthModal: 50,
                    DataColumns: ['"' + tTable + '".FTWahCode', 'TCNMWaHouse_L.FTWahName'],
                    DataColumnsFormat: ['', ''],
                    OrderBy: [tOrderBy],
                    Perpage: 10,
                },
                CallBack: {
                    StausAll: ['oetMmtWahStaSelectAll'],
                    Value: ['oetMmtWahCodeSelect', '"' + tTable + '".FTWahCode'],
                    Text: ['oetMmtWahNameSelect', 'TCNMWaHouse_L.FTWahName']
                }
            };
            JCNxBrowseMultiSelect('oWaHouseBrowseMultiOption');
            $('#obtMmtMultiBrowseWaHouse').attr("disabled", false);
        } else {
            JCNxShowMsgSessionExpired();
        }
    });

    //เปิดปุ่ม
    function JSvMevementBntWah(PtDataWah) {
        $('#obtMmtMultiBrowseWaHouse').attr("disabled", false);
    }
    // =========================================== Event Browse Multi WaHouse ===========================================

    // =========================================== Event Browse Multi Branch ===========================================
    // $('#obtMmtMultiBrowseProduct').unbind().click(function() {
    //     // ปิดปุ่ม
    //     // $('#obtMmtMultiBrowseProduct').attr("disabled", true);
    //     var nStaSession = JCNxFuncChkSessionExpired();
    //     if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
    //         JSxCheckPinMenuClose(); // Hidden Pin Menu
    //         window.oProductBrowseMultiOption = undefined;
    //         let tSessionUsrLev = '<?=$this->session->userdata('tSesUsrLevel')?>';
    //         let tBchCodeSess = $('#oetMmtBchCodeSelect').val();

    //         var oBrowsePdtSettings = {
    //             Qualitysearch: [
    //                 "NAMEPDT",
    //                 "CODEPDT"
    //             ],
    //             PriceType: ["Cost", "tCN_Cost", "Company", "1"],
    //             //'PriceType'       : ['Pricesell'],
    //             //'SelectTier'      : ['PDT'],
    //             SelectTier: ["Barcode"],
    //             //'Elementreturn'   : ['oetInputTestValue','oetInputTestName'],
    //             ShowCountRecord: 10,
    //             NextFunc: "FSvMNTNextFuncB4SelPDT",
    //             ReturnType: "M",
    //             SPL: ["", ""],
    //             BCH: [tBchCodeSess, tBchCodeSess],
    //             MER: ["", ""],
    //             SHP: ["", ""],
    //         }

    //         $.ajax({
    //             type: "POST",
    //             url: "BrowseDataPDT",
    //             data: oBrowsePdtSettings,
    //             cache: false,
    //             timeout: 5000,
    //             success: function (tResult) {
    //                 // $(".modal.fade:not(#odvTBBrowseShipAdd,#odvModalDOCPDT,#odvModalWanning,#odvModalInfoMessage,#odvShowOrderColumn,#odvTBPopupApv,#odvModalDelPdtTB)").remove();
    //                 $("#odvModalDOCPDT").modal({ backdrop: "static", keyboard: false });
    //                 $("#odvModalDOCPDT").modal({ show: true });

    //                 //remove localstorage
    //                 localStorage.removeItem("LocalItemDataPDT");
    //                 $("#odvModalsectionBodyPDT").html(tResult);
    //             },
    //             error: function (data) {
    //                 console.log(data);
    //             }
    //         });

    //         // let tCondition = '';
    //         // if (tBchCodeSess != '' && tSessionUsrLev!= 'HQ') {
    //         //     tCondition += " AND ( TCNMPdtSpcBch.FTBchCode = '" + tBchCodeSess + "' OR ( TCNMPdtSpcBch.FTBchCode IS NULL OR TCNMPdtSpcBch.FTBchCode ='' ) )";
    //         // }

    //         // let tAgnCode        = '<?php echo $this->session->userdata("tSesUsrAgnCode"); ?>';
    //         // if( tAgnCode != '' ){
    //         //     tCondition += " AND TCNMPdtSpcBch.FTAgnCode = '"+tAgnCode+"' ";
    //         // }


    //         // oProductBrowseMultiOption = {
    //         //     Title: ['product/product/product', 'tPDTTitle'],
    //         //     Table: {
    //         //         Master: 'TCNMPdt',
    //         //         PK: 'FTPdtCode'
    //         //     },
    //         //     Join: {
    //         //         Table: ['TCNMPdt_L', 'TCNMPdtSpcBch'],
    //         //         On: [
    //         //             'TCNMPdt_L.FTPdtCode = TCNMPdt.FTPdtCode AND TCNMPdt_L.FNLngID = ' + nLangEdits,
    //         //             'TCNMPdtSpcBch.FTPdtCode = TCNMPdt.FTPdtCode'
    //         //         ]
    //         //     },
    //         //     Where: {
    //         //         Condition: [tCondition]
    //         //     },
    //         //     GrideView: {
    //         //         ColumnPathLang: 'product/product/product',
    //         //         ColumnKeyLang: ['tPDTCode', 'tPDTName'],
    //         //         ColumnsSize: ['10%', '75%'],
    //         //         WidthModal: 50,
    //         //         DataColumns: ['TCNMPdt.FTPdtCode', 'TCNMPdt_L.FTPdtName'],
    //         //         DataColumnsFormat: ['', ''],
    //         //         Perpage: 10,
    //         //         OrderBy: ['TCNMPdt.FDCreateOn DESC'],
    //         //         SourceOrder: "ASC"
    //         //     },
    //         //     CallBack: {
    //         //         StaSingItem: '1',
    //         //         ReturnType: 'M',
    //         //         Value: ['oetMmtPdtCodeSelect', "TCNMPdt.FTPdtCode"],
    //         //         Text: ['oetMmtPdtNameSelect', "TCNMPdt_L.FTPdtName"],
    //         //     },
    //         //     // RouteAddNew : 'saleperson',
    //         //     BrowseLev: 1,
    //         //     //DebugSQL : true
    //         // }
    //         // JCNxBrowseData('oProductBrowseMultiOption');


    //         $('#obtMmtMultiBrowseProduct').attr("disabled", false);
    //     } else {
    //         JCNxShowMsgSessionExpired();
    //     }
    // });

    $('#obtMmtMultiBrowseProduct').unbind().click(function(){
        // $('#oetInvWahStaSelectAll').val('');
        // $('#oetInvWahCodeSelect').val('');
        // $('#oetInvWahNameSelect').val('');
        var tTypeProduct = $('#ocmSearchProductType').val();
        console.log(tTypeProduct)

        switch (tTypeProduct) {
            case '1':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;

                    let tBchCodeSess = $('#oetMmtBchCodeSelect').val();
                    let tCondition ='';
                    if(tBchCodeSess!=''){
                        tCondition +=  " AND ( TCNMPdtSpcBch.FTBchCode = '"+tBchCodeSess+"' OR ( TCNMPdtSpcBch.FTBchCode IS NULL OR TCNMPdtSpcBch.FTBchCode ='' ) )";
                    }

                    let tAgnCode        = '<?php echo $this->session->userdata("tSesUsrAgnCode"); ?>';
                    if( tAgnCode != '' ){
                        tCondition += " AND TCNMPdtSpcBch.FTAgnCode = '"+tAgnCode+"' ";
                    }

                    oProductBrowseMultiOption         = {
                        Title : ['product/product/product','tPDTTitle'],
                        Table:{Master:'TCNMPdt',PK:'FTPdtCode'},
                        Join :{
                            Table:	['TCNMPdt_L','TCNMPdtSpcBch'],
                            On:[
                                'TCNMPdt_L.FTPdtCode = TCNMPdt.FTPdtCode AND TCNMPdt_L.FNLngID = '+nLangEdits,
                                'TCNMPdtSpcBch.FTPdtCode = TCNMPdt.FTPdtCode'
                                ]
                        }, 
                        Where:{
                                Condition : [tCondition]
                        },
                        GrideView:{
                            ColumnPathLang	: 'product/product/product',
                            ColumnKeyLang	: ['tPDTCode','tPDTName'],
                            ColumnsSize     : ['10%','75%'],
                            WidthModal      : 50,
                            DataColumns		: ['TCNMPdt.FTPdtCode','TCNMPdt_L.FTPdtName'],
                            DataColumnsFormat : ['',''],
                            Perpage			: 10,
                            OrderBy			: ['TCNMPdt.FDCreateOn DESC'],
                            // SourceOrder		: "ASC"
                        },
                        CallBack:{
                            StaSingItem : '1',
                            ReturnType	: 'M',
                            Value		: ['oetInvPdtCodeSelect',"TCNMPdt.FTPdtCode"],
                            Text		: ['oetMmtPdtNameSelect',"TCNMPdt.FTPdtCode"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtMmtMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            case '2':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;

                    let tBchCodeSess = $('#oetMmtBchCodeSelect').val();
                    let tCondition ='';
                    if(tBchCodeSess!=''){
                        tCondition +=  " AND ( TCNMPdtSpcBch.FTBchCode = '"+tBchCodeSess+"' OR ( TCNMPdtSpcBch.FTBchCode IS NULL OR TCNMPdtSpcBch.FTBchCode ='' ) )";
                    }

                    let tAgnCode        = '<?php echo $this->session->userdata("tSesUsrAgnCode"); ?>';
                    if( tAgnCode != '' ){
                        tCondition += " AND TCNMPdtSpcBch.FTAgnCode = '"+tAgnCode+"' ";
                    }

                    oProductBrowseMultiOption         = {
                        Title : ['product/product/product','tPDTTitle'],
                        Table:{Master:'TCNMPdt',PK:'FTPdtCode'},
                        Join :{
                            Table:	['TCNMPdt_L','TCNMPdtSpcBch'],
                            On:[
                                'TCNMPdt_L.FTPdtCode = TCNMPdt.FTPdtCode AND TCNMPdt_L.FNLngID = '+nLangEdits,
                                'TCNMPdtSpcBch.FTPdtCode = TCNMPdt.FTPdtCode'
                                ]
                        }, 
                        Where:{
                                Condition : [tCondition]
                        },
                        GrideView:{
                            ColumnPathLang	: 'product/product/product',
                            ColumnKeyLang	: ['tPDTCode','tPDTName'],
                            ColumnsSize     : ['10%','75%'],
                            WidthModal      : 50,
                            DataColumns		: ['TCNMPdt.FTPdtCode','TCNMPdt_L.FTPdtName'],
                            DataColumnsFormat : ['',''],
                            Perpage			: 10,
                            OrderBy			: ['TCNMPdt.FDCreateOn DESC'],
                            // SourceOrder		: "ASC"
                        },
                        CallBack:{
                            StaSingItem : '1',
                            ReturnType	: 'M',
                            Value		: ['oetInvPdtCodeSelect',"TCNMPdt.FTPdtCode"],
                            Text		: ['oetMmtPdtNameSelect',"TCNMPdt.FTPdtName"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtMmtMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }        
                break;
            case '3':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;

                    let tBchCodeSess = $('#oetMmtBchCodeSelect').val();
                    let tCondition ='';
                    if(tBchCodeSess!=''){
                        tCondition +=  " AND ( TCNMPdtSpcBch.FTBchCode = '"+tBchCodeSess+"' OR ( TCNMPdtSpcBch.FTBchCode IS NULL OR TCNMPdtSpcBch.FTBchCode ='' ) )";
                    }

                    let tAgnCode        = '<?php echo $this->session->userdata("tSesUsrAgnCode"); ?>';
                    if( tAgnCode != '' ){
                        tCondition += " AND TCNMPdtSpcBch.FTAgnCode = '"+tAgnCode+"' ";
                    }

                    oProductBrowseMultiOption         = {
                        Title : ['product/product/product','tPDTTitle'],
                        Table:{Master:'TCNMPdt',PK:'FTPdtCode'},
                        Join :{
                            Table:	['TCNMPdt_L','TCNMPdtSpcBch','TCNMPdtBar'],
                            On:[
                                'TCNMPdt_L.FTPdtCode = TCNMPdt.FTPdtCode AND TCNMPdt_L.FNLngID = '+nLangEdits,
                                'TCNMPdtSpcBch.FTPdtCode = TCNMPdt.FTPdtCode',
                                'TCNMPdtSpcBch.FTPdtCode = TCNMPdtBar.FTPdtCode'
                                ]
                        }, 
                        Where:{
                                Condition : [tCondition]
                        },
                        GrideView:{
                            ColumnPathLang	: 'product/product/product',
                            ColumnKeyLang	: ['tPDTCode','tPDTName','บาร์โค้ด'],
                            ColumnsSize     : ['10%','50%','25%'],
                            WidthModal      : 50,
                            DataColumns		: ['TCNMPdt.FTPdtCode','TCNMPdt_L.FTPdtName','TCNMPdtBar.FTBarCode'],
                            DataColumnsFormat : ['','',''],
                            Perpage			: 10,
                            OrderBy			: ['TCNMPdt.FDCreateOn DESC'],
                            // SourceOrder		: "ASC"
                        },
                        CallBack:{
                            StaSingItem : '1',
                            ReturnType	: 'M',
                            Value		: ['oetInvPdtCodeSelect',"TCNMPdt.FTPdtCode"],
                            Text		: ['oetMmtPdtNameSelect',"TCNMPdtBar.FTBarCode"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtMmtMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            case '4':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;
                    let tBchCodeSess = $('#oetMmtBchCodeSelect').val();
                    let tCondition ='';

                    oProductBrowseMultiOption         = {
                        Title : ['product/product/product','กลุ่มสินค้า'],
                        Table:{Master:'TCNMPdtGrp',PK:'FTPgpChain'},
                        Join :{
                            Table:	['TCNMPdtGrp_L'],
                            On:[
                                'TCNMPdtGrp_L.FTPgpChain = TCNMPdtGrp.FTPgpChain AND TCNMPdtGrp_L.FNLngID = '+nLangEdits
                                ]
                        }, 
                        Where:{
                                Condition : [tCondition]
                        },
                        GrideView:{
                            ColumnPathLang	: 'product/product/product',
                            ColumnKeyLang	: ['รหัสกลุ่มสินค้า','กลุ่มสินค้า'],
                            ColumnsSize     : ['10%','75%'],
                            WidthModal      : 50,
                            DataColumns		: ['TCNMPdtGrp.FTPgpChain','TCNMPdtGrp_L.FTPgpName'],
                            DataColumnsFormat : ['','',''],
                            Perpage			: 10,
                            OrderBy			: ['TCNMPdtGrp.FDCreateOn DESC'],
                            // SourceOrder		: "ASC"
                        },
                        CallBack:{
                            StaSingItem : '1',
                            ReturnType	: 'M',
                            Value		: ['oetInvPdtCodeSelect',"TCNMPdtGrp.FTPgpChain"],
                            Text		: ['oetMmtPdtNameSelect',"TCNMPdtGrp.FTPgpChain"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtMmtMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            case '5':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;
                    let tBchCodeSess = $('#oetMmtBchCodeSelect').val();
                    let tCondition ='';

                    oProductBrowseMultiOption         = {
                        Title : ['product/product/product','ประเภทสินค้า'],
                        Table:{Master:'TCNMPdtType',PK:'FTPtyCode'},
                        Join :{
                            Table:	['TCNMPdtType_L'],
                            On:[
                                'TCNMPdtType_L.FTPtyCode = TCNMPdtType.FTPtyCode AND TCNMPdtType_L.FNLngID = '+nLangEdits
                                ]
                        }, 
                        Where:{
                                Condition : [tCondition]
                        },
                        GrideView:{
                            ColumnPathLang	: 'product/product/product',
                            ColumnKeyLang	: ['รหัสประเภทสินค้า','ประเภทสินค้า'],
                            ColumnsSize     : ['10%','75%'],
                            WidthModal      : 50,
                            DataColumns		: ['TCNMPdtType.FTPtyCode','TCNMPdtType_L.FTPtyName'],
                            DataColumnsFormat : ['','',''],
                            Perpage			: 10,
                            OrderBy			: ['TCNMPdtType.FDCreateOn DESC'],
                            // SourceOrder		: "ASC"
                        },
                        CallBack:{
                            StaSingItem : '1',
                            ReturnType	: 'M',
                            Value		: ['oetInvPdtCodeSelect',"TCNMPdtType.FTPtyCode"],
                            Text		: ['oetMmtPdtNameSelect',"TCNMPdtType.FTPtyCode"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtMmtMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            case '6':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;
                    let tBchCodeSess = $('#oetMmtBchCodeSelect').val();
                    let tCondition ='';

                    oProductBrowseMultiOption         = {
                        Title : ['product/product/product','ยี่ห้อ'],
                        Table:{Master:'TCNMPdtBrand',PK:'FTPbnCode'},
                        Join :{
                            Table:	['TCNMPdtBrand_L'],
                            On:[
                                'TCNMPdtBrand_L.FTPbnCode = TCNMPdtBrand.FTPbnCode AND TCNMPdtBrand_L.FNLngID = '+nLangEdits
                                ]
                        }, 
                        Where:{
                                Condition : [tCondition]
                        },
                        GrideView:{
                            ColumnPathLang	: 'product/product/product',
                            ColumnKeyLang	: ['รหัสยี่ห้อ','ยี่ห้อ'],
                            ColumnsSize     : ['10%','75%'],
                            WidthModal      : 50,
                            DataColumns		: ['TCNMPdtBrand.FTPbnCode','TCNMPdtBrand_L.FTPbnName'],
                            DataColumnsFormat : ['','',''],
                            Perpage			: 10,
                            OrderBy			: ['TCNMPdtBrand.FDCreateOn DESC'],
                            // SourceOrder		: "ASC"
                        },
                        CallBack:{
                            StaSingItem : '1',
                            ReturnType	: 'M',
                            Value		: ['oetInvPdtCodeSelect',"TCNMPdtBrand.FTPbnCode"],
                            Text		: ['oetMmtPdtNameSelect',"TCNMPdtBrand.FTPbnCode"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtMmtMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            default:
                break;
        }          
    });

    //เปิดปุ่ม
    function JSvMevementBntPdt(PtDataPdt) {
        $('#obtMmtMultiBrowseProduct').attr("disabled", false);
    }
    // =========================================== Event Browse Multi Branch ===========================================
       // =========================================== Event Browse Multi Branch ===========================================
       function FSvMNTNextFuncB4SelPDT(paData){
        // console.log(paData);
                var tPdtCode = '';
                var tPdtName = '';
                var tComma = '';
                var aData =  JSON.parse(paData);
                //    console.log(aData.length);
                if(aData.length>0){
                for(var i=0;i<aData.length;i++){
                    // console.log(aData[i].packData.PDTCode);
                        if(i>0){
                            tComma = ',';
                        }
                        tPdtCode += tComma+aData[i].packData.PDTCode;
                        tPdtName += tComma+aData[i].packData.PDTName;
                }
                $('#oetMmtPdtCodeSelect').val(tPdtCode);
                $('#oetMmtPdtNameSelect').val(tPdtName);
                }else{
                    $('#oetMmtPdtCodeSelect').val('');
                $('#oetMmtPdtNameSelect').val(''); 
                }
    //    console.log(tPdtCode);
    //    console.log(tPdtName);
    }
</script>