#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemDnsServer {

    <#
        .SYNOPSIS
        Get DNS Server configured

        .DESCRIPTION
        Show DNS Server configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDnsServer

        Display DNS Server configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDnsServer -filter_attribute mode -filter_value forward-only

        Get System DNS Server with mode (DNS) equal forward-only

        .EXAMPLE
        Get-FGTSystemDnsServer -filter_attribute mode -filter_value forward -filter_type contains

        Get System Server DNS with mode  contains forward

        .EXAMPLE
        Get-FGTSystemDnsServer -skip

        Display DNS Server configured on the FortiGate (but only relevant attributes)

        EXAMPLE
        Get-FGTSystemDnsServer -vdom vdomX

        Display DNS Server configured on the FortiGate on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/dns-server' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}