#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get System Interface" {

    BeforeAll {
        Add-FGTSystemInterface -name PowerFGT -type vlan -role lan -mode static -vdom_interface root -interface port10 -vlan_id 10
    }
    AfterAll {
        $remove = Get-FGTSystemInterface -name PowerFGT 
        $remove.name | Remove-FGTSystemInterface -confirm:$false
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
        $remove = Get-FGTSystemInterface -name PowerFGT 
        $remove.name | Remove-FGTSystemInterface -confirm:$false
    }

    It "Add System Interface" {
        Add-FGTSystemInterface -name PowerFGT -type vlan -alias Alias_PowerFGT -role lan -vlan_id 10 -interface port10 -admin_access https,ping,ssh -connected $true -device_identification $true -mode static -address_mask 192.0.2.1/255.255.255.0 -vdom_interface root
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface.name | Should -Be "PowerFGT"
        $interface.type | Should -Be "vlan"
        $interface.alias | Should -Be "Alias_PowerFGT"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be 10
        $interface.interface | Should -Be "port10"
        $interface.allowaccess | Should -Be "ping https ssh"
        $interface.status | Should -Be "up"
        $interface."device-identification" | Should -Be "enable"
        $interface.mode | Should -Be "static"
        $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
    }

    It "Add System Interface with only mandatory parameters" {
        Add-FGTSystemInterface -name PowerFGT -type vlan -role lan -mode static -vdom_interface root -interface port10 -vlan_id 10
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface.name | Should -Be "PowerFGT"
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be 10
        $interface.interface | Should -Be "port10"
        $interface.mode | Should -Be "static"
    }

}

Describe "Set System Interface" {

    BeforeAll {
        Add-FGTSystemInterface -name PowerFGT -type vlan -role lan -mode static -vdom_interface root -interface port10 -vlan_id 10
    }
    AfterAll {
        $remove = Get-FGTSystemInterface -name PowerFGT 
        $remove.name | Remove-FGTSystemInterface -confirm:$false
    }

    It "Set System Interface alias" {
        Set-FGTSystemInterface -name PowerFGT -alias Set_PowerFGT
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface.alias | Should -Be "Set_PowerFGT"
    }

    It "Set System Interface role" {
        Set-FGTSystemInterface -name PowerFGT -role dmz
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface.role | Should -Be "dmz"
    }

    It "Set System Interface ip" {
        Set-FGTSystemInterface -name PowerFGT -address_mask 192.0.2.1/255.255.255.0
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
    }

    It "Set System Interface connected" {
        Set-FGTSystemInterface -name PowerFGT -connected $true
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface.status | Should -Be "up"
    }

    It "Set System Interface device-identification" {
        Set-FGTSystemInterface -name PowerFGT -device_identification $true
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface."device-identification" | Should -Be "enable"
    }

    It "Set System Interface mode" {
        Set-FGTSystemInterface -name PowerFGT -mode dhcp
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface.mode | Should -Be "dhcp"
    }

    It "Set System Interface administrative access" {
        Set-FGTSystemInterface -name PowerFGT -admin_access https,ssh
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface.allowaccess | Should -Be "https ssh"
    }

}

Describe "Remove System Interface" {

    BeforeEach {
        Add-FGTSystemInterface -name PowerFGT -type vlan -role lan -mode static -vdom_interface root -interface port10 -vlan_id 10
    }

    It "Remove System Interface by name" {
        Remove-FGTSystemInterface -name PowerFGT -confirm:$false
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface | Should -Be $NULL
    }

    It "Remove System Interface by pipeline" {
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface.name | Remove-FGTSystemInterface -confirm:$false
        $interface = Get-FGTSystemInterface -name PowerFGT
        $interface | Should -Be $NULL
    }

}

Disconnect-FGT -confirm:$false
