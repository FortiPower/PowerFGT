#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemDns {

    <#
        .SYNOPSIS
        Get DNS addresses configured

        .DESCRIPTION
        Show DNS addresses configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDns

        Display DNS configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDNS -filter_attribute primary -filter_value 192.0.2.1

        Get System DNS with primary (DNS) equal 192.0.2.1

        .EXAMPLE
        Get-FGTSystemDNS -filter_attribute domain -filter_value Fortinet -filter_type contains

        Get System DNS with domain contains Fortinet

        .EXAMPLE
        Get-FGTSystemDns -skip

        Display DNS configured on the FortiGate (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemDns -vdom vdomX

        Display DNS configured on the FortiGate on vdomX

        .EXAMPLE
        Get-FGTSystemDns -schema

        Get schema of DNS object
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
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
        [switch]$schema,
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
        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'extra', '&action=schema' )
        }

        #Filtering
        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/dns' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}