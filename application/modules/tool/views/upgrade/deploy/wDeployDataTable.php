<?php
if ($aDataList['rtCode'] == '1') {
    $nCurrentPage = $aDataList['rnCurrentPage'];
} else {
    $nCurrentPage = '1';
}
?>
<div class="row">
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr class="xCNCenter">
                        <?php if ($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaDelete'] == 1) : ?>
                            <th class="xCNTextBold" style="width:5%;"><?php echo  language('tool/tool/tool', 'tDPYTBChoose') ?></th>
                        <?php endif; ?>
                        <th class="xCNTextBold"><?php echo language('tool/tool/tool', 'tDPYTBDocNo') ?></th>
                        <th class="xCNTextBold"><?php echo language('tool/tool/tool', 'tDPYReleaseName') ?></th>
                        <th class="xCNTextBold"><?php echo language('tool/tool/tool', 'tDPYTBDocDate') ?></th>
                        <th class="xCNTextBold"><?php echo language('tool/tool/tool', 'tDPYStaPreDepTitle') ?></th>
                        <th class="xCNTextBold"><?php echo language('tool/tool/tool', 'tDPYStaDepTitle') ?></th>
                        <th class="xCNTextBold"><?php echo language('tool/tool/tool', 'tDPYTBCreateBy') ?></th>
                        <th class="xCNTextBold"><?php echo language('tool/tool/tool', 'tDPYPreApvBy') ?></th>
                        <th class="xCNTextBold"><?php echo language('tool/tool/tool', 'tDPYTBApvBy') ?></th>

                        <?php if ($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaDelete'] == 1) : ?>
                            <th class="xCNTextBold" style="width:5%;"><?= language('common/main/main', 'tCMNActionDelete') ?></th>
                        <?php endif; ?>

                        <?php if ($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaRead'] == 1) : ?>
                            <th class="xCNTextBold" style="width:5%;"><?= language('common/main/main', 'tCMNActionEdit') ?></th>
                        <?php endif; ?>
                    </tr>
                </thead>
                <tbody id="odvRGPList">
                    <?php if ($aDataList['rtCode'] == 1) : ?>
                        <?php
                        if (FCNnHSizeOf($aDataList['raItems']) != 0) {
                            foreach ($aDataList['raItems'] as $nKey => $aValue) : ?>
                                <?php

                                if ($aValue['FTXdhStaPreDep'] == 2) {
                                    $tStaPreDep =  language('tool/tool/tool', 'tDPYStaPreDep2'); //รอยืนยัน
                                    $tClassStaPreDep = 'text-warning';
                                }else if($aValue['FTXdhStaPreDep'] == 3){
                                    $tStaPreDep =  language('tool/tool/tool', 'tDPYStaPreDep3'); //รอยืนยัน
                                    $tClassStaPreDep = 'text-danger';
                                }else if($aValue['FTXdhStaPreDep'] == 1){
                                    $tStaPreDep =  language('tool/tool/tool', 'tDPYStaPreDep1'); //ยืนยันแล้ว
                                    $tClassStaPreDep = 'text-success';
                                }else{
                                    $tStaPreDep =  language('tool/tool/tool', 'tDPYStaPreDep'); //ยืนยันแล้ว
                                    $tClassStaPreDep = '';
                                }

                                if ($aValue['FTXdhStaDep'] == 2) {
                                    $tStaDep =  language('tool/tool/tool', 'tDPYStaDep2'); //รอยืนยัน
                                    $tClassStaDep = 'text-warning';
                                }else if($aValue['FTXdhStaDep'] == 3){
                                    $tStaDep =  language('tool/tool/tool', 'tDPYStaDep3'); //รอยืนยัน
                                    $tClassStaDep = 'text-danger';
                                }else if($aValue['FTXdhStaDep'] == 1){
                                    $tStaDep =  language('tool/tool/tool', 'tDPYStaDep1'); //ยืนยันแล้ว
                                    $tClassStaDep = 'text-success';
                                }else{
                                    $tStaDep =  language('tool/tool/tool', 'tDPYStaDep'); //ยืนยันแล้ว
                                    $tClassStaDep = '';
                                }


                                if ($aValue['FTXdhStaPreDep'] == 1 || $aValue['FTXdhStaPreDep'] == 3) {
                                    $tCheckboxDisabled  = "disabled";
                                    $tClassDisabled     = "xCNDocDisabled";
                                    $tTitle             = language('document/document/document', 'tDOCMsgCanNotDel');
                                    $tOnclick           = '';
                                } else {
                                    $tCheckboxDisabled  = "";
                                    $tClassDisabled     = '';
                                    $tTitle             = '';
                                    $tOnclick           = "onclick=JSoDPYDelDocSingle('" . $nCurrentPage . "','" . $aValue['FTXdhDocNo'] . "')";
                                }

                                ?>
                                <tr id="otrAdjustStock<?php echo $nKey ?>" class="text-center xCNTextDetail2 otrAdjustStock" data-code="<?php echo $aValue['FTXdhDocNo'] ?>" data-name="<?php echo $aValue['FTXdhDocNo'] ?>">
                                    <?php if ($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaDelete'] == 1) : ?>
                                        <td class="text-center">
                                             <label class="fancy-checkbox ">
                                                <input id="ocbListItem<?php echo $nKey ?>" type="checkbox" class="ocbListItem" name="ocbListItem[]" <?php echo $tCheckboxDisabled; ?>>
                                                <span class="<?php echo $tClassDisabled ?>">&nbsp;</span>
                                            </label>
                                        </td>
                                    <?php endif; ?>
                                    <td class="text-left"><?php echo (!empty($aValue['FTXdhDocNo'])) ? $aValue['FTXdhDocNo'] : '-' ?></td>
                                    <td class="text-left"><?php echo (!empty($aValue['FTXdhDepName'])) ? $aValue['FTXdhDepName'] : '-' ?></td>
                                    <td class="text-center"><?php echo (!empty($aValue['FDXdhDocDate'])) ? $aValue['FDXdhDocDate'] : '-' ?></td>
                                    <td class="text-left"><label class="xCNTDTextStatus <?= $tClassStaPreDep ?>"><?php echo $tStaPreDep; ?></label></td>

                                    <td class="text-left"><label class="xCNTDTextStatus <?= $tClassStaDep ?>"><?php echo $tStaDep; ?></label></td>
                                    <td class="text-left"><?php echo (!empty($aValue['USRCRDName'])) ? $aValue['USRCRDName'] : '-' ?> </td>
                                    <td class="text-left"><?php echo (!empty($aValue['USRPREName'])) ? $aValue['USRPREName'] : '-' ?></td>
                                    <td class="text-left"><?php echo (!empty($aValue['USRCRDName'])) ? $aValue['USRCRDName'] : '-' ?></td>
                                    <td>
                                        <img class="xCNIconTable xCNIconDel <?php echo $tClassDisabled ?>" src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/delete.png' ?>" <?=$tOnclick?> >
                                    </td>
                               
                                        <td>
                                            <?php if ($aValue['FTXdhStaPreDep'] == 1) { ?>
                                                <img class="xCNIconTable" style="width: 17px;" src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/view2.png' ?>" onClick="JSvDPYCallPageEdit('<?php echo $aValue['FTXdhDocNo'] ?>')">
                                            <?php } else { ?>
                                                <img class="xCNIconTable" src="<?php echo  base_url() . '/application/modules/common/assets/images/icons/edit.png' ?>" onClick="JSvDPYCallPageEdit('<?php echo $aValue['FTXdhDocNo'] ?>')">
                                            <?php } ?>
                                        </td>
                                   
                                </tr>
                            <?php endforeach;
                        } else { ?>
                            <tr>
                                <td class='text-center xCNTextDetail2' colspan='100%'><?php echo language('common/main/main', 'tCMNNotFoundData') ?></td>
                            </tr>
                        <?php } ?>
                    <?php else : ?>
                        <tr>
                            <td class='text-center xCNTextDetail2' colspan='100%'><?php echo language('common/main/main', 'tCMNNotFoundData') ?></td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
        <p><?php echo language('common/main/main', 'tResultTotalRecord') ?> <?php echo $aDataList['rnAllRow'] ?> <?php echo language('common/main/main', 'tRecord') ?> <?php echo language('common/main/main', 'tCurrentPage') ?> <?php echo $aDataList['rnCurrentPage'] ?> / <?php echo $aDataList['rnAllPage'] ?></p>
    </div>
    <div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
        <div class="xWPageDPYPdt btn-toolbar pull-right">
            <?php if ($nPage == 1) {
                $tDisabledLeft = 'disabled';
            } else {
                $tDisabledLeft = '-';
            } ?>
            <button onclick="JSvDPYClickPage('previous')" class="btn btn-white btn-sm" <?php echo $tDisabledLeft ?>>
                <i class="fa fa-chevron-left f-s-14 t-plus-1"></i>
            </button>

            <?php for ($i = max($nPage - 2, 1); $i <= max(0, min($aDataList['rnAllPage'], $nPage + 2)); $i++) { ?>
                <?php
                if ($nPage == $i) {
                    $tActive = 'active';
                    $tDisPageNumber = 'disabled';
                } else {
                    $tActive = '';
                    $tDisPageNumber = '';
                }
                ?>
                <button onclick="JSvDPYClickPage('<?php echo $i ?>')" type="button" class="btn xCNBTNNumPagenation <?php echo $tActive ?>" <?php echo $tDisPageNumber ?>><?php echo $i ?></button>
            <?php } ?>

            <?php if ($nPage >= $aDataList['rnAllPage']) {
                $tDisabledRight = 'disabled';
            } else {
                $tDisabledRight = '-';
            } ?>
            <button onclick="JSvDPYClickPage('next')" class="btn btn-white btn-sm" <?php echo $tDisabledRight ?>>
                <i class="fa fa-chevron-right f-s-14 t-plus-1"></i>
            </button>
        </div>
    </div>
</div>
<!-- ===================================================== Modal Delete Document Single ===================================================== -->
<div id="odvDPYModalDelDocSingle" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header xCNModalHead">
                <label class="xCNTextModalHeard"><?php echo language('common/main/main', 'tModalDelete') ?></label>
            </div>
            <div class="modal-body">
                <span id="ospTextConfirmDelSingle" class="xCNTextModal" style="display: inline-block; word-break:break-all"></span>
            </div>
            <div class="modal-footer">
                <button id="osmDPYConfirmPdtDTTemp" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button"><?php echo language('common/main/main', 'tModalConfirm') ?></button>
                <button class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button" data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel') ?></button>
            </div>
        </div>
    </div>
</div>
<!-- ======================================================================================================================================== -->

<!-- ===================================================== Modal Delete Document Multiple =================================================== -->
<div id="odvDPYModalDelDocMultiple" class="modal fade" tabindex="-1" role="dialog">
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
                <button id="osmConfirmDelMultiple" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button"><?php echo language('common/main/main', 'tModalConfirm') ?></button>
                <button class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button" data-dismiss="modal"><?php echo language('common/main/main', 'tModalCancel') ?></button>
            </div>
        </div>
    </div>
</div>
<!-- ======================================================================================================================================== -->
<script type="text/javascript">
    $(document).ready(function(){
        // Click Check Box List Delete All
        $('.ocbListItem').unbind().click(function(){
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
                JSxDPYTextInModal();
            }else{
                var aReturnRepeat = JStDPYFindObjectByKey(aArrayConvert[0],'nCode',nCode);
                if(aReturnRepeat == 'None' ){           //ยังไม่ถูกเลือก
                    obj.push({"nCode": nCode, "tName": tName });
                    localStorage.setItem("LocalItemData",JSON.stringify(obj));
                    JSxDPYTextInModal();
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
                    JSxDPYTextInModal();
                }
            }
            JSxDPYShowButtonChoose();
        });

        // Confirm Delete Modal Multiple
        $('#odvDPYModalDelDocMultiple #osmConfirmDelMultiple').unbind().click(function(){
            var nStaSession = JCNxFuncChkSessionExpired();
            if (typeof nStaSession !== "undefined" && nStaSession == 1) {
                JSoDPYDelDocMultiple();
            }else{
                JCNxShowMsgSessionExpired();
            }
        });
    });
</script>