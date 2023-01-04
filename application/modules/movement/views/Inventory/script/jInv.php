<script type="text/javascript">
    var nLangEdits      = '<?php echo $this->session->userdata("tLangEdit");?>';
    var tStaUsrLevel    = '<?php  echo $this->session->userdata("tSesUsrLevel"); ?>';

    $('.selectpicker').selectpicker();
    $('#ocmSearchProductType').on('change',function(){
        $('#oetInvPdtNameSelect').val('');
        switch ($('#ocmSearchProductType').val()) {
            case '1':
                $('#oetInvPdtNameSelect').attr('placeholder','รหัสสินค้า');
                break;
            case '2':
                $('#oetInvPdtNameSelect').attr('placeholder','ชื่อสินค้า');
                break;
            case '3':
                $('#oetInvPdtNameSelect').attr('placeholder','บาร์โค้ด');
                break;
            case '4':
                $('#oetInvPdtNameSelect').attr('placeholder','กลุ่มสินค้า');
                break; 
            case '5':
                $('#oetInvPdtNameSelect').attr('placeholder','ประเภทสินค้า');
                break; 
            case '6':
                $('#oetInvPdtNameSelect').attr('placeholder','ยี่ห้อ');
                break; 
            default:
                break;
        }
    });

    function JSxChqConsNextFuncBrowseBch(poDataNextfunc) {
        if (poDataNextfunc == 'NULL') {
            $('#obtInvMultiBrowseWaHouse').attr('disabled',true);
            // $('#obtInvMultiBrowseProduct').attr('disabled',true);
        } else {
            $('#obtInvMultiBrowseWaHouse').removeAttr('disabled');
            // $('#obtInvMultiBrowseProduct').removeAttr('disabled');
        }
        return;
    }

      // =========================================== Event Browse Multi Branch ===========================================
      $('#obtInvMultiBrowseBranch').unbind().click(function(){
        // เซตค่าว่าง คลังสินค้า
        $('#oetInvWahStaSelectAll').val('');
        $('#oetInvWahCodeSelect').val('');
        $('#oetInvWahNameSelect').val('');

        //เซตค่าว่าง สินค้า
        $('#oetInvPdtStaSelectAll').val('');
        $('#oetInvPdtCodeSelect').val('');
        $('#oetInvPdtNameSelect').val('');

        var nStaSession = JCNxFuncChkSessionExpired();
        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){

            var tUsrLevel     = "<?php echo $this->session->userdata("tSesUsrLevel"); ?>";
            var tBchCodeMulti = "<?php echo $this->session->userdata("tSesUsrBchCodeMulti"); ?>";
            var nCountBch     = "<?php echo $this->session->userdata("nSesUsrBchCount"); ?>";
            let tWhere		     = "";

            if(tUsrLevel != "HQ"){
                tWhere = " AND TCNMBranch.FTBchCode IN ("+tBchCodeMulti+") ";
            }else{
                tWhere = "";
            }

            JSxCheckPinMenuClose(); // Hidden Pin Menu
            window.oBranchBrowseMultiOption = undefined;
            oBranchBrowseMultiOption        = {
                Title: ['company/branch/branch','tBCHTitle'],
                Table:{Master:'TCNMBranch',PK:'FTBchCode'},
                Join :{
                    Table:	['TCNMBranch_L'],
                    On:['TCNMBranch_L.FTBchCode = TCNMBranch.FTBchCode AND TCNMBranch_L.FNLngID = '+nLangEdits]
                },
                Where: {
                    Condition: [tWhere]
                },
                GrideView:{
                    ColumnPathLang  	: 'company/branch/branch',
                    ColumnKeyLang	    : ['tBCHCode','tBCHName'],
                    ColumnsSize         : ['15%','75%'],
                    WidthModal          : 50,
                    DataColumns		    : ['TCNMBranch.FTBchCode','TCNMBranch_L.FTBchName'],
                    DataColumnsFormat   : ['',''],
                    OrderBy			    : ['TCNMBranch.FDCreateOn DESC'],
                    Perpage: 10,
                },
                CallBack:{
                    ReturnType: 'S',
                    Value		: ['oetInvBchCodeSelect','TCNMBranch.FTBchCode'],
                    Text		: ['oetInvBchNameSelect','TCNMBranch_L.FTBchName']
                },
                NextFunc: {
                    FuncName: 'JSxChqConsNextFuncBrowseBch',
                    ArgReturn: ['FTBchCode','FTBchName']
                }
            };
            JCNxBrowseData('oBranchBrowseMultiOption');
        }else{
            JCNxShowMsgSessionExpired();
        }
    });
    // =========================================== Event Browse Multi Branch ===========================================

  // =========================================== Event Browse Multi Branch ===========================================
//   $('#obtInvMultiBrowseProduct').unbind().click(function(){
//         // $('#oetInvWahStaSelectAll').val('');
//         // $('#oetInvWahCodeSelect').val('');
//         // $('#oetInvWahNameSelect').val('');

//         var nStaSession = JCNxFuncChkSessionExpired();
//         if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
//             JSxCheckPinMenuClose(); // Hidden Pin Menu

//             let tBchCodeSess = $('#oetInvBchCodeSelect').val();
//             console.log(tBchCodeSess)
//             var oBrowsePdtSettings = {
//                 Qualitysearch: [
//                     "NAMEPDT",
//                     "CODEPDT"
//                 ],
//                 PriceType: ["Cost", "tCN_Cost", "Company", "1"],
//                 //'PriceType'       : ['Pricesell'],
//                 //'SelectTier'      : ['PDT'],
//                 SelectTier: ["Barcode"],
//                 //'Elementreturn'   : ['oetInputTestValue','oetInputTestName'],
//                 ShowCountRecord: 10,
//                 NextFunc: "FSvINVNextFuncB4SelPDT",
//                 ReturnType: "M",
//                 SPL: ["", ""],
//                 BCH: [tBchCodeSess, tBchCodeSess],
//                 MER: ["", ""],
//                 SHP: ["", ""],
//             }

//             $.ajax({
//                 type: "POST",
//                 url: "BrowseDataPDT",
//                 data: oBrowsePdtSettings,
//                 cache: false,
//                 timeout: 5000,
//                 success: function (tResult) {
//                     // $(".modal.fade:not(#odvTBBrowseShipAdd,#odvModalDOCPDT,#odvModalWanning,#odvModalInfoMessage,#odvShowOrderColumn,#odvTBPopupApv,#odvModalDelPdtTB)").remove();
//                     $("#odvModalDOCPDT").modal({ backdrop: "static", keyboard: false });
//                     $("#odvModalDOCPDT").modal({ show: true });

//                     //remove localstorage
//                     localStorage.removeItem("LocalItemDataPDT");
//                     $("#odvModalsectionBodyPDT").html(tResult);
//                 },
//                 error: function (data) {
//                     console.log(data);
//                 }
//             });
//             // window.oProductBrowseMultiOption = undefined;

//             // let tBchCodeSess = $('#oetInvBchCodeSelect').val();
//             // let tCondition ='';
//             // if(tBchCodeSess!=''){
//             //     tCondition +=  " AND ( TCNMPdtSpcBch.FTBchCode = '"+tBchCodeSess+"' OR ( TCNMPdtSpcBch.FTBchCode IS NULL OR TCNMPdtSpcBch.FTBchCode ='' ) )";
//             // }

//             // let tAgnCode        = '<?php echo $this->session->userdata("tSesUsrAgnCode"); ?>';
//             // if( tAgnCode != '' ){
//             //     tCondition += " AND TCNMPdtSpcBch.FTAgnCode = '"+tAgnCode+"' ";
//             // }

//             // oProductBrowseMultiOption         = {
//             //     Title : ['product/product/product','tPDTTitle'],
//             //     Table:{Master:'TCNMPdt',PK:'FTPdtCode'},
//             //     Join :{
//             //         Table:	['TCNMPdt_L','TCNMPdtSpcBch'],
//             //         On:[
//             //             'TCNMPdt_L.FTPdtCode = TCNMPdt.FTPdtCode AND TCNMPdt_L.FNLngID = '+nLangEdits,
//             //             'TCNMPdtSpcBch.FTPdtCode = TCNMPdt.FTPdtCode'
//             //             ]
//             //     }, 
//             //     Where:{
//             //             Condition : [tCondition]
//             //     },
//             //     GrideView:{
//             //         ColumnPathLang	: 'product/product/product',
//             //         ColumnKeyLang	: ['tPDTCode','tPDTName'],
//             //         ColumnsSize     : ['10%','75%'],
//             //         WidthModal      : 50,
//             //         DataColumns		: ['TCNMPdt.FTPdtCode','TCNMPdt_L.FTPdtName'],
//             //         DataColumnsFormat : ['',''],
//             //         Perpage			: 10,
//             //         OrderBy			: ['TCNMPdt.FDCreateOn DESC'],
//             //         // SourceOrder		: "ASC"
//             //     },
//             //     CallBack:{
//             //         StaSingItem : '1',
//             //         ReturnType	: 'M',
//             //         Value		: ['oetInvPdtCodeSelect',"TCNMPdt.FTPdtCode"],
//             //         Text		: ['oetInvPdtNameSelect',"TCNMPdt_L.FTPdtName"],
//             //     },
//             //     BrowseLev : 1
//             // }
//             // JCNxBrowseData('oProductBrowseMultiOption');




//             $('#obtInvMultiBrowseProduct').attr("disabled", false);
//         }else{
//             JCNxShowMsgSessionExpired();
//         }
//     });
    // =========================================== Event Browse Multi Branch ===========================================
    $('#obtInvMultiBrowseProduct').unbind().click(function(){
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

                    let tBchCodeSess = $('#oetInvBchCodeSelect').val();
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
                            Text		: ['oetInvPdtNameSelect',"TCNMPdt.FTPdtCode"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtInvMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            case '2':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;

                    let tBchCodeSess = $('#oetInvBchCodeSelect').val();
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
                            Text		: ['oetInvPdtNameSelect',"TCNMPdt.FTPdtName"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtInvMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }        
                break;
            case '3':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;

                    let tBchCodeSess = $('#oetInvBchCodeSelect').val();
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
                            Text		: ['oetInvPdtNameSelect',"TCNMPdtBar.FTBarCode"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtInvMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            case '4':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;
                    let tBchCodeSess = $('#oetInvBchCodeSelect').val();
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
                            Text		: ['oetInvPdtNameSelect',"TCNMPdtGrp.FTPgpChain"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtInvMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            case '5':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;
                    let tBchCodeSess = $('#oetInvBchCodeSelect').val();
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
                            Text		: ['oetInvPdtNameSelect',"TCNMPdtType.FTPtyCode"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtInvMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            case '6':
                var nStaSession = JCNxFuncChkSessionExpired();
                if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                    JSxCheckPinMenuClose(); // Hidden Pin Menu
                    window.oProductBrowseMultiOption = undefined;
                    let tBchCodeSess = $('#oetInvBchCodeSelect').val();
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
                            Text		: ['oetInvPdtNameSelect',"TCNMPdtBrand.FTPbnCode"],
                        },
                        BrowseLev : 1
                    }
                    JCNxBrowseData('oProductBrowseMultiOption');


                    $('#obtInvMultiBrowseProduct').attr("disabled", false);
                }else{
                    JCNxShowMsgSessionExpired();
                }    
                break;
            default:
                break;
        }          
    });
    // =========================================== Event Browse Multi Branch ===========================================

   // =========================================== Event Browse Multi Branch ===========================================
   function FSvINVNextFuncB4SelPDT(paData){
        // console.log(paData);
                var tTypeProduct = $('#ocmSearchProductType').val();
                var tPdtCode = '';
                var tPdtName = '';
                var tBarCode = '';
                var tComma = '';
                var aData =  JSON.parse(paData);
                //    console.log(aData.length);
                if(aData.length>0){
                for(var i=0;i<aData.length;i++){
                    //console.log(aData[i].packData.Barcode)
                    // console.log(aData[i].packData.PDTCode);
                        if(i>0){
                            tComma = ',';
                        }
                        tPdtCode += tComma+aData[i].packData.PDTCode;
                        tBarCode += tComma+aData[i].packData.Barcode;
                        tPdtName += tComma+aData[i].packData.PDTName;
                }
                $('#oetInvPdtCodeSelect').val(tPdtCode);
                    switch (tTypeProduct) {
                        case '1':
                            $('#oetInvPdtNameSelect').val(tPdtCode);
                            break;
                        case '2':
                            $('#oetInvPdtNameSelect').val(tPdtName);
                            break;    
                        case '3':
                            $('#oetInvPdtNameSelect').val(tBarCode);
                            break;  
                        default:
                            break;
                    }
                }else{
                    $('#oetInvPdtCodeSelect').val('');
                $('#oetInvPdtNameSelect').val(''); 
                }
    //    console.log(tPdtCode);
    //    console.log(tPdtName);
    }
    // =========================================== Event Browse Multi WaHouse ===========================================
    $('#obtInvMultiBrowseWaHouse').unbind().click(function(){
        var nStaSession = JCNxFuncChkSessionExpired();
        let tBchcode    = $('#oetInvBchCodeSelect').val();
        let tShpcode    = $('#oetMmtShpCodeSelect').val();

        let tTable      = "TCNMWaHouse";   

        if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
            JSxCheckPinMenuClose(); // Hidden Pin Menu
            window.oWaHouseBrowseMultiOption = undefined;
            tWahWherWah                = "";
            
            if(tBchcode != ""){
                tTable  = "TCNMWaHouse";
                tBchcode = tBchcode.replace(/,/g, "','");
                tWahWherWah = "AND TCNMWaHouse.FTBchCode  IN ('"+tBchcode+"') ";
            }

            // if(tShpcode != ""){
            //     tTable                      = "TCNMShpWah";
            //     tShpcode = tShpcode.replace(/,/g, "','");
            //     tWahWherWah                = "AND TCNMShpWah.FTShpCode  IN ('"+tShpcode+"') ";
            // }

            var tOrderBy    = tTable + ".FDCreateOn DESC";

            oWaHouseBrowseMultiOption        = {
                Title: ['company/warehouse/warehouse','tWAHSubTitle'],
                Table:{Master:tTable,PK:'FTWahCode'},
                Join :{
                    Table:	['TCNMWaHouse_L', 'TCNMBranch_L'],
                    On:['TCNMWaHouse_L.FTWahCode = "'+tTable+'".FTWahCode AND "'+tTable+'".FTBchCode = TCNMWaHouse_L.FTBchCode AND TCNMWaHouse_L.FNLngID = '+nLangEdits,
                        'TCNMBranch_L.FTBchCode = "'+tTable+'".FTBchCode AND TCNMBranch_L.FNLngID = '+nLangEdits]
                },
                Where :{
                    Condition : [tWahWherWah]
                },
                GrideView:{
                    ColumnPathLang  	: 'company/warehouse/warehouse',
                    ColumnKeyLang	    : ['tWahCode','tWahName'],
                    ColumnsSize         : ['25%', '50%'],
                    WidthModal          : 50,
                    DataColumns		    : [ '"'+tTable+'".FTWahCode','TCNMWaHouse_L.FTWahName'],
                    DataColumnsFormat   : ['',''],
                    OrderBy			    : [ tOrderBy, 'TCNMBranch_L.FTBchName ASC, TCNMWaHouse_L.FTWahCode ASC'],
                    Perpage             : 10,
                },
                CallBack:{
                    StausAll    : ['oetInvWahStaSelectAll'],
                    Value		: ['oetInvWahCodeSelect','"'+tTable+'".FTWahCode'],
                    Text		: ['oetInvWahNameSelect','TCNMWaHouse_L.FTWahName']
                }
            };
            JCNxBrowseMultiSelect('oWaHouseBrowseMultiOption');
            $('#obtInvMultiBrowseWaHouse').attr("disabled", false);
        }else{
            JCNxShowMsgSessionExpired();
        }
    });
    // =========================================== Event Browse Multi WaHouse ===========================================



</script>