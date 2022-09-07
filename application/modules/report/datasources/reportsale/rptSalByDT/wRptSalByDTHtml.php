<?php
    $aDataReport    = $aDataViewRpt['aDataReport'];
    $aDataTextRef   = $aDataViewRpt['aDataTextRef'];
    $aDataFilter    = $aDataViewRpt['aDataFilter'];

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
        /* border-top: 1px solid black !important; */
        border-top: dashed 1px #333 !important;
        border-bottom : 1px solid black !important;

    }

    /*แนวนอน*/
    @media print{@page {size: landscape;
        margin: 1.5mm 1.5mm 1.5mm 1.5mm;
    }}
</style>

<div id="odvRptSaleMemberHtml">
    <div class="container-fluid xCNLayOutRptHtml">
        <div class="xCNHeaderReport">
            <div class="row">
                <?php include 'application\modules\report\datasources\Address\wRptAddress.php'; ?>
                <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 report-filter">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <div class="text-center">
                                <label class="xCNRptTitle"><?php echo $aDataTextRef['tTitleReport']; ?></label>
                            </div>
                        </div>
                    </div>

                    <?php if((isset($aDataFilter['tDocDateFrom']) && !empty($aDataFilter['tDocDateFrom'])) && (isset($aDataFilter['tDocDateTo']) && !empty($aDataFilter['tDocDateTo']))): ?>
                        <!-- ============================ ฟิวเตอร์ข้อมูล วันที่สร้างเอกสาร ============================ -->
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="text-center">
                                    <label class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptTaxSaleMemberDocDateFrom']?></label>   <label><?=date('d/m/Y',strtotime($aDataFilter['tDocDateFrom']));?>  </label>&nbsp;
                                    <label class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptTaxSaleMemberDocDateTo']?></label>     <label><?=date('d/m/Y',strtotime($aDataFilter['tDocDateTo']));?>    </label>
                                </div>
                            </div>
                        </div>
                    <?php endif;?>

                    <?php if( (isset($aDataFilter['tBchCodeFrom']) && !empty($aDataFilter['tBchCodeFrom'])) && (isset($aDataFilter['tBchCodeTo']) && !empty($aDataFilter['tBchCodeTo']))) { ?>
                        <!-- ============================ ฟิวเตอร์ข้อมูล สาขา ============================ -->
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="text-center">
                                    <label class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptTaxSaleMemberBchFrom']?></label> <label><?=$aDataFilter['tBchNameFrom'];?></label>&nbsp;
                                    <label class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptTaxSaleMemberBchTo']?></label> <label><?=$aDataFilter['tBchNameTo'];?></label>
                                </div>
                            </div>
                        </div>
                    <?php } ;?>

                </div>
            </div>
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="text-right">
                        <label class="xCNRptDataPrint"><?php echo $aDataTextRef['tDatePrint'].' '.date('d/m/Y').' '.$aDataTextRef['tTimePrint'].' '.date('H:i:s');?></label>
                    </div>
                </div>
            </div>
        </div>
        <div class="xCNContentReport">
            <div id="odvRptTableAdvance" class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th nowrap class="text-left  xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdPbnName'];?></th>
                            <th nowrap class="text-left  xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdDocDate'];?></th>
                            <th nowrap class="text-left  xCNRptColumnHeader" style="width:20%;"><?php echo $aDataTextRef['tRptSbdDocNo'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdCstCode'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdCstName'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdCstTel'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdCstSex'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdSalRmk'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdBchCode'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdSalMan'];?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdQty'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdPdtName'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdPdtCode'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdPdtSKU'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdClrName'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdPszName'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdGen'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdSeaName'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdChnName'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdAge'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdNatName'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdDepName'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdCmlName'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdClsName'];?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdReTail'];?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdGrosSale'];?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdGrosSaleEx'];?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdNetSale'];?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdNetSaleEx'];?></th>
                            <th nowrap class="text-left xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdDisText'];?></th>
                            <th nowrap class="text-right xCNRptColumnHeader" style="width:10%;"><?php echo $aDataTextRef['tRptSbdDisAmt'];?></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if(isset($aDataReport['aRptData']) && !empty($aDataReport['aRptData'])) { ?>
                            <?php foreach ($aDataReport['aRptData'] as $nKey => $aValue) { ?>
                                <tr>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTPbnName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo date('d/m/Y',strtotime($aValue['FDXshDocDate'])); ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTXshDocNo']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php if(!empty($aValue['FTCstCode'])){ echo $aValue['FTCstCode']; }else{ echo '-'; } ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php if(!empty($aValue['FTCstName'])){ echo $aValue['FTCstName']; }else{ echo $aDataTextRef['tRptCstNormal']; } ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTCstTel']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FNXshSex']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTXshRmk']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTBchName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTUsrName']; ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($aValue['FCXsdQty'],$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTXsdPdtName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTPdtCode']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTFhnRefCode']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTClrName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTPszName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTFhnGender']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTSeaName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTChnName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FNXshAge']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTXshNation']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTDepName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTCmlName']; ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTClsName']; ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($aValue['FCXsdSetPrice'],$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($aValue['FCXsdGrossSales'],$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($aValue['FCXsdGrossSalesExVat'],$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($aValue['FCXsdNetSales'],$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($aValue['FCXsdNetSalesEx'],$nOptDecimalShow); ?></td>
                                    <td nowrap class="text-left xCNRptDetail"><?php echo $aValue['FTXddDisChgTxt']; ?></td>
                                    <td nowrap class="text-right xCNRptDetail"><?php echo number_format($aValue['FCXsdDis'],$nOptDecimalShow); ?></td>
                                </tr>
                                <?php
                                    $paFooterSumData = array(
                                        $aDataTextRef['tRptSbdTotal'],
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
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        'N',
                                        number_format($aValue["FCXsdSetPrice_Footer"],$nOptDecimalShow),
                                        number_format($aValue["FCXsdGrossSales_Footer"],$nOptDecimalShow),
                                        number_format($aValue["FCXsdGrossSalesExVat_Footer"],$nOptDecimalShow),
                                        number_format($aValue["FCXsdNetSales_Footer"],$nOptDecimalShow),
                                        number_format($aValue["FCXsdNetSalesEx_Footer"],$nOptDecimalShow),
                                        'N',
                                        number_format($aValue["FCXsdDis_Footer"],$nOptDecimalShow)
                                    );
                                ?>
                            <?php } ?>
                            <?php
                                // Step 6 : สั่ง Summary Footer
                                $nPageNo = $aDataReport["aPagination"]["nDisplayPage"];
                                $nTotalPage = $aDataReport["aPagination"]["nTotalPage"];
                                FCNtHRPTSumFooter($nPageNo, $nTotalPage, $paFooterSumData);
                            ?>
                        <?php }else { ?>
                            <tr><td class='text-center xCNTextDetail2' colspan='100%'><?php echo $aDataTextRef['tRptTaxSalePosNoData'];?></td></tr>
                        <?php } ;?>
                    </tbody>
                </table>
            </div>

            <div class="xCNRptFilterTitle"> <!-- style="margin-top: 10px;" -->
                <div class="text-left">
                    <label class="xCNTextConsOth"><?=$aDataTextRef['tRptConditionInReport'];?></label>
                </div>
            </div>

            <!-- ============================ ฟิวเตอร์ข้อมูล สาขา ============================ -->
            <?php if (isset($aDataFilter['tBchCodeSelect']) && !empty($aDataFilter['tBchCodeSelect'])) : ?>
                <div class="xCNRptFilterBox">
                    <div class="xCNRptFilter">
                        <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptBchFrom']; ?> : </span> <?php echo ($aDataFilter['bBchStaSelectAll']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tBchNameSelect']; ?></label>
                    </div>
                </div>
            <?php endif; ?>

             <!-- ============================ ฟิวเตอร์ข้อมูล กลุ่มธุรกิจ ============================ -->
            <?php if ((isset($aDataFilter['tRptMerCodeFrom']) && !empty($aDataFilter['tRptMerCodeFrom'])) && (isset($aDataFilter['tRptMerCodeTo']) && !empty($aDataFilter['tRptMerCodeTo']))) : ?>
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjMerChantFrom'].' : </span>'.$aDataFilter['tRptMerNameFrom'];?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjMerChantTo'].' : </span>'.$aDataFilter['tRptMerNameTo'];?></label>
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
            <?php if ((isset($aDataFilter['tRptShpCodeFrom']) && !empty($aDataFilter['tRptShpCodeFrom'])) && (isset($aDataFilter['tRptShpCodeTo']) && !empty($aDataFilter['tRptShpCodeTo']))) : ?>
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjShopFrom'].' : </span>'.$aDataFilter['tRptShpNameFrom'];?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjShopTo'].' : </span>'.$aDataFilter['tRptShpNameTo'];?></label>
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
            <?php if ((isset($aDataFilter['tRptPosCodeFrom']) && !empty($aDataFilter['tRptPosCodeFrom'])) && (isset($aDataFilter['tRptPosCodeTo']) && !empty($aDataFilter['tRptPosCodeTo']))) : ?>
            <div class="xCNRptFilterBox">
                <div class="text-left xCNRptFilter">
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjPosFrom'].' : </span>'.$aDataFilter['tRptPosCodeFrom'];?></label>
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptAdjPosTo'].' : </span>'.$aDataFilter['tRptPosCodeTo'];?></label>
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

            <!-- ============================ ฟิวเตอร์ข้อมูล ประเภทสินค้า ============================ -->
            <?php if ((isset($aDataFilter['tPtyCodeFrom']) && !empty($aDataFilter['tPtyCodeFrom'])) && (isset($aDataFilter['tPtyCodeTo']) && !empty($aDataFilter['tPtyCodeTo']))) : ?>
            <div class="xCNRptFilterBox">
                <div class="text-left xCNRptFilter">
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tPdtTypeFrom'].' : </span>'.$aDataFilter['tPtyCodeFrom'];?></label>
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tPdtTypeTo'].' : </span>'.$aDataFilter['tPtyCodeTo'];?></label>
                </div>
            </div>
            <?php endif; ?>

            <!-- ============================ ฟิวเตอร์ข้อมูล ยี่ห้อ ============================ -->
            <?php if ((isset($aDataFilter['tPbnCodeFrom']) && !empty($aDataFilter['tPbnCodeFrom'])) && (isset($aDataFilter['tPbnCodeTo']) && !empty($aDataFilter['tPbnCodeTo']))) : ?>
            <div class="xCNRptFilterBox">
                <div class="text-left xCNRptFilter">
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptBrandFrom'].' : </span>'.$aDataFilter['tPbnCodeFrom'];?></label>
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptBrandTo'].' : </span>'.$aDataFilter['tPbnCodeTo'];?></label>
                </div>
            </div>
            <?php endif; ?>


            <!-- ============================ ฟิวเตอร์ข้อมูล สินค้า ============================ -->
            <?php if ((isset($aDataFilter['tPdtCodeFrom']) && !empty($aDataFilter['tPdtCodeFrom'])) && (isset($aDataFilter['tPdtCodeTo']) && !empty($aDataFilter['tPdtCodeTo']))) : ?>
            <div class="xCNRptFilterBox">
                <div class="text-left xCNRptFilter">
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tPdtCodeFrom'].' : </span>'.$aDataFilter['tPdtCodeFrom'];?></label>
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tPdtCodeTo'].' : </span>'.$aDataFilter['tPdtCodeTo'];?></label>
                </div>
            </div>
            <?php endif; ?>


            <?php if( (isset($aDataFilter['tSeaCodeFrom']) && !empty($aDataFilter['tSeaCodeFrom'])) && (isset($aDataFilter['tSeaCodeTo']) && !empty($aDataFilter['tSeaCodeTo']))) { ?>
                <!-- ===== ฟิวเตอร์ข้อมูล สินค้า =========================================== -->
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tSeaCodeFrom'].' : </span>'.$aDataFilter['tSeaNameFrom'];?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tSeaCodeTo'].' : </span>'.$aDataFilter['tSeaNameTo'];?></label>
                    </div>
                </div>
            <?php } ;?>
            <?php if( (isset($aDataFilter['tFabCodeFrom']) && !empty($aDataFilter['tFabCodeFrom'])) && (isset($aDataFilter['tFabCodeTo']) && !empty($aDataFilter['tFabCodeTo']))) { ?>
                <!-- ===== ฟิวเตอร์ข้อมูล สินค้า =========================================== -->
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tFabCodeFrom'].' : </span>'.$aDataFilter['tFabNameFrom'];?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tFabCodeTo'].' : </span>'.$aDataFilter['tFabNameTo'];?></label>
                    </div>
                </div>
            <?php } ;?>
            <?php if( (isset($aDataFilter['tClrCodeFrom']) && !empty($aDataFilter['tClrCodeFrom'])) && (isset($aDataFilter['tClrCodeTo']) && !empty($aDataFilter['tClrCodeTo']))) { ?>
                <!-- ===== ฟิวเตอร์ข้อมูล สินค้า =========================================== -->
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tClrCodeFrom'].' : </span>'.$aDataFilter['tClrNameFrom'];?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tClrCodeTo'].' : </span>'.$aDataFilter['tClrNameTo'];?></label>
                    </div>
                </div>
            <?php } ;?>
            <?php if( (isset($aDataFilter['tPszCodeFrom']) && !empty($aDataFilter['tPszCodeFrom'])) && (isset($aDataFilter['tPszCodeTo']) && !empty($aDataFilter['tPszCodeTo']))) { ?>
                <!-- ===== ฟิวเตอร์ข้อมูล สินค้า =========================================== -->
                <div class="xCNRptFilterBox">
                    <div class="text-left xCNRptFilter">
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tPszCodeFrom'].' : </span>'.$aDataFilter['tPszNameFrom'];?></label>
                        <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tPszCodeTo'].' : </span>'.$aDataFilter['tPszNameTo'];?></label>
                    </div>
                </div>
            <?php } ;?>
            <!-- ============================ ฟิวเตอร์ข้อมูล ลูกค้า ============================ -->
            <?php if ((isset($aDataFilter['tCstCodeFrom']) && !empty($aDataFilter['tCstCodeFrom'])) && (isset($aDataFilter['tCstCodeTo']) && !empty($aDataFilter['tCstCodeTo']))) : ?>
            <div class="xCNRptFilterBox">
                <div class="text-left xCNRptFilter">
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptCstFrom'].' : </span>'.$aDataFilter['tCstCodeFrom'];?></label>
                    <label class="xCNRptLabel xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptCstTo'].' : </span>'.$aDataFilter['tCstCodeTo'];?></label>
                </div>
            </div>
            <?php endif; ?>
            <?php if (isset($aDataFilter['tCstCodeSelect']) && !empty($aDataFilter['tCstCodeSelect'])) : ?>
                <div class="xCNRptFilterBox">
                    <div class="xCNRptFilter">
                        <label class="xCNRptDisplayBlock"><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptCstFrom']; ?> : </span> <?php echo ($aDataFilter['bCstStaSelectAll']) ? $aDataTextRef['tRptAll'] : $aDataFilter['tCstCodeSelect']; ?></label>
                    </div>
                </div>
            <?php endif; ?>

            <!-- ============================ ฟิวเตอร์ข้อมูล tRptPosType ============================ -->
            <div class="xCNRptFilterBox">
                <div class="text-left xCNRptFilter">
                    <label class="xCNRptLabel xCNRptDisplayBlock" ><span class="xCNRptFilterHead"><?php echo $aDataTextRef['tRptPosTypeName'].' : </span>'.$aDataTextRef['tRptPosType'.$aDataFilter['tPosType']]; ?></label>
                </div>
            </div>
        </div>
        <div class="xCNFooterPageRpt">
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="text-right">
                        <?php if($aDataReport["aPagination"]["nTotalPage"] > 0):?>
                            <label class="xCNRptLabel"><?php echo $aDataReport["aPagination"]["nDisplayPage"].' / '.$aDataReport["aPagination"]["nTotalPage"]; ?></label>
                        <?php endif;?>
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
