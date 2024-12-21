#
# Copyright 2024, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorSystemDHCP {

    <#
        .SYNOPSIS
        Get System DHCP

        .DESCRIPTION
        Get System DHCP (status, ip, expire_time, interface, mac...)

        .EXAMPLE
        Get-FGTMonitorSystemDHCP

        Get System DHCP

        .EXAMPLE
        Get-FGTMonitorSystemDHCP -interface port1

        Get System DHCP with interface port1


        .EXAMPLE
        Get-FGTMonitorSystemDHCP -scope vdom

        Get System DHCP from scope vdom
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [string]$interface,
        [Parameter(Mandatory = $false)]
        [ValidateSet('vdom', 'global')]
        [string]$scope,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v2/monitor/system/dhcp?'
        if ($interface) {
            $uri += "&interface=$($interface)"
        }
        if ($scope) {
            $uri += "&scope=$($scope)"
        }

        $response = Invoke-FGTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
