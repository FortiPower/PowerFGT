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

Describe "Get Router OSPF" {


    It "Get Router OSPF Does not throw an error" {
        {
            Get-FGTRouterOSPF
        } | Should -Not -Throw
    }

    It "Get ALL Router OSPF" {
        $ro = Get-FGTRouterOSPF
        @($ro).count | Should -Not -Be $NULL
    }

    It "Get ALL Router OSPF with -skip" {
        $ro = Get-FGTRouterOSPF -skip
        @($ro).count | Should -Not -Be $NULL
    }

}

Describe "Set Router OSPF" {

    BeforeAll {
        $script:ospf = Get-FGTRouterOSPF
    }

    It "Change router-id" {
        Set-FGTRouterOSPF -router_id "192.0.2.1"
        $ro = Get-FGTRouterOSPF
        $ro.'router-id' | Should -Be "192.0.2.1"
    }

    It "Change OSPF via data (one field)" {
        $data = @{ "distance" = 120 }
        Set-FGTRouterOSPF -data $data
        $ro = Get-FGTRouterOSPF
        $ro.distance | Should -Be "120"
    }

    It "Change OSPF via data (two fields)" {
        $data = @{ "default-metric" = 15 ; "default-information-originate" = "enable" }
        Set-FGTRouterOSPF -data $data
        $ro = Get-FGTRouterOSPF
        $ro.'default-metric' | Should -Be "15"
        $ro.'default-information-originate' | Should -Be "enable"
    }

    AfterAll {
        #convert Ps(Custom)Object to Hashtable
        $hashtable = @{}
        foreach ( $property in $ospf.psobject.properties.name ) {
            $hashtable[$property] = $ospf.$property
        }
        Set-FGTRouterOSPF -data $hashtable
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}