#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

#include common configuration
. ../common.ps1

Describe "Get Firewall Proxy Address" {

    BeforeAll {
        $addr = Add-FGTFirewallProxyAddress -name $pester_proxyaddress1 -hostregex 'fortipower.github.io'
        $script:uuid = $addr.uuid
        Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method get -hostObjectName $pester_address1
        Add-FGTFirewallProxyAddress -Name $pester_proxyaddress3 -hostObjectName $pester_address1 -path '/PowerFGT'
    }

    It "Get Address Does not throw an error" {
        {
            Get-FGTFirewallProxyAddress
        } | Should -Not -Throw
    }

    It "Get ALL Address" {
        $address = Get-FGTFirewallProxyAddress
        $address.count | Should -Not -Be $NULL
    }

    It "Get ALL Address with -skip" {
        $address = Get-FGTFirewallProxyAddress -skip
        $address.count | Should -Not -Be $NULL
    }

    It "Get Address ($pester_proxyaddress1)" {
        $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress1
        $address.name | Should -Be $pester_proxyaddress1
    }

    It "Get Address ($pester_proxyaddress1) and confirm (via Confirm-FGTProxyAddress)" {
        $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress1
        Confirm-FGTProxyAddress ($address) | Should -Be $true
    }

    Context "Search" {

        It "Search Address by name ($pester_proxyaddress1)" {
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress1
            @($address).count | Should -be 1
            $address.name | Should -Be $pester_proxyaddress1
        }

        It "Search Address by uuid ($script:uuid)" {
            $address = Get-FGTFirewallProxyAddress -uuid $script:uuid
            @($address).count | Should -be 1
            $address.name | Should -Be $pester_proxyaddress1
        }

    }

    AfterAll {
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false
        Get-FGTFirewallProxyAddress -name $pester_proxyaddress3 | Remove-FGTFirewallProxyAddress -confirm:$false

        #Remove also Firewall Address (FQDN)
        Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
    }

}

Describe "Add Firewall Proxy Address" {

    Context "host-regex" {

        AfterEach {
            Get-FGTFirewallProxyAddress -name $pester_proxyaddress1 | Remove-FGTFirewallProxyAddress -confirm:$false
        }

        It "Add Address $pester_proxyaddress1 (type host-regex)" {
            Add-FGTFirewallProxyAddress -name $pester_proxyaddress1 -hostregex 'fortipower.github.io'
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress1
            $address.name | Should -Be $pester_proxyaddress1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "host-regex"
            $address.host | Should -BeNullOrEmpty
            $address.'host-regex' | Should -Be "fortipower.github.io"
            $address.path | Should -BeNullOrEmpty
            $address.method | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            $address.visibility | Should -Be $true
        }


        It "Add Address $pester_proxyaddress1 (type host-regex and comment)" {
            Add-FGTFirewallProxyAddress -name $pester_proxyaddress1 -hostregex 'fortipower.github.io' -comment "Add via PowerFGT"
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress1
            $address.name | Should -Be $pester_proxyaddress1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "host-regex"
            $address.host | Should -BeNullOrEmpty
            $address.'host-regex' | Should -Be "fortipower.github.io"
            $address.path | Should -BeNullOrEmpty
            $address.method | Should -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT"
            $address.visibility | Should -Be $true
        }

        It "Add Address $pester_proxyaddress1 (type host-regex and visiblity disable)" {
            Add-FGTFirewallProxyAddress -name $pester_proxyaddress1 -hostregex 'fortipower.github.io' -visibility:$false
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress1
            $address.name | Should -Be $pester_proxyaddress1
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "host-regex"
            $address.host | Should -BeNullOrEmpty
            $address.'host-regex' | Should -Be "fortipower.github.io"
            $address.path | Should -BeNullOrEmpty
            $address.method | Should -BeNullOrEmpty
            $address.comment | Should -BeNullorEmpty
            $address.visibility | Should -Be "disable"
        }

        It "Try to Add Address $pester_proxyaddress1 (but there is already a object with same name)" {
            #Add first address
            Add-FGTFirewallProxyAddress -name $pester_proxyaddress1 -hostregex 'fortipower.github.io'
            #Add Second address with same name
            { Add-FGTFirewallProxyAddress -name $pester_proxyaddress1 -hostregex 'fortipower.github.io' } | Should -Throw "Already a ProxyAddress object using the same name"
        }

    }

    Context "method" {

        BeforeAll {
            Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        }

        AfterEach {
            Get-FGTFirewallProxyAddress -name $pester_proxyaddress2 | Remove-FGTFirewallProxyAddress -confirm:$false
        }

        It "Add Address $pester_proxyaddress2 (type method)" {
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method get -hostObjectName $pester_address1
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
            $address.name | Should -Be $pester_proxyaddress2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "method"
            $address.host | Should -Be $pester_address1
            $address.'host-regex' | Should -BeNullOrEmpty
            $address.path | Should -BeNullOrEmpty
            $address.method | Should -Be "get"
            $address.comment | Should -BeNullorEmpty
            $address.visibility | Should -Be $true
        }

        It "Add Address $pester_proxyaddress2 (type method and comment)" {
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method get -hostObjectName $pester_address1 -comment "Add via PowerFGT"
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
            $address.name | Should -Be $pester_proxyaddress2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "method"
            $address.host | Should -Be $pester_address1
            $address.'host-regex' | Should -BeNullOrEmpty
            $address.path | Should -BeNullOrEmpty
            $address.method | Should -Be "get"
            $address.comment | Should -Be "Add via PowerFGT"
            $address.visibility | Should -Be $true
        }

        It "Add Address $pester_proxyaddress2 (type method and visiblity disable)" {
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method get -hostObjectName $pester_address1 -visibility:$false
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
            $address.name | Should -Be $pester_proxyaddress2
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "method"
            $address.host | Should -Be $pester_address1
            $address.'host-regex' | Should -BeNullOrEmpty
            $address.path | Should -BeNullOrEmpty
            $address.method | Should -Be "get"
            $address.comment | Should -BeNullOrEmpty
            $address.visibility | Should -Be "disable"
        }

        It "Try to Add Address $pester_proxyaddress2 (but there is already a object with same name)" {
            #Add first address
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method get -hostObjectName $pester_address1
            #Add Second address with same name
            { Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method get -hostObjectName $pester_address1 } | Should -Throw "Already a ProxyAddress object using the same name"
        }

        Context "Method type" {

            It "Add Address $pester_proxyaddress2 (type method connect)" {
                Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method connect -hostObjectName $pester_address1
                $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
                $address.name | Should -Be $pester_proxyaddress2
                $address.uuid | Should -Not -BeNullOrEmpty
                $address.type | Should -Be "method"
                $address.host | Should -Be $pester_address1
                $address.'host-regex' | Should -BeNullOrEmpty
                $address.path | Should -BeNullOrEmpty
                $address.method | Should -Be "connect"
                $address.comment | Should -BeNullorEmpty
                $address.visibility | Should -Be $true
            }

            It "Add Address $pester_proxyaddress2 (type method delete)" {
                Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method delete -hostObjectName $pester_address1
                $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
                $address.name | Should -Be $pester_proxyaddress2
                $address.uuid | Should -Not -BeNullOrEmpty
                $address.type | Should -Be "method"
                $address.host | Should -Be $pester_address1
                $address.'host-regex' | Should -BeNullOrEmpty
                $address.path | Should -BeNullOrEmpty
                $address.method | Should -Be "delete"
                $address.comment | Should -BeNullorEmpty
                $address.visibility | Should -Be $true
            }

            It "Add Address $pester_proxyaddress2 (type method get)" {
                Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method get -hostObjectName $pester_address1
                $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
                $address.name | Should -Be $pester_proxyaddress2
                $address.uuid | Should -Not -BeNullOrEmpty
                $address.type | Should -Be "method"
                $address.host | Should -Be $pester_address1
                $address.'host-regex' | Should -BeNullOrEmpty
                $address.path | Should -BeNullOrEmpty
                $address.method | Should -Be "get"
                $address.comment | Should -BeNullorEmpty
                $address.visibility | Should -Be $true
            }

            It "Add Address $pester_proxyaddress2 (type method head)" {
                Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method head -hostObjectName $pester_address1
                $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
                $address.name | Should -Be $pester_proxyaddress2
                $address.uuid | Should -Not -BeNullOrEmpty
                $address.type | Should -Be "method"
                $address.host | Should -Be $pester_address1
                $address.'host-regex' | Should -BeNullOrEmpty
                $address.path | Should -BeNullOrEmpty
                $address.method | Should -Be "head"
                $address.comment | Should -BeNullorEmpty
                $address.visibility | Should -Be $true
            }

            It "Add Address $pester_proxyaddress2 (type method options)" {
                Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method options -hostObjectName $pester_address1
                $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
                $address.name | Should -Be $pester_proxyaddress2
                $address.uuid | Should -Not -BeNullOrEmpty
                $address.type | Should -Be "method"
                $address.host | Should -Be $pester_address1
                $address.'host-regex' | Should -BeNullOrEmpty
                $address.path | Should -BeNullOrEmpty
                $address.method | Should -Be "options"
                $address.comment | Should -BeNullorEmpty
                $address.visibility | Should -Be $true
            }

            It "Add Address $pester_proxyaddress2 (type method post)" {
                Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method post -hostObjectName $pester_address1
                $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
                $address.name | Should -Be $pester_proxyaddress2
                $address.uuid | Should -Not -BeNullOrEmpty
                $address.type | Should -Be "method"
                $address.host | Should -Be $pester_address1
                $address.'host-regex' | Should -BeNullOrEmpty
                $address.path | Should -BeNullOrEmpty
                $address.method | Should -Be "post"
                $address.comment | Should -BeNullorEmpty
                $address.visibility | Should -Be $true
            }

            It "Add Address $pester_proxyaddress2 (type method put)" {
                Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method put -hostObjectName $pester_address1
                $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
                $address.name | Should -Be $pester_proxyaddress2
                $address.uuid | Should -Not -BeNullOrEmpty
                $address.type | Should -Be "method"
                $address.host | Should -Be $pester_address1
                $address.'host-regex' | Should -BeNullOrEmpty
                $address.path | Should -BeNullOrEmpty
                $address.method | Should -Be "put"
                $address.comment | Should -BeNullorEmpty
                $address.visibility | Should -Be $true
            }

            It "Add Address $pester_proxyaddress2 (typemethod trace)" {
                Add-FGTFirewallProxyAddress -Name $pester_proxyaddress2 -method trace -hostObjectName $pester_address1
                $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress2
                $address.name | Should -Be $pester_proxyaddress2
                $address.uuid | Should -Not -BeNullOrEmpty
                $address.type | Should -Be "method"
                $address.host | Should -Be $pester_address1
                $address.'host-regex' | Should -BeNullOrEmpty
                $address.path | Should -BeNullOrEmpty
                $address.method | Should -Be "trace"
                $address.comment | Should -BeNullorEmpty
                $address.visibility | Should -Be $true
            }

        }

        AfterAll {
            #Remove also Firewall Address (FQDN)
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        }

    }

    Context "url" {

        BeforeAll {
            Add-FGTFirewallAddress -name $pester_address1 -fqdn 'fortipower.github.io'
        }

        AfterEach {
            Get-FGTFirewallProxyAddress -name $pester_proxyaddress3 | Remove-FGTFirewallProxyAddress -confirm:$false
        }

        It "Add Address $pester_proxyaddress3  (type url)" {
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress3 -hostObjectName $pester_address1 -path "/PowerFGT"
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress3
            $address.name | Should -Be $pester_proxyaddress3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "url"
            $address.host | Should -Be $pester_address1
            $address.'host-regex' | Should -BeNullOrEmpty
            $address.path | Should -Be "/PowerFGT"
            $address.method | Should -BeNullOrEmpty
            $address.comment | Should -BeNullorEmpty
            $address.visibility | Should -Be $true
        }

        It "Add Address $pester_proxyaddress3  (type method and comment)" {
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress3 -hostObjectName $pester_address1 -path "/PowerFGT" -comment "Add via PowerFGT"
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress3
            $address.name | Should -Be $pester_proxyaddress3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "url"
            $address.host | Should -Be $pester_address1
            $address.'host-regex' | Should -BeNullOrEmpty
            $address.path | Should -Be "/PowerFGT"
            $address.method | Should  -BeNullOrEmpty
            $address.comment | Should -Be "Add via PowerFGT"
            $address.visibility | Should -Be $true
        }

        It "Add Address $pester_proxyaddress3  (type method and visiblity disable)" {
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress3 -hostObjectName $pester_address1 -path "/PowerFGT" -visibility:$false
            $address = Get-FGTFirewallProxyAddress -name $pester_proxyaddress3
            $address.name | Should -Be $pester_proxyaddress3
            $address.uuid | Should -Not -BeNullOrEmpty
            $address.type | Should -Be "url"
            $address.host | Should -Be $pester_address1
            $address.'host-regex' | Should -BeNullOrEmpty
            $address.path | Should -Be "/PowerFGT"
            $address.method | Should -BeNullOrEmpty
            $address.comment | Should -BeNullOrEmpty
            $address.visibility | Should -Be "disable"
        }

        It "Try to Add Address $pester_proxyaddress3  (but there is already a object with same name)" {
            #Add first address
            Add-FGTFirewallProxyAddress -Name $pester_proxyaddress3 -method get -hostObjectName $pester_address1
            #Add Second address with same name
            { Add-FGTFirewallProxyAddress -Name $pester_proxyaddress3 -method get -hostObjectName $pester_address1 } | Should -Throw "Already a ProxyAddress object using the same name"
        }

        AfterAll {
            #Remove also Firewall Address (FQDN)
            Get-FGTFirewallAddress -name $pester_address1 | Remove-FGTFirewallAddress -confirm:$false
        }

    }
}

Disconnect-FGT -confirm:$false
