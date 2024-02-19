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
            $ss.'timezone' | Should -Be $NULL
        }

        It "Search 2 System Global by name (language, timezone)" {
            $ss = Get-FGTSystemGlobal -name "language", "timezone"
            $ss.'language' | Should -Be -Not $NULL
            $ss.'gui-dns-database' | Should -Be $NULL
            $ss.'timezone' | Should -Be -Not $NULL
        }

        It "Search 1 System Global by name (language)" {
            $ss = Get-FGTSystemGlobal -name "language"
            $ss.'language' | Should -Be -Not $NULL
            $ss.'timezone' | Should -Be $NULL
        }
    }
}

Describe "Set System Global" {

    BeforeAll {
        $script:settings = Get-FGTSystemGlobal
    }

    It "Change admintimeout to 60" {
        Set-FGTSystemGlobal -admintimeout 60
        $sg = Get-FGTSystemGlobal
        $sg.'admintimeout' | Should -Be "60"
    }

    It "Change admin_port (HTTP)" -Skip:($httpOnly -or $ci) {
        Set-FGTSystemGlobal -admin_port 8080
        $sg = Get-FGTSystemGlobal
        $sg.'admin-port' | Should -Be "8080"
    }

    It "Change admin_sport (HTTPS)" -Skip:($httpOnly -eq $false -or $fgt_version -le "7.0.0" -or $ci) {
        Set-FGTSystemGlobal -admin_sport 8443
        $sg = Get-FGTSystemGlobal
        $sg.'admin-sport' | Should -Be "8443"
    }

    It "Change admin_ssh_port" {
        Set-FGTSystemGlobal -admin_ssh_port 8022
        $sg = Get-FGTSystemGlobal
        $sg.'admin-ssh-port' | Should -Be "8022"
    }

    It "Change alias" {
        Set-FGTSystemGlobal -alias "alias_PowerFGT"
        $sg = Get-FGTSystemGlobal
        $sg.'alias' | Should -Be "alias_PowerFGT"
    }

    It "Change dst to disable" -skip:($fgt_version -ge "7.2.0") {
        Set-FGTSystemGlobal -dst:$false
        $sg = Get-FGTSystemGlobal
        $sg.'dst' | Should -Be "disable"
    }

    It "Change dst to enable" -Skip:($fgt_version -ge "7.2.0") {
        Set-FGTSystemGlobal -dst
        $sg = Get-FGTSystemGlobal
        $sg.'dst' | Should -Be "enable"
    }

    It "Change fortiextender to enable" {
        Set-FGTSystemGlobal -fortiextender
        $sg = Get-FGTSystemGlobal
        $sg.'fortiextender' | Should -Be "enable"
    }

    It "Change fortiextender to disable" {
        Set-FGTSystemGlobal -fortiextender:$false
        $sg = Get-FGTSystemGlobal
        $sg.'fortiextender' | Should -Be "disable"
    }

    It "Change hostname" {
        Set-FGTSystemGlobal -hostname "hostname_PowerFGT"
        $sg = Get-FGTSystemGlobal
        $sg.'hostname' | Should -Be "hostname_PowerFGT"
    }

    It "Change gui-certificates to disable" {
        Set-FGTSystemGlobal -gui_certificates:$false
        $sg = Get-FGTSystemGlobal
        $sg.'gui-certificates' | Should -Be "disable"
    }

    It "Change gui-certificates to enable" {
        Set-FGTSystemGlobal -gui_certificates
        $sg = Get-FGTSystemGlobal
        $sg.'gui-certificates' | Should -Be "enable"
    }

    It "Change gui-wireless-opensecurity to disable" {
        Set-FGTSystemGlobal -gui_wireless_opensecurity:$false
        $sg = Get-FGTSystemGlobal
        $sg.'gui-wireless-opensecurity' | Should -Be "disable"
    }

    It "Change gui-wireless-opensecurity to enable" {
        Set-FGTSystemGlobal -gui_wireless_opensecurity
        $sg = Get-FGTSystemGlobal
        $sg.'gui-wireless-opensecurity' | Should -Be "enable"
    }

    It "Change lldp-reception to enable" -skip:($fgt_version -lt "6.2.0") {
        Set-FGTSystemGlobal -lldp_reception
        $sg = Get-FGTSystemGlobal
        $sg.'lldp-reception' | Should -Be "enable"
    }

    It "Change lldp-reception to disable" -skip:($fgt_version -lt "6.2.0") {
        Set-FGTSystemGlobal -lldp_reception:$false
        $sg = Get-FGTSystemGlobal
        $sg.'lldp-reception' | Should -Be "disable"
    }

    It "Change lldp-transmission to enable" {
        Set-FGTSystemGlobal -lldp_transmission
        $sg = Get-FGTSystemGlobal
        $sg.'lldp-transmission' | Should -Be "enable"
    }

    It "Change lldp-transmission to disable" {
        Set-FGTSystemGlobal -lldp_transmission:$false
        $sg = Get-FGTSystemGlobal
        $sg.'lldp-transmission' | Should -Be "disable"
    }

    <# Disable need some other change...
    It "Change switch-controller to enable" {
        Set-FGTSystemGlobal -switch_controller
        $sg = Get-FGTSystemGlobal
        $sg.'switch-controller' | Should -Be "enable"
    }

    It "Change switch-controller to disable" {
        Set-FGTSystemGlobal -switch_controller:$false
        $sg = Get-FGTSystemGlobal
        $sg.'switch-controller' | Should -Be "disable"
    }
    #>

    It "Change timezone" {
        Set-FGTSystemGlobal -timezone 28
        $sg = Get-FGTSystemGlobal
        $sg.'timezone' | Should -Be "28"
    }

    <# Disable need some other change...
    It "Change wireless-controller to disable" {
        Set-FGTSystemGlobal -wireless_controller:$false
        $sg = Get-FGTSystemGlobal
        $sg.'wireless-controller' | Should -Be "disable"
    }

    It "Change wireless-controller to enable" {
        Set-FGTSystemGlobal -wireless_controller
        $sg = Get-FGTSystemGlobal
        $sg.'wireless-controller' | Should -Be "enable"
    }
    #>

    It "Change settings via data (one field)" {
        $data = @{ "two-factor-sms-expiry" = 120 }
        Set-FGTSystemGlobal -data $data
        $sg = Get-FGTSystemGlobal
        $sg.'two-factor-sms-expiry' | Should -Be "120"
    }

    It "Change settings via data (two fields)" {
        $data = @{ "two-factor-sms-expiry" = 240 ; "two-factor-email-expiry" = 120 }
        Set-FGTSystemGlobal -data $data
        $sg = Get-FGTSystemGlobal
        $sg.'two-factor-sms-expiry' | Should -Be "240"
        $sg.'two-factor-email-expiry' | Should -Be "120"
    }

    AfterAll {
        #convert Ps(Custom)Object to Hashtable
        $hashtable = @{}
        foreach ( $property in $settings.psobject.properties.name ) {
            $hashtable[$property] = $settings.$property
        }
        Set-FGTSystemGlobal -data $hashtable
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}