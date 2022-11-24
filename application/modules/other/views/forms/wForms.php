<input id="oetFrmStaBrowse" type="hidden" value="<?php echo $nFrmBrowseType?>">
<input id="oetFrmCallBackOption" type="hidden" value="<?php echo $tFrmBrowseOption?>">

<?php if(isset($nFrmBrowseType) && $nFrmBrowseType == 0) : ?>
	<div id="odvFrmMainMenu" class="main-menu">
		<div class="xCNMrgNavMenu">
			<div class="row xCNavRow" style="width:inherit;">
				<div class="col-xs-12 col-sm-8 col-md-8 col-lg-8">
					<ol id="oliMenuNav" class="breadcrumb">
						<?php FCNxHADDfavorite('forms/0/0');?> 
						<li id="oliFrmTitle" onclick="JSvCallPageFormsList()" style="cursor:pointer"><?php echo language('other/forms/forms','tFRMTitle')?></li>
						<li id="oliFrmTitleAdd" class="active"><a><?php echo language('other/forms/forms','tFRMTitleAdd')?></a></li>
						<li id="oliFrmTitleEdit" class="active"><a><?php echo language('other/forms/forms','tFRMTitleEdit')?></a></li>
					</ol>
				</div>
				<div class="col-xs-12 col-sm-4 col-md-4 col-lg-4 text-right p-r-0">
					<div id="odvBtnFrmInfo">
					<?php if($aAlwEventForms['tAutStaFull'] == 1 || ($aAlwEventForms['tAutStaAdd'] == 1 || $aAlwEventForms['tAutStaEdit'] == 1)) : ?>
						<button class="xCNBTNPrimeryPlus" type="submit" onclick="JSvCallPageFormsAdd()">+</button>
					<?php endif;?>
					</div>
					<div id="odvBtnFrmAddEdit">
						<button onclick="JSvCallPageFormsList()" class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"> <?php echo language('common/main/main', 'tBack')?></button>
						<?php if($aAlwEventForms['tAutStaFull'] == 1 || ($aAlwEventForms['tAutStaAdd'] == 1 || $aAlwEventForms['tAutStaEdit'] == 1)) : ?>
						<div class="btn-group">
							<button type="submit" class="btn xWBtnGrpSaveLeft" onclick="$('#obtSubmitForms').click()"> <?php echo language('common/main/main', 'tSave')?></button>
							<?php echo $vBtnSave?>
						</div>
					<?php endif;?>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="xCNMenuCump xCNFrmBrowseLine" id="odvMenuCump">
		&nbsp;
	</div>
	<div class="main-content">
		<div id="odvContentPageForms" class="panel panel-headline">
		</div>
	</div>
<?php else: ?>
    <div class="modal-header xCNModalHead">
        <div class="row">
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                <a onclick="JCNxBrowseData('<?php echo $tFrmBrowseOption?>')" class="xWBtnPrevious xCNIconBack" style="float:left;">
                    <i class="fa fa-arrow-left xCNIcon"></i>	
                </a>
                <ol id="oliPvnNavBrowse" class="breadcrumb xCNMenuModalBrowse">
                    <li class="xWBtnPrevious" onclick="JCNxBrowseData('<?php echo $tFrmBrowseOption?>')"><a><?php echo language('common/main/main','tShowData');?> : <?php echo  language('other/forms/forms','tFRMTitle')?></a></li>
                    <li class="active"><a><?php echo language('other/forms/forms','tFRMTitleAdd')?></a></li>
                </ol>
            </div>
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                <div id="odvPvnBtnGroup" class="demo-button xCNBtngroup" style="width:100%;">
                    <button type="button" class="btn xCNBTNPrimery" onclick="$('#obtSubmitForms').click()"><?php echo language('common/main/main', 'tSave')?></button>
                </div>
            </div>
        </div>
    </div>
    <div id="odvModalBodyBrowse" class="modal-body xCNModalBodyAdd">
    </div>
<?php endif;?>

<script src="<?php echo base_url('application/modules/other/assets/src/forms/jForms.js'); ?>"></script>
<script src="<?php echo base_url('application/modules/common/assets/js/jquery.mask.js')?>"></script>
<script src="<?php echo base_url('application/modules/common/assets/src/jFormValidate.js')?>"></script>