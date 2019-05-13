#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemGlobal {

    <#
        .SYNOPSIS
        Get list of System Global Settings

        .DESCRIPTION
        Get list of System Global Settings (hostname, alias....)

        .EXAMPLE
        Get-FGTSystemGlobal

        Get list of all System Global Settings

        .EXAMPLE
        Get-FGTSystemGlobal -skip

        Get list of all System Global Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemGlobal -vdom vdomX

        Get list of all System Global Settings on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/global' -method 'GET' @invokeParams
        $reponse.results
    }

    End {
    }
}