<style>
    .xCNBorderRight {
        border-right: 1px solid #cccccc;
    }

    .xCNNonBorder {
        border-top: 0px !important;
    }

    .xCNBorderBottom {
        border-bottom: 1px solid #cccccc;
    }

    .xCNTableOptionIco {
        width: 13px;
        cursor: pointer;
    }

    .xCNTableOptionIco:hover {
        width: 15px;
    }

    .table>tr>th {
        vertical-align: middle !important;
        font-size: 13px !important;
    }

    .table>tbody>tr>td {
        vertical-align: middle;
        font-size: 13px;
    }

    .xCNPointer {
        cursor: pointer;
    }
    .XCNPositionMaster {
        display: block;
        background:#f5f5f5;
        width:330px;
        height:155px;
        position : absolute;
        left:90px;
        border: 1px solid #070708;
        padding  : 10px;
        margin-top : -158px;
    }

    .xCNPositionMasterBtn {
        width: 70px;
        height: 30px;
        position: absolute;
        left: 83px;
        top: 0px;
    }


    <style style="text/css">
  	.hoverTable{
		width:100%; 
		border-collapse:collapse; 
	}
	.hoverTable td{ 
		padding:7px; border:#4e95f4 1px solid;
	}
	/* Define the default color for all the table rows */
	.hoverTable tr{
		background: #b8d1f3;
	}
	/* Define the hover highlight color for the table row */
    .hoverTable tr:hover {
          background-color: #ffff99;
    }
</style>
<input type="hidden" id="oetPdtForSys" value="<?php echo $tPdtForSys; ?>">
<input type="hidden" id="oetPage" value="<?php echo $nPage; ?>">

<?php
//Decimal Show ลง 2 ตำแหน่ง
$nDecShow =  FCNxHGetOptionDecimalShow();
?>

<div class="row">
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
        <div id="odvDataTableProduct" class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <?php if ($aAlwEventPdt['tAutStaFull'] == 1 || $aAlwEventPdt['tAutStaDelete'] == 1) : ?>
                            <th nowrap class="xCNTextBold text-center" style="width:5%;">
                                <label class="fancy-checkbox">
                                    <input type="checkbox" class="ocmCENCheckDeleteAll" id="ocmCENCheckDeleteAll">
                                    <span class="ospListItem">&nbsp;</span>
                                </label>
                            </th>
                        <?php endif; ?>
                        <th nowrap class="text-center xCNTextBold" style="width:5%;"><?php echo language('product/product/product', 'tPDTTBImg') ?></th>

                        <!--======================================== Loop Manage Table ====================================================-->
                        <?php foreach ($aPdtColumnShw as $HeaderColKey => $HeaderColVal) : ?>
                            <th nowrap class="text-center xCNTextBold"><?php echo iconv_substr($HeaderColVal->FTShwNameUsr, 0, 18, "UTF-8"); ?></th>
                        <?php endforeach; ?>
                        <!--===============================================================================================================-->
                        <?php if ($aAlwEventPdt['tAutStaFull'] == 1 || $aAlwEventPdt['tAutStaDelete'] == 1) : ?>
                            <th nowrap class="text-center xCNTextBold" style="width:5%;border-right-color: #fff !important;"><?php echo language('product/product/product', 'tPDTTBDelete') ?></th>
                        <?php endif; ?>
                        <?php if ($aAlwEventPdt['tAutStaFull'] == 1 || $aAlwEventPdt['tAutStaDelete'] == 1) : ?>
                            <th nowrap class="text-center xCNTextBold" style="width:5%;"><?php echo language('product/product/product', 'tPDTTBEdits') ?></th>
                        <?php endif; ?>
                    </tr>
                </thead>
                <tbody id="odvPdtDataList">
                    <?php $tProductCode = ''; ?>
                    <?php if (is_array($aPdtDataList) && $aPdtDataList['rtCode'] == 1) : ?>
                        <?php foreach ($aPdtDataList['raItems'] as $nKeys => $aDataPdtVal) : ?>
                            <?php if ($tProductCode !== $aDataPdtVal['FTPdtCode']) : ?>
                                <?php
                                    if($aDataPdtVal['rtPdtStaPriRef'] == '1'){
                                        $tDisableTD     = "xWTdDisable";
                                        $tDisableImg    = "xWImgDisable";
                                        $tDisabledItem  = "disabled ";
                                        $tDisabledItem2  = "xCNDisabled ";
                                        $tDisabledcheckrow  = "true";
                                    }else{
                                        $tDisableTD     = "";
                                        $tDisableImg    = "";
                                        $tDisabledItem  = "";
                                        $tDisabledItem2  = " ";
                                        $tDisabledcheckrow  = "false";
                                    }
                                ?>
                                <tr class="xCNTextDetail2 xWPdtInfo xWPdtTr<?=$aDataPdtVal['FNRowID']?>" data-keys="<?=$aDataPdtVal['FNRowID']?>" data-code="<?php echo $aDataPdtVal['FTPdtCode'];?>" data-name="<?php echo $aDataPdtVal['FTPdtName'];?>">

                                    <?php if ($aAlwEventPdt['tAutStaFull'] == 1 || $aAlwEventPdt['tAutStaDelete'] == 1) : ?>
                                        <td nowrap class="text-center xCNBorderRight xWPdtMerge">
                                            <label class="fancy-checkbox">
                                                <input id="ocbListItem<?php echo $nKeys ?>" <?php echo $tDisabledItem; ?> type="checkbox" class="ocbListItem" name="ocbListItem[]">
                                                <span class="<?php echo $tDisabledItem2; ?>">&nbsp;</span>
                                            </label>
                                        </td>
                                    <?php endif; ?>
                                    <td nowrap class="xCNBorderRight xWPdtImgtd text-center" rowspan="4" style="padding-right:10px !important">
                                        <?php echo FCNtHGetImagePageList($aDataPdtVal['FTImgObj'], '50px'); ?>
                                    </td>

                                    <?php foreach ($aPdtColumnShw as $nDataKey => $aDataVal) :
                                        $tColumnName        = $aDataVal->FTShwFedShw;
                                        $nColWidth          = $aDataVal->FNShwColWidth;
                                        $tColumnDataType    = substr($tColumnName, 0, 2);
                                        if ($tColumnDataType == 'FC') {
                                            $tAlignFormat   = 'text-right';
                                            $tDataCol       = number_format($aDataPdtVal[$tColumnName], $nDecShow);
                                        } elseif ($tColumnDataType == 'FN') {
                                            $tAlignFormat   = 'text-right';
                                            $tDataCol       = number_format($aDataPdtVal[$tColumnName], 0);
                                        } else {
                                            $tAlignFormat = 'text-left';
                                            $tDataCol = $aDataPdtVal[$tColumnName];
                                        }
                                    ?>
                                        <?php
                                        $tRemark = '';
                                        switch ($tColumnName) {
                                            case 'FTPdtName':
                                                $tClassMerge    = 'xWPdtMerge';
                                                break;
                                            case 'FTPdtCode':
                                                $tClassMerge    = 'xWPdtMerge';
                                                break;
                                            case 'FTPgpName':
                                                $tClassMerge    = 'xWPdtMerge';
                                                break;
                                            case 'FTPtyName':
                                                $tClassMerge    = 'xWPdtMerge';
                                                break;
                                            default:
                                                $tClassMerge    = '';
                                        }
                                        ?>

                                        <?php
                                        //เช็คค่าว่าง
                                        if ($tDataCol == '' || $tDataCol == null) {
                                            $tDataCol = '-';
                                        } else {
                                            $tDataCol = $tDataCol;
                                        }
                                        ?>

                                        <td nowrap class="<?php echo $tAlignFormat; ?> <?php echo $tClassMerge; ?>" style="width:<?php echo $nColWidth ?>%"><?php echo $tDataCol ?></td>
                                    <?php endforeach; ?>
                                    <?php if ($aAlwEventPdt['tAutStaFull'] == 1 || $aAlwEventPdt['tAutStaDelete'] == 1) : ?>
                                        <td nowrap class="text-center xWPdtMerge xWTDBorderPDT <?=$tDisableTD?>" style="border-right-color:#fff !important;border-top-style: double !important;">
                                            <img class="xCNIconTable xCNIconDelete xWPdtDeleteItem <?php echo $tDisableImg; ?>" data-delpage="<?php echo $nPage; ?>" data-delcode="<?php echo $aDataPdtVal['FTPdtCode']; ?>" data-delname="<?php echo $aDataPdtVal['FTPdtName']; ?>" data-type="<?php echo $aDataPdtVal['FTPdtForSystem']; ?>">
                                        </td>
                                    <?php endif; ?>

                                    <?php if ($aAlwEventPdt['tAutStaFull'] == 1 || $aAlwEventPdt['tAutStaDelete'] == 1) : ?>
                                        <td nowrap class="text-center xWPdtMerge xWTDBorderPDT" style="border-top-style: double !important;">
                                            <img class="xCNIconTable xCNIconEdit xWPdtCallPageEdit">
                                        </td>
                                    <?php endif; ?>
                                </tr>
                            <?php $tProductCode = $aDataPdtVal['FTPdtCode'];
                            elseif ($tProductCode === $aDataPdtVal['FTPdtCode']) : ?>
                                <tr class="xCNTextDetail2 xWPdtTr<?=$aDataPdtVal['FNRowID']?>">
                                    <?php foreach ($aPdtColumnShw as $nDataKey => $aDataVal) :
                                        $tColumnName        = $aDataVal->FTShwFedShw;
                                        $nColWidth          = $aDataVal->FNShwColWidth;
                                        $tColumnDataType    = substr($tColumnName, 0, 2);
                                        if ($tColumnDataType == 'FC') {
                                            $tAlignFormat   = 'text-right';
                                            $tDataCol       = number_format($aDataPdtVal[$tColumnName], $nDecShow);
                                        } elseif ($tColumnDataType == 'FN') {
                                            $tAlignFormat   = 'text-right';
                                            $tDataCol       = number_format($aDataPdtVal[$tColumnName], 0);
                                        } else {
                                            $tAlignFormat   = 'text-left';
                                            $tDataCol       = $aDataPdtVal[$tColumnName];
                                        }
                                    ?>
                                        <?php switch ($tColumnName):
                                            case 'FTPdtCode': ?>
                                                <!-- <td nowrap class="xCNNonBorder" style="width:<?php echo $nColWidth ?>%"></td> -->
                                                <?php break; ?>
                                            <?php
                                            case 'FTPdtName': ?>
                                                <?php break; ?>
                                            <?php
                                            case 'FTPgpChainName': ?>
                                                <td nowrap class="xCNNonBorder" style="width:<?php echo $nColWidth ?>%"></td>
                                                <?php break; ?>
                                            <?php
                                            case 'FTPgpName': ?>
                                                <?php break; ?>
                                            <?php
                                            case 'FTPtyName': ?>
                                                <?php break; ?>
                                            <?php
                                            default: ?>
                                                <td nowrap class="xCNNonBorder <?php echo $tAlignFormat ?>" style="width:<?php echo $nColWidth ?>%"><?php echo $tDataCol ?></td>
                                        <?php endswitch; ?>
                                    <?php endforeach; ?>
                                </tr>
                            <?php endif; ?>
                        <?php endforeach; ?>
                    <?php else : ?>
                        <tr>
                            <td class='text-center xCNTextDetail2' colspan='99'><?php echo language('common/main/main', 'tCMNNotFoundData') ?></td>
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
        <?php $nShowRecord = get_cookie('nShowRecordInPageList'); ?>
        <p>แสดงข้อมูลรายการล่าสุด <?= $nShowRecord ?> รายการ</p>
    </div>
</div>

<!-- ===================================================== Modal Delete Product Multiple =================================================== -->
<div id="odvModalDeletePdtMultiple" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <label class="xCNTextModalHeard"><?php echo language('common/main/main', 'tModalDelete') ?></label>
            </div>
            <div class="modal-body">
                <span id="ospTextConfirmDelMultiple" class="xCNTextModal" style="display: inline-block; word-break:break-all"></span>
                <input type='hidden' id="ohdConfirmIDDelMultiple">
            </div>
            <div class="modal-footer">
                <button id="osmConfirmDelMultiple" onclick="JSoProductDeleteMultiple();" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button"><?php echo language('common/main/main', 'tModalConfirm') ?></button>
                <button class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button" data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel') ?></button>
            </div>
        </div>
    </div>
</div>
<!-- ====================================================== End Modal Delete Product Multiple ============================================== -->

<div class="XCNPositionMaster xWCanEnterMaster" id="odvModalAddPdtConfigMaster"> 
    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
        <label class="xCNLabelFrm"><?php echo language('common/main/main','tCommonShowDetail')?></label>
    </div> 
    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6 text-right">
        <button id="obtPdtConfigSaveMaster" class="btn xCNBTNPrimery xCNBTNPrimery2Btn xCNPositionMasterBtn" type="button" onclick="JSvCallPageProductDataTable();"><?php echo language('common/main/main','tSave')?></button>
    </div><hr style="border-top: 1px solid black; margin-top: 35px; width:100%;" > 
        <div class="row"> <!--จำนวน Top Page-->
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
             <label class="xCNLabelFrm"> <input type="radio" name="ordStaTopPdt" value="1" class="ordStaTopPdt" <?php if($nStaTopPdt==1){ echo 'checked'; } ?>> <?php echo language('common/main/main','tStaTopPdtDres1')?></label>
            </div>
        </div>
        <div class="row">  <!--จำนวน PerPage-->
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
            <label class="xCNLabelFrm"><input type="radio" name="ordStaTopPdt" value="2" class="ordStaTopPdt" <?php if($nStaTopPdt==2){ echo 'checked'; } ?>> <?php echo language('common/main/main','tStaTopPdtDres2')?></label>
            </div>
       
        </div>
</div>

<script type="text/Javascript">
    $('ducument').ready(function(){
        JSxPdtSetRowSpan();

        $('#odvModalAddPdtConfigMaster').hide();

        $("#ospClickShowPDTConfigMaster").click(function(){
            $("#odvModalAddPdtConfigMaster").toggle();
            $("#oetMaxPageMater").focus();
        });

        //Enter ได้
        $('.xWCanEnterMaster').on('keypress',function(){
            if(event.keyCode == 13){
                $('#obtPdtConfigSaveMaster').click();
            }
        });
    });

    $('.xWPdtCallPageEdit').click(function(){
        var tPdtCode    = $(this).parents('.xWPdtInfo').data('code');
        JSvCallPageProductEdit(tPdtCode,'edit');
    });

    $('.xWPdtCallPageView').click(function(){
        var tPdtCode    = $(this).parents('.xWPdtInfo').data('code');
        JSvCallPageProductEdit(tPdtCode,'view');
    });

    $('.xCNBtnPagenation').click(function(){
        var tNumberPage = $(this).data('page');
        var nEndPage    = $(this).data('endpage');
        JSvProductClickPage(tNumberPage,nEndPage);
        return false;
    });

    // Event Delete Single
    $('.xWPdtDeleteItem').click(function(){
        var nPageDel        = $(this).data('delpage');
        var nPageCodeDel    = $(this).data('delcode');
        var nPageNameDel    = $(this).data('delname');
        var nPdtForSystem   = $(this).data('type');
        JSoProductDeleteSingle(nPageDel,nPageCodeDel,nPageNameDel,nPdtForSystem);
    });

    // Select List Table Item
    $('.ocbListItem').click(function(){
        var nCode = $(this).parent().parent().parent().data('code');  //code
        var tName = $(this).parent().parent().parent().data('name');  //Name
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
            JSxPaseCodeDelInModal();
        }else{
            var aReturnRepeat   = findObjectByKey(aArrayConvert[0],'nCode',nCode);
            if(aReturnRepeat == 'None' ){           //ยังไม่ถูกเลือก
                obj.push({"nCode": nCode, "tName": tName });
                localStorage.setItem("LocalItemData",JSON.stringify(obj));
                JSxPaseCodeDelInModal();
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
                JSxPaseCodeDelInModal();
            }
        }
        JSxShowButtonChoose();
    });

    //Function Chack RowSpan Image In Tr Data
    //Parameters : Document Redy And Event Button
    //Creator :	01/02/2019 wasin(Yoshi)
    //Return : Set RowSpan In TD
    //Return Type : None
    function JSxPdtSetRowSpan(){
        $('#odvDataTableProduct #odvPdtDataList .xWPdtInfo').each(function(){
            var tDataPdtCode        = $(this).data('keys');
            var nContDataRowSpan    = $('#odvDataTableProduct #odvPdtDataList .xWPdtTr'+tDataPdtCode).length;
            $('#odvDataTableProduct #odvPdtDataList .xWPdtTr'+tDataPdtCode+' .xWPdtImgtd').attr('rowspan',nContDataRowSpan);
            $('#odvDataTableProduct #odvPdtDataList .xWPdtTr'+tDataPdtCode+' .xWPdtMerge').attr('rowspan',nContDataRowSpan);
        });
    }
</script>