#
# Copyright 2024, Jules
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get Firewall IPPool" {

    It "Get IPPool Schema" {
        $schema = Get-FGTFirewallIPPool -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "firewall"
        $schema.name | Should -Be "ippool"
        $schema.mkey | Should -Be "name"
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}
