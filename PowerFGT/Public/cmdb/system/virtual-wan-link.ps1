#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemVirtualWANLink {

    <#
        .SYNOPSIS
        Get Virtual Wan Link (SD-WAN) Settings

        .DESCRIPTION
        Get Virtual Wan Link Settings (status, load balance mode, members, health-check... )

        .EXAMPLE
        Get-FGTSystemVirtualWANLink

        Get Virtual Wan Link Settings

        .EXAMPLE
        Get-FGTSystemVirtualWANLink -skip

        Get Virtual Wan Link Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemVirtualWANLink -vdom vdomX

        Get Virtual Wan Link Settings on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/virtual-wan-link' -method 'GET' @invokeParams
        $reponse.results
    }

    End {
    }
}