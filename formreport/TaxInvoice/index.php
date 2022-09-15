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
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.reports.engine.pack.js"></script>
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.reports.export.pack.js"></script>
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.viewer.pack.js"></script>

	<?php
		if(isset($_GET["infor"])){
			$aParamiterMap = array(
				"Lang","ComCode","BranchCode","DocCode","DocBchCode"
			);
			$aDataMQ 		= FSaHDeCodeUrlParameter($_GET["infor"],$aParamiterMap);
			$tGrandText 	= $_GET["Grand"];
			$PrintByPage 	= $_GET["PrintByPage"];
		}else{
			$aDataMQ = false;
		}
		if($aDataMQ){
	?>

	<?php
		StiHelper::init("handler.php", 30);
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
				"6vJhGtLLLz2GNviWmUTrhSqnOItdDwjBylQzQcAOiHm8ftXz4NowX0TSVFSGC3hzl24Z2GpTfR9S0kss" +
				"No0qvNZDaEB9/QCz1e36fOCwGuS4P6J5H4z+T8P4KjruMgpwINaByP2PA1782kD3aWKiYV7oWbaJBC5c" +
				"ZuAbw1oB6f6idkL4KNRMKij6hfA0En/wALgKLxC68Th5rQJu0CNUJQ5VZtYQF7V30oqQaFULllmwsQ4R" +
				"qusbDBiJehlS+upneaVr+5tWXC7ZLe2WsYmjVfUN+enl0FWGPuVuz9iPYgRR2HpcX4D+KGs08KKSDCxU" +
				"1hD42FTZQn6TrecG9FyPJCUdlIKA7BdUc/MiAJjVedYuktJmcJveveWjygCY/EuMgMVg2lGs6+cw8rOG" +
				"Yc6zTLT/RIXv6CLL12TY6Smy4LF9HxXz8aIpOIhtYgMXOqpUqsgCHwQuohOKLUOwjEzaYoM8EbK4eLsD" +
				"I+3VfHuI6aJcOiQ0opZeZiJb8Y4WfyOFH0hpR42s8Q9zmgDGyJBeg7xD17Od7tAyIq9teng2SzTg4CnU" +
				"zvUlg61W56fxY8GDB4PQBJOZYwKJG/mnLWWj35CX08wu9vFBEULsn8CHkfACDezrW5AJo+7dejc2vrWB" +
				"SyGIiMwOi+YCaizHhW/JcKerZi3+A+/7J8jimH6SlHsEvusOgzlcsaUqM9+IglHHeZQ3ySQDHmJ6BQnG" +
				"tYLuIAeoy6Yjp4Az6Pj0bKWhEDNh2LUC3ww0U5Vt6vEjQ2TenAUMG2tFxdDt/ZaFTMC/G8oc5gL43LtT" +
				"jdxoQPw64X8ebaOeMt5u8/ANBaSb3r6FfFyUqhSo9+Nqetu/fiZ1bYVAew2QI1WdxDc9EH8swebLtXQ1" +
				"4TI2g+jw1epXS2GTiNgQNqs9DCDlaSKm+N8EdJgpcTDOSLev9asX6iPqNtIFM7CUVykR1WcG6WyVqM1v" +
				"VYHtgpiYZc16NXoCCqvav+R6pjCpXK+fSs/VGIdqosZD1Nwzixtnsr++9lfTThu0HWsca1Ul2CMVwyDD" +
				"Jtpyk7HQFMdj/aTni+iaGpqvDN8=";

			Stimulsoft.Base.Localization.StiLocalization.setLocalizationFile("<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/localization/en.xml", true);

			var report = Stimulsoft.Report.StiReport.createNewReport();
			report.loadFile("reports/Frm_PSInvoiceSale.mrt?V=<?=date('YmdHis')?>");

			if(staprint == "Print") {
				report.onBeginProcessData = function (args, callback) {
					<?php StiHelper::createHandler(); ?>
				}


			report.dictionary.variables.getByName("SP_nLang").valueObject 		= "<?=$aDataMQ["Lang"];?>";
			report.dictionary.variables.getByName("nLanguage").valueObject 		= "<?=$aDataMQ["Lang"];?>";
			report.dictionary.variables.getByName("SP_tCompCode").valueObject 	= "<?=$aDataMQ["ComCode"];?>";
			report.dictionary.variables.getByName("SP_tCmpBch").valueObject 	= "<?=$aDataMQ["BranchCode"];?>";
			report.dictionary.variables.getByName("SP_nAddSeq").valueObject 	= 3;
			report.dictionary.variables.getByName("SP_tDocNo").valueObject 		= "<?=$aDataMQ["DocCode"];?>";
			report.dictionary.variables.getByName("SP_tStaPrn").valueObject 	= i.toString();
			report.dictionary.variables.getByName("SP_tGrdStr").valueObject 	= "<?=$tGrandText?>";
			report.dictionary.variables.getByName("SP_tDocBch").valueObject     = "<?=$aDataMQ['DocBchCode']?>";

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
			report.dictionary.variables.getByName("nLanguage").valueObject 		= "<?=$aDataMQ["Lang"];?>";
			report.dictionary.variables.getByName("SP_tCompCode").valueObject 	= "<?=$aDataMQ["ComCode"];?>";
			report.dictionary.variables.getByName("SP_tCmpBch").valueObject 	= "<?=$aDataMQ["BranchCode"];?>";
			report.dictionary.variables.getByName("SP_nAddSeq").valueObject 	= 3;
			report.dictionary.variables.getByName("SP_tDocNo").valueObject 		= "<?=$aDataMQ["DocCode"];?>";
			report.dictionary.variables.getByName("SP_tStaPrn").valueObject 	=  "1";
			report.dictionary.variables.getByName("SP_tGrdStr").valueObject 	= "<?=$tGrandText?>";
			report.dictionary.variables.getByName("SP_tDocBch").valueObject     = "<?=$aDataMQ['DocBchCode']?>";

			var options = new Stimulsoft.Viewer.StiViewerOptions();
			options.appearance.fullScreenMode = true;
			options.toolbar.displayMode = Stimulsoft.Viewer.StiToolbarDisplayMode.Separated;
			options.toolbar.showPrintButton = false;
			options.toolbar.showSaveButton = false;
			options.toolbar.showDesignButton = false;
			options.toolbar.showAboutButton = false;
			var viewer = new Stimulsoft.Viewer.StiViewer(options, "StiViewer", false);

			viewer.onPrepareVariables = function (args, callback) {
				Stimulsoft.Helper.process(args, callback);
			}

			viewer.onBeginProcessData = function (args, callback) {
				Stimulsoft.Helper.process(args, callback);
			}

			viewer.report = report;
			viewer.renderHtml("viewerContent");
			}
		}
	</script>
		<?php
		}
	?>
</head>
<body onload="ProcessForm()">
	<div id="viewerContent"></div>
</body>
</html>