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

Describe "Get System DNS" {

    It "Get System DNS Schema" {
        $schema = Get-FGTSystemDns -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "system"
        $schema.name | Should -Be "dns"
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}
