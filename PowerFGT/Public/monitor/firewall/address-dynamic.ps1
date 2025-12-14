#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorFirewallAddressDynamic {

    <#
        .SYNOPSIS
        Get Monitor Firewall Address Dynamic

        .DESCRIPTION
        Get Monitor Firewall Adresss Dynamic (addr, subtype...)

        .EXAMPLE
        Get-FGTMonitorFirewallAddressDynamic

        Get ALL Firewall Address Dynamic

        .EXAMPLE
        Get-FGTMonitorFirewallAddressDynamic -dynamic mySDN

        Get Firewall Address Dynamic of mySDN

        .EXAMPLE
        Get-FGTMonitorFirewallAddressDynamic -vdom vdomX

        Get Firewall Address Dynamic of vdomX

    #>

    Param(
        [Parameter (Mandatory = $false, Position = 1)]
        [string]$dynamic,
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

        $uri = 'api/v2/monitor/firewall/address-dynamic?'

        if ($dynamic) {
            $uri += "mkey=$($dynamic)"
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
