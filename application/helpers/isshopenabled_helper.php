<?php
/**
* Functionality : อ่านค่าว่าอนุญาตให้ระบบร้านค้าทำงานไหมจาก db มาเก็บใน userdata session
* Parameters    : -
* Creator       : 16/04/2020 surawat + 11/08/2020 Supawat 
* Last Modified : -
* Return        : -
* Return Type   : -
*/
function FCNbLoadConfigIsShpEnabled(){
    $ci = &get_instance();
    $ci->load->database();
    $tRoleCode  = $ci->session->userdata('tSesUsrRoleCodeMulti');
    $tSQL       = "SELECT FTRolCode , FTMnuCode , FTAutStaRead FROM TCNTUsrMenu WHERE FTRolCode IN($tRoleCode) AND FTMnuCode IN('SVD002','SLK002','STO003') ";
    $oQuery     = $ci->db->query($tSQL);
    if ($oQuery->num_rows() > 0) { 
        $bBrowseShpConfigValue = true;
        $ci->session->set_userdata("bShpEnabled", $bBrowseShpConfigValue);
    } else { 
        $bBrowseShpConfigValue = false;
        $ci->session->set_userdata("bShpEnabled", $bBrowseShpConfigValue);
    }
    return $ci->session->userdata("bShpEnabled");
}

/**
* Functionality : อ่านค่าการอนุญาตให้ระบบร้านค้าทำงานที่เก็บไว้ใน userdata session
* Parameters    : -
* Creator       : 16/04/2020 surawat + 11/08/2020 Supawat 
* Last Modified : -
* Return        : ผลอนุญาตให้ระบบร้านค้าทำงาน
* Return Type   : boolean
*/
function FCNbGetIsShpEnabled(){
    $ci = &get_instance();
    return $ci->session->userdata("bShpEnabled");
}

/**
* Functionality : อ่านค่าว่าอนุญาตให้ระบบตัวแทนขายทำงานไหมจาก db มาเก็บใน userdata session
* Parameters    : -
* Creator       : 09/11/2020 Napat(Jame)
* Last Modified : -
* Return        : -
* Return Type   : -
*/
function FCNbLoadConfigIsAgnEnabled(){
    $ci = &get_instance();
    $ci->load->database();
    $tRoleCode  = $ci->session->userdata('tSesUsrRoleCodeMulti');
    $tSQL       = " SELECT FTRolCode , FTMnuCode , FTAutStaRead FROM TCNTUsrMenu WHERE FTRolCode IN($tRoleCode) AND FTMnuCode IN('SYS006') ";
    $oQuery     = $ci->db->query($tSQL);
    if ($oQuery->num_rows() > 0) { 
        $ci->session->set_userdata("bAgnEnabled", true);
    } else { 
        $ci->session->set_userdata("bAgnEnabled", false);
    }
    return $ci->session->userdata("bAgnEnabled");
}

/**
* Functionality : อ่านค่าการอนุญาตให้ระบบตัวแทนขายทำงานที่เก็บไว้ใน userdata session
* Parameters    : -
* Creator       : 09/11/2020 Napat(Jame)
* Last Modified : -
* Return        : ผลอนุญาตให้ระบบตัวแทนขายทำงาน
* Return Type   : boolean
*/
function FCNbGetIsAgnEnabled(){
    $ci = &get_instance();
    return $ci->session->userdata("bAgnEnabled");
}

/**
* Functionality : อ่านค่าว่าอนุญาตให้ระบบตัวแทนขายทำงานไหมจาก db มาเก็บใน userdata session
* Parameters    : -
* Creator       : 19/11/2020 Napat(Jame)
* Last Modified : -
* Return        : -
* Return Type   : -
*/
function FCNbLoadConfigIsLockerEnabled(){
    $ci = &get_instance();
    $ci->load->database();
    $tRoleCode  = $ci->session->userdata('tSesUsrRoleCodeMulti');
    $tSQL       = " SELECT FTRolCode , FTMnuCode , FTAutStaRead FROM TCNTUsrMenu WHERE FTRolCode IN($tRoleCode) AND FTGmnCode = 'SLK' ";
    $oQuery     = $ci->db->query($tSQL);
    if ($oQuery->num_rows() > 0) { 
        $ci->session->set_userdata("bLockerEnabled", true);
    } else { 
        $ci->session->set_userdata("bLockerEnabled", false);
    }
    return $ci->session->userdata("bLockerEnabled");
}

/**
* Functionality : อ่านค่าการอนุญาตให้ระบบตัวแทนขายทำงานที่เก็บไว้ใน userdata session
* Parameters    : -
* Creator       : 19/11/2020 Napat(Jame)
* Last Modified : -
* Return        : ผลอนุญาตให้ระบบตัวแทนขายทำงาน
* Return Type   : boolean
*/
function FCNbGetIsLockerEnabled(){
    $ci = &get_instance();
    return $ci->session->userdata("bLockerEnabled");
}


/**
* Functionality : อ่านค่าว่าอนุญาตให้ระบบตัวแทนขายทำงานไหมจาก db มาเก็บใน userdata session
* Parameters    : -
* Creator       : 19/11/2020 Napat(Jame)
* Last Modified : -
* Return        : -
* Return Type   : -
*/
function FCNbLoadPdtFasionEnabled(){
    $ci = &get_instance();
    $ci->load->database();
    $tRoleCode  = $ci->session->userdata('tSesUsrRoleCodeMulti');
    $tSQL       = " SELECT FTRolCode , FTMnuCode , FTAutStaRead FROM TCNTUsrMenu WHERE FTRolCode IN($tRoleCode) AND FTGmnCode = 'PFH' ";
    $oQuery     = $ci->db->query($tSQL);
    if ($oQuery->num_rows() > 0) { 
        $ci->session->set_userdata("bPdtFasionEnabled", true);
    } else { 
        $ci->session->set_userdata("bPdtFasionEnabled", false);
    }
    return $ci->session->userdata("bPdtFasionEnabled");
}

/**
* Functionality : อ่านค่าการอนุญาตให้ระบบตัวแทนขายทำงานที่เก็บไว้ใน userdata session
* Parameters    : -
* Creator       : 19/11/2020 Napat(Jame)
* Last Modified : -
* Return        : ผลอนุญาตให้ระบบตัวแทนขายทำงาน
* Return Type   : boolean
*/
function FCNbGetPdtFasionEnabled(){
    $ci = &get_instance();
    return $ci->session->userdata("bPdtFasionEnabled");
}

/* Create By : 23/08/2021 Napat(Jame)*/
function FCNbGetIsCategoryEnabled($pnCatLevel){
    $ci = &get_instance();
    $nCatLevel = intval($pnCatLevel);
    switch($nCatLevel){
        case 1:
            $bReturn = $ci->session->userdata("bCatLvl1Enabled");
            break;
        case 2:
            $bReturn = $ci->session->userdata("bCatLvl2Enabled");
            break;
        case 3:
            $bReturn = $ci->session->userdata("bCatLvl3Enabled");
            break;
        case 4:
            $bReturn = $ci->session->userdata("bCatLvl4Enabled");
            break;
        case 5:
            $bReturn = $ci->session->userdata("bCatLvl5Enabled");
            break;
    }
    return $bReturn;
}

// Create By : Napat(Jame) 26/10/2022
function FCNbLoadConfigIsCarEnabled(){
    $ci = &get_instance();
    $ci->load->database();
    $tRoleCode  = $ci->session->userdata('tSesUsrRoleCodeMulti');
    $tSQL       = " SELECT FTRolCode , FTMnuCode , FTAutStaRead FROM TCNTUsrMenu WHERE FTRolCode IN($tRoleCode) AND FTMnuCode IN('M00111') "; // รหัสเมนูข้อมูลรถ อ้างอิงจากเบส Fitauto
    $oQuery     = $ci->db->query($tSQL);
    if ($oQuery->num_rows() > 0) { 
        $ci->session->set_userdata("bCarEnabled", true);
    } else { 
        $ci->session->set_userdata("bCarEnabled", false);
    }
    return $ci->session->userdata("bCarEnabled");
}

// Create By : Napat(Jame) 26/10/2022
function FCNbGetIsCarEnabled(){
    $ci = &get_instance();
    return $ci->session->userdata("bCarEnabled");
}