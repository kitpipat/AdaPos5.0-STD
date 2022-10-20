<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 p-t-10">
    <table class="table xWPdtTableFont">
        <thead>
            <tr class="xCNCenter">
                <th nowrap ><?php echo language('document/expenserecord/expenserecord','ประเภทอ้างอิง')?></th>
                <th nowrap><?php echo language('document/expenserecord/expenserecord','เลขที่เอกสารอ้างอิง')?></th>
                <th nowrap ><?php echo language('document/expenserecord/expenserecord','วันที่เอกสารอ้างอิง')?></th>
                <th nowrap ><?php echo language('document/expenserecord/expenserecord','ค่าอ้างอิง')?></th>
                <th nowrap class="xCNTextBold xCNHideWhenCancelOrApprove" style="width:70px;"><?php echo language('common/main/main','tCMNActionDelete')?></th>
                <th nowrap class="xCNTextBold xCNHideWhenCancelOrApprove" style="width:70px;"><?php echo language('common/main/main','tCMNActionEdit')?></th>
            </tr>
        </thead>
        <tbody>
            <?php if( $aDataDocHDRef['tCode'] == '1' ){
                foreach($aDataDocHDRef['aItems'] as $aValue){ ?>
                    <tr data-refdocno="<?=$aValue['FTXthRefDocNo']?>" data-reftype="<?=$aValue['FTXthRefType']?>" data-refdocdate="<?=date_format(date_create($aValue['FDXthRefDocDate']),'Y-m-d')?>" data-refkey="<?=$aValue['FTXthRefKey']?>" >
                        <td nowrap><?=language('document/document/document','tDocRefType'.$aValue['FTXthRefType'])?></td>
                        <td nowrap><?=$aValue['FTXthRefDocNo']?></td>
                        <td nowrap class="text-center"><?=date_format(date_create($aValue['FDXthRefDocDate']),'Y-m-d')?></td>
                        <td nowrap class="text-left">
                            <?php if( $aValue['FTXthRefType'] != '' ){ echo $aValue['FTXthRefKey']; }else{ echo "-"; } ?>
                        </td>
                        <td nowrap class="text-center xCNHideWhenCancelOrApprove">
                            <img class="xCNIconTable xCNIconDel xWDelDocRef" src="<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>">
                        </td>
                        <td nowrap class="text-center xCNHideWhenCancelOrApprove">
                            <img class="xCNIconTable xWEditDocRef" src="<?=base_url().'/application/modules/common/assets/images/icons/edit.png'?>">
                        </td>
                    </tr>
                <?php } ?>
            <?php }else{ ?>
                <tr><td class="text-center xCNTextDetail2" colspan="100%"><?php echo language('common/main/main','tCMNNotFoundData')?></td></tr>
            <?php } ?>
        </tbody>
    </table>
</div>

<script>

    var nQTStaApv =  $('#ohdTQStaApv').val();
    var nQTStaDoc =  $('#ohdTQStaDoc').val();
    if(nQTStaApv == 1 || nQTStaDoc == 3){
        //เพิ่มข้อมูลสินค้า
        $('.xCNHideWhenCancelOrApprove').hide();
    }

    //กดลบข้อมูล
    $('.xWDelDocRef').off('click').on('click',function(){
        var tRefDocNo = $(this).parents().parents().attr('data-refdocno');
        JCNxOpenLoading();
        $.ajax({
            type    : "POST",
            url     : "docDPSEventDelHDDocRef",
            data:{
                'ptDocNo'         : $('#oetTQDocNo').val(),
                'ptRefDocNo'      : tRefDocNo
            },
            cache: false,
            timeout: 0,
            success: function(oResult){
                var aResult = JSON.parse(oResult);
                if( aResult['nStaEvent'] == 1 ){
                    FSxQTCallPageHDDocRef();
                }else{
                    var tMessageError = aResult['tStaMessg'];
                    FSvCMNSetMsgErrorDialog(tMessageError);
                    JCNxCloseLoading();
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                JCNxResponseError(jqXHR, textStatus, errorThrown);
            }
        });
    });

    //กดแก้ไข
    $('.xWEditDocRef').off('click').on('click',function(){
        var tRefDocNo   = $(this).parents().parents().attr('data-refdocno');
        var tRefType    = $(this).parents().parents().attr('data-reftype');
        var tRefDocDate = $(this).parents().parents().attr('data-refdocdate');
        var tRefKey     = $(this).parents().parents().attr('data-refkey');
        $('#ocbDPSRefType').val(tRefType);
        $('#ocbDPSRefType').selectpicker('refresh');
        $('#oetDPSRefDocDate').datepicker({ dateFormat: 'yy-mm-dd' }).val(tRefDocDate);

        if(tRefType == 1){//ภายใน
            $('#oetDPSDocRefIntName').val(tRefDocNo);
            $('#oetDPSDocRefInt').val(tRefDocNo);
        }else{ //ภายนอก
            $('#oetDPSRefDocNo').val(tRefDocNo);
        }

        $('#oetDPSRefKey').val(tRefKey);
        $('#oetDPSRefDocNoOld').val(tRefDocNo);
        $('#odvDPSModalAddDocRef').modal('show');
    });
    
</script>
    