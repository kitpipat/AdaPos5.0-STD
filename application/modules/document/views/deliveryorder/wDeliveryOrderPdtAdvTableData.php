<style>
    #odvRowDataEndOfBill .panel-heading{
        padding-top     : 10px !important;
        padding-bottom  : 10px !important;
    }
    #odvRowDataEndOfBill .panel-body{
        padding-top     : 0px !important;
        padding-bottom  : 0px !important;
    }
    #odvRowDataEndOfBill .list-group-item {
        padding-left    : 0px !important;
        padding-right   : 0px !important;
        border          : 0px solid #ddd;
    }
    .mark-font, .panel-default > .panel-heading.mark-font{
        color           : #232C3D !important;
        font-weight     : 900;
    }

</style>
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
    <div class="table-responsive">
        <input type="text" class="xCNHide" id="ohdBrowseDataPdtCode" value="">
        <input type="text" class="xCNHide" id="ohdBrowseDataPunCode" value="">
        <input type="text" class="xCNHide" id="ohdEditInlinePdtCode" value="<?php echo $tDOPdtCode;?>">
        <input type="text" class="xCNHide" id="ohdEditInlinePunCode" value="<?php echo $tDOPunCode;?>">
        <input type="text" class="xCNHide" id="ohdDORtCode" value="<?php echo $aDataDocDTTemp['rtCode'];?>">
        <input type="text" class="xCNHide" id="ohdDOStaDoc" value="<?php echo $tDOStaDoc;?>">
        <input type="text" class="xCNHide" id="ohdDOStaApv" value="<?php echo $tDOStaApv;?>">
        <table id="otbDODocPdtAdvTableList" class="table xWPdtTableFont">
            <thead>
                <tr class="xCNCenter">
                    <th class="text-center" id="othCheckboxHide">
                        <label class="fancy-checkbox">
                            <input id="ocbCheckAll" type="checkbox" class="ocbListItemAll" name="ocbCheckAll" onclick="FSxDOSelectAll(this)">
                            <span class="">&nbsp;</span>
                        </label>
                    </th>
                    <th class="xCNTextBold"><?=language('document/deliveryorder/deliveryorder','tDOTable_pdtcode')?></th>
                    <th class="xCNTextBold"><?=language('document/deliveryorder/deliveryorder','tDOTable_pdtname')?></th>
                    <th class="xCNTextBold"><?=language('document/deliveryorder/deliveryorder','tDOTable_barcode')?></th>
                    <th class="xCNTextBold"><?=language('document/deliveryorder/deliveryorder','tDOTable_qty')?></th>
                    <th class="xCNTextBold"><?=language('document/deliveryorder/deliveryorder','tDOTable_unit')?></th>
                    <th class="xCNPIBeHideMQSS"><?php echo language('common/main/main','tCMNActionDelete')?></th>
                </tr>
            </thead>
            <tbody id="odvTBodyDOPdtAdvTableList">
            <?php 
                if($aDataDocDTTemp['rtCode'] == 1):
                    foreach($aDataDocDTTemp['raItems'] as $DataTableKey => $aDataTableVal): 
                        $nKey = $aDataTableVal['FNXtdSeqNo'];
            ?>
                    <tr class="otr<?=$aDataTableVal['FTPdtCode'];?><?php echo $aDataTableVal['FTXtdBarCode'];?> xWPdtItem xWPdtItemList<?=$nKey?>" 
                        data-alwvat="<?=$aDataTableVal['FTXtdVatType'];?>" 
                        data-vat="<?=$aDataTableVal['FCXtdVatRate']?>" 
                        data-key="<?=$nKey?>" 
                        data-pdtcode="<?=$aDataTableVal['FTPdtCode'];?>" 
                        data-pdtName="<?=$aDataTableVal['FTXtdPdtName'];?>" 
                        data-seqno="<?=$nKey?>" 
                        data-setprice="<?=$aDataTableVal['FCXtdSetPrice'];?>" 
                        data-qty="<?=$aDataTableVal['FCXtdQty'];?>" 
                        data-netafhd="<?=$aDataTableVal['FCXtdNetAfHD'];?>" 
                        data-net="<?=$aDataTableVal['FCXtdNet'];?>" 
                        data-stadis="<?=$aDataTableVal['FTXtdStaAlwDis'];?>" 
                    >
                        <td class="otdListItem">
                            <label class="fancy-checkbox text-center">
                                <input id="ocbListItem<?=$nKey?>" type="checkbox" class="ocbListItem" name="ocbListItem[]" onclick="FSxDOSelectMulDel(this)">
                                <span class="ospListItem">&nbsp;</span>
                            </label>
                        </td>
                        <td><?=$aDataTableVal['FTPdtCode'];?></td>

                        <?php if($aDataTableVal['FTTmpStatus'] == '5' && $tDOStaDoc == '3'){?>
                            <td>
                            <div class="xWEditInLine<?=$nKey?>">
                                <input type="text" class="xCNQty xCNHide form-control xCNPdtEditInLine xWValueEditNameInLine<?=$nKey?> xWShowNameInLine<?=$nKey?> " id="ohdPdtName<?=$nKey?>" name="ohdPdtName<?=$nKey?>" data-seq="<?=$nKey?>" value="<?=$aDataTableVal['FTXtdPdtName'];?>" autocomplete="off">
                            </div>
                            <?=$aDataTableVal['FTXtdPdtName'];?>
                        </td>
                        <?php }elseif($aDataTableVal['FTTmpStatus'] == '5' && $tDOStaApv != '1'){?>
                        <td>
                            <div class="xWEditInLine<?=$nKey?>">
                                <input type="text" class="xCNQty form-control xCNPdtEditInLine xWValueEditNameInLine<?=$nKey?> xWShowNameInLine<?=$nKey?> " id="ohdPdtName<?=$nKey?>" name="ohdPdtName<?=$nKey?>" data-seq="<?=$nKey?>" value="<?=$aDataTableVal['FTXtdPdtName'];?>" autocomplete="off">
                            </div>
                        </td>
                        <?php }else{ ?>
                        <td>
                            <div class="xWEditInLine<?=$nKey?>">
                                <input type="text" class="xCNQty xCNHide form-control xCNPdtEditInLine xWValueEditNameInLine<?=$nKey?> xWShowNameInLine<?=$nKey?> " id="ohdPdtName<?=$nKey?>" name="ohdPdtName<?=$nKey?>" data-seq="<?=$nKey?>" value="<?=$aDataTableVal['FTXtdPdtName'];?>" autocomplete="off">
                            </div>
                            <?=$aDataTableVal['FTXtdPdtName'];?>
                        </td>
                        <?php } ?>

                        <!-- <td><?=$aDataTableVal['FTXtdPdtName'];?></td> -->


                        <td><?=$aDataTableVal['FTXtdBarCode'];?></td>
                        <td><?=$aDataTableVal['FTPunName'];?></td>

                        <td class="otdQty">
                            <div class="xWEditInLine<?=$nKey?>">
                                <input type="text" class="xCNQty form-control xCNInputNumericWithDecimal xCNPdtEditInLine text-right xWValueEditInLine<?=$nKey?> xWShowInLine<?=$nKey?> " id="ohdQty<?=$nKey?>" name="ohdQty<?=$nKey?>" data-seq="<?=$nKey?>" maxlength="10" value="<?=str_replace(",","",number_format($aDataTableVal['FCXtdQty'],2));?>" autocomplete="off">
                            </div>
                        </td>
                        <td nowrap="" class="text-center xCNPIBeHideMQSS">
                            <label class="xCNTextLink">
                                <img class="xCNIconTable xWDelDocRef" src="application/modules/common/assets/images/icons/delete.png" title="Remove" onclick="JSnDODelPdtInDTTempSingle(this)">
                            </label>
                        </td>
                    </tr>
            <?php 
                    endforeach;
                else:
            ?>
                <tr><td class="text-center xCNTextDetail2 xCNTextNotfoundDataPdtTable" colspan="100%"><?php echo language('common/main/main','tCMNNotFoundData')?></td></tr>
            <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

<!-- ============================================ Modal Confirm Delete Documet Detail Dis ============================================ -->
    <div id="odvDOModalConfirmDeleteDTDis" class="modal fade" style="z-index: 7000;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header xCNModalHead">
                    <label class="xCNTextModalHeard"><?= language('common/main/main', 'tDOMsgNotificationChangeData') ?></label>
                </div>
                <div class="modal-body">
                    <label><?php echo language('document/purchaseorder/purchaseorder','tDOMsgTextNotificationChangeData');?></label>
                </div>
                <div class="modal-footer">
                    <button id="obtDOConfirmDeleteDTDis" type="button"  class="btn xCNBTNPrimery" data-dismiss="modal"><?php echo language('common/main/main', 'tModalConfirm');?></button>
                    <button id="obtDOCancelDeleteDTDis" type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?php echo language('common/main/main', 'ยกเลิก');?></button>
                </div>
            </div>
        </div>
    </div>
<!-- ================================================================================================================================= -->



<!--ลบสินค้าแบบตัวเดียว-->
<div id="odvModalDelDocSingle" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <label class="xCNTextModalHeard"><?php echo language('common/main/main', 'tModalDelete')?></label>
            </div>
            <div class="modal-body">
                <span id="ospTextConfirmDelSingle" class="xCNTextModal" style="display: inline-block; word-break:break-all"></span>
            </div>
            <div class="modal-footer">
                <button id="osmTWIConfirmPdtDTTemp" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button"><?php echo language('common/main/main', 'tModalConfirm')?></button>
                <button class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"  data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel')?></button>
            </div>
        </div>
    </div>
</div>

<!--ลบสินค้าแบบหลายตัว-->
<div id="odvModalDelDocMultiple" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <label class="xCNTextModalHeard"><?php echo language('common/main/main','tModalDelete')?></label>
            </div>
            <div class="modal-body">
                <span id="ospTextConfirmDelMultiple" class="xCNTextModal" style="display: inline-block; word-break:break-all"></span>
                <input type='hidden' id="ohdConfirmIDDelMultiple">
            </div>
            <div class="modal-footer">
                <button id="osmConfirmDelMultiple" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button"><?php echo language('common/main/main', 'tModalConfirm')?></button>
                <button class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"  data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel')?></button>
            </div>
        </div>
    </div>
</div>
<?php  include("script/jDeliveryOrderPdtAdvTableData.php");?>

<script>  
    
    $( document ).ready(function() {
        JSxAddScollBarInTablePdt();
        JSxEditQtyAndPrice();    
        if($('#ohdDOStaApv').val()==1 && $('#ohdDOStaDoc').val()==1){
            $('.xCNBTNPrimeryDisChgPlus').hide();
            $("#othCheckboxHide").hide();
            $(".xCNPIBeHideMQSS").hide();
            $(".xCNIconTable").attr("onclick", "").unbind("click");
            $('.xCNPdtEditInLine').attr('readonly',true);
            $('#obtDOBrowseCustomer').attr('disabled',true);
            $('.otdListItem').hide();
        }else if($('#ohdDOStaDoc').val()==3){
            $('.xCNBTNPrimeryDisChgPlus').hide();
            $("#othCheckboxHide").hide();
            $(".xCNPIBeHideMQSS").hide();
            $(".xCNIconTable").attr("onclick", "").unbind("click");
            $('.xCNPdtEditInLine').attr('readonly',true);
            $('#obtDOBrowseCustomer').attr('disabled',true);
            $('.otdListItem').hide();
        }

        JSxDOCountPdtItems()
    
    });


    // Next Func จาก Browse PDT Center
    function FSvDONextFuncB4SelPDT(ptPdtData){
        var aPackData = JSON.parse(ptPdtData);
        // console.log(aPackData[0]);
        for(var i=0;i<aPackData.length;i++){
            var aNewPackData = JSON.stringify(aPackData[i]);
            var aNewPackData = "["+aNewPackData+"]";
            FSvDOAddPdtIntoDocDTTemp(aNewPackData);         // Append HMTL
            FSvDOAddBarcodeIntoDocDTTemp(aNewPackData);     // Insert Database
        }
    }

    // Append PDT
    function FSvDOAddPdtIntoDocDTTemp(ptPdtData){
        JCNxCloseLoading();
        var aPackData = JSON.parse(ptPdtData);
        //console.log(aPackData[0]);
        var tCheckIteminTableClass = $('#otbDODocPdtAdvTableList tbody tr td').hasClass('xCNTextNotfoundDataPdtTable');
        var nDOODecimalShow = $('#ohdDOODecimalShow').val();
        // var tCheckIteminTable = $('#otbDODocPdtAdvTableList tbody tr').length;
        if(tCheckIteminTableClass==true){
            $('#otbDODocPdtAdvTableList tbody').html('');
            var nKey    = 1;
        }else{
            var nKey    = parseInt($('#otbDODocPdtAdvTableList tr:last').attr('data-seqno')) + parseInt(1);
        }

        var nLen    = aPackData.length;
        var tHTML   = '';
        // var nKey    = parseInt($('#otbDODocPdtAdvTableList tbody tr').length) + parseInt(1);
        
        for(var i=0; i<nLen; i++){

            var oData           = aPackData[i];
            var oResult         = oData.packData;

            //console.log(oResult);

            oResult.NetAfHD     = (oResult.NetAfHD == '' || oResult.NetAfHD === undefined ? 0 : oResult.NetAfHD);
            oResult.Qty         = (oResult.Qty == '' || oResult.Qty === undefined ? 1 : oResult.Qty);
            oResult.Net         = (oResult.Net == '' || oResult.Net === undefined ? oResult.Price : oResult.Net);
            oResult.tDisChgTxt  = (oResult.tDisChgTxt == '' || oResult.tDisChgTxt === undefined ? '' : oResult.tDisChgTxt);

            var tBarCode        = oResult.Barcode;          //บาร์โค๊ด
            var tProductCode    = oResult.PDTCode;          //รหัสสินค้า
            var tProductName    = oResult.PDTName;          //ชื่อสินค้า
            var tUnitName       = oResult.PUNName;          //ชื่อหน่วยสินค้า
            var nQty            = parseInt(oResult.Qty);             //จำนวน
            var tTypePDT        = oResult.tTypePDT


            // console.log(oData);

            var tDuplicate = $('#otbDODocPdtAdvTableList tbody tr').hasClass('otr'+tProductCode+tBarCode);
            var InfoOthReAddPdt = $('#ocmDOFrmInfoOthReAddPdt').val();
            if(tDuplicate == true && InfoOthReAddPdt==1){
                //ถ้าสินค้าซ้ำ ให้เอา Qty +1
                var nValOld     = $('.otr'+tProductCode+tBarCode).find('.xCNQty').val();
                var nNewValue   = parseInt(nValOld) + parseInt(1);

                // รวมสินค้าซ้ำกรณีที่เปลี่ยนจากเลือกแบบแยกรายการเป็นบวกในรายการเดียวกัน
                var tCname = 'otr'+tProductCode+tBarCode;
                $('.'+tCname).each(function (e) { 
                        if(e == '0'){
                            $(this).find('.xCNQty').val(nNewValue);
                        }
                });

                //$('.otr'+tProductCode+tBarCode).find('.xCNQty').val(nNewValue);
            }else{//ถ้าสินค้าไม่ซ้ำ ก็บวกเพิ่มต่อเลย
                //จำนวน
                var oQty = '<div class="xWEditInLine'+nKey+'">';
                    oQty += '<input ';
                    oQty += 'type="text" ';
                    oQty += 'class="xCNQty form-control xCNInputNumericWithDecimal xCNPdtEditInLine text-right xWValueEditInLine'+nKey+' xWShowInLine'+nKey+' "';
                    oQty += 'id="ohdQty'+nKey+'" ';
                    oQty += 'name="ohdQty'+nKey+'" '; 
                    oQty += 'data-seq='+nKey+' ';
                    oQty += 'maxlength="10" '; 
                    oQty += 'value="'+nQty+'"';
                    oQty += 'autocomplete="off" >';
                    oQty += '</div>';  

                tHTML += '<tr class="otr'+tProductCode+''+tBarCode+' xWPdtItem xWPdtItemList'+nKey+'"';
                tHTML += '  data-key="'+nKey+'"';
                tHTML += '  data-pdtcode="'+tProductCode+'"';
                tHTML += '  data-seqno="'+nKey+'"';
                tHTML += '  data-qty="'+nQty+'"';
                tHTML += '  data-TypePdt="'+tTypePDT+'"';

                tHTML += '>';
                tHTML += '<td class="otdListItem">';
                tHTML += '  <label class="fancy-checkbox text-center">';
                tHTML += '      <input id="ocbListItem'+nKey+'" type="checkbox" class="ocbListItem" name="ocbListItem[]" onclick="FSxDOSelectMulDel(this)">';
                tHTML += '      <span class="ospListItem">&nbsp;</span>';
                tHTML += '  </label>';
                tHTML += '</td>';
                tHTML += '<td>'+tProductCode+'</td>';

                if(tTypePDT == '5'){
                    tHTML += '<td><div class="xWEditInLine'+nKey+'">';
                    tHTML += '<input ';
                    tHTML += 'type="text" ';
                    tHTML += 'class="xCNName form-control xCNPdtEditInLine text-left xWValueEditNameInLine'+nKey+' xWShowNameInLine'+nKey+' "';
                    tHTML += 'id="ohdPdtName'+nKey+'" ';
                    tHTML += 'name="ohdPdtName'+nKey+'" '; 
                    tHTML += 'data-seq='+nKey+' ';
                    tHTML += 'value="'+tProductName+'"';
                    tHTML += 'autocomplete="off" >';
                    tHTML += '</div></td>';  
                }else{
                    tHTML += '<td><div class="xWEditInLine'+nKey+'">';
                    tHTML += '<input ';
                    tHTML += 'type="text" ';
                    tHTML += 'class="xCNName xCNHide form-control xCNPdtEditInLine text-left xWValueEditNameInLine'+nKey+' xWShowNameInLine'+nKey+' "';
                    tHTML += 'id="ohdPdtName'+nKey+'" ';
                    tHTML += 'name="ohdPdtName'+nKey+'" '; 
                    tHTML += 'data-seq='+nKey+' ';
                    tHTML += 'value="'+tProductName+'"';
                    tHTML += 'autocomplete="off" >';
                    tHTML += tProductName+'</div></td>';  
                }
                // tHTML += '<td>'+tProductName+'</td>';

                tHTML += '<td>'+tBarCode+'</td>';
                tHTML += '<td>'+tUnitName+'</td>';
                tHTML += '<td class="otdQty">'+oQty+'</td>';
                if($('#ohdPOSTaImport').val()==1){
                tHTML += '<td class="xDOImportDT"> </td>';
                }
                tHTML += '<td nowrap class="text-center xCNPIBeHideMQSS">';
                tHTML += '  <label class="xCNTextLink">';
                tHTML += '      <img class="xCNIconTable xWDelDocRef" src="application/modules/common/assets/images/icons/delete.png" title="Remove" onclick="JSnDODelPdtInDTTempSingle(this)">';
                tHTML += '  </label>';
                tHTML += '</td>';
                tHTML += '</tr>';
                nKey++;
            }
        }

        //สร้างตาราง
        $('#otbDODocPdtAdvTableList tbody').append(tHTML);

        JSxDOCountPdtItems();
        JSxAddScollBarInTablePdt();
        JSxEditQtyAndPrice();
    }
    // Check All
    $('#ocbCheckAll').click(function(){
        if($(this).is(':checked')==true){
            $('.ocbListItem').prop('checked',true);
            $("#odvDOMngDelPdtInTableDT #oliDOBtnDeleteMulti").removeClass("disabled");
        }else{
            $('.ocbListItem').prop('checked',false);
            $("#odvDOMngDelPdtInTableDT #oliDOBtnDeleteMulti").addClass("disabled");
        }
    });

    function FSxDOSelectMulDel(ptElm){
    // $('#otbDODocPdtAdvTableList #odvTBodyDOPdtAdvTableList .ocbListItem').click(function(){
        let tDODocNo    = $('#oetDODocNo').val();
        let tDOSeqNo    = $(ptElm).parents('.xWPdtItem').data('key');
        let tDOPdtCode  = $(ptElm).parents('.xWPdtItem').data('pdtcode');
        let tDOBarCode  = $(ptElm).parents('.xWPdtItem').data('barcode');
        var nDOODecimalShow = $('#ohdDOODecimalShow').val();
        // let tDOPunCode  = $(this).parents('.xWPdtItem').data('puncode');
        $(ptElm).prop('checked', true);
        let oLocalItemDTTemp    = localStorage.getItem("DO_LocalItemDataDelDtTemp");
        let oDataObj            = [];
        if(oLocalItemDTTemp){
            oDataObj    = JSON.parse(oLocalItemDTTemp);
        }
        let aArrayConvert   = [JSON.parse(localStorage.getItem("DO_LocalItemDataDelDtTemp"))];
        if(aArrayConvert == '' || aArrayConvert == null){
            oDataObj.push({
                'tDocNo'    : tDODocNo,
                'tSeqNo'    : tDOSeqNo,
                'tPdtCode'  : tDOPdtCode,
                'tBarCode'  : tDOBarCode,
                // 'tPunCode'  : tDOPunCode,
            });
            localStorage.setItem("DO_LocalItemDataDelDtTemp",JSON.stringify(oDataObj));
            JSxDOTextInModalDelPdtDtTemp();
        }else{
            var aReturnRepeat   = JStDOFindObjectByKey(aArrayConvert[0],'tSeqNo',tDOSeqNo);
            if(aReturnRepeat == 'None' ){
                //ยังไม่ถูกเลือก
                oDataObj.push({
                    'tDocNo'    : tDODocNo,
                    'tSeqNo'    : tDOSeqNo,
                    'tPdtCode'  : tDOPdtCode,
                    'tBarCode'  : tDOBarCode,
                    // 'tPunCode'  : tDOPunCode,
                });
                localStorage.setItem("DO_LocalItemDataDelDtTemp",JSON.stringify(oDataObj));
                JSxDOTextInModalDelPdtDtTemp();
            }else if(aReturnRepeat == 'Dupilcate'){
                localStorage.removeItem("DO_LocalItemDataDelDtTemp");
                $(ptElm).prop('checked', false);
                var nLength = aArrayConvert[0].length;
                for($i=0; $i<nLength; $i++){
                    if(aArrayConvert[0][$i].tSeqNo == tDOSeqNo){
                        delete aArrayConvert[0][$i];
                    }
                }
                var aNewarraydata   = [];
                for($i=0; $i<nLength; $i++){
                    if(aArrayConvert[0][$i] != undefined){
                        aNewarraydata.push(aArrayConvert[0][$i]);
                    }
                }
                localStorage.setItem("DO_LocalItemDataDelDtTemp",JSON.stringify(aNewarraydata));
                JSxDOTextInModalDelPdtDtTemp();
            }
        }
        JSxDOShowButtonDelMutiDtTemp();
        // });
    }

    function JSxAddScollBarInTablePdt(){
        $('#otbDODocPdtAdvTableList >tbody >tr').css('background-color','#ffffff');
        var rowCount = $('#otbDODocPdtAdvTableList >tbody >tr').length;
            if(rowCount >= 2){
                $('#otbDODocPdtAdvTableList >tbody >tr').last().css('background-color','rgb(226, 243, 255)');
        
            }
            
        if(rowCount >= 7){
            $('.xWShowInLine' + rowCount).focus();

            $('html, body').animate({
                scrollTop: ($("#oetDOInsertBarcode").offset().top)-80
            }, 0);
        }

        if($('#oetDOFrmCstCode').val() != ''){
            $('#oetDOInsertBarcode').focus();
        }
    }

        //เเก้ไขจำนวน
    function JSxEditQtyAndPrice() {
        $('.xCNPdtEditInLine').click(function() {
            $(this).focus().select();
        });

        // $('.xCNQty').change(function(e){
        $('.xCNPdtEditInLine').off().on('change keyup', function(e) {
            if(e.type === 'change' || e.keyCode === 13){
                var nSeq    = $(this).attr('data-seq');
                var nQty        = $('#ohdQty'+nSeq).val();
                nNextTab = parseInt(nSeq)+1;
                $('.xWValueEditInLine'+nNextTab).focus().select();
                
                JSxGetDisChgList(nSeq);
            }
        });

    }

    //เเก้ไขจำนวน และ ราคา
    function JSxGetDisChgList(pnSeq){

        var nQty        = $('#ohdQty'+pnSeq).val();
        var tDODocNo        = $("#oetDODocNo").val();
        var tDOBchCode      = $("#ohdDOBchCode").val();
        var tName        = $('#ohdPdtName'+pnSeq).val();

        if(pnSeq != undefined){
            $.ajax({
                type    : "POST",
                url     : "docDOEditPdtInDTDocTemp",
                data    : {
                    'tDOBchCode'        : tDOBchCode,
                    'tDODocNo'          : tDODocNo,
                    'nDOSeqNo'          : pnSeq,
                    'FTXtdPdtName'      : tName,
                    'nQty'              : nQty
                },
                catch   : false,
                timeout : 0,
                success : function (oResult){ },
                error   : function (jqXHR, textStatus, errorThrown) { }
            });
        }
    }

    $(document).on("keypress", 'form', function (e) {
        var code = e.keyCode || e.which;
        if (code == 13) {
            e.preventDefault();
            return false;
        }
    });

    function FSxDOSelectAll(){
    if($('.ocbListItemAll').is(":checked")){
        $('.ocbListItem').each(function (e) { 
            if(!$(this).is(":checked")){
                $(this).on( "click", FSxDOSelectMulDel(this) );
            }
    });
    }else{
        $('.ocbListItem').each(function (e) { 
            if($(this).is(":checked")){
                $(this).on( "click", FSxDOSelectMulDel(this) );
            }
    });
    }
    
}

</script>


