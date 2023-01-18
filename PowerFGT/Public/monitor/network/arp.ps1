#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorNetworkARP {

    <#
        .SYNOPSIS
        Get Network ARP

        .DESCRIPTION
        Get Network ARP

        .EXAMPLE
        Get-FGTMonitorNetworkARP

        Get Network ARP

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v2/monitor/network/arp'
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
