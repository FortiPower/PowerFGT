

function Get-FGTInterface {

  <#
      .SYNOPSIS
      Get list of all interfaces

      .DESCRIPTION
      Get list of all interface

      .EXAMPLE
      Get-FGTInterface

      Get list of all interface

  #>


        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/interface' -method 'GET'
        $reponse.results
   }
