<style>
.tableFixHead          { overflow: auto; height: 160px; width: 'auto';  padding-left: 15px; padding-right: 15px; }
.tableFixHead thead th { position: sticky; top: 0; z-index: 1; }
.tableFixHead tbody th { position: sticky; left: 0; }
.xRefIntTable  { border-collapse: collapse; width: 100%; }
.xRefIntTh { white-space: nowrap; background:#eee; }
.xRefIntTd { white-space: nowrap; }

    #otbRftSelectReport>thead>tr>td.xActiveRpt, 
    #otbRftSelectReport>tbody>tr>td.xActiveRpt, 
    #otbRftSelectReport>tfoot>tr>td.xActiveRpt, 
    #otbRftSelectReport>thead>tr>th.xActiveRpt, 
    #otbRftSelectReport>tbody>tr>th.xActiveRpt, 
    #otbRftSelectReport>tfoot>tr>th.xActiveRpt, 
    #otbRftSelectReport>thead>tr.xActiveRpt>td, 
    #otbRftSelectReport>tbody>tr.xActiveRpt>td, 
    #otbRftSelectReport>tfoot>tr.xActiveRpt>td, 
    #otbRftSelectReport>thead>tr.xActiveRpt>th, 
    #otbRftSelectReport>tbody>tr.xActiveRpt>th, 
    #otbRftSelectReport>tfoot>tr.xActiveRpt>th {
        background-color: #31adea;
        color: #FFFFFF !important;
}

</style>
<?php if($tIframeNameID=='oifPrint'){ ?>
<section>
        <div class="form-check form-check-inline">
            <input class="form-check-input xCNRftRadioPrint" type="radio" name="orbPrintRft"  id="orbPrintRft1"  value="1" checked>
            <label class="form-check-label" for="orbPrintRft1">&nbsp;<?=language('document/taxinvoice/taxinvoice', 'tTAXPrintAll'); ?></label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input xCNRftRadioPrint" type="radio" name="orbPrintRft"  id="orbPrintRft2" value="2">
            <label class="form-check-label" for="orbPrintRft2">&nbsp;<?=language('document/taxinvoice/taxinvoice', 'tTAXPrintBypage'); ?></label>
        </div>

        <div class="form-group xCNPrintByPage" style="display:none;">
            <label class="xCNLabelFrm" style="margin-top: 5px;"><?=language('document/taxinvoice/taxinvoice', 'tTAXPrintBypageKey'); ?></label>
            <input type="text" class="form-control xWTooltipsBT xCNInputWithoutSpcNotThai xCNInputWithoutSingleQuote xCNInputNumericWithDecimal" id="oetPrintAgainRft" name="oetPrintAgainRft" maxlength="2" value=""
                    placeholder="<?=language('document/taxinvoice/taxinvoice', 'tTAXPrintBypageKey'); ?>">
        </div>

        <script>
            $('.xCNRftRadioPrint').change(function(e) {
                var nValue = $(this).val();
                if(nValue == 2){
                    $('.xCNPrintByPage').css('display','block');
                }else{
                    $('.xCNPrintByPage').css('display','none');
                }
            });
    </script>
   
</section>
<?php } ?>
<?php 
if(FCNnHSizeOf($aItems['raItems'])>1){
    if($tIframeNameID=='oifPrint'){ 
            echo '<hr>';
    }
    $tDivHide= '';
    $tRptClassAvtive2 = '';
}else{
    $tDivHide= 'none';
    $tRptClassAvtive2 = 'xActiveRpt';
}
    ?>
<!--layout table-->
<div class="tableFixHead row" style="display:<?=$tDivHide?>">
  <table class="table xRefIntTable"  id="otbRftSelectReport">
    <thead>
        <tr>
                <th class='xCNTextBold xRefIntTh' ><?=language('report/report/report','tRPAPleaseSelectReportFrom')?></th>
        </tr>
    </thead>   
    <tbody >
        <?php 
                if(!empty($aItems['raItems'])){
                    foreach($aItems['raItems'] AS $aData){
                        if($aData['FTRfuStaUsrDef']=='1'){
                            $tRptClassAvtive = 'xActiveRpt';
                        }else{
                            $tRptClassAvtive = '';
                        }
        ?>
            <tr class="panel-heading xSelectRptCode <?=$tRptClassAvtive?> <?=$tRptClassAvtive2?>" style="cursor:pointer;"
                    agncode="<?=$aData['FTAgnCode']?>"
                    rptpath="<?=$aData['FTRptPath']?>"
                    rptfilename="<?=$aData['FTRptFileName']?>"
                    >
                <td class="text-left xCNTextDetail2 xRefIntTd"  >
                <?=$aData['FTRtpName']?> 
                <?php if($aData['FTAgnCode']==''){ echo '(มารตฐาน)'; } ?>
                </td>
            </tr>
           <?php    } 
                        } ?>
        </tbody>
</table>
</div>
<script>
$('.xSelectRptCode').click(function(){
    var tBchCode = $(this).data('bchcode');
    var tDocNo = $(this).data('docno');
    $('.xSelectRptCode').removeClass('xActiveRpt');
    $(this).addClass('xActiveRpt');
})

if($('.xActiveRpt').length==0){
    $('.xSelectRptCode:first').addClass('xActiveRpt');
}

</script>
