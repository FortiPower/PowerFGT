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

Describe "Get VPN Ipsec Phase 2 Interface" {

    BeforeAll {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -type static -interface port2 -proposal aes256-sha256 -psksecret MySecret -remotegw 192.0.2.1
        Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn2 -type dynamic -interface port2 -proposal aes256-sha256 -psksecret MySecret
        Get-FGTVpnIpsecPhase2Interface -name $pester_vpn2 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn2_ph2
    }

    It "Get VPN Ipsec Phase 2 interface does not throw an error" {
        {
            Get-FGTVpnIpsecPhase2Interface
        } | Should -Not -Throw
    }

    It "Get ALL VPN Ipsec Phase 2 interface(s)" {
        $interface = Get-FGTVpnIpsecPhase2Interface
        $interface.count | Should -Not -Be $NULL
    }

    It "Get ALL VPN Ipsec Phase 2 interface(s) with -skip" {
        $interface = Get-FGTVpnIpsecPhase2Interface -skip
        $interface.count | Should -Not -Be $NULL
    }

    It "Get VPN Ipsec Phase 2 interface ($pester_int1)" {
        $interface = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
        $interface.name | Should -Be $pester_vpn1_ph2
    }

    It "Get VPN Ipsec Phase 2 interface ($pester_vpn1_ph2) and confirm (via Confirm-FGTVpnIpsecPhase2Interface)" {
        $interface = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
        Confirm-FGTVpnIpsecPhase2Interface $interface | Should -Be $true
    }

    Context "Search" {

        It "Search VPN Ipsec Phase 2 interface by name ($pester_vpn1_ph2)" {
            $interface = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            @($interface).count | Should -be 1
            $interface.name | Should -Be $pester_vpn1_ph2
        }

    }

    AfterAll {
        Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 | Remove-FGTVpnIpsecPhase2Interface -Confirm:$false
        Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
        Get-FGTVpnIpsecPhase2Interface -name $pester_vpn2_ph2 | Remove-FGTVpnIpsecPhase2Interface -Confirm:$false
        Get-FGTVpnIpsecPhase1Interface -name $pester_vpn2 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}