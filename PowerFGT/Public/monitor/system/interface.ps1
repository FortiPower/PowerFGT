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

        .EXAMPLE
        Get-FGTMonitorSystemInterface -include_vlan

        Get System Interface with vlan information

        .EXAMPLE
        Get-FGTMonitorSystemInterface -include_aggregate

        Get System Interface with aggregate interface information
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$include_vlan,
        [Parameter(Mandatory = $false)]
        [switch]$include_aggregate,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v2/monitor/system/interface?'
        if ($include_vlan) {
            $uri += "&include_vlan=true"
        }
        if ($include_aggregate) {
            $uri += "&include_aggregate=true"
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
