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
    #>

    Begin {
    }

    Process {
        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/ippool' -method 'GET'
        $response.results

    }

    End {
    }
}