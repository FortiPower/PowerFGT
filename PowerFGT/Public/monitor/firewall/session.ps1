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

        Get ALL Firewall Policy session (by default 20 first session)

        .EXAMPLE
        Get-FGTMonitorFirewallSession -count 1000

        Get 1000 Firewall Session monitor

        .EXAMPLE
        Get-FGTMonitorFirewallSession -policyid 23

        Get Firewall Session monitor with id 23

        .EXAMPLE
        Get-FGTMonitorFirewallSession -vdom vdomX

        Get Firewall Session monitor of vdomX

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

        $c = $count
        if ($count -gt 1000) {
            $count = 1000
        }

        $uri = "api/v2/monitor/firewall/session?count=${count}"

        if ( $PsBoundParameters.ContainsKey('summary') ) {
            $uri += "&summary=$true"
        }
        if ( $PsBoundParameters.ContainsKey('policyid') ) {
            $uri += "&policyid=$policyid"
        }

        $results = @()
        $i = 0
        while ($i -lt $c) {
            $uri2 = $uri + "&start=$($i)"
            $response = Invoke-FGTRestMethod -uri $uri2 -method 'GET' -connection $connection @invokeParams

            $i += 1024
            $results += $response.results.details
        }
        $output = new-Object -TypeName PSObject
        if ( $PsBoundParameters.ContainsKey('summary') ) {
            $output | add-member -name "summary" -membertype NoteProperty -Value $response.summary
        }
        $output | add-member -name "details" -membertype NoteProperty -Value $results
        $output
    }

    End {
    }
}
