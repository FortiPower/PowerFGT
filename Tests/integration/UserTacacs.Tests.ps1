#
# Copyright 2024, Cedric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get User Tacacs" {

    BeforeAll {
        Add-FGTusertacacs -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key
    }

    It "Get User Tacacs Does not throw an error" {
        {
            Get-FGTuserTACACS
        } | Should -Not -Throw
    }

    It "Get ALL User Tacacs" {
        $usertacacs = Get-FGTuserTACACS
        @($usertacacs).count | Should -Not -Be $NULL
    }

    It "Get ALL User Tacacs with -skip" {
        $usertacacs = Get-FGTuserTACACS -skip
        @($usertacacs).count | Should -Not -Be $NULL
    }

    It "Get User Tacacs with -name $pester_usertacacs -meta" {
        $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs -meta
        $usertacacs.q_ref | Should -Not -BeNullOrEmpty
        $usertacacs.q_static | Should -Not -BeNullOrEmpty
        $usertacacs.q_no_rename | Should -Not -BeNullOrEmpty
        $usertacacs.q_global_entry | Should -Not -BeNullOrEmpty
        $usertacacs.q_type | Should -Not -BeNullOrEmpty
        $usertacacs.q_path | Should -Be "user"
        $usertacacs.q_name | Should -Be "tacacs+"
        $usertacacs.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $usertacacs.q_no_edit | Should -Not -BeNullOrEmpty
        }
    }

    It "Get User Tacacs ($pester_usertacacs)" {
        $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
        $usertacacs.name | Should -Be $pester_usertacacs
    }

    It "Get User Tacacs ($pester_usertacacs) and confirm (via Confirm-FGTuserTACACS)" {
        $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
        Confirm-FGTuserTACACS ($usertacacs) | Should -Be $true
    }

    Context "Search" {

        It "Search User Tacacs by name ($pester_usertacacs)" {
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            @($usertacacs).count | Should -be 1
            $usertacacs.name | Should -Be $pester_usertacacs
        }

    }

    AfterAll {
        Get-FGTuserTACACS -name $pester_usertacacs | Remove-FGTuserTACACS -confirm:$false
    }

}