<div class="table-responsive">
    <table class="table table-striped xWPdtTableFont">
        <thead>
            <tr>
                <th width="10%" class="text-leff"><?php echo language('payment/card/card', 'tDate'); ?></th>
                <th width="10%" class="text-left"><?php echo language('payment/card/card', 'tType'); ?></th>
                <th width="10%" class="text-left"><?php echo language('payment/card/card', 'tShop'); ?></th>
                <th width="10%" class="text-left"><?php echo language('payment/card/card', 'tCashier'); ?></th>
                <th width="10%" class="text-right"><?php echo language('payment/card/card', 'tValue'); ?></th>
                <th width="10%" class="text-right"><?php echo language('payment/card/card', 'tPromotionAmount'); ?></th>
                <th width="10%" class="text-right"><?php echo language('payment/card/card', 'tBalance'); ?></th>
            </tr>
        </thead>
        <tbody>
            <?php if ($aDataList['rtCode'] == 1) { ?>
                <?php foreach (array_reverse($aDataList['raItems']) as $key => $aValue) { ?>
                    <?php
                        // 1:เติมเงิน, 2:ยกเลิกเติมเงิน, 3:ตัดจ่าย(ขาย), 4:ยกเลิกตัดจ่าย(คืน), 5:แลกคืน, 6:เบิกบัตร, 7:คืนบัตร, 8:โอนเงินออก, 9:โอนเงินเข้า ,10:ล้างบัตร,11:ปรับสถานะ,12:บัตรใหม่
                        $aPayType = ["2","3","5","8","10"];
                        if(in_array($aValue['FTTxnDocType'],$aPayType)){
                            $cTxnValue = '-'.number_format($aValue['FCTxnValue'],$nOptDecimalShow);
                            $cBalance = number_format((floatval($aValue['FCTxnPmt']) + floatval($aValue['FCTxnCrdValue'])) - floatval($aValue['FCTxnValue']),$nOptDecimalShow);
                        }else{
                            $cTxnValue = number_format($aValue['FCTxnValue'],$nOptDecimalShow);
                            $cBalance = number_format((floatval($aValue['FCTxnPmt']) + floatval($aValue['FCTxnCrdValue'])) + floatval($aValue['FCTxnValue']),$nOptDecimalShow);
                        }
                    ?>
                    <tr class="xCNTextDetail2" data-pay-type="<?php echo $aValue['FTTxnDocType']; ?>">
                        <td class="text-left"><?php echo date('Y-m-d H:i:s', strtotime($aValue['FDTxnDocDate'])); ?></td>
                        <td class="text-left"><?php echo $aValue['FTTxnName']; ?></td>
                        <td class="text-left"><?php echo $aValue['FTShpName']; ?></td>
                        <td class="text-left"><?php echo $aValue['FTTxnPosCode']; ?></td>
                        <td class="text-right"><?php echo $cTxnValue; ?></td>
                        <td class="text-right"><?php echo number_format($aValue['FCTxnPmt'],$nOptDecimalShow); ?></td>
                        <td class="text-right"><?php echo $cBalance; ?></td>
                    </tr>       
                <?php } ?>
            <?php } else { ?>
                <tr>
                    <td class='text-center xCNTextDetail2' colspan='100%'><?= language('common/main/main', 'tCMNNotFoundData') ?></td>
                </tr>
            <?php }; ?>
        </tbody>
    </table>
</div>