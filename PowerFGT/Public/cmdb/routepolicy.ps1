#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTRoutepolicy {

    <#
        .SYNOPSIS
        Get list of all "route policy"

        .DESCRIPTION
        Get list of all "route policy" (Source, Destination, Protocol, Action...)

        .EXAMPLE
        Get-FGTRoutepolicy

        Get list of all route policy object

        .EXAMPLE
        Get-FGTRoutepolicy -skip

        Get list of all route policy object (but only relevant attributes)
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/policy' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }
}
