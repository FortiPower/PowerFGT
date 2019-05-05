#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTRouterPolicy {

    <#
        .SYNOPSIS
        Get list of all "route policy"

        .DESCRIPTION
        Get list of all "route policy" (Source, Destination, Protocol, Action...)

        .EXAMPLE
        Get-FGTRouterPolicy

        Get list of all route policy object

        .EXAMPLE
        Get-FGTRouterPolicy -skip

        Get list of all route policy object (but only relevant attributes)

        .EXAMPLE
        Get-FGTRouterPolicy -vdom vdomX

        Get list of all route policy object on vdomX
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/policy' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }
}
