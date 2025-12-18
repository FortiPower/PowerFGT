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

Describe "Get Static Route" {

    BeforeAll {
        Add-FGTRouterStatic -seq_num 10 -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2
        Add-FGTRouterStatic -seq_num 11 -dst 198.51.100.0/24 -gateway 192.2.0.254 -device $pester_port3
    }

    It "Get Static Route Does not throw an error" {
        {
            Get-FGTRouterStatic
        } | Should -Not -Throw
    }

    It "Get ALL Static Route" {
        $route = Get-FGTRouterStatic
        $route.count | Should -Not -Be $NULL
    }

    It "Get ALL Static Route with -skip" {
        $route = Get-FGTRouterStatic -skip
        $route.count | Should -Not -Be $NULL
    }

    It "Get Static Route -Schema" {
        $schema = Get-FGTRouterStatic -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.name | Should -Be "static"
        $schema.category | Should -Not -BeNullOrEmpty
        $schema.children | Should -Not -BeNullOrEmpty
        $schema.mkey | Should -Be "seq-num"
    }

    It "Get Static Route with gateway 192.2.0.254 and confirm (via Confirm-FGTRouterStatic)" {
        $route = Get-FGTRouterStatic -gateway 192.2.0.254
        Confirm-FGTRouterStatic ($route) | Should -Be $true
    }

    It "Get ALL Static Route with meta" {
        $route = Get-FGTRouterStatic -meta -gateway 192.2.0.254
        $route.q_ref | Should -Not -BeNullOrEmpty
        $route.q_static | Should -Not -BeNullOrEmpty
        $route.q_no_rename | Should -Not -BeNullOrEmpty
        $route.q_global_entry | Should -Not -BeNullOrEmpty
        $route.q_type | Should -Not -BeNullOrEmpty
        $route.q_path | Should -Be "router"
        $route.q_name | Should -Be "static"
        $route.q_mkey_type | Should -Be "integer"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $route.q_no_edit | Should -Not -BeNullOrEmpty
        }
        #$route.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search Static Route by device" {
            $route = Get-FGTRouterStatic -device $pester_port2
            @($route).count | Should -be 1
            $route.device | Should -Be $pester_port2
        }

        It "Search Static Route by dst" {
            $route = Get-FGTRouterStatic -dst "198.51.100.0 255.255.255.0"
            @($route).count | Should -be 1
            $route.dst | Should -Be "198.51.100.0 255.255.255.0"
        }

        It "Search Static Route by gateway" {
            $route = Get-FGTRouterStatic -gateway 198.51.100.254
            @($route).count | Should -be 1
            $route.gateway | Should -Be "198.51.100.254"
        }

        It "Search Static Route by seq-num" {
            $route = Get-FGTRouterStatic -seq_num 10
            @($route).count | Should -be 1
            $route.'seq-num' | Should -Be "10"
        }
    }

    AfterAll {
        Get-FGTRouterStatic -gateway 198.51.100.254 | Remove-FGTRouterStatic -confirm:$false
        Get-FGTRouterStatic -gateway 192.2.0.254 | Remove-FGTRouterStatic -confirm:$false
    }

}

Describe "Add Static Route" {

    AfterEach {
        Get-FGTRouterStatic -dst "192.2.0.0 255.255.255.0" | Remove-FGTRouterStatic -confirm:$false
        Get-FGTRouterStatic -gateway "198.51.100.254" | Remove-FGTRouterStatic -confirm:$false
    }

    It "Add Static Route to 192.2.0.0/24" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with distance (15)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -distance 15
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 15
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with priority (5)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -priority 5
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        $route.priority | Should -Be 5
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with seq-num (10)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -seq_num 10
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Be "10"
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with status (enable)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -status
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with status (disable)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -status:$false
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "disable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with weight (10)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -weight 10
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 10
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with comment" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -comment "Add by PowerFGT"
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be "Add by PowerFGT"
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with blackhole (enable)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -blackhole
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -dst "192.2.0.0 255.255.255.0"
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "0.0.0.0"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be ""
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "enable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with dynamic-gateway (enable)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -dynamic_gateway
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "enable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to FortiGuard DNS with internet-service" {
        $r = Add-FGTRouterStatic -gateway 198.51.100.254 -device $pester_port2 -internet_service 1245187
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "0.0.0.0 0.0.0.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "1245187"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with link-monitor-exempt (enable)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -link_monitor_exempt
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "enable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with bfd (enable)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -bfd
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "enable"
    }

    It "Add Static Route to 192.2.0.0/24 with -data (1 field)" {
        $data = @{ "weight" = "15" }
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -data $data
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 15
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }

    It "Add Static Route to 192.2.0.0/24 with -data (2 fields)" {
        $data = @{ "weight" = "15" ; "bfd" = "enable" }
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -data $data
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 15
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "enable"
    }

    <# Need to add vrf to Add-FTGInterfaces
    It "Add Static Route to 192.2.0.0/24 with vrf" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_port2 -vrf 1
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        } else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr| Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Be "1"
        $route.bfd | Should -Be "enable"
    }
    #>

    <# Need to add allow_routing to Add-FTGFirewallAddress
    It "Add Static Route to $pester_address2 (dstaddr)" {
        $r = Add-FGTRouterStatic -dstaddr $pester_address2 -gateway 198.51.100.254 -device $pester_$pester_port2
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "0.0.0.0 0.0.0.0"
        $route.src | Should -Be "0.0.0.0 0.0.0.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        } else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr| Should -Be $pester_address2
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }
    #>

    <#historic settings ? don't work...
    It "Add Static Route to 192.2.0.0/24 with src (203.0.113.0/24)" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -src 203.0.113.0/24 -gateway 198.51.100.254 -device $pester_$pester_port2
        @($r).count | Should -Be "1"
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route.'seq-num' | Should -Not -BeNullOrEmpty
        $route.status | Should -Be "enable"
        $route.dst | Should -Be "192.2.0.0 255.255.255.0"
        $route.src | Should -Be "203.0.113.0 255.255.255.0"
        $route.gateway | Should -Be "198.51.100.254"
        $route.distance | Should -Be 10
        $route.weight | Should -Be 0
        if ($DefaultFGTConnection.version -lt "7.0.0") {
            $route.priority | Should -Be 0
        }
        else {
            $route.priority | Should -Be 1
        }
        $route.device | Should -Be "$pester_$pester_port2"
        $route.comment | Should -Be ""
        $route.blackhole | Should -Be "disable"
        $route.'dynamic-gateway' | Should -Be "disable"
        $route.dstaddr | Should -Be ""
        $route.'internet-service' | Should -Be "0"
        $route.'internet-service-custom' | Should -Be ""
        $route.'link-monitor-exempt' | Should -Be "disable"
        $route.vrf | Should -Not -BeNullOrEmpty
        $route.bfd | Should -Be "disable"
    }
    #>

    It "Try to Add Static Route with duplicate seq-num" {
        $r = Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_$pester_port2 -seq_num 10
        @($r).count | Should -Be "1"
        {
            Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device $pester_$pester_port2 -seq_num 10
        } | Should -Throw "Already a static route with this sequence number"
    }

    It "Try to Add Static Route with unknown device" {
        {
            Add-FGTRouterStatic -dst 192.2.0.0/24 -gateway 198.51.100.254 -device PowerFGT
        } | Should -Throw "The device interface does not exist"
    }
}

Describe "Remove Static Route" {

    BeforeEach {
        Add-FGTRouterStatic -seq_num 10 -dst 192.2.0.0/24 -gateway 198.51.100.254 -distance 15 -priority 5 -device $pester_$pester_port2
    }

    It "Remove Static Route 192.2.0.0/24 by pipeline" {
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route | Remove-FGTRouterStatic -confirm:$false
        $route = Get-FGTRouterStatic -gateway 198.51.100.254
        $route | Should -Be $NULL
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}