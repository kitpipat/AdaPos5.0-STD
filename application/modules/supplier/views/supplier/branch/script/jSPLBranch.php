<script type="text/javascript">
    $(document).ready(function(){
        localStorage.removeItem('LocalItemData');
        JSxCheckPinMenuClose(); /*Check เปิดปิด Menu ตาม Pin*/
        JSxSplBranchNavDefult();

        JSxSPLBranchList();
    });


    //function : Function Clear Defult Button Supplier
    //Parameters : Document Ready
    //Creator : 10/10/2018 Phisan
    //Return : Show Tab Menu
    //Return Type : -
    function JSxSplBranchNavDefult() {
            $('.xCNChoose').hide();
            $('#oliSplBranchTitleAdd').hide();
            $('#oliSplBranchTitleEdit').hide();
            $('#odvSPLBranchBtnAddEdit').hide();
            $('#odvBtnSplBranchInfo').show();
    }

    //function : Function Clear Defult Button Supplier
    //Parameters : Document Ready
    //Creator : 10/10/2018 Phisan
    //Return : Show Tab Menu
    //Return Type : -
    function JSxSPLBranchList(){
    JCNxOpenLoading();
    $.ajax({
                type: "POST",
                url: "supplierBranchList",
                cache: false,
                timeout: 0,
                success: function(tResult){
                    $('#odvContentPageSPLBranch').html(tResult);
                    JSxSPLBranchDataTable();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    JCNxResponseError(jqXHR, textStatus, errorThrown);
                }
            });

    }

    //function: Call Product Type Data List
    //Parameters: Ajax Success Event
    //Creator:	10/10/2018 phisan
    //Return: View
    //Return Type: View
    function JSxSPLBranchDataTable(pnPage) {
        var tSearchAll = $('#oetSearchSPLBranch').val();
        var tSPLBranchSplCode = $('#oetSPLBranchSplCode').val();
        var tSPLBranchBchCode = $('#oetSPLBranchBchCode').val();
        var nPageCurrent = (pnPage === undefined || pnPage == '') ? '1' : pnPage;
        $.ajax({
            type: "POST",
            url: "supplierBranchDataTable",
            data: {
                tSearchAll: tSearchAll,
                nPageCurrent: nPageCurrent,
                tSPLBranchSplCode : tSPLBranchSplCode,
                tSPLBranchBchCode : tSPLBranchBchCode,
            },
            cache: false,
            Timeout: 0,
            success: function(tResult) {
                if (tResult != "") {
                    $('#ostDataSPLBranch').html(tResult);
                    if(tSPLBranchSplCode!=''){
                        $('.othSPLBranchShow1').hide();
                    }
                    
                    if(tSPLBranchBchCode!=''){
                        $('.othSPLBranchShow2').hide();
                    }
                    
                }
                JSxSplBranchNavDefult();
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    }


    //Functionality : Call Page Supplier Add
    //Parameters : Event Button Click
    //Creator : 10/10/2018 phisan
    //Return : View
    //Return Type : View
    function JSxSPLBranchPageAdd() {
        JCNxOpenLoading();
        $.ajax({
            type: "POST",
            url: "supplierPageAddBranch",
            cache: false,
            timeout: 0,
            success: function(tResult) {
                 $('#oliSplBranchTitleEdit').hide();
                    $('#oliSplBranchTitleAdd').show();
                    $('#odvBtnSplBranchInfo').hide();
                    $('#odvSPLBranchBtnAddEdit').show();
                $('#odvContentPageSPLBranch').html(tResult);
           
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    }
   //Functionality : Call Page Supplier Add
    //Parameters : Event Button Click
    //Creator : 10/10/2018 phisan
    //Return : View
    //Return Type : View
    function JSvCallPageSPLBranchEdit(ptSplCode,ptBchCode) {
    JCNxOpenLoading();
        $.ajax({
            type: "POST",
            url: "supplierBranchPageEdit",
            cache: false,
            data: {
                ptSplCode : ptSplCode,
                ptBchCode : ptBchCode,
            },
            timeout: 0,
            success: function(tResult) {
                 $('#oliSplBranchTitleEdit').hide();
                    $('#oliSplBranchTitleAdd').show();
                    $('#odvBtnSplBranchInfo').hide();
                    $('#odvSPLBranchBtnAddEdit').show();
                $('#odvContentPageSPLBranch').html(tResult);
           
                JCNxCloseLoading();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    }
    //Functionality : Call Page Supplier Add
    //Parameters : Event Button Click
    //Creator : 10/10/2018 phisan
    //Return : View
    //Return Type : View
    function JSxSPLAddEditBranch() {
  
        if($('#oetSBHSplCode').val()==''){
            return     FSvCMNSetMsgWarningDialog('กรุณาระบุผู้จำหน่าย');
        }

        if($('#oetSBHBchCode').val()==''){
            return     FSvCMNSetMsgWarningDialog('กรุณาระบุสาขา');
        }
        JCNxOpenLoading();
        var tRoute = $('#oetSBHtRoute').val();
                $.ajax({
                    type: "POST",
                    url: tRoute,
                    data: $('#ofmSplBranch').serialize(),
                    success: function(oResult) {
                            var aReturn = JSON.parse(oResult);
                            if (aReturn['nStaEvent'] == 1) {
                                JSxSPLBranchList();
                            } else {
                                FSvCMNSetMsgWarningDialog(aReturn['tStaMessg']);
                                JCNxCloseLoading();
                                //JSvCallPageSupplierList();
                            }
                       
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        JCNxResponseError(jqXHR, textStatus, errorThrown);
                    }
                });
    }



    function JSoSPLBranchDel(ptSplCode, ptBchCode) {
    // alert(ptSplCode);
    var aData = $('#ohdConfirmIDDelete').val();
    var aTexts = aData.substring(0, aData.length - 2);
    var aDataSplit = aTexts.split(" , ");
    var aDataSplitlength = aDataSplit.length;
    var aNewIdDelete = [];

    var tConfirm = $('#ohdDeleteconfirm').val();
    var tConfirmYN = $('#ohdDeleteconfirmYN').val();

    $('#odvModalDelSPLBranch').modal('show');
    $('#ospConfirmDeleteSPLBranch').html(tConfirm + " " + ' (' + ptBchCode + ')' + tConfirmYN);
    $('#osmConfirmSPLBranch').on('click', function(evt) {
        JCNxOpenLoading();
        $.ajax({
            type: "POST",
            url: "supplierBranchEventDelete",
            data: { ptSplCode: ptSplCode ,ptBchCode:ptBchCode  },
            cache: false,
            timeout: 0,
            success: function(oResult) {
                // console.log(oResult);
                // var aReturn = JSON.parse(oResult);

                JSxSPLBranchDataTable(1);
                $('.modal-backdrop').remove();
                JSxSplBranchNavDefult();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    });

}

//Functionality : เปลี่ยนหน้า pagenation
//Parameters : Event Click Pagenation
//Creator : 17/09/2018 phisan
//Return : View
//Return Type : View
function JSvSPLBranchClickPage(ptPage) {
    var nPageCurrent = '';
    switch (ptPage) {
        case 'next': //กดปุ่ม Next
            $('.xWBtnNext').addClass('disabled');
            nPageOld = $('.xWPageSPLBranch .active').text(); // Get เลขก่อนหน้า
            nPageNew = parseInt(nPageOld, 10) + 1; // +1 จำนวน
            nPageCurrent = nPageNew
            break;
        case 'previous': //กดปุ่ม Previous
            nPageOld = $('.xWPageSPLBranch .active').text(); // Get เลขก่อนหน้า
            nPageNew = parseInt(nPageOld, 10) - 1; // -1 จำนวน
            nPageCurrent = nPageNew
            break;
        default:
            nPageCurrent = ptPage
    }
    JCNxOpenLoading();
    JSxSPLBranchDataTable(nPageCurrent);
}


</script>
