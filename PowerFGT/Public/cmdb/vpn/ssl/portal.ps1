#
# Copyright, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTVpnSSLPortal {

    <#
        .SYNOPSIS
        Get list of all VPN SSL Portal settings

        .DESCRIPTION
        Get list of all VPN SSL Portal (name, interface, server ...)

        .EXAMPLE
        Get-FGTVpnSSLPortal

        Get list of all settings of VPN SSL Portal

        .EXAMPLE
        Get-FGTVpnSSLPortal -name myVpnSSLPortal

        Get VPN SSL Portal named myVpnSSLPortal

        .EXAMPLE
        Get-FGTVpnSSLPortal -name FGT -filter_type contains

        Get VPN SSL Portal contains with *FGT*

        .EXAMPLE
        Get-FGTVpnSSLPortal -skip

        Get list of all settings of VPN SSL Portal (but only relevant attributes)

        .EXAMPLE
        Get-FGTVpnSSLPortal -vdom vdomX

        Get list of all settings of VPN SSL Portal on vdomX
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

        $uri = 'api/v2/cmdb/vpn.ssl.web/portal'

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

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
