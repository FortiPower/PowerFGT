#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTHA {

    <#
        .SYNOPSIS
        Get list of HA Settings

        .DESCRIPTION
        Get list of HA Settings (Mode, Group-ID, Group-Name, Password, monitor...)

        .EXAMPLE
        Get-FGTHA

        Get HA Settings

        .EXAMPLE
        Get-FGTHA -skip

        Get HA Settings (but only relevant attributes)
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

        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/ha' -method 'GET' @invokeParams
        $reponse.results
    }

    End {
    }
}