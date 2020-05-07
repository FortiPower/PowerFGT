#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get Firewall Policy" {

    BeforeAll {
        $policy = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
        $script:uuid = $policy.uuid
        $script:policyid = $policy.policyid
    }

    It "Get Policy Does not throw an error" {
        {
            Get-FGTFirewallPolicy
        } | Should Not Throw
    }

    It "Get ALL Policy" {
        $policy = Get-FGTFirewallPolicy
        $policy.count | Should -Not -Be $NULL
    }

    It "Get ALL Policy with -skip" {
        $policy = Get-FGTFirewallPolicy -skip
        $policy.count | Should -Not -Be $NULL
    }

    It "Get Policy ($pester_policy1)" {
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
    }

    It "Get Policy ($pester_policy1) and confirm (via Confirm-FGTFirewallPolicy)" {
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        Confirm-FGTFirewallPolicy ($policy) | Should -Be $true
    }

    Context "Search" {

        It "Search Policy by name ($pester_policy1)" {
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            @($policy).count | Should -be 1
            $policy.name | Should -Be $pester_policy1
        }

        It "Search Policy by uuid ($script:uuid)" {
            $policy = Get-FGTFirewallPolicy -uuid $script:uuid
            @($policy).count | Should -be 1
            $policy.name | Should -Be $pester_policy1
        }

        It "Search Policy by policyid ($script:policyid)" {
            $policy = Get-FGTFirewallPolicy -policyid $script:policyid
            @($policy).count | Should -be 1
            $policy.name | Should -Be $pester_policy1
        }

    }

    AfterAll {
        Get-FGTFirewallPolicy -name $pester_policy1 | Remove-FGTFirewallPolicy -noconfirm
    }

}

Describe "Remove Firewall Policy" {

    BeforeEach {
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
    }

    It "Remove Policy $pester_policy1 by pipeline" {
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy | Remove-FGTFirewallPolicy -noconfirm
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy | Should -Be $NULL
    }

}

Disconnect-FGT -noconfirm
