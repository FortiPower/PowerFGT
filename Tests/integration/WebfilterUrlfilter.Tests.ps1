#
# Copyright 2022, Cédric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get WebFilter UrlFilter" {

    BeforeAll {
        $urlfilter = Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
        $script:uuid = $urlfilter.id
        Add-FGTWebfilterUrlfilter -name $pester_url2 -url_id 2 -url_type wildcard -url *powerfgt.com -action allow -status enable
    }

    It "Get WebFilter UrlFilter Does not throw an error" {
        {
            Get-FGTWebfilterUrlfilter
        } | Should -Not -Throw
    }

    It "Get ALL URL Filter" {
        $urlfilter = Get-FGTWebfilterUrlfilter
        $urlfilter.count | Should -Not -Be $NULL
    }

    It "Get ALL URL Filter with -skip" {
        $urlfilter = Get-FGTWebfilterUrlfilter -skip
        $urlfilter.count | Should -Not -Be $NULL
    }

    It "Get URL Filter ($pester_url1)" {
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
    }

    It "Get URL Filter ($pester_url1) and confirm (via Confirm-FGTWebfilterUrlfilter)" {
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        Confirm-FGTWebfilterUrlfilter ($urlfilter) | Should -Be $true
    }

    Context "Search" {

        It "Search URL Filter by name ($pester_url1)" {
            $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
            @($urlfilter).count | Should -be 1
            $urlfilter.name | Should -Be $pester_url1
        }

        It "Search URL Filter by uuid ($script:uuid)" {
            $urlfilter = Get-FGTWebfilterUrlfilter -id $script:uuid
            @($urlfilter).count | Should -be 1
            $urlfilter.name | Should -Be $pester_url1
        }

    }

    AfterAll {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Remove-FGTWebfilterUrlfilter -confirm:$false
        Get-FGTWebfilterUrlfilter -name $pester_url2 | Remove-FGTWebfilterUrlfilter -confirm:$false
    }

}

Describe "Add WebFilter UrlFilter" {

    AfterEach {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Remove-FGTWebfilterUrlfilter -confirm:$false
    }

    It "Add URL Filter $pester_url1" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -BeNullOrEmpty
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"
        $urlfilter.entries.action | Should -Be "allow"
        $urlfilter.entries.status | Should -Be "enable"
    }

    It "Add URL Filter $pester_url1 (with comment)" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable -comment "Added by PowerFGT"
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -Be "Added by PowerFGT"
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"
        $urlfilter.entries.action | Should -Be "allow"
        $urlfilter.entries.status | Should -Be "enable"
    }

    It "Try to Add URL Filter $pester_url1 (but there is already a object with same name)" {
        #Add first URL Filter
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
        #Add Second URL Filter with same name
        { Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable } | Should -Throw "Already a URL profile object using the same name"
    }

}