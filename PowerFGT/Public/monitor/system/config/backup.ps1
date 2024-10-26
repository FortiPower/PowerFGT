#
# Copyright 2022, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
function Get-FGTMonitorSystemConfigBackup {

    <#
        .SYNOPSIS
        Get System Config Backup

        .DESCRIPTION
        Get System Config Backup

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup

        Get System Config Backup

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup -skip

        Get System Config Backup (but only relevant attributes)

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup -vdom vdomX

        Get System Config Backup on vdomX

        .EXAMPLE
        Get-FGTMonitorSystemConfigBackup -scope global -vdom vdomX

        Get System Config Backup in global scope even if vdom is specified
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$skip,
        [Parameter(Mandatory = $false)]
        [String[]]$vdom,
        [Parameter(Mandatory = $false)]
        [ValidateSet("global", "vdom")]
        [string]$scope = "global",  # Scope parameter with default "global"
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultFGTConnection
    )

    Begin {
    }

    Process {
        $invokeParams = @{ }

        if ( $PsBoundParameters.ContainsKey('skip') ) {
            $invokeParams.add('skip', $skip)
        }

        # Add vdom to invokeParams if provided
        if ($PsBoundParameters.ContainsKey('vdom')) {
            $invokeParams.add('vdom', $vdom)

            # Only change scope to "vdom" if vdom is provided and scope was not explicitly set to "global"
            if (-not $PsBoundParameters.ContainsKey('scope') -or $scope -eq "vdom") {
                $scope = "vdom"
            }
        }

        # Prepare URI and request method based on connection version
        if ($connection.version -lt "7.6.0") {
            $method = "get"
            $uri = "api/v2/monitor/system/config/backup?scope=$scope"
            $body = ""
        }
        else {
            $method = "post"
            $uri = 'api/v2/monitor/system/config/backup'
            $body = @{
                "scope" = "$scope"
            }
        }

        $response = Invoke-FGTRestMethod -uri $uri -method $method -body $body -connection $connection @invokeParams
        $response
    }

    End {
    }
}
