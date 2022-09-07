<?php 
    if($aPdtDataList['rtCode'] == '1'){
        $nCurrentPage = $aPdtDataList['rnCurrentPage'];
    }else{
        $nCurrentPage = '1';
    }
    $nAPJColspan = 8;
?>

<div class="">
    <div class="col-md-12">
        <div class="table-responsive">
            <table id="otbPbnDataList" class="table table-striped"> <!-- เปลี่ยน -->
                <thead>
                    <tr>
                       <th nowrap class="text-center xCNTextBold" style="width:10%;">      <label class="fancy-checkbox">
                                        <input id="ocbListItemAll" type="checkbox" class="ocbListItem" name="ocbListItem[]"  value="all"  checked >
                                        <span>&nbsp;<?= language('product/product/product','tAdjPdtSelect')?></span>
                                    </th>
                        <!-- <th class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tAdjPdtBranch')?></th> -->
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tAdjPdtCode').language('product/product/product','tAdjPdtProduct')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tAdjPdtName').language('product/product/product','tAdjPdtProduct')?></th>
                        <?php if($aConditionAdjustProduct['tAJPSelectTable']=='TCNMPdtPackSize' || $aConditionAdjustProduct['tAJPSelectTable']=='TCNMPdtBar' || $aConditionAdjustProduct['tAJPSelectTable']=='TFHMPdtColorSize'): $nAPJColspan++; ?>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tAdjPdtUnit')?></th>
                        <?php endif; ?>
                        <?php if($aConditionAdjustProduct['tAJPSelectTable']=='TCNMPdtBar' || $aConditionAdjustProduct['tAJPSelectTable']=='TFHMPdtColorSize'): $nAPJColspan++ ?>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tAdjPdtBarCode')?></th>
                        <?php endif; ?>
                        <?php if($aConditionAdjustProduct['tAJPSelectTable']=='TFHMPdtColorSize'): $nAPJColspan = $nAPJColspan+10 ?>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtDataTableRefCode')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtDepart')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtClass')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtSubClass')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtGroup')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtComLines')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtDataTableSeason')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtDataTableFabric')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtDataTableColor')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tFhnPdtDataTableSize')?></th>
                        <?php endif; ?>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tAdjPdtGroup')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tAdjPdtBrand')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tAdjPdtModel')?></th>
                        <th nowrap class="text-center xCNTextBold" style="width:10%;"><?= language('product/product/product','tAdjPdtType')?></th>
                    </tr>
                </thead>
                <tbody>
                <?php
                    if($aPdtDataList['rtCode']=='1'){
                            foreach($aPdtDataList['raItems'] as $aData){
                ?>
                            <tr class="text-center xCNTextDetail2 otrPdtPbn">
                   
                                <td class="text-center">
                                    <label class="fancy-checkbox">
                                        <input id="ocbListItem" type="checkbox" class="ocbListItem" name="ocbListItem[<?=$aData['FNRowID']?>]"  value="<?=$aData['FNRowID']?>" <?php if($aData['FTStaAlwSet']=='1'){ echo 'checked'; } ?>>
                                        <span>&nbsp;</span>
                                    </label>
                                </td>
                                <!-- <td nowrap class="text-left"><?=$aData['FTBchName']?></td> -->
                                <td nowrap class="text-left"><?=$aData['FTPdtCode']?></td>
                                <td nowrap class="text-left"><?=$aData['FTPdtName']?></td>
                                <?php if($aConditionAdjustProduct['tAJPSelectTable']=='TCNMPdtPackSize' || $aConditionAdjustProduct['tAJPSelectTable']=='TCNMPdtBar' || $aConditionAdjustProduct['tAJPSelectTable']=='TFHMPdtColorSize'): ?>
                                <td nowrap class="text-left"><?=$aData['FTPunName']?></td>
                                <?php endif; ?>
                                <?php if($aConditionAdjustProduct['tAJPSelectTable']=='TCNMPdtBar' || $aConditionAdjustProduct['tAJPSelectTable']=='TFHMPdtColorSize'): ?>
                                <td nowrap class="text-left"><?=$aData['FTBarCode']?></td>
                                <?php endif; ?>
                                <?php if($aConditionAdjustProduct['tAJPSelectTable']=='TFHMPdtColorSize'): $nAPJColspan++ ?>
                                <td nowrap class="text-left"><?=$aData['FTFhnRefCode']?></td>
                                <td nowrap class="text-left"><?=$aData['FTDepName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTClsName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTSclName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTFhnPgpName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTCmlName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTSeaName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTFabName']?></td>
                                <td nowrap class="text-left"><?php if(!empty($aData['FTClrCode'])){ echo'('.$aData['FTClrCode'].') '; } echo $aData['FTClrName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTPszName']?></td>
                                <?php endif; ?>
                                <td nowrap class="text-left"><?=$aData['FTPgpName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTPbnName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTPmoName']?></td>
                                <td nowrap class="text-left"><?=$aData['FTPtyName']?></td>
                            
                             
                            </tr>
                <?php 
                            }
                            
                         }else{ ?>
                        <tr><td class='text-center xCNTextDetail2' colspan='<?=$nAPJColspan?>'><?= language('product/product/product','tPdtSrnSetNoData')?></td></tr>
                 <?php } ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
<input type="hidden" id="ohdAJPCountSelectRow" value="<?=$aPdtDataList['rnRowsChked']?>">
<input type="hidden" id="nPagePDTAll" value="<?=$aPdtDataList['rnAllRow']?>">
<div class="">
    <div class="col-md-6">
        <p><?= language('common/main/main','tResultTotalRecord')?> <?=$aPdtDataList['rnAllRow']?> <?= language('common/main/main','tRecord')?> <?= language('common/main/main','tCurrentPage')?> <?=$aPdtDataList['rnCurrentPage']?> / <?=$aPdtDataList['rnAllPage']?></p>
    </div>
    <div class="col-md-6">
        <div class="xWPageAPJ btn-toolbar pull-right"> <!-- เปลี่ยนชื่อ Class เป็นของเรื่องนั้นๆ --> 
            <?php if($nPage == 1){ $tDisabledLeft = 'disabled'; }else{ $tDisabledLeft = '-';} ?>
            <button onclick="JSvAPJClickPage('previous')" class="btn btn-white btn-sm" <?php echo $tDisabledLeft ?>> <!-- เปลี่ยนชื่อ Onclick เป็นของเรื่องนั้นๆ --> 
                <i class="fa fa-chevron-left f-s-14 t-plus-1"></i>
            </button>
            <?php for($i=max($nPage-2, 1); $i<=max(0, min($aPdtDataList['rnAllPage'],$nPage+2)); $i++){?> <!-- เปลี่ยนชื่อ Parameter Loop เป็นของเรื่องนั้นๆ --> 
                <?php 
                    if($nPage == $i){ 
                        $tActive = 'active'; 
                        $tDisPageNumber = 'disabled';
                    }else{ 
                        $tActive = '';
                        $tDisPageNumber = '';
                    }
                ?>
                <!-- เปลี่ยนชื่อ Onclick เป็นของเรื่องนั้นๆ --> 
                <button onclick="JSvAPJClickPage('<?php echo $i?>')" type="button" class="btn xCNBTNNumPagenation <?php echo $tActive ?>" <?php echo $tDisPageNumber ?>><?php echo $i?></button>
            <?php } ?>
            <?php if($nPage >= $aPdtDataList['rnAllPage']){  $tDisabledRight = 'disabled'; }else{  $tDisabledRight = '-';  } ?>
            <button onclick="JSvAPJClickPage('next')" class="btn btn-white btn-sm" <?php echo $tDisabledRight ?>> <!-- เปลี่ยนชื่อ Onclick เป็นของเรื่องนั้นๆ --> 
                <i class="fa fa-chevron-right f-s-14 t-plus-1"></i>
            </button>
        </div>
    </div>
</div>

<div class="modal fade" id="odvModalDelPdtPbn">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header xCNModalHead">
				<label class="xCNTextModalHeard"><?=language('common/main/main', 'tModalDelete')?></label>
			</div>
			<div class="modal-body">
				<span id="ospConfirmDelete"> - </span>
				<input type='hidden' id="ohdConfirmIDDelete">
			</div>
			<div class="modal-footer">
				<button id="osmConfirm" type="button" class="btn xCNBTNPrimery" onClick="JSoPdtPbnDelChoose('<?=$nCurrentPage?>')"><?=language('common/main/main', 'tModalConfirm')?></button>
        		<button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?=language('common/main/main', 'tModalCancel')?></button>
			</div>
		</div>
	</div>
</div>
<script>

if($('#ohdCheckedAll').val()==1){
    $('#ocbListItemAll').prop('checked',true);
}else{
    $('#ocbListItemAll').prop('checked',false);
}
$('.ocbListItem').on('change',function(){
    // console.log(this.value);
    // console.log(this.checked);

    if(this.checked==true){
        var nStaAlwSet = 1;
    }else{
        var nStaAlwSet = 2;
    }

    let oPdtListChk = {
        nRowID : this.value,
        nStaAlwSet : nStaAlwSet
    }
    JSxAPJUpdateStaAlw(oPdtListChk);
    if(this.value=='all'){
            $('#ohdCheckedAll').val(nStaAlwSet);
            if(nStaAlwSet==1){
                $('.ocbListItem').prop('checked',true);
            }else{
                $('.ocbListItem').prop('checked',false);
            }
     }

});
</script>