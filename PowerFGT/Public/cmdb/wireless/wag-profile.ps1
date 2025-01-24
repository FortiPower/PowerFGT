#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTWirelessWAGProfile {

    <#
        .SYNOPSIS
        Get list of Wireless WAG (Wireless Access Gateway) Profile Settings

        .DESCRIPTION
        Get list of Wireless WAG (Wireless Access Gateway) Profile Settings (Name, SSID, Security ...)

        .EXAMPLE
        Get-FGTWirelessWAGProfile

        Get list of Wireless WAG (Wireless Access Gateway) Profile object

        .EXAMPLE
        Get-FGTWirelessWAGProfile -name MyWAGProfile

        Get list of Wireless WAG (Wireless Access Gateway) Profile object named MyWAGProfile

        .EXAMPLE
        Get-FGTWirelessWAGProfile -meta

        Get list of Wireless WAG (Wireless Access Gateway) Profile object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTWirelessWAGProfile -skip

        Get list of Wireless WAG (Wireless Access Gateway) Profile object (but only relevant attributes)

        .EXAMPLE
        Get-FGTWirelessWAGProfile -vdom vdomX

        Get list of Wireless WAG (Wireless Access Gateway) Profile object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
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
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/wireless-controller/wag-profile' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
