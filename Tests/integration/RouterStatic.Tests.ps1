#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get Router Static" {

    BeforeAll {
        Add-FGTRouterStatic -seq_num 10 -dst 192.2.0.0/24 -gateway 192.2.0.1 -distance 15 -priority 5 -device port2
        Add-FGTRouterStatic -seq_num 11 -dst 192.3.0.0/24 -gateway 192.3.0.1 -distance 15 -priority 5 -device port2
    }

    It "Get Route Does not throw an error" {
        {
            Get-FGTRouterStatic
        } | Should -Not -Throw
    }

    It "Get ALL Route" {
        $route = Get-FGTRouterStatic
        $route.count | Should -Not -Be $NULL
    }

    It "Get ALL Route with -skip" {
        $route = Get-FGTRouterStatic -skip
        $route.count | Should -Not -Be $NULL
    }

    It "Get Route with gateway 192.2.0.1" {
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
        $route.gateway | Should -Be "192.2.0.1"
    }

    It "Get Route with gateway 192.3.0.1 and confirm (via Confirm-FGTRouterStatic)" {
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.3.0.1
        Confirm-FGTRouterStatic ($route) | Should -Be $true
    }

    Context "Search" {

        It "Search Route by gateway" {
            $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
            @($route).count | Should -be 1
            $route.gateway | Should -Be "192.2.0.1"
        }

    }

    AfterAll {
        Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1 | Remove-FGTRouterStatic -confirm:$false
        Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.3.0.1 | Remove-FGTRouterStatic -confirm:$false
    }

}

Describe "Add Static Route" {

    AfterEach {
        Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1 | Remove-FGTRouterStatic -confirm:$false
    }

    It "Add route to 192.2.0.0/24" {
        Add-FGTRouterStatic -seq_num 10 -dst 192.2.0.0/24 -gateway 192.2.0.1 -device port2
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.gateway | Should -Be "192.2.0.1"
        $route.device | Should -Be "port2"
    }

    It "Add route to 192.2.0.0/24 with multiple parameters" {
        Add-FGTRouterStatic -seq_num 10 -dst 192.2.0.0/24 -gateway 192.2.0.1 -distance 15 -priority 5 -device port2
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.gateway | Should -Be "192.2.0.1"
        $route.distance | Should -Be 15
        $route.priority | Should -Be 5
        $route.device | Should -Be "port2"
    }

}

Describe "Remove Static Route" {

    BeforeEach {
        Add-FGTRouterStatic -seq_num 10 -dst 192.2.0.0/24 -gateway 192.2.0.1 -distance 15 -priority 5 -device port2
    }

    It "Remove Route 192.2.0.0/24 by pipeline" {
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
        $route | Remove-FGTRouterStatic -confirm:$false
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
        $route | Should -Be $NULL
    }

}

Disconnect-FGT -confirm:$false
#>