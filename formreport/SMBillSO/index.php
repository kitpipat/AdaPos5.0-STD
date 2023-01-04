<?php
require_once "stimulsoft/helper.php";
require_once "../decodeURLCenter.php";
require_once('../../config_deploy.php');
?>
<!DOCTYPE html>

<html>
<head>
	<?php
		if(isset($_GET["infor"])){
			$aParamiterMap = array(
				"Lang","ComCode","BranchCode","DocCode","tDocDate","tDocTime","DocBchCode"
			);
			$aDataMQ = FSaHDeCodeUrlParameter($_GET["infor"],$aParamiterMap);
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
	<title>Frm_SQL_SMBillSO.mrt - Viewer</title>
	<!-- <link rel="stylesheet" type="text/css" href="css/stimulsoft.viewer.office2013.whiteblue.css">
	<script type="text/javascript" src="scripts/stimulsoft.reports.js"></script>
	<script type="text/javascript" src="scripts/stimulsoft.reports.maps.js"></script>
	<script type="text/javascript" src="scripts/stimulsoft.viewer.js"></script> -->

	<link rel="stylesheet" type="text/css" href="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/css/stimulsoft.viewer.office2013.whiteblue.css">
	<link rel="stylesheet" type="text/css" href="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/css/stimulsoft.designer.office2013.whiteblue.css">
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.reports.engine.pack.js"></script>
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.reports.export.pack.js"></script>
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.viewer.pack.js"></script>
	<script type="text/javascript" src="<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/scripts/stimulsoft.designer.pack.js"></script> 

	<?php
		StiHelper::init("handler.php", 30);
	?>
	<script type="text/javascript">
		function Start() {
			Stimulsoft.Base.StiLicense.key =
				"6vJhGtLLLz2GNviWmUTrhSqnOItdDwjBylQzQcAOiHkPkIhwQCkyxCcx+aTuRu0+xbRyp8PLcMKXOwrM" +
				"hrjtWYJwLTDjgOVM1u8uRFaIkPKP9UBWkoaJynxEz+9YAfX4iyvtQBygjWULd1kMgGAp2p6IXaINnSsy" +
				"H0AFogx4QryK3+DtNECTST+nh6eCuG5NyQDmAHmIFdx6pLY5ESinVhr4/PHiBbRuFZ+qWU9jSTbRpKSZ" +
				"HSjvKEsmjCNX5orRYljJ4IocxWAwta2X87BwjjZnjC1y6AS8WmjRCNHfLL02cC76IpvgWy483LQKVLEH" +
				"OG5JejXpIVLGM7qw5O+rUyUWePKxQLBMDnUPbiYF5fRDYwvTXzZYaB7t+6eUukdE51lclE/oQlg059Pv" +
				"7rLVYQBz2LH/KRdBB+sbOZf7+jP9uVj9ZW83nap0CPePbi5VXguTfyXd/BgTyyUKmvRMNuNDyMoUre3q" +
				"khlrMk/OPBma6TZgjbuM92By58BnK74zRS1Ln6dODBJh1X0S+W2seqQIEijtRxm02M0m8AgfV0Fqy/fC" +
				"fQh7iFOJoGZHfjWSGy3R9JVY3cChaFoZd6BuphvMQ3VmWzjLePR3Y4IonqPsuMWPlSsIfaEmTerjliAu" +
				"jOze3KxBVLq3mQdg2xKtMRo+GfPjZ+QlhHhVzzeAvJ06Wseyjw7LbH1NPWOgtlQpszzWewAbFn4C7km1" +
				"O6AUPS6ZjZvfSTzAYywJq0qWmsOpJYdP0K1Bq+D9qm94KhP6rB6HRYYkK3DqA/9KvTkvFlrTIsrbA96Z" +
				"5wQPxugzhFBP6OXn5mC2O0E+rn0EO0K8GhyYKarmIR+ZsNW/RkjoSYRE+u2id4/4tyxEKzbWDxrP+iQa" +
				"4045yI3AIH5mNHq09eXk3HiNPwMS6zwNakAaBbJKXYuJw4XPAsrLs/76V3Ee29cr4JExHUxvhR6g9hnl" +
				"mZs9eAaTOR1X7hGMdI/UTB/uw3d2otehXTkTLSKzXi/p7/t5ivhjJwVKZlsA1mzB5fcxxT3ckL0jjs6c" +
				"iEDKr3ZEwmB4Sm5nKQ/Z4C/APUU=";

			Stimulsoft.Base.Localization.StiLocalization.setLocalizationFile("<?=BASE_URL?>/formreport/AdaCoreFrmReportNew/localization/en-so.xml", true);

			// var report = new Stimulsoft.Report.StiReport();
			var report = Stimulsoft.Report.StiReport.createNewReport();
			report.loadFile("<?=$tPathFile?>");

			report.dictionary.variables.getByName("SP_nLang").valueObject 		= "<?php echo $aDataMQ["Lang"]; ?>";
			report.dictionary.variables.getByName("nLanguage").valueObject 		= "<?php echo $aDataMQ["Lang"]; ?>";
			report.dictionary.variables.getByName("SP_tCompCode").valueObject 	= "<?php echo $aDataMQ["ComCode"]; ?>";
			report.dictionary.variables.getByName("SP_tCmpBch").valueObject 	= "<?php echo $aDataMQ["BranchCode"]; ?>";
			report.dictionary.variables.getByName("SP_tDocNo").valueObject 		= "<?php echo $aDataMQ["DocCode"]; ?>";
			report.dictionary.variables.getByName("SP_tDocDate").valueObject 	= "<?php echo $aDataMQ["tDocDate"]; ?>";
			report.dictionary.variables.getByName("SP_tDocTime").valueObject 	= "<?php echo substr($aDataMQ["tDocTime"],0,5); ?>";
			report.dictionary.variables.getByName("SP_nAddSeq").valueObject 	= 10149;
			report.dictionary.variables.getByName("SP_tDocBch").valueObject 	= "<?=$aDataMQ["DocBchCode"];?>";
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
		</script>
	<?php
		}
	?>
</head>
<body onload="Start()">
	<?php
		if($aDataMQ){
	?>
	<?php if($tStaEdit!='1'){ ?>
		<div id="viewerContent"></div>
	<?php }else{ ?>
		<div id="designerContent"></div>
		<?php } ?>
	<?php
		}else{
			echo "ไม่สามารถเข้าถึงข้อมูลนี้ได้";
		}
	?>
</body>
</html>