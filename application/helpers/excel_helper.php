<?php

/*  Function : Delete Data All DocTemp
    create : 05-03-2019 Krit(Copter)
*/
include APPPATH . 'libraries/spout-3.1.0/src/Spout/Autoloader/autoload.php';
use Box\Spout\Common\Entity\Row;
use Box\Spout\Common\Entity\Style\Border;
use Box\Spout\Common\Entity\Style\CellAlignment;
use Box\Spout\Common\Entity\Style\Color;
use Box\Spout\Writer\Common\Creator\Style\BorderBuilder;
use Box\Spout\Writer\Common\Creator\Style\StyleBuilder;
use Box\Spout\Writer\Common\Creator\WriterEntityFactory;

// Functionality: ส่งออกแบบคิวรี่
// Parameters: array
// Creator: 22/06/2021 Nattakit (Nale) 
// Return: ข้อมูลสินค้าแบบ Array
// ReturnType: Object Array
function FCNxEXCExportByQuery($paParam){

    $ci = &get_instance();
    $ci->load->database();
    $tUserSesstionID = $ci->session->userdata("tSesSessionID");
    $tDateNow = date('Y-m-d');
    $tFileName = $paParam['tFileName'];
    $aHeader = $paParam['aHeader'];
    $tQuery = $paParam['tQuery'];
    
    $tFileName = $tFileName.'.xlsx';

    $aResult = FCNaEXCQueryResult($tQuery);

    $oWriter = WriterEntityFactory::createXLSXWriter();

    $oWriter->openToBrowser($tFileName); // stream data directly to the browser
    $oBorder = (new BorderBuilder())
    ->setBorderTop(Color::BLACK, Border::WIDTH_THIN)
    ->setBorderBottom(Color::BLACK, Border::WIDTH_THIN)
    ->setBorderLeft(Color::BLACK, Border::WIDTH_THIN)
    ->setBorderRight(Color::BLACK, Border::WIDTH_THIN)
    ->build();

    $oStyleColums = (new StyleBuilder())
        ->setBorder($oBorder)
        ->setFontBold()
        ->build();


    if(!empty($aResult)){//Create Rows with Cells

        if(!empty($aHeader)){
            $aHeaderName =   $aHeader;
        }else{
            $aHeaderName = FCNaEXCCreateHeader($aResult[0]);
        }
            $aMultiRows[] = WriterEntityFactory::createRowFromArray($aHeaderName, $oStyleColums);

        foreach($aResult as $aRows){
                    $aMultiRows[] = WriterEntityFactory::createRowFromArray($aRows, $oStyleColums);
        }
    }

    $oWriter->addRows($aMultiRows);
    $oWriter->close();
}

    // Functionality: ส่งออกแบบตาราง
    // Parameters: array
    // Creator: 22/06/2021 Nattakit (Nale) 
    // Return: ข้อมูลสินค้าแบบ Array
    // ReturnType: Object Array
function FCNxEXCExportByTable($paParam){

    $ci = &get_instance();
    $ci->load->database();
    $tUserSesstionID = $ci->session->userdata("tSesSessionID");
    $tDateNow = date('Y-m-d');
    $tFileName = $paParam['tFileName'];
    $aHeader = $paParam['aHeader'];
    $tQuery = "SELECT * FROM ".$paParam['tTable'];
    
    $tFileName = $tFileName.'.xlsx';

    $aResult = FCNaEXCQueryResult($tQuery);

    $oWriter = WriterEntityFactory::createXLSXWriter();

    $oWriter->openToBrowser($tFileName); // stream data directly to the browser
    $oBorder = (new BorderBuilder())
    ->setBorderTop(Color::BLACK, Border::WIDTH_THIN)
    ->setBorderBottom(Color::BLACK, Border::WIDTH_THIN)
    ->setBorderLeft(Color::BLACK, Border::WIDTH_THIN)
    ->setBorderRight(Color::BLACK, Border::WIDTH_THIN)
    ->build();

    $oStyleColums = (new StyleBuilder())
        ->setBorder($oBorder)
        ->setFontBold()
        ->build();


    if(!empty($aResult)){//Create Rows with Cells

        if(!empty($aHeader)){
            $aHeaderName =   $aHeader;
        }else{
            $aHeaderName = FCNaEXCCreateHeader($aResult[0]);
        }
            $aMultiRows[] = WriterEntityFactory::createRowFromArray($aHeaderName, $oStyleColums);

        foreach($aResult as $aRows){
                    $aMultiRows[] = WriterEntityFactory::createRowFromArray($aRows, $oStyleColums);
        }
    }

    $oWriter->addRows($aMultiRows);
    $oWriter->close();
}


    // Functionality: ส่งออกแบบอาเรย์
    // Parameters: array
    // Creator: 22/06/2021 Nattakit (Nale) 
    // Return: ข้อมูลสินค้าแบบ Array
    // ReturnType: Object Array
function FCNxEXCExportByArray($paParam){

    $ci = &get_instance();
    $ci->load->database();
    $tUserSesstionID = $ci->session->userdata("tSesSessionID");
    $tDateNow = date('Y-m-d');
    $tFileName = $paParam['tFileName'];
    $aHeader = $paParam['aHeader'];
    $aResult = $paParam['aDataArray'];
    
    $tFileName = $tFileName.'.xlsx';

    $oWriter = WriterEntityFactory::createXLSXWriter();

    $oWriter->openToBrowser($tFileName); // stream data directly to the browser
    $oBorder = (new BorderBuilder())
    ->setBorderTop(Color::BLACK, Border::WIDTH_THIN)
    ->setBorderBottom(Color::BLACK, Border::WIDTH_THIN)
    ->setBorderLeft(Color::BLACK, Border::WIDTH_THIN)
    ->setBorderRight(Color::BLACK, Border::WIDTH_THIN)
    ->build();

    $oStyleColums = (new StyleBuilder())
        ->setBorder($oBorder)
        ->setFontBold()
        ->build();


    if(!empty($aResult)){//Create Rows with Cells

        if(!empty($aHeader)){
            $aHeaderName =   $aHeader;
        }else{
            $aHeaderName = FCNaEXCCreateHeader($aResult[0]);
        }
            $aMultiRows[] = WriterEntityFactory::createRowFromArray($aHeaderName, $oStyleColums);

        foreach($aResult as $aRows){
                    $aMultiRows[] = WriterEntityFactory::createRowFromArray($aRows, $oStyleColums);
        }
    }

    $oWriter->addRows($aMultiRows);
    $oWriter->close();
}

    // Functionality: ส่งออกแบบอาเรย์
    // Parameters: array
    // Creator: 22/06/2021 Nattakit (Nale) 
    // Return: ข้อมูลสินค้าแบบ Array
    // ReturnType: Object Array
function FCNaEXCQueryResult($ptQuery){
    $ci = &get_instance();
    $ci->load->database();

        if($ptQuery){
            $oQuery = $ci->db->query($ptQuery);
            $aResult = $oQuery->result_array();
        }else{
            $aResult = array();
        }
        return $aResult;
}
    // Functionality: ส่งออกแบบอาเรย์
    // Parameters: array
    // Creator: 22/06/2021 Nattakit (Nale) 
    // Return: ข้อมูลสินค้าแบบ Array
    // ReturnType: Object Array
function FCNaEXCCreateHeader($paRows){
    $aCellsHeader = array();
    if(!empty($paRows)){
        foreach($paRows as $tKey => $aCells){
            $aCellsHeader[] = $tKey;
        }
    }
    return $aCellsHeader;
}

