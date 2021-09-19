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

Describe "Get System Interface" {

    BeforeAll {
        Add-FGTSystemInterface -name $pester_int1 -type vlan -role lan -mode static -vdom_interface root -interface $pester_port1 -vlan_id $pester_vlanid1
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

    It "Get interface pester_port1" {
        $interface = Get-FGTSystemInterface -name $pester_port1
        $interface.name | Should -Be $pester_port1
    }

    AfterAll {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
    }
}

Describe "Add System Interface" {

    AfterEach {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
    }

    It "Add System Interface with only mandatory parameters" {
        Add-FGTSystemInterface -name $pester_int1 -type vlan -role lan -mode static -vdom_interface root -interface $pester_port1 -vlan_id 10
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be 10
        $interface.interface | Should -Be $pester_port1
        $interface.mode | Should -Be "static"
    }

    It "Add System Interface" {
        Add-FGTSystemInterface -name $pester_int1 -type vlan -alias Alias_$pester_int1 -role lan -vlan_id $pester_vlanid1 -interface $pester_port1 -admin_access https, ping, ssh -status up -device_identification $true -mode static -ip 192.0.2.1 -netmask 255.255.255.0 -vdom_interface root
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
        $interface.type | Should -Be "vlan"
        $interface.alias | Should -Be "Alias_$pester_int1"
        $interface.role | Should -Be "lan"
        $interface.vlanid | Should -Be $pester_vlanid1
        $interface.interface | Should -Be $pester_port1
        $interface.allowaccess | Should -Be "ping https ssh"
        $interface.status | Should -Be "up"
        $interface."device-identification" | Should -Be "enable"
        $interface.mode | Should -Be "static"
        $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
    }

}

Describe "Set System Interface" {

    BeforeAll {
        Add-FGTSystemInterface -name $pester_int1 -type vlan -role lan -mode static -vdom_interface root -interface $pester_port1 -vlan_id $pester_vlanid1
    }

    It "Set System Interface alias" {
        Set-FGTSystemInterface -name $pester_int1 -alias Set_$pester_int1
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.alias | Should -Be "Set_$pester_int1"
    }

    It "Set System Interface role" {
        Set-FGTSystemInterface -name $pester_int1 -role dmz
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.role | Should -Be "dmz"
    }

    It "Set System Interface ip" {
        Set-FGTSystemInterface -name $pester_int1 -ip 192.0.2.1 -netmask 255.255.255.0
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
    }

    It "Set System Interface disconnected" {
        Set-FGTSystemInterface -name $pester_int1 -status down
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.status | Should -Be "down"
    }

    It "Set System Interface connected" {
        Set-FGTSystemInterface -name $pester_int1 -status up
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.status | Should -Be "up"
    }

    It "Set System Interface device-identification enabled" {
        Set-FGTSystemInterface -name $pester_int1 -device_identification $true
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface."device-identification" | Should -Be "enable"
    }

    It "Set System Interface device-identification disabled" {
        Set-FGTSystemInterface -name $pester_int1 -device_identification $false
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface."device-identification" | Should -Be "disable"
    }

    It "Set System Interface mode" {
        Set-FGTSystemInterface -name $pester_int1 -mode dhcp
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.mode | Should -Be "dhcp"
    }

    It "Set System Interface administrative access" {
        Set-FGTSystemInterface -name $pester_int1 -admin_access https, ssh
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.allowaccess | Should -Be "https ssh"
    }

    It "Set System Interface dhcp relay" {
        Set-FGTSystemInterface -name $pester_int1 -dhcprelayip "10.0.0.1", "10.0.0.2"
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.'dhcp-relay-ip' | Should -Be '"10.0.0.1" "10.0.0.2" '
        $interface.'dhcp-relay-service' | Should -Be "enable"
    }

    It "Set System Interface dhcp relay then remove" {
        Set-FGTSystemInterface -name $pester_int1 -dhcprelayip "10.0.0.1", "10.0.0.2"
        Set-FGTSystemInterface -name $pester_int1 -dhcprelayip $null
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.'dhcp-relay-service' | Should -Be "disable"
    }

    AfterAll {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
    }
}

Describe "Remove System Interface" {

    BeforeEach {
        Add-FGTSystemInterface -name $pester_int1 -type vlan -role lan -mode static -vdom_interface root -interface $pester_port1 -vlan_id $pester_vlanid1
    }

    It "Remove System Interface by pipeline" {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -confirm:$false
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface | Should -Be $NULL
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}