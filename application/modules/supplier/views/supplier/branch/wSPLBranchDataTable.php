<style>
    /* .xWSPLBranchActive {
        color: #007b00 !important;
        font-weight: bold;
        cursor: default;
    }
    .xWSPLBranchInActive {
        color: #7b7f7b !important;
        font-weight: bold;
        cursor: default;
    }
    .xWSPLBranchCancle {
        color: #f60a0a !important;
        font-weight: bold;
        cursor: default;
    } */
</style>
<?php 
    if($aDataList['rtCode'] == '1'){
        $nCurrentPage = $aDataList['rnCurrentPage'];
    }else{
        $nCurrentPage = '1';
    }
?>
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
        <div class="table-responsive">
            <table id="otbSplDataList" class="table table-striped">
                <thead>
                    <tr>
                        <th nowarp class="text-center xCNTextBold othSPLBranchShow1" width="20%"><?php echo  language('supplier/supplier/supplier','tSPLBranchSplName')?></th>
                        <th nowarp class="text-center xCNTextBold othSPLBranchShow2" width="20%"><?php echo  language('supplier/supplier/supplier','tSPLBranchBchName')?></th>
                        <th nowarp class="text-center xCNTextBold" width="12%"><?php echo  language('supplier/supplier/supplier','tSbhLeadTime')?></th>
                        <th nowarp class="text-center xCNTextBold" width="8%"><?php echo  language('supplier/supplier/supplier','tSbhOrdDay')?></th>
                        <th nowarp class="text-center xCNTextBold" width="15%"><?php echo  language('supplier/supplier/supplier','tSbhStaAlwOrdTitle')?></th>
                        <th nowarp class="text-center xCNTextBold" width="5%"><?php echo  language('supplier/supplier/supplier','tDelete')?></th>
                        <th nowarp class="text-center xCNTextBold" width="5%"><?php echo  language('supplier/supplier/supplier','tEdit')?></th>
                    </tr>
                </thead>
                <tbody>
                    <?php if($aDataList['rtCode'] == 1 ):?>
                        <?php foreach($aDataList['raItems'] AS $nKey => $aValue):
                            $cDecimalShow = FCNxHGetOptionDecimalShow();
                            ?>
                            <tr class="xCNTextDetail2 otrSPLBranch" id="otrSPLBranch<?php echo $nKey?>" data-code="<?php echo $aValue['FTSplCode']?>">
                                
                                <td nowarp class="othSPLBranchShow1"><?php echo $aValue['FTSplName']?></td>
                                <td nowarp class="othSPLBranchShow2"><?php echo $aValue['FTBchName']?></td>
                                <td nowarp><?php echo number_format($aValue['FCSbhLeadTime'],$cDecimalShow)?></td>
                                <td nowarp><?php echo $aValue['FTSbhOrdDay']?></td>
                                <td nowarp><?php
                                $nSplBchFlag = 0;
                                if($aValue['FTSbhStaAlwOrdSun']=='1'){
                                    echo language('supplier/supplier/supplier','tSbhStaOrdSun');
                                    $nSplBchFlag = 1;
                                }
                                if($aValue['FTSbhStaAlwOrdMon']=='1'){
                                    if($nSplBchFlag==1){
                                        echo ',';
                                    }
                                    echo language('supplier/supplier/supplier','tSbhStaOrdMon');
                                    $nSplBchFlag = 1;
                                }
                                if($aValue['FTSbhStaAlwOrdTue']=='1'){
                                    if($nSplBchFlag==1){
                                        echo ',';
                                    }
                                    echo language('supplier/supplier/supplier','tSbhStaOrdTue');
                                    $nSplBchFlag = 1;
                                }
                                if($aValue['FTSbhStaAlwOrdWed']=='1'){
                                    if($nSplBchFlag==1){
                                        echo ',';
                                    }
                                    echo language('supplier/supplier/supplier','tSbhStaOrdWed');
                                    $nSplBchFlag = 1;
                                }
                                if($aValue['FTSbhStaAlwOrdThu']=='1'){
                                    if($nSplBchFlag==1){
                                        echo ',';
                                    }
                                    echo language('supplier/supplier/supplier','tSbhStaOrdThu');
                                    $nSplBchFlag = 1;
                                }
                                if($aValue['FTSbhStaAlwOrdFri']=='1'){
                                    if($nSplBchFlag==1){
                                        echo ',';
                                    }
                                    echo language('supplier/supplier/supplier','tSbhStaOrdFri');
                                    $nSplBchFlag = 1;
                                }
                                if($aValue['FTSbhStaAlwOrdSat']=='1'){
                                    if($nSplBchFlag==1){
                                        echo ',';
                                    }
                                    echo language('supplier/supplier/supplier','tSbhStaOrdSat');
                                    $nSplBchFlag = 1;
                                }
                                ?></td>
                                <td nowarp class="text-center">
                                    <img class="xCNIconTable" src="<?php echo  base_url().'/application/modules/common/assets/images/icons/delete.png'?>" onClick="JSoSPLBranchDel('<?php echo $aValue['FTSplCode']?>','<?php echo $aValue['FTBchCode']?>')">
                                </td>
                                <td nowarp class="text-center">
                                    <img class="xCNIconTable" src="<?php echo  base_url().'/application/modules/common/assets/images/icons/edit.png'?>" onClick="JSvCallPageSPLBranchEdit('<?php echo $aValue['FTSplCode']?>','<?php echo $aValue['FTBchCode']?>')">
                                </td>
                            </tr>
                        <?php endforeach;?>
                    <?php else:?>
                        <tr><td class='text-center xCNTextDetail2' colspan='9'><?php echo language('supplier/supplier/supplier','tSPLTBNoData')?></td></tr>
                    <?php endif;?>
                </tbody>
            </table>
        </div>
    </div>
    

    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
        <p><?php echo language('common/main/main','tResultTotalRecord')?> <?php echo $aDataList['rnAllRow']?> <?php echo language('common/main/main','tRecord')?> <?= language('common/main/main','tCurrentPage')?> <?php echo $aDataList['rnCurrentPage']?> / <?php echo $aDataList['rnAllPage']?></p>
    </div>
    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
        <div class="xWPageSPLBranch btn-toolbar pull-right">
            <?php if($nPage == 1){ $tDisabledLeft = 'disabled'; }else{ $tDisabledLeft = '-';} ?>
            <button onclick="JSvSPLBranchClickPage('previous')" class="btn btn-white btn-sm" <?php echo $tDisabledLeft ?>>
                <i class="fa fa-chevron-left f-s-14 t-plus-1"></i>
            </button>
            <?php for($i=max($nPage-2, 1); $i<=max(0, min($aDataList['rnAllPage'],$nPage+2)); $i++){?>
                <?php 
                    if($nPage == $i){ 
                        $tActive = 'active'; 
                        $tDisPageNumber = 'disabled';
                    }else{ 
                        $tActive = '';
                        $tDisPageNumber = '';
                    }
                ?>
                <button onclick="JSvSPLBranchClickPage('<?php echo $i?>')" type="button" class="btn xCNBTNNumPagenation <?php echo $tActive ?>" <?php echo $tDisPageNumber ?>><?php echo $i?></button>
            <?php } ?>
            <?php if($nPage >= $aDataList['rnAllPage']){  $tDisabledRight = 'disabled'; }else{  $tDisabledRight = '-';  } ?>
            <button onclick="JSvSPLBranchClickPage('next')" class="btn btn-white btn-sm" <?php echo $tDisabledRight ?>>
                <i class="fa fa-chevron-right f-s-14 t-plus-1"></i>
            </button>
        </div>
    </div>

    

    <div class="modal fade" id="odvModalDelSPLBranch">
	<div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <label class="xCNTextModalHeard"><?php echo language('common/main/main', 'tModalDelete')?></label>
            </div>
            <div class="modal-body">
                <span id="ospConfirmDeleteSPLBranch" class="xCNTextModal"></span>
                <input type='hidden' id="ohdConfirmIDDelete">
            </div>
            <div class="modal-footer">
                <button id="osmConfirmSPLBranch" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button">
                    <?php echo language('common/main/main', 'tModalConfirm')?>
                </button>
                <button class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"  data-dismiss="modal">
                    <?php echo language('common/main/main', 'tModalCancel')?>
                </button>
            </div>
        </div>
    </div>
</div>
    
<script type="text/javascript">
    $('.ocbListItem').click(function(){
        var nCode = $(this).parent().parent().parent().data('code');  //code
        var tName = $(this).parent().parent().parent().data('name');  //code
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
            if(aReturnRepeat == 'None' ){           //ยังไม่ถูกเลือก
                obj.push({"nCode": nCode, "tName": tName });
                localStorage.setItem("LocalItemData",JSON.stringify(obj));
                JSxTextinModal();
            }else if(aReturnRepeat == 'Dupilcate'){	//เคยเลือกไว้แล้ว
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
</script>