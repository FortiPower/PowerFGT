function Get-FGTInterface {

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$SimpleView 
         )
    
    if ($SimpleView -eq $False) {
            $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/interface' -method 'GET'
            $reponse.results
    } else {
    
            $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/interface' -method 'GET'
            $reponse.results | select status, name, alias, role, ip, mode, type, allowaccess, macaddr | ft
    }

    
}