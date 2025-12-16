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

Describe "Get System DHCP Server" {

    It "Get System DHCP Server Schema" {
        $schema = Get-FGTSystemDHCPServer -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "system.dhcp"
        $schema.name | Should -Be "server"
        $schema.mkey | Should -Be "id"
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}
