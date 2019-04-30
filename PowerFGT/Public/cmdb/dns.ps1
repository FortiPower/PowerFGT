#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTDns {

    <#
        .SYNOPSIS
        Get DNS addresses configured

        .DESCRIPTION
        Show DNS addresses configured on the FortiGate

        .EXAMPLE
        Get-FGTDns

        Display DNS configured on the FortiGate

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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/dns' -method 'GET' @invokeParams
        $response.results
    }

    End {
    }
}