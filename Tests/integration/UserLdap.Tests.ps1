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

Describe "Get User Ldap" {

    BeforeAll {
        Add-FGTUserLDAP -name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
    }

    It "Get User Ldap Does not throw an error" {
        {
            Get-FGTUserLDAP
        } | Should -Not -Throw
    }

    It "Get ALL User Ldap" {
        $userldap = Get-FGTUserLDAP
        $userldap.count | Should -Not -Be $NULL
    }

    It "Get ALL User Ldap with -skip" {
        $userldap = Get-FGTUserLDAP -skip
        $userldap.count | Should -Not -Be $NULL
    }

    It "Get User Ldap with -name $pester_userldap -meta" {
        $userldap = Get-FGTUserLDAP -name $pester_userldap -meta
        $userldap.q_ref | Should -Not -BeNullOrEmpty
        $userldap.q_static | Should -Not -BeNullOrEmpty
        $userldap.q_no_rename | Should -Not -BeNullOrEmpty
        $userldap.q_global_entry | Should -Not -BeNullOrEmpty
        $userldap.q_type | Should -Not -BeNullOrEmpty
        $userldap.q_path | Should -Be "user"
        $userldap.q_name | Should -Be "ldap"
        $userldap.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $userldap.q_no_edit | Should -Not -BeNullOrEmpty
        }
    }

    It "Get User Ldap ($pester_userldap)" {
        $userldap = Get-FGTUserLDAP -name $pester_userldap
        $userldap.name | Should -Be $pester_userldap
    }

    It "Get User Ldap ($pester_userldap) and confirm (via Confirm-FGTUserLDAP)" {
        $userldap = Get-FGTUserLDAP -name $pester_userldap
        Confirm-FGTUserLDAP ($userldap) | Should -Be $true
    }

    Context "Search" {

        It "Search User Ldap by name ($pester_userldap)" {
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            @($userldap).count | Should -be 1
            $userldap.name | Should -Be $pester_userldap
        }

    }

    AfterAll {
        Get-FGTUserLDAP -name $pester_userldap | Remove-FGTUserLDAP -confirm:$false
    }

}

Describe "Add User Ldap" {

    Context "LDAP Server (Primary, secondary, tertiary servers, type, secure connection etc ...)" {

        AfterEach {
            Get-FGTUserLDAP -name $pester_userldap | Remove-FGTUserLDAP -confirm:$false
        }

        It "Add User LDAP Server $pester_userldap" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
        }

        It "Add User LDAP Server $pester_userldap with secondary-server" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -secondary_server $pester_userldapserver2
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.'secondary-server' | Should -Be $pester_userldapserver2
        }

        It "Add User LDAP Server $pester_userldap with tertiary-server" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -secondary_server $pester_userldapserver2 -tertiary_server $pester_userldapserver3
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.'secondary-server' | Should -Be $pester_userldapserver2
            $userldap.'tertiary-server' | Should -Be $pester_userldapserver3
        }

        It "Add User LDAP Server $pester_userldap with cnid" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -cnid sAMAccountName
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.cnid | Should -Be "sAMAccountName"
        }

        It "Add User LDAP Server $pester_userldap with type simple" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -type simple
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.type | Should -Be "simple"
        }

        It "Add User LDAP Server $pester_userldap with type anonymous" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -type anonymous
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.type | Should -Be "anonymous"
        }

        It "Add User LDAP Server $pester_userldap with type regular" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -type regular -username powerfgt -password $pester_userldappassword
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.type | Should -Be "regular"
            $userldap.username | Should -Be "powerfgt"
        }

        It "Add User LDAP Server $pester_userldap with secure connection disabled" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -secure disable
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.secure | Should -Be "disable"
        }

        It "Add User LDAP Server $pester_userldap with secure connection starttls" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -secure starttls
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.secure | Should -Be "starttls"
        }

        It "Add User LDAP Server $pester_userldap with secure connection ldaps" {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -secure ldaps
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.secure | Should -Be "ldaps"
            $userldap.port | Should -Be "636"
        }

        It "Add User LDAP Server $pester_userldap with port 10389 and secure connection to ldaps via -data" {
            $data = @{ "port" = "10389" ; "secure" = "ldaps" }
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" -data $data
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver1
            $userldap.dn | Should -Be "dc=fgt,dc=power,dc=powerfgt"
            $userldap.secure | Should -Be "ldaps"
            $userldap.port | Should -Be "10389"
        }

        It "Try to Add User LDAP Server $pester_userldap (but there is already a object with same name)" {
            #Add first userldap
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
            #Add Second userldap with same name
            { Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt" } | Should -Throw "Already a LDAP Server using the same name"
        }

    }

}

Describe "Configure User Ldap" {

    Context "Change server, CNID, DN, etc..." {

        BeforeAll {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
        }

        It "Change name of LDAP Server" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -name "pester_ldapserver_renamed"
            $userldap = Get-FGTUserLDAP -name "pester_ldapserver_renamed"
            $userldap.name | Should -Be "pester_ldapserver_renamed"
            $userldap.server | Should -Be $pester_userldapserver1
        }

        It "Change name of LDAP Server back to initial value" {
            Get-FGTUserLDAP -name "pester_ldapserver_renamed" | Set-FGTuserldap -name $pester_userldap
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
        }

        It "Change server" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -server $pester_userldapserver2
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver2
        }

        It "Change secondary-server" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -secondary_server $pester_userldapserver3
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver2
            $userldap."secondary-server" | Should -Be $pester_userldapserver3
        }

        It "Change tertiary-server" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -tertiary_server $pester_userldapserver1
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.server | Should -Be $pester_userldapserver2
            $userldap."secondary-server" | Should -Be $pester_userldapserver3
            $userldap."tertiary-server" | Should -Be $pester_userldapserver1
        }

        It "Change CNID" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -cnid sAMAccountName
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.cnid | Should -Be "sAMAccountName"
        }

        It "Change DN" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -dn "dc=newfgt,dc=power,dc=powerfgt"
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.dn | Should -Be "dc=newfgt,dc=power,dc=powerfgt"
        }

        AfterAll {
            Get-FGTUserLDAP -name $pester_userldap | Remove-FGTUserLDAP -confirm:$false
        }

    }

    Context "Change type" {

        BeforeAll {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
        }

        It "Change type (Regular)" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -type regular -username powerfgt -password $pester_userldappassword
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.type | Should -Be "regular"
            $userldap.username | Should -Be "powerfgt"
            $userldap.password | Should -Not -Be $Null
        }

        It "Change only username when type is already regular" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -username powerfgtchanged
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.type | Should -Be "regular"
            $userldap.username | Should -Be "powerfgtchanged"
        }

        It "Change only password when type is already regular" {
            {
                Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -password $pester_userldappasswordchanged
            } | Should -Not -Throw
        }

        It "Change type (Anonymous)" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -type anonymous
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.type | Should -Be "anonymous"
        }

        It "Change type (Simple)" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -type simple
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.type | Should -Be "simple"
        }

        It "Change only username when type is not regular" {
            {
                Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -username powerfgt
            } | Should -Throw "The type need to be regular to specify username or password"
        }

        It "Change only password when type is not regular" {
            {
                Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -password $pester_userldappassword
            } | Should -Throw "The type need to be regular to specify username or password"
        }

        It "Change username and password when type is not regular" {
            {
                Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -username powerfgt -password $pester_userldappassword
            } | Should -Throw "The type need to be regular to specify username or password"
        }

        It "Change type to regular without username" {
            {
                Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -type regular -password $pester_userldappassword
            } | Should -Throw "You need to specify an username and a password !"
        }

        It "Change type to regular without password" {
            {
                Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -type regular -username powerfgt
            } | Should -Throw "You need to specify an username and a password !"
        }

        It "Change type to regular without username and password" {
            {
                Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -type regular
            } | Should -Throw "You need to specify an username and a password !"
        }

        AfterAll {
            Get-FGTUserLDAP -name $pester_userldap | Remove-FGTUserLDAP -confirm:$false
        }

    }

    Context "Change secure connection" {

        BeforeAll {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
        }

        It "Change secure connection to ldaps" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -secure ldaps
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.secure | Should -Be "ldaps"
            $userldap.port | Should -Be "636"
        }

        It "Change secure connection to starttls" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -secure starttls
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.secure | Should -Be "starttls"
            $userldap.port | Should -Be "389"
        }

        It "Change secure connection to disable" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -secure disable
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.secure | Should -Be "disable"
            $userldap.port | Should -Be "389"
        }

        It "Change secure connection with -data" {
            $data = @{ "secure" = "ldaps" }
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -data $data
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.secure | Should -Be "ldaps"
            $userldap.port | Should -Be "636"
        }

        AfterAll {
            Get-FGTUserLDAP -name $pester_userldap | Remove-FGTUserLDAP -confirm:$false
        }

    }
}

Describe "Remove User Ldap" {

    Context "local" {

        BeforeEach {
            Add-FGTUserLDAP -Name $pester_userldap -server $pester_userldapserver1 -dn "dc=fgt,dc=power,dc=powerfgt"
        }

        It "Remove User Ldap $pester_userldap by pipeline" {
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap | Remove-FGTUserLDAP -confirm:$false
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap | Should -Be $NULL
        }

    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}