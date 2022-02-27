#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorSystemFirmware {

    <#
        .SYNOPSIS
        Get System Firmware

        .DESCRIPTION
        Get System Firmware

        .EXAMPLE
        Get-FGTMonitorSystemFirmware

        Get System Firmware (current and available)

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v2/monitor/system/firmware'
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
