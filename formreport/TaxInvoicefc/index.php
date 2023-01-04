<?php
require_once "stimulsoft/helper.php";
require_once "../decodeURLCenter.php";
require_once('../../config_deploy.php');
?>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Frm_PSInvoiceSale.mrt - Viewer</title>
	<link rel="stylesheet" type="text/css" href="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/css/stimulsoft.viewer.office2013.whiteblue.css">
	<link rel="stylesheet" type="text/css" href="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/css/stimulsoft.designer.office2013.whiteblue.css">
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.reports.engine.js"></script>
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.reports.export.js"></script>
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.viewer.js"></script>
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.designer.js"></script> 

	<?php
		if(isset($_GET["infor"])){
			$aParamiterMap = array(
				"Lang","ComCode","BranchCode","DocCode","DocBchCode"
			);
			$aDataMQ 		= FSaHDeCodeUrlParameter($_GET["infor"],$aParamiterMap);
			$tGrandText 	= $_GET["Grand"];
			$PrintByPage 	= $_GET["PrintByPage"];
			$tAgncode 	= $_GET["Agncode"];
			$tFilename 	= $_GET["Filename"];
			$tPathFile = '';
			if(!empty($tAgncode)){
				$tPathFile=$tFilename;
			}else{
				$tPathFile='reports/'.$tFilename;
			}

			$tStaEdit 	= @$_GET["StaEdit"];
		}else{
			$aDataMQ = false;
		}
		if($aDataMQ){
	?>

	<?php
		$options = StiHelper::createOptions();
		$options->handler = "handler.php";
		$options->timeout = 30;
		StiHelper::initialize($options);
	?>
	<script type="text/javascript">
		var showAlert = true;
		
		function ProcessForm() {
			staPrint = '<?=$_GET["StaPrint"];?>';
			if(staPrint == 0){
				Start("Preview","")
			}else{

				nPrintOriginal 	= '<?=$_GET["PrintOriginal"];?>';
				nPrintCopy 		= '<?=$_GET["PrintCopy"];?>';
				aPackData 		= [];

				var nPrint = parseInt(nPrintOriginal) + parseInt(nPrintCopy);
				for(j=1; j<=nPrintOriginal; j++){
					aPackData.push(1);
				}

				for(k=1; k<=nPrintCopy; k++){
					aPackData.push(2);
				}

				//วนลูปปริ้้นเอกสาร
				for(i=0;i<nPrint;i++){
					Start("Print",aPackData[i])
				}
			}
		}
		
		function Start(staprint , i) {
			Stimulsoft.Base.StiLicense.key =
				"6vJhGtLLLz2GNviWmUTrhSqnOItdDwjBylQzQcAOiHlxd6bn81jYQswEUbfVJhgRQVXQSIb753lgwE8N" +
				"1L3elUTO52gcD5ywKTUb1A/1wKL8wEsIzmIcMbLqb/NYe09kbTuOxJksbAqRDsMKUrzeELdOpt097xfN" +
				"gFJfBiQuwFKB+fk3u76bRQ1cX6PBw9bEkR5nUOrxQG/GKZ64sIzKx1k1ouIrqdvoE3qmDDgWSHILXaZD" +
				"D0JD4pXXF2zX/7+zq49gh3Wwr0U5VCYPA/rjmEqLE8jUz0TnviU9NIldlY/W7NN7O0aVab/zsarkCN2q" +
				"oMCr/hM/HpCtE4S8+FeQkiIbcDVE43683QWwD7OuSVQ2tESN0yY5Ljf2YSnsCbs/PKQF/0Y1OawNFAQV" +
				"H7azuUrg67LYCFtn9+ltAMlCFwe351zlbEG99qo/a5U+W32nj8X9D5S1E0ksmCBlcKDHocMNbcLqz71m" +
				"jJu8yPhq92AI0ufmKvzxcpmBGycxe6fuuQz62X81XG6iWGZ6psdCMKO4D9+eebHerJrLoAwG8/8r7Eb8" +
				"IOx4yVxt5ZsbU3fJqDjZVDC/OmdUCe5LdgxooshUkLPXzYr+TXWc4SBmIqb2SqOfw6vR4hbD6M6Zgfbt" +
				"4PJhXTdtE+BNPL3hpxS9vLtRGLvH6xOaE7l3IC5OcwLFKlFZKVfkWnkyqiHzIOYvfNFzDnq92DoW8xkj" +
				"4f3lRlhERPGQ7/aexwTzbDmDd3v2bKirjNH2OArGRJMeJSgVV3tPlVRMrYzm3nbPSuiv08cQRGyXGI+3" +
				"Vt4qiRdYIZMoe65OC8c3yts7UcqIc/2BIKZwXtCUd1hnb4JB5apKa3tbTKD28ilpWJy9qB+X7iMVW6Zt" +
				"hFv894r92a58PsTNBvgyrH6FSCcvyqbX6Pu7lR4BTxhfmN4WoOEvwqN7RPF98YWk1kW4CdqtqJ56RBvn" +
				"cz5NbvBC+HhicBgk68W/N0178xEZQ/0KJJIn+Hhspom6MY56hQxGNhFDGvlrNF4tQ12fp0f+OT9rZRnx" +
				"+EqQWyKtau3QC4/K5VxWlPiFxGw=";

			Stimulsoft.Base.Localization.StiLocalization.setLocalizationFile("<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/localization/en-GB.xml", true);

			// var report = Stimulsoft.Report.StiReport.createNewReport();
			var report = new Stimulsoft.Report.StiReport();
			report.loadFile("<?=$tPathFile?>");
		
			if(staprint == "Print") {
				report.onBeginProcessData = function (args, callback) {
					<?php StiHelper::createHandler(); ?>
				}
				report.dictionary.variables.getByName("SP_nLang").valueObject 		= "<?=$aDataMQ["Lang"];?>";
				report.dictionary.variables.getByName("nLanguage").valueObject 		= <?=$aDataMQ["Lang"];?>;
				report.dictionary.variables.getByName("SP_tCompCode").valueObject 	= "<?=$aDataMQ["ComCode"];?>";
				report.dictionary.variables.getByName("SP_tCmpBch").valueObject 	= "<?=$aDataMQ["BranchCode"];?>";
				report.dictionary.variables.getByName("SP_nAddSeq").valueObject 	= 3;
				report.dictionary.variables.getByName("SP_tDocNo").valueObject 		= "<?=$aDataMQ["DocCode"];?>";
				report.dictionary.variables.getByName("SP_tStaPrn").valueObject 	= i.toString();
				report.dictionary.variables.getByName("SP_tGrdStr").valueObject 	= "<?=$tGrandText?>";
				report.renderAsync(function(){
					if('<?=$PrintByPage?>' == 'ALL'){
						report.print();
					}else{	
						var nCount = report.pages.report.renderedPages.count;
						if(parseInt('<?=$PrintByPage?>') > nCount){
							if (showAlert==true){
								alert ("ไม่พบเลขหน้าที่ระบุ");
								showAlert = false;
							}
						}else{
							var nPage 		= parseInt('<?=$PrintByPage?>') - parseInt(1);
							var pageRange 	= new Stimulsoft.Report.StiPagesRange(Stimulsoft.Report.StiRangeType.CurrentPage,nPage,nPage);
							report.print(pageRange);
						}
					}
				});
			}else{
			
				report.dictionary.variables.getByName("SP_nLang").valueObject 		= "<?=$aDataMQ["Lang"];?>";
				report.dictionary.variables.getByName("nLanguage").valueObject 		= <?=$aDataMQ["Lang"];?>;
				report.dictionary.variables.getByName("SP_tCompCode").valueObject 	= "<?=$aDataMQ["ComCode"];?>";
				report.dictionary.variables.getByName("SP_tCmpBch").valueObject 	= "<?=$aDataMQ["BranchCode"];?>";
				report.dictionary.variables.getByName("SP_nAddSeq").valueObject 	= 3;
				report.dictionary.variables.getByName("SP_tDocNo").valueObject 		= "<?=$aDataMQ["DocCode"];?>";
				report.dictionary.variables.getByName("SP_tStaPrn").valueObject 	= "1";
				report.dictionary.variables.getByName("SP_tGrdStr").valueObject 	= "<?=$tGrandText?>";

				<?php if($tStaEdit!='1'){ ?>
					var options = new Stimulsoft.Viewer.StiViewerOptions();
					options.appearance.fullScreenMode = true;
					options.toolbar.displayMode = Stimulsoft.Viewer.StiToolbarDisplayMode.Separated;
					
					var viewer = new Stimulsoft.Viewer.StiViewer(options, "StiViewer", false);

					viewer.onPrepareVariables = function (args, callback) {
						Stimulsoft.Helper.process(args, callback);
					}

					viewer.onBeginProcessData = function (args, callback) {
						Stimulsoft.Helper.process(args, callback);
					}

					viewer.report = report;
					viewer.renderHtml("viewerContent");
				<?php }else{ ?>
				var options = new Stimulsoft.Designer.StiDesignerOptions();
				console.log(options);
				options.appearance.fullScreenMode = true;
				options.toolbar.showSaveButton = false;
				options.toolbar.showFileMenuSave = false;
				
				var designer = new Stimulsoft.Designer.StiDesigner(options, "StiDesigner", false);

				designer.onPrepareVariables = function (args, callback) {
				Stimulsoft.Helper.process(args, callback);
				}

				designer.onBeginProcessData = function (args, callback) {
					<?php StiHelper::createHandler(); ?>
				}

				designer.onSaveReport = function (args) {
					<?php StiHelper::createHandler(); ?>
				}

				designer.report = report;
				designer.renderHtml("designerContent");
				<?php } ?>
			}
		}
	</script>
	<?php
		}
	?>
</head>
<?php if($tStaEdit!='1'){ ?>
<body onload="ProcessForm()">
	<div id="viewerContent"></div>
</body>
<?php }else{ ?>
<body onload="Start()">
	<div id="designerContent"></div>
</body>
<?php } ?>
</html>