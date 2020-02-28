#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemHA {

    <#
        .SYNOPSIS
        Get list of HA Settings

        .DESCRIPTION
        Get list of HA Settings (Mode, Group-ID, Group-Name, Password, monitor...)

        .EXAMPLE
        Get-FGTSystemHA

        Get HA Settings

        .EXAMPLE
        Get-FGTSystemHA -filter_attribute mode -filter_value standalone

        Get HA with mode equal standalone

        .EXAMPLE
        Get-FGTSystemHA -filter_attribute group_name -filter_value Fortinet -filter_type contains

        Get HA with group_name contains Fortinet

        .EXAMPLE
        Get-FGTSystemHA -skip

        Get HA Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemHA -vdom vdomX

        Get HA Settings on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/ha' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}