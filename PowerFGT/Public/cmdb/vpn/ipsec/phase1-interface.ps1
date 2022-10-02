#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-FGTVpnIpsecPhase1Interface {

    <#
        .SYNOPSIS
        Add a Vpn IPsec Phase 1 Interface

        .DESCRIPTION
        Add an Vpn IPsec Phase 1 Interface (Version, type, interface, proposal, psksecret... )

        .EXAMPLE
        Add-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN -type static -interface port2 -proposal aes256-sha256 -psksecret MySecret -remotegw 192.0.2.1

        Create a static VPN IPsec Phase 1 Interface named PowerFGT_VPN with interface port2, proposal aes256-sha256 with Remote Gateway 192.0.2.1

        .EXAMPLE
        Add-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN -type dynamic -interface port2 -proposal aes256-sha256, aes256-sha512 -dhgrp 14,15 -psksecret MySecret

        Create a dynamic VPN IPsec Phase 1 Interface named PowerFGT_VPN with interface port2, multiple proposal aes256-sha256, aes256-sha512 and DH Group 14 & 15

    #>
    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [ValidateLength(1, 15)]
        [string]$name,
        [Parameter (Mandatory = $true)]
        [ValidateSet('static', 'dynamic', IgnoreCase = $false)]
        [string]$type,
        [Parameter (Mandatory = $true)]
        [string]$interface,
        [Parameter (Mandatory = $false)]
        [ValidateSet('1', '2')]
        [string]$ikeversion,
        [Parameter (Mandatory = $true)]
        [string[]]$proposal,
        [Parameter (Mandatory = $false)]
        [int[]]$dhgrp,
        [ValidateSet(1, 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 27, 28, 29, 30, 31, 32)]
        [Parameter (Mandatory = $true)]
        [string]$psksecret,
        [Parameter (Mandatory = $false)]
        [string]$remotegw,
        [Parameter (Mandatory = $false)]
        [ValidateSet('any', 'one', 'dialup', 'peer', 'peergrp', IgnoreCase = $false)]
        [string]$peertype,
        [Parameter (Mandatory = $false)]
        [switch]$netdevice,
        [Parameter (Mandatory = $false)]
        [switch]$addroute,
        [Parameter (Mandatory = $false)]
        [switch]$autodiscoverysender,
        [Parameter (Mandatory = $false)]
        [switch]$autodiscoveryreceiver,
        [Parameter (Mandatory = $false)]
        [switch]$exchangeinterfaceip,
        [Parameter (Mandatory = $false)]
        [int]$networkid,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/vpn.ipsec/phase1-interface"
        $_interface = new-Object -TypeName PSObject

        $_interface | add-member -name "name" -membertype NoteProperty -Value $name

        $_interface | add-member -name "type" -membertype NoteProperty -Value $type
        $_interface | add-member -name "interface" -membertype NoteProperty -Value $interface
        $_interface | add-member -name "proposal" -membertype NoteProperty -Value $proposal
        $_interface | add-member -name "psksecret" -membertype NoteProperty -Value $psksecret

        if ( $PsBoundParameters.ContainsKey('ikeversion') ) {
            $_interface | add-member -name "ikeversion" -membertype NoteProperty -Value $ikeversion
        }

        if ( $type -eq "static" -and $PsBoundParameters.ContainsKey('remotegw') ) {
            $_interface | add-member -name "remote-gw" -membertype NoteProperty -Value $remotegw
        }
        else {
            throw "You need to specify the remote-gw when use type static"
        }

        if ( $PsBoundParameters.ContainsKey('peertype') ) {
            $_interface | add-member -name "peertype" -membertype NoteProperty -Value $peertype
        }

        if ( $PsBoundParameters.ContainsKey('dhgrp') ) {
            $_interface | add-member -name "dhgrp" -membertype NoteProperty -Value $dhgrp
        }

        if ( $PsBoundParameters.ContainsKey('netdevice') ) {
            if ($netdevice) {
                $_interface | Add-member -name "net-device" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "net-device" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('addroute') ) {
            if ($addroute) {
                $_interface | Add-member -name "add-route" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "add-route" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('autodiscoverysender') ) {
            if ($autodiscoverysender) {
                $_interface | Add-member -name "auto-discovery-sender" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "auto-discovery-sender" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('autodiscoveryreceiver') ) {
            if ($autodiscoveryreceiver) {
                $_interface | Add-member -name "auto-discovery-receiver" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "auto-discovery-receiver" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $PsBoundParameters.ContainsKey('exchangeinterfaceip') ) {
            if ($exchangeinterfaceip) {
                $_interface | Add-member -name "exchange-interface-ip" -membertype NoteProperty -Value "enable"
            }
            else {
                $_interface | Add-member -name "exchange-interface-ip" -membertype NoteProperty -Value "disable"
            }
        }

        if ( $ikeversion -eq "2" -and $PsBoundParameters.ContainsKey('networkid') ) {
            $_interface | Add-member -name "network-overlay" -membertype NoteProperty -Value "enable"
            $_interface | Add-member -name "network-id" -membertype NoteProperty -Value $networkid
        }
        else {
            Throw "Need to set ikeversion 2 to use networkid"
        }

        $null = Invoke-FGTRestMethod -uri $uri -method 'POST' -body $_interface -connection $connection @invokeParams

        Get-FGTVpnIpsecPhase1Interface -name $name -connection $connection @invokeParams
    }

    End {
    }
}

function Get-FGTVpnIpsecPhase1Interface {

    <#
        .SYNOPSIS
        Get list of all VPN IPsec phase 1 (ISAKMP) settings

        .DESCRIPTION
        Get list of all VPN IPsec phase 1 (name, IP Address, description, pre shared key ...)

        .EXAMPLE
        Get-FGTVpnIPsecPhase1Interface

        Get list of all settings of VPN IPsec Phase 1 interface

        .EXAMPLE
        Get-FGTVpnIPsecPhase1Interface -name myVPNIPsecPhase1interface

        Get VPN IPsec Phase 1 interface named myVPNIPsecPhase1interface

        .EXAMPLE
        Get-FGTVpnIPsecPhase1Interface -name myVPNIPsecPhase1interface -plaintext_password

        Get VPN IPsec Phase 1 interface named myVPNIPsecPhase1interface with Plain Text Password

        .EXAMPLE
        Get-FGTVpnIPsecPhase1Interface -name FGT -filter_type contains

        Get VPN IPsec Phase 1 interface contains with *FGT*

        .EXAMPLE
        Get-FGTVpnIPsecPhase1Interface -skip

        Get list of all settings of VPN IPsec Phase 1 interface (but only relevant attributes)

        .EXAMPLE
        Get-FGTVpnIPsecPhase1Interface -vdom vdomX

        Get list of all settings of VPN IPsec Phase 1 interface on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false)]
        [switch]$plaintext_password,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "name")]
        [Parameter (ParameterSetName = "filter")]
        [ValidateSet('equal', 'contains')]
        [string]$filter_type = "equal",
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [psobject]$filter_value,
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v2/cmdb/vpn.ipsec/phase1-interface'

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        #Filtering
        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        if ( $PsBoundParameters.ContainsKey('plaintext_password') ) {
            if ($plaintext_password) {
                $uri += "?plain-text-password=1"
            }
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}

function Remove-FGTVpnIpsecPhase1Interface {

    <#
        .SYNOPSIS
        Remove a Vpn IPsec Phase 1 Interface

        .DESCRIPTION
        Remove a Vpn IPsec Phase 1 Interface

        .EXAMPLE
        Get-FGTVpnIpsecPhase1Interface -name PowerFGT_VPN | Remove-FGTVpnIpsecPhase1Interface

        Removes the Vpn IPsec Phase 1 Interface PowerFGT_VPN which was retrieved with Get-FGTVpnIpsecPhase1Interface

        .EXAMPLE
        Get-FGTVpnIpsecPhase1Interfacee -name PowerFGT_VPN | Remove-FGTVpnIpsecPhase1Interfacee -Confirm:$false

        Removes the Vpn IPsec Phase 1 Interface PowerFGT_VPN and suppresses the confirmation question
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateScript( { Confirm-FGTVpnIpsecPhase1Interface $_ })]
        [psobject]$interface,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/cmdb/vpn.ipsec/phase1-interface/$($interface.name)"

        if ($PSCmdlet.ShouldProcess($interface.name, 'Remove Vpn IPsec Phase 1 Interface')) {
            $null = Invoke-FGTRestMethod -uri $uri -method 'DELETE' -connection $connection @invokeParams
        }
    }

    End {
    }
}