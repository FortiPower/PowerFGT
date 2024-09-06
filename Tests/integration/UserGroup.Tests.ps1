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
        Add-FGTUserLocal -Name $pester_User1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTUserLocal -Name $pester_User2 -ip 192.0.2.2 -mask 255.255.255.255
        #Create Usergroup object with one member
        $script:addrgrp = Add-FGTUserGroup -name $pester_Usergroup1 -member $pester_User1
        $script:uuid = $addrgrp.uuid
        Add-FGTUserGroup -name $pester_Usergroup2 -member $pester_User2
    }

    It "Get User Group Does not throw an error" {
        {
            Get-FGTUserGroup
        } | Should -Not -Throw
    }

    It "Get ALL User Group" {
        $Usergroup = Get-FGTUserGroup
        $Usergroup.count | Should -Not -Be $NULL
    }

    It "Get ALL User Group with -skip" {
        $Usergroup = Get-FGTUserGroup -skip
        $Usergroup.count | Should -Not -Be $NULL
    }

    It "Get User Group ($pester_Usergroup1)" {
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
    }

    It "Get User Group ($pester_Usergroup1) and confirm (via Confirm-FGTUserGroup)" {
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        Confirm-FGTUserGroup ($Usergroup) | Should -Be $true
    }

    It "Get User Group ($pester_Usergroup1) and meta" {
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1 -meta
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.q_ref | Should -Not -BeNullOrEmpty
        $Usergroup.q_static | Should -Not -BeNullOrEmpty
        $Usergroup.q_no_rename | Should -Not -BeNullOrEmpty
        $Usergroup.q_global_entry | Should -Not -BeNullOrEmpty
        $Usergroup.q_type | Should -Not -BeNullOrEmpty
        $Usergroup.q_path | Should -Be "user"
        $Usergroup.q_name | Should -Be "group"
        $Usergroup.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $Usergroup.q_no_edit | Should -Not -BeNullOrEmpty
        }
        $Usergroup.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search User Group by name ($pester_Usergroup1)" {
            $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
            @($Usergroup).count | Should -be 1
            $Usergroup.name | Should -Be $pester_Usergroup1
        }

        It "Search User Group by uuid ($script:uuid)" {
            $Usergroup = Get-FGTUserGroup -uuid $script:uuid
            @($Usergroup).count | Should -be 1
            $Usergroup.name | Should -Be $pester_Usergroup1
        }

    }

    AfterAll {
        #Remove User group before User...
        Get-FGTUserGroup -name $pester_Usergroup1 | Remove-FGTUserGroup -confirm:$false
        Get-FGTUserGroup -name $pester_Usergroup2 | Remove-FGTUserGroup -confirm:$false

        Get-FGTUserLocal -name $pester_User1 | Remove-FGTUser -confirm:$false
        Get-FGTUserLocal -name $pester_User2 | Remove-FGTUser -confirm:$false
    }

}

Describe "Add User Group" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal-Name $pester_User1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTUserLocal-Name $pester_User2 -ip 192.0.2.2 -mask 255.255.255.255
    }

    AfterEach {
        Get-FGTUserGroup -name $pester_Usergroup1 | Remove-FGTUserGroup -confirm:$false
    }

    It "Add User Group $pester_Usergroup1 (with 1 member)" {
        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "1"
        $Usergroup.member.name | Should -BeIn $pester_User1
        $Usergroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Add User Group $pester_Usergroup1 (with 1 member and a comment)" {
        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1 -comment "Add via PowerFGT"
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "1"
        $Usergroup.member.name | Should -BeIn $pester_User1
        $Usergroup.comment | Should -Be "Add via PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Add User Group $pester_Usergroup1 (with 1 member and visibility disable)" {
        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1 -visibility:$false
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "1"
        $Usergroup.member.name | Should -BeIn $pester_User1
        $Usergroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be "disable"
        }
    }

    It "Add User Group $pester_Usergroup1 (with 2 members)" {
        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1, $pester_User2
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "2"
        $Usergroup.member.name | Should -BeIn $pester_User1, $pester_User2
        $Usergroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Add User Group $pester_Usergroup1 (with 1 member and data (1 field))" {
        $data = @{ "color" = 23 }
        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1 -data $data
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "1"
        $Usergroup.member.name | Should -BeIn $pester_User1
        $Usergroup.comment | Should -BeNullOrEmpty
        $Usergroup.color | Should -Be "23"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Add User Group $pester_Usergroup1 (with 1 member and data (2 fields))" {
        $data = @{ "color" = 23; "comment" = "Add via PowerFGT and -data" }
        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1 -data $data
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "1"
        $Usergroup.member.name | Should -BeIn $pester_User1
        $Usergroup.comment | Should -Be "Add via PowerFGT and -data"
        $Usergroup.color | Should -Be "23"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Try to Add User Group $pester_Usergroup1 (but there is already a object with same name)" {
        #Add first User Group
        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1
        #Add Second User Group with same name
        { Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1 } | Should -Throw "Already an Usergroup object using the same name"

    }

    AfterAll {
        Get-FGTUserLocal -name $pester_User1 | Remove-FGTUser -confirm:$false
        Get-FGTUserLocal -name $pester_User2 | Remove-FGTUser -confirm:$false
    }

}

Describe "Add User Group Member" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal-Name $pester_User1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTUserLocal-Name $pester_User2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTUserLocal-Name $pester_User3 -ip 192.0.2.3 -mask 255.255.255.255
        Add-FGTUserLocal-Name $pester_User4 -ip 192.0.2.4 -mask 255.255.255.255
    }

    BeforeEach {
        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1
    }

    AfterEach {
        Get-FGTUserGroup -name $pester_Usergroup1 | Remove-FGTUserGroup -confirm:$false
    }

    It "Add 1 member to User Group $pester_Usergroup1 (with 1 member before)" {
        Get-FGTUserGroup -Name $pester_Usergroup1 | Add-FGTUserGroupMember -member $pester_User2
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "2"
        $Usergroup.member.name | Should -BeIn $pester_User1, $pester_User2
        $Usergroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Add 2 members to User Group $pester_Usergroup1 (with 1 member before)" {
        Get-FGTUserGroup -Name $pester_Usergroup1 | Add-FGTUserGroupMember -member $pester_User2, $pester_User3
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "3"
        $Usergroup.member.name | Should -BeIn $pester_User1, $pester_User2, $pester_User3
        $Usergroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Add 2 members to User Group $pester_Usergroup1 (with 2 members before)" {
        Get-FGTUserGroup -Name $pester_Usergroup1 | Add-FGTUserGroupMember -member $pester_User2
        Get-FGTUserGroup -Name $pester_Usergroup1 | Add-FGTUserGroupMember -member $pester_User3, $pester_User4
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "4"
        $Usergroup.member.name | Should -BeIn $pester_User1, $pester_User2, $pester_User3, $pester_User4
        $Usergroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    AfterAll {
        Get-FGTUserLocal -name $pester_User1 | Remove-FGTUser -confirm:$false
        Get-FGTUserLocal -name $pester_User2 | Remove-FGTUser -confirm:$false
        Get-FGTUserLocal -name $pester_User3 | Remove-FGTUser -confirm:$false
        Get-FGTUserLocal -name $pester_User4 | Remove-FGTUser -confirm:$false
    }

}

Describe "Configure User Group" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal-Name $pester_User1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTUserLocal-Name $pester_User2 -ip 192.0.2.2 -mask 255.255.255.255

        $addrgrp = Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1
        $script:uuid = $addrgrp.uuid
    }

    It "Change comment" {
        Get-FGTUserGroup -name $pester_Usergroup1 | Set-FGTUserGroup -comment "Modified by PowerFGT"
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "1"
        $Usergroup.member.name | Should -BeIn $pester_User1
        $Usergroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Change visiblity" {
        Get-FGTUserGroup -name $pester_Usergroup1 | Set-FGTUserGroup -visibility:$false
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "1"
        $Usergroup.member.name | Should -BeIn $pester_User1
        $Usergroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be "disable"
        }
    }

    It "Change 1 Member ($pester_User2)" {
        Get-FGTUserGroup -name $pester_Usergroup1 | Set-FGTUserGroup -member $pester_User2
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "1"
        $Usergroup.member.name | Should -BeIn $pester_User2
        $Usergroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be "disable"
        }
    }

    It "Change 2 Members ($pester_User1 and $pester_User2)" {
        Get-FGTUserGroup -name $pester_Usergroup1 | Set-FGTUserGroup -member $pester_User1, $pester_User2
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "2"
        $Usergroup.member.name | Should -BeIn $pester_User1, $pester_User2
        $Usergroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be "disable"
        }
    }

    It "Change -data (1 field)" {
        $data = @{ "color" = 23 }
        Get-FGTUserGroup -name $pester_Usergroup1 | Set-FGTUserGroup -data $data
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "2"
        $Usergroup.member.name | Should -BeIn $pester_User1, $pester_User2
        $Usergroup.comment | Should -Be "Modified by PowerFGT"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be "disable"
        }
        $Usergroup.color | Should -Be "23"
    }

    It "Change -data (2 fields)" {
        $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
        Get-FGTUserGroup -name $pester_Usergroup1 | Set-FGTUserGroup -data $data
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "2"
        $Usergroup.member.name | Should -BeIn $pester_User1, $pester_User2
        $Usergroup.comment | Should -Be "Modified by PowerFGT via -data"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be "disable"
        }
        $Usergroup.color | Should -Be "4"
    }

    It "Change Name" {
        Get-FGTUserGroup -name $pester_Usergroup1 | Set-FGTUserGroup -name "pester_Usergroup1_change"
        $Usergroup = Get-FGTUserGroup -name "pester_Usergroup1_change"
        $Usergroup.name | Should -Be "pester_Usergroup1_change"
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "2"
        $Usergroup.member.name | Should -BeIn $pester_User1, $pester_User2
        $Usergroup.comment | Should -Be "Modified by PowerFGT via -data"
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be "disable"
        }
    }

    AfterAll {
        #Remove User group before User...
        Get-FGTUserGroup -uuid $script:uuid | Remove-FGTUserGroup -confirm:$false

        Get-FGTUserLocal -name $pester_User1 | Remove-FGTUser -confirm:$false
        Get-FGTUserLocal -name $pester_User2 | Remove-FGTUser -confirm:$false
    }

}

Describe "Copy User Group" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal-Name $pester_User1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTUserLocal-Name $pester_User2 -ip 192.0.2.2 -mask 255.255.255.255

        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1, $pester_User2
    }


    It "Copy User Group ($pester_Usergroup1 => copy_pester_Usergroup1)" {
        Get-FGTUserGroup -name $pester_Usergroup1 | Copy-FGTUserGroup -name copy_pester_Usergroup1
        $Usergroup = Get-FGTUserGroup -name copy_pester_Usergroup1
        $Usergroup.name | Should -Be "copy_pester_Usergroup1"
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "2"
        $Usergroup.member.name | Should -BeIn $pester_User1, $pester_User2
        $Usergroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    AfterAll {
        #Remove User group before User...

        #Remove copy_pester_User1
        Get-FGTUserGroup -name copy_pester_Usergroup1 | Remove-FGTUserGroup -confirm:$false

        Get-FGTUserGroup -name $pester_Usergroup1 | Remove-FGTUserGroup -confirm:$false

        Get-FGTUserLocal -name $pester_User1 | Remove-FGTUser -confirm:$false
        Get-FGTUserLocal -name $pester_User2 | Remove-FGTUser -confirm:$false
    }

}

Describe "Remove User Group" {

    BeforeEach {
        Add-FGTUserLocal-Name $pester_User1 -ip 192.0.2.1 -mask 255.255.255.255

        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1
    }

    It "Remove User Group $pester_Usergroup1 by pipeline" {
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup | Remove-FGTUserGroup -confirm:$false
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup | Should -Be $NULL
    }

    AfterAll {
        Get-FGTUserLocal -name $pester_User1 | Remove-FGTUser -confirm:$false
    }

}

Describe "Remove User Group Member" {

    BeforeAll {
        #Create some User object
        Add-FGTUserLocal-Name $pester_User1 -ip 192.0.2.1 -mask 255.255.255.255
        Add-FGTUserLocal-Name $pester_User2 -ip 192.0.2.2 -mask 255.255.255.255
        Add-FGTUserLocal-Name $pester_User3 -ip 192.0.2.3 -mask 255.255.255.255
    }

    BeforeEach {
        Add-FGTUserGroup -Name $pester_Usergroup1 -member $pester_User1, $pester_User2, $pester_User3
    }

    AfterEach {
        Get-FGTUserGroup -name $pester_Usergroup1 | Remove-FGTUserGroup -confirm:$false
    }

    It "Remove 1 member to User Group $pester_Usergroup1 (with 3 members before)" {
        Get-FGTUserGroup -Name $pester_Usergroup1 | Remove-FGTUserGroupMember -member $pester_User1
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "2"
        $Usergroup.member.name | Should -BeIn $pester_User2, $pester_User3
        $Usergroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Remove 2 members to User Group $pester_Usergroup1 (with 3 members before)" {
        Get-FGTUserGroup -Name $pester_Usergroup1 | Remove-FGTUserGroupMember -member $pester_User2, $pester_User3
        $Usergroup = Get-FGTUserGroup -name $pester_Usergroup1
        $Usergroup.name | Should -Be $pester_Usergroup1
        $Usergroup.uuid | Should -Not -BeNullOrEmpty
        ($Usergroup.member).count | Should -Be "1"
        $Usergroup.member.name | Should -BeIn $pester_User1
        $Usergroup.comment | Should -BeNullOrEmpty
        if ($DefaultFGTConnection.version -lt "6.4.0") {
            $Usergroup.visibility | Should -Be $true
        }
    }

    It "Try Remove 3 members to User Group $pester_Usergroup1 (with 3 members before)" {
        {
            Get-FGTUserGroup -Name $pester_Usergroup1 | Remove-FGTUserGroupMember -member $pester_User1, $pester_User2, $pester_User3
        } | Should -Throw "You can't remove all members. Use Remove-FGTUserGroup to remove User Group"
    }

    AfterAll {
        Get-FGTUserLocal-name $pester_User1 | Remove-FGTUser -confirm:$false
        Get-FGTUserLocal-name $pester_User2 | Remove-FGTUser -confirm:$false
        Get-FGTUserLocal -name $pester_User3 | Remove-FGTUser -confirm:$false
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}