#
# Copyright 2024, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSwitchSNMPCommunity {

    <#
        .SYNOPSIS
        Get list of SNMP Community

        .DESCRIPTION
        Get list of SNMP Community (name, id, status, hots ...)

        .EXAMPLE
        Get-FGTSwitchSNMPCommunity

        Get list of SNMP Community objects

        .EXAMPLE
        Get-FGTSwitchSNMPCommunity -id MySNMPCommunity

        Get SNMP Community object named MySNMPCommunity

        .EXAMPLE
        Get-FGTSwitchSNMPCommunity -meta

        Get list of SNMP Community object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTSwitchSNMPCommunity -skip

        Get list of SNMP Community object (but only relevant attributes)

        .EXAMPLE
        Get-FGTSwitchSNMPCommunity -vdom vdomX

        Get list of SNMP Community object on vdomX
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
            "id" {
                $filter_value = $id
                $filter_attribute = "id"
            }
            default { }
        }

        #before 6.2.x, it is not available
        if ($connection.version -lt "6.2.0") {
            Throw "Switch SNMP Community is not available before Forti OS 6.2"
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/switch-controller/snmp-community' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
