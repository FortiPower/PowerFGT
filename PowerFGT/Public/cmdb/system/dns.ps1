#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
# Copyright 2019, Benjamin Perrier <ben dot perrier at outlook dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-FGTSystemDns {

    <#
        .SYNOPSIS
        Get DNS addresses configured

        .DESCRIPTION
        Show DNS addresses configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDns

        Display DNS configured on the FortiGate

        .EXAMPLE
        Get-FGTSystemDns -skip

        Display DNS configured on the FortiGate (but only relevant attributes)

        EXAMPLE
        Get-FGTSystemDns -vdom vdomX

        Display DNS configured on the FortiGate on vdomX
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection=$DefaultFGTConnection
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

        $response = Invoke-FGTRestMethod -uri 'api/v2/cmdb/system/dns' -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}