#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorVpnIPsec {

    <#
        .SYNOPSIS
        Get VPN IPsec

        .DESCRIPTION
        Get VPN IPsec

        .EXAMPLE
        Get-FGTMonitorVpnIPsec

        Get VPN IPsec (name, incoming_bytes, outgoing_bytes, rgwy...)

        .EXAMPLE
        Get-FGTMonitorVpnIPsec -vdom vdomX

        Get VPN IPsec monitor of vdomX

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

        $uri = 'api/v2/monitor/vpn/ipsec'

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
