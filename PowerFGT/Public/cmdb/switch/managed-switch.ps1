#
# Copyright 2024, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSwitchManagedSwitch {

    <#
        .SYNOPSIS
        Get list of Managed Switches

        .DESCRIPTION
        Get list of Managed Switches (name, switch_id, serial, status, ...)

        .EXAMPLE
        Get-FGTSwitchManagedSwitch

        Get list of Managed Switches objects

        .EXAMPLE
        Get-FGTSwitchManagedSwitch -switchid MyManagedSwitch

        Get Managed Switches object named MyManagedSwitch

        .EXAMPLE
        Get-FGTSwitchManagedSwitch -meta

        Get list of Managed Switches object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTSwitchManagedSwitch -skip

        Get list of Managed Switches object (but only relevant attributes)

        .EXAMPLE
        Get-FGTSwitchManagedSwitch -schema

        Get schema of Switch Managed Switch

        .EXAMPLE
        Get-FGTSwitchManagedSwitch -vdom vdomX

        Get list of Managed Switches object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "switchid")]
        [string]$switchid,
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
        switch ( $PSCmdlet.ParameterSetName ) {
            "switchid" {
                $filter_value = $switchid
                $filter_attribute = "switch-id"
            }
            default { }
        }

        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'extra', "&action=schema" )
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/switch-controller/managed-switch' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
