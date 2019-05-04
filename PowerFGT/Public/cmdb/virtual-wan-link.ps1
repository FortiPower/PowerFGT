#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTVirtualWANLink {

    <#
        .SYNOPSIS
        Get Virtual Wan Link (SD-WAN) Settings

        .DESCRIPTION
        Get Virtual Wan Link Settings (status, load balance mode, members, health-check... )

        .EXAMPLE
        Get-FGTVirtualWANLink

        Get Virtual Wan Link Settings

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$skip
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/virtual-wan-link' -method 'GET' @invokeParams
        $reponse.results
    }

    End {
    }
}