<?php

defined('BASEPATH') or exit('No direct script access allowed');

include APPPATH . 'third_party/PHPExcel/Classes/PHPExcel.php';
include APPPATH . 'third_party/PHPExcel/Classes/PHPExcel/IOFactory.php';
include APPPATH . 'third_party/PHPExcel/Classes/PHPExcel/Writer/Excel2007.php';

include APPPATH .'libraries/spout-3.1.0/src/Spout/Autoloader/autoload.php';
use Box\Spout\Writer\Common\Creator\WriterEntityFactory;
use Box\Spout\Common\Entity\Row;
use Box\Spout\Common\Entity\Style\Border;
use Box\Spout\Writer\Common\Creator\Style\BorderBuilder;
use Box\Spout\Common\Entity\Style\Color;
use Box\Spout\Writer\Common\Creator\Style\StyleBuilder;
use Box\Spout\Common\Entity\Style\CellAlignment;

class cRptCheckStatusCard extends MX_Controller {

    /**
     * ภาษา
     * @var array
     */
    public $aText = [];

    /**
     * จำนวนต่อหน้าในรายงาน
     * @var int 
     */
    public $nPerPage = 100;

    /**
     * Page number
     * @var int
     */
    public $nPage = 1;

    /**
     * จำนวนทศนิยม
     * @var int
     */
    public $nOptDecimalShow = 2;

    /**
     * จำนวนข้อมูลใน Temp
     * @var int
     */
    public $nRows = 0;

    /**
     * Computer Name
     * @var string
     */
    public $tCompName;

    /**
     * User Login on Bch
     * @var string
     */
    public $tBchCodeLogin;

    /**
     * Report Code
     * @var string
     */
    public $tRptCode;

    /**
     * Report Group
     * @var string
     */
    public $tRptGroup;

    /**
     * System Language
     * @var int
     */
    public $nLngID;

    /**
     * User Session ID
     * @var string
     */
    public $tUserSessionID;

    /**
     * Report route
     * @var string
     */
    public $tRptRoute;

    /**
     * Report Export Type
     * @var string
     */
    public $tRptExportType;

    /**
     * Filter for Report
     * @var array 
     */
    public $aRptFilter = [];

    /**
     * Company Info
     * @var array
     */
    public $aCompanyInfo = [];

    /**
     * User Login Session
     * @var string 
     */
    public $tUserLoginCode;

     /**
     * Sys Bch Code 
     * @var string 
     */
    public $tSysBchCode;

    public function __construct() {
        $this->load->model('report/report/mReport');
        $this->load->model('company/company/mCompany');
        $this->load->model('report/reportcard/mRptCheckStatusCard');

        // Init Report
        $this->init();

        parent::__construct();
    }

    private function init() {
        $this->aText = [
            'tTitleReport'              => language('report/report/report', 'tRPCTitleRptCheckStatusCard'),
            'tRptTaxNo'                 => language('report/report/report', 'tRptTaxNo'),
            'tRptDatePrint'             => language('report/report/report', 'tRptDatePrint'),
            'tRptDateExport'            => language('report/report/report', 'tRptDateExport'),
            'tRptTimePrint'             => language('report/report/report', 'tRptTimePrint'),
            'tRptPrintHtml'             => language('report/report/report', 'tRptPrintHtml'),
            'tRptBranch'                => language('report/report/report', 'tRptAddrBranch'),
            'tRptFaxNo'                 => language('report/report/report', 'tRptAddrFax'),
            'tRptTel'                   => language('report/report/report', 'tRptAddrTel'),

            // Filter
            'tRptBchFrom'               => language('report/report/report', 'tRptBchFrom'),
            'tRptBchTo'                 => language('report/report/report', 'tRptBchTo'),
            'tRptMerFrom'               => language('report/report/report', 'tRptMerFrom'),
            'tRptMerTo'                 => language('report/report/report', 'tRptMerTo'),
            'tRptShopFrom'              => language('report/report/report', 'tRptShopFrom'),
            'tRptShopTo'                => language('report/report/report', 'tRptShopTo'),
            'tRptPosFrom'               => language('report/report/report', 'tRptPosFrom'),
            'tRptPosTo'                 => language('report/report/report', 'tRptPosTo'),
            'tRPCCrdTypeFrom'           => language('report/report/report','tRPCCrdTypeFrom'),
            'tRPCCrdTypeTo'             => language('report/report/report','tRPCCrdTypeTo'),
            'tRPCCrdFrom'               => language('report/report/report','tRPCCrdFrom'),
            'tRPCCrdTo'                 => language('report/report/report','tRPCCrdTo'),
            'tRPCStaCrdFrom'            => language('report/report/report','tRPCStaCrdFrom'),
            'tRPCStaCrdTo'              => language('report/report/report','tRPCStaCrdTo'),
            'tRPCDateFrom'              => language('report/report/report','tRPCDateFrom'),
            'tRPCDateTo'                => language('report/report/report','tRPCDateTo'),
            'tRPCDateStartFrom'         => language('report/report/report','tRPCDateStartFrom'),
            'tRPCDateStartTo'           => language('report/report/report','tRPCDateStartTo'),
            'tRPCDateExpireFrom'        => language('report/report/report','tRPCDateExpireFrom'),
            'tRPCDateExpireTo'          => language('report/report/report','tRPCDateExpireTo'),
            'tRPCTaxNo'                 => language('report/report/report', 'tRPCTaxNo'),

            // Table Report
            'tRPCRowNuber'              => language('report/report/report','tRPC2TBRowNuber'),
            'tRPCCardCode'              => language('report/report/report','tRPC2TBCardCode'),
            'tRPCCardHolderID'          => language('report/report/report','tRPC2TBCardHolderID'),
            'tRPCCardType'              => language('report/report/report','tRPC2TBCardType'),
            'tRPCCardName'              => language('report/report/report','tRPC2TBCardName'),
            'tRPCCardStartDate'         => language('report/report/report','tRPC2TBCardStartDate'),
            'tRPCCardExpireDate'        => language('report/report/report','tRPC2TBCardExpireDate'),
            'tRPCCardValue'             => language('report/report/report','tRPC2TBCardValue'),
            'tRPCCardDocDate'           => language('report/report/report','tRPC2TBCardDocDate'),
            'tRPCCardPosCode'           => language('report/report/report','tRPC2TBCardPosCode'),
            'tRPCTBFooterSumAll'        => language('report/report/report','tRPCTBFooterSumAll'),
            'tRPCCardDetailStaActive1'  => language('report/report/report','tRPCCardDetailStaActive1'),
            'tRPCCardDetailStaActive2'  => language('report/report/report','tRPCCardDetailStaActive2'),
            'tRPCCardDetailStaActive3'  => language('report/report/report','tRPCCardDetailStaActive3'),
            'tRptConditionInReport'     => language('report/report/report', 'tRptConditionInReport'),
            'tRptAll'                   => language('report/report/report', 'tRptAll')
        ];

        $this->tSysBchCode     = SYS_BCH_CODE;
        $this->tBchCodeLogin   = (!empty($this->session->userdata('tSesUsrBchCom')) ? $this->session->userdata('tSesUsrBchCom') : $this->session->userdata('tSesUsrBchCom'));
        $this->nPerPage        = 100;
        $this->nOptDecimalShow = FCNxHGetOptionDecimalShow();
        
        $tIP = $this->input->ip_address();
        $tFullHost = gethostbyaddr($tIP);
        $this->tCompName = $tFullHost;
        
        $this->nLngID = FCNaHGetLangEdit();
        $this->tRptCode = $this->input->post('ohdRptCode');
        $this->tRptGroup = $this->input->post('ohdRptGrpCode');
        $this->tUserSessionID = $this->session->userdata('tSesSessionID');
        $this->tRptRoute = $this->input->post('ohdRptRoute');
        $this->tRptExportType = $this->input->post('ohdRptTypeExport');
        $this->nPage = empty($this->input->post('ohdRptCurrentPage')) ? 1 : $this->input->post('ohdRptCurrentPage');
        $this->tUserLoginCode = $this->session->userdata('tSesUsername');

        // Report Filter
        $this->aRptFilter = [
            'tUserSessionID' => $this->tUserSessionID,
            'tCompName' => $this->tCompName,
            'tRptCode' => $this->tRptCode,
            'nLngID' => $this->nLngID,

            'tTypeSelect' => !empty($this->input->post('ohdTypeDataCondition')) ? $this->input->post('ohdTypeDataCondition') : "",
            
            // ประเภทบัตร
            'tCardTypeCodeFrom' => !empty($this->input->post('oetRptCardTypeCodeFrom')) ? $this->input->post('oetRptCardTypeCodeFrom') : '',
            'tCardTypeNameFrom' => !empty($this->input->post('oetRptCardTypeNameFrom')) ? $this->input->post('oetRptCardTypeNameFrom') : '',
            'tCardTypeCodeTo' => !empty($this->input->post('oetRptCardTypeCodeTo')) ? $this->input->post('oetRptCardTypeCodeTo') : '',
            'tCardTypeNameTo' => !empty($this->input->post('oetRptCardTypeNameTo')) ? $this->input->post('oetRptCardTypeNameTo') : '',
            // หมายเลขบัตร
            'tCardCodeFrom' => !empty($this->input->post('oetRptCardCodeFrom')) ? $this->input->post('oetRptCardCodeFrom') : '',
            'tCardNameFrom' => !empty($this->input->post('oetRptCardNameFrom')) ? $this->input->post('oetRptCardNameFrom') : '',
            'tCardCodeTo' => !empty($this->input->post('oetRptCardCodeTo')) ? $this->input->post('oetRptCardCodeTo') : '',
            'tCardNameTo' => !empty($this->input->post('oetRptCardNameTo')) ? $this->input->post('oetRptCardNameTo') : '',
            // สถานะบัตร
            'tStaCardFrom' => !empty($this->input->post('ocmRptStaCardFrom')) ? $this->input->post('ocmRptStaCardFrom') : '',
            'tStaCardNameFrom' => !empty($this->input->post('ohdRptStaCardNameFrom')) ? $this->input->post('ohdRptStaCardNameFrom') : '',
            'tStaCardTo' => !empty($this->input->post('ocmRptStaCardTo')) ? $this->input->post('ocmRptStaCardTo') : '',
            'tStaCardNameTo' => !empty($this->input->post('ohdRptStaCardNameTo')) ? $this->input->post('ohdRptStaCardNameTo') : '',
            // วันที่เอกสาร(DocNo)
            'tDocDateFrom' => !empty($this->input->post('oetRptDocDateFrom')) ? $this->input->post('oetRptDocDateFrom') : "",
            'tDocDateTo' => !empty($this->input->post('oetRptDocDateTo')) ? $this->input->post('oetRptDocDateTo') : "",
            // วันที่เริ่มต้น
            'tDateStartFrom' => !empty($this->input->post('oetRptDateStartFrom')) ? $this->input->post('oetRptDateStartFrom') : '',
            'tDateStartTo' => !empty($this->input->post('oetRptDateStartTo')) ? $this->input->post('oetRptDateStartTo') : '',
            // วันที่สิ้นสุด
            'tDateExpireFrom' => !empty($this->input->post('oetRptDateExpireFrom')) ? $this->input->post('oetRptDateExpireFrom') : '',
            'tDateExpireTo' => !empty($this->input->post('oetRptDateExpireTo')) ? $this->input->post('oetRptDateExpireTo') : '',


            //Fillter Agency (ตัวแทนขาย)
            'tAgnCodeSelect' => !empty($this->input->post('oetSpcAgncyCode')) ? $this->input->post('oetSpcAgncyCode') : "",
            

            // Filter Branch (สาขา)
            'tBchCodeFrom' => !empty($this->input->post('oetRptBchCodeFrom')) ? $this->input->post('oetRptBchCodeFrom') : "",
            'tBchNameFrom' => !empty($this->input->post('oetRptBchNameFrom')) ? $this->input->post('oetRptBchNameFrom') : "",
            'tBchCodeTo' => !empty($this->input->post('oetRptBchCodeTo')) ? $this->input->post('oetRptBchCodeTo') : "",
            'tBchNameTo' => !empty($this->input->post('oetRptBchNameTo')) ? $this->input->post('oetRptBchNameTo') : "",
            'tBchCodeSelect' => !empty($this->input->post('oetRptBchCodeSelect')) ? $this->input->post('oetRptBchCodeSelect') : "",
            'tBchNameSelect' => !empty($this->input->post('oetRptBchNameSelect')) ? $this->input->post('oetRptBchNameSelect') : "",
            'bBchStaSelectAll' => !empty($this->input->post('oetRptBchStaSelectAll')) && ($this->input->post('oetRptBchStaSelectAll') == 1) ? true : false,

            // Filter Merchant (กลุ่มธุรกิจ)
            'tMerCodeFrom' => (empty($this->input->post('oetRptMerCodeFrom'))) ? '' : $this->input->post('oetRptMerCodeFrom'),
            'tMerNameFrom' => (empty($this->input->post('oetRptMerNameFrom'))) ? '' : $this->input->post('oetRptMerNameFrom'),
            'tMerCodeTo' => (empty($this->input->post('oetRptMerCodeTo'))) ? '' : $this->input->post('oetRptMerCodeTo'),
            'tMerNameTo' => (empty($this->input->post('oetRptMerNameTo'))) ? '' : $this->input->post('oetRptMerNameTo'),
            'tMerCodeSelect' => !empty($this->input->post('oetRptMerCodeSelect')) ? $this->input->post('oetRptMerCodeSelect') : "",
            'tMerNameSelect' => !empty($this->input->post('oetRptMerNameSelect')) ? $this->input->post('oetRptMerNameSelect') : "",
            'bMerStaSelectAll' => !empty($this->input->post('oetRptMerStaSelectAll')) && ($this->input->post('oetRptMerStaSelectAll') == 1) ? true : false,

            // Filter Shop (ร้านค้า)
            'tShpCodeFrom' => (empty($this->input->post('oetRptShpCodeFrom'))) ? '' : $this->input->post('oetRptShpCodeFrom'),
            'tShpNameFrom' => (empty($this->input->post('oetRptShpNameFrom'))) ? '' : $this->input->post('oetRptShpNameFrom'),
            'tShpCodeTo' => (empty($this->input->post('oetRptShpCodeTo'))) ? '' : $this->input->post('oetRptShpCodeTo'),
            'tShpNameTo' => (empty($this->input->post('oetRptShpNameTo'))) ? '' : $this->input->post('oetRptShpNameTo'),
            'tShpCodeSelect' => !empty($this->input->post('oetRptShpCodeSelect')) ? $this->input->post('oetRptShpCodeSelect') : "",
            'tShpNameSelect' => !empty($this->input->post('oetRptShpNameSelect')) ? $this->input->post('oetRptShpNameSelect') : "",
            'bShpStaSelectAll' => !empty($this->input->post('oetRptShpStaSelectAll')) && ($this->input->post('oetRptShpStaSelectAll') == 1) ? true : false,

            // Filter Pos (เครื่องจุดขาย)
            'tPosCodeFrom' => (empty($this->input->post('oetRptPosCodeFrom'))) ? '' : $this->input->post('oetRptPosCodeFrom'),
            'tPosNameFrom' => (empty($this->input->post('oetRptPosNameFrom'))) ? '' : $this->input->post('oetRptPosNameFrom'),
            'tPosCodeTo' => (empty($this->input->post('oetRptPosCodeTo'))) ? '' : $this->input->post('oetRptPosCodeTo'),
            'tPosNameTo' => (empty($this->input->post('oetRptPosNameTo'))) ? '' : $this->input->post('oetRptPosNameTo'),
            'tPosCodeSelect' => !empty($this->input->post('oetRptPosCodeSelect')) ? $this->input->post('oetRptPosCodeSelect') : "",
            'tPosNameSelect' => !empty($this->input->post('oetRptPosNameSelect')) ? $this->input->post('oetRptPosNameSelect') : "",
            'bPosStaSelectAll' => !empty($this->input->post('oetRptPosStaSelectAll')) && ($this->input->post('oetRptPosStaSelectAll') == 1) ? true : false,

        ];


        // ดึงข้อมูลบริษัทฯ
        $aCompInfoParams = [
            'nLngID' => $this->nLngID,
            'tBchCode' => $this->tBchCodeLogin
        ];
        $this->aCompanyInfo = FCNaGetCompanyInfo($aCompInfoParams)['raItems'];
    }

    public function index() {

        if (!empty($this->tRptExportType) && !empty($this->tRptCode)) {

            // Execute Stored Procedure
            $this->mRptCheckStatusCard->FSnMExecStoreReport($this->aRptFilter);

            $aDataSwitchCase = array(
                'ptRptRoute' => $this->tRptRoute,
                'ptRptCode' => $this->tRptCode,
                'ptRptTypeExport' => $this->tRptExportType,
                'paDataFilter' => $this->aRptFilter
            );

            switch ($this->tRptExportType) {
                case 'html':
                    $this->FSvCCallRptViewBeforePrint($aDataSwitchCase);
                    break;
                case 'excel':
                    $this->FSvCCallRptRenderExcel($aDataSwitchCase);
                    break;   
            }
        }
    }

    /**
     * Functionality: ฟังก์ชั่นดูตัวอย่างก่อนพิมพ์ (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 01/11/2019 Piya
     * LastUpdate: -
     * Return: View Report Viewer
     * ReturnType: View
     */
    public function FSvCCallRptViewBeforePrint($paDataSwitchCase) {

        $aDataWhere = array(
            'tUserSessionID' => $this->tUserSessionID,
            'tCompName' => $this->tCompName,
            'tUserCode' => $this->tUserLoginCode,
            'tRptCode' => $this->tRptCode,
            'nPage' => 1, // เริ่มทำงานหน้าแรก
            'nRow' => $this->nPerPage,
            'nOptDecimalShow' => $this->nOptDecimalShow
        );

        // Get Data Report
        $aDataReport = $this->mRptCheckStatusCard->FSaMGetDataReport($aDataWhere, $this->aRptFilter);

        if ($aDataReport['rnCurrentPage'] == $aDataReport['rnAllPage']) {
            $aDataSumFooterReport = $this->mRptCheckStatusCard->FSaMRPTCRDGetDataRptCheckStatusCardSum($aDataWhere);
            $aDataReport['aDataSumFooterReport'] = $aDataSumFooterReport;
        }else{
            $aDataReport['aDataSumFooterReport'] = [];
        }

        // Call View Report
        $tViewRenderKool = $this->FCNvCRenderKoolReportHtml($aDataReport, $this->aRptFilter);

        $aDataView = array(
            'aCompanyInfo' => $this->aCompanyInfo,
            'tTitleReport' => $this->aText['tTitleReport'],
            'tRptTypeExport' => $this->tRptExportType,
            'tRptCode' => $this->tRptCode,
            'tRptRoute' => $this->tRptRoute,
            'tViewRenderKool' => $tViewRenderKool,
            'aDataFilter' => $this->aRptFilter,
            'aDataReport' => $aDataReport
        );
        $this->load->view('report/report/wReportViewer', $aDataView);
    }

    /**
     * Functionality: Click Page Report (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 01/11/2019 Piya
     * LastUpdate: -
     * Return: View Report Viewer
     * ReturnType: View
     */
    public function FSvCCallRptViewBeforePrintClickPage() {

        /*===== Begin Init Variable ====================================================*/
        $aDataFilter = json_decode($this->input->post('ohdRptDataFilter'), true);
        /*===== End Init Variable ======================================================*/
        
        $aDataWhere = array(
            'tUserSessionID' => $this->tUserSessionID,
            'tCompName' => $this->tCompName,
            'tUserCode' => $this->tUserLoginCode,
            'tRptCode' => $this->tRptCode,
            'nPage' => $this->nPage,
            'nRow' => $this->nPerPage,
            'nOptDecimalShow' => $this->nOptDecimalShow
        );
        $aDataReport = $this->mRptCheckStatusCard->FSaMGetDataReport($aDataWhere, $aDataFilter);

        if ($aDataReport['rnCurrentPage'] == $aDataReport['rnAllPage']) {
            $aDataSumFooterReport = $this->mRptCheckStatusCard->FSaMRPTCRDGetDataRptCheckStatusCardSum($aDataWhere);
            $aDataReport['aDataSumFooterReport'] = $aDataSumFooterReport;
        }else{
            $aDataReport['aDataSumFooterReport'] = [];
        }

        if (!empty($aDataReport['rtCode']) && $aDataReport['rtCode'] == 1) {
            $tViewRenderKool = $this->FCNvCRenderKoolReportHtml($aDataReport, $aDataFilter);
        } else {
            $tViewRenderKool = "";
        }

        $aDataView = array(
            'tTitleReport' => $this->aText['tTitleReport'],
            'tRptTypeExport' => $this->tRptExportType,
            'tRptCode' => $this->tRptCode,
            'tRptRoute' => $this->tRptRoute,
            'tViewRenderKool' => $tViewRenderKool,
            'aDataFilter' => $aDataFilter,
            'aDataReport' => $aDataReport
        );
        $this->load->view('report/report/wReportViewer', $aDataView);
    }

    /**
     * Functionality: Call Rpt Table Kool Report
     * Parameters:  Function Parameter
     * Creator: 01/11/2019 Piya
     * LastUpdate: -
     * Return: View Kool Report
     * ReturnType: View
     */
    public function FCNvCRenderKoolReportHtml($paDataReport, $paDataFilter) {

        // Ref File Kool Report
        require_once APPPATH . 'modules\report\datasources\reportcard\rptCheckStatusCard\rRptCheckStatusCard.php';

        // Set Parameter To Report
        $oRptDropByDateHtml = new rRptCheckStatusCard(array(
            'nCurrentPage' => $paDataReport['rnCurrentPage'],
            'nAllPage' => $paDataReport['rnAllPage'],
            'aCompanyInfo' => $this->aCompanyInfo,
            'aFilterReport' => $paDataFilter,
            'aDataTextRef' => $this->aText,
            'aDataReturn' => $paDataReport,
            'nOptDecimalShow' => $this->nOptDecimalShow
        ));

        $oRptDropByDateHtml->run();
        $tHtmlViewReport = $oRptDropByDateHtml->render('wRptCheckStatusCardHtml', true);
        return $tHtmlViewReport;
    }


    /**
     * Functionality: Render Excel Report
     * Parameters:  Function Parameter
     * Creator: 22/12/2020 Sooksanti
     * LastUpdate: 
     * Return: file
     * ReturnType: file
     */
    public function  FSvCCallRptRenderExcel(){
        $tFileName = $this->aText['tTitleReport'].'_'.date('YmdHis').'.xlsx';
        $nOptDecimalShow    = $this->nOptDecimalShow;
        $oWriter = WriterEntityFactory::createXLSXWriter();

        $oWriter->openToBrowser($tFileName); // stream data directly to the browser

        $aMulltiRow = $this->FSoCCallRptRenderHedaerExcel();  //เรียกฟังชั่นสร้างส่วนหัวรายงาน
        $oWriter->addRows($aMulltiRow);

        $oBorder = (new BorderBuilder())
        ->setBorderTop(Color::BLACK, Border::WIDTH_THIN)
        ->setBorderBottom(Color::BLACK, Border::WIDTH_THIN)
        ->build();

        $oStyleColums = (new StyleBuilder())
        ->setBorder($oBorder)
        ->build();


        $aCells = [
            WriterEntityFactory::createCell($this->aText['tRPCCardCode']),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tRPCCardHolderID']),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tRPCCardType']),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tRPCCardName']),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tRPCCardStartDate']),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tRPCCardExpireDate']),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tRPCCardValue']),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tRPCCardDocDate']),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tRPCCardPosCode']),
            WriterEntityFactory::createCell(null),

        ];

        // /** add a row at a time */
        $singleRow = WriterEntityFactory::createRow($aCells,$oStyleColums);
        $oWriter->addRow($singleRow);

        $aDataWhere = array(
            'tUserSessionID' => $this->tUserSessionID,
            'tCompName' => $this->tCompName,
            'tUserCode' => $this->tUserLoginCode,
            'tRptCode' => $this->tRptCode,
            'nPage' => 1, // เริ่มทำงานหน้าแรก
            'nRow' => 999999999,
            'nOptDecimalShow' => $this->nOptDecimalShow
        );

        // Get Data Report
        $aDataReport = $this->mRptCheckStatusCard->FSaMGetDataReport($aDataWhere, $this->aRptFilter);


        /** Create a style with the StyleBuilder */
        $oStyle = (new StyleBuilder())
        ->setCellAlignment(CellAlignment::RIGHT)
        ->build();

        if(isset($aDataReport['raItems']) && !empty($aDataReport['raItems'])) {
            foreach ($aDataReport['raItems'] as $nKey => $aValue) { 

                $values= [
                    WriterEntityFactory::createCell($aValue['FTCrdCode']),
                    WriterEntityFactory::createCell(null),
                    WriterEntityFactory::createCell($aValue['FTCrdHolderID']),
                    WriterEntityFactory::createCell(null),
                    WriterEntityFactory::createCell($aValue['FTCtyName']),
                    WriterEntityFactory::createCell(null),
                    WriterEntityFactory::createCell($aValue['FTCrdName']),
                    WriterEntityFactory::createCell(null),
                    WriterEntityFactory::createCell(empty($aValue['FDCrdStartDate']) ? '' : date("d/m/Y", strtotime($aValue['FDCrdStartDate']))),
                    WriterEntityFactory::createCell(null),
                    WriterEntityFactory::createCell(empty($aValue['FDCrdStartDate']) ? '' : date("d/m/Y", strtotime($aValue['FDCrdExpireDate']))),
                    WriterEntityFactory::createCell(null),
                    WriterEntityFactory::createCell(number_format($aValue['FCCrdValue'],$nOptDecimalShow),$oStyle),
                    WriterEntityFactory::createCell(null),
                    WriterEntityFactory::createCell(empty($aValue['FDCrdStartDate']) ? '' : date("d/m/Y H:i:s", strtotime($aValue['FDCrdExpireDate']))),
                    WriterEntityFactory::createCell(null),
                    WriterEntityFactory::createCell($aValue['FTTxnPosCode']),
                    WriterEntityFactory::createCell(null),
                ];

                $aRow = WriterEntityFactory::createRow($values);
                $oWriter->addRow($aRow);

                if(($nKey+1)==FCNnHSizeOf($aDataReport['raItems'])){ //SumFooter
                    $aDataSumFooterReport = $this->mRptCheckStatusCard->FSaMRPTCRDGetDataRptCheckStatusCardSum($aDataWhere);
                    $aDataReport['aDataSumFooterReport'] = $aDataSumFooterReport;
                    $values= [
                        WriterEntityFactory::createCell($this->aText['tRPCTBFooterSumAll']),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(number_format($aDataSumFooterReport[0]['FCCrdValueSum'],$nOptDecimalShow),$oStyle),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                        WriterEntityFactory::createCell(null),
                    ];
                    $aRow = WriterEntityFactory::createRow($values,$oStyleColums);
                    $oWriter->addRow($aRow);
                }
            }
        }

        $aMulltiRow = $this->FSoCCallRptRenderFooterExcel();//เรียกฟังชั่นสร้างส่วนท้ายรายงาน
        $oWriter->addRows($aMulltiRow);

        $oWriter->close();
    }


    /**
     * Functionality: Render Excel Report Header
     * Parameters:  Function Parameter
     * Creator: 22/12/2020 Sooksanti
     * LastUpdate: 
     * Return: oject
     * ReturnType: oject
     */
    public function FSoCCallRptRenderHedaerExcel(){

        if (isset($this->aCompanyInfo) && count($this->aCompanyInfo)>0) {
            $tFTAddV1Village = $this->aCompanyInfo['FTAddV1Village'];
            $tFTCmpName     = $this->aCompanyInfo['FTCmpName'];
            $tFTAddV1No     = $this->aCompanyInfo['FTAddV1No'];
            $tFTAddV1Road   = $this->aCompanyInfo['FTAddV1Road'];
            $tFTAddV1Soi    = $this->aCompanyInfo['FTAddV1Soi'];
            $tFTSudName     = $this->aCompanyInfo['FTSudName'];
            $tFTDstName     = $this->aCompanyInfo['FTDstName'];
            $tFTPvnName     = $this->aCompanyInfo['FTPvnName'];
            $tFTAddV1PostCode = $this->aCompanyInfo['FTAddV1PostCode'];
            $tFTAddV2Desc1  = $this->aCompanyInfo['FTAddV2Desc1'];
            $tFTAddV2Desc2  = $this->aCompanyInfo['FTAddV2Desc2'];
            $tFTAddVersion  = $this->aCompanyInfo['FTAddVersion'];
            $tFTBchName     = $this->aCompanyInfo['FTBchName'];
            $tFTAddTaxNo    = $this->aCompanyInfo['FTAddTaxNo'];
            $tFTCmpTel      = $this->aCompanyInfo['FTAddTel'];
            $tRptFaxNo      = $this->aCompanyInfo['FTAddFax'];
        }else {
            $tFTCmpTel      = "";
            $tFTCmpName     = "";
            $tFTAddV1No     = "";
            $tFTAddV1Road   = "";
            $tFTAddV1Soi    = "";
            $tFTSudName     = "";
            $tFTDstName     = "";
            $tFTPvnName     = "";
            $tFTAddV1PostCode   = "";
            $tFTAddV2Desc1      = "1"; 
            $tFTAddV1Village    = "";
            $tFTAddV2Desc2      = "2";
            $tFTAddVersion      = "";
            $tFTBchName         = "";
            $tFTAddTaxNo        = "";
            $tRptFaxNo          = "";
        }
        $oStyle = (new StyleBuilder())
            ->setFontBold()
            ->setFontSize(12)
            ->build();

        $aCells = [
            WriterEntityFactory::createCell($tFTCmpName),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tTitleReport']),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
        ];

        $aMulltiRow[] = WriterEntityFactory::createRow($aCells, $oStyle);

        $tAddress = '';
        if ($tFTAddVersion == '1') {
            $tAddress = $tFTAddV1No . ' ' .$tFTAddV1Village. ' '.$tFTAddV1Road.' ' . $tFTAddV1Soi . ' ' . $tFTSudName . ' ' . $tFTDstName . ' ' . $tFTPvnName . ' ' . $tFTAddV1PostCode;
        }
        if ($tFTAddVersion == '2') {
            $tAddress = $tFTAddV2Desc1 . ' ' . $tFTAddV2Desc2;
        }

        $aCells = [
            WriterEntityFactory::createCell($tAddress),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
        ];
        $aMulltiRow[] = WriterEntityFactory::createRow($aCells);

        $aCells = [
            WriterEntityFactory::createCell($this->aText['tRptTel'] . ' ' . $tFTCmpTel . ' '.$this->aText['tRptFaxNo'] . ' ' . $tRptFaxNo),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
        ];
        $aMulltiRow[]  = WriterEntityFactory::createRow($aCells);

        $aCells = [
            WriterEntityFactory::createCell($this->aText['tRptBranch'] . ' ' . $tFTBchName),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
        ];
        $aMulltiRow[] = WriterEntityFactory::createRow($aCells);

        $aCells = [
            WriterEntityFactory::createCell($this->aText['tRPCTaxNo'] . ' : ' . $tFTAddTaxNo),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
        ];
        $aMulltiRow[] = WriterEntityFactory::createRow($aCells);

        $aCells = [
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
        ];
        $aMulltiRow[] = WriterEntityFactory::createRow($aCells);


        if ((isset($this->aRptFilter['tDocDateFrom']) && !empty($this->aRptFilter['tDocDateFrom'])) && (isset($this->aRptFilter['tDocDateTo']) && !empty($this->aRptFilter['tDocDateTo']))) {
            $aCells = [
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell($this->aText['tRPCDateFrom'].' '.date('d/m/Y',strtotime($this->aRptFilter['tDocDateFrom'])).' '.$this->aText['tRPCDateTo'].' '.date('d/m/Y',strtotime($this->aRptFilter['tDocDateTo']))),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);
        }

        $aCells = [
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tRptDatePrint'].' '.date('d/m/Y').' '.$this->aText['tRptTimePrint'].' '.date('H:i:s')),
        ];

        $aMulltiRow[] = WriterEntityFactory::createRow($aCells);

        return $aMulltiRow;
    }



        /**
     * Functionality: Render Excel Report Footer
     * Parameters:  Function Parameter
     * Creator: 22/12/2020 Sooksanti
     * LastUpdate:
     * Return: oject
     * ReturnType: oject
     */
    public function FSoCCallRptRenderFooterExcel()
    {

        $oStyleFilter = (new StyleBuilder())
            ->setFontBold()
            ->build();
        $aCells = [
            WriterEntityFactory::createCell(null),
        ];
        $aMulltiRow[] = WriterEntityFactory::createRow($aCells);

        $aCells = [
            WriterEntityFactory::createCell($this->aText['tRptConditionInReport']),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
        ];
        $aMulltiRow[] = WriterEntityFactory::createRow($aCells, $oStyleFilter);

        // สาขา แบบเลือก
        if (!empty($this->aRptFilter['tBchCodeSelect'])) {
            $tBchSelectText = ($this->aRptFilter['bBchStaSelectAll']) ? $this->aText['tRptAll'] : $this->aRptFilter['tBchNameSelect'];
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptBchFrom'] . ' : ' . $tBchSelectText),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);
        }

        // กลุ่มธุรกิจ แบบเลือก
        if (!empty($this->aRptFilter['tMerCodeSelect'])) {
            $tMerSelectText = ($this->aRptFilter['bMerStaSelectAll']) ? $this->aText['tRptAll'] : $this->aRptFilter['tMerNameSelect'];
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptMerFrom'] . ' : ' . $tMerSelectText),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);
        }

        // ร้านค้า แบบเลือก
        if (!empty($this->aRptFilter['tShpCodeSelect'])) {
            $tShpSelectText = ($this->aRptFilter['bShpStaSelectAll']) ? $this->aText['tRptAll'] : $this->aRptFilter['tShpNameSelect'];
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptShopFrom'] . ' : ' . $tShpSelectText),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);
        }


        // เครื่องจุดขาย (Pos) แบบเลือก
        if (!empty($this->aRptFilter['tPosCodeSelect'])) {
            $tPosSelectText = ($this->aRptFilter['bPosStaSelectAll']) ? $this->aText['tRptAll'] : $this->aRptFilter['tPosNameSelect'];
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptPosFrom'] . ' : ' . $tPosSelectText),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);
        }


        //หมายเลขบัตร
        if ((isset($this->aRptFilter['tCardCodeFrom']) && !empty($this->aRptFilter['tCardCodeFrom'])) && (isset($this->aRptFilter['tCardCodeTo']) && !empty($this->aRptFilter['tCardCodeTo']))) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRPCCrdFrom'] . ' : ' .$this->aRptFilter['tCardNameFrom']),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell($this->aText['tRPCCrdTo'] . ' : ' .$this->aRptFilter['tCardNameTo']),
                WriterEntityFactory::createCell(null),

            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);
        }

        //ประเภทบัตร
        if ((isset($this->aRptFilter['tCardTypeCodeFrom']) && !empty($this->aRptFilter['tCardTypeCodeFrom'])) && (isset($this->aRptFilter['tCardTypeCodeTo']) && !empty($this->aRptFilter['tCardTypeCodeTo']))) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRPCCrdTypeFrom'] . ' : ' .$this->aRptFilter['tCardTypeNameFrom']),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell($this->aText['tRPCCrdTypeTo'] . ' : ' .$this->aRptFilter['tCardTypeNameTo']),
                WriterEntityFactory::createCell(null),

            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);
        }

        //สถานะบัตร
        if ((isset($this->aRptFilter['tStaCardFrom']) && !empty($this->aRptFilter['tStaCardFrom'])) && (isset($this->aRptFilter['tStaCardTo']) && !empty($this->aRptFilter['tStaCardTo']))) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRPCStaCrdFrom'] . ' : ' .$this->aRptFilter['tStaCardNameFrom']),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell($this->aText['tRPCStaCrdTo'] . ' : ' .$this->aRptFilter['tStaCardNameTo']),
                WriterEntityFactory::createCell(null),

            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);  
        }

        //วันที่เริ่มใช้งานบัตร
        if ((isset($this->aRptFilter['tDateStartFrom']) && !empty($this->aRptFilter['tDateStartFrom'])) && (isset($this->aRptFilter['tDateStartTo']) && !empty($this->aRptFilter['tDateStartTo']))) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRPCDateStartFrom'] . ' : ' .$this->aRptFilter['tDateStartFrom']),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell($this->aText['tRPCDateStartTo'] . ' : ' .$this->aRptFilter['tDateStartTo']),
                WriterEntityFactory::createCell(null),

            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);            
        }
        
        //วันที่บัตรหมดอายุ
        if ((isset($this->aRptFilter['tDateExpireFrom']) && !empty($this->aRptFilter['tDateExpireFrom'])) && (isset($this->aRptFilter['tDateExpireTo']) && !empty($this->aRptFilter['tDateExpireTo']))) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRPCDateExpireFrom'] . ' : ' .$this->aRptFilter['tDateExpireFrom']),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell($this->aText['tRPCDateExpireTo'] . ' : ' .$this->aRptFilter['tDateExpireTo']),
                WriterEntityFactory::createCell(null),

            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);  
        }
        return $aMulltiRow;
    }
}