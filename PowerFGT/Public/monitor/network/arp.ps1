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

        .EXAMPLE
        Get-FGTMonitorNetworkARP -vdom vdomX

        Get Network ARP of vdomX

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        #before 6.4.x, it is not available
        if ($connection.version -lt "6.4.0") {
            Throw "Monitor Network ARP is not available before Forti OS 6.4"
        }

        $uri = 'api/v2/monitor/network/arp'
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
