#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1


BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get Router Static" {

    BeforeAll {
        Add-FGTRouterStatic -seq_num 10 -dst 192.2.0.0/24 -gateway 192.2.0.1 -distance 15 -priority 5 -device port2
        Add-FGTRouterStatic -seq_num 11 -dst 198.51.100.0/24 -gateway 198.51.100.1 -distance 15 -priority 5 -device port2
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

    It "Get Route with gateway 198.51.100.1 and confirm (via Confirm-FGTRouterStatic)" {
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 198.51.100.1
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
        Get-FGTRouterStatic -filter_attribute gateway -filter_value 198.51.100.1 | Remove-FGTRouterStatic -confirm:$false
    }

}

Describe "Add Static Route" {

    AfterEach {
        Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1 | Remove-FGTRouterStatic -confirm:$false
    }

    It "Add route to 192.2.0.0/24" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 192.2.0.1 -device port2
        ($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.gateway | Should -Be "192.2.0.1"
        $route.distance | Should -Be 10
        $route.priority | Should -Be 0
        $route.device | Should -Be "port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr| Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Be "0"
        $route.bfd | Should -Be "disable"
    }

    It "Add route to 192.2.0.0/24 with distance (15)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 192.2.0.1 -device port2 -distance 15
        ($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.gateway | Should -Be "192.2.0.1"
        $route.distance | Should -Be 15
        $route.priority | Should -Be 0
        $route.device | Should -Be "port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr| Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Be "0"
        $route.bfd | Should -Be "disable"
    }

    It "Add route to 192.2.0.0/24 with priority (5)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 192.2.0.1 -device port2 -priority 5
        ($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.gateway | Should -Be "192.2.0.1"
        $route.distance | Should -Be 10
        $route.priority | Should -Be 5
        $route.device | Should -Be "port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr| Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Be "0"
        $route.bfd | Should -Be "disable"
    }

    It "Add route to 192.2.0.0/24 with seq-num (10)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 192.2.0.1 -device port2 -seq_num 10
        ($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -filter_attribute gateway -filter_value 192.2.0.1
        $route.'seq-num' | Should -Be "10"
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.gateway | Should -Be "192.2.0.1"
        $route.distance | Should -Be 10
        $route.priority | Should -Be 0
        $route.device | Should -Be "port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr| Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Be "0"
        $route.bfd | Should -Be "disable"
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

AfterAll {
    Disconnect-FGT -confirm:$false
}