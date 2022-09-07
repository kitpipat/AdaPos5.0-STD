<?php
if($aResult['rtCode'] == "1"){
    $tBnkCode       	= $aResult['raItems']['rtBnkCode'];
	$tBnkName       	= $aResult['raItems']['rtBnkName'];
    $tBnkRmk               = $aResult['raItems']['rtBnkRmk'];
    $tImgObj           = $aResult['raItems']['rtFTImgObj'];

    //route
	$tRoute         	= "bankeventedit";
	//Event Control
	if(isset($aAlwEventBank)){
		if($aAlwEventBank['tAutStaFull'] == 1 || $aAlwEventBank['tAutStaEdit'] == 1){
			$nAutStaEdit = 1;
		}else{
			$nAutStaEdit = 0;
		}
	}else{
		$nAutStaEdit = 0;
	}	
}else{
    $tBnkCode       	= "";
	$tBnkName       	= "";
    $tBnkRmk          = "";
    $tImgObj            = "";

    //route
	$tRoute         = "bankEventUpdate";
	$nAutStaEdit = 0; //Event Control
}
?>

                    <form class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data" id="ofmAddBank">
                        <button style="display:none" type="submit" id="obtSubmitBank" onclick="JSnBankAddEdit('<?php echo $tRoute ?>')"></button>
                        <div class="panel-body" style="padding-top:20px !important;">
                        <div class="row">
                        <div class="col-xs-4 col-sm-4">
                        <div class="upload-img" id="oImgUpload">
                            <?php
                                if(isset($tImgObjAll) && !empty($tImgObjAll)){
                                    $tFullPatch = './application/modules/'.$tImgObjAll;
                                    if (file_exists($tFullPatch)){
                                        $tPatchImg = base_url().'/application/modules/'.$tImgObjAll;
                                    }else{
                                        $tPatchImg = base_url().'application/modules/common/assets/images/200x200.png';
                                    }
                                }else{
                                    $tPatchImg = base_url().'application/modules/common/assets/images/200x200.png';
                                }

                                // Check Image Name
                                if(isset($tImgName) && !empty($tImgName)){
                                    $tImageNameBnk   = $tImgName;
                                }else{
                                    $tImageNameBnk   = '';
                                }
                            ?>      
                            <img id="oimImgMasterBank" class="img-responsive xCNImgCenter" style="width: 100%;" id="" src="<?php echo $tPatchImg;?>">
                        </div>
                        <div class="xCNUplodeImage">	
                 
                            <input type="text" class="xCNHide" id="oetImgInputBankOld"  name="oetImgInputBankOld" value="<?php echo @$tImageNameBnk;?>">
                            <input type="text" class="xCNHide" id="oetImgInputBank" name="oetImgInputBank" value="<?php echo @$tImageNameBnk;?>">
                            <button type="button" class="btn xCNBTNDefult" onclick="JSvImageCallTempNEW('','','Bank')">  <i class="fa fa-picture-o xCNImgButton"></i> <?php echo language('common/main/main','tSelectPic')?></button>
                        </div>
                        
                        <div class="col-xs-12 col-sm-12" style="margin-top:10%;">
                          
                        </div>
                    </div>

                            <div class="col-xs-12 col-md-8 col-lg-8">
                              
                                    <div class="form-group">
                                        <div class="validate-input">
                                        <label class="xCNLabelFrm"><span class="text-danger">*</span><?php echo language('bank/bank/bank','tBNKTBCode')?></label>
                                        <input type="hidden" class="form-control" maxlength="5" id="oetBnkCodeOld" name="oetBnkCodeOld" placeholder="รหัสธนาคาร" autocomplete="off" value="<?php echo $tBnkCode ?>" data-validate-required="<?php echo language('bank/bank/bank','tBNKValidCode')?> ">
                                            <input type="text" class="form-control" maxlength="5" id="oetBnkCode" name="oetBnkCode" placeholder="<?php echo language('bank/bank/bank','tBNKTBCode')?>" autocomplete="off" value="<?php echo $tBnkCode ?>" data-validate-required="<?php echo language('bank/bank/bank','tBNKValidCode')?> ">
                                        </div>
                                    </div>
                                    
									<div class="form-group">
                                        <div class="validate-input">
                                        <label class="xCNLabelFrm"><span class="text-danger">*</span><?php echo language('bank/bank/bank','tBNKTBName')?></label>
                                            <input type="text" class="form-control" maxlength="200" id="oetBnkName" name="oetBnkName" placeholder="<?php echo language('bank/bank/bank','tBNKTBName')?>" autocomplete="off" value="<?php echo $tBnkName ?>" data-validate-required="<?php echo language('bank/bank/bank','tBNKValidName')?> ">
                                        </div>
                                    </div>
                                    
									
                                    
                                    <div class="form-group">
                                        <label class="xCNLabelFrm"><?php echo language('bank/bank/bank','tBNKRemark')?></label>
                                        <textarea class="form-control" maxlength="100" rows="4" id="otaBnkRmk" name="otaBnkRmk" ><?php echo $tBnkRmk ?></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
               

<script type="text/javascript">
    $('.selection-2').selectpicker();



    $('.selectpicker').selectpicker();
$(".selection-2").select2({
	minimumResultsForSearch: 20,
	dropdownParent: $('#dropDownSelect1')
});

$('.xWTooltipsBT').tooltip({'placement': 'bottom'});
$('[data-toggle="tooltip"]').tooltip({'placement': 'top'});


</script>
