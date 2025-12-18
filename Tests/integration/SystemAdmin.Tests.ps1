#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get System Admin" {

    BeforeAll {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin
    }

    It "Get System Admin does not throw an error" {
        {
            Get-FGTSystemAdmin
        } | Should -Not -Throw
    }

    It "Get ALL System Admins" {
        $admin = Get-FGTSystemAdmin
        @($admin).count | Should -Not -Be $NULL
    }

    It "Get ALL System Admin with -skip" {
        $admin = Get-FGTSystemAdmin -skip
        @($admin).count | Should -Not -Be $NULL
    }

    It "Get System Admin -Schema" {
        $schema = Get-FGTSystemAdmin -schema
        $schema | Should -Not -BeNullOrEmpty
        $schema.name | Should -Be "admin"
        $schema.category | Should -Not -BeNullOrEmpty
        $schema.children | Should -Not -BeNullOrEmpty
        $schema.mkey | Should -Be "name"
    }

    It "Get System Admin ($pester_admin1)" {
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
    }

    It "Get System Admin ($pester_admin1) and confirm (via Confirm-FGTSystemAdmin)" {
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        Confirm-FGTSystemAdmin $admin | Should -Be $true
    }

    It "Get System Admin ($pester_admin1) with meta" {
        $admin = Get-FGTSystemAdmin -name $pester_admin1 -meta
        $admin.name | Should -Be $pester_admin1
        $admin.q_ref | Should -Not -BeNullOrEmpty
        $admin.q_static | Should -Not -BeNullOrEmpty
        $admin.q_no_rename | Should -Not -BeNullOrEmpty
        $admin.q_global_entry | Should -Not -BeNullOrEmpty
        $admin.q_type | Should -Not -BeNullOrEmpty
        $admin.q_path | Should -Be "system"
        $admin.q_name | Should -Be "admin"
        $admin.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $admin.q_no_edit | Should -Not -BeNullOrEmpty
        }
        #$admin.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search System Admin by name ($pester_admin1)" {
            $admin = Get-FGTSystemAdmin -name $pester_admin1
            @($admin).count | Should -be 1
            $admin.name | Should -Be $pester_admin1
        }

    }

    AfterAll {
        Get-FGTSystemAdmin -name $pester_admin1 | Remove-FGTSystemAdmin -Confirm:$false
    }

}

Describe "Add System Admin" {

    AfterEach {
        Get-FGTSystemAdmin -name $pester_admin1 | Remove-FGTSystemAdmin -Confirm:$false
    }

    It "Add System Admin with only mandatory parameters (password and accprofile)" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
    }

    It "Add System Admin with comments" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -comments "Added via PowerFGT"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.comments | Should -Be "Added via PowerFGT"
    }

    It "Add System Admin with trusthost1" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost1 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost2" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost2 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost3" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost3 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost4" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost4 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost5" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost5 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost6" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost6 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost7" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost7 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost7" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost7 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost8" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost8 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost9" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost9 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with trusthost10" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost10 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "192.0.2.1 255.255.255.255"
    }

    It "Add System Admin with all trusthost (1 to 10)" {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -trusthost1 192.0.2.1/32 -trusthost2 192.0.2.2/32 -trusthost3 192.0.2.3/32 -trusthost4 192.0.2.4/32 -trusthost5 192.0.2.5/32 -trusthost6 192.0.2.6/32 -trusthost7 192.0.2.7/32 -trusthost8 192.0.2.8/32 -trusthost9 192.0.2.9/32 -trusthost10 192.0.2.10/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin.trusthost1 | Should -Be "192.0.2.1 255.255.255.255"
        $admin.trusthost2 | Should -Be "192.0.2.2 255.255.255.255"
        $admin.trusthost3 | Should -Be "192.0.2.3 255.255.255.255"
        $admin.trusthost4 | Should -Be "192.0.2.4 255.255.255.255"
        $admin.trusthost5 | Should -Be "192.0.2.5 255.255.255.255"
        $admin.trusthost6 | Should -Be "192.0.2.6 255.255.255.255"
        $admin.trusthost7 | Should -Be "192.0.2.7 255.255.255.255"
        $admin.trusthost8 | Should -Be "192.0.2.8 255.255.255.255"
        $admin.trusthost9 | Should -Be "192.0.2.9 255.255.255.255"
        $admin.trusthost10 | Should -Be "192.0.2.10 255.255.255.255"
    }

    It "Add System Admin (with -data (1 field))" {
        $data = @{ "guest-auth" = "enable" }
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -data $data
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin."guest-auth" | Should -Be "enable"
    }

    It "Add System Admin (with -data (2 fields))" {
        $data = @{ "two-factor" = "email"; "email-to" = "admin@fgt.power" }
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin -data $data
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "super_admin"
        $admin."two-factor" | Should -Be "email"
        $admin."email-to" | Should -Be "admin@fgt.power"
    }

}

Describe "Set System Admin" {

    BeforeAll {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin
    }

    It "Set System Admin access profile (prof_admin)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -accprofile prof_admin
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.accprofile | Should -Be "prof_admin"
    }

    It "Set System Admin commments" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -comments "Modified via PowerFGT"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.password | Should -Not -Be $NULL
        $admin.comments | Should -Be "Modified via PowerFGT"
    }

    It "Set System Admin trusthost1" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost1 192.0.2.1/32
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "192.0.2.1 255.255.255.255"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "0.0.0.0 0.0.0.0"
    }

    It "Set System Admin trusthost2 (and trusthost1 any)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost2 192.0.2.2/32 -trusthost1 "0.0.0.0 0.0.0.0"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "192.0.2.2 255.255.255.255"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "0.0.0.0 0.0.0.0"
    }

    It "Set System Admin trusthost3 (and trusthost2 any)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost3 192.0.2.3/32 -trusthost2 "0.0.0.0 0.0.0.0"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "192.0.2.3 255.255.255.255"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "0.0.0.0 0.0.0.0"
    }

    It "Set System Admin trusthost4 (and trusthost3 any)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost4 192.0.2.4/32 -trusthost3 "0.0.0.0 0.0.0.0"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "192.0.2.4 255.255.255.255"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "0.0.0.0 0.0.0.0"
    }

    It "Set System Admin trusthost5 (and trusthost4 any)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost5 192.0.2.5/32 -trusthost4 "0.0.0.0 0.0.0.0"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "192.0.2.5 255.255.255.255"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "0.0.0.0 0.0.0.0"
    }

    It "Set System Admin trusthost6 (and trusthost5 any)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost6 192.0.2.6/32 -trusthost5 "0.0.0.0 0.0.0.0"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "192.0.2.6 255.255.255.255"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "0.0.0.0 0.0.0.0"
    }

    It "Set System Admin trusthost7 (and trusthost6 any)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost7 192.0.2.7/32 -trusthost6 "0.0.0.0 0.0.0.0"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "192.0.2.7 255.255.255.255"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "0.0.0.0 0.0.0.0"
    }

    It "Set System Admin trusthost8 (and trusthost7 any)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost8 192.0.2.8/32 -trusthost7 "0.0.0.0 0.0.0.0"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "192.0.2.8 255.255.255.255"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "0.0.0.0 0.0.0.0"
    }

    It "Set System Admin trusthost9 (and trusthost8 any)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost9 192.0.2.9/32 -trusthost8 "0.0.0.0 0.0.0.0"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "192.0.2.9 255.255.255.255"
        $admin.trusthost10 | Should -Be "0.0.0.0 0.0.0.0"
    }

    It "Set System Admin trusthost10 (and trusthost9 any)" {
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -trusthost10 192.0.2.10/32 -trusthost9 "0.0.0.0 0.0.0.0"
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin.name | Should -Be $pester_admin1
        $admin.trusthost1 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost2 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost3 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost4 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost5 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost6 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost7 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost8 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost9 | Should -Be "0.0.0.0 0.0.0.0"
        $admin.trusthost10 | Should -Be "192.0.2.10 255.255.255.255"
    }

    It "Set System Admin using -data (1 field)" {
        $data = @{ "guest-auth" = "enable" }
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -data $data
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin."guest-auth" | Should -Be "enable"
    }

    It "Set System Admin using -data (2 fields)" {
        $data = @{"two-factor" = "email"; "email-to" = "admin@fgt.power" }
        Get-FGTSystemAdmin -name $pester_admin1 | Set-FGTSystemAdmin -data $data
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin."two-factor" | Should -Be "email"
        $admin."email-to" | Should -Be "admin@fgt.power"
    }

    AfterAll {
        Get-FGTSystemAdmin -name $pester_admin1 | Remove-FGTSystemAdmin -Confirm:$false
    }

}

Describe "Remove System Admin" {

    BeforeEach {
        Add-FGTSystemAdmin -name $pester_admin1 -password $pester_adminpassword -accprofile super_admin
    }

    It "Remove System Admin by pipeline" {
        Get-FGTSystemAdmin -name $pester_admin1 | Remove-FGTSystemAdmin -confirm:$false
        $admin = Get-FGTSystemAdmin -name $pester_admin1
        $admin | Should -Be $NULL
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}
