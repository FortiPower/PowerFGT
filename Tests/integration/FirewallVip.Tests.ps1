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

Describe "Get Firewall VIP" {

    BeforeAll {
        $vip = Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        $script:uuid = $vip.uuid
        Add-FGTFirewallVip -Name $pester_vip2 -type static-nat -extip 192.2.0.2 -mappedip 198.51.100.1
    }

    It "Get Virtual IP Does not throw an error" {
        {
            Get-FGTFirewallVip
        } | Should -Not -Throw
    }

    It "Get ALL Virtual IP" {
        $vip = Get-FGTFirewallVip
        $vip.count | Should -Not -Be $NULL
    }

    It "Get ALL Virtual IP with -skip" {
        $vip = Get-FGTFirewallVip -skip
        $vip.count | Should -Not -Be $NULL
    }

    It "Get Virtual IP ($pester_vip1)" {
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
    }

    It "Get Virtual IP ($pester_vip1) and confirm (via Confirm-FGTVip)" {
        $vip = Get-FGTFirewallVip -name $pester_vip1
        Confirm-FGTVip ($vip) | Should -Be $true
    }

    It "Get Virtual IP ($pester_vip1) and meta" {
        $vip = Get-FGTFirewallVip -name $pester_vip1 -meta
        $vip.name | Should -Be $pester_vip1
        $vip.q_ref | Should -Not -BeNullOrEmpty
        $vip.q_static | Should -Not -BeNullOrEmpty
        $vip.q_no_rename | Should -Not -BeNullOrEmpty
        $vip.q_global_entry | Should -Not -BeNullOrEmpty
        $vip.q_type | Should -Not -BeNullOrEmpty
        $vip.q_path | Should -Be "firewall"
        $vip.q_name | Should -Be "vip"
        $vip.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $vip.q_no_edit | Should -Not -BeNullOrEmpty
        }
        $vip.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search Virtual IP by name ($pester_vip1)" {
            $vip = Get-FGTFirewallVip -name $pester_vip1
            @($vip).count | Should -be 1
            $vip.name | Should -Be $pester_vip1
        }

        It "Search Virtual IP by uuid ($script:uuid)" {
            $vip = Get-FGTFirewallVip -uuid $script:uuid
            @($vip).count | Should -be 1
            $vip.name | Should -Be $pester_vip1
        }

    }

    AfterAll {
        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVIP -confirm:$false
        Get-FGTFirewallVip -name $pester_vip2 | Remove-FGTFirewallVIP -confirm:$false
    }

}

Describe "Add Firewall VIP" {

    AfterEach {
        Get-FGTFirewallVip -name $pester_vip1 | Remove-FGTFirewallVIP -confirm:$false
    }

    It "Add Virtual IP $pester_vip1 (type static-nat)" {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -BeNullOrEmpty
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be "any"
        $vip.portforward | Should -Be "disable"
        $vip.protocol | Should -Be "tcp"
        $vip.extport | Should -Be "0-65535"
        $vip.mappedport | Should -Be "0-65535"
        $vip.'arp-reply' | Should -Be "enable"
    }

    It "Add Virtual IP $pester_vip1 (type static-nat with comment)" {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 -comment "Add via PowerFGT"
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -Be "Add via PowerFGT"
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be "any"
        $vip.portforward | Should -Be "disable"
        $vip.protocol | Should -Be "tcp"
        $vip.extport | Should -Be "0-65535"
        $vip.mappedport | Should -Be "0-65535"
        $vip.'arp-reply' | Should -Be "enable"
    }

    It "Add Virtual IP $pester_vip1 (type static-nat with interface)" {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 -interface $pester_port1
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -BeNullOrEmpty
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be $pester_port1
        $vip.portforward | Should -Be "disable"
        $vip.protocol | Should -Be "tcp"
        $vip.extport | Should -Be "0-65535"
        $vip.mappedport | Should -Be "0-65535"
        $vip.'arp-reply' | Should -Be "enable"
    }

    It "Add Virtual IP $pester_vip1 (type static-nat with Port Forward TCP 8080)" {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 -portforward -extport 8080
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -BeNullOrEmpty
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be "Any"
        $vip.portforward | Should -Be "enable"
        $vip.protocol | Should -Be "tcp"
        $vip.extport | Should -Be "8080"
        $vip.mappedport | Should -Be "8080"
        $vip.'arp-reply' | Should -Be "enable"
    }

    It "Add Virtual IP $pester_vip1 (type static-nat with Port Forward UDP 8080)" {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 -portforward -extport 8080 -protocol udp
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -BeNullOrEmpty
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be "Any"
        $vip.portforward | Should -Be "enable"
        $vip.protocol | Should -Be "udp"
        $vip.extport | Should -Be "8080"
        $vip.mappedport | Should -Be "8080"
        $vip.'arp-reply' | Should -Be "enable"
    }

    It "Add Virtual IP $pester_vip1 (type static-nat with Port Forward TCP 8080 -> 80)" {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 -portforward -extport 8080 -mappedport 80
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -BeNullOrEmpty
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be "Any"
        $vip.portforward | Should -Be "enable"
        $vip.protocol | Should -Be "tcp"
        $vip.extport | Should -Be "8080"
        $vip.mappedport | Should -Be "80"
        $vip.'arp-reply' | Should -Be "enable"
    }

    It "Add Virtual IP $pester_vip1 (type static-nat with arpreply enabled)" {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 -arpreply:$true
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -BeNullOrEmpty
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be "any"
        $vip.portforward | Should -Be "disable"
        $vip.protocol | Should -Be "tcp"
        $vip.extport | Should -Be "0-65535"
        $vip.mappedport | Should -Be "0-65535"
        $vip.'arp-reply' | Should -Be "enable"
    }

    It "Add Virtual IP $pester_vip1 (type static-nat with arpreply disabled)" {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 -arpreply:$false
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -BeNullOrEmpty
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be "any"
        $vip.portforward | Should -Be "disable"
        $vip.protocol | Should -Be "tcp"
        $vip.extport | Should -Be "0-65535"
        $vip.mappedport | Should -Be "0-65535"
        $vip.'arp-reply' | Should -Be "disable"
    }

    It "Add Virtual IP $pester_vip1 (type static-nat via data (one field))" {
        $data = @{ "color" = "4" }
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 -data $data
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -BeNullOrEmpty
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be "any"
        $vip.portforward | Should -Be "disable"
        $vip.protocol | Should -Be "tcp"
        $vip.extport | Should -Be "0-65535"
        $vip.mappedport | Should -Be "0-65535"
        $vip.'arp-reply' | Should -Be "enable"
        $vip.'nat-source-vip' | Should -Be "disable"
        $vip.color | Should -Be "4"
    }

    It "Add Virtual IP $pester_vip1 (type static-nat via data (two fields))" {
        $data = @{ "nat-source-vip" = "enable" ; "color" = "23" }
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 -data $data
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip.name | Should -Be $pester_vip1
        $vip.uuid | Should -Not -BeNullOrEmpty
        $vip.comment | Should -BeNullOrEmpty
        $vip.type | Should -Be "static-nat"
        $vip.extip | Should -Be "192.2.0.1"
        $vip.mappedip.range | Should -Be "198.51.100.1"
        $vip.extintf | Should -Be "any"
        $vip.portforward | Should -Be "disable"
        $vip.protocol | Should -Be "tcp"
        $vip.extport | Should -Be "0-65535"
        $vip.mappedport | Should -Be "0-65535"
        $vip.'arp-reply' | Should -Be "enable"
        $vip.'nat-source-vip' | Should -Be "enable"
        $vip.color | Should -Be "23"
    }

    It "Try to Add Virtual IP $pester_vip1 (but there is already a object with same name)" {
        #Add first Virtual IP
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
        #Add Second Virtual IP with same name
        { Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1 } | Should -Throw "Already a VIP object using the same name"
    }

}

Describe "Remove Firewall VIP" {

    BeforeEach {
        Add-FGTFirewallVip -Name $pester_vip1 -type static-nat -extip 192.2.0.1 -mappedip 198.51.100.1
    }

    It "Remove Virtual IP $pester_vip1 by pipeline" {
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip | Remove-FGTFirewallVIP -confirm:$false
        $vip = Get-FGTFirewallVip -name $pester_vip1
        $vip | Should -Be $NULL
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}