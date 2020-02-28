#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTRouterPolicy {

    <#
        .SYNOPSIS
        Get list of all "route policy"

        .DESCRIPTION
        Get list of all "route policy" (Source, Destination, Protocol, Action...)

        .EXAMPLE
        Get-FGTRouterPolicy

        Get list of all route policy object

        .EXAMPLE
        Get-FGTRouterPolicy -filter_attribute gateway -filter_value 192.2.0.1

        Get route policy object with gateway equal 192.2.0.1

        .EXAMPLE
        Get-FGTRouterPolicy -filter_attribute device -filter_value vlan -filter_type contains

        Get route policy bject with device contains port

        .EXAMPLE
        Get-FGTRouterPolicy -skip

        Get list of all route policy object (but only relevant attributes)

        .EXAMPLE
        Get-FGTRouterPolicy -vdom vdomX

        Get list of all route policy object on vdomX
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
        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/policy' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
