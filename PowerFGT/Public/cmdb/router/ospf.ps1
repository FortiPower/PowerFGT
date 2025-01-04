#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTRouterOSPF {

    <#
        .SYNOPSIS
        Get list of all OSPF

        .DESCRIPTION
        Get list of all OSPF (area, router-id, neighbor, network...)

        .EXAMPLE
        Get-FGTRouterOSPF

        Get list of all route OSPF object

        .EXAMPLE
        Get-FGTRouterOSPF -meta

        Get list of all route OSPF object with metadata (q_...) like usage (q_ref)

        .EXAMPLE
        Get-FGTRouterOSPF -skip

        Get list of all route OSPF object (but only relevant attributes)

        .EXAMPLE
        Get-FGTRouterOSPF -vdom vdomX

        Get list of all route OSPF object on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/ospf' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
