#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemSDWAN {

    <#
        .SYNOPSIS
        Get SD-WAN Settings

        .DESCRIPTION
        Get SD-WAN (status, load balance mode, members, health-check... )

        .EXAMPLE
        Get-FGTSystemSDWAN

        Get SD-WAN  Settings

        .EXAMPLE
        Get-FGTSystemSDWAN -filter_attribute status -filter_value enable

        Get SD-WAN with mode equal standalone

        .EXAMPLE
        Get-FGTSystemSDWAN -filter_attribute load-balance-mode -filter_value ip -filter_type contains

        Get SD-WAN with load-balance-modecontains ip

        .EXAMPLE
        Get-FGTSystemSDWAN -skip

        Get SD-WAN Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemSDWAN -schema

        Get schema of System SDWAN

        .EXAMPLE
        Get-FGTSystemSDWAN -vdom vdomX

        Get SD-WAN Settings on vdomX
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

        $uri = 'api/v2/cmdb/system/sdwan'

        $invokeParams = @{ }
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
        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        #before 6.4.x, it is not available need to use Virtual WAN Link
        if ($connection.version -lt "6.4.0") {
            Throw "Please use Get-FGTSystemVirtualWANLink, SD-WAN is not available before FortiOS 6.4.x"
        }

        $reponse = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}