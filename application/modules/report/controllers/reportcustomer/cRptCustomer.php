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

date_default_timezone_set("Asia/Bangkok");

class cRptCustomer extends MX_Controller{
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
     * User Login Session
     * @var string
     */
    public $tSysBchCode;


    public function __construct() {
        $this->load->helper('report');
        $this->load->model('company/company/mCompany');
        $this->load->model('report/report/mReport');
        $this->load->model('report/reportcustomer/mRptCustomer');

        // Init Report
        $this->init();

        parent::__construct();
    }

    private function init() {
        $this->aText = [
            'tTitleReport'         => language('report/report/report', 'tRptMasCstTitle'),
            'tDatePrint'           => language('report/report/report', 'tRptSalByDTDatePrint'),
            'tTimePrint'           => language('report/report/report', 'tRptSalByDTTimePrint'),

            // Address Lang
            'tRptAddrBuilding'      => language('report/report/report', 'tRptAddrBuilding'),
            'tRptAddrRoad'          => language('report/report/report', 'tRptAddrRoad'),
            'tRptAddrSoi'           => language('report/report/report', 'tRptAddrSoi'),
            'tRptAddrSubDistrict'   => language('report/report/report', 'tRptAddrSubDistrict'),
            'tRptAddrDistrict'      => language('report/report/report', 'tRptAddrDistrict'),
            'tRptAddrProvince'      => language('report/report/report', 'tRptAddrProvince'),
            'tRptAddrTel'           => language('report/report/report', 'tRptAddrTel'),
            'tRptAddrFax'           => language('report/report/report', 'tRptAddrFax'),
            'tRptAddrBranch'        => language('report/report/report', 'tRptAddrBranch'),
            'tRptAddV2Desc1'        => language('report/report/report', 'tRptAddV2Desc1'),
            'tRptAddV2Desc2'        => language('report/report/report', 'tRptAddV2Desc2'),
            'tRPCTaxNo' => language('report/report/report', 'tRPCTaxNo'),
            'tRptTaxSalePosTel'     => language('report/report/report', 'tRptTaxSalePosTel'),
            'tRptTaxSalePosFax'     => language('report/report/report', 'tRptTaxSalePosFax'),
            'tRptTaxSalePosBch'     => language('report/report/report', 'tRptTaxSalePosBch'),
            'tRptTaxSalePosTaxId'   => language('report/report/report', 'tRptTaxSalePosTaxId'),
            'tRptFaxNo' => language('report/report/report', 'tRptFaxNo'),
            'tRptTel' => language('report/report/report', 'tRptTel'),
            'tRptTaxSaleMemberDocDateFrom' => language('report/report/report', 'tRptTaxSalePosFilterDocDateFrom'),
            'tRptTaxSaleMemberDocDateTo'   => language('report/report/report', 'tRptTaxSalePosFilterDocDateTo'),
            'tRptTaxSaleMemberBchFrom'     => language('report/report/report', 'tRptTaxSalePosFilterBchFrom'),
            'tRptTaxSaleMemberBchTo'       => language('report/report/report', 'tRptTaxSalePosFilterBchTo'),


            'tRptCstGrpFrom'       => language('report/report/report', 'tRptCstGrpFrom'),
            'tRptCstGrpTo'       => language('report/report/report', 'tRptCstGrpTo'),
            'tRptCstTypeFrom'       => language('report/report/report', 'tRptCstTypeFrom'),
            'tRptCstTypeTo'       => language('report/report/report', 'tRptCstTypeTo'),
            'tRptCstLevFrom'       => language('report/report/report', 'tRptCstLevFrom'),
            'tRptCstLevTo'       => language('report/report/report', 'tRptCstLevTo'),
            

            //header
            'tRptMasCstCode'               => language('report/report/report', 'tRptMasCstCode'),
            'tRptMasCstName'               => language('report/report/report', 'tRptMasCstName'),
            'tRptMasCstCard'                  => language('report/report/report', 'tRptMasCstCard'),
            'tRptMasCstSalTotal'              => language('report/report/report', 'tRptMasCstSalTotal'),
            'tRptMasCstLstSal'             => language('report/report/report', 'tRptMasCstLstSal'),
            'tRptMasCstLstSalDate'             => language('report/report/report', 'tRptMasCstLstSalDate'),
            'tRptMasCstBchName'             => language('report/report/report', 'tRptMasCstBchName'),
            'tRptMasCstTel'             => language('report/report/report', 'tRptMasCstTel'),
            'tRptMasCstDob'             => language('report/report/report', 'tRptMasCstDob'),
            'tRptMasCstSex'             => language('report/report/report', 'tRptMasCstSex'),
            'tRptMasCstCountChn'             => language('report/report/report', 'tRptMasCstCountChn'),
            'tRptMasCstAddress'             => language('report/report/report', 'tRptMasCstAddress'),
            'tReportSellTolSex1'             => language('report/report/report', 'tReportSellTolSex1'),
            'tReportSellTolSex2'             => language('report/report/report', 'tReportSellTolSex2'),
            
            'tRptSbdTotal'             => language('report/report/report', 'tRptByBillTotal'),


            'tRptRentAmtFolCourSumText' => language('report/report/report', 'tRptRentAmtFolCourSumText'),
            'tRptConditionInReport'     => language('report/report/report', 'tRptConditionInReport'),
            // No Data Report
            'tRptTaxSalePosNoData'      => language('common/main/main', 'tCMNNotFoundData'),


            'tRptBchFrom'               => language('report/report/report', 'tRptBchFrom'),
            'tRptBchTo'                 => language('report/report/report', 'tRptBchTo'),
            'tRptMerFrom'               => language('report/report/report', 'tRptMerFrom'),
            'tRptMerTo'                 => language('report/report/report', 'tRptMerTo'),
            'tRptShopFrom'              => language('report/report/report', 'tRptShopFrom'),
            'tRptShopTo'                => language('report/report/report', 'tRptShopTo'),
            'tRptPosFrom'               => language('report/report/report', 'tRptPosFrom'),
            'tRptPosTo'                 => language('report/report/report', 'tRptPosTo'),

            'tRowNumber'                 => language('report/report/report', 'tRowNumber'),

            'tRptPosType'               => language('report/report/report', 'tRptPosType'),
            'tRptPosType1'              => language('report/report/report', 'tRptPosType1'),
            'tRptPosType2'              => language('report/report/report', 'tRptPosType2'),
            'tRptPosTypeName'           => language('report/report/report', 'tRptPosTypeName'),
            'tRptAll'                   => language('report/report/report', 'tRptAll'),
            'tPdtTypeFrom'               => language('report/report/report', 'tPdtTypeFrom'),
            'tPdtTypeTo'                 => language('report/report/report', 'tPdtTypeTo'),
            'tRptBrandFrom'               => language('report/report/report', 'tRptBrandFrom'),
            'tRptBrandTo'                 => language('report/report/report', 'tRptBrandTo'),
            'tPdtCodeFrom'               => language('report/report/report', 'tPdtCodeFrom'),
            'tPdtCodeTo'                 => language('report/report/report', 'tPdtCodeTo'),
            'tRptCstFrom'               => language('report/report/report', 'tRptCstFrom'),
            'tRptCstTo'                 => language('report/report/report', 'tRptCstTo'),
            
        ];
        // echo '<pre>';
        // print_r($this->input->post());
        // echo '</pre>';
        // die();
        $this->tSysBchCode          = SYS_BCH_CODE;
        $this->tBchCodeLogin        = (!empty($this->session->userdata('tSesUsrBchCom')) ? $this->session->userdata('tSesUsrBchCom') : $this->session->userdata('tSesUsrBchCom'));
        $this->nPerPage             = 100;
        $this->nOptDecimalShow      = FCNxHGetOptionDecimalShow();

        $tIP                        = $this->input->ip_address();
        $tFullHost                  = gethostbyaddr($tIP);
        $this->tCompName            = $tFullHost;

        $this->nLngID               = FCNaHGetLangEdit();
        $this->tRptCode             = $this->input->post('ohdRptCode');
        $this->tRptGroup            = $this->input->post('ohdRptGrpCode');
        $this->tUserSessionID       = $this->session->userdata('tSesSessionID');
        $this->tRptRoute            = $this->input->post('ohdRptRoute');
        $this->tRptExportType       = $this->input->post('ohdRptTypeExport');
        $this->nPage                = empty($this->input->post('ohdRptCurrentPage')) ? 1 : $this->input->post('ohdRptCurrentPage');
        $this->tUserLoginCode       = $this->session->userdata('tSesUsername');

        // Report Filter
        $this->aRptFilter = [
            'tUserSession'      => $this->tUserSessionID,
            'tCompName'         => $tFullHost,
            'tRptCode'          => $this->tRptCode,
            'nLangID'           => $this->nLngID,

            'tTypeSelect'       => !empty($this->input->post('ohdTypeDataCondition')) ? $this->input->post('ohdTypeDataCondition') : "",

            // สาขา(Branch)
            'tBchCodeFrom'      => !empty($this->input->post('oetRptBchCodeFrom')) ? $this->input->post('oetRptBchCodeFrom') : "",
            'tBchNameFrom'      => !empty($this->input->post('oetRptBchNameFrom')) ? $this->input->post('oetRptBchNameFrom') : "",
            'tBchCodeTo'        => !empty($this->input->post('oetRptBchCodeTo')) ? $this->input->post('oetRptBchCodeTo') : "",
            'tBchNameTo'        => !empty($this->input->post('oetRptBchNameTo')) ? $this->input->post('oetRptBchNameTo') : "",
            'tBchCodeSelect'    => !empty($this->input->post('oetRptBchCodeSelect')) ? $this->input->post('oetRptBchCodeSelect') : "",
            'tBchNameSelect'    => !empty($this->input->post('oetRptBchNameSelect')) ? $this->input->post('oetRptBchNameSelect') : "",
            'bBchStaSelectAll'  => !empty($this->input->post('oetRptBchStaSelectAll')) && ($this->input->post('oetRptBchStaSelectAll') == 1) ? true : false,

            // กลุ่มธุรกิจ
            'tRptMerCodeFrom'   => !empty($this->input->post('oetRptMerCodeFrom')) ? $this->input->post('oetRptMerCodeFrom') : "",
            'tRptMerNameFrom'   => !empty($this->input->post('oetRptMerNameFrom')) ? $this->input->post('oetRptMerNameFrom') : "",
            'tRptMerCodeTo'     => !empty($this->input->post('oetRptMerCodeTo')) ? $this->input->post('oetRptMerCodeTo') : "",
            'tRptMerNameTo'     => !empty($this->input->post('oetRptMerNameTo')) ? $this->input->post('oetRptMerNameTo') : "",
            'tMerCodeSelect'    => !empty($this->input->post('oetRptMerCodeSelect')) ? $this->input->post('oetRptMerCodeSelect') : "",
            'tMerNameSelect'    => !empty($this->input->post('oetRptMerNameSelect')) ? $this->input->post('oetRptMerNameSelect') : "",
            'bMerStaSelectAll'  => !empty($this->input->post('oetRptMerStaSelectAll')) && ($this->input->post('oetRptMerStaSelectAll') == 1) ? true : false,

            // ร้านค้า
            'tRptShpCodeFrom'   => !empty($this->input->post('oetRptShpCodeFrom')) ? $this->input->post('oetRptShpCodeFrom') : "",
            'tRptShpNameFrom'   => !empty($this->input->post('oetRptShpNameFrom')) ? $this->input->post('oetRptShpNameFrom') : "",
            'tRptShpCodeTo'     => !empty($this->input->post('oetRptShpCodeTo')) ? $this->input->post('oetRptShpCodeTo') : "",
            'tRptShpNameTo'     => !empty($this->input->post('oetRptShpNameTo')) ? $this->input->post('oetRptShpNameTo') : "",
            'tShpCodeSelect'    => !empty($this->input->post('oetRptShpCodeSelect')) ? $this->input->post('oetRptShpCodeSelect') : "",
            'tShpNameSelect'    => !empty($this->input->post('oetRptShpNameSelect')) ? $this->input->post('oetRptShpNameSelect') : "",
            'bShpStaSelectAll'  => !empty($this->input->post('oetRptShpStaSelectAll')) && ($this->input->post('oetRptShpStaSelectAll') == 1) ? true : false,

            // เครื่องจุดขาย
            'tRptPosCodeFrom'   => !empty($this->input->post('oetRptPosCodeFrom')) ? $this->input->post('oetRptPosCodeFrom') : "",
            'tRptPosNameFrom'   => !empty($this->input->post('oetRptPosNameFrom')) ? $this->input->post('oetRptPosNameFrom') : "",
            'tRptPosCodeTo'     => !empty($this->input->post('oetRptPosCodeTo')) ? $this->input->post('oetRptPosCodeTo') : "",
            'tRptPosNameTo'     => !empty($this->input->post('oetRptPosNameTo')) ? $this->input->post('oetRptPosNameTo') : "",
            'tPosCodeSelect'    => !empty($this->input->post('oetRptPosCodeSelect')) ? $this->input->post('oetRptPosCodeSelect') : "",
            'tPosNameSelect'    => !empty($this->input->post('oetRptPosNameSelect')) ? $this->input->post('oetRptPosNameSelect') : "",
            'bPosStaSelectAll'  => !empty($this->input->post('oetRptPosStaSelectAll')) && ($this->input->post('oetRptPosStaSelectAll') == 1) ? true : false,


            //ตัวแทนขาย
            'tSpcAgncyCode'      => !empty($this->input->post('oetSpcAgncyCode')) ? $this->input->post('oetSpcAgncyCode') : "",

            // กลุ่มลูกค้า
            'tRptCgpCodeFrm'      => !empty($this->input->post('oetRptCgpCodeFrm')) ? $this->input->post('oetRptCgpCodeFrm') : "",
            'tRptCgpNameFrm'      => !empty($this->input->post('oetRptCgpNameFrm')) ? $this->input->post('oetRptCgpNameFrm') : "",
            'tRptCgpCodeTo'        => !empty($this->input->post('oetRptCgpCodeTo')) ? $this->input->post('oetRptCgpCodeTo') : "",
            'tRptCgpNameTo'        => !empty($this->input->post('oetRptCgpNameTo')) ? $this->input->post('oetRptCgpNameTo') : "",

            // ประเภทลูกค้า
            'tRptCtyCodeFrm'      => !empty($this->input->post('oetRptCtyCodeFrm')) ? $this->input->post('oetRptCtyCodeFrm') : "",
            'tRptCtyNameFrm'      => !empty($this->input->post('oetRptCtyNameFrm')) ? $this->input->post('oetRptCtyNameFrm') : "",
            'tRptCtyCodeTo'        => !empty($this->input->post('oetRptCtyCodeTo')) ? $this->input->post('oetRptCtyCodeTo') : "",
            'tRptCtyNameTo'        => !empty($this->input->post('oetRptCtyNameTo')) ? $this->input->post('oetRptCtyNameTo') : "",
          
    
            // ระดับลูกค้า
            'tRptClvCodeFrm'      => !empty($this->input->post('oetRptClvCodeFrm')) ? $this->input->post('oetRptClvCodeFrm') : "",
            'tRptClvNameFrm'      => !empty($this->input->post('oetRptClvNameFrm')) ? $this->input->post('oetRptClvNameFrm') : "",
            'tRptClvCodeTo'        => !empty($this->input->post('oetRptClvCodeTo')) ? $this->input->post('oetRptClvCodeTo') : "",
            'tRptClvNameTo'        => !empty($this->input->post('oetRptClvNameTo')) ? $this->input->post('oetRptClvNameTo') : "",
            
            // ลูกค้า
            'tCstCodeFrom'      => !empty($this->input->post('oetRptCstCodeFrom')) ? $this->input->post('oetRptCstCodeFrom') : "",
            'tCstNameFrom'      => !empty($this->input->post('oetRptCstNameFrom')) ? $this->input->post('oetRptCstNameFrom') : "",
            'tCstCodeTo'        => !empty($this->input->post('oetRptCstCodeTo')) ? $this->input->post('oetRptCstCodeTo') : "",
            'tCstNameTo'        => !empty($this->input->post('oetRptCstNameTo')) ? $this->input->post('oetRptCstNameTo') : "",

            // วันที่เอกสาร(DocNo)
            'tDocDateFrom'      => !empty($this->input->post('oetRptDocDateFrom')) ? $this->input->post('oetRptDocDateFrom') : "",
            'tDocDateTo'        => !empty($this->input->post('oetRptDocDateTo')) ? $this->input->post('oetRptDocDateTo') : "",

            //ประเภทเครื่องจุดขาย
            'tPosType'          =>  !empty($this->input->post('ocmPosType')) ? $this->input->post('ocmPosType') : "",

        ];

         // ดึงข้อมูลบริษัทฯ
         $aCompInfoParams = [
            'nLngID'    => $this->nLngID,
            'tBchCode'  => $this->tBchCodeLogin
        ];

        $this->aCompanyInfo = FCNaGetCompanyInfo($aCompInfoParams)['raItems'];
    }

    public function index() {
        if (!empty($this->tRptCode) && !empty($this->tRptExportType)) {



            // // Call Stored Procedure
            $this->mRptCustomer->FSnMExecStoreReport($this->aRptFilter);

            // // //  // Count Rows
             $aCountRowParams = [
                'tCompName'      => $this->tCompName,
                'tRptCode'       => $this->tRptCode,
                'tUsrSessionID'  => $this->tUserSessionID,
                'aDataFilter'    => $this->aRptFilter
            ];

             $this->nRows = $this->mRptCustomer->FSnMCountRowInTemp($aCountRowParams);

            // // // // // // Report Type
            switch ($this->tRptExportType) {
                case 'html':
                    $this->FSvCCallRptViewBeforePrint();
                    break;
                case 'excel':
                    $this->FSvCCallRptRenderExcel($this->aRptFilter);
                    break;
                case 'pdf':
                    $this->FSvCCallRptRenderExcel($this->aRptFilter);
                    break;
            }
        }
    }


      /**
     * Functionality: ฟังก์ชั่นดูตัวอย่างก่อนพิมพ์ (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 21/12/2019 Witsarut(Bell)
     * LastUpdate: -
     * Return: View Report Viewersd
     * ReturnType: View
     */
    public function FSvCCallRptViewBeforePrint(){
        try{

            $aDataReportParams = [
                'nPerPage'      => $this->nPerPage,
                'nPage'         => $this->nPage,
                'tCompName'     => $this->tCompName,
                'tRptCode'      => $this->tRptCode,
                'tUsrSessionID' => $this->tUserSessionID,
                'aDataFilter'   => $this->aRptFilter
            ];

            //Get Data
            $aDataReport = $this->mRptCustomer->FSaMGetDataReport($aDataReportParams);

            // Load View Advance Table
            $aDataViewRptParams = [
                'nOptDecimalShow' => $this->nOptDecimalShow,
                'aCompanyInfo'    => $this->aCompanyInfo,
                'aDataReport'     => $aDataReport,
                'aDataTextRef'    => $this->aText,
                'aDataFilter'     => $this->aRptFilter
            ];

            $tRptView = JCNoHLoadViewAdvanceTable('report/datasources/rptCustomer', 'wRptCustomerHtml', $aDataViewRptParams);


            // Data Viewer Center Report
            $aDataViewerParams = [
                'tTitleReport'    => $this->aText['tTitleReport'],
                'tRptTypeExport'  => $this->tRptExportType,
                'tRptCode'        => $this->tRptCode,
                'tRptRoute'       => $this->tRptRoute,
                'tViewRenderKool' => $tRptView,
                'aDataFilter' => $this->aRptFilter,
                'aDataReport' => [
                    'raItems'       => $aDataReport['aRptData'],
                    'rnAllRow'      => $aDataReport['aPagination']['nTotalRecord'],
                    'rnCurrentPage' => $aDataReport['aPagination']['nDisplayPage'],
                    'rnAllPage'     => $aDataReport['aPagination']['nTotalPage'],
                    'rtCode'        => '1',
                    'rtDesc'        => 'success',

                ]
            ];

            $this->load->view('report/report/wReportViewer', $aDataViewerParams);
            /** =========== End Render View ================================== */

        }catch(Exception $Error){
            echo $Error;
        }
    }

     /**
     * Functionality: Click Page Report (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 15/10/2562 Witsarut(Bell)
     * LastUpdate: -
     * Return: View Report Viewer
     * ReturnType: View
     */
    public function FSvCCallRptViewBeforePrintClickPage(){
        /** =========== Begin Init Variable ================================== */
        $aDataFilter = json_decode($this->input->post('ohdRptDataFilter'), true);
        /** =========== End Init Variable ==================================== */

        $aDataWhere = array(
            'tUserSession'      => $this->tUserSessionID,
            'tCompName'         => $this->tCompName,
            'tUserCode'         => $this->tUserLoginCode,
            'tRptCode'          => $this->tRptCode,
            'nPage'             => $this->nPage,
            'nRow'              => $this->nPerPage,
            'nPerPage'          => $this->nPerPage,
            'tUsrSessionID'     => $this->tUserSessionID,
            'aDataFilter'       => $this->aRptFilter
        );

        //Get Data
        $aDataReport = $this->mRptCustomer->FSaMGetDataReport($aDataWhere, $aDataFilter);

        // GetDataSumFootReport
        // $aDataSumFoot = $this->mRptCustomer->FSaMGetDataSumFootReport($aDataWhere, $aDataFilter);

        // Load View Advance Table
        $aDataViewRptParams = [
            'aDataReport'       => $aDataReport,
            'aDataTextRef'      => $this->aText,
            'aCompanyInfo'      => $this->aCompanyInfo,
            'nOptDecimalShow'   => $this->nOptDecimalShow,
            'aDataFilter'       => $this->aRptFilter
        ];

        // Load View Advance Tablew
        $tRptView = JCNoHLoadViewAdvanceTable('report/datasources/rptCustomer', 'wRptCustomerHtml', $aDataViewRptParams);

        // Data Viewer Center Report
        $aDataViewer = array(
            'tTitleReport' => $this->aText['tTitleReport'],
            'tRptTypeExport' => $this->tRptExportType,
            'tRptCode' => $this->tRptCode,
            'tRptRoute' => $this->tRptRoute,
            'tViewRenderKool' => $tRptView,
            'aDataFilter' => $aDataFilter,
            'aDataReport' => array(
                'raItems' => $aDataReport['aRptData'],
                'rnAllRow' => $aDataReport['aPagination']['nTotalRecord'],
                'rnCurrentPage' => $aDataReport['aPagination']['nDisplayPage'],
                'rnAllPage' => $aDataReport['aPagination']['nTotalPage'],
                'rtCode' => '1',
                'rtDesc' => 'success',
            )
        );

        $this->load->view('report/report/wReportViewer', $aDataViewer);

    }

    /**
     * Functionality: Click Page Report (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 23/09/2019 Witsarut
     * LastUpdate:
     * Return: object Status Count Data Report
     * ReturnType: Object
     */
    public function FSoCChkDataReportInTableTemp(){
        try{
            $aDataCountData = [
                'tCompName'     => $this->tCompName,
                'tRptCode'      => $this->tRptCode,
                'tUserSession'  => $this->tUserSessionID,
                'aDataFilter'   => $this->aRptFilter
            ];

            $nDataCountPage     = $this->mRptCustomer->FSnMCountRowInTemp($aDataCountData);

            $aResponse = array(
                'nCountPageAll' => $nDataCountPage,
                'nStaEvent'     => 1,
                'tMessage'      => 'Success Count Data All'
            );
        }catch(ErrorException $Error){
            $aResponse = array(
                'nStaEvent' => 500,
                'tMessage' => $Error->getMessage()
            );
        }
        echo json_encode($aResponse);
    }


    /**
     * Functionality: Send Rabbit MQ Report
     * Parameters:  Function Parameter
     * Creator: 23/069/2019 Witsarut
     * LastUpdate:
     * Return: object Send Rabbit MQ Report
     * ReturnType: Object
     */
    public function FSvCCallRptExportFile(){
        $dDateSendMQ     = date('Y-m-d');
        $dTimeSendMQ     = date('H:i:s');
        $dDateSubscribe  = date('Ymd');
        $dTimeSubscribe  = date('His');

        // Set Parameter Send MQ
        $tRptQueueName = 'RPT_' . $this->tSysBchCode . '_' . $this->tRptGroup . '_' . $this->tRptCode;

        $aDataSendMQ    = [
            'tQueueName' => $tRptQueueName,
            'aParams' => [
                'ptRptCode'         => $this->tRptCode,
                'pnPerFile'         => 20000,
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
        $aResponse  = array(
            'nStaEvent' => 1,
            'tMessage'  => 'Success Send Rabbit MQ.',
            'aDataSubscribe'    => array(
                'ptSysBchCode'      => $this->tSysBchCode,
                'ptComName'         => $this->tCompName,
                'ptRptCode'         => $this->tRptCode,
                'ptUserCode'        => $this->tUserLoginCode,
                'ptUserSessionID'   => $this->tUserSessionID,
                'pdDateSubscribe'   => $dDateSubscribe,
                'pdTimeSubscribe'   => $dTimeSubscribe,
            )
        );
        echo json_encode($aResponse);
    }


    /**
     * Functionality: Render Excel Report
     * Parameters:  Function Parameter
     * Creator: 30/07/2020 Nattakit
     * LastUpdate:
     * Return: file
     * ReturnType: file
     */
    public function  FSvCCallRptRenderExcel(){
        $tFileName = $this->aText['tTitleReport'].'_'.date('YmdHis').'.xlsx';
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
                ->setFontBold()
                ->build();

            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptMasCstCode']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstName']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstCard']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstSalTotal']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstLstSal']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstLstSalDate']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstBchName']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstTel']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstDob']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstSex']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstCountChn']),
                WriterEntityFactory::createCell($this->aText['tRptMasCstAddress'])
                ];

       
            /** add a row at a time */
            $singleRow = WriterEntityFactory::createRow($aCells,$oStyleColums);
            $oWriter->addRow($singleRow);

        $aDataReportParams = [
            'nPerPage'      => 999999999999,
            'nPage'         => $this->nPage,
            'tCompName'     => $this->tCompName,
            'tRptCode'      => $this->tRptCode,
            'tUsrSessionID' => $this->tUserSessionID,
            'aDataFilter'   => $this->aRptFilter
        ];

      //Get Data
      $aDataReport = $this->mRptCustomer->FSaMGetDataReport($aDataReportParams);

         /** Create a style with the StyleBuilder */
            $oStyle = (new StyleBuilder())
                    ->setCellAlignment(CellAlignment::RIGHT)
                    ->build();

         if(isset($aDataReport['aRptData']) && !empty($aDataReport['aRptData'])) {
             foreach ($aDataReport['aRptData'] as $nKey => $aValue) {

                if(!empty($aValue['FDXshLastDate'])){ 
                    $dXshLastDate = date('d/m/Y H:i:s',strtotime($aValue['FDXshLastDate']));
                }else{
                    $dXshLastDate = NULL;
                }

                if(!empty($aValue['FTBchCode'])){ 
                    $tBchCode = '('.$aValue['FTBchCode'].') '.$aValue['FTBchName'];
                }else{
                    $tBchCode = NULL;
                }

                if(!empty($aValue['FTCstSex'])){ 
                     $tCstSex = $this->aText['tReportSellTolSex'.$aValue['FTCstSex']];
                 }else{
                     $tCstSex =  NULL;
                 }
                       $values= [
                                WriterEntityFactory::createCell($aValue['FTCstCode']),
                                WriterEntityFactory::createCell($aValue['FTCstName']),
                                WriterEntityFactory::createCell($aValue['FTCstCrdNo']),
                                WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FCTxnBuyTotal'])),
                                WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FCXshGrand'])),
                                WriterEntityFactory::createCell($dXshLastDate),
                                WriterEntityFactory::createCell($tBchCode),
                                WriterEntityFactory::createCell($aValue['FTCstTel']),
                                WriterEntityFactory::createCell(date('d/m/Y',strtotime($aValue['FDCstDob']))),
                                WriterEntityFactory::createCell($tCstSex),
                                WriterEntityFactory::createCell($aValue['FTChnCount']),
                                WriterEntityFactory::createCell($aValue['FTCstAddress'])
                        
                          
                        ];
                        $aRow = WriterEntityFactory::createRow($values);
                        $oWriter->addRow($aRow);

                    if(($nKey+1)==FCNnHSizeOf($aDataReport['aRptData'])){ //SumFooter
                        $values= [
                            WriterEntityFactory::createCell($this->aText['tRptSbdTotal']),
                            WriterEntityFactory::createCell(NULL),
                            WriterEntityFactory::createCell(NULL),
                            WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FCTxnBuyTotal_Footer'])),
                            WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FCXshGrand_Footer'])),
                            WriterEntityFactory::createCell(NULL),
                            WriterEntityFactory::createCell(NULL),
                            WriterEntityFactory::createCell(NULL),
                            WriterEntityFactory::createCell(NULL),
                            WriterEntityFactory::createCell(NULL),
                            WriterEntityFactory::createCell(NULL),
                      
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
     * Creator: 30/07/2020 Nattakit
     * LastUpdate:
     * Return: oject
     * ReturnType: oject
     */
    public function FSoCCallRptRenderHedaerExcel(){
        if (isset($this->aCompanyInfo) && count($this->aCompanyInfo)>0) {
    $tFTAddV1Village = $this->aCompanyInfo['FTAddV1Village']; 
            $tFTCmpName = $this->aCompanyInfo['FTCmpName'];
            $tFTAddV1No = $this->aCompanyInfo['FTAddV1No'];
            $tFTAddV1Road = $this->aCompanyInfo['FTAddV1Road'];
            $tFTAddV1Soi = $this->aCompanyInfo['FTAddV1Soi'];
            $tFTSudName = $this->aCompanyInfo['FTSudName'];
            $tFTDstName = $this->aCompanyInfo['FTDstName'];
            $tFTPvnName = $this->aCompanyInfo['FTPvnName'];
            $tFTAddV1PostCode = $this->aCompanyInfo['FTAddV1PostCode'];
            $tFTAddV2Desc1 = $this->aCompanyInfo['FTAddV2Desc1'];
            $tFTAddV2Desc2 = $this->aCompanyInfo['FTAddV2Desc2'];
            $tFTAddVersion = $this->aCompanyInfo['FTAddVersion'];
            $tFTBchName = $this->aCompanyInfo['FTBchName'];
            $tFTAddTaxNo = $this->aCompanyInfo['FTAddTaxNo'];
            $tFTCmpTel = $this->aCompanyInfo['FTAddTel'];
            $tRptFaxNo = $this->aCompanyInfo['FTAddFax'];
        }else {
            $tFTCmpTel = "";
            $tFTCmpName = "";
            $tFTAddV1No = "";
            $tFTAddV1Road = "";
            $tFTAddV1Soi = "";
            $tFTSudName = "";
            $tFTDstName = "";
            $tFTPvnName = "";
            $tFTAddV1PostCode = "";
            $tFTAddV2Desc1 = "1"; $tFTAddV1Village = "";
            $tFTAddV2Desc2 = "2";
            $tFTAddVersion = "";
            $tFTBchName = "";
            $tFTAddTaxNo = "";
            $tRptFaxNo = "";
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
        WriterEntityFactory::createCell($this->aText['tTitleReport']),
        WriterEntityFactory::createCell(NULL),
        WriterEntityFactory::createCell(NULL),
        WriterEntityFactory::createCell(NULL),
        ];

        $aMulltiRow[] = WriterEntityFactory::createRow($aCells,$oStyle);

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
            WriterEntityFactory::createCell($this->aText['tRptAddrBranch'] .' '. $tFTBchName),
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


        if((isset($this->aRptFilter['tDocDateFrom']) && !empty($this->aRptFilter['tDocDateFrom'])) && (isset($this->aRptFilter['tDocDateTo']) && !empty($this->aRptFilter['tDocDateTo']))){
            $aCells = [
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell($this->aText['tRptTaxSaleMemberDocDateFrom'].' '.date('d/m/Y',strtotime($this->aRptFilter['tDocDateFrom'])).' '.$this->aText['tRptTaxSaleMemberDocDateTo'].' '.date('d/m/Y',strtotime($this->aRptFilter['tDocDateTo']))),
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
            WriterEntityFactory::createCell($this->aText['tDatePrint'].' '.date('d/m/Y').' '.$this->aText['tTimePrint'].' '.date('H:i:s')),
            ];

        $aMulltiRow[] = WriterEntityFactory::createRow($aCells);

        return $aMulltiRow;

    }

    /**
     * Functionality: Render Excel Report Footer
     * Parameters:  Function Parameter
     * Creator: 30/07/2020 Nattakit
     * LastUpdate:
     * Return: oject
     * ReturnType: oject
     */
    public function FSoCCallRptRenderFooterExcel(){

        $oStyleFilter = (new StyleBuilder())
        ->setFontBold()
        ->build();
    $aCells = [
        WriterEntityFactory::createCell($this->aText['tRptConditionInReport']),
        WriterEntityFactory::createCell(NULL),
        WriterEntityFactory::createCell(NULL),
        WriterEntityFactory::createCell(NULL),
        WriterEntityFactory::createCell(NULL),
        WriterEntityFactory::createCell(NULL),
        WriterEntityFactory::createCell(NULL),
        WriterEntityFactory::createCell(NULL),
        WriterEntityFactory::createCell(NULL),
        ];
        $aMulltiRow[] = WriterEntityFactory::createRow($aCells,$oStyleFilter);


        if (isset($this->aRptFilter['tBchCodeSelect']) && !empty($this->aRptFilter['tBchCodeSelect'])) {
          $tBchSelect =  ($this->aRptFilter['bBchStaSelectAll']) ? $this->aText['tRptAll'] : $this->aRptFilter['tBchNameSelect'];
        $aCells = [
            WriterEntityFactory::createCell($this->aText['tRptBchFrom'].' : '.$tBchSelect),
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
        }


        if (isset($this->aRptFilter['tMerCodeSelect']) && !empty($this->aRptFilter['tMerCodeSelect'])) {
            $tMerSelect =  ($this->aRptFilter['bMerStaSelectAll']) ? $this->aText['tRptAll'] : $this->aRptFilter['tMerNameSelect'];
          $aCells = [
              WriterEntityFactory::createCell($this->aText['tRptMerFrom'].' : '.$tMerSelect),
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
          }

          if (isset($this->aRptFilter['tShpCodeSelect']) && !empty($this->aRptFilter['tShpCodeSelect'])) {
            $tShpSelect =  ($this->aRptFilter['bShpStaSelectAll']) ? $this->aText['tRptAll'] : $this->aRptFilter['tShpNameSelect'];
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptAdjShopFrom'].' : '.$tShpSelect),
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
          }

          if (isset($this->aRptFilter['tPosCodeSelect']) && !empty($this->aRptFilter['tPosCodeSelect'])) {
            $tPosSelect =  ($this->aRptFilter['bPosStaSelectAll']) ? $this->aText['tRptAll'] : $this->aRptFilter['tPosCodeSelect'];
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptPosFrom'].' : '.$tPosSelect),
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
          }


          if ((isset($this->aRptFilter['tCstCodeFrom']) && !empty($this->aRptFilter['tCstCodeFrom'])) && (isset($this->aRptFilter['tCstCodeTo']) && !empty($this->aRptFilter['tCstCodeTo']))) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptCstFrom'].' : '.$this->aRptFilter['tCstCodeFrom'].' '.$this->aText['tRptCstTo'].' : '.$this->aRptFilter['tCstCodeTo']),
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
          }



 
          if ((isset($this->aRptFilter['tRptCtyCodeFrm']) && !empty($this->aRptFilter['tRptCtyCodeFrm'])) && (isset($this->aRptFilter['tRptCtyCodeTo']) && !empty($this->aRptFilter['tRptCtyCodeTo']))) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptCstTypeTo'].' : '.$this->aRptFilter['tRptCtyCodeFrm'].' '.$this->aText['tRptCstTypeTo'].' : '.$this->aRptFilter['tRptCtyCodeTo']),
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
          }


          if ((isset($this->aRptFilter['tRptClvCodeFrm']) && !empty($this->aRptFilter['tRptClvCodeFrm'])) && (isset($this->aRptFilter['tRptClvCodeTo']) && !empty($this->aRptFilter['tRptClvCodeTo']))) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptCstLevFrom'].' : '.$this->aRptFilter['tRptClvCodeFrm'].' '.$this->aText['tRptCstGrpTo'].' : '.$this->aRptFilter['tRptClvCodeTo']),
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
          }

          if ((isset($this->aRptFilter['tRptCgpCodeFrm']) && !empty($this->aRptFilter['tRptCgpCodeFrm'])) && (isset($this->aRptFilter['tRptCgpCodeFrm']) && !empty($this->aRptFilter['tRptCgpCodeFrm']))) {
            $aCells = [
                WriterEntityFactory::createCell($this->aText['tRptCstGrpFrom'].' : '.$this->aRptFilter['tRptCgpCodeFrm']),
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
          }


          return $aMulltiRow;

    }




}
