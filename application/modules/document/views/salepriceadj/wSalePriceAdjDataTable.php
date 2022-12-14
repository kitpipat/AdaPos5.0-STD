<?php 
    $nCurrentPage = '1';
?>
<div class="row">
    <div class="col-md-12">
        <div class="table-responsive">

            <table id="otbSpaDataList" class="table table-striped"> 
                <thead>
                    <tr>
                        <?php if($aAlwEventSalePriceAdj['tAutStaFull'] == 1 || $aAlwEventSalePriceAdj['tAutStaDelete'] == 1) : ?>
                            <th nowrap class="xCNTextBold text-center" style="width:5%;">
                                <label class="fancy-checkbox">
                                    <input type="checkbox" class="ocmCENCheckDeleteAll" id="ocmCENCheckDeleteAll" >
                                    <span class="ospListItem">&nbsp;</span>
                                </label>
                            </th>                        
                        <?php endif; ?>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?php echo  language('document/salepriceadj/salepriceadj','tTBSpaBchCode')?></th>
                        <th nowrap class="text-center xCNTextBold" ><?php echo  language('document/salepriceadj/salepriceadj','tTBSpaDocNo')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?php echo  language('document/salepriceadj/salepriceadj','tTBSpaDocDate')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:8%;"><?php echo  language('document/salepriceadj/salepriceadj','tTBSpaStaDoc')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:8%;"><?php echo  language('document/salepriceadj/salepriceadj','tTBSpaStaPrcDoc')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('document/salepriceadj/salepriceadj', 'tLabel1') ?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?php echo  language('document/salepriceadj/salepriceadj','tTBSpaCreateBy')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?php echo  language('document/salepriceadj/salepriceadj','tTBSpaUsrApv')?></th>
                        <?php if($aAlwEventSalePriceAdj['tAutStaFull'] == 1 || $aAlwEventSalePriceAdj['tAutStaDelete'] == 1) : ?>
                        <th nowrap class="text-center xCNTextBold" style="width:5%;"><?php echo  language('document/salepriceadj/salepriceadj','tTBSpaDelete')?></th>
                        <?php endif; ?>
                        <?php if($aAlwEventSalePriceAdj['tAutStaFull'] == 1 || ($aAlwEventSalePriceAdj['tAutStaEdit'] == 1 || $aAlwEventSalePriceAdj['tAutStaRead'] == 1))  : ?>
                        <th nowrap class="text-center xCNTextBold" style="width:5%;"><?php echo  language('document/salepriceadj/salepriceadj','tTBSpaEdit')?></th>
                        <?php endif; ?>
                    </tr>
                </thead>
                <tbody>
                    <?php if($aSpaDataList['rtCode'] == 1 ):?>
                        <?php foreach($aSpaDataList['raItems'] AS $nKey => $aValue):
                            if($aValue['FTXphStaApv']=="" || $aValue['FTXphStaDoc'] == 3){
                                $tXphUsrApv = language('document/salepriceadj/salepriceadj','tSpaStaEmtpy');
                            }else{
                                $tXphUsrApv = $aValue['FTXphUsrApv'];
                            }

                            /*===== Begin UsedStatus ===================================*/
                            $tClassStaUse = "";
                            $tPmtUsedStatusShow = "";
                            if ($aValue['UsedStatus'] == "1") {
                                $tClassStaUse = 'text-warning';
                                $tPmtUsedStatusShow = language('document/salepriceadj/salepriceadj', 'tLabel2');
                            }

                            if (in_array($aValue['UsedStatus'], ["2","3"])) {
                                $tClassStaUse = 'text-success';
                                if($aValue['UsedStatus'] == "2"){
                                    $tPmtUsedStatusShow = language('document/salepriceadj/salepriceadj', 'tLabel3');
                                }else{
                                    $tPmtUsedStatusShow = language('document/salepriceadj/salepriceadj', 'tLabel4');
                                }  
                            }

                            if (in_array($aValue['UsedStatus'], ["4","5"])) {
                                $tClassStaUse = 'text-danger';
                                if($aValue['UsedStatus'] == "4"){
                                    $tPmtUsedStatusShow = language('document/salepriceadj/salepriceadj', 'tLabel5');
                                }else{
                                    $tPmtUsedStatusShow = language('document/salepriceadj/salepriceadj', 'tLabel6');
                                }
                            }

                            if($aValue['FTXphStaDoc'] == 3){
                                $tClassStaDoc = 'text-danger';
                                $tStaDoc = language('common/main/main', 'tStaDoc3');
                            }else if(!empty($aValue['FTXphStaApv'])){
                                $tClassStaDoc = 'text-success';
                                $tStaDoc = language('common/main/main', 'tStaDoc1'); 
                            }else{
                                $tClassStaDoc = 'text-warning';
                                $tStaDoc = language('common/main/main', 'tStaDoc');
                            }

                            if ($aValue['FTXphStaPrcDoc'] == 1) {
                                $tClassPrcStk = 'text-success';
                                $tStaPrcDoc = language('common/main/main', 'tStaPrcDoc1');
                            } else if ($aValue['FTXphStaPrcDoc'] == 2) {
                                $tClassPrcStk = 'text-warning';
                                $tStaPrcDoc = language('common/main/main', 'tStaPrcDoc2');
                            } else if ($aValue['FTXphStaPrcDoc'] == 0 || $aValue['FTXphStaPrcDoc'] == '') {
                                $tClassPrcStk = 'text-warning';
                                $tStaPrcDoc = language('common/main/main', 'tStaPrcDoc3');
                            }

                            /*===== End UsedStatus =====================================*/
                        ?>
                            
                            <tr class="text-left xCNTextDetail2 otrPdtSpa" id="otrPdtSpa<?php echo $nKey?>" data-doc="<?php echo $aValue['FTXphDocNo']?>" data-bch="<?php echo $aValue['FTBchCode']?>">
                                <?php if($aAlwEventSalePriceAdj['tAutStaFull'] == 1 || $aAlwEventSalePriceAdj['tAutStaDelete'] == 1) : ?>
                                <td nowrap class="text-center">
                                    <label class="fancy-checkbox">
                                        <input id="ocbListItem<?php echo $nKey?>" type="checkbox" class="ocbListItem" name="ocbListItem[]" <?php if($aValue['FTXphStaApv']!="" || $aValue['FTXphStaDoc']=="3"){ echo "disabled"; } ?>>
                                        <span <?php if($aValue['FTXphStaApv']!="" || $aValue['FTXphStaDoc']=="3"){ echo "class='xCNDocDisabled'"; } ?>>&nbsp;</span>
                                    </label>
                                </td>
                                <?php endif; ?>
                                <td nowrap><?php echo $aValue['FTBchName']?></td>
                                <td nowrap><?php echo $aValue['FTXphDocNo']?></td>
                                <td nowrap class="text-center"><?php echo date("d/m/Y",strtotime($aValue['FDXphDocDate']));?></td>
                                <!-- <td nowrap><?php echo language('document/salepriceadj/salepriceadj', 'tSpaADDXphStaDocn'.$aValue['FTXphStaDoc']);?></td> -->
                                <td nowrap class="text-left"><label class="xCNTDTextStatus <?= $tClassStaDoc ?>"><?php echo $tStaDoc; ?></label></td>
                                <td nowrap class="text-left"><label class="xCNTDTextStatus <?= $tClassPrcStk ?>"><?php echo $tStaPrcDoc; ?></label></td>
                                <td class="text-left"><label class="xCNTDTextStatus <?= $tClassStaUse ?>"><?php echo $tPmtUsedStatusShow; ?></label></td>
                                <td nowrap><?php echo $aValue['FTCreateBy']?></td>
                                <td nowrap><?php echo $tXphUsrApv?></td>
                                <?php if($aAlwEventSalePriceAdj['tAutStaFull'] == 1 || $aAlwEventSalePriceAdj['tAutStaDelete'] == 1) : ?>
                                <td  class="text-center <?php if($aValue['FTXphStaApv']!="" || $aValue['FTXphStaDoc']=="3"){ echo "xWTdDisable"; } ?>" nowrap ><img class="xCNIconTable <?php if($aValue['FTXphStaApv']!="" || $aValue['FTXphStaDoc']=="3"){ echo "xWImgDisable"; } ?>" src="<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>" onClick="JSoSpaDel('<?php echo $nCurrentPage?>','<?php echo $aValue['FTXphDocNo']?>')" <?php if($aValue['FTXphStaApv']!="" || $aValue['FTXphStaDoc']=="3"){ echo "disabled"; } ?>></td>
                                <?php endif; ?>
                                <?php if($aAlwEventSalePriceAdj['tAutStaFull'] == 1 || ($aAlwEventSalePriceAdj['tAutStaEdit'] == 1 || $aAlwEventSalePriceAdj['tAutStaRead'] == 1)) : ?>
                                    <td class="text-center">
                                        <?php if($aValue['FTXphStaApv'] == 1 || $aValue['FTXphStaDoc'] == 3){ ?>
                                            <img class="xCNIconTable" style="width: 17px;" src="<?=base_url().'/application/modules/common/assets/images/icons/view2.png'?>" onClick="JSvCallPageSpaEdit('<?=$aValue['FTXphDocNo']?>')">
                                        <?php }else{ ?>
                                            <img class="xCNIconTable" src="<?=base_url().'/application/modules/common/assets/images/icons/edit.png'?>" onClick="JSvCallPageSpaEdit('<?=$aValue['FTXphDocNo']?>')">
                                        <?php } ?>
                                    </td>
                                <?php endif; ?>
                            </tr>
                        <?php endforeach;?>
                    <?php else:?>
                        <tr><td nowrap class='text-center xCNTextDetail2' colspan='99'><?php echo  language('common/main/main','tCMNNotFoundData')?></td></tr>
                    <?php endif;?>
                </tbody>
            </table>

        </div>
    </div>
</div>

<div class="row">
    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
        <?php $nShowRecord = get_cookie('nShowRecordInPageList'); ?>
        <p>?????????????????????????????????????????????????????????????????? <?=$nShowRecord?> ??????????????????</p>
    </div>
</div>
<div class="modal fade" id="odvModalDelSpa">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header xCNModalHead">
				<label class="xCNTextModalHeard"><?php echo language('common/main/main', 'tModalDelete')?></label>
			</div>
			<div class="modal-body">
				<span id="ospConfirmDelete"> - </span>
				<input type='hidden' id="ohdConfirmIDDelete">
			</div>
			<div class="modal-footer">
				<button id="osmConfirm" type="button" class="btn xCNBTNPrimery" onClick="JSoSpaDelChoose('<?php echo $nCurrentPage?>')"><?php echo language('common/main/main', 'tModalConfirm')?></button>
        		<button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel')?></button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
    $('ducument').ready(function(){
        JSxShowButtonChoose();
        var aArrayConvert = [JSON.parse(localStorage.getItem("LocalItemData"))];
        var nlength = $('#odvRGPList').children('tr').length;
        for($i=0; $i < nlength; $i++){
            var tDataCode = $('#otrPdtSpa'+$i).data('code')
            if(aArrayConvert == null || aArrayConvert == ''){
            }else{
                var aReturnRepeat = findObjectByKey(aArrayConvert[0],'nCode',tDataCode);
                if(aReturnRepeat == 'Dupilcate'){
                    $('#ocbListItem'+$i).prop('checked', true);
                }else{ }
            }
        }

        $('.ocbListItem').click(function(){
            var nCode = $(this).parent().parent().parent().data('doc');  //code
            var tName = $(this).parent().parent().parent().data('bch');  //code
            $(this).prop('checked', true);
            var LocalItemData = localStorage.getItem("LocalItemData");
            var obj = [];
            if(LocalItemData){
                obj = JSON.parse(LocalItemData);
            }else{ }
            var aArrayConvert = [JSON.parse(localStorage.getItem("LocalItemData"))];
            if(aArrayConvert == '' || aArrayConvert == null){
                obj.push({"nCode": nCode, "tName": tName });
                localStorage.setItem("LocalItemData",JSON.stringify(obj));
                JSxTextinModal();
            }else{
                var aReturnRepeat = findObjectByKey(aArrayConvert[0],'nCode',nCode);
                if(aReturnRepeat == 'None' ){           //??????????????????????????????????????????
                    obj.push({"nCode": nCode, "tName": tName });
                    localStorage.setItem("LocalItemData",JSON.stringify(obj));
                    JSxTextinModal();
                }else if(aReturnRepeat == 'Dupilcate'){	//?????????????????????????????????????????????
                    localStorage.removeItem("LocalItemData");
                    $(this).prop('checked', false);
                    var nLength = aArrayConvert[0].length;
                    for($i=0; $i<nLength; $i++){
                        if(aArrayConvert[0][$i].nCode == nCode){
                            delete aArrayConvert[0][$i];
                        }
                    }
                    var aNewarraydata = [];
                    for($i=0; $i<nLength; $i++){
                        if(aArrayConvert[0][$i] != undefined){
                            aNewarraydata.push(aArrayConvert[0][$i]);
                        }
                    }
                    localStorage.setItem("LocalItemData",JSON.stringify(aNewarraydata));
                    JSxTextinModal();
                }
            }
            JSxShowButtonChoose();
        })
    });
</script>