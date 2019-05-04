#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTService {

    <#
        .SYNOPSIS
        Get list of all "services"

        .DESCRIPTION
        Get list of all "services" (SMTP, HTTP, HTTPS, DNS...)

        .EXAMPLE
        Get-FGTService

        Get list of all services object

        .EXAMPLE
        Get-FGTService -skip

        Get list of all services object (but only relevant attributes)

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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall.service/custom' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }
}