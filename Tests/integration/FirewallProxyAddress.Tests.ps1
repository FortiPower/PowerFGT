#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get Firewall Proxy Address" {

    BeforeAll {
        $addr = Add-FGTFirewallProxyAddress -name $pester_proxyaddress1 -hostregex 'fortipower\.github\.io'
        $script:uuid = $addr.uuid
        Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method get -hostObjectName $pester_address1
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress3 -hostObjectName $pester_address1 -path '/PowerFGT'
    }

    It "Get Address Does not throw an error" {
        {
            Get-FGTFirewallProxyAddress
        } | Should -Not -Throw
    }

    It "Get ALL Address" {
        $address = Get-FGTFirewallProxyAddress
        $address.count | Should -Not -Be $NULL
    }

    It "Get ALL Address with -skip" {
        $address = Get-FGTFirewallProxyAddress -skip
        $address.count | Should -Not -Be $NULL
    }

    It "Get Address ($pester_proxyaddress1)" {
        $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress1
        $address.name | Should -Be $pester_proxyaddress1
    }

    It "Get Address ($pester_proxyaddress1) and confirm (via Confirm-FGTProxyAddress)" {
        $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress1
        Confirm-FGTProxyAddress ($address) | Should -Be $true
    }

    Context "Search" {

        It "Search Address by name ($pester_proxyaddress1)" {
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress1
            @($address).count | Should -be 1
            $address.name | Should -Be $pester_proxyaddress1
        }

        It "Search Address by uuid ($script:uuid)" {
            $address = Get-FGTFirewallProxyAddress -uuid $script:uuid
            @($address).count | Should -be 1
            $address.name | Should -Be $pester_proxyaddress1
        }

    }

    AfterAll {
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress3 | Remove-FGTFirewallProxyAddress -confirm:$false

        #Remove also Firewall Address (FQDN)
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
    }

}


Disconnect-FGT -confirm:$false
