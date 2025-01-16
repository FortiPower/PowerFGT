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

Describe "Get SDN Connector" -skip:($fgt_version -lt "6.2.0") {

    BeforeAll {
        Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server MyVcenter -username "powerfgt@vsphere.local" -password $pester_sdnconnectorpassword
    }

    It "Get SDN Connector does not throw an error" {
        {
            Get-FGTSystemSDNConnector
        } | Should -Not -Throw
    }

    It "Get ALL SDN Connectors" {
        $sdnconnector = Get-FGTSystemSDNConnector
        @($sdnconnector).count | Should -Not -Be $NULL
    }

    It "Get ALL SDN Connector with -skip" {
        $sdnconnector = Get-FGTSystemSDNConnector -skip
        @($sdnconnector).count | Should -Not -Be $NULL
    }

    It "Get SDN Connector ($pester_sdnconnector1)" {
        $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
        $sdnconnector.name | Should -Be $pester_sdnconnector1
    }

    It "Get SDN Connector ($pester_sdnconnector1) and confirm (via Confirm-FGTSDNConnector)" {
        $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
        Confirm-FGTSDNConnector $sdnconnector | Should -Be $true
    }

    It "Get SDN Connector ($pester_sdnconnector1) with meta" {
        $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1 -meta
        $sdnconnector.name | Should -Be $pester_sdnconnector1
        $sdnconnector.q_ref | Should -Not -BeNullOrEmpty
        $sdnconnector.q_static | Should -Not -BeNullOrEmpty
        $sdnconnector.q_no_rename | Should -Not -BeNullOrEmpty
        $sdnconnector.q_global_entry | Should -Not -BeNullOrEmpty
        $sdnconnector.q_type | Should -Not -BeNullOrEmpty
        $sdnconnector.q_path | Should -Be "system"
        $sdnconnector.q_name | Should -Be "sdn-connector"
        $sdnconnector.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $sdnconnector.q_no_edit | Should -Not -BeNullOrEmpty
        }
        #$sdnconnector.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search SDN Connector by name ($pester_sdnconnector1)" {
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            @($sdnconnector).count | Should -be 1
            $sdnconnector.name | Should -Be $pester_sdnconnector1
        }

    }

    AfterAll {
        Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Remove-FGTSystemSDNConnector -Confirm:$false
    }

}

Describe "Add SDN Connector" -skip:($fgt_version -lt "6.2.0") {

    AfterEach {
        Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Remove-FGTSystemSDNConnector -Confirm:$false
    }

    Context "vmware" {

        It "Add SDN Connector type vmware with only mandatory parameters" {
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server MyVcenter -username "powerfgt@vsphere.local" -password $pester_sdnconnectorpassword
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.name | Should -Be $pester_sdnconnector1
            $sdnconnector.type | Should -Be "vmware"
            $sdnconnector.server | Should -Be "MyVcenter"
            $sdnconnector.username | Should -Be "powerfgt@vsphere.local"
            $sdnconnector.password | Should -Not -Be $NULL
            $sdnconnector.status | Should -Be "enable"
            if ($DefaultFGTConnection.version -ge "6.4.0") {
                $sdnconnector."verify-certificate" | Should -Be "enable"
            }
            $sdnconnector."update-interval" | Should -Be "60"
        }

        It "Add SDN Connector type vmware with status disable" {
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server MyVcenter -username "powerfgt@vsphere.local" -password $pester_sdnconnectorpassword -status:$disable
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.name | Should -Be $pester_sdnconnector1
            $sdnconnector.type | Should -Be "vmware"
            $sdnconnector.server | Should -Be "MyVcenter"
            $sdnconnector.username | Should -Be "powerfgt@vsphere.local"
            $sdnconnector.password | Should -Not -Be $NULL
            $sdnconnector.status | Should -Be "disable"
            if ($DefaultFGTConnection.version -ge "6.4.0") {
                $sdnconnector."verify-certificate" | Should -Be "enable"
            }
            $sdnconnector."update-interval" | Should -Be "60"
        }

        It "Add SDN Connector type vmware with verify-certificate disable" -skip:($fgt_version -lt "6.4.0") {
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server MyVcenter -username "powerfgt@vsphere.local" -password $pester_sdnconnectorpassword -verify_certificate:$disable
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.name | Should -Be $pester_sdnconnector1
            $sdnconnector.type | Should -Be "vmware"
            $sdnconnector.server | Should -Be "MyVcenter"
            $sdnconnector.username | Should -Be "powerfgt@vsphere.local"
            $sdnconnector.password | Should -Not -Be $NULL
            $sdnconnector.status | Should -Be "enable"
            $sdnconnector."verify-certificate" | Should -Be "disable"
            $sdnconnector."update-interval" | Should -Be "60"
        }

        It "Add SDN Connector type vmware with update-interval (120)" {
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server MyVcenter -username "powerfgt@vsphere.local" -password $pester_sdnconnectorpassword -update_interval 120
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.name | Should -Be $pester_sdnconnector1
            $sdnconnector.type | Should -Be "vmware"
            $sdnconnector.server | Should -Be "MyVcenter"
            $sdnconnector.username | Should -Be "powerfgt@vsphere.local"
            $sdnconnector.password | Should -Not -Be $NULL
            $sdnconnector.status | Should -Be "enable"
            if ($DefaultFGTConnection.version -ge "6.4.0") {
                $sdnconnector."verify-certificate" | Should -Be "enable"
            }
            $sdnconnector."update-interval" | Should -Be "120"
        }

        It "Add SDN Connector type vmware (with -data (1 field))" {
            $data = @{ "update-interval" = "360" }
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server MyVcenter -username "powerfgt@vsphere.local" -password $pester_sdnconnectorpassword -data $data
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.name | Should -Be $pester_sdnconnector1
            $sdnconnector.type | Should -Be "vmware"
            $sdnconnector.server | Should -Be "MyVcenter"
            $sdnconnector.username | Should -Be "powerfgt@vsphere.local"
            $sdnconnector.password | Should -Not -Be $NULL
            $sdnconnector.status | Should -Be "enable"
            if ($DefaultFGTConnection.version -ge "6.4.0") {
                $sdnconnector."verify-certificate" | Should -Be "enable"
            }
            $sdnconnector."update-interval" | Should -Be "360"
        }

        It "Add SDN Connector type vmware (with -data (2 fields))" {
            $data = @{ "update-interval" = "600"; "status" = "disable" }
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server MyVcenter -username "powerfgt@vsphere.local" -password $pester_sdnconnectorpassword -data $data
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.name | Should -Be $pester_sdnconnector1
            $sdnconnector.type | Should -Be "vmware"
            $sdnconnector.server | Should -Be "MyVcenter"
            $sdnconnector.username | Should -Be "powerfgt@vsphere.local"
            $sdnconnector.password | Should -Not -Be $NULL
            $sdnconnector.status | Should -Be "disable"
            if ($DefaultFGTConnection.version -ge "6.4.0") {
                $sdnconnector."verify-certificate" | Should -Be "enable"
            }
            $sdnconnector."update-interval" | Should -Be "600"

        }

        <#
        It "Add SDN Connector (with -data (1 field))" {
            $data = @{ "alias" = "int_PowerFGT" }
            $p = $_.param
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 @p -data $data
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.name | Should -Be $pester_sdnconnector1
            switch ($_.type) {
                "vlan" {
                    $sdnconnector.type | Should -Be "vlan"
                    $sdnconnector.vlanid | Should -Be $pester_vlanid1
                    $sdnconnector.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $sdnconnector.type | Should -Be "aggregate"
                    $sdnconnector.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $sdnconnector.type | Should -Be "redundant"
                    }
                    else {
                        $sdnconnector.type | Should -Be "aggregate"
                    }
                    $sdnconnector.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $sdnconnector.type | Should -Be "loopback"
                }
            }
            $sdnconnector.role | Should -Be "lan"
            $sdnconnector.mode | Should -Be "static"
            $sdnconnector.alias | Should -Be "int_PowerFGT"
        }

        It "Add SDN Connector (with -data (2 fields))" {
            $data = @{ "alias" = "int_PowerFGT"; description = "Add via PowerFGT using -data" }
            $p = $_.param
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 @p -data $data
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.name | Should -Be $pester_sdnconnector1
            switch ($_.type) {
                "vlan" {
                    $sdnconnector.type | Should -Be "vlan"
                    $sdnconnector.vlanid | Should -Be $pester_vlanid1
                    $sdnconnector.interface | Should -Be $pester_port1
                }
                "aggregate_lacp" {
                    $sdnconnector.type | Should -Be "aggregate"
                    $sdnconnector.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "aggregate_static" {
                    if (($fgt_version -ge "6.2.0")) {
                        $sdnconnector.type | Should -Be "redundant"
                    }
                    else {
                        $sdnconnector.type | Should -Be "aggregate"
                    }
                    $sdnconnector.member.'interface-name' | Should -BeIn $pester_port1, $pester_port2
                }
                "loopback" {
                    $sdnconnector.type | Should -Be "loopback"
                }
            }
            $sdnconnector.role | Should -Be "lan"
            $sdnconnector.mode | Should -Be "static"
            $sdnconnector.alias | Should -Be "int_PowerFGT"
            $sdnconnector.description | Should -Be "Add via PowerFGT using -data"
        }
#>
    }
}

Describe "Set SDN Connector" -skip:($fgt_version -lt "6.2.0") {

    Context "vmware" {
        BeforeAll {
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server MyVcenter -username "powerfgt@vsphere.local" -password $pester_sdnconnectorpassword
        }

        It "Set SDN Connector status (disable)" {
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Set-FGTSystemSDNConnector -status:$false
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.status | Should -Be "disable"
        }

        It "Set SDN Connector status (enable)" {
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Set-FGTSystemSDNConnector -status
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.status | Should -Be "enable"
        }

        It "Set SDN Connector verify-certificate (disable)" -skip:($fgt_version -lt "6.4.0") {
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Set-FGTSystemSDNConnector -verify_certificate:$false
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector."verify-certificate" | Should -Be "disable"
        }

        It "Set SDN Connector verify-certificate (enable)" -skip:($fgt_version -lt "6.4.0") {
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Set-FGTSystemSDNConnector -verify_certificate
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector."verify-certificate" | Should -Be "enable"
        }

        It "Set SDN Connector update-interval (120)" {
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Set-FGTSystemSDNConnector -update_interval 120
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector."update-interval" | Should -Be "120"
        }

        It "Set SDN Connector using -data (1 field)" {
            $data = @{ "server" = "MyUpdateServer" }
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Set-FGTSystemSDNConnector -data $data
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector.server | Should -Be "MyUpdateServer"
        }

        It "Set SDN Connector using -data (2 fields)" {
            $data = @{ "update-interval" = "44" ; server = "MyUpdateServer2" }
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Set-FGTSystemSDNConnector -data $data
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector."update-interval" | Should -Be "44"
            $sdnconnector.server | Should -Be "MyUpdateServer2"
        }

        AfterAll {
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Remove-FGTSystemSDNConnector -Confirm:$false
        }
    }
}

Describe "Remove SDN Connector" -skip:($fgt_version -lt "6.2.0") {

    Context "vmware" {

        BeforeEach {
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server MyVcenter -username "powerfgt@vsphere.local" -password $pester_sdnconnectorpassword
        }

        It "Remove SDN Connector by pipeline" {
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Remove-FGTSystemSDNConnector -confirm:$false
            $sdnconnector = Get-FGTSystemSDNConnector -name $pester_sdnconnector1
            $sdnconnector | Should -Be $NULL
        }

    }
}

AfterAll {
    Disconnect-FGT -confirm:$false
}