#
# Copyright 2020-2021, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get System Global" {

    It "Get System Global does not throw" {
        {
            Get-FGTSystemGlobal
        } | Should -Not -Throw
    }

    It "Get ALL Global with -skip" {
        $ss = Get-FGTSystemGlobal -skip
        @($ss).count | Should -Not -Be $NULL
    }

    Context "Search" {

        It "Search a System Setting by name (language)" {
            $ss = Get-FGTSystemGlobal -name "language"
            $ss.'language' | Should -Be -Not $NULL
            $ss.'timezone'  | Should -Be $NULL
        }

        It "Search 2 System Global by name (language, timezone)" {
            $ss = Get-FGTSystemGlobal -name "language", "timezone"
            $ss.'language' | Should -Be -Not $NULL
            $ss.'gui-dns-database'  | Should -Be $NULL
            $ss.'timezone'  | Should -Be -Not $NULL
        }

        It "Search 1 System Global by name (language)" {
            $ss = Get-FGTSystemGlobal -name "language"
            $ss.'language' | Should -Be -Not $NULL
            $ss.'timezone'  | Should -Be $NULL
        }
    }
}

Describe "Set System Global" {

    It "Change admintimeout to 480" {
        Set-FGTSystemGlobal -admintimeout 480
        $sg = Get-FGTSystemGlobal
        $sg.'admintimeout' | Should -Be "480"
    }

    It "Change admin_port (HTTP)" -Skip:($httpOnly) {
        Set-FGTSystemGlobal -admin_port 8080
        $sg = Get-FGTSystemGlobal
        $sg.'admin-port' | Should -Be "8080"
    }

    It "Change admin_sport (HTTPS)" -Skip:($httpOnly -eq $false) {
        Set-FGTSystemGlobal -admin_sport 8443
        $sg = Get-FGTSystemGlobal
        $sg.'admin-sport' | Should -Be "8443"
    }

    It "Change admin_ssh_port" {
        Set-FGTSystemGlobal -admin_ssh_port 8022
        $sg = Get-FGTSystemGlobal
        $sg.'admin-ssh-port' | Should -Be "8022"
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}