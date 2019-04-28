#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTPolicy {

    <#
        .SYNOPSIS
        Get list of all policies/rules

        .DESCRIPTION
        Get list of all policies (name, interface source/destination, address (network) source/destination, service, action...)

        .EXAMPLE
        Get-FGTPolicy

        Get list of all policies

    #>

    Begin {
    }

    Process {
        $reponse = Invoke-FGTRestMethod -uri 'api/v2/cmdb/firewall/policy' -method 'GET'
        $reponse.results
    }

    End {
    }
}