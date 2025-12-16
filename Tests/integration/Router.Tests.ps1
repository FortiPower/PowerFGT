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

Describe "Get Router" {

    It "Get Router BGP Schema" {
        $schema = Get-FGTRouterBGP -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "router"
        $schema.name | Should -Be "bgp"
    }

    It "Get Router OSPF Schema" {
        $schema = Get-FGTRouterOSPF -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "router"
        $schema.name | Should -Be "ospf"
    }

    It "Get Router Policy Schema" {
        $schema = Get-FGTRouterPolicy -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "router"
        $schema.name | Should -Be "policy"
    }

    It "Get Router Static Schema" {
        $schema = Get-FGTRouterStatic -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "router"
        $schema.name | Should -Be "static"
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}
