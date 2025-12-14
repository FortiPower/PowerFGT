#
# Copyright 2024, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get Monitor" {

    It "Get Monitor Firewall Address Dynamic Schema" {
        $schema = Get-FGTMonitorFirewallAddressDynamic -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Monitor Firewall Address FQDN Schema" {
        $schema = Get-FGTMonitorFirewallAddressFQDN -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Monitor Firewall Policy Schema" {
        $schema = Get-FGTMonitorFirewallPolicy -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Monitor Firewall Session Schema" {
        $schema = Get-FGTMonitorFirewallSession -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Monitor System HA Peer Schema" {
        $schema = Get-FGTMonitorSystemHAPeer -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Monitor System HA Checksum Schema" {
        $schema = Get-FGTMonitorSystemHAChecksum -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Monitor Utm Application Categories Schema" {
        $schema = Get-FGTMonitorUtmApplicationCategories -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Monitor Vpn IPsec Schema" {
        $schema = Get-FGTMonitorVpnIPsec -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Monitor Vpn Ssl Schema" {
        $schema = Get-FGTMonitorVpnSsl -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Monitor Webfilter Categories Schema" {
        $schema = Get-FGTMonitorWebfilterCategories -schema
        $schema | Should -Not -BeNullOrEmpty
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}
