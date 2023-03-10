#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorFirewallSession {

    <#
        .SYNOPSIS
        Get Monitor Firewall Session

        .DESCRIPTION
        Get Monitor Firewall Session (proto, source/destination IP/Port, policyid ...)

        .EXAMPLE
        Get-FGTMonitorFirewallSession

        Get ALL Firewall Policy session

        .EXAMPLE
        Get-FGTMonitorFirewallSession -policyid 23

        Get Firewall Policy monitor with id 23

        .EXAMPLE
        Get-FGTMonitorFirewallSession -vdom vdomX

        Get Firewall Policy monitor of vdomX

    #>

    Param(
        [Parameter (Mandatory = $false)]
        [switch]$summary,
        [Parameter (Mandatory = $false)]
        [int]$policyid,
        [Parameter (Mandatory = $false)]
        [int]$count = 20,
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

        $uri = "api/v2/monitor/firewall/session?count=${count}"

        if ( $PsBoundParameters.ContainsKey('summary') ) {
            $uri += "&summary=$true"
        }

        if ( $PsBoundParameters.ContainsKey('policyid') ) {
            $uri += "&policyid=$policyid"
        }
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
