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

Describe "Get Switch" {

    It "Get Switch Fortilink Settings Schema" {
        $schema = Get-FGTSwitchFortilinkSettings -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "fortilink-settings"
    }

    It "Get Switch Global Schema" {
        $schema = Get-FGTSwitchGlobal -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "global"
    }

    It "Get Switch LLDP Profile Schema" {
        $schema = Get-FGTSwitchLLDPProfile -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "lldp-profile"
    }

    It "Get Switch LLDP Settings Schema" {
        $schema = Get-FGTSwitchLLDPSettings -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "lldp-settings"
    }

    It "Get Switch Managed Switch Schema" {
        $schema = Get-FGTSwitchManagedSwitch -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "managed-switch"
    }

    It "Get Switch SNMP Community Schema" {
        $schema = Get-FGTSwitchSNMPCommunity -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "snmp-community"
    }

    It "Get Switch STP Instance Schema" {
        $schema = Get-FGTSwitchSTPInstance -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "stp-instance"
    }

    It "Get Switch STP Settings Schema" {
        $schema = Get-FGTSwitchSTPSettings -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "stp-settings"
    }

    It "Get Switch Group Schema" {
        $schema = Get-FGTSwitchGroup -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "switch-group"
    }

    It "Get Switch Profile Schema" {
        $schema = Get-FGTSwitchProfile -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "switch-profile"
    }

    It "Get Switch System Schema" {
        $schema = Get-FGTSwitchSystem -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "system"
    }

    It "Get Switch Vlan Policy Schema" {
        $schema = Get-FGTSwitchVlanPolicy -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.path | Should -Be "switch-controller"
        $schema.name | Should -Be "vlan-policy"
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}
