<?php 
    $tBchBrowseInputClass = 'col-lg-4 col-sm-4 col-md-4 col-xs-12';
    $tInvBrowseInputClass = 'col-lg-4 col-sm-4 col-md-4 col-xs-12';
    $tWahBrowseInputClass = 'col-lg-4 col-sm-4 col-md-4 col-xs-12';
    $nFilterPdtType = '1' ;
?>

<div class="">
	<div class="row">
        <div class="panel-body" style="padding-top:20px !important;">
            <div class="col-lg-12 col-sm-12 col-md-12 col-xs-12">
                <div id="odvSetionMovement">
                    <div class="row">
                        <div class="col-lg-12 col-sm-12 col-md-12 col-xs-12">
                            <!-- กลุ่ม Browse ข้อมูล -->
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-8 col-lg-9" >
                                    <div class="row">
                                        <!-- Browse สาขา -->
                                        <div class="col-lg-3 col-sm-4 col-md-4 col-xs-12">
                                            <?php 
                                                $tBCHCode = $this->session->userdata("tSesUsrBchCodeDefault");
                                                $tBCHName = $this->session->userdata("tSesUsrBchNameDefault");
                                            ?>
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type='text' class='form-control xCNHide xWRptAllInput' id='oetInvBchStaSelectAll' name='oetInvBchStaSelectAll' value=<?=$tBCHCode?>>
                                                    <input type='text' class='form-control xCNHide xWRptAllInput' id='oetInvBchCodeSelect'   name='oetInvBchCodeSelect' value=<?=$tBCHCode?>>
                                                    <input type='text' class='form-control xWPointerEventNone xWRptAllInput' id='oetInvBchNameSelect' name='oetInvBchNameSelect' placeholder="<?= language('movement/movement/movement','tMMTListBanch')?>" autocomplete="off" readonly value='<?=$tBCHName?>'>
                                                    <span class="input-group-btn">
                                                        
                                                        <?php 
                                                            if($this->session->userdata("tSesUsrLevel") == "HQ"){
                                                                $tDisabled = "";
                                                            }else{
                                                                $nCountBch = $this->session->userdata("nSesUsrBchCount");
                                                                if($nCountBch == 1){
                                                                    $tDisabled = "disabled";
                                                                }else{
                                                                    $tDisabled = "";
                                                                }
                                                            }
                                                        ?>
                                                        <button id="obtInvMultiBrowseBranch" type="button" <?=$tDisabled?> class="btn xCNBtnDateTime">      
                                                            <img  src="<?=base_url().'application/modules/common/assets/images/icons/find-24.png'?>">
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- End Browse สาขา -->
                                        
                                        <!-- Browse คลังสินค้า -->
                                        <div class="col-lg-3 col-sm-4 col-md-4 col-xs-12">
                                            <?php 
                                                $tWahCode = $this->session->userdata("tSesUsrWahCode");
                                                $tWahName = $this->session->userdata("tSesUsrWahName");
                                            ?>
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type='text' class='form-control xCNHide xWRptAllInput' id='oetInvWahStaSelectAll' name='oetInvWahStaSelectAll' value="<?=$tWahCode?>">
                                                    <input type='text' class='form-control xCNHide xWRptAllInput' id='oetInvWahCodeSelect'   name='oetInvWahCodeSelect' value="<?=$tWahCode?>">
                                                    <input type='text' class='form-control xWPointerEventNone xWRptAllInput' id='oetInvWahNameSelect' name='oetInvWahNameSelect' value="<?=$tWahName?>" placeholder="<?= language('movement/movement/movement','tMMTListWaHouse')?>" autocomplete="off" readonly>
                                                    <span class="input-group-btn">
                                                        <button id="obtInvMultiBrowseWaHouse" type="button" class="btn xCNBtnDateTime">
                                                            <img  src="<?=base_url().'application/modules/common/assets/images/icons/find-24.png'?>">
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- End Browse คลังสินค้า -->

                                        <div class="col-lg-3 col-sm-4 col-md-4 col-xs-12">
                                            <div class="form-group">
                                                <select class="selectpicker form-control" id="ocmSearchProductType" name="ocmSearchProductType" maxlength="1" >
                                                    <option class="" value="1"    <?php if(@$nFilterPdtType=='1'){ echo 'selected'; } ?>><?=language('product/product/product','tPdtSreachType1')?></option>
                                                    <option class="" value="2"    <?php if(@$nFilterPdtType=='2'){ echo 'selected'; } ?>><?=language('product/product/product','tPdtSreachType2')?></option>
                                                    <option class="" value="3"    <?php if(@$nFilterPdtType=='3'){ echo 'selected'; } ?>><?=language('product/product/product','tPdtSreachType3')?></option>
                                                    <option class="" value="4"    <?php if(@$nFilterPdtType=='5'){ echo 'selected'; } ?>><?=language('product/product/product','tPdtSreachType5')?></option>
                                                    <option class="" value="5"    <?php if(@$nFilterPdtType=='6'){ echo 'selected'; } ?>><?=language('product/product/product','tPdtSreachType6')?></option>
                                                    <option class="" value="6"    <?php if(@$nFilterPdtType=='7'){ echo 'selected'; } ?>><?=language('product/product/product','tPdtSreachType7')?></option>
                                                </select>
                                            </div>
                                        </div>   

                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type='text' class='form-control xWRptAllInput' id='oetInvPdtNameSelect' name='oetInvPdtNameSelect' placeholder="รหัสสินค้า" onkeypress="Javascript:if(event.keyCode==13) JSxInvDataTable(1);" autocomplete="off">
                                                <span class="input-group-btn">
                                                    <button class="btn xCNBtnBrowseAddOn xCNApvOrCanCelDisabled" onclick="JSxInvDataTable(1);"  type="button">
                                                        <img src="<?= base_url() . '/application/modules/common/assets/images/icons/search-24.png' ?>">
                                                    </button>
                                                </span>
                                                <span class="input-group-btn">
                                                    <button class="btn xCNBtnBrowseAddOn xCNApvOrCanCelDisabled" id="obtInvMultiBrowseProduct" type="button">
                                                        <img src="<?= base_url() . '/application/modules/common/assets/images/icons/find-24.png' ?>">
                                                    </button>
                                                </span>
                                                <input name="oetTAXABBTypeDocuement" id="oetTAXABBTypeDocuement" type="hidden">
                                            </div>
                                        </div>                                

                                    </div>
                                </div>
                                <div class="col-xs-12 col-sm-12 col-md-4 col-lg-3">                                                           
                                    <!-- ปุ่มกรองข้อมูล -->
                                    <div class="form-group">
                                        <div id="odvBtnMovement" style="text-align: right;">
                                            <button  type="button" id="obtInvSearchSubmit" class="btn xCNBTNPrimery" _onclick="JSxInvSearchData()"><?= language('movement/movement/movement','tMMTListSearch')?>	</button>	
                                        </div>
                                    </div>
                                    <!-- End ปุ่มกรองข้อมูล -->
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 col-md-12 col-lg-12 col-sm-12">
                            <section id="odvInvContentTable"></section>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php include "script/jInv.php"; ?>
<script src="<?= base_url('application/modules/common/assets/js/jquery.mask.js')?>"></script>
<script src="<?= base_url('application/modules/common/assets/src/jFormValidate.js')?>"></script>