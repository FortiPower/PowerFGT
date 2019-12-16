#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTFirewallServiceGroup {

    <#
        .SYNOPSIS
        Get list of all "services group"

        .DESCRIPTION
        Get list of all "services group"

        .EXAMPLE
        Get-FGTFirewallServiceGroup

        Get list of all services group object

        .EXAMPLE
        Get-FGTFirewallServiceGroup -skip

        Get list of all services group object (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallServiceGroup -vdom vdomX

        Get list of all services group object on vdomX
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall.service/group' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }

}