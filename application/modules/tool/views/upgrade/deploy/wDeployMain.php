<style>
 .xDPYTitle{
    font-family: THSarabunNew-Bold;
    font-size: 21px !important;
    line-height: 32px;
    font-weight: 500;
    color: #179bfd !important;
 }
</style>
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
<div id="odvDPYMainMenu" class="">
        <div class="xCNMrgNavMenu">
            <div class="row xCNavRow" style="width:inherit;">
                <div class="col-xs-12 col-md-6">
                    <ol id="oliDPYMenuNav" class="breadcrumb">
                        <li id="oliDPYTitle" class="xDPYTitle" style="cursor:pointer;"><?php echo language('tool/tool/tool','tDPYTitle');?></li>
						<li id="oliDPYTitleAdd" class="active"><a><?php echo language('tool/tool/tool','tDPYTitleAdd');?></a></li>
						<li id="oliDPYTitleEdit" class="active"><a><?php echo language('tool/tool/tool','tDPYTitleEdit');?></a></li>    
						<li id="oliDPYTitleDetail" class="active"><a><?php echo language('tool/tool/tool','tDPYTitleDetail');?></a></li>    
                    </ol>
                </div>
                <div class="col-xs-12 col-md-6 text-right p-r-0">
                    <div class="demo-button xCNBtngroup" style="width:100%;">
                        <div id="odvBtnASTInfo">
								<button id="obtDPYCallPageAdd" class="xCNBTNPrimeryPlus" type="button">+</button>
                        </div>
                        <div id="odvBtnAddEdit">
                            <div class="demo-button xCNBtngroup" style="width:100%;">
                                <button id="obtDPYCallBackPage" class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"> <?php echo language('common/main/main','tBack')?></button>
                      
                                    <!-- <button id="obtDPYPrint" onclick="JSnASTPrintDoc()" class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"> <?php echo language('common/main/main', 'tCMNPrint')?></button> -->
                                    <button id="obtDPYCancel" onclick="JSnDPYCancelDoc(false)" class="btn xCNBTNDefult xCNBTNDefult2Btn" type="button"> <?php echo language('common/main/main', 'tCancel')?></button> 
                                    <button id="obtDPYApproveDep"  class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button"> <?php echo language('common/main/main', 'tCMNApproveDep')?></button>
                                    <button id="obtDPYApprove"  class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button"> <?php echo language('common/main/main', 'tCMNApprove')?></button>
                                   
                                <button id="obtDPYSubmitFrom" type="button" class="btn xCNBTNPrimery xCNBTNPrimery2Btn"> <?php echo language('common/main/main', 'tSave')?></button>
                                   
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
<div class="" id="odvContentPageDPY">
    <div class="panel-heading">
        <div class="row">
            <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
                <div class="form-group">
                    <div class="input-group">
                        <input class="form-control xCNInpuASTthoutSingleQuote" type="text" id="oetSearchAll" name="oetSearchAll" placeholder="<?php echo language('tool/tool/tool', 'tDPYFillTextSearch') ?>" onkeyup="Javascript:if(event.keyCode==13) JCNxDPYDataTable()" autocomplete="off">
                        <span class="input-group-btn">
                            <button type="button" class="btn xCNBtnDateTime" onclick="JCNxDPYDataTable()">
                                <img class="xCNIconSearch">
                            </button>
                        </span>
                    </div>
                </div>
            </div>
            <a id="oahDPYAdvanceSearch" class="btn xCNBTNDefult xCNBTNDefult1Btn" href="javascript:;"><?php echo language('common/main/main', 'tAdvanceSearch'); ?></a>
            <a id="oahDPYSearchReset" class="btn xCNBTNDefult xCNBTNDefult1Btn" href="javascript:;" onclick="JSxDPYClearSearchData()"><?php echo language('common/main/main', 'tClearSearch'); ?></a>
        </div>
        <div id="odvDPYAdvanceSearchContainer" class="hidden" style="margin-bottom:20px;">
            <form id="ofmASTFromSerchAdv" class="validate-form" action="javascript:void(0)" method="post">
                <div class="row">
          
                    <!-- From Search Advanced  DocDate -->
                    <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('tool/tool/tool', 'tDPYAdvSearchDocDate'); ?></label>
                            <div class="input-group">
                                <input class="form-control xCNDatePicker" type="text" id="oetDPYDocDateFrom" name="oetDPYDocDateFrom" placeholder="<?php echo language('tool/tool/tool', 'tDPYAdvSearchFrom'); ?>">
                                <span class="input-group-btn">
                                    <button id="obtDPYDocDateForm" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                        <div class="form-group">
                            <label class="xCNLabelFrm"></label>
                            <div class="input-group">
                                <input class="form-control xCNDatePicker" type="text" id="oetDPYDocDateTo" name="oetDPYDocDateTo" placeholder="<?php echo language('tool/tool/tool', 'tDPYAdvSearchTo'); ?>">
                                <span class="input-group-btn">
                                    <button id="obtDPYDocDateTo" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                </span>
                            </div>
                        </div>
                    </div>
          
                    <div class="col-xs-12 col-md-3 col-lg-3">
                        <div class="col-lg-12 col-md-12 col-xs-12 no-padding">
                            <label class="xCNLabelFrm"><?php echo language('tool/tool/tool', 'tDPYStaPreDepTitle'); ?></label>
                        </div>
                        <div class="form-group">
                            <select class="selectpicker form-control" id="ocmDPYStaPreDep" name="ocmDPYStaPreDep">
                                <option value='0'><?php echo language('common/main/main', 'tStaDocAll'); ?></option>
                                <option value='1'><?php echo language('tool/tool/tool', 'tDPYStaDep1'); ?></option>
                                <option value='2'><?php echo language('tool/tool/tool', 'tDPYStaDep2'); ?></option>
                            </select>
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-3 col-lg-3">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('tool/tool/tool', 'tDPYStaDepTitle'); ?></label>
                            <select class="selectpicker form-control" id="ocmDPYStaDep" name="ocmDPYStaDep">
                                <option value='0'><?php echo language('common/main/main', 'tAll'); ?></option>
                                <option value='1'><?php echo language('tool/tool/tool', 'tDPYStaDep1'); ?></option>
                                <option value='2'><?php echo language('tool/tool/tool', 'tDPYStaDep2'); ?></option>
                            </select>
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <div class="form-group" style="width: 60%;">
                            <label class="xCNLabelFrm">&nbsp;</label>
                            <button id="obtDPYSubmitFrmSearchAdv" class="btn xCNBTNPrimery" style="width:100%" onclick="JCNxDPYDataTable()"><?php echo language('common/main/main', 'tSearch'); ?></button>
                        </div>
                    </div>

                </div>
            </form>
        </div>
    </div>
    <div class="">
        <div class="">
            <div class="col-xs-8 col-sm-4 col-md-4 col-lg-4">
            </div>
            <div class="col-xs-4 col-md-8 col-lg-8 text-right" style="margin-top:-35px;">
                <div id="odvMngTableList" class="btn-group xCNDropDrownGroup">
                    <button type="button" class="btn xCNBTNMngTable" data-toggle="dropdown">
                        <?php echo language('common/main/main', 'tCMNOption') ?>
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li id="oliBtnDeleteAll" class="disabled">
                            <a data-toggle="modal" data-target="#odvDPYModalDelDocMultiple"><?= language('common/main/main', 'tDelAll') ?></a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="panel-body">
        <section id="ostContentDeployTable"></section>
    </div>
</div>
</div>
<script src="<?php echo  base_url('application/modules/common/assets/js/jquery.mask.js') ?>"></script>
<script src="<?php echo  base_url('application/modules/common/assets/src/jFormValidate.js') ?>"></script>
<?php 
    include('script/jDeployMain.php');
?>