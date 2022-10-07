<input id="oetMCRStaBrowse"         type="hidden"   value="<?=$nBrowseType?>">
<input id="oetMCRCallBackOption"    type="hidden"   value="<?=$tBrowseOption?>">
<input id="oetMCRDataCutOffCsrCr"   type="hidden"   value="">
<?php if(isset($nBrowseType) && $nBrowseType == 0) : ?>
    <div id="odvMCRMainMenu" class="main-menu">
        <div class="xCNMrgNavMenu">
            <div class="row xCNavRow" style="width:inherit;">
                <div class="col-xs-12 col-sm-8 col-md-8 col-lg-8">
                    <ol id="oliMenuNav" class="breadcrumb">
                        <?php FCNxHADDfavorite('cstMngCredit/0/0');?> 
                        <li id="oliMCRTitle"        class="xCNLinkClick" style="cursor:pointer" onclick="JSvMCRCallPageList()"><?= language('customer/customermngcredit/customermngcredit','tMCRTitle')?></li>
                        <li id="oliMCRTitleAdd"     class="active"><a><?= language('customer/customermngcredit/customermngcredit','tMCRTitleAdd')?></a></li>
                        <li id="oliMCRTitleEdit"    class="active"><a><?= language('customer/customermngcredit/customermngcredit','tMCRTitleEdit')?></a></li>
                    </ol>
                </div>
                <div class="col-xs-12 col-sm-4 col-md-4 col-lg-4 text-right p-r-0">
                    <div class="demo-button xCNBtngroup" style="width:100%;">
                        <div id="odvBtnMCRInfo">
                            <?php if($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaAdd'] == 1) : ?>
                                <button onclick="JSvMCREventCutOffCredit()" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button" id="obtMCRBtnCutOffCstCr" style="display:none;">ปรับวงเงินเครดิตคงเหลือ</button>
                            <?php endif; ?>
                        </div>
                        <div id="odvBtnAddEdit">
                            <button onclick="JSvMCRCallPageList()" class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"><?= language('common/main/main', 'tBack')?></button>
                            <?php if($aAlwEvent['tAutStaFull'] == 1 || ($aAlwEvent['tAutStaAdd'] == 1 || $aAlwEvent['tAutStaEdit'] == 1)) : ?>
                                <div class="btn-group"  id="obtBarSubmitMCR">
                                    <div class="btn-group">
                                        <button type="submit" class="btn xWBtnGrpSaveLeft" onclick="$('#obtMCRSubmitForm').click()"><?= language('common/main/main', 'tSave')?></button>
                                        <?=$vBtnSave?>
                                    </div>
                                </div>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>    
    </div>
    <div class="xCNMenuCump" id="odvMenuCump">&nbsp;</div>
    <div class="main-content">
        <div id="odvContentPageMCR"></div>
    </div>
<?php else: ?>
    <div class="modal-header xCNModalHead">
        <div class="row">
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                <a onclick="JCNxBrowseData('<?php echo $tBrowseOption?>')" class="xWBtnPrevious xCNIconBack" style="float:left;">
                    <i class="fa fa-arrow-left xCNIcon"></i>	
                </a>
                <ol id="oliBchNavBrowse" class="breadcrumb xCNMenuModalBrowse">
                    <li class="xWBtnPrevious" onclick="JCNxBrowseData('<?php echo $tBrowseOption?>')"><a><?php echo language('common/main/main','tShowData');?> : <?= language('customer/customermngcredit/customermngcredit','tMCRTitle')?></a></li>
                    <li class="active"><a><?= language('customer/customermngcredit/customermngcredit','tMCRTitleAdd')?></a></li>
                </ol>
            </div>
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                <div id="odvBchBtnGroup" class="demo-button xCNBtngroup" style="width:100%;">
                    <button type="button" class="btn xCNBTNPrimery" onclick="$('#obtSubmitMCR').click()"><?php echo language('common/main/main', 'tSave')?></button>
                </div>
            </div>
        </div>
        <div id="odvModalBodyBrowse" class="modal-body xCNModalBodyAdd">
        </div>
    </div>
<?php endif;?>
<?php include('script/jCstMngCredit.php'); ?>
