<?php
$aCompanyInfo       = $aDataViewRpt['aCompanyInfo'];
$aDataFilter        = $aDataViewRpt['aDataFilter'];
$aDataTextRef       = $aDataViewRpt['aDataTextRef'];
$aDataReport        = $aDataViewRpt['aDataReport'];
$nOptDecimalShow    = $aDataViewRpt['nOptDecimalShow'];

// echo '<pre>';
// print_r($aDataFilter);
// echo '</pre>';
?>
<style>
    .xCNFooterRpt {
        border-bottom: 7px double #ddd;
    }

    .table thead th,
    .table>thead>tr>th,
    .table tbody tr,
    .table>tbody>tr>td {
        border: 0px transparent !important;
    }

    .table>thead:first-child>tr:first-child>td,
    .table>thead:first-child>tr:first-child>th {
        border-top: 1px solid black !important;
        border-bottom: dashed 1px #333 !important;
    }


    .xWRptMovePosVDData>td:first-child {
        text-indent: 40px;
    }

    /*แนวนอน*/
    @media print {
        @page {
            size: A4 landscape;
            margin: 5mm 5mm 5mm 5mm;
        }
    }
</style>
<div id="odvRptMovePosVDHtml">
    <div class="container-fluid xCNLayOutRptHtml">
        <div class="xCNHeaderReport">

            <div class="row">
                <?php include 'application\modules\report\datasources\Address\wRptAddress.php'; ?>
                <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4">

                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <div class="text-center">
                                <label class="xCNRptTitle"><?php echo @$aDataTextRef['tTitleReport']; ?></label>
                            </div>
                        </div>
                    </div>
                    <?php if((isset($aDataFilter['tDocDateFrom']) && !empty($aDataFilter['tDocDateFrom'])) && (isset($aDataFilter['tDocDateTo']) && !empty($aDataFilter['tDocDateTo']))): ?>
                        <!-- ============================ ฟิวเตอร์ข้อมูล วันที่สร้างเอกสาร ============================ -->
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="text-center xCNRptFilter">
                                    <label class="xCNRptLabel"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptDateFrom'].' : </span>'.date('d/m/Y',strtotime($aDataFilter['tDocDateFrom']));?></label>
                                    <label class="xCNRptLabel"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptDateTo'].' : </span>'.date('d/m/Y',strtotime($aDataFilter['tDocDateTo']));?></label>
                                </div>
                            </div>
                        </div>
                    <?php endif;?>
                    <?php if ((isset($aDataFilter['tBchCodeFrom']) && !empty($aDataFilter['tBchCodeFrom'])) && (isset($aDataFilter['tBchCodeTo']) && !empty($aDataFilter['tBchCodeTo']))) { ?>
                        <!-- ============================ ฟิวเตอร์ข้อมูล สาขา ============================ -->
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="text-center">
                                    <label class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptBchFrom'] ?> : </label> <label><?= $aDataFilter['tBchNameFrom']; ?></label>&nbsp;
                                    <label class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptBchTo'] ?> : </label> <label><?= $aDataFilter['tBchNameTo']; ?></label>
                                </div>
                            </div>
                        </div>
                    <?php } ?>

                </div>
                <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4"></div>
            </div>
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 table-responsive">
                    <div class="text-right">
                        <label class="xCNRptDataPrint"><?php echo $aDataTextRef['tDatePrint'] . ' ' . date('d/m/Y') . ' ' . $aDataTextRef['tTimePrint'] . ' ' . date('H:i:s'); ?></label>
                    </div>
                </div>
            </div>
        </div>
        <div class="xCNContentReport">
            <div id="odvRptTableAdvance" class="table-responsive">
                <table class="table">
                    <thead>
                        <tr style="border-bottom: 1px solid black !important">
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRptPKUCopCode'); ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRptPKUCopname'); ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRptPKUPos'); ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRptBillNo'); ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRptPKUTypeName'); ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRPCOperator'); ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRPC1TBCardTxnDocDate'); ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRptPKUValues'); ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRptPKUTotalVal'); ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRptPKUActive'); ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo language('report/report/report', 'tRptPKURemaining'); ?></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php 
                            $newArray = array();
                            if (isset($aDataReport['aRptData']) && !empty($aDataReport['aRptData'])) : ?>
                            <?php
                            //    echo '<pre>';
                            //    print_r($aDataReport['aRptData']);
                            //    echo '</pre>';
                            //    die();
                            $tCpnCode = '';
                            // Set ตัวแปร SumSubFooter และ ตัวแปร SumFooter
                            $tRptGtpBchCode = "";
                            $tRptGtpWahCode = "";
                            $nCountBchCode  = 0;
                            $nCountWahCode  = 0;
                            ?>
                            <?php foreach ($aDataReport['aRptData'] as $nKey => $aValue) : 
                                $aCpnAmt = $aValue["FCXshCpnAmt"];
                                if($aValue['FTCpnNo'] == $tCpnCode){
                                    $tStyleCpn = '';
                                    $tCpnAmt = number_format($aCpnAmt, $nOptDecimalShow);
                                    $tCpnAmtTotal = '';
                                    $tCpnQtyUse = '';
                                    $tCpnQtyUse = '';
                                    $tCpnQtyLeft = '';
                                }else{
                                    $tStyleCpn = 'border-top: dashed 1px #333 !important;';
                                    $tCpnAmt = number_format($aCpnAmt, $nOptDecimalShow);
                                    $tCpnAmtTotal = number_format($aValue["FCCpnAmtTatalGroupByCpn"], $nOptDecimalShow);
                                    $tCpnQtyUse = number_format($aValue["FCCpnQtyUseGroupByCpn"], $nOptDecimalShow);
                                    $tCpnQtyLeft = number_format($aValue['FCCpnQtyLeftGroupByCpn'], $nOptDecimalShow);
                                }
                            ?>
                               
                                <tr class="" style="<?=$tStyleCpn?>">
                                    <td class="xCNRptDetail" ><?php echo $aValue['FTCpnNo']; ?></td>
                                    <td class="text-left xCNRptDetail"><?php echo $aValue['FTCpnName']; ?></td>
                                    <td class="text-left xCNRptDetail"><?php echo $aValue['FTPosName']; ?></td>
                                    <td class="text-left xCNRptDetail"><?php echo $aValue['FTXshDocNo']; ?></td>
                                    <td class="text-left xCNRptDetail"><?php echo $aValue['FTXshDocType']; ?></td>
                                    <td class="text-left xCNRptDetail"><?php echo $aValue['FTUsrName']; ?></td>
                                    <td class="text-left xCNRptDetail"><?php echo date("Y-m-d H:i:s", strtotime($aValue["FDXshDocDate"])); ?></td>
                                    <td class="text-right xCNRptDetail"><?php echo $tCpnAmt;?></td>
                                    <td class="text-right xCNRptDetail"><?php echo $tCpnAmtTotal; ?></td>
                                    <td class="text-right xCNRptDetail"><?php echo  $tCpnQtyUse; ?></td>
                                    <td class="text-right xCNRptDetail"><?php echo  $tCpnQtyLeft; ?> </td>
                                </tr>
                                <?php
                                // $nSubSumQty = number_format($aValue["FCStkQty_SubTotal"], $nOptDecimalShow);
                                // $aSumFooter = array($aDataTextRef['tRptTotal'], 'N', $nSubSumQty);

                                // $nVal = $nVal + $aValue["FCPdtCostTotal_Footer"];
                                // $tFCPdtCostTotal    = number_format($nVal, $nOptDecimalShow);
                                $nFCStkQtyMonEnd_Footer   = number_format($aValue["FCCpnAmtAmt_Footer"], $nOptDecimalShow);
                                $nFCStkQtyIn_Footer   = number_format($aValue["FCCpnAmtTatal_Footer"], $nOptDecimalShow);
                                $nFCStkQtyOut_Footer   = number_format($aValue["FCCpnQtyUse_Footer"], $nOptDecimalShow);
                                $nFCStkQtySale_Footer   = number_format($aValue["FCCpnQtyLeft_Footer"], $nOptDecimalShow);
                                $paFooterSumData    = array($aDataTextRef['tRptTotalFooter'],'N','N','N','N','N','N', $nFCStkQtyMonEnd_Footer, $nFCStkQtyIn_Footer, $nFCStkQtyOut_Footer, $nFCStkQtySale_Footer);
                                ?>
                            <?php $tCpnCode = $aValue['FTCpnNo']; endforeach; ?>

                            <?php
                            $nPageNo    = $aDataReport["aPagination"]["nDisplayPage"];
                            $nTotalPage = $aDataReport["aPagination"]["nTotalPage"];

                            if ($nPageNo == $nTotalPage) {
                                echo "<tr class='xCNTrFooter'>";
                                for ($i = 0; $i < count($paFooterSumData); $i++) {
                                    if ($i == 0) {
                                        $tStyle = 'text-align:left;border-top:1px solid #333;border-bottom:1px solid #333;/*background-color: #CFE2F3;*/';
                                    } else {
                                        $tStyle = 'text-align:right;border-top:1px solid #333;border-bottom:1px solid #333;/*background-color: #CFE2F3;*/';
                                    }
                                    if ($paFooterSumData[$i] != 'N') {
                                        $tFooterVal = $paFooterSumData[$i];
                                    } else {
                                        $tFooterVal = '';
                                    }
                                    if ($i == 0) {
                                        echo "<td class='xCNRptSumFooter text-left'>" . $tFooterVal . "</td>";
                                    } else {
                                        echo "<td class='xCNRptSumFooter text-right'>" . $tFooterVal . "</td>";
                                    }
                                }
                                echo "<tr>";
                            }
                            ?>
                        <?php else : ?>
                            <tr>
                                <td class='text-center xCNTextDetail2' colspan='100%'><?php echo $aDataTextRef['tRptAdjStkNoData']; ?></td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>

            <?php if ((isset($aDataFilter['tPdtCodeFrom']) && !empty($aDataFilter['tPdtCodeFrom'])) && (isset($aDataFilter['tPdtCodeTo']) && !empty($aDataFilter['tPdtCodeTo']))
                || (isset($aDataFilter['tWahCodeFrom']) && !empty($aDataFilter['tWahCodeFrom'])) && (isset($aDataFilter['tWahCodeTo']) && !empty($aDataFilter['tWahCodeTo']))
                || (isset($aDataFilter['tMerCodeFrom']) && !empty($aDataFilter['tMerCodeFrom'])) && (isset($aDataFilter['tMerCodeTo']) && !empty($aDataFilter['tMerCodeTo']))
                || (isset($aDataFilter['tShpCodeFrom']) && !empty($aDataFilter['tShpCodeFrom'])) && (isset($aDataFilter['tShpCodeTo']) && !empty($aDataFilter['tShpCodeTo']))
                || (isset($aDataFilter['tPosCodeFrom']) && !empty($aDataFilter['tPosCodeFrom'])) && (isset($aDataFilter['tPosCodeTo']) && !empty($aDataFilter['tPosCodeTo']))
                || (isset($aDataFilter['tBchCodeSelect']))
                || (isset($aDataFilter['tMerCodeSelect']))
                || (isset($aDataFilter['tShpCodeSelect']))
                || (isset($aDataFilter['tPosCodeSelect']))
                || (isset($aDataFilter['tWahCodeSelect']))
            ) { ?>
                <div class="xCNRptFilterTitle">
                    <div class="text-left">
                        <label class="xCNTextConsOth"><?= $aDataTextRef['tRptConditionInReport']; ?></label>
                    </div>
                </div>
            <?php }; ?>

             <!-- ============================ ฟิวเตอร์ข้อมูล ตัวแทนขาย ============================ -->
             <?php if (isset($aDataFilter['tAgnCode']) && !empty($aDataFilter['tAgnCode'])) : ?>
                <div class="xCNRptFilterBox">
                    <div class="xCNRptFilter">
                        <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptGrpAgency']; ?> : </span> <?php echo (!$aDataFilter['tAgnCode']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tAgnName']; ?></label>
                    </div>
                </div>
            <?php endif; ?>

            <!-- ============================ ฟิวเตอร์ข้อมูล สาขา ============================ -->
            <?php if (isset($aDataFilter['tBchCodeSelect']) && !empty($aDataFilter['tBchCodeSelect'])) : ?>
                <div class="xCNRptFilterBox">
                    <div class="xCNRptFilter">
                        <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptBchFrom']; ?> : </span> <?php echo ($aDataFilter['bBchStaSelectAll']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tBchNameSelect']; ?></label>
                    </div>
                </div>
            <?php endif; ?>

            <!-- ============================ ฟิวเตอร์ข้อมูล จุดขาย ============================ -->
            <?php if ((isset($aDataFilter['tPosCodeFrom']) && !empty($aDataFilter['tPosCodeFrom'])) && (isset($aDataFilter['tPosCodeTo']) && !empty($aDataFilter['tPosCodeTo']))) : ?>
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjPosFrom'] . ' : </span>' . $aDataFilter['tPosCodeFrom']; ?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjPosTo'] . ' : </span>' . $aDataFilter['tPosCodeTo']; ?></label>
                    </div>
                </div>
            <?php endif; ?>
            <?php if (isset($aDataFilter['tPosCodeSelect']) && !empty($aDataFilter['tPosCodeSelect'])) : ?>
                <div class="xCNRptFilterBox">
                    <div class="xCNRptFilter">
                        <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptPosFrom']; ?> : </span> <?php echo ($aDataFilter['bPosStaSelectAll']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tPosCodeSelect']; ?></label>
                    </div>
                </div>
            <?php endif; ?>

            <!-- ============================ ฟิวเตอร์ข้อมูล คลังสินค้า ============================ -->
            <?php if ((isset($aDataFilter['tWahCodeFrom']) && !empty($aDataFilter['tWahCodeFrom'])) && (isset($aDataFilter['tWahCodeTo']) && !empty($aDataFilter['tWahCodeTo']))) : ?>
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjWahFrom'] . ' : </span>' . $aDataFilter['tWahNameFrom']; ?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjWahTo'] . ' : </span>' . $aDataFilter['tWahNameTo']; ?></label>
                    </div>
                </div>
            <?php endif; ?>
            <?php if (isset($aDataFilter['tWahCodeSelect']) && !empty($aDataFilter['tWahCodeSelect'])) : ?>
                <div class="xCNRptFilterBox">
                    <div class="xCNRptFilter">
                        <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjWahFrom']; ?> : </span> <?php echo ($aDataFilter['bWahStaSelectAll']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tWahNameSelect']; ?></label>
                    </div>
                </div>
            <?php endif; ?>

            <?php if ((isset($aDataFilter['tPdtCodeFrom']) && !empty($aDataFilter['tPdtCodeFrom'])) && (isset($aDataFilter['tPdtCodeTo']) && !empty($aDataFilter['tPdtCodeTo']))) : ?>
                <!-- ============================ ฟิวเตอร์ข้อมูล สินค้า ============================ -->
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tPdtCodeFrom'] . ' : </span>' . $aDataFilter['tPdtNameFrom']; ?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tPdtCodeTo'] . ' : </span>' . $aDataFilter['tPdtNameTo']; ?></label>
                    </div>
                </div>
            <?php endif; ?>
            <?php if (isset($aDataFilter['tPdtCodeSelect']) && !empty($aDataFilter['tPdtCodeSelect'])) : ?>
                <div class="xCNRptFilterBox">
                    <div class="xCNRptFilter">
                        <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tPdtCodeFrom']; ?> : </span> <?php echo ($aDataFilter['bPdtStaSelectAll']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tPdtNameSelect']; ?></label>
                    </div>
                </div>
            <?php endif; ?>

            <?php if (isset($aDataFilter['tPdtStaActive']) && !empty($aDataFilter['tPdtStaActive'])) { ?>
                <!-- ============================ ฟิวเตอร์ข้อมูล สถานะเคลื่อนไหว ============================ -->
                <div class="xCNRptFilterBox">
                    <div class="xCNRptFilter">
                        <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptTitlePdtMoving']; ?> : </span> <?php echo $aDataTextRef['tRptPdtMoving' . $aDataFilter['tPdtStaActive']] ?></label>
                    </div>
                </div>
            <?php } ?>

            <?php if ((isset($aDataFilter['tCouponCodeFrom']) && !empty($aDataFilter['tCouponCodeFrom'])) && (isset($aDataFilter['tCouponCodeTo']) && !empty($aDataFilter['tCouponCodeTo']))) : ?>
                <!-- ============================ ฟิวเตอร์ข้อมูล คูปอง ============================ -->
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptCouponFrom'] . ' : </span>' . $aDataFilter['tCouponNameFrom']; ?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptCouponTo'] . ' : </span>' . $aDataFilter['tCouponNameTo']; ?></label>
                    </div>
                </div>
            <?php endif; ?>


        </div>
        <div class="xCNFooterPageRpt">
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="text-right">
                        <?php if ($aDataReport["aPagination"]["nTotalPage"] > 0) : ?>
                            <label class="xCNRptLabel"><?php echo $aDataReport["aPagination"]["nDisplayPage"] . ' / ' . $aDataReport["aPagination"]["nTotalPage"]; ?></label>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function() {
        var oFilterLabel = $('.report-filter .text-left label:first-child');
        var nMaxWidth = 0;
        oFilterLabel.each(function(index) {
            var nLabelWidth = $(this).outerWidth();
            if (nLabelWidth > nMaxWidth) {
                nMaxWidth = nLabelWidth;
            }
        });
        $('.report-filter .text-left label:first-child').width(nMaxWidth + 50);
    });
</script>
