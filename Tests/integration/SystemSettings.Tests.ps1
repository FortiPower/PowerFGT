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

Describe "Get System Settings" {

    It "Get Settings does not throw" {
        {
            Get-FGTSystemSettings
        } | Should -Not -Throw
    }

    It "Get ALL Settings with -skip" {
        $ss = Get-FGTSystemSettings -skip
        @($ss).count | Should -Not -Be $NULL
    }
}

Describe "Set System Settings" {

    BeforeAll {
        $script:settings = Get-FGTSystemSettings
    }

    It "Change gui-allow-unnamed-policy to enable" {
        Set-FGTSystemSettings -gui_allow_unnamed_policy
        $ss = Get-FGTSystemSettings
        $ss.'gui-allow-unnamed-policy' | Should -Be "enable"
    }

    It "Change gui-allow-unnamed-policy to disable" {
        Set-FGTSystemSettings -gui_allow_unnamed_policy:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-allow-unnamed-policy' | Should -Be "disable"
    }

    It "Change gui-dns-database to enable" {
        Set-FGTSystemSettings -gui_dns_database
        $ss = Get-FGTSystemSettings
        $ss.'gui-dns-database' | Should -Be "enable"
    }

    It "Change gui-dns-database to disable" {
        Set-FGTSystemSettings -gui_dns_database:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-dns-database' | Should -Be "disable"
    }

    It "Change gui-explicit-proxy to enable" {
        Set-FGTSystemSettings -gui_explicit_proxy
        $ss = Get-FGTSystemSettings
        $ss.'gui-explicit-proxy' | Should -Be "enable"
    }

    It "Change gui-explicit-proxy to disable" {
        Set-FGTSystemSettings -gui_explicit_proxy:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-explicit-proxy' | Should -Be "disable"
    }

    It "Change gui-sslvpn-personal-bookmarks to enable" {
        Set-FGTSystemSettings -gui_sslvpn_personal_bookmarks
        $ss = Get-FGTSystemSettings
        $ss.'gui-sslvpn-personal-bookmarks' | Should -Be "enable"
    }

    It "Change gui-sslvpn-personal-bookmarks to disable" {
        Set-FGTSystemSettings -gui_sslvpn_personal_bookmarks:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-sslvpn-personal-bookmarks' | Should -Be "disable"
    }

    It "Change gui-ztna to enable" {
        Set-FGTSystemSettings -gui_ztna
        $ss = Get-FGTSystemSettings
        $ss.'gui-ztna' | Should -Be "enable"
    }

    It "Change gui-ztna to disable" {
        Set-FGTSystemSettings -gui_ztna:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-ztna' | Should -Be "disable"
    }

    It "Change lldp-transmission/reception to enable" {
        Set-FGTSystemSettings -lldp_transmission enable -lldp_reception enable
        $ss = Get-FGTSystemSettings
        $ss.'lldp-transmission' | Should -Be "enable"
        $ss.'lldp-reception' | Should -Be "enable"
    }

    It "Change lldp-transmission/reception to disable" {
        Set-FGTSystemSettings -lldp_transmission disable -lldp_reception disable
        $ss = Get-FGTSystemSettings
        $ss.'lldp-transmission' | Should -Be "disable"
        $ss.'lldp-reception' | Should -Be "disable"
    }

    It "Change lldp-transmission/reception to global" {
        Set-FGTSystemSettings -lldp_transmission global -lldp_reception global
        $ss = Get-FGTSystemSettings
        $ss.'lldp-transmission' | Should -Be "global"
        $ss.'lldp-reception' | Should -Be "global"
    }

    It "Change settings via data (one field)" {
        $data = @{ "ike-port" = 1500 }
        Set-FGTSystemSettings -data $data
        $ss = Get-FGTSystemSettings
        $ss.'ike-port' | Should -Be "1500"
    }

    It "Change settings via data (two fields)" {
        $data = @{ "ike-port" = 1501 ; "ike-policy-route" = "enable" }
        Set-FGTSystemSettings -data $data
        $ss = Get-FGTSystemSettings
        $ss.'ike-port' | Should -Be "1501"
        $ss.'ike-policy-route' | Should -Be "enable"
    }

    AfterAll {
        #convert Ps(Custom)Object to Hashtable
        $hashtable = @{}
        foreach ( $property in $settings.psobject.properties.name ) {
            $hashtable[$property] = $settings.$property
        }
        set-FGTSystemSettings -data $hashtable
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}