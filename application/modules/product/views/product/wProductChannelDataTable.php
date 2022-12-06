<style>
    .xWEditInlineElement {
        text-align: right !important;
    }
</style>

<?php
if (isset($aDataUnitPackSize)) {
    $tPdtPriceRet   =   "";
    $tPdtPriceWhs   =   "";
    $tPdtPriceNet   =   "";
} else {
    $tPdtPriceRet   =   0;
    $tPdtPriceWhs   =   0;
    $tPdtPriceNet   =   0;
}
?>
<?php
$tPunCode = "";
$tPunName = "";
if (isset($aDataUnitPackSize['raItems'])) {
    foreach ($aDataUnitPackSize['raItems'] as $nKey => $aValue) {
        if ($tPunCode == "") {
            $tPunCode = $aValue['FTChnCode'];
            $tPunName = $aValue['FTChnName'];
        } else {
            $tPunCode = $tPunCode . "," . $aValue['FTChnCode'];
            $tPunName = $tPunName . "," . $aValue['FTChnName'];
        }
    }
}
?>
<input type="hidden" id="ohdPdtChannelCode" class="form-control" value="<?php echo $tPunCode; ?>">
<input type="hidden" id="ohdPdtChannelName" class="form-control" value="<?php echo $tPunName; ?>">

<?php
//Decimal Show ลง 2 ตำแหน่ง
$nDecShow =  FCNxHGetOptionDecimalShow();
if($nPdtForSystem=='5'){
    $tHideClass4PdtFahsion = 'xCNHide';
}else{
    $tHideClass4PdtFahsion = ''; 
}
?>
<table class="table xWTablePackSize" id="otbTablePackSize">
    <thead>
        <tr>
            <th nowrap class="text-center xCNTextBold" style="width:5%;"><?php echo language('product/product/product', 'ลำดับ') ?></th>
            <th nowrap class="text-center xCNTextBold" style="width:25%;"><?php echo language('product/product/product', 'รหัสช่องทางการขาย') ?></th>
            <th nowrap class="text-center xCNTextBold xWPDTViewPackBarcode <?=$tHideClass4PdtFahsion?>" style="width:60%;"><?php echo language('product/product/product', 'ชื่อช่องทางการขาย') ?></th>
            <?php if ($aAlwEventPdt['tAutStaFull'] == 1 || $aAlwEventPdt['tAutStaDelete'] == 1) : ?>
                <th nowrap class="text-center xCNTextBold" style="width:10%;"><?php echo language('product/product/product', 'tPDTViewPackDelUnit') ?></th>
            <?php endif; ?>
        </tr>
    </thead>
    <tbody>
        <?php
        if (isset($aDataUnitPackSize['raItems'])) {
            foreach ($aDataUnitPackSize['raItems'] as $nKey => $aValue) {
        ?>
                <tr>
                    <td nowrap class="text-center">
                        <label><?php echo number_format($nKey + 1); ?></label>
                    </td>

                    <td nowrap class="text-left">
                        <label><?php echo $aValue['FTChnCode']; ?></label>
                    </td>

                    <td nowrap class="text-left">
                        <label><?php echo $aValue['FTChnName']; ?></label>
                    </td>

                    <?php if ($aAlwEventPdt['tAutStaFull'] == 1 || $aAlwEventPdt['tAutStaDelete'] == 1) : ?>
                        <td nowrap class="text-center">
                            <img onclick="JSxPdtDelChannelInTable(1,'<?= $aValue['FTChnCode']; ?>')" class="xCNIconTable" src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/delete.png' ?>">
                        </td>
                    <?php endif; ?>
                </tr>
            <?php
            }
        } else {
            ?>
            <tr>
                <td nowrap colspan="4" class="text-center xWTextNotfoundDataTablePdt"><?php echo language('product/product/product', 'ไม่เจอข้อมูล') ?></td>
            </tr>
        <?php
        }
        ?>
    </tbody>
</table>
