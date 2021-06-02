#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
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
