#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemDHCPServer {

    <#
        .SYNOPSIS
        Get DHCP Server configured

        .DESCRIPTION
        Show DHCP Server configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDHCPServer

        Display DHCP Server configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDHCPServer -filter_attribute 'default-gateway' -filter_value 92.2.0.254

        Get System DHCP Server with default-gateway equal 192.2.0.254

        .EXAMPLE
        Get-FGTSystemDHCPServer -filter_attribute domain -filter_value PowerFGT -filter_type contains

        Get System Server DHCP with domain contains PowerFGT

        .EXAMPLE
        Get-FGTSystemDHCPServer -meta

        Display DHCP Server configured on the FortiGate with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTSystemDHCPServer -skip

        Display DHCP Server configured on the FortiGate (but only relevant attributes)

        EXAMPLE
        Get-FGTSystemDHCPServer -vdom vdomX

        Display DHCP Server configured on the FortiGate on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
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
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

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

        #Filtering
        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system.dhcp/server' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}