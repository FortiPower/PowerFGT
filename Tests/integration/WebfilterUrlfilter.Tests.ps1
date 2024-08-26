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

    It "Add URL Filter $pester_url1 with type simple" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -BeNullOrEmpty
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"

    }

    It "Add URL Filter $pester_url1 with type wildcard" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type wildcard -url "*powerfgt.com" -action allow -status enable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -BeNullOrEmpty
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "*powerfgt.com"
        $urlfilter.entries.type | Should -Be "wildcard"
    }

    It "Add URL Filter $pester_url1 with type regex" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type regex -url "https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)" -action allow -status enable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -BeNullOrEmpty
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)"
        $urlfilter.entries.type | Should -Be "regex"
    }

    It "Add URL Filter $pester_url1 with action allow" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -BeNullOrEmpty
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"
        $urlfilter.entries.action | Should -Be "allow"
    }

    It "Add URL Filter $pester_url1 with action block" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action block -status enable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -BeNullOrEmpty
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"
        $urlfilter.entries.action | Should -Be "block"
    }

    It "Add URL Filter $pester_url1 with action monitor" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action monitor -status enable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -BeNullOrEmpty
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"
        $urlfilter.entries.action | Should -Be "monitor"
    }

    It "Add URL Filter $pester_url1 enabled" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -Be "Added by PowerFGT"
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"
        $urlfilter.entries.action | Should -Be "allow"
        $urlfilter.entries.status | Should -Be "enable"
    }

    It "Add URL Filter $pester_url1 disabled" {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status disable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -Be "Added by PowerFGT"
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"
        $urlfilter.entries.action | Should -Be "allow"
        $urlfilter.entries.status | Should -Be "disable"
    }

    It "Try to Add URL Filter $pester_url1 (but there is already a object with same name)" {
        #Add first URL Filter
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
        #Add Second URL Filter with same name
        { Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable } | Should -Throw "Already a URL profile object using the same name"
    }

    It "Try to Add a second URL to Filter $pester_url1 " {
        #Add first URL Filter
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
        #Add Second URL
        { Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 2 -url_type simple -url powerfgt2.com -action allow -status enable } | Should -Not -Throw
    }

    AfterEach {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Remove-FGTWebfilterUrlfilter -confirm:$false
    }

}

Describe "Set WebFilter UrlFilter" {

    BeforeAll {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
    }

    It "Change URL Filter $pester_url1 comment" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -comment "Changed by PowerFGT !"
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.comment | Should -Be "Changed by PowerFGT !"
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"
        $urlfilter.entries.action | Should -Be "allow"
        $urlfilter.entries.status | Should -Be "enable"
    }

    It "Change URL Filter $pester_url1 type to wildcard" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -url_id 1 -url_type wildcard -url "*powerfgt.com"
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "*powerfgt.com"
        $urlfilter.entries.type | Should -Be "wildcard"
    }

    It "Change URL Filter $pester_url1 type to regex" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -url_id 1 -url_type regex -url "https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)"
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)"
        $urlfilter.entries.type | Should -Be "regex"
    }

    It "Change URL Filter $pester_url1 type to simple" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -url_id 1 -url_type simple -url powerfgt.com
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt.com"
        $urlfilter.entries.type | Should -Be "simple"
    }

        It "Change URL Filter $pester_url1 to action block" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -url_id 1 -action block
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.action | Should -Be "block"
    }

    It "Change URL Filter $pester_url1 to action allow" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -url_id 1 -action allow
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.action | Should -Be "allow"
    }

    It "Change URL Filter $pester_url1 to action monitor" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -url_id 1 -action monitor
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.action | Should -Be "monitor"
    }

    It "Add URL Filter $pester_url1 to status disabled" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -url_id 1 -status disable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.status | Should -Be "disable"
    }

    It "Change URL Filter $pester_url1 to status enabled" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -url_id 1 -status enable
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.status | Should -Be "enable"
    }

    It "Change URL Filter $pester_url1 URL" {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Set-FGTWebfilterUrlfilter -url_id 1 -url powerfgt2.com
        $urlfilter = Get-FGTWebfilterUrlfilter -name $pester_url1
        $urlfilter.name | Should -Be $pester_url1
        $urlfilter.entries.id | Should -Be 1
        $urlfilter.entries.url | Should -Be "powerfgt2.com"
        $urlfilter.entries.type | Should -Be "simple"
    }

    AfterEach {
        Get-FGTWebfilterUrlfilter -name $pester_url1 | Remove-FGTWebfilterUrlfilter -confirm:$false
    }

}

Describe "Remove Web Filter Url Filter" {

    BeforeAll {
        Add-FGTWebfilterUrlfilter -name $pester_url1 -url_id 1 -url_type simple -url powerfgt.com -action allow -status enable
    }

    It "Remove WebFilterURLFilter $pester_url1 by pipeline" {
        $url = Get-FGTWebfilterUrlfilter -name $pester_url1
        $url | Remove-FGTFirewallAddress -confirm:$false
        $url = Get-FGTWebfilterUrlfilter -name $pester_url1
        $url | Should -Be $NULL
    }

    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}