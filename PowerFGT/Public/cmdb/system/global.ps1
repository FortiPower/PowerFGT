#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemGlobal {

    <#
        .SYNOPSIS
        Get list of System Global Settings

        .DESCRIPTION
        Get list of System Global Settings (hostname, alias....)

        .EXAMPLE
        Get-FGTSystemGlobal

        Get list of all System Global Settings

        .EXAMPLE
        Get-FGTSystemGlobal -filter_attribute admintimeout -filter_value 5

        Get System Global with admin timeout equal 5

        .EXAMPLE
        Get-FGTSystemGlobal -filter_attribute hostname -filter_value Fortinet -filter_type contains

        Get System Global with hostname contains Fortinet

        .EXAMPLE
        Get-FGTSystemGlobal -skip

        Get list of all System Global Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemGlobal -vdom vdomX

        Get list of all System Global Settings on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/global' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}