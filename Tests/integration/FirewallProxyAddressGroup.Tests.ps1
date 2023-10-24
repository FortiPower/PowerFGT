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

Describe "Get Firewall Proxy Address Group" {

    BeforeAll {
        Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        #Create Proxy Address object
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress1 -hostObjectName $pester_address1 -method "get"
        Add-FGTFirewallProxyAddress -name $pester_proxyaddress2 -hostObjectName $pester_address1 -method "post"
        #Create addressgroup object with one member
        $script:addrgrp = Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1
        $script:uuid = $addrgrp.uuid
        Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup2 -member $pester_proxyaddress2
    }

    It "Get Proxy Address Group Does not throw an error" {
        {
            Get-FGTFirewallProxyAddressGroup
        } | Should -Not -Throw
    }

    It "Get ALL Proxy Address Group" {
        $addressgroup = Get-FGTFirewallProxyAddressGroup
        $addressgroup.count | Should -Not -Be $NULL
    }

    It "Get ALL Proxy Address Group with -skip" {
        $addressgroup = Get-FGTFirewallProxyAddressGroup -skip
        $addressgroup.count | Should -Not -Be $NULL
    }

    It "Get Proxy Address Group ($pester_proxyaddressgroup1)" {
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
    }

    It "Get Proxy Address Group ($pester_proxyaddressgroup1) and confirm (via Confirm-FGTProxyAddressGroup)" {
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        Confirm-FGTProxyAddressGroup ($addressgroup) | Should -Be $true
    }

    It "Get Proxy Address Group ($pester_proxyaddressgroup1) with meta" {
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 -meta
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.q_ref | Should -Not -BeNullOrEmpty
        $addressgroup.q_static | Should -Not -BeNullOrEmpty
        $addressgroup.q_no_rename | Should -Not -BeNullOrEmpty
        $addressgroup.q_global_entry | Should -Not -BeNullOrEmpty
        $addressgroup.q_type | Should -BeIn @('469', '485', '488')
        $addressgroup.q_path | Should -Be "firewall"
        $addressgroup.q_name | Should -Be "proxy-addrgrp"
        $addressgroup.q_mkey_type | Should -Be "string"
        $addressgroup.q_no_edit | Should -Not -BeNullOrEmpty
        $addressgroup.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search Proxy Address Group by name ($pester_proxyaddressgroup1)" {
            $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
            @($addressgroup).count | Should -be 1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        }

        It "Search Proxy Address Group by uuid ($script:uuid)" {
            $addressgroup = Get-FGTFirewallProxyAddressGroup -uuid $script:uuid
            @($addressgroup).count | Should -be 1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        }

    }

    AfterAll {
        #Remove Proxy Address Group before address...
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroup -confirm:$false
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup2 | Remove-FGTFirewallProxyAddressGroup -confirm:$false

        Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false

        #Remove also Firewall Address (FQDN)
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Add Firewall Proxy Address Group" {


    Context "Type Source" {

        BeforeAll {
            Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
            #Create Proxy Address object
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress1 -hostObjectName $pester_address1 -method "get"
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -hostObjectName $pester_address1 -method "post"
        }

        AfterEach {
            Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroup -confirm:$false
        }

        It "Add Proxy Address Group $pester_proxyaddressgroup1 (with 1 member)" {
            Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1
            $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
            $addressgroup.uuid | Should -Not -BeNullOrEmpty
            $addressgroup.type | Should -Be "src"
            ($addressgroup.member).count | Should -Be "1"
            $addressgroup.member.name | Should -BeIn $pester_proxyaddress1
            $addressgroup.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $addressgroup.visibility | Should -Be $true
            }
        }

        It "Add Proxy Address Group $pester_proxyaddressgroup1 (with 1 member and a comment)" {
            Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1 -comment "Add via PowerFGT"
            $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
            $addressgroup.uuid | Should -Not -BeNullOrEmpty
            $addressgroup.type | Should -Be "src"
            ($addressgroup.member).count | Should -Be "1"
            $addressgroup.member.name | Should -BeIn $pester_proxyaddress1
            $addressgroup.comment | Should -Be "Add via PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $addressgroup.visibility | Should -Be $true
            }
        }

        It "Add Proxy Address Group $pester_proxyaddressgroup1 (with 1 member and visibility disable)" {
            Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1 -visibility:$false
            $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
            $addressgroup.uuid | Should -Not -BeNullOrEmpty
            $addressgroup.type | Should -Be "src"
            ($addressgroup.member).count | Should -Be "1"
            $addressgroup.member.name | Should -BeIn $pester_proxyaddress1
            $addressgroup.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $addressgroup.visibility | Should -Be "disable"
            }
        }

        It "Add Proxy Address Group $pester_proxyaddressgroup1 (with 2 members)" {
            Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1, $pester_proxyaddress2
            $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
            $addressgroup.uuid | Should -Not -BeNullOrEmpty
            $addressgroup.type | Should -Be "src"
            ($addressgroup.member).count | Should -Be "2"
            $addressgroup.member.name | Should -BeIn $pester_proxyaddress1, $pester_proxyaddress2
            $addressgroup.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $addressgroup.visibility | Should -Be $true
            }
        }

        It "Try to Add Proxy Address Group $pester_proxyaddressgroup1 (but there is already a object with same name)" {
            #Add first Proxy Address Group
            Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1
            #Add Second Proxy Address Group with same name
            { Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1 } | Should -Throw "Already a ProxyAddressGroup object using the same name"
        }

        AfterAll {
            Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
            Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false
            #Remove also Firewall Address (FQDN)
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "Type Destination" {

        BeforeAll {
            Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
            #Create Proxy Address object
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress1 -hostObjectName $pester_address1 -path "/PowerFGT"
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -hostObjectName $pester_address1 -path "/PowerFTM"
        }

        AfterEach {
            Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroup -confirm:$false
        }

        It "Add Proxy Address Group $pester_proxyaddressgroup1 (with 1 member)" {
            Add-FGTFirewallProxyAddressGroup -type dst -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1
            $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
            $addressgroup.uuid | Should -Not -BeNullOrEmpty
            $addressgroup.type | Should -Be "dst"
            ($addressgroup.member).count | Should -Be "1"
            $addressgroup.member.name | Should -BeIn $pester_proxyaddress1
            $addressgroup.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $addressgroup.visibility | Should -Be $true
            }
        }

        It "Add Proxy Address Group $pester_proxyaddressgroup1 (with 1 member and a comment)" {
            Add-FGTFirewallProxyAddressGroup -type dst -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1 -comment "Add via PowerFGT"
            $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
            $addressgroup.uuid | Should -Not -BeNullOrEmpty
            $addressgroup.type | Should -Be "dst"
            ($addressgroup.member).count | Should -Be "1"
            $addressgroup.member.name | Should -BeIn $pester_proxyaddress1
            $addressgroup.comment | Should -Be "Add via PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $addressgroup.visibility | Should -Be $true
            }
        }

        It "Add Proxy Address Group $pester_proxyaddressgroup1 (with 1 member and visibility disable)" {
            Add-FGTFirewallProxyAddressGroup -type dst -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1 -visibility:$false
            $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
            $addressgroup.uuid | Should -Not -BeNullOrEmpty
            $addressgroup.type | Should -Be "dst"
            ($addressgroup.member).count | Should -Be "1"
            $addressgroup.member.name | Should -BeIn $pester_proxyaddress1
            $addressgroup.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $addressgroup.visibility | Should -Be "disable"
            }
        }

        It "Add Proxy Address Group $pester_proxyaddressgroup1 (with 2 members)" {
            Add-FGTFirewallProxyAddressGroup -type dst -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1, $pester_proxyaddress2
            $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
            $addressgroup.name | Should -Be $pester_proxyaddressgroup1
            $addressgroup.uuid | Should -Not -BeNullOrEmpty
            $addressgroup.type | Should -Be "dst"
            ($addressgroup.member).count | Should -Be "2"
            $addressgroup.member.name | Should -BeIn $pester_proxyaddress1, $pester_proxyaddress2
            $addressgroup.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $addressgroup.visibility | Should -Be $true
            }
        }

        It "Try to Add Proxy Address Group $pester_proxyaddressgroup1 (but there is already a object with same name)" {
            #Add first Proxy Address Group
            Add-FGTFirewallProxyAddressGroup -type dst -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1
            #Add Second Proxy Address Group with same name
            { Add-FGTFirewallProxyAddressGroup -type dst -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1 } | Should -Throw "Already a ProxyAddressGroup object using the same name"

        }

        AfterAll {
            Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
            Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false
            #Remove also Firewall Address (FQDN)
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

}

Describe "Add Firewall Proxy Address Group Member" {

    BeforeAll {
        Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        #Create Proxy Address object
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress1 -hostObjectName $pester_address1 -method "get"
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -hostObjectName $pester_address1 -method "post"
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress3 -hostObjectName $pester_address1 -method "put"
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress4 -hostObjectName $pester_address1 -method "options"
    }

    BeforeEach {
        Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1
    }

    AfterEach {
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroup -confirm:$false
    }

    It "Add 1 member to Proxy Address Group $pester_proxyaddressgroup1 (with 1 member before)" {
        Get-FGTFirewallProxyAddressGroup -Name $pester_proxyaddressgroup1 | Add-FGTFirewallProxyAddressGroupMember -member $pester_proxyaddress2
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress1, $pester_proxyaddress2
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Add 2 members to Proxy Address Group $pester_proxyaddressgroup1 (with 1 member before)" {
        Get-FGTFirewallProxyAddressGroup -Name $pester_proxyaddressgroup1 | Add-FGTFirewallProxyAddressGroupMember -member $pester_proxyaddress2, $pester_proxyaddress3
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "3"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress1, $pester_proxyaddress2, $pester_proxyaddress3
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Add 2 members to Proxy Address Group $pester_proxyaddressgroup1 (with 2 members before)" {
        Get-FGTFirewallProxyAddressGroup -Name $pester_proxyaddressgroup1 | Add-FGTFirewallProxyAddressGroupMember -member $pester_proxyaddress2
        Get-FGTFirewallProxyAddressGroup -Name $pester_proxyaddressgroup1 | Add-FGTFirewallProxyAddressGroupMember -member $pester_proxyaddress3, $pester_proxyaddress4
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "4"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress1, $pester_proxyaddress2, $pester_proxyaddress3, $pester_proxyaddress4
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    AfterAll {
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress3 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress4 | Remove-FGTFirewallProxyAddress -confirm:$false
        #Remove also Firewall Address (FQDN)
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Configure Firewall Proxy Address Group" {

    BeforeAll {
        Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        #Create Proxy Address object
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress1 -hostObjectName $pester_address1 -method "get"
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -hostObjectName $pester_address1 -method "post"

        $addrgrp = Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1
        $script:uuid = $addrgrp.uuid
    }

    It "Change comment" {
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Set-FGTFirewallProxyAddressGroup -comment "Modified by PowerFGT"
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress1
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Change visiblity" {
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Set-FGTFirewallProxyAddressGroup -visibility:$false
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress1
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
    }

    It "Change 1 Member ($pester_proxyaddress2)" {
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Set-FGTFirewallProxyAddressGroup -member $pester_proxyaddress2
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress2
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
    }

    It "Change 2 Members ($pester_proxyaddress1 and $pester_proxyaddress2)" {
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Set-FGTFirewallProxyAddressGroup -member $pester_proxyaddress1, $pester_proxyaddress2
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress1, $pester_proxyaddress2
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
    }

    It "Change Name" {
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Set-FGTFirewallProxyAddressGroup -name "pester_proxyaddressgroup1_change"
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name "pester_proxyaddressgroup1_change"
        $addressgroup.name | Should -Be "pester_proxyaddressgroup1_change"
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress1, $pester_proxyaddress2
        $addressgroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be "disable"
        }
    }

    AfterAll {
        #Remove Proxy Address Group before address...
        Get-FGTFirewallProxyAddressGroup -uuid $script:uuid | Remove-FGTFirewallProxyAddressGroup -confirm:$false

        Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false
        #Remove also Firewall Address (FQDN)
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Copy Firewall Proxy Address Group" {

    BeforeAll {
        Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        #Create Proxy Address object
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress1 -hostObjectName $pester_address1 -method "get"
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -hostObjectName $pester_address1 -method "post"

        Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1, $pester_proxyaddress2
    }


    It "Copy Firewall Proxy Address Group ($pester_proxyaddressgroup1 => copy_pester_proxyaddressgroup1)" {
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Copy-FGTFirewallProxyAddressGroup -name copy_pester_proxyaddressgroup1
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name copy_pester_proxyaddressgroup1
        $addressgroup.name | Should -Be "copy_pester_proxyaddressgroup1"
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress1, $pester_proxyaddress2
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    AfterAll {
        #Remove Proxy Address Group before address...

        #Remove copy_pester_proxyaddress1
        Get-FGTFirewallProxyAddressGroup -name copy_pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroup -confirm:$false

        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroup -confirm:$false

        Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false

        #Remove also Firewall Address (FQDN)
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Remove Firewall Proxy Address Group" {

    BeforeEach {
        Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        #Create Proxy Address object
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress1 -hostObjectName $pester_address1 -method "get"

        Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1
    }

    It "Remove Proxy Address Group $pester_proxyaddressgroup1 by pipeline" {
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup | Remove-FGTFirewallProxyAddressGroup -confirm:$false
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup | Should -Be $NULL
    }

    AfterAll {
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false

        #Remove also Firewall Address (FQDN)
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Remove Firewall Proxy Address Group Member" {

    BeforeAll {
        Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        #Create Proxy Address object
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress1 -hostObjectName $pester_address1 -method "get"
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -hostObjectName $pester_address1 -method "post"
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress3 -hostObjectName $pester_address1 -method "put"
    }

    BeforeEach {
        Add-FGTFirewallProxyAddressGroup -type src -name $pester_proxyaddressgroup1 -member $pester_proxyaddress1, $pester_proxyaddress2, $pester_proxyaddress3
    }

    AfterEach {
        Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroup -confirm:$false
    }

    It "Remove 1 member to Proxy Address Group $pester_proxyaddressgroup1 (with 3 members before)" {
        Get-FGTFirewallProxyAddressGroup -Name $pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroupMember -member $pester_proxyaddress1
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "2"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress2, $pester_proxyaddress3
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Remove 2 members to Proxy Address Group $pester_proxyaddressgroup1 (with 3 members before)" {
        Get-FGTFirewallProxyAddressGroup -Name $pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroupMember -member $pester_proxyaddress2, $pester_proxyaddress3
        $addressgroup = Get-FGTFirewallProxyAddressGroup -name $pester_proxyaddressgroup1
        $addressgroup.name | Should -Be $pester_proxyaddressgroup1
        $addressgroup.uuid | Should -Not -BeNullOrEmpty
        $addressgroup.type | Should -Be "src"
        ($addressgroup.member).count | Should -Be "1"
        $addressgroup.member.name | Should -BeIn $pester_proxyaddress1
        $addressgroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $addressgroup.visibility | Should -Be $true
        }
    }

    It "Try Remove 3 members to Proxy Address Group $pester_proxyaddressgroup1 (with 3 members before)" {
        {
            Get-FGTFirewallProxyAddressGroup -Name $pester_proxyaddressgroup1 | Remove-FGTFirewallProxyAddressGroupMember -member $pester_proxyaddress1, $pester_proxyaddress2, $pester_proxyaddress3
        } | Should -Throw "You can't remove all members. Use Remove-FGTFirewallProxyAddressGroup to remove Proxy Address Group"
    }

    AfterAll {
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress3 | Remove-FGTFirewallProxyAddress -confirm:$false

        #Remove also Firewall Address (FQDN)
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}