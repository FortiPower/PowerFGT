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

Describe "Get Firewall Internet Service Name" {

    It "Get Internet Service Name Schema" {
        $schema = Get-FGTFirewallInternetServiceName -schema
        $schema | Should -Not -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $schema.path | Should -Be "firewall"
            $schema.name | Should -Be "internet-service"
        }
        else {
            $schema.path | Should -Be "firewall"
            $schema.name | Should -Be "internet-service-name"
        }
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}
