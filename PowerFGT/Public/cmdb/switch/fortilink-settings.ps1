#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSwitchFortilinkSettings {

    <#
        .SYNOPSIS
        Get list of Switch Fortilink Settings

        .DESCRIPTION
        Get list of Switch Fortilink Settings (Name, fortilink, ...)

        .EXAMPLE
        Get-FGTSwitchFortilinkSettings

        Get list of Switch Fortilink Settings object

        .EXAMPLE
        Get-FGTSwitchSettings -name MyFortilinkSettings

        Get list of Switch Fortilink Settings object named MyFortilinkSettings

        .EXAMPLE
        Get-FGTSwitchSettings -meta

        Get list of Switch Fortilink Settings object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTSwitchSettings -skip

        Get list of Switch Fortilink Settings object (but only relevant attributes)

        .EXAMPLE
        Get-FGTSwitchFortilinkSettings -schema

        Get schema of Switch Fortilink Settings object

        .EXAMPLE
        Get-FGTSwitchSettings -vdom vdomX

        Get list of Switch Fortilink Settings object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
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
        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'extra', '&action=schema' )
        }

        #Filtering
        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            default { }
        }

        #before 7.0.x, it is not available
        if ($connection.version -lt "7.0.0") {
            Throw "Switch Fortilink Settings is not available before Forti OS 7.0"
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/switch-controller/fortilink-settings' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
