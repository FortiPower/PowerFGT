#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorRouterIPv4 {

    <#
        .SYNOPSIS
        Get Router IPv4

        .DESCRIPTION
        List all active IPv4 routing table entries (type, IP/Mask, gateway, interface...)

        .EXAMPLE
        Get-FGTMonitorRouterIPv4

        Get ALL Router IPv4 Monitor

        .EXAMPLE
        Get-FGTMonitorRouterIPv4 -vdom vdomX

        Get Router IPv4 monitor of vdomX

    #>

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

        $uri = 'api/v2/monitor/router/ipv4'

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
