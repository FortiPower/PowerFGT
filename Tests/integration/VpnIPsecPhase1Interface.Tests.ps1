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

$type = @(
    @{ "type" = "IKEv1 Static"; "param" = @{ "ikeversion" = 1; "type" = "static"; "remotegw" = "192.0.2.1" } }
    @{ "type" = "IKEv1 Dynamic"; "param" = @{ "ikeversion" = 1; "type" = "dynamic" } }
    @{ "type" = "IKEv2 Static"; "param" = @{ "ikeversion" = 2; "type" = "static" ; "remotegw" = "192.0.2.1" } }
    @{ "type" = "IKEv2 Dynamic"; "param" = @{ "ikeversion" = 2; "type" = "dynamic" } }
)


Describe "Add VPN Ipsec Phase 1 Interface" -ForEach $type {

    Context "Interface $($_.type)" {
        AfterEach {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
        }

        It "Add VPN Ipsec Phase 1 Interface with only mandatory parameters" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.'net-device' | Should -Be "disable"
            $vpn.'add-route' | Should -Be "enable"
            $vpn.'auto-discovery-sender' | Should -Be "disable"
            $vpn.'auto-discovery-receiver' | Should -Be "disable"
            $vpn.'exchange-interface-ip' | Should -Be "disable"
            if (($fgt_version -ge "6.2.0")) {
                $vpn.'network-overlay' | Should -Be "disable"
                $vpn.'network-id' | Should -Be "0"
            }
            if ($fgt_version -lt "6.2.0" -and $_.param.type -eq "dynamic") {
                $vpn.'dpd' | Should -Be "on-idle"
                $vpn.'dpd-retrycount' | Should -Be 3
                $vpn.'dpd-retryinterval' | Should -Be 60
            }
            else {
                $vpn.'dpd' | Should -Be "on-demand"
                $vpn.'dpd-retrycount' | Should -Be 3
                $vpn.'dpd-retryinterval' | Should -Be 20
            }
            $vpn.'fragmentation' | Should -Be "enable"
            $vpn.'keepalive' |  Should -Be 10
        }

        It "Add VPN Ipsec Phase 1 Interface with 1 proposal (des-md5)" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -proposal des-md5
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.proposal | Should -Be "des-md5"
        }

        It "Add VPN Ipsec Phase 1 Interface with 1 proposal (des-sha1)" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -proposal des-sha1
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.proposal | Should -Be "des-sha1"
        }

        It "Add VPN Ipsec Phase 1 Interface with 2 proposals (des-md5, des-sha1)" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret -remotegw 192.0.2.1 @p -proposal des-md5, des-sha1
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.proposal | Should -Be "des-md5 des-sha1"
        }

        It "Add VPN Ipsec Phase 1 Interface with 1 DH Group (1)" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -dhgrp 1
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.dhgrp | Should -Be "1"
        }

        It "Add VPN Ipsec Phase 1 Interface with 1 DH Group (2)" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -dhgrp 2
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.dhgrp | Should -Be "2"
        }

        It "Add VPN Ipsec Phase 1 Interface with 2 DH Group (1, 2)" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -dhgrp 1, 2
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.dhgrp | Should -Be "1 2"
        }

        It "Add VPN Ipsec Phase 1 Interface with net-device enabled" -skip:($fgt_version -lt "6.2.0" -and $_.param.type -eq "static") {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -netdevice
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'net-device' | Should -Be "enable"
        }

        It "Add VPN Ipsec Phase 1 Interface with add-route disabled" {
            $p = $_.param
            if ($_.param.type -eq "static") {
                { Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -addroute:$false } | Should -Throw "You can't specify addroute when use type static"
            }
            else {
                Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -addroute:$false
                $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
                $vpn.name | Should -Be $pester_vpn1
                $vpn.'ike-version' | Should -Be $_.param.ikeversion
                $vpn.type | Should -Be $_.param.type
                $vpn.proposal | Should -Not -BeNullOrEmpty
                $vpn.psksecret | Should -Not -BeNullOrEmpty
                if ($_.param.type -eq "static") {
                    $vpn.'remote-gw' | Should -Be "192.0.2.1"
                }
                else {
                    $vpn.'remote-gw' | Should -Be "0.0.0.0"
                }
                $vpn.'add-route' | Should -Be "disable"
            }
        }

        It "Add VPN Ipsec Phase 1 Interface with auto-discovery-sender enabled" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -autodiscoverysender
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'auto-discovery-sender' | Should -Be "enable"
        }

        It "Add VPN Ipsec Phase 1 Interface with auto-discovery-receiver enabled" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -autodiscoveryreceiver
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'auto-discovery-receiver' | Should -Be "enable"
        }

        It "Add VPN Ipsec Phase 1 Interface with exchange-interface-ip enabled" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -exchangeinterfaceip
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'exchange-interface-ip' | Should -Be "enable"
        }

        It "Add VPN Ipsec Phase 1 Interface with network (Overlay) id (23)" -Skip:($fgt_version -lt "6.2.0") {
            $p = $_.param
            if ($_.param.ikeversion -eq "1") {
                { Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -networkid 23 } | Should -Throw "Need to set ikeversion 2 to use networkid"
            }
            else {
                #Only work with IKEv2
                Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -networkid 23
                $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
                $vpn.name | Should -Be $pester_vpn1
                $vpn.'ike-version' | Should -Be $_.param.ikeversion
                $vpn.type | Should -Be $_.param.type
                $vpn.proposal | Should -Not -BeNullOrEmpty
                $vpn.psksecret | Should -Not -BeNullOrEmpty
                if ($_.param.type -eq "static") {
                    $vpn.'remote-gw' | Should -Be "192.0.2.1"
                }
                else {
                    $vpn.'remote-gw' | Should -Be "0.0.0.0"
                }
                $vpn.'network-overlay' | Should -Be "enable"
                $vpn.'network-id' | Should -Be "23"
            }
        }

        It "Add VPN Ipsec Phase 1 Interface with dpd disable" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -dpd disable
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'dpd' | Should -Be "disable"
            $vpn.'dpd-retrycount' | Should -Be 3
            if ($fgt_version -lt "6.2.0" -and $_.param.type -eq "dynamic") {
                $vpn.'dpd-retryinterval' | Should -Be 60
            }
            else {
                $vpn.'dpd-retryinterval' | Should -Be 20
            }
        }

        It "Add VPN Ipsec Phase 1 Interface with dpd on-idle" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -dpd 'on-idle'
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'dpd' | Should -Be "on-idle"
        }

        It "Add VPN Ipsec Phase 1 Interface with dpd on-idle" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -dpd 'on-idle'
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'dpd' | Should -Be "on-idle"
            $vpn.'dpd-retrycount' | Should -Be 3
            if ($fgt_version -lt "6.2.0" -and $_.param.type -eq "dynamic") {
                $vpn.'dpd-retryinterval' | Should -Be 60
            }
            else {
                $vpn.'dpd-retryinterval' | Should -Be 20
            }
        }

        It "Add VPN Ipsec Phase 1 Interface with dpd retrycount (1)" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -dpdretrycount 1
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            if ($fgt_version -lt "6.2.0" -and $_.param.type -eq "dynamic") {
                $vpn.'dpd' | Should -Be "on-idle"
                $vpn.'dpd-retrycount' | Should -Be 1
                $vpn.'dpd-retryinterval' | Should -Be 60
            }
            else {
                $vpn.'dpd' | Should -Be "on-demand"
                $vpn.'dpd-retrycount' | Should -Be 1
                $vpn.'dpd-retryinterval' | Should -Be 20
            }

        }

        It "Add VPN Ipsec Phase 1 Interface with dpd retryinterval (10)" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -dpdretryinterval 10
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            if ($fgt_version -lt "6.2.0" -and $_.param.type -eq "dynamic") {
                $vpn.'dpd' | Should -Be "on-idle"
            }
            else {
                $vpn.'dpd' | Should -Be "on-demand"
            }
            $vpn.'dpd-retrycount' | Should -Be 3
            $vpn.'dpd-retryinterval' | Should -Be 10
        }

        It "Add VPN Ipsec Phase 1 Interface with idle timeout enabled" {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -idletimeout
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'idle-timeout' | Should -Be "enable"
        }

        It "Add VPN Ipsec Phase 1 Interface with data (one field)" {
            $data = @{ "fragmentation" = "disable" }
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -data $data
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.fragmentation | Should -Be "disable"
        }

        It "Add VPN Ipsec Phase 1 Interface with data (two fields)" {
            $data = @{ "fragmentation" = "disable" ; "keepalive" = 30 }
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p -data $data
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.fragmentation | Should -Be "disable"
            $vpn.keepalive | Should -Be 30
        }

    }

}

Describe "Configure VPN Ipsec Phase 1 Interface" -ForEach $type {

    Context "Interface $($_.type)" {
        BeforeAll {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p
        }

        It "Set VPN Ipsec Phase 1 Interface with 1 proposal (des-md5)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -proposal des-md5
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.proposal | Should -Be "des-md5"
        }

        It "Set VPN Ipsec Phase 1 Interface with 1 proposal (des-sha1)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -proposal des-sha1
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.proposal | Should -Be "des-sha1"
        }

        It "Set VPN Ipsec Phase 1 Interface with 2 proposals (des-md5, des-sha1)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -proposal des-md5, des-sha1
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.proposal | Should -Be "des-md5 des-sha1"
        }

        It "Set VPN Ipsec Phase 1 Interface with 1 DH Group (1)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -dhgrp 1
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.dhgrp | Should -Be "1"
        }

        It "Set VPN Ipsec Phase 1 Interface with 1 DH Group (2)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -dhgrp 2
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.dhgrp | Should -Be "2"
        }

        It "Set VPN Ipsec Phase 1 Interface with 2 DH Group (1, 2)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -dhgrp 1, 2
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.dhgrp | Should -Be "1 2"
        }

        It "Set VPN Ipsec Phase 1 Interface with net-device enabled" -skip:($fgt_version -lt "6.2.0" -and $_.param.type -eq "static") {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -netdevice
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'net-device' | Should -Be "enable"
        }

        It "Set VPN Ipsec Phase 1 Interface with add-route disabled" {
            if ($_.param.type -eq "static") {
                { Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -addroute:$false } | Should -Throw "You can't specify addroute when use type static"
            }
            else {
                Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -addroute:$false
                $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
                $vpn.name | Should -Be $pester_vpn1
                $vpn.'ike-version' | Should -Be $_.param.ikeversion
                $vpn.type | Should -Be $_.param.type
                $vpn.proposal | Should -Not -BeNullOrEmpty
                $vpn.psksecret | Should -Not -BeNullOrEmpty
                if ($_.param.type -eq "static") {
                    $vpn.'remote-gw' | Should -Be "192.0.2.1"
                }
                else {
                    $vpn.'remote-gw' | Should -Be "0.0.0.0"
                }
                $vpn.'add-route' | Should -Be "disable"
            }
        }

        It "Set VPN Ipsec Phase 1 Interface with auto-discovery-sender enabled" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -autodiscoverysender
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'auto-discovery-sender' | Should -Be "enable"
        }

        It "Set VPN Ipsec Phase 1 Interface with auto-discovery-sender disabled" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -autodiscoverysender:$false
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'auto-discovery-sender' | Should -Be "disable"
        }


        It "Set VPN Ipsec Phase 1 Interface with auto-discovery-receiver enabled" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -autodiscoveryreceiver
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'auto-discovery-receiver' | Should -Be "enable"
        }

        It "Set VPN Ipsec Phase 1 Interface with auto-discovery-receiver disabled" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -autodiscoveryreceiver:$false
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'auto-discovery-receiver' | Should -Be "disable"
        }

        It "Set VPN Ipsec Phase 1 Interface with exchange-interface-ip enabled" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -exchangeinterfaceip
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'exchange-interface-ip' | Should -Be "enable"
        }

        It "Set VPN Ipsec Phase 1 Interface with exchange-interface-ip disabled" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -exchangeinterfaceip:$false
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'exchange-interface-ip' | Should -Be "disable"
        }

        It "Set VPN Ipsec Phase 1 Interface with network (Overlay) id (23)" -Skip:($fgt_version -lt "6.2.0") {
            if ($_.param.ikeversion -eq "1") {
                { Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -networkid 23 } | Should -Throw "Need to set ikeversion 2 to use networkid"
            }
            else {
                #Only work with IKEv2
                Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -networkid 23
                $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
                $vpn.name | Should -Be $pester_vpn1
                $vpn.'ike-version' | Should -Be $_.param.ikeversion
                $vpn.type | Should -Be $_.param.type
                $vpn.proposal | Should -Not -BeNullOrEmpty
                $vpn.psksecret | Should -Not -BeNullOrEmpty
                if ($_.param.type -eq "static") {
                    $vpn.'remote-gw' | Should -Be "192.0.2.1"
                }
                else {
                    $vpn.'remote-gw' | Should -Be "0.0.0.0"
                }
                $vpn.'network-overlay' | Should -Be "enable"
                $vpn.'network-id' | Should -Be "23"
            }
        }

        It "Set VPN Ipsec Phase 1 Interface with dpd disable" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -dpd disable
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'dpd' | Should -Be "disable"
            $vpn.'dpd-retrycount' | Should -Be 3
            if ($fgt_version -lt "6.2.0" -and $_.param.type -eq "dynamic") {
                $vpn.'dpd-retryinterval' | Should -Be 60
            }
            else {
                $vpn.'dpd-retryinterval' | Should -Be 20
            }
        }

        It "Set VPN Ipsec Phase 1 Interface with dpd on-idle" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -dpd 'on-idle'
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'dpd' | Should -Be "on-idle"
        }

        It "Set VPN Ipsec Phase 1 Interface with dpd on-demand" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -dpd 'on-demand'
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'dpd' | Should -Be "on-demand"
            $vpn.'dpd-retrycount' | Should -Be 3
            if ($fgt_version -lt "6.2.0" -and $_.param.type -eq "dynamic") {
                $vpn.'dpd-retryinterval' | Should -Be 60
            }
            else {
                $vpn.'dpd-retryinterval' | Should -Be 20
            }
        }

        It "Set VPN Ipsec Phase 1 Interface with dpd retrycount (1)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -dpdretrycount 1
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'dpd' | Should -Be "on-demand"
            $vpn.'dpd-retrycount' | Should -Be 1
            if ($fgt_version -lt "6.2.0" -and $_.param.type -eq "dynamic") {
                $vpn.'dpd-retryinterval' | Should -Be 60
            }
            else {
                $vpn.'dpd-retryinterval' | Should -Be 20
            }
        }

        It "Set VPN Ipsec Phase 1 Interface with dpd retryinterval (10)" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -dpdretryinterval 10
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'dpd' | Should -Be "on-demand"
            $vpn.'dpd-retrycount' | Should -Be 1
            $vpn.'dpd-retryinterval' | Should -Be 10
        }

        It "Set VPN Ipsec Phase 1 Interface with idle timeout enabled" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -idletimeout
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.'idle-timeout' | Should -Be "enable"
        }

        It "Set VPN Ipsec Phase 1 Interface with data (one field)" {
            $data = @{ "fragmentation" = "disable" }
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -data $data
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.fragmentation | Should -Be "disable"
        }

        It "Set VPN Ipsec Phase 1 Interface with data (two fields)" {
            $data = @{ "fragmentation" = "disable" ; "keepalive" = 30 }
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Set-FGTVpnIpsecPhase1Interface -data $data
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn.name | Should -Be $pester_vpn1
            $vpn.'ike-version' | Should -Be $_.param.ikeversion
            $vpn.type | Should -Be $_.param.type
            $vpn.proposal | Should -Not -BeNullOrEmpty
            $vpn.psksecret | Should -Not -BeNullOrEmpty
            if ($_.param.type -eq "static") {
                $vpn.'remote-gw' | Should -Be "192.0.2.1"
            }
            else {
                $vpn.'remote-gw' | Should -Be "0.0.0.0"
            }
            $vpn.fragmentation | Should -Be "disable"
            $vpn.keepalive | Should -Be 30
        }

        AfterAll {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
        }
    }

}

Describe "Add VPN Ipsec Phase 1 Interface" -ForEach $type {

    Context "Interface $($_.type)" {

        BeforeEach {
            $p = $_.param
            Add-FGTVpnIpsecPhase1Interface -name $pester_vpn1 -interface $pester_port1 -psksecret MySecret @p
        }

        It "Remove System Interface by pipeline" {
            Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1 | Remove-FGTVpnIpsecPhase1Interface -Confirm:$false
            $vpn = Get-FGTVpnIpsecPhase1Interface -name $pester_vpn1
            $vpn | Should -Be $NULL
        }
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}