<?php

defined('BASEPATH') or exit('No direct script access allowed');

include APPPATH . 'third_party/PHPExcel/Classes/PHPExcel.php';
include APPPATH . 'third_party/PHPExcel/Classes/PHPExcel/IOFactory.php';
include APPPATH . 'third_party/PHPExcel/Classes/PHPExcel/Writer/Excel2007.php';

include APPPATH . 'libraries/spout-3.1.0/src/Spout/Autoloader/autoload.php';
use Box\Spout\Common\Entity\Row;
use Box\Spout\Common\Entity\Style\Border;
use Box\Spout\Common\Entity\Style\CellAlignment;
use Box\Spout\Common\Entity\Style\Color;
use Box\Spout\Writer\Common\Creator\Style\BorderBuilder;
use Box\Spout\Writer\Common\Creator\Style\StyleBuilder;
use Box\Spout\Writer\Common\Creator\WriterEntityFactory;

date_default_timezone_set("Asia/Bangkok");

class Rptsalebymershop_controller extends MX_Controller
{

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

    public function __construct()
    {
        $this->load->model('company/company/mCompany');
        $this->load->model('report/reportsalebymershop/Rptsalebymershop_model');
        $this->load->model('report/report/mReport');

        // Init Report
        $this->init();

        parent::__construct();
    }

    private function init()
    {
        $this->aText = [
            // Title
            'tTitleReport'              => language('report/report/report', 'tRptSalebymershopTitle'),
            'tDatePrint'                => language('report/report/report', 'tRptAdjStkVDDatePrint'),
            'tTimePrint'                => language('report/report/report', 'tRptAdjStkVDTimePrint'),

            'tMerName'                  => language('report/report/report', 'tRptSalebymershopMer'),
            'tShpName'                  => language('report/report/report', 'tRptSalebymershopShop'),
            'tPdtCode'                  => language('report/report/report', 'tRptSalebymershopPdtCode'),
            'tPdtName'                  => language('report/report/report', 'tRptSalebymershopPdtName'),
            'tQty'                      => language('report/report/report', 'tRptSalebymershopQty'),
            'tPunName'                  => language('report/report/report', 'tRptSalebymershopPun'),
            'tAmtTotal'                 => language('report/report/report', 'tRptSalebymershopAmtTotal'),
            'tDisChg'                   => language('report/report/report', 'tRptSalebymershopDisChg'),
            'tAgvPri'                   => language('report/report/report', 'tRptSalebymershopAgvPri'),
            'tGrandTotal'               => language('report/report/report', 'tRptSalebymershopGrand'),

            // Address Lang
            'tRptAddrBuilding'          => language('report/report/report', 'tRptAddrBuilding'),
            'tRptAddrRoad'              => language('report/report/report', 'tRptAddrRoad'),
            'tRptAddrSoi'               => language('report/report/report', 'tRptAddrSoi'),
            'tRptAddrSubDistrict'       => language('report/report/report', 'tRptAddrSubDistrict'),
            'tRptAddrDistrict'          => language('report/report/report', 'tRptAddrDistrict'),
            'tRptAddrProvince'          => language('report/report/report', 'tRptAddrProvince'),
            'tRptAddrTel'               => language('report/report/report', 'tRptAddrTel'),
            'tRptAddrFax'               => language('report/report/report', 'tRptAddrFax'),
            'tRptAddrBranch'            => language('report/report/report', 'tRptAddrBranch'),
            'tRptAddrTaxNo'             => language('report/report/report', 'tRptAddrTaxNo'),
            'tRptAddV2Desc1'            => language('report/report/report', 'tRptAddV2Desc1'),
            'tRptAddV2Desc2'            => language('report/report/report', 'tRptAddV2Desc2'),
            'tRPCTaxNo'                 => language('report/report/report', 'tRPCTaxNo'),
            'tRptFaxNo'                 => language('report/report/report', 'tRptFaxNo'),
            'tRptTel'                   => language('report/report/report', 'tRptTel'),
            
            // Table Report
            'tRptBarchCode'             => language('report/report/report', 'tRptBarchCode'),
            'tRptBarchName'             => language('report/report/report', 'tRptBarchName'),
            'tRptDocDate'               => language('report/report/report', 'tRptDocDate'),
            'tRptShopCode'              => language('report/report/report', 'tRptShopCode'),
            'tRptShopName'              => language('report/report/report', 'tRptShopName'),
            'tRptAmount'                => language('report/report/report', 'tRptAmount'),
            'tRptSale'                  => language('report/report/report', 'tRptSale'),
            'tRptCancelSale'            => language('report/report/report', 'tRptCancelSale'),
            'tRptTotalSale'             => language('report/report/report', 'tRptTotalSale'),
            'tRptTotalAllSale'          => language('report/report/report', 'tRptTotalAllSale'),
            'tRptPayby'                 => language('report/report/report', 'tRptPayby'),
            'tRptRcvDocumentCode'       => language('report/report/report', 'tRptRcvDocumentCode'),
            'tRptDate'                  => language('report/report/report', 'tRptDate'),
            'tRptRcvTotal'              => language('report/report/report', 'tRptRcvTotal'),

            // No Data Report
            'tRptAdjStkNoData'          => language('common/main/main', 'tCMNNotFoundData'),

            // Filter Heard Report
            'tRptBchFrom'               => language('report/report/report', 'tRptBchFrom'),
            'tRptBchTo'                 => language('report/report/report', 'tRptBchTo'),
            'tRptShopFrom'              => language('report/report/report', 'tRptShopFrom'),
            'tRptShopTo'                => language('report/report/report', 'tRptShopTo'),
            'tPdtCodeFrom'              => language('report/report/report', 'tPdtCodeFrom'),
            'tPdtCodeTo'                => language('report/report/report', 'tPdtCodeTo'),
            'tRptFromWareHouse'         => language('report/report/report', 'tRptFromWareHouse'),
            'tRptToWareHouse'           => language('report/report/report', 'tRptToWareHouse'),
            'tRptDateFrom'              => language('report/report/report', 'tRptDateFrom'),
            'tRptDateTo'                => language('report/report/report', 'tRptDateTo'),
            'tRptTotalSub'              => language('report/report/report', 'tRptTotalSub'),
            'tRptTotalFooter'           => language('report/report/report', 'tRptTotalFooter'),
            'tRptAdjMerChantFrom'       => language('report/report/report', 'tRptAdjMerChantFrom'),
            'tRptAdjMerChantTo'         => language('report/report/report', 'tRptAdjMerChantTo'),
            'tRptAdjShopFrom'           => language('report/report/report', 'tRptAdjShopFrom'),
            'tRptAdjShopTo'             => language('report/report/report', 'tRptAdjShopTo'),
            'tRptAdjPosFrom'            => language('report/report/report', 'tRptAdjPosFrom'),
            'tRptAdjPosTo'              => language('report/report/report', 'tRptAdjPosTo'),

            // Update Lang Wasin(20/11/2019)
            'tRptTotalWah'              => language('report/report/report', 'tRptTotalWah'),
            'tRptTotalBch'              => language('report/report/report', 'tRptTotalBch'),
            'tRptYear'                  => language('report/report/report', 'tRptYear'),
            'tRptMonth'                 => language('report/report/report', 'tRptMonth'),

            // Lang เดือน
            'tRptMonth1'                => language('report/report/report', 'tRptMonth01'),
            'tRptMonth2'                => language('report/report/report', 'tRptMonth02'),
            'tRptMonth3'                => language('report/report/report', 'tRptMonth03'),
            'tRptMonth4'                => language('report/report/report', 'tRptMonth04'),
            'tRptMonth5'                => language('report/report/report', 'tRptMonth05'),
            'tRptMonth6'                => language('report/report/report', 'tRptMonth06'),
            'tRptMonth7'                => language('report/report/report', 'tRptMonth07'),
            'tRptMonth8'                => language('report/report/report', 'tRptMonth08'),
            'tRptMonth9'                => language('report/report/report', 'tRptMonth09'),
            'tRptMonth10'               => language('report/report/report', 'tRptMonth10'),
            'tRptMonth11'               => language('report/report/report', 'tRptMonth11'),
            'tRptMonth12'               => language('report/report/report', 'tRptMonth12'),
            'tRptConditionInReport'     => language('report/report/report', 'tRptConditionInReport'),

            'tRptMerFrom'               => language('report/report/report', 'tRptMerFrom'),
            'tRptMerTo'                 => language('report/report/report', 'tRptMerTo'),
            'tRptShopFrom'              => language('report/report/report', 'tRptShopFrom'),
            'tRptShopTo'                => language('report/report/report', 'tRptShopTo'),
            'tRptPosFrom'               => language('report/report/report', 'tRptPosFrom'),
            'tRptPosTo'                 => language('report/report/report', 'tRptPosTo'),
            'tPdtCodeFrom'              => language('report/report/report', 'tPdtCodeFrom'),
            'tPdtCodeTo'                => language('report/report/report', 'tPdtCodeTo'),
            'tPdtGrpFrom'               => language('report/report/report', 'tPdtGrpFrom'),
            'tPdtGrpTo'                 => language('report/report/report', 'tPdtGrpTo'),
            'tPdtTypeFrom'              => language('report/report/report', 'tPdtTypeFrom'),
            'tPdtTypeTo'                => language('report/report/report', 'tPdtTypeTo'),
            'tRptAdjWahFrom'            => language('report/report/report', 'tRptAdjWahFrom'),
            'tRptAdjWahTo'              => language('report/report/report', 'tRptAdjWahTo'),
            'tRptAll'                   => language('report/report/report', 'tRptAll'),
            'tRptBchFrom'               => language('report/report/report', 'tRptBchFrom'),
            'tRptBchTo'                 => language('report/report/report', 'tRptBchTo'),

            'tRptPdtCodeFrom'           => language('report/report/report', 'tRptPdtCodeFrom'),
            'tRptPdtCodeTo'             => language('report/report/report', 'tRptPdtCodeTo'),
            'tPdtNameFrom'              => language('report/report/report', 'tPdtNameFrom'),
            'tPdtNameTo'                => language('report/report/report', 'tPdtNameTo'),
             
            'tRptGrpAgency'             => language('report/report/report', 'tRptGrpAgency'),

            'tRptTaxSaleTaxNo'          => language('report/report/report', 'tRptTaxSaleTaxNo'),

            // ความเคลื่อนไหวสินค้า
            'tRptTitlePdtMoving'        => language('report/report/report', 'tRptTitlePdtMoving'),
            'tRptPdtMoving1'            => language('report/report/report', 'tRptPdtMoving1'),
            'tRptPdtMoving2'            => language('report/report/report', 'tRptPdtMoving2'),
        ];

        $this->tSysBchCode      = SYS_BCH_CODE;
        $this->tBchCodeLogin    = (!empty($this->session->userdata('tSesUsrBchCom')) ? $this->session->userdata('tSesUsrBchCom') : $this->session->userdata('tSesUsrBchCom'));
        $this->nPerPage         = 100;
        $this->nOptDecimalShow  = FCNxHGetOptionDecimalShow();
        $tIP                    = $this->input->ip_address();
        $tFullHost              = gethostbyaddr($tIP);
        $this->tCompName        = $tFullHost;
        $this->nLngID           = FCNaHGetLangEdit();
        $this->tRptCode         = $this->input->post('ohdRptCode');
        $this->tRptGroup        = $this->input->post('ohdRptGrpCode');
        $this->tUserSessionID   = $this->session->userdata('tSesSessionID');
        $this->tRptRoute        = $this->input->post('ohdRptRoute');
        $this->tRptExportType   = $this->input->post('ohdRptTypeExport');
        $this->nPage            = empty($this->input->post('ohdRptCurrentPage')) ? 1 : $this->input->post('ohdRptCurrentPage');
        $this->tUserLoginCode   = $this->session->userdata('tSesUsername');

        // Report Filter
        $this->aRptFilter = [
            'tUserSession'      => $this->tUserSessionID,
            'tCompName'         => $tFullHost,
            'tRptCode'          => $this->tRptCode,
            'nLangID'           => $this->nLngID,

            'tTypeSelect'       => !empty($this->input->post('ohdTypeDataCondition')) ? $this->input->post('ohdTypeDataCondition') : "",

            // Filter Branch (สาขา)
            'tBchCodeSelect'    => !empty($this->input->post('oetRptBchCodeSelect')) ? $this->input->post('oetRptBchCodeSelect') : "",
            'tBchNameSelect'    => !empty($this->input->post('oetRptBchNameSelect')) ? $this->input->post('oetRptBchNameSelect') : "",
            'bBchStaSelectAll'  => !empty($this->input->post('oetRptBchStaSelectAll')) && ($this->input->post('oetRptBchStaSelectAll') == 1) ? true : false,
           
            // Filter Merchant (กลุ่มธุรกิจ)
            'tMerCodeFrom'      => (empty($this->input->post('oetRptMerCodeFrom'))) ? '' : $this->input->post('oetRptMerCodeFrom'),
            'tMerNameFrom'      => (empty($this->input->post('oetRptMerNameFrom'))) ? '' : $this->input->post('oetRptMerNameFrom'),
            'tMerCodeTo'        => (empty($this->input->post('oetRptMerCodeTo'))) ? '' : $this->input->post('oetRptMerCodeTo'),
            'tMerNameTo'        => (empty($this->input->post('oetRptMerNameTo'))) ? '' : $this->input->post('oetRptMerNameTo'),
            'tMerCodeSelect'    => !empty($this->input->post('oetRptMerCodeSelect')) ? $this->input->post('oetRptMerCodeSelect') : "",
            'tMerNameSelect'    => !empty($this->input->post('oetRptMerNameSelect')) ? $this->input->post('oetRptMerNameSelect') : "",
            'bMerStaSelectAll'  => !empty($this->input->post('oetRptMerStaSelectAll')) && ($this->input->post('oetRptMerStaSelectAll') == 1) ? true : false,

            // Filter Shop (ร้านค้า)
            'tShpCodeFrom'      => (empty($this->input->post('oetRptShpCodeFrom'))) ? '' : $this->input->post('oetRptShpCodeFrom'),
            'tShpNameFrom'      => (empty($this->input->post('oetRptShpNameFrom'))) ? '' : $this->input->post('oetRptShpNameFrom'),
            'tShpCodeTo'        => (empty($this->input->post('oetRptShpCodeTo'))) ? '' : $this->input->post('oetRptShpCodeTo'),
            'tShpNameTo'        => (empty($this->input->post('oetRptShpNameTo'))) ? '' : $this->input->post('oetRptShpNameTo'),
            'tShpCodeSelect'    => !empty($this->input->post('oetRptShpCodeSelect')) ? $this->input->post('oetRptShpCodeSelect') : "",
            'tShpNameSelect'    => !empty($this->input->post('oetRptShpNameSelect')) ? $this->input->post('oetRptShpNameSelect') : "",
            'bShpStaSelectAll'  => !empty($this->input->post('oetRptShpStaSelectAll')) && ($this->input->post('oetRptShpStaSelectAll') == 1) ? true : false,

            // สินค้า
            'tPdtCodeFrom'      => !empty($this->input->post('oetRptPdtCodeFrom')) ? $this->input->post('oetRptPdtCodeFrom') : "",
            'tPdtNameFrom'      => !empty($this->input->post('oetRptPdtNameFrom')) ? $this->input->post('oetRptPdtNameFrom') : "",
            'tPdtCodeTo'        => !empty($this->input->post('oetRptPdtCodeTo')) ? $this->input->post('oetRptPdtCodeTo') : "",
            'tPdtNameTo'        => !empty($this->input->post('oetRptPdtNameTo')) ? $this->input->post('oetRptPdtNameTo') : "",

            // ปี
            'tYear'             => !empty($this->input->post('oetRptYear')) ? $this->input->post('oetRptYear') : "",

            // เดือน
            'tMonth'            => !empty($this->input->post('ocmRptMonth')) ? $this->input->post('ocmRptMonth') : "",

            // สถานะเคลื่อนไหว
            'tPdtStaActive'     => !empty($this->input->post('ocmRptPdtStaActive')) ? $this->input->post('ocmRptPdtStaActive') : "",
            // วันที่เอกสาร(DocNo)
            'tDocDateFrom'      => !empty($this->input->post('oetRptDocDateFrom')) ? $this->input->post('oetRptDocDateFrom') : "",
            'tDocDateTo'        => !empty($this->input->post('oetRptDocDateTo')) ? $this->input->post('oetRptDocDateTo') : "",

        ];
        // print_r($this->aRptFilter);exit;
        // ดึงข้อมูลบริษัทฯ
        $aCompInfoParams = [
            'nLngID'    => $this->nLngID,
            'tBchCode'  => $this->tBchCodeLogin,
        ];
        $this->aCompanyInfo = FCNaGetCompanyInfo($aCompInfoParams)['raItems'];
    }

    public function index()
    {

        if (!empty($this->tRptExportType) && !empty($this->tRptCode)) {
            // Execute Stored Procedure
            $this->Rptsalebymershop_model->FSnMExecStoreReport($this->aRptFilter);
            $aDataSwitchCase = array(
                'ptRptRoute'        => $this->tRptRoute,
                'ptRptCode'         => $this->tRptCode,
                'ptRptTypeExport'   => $this->tRptExportType,
                'paDataFilter'      => $this->aRptFilter,
            );

            switch ($this->tRptExportType) {
                case 'html':
                    $this->FSvCCallRptViewBeforePrint($aDataSwitchCase);
                    break;
                case 'excel':
                    $this->FSvCCallRptRenderExcel($aDataSwitchCase);
                    break;
                    // case 'pdf':
                    //     $this->FSvCCallRptRenderExcel($aDataSwitchCase);
                    //     break;
            }
        }
    }

    /**
     * Functionality: ฟังก์ชั่นดูตัวอย่างก่อนพิมพ์ (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 10/07/2019 Saharat(Golf)
     * LastUpdate: 24/09/2019 Piya
     * Return: View Report Viewer
     * ReturnType: View
     */
    public function FSvCCallRptViewBeforePrint($paDataSwitchCase)
    {

        // ข้อมูลสำหรับดึงข้อมูลจากฐานข้อมูล
        $aDataWhereRpt = array(
            'nPerPage'      => $this->nPerPage,
            'nPage'         => 1, // เริ่มรายงานหน้าแรก
            'tCompName'     => $this->tCompName,
            'tRptCode'      => $this->tRptCode,
            'tUsrSessionID' => $this->tUserSessionID,
        );

        $aDataReport = $this->Rptsalebymershop_model->FSaMGetDataReport($aDataWhereRpt);

        // ข้อมูล Render Report
        $aDataViewPdt = array(
            'aDataReport'       => $aDataReport,
            'aDataTextRef'      => $this->aText,
            'aCompanyInfo'      => $this->aCompanyInfo,
            'nOptDecimalShow'   => $this->nOptDecimalShow,
            'aDataFilter'       => $paDataSwitchCase['paDataFilter'],
        );
        // echo '<pre>';
        // print_r($aDataReport);
        // echo '</pre>';
        // die();
        // Load View Advance Table
        $tRptView = JCNoHLoadViewAdvanceTable('report/datasources/rptsalebymershop', 'wRptSalByMerShpHtml', $aDataViewPdt);

        // Data Viewer Center Report
        $aDataViewer = array(
            'tTitleReport'      => $this->aText['tTitleReport'],
            'tRptTypeExport'    => $this->tRptExportType,
            'tRptCode'          => $this->tRptCode,
            'tRptRoute'         => $this->tRptRoute,
            'tViewRenderKool'   => $tRptView,
            'aDataFilter'       => $paDataSwitchCase['paDataFilter'],
            'aDataReport'       => array(
                'raItems'           => $aDataReport['aRptData'],
                'rnAllRow'          => $aDataReport['aPagination']['nTotalRecord'],
                'rnCurrentPage'     => $aDataReport['aPagination']['nDisplayPage'],
                'rnAllPage'         => $aDataReport['aPagination']['nTotalPage'],
                'rtCode'            => '1',
                'rtDesc'            => 'success',
            ),
        );
        $this->load->view('report/report/wReportViewer', $aDataViewer);
    }

    /**
     * Functionality: Click Page ดูตัวอย่างก่อนพิมพ์ (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 19/07/2019 Wasin(Yoshi)
     * LastUpdate: 24/09/2019
     * Return: View Report Viewer
     * ReturnType: View
     */
    public function FSvCCallRptViewBeforePrintClickPage()
    {

        /** =========== Begin Init Variable ================================== */
        $aDataFilter = json_decode($this->input->post('ohdRptDataFilter'), true);
        /** =========== End Init Variable ==================================== */

        // ข้อมูลสำหรับดึงข้อมูลจากฐานข้อมูล
        $aDataWhereRpt = array(
            'nPerPage'      => $this->nPerPage,
            'nPage'         => $this->nPage,
            'tCompName'     => $this->tCompName,
            'tRptCode'      => $this->tRptCode,
            'tUsrSessionID' => $this->tUserSessionID,
        );
        $aDataReport = $this->Rptsalebymershop_model->FSaMGetDataReport($aDataWhereRpt);

        // ข้อมูล Render Report
        $aDataViewPdt = array(
            'aDataReport'       => $aDataReport,
            'aDataTextRef'      => $this->aText,
            'aCompanyInfo'      => $this->aCompanyInfo,
            'nOptDecimalShow'   => $this->nOptDecimalShow,
            'aDataFilter'       => $aDataFilter,
        );
        // Load View Advance Table
        $tRptView = JCNoHLoadViewAdvanceTable('report/datasources/rptsalebymershop', 'wRptSalByMerShpHtml', $aDataViewPdt);

        // Data Viewer Center Report
        $aDataViewer = array(
            'tTitleReport'      => $this->aText['tTitleReport'],
            'tRptTypeExport'    => $this->tRptExportType,
            'tRptCode'          => $this->tRptCode,
            'tRptRoute'         => $this->tRptRoute,
            'tViewRenderKool'   => $tRptView,
            'aDataFilter'       => $aDataFilter,
            'aDataReport'           => array(
                'raItems'           => $aDataReport['aRptData'],
                'rnAllRow'          => $aDataReport['aPagination']['nTotalRecord'],
                'rnCurrentPage'     => $aDataReport['aPagination']['nDisplayPage'],
                'rnAllPage'         => $aDataReport['aPagination']['nTotalPage'],
                'rtCode'            => '1',
                'rtDesc'            => 'success',
            ),
        );
        $this->load->view('report/report/wReportViewer', $aDataViewer);
    }



    /**
     * Functionality: Click Page Report (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 16/08/2019 Wasin(Yoshi)
     * LastUpdate: 24/09/2019 Piya
     * Return: object Status Count Data Report
     * ReturnType: Object
     */
    public function FSoCChkDataReportInTableTemp($paDataSwitchCase)
    {
        try {
            $aDataCountData = [
                'tCompName'     => $paDataSwitchCase['paDataFilter']['tCompName'],
                'tRptCode'      => $paDataSwitchCase['paDataFilter']['tRptCode'],
                'tUserSession'  => $paDataSwitchCase['paDataFilter']['tUserSession'],
            ];

            $nDataCountPage = $this->Rptsalebymershop_model->FSnMCountDataReportAll($aDataCountData);

            $aResponse = array(
                'nCountPageAll' => $nDataCountPage,
                'nStaEvent'     => 1,
                'tMessage'      => 'Success Count Data All',
            );
        } catch (ErrorException $Error) {
            $aResponse = array(
                'nStaEvent'     => 500, 
                'tMessage'      => $Error->getMessage(),
            );
        }
        echo json_encode($aResponse);
    }

    /**
     * Functionality: Send Rabbit MQ Report
     * Parameters:  Function Parameter
     * Creator: 16/08/2019 Wasin(Yoshi)
     * LastUpdate: 24/09/2019 Piya
     * Return: object Send Rabbit MQ Report
     * ReturnType: Object
     */
    public function FSvCCallRptExportFile()
    {
        try {
            $dDateSendMQ = date('Y-m-d');
            $dTimeSendMQ = date('H:i:s');
            $dDateSubscribe = date('Ymd');
            $dTimeSubscribe = date('His');

            // Set Parameter Send MQ
            $tRptQueueName = 'RPT_' . $this->tSysBchCode . '_' . $this->tRptGroup . '_' . $this->tRptCode;

            $aDataSendMQ = [
                'tQueueName'    => $tRptQueueName,
                'aParams'   => [
                    'ptRptCode'         => $this->tRptCode,
                    'pnPerFile'         => 1000,
                    'ptUserCode'        => $this->tUserLoginCode,
                    'ptUserSessionID'   => $this->tUserSessionID,
                    'pnLngID'           => $this->nLngID,
                    'ptFilter'          => $this->aRptFilter,
                    'ptRptExpType'      => $this->tRptExportType,
                    'ptComName'         => $this->tCompName,
                    'ptDate'            => $dDateSendMQ,
                    'ptTime'            => $dTimeSendMQ,
                    'ptBchCode'         => (!empty($this->session->userdata('tSesUsrBchCom')) ? $this->session->userdata('tSesUsrBchCom') : $this->session->userdata('tSesUsrBchCom'))
                ]
            ];

            FCNxReportCallRabbitMQ($aDataSendMQ);

            $aResponse = array(
                'nStaEvent' => 1,
                'tMessage' => 'Success Send Rabbit MQ.',
                'aDataSubscribe' => array(
                    'ptSysBchCode'      => $this->tSysBchCode,
                    'ptComName'         => $this->tCompName,
                    'ptRptCode'         => $this->tRptCode,
                    'ptUserCode'        => $this->tUserLoginCode,
                    'ptUserSessionID'   => $this->tUserSessionID,
                    'pdDateSubscribe'   => $dDateSubscribe,
                    'pdTimeSubscribe'   => $dTimeSubscribe,
                )
            );
        } catch (Exception $Error) {
            $aResponse = array(
                'nStaEvent' => 500,
                'tMessage' => $Error->getMessage()
            );
        }
        echo json_encode($aResponse);
    }

    /**
     * Functionality: Render Excel Report
     * Parameters:  Function Parameter
     * Creator: 01/10/2020 Sooksanti
     * LastUpdate:
     * Return: file
     * ReturnType: file
     */
    public function FSvCCallRptRenderExcel()
    {
        $tFileName = $this->aText['tTitleReport'] . '_' . date('YmdHis') . '.xlsx';

        $oWriter = WriterEntityFactory::createXLSXWriter();

        $oWriter->openToBrowser($tFileName); // stream data directly to the browser

        $aMulltiRow = $this->FSoCCallRptRenderHedaerExcel(); //เรียกฟังชั่นสร้างส่วนหัวรายงาน
        $oWriter->addRows($aMulltiRow);

        $oBorder = (new BorderBuilder())
            ->setBorderTop(Color::BLACK, Border::WIDTH_THIN)
            ->setBorderBottom(Color::BLACK, Border::WIDTH_THIN)
            ->build();

        $oBorder = (new BorderBuilder())
            ->setBorderTop(Color::BLACK, Border::WIDTH_THIN)
            ->setBorderBottom(Color::BLACK, Border::WIDTH_THIN)
            ->build();

        $oStyleColums = (new StyleBuilder())
            ->setBorder($oBorder)
            ->setFontBold()
            ->build();

        $oStyle = (new StyleBuilder())->setCellAlignment(CellAlignment::RIGHT)->build();


        $aCells = [
            WriterEntityFactory::createCell($this->aText['tMerName']),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tShpName']),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tPdtCode']),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tPdtName']),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tQty'], $oStyle),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tPunName']),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tAmtTotal'], $oStyle),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tDisChg'], $oStyle),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tAgvPri'], $oStyle),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tGrandTotal'], $oStyle),
        ];


        /** add a row at a time */
        $singleRow = WriterEntityFactory::createRow($aCells, $oStyleColums);
        $oWriter->addRow($singleRow);

        $aDataWhereRpt = array(
            'nPerPage'      => 999999999999,
            'nPage'         => 1, // เริ่มรายงานหน้าแรก
            'tCompName'     => $this->tCompName,
            'tRptCode'      => $this->tRptCode,
            'tUsrSessionID' => $this->tUserSessionID,
        );
        $aDataReport = $this->Rptsalebymershop_model->FSaMGetDataReport($aDataWhereRpt);

        /** Create a style with the StyleBuilder */
        $oStyle = (new StyleBuilder())
            ->setCellAlignment(CellAlignment::RIGHT)
            ->build();

        $tMerCode       = ''; 
        $tMerNameShow   = ''; 
        $tShpCode       = '';
        $tShpNameShow   = ''; 

        if (isset($aDataReport['aRptData']) && !empty($aDataReport['aRptData'])) {
            foreach ($aDataReport['aRptData'] as $nKey => $aValue) {

                $values = [
                    WriterEntityFactory::createCell($aValue['FTMerName']),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell($aValue['FTShpName']),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell($aValue['FTPdtCode']),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell($aValue['FTPdtName']),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FTPXsdQty'])),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell($aValue['FTPunName']),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FCPXsdTotal'])),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FCPXsdDisChg'])),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FCPXsdAgvPri'])),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FCPXsdGrand'])),
                ];
                $aRow = WriterEntityFactory::createRow($values);
                $oWriter->addRow($aRow);

                if (($nKey + 1) == count($aDataReport['aRptData'])) { //SumFooter

                    $nFCPXsdQty_Footer      = $aValue["FCPXsdQty_Footer"];
                    $nFCPTotal_Footer       = $aValue["FCPTotal_Footer"];
                    $nFCPDisChg_Footer      = $aValue["FCPDisChg_Footer"];
                    $nFCPAgvPri_Footer      = $aValue["FCPAgvPri_Footer"];
                    $nFCPGrand_Footer       = $aValue["FCPGrand_Footer"];
                    $values = [
                        WriterEntityFactory::createCell(language('report/report/report', 'tRptTotalSub')),
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
                        WriterEntityFactory::createCell(FCNnGetNumeric($nFCPXsdQty_Footer)),
                        WriterEntityFactory::createCell(NULL),
                        WriterEntityFactory::createCell(NULL),
                        WriterEntityFactory::createCell(NULL),
                        WriterEntityFactory::createCell(FCNnGetNumeric($nFCPTotal_Footer)),
                        WriterEntityFactory::createCell(NULL),
                        WriterEntityFactory::createCell(FCNnGetNumeric($nFCPDisChg_Footer)),
                        WriterEntityFactory::createCell(NULL),
                        WriterEntityFactory::createCell(FCNnGetNumeric($nFCPAgvPri_Footer)),
                        WriterEntityFactory::createCell(NULL),
                        WriterEntityFactory::createCell(FCNnGetNumeric($nFCPGrand_Footer)),
                    ];
                    $aRow = WriterEntityFactory::createRow($values, $oStyleColums);
                    $oWriter->addRow($aRow);
                }

                // $tMerCode = $aValue['FTMerName'];
                // $tShpCode = $aValue['FTShpName'];
            }
        }

        $aMulltiRow = $this->FSoCCallRptRenderFooterExcel(); //เรียกฟังชั่นสร้างส่วนท้ายรายงาน
        $oWriter->addRows($aMulltiRow);

        $oWriter->close();
    }

    /**
     * Functionality: Render Excel Report Header
     * Parameters:  Function Parameter
     * Creator: 01/10/2020 Sooksanti
     * LastUpdate:
     * Return: oject
     * ReturnType: oject
     */
    public function FSoCCallRptRenderHedaerExcel(){
      if (isset($this->aCompanyInfo) && count($this->aCompanyInfo)>0) {
          $tFTAddV1Village      = $this->aCompanyInfo['FTAddV1Village']; 
          $tFTCmpName           = $this->aCompanyInfo['FTCmpName'];
          $tFTAddV1No           = $this->aCompanyInfo['FTAddV1No'];
          $tFTAddV1Road         = $this->aCompanyInfo['FTAddV1Road'];
          $tFTAddV1Soi          = $this->aCompanyInfo['FTAddV1Soi'];
          $tFTSudName           = $this->aCompanyInfo['FTSudName'];
          $tFTDstName           = $this->aCompanyInfo['FTDstName'];
          $tFTPvnName           = $this->aCompanyInfo['FTPvnName'];
          $tFTAddV1PostCode     = $this->aCompanyInfo['FTAddV1PostCode'];
          $tFTAddV2Desc1        = $this->aCompanyInfo['FTAddV2Desc1'];
          $tFTAddV2Desc2        = $this->aCompanyInfo['FTAddV2Desc2'];
          $tFTAddVersion        = $this->aCompanyInfo['FTAddVersion'];
          $tFTBchName           = $this->aCompanyInfo['FTBchName'];
          $tFTAddTaxNo          = $this->aCompanyInfo['FTAddTaxNo'];
          $tFTCmpTel            = $this->aCompanyInfo['FTAddTel'];
          $tRptFaxNo            = $this->aCompanyInfo['FTAddFax'];
      }else {
          $tFTCmpTel            = "";
          $tFTCmpName           = "";
          $tFTAddV1No           = "";
          $tFTAddV1Road         = "";
          $tFTAddV1Soi          = "";
          $tFTSudName           = "";
          $tFTDstName           = "";
          $tFTPvnName           = "";
          $tFTAddV1PostCode     = "";
          $tFTAddV2Desc1        = "1"; 
          $tFTAddV1Village      = "";
          $tFTAddV2Desc2        = "2";
          $tFTAddVersion        = "";
          $tFTBchName           = "";
          $tFTAddTaxNo          = "";
          $tRptFaxNo            = "";
      }
        $oStyle = (new StyleBuilder())
            ->setFontBold()
            ->setFontSize(12)
            ->build();

        $aCells = [
            WriterEntityFactory::createCell($tFTCmpName),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tTitleReport']),
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

        $aCells = [
            WriterEntityFactory::createCell($this->aText['tRptTel'] . ' ' . $tFTCmpTel . ' '.$this->aText['tRptFaxNo'] . ' ' . $tRptFaxNo),
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

        $aCells = [
            WriterEntityFactory::createCell($this->aText['tRptAddrBranch'] . ' ' . $tFTBchName),
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

        $aCells = [
            WriterEntityFactory::createCell($this->aText['tRPCTaxNo'] . ' : ' . $tFTAddTaxNo),
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

        // Fillter ปี
        if (!empty($this->aRptFilter['tYear']) && !empty($this->aRptFilter['tYear'])) {
            $aCells = [
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell($this->aText['tRptYear'] . '' . $this->aRptFilter['tYear']),
                WriterEntityFactory::createCell(null),
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

        // Fillter DocDate (วันที่สร้างเอกสาร)
        if ((isset($this->aRptFilter['tDocDateFrom']) && !empty($this->aRptFilter['tDocDateFrom'])) && (isset($this->aRptFilter['tDocDateTo']) && !empty($this->aRptFilter['tDocDateTo']))) {
            $aCells = [
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
                WriterEntityFactory::createCell($this->aText['tRptDateFrom'] . ' ' . date('d/m/Y', strtotime($this->aRptFilter['tDocDateFrom'])) . ' ' . $this->aText['tRptDateTo'] . ' ' . date('d/m/Y', strtotime($this->aRptFilter['tDocDateTo']))),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
                WriterEntityFactory::createCell(null),
            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells);
        }

        $aCells = [
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
        ];

        $aMulltiRow[] = WriterEntityFactory::createRow($aCells);

        $aCells = [
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
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell(null),
            WriterEntityFactory::createCell($this->aText['tDatePrint'] . ' ' . date('d/m/Y') . ' ' . $this->aText['tTimePrint'] . ' ' . date('H:i:s')),
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

        return $aMulltiRow;
    }

    /**
     * Functionality: Render Excel Report Footer
     * Parameters:  Function Parameter
     * Creator: 01/10/2020 Sooksanti
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
        // ตัวแทนขาย แบบเลือก
        if (!empty($this->aRptFilter['tAgnCode'])) {
            $tAgnSelectText = (!$this->aRptFilter['tAgnCode']) ? $this->aText['tRptAll'] : $this->aRptFilter['tAgnName'];
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptGrpAgency'] . ' : ' . $tAgnSelectText),
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

        // Fillter Shop (ร้านค้า)  แบบช่วง
        if (!empty($this->aRptFilter['tShpCodeFrom']) && !empty($this->aRptFilter['tShpCodeTo'])) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptShopFrom'] . ' : ' . $this->aRptFilter['tShpNameFrom'] . '     ' . $this->aText['tRptShopTo'] . ' : ' . $this->aRptFilter['tShpNameTo']),
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

        // Fillterฺ Mar (กลุ่มธุรกิจ) แบบช่วง
        if (!empty($this->aRptFilter['tMerCodeFrom']) && !empty($this->aRptFilter['tMerCodeTo'])) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptMerFrom'] . ' : ' . $this->aRptFilter['tMerNameFrom'] . '     ' . $this->aText['tRptMerTo'] . ' : ' . $this->aRptFilter['tMerNameTo']),
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

        // Fillterฺ Pos (เครื่องจุดขาย)) แบบช่วง
        if (!empty($this->aRptFilter['tPosCodeFrom']) && !empty($this->aRptFilter['tPosCodeTo'])) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptPosFrom'] . ' : ' . $this->aRptFilter['tPosNameFrom'] . '     ' . $this->aText['tRptPosTo'] . ' : ' . $this->aRptFilter['tPosNameTo']),
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

        // Fillter Product (สินค้า)
        if (!empty($this->aRptFilter['tPdtCodeFrom']) && !empty($this->aRptFilter['tPdtCodeTo'])) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tPdtCodeFrom'] . ' : ' . $this->aRptFilter['tPdtNameFrom'] . '     ' . $this->aText['tPdtCodeTo'] . ' : ' . $this->aRptFilter['tPdtNameTo']),
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

        // Fillter Wah (คลัง)
        if (!empty($this->aRptFilter['tWahCodeFrom']) && !empty($this->aRptFilter['tWahCodeTo'])) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptFromWareHouse'] . ' : ' . $this->aRptFilter['tWahNameFrom'] . '     ' . $this->aText['tRptToWareHouse'] . ' : ' . $this->aRptFilter['tWahNameTo']),
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

        // Fillter StaPdtActive (สถานะเคลื่อนไหว)
        if (isset($this->aRptFilter['tPdtStaActive']) && !empty($this->aRptFilter['tPdtStaActive'])) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptTitlePdtMoving'] . ' : ' . $this->aText['tRptPdtMoving' . $this->aRptFilter['tPdtStaActive']]),
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

         // Fillterฺ Coupon (คูปอง)) แบบช่วง
        if (!empty($this->aRptFilter['tCouponCodeFrom']) && !empty($this->aRptFilter['tCouponCodeTo'])) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptCouponFrom'] . ' : ' . $this->aRptFilter['tCouponNameFrom'] . '     ' . $this->aText['tRptCouponTo'] . ' : ' . $this->aRptFilter['tCouponNameTo']),
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

        return $aMulltiRow;
    }




}
