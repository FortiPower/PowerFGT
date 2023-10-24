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

Describe "Get Firewall Proxy Policy" {

    BeforeAll {
        $policy = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
        $script:uuid = $policy.uuid
        $script:policyid = $policy.policyid
        Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port2 -dstintf port1 -srcaddr all -dstaddr all
    }

    It "Get Policy Does not throw an error" {
        {
            Get-FGTFirewallProxyPolicy
        } | Should -Not -Throw
    }

    It "Get ALL Policy" {
        $policy = Get-FGTFirewallProxyPolicy
        $policy.count | Should -Not -Be $NULL
    }

    It "Get ALL Policy with -skip" {
        $policy = Get-FGTFirewallProxyPolicy -skip
        $policy.count | Should -Not -Be $NULL
    }

    It "Get Policy ($script:uuid)" {
        $policy = Get-FGTFirewallProxyPolicy -uuid $script:uuid
        $policy.uuid | Should -Be $script:uuid
    }

    It "Get Policy ($script:uuid) and confirm (via Confirm-FGTFirewallProxyPolicy)" {
        $policy = Get-FGTFirewallProxyPolicy -uuid $script:uuid
        Confirm-FGTFirewallProxyPolicy ($policy) | Should -Be $true
    }

    It "Get Policy ($script:uuid) with meta" {
        $policy = Get-FGTFirewallProxyPolicy -uuid $script:uuid -meta
        $policy.uuid | Should -Be $script:uuid
        $policy.q_ref | Should -Not -BeNullOrEmpty
        $policy.q_static | Should -Not -BeNullOrEmpty
        $policy.q_no_rename | Should -Not -BeNullOrEmpty
        $policy.q_global_entry | Should -Not -BeNullOrEmpty
        $policy.q_type | Should -BeIn @('413', '450', '459', '475', '478')
        $policy.q_path | Should -Be "firewall"
        $policy.q_name | Should -Be "proxy-policy"
        $policy.q_mkey_type | Should -Be "integer"
        $policy.q_no_edit | Should -Not -BeNullOrEmpty
        #$policy.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search Policy by uuid ($script:uuid)" {
            $policy = Get-FGTFirewallProxyPolicy -uuid $script:uuid
            @($policy).count | Should -be 1
            $policy.uuid | Should -Be $script:uuid
        }

        It "Search Policy by policyid ($script:policyid)" {
            $policy = Get-FGTFirewallProxyPolicy -policyid $script:policyid
            @($policy).count | Should -be 1
            $policy.policyid | Should -Be $script:policyid
        }

    }

    AfterAll {
        #Remove ALL Proxy Policy (no easy way to filter.... there is no name !)
        Get-FGTFirewallProxyPolicy | Remove-FGTFirewallProxyPolicy -confirm:$false
    }

}

Describe "Add Firewall Proxy Policy" {

    AfterEach {
        #Remove ALL Proxy Policy (no easy way to filter.... there is no name !)
        Get-FGTFirewallProxyPolicy | Remove-FGTFirewallProxyPolicy -confirm:$false
    }

    Context "Transparent-web" {

        It "Add Proxy Policy (port1/port2 : All/All)" {
            $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "transparent-web"
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        Context "Multi Source / destination Interface" {

            It "Add Proxy Policy (src intf: port1, port3 and dst intf: port2)" {
                $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1, port3 -dstintf port2 -srcaddr all -dstaddr all
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "transparent-web"
                ($policy.srcintf.name).count | Should -be "2"
                $policy.srcintf.name | Should -BeIn "port1", "port3"
                $policy.dstintf.name | Should -Be "port2"
                $policy.srcaddr.name | Should -Be "all"
                $policy.dstaddr.name | Should -Be "all"
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src intf: port1 and dst intf: port2, port4)" {
                $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2, port4 -srcaddr all -dstaddr all
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "transparent-web"
                $policy.srcintf.name | Should -Be "port1"
                ($policy.dstintf.name).count | Should -be "2"
                $policy.dstintf.name | Should -BeIn "port2", "port4"
                $policy.srcaddr.name | Should -Be "all"
                $policy.dstaddr.name | Should -Be "all"
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src intf: port1, port3 and dst intf: port2, port4)" {
                $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1, port3 -dstintf port2, port4 -srcaddr all -dstaddr all
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "transparent-web"
                ($policy.srcintf.name).count | Should -be "2"
                $policy.srcintf.name | Should -BeIn "port1", "port3"
                ($policy.dstintf.name).count | Should -be "2"
                $policy.dstintf.name | Should -BeIn "port2", "port4"
                $policy.srcaddr.name | Should -Be "all"
                $policy.dstaddr.name | Should -Be "all"
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

        }

        Context "Multi Source / destination address" {

            BeforeAll {
                Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
                Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
                Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
                Add-FGTFirewallAddress -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
            }

            It "Add Proxy Policy (src addr: $pester_address1 and dst addr: all)" {
                $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr $pester_address1 -dstaddr all
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "transparent-web"
                $policy.srcintf.name | Should -BeIn "port1"
                $policy.dstintf.name | Should -Be "port2"
                $policy.srcaddr.name | Should -Be $pester_address1
                $policy.dstaddr.name | Should -Be "all"
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src addr: $pester_address1, $pester_address3 and dst addr: all)" {
                $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr $pester_address1, $pester_address3 -dstaddr all
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "transparent-web"
                $policy.srcintf.name | Should -BeIn "port1"
                $policy.dstintf.name | Should -Be "port2"
                ($policy.srcaddr.name).count | Should -Be "2"
                $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
                $policy.dstaddr.name | Should -Be "all"
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src addr: all and dst addr: $pester_address2)" {
                $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr $pester_address2
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "transparent-web"
                $policy.srcintf.name | Should -BeIn "port1"
                $policy.dstintf.name | Should -Be "port2"
                $policy.srcaddr.name | Should -Be "all"
                $policy.dstaddr.name | Should -Be $pester_address2
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src addr: all and dst addr: $pester_address2, $pester_address4)" {
                $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr $pester_address2, $pester_address4
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "transparent-web"
                $policy.srcintf.name | Should -BeIn "port1"
                $policy.dstintf.name | Should -Be "port2"
                $policy.srcaddr.name | Should -Be "all"
                ($policy.dstaddr.name).count | Should -Be "2"
                $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src addr: $pester_address1, $pester_address3 and dst addr: $pester_address2, $pester_address4)" {
                $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr $pester_address1, $pester_address3 -dstaddr $pester_address2, $pester_address4
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "transparent-web"
                $policy.srcintf.name | Should -BeIn "port1"
                $policy.dstintf.name | Should -Be "port2"
                ($policy.srcaddr.name).count | Should -Be "2"
                $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
                ($policy.dstaddr.name).count | Should -Be "2"
                $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            AfterAll {
                Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
                Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
                Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
                Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
            }

        }

        It "Add Proxy Policy (with action deny)" {
            $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action deny
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "transparent-web"
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "deny"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "disable"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (with action deny with log)" {
            $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -action deny -log all
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "deny"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "all"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (status disable)" {
            $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -status:$false
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "transparent-web"
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "disable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        #Disabled: Only service webproxy actually and no yet cmdlet for Add/Remove Proxy Service
        It "Add Proxy Policy (with 1 service : HTTP)" -skip:$true {
            Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service HTTP
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "transparent-web"
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "HTTP"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        #Disabled: Only service webproxy actually and no yet cmdlet for Add/Remove Proxy Service
        It "Add Proxy Policy (with 2 services : HTTP, HTTPS)" -skip:$true {
            $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -service HTTP, HTTPS
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "transparent-web"
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -BeIn "HTTP", "HTTPS"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (with logtraffic all)" {
            $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -logtraffic all
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "transparent-web"
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "all"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (with logtraffic disable)" {
            $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -logtraffic disable
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "transparent-web"
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "disable"
            $policy.comments | Should -BeNullOrEmpty
        }

        #Add Schedule ? need API
        It "Add Proxy Policy (with schedule none)" {
            $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -schedule none
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "none"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (with comments)" {
            $return = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -comments "Add via PowerFGT"
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "transparent-web"
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -Be "Add via PowerFGT"
        }

        It "Add Proxy Policy (with policyid)" {
            Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all -policyid 23
            $policy = Get-FGTFirewallProxyPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be "23"
            $policy.proxy | Should -Be "transparent-web"
            $policy.srcintf.name | Should -Be "port1"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

    }

    Context "explicit-web" {

        BeforeAll {
            #Enable Proxy inspection mode (< 6.2.0)
            if ($fgt_version -lt "6.2.0") {
                Set-FGTSystemSettings -inspection_mode proxy
            }
            #Enable Explicit Proxy
            Invoke-FGTRestMethod api/v2/cmdb/web-proxy/explicit -method PUT -body @{ 'status' = 'enable' }
        }

        It "Add Proxy Policy (port1/port2 : All/All)" {
            $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        Context "Source / Multi destination Interface" {

            It "Add Proxy Policy (src intf: port1 and dst intf: port2, port4)" {
                $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2, port4 -srcaddr all -dstaddr all
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "explicit-web"
                ($policy.dstintf.name).count | Should -be "2"
                $policy.dstintf.name | Should -BeIn "port2", "port4"
                $policy.srcaddr.name | Should -Be "all"
                $policy.dstaddr.name | Should -Be "all"
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

        }

        Context "Multi Source / destination address" {

            BeforeAll {
                Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.1 -mask 255.255.255.255
                Add-FGTFirewallAddress -Name $pester_address2 -ip 192.0.2.2 -mask 255.255.255.255
                Add-FGTFirewallAddress -Name $pester_address3 -ip 192.0.2.3 -mask 255.255.255.255
                Add-FGTFirewallAddress -Name $pester_address4 -ip 192.0.2.4 -mask 255.255.255.255
            }

            It "Add Proxy Policy (src addr: $pester_address1 and dst addr: all)" {
                $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr $pester_address1 -dstaddr all
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "explicit-web"
                $policy.dstintf.name | Should -Be "port2"
                $policy.srcaddr.name | Should -Be $pester_address1
                $policy.dstaddr.name | Should -Be "all"
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src addr: $pester_address1, $pester_address3 and dst addr: all)" {
                $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr $pester_address1, $pester_address3 -dstaddr all
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "explicit-web"
                $policy.dstintf.name | Should -Be "port2"
                ($policy.srcaddr.name).count | Should -Be "2"
                $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
                $policy.dstaddr.name | Should -Be "all"
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src addr: all and dst addr: $pester_address2)" {
                $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr $pester_address2
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "explicit-web"
                $policy.dstintf.name | Should -Be "port2"
                $policy.srcaddr.name | Should -Be "all"
                $policy.dstaddr.name | Should -Be $pester_address2
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src addr: all and dst addr: $pester_address2, $pester_address4)" {
                $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr $pester_address2, $pester_address4
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "explicit-web"
                $policy.dstintf.name | Should -Be "port2"
                $policy.srcaddr.name | Should -Be "all"
                ($policy.dstaddr.name).count | Should -Be "2"
                $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            It "Add Proxy Policy (src addr: $pester_address1, $pester_address3 and dst addr: $pester_address2, $pester_address4)" {
                $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr $pester_address1, $pester_address3 -dstaddr $pester_address2, $pester_address4
                $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
                $policy.uuid | Should -Not -BeNullOrEmpty
                $policy.policyid | Should -Be $return.policyid
                $policy.proxy | Should -Be "explicit-web"
                $policy.dstintf.name | Should -Be "port2"
                ($policy.srcaddr.name).count | Should -Be "2"
                $policy.srcaddr.name | Should -BeIn $pester_address1, $pester_address3
                ($policy.dstaddr.name).count | Should -Be "2"
                $policy.dstaddr.name | Should -BeIn $pester_address2, $pester_address4
                $policy.action | Should -Be "accept"
                $policy.status | Should -Be "enable"
                $policy.service.name | Should -Be "webproxy"
                $policy.schedule | Should -Be "always"
                $policy.logtraffic | Should -Be "utm"
                $policy.comments | Should -BeNullOrEmpty
            }

            AfterAll {
                Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
                Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
                Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
                Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
            }

        }

        It "Add Proxy Policy (with action deny)" {
            $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -action deny
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "deny"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "disable"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (with action deny with log)" {
            $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -action deny -log all
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "deny"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "all"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (status disable)" {
            $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -status:$false
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "disable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        #Disabled: Only service webproxy actually and no yet cmdlet for Add/Remove Proxy Service
        It "Add Proxy Policy (with 1 service : HTTP)" -skip:$true {
            Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -service HTTP
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "HTTP"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        #Disabled: Only service webproxy actually and no yet cmdlet for Add/Remove Proxy Service
        It "Add Proxy Policy (with 2 services : HTTP, HTTPS)" -skip:$true {
            $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -service HTTP, HTTPS
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -BeIn "HTTP", "HTTPS"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (with logtraffic all)" {
            $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -logtraffic all
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "all"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (with logtraffic disable)" {
            $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -logtraffic disable
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "disable"
            $policy.comments | Should -BeNullOrEmpty
        }

        #Add Schedule ? need API
        It "Add Proxy Policy (with schedule none)" {
            $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -schedule none
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "none"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        It "Add Proxy Policy (with comments)" {
            $return = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -comments "Add via PowerFGT"
            $policy = Get-FGTFirewallProxyPolicy -policyid $return.policyid
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be $return.policyid
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -Be "Add via PowerFGT"
        }

        It "Add Proxy Policy (with policyid)" {
            Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all -policyid 23
            $policy = Get-FGTFirewallProxyPolicy -policyid 23
            $policy.uuid | Should -Not -BeNullOrEmpty
            $policy.policyid | Should -Be "23"
            $policy.proxy | Should -Be "explicit-web"
            $policy.dstintf.name | Should -Be "port2"
            $policy.srcaddr.name | Should -Be "all"
            $policy.dstaddr.name | Should -Be "all"
            $policy.action | Should -Be "accept"
            $policy.status | Should -Be "enable"
            $policy.service.name | Should -Be "webproxy"
            $policy.schedule | Should -Be "always"
            $policy.logtraffic | Should -Be "utm"
            $policy.comments | Should -BeNullOrEmpty
        }

        AfterAll {
            #Disable Explicit Proxy
            Invoke-FGTRestMethod api/v2/cmdb/web-proxy/explicit -method PUT -body @{ 'status' = 'disable' }
            #Disable Proxy inspection mode (< 6.2.0)
            if ($fgt_version -lt "6.2.0") {
                Set-FGTSystemSettings -inspection_mode flow
            }
        }

    }

}

Describe "Remove Firewall Proxy Policy" {

    Context "Transparent-web" {

        BeforeEach {
            $policy = Add-FGTFirewallProxyPolicy -proxy transparent-web -srcintf port1 -dstintf port2 -srcaddr all -dstaddr all
            $script:policyid = $policy.policyid
        }

        It "Remove Proxy Policy ($script:policyid) by pipeline" {
            $policy = Get-FGTFirewallProxyPolicy -policyid $script:policyid
            $policy | Remove-FGTFirewallProxyPolicy -confirm:$false
            $policy = Get-FGTFirewallProxyPolicy -policyid $script:policyid
            $policy | Should -Be $NULL
        }

    }

    Context "explicit-web" {

        BeforeAll {
            #Enable Proxy inspection mode (< 6.2.0)
            if ($fgt_version -lt "6.2.0") {
                Set-FGTSystemSettings -inspection_mode proxy
            }
            #Enable Explicit Proxy
            Invoke-FGTRestMethod api/v2/cmdb/web-proxy/explicit -method PUT -body @{ 'status' = 'enable' }
        }

        BeforeEach {
            $policy = Add-FGTFirewallProxyPolicy -proxy explicit-web -dstintf port2 -srcaddr all -dstaddr all
            $script:policyid = $policy.policyid
        }

        It "Remove Proxy Policy ($script:policyid) by pipeline" {
            $policy = Get-FGTFirewallProxyPolicy -policyid $script:policyid
            $policy | Remove-FGTFirewallProxyPolicy -confirm:$false
            $policy = Get-FGTFirewallProxyPolicy -policyid $script:policyid
            $policy | Should -Be $NULL
        }

        AfterAll {
            #Disable Explicit Proxy
            Invoke-FGTRestMethod api/v2/cmdb/web-proxy/explicit -method PUT -body @{ 'status' = 'disable' }
            #Disable Proxy inspection mode (< 6.2.0)
            if ($fgt_version -lt "6.2.0") {
                Set-FGTSystemSettings -inspection_mode flow
            }
        }

    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}