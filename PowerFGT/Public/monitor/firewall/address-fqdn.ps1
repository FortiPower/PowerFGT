#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorFirewallAddressFQDN {

    <#
        .SYNOPSIS
        Get Monitor Firewall Address FQDN

        .DESCRIPTION
        Get Monitor Firewall Adresss FQDN (fqdn, addrs, addrs_count...)

        .EXAMPLE
        Get-FGTMonitorFirewallAddressFQDN

        Get ALL Firewall Address FQDN

        .EXAMPLE
        Get-FGTMonitorFirewallAddressFQDN -fqdn github.com

        Get Firewall Address FQDN of github.com

        .EXAMPLE
        Get-FGTMonitorFirewallAddressFQDN -vdom vdomX

        Get Firewall Address FQDN of vdomX

    #>

    Param(
        [Parameter (Mandatory = $false, Position = 1)]
        [string]$fqdn,
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

        $uri = 'api/v2/monitor/firewall/address-fqdns?'

        if ($fqdn) {
            $uri += "mkey=$($fqdn)"
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
