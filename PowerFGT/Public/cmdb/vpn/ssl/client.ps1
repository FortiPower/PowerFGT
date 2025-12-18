#
# Copyright, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTVpnSSLClient {

    <#
        .SYNOPSIS
        Get list of all VPN SSL Client settings

        .DESCRIPTION
        Get list of all VPN SSL Client (name, interface, server ...)

        .EXAMPLE
        Get-FGTVpnSSLClient

        Get list of all settings of VPN SSL Client

        .EXAMPLE
        Get-FGTVpnSSLClient -name myVpnSSLClient

        Get VPN SSL Client named myVpnSSLClient

        .EXAMPLE
        Get-FGTVpnSSLClient -name FGT -filter_type contains

        Get VPN SSL Client contains with *FGT*

        .EXAMPLE
        Get-FGTVpnSSLClient -meta

        Get list of all settings of VPN SSL Client with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTVpnSSLClient -skip

        Get list of all settings of VPN SSL Client (but only relevant attributes)

        .EXAMPLE
        Get-FGTVPNSSLClient -schema

        Get schema of VPN SSL Client

        .EXAMPLE
        Get-FGTVpnSSLClient -vdom vdomX

        Get list of all settings of VPN SSL Client on vdomX
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
        [switch]$meta,
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false, ParameterSetName = "schema")]
        [switch]$schema,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v2/cmdb/vpn.ssl/client'

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('meta') ) {
            $invokeParams.add( 'meta', $meta )
        }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'extra', "&action=schema" )
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

        #before 7.0.x, it is not available !
        if ($connection.version -lt "7.0.0") {
            Throw "VPN SSL Client is not available before FortiOS 7.0.x"
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
