#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTWirelessWTP {

    <#
        .SYNOPSIS
        Get list of Wireless WTP (Wireless Termination Points) Settings

        .DESCRIPTION
        Get list of Wireless WTP (Wireless Termination Points) Settings (wtp-id, name, location ...)

        .EXAMPLE
        Get-FGTWirelessVAP

        Get list of Wireless WTP (Wireless Termination Points) object

        .EXAMPLE
        Get-FGTWirelessVAP -name MyVAP

        Get list of Wireless WTP (Wireless Termination Points) object named MyVAP

        .EXAMPLE
        Get-FGTWirelessVAP -meta

        Get list of Wireless WTP (Wireless Termination Points) object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTWirelessVAP -skip

        Get list of Wireless WTP (Wireless Termination Points) object (but only relevant attributes)

        .EXAMPLE
        Get-FGTWirelessVAP -vdom vdomX

        Get list of Wireless WTP (Wireless Termination Points) object on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/wireless-controller/wtp' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
