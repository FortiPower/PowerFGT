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

        #before 6.4.x, it is not available
        if ($connection.version -lt "6.4.0") {
            Throw "Monitor Network ARP is no available before Forti OS 6.4"
        }

        $uri = 'api/v2/monitor/network/arp'
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
