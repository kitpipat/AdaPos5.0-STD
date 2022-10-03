<?php
// Tool
$route['tool']                        = 'tool/tool/Adatools_controller/index';
$route['toolMainPage']                = 'tool/tool/Adatools_controller/FSvCATLSALMainPage';
$route['toolCallModalFilter']         = 'tool/tool/Adatools_controller/FSvCATLSALCallModalFilter';
$route['toolConfirmFilter']           = 'tool/tool/Adatools_controller/FSvCATLSALConfirmFilter';
$route['toolCallSaleDataTable']       = 'tool/tool/Adatools_controller/FSvCATLCallSaleDataTable';
$route['toolEventRepairStk']          = 'tool/tool/Adatools_controller/FSvCATLCallMqForRepairStk';



$route['toolRePairRunningBillMainPage']   = 'tool/tool/Repairrunningbill_controller/FSvCRPNMainPage';
$route['toolRePairRunningBillDataTable']  = 'tool/tool/Repairrunningbill_controller/FSvCRPNDataTable';
$route['toolRePairRunningBillCallMQPrc']  = 'tool/tool/Repairrunningbill_controller/FSvCRPNCallMQPrc';


$route['logDRG']                         = 'tool/log/Docregen_controller/index';
$route['logDRGMainPage']                 = 'tool/log/Docregen_controller/FSvCDRGMainPage';
$route['logDRGDataTable']                = 'tool/log/Docregen_controller/FSvCDRGDataTable';



$route['augAuto']                         = 'tool/upgrade/Upgrade_controller/index';
$route['augAutoMainPage']                 = 'tool/upgrade/Upgrade_controller/FSvCUPGMainPage';
$route['augAutoDataTable']                = 'tool/upgrade/Upgrade_controller/FSvCUPGDataTable';

$route['augDPYMainPage']                 = 'tool/upgrade/Deploy_controller/FSvCDPYMainPage';
$route['augDPYDataTable']                = 'tool/upgrade/Deploy_controller/FSvCDPYDataTable';
$route['augDPYPageAdd']                  = 'tool/upgrade/Deploy_controller/FSvCDPYPageAdd';
$route['augDPYEventAdd']                 = 'tool/upgrade/Deploy_controller/FSvCDPYEventAdd';
$route['augDPYPageEdit']                 = 'tool/upgrade/Deploy_controller/FSvCDPYPageEdit';
$route['augDPYEventEdit']                = 'tool/upgrade/Deploy_controller/FSvCDPYEventEdit';
$route['augDPYEventDelete']              = 'tool/upgrade/Deploy_controller/FSvCDPYEventDelete';
$route['augDPYApprove']                  = 'tool/upgrade/Deploy_controller/FSvCDPYApprove';
$route['augDPYApproveDep']               = 'tool/upgrade/Deploy_controller/FSvCDPYApproveDep';
$route['augDPYCancel']                   = 'tool/upgrade/Deploy_controller/FSvCDPYCancel';
$route['augDPYCoppyDoc']                 = 'tool/upgrade/Deploy_controller/FSvCDPYCoppyDoc';

//ตั้งค่าใบเสร็จ ยกมาจาก KPC By:IcePHP 3/10/2022
$route['toolConfigSlip']                        = 'tool/configslip/Configslip_controller/index';
$route['toolConfigSlipDataList']                = 'tool/configslip/Configslip_controller/FSvCCFSPageDataTable';
$route['toolConfigSlipEventSave']               = 'tool/configslip/Configslip_controller/FSaCCFSEventSave';
$route['toolConfigSlipPageDemo']                = 'tool/configslip/Configslip_controller/FSvCCFSPageDemo';
$route['toolConfigSlipEventResetDefault']       = 'tool/configslip/Configslip_controller/FSaCCFSEventResetDefault';