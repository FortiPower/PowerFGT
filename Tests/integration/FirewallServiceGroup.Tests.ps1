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

Describe "Get Firewall Service Group" {

    BeforeAll {
        #Create Service object
        Add-FGTFirewallServiceCustom -Name $pester_service1 -tcp_port '8080'
        Add-FGTFirewallServiceCustom -Name $pester_service2 -tcp_port '8080'
        #Create servicegroup object with one member
        $script:servgrp = Add-FGTFirewallServiceGroup -name $pester_servicegroup1 -member $pester_service1
        Add-FGTFirewallServiceGroup -name $pester_servicegroup2 -member $pester_service2
    }

    It "Get Service Group Does not throw an error" {
        {
            Get-FGTFirewallServiceGroup
        } | Should -Not -Throw
    }

    It "Get ALL Service Group" {
        $servicegroup = Get-FGTFirewallServiceGroup
        $servicegroup.count | Should -Not -Be $NULL
    }

    It "Get ALL Service Group with -skip" {
        $servicegroup = Get-FGTFirewallServiceGroup -skip
        $servicegroup.count | Should -Not -Be $NULL
    }

    It "Get Service Group ($pester_servicegroup1)" {
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
    }

    It "Get Service Group ($pester_servicegroup1) and confirm (via Confirm-FGTServiceGroup)" {
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        Confirm-FGTServiceGroup ($servicegroup) | Should -Be $true
    }

    It "Get Service Group ($pester_servicegroup1) and meta" {
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1 -meta
        $servicegroup.name | Should -Be $pester_servicegroup1
        $servicegroup.q_ref | Should -Not -BeNullOrEmpty
        $servicegroup.q_static | Should -Not -BeNullOrEmpty
        $servicegroup.q_no_rename | Should -Not -BeNullOrEmpty
        $servicegroup.q_global_entry | Should -Not -BeNullOrEmpty
        $servicegroup.q_type | Should -Not -BeNullOrEmpty
        $servicegroup.q_path | Should -Be "firewall.service"
        $servicegroup.q_name | Should -Be "group"
        $servicegroup.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $servicegroup.q_no_edit | Should -Not -BeNullOrEmpty
        }
        $servicegroup.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search Service Group by name ($pester_servicegroup1)" {
            $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
            @($servicegroup).count | Should -be 1
            $servicegroup.name | Should -Be $pester_servicegroup1
        }

    }

    AfterAll {
        #Remove service group before service...
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
        Get-FGTFirewallServiceGroup -name $pester_servicegroup2 | Remove-FGTFirewallServiceGroup -confirm:$false

        Get-FGTFirewallServiceCustom -name $pester_service1 | Remove-FGTFirewallServiceCustom -confirm:$false
        Get-FGTFirewallServiceCustom -name $pester_service2 | Remove-FGTFirewallServiceCustom -confirm:$false
    }

}

Describe "Add Firewall Service Group" {

    BeforeAll {
        #Create some Service object
        Add-FGTFirewallServiceCustom -Name $pester_service1 -tcp_port '8080'
        Add-FGTFirewallServiceCustom -Name $pester_service2 -tcp_port '8080'
    }

    AfterEach {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
    }

    It "Add Service Group $pester_servicegroup1 (with 1 member)" {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn $pester_service1
        $servicegroup.comment | Should -BeNullOrEmpty
    }

    It "Add Service Group $pester_servicegroup1 (with 1 member and a comment)" {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1 -comment "Add via PowerFGT"
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn $pester_service1
        $servicegroup.comment | Should -Be "Add via PowerFGT"
    }

    It "Add Service Group $pester_servicegroup1 (with 2 members)" {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1, $pester_service2
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn $pester_service1, $pester_service2
        $servicegroup.comment | Should -BeNullOrEmpty
    }

    It "Add Service Group $pester_servicegroup1 (with 1 member and data (1 field))" {
        $data = @{ "color" = 23 }
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1 -data $data
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn $pester_service1
        $servicegroup.comment | Should -BeNullOrEmpty
        $servicegroup.color | Should -Be "23"
    }

    It "Add Service Group $pester_servicegroup1 (with 1 member and data (2 fields))" {
        $data = @{ "color" = 23; "comment" = "Add via PowerFGT and -data" }
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1 -data $data
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn $pester_service1
        $servicegroup.comment | Should -Be "Add via PowerFGT and -data"
        $servicegroup.color | Should -Be "23"
    }

    It "Try to Add Service Group $pester_servicegroup1 (but there is already a object with same name)" {
        #Add first Service Group
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1
        #Add Second Service Group with same name
        { Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1 } | Should -Throw "Already a servicegroup object using the same name"

    }

    AfterAll {
        Get-FGTFirewallServiceCustom -name $pester_service1 | Remove-FGTFirewallServiceCustom -confirm:$false
        Get-FGTFirewallServiceCustom -name $pester_service2 | Remove-FGTFirewallServiceCustom -confirm:$false
    }

}

Describe "Add Firewall Service Group Member" {

    BeforeAll {
        #Create some Service object
        Add-FGTFirewallServiceCustom -Name $pester_service1 -tcp_port '8080'
        Add-FGTFirewallServiceCustom -Name $pester_service2 -tcp_port '8080'
        Add-FGTFirewallServiceCustom -Name $pester_service3 -tcp_port '8080'
        Add-FGTFirewallServiceCustom -Name $pester_service4 -tcp_port '8080'
    }

    BeforeEach {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1
    }

    AfterEach {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
    }

    It "Add 1 member to Service Group $pester_servicegroup1 (with 1 member before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Add-FGTFirewallServiceGroupMember -member $pester_service2
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn $pester_service1, $pester_service2
        $servicegroup.comment | Should -BeNullOrEmpty
    }

    It "Add 2 members to Service Group $pester_servicegroup1 (with 1 member before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Add-FGTFirewallServiceGroupMember -member $pester_service2, $pester_service3
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "3"
        $servicegroup.member.name | Should -BeIn $pester_service1, $pester_service2, $pester_service3
        $servicegroup.comment | Should -BeNullOrEmpty
    }

    It "Add 2 members to Service Group $pester_servicegroup1 (with 2 members before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Add-FGTFirewallServiceGroupMember -member $pester_service2
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Add-FGTFirewallServiceGroupMember -member $pester_service3, $pester_service4
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "4"
        $servicegroup.member.name | Should -BeIn $pester_service1, $pester_service2, $pester_service3, $pester_service4
        $servicegroup.comment | Should -BeNullOrEmpty
    }

    AfterAll {
        Get-FGTFirewallServiceCustom -name $pester_service1 | Remove-FGTFirewallServiceCustom -confirm:$false
        Get-FGTFirewallServiceCustom -name $pester_service2 | Remove-FGTFirewallServiceCustom -confirm:$false
        Get-FGTFirewallServiceCustom -name $pester_service3 | Remove-FGTFirewallServiceCustom -confirm:$false
        Get-FGTFirewallServiceCustom -name $pester_service4 | Remove-FGTFirewallServiceCustom -confirm:$false
    }

}

Describe "Configure Firewall Service Group" {

    BeforeAll {
        #Create some Service object
        Add-FGTFirewallServiceCustom -Name $pester_service1 -tcp_port 8080
        Add-FGTFirewallServiceCustom -Name $pester_service2 -tcp_port 8080
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1
    }

    It "Change comment" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -comment "Modified by PowerFGT"
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn $pester_service1
        $servicegroup.comment | Should -Be "Modified by PowerFGT"
    }

    It "Change 1 Member ($pester_service2)" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -member $pester_service2
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn $pester_service2
        $servicegroup.comment | Should -Be "Modified by PowerFGT"
    }

    It "Change 2 Members ($pester_service1 and $pester_service2)" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -member $pester_service1, $pester_service2
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn $pester_service1, $pester_service2
        $servicegroup.comment | Should -Be "Modified by PowerFGT"
    }

    It "Change -data (1 field)" {
        $data = @{ "color" = 23 }
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -data $data
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn $pester_service1, $pester_service2
        $servicegroup.comment | Should -Be "Modified by PowerFGT"
        $servicegroup.color | Should -Be "23"
    }

    It "Change -data (2 fields)" {
        $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -data $data
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn $pester_service1, $pester_service2
        $servicegroup.comment | Should -Be "Modified by PowerFGT via -data"
        $servicegroup.color | Should -Be "4"
    }

    It "Change Name" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -name "pester_servicegroup1_change"
        $servicegroup = Get-FGTFirewallServiceGroup -name "pester_servicegroup1_change"
        $servicegroup.name | Should -Be "pester_servicegroup1_change"
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn $pester_service1, $pester_service2
        $servicegroup.comment | Should -Be "Modified by PowerFGT via -data"
    }

    AfterAll {
        Get-FGTFirewallServiceGroup -name 'pester_servicegroup1_change' | Remove-FGTFirewallServiceGroup -confirm:$false

        Get-FGTFirewallServiceCustom -name $pester_service1 | Remove-FGTFirewallServiceCustom -confirm:$false
        Get-FGTFirewallServiceCustom -name $pester_service2 | Remove-FGTFirewallServiceCustom -confirm:$false
    }

}

Describe "Copy Firewall Service Group" {

    BeforeAll {
        #Create some Service object
        Add-FGTFirewallServiceCustom -Name $pester_service1 -tcp_port '8080'
        Add-FGTFirewallServiceCustom -Name $pester_service2 -tcp_port '8080'

        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1, $pester_service2
    }


    It "Copy Firewall Service Group ($pester_servicegroup1 => copy_pester_servicegroup1)" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Copy-FGTFirewallServiceGroup -name copy_pester_servicegroup1
        $servicegroup = Get-FGTFirewallServiceGroup -name copy_pester_servicegroup1
        $servicegroup.name | Should -Be "copy_pester_servicegroup1"
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn $pester_service1, $pester_service2
        $servicegroup.comment | Should -BeNullOrEmpty

    }

    AfterAll {
        #Remove service group before service...

        #Remove copy_pester_service1
        Get-FGTFirewallServiceGroup -name copy_pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false

        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false

        Get-FGTFirewallServiceCustom -name $pester_service1 | Remove-FGTFirewallServiceCustom -confirm:$false
        Get-FGTFirewallServiceCustom -name $pester_service2 | Remove-FGTFirewallServiceCustom -confirm:$false
    }

}

Describe "Remove Firewall Service Group" {

    BeforeEach {
        Add-FGTFirewallServiceCustom -Name $pester_service1 -tcp_port '8080'

        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1
    }

    It "Remove Service Group $pester_servicegroup1 by pipeline" {
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup | Remove-FGTFirewallServiceGroup -confirm:$false
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup | Should -Be $NULL
    }

    AfterAll {
        Get-FGTFirewallServiceCustom -name $pester_service1 | Remove-FGTFirewallServiceCustom -confirm:$false
    }

}

Describe "Remove Firewall Service Group Member" {

    BeforeAll {
        #Create some Service object
        Add-FGTFirewallServiceCustom -Name $pester_service1 -tcp_port '8080'
        Add-FGTFirewallServiceCustom -Name $pester_service2 -tcp_port '8080'
        Add-FGTFirewallServiceCustom -Name $pester_service3 -tcp_port '8080'
    }

    BeforeEach {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member $pester_service1, $pester_service2, $pester_service3
    }

    AfterEach {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
    }

    It "Remove 1 member to Service Group $pester_servicegroup1 (with 3 members before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Remove-FGTFirewallServiceGroupMember -member $pester_service1
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn $pester_service2, $pester_service3
        $servicegroup.comment | Should -BeNullOrEmpty

    }

    It "Remove 2 members to Service Group $pester_servicegroup1 (with 3 members before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Remove-FGTFirewallServiceGroupMember -member $pester_service2, $pester_service3
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn $pester_service1
        $servicegroup.comment | Should -BeNullOrEmpty

    }

    It "Try Remove 3 members to Service Group $pester_servicegroup1 (with 3 members before)" {
        {
            Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Remove-FGTFirewallServiceGroupMember -member $pester_service1, $pester_service2, $pester_service3
        } | Should -Throw "You can't remove all members. Use Remove-FGTFirewallServiceGroup to remove Service Group"
    }

    AfterAll {
        Get-FGTFirewallServiceCustom -name $pester_service1 | Remove-FGTFirewallServiceCustom -confirm:$false
        Get-FGTFirewallServiceCustom -name $pester_service2 | Remove-FGTFirewallServiceCustom -confirm:$false
        Get-FGTFirewallServiceCustom -name $pester_service3 | Remove-FGTFirewallServiceCustom -confirm:$false
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}