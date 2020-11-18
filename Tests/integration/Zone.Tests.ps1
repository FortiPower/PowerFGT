#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2020, Cédric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get zone" {

    BeforeAll {
        Add-FGTSystemZone -name $pester_zone1
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

    It "Get zone ($pester_zone1)" {
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.name | Should -Be $pester_zone1
    }

    Context "Search" {

        It "Search zone by name ($pester_zone1)" {
            $zone = Get-FGTSystemZone -name $pester_zone1
            @($zone).count | Should -be 1
            $zone.name | Should -Be $pester_zone1
        }
    }

    AfterAll {
        Get-FGTSystemZone $pester_zone1 | Remove-FGTSystemZone
    }

}

Describe "Add zone" {

    AfterEach {
        Get-FGTSystemZone $pester_zone1 | Remove-FGTSystemZone
    }

    It "Add zone $pester_zone1 with intrazone deny" {
        Add-FGTSystemZone -name $pester_zone1 -intrazone deny
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.intrazone | Should -Be "deny"
    }

    It "Add zone $pester_zone1 with intrazone allow" {
        Add-FGTSystemZone -name $pester_zone1 -intrazone allow
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.intrazone | Should -Be "allow"
    }

    It "Add zone $pester_zone1 with 0 interface" {
        Add-FGTSystemZone -name $pester_zone1
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface | Should -Be $NULL
        $zone.interface.count | Should -Be 0
    }

    It "Add zone $pester_zone1 with 1 interface" {
        Add-FGTSystemZone -name $pester_zone1 -interfaces $pester_port1
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface."interface-name" | Should -Be $pester_port1
        $zone.interface.count | Should -Be 1
    }

    It "Add zone $pester_zone1 with 2 interfaces" {
        Add-FGTSystemZone -name $pester_zone1 -interfaces $pester_port1, $pester_port2
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface.count | Should -Be 2
        $zone.interface."interface-name" | Should -BeIn $pester_port1, $pester_port2
    }

    It "Add zone $pester_zone1 with intrazone and interfaces" {
        Add-FGTSystemZone -name $pester_zone1 -intrazone deny -interfaces $pester_port1, $pester_port2
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.name | Should -Be $pester_zone1
        $zone.intrazone | Should -Be "deny"
        $zone.interface.count | Should -Be 2
        $zone.interface."interface-name" | Should -BeIn $pester_port1, $pester_port2
    }

    It "Try to add zone $pester_zone1 (but there is already an object with same name)" {
        #Add first zone
        Add-FGTSystemZone -name $pester_zone1
        #Add Second zone with same name
        { Add-FGTSystemZone -name $pester_zone1 } | Should -Throw "Already a zone using the same name"
    }
}

Describe "Set zone" {

    BeforeEach {
        Add-FGTSystemZone -name $pester_zone1 -intrazone deny -interfaces $pester_port1, $pester_port2
    }
    AfterEach {
        Get-FGTSystemZone $pester_zone1 | Remove-FGTSystemZone
    }

    It "Change name" {
        Get-FGTSystemZone -name $pester_zone1 | Set-FGTSystemZone -name $pester_zone2
        $zone = Get-FGTSystemZone -name $pester_zone2
        $zone.name | Should -Be $pester_zone2
        Get-FGTSystemZone -name $pester_zone2 | Set-FGTSystemZone -name $pester_zone1
    }

    It "Change intrazone in allow" {
        Get-FGTSystemZone -name $pester_zone1 | Set-FGTSystemZone -intrazone allow
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.intrazone | Should -Be "allow"
    }

    It "Change intrazone in deny" {
        Get-FGTSystemZone -name $pester_zone1 | Set-FGTSystemZone -intrazone deny
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.intrazone | Should -Be "deny"
    }

    It "Change interfaces" {
        Get-FGTSystemZone -name $pester_zone1 | Set-FGTSystemZone -interfaces $pester_port1, $pester_port2
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface.count | Should -Be 2
        $zone.interface."interface-name" | Should -BeIn $pester_port1, $pester_port2
    }

    It "Remove interfaces" {
        Get-FGTSystemZone -name $pester_zone1 | Set-FGTSystemZone -interfaces none
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface | Should -Be $NULL
    }
}

Describe "Remove zone" {

    BeforeEach {
        Add-FGTSystemZone -name $pester_zone1
    }

    It "Remove zone $pester_zone1 by filtering the name" {
        $zone = Get-FGTSystemZone -name $pester_zone1
        Get-FGTSystemZone $pester_zone1 | Remove-FGTSystemZone
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone | Should -Be $NULL
    }

    It "Remove zone $pester_zone1 by pipeline" {
        Get-FGTSystemZone $pester_zone1 | Remove-FGTSystemZone
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone | Should -Be $NULL
    }
}

Describe "Remove zone members" {

    BeforeEach {
        Add-FGTSystemZone -name $pester_zone1 -interfaces $pester_port1, $pester_port2, $pester_port3, $pester_port4
    }
    AfterEach {
        Get-FGTSystemZone $pester_zone1 | Remove-FGTSystemZone
    }

    It "Remove zone member $pester_port1 leaving 3 interfaces in the zone" {
        Get-FGTSystemZone -name $pester_zone1 | Remove-FGTSystemZoneMember -interfaces $pester_port1
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface.count | Should -Be 3
        $zone.interface."interface-name" | Should -BeIn $pester_port2, $pester_port3, $pester_port4
    }

    It "Remove zone members $pester_port1,$pester_port2,$pester_port3 leaving only one interface in the zone" {
        Get-FGTSystemZone -name $pester_zone1 | Remove-FGTSystemZoneMember -interfaces $pester_port1, $pester_port2, $pester_port3
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface."interface-name" | Should -Be $pester_port4
        $zone.interface.count | Should -Be 1
    }

    It "Remove all zone members leaving 0 interfaces in it" {
        Get-FGTSystemZone -name $pester_zone1 | Remove-FGTSystemZoneMember -interfaces $pester_port1, $pester_port2, $pester_port3, $pester_port4
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface | Should -Be $NULL
        $zone.interface.count | Should -Be 0
    }
}

Describe "Add zone members" {

    BeforeEach {
        Add-FGTSystemZone -name $pester_zone1 -interfaces $pester_port1, $pester_port2
    }
    AfterEach {
        Get-FGTSystemZone $pester_zone1 | Remove-FGTSystemZone
    }

    It "Add one zone member $pester_port3" {
        Get-FGTSystemZone -name $pester_zone1 | Add-FGTSystemZoneMember -interfaces $pester_port3
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface.count | Should -Be 3
        $zone.interface."interface-name" | Should -BeIn $pester_port1, $pester_port2, $pester_port3
    }

    It "Add multiple zone member $pester_port3,$pester_port4" {
        Get-FGTSystemZone -name $pester_zone1 | Add-FGTSystemZoneMember -interfaces $pester_port3, $pester_port4
        $zone = Get-FGTSystemZone -name $pester_zone1
        $zone.interface.count | Should -Be 4
        $zone.interface."interface-name" | Should -BeIn $pester_port1, $pester_port2, $pester_port3, $pester_port4
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}