<input id="oetInterfaceExportStaBrowse" type="hidden" value="<?=$nBrowseType?>">
<input id="oetInterfaceExportCallBackOption" type="hidden" value="<?=$tBrowseOption?>">

<?php
	if($this->session->userdata("tSesUsrLevel") == "HQ"){
		$tDisabled = "";
	}else{
		$nCountBch = $this->session->userdata("nSesUsrBchCount");
		if($nCountBch == 1){
			$tDisabled = "disabled";
		}else{
			$tDisabled = "";
		}
	}

	$tUserBchCode = $this->session->userdata("tSesUsrBchCodeDefault");
	$tUserBchName = $this->session->userdata("tSesUsrBchNameDefault");
?>

<?php

	$dBchStartFrm		= date('Y-m-d');
	$dBchStartTo		= date('Y-m-d');
?>

<div id="odvCpnMaIFXenu" class="main-menu clearfix">
	<div class="xCNMrgNavMenu">
		<div class="row xCNavRow" style="width:inherit;">
			<div class="col-xs-12 col-sm-8 col-md-8 col-lg-8">
				<ol id="oliMenuNav" class="breadcrumb">
					<?php FCNxHADDfavorite('interfaceexport/0/0');?> 
					<li id="oliInterfaceExportTitle" class="xCNLinkClick" style="cursor:pointer" ><?php echo language('interface/interfaceexport/interfaceexport','tITFXTitle') ?></li>
				</ol>
			</div>
			
			<div class="col-xs-12 col-sm-4 col-md-4 col-lg-4 text-right p-r-0">
			<div id="odvBtnCmpEditInfo">
			<button id="obtInterfaceExportConfirm" class="btn xCNBTNPrimery xCNBTNPrimery2Btn" type="button"> <?php echo language('interface/interfaceexport/interfaceexport','tITFXTConfirm')  ?></button> 
				</div>
	
			</div>
		</div>
	</div>
</div>
<form class="contact100-form validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data" id="ofmInterfaceExport">
<input name="oetInterfaceExporttLK_SAPDBSever" id="oetInterfaceExporttLK_SAPDBSever" type="hidden" value="<?=$aConnect['tLK_SAPDBSever']?>">
<input name="oetInterfaceExporttLK_SAPDBName" id="oetInterfaceExporttLK_SAPDBName" type="hidden" value="<?=$aConnect['tLK_SAPDBName']?>">
<input name="oetInterfaceExporttLK_SAPDBPort" id="oetInterfaceExporttLK_SAPDBPort" type="hidden" value="<?=$aConnect['tLK_SAPDBPort']?>">
<input name="oetInterfaceExporttLK_SAPDBUsr" id="oetInterfaceExporttLK_SAPDBUsr" type="hidden" value="<?=$aConnect['tLK_SAPDBUsr']?>">
<input name="oetInterfaceExporttLK_SAPDBPwd" id="oetInterfaceExporttLK_SAPDBPwd" type="hidden" value="<?=$aConnect['tLK_SAPDBPwd']?>">
<div class="main-content">
	<div class="panel panel-headline">
	<input type="hidden" name="tUserCode" id="tUserCode" value="<?=$this->session->userdata('tSesUserCode')?>">
	<div class="row">
    <div class="col-md-12">

		<div class="panel-body">

			<div class="col-md-12">
				<input type="checkbox" name="ocbAlwDupFlag" id="ocbAlwDupFlag"  value="1" > <?php echo language('interface/interfaceexport/interfaceexport','tAlwDupData')  ?>
			</div>
				<div class="table-responsive" style="padding:20px">
						<table id="otbCtyDataList" class="table table-striped"> <!-- เปลี่ยน -->
							<thead>
								<tr>
									<th width="4%" nowrap class="text-center xCNTextBold"><?php echo language('interface/interfaceexport/interfaceexport','tITFXID'); ?></th>
									<th width="5%" nowrap class="text-center xCNTextBold"><?php echo language('interface/interfaceexport/interfaceexport','tITFXSelect'); ?></th>
									<th width="20%" nowrap class="text-center xCNTextBold"><?php echo language('interface/interfaceexport/interfaceexport','tITFXList'); ?></th>
									<th nowrap class="text-center xCNTextBold"><?php echo language('interface/interfaceexport/interfaceexport','tITFXCondition'); ?></th>
									<!-- <th width="15%" nowrap class="text-center xCNTextBold"><?php echo language('interface/interfaceexport/interfaceexport','tITFXTStatus'); ?></th> -->
								</tr>
							</thead>
							<tbody>

								<?php if(!empty($aDataMasterImport)){
										foreach($aDataMasterImport as $nKey => $aData){
									?>
								<tr>
									<td align="center"><?=($nKey+1)?></td>
									<td align="center">
										<input type="checkbox" class="progress-bar-chekbox xWIFXDisabledOnProcess" name="ocmIFXExport[<?=$aData['FTApiCode']?>]" id="ocmIFXExport<?=$aData['FTApiCode']?>" value="<?=$aData['FTApiCode']?>" idpgb="xWIFXExpBonTextDisplay" data-type="ExpBon" checked >
									</td>
									<td align="left"><?php echo $aData['FTApiName'] ?></td>
									<td>
										<div class="col-md-12">

											<!-- สาขา -->
											<div class="row">
												<div class="col-md-2"><?php echo language('company/branch/branch', 'tBCHTitle'); ?></div>
												<div class="col-md-10">

													<div id="odvCondition4" class="row">
														<div class="col-lg-5">
															
															<div class="form-group">	
																<div class="input-group">
																	<input class="form-control xCNHide" id="oetIFXBchCodeSale<?=$aData['FTApiCode']?>" name="oetIFXBchCodeSale[<?=$aData['FTApiCode']?>]" maxlength="5" value="<?php echo $tUserBchCode; ?>">
																	<input class="form-control xWPointerEventNone" type="text" id="oetIFXBchNameSale<?=$aData['FTApiCode']?>" name="oetIFXBchNameSale<?=$aData['FTApiCode']?>" value="<?php echo $tUserBchName; ?>" readonly>
																	<span class="input-group-btn">
																		<button  type="button" data-seq="<?=$aData['FTApiCode']?>" class="btn xIFXBrowseBchSale xCNBtnBrowseAddOn xWIFXDisabledOnProcess" <?php echo $tDisabled; ?> >
																			<img src="<?php echo  base_url('application/modules/common/assets/images/icons/find-24.png'); ?>">
																		</button>
																	</span>
																</div>
															</div>
															
														</div>
													</div>

												</div>
											</div>
											<!-- สาขา -->

											<div class="row">
												<div class="col-md-2"><?=language('interface/interfaceexport/interfaceexport','tITFXFilterDate');?></div>
												<div class="col-md-10">

													<div id="odvCondition4" class="row">

														<div class="col-lg-5">
															<div class="form-group">
																<div class="input-group">
																	<input 
																		type="text" 
																		class="form-control xWITFXDatePickerSale xCNDatePicker xCNDatePickerStart xCNInputMaskDate xWRptAllInput xWIFXDisabledOnProcess" 
																		autocomplete="off" 
																		id="oetITFXDateFromSale<?=$aData['FTApiCode']?>"  
																		name="oetITFXDateFromSale[<?=$aData['FTApiCode']?>]"  
																		maxlength="10"
																		value=<?=$dBchStartFrm;?>>
																	<span class="input-group-btn">
																		<button id="" data-seq="<?=$aData['FTApiCode']?>" type="button" class="btn xITFXDateFromSale xCNBtnDateTime xWIFXDisabledOnProcess"><img class="xCNIconCalendar"></button>
																	</span>
																</div>
															</div>
														</div>
												
														<!-- <div class="col-lg-1">
															<p class="xCNTextTo"><?=language('interface/interfaceexport/interfaceexport','tITFXFilterTo');?></p>
														</div>

														<div class="col-lg-5">
															<div class="form-group">
																<div class="input-group">
																	<input type="text" 
																		class="form-control xWITFXDatePickerSale xCNDatePicker xCNDatePickerEnd xCNInputMaskDate xWRptAllInput xWIFXDisabledOnProcess" 
																		autocomplete="off" id="oetITFXDateToSale<?=$aData['FTApiCode']?>" 
																		name="oetITFXDateToSale[<?=$aData['FTApiCode']?>]"  
																		maxlength="10"
																		value="<?=$dBchStartTo;?>">
																	<span class="input-group-btn">
																		<button id=""  data-seq="<?=$aData['FTApiCode']?>" type="button" class="btn xITFXDateToSale xCNBtnDateTime xWIFXDisabledOnProcess"><img class="xCNIconCalendar"></button>
																	</span>
																</div>
															</div>
														</div>
														 -->
													</div>

												</div>
											</div>
												<?php if($aData['FTApiCode'] == '00003'){ ?>
											<div class="row">
												<div class="col-md-2"><?=language('interface/interfaceexport/interfaceexport','tITFXFilterDocSal');?></div>
												<div class="col-md-10">
													<div class="xCNFilterBox"><div id="odvCondition1" class="row xCNFilterRangeMode">

														<div class="col-lg-5">
															<div class="form-group">
																<div class="input-group">
																	<input type="text" class="form-control xWRptAllInput" id="oetITFXXshDocNoFrom<?=$aData['FTApiCode']?>" name="oetITFXXshDocNoFrom[<?=$aData['FTApiCode']?>]" readonly>
																	<!-- <input type="text" class="form-control xWPointerEventNone xWRptAllInput" id="oetRptBchNameFrom" name="oetRptBchNameFrom" readonly=""> -->
																	<span class="input-group-btn">
																		<button id="" data-seq="<?=$aData['FTApiCode']?>" type="button" class="btn xITFXBrowseFromSale xCNBtnBrowseAddOn xWIFXDisabledOnProcess"><img class="xCNIconFind"></button>
																	</span>
																</div>
															</div>
														</div>
												
														<div class="col-lg-1">
															<p class="xCNTextTo"><?=language('interface/interfaceexport/interfaceexport','tITFXFilterTo');?></p>
														</div>

														<div class="col-lg-5">
															<div class="form-group">
																<div class="input-group">
																	<input type="text" class="form-control xWRptAllInput" id="oetITFXXshDocNoTo<?=$aData['FTApiCode']?>" name="oetITFXXshDocNoTo[<?=$aData['FTApiCode']?>]" readonly>
																	<!-- <input type="text" class="form-control xWPointerEventNone xWRptAllInput" id="oetRptBchNameTo" name="oetRptBchNameTo" readonly=""> -->
																	<span class="input-group-btn">
																		<button id="" data-seq="<?=$aData['FTApiCode']?>" type="button" class="btn xITFXBrowseToSale xCNBtnBrowseAddOn xWIFXDisabledOnProcess"><img class="xCNIconFind"></button>
																	</span>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
											<?php }?>
										</div>
									</td>
						
								</tr>
								<?php  }} ?>
							</tbody>
						</table>

						<!-- <input type="checkbox" name="ocmIFXChkAll" class="xWIFXDisabledOnProcess" id="ocmIFXChkAll" value="1" checked > <?php //echo language('interface/interfaceexport/interfaceexport','tITFXSelectAll'); ?> -->
					</div>
				</div>
			</div>
		</div>

	</div>
</div>
</form>


<!--Modal Success-->
<div class="modal fade" id="odvInterfaceEmportSuccess">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="xCNHeardModal modal-title" style="display:inline-block"><?=language('interface/interfaceexport/interfaceexport','tStatusProcess'); ?></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p><?=language('interface/interfaceexport/interfaceexport','tContentProcess'); ?></p>
            </div>
            <div class="modal-footer">
                <button data-dismiss="modal" id="obtIFXModalMsgConfirm" type="button" class="btn xCNBTNPrimery">
                    <?=language('common/main/main', 'tModalConfirm'); ?>
                </button>
				<button type="button" id="obtIFXModalMsgCancel" class="btn xCNBTNDefult" data-dismiss="modal">
					<?php echo language('common/main/main', 'tModalCancel'); ?>
				</button>
            </div>
        </div>
    </div>
</div>



<script src="<?php echo base_url('application/modules/interface/assets/src/interfaceexport/jInterfaceExport.js')?>"></script>
<script>
	// $('#ocbReqpairExport').click(function(){
	// 	// Last Update : Napat(Jame) 17/08/2020 แก้ปัญหาติ๊ก checkbox แล้วกดปุ่มเมนูซ้ายมือไม่ได้
	// 	if($(this).prop('checked') == true){
	// 		$('.xWIFXDisabledOnProcess').prop('disabled',true);
	// 		// $('input').prop('disabled',true);
	// 		// $('button').prop('disabled',true);
	// 	}else{
	// 		$('.xWIFXDisabledOnProcess').prop('disabled',false);
	// 		// $('input').prop('disabled',false);
	// 		// $('button').prop('disabled',false);
	// 	}
	// 	$('#ocbReqpairExport').prop('disabled',false);
	// 	$('#obtInterfaceExportConfirm').prop('disabled',false);
	// 	$('#obtIFXModalMsgConfirm').prop('disabled',false);
	// });

	$( document ).ready(function() {
		$('.xCNDatePicker').datepicker({
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayHighlight: true,
			// startDate: new Date()
		}).on('changeDate',function(ev){
			JSxIFXAfterChangeDateClearBrowse();
		});
	});


	$('#oetITFXDateFromSale').on('change',function(){
		if($('#oetITFXDateToSale').val() == ""){
			$('#oetITFXDateToSale').val($('#oetITFXDateFromSale').val());
		}
	});

	$('#oetITFXDateToSale').on('change',function(){
		if($('#oetITFXDateFromSale').val() == ""){
			$('#oetITFXDateFromSale').val($('#oetITFXDateToSale').val());
		}
	});

	$('#oetITFXDateFromFinance').on('change',function(){
		if($('#oetITFXDateToFinance').val() == ""){
			$('#oetITFXDateToFinance').val($('#oetITFXDateFromFinance').val());
		}
	});

	$('#oetITFXDateToFinance').on('change',function(){
		if($('#oetITFXDateFromFinance').val() == ""){
			$('#oetITFXDateFromFinance').val($('#oetITFXDateToFinance').val());
		}
	});

	

	// Date For SaleHD
	$('.xITFXDateFromSale').off('click').on('click',function(){
		var nSeq = $(this).data('seq');
		$('#oetITFXDateFromSale'+nSeq).datepicker('show');
	});

	$('.xITFXDateToSale').off('click').on('click',function(){
		var nSeq = $(this).data('seq');
		$('#oetITFXDateToSale'+nSeq).datepicker('show');
	});

	

	// Date For Finance
	$('#obtITFXDateFromFinance').off('click').on('click',function(){
		$('#oetITFXDateFromFinance').datepicker('show');
	});

	$('#obtITFXDateToFinance').off('click').on('click',function(){
		$('#oetITFXDateToFinance').datepicker('show');
	});

	// $('.xWITFXDatePickerFinance').datepicker({
	// 	format					: 'dd/mm/yyyy',
	// 	disableTouchKeyboard 	: true,
	// 	enableOnReadonly		: false,
	// 	autoclose				: true,
	// });

	function JSxCreateDataBillToTemp(pnType,pnSeq){
		let dDateFrom		 = $('#oetITFXDateFromSale'+pnSeq).val();
		// let dDateTo			 = $('#oetITFXDateToSale'+pnSeq).val();
		let tIFXBchCodeSale  = $('#oetIFXBchCodeSale'+pnSeq).val();

		$.ajax({
				type    : "POST",
				url     : "interfaceexportFilterBill",
				data    : {
					oetITFXDateFromSale:dDateFrom,
					oetITFXDateToSale:dDateFrom,
					oetIFXBchCodeSale:tIFXBchCodeSale,
					nSeq:pnSeq,
				},
				cache   : false,
				Timeout : 0,
				success: function(tResult){
					if(pnType==1){
						window.oITFXBrowseFromSale = undefined;
						var tValueTo     = $('#oetITFXXshDocNoTo'+pnSeq).val();
						if(tValueTo == ""){
							tValueTo = 'oetITFXXshDocNoTo'+pnSeq;
						}
						oITFXBrowseFromSale        = oITFXBrowseSaleOption({
							'tReturnInputCode'  : 'oetITFXXshDocNoFrom'+pnSeq,
							'tReturnInputName'  : tValueTo,
							'tNextFuncName'     : '',
							'aArgReturn'        : ['FTXshDocNo']
						});
						JCNxBrowseData('oITFXBrowseFromSale');
					}else{
						window.oITFXBrowseToSale = undefined;
						var tValueTo     = $('#oetITFXXshDocNoFrom'+pnSeq).val();
						if(tValueTo == ""){
							tValueTo = 'oetITFXXshDocNoFrom'+pnSeq;
						}
						oITFXBrowseToSale        = oITFXBrowseSaleOption({
							'tReturnInputCode'  : 'oetITFXXshDocNoTo'+pnSeq,
							'tReturnInputName'  : tValueTo,
							'tNextFuncName'     : '',
							'aArgReturn'        : ['FTXshDocNo']
						});
						JCNxBrowseData('oITFXBrowseToSale');
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					JCNxResponseError(jqXHR, textStatus, errorThrown);
				}
			});
	}

	$('.xITFXBrowseFromSale').off('click').on('click',function(){
		var nSeq = $(this).data('seq');
		JSxCreateDataBillToTemp(1,nSeq);

	});

	$('.xITFXBrowseToSale').off('click').on('click',function(){
		var nSeq = $(this).data('seq');
		JSxCreateDataBillToTemp(2,nSeq);
	});
	

	var oITFXBrowseSaleOption = function(poReturnInput){
        let tNextFuncName    = poReturnInput.tNextFuncName;
        let aArgReturn       = poReturnInput.aArgReturn;
        let tInputReturnCode = poReturnInput.tReturnInputCode;
		let tInputReturnName = poReturnInput.tReturnInputName;
		let dDateFrom		 = $('#oetITFXDateFromSale').val();
		let dDateTo			 = $('#oetITFXDateToSale').val();
		let tIFXBchCodeSale  = $('#oetIFXBchCodeSale').val();
		let tWhere		     = "";
		let tSessionUserCode  = '<?=$this->session->userdata('tSesUserCode')?>'
		
	
			tWhere += " AND TCNTBrsBillTmp.FTUsrCode = '"+tSessionUserCode+"' ";
	



        let oOptionReturn    = {
            Title: ['interface/interfaceexport/interfaceexport','tITFXDataSal'],
            Table:{Master:'TCNTBrsBillTmp',PK:'FTXshDocNo'},
			Where: {
                    Condition: [tWhere]
			},
			// Filter:{
			// 	Selector    : 'oetIFXBchCodeSale',
			// 	Table       : 'TCNTBrsBillTmp',
			// 	Key         : 'FTBchCode'
			// },
            GrideView:{
                ColumnPathLang	: 'interface/interfaceexport/interfaceexport',
                ColumnKeyLang	: ['tITFXSalDocNo','tITFXSalDate'],
                ColumnsSize     : ['30%','50%','20%'],
                WidthModal      : 50,
                DataColumns		: ['TCNTBrsBillTmp.FTXshDocNo','TCNTBrsBillTmp.FDXshDocDate'],
                DataColumnsFormat : ['','',''],
                Perpage			: 10,
                OrderBy			: ['FTXshDocNo ASC'],
            },
            CallBack:{
                ReturnType	: 'S',
                Value		: [tInputReturnCode,"TCNTBrsBillTmp.FTXshDocNo"],
                Text		: [tInputReturnName,"TCNTBrsBillTmp.FTXshDocNo"]
			},
            NextFunc : {
                FuncName    : tNextFuncName,
                ArgReturn   : aArgReturn
            }
            // RouteAddNew: 'branch',
            // BrowseLev: 1
        };
        return oOptionReturn;
	};
	
	$('#ocmIFXChkAll').off('click').on('click',function(){
		if($(this).prop('checked') == true){
			$('.progress-bar-chekbox').prop('checked',true);
		}else{
			$('.progress-bar-chekbox').prop('checked',false);
		}
	});

	$('#obtInterfaceExportConfirm').off('click').on('click',function(){
		let nImpportFile = $('.progress-bar-chekbox:checked').length;
        if(nImpportFile > 0){
			JCNxOpenLoading(); 
			JSxIFXDefualValueProgress();
			JSxIFXCallRabbitMQ();
        }else{
            alert('Please Select Imformation For Export');
        }
	});

	$('#obtIFXBrowseBchFin').off('click').on('click',function(){
		window.oITFXBrowseBch = undefined;
		oITFXBrowseBch        = oITFXBrowseBchOption({
			'tReturnInputCode'  : 'oetIFXBchCodeFin',
			'tReturnInputName'  : 'oetIFXBchNameFin',
		});
		JCNxBrowseData('oITFXBrowseBch');
	});
	
	$('.xIFXBrowseBchSale').off('click').on('click',function(){
		window.oITFXBrowseBch = undefined;
		oITFXBrowseBch        = oITFXBrowseBchOption({
			'tReturnInputCode'  : 'oetIFXBchCodeSale'+$(this).data('seq'),
			'tReturnInputName'  : 'oetIFXBchNameSale'+$(this).data('seq'),
			'tDataSeq'          : $(this).data('seq')
		});
		JCNxBrowseData('oITFXBrowseBch');
	});

	var oITFXBrowseBchOption = function(poReturnInput){
        let tNextFuncName    = poReturnInput.tNextFuncName;
        let aArgReturn       = poReturnInput.aArgReturn;
        let tInputReturnCode = poReturnInput.tReturnInputCode;
		let tInputReturnName = poReturnInput.tReturnInputName;

		var tUsrLevel     = "<?php echo $this->session->userdata("tSesUsrLevel"); ?>";
		var tBchCodeMulti = "<?php echo $this->session->userdata("tSesUsrBchCodeMulti"); ?>";
		var nCountBch     = "<?php echo $this->session->userdata("nSesUsrBchCount"); ?>";
		let tWhere		     = "";

		if(tUsrLevel != "HQ"){
			tWhere = " AND TCNMBranch.FTBchCode IN ("+tBchCodeMulti+") ";
		}else{
			tWhere = "";
		}

		var nLangEdits  = '<?php echo $this->session->userdata("tLangEdit");?>';
        let oOptionReturn    = {
            Title: ['company/branch/branch','tBCHTitle'],
            Table:{Master:'TCNMBranch',PK:'FTBchCode'},
			Join: {
                Table: ['TCNMBranch_L'],
                On:['TCNMBranch.FTBchCode = TCNMBranch_L.FTBchCode AND TCNMBranch_L.FNLngID = '+nLangEdits]
			},
			Where: {
				Condition: [tWhere]
			},
            GrideView:{
                ColumnPathLang	: 'company/branch/branch',
                ColumnKeyLang	: ['tBCHCode','tBCHName'],
                ColumnsSize     : ['30%','70%'],
                WidthModal      : 50,
                DataColumns		: ['TCNMBranch.FTBchCode','TCNMBranch_L.FTBchName'],
                DataColumnsFormat : ['',''],
                Perpage			: 10,
                OrderBy			: ['TCNMBranch.FDCreateOn DESC'],
            },
            CallBack:{
                ReturnType	: 'S',
                Value		: [tInputReturnCode,"TCNMBranch.FTBchCode"],
                Text		: [tInputReturnName,"TCNMBranch_L.FTBchName"]
			},
        };
        return oOptionReturn;
	};

	// Create By : Napat(Jame) 17/08/2020 เมื่อกดปุ่มยืนยันให้วิ่งไปที่หน้า ประวัตินำเข้า-ส่งออก
	$('#obtIFXModalMsgConfirm').off('click');
	$('#obtIFXModalMsgConfirm').on('click',function(){
		// ใส่ timeout ป้องกัน modal-backdrop
		setTimeout(function(){
			$.ajax({
				type    : "POST",
				url     : "interfacehistory/0/0",
				data    : {},
				cache   : false,
				Timeout : 0,
				success: function(tResult){
					$('.odvMainContent').html(tResult);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					JCNxResponseError(jqXHR, textStatus, errorThrown);
				}
			});
		}, 100);
	});

</script>