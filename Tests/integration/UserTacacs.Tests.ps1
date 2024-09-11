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
        Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key
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
        Get-FGTuserTACACS -name $pester_usertacacs | Remove-FGTUserTACACS -confirm:$false
    }

}

Describe "Add User Tacacs" {

    Context "Tacacs Server (Primary, secondary, tertiary servers, port, authentication type etc ...)" {

        AfterEach {
            Get-FGTuserTACACS -name $pester_usertacacs | Remove-FGTUserTACACS -confirm:$false
        }

        It "Add User Tacacs Server $pester_usertacacs" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
        }

        It "Add User Tacacs Server $pester_usertacacs with secondary-server" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key -secondary_server $pester_usertacacsserver2 -secondary_key $pester_usertacacs_key
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs.'secondary-server' | Should -Be $pester_usertacacsserver2
            $usertacacs.'secondary-key' | Should -Not -Be $Null
        }

        It "Add User Tacacs Server $pester_usertacacs with tertiary-server" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key -secondary_server $pester_usertacacsserver2 -secondary_key $pester_usertacacs_key -tertiary_server $pester_usertacacsserver3 -tertiary_key $pester_usertacacs_key
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs.'secondary-server' | Should -Be $pester_usertacacsserver2
            $usertacacs.'secondary-key' | Should -Not -Be $Null
            $usertacacs.'tertiary-server' | Should -Be $pester_usertacacsserver3
            $usertacacs.'tertiary-key' | Should -Not -Be $Null
        }

        It "Add User Tacacs Server $pester_usertacacs with port" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key -port 10049
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs.timeout | Should -Be "10049"
        }

        It "Add User Tacacs Server $pester_usertacacs with authorization enabled" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key -authorization
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs.authorization | Should -Be "enable"
        }

        It "Add User Tacacs Server $pester_usertacacs with authorization disabled" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs.authorization | Should -Be "disable"
        }

        It "Try to Add User Tacacs Server $pester_usertacacs (but there is already a object with same name)" {
            #Add first userTacacs
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key
            #Add Second userTacacs with same name
            { Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key } | Should -Throw "Already a Tacacs Server using the same name"
        }

    }

    Context "Tacacs Server authen-type" {

        AfterEach {
            Get-FGTuserTACACS -name $pester_usertacacs | Remove-FGTUserTACACS -confirm:$false
        }

        It "Add User Tacacs Server $pester_usertacacs with authen_type as auto" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key -authen_type auto
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs."authen-type" | Should -Be "auto"
        }

        It "Add User Tacacs Server $pester_usertacacs with authen_type as mschap" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key -authen_type mschap
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs."authen-type" | Should -Be "mschap"
        }

        It "Add User Tacacs Server $pester_usertacacs with authen_type as ascii" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key -authen_type ascii
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs."authen-type" | Should -Be "ascii"
        }

        It "Add User Tacacs Server $pester_usertacacs with authen_type as chap" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key -authen_type chap
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs."authen-type" | Should -Be "chap"
        }

        It "Add User Tacacs Server $pester_usertacacs with authen_type as pap" {
            Add-FGTUserTACACS -Name $pester_usertacacs -server $pester_usertacacsserver1 -key $pester_usertacacs_key -authen_type pap
            $usertacacs = Get-FGTuserTACACS -name $pester_usertacacs
            $usertacacs.name | Should -Be $pester_usertacacs
            $usertacacs.server | Should -Be $pester_usertacacsserver1
            $usertacacs.key | Should -Not -Be $Null
            $usertacacs."authen-type" | Should -Be "pap"
        }

    }

}