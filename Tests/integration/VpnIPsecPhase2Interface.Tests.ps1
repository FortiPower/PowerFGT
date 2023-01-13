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
        @($interface).count | Should -Not -Be $NULL
    }

    It "Get ALL VPN Ipsec Phase 2 interface(s) with -skip" {
        $interface = Get-FGTVpnIpsecPhase2Interface -skip
        @($interface).count | Should -Not -Be $NULL
    }

    It "Get VPN Ipsec Phase 2 interface ($pester_vpn1_ph2)" {
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

$type = @(
    @{ "type" = "IKEv1 Static"; "param" = @{ "ikeversion" = 1; "type" = "static"; "remotegw" = "192.0.2.1" } }
    @{ "type" = "IKEv1 Dynamic"; "param" = @{ "ikeversion" = 1; "type" = "dynamic" } }
    @{ "type" = "IKEv2 Static"; "param" = @{ "ikeversion" = 2; "type" = "static" ; "remotegw" = "192.0.2.1" } }
    @{ "type" = "IKEv2 Dynamic"; "param" = @{ "ikeversion" = 2; "type" = "dynamic" } }
)

Describe "Add VPN Ipsec Phase 2 Interface" -ForEach $type {

    Context "Interface $($_.type)" {
        BeforeAll {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
            Add-FGTFirewallAddress -Name $pester_address2 -ip 192.51.0.0 -mask 255.255.255.0
        }
        AfterEach {
            Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 | Remove-FGTVpnIpsecPhase2Interface -Confirm:$false
        }

        It "Add VPN Ipsec Phase 2 Interface with only mandatory parameters (name)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.pfs | Should -Be "enable"
            $vpn.dhgrp | Should -Not -BeNullOrEmpty
            $vpn.replay | Should -Be "enable"
            $vpn.keepalive | Should -Be "disable"
            $vpn.'auto-negotiate' | Should -Be "disable"
            $vpn.keylifeseconds | Should -Be "43200"
            $vpn.keylifekbs | Should -Be "5120"
            $vpn.'keylife-type' | Should -Be "seconds"
            $vpn.encapsulation | Should -Be "tunnel-mode"
            $vpn.comments | Should -Be ""
            $vpn.protocol | Should -Be "0"
            $vpn.'src-name' | Should -Be ""
            $vpn.'src-addr-type' | Should -Be "subnet"
            $vpn.'src-subnet' | Should -Be "0.0.0.0 0.0.0.0"
            $vpn.'dst-name' | Should -Be ""
            $vpn.'dst-addr-type' | Should -Be "subnet"
            $vpn.'dst-subnet' | Should -Be "0.0.0.0 0.0.0.0"
        }

        It "Add VPN Ipsec Phase 2 Interface with 1 proposal (des-md5)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -proposal des-md5
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.proposal | Should -Be "des-md5"
        }

        It "Add VPN Ipsec Phase 2 Interface with 1 proposal (des-sha1)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -proposal des-sha1
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.proposal | Should -Be "des-sha1"
        }

        It "Add VPN Ipsec Phase 2 Interface with 2 proposal (des-md5, des-sha1)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -proposal des-md5, des-sha1
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.proposal | Should -Be "des-md5 des-sha1"
        }

        It "Add VPN Ipsec Phase 2 Interface with pfs disabled" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -pfs:$false
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.pfs | Should -Be "disable"
        }

        It "Add VPN Ipsec Phase 2 Interface with 1 DH Group (1)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -dhgrp 1
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.dhgrp | Should -Be "1"
        }

        It "Add VPN Ipsec Phase 2 Interface with 1 DH Group (2)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -dhgrp 2
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.dhgrp | Should -Be "2"
        }

        It "Add VPN Ipsec Phase 2 Interface with 2 DH Group (1, 2)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -dhgrp 1, 2
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.dhgrp | Should -Be "1 2"
        }

        It "Add VPN Ipsec Phase 2 Interface with replay disabled" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -replay:$false
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.replay | Should -Be "disable"
        }

        It "Add VPN Ipsec Phase 2 Interface with keepalive enable" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -keepalive
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.keepalive | Should -Be "enable"
        }

        It "Add VPN Ipsec Phase 2 Interface with auto-negotiate enable" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -autonegotiate
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'auto-negotiate' | Should -Be "enable"
        }

        It "Add VPN Ipsec Phase 2 Interface with keylifeseconds (28800)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -keylifeseconds 28800
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'keylife-type' | Should -Be "seconds"
            $vpn.keylifeseconds | Should -Be "28800"
        }

        It "Add VPN Ipsec Phase 2 Interface with a comments" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -comment "Add by PowerFGT"
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'comments' | Should -Be "Add by PowerFGT"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (object)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcname $pester_address1
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "name"
            $vpn.'src-name' | Should -Be $pester_address1
            $vpn.'dst-addr-type' | Should -Be "name"
            $vpn.'dst-name' | Should -Be "all"
        }

        It "Add VPN Ipsec Phase 2 Interface with a dst (object)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -dstname $pester_address2
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "name"
            $vpn.'src-name' | Should -Be "all"
            $vpn.'dst-addr-type' | Should -Be "name"
            $vpn.'dst-name' | Should -Be $pester_address2
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (object) and dst (object)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcname $pester_address1 -dstname $pester_address2
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "name"
            $vpn.'src-name' | Should -Be $pester_address1
            $vpn.'dst-addr-type' | Should -Be "name"
            $vpn.'dst-name' | Should -Be $pester_address2
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (ip)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.1
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "ip"
            $vpn.'src-start-ip' | Should -Be "192.0.2.1"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (range)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.1 -srcrange 192.0.2.23
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "range"
            $vpn.'src-start-ip' | Should -Be "192.0.2.1"
            $vpn.'src-end-ip' | Should -Be "192.0.2.23"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (subnet)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.0 -srcnetmask 255.255.255.0
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "subnet"
            $vpn.'src-subnet' | Should -Be "192.0.2.0 255.255.255.0"
        }

        It "Try to Add VPN Ipsec Phase 2 Interface with a src (subnet and range)" {
            { Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.0 -srcrange 192.0.2.23 -srcnetmask 255.255.255.0 } | Should -Throw
        }

        It "Add VPN Ipsec Phase 2 Interface with a dst (ip)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -dstip 192.0.2.1
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'dst-addr-type' | Should -Be "ip"
            $vpn.'dst-start-ip' | Should -Be "192.0.2.1"
        }

        It "Add VPN Ipsec Phase 2 Interface with a dst (range)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -dstip 192.0.2.1 -dstrange 192.0.2.23
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'dst-addr-type' | Should -Be "range"
            $vpn.'dst-start-ip' | Should -Be "192.0.2.1"
            $vpn.'dst-end-ip' | Should -Be "192.0.2.23"
        }

        It "Add VPN Ipsec Phase 2 Interface with a dst (subnet)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -dstip 192.0.2.0 -dstnetmask 255.255.255.0
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'dst-addr-type' | Should -Be "subnet"
            $vpn.'dst-subnet' | Should -Be "192.0.2.0 255.255.255.0"
        }

        It "Try to Add VPN Ipsec Phase 2 Interface with a dst (subnet and range)" {
            { Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -dstip 192.0.2.0 -dstrange 192.0.2.23 -dstnetmask 255.255.255.0 } | Should -Throw
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (ip) and dst (ip)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.1 -dstip 198.51.100.1
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "ip"
            $vpn.'src-start-ip' | Should -Be "192.0.2.1"
            $vpn.'dst-addr-type' | Should -Be "ip"
            $vpn.'dst-start-ip' | Should -Be "198.51.100.1"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (range) and dst (ip)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.1 -srcrange 192.0.2.23 -dstip 198.51.100.1
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "range"
            $vpn.'src-start-ip' | Should -Be "192.0.2.1"
            $vpn.'src-end-ip' | Should -Be "192.0.2.23"
            $vpn.'dst-addr-type' | Should -Be "ip"
            $vpn.'dst-start-ip' | Should -Be "198.51.100.1"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (subnet) and dst (ip)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.0 -srcnetmask 255.255.255.0 -dstip 198.51.100.1
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "subnet"
            $vpn.'src-subnet' | Should -Be "192.0.2.0 255.255.255.0"
            $vpn.'dst-addr-type' | Should -Be "ip"
            $vpn.'dst-start-ip' | Should -Be "198.51.100.1"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (ip) and dst (range)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.1 -dstip 198.51.100.1 -dstrange 198.51.100.23
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "ip"
            $vpn.'src-start-ip' | Should -Be "192.0.2.1"
            $vpn.'dst-addr-type' | Should -Be "range"
            $vpn.'dst-start-ip' | Should -Be "198.51.100.1"
            $vpn.'dst-end-ip' | Should -Be "198.51.100.23"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (range) and dst (range)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.1 -srcrange 192.0.2.23 -dstip 198.51.100.1 -dstrange 198.51.100.23
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "range"
            $vpn.'src-start-ip' | Should -Be "192.0.2.1"
            $vpn.'src-end-ip' | Should -Be "192.0.2.23"
            $vpn.'dst-addr-type' | Should -Be "range"
            $vpn.'dst-start-ip' | Should -Be "198.51.100.1"
            $vpn.'dst-end-ip' | Should -Be "198.51.100.23"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (subnet) and dst (range)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.0 -srcnetmask 255.255.255.0 -dstip 198.51.100.1 -dstrange 198.51.100.23
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "subnet"
            $vpn.'src-subnet' | Should -Be "192.0.2.0 255.255.255.0"
            $vpn.'dst-addr-type' | Should -Be "range"
            $vpn.'dst-start-ip' | Should -Be "198.51.100.1"
            $vpn.'dst-end-ip' | Should -Be "198.51.100.23"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (ip) and dst (subnet)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.1 -dstip 198.51.100.0 -dstnetmask 255.255.255.0
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "ip"
            $vpn.'src-start-ip' | Should -Be "192.0.2.1"
            $vpn.'dst-addr-type' | Should -Be "subnet"
            $vpn.'dst-subnet' | Should -Be "198.51.100.0 255.255.255.0"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (range) and dst (subnet)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.1 -srcrange 192.0.2.23 -dstip 198.51.100.0 -dstnetmask 255.255.255.0
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "range"
            $vpn.'src-start-ip' | Should -Be "192.0.2.1"
            $vpn.'src-end-ip' | Should -Be "192.0.2.23"
            $vpn.'dst-addr-type' | Should -Be "subnet"
            $vpn.'dst-subnet' | Should -Be "198.51.100.0 255.255.255.0"
        }

        It "Add VPN Ipsec Phase 2 Interface with a src (subnet) and dst (subnet)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 -srcip 192.0.2.0 -srcnetmask 255.255.255.0 -dstip 198.51.100.0 -dstnetmask 255.255.255.0
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn.name | Should -Be $pester_vpn1_ph2
            $vpn.phase1name | Should -Be $pester_vpn1
            $vpn.'src-addr-type' | Should -Be "subnet"
            $vpn.'src-subnet' | Should -Be "192.0.2.0 255.255.255.0"
            $vpn.'dst-addr-type' | Should -Be "subnet"
            $vpn.'dst-subnet' | Should -Be "198.51.100.0 255.255.255.0"
        }

        AfterAll {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        }
    }

}

Describe "Remove VPN Ipsec Phase 2 Interface" -ForEach $type {

    Context "Interface $($_.type)" {

        BeforeEach {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Add-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
        }

        AfterEach {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
        }


        It "Remove VPN IPsec Phase 2 Interface by pipeline" {
            Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2 | Remove-FGTVpnIpsecPhase2Interface -Confirm:$false
            $vpn = Get-FGTVpnIpsecPhase2Interface -name $pester_vpn1_ph2
            $vpn | Should -Be $NULL
        }
    }
}


AfterAll {
    Disconnect-FGT -confirm:$false
}