//Functionality : แสดงรายการฟอแมทของเอกสารนี้
//Parameters : -
//Creator : 06/10/2021 Nale
//Return : 
//Return Type : 
function JCNxRftDataTable(paData) {
    try {
            // console.log(paData);
            localStorage.setItem("oParameter", JSON.stringify(paData.oParameter));  
            localStorage.setItem("tIframeNameID", paData.tIframeNameID);  
           $.ajax({
                    type: "POST",
                    url: "RFTDataTable",
                    data: {
                        tRtfCode: paData.tRtfCode,
                        tBchCode:paData.tDocBchCode,
                        tIframeNameID:paData.tIframeNameID
                    }, 
                    cache: false,
                    Timeout: 5000,
                    success: function(oResult) {
                    let aDataReturn = JSON.parse(oResult);
                    if(aDataReturn['rtCode']!='905'){
                        if(aDataReturn['rtCode']=='2' || paData.tIframeNameID=='oifPrint'){
                            $('#odvModalbodyRft').html(aDataReturn['tHTMLDataTable']);
                            $('#odvModalRft').modal('show');
                        }else{
                            var aDataOpenReport = {
                                FTAgnCode : aDataReturn['raItems'][0]['FTAgnCode'],
                                FTRptPath : aDataReturn['raItems'][0]['FTRptPath'],
                                FTRptFileName : aDataReturn['raItems'][0]['FTRptFileName'],
                                oParameter : paData.oParameter,
                                tIframeNameID : paData.tIframeNameID
                            }
                                JCNxRftOpenFormat(aDataOpenReport);
                        }
                    }else{
                        FSvCMNSetMsgWarningDialog(aDataReturn['rtDesc']);
                    }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        JCNxResponseError(jqXHR, textStatus, errorThrown);
                    }
                });

        } catch (err) {
            console.log('JSvCallListSeasonChain Error: ', err);
        }
}

//Functionality : 
//Parameters : -
//Creator : 06/10/2021 Nale
//Return : 
//Return Type : 
function JCNxRftSelectFormat(e) {


}


//Functionality : 
//Parameters : -
//Creator : 06/10/2021 Nale
//Return : 
//Return Type : 
function JCNxRftOpenFormat(paData) {

    var tBaseUrl = $('#ohdBaseUrlUseInJS').val();
    var dGetDate = new Date(); 
    var nGetTime = dGetDate.getTime(); 

    var tOuputSteam = tBaseUrl;
    tOuputSteam += paData.FTRptPath+'?v='+nGetTime+'&Agncode='+paData.FTAgnCode+'&Filename='+paData.FTRptFileName
    for (const [tKey, tValue] of Object.entries(paData.oParameter)) {
        tOuputSteam += '&'+tKey+'='+tValue;
      }


      if(paData.tIframeNameID=='oifPrint'){
        var nValue = $('input[name=orbPrintRft]:checked').val();
        if(nValue == 2){ //พิมพ์บางหน้า
            var nOnlyPage = $('#oetPrintAgainRft').val();
            if(nOnlyPage == '' || nOnlyPage == null){
                var nPrintOnlyPage = 1;
            }else{
                var nPrintOnlyPage = nOnlyPage;
            }
        }else{
            var nPrintOnlyPage = 'ALL';
        }
        tOuputSteam += '&PrintByPage='+nPrintOnlyPage;
     }
    // tOuputSteam += paData.FTRptPath
    // console.log(tOuputSteam);
    // console.log(paData.oParameter);
    if(paData.tIframeNameID!=''){
        $("#"+paData.tIframeNameID).prop('src',tOuputSteam);
    }else{
         window.open( tOuputSteam, '_blank');
    }
 
}


//Functionality : 
//Parameters : -
//Creator : 06/10/2021 Nale
//Return : 
//Return Type : 
$('#obtRftConfirmFormat').click(function(){
    var tAgncode = $('#otbRftSelectReport>tbody>tr.xActiveRpt').attr('agncode');
    var tRtppath = $('#otbRftSelectReport>tbody>tr.xActiveRpt').attr('rptpath');
    var tRptfilename = $('#otbRftSelectReport>tbody>tr.xActiveRpt').attr('rptfilename');
    var oParameter = localStorage.getItem("oParameter");  
    var tIframeNameID = localStorage.getItem("tIframeNameID");  
    
    var aDataOpenReport = {
        FTAgnCode : tAgncode,
        FTRptPath : tRtppath,
        FTRptFileName : tRptfilename,
        oParameter :  JSON.parse(oParameter),
        tIframeNameID : tIframeNameID
    }
    // console.log(aDataOpenReport);
        JCNxRftOpenFormat(aDataOpenReport);
    $('#odvModalRft').modal('hide');
    localStorage.setItem("oParameter", '');  
    localStorage.setItem("tIframeNameID", '');  
});