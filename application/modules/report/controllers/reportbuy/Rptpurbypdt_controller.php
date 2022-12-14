<?php
defined('BASEPATH') or exit('No direct script access allowed');

include APPPATH . 'third_party/PHPExcel/Classes/PHPExcel.php';
include APPPATH . 'third_party/PHPExcel/Classes/PHPExcel/IOFactory.php';
include APPPATH . 'third_party/PHPExcel/Classes/PHPExcel/Writer/Excel2007.php';

date_default_timezone_set("Asia/Bangkok");

include APPPATH . 'libraries/spout-3.1.0/src/Spout/Autoloader/autoload.php';

use Box\Spout\Writer\Common\Creator\WriterEntityFactory;
use Box\Spout\Common\Entity\Row;
use Box\Spout\Common\Entity\Style\Border;
use Box\Spout\Writer\Common\Creator\Style\BorderBuilder;
use Box\Spout\Common\Entity\Style\Color;
use Box\Spout\Writer\Common\Creator\Style\StyleBuilder;
use Box\Spout\Common\Entity\Style\CellAlignment;


class Rptpurbypdt_controller extends MX_Controller
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
     * User Login Session
     * @var string
     */
    public $tSysBchCode;

    public function __construct()
    {
        $this->load->helper('report');
        $this->load->model('company/company/mCompany');
        $this->load->model('report/report/mReport');
        $this->load->model('report/reportbuy/Rptpurbypdt_model');
        // Init Report
        $this->init();

        parent::__construct();
    }

    private function init()
    {
        $this->aText = [
            // Title
              'tTitleReport' => language('report/report/report', 'tRptPurByPdtTitle'),
              'tDatePrint' => language('report/report/report', 'tRptTaxSalePosDatePrint'),
              'tTimePrint' => language('report/report/report', 'tRptTaxSalePosTimePrint'),

              'tRptTaxSalePosNoData' =>"ไม่มีข้อมูล",
              'tPdtnu'=> language('report/report/report', 'tPdtnu'),
              'tPdtCode'=> language('report/report/report', 'tPdtCode'),
              'tPdtName'=> language('report/report/report', 'tPdtName'),
              'tPgpChainName'=> language('report/report/report', 'tPgpChainName'),
              'tPtyName'=>language('report/report/report', 'tPtyName'),
              'tPdtSaleType'=> language('report/report/report', 'tPdtSaleType'),
              'tBarCode'=> language('report/report/report', 'tBarCode'),
              'tPunCode'=> language('report/report/report', 'tPunCode'),
              'tPunName'=> language('report/report/report', 'tPunName'),
              'tPdtUnitFact'=> language('report/report/report', 'tPdtUnitFact'),
              'tPdtPriceRET'=> language('report/report/report', 'tPdtPriceRET'),
              'tPdtCostInPerUnit'=> language('report/report/report', 'tPdtCostInPerUnit'),
              'tPdtCostInTotal'=> language('report/report/report', 'tPdtCostInTotal'),
              'tPgdPriceRetTotal'=> language('report/report/report', 'tPgdPriceRetTotal'),
              // Filter Heard Report
              'tRptBchFrom' => language('report/report/report', 'tRptBchFrom'),
              'tRptBchTo' => language('report/report/report', 'tRptBchTo'),
              'tRptShopFrom' => language('report/report/report', 'tRptShopFrom'),
              'tRptShopTo' => language('report/report/report', 'tRptShopTo'),
              'tRptDateFrom' => language('report/report/report', 'tRptDateFrom'),
              'tRptDateTo' => language('report/report/report', 'tRptDateTo'),

            // Address Lang
            'tRptAddrBuilding' => language('report/report/report', 'tRptAddrBuilding'),
            'tRptAddrRoad' => language('report/report/report', 'tRptAddrRoad'),
            'tRptAddrSoi' => language('report/report/report', 'tRptAddrSoi'),
            'tRptAddrSubDistrict' => language('report/report/report', 'tRptAddrSubDistrict'),
            'tRptAddrDistrict' => language('report/report/report', 'tRptAddrDistrict'),
            'tRptAddrProvince' => language('report/report/report', 'tRptAddrProvince'),
            'tRptAddrTel' => language('report/report/report', 'tRptAddrTel'),
            'tRptAddrFax' => language('report/report/report', 'tRptAddrFax'),
            'tRptAddrBranch' => language('report/report/report', 'tRptAddrBranch'),
            'tRptAddV2Desc1' => language('report/report/report', 'tRptAddV2Desc1'),
            'tRptAddV2Desc2' => language('report/report/report', 'tRptAddV2Desc2'),
            'tRptTel' => language('report/report/report', 'tRptAddrTel'),
            'tRptFaxNo' => language('report/report/report', 'tRptAddrFax'),
            // Table Label

            'tRptAdjMerChantFrom' => language('report/report/report', 'tRptAdjMerChantFrom'),
            'tRptAdjMerChantTo' => language('report/report/report', 'tRptAdjMerChantTo'),
            'tRptAdjShopFrom' => language('report/report/report', 'tRptAdjShopFrom'),
            'tRptAdjShopTo' => language('report/report/report', 'tRptAdjShopTo'),
            'tRptAdjPosFrom' => language('report/report/report', 'tRptAdjPosFrom'),
            'tRptAdjPosTo' => language('report/report/report', 'tRptAdjPosTo'),
            'tRptBranch' => language('report/report/report', 'tRptBranch'),
            'tRptTotal' => language('report/report/report', 'tRptTotal'),
            'tRPCTaxNo' => language('report/report/report', 'tRPCTaxNo'),
            'tRptConditionInReport' => language('report/report/report', 'tRptConditionInReport'),
            'tRptMerFrom' => language('report/report/report', 'tRptMerFrom'),
            'tRptMerTo' => language('report/report/report', 'tRptMerTo'),
            'tRptShopFrom' => language('report/report/report', 'tRptShopFrom'),
            'tRptShopTo' => language('report/report/report', 'tRptShopTo'),
            'tRptPosFrom' => language('report/report/report', 'tRptPosFrom'),
            'tRptPosTo' => language('report/report/report', 'tRptPosTo'),
            'tPdtCodeTo' => language('report/report/report', 'tPdtCodeTo'),
            'tPdtCodeFrom' => language('report/report/report', 'tPdtCodeFrom'),
            'tPdtGrpFrom' => language('report/report/report', 'tPdtGrpFrom'),
            'tPdtGrpTo' => language('report/report/report', 'tPdtGrpTo'),
            'tPdtTypeFrom' => language('report/report/report', 'tPdtTypeFrom'),
            'tPdtTypeTo' => language('report/report/report', 'tPdtTypeTo'),
            'tRptAdjWahFrom' => language('report/report/report', 'tRptAdjWahFrom'),
            'tRptAdjWahTo' => language('report/report/report', 'tRptAdjWahTo'),
            'tRptAll' => language('report/report/report', 'tRptAll'),
            'tRptPdtType1' => language('report/report/report', 'tRptPdtType1'),
            'tRptPdtType2' => language('report/report/report', 'tRptPdtType2'),
            'tRptPdtType3' => language('report/report/report', 'tRptPdtType3'),
            'tRptPdtType4' => language('report/report/report', 'tRptPdtType4'),
            'tRptPdtType6' => language('report/report/report', 'tRptPdtType6'),
            'tRptBrandFrom'      => language('report/report/report', 'tRptBrandFrom'),
            'tRptBrandTo'        => language('report/report/report', 'tRptBrandTo'),
            'tRptModelFrom'      => language('report/report/report', 'tRptModelFrom'),
            'tRptModelTo'        => language('report/report/report', 'tRptModelTo'),

            'tRptPdtMoving1'        => language('report/report/report', 'tRptPdtMoving1'),
            'tRptPdtMoving2'        => language('report/report/report', 'tRptPdtMoving2'),
            'tRptTitlePdtMoving'        => language('report/report/report', 'tRptTitlePdtMoving'),
            'tRptStaVat'        => language('report/report/report', 'tRptStaVat'),
            'tRptStaVa1'        => language('report/report/report', 'tRptStaVa1'),
            'tRptStaVa2'        => language('report/report/report', 'tRptStaVa2'),

            'tRptSplFrom' => language('report/report/report', 'tRptSplFrom'),
            'tRptSplTo' => language('report/report/report', 'tRptSplTo'),

            'tRptPhStaPaid1'            => language('report/report/report', 'tRptPhStaPaid1'),
            'tRptPhStaPaid2'            => language('report/report/report', 'tRptPhStaPaid2'),
            'tRptPhStaPaid3'            => language('report/report/report', 'tRptPhStaPaid3'),
            'tStaPaid'                  => language('report/report/report', 'tStapaid'),

            'tRptTitleStaApv' => language('report/report/report', 'tRptTitleStaApv'),
            'tRptPhStaApv' => language('report/report/report', 'tRptPhStaApv'),
            'tRptPhStaApv1' => language('report/report/report', 'tRptPhStaApv1'),
            'tRptPhStaApv2' => language('report/report/report', 'tRptPhStaApv2'),
            'tRptPhStaApv3' => language('report/report/report', 'tRptPhStaApv3'),

            'tRptPdtType0' => language('report/report/report', 'tRptPdtType0'),
            'tRptPdtType1' => language('report/report/report', 'tRptPdtType1'),
            'tRptPdtType2' => language('report/report/report', 'tRptPdtType2'),
            'tRptPdtType3' => language('report/report/report', 'tRptPdtType3'),
            'tRptPdtType4' => language('report/report/report', 'tRptPdtType4'),
            'tRptPdtType6' => language('report/report/report', 'tRptPdtType6'),

            'tRptSgpFrom' => language('report/report/report', 'tRptSgpFrom'),
            'tRptSgpTo' => language('report/report/report', 'tRptSgpTo'),

            'tRptStyFrom' => language('report/report/report', 'tRptStyFrom'),
            'tRptStyTo' => language('report/report/report', 'tRptStyTo'),

        ];

        $this->tSysBchCode = SYS_BCH_CODE;
        $this->tBchCodeLogin = (!empty($this->session->userdata('tSesUsrBchCom')) ? $this->session->userdata('tSesUsrBchCom') : $this->session->userdata('tSesUsrBchCom'));
        $this->nPerPage = 100;
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
            'tUserSession' => $this->tUserSessionID,
            'tCompName' => $tFullHost,
            'tRptCode' => $this->tRptCode,
            'nLangID' => $this->nLngID,

            'tTypeSelect' => !empty($this->input->post('ohdTypeDataCondition')) ? $this->input->post('ohdTypeDataCondition') : "",
            'tAgnCode'          => !empty($this->input->post('oetSpcAgncyCode')) ? $this->input->post('oetSpcAgncyCode') : '',
            
            // สาขา
            'tBchCodeFrom' => !empty($this->input->post('oetRptBchCodeFrom')) ? $this->input->post('oetRptBchCodeFrom') : "",
            'tBchNameFrom' => !empty($this->input->post('oetRptBchNameFrom')) ? $this->input->post('oetRptBchNameFrom') : "",
            'tBchCodeTo' => !empty($this->input->post('oetRptBchCodeTo')) ? $this->input->post('oetRptBchCodeTo') : "",
            'tBchNameTo' => !empty($this->input->post('oetRptBchNameTo')) ? $this->input->post('oetRptBchNameTo') : "",
            'tBchCodeSelect' => !empty($this->input->post('oetRptBchCodeSelect')) ? $this->input->post('oetRptBchCodeSelect') : "",
            'tBchNameSelect' => !empty($this->input->post('oetRptBchNameSelect')) ? $this->input->post('oetRptBchNameSelect') : "",
            'bBchStaSelectAll' => !empty($this->input->post('oetRptBchStaSelectAll')) && ($this->input->post('oetRptBchStaSelectAll') == 1) ? true : false,

            // Filter Shop (ร้านค้า)
            'tShpCodeFrom'      => (empty($this->input->post('oetRptShpCodeFrom'))) ? '' : $this->input->post('oetRptShpCodeFrom'),
            'tShpNameFrom'      => (empty($this->input->post('oetRptShpNameFrom'))) ? '' : $this->input->post('oetRptShpNameFrom'),
            'tShpCodeTo'        => (empty($this->input->post('oetRptShpCodeTo'))) ? '' : $this->input->post('oetRptShpCodeTo'),
            'tShpNameTo'        => (empty($this->input->post('oetRptShpNameTo'))) ? '' : $this->input->post('oetRptShpNameTo'),
            'tShpCodeSelect'    => !empty($this->input->post('oetRptShpCodeSelect')) ? $this->input->post('oetRptShpCodeSelect') : "",
            'tShpNameSelect'    => !empty($this->input->post('oetRptShpNameSelect')) ? $this->input->post('oetRptShpNameSelect') : "",
            'bShpStaSelectAll'  => !empty($this->input->post('oetRptShpStaSelectAll')) && ($this->input->post('oetRptShpStaSelectAll') == 1) ? true : false,

            // Merchant Filter
            'bFilterMerStaAll'  => (!empty($this->input->post('oetDSHSALFilterMerStaAll')) && ($this->input->post('oetDSHSALFilterMerStaAll') == 1)) ? true : false,
            'tFilterMerCode'    => (!empty($this->input->post('oetDSHSALFilterMerCode'))) ? $this->input->post('oetDSHSALFilterMerCode') : "",
            'tFilterMerName'    => (!empty($this->input->post('oetDSHSALFilterMerName'))) ? $this->input->post('oetDSHSALFilterMerName') : "",

            //วันที่เอกสาร
            'tRptDocDateFrom'    => (!empty($this->input->post('oetRptDocDateFrom'))) ? $this->input->post('oetRptDocDateFrom') : "",
            'tRptDocDateTo'    => (!empty($this->input->post('oetRptDocDateTo'))) ? $this->input->post('oetRptDocDateTo') : "",

            // กลุ่มสินค้า
            'tPdtGrpCodeFrom'   => !empty($this->input->post('oetRptPdtGrpCodeFrom')) ? $this->input->post('oetRptPdtGrpCodeFrom') : "",
            'tPdtGrpNameFrom'   => !empty($this->input->post('oetRptPdtGrpNameFrom')) ? $this->input->post('oetRptPdtGrpNameFrom') : "",
            'tPdtGrpCodeTo'     => !empty($this->input->post('oetRptPdtGrpCodeTo')) ? $this->input->post('oetRptPdtGrpCodeTo') : "",
            'tPdtGrpNameTo'     => !empty($this->input->post('oetRptPdtGrpNameTo')) ? $this->input->post('oetRptPdtGrpNameTo') : "",

            // ประเภทสินค้า
            'tPdtTypeCodeFrom'  => !empty($this->input->post('oetRptPdtTypeCodeFrom')) ? $this->input->post('oetRptPdtTypeCodeFrom') : "",
            'tPdtTypeNameFrom'  => !empty($this->input->post('oetRptPdtTypeNameFrom')) ? $this->input->post('oetRptPdtTypeNameFrom') : "",
            'tPdtTypeCodeTo'    => !empty($this->input->post('oetRptPdtTypeCodeTo')) ? $this->input->post('oetRptPdtTypeCodeTo') : "",
            'tPdtTypeNameTo'    => !empty($this->input->post('oetRptPdtTypeNameTo')) ? $this->input->post('oetRptPdtTypeNameTo') : "",

            // สินค้า
            'tRptPdtCodeFrom' => !empty($this->input->post('oetRptPdtCodeFrom')) ? $this->input->post('oetRptPdtCodeFrom') : "",
            'tRptPdtNameFrom' => !empty($this->input->post('oetRptPdtNameFrom')) ? $this->input->post('oetRptPdtNameFrom') : "",
            'tRptPdtCodeTo' => !empty($this->input->post('oetRptPdtCodeTo')) ? $this->input->post('oetRptPdtCodeTo') : "",
            'tRptPdtNameTo' => !empty($this->input->post('oetRptPdtNameTo')) ? $this->input->post('oetRptPdtNameTo') : "",

            // ยี่ห้อ
            'tPdtBrandCodeFrom'  => !empty($this->input->post('oetRptBrandCodeFrom')) ? $this->input->post('oetRptBrandCodeFrom') : "",
            'tPdtBrandNameFrom'  => !empty($this->input->post('oetRptBrandNameFrom')) ? $this->input->post('oetRptBrandNameFrom') : "",
            'tPdtBrandCodeTo'    => !empty($this->input->post('oetRptBrandCodeTo')) ? $this->input->post('oetRptBrandCodeTo') : "",
            'tPdtBrandNameTo'    => !empty($this->input->post('oetRptBrandNameTo')) ? $this->input->post('oetRptBrandNameTo') : "",

            // รุ่น
            'tPdtModelCodeFrom'  => !empty($this->input->post('oetRptModelCodeFrom')) ? $this->input->post('oetRptModelCodeFrom') : "",
            'tPdtModelNameFrom'  => !empty($this->input->post('oetRptModelNameFrom')) ? $this->input->post('oetRptModelNameFrom') : "",
            'tPdtModelCodeTo'    => !empty($this->input->post('oetRptModelCodeTo')) ? $this->input->post('oetRptModelCodeTo') : "",
            'tPdtModelNameTo'    => !empty($this->input->post('oetRptModelNameTo')) ? $this->input->post('oetRptModelNameTo') : "",

            //สถานะเคลื่อนไหว
            'tPdtStaActive' => !empty($this->input->post('ocmRptPdtStaActive')) ? $this->input->post('ocmRptPdtStaActive') : "",

            //วันที่เอกสาร
            'tPdtDateFrom' => !empty($this->input->post('oetRptOneDateFrom')) ? $this->input->post('oetRptOneDateFrom') : "",

            //ผู้จำหน่าย
            'tPdtSupplierCodeFrom' => !empty($this->input->post('oetRptSupplierCodeFrom')) ? $this->input->post('oetRptSupplierCodeFrom') : "",
            'tPdtSupplierNameFrom' => !empty($this->input->post('oetRptSupplierNameFrom')) ? $this->input->post('oetRptSupplierNameFrom') : "",
            'tPdtSupplierCodeTo' => !empty($this->input->post('oetRptSupplierCodeTo')) ? $this->input->post('oetRptSupplierCodeTo') : "",
            'tPdtSupplierNameTo' => !empty($this->input->post('oetRptSupplierNameTo')) ? $this->input->post('oetRptSupplierNameTo') : "",

             //กลุ่มผู้จำหน่าย
            'tPdtSgpCodeFrom' => !empty($this->input->post('oetRptSgpCodeFrom')) ? $this->input->post('oetRptSgpCodeFrom') : "",
            'tPdtSgpNameFrom' => !empty($this->input->post('oetRptSgpNameFrom')) ? $this->input->post('oetRptSgpNameFrom') : "",
            'tPdtSgpCodeTo' => !empty($this->input->post('oetRptSgpCodeTo')) ? $this->input->post('oetRptSgpCodeTo') : "",
            'tPdtSgpNameTo' => !empty($this->input->post('oetRptSgpNameTo')) ? $this->input->post('oetRptSgpNameTo') : "",

            //ประเภทผู้จำหน่าย
            'tPdtStyCodeFrom' => !empty($this->input->post('oetRptStyCodeFrom')) ? $this->input->post('oetRptStyCodeFrom') : "",
            'tPdtStyNameFrom' => !empty($this->input->post('oetRptStyNameFrom')) ? $this->input->post('oetRptStyNameFrom') : "",
            'tPdtStyCodeTo' => !empty($this->input->post('oetRptStyCodeTo')) ? $this->input->post('oetRptStyCodeTo') : "",
            'tPdtStyNameTo' => !empty($this->input->post('oetRptStyNameTo')) ? $this->input->post('oetRptStyNameTo') : "",

            //ใช้ราคาขาย
            'tPdtRptPdtType' => !empty($this->input->post('ocmRptPdtType')) ? $this->input->post('ocmRptPdtType') : "",

            //สถานะเอกสาร
            'tPdtRptPhStaApv' => !empty($this->input->post('ocmRptPhStaApv')) ? $this->input->post('ocmRptPhStaApv') : "",

            //สถานะ รับ/จ่ายเงิน
            'tPdtRptPhStaPaid' => !empty($this->input->post('ocmRptPhStaPaid')) ? $this->input->post('ocmRptPhStaPaid') : "",

            //ภาษีขาย
            'tPdtRptStaVat' => !empty($this->input->post('ocmRptStaVat')) ? $this->input->post('ocmRptStaVat') : ""

        ];

        // ดึงข้อมูลบริษัทฯ
        $aCompInfoParams = [
            'nLngID'    => $this->nLngID,
            'tBchCode'  => $this->tBchCodeLogin
        ];
        $this->aCompanyInfo = FCNaGetCompanyInfo($aCompInfoParams)['raItems'];
    }

    public function index()
    {

        if (!empty($this->tRptCode) && !empty($this->tRptExportType)) {

            // Execute Stored Procedure
            $this->Rptpurbypdt_model->FSnMExecStoreReport($this->aRptFilter);
            // Count Rows
            $aCountRowParams = [
                'tCompName' => $this->tCompName,
                'tRptCode' => $this->tRptCode,
                'tSessionID' => $this->tUserSessionID,
                'aDataFilter' => $this->aRptFilter
            ];
            $this->nRows = $this->Rptpurbypdt_model->FSnMCountRowInTemp($aCountRowParams);

            // Report Type
            switch ($this->tRptExportType) {
                case 'html':
                    $this->FSvCCallRptViewBeforePrint();
                    break;
                case 'excel':
                    // $this->FSoCChkDataReportInTableTemp();
                    // break;
                    $this->FSvCCallRptRenderExcel($this->aRptFilter);
                    break;
                case 'pdf':
                    break;
            }
        }
    }

    /**
     * Functionality: ฟังก์ชั่นดูตัวอย่างก่อนพิมพ์ (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 15/09/2020 Piya
     * LastUpdate: -
     * Return: View Report Viewersd
     * ReturnType: View
     */
    public function FSvCCallRptViewBeforePrint()
    {
        try {
            /** =========== Begin Get Data =================================== */
            // ดึงข้อมูลจากฐานข้อมูล Temp
            $aDataReportParams = [
                'nPerPage' => $this->nPerPage,
                'nPage' => $this->nPage,
                'tCompName' => $this->tCompName,
                'tRptCode' => $this->tRptCode,
                'tUsrSessionID' => $this->tUserSessionID,
                'aDataFilter' => $this->aRptFilter
            ];
            $aDataReport = $this->Rptpurbypdt_model->FSaMGetDataReport($aDataReportParams);

            /** =========== End Get Data ===================================== */
            /** =========== Begin Render View ================================ */
            // Load View Advance Table
            $aDataViewRptParams = [
                'nOptDecimalShow' => $this->nOptDecimalShow,
                'aCompanyInfo' => $this->aCompanyInfo,
                'aDataReport' => $aDataReport,
                'aDataTextRef' => $this->aText,
                'aDataFilter' => $this->aRptFilter
            ];
            $tRptView = JCNoHLoadViewAdvanceTable('report/datasources/reportbuy/', 'wRptpurbypdt', $aDataViewRptParams);

            // Data Viewer Center Report
            $aDataViewerParams = [
                'tTitleReport' => $this->aText['tTitleReport'],
                'tRptTypeExport' => $this->tRptExportType,
                'tRptCode' => $this->tRptCode,
                'tRptRoute' => $this->tRptRoute,
                'tViewRenderKool' => $tRptView,
                'aDataFilter' => $this->aRptFilter,
                'aDataReport' => [
                    'raItems' => $aDataReport['aRptData'],
                    'rnAllRow' => $aDataReport['aPagination']['nTotalRecord'],
                    'rnCurrentPage' => $aDataReport['aPagination']['nDisplayPage'],
                    'rnAllPage' => $aDataReport['aPagination']['nTotalPage'],
                    'rtCode' => '1',
                    'rtDesc' => 'success'
                ]
            ];
            $this->load->view('report/report/wReportViewer', $aDataViewerParams);
            /** =========== End Render View ================================== */
        } catch (Exception $Error) {
            echo $Error;
        }
    }

    /**
     * Functionality: Click Page Report (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 15/09/2020 Piya
     * LastUpdate: -
     * Return: View Report Viewer
     * ReturnType: View
     */
    public function FSvCCallRptViewBeforePrintClickPage()
    {

        /** =========== Begin Init Variable ================================== */
        $aDataFilter = json_decode($this->input->post('ohdRptDataFilter'), true);
        /** =========== End Init Variable ==================================== */
        $aDataWhere = array(
            'tUserSession' => $this->tUserSessionID,
            'tCompName' => $this->tCompName,
            'tUserCode' => $this->tUserLoginCode,
            'tRptCode' => $this->tRptCode,
            'nPage' => $this->nPage,
            'nRow' => $this->nPerPage,
            'nPerPage' => $this->nPerPage,
            'tUsrSessionID' => $this->tUserSessionID,
            'aDataFilter' => $this->aRptFilter
        );

        // Get Data ReportFSaMGetDataReport
        $aDataReport = $this->Rptpurbypdt_model->FSaMGetDataReport($aDataWhere, $aDataFilter);
        // print_r($aDataReport);
        // exit;

        // GetDataSumFootReport
        // $aDataSumFoot = $this->Rptpurbypdt_model->FSaMGetDataSumFootReport($aDataWhere, $aDataFilter);


        // Load View Advance Table
        $aDataViewRptParams = [
            'nOptDecimalShow' => $this->nOptDecimalShow,
            'aCompanyInfo' => $this->aCompanyInfo,
            'aDataReport' => $aDataReport,
            'aDataTextRef' => $this->aText,
            'aDataFilter' => $this->aRptFilter
        ];
        $tViewRenderKool = JCNoHLoadViewAdvanceTable('report/datasources/reportbuy/', 'wRptpurbypdt', $aDataViewRptParams);


        // Data Viewer Center Report
        $aDataView = [
            'tTitleReport' => $this->aText['tTitleReport'],
            'tRptTypeExport' => $this->tRptExportType,
            'tRptCode' => $this->tRptCode,
            'tRptRoute' => $this->tRptRoute,
            'tViewRenderKool' => $tViewRenderKool,
            'aDataFilter' => $this->aRptFilter,
            'aDataReport' => [
                'raItems' => $aDataReport['aRptData'],
                'rnAllRow' => $aDataReport['aPagination']['nTotalRecord'],
                'rnCurrentPage' => $aDataReport['aPagination']['nDisplayPage'],
                'rnAllPage' => $aDataReport['aPagination']['nTotalPage'],
                'rtCode' => '1',
                'rtDesc' => 'success',
            ]
        ];

        $this->load->view('report/report/wReportViewer', $aDataView);
    }

    /**
     * Functionality: Click Page Report (Report Viewer)
     * Parameters:  Function Parameter
     * Creator: 15/09/2020 Piya
     * LastUpdate: -
     * Return: Object Status Count Data Report
     * ReturnType: Object
     */
    public function FSoCChkDataReportInTableTemp()
    {
        try {
            $aDataCountData = [
                'tCompName' => $this->tCompName,
                'tRptCode' => $this->tRptCode,
                'tSessionID' => $this->tUserSessionID,
                'aDataFilter' => $this->aRptFilter,
            ];

            $nDataCountPage = $this->Rptpurbypdt_model->FSnMCountRowInTemp($aDataCountData);

            $aResponse = array(
                'nCountPageAll' => $nDataCountPage,
                'nStaEvent' => 1,
                'tMessage' => 'Success Count Data All'
            );
        } catch (ErrorException $Error) {
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
     * Creator: 15/09/2020 Piya
     * LastUpdate: -
     * Return: object Send Rabbit MQ Report
     * ReturnType: Object
     */
    public function FSvCCallRptExportFile()
    {

    }

       /**
     * Functionality: Render Excel Report
     * Parameters:  Function Parameter
     * Creator: 30/07/2020 Nattakit
     * LastUpdate:
     * Return: file
     * ReturnType: file
     */
    public function  FSvCCallRptRenderExcel()
    {
        $tFileName = $this->aText['tTitleReport'] . '_' . date('YmdHis') . '.xlsx';
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
                WriterEntityFactory::createCell('รหัสสินค้า'),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell('ชื่อสินค้า'),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell('จำนวน'),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell('หน่วย'),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell('มูลค่า'),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell('ส่วนลด'),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell('ภาษี'),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell('รวม')
            ];


        /** add a row at a time */
        $singleRow = WriterEntityFactory::createRow($aCells, $oStyleColums);
        $oWriter->addRow($singleRow);

        //  ===========================================================================================



        $aDataReportParams = [
            'nPerPage'      => 999999999999,
            'nPage'         => $this->nPage,
            'tCompName'     => $this->tCompName,
            'tRptCode'      => $this->tRptCode,
            'tUsrSessionID' => $this->tUserSessionID,
            'aDataFilter'   => $this->aRptFilter
        ];

        //Get Data
        $aDataReport = $this->Rptpurbypdt_model->FSaMGetDataReport($aDataReportParams);

        /** Create a style with the StyleBuilder */
        $oStyle = (new StyleBuilder())
            ->setCellAlignment(CellAlignment::RIGHT)
            ->build();

            $nFCXpdValueSum = 0;
            $nFCXpdDisSum = 0;
            $nFCXpdVatSum = 0;
            $nFCXpdNetAmtSum = 0;
        if (isset($aDataReport['aRptData']) && !empty($aDataReport['aRptData'])) {
            foreach ($aDataReport['aRptData'] as $nKey => $aValue) {
                $values = [
                    WriterEntityFactory::createCell($aValue['FTPdtCode']),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell($aValue['FTPdtName']),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue['FCXpdQty'])),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell($aValue['FTPunName']),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue["FCXpdValue"])),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue["FCXpdDis"])),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue["FCXpdVat"])),
                    WriterEntityFactory::createCell(NULL),
                    WriterEntityFactory::createCell(FCNnGetNumeric($aValue["FCXpdNetAmt"]))
                ];
                $aRow = WriterEntityFactory::createRow($values);
                $oWriter->addRow($aRow);
            }

            $values = [
                WriterEntityFactory::createCell("รวม"),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(FCNnGetNumeric($nFCXpdValueSum)),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(FCNnGetNumeric($nFCXpdDisSum)),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(FCNnGetNumeric($nFCXpdVatSum)),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(FCNnGetNumeric($nFCXpdNetAmtSum))
            ];
            $aRow = WriterEntityFactory::createRow($values,$oStyleColums);
            $oWriter->addRow($aRow);
        }

        $aMulltiRow = $this->FSoCCallRptRenderFooterExcel(); //เรียกฟังชั่นสร้างส่วนท้ายรายงาน
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
    public function FSoCCallRptRenderHedaerExcel()
    {
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
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell(NULL),
            WriterEntityFactory::createCell($this->aText['tTitleReport']),
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
            WriterEntityFactory::createCell($this->aText['tRptAddrBranch'] . ' ' . $tFTBchName),
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


        if ((isset($this->aRptFilter['tRptDocDateFrom']) && !empty($this->aRptFilter['tRptDocDateFrom'])) && (isset($this->aRptFilter['tRptDocDateTo']) && !empty($this->aRptFilter['tRptDocDateTo']))) {
            $aCells = [
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell(NULL),
                WriterEntityFactory::createCell($this->aText['tRptDateFrom'] . ' ' . date('d/m/Y', strtotime($this->aRptFilter['tRptDocDateFrom'])) . ' ' . $this->aText['tRptDateTo'] . ' ' . date('d/m/Y', strtotime($this->aRptFilter['tRptDocDateTo']))),
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
            WriterEntityFactory::createCell($this->aText['tDatePrint'] . ' ' . date('d/m/Y') . ' ' . $this->aText['tTimePrint'] . ' ' . date('H:i:s')),
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
    public function FSoCCallRptRenderFooterExcel()
    {

        $oStyleFilter = (new StyleBuilder())
            ->setFontBold()
            ->build();

            $aCells = [
                WriterEntityFactory::createCell(NULL),
            ];
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells, $oStyleFilter);
    
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
            $aMulltiRow[] = WriterEntityFactory::createRow($aCells, $oStyleFilter);
    
            // สาขา แบบเลือก
            if (isset($this->aRptFilter['tBchCodeSelect']) && !empty($this->aRptFilter['tBchCodeSelect'])) {
                $tBchSelect =  ($this->aRptFilter['bBchStaSelectAll']) ? $this->aText['tRptAll'] : $this->aRptFilter['tBchNameSelect'];
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptBchFrom'] . ' : ' . $tBchSelect),
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
    
            // สถานะเอกสาร
            if (isset($this->aRptFilter['tPdtRptPhStaApv'])) {
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptTitleStaApv'] . ' : ' . $this->aText['tRptPhStaApv'.$this->aRptFilter['tPdtRptPhStaApv']]),
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
    
            // สถานะเคลื่อนไหว
            if ((isset($this->aRptFilter['tPdtStaActive']) && !empty($this->aRptFilter['tPdtStaActive'])) && (isset($this->aRptFilter['tPdtStaActive']) && !empty($this->aRptFilter['tPdtStaActive']))) {
                $aPdtStaActive = array(
                    '1' => $this->aText['tRptPdtMoving1'],
                    '2' => $this->aText['tRptPdtMoving2']
                );
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptTitlePdtMoving'] . ' : ' . $aPdtStaActive[$this->aRptFilter['tPdtStaActive']]),
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
            
            // ฟิวเตอร์ข้อมูล ใช้ราคาขาย
            if ( isset($this->aRptFilter['tPdtRptPdtType'])  ) {
                if( $this->aRptFilter['tPdtRptPdtType'] == "" ){ $this->aRptFilter['tPdtRptPdtType'] = "0"; }
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tPdtSaleType'] . ' : ' . $this->aText['tRptPdtType'.$this->aRptFilter['tPdtRptPdtType']] ),
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
            
            // ฟิวเตอร์ข้อมูล ภาษี
            if ((isset($this->aRptFilter['tPdtRptStaVat']) && !empty($this->aRptFilter['tPdtRptStaVat'])) && (isset($this->aRptFilter['tPdtRptStaVat']) && !empty($this->aRptFilter['tPdtRptStaVat']))) {
              $aPdtRptStaVat = array(
               '1' => $this->aText['tRptStaVa1'],
               '2' => $this->aText['tRptStaVa2']
             );
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptStaVat'] . ' : ' . $aPdtRptStaVat[$this->aRptFilter['tPdtRptStaVat']] ),
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

            // ฟิวเตอร์ข้อมูล สถานะ รับ/จ่ายเงิน
            if ((isset($this->aRptFilter['tPdtRptPhStaPaid']) && !empty($this->aRptFilter['tPdtRptPhStaPaid'])) ) {
                $tStaPaid = '';
                if ($this->aRptFilter['tPdtRptPhStaPaid'] == 1) {
                    $tStaPaid = $this->aText['tRptPhStaPaid1'];
                }elseif ($this->aRptFilter['tPdtRptPhStaPaid'] == 2) {
                    $tStaPaid = $this->aText['tRptPhStaPaid2'];
                }elseif ($this->aRptFilter['tPdtRptPhStaPaid'] == 3) {
                    $tStaPaid = $this->aText['tRptPhStaPaid3'];
                }
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tStaPaid'] . ' : ' . $tStaPaid),
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
    
            // ฟิวเตอร์ข้อมูล สินค้า =========================================== -->
            if ((isset($this->aRptFilter['tRptPdtCodeFrom']) && !empty($this->aRptFilter['tRptPdtCodeFrom'])) && (isset($this->aRptFilter['tRptPdtCodeTo']) && !empty($this->aRptFilter['tRptPdtCodeTo']))) {
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tPdtCodeFrom'] . ' : ' . $this->aRptFilter['tRptPdtNameFrom'] . '     ' . $this->aText['tPdtCodeTo'] . ' : ' . $this->aRptFilter['tRptPdtNameTo']),
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
    
            // ฟิวเตอร์ข้อมูล กลุ่มสินค้า =========================================== -->
            if ((isset($this->aRptFilter['tPdtGrpCodeFrom']) && !empty($this->aRptFilter['tPdtGrpCodeFrom'])) && (isset($this->aRptFilter['tPdtGrpCodeTo']) && !empty($this->aRptFilter['tPdtGrpCodeTo']))) {
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tPdtGrpFrom'] . ' : ' . $this->aRptFilter['tPdtGrpNameFrom'] . '     ' . $this->aText['tPdtGrpTo'] . ' : ' . $this->aRptFilter['tPdtGrpNameTo']),
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
    
            // ฟิวเตอร์ข้อมูล ประเภทสินค้า =========================================== -->
            if ((isset($this->aRptFilter['tPdtTypeCodeFrom']) && !empty($this->aRptFilter['tPdtTypeCodeFrom'])) && (isset($this->aRptFilter['tPdtTypeCodeTo']) && !empty($this->aRptFilter['tPdtTypeCodeTo']))) {
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tPdtTypeFrom'] . ' : ' . $this->aRptFilter['tPdtTypeNameFrom'] . '     ' . $this->aText['tPdtTypeTo'] . ' : ' . $this->aRptFilter['tPdtTypeNameTo']),
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
    
            // ฟิวเตอร์ข้อมูล ยี่ห้อ =========================================== -->
            if ((isset($this->aRptFilter['tPdtBrandCodeFrom']) && !empty($this->aRptFilter['tPdtBrandCodeFrom'])) && (isset($this->aRptFilter['tPdtBrandCodeTo']) && !empty($this->aRptFilter['tPdtBrandCodeTo']))) {
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptBrandFrom'] . ' : ' . $this->aRptFilter['tPdtBrandNameFrom'] . '     ' . $this->aText['tRptBrandTo'] . ' : ' . $this->aRptFilter['tPdtBrandNameTo']),
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
    
            // ฟิวเตอร์ข้อมูล รุ่น =========================================== -->
            if ((isset($this->aRptFilter['tPdtModelCodeFrom']) && !empty($this->aRptFilter['tPdtModelCodeFrom'])) && (isset($this->aRptFilter['tPdtModelCodeTo']) && !empty($this->aRptFilter['tPdtModelCodeTo']))) {
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptModelFrom'] . ' : ' . $this->aRptFilter['tPdtModelNameFrom'] . '     ' . $this->aText['tRptModelTo'] . ' : ' . $this->aRptFilter['tPdtModelNameTo']),
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
    
            // ผู้จำหน่าย แบบช่วง
            if (!empty($this->aRptFilter['tPdtSupplierCodeFrom']) && !empty($this->aRptFilter['tPdtSupplierCodeTo'])) {
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptSplFrom'] . ' : ' . $this->aRptFilter['tPdtSupplierNameFrom'] . '     ' . $this->aText['tRptSplTo'] . ' : ' . $this->aRptFilter['tPdtSupplierNameTo']),
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
    
            // ฟิวเตอร์ข้อมูล กลุ่มผู้จำหน่าย
            if ((isset($this->aRptFilter['tPdtSgpCodeFrom']) && !empty($this->aRptFilter['tPdtSgpCodeFrom'])) && (isset($this->aRptFilter['tPdtSgpCodeTo']) && !empty($this->aRptFilter['tPdtSgpCodeTo']))) {
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptSgpFrom'] . ' : ' . $this->aRptFilter['tPdtSgpNameFrom'] . '     ' . $this->aText['tRptSgpTo'] . ' : ' . $this->aRptFilter['tPdtSgpNameTo']),
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
    
            // ฟิวเตอร์ข้อมูล ประเภทผู้จำหน่าย
            if ((isset($this->aRptFilter['tPdtStyCodeFrom']) && !empty($this->aRptFilter['tPdtStyCodeFrom'])) && (isset($this->aRptFilter['tPdtStyCodeTo']) && !empty($this->aRptFilter['tPdtStyCodeTo']))) {
                $aCells = [
                    WriterEntityFactory::createCell($this->aText['tRptStyFrom'] . ' : ' . $this->aRptFilter['tPdtStyNameFrom'] . '     ' . $this->aText['tRptStyTo'] . ' : ' . $this->aRptFilter['tPdtStyNameTo']),
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
