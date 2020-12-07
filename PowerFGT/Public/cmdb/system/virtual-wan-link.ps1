#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemVirtualWANLink {

    <#
        .SYNOPSIS
        Get Virtual Wan Link (SD-WAN) Settings

        .DESCRIPTION
        Get Virtual Wan Link Settings (status, load balance mode, members, health-check... )

        .EXAMPLE
        Get-FGTSystemVirtualWANLink

        Get Virtual Wan Link Settings

        .EXAMPLE
        Get-FGTSystemVirtualWANLink -filter_attribute status -filter_value enable

        Get Virtual Wan Link with mode equal standalone

        .EXAMPLE
        Get-FGTSystemVirtualWANLink -filter_attribute load-balance-mode -filter_value ip -filter_type contains

        Get Virtual Wan Link with load-balance-modecontains ip

        .EXAMPLE
        Get-FGTSystemVirtualWANLink -skip

        Get Virtual Wan Link Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemVirtualWANLink -vdom vdomX

        Get Virtual Wan Link Settings on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/virtual-wan-link' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}