<style>
    .xWSMTSALHeadPanel{
        /* border-bottom:1px solid #cfcbcb8a !important; */
        padding-bottom:0px !important;
    }

    .xWSMTSALTextNumber{
        font-size: 25px !important;
        font-weight: bold;
    }
    
    .xWSMTSALPanelMainRight{
        padding-bottom:0px;
        /* min-height:300px; */
        overflow-x: auto;
    }

    .xWDRG{
        cursor: pointer;
    }

    .xWSMTSALRequest{
        cursor: pointer;
    }
    .xWOverlayLodingChart{
        position: absolute;
	    min-width: 100%;
	    min-height: 100%;
	    width: 100%;
	    background: #FFFFFF;
	    z-index: 2500;
	    display: none;
	    top: 0%;
        margin-left: 0px;
        left: 0%;
    }
</style>
<?php
$dDateToday         = date("Y-m-d");
$dFirstDateOfMonth  = $dDateToday;
$dLastDateOfMonth   = $dDateToday;
?>
<div class="row">
  
    <form id="ofmUPGAuto" class="validate-form" action="javascript:void(0)" method="post" enctype="multipart/form-data">
    <!-- input ค่า sort กับ ฟิวช์ ที่ส่งไป query ของ Total By Branch -->
    <input type="hidden" id="oetDSHSALSort" name="oetDSHSALSort" value="DESC">
    <input type="hidden" id="oetDSHSALFild" name="oetDSHSALFild" value="FDCreateOn">
    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
        <!-- Panel Sale Data -->
        <div id="odvSMTSALPanelRight1" class="">
            <div >
                <div class="panel-body xWSMTSALPanelMainRight">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <div class="">
                                <div class="col-md-12 xWSMTSALHeadPanel">
                                    <div class="col-xs-12 col-sm-6 col-md-12 col-lg-12 p-l-0">
                               
                                        <div class="col-xs-12 col-sm-8 col-md-12 col-lg-12 " style="padding:0px;margin-top:0.3rem; ">

                                        <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 p-l-0">
                                            <div class="form-group">
                                                <label class="xCNLabelFrm" style="margin-right: 10px; margin-top: 5px;"><?php echo language('tool/tool/tool','tSMTSALModalAgency'); ?></label>
                                                <div class="input-group">
                                                    <input type="text" class="form-control xCNHide" id="oetUPGAgnStaAll" name="oetUPGAgnStaAll">
                                                    <input type="text" class="form-control xCNHide" id="oetUPGAgnCode" name="oetUPGAgnCode" value="<?=$this->session->userdata('tSesUsrAgnCode')?>">
                                                    <input type="text" class="form-control xWPointerEventNone" id="oetUPGAgnName" name="oetUPGAgnName" value="<?=$this->session->userdata('tSesUsrAgnName')?>" readonly>
                                                    <span class="input-group-btn">
                                                    <button id="obtUPGSALFilterAgn" type="button" class="btn xCNBtnBrowseAddOn"
                                                    <?php if($this->session->userdata("tSesUsrAgnCode")!=''){ echo 'disabled'; } ?>
                                                    ><img class="xCNIconFind"></button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 p-l-0">
                                            <div class="form-group">
                                                <label class="xCNLabelFrm" style="margin-right: 10px; margin-top: 5px;"><?php echo language('tool/tool/tool','tSMTSALModalBranch'); ?></label>
                                                <div class="input-group">
                                                    <input type="text" class="form-control xCNHide" id="oetUPGBchStaAll" name="oetUPGBchStaAll">
                                                    <input type="text" class="form-control xCNHide" id="oetUPGBchCode" name="oetUPGBchCode" value="">
                                                    <input type="text" class="form-control xWPointerEventNone" id="oetUPGBchName" name="oetUPGBchName" value="" readonly>
                                                    <span class="input-group-btn">
                                                    <button id="obtUPGSALFilterBch" type="button" class="btn xCNBtnBrowseAddOn"
                                                   
                                                    ><img class="xCNIconFind"></button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 p-l-0">
                                            <div class="form-group">
                                                <label class="xCNLabelFrm" style="margin-right: 10px; margin-top: 5px;"><?php echo language('tool/tool/tool','tSMTSALModalPos'); ?></label>
                                                <div class="input-group">
                                                    <input type="text" class="form-control xCNHide" id="oetUPGPosStaAll" name="oetUPGPosStaAll">
                                                    <input type="text" class="form-control xCNHide" id="oetUPGPosCode" name="oetUPGPosCode" >
                                                    <input type="text" class="form-control xWPointerEventNone" id="oetUPGPosName" name="oetUPGPosName" readonly>
                                                    <span class="input-group-btn">
                                                    <button id="obtUPGBrowsPos" type="button" class="btn xCNBtnBrowseAddOn" disabled><img class="xCNIconFind"></button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>


                                        <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 p-l-0" >
                                            <div class="form-group">
                                            <label class="xCNLabelFrm" style="margin-left: 10px;  margin-right: 10px; margin-top: 5px;"><?php echo language('tool/tool/tool','tSMTSALStatus');?></label>
                                                <select class="selectpicker form-control" id="oetUPGBillType" name="oetUPGBillType" maxlength="1" >
                                                    <option value="" selected><?php echo language('tool/tool/tool','tRPNBillType0');?></option>
                                                    <option value="0" ><?php echo language('tool/tool/tool','tlogUPGStaProcess0');?></option>
                                                    <option value="1" ><?php echo language('tool/tool/tool','tlogUPGStaProcess1');?></option>
                                                    <option value="2" ><?php echo language('tool/tool/tool','tlogUPGStaProcess2');?></option>
                                                    <option value="3" ><?php echo language('tool/tool/tool','tlogUPGStaProcess3');?></option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 p-l-0">
                                            <div class="form-group">
                                                <label class="xCNLabelFrm" style="margin-right: 10px; margin-top: 5px;"><?php echo language('tool/tool/tool','tlogUPGUUIDFrm'); ?></label>
                                                <div class="input-group">
                                                    <input type="text" class="form-control xWPointerEventNone" id="oetUPGUUIDFrm" name="oetUPGUUIDFrm" readonly>
                                                    <span class="input-group-btn">
                                                    <button id="obtUPGUUIDFrm" type="button" class="btn xCNBtnBrowseAddOn"><img class="xCNIconFind"></button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>



                                        <div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 " style="margin-top: 26px;">   
                                                    <button type="button" id="obtUPGReload" class="btn btn-primary" style="width:100%" >
                                                        <span><?=language('tool/tool/tool', 'tSTLToolsPreView')?></span>			
                                                    </button>
                                        </div>

                                        </div>
                                    </div>

                            
                                        
                                    </div>
                                </div>

                                

                                <div class="col-md-12 xWSMTSALDataPanel"  id="odvPanelUPGData" >
                            
                                </div>
                                <div class="xWOverlayLodingChart" data-keyfilter="FSD">
                                    <img src="<?php echo base_url(); ?>application/modules/common/assets/images/ada.loading.gif" class="xWImgLoading">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>

 
    </div>
</form>
</div>
<div id="odvSMTSALModalFilterHTML"></div>
<script type="text/javascript">
    var nLangEdits  = '<?php echo $this->session->userdata("tLangEdit");?>';
    $(document).ready(function(){

        
        $('.selectpicker').selectpicker('refresh');
        $('.xCNDatePicker').datepicker({
            format: "yyyy-mm-dd",
            todayHighlight: true,
            enableOnReadonly: false,
            disableTouchKeyboard : true,
            autoclose: true
        });

        // Event Click Button Filter Date Data Form
        $('#obtUPGDataForm').unbind().click(function(){
            $('#oetUPGDataForm').datepicker('show');
        });

        // Event Click Button Filter Date Data To
        $('#obtUPGDataTo').unbind().click(function(){
            $('#oetUPGDataTo').datepicker('show');
        });


        // $('#oetUPGDataForm').change(function(){
        //     JCNxOpenLoading();
        //     JCNxUPGDataTable();
        // });

        // $('#oetUPGDataTo').change(function(){
        //     JCNxOpenLoading();
        //     JCNxUPGDataTable();
        // });





        $('#ocbSMTRequestRepairing').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
            JSxSMTControlTableData();
            }else{
                JCNxShowMsgSessionExpired();
            }
        });

        $('#ocbSMTDataRequest').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
            JSxSMTControlTableData();
            }else{
                JCNxShowMsgSessionExpired();
            }
        });


        $('#ocbSMTInformationShitf').unbind().click(function(){
            // let nStaSession = JCNxFuncChkSessionExpired();
            // if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
            JSxSMTControlTableData();
            // }else{
            //     JCNxShowMsgSessionExpired();
            // }
         
        });

        JCNxUPGDataTable();
      
        $('.filter-option-inner-inner').css('margin-top','-2px');
    });

    $('#ocmUPGBillStaRun').on('change',function(){
        JCNxOpenLoading();
        JCNxUPGDataTable();
    });

    $('#obtUPGReload').click(function(){
           JCNxOpenLoading();
            JCNxUPGDataTable();
    });

    $('.xWUPG').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
                let tFilterDataKey  = $(this).data('keyfilter');
                let tFilterDataGrp  = $(this).data('keygrp');
                JSvSMTSALCallModalFilterDashBoard(tFilterDataKey,tFilterDataGrp);
            }else{
                JCNxShowMsgSessionExpired();
            }
        });


        // Event Click Browse Multi Branch
        $('#obtUPGSALFilterAgn').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
                JSxCheckPinMenuClose(); // Hidden Pin Menu
                var tSesUsrAgnCode = "<?=$this->session->userdata('tSesUsrAgnCode')?>";
                                // ********** Check Data Branch **********
                let tTextWhereInBranch      = '';
                if(tSesUsrAgnCode != ''){
                    var tSesUsrAgnCode = "<?=$this->session->userdata('tSesUsrAgnCode')?>";
                    tTextWhereInBranch      = " AND (TCNMAgency.FTAgnCode  ='"+tSesUsrAgnCode+"' )";
                }

                window.oSMTSALBrowseAgnOption   = undefined;
                oSMTSALBrowseAgnOption          = {
                    Title   : ['ticket/agency/agency','tAggTitle'],
                    Table   : {Master:'TCNMAgency',PK:'FTAgnCode'},
                    Join    : {
                        Table   : ['TCNMAgency_L'],
                        On      : ['TCNMAgency_L.FTAgnCode = TCNMAgency.FTAgnCode AND TCNMAgency_L.FNLngID = '+nLangEdits]
                    },
                    Where :{
                        Condition : [tTextWhereInBranch]
                    },
                    GrideView:{
                        ColumnPathLang  	: 'ticket/agency/agency',
                        ColumnKeyLang	    : ['tAggCode','tAggName'],
                        ColumnsSize         : ['15%','75%'],
                        WidthModal          : 50,
                        DataColumns		    : ['TCNMAgency.FTAgnCode','TCNMAgency_L.FTAgnName'],
                        DataColumnsFormat   : ['',''],
                        Perpage			: 10,
                        OrderBy			    : ['TCNMAgency_L.FTAgnCode ASC'],
                    },
                    CallBack:{
                        ReturnType	: 'S',
                        Value		: ['oetUPGAgnCode','TCNMAgency.FTAgnCode'],
                        Text		: ['oetUPGAgnName','TCNMAgency_L.FTAgnName']
                    },
           
                };
                JCNxBrowseData('oSMTSALBrowseAgnOption');
            }else{
                JCNxShowMsgSessionExpired();
            }
        });


        // Event Click Browse Multi Branch
        $('#obtUPGSALFilterBch').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
                JSxCheckPinMenuClose(); // Hidden Pin Menu
                var nSesUsrBchCount = "<?=$this->session->userdata('nSesUsrBchCount')?>";
                var tUPGBchCode = $('#oetUPGAgnCode').val();
                                // ********** Check Data Branch **********
                let tTextWhereInBranch      = '';
                if(nSesUsrBchCount > 0){
                    var tDataBranch = "<?=$this->session->userdata('tSesUsrBchCodeMulti')?>";
                    tTextWhereInBranch      = " AND (TCNMBranch.FTBchCode IN ("+tDataBranch+") )";
                }

                if(tUPGBchCode!=''){
                    tTextWhereInBranch      += " AND (TCNMBranch.FTAgnCode ='"+tUPGBchCode+"' )";
                }
                window.oSMTSALBrowseBchOption   = undefined;
                oSMTSALBrowseBchOption          = {
                    Title   : ['company/branch/branch','tBCHTitle'],
                    Table   : {Master:'TCNMBranch',PK:'FTBchCode'},
                    Join    : {
                        Table   : ['TCNMBranch_L'],
                        On      : ['TCNMBranch_L.FTBchCode = TCNMBranch.FTBchCode AND TCNMBranch_L.FNLngID = '+nLangEdits]
                    },
                    Where :{
                        Condition : [tTextWhereInBranch]
                    },
                    GrideView:{
                        ColumnPathLang  	: 'company/branch/branch',
                        ColumnKeyLang	    : ['tBCHCode','tBCHName'],
                        ColumnsSize         : ['15%','75%'],
                        WidthModal          : 50,
                        DataColumns		    : ['TCNMBranch.FTBchCode','TCNMBranch_L.FTBchName'],
                        DataColumnsFormat   : ['',''],
                        Perpage			: 10,
                        OrderBy			    : ['TCNMBranch_L.FTBchCode ASC'],
                    },
                    NextFunc:{
                        FuncName:'JSxUPGSetBrowsBch',
                        ArgReturn:['FTBchCode']
                    },
                    CallBack:{
                        ReturnType	: 'S',
                        Value		: ['oetUPGBchCode','TCNMBranch.FTBchCode'],
                        Text		: ['oetUPGBchName','TCNMBranch_L.FTBchName']
                    },
           
                };
                JCNxBrowseData('oSMTSALBrowseBchOption');
            }else{
                JCNxShowMsgSessionExpired();
            }
        });



        // Event Click Browse Multi Pos
        $('#obtUPGBrowsPos').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== 'undefined' && nStaSession == 1){
                var tFilterBchCode = $('#oetUPGBchCode').val();
                var tFilterBchCodeWhere =tFilterBchCode;
                if(tFilterBchCodeWhere!=''){
                  var tConditionWhere = " AND TCNMPos.FTBchCode = '"+tFilterBchCodeWhere+"' ";
                }else{
                    var tConditionWhere = "";
                }
                JSxCheckPinMenuClose(); // Hidden Pin Menu
                window.oSMTSALBrowsePosOption   = undefined;
                oSMTSALBrowsePosOption          = {
                    Title       : ["pos/salemachine/salemachine","tPOSTitle"],
                    Table       : { Master:'TCNMPos', PK:'FTPosCode'},
                    Join    : {
                        Table   : ['TCNMPos_L'],
                        On      : [
                            'TCNMPos.FTPosCode = TCNMPos_L.FTPosCode AND TCNMPos.FTBchCode = TCNMPos_L.FTbchCode AND TCNMPos_L.FNLngID = '+nLangEdits
                        ]
                    },
                    Where   : {
                        Condition : [tConditionWhere]
                    },
                    GrideView   : {
                        ColumnPathLang  : 'pos/salemachine/salemachine',
                        ColumnKeyLang   : ['tPOSCode','tPOSRegNo'],
                        ColumnsSize     : ['10%','80%'],
                        WidthModal      : 50,
                        DataColumns     : ["TCNMPos.FTPosCode","TCNMPos_L.FTPosName"],
                        DataColumnsFormat : ['',''],
                        Perpage			: 10,
                        OrderBy         : ['TCNMPos.FTPosCode ASC'],
                    },
                    NextFunc:{
                        FuncName:'JSxUPGSetBrowsPos',
                        ArgReturn:['FTPosCode']
                    },
                    CallBack    : {
                        ReturnType	: 'S',
                        Value       : ['oetUPGPosCode',"TCNMPos.FTPosCode"],
                        Text        : ['oetUPGPosName',"TCNMPos_L.FTPosName"]
                    }
                };
                JCNxBrowseData('oSMTSALBrowsePosOption');
            }else{
                JCNxShowMsgSessionExpired();
            }
        });




                // Event Click Browse Multi Branch
                $('#obtUPGUUIDFrm').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
                JSxCheckPinMenuClose(); // Hidden Pin Menu
                var tUPGAgnCode = $('#oetUPGAgnCode').val();
                var tUPGBchCode = $('#oetUPGBchCode').val();
                var tUPGPosCode = $('#oetUPGPosCode').val();
                
                                // ********** Check Data Branch **********
                let tTextWhere      = '';

                if(tUPGAgnCode != ''){
                    tTextWhere      += " AND (TCNTAppDepHis.FTAgnCode = '"+tUPGAgnCode+"' )";
                }


                if(tUPGBchCode != ''){
                    tTextWhere      += " AND (TCNTAppDepHis.FTBchCode = '"+tUPGBchCode+"' )";
                }


                if(tUPGPosCode != ''){
                    tTextWhere     += " AND (TCNTAppDepHis.FTPosCode = '"+tUPGPosCode+"' )";
                }


                // var dUPGDataForm = $('#oetUPGDataForm').val();
                // var dUPGDataTo = $('#oetUPGDataTo').val();
                // if(dUPGDataForm != '' &&  dUPGDataTo!=''){
                //     tTextWhere      = " AND CONVERT (DATE, TCNTAppDepHis.FDCreateOn, 103) BETWEEN '"+dUPGDataForm+"' AND '"+dUPGDataTo+"' ";
                // }
          
           

                window.oUPGBrowseUUIDOption   = undefined;
                oUPGBrowseUUIDOption          = {
                    Title   : ['tool/tool/tool','UUID'],
                    Table   : {Master:'TCNTAppDepHis',PK:'FTXdhDocNo'},
                    Where :{
                        Condition : [tTextWhere]
                    },
                    GrideView:{
                        ColumnPathLang  	: 'tool/tool/tool',
                        ColumnKeyLang	    : ['tToolDocDate','tlogUPGRefUUID'],
                        ColumnsSize         : ['25%','65%'],
                        WidthModal          : 50,
                        DataColumns		    : ['TCNTAppDepHis.FDCreateOn','TCNTAppDepHis.FTXdhDocNo'],
                        DistinctField       : [''],
                        DataColumnsFormat   : ['',''],
                        Perpage			: 10,
                        OrderBy			    : ['TCNTAppDepHis.FDCreateOn DESC'],
                    },
                    CallBack:{
                        ReturnType	: 'S',
                        Value		: ['oetUPGUUIDFrm','TCNTAppDepHis.FTXdhDocNo'],
                        Text		: ['oetUPGUUIDFrm','TCNTAppDepHis.FTXdhDocNo']
                    },
           
                };
                JCNxBrowseData('oUPGBrowseUUIDOption');
            }else{
                JCNxShowMsgSessionExpired();
            }
        });



     // Event Click Browse Multi Branch
         $('#obtUPGUUIDTo').unbind().click(function(){
            let nStaSession = JCNxFuncChkSessionExpired();
            if(typeof(nStaSession) !== "undefined" && nStaSession == 1) {
                JSxCheckPinMenuClose(); // Hidden Pin Menu
                var tUPGBchCode = $('#oetUPGBchCode').val();
                                // ********** Check Data Branch **********
                let tTextWhere      = '';

                // if(tUPGBchCode != ''){
                //     tTextWhere      = ' AND (TLGTDocRegen.FTBchCode = "'+tUPGBchCode+'" )';
                // }

                // var tUPGPosCode = $('#oetUPGPosCode').val();
                // if(tUPGPosCode != ''){
                //     tTextWhere      = ' AND (TLGTDocRegen.FTPosCode = "'+tUPGPosCode+'" )';
                // }

                // var dUPGDataForm = $('#oetUPGDataForm').val();
                // var dUPGDataTo = $('#oetUPGDataTo').val();
                // if(dUPGDataForm != '' &&  dUPGDataTo!=''){
                //     tTextWhere      = " AND CONVERT (DATE, TLGTDocRegen.FDCreateOn, 103) BETWEEN '"+dUPGDataForm+"' AND '"+dUPGDataTo+"' ";
                // }
          
           

                window.oUPGBrowseUUIDOption   = undefined;
                oUPGBrowseUUIDOption          = {
                    Title   : ['tool/tool/tool','UUID'],
                    Table   : {Master:'TLGTDocRegen',PK:'FTLogUUID'},
                    Where :{
                        Condition : [tTextWhere]
                    },
                    GrideView:{
                        ColumnPathLang  	: 'tool/tool/tool',
                        ColumnKeyLang	    : ['tToolDocDate','tToolDocNo'],
                        ColumnsSize         : ['25%','65%'],
                        WidthModal          : 50,
                        DataColumns		    : ['TLGTDocRegen.FDLastUpdOn','TLGTDocRegen.FTLogUUID'],
                        DistinctField       : [''],
                        DataColumnsFormat   : ['',''],
                        Perpage			: 10,
                        OrderBy			    : ['TLGTDocRegen.FDLastUpdOn DESC'],
                    },
                    CallBack:{
                        ReturnType	: 'S',
                        Value		: ['oetUPGUUIDTo','TLGTDocRegen.FTLogUUID'],
                        Text		: ['oetUPGUUIDTo','TLGTDocRegen.FTLogUUID']
                    },
           
                };
                JCNxBrowseData('oUPGBrowseUUIDOption');
            }else{
                JCNxShowMsgSessionExpired();
            }
        });
        function JSxUPGSetBrowsPos(ptParam){
            // var aParam = JSON.parse(ptParam);
      
            // console.log(aParam);
            if(ptParam!='NULL'){
                $('#oetUPGNumberFirst').attr('readonly',false);
            }else{
                $('#oetUPGNumberFirst').attr('readonly',true);      
            }
        }

        function JSxUPGSetBrowsBch(ptParam){
            $('#oetUPGPosCode').val('');
            $('#oetUPGPosName').val('');
            $('#oetUPGNumberFirst').attr('readonly',true);

            if(ptParam!='NULL'){     
                $('#oetUPGPosCode').val('');
                $('#oetUPGPosName').val('');
                $('#obtUPGBrowsPos').attr('disabled',false);
            }else{
                $('#oetUPGPosCode').val('');
                $('#oetUPGPosName').val('');
                $('#obtUPGBrowsPos').attr('disabled',true);      
            }

        }
</script>
