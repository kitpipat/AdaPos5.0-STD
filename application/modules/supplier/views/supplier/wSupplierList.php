<div class="panel-heading">
	<div class="row">
		<div class="col-xs-8 col-md-4 col-lg-4">
			<div class="form-group">
				<label class="xCNLabelFrm"><?php echo language('supplier/supplier/supplier','tSearch')?></label>
				<div class="input-group">
					<input type="text" class="form-control" id="oetSearchSupplier" name="oetSearchSupplier" placeholder="<?php echo language('supplier/supplier/supplier','tSearch')?>">
					<span class="input-group-btn">
						<button id="oimSearchSupplier" class="btn xCNBtnSearch" type="button">
							<img  src="<?php echo base_url().'/application/modules/common/assets/images/icons/search-24.png'?>">
						</button>
					</span>
				</div>
			</div>
		</div>
		<div class="col-xs-4 col-md-8 col-lg-8 text-right" style="margin-top:34px;">

		
		<button type="button" id="odvEventImportFileSPL" class="btn xCNBTNImportFile"><?= language('common/main/main','tImport')?></button>
	

			<div id="odvMngTableList" class="btn-group xCNDropDrownGroup">
				<button type="button" class="btn xCNBTNMngTable" data-toggle="dropdown">
					<?php echo language('common/main/main', 'tCMNOption') ?>
					<span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu">
					<li id="oliBtnDeleteAll" class="disabled">
						<a data-toggle="modal" data-target="#odvModalDelSupplier"><?php echo language('common/main/main', 'tDelAll') ?></a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<input type="hidden" name="ohdDeleteChooseconfirm" id="ohdDeleteChooseconfirm" value="<?php echo language('common/main/main', 'tModalConfirmDeleteItemsAll') ?>">
<input type="hidden" name="ohdDeleteconfirm" id="ohdDeleteconfirm" value="<?php echo language('common/main/main', 'tModalConfirmDeleteItems') ?>">
<input type="hidden" name="ohdDeleteconfirmYN" id="ohdDeleteconfirmYN" value="<?php echo language('common/main/main', 'tModalConfirmDeleteItemsYN') ?>">

<div class="panel-body">
	<section id="ostDataSupplier"></section>
</div>

<script>
	$('#oimSearchSupplier').click(function(){
		JCNxOpenLoading();
		JSvSupplierDataTable();
	});
	$('#oetSearchSupplier').keypress(function(event){
		if(event.keyCode == 13){
			JCNxOpenLoading();
			JSvSupplierDataTable();
		}
	});
</script>

<script>
	//nattakit 15/12/2022
	//กดนำเข้า จะวิ่งไป Modal popup ที่ center
	$('#odvEventImportFileSPL').click(function() {
		var tNameModule = 'supplier';
		var tTypeModule = 'master';
		var tAfterRoute = 'supplierPageImportDataTable';

		var aPackdata = {
			'tNameModule' : tNameModule,
			'tTypeModule' : tTypeModule,
			'tAfterRoute' : tAfterRoute
		};
		JSxImportPopUp(aPackdata);
	});
</script>