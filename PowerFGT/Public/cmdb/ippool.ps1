#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTIppool {

    <#
        .SYNOPSIS
        Get list of all (NAT) ip pool"

        .DESCRIPTION
        Get list of all (nat) ip pool"

        .EXAMPLE
        Get-FGTIppool

        Get list of all (NAT) ip pool object

        .EXAMPLE
        Get-FGTIppool -skip

        Get list of all (NAT) ip pool object (but only relevant attributes)
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/ippool' -method 'GET' @invokeParams
        $response.results

    }

    End {
    }
}