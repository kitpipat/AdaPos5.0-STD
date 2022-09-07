<?php defined ('BASEPATH') or exit ( 'No direct script access allowed' );

$route ['bankindex/(:any)/(:any)']    = 'bank/bank/cBank/index/$1/$2';
$route ['banklist']                   = 'bank/bank/cBank/FSvCBNKListPage';
$route ['bankDataTable']              = 'bank/bank/cBank/FSvCBNKDataList';
$route ['bankPageAdd']                = 'bank/bank/cBank/FSvCBNKAddPage';
$route ['bankPageEdit']               = 'bank/bank/cBank/FSvCBNKEditPage';
$route ['bankEventAdd']               = 'bank/bank/cBank/FSoCBNKAddEvent';
$route ['bankEventEdit']              = 'bank/bank/cBank/FSoCBNKEditEvent';
$route ['bankEventDelete']           = 'bank/bank/cBank/FSoCBNKDeleteEvent';