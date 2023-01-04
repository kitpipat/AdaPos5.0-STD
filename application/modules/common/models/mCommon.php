<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );
use CodeIgniter\CLI\BaseCommand;
use CodeIgniter\CLI\CLI;

class mCommon extends CI_Model {
    //Functionality : Function Update Password User Login
    //Parameters : usrlogin , oldpass , newpass
    //Creator : 13/05/2020 Napat(Jame)
    // Last Update : 16/11/2020 Napat(Jame) เพิ่มการตรวจสอบ Error Message
    //Last Modified : -
    //Return : Status Update Password
    //Return Type : Array
    public function FCNaMCMMChangePassword($paPackData){
        try{


            $tSQL = "   SELECT TOP 1
                            A.*,
                            CASE 
                                WHEN ISNULL(B.FTUsrLogin,'')     = '' THEN '999'  /*ไม่พบชื่อผู้ใช้*/
                                WHEN ISNULL(C.FTUsrLoginPwd,'')  = '' THEN '998'  /*รหัสผ่านเดิมไม่ถูกต้อง*/
                                WHEN ISNULL(B.FTUsrStaActive,'') = '2' THEN '997' /*สถานะไม่ใช้งาน ไม่สามารถเปลี่ยนรหัสผ่าน*/
                                WHEN CONVERT(VARCHAR(10),GETDATE(),121) > CONVERT(VARCHAR(10),B.FDUsrPwdExpired,121) THEN '996' /*หมดอายุไม่สามารถเปลี่ยนรหัสผ่าน*/
                                ELSE '0'
                            END AS FTErrMsg 
                        FROM (
                            SELECT '1' AS Seq
                        ) A
                        LEFT JOIN TCNMUsrLogin B WITH(NOLOCK) ON B.FTUsrLogin = '".$paPackData['FTUsrLogin']."' AND B.FTUsrLogType  = '".$paPackData['tStaLogType']."'
                        LEFT JOIN TCNMUsrLogin C WITH(NOLOCK) ON C.FTUsrLogin = '".$paPackData['FTUsrLogin']."' AND C.FTUsrLoginPwd = '".$paPackData['tPasswordOld']."'
                    ";

            $oQuery     = $this->db->query($tSQL);
            $aListData  = $oQuery->result_array();

            if( $aListData[0]['FTErrMsg'] == '0' ){
                // ถ้าส่ง parameters UsrStaActive = 3 คือ เปลี่ยนรหัสผ่าน ครั้งแรก
                // ให้ปรับสถานะ = 1 เพื่อเริ่มใช้งาน
                if($paPackData['nChkUsrSta'] == 3){
                    $this->db->set('FTUsrStaActive'  , '1');
                }

                $this->db->set('FTUsrLoginPwd'  , $paPackData['tPasswordNew']);
                $this->db->where('FTUsrLogin'  , $paPackData['FTUsrLogin']);
                $this->db->where('FTUsrLoginPwd'  , $paPackData['tPasswordOld']);
                $this->db->update('TCNMUsrLogin');

                if($this->db->affected_rows() > 0){
                    $aStatus = array(
                        'nCode'     => 1,
                        'tDesc'     => 'Update Password Success',
                    );
                }else{
                    $aStatus = array(
                        'nCode'     => 905,
                        'tDesc'     => 'Error Cannot Update Password.',
                    );
                }
            }else{
                $aStatus = array(
                    'nCode'     => $aListData[0]['FTErrMsg'],
                    'tDesc'     => 'Data false',
                );
            }
            return $aStatus;
        }catch(Exception $Error){
            return $Error;
        }
    }

    //Delete
    public function FCNaMCMMDeleteTmpExcelCasePDT($paPackData){
        try{    
            $aWhere = array('TCNMPdt','TCNMPdtUnit','TCNMPdtBrand','TCNMPdtTouchGrp','TCNMPdtType','TCNMPdtModel','TCNMPdtGrp','TCNMPdtSpcBch');
            $this->db->where_in('FTTmpTableKey' , $aWhere);
            $this->db->where_in('FTSessionID'   , $paPackData['tSessionID']);
            $this->db->delete($paPackData['tTableNameTmp']); 
        }catch(Exception $Error){
            return $Error;
        }
    }

    //Import Excel To Temp
    public function FCNaMCMMImportExcelToTmp($paPackData,$poIns){
        try{    

            $tTableNameTmp      = $paPackData['tTableNameTmp'];
            $tNameModule        = $paPackData['tNameModule'];
            $tTypeModule        = $paPackData['tTypeModule']; 
            $tFlagClearTmp      = $paPackData['tFlagClearTmp']; 
            $tTableRefPK        = $paPackData['tTableRefPK']; 



            //ลบข้อมูลทั้งหมดก่อน
            if($tTypeModule == 'document' && $tFlagClearTmp == 1){
                //ลบช้อมูลของ document
                if ($tTableNameTmp == 'TCNTPrnLabelTmp') {
                    $tIP = $this->input->ip_address();
                    $tFullHost = gethostbyaddr($tIP);
                    $this->db->where_in('FTComName', $tFullHost);
                    $this->db->delete($tTableNameTmp);
                } else {
                    $this->db->where_in('FTXthDocKey'   , $tTableRefPK);
                    $this->db->where_in('FTSessionID'   , $paPackData['tSessionID']);
                    $this->db->delete($tTableNameTmp);
                }
            }else if($tTypeModule == 'master'){
                //ลบข้อมูลของ master
                if($tNameModule != 'product'){
                    $this->db->where_in('FTTmpTableKey' , $tTableRefPK);
                    $this->db->where_in('FTSessionID'   , $paPackData['tSessionID']);
                    $this->db->delete($tTableNameTmp);  
                }
            }
           
            //เพิ่มข้อมูล
            $this->db->insert_batch($tTableNameTmp, $poIns);
            /*เพิ่มข้อมูล
             $tNameProject   = explode('/', $_SERVER['REQUEST_URI'])[1];
             $tPathFileBulk  = $_SERVER['DOCUMENT_ROOT'].'/'.$tNameProject.'/application/modules/common/assets/writeFileImport/FileImport_Branch.txt';
             $tSQL = "BULK INSERT dbo.TCNTImpMasTmp FROM '".$tPathFileBulk."'
                     WITH
                     (
                         FIELDTERMINATOR=',',
                         ROWTERMINATOR = '\n'
            )";*/
        }catch(Exception $Error){
            return $Error;
        }
    }

    //Import Excel To Temp
    public function FCNaMCMMImportExcelToFhnTmp($paPackData,$poIns){
        try{    

            $tTableFhnNameTmp   = $paPackData['tTableFhnNameTmp'];
            $tNameModule        = $paPackData['tNameModule'];
            $tTypeModule        = $paPackData['tTypeModule']; 
            $tFlagClearTmp      = $paPackData['tFlagClearTmp']; 
            $tTableRefPK        = $paPackData['tTableRefPK']; 

                //ลบช้อมูลของ document
                $this->db->where_in('FTXthDocKey'   , $tTableRefPK);
                $this->db->where_in('FTSessionID'   , $paPackData['tSessionID']);
                $this->db->delete($tTableFhnNameTmp);
  
           
            //เพิ่มข้อมูล
            $this->db->insert_batch($tTableFhnNameTmp, $poIns);

        }catch(Exception $Error){
            return $Error;
        }
    }


    /**
     * Functionality: ตรวจสอบข้อมูลสินค้าจากรหัสบาร์โค้ด
     * Parameters: Array เงื่อนไขการเช็คค่า [$paParams]
     * Creator: 21/04/2022 ์ฟสำ
     * Last Modified: -
     * Return: Statuss
     * Return Type: Number
    */
    public function FCNaMCMMImportExcelFindPdtInfoByBarCode($paData){
        $tPdtCode = $paData['FTPdtCode'];
        $tBarCode = $paData['FTBarCode'];
        $nLngID = $paData['FNLngID'];
        $tSQL = "SELECT
        	        PDT.FTPdtForSystem,
                    CASE WHEN PDT.FTPdtForSystem = 5 THEN 'FH' ELSE 'GN' END AS PDTSpc ,
                    BAR.FTPdtCode,
                    PDT_L.FTPdtName,
                    BAR.FTBarCode,
                    BAR.FTPunCode,
                    UNT_L.FTPunName,
                    PSZ.FCPdtUnitFact,
                    BAR.FTFhnRefCode,
                    BAR.FNBarRefSeq,
                    BAR.FTPlcCode,
                    PDT.FTPdtStaVatBuy,
                    PDT.FTPdtStaAlwDis,
                    PDT.FTPdtSaleType
                FROM
                    TCNMPdtBar BAR WITH(NOLOCK)
                LEFT OUTER JOIN TCNMPdt PDT WITH(NOLOCK) ON BAR.FTPdtCode = PDT.FTPdtCode
                LEFT OUTER JOIN TCNMPdt_L PDT_L WITH(NOLOCK) ON BAR.FTPdtCode = PDT_L.FTPdtCode AND PDT_L.FNLngID = $nLngID
                LEFT OUTER JOIN TCNMPdtUnit_L UNT_L WITH(NOLOCK) ON BAR.FTPunCode = UNT_L.FTPunCode AND UNT_L.FNLngID = $nLngID
                LEFT OUTER JOIN TCNMPdtPackSize PSZ WITH(NOLOCK) ON BAR.FTPdtCode = PSZ.FTPdtCode AND BAR.FTPunCode = PSZ.FTPunCode
                WHERE PDT.FTPdtStaActive = '1'
                ";
            if(!empty($tPdtCode)){
                $tSQL .= " AND BAR.FTPdtCode = '$tPdtCode' "; 
            }
            if(!empty($tBarCode)){
                $tSQL .= " AND BAR.FTBarCode = '$tBarCode' "; 
            }
            $oQuery = $this->db->query($tSQL);

            if ($oQuery->num_rows() > 0) {
                $oDetail = $oQuery->row_array();
                $aResult = array(
                    'raItem'   => $oDetail,
                    'rtCode'    => '1',
                    'rtDesc'    => 'success',
                );
            } else {
                $aResult = array(
                    'rtCode' => '800',
                    'rtDesc' => 'data not found.',
                );
            }
            return $aResult;
    }


    
    /**
     * Functionality: ตรวจสอบข้อมูลสินค้าจากรหัสบาร์โค้ด
     * Parameters: Array เงื่อนไขการเช็คค่า [$paParams]
     * Creator: 21/04/2022 ์ฟสำ
     * Last Modified: -
     * Return: Statuss
     * Return Type: Number
    */
    public function FCNaMCMMListDataPrintBarCode($ptBarCode, $pnLangPrint)
    {
        $tSQLSelect = " SELECT 
        PDT.FTPdtCode,
                            PDTL.FTPdtName FTPdtName, 
                            ISNULL(PRI.FCPgdPriceRet,0) FCPdtPrice,
                            '' FTPlcCode,
                            GETDATE() FDPrnDate,
                            ISNULL(PCL.FTClrName,'') + ' ' + ISNULL(PSZ.FTPszName,'') FTPdtContentUnit,
                            '' AS FTPlbCode, 
                            ISNULL(PBNL.FTPbnName,'') FTPbnDesc,
                            'ดูที่ผลิตภัณฑ์' FTPdtTime, 
                            'ดูที่ผลิตภัณฑ์' FTPdtMfg,
                            'บริษัท คิง เพาเวอร์ คลิก จำกัด' FTPdtImporter,
                            PDG.FTPdgRegNo FTPdtRefNo,
                            PSZ.FTPszName FTPdtValue,
                            1 FTPlbStaSelect
        FROM TCNMPdt PDT with(nolock)
                    INNER JOIN TCNMPdtPackSize PPS with(nolock) ON PPS.FTPdtCode = PDT.FTPdtCode
                    LEFT JOIN TCNMPdtUnit_L PUL WITH(NOLOCK) ON PUL.FTPunCode = PPS.FTPunCode AND PUL.FNLngID = $pnLangPrint
                    LEFT JOIN TCNMPdtBar BAR with(nolock) ON BAR.FTPdtCode = PPS.FTPdtCode AND BAR.FTPunCode = PPS.FTPunCode
                    LEFT JOIN TCNMPdt_L PDTL with(nolock) ON PDTL.FTPdtCode = PDT.FTPdtCode AND PDTL.FNLngID = $pnLangPrint
                    LEFT JOIN (SELECT PRI.FTPdtCode,PRI.FTPunCode,PRI.FCPgdPriceRet FROM TCNTPdtPrice4PDT PRI with(nolock) 
                                INNER JOIN (SELECT FTPdtCode,FTPunCode,MAX(FTPghDocNo) FTPghDocNo
                                FROM TCNTPdtPrice4PDT with(nolock)
                                WHERE CONVERT(VARCHAR(10),GETDATE(),121) BETWEEN FDPghDStart AND FDPghDStop
                                AND FTPghDocType = '1' 
                                GROUP BY FTPdtCode,FTPunCode) PRI2 ON PRI2.FTPdtCode = PRI.FTPdtCode AND PRI2.FTPunCode = PRI.FTPunCode 
                                AND PRI2.FTPghDocNo = PRI.FTPghDocNo) PRI ON PRI.FTPdtCode = PDT.FTPdtCode AND BAR.FTPunCode = PRI.FTPunCode
                                LEFT JOIN
                            (
                            SELECT PRI.FTPdtCode, 
                                PRI.FTPunCode, 
                                PRI.FCPgdPriceRet
                            FROM TCNTPdtPrice4PDT PRI WITH(NOLOCK)
                                INNER JOIN
                            (
                                SELECT FTPdtCode, 
                                    FTPunCode, 
                                    MAX(FTPghDocNo) FTPghDocNo
                                FROM TCNTPdtPrice4PDT WITH(NOLOCK)
                                WHERE CONVERT(VARCHAR(10), GETDATE(), 121) BETWEEN FDPghDStart AND FDPghDStop
                                    AND FTPghDocType = '2'
                                GROUP BY FTPdtCode, 
                                        FTPunCode
                            ) PRI2 ON PRI2.FTPdtCode = PRI.FTPdtCode
                                    AND PRI2.FTPunCode = PRI.FTPunCode
                                    AND PRI2.FTPghDocNo = PRI.FTPghDocNo
                            ) PRIPRO ON PRIPRO.FTPdtCode = PDT.FTPdtCode
                                    AND BAR.FTPunCode = PRIPRO.FTPunCode
                    LEFT JOIN TCNMPdtBrand_L PBNL with(nolock) ON PBNL.FTPbnCode = PDT.FTPbnCode AND PBNL.FNLngID = $pnLangPrint
                    LEFT JOIN TCNMPdtDrug PDG with(nolock) ON PDG.FTPdtCode = PDT.FTPdtCode
                    LEFT JOIN TCNMPdtSize_L PSZ with(nolock) ON PSZ.FTPszCode = PPS.FTPszCode AND PSZ.FNLngID =   $pnLangPrint
                    LEFT JOIN TCNMPdtColor_L PCL with(nolock) ON PCL.FTClrCode = PPS.FTClrCode AND PCL.FNLngID =   $pnLangPrint
                    LEFT JOIN TCNMPdtCategory CAT WITH(NOLOCK) ON PDT.FTPdtCode = CAT.FTPdtCode
                    WHERE 1 = 1 AND BAR.FTBarCode = '$ptBarCode' ";


        $oQuerySelect = $this->db->query($tSQLSelect);

        if ($oQuerySelect->num_rows() > 0) {
            $oResult = $oQuerySelect->result_array();
        } else {
            $oResult = array();
        }

        return  $oResult;
    }


    /**
     * Functionality: ตรวจสอบข้อมูลสินค้าจากรหัสบาร์โค้ด
     * Parameters: Array เงื่อนไขการเช็คค่า [$paParams]
     * Creator: 21/04/2022 ์ฟสำ
     * Last Modified: -
     * Return: Statuss
     * Return Type: Number
    */
    public function FCNaMCMMListDataPrintBarCodeCheckValidate()
    {
        $tIP = $this->input->ip_address();
        $tFullHost = gethostbyaddr($tIP);

        $tSQL = "UPDATE TCNTPrnLabelTmp
        SET FTPlbStaImport = 2,FTPlbStaSelect = null,FTPlbImpDesc =  '[2]ไม่พบสินค้า'
        WHERE FTPdtCode  IS NULL AND FTComName = '$tFullHost' ";

        $oQuerySelect = $this->db->query($tSQL);

        // if ($oQuerySelect->num_rows() > 0) {
        //     $oResult = $oQuerySelect->result_array();
        // } else {
        //     $oResult = array();
        // }

        // return  $oResult;
    }

        // Create By : Napat(Jame) 22/06/2022
        public function FCNaMWahChkStk($paParams){
            $tBchCode   = $paParams['tBchCode'];
            $tWahCode   = $paParams['tWahCode'];
    
            // print_r($tWahCode);
            $tSQL = " SELECT 1 FROM TCNMWaHouse WHERE FTBchCode = '".$tBchCode."' AND FTWahCode = '".$tWahCode."' AND FTWahStaChkStk IN ('2','3') ";
            $oQuery = $this->db->query($tSQL);
    
            if( $oQuery->num_rows() > 0 ){
                $aStatus = array(
                    'nCode'     => 1,
                    'tDesc'     => 'Wahouse is check stock'
                );
            }else{
                $aStatus = array(
                    'nCode'     => 800,
                    'tDesc'     => 'Wahouse is not check stock',
                );
            }
            return $aStatus;
        }
    
        // Create By : Napat(Jame) 22/06/2022
        // Last Update : Napat(Jame) 29/06/2022 เพิ่มแสดงเอกสารรออนุมัติ เฉพาะเอกสารที่มีสินค้าตรงกัน อย่างน้อย 1 รายการ
        // ค้นหาเอกสารการโอน รออนุมัติ
        public function FCNaMGetDocInvPendingApv($paParams){
            $tBchCode   = $paParams['tBchCode'];
            $tWahCode   = $paParams['tWahCode'];
            $nLangEdit  = $this->session->userdata("tLangEdit");
    
            $tTableDT   = $paParams['tTableDT'];
            $tDocNo     = $paParams['tDocNo'];
            $tDocDT     = " INNER JOIN ".$tTableDT." DOCDT WITH(NOLOCK) ON DOCDT.FTXthDocNo = '".$tDocNo."' AND DT.FTPdtCode = DOCDT.FTPdtCode ";
    
            $tSQL = "   SELECT DOC.FTXthDocType,DOC.FDXthDocDate,DOC.FTXthDocNo,USRL.FTUsrName 
                        FROM (
                            SELECT DISTINCT 'ใบรับโอน-สาขา' AS FTXthDocType,HD.FDXthDocDate,HD.FTXthDocNo,HD.FTCreateBy
                            FROM TCNTPdtTbiHD HD WITH(NOLOCK) 
                            INNER JOIN TCNTPdtTbiDT DT WITH(NOLOCK) ON HD.FTXthDocNo = DT.FTXthDocNo
                            ".$tDocDT."
                            WHERE HD.FTXthBchTo = '".$tBchCode."' AND HD.FTXthWhTo = '".$tWahCode."'
                                AND HD.FTXthStaDoc = '1' 
                                AND ISNULL(HD.FTXthStaApv,'') = ''
    
                            UNION ALL
                        
                            SELECT DISTINCT
                                CASE WHEN HD.FNXthDocType = 1 THEN 'ใบรับเข้า-คลังสินค้า' 
                                ELSE 'ใบรับโอน - คลังสินค้า' END AS FTXthDocType,
                                HD.FDXthDocDate,HD.FTXthDocNo,HD.FTCreateBy
                            FROM TCNTPdtTwiHD HD WITH(NOLOCK) 
                            INNER JOIN TCNTPdtTwiDT DT WITH(NOLOCK) ON HD.FTXthDocNo = DT.FTXthDocNo
                            ".$tDocDT."
                            WHERE HD.FTBchCode = '".$tBchCode."' AND HD.FTXthWhTo = '".$tWahCode."'
                                AND HD.FTXthStaDoc = '1' 
                                AND ISNULL(HD.FTXthStaApv,'') = ''
                        
                            UNION ALL
                        
                            SELECT DISTINCT 'ใบโอนสินค้าระหว่างคลัง'AS FTXthDocType,HD.FDXthDocDate,HD.FTXthDocNo,HD.FTCreateBy
                            FROM TCNTPdtTwxHD HD WITH(NOLOCK) 
                            INNER JOIN TCNTPdtTwxDT DT WITH(NOLOCK) ON HD.FTXthDocNo = DT.FTXthDocNo
                            ".$tDocDT."
                            WHERE HD.FTBchCode = '".$tBchCode."' AND HD.FTXthWhFrm = '".$tWahCode."'
                                AND HD.FTXthStaDoc = '1' 
                                AND ISNULL(HD.FTXthStaApv,'') = ''
                        
                            UNION ALL
                        
                            SELECT DISTINCT 'ใบตรวจนับ - ยืนยันสินค้าคงคลัง'AS FTXthDocType,HD.FDAjhDocDate AS FDXthDocDate,HD.FTAjhDocNo AS FTXthDocNo,HD.FTCreateBy
                            FROM TCNTPdtAdjStkHD HD WITH(NOLOCK) 
                            INNER JOIN TCNTPdtAdjStkDT DT WITH(NOLOCK) ON HD.FTAjhDocNo = DT.FTAjhDocNo
                            ".$tDocDT."
                            WHERE HD.FTAjhBchTo = '".$tBchCode."' AND HD.FTAjhWhTo = '".$tWahCode."'
                                AND HD.FTAjhStaDoc = '1' 
                                AND ISNULL(HD.FTAjhStaApv,'') = ''
                                AND HD.FTAjhDocType = '3'
    
                            UNION ALL
    
                            SELECT DISTINCT 'ใบเบิกออก - คลังสินค้า'AS FTXthDocType,HD.FDXthDocDate,HD.FTXthDocNo,HD.FTCreateBy
                            FROM TCNTPdtTwoHD HD WITH(NOLOCK) 
                            INNER JOIN TCNTPdtTwoDT DT WITH(NOLOCK) ON HD.FTXthDocNo = DT.FTXthDocNo
                            ".$tDocDT."
                            WHERE HD.FTBchCode = '".$tBchCode."' AND HD.FTXthWhFrm = '".$tWahCode."'
                                AND HD.FTXthStaDoc = '1' 
                                AND ISNULL(HD.FTXthStaApv,'') = ''
    
                            UNION ALL
    
                            SELECT DISTINCT 'ใบจ่ายโอน - สาขา'AS FTXthDocType,HD.FDXthDocDate,HD.FTXthDocNo,HD.FTCreateBy
                            FROM TCNTPdtTboHD HD WITH(NOLOCK) 
                            INNER JOIN TCNTPdtTboDT DT WITH(NOLOCK) ON HD.FTXthDocNo = DT.FTXthDocNo
                            ".$tDocDT."
                            WHERE HD.FTXthBchFrm = '".$tBchCode."' AND HD.FTXthWhFrm = '".$tWahCode."'
                                AND HD.FTXthStaDoc = '1' 
                                AND ISNULL(HD.FTXthStaApv,'') = ''
    
                            UNION ALL
    
                            SELECT DISTINCT 'ใบจ่ายโอน - คลังสินค้า'AS FTXthDocType,HD.FDXthDocDate,HD.FTXthDocNo,HD.FTCreateBy
                            FROM TCNTPdtTwoHD HD WITH(NOLOCK) 
                            INNER JOIN TCNTPdtTwoDT DT WITH(NOLOCK) ON HD.FTXthDocNo = DT.FTXthDocNo
                            ".$tDocDT."
                            WHERE HD.FTBchCode = '".$tBchCode."' AND HD.FTXthWhFrm = '".$tWahCode."'
                                AND HD.FTXthStaDoc = '1' 
                                AND ISNULL(HD.FTXthStaApv,'') = ''
                                AND HD.FNXthDocType = '4'
    
                            UNION ALL
    
                            SELECT DISTINCT 'ใบโอนสินค้าระหว่างสาขา'AS FTXthDocType,HD.FDXthDocDate,HD.FTXthDocNo,HD.FTCreateBy
                            FROM TCNTPdtTbxHD HD WITH(NOLOCK) 
                            INNER JOIN TCNTPdtTbxDT DT WITH(NOLOCK) ON HD.FTXthDocNo = DT.FTXthDocNo
                            ".$tDocDT."
                            WHERE HD.FTXthBchFrm = '".$tBchCode."' AND HD.FTXthWhFrm = '".$tWahCode."'
                                AND HD.FTXthStaDoc = '1' 
                                AND ISNULL(HD.FTXthStaApv,'') = ''
                        ) DOC
                        LEFT JOIN TCNMUser_L USRL WITH(NOLOCK) ON USRL.FTUsrCode = DOC.FTCreateBy AND USRL.FNLngID = ".$nLangEdit."
                        WHERE DOC.FTXthDocNo != '$tDocNo' ";
                        
    
            // TCNTPdtTbiHD ใบรับโอน - สาขา (อนุมัติสต๊อกปลายทางเพิ่ม)
            // TCNTPdtTwiHD FNXthDocType = 1 ใบรับเข้า - คลังสินค้า (อนุมัติสตีอกเพิ่ม)
            // TCNTPdtTwiHD FNXthDocType = 5 ใบรับโอน - คลังสินค้า (อนุมัติสต๊อกปลายทางเพิ่ม)
            // TCNTPdtTwxHD ใบโอนสินค้าระหว่างคลัง (อนุมัติสต๊อกปลายทางเพิ่ม)
            // TCNTPdtAdjStkHD FTAjhDocType = 3 ใบตรวจนับ - ยืนยันสินค้าคงคลัง (อนุมัติ ปรับปรุงสต๊อก)
            // TCNTPdtTwoHD FNXthDocType = 2 ใบเบิกออก - คลังสินค้า (อนุมัติ สต๊อกลด)
    
            // TCNTPdtTbxHD ใบโอนสินค้าระหว่างสาขา (อนุมัติสต๊อกปลายทางเพิ่ม) แต่ต้นทางต้องเป็นคนอนุมัติ ปลายทางไม่เห็นเอกสาร
            // TCNTPdtTwoHD FNXthDocType = 4 ใบจ่ายโอน - คลังสินค้า (อนุมัติสต๊อกปลายทางไม่เพิ่ม) ต้องไปทำใบรับโอน - คลังสินค้า
    
            $oQuery = $this->db->query($tSQL);
    
            if( $oQuery->num_rows() > 0 ){
                $aStatus = array(
                    'nCode'     => 1,
                    'tDesc'     => 'Found Document Pending Approve',
                    'aItems'    => $oQuery->result_array()
                );
            }else{
                $aStatus = array(
                    'nCode'     => 800,
                    'tDesc'     => 'Not Found Document Pending Approve',
                );
            }
            return $aStatus;
        }
    
        // Create By : Napat(Jame) 22/06/2022
        public function FCNaMGetNotEnoughQty($paParams){
            $tBchCode   = $paParams['tBchCode'];
            $tWahCode   = $paParams['tWahCode'];
            $tDocNo     = $paParams['tDocNo'];
            $tTableDT   = $paParams['tTableDT'];
            $nLangEdit  = $this->session->userdata("tLangEdit");
    
            $tSQL = "   SELECT 
                            DT.FTBchCode,
                            DT.FTWahCode,
                            DT.FTPdtCode,
                            PDTL.FTPdtName,
                            ISNULL(STK.FCStkQty,0) AS FCStkQty,
                            DT.FCDTQty,
                            (ISNULL(STK.FCStkQty,0) - ISNULL(DT.FCDTQty,0)) AS FCQtyDiff,
                            (ISNULL(STK.FCStkQty,0) - ISNULL(DT.FCDTQty,0)) * (-1) AS FCQtyDiff2
                        FROM (
                            SELECT
                                '".$tBchCode."' AS FTBchCode,
                                '".$tWahCode."' AS FTWahCode,
                                FTPdtCode,
                                SUM(FCXtdQtyAll) AS FCDTQty 
                            FROM ".$tTableDT." WITH(NOLOCK) 
                            WHERE FTXthDocNo = '".$tDocNo."' 
                            GROUP BY FTPdtCode
                        ) DT
                        LEFT JOIN TCNTPdtStkBal STK WITH(NOLOCK) ON STK.FTPdtCode = DT.FTPdtCode AND STK.FTBchCode = DT.FTBchCode AND STK.FTWahCode = DT.FTWahCode
                        LEFT JOIN TCNMPdt_L PDTL WITH(NOLOCK) ON DT.FTPdtCode = PDTL.FTPdtCode AND PDTL.FNLngID = ".$nLangEdit."
                        WHERE (ISNULL(STK.FCStkQty,0) - ISNULL(DT.FCDTQty,0)) < 0
                        ORDER BY DT.FTPdtCode ASC ";
            $oQuery = $this->db->query($tSQL);
    
            if( $oQuery->num_rows() > 0 ){
                $aStatus = array(
                    'nCode'     => 1,
                    'tDesc'     => 'พบสินค้าบางรายการ สต๊อกไม่เพียงพอ.',
                    'aItems'    => $oQuery->result_array()
                );
            }else{
                $aStatus = array(
                    'nCode'     => 800,
                    'tDesc'     => 'สินค้าทุกรายการ มีสต๊อก',
                );
            }
            return $aStatus;
        }
}