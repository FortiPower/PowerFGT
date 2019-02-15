#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#


$arrExcelValues = @() 
 
$objExcel = new-object -comobject excel.application  
$objExcel.Visible = $True  
$objWorkbook = $objExcel.Workbooks.Open(".\import.xlsx") 
$objWorksheet = $objWorkbook.Worksheets.Item(1) 
 
$ligne = 2 
$col = 1


while ($objWorksheet.Cells.Item($ligne,1).Value() -ne $null) {

$col = 1
$arrExcelValues = @() 

    Do { 
    $arrExcelValues += $objWorksheet.Cells.Item($ligne, $col).Value() 
    $col++ 

    } 
    While ($objWorksheet.Cells.Item(1,$col).Value() -ne $null) 


 
    $arrExcelValues


    Add-FGTPolicy -policyid $arrExcelValues[0] -name $arrExcelValues[1] -srcintf $arrExcelValues[2] -dstintf $arrExcelValues[3] -srcaddr $arrExcelValues[4] -dstaddr $arrExcelValues[5] -action $arrExcelValues[6] -status $arrExcelValues[7] -schedule $arrExcelValues[8] -service $arrExcelValues[9] -nat $arrExcelValues[10] 
     
    
$ligne++

}
 

$a = $objExcel.Quit
