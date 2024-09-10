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

Describe "Get User Radius" {

    BeforeAll {
        Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret
    }

    It "Get User Radius Does not throw an error" {
        {
            Get-FGTUserRADIUS
        } | Should -Not -Throw
    }

    It "Get ALL User Radius" {
        $userradius = Get-FGTUserRADIUS
        @($userradius).count | Should -Not -Be $NULL
    }

    It "Get ALL User RADIUS with -skip" {
        $userradius = Get-FGTUserRADIUS -skip
        @($userradius).count | Should -Not -Be $NULL
    }

    It "Get User Radius with -name $pester_userradius -meta" {
        $userradius = Get-FGTUserRADIUS -name $pester_userradius -meta
        $userradius.q_ref | Should -Not -BeNullOrEmpty
        $userradius.q_static | Should -Not -BeNullOrEmpty
        $userradius.q_no_rename | Should -Not -BeNullOrEmpty
        $userradius.q_global_entry | Should -Not -BeNullOrEmpty
        $userradius.q_type | Should -Not -BeNullOrEmpty
        $userradius.q_path | Should -Be "user"
        $userradius.q_name | Should -Be "radius"
        $userradius.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $userradius.q_no_edit | Should -Not -BeNullOrEmpty
        }
    }

    It "Get User Radius ($pester_userradius)" {
        $userradius = Get-FGTUserRADIUS -name $pester_userradius
        $userradius.name | Should -Be $pester_userradius
    }

    It "Get User Radius ($pester_userradius) and confirm (via Confirm-FGTUserRADIUS)" {
        $userradius = Get-FGTUserRADIUS -name $pester_userradius
        Confirm-FGTUserRADIUS ($userradius) | Should -Be $true
    }

    Context "Search" {

        It "Search User Radius by name ($pester_userradius)" {
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            @($userradius).count | Should -be 1
            $userradius.name | Should -Be $pester_userradius
        }

    }

    AfterAll {
        Get-FGTUserRADIUS -name $pester_userradius | Remove-FGTUserRADIUS -confirm:$false
    }

}

Describe "Add User Radius" {

    Context "Radius Server (Primary, secondary, tertiary servers, timeout, nas ID etc ...)" {

        AfterEach {
            Get-FGTUserRADIUS -name $pester_userradius | Remove-FGTUserRADIUS -confirm:$false
        }

        It "Add User RADIUS Server $pester_userradius" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
        }

        It "Add User RADIUS Server $pester_userradius with secondary-server" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -secondary_server $pester_userradiusserver2 -secondary_secret $pester_userradius_secret
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius.'secondary-server' | Should -Be $pester_userradiusserver2
            $userradius.'secondary-secret' | Should -Not -Be $Null
        }

        It "Add User RADIUS Server $pester_userradius with tertiary-server" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -secondary_server $pester_userradiusserver2 -secondary_secret $pester_userradius_secret -tertiary_server $pester_userradiusserver3 -tertiary_secret $pester_userradius_secret
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius.'secondary-server' | Should -Be $pester_userradiusserver2
            $userradius.'secondary-secret' | Should -Not -Be $Null
            $userradius.'tertiary-server' | Should -Be $pester_userradiusserver3
            $userradius.'tertiary-secret' | Should -Not -Be $Null
        }

        It "Add User RADIUS Server $pester_userradius with timeout" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -timeout 100
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius.timeout | Should -Be "100"
        }

        It "Add User RADIUS Server $pester_userradius with NAS IP" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -nas_ip 192.0.2.1
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius."nas-ip" | Should -Be "192.0.2.1"
        }

        It "Add User RADIUS Server $pester_userradius with NAS ID" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -nas_id PowerFGT
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius."nas-id" | Should -Be "PowerFGT"
        }

        It "Try to Add User RADIUS Server $pester_userradius (but there is already a object with same name)" {
            #Add first userRADIUS
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret
            #Add Second userRADIUS with same name
            { Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret } | Should -Throw "Already a RADIUS Server using the same name"
        }

    }

    Context "Radius Server auth-type" {

        AfterEach {
            Get-FGTUserRADIUS -name $pester_userradius | Remove-FGTUserRADIUS -confirm:$false
        }

        It "Add User RADIUS Server $pester_userradius with auth_type as auto" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -auth_type auto
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius."auth-type" | Should -Be "auto"
        }

        It "Add User RADIUS Server $pester_userradius with auth_type as ms_chap_v2" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -auth_type ms_chap_v2
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius."auth-type" | Should -Be "ms_chap_v2"
        }

        It "Add User RADIUS Server $pester_userradius with auth_type as ms_chap" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -auth_type ms_chap
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius."auth-type" | Should -Be "ms_chap"
        }

        It "Add User RADIUS Server $pester_userradius with auth_type as chap" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -auth_type chap
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius."auth-type" | Should -Be "chap"
        }

        It "Add User RADIUS Server $pester_userradius with auth_type as pap" {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret -auth_type pap
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver1
            $userradius.secret | Should -Not -Be $Null
            $userradius."auth-type" | Should -Be "pap"
        }

    }

}

Describe "Configure User RADIUS" {

    Context "Change server, secondary-server, timeout, etc ..." {

        BeforeAll {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret
        }

        It "Change name of RADIUS Server" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -name "pester_radiusserver_renamed"
            $userradius = Get-FGTUserRADIUS -name "pester_radiusserver_renamed"
            $userradius.name | Should -Be "pester_radiusserver_renamed"
            $userradius.server | Should -Be $pester_userradiusserver1
        }

        It "Change name of RADIUS Server back to initial value" {
            Get-FGTUserRADIUS -name "pester_radiusserver_renamed" | Set-FGTuserRADIUS -name $pester_userradius
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
        }

        It "Change server" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -server $pester_userradiusserver2
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver2
            $userradius.secret | Should -Not -Be $Null
        }

        It "Change secondary-server" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -secondary_server $pester_userradiusserver3 -secondary_secret $pester_userradius_secret
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver2
            $userradius."secondary-server" | Should -Be $pester_userradiusserver3
            $userradius."secondary-secret" | Should -Not -Be $Null
        }

        It "Change tertiary-server" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -tertiary_server $pester_userradiusserver1 -tertiary_secret $pester_userradius_secret
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver2
            $userradius."secondary-server" | Should -Be $pester_userradiusserver3
            $userradius."secondary-secret" | Should -Not -Be $Null
            $userradius."tertiary-server" | Should -Be $pester_userradiusserver1
            $userradius."tertiary-secret" | Should -Not -Be $Null
        }

        It "Change timeout" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -timeout 200
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.timeout | Should -Be "200"
        }

        It "Change NAS IP" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -nas_ip "192.2.0.2"
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius."nas-ip" | Should -Be "192.2.0.2"
        }

        It "Change NAS ID" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -nas_id "PowerFGT"
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius."nas-id" | Should -Be "PowerFGT"
        }

        AfterAll {
            Get-FGTUserRADIUS -name $pester_userradius | Remove-FGTUserRADIUS -confirm:$false
        }

    }

    Context "Change auth-type" {

        BeforeAll {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret
        }

        It "Change type ms_chap_v2" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -auth_type ms_chap_v2
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius."auth-type" | Should -Be "ms_chap_v2"
        }

        It "Change type ms_chap" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -auth_type ms_chap
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius."auth-type" | Should -Be "ms_chap"
        }

        It "Change type chap" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -auth_type chap
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius."auth-type" | Should -Be "chap"
        }

        It "Change type pap" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -auth_type pap
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius."auth-type" | Should -Be "pap"
        }

        It "Change type auto" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -auth_type auto
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius."auth-type" | Should -Be "auto"
        }

        AfterAll {
            Get-FGTUserRADIUS -name $pester_userradius | Remove-FGTUserRADIUS -confirm:$false
        }

    }

}

Describe "Remove User RADIUS" {

    Context "local" {

        BeforeEach {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -secret $pester_userradius_secret
        }

        It "Remove User RADIUS $pester_userradius by pipeline" {
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius | Remove-FGTUserRADIUS -confirm:$false
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius | Should -Be $NULL
        }

    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}