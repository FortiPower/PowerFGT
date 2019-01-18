

function Get-FGTStaticRoute {
    
    Param(
        [Parameter(Mandatory = $false)]
        [switch]$SimpleView 
         )
    
    if ($SimpleView -eq $False) {
        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/static' -method 'GET'
        $reponse.results
    } else { 
        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/static' -method 'GET'
        $reponse.results | ft
    }


    }