<?php defined ('BASEPATH') or exit ( 'No direct script access allowed' );

////////////////////////เมนูลงทะเบียน////////////////////////
$route['adwADWGetProfile'] = 'adawallet/Adawallet_controller/index';
$route['adwADWRegister'] = 'adawallet/Adawallet_controller/FSaCADWRegister';

////////////////////เมนูเติมเงิน-เช็คยอดเงิน////////////////////
$route['adwADWShowBalance'] = 'adawallet/Adawallet_controller/FSaCADWShowBalance';
$route['adwADWCheckBalance'] = 'adawallet/Adawallet_controller/FSaCADWCheckBalance';
$route['adwADWGenQR'] = 'adawallet/Adawallet_controller/FSaCADWGenQR';
$route['adwADWTopup'] = 'adawallet/Adawallet_controller/FSaCADWTopup';

/////////////////////////เมนูจ่ายเงิน/////////////////////////
$route['adwADWPayment'] = 'adawallet/Adawallet_controller/FSaCADWPayment';
$route['adwADWEventPayment'] = 'adawallet/Adawallet_controller/FSaCADWEventPayment';
$route['adwADWRequestOTP'] = 'adawallet/Adawallet_controller/FSaCADWRequestOTP';

/////////////////////////เมนูบันทึกรูปลงโทรศัพท์ในจ่ายเงิน/////////////////////////
$route['adwADWEventSaveImage'] = 'adawallet/Adawallet_controller/FSaCADWEventSaveImage';
$route['adwADWEventDonwloadImage/(:any)/(:any)'] = 'adawallet/Adawallet_controller/FSaCADWEventDonwloadImage/$1/$2';
$route['adwADWEventUnlinkImage'] = 'adawallet/Adawallet_controller/FSaCADWEventUnlinkImage';

/////////////////////////เมนูคืนเงิน/////////////////////////
$route['adwADWRefund'] = 'adawallet/Adawallet_controller/FSaCADWRefund';
$route['adwADWShowRefund'] = 'adawallet/Adawallet_controller/FSaCADWShowRefund';
$route['adwADWEventRefund'] = 'adawallet/Adawallet_controller/FSaCADWEventRefund';



