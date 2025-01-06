#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorRouterBGPNeighbors {

    <#
        .SYNOPSIS
        Get Router BGP Neighbors

        .DESCRIPTION
        List all active discovered BGP neighbors (neighbor_ip, remote_as, state....)

        .EXAMPLE
        Get-FGTMonitorRouterBGPNeighbors

        Get ALL Router BGP Neighbors

        .EXAMPLE
        Get-FGTMonitorRouterBGPNeighbors -vdom vdomX

        Get Router BGP Neighbors monitor of vdomX

    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    Param(
        [Parameter (Mandatory = $false)]
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

        $uri = 'api/v2/monitor/router/bgp/neighbors'

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
