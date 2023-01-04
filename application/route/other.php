<?php
// Reason (เหตุผล)
$route['reason/(:any)/(:any)']     = 'other/reason/cReason/index/$1/$2';
$route['reasonList']               = 'other/reason/cReason/FSvRSNListPage';
$route['reasonDataTable']          = 'other/reason/cReason/FSvRSNDataList';
$route['reasonPageAdd']            = 'other/reason/cReason/FSvRSNAddPage';
$route['reasonEventAdd']           = 'other/reason/cReason/FSaRSNAddEvent';
$route['reasonPageEdit']           = 'other/reason/cReason/FSvRSNEditPage';
$route['reasonEventEdit']          = 'other/reason/cReason/FSaRSNEditEvent';
$route['reasonEventDelete']        = 'other/reason/cReason/FSaRSNDeleteEvent';
// $route ['reasonEventDelete']        = 'other/reason/cReason/FSaRSNDeleteEvent';	


// Reason ประเทศ
// Worakorn 30/04/2021
$route['masNation/(:any)/(:any)']     = 'other/nation/Nation_controller/index/$1/$2';
$route['nationList']               = 'other/nation/Nation_controller/FSvCNATListPage';
$route['nationDataTable']          = 'other/nation/Nation_controller/FSvCNATDataList';
$route['nationDataTableAPI']          = 'other/nation/Nation_controller/FSvCNATDataListAPINation';


// Forms (ฟอร์ม)
$route['forms/(:any)/(:any)']     = 'other/forms/Forms_controller/index/$1/$2';
$route['formsList']               = 'other/forms/Forms_controller/FSvCFRMListPage';
$route['formsDataTable']          = 'other/forms/Forms_controller/FSvCFRMDataList';
$route['formsPageAdd']            = 'other/forms/Forms_controller/FSvCFRMAddPage';
$route['formsEventAdd']           = 'other/forms/Forms_controller/FSaCFRMAddEvent';
$route['formsPageEdit']           = 'other/forms/Forms_controller/FSvCFRMEditPage';
$route['formsEventEdit']          = 'other/forms/Forms_controller/FSaCFRMEditEvent';
$route['formsEventDelete']        = 'other/forms/Forms_controller/FSaCFRMDeleteEvent';
$route['formsStdGetUrlEdit']      = 'other/forms/Forms_controller/FSaCFRMStdGetUrlEditForm';