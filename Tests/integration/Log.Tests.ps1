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

Describe "Get Log" {

    It "Get Log Event Schema" {
        $schema = Get-FGTLogEvent -schema
        $schema | Should -Not -BeNullOrEmpty
    }

    It "Get Log Traffic Schema" {
        $schema = Get-FGTLogTraffic -schema
        $schema | Should -Not -BeNullOrEmpty
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}
