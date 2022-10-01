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
        Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1
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

    It "Get interface ($pester_int1)" {
        $interface = Get-FGTSystemInterface -name $pester_int1
        $interface.name | Should -Be $pester_int1
    }

    It "Get interface ($pester_int1) and confirm (via Confirm-FGTInterface)" {
        $interface = Get-FGTSystemInterface -name $pester_int1
        Confirm-FGTInterface $interface | Should -Be $true
    }

    Context "Search" {

        It "Search interface by name ($pester_int1)" {
            $interface = Get-FGTSystemInterface -name $pester_int1
            @($interface).count | Should -be 1
            $interface.name | Should -Be $pester_int1
        }

    }

    AfterAll {
        Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
    }

}

Describe "Add System Interface" {

    Context "Interface Vlan" {
        AfterEach {
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
        }

        It "Add System Interface with only mandatory parameters" {
            Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
        }

        It "Add System Interface (All parameters...)" {
            Add-FGTSystemInterface -name $pester_int1 -alias Alias_$pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -allowaccess https, ping, ssh -status up -device_identification $true -mode static -ip 192.0.2.1 -netmask 255.255.255.0
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

        It "Add System Interface (with alias)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -alias Alias_$pester_int1
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.alias | Should -Be "Alias_$pester_int1"
        }

        It "Add System Interface (with allowaccess https)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -allowaccess https
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "https"
        }

        It "Add System Interface (with allowaccess ssh)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -allowaccess ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "ssh"
        }

        It "Add System Interface (with allowaccess https ssh)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -allowaccess https, ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "https ssh"
        }

        It "Add System Interface (with status up)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -status up
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.status | Should -Be "up"
        }

        It "Add System Interface (with status down)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -status down
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.status | Should -Be "down"
        }

        It "Add System Interface (with role lan)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -role lan
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "lan"
        }

        It "Add System Interface (with role dmz)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -role dmz
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "dmz"
        }

        It "Add System Interface (with role wan)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -role wan
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "wan"
        }

        It "Add System Interface (with role undefined)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -role undefined
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "undefined"
        }

        It "Add System Interface (with device-identification enabled)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -device_identification $true
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface."device-identification" | Should -Be $true
        }

        It "Add System Interface (with device-identification disabled)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -device_identification $false
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface."device-identification" | Should -Be "disable"
        }

        It "Add System Interface (with mode static)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -mode static
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
        }

        It "Add System Interface (with mode dhcp)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -mode dhcp
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "dhcp"
        }

        It "Add System Interface (with IP Address and Netmask)" {
            Add-FGTSystemInterface -name $pester_int1 -vlan_id $pester_vlanid1 -interface $pester_port1 -ip 192.0.2.1 -netmask 255.255.255.0
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlanid | Should -Be $pester_vlanid1
            $interface.interface | Should -Be $pester_port1
            $interface.mode | Should -Be "static"
            $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
        }
    }

    Context "Interface loopback" {
        AfterEach {
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
        }

        It "Add System Interface with only mandatory parameters" {
            Add-FGTSystemInterface -name $pester_int1 -loopback
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
        }

        It "Add System Interface (All parameters...)" {
            Add-FGTSystemInterface -name $pester_int1 -alias Alias_$pester_int1 -loopback -allowaccess https, ping, ssh -status up -device_identification $true -mode static -ip 192.0.2.1 -netmask 255.255.255.0
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.alias | Should -Be "Alias_$pester_int1"
            $interface.role | Should -Be "lan"
            $interface.allowaccess | Should -Be "ping https ssh"
            $interface.status | Should -Be "up"
            $interface."device-identification" | Should -Be "enable"
            $interface.mode | Should -Be "static"
            $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
        }

        It "Add System Interface (with alias)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -alias Alias_$pester_int1
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.alias | Should -Be "Alias_$pester_int1"
        }

        It "Add System Interface (with allowaccess https)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -allowaccess https
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "https"
        }

        It "Add System Interface (with allowaccess ssh)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -allowaccess ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "ssh"
        }

        It "Add System Interface (with allowaccess https ssh)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -allowaccess https, ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "https ssh"
        }

        It "Add System Interface (with status up)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -status up
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.status | Should -Be "up"
        }

        It "Add System Interface (with status down)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -status down
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.status | Should -Be "down"
        }

        It "Add System Interface (with role lan)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -role lan
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "lan"
        }

        It "Add System Interface (with role dmz)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -role dmz
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "dmz"
        }

        It "Add System Interface (with role wan)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -role wan
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "wan"
        }

        It "Add System Interface (with role undefined)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -role undefined
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "undefined"
        }

        It "Add System Interface (with device-identification enabled)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -device_identification $true
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface."device-identification" | Should -Be $true
        }

        It "Add System Interface (with device-identification disabled)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -device_identification $false
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface."device-identification" | Should -Be "disable"
        }

        It "Add System Interface (with mode static)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -mode static
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
        }
        <# Disable mode dhcp, it is not possible with a loopback...
        It "Add System Interface (with mode dhcp)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -mode dhcp
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "dhcp"
        }
#>
        It "Add System Interface (with IP Address and Netmask)" {
            Add-FGTSystemInterface -name $pester_int1 -loopback -ip 192.0.2.1 -netmask 255.255.255.0
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            $interface.type | Should -Be "loopback"
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
        }

    }

    $atype = @(
        @{ "atype" = "lacp" }
        @{ "atype" = "static" }
    )

    Context "Interface aggregate $($_.atype)" -ForEach $atype {
        AfterEach {
            Get-FGTSystemInterface -name $pester_int2 | Remove-FGTSystemInterface -Confirm:$false
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
        }

        It "Add System Interface with only mandatory parameters" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if (($fgt_version -ge "6.2.0") -and ($_.atype -eq "static")) {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
        }

        It "Add System Interface (All parameters...)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -alias Alias_$pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -allowaccess https, ping, ssh -status up -device_identification $true -mode static -ip 192.0.2.1 -netmask 255.255.255.0
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.alias | Should -Be "Alias_$pester_int1"
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.allowaccess | Should -Be "ping https ssh"
            $interface.status | Should -Be "up"
            $interface."device-identification" | Should -Be "enable"
            $interface.mode | Should -Be "static"
            $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
        }

        It "Add System Interface (with alias)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -alias Alias_$pester_int1
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.alias | Should -Be "Alias_$pester_int1"
        }

        It "Add System Interface (with allowaccess https)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -allowaccess https
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "https"
        }

        It "Add System Interface (with allowaccess ssh)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -allowaccess ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "ssh"
        }

        It "Add System Interface (with allowaccess https ssh)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -allowaccess https, ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "https ssh"
        }

        It "Add System Interface (with status up)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -status up
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.status | Should -Be "up"
        }

        It "Add System Interface (with status down)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -status down
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.status | Should -Be "down"
        }

        It "Add System Interface (with role lan)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -role lan
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "lan"
        }

        It "Add System Interface (with role dmz)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -role dmz
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "dmz"
        }

        It "Add System Interface (with role wan)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -role wan
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "wan"
        }

        It "Add System Interface (with role undefined)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -role undefined
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "undefined"
        }

        It "Add System Interface (with device-identification enabled)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -device_identification $true
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface."device-identification" | Should -Be $true
        }

        It "Add System Interface (with device-identification disabled)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -device_identification $false
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface."device-identification" | Should -Be "disable"
        }

        It "Add System Interface (with mode static)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -mode static
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
        }

        It "Add System Interface (with mode dhcp)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -mode dhcp
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "dhcp"
        }

        It "Add System Interface (with IP Address and Netmask)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2 -ip 192.0.2.1 -netmask 255.255.255.0
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            if ($fgt_version -ge "6.2.0" -and $_.atype -eq "static") {
                $interface.type | Should -Be "redundant"
            }
            else {
                $interface.type | Should -Be "aggregate"
            }
            $interface.role | Should -Be "lan"
            $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
            $interface.mode | Should -Be "static"
            $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
        }

        It "Add Vlan System Interface (on aggregate $($_.atype) interface)" -TestCases $_ {
            Add-FGTSystemInterface -name $pester_int1 -atype $_.atype -member $pester_port1, $pester_port2
            Add-FGTSystemInterface -name $pester_int2 -vlan $pester_vlanid1 -interface $pester_int1
            $interface = Get-FGTSystemInterface -name $pester_int2
            $interface.name | Should -Be $pester_int2
            $interface.type | Should -Be "vlan"
            $interface.role | Should -Be "lan"
            $interface.vlan_id | Should -Be $script:pester_vlanid1
            $interface.mode | Should -Be "static"
        }

    }

}

$type = @(
    @{ "type" = "vlan" }
    @{ "type" = "aggregate_lacp" }
    @{ "type" = "aggregate_static" }
    @{ "type" = "loopback" }
)

Describe "Add System Interface Member" -ForEach $type {

    Context "Add System Interface $($_.type) Member" {

        BeforeEach {
            switch ($_.type) {
                "vlan" {
                    Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1
                }
                "aggregate_lacp" {
                    Add-FGTSystemInterface -name $pester_int1 -atype lacp -member $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    Add-FGTSystemInterface -name $pester_int1 -atype static -member $pester_port1, $pester_port2
                }
                "loopback" {
                    Add-FGTSystemInterface -name $pester_int1 -loopback
                }
            }
        }

        It "Add System Interface Member (HTTPS)" -TestCases $_ {
            Get-FGTSystemInterface -name $pester_int1 | Add-FGTSystemInterfaceMember -allowaccess https
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.allowaccess | Should -Be "https"
        }

        It "Add System Interface Member (SSH) with before HTTPS" -TestCases $_ {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -allowaccess https
            Get-FGTSystemInterface -name $pester_int1 | Add-FGTSystemInterfaceMember -allowaccess ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.allowaccess | Should -Be "https ssh"
        }

        AfterEach {
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
        }
    }

}


Describe "Set System Interface" -ForEach $type {

    Context "Set System Interface $($_.type)" {

        BeforeAll {
            switch ($_.type) {
                "vlan" {
                    Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1
                }
                "aggregate_lacp" {
                    Add-FGTSystemInterface -name $pester_int1 -atype lacp -member $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    Add-FGTSystemInterface -name $pester_int1 -atype static -member $pester_port1, $pester_port2
                }
                "loopback" {
                    Add-FGTSystemInterface -name $pester_int1 -loopback
                }
            }
        }

        It "Set System Interface alias" {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -alias Set_$pester_int1
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.alias | Should -Be "Set_$pester_int1"
        }

        It "Set System Interface role" {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -role dmz
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.role | Should -Be "dmz"
        }

        It "Set System Interface IP (and Netmask)" {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -ip 192.0.2.1 -netmask 255.255.255.0
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
        }

        It "Set System Interface status (up)" {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -status down
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.status | Should -Be "down"
        }

        It "Set System Interface status (down)" {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -status up
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.status | Should -Be "up"
        }

        It "Set System Interface device-identification enabled" -Skip:($_.type -eq "loopback") {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -device_identification $true
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface."device-identification" | Should -Be "enable"
        }

        It "Set System Interface device-identification disabled" -Skip:($_.type -eq "loopback") {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -device_identification $false
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface."device-identification" | Should -Be "disable"
        }

        It "Set System Interface mode (DHCP)" -Skip:($_.type -eq "loopback") {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -mode dhcp
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.mode | Should -Be "dhcp"
        }

        It "Set System Interface Administrative Access (HTTPS, SSH)" {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -allowaccess https, ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.allowaccess | Should -Be "https ssh"
        }

        It "Set System Interface DHCP Relay" -Skip:($_.type -eq "loopback") {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -dhcprelayip "192.0.2.1", "192.0.2.2"
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.'dhcp-relay-ip' | Should -Be '"192.0.2.1" "192.0.2.2" '
            $interface.'dhcp-relay-service' | Should -Be "enable"
        }

        It "Set System Interface DHCP Relay then remove" {
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -dhcprelayip "192.0.2.1", "192.0.2.2"
            Get-FGTSystemInterface -name $pester_int1 | Set-FGTSystemInterface -dhcprelayip $null
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.'dhcp-relay-service' | Should -Be "disable"
        }

        AfterAll {
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
        }

    }
}

Describe "Remove System Interface" -ForEach $type {

    Context "Remove System Interface $($_.type)" {

        BeforeEach {
            switch ($_.type) {
                "vlan" {
                    Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1
                }
                "aggregate_lacp" {
                    Add-FGTSystemInterface -name $pester_int1 -atype lacp -member $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    Add-FGTSystemInterface -name $pester_int1 -atype static -member $pester_port1, $pester_port2
                }
                "loopback" {
                    Add-FGTSystemInterface -name $pester_int1 -loopback
                }
            }
        }

        It "Remove System Interface by pipeline" {
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -confirm:$false
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface | Should -Be $NULL
        }

    }
}

Describe "Remove System Interface Member" -ForEach $type {

    Context "Remove System Interface $($_.type) Member" {

        BeforeEach {
            switch ($_.type) {
                "vlan" {
                    Add-FGTSystemInterface -name $pester_int1 -interface $pester_port1 -vlan_id $pester_vlanid1 -allowacces ssh, https
                }
                "aggregate_lacp" {
                    Add-FGTSystemInterface -name $pester_int1 -atype lacp -member $pester_port1, $pester_port2 -allowacces ssh, https
                }
                "aggregate_static" {
                    Add-FGTSystemInterface -name $pester_int1 -atype static -member $pester_port1, $pester_port2 -allowacces ssh, https
                }
                "loopback" {
                    Add-FGTSystemInterface -name $pester_int1 -loopback -allowacces ssh, https
                }
            }
        }

        It "Remove System Interface Member (HTTPS)" {
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterfaceMember -allowaccess https
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.allowaccess | Should -Be "ssh"
        }

        It "Remove System Interface Member (SSH and HTTPS)" {
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterfaceMember -allowaccess ssh, https
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.allowaccess | Should -Be ""
        }

        AfterEach {
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
        }
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}