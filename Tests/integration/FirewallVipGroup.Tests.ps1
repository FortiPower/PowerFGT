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

Describe "Get Firewall Vip Group" {

    BeforeAll {
        #Create Vip object
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        Add-FGTFirewallVip -Name $pester_vip2 -type static-nat -extip 192.2.0.2 -mappedip 198.51.100.2
        #Create vipgroup object with one member
        $script:addrgrp = Add-FGTFirewallVipGroup -name $pester_vipgroup1 -member $pester_vip1
        $script:uuid = $addrgrp.uuid
        Add-FGTFirewallVipGroup -name $pester_vipgroup2 -member $pester_vip2
    }

    It "Get Vip Group Does not throw an error" {
        {
            Get-FGTFirewallVipGroup
        } | Should -Not -Throw
    }

    It "Get ALL Vip Group" {
        $vipgroup = Get-FGTFirewallVipGroup
        $vipgroup.count | Should -Not -Be $NULL
    }

    It "Get ALL Vip Group with -skip" {
        $vipgroup = Get-FGTFirewallVipGroup -skip
        $vipgroup.count | Should -Not -Be $NULL
    }

    It "Get Vip Group ($pester_vipgroup1)" {
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
    }

    It "Get Vip Group ($pester_vipgroup1) and confirm (via Confirm-FGTVipGroup)" {
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        Confirm-FGTVipGroup ($vipgroup) | Should -Be $true
    }

    It "Get Vip Group ($pester_vipgroup1) and meta" {
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1 -meta
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.q_ref | Should -Not -BeNullOrEmpty
        $vipgroup.q_static | Should -Not -BeNullOrEmpty
        $vipgroup.q_no_rename | Should -Not -BeNullOrEmpty
        $vipgroup.q_global_entry | Should -Not -BeNullOrEmpty
        $vipgroup.q_type | Should -BeIn @('188', '197', '198', '206', '209')
        $vipgroup.q_path | Should -Be "firewall"
        $vipgroup.q_name | Should -Be "vipgrp"
        $vipgroup.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $vipgroup.q_no_edit | Should -Not -BeNullOrEmpty
        }
        $vipgroup.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search Vip Group by name ($pester_vipgroup1)" {
            $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
            @($vipgroup).count | Should -be 1
            $vipgroup.name | Should -Be $pester_vipgroup1
        }

        It "Search Vip Group by uuid ($script:uuid)" {
            $vipgroup = Get-FGTFirewallVipGroup -uuid $script:uuid
            @($vipgroup).count | Should -be 1
            $vipgroup.name | Should -Be $pester_vipgroup1
        }

    }

    AfterAll {
        #Remove vip group before vip...
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Remove-FGTFirewallVipGroup -confirm:$false
        Get-FGTFirewallVipGroup -name $pester_vipgroup2 | Remove-FGTFirewallVipGroup -confirm:$false

        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVip -confirm:$false
        Get-FGTFirewallVip -name $pester_vip2 | Remove-FGTFirewallVip -confirm:$false
    }

}

Describe "Add Firewall Vip Group" {

    BeforeAll {
        #Create some Vip object
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        Add-FGTFirewallVip -Name $pester_vip2 -type static-nat -extip 192.2.0.2 -mappedip 198.51.100.2
    }

    AfterEach {
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Remove-FGTFirewallVipGroup -confirm:$false
    }

    It "Add Vip Group $pester_vipgroup1 (with 1 member)" {
        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "1"
        $vipgroup.member.name | Should -BeIn $pester_vip1
        $vipgroup.comments | Should -BeNullOrEmpty
    }

    It "Add Vip Group $pester_vipgroup1 (with 1 member and a comments)" {
        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1 -comments "Add via PowerFGT"
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "1"
        $vipgroup.member.name | Should -BeIn $pester_vip1
        $vipgroup.comments | Should -Be "Add via PowerFGT"
    }

    It "Add Vip Group $pester_vipgroup1 (with 2 members)" {
        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1, $pester_vip2
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "2"
        $vipgroup.member.name | Should -BeIn $pester_vip1, $pester_vip2
        $vipgroup.comments | Should -BeNullOrEmpty
    }

    It "Add Vip Group $pester_vipgroup1 (with 1 member and data (1 field))" {
        $data = @{ "color" = "23" }
        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1 -data $data
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "1"
        $vipgroup.member.name | Should -BeIn $pester_vip1
        $vipgroup.comments | Should -BeNullOrEmpty
        $vipgroup.color | Should -Be "23"
    }

    It "Add Vip Group $pester_vipgroup1 (with 1 member and data (2 fields))" {
        $data = @{ "color" = "23" ; comments = "Add via PowerFGT with -data" }
        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1 -data $data
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "1"
        $vipgroup.member.name | Should -BeIn $pester_vip1
        $vipgroup.comments | Should -Be "Add via PowerFGT with -data"
        $vipgroup.color | Should -Be "23"
    }

    It "Try to Add Vip Group $pester_vipgroup1 (but there is already a object with same name)" {
        #Add first Vip Group
        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1
        #Add Second Vip Group with same name
        { Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1 } | Should -Throw "Already a VipGroup object using the same name"

    }

    AfterAll {
        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVip -confirm:$false
        Get-FGTFirewallVip -name $pester_vip2 | Remove-FGTFirewallVip -confirm:$false
    }

}

Describe "Add Firewall Vip Group Member" {

    BeforeAll {
        #Create some Vip object
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        Add-FGTFirewallVip -Name $pester_vip2 -type static-nat -extip 192.2.0.2 -mappedip 198.51.100.2
        Add-FGTFirewallVip -Name $pester_vip3 -type static-nat -extip 192.2.0.3 -mappedip 198.51.100.3
        Add-FGTFirewallVip -Name $pester_vip4 -type static-nat -extip 192.2.0.4 -mappedip 198.51.100.4
    }

    BeforeEach {
        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1
    }

    AfterEach {
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Remove-FGTFirewallVipGroup -confirm:$false
    }

    It "Add 1 member to Vip Group $pester_vipgroup1 (with 1 member before)" {
        Get-FGTFirewallVipGroup -Name $pester_vipgroup1 | Add-FGTFirewallVipGroupMember -member $pester_vip2
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "2"
        $vipgroup.member.name | Should -BeIn $pester_vip1, $pester_vip2
        $vipgroup.comments | Should -BeNullOrEmpty
    }

    It "Add 2 members to Vip Group $pester_vipgroup1 (with 1 member before)" {
        Get-FGTFirewallVipGroup -Name $pester_vipgroup1 | Add-FGTFirewallVipGroupMember -member $pester_vip2, $pester_vip3
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "3"
        $vipgroup.member.name | Should -BeIn $pester_vip1, $pester_vip2, $pester_vip3
        $vipgroup.comments | Should -BeNullOrEmpty
    }

    It "Add 2 members to Vip Group $pester_vipgroup1 (with 2 members before)" {
        Get-FGTFirewallVipGroup -Name $pester_vipgroup1 | Add-FGTFirewallVipGroupMember -member $pester_vip2
        Get-FGTFirewallVipGroup -Name $pester_vipgroup1 | Add-FGTFirewallVipGroupMember -member $pester_vip3, $pester_vip4
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "4"
        $vipgroup.member.name | Should -BeIn $pester_vip1, $pester_vip2, $pester_vip3, $pester_vip4
        $vipgroup.comments | Should -BeNullOrEmpty
    }

    AfterAll {
        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVip -confirm:$false
        Get-FGTFirewallVip -name $pester_vip2 | Remove-FGTFirewallVip -confirm:$false
        Get-FGTFirewallVip -name $pester_vip3 | Remove-FGTFirewallVip -confirm:$false
        Get-FGTFirewallVip -name $pester_vip4 | Remove-FGTFirewallVip -confirm:$false
    }

}

Describe "Configure Firewall Vip Group" {

    BeforeAll {
        #Create some Vip object
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        Add-FGTFirewallVip -Name $pester_vip2 -type static-nat -extip 192.2.0.2 -mappedip 198.51.100.1

        $addrgrp = Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1
        $script:uuid = $addrgrp.uuid
    }

    It "Change comments" {
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Set-FGTFirewallVipGroup -comments "Modified by PowerFGT"
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "1"
        $vipgroup.member.name | Should -BeIn $pester_vip1
        $vipgroup.comments | Should -Be "Modified by PowerFGT"
    }

    It "Change 1 Member ($pester_vip2)" {
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Set-FGTFirewallVipGroup -member $pester_vip2
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "1"
        $vipgroup.member.name | Should -BeIn $pester_vip2
        $vipgroup.comments | Should -Be "Modified by PowerFGT"
    }

    It "Change 2 Members ($pester_vip1 and $pester_vip2)" {
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Set-FGTFirewallVipGroup -member $pester_vip1, $pester_vip2
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "2"
        $vipgroup.member.name | Should -BeIn $pester_vip1, $pester_vip2
        $vipgroup.comments | Should -Be "Modified by PowerFGT"
    }

    It "Change -data (1 field)" {
        $data = @{ "color" = "23" }
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Set-FGTFirewallVipGroup -data $data
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "2"
        $vipgroup.member.name | Should -BeIn $pester_vip1, $pester_vip2
        $vipgroup.comments | Should -Be "Modified by PowerFGT"
        $vipgroup.color | Should -Be "23"
    }

    It "Change -data (2 fields)" {
        $data = @{ "color" = "4" ; comments = "Modified by PowerFGT with -data" }
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Set-FGTFirewallVipGroup -data $data
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "2"
        $vipgroup.member.name | Should -BeIn $pester_vip1, $pester_vip2
        $vipgroup.comments | Should -Be "Modified by PowerFGT with -data"
        $vipgroup.color | Should -Be "4"
    }

    It "Change Name" {
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Set-FGTFirewallVipGroup -name "pester_vipgroup1_change"
        $vipgroup = Get-FGTFirewallVipGroup -name "pester_vipgroup1_change"
        $vipgroup.name | Should -Be "pester_vipgroup1_change"
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "2"
        $vipgroup.member.name | Should -BeIn $pester_vip1, $pester_vip2
        $vipgroup.comments | Should -Be "Modified by PowerFGT with -data"
    }

    AfterAll {
        #Remove vip group before vip...
        Get-FGTFirewallVipGroup -uuid $script:uuid | Remove-FGTFirewallVipGroup -confirm:$false

        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVip -confirm:$false
        Get-FGTFirewallVip -name $pester_vip2 | Remove-FGTFirewallVip -confirm:$false
    }

}

Describe "Copy Firewall Vip Group" {

    BeforeAll {
        #Create some Vip object
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        Add-FGTFirewallVip -Name $pester_vip2 -type static-nat -extip 192.2.0.2 -mappedip 198.51.100.1

        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1, $pester_vip2
    }


    It "Copy Firewall Vip Group ($pester_vipgroup1 => copy_pester_vipgroup1)" {
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Copy-FGTFirewallVipGroup -name copy_pester_vipgroup1
        $vipgroup = Get-FGTFirewallVipGroup -name copy_pester_vipgroup1
        $vipgroup.name | Should -Be "copy_pester_vipgroup1"
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "2"
        $vipgroup.member.name | Should -BeIn $pester_vip1, $pester_vip2
        $vipgroup.comments | Should -BeNullOrEmpty
    }

    AfterAll {
        #Remove vip group before vip...

        #Remove copy_pester_vip1
        Get-FGTFirewallVipGroup -name copy_pester_vipgroup1 | Remove-FGTFirewallVipGroup -confirm:$false

        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Remove-FGTFirewallVipGroup -confirm:$false

        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVip -confirm:$false
        Get-FGTFirewallVip -name $pester_vip2 | Remove-FGTFirewallVip -confirm:$false
    }

}

Describe "Remove Firewall Vip Group" {

    BeforeEach {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1

        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1
    }

    It "Remove Vip Group $pester_vipgroup1 by pipeline" {
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup | Remove-FGTFirewallVipGroup -confirm:$false
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup | Should -Be $NULL
    }

    AfterAll {
        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVip -confirm:$false
    }

}

Describe "Remove Firewall Vip Group Member" {

    BeforeAll {
        #Create some Vip object
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        Add-FGTFirewallVip -Name $pester_vip2 -type static-nat -extip 192.2.0.2 -mappedip 198.51.100.2
        Add-FGTFirewallVip -Name $pester_vip3 -type static-nat -extip 192.2.0.3 -mappedip 198.51.100.3
    }

    BeforeEach {
        Add-FGTFirewallVipGroup -Name $pester_vipgroup1 -member $pester_vip1, $pester_vip2, $pester_vip3
    }

    AfterEach {
        Get-FGTFirewallVipGroup -name $pester_vipgroup1 | Remove-FGTFirewallVipGroup -confirm:$false
    }

    It "Remove 1 member to Vip Group $pester_vipgroup1 (with 3 members before)" {
        Get-FGTFirewallVipGroup -Name $pester_vipgroup1 | Remove-FGTFirewallVipGroupMember -member $pester_vip1
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "2"
        $vipgroup.member.name | Should -BeIn $pester_vip2, $pester_vip3
        $vipgroup.comments | Should -BeNullOrEmpty
    }

    It "Remove 2 members to Vip Group $pester_vipgroup1 (with 3 members before)" {
        Get-FGTFirewallVipGroup -Name $pester_vipgroup1 | Remove-FGTFirewallVipGroupMember -member $pester_vip2, $pester_vip3
        $vipgroup = Get-FGTFirewallVipGroup -name $pester_vipgroup1
        $vipgroup.name | Should -Be $pester_vipgroup1
        $vipgroup.uuid | Should -Not -BeNullOrEmpty
        ($vipgroup.member).count | Should -Be "1"
        $vipgroup.member.name | Should -BeIn $pester_vip1
        $vipgroup.comments | Should -BeNullOrEmpty
    }

    It "Try Remove 3 members to Vip Group $pester_vipgroup1 (with 3 members before)" {
        {
            Get-FGTFirewallVipGroup -Name $pester_vipgroup1 | Remove-FGTFirewallVipGroupMember -member $pester_vip1, $pester_vip2, $pester_vip3
        } | Should -Throw "You can't remove all members. Use Remove-FGTFirewallVipGroup to remove Vip Group"
    }

    AfterAll {
        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVip -confirm:$false
        Get-FGTFirewallVip -name $pester_vip2 | Remove-FGTFirewallVip -confirm:$false
        Get-FGTFirewallVip -name $pester_vip3 | Remove-FGTFirewallVip -confirm:$false
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}