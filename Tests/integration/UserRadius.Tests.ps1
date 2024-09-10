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

    Context "Change server, CNID, DN, etc..." {

        BeforeAll {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
        }

        It "Change name of RADIUS Server" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -name "pester_RADIUSserver_renamed"
            $userradius = Get-FGTUserRADIUS -name "pester_RADIUSserver_renamed"
            $userradius.name | Should -Be "pester_RADIUSserver_renamed"
            $userradius.server | Should -Be $pester_userradiusserver1
        }

        It "Change name of RADIUS Server back to initial value" {
            Get-FGTUserRADIUS -name "pester_RADIUSserver_renamed" | Set-FGTuserRADIUS -name $pester_userradius
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
        }

        It "Change server" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -server $pester_userradiusserver2
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver2
        }

        It "Change secondary-server" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -secondary_server $pester_userradiusserver3
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver2
            $userradius."secondary-server" | Should -Be $pester_userradiusserver3
        }

        It "Change tertiary-server" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -tertiary_server $pester_userradiusserver1
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.server | Should -Be $pester_userradiusserver2
            $userradius."secondary-server" | Should -Be $pester_userradiusserver3
            $userradius."tertiary-server" | Should -Be $pester_userradiusserver1
        }

        It "Change CNID" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -cnid sAMAccountName
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.cnid | Should -Be "sAMAccountName"
        }

        It "Change DN" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -dn "dc=newfgt,dc=power,dc=powerfgt"
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.dn | Should -Be "dc=newfgt,dc=power,dc=powerfgt"
        }

        AfterAll {
            Get-FGTUserRADIUS -name $pester_userradius | Remove-FGTUserRADIUS -confirm:$false
        }

    }

    Context "Change type" {

        BeforeAll {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
        }

        It "Change type (Regular)" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -type regular -username powerfgt -password $pester_userradiuspassword
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.type | Should -Be "regular"
            $userradius.username | Should -Be "powerfgt"
            $userradius.password | Should -Not -Be $Null
        }

        It "Change only username when type is already regular" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -username powerfgtchanged
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.type | Should -Be "regular"
            $userradius.username | Should -Be "powerfgtchanged"
        }

        It "Change only password when type is already regular" {
            {
                Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -password $pester_userradiuspasswordchanged
            } | Should -Not -Throw
        }

        It "Change type (Anonymous)" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -type anonymous
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.type | Should -Be "anonymous"
        }

        It "Change type (Simple)" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -type simple
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.type | Should -Be "simple"
        }

        It "Change only username when type is not regular" {
            {
                Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -username powerfgt
            } | Should -Throw "The type need to be regular to specify username or password"
        }

        It "Change only password when type is not regular" {
            {
                Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -password $pester_userradiuspassword
            } | Should -Throw "The type need to be regular to specify username or password"
        }

        It "Change username and password when type is not regular" {
            {
                Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -username powerfgt -password $pester_userradiuspassword
            } | Should -Throw "The type need to be regular to specify username or password"
        }

        It "Change type to regular without username" {
            {
                Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -type regular -password $pester_userradiuspassword
            } | Should -Throw "You need to specify an username and a password !"
        }

        It "Change type to regular without password" {
            {
                Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -type regular -username powerfgt
            } | Should -Throw "You need to specify an username and a password !"
        }

        It "Change type to regular without username and password" {
            {
                Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -type regular
            } | Should -Throw "You need to specify an username and a password !"
        }

        AfterAll {
            Get-FGTUserRADIUS -name $pester_userradius | Remove-FGTUserRADIUS -confirm:$false
        }

    }

    Context "Change secure connection" {

        BeforeAll {
            Add-FGTUserRADIUS -Name $pester_userradius -server $pester_userradiusserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
        }

        It "Change secure connection to RADIUSs" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -secure RADIUSs
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.secure | Should -Be "RADIUSs"
            $userradius.port | Should -Be "636"
        }

        It "Change secure connection to starttls" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -secure starttls
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.secure | Should -Be "starttls"
            $userradius.port | Should -Be "389"
        }

        It "Change secure connection to disable" {
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -secure disable
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.secure | Should -Be "disable"
            $userradius.port | Should -Be "389"
        }

        It "Change secure connection with -data" {
            $data = @{ "secure" = "RADIUSs" }
            Get-FGTUserRADIUS -name $pester_userradius | Set-FGTuserRADIUS -data $data
            $userradius = Get-FGTUserRADIUS -name $pester_userradius
            $userradius.name | Should -Be $pester_userradius
            $userradius.secure | Should -Be "RADIUSs"
            $userradius.port | Should -Be "636"
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