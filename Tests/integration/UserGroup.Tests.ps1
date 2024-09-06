#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get User Group" {

    BeforeAll {
        #Create User object
        Add-FGTUserLocal -Name $pester_userlocal -passwd $pester_userlocalpassword
        Add-FGTUserLocal -Name $pester_userlocal2 -passwd $pester_userlocalpassword
        #Create Usergroup object with one member
        Add-FGTUserGroup -name $pester_usergroup1 -member $pester_userlocal
        Add-FGTUserGroup -name $pester_usergroup2 -member $pester_userlocal2
    }

    It "Get User Group Does not throw an error" {
        {
            Get-FGTUserGroup
        } | Should -Not -Throw
    }

    It "Get ALL User Group" {
        $usergroup = Get-FGTUserGroup
        $usergroup.count | Should -Not -Be $NULL
    }

    It "Get ALL User Group with -skip" {
        $usergroup = Get-FGTUserGroup -skip
        $usergroup.count | Should -Not -Be $NULL
    }

    It "Get User Group ($pester_usergroup1)" {
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
    }

    It "Get User Group ($pester_usergroup1) and confirm (via Confirm-FGTUserGroup)" {
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        Confirm-FGTUserGroup ($usergroup) | Should -Be $true
    }

    It "Get User Group ($pester_usergroup1) and meta" {
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1 -meta
        $usergroup.name | Should -Be $pester_usergroup1
        $usergroup.q_ref | Should -Not -BeNullOrEmpty
        $usergroup.q_static | Should -Not -BeNullOrEmpty
        $usergroup.q_no_rename | Should -Not -BeNullOrEmpty
        $usergroup.q_global_entry | Should -Not -BeNullOrEmpty
        $usergroup.q_type | Should -Not -BeNullOrEmpty
        $usergroup.q_path | Should -Be "user"
        $usergroup.q_name | Should -Be "group"
        $usergroup.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $usergroup.q_no_edit | Should -Not -BeNullOrEmpty
        }
        $usergroup.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search User Group by name ($pester_usergroup1)" {
            $usergroup = Get-FGTUserGroup -name $pester_usergroup1
            @($usergroup).count | Should -be 1
            $usergroup.name | Should -Be $pester_usergroup1
        }

    }

    AfterAll {
        #Remove User group before User...
        Get-FGTUserGroup -name $pester_usergroup1 | Remove-FGTUserGroup -confirm:$false
        Get-FGTUserGroup -name $pester_usergroup2 | Remove-FGTUserGroup -confirm:$false

        Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
        Get-FGTUserLocal -name $pester_userlocal2 | Remove-FGTUserLocal -confirm:$false
    }

}

Describe "Add User Group" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal -Name $pester_userlocal -passwd $pester_userlocalpassword
        Add-FGTUserLocal -Name $pester_userlocal2 -passwd $pester_userlocalpassword
    }

    AfterEach {
        Get-FGTUserGroup -name $pester_usergroup1 | Remove-FGTUserGroup -confirm:$false
    }

    It "Add User Group $pester_usergroup1 (with 1 member)" {
        Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "1"
        $usergroup.member.name | Should -BeIn $pester_userlocal
    }

    It "Add User Group $pester_usergroup1 (with 2 members)" {
        Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal, $pester_userlocal2
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "2"
        $usergroup.member.name | Should -BeIn $pester_userlocal, $pester_userlocal2
    }

    It "Add User Group $pester_usergroup1 (with 1 member and data (1 field))" {
        $data = @{ "authtimeout" = 23 }
        Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal -data $data
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "1"
        $usergroup.member.name | Should -BeIn $pester_userlocal
        $usergroup.authtimeout | Should -Be "23"
    }

    It "Add User Group $pester_usergroup1 (with 1 member and data (2 fields))" {
        $data = @{ "authtimeout" = 23; "auth-concurrent-override" = "enable" }
        Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal -data $data
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "1"
        $usergroup.member.name | Should -BeIn $pester_userlocal
        $usergroup.authtimeout | Should -Be "23"
        $usergroup.'auth-concurrent-override' | Should -Be "enable"
    }

    It "Try to Add User Group $pester_usergroup1 (but there is already a object with same name)" {
        #Add first User Group
        Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal
        #Add Second User Group with same name
        { Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal } | Should -Throw "Already an User Group object using the same name"

    }

    AfterAll {
        Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
        Get-FGTUserLocal -name $pester_userlocal2 | Remove-FGTUserLocal -confirm:$false
    }

}

Describe "Add User Group Member" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal -Name $pester_userlocal -passwd $pester_userlocalpassword
        Add-FGTUserLocal -Name $pester_userlocal2 -passwd $pester_userlocalpassword
        Add-FGTUserLocal -Name $pester_userlocal3 -passwd $pester_userlocalpassword
        Add-FGTUserLocal -Name $pester_userlocal4 -passwd $pester_userlocalpassword
    }

    BeforeEach {
        Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal
    }

    AfterEach {
        Get-FGTUserGroup -name $pester_usergroup1 | Remove-FGTUserGroup -confirm:$false
    }

    It "Add 1 member to User Group $pester_usergroup1 (with 1 member before)" {
        Get-FGTUserGroup -Name $pester_usergroup1 | Add-FGTUserGroupMember -member $pester_userlocal2
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "2"
        $usergroup.member.name | Should -BeIn $pester_userlocal, $pester_userlocal2
    }

    It "Add 2 members to User Group $pester_usergroup1 (with 1 member before)" {
        Get-FGTUserGroup -Name $pester_usergroup1 | Add-FGTUserGroupMember -member $pester_userlocal2, $pester_userlocal3
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "3"
        $usergroup.member.name | Should -BeIn $pester_userlocal, $pester_userlocal2, $pester_userlocal3
    }

    It "Add 2 members to User Group $pester_usergroup1 (with 2 members before)" {
        Get-FGTUserGroup -Name $pester_usergroup1 | Add-FGTUserGroupMember -member $pester_userlocal2
        Get-FGTUserGroup -Name $pester_usergroup1 | Add-FGTUserGroupMember -member $pester_userlocal3, $pester_userlocal4
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "4"
        $usergroup.member.name | Should -BeIn $pester_userlocal, $pester_userlocal2, $pester_userlocal3, $pester_userlocal4
    }

    AfterAll {
        Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
        Get-FGTUserLocal -name $pester_userlocal2 | Remove-FGTUserLocal -confirm:$false
        Get-FGTUserLocal -name $pester_userlocal3 | Remove-FGTUserLocal -confirm:$false
        Get-FGTUserLocal -name $pester_userlocal4 | Remove-FGTUserLocal -confirm:$false
    }

}

Describe "Configure User Group" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal -Name $pester_userlocal -passwd $pester_userlocalpassword
        Add-FGTUserLocal -Name $pester_userlocal2 -passwd $pester_userlocalpassword

        $addrgrp = Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal
        $script:uuid = $addrgrp.uuid
    }

    It "Change 1 Member ($pester_userlocal2)" {
        Get-FGTUserGroup -name $pester_usergroup1 | Set-FGTUserGroup -member $pester_userlocal2
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "1"
        $usergroup.member.name | Should -BeIn $pester_userlocal2
    }

    It "Change 2 Members ($pester_userlocal and $pester_userlocal2)" {
        Get-FGTUserGroup -name $pester_usergroup1 | Set-FGTUserGroup -member $pester_userlocal, $pester_userlocal2
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "2"
        $usergroup.member.name | Should -BeIn $pester_userlocal, $pester_userlocal2
    }

    It "Change -data (1 field)" {
        $data = @{ "authtimeout" = 23 }
        Get-FGTUserGroup -name $pester_usergroup1 | Set-FGTUserGroup -data $data
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "2"
        $usergroup.member.name | Should -BeIn $pester_userlocal, $pester_userlocal2
        $usergroup.authtimeout | Should -Be "23"
    }

    It "Change -data (2 fields)" {
        $data = @{ "authtimeout" = 44 ; "auth-concurrent-override" = "enable" }
        Get-FGTUserGroup -name $pester_usergroup1 | Set-FGTUserGroup -data $data
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "2"
        $usergroup.member.name | Should -BeIn $pester_userlocal, $pester_userlocal2
        $usergroup.authtimeout | Should -Be "44"
        $usergroup.'auth-concurrent-override' | Should -Be "enable"
    }

    It "Change Name" {
        Get-FGTUserGroup -name $pester_usergroup1 | Set-FGTUserGroup -name "pester_usergroup1_change"
        $usergroup = Get-FGTUserGroup -name "pester_usergroup1_change"
        $usergroup.name | Should -Be "pester_usergroup1_change"
        ($usergroup.member).count | Should -Be "2"
        $usergroup.member.name | Should -BeIn $pester_userlocal, $pester_userlocal2
    }

    AfterAll {
        #Remove User group before User...
        Get-FGTUserGroup -name pester_usergroup1_change | Remove-FGTUserGroup -confirm:$false

        Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
        Get-FGTUserLocal -name $pester_userlocal2 | Remove-FGTUserLocal -confirm:$false
    }

}

Describe "Copy User Group" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal -Name $pester_userlocal -passwd $pester_userlocalpassword
        Add-FGTUserLocal -Name $pester_userlocal2 -passwd $pester_userlocalpassword

        Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal, $pester_userlocal2
    }


    It "Copy User Group ($pester_usergroup1 => copy_pester_Usergroup1)" {
        Get-FGTUserGroup -name $pester_usergroup1 | Copy-FGTUserGroup -name copy_pester_Usergroup1
        $usergroup = Get-FGTUserGroup -name copy_pester_Usergroup1
        $usergroup.name | Should -Be "copy_pester_Usergroup1"
        ($usergroup.member).count | Should -Be "2"
        $usergroup.member.name | Should -BeIn $pester_userlocal, $pester_userlocal2
    }

    AfterAll {
        #Remove User group before User...

        #Remove copy_pester_User1
        Get-FGTUserGroup -name copy_pester_Usergroup1 | Remove-FGTUserGroup -confirm:$false

        Get-FGTUserGroup -name $pester_usergroup1 | Remove-FGTUserGroup -confirm:$false

        Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
        Get-FGTUserLocal -name $pester_userlocal2 | Remove-FGTUserLocal -confirm:$false
    }

}

Describe "Remove User Group" {

    BeforeEach {
        Add-FGTUserLocal -Name $pester_userlocal -passwd $pester_userlocalpassword

        Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal
    }

    It "Remove User Group $pester_usergroup1 by pipeline" {
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup | Remove-FGTUserGroup -confirm:$false
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup | Should -Be $NULL
    }

    AfterAll {
        Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
    }

}

Describe "Remove User Group Member" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal -Name $pester_userlocal -passwd $pester_userlocalpassword
        Add-FGTUserLocal -Name $pester_userlocal2 -passwd $pester_userlocalpassword
        Add-FGTUserLocal -Name $pester_userlocal3 -passwd $pester_userlocalpassword
    }

    BeforeEach {
        Add-FGTUserGroup -Name $pester_usergroup1 -member $pester_userlocal, $pester_userlocal2, $pester_userlocal3
    }

    AfterEach {
        Get-FGTUserGroup -name $pester_usergroup1 | Remove-FGTUserGroup -confirm:$false
    }

    It "Remove 1 member to User Group $pester_usergroup1 (with 3 members before)" {
        Get-FGTUserGroup -Name $pester_usergroup1 | Remove-FGTUserGroupMember -member $pester_userlocal
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "2"
        $usergroup.member.name | Should -BeIn $pester_userlocal2, $pester_userlocal3
    }

    It "Remove 2 members to User Group $pester_usergroup1 (with 3 members before)" {
        Get-FGTUserGroup -Name $pester_usergroup1 | Remove-FGTUserGroupMember -member $pester_userlocal2, $pester_userlocal3
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "1"
        $usergroup.member.name | Should -BeIn $pester_userlocal
    }

    It "Remove 3 members to User Group $pester_usergroup1 (with 3 members before)" {
        Get-FGTUserGroup -Name $pester_usergroup1 | Remove-FGTUserGroupMember -member $pester_userlocal, $pester_userlocal2, $pester_userlocal3
        $usergroup = Get-FGTUserGroup -name $pester_usergroup1
        $usergroup.name | Should -Be $pester_usergroup1
        ($usergroup.member).count | Should -Be "0"
    }

    AfterAll {
        Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
        Get-FGTUserLocal -name $pester_userlocal2 | Remove-FGTUserLocal -confirm:$false
        Get-FGTUserLocal -name $pester_userlocal3 | Remove-FGTUserLocal -confirm:$false
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}