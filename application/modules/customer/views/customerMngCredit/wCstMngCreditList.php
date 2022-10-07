<div class="panel panel-headline">
    <div class="panel-heading">
        <div class="row">
            <div class="col-xs-8 col-sm-4 col-md-4 col-lg-4">
                <div class="form-group">
                    <label class="xCNLabelFrm"><?php echo language('customer/customermngcredit/customermngcredit','tMCRTBCSearch')?></label>
                    <div class="input-group">
                        <input 
                            type="text"
                            class="form-control xCNInputWithoutSingleQuote"
                            id="oetSearchAll"
                            name="oetSearchAll"
                            onkeypress="Javascript:if(event.keyCode==13) JSvMCRCallPageDataTable()"
                            autocomplete="off" 
                            placeholder="<?php echo language('common/main/main','tPlaceholder')?>"
                        >
                        <span class="input-group-btn">
                            <button id="oimSearchMCR" class="btn xCNBtnSearch" type="button">
                                <img onclick="JSvMCRCallPageDataTable()" class="xCNIconBrowse" src="<?= base_url().'/application/modules/common/assets/images/icons/search-24.png'?>">
                            </button>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="panel-body">
        <div id="odvContentMCRData"></div>
    </div>
</div>
<script src="<?= base_url('application/modules/common/assets/js/jquery.mask.js')?>"></script>
<script src="<?= base_url('application/modules/common/assets/src/jFormValidate.js')?>"></script>
<script type="text/javascript">
    $('#oimSearchMCR').click(function(){
		JSvMCRCallPageDataTable();
    });
    $('#oetSearchAll').keypress(function(event){
		if(event.keyCode == 13){
			JSvMCRCallPageDataTable();
		}
	});
</script>