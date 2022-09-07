<?php

// Create By : Napat(Jame) 11/02/2021
// เนื่องจากอัพเดทเวอชั่น php => 7.3 ฟังค์ชั่น count() ไม่รองรับ ถ้าใส่ข้อมูลที่ไม่ใช่ array || object มันจะ error
// จึงสร้างฟังค์ชั่นนี้มาเพื่อ replace all file in project
function FCNnHSizeOf($poParams){
    try{
        $nCount = 0;
        if( !empty($poParams) && ( is_array($poParams) || is_object($poParams) ) ){
            $nCount = count($poParams);
        }
    }catch(Exception $Error){
        $nCount = 0;
    }
    return $nCount;
}




function FCNUtf8StrLen($ptString) {
    
    $nC = strlen($ptString); $nL = 0;
    for ($nI = 0; $nI < $nC; ++$nI) if ((ord($ptString[$nI]) & 0xC0) != 0x80) ++$nL;
    return $nL;
}


    //Functionality : Get Top Row Product By Config
    //Parameters : Ajax Call View DataTable
    //Creator : 17/02/2022
    //Return : integer
    //Return Type : INT
    function FCNnGetBrwTopWeb() {
        try{
            $ci = &get_instance();
            $ci->load->database();
            $tSQL = "SELECT FTSysStaDefValue,FTSysStaUsrValue
            FROM  TSysConfig 
            WHERE FTSysCode = 'nVB_BrwTopWeb'
            AND FTSysKey = 'nVB_BrwTopWeb'";

                $oQuery = $ci->db->query($tSQL);

                if ($oQuery->num_rows() > 0) {
                $oRes  = $oQuery->row_array();
                if ($oRes['FTSysStaUsrValue'] != '') {
                    $tDataTopPdt = $oRes['FTSysStaUsrValue'];
                } else {
                    $tDataTopPdt = $oRes['FTSysStaDefValue'];
                }
                } else {
                //Decimal Default = 2 
                $tDataTopPdt = 50;
                }
                return $tDataTopPdt;
            }catch(Exception $Error){

                return 50;
            }
    }



    //Functionality : Get Top Row Product By Config
    //Parameters : Ajax Call View DataTable
    //Creator : 17/02/2022
    //Return : integer
    //Return Type : INT
    function FCNnGetStaTopPdt() {
        try{
            $ci = &get_instance();
            $ci->load->database();
            $tSQL = "SELECT FTSysStaDefValue,FTSysStaUsrValue
            FROM  TSysConfig 
            WHERE FTSysCode = 'nVB_StaTopPdt'
            AND FTSysKey = 'nVB_StaTopPdt'";

                $oQuery = $ci->db->query($tSQL);

                if ($oQuery->num_rows() > 0) {
                $oRes  = $oQuery->row_array();
                if ($oRes['FTSysStaUsrValue'] != '') {
                    $tDataTopPdt = $oRes['FTSysStaUsrValue'];
                } else {
                    $tDataTopPdt = $oRes['FTSysStaDefValue'];
                }
                } else {
                //Decimal Default = 2 
                $tDataTopPdt = 50;
                }
                return $tDataTopPdt;
            }catch(Exception $Error){

                return 50;
            }
    }
