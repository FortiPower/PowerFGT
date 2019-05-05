#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTFirewallAddressgroup {

    <#
        .SYNOPSIS
        Get addresses group configured

        .DESCRIPTION
        Show addresses group configured (Name, Member...)

        .EXAMPLE
        Get-FGTFirewallAddressgroup

        Display all addresses group.

        .EXAMPLE
        Get-FGTFirewallAddressgroup -skip

        Display all addresses group (but only relevant attributes)

        .EXAMPLE
        Get-FGTFirewallAddressgroup -vdom vdomX

        Display all addresses group on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/addrgrp' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }
}