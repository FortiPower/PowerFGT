#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemHA {

    <#
        .SYNOPSIS
        Get list of HA Settings

        .DESCRIPTION
        Get list of HA Settings (Mode, Group-ID, Group-Name, Password, monitor...)

        .EXAMPLE
        Get-FGTSystemHA

        Get HA Settings

        .EXAMPLE
        Get-FGTSystemHA -skip

        Get HA Settings (but only relevant attributes)

        .EXAMPLE
        Get-FGTSystemHA -vdom vdomX

        Get HA Settings on vdomX
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/ha' -method 'GET' -connection $connection @invokeParams
        $reponse.results
    }

    End {
    }
}