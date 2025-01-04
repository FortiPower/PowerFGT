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

Describe "Get Router BGP" {


    It "Get Router BGP Does not throw an error" {
        {
            Get-FGTRouterBGP
        } | Should -Not -Throw
    }

    It "Get ALL Router BGP" {
        $rb = Get-FGTRouterBGP
        @($rb).count | Should -Not -Be $NULL
    }

    It "Get ALL Router BGP with -skip" {
        $rb = Get-FGTRouterBGP -skip
        @($rb).count | Should -Not -Be $NULL
    }

}

Describe "Set Router BGP" {

    BeforeAll {
        $script:bgp = Get-FGTRouterBGP
    }

    It "Change AS" {
        Set-FGTRouterBGP -as 65001
        $rb = Get-FGTRouterBGP
        $rb.as | Should -Be "65001"
    }

    It "Change router-id" {
        Set-FGTRouterBGP -router_id "192.0.2.1"
        $rb = Get-FGTRouterBGP
        $rb.'router-id' | Should -Be "192.0.2.1"
    }

    It "Change BGP via data (one field)" {
        $data = @{ "keepalive-timer" = 30 }
        Set-FGTRouterBGP -data $data
        $rb = Get-FGTRouterBGP
        $rb.'keepalive-timer' | Should -Be "30"
    }

    It "Change BGP via data (two fields)" {
        $data = @{ "holdtime-timer" = 120 ; "ebgp-multipath" = "enable" }
        Set-FGTRouterBGP -data $data
        $rb = Get-FGTRouterBGP
        $rb.'holdtime-timer' | Should -Be "120"
        $rb.'ebgp-multipath' | Should -Be "enable"
    }

    AfterAll {
        #convert Ps(Custom)Object to Hashtable
        $hashtable = @{}
        foreach ( $property in $bgp.psobject.properties.name ) {
            if ($property -eq "router-id" -or $property -eq "as") {
                continue
            }
            $hashtable[$property] = $bgp.$property
        }
        Set-FGTRouterBGP -router_id 0.0.0.0 -as 0 -data $hashtable
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}