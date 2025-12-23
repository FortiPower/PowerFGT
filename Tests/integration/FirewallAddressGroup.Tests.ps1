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

Describe "Get Firewall Address Group" {

    BeforeAll {
        #Create Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        #Create addressgroup object with one member
        $script:addrgrp = Add-FGTFirewallAddressGroup -name $pester_addressgroup1 -member $pester_address1
        $script:uuid = $addrgrp.uuid
        Add-FGTFirewallAddressGroup -name $pester_addressgroup2 -member $pester_address2
    }

    It "Get Address Group Does not throw an error" {
        {
            Get-FGTFirewallAddressGroup
        } | Should -Not -Throw
    }

    It "Get ALL Address Group" {
        $addressgroup = Get-FGTFirewallAddressGroup
        $addressgroup.count | Should -Not -Be $NULL
    }

    It "Get ALL Address Group with -skip" {
        $addressgroup = Get-FGTFirewallAddressGroup -skip
        $addressgroup.count | Should -Not -Be $NULL
    }

    It "Get Address Group ($pester_addressgroup1)" {
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
    }

    It "Get Address Group ($pester_addressgroup1) and confirm (via Confirm-FGTAddressGroup)" {
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        Confirm-FGTAddressGroup ($addressgroup) | Should -Be $true
    }

    It "Get Address Group ($pester_addressgroup1) and meta" {
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1 -meta
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.q_ref | Should -Not -BeNullOrEmpty
        $addressgroup.q_static | Should -Not -BeNullOrEmpty
        $addressgroup.q_no_rename | Should -Not -BeNullOrEmpty
        $addressgroup.q_global_entry | Should -Not -BeNullOrEmpty
        $addressgroup.q_type | Should -Not -BeNullOrEmpty
        $addressgroup.q_path | Should -Be "firewall"
        $addressgroup.q_name | Should -Be "addrgrp"
        $addressgroup.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $addressgroup.q_no_edit | Should -Not -BeNullOrEmpty
        }
        $addressgroup.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search Address Group by name ($pester_addressgroup1)" {
            $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
            @($addressgroup).count | Should -be 1
            $addressgroup.name | Should -Be $pester_addressgroup1
        }

        It "Search Address Group by uuid ($script:uuid)" {
            $addressgroup = Get-FGTFirewallAddressGroup -uuid $script:uuid
            @($addressgroup).count | Should -be 1
            $addressgroup.name | Should -Be $pester_addressgroup1
        }

    }

    AfterAll {
        #Remove address group before address...
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Remove-FGTFirewallAddressGroup -confirm:$false
        Get-FGTFirewallAddressGroup -name $pester_addressgroup2 | Remove-FGTFirewallAddressGroup -confirm:$false

        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Add Firewall Address Group" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
    }

    AfterEach {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Remove-FGTFirewallAddressGroup -confirm:$false
    }

    It "Add Address Group $pester_addressgroup1 (with 0 member)" -skip:($fgt_version -lt "7.2.0") {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "0"
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Add Address Group $pester_addressgroup1 (with 1 member)" {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Add Address Group $pester_addressgroup1 (with 1 member and a comment)" {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1 -comment "Add via PowerFGT"
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -Be "Add via PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Add Address Group $pester_addressgroup1 (with 1 member and visibility disable)" {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1 -visibility:$false
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
    }

    It "Add Address Group $pester_addressgroup1 (with 2 members)" {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1, $pester_address2
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Add Address Group $pester_addressgroup1 (with 1 member and data (1 field))" {
        $data = @{ "color" = 23 }
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1 -data $data
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -BeNullOrEmpty
        $addressgroup.color | Should -Be "23"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Add Address Group $pester_addressgroup1 (with 1 member and data (2 fields))" {
        $data = @{ "color" = 23; "comment" = "Add via PowerFGT and -data" }
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1 -data $data
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -Be "Add via PowerFGT and -data"
        $addressgroup.color | Should -Be "23"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Try to Add Address Group $pester_addressgroup1 (but there is already a object with same name)" {
        #Add first Address Group
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1
        #Add Second Address Group with same name
        { Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1 } | Should -Throw "Already an addressgroup object using the same name"

    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Add Firewall Address Group Member" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
    }

    BeforeEach {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1
    }

    AfterEach {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Remove-FGTFirewallAddressGroup -confirm:$false
    }

    It "Add 1 member to Address Group $pester_addressgroup1 (with 1 member before)" {
        Get-FGTFirewallAddressGroup -Name $pester_addressgroup1 | Add-FGTFirewallAddressGroupMember -member $pester_address2
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Add 2 members to Address Group $pester_addressgroup1 (with 1 member before)" {
        Get-FGTFirewallAddressGroup -Name $pester_addressgroup1 | Add-FGTFirewallAddressGroupMember -member $pester_address2, $pester_address3
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "3"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2, $pester_address3
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Add 2 members to Address Group $pester_addressgroup1 (with 2 members before)" {
        Get-FGTFirewallAddressGroup -Name $pester_addressgroup1 | Add-FGTFirewallAddressGroupMember -member $pester_address2
        Get-FGTFirewallAddressGroup -Name $pester_addressgroup1 | Add-FGTFirewallAddressGroupMember -member $pester_address3, $pester_address4
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "4"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2, $pester_address3, $pester_address4
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Configure Firewall Address Group" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255

        $addrgrp = Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1
        $script:uuid = $addrgrp.uuid
    }

    It "Change comment" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Set-FGTFirewallAddressGroup -comment "Modified by PowerFGT"
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Change visiblity" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Set-FGTFirewallAddressGroup -visibility:$false
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
    }

    It "Change 1 Member ($pester_address2)" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Set-FGTFirewallAddressGroup -member $pester_address2
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address2
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
    }

    It "Change 2 Members ($pester_address1 and $pester_address2)" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Set-FGTFirewallAddressGroup -member $pester_address1, $pester_address2
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
    }

    It "Change -data (1 field)" {
        $data = @{ "color" = 23 }
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Set-FGTFirewallAddressGroup -data $data
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
        $addressgroup.color | Should -Be "23"
    }

    It "Change -data (2 fields)" {
        $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Set-FGTFirewallAddressGroup -data $data
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -Be "Modified by PowerFGT via -data"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
        $addressgroup.color | Should -Be "4"
    }

    It "Change Name" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Set-FGTFirewallAddressGroup -name "pester_addressgroup1_change"
        $addressgroup = Get-FGTFirewallAddressGroup -name "pester_addressgroup1_change"
        $addressgroup.name | Should -Be "pester_addressgroup1_change"
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -Be "Modified by PowerFGT via -data"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
    }

    AfterAll {
        #Remove address group before address...
        Get-FGTFirewallAddressGroup -uuid $script:uuid | Remove-FGTFirewallAddressGroup -confirm:$false

        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Copy Firewall Address Group" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255

        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1, $pester_address2
    }


    It "Copy Firewall Address Group ($pester_addressgroup1 => copy_pester_addressgroup1)" {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Copy-FGTFirewallAddressGroup -name copy_pester_addressgroup1
        $addressgroup = Get-FGTFirewallAddressGroup -name copy_pester_addressgroup1
        $addressgroup.name | Should -Be "copy_pester_addressgroup1"
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address1, $pester_address2
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    AfterAll {
        #Remove address group before address...

        #Remove copy_pester_address1
        Get-FGTFirewallAddressGroup -name copy_pester_addressgroup1 | Remove-FGTFirewallAddressGroup -confirm:$false

        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Remove-FGTFirewallAddressGroup -confirm:$false

        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Remove Firewall Address Group" {

    BeforeEach {
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255

        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1
    }

    It "Remove Address Group $pester_addressgroup1 by pipeline" {
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup | Remove-FGTFirewallAddressGroup -confirm:$false
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup | Should -Be $NULL
    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Remove Firewall Address Group Member" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
    }

    BeforeEach {
        Add-FGTFirewallAddressGroup -Name $pester_addressgroup1 -member $pester_address1, $pester_address2, $pester_address3
    }

    AfterEach {
        Get-FGTFirewallAddressGroup -name $pester_addressgroup1 | Remove-FGTFirewallAddressGroup -confirm:$false
    }

    It "Remove 1 member to Address Group $pester_addressgroup1 (with 3 members before)" {
        Get-FGTFirewallAddressGroup -Name $pester_addressgroup1 | Remove-FGTFirewallAddressGroupMember -member $pester_address1
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_address2, $pester_address3
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Remove 2 members to Address Group $pester_addressgroup1 (with 3 members before)" {
        Get-FGTFirewallAddressGroup -Name $pester_addressgroup1 | Remove-FGTFirewallAddressGroupMember -member $pester_address2, $pester_address3
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_address1
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Remove 3 members to Address Group $pester_addressgroup1 (with 3 members before)" -skip:($fgt_version -lt "7.2.0") {
        Get-FGTFirewallAddressGroup -Name $pester_addressgroup1 | Remove-FGTFirewallAddressGroupMember -member $pester_address1, $pester_address2, $pester_address3
        $addressgroup = Get-FGTFirewallAddressGroup -name $pester_addressgroup1
        $addressgroup.name | Should -Be $pester_addressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        ($addressgroup.member).count | Should -Be "0"
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}