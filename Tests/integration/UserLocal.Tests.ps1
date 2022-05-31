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
        Add-FGTUserLocal -name $pester_userlocal -password $pester_userlocalpassword
        #$script:uuid = $addr.uuid
    }

    It "Get User Local Does not throw an error" {
        {
            Get-FGTUserLocal
        } | Should -Not -Throw
    }

    It "Get ALL userlocal" {
        $userlocal = Get-FGTUserLocal
        $userlocal.count | Should -Not -Be $NULL
    }

    It "Get ALL userlocal with -skip" {
        $userlocal = Get-FGTUserLocal -skip
        $userlocal.count | Should -Not -Be $NULL
    }

    It "Get userlocal ($pester_userlocal)" {
        $userlocal = Get-FGTUserLocal -name $pester_userlocal
        $userlocal.name | Should -Be $pester_userlocal
    }

    It "Get userlocal ($pester_userlocal) and confirm (via Confirm-FGTUserLocal)" {
        $userlocal = Get-FGTUserLocal -name $pester_userlocal
        Confirm-FGTuserlocal ($userlocal) | Should -Be $true
    }

    Context "Search" {

        It "Search userlocal by name ($pester_userlocal)" {
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            @($userlocal).count | Should -be 1
            $userlocal.name | Should -Be $pester_userlocal
        }

        <#It "Search userlocal by uuid ($script:uuid)" {
            $userlocal = Get-FGTUserLocal -uuid $script:uuid
            @($userlocal).count | Should -be 1
            $userlocal.name | Should -Be $pester_userlocal
        }#>

    }

    AfterAll {
        Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
    }

}

Describe "Add User Local" {

    Context "local" {

        AfterEach {
            Get-FGTUserLocal -name $pester_userlocal | Remove-FGTUserLocal -confirm:$false
        }

        It "Add userlocal $pester_userlocal enable" {
            Add-FGTUserLocal -Name $pester_userlocal -status -password $pester_userlocalpassword
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -BeNullOrEmpty
            $userlocal.'two-factor' | Should -BeNullOrEmpty
        }

        It "Add userlocal $pester_userlocal email to" {
            Add-FGTUserLocal -Name $pester_userlocal -email_to "powerfgt@power.fgt" -password $pester_userlocalpassword
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "disable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -BeNullOrEmpty
        }

        It "Add userlocal $pester_userlocal MFA" {
            Add-FGTUserLocal -Name $pester_userlocal -status -two_factor email -email_to "powerfgt@power.fgt" -password $pester_userlocalpassword
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "disable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -Be "email"
            }

        It "Try to Add userlocal $pester_userlocal (but there is already a object with same name)" {
            #Add first userlocal
            Add-FGTUserLocal -Name $pester_userlocal -status -password $pester_userlocalpassword
            #Add Second userlocal with same name
            { Add-FGTUserLocal -Name $pester_userlocal -status -password $pester_userlocalpassword } | Should -Throw "Already a user object using the same name"
        }

    }

}

Describe "Configure User Local" {

    Context "local" {

        BeforeAll {
            $userlocal = Add-FGTUserLocal -Name $pester_userlocal -password $pester_userlocalpassword
        }

        It "Change status userlocal" {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -status
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "enable"
            $userlocal.'email-to' | Should -BeNullOrEmpty
            $userlocal.'two-factor' | Should -BeNullOrEmpty
        }

        It "Change email to" {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -email_to "powerfgt@power.fgt"
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "disable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -BeNullOrEmpty
        }

        It "Change MFA" {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -two_factor email
            $userlocal = Get-FGTUserLocal -name $pester_userlocal
            $userlocal.name | Should -Be $pester_userlocal
            $userlocal.status | Should -Be "disable"
            $userlocal.'email-to' | Should -Be "powerfgt@power.fgt"
            $userlocal.'two-factor' | Should -Be "email"
        }

        It "Change Name" {
            Get-FGTUserLocal -name $pester_userlocal | Set-FGTUserLocal -name "pester_userlocal_change"
            $userlocal = Get-FGTUserLocal -name "pester_userlocal_change"
            $userlocal.name | Should -Be "pester_userlocal_change"
            $userlocal.status | Should -Be "disable"
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
            Add-FGTUserLocal -Name $pester_userlocal -password $pester_userlocalpassword
        }

        It "Remove userlocal $pester_userlocal by pipeline" {
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