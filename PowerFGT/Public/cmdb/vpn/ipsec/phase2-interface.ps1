#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#


function Get-FGTVpnIpsecPhase2Interface {

    <#
        .SYNOPSIS
        Get list of all VPN IPsec phase 2 (IKE) settings

        .DESCRIPTION
        Get list of all VPN IPsec phase 2 (Local / Remote Network PFS, Cipher, Hash...)

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface

        Get list of all settings of VPN IPsec Phase 2 interface

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -name myVPNIPsecPhase2interface

        Get VPN IPsec Phase 2 interface named myVPNIPsecPhase2interface

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -name FGT -filter_type contains

        Get VPN IPsec Phase 2 interface contains with *FGT*

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -skip

        Get list of all settings of VPN IPsec Phase 2 interface (but only relevant attributes)

        .EXAMPLE
        Get-FGTVpnIPsecPhase2Interface -vdom vdomX

        Get list of all settings of VPN IPsec Phase 2 interface on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/vpn.ipsec/phase2-interface' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
