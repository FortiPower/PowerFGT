#
# Copyright 2024, Cedric Moreau <moreaucedric0 at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorSystemInterfaceDHCPStatus {

    <#
        .SYNOPSIS
        Get Interface DHCP Status

        .DESCRIPTION
        Get Client DHCP Status for an interface

        .EXAMPLE
        Get-FGTMonitorSystemInterfaceDHCPStatus -interface wan

        Get DHCP Client status for the specified interface wan

    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$interface,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = "api/v2/monitor/system/interface/dhcp-status?mkey=$($interface)"
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
