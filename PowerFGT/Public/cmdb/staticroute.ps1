#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTStaticroute {

    <#
        .SYNOPSIS
        Get list of all "static routes"

        .DESCRIPTION
        Get list of all "static routes" (destination network, gateway, port, distance, weight...)

        .EXAMPLE
        Get-FGTStaticroute

        Get list of all static route object

        .EXAMPLE
        Get-FGTStaticroute -skip

        Get list of all static route object (but only relevant attributes)
    #>

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add( 'skip', $skip )
        }

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/router/static' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }
}
