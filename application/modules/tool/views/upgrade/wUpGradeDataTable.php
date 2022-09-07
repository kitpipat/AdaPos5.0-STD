<?php
if ($aTotalSaleByBranchData['rtCode'] == '1') {
    $nCurrentPage = $aTotalSaleByBranchData['rnCurrentPage'];
} else {
    $nCurrentPage = '1';
}
?>
<style>
    .xWRowSort {
        cursor: pointer;
    }

    .xWSpanSort {
        cursor: pointer;
    }
</style>

 <div class="table-responsive "  style="margin-top: 22px;">
    <table id="" class="table table-striped">
        <thead>
            <tr>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdSeq'); ?></th>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdAgn'); ?></th>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdBch'); ?></th>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdPos'); ?></th>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdLstRelease'); ?></th>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdLstReleaseName'); ?></th>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdLstStatus'); ?></th>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdActRelease'); ?></th>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdActReleaseName'); ?></th>
                <th nowarp class="text-center xCNTextBold xWRowSort" ><?php echo language('tool/tool/tool', 'tlogUPGTdLstUpd'); ?></th>
            </tr>
        </thead>
        <tbody>
            <?php if (!empty($aTotalSaleByBranchData['raItems'])) { ?>
                <?php foreach ($aTotalSaleByBranchData['raItems'] as $nKey => $aValue) :

                            if($aValue['FTXdsStaPrc']=='0' || $aValue['FTXdsStaPrc']==''){
                                $tLogStaServer = '<span style="color:#eeb426f5">'.language('tool/tool/tool', 'tlogUPGStaProcess0').'</span>';
                            }else if($aValue['FTXdsStaPrc']=='1'){
                                $tLogStaServer = '<span style="color:#415bed">'.language('tool/tool/tool', 'tlogUPGStaProcess1').'</span>';
                            }else if($aValue['FTXdsStaPrc']=='2'){
                                $tLogStaServer = '<span style="color:green">'.language('tool/tool/tool', 'tlogUPGStaProcess2').'</span>';
                            }else if($aValue['FTXdsStaPrc']=='3'){
                                $tLogStaServer = '<span style="color:red">'.language('tool/tool/tool', 'tlogUPGStaProcess3').'</span>';
                            }
  
                ?>
                    <tr>
                        <td nowarp  class="text-center"><?php echo $aValue['rtRowID'] ?></td>
                        <td nowarp><?php echo $aValue['FTAgnName'] ?></td>
                        <td nowarp><?php echo $aValue['FTBchCode'] ?></td>
                        <td nowarp><?php echo $aValue['FTPosCode'] ?></td>
                        <td nowarp><?php echo $aValue['FTXdhDocNo'] ?></td>
                        <td nowarp><?php echo $aValue['FTXdhDepName'] ?></td>
                        <td nowarp class="text-left"><?php echo $tLogStaServer ?></td>
                        <td nowarp><?php echo $aValue['FTXdhDocNoOld'] ?></td>
                        <td nowarp><?php echo $aValue['FTXdhDepNameOld'] ?></td>
                        <td nowarp class="text-center"><?php 
                        if(!empty($aValue['FDXdsDUpgrade'])){
                            echo date('d/m/Y H:i:s',strtotime($aValue['FDXdsDUpgrade']));
                        }else{
                            echo '';
                        }
                        ?></td>
                    </tr>
                <?php endforeach; ?>
            <?php }else{ ?>
                <tr>
                    <td colspan="9" align="center"><?php echo language('tool/tool/tool', 'tToolDataNotFound'); ?></td>    
                <tr>
          <?php  } ?>
        </tbody>
    </table>
</div>


<div class="row">
    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
        <p><?php echo language('common/main/main', 'tResultTotalRecord') ?> <?php echo $aTotalSaleByBranchData['rnAllRow'] ?> <?php echo language('common/main/main', 'tRecord') ?> <?php echo $aTotalSaleByBranchData['rnCurrentPage'] ?> / <?php echo $aTotalSaleByBranchData['rnAllPage'] ?></p>
    </div>
    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
        <div class="xWPageUPG btn-toolbar pull-right">
            <?php if ($nPage == 1) {
                $tDisabledLeft = 'disabled';
            } else {
                $tDisabledLeft = '-';
            } ?>
            <button onclick="JSvUPGClickPage('previous')" class="btn btn-white btn-sm" <?php echo $tDisabledLeft ?>>
                <i class="fa fa-chevron-left f-s-14 t-plus-1"></i>
            </button>
            <?php for ($i = max($nPage - 2, 1); $i <= max(0, min($aTotalSaleByBranchData['rnAllPage'], $nPage + 2)); $i++) { ?>
                <?php
                if ($nPage == $i) {
                    $tActive = 'active';
                    $tDisPageNumber = 'disabled';
                } else {
                    $tActive = '';
                    $tDisPageNumber = '';
                }
                ?>
                <button onclick="JSvUPGClickPage('<?php echo $i ?>')" type="button" class="btn xCNBTNNumPagenation <?php echo $tActive ?>" <?php echo $tDisPageNumber ?>><?php echo $i ?></button>
            <?php } ?>
            <?php if ($nPage >= $aTotalSaleByBranchData['rnAllPage']) {
                $tDisabledRight = 'disabled';
            } else {
                $tDisabledRight = '-';
            } ?>
            <button onclick="JSvUPGClickPage('next')" class="btn btn-white btn-sm" <?php echo $tDisabledRight ?>>
                <i class="fa fa-chevron-right f-s-14 t-plus-1"></i>
            </button>
        </div>
    </div>
</div>

<script>
$('#ocbListItemAll').click(function(){
            if($("#ocbListItemAll:checkbox:checked").is(':checked')==true){
                $('.ocbATLListItem').not(':disabled').prop('checked',true);
            }else{
                $('.ocbATLListItem').not(':disabled').prop('checked',false);
            }
});

$('.ocbATLListItem').click(function(){
            if($(this).is(':checked')==false){
                $('#ocbListItemAll').prop('checked',false);
            }
});

</script>


