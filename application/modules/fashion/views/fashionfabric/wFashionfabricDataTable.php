<?php
if ($aDataList['rtCode'] == '1') {
    $nCurrentPage = $aDataList['rnCurrentPage'];
} else {
    $nCurrentPage = '1';
}
?>

<div class="row">
    <div class="col-md-12">
        <input type="hidden" id="nCurrentPageTB" value="<?= $nCurrentPage; ?>">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th class="xCNTextBold text-center" style="width:10%;"><?php echo language('common/main/main', 'tCMNChoose'); ?></th>
                        <th class="xCNTextBold text-center"><?php echo language('fashion/fashionfabric/fashionfabric', 'tFashionFabricCode'); ?></th>
                        <th class="xCNTextBold text-center"><?php echo language('fashion/fashionfabric/fashionfabric', 'tFashionFabricName'); ?></th>
                        <!-- <th class="xCNTextBold text-center"><?php echo language('fashion/fashionfabric/fashionfabric', 'tFashionFabricAgency'); ?></th> -->
                        <th class="xCNTextBold text-center" style="width:10%;"><?php echo language('common/main/main', 'tCMNActionDelete'); ?></th>
                        <th class="xCNTextBold text-center" style="width:10%;"><?php echo language('common/main/main', 'tEdit'); ?></th>
                    </tr>
                </thead>
                <tbody id="odvRGPList">
                    <?php if ($aDataList['rtCode'] == 1) : ?>
                        <?php foreach ($aDataList['raItems'] as $key => $aValue) { ?>

                            <?php

                            $tOnClickDel    = " onClick=\"JSaFashionFabricDelete('" . $nCurrentPage . "','" . $aValue['rtFabCode'] . "','" . $aValue['rtFabName'] . "')\" ";
                            $tFabricDel      = "";
                            $tDisabledDel   = "";

                            ?>
                            <tr class="text-center xCNTextDetail2 xWChnItems" data-key="<?php echo $key; ?>" data-fabcode="<?php echo $aValue['rtFabCode']; ?>" ">
                                <td class=" text-center">
                                <label class="fancy-checkbox">
                                    <input id="ocbListItem<?= $key ?>" type="checkbox" class="ocbListItem" name="ocbListItem[]" <?= $tDisabledDel ?>>
                                    <span class="<?= $tFabricDel ?>">&nbsp;</span>
                                </label>
                                </td>
                                <td class="text-left otdChnCode"><?php echo $aValue['rtFabCode']; ?></td>
                                <td class="text-left"><?php echo $aValue['rtFabName']; ?></td>
                                <!-- <td class="text-left"><?php echo $aValue['rtAgnName']; ?></td> -->
                                <td>
                                    <img class="xCNIconTable <?= $tFabricDel ?>" src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/delete.png' ?>" <?= $tOnClickDel ?> title="<?php echo language('common/main/main', 'tCMNActionDelete'); ?>">
                                </td>
                                <td>
                                    <img class="xCNIconTable" src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/edit.png' ?>" onClick="JSvCallPageFashionFabricEdit('<?php echo $aValue['rtFabCode']; ?>')" title="<?php echo language('common/main/main', 'tEdit'); ?>">
                                </td>
                            </tr>
                        <?php } ?>
                    <?php else : ?>
                        <tr>
                            <td class='text-center xCNTextDetail2' colspan='6'><?php echo language('common/main/main', 'tCMNNotFoundData'); ?></td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="row">
    <!-- เปลี่ยน -->
    <div class="col-md-6">
        <p><?php echo language('common/main/main', 'tResultTotalRecord') ?> <?= $aDataList['rnAllRow'] ?> <?php echo language('common/main/main', 'tRecord') ?> <?php echo $aDataList['rnCurrentPage']; ?> / <?php echo $aDataList['rnAllPage']; ?></p>
    </div>
    <!-- เปลี่ยน -->
    <div class="col-md-6">
        <div class="xWPageGrp btn-toolbar pull-right">
            <!-- เปลี่ยนชื่อ Class เป็นของเรื่องนั้นๆ -->
            <?php if ($nPage == 1) {
                $tDisabledLeft = 'disabled';
            } else {
                $tDisabledLeft = '-';
            } ?>
            <button onclick="JSvFashionFabricClickPage('previous')" class="btn btn-white btn-sm" <?php echo $tDisabledLeft ?>>
                <!-- เปลี่ยนชื่อ Onclick เป็นของเรื่องนั้นๆ -->
                <i class="fa fa-chevron-left f-s-14 t-plus-1"></i>
            </button>
            <?php for ($i = max($nPage - 2, 1); $i <= max(0, min($aDataList['rnAllPage'], $nPage + 2)); $i++) { ?>
                <!-- เปลี่ยนชื่อ Parameter Loop เป็นของเรื่องนั้นๆ -->
                <?php
                if ($nPage == $i) {
                    $tActive = 'active';
                    $tDisPageNumber = 'disabled';
                } else {
                    $tActive = '';
                    $tDisPageNumber = '';
                }
                ?>
                <!-- เปลี่ยนชื่อ Onclick เป็นของเรื่องนั้นๆ -->
                <button onclick="JSvFashionFabricClickPage('<?php echo $i ?>')" type="button" class="btn xCNBTNNumPagenation <?php echo $tActive ?>" <?php echo $tDisPageNumber ?>><?php echo $i ?></button>
            <?php } ?>
            <?php if ($nPage >= $aDataList['rnAllPage']) {
                $tDisabledRight = 'disabled';
            } else {
                $tDisabledRight = '-';
            } ?>
            <button onclick="JSvFashionFabricClickPage('next')" class="btn btn-white btn-sm" <?php echo $tDisabledRight ?>>
                <!-- เปลี่ยนชื่อ Onclick เป็นของเรื่องนั้นๆ -->
                <i class="fa fa-chevron-right f-s-14 t-plus-1"></i>
            </button>
        </div>
    </div>
</div>

<div class="modal fade" id="odvModalDelFashionFabric">
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
                <button id="osmConfirm" type="button" class="btn xCNBTNPrimery" onClick="JSnChanelDelChoose('<?= $nCurrentPage ?>')"><?= language('common/main/main', 'tModalConfirm') ?></button>
                <button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?= language('common/main/main', 'tModalCancel') ?></button>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="odvModalDeleteMutirecord">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <label class="xCNTextModalHeard"><?= language('common/main/main', 'tModalDelete') ?></label>
            </div>
            <div class="modal-body">
                <span id="ospConfirmDelete"></span> <?= language('common/main/main', 'tModalDeleteMulti') ?>


            </div>
            <div class="modal-footer">
                <button id="osmConfirm" type="button" class="btn xCNBTNPrimery" onClick="JSxChnDeleteMutirecord('<?= $nCurrentPage ?>')"><?= language('common/main/main', 'tModalConfirm') ?></button>
                <button type="button" class="btn xCNBTNDefult" data-dismiss="modal"><?= language('common/main/main', 'tModalCancel') ?></button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(function() {
        $('.ocbListItem').click(function() {
            // var nCode = $(this).parents('.xWRcvSpcItems').data('appcode'); //code
            // var tName = $(this).parents('.xWRcvSpcItems').data('appname'); //code
            var nKey = $(this).parents('.xWChnItems').data('key'); //code
            $(this).prop('checked', true);
            var LocalItemData = localStorage.getItem("LocalItemData");
            var obj = [];
            if (LocalItemData) {
                obj = JSON.parse(LocalItemData);
            } else {}
            var aArrayConvert = [JSON.parse(localStorage.getItem("LocalItemData"))];
            if (aArrayConvert == '' || aArrayConvert == null) {
                obj.push({
                    // "nCode": nCode,
                    // "tName": tName
                    "nKey": nKey
                });
                localStorage.setItem("LocalItemData", JSON.stringify(obj));
                JSxPaseCodeDelInModal();

            } else {
                var aReturnRepeat = findObjectByKey(aArrayConvert[0], 'nKey', nKey);
                if (aReturnRepeat == 'None') { //ยังไม่ถูกเลือก
                    obj.push({
                        // "nCode": nCode,
                        // "tName": tName
                        "nKey": nKey
                    });
                    localStorage.setItem("LocalItemData", JSON.stringify(obj));
                    JSxPaseCodeDelInModal();

                } else if (aReturnRepeat == 'Dupilcate') { //เคยเลือกไว้แล้ว
                    localStorage.removeItem("LocalItemData");
                    $(this).prop('checked', false);
                    var nLength = aArrayConvert[0].length;
                    for ($i = 0; $i < nLength; $i++) {
                        if (aArrayConvert[0][$i].nKey == nKey) {
                            delete aArrayConvert[0][$i];
                        }
                    }
                    var aNewarraydata = [];
                    for ($i = 0; $i < nLength; $i++) {
                        if (aArrayConvert[0][$i] != undefined) {
                            aNewarraydata.push(aArrayConvert[0][$i]);
                        }
                    }
                    localStorage.setItem("LocalItemData", JSON.stringify(aNewarraydata));
                    JSxPaseCodeDelInModal();
                }
            }
            JSxShowButtonChoose();
        });
    });
</script>