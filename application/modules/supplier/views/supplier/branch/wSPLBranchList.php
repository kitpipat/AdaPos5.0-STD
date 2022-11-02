
<style>
     .xWBtnAdd {
        box-shadow: none;
    }
    
</style>
<div class="col-xs-8 col-md-4 col-lg-4">
    <div class="form-group">
        <div class="input-group">
            <input type="text" class="form-control" id="oetSearchSPLBranch" name="oetSearchSPLBranch" placeholder="<?php echo language('supplier/supplier/supplier','tSearch')?>">
            <span class="input-group-btn">
                <button id="oimSearchSPLBranch" class="btn xCNBtnSearch" type="button">
                    <img  src="<?php echo base_url().'/application/modules/common/assets/images/icons/search-24.png'?>">
                </button>
            </span>
        </div>
    </div>
</div>
<div class="col-xs-4 col-md-8 col-lg-8 text-right" style="">
    <!-- <button class="xCNBTNPrimeryPlus" type="button" onclick="JSvCallPageSPLBranchAdd()">+</button> -->
</div>

<section id="ostDataSPLBranch"></section>

<script>
	$('#oimSearchSPLBranch').click(function(){
		JCNxOpenLoading();
		JSxSPLBranchDataTable();
	});
	$('#oetSearchSPLBranch').keypress(function(event){
		if(event.keyCode == 13){
			JCNxOpenLoading();
			JSxSPLBranchDataTable();
		}
	});
</script>