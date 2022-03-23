#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe  "Connect to a FortiGate (using HTTP)" {
    It "Connect to a FortiGate (using HTTP) and check global variable" {
        Connect-FGT $ipaddress -Username $login -password $mysecpassword -httpOnly -port $port
        $DefaultFGTConnection | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.server | Should -Be $ipaddress
        $DefaultFGTConnection.invokeParams | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.port | Should -Be $port
        $DefaultFGTConnection.httpOnly | Should -Be $true
        $DefaultFGTConnection.session | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.headers | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.version | Should -Not -BeNullOrEmpty
    }
    It "Disconnect to a FortiGate (using HTTP) and check global variable" {
        Disconnect-FGT -confirm:$false
        $DefaultFGTConnection | Should -Be $null
    }
    It "Connect to a FortiGate (using HTTP) with wrong password" {
        { Connect-FGT $ipaddress -Username $login -password $mywrongpassword -httpOnly -port $port } | Should -throw "Log in failure. Most likely an incorrect username/password combo"
    }
    #TODO: Connect using MFA (token) and/or need to change password (admin expiration)
    It "Connect to a Fortigate (using HTTP) with apiToken" -Skip:( -not ($apitoken -ne $null -and $httpOnly -eq $true -and $fgt_version -ge "7.0.0")) {
        Connect-FGT -Server $ipaddress -ApiToken $apitoken -port $port -httpOnly
        $DefaultFGTConnection | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.server | Should -Be $ipaddress
        $DefaultFGTConnection.invokeParams | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.port | Should -Be $port
        $DefaultFGTConnection.httpOnly | Should -Be $true
        $DefaultFGTConnection.session | Should -BeNullOrEmpty
        $DefaultFGTConnection.headers | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.version | Should -Not -BeNullOrEmpty
    }
}

Describe "Connect to a fortigate (using HTTPS)" {
    It "Connect to a FortiGate (using HTTPS and -SkipCertificateCheck) and check global variable" -Skip:($httpOnly) {
        Connect-FGT $ipaddress -Username $login -password $mysecpassword -SkipCertificateCheck -port $port
        $DefaultFGTConnection | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.server | Should -Be $ipaddress
        $DefaultFGTConnection.invokeParams | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.port | Should -Be $port
        $DefaultFGTConnection.httpOnly | Should -Be $false
        $DefaultFGTConnection.session | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.headers | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.version | Should -Not -BeNullOrEmpty
    }
    It "Disconnect to a FortiGate (using HTTPS) and check global variable" -Skip:($httpOnly) {
        Disconnect-FGT -confirm:$false
        $DefaultFGTConnection | Should -Be $null
    }
    #This test only work with PowerShell 6 / Core (-SkipCertificateCheck don't change global variable but only Invoke-WebRequest/RestMethod)
    #This test will be fail, if there is valid certificate...
    It "Connect to a FortiGate (using HTTPS) and check global variable" -Skip:("Desktop" -eq $PSEdition -Or $httpOnly) {
        { Connect-FGT $ipaddress -Username $login -password $mysecpassword } | Should throw "Unable to connect (certificate)"
    }

    It "Connect to a FortiGate (using HTTPS) with wrong password" -Skip:($httpOnly) {
        { Connect-FGT $ipaddress -Username $login -password $mywrongpassword -port $port } | Should -throw "Log in failure. Most likely an incorrect username/password combo"
    }

    It "Connect to a Fortigate (using HTTPS) with apiToken" -Skip:($apitoken -eq $null -Or $httpOnly) {
        Connect-FGT -Server $ipaddress -ApiToken $apitoken -port $port -SkipCertificateCheck
        $DefaultFGTConnection | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.server | Should -Be $ipaddress
        $DefaultFGTConnection.invokeParams | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.port | Should -Be $port
        $DefaultFGTConnection.httpOnly | Should -Be $false
        $DefaultFGTConnection.session | Should -BeNullOrEmpty
        $DefaultFGTConnection.headers | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.version | Should -Not -BeNullOrEmpty
    }
}

Describe "Connect to a FortiGate (with post-login-banner enable)" {
    BeforeAll {
        Connect-FGT @invokeParams

        #Enable post-login-banner (using FGTRestMethod because no yet  Set-FGTSystemSettings)
        Invoke-FGTRestMethod -method "PUT" -body @{ 'post-login-banner' = 'enable' } -uri "api/v2/cmdb/system/settings"

        Disconnect-FGT -confirm:$false
    }

    It "Connect to a FortiGate (with post-login-banner)" {
        $script:fgt = Connect-FGT @invokeParams -DefaultConnection:$false
        $fgt.session | Should -Not -BeNullOrEmpty
        $fgt.server | Should -Be $ipaddress
        $fgt.invokeParams | Should -Not -BeNullOrEmpty
        $fgt.port | Should -Be $port
        $fgt.httpOnly | Should -Be $true
        $fgt.session | Should -Not -BeNullOrEmpty
        $fgt.headers | Should -Not -BeNullOrEmpty
        $fgt.version | Should -Not -BeNullOrEmpty

        Disconnect-FGT -connection $fgt -confirm:$false
    }

    AfterAll {
        Connect-FGT @invokeParams

        #Disable post-login-banner (using FGTRestMethod because no yet  Set-FGTSystemSettings)
        Invoke-FGTRestMethod -method "PUT" -body @{ 'post-login-banner' = 'disable' } -uri "api/v2/cmdb/system/settings"

        Disconnect-FGT -confirm:$false
    }

}

Describe "Connect to a FortiGate (using multi connection)" {
    It "Connect to a FortiGate (using HTTPS and store on fgt variable)" {
        $script:fgt = Connect-FGT $ipaddress -Username $login -password $mysecpassword -httpOnly -SkipCertificate -DefaultConnection:$false -port $port
        $DefaultFGTConnection | Should -BeNullOrEmpty
        $fgt.session | Should -Not -BeNullOrEmpty
        $fgt.server | Should -Be $ipaddress
        $fgt.invokeParams | Should -Not -BeNullOrEmpty
        $fgt.port | Should -Be $port
        $fgt.httpOnly | Should -Be $true
        $fgt.session | Should -Not -BeNullOrEmpty
        $fgt.headers | Should -Not -BeNullOrEmpty
        $fgt.version | Should -Not -BeNullOrEmpty
    }

    It "Throw when try to use Invoke-FGTRestMethod and not connected" {
        { Invoke-FGTRestMethod -uri "api/v2/cmdb/firewall/address" } | Should -Throw "Not Connected. Connect to the Fortigate with Connect-FGT"
    }

    Context "Use Multi connection for call some (Get) cmdlet (Vlan, System...)" {
        It "Use Multi connection for call Get Firewall Address" {
            { Get-FGTFirewallAddress -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Address Group" {
            { Get-FGTFirewallAddressGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall IP Pool" {
            { Get-FGTFirewallIPPool -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Policy" {
            { Get-FGTFirewallPolicy -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Proxy Address" {
            { Get-FGTFirewallProxyAddress -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Proxy Address Group" {
            { Get-FGTFirewallProxyAddressGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Proxy Policy" {
            { Get-FGTFirewallProxyPolicy -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Service Custom" {
            { Get-FGTFirewallServiceCustom -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Service Group" {
            { Get-FGTFirewallServiceGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Virtual IP (VIP)" {
            { Get-FGTFirewallVip -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Log Traffic" {
            { Get-FGTLogTraffic -type memory -subtype local -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Router Policy" {
            { Get-FGTRouterPolicy -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Router Static" {
            { Get-FGTRouterStatic -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Admin(istrator)" {
            { Get-FGTSystemAdmin -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System DNS" {
            { Get-FGTSystemDns -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System DNS Server" {
            { Get-FGTSystemDnsServer -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Global" {
            { Get-FGTSystemGlobal -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System HA" {
            { Get-FGTSystemHA -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Interface" {
            { Get-FGTSystemInterface -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Vdom" {
            { Get-FGTSystemVdom -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System Virtual WAN Link (SD-WAN)" {
            { Get-FGTSystemVirtualWANLink -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System SD-WAN (> 6.4.0)" -skip:($fgt_version -lt "6.4.0") {
            { Get-FGTSystemSDWAN -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get System SD-WAN (< 6.4.0)" -skip:($fgt_version -ge "6.4.0") {
            { Get-FGTSystemSDWAN -connection $fgt } | Should -Throw "Please use Get-FGTSystemVirtualWANLink, SD-WAN is not available before FortiOS 6.4.x"
        }
        It "Use Multi connection for call Get System Zone " {
            { Get-FGTSystemZone -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get User Group" {
            { Get-FGTUserGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get User LDAP" {
            { Get-FGTUserLDAP -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get User Local" {
            { Get-FGTUserLocal -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get User RADIUS" {
            { Get-FGTUserRADIUS -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get VPN IPsec Phase 1 Interface" {
            { Get-FGTVpnIpsecPhase1Interface -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get VPN IPsec Phase 2 Interface" {
            { Get-FGTVpnIpsecPhase2Interface -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor System Config Backup" {
            { Get-FGTMonitorSystemConfigBackup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor System Firmware" {
            { Get-FGTMonitorSystemFirmware -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor License Status" {
            { Get-FGTMonitorLicenseStatus -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor VPN SSL" {
            { Get-FGTMonitorVpnSsl -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor VPN IPsec" {
            { Get-FGTMonitorVpnIPsec -connection $fgt } | Should -Not -Throw
        }
    }

    It "Disconnect to a FortiGate (Multi connection)" {
        Disconnect-FGT -connection $fgt -confirm:$false
        $DefaultFGTConnection | Should -Be $null
    }

    AfterAll {
        #Remove script scope variable
        Remove-Variable -name fgt -scope script
    }

}
