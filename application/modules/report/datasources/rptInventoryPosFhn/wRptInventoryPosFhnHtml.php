<?php
    $aCompanyInfo = $aDataViewRpt['aCompanyInfo'];
    $aDataFilter = $aDataViewRpt['aDataFilter'];
    $aDataTextRef = $aDataViewRpt['aDataTextRef'];
    $aDataReport = $aDataViewRpt['aDataReport'];
    $nOptDecimalShow = $aDataViewRpt['nOptDecimalShow'];

?>

<style>
    .xCNFooterRpt {
        border-bottom : 7px double #ddd;
    }

    .table thead th, .table>thead>tr>th, .table tbody tr, .table>tbody>tr>td {
        border: 0px transparent !important;
    }

    .table>thead:first-child>tr:first-child>td, .table>thead:first-child>tr:first-child>th {
        border-top: 1px solid black !important;
        border-bottom : 1px solid black !important;

        /* background-color: #CFE2F3 !important; */
    }

    .table>tbody>tr.xCNTrSubFooter{
        border-top: 1px solid black !important;
        border-bottom : 1px solid black !important;
        /* background-color: #CFE2F3 !important; */
    }

    .table>tbody>tr.xCNTrFooter{
        border-top: 1px solid black !important;
    }
    .table tbody tr.xCNHeaderGroup, .table>tbody>tr.xCNHeaderGroup>td {
        /* color: #232C3D !important; */
        font-size: 18px !important;
        font-weight: 600;
    }
    .table>tbody>tr.xCNHeaderGroup>td:nth-child(4), .table>tbody>tr.xCNHeaderGroup>td:nth-child(5) {
        text-align: right;
    }

    /*แนวนอน*/
    @media print{@page {
        size: A4 portrait;
        margin: 5mm 5mm 5mm 5mm;
    }}

    /*แนวตั้ง*/
    /*@media print{@page {size: portrait}}*/
</style>

<div id="odvRptProductTransferHtml">
    <div class="container-fluid xCNLayOutRptHtml">

        <div class="xCNHeaderReport">
            <div class="row">
                <?php include 'application\modules\report\datasources\Address\wRptAddress.php'; ?>
                <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">

                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <div class="text-center">
                                <label class="xCNRptTitle"><?php echo $aDataTextRef['tTitleReport']; ?></label>
                            </div>
                        </div>
                    </div>

                    <?php if ((isset($aDataFilter['tBchCodeFrom']) && !empty($aDataFilter['tBchCodeFrom'])) && (isset($aDataFilter['tBchCodeTo']) && !empty($aDataFilter['tBchCodeTo']))) { ?>
                        <!-- ============================ ฟิวเตอร์ข้อมูล สาขา ============================ -->
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="text-center">
                                    <label class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptBchFrom']?> : </label>   <label><?=$aDataFilter['tBchNameFrom'];?></label>&nbsp;
                                    <label class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptBchTo']?> : </label>     <label><?=$aDataFilter['tBchNameTo']; ?></label>
                                </div>
                            </div>
                        </div>
                    <?php }; ?>
                </div>
                <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 "></div>
            </div>
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 table-responsive">
                    <div class="text-right">
                        <?php date_default_timezone_set('Asia/Bangkok'); ?>
                        <label class="xCNRptDataPrint"><?php echo $aDataTextRef['tDatePrint'] . ' ' . date('d/m/Y') . ' ' . $aDataTextRef['tTimePrint'] . ' ' . date('H:i:s'); ?></label>
                    </div>
                </div>
            </div>
        </div>
        <div class="xCNContentReport">
            <div id="odvRptTableAdvance" class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:5%;" ><?php echo $aDataTextRef['tRptBarchCode']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tRptBarchName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:5%;" ><?php echo $aDataTextRef['tRptPDTWahCode']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tRptPDTWahName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:5%;" ><?php echo $aDataTextRef['tRptPdtCode']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:30%;" ><?php echo $aDataTextRef['tRptPdtName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:15%;" ><?php echo $aDataTextRef['tRptBarCode']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:15%;" ><?php echo $aDataTextRef['tFTFhnRefCode']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tRptSbdDepName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tRptSbdClsName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tRptSbdSeaName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tFTFabName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tRptSbdClrName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tRptSbdPszName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tFTPmoName']; ?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="vertical-align : middle;text-align:left; width:10%;" ><?php echo $aDataTextRef['tRptPDTChainName']; ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="vertical-align : middle;text-align:right; width:10%;"><?php echo $aDataTextRef['tRptPosVendingCount']; ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="vertical-align : middle;text-align:right; width:10%;"><?php echo $aDataTextRef['tRptCabinetCostAvg']; ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="vertical-align : middle;text-align:right; width:10%;"><?php echo $aDataTextRef['tRptProductValue']; ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="vertical-align : middle;text-align:right; width:10%;"><?php echo $aDataTextRef['tRptCabinetCost'];   ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="vertical-align : middle;text-align:right; width:10%;"><?php echo $aDataTextRef['tRptProductValueTotal']; ?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="vertical-align : middle;text-align:right; width:10%;"><?php echo $aDataTextRef['tRptTotalAfterCost']; ?></th>
                        </tr>
                     
                    </thead>
                    <tbody>
                        <?php if (isset($aDataReport['aRptData']) && !empty($aDataReport['aRptData'])) { ?>
                            <?php
                            // Set ตัวแปร SumSubFooter และ ตัวแปร SumFooter
                            $nSubSumAjdWahB4Adj = 0;
                            $nSubSumAjdUnitQty  = 0;
                            $nVal               = 0;
                            $tBchCodeNew        = '';
                            $tWahCodeOld        = '';
                            $tPDTCodeOld        = '';
                            $tChainCodeName     = 'First';
                            ?>

                            <!--กลาง-->
                            <?php foreach ($aDataReport['aRptData'] as $nKey => $aValue) { ?>
                                <?php
                                    // Step 1 เตรียม Parameter สำหรับการ Groupping
                                    $tWahCode       = $aValue["FTWahName"];
                                    $tPDTCode       = $aValue["FTPdtCode"];
                                    $tPDTName       = $aValue["FTPdtName"];
                                    $tFhnRefCode    = $aValue["FTFhnRefCode"];
                                    $tDepName    = $aValue["FTDepName"];
                                    $tClsName    = $aValue["FTClsName"];
                                    $tSeaName    = $aValue["FTSeaName"];
                                    $tPmoName    = $aValue["FTPmoName"];
                                    $nGroupMember   = $aValue["FNRptGroupMember"];
                                    $nRowPartID     = $aValue["FNRowPartID"];
                                    $tBchCode       = $aValue["FTBchCode"];

                                    $cFCStkQty = empty($aValue['FCStkQty']) ? 0 : $aValue['FCStkQty'];
                                    $cFCPdtCostAVGEX = empty($aValue['FCPdtCostAVGEX']) ? 0 : $aValue['FCPdtCostAVGEX'];
                                    $cFCPgdPriceRet = empty($aValue['FCPgdPriceRet']) ? 0 : $aValue['FCPgdPriceRet'];
                                    $cFCPdtCostTotal = empty($aValue['FCPdtCostTotal']) ? 0 : $aValue['FCPdtCostTotal'];
                                    $cFCXshNetSale = empty($aValue['FCXshNetSale']) ? 0 : $aValue['FCXshNetSale'];
                                    $cFCXshDiffCost = empty($aValue['FCXshDiffCost']) ? 0 : $aValue['FCXshDiffCost'];
                                ?>
                              
                              <tr>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTBchCode']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTBchName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTWahCode']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTWahName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTPdtCode']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTPdtName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTBarCode']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTFhnRefCode']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTDepName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTClsName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTSeaName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTFabName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php if(!empty($aValue['FTClrRmk'])){ echo '('.$aValue['FTClrRmk'].') '; } echo $aValue['FTClrName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTPszName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTPmoName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo ($aValue['FTPgpChainName'] == "" ? "-" : $aValue['FTPgpChainName']) ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($cFCStkQty,$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($cFCPdtCostAVGEX,$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($cFCPgdPriceRet,$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($cFCPdtCostTotal,$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($cFCXshNetSale,$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($cFCXshDiffCost,$nOptDecimalShow); ?></td>
                                </tr>
                                <?php
                                    $paFooterSumData = array(
                                        $aDataTextRef['tRptTotalFooter'],
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        number_format($aValue["FCStkQty_Footer"],$nOptDecimalShow),
                                        'N',
                                        'N',
                                        number_format($aValue["FCPdtCostTotal_Footer"],$nOptDecimalShow),
                                        number_format($aValue["FCXshNetSale_Footer"],$nOptDecimalShow),
                                        number_format($aValue["FCXshDiffCost_Footer"],$nOptDecimalShow)
                                    );
                                ?>
                            <?php } ?>
                            <?php
                                // Step 6 : สั่ง Summary Footer
                                $nPageNo = $aDataReport["aPagination"]["nDisplayPage"];
                                $nTotalPage = $aDataReport["aPagination"]["nTotalPage"];
                                FCNtHRPTSumFooter($nPageNo, $nTotalPage, $paFooterSumData);
                            ?>

                        <?php } else { ?>
                            <tr><td class='text-center xCNTextDetail2' colspan='100%'><?php echo $aDataTextRef['tRptAdjStkNoData']; ?></td></tr>
                        <?php } ?>
                    </tbody>
                </table>
            </div>


            <?php if ((isset($aDataFilter['tWahNameFrom']) && !empty($aDataFilter['tWahNameFrom'])) && (isset($aDataFilter['tWahNameTo']) && !empty($aDataFilter['tWahNameTo']))
                        || (isset($aDataFilter['tMerCodeFrom']) && !empty($aDataFilter['tMerCodeFrom'])) && (isset($aDataFilter['tMerCodeTo']) && !empty($aDataFilter['tMerCodeTo']))
                        || (isset($aDataFilter['tShpCodeFrom']) && !empty($aDataFilter['tShpCodeFrom'])) && (isset($aDataFilter['tShpCodeTo']) && !empty($aDataFilter['tShpCodeTo']))
                        || (isset($aDataFilter['tPosCodeFrom']) && !empty($aDataFilter['tPosCodeFrom'])) && (isset($aDataFilter['tPosCodeTo']) && !empty($aDataFilter['tPosCodeTo']))
                        || (isset($aDataFilter['tWahCodeFrom']) && !empty($aDataFilter['tWahCodeFrom'])) && (isset($aDataFilter['tWahCodeTo']) && !empty($aDataFilter['tWahCodeTo']))
                        || (isset($aDataFilter['tBchCodeSelect']))
                        || (isset($aDataFilter['tMerCodeSelect']))
                        || (isset($aDataFilter['tShpCodeSelect']))
                        || (isset($aDataFilter['tPosCodeSelect']))
                        || (isset($aDataFilter['tWahCodeSelect']))
                        ){ ?>
                    <div class="xCNRptFilterTitle">
                        <div class="text-left">
                            <label class="xCNTextConsOth"><?=$aDataTextRef['tRptConditionInReport'];?></label>
                        </div>
                    </div>
                <?php }; ?>

                 <!-- ============================ ฟิวเตอร์ข้อมูล สาขา ============================ -->
                <?php if (isset($aDataFilter['tBchCodeSelect']) && !empty($aDataFilter['tBchCodeSelect'])) : ?>
                    <div class="xCNRptFilterBox">
                        <div class="xCNRptFilter">
                            <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptBchFrom']; ?> : </span> <?php echo ($aDataFilter['bBchStaSelectAll']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tBchNameSelect']; ?></label>
                        </div>
                    </div>
                <?php endif; ?>

                 <!-- ============================ ฟิวเตอร์ข้อมูล กลุ่มธุรกิจ ============================ -->
                <?php if ((isset($aDataFilter['tMerCodeFrom']) && !empty($aDataFilter['tMerCodeFrom'])) && (isset($aDataFilter['tMerCodeTo']) && !empty($aDataFilter['tMerCodeTo']))) : ?>
                    <div class="xCNRptFilterBox">
                        <div class="text-left xCNRptFilter">
                            <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjMerChantFrom'].' : </span>'.$aDataFilter['tMerNameFrom'];?></label>
                            <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjMerChantTo'].' : </span>'.$aDataFilter['tMerNameTo'];?></label>
                        </div>
                    </div>
                <?php endif; ?>
                <?php if (isset($aDataFilter['tMerCodeSelect']) && !empty($aDataFilter['tMerCodeSelect'])) : ?>
                    <div class="xCNRptFilterBox">
                        <div class="xCNRptFilter">
                            <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptMerFrom']; ?> : </span> <?php echo ($aDataFilter['bMerStaSelectAll']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tMerNameSelect']; ?></label>
                        </div>
                    </div>
                <?php endif; ?>

                <!-- ============================ ฟิวเตอร์ข้อมูล ร้านค้า ============================ -->
                <?php if ((isset($aDataFilter['tShpCodeFrom']) && !empty($aDataFilter['tShpCodeFrom'])) && (isset($aDataFilter['tShpCodeTo']) && !empty($aDataFilter['tShpCodeTo']))) : ?>
                    <div class="xCNRptFilterBox">
                        <div class="text-left xCNRptFilter">
                            <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjShopFrom'].' : </span>'.$aDataFilter['tShpNameFrom'];?></label>
                            <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjShopTo'].' : </span>'.$aDataFilter['tShpNameTo'];?></label>
                        </div>
                    </div>
                <?php endif; ?>
                <?php if (isset($aDataFilter['tShpCodeSelect']) && !empty($aDataFilter['tShpCodeSelect'])) : ?>
                    <div class="xCNRptFilterBox">
                        <div class="xCNRptFilter">
                            <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptShopFrom']; ?> : </span> <?php echo ($aDataFilter['bShpStaSelectAll']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tShpNameSelect']; ?></label>
                        </div>
                    </div>
                <?php endif; ?>

                <!-- ============================ ฟิวเตอร์ข้อมูล จุดขาย ============================ -->
                <?php if ((isset($aDataFilter['tPosCodeFrom']) && !empty($aDataFilter['tPosCodeFrom'])) && (isset($aDataFilter['tPosCodeTo']) && !empty($aDataFilter['tPosCodeTo']))) : ?>
                    <div class="xCNRptFilterBox">
                            <div class="text-left xCNRptFilter">
                                <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjPosFrom'].' : </span>'.$aDataFilter['tPosCodeFrom'];?></label>
                                <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjPosTo'].' : </span>'.$aDataFilter['tPosCodeTo'];?></label>
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
                            <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjWahFrom'].' : </span>'.$aDataFilter['tWahNameFrom'];?></label>
                            <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjWahTo'].' : </span>'.$aDataFilter['tWahNameTo'];?></label>
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
        </div>
        <div class="xCNFooterPageRpt">
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="text-right">
                        <?php if ($aDataReport["aPagination"]["nTotalPage"] > 0) { ?>
                            <label class="xCNRptLabel"><?php echo $aDataReport["aPagination"]["nDisplayPage"] . ' / ' . $aDataReport["aPagination"]["nTotalPage"]; ?></label>
                        <?php } ?>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function(){
        var oFilterLabel = $('.report-filter .text-left label:first-child');
        var nMaxWidth = 0;
        oFilterLabel.each(function(index){
            var nLabelWidth = $(this).outerWidth();
            if(nLabelWidth > nMaxWidth){
                nMaxWidth = nLabelWidth;
            }
        });
        $('.report-filter .text-left label:first-child').width(nMaxWidth + 50);
    });
</script>
