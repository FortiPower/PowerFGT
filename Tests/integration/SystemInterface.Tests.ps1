#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get System Interface" {

    BeforeAll {
        Add-FGTSystemInterface -name $pester_zone1 -type vlan -role lan -mode static -vdom_interface root -interface $pester_port1 -vlan_id 10
    }
    AfterAll {
        Get-FGTSystemInterface -name $pester_zone1 | Remove-FGTSystemInterface
    }

    It "Get interface does not throw an error" {
        {
            Get-FGTSystemInterface
        } | Should -Not -Throw
    }

    It "Get ALL interfaces" {
        $interface = Get-FGTSystemInterface
        $interface.count | Should -Not -Be $NULL
    }

    It "Get ALL interface with -skip" {
        $interface = Get-FGTSystemInterface -skip
        $interface.count | Should -Not -Be $NULL
    }

    It "Get interface port1" {
        $interface = Get-FGTSystemInterface -name port1
        $interface.name | Should -Be "port1"
    }

}

Describe "Add System Interface" {

    AfterEach {
        Get-FGTSystemInterface -name $pester_zone1 | Remove-FGTSystemInterface
    }

    It "Add System Interface" {
        Add-FGTSystemInterface -name $pester_zone1 -type vlan -alias Alias_$pester_zone1 -role lan -vlan_id 10 -interface $pester_port1 -admin_access https,ping,ssh -connected $true -device_identification $true -mode static -address_mask 192.0.2.1/255.255.255.0 -vdom_interface root
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface.name | Should -Be $pester_zone1
        $interface.type | Should -Be "vlan"
        $interface.alias | Should -Be "Alias_$pester_zone1"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be 10
        $interface.interface | Should -Be $pester_port1
        $interface.allowaccess | Should -Be "ping https ssh"
        $interface.status | Should -Be "up"
        $interface."device-identification" | Should -Be "enable"
        $interface.mode | Should -Be "static"
        $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
    }

    It "Add System Interface with only mandatory parameters" {
        Add-FGTSystemInterface -name $pester_zone1 -type vlan -role lan -mode static -vdom_interface root -interface $pester_port1 -vlan_id 10
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface.name | Should -Be $pester_zone1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be 10
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
    }

}

Describe "Set System Interface" {

    BeforeAll {
        Add-FGTSystemInterface -name $pester_zone1 -type vlan -role lan -mode static -vdom_interface root -interface $pester_port1 -vlan_id 10
    }
    AfterAll {
        Get-FGTSystemInterface -name $pester_zone1 | Remove-FGTSystemInterface
    }

    It "Set System Interface alias" {
        Set-FGTSystemInterface -name $pester_zone1 -alias Set_$pester_zone1
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface.alias | Should -Be "Set_$pester_zone1"
    }

    It "Set System Interface role" {
        Set-FGTSystemInterface -name $pester_zone1 -role dmz
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface.role | Should -Be "dmz"
    }

    It "Set System Interface ip" {
        Set-FGTSystemInterface -name $pester_zone1 -address_mask 192.0.2.1/255.255.255.0
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
    }

    It "Set System Interface connected" {
        Set-FGTSystemInterface -name $pester_zone1 -connected $true
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface.status | Should -Be "up"
    }

    It "Set System Interface device-identification" {
        Set-FGTSystemInterface -name $pester_zone1 -device_identification $true
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface."device-identification" | Should -Be "enable"
    }

    It "Set System Interface mode" {
        Set-FGTSystemInterface -name $pester_zone1 -mode dhcp
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface.mode | Should -Be "dhcp"
    }

    It "Set System Interface administrative access" {
        Set-FGTSystemInterface -name $pester_zone1 -admin_access https,ssh
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface.allowaccess | Should -Be "https ssh"
    }

}

Describe "Remove System Interface" {

    BeforeEach {
        Add-FGTSystemInterface -name $pester_zone1 -type vlan -role lan -mode static -vdom_interface root -interface $pester_port1 -vlan_id 10
    }

    It "Remove System Interface by pipeline" {
        Get-FGTSystemInterface -name $pester_zone1 | Remove-FGTSystemInterface
        $interface = Get-FGTSystemInterface -name $pester_zone1
        $interface | Should -Be $NULL
    }

}

Disconnect-FGT -confirm:$false
