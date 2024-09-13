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
        Get Client DHCP Status for an interface (Fortiguard, forticare....)

        .EXAMPLE
        Get-FGTMonitorSystemInterfaceDHCPStatus

        Get License Status with status, version and last_update

    #>

    Param(
        [Parameter (Mandatory = $true, Position = 1)]
        [string]$interface,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = "api/v2/monitor/system/interface/dhcp-status?mkey=$($interface)"
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
