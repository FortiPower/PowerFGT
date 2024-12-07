#
# Copyright 2024, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorSystemInterface {

    <#
        .SYNOPSIS
        Get System Interface

        .DESCRIPTION
        Get System Interface (status, alias, speed, tx/rx packets/bytes...)

        .EXAMPLE
        Get-FGTMonitorSystemInterface

        Get System Interface

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v2/monitor/system/interface'

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
