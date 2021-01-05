#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Public_cmdb = @( Get-ChildItem -Path $PSScriptRoot\Public\cmdb\*.ps1 -ErrorAction SilentlyContinue )
$Public_cmdb_firewall = @( Get-ChildItem -Path $PSScriptRoot\Public\cmdb\firewall\*.ps1 -ErrorAction SilentlyContinue )
$Public_cmdb_firewall_proxy = @( Get-ChildItem -Path $PSScriptRoot\Public\cmdb\firewall\proxy\*.ps1 -ErrorAction SilentlyContinue )
$Public_cmdb_firewall_service = @( Get-ChildItem -Path $PSScriptRoot\Public\cmdb\firewall\service\*.ps1 -ErrorAction SilentlyContinue )
$Public_cmdb_system = @( Get-ChildItem -Path $PSScriptRoot\Public\cmdb\system\*.ps1 -ErrorAction SilentlyContinue )
$Public_cmdb_user = @( Get-ChildItem -Path $PSScriptRoot\Public\cmdb\user\*.ps1 -ErrorAction SilentlyContinue )
$Public_cmdb_router = @( Get-ChildItem -Path $PSScriptRoot\Public\cmdb\router\*.ps1 -ErrorAction SilentlyContinue )
$Public_cmdb_vpnipsec = @( Get-ChildItem -Path $PSScriptRoot\Public\cmdb\vpn\ipsec\*.ps1 -ErrorAction SilentlyContinue )
$Public_monitor = @( Get-ChildItem -Path $PSScriptRoot\Public\cmdb\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach ($import in @($Public + $Public_cmdb + $Public_cmdb_firewall + $Public_cmdb_firewall_proxy + $Public_cmdb_firewall_service + $Public_cmdb_system + $Public_cmdb_user + $Public_cmdb_router + $Public_cmdb_vpnipsec + $Public_monitor + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Here I might...
# Read in or create an initial config file and variable
# Export Public functions ($Public.BaseName) for WIP modules
# Set variables visible to the module and its functions only

#Export-ModuleMember -Function $Public.Basename