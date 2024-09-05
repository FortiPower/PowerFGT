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

<#Describe "Configure User Ldap" {

    Context "Change name, email, MFA, etc" {

        BeforeAll {
            Add-FGTUserLDAP -Name $pester_userldap -passwd $pester_userldappassword
        }

        It "Change status User Ldap" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -status
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.status | Should -Be "enable"
            $userldap.'email-to' | Should -BeNullOrEmpty
            $userldap.'two-factor' | Should -Be "disable"
        }

        It "Change email to" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -email_to "powerfgt@power.fgt"
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.status | Should -Be "disable"
            $userldap.'email-to' | Should -Be "powerfgt@power.fgt"
            $userldap.'two-factor' | Should -Be "disable"
        }

        It "Enable MFA by email" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -two_factor email
            $userldap = Get-FGTUserLDAP -name $pester_userldap
            $userldap.name | Should -Be $pester_userldap
            $userldap.status | Should -Be "disable"
            $userldap.'email-to' | Should -Be "powerfgt@power.fgt"
            $userldap.'two-factor' | Should -Be "email"
        }

        It "Change Name" {
            Get-FGTUserLDAP -name $pester_userldap | Set-FGTuserldap -name "pester_userldap_change"
            $userldap = Get-FGTUserLDAP -name "pester_userldap_change"
            $userldap.name | Should -Be "pester_userldap_change"
            $userldap.status | Should -Be "disable"
            $userldap.'email-to' | Should -Be "powerfgt@power.fgt"
            $userldap.'two-factor' | Should -Be "email"
        }

        It "Change email to with -data" {
            $data = @{ "email-to" = "powerfgt@power.fgt" }
            Get-FGTUserLDAP -name "pester_userldap_change" | Set-FGTuserldap -data $data
            $userldap = Get-FGTUserLDAP -name "pester_userldap_change"
            $userldap.name | Should -Be "pester_userldap_change"
            $userldap.status | Should -Be "disable"
            $userldap.'email-to' | Should -Be "powerfgt@power.fgt"
            $userldap.'two-factor' | Should -Be "email"
        }

        AfterAll {
            Get-FGTUserLDAP -name "pester_userldap_change" | Remove-FGTUserLDAP -confirm:$false
        }

    }
}
#>
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