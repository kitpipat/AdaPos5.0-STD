<form id="ofmAddBranchProfile" class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data">
<div class="col-xs-12 col-sm-12 col-md-8 col-lg-8">
	<div class="row">
				<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">


                <div class="form-group">
                    <label class="xCNLabelFrm"><?php echo language('company/branch/branch','tBpfDateOpen');?></label>
                    <div class="input-group">
                        <input
                            type="text"
                            class="form-control xCNDatePicker2 xCNInputMaskDate text-center"
                            id="oetBpfDateOpen"
                            name="oetBpfDateOpen"
                            value="<?php echo @$dBpfDateOpen;?>"
                        >
                        <span class="input-group-btn">
                            <button id="obtBpfDateOpen" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="xCNLabelFrm"><span class="text-danger">*</span> <?php echo language('company/branch/branch','tBpfBchSizeTitle');?></label>
                    <select class="selectpicker form-control" id="ocmBpfBchSize" name="ocmBpfBchSize" value="<?php echo @$tBpfBchSize;?>">
                        <option value="" <?php echo (@$tBpfBchSize == '')? " selected" : "";?>><?php echo language('company/branch/branch', 'tBpfBchSizeSelect');?></option>
                        <option value="XS" <?php echo (@$tBpfBchSize == 'XS')? " selected" : "";?>>
                            <?php echo language('company/branch/branch', 'tBpfBchSize1');?>
                        </option>
                        <option value="S"<?php echo (@$tBpfBchSize == 'S')? " selected" : "";?>>
                            <?php echo language('company/branch/branch', 'tBpfBchSize2');?>
                        </option>
                        <option value="M"<?php echo (@$tBpfBchSize == 'M')? " selected" : "";?>>
                            <?php echo language('company/branch/branch', 'tBpfBchSize3');?>
                        </option>
                        <option value="L"<?php echo (@$tBpfBchSize == 'L')? " selected" : "";?>>
                            <?php echo language('company/branch/branch', 'tBpfBchSize4');?>
                        </option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="xCNLabelFrm">
                    <span class="text-danger">*</span> <?php echo language('company/branch/branch','tBpfDJCode');?>
                    </label>
                    <input
                            type="text"
                            class="form-control"
                            maxlength="10"
                            id="oetBpfDJCode"
                            name="oetBpfDJCode"
                            autocomplete="off"
                            placeholder="<?php echo language('company/branch/branch','tBpfDJCode');?>"
                            data-validate-required ="<?php echo language('company/branch/branch','tSHPValiBranchName')?>"
                            value="<?php echo @$tBpfDJCode?>"
                        >
                    </div>


                    <div class="form-group">
                    <label class="xCNLabelFrm"><?php echo language('company/branch/branch','tBpfM1Code');?></label>
                    <div class="input-group">
                        <input type="text" class="form-control xCNHide" id="oetBpfM1Code" name="oetBpfM1Code" value="<?php echo @$tBpfM1Code; ?>">
                        <input type="text" class="form-control xWPointerEventNone" id="oetBpfM1Name" name="oetBpfM1Name" value="<?php echo @$tBpfM1Name; ?>" readonly>
                        <span class="input-group-btn">
                            <button id="obtBchBrowseM1"  type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="xCNLabelFrm"><?php echo language('company/branch/branch','tBpfMdjCode');?></label>
                    <div class="input-group">
                        <input type="text" class="form-control xCNHide" id="oetBpfMdjCode" name="oetBpfMdjCode" value="<?php echo @$tBpfMdjCode; ?>">
                        <input type="text" class="form-control xWPointerEventNone" id="oetBpfMdjName" name="oetBpfMdjName" value="<?php echo @$tBpfMdjName; ?>" readonly>
                        <span class="input-group-btn">
                            <button id="obtBchBrowseMdj"  type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="xCNLabelFrm"><?php echo language('company/branch/branch','tBpfFstVolumn')?></label>
                    <input type="text" class="form-control text-right xCNInputNumericWithoutDecimal" maxlength="14" id="oetBpfFstVolumn" name="oetBpfFstVolumn" placeholder="0.00" value="<?=str_replace(",","",number_format($cBpfFstVolumn,FCNxHGetOptionDecimalShow()));?>"  >
                </div>
			

                <div class="form-group">
                    <label class="xCNLabelFrm">
                       <?php echo language('company/branch/branch','tBpfGldShop');?>
                    </label>
                    <input
                        type="text"
                        class="form-control"
                        maxlength="50"
                        id="oetBpfGldShop"
                        name="oetBpfGldShop"
                        autocomplete="off"
                        placeholder="<?php echo language('company/branch/branch','tBpfGldShop');?>"
                        value="<?php echo @$tBpfGldShop?>"
                        >
                    </div>


        </div>
</div>
</form>
<script>
        $('.xCNDatePicker2').datepicker({
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayHighlight: true
        });

</script>