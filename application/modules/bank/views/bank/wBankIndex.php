<input id="oetBnkStaBrowse" type="hidden" value="<?=$nBrowseType?>">
<input id="oetBnkCallBackOption" type="hidden" value="<?=$tBrowseOption?>">

<?php if(isset($nBrowseType) && $nBrowseType == 0) : ?>
<div id="odvCpnMainMenu" class="main-menu clearfix">
	<div class="xCNMrgNavMenu">
		<div class="row xCNavRow" style="width:inherit;">
			<div class="col-xs-12 col-sm-8 col-md-8 col-lg-8">
				<ol id="oliMenuNav" class="breadcrumb">
					<?php FCNxHADDfavorite('bankindex/0/0');?> 
					<li id="oliBnkTitle" class="xCNLinkClick" style="cursor:pointer" onclick="JSvCallPageBankList()"><?= language('bank/bank/bank','tBNKTitle')?></li>
					<li id="oliBnkAdd" class="xCNLinkClick" style="cursor:pointer" onclick="JSvCallPageBankAddBank()"><?= language('bank/bank/bank','tBNKTitleAdd')?></li>
					<li id="oliBnkEdit" class="xCNLinkClick" style="cursor:pointer" onclick="JSvCallEditBnk()"><?= language('bank/bank/bank','tBNKTitleEdit')?></li>
				</ol>
			</div>
			
			<div class="col-xs-12 col-sm-4 col-md-4 col-lg-4 text-right p-r-0">
			<div id="odvBtnCmpEditInfo">
							<button onclick="JSvCallPageBankList()" id="obtBarBack" class="btn xCNBTNDefult xCNBTNDefult2Btn" type="submit"> <?= language('common/main/main', 'tBack')?></button>
							<?php if($aAlwEventBank['tAutStaFull'] == 1 || ($aAlwEventBank['tAutStaAdd'] == 1 || $aAlwEventBank['tAutStaEdit'] == 1)) : ?>
							<div class="btn-group">
								<button onclick="$('#obtSubmitBank').click();" class="btn btn-default xWBtnGrpSaveLeft" type="submit"> <?= language('common/main/main', 'tSave')?></button>
								<?=$vBtnSave?>
							</div>
							<?php endif; ?>
				</div>
				<div class="demo-button xCNBtngroup" style="width:100%;">
					<div id="odvBtnAgnInfo">
						<?php if($aAlwEventBank['tAutStaFull'] == 1 || $aAlwEventBank['tAutStaAdd'] == 1) : ?>
							<button id="obtCpnAdd" class="xCNBTNPrimeryPlus" type="button" onclick="JSvCallPageBankAddBank()">+</button>
						<?php endif; ?>
					</div>
			
				</div>
			</div>
		</div>
	</div>
</div>
<div class="xCNMenuCump" id="odvMenuCump">
	&nbsp;
</div>
<div class="main-content">
	<div id="odvContentPageBank" class="panel panel-headline">
	</div>
</div>
<?php else: ?>
	<div class="modal-header xCNModalHead">
        <div class="row">
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                <a onclick="JCNxBrowseData('<?=$tBrowseOption?>')" class="xWBtnPrevious xCNIconBack" style="float:left;">
                    <i class="fa fa-arrow-left xCNIcon"></i>	
                </a>
                <ol id="oliBchNavBrowse" class="breadcrumb xCNMenuModalBrowse">
                    <li class="xWBtnPrevious" onclick="JCNxBrowseData('<?=$tBrowseOption?>')"><a><?= language('common/main/main', 'tShowData')?> : <?= language('bank/bank/bank','tBNKTitleAdd')?></a></li>
                    <!-- <li class="active"><a><?= language('bank/bank/bank','tbank')?></a></li> -->
                </ol>
            </div>
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text-right">
                <div id="odvBchBtnGroup" class="demo-button xCNBtngroup" style="width:100%;">
                    <button type="button" class="btn xCNBTNPrimery" onclick="$('#obtSubmitBank').click()"><?= language('common/main/main', 'tSave')?></button>
                </div>
            </div>
        </div>
    </div>
    <div id="odvModalBodyBrowse" class="modal-body">
	
    </div>
<?php endif;?>
<script src="<?php echo base_url('application/modules/bank/assets/src/bank/jBank.js')?>"></script>