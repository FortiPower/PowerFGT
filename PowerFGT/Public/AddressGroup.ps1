

function Get-FGTAddrgrp {
    
    Param(
        [Parameter(Mandatory = $false)]
        [switch]$SimpleView 
         )
    
    if ($SimpleView -eq $False) {
        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/addrgrp' -method 'GET'
        $reponse.results
    } else { 
        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/addrgrp' -method 'GET'
        $reponse.results | ft
    }


    }