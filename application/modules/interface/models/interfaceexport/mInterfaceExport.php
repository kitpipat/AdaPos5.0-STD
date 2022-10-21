<?php
defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

class mInterfaceExport extends CI_Model {
    
    public function FSaMIFXGetHD($pnLang){
        $tSesUsrAgnCode = $this->session->userdata('tSesUsrAgnCode');
        $tSQL = "   SELECT 
                        API.FTApiCode,
                        API.FNApiGrpSeq,
                        API_L.FTApiName
                    FROM TCNMTxnAPI API WITH(NOLOCK) 
                    LEFT JOIN TCNMTxnAPI_L API_L ON API.FTApiCode = API_L.FTApiCode AND API_L.FNLngID = $pnLang ";
                    if($this->session->userdata('tSesUsrLevel')!='HQ'){
                    $tSQL .= " LEFT JOIN TCNMTxnSpcAPI SpcAPI WITH(NOLOCK)  ON API.FTApiCode = SpcAPI.FTApiCode ";
                }
        $tSQL .= "WHERE 1=1 
                    AND API.FTApiTxnType = '2' 
                    AND ISNULL(API_L.FTApiName,'') != '' ";
                    if($this->session->userdata('tSesUsrLevel')!='HQ'){
            $tSQL .= " AND ( SpcAPI.FTAgnCode = '$tSesUsrAgnCode' OR  SpcAPI.FTAgnCode IS NULL )";
                    }
            $tSQL .= "     ORDER BY API.FNApiGrpSeq ASC
                ";

        $oQuery     = $this->db->query($tSQL);
        $aResult    = $oQuery->result_array();
        return $aResult;
    }


    //Get Data TLKMConfig  
    public function FSaMINMGetDataConfig(){
    $tSQL = " SELECT
                CON.FTCfgCode,
                CASE WHEN CON.FTCfgStaUsrValue <> '' THEN
                CON.FTCfgStaUsrValue
                ELSE
                CON.FTCfgStaDefValue
                END AS FTCfgStaUsrValue,
                CONL.FTCfgName
                FROM
                    TLKMConfig CON WITH (NOLOCK)
                LEFT JOIN TLKMConfig_L CONL ON CON.FTCfgCode = CONL.FTCfgCode AND CONL.FNLngID = 1
                WHERE
                    CON.FTCfgKey = 'Noti'
                ORDER BY CAST(CON.FTCfgSeq as INT) ASC
             ";

        $oQuery     = $this->db->query($tSQL);

        $aResult    = $oQuery->result_array();
        return $aResult;
    }

        //19-11-2020 เนลว์เพิ่ม UNION การขายของ Vending
       //Get Data DocNo
       public function FSaMINMGetDataDocNo($ptDocNoFrom,$ptDocNoTo,$ptBchCode){
        // $tSQL = " SELECT  FTXshDocNo
        //             FROM TPSTSalHD WITH(NOLOCK)
        //             WHERE FTXshDocNo BETWEEN '$ptDocNoFrom' AND '$ptDocNoTo'
        //          ";

        $tSQL = "SELECT aData.*  FROM
                    ( SELECT
                        0 + ROW_NUMBER () OVER (ORDER BY FTXshDocNo ASC) AS rtRowID,
                        TPSTTaxHD.FTBchCode AS FTBchCode,
                        TPSTTaxHD.FTXshDocNo AS FTXshDocNo
                    FROM
                        TPSTTaxHD WITH (NOLOCK)
                    ) AS aData
                    WHERE 1=1
                    ";

            if($ptBchCode!=''){
                $tSQL .=" AND aData.FTBchCode = '$ptBchCode' ";
            }

            $tSQL .=" AND aData.FTXshDocNo BETWEEN '$ptDocNoFrom' AND '$ptDocNoTo' ";
    
            $oQuery     = $this->db->query($tSQL);
        
    
            $aResult    = $oQuery->result_array();
            return $aResult;
        }

        public function FSaMINMGetLogHisError(){

          $tSql ="SELECT
          LKH.FTLogTaskRef,
          SHD.FTBchCode
          
          FROM
          dbo.TLKTLogHis AS LKH
          LEFT OUTER JOIN TPSTTaxHD SHD ON LKH.FTLogTaskRef = SHD.FTXshDocNo
          WHERE
          LKH.FTLogType = 2 AND
          LKH.FTLogStaPrc = 2
          ";

          $oQuery     = $this->db->query($tSql);
    
          $aResult    = $oQuery->result_array();
          return $aResult;
        }
        // Nattakit Nale 25/11/2020
     //ยกบิลขายที่จะใช้ ไปในตาราง Temp ทำเพื่อเรียงลำดับบิลขายของท้ั้ง VD และ PS แสดงใน Brows
        public function FSxMIFXFillterBill($paData){


            $tSQLPSWhere=' WHERE 1=1 ';
            $tSQLVDWhere=' WHERE 1=1 ';

            if($paData['tFXBchCodeSale']!=''){
                $tFXBchCodeSale = $paData['tFXBchCodeSale'];
                 $tSQLPSWhere .=" AND TPSTTaxHD.FTBchCode = '$tFXBchCodeSale' ";
             }
   
            if($paData['tFXDateFromSale']!=''){
                $tFXDateFromSale = $paData['tFXDateFromSale'];
                 $tSQLPSWhere .=" AND CONVERT(VARCHAR(10),TPSTTaxHD.FDXshDocDate,121) >= '$tFXDateFromSale' ";
            }


            if($paData['tFXDateToSale']!=''){
                $tFXDateToSale = $paData['tFXDateToSale'];
                 $tSQLPSWhere .=" AND CONVERT(VARCHAR(10),TPSTTaxHD.FDXshDocDate,121) <= '$tFXDateToSale' ";
             }
            
             if($paData['nSeq']==2){
                $tSQLPSWhere .=" AND TPSTTaxHD.FNXshDocType = '4' ";
             }else{
                $tSQLPSWhere .=" AND TPSTTaxHD.FNXshDocType = '5' ";
             }

            $tSesUserCode = $this->session->userdata('tSesUserCode');

            $this->db->where('FTUsrCode',$tSesUserCode)->delete('TCNTBrsBillTmp');

            $tSQL = "INSERT INTO TCNTBrsBillTmp 
                                SELECT
                                    '$tSesUserCode' AS FTUsrCode,
                                    Document.*,
                                    GETDATE() AS FTCreateOn , 
                                    '$tSesUserCode' AS FTCreateBy
                                FROM
                                    (
                                        SELECT
                                            TPSTTaxHD.FTXshDocNo AS FTXshDocNo,
                                            TPSTTaxHD.FDXshDocDate AS FTXshDocDate
                                        FROM
                                            TPSTTaxHD WITH (NOLOCK)
                                            $tSQLPSWhere

                                    ) Document
                                ORDER BY
                                    Document.FTXshDocNo
                            ";
                // echo $tSQL;
                // die();
                $this->db->query($tSQL);

        }
   
                //Get Data TLKMConfig  
                public function FSaMIFXGetDataInterfaceConfig(){
                    $tSQL = " SELECT
                                CON.FTCfgCode,
                                CASE WHEN CON.FTCfgStaUsrValue <> '' THEN
                                CON.FTCfgStaUsrValue
                                ELSE
                                CON.FTCfgStaDefValue
                                END AS FTCfgStaUsrValue
                                FROM
                                    TLKMConfig CON WITH (NOLOCK)
                                WHERE
                                    CON.FTCfgKey = 'interface'
                                ORDER BY CAST(CON.FTCfgSeq as INT) ASC ";    //Type 1 นำเข้า
                        $oQuery     = $this->db->query($tSQL);
                        $aResult    = $oQuery->result_array();
                        return $aResult;
                }

                
}


