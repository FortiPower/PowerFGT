#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get Firewall Address Group" {

    BeforeAll {
        #Create Address object
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        #Add-FGTFirewallAddress -type ipmask -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        #Add-FGTFirewallAddress -type ipmask -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
        #Add-FGTFirewallAddress -type ipmask -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
        #Create addressgroup object with d object
        $script:addrgrp = Add-FGTFirewallAddressGroup -name $pester_addressgroup -member $pester_address1
        $script:uuid = $addrgrp.uuid
    }

    It "Get Address Group Does not throw an error" {
        {
            Get-FGTFirewallAddressGroup
        } | Should Not Throw
    }

    It "Get ALL Address Group" {
        $addressgroup = Get-FGTFirewallAddressGroup
        $addressgroup.count | Should -Not -Be $NULL
    }

    It "Get ALL Address Group with -skip" {
        $addressgroup = Get-FGTFirewallAddressGroup -skip
        $addressgroup.count | Should -Not -Be $NULL
    }

    It "Get Address Group ($pester_addressgroup)" {
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        $addressgroup.name | Should -Be $pester_addressgroup
    }

    It "Get Address Group ($pester_addressgroup) and confirm (via Confirm-FGTAddressGroup)" {
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        Confirm-FGTAddressGroup ($addressgroup) | Should -Be $true
    }

    Context "Search" {

        It "Search Address Group by name ($pester_addressgroup)" {
            $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
            @($addressgroup).count | Should -be 1
            $addressgroup.name | Should -Be $pester_addressgroup
        }

        It "Search Address Group by uuid ($script:uuid)" {
            $addressgroup = Get-FGTFirewallAddressGroup -uuid $script:uuid
            @($addressgroup).count | Should -be 1
            $addressgroup.name | Should -Be $pester_addressgroup
        }

    }

    AfterAll {
        #Remove address group before address...
        Get-FGTFirewallAddressGroup -name $pester_addressgroup | Remove-FGTFirewallAddressGroup -noconfirm

        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
    }

}

Describe "Add Firewall Address Group" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -type ipmask -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
    }

    AfterEach {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup | Remove-FGTFirewallAddressGroup -noconfirm
    }

    It "Add Address Group $pester_addressgroup (with 1 member)" {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup -member $pester_address1
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        $addressgroup.name | Should -Be $pester_addressgroup
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -BeNullOrEmpty
        $addressgroup.visibility | Should -Be $true
    }

    It "Add Address Group $pester_addressgroup (with 1 member and a comment)" {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup -member $pester_address1 -comment "Add via PowerFGT"
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        $addressgroup.name | Should -Be $pester_addressgroup
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -Be "Add via PowerFGT"
        $addressgroup.visibility | Should -Be $true
    }

    It "Add Address Group $pester_addressgroup (with 1 member and visibility disable)" {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup -member $pester_address1 -visibility:$false
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        $addressgroup.name | Should -Be $pester_addressgroup
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -BeNullOrEmpty
        $addressgroup.visibility | Should -Be "disable"
    }

    It "Add Address Group $pester_addressgroup (with 2 members)" {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup -member $pester_address1, $pester_address2
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        $addressgroup.name | Should -Be $pester_addressgroup
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -BeNullOrEmpty
        $addressgroup.visibility | Should -Be $true
    }

    It "Try to Add Address Group $pester_addressgroup (but there is already a object with same name)" {
        #Add first Address Group
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup -member $pester_address1
        #Add Second Address Group with same name
        { Add-FGTFirewallAddressGroup -Name $pester_addressgroup -member $pester_address1 } | Should -Throw "Already an addressgroup object using the same name"

    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -noconfirm
    }

}

Describe "Configure Firewall Address Group" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -type ipmask -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255

        $addrgrp = Add-FGTFirewallAddressGroup -Name $pester_addressgroup -member $pester_address1
        $script:uuid = $addrgrp.uuid
    }

    It "Change comment" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup | Set-FGTFirewallAddressGroup -comment "Modified by PowerFGT"
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        $addressgroup.name | Should -Be $pester_addressgroup
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        $addressgroup.visibility | Should -Be $true
    }

    It "Change visiblity" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup | Set-FGTFirewallAddressGroup -visibility:$false
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        $addressgroup.name | Should -Be $pester_addressgroup
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        $addressgroup.visibility | Should -Be "disable"
    }

    It "Change 1 Member ($pester_address2)" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup | Set-FGTFirewallAddressGroup -member $pester_address2
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        $addressgroup.name | Should -Be $pester_addressgroup
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address2
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        $addressgroup.visibility | Should -Be "disable"
    }

    It "Change 2 Members ($pester_address1 and $pester_address2)" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup | Set-FGTFirewallAddressGroup -member $pester_address1, $pester_address2
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup
        $addressgroup.name | Should -Be $pester_addressgroup
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        $addressgroup.visibility | Should -Be "disable"
    }

    It "Change Name" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup | Set-FGTFirewallAddressGroup -name "pester_addressgroup_change"
        $addressgroup = Get-FGTFirewallAddressGroup -name "pester_addressgroup_change"
        $addressgroup.name | Should -Be "pester_addressgroup_change"
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        $addressgroup.visibility | Should -Be "disable"
    }

    AfterAll {
        #Remove address group before address...
        Get-FGTFirewallAddressGroup -uuid $script:uuid | Remove-FGTFirewallAddressGroup -noconfirm

        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -noconfirm
    }

}

Describe "Copy Firewall Address Group" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -type ipmask -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255

        Add-FGTFirewallAddressGroup -Name $pester_addressgroup -member $pester_address1, $pester_address2
    }


    It "Copy Firewall Address Group ($pester_addressgroup => copy_pester_addressgroup1)" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup | Copy-FGTFirewallAddressGroup -name copy_pester_addressgroup1
        $addressgroup = Get-FGTFirewallAddressGroup -name copy_pester_addressgroup1
        $addressgroup.name | Should -Be "copy_pester_addressgroup1"
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -BeNullOrEmpty
        $addressgroup.visibility | Should -Be $true
    }

    AfterAll {
        #Remove address group before address...

        #Remove copy_pester_address1
        Get-FGTFirewallAddressGroup -name copy_pester_addressgroup1 | Remove-FGTFirewallAddressGroup -noconfirm

        Get-FGTFirewallAddressGroup -name $pester_addressgroup | Remove-FGTFirewallAddressGroup -noconfirm

        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -noconfirm
    }

}

Disconnect-FGT -noconfirm
