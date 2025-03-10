#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

BeforeAll {
    Connect-FGT @invokeParams
}

Describe "Get Firewall Service Custom" {

    BeforeAll {
        Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080
    }

    It "Get Service Custom Does not throw an error" {
        {
            Get-FGTFirewallServiceCustom
        } | Should -Not -Throw
    }

    It "Get ALL Service Custom" {
        $sc = Get-FGTFirewallServiceCustom
        $sc.count | Should -Not -Be $NULL
    }

    It "Get ALL Service Custom with -skip" {
        $sc = Get-FGTFirewallServiceCustom -skip
        $sc.count | Should -Not -Be $NULL
    }

    It "Get Service Custom ($pester_servicecustom1)" {
        $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
        $sc.name | Should -Be $pester_servicecustom1
    }

    It "Get Service Custom ($pester_servicecustom1) and confirm (via Confirm-FGTServiceCustom)" {
        $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
        Confirm-FGTServiceCustom ($sc) | Should -Be $true
    }

    It "Get Service Custom ($pester_servicecustom1) with meta" {
        $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1 -meta
        $sc.name | Should -Be $pester_servicecustom1
        $sc.q_ref | Should -Not -BeNullOrEmpty
        $sc.q_static | Should -Not -BeNullOrEmpty
        $sc.q_no_rename | Should -Not -BeNullOrEmpty
        $sc.q_global_entry | Should -Not -BeNullOrEmpty
        $sc.q_type | Should -Not -BeNullOrEmpty
        $sc.q_path | Should -Be "firewall.service"
        $sc.q_name | Should -Be "custom"
        $sc.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $sc.q_no_edit | Should -Not -BeNullOrEmpty
        }
        $sc.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search Service Custom by name ($pester_servicecustom1)" {
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            @($sc).count | Should -be 1
            $sc.name | Should -Be $pester_servicecustom1
        }
    }

    AfterAll {
        Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Remove-FGTFirewallServiceCustom -confirm:$false
    }

}

Describe "Add Firewall Service Custom" {

    Context "Common" {

        AfterEach {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Remove-FGTFirewallServiceCustom -confirm:$false
        }

        It "Add Service Custom $pester_servicecustom1 with comment" {
            Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080 -comment "My Comment"
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Not -BeNullOrEmpty
            $sc.comment | Should -Be "My Comment"
            $sc.'session-ttl' | Should -Be "0"
            $sc.color | Should -Be "0"
        }

        It "Add Service Custom $pester_servicecustom1 with category (Email)" {
            Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080 -category Email
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Not -BeNullOrEmpty
            $sc.comment | Should -BeNullOrEmpty
            $sc.'session-ttl' | Should -Be "0"
            $sc.color | Should -Be "0"
            $sc.category | Should -Be "Email"
        }

        It "Add Service Custom $pester_servicecustom1 with data (1 field)" {
            $data = @{ "color" = 12 }
            Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080 -data $data
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Not -BeNullOrEmpty
            $sc.comment | Should -BeNullOrEmpty
            $sc.'session-ttl' | Should -Be "0"
            $sc.color | Should -Be "12"
        }

        It "Add Service Custom $pester_servicecustom1 with data (2 fields)" {
            $data = @{ "color" = 23 ; "session-ttl" = 3600 }
            Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080 -data $data
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Not -BeNullOrEmpty
            $sc.comment | Should -BeNullOrEmpty
            $sc.'session-ttl' | Should -Be "3600"
            $sc.color | Should -Be "23"
        }

    }

    Context "Protocol : TCP/UDP/SCTP" {

        AfterEach {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Remove-FGTFirewallServiceCustom -confirm:$false
        }

        Context "TCP" {

            It "Add Service Custom $pester_servicecustom1 with tcp-port" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080"
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Add Service Custom $pester_servicecustom1 with tcp-port range" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port "8080-8090"
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080-8090"
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Add Service Custom $pester_servicecustom1 with multiple tcp-port" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080, 8090
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080 8090"
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Add Service Custom $pester_servicecustom1 with multiple tcp-port range" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port "8080-8090", 10000
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080-8090 10000"
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

        }

        Context "UDP" {

            It "Add Service Custom $pester_servicecustom1 with udp-port" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -udp_port 8080
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -Be "8080"
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Add Service Custom $pester_servicecustom1 with udp-port range" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -udp_port "8080-8090"
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -Be "8080-8090"
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Add Service Custom $pester_servicecustom1 with multiple udp-port" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -udp_port 8080, 8090
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -Be "8080 8090"
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Add Service Custom $pester_servicecustom1 with multiple udp-port range" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -udp_port "8080-8090", 10000
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -Be "8080-8090 10000"
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

        }

        Context "SCTP" {

            It "Add Service Custom $pester_servicecustom1 with sctp-port" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -sctp_port 8080
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -Be "8080"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Add Service Custom $pester_servicecustom1 with sctp-port range" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -sctp_port "8080-8090"
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -Be "8080-8090"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Add Service Custom $pester_servicecustom1 with multiple sctp-port" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -sctp_port 8080, 8090
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -Be "8080 8090"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Add Service Custom $pester_servicecustom1 with multiple sctp-port range" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -sctp_port "8080-8090", 10000
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -Be "8080-8090 10000"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

        }

        Context "Multiple Protocol" {

            It "Add Service Custom $pester_servicecustom1 with tcp/udp/sctp port range" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080 -udp_port 8081 -sctp_port 8082
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080"
                $sc."udp-portrange" | Should -Be "8081"
                $sc."sctp-portrange" | Should -Be "8082"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }


            It "Add Service Custom $pester_servicecustom1 with multiple tcp/udp/sctp port range" {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080, 9080 -udp_port 8081, 9081 -sctp_port 8082, 9082
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080 9080"
                $sc."udp-portrange" | Should -Be "8081 9081"
                $sc."sctp-portrange" | Should -Be "8082 9082"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }
        }
    }

    Context "Protocol: IP" {

        AfterEach {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Remove-FGTFirewallServiceCustom -confirm:$false
        }

        It "Add Service Custom $pester_servicecustom1 with IP Protocol (44)" {
            Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -protocolNumber 44
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Be "IP"
            $sc."tcp-portrange" | Should -BeNullOrEmpty
            $sc."udp-portrange" | Should -BeNullOrEmpty
            $sc."sctp-portrange" | Should -BeNullOrEmpty
            $sc."protocol-number" | Should -Be "44"
            $sc.comment | Should -BeNullOrEmpty
            $sc.'session-ttl' | Should -Be "0"
            $sc.color | Should -Be "0"
        }
    }

    Context "Protocol: ICMP" -skip:($fgt_version -lt "6.4.0") {

        AfterEach {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Remove-FGTFirewallServiceCustom -confirm:$false
        }

        It "Add Service Custom $pester_servicecustom1 with ICMP Type (0) and code (8)" {
            Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -icmptype 0 -icmpcode 8
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Be "ICMP"
            $sc."tcp-portrange" | Should -BeNullOrEmpty
            $sc."udp-portrange" | Should -BeNullOrEmpty
            $sc."sctp-portrange" | Should -BeNullOrEmpty
            $sc."protocol-number" | Should -BeNullOrEmpty
            $sc.icmptype | Should -Be "0"
            $sc.icmpcode | Should -Be "8"
            $sc.comment | Should -BeNullOrEmpty
            $sc.'session-ttl' | Should -Be "0"
            $sc.color | Should -Be "0"

        }

    }

}

Describe "Configure Firewall Service Custom" {

    Context "Common" {

        BeforeAll {
            Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080
        }

        It "Change Service Custom Comment" {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -comment "My new Comment"
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            if ($DefaultFGTConnection.version -ge "7.6.0") {
                $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
            }
            else {
                $sc.protocol | Should -Be "TCP/UDP/SCTP"
            }
            $sc."tcp-portrange" | Should -Not -BeNullOrEmpty
            $sc."udp-portrange" | Should -BeNullOrEmpty
            $sc."sctp-portrange" | Should -BeNullOrEmpty
            $sc."protocol-number" | Should -BeNullOrEmpty
            $sc.icmptype | Should -BeNullOrEmpty
            $sc.icmpcode | Should -BeNullOrEmpty
            $sc.comment | Should -Be "My new Comment"
            $sc.'session-ttl' | Should -Be "0"
            $sc.color | Should -Be "0"
        }

        It "Change Service Custom Category (Email)" {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -category "Email"
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            if ($DefaultFGTConnection.version -ge "7.6.0") {
                $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
            }
            else {
                $sc.protocol | Should -Be "TCP/UDP/SCTP"
            }
            $sc."tcp-portrange" | Should -Not -BeNullOrEmpty
            $sc."udp-portrange" | Should -BeNullOrEmpty
            $sc."sctp-portrange" | Should -BeNullOrEmpty
            $sc."protocol-number" | Should -BeNullOrEmpty
            $sc.icmptype | Should -BeNullOrEmpty
            $sc.icmpcode | Should -BeNullOrEmpty
            $sc.category | Should -Be "Email"
        }


        It "Change Service Custom with data (1 field)" {
            $data = @{ "color" = 12 }
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -data $data
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Not -BeNullOrEmpty
            $sc.'session-ttl' | Should -Be "0"
            $sc.color | Should -Be "12"
        }

        It "Change Service Custom with data (2 fields)" {
            $data = @{ "color" = 23 ; "session-ttl" = 3600 }
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -data $data
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Not -BeNullOrEmpty
            $sc.'session-ttl' | Should -Be "3600"
            $sc.color | Should -Be "23"
        }

        It "Change Service Custom Name" {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -name pester_servicecustom2
            $sc = Get-FGTFirewallServiceCustom -name pester_servicecustom2
            $sc.name | Should -Be "pester_servicecustom2"
            if ($DefaultFGTConnection.version -ge "7.6.0") {
                $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
            }
            else {
                $sc.protocol | Should -Be "TCP/UDP/SCTP"
            }
            $sc."tcp-portrange" | Should -Not -BeNullOrEmpty
            $sc."udp-portrange" | Should -BeNullOrEmpty
            $sc."sctp-portrange" | Should -BeNullOrEmpty
            $sc."protocol-number" | Should -BeNullOrEmpty
            $sc.icmptype | Should -BeNullOrEmpty
            $sc.icmpcode | Should -BeNullOrEmpty
        }

        AfterAll {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Remove-FGTFirewallServiceCustom -confirm:$false
            Get-FGTFirewallServiceCustom -name pester_servicecustom2 | Remove-FGTFirewallServiceCustom -confirm:$false
        }
    }

    Context "Protocol : TCP/UDP/SCTP" {

        AfterEach {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Remove-FGTFirewallServiceCustom -confirm:$false
        }

        Context "TCP" {

            BeforeEach {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8081
            }

            It "Set Service Custom $pester_servicecustom1 with tcp-port" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -tcp_port 8080
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080"
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Set Service Custom $pester_servicecustom1 with tcp-port range" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -tcp_port "8080-8090"
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080-8090"
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Set Service Custom $pester_servicecustom1 with multiple tcp-port" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -tcp_port 8080, 8090
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080 8090"
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Set Service Custom $pester_servicecustom1 with multiple tcp-port range" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -tcp_port "8080-8090", 10000
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080-8090 10000"
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

        }

        Context "UDP" {

            BeforeEach {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -udp_port 8081
            }

            It "Set Service Custom $pester_servicecustom1 with udp-port" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -udp_port 8080
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -Be "8080"
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Set Service Custom $pester_servicecustom1 with udp-port range" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -udp_port "8080-8090"
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -Be "8080-8090"
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Set Service Custom $pester_servicecustom1 with multiple udp-port" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -udp_port 8080, 8090
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -Be "8080 8090"
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Set Service Custom $pester_servicecustom1 with multiple udp-port range" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -udp_port "8080-8090", 10000
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -Be "8080-8090 10000"
                $sc."sctp-portrange" | Should -BeNullOrEmpty
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

        }

        Context "SCTP" {

            BeforeEach {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -sctp_port 8081
            }

            It "Set Service Custom $pester_servicecustom1 with sctp-port" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -sctp_port 8080
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -Be "8080"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Set Service Custom $pester_servicecustom1 with sctp-port range" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -sctp_port "8080-8090"
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -Be "8080-8090"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Set Service Custom $pester_servicecustom1 with multiple sctp-port" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -sctp_port 8080, 8090
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -Be "8080 8090"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

            It "Set Service Custom $pester_servicecustom1 with multiple sctp-port range" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -sctp_port "8080-8090", 10000
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -BeNullOrEmpty
                $sc."udp-portrange" | Should -BeNullOrEmpty
                $sc."sctp-portrange" | Should -Be "8080-8090 10000"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }

        }

        Context "Multiple Protocol" {

            BeforeEach {
                Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -udp_port 8081
            }

            It "Set Service Custom $pester_servicecustom1 with tcp/udp/sctp port range" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -tcp_port 8080 -udp_port 8081 -sctp_port 8082
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080"
                $sc."udp-portrange" | Should -Be "8081"
                $sc."sctp-portrange" | Should -Be "8082"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }


            It "Set Service Custom $pester_servicecustom1 with multiple tcp/udp/sctp port range" {
                Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -tcp_port 8080, 9080 -udp_port 8081, 9081 -sctp_port 8082, 9082
                $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
                $sc.name | Should -Be $pester_servicecustom1
                if ($DefaultFGTConnection.version -ge "7.6.0") {
                    $sc.protocol | Should -Be "TCP/UDP/UDP-Lite/SCTP"
                }
                else {
                    $sc.protocol | Should -Be "TCP/UDP/SCTP"
                }
                $sc."tcp-portrange" | Should -Be "8080 9080"
                $sc."udp-portrange" | Should -Be "8081 9081"
                $sc."sctp-portrange" | Should -Be "8082 9082"
                $sc.comment | Should -BeNullOrEmpty
                $sc.'session-ttl' | Should -Be "0"
                $sc.color | Should -Be "0"
            }
        }
    }

    Context "Protocol: IP" {

        AfterEach {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Remove-FGTFirewallServiceCustom -confirm:$false
        }

        BeforeEach {
            Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -protocolNumber 43
        }

        It "Set Service Custom $pester_servicecustom1 with IP Protocol (44)" {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -protocolNumber 44
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Be "IP"
            $sc."tcp-portrange" | Should -BeNullOrEmpty
            $sc."udp-portrange" | Should -BeNullOrEmpty
            $sc."sctp-portrange" | Should -BeNullOrEmpty
            $sc."protocol-number" | Should -Be "44"
            $sc.comment | Should -BeNullOrEmpty
            $sc.'session-ttl' | Should -Be "0"
            $sc.color | Should -Be "0"
        }
    }

    Context "Protocol: ICMP" -skip:($fgt_version -lt "6.4.0") {

        AfterEach {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Remove-FGTFirewallServiceCustom -confirm:$false
        }

        BeforeEach {
            Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -icmptype 1 -icmpcode 7
        }

        It "Set Service Custom $pester_servicecustom1 with ICMP Type (0) and code (8)" {
            Get-FGTFirewallServiceCustom -name $pester_servicecustom1 | Set-FGTFirewallServiceCustom -icmptype 0 -icmpcode 8
            $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
            $sc.name | Should -Be $pester_servicecustom1
            $sc.protocol | Should -Be "ICMP"
            $sc."tcp-portrange" | Should -BeNullOrEmpty
            $sc."udp-portrange" | Should -BeNullOrEmpty
            $sc."sctp-portrange" | Should -BeNullOrEmpty
            $sc."protocol-number" | Should -BeNullOrEmpty
            $sc.icmptype | Should -Be "0"
            $sc.icmpcode | Should -Be "8"
            $sc.comment | Should -BeNullOrEmpty
            $sc.'session-ttl' | Should -Be "0"
            $sc.color | Should -Be "0"

        }

    }
}

Describe "Remove Firewall Service Custom" {

    BeforeEach {
        Add-FGTFirewallServiceCustom -Name $pester_servicecustom1 -tcp_port 8080
    }

    It "Remove Service Custom $pester_servicecustom1 by pipeline" {
        $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
        $sc | Remove-FGTFirewallServiceCustom -confirm:$false
        $sc = Get-FGTFirewallServiceCustom -name $pester_servicecustom1
        $sc | Should -Be $NULL
    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}