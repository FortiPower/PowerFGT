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
        #Create servicegroup object with one member
        Add-FGTFirewallServiceGroup -name $pester_servicegroup1 -member HTTP
        Add-FGTFirewallServiceGroup -name $pester_servicegroup2 -member HTTPS
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
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
        Get-FGTFirewallServiceGroup -name $pester_servicegroup2 | Remove-FGTFirewallServiceGroup -confirm:$false
    }

}

Describe "Add Firewall Service Group" {

    AfterEach {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
    }

    It "Add Service Group $pester_servicegroup1 (with 1 member)" {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn HTTP
        $servicegroup.comment | Should -BeNullOrEmpty
    }

    It "Add Service Group $pester_servicegroup1 (with 1 member and a comment)" {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP -comment "Add via PowerFGT"
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn HTTP
        $servicegroup.comment | Should -Be "Add via PowerFGT"
    }

    It "Add Service Group $pester_servicegroup1 (with 2 members)" {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP, HTTPS
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn HTTP, HTTPS
        $servicegroup.comment | Should -BeNullOrEmpty
    }

    It "Add Service Group $pester_servicegroup1 (with 1 member and data (1 field))" {
        $data = @{ "color" = 23 }
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP -data $data
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn HTTP
        $servicegroup.comment | Should -BeNullOrEmpty
        $servicegroup.color | Should -Be "23"
    }

    It "Add Service Group $pester_servicegroup1 (with 1 member and data (2 fields))" {
        $data = @{ "color" = 23; "comment" = "Add via PowerFGT and -data" }
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP -data $data
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn HTTP
        $servicegroup.comment | Should -Be "Add via PowerFGT and -data"
        $servicegroup.color | Should -Be "23"
    }

    It "Try to Add Service Group $pester_servicegroup1 (but there is already a object with same name)" {
        #Add first Service Group
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP
        #Add Second Service Group with same name
        { Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP } | Should -Throw "Already a servicegroup object using the same name"
    }
}

Describe "Add Firewall Service Group Member" {

    BeforeEach {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP
    }

    AfterEach {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
    }

    It "Add 1 member to Service Group $pester_servicegroup1 (with 1 member before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Add-FGTFirewallServiceGroupMember -member HTTPS
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn HTTP, HTTPS
        $servicegroup.comment | Should -BeNullOrEmpty
    }

    It "Add 2 members to Service Group $pester_servicegroup1 (with 1 member before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Add-FGTFirewallServiceGroupMember -member HTTPS, POP3
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "3"
        $servicegroup.member.name | Should -BeIn HTTP, HTTPS, POP3
        $servicegroup.comment | Should -BeNullOrEmpty
    }

    It "Add 2 members to Service Group $pester_servicegroup1 (with 2 members before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Add-FGTFirewallServiceGroupMember -member HTTPS
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Add-FGTFirewallServiceGroupMember -member POP3, IMAP
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "4"
        $servicegroup.member.name | Should -BeIn HTTP, HTTPS, POP3, IMAP
        $servicegroup.comment | Should -BeNullOrEmpty
    }
}

Describe "Configure Firewall Service Group" {

    BeforeAll {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP
    }

    It "Change comment" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -comment "Modified by PowerFGT"
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn HTTP
        $servicegroup.comment | Should -Be "Modified by PowerFGT"
    }

    It "Change 1 Member (HTTPS)" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -member HTTPS
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn HTTPS
        $servicegroup.comment | Should -Be "Modified by PowerFGT"
    }

    It "Change 2 Members (HTTP and HTTPS)" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -member HTTP, HTTPS
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn HTTP, HTTPS
        $servicegroup.comment | Should -Be "Modified by PowerFGT"
    }

    It "Change -data (1 field)" {
        $data = @{ "color" = 23 }
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -data $data
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn HTTP, HTTPS
        $servicegroup.comment | Should -Be "Modified by PowerFGT"
        $servicegroup.color | Should -Be "23"
    }

    It "Change -data (2 fields)" {
        $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -data $data
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn HTTP, HTTPS
        $servicegroup.comment | Should -Be "Modified by PowerFGT via -data"
        $servicegroup.color | Should -Be "4"
    }

    It "Change Name" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Set-FGTFirewallServiceGroup -name "pester_servicegroup1_change"
        $servicegroup = Get-FGTFirewallServiceGroup -name "pester_servicegroup1_change"
        $servicegroup.name | Should -Be "pester_servicegroup1_change"
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn HTTP, HTTPS
        $servicegroup.comment | Should -Be "Modified by PowerFGT via -data"
    }

    AfterAll {
        Get-FGTFirewallServiceGroup -name 'pester_servicegroup1_change' | Remove-FGTFirewallServiceGroup -confirm:$false
    }
}

Describe "Copy Firewall Service Group" {

    BeforeAll {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP, HTTPS
    }


    It "Copy Firewall Service Group ($pester_servicegroup1 => copy_pester_servicegroup1)" {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Copy-FGTFirewallServiceGroup -name copy_pester_servicegroup1
        $servicegroup = Get-FGTFirewallServiceGroup -name copy_pester_servicegroup1
        $servicegroup.name | Should -Be "copy_pester_servicegroup1"
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn HTTP, HTTPS
        $servicegroup.comment | Should -BeNullOrEmpty

    }

    AfterAll {
        #Remove copy_pester_service1
        Get-FGTFirewallServiceGroup -name copy_pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
    }

}

Describe "Remove Firewall Service Group" {

    BeforeEach {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP
    }

    It "Remove Service Group $pester_servicegroup1 by pipeline" {
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup | Remove-FGTFirewallServiceGroup -confirm:$false
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup | Should -Be $NULL
    }
}

Describe "Remove Firewall Service Group Member" {

    BeforeEach {
        Add-FGTFirewallServiceGroup -Name $pester_servicegroup1 -member HTTP, HTTPS, POP3
    }

    AfterEach {
        Get-FGTFirewallServiceGroup -name $pester_servicegroup1 | Remove-FGTFirewallServiceGroup -confirm:$false
    }

    It "Remove 1 member to Service Group $pester_servicegroup1 (with 3 members before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Remove-FGTFirewallServiceGroupMember -member HTTP
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "2"
        $servicegroup.member.name | Should -BeIn HTTPS, POP3
        $servicegroup.comment | Should -BeNullOrEmpty

    }

    It "Remove 2 members to Service Group $pester_servicegroup1 (with 3 members before)" {
        Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Remove-FGTFirewallServiceGroupMember -member HTTPS, POP3
        $servicegroup = Get-FGTFirewallServiceGroup -name $pester_servicegroup1
        $servicegroup.name | Should -Be $pester_servicegroup1
        ($servicegroup.member).count | Should -Be "1"
        $servicegroup.member.name | Should -BeIn HTTP
        $servicegroup.comment | Should -BeNullOrEmpty

    }

    It "Try Remove 3 members to Service Group $pester_servicegroup1 (with 3 members before)" {
        {
            Get-FGTFirewallServiceGroup -Name $pester_servicegroup1 | Remove-FGTFirewallServiceGroupMember -member HTTP, HTTPS, POP3
        } | Should -Throw "You can't remove all members. Use Remove-FGTFirewallServiceGroup to remove Service Group"
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}