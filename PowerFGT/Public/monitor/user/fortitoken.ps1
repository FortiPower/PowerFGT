#
# Copyright 2024, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorUserFortitoken {

    <#
        .SYNOPSIS
        Get User Fortitoken

        .DESCRIPTION
        Get User FortiToken ( description, type, license, status... )

        .EXAMPLE
        Get-FGTMonitorUserFortitoken

        Get User Fortitoken information

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $invokeParams = @{ }
        if ( $PsBoundParameters.ContainsKey('vdom') ) {
            $invokeParams.add( 'vdom', $vdom )
        }

        $uri = 'api/v2/monitor/user/fortitoken'

        $response = Invoke-FGTRestMethod -uri $uri -method "GET" -body $body -connection $connection @invokeParams
        $response.results

    }

    End {
    }
}
