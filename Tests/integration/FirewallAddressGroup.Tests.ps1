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
        $script:uuid = $addgrp.uuid
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

Disconnect-FGT -noconfirm
