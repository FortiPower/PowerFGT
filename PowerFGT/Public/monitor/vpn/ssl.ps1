#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorVpnSsl {

    <#
        .SYNOPSIS
        Get VPN SSL

        .DESCRIPTION
        Get VPN SSL (and stats)

        .EXAMPLE
        Get-FGTMonitorVpnSsl

        Get VPN SSL (user_name, remote_host, last_login)

        .EXAMPLE
        Get-FGTMonitorVpnSsl -stats

        Get VPN SSL Stats (current, max user)
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$stats,
        [Parameter (Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [switch]$schema,
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
        if ( $PsBoundParameters.ContainsKey('schema') ) {
            $invokeParams.add( 'schema', $schema )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = 'api/v2/monitor/vpn/ssl'

        if ($stats) {
            $uri += "/stats"
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
