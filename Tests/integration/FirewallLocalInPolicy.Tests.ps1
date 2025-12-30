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

Describe "Get Firewall Local In Policy" {

    BeforeAll {
        $policy1 = Add-FGTFirewallLocalInPolicy -intf $pester_port1 -srcaddr all -dstaddr all
        $script:uuid = $policy1.uuid
        $script:policyid1 = $policy1.policyid
        Add-FGTFirewallLocalInPolicy -intf $pester_port2 -srcaddr all -dstaddr all
    }

    It "Get Policy Does not throw an error" {
        {
            Get-FGTFirewallLocalInPolicy
        } | Should -Not -Throw
    }

    It "Get ALL Policy" {
        $policy = Get-FGTFirewallLocalInPolicy
        $policy.count | Should -Not -Be $NULL
    }

    It "Get ALL Policy with -skip" {
        $policy = Get-FGTFirewallLocalInPolicy -skip
        $policy.count | Should -Not -Be $NULL
    }

    It "Get Policy -Schema" {
        $schema = Get-FGTFirewallLocalInPolicy -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.name | Should -Be "local-in-policy"
        $schema.category | Should -Not -BeNullOrEmpty
        $schema.children | Should -Not -BeNullOrEmpty
        $schema.mkey | Should -Be "policyid"
    }

    It "Get Policy ($pester_policy1) and confirm (via Confirm-FGTFirewallLocalInPolicy)" {
        $policy = Get-FGTFirewallLocalInPolicy -policyid $script:policyid1
        Confirm-FGTFirewallLocalInPolicy ($policy) | Should -Be $true
    }

    It "Get Policy ($pester_policy1) and meta" {
        $policy = Get-FGTFirewallLocalInPolicy -policyid $script:policyid1 -meta
        $policy.policyid | Should -Be $script:policyid1
        $policy.q_ref | Should -Not -BeNullOrEmpty
        $policy.q_static | Should -Not -BeNullOrEmpty
        $policy.q_no_rename | Should -Not -BeNullOrEmpty
        $policy.q_global_entry | Should -Not -BeNullOrEmpty
        $policy.q_type | Should -Not -BeNullOrEmpty
        $policy.q_path | Should -Be "firewall"
        $policy.q_name | Should -Be "local-in-policy"
        $policy.q_mkey_type | Should -Be "integer"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $policy.q_no_edit | Should -Not -BeNullOrEmpty
        }
        #$policy.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {


        It "Search Policy by uuid ($script:uuid)" {
            $policy = Get-FGTFirewallLocalInPolicy -uuid $script:uuid
            @($policy).count | Should -be 1
            $policy.uuid | Should -Be $script:uuid
        }

        It "Search Policy by policyid ($script:policyid1)" {
            $policy = Get-FGTFirewallLocalInPolicy -policyid $script:policyid1
            @($policy).count | Should -be 1
            $policy.policyid | Should -Be $script:policyid1
        }

    }

    AfterAll {
        Get-FGTFirewallLocalInPolicy -policyid $script:policyid1 | Remove-FGTFirewallLocalInPolicy -confirm:$false
        Get-FGTFirewallLocalInPolicy -policyid $script:policyid2 | Remove-FGTFirewallLocalInPolicy -confirm:$false
    }

}


Describe "Add Firewall Local In Policy" {

    BeforeAll {
        Add-FGTFirewallLocalInPolicy -policyid 44 -intf $pester_port2 -srcaddr all -dstaddr all
    }

    AfterEach {
        Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicy -confirm:$false
    }

    It "Add Policy $pester_policy1 ($pester_port1 / $pester_port2 : All/All)" {
        $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
        $policy.uuid | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            $policy.intf.name | Should -Be $pester_port1
        }
        else {
            $policy.intf | Should -Be $pester_port1
        }
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.comments | Should -BeNullOrEmpty
    }

    Context "Multi Interface" -skip:($fgt_version -lt "7.4.0") {

        It "Add Policy $pester_policy1 (intf: $pester_port1, $pester_port3)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1, $pester_port3 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            ($policy.intf.name).count | Should -be "2"
            $policy.intf.name | Should -BeIn $pester_port1, $pester_port3
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

    }

    Context "Multi Source / destination address" {

        BeforeAll {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
            Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
            Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
            Add-FGTFirewallAddress -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
        }

        It "Add Policy $pester_policy1 (src addr: $pester_address1 and dst addr: all)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr $pester_address1 -dstaddr all
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be $pester_address1
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src addr: $pester_address1, $pester_address3 and dst addr: all)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr $pester_address1, $pester_address3 -dstaddr all
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src addr: all and dst addr: $pester_address2)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr $pester_address2
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be $pester_address2
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src addr: all and dst addr: $pester_address2, $pester_address4)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr $pester_address2, $pester_address4
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be "all"
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Policy $pester_policy1 (src addr: $pester_address1, $pester_address3 and dst addr: $pester_address2, $pester_address4)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr $pester_address1, $pester_address3 -dstaddr $pester_address2, $pester_address4
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        AfterAll {
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    It "Add Policy $pester_policy1 (with action deny)" {
        $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all -action deny
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
        $policy.uuid | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            $policy.intf.name | Should -Be $pester_port1
        }
        else {
            $policy.intf | Should -Be $pester_port1
        }
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "deny"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (status disable)" {
        $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all -status:$false
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
        $policy.uuid | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            $policy.intf.name | Should -Be $pester_port1
        }
        else {
            $policy.intf | Should -Be $pester_port1
        }
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "disable"
        $policy.service.name | Should -Be "all"
        $policy.schedule | Should -Be "always"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with 1 service : HTTP)" {
        $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all -service HTTP
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
        $policy.uuid | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            $policy.intf.name | Should -Be $pester_port1
        }
        else {
            $policy.intf | Should -Be $pester_port1
        }
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "HTTP"
        $policy.schedule | Should -Be "always"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with 2 services : HTTP, HTTPS)" {
        $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all -service HTTP, HTTPS
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
        $policy.uuid | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            $policy.intf.name | Should -Be $pester_port1
        }
        else {
            $policy.intf | Should -Be $pester_port1
        }
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -BeIn "HTTP", "HTTPS"
        $policy.schedule | Should -Be "always"
        $policy.comments | Should -BeNullOrEmpty
    }

    #Add Schedule ? need API
    It "Add Policy $pester_policy1 (with schedule none)" {
        $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all -schedule none
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
        $policy.uuid | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            $policy.intf.name | Should -Be $pester_port1
        }
        else {
            $policy.intf | Should -Be $pester_port1
        }
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "none"
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Add Policy $pester_policy1 (with comments)" {
        $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all -comments "Add via PowerFGT"
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
        $policy.uuid | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            $policy.intf.name | Should -Be $pester_port1
        }
        else {
            $policy.intf | Should -Be $pester_port1
        }
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "always"
        $policy.comments | Should -Be "Add via PowerFGT"
    }

    It "Add Policy $pester_policy1 (with data (1 field))" {
        $data = @{ "virtual-patch" = "enable" }
        $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all -data $data
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
        $policy.uuid | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            $policy.intf.name | Should -Be $pester_port1
        }
        else {
            $policy.intf | Should -Be $pester_port1
        }
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "always"
        $policy.comments | Should -BeNullOrEmpty
        $policy.'virtual-patch' | Should -Be "enable"
    }

    It "Add Policy $pester_policy1 (with data (2 fields))" {
        $data = @{ "virtual-patch" = "enable" ; "comments" = "Add via PowerFGT and -data" }
        $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all -data $data
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid $p.policyid
        $policy.uuid | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            $policy.intf.name | Should -Be $pester_port1
        }
        else {
            $policy.intf | Should -Be $pester_port1
        }
        $policy.srcaddr.name | Should -Be "all"
        $policy.dstaddr.name | Should -Be "all"
        $policy.action | Should -Be "accept"
        $policy.status | Should -Be "enable"
        $policy.service.name | Should -Be "All"
        $policy.schedule | Should -Be "always"
        $policy.comments | Should -Be "Add via PowerFGT and -data"
        $policy.'virtual-patch' | Should -Be "enable"
    }

    AfterAll {
        Get-FGTFirewallPolicy -policyid 44 | Remove-FGTFirewallPolicy -confirm:$false
    }
}

Describe "Add Firewall Local In Policy Member" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
    }

    AfterEach {
        Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicy -confirm:$false
    }

    Context "Add Member(s) to Source Address" {

        It "Add 1 member to Policy Src Address $pester_address1 (with All before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -srcaddr $pester_address1
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be $pester_address1
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 2 members to Policy Src Address $pester_address1, $pester_address3 (with All before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -srcaddr $pester_address1, $pester_address3
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -Be $pester_address1, $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 1 member to Policy Src Address $pester_address3 (with $pester_address1 before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr $pester_address1 -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -srcaddr $pester_address3
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -Be $pester_address1, $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

    }

    Context "Add Member(s) to Destination Address" {

        It "Add 1 member to Policy Dst Address $pester_address2 (with All before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -dstaddr $pester_address2
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "$pester_address2"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 2 members to Policy Dst Address $pester_address2, $pester_address4 (with All before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -dstaddr $pester_address2, $pester_address4
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be "all"
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 1 member to Policy Dst Address $pester_address4 (with $pester_address2 before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr $pester_address2
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -dstaddr $pester_address4
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be "all"
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }
    }

    Context "Add Member(s) to Source and Destination Address" {

        It "Add 1 member to Policy src Address $pester_address1 dst Address $pester_address2 (with All before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -srcaddr $pester_address1 -dstaddr $pester_address2
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be "$pester_address1"
            $policy.dstaddr.name | Should -Be "$pester_address2"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 2 members to Policy Src Address $pester_address1, $pester_address3 and Dst Address $pester_address2, $pester_address4 (with All before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -srcaddr $pester_address1, $pester_address3 -dstaddr $pester_address2, $pester_address4
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 1 members to Policy Src Address $pester_address3 and Dst Address $pester_address4 (with $pester_address1/$pester_address2 before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr $pester_address1 -dstaddr $pester_address2
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -srcaddr $pester_address3 -dstaddr $pester_address4
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }
    }

    Context "Add Member(s) to Interface" -skip:($fgt_version -lt "7.4.0") {

        It "Add 1 member to Policy Src Interface $pester_port1 (with any before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf any -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -intf $pester_port1
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.intf.name | Should -Be $pester_port1
            ($policy.intf.name).count | Should -Be "1"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"x
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 2 members to Policy Interface $pester_port1, $pester_port3 (with any before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf any -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -intf $pester_port3, $pester_port4
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.intf.name | Should -Be $pester_port3, $pester_port4
            ($policy.intf.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"x
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add 1 member to Policy Interface $pester_port3 (with $pester_port1 before)" {
            $p = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            Get-FGTFirewallLocalInPolicy -policyid 23 | Add-FGTFirewallLocalInPolicyMember -intf $pester_port3
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.intf.name | Should -Be $pester_port1, $pester_port3
            ($policy.intf.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"x
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
    }

}
<#
Describe "Move Firewall Local In Policy" {

    BeforeEach {
        $p1 = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all -service SSH
        $script:policyid1 = [int]$p1.policyid
        $p2 = Add-FGTFirewallLocalInPolicy -policyid 44 -intf $pester_port1 -srcaddr all -dstaddr all -service HTTP
        $script:policyid2 = [int]$p2.policyid
        $p3 = Add-FGTFirewallLocalInPolicy -policyid 85 -intf $pester_port1 -srcaddr all -dstaddr all -service HTTPS
        $script:policyid3 = [int]$p3.policyid
    }

    AfterEach {
        Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicy -confirm:$false
        Get-FGTFirewallLocalInPolicy -policyid 44 | Remove-FGTFirewallLocalInPolicy -confirm:$false
        Get-FGTFirewallLocalInPolicy -policyid 85 | Remove-FGTFirewallLocalInPolicy -confirm:$false
    }

    Context "Move Policy Using id" {

        It "Move Policy SSH after HTTPS (using id)" {
            Get-FGTFirewallLocalInPolicy -policyid 23 | Move-FGTFirewallLocalInPolicy -after -id $policyid3
            $policy = Get-FGTFirewallLocalInPolicy
            $policy[0].policyid | Should -Be 44
            $policy[1].policyid | Should -Be 85
            $policy[2].policyid | Should -Be 23
        }

        It "Move Policy HTTPS before SSH (using id)" {
            Get-FGTFirewallLocalInPolicy --policyid 85 | Move-FGTFirewallLocalInPolicy -before -id $policyid1
            $policy = Get-FGTFirewallLocalInPolicy
            $policy[0].policyid | Should -Be 85
            $policy[1].policyid | Should -Be 23
            $policy[2].policyid | Should -Be 44
        }
    }

    Context "Move Policy Using Firewall Local In Policy Object" {

        It "Move Policy HTTPS before SSH (using Firewall Local In Policy Object)" {

            Get-FGTFirewallLocalInPolicy -policyid 85 | Move-FGTFirewallLocalInPolicy -before -id (Get-FGTFirewallLocalInPolicy -policyid 23)
            $policy = Get-FGTFirewallLocalInPolicy
            $policy[0].policyid | Should -Be 85
            $policy[1].policyid | Should -Be 23
            $policy[2].policyid | Should -Be 44
        }
    }
}
#>

Describe "Configure Firewall Local In Policy" {

    BeforeAll {
        $policy = Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
        $script:uuid = $policy.uuid
    }

    Context "Multi Interface" -skip:($fgt_version -lt "7.4.0") {

        It "Set Policy $pester_policy1 (intf: $pester_port1, $pester_port3)" {
            $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -intf $pester_port1, $pester_port3
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23

            $policy.uuid | Should -Not -BeNullOrEmpty
            ($policy.intf.name).count | Should -be "2"
            $policy.intf.name | Should -BeIn $pester_port1, $pester_port3
        }

    }

    Context "Multi Source / Destination address" {

        BeforeAll {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
            Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
            Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
            Add-FGTFirewallAddress -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
        }

        It "Set Policy $pester_policy1 (src addr: $pester_address1)" {
            $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -srcaddr $pester_address1
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.srcaddr.name | Should -Be $pester_address1
        }

        It "Set Policy $pester_policy1 (src addr: $pester_address1, $pester_address3)" {
            $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -srcaddr $pester_address1, $pester_address3
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
        }

        It "Set Policy $pester_policy1 (dst addr: $pester_address2)" {
            $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -dstaddr $pester_address2
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.dstaddr.name | Should -Be $pester_address2
        }

        It "Set Policy $pester_policy1 (dst addr: $pester_address2, $pester_address4)" {
            $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -dstaddr $pester_address2, $pester_address4
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
        }

        It "Set Policy $pester_policy1 (src addr: all and dst addr: all)" {
            $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -srcaddr all -dstaddr all
            @($p).count | Should -Be "1"
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            ($policy.srcaddr.name).count | Should -Be "1"
            $policy.srcaddr.name | Should -Be "all"
            ($policy.dstaddr.name).count | Should -Be "1"
            $policy.dstaddr.name | Should -Be "all"
        }

        AfterAll {
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
            Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    It "Set Policy $pester_policy1 (with action deny)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -action deny
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.action | Should -Be "deny"
    }

    It "Set Policy $pester_policy1 (with action accept)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -action accept
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.action | Should -Be "accept"
    }

    It "Set Policy $pester_policy1 (status disable)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -status:$false
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.status | Should -Be "disable"
    }

    It "Set Policy $pester_policy1 (status enable)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -status
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.status | Should -Be "enable"
    }

    It "Set Policy $pester_policy1 (with 1 service : HTTP)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -service HTTP
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.service.name | Should -Be "HTTP"
    }

    It "Set Policy $pester_policy1 (with 2 services : SSH, HTTPS)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -service SSH, HTTPS
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.service.name | Should -BeIn "SSH", "HTTPS"
    }

    It "Set Policy $pester_policy1 (with 1 service : ALL))" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -service ALL
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.service.name | Should -Be "all"
    }

    #Add Schedule ? need API
    It "Set Policy $pester_policy1 (with schedule none)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -schedule none
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.schedule | Should -Be "none"
    }

    It "Set Policy $pester_policy1 (with schedule always)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -schedule always
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.schedule | Should -Be "always"
    }

    It "Set Policy $pester_policy1 (with comments)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -comments "Modify via PowerFGT"
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.comments | Should -Be "Modify via PowerFGT"
    }

    It "Set Policy $pester_policy1 (with comments: null)" {
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -comments ""
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.comments | Should -BeNullOrEmpty
    }

    It "Set Policy $pester_policy1 (with data (1 field))" {
        $data = @{ "virtual-patch" = "enable" }
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -data $data
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.'virtual-patch' | Should -Be "enable"
    }

    It "Set Policy $pester_policy1 (with data (2 fields))" {
        $data = @{ "virtual-patch" = "disable" ; "comments" = "Modify via PowerFGT and -data" }
        $p = Get-FGTFirewallLocalInPolicy -policyid 23 | Set-FGTFirewallLocalInPolicy -data $data
        @($p).count | Should -Be "1"
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy.uuid | Should -Not -BeNullOrEmpty
        $policy.comments | Should -Be "Modify via PowerFGT and -data"
        $policy.'virtual-patch' | Should -Be "disable"
    }

    AfterAll {
        Get-FGTFirewallLocalInPolicy -uuid $script:uuid | Remove-FGTFirewallLocalInPolicy -confirm:$false
    }

}
Describe "Remove Firewall Local In Policy" {

    BeforeEach {
        Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr all
    }

    It "Remove Policy $pester_policy1 by pipeline" {
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy | Remove-FGTFirewallLocalInPolicy -confirm:$false
        $policy = Get-FGTFirewallLocalInPolicy -policyid 23
        $policy | Should -Be $NULL
    }

}

Describe "Remove Firewall Local In Policy Member" {

    BeforeAll {
        #Create some Address object
        Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
    }

    AfterEach {
        Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicy -confirm:$false
    }

    Context "Remove Member(s) to Source Address" {
        BeforeEach {
            Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr $pester_address1, $pester_address2, $pester_address3 -dstaddr all
        }

        It "Remove 1 member to Policy Src Address $pester_address1 (with 3 members before)" {
            Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicyMember -srcaddr $pester_address1
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            ($policy.srcaddr.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -Be $pester_address2, $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Remove 2 members to Policy Src Address $pester_address1, $pester_address2 (with 3 members before)" {
            Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicyMember -srcaddr $pester_address1, $pester_address2
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be $pester_address3
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Try Remove 3 members to Policy Src Address $pester_address1, $pester_address2, $pester_address3 (with 3 members before)" {
            {
                Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicyMember -srcaddr $pester_address1, $pester_address2, $pester_address3
            } | Should -Throw "You can't remove all members. Use Set-FGTFirewallLocalInPolicy to remove Source Address"
        }

    }

    Context "Remove Member(s) to Interface" -skip:($fgt_version -lt "7.4.0") {
        BeforeEach {
            Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1, $pester_port2, $pester_port3 -srcaddr all -dstaddr all
        }

        It "Remove 1 member to Policy Interface $pester_port1 (with 3 members before)" {
            Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicyMember -intf $pester_port1
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.intf.name | Should -BeIn $pester_port2, $pester_port3
            ($policy.intf.name).count | Should -Be "2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Remove 2 members to Policy Interface $pester_port1, $pester_port2 (with 3 members before)" {
            Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicyMember -intf $pester_port1, $pester_port2
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.intf.name | Should -BeIn $pester_port3
            ($policy.srcaddr.name).count | Should -Be "1"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Try Remove 3 members to Address $pester_port1, $pester_port2, $pester_port3 (with 3 members before)" {
            {
                Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicyMember -intf $pester_port1, $pester_port2, $pester_port3
            } | Should -Throw "You can't remove all members. Use Set-FGTFirewallLocalInPolicy to remove interface"
        }

    }

    Context "Remove Member(s) to Destination Address" {
        BeforeEach {
            Add-FGTFirewallLocalInPolicy -policyid 23 -intf $pester_port1 -srcaddr all -dstaddr $pester_address1, $pester_address2, $pester_address3
        }

        It "Remove 1 member to Policy Dest Address $pester_address1 (with 3 members before)" {
            Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicyMember -dstaddr $pester_address1
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be "all"
            ($policy.dstaddr.name).count | Should -Be "2"
            $policy.dstaddr.name | Should -Be $pester_address2, $pester_address3
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Remove 2 members to Policy Dest Address $pester_address1, $pester_address2 (with 3 members before)" {
            Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicyMember -dstaddr $pester_address1, $pester_address2
            $policy = Get-FGTFirewallLocalInPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            if ($DefaultFGTConnection.version -ge "7.4.0") {
                $policy.intf.name | Should -Be $pester_port1
            }
            else {
                $policy.intf | Should -Be $pester_port1
            }
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be $pester_address3
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "all"
            $policy.schedule | Should -Be "always"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Try Remove 3 members to Policy Dest Address $pester_address1, $pester_address2, $pester_address3 (with 3 members before)" {
            {
                Get-FGTFirewallLocalInPolicy -policyid 23 | Remove-FGTFirewallLocalInPolicyMember -dstaddr $pester_address1, $pester_address2, $pester_address3
            } | Should -Throw "You can't remove all members. Use Set-FGTFirewallLocalInPolicy to remove Destination Address"
        }

    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
    }

}
#>
AfterAll {
    Disconnect-FGT -confirm:$false
}