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

Describe "Get Firewall Policy" {

    BeforeAll {
        $policy = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
        $script:uuid = $policy.uuid
        $script:policyid = $policy.policyid
        Add-FGTFirewallPolicy -name $pester_policy2 -srcintf port2 -dstintf port1 -srcaddr all -dstaddr all
    }

    It "Get Policy Does not throw an error" {
        {
            Get-FGTFirewallPolicy
        } | Should -Not -Throw
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

    It "Get Policy ($pester_policy1) and meta" {
        $policy = Get-FGTFirewallPolicy -name $pester_policy1 -meta
        $policy.name | Should -Be $pester_policy1
        $policy.q_ref | Should -Not -BeNullOrEmpty
        $policy.q_static | Should -Not -BeNullOrEmpty
        $policy.q_no_rename | Should -Not -BeNullOrEmpty
        $policy.q_global_entry | Should -Not -BeNullOrEmpty
        $policy.q_type | Should -BeIn @('50', '51', '52', '53')
        $policy.q_path | Should -Be "firewall"
        $policy.q_name | Should -Be "policy"
        $policy.q_mkey_type | Should -Be "integer"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $policy.q_no_edit | Should -Not -BeNullOrEmpty
        }
        #$policy.q_class | Should -Not -BeNullOrEmpty
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
        Get-FGTFirewallPolicy -name $pester_policy1 | Remove-FGTFirewallPolicy -confirm:$false
        Get-FGTFirewallPolicy -name $pester_policy2 | Remove-FGTFirewallPolicy -confirm:$false
    }

}

Describe "Add Firewall Policy" {

    BeforeAll {
        Add-FGTFirewallPolicy -name $pester_policy2 -srcintf port2 -dstintf port3 -srcaddr all -dstaddr all
    }

    AfterEach {
        Get-FGTFirewallPolicy -name $pester_policy1 | Remove-FGTFirewallPolicy -confirm:$false
    }

    It "Add Policy $pester_policy1 (port1/port2 : All/All)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
    }

    Context "Multi Source / destination Interface" {

        It "Add Policy $pester_policy1 (src intf: port1, port3 and dst intf: port2)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1, port3 -dstintf port2 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            ($policy.srcintf.name).count | Should -be "2"
            $policy.srcintf.name | Should -BeIn "port1", "port3"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src intf: port1 and dst intf: port2, port4)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2, port4 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -Be "port1"
            ($policy.dstintf.name).count | Should -be "2"
            $policy.dstintf.name | Should -BeIn "port2", "port4"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src intf: port1, port3 and dst intf: port2, port4)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1, port3 -dstintf port2, port4 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            ($policy.srcintf.name).count | Should -be "2"
            $policy.srcintf.name | Should -BeIn "port1", "port3"
            ($policy.dstintf.name).count | Should -be "2"
            $policy.dstintf.name | Should -BeIn "port2", "port4"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

    }

    Context "Multi Source / destination address" {

        BeforeAll {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
            Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
            Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
            Add-FGTFirewallAddress -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
        }

        It "Add Policy $pester_policy1 (src addr: $pester_address1 and dst addr: all)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1 -dstaddr all
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be $pester_address1
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src addr: $pester_address1, $pester_address3 and dst addr: all)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1, $pester_address3 -dstaddr all
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src addr: all and dst addr: $pester_address2)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr $pester_address2
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be $pester_address2
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src addr: all and dst addr: $pester_address2, $pester_address4)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr $pester_address2, $pester_address4
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src addr: $pester_address1, $pester_address3 and dst addr: $pester_address2, $pester_address4)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1, $pester_address3 -dstaddr $pester_address2, $pester_address4
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        AfterAll {
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    It "Add Policy $pester_policy1 (with nat)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -nat
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "enable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with action deny)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action deny
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "deny"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "disable"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with action deny with log)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action deny -log all
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "deny"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "all"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (status disable)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -status:$false
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "disable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with 1 service : HTTP)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service HTTP
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "HTTP"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with 2 services : HTTP, HTTPS)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service HTTP, HTTPS
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -BeIn "HTTP", "HTTPS"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with logtraffic all)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -logtraffic all
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "all"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with logtraffic disable)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -logtraffic disable
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "disable"
        $policy.comments | Should -BeNullOrEmpty
    }

    #Add Schedule ? need API
    It "Add Policy $pester_policy1 (with schedule none)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -schedule none
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "none"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with comments)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -comments "Add via PowerFGT"
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -Be "Add via PowerFGT"
    }

    It "Add Policy $pester_policy1 (with policyid)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -policyid 23
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.policyid | Should -Be "23"
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
    }

    #Disable missing API for create IP Pool
    It "Add Policy $pester_policy1 (with IP Pool)" -skip:$true {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -nat -ippool "MyIPPool"
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -BeIn "HTTP", "HTTPS"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "enable"
        $policy.logtraffic | Should -Be "disable"
        $policy.comments | Should -BeNullOrEmpty
        $policy.ippool | Should -Be "enable"
        $policy.poolname | Should -Be "MyIPPool"
    }

    It "Add Policy $pester_policy1 (with data (1 field))" {
        $data = @{ "logtraffic-start" = "enable" }
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -data $data
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
        $policy.'logtraffic-start' | Should -Be "enable"
    }

    It "Add Policy $pester_policy1 (with data (2 fields))" {
        $data = @{ "logtraffic-start" = "enable" ; "comments" = "Add via PowerFGT and -data" }
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -data $data
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -Be "Add via PowerFGT and -data"
        $policy.'logtraffic-start' | Should -Be "enable"
    }

    It "Add Policy $pester_policy1 (with SSL/SSH Profile: certificate-inspection)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -sslsshprofile certificate-inspection
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
        $policy.'utm-status' | Should -Be "disable"
        $policy.'ssl-ssh-profile' | Should -Be "certificate-inspection"
    }


    It "Add Policy $pester_policy1 (with SSL/SSH Profile: deep-inspection)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -sslsshprofile deep-inspection
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
        $policy.'utm-status' | Should -Be "disable"
        $policy.'ssl-ssh-profile' | Should -Be "deep-inspection"
    }

    It "Add Policy $pester_policy1 (with AV Profile: default)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -avprofile default
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
        $policy.'utm-status' | Should -Be "enable"
        $policy.'av-profile' | Should -Be "default"
    }

    It "Add Policy $pester_policy1 (with Web Filter Profile: default)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -webfilterprofile default
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
        $policy.'utm-status' | Should -Be "enable"
        $policy.'webfilter-profile' | Should -Be "default"
    }

    It "Add Policy $pester_policy1 (with DNS Filter Profile: default)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -dnsfilterprofile default
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
        $policy.'utm-status' | Should -Be "enable"
        $policy.'dnsfilter-profile' | Should -Be "default"
    }

    It "Add Policy $pester_policy1 (with IP Sensor: default)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -ipssensor default
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
        $policy.'utm-status' | Should -Be "enable"
        $policy.'ips-sensor' | Should -Be "default"
    }

    It "Add Policy $pester_policy1 (with Application List: default)" {
        $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -applicationlist default
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy.name | Should -Be $pester_policy1
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.srcintf.name | Should -Be "port1"
        $policy.dstintf.name | Should -Be "port2"
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.nat | Should -Be "disable"
        $policy.logtraffic | Should -Be "utm"
        $policy.comments | Should -BeNullOrEmpty
        $policy.'utm-status' | Should -Be "enable"
        $policy.'application-list' | Should -Be "default"
    }

    It "Try to Add Policy $pester_policy1 (but there is already a object with same name)" {
        #Add first policy
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
        #Add Second policy with same name
        { Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all } | Should -Throw "Already a Policy using the same name"
    }

    It "Try to Add Policy without name (unnamed policy)" {
        #TODO: Add check where unnamed policy is allowed (need cmdlet for modified System Settings)
        { Add-FGTFirewallPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all } | Should -Throw "You need to specifiy a name"
    }

    Context "Unnamed Policy" {

        BeforeAll {
            #Change settings for enable unnamed policy
            Set-FGTSystemSettings -gui_allow_unnamed_policy
        }

        AfterEach {
            Get-FGTFirewallPolicy -policyid 23 | Remove-FGTFirewallPolicy -confirm:$false
        }

        It "Add unnamed Policy" {
            $p = Add-FGTFirewallPolicy -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -policyid 23
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallPolicy -policyid 23
            $policy.name | Should -Be ""
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
            $policy.ippool | Should -Be "disable"
            $policy.comments | Should -BeNullOrEmpty
        }

        AfterAll {
            #Reverse settings for enable unnamed policy
            Set-FGTSystemSettings -gui_allow_unnamed_policy:$false
        }
    }

    AfterAll {
        Get-FGTFirewallPolicy -name $pester_policy2 | Remove-FGTFirewallPolicy -confirm:$false
    }
}

Describe "Add Firewall Policy Member" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
    }

    AfterEach {
        Get-FGTFirewallPolicy -name $pester_policy1 | Remove-FGTFirewallPolicy -confirm:$false
    }

    Context "Add Member(s) to Source Address" {

        It "Add 1 member to Policy Src Address $pester_address1 (with All before)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallPolicy -Name $pester_policy1 | Add-FGTFirewallPolicyMember -srcaddr $pester_address1
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be $pester_address1
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 2 members to Policy Src Address $pester_address1, $pester_address3 (with All before)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallPolicy -Name $pester_policy1 | Add-FGTFirewallPolicyMember -srcaddr $pester_address1, $pester_address3
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -Be $pester_address1, $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 1 member to Policy Src Address $pester_address3 (with $pester_address1 before)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1 -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallPolicy -Name $pester_policy1 | Add-FGTFirewallPolicyMember -srcaddr $pester_address3
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -Be $pester_address1, $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

    }

    Context "Add Member(s) to Destination Address" {

        It "Add 1 member to Policy Dst Address $pester_address2 (with All before)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallPolicy -Name $pester_policy1 | Add-FGTFirewallPolicyMember -dstaddr $pester_address2
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "$pester_address2"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 2 members to Policy Dst Address $pester_address2, $pester_address4 (with All before)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallPolicy -Name $pester_policy1 | Add-FGTFirewallPolicyMember -dstaddr $pester_address2, $pester_address4
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 1 member to Policy Dst Address $pester_address4 (with $pester_address2 before)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr $pester_address2
            @($p).count | Should -Be "1"
            Get-FGTFirewallPolicy -Name $pester_policy1 | Add-FGTFirewallPolicyMember -dstaddr $pester_address4
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }
    }

    Context "Add Member(s) to Source and Destination Address" {

        It "Add 1 member to Policy src Address $pester_address1 dst Address $pester_address2 (with All before)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallPolicy -Name $pester_policy1 | Add-FGTFirewallPolicyMember -srcaddr $pester_address1 -dstaddr $pester_address2
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "$pester_address1"
            $policy.dstaddr.name | Should -Be "$pester_address2"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 2 members to Policy Src Address $pester_address1, $pester_address3 and Dst Address $pester_address2, $pester_address4 (with All before)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallPolicy -Name $pester_policy1 | Add-FGTFirewallPolicyMember -srcaddr $pester_address1, $pester_address3 -dstaddr $pester_address2, $pester_address4
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 1 members to Policy Src Address $pester_address3 and Dst Address $pester_address4 (with $pester_address1/$pester_address2 before)" {
            $p = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1 -dstaddr $pester_address2
            @($p).count | Should -Be "1"
            Get-FGTFirewallPolicy -Name $pester_policy1 | Add-FGTFirewallPolicyMember -srcaddr $pester_address3 -dstaddr $pester_address4
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }
    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Move Firewall Policy" {

    BeforeEach {
        $p1 = Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service SSH
        $script:policyid1 = [int]$p1.policyid
        $p2 = Add-FGTFirewallPolicy -name $pester_policy2 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service HTTP
        $script:policyid2 = [int]$p2.policyid
        $p3 = Add-FGTFirewallPolicy -name $pester_policy3 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service HTTPS
        $script:policyid3 = [int]$p3.policyid
    }

    AfterEach {
        Get-FGTFirewallPolicy -name $pester_policy1 | Remove-FGTFirewallPolicy -confirm:$false
        Get-FGTFirewallPolicy -name $pester_policy2 | Remove-FGTFirewallPolicy -confirm:$false
        Get-FGTFirewallPolicy -name $pester_policy3 | Remove-FGTFirewallPolicy -confirm:$false
    }

    Context "Move Policy Using id" {

        It "Move Policy SSH after HTTPS (using id)" {
            Get-FGTFirewallPolicy -name $pester_policy1 | Move-FGTFirewallPolicy -after -id $policyid3
            $policy = Get-FGTFirewallPolicy
            $policy[0].name | Should -Be $pester_policy2
            $policy[1].name | Should -Be $pester_policy3
            $policy[2].name | Should -Be $pester_policy1
        }

        It "Move Policy HTTPS before SSH (using id)" {
            Get-FGTFirewallPolicy -name $pester_policy3 | Move-FGTFirewallPolicy -before -id $policyid1
            $policy = Get-FGTFirewallPolicy
            $policy[0].name | Should -Be $pester_policy3
            $policy[1].name | Should -Be $pester_policy1
            $policy[2].name | Should -Be $pester_policy2
        }
    }

    Context "Move Policy Using Firewall Policy Object" {

        It "Move Policy SSH after HTTPS (using Firewall Policy Object)" {
            Get-FGTFirewallPolicy -name $pester_policy1 | Move-FGTFirewallPolicy -after -id (Get-FGTFirewallPolicy -name $pester_policy3)
            $policy = Get-FGTFirewallPolicy
            $policy[0].name | Should -Be $pester_policy2
            $policy[1].name | Should -Be $pester_policy3
            $policy[2].name | Should -Be $pester_policy1
        }

        It "Move Policy HTTPS before SSH (using Firewall Policy Object)" {
            Get-FGTFirewallPolicy -name $pester_policy3 | Move-FGTFirewallPolicy -before -id (Get-FGTFirewallPolicy -name $pester_policy1)
            $policy = Get-FGTFirewallPolicy
            $policy[0].name | Should -Be $pester_policy3
            $policy[1].name | Should -Be $pester_policy1
            $policy[2].name | Should -Be $pester_policy2
        }
    }
}

Describe "Remove Firewall Policy" {

    BeforeEach {
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
    }

    It "Remove Policy $pester_policy1 by pipeline" {
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy | Remove-FGTFirewallPolicy -confirm:$false
        $policy = Get-FGTFirewallPolicy -name $pester_policy1
        $policy | Should -Be $NULL
    }

}

Describe "Remove Firewall Policy Member" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
    }

    AfterEach {
        Get-FGTFirewallPolicy -name $pester_policy1 | Remove-FGTFirewallPolicy -confirm:$false
    }

    Context "Remove Member(s) to Source Address" {
        BeforeEach {
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1, $pester_address2, $pester_address3 -dstaddr all
        }

        It "Remove 1 member to Policy Src Address $pester_address1 (with 3 members before)" {
            Get-FGTFirewallPolicy -Name $pester_policy1 | Remove-FGTFirewallPolicyMember -srcaddr $pester_address1
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -Be $pester_address2, $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Remove 2 members to Policy Src Address $pester_address1, $pester_address2 (with 3 members before)" {
            Get-FGTFirewallPolicy -Name $pester_policy1 | Remove-FGTFirewallPolicyMember -srcaddr $pester_address1, $pester_address2
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Remove 3 members to Policy Src Address $pester_address1, $pester_address2, $pester_address3 (with 3 members before)" {
            Get-FGTFirewallPolicy -Name $pester_policy1 | Remove-FGTFirewallPolicyMember -srcaddr $pester_address1, $pester_address2, $pester_address3
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be $null
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

    }

    Context "Remove Member(s) to Destination Address" {
        BeforeEach {
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr $pester_address1, $pester_address2, $pester_address3
        }

        It "Remove 1 member to Policy Dst Address $pester_address1 (with 3 members before)" {
            Get-FGTFirewallPolicy -Name $pester_policy1 | Remove-FGTFirewallPolicyMember -dstaddr $pester_address1
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -Be $pester_address2, $pester_address3
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Remove 2 members to Policy Dst Address $pester_address1, $pester_address2 (with 3 members before)" {
            Get-FGTFirewallPolicy -Name $pester_policy1 | Remove-FGTFirewallPolicyMember -dstaddr $pester_address1, $pester_address2
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be $pester_address3
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Remove 3 members to Policy Dst Address $pester_address1, $pester_address2, $pester_address3 (with 3 members before)" {
            Get-FGTFirewallPolicy -Name $pester_policy1 | Remove-FGTFirewallPolicyMember -dstaddr $pester_address1, $pester_address2, $pester_address3
            $policy = Get-FGTFirewallPolicy -name $pester_policy1
            $policy.name | Should -Be $pester_policy1
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcintf.name | Should -BeIn "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be $null
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.nat | Should -Be "disable"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}