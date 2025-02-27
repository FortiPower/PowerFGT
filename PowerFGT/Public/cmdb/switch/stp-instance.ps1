#
# Copyright 2024, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSwitchSTPInstance {

    <#
        .SYNOPSIS
        Get list of STP Instance

        .DESCRIPTION
        Get list of STP Instance (id , vlan-range ...)

        .EXAMPLE
        Get-FGTSwitchSTPInstance

        Get list of STP Instance objects

        .EXAMPLE
        Get-FGTSwitchSTPInstance -id MySTPInstance

        Get STP Instance object named MySTPInstance

        .EXAMPLE
        Get-FGTSwitchSTPInstance -meta

        Get list of STP Instance object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTSwitchSTPInstance -skip

        Get list of STP Instance object (but only relevant attributes)

        .EXAMPLE
        Get-FGTSwitchSTPInstance -vdom vdomX

        Get list of STP Instance object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "id")]
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

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/switch-controller/stp-instance' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
