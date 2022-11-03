
<style>
     .xWBtnAdd {
        box-shadow: none;
    }
    
</style>
<input type="hidden" name="oetSPLBranchSplCode" id="oetSPLBranchSplCode" value="<?=$tSplCode?>">
<input type="hidden" name="oetSPLBranchSplName" id="oetSPLBranchSplName" value="<?=$tSplName?>">
<input type="hidden" name="oetSPLBranchBchCode" id="oetSPLBranchBchCode" value="<?=$tBchCode?>">
<input type="hidden" name="oetSPLBranchBchName" id="oetSPLBranchBchName" value="<?=$tBchName?>">
<div id="odvSplMenuTitle" class="">
        <div class="xCNMrgNavMenu">
            <div class="row xCNavRow" style="width:inherit;">
                <div class="col-xs-12 col-md-8 col-lg-8">
                    <ol id="oliMenuNav" class="breadcrumb">
                        <li id="oliSplBranchTitle" class="xCNLinkClick" onclick="JSxSPLBranchList()" style="cursor:pointer"><?= language('supplier/supplier/supplier','tSPLBranchTitle')?></li> <!-- เปลี่ยน -->
                        <li id="oliSplBranchTitleAdd" class="active"><a><?= language('supplier/supplier/supplier','tSPLBranchTitleAdd')?></a></li>
                        <li id="oliSplBranchTitleEdit" class="active"><a><?= language('supplier/supplier/supplier','tSPLBranchTitleEdit')?></a></li>
                    </ol>
                </div>
                <div class="col-xs-12 col-md-4 col-lg-4 text-right p-r-0">
                    <div id="odvBtnSplBranchInfo">
                        <button class="xCNBTNPrimeryPlus" type="button" onclick="JSxSPLBranchPageAdd()">+</button>
                    </div>
                    <div id="odvSPLBranchBtnAddEdit">
                        <div class="demo-button xCNBtngroup" style="width:100%;">
                            <button onclick="JSxSPLBranchList()"  class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"> <?php echo language('common/main/main', 'tBack')?></button>
                            <div class="btn-group xWBtnHide">
                                <button id="odvBtnGroup" type="submit" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" onclick="JSxSPLAddEditBranch()"> <?php echo language('common/main/main', 'tSave')?></button>
        
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="xCNMenuCump xCNSplBrowseLine" id="odvMenuCump">
        &nbsp;
    </div>
    <div class="main-content">
        <div class="row" id="odvContentPageSPLBranch"></div>
    </div>

<?php include "script/jSPLBranch.php"; ?> 