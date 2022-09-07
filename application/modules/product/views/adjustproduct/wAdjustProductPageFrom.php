<?php
    if(FCNbGetPdtFasionEnabled()){ //ถ้าเป็นแพคเกจสินค้าแฟชั่น
        $tPdtforSystemDataTable  = "5";
    }else{
        $tPdtforSystemDataTable  = "1";
    }
?>
<style>
.xPadding30 {
    padding-left: 30px;
    padding-right: 30px;
    padding-bottom: 30px;
}
.xPaddingTop15 {
    padding-top: 15px;
}
.xPaddingTop25 {
    padding-top: 25px;
}
</style>
<div class="row">
<form  action="javascript:void(0)" method="post" enctype="multipart/form-data" id="ofmAdjustProduct">
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 xPadding30">
    <input type="hidden"  name="ohdCheckedAll" id="ohdCheckedAll" value="1" >
    <input type="hidden"  name="ohdCheckedRowCout" id="ohdCheckedRowCout" value="0" >
        <div class="xCNTabCondition"><label class="xCNTabConditionHeader xCNLabelFrm"><h3><?= language('product/product/product','tAdjPdtCondition')?></h3></label>
                     
                        <div class="row xPaddingTop30" >

                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtTable')?></label>
                                    <!-- <div class="input-group"> -->
                                        <select class="selectpicker form-control" name="ocmAJPSelectTable" id="ocmAJPSelectTable">
                                            <option value="TCNMPdt"><?= language('product/product/product','tAdjPdtLevel1')?></option>
                                            <option value="TCNMPdtPackSize"><?= language('product/product/product','tAdjPdtLevel2')?></option>
                                            <option value="TCNMPdtBar"><?= language('product/product/product','tAdjPdtLevel3')?></option>
                                            <option value="TFHMPdtColorSize" <?php if($tPdtforSystemDataTable=='5'){ echo 'selected'; } ?>><?= language('product/product/product','tAdjPdtLevel4')?></option>
                                        </select>
                                    <!-- </div> -->
                                </div>
                            </div>

                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtField')?></label>
                                    <select class="selectpicker form-control" name="ocmAJPSelectField" id="ocmAJPSelectField"></select>
                                </div>
                            </div>

                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                                <div class="form-group">
                                    <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtValue')?></label>
                                    <select class="selectpicker form-control" name="ocmAJPSelectValue" id="ocmAJPSelectValue"></select>
                                </div>
                            </div>

                        </div>
                       
         </div>


         <div class="row xPaddingTop15">

                <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtFilAgency')?></label>
                        <div class="input-group">
                            <input class="form-control xCNHide" id="oetAJPAgnCode" name="oetAJPAgnCode" value="<?=$this->session->userdata('tSesUsrAgnCode')?>" >
                            <input
                                class="form-control xWPointerEventNone"
                                type="text"
                                id="oetAJPAgnName"
                                name="oetAJPAgnName"
                                value="<?=$this->session->userdata('tSesUsrAgnName')?>"
                                placeholder="<?= language('product/product/product','tAdjPdtFilAgency')?>"
                                readonly
                            >
                            <span class="input-group-btn">
                                <button id="obtAJPBrowsAgn" type="button" class="btn xCNBtnBrowseAddOn" <?php if($this->session->userdata('tSesUsrAgnName')!=''){ echo 'disabled'; } ?>><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>
                <?php 
                if(!FCNbUsrIsAgnLevel() && $this->session->userdata('tSesUsrLevel')!='HQ'){
                    $tBchCode       = $this->session->userdata("tSesUsrBchCodeDefault");
                    $tBchName       = $this->session->userdata("tSesUsrBchNameDefault");
                    }else{
                    $tBchCode       = '';
                    $tBchName       = '';
                }
                ?>
                <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtFilBranch')?></label>
                        <div class="input-group">
                            <input class="form-control xCNHide" id="oetAJPBchCode" name="oetAJPBchCode" value="<?=$tBchCode?>" >
                            <input
                                class="form-control xWPointerEventNone"
                                type="text"
                                id="oetAJPBchName"
                                name="oetAJPBchName"
                                value="<?=$tBchName?>"
                                placeholder="<?= language('product/product/product','tAdjPdtFilBranch')?>"
                                readonly
                            >
                            <span class="input-group-btn">
                                <button id="obtAJPBrowsBch" type="button" class="btn xCNBtnBrowseAddOn" ><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtFilFrom')?></label>
                        <div class="input-group">
                            <input class="form-control xCNHide" id="oetAJPPdtCodeFrom" name="oetAJPPdtCodeFrom" >
                            <input
                                class="form-control xWPointerEventNone"
                                type="text"
                                id="oetAJPPdtNameFrom"
                                name="oetAJPPdtNameFrom"
                                placeholder="<?= language('product/product/product','tAdjPdtFilFrom')?>"
                                readonly
                            >
                            <span class="input-group-btn">
                                <button id="obtAJPBrowsPdtFrom" type="button" class="btn xCNBtnBrowseAddOn" ><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtFilTo')?></label>
                        <div class="input-group">
                            <input class="form-control xCNHide" id="oetAJPPdtCodeTo" name="oetAJPPdtCodeTo" >
                            <input
                                class="form-control xWPointerEventNone"
                                type="text"
                                id="oetAJPPdtNameTo"
                                name="oetAJPPdtNameTo"
                                placeholder="<?= language('product/product/product','tAdjPdtFilTo')?>"
                                readonly
                            >
                            <span class="input-group-btn">
                                <button id="obtAJPBrowsPdtTo" type="button" class="btn xCNBtnBrowseAddOn" ><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>
                

                <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtFilGroup')?></label>
                        <div class="input-group">
                            <input class="form-control xCNHide" id="oetAJPPgpCode" name="oetAJPPgpCode" >
                            <input
                                class="form-control xWPointerEventNone"
                                type="text"
                                id="oetAJPPgpName"
                                name="oetAJPPgpName"
                                placeholder="<?= language('product/product/product','tAdjPdtFilGroup')?>"
                                readonly
                            >
                            <span class="input-group-btn">
                                <button id="obtAJPBrowsPgp" type="button" class="btn xCNBtnBrowseAddOn" ><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtFilBrand')?></label>
                        <div class="input-group">
                            <input class="form-control xCNHide" id="oetAJPPbnCode" name="oetAJPPbnCode" >
                            <input
                                class="form-control xWPointerEventNone"
                                type="text"
                                id="oetAJPPbnName"
                                name="oetAJPPbnName"
                                placeholder="<?= language('product/product/product','tAdjPdtFilBrand')?>"
                                readonly
                            >
                            <span class="input-group-btn">
                                <button id="obtAJPBrowsPbn" type="button" class="btn xCNBtnBrowseAddOn" ><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>


                <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtFilModel')?></label>
                        <div class="input-group">
                            <input class="form-control xCNHide" id="oetAJPPmoCode" name="oetAJPPmoCode" >
                            <input
                                class="form-control xWPointerEventNone"
                                type="text"
                                id="oetAJPPmoName"
                                name="oetAJPPmoName"
                                placeholder="<?= language('product/product/product','tAdjPdtFilModel')?>"
                                readonly
                            >
                            <span class="input-group-btn">
                                <button id="obtAJPBrowsPmo" type="button" class="btn xCNBtnBrowseAddOn" ><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtFilType')?></label>
                        <div class="input-group">
                            <input class="form-control xCNHide" id="oetAJPPtyCode" name="oetAJPPtyCode" >
                            <input
                                class="form-control xWPointerEventNone"
                                type="text"
                                id="oetAJPPtyName"
                                name="oetAJPPtyName"
                                placeholder="<?= language('product/product/product','tAdjPdtFilType')?>"
                                readonly
                            >
                            <span class="input-group-btn">
                                <button id="obtAJPBrowsPty" type="button" class="btn xCNBtnBrowseAddOn" ><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>


                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xFashionHide">
                    <div class="form-group">
                    <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtDepart') ?> </label>
                        <div class="input-group">
                            <input type="text" id="oetFhnPdtDepartCode" class="form-control xCNHide" name="oetFhnPdtDepartCode"   >
                            <input type="text" id="oetFhnPdtDepartName" class="form-control" name="oetFhnPdtDepartName" placeholder="<?= language('product/product/product', 'tFhnPdtDepart') ?>"  readonly> 
                            <span class="input-group-btn">
                                <button id="obFhnPdtDepartBrows" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xFashionHide">
                    <div class="form-group">
                    <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtClass') ?> </label>
                        <div class="input-group">
                            <input type="text" id="oetFhnPdtClassCode" class="form-control xCNHide" name="oetFhnPdtClassCode"   >
                            <input type="text" id="oetFhnPdtClassName" class="form-control" name="oetFhnPdtClassName" placeholder="<?= language('product/product/product', 'tFhnPdtClass') ?>"  readonly> 
                            <span class="input-group-btn">
                                <button id="obFhnPdtClassBrows" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xFashionHide">
                    <div class="form-group">
                    <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtSubClass') ?> </label>
                        <div class="input-group">
                            <input type="text" id="oetFhnPdtSubClassCode" class="form-control xCNHide" name="oetFhnPdtSubClassCode"   >
                            <input type="text" id="oetFhnPdtSubClassName" class="form-control" name="oetFhnPdtSubClassName" placeholder="<?= language('product/product/product', 'tFhnPdtSubClass') ?>"  readonly> 
                            <span class="input-group-btn">
                                <button id="obFhnPdtSubClassBrows" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xFashionHide">
                    <div class="form-group">
                    <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtGroup') ?> </label>
                        <div class="input-group">
                            <input type="text" id="oetFhnPdtGroupCode" class="form-control xCNHide" name="oetFhnPdtGroupCode"   >
                            <input type="text" id="oetFhnPdtGroupName" class="form-control" name="oetFhnPdtGroupName" placeholder="<?= language('product/product/product', 'tFhnPdtGroup') ?>"  readonly> 
                            <span class="input-group-btn">
                                <button id="obFhnPdtGroupBrows" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xFashionHide">
                    <div class="form-group">
                    <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtComLines') ?> </label>
                        <div class="input-group">
                            <input type="text" id="oetFhnPdtComLinesCode" class="form-control xCNHide" name="oetFhnPdtComLinesCode"   >
                            <input type="text" id="oetFhnPdtComLinesName" class="form-control" name="oetFhnPdtComLinesName" placeholder="<?= language('product/product/product', 'tFhnPdtComLines') ?>"  readonly> 
                            <span class="input-group-btn">
                                <button id="obFhnPdtComLinesBrows" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

          

                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xFashionHide">
                    <div class="form-group">
                    <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtDataTableSeason') ?> </label>
                        <div class="input-group">
                            <input type="text" id="oetFhnPdtSeasonCode" class="form-control xCNHide" name="oetFhnPdtSeasonCode"   >
                            <input type="text" id="oetFhnPdtSeasonName" class="form-control" name="oetFhnPdtSeasonName" placeholder="<?= language('product/product/product', 'tFhnPdtDataTableSeason') ?>"  readonly> 
                            <span class="input-group-btn">
                                <button id="obFhnPdtSeasonBrows" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xFashionHide">
                    <div class="form-group">
                    <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtDataTableFabric') ?> </label>
                        <div class="input-group">
                            <input type="text" id="oetFhnPdtFabricCode" class="form-control xCNHide" name="oetFhnPdtFabricCode"   >
                            <input type="text" id="oetFhnPdtFabricName" class="form-control" name="oetFhnPdtFabricName" placeholder="<?= language('product/product/product', 'tFhnPdtDataTableFabric') ?>"  readonly> 
                            <span class="input-group-btn">
                                <button id="obFhnPdtFabricBrows" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xFashionHide">
                    <div class="form-group">
                    <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtDataTableSize') ?> </label>
                        <div class="input-group">
                            <input type="text" id="oetFhnPdtSizeCode" class="form-control xCNHide" name="oetFhnPdtSizeCode"   >
                            <input type="text" id="oetFhnPdtSizeName" class="form-control" name="oetFhnPdtSizeName" placeholder="<?= language('product/product/product', 'tFhnPdtDataTableSize') ?>"  readonly> 
                            <span class="input-group-btn">
                                <button id="obFhnPdtSizeBrows" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xFashionHide">
                    <div class="form-group">
                    <label id="" class="xCNLabelFrm"><?= language('product/product/product', 'tFhnPdtDataTableColor') ?> </label>
                        <div class="input-group">
                            <input type="text" id="oetFhnPdtColorCode" class="form-control xCNHide" name="oetFhnPdtColorCode"   >
                            <input type="text" id="oetFhnPdtColorName" class="form-control" name="oetFhnPdtColorName" placeholder="<?= language('product/product/product', 'tFhnPdtDataTableColor') ?>"  readonly> 
                            <span class="input-group-btn">
                                <button id="obFhnPdtColorBrows" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                            <div class="form-group">
                                <label class="xCNLabelFrm"><?= language('product/product/product','tAdjPdtFilStaAlwHQ')?></label>
                                <select class="selectpicker form-control" name="ocmAJPStaAlwPoHQ" id="ocmAJPStaAlwPoHQ">
                                    <option value=""><?= language('product/product/product','tAdjPdtFilStaAlwHQ1')?></option>
                                    <option value="1"><?= language('product/product/product','tAdjPdtFilStaAlwHQ2')?></option>
                                    <option value="2"><?= language('product/product/product','tAdjPdtFilStaAlwHQ3')?></option>
                                </select>
                            </div>
                </div> -->


                <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2 xPaddingTop25" >
                <button  class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button" onclick="JSxClearConditionAll()"> <?= language('product/product/product','tAdjPdtClearFilter')?></button>
                <button id="obtMainAdjustProductFilter" type="button" class="btn btn xCNBTNPrimery xCNBTNPrimery2Btn"> <?= language('product/product/product','tAdjPdtFilter')?></button>
                </div>
         </div>

        <hr>

        <div class="row xPaddingTop15" id="odvAJPDataTable">
                    
        </div>  


    </div>
</form>
</div>
<?php include "script/jAdjustProductPageFrom.php"; ?>
