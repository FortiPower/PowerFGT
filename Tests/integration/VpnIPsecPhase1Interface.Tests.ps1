#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get VPN Ipsec Phase 1 Interface" {

    BeforeAll {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -type static -interface port2 -proposal aes256-sha256 -psksecret MySecret -remotegw 192.0.2.1
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn2 -type dynamic -interface port2 -proposal aes256-sha256 -psksecret MySecret
    }

    It "Get VPN Ipsec Phase 1 interface does not throw an error" {
        {
            Get-FGTVpnIpsecPhase1Interface
        } | Should -Not -Throw
    }

    It "Get ALL VPN Ipsec Phase 1 interfaces" {
        $interface = Get-FGTVpnIpsecPhase1Interface
        $interface.count | Should -Not -Be $NULL
    }

    It "Get ALL VPN Ipsec Phase 1 interface with -skip" {
        $interface = Get-FGTVpnIpsecPhase1Interface -skip
        $interface.count | Should -Not -Be $NULL
    }

    It "Get VPN Ipsec Phase 1 interface ($pester_int1)" {
        $interface = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        $interface.name | Should -Be $pester_vpn1
    }

    It "Get VPN Ipsec Phase 1 interface ($pester_vpn1) and confirm (via Confirm-FGTVpnIpsecPhase1Interface)" {
        $interface = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        Confirm-FGTVpnIpsecPhase1Interface $interface | Should -Be $true
    }

    Context "Search" {

        It "Search VPN Ipsec Phase 1 interface by name ($pester_vpn1)" {
            $interface = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            @($interface).count | Should -be 1
            $interface.name | Should -Be $pester_vpn1
        }

    }

    AfterAll {
        Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
        Get-FGTVpnIpsecPhase1Interface -name $pester_vpn2 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
    }

}

<#
Describe "Add System Interface" {

    AfterEach {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
    }

    It "Add System Interface with only mandatory parameters" {
        Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
    }

    It "Add System Interface (All parameters...)" {
        Add-FGTSystemInterface -name $pester_int1 -alias Alias_$pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -allowaccess https, ping, ssh -status up -device_identification $true -mode static -ip 192.0.2.1 -netmask 255.255.255.0
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.alias | Should -Be "Alias_$pester_int1"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.allowaccess | Should -Be "ping https ssh"
        $interface.status | Should -Be "up"
        $interface."device-identification" | Should -Be "enable"
        $interface.mode | Should -Be "static"
        $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
    }

    It "Add System Interface (with alias)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -alias Alias_$pester_int1
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.alias | Should -Be "Alias_$pester_int1"
    }

    It "Add System Interface (with allowaccess https)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -allowaccess https
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.allowaccess | Should -Be "https"
    }

    It "Add System Interface (with allowaccess ssh)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -allowaccess ssh
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.allowaccess | Should -Be "ssh"
    }

    It "Add System Interface (with allowaccess https ssh)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -allowaccess https, ssh
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.allowaccess | Should -Be "https ssh"
    }

    It "Add System Interface (with status up)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -status up
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.status | Should -Be "up"
    }

    It "Add System Interface (with status down)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -status down
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.status | Should -Be "down"
    }

    It "Add System Interface (with role lan)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -role lan
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.role | Should -Be "lan"
    }

    It "Add System Interface (with role dmz)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -role dmz
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.role | Should -Be "dmz"
    }

    It "Add System Interface (with role wan)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -role wan
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.role | Should -Be "wan"
    }

    It "Add System Interface (with role undefined)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -role undefined
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.role | Should -Be "undefined"
    }

    It "Add System Interface (with device-identification enabled)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -device_identification $true
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface."device-identification" | Should -Be $true
    }

    It "Add System Interface (with device-identification disabled)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -device_identification $false
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface."device-identification" | Should -Be "disable"
    }

    It "Add System Interface (with mode static)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -mode static
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
    }

    It "Add System Interface (with mode dhcp)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -mode dhcp
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "dhcp"
    }

    It "Add System Interface (with IP Address and Netmask)" {
        Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -ip 192.0.2.1 -netmask 255.255.255.0
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
        $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
    }
}

Describe "Add System Interface Member" {

    BeforeEach {
        Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1
    }

    It "Add System Interface Member (HTTPS)" {
        Get-FGTSystemInterface -name $pester_int1 | Add-FGTSystemInterfaceMember -allowaccess https
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.allowaccess | Should -Be "https"
    }

    It "Add System Interface Member (SSH) with before HTTPS" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -allowaccess https
        Get-FGTSystemInterface -name $pester_int1 | Add-FGTSystemInterfaceMember -allowaccess ssh
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.allowaccess | Should -Be "https ssh"
    }

    AfterEach {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
    }
}

Describe "Set System Interface" {

    BeforeAll {
        Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1
    }

    It "Set System Interface alias" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -alias Set_$pester_int1
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.alias | Should -Be "Set_$pester_int1"
    }

    It "Set System Interface role" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -role dmz
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.role | Should -Be "dmz"
    }

    It "Set System Interface IP (and Netmask)" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -ip 192.0.2.1 -netmask 255.255.255.0
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
    }

    It "Set System Interface status (up)" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -status down
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.status | Should -Be "down"
    }

    It "Set System Interface status (down)" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -status up
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.status | Should -Be "up"
    }

    It "Set System Interface device-identification enabled" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -device_identification $true
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface."device-identification" | Should -Be "enable"
    }

    It "Set System Interface device-identification disabled" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -device_identification $false
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface."device-identification" | Should -Be "disable"
    }

    It "Set System Interface mode (DHCP)" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -mode dhcp
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.mode | Should -Be "dhcp"
    }

    It "Set System Interface Administrative Access (HTTPS, SSH)" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -allowaccess https, ssh
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.allowaccess | Should -Be "https ssh"
    }

    It "Set System Interface DHCP Relay" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -dhcprelayip "192.0.2.1", "192.0.2.2"
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.'dhcp-relay-ip' | Should -Be '"192.0.2.1" "192.0.2.2" '
        $interface.'dhcp-relay-service' | Should -Be "enable"
    }

    It "Set System Interface DHCP Relay then remove" {
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -dhcprelayip "192.0.2.1", "192.0.2.2"
        Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -dhcprelayip $null
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.'dhcp-relay-service' | Should -Be "disable"
    }

    AfterAll {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
    }
}

Describe "Remove System Interface" {

    BeforeEach {
        Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1
    }

    It "Remove System Interface by pipeline" {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -confirm:$false
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface | Should -Be $NULL
    }

}

Describe "Remove System Interface Member" {

    BeforeEach {
        Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1 -allowacces ssh, https
    }

    It "Remove System Interface Member (HTTPS)" {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterfaceMember -allowaccess https
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.allowaccess | Should -Be "ssh"
    }

    It "Remove System Interface Member (SSH and HTTPS)" {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterfaceMember -allowaccess ssh, https
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.allowaccess | Should -Be ""
    }

    AfterEach {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
    }
}
#>
AfterAll {
    Disconnect-FGT -confirm:$false
}