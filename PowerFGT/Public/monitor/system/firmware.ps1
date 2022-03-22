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
        Get System Firmware (and upgrade paths)

        .EXAMPLE
        Get-FGTMonitorSystemFirmware

        Get System Firmware (current and available)

        .EXAMPLE
        Get-FGTMonitorSystemFirmware -upgrade_paths

        Get System Firmware Upgrade Paths (need to have FortiGuard)
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$upgrade_paths,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v2/monitor/system/firmware'
        if ($upgrade_paths) {
            $uri += "/upgrade_paths"
        }
        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
