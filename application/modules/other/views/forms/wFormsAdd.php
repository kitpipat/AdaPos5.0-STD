<?php 
if($aResult['rtCode'] == 1){
    $tFrmCode   = $aResult['raItems']['rtRfuCode'];
    $tFrmName   = $aResult['raItems']['rtRfuName'];
    $tFrmRemark = $aResult['raItems']['rtRfuRemark'];
	$tRfsCode = $aResult['raItems']['rtRfsCode'];
	$tRfsName = $aResult['raItems']['rtRfsName'];
	$tRfsPath = $aResult['raItems']['rtRfsPath'];
	
	$tRfuFileName = $aResult['raItems']['rtRfuFileName'];
	$tRfsFileName = $aResult['raItems']['rtRfsFileName'];
	
	$tRfuPath = $aResult['raItems']['rtRfuPath'];
	
	$tRfuStaAlwEdit = $aResult['raItems']['rtRfuStaAlwEdit'];
	$tRfuStaUsrDef = $aResult['raItems']['rtRfuStaUsrDef'];
	$tRfuStaUse = $aResult['raItems']['rtRfuStaUse'];

	
	$tRoute     = "formsEventEdit";
	
	$tFrmAgnCode       = $aResult['raItems']['rtAgnCode'];
    $tFrmAgnName       = $aResult['raItems']['rtAgnName'];


}else{
    $tFrmCode   = "";
    $tFrmName   = "";
    $tFrmRemark = "";
	$tRfsCode = "";
	$tRfsName = "";
	$tRfsPath = "";

	$tRfuFileName = "";
	$tRfsFileName = "";
	$tRfuPath = "";

	$tRfuStaAlwEdit = "1";
	$tRfuStaUsrDef = "1";
	$tRfuStaUse = "1";

	$tRoute     = "formsEventAdd";
	

	$tFrmAgnCode       = $tSesAgnCode;
    $tFrmAgnName       = $tSesAgnName;
}
?>
<form class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data" autocorrect="off" autocapitalize="off" autocomplete="off" id="ofmAddForms">
	<button style="display:none" type="submit" id="obtSubmitForms" onclick="JSnAddEditForms('<?php echo $tRoute?>')"></button>
	<div class="panel-body"  style="padding-top:20px !important;">
	
		<div class="row">
			<div class="col-xs-12 col-md-6 col-lg-6">
				<label class="xCNLabelFrm"><span style="color:red">*</span><?= language('other/forms/forms','tFRMCode')?></label>
				<div id="odvFormsAutoGenCode" class="form-group">
					<div class="validate-input">
						<label class="fancy-checkbox">
							<input type="checkbox" id="ocbFormsAutoGenCode" name="ocbFormsAutoGenCode" checked="true" value="1">
							<span> <?php echo language('common/main/main', 'tGenerateAuto'); ?></span>
						</label>
					</div>
				</div>

				<div id="odvFormsCodeForm" class="form-group">
					<input type="hidden" id="ohdCheckDuplicateFrmCode" name="ohdCheckDuplicateFrmCode" value="1"> 
					<div class="validate-input">
						<input 
							type="text" 
							class="form-control xCNInputWithoutSpcNotThai xCNInputWithoutSingleQuote" 
							maxlength="5" 
							id="oetFrmCode" 
							name="oetFrmCode"
							data-is-created="<?php echo $tFrmCode; ?>"
							placeholder="<?php echo language('other/forms/forms','tFRMTBCode')?>";
							value="<?php echo $tFrmCode; ?>" 
							data-validate-required = "<?php echo language('other/forms/forms','tFRMValidCode')?>"
							data-validate-dublicateCode = "<?php echo language('other/forms/forms','tFRMValidCodeDup')?>"
						>
					</div>
				</div>
				
			</div>
		</div>

		<?php 
			if($tRoute == "formsEventAdd"){
				$tFrmAgnCode   = $tSesAgnCode;
				$tFrmAgnName   = $tSesAgnName;
				$tDisabled     = '';
				$tDisabledForms     = 'disabled';
				$tNameElmIDAgn = 'oimBrowseAgn';
			}else{
				$tFrmAgnCode    = $tFrmAgnCode;
				$tFrmAgnName    = $tFrmAgnName;
				$tDisabled      = 'disabled';
				$tDisabledForms     = '';
				$tNameElmIDAgn  = 'oimBrowseAgn';
			}
		?>

		<!-- เพิ่ม Browser AD  -->
		<div class="row">
			<div class="col-xs-12 col-md-6 col-lg-6">
				<div class="form-group ">
					<label class="xCNLabelFrm"></span><?php echo language('other/forms/forms','tFRMAgency')?></label>	
					<div class="input-group"><input class="form-control xCNHide" type="text" id="oetFrmAgnCode" name="oetFrmAgnCode" maxlength="5" value="<?php echo @$tFrmAgnCode;?>">
						<input type="text" class="form-control xWPointerEventNone" 
							id="oetFrmAgnName" 
							name="oetFrmAgnName" 
							maxlength="100" 
							placeholder ="<?php echo language('other/forms/forms','tFRMAgency');?>"
							data-validate-required="<?=language('other/forms/forms','tFRMValidAgnName')?>"

							value="<?php echo @$tFrmAgnName;?>" readonly>
						<span class="input-group-btn">
							<button id="<?=@$tNameElmIDAgn;?>" type="button" class="btn xCNBtnBrowseAddOn <?=@$tDisabled?>">
								<img src="<?php echo  base_url().'/application/modules/common/assets/images/icons/find-24.png'?>">
							</button>
						</span>
					</div>
				</div>	
					<!-- เพิ่ม Browser Format  -->
					<div class="form-group ">
							<label class="xCNLabelFrm"></span><?php echo language('other/forms/forms','tFRMDocument')?></label>	
							<input class="form-control xCNHide" type="text" id="oetFrmRfsPath" name="oetFrmRfsPath"  value="<?php echo @$tRfsPath;?>">
							<input type="text" class="form-control xCNHide" name="oetRfsFileName" id="oetRfsFileName" value="<?=$tRfsFileName?>"  readonly="">
							<div class="input-group"><input class="form-control xCNHide" type="text" id="oetFrmRfsCode" name="oetFrmRfsCode" maxlength="5" value="<?php echo @$tRfsCode;?>">
								<input type="text" class="form-control xWPointerEventNone" 
									id="oetFrmRfsName" 
									name="oetFrmRfsName" 
									maxlength="100" 
									placeholder ="<?php echo language('other/forms/forms','tFRMDocument');?>"
									data-validate-required="<?=language('other/forms/forms','tFRMValidFormsSTD')?>"
									value="<?php echo @$tRfsName;?>" readonly>
								<span class="input-group-btn">
									<button id="obtFrmBrowseFormat" type="button" class="btn xCNBtnBrowseAddOn <?=@$tDisabled?>">
										<img src="<?php echo  base_url().'/application/modules/common/assets/images/icons/find-24.png'?>">
									</button>
									<button id="obtEditStimuFormStd" type="button" class="btn xCNBtnBrowseAddOn " data-url="" disabled='true'>
										<img src="<?php echo  base_url().'/application/modules/common/assets/images/icons/edit.png'?>">
									</button>
								</span>
							</div>
						</div>
			</div>
		</div>

		<div class="row">
			<div class="col-xs-12 col-md-6 col-lg-6">
				<div class="form-group">
					<div class="validate-input">
						<label class="xCNLabelFrm"><span style="color:red">*</span><?php echo language('other/forms/forms','tFRMName')?></label>
						<input
							type="text"
							class="form-control"
							maxlength="200"
							id="oetFrmName"
							name="oetFrmName"
							placeholder="<?php echo language('other/forms/forms','tFRMName')?>"
							value="<?php echo $tFrmName?>"
							data-validate-required="<?php echo language('other/forms/forms','tFRMValidName')?>"
						>
					</div>
				</div>	
			
				<!-- <div class="form-group">
					<label for="exampleFormControlFile1">Example file input</label>
					<input type="file" class="form-control-file" id="exampleFormControlFile1">
				</div> -->

				<div class="input-group xWAdvItem change-file" >
				<input class="form-control xCNHide" type="text" id="oetRfuPath" name="oetRfuPath"  value="<?php echo @$tRfuPath;?>">
                <input type="text" class="form-control xWAdvFtuFile" name="oetRfuFileName" id="oetRfuFileName" value="<?=$tRfuFileName?>"  readonly="">
                <label class="input-group-btn">

                    <div class="btn xCNBtnPrimeryAddOn" style="font-size:18px;">
                        <input accesskey="" type="file" id="oetFrmRtuFile" class="xWAdvMedia" name="oetFrmRtuFile"  style="position: absolute;clip: rect(0px, 0px, 0px, 0px);" onchange="JSxFRMChangedFile(this, event)" > เลือกไฟล์                    </div>
						
						<button id="obtEditStimuFormSpc" type="button" class="btn xCNBtnBrowseAddOn "  data-url="" <?=$tDisabledForms?>>
							<img src="<?php echo  base_url().'/application/modules/common/assets/images/icons/edit.png'?>">
						</button>

				</label>
            	</div>

				<div class="form-group">
						<label class="xCNLabelFrm"><?= language('other/forms/forms','tFRMRemark')?></label>
						<textarea class="form-control" rows="4" maxlength="100" id="otaFrmRemark" name="oetFrmRemark"><?php echo $tFrmRemark?></textarea>

				</div>


				<!-- สถานะอนุณาตแก้ไขไฟล์    -->
				<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 row" style="display:none">
					<div class="form-group">
						<label class="fancy-checkbox">
							<?php
							if (isset($tRfuStaAlwEdit) && $tRfuStaAlwEdit == 1) {
								$tCheckedStaAlwEdit  = 'checked';
							} else {
								$tCheckedStaAlwEdit  = '';
							}
							?>
							<input type="checkbox" id="ocbRfuStaAlwEdit" name="ocbRfuStaAlwEdit" <?php echo $tCheckedStaAlwEdit; ?>>
							<span> <?php echo language('other/forms/forms', 'tRfuStaAlwEdit'); ?></span>
						</label>
					</div>
				</div>

				
				<!-- สถานะอนุณาตแก้ไขไฟล์    -->
				<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 row">
					<div class="form-group">
						<label class="fancy-checkbox">
							<?php
							if (isset($tRfuStaUsrDef) && $tRfuStaUsrDef == 1) {
								$tCheckedStaUsrDef  = 'checked';
							} else {
								$tCheckedStaUsrDef  = '';
							}
							?>
							<input type="checkbox" id="ocbRfuStaUsrDef" name="ocbRfuStaUsrDef" <?php echo $tCheckedStaUsrDef; ?>>
							<span> <?php echo language('other/forms/forms', 'tRfuStaUsrDef'); ?></span>
						</label>
					</div>
				</div>

				
				<!-- สถานะอนุณาตแก้ไขไฟล์    -->
				<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 row">
					<div class="form-group">
						<label class="fancy-checkbox">
							<?php
							if (isset($tRfuStaUse) && $tRfuStaUse == 1) {
								$tCheckedStaUse  = 'checked';
							} else {
								$tCheckedStaUse  = '';
							}
							?>
							<input type="checkbox" id="ocbRfuStaUse" name="ocbRfuStaUse" <?php echo $tCheckedStaUse; ?>>
							<span> <?php echo language('other/forms/forms', 'tRfuStaUse'); ?></span>
						</label>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<?php include "script/jFormsAdd.php"; ?>


<script>
	var tRouteLevel = $('#oetFrmCallBackOption').val();
	if(tRouteLevel == 'oASTBrowseFrmOption' || tRouteLevel == 'oAdjStkSumBrowseForms' || tRouteLevel == 'oAdjStkSubBrowseForms'){
		$(".selection-2[name=ocmRcnGroup]").val('008');
		$(".selection-2[name=ocmRcnGroup]").selectpicker('refresh');
	}
</script>