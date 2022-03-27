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
        Get-FGTMonitorRouterIPv4 -ip_mask 192.0.2.0/24

        Get Router IPv4 Monitor where IP/MASK is 192.0.2.0/24

        .EXAMPLE
        Get-FGTMonitorRouterIPv4 -gateway 192.0.2.1

        Get Router IPv4 Monitor where Gateway is 192.0.2.1

        .EXAMPLE
        Get-FGTMonitorRouterIPv4 -type connected

        Get Router IPv4 Monitor with type is connected

        .EXAMPLE
        Get-FGTMonitorRouterIPv4 -interface port1

        Get Router IPv4 Monitor where interface is port1

        .EXAMPLE
        Get-FGTMonitorRouterIPv4 -vdom vdomX

        Get Router IPv4 monitor of vdomX

    #>

    Param(
        [Parameter (Mandatory = $false)]
        [string]$ip_mask,
        [Parameter (Mandatory = $false)]
        [string]$gateway,
        [Parameter (Mandatory = $false)]
        [ValidateSet('def', 'kernel', 'connect', 'static', 'rip', 'ripng', 'ospf', 'ospf6', 'bgp', 'isis', 'ha')]
        [string]$type,
        [Parameter (Mandatory = $false)]
        [string]$interface,
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

        $uri = 'api/v2/monitor/router/ipv4?'


        if ( $PsBoundParameters.ContainsKey('ip_mask') ) {
            $uri += "&ip_mask=$ip_mask"
        }

        if ( $PsBoundParameters.ContainsKey('gateway') ) {
            $uri += "&gateway=$gateway"
        }

        if ( $PsBoundParameters.ContainsKey('type') ) {
            $uri += "&type=$type"
        }

        if ( $PsBoundParameters.ContainsKey('interface') ) {
            $uri += "&interface=$interface"
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
