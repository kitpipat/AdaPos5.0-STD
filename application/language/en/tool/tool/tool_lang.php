<?php
if (! defined ( 'BASEPATH' ))
    exit ( 'No direct script access allowed' );
    
//TH
//Nav Menu
$lang['tToolTitle']      = "Tool";

$lang['tToolTabStaPrcStk']   = "Check sales bill inventory processing status";

$lang['tToolBranchCode']   = "Branch Code";
$lang['tToolBranchName']   = "Branch Name";
$lang['tToolPosCode']   = "POS";
$lang['tToolDocNo']   = "Document No";
$lang['tToolDocDate']   = "Date";
$lang['tToolWahCode']   = "Wahouse Code";
$lang['tToolStaPrcStk']   = "Process Stock Status";

$lang['tToolStaPrcStk0']   = "All";
$lang['tToolStaPrcStk1']   = "Process";
$lang['tToolStaPrcStk2']   = "Wait Process";

$lang['tToolDataNotFound']   = "Not Found";


$lang['tToolMassageSuccess']   = "Repair information has been submitted to the server.";
$lang['tToolMassageError']   = "Failed to send repair data to server.";

$lang['tSTLToolsConfirmRepair']   = "You are sure to process the inventory according to the selected lines.";


$lang['tToolStatDate']   = "Date From";
$lang['tToolToDate']   = "To Date";

$lang['tToolAllBillNotPrcStock']   = "Do not filter by date range";


$lang['tRPNTitle']   = "Check bill running number";
$lang['tRPNBillType']   = "Bill type";
$lang['tRPNBillType0']   = "All";
$lang['tRPNBillType1']   = "Sale";
$lang['tRPNBillType2']   = "Return";

$lang['tSMTSALModalBranch']   = "Branch";
$lang['tSMTSALModalPos']   = "Pos";

$lang['tSTLToolsPreView']   = "Preview";
$lang['tSTLToolsConfirm']   = "Confirm";

$lang['tSMTSALModalBill']   = "Document No From";
$lang['tSMTSALModalBillStratBill']   = "Number first";

$lang['tSMTSALModalBillSal']   = "Sales document information";

$lang['tSMTSALModalBillOld']   = "Original Bill No.";
$lang['tSMTSALModalBillNews']   = "New Bill No.";
$lang['tSMTSALModalBillStaRun']   = "Document Status";
$lang['tSMTSALModalBillStaRun1']   = "Changeable";
$lang['tSMTSALModalBillStaRun2']   = "The running number is duplicated in the system.";

$lang['tSMTSALDressCrip1']   = "This information cannot be confirmed because the new document number is already duplicated in the system. To";
$lang['tSMTSALRefUUID']   = "Ref UUID";

$lang['tSTLToolsConfirmRepairRunning']   = "Are you sure to change the document number in the filtered order?";



$lang['tLogGenRnn']   = "History of changes to bill numbers";



$lang['tlogDRGTitle']      = "History of Bill's No.";
$lang['tlogDRGUUIDFrm']      = "UUID From";
$lang['tlogDRGUUIDTo']      = "To UUID";
$lang['tlogDRGDocNo']      = "Original Bill No.";
$lang['tlogDRGRefUUID']      = "Ref UUID";
$lang['tlogDRGStaServer']      = "Server Status";
$lang['tlogDRGStaClient']      = "Client Status";
$lang['tlogDRGStaProcess1']      = "Processed";
$lang['tlogDRGStaProcess2']      = "Waiting to be processed";




$lang['augAutoTitle']      = "อัพเกรดหน้าร้าน";

$lang['tlogUPGTitle']      = "อัพเกรดหน้าร้าน";
$lang['tlogUPGUUIDFrm']      = "รอบการอัพเกรด";
$lang['tlogUPGUUIDTo']      = "ถึง เลขที่อ้างอิง";
$lang['tlogUPGDocNo']      = "เลขที่เอกสารเดิม";
$lang['tlogUPGRefUUID']      = "รอบการอัพเกรด";
$lang['tlogUPGStaServer']      = "สถานะเซิฟเวอร์";
$lang['tlogUPGStaClient']      = "สถานะเครื่องจุดขาย";


$lang['tlogUPGTab1']      = "ข้อมูลสถานะการอัพเกรดตามจุดขาย";
$lang['tlogUPGTab2']      = "ข้อมูลรอบการแจ้งอัพเกรด";


$lang['tSMTSALModalAgency']   = "ตัวแทนขาย/แฟรนไชส์";
$lang['tSMTSALStatus']   = "สถานะ";
$lang['tlogUPGStaProcess0']      = "รอดาวน์โหลด";
$lang['tlogUPGStaProcess1']      = "ดาวโหลดสำเร็จ";
$lang['tlogUPGStaProcess2']      = "อัพเกรดสำเร็จ";
$lang['tlogUPGStaProcess3']      = "อัพเกรดไม่สำเร็จ";

$lang['tlogUPGTdSeq']      = "ลำดับ";
$lang['tlogUPGTdAgn']      = "ตัวแทนขาย/แฟรนไชส์";
$lang['tlogUPGTdBch']      = "สาขา";
$lang['tlogUPGTdPos']      = "จุดขาย";
$lang['tlogUPGTdLstRelease']      = "Release ล่าสุด";
$lang['tlogUPGTdLstReleaseName']      = "ชื่อรอบการอัพเกรดล่าสุดล่าสุด";
$lang['tlogUPGTdLstStatus']      = "สถานะล่าสุด";
$lang['tlogUPGTdActRelease']      = "Release ที่ใช้งาน";
$lang['tlogUPGTdActReleaseName']      = "ชื่อรอบการอัพเกรดที่ใช้งาน";
$lang['tlogUPGTdLstUpd']      = "วันที่ปรับปรุง";


$lang['tDPYTitle']      = "รอบการแจ้งอัพเกรด";
$lang['tDPYTitleAdd']      = "เพิ่ม";
$lang['tDPYTitleEdit']      = "แก้ไข";
$lang['tDPYTitleDetail']      = "รายละเอียด";

$lang['tDPYFillTextSearch']      = "กรุณาระบุคำค้นหา";


// Form Advance Search List
$lang['tDPYAdvSearchFrom']          = "จาก";
$lang['tDPYAdvSearchTo']            = "ถึง";
$lang['tDPYAdvSearchBranch']        = "จากสาขา";
$lang['tDPYAdvSearchBranchTo']      = "ถึงสาขา";
$lang['tDPYAdvSearchDocDate']       = "จากวันที่เอกสาร";
$lang['tDPYAdvSearchDocDateTo']     = "ถึงวันที่เอกสาร";
$lang['tDPYAdvSearchLabelStaDoc']   = "สถานะเอกสาร";
$lang['tDPYAdvSearchStaApprove']    = "สถานะอนุมัติ";
$lang['tDPYAdvSearchStaPrcStk']     = "สถานะประมวลผล";

// Status Document
$lang['tDPYStaApv']              = "รอการอนุมัติ";
$lang['tDPYStaApv1']             = "อนุมัติแล้ว";
$lang['tDPYStaApv2']             = "รอการอนุมัติ";
$lang['tDPYStaDoc']              = "-";
$lang['tDPYStaPreDep']             = "-";
$lang['tDPYStaPreDep1']             = "ยืนยันแล้ว";
$lang['tDPYStaPreDep2']             = "รอยืนยัน";
$lang['tDPYStaPreDep3']             = "ยกเลิก";
$lang['tDPYStaDep']             = "-";
$lang['tDPYStaDep1']             = "ยืนยันแล้ว";
$lang['tDPYStaDep2']             = "รอยืนยัน";
$lang['tDPYStaDep3']             = "ยกเลิก";
$lang['tDPYStaPrcStk']           = "รอการประมวลผล";
$lang['tDPYStaPrcStk0']          = "รอการประมวลผล";
$lang['tDPYStaPrcStk1']          = "ประมวลผลแล้ว";
$lang['tDPYStaPrcStk2']          = "รอการประมวลผล";

// Name Head Data Table List
$lang['tDPYTBChoose']       = "เลือก";
$lang['tDPYTBBchCreate']    = "สาขาที่สร้าง";
$lang['tDPYTBDocNo']        = "เลขที่เอกสาร";
$lang['tDPYTBDocDate']      = "วันที่เอกสาร";
$lang['tDPYTBBch']          = "สาขา";
$lang['tDPYTBShp']          = "ร้านค้า";
$lang['tDPYTBSpl']          = "ผู้จำหน่าย";
$lang['tDPYTBGrand']        = "ยอดสั่งซื้อ";
$lang['tDPYTBVatRate']      = "อัตราภาษี";
$lang['tDPYTBVat']          = "ยอดรวมภาษี";
$lang['tDPYTBStaDoc']       = "สถานะเอกสาร";
$lang['tDPYTBStaApv']       = "สถานะอนุมัติ";
$lang['tDPYTBStaPrc']       = "สถานะประมวลผล";
$lang['tDPYTBStaPrc1']      = "ประมวลผล";
$lang['tDPYTBStaPrc2']      = "กำลังประมวลผล";
$lang['tDPYTBStaPrc3']      = "รอการประมวลผล";
$lang['tDPYTBCreateBy']     = "ผู้สร้าง";
$lang['tDPYTBApvBy']        = "ผู้อนุมัติ";
$lang['tDPYTBDelete']       = "ลบ";
$lang['tDPYTBEdit']         = "แก้ไข";
$lang['tDPYTBQtyAllDiff']   = "ยอดที่ปรับปรุง";



// Label Form Adjust Stock
$lang['tDPYApproved']           = "อนุมัติแล้ว";
$lang['tDPYAutoGenCode']        = "สร้างเลขที่อัตโนมัติ";
$lang['tDPYFillTextSearch']     = "กรอกคำค้นหา";
$lang['tDPYDocNo']              = "เลขที่เอกสาร";
$lang['tDPYDocDate']            = "วันที่เอกสาร";
$lang['tDPYDocTime']            = "เวลาเอกสาร";
$lang['tDPYCreateBy']           = "ผู้สร้างเอกสาร";
$lang['tDPYApvBy']              = "ผู้อนุมัติ";
$lang['tDPYPreApvBy']              = "ผู้อนุมัติเตรียมอัพเกรด";
$lang['tDPYBranch']             = "สาขา";
$lang['tDPYMerchant']           = "กลุ่มร้านค้า";
$lang['tDPYMerPdtGrp']          = "กลุ่มธุรกิจ Merchant";
$lang['tDPYShop']               = "ร้านค้า";
$lang['tDPYPos']                = "เครื่องจุดขาย";
$lang['tDPYWarehouse']          = "คลังสินค้า";
$lang['tDPYReason']             = "เหตุผล";
$lang['tDPYRemark']             = "หมายเหตุ";
$lang['tDPYSearchPdt']          = "ค้นหาสินค้า";
$lang['tDPYScanPdt']            = "แสกนสินค้า";
$lang['tDPYScanPdtNotFound']    = "ไม่พบข้อมูลรายการสินค้าที่แสกน";
$lang['tDPYApvSeqChk1']         = "ตรวจนับครั้งที่ 1";
$lang['tDPYApvSeqChk2']         = "ตรวจนับครั้งที่ 2";
$lang['tDPYApvSeqChk3']         = "กำหนดเอง";
$lang['tDPYApvSeqChk4']         = "ตรวจนับทั้งหมด";
$lang['tDPYStaDocAct']          = "เคลื่อนไหว";

$lang['tDPYClearData']          = "ล้างข้อมูล";
$lang['tDPYSearchProduct']      = "ค้นหารายการสินค้า";

$lang['tDPYConditionDoc']       = "เงื่อนไขเอกสาร";
$lang['tDPYDocument']           = "เอกสาร";



$lang['tDPYSpcNo']           = "ลำดับ";
$lang['tDPYSpcType']         = "ประเภท";
$lang['tDPYSpcAgnName']      = "ตัวแทนขาย";
$lang['tDPYSpcBchName']      = "สาขา";
$lang['tDPYSpcPosName']      = "จุดขาย";
$lang['tDPYSpcDel']          = "ลบ";
$lang['tDPYSpcNotFound']     = "ไม่พบข้อมูล";


$lang['tDPYDTTitle']         = "รายการอัพเกรด";

$lang['tDPYDTApp']         = "โปรแกรม";
$lang['tDPYDTVer']         = "เวอร์ชั่น";
$lang['tDPYDTPath']         = "ที่อยู่ไฟล์";
$lang['tDPYConditionDocPos']  = "เงื่อนไขการอัพเกรด";
$lang['tDPYReleaseName']      = "ชื่อรอบการอัพเกรด";
$lang['tDPYZipUrl']           = "ลิงก์ดาวน์โหลดไฟล์อัพเกรด";
$lang['tDPYJsonUrl']          = "ลิงก์ดาวน์โหลดไฟล์ Json";
$lang['tDPYRrmk']             = "หมายเหตุ";
$lang['tDPYDescription']      = "ถ้ามีไฟล์ Readme.txt ให้วางไว้ใน Zip";


$lang['tDPYStaPreDepTitle']  = "สถานะเตรียมอัพเกรด";
$lang['tDPYStaDepTitle']  = "สถานะการอัพเกรด";
$lang['tDPYStaDoc1']             = "สมบูรณ์";
$lang['tDPYStaDoc2']             = "ไม่สมบูรณ์";

$lang['tDPYStaType1']            = "ร่วมรายการ";
$lang['tDPYStaType2']            = "ยกเว้น";


$lang['tDPYCanDoc']      = "ยกเลิกเอกสาร";

$lang['tDPYDocRemoveCantEdit']      = "เอกสารใบนี้ทำการประมวลผล หรือยกเลิกแล้ว ไม่สามารถแก้ไขได้";

$lang['tDPYCancel']      = "คุณต้องการที่จะยกเลิกเอกสารนี้หรือไม่";

$lang['tCMNApproveDep']     = "อัพเกรด";

$lang['tCMNApproveDepTitle']    = "แจ้งอัพเกรด";
$lang['tCMNApproveDepDesc']     = "ยืนยันอัพเกรดหน้าร้านตามรายการ";

$lang['tDPYStaForce']     = "บังคับอัพเกรด";

$lang['tDPYActDate']     = "วันที่มีผล";
$lang['tDPYActTime']     = "เวลาที่มีผล";

$lang['tUPGUUIDCoppy']     = "สำเนา";

$lang['tUPGUUIDCoppyTitle']     = "ทำสำเนา";
