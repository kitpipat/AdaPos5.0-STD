<input type="hidden" id="oetPDSStaBrowse" value="<?php echo $nCPDSBrowseType;?>">
<input type="hidden" id="oetPDSCallBackOption" value="<?php echo $tCPDSBrowseOption;?>">

<?php if(isset($nCPDSBrowseType) && $nCPDSBrowseType == 0): ?>
	<div id="odvPDSMainMenu" class="main-menu">
		<div class="xCNMrgNavMenu">
			<div class="row xCNavRow" style="width:inherit;">
				<div class="col-xs-12 col-sm-6 col-md-6 col-lg-6">
					<ol id="oliMenuNav" class="breadcrumb">
						<?php FCNxHADDfavorite('settingpdtscale/0/0');?> 
                        <li id="oliPDSTitle" class="xCNLinkClick" style="cursor:pointer" onclick="JSvPDSCallPageList('')"><?php echo language('product/settingpdtscale/settingpdtscale','tPDSTitle')?></li>
						<li id="oliPDSTitleAdd" class="active"><a><?php echo language('product/settingpdtscale/settingpdtscale','tPDSTitleAdd')?></a></li>
						<li id="oliPDSTitleEdit" class="active"><a><?php echo language('product/settingpdtscale/settingpdtscale','tPDSTitleEdit')?></a></li>
					</ol>
				</div>
				<div class="col-xs-12 col-sm-6 col-md-6 col-lg-6 text-right p-r-0">
					<div class="demo-button xCNBtngroup" style="width:100%;">
						<div id="odvBtnPDSInfo">
							<?php if($aAlwEvent['tAutStaFull'] == 1 || $aAlwEvent['tAutStaAdd'] == 1) : ?>
								<button id="obtPDSAdd" class="xCNBTNPrimeryPlus" type="button" onclick="JSvPDSCallPageAdd()">+</button>
							<?php endif; ?>
						</div>
						<div id="odvBtnAddEdit">
							<div class="demo-button xCNBtngroup" style="width:100%;">
								<button onclick="JSvPDSCallPageList()" class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"> <?php echo language('common/main/main', 'tBack')?></button>
								<?php if($aAlwEvent['tAutStaFull'] == 1 || ($aAlwEvent['tAutStaAdd'] == 1 || $aAlwEvent['tAutStaEdit'] == 1)):?>
									<div class="btn-group">
										<button type="submit" class="btn xWBtnGrpSaveLeft" onclick="$('#obtSubmitPDS').click()"> <?php echo language('common/main/main', 'tSave')?></button>
										<?php echo $vBtnSave?>
									</div>
								<?php endif;?>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="xCNMenuCump xCNPDSBrowseLine" id="odvMenuCump">&nbsp;</div>
	<div class="main-content">
        <div id="odvContentPagePDS" >
        </div>
    </div>
<?php else: ?>
	<div class="modal-header xCNModalHead">
        <div class="row">
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                <a id="oahPDSBrowseCallBack" onclick="JCNxBrowseData('<?php echo $tCPDSBrowseOption?>')" class="xWBtnPrevious xCNIconBack" style="float:left;">
                    <i class="fa fa-arrow-left xCNIcon"></i>	
                </a>
                <ol id="oliPDSNavBrowse" class="breadcrumb xCNMenuModalBrowse">
                    <li id="oliPDSBrowsePrevious" onclick="JCNxBrowseData('<?php echo $tCPDSBrowseOption?>')" class="xWBtnPrevious"><a><?php echo language('common/main/main','tShowData');?> : <?php echo language('product/settingpdtscale/settingpdtscale','tPDSTitle')?></a></li>
                    <li class="active"><a><?php echo language('product/settingpdtscale/settingpdtscale','tPDSTitleAdd')?></a></li>
                </ol>
            </div>
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                <div id="odvPDSBtnGroup" class="demo-button xCNBtngroup" style="width:100%;">
                    <button id="obtPDSBrowseSubmit" type="button" class="btn xCNBTNPrimery" onclick="$('#obtSubmitPDS').click()">
						<?php echo language('common/main/main', 'tSave');?>
					</button>
                </div>
            </div>
        </div>
    </div>
    <div id="odvModalBodyBrowse" class="modal-body xCNModalBodyAdd">
    </div>
<?php endif; ?>
<script src="<?php echo base_url('application/modules/settingconfig/assets/src/settingpdtscale/jPdtScale.js')?>"></script>