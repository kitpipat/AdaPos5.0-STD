<?php
if (! defined ( 'BASEPATH' ))
    exit ( 'No direct script access allowed' );
    
//TH
//Nav Menu
$lang['tToolTitle']      = "ซ่อมบิลขายไม่ตัดสต็อก";

$lang['tToolTabStaPrcStk']   = "ตรวจสอบสถานะประมวลผลสต็อกบิลขาย";

$lang['tToolBranchCode']   = "รหัสสาขา";
$lang['tToolBranchName']   = "สาขา";
$lang['tToolPosCode']   = "เครื่องจุดขาย";
$lang['tToolDocNo']   = "เลขที่เอกสาร";
$lang['tToolDocDate']   = "วันที่เอกสาร";
$lang['tToolWahCode']   = "รหัสคลังสินค้า";
$lang['tToolStaPrcStk']   = "สถานะประมวลผลสต็อก";

$lang['tToolStaPrcStk0']   = "ทั้งหมด";
$lang['tToolStaPrcStk1']   = "ประมวลผลแล้ว";
$lang['tToolStaPrcStk2']   = "ยังไม่ประมวลผล";

$lang['tToolDataNotFound']   = "ไม่พบข้อมูล";


$lang['tToolMassageSuccess']   = "ส่งข้อมูลซ่อมไปยังเซิฟเวอร์เรียบร้อย";
$lang['tToolMassageError']   = "ส่งข้อมูลซ่อมไปยังเซิฟเวอร์ไม่สำเร็จ";

$lang['tSTLToolsConfirmRepair']   = "คุณแน่ใจที่จะทำการประมวลผลสต็อกตามรายการที่เลือกไว้";


$lang['tToolStatDate']   = "จากข้อมูลวันที่";
$lang['tToolToDate']   = "ถึงข้อมูลวันที่";

$lang['tToolAllBillNotPrcStock']   = "ไม่กรองตามช่วงวันที่";


$lang['tRPNTitle']   = "ตรวจสอบเลขที่รันนิ่งบิล";
$lang['tRPNBillType']   = "ประเภทบิล";
$lang['tRPNBillType0']   = "ทั้งหมด";
$lang['tRPNBillType1']   = "ขาย";
$lang['tRPNBillType2']   = "คืน";

$lang['tSMTSALModalBranch']   = "สาขา";
$lang['tSMTSALModalPos']   = "จุดขาย";

$lang['tSTLToolsPreView']   = "แสดงข้อมูล";
$lang['tSTLToolsConfirm']   = "ยืนยัน";

$lang['tSMTSALModalBill']   = "เลขที่เอกสารเริ่มต้น";
$lang['tSMTSALModalBillStratBill']   = "เลขที่บิลตั้งต้นใหม่";

$lang['tSMTSALModalBillSal']   = "ข้อมูลเอกสารการขาย";

$lang['tSMTSALModalBillOld']   = "เลขที่บิลเดิม";
$lang['tSMTSALModalBillNews']   = "เลขที่บิลใหม่";
$lang['tSMTSALModalBillStaRun']   = "สถานะเอกสาร";
$lang['tSMTSALModalBillStaRun1']   = "สามารถเปลี่ยนได้";
$lang['tSMTSALModalBillStaRun2']   = "ไม่สามารถเปลี่ยนได้";

$lang['tSMTSALDressCrip1']   = "ไม่สามารถยืนยันข้อมูลนี้ได้เนื่องจากเลขที่เอกสารใหม่ซ้ำกับในระบบอยู่แล้วหรือยังไม่ได้มีการปิดรอบ ที่";
$lang['tSMTSALRefUUID']   = "เลขที่อ้างอิง";

$lang['tSTLToolsConfirmRepairRunning']   = "คุณแน่ใจที่จะเปลี่ยนแปลงเลขที่เอกสารตามลำดับที่กรอง";



$lang['tLogGenRnn']   = "ประวัติเปลี่ยนแปลงเลขที่บิล";



$lang['tlogDRGTitle']      = "ซ่อมเลขที่บิล";
$lang['tlogDRGUUIDFrm']      = "จาก เลขที่อ้างอิง";
$lang['tlogDRGUUIDTo']      = "ถึง เลขที่อ้างอิง";
$lang['tlogDRGDocNo']      = "เลขที่เอกสารเดิม";
$lang['tlogDRGRefUUID']      = "เลขที่อ้างอิง";
$lang['tlogDRGStaServer']      = "สถานะเซิฟเวอร์";
$lang['tlogDRGStaClient']      = "สถานะเครื่องจุดขาย";
$lang['tlogDRGStaProcess1']      = "ประมวลผลแล้ว";
$lang['tlogDRGStaProcess2']      = "รอประมวลผล";

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
$lang['tlogUPGTdLstRelease']      = "รอบอัพเกรดล่าสุด";
$lang['tlogUPGTdLstReleaseName']      = "ชื่อรอบอัพเกรดล่าสุดล่าสุด";
$lang['tlogUPGTdLstStatus']      = "สถานะล่าสุด";
$lang['tlogUPGTdActRelease']      = "รอบอัพเกรดที่ใช้งาน";
$lang['tlogUPGTdActReleaseName']      = "ชื่อรอบอัพเกรดที่ใช้งาน";
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
$lang['tDPYTBApvBy']        = "ผู้อัพเกรด";
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
$lang['tDPYApvBy']              = "ผู้อัพเกรด";
$lang['tDPYPreApvBy']              = "ผู้เตรียมอัพเกรด";
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