<script type="text/javascript">

$('.xDPSRefInt').click(function(){
    var tBchCode = $(this).data('bchcode');
    var tDocNo = $(this).data('docno');
    JSxDPSCallRefIntDocDetailDataTable(tBchCode,tDocNo);
    $('.xDPSRefInt').removeClass('active');
    $(this).addClass('active');

})

// Function Check Data Search And Add In Tabel DT Temp
function JSvDPSRefIntClickPageList(ptPage){
    var nPageCurrent = '';
    switch (ptPage) {
        case 'next': //กดปุ่ม Next
            $('.xWBtnNext').addClass('disabled');
            nPageOld    = $('.xWPIPageDataTable .active').text(); // Get เลขก่อนหน้า
            nPageNew    = parseInt(nPageOld, 10) + 1; // +1 จำนวน
            nPageCurrent = nPageNew
            break;
        case 'previous': //กดปุ่ม Previous
            nPageOld    = $('.xWPIPageDataTable .active').text(); // Get เลขก่อนหน้า
            nPageNew    = parseInt(nPageOld, 10) - 1; // -1 จำนวน
            nPageCurrent = nPageNew
            break;
        default:
            nPageCurrent = ptPage
    }
    JCNxOpenLoading();
    JSxRefIntDocHDDataTable(nPageCurrent);
}


// ดึงรายละเอียดภายในเอกสารอ้างอิง
function JSxDPSCallRefIntDocDetailDataTable(ptBchCode,ptDocNo){
    let tDPSTypeRef = $('#ocmDPSSelectBrowse').val();
    JCNxOpenLoading();
    $.ajax({
        type: "POST",
        url: "dcmDPSCallRefIntDocDetailDataTableQT",
        data: {
            'ptBchCode'     : ptBchCode,
            'ptDocNo'       : ptDocNo,
            'tDPSTypeRef'   : tDPSTypeRef
        },
        cache: false,
        Timeout: 0,
        success: function (oResult){
            $('#odvDPSRefIntDocDetail').html(oResult);
            JCNxCloseLoading();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            // JSxRefIntDocHDDataTable(pnPage)
            JCNxResponseError(jqXHR, textStatus, errorThrown);
        }
    });
}



</script>