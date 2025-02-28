#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe  "Connect to a FortiGate (using HTTP)" {
    It "Connect to a FortiGate (using HTTP) and check global variable" -Skip:( -not $httpOnly ) {
        Connect-FGT $ipaddress -Username $login -password $mysecpassword -httpOnly -port $port
        $DefaultFGTConnection | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.server | Should -Be $ipaddress
        $DefaultFGTConnection.invokeParams | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.port | Should -Be $port
        $DefaultFGTConnection.httpOnly | Should -Be $true
        $DefaultFGTConnection.session | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.headers | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.version | Should -Not -BeNullOrEmpty
        $DefaultFGTConnection.serial | Should -Not -BeNullOrEmpty
    }
    It "Disconnect to a FortiGate (using HTTP) and check global variable" -Skip:( -not $httpOnly ) {
        Disconnect-FGT -confirm:$false
        $DefaultFGTConnection | Should -Be $null
    }
    It "Connect to a FortiGate (using HTTP) with wrong password" -Skip:( -not $httpOnly ) {
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
        $DefaultFGTConnection.serial | Should -Not -BeNullOrEmpty
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
        $DefaultFGTConnection.serial | Should -Not -BeNullOrEmpty
    }
    It "Disconnect to a FortiGate (using HTTPS) and check global variable" -Skip:($httpOnly) {
        Disconnect-FGT -confirm:$false
        $DefaultFGTConnection | Should -Be $null
    }
    #This test only work with PowerShell 6 / Core (-SkipCertificateCheck don't change global variable but only Invoke-WebRequest/RestMethod)
    #This test will be fail, if there is valid certificate...
    It "Connect to a FortiGate (using HTTPS) and check global variable" -Skip:("Desktop" -eq $PSEdition -Or $httpOnly) {
        { Connect-FGT $ipaddress -Username $login -password $mysecpassword } | Should -throw "Unable to connect (certificate)"
    }

    It "Connect to a FortiGate (using HTTPS) with wrong password" -Skip:($httpOnly) {
        { Connect-FGT $ipaddress -Username $login -password $mywrongpassword -port $port -SkipCertificateCheck:$SkipCertificateCheck } | Should -throw "Log in failure. Most likely an incorrect username/password combo"
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
        $DefaultFGTConnection.serial | Should -Not -BeNullOrEmpty
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
        #$fgt.invokeParams.SkipCertificateCheck | Should -Be $invokeParams.SkipCertificateCheck
        $fgt.port | Should -Be $port
        $fgt.httpOnly | Should -Be $invokeParams.httpOnly
        $fgt.session | Should -Not -BeNullOrEmpty
        $fgt.headers | Should -Not -BeNullOrEmpty
        $fgt.version | Should -Not -BeNullOrEmpty
        $fgt.serial | Should -Not -BeNullOrEmpty

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
        $script:fgt = Connect-FGT @invokeParams -DefaultConnection:$false
        $DefaultFGTConnection | Should -BeNullOrEmpty
        $fgt.session | Should -Not -BeNullOrEmpty
        $fgt.server | Should -Be $ipaddress
        $fgt.invokeParams | Should -Not -BeNullOrEmpty
        #$fgt.invokeParams.SkipCertificateCheck | Should -Be $invokeParams.SkipCertificateCheck
        $fgt.port | Should -Be $port
        $fgt.httpOnly | Should -Be $invokeParams.httpOnly
        $fgt.session | Should -Not -BeNullOrEmpty
        $fgt.headers | Should -Not -BeNullOrEmpty
        $fgt.version | Should -Not -BeNullOrEmpty
        $fgt.serial | Should -Not -BeNullOrEmpty
    }

    It "Throw when try to use Invoke-FGTRestMethod and not connected" {
        { Invoke-FGTRestMethod -uri "api/v2/cmdb/firewall/address" } | Should -Throw "Not Connected. Connect to the Fortigate with Connect-FGT"
    }

    Context "Use Multi connection for call some (Get) cmdlet (Vlan, System...)" {
        It "Use Multi connection for call Get Application List" {
            { Get-FGTApplicationList -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Antivirus Profile" {
            { Get-FGTAntivirusProfile -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get DNS Filter Profile" {
            { Get-FGTDnsfilterProfile -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get IPS Sensor" {
            { Get-FGTIpsSensor -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Address" {
            { Get-FGTFirewallAddress -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Address Group" {
            { Get-FGTFirewallAddressGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall IP Pool" {
            { Get-FGTFirewallIPPool -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Internet Service Name (ISDB)" {
            { Get-FGTFirewallInternetServiceName -connection $fgt } | Should -Not -Throw
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
        It "Use Multi connection for call Get Firewall SSL SSH Profile" {
            { Get-FGTFirewallSSLSSHProfile -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Firewall Virtual IP (VIP)" {
            { Get-FGTFirewallVip -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Log Traffic" {
            { Get-FGTLogTraffic -type memory -subtype local -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Log Settings" {
            { Get-FGTLogSetting -type syslogd -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Router BGP" {
            { Get-FGTRouterBGP -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Router OSPF" {
            { Get-FGTRouterOSPF -connection $fgt } | Should -Not -Throw
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
        It "Use Multi connection for call Get System DHCP Server" {
            { Get-FGTSystemDHCPServer -connection $fgt } | Should -Not -Throw
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
        #Diasble because get 400 error with VM... (or when no System Virtual Switch) => All Release
        #It "Use Multi connection for call Get System Virtual Switch" {
        #    { Get-FGTSystemVirtualSwitch -connection $fgt } | Should -Not -Throw
        #}
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
        It "Use Multi connection for call Get User SAML (> 6.2.0)" -skip:($fgt_version -lt "6.2.0") {
            { Get-FGTUserSAML -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get User SAML (< 6.2.0)" -skip:($fgt_version -ge "6.2.0") {
            { Get-FGTUserSAML -connection $fgt } | Should -Throw "You can't get User SAML with FortiOS < 6.2.0"
        }
        It "Use Multi connection for call Get VPN IPsec Phase 1 Interface" {
            { Get-FGTVpnIpsecPhase1Interface -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get VPN IPsec Phase 2 Interface" {
            { Get-FGTVpnIpsecPhase2Interface -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get VPN SSL Client (> 7.0.0)" -skip:($fgt_version -lt "7.0.0") {
            { Get-FGTVpnSSLClient -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get VPN SSL Client (< 7.0.0)" -skip:($fgt_version -ge "7.0.0") {
            { Get-FGTVpnSSLClient -connection $fgt } | Should -Throw "VPN SSL Client is not available before FortiOS 7.0.x"
        }
        It "Use Multi connection for call Get VPN SSL Portal" {
            { Get-FGTVpnSSLPortal -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get VPN SSL Settings" {
            { Get-FGTVpnSSLSettings -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Webfilter Profile" {
            { Get-FGTWebfilterProfile -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Firewall Address Dynamic" {
            { Get-FGTMonitorFirewallAddressDynamic -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Firewall Address FQDN" {
            { Get-FGTMonitorFirewallAddressFQDN -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Firewall Policy" {
            { Get-FGTMonitorFirewallPolicy -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Firewall Session" {
            { Get-FGTMonitorFirewallSession -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Router BGP Neighbors (> 7.0.0)" -skip:($fgt_version -lt "7.0.0") {
            { Get-FGTMonitorRouterBGPNeighbors -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Router BGP Neighbors (< 7.0.0)" -skip:($fgt_version -ge "7.0.0") {
            { Get-FGTMonitorRouterBGPNeighbors -connection $fgt } | Should -Throw "Monitor Router BGP Neighbors is not available before FortiOS 7.0.x"
        }
        It "Use Multi connection for call Get Monitor Router IPv4" {
            { Get-FGTMonitorRouterIPv4 -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Router OSPF Neighbors (> 7.0.0)" -skip:($fgt_version -lt "7.0.0") {
            { Get-FGTMonitorRouterOSPFNeighbors -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Router OSPF Neighbors (< 7.0.0)" -skip:($fgt_version -ge "7.0.0") {
            { Get-FGTMonitorRouterOSPFNeighbors -connection $fgt } | Should -Throw "Monitor Router OSPF Neighbors is not available before FortiOS 7.0.x"
        }
        It "Use Multi connection for call Get Monitor System Config Backup" {
            { Get-FGTMonitorSystemConfigBackup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor System DHCP" {
            { Get-FGTMonitorSystemDHCP -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor System Firmware" {
            { Get-FGTMonitorSystemFirmware -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor System Interface" {
            { Get-FGTMonitorSystemInterface -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor System HA Peer (>= 6.2.0 or < 6.2.0 with HA enable)" -skip:($VersionIs60WithNoHA) {
            { Get-FGTMonitorSystemHAPeer -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor System HA Peer (< 6.2.0 with no HA)" -skip:( -Not $VersionIs60WithNoHA) {
            { Get-FGTMonitorSystemHAPeer -connection $fgt } | Should -Throw "You can't check HA Peer with FortiOS < 6.2.0"
        }
        It "Use Multi connection for call Get Monitor System HA Checksum (>= 6.2.0 or < 6.2.0 with HA enable)" -skip:( $VersionIs60WithNoHA) {
            { Get-FGTMonitorSystemHAChecksum -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor System HA Checksum (< 6.2.0 with no HA)" -skip:( -Not $VersionIs60WithNoHA) {
            { Get-FGTMonitorSystemHAChecksum -connection $fgt } | Should -Throw "You can't check HA Checksum with FortiOS < 6.2.0"
        }
        It "Use Multi connection for call Get Monitor System Interface DHCP Status" {
            { Get-FGTMonitorSystemInterfaceDHCPStatus -interface $pester_port1 -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor License Status" {
            { Get-FGTMonitorLicenseStatus -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Network ARP (> 6.4.0)" -skip:($fgt_version -lt "6.4.0") {
            { Get-FGTMonitorNetworkARP -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Network ARP (< 6.4.0)" -skip:($fgt_version -ge "6.4.0") {
            { Get-FGTMonitorNetworkARP -connection $fgt } | Should -Throw "Monitor Network ARP is not available before Forti OS 6.4"
        }
        It "Use Multi connection for call Get Monitor User Fortitoken" {
            { Get-FGTMonitorUserFortitoken -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor UTM Application Categories" {
            { Get-FGTMonitorUtmApplicationCategories -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor VPN SSL" {
            { Get-FGTMonitorVpnSsl -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor VPN IPsec" {
            { Get-FGTMonitorVpnIPsec -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Monitor Webfilter Categories" {
            { Get-FGTMonitorWebfilterCategories -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch Global" {
            { Get-FGTSwitchGlobal -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch Fortilink Settings (> 7.0.0)" -skip:($fgt_version -lt "7.0.0") {
            { Get-FGTSwitchFortilinkSettings -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch Fortilink Settings (< 7.0.0)" -skip:($fgt_version -ge "7.0.0") {
            { Get-FGTSwitchFortilinkSettings -connection $fgt } | Should -Throw "Switch Fortilink Settings is not available before Forti OS 7.0"
        }
        It "Use Multi connection for call Get Switch Group" {
            { Get-FGTSwitchGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch LLDP Profile" {
            { Get-FGTSwitchLLDPProfile -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch LLDP Settingse" {
            { Get-FGTSwitchLLDPSettings -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch Managed Switch" {
            { Get-FGTSwitchManagedSwitch -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch SNMP Community (>= 6.2.0)" -skip:($fgt_version -lt "6.2.0") {
            { Get-FGTSwitchSNMPCommunity -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch SNMP Community(< 6.4.0)" -skip:($fgt_version -ge "6.4.0") {
            { Get-FGTSwitchSNMPCommunity -connection $fgt } | Should -Throw "Switch SNMP Community is not available before Forti OS 6.2"
        }
        It "Use Multi connection for call Get Switch STP Instance (>= 6.2.0)" -skip:($fgt_version -lt "6.2.0") {
            { Get-FGTSwitchSTPInstance -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch STP Instance (< 6.2.0)" -skip:($fgt_version -ge "6.2.0") {
            { Get-FGTSwitchSTPInstance -connection $fgt } | Should -Throw "Switch SNMP Community is not available before Forti OS 6.2"
        }
        It "Use Multi connection for call Get Switch STP Settings" {
            { Get-FGTSwitchSTPSettings -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch System" {
            { Get-FGTSwitchSystem -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch Profile" {
            { Get-FGTSwitchProfile -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch Vlan Policy (>= 6.4.0)" -skip:($fgt_version -lt "6.4.0") {
            { Get-FGTSwitchVlanPolicy -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Switch Vlan Policy (< 6.4.0)" -skip:($fgt_version -ge "6.4.0") {
            { Get-FGTSwitchVlanPolicy -connection $fgt } | Should -Throw "Switch Vlan Policy is not available before Forti OS 6.4"
        }
        It "Use Multi connection for call Get Wireless Global" {
            { Get-FGTWirelessGlobal -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Wireless Setting" {
            { Get-FGTWirelessSetting -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Wireless SSID Policy (> 7.0.0)" -skip:($fgt_version -lt "7.0.0") {
            { Get-FGTWirelessSSIDPolicy -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Wireless SSID Policy (< 7.0.0)" -skip:($fgt_version -ge "7.0.0") {
            { Get-FGTWirelessSSIDPolicy -connection $fgt } | Should -Throw "Wireless SSID Policy is not available before Forti OS 7.0"
        }
        It "Use Multi connection for call Get Wireless VAP (Virtual AP Profile)" {
            { Get-FGTWirelessVAP -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Wireless VAP (Virtual AP Profile) Group" {
            { Get-FGTWirelessVAPGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Wireless WAG (Wireless Access Gateway) Profile (> 6.2.0)" -skip:($fgt_version -lt "6.2.0") {
            { Get-FGTWirelessWAGProfile -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Wireless WAG (Wireless Access Gateway) Profile (< 6.2.0)" -skip:($fgt_version -ge "6.2.0") {
            { Get-FGTWirelessWAGProfile -connection $fgt } | Should  -Throw "Wireless WAG (Wireless Access Gateway is not available before Forti OS 6.2"
        }
        It "Use Multi connection for call Get Wireless WTP (Wireless Termination Points)" {
            { Get-FGTWirelessWTP -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Wireless WTP (Wireless Termination Points) Group" {
            { Get-FGTWirelessWTPGroup -connection $fgt } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Wireless WTP (Wireless Termination Points) Profile" {
            { Get-FGTWirelessWTPProfile -connection $fgt } | Should -Not -Throw
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
