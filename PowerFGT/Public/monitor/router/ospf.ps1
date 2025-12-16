#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorRouterOSPFNeighbors {

    <#
        .SYNOPSIS
        Get Router OSPF Neighbors

        .DESCRIPTION
        List all active discovered OSPF neighbors (ip, route-id, state, priority....)

        .EXAMPLE
        Get-FGTMonitorRouterOSPFNeighbors

        Get ALL Router OSPF Neighbors

        .EXAMPLE
        Get-FGTMonitorRouterOSPFNeighbors -vdom vdomX

        Get Router OSPF Neighbors monitor of vdomX

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

        #before 7.0.x, it is not available !
        if ($connection.version -lt "7.0.0") {
            Throw "Monitor Router OSPF Neighbors is not available before FortiOS 7.0.x"
        }

        $uri = 'api/v2/monitor/router/ospf/neighbors'

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
