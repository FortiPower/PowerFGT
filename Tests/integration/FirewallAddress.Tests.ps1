#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get Firewall Address" {

    BeforeAll {
        $addr = Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
        $script:uuid = $addr.uuid
    }

    It "Get Address Does not throw an error" {
        {
            Get-FGTFirewallAddress
        } | Should -Not -Throw
    }

    It "Get ALL Address" {
        $address = Get-FGTFirewallAddress
        $address.count | Should -Not -Be $NULL
    }

    It "Get ALL Address with -skip" {
        $address = Get-FGTFirewallAddress -skip
        $address.count | Should -Not -Be $NULL
    }

    It "Get Address ($pester_address1)" {
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
    }

    It "Get Address ($pester_address1) and confirm (via Confirm-FGTAddress)" {
        $address = Get-FGTFirewallAddress -name $pester_address1
        Confirm-FGTAddress ($address) | Should -Be $true
    }

    Context "Search" {

        It "Search Address by name ($pester_address1)" {
            $address = Get-FGTFirewallAddress -name $pester_address1
            @($address).count | Should -be 1
            $address.name | Should -Be $pester_address1
        }

        It "Search Address by uuid ($script:uuid)" {
            $address = Get-FGTFirewallAddress -uuid $script:uuid
            @($address).count | Should -be 1
            $address.name | Should -Be $pester_address1
        }

    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
    }

}

Describe "Add Firewall Address" {

    AfterEach {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
    }

    It "Add Address $pester_address1 (type ipmask)" {
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.2.0"
        $address.'end-ip' | Should -Be "255.255.255.0"
        $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
        $address.'associated-interface' | Should -BeNullOrEmpty
        $address.comment | Should -BeNullOrEmpty
        $address.visibility | Should -Be $true
    }

    It "Add Address $pester_address1 (type ipmask and interface)" {
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 -interface port2
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.2.0"
        $address.'end-ip' | Should -Be "255.255.255.0"
        $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
        $address.'associated-interface' | Should -Be "port2"
        $address.comment | Should -BeNullOrEmpty
        $address.visibility | Should -Be $true
    }

    It "Add Address $pester_address1 (type ipmask and comment)" {
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 -comment "Add via PowerFGT"
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.2.0"
        $address.'end-ip' | Should -Be "255.255.255.0"
        $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
        $address.'associated-interface' | Should -BeNullOrEmpty
        $address.comment | Should -Be "Add via PowerFGT"
        $address.visibility | Should -Be $true
    }

    It "Add Address $pester_address1 (type ipmask and visiblity disable)" {
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 -visibility:$false
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.2.0"
        $address.'end-ip' | Should -Be "255.255.255.0"
        $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
        $address.'associated-interface' | Should -BeNullOrEmpty
        $address.comment | Should -BeNullOrEmpty
        $address.visibility | Should -Be "disable"
    }

    It "Try to Add Address $pester_address1 (but there is already a object with same name)" {
        #Add first address
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
        #Add Second address with same name
        { Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 } | Should -Throw "Already an address object using the same name"

    }
}

Describe "Configure Firewall Address" {

    BeforeAll {
        $address = Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
        $script:uuid = $address.uuid
    }

    It "Change IP Address" {
        Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -ip 192.0.3.0
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.3.0"
        $address.'end-ip' | Should -Be "255.255.255.0"
        $address.subnet | Should -Be "192.0.3.0 255.255.255.0"
        $address.'associated-interface' | Should -BeNullOrEmpty
        $address.comment | Should -BeNullOrEmpty
        $address.visibility | Should -Be $true
    }

    It "Change IP Mask" {
        Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -mask 255.255.255.128
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.3.0"
        $address.'end-ip' | Should -Be "255.255.255.128"
        $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
        $address.'associated-interface' | Should -BeNullOrEmpty
        $address.comment | Should -BeNullOrEmpty
        $address.visibility | Should -Be $true
    }

    It "Change (Associated) Interface" {
        Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -interface port2
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.3.0"
        $address.'end-ip' | Should -Be "255.255.255.128"
        $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
        $address.'associated-interface' | Should -Be "port2"
        $address.comment | Should -BeNullOrEmpty
        $address.visibility | Should -Be $true
    }

    It "Change comment" {
        Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -comment "Modified by PowerFGT"
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.3.0"
        $address.'end-ip' | Should -Be "255.255.255.128"
        $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
        $address.'associated-interface' | Should -Be "port2"
        $address.comment | Should -Be "Modified by PowerFGT"
        $address.visibility | Should -Be $true
    }

    It "Change visiblity" {
        Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -visibility:$false
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.3.0"
        $address.'end-ip' | Should -Be "255.255.255.128"
        $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
        $address.'associated-interface' | Should -Be "port2"
        $address.comment | Should -Be "Modified by PowerFGT"
        $address.visibility | Should -Be "disable"
    }

    It "Change Name" {
        Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -name "pester_address_change"
        $address = Get-FGTFirewallAddress -name "pester_address_change"
        $address.name | Should -Be "pester_address_change"
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.3.0"
        $address.'end-ip' | Should -Be "255.255.255.128"
        $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
        $address.'associated-interface' | Should -Be "port2"
        $address.comment | Should -Be "Modified by PowerFGT"
        $address.visibility | Should -Be "disable"
    }

    AfterAll {
        Get-FGTFirewallAddress -uuid $script:uuid | Remove-FGTFirewallAddress -noconfirm
    }

}

Describe "Copy Firewall Address" {

    BeforeAll {
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
    }

    It "Copy Firewall Address ($pester_address1 => copy_pester_address1)" {
        Get-FGTFirewallAddress -name $pester_address1 | Copy-FGTFirewallAddress -name copy_pester_address1
        $address = Get-FGTFirewallAddress -name copy_pester_address1
        $address.name | Should -Be copy_pester_address1
        $address.uuid | Should -Not -BeNullOrEmpty
        $address.type | Should -Be "ipmask"
        $address.'start-ip' | Should -Be "192.0.2.0"
        $address.'end-ip' | Should -Be "255.255.255.0"
        $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
        $address.'associated-interface' | Should -BeNullOrEmpty
        $address.comment | Should -BeNullOrEmpty
        $address.visibility | Should -Be $true
    }

    AfterAll {
        #Remove copy_pester_address1
        Get-FGTFirewallAddress -name copy_pester_address1 | Remove-FGTFirewallAddress -noconfirm
        #Remove $pester_address1
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -noconfirm
    }

}

Describe "Remove Firewall Address" {

    BeforeEach {
        Add-FGTFirewallAddress -type ipmask -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
    }

    It "Remove Address $pester_address1 by pipeline" {
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address | Remove-FGTFirewallAddress -noconfirm
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address | Should -Be $NULL
    }

}

Disconnect-FGT -noconfirm
