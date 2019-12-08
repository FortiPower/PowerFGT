#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTFirewallIPPool {

    <#
        .SYNOPSIS
        Get list of all (NAT) ip pool"

        .DESCRIPTION
        Get list of all (nat) ip pool"

        .EXAMPLE
        Get-FGTFirewallIPPool

        Get list of all (NAT) ip pool object

        .EXAMPLE
        Get-FGTFirewallIPPool -skip

        Get list of all (NAT) ip pool object (but only relevant attributes)

       .EXAMPLE
        Get-FGTFirewallIPPool -vdom vdomX

        Get list of all (NAT) ip pool object on vdomX
    #>

    Param(
        [Parameter(Mandatory = $false)]
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/ippool' -method 'GET' -connection $connection @invokeParams
        $response.results

    }

    End {
    }
}