#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get zone" {

    BeforeAll {
        Add-FGTSystemZone -name "PowerFGT" -intrazone deny -interfaces port9,port10
    }

    It "Get Zones does not throw" {
        {
            Get-FGTSystemZone
        } | Should -Not -Throw
    }

    It "Get ALL zones" {
        $zone = Get-FGTSystemZone
        @($zone).count | Should -Not -Be $NULL
    }

    It "Get ALL zones with -skip" {
        $zone = Get-FGTSystemZone -skip
        @($zone).count | Should -Not -Be $NULL
    }

    It "Get zone (PowerFGT)" {
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.name | Should -Be "PowerFGT"
    }

    Context "Search" {

        It "Search zone by name (PowerFGT)" {
            $zone = Get-FGTSystemZone -name "PowerFGT"
            @($zone).count | Should -be 1
            $zone.name | Should -Be "PowerFGT"
        }
    }

    AfterAll {
        Remove-FGTSystemZone -name PowerFGT
    }

}

Describe "Add zone" {

    AfterEach {
        Remove-FGTSystemZone -name PowerFGT
    }

    It "Add zone PowerFGT with intrazone deny" {
        Add-FGTSystemZone -name "PowerFGT" -intrazone deny 
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.intrazone | Should -Be "deny"
    }

    It "Add zone PowerFGT with intrazone allow" {
        Add-FGTSystemZone -name "PowerFGT" -intrazone allow 
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.intrazone | Should -Be "allow"
    }

    It "Add zone PowerFGT with 0 interface" {
        Add-FGTSystemZone -name "PowerFGT" 
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.interface | Should -Be $NULL
    }

    It "Add zone PowerFGT with 1 interface" {
        Add-FGTSystemZone -name "PowerFGT" -interfaces port9
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.interface."interface-name" | Should -Be "port9"
    }

    It "Add zone PowerFGT with 2 interfaces" {
        Add-FGTSystemZone -name "PowerFGT" -interfaces port9,port10
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.interface."interface-name"[0] | Should -Be "port9"
        $zone.interface."interface-name"[1] | Should -Be "port10"
    }

    It "Add zone PowerFGT with intrazone and interfaces" {
        Add-FGTSystemZone -name "PowerFGT" -intrazone deny -interfaces port9,port10
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.name | Should -Be "PowerFGT"
        $zone.intrazone | Should -Be "deny"
        $zone.interface."interface-name"[0] | Should -Be "port9"
        $zone.interface."interface-name"[1] | Should -Be "port10"
    }

    It "Try to add zone PowerFGT (but there is already an object with same name)" {
        #Add first zone
        Add-FGTSystemZone -name PowerFGT
        #Add Second zone with same name
        { Add-FGTSystemZone -name PowerFGT } | Should -Throw "Already a zone using the same name"
    }
}

Describe "Set zone" {

    BeforeEach {
        Add-FGTSystemZone -name "PowerFGT" -intrazone deny -interfaces port9,port10
    }
    AfterEach {
        Remove-FGTSystemZone -name PowerFGT
    }

    It "Change name" {
        Set-FGTSystemZone -name "PowerFGT" -zone_name "PowerFGT_new"
        $zone = Get-FGTSystemZone -name "PowerFGT_new"
        $zone.name | Should -Be "PowerFGT_new"
        Set-FGTSystemZone -name "PowerFGT_new" -zone_name "PowerFGT"
    }

    It "Change name using pipelines" {
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.name | Set-FGTSystemZone -zone_name "PowerFGT_new"
        $zone = Get-FGTSystemZone -name "PowerFGT_new"
        $zone.name | Should -Be "PowerFGT_new"
        Set-FGTSystemZone -name "PowerFGT_new" -zone_name "PowerFGT"
    }

    It "Change intrazone" {
        Set-FGTSystemZone -name "PowerFGT" -intrazone allow
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.intrazone | Should -Be "allow"
    }

    It "Change interfaces" {
        Set-FGTSystemZone -name "PowerFGT" -interfaces port7,port8
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.interface."interface-name"[0] | Should -Be "port7"
        $zone.interface."interface-name"[1] | Should -Be "port8"
    }
}

Describe "Remove zone" {

    BeforeEach {
        Add-FGTSystemZone -name PowerFGT
    }

    It "Remove zone PowerFGT by filtering the name" {
        $zone = Get-FGTSystemZone -name "PowerFGT"
        Remove-FGTSystemZone -name "PowerFGT" 
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone | Should -Be $NULL
    }

    It "Remove zone PowerFGT by pipeline" {
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone.name | Remove-FGTSystemZone
        $zone = Get-FGTSystemZone -name "PowerFGT"
        $zone | Should -Be $NULL
    }
}

Disconnect-FGT -confirm:$false
