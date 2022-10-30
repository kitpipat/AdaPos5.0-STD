<div class="panel panel-headline">
    <div class="panel-heading">
        <div class="row">
            <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
                <div class="form-group">
                    <div class="input-group">
                        <input
                            class="form-control xCNInpuTXOthoutSingleQuote"
                            type="text"
                            id="oetDOSearchAllDocument"
                            name="oetDOSearchAllDocument"
                            placeholder="<?php echo language('document/deliveryorder/deliveryorder','tDOFillTextSearch')?>"
                            autocomplete="off"
                        >
                        <span class="input-group-btn">
                            <button id="obtDOSerchAllDocument" type="button" class="btn xCNBtnDateTime"><img class="xCNIconSearch"></button>
                        </span>
                    </div>
                </div>
            </div>
            <button id="obtDOAdvanceSearch" class="btn xCNBTNDefult xCNBTNDefult1Btn"><?php echo language('common/main/main', 'tAdvanceSearch'); ?></button>
            <button id="obtDOSearchReset" class="btn xCNBTNDefult xCNBTNDefult1Btn"><?php echo language('common/main/main', 'tClearSearch'); ?></button>
        </div>
        <div id="odvDOAdvanceSearchContainer" class="hidden" style="margin-bottom:20px;">
            <form id="ofmDOFromSerchAdv" class="validate-form" action="javascript:void(0)" method="post">
                <div class="row">
                    <!-- From Search Advanced  Branch -->
                    <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <div class="form-group">
                            <?php
                                if ( $this->session->userdata("tSesUsrLevel") != "HQ" ){
                                    if( $this->session->userdata("nSesUsrBchCount") <= 1 ){ //ค้นหาขั้นสูง
                                        $tBCHCode 	= $this->session->userdata("tSesUsrBchCodeDefault");
                                        $tBCHName 	= $this->session->userdata("tSesUsrBchNameDefault");
                                    }else{
                                        $tBCHCode 	= '';
                                        $tBCHName 	= '';
                                    }
                                }else{
                                    $tBCHCode 		= '';
                                    $tBCHName 		= '';
                                }
                            ?>
                            <label class="xCNLabelFrm"><?php echo language('document/deliveryorder/deliveryorder','tDOAdvSearchBranch'); ?></label>
                            <div class="input-group">
                                <input class="form-control xCNHide" type="text" id="oetDOAdvSearchBchCodeFrom" name="oetDOAdvSearchBchCodeFrom" maxlength="5"  value="<?= $tBCHCode; ?>">
                                <input
                                    class="form-control xWPointerEventNone"
                                    type="text"
                                    id="oetDOAdvSearchBchNameFrom"
                                    name="oetDOAdvSearchBchNameFrom"
                                    placeholder="<?php echo language('document/deliveryorder/deliveryorder','tDOAdvSearchFrom'); ?>"
                                    readonly
                                    value="<?= $tBCHName; ?>"
                                >
                                <span class="input-group-btn">
                                    <button id="obtDOAdvSearchBrowseBchFrom" type="button" class="btn xCNBtnBrowseAddOn" ><img class="xCNIconFind"></button>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('document/deliveryorder/deliveryorder','tDOAdvSearchTo');?></label>
                            <div class="input-group">
                                <input class="form-control xCNHide" id="oetDOAdvSearchBchCodeTo"name="oetDOAdvSearchBchCodeTo" maxlength="5"  value="<?= $tBCHCode; ?>">
                                <input
                                    class="form-control xWPointerEventNone"
                                    type="text"
                                    id="oetDOAdvSearchBchNameTo"
                                    name="oetDOAdvSearchBchNameTo"
                                    placeholder="<?php echo language('document/deliveryorder/deliveryorder','tDOAdvSearchTo'); ?>"
                                    readonly
                                    value="<?= $tBCHName; ?>"
                                >
                                <span class="input-group-btn">
                                    <button id="obtDOAdvSearchBrowseBchTo" type="button" class="btn xCNBtnBrowseAddOn" ><img class="xCNIconFind"></button>
                                </span>
                            </div>
                        </div>
                    </div>
                    <!-- From Search Advanced Agency -->
                    <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?=language('document/purchaseorder/purchaseorder','tPOPanelAgency'); ?></label>
                            <div class="input-group">
                                <?php
                                    if ( $this->session->userdata("tSesUsrLevel") != "HQ" ){
                                        $tSatAgnCode    = $this->session->userdata('tSesUsrAgnCode');
                                        $tSatAgnName    = $this->session->userdata('tSesUsrAgnName');
                                        $tDisabled      = 'disabled';
                                    } else {
                                        $tSatAgnCode    ='';
                                        $tSatAgnName    ='';
                                        $tDisabled      = '';
                                    }
                                ?>
                                <input class="form-control xCNHide" type="text" id="oetDOAdvSearchAgnCode" name="oetDOAdvSearchAgnCode" maxlength="5" value="<?php echo $tSatAgnCode?>">
                                <input
                                    class="form-control xWPointerEventNone"
                                    type="text"
                                    id="oetDOAdvSearchAgnName"
                                    name="oetDOAdvSearchAgnName"
                                    placeholder="<?php echo language('document/deliveryorder/deliveryorder','tPOPanelAgency'); ?>"
                                    readonly
                                    value="<?php echo $tSatAgnName?>"
                                >
                                <span class="input-group-btn">
                                    <button id="obtDOAdvSearchBrowseAgn" type="button" class="btn xCNBtnBrowseAddOn" <?php echo $tDisabled?>><img class="xCNIconFind"></button>
                                </span>
                            </div>
                        </div>
                    </div>
                    <!-- From Search Advanced  Supplier -->
                    <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?=language('document/purchaseorder/purchaseorder','tPOPanelSupplier'); ?></label>
                            <div class="input-group">
                                <input class="form-control xCNHide" type="text" id="oetDOAdvSearchSplCode" name="oetDOAdvSearchSplCode" maxlength="5">
                                <input
                                    class="form-control xWPointerEventNone"
                                    type="text"
                                    id="oetDOAdvSearchSplName"
                                    name="oetDOAdvSearchSplName"
                                    placeholder="<?php echo language('document/deliveryorder/deliveryorder','tPOPanelSupplier'); ?>"
                                    readonly
                                >
                                <span class="input-group-btn">
                                    <button id="obtDOAdvSearchBrowseSpl" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                                </span>
                            </div>
                        </div>
                    </div>
                    <!-- From Search Advanced  DocDate -->
                    <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('document/deliveryorder/deliveryorder','tDOAdvSearchDocDate'); ?></label>
                            <div class="input-group">
                                <input
                                    class="form-control xCNDatePicker"
                                    type="text"
                                    id="oetDOAdvSearcDocDateFrom"
                                    name="oetDOAdvSearcDocDateFrom"
                                    placeholder="<?php echo language('document/deliveryorder/deliveryorder', 'tDOAdvSearchDateFrom'); ?>"
                                >
                                <span class="input-group-btn" >
                                    <button id="obtDOAdvSearchDocDateForm" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <label class="xCNLabelFrm"><?php echo language('document/deliveryorder/deliveryorder', 'tDOAdvSearchDateTo'); ?></label>
                        <div class="input-group">
                            <input
                                class="form-control xCNDatePicker"
                                type="text"
                                id="oetDOAdvSearcDocDateTo"
                                name="oetDOAdvSearcDocDateTo"
                                placeholder="<?php echo language('document/deliveryorder/deliveryorder', 'tDOAdvSearchDateTo'); ?>"
                            >
                            <span class="input-group-btn" >
                                <button id="obtDOAdvSearchDocDateTo" type="button" class="btn xCNBtnDateTime"><img class="xCNIconCalendar"></button>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <!-- From Search Advanced Status Doc -->
                    <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('document/deliveryorder/deliveryorder','tDOAdvSearchStaDoc'); ?></label>
                            <select class="selectpicker form-control" id="ocmDOAdvSearchStaDoc" name="ocmDOAdvSearchStaDoc">
                                <option value='0'><?php echo language('common/main/main', 'tStaDocAll'); ?></option>
                                <option value='1'><?php echo language('common/main/main', 'tStaDocApv'); ?></option>
                                <option value='2'><?php echo language('common/main/main', 'tStaDocPendingApv'); ?></option>
                                <option value='3'><?php echo language('common/main/main', 'tStaDocCancel'); ?></option>
                            </select>
                        </div>
                    </div>
                    <!-- From Search Advanced Status Doc Aaction -->
					<div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <div class="form-group">
                            <label class="xCNLabelFrm"><?php echo language('common/main/main', 'tStaDocAct'); ?></label>
                                <select class="selectpicker form-control" id="ocmStaDocAct" name="ocmStaDocAct">
                                    <option value='0' selected><?php echo language('common/main/main', 'tAll'); ?></option>
                                    <option value='1'><?php echo language('common/main/main', 'tStaDocActMove'); ?></option>
                                    <option value='2'><?php echo language('common/main/main', 'tStaDocActNotMoving'); ?></option>
                                </select>
                        </div>
                    </div>
                    <!-- Button Form Search Advanced -->
                    <div class="col-xs-12 col-sm-6 col-md-2 col-lg-2">
                        <div class="form-group" style="width:60%;float:left;">
                            <label class="xCNLabelFrm">&nbsp;</label>
                            <button id="obtDOAdvSearchSubmitForm" class="btn xCNBTNPrimery" style="width:100%"><?php echo language('common/main/main', 'tSearch'); ?></button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="panel-heading">
        <div class="row">
            <div class="col-xs-8 col-sm-4 col-md-4 col-lg-4">
            </div>
            <div class="col-xs-4 col-md-8 col-lg-8 text-right" style="margin-top:-35px;">
                <div id="odvDOMngTableList" class="btn-group xCNDropDrownGroup">
                    <button type="button" class="btn xCNBTNMngTable" data-toggle="dropdown">
                        <?php echo language('common/main/main','tCMNOption')?>
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
						<li id="oliDOBtnDeleteAll">
							<a data-toggle="modal" data-target="#odvDOModalDelDocMultiple"><?php echo language('common/main/main','tCMNDeleteAll')?></a>
						</li>
					</ul>
                </div>
            </div>
        </div>
    </div>
    <div class="panel-body">
        <section id="ostDODataTableDocument"></section>
    </div>
</div>
<script src="<?php echo base_url('application/modules/common/assets/src/jFormValidate.js')?>"></script>
<?php include('script/jDeliveryOrderFormSearchList.php')?>