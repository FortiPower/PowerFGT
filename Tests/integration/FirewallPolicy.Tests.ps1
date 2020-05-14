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
        Get-FGTFirewallPolicy -name $pester_policy2 | Remove-FGTFirewallPolicy -noconfirm
    }

}

Describe "Add Firewall Policy" {

    AfterEach {
        Get-FGTFirewallPolicy -name $pester_policy1 | Remove-FGTFirewallPolicy -noconfirm
    }

    It "Add Policy $pester_policy1 (port1/port2 : All/All)" {
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1, port3 -dstintf port2 -srcaddr all -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2, port4 -srcaddr all -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1, port3 -dstintf port2, port4 -srcaddr all -dstaddr all
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
            Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
            Add-FGTFirewallAddress -type ipmask -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
            Add-FGTFirewallAddress -type ipmask -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
            Add-FGTFirewallAddress -type ipmask -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
        }

        It "Add Policy $pester_policy1 (src addr: $pester_address1 and dst addr: all)" {
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1 -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1, $pester_address3 -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr $pester_address2
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr $pester_address2, $pester_address4
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1, $pester_address3 -dstaddr $pester_address2, $pester_address4
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
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
            Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -noconfirm
            Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -noconfirm
            Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -noconfirm
        }

    }

    It "Add Policy $pester_policy1 (with nat)" {
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -nat
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
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action deny
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
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action deny -log all
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
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -status:$false
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
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service HTTP
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
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service HTTP, HTTPS
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
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -logtraffic all
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
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -logtraffic disable
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
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -schedule none
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
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -comments "Add via PowerFGT"
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

    #Disable missing API for create IP Pool
    It "Add Policy $pester_policy1 (with IP Pool)" -skip:$true {
        Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -nat -ippool "MyIPPool"
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

}

Describe "Add Firewall Policy Member" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -type ipmask -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTFirewallAddress -type ipmask -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
        Add-FGTFirewallAddress -type ipmask -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
    }

    AfterEach {
        Get-FGTFirewallPolicy -name $pester_policy1 | Remove-FGTFirewallPolicy -noconfirm
    }

    Context "Add Member(s) to Source Address" {

        It "Add 1 member to Policy Src Address $pester_address1 (with All before)" {
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1 -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr $pester_address2
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
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
            Add-FGTFirewallPolicy -name $pester_policy1 -srcintf port1 -dstintf port2 -srcaddr $pester_address1 -dstaddr $pester_address2
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
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -noconfirm
        Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -noconfirm
        Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -noconfirm
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

Describe "Remove Firewall Policy Member" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -type ipmask -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTFirewallAddress -type ipmask -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
    }

    AfterEach {
        Get-FGTFirewallPolicy -name $pester_policy1 | Remove-FGTFirewallPolicy -noconfirm
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
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -noconfirm
        Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -noconfirm
    }

}

Disconnect-FGT -noconfirm
