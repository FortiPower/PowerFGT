#
# Copyright 2022, Cedric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get User Local" {

    BeforeAll {
        Add-FGTUserLocal -name $pester_userlocal -passwd $pester_userlocalpassword
        #$script:uuid = $addr.uuid
    }

    It "Get User Local Does not throw an error" {
        {
            Get-FGTUserLocal
        } | Should -Not -Throw
    }

    It "Get ALL User Local" {
        $userlocal = Get-FGTUserLocal
        $userlocal.count | Should -Not -Be $NULL
    }

    It "Get ALL User Local with -skip" {
        $userlocal = Get-FGTUserLocal -skip
        $userlocal.count | Should -Not -Be $NULL
    }

    It "Get User Local ($pester_userlocal)" {
        $userlocal = Get-FGTUserLocal -name $pester_userlocal
        $userlocal.name | Should -Be $pester_userlocal
    }

    It "Get User Local ($pester_userlocal) and confirm (via Confirm-FGTUserLocal)" {
        $userlocal = Get-FGTUserLocal -name $pester_userlocal
        Confirm-FGTUserLocal ($userlocal) | Should -Be $true
    }

    It "Get User Local with meta" {
        $userlocal = Get-FGTUserLocal -name $pester_userlocal -meta
        $userlocal.q_ref | Should -Not -BeNullOrEmpty
        $userlocal.q_static | Should -Not -BeNullOrEmpty
        $userlocal.q_no_rename | Should -Not -BeNullOrEmpty
        $userlocal.q_global_entry | Should -Not -BeNullOrEmpty
        $userlocal.q_type | Should -Not -BeNullOrEmpty
        $userlocal.q_path | Should -Be "user"
        $userlocal.q_name | Should -Be "local"
        $userlocal.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $userlocal.q_no_edit | Should -Not -BeNullOrEmpty
        }
        $userlocal.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search User Local by name ($pester_userlocal)" {
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            @($userlocal).count | Should -be 1
            $userlocal.name | Should -Be $pester_userlocal
        }

    }

    AfterAll {
        Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
    }

}

Describe "Add User Local" {

    Context "Local User (Email, MFA, etc)" {

        AfterEach {
            Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
        }

        It "Add User Local $pester_userlocal enable" {
            Add-FGTUserLocal -Name $pester_userlocal -status -passwd $pester_userlocalpassword
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -BeNullOrEmpty
            $userlocal.'two-factor' | Should -Be "disable"
        }

        It "Add User Local $pester_userlocal email to" {
            Add-FGTUserLocal -Name $pester_userlocal -email_to "powerfgt@power.fgt" -passwd $pester_userlocalpassword
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "disable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -Be "disable"
        }

        It "Add User Local $pester_userlocal MFA by email" {
            Add-FGTUserLocal -Name $pester_userlocal -status -two_factor email -email_to "powerfgt@power.fgt" -passwd $pester_userlocalpassword
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -Be "email"
        }

        It "Add User Local $pester_userlocal email with -data" {
            $data = @{ "email-to" = "powerfgt@power.fgt" }
            Add-FGTUserLocal -Name $pester_userlocal -status -data $data -passwd $pester_userlocalpassword
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
        }

        It "Try to Add User Local $pester_userlocal (but there is already a object with same name)" {
            #Add first userlocal
            Add-FGTUserLocal -Name $pester_userlocal -status -passwd $pester_userlocalpassword
            #Add Second userlocal with same name
            { Add-FGTUserLocal -Name $pester_userlocal -status -passwd $pester_userlocalpassword } | Should -Throw "Already a Local User object using the same name"
        }

    }

}

Describe "Configure User Local" {

    Context "Change name, email, MFA, etc" {

        BeforeAll {
            Add-FGTUserLocal -Name $pester_userlocal -passwd $pester_userlocalpassword
        }

        It "Change status User Local to disable" {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -status:$false
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "disable"
            $userlocal.'email-to' | Should -BeNullOrEmpty
            $userlocal.'two-factor' | Should -Be "disable"
        }

        It "Change status User Local to enable" {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -status
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -BeNullOrEmpty
            $userlocal.'two-factor' | Should -Be "disable"
        }

        It "Change email to" {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -email_to "powerfgt@power.fgt"
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -Be "disable"
        }

        It "Enable MFA by email" {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -two_factor email
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -Be "email"
        }

        It "Change Password (With FortiOS > 7.4.0)" -skip:($fgt_version -ge "7.4.0") {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -passwd $mywrongpassword
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -Be "email"
        }

        It "Try to Change Password (With FortiOS >= 7.4.0)" -skip:($fgt_version -lt "7.4.0") {
            { Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -passwd $mywrongpassword } | Should -Throw "Can't change passwd with FortiOS > 7.4.0 (Need to use Set-FGTMonitorUserLocalChangePassword)"
        }

        It "Change Password (With FortiOS >= 7.4.0) with Set-FGTMonitorUserLocalChangePassword" -skip:($fgt_version -lt "7.4.0") {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTMonitorUserLocalChangePassword -new_password $mywrongpassword
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
        }

        It "Try to Change Password (with FortiOS < 7.4.0) with Set-FGTMonitorUserLocalChangePassword" -skip:($fgt_version -ge "7.4.0") {
            { Get-FGTUserLocal -name $pester_userlocal | Set-FGTMonitorUserLocalChangePassword -new_password $mywrongpassword } | Should -Throw "You need to use Set-FGTLocalUser -passwd..."
        }

        It "Change Name" {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -name "pester_userlocal_change"
            $userlocal = Get-FGTUserLocal -name "pester_userlocal_change"
            $userlocal.name | Should -Be "pester_userlocal_change"
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -Be "email"
        }

        It "Change email to with -data" {
            $data = @{ "email-to" = "powerfgt@power.fgt" }
            Get-FGTUserLocal -name "pester_userlocal_change" | Set-FGTUserLocal -data $data
            $userlocal = Get-FGTUserLocal -name "pester_userlocal_change"
            $userlocal.name | Should -Be "pester_userlocal_change"
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -Be "email"
        }

        AfterAll {
            Get-FGTUserLocal -name "pester_userlocal_change" | Remove-FGTUserLocal -confirm:$false
        }

    }
}

Describe "Remove User Local" {

    Context "local" {

        BeforeEach {
            Add-FGTUserLocal -Name $pester_userlocal -passwd $pester_userlocalpassword
        }

        It "Remove User Local $pester_userlocal by pipeline" {
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal | Remove-FGTUserLocal -confirm:$false
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal | Should -Be $NULL
        }

    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}