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

AfterAll {
    Disconnect-FGT -confirm:$false
}