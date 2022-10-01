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

$type = @(
    @{ "type" = "vlan"; "param" = @{ "vlan_id" = $pester_vlanid1; "interface" = $pester_port1 } }
    @{ "type" = "aggregate_lacp"; "param" = @{ "atype" = "lacp"; "member" = $pester_port1, $pester_port2 } }
    @{ "type" = "aggregate_static"; "param" = @{ "atype" = "static"; "member" = $pester_port1, $pester_port2 } }
    @{ "type" = "loopback"; "param" = @{ "loopback" = $true } }
)

Describe "Add System Interface" -ForEach $type {

    Context "Interface $($_.type)" {
        AfterEach {
            Get-FGTSystemInterface -name $pester_int2 | Remove-FGTSystemInterface -Confirm:$false
            Get-FGTSystemInterface -name $pester_int1 | Remove-FGTSystemInterface -Confirm:$false
        }

        It "Add System Interface with only mandatory parameters" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
        }

        It "Add System Interface (All parameters...)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -alias Alias_$pester_int1 -allowaccess https, ping, ssh -status up -device_identification $true -mode static -ip 192.0.2.1 -netmask 255.255.255.0
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.alias | Should -Be "Alias_$pester_int1"
            $interface.role | Should -Be "lan"
            $interface.allowaccess | Should -Be "ping https ssh"
            $interface.status | Should -Be "up"
            $interface."device-identification" | Should -Be "enable"
            $interface.mode | Should -Be "static"
            $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
        }

        It "Add System Interface (with alias)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -alias Alias_$pester_int1
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.alias | Should -Be "Alias_$pester_int1"
        }

        It "Add System Interface (with allowaccess https)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -allowaccess https
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "https"
        }

        It "Add System Interface (with allowaccess ssh)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -allowaccess ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "ssh"
        }

        It "Add System Interface (with allowaccess https ssh)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -allowaccess https, ssh
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.allowaccess | Should -Be "https ssh"
        }

        It "Add System Interface (with status up)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -status up
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.status | Should -Be "up"
        }

        It "Add System Interface (with status down)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -status down
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.status | Should -Be "down"
        }

        It "Add System Interface (with role lan)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -role lan
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "lan"
        }

        It "Add System Interface (with role dmz)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -role dmz
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "dmz"
        }

        It "Add System Interface (with role wan)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -role wan
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "wan"
        }

        It "Add System Interface (with role undefined)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -role undefined
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.mode | Should -Be "static"
            $interface.role | Should -Be "undefined"
        }

        It "Add System Interface (with device-identification enabled)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -device_identification $true
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface."device-identification" | Should -Be $true
        }

        It "Add System Interface (with device-identification disabled)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -device_identification $false
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface."device-identification" | Should -Be "disable"
        }

        It "Add System Interface (with mode static)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -mode static
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
        }

        It "Add System Interface (with mode dhcp)" -Skip:($_.type -eq "loopback") {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -mode dhcp
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "dhcp"
        }

        It "Add System Interface (with IP Address and Netmask)" {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p -ip 192.0.2.1 -netmask 255.255.255.0
            $interface = Get-FGTSystemInterface -name $pester_int1
            $interface.name | Should -Be $pester_int1
            switch ($_.type) {
                "vlan" {
                    $interface.type | Should -Be "vlan"
                    $interface.vlanid | Should -Be $pester_vlanid1
                    $interface.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $interface.type | Should -Be "aggregate"
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $interface.type | Should -Be "redundant"
                    }
                    else {
                        $interface.type | Should -Be "aggregate"
                    }
                    $interface.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $interface.type | Should -Be "loopback"
                }
            }
            $interface.role | Should -Be "lan"
            $interface.mode | Should -Be "static"
            $interface.ip | Should -Be "192.0.2.1 255.255.255.0"
        }

        It "Add Vlan System Interface (on aggregate $($_.type) interface)" -Skip:($_.type -eq "loopback" -or $_.type -eq "vlan") {
            $p = $_.param
            Add-FGTSystemInterface -name $pester_int1 @p
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