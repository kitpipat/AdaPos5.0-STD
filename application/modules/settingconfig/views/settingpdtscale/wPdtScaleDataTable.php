<div class="row">
    <div class="col-md-12">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <!-- <th class="xCNTextBold text-center" style="width:10%;"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSTBChoose') ?></th> -->
                        <th class="text-center" id="othCheckboxHide" width="3%">
                            <label class="fancy-checkbox">
                                <input id="ocbCheckAll" type="checkbox" class="ocmCENCheckDeleteAll" name="ocbCheckAll" style="margin-right: 0px !important">
                                <span class="">&nbsp;</span>
                            </label>
                        </th>
                        <th class="xCNTextBold text-left" style="width:20%;"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSTBCode') ?></th>
                        <th class="xCNTextBold text-left" style="width:20%;"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSTBName') ?></th>
                        <th class="xCNTextBold text-left" style="width:30%;"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSTBStaCheckDigit') ?></th>
                        <th class="xCNTextBold text-left" style="width:10%;"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSTBStatus') ?></th>
                        <th class="xCNTextBold text-center" style="width:10%;"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSTBDelete') ?></th>
                        <th class="xCNTextBold text-center" style="width:10%;"><?php echo language('product/settingpdtscale/settingpdtscale', 'tPDSTBEdit') ?></th>
                    </tr>
                </thead>
                <tbody id="odvPDSList">
                    <?php if ($aDataList['rtCode'] == 1) : ?>
                        <?php foreach ($aDataList['raItems'] as $key => $aValue) { ?>
                            <tr class="text-center xCNTextDetail2 otrPDS" id="otrPDS<?= $key ?>" data-code="<?= $aValue['FTPdsCode'] ?>" data-name="<?= $aValue['FTPdsCode'] ?>" >
                                <td class="text-center">
                                    <label class="fancy-checkbox">
                                        <input id="ocbListItem<?= $key ?>" type="checkbox" class="ocbListItem" name="ocbListItem[]" onchange="JSxPDSVisibledDelAllBtn(this, event)">
                                        <span>&nbsp;</span>
                                    </label>
                                </td>
                                <td class="text-left otdPDSCode otdPDSName" data-agncode="<?= $aValue['FTAgnCode'] ?>"><?= $aValue['FTPdsCode'] ?></td>
                                <td class="text-left "><?= $aValue['FNPdsLenBar'] ?></td>
                                <?php
                                $tPdsStaChkDigit = '';
                                if ($aValue['FTPdsStaChkDigit'] == 1) {
                                    $tPdsStaChkDigit = language('product/settingpdtscale/settingpdtscale', 'tPDSTBStaChkDigit1');
                                } else {
                                    $tPdsStaChkDigit = language('product/settingpdtscale/settingpdtscale', 'tPDSTBStaChkDigit2');
                                }
                                ?>
                                <td class="text-left"><?php echo $tPdsStaChkDigit;  ?></td>
                           
                                <?php
                                $tPDSStaUse = '';
                                if ($aValue['FTPdsStaUse'] == 1) {
                                    $tPDSStaUse = language('product/settingpdtscale/settingpdtscale', 'tPDSTBActive1');
                                } else {
                                    $tPDSStaUse = language('product/settingpdtscale/settingpdtscale', 'tPDSTBActive2');
                                }
                                ?>
                                <td class="text-left"><?php echo $tPDSStaUse;  ?></td>
                                <td>
                                    <img class="xCNIconTable" src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/delete.png' ?>" onClick="JSaPDSDelete(this, event)" title="<?php echo language('customer/customerGroup/customerGroup', 'tCstGrpTBDelete'); ?>">
                                </td>
                                <td>
                                    <img class="xCNIconTable" src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/edit.png' ?>" onClick="JSvPDSCallPageEdit('<?= $aValue['FTPdsCode'] ?>','<?= $aValue['FTAgnCode'] ?>')" title="<?php echo language('customer/customerGroup/customerGroup', 'tCstGrpTBEdit'); ?>">
                                </td>
                            </tr>
                        <?php } ?>
                    <?php else : ?>
                        <tr>
                            <td class='text-center xCNTextDetail2' colspan='7'><?php echo language('product/settingpdtscale/settingpdtscale', 'tLPRTNotFoundData') ?></td>
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
        <p><?= language('common/main/main', 'tResultTotalRecord') ?> <?= $aDataList['rnAllRow'] ?> <?= language('common/main/main', 'tRecord') ?> <?= language('common/main/main', 'tCurrentPage') ?> <?= $aDataList['rnCurrentPage'] ?> / <?= $aDataList['rnAllPage'] ?></p>
    </div>
    <!-- เปลี่ยน -->
    <div class="col-md-6">
        <div class="xWPagePDS btn-toolbar pull-right">
            <!-- เปลี่ยนชื่อ Class เป็นของเรื่องนั้นๆ -->
            <?php if ($nPage == 1) {
                $tDisabledLeft = 'disabled';
            } else {
                $tDisabledLeft = '-';
            } ?>
            <button onclick="JSvPDSClickPage('previous')" class="btn btn-white btn-sm" <?php echo $tDisabledLeft ?>>
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
                <button onclick="JSvPDSClickPage('<?php echo $i ?>')" type="button" class="btn xCNBTNNumPagenation <?php echo $tActive ?>" <?php echo $tDisPageNumber ?>><?php echo $i ?></button>
            <?php } ?>
            <?php if ($nPage >= $aDataList['rnAllPage']) {
                $tDisabledRight = 'disabled';
            } else {
                $tDisabledRight = '-';
            } ?>
            <button onclick="JSvPDSClickPage('next')" class="btn btn-white btn-sm" <?php echo $tDisabledRight ?>>
                <!-- เปลี่ยนชื่อ Onclick เป็นของเรื่องนั้นๆ -->
                <i class="fa fa-chevron-right f-s-14 t-plus-1"></i>
            </button>
        </div>
    </div>
</div>
<script type="text/javascript">
    $('ducument').ready(function() {});
</script>