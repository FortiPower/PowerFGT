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

    Context "Search" {

        It "Search a setting by name (gui-allow-unnamed-policy)" {
            $ss = Get-FGTSystemSettings -name "gui-allow-unnamed-policy"
            $ss.'gui-allow-unnamed-policy' | Should -Be -Not $NULL
            $ss.'gui-dns-database' | Should -Be $NULL
        }

        It "Search 2 settings by name (gui-allow-unnamed-policy, gui-explicit-proxy)" {
            $ss = Get-FGTSystemSettings -name "gui-allow-unnamed-policy", "gui-explicit-proxy"
            $ss.'gui-allow-unnamed-policy' | Should -Be -Not $NULL
            $ss.'gui-dns-database' | Should -Be $NULL
            $ss.'gui-explicit-proxy' | Should -Be -Not $NULL
        }

        It "Search 1 setting by name (gui_allow_unnamed_policy)" {
            $ss = Get-FGTSystemSettings -name "gui_allow_unnamed_policy"
            $ss.'gui-allow-unnamed-policy' | Should -Be -Not $NULL
            $ss.'gui-dns-database' | Should -Be $NULL
        }
    }
}

Describe "Set System Settings" {

    BeforeAll {
        $script:settings = Get-FGTSystemSettings
        #for FortiOS 7.4.x, you need to enable global setting sslvpn Web Mode
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            Set-FGTSystemGlobal -sslvpn_web_mode
        }
    }

    #Coming with FortiOS 7.2.x and need for some feature (like waf, ztna.. ) and remove with 7.6.0...
    It "Change gui-proxy-inspection to enable" -skip:($fgt_version -lt "7.2.0" -or $fgt_version -ge "7.6.0") {
        Set-FGTSystemSettings -gui_proxy_inspection
        $ss = Get-FGTSystemSettings
        $ss.'gui-proxy-inspection' | Should -Be "enable"
    }

    #Coming with FortiOS 7.4.x and need for enable VPN SSL (like waf, ztna.. )
    It "Change gui-sslvpn to enable" -skip:($fgt_version -lt "7.4.0") {
        Set-FGTSystemSettings -gui_sslvpn
        $ss = Get-FGTSystemSettings
        $ss.'gui-sslvpn' | Should -Be "enable"
    }

    It "Change allow-subnet-overlap to enable" {
        Set-FGTSystemSettings -allow_subnet_overlap
        $ss = Get-FGTSystemSettings
        $ss.'allow-subnet-overlap' | Should -Be "enable"
    }

    It "Change allow-subnet-overlap to disable" {
        Set-FGTSystemSettings -allow_subnet_overlap:$false
        $ss = Get-FGTSystemSettings
        $ss.'allow-subnet-overlap' | Should -Be "disable"
    }

    It "Change central-nat to enable" {
        Set-FGTSystemSettings -central_nat
        $ss = Get-FGTSystemSettings
        $ss.'central-nat' | Should -Be "enable"
    }

    It "Change central-nat to disable" {
        Set-FGTSystemSettings -central_nat:$false
        $ss = Get-FGTSystemSettings
        $ss.'central-nat' | Should -Be "disable"
    }

    It "Change inspection-mode to proxy" -skip:($fgt_version -ge "6.2.0") {
        Set-FGTSystemSettings -inspection_mode proxy
        $ss = Get-FGTSystemSettings
        $ss.'inspection-mode' | Should -Be "proxy"
    }

    It "Change inspection-mode to flow" -skip:($fgt_version -ge "6.2.0") {
        Set-FGTSystemSettings -inspection_mode flow
        $ss = Get-FGTSystemSettings
        $ss.'inspection-mode' | Should -Be "flow"
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

    It "Change gui-dynamic-routing to enable" {
        Set-FGTSystemSettings -gui_dynamic_routing
        $ss = Get-FGTSystemSettings
        $ss.'gui-dynamic-routing' | Should -Be "enable"
    }

    It "Change gui-dynamic-routing to disable" {
        Set-FGTSystemSettings -gui_dynamic_routing:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-dynamic-routing' | Should -Be "disable"
    }

    It "Change gui-explicit-proxy to enable" {
        #for FortiOS 6.0.x, you need to enable proxy inspection mode for use Explicit Proxy
        if ($DefaultFGTConnection.version -lt "6.2.0") {
            Set-FGTSystemSettings -inspection_mode proxy
        }
        Set-FGTSystemSettings -gui_explicit_proxy
        $ss = Get-FGTSystemSettings
        $ss.'gui-explicit-proxy' | Should -Be "enable"
    }

    It "Change gui-explicit-proxy to disable" {
        Set-FGTSystemSettings -gui_explicit_proxy:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-explicit-proxy' | Should -Be "disable"
        #reenable inspection mode flow
        if ($DefaultFGTConnection.version -lt "6.2.0") {
            Set-FGTSystemSettings -inspection_mode flow
        }
    }

    It "Change gui-ips to enable" {
        Set-FGTSystemSettings -gui_ips
        $ss = Get-FGTSystemSettings
        $ss.'gui-ips' | Should -Be "enable"
    }

    It "Change gui-ips to disable" {
        Set-FGTSystemSettings -gui_ips:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-ips' | Should -Be "disable"
    }

    It "Change gui-load-balance to enable" {
        Set-FGTSystemSettings -gui_load_balance
        $ss = Get-FGTSystemSettings
        $ss.'gui-load-balance' | Should -Be "enable"
    }

    It "Change gui-load-balance to disable" {
        Set-FGTSystemSettings -gui_load_balance:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-load-balance' | Should -Be "disable"
    }

    It "Change gui-local-in-policy to enable" {
        Set-FGTSystemSettings -gui_local_in_policy
        $ss = Get-FGTSystemSettings
        $ss.'gui-local-in-policy' | Should -Be "enable"
    }

    It "Change gui-local-in-policy to disable" {
        Set-FGTSystemSettings -gui_local_in_policy:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-local-in-policy' | Should -Be "disable"
    }

    It "Change gui-multiple-interface-policy to enable" {
        Set-FGTSystemSettings -gui_multiple_interface_policy
        $ss = Get-FGTSystemSettings
        $ss.'gui-multiple-interface-policy' | Should -Be "enable"
    }

    It "Change gui-multiple-interface-policy to disable" {
        Set-FGTSystemSettings -gui_multiple_interface_policy:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-multiple-interface-policy' | Should -Be "disable"
    }

    It "Change gui-multiple-utm-profiles to enable" -skip:($fgt_version -ge "6.4.0") {
        Set-FGTSystemSettings -gui_multiple_utm_profiles
        $ss = Get-FGTSystemSettings
        $ss.'gui-multiple-utm-profiles' | Should -Be "enable"
    }

    It "Change gui-multiple-utm-profiles to disable" -skip:($fgt_version -ge "6.4.0") {
        Set-FGTSystemSettings -gui_multiple_utm_profiles:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-multiple-utm-profiles' | Should -Be "disable"
    }

    It "Change gui-spamfilter to enable" {
        #for FortiOS 6.0.x, you need to enable proxy inspection mode for use Spam Filter
        if ($DefaultFGTConnection.version -lt "6.2.0") {
            Set-FGTSystemSettings -inspection_mode proxy
        }
        Set-FGTSystemSettings -gui_spamfilter
        $ss = Get-FGTSystemSettings
        $ss.'gui-spamfilter' | Should -Be "enable"
    }

    It "Change gui-spamfilter to disable" {
        Set-FGTSystemSettings -gui_spamfilter:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-spamfilter' | Should -Be "disable"
        #reenable inspection mode flow
        if ($DefaultFGTConnection.version -lt "6.2.0") {
            Set-FGTSystemSettings -inspection_mode flow
        }
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

    It "Change gui-sslvpn-realms to enable" {
        Set-FGTSystemSettings -gui_sslvpn_realms
        $ss = Get-FGTSystemSettings
        $ss.'gui-sslvpn-realms' | Should -Be "enable"
    }

    It "Change gui-sslvpn-realms to disable" {
        Set-FGTSystemSettings -gui_sslvpn_realms:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-sslvpn-realms' | Should -Be "disable"
    }

    It "Change gui-voip-profile to enable" {
        Set-FGTSystemSettings -gui_voip_profile
        $ss = Get-FGTSystemSettings
        $ss.'gui-voip-profile' | Should -Be "enable"
    }

    It "Change gui-voip-profile to disable" {
        Set-FGTSystemSettings -gui_voip_profile:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-voip-profile' | Should -Be "disable"
    }

    It "Change gui-waf-profile to enable" {
        #for FortiOS 6.0.x, you need to enable proxy inspection mode for use WAF Profile
        if ($DefaultFGTConnection.version -lt "6.2.0") {
            Set-FGTSystemSettings -inspection_mode proxy
        }
        Set-FGTSystemSettings -gui_waf_profile
        $ss = Get-FGTSystemSettings
        $ss.'gui-waf-profile' | Should -Be "enable"
    }

    It "Change gui-waf-profile to disable" {
        Set-FGTSystemSettings -gui_waf_profile:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-waf-profile' | Should -Be "disable"
        #reenable inspection mode flow
        if ($DefaultFGTConnection.version -lt "6.2.0") {
            Set-FGTSystemSettings -inspection_mode flow
        }
    }

    It "Change gui-ztna to enable" -skip:($fgt_version -lt "7.0.0") {
        Set-FGTSystemSettings -gui_ztna
        $ss = Get-FGTSystemSettings
        $ss.'gui-ztna' | Should -Be "enable"
    }

    It "Change gui-ztna to disable" -skip:($fgt_version -lt "7.0.0") {
        Set-FGTSystemSettings -gui_ztna:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-ztna' | Should -Be "disable"
    }

    It "Change lldp-transmission to enable" {
        Set-FGTSystemSettings -lldp_transmission enable
        $ss = Get-FGTSystemSettings
        $ss.'lldp-transmission' | Should -Be "enable"
    }

    It "Change lldp-transmission to disable" {
        Set-FGTSystemSettings -lldp_transmission disable
        $ss = Get-FGTSystemSettings
        $ss.'lldp-transmission' | Should -Be "disable"
    }

    It "Change lldp-transmission to global" {
        Set-FGTSystemSettings -lldp_transmission global
        $ss = Get-FGTSystemSettings
        $ss.'lldp-transmission' | Should -Be "global"
    }

    It "Change lldp-reception to enable" -skip:($fgt_version -lt "6.2.0") {
        Set-FGTSystemSettings -lldp_reception enable
        $ss = Get-FGTSystemSettings
        $ss.'lldp-reception' | Should -Be "enable"
    }

    It "Change lldp-reception to disable" -skip:($fgt_version -lt "6.2.0") {
        Set-FGTSystemSettings -lldp_reception disable
        $ss = Get-FGTSystemSettings
        $ss.'lldp-reception' | Should -Be "disable"
    }

    It "Change lldp-reception to global" -skip:($fgt_version -lt "6.2.0") {
        Set-FGTSystemSettings -lldp_reception global
        $ss = Get-FGTSystemSettings
        $ss.'lldp-reception' | Should -Be "global"
    }

    It "Change gui-proxy-inspection to disable" -skip:($fgt_version -lt "7.2.0" -or $fgt_version -ge "7.6.0") {
        Set-FGTSystemSettings -gui_proxy_inspection:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-proxy-inspection' | Should -Be "disable"
    }

    It "Change gui-sslvpn to disable" -skip:($fgt_version -lt "7.4.0") {
        Set-FGTSystemSettings -gui_sslvpn:$false
        $ss = Get-FGTSystemSettings
        $ss.'gui-sslvpn' | Should -Be "disable"
    }

    It "Change settings via data (one field)" {
        $data = @{ "ecmp-max-paths" = 254 }
        Set-FGTSystemSettings -data $data
        $ss = Get-FGTSystemSettings
        $ss.'ecmp-max-paths' | Should -Be "254"
    }

    It "Change settings via data (two fields)" {
        $data = @{ "ecmp-max-paths" = 253 ; "deny-tcp-with-icmp" = "enable" }
        Set-FGTSystemSettings -data $data
        $ss = Get-FGTSystemSettings
        $ss.'ecmp-max-paths' | Should -Be "253"
        $ss.'deny-tcp-with-icmp' | Should -Be "enable"
    }

    AfterAll {
        #convert Ps(Custom)Object to Hashtable
        $hashtable = @{}
        foreach ( $property in $settings.psobject.properties.name ) {
            $hashtable[$property] = $settings.$property
        }
        Set-FGTSystemSettings -data $hashtable

        #Disable SSL VPN Web Mode
        if ($DefaultFGTConnection.version -ge "7.4.0") {
            Set-FGTSystemGlobal -sslvpn_web_mode:$false
        }
    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}