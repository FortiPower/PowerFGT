#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorLicenseStatus {

    <#
        .SYNOPSIS
        Get License Status

        .DESCRIPTION
        Get License Status (Fortiguard, forticare....)

        .EXAMPLE
        Get-FGTMonitorLicenseStatus

        Get License Status with status, version and last_update

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v2/monitor/monitor/license/status'
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection @invokeParams
        $response.results
    }

    End {
    }
}
