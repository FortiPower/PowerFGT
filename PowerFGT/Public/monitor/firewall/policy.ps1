#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorFirewallPolicy {

    <#
        .SYNOPSIS
        Get Monitor Firewall Policy

        .DESCRIPTION
        Get Monitor Firewall Policy (policyid, bytes, packets, hit_count...)

        .EXAMPLE
        Get-FGTMonitorFirewallPolicy

        Get ALL Firewall Policy monitor

        .EXAMPLE
        Get-FGTMonitorFirewallPolicy -policyid 23

        Get Firewall Policy monitor with id 23

        .EXAMPLE
        Get-FGTMonitorFirewallPolicy -vdom vdomX

        Get Firewall Policy monitor of vdomX

    #>

    Param(
        [Parameter (Mandatory = $false)]
        [int]$policyid,
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

        $uri = 'api/v2/monitor/firewall/policy?'

        if ( $PsBoundParameters.ContainsKey('policyid') ) {
            $uri += "&policyid=$policyid"
        }
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
