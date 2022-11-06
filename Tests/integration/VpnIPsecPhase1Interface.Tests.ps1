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


Describe "Add VPN Ipsec Phase 1 Interface" {

    AfterEach {
        Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
    }

    It "Add VPN Ipsec Phase 1 Interface with only mandatory parameters" {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -type static -psksecret MySecret -remotegw 192.0.2.1
        $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        $vpn.name | Should -Be $pester_vpn1
        $vpn.type | Should -Be "static"
        $vpn.psksecret | Should -Not -BeNullOrEmpty
        $vpn.'remote-gw' | Should -Be "192.0.2.1"
        $vpn.proposal | Should -Not -BeNullOrEmpty
        $vpn.'net-device' | Should -Be "disable"
        $vpn.'add-route' | Should -Be "enable"
        $vpn.'auto-discovery-sender' | Should -Be "disable"
        $vpn.'auto-discovery-receiver' | Should -Be "disable"
        $vpn.'exchange-interface-ip' | Should -Be "disable"
    }

    It "Add VPN Ipsec Phase 1 Interface with 1 proposal (des-md5)" {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -type static -psksecret MySecret -remotegw 192.0.2.1 -proposal des-md5
        $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        $vpn.name | Should -Be $pester_vpn1
        $vpn.type | Should -Be "static"
        $vpn.psksecret | Should -Not -BeNullOrEmpty
        $vpn.'remote-gw' | Should -Be "192.0.2.1"
        $vpn.proposal | Should -Be "des-md5"
    }

    It "Add VPN Ipsec Phase 1 Interface with 1 proposal (des-sha1)" {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -type static -psksecret MySecret -remotegw 192.0.2.1 -proposal des-sha1
        $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        $vpn.name | Should -Be $pester_vpn1
        $vpn.type | Should -Be "static"
        $vpn.psksecret | Should -Not -BeNullOrEmpty
        $vpn.'remote-gw' | Should -Be "192.0.2.1"
        $vpn.proposal | Should -Be "des-sha1"
    }

    It "Add VPN Ipsec Phase 1 Interface with 2 proposals (des-md5, des-sha1)" {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -type static -psksecret MySecret -remotegw 192.0.2.1 -proposal des-md5, des-sha1
        $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        $vpn.name | Should -Be $pester_vpn1
        $vpn.type | Should -Be "static"
        $vpn.psksecret | Should -Not -BeNullOrEmpty
        $vpn.'remote-gw' | Should -Be "192.0.2.1"
        $vpn.proposal | Should -Be "des-md5 des-sha1"
    }

    It "Add VPN Ipsec Phase 1 Interface with 1 DH Group (1)" {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -type static -psksecret MySecret -remotegw 192.0.2.1 -dhgrp 1
        $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        $vpn.name | Should -Be $pester_vpn1
        $vpn.type | Should -Be "static"
        $vpn.proposal | Should -Not -BeNullOrEmpty
        $vpn.psksecret | Should -Not -BeNullOrEmpty
        $vpn.'remote-gw' | Should -Be "192.0.2.1"
        $vpn.dhgrp | Should -Be "1"
    }

    It "Add VPN Ipsec Phase 1 Interface with 1 DH Group (2)" {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -type static -psksecret MySecret -remotegw 192.0.2.1 -dhgrp 2
        $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        $vpn.name | Should -Be $pester_vpn1
        $vpn.type | Should -Be "static"
        $vpn.proposal | Should -Not -BeNullOrEmpty
        $vpn.psksecret | Should -Not -BeNullOrEmpty
        $vpn.'remote-gw' | Should -Be "192.0.2.1"
        $vpn.dhgrp | Should -Be "2"
    }

    It "Add VPN Ipsec Phase 1 Interface with 2 DH Group (1, 2)" {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -type static -psksecret MySecret -remotegw 192.0.2.1 -dhgrp 1, 2
        $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        $vpn.name | Should -Be $pester_vpn1
        $vpn.type | Should -Be "static"
        $vpn.proposal | Should -Not -BeNullOrEmpty
        $vpn.psksecret | Should -Not -BeNullOrEmpty
        $vpn.'remote-gw' | Should -Be "192.0.2.1"
        $vpn.dhgrp | Should -Be "1 2"
    }
}

Describe "Remove VPN Ipsec Phase 1 Interface" {

    BeforeEach {
        Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -type static -psksecret MySecret -remotegw 192.0.2.1
    }

    It "Remove System Interface by pipeline" {
        Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
        $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
        $vpn | Should -Be $NULL
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}