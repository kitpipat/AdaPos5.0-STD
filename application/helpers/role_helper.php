<?php
    /**
     * Functionality : Check user in role
     * Parameters : $ptCardTypeCode
     * Creator : 18/1/2019 Piya
     * Last Modified : -
     * Return : Status true is have user, false is empty user
     * Return Type : Boolean
    */
    function FCNbIsHaveUserInRole($ptRoleCode){
        $ci = &get_instance();
        $ci->load->database();
        
        $bHaveUser = false;
        
        $tSQL = "   
            SELECT 
                USR.FTUsrCode
            FROM TCNMUsrActRole USR
            WHERE USR.FTRolCode = '$ptRoleCode'
        ";
        
        $oQuery = $ci->db->query($tSQL);
        
        if ($oQuery->num_rows() > 0) {
            $bHaveUser = true;
        }
        
        return $bHaveUser;
    }
    
    function FCNbIsGetRoleWasteWAH(){
        $ci = &get_instance();
        $ci->load->database();

        $tSesUsrRoleCodeMulti = $ci->session->userdata("tSesUsrRoleCodeMulti");

        $tSQL = "SELECT
                    USR.FTRolCode
                FROM TCNTUsrFuncRpt USR
                WHERE USR.FTRolCode IN ($tSesUsrRoleCodeMulti) AND FTUfrGrpRef = '085' AND FTUfrRef = 'KB901' ";

        $oQuery = $ci->db->query($tSQL);
        if ($oQuery->num_rows() > 0) {
            $bHaveUser = true;
        }else{
            $bHaveUser = false;
        }
        unset($tSesUsrRoleCodeMulti);
        unset($tSQL);
        unset($oQuery);
        return $bHaveUser;
    }
    /**
     * Functionality : Check Alow Function in Role
     * Parameters : $paParams
     * Creator : 18/05/2020 Piya
     * Last Modified : -
     * Return : Status true is alow function, false is not alow function
     * Return Type : Boolean
    */
    function FCNbIsAlwFuncInRole($paParams = []){

        $tUfrGrpRef = $paParams["tUfrGrpRef"];
        $tUfrRef = $paParams["tUfrRef"];
        $tGhdApp = $paParams["tGhdApp"];

        $ci = &get_instance();
        $ci->load->database();

        $tRoleCode = empty($ci->session->userdata("tSesUsrRoleCodeMulti"))?"''":$ci->session->userdata("tSesUsrRoleCodeMulti");
        
        $bStatus = false;
        
        $tSQL = "   
            SELECT 
            USR_FUNC_RPT.FTRolCode
            FROM TCNTUsrFuncRpt USR_FUNC_RPT WITH (NOLOCK)
            WHERE USR_FUNC_RPT.FTUfrType = '1'
            AND USR_FUNC_RPT.FTUfrStaAlw = '1'
            AND USR_FUNC_RPT.FTRolCode IN ($tRoleCode)
            AND USR_FUNC_RPT.FTUfrGrpRef = '$tUfrGrpRef'
            AND USR_FUNC_RPT.FTUfrRef = '$tUfrRef'
            AND USR_FUNC_RPT.FTGhdApp = '$tGhdApp'
        ";
        
        $oQuery = $ci->db->query($tSQL);
        
        if ($oQuery->num_rows() > 0) {
            $bStatus = true;
        }
        
        return $bStatus;
    }

    /**
     * Functionality : Check Level Usr Agn ?
     * Parameters : $paParams
     * Creator : 17/12/2020 Nattakit
     * Last Modified : -
     * Return : ?????????????????????????????????????????????????????????????????????????????? ??????????????? AD ?????????????????????
     * Return Type : Boolean
    */
    function FCNbUsrIsAgnLevel(){
        $ci = &get_instance();
        $ci->load->database();

        $tSesUserCode = $ci->session->userdata('tSesUserCode');
        $aDataUsrGrp = $ci->db->where('FTUsrCode',$tSesUserCode)->get('TCNTUsrGroup')->row_array();

        if(!empty($aDataUsrGrp['FTAgnCode']) &&  empty($aDataUsrGrp['FTBchCode'])){
            $bStatusReSult = true;
        }else{
            $bStatusReSult = false;
        }
      return $bStatusReSult;
    }

    /**
     * Functionality : Check Level Usr Mer ?
     * Parameters : $paParams
     * Creator : 17/12/2020 Nattakit
     * Last Modified : -
     * Return : ?????????????????????????????????????????????????????????????????????????????? ??????????????? Mer ?????????????????????
     * Return Type : Boolean
    */
    function FCNbUsrIsMerLevel(){
        $ci = &get_instance();
        $ci->load->database();

        $tSesUserCode = $ci->session->userdata('tSesUserCode');
        $aDataUsrGrp = $ci->db->where('FTUsrCode',$tSesUserCode)->get('TCNTUsrGroup')->row_array();

        if(!empty($aDataUsrGrp['FTMerCode']) &&  empty($aDataUsrGrp['FTShpCode'])){
            $bStatusReSult = true;
        }else{
            $bStatusReSult = false;
        }
      return $bStatusReSult;
    }

    function FCNbGetUsrFuncRpt($paData){
        $ci = &get_instance();
        $ci->load->database();

        $tUfrGrpRef = $paData['FTUfrGrpRef'];
        $tUfrRef    = $paData['FTUfrRef'];

        $tSesUsrRoleCodeMulti = $ci->session->userdata("tSesUsrRoleCodeMulti");
        $tSQL       = " SELECT FTUfrStaAlw
                        FROM TCNTUsrFuncRpt WITH(NOLOCK)
                        WHERE FTUfrGrpRef   = '$tUfrGrpRef'
                          AND FTUfrRef      = '$tUfrRef'
                          AND FTRolCode     IN ($tSesUsrRoleCodeMulti)
                          AND FTUfrStaAlw   = '1' ";
        $oQuery = $ci->db->query($tSQL);
        if( $oQuery->num_rows() > 0 ){
            return true;
        }else{
            return false;
        }
    }
