var nLangEdits = $('#oetLangID').val();

// ตัวแทนขาย
$('#obtPAPBrowseAgn').unbind().click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oPAPBrowseAgn = undefined;
        oPAPBrowseAgn = oPAPBrowseAgnCode({
            'tReturnInputCode': 'oetPAPAgnCode',
            'tReturnInputName': 'oetPAPAgnName',
        });
        JCNxBrowseData('oPAPBrowseAgn');
    } else {
        JCNxShowMsgSessionExpired();
    }
   });

var oPAPBrowseAgnCode = function(poReturnInputAgn) {
    let tAgnInputReturnCode = poReturnInputAgn.tReturnInputCode;
    let tAgnInputReturnName = poReturnInputAgn.tReturnInputName;
    let oAgnOptionReturn = {
        Title: ['authen/user/user', 'tBrowseAgnTitle'],
        Table: {
            Master: 'TCNMAgency',
            PK: 'FTAgnCode'
        },
        Join: {
            Table: ['TCNMAgency_L'],
            On: [
                'TCNMAgency.FTAgnCode = TCNMAgency_L.FTAgnCode AND TCNMAgency_L.FNLngID = ' + nLangEdits
            ]
        },
        GrideView: {
            ColumnPathLang: 'authen/user/user',
            ColumnKeyLang: ['tBrowseAgnCode', 'tBrowseAgnName'],
            ColumnsSize: ['15%', '90%'],
            WidthModal: 50,
            DataColumns: ['TCNMAgency.FTAgnCode', 'TCNMAgency_L.FTAgnName'],
            DataColumnsFormat: ['', ''],
            Perpage: 10,
            OrderBy: ['TCNMAgency.FDCreateOn DESC'],
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tAgnInputReturnCode, "TCNMAgency.FTAgnCode"],
            Text: [tAgnInputReturnName, "TCNMAgency_L.FTAgnName"]
        },
    };
    return oAgnOptionReturn;
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// คลัง
$('#obtPAPBrowseWahCode').unbind().click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oPAPBrowseWah = undefined;
        oPAPBrowseWah = oPAPBrowseWahCode({
            'tReturnInputCode': 'oetPAPWahCode',
            'tReturnInputName': 'oetPAPWahName',
        });
        JCNxBrowseData('oPAPBrowseWah');
    } else {
        JCNxShowMsgSessionExpired();
    }
   });

var oPAPBrowseWahCode = function(poReturnInputWah) {
    let tInputReturnCode = poReturnInputWah.tReturnInputCode;
    let tInputReturnName = poReturnInputWah.tReturnInputName;

    var tSQLWhereBch  = "";
    var tBchCode      = $('#oetPAPBchCode').val();
    var tUsrLevel     = $('#ohdUsrLevel').val();
    var tBchMulti     = $('#ohdBchMulti').val();
    
    if(tUsrLevel != "HQ" && tBchCode == ""){
        tSQLWhereBch = " AND TCNMWaHouse_L.FTBchCode = "+tBchMulti+"";
    }else if(tUsrLevel != "HQ" && tBchCode != ""){
        tSQLWhereBch = " AND TCNMWaHouse_L.FTBchCode = '"+tBchCode+"' ";
    }else if(tBchCode != "") {
        tSQLWhereBch = " AND TCNMWaHouse_L.FTBchCode = '"+tBchCode+"' ";
    }else{
        var tSQLWhereBch = "";
    }

    let oOptionReturn = {
        Title: ['company/branch/branch', 'tBCHTitle'],
        Table: {
            Master: 'TCNMWaHouse_L',
            PK: 'FTWahCode'
        },
        Where: {
            Condition: [tSQLWhereBch,'AND TCNMWaHouse_L.FNLngID = '+ nLangEdits]
        },
        GrideView: {
            ColumnPathLang: 'company/branch/branch',
            ColumnKeyLang: ['tBchCode', 'tBCHSubTitle'],
            ColumnsSize: ['15%', '90%'],
            WidthModal: 50,
            DataColumns: ['TCNMWaHouse_L.FTWahCode', 'TCNMWaHouse_L.FTWahName'],
            DataColumnsFormat: ['', ''],
            Perpage: 10,
            OrderBy: ['TCNMWaHouse_L.FTWahCode DESC'],
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMWaHouse_L.FTWahCode"],
            Text: [tInputReturnName, "TCNMWaHouse_L.FTWahName"]
        },
    };
    return oOptionReturn;
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// รหัสสินค้า
$('#obtPAPBrowsePdtCode').unbind().click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oPAPBrowsePdt = undefined;
        oPAPBrowsePdt = oPAPBrowsePdtCode({
            'tReturnInputCode': 'oetPAPPdtCode',
            'tReturnInputName': 'oetPAPPdtName',
        });
        JCNxBrowseData('oPAPBrowsePdt');
    } else {
        JCNxShowMsgSessionExpired();
    }
   });

var oPAPBrowsePdtCode = function(poReturnInputPdt) {
    let tInputReturnCode = poReturnInputPdt.tReturnInputCode;
    let tInputReturnName = poReturnInputPdt.tReturnInputName;

    let oOptionReturn = {
        Title: ['ticket/product/product', 'tProduct'],
        Table: {
            Master: 'TCNMPdt',
            PK: 'FTPdtCode'
        },
        Join: {
            Table: ['TCNMPdt_L'],
            On: [
                'TCNMPdt.FTPdtCode = TCNMPdt_L.FTPdtCode AND TCNMPdt_L.FNLngID = ' + nLangEdits
            ]
        },
        GrideView: {
            ColumnPathLang: 'ticket/product/product',
            ColumnKeyLang: ['tCodeProduct', 'tProductInformation'],
            ColumnsSize: ['15%', '90%'],
            WidthModal: 50,
            DataColumns: ['TCNMPdt.FTPdtCode', 'TCNMPdt_L.FTPdtName'],
            DataColumnsFormat: ['', ''],
            Perpage: 10,
            OrderBy: ['TCNMPdt.FDCreateOn DESC'],
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMPdt.FTPdtCode"],
            Text: [tInputReturnName, "TCNMPdt_L.FTPdtName"]
        },
    };
    return oOptionReturn;
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// กลุ่มสินค้า
$('#obtPAPBrowseGrpProductCode').unbind().click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oPAPBrowseGrpPdt = undefined;
        oPAPBrowseGrpPdt = oPAPBrowseGrpPdtCode({
            'tReturnInputCode': 'oetPAPGrpProductCode',
            'tReturnInputName': 'oetPAPGrpProductName',
        });
        JCNxBrowseData('oPAPBrowseGrpPdt');
    } else {
        JCNxShowMsgSessionExpired();
    }
   });

var oPAPBrowseGrpPdtCode = function(poReturnInputGrpPdt) {
    let tInputReturnCode = poReturnInputGrpPdt.tReturnInputCode;
    let tInputReturnName = poReturnInputGrpPdt.tReturnInputName;

    // var tPdtCode = $('#oetPAPPdtCode').val();
    // var tSQLWherePdt = '';

    // if (tPdtCode != '') {
    //     tSQLWherePdt = " AND TCNMBranch.FTBchCode IN ("+tPdtCode+")";
    // }

    let oOptionReturn = {
        Title: ['product/pdtgroup/pdtgroup', 'tPGPTitle'],
        Table: {
            Master: 'TCNMPdtGrp',
            PK: 'FTPgpChain'
        },
        Join: {
            Table: ['TCNMPdtGrp_L'],
            On: [
                'TCNMPdtGrp.FTPgpChain = TCNMPdtGrp_L.FTPgpChain AND TCNMPdtGrp_L.FNLngID = ' + nLangEdits
            ]
        },
        GrideView: {
            ColumnPathLang: 'product/pdtgroup/pdtgroup',
            ColumnKeyLang: ['tPGPChainCode', 'tPGPChain'],
            ColumnsSize: ['15%', '90%'],
            WidthModal: 50,
            DataColumns: ['TCNMPdtGrp.FTPgpChain', 'TCNMPdtGrp_L.FTPgpName'],
            DataColumnsFormat: ['', ''],
            Perpage: 10,
            OrderBy: ['TCNMPdtGrp.FDCreateOn DESC'],
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMPdtGrp.FTPgpChain"],
            Text: [tInputReturnName, "TCNMPdtGrp_L.FTPgpName"]
        },
    };
    return oOptionReturn;
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// กลุ่มสินค้า
$('#obtPAPBrowsePdtBrand').unbind().click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oPAPBrowsePdtBrand = undefined;
        oPAPBrowsePdtBrand = oPAPBrowsePdtBrandCode({
            'tReturnInputCode': 'oetPAPProducBrandCode',
            'tReturnInputName': 'oetPAPProductBrandName',
        });
        JCNxBrowseData('oPAPBrowsePdtBrand');
    } else {
        JCNxShowMsgSessionExpired();
    }
   });

var oPAPBrowsePdtBrandCode = function(poReturnInputPdtBrand) {
    let tInputReturnCode = poReturnInputPdtBrand.tReturnInputCode;
    let tInputReturnName = poReturnInputPdtBrand.tReturnInputName;
    let oOptionReturn = {
        Title: ['product/pdtbrand/pdtbrand', 'tPBNTitle'],
        Table: {
            Master: 'TCNMPdtBrand',
            PK: 'FTPbnCode'
        },
        Join: {
            Table: ['TCNMPdtBrand_L'],
            On: [
                'TCNMPdtBrand.FTPbnCode = TCNMPdtBrand_L.FTPbnCode AND TCNMPdtBrand_L.FNLngID = ' + nLangEdits
            ]
        },
        GrideView: {
            ColumnPathLang: 'product/pdtbrand/pdtbrand',
            ColumnKeyLang: ['tPBNCode', 'tPBNName'],
            ColumnsSize: ['15%', '90%'],
            WidthModal: 50,
            DataColumns: ['TCNMPdtBrand.FTPbnCode', 'TCNMPdtBrand_L.FTPbnName'],
            DataColumnsFormat: ['', ''],
            Perpage: 10,
            OrderBy: ['TCNMPdtBrand.FDCreateOn DESC'],
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMPdtBrand.FTPbnCode"],
            Text: [tInputReturnName, "TCNMPdtBrand_L.FTPbnName"]
        },
    };
    return oOptionReturn;
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// โมเดลสินค้า
$('#obtPAPBrowsePdtModel').unbind().click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oPAPBrowsePdtModel = undefined;
        oPAPBrowsePdtModel = oPAPBrowsePdtModelCode({
            'tReturnInputCode': 'oetPAPProducModelCode',
            'tReturnInputName': 'oetPAPProductModelName',
        });
        JCNxBrowseData('oPAPBrowsePdtModel');
    } else {
        JCNxShowMsgSessionExpired();
    }
   });

var oPAPBrowsePdtModelCode = function(poReturnInputPdtModel) {
    let tInputReturnCode = poReturnInputPdtModel.tReturnInputCode;
    let tInputReturnName = poReturnInputPdtModel.tReturnInputName;
    let oOptionReturn = {
        Title: ['product/pdtbrand/pdtbrand', 'tPBNTitle'],
        Table: {
            Master: 'TCNMPdtModel',
            PK: 'FTPmoCode'
        },
        Join: {
            Table: ['TCNMPdtModel_L'],
            On: [
                'TCNMPdtModel.FTPmoCode = TCNMPdtModel_L.FTPmoCode AND TCNMPdtModel_L.FNLngID = ' + nLangEdits
            ]
        },
        GrideView: {
            ColumnPathLang: 'product/pdtbrand/pdtbrand',
            ColumnKeyLang: ['tPBNCode', 'tPBNName'],
            ColumnsSize: ['15%', '90%'],
            WidthModal: 50,
            DataColumns: ['TCNMPdtModel.FTPmoCode', 'TCNMPdtModel_L.FTPmoName'],
            DataColumnsFormat: ['', ''],
            Perpage: 10,
            OrderBy: ['TCNMPdtModel.FDCreateOn DESC'],
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMPdtModel.FTPmoCode"],
            Text: [tInputReturnName, "TCNMPdtModel_L.FTPmoName"]
        },
    };
    return oOptionReturn;
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// โมเดลสินค้า
$('#obtPAPBrowsePdtModel').unbind().click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oPAPBrowsePdtModel = undefined;
        oPAPBrowsePdtModel = oPAPBrowsePdtModelCode({
            'tReturnInputCode': 'oetPAPProducModelCode',
            'tReturnInputName': 'oetPAPProductModelName',
        });
        JCNxBrowseData('oPAPBrowsePdtModel');
    } else {
        JCNxShowMsgSessionExpired();
    }
   });

var oPAPBrowsePdtModelCode = function(poReturnInputPdtModel) {
    let tInputReturnCode = poReturnInputPdtModel.tReturnInputCode;
    let tInputReturnName = poReturnInputPdtModel.tReturnInputName;
    let oOptionReturn = {
        Title: ['product/pdtmodel/pdtmodel', 'tPMOTitle'],
        Table: {
            Master: 'TCNMPdtModel',
            PK: 'FTPmoCode'
        },
        Join: {
            Table: ['TCNMPdtModel_L'],
            On: [
                'TCNMPdtModel.FTPmoCode = TCNMPdtModel_L.FTPmoCode AND TCNMPdtModel_L.FNLngID = ' + nLangEdits
            ]
        },
        GrideView: {
            ColumnPathLang: 'product/pdtmodel/pdtmodel',
            ColumnKeyLang: ['tPMOCode', 'tPMOName'],
            ColumnsSize: ['15%', '90%'],
            WidthModal: 50,
            DataColumns: ['TCNMPdtModel.FTPmoCode', 'TCNMPdtModel_L.FTPmoName'],
            DataColumnsFormat: ['', ''],
            Perpage: 10,
            OrderBy: ['TCNMPdtModel.FDCreateOn DESC'],
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMPdtModel.FTPmoCode"],
            Text: [tInputReturnName, "TCNMPdtModel_L.FTPmoName"]
        },
    };
    return oOptionReturn;
}

//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------

// ประเภทสินค้า
$('#obtPAPBrowsePdtTypeCode').unbind().click(function() {
    var nStaSession = JCNxFuncChkSessionExpired();
    if (typeof(nStaSession) !== 'undefined' && nStaSession == 1) {
        JSxCheckPinMenuClose(); // Hidden Pin Menu
        window.oPAPBrowsePdtType = undefined;
        oPAPBrowsePdtType = oPAPBrowsePdtTypeCode({
            'tReturnInputCode': 'oetPAPProducTypeCode',
            'tReturnInputName': 'oetPAPProductTypeName',
        });
        JCNxBrowseData('oPAPBrowsePdtType');
    } else {
        JCNxShowMsgSessionExpired();
    }
   });

var oPAPBrowsePdtTypeCode = function(poReturnInputPdtType) {
    let tInputReturnCode = poReturnInputPdtType.tReturnInputCode;
    let tInputReturnName = poReturnInputPdtType.tReturnInputName;
    
    var tSQLWhereAgn = '';
    var tAgnCode     = $('#oetPAPAgnCode').val();

    if(tAgnCode != ""){
        tSQLWhereAgn = "AND TCNMPdtType.FTAgnCode IN ("+tAgnCode+")";
    }else{
        tSQLWhereAgn = "";
    }

    let oOptionReturn = {
        Title: ['product/pdttype/pdttype', 'tPTYTitle'],
        Table: {
            Master: 'TCNMPdtType',
            PK: 'FTPtyCode'
        },
        Join: {
            Table: ['TCNMPdtType_L'],
            On: [
                'TCNMPdtType.FTPtyCode = TCNMPdtType_L.FTPtyCode AND TCNMPdtType_L.FNLngID = ' + nLangEdits
            ]
        },
        Where: {
            Condition: [tSQLWhereAgn]
        },
        GrideView: {
            ColumnPathLang: 'product/pdttype/pdttype',
            ColumnKeyLang: ['tPTYTBCode', 'tPTYTBName'],
            ColumnsSize: ['15%', '90%'],
            WidthModal: 50,
            DataColumns: ['TCNMPdtType.FTPtyCode', 'TCNMPdtType_L.FTPtyName'],
            DataColumnsFormat: ['', ''],
            Perpage: 10,
            OrderBy: ['TCNMPdtType.FDCreateOn DESC'],
        },
        CallBack: {
            ReturnType: 'S',
            Value: [tInputReturnCode, "TCNMPdtType.FTPtyCode"],
            Text: [tInputReturnName, "TCNMPdtType_L.FTPtyName"]
        },
    };
    return oOptionReturn;
}