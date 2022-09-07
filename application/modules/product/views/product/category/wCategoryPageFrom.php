<?php 

    if($aMasterPdt['rtCode']=="1"){
        $tFhnPdtCode = $aMasterPdt['raItems']['FTPdtCode'];
        $tFhnPdtName = $aMasterPdt['raItems']['FTPdtName'];
        $tFhnDepCode = $aMasterPdt['raItems']['FTDepCode'];
        $tFhnDepName = $aMasterPdt['raItems']['FTDepName'];
        $tFhnClsCode = $aMasterPdt['raItems']['FTClsCode'];
        $tFhnClsName = $aMasterPdt['raItems']['FTClsName'];
        $tFhnSclCode = $aMasterPdt['raItems']['FTSclCode'];
        $tFhnSclName = $aMasterPdt['raItems']['FTSclName'];
        $tFhnPgpCode = $aMasterPdt['raItems']['FTPgpCode'];
        $tFhnPgpName = $aMasterPdt['raItems']['FTPgpName'];
        $tFhnCmlCode = $aMasterPdt['raItems']['FTCmlCode'];
        $tFhnCmlName = $aMasterPdt['raItems']['FTCmlName'];
        $tFhnModNo   = $aMasterPdt['raItems']['FTFhnModNo'];
        $nFhnGender  = $aMasterPdt['raItems']['FTFhnGender'];
    }else{
        $tFhnPdtCode = '';
        $tFhnPdtName = '';
        $tFhnDepCode = '';
        $tFhnDepName = '';
        $tFhnClsCode = '';
        $tFhnClsName = '';
        $tFhnSclCode = '';
        $tFhnSclName = '';
        $tFhnPgpCode = '';
        $tFhnPgpName = '';
        $tFhnCmlCode = '';
        $tFhnCmlName = '';
        $tFhnModNo   = '';
        $nFhnGender  = '';
    }
?>
<style>
.xPadding5 {
    padding:5px
}
</style>
<form action="javascript:void(0);" class="validate-form" method="post" id="ofmAddEditProductCategory">
<input type="hidden" name="oetCgyPdtCode" id="oetCgyPdtCode" value="<?=$tFhnPdtCode?>">
<div id="odvPdtCategoryMenuSelectPdt" class="row">
    <div class="col-xs-12 col-sm-9 col-md-9 col-lg-9" style="margin-bottom:10px;">

        <div class="row xPadding5" >
            <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3" id="odvtTmpImgForPdtCategoryPage">
                <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtName') ?> </label>
            </div>
            <div class="col-xs-12 col-sm-3 col-md-6 col-lg-6" id="odvCgyPdtName">
                <?=$tFhnPdtName?>
            </div>
        </div>

        <div class="row xPadding5">
            <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3" id="odvtTmpImgForPdtCategoryPage">
                <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtDepart') ?> </label>
            </div>
            <div class="col-xs-12 col-sm-3 col-md-6 col-lg-6" id="">
                    <div class="input-group">
                        <input type="text" id="oetCgyPdtDepartCode" class="form-control xCNHide" name="oetCgyPdtDepartCode" value="<?=$tFhnDepCode?>" data-validate="<?= language('product/product/product', 'tFhnPdtDepart') ?>" >
                        <input type="text" id="oetCgyPdtDepartName" class="form-control" name="oetCgyPdtDepartName" value="<?=$tFhnDepName?>" readonly>
                        <span class="input-group-btn">
                            <button id="obFhnPdtDepartBrows" type="button" class="btn xCNBtnBrowseAddOn">
                                <img src="<?php echo base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                            </button>
                        </span>
                    </div>
            </div>
        </div>

        <div class="row xPadding5">
            <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3" id="odvtTmpImgForPdtCategoryPage">
                <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtClass') ?> </label>
            </div>
            <div class="col-xs-12 col-sm-3 col-md-6 col-lg-6" id="">
                    <div class="input-group">
                        <input type="text" id="oetCgyPdtClassCode" class="form-control xCNHide" name="oetCgyPdtClassCode" value="<?=$tFhnClsCode?>" data-validate="<?= language('product/product/product', 'tFhnPdtClass') ?>">
                        <input type="text" id="oetCgyPdtClassName" class="form-control" name="oetCgyPdtClassName" value="<?=$tFhnClsName?>" readonly>
                        <span class="input-group-btn">
                            <button id="obFhnPdtClassBrows" type="button" class="btn xCNBtnBrowseAddOn">
                                <img src="<?php echo base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                            </button>
                        </span>
                    </div>
            </div>
        </div>

        <div class="row xPadding5">
            <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3" id="odvtTmpImgForPdtCategoryPage">
                <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtSubClass') ?> </label>
            </div>
            <div class="col-xs-12 col-sm-3 col-md-6 col-lg-6" id="">
                    <div class="input-group">
                        <input type="text" id="oetCgyPdtSubClassCode" class="form-control xCNHide" name="oetCgyPdtSubClassCode" value="<?=$tFhnSclCode?>" data-validate="<?= language('product/product/product', 'tFhnPdtSubClass') ?>">
                        <input type="text" id="oetCgyPdtSubClassName" class="form-control" name="oetCgyPdtSubClassName" value="<?=$tFhnSclName?>" readonly>
                        <span class="input-group-btn">
                            <button id="obFhnPdtSubClassBrows" type="button" class="btn xCNBtnBrowseAddOn">
                                <img src="<?php echo base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                            </button>
                        </span>
                    </div>
            </div>
        </div>

        <div class="row xPadding5">
            <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3" id="odvtTmpImgForPdtCategoryPage">
                <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtGroup') ?> </label>
            </div>
            <div class="col-xs-12 col-sm-3 col-md-6 col-lg-6" id="">
                    <div class="input-group">
                        <input type="text" id="oetCgyPdtGroupCode" class="form-control xCNHide" name="oetCgyPdtGroupCode" value="<?=$tFhnPgpCode?>" data-validate="<?= language('product/product/product', 'tFhnPdtGroup') ?>">
                        <input type="text" id="oetCgyPdtGroupName" class="form-control" name="oetCgyPdtGroupName" value="<?=$tFhnPgpName?>" readonly>
                        <span class="input-group-btn">
                            <button id="obFhnPdtGroupBrows" type="button" class="btn xCNBtnBrowseAddOn">
                                <img src="<?php echo base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                            </button>
                        </span>
                    </div>
            </div>
        </div>


        <div class="row xPadding5">
            <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3" id="odvtTmpImgForPdtCategoryPage">
                <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtComLines') ?> </label>
            </div>
            <div class="col-xs-12 col-sm-3 col-md-6 col-lg-6" id="">
                    <div class="input-group">
                        <input type="text" id="oetCgyPdtComLinesCode" class="form-control xCNHide" name="oetCgyPdtComLinesCode" value="<?=$tFhnCmlCode?>" data-validate="<?= language('product/product/product', 'tFhnPdtComLines') ?>">
                        <input type="text" id="oetCgyPdtComLinesName" class="form-control" name="oetCgyPdtComLinesName" value="<?=$tFhnCmlName?>" readonly>
                        <span class="input-group-btn">
                            <button id="obFhnPdtComLinesBrows" type="button" class="btn xCNBtnBrowseAddOn">
                                <img src="<?php echo base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                            </button>
                        </span>
                    </div>
            </div>
        </div>


        <div class="row xPadding5">
            <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3" id="odvtTmpImgForPdtCategoryPage">
                <label id="" class="xCNLabelFrm"><span style="color:red">*</span> <?= language('product/product/product', 'tFhnPdtMod') ?></label>
            </div>
            <div class="col-xs-12 col-sm-3 col-md-6 col-lg-6" id="">
                        <input type="text" id="oetCgyPdtModelNo" class="form-control" name="oetCgyPdtModelNo" maxlength="30" value="<?=$tFhnModNo?>" data-validate="<?= language('product/product/product', 'tFhnPdtMod') ?>">
            </div>
        </div>

        <div class="row xPadding5">      
            <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3" id="odvtTmpImgForPdtCategoryPage">
                <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtGender') ?> </label>
            </div>
            <div class="col-xs-12 col-sm-3 col-md-6 col-lg-6" id="">
                    <select class="form-control" name="ocmCgyPdtGender" id="ocmCgyPdtGender" >
                        <option value="1" <?php if($nFhnGender=='1'){ echo 'selected'; } ?>><?= language('product/product/product', 'tFhnPdtGender1') ?></option>
                        <option value="2" <?php if($nFhnGender=='2'){ echo 'selected'; } ?>><?= language('product/product/product', 'tFhnPdtGender2') ?></option>
                        <option value="3" <?php if($nFhnGender=='3'){ echo 'selected'; } ?>><?= language('product/product/product', 'tFhnPdtGender3') ?></option>
                    </select>
            </div>
        </div>

  
     </div>
      <div class="col-xs-12 col-sm-3 col-md-3 col-lg-3 text-right" style="margin-bottom:10px;">
                          
                                <button id="obtPdtCategoryBack" class="btn " type="button" style="background-color: #D4D4D4; color: #000000;"><?= language('common/main/main', 'tCancel') ?></button>
                                <button id="obtPdtCategorySave" class="btn " type="button" style="background-color: rgb(23, 155, 253); color: white;"><?= language('common/main/main', 'tSave') ?></button>
      </div>
</div>
</form>



<?php include('script/jCategoryPageFrom.php');?>
