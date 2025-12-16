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

Describe "Get System DNS Server" {

    It "Get System DNS Server Schema" {
        $schema = Get-FGTSystemDnsServer -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "system"
        $schema.name | Should -Be "dns-server"
        $schema.mkey | Should -Be "name"
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}
