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

Describe "Get Firewall Address" {

    BeforeAll {
        $addr = Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
        $script:uuid = $addr.uuid
        Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io
        Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100
        Add-FGTFirewallAddress -Name $pester_address4 -country FR
        if ($DefaultFGTConnection.version -ge "7.0.0") {
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06
        }
    }

    It "Get Address Does not throw an error" {
        {
            Get-FGTFirewallAddress
        } | Should -Not -Throw
    }

    It "Get ALL Address" {
        $address = Get-FGTFirewallAddress
        $address.count | Should -Not -Be $NULL
    }

    It "Get ALL Address with -skip" {
        $address = Get-FGTFirewallAddress -skip
        $address.count | Should -Not -Be $NULL
    }

    It "Get Address ($pester_address1)" {
        $address = Get-FGTFirewallAddress -name $pester_address1
        $address.name | Should -Be $pester_address1
    }

    It "Get Address ($pester_address1) and confirm (via Confirm-FGTAddress)" {
        $address = Get-FGTFirewallAddress -name $pester_address1
        Confirm-FGTAddress ($address) | Should -Be $true
    }

    It "Get Address ($pester_address1) with meta" {
        $address = Get-FGTFirewallAddress -name $pester_address1 -meta
        $address.name | Should -Be $pester_address1
        $address.q_ref | Should -Not -BeNullOrEmpty
        $address.q_static | Should -Not -BeNullOrEmpty
        $address.q_no_rename | Should -Not -BeNullOrEmpty
        $address.q_global_entry | Should -Not -BeNullOrEmpty
        $address.q_type | Should -Not -BeNullOrEmpty
        $address.q_path | Should -Be "firewall"
        $address.q_name | Should -Be "address"
        $address.q_mkey_type | Should -Be "string"
        if ($DefaultFGTConnection.version -ge "6.2.0") {
            $address.q_no_edit | Should -Not -BeNullOrEmpty
        }
        $address.q_class | Should -Not -BeNullOrEmpty
    }

    Context "Search" {

        It "Search Address by name ($pester_address1)" {
            $address = Get-FGTFirewallAddress -name $pester_address1
            @($address).count | Should -be 1
            $address.name | Should -Be $pester_address1
        }

        It "Search Address by uuid ($script:uuid)" {
            $address = Get-FGTFirewallAddress -uuid $script:uuid
            @($address).count | Should -be 1
            $address.name | Should -Be $pester_address1
        }

    }

    AfterAll {
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
        Get-FGTFirewallAddress -name $pester_address5 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Add Firewall Address" {

    Context "ipmask" {

        AfterEach {
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        }

        It "Add Address $pester_address1 (type ipmask)" {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Add Address $pester_address1 (type ipmask and interface)" {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address1 (type ipmask and comment)" {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 -comment "Add via PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address1 (type ipmask and visiblity disable)" {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        It "Add Address $pester_address1 (type ipmask and allow routing)" {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 -allowrouting
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "enable"
        }

        It "Add Address $pester_address1 (type ipmask and data (1 field))" {
            $data = @{ "color" = 23 }
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 -data $data
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "23"
        }

        It "Add Address $pester_address1 (type ipmask and data (2 fields))" {
            $data = @{ "color" = 23 ; "comment" = "Add via PowerFGT and -data" }
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 -data $data
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT and -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "23"
        }

        It "Try to Add Address $pester_address1 (but there is already a object with same name)" {
            #Add first address
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
            #Add Second address with same name
            { Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0 } | Should -Throw "Already an address object using the same name"
        }

    }

    Context "iprange" {

        AfterEach {
            Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
        }

        It "Add Address $pester_address3 (type iprange)" {
            Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.1"
            $address.'end-ip' | Should -Be "192.0.2.100"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Add Address $pester_address3 (type iprange and interface)" {
            Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100 -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.1"
            $address.'end-ip' | Should -Be "192.0.2.100"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address3 (type iprange and comment)" {
            Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100 -comment "Add via PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.1"
            $address.'end-ip' | Should -Be "192.0.2.100"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address3 (type iprange and visiblity disable)" {
            Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100 -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.1"
            $address.'end-ip' | Should -Be "192.0.2.100"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        It "Add Address $pester_address3 (type iprange and data (1 field))" {
            $data = @{ "color" = 23 }
            Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100 -data $data
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.1"
            $address.'end-ip' | Should -Be "192.0.2.100"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.color | Should -Be "23"
        }

        It "Add Address $pester_address3 (type iprange and data (2 fields))" {
            $data = @{ "color" = 23 ; "comment" = "Add via PowerFGT and -data" }
            Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100 -data $data
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.1"
            $address.'end-ip' | Should -Be "192.0.2.100"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT and -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.color | Should -Be "23"
        }

        It "Try to Add Address $pester_address3 (but there is already a object with same name)" {
            #Add first address
            Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100
            #Add Second address with same name
            { Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100 } | Should -Throw "Already an address object using the same name"
        }

    }

    Context "fqdn" {

        AfterEach {
            Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        }

        It "Add Address $pester_address2 (type fqdn)" {
            Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.subnet | Should -BeNullOrEmpty
            $address.fqdn | Should -be "fortipower.github.io"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Add Address $pester_address2 (type fqdn and interface)" {
            Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.subnet | Should -BeNullOrEmpty
            $address.fqdn | Should -be "fortipower.github.io"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address2 (type fqdn and comment)" {
            Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io -comment "Add via PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.subnet | Should -BeNullOrEmpty
            $address.fqdn | Should -be "fortipower.github.io"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address2 (type fqdn and visiblity disable)" {
            Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.subnet | Should -BeNullOrEmpty
            $address.fqdn | Should -be "fortipower.github.io"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        It "Add Address $pester_address2 (type fqdn and data (1 field))" {
            $data = @{ "color" = 23 ; }
            Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io -data $data
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.subnet | Should -BeNullOrEmpty
            $address.fqdn | Should -be "fortipower.github.io"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.color | Should -Be "23"
        }

        It "Add Address $pester_address2 (type fqdn and data (2 fields))" {
            $data = @{ "color" = 23 ; "comment" = "Add via PowerFGT and -data" }
            Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io -data $data
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.subnet | Should -BeNullOrEmpty
            $address.fqdn | Should -be "fortipower.github.io"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT and -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.color | Should -Be "23"
        }

    }

    Context "geography" {

        AfterEach {
            Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
        }

        It "Add Address $pester_address4 (type geography)" {
            Add-FGTFirewallAddress -Name $pester_address4 -country FR
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.subnet | Should -BeNullOrEmpty
            $address.country | Should -be "FR"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Add Address $pester_address4 (type geography and interface)" {
            Add-FGTFirewallAddress -Name $pester_address4 -country FR -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.subnet | Should -BeNullOrEmpty
            $address.country | Should -be "FR"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address4 (type geography and comment)" {
            Add-FGTFirewallAddress -Name $pester_address4 -country FR -comment "Add via PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.subnet | Should -BeNullOrEmpty
            $address.country | Should -be "FR"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address4 (type geography and visiblity disable)" {
            Add-FGTFirewallAddress -Name $pester_address4 -country FR -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.subnet | Should -BeNullOrEmpty
            $address.country | Should -be "FR"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        It "Add Address $pester_address4 (type geography and data (1 field))" {
            $data = @{ "color" = 23 }
            Add-FGTFirewallAddress -Name $pester_address4 -country FR -data $data
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.subnet | Should -BeNullOrEmpty
            $address.country | Should -be "FR"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.color | Should -Be "23"
        }

        It "Add Address $pester_address4 (type geography and data (2 fields))" {
            $data = @{ "color" = 23 ; "comment" = "Add via PowerFGT and -data" }
            Add-FGTFirewallAddress -Name $pester_address4 -country FR -data $data
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.subnet | Should -BeNullOrEmpty
            $address.country | Should -be "FR"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT and -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.color | Should -Be "23"
        }

    }

    Context "mac" -skip:($fgt_version -lt "7.0.0") {

        AfterEach {
            Get-FGTFirewallAddress -name $pester_address5 | Remove-FGTFirewallAddress -confirm:$false
        }

        It "Add Address $pester_address5 (type mac)" {
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06"
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Add 2 Address(es) $pester_address5 (type mac)" {
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06, 01:02:03:04:05:07
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06", "01:02:03:04:05:07"
            ($address.macaddr.macaddr).count | Should -Be "2"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Add Address $pester_address5 (type mac and interface)" {
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06 -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -BeNullOrEmpty
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06"
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address5 (type mac and comment)" {
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06 -comment "Add via PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -BeNullOrEmpty
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06"
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address5 (type mac and visiblity disable)" {
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06 -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -BeNullOrEmpty
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06"
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        <# skip because can't enable allow routing with mac :)#>
        It "Add Address $pester_address5 (type mac and allow routing)" -skip:$true {
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06 -allowrouting
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -BeNullOrEmpty
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06"
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "enable"
        }


        It "Add Address $pester_address5 (type mac and data (1 field))" {
            $data = @{ "color" = 23 }
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06 -data $data
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -BeNullOrEmpty
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06"
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "23"
        }

        It "Add Address $pester_address5 (type mac and data (2 fields))" {
            $data = @{ "color" = 23 ; "comment" = "Add via PowerFGT and -data" }
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06 -data $data
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            #$address.'start-ip' | Should -Be "192.0.2.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -BeNullOrEmpty
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06"
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT and -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "23"
        }

        It "Try to Add Address $pester_address5 (but there is already a object with same name)" {
            #Add first address
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06
            #Add Second address with same name
            { Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06 } | Should -Throw "Already an address object using the same name"
        }

    }

    context "dynamic (SDN)" -skip:($fgt_version -lt "6.2.0") {

        BeforeAll {
            #Add SDN Connector
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server "myServer" -username MyUsername -password $pester_sdnconnectorpassword
        }
        AfterEach {
            Get-FGTFirewallAddress -name $pester_address6 | Remove-FGTFirewallAddress -confirm:$false
        }

        It "Add Address $pester_address6 (type dynamic)" {
            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=myVM"
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector1
            $address.filter | Should -Be "VMNAME=myVM"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Add Address $pester_address6 (type dynamic and interface)" {
            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=myVM" -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector1
            $address.filter | Should -Be "VMNAME=myVM"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address6 (type dynamic and comment)" {
            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=myVM" -comment "Add via PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector1
            $address.filter | Should -Be "VMNAME=myVM"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Add Address $pester_address6 (type dynamic and visiblity disable)" {
            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=myVM" -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector1
            $address.filter | Should -Be "VMNAME=myVM"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        <# skip because can't enable allow routing with dynamic :)#>
        It "Add Address $pester_address6 (type dynamic and allow routing)" -skip:$true {
            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=myVM" -allowrouting
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector1
            $address.filter | Should -Be "VMNAME=myVM"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "enable"
        }

        It "Add Address $pester_address6 (type dynamic and data (1 field))" {
            $data = @{ "color" = 23 }
            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=myVM" -data $data
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector1
            $address.filter | Should -Be "VMNAME=myVM"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "23"
        }

        It "Add Address $pester_address6 (type dynamic and data (2 fields))" {
            $data = @{ "color" = 23 ; "comment" = "Add via PowerFGT and -data" }
            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=myVM" -data $data
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector1
            $address.filter | Should -Be "VMNAME=myVM"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT and -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "23"
        }

        It "Try to Add Address $pester_address6 (but there is already a object with same name)" {
            #Add first address
            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=myVM"
            #Add Second address with same name
            { Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=myVM" } | Should -Throw "Already an address object using the same name"
        }

        AfterAll {
            #Delete SDN Connector
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Remove-FGTSystemSDNConnector -confirm:$false
        }
    }

}

Describe "Configure Firewall Address" {

    Context "ipmask" {

        BeforeAll {
            $address = Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
            $script:uuid = $address.uuid
        }

        It "Change IP Address" {
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -ip 192.0.3.0
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            #$address.'start-ip' | Should -Be "192.0.3.0"
            #$address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.0"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Change IP Mask" {
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -mask 255.255.255.128
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.3.0"
            # $address.'end-ip' | Should -Be "255.255.255.128"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change (Associated) Interface" {
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.3.0"
            # $address.'end-ip' | Should -Be "255.255.255.128"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change comment" {
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -comment "Modified by PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.3.0"
            # $address.'end-ip' | Should -Be "255.255.255.128"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change visiblity" {
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.3.0"
            # $address.'end-ip' | Should -Be "255.255.255.128"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        It "Change allow routing (enable)" {
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -allowrouting
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.3.0"
            # $address.'end-ip' | Should -Be "255.255.255.128"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "enable"
        }

        It "Change allow routing (disable)" {
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -allowrouting:$false
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.3.0"
            # $address.'end-ip' | Should -Be "255.255.255.128"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "disable"
        }

        It "Change -data (1 field)" {
            $data = @{ "color" = 23 }
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.3.0"
            # $address.'end-ip' | Should -Be "255.255.255.128"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "23"
        }

        It "Change -data (2 fields)" {
            $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address.name | Should -Be $pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.3.0"
            # $address.'end-ip' | Should -Be "255.255.255.128"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "4"
        }

        It "Try to Configure Address $pester_address1 (but it is wrong type...)" {
            { Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -fqdn "fortipower.github.io" } | Should -Throw "Address type (ipmask) need to be on the same type (fqdn)"
        }

        It "Change Name" {
            Get-FGTFirewallAddress -name $pester_address1 | Set-FGTFirewallAddress -name "pester_address_change"
            $address = Get-FGTFirewallAddress -name "pester_address_change"
            $address.name | Should -Be "pester_address_change"
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.3.0"
            # $address.'end-ip' | Should -Be "255.255.255.128"
            $address.subnet | Should -Be "192.0.3.0 255.255.255.128"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        AfterAll {
            Get-FGTFirewallAddress -uuid $script:uuid | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "iprange" {

        BeforeAll {
            $address = Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100
            $script:uuid = $address.uuid
        }

        It "Change Start IP" {
            Get-FGTFirewallAddress -name $pester_address3 | Set-FGTFirewallAddress -startip 192.0.2.99
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.99"
            $address.'end-ip' | Should -Be "192.0.2.100"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Change End IP" {
            Get-FGTFirewallAddress -name $pester_address3 | Set-FGTFirewallAddress -endip 192.0.2.199
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.99"
            $address.'end-ip' | Should -Be "192.0.2.199"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change (Associated) Interface" {
            Get-FGTFirewallAddress -name $pester_address3 | Set-FGTFirewallAddress -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.99"
            $address.'end-ip' | Should -Be "192.0.2.199"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change comment" {
            Get-FGTFirewallAddress -name $pester_address3 | Set-FGTFirewallAddress -comment "Modified by PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.99"
            $address.'end-ip' | Should -Be "192.0.2.199"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change visiblity" {
            Get-FGTFirewallAddress -name $pester_address3 | Set-FGTFirewallAddress -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.99"
            $address.'end-ip' | Should -Be "192.0.2.199"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        It "Change -data (1 field)" {
            $data = @{ "color" = 23 }
            Get-FGTFirewallAddress -name $pester_address3 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.99"
            $address.'end-ip' | Should -Be "192.0.2.199"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'color' | Should -Be "23"
        }

        It "Change -data (2 fields)" {
            $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
            Get-FGTFirewallAddress -name $pester_address3 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address.name | Should -Be $pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.99"
            $address.'end-ip' | Should -Be "192.0.2.199"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'color' | Should -Be "4"
        }

        It "Try to Configure Address $pester_address3 (but it is wrong type...)" {
            { Get-FGTFirewallAddress -name $pester_address3 | Set-FGTFirewallAddress -fqdn "fortipower.github.io" } | Should -Throw "Address type (iprange) need to be on the same type (fqdn)"
        }

        It "Change Name" {
            Get-FGTFirewallAddress -name $pester_address3 | Set-FGTFirewallAddress -name "pester_address_change"
            $address = Get-FGTFirewallAddress -name "pester_address_change"
            $address.name | Should -Be "pester_address_change"
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.99"
            $address.'end-ip' | Should -Be "192.0.2.199"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        AfterAll {
            Get-FGTFirewallAddress -uuid $script:uuid | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "fqdn" {

        BeforeAll {
            $address = Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io
            $script:uuid = $address.uuid
        }

        It "Change fqdn" {
            Get-FGTFirewallAddress -name $pester_address2 | Set-FGTFirewallAddress -fqdn fortipower.github.com
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.fqdn | Should -Be "fortipower.github.com"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Change (Associated) Interface" {
            Get-FGTFirewallAddress -name $pester_address2 | Set-FGTFirewallAddress -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.fqdn | Should -Be "fortipower.github.com"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change comment" {
            Get-FGTFirewallAddress -name $pester_address2 | Set-FGTFirewallAddress -comment "Modified by PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.fqdn | Should -Be "fortipower.github.com"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change visiblity" {
            Get-FGTFirewallAddress -name $pester_address2 | Set-FGTFirewallAddress -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.fqdn | Should -Be "fortipower.github.com"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        It "Change -data (1 field)" {
            $data = @{ "color" = 23 }
            Get-FGTFirewallAddress -name $pester_address2 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.fqdn | Should -Be "fortipower.github.com"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'color' | Should -Be "23"
        }

        It "Change -data (2 fields)" {
            $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
            Get-FGTFirewallAddress -name $pester_address2 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address.name | Should -Be $pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.fqdn | Should -Be "fortipower.github.com"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'color' | Should -Be "4"
        }

        It "Try to Configure Address $pester_address2 (but it is wrong type...)" {
            { Get-FGTFirewallAddress -name $pester_address2 | Set-FGTFirewallAddress -ip 192.0.2.0 -mask 255.255.255.0 } | Should -Throw "Address type (fqdn) need to be on the same type (ipmask)"
        }

        It "Change Name" {
            Get-FGTFirewallAddress -name $pester_address2 | Set-FGTFirewallAddress -name "pester_address_change"
            $address = Get-FGTFirewallAddress -name "pester_address_change"
            $address.name | Should -Be "pester_address_change"
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.fqdn | Should -Be "fortipower.github.com"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        AfterAll {
            Get-FGTFirewallAddress -uuid $script:uuid | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "geography" {

        BeforeAll {
            $address = Add-FGTFirewallAddress -Name $pester_address4 -country US
            $script:uuid = $address.uuid
        }

        It "Change geography" {
            Get-FGTFirewallAddress -name $pester_address4 | Set-FGTFirewallAddress -country FR
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.country | Should -Be "FR"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.'color' | Should -Be "0"
        }

        It "Change (Associated) Interface" {
            Get-FGTFirewallAddress -name $pester_address4 | Set-FGTFirewallAddress -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.country | Should -Be "FR"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change comment" {
            Get-FGTFirewallAddress -name $pester_address4 | Set-FGTFirewallAddress -comment "Modified by PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.country | Should -Be "FR"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change visiblity" {
            Get-FGTFirewallAddress -name $pester_address4 | Set-FGTFirewallAddress -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.country | Should -Be "FR"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        It "Change -data (1 field)" {
            $data = @{ "color" = 23 }
            Get-FGTFirewallAddress -name $pester_address4 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.country | Should -Be "FR"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'color' | Should -Be "23"
        }

        It "Change -data (2 fields)" {
            $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
            Get-FGTFirewallAddress -name $pester_address4 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address.name | Should -Be $pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.country | Should -Be "FR"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'color' | Should -Be "4"
        }

        It "Try to Configure Address $pester_address4 (but it is wrong type...)" {
            { Get-FGTFirewallAddress -name $pester_address4 | Set-FGTFirewallAddress -ip 192.0.2.0 -mask 255.255.255.0 } | Should -Throw "Address type (geography) need to be on the same type (ipmask)"
        }

        It "Change Name" {
            Get-FGTFirewallAddress -name $pester_address4 | Set-FGTFirewallAddress -name "pester_address_change"
            $address = Get-FGTFirewallAddress -name "pester_address_change"
            $address.name | Should -Be "pester_address_change"
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.country | Should -Be "FR"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        AfterAll {
            Get-FGTFirewallAddress -uuid $script:uuid | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "mac" -skip:($fgt_version -lt "7.0.0") {

        BeforeAll {
            $address = Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06
            $script:uuid = $address.uuid
        }

        It "Change 2 MAC" {
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -mac 01:02:03:04:05:06, 01:02:03:04:05:07
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "2"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06", "01:02:03:04:05:07"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Change 1 MAC" {
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -mac 01:02:03:04:05:07
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:07"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }


        It "Change (Associated) Interface" {
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:07"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change comment" {
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -comment "Modified by PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change visiblity" {
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:07"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        # Skip allow-routing is not supported with mac type
        It "Change allow routing (enable)" -skip:$true {
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -allowrouting
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:07"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "enable"
        }

        # Skip allow-routing is not supported with mac type
        It "Change allow routing (disable)" -skip:$true {
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -allowrouting:$false
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:07"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "disable"
        }

        It "Change -data (1 field)" {
            $data = @{ "color" = 23 }
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:07"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "23"
        }

        It "Change -data (2 fields)" {
            $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address.name | Should -Be $pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:07"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "4"
        }

        It "Try to Configure Address $pester_address5 (but it is wrong type...)" {
            { Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -fqdn "fortipower.github.io" } | Should -Throw "Address type (mac) need to be on the same type (fqdn)"
        }

        It "Change Name" {
            Get-FGTFirewallAddress -name $pester_address5 | Set-FGTFirewallAddress -name "pester_address_change"
            $address = Get-FGTFirewallAddress -name "pester_address_change"
            $address.name | Should -Be "pester_address_change"
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "mac"
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:07"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        AfterAll {
            Get-FGTFirewallAddress -uuid $script:uuid | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    context "dynamic (SDN)" -skip:($fgt_version -lt "6.2.0") {

        BeforeAll {

            #Add SDN Connector
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server "myServer" -username MyUsername -password $pester_sdnconnectorpassword

            Add-FGTSystemSDNConnector -name $pester_sdnconnector2 -server "myServer2" -username MyUsername -password $pester_sdnconnectorpassword

            $address = Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=MyVM"
            $script:uuid = $address.uuid
        }

        It "Change Filter" {
            Get-FGTFirewallAddress -name $pester_address6 | Set-FGTFirewallAddress -filter "VMNAME=MyFGTVM"
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector1
            $address.filter | Should -Be "VMNAME=MyFGTVM"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "0"
        }

        It "Change SDN" {
            Get-FGTFirewallAddress -name $pester_address6 | Set-FGTFirewallAddress -sdn $pester_sdnconnector2
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector2
            $address.filter | Should -Be "VMNAME=MyFGTVM"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change (Associated) Interface" {
            Get-FGTFirewallAddress -name $pester_address6 | Set-FGTFirewallAddress -interface port2
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector2
            $address.filter | Should -Be "VMNAME=MyFGTVM"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change comment" {
            Get-FGTFirewallAddress -name $pester_address6 | Set-FGTFirewallAddress -comment "Modified by PowerFGT"
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector2
            $address.filter | Should -Be "VMNAME=MyFGTVM"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        It "Change visiblity" {
            Get-FGTFirewallAddress -name $pester_address6 | Set-FGTFirewallAddress -visibility:$false
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector2
            $address.filter | Should -Be "VMNAME=MyFGTVM"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }

        It "Change -data (1 field)" {
            $data = @{ "color" = 23 }
            Get-FGTFirewallAddress -name $pester_address6 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector2
            $address.filter | Should -Be "VMNAME=MyFGTVM"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "23"
        }

        It "Change -data (2 fields)" {
            $data = @{ "color" = 4 ; comment = "Modified by PowerFGT via -data" }
            Get-FGTFirewallAddress -name $pester_address6 | Set-FGTFirewallAddress -data $data
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address.name | Should -Be $pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector2
            $address.filter | Should -Be "VMNAME=MyFGTVM"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
            $address.'allow-routing' | Should -Be "disable"
            $address.color | Should -Be "4"
        }

        It "Try to Configure Address $pester_address6 (but it is wrong type...)" {
            { Get-FGTFirewallAddress -name $pester_address6 | Set-FGTFirewallAddress -fqdn "fortipower.github.io" } | Should -Throw "Address type (dynamic) need to be on the same type (fqdn)"
        }

        It "Change Name" {
            Get-FGTFirewallAddress -name $pester_address6 | Set-FGTFirewallAddress -name "pester_address_change"
            $address = Get-FGTFirewallAddress -name "pester_address_change"
            $address.name | Should -Be "pester_address_change"
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "dynamic"
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector2
            $address.filter | Should -Be "VMNAME=MyFGTVM"
            $address.'associated-interface' | Should -Be "port2"
            $address.comment | Should -Be "Modified by PowerFGT via -data"
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "disable"
            }
        }
        AfterAll {
            Get-FGTFirewallAddress -uuid $script:uuid | Remove-FGTFirewallAddress -confirm:$false

            #Delete SDN Connector
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Remove-FGTSystemSDNConnector -confirm:$false
            Get-FGTSystemSDNConnector -name $pester_sdnconnector2 | Remove-FGTSystemSDNConnector -confirm:$false
        }

    }
}

Describe "Copy Firewall Address" {

    Context "ipmask" {

        BeforeAll {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
        }

        It "Copy Firewall Address ($pester_address1 => copy_pester_address1)" {
            Get-FGTFirewallAddress -name $pester_address1 | Copy-FGTFirewallAddress -name copy_pester_address1
            $address = Get-FGTFirewallAddress -name copy_pester_address1
            $address.name | Should -Be copy_pester_address1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "ipmask"
            # $address.'start-ip' | Should -Be "192.0.2.0"
            # $address.'end-ip' | Should -Be "255.255.255.0"
            $address.subnet | Should -Be "192.0.2.0 255.255.255.0"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        AfterAll {
            #Remove copy_pester_address1
            Get-FGTFirewallAddress -name copy_pester_address1 | Remove-FGTFirewallAddress -confirm:$false
            #Remove $pester_address1
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "iprange" {

        BeforeAll {
            Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100
        }

        It "Copy Firewall Address ($pester_address3 => copy_pester_address3)" {
            Get-FGTFirewallAddress -name $pester_address3 | Copy-FGTFirewallAddress -name copy_pester_address3
            $address = Get-FGTFirewallAddress -name copy_pester_address3
            $address.name | Should -Be copy_pester_address3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "iprange"
            $address.'start-ip' | Should -Be "192.0.2.1"
            $address.'end-ip' | Should -Be "192.0.2.100"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        AfterAll {
            #Remove copy_pester_address3
            Get-FGTFirewallAddress -name copy_pester_address3 | Remove-FGTFirewallAddress -confirm:$false
            #Remove $pester_address3
            Get-FGTFirewallAddress -name $pester_address3 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "fqdn" {

        BeforeAll {
            Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io
        }

        It "Copy Firewall Address ($pester_address2 => copy_pester_address2)" {
            Get-FGTFirewallAddress -name $pester_address2 | Copy-FGTFirewallAddress -name copy_pester_address2
            $address = Get-FGTFirewallAddress -name copy_pester_address2
            $address.name | Should -Be copy_pester_address2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "fqdn"
            $address.subnet | Should -BeNullOrEmpty
            $address.fqdn | Should -be "fortipower.github.io"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        AfterAll {
            #Remove copy_pester_address2
            Get-FGTFirewallAddress -name copy_pester_address2 | Remove-FGTFirewallAddress -confirm:$false
            #Remove $pester_address2
            Get-FGTFirewallAddress -name $pester_address2 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "geography" {

        BeforeAll {
            Add-FGTFirewallAddress -name $pester_address4 -country FR
        }

        It "Copy Firewall Address ($pester_address4 => copy_pester_address4)" {
            Get-FGTFirewallAddress -name $pester_address4 | Copy-FGTFirewallAddress -name copy_pester_address4
            $address = Get-FGTFirewallAddress -name copy_pester_address4
            $address.name | Should -Be copy_pester_address4
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "geography"
            $address.subnet | Should -BeNullOrEmpty
            $address.country | Should -be "FR"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        AfterAll {
            #Remove copy_pester_address4
            Get-FGTFirewallAddress -name copy_pester_address4 | Remove-FGTFirewallAddress -confirm:$false
            #Remove $pester_address4
            Get-FGTFirewallAddress -name $pester_address4 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "mac" -skip:($fgt_version -lt "7.0.0") {

        BeforeAll {
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06
        }

        It "Copy Firewall Address ($pester_address5 => copy_pester_address5)" {
            Get-FGTFirewallAddress -name $pester_address5 | Copy-FGTFirewallAddress -name copy_pester_address5
            $address = Get-FGTFirewallAddress -name copy_pester_address5
            $address.name | Should -Be copy_pester_address5
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.subnet | Should -BeNullOrEmpty
            ($address.macaddr.macaddr).count | Should -Be "1"
            $address.macaddr.macaddr | Should -Be "01:02:03:04:05:06"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        AfterAll {
            #Remove copy_pester_address5
            Get-FGTFirewallAddress -name copy_pester_address5 | Remove-FGTFirewallAddress -confirm:$false
            #Remove $pester_address5
            Get-FGTFirewallAddress -name $pester_address5 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    context "dynamic (SDN)" -skip:($fgt_version -lt "6.2.0") {

        BeforeAll {
            #Add SDN Connector
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server "myServer" -username MyUsername -password $pester_sdnconnectorpassword

            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=MyVM"
        }

        It "Copy Firewall Address ($pester_address6 => copy_pester_address6)" {
            Get-FGTFirewallAddress -name $pester_address6 | Copy-FGTFirewallAddress -name copy_pester_address6
            $address = Get-FGTFirewallAddress -name copy_pester_address6
            $address.name | Should -Be copy_pester_address6
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.subnet | Should -BeNullOrEmpty
            $address.sdn | Should -Be $pester_sdnconnector1
            $address.filter | Should -Be "VMNAME=MyVM"
            $address.'associated-interface' | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            if ($DefaultFGTConnection.version -lt "6.4.0") {
                $address.visibility | Should -Be "enable"
            }
        }

        AfterAll {
            #Remove copy_pester_address6
            Get-FGTFirewallAddress -name copy_pester_address6 | Remove-FGTFirewallAddress -confirm:$false
            #Remove $pester_address6
            Get-FGTFirewallAddress -name $pester_address6 | Remove-FGTFirewallAddress -confirm:$false

            #Delete SDN Connector
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Remove-FGTSystemSDNConnector -confirm:$false
        }

    }

}

Describe "Remove Firewall Address" {

    Context "ipmask" {

        BeforeEach {
            Add-FGTFirewallAddress -Name $pester_address1 -ip 192.0.2.0 -mask 255.255.255.0
        }

        It "Remove Address $pester_address1 by pipeline" {
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address | Remove-FGTFirewallAddress -confirm:$false
            $address = Get-FGTFirewallAddress -name $pester_address1
            $address | Should -Be $NULL
        }

    }

    Context "iprange" {

        BeforeEach {
            Add-FGTFirewallAddress -Name $pester_address3 -startip 192.0.2.1 -endip 192.0.2.100
        }

        It "Remove Address $pester_address3 by pipeline" {
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address | Remove-FGTFirewallAddress -confirm:$false
            $address = Get-FGTFirewallAddress -name $pester_address3
            $address | Should -Be $NULL
        }

    }

    Context "fqdn" {

        BeforeEach {
            Add-FGTFirewallAddress -Name $pester_address2 -fqdn fortipower.github.io
        }

        It "Remove Address $pester_address2 by pipeline" {
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address | Remove-FGTFirewallAddress -confirm:$false
            $address = Get-FGTFirewallAddress -name $pester_address2
            $address | Should -Be $NULL
        }

    }

    Context "geography" {

        BeforeEach {
            Add-FGTFirewallAddress -Name $pester_address4 -country FR
        }

        It "Remove Address $pester_address4 by pipeline" {
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address | Remove-FGTFirewallAddress -confirm:$false
            $address = Get-FGTFirewallAddress -name $pester_address4
            $address | Should -Be $NULL
        }

    }

    Context "mac" -skip:($fgt_version -lt "7.0.0") {

        BeforeEach {
            Add-FGTFirewallAddress -Name $pester_address5 -mac 01:02:03:04:05:06
        }

        It "Remove Address $pester_address5 by pipeline" {
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address | Remove-FGTFirewallAddress -confirm:$false
            $address = Get-FGTFirewallAddress -name $pester_address5
            $address | Should -Be $NULL
        }

    }

    context "dynamic (SDN)" -skip:($fgt_version -lt "6.2.0") {

        BeforeEach {
            #Add SDN Connector
            Add-FGTSystemSDNConnector -name $pester_sdnconnector1 -server "myServer" -username MyUsername -password $pester_sdnconnectorpassword

            Add-FGTFirewallAddress -Name $pester_address6 -sdn $pester_sdnconnector1 -filter "VMNAME=MyVM"
        }

        It "Remove Address $pester_address6 by pipeline" {
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address | Remove-FGTFirewallAddress -confirm:$false
            $address = Get-FGTFirewallAddress -name $pester_address6
            $address | Should -Be $NULL
        }

        AfterEach {
            #Delete SDN Connector
            Get-FGTSystemSDNConnector -name $pester_sdnconnector1 | Remove-FGTSystemSDNConnector -confirm:$false
        }

    }

}

AfterAll {
    Disconnect-FGT -confirm:$false
}