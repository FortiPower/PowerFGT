#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTFirewallServiceCustom {

    <#
        .SYNOPSIS
        Get list of all "services"

        .DESCRIPTION
        Get list of all "services" (SMTP, HTTP, HTTPS, DNS...)

        .EXAMPLE
        Get-FGTFirewallServiceCustom

        Get list of all services object

        .EXAMPLE
        Get-FGTFirewallServiceCustom -skip

        Get list of all services object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallServiceCustom -vdom vdomX

        Get list of all services object on vdomX

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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall.service/custom' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}