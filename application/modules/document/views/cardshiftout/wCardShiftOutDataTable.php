<div class="row">
    <div class="col-md-12">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <?php if ($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaDelete'] == 1) { ?>
                            <th class="xCNTextBold text-center" style="width:5%;"><?= language('common/main/main', 'tCMNChoose') ?></th>
                        <?php } ?>
                        <th nowrap class="xCNTextBold text-center" style="width:20%;"><?php echo language('document/card/cardout','tCardShiftOutTBBranchCode'); ?></th>
                        <th nowrap class="xCNTextBold text-center" style="width:20%;"><?php echo language('document/card/cardout','tCardShiftOutTBDocNo'); ?></th>
                        <th nowrap class="xCNTextBold text-center" style="width:10%;"><?php echo language('document/card/cardout','tCardShiftOutTBDocDate'); ?></th>
                        <th nowrap class="xCNTextBold text-center" style="width:10%;"><?php echo language('document/card/cardout','tCardShiftOutTBCardNumber'); ?></th>
                        <th nowrap class="xCNTextBold text-center" style="width:10%;"><?php echo language('document/card/cardout','tCardShiftOutTBDocStatus'); ?></th>
                        <th nowrap class="xCNTextBold text-center" style="width:10%;"><?php echo language('document/card/cardout','tCardShiftOutTBApproveStatus'); ?></th>
                        <?php if ($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaDelete'] == 1) { ?>
                            <th class="xCNTextBold text-center" style="width:5%;"><?= language('common/main/main', 'tCMNActionDelete') ?></th>
                        <?php } ?>
                        <?php if($aAlwEvent['tAutStaFull'] == 1 || ($aAlwEvent['tAutStaEdit'] == 1 || $aAlwEvent['tAutStaRead'] == 1))  : ?>
                        <th nowrap class="xCNTextBold text-center" style="width:5%;"><?php echo language('document/card/cardout','tCardShiftOutTBEdit'); ?></th>
                        <?php endif; ?>
                    </tr>
                </thead>
                <tbody id="odvRGPList">
                <?php if($aDataList['rtCode'] == 1 ):?>
                    <?php foreach($aDataList['raItems'] AS $key => $aValue) : ?>
                        <?php
                            $nCurrentPage = $aDataList['rnCurrentPage'];
                            $bIsApvOrCancel = ($aValue['rtCardShiftOutCshStaPrcDoc'] == 1 || $aValue['rtCardShiftOutCshStaPrcDoc'] == 2) || ($aValue['rtCardShiftOutCshStaDoc'] == 3 );

                            if ($bIsApvOrCancel) {
                                $CheckboxDisabled = "disabled";
                                $ClassDisabled = 'xCNDocDisabled';
                                $Title = language('document/document/document', 'tDOCMsgCanNotDel');
                                $Onclick = '';
                            } else {
                                $CheckboxDisabled = "";
                                $ClassDisabled = '';
                                $Title = '';
                                $Onclick = "onclick=JSxCardShiftOutDocDel('" . $nCurrentPage . "','" . $aValue['rtCardShiftOutDocNo'] . "','".$aValue['rtCardShiftOutBchCode']."')";
                            }
                        ?>
                        <tr 
                        class="text-center xCNTextDetail2 otrCardShiftOut"
                        data-doc-no="<?php echo $aValue['rtCardShiftOutDocNo']; ?>"
                        data-bch-code="<?php echo $aValue['rtCardShiftOutBchCode']; ?>">

                            <?php if ($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaDelete'] == 1) { ?>
                                <td class="text-center">
                                    <label class="fancy-checkbox ">
                                        <input type="checkbox" class="ocbListItem" name="ocbListItem[]" <?= $CheckboxDisabled ?>>
                                        <span class="<?= $ClassDisabled ?>">&nbsp;</span>
                                    </label>
                                </td>
                            <?php } ?>
                            <td nowrap class="text-left xCNBchCode"><?php echo @$aValue['rtCardShiftOutBchCode']?></td>
                            <td nowrap class="text-left"><?php echo @$aValue['rtCardShiftOutDocNo']; ?></td>
                            <td nowrap class="text-center"><?php echo date('d/m/Y', strtotime(@$aValue['rtCardShiftOutDocDate'])); ?></td>
                            <td nowrap class="text-right"><?php echo @number_format($aValue['rtCardShiftOutCshCardQty'], 0); ?></td>
                            <?php
                            $tCshStaDoc = "";
                                //StaDoc
                                if ($aValue['rtCardShiftOutCshStaDoc'] == 1) {
                                    $tClassStaDoc = 'text-success';
                                } else if ($aValue['rtCardShiftOutCshStaDoc'] == 2) {
                                    $tClassStaDoc = 'text-warning';
                                } else if ($aValue['rtCardShiftOutCshStaDoc'] == 3) {
                                    $tClassStaDoc = 'text-danger';
                                }
                            if(@$aValue['rtCardShiftOutCshStaDoc'] == "1"){$tCshStaDoc = language('document/card/cardout','tCardShiftOutTBComplete');}
                            if(@$aValue['rtCardShiftOutCshStaDoc'] == "2"){$tCshStaDoc = language('document/card/cardout','tCardShiftOutTBIncomplete');}
                            if(@$aValue['rtCardShiftOutCshStaDoc'] == "3"){$tCshStaDoc = language('document/card/cardout','tCardShiftOutTBCancel');}
                            ?>
                            <td nowrap class="text-left"><label class="xCNTDTextStatus <?= $tClassStaDoc ?>"><?php echo $tCshStaDoc; ?><label></td>
                            <?php 
                            $tCshStaPrcDoc = "";
                            if ($aValue['rtCardShiftOutCshStaPrcDoc'] == 1) {
                                $tClassStaApv = 'text-success';
                            } else if ($aValue['rtCardShiftOutCshStaPrcDoc'] == 2) {
                                $tClassStaApv = 'text-warning';
                            } else if ($aValue['rtCardShiftOutCshStaPrcDoc'] == '') {
                                $tClassStaApv = 'text-danger';
                            }
                            if(empty($aValue['rtCardShiftOutCshStaPrcDoc'])){$tCshStaPrcDoc = language('document/card/cardout','tCardShiftOutTBPending');}
                            if(empty($aValue['rtCardShiftOutCshStaPrcDoc']) && @$aValue['rtCardShiftOutCshStaDoc'] == "3"){$tCshStaPrcDoc = "N/A";}
                            if(@$aValue['rtCardShiftOutCshStaPrcDoc'] == "2"){$tCshStaPrcDoc = language('document/card/cardout','tCardShiftOutTBProcessing');}
                            if(@$aValue['rtCardShiftOutCshStaPrcDoc'] == "1"){$tCshStaPrcDoc = language('document/card/cardout','tCardShiftOutTBApproved');}
                            ?>
                            <td nowrap class="text-left"><label class="xCNTDTextStatus <?= $tClassStaApv ?>"><?php echo $tCshStaPrcDoc; ?></label></td>
                            <?php if ($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaDelete'] == 1) { ?>
                                <td>
                                    <img class="xCNIconTable xCNIconDel <?= $ClassDisabled ?>" src="<?= base_url('application/modules/common/assets/images/icons/delete.png') ?>" title="<?= $Title ?>" <?= $Onclick ?>>
                                </td>
                            <?php } ?>

                            <?php if ($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaEdit'] == 1 || $aAlwEvent['tAutStaRead'] == 1) { ?>
                                <td>
                                    <?php if($bIsApvOrCancel) { ?>
                                        <img class="xCNIconTable" style="width: 17px;" src="<?= base_url('application/modules/common/assets/images/icons/view2.png'); ?>" onClick="JSvCardShiftOutCallPageCardShiftOutEdit('<?= $aValue['rtCardShiftOutDocNo'] ?>')">
                                    <?php }else{ ?>
                                        <img class="xCNIconTable" src="<?= base_url('application/modules/common/assets/images/icons/edit.png') ?>" onClick="JSvCardShiftOutCallPageCardShiftOutEdit('<?= $aValue['rtCardShiftOutDocNo'] ?>')">
                                    <?php } ?>
                                </td>
                            <?php } ?>
                        </tr>
                    <?php endforeach; ?>
                <?php else:?>
                    <tr><td nowrap class='text-center xCNTextDetail2' colspan='100%'><?php echo language('common/main/main','tCMNNotFoundData'); ?></td></tr>
                <?php endif;?>
                </tbody>
			</table>
        </div>
    </div>
</div>

<div class="row">
    <!-- ????????????????????? -->
    <div class="col-md-6">
        <p><?php echo language('common/main/main','tResultTotalRecord'); ?> <?php echo $aDataList['rnAllRow']; ?> <?php echo language('common/main/main','tRecord'); ?> <?php echo language('common/main/main','tCurrentPage'); ?> <?php echo $aDataList['rnCurrentPage']; ?> / <?php echo $aDataList['rnAllPage']; ?></p>
    </div>
    <!-- ????????????????????? -->
    <div class="col-md-6">
        <div class="xWPageCardShiftOut btn-toolbar pull-right"> <!-- ????????????????????????????????? Class ?????????????????????????????????????????????????????? --> 
            <?php if($nPage == 1){ $tDisabledLeft = 'disabled'; }else{ $tDisabledLeft = '-';} ?>
            <button onclick="JSvCardShiftOutClickPage('previous')" class="btn btn-white btn-sm" <?php echo $tDisabledLeft ?>> <!-- ????????????????????????????????? Onclick ?????????????????????????????????????????????????????? --> 
                <i class="fa fa-chevron-left f-s-14 t-plus-1"></i>
            </button>
            <?php for($i=max($nPage-2, 1); $i<=max(0, min($aDataList['rnAllPage'],$nPage+2)); $i++){?> <!-- ????????????????????????????????? Parameter Loop ?????????????????????????????????????????????????????? --> 
                <?php 
                    if($nPage == $i){ 
                        $tActive = 'active'; 
                        $tDisPageNumber = 'disabled';
                    }else{ 
                        $tActive = '';
                        $tDisPageNumber = '';
                    }
                ?>
                <!-- ????????????????????????????????? Onclick ?????????????????????????????????????????????????????? --> 
                <button onclick="JSvCardShiftOutClickPage('<?php echo $i?>')" type="button" class="btn xCNBTNNumPagenation <?php echo $tActive ?>" <?php echo $tDisPageNumber ?>><?php echo $i?></button>
            <?php } ?>
            <?php if($nPage >= $aDataList['rnAllPage']){  $tDisabledRight = 'disabled'; }else{  $tDisabledRight = '-';  } ?>
            <button onclick="JSvCardShiftOutClickPage('next')" class="btn btn-white btn-sm" <?php echo $tDisabledRight ?>> <!-- ????????????????????????????????? Onclick ?????????????????????????????????????????????????????? --> 
                <i class="fa fa-chevron-right f-s-14 t-plus-1"></i>
            </button>
        </div>
    </div>
</div>

<div class="modal fade" id="odvModalDel">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <label class="xCNTextModalHeard"><?= language('common/main/main', 'tModalDelete') ?></label>
            </div>
            <div class="modal-body">
                <span id="ospConfirmDelete"> - </span>
                <input type='hidden' id="ohdConfirmIDDelete">
            </div>
            <div class="modal-footer">
                <button id="osmConfirm" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button">
                    <?= language('common/main/main', 'tModalConfirm') ?>
                </button>
                <button class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button" data-dismiss="modal">
                    <?= language('common/main/main', 'tModalCancel') ?>
                </button>
            </div>
        </div>
    </div>
</div>


<script>
    $(".ocbListItem").unbind().bind('click', function(){
        var bIsMore = $(".ocbListItem:checked").length > 0;
        if(bIsMore){
            $("#oliBtnDeleteAll").removeClass('disabled');
        }else{
            $("#oliBtnDeleteAll").addClass('disabled');
        }
    });
</script>