#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTRouterBGP {

    <#
        .SYNOPSIS
        Get list of all BGP

        .DESCRIPTION
        Get list of all BGP (AS, router-id, neighbor, network...)

        .EXAMPLE
        Get-FGTRouterBGP

        Get list of all route BGP object

        .EXAMPLE
        Get-FGTRouterBGP -meta

        Get list of all route BGP object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTRouterBGP -skip

        Get list of all route BGP object (but only relevant attributes)

        .EXAMPLE
        Get-FGTRouterBGP -vdom vdomX

        Get list of all route BGP object on vdomX
    #>

    [CmdletBinding(DefaultParameterSetName = "default")]
    Param(
        [switch]$meta,
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
        if ( $PsBoundParameters.ContainsKey('meta') ) {
            $invokeParams.add( 'meta', $meta )
        }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/bgp' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
