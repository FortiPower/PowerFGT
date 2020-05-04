#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get Firewall VIP" {

    BeforeAll {
        $vip = Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        $script:uuid = $vip.uuid
    }

    It "Get Virtual IP Does not throw an error" {
        {
            Get-FGTFirewallVip
        } | Should Not Throw
    }

    It "Get ALL Virtual IP" {
        $vip = Get-FGTFirewallVip
        $vip.count | Should -Not -Be $NULL
    }

    It "Get ALL Virtual IP with -skip" {
        $vip = Get-FGTFirewallVip -skip
        $vip.count | Should -Not -Be $NULL
    }

    It "Get Virtual IP ($pester_vip1)" {
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
    }

    It "Get Virtual IP ($pester_vip1) and confirm (via Confirm-FGTVip)" {
        $vip = Get-FGTFirewallVip -name $pester_vip1
        Confirm-FGTVip ($vip) | Should -Be $true
    }

    Context "Search" {

        It "Search Virtual IP by name ($pester_vip1)" {
            $vip = Get-FGTFirewallVip -name $pester_vip1
            @($vip).count | Should -be 1
            $vip.name | Should -Be $pester_vip1
        }

        It "Search Virtual IP by uuid ($script:uuid)" {
            $vip = Get-FGTFirewallVip -uuid $script:uuid
            @($vip).count | Should -be 1
            $vip.name | Should -Be $pester_vip1
        }

    }

    AfterAll {
        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVip -noconfirm
    }

}

Describe "Remove Firewall VIP" {

    BeforeEach {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
    }

    It "Remove Virtual IP $pester_vip1 by pipeline" {
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip | Remove-FGTFirewallVip -noconfirm
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip | Should -Be $NULL
    }

}

Disconnect-FGT -noconfirm
